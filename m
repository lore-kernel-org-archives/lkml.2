Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755750Ab1GJPhT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 11:37:19 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58949 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755354Ab1GJPgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 11:36:32 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com, Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 08/10] staging: et131x: add et1310_ prefix to et1310_mac.c functions
Date: Sun, 10 Jul 2011 16:35:33 +0100
Message-Id: <1310312135-28407-9-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1310312135-28407-1-git-send-email-mark.einon@gmail.com>
References: <1310312135-28407-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Making finger pointing that bit easier.
Tested on an ET-131x device.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et1310_mac.c     |   32 +++++++++++++++---------------
 drivers/staging/et131x/et1310_phy.c     |    4 +-
 drivers/staging/et131x/et131x.h         |   20 +++++++++---------
 drivers/staging/et131x/et131x_initpci.c |   10 ++++----
 drivers/staging/et131x/et131x_isr.c     |    2 +-
 drivers/staging/et131x/et131x_netdev.c  |    4 +-
 6 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/drivers/staging/et131x/et1310_mac.c b/drivers/staging/et131x/et1310_mac.c
index 21b6153..8d8bc8b 100644
--- a/drivers/staging/et131x/et1310_mac.c
+++ b/drivers/staging/et131x/et1310_mac.c
@@ -99,10 +99,10 @@
 #define COUNTER_MASK_12_BIT (COUNTER_WRAP_12_BIT - 1)
 
 /**
- * config_mac_regs1 - Initialize the first part of MAC regs
+ * et1310_config_mac_regs1 - Initialize the first part of MAC regs
  * @etdev: pointer to our adapter structure
  */
-void config_mac_regs1(struct et131x_adapter *etdev)
+void et1310_config_mac_regs1(struct et131x_adapter *etdev)
 {
 	struct mac_regs __iomem *macregs = &etdev->regs->mac;
 	u32 station1;
@@ -159,10 +159,10 @@ void config_mac_regs1(struct et131x_adapter *etdev)
 }
 
 /**
- * config_mac_regs2 - Initialize the second part of MAC regs
+ * et1310_config_mac_regs2 - Initialize the second part of MAC regs
  * @etdev: pointer to our adapter structure
  */
-void config_mac_regs2(struct et131x_adapter *etdev)
+void et1310_config_mac_regs2(struct et131x_adapter *etdev)
 {
 	int32_t delay = 0;
 	struct mac_regs __iomem *mac = &etdev->regs->mac;
@@ -235,7 +235,7 @@ void config_mac_regs2(struct et131x_adapter *etdev)
 	}
 }
 
-void config_rxmac_regs(struct et131x_adapter *etdev)
+void et1310_config_rxmac_regs(struct et131x_adapter *etdev)
 {
 	struct rxmac_regs __iomem *rxmac = &etdev->regs->rxmac;
 	u32 sa_lo;
@@ -295,7 +295,7 @@ void config_rxmac_regs(struct et131x_adapter *etdev)
 
 	/* Let's initialize the Unicast Packet filtering address */
 	if (etdev->PacketFilter & ET131X_PACKET_TYPE_DIRECTED) {
-		setup_device_for_unicast(etdev);
+		et1310_setup_device_for_unicast(etdev);
 		pf_ctrl |= 4;	/* Unicast filter */
 	} else {
 		writel(0, &rxmac->uni_pf_addr1);
@@ -306,7 +306,7 @@ void config_rxmac_regs(struct et131x_adapter *etdev)
 	/* Let's initialize the Multicast hash */
 	if (!(etdev->PacketFilter & ET131X_PACKET_TYPE_ALL_MULTICAST)) {
 		pf_ctrl |= 2;	/* Multicast filter */
-		setup_device_for_multicast(etdev);
+		et1310_setup_device_for_multicast(etdev);
 	}
 
 	/* Runt packet filtering.  Didn't work in version A silicon. */
@@ -365,7 +365,7 @@ void config_rxmac_regs(struct et131x_adapter *etdev)
 	writel(0x9, &rxmac->ctrl);
 }
 
-void config_txmac_regs(struct et131x_adapter *etdev)
+void et1310_config_txmac_regs(struct et131x_adapter *etdev)
 {
 	struct txmac_regs *txmac = &etdev->regs->txmac;
 
@@ -379,7 +379,7 @@ void config_txmac_regs(struct et131x_adapter *etdev)
 		writel(0x40, &txmac->cf_param);
 }
 
-void config_macstat_regs(struct et131x_adapter *etdev)
+void et1310_config_macstat_regs(struct et131x_adapter *etdev)
 {
 	struct macstat_regs __iomem *macstat =
 		&etdev->regs->macstat;
@@ -444,7 +444,7 @@ void config_macstat_regs(struct et131x_adapter *etdev)
 	writel(0xFFFE7E8B, &macstat->carry_reg2_mask);
 }
 
-void config_flow_control(struct et131x_adapter *etdev)
+void et1310_config_flow_control(struct et131x_adapter *etdev)
 {
 	if (etdev->duplex_mode == 0) {
 		etdev->flowcontrol = FLOW_NONE;
@@ -480,10 +480,10 @@ void config_flow_control(struct et131x_adapter *etdev)
 }
 
 /**
- * update_macstat_host_counters - Update the local copy of the statistics
+ * et1310_update_macstat_host_counters - Update the local copy of the statistics
  * @etdev: pointer to the adapter structure
  */
-void update_macstat_host_counters(struct et131x_adapter *etdev)
+void et1310_update_macstat_host_counters(struct et131x_adapter *etdev)
 {
 	struct ce_stats *stats = &etdev->stats;
 	struct macstat_regs __iomem *macstat =
@@ -508,14 +508,14 @@ void update_macstat_host_counters(struct et131x_adapter *etdev)
 }
 
 /**
- * handle_macstat_interrupt
+ * et1310_handle_macstat_interrupt
  * @etdev: pointer to the adapter structure
  *
  * One of the MACSTAT counters has wrapped.  Update the local copy of
  * the statistics held in the adapter structure, checking the "wrap"
  * bit for each counter.
  */
-void handle_macstat_interrupt(struct et131x_adapter *etdev)
+void et1310_handle_macstat_interrupt(struct et131x_adapter *etdev)
 {
 	u32 carry_reg1;
 	u32 carry_reg2;
@@ -565,7 +565,7 @@ void handle_macstat_interrupt(struct et131x_adapter *etdev)
 		etdev->stats.collisions           += COUNTER_WRAP_12_BIT;
 }
 
-void setup_device_for_multicast(struct et131x_adapter *etdev)
+void et1310_setup_device_for_multicast(struct et131x_adapter *etdev)
 {
 	struct rxmac_regs __iomem *rxmac = &etdev->regs->rxmac;
 	uint32_t nIndex;
@@ -613,7 +613,7 @@ void setup_device_for_multicast(struct et131x_adapter *etdev)
 	}
 }
 
-void setup_device_for_unicast(struct et131x_adapter *etdev)
+void et1310_setup_device_for_unicast(struct et131x_adapter *etdev)
 {
 	struct rxmac_regs __iomem *rxmac = &etdev->regs->rxmac;
 	u32 uni_pf1;
diff --git a/drivers/staging/et131x/et1310_phy.c b/drivers/staging/et131x/et1310_phy.c
index f6c35b6..3653426 100644
--- a/drivers/staging/et131x/et1310_phy.c
+++ b/drivers/staging/et131x/et1310_phy.c
@@ -846,7 +846,7 @@ void et131x_mii_check(struct et131x_adapter *etdev,
 				et131x_mii_write(etdev, 0x12, register18);
 			}
 
-			config_flow_control(etdev);
+			et1310_config_flow_control(etdev);
 
 			if (etdev->linkspeed == TRUEPHY_SPEED_1000MBPS &&
 					etdev->RegistryJumboPacket > 2048)
@@ -854,7 +854,7 @@ void et131x_mii_check(struct et131x_adapter *etdev,
 								   0x2000);
 
 			et131x_set_rx_dma_timer(etdev);
-			config_mac_regs2(etdev);
+			et1310_config_mac_regs2(etdev);
 		}
 	}
 }
diff --git a/drivers/staging/et131x/et131x.h b/drivers/staging/et131x/et131x.h
index c33594b..b201136 100644
--- a/drivers/staging/et131x/et131x.h
+++ b/drivers/staging/et131x/et131x.h
@@ -71,16 +71,16 @@ irqreturn_t et131x_isr(int irq, void *dev_id);
 void et131x_isr_handler(struct work_struct *work);
 
 /* et1310_mac.c */
-void config_mac_regs1(struct et131x_adapter *adapter);
-void config_mac_regs2(struct et131x_adapter *adapter);
-void config_rxmac_regs(struct et131x_adapter *adapter);
-void config_txmac_regs(struct et131x_adapter *adapter);
-void config_macstat_regs(struct et131x_adapter *adapter);
-void config_flow_control(struct et131x_adapter *adapter);
-void update_macstat_host_counters(struct et131x_adapter *adapter);
-void handle_macstat_interrupt(struct et131x_adapter *adapter);
-void setup_device_for_multicast(struct et131x_adapter *adapter);
-void setup_device_for_unicast(struct et131x_adapter *adapter);
+void et1310_config_mac_regs1(struct et131x_adapter *adapter);
+void et1310_config_mac_regs2(struct et131x_adapter *adapter);
+void et1310_config_rxmac_regs(struct et131x_adapter *adapter);
+void et1310_config_txmac_regs(struct et131x_adapter *adapter);
+void et1310_config_macstat_regs(struct et131x_adapter *adapter);
+void et1310_config_flow_control(struct et131x_adapter *adapter);
+void et1310_update_macstat_host_counters(struct et131x_adapter *adapter);
+void et1310_handle_macstat_interrupt(struct et131x_adapter *adapter);
+void et1310_setup_device_for_multicast(struct et131x_adapter *adapter);
+void et1310_setup_device_for_unicast(struct et131x_adapter *adapter);
 
 /* et131x_netdev.c */
 struct net_device *et131x_device_alloc(void);
diff --git a/drivers/staging/et131x/et131x_initpci.c b/drivers/staging/et131x/et131x_initpci.c
index 75b2c48..a8700b6 100644
--- a/drivers/staging/et131x/et131x_initpci.c
+++ b/drivers/staging/et131x/et131x_initpci.c
@@ -269,7 +269,7 @@ void et131x_error_timer_handler(unsigned long data)
 	pm_csr = readl(&etdev->regs->global.pm_csr);
 
 	if ((pm_csr & ET_PM_PHY_SW_COMA) == 0)
-		update_macstat_host_counters(etdev);
+		et1310_update_macstat_host_counters(etdev);
 	else
 		dev_err(&etdev->pdev->dev,
 		    "No interrupts, in PHY coma, pm_csr = 0x%x\n", pm_csr);
@@ -380,19 +380,19 @@ int et131x_adapter_setup(struct et131x_adapter *etdev)
 	/* Configure the JAGCore */
 	ConfigGlobalRegs(etdev);
 
-	config_mac_regs1(etdev);
+	et1310_config_mac_regs1(etdev);
 
 	/* Configure the MMC registers */
 	/* All we need to do is initialize the Memory Control Register */
 	writel(ET_MMC_ENABLE, &etdev->regs->mmc.mmc_ctrl);
 
-	config_rxmac_regs(etdev);
-	config_txmac_regs(etdev);
+	et1310_config_rxmac_regs(etdev);
+	et1310_config_txmac_regs(etdev);
 
 	et131x_config_rx_dma_regs(etdev);
 	ConfigTxDmaRegs(etdev);
 
-	config_macstat_regs(etdev);
+	et1310_config_macstat_regs(etdev);
 
 	/* Move the following code to Timer function?? */
 	status = et131x_xcvr_find(etdev);
diff --git a/drivers/staging/et131x/et131x_isr.c b/drivers/staging/et131x/et131x_isr.c
index 33d432f..9b316be 100644
--- a/drivers/staging/et131x/et131x_isr.c
+++ b/drivers/staging/et131x/et131x_isr.c
@@ -461,7 +461,7 @@ void et131x_isr_handler(struct work_struct *work)
 			 * to maintain the top, software managed bits of the
 			 * counter(s).
 			 */
-			handle_macstat_interrupt(etdev);
+			et1310_handle_macstat_interrupt(etdev);
 		}
 
 		/* Handle SLV Timeout Interrupt */
diff --git a/drivers/staging/et131x/et131x_netdev.c b/drivers/staging/et131x/et131x_netdev.c
index 0f12b58..546acb3 100644
--- a/drivers/staging/et131x/et131x_netdev.c
+++ b/drivers/staging/et131x/et131x_netdev.c
@@ -301,14 +301,14 @@ int et131x_set_packet_filter(struct et131x_adapter *adapter)
 		if (filter & ET131X_PACKET_TYPE_ALL_MULTICAST)
 			pf_ctrl &= ~2;	/* Multicast filter bit */
 		else {
-			setup_device_for_multicast(adapter);
+			et1310_setup_device_for_multicast(adapter);
 			pf_ctrl |= 2;
 			ctrl &= ~0x04;
 		}
 
 		/* Set us up with Unicast packet filtering */
 		if (filter & ET131X_PACKET_TYPE_DIRECTED) {
-			setup_device_for_unicast(adapter);
+			et1310_setup_device_for_unicast(adapter);
 			pf_ctrl |= 4;
 			ctrl &= ~0x04;
 		}
-- 
1.7.4.4

