Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932507Ab2GEKbf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 06:31:35 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:52252 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755611Ab2GEK3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 06:29:49 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/7 v2] ASoC: siu: don't use DMA device for channel filtering
Date: Thu,  5 Jul 2012 12:29:38 +0200
Message-Id: <1341484183-10757-3-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1341484183-10757-1-git-send-email-g.liakhovetski@gmx.de>
References: <1341484183-10757-1-git-send-email-g.liakhovetski@gmx.de>
X-Provags-ID: V02:K0:TMuue3rV+1udIN4CKPxFrO0I/y7C2466UgdcLud70o9
 pJwpXehD/P5krKcWPvYlP3Tf8qmm3Hnm3aLwd7+rLr5QAxkETO
 wo6fkdPGHmYmj0wmGvPFy5N/7YUBwXi2Iiears9c35ce50o1fH
 ddJrjSYJM4/lop2eCBHPCntPPXgfNFJAyjEotoDTYyEBxIDMgZ
 GDyMWOv3EAf6NI172i0wIctjoziPYdDqFE31UcYxcmxAEd+ikw
 PpWP2jFAkoWahawxYzio9XvCI9OH5BBDUdU38xlsCb2m4KxFiZ
 PzFN+YXqGBlFviTp6Ipzhbwdyh1s4mI1Z4jo5SqoYdFWZF0OM/
 hpRBQtorzxHA+MJGwUMogCBkqs0dMXdE5eQpI0XzrvI16Fd8S5
 NXNNiwzZ5uvXg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DMA channels are filtered based on slave IDs, no need to additionally filter
on DMA device.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 sound/soc/sh/siu_pcm.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/sound/soc/sh/siu_pcm.c b/sound/soc/sh/siu_pcm.c
index 3fdc801..488f9be 100644
--- a/sound/soc/sh/siu_pcm.c
+++ b/sound/soc/sh/siu_pcm.c
@@ -332,9 +332,6 @@ static bool filter(struct dma_chan *chan, void *slave)
 
 	pr_debug("%s: slave ID %d\n", __func__, param->shdma_slave.slave_id);
 
-	if (unlikely(param->dma_dev != chan->device->dev))
-		return false;
-
 	chan->private = &param->shdma_slave;
 	return true;
 }
@@ -369,7 +366,6 @@ static int siu_pcm_open(struct snd_pcm_substream *ss)
 			pdata->dma_slave_rx_a;
 	}
 
-	param->dma_dev = pdata->dma_dev;
 	/* Get DMA channel */
 	siu_stream->chan = dma_request_channel(mask, filter, param);
 	if (!siu_stream->chan) {
-- 
1.7.2.5

