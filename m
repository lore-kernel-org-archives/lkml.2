Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161380Ab1FALS6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 07:18:58 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58270 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161186Ab1FALSm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 07:18:42 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-input@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: [PATCH 3/8] MFD: twl4030-audio: Rename platform data
Date: Wed, 1 Jun 2011 14:17:26 +0300
Message-ID: <1306927051-8937-4-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.5.3
In-Reply-To: <1306927051-8937-1-git-send-email-peter.ujfalusi@ti.com>
References: <1306927051-8937-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allign the platform data names for twl4030 audio submodule:
twl4030_audio_data: for the core MFD driver
twl4030_codec_data: for ASoC codec driver
twl4030_vibra_data: for the input/ForceFeedback driver

To avoid breakage, change all depending drivers, files
to use the new types.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 arch/arm/mach-omap2/board-3430sdp.c          |    8 ++++----
 arch/arm/mach-omap2/board-devkit8000.c       |    8 ++++----
 arch/arm/mach-omap2/board-igep0020.c         |    8 ++++----
 arch/arm/mach-omap2/board-omap3beagle.c      |    8 ++++----
 arch/arm/mach-omap2/board-omap3evm.c         |    8 ++++----
 arch/arm/mach-omap2/board-omap3pandora.c     |    8 ++++----
 arch/arm/mach-omap2/board-omap3stalker.c     |    8 ++++----
 arch/arm/mach-omap2/board-omap3touchbook.c   |    8 ++++----
 arch/arm/mach-omap2/board-overo.c            |    8 ++++----
 arch/arm/mach-omap2/board-rx51-peripherals.c |    6 +++---
 arch/arm/mach-omap2/board-zoom-peripherals.c |   14 +++++++-------
 drivers/input/misc/twl4030-vibra.c           |    2 +-
 drivers/mfd/twl-core.c                       |    8 ++++----
 drivers/mfd/twl4030-audio.c                  |    8 ++++----
 include/linux/i2c/twl.h                      |   12 ++++++------
 sound/soc/codecs/twl4030.c                   |    6 +++---
 sound/soc/codecs/twl6040.c                   |    2 +-
 17 files changed, 65 insertions(+), 65 deletions(-)

diff --git a/arch/arm/mach-omap2/board-3430sdp.c b/arch/arm/mach-omap2/board-3430sdp.c
index ae2963a..36fb018 100644
--- a/arch/arm/mach-omap2/board-3430sdp.c
+++ b/arch/arm/mach-omap2/board-3430sdp.c
@@ -463,11 +463,11 @@ static struct regulator_init_data sdp3430_vpll2 = {
 	.consumer_supplies	= sdp3430_vpll2_supplies,
 };
 
-static struct twl4030_codec_audio_data sdp3430_audio;
+static struct twl4030_codec_data sdp3430_codec;
 
-static struct twl4030_codec_data sdp3430_codec = {
+static struct twl4030_audio_data sdp3430_audio = {
 	.audio_mclk = 26000000,
-	.audio = &sdp3430_audio,
+	.codec = &sdp3430_codec,
 };
 
 static struct twl4030_platform_data sdp3430_twldata = {
@@ -480,7 +480,7 @@ static struct twl4030_platform_data sdp3430_twldata = {
 	.madc		= &sdp3430_madc_data,
 	.keypad		= &sdp3430_kp_data,
 	.usb		= &sdp3430_usb_data,
-	.codec		= &sdp3430_codec,
+	.audio		= &sdp3430_audio,
 
 	.vaux1		= &sdp3430_vaux1,
 	.vaux2		= &sdp3430_vaux2,
diff --git a/arch/arm/mach-omap2/board-devkit8000.c b/arch/arm/mach-omap2/board-devkit8000.c
index cf520d7..3a83bc4 100644
--- a/arch/arm/mach-omap2/board-devkit8000.c
+++ b/arch/arm/mach-omap2/board-devkit8000.c
@@ -337,11 +337,11 @@ static struct twl4030_usb_data devkit8000_usb_data = {
 	.usb_mode	= T2_USB_MODE_ULPI,
 };
 
-static struct twl4030_codec_audio_data devkit8000_audio_data;
+static struct twl4030_codec_data devkit8000_codec_data;
 
-static struct twl4030_codec_data devkit8000_codec_data = {
+static struct twl4030_audio_data devkit8000_audio_data = {
 	.audio_mclk = 26000000,
-	.audio = &devkit8000_audio_data,
+	.codec = &devkit8000_codec_data,
 };
 
 static struct twl4030_platform_data devkit8000_twldata = {
@@ -351,7 +351,7 @@ static struct twl4030_platform_data devkit8000_twldata = {
 	/* platform_data for children goes here */
 	.usb		= &devkit8000_usb_data,
 	.gpio		= &devkit8000_gpio_data,
-	.codec		= &devkit8000_codec_data,
+	.audio		= &devkit8000_audio_data,
 	.vmmc1		= &devkit8000_vmmc1,
 	.vdac		= &devkit8000_vdac,
 	.vpll1		= &devkit8000_vpll1,
diff --git a/arch/arm/mach-omap2/board-igep0020.c b/arch/arm/mach-omap2/board-igep0020.c
index 0c1bfca..89d3999 100644
--- a/arch/arm/mach-omap2/board-igep0020.c
+++ b/arch/arm/mach-omap2/board-igep0020.c
@@ -519,11 +519,11 @@ static void __init igep_init_early(void)
 				  m65kxxxxam_sdrc_params);
 }
 
-static struct twl4030_codec_audio_data igep2_audio_data;
+static struct twl4030_codec_data igep2_codec_data;
 
-static struct twl4030_codec_data igep2_codec_data = {
+static struct twl4030_audio_data igep2_audio_data = {
 	.audio_mclk = 26000000,
-	.audio = &igep2_audio_data,
+	.codec = &igep2_codec_data,
 };
 
 static int igep2_keymap[] = {
@@ -588,7 +588,7 @@ static void __init igep_i2c_init(void)
 		if (ret)
 			pr_warning("IGEP2: Could not register I2C3 bus (%d)\n", ret);
 
-		igep_twldata.codec	= &igep2_codec_data;
+		igep_twldata.audio	= &igep2_audio_data;
 		igep_twldata.keypad	= &igep2_keypad_pdata;
 		igep_twldata.vpll2	= &igep2_vpll2;
 	}
diff --git a/arch/arm/mach-omap2/board-omap3beagle.c b/arch/arm/mach-omap2/board-omap3beagle.c
index be71426..d8ff23b 100644
--- a/arch/arm/mach-omap2/board-omap3beagle.c
+++ b/arch/arm/mach-omap2/board-omap3beagle.c
@@ -387,11 +387,11 @@ static struct twl4030_usb_data beagle_usb_data = {
 	.usb_mode	= T2_USB_MODE_ULPI,
 };
 
-static struct twl4030_codec_audio_data beagle_audio_data;
+static struct twl4030_codec_data beagle_codec_data;
 
-static struct twl4030_codec_data beagle_codec_data = {
+static struct twl4030_audio_data beagle_audio_data = {
 	.audio_mclk = 26000000,
-	.audio = &beagle_audio_data,
+	.codec = &beagle_codec_data,
 };
 
 static struct twl4030_platform_data beagle_twldata = {
@@ -401,7 +401,7 @@ static struct twl4030_platform_data beagle_twldata = {
 	/* platform_data for children goes here */
 	.usb		= &beagle_usb_data,
 	.gpio		= &beagle_gpio_data,
-	.codec		= &beagle_codec_data,
+	.audio		= &beagle_audio_data,
 	.vmmc1		= &beagle_vmmc1,
 	.vsim		= &beagle_vsim,
 	.vdac		= &beagle_vdac,
diff --git a/arch/arm/mach-omap2/board-omap3evm.c b/arch/arm/mach-omap2/board-omap3evm.c
index b4d4346..76677d0 100644
--- a/arch/arm/mach-omap2/board-omap3evm.c
+++ b/arch/arm/mach-omap2/board-omap3evm.c
@@ -442,11 +442,11 @@ static struct twl4030_madc_platform_data omap3evm_madc_data = {
 	.irq_line	= 1,
 };
 
-static struct twl4030_codec_audio_data omap3evm_audio_data;
+static struct twl4030_codec_data omap3evm_codec_data;
 
-static struct twl4030_codec_data omap3evm_codec_data = {
+static struct twl4030_audio_data omap3evm_audio_data = {
 	.audio_mclk = 26000000,
-	.audio = &omap3evm_audio_data,
+	.codec = &omap3evm_codec_data,
 };
 
 static struct regulator_consumer_supply omap3_evm_vdda_dac_supply =
@@ -556,7 +556,7 @@ static struct twl4030_platform_data omap3evm_twldata = {
 	.madc		= &omap3evm_madc_data,
 	.usb		= &omap3evm_usb_data,
 	.gpio		= &omap3evm_gpio_data,
-	.codec		= &omap3evm_codec_data,
+	.audio		= &omap3evm_audio_data,
 	.vdac		= &omap3_evm_vdac,
 	.vpll2		= &omap3_evm_vpll2,
 	.vio		= &omap3evm_vio,
diff --git a/arch/arm/mach-omap2/board-omap3pandora.c b/arch/arm/mach-omap2/board-omap3pandora.c
index 1d10736..b30df05 100644
--- a/arch/arm/mach-omap2/board-omap3pandora.c
+++ b/arch/arm/mach-omap2/board-omap3pandora.c
@@ -506,11 +506,11 @@ static struct twl4030_usb_data omap3pandora_usb_data = {
 	.usb_mode	= T2_USB_MODE_ULPI,
 };
 
-static struct twl4030_codec_audio_data omap3pandora_audio_data;
+static struct twl4030_codec_data omap3pandora_codec_data;
 
-static struct twl4030_codec_data omap3pandora_codec_data = {
+static struct twl4030_audio_data omap3pandora_audio_data = {
 	.audio_mclk = 26000000,
-	.audio = &omap3pandora_audio_data,
+	.codec = &omap3pandora_codec_data,
 };
 
 static struct twl4030_bci_platform_data pandora_bci_data;
@@ -520,7 +520,7 @@ static struct twl4030_platform_data omap3pandora_twldata = {
 	.irq_end	= TWL4030_IRQ_END,
 	.gpio		= &omap3pandora_gpio_data,
 	.usb		= &omap3pandora_usb_data,
-	.codec		= &omap3pandora_codec_data,
+	.audio		= &omap3pandora_audio_data,
 	.vmmc1		= &pandora_vmmc1,
 	.vmmc2		= &pandora_vmmc2,
 	.vdac		= &pandora_vdac,
diff --git a/arch/arm/mach-omap2/board-omap3stalker.c b/arch/arm/mach-omap2/board-omap3stalker.c
index 0c108a2..f4d6eea 100644
--- a/arch/arm/mach-omap2/board-omap3stalker.c
+++ b/arch/arm/mach-omap2/board-omap3stalker.c
@@ -396,11 +396,11 @@ static struct twl4030_madc_platform_data omap3stalker_madc_data = {
 	.irq_line	= 1,
 };
 
-static struct twl4030_codec_audio_data omap3stalker_audio_data;
+static struct twl4030_codec_data omap3stalker_codec_data;
 
-static struct twl4030_codec_data omap3stalker_codec_data = {
+static struct twl4030_audio_data omap3stalker_audio_data = {
 	.audio_mclk	= 26000000,
-	.audio		= &omap3stalker_audio_data,
+	.codec		= &omap3stalker_codec_data,
 };
 
 static struct regulator_consumer_supply omap3_stalker_vdda_dac_supply =
@@ -451,7 +451,7 @@ static struct twl4030_platform_data omap3stalker_twldata = {
 	.madc		= &omap3stalker_madc_data,
 	.usb		= &omap3stalker_usb_data,
 	.gpio		= &omap3stalker_gpio_data,
-	.codec		= &omap3stalker_codec_data,
+	.audio		= &omap3stalker_audio_data,
 	.vdac		= &omap3_stalker_vdac,
 	.vpll2		= &omap3_stalker_vpll2,
 	.vmmc1		= &omap3stalker_vmmc1,
diff --git a/arch/arm/mach-omap2/board-omap3touchbook.c b/arch/arm/mach-omap2/board-omap3touchbook.c
index 82872d7..dca3664 100644
--- a/arch/arm/mach-omap2/board-omap3touchbook.c
+++ b/arch/arm/mach-omap2/board-omap3touchbook.c
@@ -242,11 +242,11 @@ static struct twl4030_usb_data touchbook_usb_data = {
 	.usb_mode	= T2_USB_MODE_ULPI,
 };
 
-static struct twl4030_codec_audio_data touchbook_audio_data;
+static struct twl4030_codec_data touchbook_codec_data;
 
-static struct twl4030_codec_data touchbook_codec_data = {
+static struct twl4030_audio_data touchbook_audio_data = {
 	.audio_mclk = 26000000,
-	.audio = &touchbook_audio_data,
+	.codec = &touchbook_codec_data,
 };
 
 static struct twl4030_platform_data touchbook_twldata = {
@@ -256,7 +256,7 @@ static struct twl4030_platform_data touchbook_twldata = {
 	/* platform_data for children goes here */
 	.usb		= &touchbook_usb_data,
 	.gpio		= &touchbook_gpio_data,
-	.codec		= &touchbook_codec_data,
+	.audio		= &touchbook_audio_data,
 	.vmmc1		= &touchbook_vmmc1,
 	.vsim		= &touchbook_vsim,
 	.vdac		= &touchbook_vdac,
diff --git a/arch/arm/mach-omap2/board-overo.c b/arch/arm/mach-omap2/board-overo.c
index 1555918..1395bc9 100644
--- a/arch/arm/mach-omap2/board-overo.c
+++ b/arch/arm/mach-omap2/board-overo.c
@@ -482,11 +482,11 @@ static struct regulator_init_data overo_vpll2 = {
 	.consumer_supplies	= overo_vdds_dsi_supply,
 };
 
-static struct twl4030_codec_audio_data overo_audio_data;
+static struct twl4030_codec_data overo_codec_data;
 
-static struct twl4030_codec_data overo_codec_data = {
+static struct twl4030_audio_data overo_audio_data = {
 	.audio_mclk = 26000000,
-	.audio = &overo_audio_data,
+	.codec = &overo_codec_data,
 };
 
 static struct twl4030_platform_data overo_twldata = {
@@ -494,7 +494,7 @@ static struct twl4030_platform_data overo_twldata = {
 	.irq_end	= TWL4030_IRQ_END,
 	.gpio		= &overo_gpio_data,
 	.usb		= &overo_usb_data,
-	.codec		= &overo_codec_data,
+	.audio		= &overo_audio_data,
 	.vmmc1		= &overo_vmmc1,
 	.vdac		= &overo_vdac,
 	.vpll2		= &overo_vpll2,
diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c b/arch/arm/mach-omap2/board-rx51-peripherals.c
index f6247e7..382057d 100644
--- a/arch/arm/mach-omap2/board-rx51-peripherals.c
+++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
@@ -764,11 +764,11 @@ static struct twl4030_power_data rx51_t2scripts_data __initdata = {
 	.resource_config = twl4030_rconfig,
 };
 
-struct twl4030_codec_vibra_data rx51_vibra_data __initdata = {
+struct twl4030_vibra_data rx51_vibra_data __initdata = {
 	.coexist	= 0,
 };
 
-struct twl4030_codec_data rx51_codec_data __initdata = {
+struct twl4030_audio_data rx51_audio_data __initdata = {
 	.audio_mclk	= 26000000,
 	.vibra		= &rx51_vibra_data,
 };
@@ -783,7 +783,7 @@ static struct twl4030_platform_data rx51_twldata __initdata = {
 	.madc			= &rx51_madc_data,
 	.usb			= &rx51_usb_data,
 	.power			= &rx51_t2scripts_data,
-	.codec			= &rx51_codec_data,
+	.audio			= &rx51_audio_data,
 
 	.vaux1			= &rx51_vaux1,
 	.vaux2			= &rx51_vaux2,
diff --git a/arch/arm/mach-omap2/board-zoom-peripherals.c b/arch/arm/mach-omap2/board-zoom-peripherals.c
index 118c6f5..3060e11 100644
--- a/arch/arm/mach-omap2/board-zoom-peripherals.c
+++ b/arch/arm/mach-omap2/board-zoom-peripherals.c
@@ -323,11 +323,11 @@ static struct twl4030_madc_platform_data zoom_madc_data = {
 	.irq_line	= 1,
 };
 
-static struct twl4030_codec_audio_data zoom_audio_data;
+static struct twl4030_codec_data zoom_codec_data;
 
-static struct twl4030_codec_data zoom_codec_data = {
+static struct twl4030_audio_data zoom_audio_data = {
 	.audio_mclk = 26000000,
-	.audio = &zoom_audio_data,
+	.codec = &zoom_codec_data,
 };
 
 static struct twl4030_platform_data zoom_twldata = {
@@ -340,7 +340,7 @@ static struct twl4030_platform_data zoom_twldata = {
 	.usb		= &zoom_usb_data,
 	.gpio		= &zoom_gpio_data,
 	.keypad		= &zoom_kp_twl4030_data,
-	.codec		= &zoom_codec_data,
+	.audio		= &zoom_audio_data,
 	.vmmc1          = &zoom_vmmc1,
 	.vmmc2          = &zoom_vmmc2,
 	.vsim           = &zoom_vsim,
@@ -351,9 +351,9 @@ static struct twl4030_platform_data zoom_twldata = {
 static int __init omap_i2c_init(void)
 {
 	if (machine_is_omap_zoom2()) {
-		zoom_audio_data.ramp_delay_value = 3;	/* 161 ms */
-		zoom_audio_data.hs_extmute = 1;
-		zoom_audio_data.set_hs_extmute = zoom2_set_hs_extmute;
+		zoom_codec_data.ramp_delay_value = 3;	/* 161 ms */
+		zoom_codec_data.hs_extmute = 1;
+		zoom_codec_data.set_hs_extmute = zoom2_set_hs_extmute;
 	}
 	omap_pmic_init(1, 2400, "twl5030", INT_34XX_SYS_NIRQ, &zoom_twldata);
 	omap_register_i2c_bus(2, 400, NULL, 0);
diff --git a/drivers/input/misc/twl4030-vibra.c b/drivers/input/misc/twl4030-vibra.c
index 7abca85..3c1a432 100644
--- a/drivers/input/misc/twl4030-vibra.c
+++ b/drivers/input/misc/twl4030-vibra.c
@@ -196,7 +196,7 @@ static SIMPLE_DEV_PM_OPS(twl4030_vibra_pm_ops,
 
 static int __devinit twl4030_vibra_probe(struct platform_device *pdev)
 {
-	struct twl4030_codec_vibra_data *pdata = pdev->dev.platform_data;
+	struct twl4030_vibra_data *pdata = pdev->dev.platform_data;
 	struct vibra_info *info;
 	int ret;
 
diff --git a/drivers/mfd/twl-core.c b/drivers/mfd/twl-core.c
index b8f2a4e..f9d7880 100644
--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -815,20 +815,20 @@ add_children(struct twl4030_platform_data *pdata, unsigned long features)
 			return PTR_ERR(child);
 	}
 
-	if (twl_has_codec() && pdata->codec && twl_class_is_4030()) {
+	if (twl_has_codec() && pdata->audio && twl_class_is_4030()) {
 		sub_chip_id = twl_map[TWL_MODULE_AUDIO_VOICE].sid;
 		child = add_child(sub_chip_id, "twl4030-audio",
-				pdata->codec, sizeof(*pdata->codec),
+				pdata->audio, sizeof(*pdata->audio),
 				false, 0, 0);
 		if (IS_ERR(child))
 			return PTR_ERR(child);
 	}
 
 	/* Phoenix codec driver is probed directly atm */
-	if (twl_has_codec() && pdata->codec && twl_class_is_6030()) {
+	if (twl_has_codec() && pdata->audio && twl_class_is_6030()) {
 		sub_chip_id = twl_map[TWL_MODULE_AUDIO_VOICE].sid;
 		child = add_child(sub_chip_id, "twl6040-codec",
-				pdata->codec, sizeof(*pdata->codec),
+				pdata->audio, sizeof(*pdata->audio),
 				false, 0, 0);
 		if (IS_ERR(child))
 			return PTR_ERR(child);
diff --git a/drivers/mfd/twl4030-audio.c b/drivers/mfd/twl4030-audio.c
index 467ddb8..353bce8 100644
--- a/drivers/mfd/twl4030-audio.c
+++ b/drivers/mfd/twl4030-audio.c
@@ -159,7 +159,7 @@ EXPORT_SYMBOL_GPL(twl4030_audio_get_mclk);
 static int __devinit twl4030_audio_probe(struct platform_device *pdev)
 {
 	struct twl4030_audio *audio;
-	struct twl4030_codec_data *pdata = pdev->dev.platform_data;
+	struct twl4030_audio_data *pdata = pdev->dev.platform_data;
 	struct mfd_cell *cell = NULL;
 	int ret, childs = 0;
 	u8 val;
@@ -206,11 +206,11 @@ static int __devinit twl4030_audio_probe(struct platform_device *pdev)
 	audio->resource[TWL4030_AUDIO_RES_APLL].reg = TWL4030_REG_APLL_CTL;
 	audio->resource[TWL4030_AUDIO_RES_APLL].mask = TWL4030_APLL_EN;
 
-	if (pdata->audio) {
+	if (pdata->codec) {
 		cell = &audio->cells[childs];
 		cell->name = "twl4030-codec";
-		cell->platform_data = pdata->audio;
-		cell->pdata_size = sizeof(*pdata->audio);
+		cell->platform_data = pdata->codec;
+		cell->pdata_size = sizeof(*pdata->codec);
 		childs++;
 	}
 	if (pdata->vibra) {
diff --git a/include/linux/i2c/twl.h b/include/linux/i2c/twl.h
index ba4f886..e0aba2b 100644
--- a/include/linux/i2c/twl.h
+++ b/include/linux/i2c/twl.h
@@ -657,7 +657,7 @@ struct twl4030_power_data {
 extern void twl4030_power_init(struct twl4030_power_data *triton2_scripts);
 extern int twl4030_remove_script(u8 flags);
 
-struct twl4030_codec_audio_data {
+struct twl4030_codec_data {
 	unsigned int digimic_delay; /* in ms */
 	unsigned int ramp_delay_value;
 	unsigned int offset_cncl_path;
@@ -667,14 +667,14 @@ struct twl4030_codec_audio_data {
 	void (*set_hs_extmute)(int mute);
 };
 
-struct twl4030_codec_vibra_data {
+struct twl4030_vibra_data {
 	unsigned int	coexist;
 };
 
-struct twl4030_codec_data {
+struct twl4030_audio_data {
 	unsigned int	audio_mclk;
-	struct twl4030_codec_audio_data		*audio;
-	struct twl4030_codec_vibra_data		*vibra;
+	struct twl4030_codec_data *codec;
+	struct twl4030_vibra_data *vibra;
 
 	/* twl6040 */
 	int audpwron_gpio;	/* audio power-on gpio */
@@ -690,7 +690,7 @@ struct twl4030_platform_data {
 	struct twl4030_keypad_data		*keypad;
 	struct twl4030_usb_data			*usb;
 	struct twl4030_power_data		*power;
-	struct twl4030_codec_data		*codec;
+	struct twl4030_audio_data		*audio;
 
 	/* Common LDO regulators for TWL4030/TWL6030 */
 	struct regulator_init_data		*vdac;
diff --git a/sound/soc/codecs/twl4030.c b/sound/soc/codecs/twl4030.c
index 5e648d3..71674be 100644
--- a/sound/soc/codecs/twl4030.c
+++ b/sound/soc/codecs/twl4030.c
@@ -297,7 +297,7 @@ static inline void twl4030_reset_registers(struct snd_soc_codec *codec)
 
 static void twl4030_init_chip(struct snd_soc_codec *codec)
 {
-	struct twl4030_codec_audio_data *pdata = dev_get_platdata(codec->dev);
+	struct twl4030_codec_data *pdata = dev_get_platdata(codec->dev);
 	struct twl4030_priv *twl4030 = snd_soc_codec_get_drvdata(codec);
 	u8 reg, byte;
 	int i = 0;
@@ -732,7 +732,7 @@ static int aif_event(struct snd_soc_dapm_widget *w,
 
 static void headset_ramp(struct snd_soc_codec *codec, int ramp)
 {
-	struct twl4030_codec_audio_data *pdata = codec->dev->platform_data;
+	struct twl4030_codec_data *pdata = codec->dev->platform_data;
 	unsigned char hs_gain, hs_pop;
 	struct twl4030_priv *twl4030 = snd_soc_codec_get_drvdata(codec);
 	/* Base values for ramp delay calculation: 2^19 - 2^26 */
@@ -2297,7 +2297,7 @@ static struct snd_soc_codec_driver soc_codec_dev_twl4030 = {
 
 static int __devinit twl4030_codec_probe(struct platform_device *pdev)
 {
-	struct twl4030_codec_audio_data *pdata = pdev->dev.platform_data;
+	struct twl4030_codec_data *pdata = pdev->dev.platform_data;
 
 	if (!pdata) {
 		dev_err(&pdev->dev, "platform_data is missing\n");
diff --git a/sound/soc/codecs/twl6040.c b/sound/soc/codecs/twl6040.c
index 4c33663..ade6616 100644
--- a/sound/soc/codecs/twl6040.c
+++ b/sound/soc/codecs/twl6040.c
@@ -1600,7 +1600,7 @@ static int twl6040_resume(struct snd_soc_codec *codec)
 
 static int twl6040_probe(struct snd_soc_codec *codec)
 {
-	struct twl4030_codec_data *twl_codec = codec->dev->platform_data;
+	struct twl4030_audio_data *twl_codec = codec->dev->platform_data;
 	struct twl6040_data *priv;
 	int audpwron, naudint;
 	int ret = 0;
-- 
1.7.5.3

