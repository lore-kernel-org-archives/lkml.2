Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422779Ab2JLPPf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 11:15:35 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:49130 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932303Ab2JLPPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 11:15:32 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc: jonathan@jonmasters.org, eric.dumazet@gmail.com,
        Mark Langsdorf <mark.langsdorf@calxeda.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 2/6] net: calxedaxgmac: remove explicit rx dma buffer polling
Date: Fri, 12 Oct 2012 10:15:04 -0500
Message-Id: <1350054908-30646-3-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350054908-30646-1-git-send-email-robherring2@gmail.com>
References: <1350054908-30646-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

New received frames will trigger the rx DMA to poll the DMA descriptors,
so there is no need to tell the h/w to poll. We also want to enable
dropping frames from the fifo when there is no buffer.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
---
 drivers/net/ethernet/calxeda/xgmac.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/calxeda/xgmac.c b/drivers/net/ethernet/calxeda/xgmac.c
index 7f5fd17..728fcef 100644
--- a/drivers/net/ethernet/calxeda/xgmac.c
+++ b/drivers/net/ethernet/calxeda/xgmac.c
@@ -966,7 +966,7 @@ static int xgmac_hw_init(struct net_device *dev)
 		ctrl |= XGMAC_CONTROL_IPC;
 	writel(ctrl, ioaddr + XGMAC_CONTROL);
 
-	writel(DMA_CONTROL_DFF | DMA_CONTROL_OSF, ioaddr + XGMAC_DMA_CONTROL);
+	writel(DMA_CONTROL_OSF, ioaddr + XGMAC_DMA_CONTROL);
 
 	/* Set the HW DMA mode and the COE */
 	writel(XGMAC_OMR_TSF | XGMAC_OMR_RFD | XGMAC_OMR_RFA |
@@ -1180,8 +1180,6 @@ static int xgmac_rx(struct xgmac_priv *priv, int limit)
 
 	xgmac_rx_refill(priv);
 
-	writel(1, priv->base + XGMAC_DMA_RX_POLL);
-
 	return count;
 }
 
-- 
1.7.9.5

