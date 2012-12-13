Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932386Ab2LMOwv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:52:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44340 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756507Ab2LMOFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:05:42 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 080/241] ASoC: cs42l52: fix the return value of cs42l52_set_fmt()
Date: Thu, 13 Dec 2012 11:57:25 -0200
Message-Id: <1355407206-17100-81-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

commit 5c855c8e2be67f2d5a989ef1190098f924f9f820 upstream.

Fix the return value of cs42l52_set_fmt() when clock inversion is
not allowed and also remove the useless variable ret.

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

[We had been assigning to ret but then ignoring the value we assgined
-- broonie]

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 sound/soc/codecs/cs42l52.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/sound/soc/codecs/cs42l52.c b/sound/soc/codecs/cs42l52.c
index a710941..a3b2631 100644
--- a/sound/soc/codecs/cs42l52.c
+++ b/sound/soc/codecs/cs42l52.c
@@ -775,7 +775,6 @@ static int cs42l52_set_fmt(struct snd_soc_dai *codec_dai, unsigned int fmt)
 {
 	struct snd_soc_codec *codec = codec_dai->codec;
 	struct cs42l52_private *cs42l52 = snd_soc_codec_get_drvdata(codec);
-	int ret = 0;
 	u8 iface = 0;
 
 	switch (fmt & SND_SOC_DAIFMT_MASTER_MASK) {
@@ -824,7 +823,7 @@ static int cs42l52_set_fmt(struct snd_soc_dai *codec_dai, unsigned int fmt)
 	case SND_SOC_DAIFMT_NB_IF:
 		break;
 	default:
-		ret = -EINVAL;
+		return -EINVAL;
 	}
 	cs42l52->config.format = iface;
 	snd_soc_write(codec, CS42L52_IFACE_CTL1, cs42l52->config.format);
-- 
1.7.9.5

