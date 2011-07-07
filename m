Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831Ab1GGWAA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 18:00:00 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:59422 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596Ab1GGV77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 17:59:59 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com, Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 1/2] staging: et131x: rename adapter->Flags to adapter->flags
Date: Thu,  7 Jul 2011 22:59:03 +0100
Message-Id: <1310075944-2679-1-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial rename of the adapter flags struct member to remove camel case.
Tested on a ET-131x device.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et1310_mac.c     |    2 +-
 drivers/staging/et131x/et1310_pm.c      |    4 ++--
 drivers/staging/et131x/et1310_rx.c      |    6 +++---
 drivers/staging/et131x/et1310_tx.c      |    2 +-
 drivers/staging/et131x/et131x_adapter.h |    2 +-
 drivers/staging/et131x/et131x_netdev.c  |   14 +++++++-------
 6 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/et131x/et1310_mac.c b/drivers/staging/et131x/et1310_mac.c
index b1a7183..e6c243a 100644
--- a/drivers/staging/et131x/et1310_mac.c
+++ b/drivers/staging/et131x/et1310_mac.c
@@ -229,7 +229,7 @@ void ConfigMACRegs2(struct et131x_adapter *etdev)
 	writel(ctl, &etdev->regs->txmac.ctl);
 
 	/* Ready to start the RXDMA/TXDMA engine */
-	if (etdev->Flags & fMP_ADAPTER_LOWER_POWER) {
+	if (etdev->flags & fMP_ADAPTER_LOWER_POWER) {
 		et131x_rx_dma_enable(etdev);
 		et131x_tx_dma_enable(etdev);
 	}
diff --git a/drivers/staging/et131x/et1310_pm.c b/drivers/staging/et131x/et1310_pm.c
index 2bc1944..29d4d66 100644
--- a/drivers/staging/et131x/et1310_pm.c
+++ b/drivers/staging/et131x/et1310_pm.c
@@ -121,7 +121,7 @@ void EnablePhyComa(struct et131x_adapter *etdev)
 
 	/* Stop sending packets. */
 	spin_lock_irqsave(&etdev->send_hw_lock, flags);
-	etdev->Flags |= fMP_ADAPTER_LOWER_POWER;
+	etdev->flags |= fMP_ADAPTER_LOWER_POWER;
 	spin_unlock_irqrestore(&etdev->send_hw_lock, flags);
 
 	/* Wait for outstanding Receive packets */
@@ -172,7 +172,7 @@ void DisablePhyComa(struct et131x_adapter *etdev)
 	et131x_adapter_setup(etdev);
 
 	/* Allow Tx to restart */
-	etdev->Flags &= ~fMP_ADAPTER_LOWER_POWER;
+	etdev->flags &= ~fMP_ADAPTER_LOWER_POWER;
 
 	/* Need to re-enable Rx. */
 	et131x_rx_dma_enable(etdev);
diff --git a/drivers/staging/et131x/et1310_rx.c b/drivers/staging/et131x/et1310_rx.c
index fc90096..7e386e0 100644
--- a/drivers/staging/et131x/et1310_rx.c
+++ b/drivers/staging/et131x/et1310_rx.c
@@ -394,7 +394,7 @@ int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 						   SLAB_HWCACHE_ALIGN,
 						   NULL);
 
-	adapter->Flags |= fMP_ADAPTER_RECV_LOOKASIDE;
+	adapter->flags |= fMP_ADAPTER_RECV_LOOKASIDE;
 
 	/* The RFDs are going to be put on lists later on, so initialize the
 	 * lists now.
@@ -528,9 +528,9 @@ void et131x_rx_dma_memory_free(struct et131x_adapter *adapter)
 	/* Free receive packet pool */
 
 	/* Destroy the lookaside (RFD) pool */
-	if (adapter->Flags & fMP_ADAPTER_RECV_LOOKASIDE) {
+	if (adapter->flags & fMP_ADAPTER_RECV_LOOKASIDE) {
 		kmem_cache_destroy(rx_ring->RecvLookaside);
-		adapter->Flags &= ~fMP_ADAPTER_RECV_LOOKASIDE;
+		adapter->flags &= ~fMP_ADAPTER_RECV_LOOKASIDE;
 	}
 
 	/* Free the FBR Lookup Table */
diff --git a/drivers/staging/et131x/et1310_tx.c b/drivers/staging/et131x/et1310_tx.c
index bb67192..8b1af64 100644
--- a/drivers/staging/et131x/et1310_tx.c
+++ b/drivers/staging/et131x/et1310_tx.c
@@ -307,7 +307,7 @@ int et131x_send_packets(struct sk_buff *skb, struct net_device *netdev)
 		/* We need to see if the link is up; if it's not, make the
 		 * netif layer think we're good and drop the packet
 		 */
-		if ((etdev->Flags & fMP_ADAPTER_FAIL_SEND_MASK) ||
+		if ((etdev->flags & fMP_ADAPTER_FAIL_SEND_MASK) ||
 					!netif_carrier_ok(netdev)) {
 			dev_kfree_skb_any(skb);
 			skb = NULL;
diff --git a/drivers/staging/et131x/et131x_adapter.h b/drivers/staging/et131x/et131x_adapter.h
index 39051df..408c50b 100644
--- a/drivers/staging/et131x/et131x_adapter.h
+++ b/drivers/staging/et131x/et131x_adapter.h
@@ -150,7 +150,7 @@ struct et131x_adapter {
 	struct work_struct task;
 
 	/* Flags that indicate current state of the adapter */
-	u32 Flags;
+	u32 flags;
 	u32 HwErrCount;
 
 	/* Configuration  */
diff --git a/drivers/staging/et131x/et131x_netdev.c b/drivers/staging/et131x/et131x_netdev.c
index 6bcddf1..5f25bba 100644
--- a/drivers/staging/et131x/et131x_netdev.c
+++ b/drivers/staging/et131x/et131x_netdev.c
@@ -162,7 +162,7 @@ int et131x_open(struct net_device *netdev)
 	/* Enable device interrupts */
 	et131x_enable_interrupts(adapter);
 
-	adapter->Flags |= fMP_ADAPTER_INTERRUPT_IN_USE;
+	adapter->flags |= fMP_ADAPTER_INTERRUPT_IN_USE;
 
 	/* We're ready to move some data, so start the queue */
 	netif_start_queue(netdev);
@@ -190,7 +190,7 @@ int et131x_close(struct net_device *netdev)
 	et131x_disable_interrupts(adapter);
 
 	/* Deregistering ISR */
-	adapter->Flags &= ~fMP_ADAPTER_INTERRUPT_IN_USE;
+	adapter->flags &= ~fMP_ADAPTER_INTERRUPT_IN_USE;
 	free_irq(netdev->irq, netdev);
 
 	/* Stop the error timer */
@@ -449,11 +449,11 @@ void et131x_tx_timeout(struct net_device *netdev)
 	/* Any nonrecoverable hardware error?
 	 * Checks adapter->flags for any failure in phy reading
 	 */
-	if (etdev->Flags & fMP_ADAPTER_NON_RECOVER_ERROR)
+	if (etdev->flags & fMP_ADAPTER_NON_RECOVER_ERROR)
 		return;
 
 	/* Hardware failure? */
-	if (etdev->Flags & fMP_ADAPTER_HARDWARE_ERROR) {
+	if (etdev->flags & fMP_ADAPTER_HARDWARE_ERROR) {
 		dev_err(&etdev->pdev->dev, "hardware error - reset\n");
 		return;
 	}
@@ -471,7 +471,7 @@ void et131x_tx_timeout(struct net_device *netdev)
 					       flags);
 
 			dev_warn(&etdev->pdev->dev,
-				"Send stuck - reset.  tcb->WrIndex %x, Flags 0x%08x\n",
+				"Send stuck - reset.  tcb->WrIndex %x, flags 0x%08x\n",
 				tcb->index,
 				tcb->flags);
 
@@ -540,7 +540,7 @@ int et131x_change_mtu(struct net_device *netdev, int new_mtu)
 	et131x_adapter_setup(adapter);
 
 	/* Enable interrupts */
-	if (adapter->Flags & fMP_ADAPTER_INTERRUPT_IN_USE)
+	if (adapter->flags & fMP_ADAPTER_INTERRUPT_IN_USE)
 		et131x_enable_interrupts(adapter);
 
 	/* Restart the Tx and Rx DMA engines */
@@ -622,7 +622,7 @@ int et131x_set_mac_addr(struct net_device *netdev, void *new_mac)
 	et131x_adapter_setup(adapter);
 
 	/* Enable interrupts */
-	if (adapter->Flags & fMP_ADAPTER_INTERRUPT_IN_USE)
+	if (adapter->flags & fMP_ADAPTER_INTERRUPT_IN_USE)
 		et131x_enable_interrupts(adapter);
 
 	/* Restart the Tx and Rx DMA engines */
-- 
1.7.4.4

