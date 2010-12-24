Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760Ab0LXNs5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 08:48:57 -0500
Received: from smtp-out-045.synserver.de ([212.40.180.45]:1049 "HELO
	smtp-out-045.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752297Ab0LXNst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 08:48:49 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 27157
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>,
        Zhuang <haojian.zhuang@marvell.com>, Barry Song <21cnbao@gmail.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Timur Tabi <timur@freescale.com>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Richard Purdie <richard@openedhand.com>,
        Mike Arthur <Mike.Arthur@wolfsonmicro.com>,
        Jonathan Cameron <jic23@cam.ac.uk>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH 1/9] ASoC: codecs: Remove unused reg_cache fields from device structs
Date: Fri, 24 Dec 2010 14:47:56 +0100
Message-Id: <1293198484-1902-2-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1293198484-1902-1-git-send-email-lars@metafoo.de>
References: <1293198484-1902-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The multi-component patch (commit f0fba2ad1) introduced a generic register cache
handling framework in the ASoC core and most drivers where converted to use it.
But there are quite a few drivers left which now have an unused reg_cache field in
their private device struct.
This patch removes these unused fields.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Cc: Zhuang <haojian.zhuang@marvell.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Joonyoung Shim <jy0922.shim@samsung.com>
Cc: Timur Tabi <timur@freescale.com>
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Richard Purdie <richard@openedhand.com>
Cc: Mike Arthur <Mike.Arthur@wolfsonmicro.com>
Cc: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

---
Compile tested only
---
 sound/soc/codecs/88pm860x-codec.c |    1 -
 sound/soc/codecs/ad193x.c         |    1 -
 sound/soc/codecs/ak4671.c         |    1 -
 sound/soc/codecs/cs4270.c         |    1 -
 sound/soc/codecs/cs42l51.c        |    1 -
 sound/soc/codecs/cx20442.c        |    1 -
 sound/soc/codecs/tlv320aic26.c    |    4 +---
 sound/soc/codecs/uda1380.c        |    1 -
 sound/soc/codecs/wm8580.c         |    1 -
 sound/soc/codecs/wm8711.c         |    1 -
 sound/soc/codecs/wm8731.c         |    1 -
 sound/soc/codecs/wm8750.c         |    1 -
 sound/soc/codecs/wm8900.c         |    1 -
 sound/soc/codecs/wm8903.c         |    2 --
 sound/soc/codecs/wm8940.c         |    1 -
 sound/soc/codecs/wm8960.c         |    1 -
 sound/soc/codecs/wm8961.c         |    1 -
 sound/soc/codecs/wm8974.c         |    1 -
 sound/soc/codecs/wm8978.c         |    1 -
 sound/soc/codecs/wm8988.c         |    1 -
 sound/soc/codecs/wm8993.c         |    1 -
 sound/soc/codecs/wm9081.c         |    1 -
 22 files changed, 1 insertions(+), 25 deletions(-)

diff --git a/sound/soc/codecs/88pm860x-codec.c b/sound/soc/codecs/88pm860x-codec.c
index 3e798a1..5da8207 100644
--- a/sound/soc/codecs/88pm860x-codec.c
+++ b/sound/soc/codecs/88pm860x-codec.c
@@ -146,7 +146,6 @@ struct pm860x_priv {
 
 	int			irq[4];
 	unsigned char		name[4][MAX_NAME_LEN];
-	unsigned char		reg_cache[REG_CACHE_SIZE];
 };
 
 /* -9450dB to 0dB in 150dB steps ( mute instead of -9450dB) */
diff --git a/sound/soc/codecs/ad193x.c b/sound/soc/codecs/ad193x.c
index a007bd7..da46479 100644
--- a/sound/soc/codecs/ad193x.c
+++ b/sound/soc/codecs/ad193x.c
@@ -23,7 +23,6 @@
 
 /* codec private data */
 struct ad193x_priv {
-	u8 reg_cache[AD193X_NUM_REGS];
 	enum snd_soc_control_type bus_type;
 	void *control_data;
 	int sysclk;
diff --git a/sound/soc/codecs/ak4671.c b/sound/soc/codecs/ak4671.c
index 4faf105..2ec75ab 100644
--- a/sound/soc/codecs/ak4671.c
+++ b/sound/soc/codecs/ak4671.c
@@ -27,7 +27,6 @@
 struct ak4671_priv {
 	enum snd_soc_control_type control_type;
 	void *control_data;
-	u8 reg_cache[AK4671_CACHEREGNUM];
 };
 
 /* ak4671 register cache & default register settings */
diff --git a/sound/soc/codecs/cs4270.c b/sound/soc/codecs/cs4270.c
index 6d4bdc6..3a582ca 100644
--- a/sound/soc/codecs/cs4270.c
+++ b/sound/soc/codecs/cs4270.c
@@ -114,7 +114,6 @@ static const char *supply_names[] = {
 struct cs4270_private {
 	enum snd_soc_control_type control_type;
 	void *control_data;
-	u8 reg_cache[CS4270_NUMREGS];
 	unsigned int mclk; /* Input frequency of the MCLK pin */
 	unsigned int mode; /* The mode (I2S or left-justified) */
 	unsigned int slave_mode;
diff --git a/sound/soc/codecs/cs42l51.c b/sound/soc/codecs/cs42l51.c
index d4e60dc..8fb7070 100644
--- a/sound/soc/codecs/cs42l51.c
+++ b/sound/soc/codecs/cs42l51.c
@@ -46,7 +46,6 @@ struct cs42l51_private {
 	unsigned int mclk;
 	unsigned int audio_mode;	/* The mode (I2S or left-justified) */
 	enum master_slave_mode func;
-	u8 reg_cache[CS42L51_NUMREGS];
 };
 
 #define CS42L51_FORMATS ( \
diff --git a/sound/soc/codecs/cx20442.c b/sound/soc/codecs/cx20442.c
index a9521ac..03d1e86 100644
--- a/sound/soc/codecs/cx20442.c
+++ b/sound/soc/codecs/cx20442.c
@@ -26,7 +26,6 @@
 struct cx20442_priv {
 	enum snd_soc_control_type control_type;
 	void *control_data;
-	u8 reg_cache[1];
 };
 
 #define CX20442_PM		0x0
diff --git a/sound/soc/codecs/tlv320aic26.c b/sound/soc/codecs/tlv320aic26.c
index 68f0ae47..e2a7608 100644
--- a/sound/soc/codecs/tlv320aic26.c
+++ b/sound/soc/codecs/tlv320aic26.c
@@ -30,7 +30,6 @@ MODULE_LICENSE("GPL");
 struct aic26 {
 	struct spi_device *spi;
 	struct snd_soc_codec codec;
-	u16 reg_cache[AIC26_NUM_REGS];	/* shadow registers */
 	int master;
 	int datfm;
 	int mclk;
@@ -354,7 +353,6 @@ static DEVICE_ATTR(keyclick, 0644, aic26_keyclick_show, aic26_keyclick_set);
  */
 static int aic26_probe(struct snd_soc_codec *codec)
 {
-	struct aic26 *aic26 = snd_soc_codec_get_drvdata(codec);
 	int ret, err, i, reg;
 
 	dev_info(codec->dev, "Probing AIC26 SoC CODEC driver\n");
@@ -372,7 +370,7 @@ static int aic26_probe(struct snd_soc_codec *codec)
 	aic26_reg_write(codec, AIC26_REG_AUDIO_CTRL3, reg);
 
 	/* Fill register cache */
-	for (i = 0; i < ARRAY_SIZE(aic26->reg_cache); i++)
+	for (i = 0; i < codec->driver->reg_cache_size; i++)
 		aic26_reg_read(codec, i);
 
 	/* Register the sysfs files for debugging */
diff --git a/sound/soc/codecs/uda1380.c b/sound/soc/codecs/uda1380.c
index 800980e..c5ca8cf 100644
--- a/sound/soc/codecs/uda1380.c
+++ b/sound/soc/codecs/uda1380.c
@@ -35,7 +35,6 @@
 /* codec private data */
 struct uda1380_priv {
 	struct snd_soc_codec *codec;
-	u16 reg_cache[UDA1380_CACHEREGNUM];
 	unsigned int dac_clk;
 	struct work_struct work;
 	void *control_data;
diff --git a/sound/soc/codecs/wm8580.c b/sound/soc/codecs/wm8580.c
index 0ebdecf..8f6b5ee 100644
--- a/sound/soc/codecs/wm8580.c
+++ b/sound/soc/codecs/wm8580.c
@@ -190,7 +190,6 @@ static const char *wm8580_supply_names[WM8580_NUM_SUPPLIES] = {
 struct wm8580_priv {
 	enum snd_soc_control_type control_type;
 	struct regulator_bulk_data supplies[WM8580_NUM_SUPPLIES];
-	u16 reg_cache[WM8580_MAX_REGISTER + 1];
 	struct pll_state a;
 	struct pll_state b;
 	int sysclk[2];
diff --git a/sound/soc/codecs/wm8711.c b/sound/soc/codecs/wm8711.c
index fec37eb..97c3038 100644
--- a/sound/soc/codecs/wm8711.c
+++ b/sound/soc/codecs/wm8711.c
@@ -33,7 +33,6 @@
 /* codec private data */
 struct wm8711_priv {
 	enum snd_soc_control_type bus_type;
-	u16 reg_cache[WM8711_CACHEREGNUM];
 	unsigned int sysclk;
 };
 
diff --git a/sound/soc/codecs/wm8731.c b/sound/soc/codecs/wm8731.c
index 71122dc..0a67c31 100644
--- a/sound/soc/codecs/wm8731.c
+++ b/sound/soc/codecs/wm8731.c
@@ -43,7 +43,6 @@ static const char *wm8731_supply_names[WM8731_NUM_SUPPLIES] = {
 struct wm8731_priv {
 	enum snd_soc_control_type control_type;
 	struct regulator_bulk_data supplies[WM8731_NUM_SUPPLIES];
-	u16 reg_cache[WM8731_CACHEREGNUM];
 	unsigned int sysclk;
 	int sysclk_type;
 	int playback_fs;
diff --git a/sound/soc/codecs/wm8750.c b/sound/soc/codecs/wm8750.c
index 51280e9..38f38fd 100644
--- a/sound/soc/codecs/wm8750.c
+++ b/sound/soc/codecs/wm8750.c
@@ -52,7 +52,6 @@ static const u16 wm8750_reg[] = {
 struct wm8750_priv {
 	unsigned int sysclk;
 	enum snd_soc_control_type control_type;
-	u16 reg_cache[ARRAY_SIZE(wm8750_reg)];
 };
 
 #define wm8750_reset(c)	snd_soc_write(c, WM8750_RESET, 0)
diff --git a/sound/soc/codecs/wm8900.c b/sound/soc/codecs/wm8900.c
index cfbaac1..cd09599 100644
--- a/sound/soc/codecs/wm8900.c
+++ b/sound/soc/codecs/wm8900.c
@@ -139,7 +139,6 @@
 
 struct wm8900_priv {
 	enum snd_soc_control_type control_type;
-	u16 reg_cache[WM8900_MAXREG];
 
 	u32 fll_in; /* FLL input frequency */
 	u32 fll_out; /* FLL output frequency */
diff --git a/sound/soc/codecs/wm8903.c b/sound/soc/codecs/wm8903.c
index 02de5ae..6ad6932 100644
--- a/sound/soc/codecs/wm8903.c
+++ b/sound/soc/codecs/wm8903.c
@@ -214,8 +214,6 @@ static u16 wm8903_reg_defaults[] = {
 
 struct wm8903_priv {
 
-	u16 reg_cache[ARRAY_SIZE(wm8903_reg_defaults)];
-
 	int sysclk;
 	int irq;
 
diff --git a/sound/soc/codecs/wm8940.c b/sound/soc/codecs/wm8940.c
index 381934f..fc7761f 100644
--- a/sound/soc/codecs/wm8940.c
+++ b/sound/soc/codecs/wm8940.c
@@ -42,7 +42,6 @@
 
 struct wm8940_priv {
 	unsigned int sysclk;
-	u16 reg_cache[WM8940_CACHEREGNUM];
 	enum snd_soc_control_type control_type;
 	void *control_data;
 };
diff --git a/sound/soc/codecs/wm8960.c b/sound/soc/codecs/wm8960.c
index 054f573..2bb8561 100644
--- a/sound/soc/codecs/wm8960.c
+++ b/sound/soc/codecs/wm8960.c
@@ -71,7 +71,6 @@ static const u16 wm8960_reg[WM8960_CACHEREGNUM] = {
 };
 
 struct wm8960_priv {
-	u16 reg_cache[WM8960_CACHEREGNUM];
 	enum snd_soc_control_type control_type;
 	void *control_data;
 	int (*set_bias_level)(struct snd_soc_codec *,
diff --git a/sound/soc/codecs/wm8961.c b/sound/soc/codecs/wm8961.c
index 6b22ef2..55252e7 100644
--- a/sound/soc/codecs/wm8961.c
+++ b/sound/soc/codecs/wm8961.c
@@ -289,7 +289,6 @@ static u16 wm8961_reg_defaults[] = {
 struct wm8961_priv {
 	enum snd_soc_control_type control_type;
 	int sysclk;
-	u16 reg_cache[WM8961_MAX_REGISTER];
 };
 
 static int wm8961_volatile_register(unsigned int reg)
diff --git a/sound/soc/codecs/wm8974.c b/sound/soc/codecs/wm8974.c
index 5d28642..ca646a8 100644
--- a/sound/soc/codecs/wm8974.c
+++ b/sound/soc/codecs/wm8974.c
@@ -51,7 +51,6 @@ static const u16 wm8974_reg[WM8974_CACHEREGNUM] = {
 
 struct wm8974_priv {
 	enum snd_soc_control_type control_type;
-	u16 reg_cache[WM8974_CACHEREGNUM];
 };
 
 #define wm8974_reset(c)	snd_soc_write(c, WM8974_RESET, 0)
diff --git a/sound/soc/codecs/wm8978.c b/sound/soc/codecs/wm8978.c
index a195af9..4bbc344 100644
--- a/sound/soc/codecs/wm8978.c
+++ b/sound/soc/codecs/wm8978.c
@@ -59,7 +59,6 @@ struct wm8978_priv {
 	unsigned int f_opclk;
 	int mclk_idx;
 	enum wm8978_sysclk_src sysclk;
-	u16 reg_cache[WM8978_CACHEREGNUM];
 };
 
 static const char *wm8978_companding[] = {"Off", "NC", "u-law", "A-law"};
diff --git a/sound/soc/codecs/wm8988.c b/sound/soc/codecs/wm8988.c
index 65807b1..d7170f1 100644
--- a/sound/soc/codecs/wm8988.c
+++ b/sound/soc/codecs/wm8988.c
@@ -53,7 +53,6 @@ struct wm8988_priv {
 	unsigned int sysclk;
 	enum snd_soc_control_type control_type;
 	struct snd_pcm_hw_constraint_list *sysclk_constraints;
-	u16 reg_cache[WM8988_NUM_REG];
 };
 
 
diff --git a/sound/soc/codecs/wm8993.c b/sound/soc/codecs/wm8993.c
index 15f34a2..18c0d9c 100644
--- a/sound/soc/codecs/wm8993.c
+++ b/sound/soc/codecs/wm8993.c
@@ -225,7 +225,6 @@ static struct {
 
 struct wm8993_priv {
 	struct wm_hubs_data hubs_data;
-	u16 reg_cache[WM8993_REGISTER_COUNT];
 	struct regulator_bulk_data supplies[WM8993_NUM_SUPPLIES];
 	struct wm8993_platform_data pdata;
 	enum snd_soc_control_type control_type;
diff --git a/sound/soc/codecs/wm9081.c b/sound/soc/codecs/wm9081.c
index e5055b2..702db69 100644
--- a/sound/soc/codecs/wm9081.c
+++ b/sound/soc/codecs/wm9081.c
@@ -157,7 +157,6 @@ static struct {
 struct wm9081_priv {
 	enum snd_soc_control_type control_type;
 	void *control_data;
-	u16 reg_cache[WM9081_MAX_REGISTER + 1];
 	int sysclk_source;
 	int mclk_rate;
 	int sysclk_rate;
-- 
1.7.2.3

