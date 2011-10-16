Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673Ab1JPP3U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 11:29:20 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60068 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754536Ab1JPP3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 11:29:19 -0400
Subject: [PATCH 2/3] ASoC: wm8900: Fix the mask defines
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
In-Reply-To: <1318778876.3106.3.camel@phoenix>
References: <1318778876.3106.3.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 16 Oct 2011 23:29:12 +0800
Message-ID: <1318778952.3106.4.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we have done bitwise NOT against the mask bits for the defines of
WM8900_REG_CLOCKING1_BCLK_MASK,
WM8900_REG_CLOCKING1_OPCLK_MASK and WM8900_LRC_MASK.

But we don't have the bitwise NOT against the mask bits for the defines of
WM8900_REG_CLOCKING2_DAC_CLKDIV,
WM8900_REG_CLOCKING2_ADC_CLKDIV and WM8900_REG_DACCTRL_AIF_LRCLKRATE.

It is error prone to mix the inconsistent meaning for different mask defines.
So lets make the defines for each mask to be corresponding to the bits
defines in datasheet. Don't add extra "bitwise NOT" to the defines.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/wm8900.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/sound/soc/codecs/wm8900.c b/sound/soc/codecs/wm8900.c
index b16522f..86de396 100644
--- a/sound/soc/codecs/wm8900.c
+++ b/sound/soc/codecs/wm8900.c
@@ -110,8 +110,8 @@
 
 #define WM8900_REG_CLOCKING1_BCLK_DIR   0x1
 #define WM8900_REG_CLOCKING1_MCLK_SRC   0x100
-#define WM8900_REG_CLOCKING1_BCLK_MASK  (~0x01e)
-#define WM8900_REG_CLOCKING1_OPCLK_MASK (~0x7000)
+#define WM8900_REG_CLOCKING1_BCLK_MASK  0x01e
+#define WM8900_REG_CLOCKING1_OPCLK_MASK 0x7000
 
 #define WM8900_REG_CLOCKING2_ADC_CLKDIV 0xe0
 #define WM8900_REG_CLOCKING2_DAC_CLKDIV 0x1c
@@ -135,7 +135,7 @@
 #define WM8900_REG_HPCTL1_HP_SHORT       0x08
 #define WM8900_REG_HPCTL1_HP_SHORT2      0x04
 
-#define WM8900_LRC_MASK 0xfc00
+#define WM8900_LRC_MASK 0x03ff
 
 struct wm8900_priv {
 	enum snd_soc_control_type control_type;
@@ -824,22 +824,22 @@ static int wm8900_set_dai_clkdiv(struct snd_soc_dai *codec_dai,
 	case WM8900_BCLK_DIV:
 		reg = snd_soc_read(codec, WM8900_REG_CLOCKING1);
 		snd_soc_write(codec, WM8900_REG_CLOCKING1,
-			     div | (reg & WM8900_REG_CLOCKING1_BCLK_MASK));
+			     div | (reg & ~WM8900_REG_CLOCKING1_BCLK_MASK));
 		break;
 	case WM8900_OPCLK_DIV:
 		reg = snd_soc_read(codec, WM8900_REG_CLOCKING1);
 		snd_soc_write(codec, WM8900_REG_CLOCKING1,
-			     div | (reg & WM8900_REG_CLOCKING1_OPCLK_MASK));
+			     div | (reg & ~WM8900_REG_CLOCKING1_OPCLK_MASK));
 		break;
 	case WM8900_DAC_LRCLK:
 		reg = snd_soc_read(codec, WM8900_REG_AUDIO4);
 		snd_soc_write(codec, WM8900_REG_AUDIO4,
-			     div | (reg & WM8900_LRC_MASK));
+			     div | (reg & ~WM8900_LRC_MASK));
 		break;
 	case WM8900_ADC_LRCLK:
 		reg = snd_soc_read(codec, WM8900_REG_AUDIO3);
 		snd_soc_write(codec, WM8900_REG_AUDIO3,
-			     div | (reg & WM8900_LRC_MASK));
+			     div | (reg & ~WM8900_LRC_MASK));
 		break;
 	case WM8900_DAC_CLKDIV:
 		reg = snd_soc_read(codec, WM8900_REG_CLOCKING2);
-- 
1.7.4.1



