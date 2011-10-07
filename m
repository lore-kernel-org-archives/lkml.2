Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965441Ab1JGNjS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 09:39:18 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49282 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608Ab1JGNjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 09:39:16 -0400
Subject: [PATCH v3 03/10] ASoC: wm8731: Convert to snd_soc_cache_sync
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Richard Purdie <rpurdie@rpsys.net>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
In-Reply-To: <1317994508.9906.1.camel@phoenix>
References: <1317994508.9906.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 Oct 2011 21:39:09 +0800
Message-ID: <1317994749.9906.7.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to snd_soc_cache_sync for sync reg_cache with the hardware.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/wm8731.c |   15 ++-------------
 1 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/sound/soc/codecs/wm8731.c b/sound/soc/codecs/wm8731.c
index f76b6fc..7e5ec03 100644
--- a/sound/soc/codecs/wm8731.c
+++ b/sound/soc/codecs/wm8731.c
@@ -427,9 +427,7 @@ static int wm8731_set_bias_level(struct snd_soc_codec *codec,
 				 enum snd_soc_bias_level level)
 {
 	struct wm8731_priv *wm8731 = snd_soc_codec_get_drvdata(codec);
-	int i, ret;
-	u8 data[2];
-	u16 *cache = codec->reg_cache;
+	int ret;
 	u16 reg;
 
 	switch (level) {
@@ -444,16 +442,7 @@ static int wm8731_set_bias_level(struct snd_soc_codec *codec,
 			if (ret != 0)
 				return ret;
 
-			/* Sync reg_cache with the hardware */
-			for (i = 0; i < ARRAY_SIZE(wm8731_reg); i++) {
-				if (cache[i] == wm8731_reg[i])
-					continue;
-
-				data[0] = (i << 1) | ((cache[i] >> 8)
-						      & 0x0001);
-				data[1] = cache[i] & 0x00ff;
-				codec->hw_write(codec->control_data, data, 2);
-			}
+			snd_soc_cache_sync(codec);
 		}
 
 		/* Clear PWROFF, gate CLKOUT, everything else as-is */
-- 
1.7.4.1



