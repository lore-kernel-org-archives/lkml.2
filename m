Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452Ab2ARKWs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 05:22:48 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:49176 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756306Ab2ARKWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 05:22:45 -0500
Date: Wed, 18 Jan 2012 11:22:37 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: linux-kernel@vger.kernel.org
cc: linux-sh@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        "Shimoda, Yoshihiro" <yoshihiro.shimoda.uh@renesas.com>,
        alsa-devel@alsa-project.org
Subject: [PATCH 6/7] ASoC: SIU: prepare for conversion to simple DMA
In-Reply-To: <Pine.LNX.4.64.1201181025280.28782@axis700.grange>
Message-ID: <Pine.LNX.4.64.1201181117590.28782@axis700.grange>
References: <Pine.LNX.4.64.1201181025280.28782@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:Z3Sz84N35BtUUOtJ43AJasZXAA2WHqJ0ON+002pgcwT
 cwhNHR7j0/JB4LXN/t3KuJizwU0WUhcKtheF9vjliaTV7fbKHG
 bmpS4BotdGTaXSULgk0/5hFCyjwDrSkJdvP8VDOjrTeZQkp4+2
 UyCRhzgQeH9zTSNRwPQdG0XRQWAX5Xr+FFS15IeQ850q/QpwGn
 SlMvd9lQOezXUg8K0PStoThoL7gnrp0dfXPj0cIP5G9f5nXzYe
 IFBO/bVhelS3NPQl1FlL9bBghmg1hYfMyNOIph2PR0UGireBe6
 lXq1sx2QfL5K3G8rHI1IQFuGkkfC+JUm1XK7AKQSbGWfml2aKa
 LOdtsqLjwuNezGVuxvEJh+1b2VF+tY6QdgDG+PkvZSAPAbiYyA
 KvS1mxIBwVTgg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 sound/soc/sh/siu_pcm.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/soc/sh/siu_pcm.c b/sound/soc/sh/siu_pcm.c
index f8f6816..6390fec 100644
--- a/sound/soc/sh/siu_pcm.c
+++ b/sound/soc/sh/siu_pcm.c
@@ -330,12 +330,12 @@ static bool filter(struct dma_chan *chan, void *slave)
 {
 	struct sh_dmae_slave *param = slave;
 
-	pr_debug("%s: slave ID %d\n", __func__, param->slave_id);
+	pr_debug("%s: slave ID %d\n", __func__, param->simple_slave.slave_id);
 
 	if (unlikely(param->dma_dev != chan->device->dev))
 		return false;
 
-	chan->private = param;
+	chan->private = &param->simple_slave;
 	return true;
 }
 
@@ -360,12 +360,12 @@ static int siu_pcm_open(struct snd_pcm_substream *ss)
 	if (ss->stream == SNDRV_PCM_STREAM_PLAYBACK) {
 		siu_stream = &port_info->playback;
 		param = &siu_stream->param;
-		param->slave_id = port ? pdata->dma_slave_tx_b :
+		param->simple_slave.slave_id = port ? pdata->dma_slave_tx_b :
 			pdata->dma_slave_tx_a;
 	} else {
 		siu_stream = &port_info->capture;
 		param = &siu_stream->param;
-		param->slave_id = port ? pdata->dma_slave_rx_b :
+		param->simple_slave.slave_id = port ? pdata->dma_slave_rx_b :
 			pdata->dma_slave_rx_a;
 	}
 
-- 
1.7.2.5

