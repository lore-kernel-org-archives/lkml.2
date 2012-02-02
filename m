Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933402Ab2BBVgQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 16:36:16 -0500
Received: from mxout1.idt.com ([157.165.5.25]:57320 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757432Ab2BBVde (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 16:33:34 -0500
From: Alexandre Bounine <alexandre.bounine@idt.com>
To: vinod.koul@intel.com, dan.j.williams@intel.com,
        linux-kernel@vger.kernel.org
Cc: Alexandre Bounine <alexandre.bounine@idt.com>,
        "David S. Miller" <davem@davemloft.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dennis Aberilla <denzzzhome@yahoo.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Wan ZongShun <mcuos.com@gmail.com>
Subject: [PATCH 07/11] net/ks8842: add context parameter to prep_slave_sg call
Date: Thu,  2 Feb 2012 16:32:17 -0500
Message-Id: <1328218341-31436-8-git-send-email-alexandre.bounine@idt.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1328218341-31436-1-git-send-email-alexandre.bounine@idt.com>
References: <1328218341-31436-1-git-send-email-alexandre.bounine@idt.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixups for calls affected by adding the new context parameter to DMA_SLAVE
and DMA_CYCLIC interfaces.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Dennis Aberilla <denzzzhome@yahoo.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Wan ZongShun <mcuos.com@gmail.com>
---
 drivers/net/ethernet/micrel/ks8842.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ks8842.c b/drivers/net/ethernet/micrel/ks8842.c
index 0a85690..afc6b57 100644
--- a/drivers/net/ethernet/micrel/ks8842.c
+++ b/drivers/net/ethernet/micrel/ks8842.c
@@ -460,7 +460,7 @@ static int ks8842_tx_frame_dma(struct sk_buff *skb, struct net_device *netdev)
 
 	ctl->adesc = ctl->chan->device->device_prep_slave_sg(ctl->chan,
 		&ctl->sg, 1, DMA_MEM_TO_DEV,
-		DMA_PREP_INTERRUPT | DMA_COMPL_SKIP_SRC_UNMAP);
+		DMA_PREP_INTERRUPT | DMA_COMPL_SKIP_SRC_UNMAP, NULL);
 	if (!ctl->adesc)
 		return NETDEV_TX_BUSY;
 
@@ -572,7 +572,7 @@ static int __ks8842_start_new_rx_dma(struct net_device *netdev)
 
 		ctl->adesc = ctl->chan->device->device_prep_slave_sg(ctl->chan,
 			sg, 1, DMA_DEV_TO_MEM,
-			DMA_PREP_INTERRUPT | DMA_COMPL_SKIP_SRC_UNMAP);
+			DMA_PREP_INTERRUPT | DMA_COMPL_SKIP_SRC_UNMAP, NULL);
 
 		if (!ctl->adesc)
 			goto out;
-- 
1.7.8.4

