Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751595Ab1IUGm4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 02:42:56 -0400
Received: from mail-gw0-f52.google.com ([74.125.83.52]:60375 "EHLO
	mail-gw0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850Ab1IUGmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 02:42:55 -0400
Subject: [PATCH 4/4] ASoC: Staticise nuc900_dma_getposition()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Wan ZongShun <mcuos.com@gmail.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
In-Reply-To: <1316587205.2824.1.camel@phoenix>
References: <1316587205.2824.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Sep 2011 14:42:49 +0800
Message-ID: <1316587369.2824.4.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is not used outside this driver so no need to make the symbol global.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/nuc900/nuc900-pcm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/nuc900/nuc900-pcm.c b/sound/soc/nuc900/nuc900-pcm.c
index e46d551..4e3626b 100644
--- a/sound/soc/nuc900/nuc900-pcm.c
+++ b/sound/soc/nuc900/nuc900-pcm.c
@@ -227,7 +227,7 @@ static int nuc900_dma_trigger(struct snd_pcm_substream *substream, int cmd)
 	return ret;
 }
 
-int nuc900_dma_getposition(struct snd_pcm_substream *substream,
+static int nuc900_dma_getposition(struct snd_pcm_substream *substream,
 					dma_addr_t *src, dma_addr_t *dst)
 {
 	struct snd_pcm_runtime *runtime = substream->runtime;
-- 
1.7.4.1



