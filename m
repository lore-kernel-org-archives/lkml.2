Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057Ab1JNFrn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 01:47:43 -0400
Received: from mga14.intel.com ([143.182.124.37]:62630 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932552Ab1JNFre (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 01:47:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,344,1315206000"; 
   d="scan'208";a="62487077"
From: Vinod Koul <vinod.koul@intel.com>
To: dan.j.williams@intel.com
Cc: linux-kernel@vger.kernel.org, jaswinder.singh@linaro.org,
        21cnbao@gmail.com, rmk@arm.linux.org.uk,
        Vinod Koul <vinod.koul@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 10/10] net-ks8842: move to dma_transfer_direction
Date: Fri, 14 Oct 2011 11:08:25 +0530
Message-Id: <1318570705-17595-11-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1318570705-17595-1-git-send-email-vinod.koul@intel.com>
References: <1318570705-17595-1-git-send-email-vinod.koul@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vinod Koul <vinod.koul@linux.intel.com>

Signed-off-by: Vinod Koul <vinod.koul@linux.intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/net/ks8842.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ks8842.c b/drivers/net/ks8842.c
index 4a6ae05..7ca0640 100644
--- a/drivers/net/ks8842.c
+++ b/drivers/net/ks8842.c
@@ -459,7 +459,7 @@ static int ks8842_tx_frame_dma(struct sk_buff *skb, struct net_device *netdev)
 		sg_dma_len(&ctl->sg) += 4 - sg_dma_len(&ctl->sg) % 4;
 
 	ctl->adesc = ctl->chan->device->device_prep_slave_sg(ctl->chan,
-		&ctl->sg, 1, DMA_TO_DEVICE,
+		&ctl->sg, 1, MEM_TO_DEV,
 		DMA_PREP_INTERRUPT | DMA_COMPL_SKIP_SRC_UNMAP);
 	if (!ctl->adesc)
 		return NETDEV_TX_BUSY;
@@ -571,7 +571,7 @@ static int __ks8842_start_new_rx_dma(struct net_device *netdev)
 		sg_dma_len(sg) = DMA_BUFFER_SIZE;
 
 		ctl->adesc = ctl->chan->device->device_prep_slave_sg(ctl->chan,
-			sg, 1, DMA_FROM_DEVICE,
+			sg, 1, DEV_TO_MEM,
 			DMA_PREP_INTERRUPT | DMA_COMPL_SKIP_SRC_UNMAP);
 
 		if (!ctl->adesc)
-- 
1.7.0.4

