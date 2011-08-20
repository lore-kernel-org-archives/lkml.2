Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615Ab1HTNFL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 09:05:11 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:46403 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314Ab1HTNFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 09:05:07 -0400
Subject: [PATCH] ASoC: soc-cache: Avoid a redundant test for
 codec->reg_def_copy
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 20 Aug 2011 21:04:58 +0800
Message-ID: <1313845498.2619.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/soc-cache.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/sound/soc/soc-cache.c b/sound/soc/soc-cache.c
index fdfd488..d620147 100644
--- a/sound/soc/soc-cache.c
+++ b/sound/soc/soc-cache.c
@@ -727,13 +727,11 @@ static int snd_soc_lzo_cache_init(struct snd_soc_codec *codec)
 	 * and remember to free it afterwards.
 	 */
 	tofree = 0;
-	if (!codec->reg_def_copy)
-		tofree = 1;
-
 	if (!codec->reg_def_copy) {
 		codec->reg_def_copy = kzalloc(codec->reg_size, GFP_KERNEL);
 		if (!codec->reg_def_copy)
 			return -ENOMEM;
+		tofree = 1;
 	}
 
 	blkcount = snd_soc_lzo_block_count();
-- 
1.7.4.1



