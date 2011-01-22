Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795Ab1AVWi1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 17:38:27 -0500
Received: from smtp-out-005.synserver.de ([212.40.180.5]:1038 "HELO
	smtp-out-002.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1750872Ab1AVWi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 17:38:26 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 19667
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>, stable@kernel.org (for 2.6.37)
Subject: [PATCH] ASoC: Fix codec device id format used by some dai_links
Date: Sat, 22 Jan 2011 23:38:07 +0100
Message-Id: <1295735888-25527-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The id part of a I2C device name is created with the "%d-%04x" format string.

So for example for a I2C device, which is connected to the adapter with the id 0
and has its address set to 0x1a the id part of the devices name would be
"0-001a".

Currently some sound board drivers have the id part the codec_name field of
their dai_link structures set as if it had been created by a "%d-0x%x" format
string. For example "0-0x1a" instead of "0-001a".

As a result there is no match between the codec device and the dai_link and no
sound card is instantiated.

This patch fixes it.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Cc: stable@kernel.org (for 2.6.37)

---
This problem has been noted with the neo1993_gta02 sound board driver and has
only been runtime tested for the neo1973 and neo1973_gta02 sound board drivers,
but in theory the problem should be the same for all of the drivers changed by
this patch.
---
 sound/soc/atmel/playpaq_wm8510.c               |    2 +-
 sound/soc/atmel/snd-soc-afeb9260.c             |    2 +-
 sound/soc/blackfin/bf5xx-ssm2602.c             |    2 +-
 sound/soc/imx/wm1133-ev1.c                     |    2 +-
 sound/soc/samsung/goni_wm8994.c                |    4 ++--
 sound/soc/samsung/jive_wm8750.c                |    2 +-
 sound/soc/samsung/neo1973_gta02_wm8753.c       |    4 ++--
 sound/soc/samsung/neo1973_wm8753.c             |    4 ++--
 sound/soc/samsung/s3c24xx_simtec_hermes.c      |    2 +-
 sound/soc/samsung/s3c24xx_simtec_tlv320aic23.c |    2 +-
 sound/soc/samsung/smartq_wm8987.c              |    2 +-
 11 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/sound/soc/atmel/playpaq_wm8510.c b/sound/soc/atmel/playpaq_wm8510.c
index 1aac2f4..e2b6595 100644
--- a/sound/soc/atmel/playpaq_wm8510.c
+++ b/sound/soc/atmel/playpaq_wm8510.c
@@ -356,7 +356,7 @@ static struct snd_soc_dai_link playpaq_wm8510_dai = {
 	.stream_name = "WM8510 PCM",
 	.cpu_dai_name= "atmel-ssc-dai.0",
 	.platform_name = "atmel-pcm-audio",
-	.codec_name = "wm8510-codec.0-0x1a",
+	.codec_name = "wm8510-codec.0-001a",
 	.codec_dai_name = "wm8510-hifi",
 	.init = playpaq_wm8510_init,
 	.ops = &playpaq_wm8510_ops,
diff --git a/sound/soc/atmel/snd-soc-afeb9260.c b/sound/soc/atmel/snd-soc-afeb9260.c
index da2208e..5e4d499 100644
--- a/sound/soc/atmel/snd-soc-afeb9260.c
+++ b/sound/soc/atmel/snd-soc-afeb9260.c
@@ -129,7 +129,7 @@ static struct snd_soc_dai_link afeb9260_dai = {
 	.cpu_dai_name = "atmel-ssc-dai.0",
 	.codec_dai_name = "tlv320aic23-hifi",
 	.platform_name = "atmel_pcm-audio",
-	.codec_name = "tlv320aic23-codec.0-0x1a",
+	.codec_name = "tlv320aic23-codec.0-001a",
 	.init = afeb9260_tlv320aic23_init,
 	.ops = &afeb9260_ops,
 };
diff --git a/sound/soc/blackfin/bf5xx-ssm2602.c b/sound/soc/blackfin/bf5xx-ssm2602.c
index e902b24..ad28663 100644
--- a/sound/soc/blackfin/bf5xx-ssm2602.c
+++ b/sound/soc/blackfin/bf5xx-ssm2602.c
@@ -119,7 +119,7 @@ static struct snd_soc_dai_link bf5xx_ssm2602_dai = {
 	.cpu_dai_name = "bf5xx-i2s",
 	.codec_dai_name = "ssm2602-hifi",
 	.platform_name = "bf5xx-pcm-audio",
-	.codec_name = "ssm2602-codec.0-0x1b",
+	.codec_name = "ssm2602-codec.0-001b",
 	.ops = &bf5xx_ssm2602_ops,
 };
 
diff --git a/sound/soc/imx/wm1133-ev1.c b/sound/soc/imx/wm1133-ev1.c
index 75b4c72..f507e57 100644
--- a/sound/soc/imx/wm1133-ev1.c
+++ b/sound/soc/imx/wm1133-ev1.c
@@ -246,7 +246,7 @@ static struct snd_soc_dai_link wm1133_ev1_dai = {
 	.cpu_dai_name = "imx-ssi.0",
 	.codec_dai_name = "wm8350-hifi",
 	.platform_name = "imx-fiq-pcm-audio.0",
-	.codec_name = "wm8350-codec.0-0x1a",
+	.codec_name = "wm8350-codec.0-001a",
 	.init = wm1133_ev1_init,
 	.ops = &wm1133_ev1_ops,
 	.symmetric_rates = 1,
diff --git a/sound/soc/samsung/goni_wm8994.c b/sound/soc/samsung/goni_wm8994.c
index f6b3a3c..3a7861c 100644
--- a/sound/soc/samsung/goni_wm8994.c
+++ b/sound/soc/samsung/goni_wm8994.c
@@ -238,7 +238,7 @@ static struct snd_soc_dai_link goni_dai[] = {
 	.cpu_dai_name = "samsung-i2s.0",
 	.codec_dai_name = "wm8994-hifi",
 	.platform_name = "samsung-audio",
-	.codec_name = "wm8994-codec.0-0x1a",
+	.codec_name = "wm8994-codec.0-001a",
 	.init = goni_wm8994_init,
 	.ops = &goni_hifi_ops,
 }, {
@@ -247,7 +247,7 @@ static struct snd_soc_dai_link goni_dai[] = {
 	.cpu_dai_name = "goni-voice-dai",
 	.codec_dai_name = "wm8994-voice",
 	.platform_name = "samsung-audio",
-	.codec_name = "wm8994-codec.0-0x1a",
+	.codec_name = "wm8994-codec.0-001a",
 	.ops = &goni_voice_ops,
 },
 };
diff --git a/sound/soc/samsung/jive_wm8750.c b/sound/soc/samsung/jive_wm8750.c
index 3b53ad5..14eb6ea 100644
--- a/sound/soc/samsung/jive_wm8750.c
+++ b/sound/soc/samsung/jive_wm8750.c
@@ -131,7 +131,7 @@ static struct snd_soc_dai_link jive_dai = {
 	.cpu_dai_name	= "s3c2412-i2s",
 	.codec_dai_name = "wm8750-hifi",
 	.platform_name	= "samsung-audio",
-	.codec_name	= "wm8750-codec.0-0x1a",
+	.codec_name	= "wm8750-codec.0-001a",
 	.init		= jive_wm8750_init,
 	.ops		= &jive_ops,
 };
diff --git a/sound/soc/samsung/neo1973_gta02_wm8753.c b/sound/soc/samsung/neo1973_gta02_wm8753.c
index 69e08fd..5e77cd1 100644
--- a/sound/soc/samsung/neo1973_gta02_wm8753.c
+++ b/sound/soc/samsung/neo1973_gta02_wm8753.c
@@ -391,7 +391,7 @@ static struct snd_soc_dai_link neo1973_gta02_dai[] = {
 	.codec_dai_name = "wm8753-hifi",
 	.init = neo1973_gta02_wm8753_init,
 	.platform_name = "samsung-audio",
-	.codec_name = "wm8753-codec.0-0x1a",
+	.codec_name = "wm8753-codec.0-001a",
 	.ops = &neo1973_gta02_hifi_ops,
 },
 { /* Voice via BT */
@@ -400,7 +400,7 @@ static struct snd_soc_dai_link neo1973_gta02_dai[] = {
 	.cpu_dai_name = "bluetooth-dai",
 	.codec_dai_name = "wm8753-voice",
 	.ops = &neo1973_gta02_voice_ops,
-	.codec_name = "wm8753-codec.0-0x1a",
+	.codec_name = "wm8753-codec.0-001a",
 	.platform_name = "samsung-audio",
 },
 };
diff --git a/sound/soc/samsung/neo1973_wm8753.c b/sound/soc/samsung/neo1973_wm8753.c
index c7a2451..cf69e14 100644
--- a/sound/soc/samsung/neo1973_wm8753.c
+++ b/sound/soc/samsung/neo1973_wm8753.c
@@ -561,7 +561,7 @@ static struct snd_soc_dai_link neo1973_dai[] = {
 	.platform_name = "samsung-audio",
 	.cpu_dai_name = "s3c24xx-i2s",
 	.codec_dai_name = "wm8753-hifi",
-	.codec_name = "wm8753-codec.0-0x1a",
+	.codec_name = "wm8753-codec.0-001a",
 	.init = neo1973_wm8753_init,
 	.ops = &neo1973_hifi_ops,
 },
@@ -571,7 +571,7 @@ static struct snd_soc_dai_link neo1973_dai[] = {
 	.platform_name = "samsung-audio",
 	.cpu_dai_name = "bluetooth-dai",
 	.codec_dai_name = "wm8753-voice",
-	.codec_name = "wm8753-codec.0-0x1a",
+	.codec_name = "wm8753-codec.0-001a",
 	.ops = &neo1973_voice_ops,
 },
 };
diff --git a/sound/soc/samsung/s3c24xx_simtec_hermes.c b/sound/soc/samsung/s3c24xx_simtec_hermes.c
index d7b3e6e..2fa6d1b 100644
--- a/sound/soc/samsung/s3c24xx_simtec_hermes.c
+++ b/sound/soc/samsung/s3c24xx_simtec_hermes.c
@@ -84,7 +84,7 @@ static int simtec_hermes_init(struct snd_soc_pcm_runtime *rtd)
 static struct snd_soc_dai_link simtec_dai_aic33 = {
 	.name		= "tlv320aic33",
 	.stream_name	= "TLV320AIC33",
-	.codec_name	= "tlv320aic3x-codec.0-0x1a",
+	.codec_name	= "tlv320aic3x-codec.0-001a",
 	.cpu_dai_name	= "s3c24xx-i2s",
 	.codec_dai_name = "tlv320aic3x-hifi",
 	.platform_name	= "samsung-audio",
diff --git a/sound/soc/samsung/s3c24xx_simtec_tlv320aic23.c b/sound/soc/samsung/s3c24xx_simtec_tlv320aic23.c
index ff6168f..d219223 100644
--- a/sound/soc/samsung/s3c24xx_simtec_tlv320aic23.c
+++ b/sound/soc/samsung/s3c24xx_simtec_tlv320aic23.c
@@ -73,7 +73,7 @@ static int simtec_tlv320aic23_init(struct snd_soc_pcm_runtime *rtd)
 static struct snd_soc_dai_link simtec_dai_aic23 = {
 	.name		= "tlv320aic23",
 	.stream_name	= "TLV320AIC23",
-	.codec_name	= "tlv320aic3x-codec.0-0x1a",
+	.codec_name	= "tlv320aic3x-codec.0-001a",
 	.cpu_dai_name	= "s3c24xx-i2s",
 	.codec_dai_name = "tlv320aic3x-hifi",
 	.platform_name	= "samsung-audio",
diff --git a/sound/soc/samsung/smartq_wm8987.c b/sound/soc/samsung/smartq_wm8987.c
index 0a2c4f2..d14f939 100644
--- a/sound/soc/samsung/smartq_wm8987.c
+++ b/sound/soc/samsung/smartq_wm8987.c
@@ -207,7 +207,7 @@ static struct snd_soc_dai_link smartq_dai[] = {
 		.cpu_dai_name	= "samsung-i2s.0",
 		.codec_dai_name	= "wm8750-hifi",
 		.platform_name	= "samsung-audio",
-		.codec_name	= "wm8750-codec.0-0x1a",
+		.codec_name	= "wm8750-codec.0-001a",
 		.init		= smartq_wm8987_init,
 		.ops		= &smartq_hifi_ops,
 	},
-- 
1.7.2.3

