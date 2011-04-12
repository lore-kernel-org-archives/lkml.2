Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932207Ab1DLRjf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 13:39:35 -0400
Received: from smtp-out-051.synserver.de ([212.40.185.51]:1060 "HELO
	smtp-out-049.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1756136Ab1DLRje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 13:39:34 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 7621
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 2/2] ASoC: codecs: JZ4740: Convert to table based controls and DAPM setup
Date: Tue, 12 Apr 2011 19:33:29 +0200
Message-Id: <1302629609-21537-2-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1302629609-21537-1-git-send-email-lars@metafoo.de>
References: <1302629609-21537-1-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the newly introduced dapm_widgets, dpam_routes and controls fields of the
snd_soc_dai_driver struct to setup controls and DAPM.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 sound/soc/codecs/jz4740.c |   18 +++++++-----------
 1 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/sound/soc/codecs/jz4740.c b/sound/soc/codecs/jz4740.c
index f5ccdbf7..e373f8f 100644
--- a/sound/soc/codecs/jz4740.c
+++ b/sound/soc/codecs/jz4740.c
@@ -294,20 +294,9 @@ static int jz4740_codec_set_bias_level(struct snd_soc_codec *codec,
 
 static int jz4740_codec_dev_probe(struct snd_soc_codec *codec)
 {
-	struct snd_soc_dapm_context *dapm = &codec->dapm;
-
 	snd_soc_update_bits(codec, JZ4740_REG_CODEC_1,
 			JZ4740_CODEC_1_SW2_ENABLE, JZ4740_CODEC_1_SW2_ENABLE);
 
-	snd_soc_add_controls(codec, jz4740_codec_controls,
-		ARRAY_SIZE(jz4740_codec_controls));
-
-	snd_soc_dapm_new_controls(dapm, jz4740_codec_dapm_widgets,
-		ARRAY_SIZE(jz4740_codec_dapm_widgets));
-
-	snd_soc_dapm_add_routes(dapm, jz4740_codec_dapm_routes,
-		ARRAY_SIZE(jz4740_codec_dapm_routes));
-
 	jz4740_codec_set_bias_level(codec, SND_SOC_BIAS_STANDBY);
 
 	return 0;
@@ -348,6 +337,13 @@ static struct snd_soc_codec_driver soc_codec_dev_jz4740_codec = {
 	.reg_cache_default	= jz4740_codec_regs,
 	.reg_word_size = sizeof(u32),
 	.reg_cache_size	= 2,
+
+	.controls = jz4740_codec_controls,
+	.num_controls = ARRAY_SIZE(jz4740_codec_controls),
+	.dapm_widgets = jz4740_codec_dapm_widgets,
+	.num_dapm_widgets = ARRAY_SIZE(jz4740_codec_dapm_widgets),
+	.dapm_routes = jz4740_codec_dapm_routes,
+	.num_dapm_routes = ARRAY_SIZE(jz4740_codec_dapm_routes),
 };
 
 static int __devinit jz4740_codec_probe(struct platform_device *pdev)
-- 
1.7.2.5

