DROP DATABASE 370_a3_2;

CREATE DATABASE 370_a3_2;

USE 370_a3_2;

Exercise 1.
1. Create simple SQL statements to create the above relations

CREATE TABLE Classes(
	class VARCHAR(50),
	type VARCHAR(50),
	country VARCHAR(50),
	numGuns INT(10),
	bore INT(10),
	displacement INT(10)
);

CREATE TABLE Ships(
	name VARCHAR(50), 
	class VARCHAR(50), 
	launched INT(10)
);

CREATE TABLE Battles(
	name VARCHAR(50), 
	date_fought DATE
);

CREATE TABLE Outcomes(
	ship VARCHAR(50), 
	battle VARCHAR(50), 
	result VARCHAR(50)
);

2. Insert the following data.

INSERT INTO Classes VALUES('Bismarck','bb','Germany',8,15,42000);
INSERT INTO Classes VALUES('Kongo','bc','Japan',8,14,32000);
INSERT INTO Classes VALUES('North Carolina','bb','USA',9,16,37000);
INSERT INTO Classes VALUES('Renown','bc','Gt. Britain',6,15,32000);
INSERT INTO Classes VALUES('Revenge','bb','Gt. Britain',8,15,29000);
INSERT INTO Classes VALUES('Tennessee','bb','USA',12,14,32000);
INSERT INTO Classes VALUES('Yamato','bb','Japan',9,18,65000);

INSERT INTO Ships VALUES('California','Tennessee',1921);
INSERT INTO Ships VALUES('Haruna','Kongo',1915);
INSERT INTO Ships VALUES('Hiei','Kongo',1914);
INSERT INTO Ships VALUES('Iowa','Iowa',1943);
INSERT INTO Ships VALUES('Kirishima','Kongo',1914);
INSERT INTO Ships VALUES('Kongo','Kongo',1913);
INSERT INTO Ships VALUES('Missouri','Iowa',1944);
INSERT INTO Ships VALUES('Musashi','Yamato',1942);
INSERT INTO Ships VALUES('New Jersey','Iowa',1943);
INSERT INTO Ships VALUES('North Carolina','North Carolina',1941);
INSERT INTO Ships VALUES('Ramilles','Revenge',1917);
INSERT INTO Ships VALUES('Renown','Renown',1916);
INSERT INTO Ships VALUES('Repulse','Renown',1916);
INSERT INTO Ships VALUES('Resolution','Revenge',1916);
INSERT INTO Ships VALUES('Revenge','Revenge',1916);
INSERT INTO Ships VALUES('Royal Oak','Revenge',1916);
INSERT INTO Ships VALUES('Royal Sovereign','Revenge',1916);
INSERT INTO Ships VALUES('Tennessee','Tennessee',1920);
INSERT INTO Ships VALUES('Washington','North Carolina',1941);
INSERT INTO Ships VALUES('Wisconsin','Iowa',1944);
INSERT INTO Ships VALUES('Yamato','Yamato',1941);

INSERT INTO Battles VALUES('North Atlantic','27-May-1941');
INSERT INTO Battles VALUES('Guadalcanal','15-Nov-1942');
INSERT INTO Battles VALUES('North Cape','26-Dec-1943');
INSERT INTO Battles VALUES('Surigao Strait','25-Oct-1944');

INSERT INTO Outcomes VALUES('Bismarck','North Atlantic', 'sunk');
INSERT INTO Outcomes VALUES('California','Surigao Strait', 'ok');
INSERT INTO Outcomes VALUES('Duke of York','North Cape', 'ok');
INSERT INTO Outcomes VALUES('Fuso','Surigao Strait', 'sunk');
INSERT INTO Outcomes VALUES('Hood','North Atlantic', 'sunk');
INSERT INTO Outcomes VALUES('King George V','North Atlantic', 'ok');
INSERT INTO Outcomes VALUES('Kirishima','Guadalcanal', 'sunk');
INSERT INTO Outcomes VALUES('Prince of Wales','North Atlantic', 'damaged');
INSERT INTO Outcomes VALUES('Rodney','North Atlantic', 'ok');
INSERT INTO Outcomes VALUES('Scharnhorst','North Cape', 'sunk');
INSERT INTO Outcomes VALUES('South Dakota','Guadalcanal', 'ok');
INSERT INTO Outcomes VALUES('West Virginia','Surigao Strait', 'ok');
INSERT INTO Outcomes VALUES('Yamashiro','Surigao Strait', 'sunk');

Exercise 2.
1. List the name, displacement, and number of guns of the ships engaged in the battle of Guadalcanal.

SELECT name, displacement, numguns
FROM classes, ships, outcomes
WHERE classes.class = ships.class AND 
ships.name = outcomes.ship AND 
battle='Guadalcanal';

2. Find the names of the ships whose number of guns was the largest for those ships of the same bore.

SELECT Ships.name
FROM Ships, Classes
WHERE Classes.Class = Classes.Class
AND numGuns >= ALL (SELECT numGuns
FROM Classes
WHERE Classes.bore = Classes.bore);

3. Find for each class with at least three ships the number of ships of that class sunk in battle.

SELECT n.class, COUNT(result) 
FROM
(SELECT class, name
FROM Ships
WHERE class IN (
SELECT class FROM Ships
GROUP BY class
HAVING COUNT(*) >= 3)
) n
LEFT JOIN
(SELECT ship, result
FROM Outcomes
WHERE result = ’sunk’) S ON n.name = s.ship
GROUP BY n.class;

Exercise 3.
1. Two of the three battleships of the Italian Vittorio Veneto class â€“
Vittorio Veneto and Italia â€“ were launched in 1940;
the third ship of that class, Roma, was launched in 1942.
Each had 15-inch guns and a displacement of 41,000 tons.

INSERT INTO Classes VALUES ('Vittorio Veneto', 'bb', 'Italy', 15, 41000);
INSERT INTO Ships VALUES ('Vittorio Veneto', 'Vittorio Veneto', 1940);
INSERT INTO Ships VALUES ('Italia', 'Vittorio Veneto', 1940);
INSERT INTO Ships VALUES ('Roma', 'Vittorio Veneto', 1942);

2. Delete all classes with fewer than three ships.

DELETE FROM Classes 
WHERE class 
IN (SELECT class 
FROM Classes 
NATURAL LEFT OUTER JOIN Ships
GROUP BY class
HAVING COUNT(name)<3);

3. Modify the Classes relation so that gun bores are measured in centimeters
(one inch = 2.5 cm) and displacements are measured in metric tons (one metric ton = 1.1 ton).

UPDATE Classes SET bore = bore*2.5, 
displacement = displacement/1.1;

Exercise 4.
1. No ship can be in battle before it is launched.

CREATE VIEW OutcomesView AS
SELECT
       o.ship,
       o.battle,
       o.result
   FROM
       Outcomes o
       INNER JOIN Battles b ON o.battle=b.name
       INNER JOIN Ships s on s.name=o.ship
   WHERE
       b.date_fought >= s.launched;

2. No ship can be launched before.

CREATE VIEW ShipsV AS
SELECT
       s1.name,
       s1.class,
       s1.launched
   FROM
       Ships s1
       INNER JOIN Ships s2 on s1.name=s2.class
   WHERE
       s1.launched>=s2.launched

3. No ship fought in a battle that was at a later date than another battle in which that ship was sunk.

CREATE VIEW OutcomesV AS
SELECT
o.ship,
o.battle,
o.result
FROM
Outcomes o
INNER JOIN Battles b ON o.battle=b.name
INNER JOIN Ships s on s.name=o.ship
WHERE
b.date_fought >= s.launched;
