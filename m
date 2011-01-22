Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639Ab1AVWi1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 17:38:27 -0500
Received: from smtp-out-005.synserver.de ([212.40.180.5]:1060 "HELO
	smtp-out-002.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1751089Ab1AVWi0 (ORCPT
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
Subject: [PATCH] SoC: Samsung: Fix outdated cpu_dai_name for s3c24xx i2s
Date: Sat, 22 Jan 2011 23:38:08 +0100
Message-Id: <1295735888-25527-2-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1295735888-25527-1-git-send-email-lars@metafoo.de>
References: <1295735888-25527-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During the multi-component patch the s3c24xx i2s driver was renamed from
"s3c24xx-i2s" to "s3c24xx-iis", while the sound board drivers were not
updated to reflect this change as well.

As a result there is no match between the dai_link and the i2s driver and no
sound card is instantiated.

This patch fixes the problem by updating the sound board drivers to use
"s3c24xx-iis" for the cpu_dai_name.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Cc: stable@kernel.org (for 2.6.37)
---
 sound/soc/samsung/neo1973_gta02_wm8753.c       |    2 +-
 sound/soc/samsung/neo1973_wm8753.c             |    2 +-
 sound/soc/samsung/s3c24xx_simtec_hermes.c      |    2 +-
 sound/soc/samsung/s3c24xx_simtec_tlv320aic23.c |    2 +-
 sound/soc/samsung/s3c24xx_uda134x.c            |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/sound/soc/samsung/neo1973_gta02_wm8753.c b/sound/soc/samsung/neo1973_gta02_wm8753.c
index 5e77cd1..95ebf81 100644
--- a/sound/soc/samsung/neo1973_gta02_wm8753.c
+++ b/sound/soc/samsung/neo1973_gta02_wm8753.c
@@ -387,7 +387,7 @@ static struct snd_soc_dai_link neo1973_gta02_dai[] = {
 { /* Hifi Playback - for similatious use with voice below */
 	.name = "WM8753",
 	.stream_name = "WM8753 HiFi",
-	.cpu_dai_name = "s3c24xx-i2s",
+	.cpu_dai_name = "s3c24xx-iis",
 	.codec_dai_name = "wm8753-hifi",
 	.init = neo1973_gta02_wm8753_init,
 	.platform_name = "samsung-audio",
diff --git a/sound/soc/samsung/neo1973_wm8753.c b/sound/soc/samsung/neo1973_wm8753.c
index cf69e14..d20815d 100644
--- a/sound/soc/samsung/neo1973_wm8753.c
+++ b/sound/soc/samsung/neo1973_wm8753.c
@@ -559,7 +559,7 @@ static struct snd_soc_dai_link neo1973_dai[] = {
 	.name = "WM8753",
 	.stream_name = "WM8753 HiFi",
 	.platform_name = "samsung-audio",
-	.cpu_dai_name = "s3c24xx-i2s",
+	.cpu_dai_name = "s3c24xx-iis",
 	.codec_dai_name = "wm8753-hifi",
 	.codec_name = "wm8753-codec.0-001a",
 	.init = neo1973_wm8753_init,
diff --git a/sound/soc/samsung/s3c24xx_simtec_hermes.c b/sound/soc/samsung/s3c24xx_simtec_hermes.c
index 2fa6d1b..ce6aef6 100644
--- a/sound/soc/samsung/s3c24xx_simtec_hermes.c
+++ b/sound/soc/samsung/s3c24xx_simtec_hermes.c
@@ -85,7 +85,7 @@ static struct snd_soc_dai_link simtec_dai_aic33 = {
 	.name		= "tlv320aic33",
 	.stream_name	= "TLV320AIC33",
 	.codec_name	= "tlv320aic3x-codec.0-001a",
-	.cpu_dai_name	= "s3c24xx-i2s",
+	.cpu_dai_name	= "s3c24xx-iis",
 	.codec_dai_name = "tlv320aic3x-hifi",
 	.platform_name	= "samsung-audio",
 	.init		= simtec_hermes_init,
diff --git a/sound/soc/samsung/s3c24xx_simtec_tlv320aic23.c b/sound/soc/samsung/s3c24xx_simtec_tlv320aic23.c
index d219223..a7ef7db 100644
--- a/sound/soc/samsung/s3c24xx_simtec_tlv320aic23.c
+++ b/sound/soc/samsung/s3c24xx_simtec_tlv320aic23.c
@@ -74,7 +74,7 @@ static struct snd_soc_dai_link simtec_dai_aic23 = {
 	.name		= "tlv320aic23",
 	.stream_name	= "TLV320AIC23",
 	.codec_name	= "tlv320aic3x-codec.0-001a",
-	.cpu_dai_name	= "s3c24xx-i2s",
+	.cpu_dai_name	= "s3c24xx-iis",
 	.codec_dai_name = "tlv320aic3x-hifi",
 	.platform_name	= "samsung-audio",
 	.init		= simtec_tlv320aic23_init,
diff --git a/sound/soc/samsung/s3c24xx_uda134x.c b/sound/soc/samsung/s3c24xx_uda134x.c
index ce749a1..3cb7007 100644
--- a/sound/soc/samsung/s3c24xx_uda134x.c
+++ b/sound/soc/samsung/s3c24xx_uda134x.c
@@ -221,7 +221,7 @@ static struct snd_soc_dai_link s3c24xx_uda134x_dai_link = {
 	.stream_name = "UDA134X",
 	.codec_name = "uda134x-hifi",
 	.codec_dai_name = "uda134x-hifi",
-	.cpu_dai_name = "s3c24xx-i2s",
+	.cpu_dai_name = "s3c24xx-iis",
 	.ops = &s3c24xx_uda134x_ops,
 	.platform_name	= "samsung-audio",
 };
-- 
1.7.2.3

