Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849Ab1JQMQo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 08:16:44 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:53377 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750Ab1JQMQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 08:16:43 -0400
Message-ID: <1318853797.4642.3.camel@phoenix>
Subject: [PATCH 2/2] ASoC: wm8741: Use snd_soc_cache_sync to sync reg_cache
 with the hardware
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Date: Mon, 17 Oct 2011 20:16:37 +0800
In-Reply-To: <1318853696.4642.1.camel@phoenix>
References: <1318853696.4642.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/wm8741.c |   10 +---------
 1 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/sound/soc/codecs/wm8741.c b/sound/soc/codecs/wm8741.c
index 85ebe02..57ad22a 100644
--- a/sound/soc/codecs/wm8741.c
+++ b/sound/soc/codecs/wm8741.c
@@ -404,15 +404,7 @@ static struct snd_soc_dai_driver wm8741_dai = {
 #ifdef CONFIG_PM
 static int wm8741_resume(struct snd_soc_codec *codec)
 {
-	u16 *cache = codec->reg_cache;
-	int i;
-
-	/* RESTORE REG Cache */
-	for (i = 0; i < WM8741_REGISTER_COUNT; i++) {
-		if (cache[i] == wm8741_reg_defaults[i] || WM8741_RESET == i)
-			continue;
-		snd_soc_write(codec, i, cache[i]);
-	}
+	snd_soc_cache_sync(codec);
 	return 0;
 }
 #else
-- 
1.7.5.4



