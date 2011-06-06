Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757001Ab1FFSIT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 14:08:19 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57786 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756584Ab1FFSHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 14:07:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Gk386bR+90mI8OBHZzaXGCc2Sghb96ShVwehnwIUF2x9tgnn6XqXOeNe8SVUkzkb9+
         gIy8gjbXc2P2gZfkIQKzKuB4r21IhOLCrWvUAbaOl0zLiWkb1ipvdBsLlaAEMuFoNGrq
         /jr9RFnRf95rujh+8NMkPTjYwxwjH0VCqz9vA=
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com, alan@lxorguk.ukuu.org.uk,
        Mark Einon <mark.einon@gmail.com>
Subject: [PATCH v2 7/7] staging: et131x: Removing '_t' from ce_stats_t struct
Date: Mon,  6 Jun 2011 19:07:04 +0100
Message-Id: <1307383624-8740-8-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1307383624-8740-1-git-send-email-mark.einon@gmail.com>
References: <1307295320-31716-1-git-send-email-mark.einon@gmail.com>
 <1307383624-8740-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing '_t' from ce_stats_t struct name and renaming et131x_adapter ce_stats member from
 'Stats' to 'stats'

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et1310_mac.c     |   30 +++++++++++++++---------------
 drivers/staging/et131x/et1310_phy.c     |    6 +++---
 drivers/staging/et131x/et1310_rx.c      |   10 +++++-----
 drivers/staging/et131x/et1310_tx.c      |    8 ++++----
 drivers/staging/et131x/et131x.h         |    2 +-
 drivers/staging/et131x/et131x_adapter.h |    4 ++--
 drivers/staging/et131x/et131x_isr.c     |    4 ++--
 drivers/staging/et131x/et131x_netdev.c  |    4 ++--
 8 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/drivers/staging/et131x/et1310_mac.c b/drivers/staging/et131x/et1310_mac.c
index 5a745cf..b1a7183 100644
--- a/drivers/staging/et131x/et1310_mac.c
+++ b/drivers/staging/et131x/et1310_mac.c
@@ -452,7 +452,7 @@ void ConfigFlowControl(struct et131x_adapter *etdev)
  */
 void UpdateMacStatHostCounters(struct et131x_adapter *etdev)
 {
-	struct ce_stats_t *stats = &etdev->Stats;
+	struct ce_stats *stats = &etdev->stats;
 	struct macstat_regs __iomem *macstat =
 		&etdev->regs->macstat;
 
@@ -503,33 +503,33 @@ void HandleMacStatInterrupt(struct et131x_adapter *etdev)
 	 * block indicates that one of the counters has wrapped.
 	 */
 	if (Carry1 & (1 << 14))
-		etdev->Stats.code_violations += COUNTER_WRAP_16_BIT;
+		etdev->stats.code_violations += COUNTER_WRAP_16_BIT;
 	if (Carry1 & (1 << 8))
-		etdev->Stats.alignment_err += COUNTER_WRAP_12_BIT;
+		etdev->stats.alignment_err += COUNTER_WRAP_12_BIT;
 	if (Carry1 & (1 << 7))
-		etdev->Stats.length_err += COUNTER_WRAP_16_BIT;
+		etdev->stats.length_err += COUNTER_WRAP_16_BIT;
 	if (Carry1 & (1 << 2))
-		etdev->Stats.other_errors += COUNTER_WRAP_16_BIT;
+		etdev->stats.other_errors += COUNTER_WRAP_16_BIT;
 	if (Carry1 & (1 << 6))
-		etdev->Stats.crc_err += COUNTER_WRAP_16_BIT;
+		etdev->stats.crc_err += COUNTER_WRAP_16_BIT;
 	if (Carry1 & (1 << 3))
-		etdev->Stats.rx_ov_flow += COUNTER_WRAP_16_BIT;
+		etdev->stats.rx_ov_flow += COUNTER_WRAP_16_BIT;
 	if (Carry1 & (1 << 0))
-		etdev->Stats.norcvbuf += COUNTER_WRAP_16_BIT;
+		etdev->stats.norcvbuf += COUNTER_WRAP_16_BIT;
 	if (Carry2 & (1 << 16))
-		etdev->Stats.max_pkt_error += COUNTER_WRAP_12_BIT;
+		etdev->stats.max_pkt_error += COUNTER_WRAP_12_BIT;
 	if (Carry2 & (1 << 15))
-		etdev->Stats.tx_uflo += COUNTER_WRAP_12_BIT;
+		etdev->stats.tx_uflo += COUNTER_WRAP_12_BIT;
 	if (Carry2 & (1 << 6))
-		etdev->Stats.first_collision += COUNTER_WRAP_12_BIT;
+		etdev->stats.first_collision += COUNTER_WRAP_12_BIT;
 	if (Carry2 & (1 << 8))
-		etdev->Stats.tx_deferred += COUNTER_WRAP_12_BIT;
+		etdev->stats.tx_deferred += COUNTER_WRAP_12_BIT;
 	if (Carry2 & (1 << 5))
-		etdev->Stats.excessive_collisions += COUNTER_WRAP_12_BIT;
+		etdev->stats.excessive_collisions += COUNTER_WRAP_12_BIT;
 	if (Carry2 & (1 << 4))
-		etdev->Stats.late_collisions += COUNTER_WRAP_12_BIT;
+		etdev->stats.late_collisions += COUNTER_WRAP_12_BIT;
 	if (Carry2 & (1 << 2))
-		etdev->Stats.collisions += COUNTER_WRAP_12_BIT;
+		etdev->stats.collisions += COUNTER_WRAP_12_BIT;
 }
 
 void SetupDeviceForMulticast(struct et131x_adapter *etdev)
diff --git a/drivers/staging/et131x/et1310_phy.c b/drivers/staging/et131x/et1310_phy.c
index 190db0b..1df0d05 100644
--- a/drivers/staging/et131x/et1310_phy.c
+++ b/drivers/staging/et131x/et1310_phy.c
@@ -178,7 +178,7 @@ int MiWrite(struct et131x_adapter *etdev, u8 xcvrReg, u16 value)
 {
 	struct mac_regs __iomem *mac = &etdev->regs->mac;
 	int status = 0;
-	u8 xcvrAddr = etdev->Stats.xcvr_addr;
+	u8 xcvrAddr = etdev->stats.xcvr_addr;
 	u32 delay;
 	u32 miiAddr;
 	u32 miiCmd;
@@ -259,8 +259,8 @@ int et131x_xcvr_find(struct et131x_adapter *etdev)
 		xcvr_id = (u32) ((idr1 << 16) | idr2);
 
 		if (idr1 != 0 && idr1 != 0xffff) {
-			etdev->Stats.xcvr_id = xcvr_id;
-			etdev->Stats.xcvr_addr = xcvr_addr;
+			etdev->stats.xcvr_id = xcvr_id;
+			etdev->stats.xcvr_addr = xcvr_addr;
 			return 0;
 		}
 	}
diff --git a/drivers/staging/et131x/et1310_rx.c b/drivers/staging/et131x/et1310_rx.c
index cd72a0b..100ee9b4 100644
--- a/drivers/staging/et131x/et1310_rx.c
+++ b/drivers/staging/et131x/et1310_rx.c
@@ -971,7 +971,7 @@ struct rfd *nic_rx_pkts(struct et131x_adapter *etdev)
 	 * also counted here.
 	 */
 	if (len < (NIC_MIN_PACKET_SIZE + 4)) {
-		etdev->Stats.other_errors++;
+		etdev->stats.other_errors++;
 		len = 0;
 	}
 
@@ -1039,16 +1039,16 @@ struct rfd *nic_rx_pkts(struct et131x_adapter *etdev)
 			}
 
 			if (len > 0)
-				etdev->Stats.multircv++;
+				etdev->stats.multircv++;
 		} else if (word0 & ALCATEL_BROADCAST_PKT)
-			etdev->Stats.brdcstrcv++;
+			etdev->stats.brdcstrcv++;
 		else
 			/* Not sure what this counter measures in
 			 * promiscuous mode. Perhaps we should check
 			 * the MAC address to see if it is directed
 			 * to us in promiscuous mode.
 			 */
-			etdev->Stats.unircv++;
+			etdev->stats.unircv++;
 	}
 
 	if (len > 0) {
@@ -1132,7 +1132,7 @@ void et131x_handle_recv_interrupt(struct et131x_adapter *etdev)
 		}
 
 		/* Increment the number of packets we received */
-		etdev->Stats.ipackets++;
+		etdev->stats.ipackets++;
 
 		/* Set the status on the packet, either resources or success */
 		if (etdev->rx_ring.nReadyRecv < RFD_LOW_WATER_MARK) {
diff --git a/drivers/staging/et131x/et1310_tx.c b/drivers/staging/et131x/et1310_tx.c
index 4241d2a..b8f8dae 100644
--- a/drivers/staging/et131x/et1310_tx.c
+++ b/drivers/staging/et131x/et1310_tx.c
@@ -635,11 +635,11 @@ inline void et131x_free_send_packet(struct et131x_adapter *etdev,
 	struct net_device_stats *stats = &etdev->net_stats;
 
 	if (tcb->flags & fMP_DEST_BROAD)
-		atomic_inc(&etdev->Stats.brdcstxmt);
+		atomic_inc(&etdev->stats.brdcstxmt);
 	else if (tcb->flags & fMP_DEST_MULTI)
-		atomic_inc(&etdev->Stats.multixmt);
+		atomic_inc(&etdev->stats.multixmt);
 	else
-		atomic_inc(&etdev->Stats.unixmt);
+		atomic_inc(&etdev->stats.unixmt);
 
 	if (tcb->skb) {
 		stats->tx_bytes += tcb->skb->len;
@@ -673,7 +673,7 @@ inline void et131x_free_send_packet(struct et131x_adapter *etdev,
 	/* Add the TCB to the Ready Q */
 	spin_lock_irqsave(&etdev->TCBReadyQLock, flags);
 
-	etdev->Stats.opackets++;
+	etdev->stats.opackets++;
 
 	if (etdev->tx_ring.tcb_qtail)
 		etdev->tx_ring.tcb_qtail->next = tcb;
diff --git a/drivers/staging/et131x/et131x.h b/drivers/staging/et131x/et131x.h
index 8aa3365..e425147 100644
--- a/drivers/staging/et131x/et131x.h
+++ b/drivers/staging/et131x/et131x.h
@@ -108,7 +108,7 @@ void et131x_setphy_normal(struct et131x_adapter *adapter);
 int PhyMiRead(struct et131x_adapter *adapter, u8 xcvrAddr,
 	      u8 xcvrReg, u16 *value);
 #define MiRead(adapter, xcvrReg, value) \
-	PhyMiRead((adapter), (adapter)->Stats.xcvr_addr, (xcvrReg), (value))
+	PhyMiRead((adapter), (adapter)->stats.xcvr_addr, (xcvrReg), (value))
 
 int32_t MiWrite(struct et131x_adapter *adapter,
 		u8 xcvReg, u16 value);
diff --git a/drivers/staging/et131x/et131x_adapter.h b/drivers/staging/et131x/et131x_adapter.h
index 0cbf699..c6657f4 100644
--- a/drivers/staging/et131x/et131x_adapter.h
+++ b/drivers/staging/et131x/et131x_adapter.h
@@ -98,7 +98,7 @@ struct rfd {
 #define FLOW_NONE	3
 
 /* Struct to define some device statistics */
-struct ce_stats_t {
+struct ce_stats {
 	/* Link Input/Output stats */
 	uint64_t ipackets;	/* # of in packets */
 	uint64_t opackets;	/* # of out packets */
@@ -239,7 +239,7 @@ struct et131x_adapter {
 	u8 ReplicaPhyLoopbkPF;	/* Replica Enable Pass/Fail */
 
 	/* Stats */
-	struct ce_stats_t Stats;
+	struct ce_stats stats;
 
 	struct net_device_stats net_stats;
 	struct net_device_stats net_stats_prev;
diff --git a/drivers/staging/et131x/et131x_isr.c b/drivers/staging/et131x/et131x_isr.c
index 11700b5..19d6726 100644
--- a/drivers/staging/et131x/et131x_isr.c
+++ b/drivers/staging/et131x/et131x_isr.c
@@ -222,7 +222,7 @@ irqreturn_t et131x_isr(int irq, void *dev_id)
 	 * DPC. We will clear the software copy of that in that
 	 * routine.
 	 */
-	adapter->Stats.InterruptStatus = status;
+	adapter->stats.InterruptStatus = status;
 
 	/* Schedule the ISR handler as a bottom-half task in the
 	 * kernel's tq_immediate queue, and mark the queue for
@@ -244,7 +244,7 @@ void et131x_isr_handler(struct work_struct *work)
 {
 	struct et131x_adapter *etdev =
 		container_of(work, struct et131x_adapter, task);
-	u32 status = etdev->Stats.InterruptStatus;
+	u32 status = etdev->stats.InterruptStatus;
 	struct address_map __iomem *iomem = etdev->regs;
 
 	/*
diff --git a/drivers/staging/et131x/et131x_netdev.c b/drivers/staging/et131x/et131x_netdev.c
index 7cc4b48..2da5828 100644
--- a/drivers/staging/et131x/et131x_netdev.c
+++ b/drivers/staging/et131x/et131x_netdev.c
@@ -100,7 +100,7 @@ struct net_device_stats *et131x_stats(struct net_device *netdev)
 {
 	struct et131x_adapter *adapter = netdev_priv(netdev);
 	struct net_device_stats *stats = &adapter->net_stats;
-	struct ce_stats_t *devstat = &adapter->Stats;
+	struct ce_stats *devstat = &adapter->stats;
 
 	stats->rx_packets = devstat->ipackets;
 	stats->tx_packets = devstat->opackets;
@@ -218,7 +218,7 @@ int et131x_ioctl_mii(struct net_device *netdev, struct ifreq *reqbuf, int cmd)
 
 	switch (cmd) {
 	case SIOCGMIIPHY:
-		data->phy_id = etdev->Stats.xcvr_addr;
+		data->phy_id = etdev->stats.xcvr_addr;
 		break;
 
 	case SIOCGMIIREG:
-- 
1.7.4.4

