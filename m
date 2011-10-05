Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935575Ab1JEXkJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 19:40:09 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64935 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934986Ab1JEXkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 19:40:07 -0400
Subject: [PATCH RESEND] ASoC: Remove impossible case from wm8994_hw_params
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 06 Oct 2011 07:39:59 +0800
Message-ID: <1317857999.6291.3.camel@phoenix>
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
 sound/soc/codecs/wm8994.c |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/sound/soc/codecs/wm8994.c b/sound/soc/codecs/wm8994.c
index 16542de..68e769e 100644
--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -2235,7 +2235,6 @@ static int wm8994_hw_params(struct snd_pcm_substream *substream,
 			    struct snd_soc_dai *dai)
 {
 	struct snd_soc_codec *codec = dai->codec;
-	struct wm8994 *control = codec->control_data;
 	struct wm8994_priv *wm8994 = snd_soc_codec_get_drvdata(codec);
 	int aif1_reg;
 	int aif2_reg;
@@ -2278,15 +2277,6 @@ static int wm8994_hw_params(struct snd_pcm_substream *substream,
 			dev_dbg(codec->dev, "AIF2 using split LRCLK\n");
 		}
 		break;
-	case 3:
-		switch (control->type) {
-		case WM1811:
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



