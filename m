Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581Ab1KMTpV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 14:45:21 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57523 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511Ab1KMTpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 14:45:19 -0500
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 2/2] staging: et131x: Remove section comments
Date: Sun, 13 Nov 2011 19:43:39 +0000
Message-Id: <1321213419-5853-2-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.7.1
In-Reply-To: <1321213419-5853-1-git-send-email-mark.einon@gmail.com>
References: <1321213419-5853-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following the move to put the driver into one file, comments were added to identify which source file each set of functions originated from.
These no longer made sense after functions were moved around to remove some forward declarations, so remove them.

A function comment was previously not moved along with its function, now they are reunited.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et131x.c |   46 +++++++++-----------------------------
 1 files changed, 11 insertions(+), 35 deletions(-)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index 819ef10..7ae3e53 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -177,9 +177,7 @@ MODULE_DESCRIPTION("10/100/1000 Base-T Ethernet Driver "
 
 /* RX defines */
 #define USE_FBR0 1
-
 #define FBR_CHUNKS 32
-
 #define MAX_DESC_PER_RING_RX         1024
 
 /* number of RFDs - default and min */
@@ -194,7 +192,6 @@ MODULE_DESCRIPTION("10/100/1000 Base-T Ethernet Driver "
 #endif
 
 #define NIC_MIN_NUM_RFD		64
-
 #define NUM_PACKETS_HANDLED	256
 
 #define ALCATEL_MULTICAST_PKT	0x01000000
@@ -426,7 +423,6 @@ struct tx_ring {
 	int since_irq;
 };
 
-/* ADAPTER defines */
 /*
  * Do not change these values: if changed, then change also in respective
  * TXdma and Rxdma engines
@@ -575,8 +571,6 @@ struct et131x_adapter {
 	struct net_device_stats net_stats;
 };
 
-/* EEPROM functions */
-
 static int eeprom_wait_ready(struct pci_dev *pdev, u32 *status)
 {
 	u32 reg;
@@ -947,19 +941,6 @@ static inline void add_12bit(u32 *v, int n)
 }
 
 /**
- * nic_rx_pkts - Checks the hardware for available packets
- * @adapter: pointer to our adapter
- *
- * Returns rfd, a pointer to our MPRFD.
- *
- * Checks the hardware for available packets, using completion ring
- * If packets are available, it gets an RFD from the recv_list, attaches
- * the packet to it, puts the RFD in the RecvPendList, and also returns
- * the pointer to the RFD.
- */
-/* MAC functions */
-
-/**
  * et1310_config_mac_regs1 - Initialize the first part of MAC regs
  * @adapter: pointer to our adapter structure
  */
@@ -1715,8 +1696,6 @@ static void et1310_handle_macstat_interrupt(struct et131x_adapter *adapter)
 		adapter->stats.tx_collisions	+= COUNTER_WRAP_12_BIT;
 }
 
-/* PHY functions */
-
 static int et131x_mdio_read(struct mii_bus *bus, int phy_addr, int reg)
 {
 	struct net_device *netdev = bus->priv;
@@ -1864,8 +1843,6 @@ static void et131x_configure_global_regs(struct et131x_adapter *adapter)
 	writel(0, &regs->watchdog_timer);
 }
 
-/* PM functions */
-
 /**
  * et131x_config_rx_dma_regs - Start of Rx_DMA init sequence
  * @adapter: pointer to our adapter structure
@@ -2272,8 +2249,6 @@ static void et1310_disable_phy_coma(struct et131x_adapter *adapter)
 	et131x_enable_txrx(adapter->netdev);
 }
 
-/* RX functions */
-
 static inline u32 bump_free_buff_ring(u32 *free_buff_ring, u32 limit)
 {
 	u32 tmp_free_buff_ring = *free_buff_ring;
@@ -2919,6 +2894,17 @@ static void nic_return_rfd(struct et131x_adapter *adapter, struct rfd *rfd)
 	WARN_ON(rx_local->num_ready_recv > rx_local->num_rfd);
 }
 
+/**
+ * nic_rx_pkts - Checks the hardware for available packets
+ * @adapter: pointer to our adapter
+ *
+ * Returns rfd, a pointer to our MPRFD.
+ *
+ * Checks the hardware for available packets, using completion ring
+ * If packets are available, it gets an RFD from the recv_list, attaches
+ * the packet to it, puts the RFD in the RecvPendList, and also returns
+ * the pointer to the RFD.
+ */
 static struct rfd *nic_rx_pkts(struct et131x_adapter *adapter)
 {
 	struct rx_ring *rx_local = &adapter->rx_ring;
@@ -3189,8 +3175,6 @@ static void et131x_handle_recv_interrupt(struct et131x_adapter *adapter)
 		adapter->rx_ring.unfinished_receives = false;
 }
 
-/* TX functions */
-
 /**
  * et131x_tx_dma_memory_alloc
  * @adapter: pointer to our private adapter structure
@@ -3799,8 +3783,6 @@ static void et131x_handle_send_interrupt(struct et131x_adapter *adapter)
 	spin_unlock_irqrestore(&adapter->tcb_send_qlock, flags);
 }
 
-/* ETHTOOL functions */
-
 static int et131x_get_settings(struct net_device *netdev,
 			       struct ethtool_cmd *cmd)
 {
@@ -3971,8 +3953,6 @@ static void et131x_set_ethtool_ops(struct net_device *netdev)
 	SET_ETHTOOL_OPS(netdev, &et131x_ethtool_ops);
 }
 
-/* PCI functions */
-
 /**
  * et131x_hwaddr_init - set up the MAC Address on the ET1310
  * @adapter: pointer to our private adapter structure
@@ -4483,8 +4463,6 @@ static SIMPLE_DEV_PM_OPS(et131x_pm_ops, et131x_suspend, et131x_resume);
 #define ET131X_PM_OPS NULL
 #endif
 
-/* ISR functions */
-
 /**
  * et131x_isr - The Interrupt Service Routine for the driver.
  * @irq: the IRQ on which the interrupt was received.
@@ -4782,8 +4760,6 @@ static void et131x_isr_handler(struct work_struct *work)
 	et131x_enable_interrupts(adapter);
 }
 
-/* NETDEV functions */
-
 /**
  * et131x_stats - Return the current device statistics.
  * @netdev: device whose stats are being queried
-- 
1.7.7.1

