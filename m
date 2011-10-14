Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab1JNJCO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 05:02:14 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:64194 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345Ab1JNJCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 05:02:12 -0400
Subject: [PATCH 1/2] ASoC: ad193x: Fix define of AD193X_PLL_INPUT_MASK
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Barry Song <21cnbao@gmail.com>, alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Oct 2011 17:01:59 +0800
Message-ID: <1318582919.19976.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current code defines AD193X_PLL_INPUT_MASK as (~0x6) which is quite
different from other MASK defines.
To make it consistent with other mask defines, define AD193X_PLL_INPUT_MASK
as 0x6 and change the code accordingly.
I think this change improves the readability.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/ad193x.c |    2 +-
 sound/soc/codecs/ad193x.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/ad193x.c b/sound/soc/codecs/ad193x.c
index f934670..39056ce 100644
--- a/sound/soc/codecs/ad193x.c
+++ b/sound/soc/codecs/ad193x.c
@@ -298,7 +298,7 @@ static int ad193x_hw_params(struct snd_pcm_substream *substream,
 	}
 
 	reg = snd_soc_read(codec, AD193X_PLL_CLK_CTRL0);
-	reg = (reg & AD193X_PLL_INPUT_MASK) | master_rate;
+	reg = (reg & (~AD193X_PLL_INPUT_MASK)) | master_rate;
 	snd_soc_write(codec, AD193X_PLL_CLK_CTRL0, reg);
 
 	reg = snd_soc_read(codec, AD193X_DAC_CTRL2);
diff --git a/sound/soc/codecs/ad193x.h b/sound/soc/codecs/ad193x.h
index 536e5f2..1507eaa 100644
--- a/sound/soc/codecs/ad193x.h
+++ b/sound/soc/codecs/ad193x.h
@@ -11,7 +11,7 @@
 
 #define AD193X_PLL_CLK_CTRL0    0x00
 #define AD193X_PLL_POWERDOWN           0x01
-#define AD193X_PLL_INPUT_MASK   (~0x6)
+#define AD193X_PLL_INPUT_MASK   0x6
 #define AD193X_PLL_INPUT_256    (0 << 1)
 #define AD193X_PLL_INPUT_384    (1 << 1)
 #define AD193X_PLL_INPUT_512    (2 << 1)
-- 
1.7.4.1



