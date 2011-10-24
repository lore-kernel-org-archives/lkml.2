Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903Ab1JXDct (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 23:32:49 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:35540 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819Ab1JXDcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 23:32:48 -0400
Message-ID: <1319427161.5773.3.camel@phoenix>
Subject: [PATCH 1/3] ASoC: wm8940: Fix setting PLL Output clock division
 ratio
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Date: Mon, 24 Oct 2011 11:32:41 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the datasheet:
The PLL Output clock division ratio is controlled by BIT[5:4] of
WM8940_GPIO register(08h).
Current code read/write the WM8940_ADDCNTRL(07h) register which is wrong.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/wm8940.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/wm8940.c b/sound/soc/codecs/wm8940.c
index a4abfdf..3cc3bce 100644
--- a/sound/soc/codecs/wm8940.c
+++ b/sound/soc/codecs/wm8940.c
@@ -627,8 +627,8 @@ static int wm8940_set_dai_clkdiv(struct snd_soc_dai *codec_dai,
 		ret = snd_soc_write(codec, WM8940_CLOCK, reg | (div << 5));
 		break;
 	case WM8940_OPCLKDIV:
-		reg = snd_soc_read(codec, WM8940_ADDCNTRL) & 0xFFCF;
-		ret = snd_soc_write(codec, WM8940_ADDCNTRL, reg | (div << 4));
+		reg = snd_soc_read(codec, WM8940_GPIO) & 0xFFCF;
+		ret = snd_soc_write(codec, WM8940_GPIO, reg | (div << 4));
 		break;
 	}
 	return ret;
-- 
1.7.5.4



