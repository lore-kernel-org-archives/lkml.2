Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756961Ab1KVJDT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 04:03:19 -0500
Received: from emcscan.emc.com.tw ([192.72.220.5]:62061 "EHLO
	emcscan.emc.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756169Ab1KVJC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 04:02:59 -0500
From: JJ Ding <jj_ding@emc.com.tw>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        JJ Ding <jj_ding@emc.com.tw>, JJ Ding <dgdunix@gmail.com>
Subject: [PATCH TRIVIAL 5/5] Input: touchscreen: use macro module_platform_driver()
Date: Tue, 22 Nov 2011 17:00:46 +0800
Message-Id: <1321952446-7591-6-git-send-email-jj_ding@emc.com.tw>
X-Mailer: git-send-email 1.7.8-rc2
In-Reply-To: <1321952446-7591-1-git-send-email-jj_ding@emc.com.tw>
References: <1321952446-7591-1-git-send-email-jj_ding@emc.com.tw>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: JJ Ding <dgdunix@gmail.com>

Commit 940ab88962bc1aff3273a8356d64577a6e386736 introduced a new macro to
save some platform_driver boilerplate code. Use it.

Signed-off-by: JJ Ding <dgdunix@gmail.com>
---
 drivers/input/touchscreen/88pm860x-ts.c      |   13 +------------
 drivers/input/touchscreen/atmel-wm97xx.c     |   13 +------------
 drivers/input/touchscreen/atmel_tsadcc.c     |   15 +--------------
 drivers/input/touchscreen/da9034-ts.c        |   13 +------------
 drivers/input/touchscreen/intel-mid-touch.c  |   13 +------------
 drivers/input/touchscreen/jornada720_ts.c    |   14 +-------------
 drivers/input/touchscreen/lpc32xx_ts.c       |   13 +------------
 drivers/input/touchscreen/mainstone-wm97xx.c |   14 +-------------
 drivers/input/touchscreen/mc13783_ts.c       |   13 +------------
 drivers/input/touchscreen/pcap_ts.c          |   14 +-------------
 drivers/input/touchscreen/s3c2410_ts.c       |   14 +-------------
 drivers/input/touchscreen/stmpe-ts.c         |   15 +--------------
 drivers/input/touchscreen/tnetv107x-ts.c     |   14 +-------------
 drivers/input/touchscreen/tps6507x-ts.c      |   13 +------------
 drivers/input/touchscreen/ucb1400_ts.c       |   14 +-------------
 drivers/input/touchscreen/w90p910_ts.c       |   14 +-------------
 drivers/input/touchscreen/wm831x-ts.c        |   13 +------------
 drivers/input/touchscreen/zylonite-wm97xx.c  |   14 +-------------
 18 files changed, 18 insertions(+), 228 deletions(-)

diff --git a/drivers/input/touchscreen/88pm860x-ts.c b/drivers/input/touchscreen/88pm860x-ts.c
index b3aebc2..05f30b7 100644
--- a/drivers/input/touchscreen/88pm860x-ts.c
+++ b/drivers/input/touchscreen/88pm860x-ts.c
@@ -217,18 +217,7 @@ static struct platform_driver pm860x_touch_driver = {
 	.probe	= pm860x_touch_probe,
 	.remove	= __devexit_p(pm860x_touch_remove),
 };
-
-static int __init pm860x_touch_init(void)
-{
-	return platform_driver_register(&pm860x_touch_driver);
-}
-module_init(pm860x_touch_init);
-
-static void __exit pm860x_touch_exit(void)
-{
-	platform_driver_unregister(&pm860x_touch_driver);
-}
-module_exit(pm860x_touch_exit);
+module_platform_driver(pm860x_touch_driver);
 
 MODULE_DESCRIPTION("Touchscreen driver for Marvell Semiconductor 88PM860x");
 MODULE_AUTHOR("Haojian Zhuang <haojian.zhuang@marvell.com>");
diff --git a/drivers/input/touchscreen/atmel-wm97xx.c b/drivers/input/touchscreen/atmel-wm97xx.c
index 8034cbb..d016cb2 100644
--- a/drivers/input/touchscreen/atmel-wm97xx.c
+++ b/drivers/input/touchscreen/atmel-wm97xx.c
@@ -429,18 +429,7 @@ static struct platform_driver atmel_wm97xx_driver = {
 	.suspend	= atmel_wm97xx_suspend,
 	.resume		= atmel_wm97xx_resume,
 };
-
-static int __init atmel_wm97xx_init(void)
-{
-	return platform_driver_probe(&atmel_wm97xx_driver, atmel_wm97xx_probe);
-}
-module_init(atmel_wm97xx_init);
-
-static void __exit atmel_wm97xx_exit(void)
-{
-	platform_driver_unregister(&atmel_wm97xx_driver);
-}
-module_exit(atmel_wm97xx_exit);
+module_platform_driver(atmel_wm97xx_driver);
 
 MODULE_AUTHOR("Hans-Christian Egtvedt <egtvedt@samfundet.no>");
 MODULE_DESCRIPTION("wm97xx continuous touch driver for Atmel AT91 and AVR32");
diff --git a/drivers/input/touchscreen/atmel_tsadcc.c b/drivers/input/touchscreen/atmel_tsadcc.c
index 122a878..201b2d2 100644
--- a/drivers/input/touchscreen/atmel_tsadcc.c
+++ b/drivers/input/touchscreen/atmel_tsadcc.c
@@ -351,20 +351,7 @@ static struct platform_driver atmel_tsadcc_driver = {
 		.name	= "atmel_tsadcc",
 	},
 };
-
-static int __init atmel_tsadcc_init(void)
-{
-	return platform_driver_register(&atmel_tsadcc_driver);
-}
-
-static void __exit atmel_tsadcc_exit(void)
-{
-	platform_driver_unregister(&atmel_tsadcc_driver);
-}
-
-module_init(atmel_tsadcc_init);
-module_exit(atmel_tsadcc_exit);
-
+module_platform_driver(atmel_tsadcc_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Atmel TouchScreen Driver");
diff --git a/drivers/input/touchscreen/da9034-ts.c b/drivers/input/touchscreen/da9034-ts.c
index 2b72a59..36b65cf 100644
--- a/drivers/input/touchscreen/da9034-ts.c
+++ b/drivers/input/touchscreen/da9034-ts.c
@@ -379,18 +379,7 @@ static struct platform_driver da9034_touch_driver = {
 	.probe		= da9034_touch_probe,
 	.remove		= __devexit_p(da9034_touch_remove),
 };
-
-static int __init da9034_touch_init(void)
-{
-	return platform_driver_register(&da9034_touch_driver);
-}
-module_init(da9034_touch_init);
-
-static void __exit da9034_touch_exit(void)
-{
-	platform_driver_unregister(&da9034_touch_driver);
-}
-module_exit(da9034_touch_exit);
+module_platform_driver(da9034_touch_driver);
 
 MODULE_DESCRIPTION("Touchscreen driver for Dialog Semiconductor DA9034");
 MODULE_AUTHOR("Eric Miao <eric.miao@marvell.com>, Bin Yang <bin.yang@marvell.com>");
diff --git a/drivers/input/touchscreen/intel-mid-touch.c b/drivers/input/touchscreen/intel-mid-touch.c
index 3276952..3cd7a83 100644
--- a/drivers/input/touchscreen/intel-mid-touch.c
+++ b/drivers/input/touchscreen/intel-mid-touch.c
@@ -664,18 +664,7 @@ static struct platform_driver mrstouch_driver = {
 	.probe		= mrstouch_probe,
 	.remove		= __devexit_p(mrstouch_remove),
 };
-
-static int __init mrstouch_init(void)
-{
-	return platform_driver_register(&mrstouch_driver);
-}
-module_init(mrstouch_init);
-
-static void __exit mrstouch_exit(void)
-{
-	platform_driver_unregister(&mrstouch_driver);
-}
-module_exit(mrstouch_exit);
+module_platform_driver(mrstouch_driver);
 
 MODULE_AUTHOR("Sreedhara Murthy. D.S, sreedhara.ds@intel.com");
 MODULE_DESCRIPTION("Intel Moorestown Resistive Touch Screen Driver");
diff --git a/drivers/input/touchscreen/jornada720_ts.c b/drivers/input/touchscreen/jornada720_ts.c
index 50076c2..c3848ad 100644
--- a/drivers/input/touchscreen/jornada720_ts.c
+++ b/drivers/input/touchscreen/jornada720_ts.c
@@ -172,16 +172,4 @@ static struct platform_driver jornada720_ts_driver = {
 		.owner	= THIS_MODULE,
 	},
 };
-
-static int __init jornada720_ts_init(void)
-{
-	return platform_driver_register(&jornada720_ts_driver);
-}
-
-static void __exit jornada720_ts_exit(void)
-{
-	platform_driver_unregister(&jornada720_ts_driver);
-}
-
-module_init(jornada720_ts_init);
-module_exit(jornada720_ts_exit);
+module_platform_driver(jornada720_ts_driver);
diff --git a/drivers/input/touchscreen/lpc32xx_ts.c b/drivers/input/touchscreen/lpc32xx_ts.c
index 0a484ed..afcd069 100644
--- a/drivers/input/touchscreen/lpc32xx_ts.c
+++ b/drivers/input/touchscreen/lpc32xx_ts.c
@@ -392,18 +392,7 @@ static struct platform_driver lpc32xx_ts_driver = {
 		.pm	= LPC32XX_TS_PM_OPS,
 	},
 };
-
-static int __init lpc32xx_ts_init(void)
-{
-	return platform_driver_register(&lpc32xx_ts_driver);
-}
-module_init(lpc32xx_ts_init);
-
-static void __exit lpc32xx_ts_exit(void)
-{
-	platform_driver_unregister(&lpc32xx_ts_driver);
-}
-module_exit(lpc32xx_ts_exit);
+module_platform_driver(lpc32xx_ts_driver);
 
 MODULE_AUTHOR("Kevin Wells <kevin.wells@nxp.com");
 MODULE_DESCRIPTION("LPC32XX TSC Driver");
diff --git a/drivers/input/touchscreen/mainstone-wm97xx.c b/drivers/input/touchscreen/mainstone-wm97xx.c
index e966c29..7d2b213 100644
--- a/drivers/input/touchscreen/mainstone-wm97xx.c
+++ b/drivers/input/touchscreen/mainstone-wm97xx.c
@@ -302,19 +302,7 @@ static struct platform_driver mainstone_wm97xx_driver = {
 		.name = "wm97xx-touch",
 	},
 };
-
-static int __init mainstone_wm97xx_init(void)
-{
-	return platform_driver_register(&mainstone_wm97xx_driver);
-}
-
-static void __exit mainstone_wm97xx_exit(void)
-{
-	platform_driver_unregister(&mainstone_wm97xx_driver);
-}
-
-module_init(mainstone_wm97xx_init);
-module_exit(mainstone_wm97xx_exit);
+module_platform_driver(mainstone_wm97xx_driver);
 
 /* Module information */
 MODULE_AUTHOR("Liam Girdwood <lrg@slimlogic.co.uk>");
diff --git a/drivers/input/touchscreen/mc13783_ts.c b/drivers/input/touchscreen/mc13783_ts.c
index ede0274..68f86f7 100644
--- a/drivers/input/touchscreen/mc13783_ts.c
+++ b/drivers/input/touchscreen/mc13783_ts.c
@@ -240,18 +240,7 @@ static struct platform_driver mc13783_ts_driver = {
 		.name	= MC13783_TS_NAME,
 	},
 };
-
-static int __init mc13783_ts_init(void)
-{
-	return platform_driver_probe(&mc13783_ts_driver, &mc13783_ts_probe);
-}
-module_init(mc13783_ts_init);
-
-static void __exit mc13783_ts_exit(void)
-{
-	platform_driver_unregister(&mc13783_ts_driver);
-}
-module_exit(mc13783_ts_exit);
+module_platform_driver(mc13783_ts_driver);
 
 MODULE_DESCRIPTION("MC13783 input touchscreen driver");
 MODULE_AUTHOR("Sascha Hauer <s.hauer@pengutronix.de>");
diff --git a/drivers/input/touchscreen/pcap_ts.c b/drivers/input/touchscreen/pcap_ts.c
index ea6ef16..f57aeb8 100644
--- a/drivers/input/touchscreen/pcap_ts.c
+++ b/drivers/input/touchscreen/pcap_ts.c
@@ -252,19 +252,7 @@ static struct platform_driver pcap_ts_driver = {
 		.pm	= PCAP_TS_PM_OPS,
 	},
 };
-
-static int __init pcap_ts_init(void)
-{
-	return platform_driver_register(&pcap_ts_driver);
-}
-
-static void __exit pcap_ts_exit(void)
-{
-	platform_driver_unregister(&pcap_ts_driver);
-}
-
-module_init(pcap_ts_init);
-module_exit(pcap_ts_exit);
+module_platform_driver(pcap_ts_driver);
 
 MODULE_DESCRIPTION("Motorola PCAP2 touchscreen driver");
 MODULE_AUTHOR("Daniel Ribeiro / Harald Welte");
diff --git a/drivers/input/touchscreen/s3c2410_ts.c b/drivers/input/touchscreen/s3c2410_ts.c
index 64ce697..bf1a064 100644
--- a/drivers/input/touchscreen/s3c2410_ts.c
+++ b/drivers/input/touchscreen/s3c2410_ts.c
@@ -432,19 +432,7 @@ static struct platform_driver s3c_ts_driver = {
 	.probe		= s3c2410ts_probe,
 	.remove		= __devexit_p(s3c2410ts_remove),
 };
-
-static int __init s3c2410ts_init(void)
-{
-	return platform_driver_register(&s3c_ts_driver);
-}
-
-static void __exit s3c2410ts_exit(void)
-{
-	platform_driver_unregister(&s3c_ts_driver);
-}
-
-module_init(s3c2410ts_init);
-module_exit(s3c2410ts_exit);
+module_platform_driver(s3c_ts_driver);
 
 MODULE_AUTHOR("Arnaud Patard <arnaud.patard@rtp-net.org>, "
 	      "Ben Dooks <ben@simtec.co.uk>, "
diff --git a/drivers/input/touchscreen/stmpe-ts.c b/drivers/input/touchscreen/stmpe-ts.c
index ae88e13..692b685 100644
--- a/drivers/input/touchscreen/stmpe-ts.c
+++ b/drivers/input/touchscreen/stmpe-ts.c
@@ -379,20 +379,7 @@ static struct platform_driver stmpe_ts_driver = {
 	.probe = stmpe_input_probe,
 	.remove = __devexit_p(stmpe_ts_remove),
 };
-
-static int __init stmpe_ts_init(void)
-{
-	return platform_driver_register(&stmpe_ts_driver);
-}
-
-module_init(stmpe_ts_init);
-
-static void __exit stmpe_ts_exit(void)
-{
-	platform_driver_unregister(&stmpe_ts_driver);
-}
-
-module_exit(stmpe_ts_exit);
+module_platform_driver(stmpe_ts_driver);
 
 MODULE_AUTHOR("Luotao Fu <l.fu@pengutronix.de>");
 MODULE_DESCRIPTION("STMPEXXX touchscreen driver");
diff --git a/drivers/input/touchscreen/tnetv107x-ts.c b/drivers/input/touchscreen/tnetv107x-ts.c
index 0e8f63e..7e74880 100644
--- a/drivers/input/touchscreen/tnetv107x-ts.c
+++ b/drivers/input/touchscreen/tnetv107x-ts.c
@@ -378,19 +378,7 @@ static struct platform_driver tsc_driver = {
 	.driver.name	= "tnetv107x-ts",
 	.driver.owner	= THIS_MODULE,
 };
-
-static int __init tsc_init(void)
-{
-	return platform_driver_register(&tsc_driver);
-}
-
-static void __exit tsc_exit(void)
-{
-	platform_driver_unregister(&tsc_driver);
-}
-
-module_init(tsc_init);
-module_exit(tsc_exit);
+module_platform_driver(tsc_driver);
 
 MODULE_AUTHOR("Cyril Chemparathy");
 MODULE_DESCRIPTION("TNETV107X Touchscreen Driver");
diff --git a/drivers/input/touchscreen/tps6507x-ts.c b/drivers/input/touchscreen/tps6507x-ts.c
index 4303149..6c6f6d8 100644
--- a/drivers/input/touchscreen/tps6507x-ts.c
+++ b/drivers/input/touchscreen/tps6507x-ts.c
@@ -371,18 +371,7 @@ static struct platform_driver tps6507x_ts_driver = {
 	.probe = tps6507x_ts_probe,
 	.remove = __devexit_p(tps6507x_ts_remove),
 };
-
-static int __init tps6507x_ts_init(void)
-{
-	return platform_driver_register(&tps6507x_ts_driver);
-}
-module_init(tps6507x_ts_init);
-
-static void __exit tps6507x_ts_exit(void)
-{
-	platform_driver_unregister(&tps6507x_ts_driver);
-}
-module_exit(tps6507x_ts_exit);
+module_platform_driver(tps6507x_ts_driver);
 
 MODULE_AUTHOR("Todd Fischer <todd.fischer@ridgerun.com>");
 MODULE_DESCRIPTION("TPS6507x - TouchScreen driver");
diff --git a/drivers/input/touchscreen/ucb1400_ts.c b/drivers/input/touchscreen/ucb1400_ts.c
index 3b5b5df..cf2440f 100644
--- a/drivers/input/touchscreen/ucb1400_ts.c
+++ b/drivers/input/touchscreen/ucb1400_ts.c
@@ -456,16 +456,7 @@ static struct platform_driver ucb1400_ts_driver = {
 		.name	= "ucb1400_ts",
 	},
 };
-
-static int __init ucb1400_ts_init(void)
-{
-	return platform_driver_register(&ucb1400_ts_driver);
-}
-
-static void __exit ucb1400_ts_exit(void)
-{
-	platform_driver_unregister(&ucb1400_ts_driver);
-}
+module_platform_driver(ucb1400_ts_driver);
 
 module_param(adcsync, bool, 0444);
 MODULE_PARM_DESC(adcsync, "Synchronize touch readings with ADCSYNC pin.");
@@ -479,8 +470,5 @@ MODULE_PARM_DESC(ts_delay_pressure,
 		"delay between panel setup and pressure read."
 		"  Default = 0us.");
 
-module_init(ucb1400_ts_init);
-module_exit(ucb1400_ts_exit);
-
 MODULE_DESCRIPTION("Philips UCB1400 touchscreen driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/input/touchscreen/w90p910_ts.c b/drivers/input/touchscreen/w90p910_ts.c
index 217aa51..9396b21 100644
--- a/drivers/input/touchscreen/w90p910_ts.c
+++ b/drivers/input/touchscreen/w90p910_ts.c
@@ -331,19 +331,7 @@ static struct platform_driver w90x900ts_driver = {
 		.owner	= THIS_MODULE,
 	},
 };
-
-static int __init w90x900ts_init(void)
-{
-	return platform_driver_register(&w90x900ts_driver);
-}
-
-static void __exit w90x900ts_exit(void)
-{
-	platform_driver_unregister(&w90x900ts_driver);
-}
-
-module_init(w90x900ts_init);
-module_exit(w90x900ts_exit);
+module_platform_driver(w90x900ts_driver);
 
 MODULE_AUTHOR("Wan ZongShun <mcuos.com@gmail.com>");
 MODULE_DESCRIPTION("w90p910 touch screen driver!");
diff --git a/drivers/input/touchscreen/wm831x-ts.c b/drivers/input/touchscreen/wm831x-ts.c
index 9175d49..4bc851a 100644
--- a/drivers/input/touchscreen/wm831x-ts.c
+++ b/drivers/input/touchscreen/wm831x-ts.c
@@ -401,18 +401,7 @@ static struct platform_driver wm831x_ts_driver = {
 	.probe = wm831x_ts_probe,
 	.remove = __devexit_p(wm831x_ts_remove),
 };
-
-static int __init wm831x_ts_init(void)
-{
-	return platform_driver_register(&wm831x_ts_driver);
-}
-module_init(wm831x_ts_init);
-
-static void __exit wm831x_ts_exit(void)
-{
-	platform_driver_unregister(&wm831x_ts_driver);
-}
-module_exit(wm831x_ts_exit);
+module_platform_driver(wm831x_ts_driver);
 
 /* Module information */
 MODULE_AUTHOR("Mark Brown <broonie@opensource.wolfsonmicro.com>");
diff --git a/drivers/input/touchscreen/zylonite-wm97xx.c b/drivers/input/touchscreen/zylonite-wm97xx.c
index f6328c0..add6e3b 100644
--- a/drivers/input/touchscreen/zylonite-wm97xx.c
+++ b/drivers/input/touchscreen/zylonite-wm97xx.c
@@ -223,19 +223,7 @@ static struct platform_driver zylonite_wm97xx_driver = {
 		.name	= "wm97xx-touch",
 	},
 };
-
-static int __init zylonite_wm97xx_init(void)
-{
-	return platform_driver_register(&zylonite_wm97xx_driver);
-}
-
-static void __exit zylonite_wm97xx_exit(void)
-{
-	platform_driver_unregister(&zylonite_wm97xx_driver);
-}
-
-module_init(zylonite_wm97xx_init);
-module_exit(zylonite_wm97xx_exit);
+module_platform_driver(zylonite_wm97xx_driver);
 
 /* Module information */
 MODULE_AUTHOR("Mark Brown <broonie@opensource.wolfsonmicro.com>");
-- 
1.7.8-rc2

