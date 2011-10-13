Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429Ab1JMHXF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 03:23:05 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43666 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564Ab1JMHXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 03:23:03 -0400
Subject: [PATCH 1/3] ASoC: alc5623: Convert codec->hw_read to regmap_read
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 Oct 2011 15:22:55 +0800
Message-ID: <1318490575.2857.8.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

codec->hw_read is broken now, let's covert to regmap_read.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/alc5623.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/alc5623.c b/sound/soc/codecs/alc5623.c
index 557b3af..8c156cb 100644
--- a/sound/soc/codecs/alc5623.c
+++ b/sound/soc/codecs/alc5623.c
@@ -51,10 +51,13 @@ static void alc5623_fill_cache(struct snd_soc_codec *codec)
 {
 	int i, step = codec->driver->reg_cache_step;
 	u16 *cache = codec->reg_cache;
+	unsigned int val;
 
 	/* not really efficient ... */
-	for (i = 0 ; i < codec->driver->reg_cache_size ; i += step)
-		cache[i] = codec->hw_read(codec, i);
+	for (i = 0 ; i < codec->driver->reg_cache_size ; i += step) {
+		regmap_read(codec->control_data, i, &val);
+		cache[i] = val;
+	}
 }
 
 static inline int alc5623_reset(struct snd_soc_codec *codec)
-- 
1.7.4.1



