Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932075Ab1JCMRe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 08:17:34 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42054 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755588Ab1JCMR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 08:17:28 -0400
Subject: [PATCH] ASoC: Remove needless  codec->dapm.bias_level assignment
 to SND_SOC_BIAS_OFF
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Vinod Koul <vinod.koul@linux.intel.com>,
        Harsha Priya <priya.harsha@intel.com>, alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 03 Oct 2011 20:17:16 +0800
Message-ID: <1317644236.2724.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This assignment is done by the snd_soc_register_codec so there is no need
to redo it in probe function of a codec driver.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/sn95031.c |    1 -
 sound/soc/codecs/wm5100.c  |    2 --
 sound/soc/codecs/wm8996.c  |    1 -
 3 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/sn95031.c b/sound/soc/codecs/sn95031.c
index adb85bf..09c4593 100644
--- a/sound/soc/codecs/sn95031.c
+++ b/sound/soc/codecs/sn95031.c
@@ -827,7 +827,6 @@ static int sn95031_codec_probe(struct snd_soc_codec *codec)
 {
 	pr_debug("codec_probe called\n");
 
-	codec->dapm.bias_level = SND_SOC_BIAS_OFF;
 	codec->dapm.idle_bias_off = 1;
 
 	/* PCM interface config
diff --git a/sound/soc/codecs/wm5100.c b/sound/soc/codecs/wm5100.c
index f603989..46afdf86 100644
--- a/sound/soc/codecs/wm5100.c
+++ b/sound/soc/codecs/wm5100.c
@@ -2285,8 +2285,6 @@ static int wm5100_probe(struct snd_soc_codec *codec)
 
 	wm5100->codec = codec;
 
-	codec->dapm.bias_level = SND_SOC_BIAS_OFF;
-
 	ret = snd_soc_codec_set_cache_io(codec, 16, 16, SND_SOC_I2C);
 	if (ret != 0) {
 		dev_err(codec->dev, "Failed to set cache I/O: %d\n", ret);
diff --git a/sound/soc/codecs/wm8996.c b/sound/soc/codecs/wm8996.c
index b98a8f8..43e46c7 100644
--- a/sound/soc/codecs/wm8996.c
+++ b/sound/soc/codecs/wm8996.c
@@ -2706,7 +2706,6 @@ static int wm8996_probe(struct snd_soc_codec *codec)
 	init_completion(&wm8996->fll_lock);
 
 	dapm->idle_bias_off = true;
-	dapm->bias_level = SND_SOC_BIAS_OFF;
 
 	ret = snd_soc_codec_set_cache_io(codec, 16, 16, SND_SOC_I2C);
 	if (ret != 0) {
-- 
1.7.4.1



