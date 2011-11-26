Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520Ab1KZEBZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 23:01:25 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49302 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab1KZEBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 23:01:24 -0500
Message-ID: <1322280070.6458.1.camel@phoenix>
Subject: [PATCH] power_supply: convert drivers/power/* to use
 module_platform_driver()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mike Rapoport <mike@compulab.co.il>,
        Clifton Barnes <cabarnes@indesign-llc.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Nithish Mahalingam <nithish.mahalingam@intel.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Balaji Rao <balajirrao@openmoko.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>
Date: Sat, 26 Nov 2011 12:01:10 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the drivers in drivers/power/* to use the
module_platform_driver() macro which makes the code smaller and a bit
simpler.

Cc: Mike Rapoport <mike@compulab.co.il>
Cc: Clifton Barnes <cabarnes@indesign-llc.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Nithish Mahalingam <nithish.mahalingam@intel.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: Balaji Rao <balajirrao@openmoko.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/power/da9030_battery.c    |   13 +------------
 drivers/power/ds2760_battery.c    |   13 +------------
 drivers/power/ds2780_battery.c    |   16 ++--------------
 drivers/power/gpio-charger.c      |   12 +-----------
 drivers/power/intel_mid_battery.c |   13 +------------
 drivers/power/isp1704_charger.c   |   12 +-----------
 drivers/power/jz4740-battery.c    |   12 +-----------
 drivers/power/max8903_charger.c   |   12 +-----------
 drivers/power/max8925_power.c     |   12 +-----------
 drivers/power/max8998_charger.c   |   12 +-----------
 drivers/power/olpc_battery.c      |   12 +-----------
 drivers/power/pcf50633-charger.c  |   12 +-----------
 drivers/power/pda_power.c         |   15 ++-------------
 drivers/power/s3c_adc_battery.c   |   12 +-----------
 drivers/power/tosa_battery.c      |   13 +------------
 drivers/power/wm831x_backup.c     |   12 +-----------
 drivers/power/wm831x_power.c      |   12 +-----------
 drivers/power/wm8350_power.c      |   12 +-----------
 drivers/power/wm97xx_battery.c    |   13 +------------
 19 files changed, 21 insertions(+), 219 deletions(-)

diff --git a/drivers/power/da9030_battery.c b/drivers/power/da9030_battery.c
index d2c793cf..3fd3e95 100644
--- a/drivers/power/da9030_battery.c
+++ b/drivers/power/da9030_battery.c
@@ -588,18 +588,7 @@ static struct platform_driver da903x_battery_driver = {
 	.remove = da9030_battery_remove,
 };
 
-static int da903x_battery_init(void)
-{
-	return platform_driver_register(&da903x_battery_driver);
-}
-
-static void da903x_battery_exit(void)
-{
-	platform_driver_unregister(&da903x_battery_driver);
-}
-
-module_init(da903x_battery_init);
-module_exit(da903x_battery_exit);
+module_platform_driver(da903x_battery_driver);
 
 MODULE_DESCRIPTION("DA9030 battery charger driver");
 MODULE_AUTHOR("Mike Rapoport, CompuLab");
diff --git a/drivers/power/ds2760_battery.c b/drivers/power/ds2760_battery.c
index f2c9cc3..208835e 100644
--- a/drivers/power/ds2760_battery.c
+++ b/drivers/power/ds2760_battery.c
@@ -637,18 +637,7 @@ static struct platform_driver ds2760_battery_driver = {
 	.resume	  = ds2760_battery_resume,
 };
 
-static int __init ds2760_battery_init(void)
-{
-	return platform_driver_register(&ds2760_battery_driver);
-}
-
-static void __exit ds2760_battery_exit(void)
-{
-	platform_driver_unregister(&ds2760_battery_driver);
-}
-
-module_init(ds2760_battery_init);
-module_exit(ds2760_battery_exit);
+module_platform_driver(ds2760_battery_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>, "
diff --git a/drivers/power/ds2780_battery.c b/drivers/power/ds2780_battery.c
index 887ec98..de31cae 100644
--- a/drivers/power/ds2780_battery.c
+++ b/drivers/power/ds2780_battery.c
@@ -841,8 +841,6 @@ static int __devexit ds2780_battery_remove(struct platform_device *pdev)
 	return 0;
 }
 
-MODULE_ALIAS("platform:ds2780-battery");
-
 static struct platform_driver ds2780_battery_driver = {
 	.driver = {
 		.name = "ds2780-battery",
@@ -851,19 +849,9 @@ static struct platform_driver ds2780_battery_driver = {
 	.remove   = __devexit_p(ds2780_battery_remove),
 };
 
-static int __init ds2780_battery_init(void)
-{
-	return platform_driver_register(&ds2780_battery_driver);
-}
-
-static void __exit ds2780_battery_exit(void)
-{
-	platform_driver_unregister(&ds2780_battery_driver);
-}
-
-module_init(ds2780_battery_init);
-module_exit(ds2780_battery_exit);
+module_platform_driver(ds2780_battery_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Clifton Barnes <cabarnes@indesign-llc.com>");
 MODULE_DESCRIPTION("Maxim/Dallas DS2780 Stand-Alone Fuel Gauage IC driver");
+MODULE_ALIAS("platform:ds2780-battery");
diff --git a/drivers/power/gpio-charger.c b/drivers/power/gpio-charger.c
index a64b885..8672c91 100644
--- a/drivers/power/gpio-charger.c
+++ b/drivers/power/gpio-charger.c
@@ -185,17 +185,7 @@ static struct platform_driver gpio_charger_driver = {
 	},
 };
 
-static int __init gpio_charger_init(void)
-{
-	return platform_driver_register(&gpio_charger_driver);
-}
-module_init(gpio_charger_init);
-
-static void __exit gpio_charger_exit(void)
-{
-	platform_driver_unregister(&gpio_charger_driver);
-}
-module_exit(gpio_charger_exit);
+module_platform_driver(gpio_charger_driver);
 
 MODULE_AUTHOR("Lars-Peter Clausen <lars@metafoo.de>");
 MODULE_DESCRIPTION("Driver for chargers which report their online status through a GPIO");
diff --git a/drivers/power/intel_mid_battery.c b/drivers/power/intel_mid_battery.c
index 01fa671..d096497 100644
--- a/drivers/power/intel_mid_battery.c
+++ b/drivers/power/intel_mid_battery.c
@@ -779,18 +779,7 @@ static struct platform_driver platform_pmic_battery_driver = {
 	.remove = __devexit_p(platform_pmic_battery_remove),
 };
 
-static int __init platform_pmic_battery_module_init(void)
-{
-	return platform_driver_register(&platform_pmic_battery_driver);
-}
-
-static void __exit platform_pmic_battery_module_exit(void)
-{
-	platform_driver_unregister(&platform_pmic_battery_driver);
-}
-
-module_init(platform_pmic_battery_module_init);
-module_exit(platform_pmic_battery_module_exit);
+module_platform_driver(platform_pmic_battery_driver);
 
 MODULE_AUTHOR("Nithish Mahalingam <nithish.mahalingam@intel.com>");
 MODULE_DESCRIPTION("Intel Moorestown PMIC Battery Driver");
diff --git a/drivers/power/isp1704_charger.c b/drivers/power/isp1704_charger.c
index f6d72b4..6a4ef38 100644
--- a/drivers/power/isp1704_charger.c
+++ b/drivers/power/isp1704_charger.c
@@ -494,17 +494,7 @@ static struct platform_driver isp1704_charger_driver = {
 	.remove = __devexit_p(isp1704_charger_remove),
 };
 
-static int __init isp1704_charger_init(void)
-{
-	return platform_driver_register(&isp1704_charger_driver);
-}
-module_init(isp1704_charger_init);
-
-static void __exit isp1704_charger_exit(void)
-{
-	platform_driver_unregister(&isp1704_charger_driver);
-}
-module_exit(isp1704_charger_exit);
+module_platform_driver(isp1704_charger_driver);
 
 MODULE_ALIAS("platform:isp1704_charger");
 MODULE_AUTHOR("Nokia Corporation");
diff --git a/drivers/power/jz4740-battery.c b/drivers/power/jz4740-battery.c
index 763f894..6b77029 100644
--- a/drivers/power/jz4740-battery.c
+++ b/drivers/power/jz4740-battery.c
@@ -441,17 +441,7 @@ static struct platform_driver jz_battery_driver = {
 	},
 };
 
-static int __init jz_battery_init(void)
-{
-	return platform_driver_register(&jz_battery_driver);
-}
-module_init(jz_battery_init);
-
-static void __exit jz_battery_exit(void)
-{
-	platform_driver_unregister(&jz_battery_driver);
-}
-module_exit(jz_battery_exit);
+module_platform_driver(jz_battery_driver);
 
 MODULE_ALIAS("platform:jz4740-battery");
 MODULE_LICENSE("GPL");
diff --git a/drivers/power/max8903_charger.c b/drivers/power/max8903_charger.c
index f204ad1..3e23f43 100644
--- a/drivers/power/max8903_charger.c
+++ b/drivers/power/max8903_charger.c
@@ -374,17 +374,7 @@ static struct platform_driver max8903_driver = {
 	},
 };
 
-static int __init max8903_init(void)
-{
-	return platform_driver_register(&max8903_driver);
-}
-module_init(max8903_init);
-
-static void __exit max8903_exit(void)
-{
-	platform_driver_unregister(&max8903_driver);
-}
-module_exit(max8903_exit);
+module_platform_driver(max8903_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("MAX8903 Charger Driver");
diff --git a/drivers/power/max8925_power.c b/drivers/power/max8925_power.c
index a70e16d..95f8af6 100644
--- a/drivers/power/max8925_power.c
+++ b/drivers/power/max8925_power.c
@@ -512,17 +512,7 @@ static struct platform_driver max8925_power_driver = {
 	},
 };
 
-static int __init max8925_power_init(void)
-{
-	return platform_driver_register(&max8925_power_driver);
-}
-module_init(max8925_power_init);
-
-static void __exit max8925_power_exit(void)
-{
-	platform_driver_unregister(&max8925_power_driver);
-}
-module_exit(max8925_power_exit);
+module_platform_driver(max8925_power_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Power supply driver for MAX8925");
diff --git a/drivers/power/max8998_charger.c b/drivers/power/max8998_charger.c
index 0737302..9b3f2bf 100644
--- a/drivers/power/max8998_charger.c
+++ b/drivers/power/max8998_charger.c
@@ -204,17 +204,7 @@ static struct platform_driver max8998_battery_driver = {
 	.id_table = max8998_battery_id,
 };
 
-static int __init max8998_battery_init(void)
-{
-	return platform_driver_register(&max8998_battery_driver);
-}
-module_init(max8998_battery_init);
-
-static void __exit max8998_battery_cleanup(void)
-{
-	platform_driver_unregister(&max8998_battery_driver);
-}
-module_exit(max8998_battery_cleanup);
+module_platform_driver(max8998_battery_driver);
 
 MODULE_DESCRIPTION("MAXIM 8998 battery control driver");
 MODULE_AUTHOR("MyungJoo Ham <myungjoo.ham@samsung.com>");
diff --git a/drivers/power/olpc_battery.c b/drivers/power/olpc_battery.c
index 21e7c06..7385092 100644
--- a/drivers/power/olpc_battery.c
+++ b/drivers/power/olpc_battery.c
@@ -630,17 +630,7 @@ static struct platform_driver olpc_battery_driver = {
 	.suspend = olpc_battery_suspend,
 };
 
-static int __init olpc_bat_init(void)
-{
-	return platform_driver_register(&olpc_battery_driver);
-}
-module_init(olpc_bat_init);
-
-static void __exit olpc_bat_exit(void)
-{
-	platform_driver_unregister(&olpc_battery_driver);
-}
-module_exit(olpc_bat_exit);
+module_platform_driver(olpc_battery_driver);
 
 MODULE_AUTHOR("David Woodhouse <dwmw2@infradead.org>");
 MODULE_LICENSE("GPL");
diff --git a/drivers/power/pcf50633-charger.c b/drivers/power/pcf50633-charger.c
index 4fa52e1..3d1e9ef 100644
--- a/drivers/power/pcf50633-charger.c
+++ b/drivers/power/pcf50633-charger.c
@@ -474,17 +474,7 @@ static struct platform_driver pcf50633_mbc_driver = {
 	.remove = __devexit_p(pcf50633_mbc_remove),
 };
 
-static int __init pcf50633_mbc_init(void)
-{
-	return platform_driver_register(&pcf50633_mbc_driver);
-}
-module_init(pcf50633_mbc_init);
-
-static void __exit pcf50633_mbc_exit(void)
-{
-	platform_driver_unregister(&pcf50633_mbc_driver);
-}
-module_exit(pcf50633_mbc_exit);
+module_platform_driver(pcf50633_mbc_driver);
 
 MODULE_AUTHOR("Balaji Rao <balajirrao@openmoko.org>");
 MODULE_DESCRIPTION("PCF50633 mbc driver");
diff --git a/drivers/power/pda_power.c b/drivers/power/pda_power.c
index 87be679..fd49689 100644
--- a/drivers/power/pda_power.c
+++ b/drivers/power/pda_power.c
@@ -498,8 +498,6 @@ static int pda_power_resume(struct platform_device *pdev)
 #define pda_power_resume NULL
 #endif /* CONFIG_PM */
 
-MODULE_ALIAS("platform:pda-power");
-
 static struct platform_driver pda_power_pdrv = {
 	.driver = {
 		.name = "pda-power",
@@ -510,17 +508,8 @@ static struct platform_driver pda_power_pdrv = {
 	.resume = pda_power_resume,
 };
 
-static int __init pda_power_init(void)
-{
-	return platform_driver_register(&pda_power_pdrv);
-}
-
-static void __exit pda_power_exit(void)
-{
-	platform_driver_unregister(&pda_power_pdrv);
-}
+module_platform_driver(pda_power_pdrv);
 
-module_init(pda_power_init);
-module_exit(pda_power_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Anton Vorontsov <cbou@mail.ru>");
+MODULE_ALIAS("platform:pda-power");
diff --git a/drivers/power/s3c_adc_battery.c b/drivers/power/s3c_adc_battery.c
index d32d0d7..e687ee7 100644
--- a/drivers/power/s3c_adc_battery.c
+++ b/drivers/power/s3c_adc_battery.c
@@ -421,17 +421,7 @@ static struct platform_driver s3c_adc_bat_driver = {
 	.resume		= s3c_adc_bat_resume,
 };
 
-static int __init s3c_adc_bat_init(void)
-{
-	return platform_driver_register(&s3c_adc_bat_driver);
-}
-module_init(s3c_adc_bat_init);
-
-static void __exit s3c_adc_bat_exit(void)
-{
-	platform_driver_unregister(&s3c_adc_bat_driver);
-}
-module_exit(s3c_adc_bat_exit);
+module_platform_driver(s3c_adc_bat_driver);
 
 MODULE_AUTHOR("Vasily Khoruzhick <anarsoul@gmail.com>");
 MODULE_DESCRIPTION("iPAQ H1930/H1940/RX1950 battery controller driver");
diff --git a/drivers/power/tosa_battery.c b/drivers/power/tosa_battery.c
index ada86a4..28bbe7e 100644
--- a/drivers/power/tosa_battery.c
+++ b/drivers/power/tosa_battery.c
@@ -438,18 +438,7 @@ static struct platform_driver tosa_bat_driver = {
 	.resume		= tosa_bat_resume,
 };
 
-static int __init tosa_bat_init(void)
-{
-	return platform_driver_register(&tosa_bat_driver);
-}
-
-static void __exit tosa_bat_exit(void)
-{
-	platform_driver_unregister(&tosa_bat_driver);
-}
-
-module_init(tosa_bat_init);
-module_exit(tosa_bat_exit);
+module_platform_driver(tosa_bat_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Dmitry Baryshkov");
diff --git a/drivers/power/wm831x_backup.c b/drivers/power/wm831x_backup.c
index e648cbe..6243e69 100644
--- a/drivers/power/wm831x_backup.c
+++ b/drivers/power/wm831x_backup.c
@@ -226,17 +226,7 @@ static struct platform_driver wm831x_backup_driver = {
 	},
 };
 
-static int __init wm831x_backup_init(void)
-{
-	return platform_driver_register(&wm831x_backup_driver);
-}
-module_init(wm831x_backup_init);
-
-static void __exit wm831x_backup_exit(void)
-{
-	platform_driver_unregister(&wm831x_backup_driver);
-}
-module_exit(wm831x_backup_exit);
+module_platform_driver(wm831x_backup_driver);
 
 MODULE_DESCRIPTION("Backup battery charger driver for WM831x PMICs");
 MODULE_AUTHOR("Mark Brown <broonie@opensource.wolfsonmicro.com>");
diff --git a/drivers/power/wm831x_power.c b/drivers/power/wm831x_power.c
index c32e6f8..987332b 100644
--- a/drivers/power/wm831x_power.c
+++ b/drivers/power/wm831x_power.c
@@ -655,17 +655,7 @@ static struct platform_driver wm831x_power_driver = {
 	},
 };
 
-static int __init wm831x_power_init(void)
-{
-	return platform_driver_register(&wm831x_power_driver);
-}
-module_init(wm831x_power_init);
-
-static void __exit wm831x_power_exit(void)
-{
-	platform_driver_unregister(&wm831x_power_driver);
-}
-module_exit(wm831x_power_exit);
+module_platform_driver(wm831x_power_driver);
 
 MODULE_DESCRIPTION("Power supply driver for WM831x PMICs");
 MODULE_AUTHOR("Mark Brown <broonie@opensource.wolfsonmicro.com>");
diff --git a/drivers/power/wm8350_power.c b/drivers/power/wm8350_power.c
index 0693902..fae04d3 100644
--- a/drivers/power/wm8350_power.c
+++ b/drivers/power/wm8350_power.c
@@ -522,17 +522,7 @@ static struct platform_driver wm8350_power_driver = {
 	},
 };
 
-static int __init wm8350_power_init(void)
-{
-	return platform_driver_register(&wm8350_power_driver);
-}
-module_init(wm8350_power_init);
-
-static void __exit wm8350_power_exit(void)
-{
-	platform_driver_unregister(&wm8350_power_driver);
-}
-module_exit(wm8350_power_exit);
+module_platform_driver(wm8350_power_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Power supply driver for WM8350");
diff --git a/drivers/power/wm97xx_battery.c b/drivers/power/wm97xx_battery.c
index 156559e..79df557 100644
--- a/drivers/power/wm97xx_battery.c
+++ b/drivers/power/wm97xx_battery.c
@@ -291,18 +291,7 @@ static struct platform_driver wm97xx_bat_driver = {
 	.remove		= __devexit_p(wm97xx_bat_remove),
 };
 
-static int __init wm97xx_bat_init(void)
-{
-	return platform_driver_register(&wm97xx_bat_driver);
-}
-
-static void __exit wm97xx_bat_exit(void)
-{
-	platform_driver_unregister(&wm97xx_bat_driver);
-}
-
-module_init(wm97xx_bat_init);
-module_exit(wm97xx_bat_exit);
+module_platform_driver(wm97xx_bat_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Marek Vasut <marek.vasut@gmail.com>");
-- 
1.7.5.4



