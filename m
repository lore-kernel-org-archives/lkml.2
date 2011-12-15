Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282Ab1LOGrB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 01:47:01 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:65369 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755459Ab1LOGq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 01:46:59 -0500
Message-ID: <1323931602.3305.1.camel@phoenix>
Subject: [PATCH RESEND] rtc: convert drivers/rtc/* to use
 module_platform_driver()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mike Frysinger <vapier.adi@gmail.com>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Ben Dooks <ben@simtec.co.uk>,
        John Stultz <john.stultz@linaro.org>, rtc-linux@googlegroups.com,
        Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 15 Dec 2011 14:46:42 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the drivers in drivers/rtc/* to use the
module_platform_driver() macro which makes the code smaller and a bit
simpler.

Cc: Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>
Cc: Mike Frysinger <vapier.adi@gmail.com>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Ben Dooks <ben@simtec.co.uk>
Cc: John Stultz <john.stultz@linaro.org>
Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Mike Frysinger <vapier@gentoo.org>
Acked-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
This patch was sent on https://lkml.org/lkml/2011/11/25/127.
I regenerate the patch against linux-next 20111214.
Also Cc Andrew Morton who seems to be mostly handing
the RTC stuff at the moment.

Axel

 drivers/rtc/rtc-88pm860x.c |   12 +-----------
 drivers/rtc/rtc-ab8500.c   |   12 +-----------
 drivers/rtc/rtc-bfin.c     |   13 +------------
 drivers/rtc/rtc-bq4802.c   |   13 +------------
 drivers/rtc/rtc-dm355evm.c |   12 +-----------
 drivers/rtc/rtc-ds1286.c   |   13 +------------
 drivers/rtc/rtc-ds1511.c   |   15 +--------------
 drivers/rtc/rtc-ds1553.c   |   13 +------------
 drivers/rtc/rtc-ds1742.c   |   13 +------------
 drivers/rtc/rtc-jz4740.c   |   12 +-----------
 drivers/rtc/rtc-lpc32xx.c  |   12 +-----------
 drivers/rtc/rtc-m48t35.c   |   13 +------------
 drivers/rtc/rtc-m48t59.c   |   13 +------------
 drivers/rtc/rtc-m48t86.c   |   13 +------------
 drivers/rtc/rtc-max8925.c  |   12 +-----------
 drivers/rtc/rtc-max8998.c  |   12 +-----------
 drivers/rtc/rtc-mpc5121.c  |   12 +-----------
 drivers/rtc/rtc-mrst.c     |   13 +------------
 drivers/rtc/rtc-pcf50633.c |   12 +-----------
 drivers/rtc/rtc-pm8xxx.c   |   12 +-----------
 drivers/rtc/rtc-puv3.c     |   16 +---------------
 drivers/rtc/rtc-s3c.c      |   16 +---------------
 drivers/rtc/rtc-sa1100.c   |   13 +------------
 drivers/rtc/rtc-spear.c    |   12 +-----------
 drivers/rtc/rtc-stk17ta8.c |   13 +------------
 drivers/rtc/rtc-stmp3xxx.c |   13 +------------
 drivers/rtc/rtc-v3020.c    |   13 +------------
 drivers/rtc/rtc-vr41xx.c   |   13 +------------
 drivers/rtc/rtc-vt8500.c   |   12 +-----------
 drivers/rtc/rtc-wm831x.c   |   12 +-----------
 drivers/rtc/rtc-wm8350.c   |   12 +-----------
 31 files changed, 31 insertions(+), 366 deletions(-)

diff --git a/drivers/rtc/rtc-88pm860x.c b/drivers/rtc/rtc-88pm860x.c
index 64b847b..f04761e 100644
--- a/drivers/rtc/rtc-88pm860x.c
+++ b/drivers/rtc/rtc-88pm860x.c
@@ -410,17 +410,7 @@ static struct platform_driver pm860x_rtc_driver = {
 	.remove		= __devexit_p(pm860x_rtc_remove),
 };
 
-static int __init pm860x_rtc_init(void)
-{
-	return platform_driver_register(&pm860x_rtc_driver);
-}
-module_init(pm860x_rtc_init);
-
-static void __exit pm860x_rtc_exit(void)
-{
-	platform_driver_unregister(&pm860x_rtc_driver);
-}
-module_exit(pm860x_rtc_exit);
+module_platform_driver(pm860x_rtc_driver);
 
 MODULE_DESCRIPTION("Marvell 88PM860x RTC driver");
 MODULE_AUTHOR("Haojian Zhuang <haojian.zhuang@marvell.com>");
diff --git a/drivers/rtc/rtc-ab8500.c b/drivers/rtc/rtc-ab8500.c
index df7bfc3..a0a9810 100644
--- a/drivers/rtc/rtc-ab8500.c
+++ b/drivers/rtc/rtc-ab8500.c
@@ -463,18 +463,8 @@ static struct platform_driver ab8500_rtc_driver = {
 	.remove = __devexit_p(ab8500_rtc_remove),
 };
 
-static int __init ab8500_rtc_init(void)
-{
-	return platform_driver_register(&ab8500_rtc_driver);
-}
-
-static void __exit ab8500_rtc_exit(void)
-{
-	platform_driver_unregister(&ab8500_rtc_driver);
-}
+module_platform_driver(ab8500_rtc_driver);
 
-module_init(ab8500_rtc_init);
-module_exit(ab8500_rtc_exit);
 MODULE_AUTHOR("Virupax Sadashivpetimath <virupax.sadashivpetimath@stericsson.com>");
 MODULE_DESCRIPTION("AB8500 RTC Driver");
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/rtc/rtc-bfin.c b/drivers/rtc/rtc-bfin.c
index 90d8662..abfc1a0 100644
--- a/drivers/rtc/rtc-bfin.c
+++ b/drivers/rtc/rtc-bfin.c
@@ -456,18 +456,7 @@ static struct platform_driver bfin_rtc_driver = {
 	.resume		= bfin_rtc_resume,
 };
 
-static int __init bfin_rtc_init(void)
-{
-	return platform_driver_register(&bfin_rtc_driver);
-}
-
-static void __exit bfin_rtc_exit(void)
-{
-	platform_driver_unregister(&bfin_rtc_driver);
-}
-
-module_init(bfin_rtc_init);
-module_exit(bfin_rtc_exit);
+module_platform_driver(bfin_rtc_driver);
 
 MODULE_DESCRIPTION("Blackfin On-Chip Real Time Clock Driver");
 MODULE_AUTHOR("Mike Frysinger <vapier@gentoo.org>");
diff --git a/drivers/rtc/rtc-bq4802.c b/drivers/rtc/rtc-bq4802.c
index 128270c..bf612ef 100644
--- a/drivers/rtc/rtc-bq4802.c
+++ b/drivers/rtc/rtc-bq4802.c
@@ -218,15 +218,4 @@ static struct platform_driver bq4802_driver = {
 	.remove		= __devexit_p(bq4802_remove),
 };
 
-static int __init bq4802_init(void)
-{
-	return platform_driver_register(&bq4802_driver);
-}
-
-static void __exit bq4802_exit(void)
-{
-	platform_driver_unregister(&bq4802_driver);
-}
-
-module_init(bq4802_init);
-module_exit(bq4802_exit);
+module_platform_driver(bq4802_driver);
diff --git a/drivers/rtc/rtc-dm355evm.c b/drivers/rtc/rtc-dm355evm.c
index 2322c43..d4457af 100644
--- a/drivers/rtc/rtc-dm355evm.c
+++ b/drivers/rtc/rtc-dm355evm.c
@@ -161,16 +161,6 @@ static struct platform_driver rtc_dm355evm_driver = {
 	},
 };
 
-static int __init dm355evm_rtc_init(void)
-{
-	return platform_driver_register(&rtc_dm355evm_driver);
-}
-module_init(dm355evm_rtc_init);
-
-static void __exit dm355evm_rtc_exit(void)
-{
-	platform_driver_unregister(&rtc_dm355evm_driver);
-}
-module_exit(dm355evm_rtc_exit);
+module_platform_driver(rtc_dm355evm_driver);
 
 MODULE_LICENSE("GPL");
diff --git a/drivers/rtc/rtc-ds1286.c b/drivers/rtc/rtc-ds1286.c
index 68e6caf..990c3ff 100644
--- a/drivers/rtc/rtc-ds1286.c
+++ b/drivers/rtc/rtc-ds1286.c
@@ -396,21 +396,10 @@ static struct platform_driver ds1286_platform_driver = {
 	.remove		= __devexit_p(ds1286_remove),
 };
 
-static int __init ds1286_init(void)
-{
-	return platform_driver_register(&ds1286_platform_driver);
-}
-
-static void __exit ds1286_exit(void)
-{
-	platform_driver_unregister(&ds1286_platform_driver);
-}
+module_platform_driver(ds1286_platform_driver);
 
 MODULE_AUTHOR("Thomas Bogendoerfer <tsbogend@alpha.franken.de>");
 MODULE_DESCRIPTION("DS1286 RTC driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
 MODULE_ALIAS("platform:rtc-ds1286");
-
-module_init(ds1286_init);
-module_exit(ds1286_exit);
diff --git a/drivers/rtc/rtc-ds1511.c b/drivers/rtc/rtc-ds1511.c
index 586c244..761f36b 100644
--- a/drivers/rtc/rtc-ds1511.c
+++ b/drivers/rtc/rtc-ds1511.c
@@ -580,20 +580,7 @@ static struct platform_driver ds1511_rtc_driver = {
 	},
 };
 
- static int __init
-ds1511_rtc_init(void)
-{
-	return platform_driver_register(&ds1511_rtc_driver);
-}
-
- static void __exit
-ds1511_rtc_exit(void)
-{
-	platform_driver_unregister(&ds1511_rtc_driver);
-}
-
-module_init(ds1511_rtc_init);
-module_exit(ds1511_rtc_exit);
+module_platform_driver(ds1511_rtc_driver);
 
 MODULE_AUTHOR("Andrew Sharp <andy.sharp@lsi.com>");
 MODULE_DESCRIPTION("Dallas DS1511 RTC driver");
diff --git a/drivers/rtc/rtc-ds1553.c b/drivers/rtc/rtc-ds1553.c
index 1350029..6f0a1b5 100644
--- a/drivers/rtc/rtc-ds1553.c
+++ b/drivers/rtc/rtc-ds1553.c
@@ -361,18 +361,7 @@ static struct platform_driver ds1553_rtc_driver = {
 	},
 };
 
-static __init int ds1553_init(void)
-{
-	return platform_driver_register(&ds1553_rtc_driver);
-}
-
-static __exit void ds1553_exit(void)
-{
-	platform_driver_unregister(&ds1553_rtc_driver);
-}
-
-module_init(ds1553_init);
-module_exit(ds1553_exit);
+module_platform_driver(ds1553_rtc_driver);
 
 MODULE_AUTHOR("Atsushi Nemoto <anemo@mba.ocn.ne.jp>");
 MODULE_DESCRIPTION("Dallas DS1553 RTC driver");
diff --git a/drivers/rtc/rtc-ds1742.c b/drivers/rtc/rtc-ds1742.c
index e3e0f92..7611266 100644
--- a/drivers/rtc/rtc-ds1742.c
+++ b/drivers/rtc/rtc-ds1742.c
@@ -240,18 +240,7 @@ static struct platform_driver ds1742_rtc_driver = {
 	},
 };
 
-static __init int ds1742_init(void)
-{
-	return platform_driver_register(&ds1742_rtc_driver);
-}
-
-static __exit void ds1742_exit(void)
-{
-	platform_driver_unregister(&ds1742_rtc_driver);
-}
-
-module_init(ds1742_init);
-module_exit(ds1742_exit);
+module_platform_driver(ds1742_rtc_driver);
 
 MODULE_AUTHOR("Atsushi Nemoto <anemo@mba.ocn.ne.jp>");
 MODULE_DESCRIPTION("Dallas DS1742 RTC driver");
diff --git a/drivers/rtc/rtc-jz4740.c b/drivers/rtc/rtc-jz4740.c
index b647363..1481e36 100644
--- a/drivers/rtc/rtc-jz4740.c
+++ b/drivers/rtc/rtc-jz4740.c
@@ -355,17 +355,7 @@ struct platform_driver jz4740_rtc_driver = {
 	},
 };
 
-static int __init jz4740_rtc_init(void)
-{
-	return platform_driver_register(&jz4740_rtc_driver);
-}
-module_init(jz4740_rtc_init);
-
-static void __exit jz4740_rtc_exit(void)
-{
-	platform_driver_unregister(&jz4740_rtc_driver);
-}
-module_exit(jz4740_rtc_exit);
+module_platform_driver(jz4740_rtc_driver);
 
 MODULE_AUTHOR("Lars-Peter Clausen <lars@metafoo.de>");
 MODULE_LICENSE("GPL");
diff --git a/drivers/rtc/rtc-lpc32xx.c b/drivers/rtc/rtc-lpc32xx.c
index ae16250..ecc1713 100644
--- a/drivers/rtc/rtc-lpc32xx.c
+++ b/drivers/rtc/rtc-lpc32xx.c
@@ -396,17 +396,7 @@ static struct platform_driver lpc32xx_rtc_driver = {
 	},
 };
 
-static int __init lpc32xx_rtc_init(void)
-{
-	return platform_driver_register(&lpc32xx_rtc_driver);
-}
-module_init(lpc32xx_rtc_init);
-
-static void __exit lpc32xx_rtc_exit(void)
-{
-	platform_driver_unregister(&lpc32xx_rtc_driver);
-}
-module_exit(lpc32xx_rtc_exit);
+module_platform_driver(lpc32xx_rtc_driver);
 
 MODULE_AUTHOR("Kevin Wells <wellsk40@gmail.com");
 MODULE_DESCRIPTION("RTC driver for the LPC32xx SoC");
diff --git a/drivers/rtc/rtc-m48t35.c b/drivers/rtc/rtc-m48t35.c
index 8e2a24e..f9e3b35 100644
--- a/drivers/rtc/rtc-m48t35.c
+++ b/drivers/rtc/rtc-m48t35.c
@@ -216,21 +216,10 @@ static struct platform_driver m48t35_platform_driver = {
 	.remove		= __devexit_p(m48t35_remove),
 };
 
-static int __init m48t35_init(void)
-{
-	return platform_driver_register(&m48t35_platform_driver);
-}
-
-static void __exit m48t35_exit(void)
-{
-	platform_driver_unregister(&m48t35_platform_driver);
-}
+module_platform_driver(m48t35_platform_driver);
 
 MODULE_AUTHOR("Thomas Bogendoerfer <tsbogend@alpha.franken.de>");
 MODULE_DESCRIPTION("M48T35 RTC driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
 MODULE_ALIAS("platform:rtc-m48t35");
-
-module_init(m48t35_init);
-module_exit(m48t35_exit);
diff --git a/drivers/rtc/rtc-m48t59.c b/drivers/rtc/rtc-m48t59.c
index 2836538..30ebfec 100644
--- a/drivers/rtc/rtc-m48t59.c
+++ b/drivers/rtc/rtc-m48t59.c
@@ -530,18 +530,7 @@ static struct platform_driver m48t59_rtc_driver = {
 	.remove		= __devexit_p(m48t59_rtc_remove),
 };
 
-static int __init m48t59_rtc_init(void)
-{
-	return platform_driver_register(&m48t59_rtc_driver);
-}
-
-static void __exit m48t59_rtc_exit(void)
-{
-	platform_driver_unregister(&m48t59_rtc_driver);
-}
-
-module_init(m48t59_rtc_init);
-module_exit(m48t59_rtc_exit);
+module_platform_driver(m48t59_rtc_driver);
 
 MODULE_AUTHOR("Mark Zhan <rongkai.zhan@windriver.com>");
 MODULE_DESCRIPTION("M48T59/M48T02/M48T08 RTC driver");
diff --git a/drivers/rtc/rtc-m48t86.c b/drivers/rtc/rtc-m48t86.c
index f981287..863fb33 100644
--- a/drivers/rtc/rtc-m48t86.c
+++ b/drivers/rtc/rtc-m48t86.c
@@ -185,21 +185,10 @@ static struct platform_driver m48t86_rtc_platform_driver = {
 	.remove		= __devexit_p(m48t86_rtc_remove),
 };
 
-static int __init m48t86_rtc_init(void)
-{
-	return platform_driver_register(&m48t86_rtc_platform_driver);
-}
-
-static void __exit m48t86_rtc_exit(void)
-{
-	platform_driver_unregister(&m48t86_rtc_platform_driver);
-}
+module_platform_driver(m48t86_rtc_platform_driver);
 
 MODULE_AUTHOR("Alessandro Zummo <a.zummo@towertech.it>");
 MODULE_DESCRIPTION("M48T86 RTC driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
 MODULE_ALIAS("platform:rtc-m48t86");
-
-module_init(m48t86_rtc_init);
-module_exit(m48t86_rtc_exit);
diff --git a/drivers/rtc/rtc-max8925.c b/drivers/rtc/rtc-max8925.c
index 3bc046f..4a55293 100644
--- a/drivers/rtc/rtc-max8925.c
+++ b/drivers/rtc/rtc-max8925.c
@@ -299,17 +299,7 @@ static struct platform_driver max8925_rtc_driver = {
 	.remove		= __devexit_p(max8925_rtc_remove),
 };
 
-static int __init max8925_rtc_init(void)
-{
-	return platform_driver_register(&max8925_rtc_driver);
-}
-module_init(max8925_rtc_init);
-
-static void __exit max8925_rtc_exit(void)
-{
-	platform_driver_unregister(&max8925_rtc_driver);
-}
-module_exit(max8925_rtc_exit);
+module_platform_driver(max8925_rtc_driver);
 
 MODULE_DESCRIPTION("Maxim MAX8925 RTC driver");
 MODULE_AUTHOR("Haojian Zhuang <haojian.zhuang@marvell.com>");
diff --git a/drivers/rtc/rtc-max8998.c b/drivers/rtc/rtc-max8998.c
index 2e48aa6..7196f43 100644
--- a/drivers/rtc/rtc-max8998.c
+++ b/drivers/rtc/rtc-max8998.c
@@ -327,17 +327,7 @@ static struct platform_driver max8998_rtc_driver = {
 	.id_table	= max8998_rtc_id,
 };
 
-static int __init max8998_rtc_init(void)
-{
-	return platform_driver_register(&max8998_rtc_driver);
-}
-module_init(max8998_rtc_init);
-
-static void __exit max8998_rtc_exit(void)
-{
-	platform_driver_unregister(&max8998_rtc_driver);
-}
-module_exit(max8998_rtc_exit);
+module_platform_driver(max8998_rtc_driver);
 
 MODULE_AUTHOR("Minkyu Kang <mk7.kang@samsung.com>");
 MODULE_AUTHOR("Joonyoung Shim <jy0922.shim@samsung.com>");
diff --git a/drivers/rtc/rtc-mpc5121.c b/drivers/rtc/rtc-mpc5121.c
index da60915..9d3cacc 100644
--- a/drivers/rtc/rtc-mpc5121.c
+++ b/drivers/rtc/rtc-mpc5121.c
@@ -418,17 +418,7 @@ static struct platform_driver mpc5121_rtc_driver = {
 	.remove = __devexit_p(mpc5121_rtc_remove),
 };
 
-static int __init mpc5121_rtc_init(void)
-{
-	return platform_driver_register(&mpc5121_rtc_driver);
-}
-module_init(mpc5121_rtc_init);
-
-static void __exit mpc5121_rtc_exit(void)
-{
-	platform_driver_unregister(&mpc5121_rtc_driver);
-}
-module_exit(mpc5121_rtc_exit);
+module_platform_driver(mpc5121_rtc_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("John Rigby <jcrigby@gmail.com>");
diff --git a/drivers/rtc/rtc-mrst.c b/drivers/rtc/rtc-mrst.c
index bb21f44..6cd6c72 100644
--- a/drivers/rtc/rtc-mrst.c
+++ b/drivers/rtc/rtc-mrst.c
@@ -537,18 +537,7 @@ static struct platform_driver vrtc_mrst_platform_driver = {
 	}
 };
 
-static int __init vrtc_mrst_init(void)
-{
-	return platform_driver_register(&vrtc_mrst_platform_driver);
-}
-
-static void __exit vrtc_mrst_exit(void)
-{
-	platform_driver_unregister(&vrtc_mrst_platform_driver);
-}
-
-module_init(vrtc_mrst_init);
-module_exit(vrtc_mrst_exit);
+module_platform_driver(vrtc_mrst_platform_driver);
 
 MODULE_AUTHOR("Jacob Pan; Feng Tang");
 MODULE_DESCRIPTION("Driver for Moorestown virtual RTC");
diff --git a/drivers/rtc/rtc-pcf50633.c b/drivers/rtc/rtc-pcf50633.c
index 0c42389..a20202f 100644
--- a/drivers/rtc/rtc-pcf50633.c
+++ b/drivers/rtc/rtc-pcf50633.c
@@ -294,17 +294,7 @@ static struct platform_driver pcf50633_rtc_driver = {
 	.remove = __devexit_p(pcf50633_rtc_remove),
 };
 
-static int __init pcf50633_rtc_init(void)
-{
-	return platform_driver_register(&pcf50633_rtc_driver);
-}
-module_init(pcf50633_rtc_init);
-
-static void __exit pcf50633_rtc_exit(void)
-{
-	platform_driver_unregister(&pcf50633_rtc_driver);
-}
-module_exit(pcf50633_rtc_exit);
+module_platform_driver(pcf50633_rtc_driver);
 
 MODULE_DESCRIPTION("PCF50633 RTC driver");
 MODULE_AUTHOR("Balaji Rao <balajirrao@openmoko.org>");
diff --git a/drivers/rtc/rtc-pm8xxx.c b/drivers/rtc/rtc-pm8xxx.c
index d420e9d..9f1d6bc 100644
--- a/drivers/rtc/rtc-pm8xxx.c
+++ b/drivers/rtc/rtc-pm8xxx.c
@@ -532,17 +532,7 @@ static struct platform_driver pm8xxx_rtc_driver = {
 	},
 };
 
-static int __init pm8xxx_rtc_init(void)
-{
-	return platform_driver_register(&pm8xxx_rtc_driver);
-}
-module_init(pm8xxx_rtc_init);
-
-static void __exit pm8xxx_rtc_exit(void)
-{
-	platform_driver_unregister(&pm8xxx_rtc_driver);
-}
-module_exit(pm8xxx_rtc_exit);
+module_platform_driver(pm8xxx_rtc_driver);
 
 MODULE_ALIAS("platform:rtc-pm8xxx");
 MODULE_DESCRIPTION("PMIC8xxx RTC driver");
diff --git a/drivers/rtc/rtc-puv3.c b/drivers/rtc/rtc-puv3.c
index e4b6880..2b71f9f 100644
--- a/drivers/rtc/rtc-puv3.c
+++ b/drivers/rtc/rtc-puv3.c
@@ -337,21 +337,7 @@ static struct platform_driver puv3_rtcdrv = {
 	}
 };
 
-static char __initdata banner[] = "PKUnity-v3 RTC, (c) 2009 PKUnity Co.\n";
-
-static int __init puv3_rtc_init(void)
-{
-	printk(banner);
-	return platform_driver_register(&puv3_rtcdrv);
-}
-
-static void __exit puv3_rtc_exit(void)
-{
-	platform_driver_unregister(&puv3_rtcdrv);
-}
-
-module_init(puv3_rtc_init);
-module_exit(puv3_rtc_exit);
+module_platform_driver(puv3_rtcdrv);
 
 MODULE_DESCRIPTION("RTC Driver for the PKUnity v3 chip");
 MODULE_AUTHOR("Hu Dongliang");
diff --git a/drivers/rtc/rtc-s3c.c b/drivers/rtc/rtc-s3c.c
index 175067a..aef40bd 100644
--- a/drivers/rtc/rtc-s3c.c
+++ b/drivers/rtc/rtc-s3c.c
@@ -673,21 +673,7 @@ static struct platform_driver s3c_rtc_driver = {
 	},
 };
 
-static char __initdata banner[] = "S3C24XX RTC, (c) 2004,2006 Simtec Electronics\n";
-
-static int __init s3c_rtc_init(void)
-{
-	printk(banner);
-	return platform_driver_register(&s3c_rtc_driver);
-}
-
-static void __exit s3c_rtc_exit(void)
-{
-	platform_driver_unregister(&s3c_rtc_driver);
-}
-
-module_init(s3c_rtc_init);
-module_exit(s3c_rtc_exit);
+module_platform_driver(s3c_rtc_driver);
 
 MODULE_DESCRIPTION("Samsung S3C RTC Driver");
 MODULE_AUTHOR("Ben Dooks <ben@simtec.co.uk>");
diff --git a/drivers/rtc/rtc-sa1100.c b/drivers/rtc/rtc-sa1100.c
index 0b40bb8..9f375cc 100644
--- a/drivers/rtc/rtc-sa1100.c
+++ b/drivers/rtc/rtc-sa1100.c
@@ -369,18 +369,7 @@ static struct platform_driver sa1100_rtc_driver = {
 	},
 };
 
-static int __init sa1100_rtc_init(void)
-{
-	return platform_driver_register(&sa1100_rtc_driver);
-}
-
-static void __exit sa1100_rtc_exit(void)
-{
-	platform_driver_unregister(&sa1100_rtc_driver);
-}
-
-module_init(sa1100_rtc_init);
-module_exit(sa1100_rtc_exit);
+module_platform_driver(sa1100_rtc_driver);
 
 MODULE_AUTHOR("Richard Purdie <rpurdie@rpsys.net>");
 MODULE_DESCRIPTION("SA11x0/PXA2xx Realtime Clock Driver (RTC)");
diff --git a/drivers/rtc/rtc-spear.c b/drivers/rtc/rtc-spear.c
index 893bac2..19a28a6 100644
--- a/drivers/rtc/rtc-spear.c
+++ b/drivers/rtc/rtc-spear.c
@@ -516,17 +516,7 @@ static struct platform_driver spear_rtc_driver = {
 	},
 };
 
-static int __init rtc_init(void)
-{
-	return platform_driver_register(&spear_rtc_driver);
-}
-module_init(rtc_init);
-
-static void __exit rtc_exit(void)
-{
-	platform_driver_unregister(&spear_rtc_driver);
-}
-module_exit(rtc_exit);
+module_platform_driver(spear_rtc_driver);
 
 MODULE_ALIAS("platform:rtc-spear");
 MODULE_AUTHOR("Rajeev Kumar <rajeev-dlh.kumar@st.com>");
diff --git a/drivers/rtc/rtc-stk17ta8.c b/drivers/rtc/rtc-stk17ta8.c
index ed3e9b5..7621116 100644
--- a/drivers/rtc/rtc-stk17ta8.c
+++ b/drivers/rtc/rtc-stk17ta8.c
@@ -370,18 +370,7 @@ static struct platform_driver stk17ta8_rtc_driver = {
 	},
 };
 
-static __init int stk17ta8_init(void)
-{
-	return platform_driver_register(&stk17ta8_rtc_driver);
-}
-
-static __exit void stk17ta8_exit(void)
-{
-	platform_driver_unregister(&stk17ta8_rtc_driver);
-}
-
-module_init(stk17ta8_init);
-module_exit(stk17ta8_exit);
+module_platform_driver(stk17ta8_rtc_driver);
 
 MODULE_AUTHOR("Thomas Hommel <thomas.hommel@ge.com>");
 MODULE_DESCRIPTION("Simtek STK17TA8 RTC driver");
diff --git a/drivers/rtc/rtc-stmp3xxx.c b/drivers/rtc/rtc-stmp3xxx.c
index 7315068..1028786 100644
--- a/drivers/rtc/rtc-stmp3xxx.c
+++ b/drivers/rtc/rtc-stmp3xxx.c
@@ -276,18 +276,7 @@ static struct platform_driver stmp3xxx_rtcdrv = {
 	},
 };
 
-static int __init stmp3xxx_rtc_init(void)
-{
-	return platform_driver_register(&stmp3xxx_rtcdrv);
-}
-
-static void __exit stmp3xxx_rtc_exit(void)
-{
-	platform_driver_unregister(&stmp3xxx_rtcdrv);
-}
-
-module_init(stmp3xxx_rtc_init);
-module_exit(stmp3xxx_rtc_exit);
+module_platform_driver(stmp3xxx_rtcdrv);
 
 MODULE_DESCRIPTION("STMP3xxx RTC Driver");
 MODULE_AUTHOR("dmitry pervushin <dpervushin@embeddedalley.com> and "
diff --git a/drivers/rtc/rtc-v3020.c b/drivers/rtc/rtc-v3020.c
index f71c3ce..bca5d67 100644
--- a/drivers/rtc/rtc-v3020.c
+++ b/drivers/rtc/rtc-v3020.c
@@ -393,18 +393,7 @@ static struct platform_driver rtc_device_driver = {
 	},
 };
 
-static __init int v3020_init(void)
-{
-	return platform_driver_register(&rtc_device_driver);
-}
-
-static __exit void v3020_exit(void)
-{
-	platform_driver_unregister(&rtc_device_driver);
-}
-
-module_init(v3020_init);
-module_exit(v3020_exit);
+module_platform_driver(rtc_device_driver);
 
 MODULE_DESCRIPTION("V3020 RTC");
 MODULE_AUTHOR("Raphael Assenat");
diff --git a/drivers/rtc/rtc-vr41xx.c b/drivers/rtc/rtc-vr41xx.c
index c5698cd..fcbfdda 100644
--- a/drivers/rtc/rtc-vr41xx.c
+++ b/drivers/rtc/rtc-vr41xx.c
@@ -405,15 +405,4 @@ static struct platform_driver rtc_platform_driver = {
 	},
 };
 
-static int __init vr41xx_rtc_init(void)
-{
-	return platform_driver_register(&rtc_platform_driver);
-}
-
-static void __exit vr41xx_rtc_exit(void)
-{
-	platform_driver_unregister(&rtc_platform_driver);
-}
-
-module_init(vr41xx_rtc_init);
-module_exit(vr41xx_rtc_exit);
+module_platform_driver(rtc_platform_driver);
diff --git a/drivers/rtc/rtc-vt8500.c b/drivers/rtc/rtc-vt8500.c
index f93f412..9e94fb1 100644
--- a/drivers/rtc/rtc-vt8500.c
+++ b/drivers/rtc/rtc-vt8500.c
@@ -311,17 +311,7 @@ static struct platform_driver vt8500_rtc_driver = {
 	},
 };
 
-static int __init vt8500_rtc_init(void)
-{
-	return platform_driver_register(&vt8500_rtc_driver);
-}
-module_init(vt8500_rtc_init);
-
-static void __exit vt8500_rtc_exit(void)
-{
-	platform_driver_unregister(&vt8500_rtc_driver);
-}
-module_exit(vt8500_rtc_exit);
+module_platform_driver(vt8500_rtc_driver);
 
 MODULE_AUTHOR("Alexey Charkov <alchark@gmail.com>");
 MODULE_DESCRIPTION("VIA VT8500 SoC Realtime Clock Driver (RTC)");
diff --git a/drivers/rtc/rtc-wm831x.c b/drivers/rtc/rtc-wm831x.c
index 657c6f6..3b6e6a6 100644
--- a/drivers/rtc/rtc-wm831x.c
+++ b/drivers/rtc/rtc-wm831x.c
@@ -468,17 +468,7 @@ static struct platform_driver wm831x_rtc_driver = {
 	},
 };
 
-static int __init wm831x_rtc_init(void)
-{
-	return platform_driver_register(&wm831x_rtc_driver);
-}
-module_init(wm831x_rtc_init);
-
-static void __exit wm831x_rtc_exit(void)
-{
-	platform_driver_unregister(&wm831x_rtc_driver);
-}
-module_exit(wm831x_rtc_exit);
+module_platform_driver(wm831x_rtc_driver);
 
 MODULE_AUTHOR("Mark Brown <broonie@opensource.wolfsonmicro.com>");
 MODULE_DESCRIPTION("RTC driver for the WM831x series PMICs");
diff --git a/drivers/rtc/rtc-wm8350.c b/drivers/rtc/rtc-wm8350.c
index 6642142..c2e52d1 100644
--- a/drivers/rtc/rtc-wm8350.c
+++ b/drivers/rtc/rtc-wm8350.c
@@ -486,17 +486,7 @@ static struct platform_driver wm8350_rtc_driver = {
 	},
 };
 
-static int __init wm8350_rtc_init(void)
-{
-	return platform_driver_register(&wm8350_rtc_driver);
-}
-module_init(wm8350_rtc_init);
-
-static void __exit wm8350_rtc_exit(void)
-{
-	platform_driver_unregister(&wm8350_rtc_driver);
-}
-module_exit(wm8350_rtc_exit);
+module_platform_driver(wm8350_rtc_driver);
 
 MODULE_AUTHOR("Mark Brown <broonie@opensource.wolfsonmicro.com>");
 MODULE_DESCRIPTION("RTC driver for the WM8350");
-- 
1.7.5.4



