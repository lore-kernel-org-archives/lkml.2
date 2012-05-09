Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759918Ab2EIPKo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 11:10:44 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:54903 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759818Ab2EIPJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 11:09:38 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-kernel@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 6/9 v3] ASoC: siu: prepare for conversion to the shdma base library
Date: Wed,  9 May 2012 17:09:18 +0200
Message-Id: <1336576161-27082-7-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1336576161-27082-1-git-send-email-g.liakhovetski@gmx.de>
References: <1336576161-27082-1-git-send-email-g.liakhovetski@gmx.de>
X-Provags-ID: V02:K0:ZepLcg7Lv3QlRn+PCeNhQg6I2QCaQKh/TiEARow8J38
 0xXW/w/6qedKuPeTqnKvV11QktYsbatXV9d/UVk0BHZrgBx3/n
 5lqiCfCOP5rymqw77BhjHcIgV7oWozaQVZqiQaWT9NlVf+XQMQ
 e83aDd3L6agk2qKaVxU8010tc5pFkhjIUuvyHq238hvaccXhNe
 bRF4IZd+gsvdEvUhIlMQKIxi7YMA+2t6fTOjg1DX97ycj7HVdP
 FBp/ieZyizQFNw+WwDd4/x6TIl5/5Ra8z63w1FbKekc3+9/zYN
 7IJne+eDB4F4D6Nl4qDqdjztEZgSI6mGYHzDHUrPhIS/cuYXeL
 x5LENrk7DC80A7zRcqgNft5VbE2KvPv0E0oE8xmGbDMFBMu4aC
 wSJG9LB9Ipc4A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Liam Girdwood <lrg@ti.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 sound/soc/sh/siu_pcm.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/soc/sh/siu_pcm.c b/sound/soc/sh/siu_pcm.c
index 5cfcc65..3fdc801 100644
--- a/sound/soc/sh/siu_pcm.c
+++ b/sound/soc/sh/siu_pcm.c
@@ -330,12 +330,12 @@ static bool filter(struct dma_chan *chan, void *slave)
 {
 	struct sh_dmae_slave *param = slave;
 
-	pr_debug("%s: slave ID %d\n", __func__, param->slave_id);
+	pr_debug("%s: slave ID %d\n", __func__, param->shdma_slave.slave_id);
 
 	if (unlikely(param->dma_dev != chan->device->dev))
 		return false;
 
-	chan->private = param;
+	chan->private = &param->shdma_slave;
 	return true;
 }
 
@@ -360,12 +360,12 @@ static int siu_pcm_open(struct snd_pcm_substream *ss)
 	if (ss->stream == SNDRV_PCM_STREAM_PLAYBACK) {
 		siu_stream = &port_info->playback;
 		param = &siu_stream->param;
-		param->slave_id = port ? pdata->dma_slave_tx_b :
+		param->shdma_slave.slave_id = port ? pdata->dma_slave_tx_b :
 			pdata->dma_slave_tx_a;
 	} else {
 		siu_stream = &port_info->capture;
 		param = &siu_stream->param;
-		param->slave_id = port ? pdata->dma_slave_rx_b :
+		param->shdma_slave.slave_id = port ? pdata->dma_slave_rx_b :
 			pdata->dma_slave_rx_a;
 	}
 
-- 
1.7.2.5

