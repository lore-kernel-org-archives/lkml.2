Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029Ab1JNBhJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 21:37:09 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36954 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906Ab1JNBhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 21:37:07 -0400
Subject: [PATCH 2/3] ASoC: tlv320aic3x: Convert codec->hw_read to
 snd_soc_read
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Vladimir Barinov <vbarinov@embeddedalley.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
In-Reply-To: <1318556120.6379.1.camel@phoenix>
References: <1318556120.6379.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Oct 2011 09:37:00 +0800
Message-ID: <1318556220.6379.3.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

codec->hw_read is broken now, let's covert to snd_soc_read.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/tlv320aic3x.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/sound/soc/codecs/tlv320aic3x.c b/sound/soc/codecs/tlv320aic3x.c
index be55b7f..7a49390 100644
--- a/sound/soc/codecs/tlv320aic3x.c
+++ b/sound/soc/codecs/tlv320aic3x.c
@@ -137,7 +137,10 @@ static int aic3x_read(struct snd_soc_codec *codec, unsigned int reg,
 	if (reg >= AIC3X_CACHEREGNUM)
 		return -1;
 
-	*value = codec->hw_read(codec, reg);
+	codec->cache_bypass = 1;
+	*value = snd_soc_read(codec, reg);
+	codec->cache_bypass = 0;
+
 	cache[reg] = *value;
 
 	return 0;
-- 
1.7.4.1



