Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542Ab2KGMih (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 07:38:37 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:44589 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab2KGMig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 07:38:36 -0500
MIME-Version: 1.0
Date: Wed, 7 Nov 2012 20:38:35 +0800
Message-ID: <CAPgLHd_GJMWGiMbJp=Jd9cevekJm_LpAXuCT_QADbQXqoBoa0w@mail.gmail.com>
Subject: [PATCH -next] ASoC: cs42l52: fix the return value of cs42l52_set_fmt()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: lrg@ti.com, broonie@opensource.wolfsonmicro.com, perex@perex.cz,
        tiwai@suse.de
Cc: yongjun_wei@trendmicro.com.cn, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix the return value of cs42l52_set_fmt() when clock inversion is
not allowed and also remove the useless variable ret.

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 sound/soc/codecs/cs42l52.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/sound/soc/codecs/cs42l52.c b/sound/soc/codecs/cs42l52.c
index 4d8db36..97a8105 100644
--- a/sound/soc/codecs/cs42l52.c
+++ b/sound/soc/codecs/cs42l52.c
@@ -773,7 +773,6 @@ static int cs42l52_set_fmt(struct snd_soc_dai *codec_dai, unsigned int fmt)
 {
 	struct snd_soc_codec *codec = codec_dai->codec;
 	struct cs42l52_private *cs42l52 = snd_soc_codec_get_drvdata(codec);
-	int ret = 0;
 	u8 iface = 0;
 
 	switch (fmt & SND_SOC_DAIFMT_MASTER_MASK) {
@@ -822,7 +821,7 @@ static int cs42l52_set_fmt(struct snd_soc_dai *codec_dai, unsigned int fmt)
 	case SND_SOC_DAIFMT_NB_IF:
 		break;
 	default:
-		ret = -EINVAL;
+		return -EINVAL;
 	}
 	cs42l52->config.format = iface;
 	snd_soc_write(codec, CS42L52_IFACE_CTL1, cs42l52->config.format);


