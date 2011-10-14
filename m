Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932594Ab1JNFrf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 01:47:35 -0400
Received: from mga14.intel.com ([143.182.124.37]:62630 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755788Ab1JNFrc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 01:47:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,344,1315206000"; 
   d="scan'208";a="62487069"
From: Vinod Koul <vinod.koul@intel.com>
To: dan.j.williams@intel.com
Cc: linux-kernel@vger.kernel.org, jaswinder.singh@linaro.org,
        21cnbao@gmail.com, rmk@arm.linux.org.uk,
        Vinod Koul <vinod.koul@linux.intel.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 09/10] USB: move to dma_transfer_direction
Date: Fri, 14 Oct 2011 11:08:24 +0530
Message-Id: <1318570705-17595-10-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1318570705-17595-1-git-send-email-vinod.koul@intel.com>
References: <1318570705-17595-1-git-send-email-vinod.koul@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vinod Koul <vinod.koul@linux.intel.com>

Signed-off-by: Vinod Koul <vinod.koul@linux.intel.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/usb/musb/ux500_dma.c     |    4 ++--
 drivers/usb/renesas_usbhs/fifo.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/musb/ux500_dma.c b/drivers/usb/musb/ux500_dma.c
index ef4333f..9587bdd 100644
--- a/drivers/usb/musb/ux500_dma.c
+++ b/drivers/usb/musb/ux500_dma.c
@@ -112,7 +112,7 @@ static bool ux500_configure_channel(struct dma_channel *channel,
 	struct musb_hw_ep *hw_ep = ux500_channel->hw_ep;
 	struct dma_chan *dma_chan = ux500_channel->dma_chan;
 	struct dma_async_tx_descriptor *dma_desc;
-	enum dma_data_direction direction;
+	enum dma_transfer_direction direction;
 	struct scatterlist sg;
 	struct dma_slave_config slave_conf;
 	enum dma_slave_buswidth addr_width;
@@ -132,7 +132,7 @@ static bool ux500_configure_channel(struct dma_channel *channel,
 	sg_dma_address(&sg) = dma_addr;
 	sg_dma_len(&sg) = len;
 
-	direction = ux500_channel->is_tx ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
+	slave_dirn = ux500_channel->is_tx ? MEM_TO_DEV : DEV_TO_MEM;
 	addr_width = (len & 0x3) ? DMA_SLAVE_BUSWIDTH_1_BYTE :
 					DMA_SLAVE_BUSWIDTH_4_BYTES;
 
diff --git a/drivers/usb/renesas_usbhs/fifo.c b/drivers/usb/renesas_usbhs/fifo.c
index a34430f..f5bc370 100644
--- a/drivers/usb/renesas_usbhs/fifo.c
+++ b/drivers/usb/renesas_usbhs/fifo.c
@@ -591,10 +591,10 @@ static void usbhsf_dma_prepare_tasklet(unsigned long data)
 	struct dma_async_tx_descriptor *desc;
 	struct dma_chan *chan = usbhsf_dma_chan_get(fifo, pkt);
 	struct device *dev = usbhs_priv_to_dev(priv);
-	enum dma_data_direction dir;
+	enum dma_transfer_direction dir;
 	dma_cookie_t cookie;
 
-	dir = usbhs_pipe_is_dir_in(pipe) ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
+	dir = usbhs_pipe_is_dir_in(pipe) ? DEV_TO_MEM : MEM_TO_DEV;
 
 	sg_init_table(&sg, 1);
 	sg_set_page(&sg, virt_to_page(pkt->dma),
-- 
1.7.0.4

