SELECT * 
FROM [dbo].[road_accident]

-- CY Casualties --
SELECT SUM(number_of_casualties) AS CY_Casualties
FROM road_accident
WHERE YEAR(accident_date) = '2022'


-- CY Accidents --
SELECT COUNT(distinct accident_index) AS CY_Accidents
FROM road_accident
WHERE YEAR(accident_date) = '2022'


-- Fatal_Casualties --
SELECT SUM(number_of_casualties) AS CY_Fatal_Casualties
FROM road_accident
WHERE YEAR(accident_date) = '2022' AND accident_severity = 'Fatal'


-- CY_Serious_Casualties --
SELECT SUM(number_of_casualties) AS CY_Serious_Casualties
FROM road_accident
WHERE YEAR(accident_date) = '2022' AND accident_severity = 'Serious'


-- CY_Slight_Casualties --
SELECT SUM(number_of_casualties) AS CY_Slight_Casualties
FROM road_accident
WHERE YEAR(accident_date) = '2022' AND accident_severity = 'Slight'


-- Percentage Total Accidents by Slight --
SELECT CAST(SUM(number_of_casualties) as float) / (SELECT CAST(SUM(number_of_casualties) AS float) from road_accident) * 100 
FROM road_accident
WHERE accident_severity = 'Slight'


-- Percentage Total Accidents by Serious --
SELECT CAST(SUM(number_of_casualties) as float) / (SELECT CAST(SUM(number_of_casualties) AS float) from road_accident) * 100 
FROM road_accident
WHERE accident_severity = 'Serious'


-- Percentage Total Accidents by Fatal --
SELECT CAST(SUM(number_of_casualties) as float) / (SELECT CAST(SUM(number_of_casualties) AS float) from road_accident) * 100 
FROM road_accident
WHERE accident_severity = 'Fatal'


-- Secondary KPI --
SELECT 
	CASE
		WHEN vehicle_type IN ('Agricultural vehicle') THEN 'Agricultural'
		WHEN vehicle_type IN ('Car', 'Taxi/Private hire car') THEN 'Car'
		WHEN vehicle_type IN ('Motorcycle 125cc and under', 'Motorcycle 50cc and under', 'Motorcycle over 125cc and up to 500cc', 'Motorcycle over 500cc', 'Pedal cycle') THEN 'Bike'
		WHEN vehicle_type IN ('Bus or coach (17 or more pass seats)', 'Minibus (8 - 16 passenger seats)') THEN 'Bus'
		WHEN vehicle_type IN ('Goods 7.5 tonnes mgw and over', 'Goods over 3.5t. and under 7.5t', 'Van / Goods 3.5 tonnes mgw or under') THEN 'Van'
		ELSE 'Other'
	END AS vehicle_group,
	SUM(number_of_casualties) as CY_Casualties
FROM road_accident
WHERE YEAR(accident_date) = '2022'
GROUP BY 
	CASE
		WHEN vehicle_type IN ('Agricultural vehicle') THEN 'Agricultural'
		WHEN vehicle_type IN ('Car', 'Taxi/Private hire car') THEN 'Car'
		WHEN vehicle_type IN ('Motorcycle 125cc and under', 'Motorcycle 50cc and under', 'Motorcycle over 125cc and up to 500cc', 'Motorcycle over 500cc', 'Pedal cycle') THEN 'Bike'
		WHEN vehicle_type IN ('Bus or coach (17 or more pass seats)', 'Minibus (8 - 16 passenger seats)') THEN 'Bus'
		WHEN vehicle_type IN ('Goods 7.5 tonnes mgw and over', 'Goods over 3.5t. and under 7.5t', 'Van / Goods 3.5 tonnes mgw or under') THEN 'Van'
		ELSE 'Other'
    END 


-- CY Casualties VS PY Casualties --
SELECT DATENAME(MONTH, accident_date) Month_name, SUM(number_of_casualties) CY_Casualties
FROM road_accident
WHERE YEAR(accident_date) = '2022'
GROUP BY DATENAME(MONTH, accident_date)

SELECT DATENAME(MONTH, accident_date) Month_name, SUM(number_of_casualties) PY_Casualties
FROM road_accident
WHERE YEAR(accident_date) = '2021'
GROUP BY DATENAME(MONTH, accident_date)


-- Road Type --
SELECT road_type, SUM(number_of_casualties) CY_Casualties
FROM road_accident
WHERE YEAR(accident_date) = '2022'
GROUP BY road_type


-- Casualties Urban or Rural Area --
SELECT urban_or_rural_area, SUM(number_of_casualties), SUM(number_of_casualties) * 100 / (SELECT SUM(number_of_casualties) FROM road_accident WHERE YEAR(accident_date) = '2022')
FROM road_accident
WHERE YEAR(accident_date) = '2022'
GROUP BY urban_or_rural_area

SELECT urban_or_rural_area, SUM(number_of_casualties), SUM(number_of_casualties) * 100 / (SELECT SUM(number_of_casualties) FROM road_accident)
FROM road_accident
--WHERE YEAR(accident_date) = '2022'
GROUP BY urban_or_rural_area

--  --
SELECT 
	CASE
		WHEN light_conditions IN ('Daylight') THEN 'Day'
		WHEN light_conditions IN ('Darkness - lighting unknown', 'Darkness - lights lit', 'Darkness - lights unlit', 'Darkness - no lighting') THEN 'Night'
	END AS Ligt_Condition,
	CAST(CAST(SUM(number_of_casualties) as decimal(10,2)) * 100 / 
	(SELECT CAST(SUM(number_of_casualties) AS decimal(10,2)) FROM road_accident WHERE YEAR(accident_date) = '2022') AS decimal(10,2)) AS CY_Casualties_PCT 
FROM road_accident
WHERE YEAR(accident_date) = '2022'
GROUP BY 
		CASE
		WHEN light_conditions IN ('Daylight') THEN 'Day'
		WHEN light_conditions IN ('Darkness - lighting unknown', 'Darkness - lights lit', 'Darkness - lights unlit', 'Darkness - no lighting') THEN 'Night'
	END 


--  --
SELECT TOP 10 local_authority, SUM(number_of_casualties) as Total_Casualties
FROM road_accident
GROUP BY local_authority
ORDER BY Total_Casualties DESC