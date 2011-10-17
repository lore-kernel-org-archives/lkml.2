Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723Ab1JQMPI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 08:15:08 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:32851 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750Ab1JQMPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 08:15:07 -0400
Message-ID: <1318853696.4642.1.camel@phoenix>
Subject: [PATCH 1/2] ASoC: wm8741: Fix setting interface format for DSP modes
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Date: Mon, 17 Oct 2011 20:14:56 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the datasheet:
Format Control (05h)
BITS[3:2]
        FMT[1:0] Audio data format selection
                00 = right justified mode
                01 = left justified mode
                10 = I2S mode
                11 = DSP mode
BIT[4]  LRP Polarity selec for LRCLK/DSP mode select
                0 = normal LRCLK poalrity/DSP mode A
                1 = inverted LRCLK poarity/DSP mode B

For SND_SOC_DAIFMT_DSP_A, we should set 0x000C instead of 0x0003.
For SND_SOC_DAIFMT_DSP_B, we should set 0x001C instead of 0x0013.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/wm8741.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/wm8741.c b/sound/soc/codecs/wm8741.c
index a42b282..85ebe02 100644
--- a/sound/soc/codecs/wm8741.c
+++ b/sound/soc/codecs/wm8741.c
@@ -339,10 +339,10 @@ static int wm8741_set_dai_fmt(struct snd_soc_dai *codec_dai,
 		iface |= 0x0004;
 		break;
 	case SND_SOC_DAIFMT_DSP_A:
-		iface |= 0x0003;
+		iface |= 0x000C;
 		break;
 	case SND_SOC_DAIFMT_DSP_B:
-		iface |= 0x0013;
+		iface |= 0x001C;
 		break;
 	default:
 		return -EINVAL;
-- 
1.7.5.4



