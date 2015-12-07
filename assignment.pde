
import controlP5.*;
ControlP5 controlP5;

ArrayList<controlP5.Button> buttons = new ArrayList<controlP5.Button>();
DropdownList ddl;
PFont btnfont = createFont("Arial", 20, false); // use true/false for smooth/no-smooth
ControlFont btnFont = new ControlFont(btnfont, 241);
PFont headfont = createFont("Times", 15, false); // use true/false for smooth/no-smooth
ControlFont headFont = new ControlFont(headfont, 241);

ArrayList<PLTable> alltime = new ArrayList<PLTable>();
ArrayList<PLTable> last10yrs = new ArrayList<PLTable>();
ArrayList<Points> points = new ArrayList<Points>();
ArrayList<Goals> goals = new ArrayList<Goals>();
ArrayList<TopGS> scorer = new ArrayList<TopGS>();
ArrayList<MostGlsInGame> scorerGame = new ArrayList<MostGlsInGame>();
ArrayList<MostValuableXI> player = new ArrayList<MostValuableXI>();

String[] allTimeColNames = {
  "P Total Matches Played", 
  "W Wins (Home)", "L Losses (Home)", "D Draws (Home)", "GF Goals For (Home)", "GA Goals For (Home)", 
  "W Wins (Away)", "L Losses (Away)", "D Draws (Away)", "GF Goals For (Away)", "GA Goals For (Away)", 
  "F Total Goals For", "A Total Goals Against", 
  "GD All Time Goal Difference", "Pts All Time Points"
};

float border;
float widthRange;
float heightRange;

void setup() 
{
  size(1200, 600);
  border = 40;
  widthRange = (float)width - (border*2);
  heightRange = (float)height - (border*2);

  loadData();
  mainMenu();
}

void loadData()
{
  String[] data = loadStrings("PLAllTime.csv");

  for (int i = 0; i < data.length; i++)
  {
    PLTable row = new PLTable(data[i]);
    alltime.add(row);
  }


  data = loadStrings("PLAllTimeAvgPts.csv");

  for (int i = 0; i < data.length; i++)
  {
    Points row = new Points(data[i]);
    points.add(row);
  }

  data = loadStrings("PLAllTimeAvgGls.csv");

  for (int i = 0; i < data.length; i++)
  {
    Goals row = new Goals(data[i]);
    goals.add(row);
  }

  data = loadStrings("TopGS.csv");

  for (int i = 0; i < data.length; i++)
  {
    TopGS row = new TopGS(data[i]);
    scorer.add(row);
  }

  data = loadStrings("MostGoalsInGame.csv");

  for (int i = 0; i < data.length; i++)
  {
    MostGlsInGame row = new MostGlsInGame(data[i]);
    scorerGame.add(row);
  }

  data = loadStrings("MostValuableXI.csv");

  for (int i = 0; i < data.length; i++)
  {
    MostValuableXI row = new MostValuableXI(data[i], i);
    player.add(row);
  }
}

PLTable st = new PLTable();
PLTable bcd = new PLTable();
PLTable tpts = new PLTable();
PLTable agls = new PLTable();
PLTable apts = new PLTable();
PLTable tgls = new PLTable();

void draw() 
{
  background(0);

  hideButton();

  switch (mode)
  {
  case 101:
    {
      st.showTable(alltime);
      break;
    }
  case 102:
    {

      bcd.TeamBarChartDisplay(team);
      break;
    }
  case 103:
    {
      agls.TeamAllGoals(team);
      break;
    }
  case 104:
    {
      apts.TeamAllPoints(team);
      break;
    }
  case 105:
    {
      tgls.GoalGraph(team);
      break;
    }
  case 106:
    {
      tpts.PointGraph(team);
      break;
    }
  case 107:
    {
      TopGS tgs = new TopGS();
      tgs.showTopScorers();
      break;
    }
  case 108:
    {
      MostGlsInGame mgg = new MostGlsInGame();
      mgg.showMostGlsInGame();
      break;
    }
  case 109:
    {
      MostValuableXI mvxi = new MostValuableXI();
      mvxi.drawPitch();
      int[] formation = {
        1, 4, 2, 3, 1
      };
      for (int i = 0; i < formation.length; i++)
      {
        mvxi.drawXI(formation[i], formation.length, i);
      }
      break;
    }
  default:
    {
      fill(255);
      stroke(255);
      textSize(15);
      text("Stats correct up to the end of the 2014/2015 season.", ((float)widthRange * 0.15f), border/2);
    }
    break;
  }
}


int mode = 100;
int team;
int mainBtns;

//Control P5 menu code
void mainMenu()
{
  controlP5 = new ControlP5(this);

  String[] mainMsg = {
    "Return To Main Menu", "All Time BPL Table", "Your Team", 
    "All Teams: Goals", "All Teams: Points", "By Team: Goals", 
    "By Team: Points", "Top Goal Scorers", "Most Goals/Game", 
    "Most Valuable XI"
  }; 

  mainBtns = mainMsg.length;
  int padding = 150;
  int w = (int)textWidth(mainMsg[0]);
  int h = 35;
  buttons.add( controlP5.addButton(mainMsg[0], 100, 0, 0, w, h) );
  //  buttons.get(0).getCaptionLabel().setFont(headfont);

  for (int i = 1; i < mainMsg.length; i++)
  {
    w = (int)textWidth(mainMsg[i]) + padding;
    h = 30;
    int x = ( (int)widthRange / 2 ) - (w/2);
    int y = ( (int)heightRange / mainMsg.length) * i;
    buttons.add( controlP5.addButton(mainMsg[i], i + 100, x, y, w, h) );
    buttons.get(i).getCaptionLabel().setFont(btnfont);
    //    buttons.get(i).captionLabel().getStyle().marginTop = 36;
  }

  int ddlX = (int)(width * 0.7);
  int ddlY = 0;
  int ddlW = 300;
  int ddlH = 120;

  ddl = controlP5.addDropdownList("Select Team", ddlX, ddlY, ddlW, ddlH);
  ddl.close();
  ddl.getCaptionLabel().getStyle().marginTop = 6;
  //  ddl.getCaptionLabel().getStyle().marginLeft = 60;

  customize(ddl);
}

void customize(DropdownList ddl)
{
  ddl.setBackgroundColor(color(190));
  ddl.setItemHeight(30);
  ddl.setBarHeight(30);

  //  ddl.getCaptionLabel().getStyle().marginTop = 3;
  //ddl.getCaptionLabel().getStyle().marginLeft = 60;

  for (int i = 0; i < alltime.size (); i++)
  {
    ddl.addItem(alltime.get(i).clubName, i ); // give each item a value, in this example starting from zero
    ddl.getCaptionLabel().setFont(btnfont);
  }
  ddl.setColorBackground(color(60));
  ddl.setColorActive(color(255, 128));
}

void controlEvent(ControlEvent theEvent)
{
  if ((int)theEvent.getValue() > 99)
    mode = (int)theEvent.getValue();
  else
    team = (int)theEvent.getValue();
  println(theEvent.getValue());
}

void hideButton() 
{

  if (mode == 100) 
  {
    for (int i = 1; i < buttons.size (); i++)
    {
      if (i < mainBtns)
      {
        buttons.get(i).show();
      }//end if
      else
      {
        buttons.get(i).hide();
      }//end else
    }//end for
  }//end if
  else 
  {
    for (int i = 1; i < buttons.size (); i++)
    {

      if (i < mainBtns)
      {
        buttons.get(i).hide();
      }//end if
    }//end for
  }//end else
}//end hide button

void keyPressed()
{
  if ( key == ' ' )
  {
    mode = 100;
  }
}

