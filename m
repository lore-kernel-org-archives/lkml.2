Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932694Ab2AUKLS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 05:11:18 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38906 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932680Ab2AUKLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 05:11:07 -0500
Message-ID: <1327140645.3928.1.camel@phoenix>
Subject: [PATCH] [media] convert drivers/media/* to use module_i2c_driver()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Heungjun Kim <riverful.kim@samsung.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Tomasz Stanislawski <t.stanislaws@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Andrew Chew <achew@nvidia.com>, Paul Mundt <lethal@linux-sh.org>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Johannes Obermaier <johannes.obermaier@gmail.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Steven Toth <stoth@kernellabs.com>, linux-media@vger.kernel.org
Date: Sat, 21 Jan 2012 18:10:45 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the drivers in drivers/media/* to use the
module_i2_driver() macro which makes the code smaller and a bit simpler.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Heungjun Kim <riverful.kim@samsung.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Joonyoung Shim <jy0922.shim@samsung.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Andrew Chew <achew@nvidia.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Michael Grzeschik <m.grzeschik@pengutronix.de>
Cc: Johannes Obermaier <johannes.obermaier@gmail.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Steven Toth <stoth@kernellabs.com>
---
 drivers/media/dvb/frontends/au8522_decoder.c  |   13 +----------
 drivers/media/radio/radio-tea5764.c           |   19 +----------------
 drivers/media/radio/saa7706h.c                |   13 +----------
 drivers/media/radio/si470x/radio-si470x-i2c.c |   28 +------------------------
 drivers/media/radio/si4713-i2c.c              |   15 +------------
 drivers/media/radio/tef6862.c                 |   14 +-----------
 drivers/media/video/adp1653.c                 |   19 +----------------
 drivers/media/video/adv7170.c                 |   13 +----------
 drivers/media/video/adv7175.c                 |   13 +----------
 drivers/media/video/adv7180.c                 |   14 +-----------
 drivers/media/video/adv7343.c                 |   13 +----------
 drivers/media/video/ak881x.c                  |   13 +----------
 drivers/media/video/as3645a.c                 |   19 +----------------
 drivers/media/video/bt819.c                   |   13 +----------
 drivers/media/video/bt856.c                   |   13 +----------
 drivers/media/video/bt866.c                   |   13 +----------
 drivers/media/video/cs5345.c                  |   13 +----------
 drivers/media/video/cs53l32a.c                |   13 +----------
 drivers/media/video/cx25840/cx25840-core.c    |   13 +----------
 drivers/media/video/imx074.c                  |   13 +----------
 drivers/media/video/indycam.c                 |   13 +----------
 drivers/media/video/ir-kbd-i2c.c              |   17 ++------------
 drivers/media/video/ks0127.c                  |   13 +----------
 drivers/media/video/m52790.c                  |   13 +----------
 drivers/media/video/m5mols/m5mols_core.c      |   13 +----------
 drivers/media/video/msp3400-driver.c          |   13 +----------
 drivers/media/video/mt9m001.c                 |   13 +----------
 drivers/media/video/mt9m111.c                 |   13 +----------
 drivers/media/video/mt9p031.c                 |   13 +----------
 drivers/media/video/mt9t001.c                 |   13 +----------
 drivers/media/video/mt9t031.c                 |   13 +----------
 drivers/media/video/mt9t112.c                 |   16 +-------------
 drivers/media/video/mt9v011.c                 |   13 +----------
 drivers/media/video/mt9v022.c                 |   13 +----------
 drivers/media/video/mt9v032.c                 |   13 +----------
 drivers/media/video/noon010pc30.c             |   13 +----------
 drivers/media/video/ov2640.c                  |   16 +-------------
 drivers/media/video/ov5642.c                  |   13 +----------
 drivers/media/video/ov6650.c                  |   13 +----------
 drivers/media/video/ov7670.c                  |   13 +----------
 drivers/media/video/ov772x.c                  |   17 +--------------
 drivers/media/video/ov9640.c                  |   13 +----------
 drivers/media/video/ov9740.c                  |   13 +----------
 drivers/media/video/rj54n1cb0c.c              |   13 +----------
 drivers/media/video/s5k6aa.c                  |   13 +----------
 drivers/media/video/s5p-tv/hdmiphy_drv.c      |   12 +---------
 drivers/media/video/saa6588.c                 |   13 +----------
 drivers/media/video/saa7110.c                 |   13 +----------
 drivers/media/video/saa7115.c                 |   13 +----------
 drivers/media/video/saa7127.c                 |   13 +----------
 drivers/media/video/saa7134/saa6752hs.c       |   13 +----------
 drivers/media/video/saa717x.c                 |   13 +----------
 drivers/media/video/saa7185.c                 |   13 +----------
 drivers/media/video/saa7191.c                 |   13 +----------
 drivers/media/video/sr030pc30.c               |   13 +----------
 drivers/media/video/tda7432.c                 |   13 +----------
 drivers/media/video/tda9840.c                 |   13 +----------
 drivers/media/video/tea6415c.c                |   13 +----------
 drivers/media/video/tea6420.c                 |   13 +----------
 drivers/media/video/ths7303.c                 |   14 +-----------
 drivers/media/video/tlv320aic23b.c            |   13 +----------
 drivers/media/video/tuner-core.c              |   13 +----------
 drivers/media/video/tvaudio.c                 |   13 +----------
 drivers/media/video/tvp514x.c                 |   13 +----------
 drivers/media/video/tvp5150.c                 |   13 +----------
 drivers/media/video/tvp7002.c                 |   25 +---------------------
 drivers/media/video/tw9910.c                  |   16 +-------------
 drivers/media/video/upd64031a.c               |   13 +----------
 drivers/media/video/upd64083.c                |   13 +----------
 drivers/media/video/vp27smpx.c                |   13 +----------
 drivers/media/video/vpx3220.c                 |   13 +----------
 drivers/media/video/wm8739.c                  |   13 +----------
 drivers/media/video/wm8775.c                  |   13 +----------
 73 files changed, 75 insertions(+), 940 deletions(-)

diff --git a/drivers/media/dvb/frontends/au8522_decoder.c b/drivers/media/dvb/frontends/au8522_decoder.c
index 2b248c1..55b6390 100644
--- a/drivers/media/dvb/frontends/au8522_decoder.c
+++ b/drivers/media/dvb/frontends/au8522_decoder.c
@@ -839,15 +839,4 @@ static struct i2c_driver au8522_driver = {
 	.id_table	= au8522_id,
 };
 
-static __init int init_au8522(void)
-{
-	return i2c_add_driver(&au8522_driver);
-}
-
-static __exit void exit_au8522(void)
-{
-	i2c_del_driver(&au8522_driver);
-}
-
-module_init(init_au8522);
-module_exit(exit_au8522);
+module_i2c_driver(au8522_driver);
diff --git a/drivers/media/radio/radio-tea5764.c b/drivers/media/radio/radio-tea5764.c
index db20904..6b1fae3 100644
--- a/drivers/media/radio/radio-tea5764.c
+++ b/drivers/media/radio/radio-tea5764.c
@@ -575,21 +575,7 @@ static struct i2c_driver tea5764_i2c_driver = {
 	.id_table = tea5764_id,
 };
 
-/* init the driver */
-static int __init tea5764_init(void)
-{
-	int ret = i2c_add_driver(&tea5764_i2c_driver);
-
-	printk(KERN_INFO KBUILD_MODNAME ": " DRIVER_VERSION ": "
-		DRIVER_DESC "\n");
-	return ret;
-}
-
-/* cleanup the driver */
-static void __exit tea5764_exit(void)
-{
-	i2c_del_driver(&tea5764_i2c_driver);
-}
+module_i2c_driver(tea5764_i2c_driver);
 
 MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_DESCRIPTION(DRIVER_DESC);
@@ -600,6 +586,3 @@ module_param(use_xtal, int, 0);
 MODULE_PARM_DESC(use_xtal, "Chip have a xtal connected in board");
 module_param(radio_nr, int, 0);
 MODULE_PARM_DESC(radio_nr, "video4linux device number to use");
-
-module_init(tea5764_init);
-module_exit(tea5764_exit);
diff --git a/drivers/media/radio/saa7706h.c b/drivers/media/radio/saa7706h.c
index b1193df..9474706 100644
--- a/drivers/media/radio/saa7706h.c
+++ b/drivers/media/radio/saa7706h.c
@@ -434,18 +434,7 @@ static struct i2c_driver saa7706h_driver = {
 	.id_table	= saa7706h_id,
 };
 
-static __init int saa7706h_init(void)
-{
-	return i2c_add_driver(&saa7706h_driver);
-}
-
-static __exit void saa7706h_exit(void)
-{
-	i2c_del_driver(&saa7706h_driver);
-}
-
-module_init(saa7706h_init);
-module_exit(saa7706h_exit);
+module_i2c_driver(saa7706h_driver);
 
 MODULE_DESCRIPTION("SAA7706H Car Radio DSP driver");
 MODULE_AUTHOR("Mocean Laboratories");
diff --git a/drivers/media/radio/si470x/radio-si470x-i2c.c b/drivers/media/radio/si470x/radio-si470x-i2c.c
index fd3541b..9b546a5 100644
--- a/drivers/media/radio/si470x/radio-si470x-i2c.c
+++ b/drivers/media/radio/si470x/radio-si470x-i2c.c
@@ -539,33 +539,7 @@ static struct i2c_driver si470x_i2c_driver = {
 	.id_table		= si470x_i2c_id,
 };
 
-
-
-/**************************************************************************
- * Module Interface
- **************************************************************************/
-
-/*
- * si470x_i2c_init - module init
- */
-static int __init si470x_i2c_init(void)
-{
-	printk(KERN_INFO DRIVER_DESC ", Version " DRIVER_VERSION "\n");
-	return i2c_add_driver(&si470x_i2c_driver);
-}
-
-
-/*
- * si470x_i2c_exit - module exit
- */
-static void __exit si470x_i2c_exit(void)
-{
-	i2c_del_driver(&si470x_i2c_driver);
-}
-
-
-module_init(si470x_i2c_init);
-module_exit(si470x_i2c_exit);
+module_i2c_driver(si470x_i2c_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR(DRIVER_AUTHOR);
diff --git a/drivers/media/radio/si4713-i2c.c b/drivers/media/radio/si4713-i2c.c
index 27aba93..b898c89 100644
--- a/drivers/media/radio/si4713-i2c.c
+++ b/drivers/media/radio/si4713-i2c.c
@@ -2106,17 +2106,4 @@ static struct i2c_driver si4713_i2c_driver = {
 	.id_table       = si4713_id,
 };
 
-/* Module Interface */
-static int __init si4713_module_init(void)
-{
-	return i2c_add_driver(&si4713_i2c_driver);
-}
-
-static void __exit si4713_module_exit(void)
-{
-	i2c_del_driver(&si4713_i2c_driver);
-}
-
-module_init(si4713_module_init);
-module_exit(si4713_module_exit);
-
+module_i2c_driver(si4713_i2c_driver);
diff --git a/drivers/media/radio/tef6862.c b/drivers/media/radio/tef6862.c
index 3408685..6418c4c 100644
--- a/drivers/media/radio/tef6862.c
+++ b/drivers/media/radio/tef6862.c
@@ -215,20 +215,8 @@ static struct i2c_driver tef6862_driver = {
 	.id_table	= tef6862_id,
 };
 
-static __init int tef6862_init(void)
-{
-	return i2c_add_driver(&tef6862_driver);
-}
-
-static __exit void tef6862_exit(void)
-{
-	i2c_del_driver(&tef6862_driver);
-}
-
-module_init(tef6862_init);
-module_exit(tef6862_exit);
+module_i2c_driver(tef6862_driver);
 
 MODULE_DESCRIPTION("TEF6862 Car Radio Enhanced Selectivity Tuner");
 MODULE_AUTHOR("Mocean Laboratories");
 MODULE_LICENSE("GPL v2");
-
diff --git a/drivers/media/video/adp1653.c b/drivers/media/video/adp1653.c
index 12eedf4..0d13f05 100644
--- a/drivers/media/video/adp1653.c
+++ b/drivers/media/video/adp1653.c
@@ -482,24 +482,7 @@ static struct i2c_driver adp1653_i2c_driver = {
 	.id_table	= adp1653_id_table,
 };
 
-static int __init adp1653_init(void)
-{
-	int rval;
-
-	rval = i2c_add_driver(&adp1653_i2c_driver);
-	if (rval)
-		printk(KERN_ALERT "%s: failed at i2c_add_driver\n", __func__);
-
-	return rval;
-}
-
-static void __exit adp1653_exit(void)
-{
-	i2c_del_driver(&adp1653_i2c_driver);
-}
-
-module_init(adp1653_init);
-module_exit(adp1653_exit);
+module_i2c_driver(adp1653_i2c_driver);
 
 MODULE_AUTHOR("Sakari Ailus <sakari.ailus@nokia.com>");
 MODULE_DESCRIPTION("Analog Devices ADP1653 LED flash driver");
diff --git a/drivers/media/video/adv7170.c b/drivers/media/video/adv7170.c
index 879f1d8..6bc01fb 100644
--- a/drivers/media/video/adv7170.c
+++ b/drivers/media/video/adv7170.c
@@ -407,15 +407,4 @@ static struct i2c_driver adv7170_driver = {
 	.id_table	= adv7170_id,
 };
 
-static __init int init_adv7170(void)
-{
-	return i2c_add_driver(&adv7170_driver);
-}
-
-static __exit void exit_adv7170(void)
-{
-	i2c_del_driver(&adv7170_driver);
-}
-
-module_init(init_adv7170);
-module_exit(exit_adv7170);
+module_i2c_driver(adv7170_driver);
diff --git a/drivers/media/video/adv7175.c b/drivers/media/video/adv7175.c
index 206078e..c7640fa 100644
--- a/drivers/media/video/adv7175.c
+++ b/drivers/media/video/adv7175.c
@@ -457,15 +457,4 @@ static struct i2c_driver adv7175_driver = {
 	.id_table	= adv7175_id,
 };
 
-static __init int init_adv7175(void)
-{
-	return i2c_add_driver(&adv7175_driver);
-}
-
-static __exit void exit_adv7175(void)
-{
-	i2c_del_driver(&adv7175_driver);
-}
-
-module_init(init_adv7175);
-module_exit(exit_adv7175);
+module_i2c_driver(adv7175_driver);
diff --git a/drivers/media/video/adv7180.c b/drivers/media/video/adv7180.c
index d2138d0..b8b6c4b 100644
--- a/drivers/media/video/adv7180.c
+++ b/drivers/media/video/adv7180.c
@@ -444,20 +444,8 @@ static struct i2c_driver adv7180_driver = {
 	.id_table	= adv7180_id,
 };
 
-static __init int adv7180_init(void)
-{
-	return i2c_add_driver(&adv7180_driver);
-}
-
-static __exit void adv7180_exit(void)
-{
-	i2c_del_driver(&adv7180_driver);
-}
-
-module_init(adv7180_init);
-module_exit(adv7180_exit);
+module_i2c_driver(adv7180_driver);
 
 MODULE_DESCRIPTION("Analog Devices ADV7180 video decoder driver");
 MODULE_AUTHOR("Mocean Laboratories");
 MODULE_LICENSE("GPL v2");
-
diff --git a/drivers/media/video/adv7343.c b/drivers/media/video/adv7343.c
index 021fab2..119b604 100644
--- a/drivers/media/video/adv7343.c
+++ b/drivers/media/video/adv7343.c
@@ -475,15 +475,4 @@ static struct i2c_driver adv7343_driver = {
 	.id_table	= adv7343_id,
 };
 
-static __init int init_adv7343(void)
-{
-	return i2c_add_driver(&adv7343_driver);
-}
-
-static __exit void exit_adv7343(void)
-{
-	i2c_del_driver(&adv7343_driver);
-}
-
-module_init(init_adv7343);
-module_exit(exit_adv7343);
+module_i2c_driver(adv7343_driver);
diff --git a/drivers/media/video/ak881x.c b/drivers/media/video/ak881x.c
index 53c496c..ba67465 100644
--- a/drivers/media/video/ak881x.c
+++ b/drivers/media/video/ak881x.c
@@ -352,18 +352,7 @@ static struct i2c_driver ak881x_i2c_driver = {
 	.id_table	= ak881x_id,
 };
 
-static int __init ak881x_module_init(void)
-{
-	return i2c_add_driver(&ak881x_i2c_driver);
-}
-
-static void __exit ak881x_module_exit(void)
-{
-	i2c_del_driver(&ak881x_i2c_driver);
-}
-
-module_init(ak881x_module_init);
-module_exit(ak881x_module_exit);
+module_i2c_driver(ak881x_i2c_driver);
 
 MODULE_DESCRIPTION("TV-output driver for ak8813/ak8814");
 MODULE_AUTHOR("Guennadi Liakhovetski <g.liakhovetski@gmx.de>");
diff --git a/drivers/media/video/as3645a.c b/drivers/media/video/as3645a.c
index f241702..7a3371f 100644
--- a/drivers/media/video/as3645a.c
+++ b/drivers/media/video/as3645a.c
@@ -881,24 +881,7 @@ static struct i2c_driver as3645a_i2c_driver = {
 	.id_table = as3645a_id_table,
 };
 
-static int __init as3645a_init(void)
-{
-	int rval;
-
-	rval = i2c_add_driver(&as3645a_i2c_driver);
-	if (rval)
-		pr_err("%s: Failed to register the driver\n", AS3645A_NAME);
-
-	return rval;
-}
-
-static void __exit as3645a_exit(void)
-{
-	i2c_del_driver(&as3645a_i2c_driver);
-}
-
-module_init(as3645a_init);
-module_exit(as3645a_exit);
+module_i2c_driver(as3645a_i2c_driver);
 
 MODULE_AUTHOR("Laurent Pinchart <laurent.pinchart@ideasonboard.com>");
 MODULE_DESCRIPTION("LED flash driver for AS3645A, LM3555 and their clones");
diff --git a/drivers/media/video/bt819.c b/drivers/media/video/bt819.c
index 859eabf..377bf05 100644
--- a/drivers/media/video/bt819.c
+++ b/drivers/media/video/bt819.c
@@ -514,15 +514,4 @@ static struct i2c_driver bt819_driver = {
 	.id_table	= bt819_id,
 };
 
-static __init int init_bt819(void)
-{
-	return i2c_add_driver(&bt819_driver);
-}
-
-static __exit void exit_bt819(void)
-{
-	i2c_del_driver(&bt819_driver);
-}
-
-module_init(init_bt819);
-module_exit(exit_bt819);
+module_i2c_driver(bt819_driver);
diff --git a/drivers/media/video/bt856.c b/drivers/media/video/bt856.c
index a43059d..7e5bd36 100644
--- a/drivers/media/video/bt856.c
+++ b/drivers/media/video/bt856.c
@@ -270,15 +270,4 @@ static struct i2c_driver bt856_driver = {
 	.id_table	= bt856_id,
 };
 
-static __init int init_bt856(void)
-{
-	return i2c_add_driver(&bt856_driver);
-}
-
-static __exit void exit_bt856(void)
-{
-	i2c_del_driver(&bt856_driver);
-}
-
-module_init(init_bt856);
-module_exit(exit_bt856);
+module_i2c_driver(bt856_driver);
diff --git a/drivers/media/video/bt866.c b/drivers/media/video/bt866.c
index 4e5dcea..905320b 100644
--- a/drivers/media/video/bt866.c
+++ b/drivers/media/video/bt866.c
@@ -240,15 +240,4 @@ static struct i2c_driver bt866_driver = {
 	.id_table	= bt866_id,
 };
 
-static __init int init_bt866(void)
-{
-	return i2c_add_driver(&bt866_driver);
-}
-
-static __exit void exit_bt866(void)
-{
-	i2c_del_driver(&bt866_driver);
-}
-
-module_init(init_bt866);
-module_exit(exit_bt866);
+module_i2c_driver(bt866_driver);
diff --git a/drivers/media/video/cs5345.c b/drivers/media/video/cs5345.c
index 1d64af9..c8581e2 100644
--- a/drivers/media/video/cs5345.c
+++ b/drivers/media/video/cs5345.c
@@ -249,15 +249,4 @@ static struct i2c_driver cs5345_driver = {
 	.id_table	= cs5345_id,
 };
 
-static __init int init_cs5345(void)
-{
-	return i2c_add_driver(&cs5345_driver);
-}
-
-static __exit void exit_cs5345(void)
-{
-	i2c_del_driver(&cs5345_driver);
-}
-
-module_init(init_cs5345);
-module_exit(exit_cs5345);
+module_i2c_driver(cs5345_driver);
diff --git a/drivers/media/video/cs53l32a.c b/drivers/media/video/cs53l32a.c
index 51c5b9a..b293912 100644
--- a/drivers/media/video/cs53l32a.c
+++ b/drivers/media/video/cs53l32a.c
@@ -248,15 +248,4 @@ static struct i2c_driver cs53l32a_driver = {
 	.id_table	= cs53l32a_id,
 };
 
-static __init int init_cs53l32a(void)
-{
-	return i2c_add_driver(&cs53l32a_driver);
-}
-
-static __exit void exit_cs53l32a(void)
-{
-	i2c_del_driver(&cs53l32a_driver);
-}
-
-module_init(init_cs53l32a);
-module_exit(exit_cs53l32a);
+module_i2c_driver(cs53l32a_driver);
diff --git a/drivers/media/video/cx25840/cx25840-core.c b/drivers/media/video/cx25840/cx25840-core.c
index 05247d4..fc1ff69 100644
--- a/drivers/media/video/cx25840/cx25840-core.c
+++ b/drivers/media/video/cx25840/cx25840-core.c
@@ -5301,15 +5301,4 @@ static struct i2c_driver cx25840_driver = {
 	.id_table	= cx25840_id,
 };
 
-static __init int init_cx25840(void)
-{
-	return i2c_add_driver(&cx25840_driver);
-}
-
-static __exit void exit_cx25840(void)
-{
-	i2c_del_driver(&cx25840_driver);
-}
-
-module_init(init_cx25840);
-module_exit(exit_cx25840);
+module_i2c_driver(cx25840_driver);
diff --git a/drivers/media/video/imx074.c b/drivers/media/video/imx074.c
index eec75bb..351e9ba 100644
--- a/drivers/media/video/imx074.c
+++ b/drivers/media/video/imx074.c
@@ -468,18 +468,7 @@ static struct i2c_driver imx074_i2c_driver = {
 	.id_table	= imx074_id,
 };
 
-static int __init imx074_mod_init(void)
-{
-	return i2c_add_driver(&imx074_i2c_driver);
-}
-
-static void __exit imx074_mod_exit(void)
-{
-	i2c_del_driver(&imx074_i2c_driver);
-}
-
-module_init(imx074_mod_init);
-module_exit(imx074_mod_exit);
+module_i2c_driver(imx074_i2c_driver);
 
 MODULE_DESCRIPTION("Sony IMX074 Camera driver");
 MODULE_AUTHOR("Guennadi Liakhovetski <g.liakhovetski@gmx.de>");
diff --git a/drivers/media/video/indycam.c b/drivers/media/video/indycam.c
index e5ed4db..5482363 100644
--- a/drivers/media/video/indycam.c
+++ b/drivers/media/video/indycam.c
@@ -387,15 +387,4 @@ static struct i2c_driver indycam_driver = {
 	.id_table	= indycam_id,
 };
 
-static __init int init_indycam(void)
-{
-	return i2c_add_driver(&indycam_driver);
-}
-
-static __exit void exit_indycam(void)
-{
-	i2c_del_driver(&indycam_driver);
-}
-
-module_init(init_indycam);
-module_exit(exit_indycam);
+module_i2c_driver(indycam_driver);
diff --git a/drivers/media/video/ir-kbd-i2c.c b/drivers/media/video/ir-kbd-i2c.c
index a7c41d3..04f192a 100644
--- a/drivers/media/video/ir-kbd-i2c.c
+++ b/drivers/media/video/ir-kbd-i2c.c
@@ -471,7 +471,7 @@ static const struct i2c_device_id ir_kbd_id[] = {
 	{ }
 };
 
-static struct i2c_driver driver = {
+static struct i2c_driver ir_kbd_driver = {
 	.driver = {
 		.name   = "ir-kbd-i2c",
 	},
@@ -480,21 +480,10 @@ static struct i2c_driver driver = {
 	.id_table       = ir_kbd_id,
 };
 
+module_i2c_driver(ir_kbd_driver);
+
 /* ----------------------------------------------------------------------- */
 
 MODULE_AUTHOR("Gerd Knorr, Michal Kochanowicz, Christoph Bartelmus, Ulrich Mueller");
 MODULE_DESCRIPTION("input driver for i2c IR remote controls");
 MODULE_LICENSE("GPL");
-
-static int __init ir_init(void)
-{
-	return i2c_add_driver(&driver);
-}
-
-static void __exit ir_fini(void)
-{
-	i2c_del_driver(&driver);
-}
-
-module_init(ir_init);
-module_exit(ir_fini);
diff --git a/drivers/media/video/ks0127.c b/drivers/media/video/ks0127.c
index afa9118..ee7ca2d 100644
--- a/drivers/media/video/ks0127.c
+++ b/drivers/media/video/ks0127.c
@@ -721,15 +721,4 @@ static struct i2c_driver ks0127_driver = {
 	.id_table	= ks0127_id,
 };
 
-static __init int init_ks0127(void)
-{
-	return i2c_add_driver(&ks0127_driver);
-}
-
-static __exit void exit_ks0127(void)
-{
-	i2c_del_driver(&ks0127_driver);
-}
-
-module_init(init_ks0127);
-module_exit(exit_ks0127);
+module_i2c_driver(ks0127_driver);
diff --git a/drivers/media/video/m52790.c b/drivers/media/video/m52790.c
index 303ffa7..0991576 100644
--- a/drivers/media/video/m52790.c
+++ b/drivers/media/video/m52790.c
@@ -213,15 +213,4 @@ static struct i2c_driver m52790_driver = {
 	.id_table	= m52790_id,
 };
 
-static __init int init_m52790(void)
-{
-	return i2c_add_driver(&m52790_driver);
-}
-
-static __exit void exit_m52790(void)
-{
-	i2c_del_driver(&m52790_driver);
-}
-
-module_init(init_m52790);
-module_exit(exit_m52790);
+module_i2c_driver(m52790_driver);
diff --git a/drivers/media/video/m5mols/m5mols_core.c b/drivers/media/video/m5mols/m5mols_core.c
index 93d768d..eaab33a 100644
--- a/drivers/media/video/m5mols/m5mols_core.c
+++ b/drivers/media/video/m5mols/m5mols_core.c
@@ -1057,18 +1057,7 @@ static struct i2c_driver m5mols_i2c_driver = {
 	.id_table	= m5mols_id,
 };
 
-static int __init m5mols_mod_init(void)
-{
-	return i2c_add_driver(&m5mols_i2c_driver);
-}
-
-static void __exit m5mols_mod_exit(void)
-{
-	i2c_del_driver(&m5mols_i2c_driver);
-}
-
-module_init(m5mols_mod_init);
-module_exit(m5mols_mod_exit);
+module_i2c_driver(m5mols_i2c_driver);
 
 MODULE_AUTHOR("HeungJun Kim <riverful.kim@samsung.com>");
 MODULE_AUTHOR("Dongsoo Kim <dongsoo45.kim@samsung.com>");
diff --git a/drivers/media/video/msp3400-driver.c b/drivers/media/video/msp3400-driver.c
index d7cd0f6..82ce507 100644
--- a/drivers/media/video/msp3400-driver.c
+++ b/drivers/media/video/msp3400-driver.c
@@ -881,18 +881,7 @@ static struct i2c_driver msp_driver = {
 	.id_table	= msp_id,
 };
 
-static __init int init_msp(void)
-{
-	return i2c_add_driver(&msp_driver);
-}
-
-static __exit void exit_msp(void)
-{
-	i2c_del_driver(&msp_driver);
-}
-
-module_init(init_msp);
-module_exit(exit_msp);
+module_i2c_driver(msp_driver);
 
 /*
  * Overrides for Emacs so that we follow Linus's tabbing style.
diff --git a/drivers/media/video/mt9m001.c b/drivers/media/video/mt9m001.c
index 097c9d3..7e64818 100644
--- a/drivers/media/video/mt9m001.c
+++ b/drivers/media/video/mt9m001.c
@@ -730,18 +730,7 @@ static struct i2c_driver mt9m001_i2c_driver = {
 	.id_table	= mt9m001_id,
 };
 
-static int __init mt9m001_mod_init(void)
-{
-	return i2c_add_driver(&mt9m001_i2c_driver);
-}
-
-static void __exit mt9m001_mod_exit(void)
-{
-	i2c_del_driver(&mt9m001_i2c_driver);
-}
-
-module_init(mt9m001_mod_init);
-module_exit(mt9m001_mod_exit);
+module_i2c_driver(mt9m001_i2c_driver);
 
 MODULE_DESCRIPTION("Micron MT9M001 Camera driver");
 MODULE_AUTHOR("Guennadi Liakhovetski <kernel@pengutronix.de>");
diff --git a/drivers/media/video/mt9m111.c b/drivers/media/video/mt9m111.c
index bee65bf..b0c5299 100644
--- a/drivers/media/video/mt9m111.c
+++ b/drivers/media/video/mt9m111.c
@@ -1008,18 +1008,7 @@ static struct i2c_driver mt9m111_i2c_driver = {
 	.id_table	= mt9m111_id,
 };
 
-static int __init mt9m111_mod_init(void)
-{
-	return i2c_add_driver(&mt9m111_i2c_driver);
-}
-
-static void __exit mt9m111_mod_exit(void)
-{
-	i2c_del_driver(&mt9m111_i2c_driver);
-}
-
-module_init(mt9m111_mod_init);
-module_exit(mt9m111_mod_exit);
+module_i2c_driver(mt9m111_i2c_driver);
 
 MODULE_DESCRIPTION("Micron/Aptina MT9M111/MT9M112/MT9M131 Camera driver");
 MODULE_AUTHOR("Robert Jarzmik");
diff --git a/drivers/media/video/mt9p031.c b/drivers/media/video/mt9p031.c
index 93c3ec7..dde2610 100644
--- a/drivers/media/video/mt9p031.c
+++ b/drivers/media/video/mt9p031.c
@@ -945,18 +945,7 @@ static struct i2c_driver mt9p031_i2c_driver = {
 	.id_table       = mt9p031_id,
 };
 
-static int __init mt9p031_mod_init(void)
-{
-	return i2c_add_driver(&mt9p031_i2c_driver);
-}
-
-static void __exit mt9p031_mod_exit(void)
-{
-	i2c_del_driver(&mt9p031_i2c_driver);
-}
-
-module_init(mt9p031_mod_init);
-module_exit(mt9p031_mod_exit);
+module_i2c_driver(mt9p031_i2c_driver);
 
 MODULE_DESCRIPTION("Aptina MT9P031 Camera driver");
 MODULE_AUTHOR("Bastian Hecht <hechtb@gmail.com>");
diff --git a/drivers/media/video/mt9t001.c b/drivers/media/video/mt9t001.c
index cd81d04..49ca3cb 100644
--- a/drivers/media/video/mt9t001.c
+++ b/drivers/media/video/mt9t001.c
@@ -817,18 +817,7 @@ static struct i2c_driver mt9t001_driver = {
 	.id_table	= mt9t001_id,
 };
 
-static int __init mt9t001_init(void)
-{
-	return i2c_add_driver(&mt9t001_driver);
-}
-
-static void __exit mt9t001_exit(void)
-{
-	i2c_del_driver(&mt9t001_driver);
-}
-
-module_init(mt9t001_init);
-module_exit(mt9t001_exit);
+module_i2c_driver(mt9t001_driver);
 
 MODULE_DESCRIPTION("Aptina (Micron) MT9T001 Camera driver");
 MODULE_AUTHOR("Laurent Pinchart <laurent.pinchart@ideasonboard.com>");
diff --git a/drivers/media/video/mt9t031.c b/drivers/media/video/mt9t031.c
index 84add1a..1415074 100644
--- a/drivers/media/video/mt9t031.c
+++ b/drivers/media/video/mt9t031.c
@@ -850,18 +850,7 @@ static struct i2c_driver mt9t031_i2c_driver = {
 	.id_table	= mt9t031_id,
 };
 
-static int __init mt9t031_mod_init(void)
-{
-	return i2c_add_driver(&mt9t031_i2c_driver);
-}
-
-static void __exit mt9t031_mod_exit(void)
-{
-	i2c_del_driver(&mt9t031_i2c_driver);
-}
-
-module_init(mt9t031_mod_init);
-module_exit(mt9t031_mod_exit);
+module_i2c_driver(mt9t031_i2c_driver);
 
 MODULE_DESCRIPTION("Micron MT9T031 Camera driver");
 MODULE_AUTHOR("Guennadi Liakhovetski <lg@denx.de>");
diff --git a/drivers/media/video/mt9t112.c b/drivers/media/video/mt9t112.c
index 7b34b11..8d1445f 100644
--- a/drivers/media/video/mt9t112.c
+++ b/drivers/media/video/mt9t112.c
@@ -1117,21 +1117,7 @@ static struct i2c_driver mt9t112_i2c_driver = {
 	.id_table = mt9t112_id,
 };
 
-/************************************************************************
-			module function
-************************************************************************/
-static int __init mt9t112_module_init(void)
-{
-	return i2c_add_driver(&mt9t112_i2c_driver);
-}
-
-static void __exit mt9t112_module_exit(void)
-{
-	i2c_del_driver(&mt9t112_i2c_driver);
-}
-
-module_init(mt9t112_module_init);
-module_exit(mt9t112_module_exit);
+module_i2c_driver(mt9t112_i2c_driver);
 
 MODULE_DESCRIPTION("SoC Camera driver for mt9t112");
 MODULE_AUTHOR("Kuninori Morimoto");
diff --git a/drivers/media/video/mt9v011.c b/drivers/media/video/mt9v011.c
index db74dd2..6bf01ad 100644
--- a/drivers/media/video/mt9v011.c
+++ b/drivers/media/video/mt9v011.c
@@ -709,15 +709,4 @@ static struct i2c_driver mt9v011_driver = {
 	.id_table	= mt9v011_id,
 };
 
-static __init int init_mt9v011(void)
-{
-	return i2c_add_driver(&mt9v011_driver);
-}
-
-static __exit void exit_mt9v011(void)
-{
-	i2c_del_driver(&mt9v011_driver);
-}
-
-module_init(init_mt9v011);
-module_exit(exit_mt9v011);
+module_i2c_driver(mt9v011_driver);
diff --git a/drivers/media/video/mt9v022.c b/drivers/media/video/mt9v022.c
index 9449407..bf63417 100644
--- a/drivers/media/video/mt9v022.c
+++ b/drivers/media/video/mt9v022.c
@@ -872,18 +872,7 @@ static struct i2c_driver mt9v022_i2c_driver = {
 	.id_table	= mt9v022_id,
 };
 
-static int __init mt9v022_mod_init(void)
-{
-	return i2c_add_driver(&mt9v022_i2c_driver);
-}
-
-static void __exit mt9v022_mod_exit(void)
-{
-	i2c_del_driver(&mt9v022_i2c_driver);
-}
-
-module_init(mt9v022_mod_init);
-module_exit(mt9v022_mod_exit);
+module_i2c_driver(mt9v022_i2c_driver);
 
 MODULE_DESCRIPTION("Micron MT9V022 Camera driver");
 MODULE_AUTHOR("Guennadi Liakhovetski <kernel@pengutronix.de>");
diff --git a/drivers/media/video/mt9v032.c b/drivers/media/video/mt9v032.c
index d90b982..75e253a 100644
--- a/drivers/media/video/mt9v032.c
+++ b/drivers/media/video/mt9v032.c
@@ -756,18 +756,7 @@ static struct i2c_driver mt9v032_driver = {
 	.id_table	= mt9v032_id,
 };
 
-static int __init mt9v032_init(void)
-{
-	return i2c_add_driver(&mt9v032_driver);
-}
-
-static void __exit mt9v032_exit(void)
-{
-	i2c_del_driver(&mt9v032_driver);
-}
-
-module_init(mt9v032_init);
-module_exit(mt9v032_exit);
+module_i2c_driver(mt9v032_driver);
 
 MODULE_DESCRIPTION("Aptina MT9V032 Camera driver");
 MODULE_AUTHOR("Laurent Pinchart <laurent.pinchart@ideasonboard.com>");
diff --git a/drivers/media/video/noon010pc30.c b/drivers/media/video/noon010pc30.c
index 50838bf..794e172 100644
--- a/drivers/media/video/noon010pc30.c
+++ b/drivers/media/video/noon010pc30.c
@@ -844,18 +844,7 @@ static struct i2c_driver noon010_i2c_driver = {
 	.id_table	= noon010_id,
 };
 
-static int __init noon010_init(void)
-{
-	return i2c_add_driver(&noon010_i2c_driver);
-}
-
-static void __exit noon010_exit(void)
-{
-	i2c_del_driver(&noon010_i2c_driver);
-}
-
-module_init(noon010_init);
-module_exit(noon010_exit);
+module_i2c_driver(noon010_i2c_driver);
 
 MODULE_DESCRIPTION("Siliconfile NOON010PC30 camera driver");
 MODULE_AUTHOR("Sylwester Nawrocki <s.nawrocki@samsung.com>");
diff --git a/drivers/media/video/ov2640.c b/drivers/media/video/ov2640.c
index b5247cb..3c2c5d3 100644
--- a/drivers/media/video/ov2640.c
+++ b/drivers/media/video/ov2640.c
@@ -1103,21 +1103,7 @@ static struct i2c_driver ov2640_i2c_driver = {
 	.id_table = ov2640_id,
 };
 
-/*
- * Module functions
- */
-static int __init ov2640_module_init(void)
-{
-	return i2c_add_driver(&ov2640_i2c_driver);
-}
-
-static void __exit ov2640_module_exit(void)
-{
-	i2c_del_driver(&ov2640_i2c_driver);
-}
-
-module_init(ov2640_module_init);
-module_exit(ov2640_module_exit);
+module_i2c_driver(ov2640_i2c_driver);
 
 MODULE_DESCRIPTION("SoC Camera driver for Omni Vision 2640 sensor");
 MODULE_AUTHOR("Alberto Panizzo");
diff --git a/drivers/media/video/ov5642.c b/drivers/media/video/ov5642.c
index bb37ec8..80e0779 100644
--- a/drivers/media/video/ov5642.c
+++ b/drivers/media/video/ov5642.c
@@ -1068,18 +1068,7 @@ static struct i2c_driver ov5642_i2c_driver = {
 	.id_table	= ov5642_id,
 };
 
-static int __init ov5642_mod_init(void)
-{
-	return i2c_add_driver(&ov5642_i2c_driver);
-}
-
-static void __exit ov5642_mod_exit(void)
-{
-	i2c_del_driver(&ov5642_i2c_driver);
-}
-
-module_init(ov5642_mod_init);
-module_exit(ov5642_mod_exit);
+module_i2c_driver(ov5642_i2c_driver);
 
 MODULE_DESCRIPTION("Omnivision OV5642 Camera driver");
 MODULE_AUTHOR("Bastian Hecht <hechtb@gmail.com>");
diff --git a/drivers/media/video/ov6650.c b/drivers/media/video/ov6650.c
index 6806345..5e7012e 100644
--- a/drivers/media/video/ov6650.c
+++ b/drivers/media/video/ov6650.c
@@ -1046,18 +1046,7 @@ static struct i2c_driver ov6650_i2c_driver = {
 	.id_table = ov6650_id,
 };
 
-static int __init ov6650_module_init(void)
-{
-	return i2c_add_driver(&ov6650_i2c_driver);
-}
-
-static void __exit ov6650_module_exit(void)
-{
-	i2c_del_driver(&ov6650_i2c_driver);
-}
-
-module_init(ov6650_module_init);
-module_exit(ov6650_module_exit);
+module_i2c_driver(ov6650_i2c_driver);
 
 MODULE_DESCRIPTION("SoC Camera driver for OmniVision OV6650");
 MODULE_AUTHOR("Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>");
diff --git a/drivers/media/video/ov7670.c b/drivers/media/video/ov7670.c
index 6a56496..e7c82b2 100644
--- a/drivers/media/video/ov7670.c
+++ b/drivers/media/video/ov7670.c
@@ -1583,15 +1583,4 @@ static struct i2c_driver ov7670_driver = {
 	.id_table	= ov7670_id,
 };
 
-static __init int init_ov7670(void)
-{
-	return i2c_add_driver(&ov7670_driver);
-}
-
-static __exit void exit_ov7670(void)
-{
-	i2c_del_driver(&ov7670_driver);
-}
-
-module_init(init_ov7670);
-module_exit(exit_ov7670);
+module_i2c_driver(ov7670_driver);
diff --git a/drivers/media/video/ov772x.c b/drivers/media/video/ov772x.c
index 9f6ce3d..74e77d3 100644
--- a/drivers/media/video/ov772x.c
+++ b/drivers/media/video/ov772x.c
@@ -1123,22 +1123,7 @@ static struct i2c_driver ov772x_i2c_driver = {
 	.id_table = ov772x_id,
 };
 
-/*
- * module function
- */
-
-static int __init ov772x_module_init(void)
-{
-	return i2c_add_driver(&ov772x_i2c_driver);
-}
-
-static void __exit ov772x_module_exit(void)
-{
-	i2c_del_driver(&ov772x_i2c_driver);
-}
-
-module_init(ov772x_module_init);
-module_exit(ov772x_module_exit);
+module_i2c_driver(ov772x_i2c_driver);
 
 MODULE_DESCRIPTION("SoC Camera driver for ov772x");
 MODULE_AUTHOR("Kuninori Morimoto");
diff --git a/drivers/media/video/ov9640.c b/drivers/media/video/ov9640.c
index a4f9979..23412de 100644
--- a/drivers/media/video/ov9640.c
+++ b/drivers/media/video/ov9640.c
@@ -738,18 +738,7 @@ static struct i2c_driver ov9640_i2c_driver = {
 	.id_table = ov9640_id,
 };
 
-static int __init ov9640_module_init(void)
-{
-	return i2c_add_driver(&ov9640_i2c_driver);
-}
-
-static void __exit ov9640_module_exit(void)
-{
-	i2c_del_driver(&ov9640_i2c_driver);
-}
-
-module_init(ov9640_module_init);
-module_exit(ov9640_module_exit);
+module_i2c_driver(ov9640_i2c_driver);
 
 MODULE_DESCRIPTION("SoC Camera driver for OmniVision OV96xx");
 MODULE_AUTHOR("Marek Vasut <marek.vasut@gmail.com>");
diff --git a/drivers/media/video/ov9740.c b/drivers/media/video/ov9740.c
index d9a9f71..3eb07c2 100644
--- a/drivers/media/video/ov9740.c
+++ b/drivers/media/video/ov9740.c
@@ -998,18 +998,7 @@ static struct i2c_driver ov9740_i2c_driver = {
 	.id_table = ov9740_id,
 };
 
-static int __init ov9740_module_init(void)
-{
-	return i2c_add_driver(&ov9740_i2c_driver);
-}
-
-static void __exit ov9740_module_exit(void)
-{
-	i2c_del_driver(&ov9740_i2c_driver);
-}
-
-module_init(ov9740_module_init);
-module_exit(ov9740_module_exit);
+module_i2c_driver(ov9740_i2c_driver);
 
 MODULE_DESCRIPTION("SoC Camera driver for OmniVision OV9740");
 MODULE_AUTHOR("Andrew Chew <achew@nvidia.com>");
diff --git a/drivers/media/video/rj54n1cb0c.c b/drivers/media/video/rj54n1cb0c.c
index 9937386..f6419b2 100644
--- a/drivers/media/video/rj54n1cb0c.c
+++ b/drivers/media/video/rj54n1cb0c.c
@@ -1407,18 +1407,7 @@ static struct i2c_driver rj54n1_i2c_driver = {
 	.id_table	= rj54n1_id,
 };
 
-static int __init rj54n1_mod_init(void)
-{
-	return i2c_add_driver(&rj54n1_i2c_driver);
-}
-
-static void __exit rj54n1_mod_exit(void)
-{
-	i2c_del_driver(&rj54n1_i2c_driver);
-}
-
-module_init(rj54n1_mod_init);
-module_exit(rj54n1_mod_exit);
+module_i2c_driver(rj54n1_i2c_driver);
 
 MODULE_DESCRIPTION("Sharp RJ54N1CB0C Camera driver");
 MODULE_AUTHOR("Guennadi Liakhovetski <g.liakhovetski@gmx.de>");
diff --git a/drivers/media/video/s5k6aa.c b/drivers/media/video/s5k6aa.c
index 0df7f2a..0b9f3c7 100644
--- a/drivers/media/video/s5k6aa.c
+++ b/drivers/media/video/s5k6aa.c
@@ -1663,18 +1663,7 @@ static struct i2c_driver s5k6aa_i2c_driver = {
 	.id_table	= s5k6aa_id,
 };
 
-static int __init s5k6aa_init(void)
-{
-	return i2c_add_driver(&s5k6aa_i2c_driver);
-}
-
-static void __exit s5k6aa_exit(void)
-{
-	i2c_del_driver(&s5k6aa_i2c_driver);
-}
-
-module_init(s5k6aa_init);
-module_exit(s5k6aa_exit);
+module_i2c_driver(s5k6aa_i2c_driver);
 
 MODULE_DESCRIPTION("Samsung S5K6AA(FX) SXGA camera driver");
 MODULE_AUTHOR("Sylwester Nawrocki <s.nawrocki@samsung.com>");
diff --git a/drivers/media/video/s5p-tv/hdmiphy_drv.c b/drivers/media/video/s5p-tv/hdmiphy_drv.c
index 6693f4a..0afef77 100644
--- a/drivers/media/video/s5p-tv/hdmiphy_drv.c
+++ b/drivers/media/video/s5p-tv/hdmiphy_drv.c
@@ -175,14 +175,4 @@ static struct i2c_driver hdmiphy_driver = {
 	.id_table = hdmiphy_id,
 };
 
-static int __init hdmiphy_init(void)
-{
-	return i2c_add_driver(&hdmiphy_driver);
-}
-module_init(hdmiphy_init);
-
-static void __exit hdmiphy_exit(void)
-{
-	i2c_del_driver(&hdmiphy_driver);
-}
-module_exit(hdmiphy_exit);
+module_i2c_driver(hdmiphy_driver);
diff --git a/drivers/media/video/saa6588.c b/drivers/media/video/saa6588.c
index 99a2ac1..0caac50 100644
--- a/drivers/media/video/saa6588.c
+++ b/drivers/media/video/saa6588.c
@@ -539,15 +539,4 @@ static struct i2c_driver saa6588_driver = {
 	.id_table	= saa6588_id,
 };
 
-static __init int init_saa6588(void)
-{
-	return i2c_add_driver(&saa6588_driver);
-}
-
-static __exit void exit_saa6588(void)
-{
-	i2c_del_driver(&saa6588_driver);
-}
-
-module_init(init_saa6588);
-module_exit(exit_saa6588);
+module_i2c_driver(saa6588_driver);
diff --git a/drivers/media/video/saa7110.c b/drivers/media/video/saa7110.c
index 9966420..51cd4c8 100644
--- a/drivers/media/video/saa7110.c
+++ b/drivers/media/video/saa7110.c
@@ -491,15 +491,4 @@ static struct i2c_driver saa7110_driver = {
 	.id_table	= saa7110_id,
 };
 
-static __init int init_saa7110(void)
-{
-	return i2c_add_driver(&saa7110_driver);
-}
-
-static __exit void exit_saa7110(void)
-{
-	i2c_del_driver(&saa7110_driver);
-}
-
-module_init(init_saa7110);
-module_exit(exit_saa7110);
+module_i2c_driver(saa7110_driver);
diff --git a/drivers/media/video/saa7115.c b/drivers/media/video/saa7115.c
index 0ef5484..2107336 100644
--- a/drivers/media/video/saa7115.c
+++ b/drivers/media/video/saa7115.c
@@ -1724,15 +1724,4 @@ static struct i2c_driver saa711x_driver = {
 	.id_table	= saa711x_id,
 };
 
-static __init int init_saa711x(void)
-{
-	return i2c_add_driver(&saa711x_driver);
-}
-
-static __exit void exit_saa711x(void)
-{
-	i2c_del_driver(&saa711x_driver);
-}
-
-module_init(init_saa711x);
-module_exit(exit_saa711x);
+module_i2c_driver(saa711x_driver);
diff --git a/drivers/media/video/saa7127.c b/drivers/media/video/saa7127.c
index ad96461..39c90b0 100644
--- a/drivers/media/video/saa7127.c
+++ b/drivers/media/video/saa7127.c
@@ -852,15 +852,4 @@ static struct i2c_driver saa7127_driver = {
 	.id_table	= saa7127_id,
 };
 
-static __init int init_saa7127(void)
-{
-	return i2c_add_driver(&saa7127_driver);
-}
-
-static __exit void exit_saa7127(void)
-{
-	i2c_del_driver(&saa7127_driver);
-}
-
-module_init(init_saa7127);
-module_exit(exit_saa7127);
+module_i2c_driver(saa7127_driver);
diff --git a/drivers/media/video/saa7134/saa6752hs.c b/drivers/media/video/saa7134/saa6752hs.c
index f9f29cc..f147b05 100644
--- a/drivers/media/video/saa7134/saa6752hs.c
+++ b/drivers/media/video/saa7134/saa6752hs.c
@@ -1001,18 +1001,7 @@ static struct i2c_driver saa6752hs_driver = {
 	.id_table	= saa6752hs_id,
 };
 
-static __init int init_saa6752hs(void)
-{
-	return i2c_add_driver(&saa6752hs_driver);
-}
-
-static __exit void exit_saa6752hs(void)
-{
-	i2c_del_driver(&saa6752hs_driver);
-}
-
-module_init(init_saa6752hs);
-module_exit(exit_saa6752hs);
+module_i2c_driver(saa6752hs_driver);
 
 /*
  * Overrides for Emacs so that we follow Linus's tabbing style.
diff --git a/drivers/media/video/saa717x.c b/drivers/media/video/saa717x.c
index b6172c2..1e84466 100644
--- a/drivers/media/video/saa717x.c
+++ b/drivers/media/video/saa717x.c
@@ -1375,15 +1375,4 @@ static struct i2c_driver saa717x_driver = {
 	.id_table	= saa717x_id,
 };
 
-static __init int init_saa717x(void)
-{
-	return i2c_add_driver(&saa717x_driver);
-}
-
-static __exit void exit_saa717x(void)
-{
-	i2c_del_driver(&saa717x_driver);
-}
-
-module_init(init_saa717x);
-module_exit(exit_saa717x);
+module_i2c_driver(saa717x_driver);
diff --git a/drivers/media/video/saa7185.c b/drivers/media/video/saa7185.c
index 96f56c2..2c6b65c 100644
--- a/drivers/media/video/saa7185.c
+++ b/drivers/media/video/saa7185.c
@@ -374,15 +374,4 @@ static struct i2c_driver saa7185_driver = {
 	.id_table	= saa7185_id,
 };
 
-static __init int init_saa7185(void)
-{
-	return i2c_add_driver(&saa7185_driver);
-}
-
-static __exit void exit_saa7185(void)
-{
-	i2c_del_driver(&saa7185_driver);
-}
-
-module_init(init_saa7185);
-module_exit(exit_saa7185);
+module_i2c_driver(saa7185_driver);
diff --git a/drivers/media/video/saa7191.c b/drivers/media/video/saa7191.c
index 211fa25..d7d1670 100644
--- a/drivers/media/video/saa7191.c
+++ b/drivers/media/video/saa7191.c
@@ -656,15 +656,4 @@ static struct i2c_driver saa7191_driver = {
 	.id_table	= saa7191_id,
 };
 
-static __init int init_saa7191(void)
-{
-	return i2c_add_driver(&saa7191_driver);
-}
-
-static __exit void exit_saa7191(void)
-{
-	i2c_del_driver(&saa7191_driver);
-}
-
-module_init(init_saa7191);
-module_exit(exit_saa7191);
+module_i2c_driver(saa7191_driver);
diff --git a/drivers/media/video/sr030pc30.c b/drivers/media/video/sr030pc30.c
index d1b07ac..e9d95bd 100644
--- a/drivers/media/video/sr030pc30.c
+++ b/drivers/media/video/sr030pc30.c
@@ -864,18 +864,7 @@ static struct i2c_driver sr030pc30_i2c_driver = {
 	.id_table	= sr030pc30_id,
 };
 
-static int __init sr030pc30_init(void)
-{
-	return i2c_add_driver(&sr030pc30_i2c_driver);
-}
-
-static void __exit sr030pc30_exit(void)
-{
-	i2c_del_driver(&sr030pc30_i2c_driver);
-}
-
-module_init(sr030pc30_init);
-module_exit(sr030pc30_exit);
+module_i2c_driver(sr030pc30_i2c_driver);
 
 MODULE_DESCRIPTION("Siliconfile SR030PC30 camera driver");
 MODULE_AUTHOR("Sylwester Nawrocki <s.nawrocki@samsung.com>");
diff --git a/drivers/media/video/tda7432.c b/drivers/media/video/tda7432.c
index bd21854..f7707e6 100644
--- a/drivers/media/video/tda7432.c
+++ b/drivers/media/video/tda7432.c
@@ -482,15 +482,4 @@ static struct i2c_driver tda7432_driver = {
 	.id_table	= tda7432_id,
 };
 
-static __init int init_tda7432(void)
-{
-	return i2c_add_driver(&tda7432_driver);
-}
-
-static __exit void exit_tda7432(void)
-{
-	i2c_del_driver(&tda7432_driver);
-}
-
-module_init(init_tda7432);
-module_exit(exit_tda7432);
+module_i2c_driver(tda7432_driver);
diff --git a/drivers/media/video/tda9840.c b/drivers/media/video/tda9840.c
index 22fa820..465d708 100644
--- a/drivers/media/video/tda9840.c
+++ b/drivers/media/video/tda9840.c
@@ -208,15 +208,4 @@ static struct i2c_driver tda9840_driver = {
 	.id_table	= tda9840_id,
 };
 
-static __init int init_tda9840(void)
-{
-	return i2c_add_driver(&tda9840_driver);
-}
-
-static __exit void exit_tda9840(void)
-{
-	i2c_del_driver(&tda9840_driver);
-}
-
-module_init(init_tda9840);
-module_exit(exit_tda9840);
+module_i2c_driver(tda9840_driver);
diff --git a/drivers/media/video/tea6415c.c b/drivers/media/video/tea6415c.c
index 827425c..d1d6ea1 100644
--- a/drivers/media/video/tea6415c.c
+++ b/drivers/media/video/tea6415c.c
@@ -184,15 +184,4 @@ static struct i2c_driver tea6415c_driver = {
 	.id_table	= tea6415c_id,
 };
 
-static __init int init_tea6415c(void)
-{
-	return i2c_add_driver(&tea6415c_driver);
-}
-
-static __exit void exit_tea6415c(void)
-{
-	i2c_del_driver(&tea6415c_driver);
-}
-
-module_init(init_tea6415c);
-module_exit(exit_tea6415c);
+module_i2c_driver(tea6415c_driver);
diff --git a/drivers/media/video/tea6420.c b/drivers/media/video/tea6420.c
index f350b6c..3875721 100644
--- a/drivers/media/video/tea6420.c
+++ b/drivers/media/video/tea6420.c
@@ -166,15 +166,4 @@ static struct i2c_driver tea6420_driver = {
 	.id_table	= tea6420_id,
 };
 
-static __init int init_tea6420(void)
-{
-	return i2c_add_driver(&tea6420_driver);
-}
-
-static __exit void exit_tea6420(void)
-{
-	i2c_del_driver(&tea6420_driver);
-}
-
-module_init(init_tea6420);
-module_exit(exit_tea6420);
+module_i2c_driver(tea6420_driver);
diff --git a/drivers/media/video/ths7303.c b/drivers/media/video/ths7303.c
index 61b1dd1..e5c0eed 100644
--- a/drivers/media/video/ths7303.c
+++ b/drivers/media/video/ths7303.c
@@ -137,16 +137,4 @@ static struct i2c_driver ths7303_driver = {
 	.id_table	= ths7303_id,
 };
 
-static int __init ths7303_init(void)
-{
-	return i2c_add_driver(&ths7303_driver);
-}
-
-static void __exit ths7303_exit(void)
-{
-	i2c_del_driver(&ths7303_driver);
-}
-
-module_init(ths7303_init);
-module_exit(ths7303_exit);
-
+module_i2c_driver(ths7303_driver);
diff --git a/drivers/media/video/tlv320aic23b.c b/drivers/media/video/tlv320aic23b.c
index 286ec7e..809a75a 100644
--- a/drivers/media/video/tlv320aic23b.c
+++ b/drivers/media/video/tlv320aic23b.c
@@ -227,15 +227,4 @@ static struct i2c_driver tlv320aic23b_driver = {
 	.id_table	= tlv320aic23b_id,
 };
 
-static __init int init_tlv320aic23b(void)
-{
-	return i2c_add_driver(&tlv320aic23b_driver);
-}
-
-static __exit void exit_tlv320aic23b(void)
-{
-	i2c_del_driver(&tlv320aic23b_driver);
-}
-
-module_init(init_tlv320aic23b);
-module_exit(exit_tlv320aic23b);
+module_i2c_driver(tlv320aic23b_driver);
diff --git a/drivers/media/video/tuner-core.c b/drivers/media/video/tuner-core.c
index 4059ea1..19069c6 100644
--- a/drivers/media/video/tuner-core.c
+++ b/drivers/media/video/tuner-core.c
@@ -1314,18 +1314,7 @@ static struct i2c_driver tuner_driver = {
 	.id_table	= tuner_id,
 };
 
-static __init int init_tuner(void)
-{
-	return i2c_add_driver(&tuner_driver);
-}
-
-static __exit void exit_tuner(void)
-{
-	i2c_del_driver(&tuner_driver);
-}
-
-module_init(init_tuner);
-module_exit(exit_tuner);
+module_i2c_driver(tuner_driver);
 
 MODULE_DESCRIPTION("device driver for various TV and TV+FM radio tuners");
 MODULE_AUTHOR("Ralph Metzler, Gerd Knorr, Gunther Mayer");
diff --git a/drivers/media/video/tvaudio.c b/drivers/media/video/tvaudio.c
index f22dbef..c5b1a73 100644
--- a/drivers/media/video/tvaudio.c
+++ b/drivers/media/video/tvaudio.c
@@ -2078,15 +2078,4 @@ static struct i2c_driver tvaudio_driver = {
 	.id_table	= tvaudio_id,
 };
 
-static __init int init_tvaudio(void)
-{
-	return i2c_add_driver(&tvaudio_driver);
-}
-
-static __exit void exit_tvaudio(void)
-{
-	i2c_del_driver(&tvaudio_driver);
-}
-
-module_init(init_tvaudio);
-module_exit(exit_tvaudio);
+module_i2c_driver(tvaudio_driver);
diff --git a/drivers/media/video/tvp514x.c b/drivers/media/video/tvp514x.c
index dd26cac..cd615c1 100644
--- a/drivers/media/video/tvp514x.c
+++ b/drivers/media/video/tvp514x.c
@@ -1163,15 +1163,4 @@ static struct i2c_driver tvp514x_driver = {
 	.id_table = tvp514x_id,
 };
 
-static int __init tvp514x_init(void)
-{
-	return i2c_add_driver(&tvp514x_driver);
-}
-
-static void __exit tvp514x_exit(void)
-{
-	i2c_del_driver(&tvp514x_driver);
-}
-
-module_init(tvp514x_init);
-module_exit(tvp514x_exit);
+module_i2c_driver(tvp514x_driver);
diff --git a/drivers/media/video/tvp5150.c b/drivers/media/video/tvp5150.c
index 6be9910..f1fcedd 100644
--- a/drivers/media/video/tvp5150.c
+++ b/drivers/media/video/tvp5150.c
@@ -1121,15 +1121,4 @@ static struct i2c_driver tvp5150_driver = {
 	.id_table	= tvp5150_id,
 };
 
-static __init int init_tvp5150(void)
-{
-	return i2c_add_driver(&tvp5150_driver);
-}
-
-static __exit void exit_tvp5150(void)
-{
-	i2c_del_driver(&tvp5150_driver);
-}
-
-module_init(init_tvp5150);
-module_exit(exit_tvp5150);
+module_i2c_driver(tvp5150_driver);
diff --git a/drivers/media/video/tvp7002.c b/drivers/media/video/tvp7002.c
index 236c559..d7676d8 100644
--- a/drivers/media/video/tvp7002.c
+++ b/drivers/media/video/tvp7002.c
@@ -1069,27 +1069,4 @@ static struct i2c_driver tvp7002_driver = {
 	.id_table = tvp7002_id,
 };
 
-/*
- * tvp7002_init - Initialize driver via I2C interface
- *
- * Register the TVP7002 driver.
- * Return 0 on success or error code on failure.
- */
-static int __init tvp7002_init(void)
-{
-	return i2c_add_driver(&tvp7002_driver);
-}
-
-/*
- * tvp7002_exit - Remove driver via I2C interface
- *
- * Unregister the TVP7002 driver.
- * Returns nothing.
- */
-static void __exit tvp7002_exit(void)
-{
-	i2c_del_driver(&tvp7002_driver);
-}
-
-module_init(tvp7002_init);
-module_exit(tvp7002_exit);
+module_i2c_driver(tvp7002_driver);
diff --git a/drivers/media/video/tw9910.c b/drivers/media/video/tw9910.c
index a514fa6..8768efb 100644
--- a/drivers/media/video/tw9910.c
+++ b/drivers/media/video/tw9910.c
@@ -951,21 +951,7 @@ static struct i2c_driver tw9910_i2c_driver = {
 	.id_table = tw9910_id,
 };
 
-/*
- * module function
- */
-static int __init tw9910_module_init(void)
-{
-	return i2c_add_driver(&tw9910_i2c_driver);
-}
-
-static void __exit tw9910_module_exit(void)
-{
-	i2c_del_driver(&tw9910_i2c_driver);
-}
-
-module_init(tw9910_module_init);
-module_exit(tw9910_module_exit);
+module_i2c_driver(tw9910_i2c_driver);
 
 MODULE_DESCRIPTION("SoC Camera driver for tw9910");
 MODULE_AUTHOR("Kuninori Morimoto");
diff --git a/drivers/media/video/upd64031a.c b/drivers/media/video/upd64031a.c
index 1aab96a..1e74465 100644
--- a/drivers/media/video/upd64031a.c
+++ b/drivers/media/video/upd64031a.c
@@ -271,15 +271,4 @@ static struct i2c_driver upd64031a_driver = {
 	.id_table	= upd64031a_id,
 };
 
-static __init int init_upd64031a(void)
-{
-	return i2c_add_driver(&upd64031a_driver);
-}
-
-static __exit void exit_upd64031a(void)
-{
-	i2c_del_driver(&upd64031a_driver);
-}
-
-module_init(init_upd64031a);
-module_exit(exit_upd64031a);
+module_i2c_driver(upd64031a_driver);
diff --git a/drivers/media/video/upd64083.c b/drivers/media/video/upd64083.c
index 65d065a..75d6acc 100644
--- a/drivers/media/video/upd64083.c
+++ b/drivers/media/video/upd64083.c
@@ -243,15 +243,4 @@ static struct i2c_driver upd64083_driver = {
 	.id_table	= upd64083_id,
 };
 
-static __init int init_upd64083(void)
-{
-	return i2c_add_driver(&upd64083_driver);
-}
-
-static __exit void exit_upd64083(void)
-{
-	i2c_del_driver(&upd64083_driver);
-}
-
-module_init(init_upd64083);
-module_exit(exit_upd64083);
+module_i2c_driver(upd64083_driver);
diff --git a/drivers/media/video/vp27smpx.c b/drivers/media/video/vp27smpx.c
index c15efb6..7cfbc9d 100644
--- a/drivers/media/video/vp27smpx.c
+++ b/drivers/media/video/vp27smpx.c
@@ -208,15 +208,4 @@ static struct i2c_driver vp27smpx_driver = {
 	.id_table	= vp27smpx_id,
 };
 
-static __init int init_vp27smpx(void)
-{
-	return i2c_add_driver(&vp27smpx_driver);
-}
-
-static __exit void exit_vp27smpx(void)
-{
-	i2c_del_driver(&vp27smpx_driver);
-}
-
-module_init(init_vp27smpx);
-module_exit(exit_vp27smpx);
+module_i2c_driver(vp27smpx_driver);
diff --git a/drivers/media/video/vpx3220.c b/drivers/media/video/vpx3220.c
index e5cad6f..2f67b4c 100644
--- a/drivers/media/video/vpx3220.c
+++ b/drivers/media/video/vpx3220.c
@@ -588,15 +588,4 @@ static struct i2c_driver vpx3220_driver = {
 	.id_table	= vpx3220_id,
 };
 
-static __init int init_vpx3220(void)
-{
-	return i2c_add_driver(&vpx3220_driver);
-}
-
-static __exit void exit_vpx3220(void)
-{
-	i2c_del_driver(&vpx3220_driver);
-}
-
-module_init(init_vpx3220);
-module_exit(exit_vpx3220);
+module_i2c_driver(vpx3220_driver);
diff --git a/drivers/media/video/wm8739.c b/drivers/media/video/wm8739.c
index a22f765..3bb99e9 100644
--- a/drivers/media/video/wm8739.c
+++ b/drivers/media/video/wm8739.c
@@ -291,15 +291,4 @@ static struct i2c_driver wm8739_driver = {
 	.id_table	= wm8739_id,
 };
 
-static __init int init_wm8739(void)
-{
-	return i2c_add_driver(&wm8739_driver);
-}
-
-static __exit void exit_wm8739(void)
-{
-	i2c_del_driver(&wm8739_driver);
-}
-
-module_init(init_wm8739);
-module_exit(exit_wm8739);
+module_i2c_driver(wm8739_driver);
diff --git a/drivers/media/video/wm8775.c b/drivers/media/video/wm8775.c
index 9cedb1e..bee77ea 100644
--- a/drivers/media/video/wm8775.c
+++ b/drivers/media/video/wm8775.c
@@ -339,15 +339,4 @@ static struct i2c_driver wm8775_driver = {
 	.id_table	= wm8775_id,
 };
 
-static __init int init_wm8775(void)
-{
-	return i2c_add_driver(&wm8775_driver);
-}
-
-static __exit void exit_wm8775(void)
-{
-	i2c_del_driver(&wm8775_driver);
-}
-
-module_init(init_wm8775);
-module_exit(exit_wm8775);
+module_i2c_driver(wm8775_driver);
-- 
1.7.5.4



