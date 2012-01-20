Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118Ab2ATHij (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 02:38:39 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42587 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743Ab2ATHig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 02:38:36 -0500
Message-ID: <1327045098.29773.0.camel@phoenix>
Subject: [PATCH 1/2] hwmon: convert drivers/hwmon/* to use
 module_i2c_driver()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Corentin Labbe <corentin.labbe@geomatys.fr>,
        Dirk Eibach <eibach@gdsys.de>,
        "Mark M. Hoffman" <mhoffman@lightlink.com>,
        Steve Glendinning <steve.glendinning@smsc.com>,
        Riku Voipio <riku.voipio@iki.fi>,
        Guillaume Ligneul <guillaume.ligneul@gmail.com>,
        David George <david.george@ska.ac.za>,
        "Hans J. Koch" <hjk@hansjkoch.de>, Marc Hulsman <m.hulsman@tudelft.nl>,
        Rudolf Marek <r.marek@assembler.cz>, lm-sensors@lm-sensors.org
Date: Fri, 20 Jan 2012 15:38:18 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the drivers in drivers/hwmon/* to use the
module_i2c_driver() macro which makes the code smaller and a bit simpler.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Corentin Labbe <corentin.labbe@geomatys.fr>
Cc: Dirk Eibach <eibach@gdsys.de>
Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>
Cc: Steve Glendinning <steve.glendinning@smsc.com>
Cc: Riku Voipio <riku.voipio@iki.fi>
Cc: Guillaume Ligneul <guillaume.ligneul@gmail.com>
Cc: David George <david.george@ska.ac.za>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>
Cc: Marc Hulsman <m.hulsman@tudelft.nl>
Cc: Rudolf Marek <r.marek@assembler.cz>
---
 drivers/hwmon/ad7414.c         |   12 +-----------
 drivers/hwmon/ad7418.c         |   13 +------------
 drivers/hwmon/adm1021.c        |   13 +------------
 drivers/hwmon/adm1025.c        |   13 +------------
 drivers/hwmon/adm1026.c        |   13 +------------
 drivers/hwmon/adm1029.c        |   18 +-----------------
 drivers/hwmon/adm1031.c        |   13 +------------
 drivers/hwmon/adm9240.c        |   14 +-------------
 drivers/hwmon/ads1015.c        |   13 +------------
 drivers/hwmon/adt7411.c        |   12 +-----------
 drivers/hwmon/adt7462.c        |   13 +------------
 drivers/hwmon/adt7470.c        |   13 +------------
 drivers/hwmon/adt7475.c        |   13 +------------
 drivers/hwmon/amc6821.c        |   15 +--------------
 drivers/hwmon/asb100.c         |   13 +------------
 drivers/hwmon/atxp1.c          |   13 +------------
 drivers/hwmon/ds1621.c         |   14 +-------------
 drivers/hwmon/ds620.c          |   13 +------------
 drivers/hwmon/emc1403.c        |   13 +------------
 drivers/hwmon/emc2103.c        |   13 +------------
 drivers/hwmon/emc6w201.c       |   12 +-----------
 drivers/hwmon/f75375s.c        |   13 +------------
 drivers/hwmon/fschmd.c         |   13 +------------
 drivers/hwmon/g760a.c          |   15 +--------------
 drivers/hwmon/gl518sm.c        |   13 +------------
 drivers/hwmon/gl520sm.c        |   15 +--------------
 drivers/hwmon/jc42.c           |   13 +------------
 drivers/hwmon/lineage-pem.c    |   13 +------------
 drivers/hwmon/lm63.c           |   13 +------------
 drivers/hwmon/lm73.c           |   15 +--------------
 drivers/hwmon/lm75.c           |   17 +----------------
 drivers/hwmon/lm77.c           |   13 +------------
 drivers/hwmon/lm80.c           |   13 +------------
 drivers/hwmon/lm83.c           |   13 +------------
 drivers/hwmon/lm85.c           |   14 +-------------
 drivers/hwmon/lm87.c           |   13 +------------
 drivers/hwmon/lm90.c           |   13 +------------
 drivers/hwmon/lm92.c           |   13 +------------
 drivers/hwmon/lm93.c           |   13 +------------
 drivers/hwmon/lm95241.c        |   13 +------------
 drivers/hwmon/lm95245.c        |   13 +------------
 drivers/hwmon/ltc4151.c        |   13 +------------
 drivers/hwmon/ltc4215.c        |   13 +------------
 drivers/hwmon/ltc4245.c        |   13 +------------
 drivers/hwmon/ltc4261.c        |   13 +------------
 drivers/hwmon/max16065.c       |   13 +------------
 drivers/hwmon/max1619.c        |   13 +------------
 drivers/hwmon/max1668.c        |   13 +------------
 drivers/hwmon/max6639.c        |   13 +------------
 drivers/hwmon/max6642.c        |   13 +------------
 drivers/hwmon/max6650.c        |   13 +------------
 drivers/hwmon/pmbus/adm1275.c  |   12 +-----------
 drivers/hwmon/pmbus/lm25066.c  |   12 +-----------
 drivers/hwmon/pmbus/ltc2978.c  |   12 +-----------
 drivers/hwmon/pmbus/max16064.c |   12 +-----------
 drivers/hwmon/pmbus/max34440.c |   12 +-----------
 drivers/hwmon/pmbus/max8688.c  |   12 +-----------
 drivers/hwmon/pmbus/pmbus.c    |   12 +-----------
 drivers/hwmon/pmbus/ucd9000.c  |   12 +-----------
 drivers/hwmon/pmbus/ucd9200.c  |   12 +-----------
 drivers/hwmon/pmbus/zl6100.c   |   12 +-----------
 drivers/hwmon/sht21.c          |   23 +----------------------
 drivers/hwmon/smm665.c         |   13 +------------
 drivers/hwmon/smsc47m192.c     |   13 +------------
 drivers/hwmon/thmc50.c         |   13 +------------
 drivers/hwmon/tmp102.c         |   12 +-----------
 drivers/hwmon/tmp401.c         |   13 +------------
 drivers/hwmon/tmp421.c         |   13 +------------
 drivers/hwmon/w83791d.c        |   13 +------------
 drivers/hwmon/w83792d.c        |   16 +---------------
 drivers/hwmon/w83793.c         |   13 +------------
 drivers/hwmon/w83795.c         |   13 +------------
 drivers/hwmon/w83l785ts.c      |   13 +------------
 drivers/hwmon/w83l786ng.c      |   15 +--------------
 74 files changed, 74 insertions(+), 909 deletions(-)

diff --git a/drivers/hwmon/ad7414.c b/drivers/hwmon/ad7414.c
index edbdb6d..3646500 100644
--- a/drivers/hwmon/ad7414.c
+++ b/drivers/hwmon/ad7414.c
@@ -256,17 +256,7 @@ static struct i2c_driver ad7414_driver = {
 	.id_table = ad7414_id,
 };
 
-static int __init ad7414_init(void)
-{
-	return i2c_add_driver(&ad7414_driver);
-}
-module_init(ad7414_init);
-
-static void __exit ad7414_exit(void)
-{
-	i2c_del_driver(&ad7414_driver);
-}
-module_exit(ad7414_exit);
+module_i2c_driver(ad7414_driver);
 
 MODULE_AUTHOR("Stefan Roese <sr at denx.de>, "
 	      "Frank Edelhaeuser <frank.edelhaeuser at spansion.com>");
diff --git a/drivers/hwmon/ad7418.c b/drivers/hwmon/ad7418.c
index 42461d1..a50a6be 100644
--- a/drivers/hwmon/ad7418.c
+++ b/drivers/hwmon/ad7418.c
@@ -295,20 +295,9 @@ static int ad7418_remove(struct i2c_client *client)
 	return 0;
 }
 
-static int __init ad7418_init(void)
-{
-	return i2c_add_driver(&ad7418_driver);
-}
-
-static void __exit ad7418_exit(void)
-{
-	i2c_del_driver(&ad7418_driver);
-}
+module_i2c_driver(ad7418_driver);
 
 MODULE_AUTHOR("Alessandro Zummo <a.zummo@towertech.it>");
 MODULE_DESCRIPTION("AD7416/17/18 driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
-
-module_init(ad7418_init);
-module_exit(ad7418_exit);
diff --git a/drivers/hwmon/adm1021.c b/drivers/hwmon/adm1021.c
index e6fc006..ec84331 100644
--- a/drivers/hwmon/adm1021.c
+++ b/drivers/hwmon/adm1021.c
@@ -471,15 +471,7 @@ static struct adm1021_data *adm1021_update_device(struct device *dev)
 	return data;
 }
 
-static int __init sensors_adm1021_init(void)
-{
-	return i2c_add_driver(&adm1021_driver);
-}
-
-static void __exit sensors_adm1021_exit(void)
-{
-	i2c_del_driver(&adm1021_driver);
-}
+module_i2c_driver(adm1021_driver);
 
 MODULE_AUTHOR("Frodo Looijaard <frodol@dds.nl> and "
 		"Philip Edelbrock <phil@netroedge.com>");
@@ -488,6 +480,3 @@ MODULE_LICENSE("GPL");
 
 module_param(read_only, bool, 0);
 MODULE_PARM_DESC(read_only, "Don't set any values, read only mode");
-
-module_init(sensors_adm1021_init)
-module_exit(sensors_adm1021_exit)
diff --git a/drivers/hwmon/adm1025.c b/drivers/hwmon/adm1025.c
index 14d8997..efbc9c9 100644
--- a/drivers/hwmon/adm1025.c
+++ b/drivers/hwmon/adm1025.c
@@ -618,19 +618,8 @@ static struct adm1025_data *adm1025_update_device(struct device *dev)
 	return data;
 }
 
-static int __init sensors_adm1025_init(void)
-{
-	return i2c_add_driver(&adm1025_driver);
-}
-
-static void __exit sensors_adm1025_exit(void)
-{
-	i2c_del_driver(&adm1025_driver);
-}
+module_i2c_driver(adm1025_driver);
 
 MODULE_AUTHOR("Jean Delvare <khali@linux-fr.org>");
 MODULE_DESCRIPTION("ADM1025 driver");
 MODULE_LICENSE("GPL");
-
-module_init(sensors_adm1025_init);
-module_exit(sensors_adm1025_exit);
diff --git a/drivers/hwmon/adm1026.c b/drivers/hwmon/adm1026.c
index cd773ce..1f4f5de 100644
--- a/drivers/hwmon/adm1026.c
+++ b/drivers/hwmon/adm1026.c
@@ -1881,20 +1881,9 @@ static int adm1026_remove(struct i2c_client *client)
 	return 0;
 }
 
-static int __init sm_adm1026_init(void)
-{
-	return i2c_add_driver(&adm1026_driver);
-}
-
-static void __exit sm_adm1026_exit(void)
-{
-	i2c_del_driver(&adm1026_driver);
-}
+module_i2c_driver(adm1026_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Philip Pokorny <ppokorny@penguincomputing.com>, "
 	      "Justin Thiessen <jthiessen@penguincomputing.com>");
 MODULE_DESCRIPTION("ADM1026 driver");
-
-module_init(sm_adm1026_init);
-module_exit(sm_adm1026_exit);
diff --git a/drivers/hwmon/adm1029.c b/drivers/hwmon/adm1029.c
index d789c33..c6531a8 100644
--- a/drivers/hwmon/adm1029.c
+++ b/drivers/hwmon/adm1029.c
@@ -450,24 +450,8 @@ static struct adm1029_data *adm1029_update_device(struct device *dev)
 	return data;
 }
 
-/*
-	Common module stuff
-*/
-static int __init sensors_adm1029_init(void)
-{
-
-	return i2c_add_driver(&adm1029_driver);
-}
-
-static void __exit sensors_adm1029_exit(void)
-{
-
-	i2c_del_driver(&adm1029_driver);
-}
+module_i2c_driver(adm1029_driver);
 
 MODULE_AUTHOR("Corentin LABBE <corentin.labbe@geomatys.fr>");
 MODULE_DESCRIPTION("adm1029 driver");
 MODULE_LICENSE("GPL v2");
-
-module_init(sensors_adm1029_init);
-module_exit(sensors_adm1029_exit);
diff --git a/drivers/hwmon/adm1031.c b/drivers/hwmon/adm1031.c
index 97e2cfb..71b5ec3 100644
--- a/drivers/hwmon/adm1031.c
+++ b/drivers/hwmon/adm1031.c
@@ -1131,19 +1131,8 @@ static struct adm1031_data *adm1031_update_device(struct device *dev)
 	return data;
 }
 
-static int __init sensors_adm1031_init(void)
-{
-	return i2c_add_driver(&adm1031_driver);
-}
-
-static void __exit sensors_adm1031_exit(void)
-{
-	i2c_del_driver(&adm1031_driver);
-}
+module_i2c_driver(adm1031_driver);
 
 MODULE_AUTHOR("Alexandre d'Alton <alex@alexdalton.org>");
 MODULE_DESCRIPTION("ADM1031/ADM1030 driver");
 MODULE_LICENSE("GPL");
-
-module_init(sensors_adm1031_init);
-module_exit(sensors_adm1031_exit);
diff --git a/drivers/hwmon/adm9240.c b/drivers/hwmon/adm9240.c
index 2de4511..340b842 100644
--- a/drivers/hwmon/adm9240.c
+++ b/drivers/hwmon/adm9240.c
@@ -821,21 +821,9 @@ static struct adm9240_data *adm9240_update_device(struct device *dev)
 	return data;
 }
 
-static int __init sensors_adm9240_init(void)
-{
-	return i2c_add_driver(&adm9240_driver);
-}
-
-static void __exit sensors_adm9240_exit(void)
-{
-	i2c_del_driver(&adm9240_driver);
-}
+module_i2c_driver(adm9240_driver);
 
 MODULE_AUTHOR("Michiel Rook <michiel@grendelproject.nl>, "
 		"Grant Coady <gcoady.lk@gmail.com> and others");
 MODULE_DESCRIPTION("ADM9240/DS1780/LM81 driver");
 MODULE_LICENSE("GPL");
-
-module_init(sensors_adm9240_init);
-module_exit(sensors_adm9240_exit);
-
diff --git a/drivers/hwmon/ads1015.c b/drivers/hwmon/ads1015.c
index eedca3c..60be358 100644
--- a/drivers/hwmon/ads1015.c
+++ b/drivers/hwmon/ads1015.c
@@ -306,19 +306,8 @@ static struct i2c_driver ads1015_driver = {
 	.id_table = ads1015_id,
 };
 
-static int __init sensors_ads1015_init(void)
-{
-	return i2c_add_driver(&ads1015_driver);
-}
-
-static void __exit sensors_ads1015_exit(void)
-{
-	i2c_del_driver(&ads1015_driver);
-}
+module_i2c_driver(ads1015_driver);
 
 MODULE_AUTHOR("Dirk Eibach <eibach@gdsys.de>");
 MODULE_DESCRIPTION("ADS1015 driver");
 MODULE_LICENSE("GPL");
-
-module_init(sensors_ads1015_init);
-module_exit(sensors_ads1015_exit);
diff --git a/drivers/hwmon/adt7411.c b/drivers/hwmon/adt7411.c
index ffe64f8..71bacc5 100644
--- a/drivers/hwmon/adt7411.c
+++ b/drivers/hwmon/adt7411.c
@@ -348,17 +348,7 @@ static struct i2c_driver adt7411_driver = {
 	.class = I2C_CLASS_HWMON,
 };
 
-static int __init sensors_adt7411_init(void)
-{
-	return i2c_add_driver(&adt7411_driver);
-}
-module_init(sensors_adt7411_init)
-
-static void __exit sensors_adt7411_exit(void)
-{
-	i2c_del_driver(&adt7411_driver);
-}
-module_exit(sensors_adt7411_exit)
+module_i2c_driver(adt7411_driver);
 
 MODULE_AUTHOR("Sascha Hauer <s.hauer@pengutronix.de> and "
 	"Wolfram Sang <w.sang@pengutronix.de>");
diff --git a/drivers/hwmon/adt7462.c b/drivers/hwmon/adt7462.c
index 3df331a..e4b1cc9 100644
--- a/drivers/hwmon/adt7462.c
+++ b/drivers/hwmon/adt7462.c
@@ -1974,19 +1974,8 @@ static int adt7462_remove(struct i2c_client *client)
 	return 0;
 }
 
-static int __init adt7462_init(void)
-{
-	return i2c_add_driver(&adt7462_driver);
-}
-
-static void __exit adt7462_exit(void)
-{
-	i2c_del_driver(&adt7462_driver);
-}
+module_i2c_driver(adt7462_driver);
 
 MODULE_AUTHOR("Darrick J. Wong <djwong@us.ibm.com>");
 MODULE_DESCRIPTION("ADT7462 driver");
 MODULE_LICENSE("GPL");
-
-module_init(adt7462_init);
-module_exit(adt7462_exit);
diff --git a/drivers/hwmon/adt7470.c b/drivers/hwmon/adt7470.c
index b23efd9..54ec890 100644
--- a/drivers/hwmon/adt7470.c
+++ b/drivers/hwmon/adt7470.c
@@ -1317,19 +1317,8 @@ static int adt7470_remove(struct i2c_client *client)
 	return 0;
 }
 
-static int __init adt7470_init(void)
-{
-	return i2c_add_driver(&adt7470_driver);
-}
-
-static void __exit adt7470_exit(void)
-{
-	i2c_del_driver(&adt7470_driver);
-}
+module_i2c_driver(adt7470_driver);
 
 MODULE_AUTHOR("Darrick J. Wong <djwong@us.ibm.com>");
 MODULE_DESCRIPTION("ADT7470 driver");
 MODULE_LICENSE("GPL");
-
-module_init(adt7470_init);
-module_exit(adt7470_exit);
diff --git a/drivers/hwmon/adt7475.c b/drivers/hwmon/adt7475.c
index 71e9ac4..522cb76 100644
--- a/drivers/hwmon/adt7475.c
+++ b/drivers/hwmon/adt7475.c
@@ -1600,19 +1600,8 @@ static struct adt7475_data *adt7475_update_device(struct device *dev)
 	return data;
 }
 
-static int __init sensors_adt7475_init(void)
-{
-	return i2c_add_driver(&adt7475_driver);
-}
-
-static void __exit sensors_adt7475_exit(void)
-{
-	i2c_del_driver(&adt7475_driver);
-}
+module_i2c_driver(adt7475_driver);
 
 MODULE_AUTHOR("Advanced Micro Devices, Inc");
 MODULE_DESCRIPTION("adt7475 driver");
 MODULE_LICENSE("GPL");
-
-module_init(sensors_adt7475_init);
-module_exit(sensors_adt7475_exit);
diff --git a/drivers/hwmon/amc6821.c b/drivers/hwmon/amc6821.c
index 4a4bfef..5298855 100644
--- a/drivers/hwmon/amc6821.c
+++ b/drivers/hwmon/amc6821.c
@@ -1095,20 +1095,7 @@ static struct amc6821_data *amc6821_update_device(struct device *dev)
 	return data;
 }
 
-
-static int __init amc6821_init(void)
-{
-	return i2c_add_driver(&amc6821_driver);
-}
-
-static void __exit amc6821_exit(void)
-{
-	i2c_del_driver(&amc6821_driver);
-}
-
-module_init(amc6821_init);
-module_exit(amc6821_exit);
-
+module_i2c_driver(amc6821_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("T. Mertelj <tomaz.mertelj@guest.arnes.si>");
diff --git a/drivers/hwmon/asb100.c b/drivers/hwmon/asb100.c
index a5f1642..573fff5 100644
--- a/drivers/hwmon/asb100.c
+++ b/drivers/hwmon/asb100.c
@@ -1002,19 +1002,8 @@ static struct asb100_data *asb100_update_device(struct device *dev)
 	return data;
 }
 
-static int __init asb100_init(void)
-{
-	return i2c_add_driver(&asb100_driver);
-}
-
-static void __exit asb100_exit(void)
-{
-	i2c_del_driver(&asb100_driver);
-}
+module_i2c_driver(asb100_driver);
 
 MODULE_AUTHOR("Mark M. Hoffman <mhoffman@lightlink.com>");
 MODULE_DESCRIPTION("ASB100 Bach driver");
 MODULE_LICENSE("GPL");
-
-module_init(asb100_init);
-module_exit(asb100_exit);
diff --git a/drivers/hwmon/atxp1.c b/drivers/hwmon/atxp1.c
index d4a589b..5a671ca 100644
--- a/drivers/hwmon/atxp1.c
+++ b/drivers/hwmon/atxp1.c
@@ -390,15 +390,4 @@ static int atxp1_remove(struct i2c_client *client)
 	return 0;
 };
 
-static int __init atxp1_init(void)
-{
-	return i2c_add_driver(&atxp1_driver);
-};
-
-static void __exit atxp1_exit(void)
-{
-	i2c_del_driver(&atxp1_driver);
-};
-
-module_init(atxp1_init);
-module_exit(atxp1_exit);
+module_i2c_driver(atxp1_driver);
diff --git a/drivers/hwmon/ds1621.c b/drivers/hwmon/ds1621.c
index e23a8ab..5dc5489 100644
--- a/drivers/hwmon/ds1621.c
+++ b/drivers/hwmon/ds1621.c
@@ -311,20 +311,8 @@ static struct i2c_driver ds1621_driver = {
 	.address_list	= normal_i2c,
 };
 
-static int __init ds1621_init(void)
-{
-	return i2c_add_driver(&ds1621_driver);
-}
-
-static void __exit ds1621_exit(void)
-{
-	i2c_del_driver(&ds1621_driver);
-}
-
+module_i2c_driver(ds1621_driver);
 
 MODULE_AUTHOR("Christian W. Zuckschwerdt <zany@triq.net>");
 MODULE_DESCRIPTION("DS1621 driver");
 MODULE_LICENSE("GPL");
-
-module_init(ds1621_init);
-module_exit(ds1621_exit);
diff --git a/drivers/hwmon/ds620.c b/drivers/hwmon/ds620.c
index 300c3d4..50663ef 100644
--- a/drivers/hwmon/ds620.c
+++ b/drivers/hwmon/ds620.c
@@ -297,19 +297,8 @@ static struct i2c_driver ds620_driver = {
 	.id_table = ds620_id,
 };
 
-static int __init ds620_init(void)
-{
-	return i2c_add_driver(&ds620_driver);
-}
-
-static void __exit ds620_exit(void)
-{
-	i2c_del_driver(&ds620_driver);
-}
+module_i2c_driver(ds620_driver);
 
 MODULE_AUTHOR("Roland Stigge <stigge@antcom.de>");
 MODULE_DESCRIPTION("DS620 driver");
 MODULE_LICENSE("GPL");
-
-module_init(ds620_init);
-module_exit(ds620_exit);
diff --git a/drivers/hwmon/emc1403.c b/drivers/hwmon/emc1403.c
index 270ffab..99ac141 100644
--- a/drivers/hwmon/emc1403.c
+++ b/drivers/hwmon/emc1403.c
@@ -366,18 +366,7 @@ static struct i2c_driver sensor_emc1403 = {
 	.address_list = emc1403_address_list,
 };
 
-static int __init sensor_emc1403_init(void)
-{
-	return i2c_add_driver(&sensor_emc1403);
-}
-
-static void  __exit sensor_emc1403_exit(void)
-{
-	i2c_del_driver(&sensor_emc1403);
-}
-
-module_init(sensor_emc1403_init);
-module_exit(sensor_emc1403_exit);
+module_i2c_driver(sensor_emc1403);
 
 MODULE_AUTHOR("Kalhan Trisal <kalhan.trisal@intel.com");
 MODULE_DESCRIPTION("emc1403 Thermal Driver");
diff --git a/drivers/hwmon/emc2103.c b/drivers/hwmon/emc2103.c
index 8650639..0f51382 100644
--- a/drivers/hwmon/emc2103.c
+++ b/drivers/hwmon/emc2103.c
@@ -722,19 +722,8 @@ static struct i2c_driver emc2103_driver = {
 	.address_list	= normal_i2c,
 };
 
-static int __init sensors_emc2103_init(void)
-{
-	return i2c_add_driver(&emc2103_driver);
-}
-
-static void __exit sensors_emc2103_exit(void)
-{
-	i2c_del_driver(&emc2103_driver);
-}
+module_i2c_driver(emc2103_driver);
 
 MODULE_AUTHOR("Steve Glendinning <steve.glendinning@smsc.com>");
 MODULE_DESCRIPTION("SMSC EMC2103 hwmon driver");
 MODULE_LICENSE("GPL");
-
-module_init(sensors_emc2103_init);
-module_exit(sensors_emc2103_exit);
diff --git a/drivers/hwmon/emc6w201.c b/drivers/hwmon/emc6w201.c
index 6ebb9b7..840f511 100644
--- a/drivers/hwmon/emc6w201.c
+++ b/drivers/hwmon/emc6w201.c
@@ -552,17 +552,7 @@ static struct i2c_driver emc6w201_driver = {
 	.address_list	= normal_i2c,
 };
 
-static int __init sensors_emc6w201_init(void)
-{
-	return i2c_add_driver(&emc6w201_driver);
-}
-module_init(sensors_emc6w201_init);
-
-static void __exit sensors_emc6w201_exit(void)
-{
-	i2c_del_driver(&emc6w201_driver);
-}
-module_exit(sensors_emc6w201_exit);
+module_i2c_driver(emc6w201_driver);
 
 MODULE_AUTHOR("Jean Delvare <khali@linux-fr.org>");
 MODULE_DESCRIPTION("SMSC EMC6W201 hardware monitoring driver");
diff --git a/drivers/hwmon/f75375s.c b/drivers/hwmon/f75375s.c
index eedf574..398dbc8 100644
--- a/drivers/hwmon/f75375s.c
+++ b/drivers/hwmon/f75375s.c
@@ -858,19 +858,8 @@ static int f75375_detect(struct i2c_client *client,
 	return 0;
 }
 
-static int __init sensors_f75375_init(void)
-{
-	return i2c_add_driver(&f75375_driver);
-}
-
-static void __exit sensors_f75375_exit(void)
-{
-	i2c_del_driver(&f75375_driver);
-}
+module_i2c_driver(f75375_driver);
 
 MODULE_AUTHOR("Riku Voipio");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("F75373/F75375/F75387 hardware monitoring driver");
-
-module_init(sensors_f75375_init);
-module_exit(sensors_f75375_exit);
diff --git a/drivers/hwmon/fschmd.c b/drivers/hwmon/fschmd.c
index 06cbf77..35ddf6d 100644
--- a/drivers/hwmon/fschmd.c
+++ b/drivers/hwmon/fschmd.c
@@ -1341,20 +1341,9 @@ static struct fschmd_data *fschmd_update_device(struct device *dev)
 	return data;
 }
 
-static int __init fschmd_init(void)
-{
-	return i2c_add_driver(&fschmd_driver);
-}
-
-static void __exit fschmd_exit(void)
-{
-	i2c_del_driver(&fschmd_driver);
-}
+module_i2c_driver(fschmd_driver);
 
 MODULE_AUTHOR("Hans de Goede <hdegoede@redhat.com>");
 MODULE_DESCRIPTION("FSC Poseidon, Hermes, Scylla, Heracles, Heimdall, Hades "
 			"and Syleus driver");
 MODULE_LICENSE("GPL");
-
-module_init(fschmd_init);
-module_exit(fschmd_exit);
diff --git a/drivers/hwmon/g760a.c b/drivers/hwmon/g760a.c
index 81b6e35..052e304 100644
--- a/drivers/hwmon/g760a.c
+++ b/drivers/hwmon/g760a.c
@@ -250,21 +250,8 @@ static int g760a_remove(struct i2c_client *client)
 	return 0;
 }
 
-/* module management */
-
-static int __init g760a_init(void)
-{
-	return i2c_add_driver(&g760a_driver);
-}
-
-static void __exit g760a_exit(void)
-{
-	i2c_del_driver(&g760a_driver);
-}
+module_i2c_driver(g760a_driver);
 
 MODULE_AUTHOR("Herbert Valerio Riedel <hvr@gnu.org>");
 MODULE_DESCRIPTION("GMT G760A driver");
 MODULE_LICENSE("GPL");
-
-module_init(g760a_init);
-module_exit(g760a_exit);
diff --git a/drivers/hwmon/gl518sm.c b/drivers/hwmon/gl518sm.c
index 8d0f71d..ae193f0 100644
--- a/drivers/hwmon/gl518sm.c
+++ b/drivers/hwmon/gl518sm.c
@@ -710,21 +710,10 @@ static struct gl518_data *gl518_update_device(struct device *dev)
 	return data;
 }
 
-static int __init sensors_gl518sm_init(void)
-{
-	return i2c_add_driver(&gl518_driver);
-}
-
-static void __exit sensors_gl518sm_exit(void)
-{
-	i2c_del_driver(&gl518_driver);
-}
+module_i2c_driver(gl518_driver);
 
 MODULE_AUTHOR("Frodo Looijaard <frodol@dds.nl>, "
 	"Kyosti Malkki <kmalkki@cc.hut.fi> and "
 	"Hong-Gunn Chew <hglinux@gunnet.org>");
 MODULE_DESCRIPTION("GL518SM driver");
 MODULE_LICENSE("GPL");
-
-module_init(sensors_gl518sm_init);
-module_exit(sensors_gl518sm_exit);
diff --git a/drivers/hwmon/gl520sm.c b/drivers/hwmon/gl520sm.c
index 1909097..52dadb2 100644
--- a/drivers/hwmon/gl520sm.c
+++ b/drivers/hwmon/gl520sm.c
@@ -979,23 +979,10 @@ static struct gl520_data *gl520_update_device(struct device *dev)
 	return data;
 }
 
-
-static int __init sensors_gl520sm_init(void)
-{
-	return i2c_add_driver(&gl520_driver);
-}
-
-static void __exit sensors_gl520sm_exit(void)
-{
-	i2c_del_driver(&gl520_driver);
-}
-
+module_i2c_driver(gl520_driver);
 
 MODULE_AUTHOR("Frodo Looijaard <frodol@dds.nl>, "
 	"Kyösti Mälkki <kmalkki@cc.hut.fi>, "
 	"Maarten Deprez <maartendeprez@users.sourceforge.net>");
 MODULE_DESCRIPTION("GL520SM driver");
 MODULE_LICENSE("GPL");
-
-module_init(sensors_gl520sm_init);
-module_exit(sensors_gl520sm_exit);
diff --git a/drivers/hwmon/jc42.c b/drivers/hwmon/jc42.c
index 28c09ee..308346c 100644
--- a/drivers/hwmon/jc42.c
+++ b/drivers/hwmon/jc42.c
@@ -588,19 +588,8 @@ abort:
 	return ret;
 }
 
-static int __init sensors_jc42_init(void)
-{
-	return i2c_add_driver(&jc42_driver);
-}
-
-static void __exit sensors_jc42_exit(void)
-{
-	i2c_del_driver(&jc42_driver);
-}
+module_i2c_driver(jc42_driver);
 
 MODULE_AUTHOR("Guenter Roeck <guenter.roeck@ericsson.com>");
 MODULE_DESCRIPTION("JC42 driver");
 MODULE_LICENSE("GPL");
-
-module_init(sensors_jc42_init);
-module_exit(sensors_jc42_exit);
diff --git a/drivers/hwmon/lineage-pem.c b/drivers/hwmon/lineage-pem.c
index 58eded2..5b8c9ae 100644
--- a/drivers/hwmon/lineage-pem.c
+++ b/drivers/hwmon/lineage-pem.c
@@ -568,19 +568,8 @@ static struct i2c_driver pem_driver = {
 	.id_table = pem_id,
 };
 
-static int __init pem_init(void)
-{
-	return i2c_add_driver(&pem_driver);
-}
-
-static void __exit pem_exit(void)
-{
-	i2c_del_driver(&pem_driver);
-}
+module_i2c_driver(pem_driver);
 
 MODULE_AUTHOR("Guenter Roeck <guenter.roeck@ericsson.com>");
 MODULE_DESCRIPTION("Lineage CPL PEM hardware monitoring driver");
 MODULE_LICENSE("GPL");
-
-module_init(pem_init);
-module_exit(pem_exit);
diff --git a/drivers/hwmon/lm63.c b/drivers/hwmon/lm63.c
index 5e6457a..15c05cc 100644
--- a/drivers/hwmon/lm63.c
+++ b/drivers/hwmon/lm63.c
@@ -1119,19 +1119,8 @@ static struct lm63_data *lm63_update_device(struct device *dev)
 	return data;
 }
 
-static int __init sensors_lm63_init(void)
-{
-	return i2c_add_driver(&lm63_driver);
-}
-
-static void __exit sensors_lm63_exit(void)
-{
-	i2c_del_driver(&lm63_driver);
-}
+module_i2c_driver(lm63_driver);
 
 MODULE_AUTHOR("Jean Delvare <khali@linux-fr.org>");
 MODULE_DESCRIPTION("LM63 driver");
 MODULE_LICENSE("GPL");
-
-module_init(sensors_lm63_init);
-module_exit(sensors_lm63_exit);
diff --git a/drivers/hwmon/lm73.c b/drivers/hwmon/lm73.c
index 9c8093c..8fa2632 100644
--- a/drivers/hwmon/lm73.c
+++ b/drivers/hwmon/lm73.c
@@ -194,21 +194,8 @@ static struct i2c_driver lm73_driver = {
 	.address_list	= normal_i2c,
 };
 
-/* module glue */
-
-static int __init sensors_lm73_init(void)
-{
-	return i2c_add_driver(&lm73_driver);
-}
-
-static void __exit sensors_lm73_exit(void)
-{
-	i2c_del_driver(&lm73_driver);
-}
+module_i2c_driver(lm73_driver);
 
 MODULE_AUTHOR("Guillaume Ligneul <guillaume.ligneul@gmail.com>");
 MODULE_DESCRIPTION("LM73 driver");
 MODULE_LICENSE("GPL");
-
-module_init(sensors_lm73_init);
-module_exit(sensors_lm73_exit);
diff --git a/drivers/hwmon/lm75.c b/drivers/hwmon/lm75.c
index b3311b1..a83f206 100644
--- a/drivers/hwmon/lm75.c
+++ b/drivers/hwmon/lm75.c
@@ -438,23 +438,8 @@ abort:
 	return ret;
 }
 
-/*-----------------------------------------------------------------------*/
-
-/* module glue */
-
-static int __init sensors_lm75_init(void)
-{
-	return i2c_add_driver(&lm75_driver);
-}
-
-static void __exit sensors_lm75_exit(void)
-{
-	i2c_del_driver(&lm75_driver);
-}
+module_i2c_driver(lm75_driver);
 
 MODULE_AUTHOR("Frodo Looijaard <frodol@dds.nl>");
 MODULE_DESCRIPTION("LM75 driver");
 MODULE_LICENSE("GPL");
-
-module_init(sensors_lm75_init);
-module_exit(sensors_lm75_exit);
diff --git a/drivers/hwmon/lm77.c b/drivers/hwmon/lm77.c
index 08f7ffe..d8c1f35 100644
--- a/drivers/hwmon/lm77.c
+++ b/drivers/hwmon/lm77.c
@@ -443,19 +443,8 @@ static struct lm77_data *lm77_update_device(struct device *dev)
 	return data;
 }
 
-static int __init sensors_lm77_init(void)
-{
-	return i2c_add_driver(&lm77_driver);
-}
-
-static void __exit sensors_lm77_exit(void)
-{
-	i2c_del_driver(&lm77_driver);
-}
+module_i2c_driver(lm77_driver);
 
 MODULE_AUTHOR("Andras BALI <drewie@freemail.hu>");
 MODULE_DESCRIPTION("LM77 driver");
 MODULE_LICENSE("GPL");
-
-module_init(sensors_lm77_init);
-module_exit(sensors_lm77_exit);
diff --git a/drivers/hwmon/lm80.c b/drivers/hwmon/lm80.c
index dc6df4e..6a2a777 100644
--- a/drivers/hwmon/lm80.c
+++ b/drivers/hwmon/lm80.c
@@ -697,20 +697,9 @@ done:
 	return ret;
 }
 
-static int __init sensors_lm80_init(void)
-{
-	return i2c_add_driver(&lm80_driver);
-}
-
-static void __exit sensors_lm80_exit(void)
-{
-	i2c_del_driver(&lm80_driver);
-}
+module_i2c_driver(lm80_driver);
 
 MODULE_AUTHOR("Frodo Looijaard <frodol@dds.nl> and "
 	"Philip Edelbrock <phil@netroedge.com>");
 MODULE_DESCRIPTION("LM80 driver");
 MODULE_LICENSE("GPL");
-
-module_init(sensors_lm80_init);
-module_exit(sensors_lm80_exit);
diff --git a/drivers/hwmon/lm83.c b/drivers/hwmon/lm83.c
index 1fed265..cd45b9d 100644
--- a/drivers/hwmon/lm83.c
+++ b/drivers/hwmon/lm83.c
@@ -430,19 +430,8 @@ static struct lm83_data *lm83_update_device(struct device *dev)
 	return data;
 }
 
-static int __init sensors_lm83_init(void)
-{
-	return i2c_add_driver(&lm83_driver);
-}
-
-static void __exit sensors_lm83_exit(void)
-{
-	i2c_del_driver(&lm83_driver);
-}
+module_i2c_driver(lm83_driver);
 
 MODULE_AUTHOR("Jean Delvare <khali@linux-fr.org>");
 MODULE_DESCRIPTION("LM83 driver");
 MODULE_LICENSE("GPL");
-
-module_init(sensors_lm83_init);
-module_exit(sensors_lm83_exit);
diff --git a/drivers/hwmon/lm85.c b/drivers/hwmon/lm85.c
index 240b7f9..7e46ebb 100644
--- a/drivers/hwmon/lm85.c
+++ b/drivers/hwmon/lm85.c
@@ -1695,22 +1695,10 @@ static struct lm85_data *lm85_update_device(struct device *dev)
 	return data;
 }
 
-
-static int __init sm_lm85_init(void)
-{
-	return i2c_add_driver(&lm85_driver);
-}
-
-static void __exit sm_lm85_exit(void)
-{
-	i2c_del_driver(&lm85_driver);
-}
+module_i2c_driver(lm85_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Philip Pokorny <ppokorny@penguincomputing.com>, "
 	"Margit Schubert-While <margitsw@t-online.de>, "
 	"Justin Thiessen <jthiessen@penguincomputing.com>");
 MODULE_DESCRIPTION("LM85-B, LM85-C driver");
-
-module_init(sm_lm85_init);
-module_exit(sm_lm85_exit);
diff --git a/drivers/hwmon/lm87.c b/drivers/hwmon/lm87.c
index ebf4efd..090f5ef 100644
--- a/drivers/hwmon/lm87.c
+++ b/drivers/hwmon/lm87.c
@@ -1054,19 +1054,8 @@ static struct lm87_data *lm87_update_device(struct device *dev)
 	return data;
 }
 
-static int __init sensors_lm87_init(void)
-{
-	return i2c_add_driver(&lm87_driver);
-}
-
-static void __exit sensors_lm87_exit(void)
-{
-	i2c_del_driver(&lm87_driver);
-}
+module_i2c_driver(lm87_driver);
 
 MODULE_AUTHOR("Jean Delvare <khali@linux-fr.org> and others");
 MODULE_DESCRIPTION("LM87 driver");
 MODULE_LICENSE("GPL");
-
-module_init(sensors_lm87_init);
-module_exit(sensors_lm87_exit);
diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
index d2dd5f9..248f2b4 100644
--- a/drivers/hwmon/lm90.c
+++ b/drivers/hwmon/lm90.c
@@ -1514,19 +1514,8 @@ static struct i2c_driver lm90_driver = {
 	.address_list	= normal_i2c,
 };
 
-static int __init sensors_lm90_init(void)
-{
-	return i2c_add_driver(&lm90_driver);
-}
-
-static void __exit sensors_lm90_exit(void)
-{
-	i2c_del_driver(&lm90_driver);
-}
+module_i2c_driver(lm90_driver);
 
 MODULE_AUTHOR("Jean Delvare <khali@linux-fr.org>");
 MODULE_DESCRIPTION("LM90/ADM1032 driver");
 MODULE_LICENSE("GPL");
-
-module_init(sensors_lm90_init);
-module_exit(sensors_lm90_exit);
diff --git a/drivers/hwmon/lm92.c b/drivers/hwmon/lm92.c
index 95cda41..0fe2f37 100644
--- a/drivers/hwmon/lm92.c
+++ b/drivers/hwmon/lm92.c
@@ -432,19 +432,8 @@ static struct i2c_driver lm92_driver = {
 	.address_list	= normal_i2c,
 };
 
-static int __init sensors_lm92_init(void)
-{
-	return i2c_add_driver(&lm92_driver);
-}
-
-static void __exit sensors_lm92_exit(void)
-{
-	i2c_del_driver(&lm92_driver);
-}
+module_i2c_driver(lm92_driver);
 
 MODULE_AUTHOR("Jean Delvare <khali@linux-fr.org>");
 MODULE_DESCRIPTION("LM92/MAX6635 driver");
 MODULE_LICENSE("GPL");
-
-module_init(sensors_lm92_init);
-module_exit(sensors_lm92_exit);
diff --git a/drivers/hwmon/lm93.c b/drivers/hwmon/lm93.c
index d2fc4ac..22ae5f0 100644
--- a/drivers/hwmon/lm93.c
+++ b/drivers/hwmon/lm93.c
@@ -2761,20 +2761,9 @@ static struct i2c_driver lm93_driver = {
 	.address_list	= normal_i2c,
 };
 
-static int __init lm93_init(void)
-{
-	return i2c_add_driver(&lm93_driver);
-}
-
-static void __exit lm93_exit(void)
-{
-	i2c_del_driver(&lm93_driver);
-}
+module_i2c_driver(lm93_driver);
 
 MODULE_AUTHOR("Mark M. Hoffman <mhoffman@lightlink.com>, "
 		"Hans J. Koch <hjk@hansjkoch.de>");
 MODULE_DESCRIPTION("LM93 driver");
 MODULE_LICENSE("GPL");
-
-module_init(lm93_init);
-module_exit(lm93_exit);
diff --git a/drivers/hwmon/lm95241.c b/drivers/hwmon/lm95241.c
index 70bca67..bd8cdb7 100644
--- a/drivers/hwmon/lm95241.c
+++ b/drivers/hwmon/lm95241.c
@@ -455,19 +455,8 @@ static struct i2c_driver lm95241_driver = {
 	.address_list	= normal_i2c,
 };
 
-static int __init sensors_lm95241_init(void)
-{
-	return i2c_add_driver(&lm95241_driver);
-}
-
-static void __exit sensors_lm95241_exit(void)
-{
-	i2c_del_driver(&lm95241_driver);
-}
+module_i2c_driver(lm95241_driver);
 
 MODULE_AUTHOR("Davide Rizzo <elpa.rizzo@gmail.com>");
 MODULE_DESCRIPTION("LM95241 sensor driver");
 MODULE_LICENSE("GPL");
-
-module_init(sensors_lm95241_init);
-module_exit(sensors_lm95241_exit);
diff --git a/drivers/hwmon/lm95245.c b/drivers/hwmon/lm95245.c
index 5e5fc1b..9a46c10 100644
--- a/drivers/hwmon/lm95245.c
+++ b/drivers/hwmon/lm95245.c
@@ -525,19 +525,8 @@ static struct i2c_driver lm95245_driver = {
 	.address_list	= normal_i2c,
 };
 
-static int __init sensors_lm95245_init(void)
-{
-	return i2c_add_driver(&lm95245_driver);
-}
-
-static void __exit sensors_lm95245_exit(void)
-{
-	i2c_del_driver(&lm95245_driver);
-}
+module_i2c_driver(lm95245_driver);
 
 MODULE_AUTHOR("Alexander Stein <alexander.stein@systec-electronic.com>");
 MODULE_DESCRIPTION("LM95245 sensor driver");
 MODULE_LICENSE("GPL");
-
-module_init(sensors_lm95245_init);
-module_exit(sensors_lm95245_exit);
diff --git a/drivers/hwmon/ltc4151.c b/drivers/hwmon/ltc4151.c
index 4ac06b7..f646b45 100644
--- a/drivers/hwmon/ltc4151.c
+++ b/drivers/hwmon/ltc4151.c
@@ -238,19 +238,8 @@ static struct i2c_driver ltc4151_driver = {
 	.id_table	= ltc4151_id,
 };
 
-static int __init ltc4151_init(void)
-{
-	return i2c_add_driver(&ltc4151_driver);
-}
-
-static void __exit ltc4151_exit(void)
-{
-	i2c_del_driver(&ltc4151_driver);
-}
+module_i2c_driver(ltc4151_driver);
 
 MODULE_AUTHOR("Per Dalen <per.dalen@appeartv.com>");
 MODULE_DESCRIPTION("LTC4151 driver");
 MODULE_LICENSE("GPL");
-
-module_init(ltc4151_init);
-module_exit(ltc4151_exit);
diff --git a/drivers/hwmon/ltc4215.c b/drivers/hwmon/ltc4215.c
index c7e6d8e..0789b63 100644
--- a/drivers/hwmon/ltc4215.c
+++ b/drivers/hwmon/ltc4215.c
@@ -309,19 +309,8 @@ static struct i2c_driver ltc4215_driver = {
 	.id_table	= ltc4215_id,
 };
 
-static int __init ltc4215_init(void)
-{
-	return i2c_add_driver(&ltc4215_driver);
-}
-
-static void __exit ltc4215_exit(void)
-{
-	i2c_del_driver(&ltc4215_driver);
-}
+module_i2c_driver(ltc4215_driver);
 
 MODULE_AUTHOR("Ira W. Snyder <iws@ovro.caltech.edu>");
 MODULE_DESCRIPTION("LTC4215 driver");
 MODULE_LICENSE("GPL");
-
-module_init(ltc4215_init);
-module_exit(ltc4215_exit);
diff --git a/drivers/hwmon/ltc4245.c b/drivers/hwmon/ltc4245.c
index 6593083..693a6bd 100644
--- a/drivers/hwmon/ltc4245.c
+++ b/drivers/hwmon/ltc4245.c
@@ -578,19 +578,8 @@ static struct i2c_driver ltc4245_driver = {
 	.id_table	= ltc4245_id,
 };
 
-static int __init ltc4245_init(void)
-{
-	return i2c_add_driver(&ltc4245_driver);
-}
-
-static void __exit ltc4245_exit(void)
-{
-	i2c_del_driver(&ltc4245_driver);
-}
+module_i2c_driver(ltc4245_driver);
 
 MODULE_AUTHOR("Ira W. Snyder <iws@ovro.caltech.edu>");
 MODULE_DESCRIPTION("LTC4245 driver");
 MODULE_LICENSE("GPL");
-
-module_init(ltc4245_init);
-module_exit(ltc4245_exit);
diff --git a/drivers/hwmon/ltc4261.c b/drivers/hwmon/ltc4261.c
index ce52355..ab1bfbf 100644
--- a/drivers/hwmon/ltc4261.c
+++ b/drivers/hwmon/ltc4261.c
@@ -297,19 +297,8 @@ static struct i2c_driver ltc4261_driver = {
 	.id_table = ltc4261_id,
 };
 
-static int __init ltc4261_init(void)
-{
-	return i2c_add_driver(&ltc4261_driver);
-}
-
-static void __exit ltc4261_exit(void)
-{
-	i2c_del_driver(&ltc4261_driver);
-}
+module_i2c_driver(ltc4261_driver);
 
 MODULE_AUTHOR("Guenter Roeck <guenter.roeck@ericsson.com>");
 MODULE_DESCRIPTION("LTC4261 driver");
 MODULE_LICENSE("GPL");
-
-module_init(ltc4261_init);
-module_exit(ltc4261_exit);
diff --git a/drivers/hwmon/max16065.c b/drivers/hwmon/max16065.c
index f8e323a..51edae9 100644
--- a/drivers/hwmon/max16065.c
+++ b/drivers/hwmon/max16065.c
@@ -699,19 +699,8 @@ static struct i2c_driver max16065_driver = {
 	.id_table = max16065_id,
 };
 
-static int __init max16065_init(void)
-{
-	return i2c_add_driver(&max16065_driver);
-}
-
-static void __exit max16065_exit(void)
-{
-	i2c_del_driver(&max16065_driver);
-}
+module_i2c_driver(max16065_driver);
 
 MODULE_AUTHOR("Guenter Roeck <guenter.roeck@ericsson.com>");
 MODULE_DESCRIPTION("MAX16065 driver");
 MODULE_LICENSE("GPL");
-
-module_init(max16065_init);
-module_exit(max16065_exit);
diff --git a/drivers/hwmon/max1619.c b/drivers/hwmon/max1619.c
index f19599f..ecac04a 100644
--- a/drivers/hwmon/max1619.c
+++ b/drivers/hwmon/max1619.c
@@ -360,20 +360,9 @@ static struct max1619_data *max1619_update_device(struct device *dev)
 	return data;
 }
 
-static int __init sensors_max1619_init(void)
-{
-	return i2c_add_driver(&max1619_driver);
-}
-
-static void __exit sensors_max1619_exit(void)
-{
-	i2c_del_driver(&max1619_driver);
-}
+module_i2c_driver(max1619_driver);
 
 MODULE_AUTHOR("Alexey Fisher <fishor@mail.ru> and "
 	"Jean Delvare <khali@linux-fr.org>");
 MODULE_DESCRIPTION("MAX1619 sensor driver");
 MODULE_LICENSE("GPL");
-
-module_init(sensors_max1619_init);
-module_exit(sensors_max1619_exit);
diff --git a/drivers/hwmon/max1668.c b/drivers/hwmon/max1668.c
index 88953f9..12249f7 100644
--- a/drivers/hwmon/max1668.c
+++ b/drivers/hwmon/max1668.c
@@ -484,19 +484,8 @@ static struct i2c_driver max1668_driver = {
 	.address_list = max1668_addr_list,
 };
 
-static int __init sensors_max1668_init(void)
-{
-	return i2c_add_driver(&max1668_driver);
-}
-
-static void __exit sensors_max1668_exit(void)
-{
-	i2c_del_driver(&max1668_driver);
-}
+module_i2c_driver(max1668_driver);
 
 MODULE_AUTHOR("David George <david.george@ska.ac.za>");
 MODULE_DESCRIPTION("MAX1668 remote temperature sensor driver");
 MODULE_LICENSE("GPL");
-
-module_init(sensors_max1668_init)
-module_exit(sensors_max1668_exit)
diff --git a/drivers/hwmon/max6639.c b/drivers/hwmon/max6639.c
index e10a092..d203eb1 100644
--- a/drivers/hwmon/max6639.c
+++ b/drivers/hwmon/max6639.c
@@ -635,19 +635,8 @@ static struct i2c_driver max6639_driver = {
 	.address_list = normal_i2c,
 };
 
-static int __init max6639_init(void)
-{
-	return i2c_add_driver(&max6639_driver);
-}
-
-static void __exit max6639_exit(void)
-{
-	i2c_del_driver(&max6639_driver);
-}
+module_i2c_driver(max6639_driver);
 
 MODULE_AUTHOR("Roland Stigge <stigge@antcom.de>");
 MODULE_DESCRIPTION("max6639 driver");
 MODULE_LICENSE("GPL");
-
-module_init(max6639_init);
-module_exit(max6639_exit);
diff --git a/drivers/hwmon/max6642.c b/drivers/hwmon/max6642.c
index 209e8a5..4298909 100644
--- a/drivers/hwmon/max6642.c
+++ b/drivers/hwmon/max6642.c
@@ -352,19 +352,8 @@ static struct i2c_driver max6642_driver = {
 	.address_list	= normal_i2c,
 };
 
-static int __init max6642_init(void)
-{
-	return i2c_add_driver(&max6642_driver);
-}
-
-static void __exit max6642_exit(void)
-{
-	i2c_del_driver(&max6642_driver);
-}
+module_i2c_driver(max6642_driver);
 
 MODULE_AUTHOR("Per Dalen <per.dalen@appeartv.com>");
 MODULE_DESCRIPTION("MAX6642 sensor driver");
 MODULE_LICENSE("GPL");
-
-module_init(max6642_init);
-module_exit(max6642_exit);
diff --git a/drivers/hwmon/max6650.c b/drivers/hwmon/max6650.c
index 159ce02..3296e6e 100644
--- a/drivers/hwmon/max6650.c
+++ b/drivers/hwmon/max6650.c
@@ -726,19 +726,8 @@ static struct max6650_data *max6650_update_device(struct device *dev)
 	return data;
 }
 
-static int __init sensors_max6650_init(void)
-{
-	return i2c_add_driver(&max6650_driver);
-}
-
-static void __exit sensors_max6650_exit(void)
-{
-	i2c_del_driver(&max6650_driver);
-}
+module_i2c_driver(max6650_driver);
 
 MODULE_AUTHOR("Hans J. Koch");
 MODULE_DESCRIPTION("MAX6650 sensor driver");
 MODULE_LICENSE("GPL");
-
-module_init(sensors_max6650_init);
-module_exit(sensors_max6650_exit);
diff --git a/drivers/hwmon/pmbus/adm1275.c b/drivers/hwmon/pmbus/adm1275.c
index 81c7c2e..fe52c3c 100644
--- a/drivers/hwmon/pmbus/adm1275.c
+++ b/drivers/hwmon/pmbus/adm1275.c
@@ -326,18 +326,8 @@ static struct i2c_driver adm1275_driver = {
 	.id_table = adm1275_id,
 };
 
-static int __init adm1275_init(void)
-{
-	return i2c_add_driver(&adm1275_driver);
-}
-
-static void __exit adm1275_exit(void)
-{
-	i2c_del_driver(&adm1275_driver);
-}
+module_i2c_driver(adm1275_driver);
 
 MODULE_AUTHOR("Guenter Roeck");
 MODULE_DESCRIPTION("PMBus driver for Analog Devices ADM1275 and compatibles");
 MODULE_LICENSE("GPL");
-module_init(adm1275_init);
-module_exit(adm1275_exit);
diff --git a/drivers/hwmon/pmbus/lm25066.c b/drivers/hwmon/pmbus/lm25066.c
index 84a37f0..86ac15a 100644
--- a/drivers/hwmon/pmbus/lm25066.c
+++ b/drivers/hwmon/pmbus/lm25066.c
@@ -334,18 +334,8 @@ static struct i2c_driver lm25066_driver = {
 	.id_table = lm25066_id,
 };
 
-static int __init lm25066_init(void)
-{
-	return i2c_add_driver(&lm25066_driver);
-}
-
-static void __exit lm25066_exit(void)
-{
-	i2c_del_driver(&lm25066_driver);
-}
+module_i2c_driver(lm25066_driver);
 
 MODULE_AUTHOR("Guenter Roeck");
 MODULE_DESCRIPTION("PMBus driver for LM25066/LM5064/LM5066");
 MODULE_LICENSE("GPL");
-module_init(lm25066_init);
-module_exit(lm25066_exit);
diff --git a/drivers/hwmon/pmbus/ltc2978.c b/drivers/hwmon/pmbus/ltc2978.c
index 820fff4..c9e4dd2 100644
--- a/drivers/hwmon/pmbus/ltc2978.c
+++ b/drivers/hwmon/pmbus/ltc2978.c
@@ -391,18 +391,8 @@ static struct i2c_driver ltc2978_driver = {
 	.id_table = ltc2978_id,
 };
 
-static int __init ltc2978_init(void)
-{
-	return i2c_add_driver(&ltc2978_driver);
-}
-
-static void __exit ltc2978_exit(void)
-{
-	i2c_del_driver(&ltc2978_driver);
-}
+module_i2c_driver(ltc2978_driver);
 
 MODULE_AUTHOR("Guenter Roeck");
 MODULE_DESCRIPTION("PMBus driver for LTC2978 and LTC3880");
 MODULE_LICENSE("GPL");
-module_init(ltc2978_init);
-module_exit(ltc2978_exit);
diff --git a/drivers/hwmon/pmbus/max16064.c b/drivers/hwmon/pmbus/max16064.c
index 1d77cf4..5cfe20f 100644
--- a/drivers/hwmon/pmbus/max16064.c
+++ b/drivers/hwmon/pmbus/max16064.c
@@ -126,18 +126,8 @@ static struct i2c_driver max16064_driver = {
 	.id_table = max16064_id,
 };
 
-static int __init max16064_init(void)
-{
-	return i2c_add_driver(&max16064_driver);
-}
-
-static void __exit max16064_exit(void)
-{
-	i2c_del_driver(&max16064_driver);
-}
+module_i2c_driver(max16064_driver);
 
 MODULE_AUTHOR("Guenter Roeck");
 MODULE_DESCRIPTION("PMBus driver for Maxim MAX16064");
 MODULE_LICENSE("GPL");
-module_init(max16064_init);
-module_exit(max16064_exit);
diff --git a/drivers/hwmon/pmbus/max34440.c b/drivers/hwmon/pmbus/max34440.c
index beaf5a8..89ae303 100644
--- a/drivers/hwmon/pmbus/max34440.c
+++ b/drivers/hwmon/pmbus/max34440.c
@@ -248,18 +248,8 @@ static struct i2c_driver max34440_driver = {
 	.id_table = max34440_id,
 };
 
-static int __init max34440_init(void)
-{
-	return i2c_add_driver(&max34440_driver);
-}
-
-static void __exit max34440_exit(void)
-{
-	i2c_del_driver(&max34440_driver);
-}
+module_i2c_driver(max34440_driver);
 
 MODULE_AUTHOR("Guenter Roeck");
 MODULE_DESCRIPTION("PMBus driver for Maxim MAX34440/MAX34441");
 MODULE_LICENSE("GPL");
-module_init(max34440_init);
-module_exit(max34440_exit);
diff --git a/drivers/hwmon/pmbus/max8688.c b/drivers/hwmon/pmbus/max8688.c
index e2b74bb..82c598d 100644
--- a/drivers/hwmon/pmbus/max8688.c
+++ b/drivers/hwmon/pmbus/max8688.c
@@ -203,18 +203,8 @@ static struct i2c_driver max8688_driver = {
 	.id_table = max8688_id,
 };
 
-static int __init max8688_init(void)
-{
-	return i2c_add_driver(&max8688_driver);
-}
-
-static void __exit max8688_exit(void)
-{
-	i2c_del_driver(&max8688_driver);
-}
+module_i2c_driver(max8688_driver);
 
 MODULE_AUTHOR("Guenter Roeck");
 MODULE_DESCRIPTION("PMBus driver for Maxim MAX8688");
 MODULE_LICENSE("GPL");
-module_init(max8688_init);
-module_exit(max8688_exit);
diff --git a/drivers/hwmon/pmbus/pmbus.c b/drivers/hwmon/pmbus/pmbus.c
index 18a385e..da5fe36 100644
--- a/drivers/hwmon/pmbus/pmbus.c
+++ b/drivers/hwmon/pmbus/pmbus.c
@@ -224,18 +224,8 @@ static struct i2c_driver pmbus_driver = {
 	.id_table = pmbus_id,
 };
 
-static int __init pmbus_init(void)
-{
-	return i2c_add_driver(&pmbus_driver);
-}
-
-static void __exit pmbus_exit(void)
-{
-	i2c_del_driver(&pmbus_driver);
-}
+module_i2c_driver(pmbus_driver);
 
 MODULE_AUTHOR("Guenter Roeck");
 MODULE_DESCRIPTION("Generic PMBus driver");
 MODULE_LICENSE("GPL");
-module_init(pmbus_init);
-module_exit(pmbus_exit);
diff --git a/drivers/hwmon/pmbus/ucd9000.c b/drivers/hwmon/pmbus/ucd9000.c
index 4ff6cf2..759a563 100644
--- a/drivers/hwmon/pmbus/ucd9000.c
+++ b/drivers/hwmon/pmbus/ucd9000.c
@@ -258,18 +258,8 @@ static struct i2c_driver ucd9000_driver = {
 	.id_table = ucd9000_id,
 };
 
-static int __init ucd9000_init(void)
-{
-	return i2c_add_driver(&ucd9000_driver);
-}
-
-static void __exit ucd9000_exit(void)
-{
-	i2c_del_driver(&ucd9000_driver);
-}
+module_i2c_driver(ucd9000_driver);
 
 MODULE_AUTHOR("Guenter Roeck");
 MODULE_DESCRIPTION("PMBus driver for TI UCD90xxx");
 MODULE_LICENSE("GPL");
-module_init(ucd9000_init);
-module_exit(ucd9000_exit);
diff --git a/drivers/hwmon/pmbus/ucd9200.c b/drivers/hwmon/pmbus/ucd9200.c
index 6e1c1a8..629d0c9 100644
--- a/drivers/hwmon/pmbus/ucd9200.c
+++ b/drivers/hwmon/pmbus/ucd9200.c
@@ -190,18 +190,8 @@ static struct i2c_driver ucd9200_driver = {
 	.id_table = ucd9200_id,
 };
 
-static int __init ucd9200_init(void)
-{
-	return i2c_add_driver(&ucd9200_driver);
-}
-
-static void __exit ucd9200_exit(void)
-{
-	i2c_del_driver(&ucd9200_driver);
-}
+module_i2c_driver(ucd9200_driver);
 
 MODULE_AUTHOR("Guenter Roeck");
 MODULE_DESCRIPTION("PMBus driver for TI UCD922x, UCD924x");
 MODULE_LICENSE("GPL");
-module_init(ucd9200_init);
-module_exit(ucd9200_exit);
diff --git a/drivers/hwmon/pmbus/zl6100.c b/drivers/hwmon/pmbus/zl6100.c
index 48c7b4a..0bb7bba 100644
--- a/drivers/hwmon/pmbus/zl6100.c
+++ b/drivers/hwmon/pmbus/zl6100.c
@@ -268,18 +268,8 @@ static struct i2c_driver zl6100_driver = {
 	.id_table = zl6100_id,
 };
 
-static int __init zl6100_init(void)
-{
-	return i2c_add_driver(&zl6100_driver);
-}
-
-static void __exit zl6100_exit(void)
-{
-	i2c_del_driver(&zl6100_driver);
-}
+module_i2c_driver(zl6100_driver);
 
 MODULE_AUTHOR("Guenter Roeck");
 MODULE_DESCRIPTION("PMBus driver for ZL6100 and compatibles");
 MODULE_LICENSE("GPL");
-module_init(zl6100_init);
-module_exit(zl6100_exit);
diff --git a/drivers/hwmon/sht21.c b/drivers/hwmon/sht21.c
index 1539878..6c2dede 100644
--- a/drivers/hwmon/sht21.c
+++ b/drivers/hwmon/sht21.c
@@ -261,28 +261,7 @@ static struct i2c_driver sht21_driver = {
 	.id_table    = sht21_id,
 };
 
-/**
- * sht21_init() - initialize driver
- *
- * Called when kernel is booted or module is inserted.
- * Returns 0 on success.
- */
-static int __init sht21_init(void)
-{
-	return i2c_add_driver(&sht21_driver);
-}
-module_init(sht21_init);
-
-/**
- * sht21_init() - clean up driver
- *
- * Called when module is removed.
- */
-static void __exit sht21_exit(void)
-{
-	i2c_del_driver(&sht21_driver);
-}
-module_exit(sht21_exit);
+module_i2c_driver(sht21_driver);
 
 MODULE_AUTHOR("Urs Fleisch <urs.fleisch@sensirion.com>");
 MODULE_DESCRIPTION("Sensirion SHT21 humidity and temperature sensor driver");
diff --git a/drivers/hwmon/smm665.c b/drivers/hwmon/smm665.c
index 1b4301f..24382c7 100644
--- a/drivers/hwmon/smm665.c
+++ b/drivers/hwmon/smm665.c
@@ -718,19 +718,8 @@ static struct i2c_driver smm665_driver = {
 	.id_table = smm665_id,
 };
 
-static int __init smm665_init(void)
-{
-	return i2c_add_driver(&smm665_driver);
-}
-
-static void __exit smm665_exit(void)
-{
-	i2c_del_driver(&smm665_driver);
-}
+module_i2c_driver(smm665_driver);
 
 MODULE_AUTHOR("Guenter Roeck");
 MODULE_DESCRIPTION("SMM665 driver");
 MODULE_LICENSE("GPL");
-
-module_init(smm665_init);
-module_exit(smm665_exit);
diff --git a/drivers/hwmon/smsc47m192.c b/drivers/hwmon/smsc47m192.c
index 95761bd..307e6a6 100644
--- a/drivers/hwmon/smsc47m192.c
+++ b/drivers/hwmon/smsc47m192.c
@@ -669,19 +669,8 @@ static struct smsc47m192_data *smsc47m192_update_device(struct device *dev)
 	return data;
 }
 
-static int __init smsc47m192_init(void)
-{
-	return i2c_add_driver(&smsc47m192_driver);
-}
-
-static void __exit smsc47m192_exit(void)
-{
-	i2c_del_driver(&smsc47m192_driver);
-}
+module_i2c_driver(smsc47m192_driver);
 
 MODULE_AUTHOR("Hartmut Rick <linux@rick.claranet.de>");
 MODULE_DESCRIPTION("SMSC47M192 driver");
 MODULE_LICENSE("GPL");
-
-module_init(smsc47m192_init);
-module_exit(smsc47m192_exit);
diff --git a/drivers/hwmon/thmc50.c b/drivers/hwmon/thmc50.c
index a195914..51ddb37 100644
--- a/drivers/hwmon/thmc50.c
+++ b/drivers/hwmon/thmc50.c
@@ -482,18 +482,7 @@ static struct thmc50_data *thmc50_update_device(struct device *dev)
 	return data;
 }
 
-static int __init sm_thmc50_init(void)
-{
-	return i2c_add_driver(&thmc50_driver);
-}
-
-static void __exit sm_thmc50_exit(void)
-{
-	i2c_del_driver(&thmc50_driver);
-}
+module_i2c_driver(thmc50_driver);
 
 MODULE_AUTHOR("Krzysztof Helt <krzysztof.h1@wp.pl>");
 MODULE_DESCRIPTION("THMC50 driver");
-
-module_init(sm_thmc50_init);
-module_exit(sm_thmc50_exit);
diff --git a/drivers/hwmon/tmp102.c b/drivers/hwmon/tmp102.c
index c08eee2..0d466b9 100644
--- a/drivers/hwmon/tmp102.c
+++ b/drivers/hwmon/tmp102.c
@@ -292,17 +292,7 @@ static struct i2c_driver tmp102_driver = {
 	.id_table	= tmp102_id,
 };
 
-static int __init tmp102_init(void)
-{
-	return i2c_add_driver(&tmp102_driver);
-}
-module_init(tmp102_init);
-
-static void __exit tmp102_exit(void)
-{
-	i2c_del_driver(&tmp102_driver);
-}
-module_exit(tmp102_exit);
+module_i2c_driver(tmp102_driver);
 
 MODULE_AUTHOR("Steven King <sfking@fdwdc.com>");
 MODULE_DESCRIPTION("Texas Instruments TMP102 temperature sensor driver");
diff --git a/drivers/hwmon/tmp401.c b/drivers/hwmon/tmp401.c
index 8b9a774..92b7f1b 100644
--- a/drivers/hwmon/tmp401.c
+++ b/drivers/hwmon/tmp401.c
@@ -662,19 +662,8 @@ static struct i2c_driver tmp401_driver = {
 	.address_list	= normal_i2c,
 };
 
-static int __init tmp401_init(void)
-{
-	return i2c_add_driver(&tmp401_driver);
-}
-
-static void __exit tmp401_exit(void)
-{
-	i2c_del_driver(&tmp401_driver);
-}
+module_i2c_driver(tmp401_driver);
 
 MODULE_AUTHOR("Hans de Goede <hdegoede@redhat.com>");
 MODULE_DESCRIPTION("Texas Instruments TMP401 temperature sensor driver");
 MODULE_LICENSE("GPL");
-
-module_init(tmp401_init);
-module_exit(tmp401_exit);
diff --git a/drivers/hwmon/tmp421.c b/drivers/hwmon/tmp421.c
index c48381f..8fac87a 100644
--- a/drivers/hwmon/tmp421.c
+++ b/drivers/hwmon/tmp421.c
@@ -324,20 +324,9 @@ static struct i2c_driver tmp421_driver = {
 	.address_list = normal_i2c,
 };
 
-static int __init tmp421_init(void)
-{
-	return i2c_add_driver(&tmp421_driver);
-}
-
-static void __exit tmp421_exit(void)
-{
-	i2c_del_driver(&tmp421_driver);
-}
+module_i2c_driver(tmp421_driver);
 
 MODULE_AUTHOR("Andre Prendel <andre.prendel@gmx.de>");
 MODULE_DESCRIPTION("Texas Instruments TMP421/422/423 temperature sensor"
 		   " driver");
 MODULE_LICENSE("GPL");
-
-module_init(tmp421_init);
-module_exit(tmp421_exit);
diff --git a/drivers/hwmon/w83791d.c b/drivers/hwmon/w83791d.c
index 679146d..b92f01f 100644
--- a/drivers/hwmon/w83791d.c
+++ b/drivers/hwmon/w83791d.c
@@ -1668,19 +1668,8 @@ static void w83791d_print_debug(struct w83791d_data *data, struct device *dev)
 }
 #endif
 
-static int __init sensors_w83791d_init(void)
-{
-	return i2c_add_driver(&w83791d_driver);
-}
-
-static void __exit sensors_w83791d_exit(void)
-{
-	i2c_del_driver(&w83791d_driver);
-}
+module_i2c_driver(w83791d_driver);
 
 MODULE_AUTHOR("Charles Spirakis <bezaur@gmail.com>");
 MODULE_DESCRIPTION("W83791D driver");
 MODULE_LICENSE("GPL");
-
-module_init(sensors_w83791d_init);
-module_exit(sensors_w83791d_exit);
diff --git a/drivers/hwmon/w83792d.c b/drivers/hwmon/w83792d.c
index e356618..1175dcf 100644
--- a/drivers/hwmon/w83792d.c
+++ b/drivers/hwmon/w83792d.c
@@ -1708,22 +1708,8 @@ static void w83792d_print_debug(struct w83792d_data *data, struct device *dev)
 }
 #endif
 
-static int __init
-sensors_w83792d_init(void)
-{
-	return i2c_add_driver(&w83792d_driver);
-}
-
-static void __exit
-sensors_w83792d_exit(void)
-{
-	i2c_del_driver(&w83792d_driver);
-}
+module_i2c_driver(w83792d_driver);
 
 MODULE_AUTHOR("Chunhao Huang @ Winbond <DZShen@Winbond.com.tw>");
 MODULE_DESCRIPTION("W83792AD/D driver for linux-2.6");
 MODULE_LICENSE("GPL");
-
-module_init(sensors_w83792d_init);
-module_exit(sensors_w83792d_exit);
-
diff --git a/drivers/hwmon/w83793.c b/drivers/hwmon/w83793.c
index 5929d44..47f975c 100644
--- a/drivers/hwmon/w83793.c
+++ b/drivers/hwmon/w83793.c
@@ -2169,19 +2169,8 @@ END:
 	return res;
 }
 
-static int __init sensors_w83793_init(void)
-{
-	return i2c_add_driver(&w83793_driver);
-}
-
-static void __exit sensors_w83793_exit(void)
-{
-	i2c_del_driver(&w83793_driver);
-}
+module_i2c_driver(w83793_driver);
 
 MODULE_AUTHOR("Yuan Mu, Sven Anders");
 MODULE_DESCRIPTION("w83793 driver");
 MODULE_LICENSE("GPL");
-
-module_init(sensors_w83793_init);
-module_exit(sensors_w83793_exit);
diff --git a/drivers/hwmon/w83795.c b/drivers/hwmon/w83795.c
index aa58b25..deb12c9 100644
--- a/drivers/hwmon/w83795.c
+++ b/drivers/hwmon/w83795.c
@@ -2244,19 +2244,8 @@ static struct i2c_driver w83795_driver = {
 	.address_list	= normal_i2c,
 };
 
-static int __init sensors_w83795_init(void)
-{
-	return i2c_add_driver(&w83795_driver);
-}
-
-static void __exit sensors_w83795_exit(void)
-{
-	i2c_del_driver(&w83795_driver);
-}
+module_i2c_driver(w83795_driver);
 
 MODULE_AUTHOR("Wei Song, Jean Delvare <khali@linux-fr.org>");
 MODULE_DESCRIPTION("W83795G/ADG hardware monitoring driver");
 MODULE_LICENSE("GPL");
-
-module_init(sensors_w83795_init);
-module_exit(sensors_w83795_exit);
diff --git a/drivers/hwmon/w83l785ts.c b/drivers/hwmon/w83l785ts.c
index edfc1ec..bc07144 100644
--- a/drivers/hwmon/w83l785ts.c
+++ b/drivers/hwmon/w83l785ts.c
@@ -302,19 +302,8 @@ static struct w83l785ts_data *w83l785ts_update_device(struct device *dev)
 	return data;
 }
 
-static int __init sensors_w83l785ts_init(void)
-{
-	return i2c_add_driver(&w83l785ts_driver);
-}
-
-static void __exit sensors_w83l785ts_exit(void)
-{
-	i2c_del_driver(&w83l785ts_driver);
-}
+module_i2c_driver(w83l785ts_driver);
 
 MODULE_AUTHOR("Jean Delvare <khali@linux-fr.org>");
 MODULE_DESCRIPTION("W83L785TS-S driver");
 MODULE_LICENSE("GPL");
-
-module_init(sensors_w83l785ts_init);
-module_exit(sensors_w83l785ts_exit);
diff --git a/drivers/hwmon/w83l786ng.c b/drivers/hwmon/w83l786ng.c
index 6eac5d9..a6310b8 100644
--- a/drivers/hwmon/w83l786ng.c
+++ b/drivers/hwmon/w83l786ng.c
@@ -806,21 +806,8 @@ static struct w83l786ng_data *w83l786ng_update_device(struct device *dev)
 	return data;
 }
 
-static int __init
-sensors_w83l786ng_init(void)
-{
-	return i2c_add_driver(&w83l786ng_driver);
-}
-
-static void __exit
-sensors_w83l786ng_exit(void)
-{
-	i2c_del_driver(&w83l786ng_driver);
-}
+module_i2c_driver(w83l786ng_driver);
 
 MODULE_AUTHOR("Kevin Lo");
 MODULE_DESCRIPTION("w83l786ng driver");
 MODULE_LICENSE("GPL");
-
-module_init(sensors_w83l786ng_init);
-module_exit(sensors_w83l786ng_exit);
-- 
1.7.5.4



