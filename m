Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818Ab1JUByz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 21:54:55 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44413 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805Ab1JUByy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 21:54:54 -0400
Message-ID: <1319162083.4352.2.camel@phoenix>
Subject: [PATCH] ASoC: sgtl5000: Fix wrong mask in some snd_soc_update_bits
 calls
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Dong Aisheng <B29396@freescale.com>, Wolfram Sang <w.sang@pengutronix.de>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Date: Fri, 21 Oct 2011 09:54:43 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure all mask bits are clear before setting new value.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
I don't have this hardware, I'd appreciate if someone can test this patch.

Thanks,
Axel
 sound/soc/codecs/sgtl5000.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/sound/soc/codecs/sgtl5000.c b/sound/soc/codecs/sgtl5000.c
index 32b5bbd..d15695d 100644
--- a/sound/soc/codecs/sgtl5000.c
+++ b/sound/soc/codecs/sgtl5000.c
@@ -723,7 +723,9 @@ static int sgtl5000_pcm_hw_params(struct snd_pcm_substream *substream,
 		return -EINVAL;
 	}
 
-	snd_soc_update_bits(codec, SGTL5000_CHIP_I2S_CTRL, i2s_ctl, i2s_ctl);
+	snd_soc_update_bits(codec, SGTL5000_CHIP_I2S_CTRL,
+			    SGTL5000_I2S_DLEN_MASK | SGTL5000_I2S_SCLKFREQ_MASK,
+			    i2s_ctl);
 
 	return 0;
 }
@@ -1146,8 +1148,7 @@ static int sgtl5000_set_power_regs(struct snd_soc_codec *codec)
 		vag = (vag - SGTL5000_ANA_GND_BASE) / SGTL5000_ANA_GND_STP;
 
 	snd_soc_update_bits(codec, SGTL5000_CHIP_REF_CTRL,
-			vag << SGTL5000_ANA_GND_SHIFT,
-			vag << SGTL5000_ANA_GND_SHIFT);
+			SGTL5000_ANA_GND_MASK, vag << SGTL5000_ANA_GND_SHIFT);
 
 	/* set line out VAG to vddio / 2, in range (0.8v, 1.675v) */
 	vag = vddio / 2;
@@ -1161,9 +1162,8 @@ static int sgtl5000_set_power_regs(struct snd_soc_codec *codec)
 		    SGTL5000_LINE_OUT_GND_STP;
 
 	snd_soc_update_bits(codec, SGTL5000_CHIP_LINE_OUT_CTRL,
-			vag << SGTL5000_LINE_OUT_GND_SHIFT |
-			SGTL5000_LINE_OUT_CURRENT_360u <<
-				SGTL5000_LINE_OUT_CURRENT_SHIFT,
+			SGTL5000_LINE_OUT_CURRENT_MASK |
+			SGTL5000_LINE_OUT_GND_MASK,
 			vag << SGTL5000_LINE_OUT_GND_SHIFT |
 			SGTL5000_LINE_OUT_CURRENT_360u <<
 				SGTL5000_LINE_OUT_CURRENT_SHIFT);
-- 
1.7.5.4



