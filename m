Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933835Ab1JDXQF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 19:16:05 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35257 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933299Ab1JDXQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 19:16:04 -0400
Subject: [PATCH] ASoC: Remove impossible case from wm8994_hw_params
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 Oct 2011 07:15:51 +0800
Message-ID: <1317770151.2547.2.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We set hw_params callback for wm8994_aif3_dai_ops to wm8994_aif3_hw_params.
Thus no need to check wm8994-aif3 in wm8994_hw_params.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/wm8994.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/sound/soc/codecs/wm8994.c b/sound/soc/codecs/wm8994.c
index d5b69c0..94a8db2 100644
--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -2210,7 +2210,6 @@ static int wm8994_hw_params(struct snd_pcm_substream *substream,
 			    struct snd_soc_dai *dai)
 {
 	struct snd_soc_codec *codec = dai->codec;
-	struct wm8994 *control = codec->control_data;
 	struct wm8994_priv *wm8994 = snd_soc_codec_get_drvdata(codec);
 	int aif1_reg;
 	int aif2_reg;
@@ -2253,14 +2252,6 @@ static int wm8994_hw_params(struct snd_pcm_substream *substream,
 			dev_dbg(codec->dev, "AIF2 using split LRCLK\n");
 		}
 		break;
-	case 3:
-		switch (control->type) {
-		case WM8958:
-			aif1_reg = WM8958_AIF3_CONTROL_1;
-			break;
-		default:
-			return 0;
-		}
 	default:
 		return -EINVAL;
 	}
-- 
1.7.4.1



