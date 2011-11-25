Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357Ab1KYHbL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 02:31:11 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51654 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab1KYHbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 02:31:09 -0500
Message-ID: <1322206260.11718.4.camel@phoenix>
Subject: [PATCH] hwmon: convert drivers/hwmon/* to use
 module_platform_driver()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Donggeun Kim <dg77.kim@samsung.com>, Simon Guinot <sguinot@lacie.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        MyungJoo Ham <myungjoo.ham@samsung.com>, Ben Dooks <ben@simtec.co.uk>,
        Hans de Goede <hdegoede@redhat.com>, J Keerthy <j-keerthy@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>, lm-sensors@lm-sensors.org
Date: Fri, 25 Nov 2011 15:31:00 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the drivers in drivers/hwmon/* to use the
module_platform_driver() macro which makes the code smaller and a bit
simpler.

Cc: Donggeun Kim <dg77.kim@samsung.com>
Cc: Simon Guinot <sguinot@lacie.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: Ben Dooks <ben@simtec.co.uk>
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: J Keerthy <j-keerthy@ti.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/hwmon/exynos4_tmu.c        |   12 +-----------
 drivers/hwmon/gpio-fan.c           |   13 +------------
 drivers/hwmon/jz4740-hwmon.c       |   12 +-----------
 drivers/hwmon/ntc_thermistor.c     |   14 +-------------
 drivers/hwmon/s3c-hwmon.c          |   13 +------------
 drivers/hwmon/sch5627.c            |   13 +------------
 drivers/hwmon/sch5636.c            |   13 +------------
 drivers/hwmon/twl4030-madc-hwmon.c |   14 +-------------
 drivers/hwmon/ultra45_env.c        |   13 +------------
 drivers/hwmon/wm831x-hwmon.c       |   12 +-----------
 drivers/hwmon/wm8350-hwmon.c       |   12 +-----------
 11 files changed, 11 insertions(+), 130 deletions(-)

diff --git a/drivers/hwmon/exynos4_tmu.c b/drivers/hwmon/exynos4_tmu.c
index faa0884..f2359a0 100644
--- a/drivers/hwmon/exynos4_tmu.c
+++ b/drivers/hwmon/exynos4_tmu.c
@@ -506,17 +506,7 @@ static struct platform_driver exynos4_tmu_driver = {
 	.resume = exynos4_tmu_resume,
 };
 
-static int __init exynos4_tmu_driver_init(void)
-{
-	return platform_driver_register(&exynos4_tmu_driver);
-}
-module_init(exynos4_tmu_driver_init);
-
-static void __exit exynos4_tmu_driver_exit(void)
-{
-	platform_driver_unregister(&exynos4_tmu_driver);
-}
-module_exit(exynos4_tmu_driver_exit);
+module_platform_driver(exynos4_tmu_driver);
 
 MODULE_DESCRIPTION("EXYNOS4 TMU Driver");
 MODULE_AUTHOR("Donggeun Kim <dg77.kim@samsung.com>");
diff --git a/drivers/hwmon/gpio-fan.c b/drivers/hwmon/gpio-fan.c
index 89aa9fb..9ba38f3 100644
--- a/drivers/hwmon/gpio-fan.c
+++ b/drivers/hwmon/gpio-fan.c
@@ -539,18 +539,7 @@ static struct platform_driver gpio_fan_driver = {
 	},
 };
 
-static int __init gpio_fan_init(void)
-{
-	return platform_driver_register(&gpio_fan_driver);
-}
-
-static void __exit gpio_fan_exit(void)
-{
-	platform_driver_unregister(&gpio_fan_driver);
-}
-
-module_init(gpio_fan_init);
-module_exit(gpio_fan_exit);
+module_platform_driver(gpio_fan_driver);
 
 MODULE_AUTHOR("Simon Guinot <sguinot@lacie.com>");
 MODULE_DESCRIPTION("GPIO FAN driver");
diff --git a/drivers/hwmon/jz4740-hwmon.c b/drivers/hwmon/jz4740-hwmon.c
index fea292d..7a48b1e 100644
--- a/drivers/hwmon/jz4740-hwmon.c
+++ b/drivers/hwmon/jz4740-hwmon.c
@@ -212,17 +212,7 @@ struct platform_driver jz4740_hwmon_driver = {
 	},
 };
 
-static int __init jz4740_hwmon_init(void)
-{
-	return platform_driver_register(&jz4740_hwmon_driver);
-}
-module_init(jz4740_hwmon_init);
-
-static void __exit jz4740_hwmon_exit(void)
-{
-	platform_driver_unregister(&jz4740_hwmon_driver);
-}
-module_exit(jz4740_hwmon_exit);
+module_platform_driver(jz4740_hwmon_driver);
 
 MODULE_DESCRIPTION("JZ4740 SoC HWMON driver");
 MODULE_AUTHOR("Lars-Peter Clausen <lars@metafoo.de>");
diff --git a/drivers/hwmon/ntc_thermistor.c b/drivers/hwmon/ntc_thermistor.c
index eab1161..9b382ec 100644
--- a/drivers/hwmon/ntc_thermistor.c
+++ b/drivers/hwmon/ntc_thermistor.c
@@ -432,19 +432,7 @@ static struct platform_driver ntc_thermistor_driver = {
 	.id_table = ntc_thermistor_id,
 };
 
-static int __init ntc_thermistor_init(void)
-{
-	return platform_driver_register(&ntc_thermistor_driver);
-}
-
-module_init(ntc_thermistor_init);
-
-static void __exit ntc_thermistor_cleanup(void)
-{
-	platform_driver_unregister(&ntc_thermistor_driver);
-}
-
-module_exit(ntc_thermistor_cleanup);
+module_platform_driver(ntc_thermistor_driver);
 
 MODULE_DESCRIPTION("NTC Thermistor Driver");
 MODULE_AUTHOR("MyungJoo Ham <myungjoo.ham@samsung.com>");
diff --git a/drivers/hwmon/s3c-hwmon.c b/drivers/hwmon/s3c-hwmon.c
index b39f52e..f6c26d1 100644
--- a/drivers/hwmon/s3c-hwmon.c
+++ b/drivers/hwmon/s3c-hwmon.c
@@ -393,18 +393,7 @@ static struct platform_driver s3c_hwmon_driver = {
 	.remove		= __devexit_p(s3c_hwmon_remove),
 };
 
-static int __init s3c_hwmon_init(void)
-{
-	return platform_driver_register(&s3c_hwmon_driver);
-}
-
-static void __exit s3c_hwmon_exit(void)
-{
-	platform_driver_unregister(&s3c_hwmon_driver);
-}
-
-module_init(s3c_hwmon_init);
-module_exit(s3c_hwmon_exit);
+module_platform_driver(s3c_hwmon_driver);
 
 MODULE_AUTHOR("Ben Dooks <ben@simtec.co.uk>");
 MODULE_DESCRIPTION("S3C ADC HWMon driver");
diff --git a/drivers/hwmon/sch5627.c b/drivers/hwmon/sch5627.c
index e3b5c60..79b6dab 100644
--- a/drivers/hwmon/sch5627.c
+++ b/drivers/hwmon/sch5627.c
@@ -590,19 +590,8 @@ static struct platform_driver sch5627_driver = {
 	.remove		= sch5627_remove,
 };
 
-static int __init sch5627_init(void)
-{
-	return platform_driver_register(&sch5627_driver);
-}
-
-static void __exit sch5627_exit(void)
-{
-	platform_driver_unregister(&sch5627_driver);
-}
+module_platform_driver(sch5627_driver);
 
 MODULE_DESCRIPTION("SMSC SCH5627 Hardware Monitoring Driver");
 MODULE_AUTHOR("Hans de Goede <hdegoede@redhat.com>");
 MODULE_LICENSE("GPL");
-
-module_init(sch5627_init);
-module_exit(sch5627_exit);
diff --git a/drivers/hwmon/sch5636.c b/drivers/hwmon/sch5636.c
index 244407a..9d5236f 100644
--- a/drivers/hwmon/sch5636.c
+++ b/drivers/hwmon/sch5636.c
@@ -521,19 +521,8 @@ static struct platform_driver sch5636_driver = {
 	.remove		= sch5636_remove,
 };
 
-static int __init sch5636_init(void)
-{
-	return platform_driver_register(&sch5636_driver);
-}
-
-static void __exit sch5636_exit(void)
-{
-	platform_driver_unregister(&sch5636_driver);
-}
+module_platform_driver(sch5636_driver);
 
 MODULE_DESCRIPTION("SMSC SCH5636 Hardware Monitoring Driver");
 MODULE_AUTHOR("Hans de Goede <hdegoede@redhat.com>");
 MODULE_LICENSE("GPL");
-
-module_init(sch5636_init);
-module_exit(sch5636_exit);
diff --git a/drivers/hwmon/twl4030-madc-hwmon.c b/drivers/hwmon/twl4030-madc-hwmon.c
index 5724074..0018c7d 100644
--- a/drivers/hwmon/twl4030-madc-hwmon.c
+++ b/drivers/hwmon/twl4030-madc-hwmon.c
@@ -136,19 +136,7 @@ static struct platform_driver twl4030_madc_hwmon_driver = {
 		   },
 };
 
-static int __init twl4030_madc_hwmon_init(void)
-{
-	return platform_driver_register(&twl4030_madc_hwmon_driver);
-}
-
-module_init(twl4030_madc_hwmon_init);
-
-static void __exit twl4030_madc_hwmon_exit(void)
-{
-	platform_driver_unregister(&twl4030_madc_hwmon_driver);
-}
-
-module_exit(twl4030_madc_hwmon_exit);
+module_platform_driver(twl4030_madc_hwmon_driver);
 
 MODULE_DESCRIPTION("TWL4030 ADC Hwmon driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/hwmon/ultra45_env.c b/drivers/hwmon/ultra45_env.c
index 3cd07bf..b9a87e8 100644
--- a/drivers/hwmon/ultra45_env.c
+++ b/drivers/hwmon/ultra45_env.c
@@ -309,15 +309,4 @@ static struct platform_driver env_driver = {
 	.remove		= __devexit_p(env_remove),
 };
 
-static int __init env_init(void)
-{
-	return platform_driver_register(&env_driver);
-}
-
-static void __exit env_exit(void)
-{
-	platform_driver_unregister(&env_driver);
-}
-
-module_init(env_init);
-module_exit(env_exit);
+module_platform_driver(env_driver);
diff --git a/drivers/hwmon/wm831x-hwmon.c b/drivers/hwmon/wm831x-hwmon.c
index 97b1f83..9b598ed 100644
--- a/drivers/hwmon/wm831x-hwmon.c
+++ b/drivers/hwmon/wm831x-hwmon.c
@@ -209,17 +209,7 @@ static struct platform_driver wm831x_hwmon_driver = {
 	},
 };
 
-static int __init wm831x_hwmon_init(void)
-{
-	return platform_driver_register(&wm831x_hwmon_driver);
-}
-module_init(wm831x_hwmon_init);
-
-static void __exit wm831x_hwmon_exit(void)
-{
-	platform_driver_unregister(&wm831x_hwmon_driver);
-}
-module_exit(wm831x_hwmon_exit);
+module_platform_driver(wm831x_hwmon_driver);
 
 MODULE_AUTHOR("Mark Brown <broonie@opensource.wolfsonmicro.com>");
 MODULE_DESCRIPTION("WM831x Hardware Monitoring");
diff --git a/drivers/hwmon/wm8350-hwmon.c b/drivers/hwmon/wm8350-hwmon.c
index 1329059..3ff67ed 100644
--- a/drivers/hwmon/wm8350-hwmon.c
+++ b/drivers/hwmon/wm8350-hwmon.c
@@ -133,17 +133,7 @@ static struct platform_driver wm8350_hwmon_driver = {
 	},
 };
 
-static int __init wm8350_hwmon_init(void)
-{
-	return platform_driver_register(&wm8350_hwmon_driver);
-}
-module_init(wm8350_hwmon_init);
-
-static void __exit wm8350_hwmon_exit(void)
-{
-	platform_driver_unregister(&wm8350_hwmon_driver);
-}
-module_exit(wm8350_hwmon_exit);
+module_platform_driver(wm8350_hwmon_driver);
 
 MODULE_AUTHOR("Mark Brown <broonie@opensource.wolfsonmicro.com>");
 MODULE_DESCRIPTION("WM8350 Hardware Monitoring");
-- 
1.7.5.4



