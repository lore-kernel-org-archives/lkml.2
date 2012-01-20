Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221Ab2ATNBo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 08:01:44 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44834 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015Ab2ATNBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 08:01:41 -0500
Message-ID: <1327064484.15205.1.camel@phoenix>
Subject: [PATCH 1/2] Input: convert drivers/input/* to use
 module_i2c_driver()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Fabien Marteau <fabien.marteau@armadeus.com>,
        Michael Hennerich <hennerich@blackfin.uclinux.org>,
        Felipe Balbi <balbi@ti.com>, Kim Kyuwon <q1.kim@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Zhang Jiejing <jiejing.zhang@freescale.com>,
        Bo Shen <voice.shen@atmel.com>,
        Raphael Derosso Pereira <raphaelpereira@gmail.com>,
        Barry Song <21cnbao@gmail.com>,
        Albert Zhang <xu.zhang@bosch-sensortec.com>,
        Hemanth V <hemanthv@ti.com>, Chris Hudson <chudson@kionix.com>,
        Samuli Konttila <samuli.konttila@aavamobile.com>,
        Mike Rapoport <mike@compulab.co.il>, Daniel Mack <daniel@caiaq.de>,
        Magnus Damm <damm@opensource.se>, Jianchun Bian <jcbian@pixcir.com.cn>,
        Dequan Meng <dqmeng@pixcir.com.cn>,
        Tony SIM <chinyeow.sim.xt@renesas.com>,
        Kwangwoo Lee <kwlee@mtekvision.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
Date: Fri, 20 Jan 2012 21:01:24 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the drivers in drivers/input/* to use the
module_i2c_driver() macro which makes the code smaller and a bit simpler.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Fabien Marteau <fabien.marteau@armadeus.com>
Cc: Michael Hennerich <hennerich@blackfin.uclinux.org>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Kim Kyuwon <q1.kim@samsung.com>
Cc: Joonyoung Shim <jy0922.shim@samsung.com>
Cc: Zhang Jiejing <jiejing.zhang@freescale.com>
Cc: Bo Shen <voice.shen@atmel.com>
Cc: Raphael Derosso Pereira <raphaelpereira@gmail.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Albert Zhang <xu.zhang@bosch-sensortec.com>
Cc: Hemanth V <hemanthv@ti.com>
Cc: Chris Hudson <chudson@kionix.com>
Cc: Samuli Konttila <samuli.konttila@aavamobile.com>
Cc: Mike Rapoport <mike@compulab.co.il>
Cc: Daniel Mack <daniel@caiaq.de>
Cc: Magnus Damm <damm@opensource.se>
Cc: Jianchun Bian <jcbian@pixcir.com.cn>
Cc: Dequan Meng <dqmeng@pixcir.com.cn>
Cc: Tony SIM <chinyeow.sim.xt@renesas.com>
Cc: Kwangwoo Lee <kwlee@mtekvision.com>
---
 drivers/input/joystick/as5011.c           |   12 +-----------
 drivers/input/keyboard/adp5588-keys.c     |   12 +-----------
 drivers/input/keyboard/adp5589-keys.c     |   12 +-----------
 drivers/input/keyboard/lm8323.c           |   12 +-----------
 drivers/input/keyboard/max7359_keypad.c   |   12 +-----------
 drivers/input/keyboard/mcs_touchkey.c     |   13 +------------
 drivers/input/keyboard/mpr121_touchkey.c  |   12 +-----------
 drivers/input/keyboard/qt1070.c           |   12 +-----------
 drivers/input/keyboard/qt2160.c           |   12 +-----------
 drivers/input/misc/ad714x-i2c.c           |   12 +-----------
 drivers/input/misc/adxl34x-i2c.c          |   12 +-----------
 drivers/input/misc/bma150.c               |   13 +------------
 drivers/input/misc/cma3000_d0x_i2c.c      |   13 +------------
 drivers/input/misc/gp2ap002a00f.c         |   13 +------------
 drivers/input/misc/kxtj9.c                |   12 +-----------
 drivers/input/misc/mma8450.c              |   12 +-----------
 drivers/input/misc/mpu3050.c              |   12 +-----------
 drivers/input/misc/pcf8574_keypad.c       |   12 +-----------
 drivers/input/mouse/synaptics_i2c.c       |   13 +------------
 drivers/input/touchscreen/ad7879-i2c.c    |   12 +-----------
 drivers/input/touchscreen/atmel_mxt_ts.c  |   13 +------------
 drivers/input/touchscreen/auo-pixcir-ts.c |   12 +-----------
 drivers/input/touchscreen/bu21013_ts.c    |   25 +------------------------
 drivers/input/touchscreen/cy8ctmg110_ts.c |   13 +------------
 drivers/input/touchscreen/eeti_ts.c       |   14 +-------------
 drivers/input/touchscreen/egalax_ts.c     |   13 +------------
 drivers/input/touchscreen/max11801_ts.c   |   13 +------------
 drivers/input/touchscreen/mcs5000_ts.c    |   13 +------------
 drivers/input/touchscreen/migor_ts.c      |   13 +------------
 drivers/input/touchscreen/pixcir_i2c_ts.c |   12 +-----------
 drivers/input/touchscreen/st1232.c        |   12 +-----------
 drivers/input/touchscreen/tsc2007.c       |   13 +------------
 32 files changed, 32 insertions(+), 379 deletions(-)

diff --git a/drivers/input/joystick/as5011.c b/drivers/input/joystick/as5011.c
index 6d6e741..3063464 100644
--- a/drivers/input/joystick/as5011.c
+++ b/drivers/input/joystick/as5011.c
@@ -355,14 +355,4 @@ static struct i2c_driver as5011_driver = {
 	.id_table	= as5011_id,
 };
 
-static int __init as5011_init(void)
-{
-	return i2c_add_driver(&as5011_driver);
-}
-module_init(as5011_init);
-
-static void __exit as5011_exit(void)
-{
-	i2c_del_driver(&as5011_driver);
-}
-module_exit(as5011_exit);
+module_i2c_driver(as5011_driver);
diff --git a/drivers/input/keyboard/adp5588-keys.c b/drivers/input/keyboard/adp5588-keys.c
index 4a7f534..39ebffa 100644
--- a/drivers/input/keyboard/adp5588-keys.c
+++ b/drivers/input/keyboard/adp5588-keys.c
@@ -653,17 +653,7 @@ static struct i2c_driver adp5588_driver = {
 	.id_table = adp5588_id,
 };
 
-static int __init adp5588_init(void)
-{
-	return i2c_add_driver(&adp5588_driver);
-}
-module_init(adp5588_init);
-
-static void __exit adp5588_exit(void)
-{
-	i2c_del_driver(&adp5588_driver);
-}
-module_exit(adp5588_exit);
+module_i2c_driver(adp5588_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>");
diff --git a/drivers/input/keyboard/adp5589-keys.c b/drivers/input/keyboard/adp5589-keys.c
index 02b5d53..74e6032 100644
--- a/drivers/input/keyboard/adp5589-keys.c
+++ b/drivers/input/keyboard/adp5589-keys.c
@@ -1108,17 +1108,7 @@ static struct i2c_driver adp5589_driver = {
 	.id_table = adp5589_id,
 };
 
-static int __init adp5589_init(void)
-{
-	return i2c_add_driver(&adp5589_driver);
-}
-module_init(adp5589_init);
-
-static void __exit adp5589_exit(void)
-{
-	i2c_del_driver(&adp5589_driver);
-}
-module_exit(adp5589_exit);
+module_i2c_driver(adp5589_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>");
diff --git a/drivers/input/keyboard/lm8323.c b/drivers/input/keyboard/lm8323.c
index 21823bfc7..39ac278 100644
--- a/drivers/input/keyboard/lm8323.c
+++ b/drivers/input/keyboard/lm8323.c
@@ -851,17 +851,7 @@ static struct i2c_driver lm8323_i2c_driver = {
 };
 MODULE_DEVICE_TABLE(i2c, lm8323_id);
 
-static int __init lm8323_init(void)
-{
-	return i2c_add_driver(&lm8323_i2c_driver);
-}
-module_init(lm8323_init);
-
-static void __exit lm8323_exit(void)
-{
-	i2c_del_driver(&lm8323_i2c_driver);
-}
-module_exit(lm8323_exit);
+module_i2c_driver(lm8323_i2c_driver);
 
 MODULE_AUTHOR("Timo O. Karjalainen <timo.o.karjalainen@nokia.com>");
 MODULE_AUTHOR("Daniel Stone");
diff --git a/drivers/input/keyboard/max7359_keypad.c b/drivers/input/keyboard/max7359_keypad.c
index 5afe35a..8edada8 100644
--- a/drivers/input/keyboard/max7359_keypad.c
+++ b/drivers/input/keyboard/max7359_keypad.c
@@ -316,17 +316,7 @@ static struct i2c_driver max7359_i2c_driver = {
 	.id_table	= max7359_ids,
 };
 
-static int __init max7359_init(void)
-{
-	return i2c_add_driver(&max7359_i2c_driver);
-}
-module_init(max7359_init);
-
-static void __exit max7359_exit(void)
-{
-	i2c_del_driver(&max7359_i2c_driver);
-}
-module_exit(max7359_exit);
+module_i2c_driver(max7359_i2c_driver);
 
 MODULE_AUTHOR("Kim Kyuwon <q1.kim@samsung.com>");
 MODULE_DESCRIPTION("MAX7359 Key Switch Controller Driver");
diff --git a/drivers/input/keyboard/mcs_touchkey.c b/drivers/input/keyboard/mcs_touchkey.c
index af1aab3..64a0ca4 100644
--- a/drivers/input/keyboard/mcs_touchkey.c
+++ b/drivers/input/keyboard/mcs_touchkey.c
@@ -274,18 +274,7 @@ static struct i2c_driver mcs_touchkey_driver = {
 	.id_table	= mcs_touchkey_id,
 };
 
-static int __init mcs_touchkey_init(void)
-{
-	return i2c_add_driver(&mcs_touchkey_driver);
-}
-
-static void __exit mcs_touchkey_exit(void)
-{
-	i2c_del_driver(&mcs_touchkey_driver);
-}
-
-module_init(mcs_touchkey_init);
-module_exit(mcs_touchkey_exit);
+module_i2c_driver(mcs_touchkey_driver);
 
 /* Module information */
 MODULE_AUTHOR("Joonyoung Shim <jy0922.shim@samsung.com>");
diff --git a/drivers/input/keyboard/mpr121_touchkey.c b/drivers/input/keyboard/mpr121_touchkey.c
index 1c1615d..caa218a 100644
--- a/drivers/input/keyboard/mpr121_touchkey.c
+++ b/drivers/input/keyboard/mpr121_touchkey.c
@@ -330,17 +330,7 @@ static struct i2c_driver mpr_touchkey_driver = {
 	.remove		= __devexit_p(mpr_touchkey_remove),
 };
 
-static int __init mpr_touchkey_init(void)
-{
-	return i2c_add_driver(&mpr_touchkey_driver);
-}
-module_init(mpr_touchkey_init);
-
-static void __exit mpr_touchkey_exit(void)
-{
-	i2c_del_driver(&mpr_touchkey_driver);
-}
-module_exit(mpr_touchkey_exit);
+module_i2c_driver(mpr_touchkey_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Zhang Jiejing <jiejing.zhang@freescale.com>");
diff --git a/drivers/input/keyboard/qt1070.c b/drivers/input/keyboard/qt1070.c
index b21bf5b..0b7b2f8 100644
--- a/drivers/input/keyboard/qt1070.c
+++ b/drivers/input/keyboard/qt1070.c
@@ -258,17 +258,7 @@ static struct i2c_driver qt1070_driver = {
 	.remove		= __devexit_p(qt1070_remove),
 };
 
-static int __init qt1070_init(void)
-{
-	return i2c_add_driver(&qt1070_driver);
-}
-module_init(qt1070_init);
-
-static void __exit qt1070_exit(void)
-{
-	i2c_del_driver(&qt1070_driver);
-}
-module_exit(qt1070_exit);
+module_i2c_driver(qt1070_driver);
 
 MODULE_AUTHOR("Bo Shen <voice.shen@atmel.com>");
 MODULE_DESCRIPTION("Driver for AT42QT1070 QTouch sensor");
diff --git a/drivers/input/keyboard/qt2160.c b/drivers/input/keyboard/qt2160.c
index fac6951..e7a5e36 100644
--- a/drivers/input/keyboard/qt2160.c
+++ b/drivers/input/keyboard/qt2160.c
@@ -379,17 +379,7 @@ static struct i2c_driver qt2160_driver = {
 	.remove		= __devexit_p(qt2160_remove),
 };
 
-static int __init qt2160_init(void)
-{
-	return i2c_add_driver(&qt2160_driver);
-}
-module_init(qt2160_init);
-
-static void __exit qt2160_cleanup(void)
-{
-	i2c_del_driver(&qt2160_driver);
-}
-module_exit(qt2160_cleanup);
+module_i2c_driver(qt2160_driver);
 
 MODULE_AUTHOR("Raphael Derosso Pereira <raphaelpereira@gmail.com>");
 MODULE_DESCRIPTION("Driver for AT42QT2160 Touch Sensor");
diff --git a/drivers/input/misc/ad714x-i2c.c b/drivers/input/misc/ad714x-i2c.c
index 56810fb..c8a7901 100644
--- a/drivers/input/misc/ad714x-i2c.c
+++ b/drivers/input/misc/ad714x-i2c.c
@@ -116,17 +116,7 @@ static struct i2c_driver ad714x_i2c_driver = {
 	.id_table = ad714x_id,
 };
 
-static int __init ad714x_i2c_init(void)
-{
-	return i2c_add_driver(&ad714x_i2c_driver);
-}
-module_init(ad714x_i2c_init);
-
-static void __exit ad714x_i2c_exit(void)
-{
-	i2c_del_driver(&ad714x_i2c_driver);
-}
-module_exit(ad714x_i2c_exit);
+module_i2c_driver(ad714x_i2c_driver);
 
 MODULE_DESCRIPTION("Analog Devices AD714X Capacitance Touch Sensor I2C Bus Driver");
 MODULE_AUTHOR("Barry Song <21cnbao@gmail.com>");
diff --git a/drivers/input/misc/adxl34x-i2c.c b/drivers/input/misc/adxl34x-i2c.c
index ccacf2b..dd1d1c1 100644
--- a/drivers/input/misc/adxl34x-i2c.c
+++ b/drivers/input/misc/adxl34x-i2c.c
@@ -148,17 +148,7 @@ static struct i2c_driver adxl34x_driver = {
 	.id_table = adxl34x_id,
 };
 
-static int __init adxl34x_i2c_init(void)
-{
-	return i2c_add_driver(&adxl34x_driver);
-}
-module_init(adxl34x_i2c_init);
-
-static void __exit adxl34x_i2c_exit(void)
-{
-	i2c_del_driver(&adxl34x_driver);
-}
-module_exit(adxl34x_i2c_exit);
+module_i2c_driver(adxl34x_driver);
 
 MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>");
 MODULE_DESCRIPTION("ADXL345/346 Three-Axis Digital Accelerometer I2C Bus Driver");
diff --git a/drivers/input/misc/bma150.c b/drivers/input/misc/bma150.c
index 8f55b54..e2f1e9f 100644
--- a/drivers/input/misc/bma150.c
+++ b/drivers/input/misc/bma150.c
@@ -673,19 +673,8 @@ static struct i2c_driver bma150_driver = {
 	.remove		= __devexit_p(bma150_remove),
 };
 
-static int __init BMA150_init(void)
-{
-	return i2c_add_driver(&bma150_driver);
-}
-
-static void __exit BMA150_exit(void)
-{
-	i2c_del_driver(&bma150_driver);
-}
+module_i2c_driver(bma150_driver);
 
 MODULE_AUTHOR("Albert Zhang <xu.zhang@bosch-sensortec.com>");
 MODULE_DESCRIPTION("BMA150 driver");
 MODULE_LICENSE("GPL");
-
-module_init(BMA150_init);
-module_exit(BMA150_exit);
diff --git a/drivers/input/misc/cma3000_d0x_i2c.c b/drivers/input/misc/cma3000_d0x_i2c.c
index d100cc5..fe9b85f 100644
--- a/drivers/input/misc/cma3000_d0x_i2c.c
+++ b/drivers/input/misc/cma3000_d0x_i2c.c
@@ -125,18 +125,7 @@ static struct i2c_driver cma3000_i2c_driver = {
 	},
 };
 
-static int __init cma3000_i2c_init(void)
-{
-	return i2c_add_driver(&cma3000_i2c_driver);
-}
-
-static void __exit cma3000_i2c_exit(void)
-{
-	i2c_del_driver(&cma3000_i2c_driver);
-}
-
-module_init(cma3000_i2c_init);
-module_exit(cma3000_i2c_exit);
+module_i2c_driver(cma3000_i2c_driver);
 
 MODULE_DESCRIPTION("CMA3000-D0x Accelerometer I2C Driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/input/misc/gp2ap002a00f.c b/drivers/input/misc/gp2ap002a00f.c
index 71fba8c..b6664cf 100644
--- a/drivers/input/misc/gp2ap002a00f.c
+++ b/drivers/input/misc/gp2ap002a00f.c
@@ -281,18 +281,7 @@ static struct i2c_driver gp2a_i2c_driver = {
 	.id_table	= gp2a_i2c_id,
 };
 
-static int __init gp2a_init(void)
-{
-	return i2c_add_driver(&gp2a_i2c_driver);
-}
-
-static void __exit gp2a_exit(void)
-{
-	i2c_del_driver(&gp2a_i2c_driver);
-}
-
-module_init(gp2a_init);
-module_exit(gp2a_exit);
+module_i2c_driver(gp2a_i2c_driver);
 
 MODULE_AUTHOR("Courtney Cavin <courtney.cavin@sonyericsson.com>");
 MODULE_DESCRIPTION("Sharp GP2AP002A00F I2C Proximity/Opto sensor driver");
diff --git a/drivers/input/misc/kxtj9.c b/drivers/input/misc/kxtj9.c
index 783597a..1c15900 100644
--- a/drivers/input/misc/kxtj9.c
+++ b/drivers/input/misc/kxtj9.c
@@ -655,17 +655,7 @@ static struct i2c_driver kxtj9_driver = {
 	.id_table	= kxtj9_id,
 };
 
-static int __init kxtj9_init(void)
-{
-	return i2c_add_driver(&kxtj9_driver);
-}
-module_init(kxtj9_init);
-
-static void __exit kxtj9_exit(void)
-{
-	i2c_del_driver(&kxtj9_driver);
-}
-module_exit(kxtj9_exit);
+module_i2c_driver(kxtj9_driver);
 
 MODULE_DESCRIPTION("KXTJ9 accelerometer driver");
 MODULE_AUTHOR("Chris Hudson <chudson@kionix.com>");
diff --git a/drivers/input/misc/mma8450.c b/drivers/input/misc/mma8450.c
index 4d60080..873ebce 100644
--- a/drivers/input/misc/mma8450.c
+++ b/drivers/input/misc/mma8450.c
@@ -247,17 +247,7 @@ static struct i2c_driver mma8450_driver = {
 	.id_table	= mma8450_id,
 };
 
-static int __init mma8450_init(void)
-{
-	return i2c_add_driver(&mma8450_driver);
-}
-module_init(mma8450_init);
-
-static void __exit mma8450_exit(void)
-{
-	i2c_del_driver(&mma8450_driver);
-}
-module_exit(mma8450_exit);
+module_i2c_driver(mma8450_driver);
 
 MODULE_AUTHOR("Freescale Semiconductor, Inc.");
 MODULE_DESCRIPTION("MMA8450 3-Axis Accelerometer Driver");
diff --git a/drivers/input/misc/mpu3050.c b/drivers/input/misc/mpu3050.c
index 208d1a1..5403c57 100644
--- a/drivers/input/misc/mpu3050.c
+++ b/drivers/input/misc/mpu3050.c
@@ -475,17 +475,7 @@ static struct i2c_driver mpu3050_i2c_driver = {
 	.id_table	= mpu3050_ids,
 };
 
-static int __init mpu3050_init(void)
-{
-	return i2c_add_driver(&mpu3050_i2c_driver);
-}
-module_init(mpu3050_init);
-
-static void __exit mpu3050_exit(void)
-{
-	i2c_del_driver(&mpu3050_i2c_driver);
-}
-module_exit(mpu3050_exit);
+module_i2c_driver(mpu3050_i2c_driver);
 
 MODULE_AUTHOR("Wistron Corp.");
 MODULE_DESCRIPTION("MPU3050 Tri-axis gyroscope driver");
diff --git a/drivers/input/misc/pcf8574_keypad.c b/drivers/input/misc/pcf8574_keypad.c
index 08be1a3..544c663 100644
--- a/drivers/input/misc/pcf8574_keypad.c
+++ b/drivers/input/misc/pcf8574_keypad.c
@@ -216,17 +216,7 @@ static struct i2c_driver pcf8574_kp_driver = {
 	.id_table = pcf8574_kp_id,
 };
 
-static int __init pcf8574_kp_init(void)
-{
-	return i2c_add_driver(&pcf8574_kp_driver);
-}
-module_init(pcf8574_kp_init);
-
-static void __exit pcf8574_kp_exit(void)
-{
-	i2c_del_driver(&pcf8574_kp_driver);
-}
-module_exit(pcf8574_kp_exit);
+module_i2c_driver(pcf8574_kp_driver);
 
 MODULE_AUTHOR("Michael Hennerich");
 MODULE_DESCRIPTION("Keypad input driver for 16 keys connected to PCF8574");
diff --git a/drivers/input/mouse/synaptics_i2c.c b/drivers/input/mouse/synaptics_i2c.c
index 1c58aaf..f1467570 100644
--- a/drivers/input/mouse/synaptics_i2c.c
+++ b/drivers/input/mouse/synaptics_i2c.c
@@ -672,18 +672,7 @@ static struct i2c_driver synaptics_i2c_driver = {
 	.id_table	= synaptics_i2c_id_table,
 };
 
-static int __init synaptics_i2c_init(void)
-{
-	return i2c_add_driver(&synaptics_i2c_driver);
-}
-
-static void __exit synaptics_i2c_exit(void)
-{
-	i2c_del_driver(&synaptics_i2c_driver);
-}
-
-module_init(synaptics_i2c_init);
-module_exit(synaptics_i2c_exit);
+module_i2c_driver(synaptics_i2c_driver);
 
 MODULE_DESCRIPTION("Synaptics I2C touchpad driver");
 MODULE_AUTHOR("Mike Rapoport, Igor Grinberg, Compulab");
diff --git a/drivers/input/touchscreen/ad7879-i2c.c b/drivers/input/touchscreen/ad7879-i2c.c
index 0dac671..3054354 100644
--- a/drivers/input/touchscreen/ad7879-i2c.c
+++ b/drivers/input/touchscreen/ad7879-i2c.c
@@ -102,17 +102,7 @@ static struct i2c_driver ad7879_i2c_driver = {
 	.id_table	= ad7879_id,
 };
 
-static int __init ad7879_i2c_init(void)
-{
-	return i2c_add_driver(&ad7879_i2c_driver);
-}
-module_init(ad7879_i2c_init);
-
-static void __exit ad7879_i2c_exit(void)
-{
-	i2c_del_driver(&ad7879_i2c_driver);
-}
-module_exit(ad7879_i2c_exit);
+module_i2c_driver(ad7879_i2c_driver);
 
 MODULE_AUTHOR("Michael Hennerich <hennerich@blackfin.uclinux.org>");
 MODULE_DESCRIPTION("AD7879(-1) touchscreen I2C bus driver");
diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index a596c27..19d4ea6 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -1267,18 +1267,7 @@ static struct i2c_driver mxt_driver = {
 	.id_table	= mxt_id,
 };
 
-static int __init mxt_init(void)
-{
-	return i2c_add_driver(&mxt_driver);
-}
-
-static void __exit mxt_exit(void)
-{
-	i2c_del_driver(&mxt_driver);
-}
-
-module_init(mxt_init);
-module_exit(mxt_exit);
+module_i2c_driver(mxt_driver);
 
 /* Module information */
 MODULE_AUTHOR("Joonyoung Shim <jy0922.shim@samsung.com>");
diff --git a/drivers/input/touchscreen/auo-pixcir-ts.c b/drivers/input/touchscreen/auo-pixcir-ts.c
index 94fb9fb..c7047b6 100644
--- a/drivers/input/touchscreen/auo-pixcir-ts.c
+++ b/drivers/input/touchscreen/auo-pixcir-ts.c
@@ -635,17 +635,7 @@ static struct i2c_driver auo_pixcir_driver = {
 	.id_table	= auo_pixcir_idtable,
 };
 
-static int __init auo_pixcir_init(void)
-{
-	return i2c_add_driver(&auo_pixcir_driver);
-}
-module_init(auo_pixcir_init);
-
-static void __exit auo_pixcir_exit(void)
-{
-	i2c_del_driver(&auo_pixcir_driver);
-}
-module_exit(auo_pixcir_exit);
+module_i2c_driver(auo_pixcir_driver);
 
 MODULE_DESCRIPTION("AUO-PIXCIR touchscreen driver");
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/input/touchscreen/bu21013_ts.c b/drivers/input/touchscreen/bu21013_ts.c
index 902c721..f2d03c0 100644
--- a/drivers/input/touchscreen/bu21013_ts.c
+++ b/drivers/input/touchscreen/bu21013_ts.c
@@ -652,30 +652,7 @@ static struct i2c_driver bu21013_driver = {
 	.id_table	=	bu21013_id,
 };
 
-/**
- * bu21013_init() - initializes the bu21013 touchscreen driver
- *
- * This function used to initializes the bu21013
- * touchscreen driver and returns integer.
- */
-static int __init bu21013_init(void)
-{
-	return i2c_add_driver(&bu21013_driver);
-}
-
-/**
- * bu21013_exit() - de-initializes the bu21013 touchscreen driver
- *
- * This function uses to de-initializes the bu21013
- * touchscreen driver and returns none.
- */
-static void __exit bu21013_exit(void)
-{
-	i2c_del_driver(&bu21013_driver);
-}
-
-module_init(bu21013_init);
-module_exit(bu21013_exit);
+module_i2c_driver(bu21013_driver);
 
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Naveen Kumar G <naveen.gaddipati@stericsson.com>");
diff --git a/drivers/input/touchscreen/cy8ctmg110_ts.c b/drivers/input/touchscreen/cy8ctmg110_ts.c
index d8815c5..237753a 100644
--- a/drivers/input/touchscreen/cy8ctmg110_ts.c
+++ b/drivers/input/touchscreen/cy8ctmg110_ts.c
@@ -350,18 +350,7 @@ static struct i2c_driver cy8ctmg110_driver = {
 	.remove		= __devexit_p(cy8ctmg110_remove),
 };
 
-static int __init cy8ctmg110_init(void)
-{
-	return i2c_add_driver(&cy8ctmg110_driver);
-}
-
-static void __exit cy8ctmg110_exit(void)
-{
-	i2c_del_driver(&cy8ctmg110_driver);
-}
-
-module_init(cy8ctmg110_init);
-module_exit(cy8ctmg110_exit);
+module_i2c_driver(cy8ctmg110_driver);
 
 MODULE_AUTHOR("Samuli Konttila <samuli.konttila@aavamobile.com>");
 MODULE_DESCRIPTION("cy8ctmg110 TouchScreen Driver");
diff --git a/drivers/input/touchscreen/eeti_ts.c b/drivers/input/touchscreen/eeti_ts.c
index 1df19bb..503c709 100644
--- a/drivers/input/touchscreen/eeti_ts.c
+++ b/drivers/input/touchscreen/eeti_ts.c
@@ -320,20 +320,8 @@ static struct i2c_driver eeti_ts_driver = {
 	.id_table = eeti_ts_id,
 };
 
-static int __init eeti_ts_init(void)
-{
-	return i2c_add_driver(&eeti_ts_driver);
-}
-
-static void __exit eeti_ts_exit(void)
-{
-	i2c_del_driver(&eeti_ts_driver);
-}
+module_i2c_driver(eeti_ts_driver);
 
 MODULE_DESCRIPTION("EETI Touchscreen driver");
 MODULE_AUTHOR("Daniel Mack <daniel@caiaq.de>");
 MODULE_LICENSE("GPL");
-
-module_init(eeti_ts_init);
-module_exit(eeti_ts_exit);
-
diff --git a/drivers/input/touchscreen/egalax_ts.c b/drivers/input/touchscreen/egalax_ts.c
index eadcc2e..70524dd 100644
--- a/drivers/input/touchscreen/egalax_ts.c
+++ b/drivers/input/touchscreen/egalax_ts.c
@@ -285,18 +285,7 @@ static struct i2c_driver egalax_ts_driver = {
 	.remove		= __devexit_p(egalax_ts_remove),
 };
 
-static int __init egalax_ts_init(void)
-{
-	return i2c_add_driver(&egalax_ts_driver);
-}
-
-static void __exit egalax_ts_exit(void)
-{
-	i2c_del_driver(&egalax_ts_driver);
-}
-
-module_init(egalax_ts_init);
-module_exit(egalax_ts_exit);
+module_i2c_driver(egalax_ts_driver);
 
 MODULE_AUTHOR("Freescale Semiconductor, Inc.");
 MODULE_DESCRIPTION("Touchscreen driver for EETI eGalax touch controller");
diff --git a/drivers/input/touchscreen/max11801_ts.c b/drivers/input/touchscreen/max11801_ts.c
index 4627fe5..4eab50b 100644
--- a/drivers/input/touchscreen/max11801_ts.c
+++ b/drivers/input/touchscreen/max11801_ts.c
@@ -255,18 +255,7 @@ static struct i2c_driver max11801_ts_driver = {
 	.remove		= __devexit_p(max11801_ts_remove),
 };
 
-static int __init max11801_ts_init(void)
-{
-	return i2c_add_driver(&max11801_ts_driver);
-}
-
-static void __exit max11801_ts_exit(void)
-{
-	i2c_del_driver(&max11801_ts_driver);
-}
-
-module_init(max11801_ts_init);
-module_exit(max11801_ts_exit);
+module_i2c_driver(max11801_ts_driver);
 
 MODULE_AUTHOR("Zhang Jiejing <jiejing.zhang@freescale.com>");
 MODULE_DESCRIPTION("Touchscreen driver for MAXI MAX11801 controller");
diff --git a/drivers/input/touchscreen/mcs5000_ts.c b/drivers/input/touchscreen/mcs5000_ts.c
index 2d84c80..b528511 100644
--- a/drivers/input/touchscreen/mcs5000_ts.c
+++ b/drivers/input/touchscreen/mcs5000_ts.c
@@ -302,18 +302,7 @@ static struct i2c_driver mcs5000_ts_driver = {
 	.id_table	= mcs5000_ts_id,
 };
 
-static int __init mcs5000_ts_init(void)
-{
-	return i2c_add_driver(&mcs5000_ts_driver);
-}
-
-static void __exit mcs5000_ts_exit(void)
-{
-	i2c_del_driver(&mcs5000_ts_driver);
-}
-
-module_init(mcs5000_ts_init);
-module_exit(mcs5000_ts_exit);
+module_i2c_driver(mcs5000_ts_driver);
 
 /* Module information */
 MODULE_AUTHOR("Joonyoung Shim <jy0922.shim@samsung.com>");
diff --git a/drivers/input/touchscreen/migor_ts.c b/drivers/input/touchscreen/migor_ts.c
index 5226194..c038db9 100644
--- a/drivers/input/touchscreen/migor_ts.c
+++ b/drivers/input/touchscreen/migor_ts.c
@@ -242,19 +242,8 @@ static struct i2c_driver migor_ts_driver = {
 	.id_table = migor_ts_id,
 };
 
-static int __init migor_ts_init(void)
-{
-	return i2c_add_driver(&migor_ts_driver);
-}
-
-static void __exit migor_ts_exit(void)
-{
-	i2c_del_driver(&migor_ts_driver);
-}
+module_i2c_driver(migor_ts_driver);
 
 MODULE_DESCRIPTION("MigoR Touchscreen driver");
 MODULE_AUTHOR("Magnus Damm <damm@opensource.se>");
 MODULE_LICENSE("GPL");
-
-module_init(migor_ts_init);
-module_exit(migor_ts_exit);
diff --git a/drivers/input/touchscreen/pixcir_i2c_ts.c b/drivers/input/touchscreen/pixcir_i2c_ts.c
index d5ac09a..72f6ba3 100644
--- a/drivers/input/touchscreen/pixcir_i2c_ts.c
+++ b/drivers/input/touchscreen/pixcir_i2c_ts.c
@@ -222,17 +222,7 @@ static struct i2c_driver pixcir_i2c_ts_driver = {
 	.id_table	= pixcir_i2c_ts_id,
 };
 
-static int __init pixcir_i2c_ts_init(void)
-{
-	return i2c_add_driver(&pixcir_i2c_ts_driver);
-}
-module_init(pixcir_i2c_ts_init);
-
-static void __exit pixcir_i2c_ts_exit(void)
-{
-	i2c_del_driver(&pixcir_i2c_ts_driver);
-}
-module_exit(pixcir_i2c_ts_exit);
+module_i2c_driver(pixcir_i2c_ts_driver);
 
 MODULE_AUTHOR("Jianchun Bian <jcbian@pixcir.com.cn>, Dequan Meng <dqmeng@pixcir.com.cn>");
 MODULE_DESCRIPTION("Pixcir I2C Touchscreen Driver");
diff --git a/drivers/input/touchscreen/st1232.c b/drivers/input/touchscreen/st1232.c
index 8825fe3..cbbf71b 100644
--- a/drivers/input/touchscreen/st1232.c
+++ b/drivers/input/touchscreen/st1232.c
@@ -268,17 +268,7 @@ static struct i2c_driver st1232_ts_driver = {
 	},
 };
 
-static int __init st1232_ts_init(void)
-{
-	return i2c_add_driver(&st1232_ts_driver);
-}
-module_init(st1232_ts_init);
-
-static void __exit st1232_ts_exit(void)
-{
-	i2c_del_driver(&st1232_ts_driver);
-}
-module_exit(st1232_ts_exit);
+module_i2c_driver(st1232_ts_driver);
 
 MODULE_AUTHOR("Tony SIM <chinyeow.sim.xt@renesas.com>");
 MODULE_DESCRIPTION("SITRONIX ST1232 Touchscreen Controller Driver");
diff --git a/drivers/input/touchscreen/tsc2007.c b/drivers/input/touchscreen/tsc2007.c
index 1f674cb..1473d23 100644
--- a/drivers/input/touchscreen/tsc2007.c
+++ b/drivers/input/touchscreen/tsc2007.c
@@ -399,18 +399,7 @@ static struct i2c_driver tsc2007_driver = {
 	.remove		= __devexit_p(tsc2007_remove),
 };
 
-static int __init tsc2007_init(void)
-{
-	return i2c_add_driver(&tsc2007_driver);
-}
-
-static void __exit tsc2007_exit(void)
-{
-	i2c_del_driver(&tsc2007_driver);
-}
-
-module_init(tsc2007_init);
-module_exit(tsc2007_exit);
+module_i2c_driver(tsc2007_driver);
 
 MODULE_AUTHOR("Kwangwoo Lee <kwlee@mtekvision.com>");
 MODULE_DESCRIPTION("TSC2007 TouchScreen Driver");
-- 
1.7.5.4



