Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751720Ab1HMN1X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 09:27:23 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:33510 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117Ab1HMN1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 09:27:22 -0400
Subject: [PATCH] ASoC: soc-cache: Remove unneeded codec_drv pointer
 variable in snd_soc_lzo_get_blksize
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 13 Aug 2011 21:27:16 +0800
Message-ID: <1313242036.12301.4.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit aea170a099793abcd0e6de46b947458073204241
"ASoC: soc-cache: Add reg_size as a member to snd_soc_codec",
the codec_drv pointer variable is not used in snd_soc_lzo_get_blksize.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/soc-cache.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/sound/soc/soc-cache.c b/sound/soc/soc-cache.c
index c17d012..fdfd488 100644
--- a/sound/soc/soc-cache.c
+++ b/sound/soc/soc-cache.c
@@ -548,9 +548,6 @@ static inline int snd_soc_lzo_get_blkpos(struct snd_soc_codec *codec,
 
 static inline int snd_soc_lzo_get_blksize(struct snd_soc_codec *codec)
 {
-	const struct snd_soc_codec_driver *codec_drv;
-
-	codec_drv = codec->driver;
 	return DIV_ROUND_UP(codec->reg_size, snd_soc_lzo_block_count());
 }
 
-- 
1.7.4.1



