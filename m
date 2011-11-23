Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578Ab1KWW6j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 17:58:39 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58943 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754842Ab1KWW6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 17:58:38 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Convert MFD drivers to use module_platform_driver
Date: Wed, 23 Nov 2011 22:58:34 +0000
Message-Id: <1322089114-2155-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factors out some boilerplate code for drivers doing the default thing
for platform driver registration. Drivers using platform_driver_probe
or an initcall other than module_init can't be converted.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/intel_msic.c    |   12 +-----------
 drivers/mfd/jz4740-adc.c    |   12 +-----------
 drivers/mfd/mcp-sa11x0.c    |   13 +------------
 drivers/mfd/pcf50633-adc.c  |   12 +-----------
 drivers/mfd/t7l66xb.c       |   16 +---------------
 drivers/mfd/tc6387xb.c      |   14 +-------------
 drivers/mfd/ti-ssp.c        |   12 +-----------
 drivers/mfd/twl4030-audio.c |   12 +-----------
 drivers/mfd/twl4030-madc.c  |   14 +-------------
 drivers/mfd/twl6040-core.c  |   13 +------------
 10 files changed, 10 insertions(+), 120 deletions(-)

diff --git a/drivers/mfd/intel_msic.c b/drivers/mfd/intel_msic.c
index 97c2776..b76657e 100644
--- a/drivers/mfd/intel_msic.c
+++ b/drivers/mfd/intel_msic.c
@@ -485,17 +485,7 @@ static struct platform_driver intel_msic_driver = {
 	},
 };
 
-static int __init intel_msic_init(void)
-{
-	return platform_driver_register(&intel_msic_driver);
-}
-module_init(intel_msic_init);
-
-static void __exit intel_msic_exit(void)
-{
-	platform_driver_unregister(&intel_msic_driver);
-}
-module_exit(intel_msic_exit);
+module_platform_driver(intel_msic_driver);
 
 MODULE_DESCRIPTION("Driver for Intel MSIC");
 MODULE_AUTHOR("Mika Westerberg <mika.westerberg@linux.intel.com>");
diff --git a/drivers/mfd/jz4740-adc.c b/drivers/mfd/jz4740-adc.c
index 1e9ee53..4ab4577 100644
--- a/drivers/mfd/jz4740-adc.c
+++ b/drivers/mfd/jz4740-adc.c
@@ -337,17 +337,7 @@ static struct platform_driver jz4740_adc_driver = {
 	},
 };
 
-static int __init jz4740_adc_init(void)
-{
-	return platform_driver_register(&jz4740_adc_driver);
-}
-module_init(jz4740_adc_init);
-
-static void __exit jz4740_adc_exit(void)
-{
-	platform_driver_unregister(&jz4740_adc_driver);
-}
-module_exit(jz4740_adc_exit);
+module_platform_driver(jz4740_adc_driver);
 
 MODULE_DESCRIPTION("JZ4740 SoC ADC driver");
 MODULE_AUTHOR("Lars-Peter Clausen <lars@metafoo.de>");
diff --git a/drivers/mfd/mcp-sa11x0.c b/drivers/mfd/mcp-sa11x0.c
index 2dab02d..02c53a0 100644
--- a/drivers/mfd/mcp-sa11x0.c
+++ b/drivers/mfd/mcp-sa11x0.c
@@ -257,18 +257,7 @@ static struct platform_driver mcp_sa11x0_driver = {
 /*
  * This needs re-working
  */
-static int __init mcp_sa11x0_init(void)
-{
-	return platform_driver_register(&mcp_sa11x0_driver);
-}
-
-static void __exit mcp_sa11x0_exit(void)
-{
-	platform_driver_unregister(&mcp_sa11x0_driver);
-}
-
-module_init(mcp_sa11x0_init);
-module_exit(mcp_sa11x0_exit);
+module_platform_driver(mcp_sa11x0_driver);
 
 MODULE_AUTHOR("Russell King <rmk@arm.linux.org.uk>");
 MODULE_DESCRIPTION("SA11x0 multimedia communications port driver");
diff --git a/drivers/mfd/pcf50633-adc.c b/drivers/mfd/pcf50633-adc.c
index aed0d2a..3927c17 100644
--- a/drivers/mfd/pcf50633-adc.c
+++ b/drivers/mfd/pcf50633-adc.c
@@ -249,17 +249,7 @@ static struct platform_driver pcf50633_adc_driver = {
 	.remove = __devexit_p(pcf50633_adc_remove),
 };
 
-static int __init pcf50633_adc_init(void)
-{
-	return platform_driver_register(&pcf50633_adc_driver);
-}
-module_init(pcf50633_adc_init);
-
-static void __exit pcf50633_adc_exit(void)
-{
-	platform_driver_unregister(&pcf50633_adc_driver);
-}
-module_exit(pcf50633_adc_exit);
+module_platform_driver(pcf50633_adc_driver);
 
 MODULE_AUTHOR("Balaji Rao <balajirrao@openmoko.org>");
 MODULE_DESCRIPTION("PCF50633 adc driver");
diff --git a/drivers/mfd/t7l66xb.c b/drivers/mfd/t7l66xb.c
index 91ad21e..2d9e879 100644
--- a/drivers/mfd/t7l66xb.c
+++ b/drivers/mfd/t7l66xb.c
@@ -442,21 +442,7 @@ static struct platform_driver t7l66xb_platform_driver = {
 
 /*--------------------------------------------------------------------------*/
 
-static int __init t7l66xb_init(void)
-{
-	int retval = 0;
-
-	retval = platform_driver_register(&t7l66xb_platform_driver);
-	return retval;
-}
-
-static void __exit t7l66xb_exit(void)
-{
-	platform_driver_unregister(&t7l66xb_platform_driver);
-}
-
-module_init(t7l66xb_init);
-module_exit(t7l66xb_exit);
+module_platform_driver(t7l66xb_platform_driver);
 
 MODULE_DESCRIPTION("Toshiba T7L66XB core driver");
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/mfd/tc6387xb.c b/drivers/mfd/tc6387xb.c
index 71bc835..d20a284 100644
--- a/drivers/mfd/tc6387xb.c
+++ b/drivers/mfd/tc6387xb.c
@@ -234,19 +234,7 @@ static struct platform_driver tc6387xb_platform_driver = {
 	.resume         = tc6387xb_resume,
 };
 
-
-static int __init tc6387xb_init(void)
-{
-	return platform_driver_register(&tc6387xb_platform_driver);
-}
-
-static void __exit tc6387xb_exit(void)
-{
-	platform_driver_unregister(&tc6387xb_platform_driver);
-}
-
-module_init(tc6387xb_init);
-module_exit(tc6387xb_exit);
+module_platform_driver(tc6387xb_platform_driver);
 
 MODULE_DESCRIPTION("Toshiba TC6387XB core driver");
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/mfd/ti-ssp.c b/drivers/mfd/ti-ssp.c
index af9ab0e..4fb0e6c 100644
--- a/drivers/mfd/ti-ssp.c
+++ b/drivers/mfd/ti-ssp.c
@@ -458,17 +458,7 @@ static struct platform_driver ti_ssp_driver = {
 	}
 };
 
-static int __init ti_ssp_init(void)
-{
-	return platform_driver_register(&ti_ssp_driver);
-}
-module_init(ti_ssp_init);
-
-static void __exit ti_ssp_exit(void)
-{
-	platform_driver_unregister(&ti_ssp_driver);
-}
-module_exit(ti_ssp_exit);
+module_platform_driver(ti_ssp_driver);
 
 MODULE_DESCRIPTION("Sequencer Serial Port (SSP) Driver");
 MODULE_AUTHOR("Cyril Chemparathy");
diff --git a/drivers/mfd/twl4030-audio.c b/drivers/mfd/twl4030-audio.c
index ae51ab5..838ce4e 100644
--- a/drivers/mfd/twl4030-audio.c
+++ b/drivers/mfd/twl4030-audio.c
@@ -261,17 +261,7 @@ static struct platform_driver twl4030_audio_driver = {
 	},
 };
 
-static int __devinit twl4030_audio_init(void)
-{
-	return platform_driver_register(&twl4030_audio_driver);
-}
-module_init(twl4030_audio_init);
-
-static void __devexit twl4030_audio_exit(void)
-{
-	platform_driver_unregister(&twl4030_audio_driver);
-}
-module_exit(twl4030_audio_exit);
+module_platform_driver(twl4030_audio_driver);
 
 MODULE_AUTHOR("Peter Ujfalusi <peter.ujfalusi@ti.com>");
 MODULE_LICENSE("GPL");
diff --git a/drivers/mfd/twl4030-madc.c b/drivers/mfd/twl4030-madc.c
index 834f824..456ecb5 100644
--- a/drivers/mfd/twl4030-madc.c
+++ b/drivers/mfd/twl4030-madc.c
@@ -807,19 +807,7 @@ static struct platform_driver twl4030_madc_driver = {
 		   },
 };
 
-static int __init twl4030_madc_init(void)
-{
-	return platform_driver_register(&twl4030_madc_driver);
-}
-
-module_init(twl4030_madc_init);
-
-static void __exit twl4030_madc_exit(void)
-{
-	platform_driver_unregister(&twl4030_madc_driver);
-}
-
-module_exit(twl4030_madc_exit);
+module_platform_driver(twl4030_madc_driver);
 
 MODULE_DESCRIPTION("TWL4030 ADC driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/mfd/twl6040-core.c b/drivers/mfd/twl6040-core.c
index 268f80f..7f06685 100644
--- a/drivers/mfd/twl6040-core.c
+++ b/drivers/mfd/twl6040-core.c
@@ -619,18 +619,7 @@ static struct platform_driver twl6040_driver = {
 	},
 };
 
-static int __devinit twl6040_init(void)
-{
-	return platform_driver_register(&twl6040_driver);
-}
-module_init(twl6040_init);
-
-static void __devexit twl6040_exit(void)
-{
-	platform_driver_unregister(&twl6040_driver);
-}
-
-module_exit(twl6040_exit);
+module_platform_driver(twl6040_driver);
 
 MODULE_DESCRIPTION("TWL6040 MFD");
 MODULE_AUTHOR("Misael Lopez Cruz <misael.lopez@ti.com>");
-- 
1.7.7.3

