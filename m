Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160Ab1LNHes (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 02:34:48 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:9154 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753469Ab1LNHer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 02:34:47 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275dhz2dh87h2a8h668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Shawn Guo <shawn.guo@linaro.org>
To: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Dong Aisheng <dong.aisheng@linaro.org>, <alsa-devel@alsa-project.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH 5/5] ASoC: mxs: correct 'direction' of device_prep_dma_cyclic
Date: Wed, 14 Dec 2011 15:47:46 +0800
Message-ID: <1323848866-19768-1-git-send-email-shawn.guo@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1323791286-29574-1-git-send-email-shawn.guo@linaro.org>
References: <1323791286-29574-1-git-send-email-shawn.guo@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit 49920bc (dmaengine: add new enum dma_transfer_direction)
changes the type of parameter 'direction' of device_prep_dma_cyclic
from dma_data_direction to dma_transfer_direction.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
---
 sound/soc/mxs/mxs-pcm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/mxs/mxs-pcm.c b/sound/soc/mxs/mxs-pcm.c
index 0e12f4e..105f42a 100644
--- a/sound/soc/mxs/mxs-pcm.c
+++ b/sound/soc/mxs/mxs-pcm.c
@@ -136,7 +136,7 @@ static int snd_mxs_pcm_hw_params(struct snd_pcm_substream *substream,
 			iprtd->period_bytes * iprtd->periods,
 			iprtd->period_bytes,
 			substream->stream == SNDRV_PCM_STREAM_PLAYBACK ?
-			DMA_TO_DEVICE : DMA_FROM_DEVICE);
+			DMA_MEM_TO_DEV : DMA_DEV_TO_MEM);
 	if (!iprtd->desc) {
 		dev_err(&chan->dev->device, "cannot prepare slave dma\n");
 		return -EINVAL;
-- 
1.7.4.1


