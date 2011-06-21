Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521Ab1FUOkF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 10:40:05 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:48255 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751369Ab1FUOj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 10:39:57 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-input@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: [PATCH v6 07/18] MFD: twl4030-audio: Rename platform data
Date: Tue, 21 Jun 2011 16:39:05 +0300
Message-ID: <1308663556-29120-8-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.5.3
In-Reply-To: <1308663556-29120-1-git-send-email-peter.ujfalusi@ti.com>
References: <1308663556-29120-1-git-send-email-peter.ujfalusi@ti.com>
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
 arch/arm/mach-omap2/board-rx51-peripherals.c |    6 +++---
 arch/arm/mach-omap2/board-zoom-peripherals.c |   10 +++++-----
 arch/arm/mach-omap2/twl-common.c             |   10 +++++-----
 drivers/input/misc/twl4030-vibra.c           |    2 +-
 drivers/mfd/twl-core.c                       |    8 ++++----
 drivers/mfd/twl4030-audio.c                  |    8 ++++----
 include/linux/i2c/twl.h                      |   12 ++++++------
 sound/soc/codecs/twl4030.c                   |    6 +++---
 sound/soc/codecs/twl6040.c                   |    2 +-
 9 files changed, 32 insertions(+), 32 deletions(-)

diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c b/arch/arm/mach-omap2/board-rx51-peripherals.c
index dfaf874..a2d3e19 100644
--- a/arch/arm/mach-omap2/board-rx51-peripherals.c
+++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
@@ -738,11 +738,11 @@ static struct twl4030_power_data rx51_t2scripts_data __initdata = {
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
@@ -752,7 +752,7 @@ static struct twl4030_platform_data rx51_twldata __initdata = {
 	.gpio			= &rx51_gpio_data,
 	.keypad			= &rx51_kp_data,
 	.power			= &rx51_t2scripts_data,
-	.codec			= &rx51_codec_data,
+	.audio			= &rx51_audio_data,
 
 	.vaux1			= &rx51_vaux1,
 	.vaux2			= &rx51_vaux2,
diff --git a/arch/arm/mach-omap2/board-zoom-peripherals.c b/arch/arm/mach-omap2/board-zoom-peripherals.c
index 8853dc4..6d44409 100644
--- a/arch/arm/mach-omap2/board-zoom-peripherals.c
+++ b/arch/arm/mach-omap2/board-zoom-peripherals.c
@@ -282,12 +282,12 @@ static int __init omap_i2c_init(void)
 			TWL_COMMON_REGULATOR_VDAC | TWL_COMMON_REGULATOR_VPLL2);
 
 	if (machine_is_omap_zoom2()) {
-		struct twl4030_codec_audio_data *audio_data;
-		audio_data = zoom_twldata.codec->audio;
+		struct twl4030_codec_data *codec_data;
+		codec_data = zoom_twldata.audio->codec;
 
-		audio_data->ramp_delay_value = 3;	/* 161 ms */
-		audio_data->hs_extmute = 1;
-		audio_data->set_hs_extmute = zoom2_set_hs_extmute;
+		codec_data->ramp_delay_value = 3;	/* 161 ms */
+		codec_data->hs_extmute = 1;
+		codec_data->set_hs_extmute = zoom2_set_hs_extmute;
 	}
 	omap_pmic_init(1, 2400, "twl5030", INT_34XX_SYS_NIRQ, &zoom_twldata);
 	omap_register_i2c_bus(2, 400, NULL, 0);
diff --git a/arch/arm/mach-omap2/twl-common.c b/arch/arm/mach-omap2/twl-common.c
index f15f880..ca219ea 100644
--- a/arch/arm/mach-omap2/twl-common.c
+++ b/arch/arm/mach-omap2/twl-common.c
@@ -80,11 +80,11 @@ static struct twl4030_madc_platform_data omap3_madc_pdata = {
 	.irq_line	= 1,
 };
 
-static struct twl4030_codec_audio_data omap3_audio;
+static struct twl4030_codec_data omap3_codec;
 
-static struct twl4030_codec_data omap3_codec_pdata = {
+static struct twl4030_audio_data omap3_audio_pdata = {
 	.audio_mclk = 26000000,
-	.audio = &omap3_audio,
+	.codec = &omap3_codec,
 };
 
 static struct regulator_consumer_supply omap3_vdda_dac_supplies[] = {
@@ -292,8 +292,8 @@ void __init omap3_pmic_get_config(struct twl4030_platform_data *pmic_data,
 	if (pdata_flags & TWL_COMMON_PDATA_MADC && !pmic_data->madc)
 		pmic_data->madc = &omap3_madc_pdata;
 
-	if (pdata_flags & TWL_COMMON_PDATA_AUDIO && !pmic_data->codec)
-		pmic_data->codec = &omap3_codec_pdata;
+	if (pdata_flags & TWL_COMMON_PDATA_AUDIO && !pmic_data->audio)
+		pmic_data->audio = &omap3_audio_pdata;
 
 	/* Common regulator configurations */
 	if (regulators_flags & TWL_COMMON_REGULATOR_VDAC && !pmic_data->vdac)
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
index 5cdf841..ae51ab5 100644
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

