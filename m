Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877Ab1AXVJq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 16:09:46 -0500
Received: from smtp-out-035.synserver.de ([212.40.180.35]:1056 "EHLO
	smtp-out-035.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206Ab1AXVJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 16:09:45 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 1805
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 1/2 v2] ASoC: Fix codec device id format used by some dai_links
Date: Mon, 24 Jan 2011 22:09:22 +0100
Message-Id: <1295903363-4433-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The id part of an I2C device name is created with the "%d-%04x" format string.

So for example for an I2C device which is connected to the adapter with the id 0
and has its address set to 0x1a the id part of the devices name would be
"0-001a".

Currently some sound board drivers have the id part the codec_name field of
their dai_link structures set as if it had been created by a "%d-0x%x" format
string. For example "0-0x1a" instead of "0-001a".

As a result there is no match between the codec device and the dai_link and no
sound card is instantiated.

This patch fixes it.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>

---
This problem has been noted with the neo1993_gta02 sound board driver and has
only been runtime tested for the neo1973 and neo1973_gta02 sound board drivers.
But in theory the problem should be the same for all of the drivers changed by
this patch.

Changes since v1:
* Fix only those drivers where it could be verified(By looking at the mach board
  file) that the codec is connected through an I2C bus.
---
 sound/soc/atmel/snd-soc-afeb9260.c             |    2 +-
 sound/soc/blackfin/bf5xx-ssm2602.c             |    2 +-
 sound/soc/samsung/neo1973_gta02_wm8753.c       |    4 ++--
 sound/soc/samsung/neo1973_wm8753.c             |    4 ++--
 sound/soc/samsung/s3c24xx_simtec_hermes.c      |    2 +-
 sound/soc/samsung/s3c24xx_simtec_tlv320aic23.c |    2 +-
 6 files changed, 8 insertions(+), 8 deletions(-)

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
 
diff --git a/sound/soc/samsung/neo1973_gta02_wm8753.c b/sound/soc/samsung/neo1973_gta02_wm8753.c
index 3eec610..9e05e10 100644
--- a/sound/soc/samsung/neo1973_gta02_wm8753.c
+++ b/sound/soc/samsung/neo1973_gta02_wm8753.c
@@ -401,7 +401,7 @@ static struct snd_soc_dai_link neo1973_gta02_dai[] = {
 	.codec_dai_name = "wm8753-hifi",
 	.init = neo1973_gta02_wm8753_init,
 	.platform_name = "samsung-audio",
-	.codec_name = "wm8753-codec.0-0x1a",
+	.codec_name = "wm8753-codec.0-001a",
 	.ops = &neo1973_gta02_hifi_ops,
 },
 { /* Voice via BT */
@@ -410,7 +410,7 @@ static struct snd_soc_dai_link neo1973_gta02_dai[] = {
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
index bb4292e..287a971 100644
--- a/sound/soc/samsung/s3c24xx_simtec_hermes.c
+++ b/sound/soc/samsung/s3c24xx_simtec_hermes.c
@@ -94,7 +94,7 @@ static int simtec_hermes_init(struct snd_soc_pcm_runtime *rtd)
 static struct snd_soc_dai_link simtec_dai_aic33 = {
 	.name		= "tlv320aic33",
 	.stream_name	= "TLV320AIC33",
-	.codec_name	= "tlv320aic3x-codec.0-0x1a",
+	.codec_name	= "tlv320aic3x-codec.0-001a",
 	.cpu_dai_name	= "s3c24xx-i2s",
 	.codec_dai_name = "tlv320aic3x-hifi",
 	.platform_name	= "samsung-audio",
diff --git a/sound/soc/samsung/s3c24xx_simtec_tlv320aic23.c b/sound/soc/samsung/s3c24xx_simtec_tlv320aic23.c
index fbba4e3..d2b14ba 100644
--- a/sound/soc/samsung/s3c24xx_simtec_tlv320aic23.c
+++ b/sound/soc/samsung/s3c24xx_simtec_tlv320aic23.c
@@ -85,7 +85,7 @@ static int simtec_tlv320aic23_init(struct snd_soc_pcm_runtime *rtd)
 static struct snd_soc_dai_link simtec_dai_aic23 = {
 	.name		= "tlv320aic23",
 	.stream_name	= "TLV320AIC23",
-	.codec_name	= "tlv320aic3x-codec.0-0x1a",
+	.codec_name	= "tlv320aic3x-codec.0-001a",
 	.cpu_dai_name	= "s3c24xx-i2s",
 	.codec_dai_name = "tlv320aic3x-hifi",
 	.platform_name	= "samsung-audio",
-- 
1.7.2.3

