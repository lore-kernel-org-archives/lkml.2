Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270Ab1K1Q1P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 11:27:15 -0500
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:28555
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751823Ab1K1Q1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 11:27:14 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzzz2dh87h2a8h668h839h)
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-FB-SS: 13,
X-FB-DOMAIN-IP-MATCH: fail
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
CC: <linux-kernel@vger.kernel.org>, <alsa-devel@alsa-project.org>,
        <drivers@analog.com>, <device-drivers-devel@blackfin.uclinux.org>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 1/7] ASoC: ad193X: Use table based DAPM and controls setup
Date: Mon, 28 Nov 2011 17:28:06 +0100
Message-ID: <1322497692-27868-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.7.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 sound/soc/codecs/ad193x.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/sound/soc/codecs/ad193x.c b/sound/soc/codecs/ad193x.c
index 1901cd2..1dfda5c 100644
--- a/sound/soc/codecs/ad193x.c
+++ b/sound/soc/codecs/ad193x.c
@@ -345,7 +345,6 @@ static struct snd_soc_dai_driver ad193x_dai = {
 static int ad193x_probe(struct snd_soc_codec *codec)
 {
 	struct ad193x_priv *ad193x = snd_soc_codec_get_drvdata(codec);
-	struct snd_soc_dapm_context *dapm = &codec->dapm;
 	int ret;
 
 	codec->control_data = ad193x->regmap;
@@ -371,17 +370,17 @@ static int ad193x_probe(struct snd_soc_codec *codec)
 	snd_soc_write(codec, AD193X_PLL_CLK_CTRL0, 0x99); /* mclk=24.576Mhz: 0x9D; mclk=12.288Mhz: 0x99 */
 	snd_soc_write(codec, AD193X_PLL_CLK_CTRL1, 0x04);
 
-	snd_soc_add_controls(codec, ad193x_snd_controls,
-			     ARRAY_SIZE(ad193x_snd_controls));
-	snd_soc_dapm_new_controls(dapm, ad193x_dapm_widgets,
-				  ARRAY_SIZE(ad193x_dapm_widgets));
-	snd_soc_dapm_add_routes(dapm, audio_paths, ARRAY_SIZE(audio_paths));
-
 	return ret;
 }
 
 static struct snd_soc_codec_driver soc_codec_dev_ad193x = {
 	.probe = 	ad193x_probe,
+	.controls = ad193x_snd_controls,
+	.num_controls = ARRAY_SIZE(ad193x_snd_controls),
+	.dapm_widgets = ad193x_dapm_widgets,
+	.num_dapm_widgets = ARRAY_SIZE(ad193x_dapm_widgets),
+	.dapm_routes = audio_paths,
+	.num_dapm_routes = ARRAY_SIZE(audio_paths),
 };
 
 #if defined(CONFIG_SPI_MASTER)
-- 
1.7.7.3


