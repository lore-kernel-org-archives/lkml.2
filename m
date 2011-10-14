Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932639Ab1JNFtE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 01:49:04 -0400
Received: from mga14.intel.com ([143.182.124.37]:25401 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932431Ab1JNFrR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 01:47:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,344,1315206000"; 
   d="scan'208";a="62487010"
From: Vinod Koul <vinod.koul@intel.com>
To: dan.j.williams@intel.com
Cc: linux-kernel@vger.kernel.org, jaswinder.singh@linaro.org,
        21cnbao@gmail.com, rmk@arm.linux.org.uk,
        Vinod Koul <vinod.koul@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH 04/10] media-video: move to dma_transfer_direction
Date: Fri, 14 Oct 2011 11:08:19 +0530
Message-Id: <1318570705-17595-5-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1318570705-17595-1-git-send-email-vinod.koul@intel.com>
References: <1318570705-17595-1-git-send-email-vinod.koul@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vinod Koul <vinod.koul@linux.intel.com>

Signed-off-by: Vinod Koul <vinod.koul@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/video/mx3_camera.c |    2 +-
 drivers/media/video/timblogiw.c  |    2 +-
 drivers/video/mx3fb.c            |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/mx3_camera.c b/drivers/media/video/mx3_camera.c
index c045b47..b6ac932 100644
--- a/drivers/media/video/mx3_camera.c
+++ b/drivers/media/video/mx3_camera.c
@@ -251,7 +251,7 @@ static int mx3_videobuf_prepare(struct vb2_buffer *vb)
 		sg_dma_len(sg)		= new_size;
 
 		buf->txd = ichan->dma_chan.device->device_prep_slave_sg(
-			&ichan->dma_chan, sg, 1, DMA_FROM_DEVICE,
+			&ichan->dma_chan, sg, 1, DEV_TO_MEM,
 			DMA_PREP_INTERRUPT);
 		if (!buf->txd)
 			return -EIO;
diff --git a/drivers/media/video/timblogiw.c b/drivers/media/video/timblogiw.c
index 84cd1b6..1940d47 100644
--- a/drivers/media/video/timblogiw.c
+++ b/drivers/media/video/timblogiw.c
@@ -564,7 +564,7 @@ static void buffer_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
 	spin_unlock_irq(&fh->queue_lock);
 
 	desc = fh->chan->device->device_prep_slave_sg(fh->chan,
-		buf->sg, sg_elems, DMA_FROM_DEVICE,
+		buf->sg, sg_elems, DEV_TO_MEM,
 		DMA_PREP_INTERRUPT | DMA_COMPL_SKIP_SRC_UNMAP);
 	if (!desc) {
 		spin_lock_irq(&fh->queue_lock);
diff --git a/drivers/video/mx3fb.c b/drivers/video/mx3fb.c
index 7e3a490..7b0232f 100644
--- a/drivers/video/mx3fb.c
+++ b/drivers/video/mx3fb.c
@@ -334,7 +334,7 @@ static void sdc_enable_channel(struct mx3fb_info *mx3_fbi)
 	/* This enables the channel */
 	if (mx3_fbi->cookie < 0) {
 		mx3_fbi->txd = dma_chan->device->device_prep_slave_sg(dma_chan,
-		      &mx3_fbi->sg[0], 1, DMA_TO_DEVICE, DMA_PREP_INTERRUPT);
+		      &mx3_fbi->sg[0], 1, MEM_TO_DEV, DMA_PREP_INTERRUPT);
 		if (!mx3_fbi->txd) {
 			dev_err(mx3fb->dev, "Cannot allocate descriptor on %d\n",
 				dma_chan->chan_id);
@@ -1104,7 +1104,7 @@ static int mx3fb_pan_display(struct fb_var_screeninfo *var,
 		async_tx_ack(mx3_fbi->txd);
 
 	txd = dma_chan->device->device_prep_slave_sg(dma_chan, sg +
-		mx3_fbi->cur_ipu_buf, 1, DMA_TO_DEVICE, DMA_PREP_INTERRUPT);
+		mx3_fbi->cur_ipu_buf, 1, MEM_TO_DEV, DMA_PREP_INTERRUPT);
 	if (!txd) {
 		dev_err(fbi->device,
 			"Error preparing a DMA transaction descriptor.\n");
-- 
1.7.0.4

