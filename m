Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751012Ab2AVHg4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 02:36:56 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51063 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722Ab2AVHgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 02:36:55 -0500
Message-ID: <1327217805.6497.2.camel@phoenix>
Subject: [PATCH 2/3] MISC: convert drivers/misc/* to use module_i2c_driver()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Michael Hennerich <hennerich@blackfin.uclinux.org>,
        Anantha Narayanan <Anantha.Narayanan@intel.com>,
        Hemanth V <hemanthv@ti.com>, Christoph Mair <christoph.mair@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Ben Gardner <bgardner@wabtec.com>, Minkyu Kang <mk7.kang@samsung.com>,
        Kalhan Trisal <kalhan.trisal@intel.com>,
        "Darrick J. Wong" <djwong@us.ibm.com>, Daniel Mack <zonque@gmail.com>,
        Rodolfo Giometti <giometti@linux.it>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <greg@kroah.com>
Date: Sun, 22 Jan 2012 15:36:45 +0800
In-Reply-To: <1327217629.6497.0.camel@phoenix>
References: <1327217629.6497.0.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the drivers in drivers/misc/* to use the
module_i2c_driver() macro which makes the code smaller and a bit
simpler.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Michael Hennerich <hennerich@blackfin.uclinux.org>
Cc: Anantha Narayanan <Anantha.Narayanan@intel.com>
Cc: Hemanth V <hemanthv@ti.com>
Cc: Christoph Mair <christoph.mair@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Ben Gardner <bgardner@wabtec.com>
Cc: Minkyu Kang <mk7.kang@samsung.com>
Cc: Kalhan Trisal <kalhan.trisal@intel.com>
Cc: Darrick J. Wong <djwong@us.ibm.com>
Cc: Daniel Mack <zonque@gmail.com>
Cc: Rodolfo Giometti <giometti@linux.it>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/misc/ad525x_dpot-i2c.c         |   12 +-----------
 drivers/misc/apds9802als.c             |   12 +-----------
 drivers/misc/apds990x.c                |   13 +------------
 drivers/misc/bh1770glc.c               |   13 +------------
 drivers/misc/bh1780gli.c               |   15 ++-------------
 drivers/misc/bmp085.c                  |   14 +-------------
 drivers/misc/ds1682.c                  |   13 +------------
 drivers/misc/eeprom/eeprom.c           |   14 +-------------
 drivers/misc/eeprom/max6875.c          |   14 +-------------
 drivers/misc/fsa9480.c                 |   12 +-----------
 drivers/misc/hmc6352.c                 |   13 +------------
 drivers/misc/ics932s401.c              |   13 +------------
 drivers/misc/isl29003.c                |   14 +-------------
 drivers/misc/isl29020.c                |   13 +------------
 drivers/misc/lis3lv02d/lis3lv02d_i2c.c |   13 +------------
 drivers/misc/tsl2550.c                 |   13 +------------
 16 files changed, 17 insertions(+), 194 deletions(-)

diff --git a/drivers/misc/ad525x_dpot-i2c.c b/drivers/misc/ad525x_dpot-i2c.c
index 83adab6..8208262 100644
--- a/drivers/misc/ad525x_dpot-i2c.c
+++ b/drivers/misc/ad525x_dpot-i2c.c
@@ -113,17 +113,7 @@ static struct i2c_driver ad_dpot_i2c_driver = {
 	.id_table	= ad_dpot_id,
 };
 
-static int __init ad_dpot_i2c_init(void)
-{
-	return i2c_add_driver(&ad_dpot_i2c_driver);
-}
-module_init(ad_dpot_i2c_init);
-
-static void __exit ad_dpot_i2c_exit(void)
-{
-	i2c_del_driver(&ad_dpot_i2c_driver);
-}
-module_exit(ad_dpot_i2c_exit);
+module_i2c_driver(ad_dpot_i2c_driver);
 
 MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>");
 MODULE_DESCRIPTION("digital potentiometer I2C bus driver");
diff --git a/drivers/misc/apds9802als.c b/drivers/misc/apds9802als.c
index 81db781..0314773 100644
--- a/drivers/misc/apds9802als.c
+++ b/drivers/misc/apds9802als.c
@@ -332,17 +332,7 @@ static struct i2c_driver apds9802als_driver = {
 	.id_table = apds9802als_id,
 };
 
-static int __init sensor_apds9802als_init(void)
-{
-	return i2c_add_driver(&apds9802als_driver);
-}
-
-static void  __exit sensor_apds9802als_exit(void)
-{
-	i2c_del_driver(&apds9802als_driver);
-}
-module_init(sensor_apds9802als_init);
-module_exit(sensor_apds9802als_exit);
+module_i2c_driver(apds9802als_driver);
 
 MODULE_AUTHOR("Anantha Narayanan <Anantha.Narayanan@intel.com");
 MODULE_DESCRIPTION("Avago apds9802als ALS Driver");
diff --git a/drivers/misc/apds990x.c b/drivers/misc/apds990x.c
index e2a52e5..ee74244 100644
--- a/drivers/misc/apds990x.c
+++ b/drivers/misc/apds990x.c
@@ -1279,19 +1279,8 @@ static struct i2c_driver apds990x_driver = {
 	.id_table = apds990x_id,
 };
 
-static int __init apds990x_init(void)
-{
-	return i2c_add_driver(&apds990x_driver);
-}
-
-static void __exit apds990x_exit(void)
-{
-	i2c_del_driver(&apds990x_driver);
-}
+module_i2c_driver(apds990x_driver);
 
 MODULE_DESCRIPTION("APDS990X combined ALS and proximity sensor");
 MODULE_AUTHOR("Samu Onkalo, Nokia Corporation");
 MODULE_LICENSE("GPL v2");
-
-module_init(apds990x_init);
-module_exit(apds990x_exit);
diff --git a/drivers/misc/bh1770glc.c b/drivers/misc/bh1770glc.c
index d79a972..3d56ae7 100644
--- a/drivers/misc/bh1770glc.c
+++ b/drivers/misc/bh1770glc.c
@@ -1399,19 +1399,8 @@ static struct i2c_driver bh1770_driver = {
 	.id_table = bh1770_id,
 };
 
-static int __init bh1770_init(void)
-{
-	return i2c_add_driver(&bh1770_driver);
-}
-
-static void __exit bh1770_exit(void)
-{
-	i2c_del_driver(&bh1770_driver);
-}
+module_i2c_driver(bh1770_driver);
 
 MODULE_DESCRIPTION("BH1770GLC / SFH7770 combined ALS and proximity sensor");
 MODULE_AUTHOR("Samu Onkalo, Nokia Corporation");
 MODULE_LICENSE("GPL v2");
-
-module_init(bh1770_init);
-module_exit(bh1770_exit);
diff --git a/drivers/misc/bh1780gli.c b/drivers/misc/bh1780gli.c
index bfeea9b..54f6f39 100644
--- a/drivers/misc/bh1780gli.c
+++ b/drivers/misc/bh1780gli.c
@@ -253,21 +253,10 @@ static struct i2c_driver bh1780_driver = {
 	.driver = {
 		.name = "bh1780",
 		.pm	= BH1780_PMOPS,
-},
+	},
 };
 
-static int __init bh1780_init(void)
-{
-	return i2c_add_driver(&bh1780_driver);
-}
-
-static void __exit bh1780_exit(void)
-{
-	i2c_del_driver(&bh1780_driver);
-}
-
-module_init(bh1780_init)
-module_exit(bh1780_exit)
+module_i2c_driver(bh1780_driver);
 
 MODULE_DESCRIPTION("BH1780GLI Ambient Light Sensor Driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/misc/bmp085.c b/drivers/misc/bmp085.c
index b29a2be..3c534ab 100644
--- a/drivers/misc/bmp085.c
+++ b/drivers/misc/bmp085.c
@@ -464,20 +464,8 @@ static struct i2c_driver bmp085_driver = {
 	.address_list	= normal_i2c
 };
 
-static int __init bmp085_init(void)
-{
-	return i2c_add_driver(&bmp085_driver);
-}
-
-static void __exit bmp085_exit(void)
-{
-	i2c_del_driver(&bmp085_driver);
-}
-
+module_i2c_driver(bmp085_driver);
 
 MODULE_AUTHOR("Christoph Mair <christoph.mair@gmail.com");
 MODULE_DESCRIPTION("BMP085 driver");
 MODULE_LICENSE("GPL");
-
-module_init(bmp085_init);
-module_exit(bmp085_exit);
diff --git a/drivers/misc/ds1682.c b/drivers/misc/ds1682.c
index a513f0a..154b02e 100644
--- a/drivers/misc/ds1682.c
+++ b/drivers/misc/ds1682.c
@@ -250,19 +250,8 @@ static struct i2c_driver ds1682_driver = {
 	.id_table = ds1682_id,
 };
 
-static int __init ds1682_init(void)
-{
-	return i2c_add_driver(&ds1682_driver);
-}
-
-static void __exit ds1682_exit(void)
-{
-	i2c_del_driver(&ds1682_driver);
-}
+module_i2c_driver(ds1682_driver);
 
 MODULE_AUTHOR("Grant Likely <grant.likely@secretlab.ca>");
 MODULE_DESCRIPTION("DS1682 Elapsed Time Indicator driver");
 MODULE_LICENSE("GPL");
-
-module_init(ds1682_init);
-module_exit(ds1682_exit);
diff --git a/drivers/misc/eeprom/eeprom.c b/drivers/misc/eeprom/eeprom.c
index 45060dd..c169e07 100644
--- a/drivers/misc/eeprom/eeprom.c
+++ b/drivers/misc/eeprom/eeprom.c
@@ -229,22 +229,10 @@ static struct i2c_driver eeprom_driver = {
 	.address_list	= normal_i2c,
 };
 
-static int __init eeprom_init(void)
-{
-	return i2c_add_driver(&eeprom_driver);
-}
-
-static void __exit eeprom_exit(void)
-{
-	i2c_del_driver(&eeprom_driver);
-}
-
+module_i2c_driver(eeprom_driver);
 
 MODULE_AUTHOR("Frodo Looijaard <frodol@dds.nl> and "
 		"Philip Edelbrock <phil@netroedge.com> and "
 		"Greg Kroah-Hartman <greg@kroah.com>");
 MODULE_DESCRIPTION("I2C EEPROM driver");
 MODULE_LICENSE("GPL");
-
-module_init(eeprom_init);
-module_exit(eeprom_exit);
diff --git a/drivers/misc/eeprom/max6875.c b/drivers/misc/eeprom/max6875.c
index 5653a3c..e36157d 100644
--- a/drivers/misc/eeprom/max6875.c
+++ b/drivers/misc/eeprom/max6875.c
@@ -208,20 +208,8 @@ static struct i2c_driver max6875_driver = {
 	.id_table	= max6875_id,
 };
 
-static int __init max6875_init(void)
-{
-	return i2c_add_driver(&max6875_driver);
-}
-
-static void __exit max6875_exit(void)
-{
-	i2c_del_driver(&max6875_driver);
-}
-
+module_i2c_driver(max6875_driver);
 
 MODULE_AUTHOR("Ben Gardner <bgardner@wabtec.com>");
 MODULE_DESCRIPTION("MAX6875 driver");
 MODULE_LICENSE("GPL");
-
-module_init(max6875_init);
-module_exit(max6875_exit);
diff --git a/drivers/misc/fsa9480.c b/drivers/misc/fsa9480.c
index f6586d5..483d6b7 100644
--- a/drivers/misc/fsa9480.c
+++ b/drivers/misc/fsa9480.c
@@ -541,17 +541,7 @@ static struct i2c_driver fsa9480_i2c_driver = {
 	.id_table = fsa9480_id,
 };
 
-static int __init fsa9480_init(void)
-{
-	return i2c_add_driver(&fsa9480_i2c_driver);
-}
-module_init(fsa9480_init);
-
-static void __exit fsa9480_exit(void)
-{
-	i2c_del_driver(&fsa9480_i2c_driver);
-}
-module_exit(fsa9480_exit);
+module_i2c_driver(fsa9480_i2c_driver);
 
 MODULE_AUTHOR("Minkyu Kang <mk7.kang@samsung.com>");
 MODULE_DESCRIPTION("FSA9480 USB Switch driver");
diff --git a/drivers/misc/hmc6352.c b/drivers/misc/hmc6352.c
index ca938fc..423cd40 100644
--- a/drivers/misc/hmc6352.c
+++ b/drivers/misc/hmc6352.c
@@ -148,18 +148,7 @@ static struct i2c_driver hmc6352_driver = {
 	.id_table = hmc6352_id,
 };
 
-static int __init sensor_hmc6352_init(void)
-{
-	return i2c_add_driver(&hmc6352_driver);
-}
-
-static void  __exit sensor_hmc6352_exit(void)
-{
-	i2c_del_driver(&hmc6352_driver);
-}
-
-module_init(sensor_hmc6352_init);
-module_exit(sensor_hmc6352_exit);
+module_i2c_driver(hmc6352_driver);
 
 MODULE_AUTHOR("Kalhan Trisal <kalhan.trisal@intel.com");
 MODULE_DESCRIPTION("hmc6352 Compass Driver");
diff --git a/drivers/misc/ics932s401.c b/drivers/misc/ics932s401.c
index 152e9d9..0029536 100644
--- a/drivers/misc/ics932s401.c
+++ b/drivers/misc/ics932s401.c
@@ -480,23 +480,12 @@ static int ics932s401_remove(struct i2c_client *client)
 	return 0;
 }
 
-static int __init ics932s401_init(void)
-{
-	return i2c_add_driver(&ics932s401_driver);
-}
-
-static void __exit ics932s401_exit(void)
-{
-	i2c_del_driver(&ics932s401_driver);
-}
+module_i2c_driver(ics932s401_driver);
 
 MODULE_AUTHOR("Darrick J. Wong <djwong@us.ibm.com>");
 MODULE_DESCRIPTION("ICS932S401 driver");
 MODULE_LICENSE("GPL");
 
-module_init(ics932s401_init);
-module_exit(ics932s401_exit);
-
 /* IBM IntelliStation Z30 */
 MODULE_ALIAS("dmi:bvnIBM:*:rn9228:*");
 MODULE_ALIAS("dmi:bvnIBM:*:rn9232:*");
diff --git a/drivers/misc/isl29003.c b/drivers/misc/isl29003.c
index a71e245..eb5de2e 100644
--- a/drivers/misc/isl29003.c
+++ b/drivers/misc/isl29003.c
@@ -455,21 +455,9 @@ static struct i2c_driver isl29003_driver = {
 	.id_table = isl29003_id,
 };
 
-static int __init isl29003_init(void)
-{
-	return i2c_add_driver(&isl29003_driver);
-}
-
-static void __exit isl29003_exit(void)
-{
-	i2c_del_driver(&isl29003_driver);
-}
+module_i2c_driver(isl29003_driver);
 
 MODULE_AUTHOR("Daniel Mack <daniel@caiaq.de>");
 MODULE_DESCRIPTION("ISL29003 ambient light sensor driver");
 MODULE_LICENSE("GPL v2");
 MODULE_VERSION(DRIVER_VERSION);
-
-module_init(isl29003_init);
-module_exit(isl29003_exit);
-
diff --git a/drivers/misc/isl29020.c b/drivers/misc/isl29020.c
index 3d6cce6..0aa08c7 100644
--- a/drivers/misc/isl29020.c
+++ b/drivers/misc/isl29020.c
@@ -230,18 +230,7 @@ static struct i2c_driver isl29020_driver = {
 	.id_table = isl29020_id,
 };
 
-static int __init sensor_isl29020_init(void)
-{
-	return i2c_add_driver(&isl29020_driver);
-}
-
-static void  __exit sensor_isl29020_exit(void)
-{
-	i2c_del_driver(&isl29020_driver);
-}
-
-module_init(sensor_isl29020_init);
-module_exit(sensor_isl29020_exit);
+module_i2c_driver(isl29020_driver);
 
 MODULE_AUTHOR("Kalhan Trisal <kalhan.trisal@intel.com>");
 MODULE_DESCRIPTION("Intersil isl29020 ALS Driver");
diff --git a/drivers/misc/lis3lv02d/lis3lv02d_i2c.c b/drivers/misc/lis3lv02d/lis3lv02d_i2c.c
index c02fea0..e8c0019 100644
--- a/drivers/misc/lis3lv02d/lis3lv02d_i2c.c
+++ b/drivers/misc/lis3lv02d/lis3lv02d_i2c.c
@@ -256,19 +256,8 @@ static struct i2c_driver lis3lv02d_i2c_driver = {
 	.id_table = lis3lv02d_id,
 };
 
-static int __init lis3lv02d_init(void)
-{
-	return i2c_add_driver(&lis3lv02d_i2c_driver);
-}
-
-static void __exit lis3lv02d_exit(void)
-{
-	i2c_del_driver(&lis3lv02d_i2c_driver);
-}
+module_i2c_driver(lis3lv02d_i2c_driver);
 
 MODULE_AUTHOR("Nokia Corporation");
 MODULE_DESCRIPTION("lis3lv02d I2C interface");
 MODULE_LICENSE("GPL");
-
-module_init(lis3lv02d_init);
-module_exit(lis3lv02d_exit);
diff --git a/drivers/misc/tsl2550.c b/drivers/misc/tsl2550.c
index 483ae5f..0beb298 100644
--- a/drivers/misc/tsl2550.c
+++ b/drivers/misc/tsl2550.c
@@ -454,20 +454,9 @@ static struct i2c_driver tsl2550_driver = {
 	.id_table = tsl2550_id,
 };
 
-static int __init tsl2550_init(void)
-{
-	return i2c_add_driver(&tsl2550_driver);
-}
-
-static void __exit tsl2550_exit(void)
-{
-	i2c_del_driver(&tsl2550_driver);
-}
+module_i2c_driver(tsl2550_driver);
 
 MODULE_AUTHOR("Rodolfo Giometti <giometti@linux.it>");
 MODULE_DESCRIPTION("TSL2550 ambient light sensor driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRIVER_VERSION);
-
-module_init(tsl2550_init);
-module_exit(tsl2550_exit);
-- 
1.7.5.4



