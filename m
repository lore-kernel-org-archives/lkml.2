Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751375Ab1IUGl6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 02:41:58 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:47386 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844Ab1IUGl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 02:41:57 -0400
Subject: [PATCH 3/4] ASoC: Staticise jz4740_pcm_new()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lars-Peter Clausen <lars@metafoo.de>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
In-Reply-To: <1316587205.2824.1.camel@phoenix>
References: <1316587205.2824.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Sep 2011 14:41:50 +0800
Message-ID: <1316587310.2824.3.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is not used outside this driver so no need to make the symbol global.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/jz4740/jz4740-pcm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/jz4740/jz4740-pcm.c b/sound/soc/jz4740/jz4740-pcm.c
index a7c9578..d1989cd 100644
--- a/sound/soc/jz4740/jz4740-pcm.c
+++ b/sound/soc/jz4740/jz4740-pcm.c
@@ -299,7 +299,7 @@ static void jz4740_pcm_free(struct snd_pcm *pcm)
 
 static u64 jz4740_pcm_dmamask = DMA_BIT_MASK(32);
 
-int jz4740_pcm_new(struct snd_soc_pcm_runtime *rtd)
+static int jz4740_pcm_new(struct snd_soc_pcm_runtime *rtd)
 {
 	struct snd_card *card = rtd->card->snd_card;
 	struct snd_soc_dai *dai = rtd->cpu_dai;
-- 
1.7.4.1



