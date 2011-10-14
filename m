Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933340Ab1JNQrl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 12:47:41 -0400
Received: from mga03.intel.com ([143.182.124.21]:62928 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933328Ab1JNQri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 12:47:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,347,1315206000"; 
   d="scan'208";a="62664821"
From: Vinod Koul <vinod.koul@linux.intel.com>
To: dan.j.williams@intel.com
Cc: linux-kernel@vger.kernel.org, jaswinder.singh@linaro.org,
        21cnbao@gmail.com, rmk@arm.linux.org.uk,
        Vinod Koul <vinod.koul@linux.intel.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 2/2] USB-renesas: move to dma_transfer_direction
Date: Fri, 14 Oct 2011 22:09:10 +0530
Message-Id: <1318610350-23335-2-git-send-email-vinod.koul@linux.intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1318570705-17595-1-git-send-email-vinod.koul@intel.com>
References: <1318570705-17595-1-git-send-email-vinod.koul@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixup usage of dma direction by introducing dma_transfer_direction,
this patch moves usb/renesas driver to use new enum

Signed-off-by: Vinod Koul <vinod.koul@linux.intel.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
v2: split the usb patch into two patches

 drivers/usb/renesas_usbhs/fifo.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

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

