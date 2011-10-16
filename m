Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662Ab1JPP2J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 11:28:09 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:42543 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941Ab1JPP2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 11:28:07 -0400
Subject: [PATCH 1/3] ASoC: wm8900: Fix wrong mask for setting
 DAC_CLKDIV/ADC_CLKDIV/LRCLK_MODE
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 16 Oct 2011 23:27:55 +0800
Message-ID: <1318778876.3106.3.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After checking the datasheet, I think what we want to do here is to
clear the WM8900_REG_CLOCKING2_DAC_CLKDIV/WM8900_REG_CLOCKING2_ADC_CLKDIV/
WM8900_REG_DACCTRL_AIF_LRCLKRATE bits and then OR with div value.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
I'd appreciate if someone can test this serial of patches.
Thanks,
Axel
 sound/soc/codecs/wm8900.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/wm8900.c b/sound/soc/codecs/wm8900.c
index 082040e..b16522f 100644
--- a/sound/soc/codecs/wm8900.c
+++ b/sound/soc/codecs/wm8900.c
@@ -844,17 +844,17 @@ static int wm8900_set_dai_clkdiv(struct snd_soc_dai *codec_dai,
 	case WM8900_DAC_CLKDIV:
 		reg = snd_soc_read(codec, WM8900_REG_CLOCKING2);
 		snd_soc_write(codec, WM8900_REG_CLOCKING2,
-			     div | (reg & WM8900_REG_CLOCKING2_DAC_CLKDIV));
+			     div | (reg & ~WM8900_REG_CLOCKING2_DAC_CLKDIV));
 		break;
 	case WM8900_ADC_CLKDIV:
 		reg = snd_soc_read(codec, WM8900_REG_CLOCKING2);
 		snd_soc_write(codec, WM8900_REG_CLOCKING2,
-			     div | (reg & WM8900_REG_CLOCKING2_ADC_CLKDIV));
+			     div | (reg & ~WM8900_REG_CLOCKING2_ADC_CLKDIV));
 		break;
 	case WM8900_LRCLK_MODE:
 		reg = snd_soc_read(codec, WM8900_REG_DACCTRL);
 		snd_soc_write(codec, WM8900_REG_DACCTRL,
-			     div | (reg & WM8900_REG_DACCTRL_AIF_LRCLKRATE));
+			     div | (reg & ~WM8900_REG_DACCTRL_AIF_LRCLKRATE));
 		break;
 	default:
 		return -EINVAL;
-- 
1.7.4.1



