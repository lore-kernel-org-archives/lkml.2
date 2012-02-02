Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933243Ab2BBVeS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 16:34:18 -0500
Received: from mxout1.idt.com ([157.165.5.25]:57405 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932585Ab2BBVeN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 16:34:13 -0500
From: Alexandre Bounine <alexandre.bounine@idt.com>
To: vinod.koul@intel.com, dan.j.williams@intel.com,
        linux-kernel@vger.kernel.org
Cc: Alexandre Bounine <alexandre.bounine@idt.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Mika Westerberg <mika.westerberg@iki.fi>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>, Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH 11/11] sound/soc: add context parameter to prep_slave_sg and prep_dma_cyclic calls
Date: Thu,  2 Feb 2012 16:32:21 -0500
Message-Id: <1328218341-31436-12-git-send-email-alexandre.bounine@idt.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1328218341-31436-1-git-send-email-alexandre.bounine@idt.com>
References: <1328218341-31436-1-git-send-email-alexandre.bounine@idt.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixups for calls affected by adding the new context parameter to DMA_SLAVE
and DMA_CYCLIC interfaces.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Liam Girdwood <lrg@ti.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Mika Westerberg <mika.westerberg@iki.fi>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Wolfram Sang <w.sang@pengutronix.de>
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>
Cc: Dong Aisheng <dong.aisheng@linaro.org>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
---
 sound/soc/ep93xx/ep93xx-pcm.c   |    2 +-
 sound/soc/imx/imx-pcm-dma-mx2.c |    2 +-
 sound/soc/mxs/mxs-pcm.c         |    2 +-
 sound/soc/sh/siu_pcm.c          |    6 ++++--
 sound/soc/txx9/txx9aclc.c       |    2 +-
 5 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/sound/soc/ep93xx/ep93xx-pcm.c b/sound/soc/ep93xx/ep93xx-pcm.c
index de83904..942c794 100644
--- a/sound/soc/ep93xx/ep93xx-pcm.c
+++ b/sound/soc/ep93xx/ep93xx-pcm.c
@@ -149,7 +149,7 @@ static int ep93xx_pcm_dma_submit(struct snd_pcm_substream *substream)
 	desc = dma_dev->device_prep_dma_cyclic(chan, runtime->dma_addr,
 					       rtd->period_bytes * rtd->periods,
 					       rtd->period_bytes,
-					       rtd->dma_data.direction);
+					       rtd->dma_data.direction, NULL);
 	if (!desc)
 		return -EINVAL;
 
diff --git a/sound/soc/imx/imx-pcm-dma-mx2.c b/sound/soc/imx/imx-pcm-dma-mx2.c
index 5780c9b..7fb9439 100644
--- a/sound/soc/imx/imx-pcm-dma-mx2.c
+++ b/sound/soc/imx/imx-pcm-dma-mx2.c
@@ -161,7 +161,7 @@ static int snd_imx_pcm_hw_params(struct snd_pcm_substream *substream,
 			iprtd->period_bytes * iprtd->periods,
 			iprtd->period_bytes,
 			substream->stream == SNDRV_PCM_STREAM_PLAYBACK ?
-			DMA_MEM_TO_DEV : DMA_DEV_TO_MEM);
+			DMA_MEM_TO_DEV : DMA_DEV_TO_MEM, NULL);
 	if (!iprtd->desc) {
 		dev_err(&chan->dev->device, "cannot prepare slave dma\n");
 		return -EINVAL;
diff --git a/sound/soc/mxs/mxs-pcm.c b/sound/soc/mxs/mxs-pcm.c
index 105f42a..ccddc5d 100644
--- a/sound/soc/mxs/mxs-pcm.c
+++ b/sound/soc/mxs/mxs-pcm.c
@@ -136,7 +136,7 @@ static int snd_mxs_pcm_hw_params(struct snd_pcm_substream *substream,
 			iprtd->period_bytes * iprtd->periods,
 			iprtd->period_bytes,
 			substream->stream == SNDRV_PCM_STREAM_PLAYBACK ?
-			DMA_MEM_TO_DEV : DMA_DEV_TO_MEM);
+			DMA_MEM_TO_DEV : DMA_DEV_TO_MEM, NULL);
 	if (!iprtd->desc) {
 		dev_err(&chan->dev->device, "cannot prepare slave dma\n");
 		return -EINVAL;
diff --git a/sound/soc/sh/siu_pcm.c b/sound/soc/sh/siu_pcm.c
index 0193e59..c89ae9e 100644
--- a/sound/soc/sh/siu_pcm.c
+++ b/sound/soc/sh/siu_pcm.c
@@ -131,7 +131,8 @@ static int siu_pcm_wr_set(struct siu_port *port_info,
 	sg_dma_address(&sg) = buff;
 
 	desc = siu_stream->chan->device->device_prep_slave_sg(siu_stream->chan,
-		&sg, 1, DMA_MEM_TO_DEV, DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+		&sg, 1, DMA_MEM_TO_DEV, DMA_PREP_INTERRUPT | DMA_CTRL_ACK,
+		NULL);
 	if (!desc) {
 		dev_err(dev, "Failed to allocate a dma descriptor\n");
 		return -ENOMEM;
@@ -181,7 +182,8 @@ static int siu_pcm_rd_set(struct siu_port *port_info,
 	sg_dma_address(&sg) = buff;
 
 	desc = siu_stream->chan->device->device_prep_slave_sg(siu_stream->chan,
-		&sg, 1, DMA_DEV_TO_MEM, DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+		&sg, 1, DMA_DEV_TO_MEM, DMA_PREP_INTERRUPT | DMA_CTRL_ACK,
+		NULL);
 	if (!desc) {
 		dev_err(dev, "Failed to allocate dma descriptor\n");
 		return -ENOMEM;
diff --git a/sound/soc/txx9/txx9aclc.c b/sound/soc/txx9/txx9aclc.c
index 2155461..252b8d4 100644
--- a/sound/soc/txx9/txx9aclc.c
+++ b/sound/soc/txx9/txx9aclc.c
@@ -135,7 +135,7 @@ txx9aclc_dma_submit(struct txx9aclc_dmadata *dmadata, dma_addr_t buf_dma_addr)
 	desc = chan->device->device_prep_slave_sg(chan, &sg, 1,
 		dmadata->substream->stream == SNDRV_PCM_STREAM_PLAYBACK ?
 		DMA_MEM_TO_DEV : DMA_DEV_TO_MEM,
-		DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
+		DMA_PREP_INTERRUPT | DMA_CTRL_ACK, NULL);
 	if (!desc) {
 		dev_err(&chan->dev->device, "cannot prepare slave dma\n");
 		return NULL;
-- 
1.7.8.4

