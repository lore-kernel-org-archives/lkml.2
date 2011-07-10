Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326Ab1GJPg3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 11:36:29 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38879 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881Ab1GJPgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 11:36:19 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com, Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 01/10] staging: et131x: Converting et1310_mac.c function and local names from CamelCase
Date: Sun, 10 Jul 2011 16:35:26 +0100
Message-Id: <1310312135-28407-2-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1310312135-28407-1-git-send-email-mark.einon@gmail.com>
References: <1310312135-28407-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tested on an ET-131x device.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et1310_mac.c     |  222 +++++++++++++++---------------
 drivers/staging/et131x/et1310_phy.c     |    4 +-
 drivers/staging/et131x/et131x.h         |   20 ++--
 drivers/staging/et131x/et131x_initpci.c |   12 +-
 drivers/staging/et131x/et131x_isr.c     |    2 +-
 drivers/staging/et131x/et131x_netdev.c  |    4 +-
 6 files changed, 132 insertions(+), 132 deletions(-)

diff --git a/drivers/staging/et131x/et1310_mac.c b/drivers/staging/et131x/et1310_mac.c
index 656be4b..db34c79 100644
--- a/drivers/staging/et131x/et1310_mac.c
+++ b/drivers/staging/et131x/et1310_mac.c
@@ -99,12 +99,12 @@
 #define COUNTER_MASK_12_BIT (COUNTER_WRAP_12_BIT - 1)
 
 /**
- * ConfigMacRegs1 - Initialize the first part of MAC regs
- * @pAdpater: pointer to our adapter structure
+ * config_mac_regs1 - Initialize the first part of MAC regs
+ * @etdev: pointer to our adapter structure
  */
-void ConfigMACRegs1(struct et131x_adapter *etdev)
+void config_mac_regs1(struct et131x_adapter *etdev)
 {
-	struct mac_regs __iomem *pMac = &etdev->regs->mac;
+	struct mac_regs __iomem *macregs = &etdev->regs->mac;
 	u32 station1;
 	u32 station2;
 	u32 ipg;
@@ -112,22 +112,22 @@ void ConfigMACRegs1(struct et131x_adapter *etdev)
 	/* First we need to reset everything.  Write to MAC configuration
 	 * register 1 to perform reset.
 	 */
-	writel(0xC00F0000, &pMac->cfg1);
+	writel(0xC00F0000, &macregs->cfg1);
 
 	/* Next lets configure the MAC Inter-packet gap register */
 	ipg = 0x38005860;		/* IPG1 0x38 IPG2 0x58 B2B 0x60 */
 	ipg |= 0x50 << 8;		/* ifg enforce 0x50 */
-	writel(ipg, &pMac->ipg);
+	writel(ipg, &macregs->ipg);
 
 	/* Next lets configure the MAC Half Duplex register */
 	/* BEB trunc 0xA, Ex Defer, Rexmit 0xF Coll 0x37 */
-	writel(0x00A1F037, &pMac->hfdp);
+	writel(0x00A1F037, &macregs->hfdp);
 
 	/* Next lets configure the MAC Interface Control register */
-	writel(0, &pMac->if_ctrl);
+	writel(0, &macregs->if_ctrl);
 
 	/* Let's move on to setting up the mii management configuration */
-	writel(0x07, &pMac->mii_mgmt_cfg);	/* Clock reset 0x7 */
+	writel(0x07, &macregs->mii_mgmt_cfg);	/* Clock reset 0x7 */
 
 	/* Next lets configure the MAC Station Address register.  These
 	 * values are read from the EEPROM during initialization and stored
@@ -142,8 +142,8 @@ void ConfigMACRegs1(struct et131x_adapter *etdev)
 		   (etdev->addr[4] << ET_MAC_STATION_ADDR1_OC5_SHIFT) |
 		   (etdev->addr[3] << ET_MAC_STATION_ADDR1_OC4_SHIFT) |
 		    etdev->addr[2];
-	writel(station1, &pMac->station_addr_1);
-	writel(station2, &pMac->station_addr_2);
+	writel(station1, &macregs->station_addr_1);
+	writel(station2, &macregs->station_addr_2);
 
 	/* Max ethernet packet in bytes that will passed by the mac without
 	 * being truncated.  Allow the MAC to pass 4 more than our max packet
@@ -152,29 +152,29 @@ void ConfigMACRegs1(struct et131x_adapter *etdev)
 	 * Packets larger than (RegistryJumboPacket) that do not contain a
 	 * VLAN ID will be dropped by the Rx function.
 	 */
-	writel(etdev->RegistryJumboPacket + 4, &pMac->max_fm_len);
+	writel(etdev->RegistryJumboPacket + 4, &macregs->max_fm_len);
 
 	/* clear out MAC config reset */
-	writel(0, &pMac->cfg1);
+	writel(0, &macregs->cfg1);
 }
 
 /**
- * ConfigMacRegs2 - Initialize the second part of MAC regs
- * @pAdpater: pointer to our adapter structure
+ * config_mac_regs2 - Initialize the second part of MAC regs
+ * @etdev: pointer to our adapter structure
  */
-void ConfigMACRegs2(struct et131x_adapter *etdev)
+void config_mac_regs2(struct et131x_adapter *etdev)
 {
 	int32_t delay = 0;
-	struct mac_regs __iomem *pMac = &etdev->regs->mac;
+	struct mac_regs __iomem *mac = &etdev->regs->mac;
 	u32 cfg1;
 	u32 cfg2;
 	u32 ifctrl;
 	u32 ctl;
 
 	ctl = readl(&etdev->regs->txmac.ctl);
-	cfg1 = readl(&pMac->cfg1);
-	cfg2 = readl(&pMac->cfg2);
-	ifctrl = readl(&pMac->if_ctrl);
+	cfg1 = readl(&mac->cfg1);
+	cfg2 = readl(&mac->cfg2);
+	ifctrl = readl(&mac->if_ctrl);
 
 	/* Set up the if mode bits */
 	cfg2 &= ~0x300;
@@ -188,12 +188,12 @@ void ConfigMACRegs2(struct et131x_adapter *etdev)
 	}
 
 	/* We need to enable Rx/Tx */
-	cfg1 |= CFG1_RX_ENABLE|CFG1_TX_ENABLE|CFG1_TX_FLOW;
+	cfg1 |= CFG1_RX_ENABLE | CFG1_TX_ENABLE | CFG1_TX_FLOW;
 	/* Initialize loop back to off */
-	cfg1 &= ~(CFG1_LOOPBACK|CFG1_RX_FLOW);
+	cfg1 &= ~(CFG1_LOOPBACK | CFG1_RX_FLOW);
 	if (etdev->flowcontrol == FLOW_RXONLY || etdev->flowcontrol == FLOW_BOTH)
 		cfg1 |= CFG1_RX_FLOW;
-	writel(cfg1, &pMac->cfg1);
+	writel(cfg1, &mac->cfg1);
 
 	/* Now we need to initialize the MAC Configuration 2 register */
 	/* preamble 7, check length, huge frame off, pad crc, crc enable
@@ -209,13 +209,13 @@ void ConfigMACRegs2(struct et131x_adapter *etdev)
 	if (!etdev->duplex_mode)
 		ifctrl |= (1<<26);	/* Enable ghd */
 
-	writel(ifctrl, &pMac->if_ctrl);
-	writel(cfg2, &pMac->cfg2);
+	writel(ifctrl, &mac->if_ctrl);
+	writel(cfg2, &mac->cfg2);
 
 	do {
 		udelay(10);
 		delay++;
-		cfg1 = readl(&pMac->cfg1);
+		cfg1 = readl(&mac->cfg1);
 	} while ((cfg1 & CFG1_WAIT) != CFG1_WAIT && delay < 100);
 
 	if (delay == 100) {
@@ -224,7 +224,7 @@ void ConfigMACRegs2(struct et131x_adapter *etdev)
 			cfg1);
 	}
 
-	/* Enable TXMAC */
+	/* Enable txmac */
 	ctl |= 0x09;	/* TX mac enable, FC disable */
 	writel(ctl, &etdev->regs->txmac.ctl);
 
@@ -235,78 +235,78 @@ void ConfigMACRegs2(struct et131x_adapter *etdev)
 	}
 }
 
-void ConfigRxMacRegs(struct et131x_adapter *etdev)
+void config_rxmac_regs(struct et131x_adapter *etdev)
 {
-	struct rxmac_regs __iomem *pRxMac = &etdev->regs->rxmac;
+	struct rxmac_regs __iomem *rxmac = &etdev->regs->rxmac;
 	u32 sa_lo;
 	u32 sa_hi = 0;
 	u32 pf_ctrl = 0;
 
 	/* Disable the MAC while it is being configured (also disable WOL) */
-	writel(0x8, &pRxMac->ctrl);
+	writel(0x8, &rxmac->ctrl);
 
 	/* Initialize WOL to disabled. */
-	writel(0, &pRxMac->crc0);
-	writel(0, &pRxMac->crc12);
-	writel(0, &pRxMac->crc34);
+	writel(0, &rxmac->crc0);
+	writel(0, &rxmac->crc12);
+	writel(0, &rxmac->crc34);
 
 	/* We need to set the WOL mask0 - mask4 next.  We initialize it to
 	 * its default Values of 0x00000000 because there are not WOL masks
 	 * as of this time.
 	 */
-	writel(0, &pRxMac->mask0_word0);
-	writel(0, &pRxMac->mask0_word1);
-	writel(0, &pRxMac->mask0_word2);
-	writel(0, &pRxMac->mask0_word3);
-
-	writel(0, &pRxMac->mask1_word0);
-	writel(0, &pRxMac->mask1_word1);
-	writel(0, &pRxMac->mask1_word2);
-	writel(0, &pRxMac->mask1_word3);
-
-	writel(0, &pRxMac->mask2_word0);
-	writel(0, &pRxMac->mask2_word1);
-	writel(0, &pRxMac->mask2_word2);
-	writel(0, &pRxMac->mask2_word3);
-
-	writel(0, &pRxMac->mask3_word0);
-	writel(0, &pRxMac->mask3_word1);
-	writel(0, &pRxMac->mask3_word2);
-	writel(0, &pRxMac->mask3_word3);
-
-	writel(0, &pRxMac->mask4_word0);
-	writel(0, &pRxMac->mask4_word1);
-	writel(0, &pRxMac->mask4_word2);
-	writel(0, &pRxMac->mask4_word3);
+	writel(0, &rxmac->mask0_word0);
+	writel(0, &rxmac->mask0_word1);
+	writel(0, &rxmac->mask0_word2);
+	writel(0, &rxmac->mask0_word3);
+
+	writel(0, &rxmac->mask1_word0);
+	writel(0, &rxmac->mask1_word1);
+	writel(0, &rxmac->mask1_word2);
+	writel(0, &rxmac->mask1_word3);
+
+	writel(0, &rxmac->mask2_word0);
+	writel(0, &rxmac->mask2_word1);
+	writel(0, &rxmac->mask2_word2);
+	writel(0, &rxmac->mask2_word3);
+
+	writel(0, &rxmac->mask3_word0);
+	writel(0, &rxmac->mask3_word1);
+	writel(0, &rxmac->mask3_word2);
+	writel(0, &rxmac->mask3_word3);
+
+	writel(0, &rxmac->mask4_word0);
+	writel(0, &rxmac->mask4_word1);
+	writel(0, &rxmac->mask4_word2);
+	writel(0, &rxmac->mask4_word3);
 
 	/* Lets setup the WOL Source Address */
 	sa_lo = (etdev->addr[2] << ET_WOL_LO_SA3_SHIFT) |
 		(etdev->addr[3] << ET_WOL_LO_SA4_SHIFT) |
 		(etdev->addr[4] << ET_WOL_LO_SA5_SHIFT) |
 		 etdev->addr[5];
-	writel(sa_lo, &pRxMac->sa_lo);
+	writel(sa_lo, &rxmac->sa_lo);
 
 	sa_hi = (u32) (etdev->addr[0] << ET_WOL_HI_SA1_SHIFT) |
 	               etdev->addr[1];
-	writel(sa_hi, &pRxMac->sa_hi);
+	writel(sa_hi, &rxmac->sa_hi);
 
 	/* Disable all Packet Filtering */
-	writel(0, &pRxMac->pf_ctrl);
+	writel(0, &rxmac->pf_ctrl);
 
 	/* Let's initialize the Unicast Packet filtering address */
 	if (etdev->PacketFilter & ET131X_PACKET_TYPE_DIRECTED) {
-		SetupDeviceForUnicast(etdev);
+		setup_device_for_unicast(etdev);
 		pf_ctrl |= 4;	/* Unicast filter */
 	} else {
-		writel(0, &pRxMac->uni_pf_addr1);
-		writel(0, &pRxMac->uni_pf_addr2);
-		writel(0, &pRxMac->uni_pf_addr3);
+		writel(0, &rxmac->uni_pf_addr1);
+		writel(0, &rxmac->uni_pf_addr2);
+		writel(0, &rxmac->uni_pf_addr3);
 	}
 
 	/* Let's initialize the Multicast hash */
 	if (!(etdev->PacketFilter & ET131X_PACKET_TYPE_ALL_MULTICAST)) {
 		pf_ctrl |= 2;	/* Multicast filter */
-		SetupDeviceForMulticast(etdev);
+		setup_device_for_multicast(etdev);
 	}
 
 	/* Runt packet filtering.  Didn't work in version A silicon. */
@@ -324,18 +324,18 @@ void ConfigRxMacRegs(struct et131x_adapter *etdev)
 		 *
 		 * seg_en on, fc_en off, size 0x10
 		 */
-		writel(0x41, &pRxMac->mcif_ctrl_max_seg);
+		writel(0x41, &rxmac->mcif_ctrl_max_seg);
 	else
-		writel(0, &pRxMac->mcif_ctrl_max_seg);
+		writel(0, &rxmac->mcif_ctrl_max_seg);
 
 	/* Initialize the MCIF water marks */
-	writel(0, &pRxMac->mcif_water_mark);
+	writel(0, &rxmac->mcif_water_mark);
 
 	/*  Initialize the MIF control */
-	writel(0, &pRxMac->mif_ctrl);
+	writel(0, &rxmac->mif_ctrl);
 
 	/* Initialize the Space Available Register */
-	writel(0, &pRxMac->space_avail);
+	writel(0, &rxmac->space_avail);
 
 	/* Initialize the the mif_ctrl register
 	 * bit 3:  Receive code error. One or more nibbles were signaled as
@@ -351,9 +351,9 @@ void ConfigRxMacRegs(struct et131x_adapter *etdev)
 	 * bit 17: Drop packet enable
 	 */
 	if (etdev->linkspeed == TRUEPHY_SPEED_100MBPS)
-		writel(0x30038, &pRxMac->mif_ctrl);
+		writel(0x30038, &rxmac->mif_ctrl);
 	else
-		writel(0x30030, &pRxMac->mif_ctrl);
+		writel(0x30030, &rxmac->mif_ctrl);
 
 	/* Finally we initialize RxMac to be enabled & WOL disabled.  Packet
 	 * filter is always enabled since it is where the runt packets are
@@ -361,11 +361,11 @@ void ConfigRxMacRegs(struct et131x_adapter *etdev)
 	 * dropping doesn't work, so it is disabled in the pf_ctrl register,
 	 * but we still leave the packet filter on.
 	 */
-	writel(pf_ctrl, &pRxMac->pf_ctrl);
-	writel(0x9, &pRxMac->ctrl);
+	writel(pf_ctrl, &rxmac->pf_ctrl);
+	writel(0x9, &rxmac->ctrl);
 }
 
-void ConfigTxMacRegs(struct et131x_adapter *etdev)
+void config_txmac_regs(struct et131x_adapter *etdev)
 {
 	struct txmac_regs *txmac = &etdev->regs->txmac;
 
@@ -379,7 +379,7 @@ void ConfigTxMacRegs(struct et131x_adapter *etdev)
 		writel(0x40, &txmac->cf_param);
 }
 
-void ConfigMacStatRegs(struct et131x_adapter *etdev)
+void config_macstat_regs(struct et131x_adapter *etdev)
 {
 	struct macstat_regs __iomem *macstat =
 		&etdev->regs->macstat;
@@ -444,7 +444,7 @@ void ConfigMacStatRegs(struct et131x_adapter *etdev)
 	writel(0xFFFE7E8B, &macstat->carry_reg2_mask);
 }
 
-void ConfigFlowControl(struct et131x_adapter *etdev)
+void config_flow_control(struct et131x_adapter *etdev)
 {
 	if (etdev->duplex_mode == 0) {
 		etdev->flowcontrol = FLOW_NONE;
@@ -480,42 +480,42 @@ void ConfigFlowControl(struct et131x_adapter *etdev)
 }
 
 /**
- * UpdateMacStatHostCounters - Update the local copy of the statistics
+ * update_macstat_host_counters - Update the local copy of the statistics
  * @etdev: pointer to the adapter structure
  */
-void UpdateMacStatHostCounters(struct et131x_adapter *etdev)
+void update_macstat_host_counters(struct et131x_adapter *etdev)
 {
 	struct ce_stats *stats = &etdev->stats;
 	struct macstat_regs __iomem *macstat =
 		&etdev->regs->macstat;
 
-	stats->collisions += readl(&macstat->tx_total_collisions);
-	stats->first_collision += readl(&macstat->tx_single_collisions);
-	stats->tx_deferred += readl(&macstat->tx_deferred);
+	stats->collisions           += readl(&macstat->tx_total_collisions);
+	stats->first_collision      += readl(&macstat->tx_single_collisions);
+	stats->tx_deferred          += readl(&macstat->tx_deferred);
 	stats->excessive_collisions += readl(&macstat->tx_multiple_collisions);
-	stats->late_collisions += readl(&macstat->tx_late_collisions);
-	stats->tx_uflo += readl(&macstat->tx_undersize_frames);
-	stats->max_pkt_error += readl(&macstat->tx_oversize_frames);
-
-	stats->alignment_err += readl(&macstat->rx_align_errs);
-	stats->crc_err += readl(&macstat->rx_code_errs);
-	stats->norcvbuf += readl(&macstat->rx_drops);
-	stats->rx_ov_flow += readl(&macstat->rx_oversize_packets);
-	stats->code_violations += readl(&macstat->rx_fcs_errs);
-	stats->length_err += readl(&macstat->rx_frame_len_errs);
-
-	stats->other_errors += readl(&macstat->rx_fragment_packets);
+	stats->late_collisions      += readl(&macstat->tx_late_collisions);
+	stats->tx_uflo              += readl(&macstat->tx_undersize_frames);
+	stats->max_pkt_error        += readl(&macstat->tx_oversize_frames);
+
+	stats->alignment_err        += readl(&macstat->rx_align_errs);
+	stats->crc_err              += readl(&macstat->rx_code_errs);
+	stats->norcvbuf             += readl(&macstat->rx_drops);
+	stats->rx_ov_flow           += readl(&macstat->rx_oversize_packets);
+	stats->code_violations      += readl(&macstat->rx_fcs_errs);
+	stats->length_err           += readl(&macstat->rx_frame_len_errs);
+
+	stats->other_errors         += readl(&macstat->rx_fragment_packets);
 }
 
 /**
- * HandleMacStatInterrupt
+ * handle_macstat_interrupt
  * @etdev: pointer to the adapter structure
  *
  * One of the MACSTAT counters has wrapped.  Update the local copy of
  * the statistics held in the adapter structure, checking the "wrap"
  * bit for each counter.
  */
-void HandleMacStatInterrupt(struct et131x_adapter *etdev)
+void handle_macstat_interrupt(struct et131x_adapter *etdev)
 {
 	u32 carry_reg1;
 	u32 carry_reg2;
@@ -536,36 +536,36 @@ void HandleMacStatInterrupt(struct et131x_adapter *etdev)
 	 * block indicates that one of the counters has wrapped.
 	 */
 	if (carry_reg1 & (1 << 14))
-		etdev->stats.code_violations += COUNTER_WRAP_16_BIT;
+		etdev->stats.code_violations      += COUNTER_WRAP_16_BIT;
 	if (carry_reg1 & (1 << 8))
-		etdev->stats.alignment_err += COUNTER_WRAP_12_BIT;
+		etdev->stats.alignment_err        += COUNTER_WRAP_12_BIT;
 	if (carry_reg1 & (1 << 7))
-		etdev->stats.length_err += COUNTER_WRAP_16_BIT;
+		etdev->stats.length_err           += COUNTER_WRAP_16_BIT;
 	if (carry_reg1 & (1 << 2))
-		etdev->stats.other_errors += COUNTER_WRAP_16_BIT;
+		etdev->stats.other_errors         += COUNTER_WRAP_16_BIT;
 	if (carry_reg1 & (1 << 6))
-		etdev->stats.crc_err += COUNTER_WRAP_16_BIT;
+		etdev->stats.crc_err              += COUNTER_WRAP_16_BIT;
 	if (carry_reg1 & (1 << 3))
-		etdev->stats.rx_ov_flow += COUNTER_WRAP_16_BIT;
+		etdev->stats.rx_ov_flow           += COUNTER_WRAP_16_BIT;
 	if (carry_reg1 & (1 << 0))
-		etdev->stats.norcvbuf += COUNTER_WRAP_16_BIT;
+		etdev->stats.norcvbuf             += COUNTER_WRAP_16_BIT;
 	if (carry_reg2 & (1 << 16))
-		etdev->stats.max_pkt_error += COUNTER_WRAP_12_BIT;
+		etdev->stats.max_pkt_error        += COUNTER_WRAP_12_BIT;
 	if (carry_reg2 & (1 << 15))
-		etdev->stats.tx_uflo += COUNTER_WRAP_12_BIT;
+		etdev->stats.tx_uflo              += COUNTER_WRAP_12_BIT;
 	if (carry_reg2 & (1 << 6))
-		etdev->stats.first_collision += COUNTER_WRAP_12_BIT;
+		etdev->stats.first_collision      += COUNTER_WRAP_12_BIT;
 	if (carry_reg2 & (1 << 8))
-		etdev->stats.tx_deferred += COUNTER_WRAP_12_BIT;
+		etdev->stats.tx_deferred          += COUNTER_WRAP_12_BIT;
 	if (carry_reg2 & (1 << 5))
 		etdev->stats.excessive_collisions += COUNTER_WRAP_12_BIT;
 	if (carry_reg2 & (1 << 4))
-		etdev->stats.late_collisions += COUNTER_WRAP_12_BIT;
+		etdev->stats.late_collisions      += COUNTER_WRAP_12_BIT;
 	if (carry_reg2 & (1 << 2))
-		etdev->stats.collisions += COUNTER_WRAP_12_BIT;
+		etdev->stats.collisions           += COUNTER_WRAP_12_BIT;
 }
 
-void SetupDeviceForMulticast(struct et131x_adapter *etdev)
+void setup_device_for_multicast(struct et131x_adapter *etdev)
 {
 	struct rxmac_regs __iomem *rxmac = &etdev->regs->rxmac;
 	uint32_t nIndex;
@@ -613,7 +613,7 @@ void SetupDeviceForMulticast(struct et131x_adapter *etdev)
 	}
 }
 
-void SetupDeviceForUnicast(struct et131x_adapter *etdev)
+void setup_device_for_unicast(struct et131x_adapter *etdev)
 {
 	struct rxmac_regs __iomem *rxmac = &etdev->regs->rxmac;
 	u32 uni_pf1;
diff --git a/drivers/staging/et131x/et1310_phy.c b/drivers/staging/et131x/et1310_phy.c
index 0bcb7fb..d5b02a8 100644
--- a/drivers/staging/et131x/et1310_phy.c
+++ b/drivers/staging/et131x/et1310_phy.c
@@ -850,7 +850,7 @@ void et131x_Mii_check(struct et131x_adapter *etdev,
 				MiWrite(etdev, 0x12, Register18);
 			}
 
-			ConfigFlowControl(etdev);
+			config_flow_control(etdev);
 
 			if (etdev->linkspeed == TRUEPHY_SPEED_1000MBPS &&
 					etdev->RegistryJumboPacket > 2048)
@@ -858,7 +858,7 @@ void et131x_Mii_check(struct et131x_adapter *etdev,
 								   0x2000);
 
 			SetRxDmaTimer(etdev);
-			ConfigMACRegs2(etdev);
+			config_mac_regs2(etdev);
 		}
 	}
 }
diff --git a/drivers/staging/et131x/et131x.h b/drivers/staging/et131x/et131x.h
index 48ebac0..289d511 100644
--- a/drivers/staging/et131x/et131x.h
+++ b/drivers/staging/et131x/et131x.h
@@ -71,16 +71,16 @@ irqreturn_t et131x_isr(int irq, void *dev_id);
 void et131x_isr_handler(struct work_struct *work);
 
 /* et1310_mac.c */
-void ConfigMACRegs1(struct et131x_adapter *adapter);
-void ConfigMACRegs2(struct et131x_adapter *adapter);
-void ConfigRxMacRegs(struct et131x_adapter *adapter);
-void ConfigTxMacRegs(struct et131x_adapter *adapter);
-void ConfigMacStatRegs(struct et131x_adapter *adapter);
-void ConfigFlowControl(struct et131x_adapter *adapter);
-void UpdateMacStatHostCounters(struct et131x_adapter *adapter);
-void HandleMacStatInterrupt(struct et131x_adapter *adapter);
-void SetupDeviceForMulticast(struct et131x_adapter *adapter);
-void SetupDeviceForUnicast(struct et131x_adapter *adapter);
+void config_mac_regs1(struct et131x_adapter *adapter);
+void config_mac_regs2(struct et131x_adapter *adapter);
+void config_rxmac_regs(struct et131x_adapter *adapter);
+void config_txmac_regs(struct et131x_adapter *adapter);
+void config_macstat_regs(struct et131x_adapter *adapter);
+void config_flow_control(struct et131x_adapter *adapter);
+void update_macstat_host_counters(struct et131x_adapter *adapter);
+void handle_macstat_interrupt(struct et131x_adapter *adapter);
+void setup_device_for_multicast(struct et131x_adapter *adapter);
+void setup_device_for_unicast(struct et131x_adapter *adapter);
 
 /* et131x_netdev.c */
 struct net_device *et131x_device_alloc(void);
diff --git a/drivers/staging/et131x/et131x_initpci.c b/drivers/staging/et131x/et131x_initpci.c
index 8c8d6b8..d98db85 100644
--- a/drivers/staging/et131x/et131x_initpci.c
+++ b/drivers/staging/et131x/et131x_initpci.c
@@ -269,7 +269,7 @@ void et131x_error_timer_handler(unsigned long data)
 	pm_csr = readl(&etdev->regs->global.pm_csr);
 
 	if ((pm_csr & ET_PM_PHY_SW_COMA) == 0)
-		UpdateMacStatHostCounters(etdev);
+		update_macstat_host_counters(etdev);
 	else
 		dev_err(&etdev->pdev->dev,
 		    "No interrupts, in PHY coma, pm_csr = 0x%x\n", pm_csr);
@@ -369,7 +369,7 @@ void ConfigGlobalRegs(struct et131x_adapter *etdev)
 
 /**
  * et131x_adapter_setup - Set the adapter up as per cassini+ documentation
- * @adapter: pointer to our private adapter structure
+ * @etdev: pointer to our private adapter structure
  *
  * Returns 0 on success, errno on failure (as defined in errno.h)
  */
@@ -380,19 +380,19 @@ int et131x_adapter_setup(struct et131x_adapter *etdev)
 	/* Configure the JAGCore */
 	ConfigGlobalRegs(etdev);
 
-	ConfigMACRegs1(etdev);
+	config_mac_regs1(etdev);
 
 	/* Configure the MMC registers */
 	/* All we need to do is initialize the Memory Control Register */
 	writel(ET_MMC_ENABLE, &etdev->regs->mmc.mmc_ctrl);
 
-	ConfigRxMacRegs(etdev);
-	ConfigTxMacRegs(etdev);
+	config_rxmac_regs(etdev);
+	config_txmac_regs(etdev);
 
 	ConfigRxDmaRegs(etdev);
 	ConfigTxDmaRegs(etdev);
 
-	ConfigMacStatRegs(etdev);
+	config_macstat_regs(etdev);
 
 	/* Move the following code to Timer function?? */
 	status = et131x_xcvr_find(etdev);
diff --git a/drivers/staging/et131x/et131x_isr.c b/drivers/staging/et131x/et131x_isr.c
index 9c33209..48b4d78 100644
--- a/drivers/staging/et131x/et131x_isr.c
+++ b/drivers/staging/et131x/et131x_isr.c
@@ -460,7 +460,7 @@ void et131x_isr_handler(struct work_struct *work)
 			 * to maintain the top, software managed bits of the
 			 * counter(s).
 			 */
-			HandleMacStatInterrupt(etdev);
+			handle_macstat_interrupt(etdev);
 		}
 
 		/* Handle SLV Timeout Interrupt */
diff --git a/drivers/staging/et131x/et131x_netdev.c b/drivers/staging/et131x/et131x_netdev.c
index 5f25bba..4e9e176 100644
--- a/drivers/staging/et131x/et131x_netdev.c
+++ b/drivers/staging/et131x/et131x_netdev.c
@@ -301,14 +301,14 @@ int et131x_set_packet_filter(struct et131x_adapter *adapter)
 		if (filter & ET131X_PACKET_TYPE_ALL_MULTICAST)
 			pf_ctrl &= ~2;	/* Multicast filter bit */
 		else {
-			SetupDeviceForMulticast(adapter);
+			setup_device_for_multicast(adapter);
 			pf_ctrl |= 2;
 			ctrl &= ~0x04;
 		}
 
 		/* Set us up with Unicast packet filtering */
 		if (filter & ET131X_PACKET_TYPE_DIRECTED) {
-			SetupDeviceForUnicast(adapter);
+			setup_device_for_unicast(adapter);
 			pf_ctrl |= 4;
 			ctrl &= ~0x04;
 		}
-- 
1.7.4.4

