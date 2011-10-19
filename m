Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164Ab1JSDAu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 23:00:50 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54405 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883Ab1JSDAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 23:00:49 -0400
Message-ID: <1318993242.7128.5.camel@phoenix>
Subject: [PATCH 2/2] ASoC: sgtl5000: Fix setting mic bias resistor
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <w.sang@pengutronix.de>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Date: Wed, 19 Oct 2011 11:00:42 +0800
In-Reply-To: <1318992896.7128.1.camel@phoenix>
References: <1318992896.7128.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the datasheet:
CHIP_MIC_CTRL 0x002A

BITS[9:8] BIAS_RESISTOR
        0x0 = Powerd off
        0x1 = 2.0 kohm
        0x2 = 4.0 kohm
        0x3 = 8.0 kohm

To set mic bias resistor, we need to update bits[9:8] of
SGTL5000_CHIP_MIC_CTRL register.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/sgtl5000.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/sound/soc/codecs/sgtl5000.c b/sound/soc/codecs/sgtl5000.c
index 91130fb..3637a62 100644
--- a/sound/soc/codecs/sgtl5000.c
+++ b/sound/soc/codecs/sgtl5000.c
@@ -131,16 +131,13 @@ static int mic_bias_event(struct snd_soc_dapm_widget *w,
 	case SND_SOC_DAPM_POST_PMU:
 		/* change mic bias resistor to 4Kohm */
 		snd_soc_update_bits(w->codec, SGTL5000_CHIP_MIC_CTRL,
-				SGTL5000_BIAS_R_4k, SGTL5000_BIAS_R_4k);
+				SGTL5000_BIAS_R_MASK,
+				SGTL5000_BIAS_R_4k << SGTL5000_BIAS_R_SHIFT);
 		break;
 
 	case SND_SOC_DAPM_PRE_PMD:
-		/*
-		 * SGTL5000_BIAS_R_8k as mask to clean the two bits
-		 * of mic bias and output impedance
-		 */
 		snd_soc_update_bits(w->codec, SGTL5000_CHIP_MIC_CTRL,
-				SGTL5000_BIAS_R_8k, 0);
+				SGTL5000_BIAS_R_MASK, 0);
 		break;
 	}
 	return 0;
-- 
1.7.5.4



