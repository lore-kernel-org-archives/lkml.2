Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019Ab1FUOkP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 10:40:15 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:48279 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753945Ab1FUOkK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 10:40:10 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-input@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: [PATCH v6 13/18] ASoC: twl6040: add all ABE DAIs
Date: Tue, 21 Jun 2011 16:39:11 +0300
Message-ID: <1308663556-29120-14-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.5.3
In-Reply-To: <1308663556-29120-1-git-send-email-peter.ujfalusi@ti.com>
References: <1308663556-29120-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liam Girdwood <lrg@ti.com>

Add all DAIs to fully support OMAP4 ABE.

Signed-off-by: Liam Girdwood <lrg@ti.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 sound/soc/codecs/twl6040.c |   44 ++++++++++++++++++++++++++++++++++++--------
 1 files changed, 36 insertions(+), 8 deletions(-)

diff --git a/sound/soc/codecs/twl6040.c b/sound/soc/codecs/twl6040.c
index a20e293..28dc5d9 100644
--- a/sound/soc/codecs/twl6040.c
+++ b/sound/soc/codecs/twl6040.c
@@ -1359,23 +1359,51 @@ static struct snd_soc_dai_ops twl6040_dai_ops = {
 	.set_sysclk	= twl6040_set_dai_sysclk,
 };
 
-static struct snd_soc_dai_driver twl6040_dai = {
-	.name = "twl6040-hifi",
+static struct snd_soc_dai_driver twl6040_dai[] = {
+{
+	.name = "twl6040-ul",
+	.capture = {
+		.stream_name = "Capture",
+		.channels_min = 1,
+		.channels_max = 2,
+		.rates = TWL6040_RATES,
+		.formats = TWL6040_FORMATS,
+	},
+	.ops = &twl6040_dai_ops,
+},
+{
+	.name = "twl6040-dl1",
 	.playback = {
-		.stream_name = "Playback",
+		.stream_name = "Headset Playback",
 		.channels_min = 1,
-		.channels_max = 4,
+		.channels_max = 2,
 		.rates = TWL6040_RATES,
 		.formats = TWL6040_FORMATS,
 	},
-	.capture = {
-		.stream_name = "Capture",
+	.ops = &twl6040_dai_ops,
+},
+{
+	.name = "twl6040-dl2",
+	.playback = {
+		.stream_name = "Handsfree Playback",
 		.channels_min = 1,
 		.channels_max = 2,
 		.rates = TWL6040_RATES,
 		.formats = TWL6040_FORMATS,
 	},
 	.ops = &twl6040_dai_ops,
+},
+{
+	.name = "twl6040-vib",
+	.playback = {
+		.stream_name = "Vibra Playback",
+		.channels_min = 2,
+		.channels_max = 2,
+		.rates = SNDRV_PCM_RATE_CONTINUOUS,
+		.formats = TWL6040_FORMATS,
+	},
+	.ops = &twl6040_dai_ops,
+},
 };
 
 #ifdef CONFIG_PM
@@ -1502,8 +1530,8 @@ static struct snd_soc_codec_driver soc_codec_dev_twl6040 = {
 
 static int __devinit twl6040_codec_probe(struct platform_device *pdev)
 {
-	return snd_soc_register_codec(&pdev->dev,
-			&soc_codec_dev_twl6040, &twl6040_dai, 1);
+	return snd_soc_register_codec(&pdev->dev, &soc_codec_dev_twl6040,
+				      twl6040_dai, ARRAY_SIZE(twl6040_dai));
 }
 
 static int __devexit twl6040_codec_remove(struct platform_device *pdev)
-- 
1.7.5.3

