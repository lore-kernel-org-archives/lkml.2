Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933326Ab1JNQrg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 12:47:36 -0400
Received: from mga03.intel.com ([143.182.124.21]:62928 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755225Ab1JNQrf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 12:47:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,347,1315206000"; 
   d="scan'208";a="62664793"
From: Vinod Koul <vinod.koul@linux.intel.com>
To: dan.j.williams@intel.com
Cc: linux-kernel@vger.kernel.org, jaswinder.singh@linaro.org,
        21cnbao@gmail.com, rmk@arm.linux.org.uk,
        Vinod Koul <vinod.koul@linux.intel.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH v2 1/2] USB-musb: move to dma_transfer_direction
Date: Fri, 14 Oct 2011 22:09:09 +0530
Message-Id: <1318610350-23335-1-git-send-email-vinod.koul@linux.intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1318570705-17595-1-git-send-email-vinod.koul@intel.com>
References: <1318570705-17595-1-git-send-email-vinod.koul@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixup usage of dma direction by introducing dma_transfer_direction,
this patch moves usb/musb driver to use new enum

Signed-off-by: Vinod Koul <vinod.koul@linux.intel.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
v2: split the usb patch into two patches
    fix the error of direction variable

 drivers/usb/musb/ux500_dma.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/musb/ux500_dma.c b/drivers/usb/musb/ux500_dma.c
index ef4333f..d5b5262 100644
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
+	direction = ux500_channel->is_tx ? MEM_TO_DEV : DEV_TO_MEM;
 	addr_width = (len & 0x3) ? DMA_SLAVE_BUSWIDTH_1_BYTE :
 					DMA_SLAVE_BUSWIDTH_4_BYTES;
 
-- 
1.7.0.4

