Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703Ab2AZO4p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 09:56:45 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:55258 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508Ab2AZO4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 09:56:39 -0500
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: linux-sh@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        linux-mmc@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-serial@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 6/7 v2] ASoC: SIU: prepare for conversion to simple DMA
Date: Thu, 26 Jan 2012 15:56:23 +0100
Message-Id: <1327589784-4287-7-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1327589784-4287-1-git-send-email-g.liakhovetski@gmx.de>
References: <1327589784-4287-1-git-send-email-g.liakhovetski@gmx.de>
X-Provags-ID: V02:K0:hvF7zn9rSWAmg4xVaSIrsiBr7y6wj8vmmIaUeopN7xF
 2B/fK96Mknb5PjwiGqveQ57aCvAnXT5jphrG3SeClLYWPwNsc8
 vZdAxmbKF9EvdbzmgbtxjO2KQ9M7IjyNX/y52uqJFMH2EYOpQ6
 6EwGwIZfpZ/cEPy4TXMaj7Ii1riKtRZGA4lYS7DN5pBKznK0Ri
 1AzX+tFOVr1mwzWJN2OtmQMeCHi9JTNdDZYp9kMTGj6dmuVKlz
 mp78jvhEhLgiUU3b7BI6AjTDnr9+SM4Jkbl0WCn9A5YLbXONaz
 XQugKO1g28c8Fk5/t2KaqSUNF1wOip1iBQeuXKzPN9XP8TW2Kr
 b/7mB8vXxnhyufx7X5PDSXkQ+3QETbnM1+MwrcATMvj1FwenWQ
 eezM60Be9tlfQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 sound/soc/sh/siu_pcm.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/soc/sh/siu_pcm.c b/sound/soc/sh/siu_pcm.c
index 0193e59..414bb35 100644
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

