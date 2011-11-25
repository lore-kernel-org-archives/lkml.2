Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896Ab1KYHGp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 02:06:45 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47214 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894Ab1KYHGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 02:06:43 -0500
Message-ID: <1322204787.11718.1.camel@phoenix>
Subject: [PATCH] hwmon: convert drivers/hwmon/* to use module_i2c_driver()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Corentin Labbe <corentin.labbe@geomatys.fr>, Dirk Eibach <eibach@gdsys.de>,
        "Mark M. Hoffman" <mhoffman@lightlink.com>,
        Steve Glendinning <steve.glendinning@smsc.com>,
        Riku Voipio <riku.voipio@iki.fi>,
        Guillaume Ligneul <guillaume.ligneul@gmail.com>,
        David George <david.george@ska.ac.za>,
        "Hans J. Koch" <hjk@hansjkoch.de>, Marc Hulsman <m.hulsman@tudelft.nl>,
        Rudolf Marek <r.marek@assembler.cz>, Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>, lm-sensors@lm-sensors.org
Date: Fri, 25 Nov 2011 15:06:27 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the drivers in drivers/hwmon/* to use the
module_i2c_driver() macro which makes the code smaller and a bit
simpler.

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
Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/hwmon/ad7414.c      |   12 +-----------
 drivers/hwmon/ad7418.c      |   13 +------------
 drivers/hwmon/adm1021.c     |   13 +------------
 drivers/hwmon/adm1025.c     |   13 +------------
 drivers/hwmon/adm1026.c     |   13 +------------
 drivers/hwmon/adm1029.c     |   18 +-----------------
 drivers/hwmon/adm1031.c     |   13 +------------
 drivers/hwmon/adm9240.c     |   14 +-------------
 drivers/hwmon/ads1015.c     |   13 +------------
 drivers/hwmon/adt7411.c     |   12 +-----------
 drivers/hwmon/adt7462.c     |   13 +------------
 drivers/hwmon/adt7470.c     |   13 +------------
 drivers/hwmon/adt7475.c     |   13 +------------
 drivers/hwmon/amc6821.c     |   15 +--------------
 drivers/hwmon/asb100.c      |   13 +------------
 drivers/hwmon/atxp1.c       |   13 +------------
 drivers/hwmon/ds1621.c      |   14 +-------------
 drivers/hwmon/ds620.c       |   13 +------------
 drivers/hwmon/emc1403.c     |   13 +------------
 drivers/hwmon/emc2103.c     |   13 +------------
 drivers/hwmon/emc6w201.c    |   12 +-----------
 drivers/hwmon/f75375s.c     |   13 +------------
 drivers/hwmon/fschmd.c      |   13 +------------
 drivers/hwmon/g760a.c       |   15 +--------------
 drivers/hwmon/gl518sm.c     |   13 +------------
 drivers/hwmon/gl520sm.c     |   15 +--------------
 drivers/hwmon/jc42.c        |   13 +------------
 drivers/hwmon/lineage-pem.c |   13 +------------
 drivers/hwmon/lm63.c        |   13 +------------
 drivers/hwmon/lm73.c        |   15 +--------------
 drivers/hwmon/lm75.c        |   17 +----------------
 drivers/hwmon/lm77.c        |   13 +------------
 drivers/hwmon/lm80.c        |   13 +------------
 drivers/hwmon/lm83.c        |   13 +------------
 drivers/hwmon/lm85.c        |   14 +-------------
 drivers/hwmon/lm87.c        |   13 +------------
 drivers/hwmon/lm90.c        |   13 +------------
 drivers/hwmon/lm92.c        |   13 +------------
 drivers/hwmon/lm93.c        |   13 +------------
 drivers/hwmon/lm95241.c     |   13 +------------
 drivers/hwmon/lm95245.c     |   13 +------------
 drivers/hwmon/ltc4151.c     |   13 +------------
 drivers/hwmon/ltc4215.c     |   13 +------------
 drivers/hwmon/ltc4245.c     |   13 +------------
 drivers/hwmon/ltc4261.c     |   13 +------------
 drivers/hwmon/max16065.c    |   13 +------------
 drivers/hwmon/max1619.c     |   13 +------------
 drivers/hwmon/max1668.c     |   13 +------------
 drivers/hwmon/max6639.c     |   13 +------------
 drivers/hwmon/max6642.c     |   13 +------------
 drivers/hwmon/max6650.c     |   13 +------------
 drivers/hwmon/sht21.c       |   23 +----------------------
 drivers/hwmon/smm665.c      |   13 +------------
 drivers/hwmon/smsc47m192.c  |   13 +------------
 drivers/hwmon/thmc50.c      |   13 +------------
 drivers/hwmon/tmp102.c      |   12 +-----------
 drivers/hwmon/tmp401.c      |   13 +------------
 drivers/hwmon/tmp421.c      |   13 +------------
 drivers/hwmon/w83791d.c     |   13 +------------
 drivers/hwmon/w83792d.c     |   16 +---------------
 drivers/hwmon/w83793.c      |   13 +------------
 drivers/hwmon/w83795.c      |   13 +------------
 drivers/hwmon/w83l785ts.c   |   13 +------------
 drivers/hwmon/w83l786ng.c   |   15 +--------------
 64 files changed, 64 insertions(+), 799 deletions(-)

diff --git a/drivers/hwmon/ad7414.c b/drivers/hwmon/ad7414.c
index df29a7f..22c2420 100644
--- a/drivers/hwmon/ad7414.c
+++ b/drivers/hwmon/ad7414.c
@@ -252,17 +252,7 @@ static struct i2c_driver ad7414_driver = {
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
index 8cb718c..367244b 100644
--- a/drivers/hwmon/ad7418.c
+++ b/drivers/hwmon/ad7418.c
@@ -289,20 +289,9 @@ static int ad7418_remove(struct i2c_client *client)
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
index 1ad0a88..5498aee 100644
--- a/drivers/hwmon/adm1021.c
+++ b/drivers/hwmon/adm1021.c
@@ -451,15 +451,7 @@ static struct adm1021_data *adm1021_update_device(struct device *dev)
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
 
 MODULE_AUTHOR ("Frodo Looijaard <frodol@dds.nl> and "
 		"Philip Edelbrock <phil@netroedge.com>");
@@ -468,6 +460,3 @@ MODULE_LICENSE("GPL");
 
 module_param(read_only, bool, 0);
 MODULE_PARM_DESC(read_only, "Don't set any values, read only mode");
-
-module_init(sensors_adm1021_init)
-module_exit(sensors_adm1021_exit)
diff --git a/drivers/hwmon/adm1025.c b/drivers/hwmon/adm1025.c
index 60befc0..f02c38b 100644
--- a/drivers/hwmon/adm1025.c
+++ b/drivers/hwmon/adm1025.c
@@ -589,19 +589,8 @@ static struct adm1025_data *adm1025_update_device(struct device *dev)
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
index 0531867..be17083 100644
--- a/drivers/hwmon/adm1026.c
+++ b/drivers/hwmon/adm1026.c
@@ -1761,20 +1761,9 @@ static int adm1026_remove(struct i2c_client *client)
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
index 0b8a3b1..8e5adb2 100644
--- a/drivers/hwmon/adm1029.c
+++ b/drivers/hwmon/adm1029.c
@@ -446,24 +446,8 @@ static struct adm1029_data *adm1029_update_device(struct device *dev)
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
index 0683e6b..71be42c 100644
--- a/drivers/hwmon/adm1031.c
+++ b/drivers/hwmon/adm1031.c
@@ -1078,19 +1078,8 @@ static struct adm1031_data *adm1031_update_device(struct device *dev)
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
index 9e234b9..5e307ba 100644
--- a/drivers/hwmon/adm9240.c
+++ b/drivers/hwmon/adm9240.c
@@ -795,21 +795,9 @@ static struct adm9240_data *adm9240_update_device(struct device *dev)
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
index 5cc3e37..e4d86ca 100644
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
index 2af0c7b..1beb8a9 100644
--- a/drivers/hwmon/adt7462.c
+++ b/drivers/hwmon/adt7462.c
@@ -1975,19 +1975,8 @@ static int adt7462_remove(struct i2c_client *client)
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
index c6d1ce0..ddca215 100644
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
index b5fcd87..c753548 100644
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
index 4033974..da6ca4f 100644
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
index d7bd1f3..0f300c6 100644
--- a/drivers/hwmon/asb100.c
+++ b/drivers/hwmon/asb100.c
@@ -971,19 +971,8 @@ static struct asb100_data *asb100_update_device(struct device *dev)
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
index 33cc143..701bc9d 100644
--- a/drivers/hwmon/atxp1.c
+++ b/drivers/hwmon/atxp1.c
@@ -367,15 +367,4 @@ static int atxp1_remove(struct i2c_client *client)
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
index ef1ac996..9832ac5 100644
--- a/drivers/hwmon/ds1621.c
+++ b/drivers/hwmon/ds1621.c
@@ -305,20 +305,8 @@ static struct i2c_driver ds1621_driver = {
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
index 225ae4f..2e2b430 100644
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
index cd2a6e4..223bd3c 100644
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
index af914ad9..c251445 100644
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
index 0064432..cbef6e1 100644
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
index 95cbfb3..8326084 100644
--- a/drivers/hwmon/f75375s.c
+++ b/drivers/hwmon/f75375s.c
@@ -699,19 +699,8 @@ static int f75375_detect(struct i2c_client *client,
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
 MODULE_DESCRIPTION("F75373/F75375 hardware monitoring driver");
-
-module_init(sensors_f75375_init);
-module_exit(sensors_f75375_exit);
diff --git a/drivers/hwmon/fschmd.c b/drivers/hwmon/fschmd.c
index aa6d8b6..73ba942 100644
--- a/drivers/hwmon/fschmd.c
+++ b/drivers/hwmon/fschmd.c
@@ -1314,20 +1314,9 @@ static struct fschmd_data *fschmd_update_device(struct device *dev)
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
index 1d6a6fa..f8cd5a9 100644
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
index a13e2da..89b8c0a 100644
--- a/drivers/hwmon/gl518sm.c
+++ b/drivers/hwmon/gl518sm.c
@@ -676,21 +676,10 @@ static struct gl518_data *gl518_update_device(struct device *dev)
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
index cd6085b..e6dcf66 100644
--- a/drivers/hwmon/gl520sm.c
+++ b/drivers/hwmon/gl520sm.c
@@ -910,23 +910,10 @@ static struct gl520_data *gl520_update_device(struct device *dev)
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
index 2d3d728..d33c592 100644
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
index 9642286..2eae1bc 100644
--- a/drivers/hwmon/lm63.c
+++ b/drivers/hwmon/lm63.c
@@ -727,19 +727,8 @@ static struct lm63_data *lm63_update_device(struct device *dev)
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
index 9e64d96..2c63f14 100644
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
index 1888dd0..f3aaa30 100644
--- a/drivers/hwmon/lm75.c
+++ b/drivers/hwmon/lm75.c
@@ -429,23 +429,8 @@ static struct lm75_data *lm75_update_device(struct device *dev)
 	return data;
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
index 8dfc678..7cd516f 100644
--- a/drivers/hwmon/lm77.c
+++ b/drivers/hwmon/lm77.c
@@ -420,19 +420,8 @@ static struct lm77_data *lm77_update_device(struct device *dev)
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
index 18a0e6c..dc983ec 100644
--- a/drivers/hwmon/lm80.c
+++ b/drivers/hwmon/lm80.c
@@ -595,20 +595,9 @@ static struct lm80_data *lm80_update_device(struct device *dev)
 	return data;
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
index 8290476..e9a8a06 100644
--- a/drivers/hwmon/lm83.c
+++ b/drivers/hwmon/lm83.c
@@ -423,19 +423,8 @@ static struct lm83_data *lm83_update_device(struct device *dev)
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
index da72dc1..fd26983 100644
--- a/drivers/hwmon/lm85.c
+++ b/drivers/hwmon/lm85.c
@@ -1611,22 +1611,10 @@ static struct lm85_data *lm85_update_device(struct device *dev)
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
index f1e6e75..126d0cc 100644
--- a/drivers/hwmon/lm87.c
+++ b/drivers/hwmon/lm87.c
@@ -963,19 +963,8 @@ static struct lm87_data *lm87_update_device(struct device *dev)
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
index 615bc4f..e70cbb9 100644
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
index 8fcbd4d4..92f2d46 100644
--- a/drivers/hwmon/lm92.c
+++ b/drivers/hwmon/lm92.c
@@ -416,19 +416,8 @@ static struct i2c_driver lm92_driver = {
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
index 3b43df4..cb1bf8c 100644
--- a/drivers/hwmon/lm93.c
+++ b/drivers/hwmon/lm93.c
@@ -2635,20 +2635,9 @@ static struct i2c_driver lm93_driver = {
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
index 513901d..6074afd 100644
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
index dce9e68..87de7de 100644
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
index 4b50601..c78d323 100644
--- a/drivers/hwmon/ltc4261.c
+++ b/drivers/hwmon/ltc4261.c
@@ -296,19 +296,8 @@ static struct i2c_driver ltc4261_driver = {
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
index 385886a..ca18f52 100644
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
index 022ded0..135822e 100644
--- a/drivers/hwmon/max1619.c
+++ b/drivers/hwmon/max1619.c
@@ -353,20 +353,9 @@ static struct max1619_data *max1619_update_device(struct device *dev)
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
index 20d1b2d..d5fb117 100644
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
index f20d997..64866a9 100644
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
index e855d3b..66f0dbc 100644
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
index ece3aaf..7a0cdb0 100644
--- a/drivers/hwmon/max6650.c
+++ b/drivers/hwmon/max6650.c
@@ -713,19 +713,8 @@ static struct max6650_data *max6650_update_device(struct device *dev)
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
index 4116381..0d392d0 100644
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
index 40b2667..8f88908 100644
--- a/drivers/hwmon/smsc47m192.c
+++ b/drivers/hwmon/smsc47m192.c
@@ -635,19 +635,8 @@ static struct smsc47m192_data *smsc47m192_update_device(struct device *dev)
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
index 7dfb4de..bd83bc0 100644
--- a/drivers/hwmon/thmc50.c
+++ b/drivers/hwmon/thmc50.c
@@ -465,18 +465,7 @@ static struct thmc50_data *thmc50_update_device(struct device *dev)
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
index 643aa8c..40b742c 100644
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
index ad8d535..a32d4dc 100644
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
index 0517a8f..aa5562d 100644
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
index 8c2844e..1729f14 100644
--- a/drivers/hwmon/w83791d.c
+++ b/drivers/hwmon/w83791d.c
@@ -1625,19 +1625,8 @@ static void w83791d_print_debug(struct w83791d_data *data, struct device *dev)
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
index f3e7130..43246e8 100644
--- a/drivers/hwmon/w83792d.c
+++ b/drivers/hwmon/w83792d.c
@@ -1641,22 +1641,8 @@ static void w83792d_print_debug(struct w83792d_data *data, struct device *dev)
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
index 854f911..77dd465 100644
--- a/drivers/hwmon/w83793.c
+++ b/drivers/hwmon/w83793.c
@@ -2120,19 +2120,8 @@ END:
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
index 845232d..25d741d 100644
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
index 20781de..57f639e 100644
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
index 0254e18..8b120eb 100644
--- a/drivers/hwmon/w83l786ng.c
+++ b/drivers/hwmon/w83l786ng.c
@@ -769,21 +769,8 @@ static struct w83l786ng_data *w83l786ng_update_device(struct device *dev)
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



