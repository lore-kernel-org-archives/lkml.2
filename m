Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935567Ab1JEXaK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 19:30:10 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:45424 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935485Ab1JEXaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 19:30:09 -0400
Subject: [PATCH v2] ASoC: Return early with -EINVAL if invalid dai format
 is detected
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Timur Tabi <timur@freescale.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 06 Oct 2011 07:29:56 +0800
Message-ID: <1317857396.6291.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Timur Tabi <timur@freescale.com>
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>
---
 sound/soc/codecs/cs4270.c  |    8 ++++----
 sound/soc/codecs/cs42l51.c |    9 ++++-----
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/sound/soc/codecs/cs4270.c b/sound/soc/codecs/cs4270.c
index 5830c93..f1f237e 100644
--- a/sound/soc/codecs/cs4270.c
+++ b/sound/soc/codecs/cs4270.c
@@ -261,7 +261,6 @@ static int cs4270_set_dai_fmt(struct snd_soc_dai *codec_dai,
 {
 	struct snd_soc_codec *codec = codec_dai->codec;
 	struct cs4270_private *cs4270 = snd_soc_codec_get_drvdata(codec);
-	int ret = 0;
 
 	/* set DAI format */
 	switch (format & SND_SOC_DAIFMT_FORMAT_MASK) {
@@ -271,7 +270,7 @@ static int cs4270_set_dai_fmt(struct snd_soc_dai *codec_dai,
 		break;
 	default:
 		dev_err(codec->dev, "invalid dai format\n");
-		ret = -EINVAL;
+		return -EINVAL;
 	}
 
 	/* set master/slave audio interface */
@@ -284,10 +283,11 @@ static int cs4270_set_dai_fmt(struct snd_soc_dai *codec_dai,
 		break;
 	default:
 		/* all other modes are unsupported by the hardware */
-		ret = -EINVAL;
+		dev_err(codec->dev, "Unknown master/slave configuration\n");
+		return -EINVAL;
 	}
 
-	return ret;
+	return 0;
 }
 
 /**
diff --git a/sound/soc/codecs/cs42l51.c b/sound/soc/codecs/cs42l51.c
index 286878d..8c3c820 100644
--- a/sound/soc/codecs/cs42l51.c
+++ b/sound/soc/codecs/cs42l51.c
@@ -288,7 +288,6 @@ static int cs42l51_set_dai_fmt(struct snd_soc_dai *codec_dai,
 {
 	struct snd_soc_codec *codec = codec_dai->codec;
 	struct cs42l51_private *cs42l51 = snd_soc_codec_get_drvdata(codec);
-	int ret = 0;
 
 	switch (format & SND_SOC_DAIFMT_FORMAT_MASK) {
 	case SND_SOC_DAIFMT_I2S:
@@ -298,7 +297,7 @@ static int cs42l51_set_dai_fmt(struct snd_soc_dai *codec_dai,
 		break;
 	default:
 		dev_err(codec->dev, "invalid DAI format\n");
-		ret = -EINVAL;
+		return -EINVAL;
 	}
 
 	switch (format & SND_SOC_DAIFMT_MASTER_MASK) {
@@ -309,11 +308,11 @@ static int cs42l51_set_dai_fmt(struct snd_soc_dai *codec_dai,
 		cs42l51->func = MODE_SLAVE_AUTO;
 		break;
 	default:
-		ret = -EINVAL;
-		break;
+		dev_err(codec->dev, "Unknown master/slave configuration\n");
+		return -EINVAL;
 	}
 
-	return ret;
+	return 0;
 }
 
 struct cs42l51_ratios {
-- 
1.7.4.1



