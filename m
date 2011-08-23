Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107Ab1HWWnD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 18:43:03 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:60470 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755900Ab1HWWmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 18:42:18 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: greg@kroah.com, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com, Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 5/8] [RESEND] staging: et131x: Rename var name 'etdev' to 'adapter' throughout module
Date: Tue, 23 Aug 2011 23:40:37 +0100
Message-Id: <1314139240-869-6-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1314139240-869-1-git-send-email-mark.einon@gmail.com>
References: <1312321621-2695-1-git-send-email-mark.einon@gmail.com>
 <1314139240-869-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Used regex (from vim) :%s/\<etdev\>/adapter/g

Changed because:
* 'etdev' is easily confused as a misspelling of 'netdev'
* 'adapter' is more widely used for this struct type in net drivers. This
change made comparing code with other drivers much easier.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et1310_eeprom.c  |   32 ++--
 drivers/staging/et131x/et1310_mac.c     |  206 ++++++++--------
 drivers/staging/et131x/et1310_phy.c     |  390 +++++++++++++++---------------
 drivers/staging/et131x/et1310_pm.c      |   44 ++--
 drivers/staging/et131x/et1310_rx.c      |  174 +++++++-------
 drivers/staging/et131x/et1310_tx.c      |  254 ++++++++++----------
 drivers/staging/et131x/et131x_initpci.c |  136 ++++++------
 drivers/staging/et131x/et131x_isr.c     |   46 ++--
 drivers/staging/et131x/et131x_netdev.c  |   26 +-
 9 files changed, 654 insertions(+), 654 deletions(-)

diff --git a/drivers/staging/et131x/et1310_eeprom.c b/drivers/staging/et131x/et1310_eeprom.c
index 2375840..e810254 100644
--- a/drivers/staging/et131x/et1310_eeprom.c
+++ b/drivers/staging/et131x/et1310_eeprom.c
@@ -150,15 +150,15 @@ static int eeprom_wait_ready(struct pci_dev *pdev, u32 *status)
 
 /**
  * eeprom_write - Write a byte to the ET1310's EEPROM
- * @etdev: pointer to our private adapter structure
+ * @adapter: pointer to our private adapter structure
  * @addr: the address to write
  * @data: the value to write
  *
  * Returns 1 for a successful write.
  */
-static int eeprom_write(struct et131x_adapter *etdev, u32 addr, u8 data)
+static int eeprom_write(struct et131x_adapter *adapter, u32 addr, u8 data)
 {
-	struct pci_dev *pdev = etdev->pdev;
+	struct pci_dev *pdev = adapter->pdev;
 	int index = 0;
 	int retries;
 	int err = 0;
@@ -222,7 +222,7 @@ static int eeprom_write(struct et131x_adapter *etdev, u32 addr, u8 data)
 		 * 1, this is so we do a blind write for load bug.
 		 */
 		if ((status & LBCIF_STATUS_GENERAL_ERROR)
-			&& etdev->pdev->revision == 0)
+			&& adapter->pdev->revision == 0)
 			break;
 
 		/*
@@ -280,7 +280,7 @@ static int eeprom_write(struct et131x_adapter *etdev, u32 addr, u8 data)
 
 /**
  * eeprom_read - Read a byte from the ET1310's EEPROM
- * @etdev: pointer to our private adapter structure
+ * @adapter: pointer to our private adapter structure
  * @addr: the address from which to read
  * @pdata: a pointer to a byte in which to store the value of the read
  * @eeprom_id: the ID of the EEPROM
@@ -288,9 +288,9 @@ static int eeprom_write(struct et131x_adapter *etdev, u32 addr, u8 data)
  *
  * Returns 1 for a successful read
  */
-static int eeprom_read(struct et131x_adapter *etdev, u32 addr, u8 *pdata)
+static int eeprom_read(struct et131x_adapter *adapter, u32 addr, u8 *pdata)
 {
-	struct pci_dev *pdev = etdev->pdev;
+	struct pci_dev *pdev = adapter->pdev;
 	int err;
 	u32 status;
 
@@ -337,9 +337,9 @@ static int eeprom_read(struct et131x_adapter *etdev, u32 addr, u8 *pdata)
 	return (status & LBCIF_STATUS_ACK_ERROR) ? -EIO : 0;
 }
 
-int et131x_init_eeprom(struct et131x_adapter *etdev)
+int et131x_init_eeprom(struct et131x_adapter *adapter)
 {
-	struct pci_dev *pdev = etdev->pdev;
+	struct pci_dev *pdev = adapter->pdev;
 	u8 eestatus;
 
 	/* We first need to check the EEPROM Status code located at offset
@@ -374,7 +374,7 @@ int et131x_init_eeprom(struct et131x_adapter *etdev)
 			 * corruption seen with 1310 B Silicon
 			 */
 			for (i = 0; i < 3; i++)
-				if (eeprom_write(etdev, i, eedata[i]) < 0)
+				if (eeprom_write(adapter, i, eedata[i]) < 0)
 					write_failed = 1;
 		}
 		if (pdev->revision  != 0x01 || write_failed) {
@@ -387,21 +387,21 @@ int et131x_init_eeprom(struct et131x_adapter *etdev)
 			 * gather additional information that normally would
 			 * come from the eeprom, like MAC Address
 			 */
-			etdev->has_eeprom = 0;
+			adapter->has_eeprom = 0;
 			return -EIO;
 		}
 	}
-	etdev->has_eeprom = 1;
+	adapter->has_eeprom = 1;
 
 	/* Read the EEPROM for information regarding LED behavior. Refer to
 	 * ET1310_phy.c, et131x_xcvr_init(), for its use.
 	 */
-	eeprom_read(etdev, 0x70, &etdev->eeprom_data[0]);
-	eeprom_read(etdev, 0x71, &etdev->eeprom_data[1]);
+	eeprom_read(adapter, 0x70, &adapter->eeprom_data[0]);
+	eeprom_read(adapter, 0x71, &adapter->eeprom_data[1]);
 
-	if (etdev->eeprom_data[0] != 0xcd)
+	if (adapter->eeprom_data[0] != 0xcd)
 		/* Disable all optional features */
-		etdev->eeprom_data[1] = 0x00;
+		adapter->eeprom_data[1] = 0x00;
 
 	return 0;
 }
diff --git a/drivers/staging/et131x/et1310_mac.c b/drivers/staging/et131x/et1310_mac.c
index 8e124fe..ab85cb3 100644
--- a/drivers/staging/et131x/et1310_mac.c
+++ b/drivers/staging/et131x/et1310_mac.c
@@ -100,11 +100,11 @@
 
 /**
  * et1310_config_mac_regs1 - Initialize the first part of MAC regs
- * @etdev: pointer to our adapter structure
+ * @adapter: pointer to our adapter structure
  */
-void et1310_config_mac_regs1(struct et131x_adapter *etdev)
+void et1310_config_mac_regs1(struct et131x_adapter *adapter)
 {
-	struct mac_regs __iomem *macregs = &etdev->regs->mac;
+	struct mac_regs __iomem *macregs = &adapter->regs->mac;
 	u32 station1;
 	u32 station2;
 	u32 ipg;
@@ -136,12 +136,12 @@ void et1310_config_mac_regs1(struct et131x_adapter *etdev)
 	 * station address is used for generating and checking pause control
 	 * packets.
 	 */
-	station2 = (etdev->addr[1] << ET_MAC_STATION_ADDR2_OC2_SHIFT) |
-		   (etdev->addr[0] << ET_MAC_STATION_ADDR2_OC1_SHIFT);
-	station1 = (etdev->addr[5] << ET_MAC_STATION_ADDR1_OC6_SHIFT) |
-		   (etdev->addr[4] << ET_MAC_STATION_ADDR1_OC5_SHIFT) |
-		   (etdev->addr[3] << ET_MAC_STATION_ADDR1_OC4_SHIFT) |
-		    etdev->addr[2];
+	station2 = (adapter->addr[1] << ET_MAC_STATION_ADDR2_OC2_SHIFT) |
+		   (adapter->addr[0] << ET_MAC_STATION_ADDR2_OC1_SHIFT);
+	station1 = (adapter->addr[5] << ET_MAC_STATION_ADDR1_OC6_SHIFT) |
+		   (adapter->addr[4] << ET_MAC_STATION_ADDR1_OC5_SHIFT) |
+		   (adapter->addr[3] << ET_MAC_STATION_ADDR1_OC4_SHIFT) |
+		    adapter->addr[2];
 	writel(station1, &macregs->station_addr_1);
 	writel(station2, &macregs->station_addr_2);
 
@@ -152,7 +152,7 @@ void et1310_config_mac_regs1(struct et131x_adapter *etdev)
 	 * Packets larger than (registry_jumbo_packet) that do not contain a
 	 * VLAN ID will be dropped by the Rx function.
 	 */
-	writel(etdev->registry_jumbo_packet + 4, &macregs->max_fm_len);
+	writel(adapter->registry_jumbo_packet + 4, &macregs->max_fm_len);
 
 	/* clear out MAC config reset */
 	writel(0, &macregs->cfg1);
@@ -160,25 +160,25 @@ void et1310_config_mac_regs1(struct et131x_adapter *etdev)
 
 /**
  * et1310_config_mac_regs2 - Initialize the second part of MAC regs
- * @etdev: pointer to our adapter structure
+ * @adapter: pointer to our adapter structure
  */
-void et1310_config_mac_regs2(struct et131x_adapter *etdev)
+void et1310_config_mac_regs2(struct et131x_adapter *adapter)
 {
 	int32_t delay = 0;
-	struct mac_regs __iomem *mac = &etdev->regs->mac;
+	struct mac_regs __iomem *mac = &adapter->regs->mac;
 	u32 cfg1;
 	u32 cfg2;
 	u32 ifctrl;
 	u32 ctl;
 
-	ctl = readl(&etdev->regs->txmac.ctl);
+	ctl = readl(&adapter->regs->txmac.ctl);
 	cfg1 = readl(&mac->cfg1);
 	cfg2 = readl(&mac->cfg2);
 	ifctrl = readl(&mac->if_ctrl);
 
 	/* Set up the if mode bits */
 	cfg2 &= ~0x300;
-	if (etdev->linkspeed == TRUEPHY_SPEED_1000MBPS) {
+	if (adapter->linkspeed == TRUEPHY_SPEED_1000MBPS) {
 		cfg2 |= 0x200;
 		/* Phy mode bit */
 		ifctrl &= ~(1 << 24);
@@ -191,7 +191,7 @@ void et1310_config_mac_regs2(struct et131x_adapter *etdev)
 	cfg1 |= CFG1_RX_ENABLE | CFG1_TX_ENABLE | CFG1_TX_FLOW;
 	/* Initialize loop back to off */
 	cfg1 &= ~(CFG1_LOOPBACK | CFG1_RX_FLOW);
-	if (etdev->flowcontrol == FLOW_RXONLY || etdev->flowcontrol == FLOW_BOTH)
+	if (adapter->flowcontrol == FLOW_RXONLY || adapter->flowcontrol == FLOW_BOTH)
 		cfg1 |= CFG1_RX_FLOW;
 	writel(cfg1, &mac->cfg1);
 
@@ -202,11 +202,11 @@ void et1310_config_mac_regs2(struct et131x_adapter *etdev)
 	cfg2 &= ~0x0021;
 
 	/* Turn on duplex if needed */
-	if (etdev->duplex_mode)
+	if (adapter->duplex_mode)
 		cfg2 |= 0x01;
 
 	ifctrl &= ~(1 << 26);
-	if (!etdev->duplex_mode)
+	if (!adapter->duplex_mode)
 		ifctrl |= (1<<26);	/* Enable ghd */
 
 	writel(ifctrl, &mac->if_ctrl);
@@ -219,25 +219,25 @@ void et1310_config_mac_regs2(struct et131x_adapter *etdev)
 	} while ((cfg1 & CFG1_WAIT) != CFG1_WAIT && delay < 100);
 
 	if (delay == 100) {
-		dev_warn(&etdev->pdev->dev,
+		dev_warn(&adapter->pdev->dev,
 		    "Syncd bits did not respond correctly cfg1 word 0x%08x\n",
 			cfg1);
 	}
 
 	/* Enable txmac */
 	ctl |= 0x09;	/* TX mac enable, FC disable */
-	writel(ctl, &etdev->regs->txmac.ctl);
+	writel(ctl, &adapter->regs->txmac.ctl);
 
 	/* Ready to start the RXDMA/TXDMA engine */
-	if (etdev->flags & fMP_ADAPTER_LOWER_POWER) {
-		et131x_rx_dma_enable(etdev);
-		et131x_tx_dma_enable(etdev);
+	if (adapter->flags & fMP_ADAPTER_LOWER_POWER) {
+		et131x_rx_dma_enable(adapter);
+		et131x_tx_dma_enable(adapter);
 	}
 }
 
-void et1310_config_rxmac_regs(struct et131x_adapter *etdev)
+void et1310_config_rxmac_regs(struct et131x_adapter *adapter)
 {
-	struct rxmac_regs __iomem *rxmac = &etdev->regs->rxmac;
+	struct rxmac_regs __iomem *rxmac = &adapter->regs->rxmac;
 	u32 sa_lo;
 	u32 sa_hi = 0;
 	u32 pf_ctrl = 0;
@@ -280,22 +280,22 @@ void et1310_config_rxmac_regs(struct et131x_adapter *etdev)
 	writel(0, &rxmac->mask4_word3);
 
 	/* Lets setup the WOL Source Address */
-	sa_lo = (etdev->addr[2] << ET_WOL_LO_SA3_SHIFT) |
-		(etdev->addr[3] << ET_WOL_LO_SA4_SHIFT) |
-		(etdev->addr[4] << ET_WOL_LO_SA5_SHIFT) |
-		 etdev->addr[5];
+	sa_lo = (adapter->addr[2] << ET_WOL_LO_SA3_SHIFT) |
+		(adapter->addr[3] << ET_WOL_LO_SA4_SHIFT) |
+		(adapter->addr[4] << ET_WOL_LO_SA5_SHIFT) |
+		 adapter->addr[5];
 	writel(sa_lo, &rxmac->sa_lo);
 
-	sa_hi = (u32) (etdev->addr[0] << ET_WOL_HI_SA1_SHIFT) |
-	               etdev->addr[1];
+	sa_hi = (u32) (adapter->addr[0] << ET_WOL_HI_SA1_SHIFT) |
+	               adapter->addr[1];
 	writel(sa_hi, &rxmac->sa_hi);
 
 	/* Disable all Packet Filtering */
 	writel(0, &rxmac->pf_ctrl);
 
 	/* Let's initialize the Unicast Packet filtering address */
-	if (etdev->packet_filter & ET131X_PACKET_TYPE_DIRECTED) {
-		et1310_setup_device_for_unicast(etdev);
+	if (adapter->packet_filter & ET131X_PACKET_TYPE_DIRECTED) {
+		et1310_setup_device_for_unicast(adapter);
 		pf_ctrl |= 4;	/* Unicast filter */
 	} else {
 		writel(0, &rxmac->uni_pf_addr1);
@@ -304,16 +304,16 @@ void et1310_config_rxmac_regs(struct et131x_adapter *etdev)
 	}
 
 	/* Let's initialize the Multicast hash */
-	if (!(etdev->packet_filter & ET131X_PACKET_TYPE_ALL_MULTICAST)) {
+	if (!(adapter->packet_filter & ET131X_PACKET_TYPE_ALL_MULTICAST)) {
 		pf_ctrl |= 2;	/* Multicast filter */
-		et1310_setup_device_for_multicast(etdev);
+		et1310_setup_device_for_multicast(adapter);
 	}
 
 	/* Runt packet filtering.  Didn't work in version A silicon. */
 	pf_ctrl |= (NIC_MIN_PACKET_SIZE + 4) << 16;
 	pf_ctrl |= 8;	/* Fragment filter */
 
-	if (etdev->registry_jumbo_packet > 8192)
+	if (adapter->registry_jumbo_packet > 8192)
 		/* In order to transmit jumbo packets greater than 8k, the
 		 * FIFO between RxMAC and RxDMA needs to be reduced in size
 		 * to (16k - Jumbo packet size).  In order to implement this,
@@ -350,7 +350,7 @@ void et1310_config_rxmac_regs(struct et131x_adapter *etdev)
 	 * bit 16: Receive frame truncated.
 	 * bit 17: Drop packet enable
 	 */
-	if (etdev->linkspeed == TRUEPHY_SPEED_100MBPS)
+	if (adapter->linkspeed == TRUEPHY_SPEED_100MBPS)
 		writel(0x30038, &rxmac->mif_ctrl);
 	else
 		writel(0x30030, &rxmac->mif_ctrl);
@@ -365,24 +365,24 @@ void et1310_config_rxmac_regs(struct et131x_adapter *etdev)
 	writel(0x9, &rxmac->ctrl);
 }
 
-void et1310_config_txmac_regs(struct et131x_adapter *etdev)
+void et1310_config_txmac_regs(struct et131x_adapter *adapter)
 {
-	struct txmac_regs *txmac = &etdev->regs->txmac;
+	struct txmac_regs *txmac = &adapter->regs->txmac;
 
 	/* We need to update the Control Frame Parameters
 	 * cfpt - control frame pause timer set to 64 (0x40)
 	 * cfep - control frame extended pause timer set to 0x0
 	 */
-	if (etdev->flowcontrol == FLOW_NONE)
+	if (adapter->flowcontrol == FLOW_NONE)
 		writel(0, &txmac->cf_param);
 	else
 		writel(0x40, &txmac->cf_param);
 }
 
-void et1310_config_macstat_regs(struct et131x_adapter *etdev)
+void et1310_config_macstat_regs(struct et131x_adapter *adapter)
 {
 	struct macstat_regs __iomem *macstat =
-		&etdev->regs->macstat;
+		&adapter->regs->macstat;
 
 	/* Next we need to initialize all the macstat registers to zero on
 	 * the device.
@@ -444,50 +444,50 @@ void et1310_config_macstat_regs(struct et131x_adapter *etdev)
 	writel(0xFFFE7E8B, &macstat->carry_reg2_mask);
 }
 
-void et1310_config_flow_control(struct et131x_adapter *etdev)
+void et1310_config_flow_control(struct et131x_adapter *adapter)
 {
-	if (etdev->duplex_mode == 0) {
-		etdev->flowcontrol = FLOW_NONE;
+	if (adapter->duplex_mode == 0) {
+		adapter->flowcontrol = FLOW_NONE;
 	} else {
 		char remote_pause, remote_async_pause;
 
-		et1310_phy_access_mii_bit(etdev,
+		et1310_phy_access_mii_bit(adapter,
 				TRUEPHY_BIT_READ, 5, 10, &remote_pause);
-		et1310_phy_access_mii_bit(etdev,
+		et1310_phy_access_mii_bit(adapter,
 				TRUEPHY_BIT_READ, 5, 11,
 				&remote_async_pause);
 
 		if ((remote_pause == TRUEPHY_BIT_SET) &&
 		    (remote_async_pause == TRUEPHY_BIT_SET)) {
-			etdev->flowcontrol = etdev->wanted_flow;
+			adapter->flowcontrol = adapter->wanted_flow;
 		} else if ((remote_pause == TRUEPHY_BIT_SET) &&
 			   (remote_async_pause == TRUEPHY_BIT_CLEAR)) {
-			if (etdev->wanted_flow == FLOW_BOTH)
-				etdev->flowcontrol = FLOW_BOTH;
+			if (adapter->wanted_flow == FLOW_BOTH)
+				adapter->flowcontrol = FLOW_BOTH;
 			else
-				etdev->flowcontrol = FLOW_NONE;
+				adapter->flowcontrol = FLOW_NONE;
 		} else if ((remote_pause == TRUEPHY_BIT_CLEAR) &&
 			   (remote_async_pause == TRUEPHY_BIT_CLEAR)) {
-			etdev->flowcontrol = FLOW_NONE;
+			adapter->flowcontrol = FLOW_NONE;
 		} else {/* if (remote_pause == TRUEPHY_CLEAR_BIT &&
 			       remote_async_pause == TRUEPHY_SET_BIT) */
-			if (etdev->wanted_flow == FLOW_BOTH)
-				etdev->flowcontrol = FLOW_RXONLY;
+			if (adapter->wanted_flow == FLOW_BOTH)
+				adapter->flowcontrol = FLOW_RXONLY;
 			else
-				etdev->flowcontrol = FLOW_NONE;
+				adapter->flowcontrol = FLOW_NONE;
 		}
 	}
 }
 
 /**
  * et1310_update_macstat_host_counters - Update the local copy of the statistics
- * @etdev: pointer to the adapter structure
+ * @adapter: pointer to the adapter structure
  */
-void et1310_update_macstat_host_counters(struct et131x_adapter *etdev)
+void et1310_update_macstat_host_counters(struct et131x_adapter *adapter)
 {
-	struct ce_stats *stats = &etdev->stats;
+	struct ce_stats *stats = &adapter->stats;
 	struct macstat_regs __iomem *macstat =
-		&etdev->regs->macstat;
+		&adapter->regs->macstat;
 
 	stats->tx_collisions	       += readl(&macstat->tx_total_collisions);
 	stats->tx_first_collisions     += readl(&macstat->tx_single_collisions);
@@ -509,13 +509,13 @@ void et1310_update_macstat_host_counters(struct et131x_adapter *etdev)
 
 /**
  * et1310_handle_macstat_interrupt
- * @etdev: pointer to the adapter structure
+ * @adapter: pointer to the adapter structure
  *
  * One of the MACSTAT counters has wrapped.  Update the local copy of
  * the statistics held in the adapter structure, checking the "wrap"
  * bit for each counter.
  */
-void et1310_handle_macstat_interrupt(struct et131x_adapter *etdev)
+void et1310_handle_macstat_interrupt(struct et131x_adapter *adapter)
 {
 	u32 carry_reg1;
 	u32 carry_reg2;
@@ -523,11 +523,11 @@ void et1310_handle_macstat_interrupt(struct et131x_adapter *etdev)
 	/* Read the interrupt bits from the register(s).  These are Clear On
 	 * Write.
 	 */
-	carry_reg1 = readl(&etdev->regs->macstat.carry_reg1);
-	carry_reg2 = readl(&etdev->regs->macstat.carry_reg2);
+	carry_reg1 = readl(&adapter->regs->macstat.carry_reg1);
+	carry_reg2 = readl(&adapter->regs->macstat.carry_reg2);
 
-	writel(carry_reg1, &etdev->regs->macstat.carry_reg1);
-	writel(carry_reg2, &etdev->regs->macstat.carry_reg2);
+	writel(carry_reg1, &adapter->regs->macstat.carry_reg1);
+	writel(carry_reg2, &adapter->regs->macstat.carry_reg2);
 
 	/* We need to do update the host copy of all the MAC_STAT counters.
 	 * For each counter, check it's overflow bit.  If the overflow bit is
@@ -536,38 +536,38 @@ void et1310_handle_macstat_interrupt(struct et131x_adapter *etdev)
 	 * block indicates that one of the counters has wrapped.
 	 */
 	if (carry_reg1 & (1 << 14))
-		etdev->stats.rx_code_violations	+= COUNTER_WRAP_16_BIT;
+		adapter->stats.rx_code_violations	+= COUNTER_WRAP_16_BIT;
 	if (carry_reg1 & (1 << 8))
-		etdev->stats.rx_align_errs	+= COUNTER_WRAP_12_BIT;
+		adapter->stats.rx_align_errs	+= COUNTER_WRAP_12_BIT;
 	if (carry_reg1 & (1 << 7))
-		etdev->stats.rx_length_errs	+= COUNTER_WRAP_16_BIT;
+		adapter->stats.rx_length_errs	+= COUNTER_WRAP_16_BIT;
 	if (carry_reg1 & (1 << 2))
-		etdev->stats.rx_other_errs	+= COUNTER_WRAP_16_BIT;
+		adapter->stats.rx_other_errs	+= COUNTER_WRAP_16_BIT;
 	if (carry_reg1 & (1 << 6))
-		etdev->stats.rx_crc_errs	+= COUNTER_WRAP_16_BIT;
+		adapter->stats.rx_crc_errs	+= COUNTER_WRAP_16_BIT;
 	if (carry_reg1 & (1 << 3))
-		etdev->stats.rx_overflows	+= COUNTER_WRAP_16_BIT;
+		adapter->stats.rx_overflows	+= COUNTER_WRAP_16_BIT;
 	if (carry_reg1 & (1 << 0))
-		etdev->stats.rcvd_pkts_dropped	+= COUNTER_WRAP_16_BIT;
+		adapter->stats.rcvd_pkts_dropped	+= COUNTER_WRAP_16_BIT;
 	if (carry_reg2 & (1 << 16))
-		etdev->stats.tx_max_pkt_errs	+= COUNTER_WRAP_12_BIT;
+		adapter->stats.tx_max_pkt_errs	+= COUNTER_WRAP_12_BIT;
 	if (carry_reg2 & (1 << 15))
-		etdev->stats.tx_underflows	+= COUNTER_WRAP_12_BIT;
+		adapter->stats.tx_underflows	+= COUNTER_WRAP_12_BIT;
 	if (carry_reg2 & (1 << 6))
-		etdev->stats.tx_first_collisions += COUNTER_WRAP_12_BIT;
+		adapter->stats.tx_first_collisions += COUNTER_WRAP_12_BIT;
 	if (carry_reg2 & (1 << 8))
-		etdev->stats.tx_deferred	+= COUNTER_WRAP_12_BIT;
+		adapter->stats.tx_deferred	+= COUNTER_WRAP_12_BIT;
 	if (carry_reg2 & (1 << 5))
-		etdev->stats.tx_excessive_collisions += COUNTER_WRAP_12_BIT;
+		adapter->stats.tx_excessive_collisions += COUNTER_WRAP_12_BIT;
 	if (carry_reg2 & (1 << 4))
-		etdev->stats.tx_late_collisions	+= COUNTER_WRAP_12_BIT;
+		adapter->stats.tx_late_collisions	+= COUNTER_WRAP_12_BIT;
 	if (carry_reg2 & (1 << 2))
-		etdev->stats.tx_collisions	+= COUNTER_WRAP_12_BIT;
+		adapter->stats.tx_collisions	+= COUNTER_WRAP_12_BIT;
 }
 
-void et1310_setup_device_for_multicast(struct et131x_adapter *etdev)
+void et1310_setup_device_for_multicast(struct et131x_adapter *adapter)
 {
-	struct rxmac_regs __iomem *rxmac = &etdev->regs->rxmac;
+	struct rxmac_regs __iomem *rxmac = &adapter->regs->rxmac;
 	uint32_t nIndex;
 	uint32_t result;
 	uint32_t hash1 = 0;
@@ -581,11 +581,11 @@ void et1310_setup_device_for_multicast(struct et131x_adapter *etdev)
 	 * specified) then we should pass NO multi-cast addresses to the
 	 * driver.
 	 */
-	if (etdev->packet_filter & ET131X_PACKET_TYPE_MULTICAST) {
+	if (adapter->packet_filter & ET131X_PACKET_TYPE_MULTICAST) {
 		/* Loop through our multicast array and set up the device */
-		for (nIndex = 0; nIndex < etdev->multicast_addr_count;
+		for (nIndex = 0; nIndex < adapter->multicast_addr_count;
 		     nIndex++) {
-			result = ether_crc(6, etdev->multicast_list[nIndex]);
+			result = ether_crc(6, adapter->multicast_list[nIndex]);
 
 			result = (result & 0x3F800000) >> 23;
 
@@ -605,7 +605,7 @@ void et1310_setup_device_for_multicast(struct et131x_adapter *etdev)
 	}
 
 	/* Write out the new hash to the device */
-	pm_csr = readl(&etdev->regs->global.pm_csr);
+	pm_csr = readl(&adapter->regs->global.pm_csr);
 	if ((pm_csr & ET_PM_PHY_SW_COMA) == 0) {
 		writel(hash1, &rxmac->multi_hash1);
 		writel(hash2, &rxmac->multi_hash2);
@@ -614,9 +614,9 @@ void et1310_setup_device_for_multicast(struct et131x_adapter *etdev)
 	}
 }
 
-void et1310_setup_device_for_unicast(struct et131x_adapter *etdev)
+void et1310_setup_device_for_unicast(struct et131x_adapter *adapter)
 {
-	struct rxmac_regs __iomem *rxmac = &etdev->regs->rxmac;
+	struct rxmac_regs __iomem *rxmac = &adapter->regs->rxmac;
 	u32 uni_pf1;
 	u32 uni_pf2;
 	u32 uni_pf3;
@@ -631,22 +631,22 @@ void et1310_setup_device_for_unicast(struct et131x_adapter *etdev)
 	 * Set up unicast packet filter reg 3 to be the octets 2 - 5 of the
 	 * MAC address for first address
 	 */
-	uni_pf3 = (etdev->addr[0] << ET_UNI_PF_ADDR2_1_SHIFT) |
-		  (etdev->addr[1] << ET_UNI_PF_ADDR2_2_SHIFT) |
-		  (etdev->addr[0] << ET_UNI_PF_ADDR1_1_SHIFT) |
-		   etdev->addr[1];
-
-	uni_pf2 = (etdev->addr[2] << ET_UNI_PF_ADDR2_3_SHIFT) |
-		  (etdev->addr[3] << ET_UNI_PF_ADDR2_4_SHIFT) |
-		  (etdev->addr[4] << ET_UNI_PF_ADDR2_5_SHIFT) |
-		   etdev->addr[5];
-
-	uni_pf1 = (etdev->addr[2] << ET_UNI_PF_ADDR1_3_SHIFT) |
-		  (etdev->addr[3] << ET_UNI_PF_ADDR1_4_SHIFT) |
-		  (etdev->addr[4] << ET_UNI_PF_ADDR1_5_SHIFT) |
-		   etdev->addr[5];
-
-	pm_csr = readl(&etdev->regs->global.pm_csr);
+	uni_pf3 = (adapter->addr[0] << ET_UNI_PF_ADDR2_1_SHIFT) |
+		  (adapter->addr[1] << ET_UNI_PF_ADDR2_2_SHIFT) |
+		  (adapter->addr[0] << ET_UNI_PF_ADDR1_1_SHIFT) |
+		   adapter->addr[1];
+
+	uni_pf2 = (adapter->addr[2] << ET_UNI_PF_ADDR2_3_SHIFT) |
+		  (adapter->addr[3] << ET_UNI_PF_ADDR2_4_SHIFT) |
+		  (adapter->addr[4] << ET_UNI_PF_ADDR2_5_SHIFT) |
+		   adapter->addr[5];
+
+	uni_pf1 = (adapter->addr[2] << ET_UNI_PF_ADDR1_3_SHIFT) |
+		  (adapter->addr[3] << ET_UNI_PF_ADDR1_4_SHIFT) |
+		  (adapter->addr[4] << ET_UNI_PF_ADDR1_5_SHIFT) |
+		   adapter->addr[5];
+
+	pm_csr = readl(&adapter->regs->global.pm_csr);
 	if ((pm_csr & ET_PM_PHY_SW_COMA) == 0) {
 		writel(uni_pf1, &rxmac->uni_pf_addr1);
 		writel(uni_pf2, &rxmac->uni_pf_addr2);
diff --git a/drivers/staging/et131x/et1310_phy.c b/drivers/staging/et131x/et1310_phy.c
index 9d2ce08..6eb9d5c 100644
--- a/drivers/staging/et131x/et1310_phy.c
+++ b/drivers/staging/et131x/et1310_phy.c
@@ -95,17 +95,17 @@
 
 /**
  * et131x_phy_mii_read - Read from the PHY through the MII Interface on the MAC
- * @etdev: pointer to our private adapter structure
+ * @adapter: pointer to our private adapter structure
  * @xcvr_addr: the address of the transceiver
  * @xcvr_reg: the register to read
  * @value: pointer to a 16-bit value in which the value will be stored
  *
  * Returns 0 on success, errno on failure (as defined in errno.h)
  */
-int et131x_phy_mii_read(struct et131x_adapter *etdev, u8 xcvr_addr,
+int et131x_phy_mii_read(struct et131x_adapter *adapter, u8 xcvr_addr,
 	      u8 xcvr_reg, u16 *value)
 {
-	struct mac_regs __iomem *mac = &etdev->regs->mac;
+	struct mac_regs __iomem *mac = &adapter->regs->mac;
 	int status = 0;
 	u32 delay;
 	u32 mii_addr;
@@ -137,9 +137,9 @@ int et131x_phy_mii_read(struct et131x_adapter *etdev, u8 xcvr_addr,
 
 	/* If we hit the max delay, we could not read the register */
 	if (delay == 50) {
-		dev_warn(&etdev->pdev->dev,
+		dev_warn(&adapter->pdev->dev,
 			    "xcvrReg 0x%08x could not be read\n", xcvr_reg);
-		dev_warn(&etdev->pdev->dev, "status is  0x%08x\n",
+		dev_warn(&adapter->pdev->dev, "status is  0x%08x\n",
 			    mii_indicator);
 
 		status = -EIO;
@@ -163,7 +163,7 @@ int et131x_phy_mii_read(struct et131x_adapter *etdev, u8 xcvr_addr,
 
 /**
  * et131x_mii_write - Write to a PHY register through the MII interface of the MAC
- * @etdev: pointer to our private adapter structure
+ * @adapter: pointer to our private adapter structure
  * @xcvr_reg: the register to read
  * @value: 16-bit value to write
  *
@@ -171,11 +171,11 @@ int et131x_phy_mii_read(struct et131x_adapter *etdev, u8 xcvr_addr,
  *
  * Return 0 on success, errno on failure (as defined in errno.h)
  */
-int et131x_mii_write(struct et131x_adapter *etdev, u8 xcvr_reg, u16 value)
+int et131x_mii_write(struct et131x_adapter *adapter, u8 xcvr_reg, u16 value)
 {
-	struct mac_regs __iomem *mac = &etdev->regs->mac;
+	struct mac_regs __iomem *mac = &adapter->regs->mac;
 	int status = 0;
-	u8 xcvr_addr = etdev->stats.xcvr_addr;
+	u8 xcvr_addr = adapter->stats.xcvr_addr;
 	u32 delay;
 	u32 mii_addr;
 	u32 mii_cmd;
@@ -207,14 +207,14 @@ int et131x_mii_write(struct et131x_adapter *etdev, u8 xcvr_reg, u16 value)
 	if (delay == 100) {
 		u16 tmp;
 
-		dev_warn(&etdev->pdev->dev,
+		dev_warn(&adapter->pdev->dev,
 		    "xcvrReg 0x%08x could not be written", xcvr_reg);
-		dev_warn(&etdev->pdev->dev, "status is  0x%08x\n",
+		dev_warn(&adapter->pdev->dev, "status is  0x%08x\n",
 			    mii_indicator);
-		dev_warn(&etdev->pdev->dev, "command is  0x%08x\n",
+		dev_warn(&adapter->pdev->dev, "command is  0x%08x\n",
 			    readl(&mac->mii_mgmt_cmd));
 
-		et131x_mii_read(etdev, xcvr_reg, &tmp);
+		et131x_mii_read(adapter, xcvr_reg, &tmp);
 
 		status = -EIO;
 	}
@@ -233,11 +233,11 @@ int et131x_mii_write(struct et131x_adapter *etdev, u8 xcvr_reg, u16 value)
 
 /**
  * et131x_xcvr_find - Find the PHY ID
- * @etdev: pointer to our private adapter structure
+ * @adapter: pointer to our private adapter structure
  *
  * Returns 0 on success, errno on failure (as defined in errno.h)
  */
-int et131x_xcvr_find(struct et131x_adapter *etdev)
+int et131x_xcvr_find(struct et131x_adapter *adapter)
 {
 	u8 xcvr_addr;
 	u16 idr1;
@@ -247,32 +247,32 @@ int et131x_xcvr_find(struct et131x_adapter *etdev)
 	/* We need to get xcvr id and address we just get the first one */
 	for (xcvr_addr = 0; xcvr_addr < 32; xcvr_addr++) {
 		/* Read the ID from the PHY */
-		et131x_phy_mii_read(etdev, xcvr_addr,
+		et131x_phy_mii_read(adapter, xcvr_addr,
 			     (u8) offsetof(struct mi_regs, idr1),
 			     &idr1);
-		et131x_phy_mii_read(etdev, xcvr_addr,
+		et131x_phy_mii_read(adapter, xcvr_addr,
 			     (u8) offsetof(struct mi_regs, idr2),
 			     &idr2);
 
 		xcvr_id = (u32) ((idr1 << 16) | idr2);
 
 		if (idr1 != 0 && idr1 != 0xffff) {
-			etdev->stats.xcvr_id = xcvr_id;
-			etdev->stats.xcvr_addr = xcvr_addr;
+			adapter->stats.xcvr_id = xcvr_id;
+			adapter->stats.xcvr_addr = xcvr_addr;
 			return 0;
 		}
 	}
 	return -ENODEV;
 }
 
-void et1310_phy_reset(struct et131x_adapter *etdev)
+void et1310_phy_reset(struct et131x_adapter *adapter)
 {
-	et131x_mii_write(etdev, PHY_CONTROL, 0x8000);
+	et131x_mii_write(adapter, PHY_CONTROL, 0x8000);
 }
 
 /**
  *	et1310_phy_power_down	-	PHY power control
- *	@etdev: device to control
+ *	@adapter: device to control
  *	@down: true for off/false for back on
  *
  *	one hundred, ten, one thousand megs
@@ -280,77 +280,77 @@ void et1310_phy_reset(struct et131x_adapter *etdev)
  *	Can't you see that this code processed
  *	Phy power, phy power..
  */
-void et1310_phy_power_down(struct et131x_adapter *etdev, bool down)
+void et1310_phy_power_down(struct et131x_adapter *adapter, bool down)
 {
 	u16 data;
 
-	et131x_mii_read(etdev, PHY_CONTROL, &data);
+	et131x_mii_read(adapter, PHY_CONTROL, &data);
 	data &= ~0x0800;	/* Power UP */
 	if (down) /* Power DOWN */
 		data |= 0x0800;
-	et131x_mii_write(etdev, PHY_CONTROL, data);
+	et131x_mii_write(adapter, PHY_CONTROL, data);
 }
 
 /**
  *	et1310_phy_auto_neg	-	autonegotiate control
- *	@etdev: device to control
+ *	@adapter: device to control
  *	@enabe: autoneg on/off
  *
  *	Set up the autonegotiation state according to whether we will be
  *	negotiating the state or forcing a speed.
  */
-static void et1310_phy_auto_neg(struct et131x_adapter *etdev, bool enable)
+static void et1310_phy_auto_neg(struct et131x_adapter *adapter, bool enable)
 {
 	u16 data;
 
-	et131x_mii_read(etdev, PHY_CONTROL, &data);
+	et131x_mii_read(adapter, PHY_CONTROL, &data);
 	data &= ~0x1000;	/* Autonegotiation OFF */
 	if (enable)
 		data |= 0x1000;		/* Autonegotiation ON */
-	et131x_mii_write(etdev, PHY_CONTROL, data);
+	et131x_mii_write(adapter, PHY_CONTROL, data);
 }
 
 /**
  *	et1310_phy_duplex_mode	-	duplex control
- *	@etdev: device to control
+ *	@adapter: device to control
  *	@duplex: duplex on/off
  *
  *	Set up the duplex state on the PHY
  */
-static void et1310_phy_duplex_mode(struct et131x_adapter *etdev, u16 duplex)
+static void et1310_phy_duplex_mode(struct et131x_adapter *adapter, u16 duplex)
 {
 	u16 data;
 
-	et131x_mii_read(etdev, PHY_CONTROL, &data);
+	et131x_mii_read(adapter, PHY_CONTROL, &data);
 	data &= ~0x100;		/* Set Half Duplex */
 	if (duplex == TRUEPHY_DUPLEX_FULL)
 		data |= 0x100;	/* Set Full Duplex */
-	et131x_mii_write(etdev, PHY_CONTROL, data);
+	et131x_mii_write(adapter, PHY_CONTROL, data);
 }
 
 /**
  *	et1310_phy_speed_select	-	speed control
- *	@etdev: device to control
+ *	@adapter: device to control
  *	@duplex: duplex on/off
  *
  *	Set the speed of our PHY.
  */
-static void et1310_phy_speed_select(struct et131x_adapter *etdev, u16 speed)
+static void et1310_phy_speed_select(struct et131x_adapter *adapter, u16 speed)
 {
 	u16 data;
 	static const u16 bits[3] = {0x0000, 0x2000, 0x0040};
 
 	/* Read the PHY control register */
-	et131x_mii_read(etdev, PHY_CONTROL, &data);
+	et131x_mii_read(adapter, PHY_CONTROL, &data);
 	/* Clear all Speed settings (Bits 6, 13) */
 	data &= ~0x2040;
 	/* Write back the new speed */
-	et131x_mii_write(etdev, PHY_CONTROL, data | bits[speed]);
+	et131x_mii_write(adapter, PHY_CONTROL, data | bits[speed]);
 }
 
 /**
  *	et1310_phy_link_status	-	read link state
- *	@etdev: device to read
+ *	@adapter: device to read
  *	@link_status: reported link state
  *	@autoneg: reported autonegotiation state (complete/incomplete/disabled)
  *	@linkspeed: returnedlink speed in use
@@ -364,7 +364,7 @@ static void et1310_phy_speed_select(struct et131x_adapter *etdev, u16 speed)
  *	I know your link speed
  *	I see all the setting that you'd rather keep
  */
-static void et1310_phy_link_status(struct et131x_adapter *etdev,
+static void et1310_phy_link_status(struct et131x_adapter *adapter,
 			  u8 *link_status,
 			  u32 *autoneg,
 			  u32 *linkspeed,
@@ -377,10 +377,10 @@ static void et1310_phy_link_status(struct et131x_adapter *etdev,
 	u16 vmi_phystatus = 0;
 	u16 control = 0;
 
-	et131x_mii_read(etdev, PHY_STATUS, &mistatus);
-	et131x_mii_read(etdev, PHY_1000_STATUS, &is1000BaseT);
-	et131x_mii_read(etdev, PHY_PHY_STATUS, &vmi_phystatus);
-	et131x_mii_read(etdev, PHY_CONTROL, &control);
+	et131x_mii_read(adapter, PHY_STATUS, &mistatus);
+	et131x_mii_read(adapter, PHY_1000_STATUS, &is1000BaseT);
+	et131x_mii_read(adapter, PHY_PHY_STATUS, &vmi_phystatus);
+	et131x_mii_read(adapter, PHY_CONTROL, &control);
 
 	*link_status = (vmi_phystatus & 0x0040) ? 1 : 0;
 	*autoneg = (control & 0x1000) ? ((vmi_phystatus & 0x0020) ?
@@ -398,26 +398,26 @@ static void et1310_phy_link_status(struct et131x_adapter *etdev,
 			TRUEPHY_POLARITY_INVERTED : TRUEPHY_POLARITY_NORMAL;
 }
 
-static void et1310_phy_and_or_reg(struct et131x_adapter *etdev,
+static void et1310_phy_and_or_reg(struct et131x_adapter *adapter,
 				  u16 regnum, u16 and_mask, u16 or_mask)
 {
 	u16 reg;
 
-	et131x_mii_read(etdev, regnum, &reg);
+	et131x_mii_read(adapter, regnum, &reg);
 	reg &= and_mask;
 	reg |= or_mask;
-	et131x_mii_write(etdev, regnum, reg);
+	et131x_mii_write(adapter, regnum, reg);
 }
 
 /* Still used from _mac for BIT_READ */
-void et1310_phy_access_mii_bit(struct et131x_adapter *etdev, u16 action,
+void et1310_phy_access_mii_bit(struct et131x_adapter *adapter, u16 action,
 			       u16 regnum, u16 bitnum, u8 *value)
 {
 	u16 reg;
 	u16 mask = 0x0001 << bitnum;
 
 	/* Read the requested register */
-	et131x_mii_read(etdev, regnum, &reg);
+	et131x_mii_read(adapter, regnum, &reg);
 
 	switch (action) {
 	case TRUEPHY_BIT_READ:
@@ -425,11 +425,11 @@ void et1310_phy_access_mii_bit(struct et131x_adapter *etdev, u16 action,
 		break;
 
 	case TRUEPHY_BIT_SET:
-		et131x_mii_write(etdev, regnum, reg | mask);
+		et131x_mii_write(adapter, regnum, reg | mask);
 		break;
 
 	case TRUEPHY_BIT_CLEAR:
-		et131x_mii_write(etdev, regnum, reg & ~mask);
+		et131x_mii_write(adapter, regnum, reg & ~mask);
 		break;
 
 	default:
@@ -437,13 +437,13 @@ void et1310_phy_access_mii_bit(struct et131x_adapter *etdev, u16 action,
 	}
 }
 
-void et1310_phy_advertise_1000BaseT(struct et131x_adapter *etdev,
+void et1310_phy_advertise_1000BaseT(struct et131x_adapter *adapter,
 				  u16 duplex)
 {
 	u16 data;
 
 	/* Read the PHY 1000 Base-T Control Register */
-	et131x_mii_read(etdev, PHY_1000_CONTROL, &data);
+	et131x_mii_read(adapter, PHY_1000_CONTROL, &data);
 
 	/* Clear Bits 8,9 */
 	data &= ~0x0300;
@@ -470,16 +470,16 @@ void et1310_phy_advertise_1000BaseT(struct et131x_adapter *etdev,
 	}
 
 	/* Write back advertisement */
-	et131x_mii_write(etdev, PHY_1000_CONTROL, data);
+	et131x_mii_write(adapter, PHY_1000_CONTROL, data);
 }
 
-static void et1310_phy_advertise_100BaseT(struct et131x_adapter *etdev,
+static void et1310_phy_advertise_100BaseT(struct et131x_adapter *adapter,
 					  u16 duplex)
 {
 	u16 data;
 
 	/* Read the Autonegotiation Register (10/100) */
-	et131x_mii_read(etdev, PHY_AUTO_ADVERTISEMENT, &data);
+	et131x_mii_read(adapter, PHY_AUTO_ADVERTISEMENT, &data);
 
 	/* Clear bits 7,8 */
 	data &= ~0x0180;
@@ -507,16 +507,16 @@ static void et1310_phy_advertise_100BaseT(struct et131x_adapter *etdev,
 	}
 
 	/* Write back advertisement */
-	et131x_mii_write(etdev, PHY_AUTO_ADVERTISEMENT, data);
+	et131x_mii_write(adapter, PHY_AUTO_ADVERTISEMENT, data);
 }
 
-static void et1310_phy_advertise_10BaseT(struct et131x_adapter *etdev,
+static void et1310_phy_advertise_10BaseT(struct et131x_adapter *adapter,
 				u16 duplex)
 {
 	u16 data;
 
 	/* Read the Autonegotiation Register (10/100) */
-	et131x_mii_read(etdev, PHY_AUTO_ADVERTISEMENT, &data);
+	et131x_mii_read(adapter, PHY_AUTO_ADVERTISEMENT, &data);
 
 	/* Clear bits 5,6 */
 	data &= ~0x0060;
@@ -544,32 +544,32 @@ static void et1310_phy_advertise_10BaseT(struct et131x_adapter *etdev,
 	}
 
 	/* Write back advertisement */
-	et131x_mii_write(etdev, PHY_AUTO_ADVERTISEMENT, data);
+	et131x_mii_write(adapter, PHY_AUTO_ADVERTISEMENT, data);
 }
 
 /**
  * et131x_xcvr_init - Init the phy if we are setting it into force mode
- * @etdev: pointer to our private adapter structure
+ * @adapter: pointer to our private adapter structure
  *
  */
-static void et131x_xcvr_init(struct et131x_adapter *etdev)
+static void et131x_xcvr_init(struct et131x_adapter *adapter)
 {
 	u16 imr;
 	u16 isr;
 	u16 lcr2;
 
 	/* Zero out the adapter structure variable representing BMSR */
-	etdev->bmsr = 0;
+	adapter->bmsr = 0;
 
-	et131x_mii_read(etdev, (u8) offsetof(struct mi_regs, isr), &isr);
-	et131x_mii_read(etdev, (u8) offsetof(struct mi_regs, imr), &imr);
+	et131x_mii_read(adapter, (u8) offsetof(struct mi_regs, isr), &isr);
+	et131x_mii_read(adapter, (u8) offsetof(struct mi_regs, imr), &imr);
 
 	/* Set the link status interrupt only.  Bad behavior when link status
 	 * and auto neg are set, we run into a nested interrupt problem
 	 */
 	imr |= 0x0105;
 
-	et131x_mii_write(etdev, (u8) offsetof(struct mi_regs, imr), imr);
+	et131x_mii_write(adapter, (u8) offsetof(struct mi_regs, imr), imr);
 
 	/* Set the LED behavior such that LED 1 indicates speed (off =
 	 * 10Mbits, blink = 100Mbits, on = 1000Mbits) and LED 2 indicates
@@ -579,150 +579,150 @@ static void et131x_xcvr_init(struct et131x_adapter *etdev)
 	 * vendors; The LED behavior is now determined by vendor data in the
 	 * EEPROM. However, the above description is the default.
 	 */
-	if ((etdev->eeprom_data[1] & 0x4) == 0) {
-		et131x_mii_read(etdev, (u8) offsetof(struct mi_regs, lcr2),
+	if ((adapter->eeprom_data[1] & 0x4) == 0) {
+		et131x_mii_read(adapter, (u8) offsetof(struct mi_regs, lcr2),
 		       &lcr2);
 
 		lcr2 &= 0x00FF;
 		lcr2 |= 0xA000;	/* led link */
 
-		if ((etdev->eeprom_data[1] & 0x8) == 0)
+		if ((adapter->eeprom_data[1] & 0x8) == 0)
 			lcr2 |= 0x0300;
 		else
 			lcr2 |= 0x0400;
 
-		et131x_mii_write(etdev, (u8) offsetof(struct mi_regs, lcr2),
+		et131x_mii_write(adapter, (u8) offsetof(struct mi_regs, lcr2),
 			lcr2);
 	}
 
 	/* Determine if we need to go into a force mode and set it */
-	if (etdev->ai_force_speed == 0 && etdev->ai_force_duplex == 0) {
-		if (etdev->wanted_flow == FLOW_TXONLY ||
-		    etdev->wanted_flow == FLOW_BOTH)
-			et1310_phy_access_mii_bit(etdev,
+	if (adapter->ai_force_speed == 0 && adapter->ai_force_duplex == 0) {
+		if (adapter->wanted_flow == FLOW_TXONLY ||
+		    adapter->wanted_flow == FLOW_BOTH)
+			et1310_phy_access_mii_bit(adapter,
 					      TRUEPHY_BIT_SET, 4, 11, NULL);
 		else
-			et1310_phy_access_mii_bit(etdev,
+			et1310_phy_access_mii_bit(adapter,
 					      TRUEPHY_BIT_CLEAR, 4, 11, NULL);
 
-		if (etdev->wanted_flow == FLOW_BOTH)
-			et1310_phy_access_mii_bit(etdev,
+		if (adapter->wanted_flow == FLOW_BOTH)
+			et1310_phy_access_mii_bit(adapter,
 					      TRUEPHY_BIT_SET, 4, 10, NULL);
 		else
-			et1310_phy_access_mii_bit(etdev,
+			et1310_phy_access_mii_bit(adapter,
 					      TRUEPHY_BIT_CLEAR, 4, 10, NULL);
 
 		/* Set the phy to autonegotiation */
-		et1310_phy_auto_neg(etdev, true);
+		et1310_phy_auto_neg(adapter, true);
 
 		/* NOTE - Do we need this? */
-		et1310_phy_access_mii_bit(etdev, TRUEPHY_BIT_SET, 0, 9, NULL);
+		et1310_phy_access_mii_bit(adapter, TRUEPHY_BIT_SET, 0, 9, NULL);
 		return;
 	}
 
-	et1310_phy_auto_neg(etdev, false);
+	et1310_phy_auto_neg(adapter, false);
 
 	/* Set to the correct force mode. */
-	if (etdev->ai_force_duplex != 1) {
-		if (etdev->wanted_flow == FLOW_TXONLY ||
-		    etdev->wanted_flow == FLOW_BOTH)
-			et1310_phy_access_mii_bit(etdev,
+	if (adapter->ai_force_duplex != 1) {
+		if (adapter->wanted_flow == FLOW_TXONLY ||
+		    adapter->wanted_flow == FLOW_BOTH)
+			et1310_phy_access_mii_bit(adapter,
 				      TRUEPHY_BIT_SET, 4, 11, NULL);
 		else
-			et1310_phy_access_mii_bit(etdev,
+			et1310_phy_access_mii_bit(adapter,
 					      TRUEPHY_BIT_CLEAR, 4, 11, NULL);
 
-		if (etdev->wanted_flow == FLOW_BOTH)
-			et1310_phy_access_mii_bit(etdev,
+		if (adapter->wanted_flow == FLOW_BOTH)
+			et1310_phy_access_mii_bit(adapter,
 					      TRUEPHY_BIT_SET, 4, 10, NULL);
 		else
-			et1310_phy_access_mii_bit(etdev,
+			et1310_phy_access_mii_bit(adapter,
 					      TRUEPHY_BIT_CLEAR, 4, 10, NULL);
 	} else {
-		et1310_phy_access_mii_bit(etdev, TRUEPHY_BIT_CLEAR,
+		et1310_phy_access_mii_bit(adapter, TRUEPHY_BIT_CLEAR,
 					  4, 10, NULL);
-		et1310_phy_access_mii_bit(etdev, TRUEPHY_BIT_CLEAR,
+		et1310_phy_access_mii_bit(adapter, TRUEPHY_BIT_CLEAR,
 					  4, 11, NULL);
 	}
-	et1310_phy_power_down(etdev, 1);
-	switch (etdev->ai_force_speed) {
+	et1310_phy_power_down(adapter, 1);
+	switch (adapter->ai_force_speed) {
 	case 10:
 		/* First we need to turn off all other advertisement */
-		et1310_phy_advertise_1000BaseT(etdev, TRUEPHY_ADV_DUPLEX_NONE);
-		et1310_phy_advertise_100BaseT(etdev, TRUEPHY_ADV_DUPLEX_NONE);
-		if (etdev->ai_force_duplex == 1) {
+		et1310_phy_advertise_1000BaseT(adapter, TRUEPHY_ADV_DUPLEX_NONE);
+		et1310_phy_advertise_100BaseT(adapter, TRUEPHY_ADV_DUPLEX_NONE);
+		if (adapter->ai_force_duplex == 1) {
 			/* Set our advertise values accordingly */
-			et1310_phy_advertise_10BaseT(etdev,
+			et1310_phy_advertise_10BaseT(adapter,
 						TRUEPHY_ADV_DUPLEX_HALF);
-		} else if (etdev->ai_force_duplex == 2) {
+		} else if (adapter->ai_force_duplex == 2) {
 			/* Set our advertise values accordingly */
-			et1310_phy_advertise_10BaseT(etdev,
+			et1310_phy_advertise_10BaseT(adapter,
 						TRUEPHY_ADV_DUPLEX_FULL);
 		} else {
 			/* Disable autoneg */
-			et1310_phy_auto_neg(etdev, false);
+			et1310_phy_auto_neg(adapter, false);
 			/* Disable rest of the advertisements */
-			et1310_phy_advertise_10BaseT(etdev,
+			et1310_phy_advertise_10BaseT(adapter,
 					TRUEPHY_ADV_DUPLEX_NONE);
 			/* Force 10 Mbps */
-			et1310_phy_speed_select(etdev, TRUEPHY_SPEED_10MBPS);
+			et1310_phy_speed_select(adapter, TRUEPHY_SPEED_10MBPS);
 			/* Force Full duplex */
-			et1310_phy_duplex_mode(etdev, TRUEPHY_DUPLEX_FULL);
+			et1310_phy_duplex_mode(adapter, TRUEPHY_DUPLEX_FULL);
 		}
 		break;
 	case 100:
 		/* first we need to turn off all other advertisement */
-		et1310_phy_advertise_1000BaseT(etdev, TRUEPHY_ADV_DUPLEX_NONE);
-		et1310_phy_advertise_10BaseT(etdev, TRUEPHY_ADV_DUPLEX_NONE);
-		if (etdev->ai_force_duplex == 1) {
+		et1310_phy_advertise_1000BaseT(adapter, TRUEPHY_ADV_DUPLEX_NONE);
+		et1310_phy_advertise_10BaseT(adapter, TRUEPHY_ADV_DUPLEX_NONE);
+		if (adapter->ai_force_duplex == 1) {
 			/* Set our advertise values accordingly */
-			et1310_phy_advertise_100BaseT(etdev,
+			et1310_phy_advertise_100BaseT(adapter,
 						TRUEPHY_ADV_DUPLEX_HALF);
 			/* Set speed */
-			et1310_phy_speed_select(etdev, TRUEPHY_SPEED_100MBPS);
-		} else if (etdev->ai_force_duplex == 2) {
+			et1310_phy_speed_select(adapter, TRUEPHY_SPEED_100MBPS);
+		} else if (adapter->ai_force_duplex == 2) {
 			/* Set our advertise values accordingly */
-			et1310_phy_advertise_100BaseT(etdev,
+			et1310_phy_advertise_100BaseT(adapter,
 						TRUEPHY_ADV_DUPLEX_FULL);
 		} else {
 			/* Disable autoneg */
-			et1310_phy_auto_neg(etdev, false);
+			et1310_phy_auto_neg(adapter, false);
 			/* Disable other advertisement */
-			et1310_phy_advertise_100BaseT(etdev,
+			et1310_phy_advertise_100BaseT(adapter,
 						TRUEPHY_ADV_DUPLEX_NONE);
 			/* Force 100 Mbps */
-			et1310_phy_speed_select(etdev, TRUEPHY_SPEED_100MBPS);
+			et1310_phy_speed_select(adapter, TRUEPHY_SPEED_100MBPS);
 			/* Force Full duplex */
-			et1310_phy_duplex_mode(etdev, TRUEPHY_DUPLEX_FULL);
+			et1310_phy_duplex_mode(adapter, TRUEPHY_DUPLEX_FULL);
 		}
 		break;
 	case 1000:
 		/* first we need to turn off all other advertisement */
-		et1310_phy_advertise_100BaseT(etdev, TRUEPHY_ADV_DUPLEX_NONE);
-		et1310_phy_advertise_10BaseT(etdev, TRUEPHY_ADV_DUPLEX_NONE);
+		et1310_phy_advertise_100BaseT(adapter, TRUEPHY_ADV_DUPLEX_NONE);
+		et1310_phy_advertise_10BaseT(adapter, TRUEPHY_ADV_DUPLEX_NONE);
 		/* set our advertise values accordingly */
-		et1310_phy_advertise_1000BaseT(etdev, TRUEPHY_ADV_DUPLEX_FULL);
+		et1310_phy_advertise_1000BaseT(adapter, TRUEPHY_ADV_DUPLEX_FULL);
 		break;
 	}
-	et1310_phy_power_down(etdev, 0);
+	et1310_phy_power_down(adapter, 0);
 }
 
 /**
  * et131x_setphy_normal - Set PHY for normal operation.
- * @etdev: pointer to our private adapter structure
+ * @adapter: pointer to our private adapter structure
  *
  * Used by Power Management to force the PHY into 10 Base T half-duplex mode,
  * when going to D3 in WOL mode. Also used during initialization to set the
  * PHY for normal operation.
  */
-void et131x_setphy_normal(struct et131x_adapter *etdev)
+void et131x_setphy_normal(struct et131x_adapter *adapter)
 {
 	/* Make sure the PHY is powered up */
-	et1310_phy_power_down(etdev, 0);
-	et131x_xcvr_init(etdev);
+	et1310_phy_power_down(adapter, 0);
+	et131x_xcvr_init(adapter);
 }
 
-void et131x_mii_check(struct et131x_adapter *etdev,
+void et131x_mii_check(struct et131x_adapter *adapter,
 		      u16 bmsr, u16 bmsr_ints)
 {
 	u8 link_status;
@@ -736,36 +736,36 @@ void et131x_mii_check(struct et131x_adapter *etdev,
 
 	if (bmsr_ints & MI_BMSR_LINK_STATUS) {
 		if (bmsr & MI_BMSR_LINK_STATUS) {
-			etdev->boot_coma = 20;
+			adapter->boot_coma = 20;
 
 			/* Update our state variables and indicate the
 			 * connected state
 			 */
-			spin_lock_irqsave(&etdev->lock, flags);
+			spin_lock_irqsave(&adapter->lock, flags);
 
-			etdev->media_state = NETIF_STATUS_MEDIA_CONNECT;
+			adapter->media_state = NETIF_STATUS_MEDIA_CONNECT;
 
-			spin_unlock_irqrestore(&etdev->lock, flags);
+			spin_unlock_irqrestore(&adapter->lock, flags);
 
-			netif_carrier_on(etdev->netdev);
+			netif_carrier_on(adapter->netdev);
 		} else {
-			dev_warn(&etdev->pdev->dev,
+			dev_warn(&adapter->pdev->dev,
 			    "Link down - cable problem ?\n");
 
-			if (etdev->linkspeed == TRUEPHY_SPEED_10MBPS) {
+			if (adapter->linkspeed == TRUEPHY_SPEED_10MBPS) {
 				/* NOTE - Is there a way to query this without
 				 * TruePHY?
-				 * && TRU_QueryCoreType(etdev->hTruePhy, 0) ==
+				 * && TRU_QueryCoreType(adapter->hTruePhy, 0) ==
 				 * EMI_TRUEPHY_A13O) {
 				 */
 				u16 register18;
 
-				et131x_mii_read(etdev, 0x12, &register18);
-				et131x_mii_write(etdev, 0x12, register18 | 0x4);
-				et131x_mii_write(etdev, 0x10,
+				et131x_mii_read(adapter, 0x12, &register18);
+				et131x_mii_write(adapter, 0x12, register18 | 0x4);
+				et131x_mii_write(adapter, 0x10,
 						 register18 | 0x8402);
-				et131x_mii_write(etdev, 0x11, register18 | 511);
-				et131x_mii_write(etdev, 0x12, register18);
+				et131x_mii_write(adapter, 0x11, register18 | 511);
+				et131x_mii_write(adapter, 0x12, register18);
 			}
 
 			/* For the first N seconds of life, we are in "link
@@ -774,27 +774,27 @@ void et131x_mii_check(struct et131x_adapter *etdev,
 			 * Timer expires, we can report disconnected (handled
 			 * in the LinkDetectionDPC).
 			 */
-			if (etdev->media_state == NETIF_STATUS_MEDIA_DISCONNECT) {
-				spin_lock_irqsave(&etdev->lock, flags);
-				etdev->media_state =
+			if (adapter->media_state == NETIF_STATUS_MEDIA_DISCONNECT) {
+				spin_lock_irqsave(&adapter->lock, flags);
+				adapter->media_state =
 				    NETIF_STATUS_MEDIA_DISCONNECT;
-				spin_unlock_irqrestore(&etdev->lock,
+				spin_unlock_irqrestore(&adapter->lock,
 						       flags);
 
-				netif_carrier_off(etdev->netdev);
+				netif_carrier_off(adapter->netdev);
 			}
 
-			etdev->linkspeed = 0;
-			etdev->duplex_mode = 0;
+			adapter->linkspeed = 0;
+			adapter->duplex_mode = 0;
 
 			/* Free the packets being actively sent & stopped */
-			et131x_free_busy_send_packets(etdev);
+			et131x_free_busy_send_packets(adapter);
 
 			/* Re-initialize the send structures */
-			et131x_init_send(etdev);
+			et131x_init_send(adapter);
 
 			/* Reset the RFD list and re-start RU */
-			et131x_reset_recv(etdev);
+			et131x_reset_recv(adapter);
 
 			/*
 			 * Bring the device back to the state it was during
@@ -802,59 +802,59 @@ void et131x_mii_check(struct et131x_adapter *etdev,
 			 * way, when we get the auto-neg complete interrupt,
 			 * we can complete init by calling config_mac_regs2.
 			 */
-			et131x_soft_reset(etdev);
+			et131x_soft_reset(adapter);
 
 			/* Setup ET1310 as per the documentation */
-			et131x_adapter_setup(etdev);
+			et131x_adapter_setup(adapter);
 
 			/* Setup the PHY into coma mode until the cable is
 			 * plugged back in
 			 */
-			if (etdev->registry_phy_coma == 1)
-				et1310_enable_phy_coma(etdev);
+			if (adapter->registry_phy_coma == 1)
+				et1310_enable_phy_coma(adapter);
 		}
 	}
 
 	if ((bmsr_ints & MI_BMSR_AUTO_NEG_COMPLETE) ||
-	   (etdev->ai_force_duplex == 3 && (bmsr_ints & MI_BMSR_LINK_STATUS))) {
+	   (adapter->ai_force_duplex == 3 && (bmsr_ints & MI_BMSR_LINK_STATUS))) {
 		if ((bmsr & MI_BMSR_AUTO_NEG_COMPLETE) ||
-		    etdev->ai_force_duplex == 3) {
-			et1310_phy_link_status(etdev,
+		    adapter->ai_force_duplex == 3) {
+			et1310_phy_link_status(adapter,
 					     &link_status, &autoneg_status,
 					     &speed, &duplex, &mdi_mdix,
 					     &masterslave, &polarity);
 
-			etdev->linkspeed = speed;
-			etdev->duplex_mode = duplex;
+			adapter->linkspeed = speed;
+			adapter->duplex_mode = duplex;
 
-			etdev->boot_coma = 20;
+			adapter->boot_coma = 20;
 
-			if (etdev->linkspeed == TRUEPHY_SPEED_10MBPS) {
+			if (adapter->linkspeed == TRUEPHY_SPEED_10MBPS) {
 				/*
 				 * NOTE - Is there a way to query this without
 				 * TruePHY?
-				 * && TRU_QueryCoreType(etdev->hTruePhy, 0)==
+				 * && TRU_QueryCoreType(adapter->hTruePhy, 0)==
 				 * EMI_TRUEPHY_A13O) {
 				 */
 				u16 register18;
 
-				et131x_mii_read(etdev, 0x12, &register18);
-				et131x_mii_write(etdev, 0x12, register18 | 0x4);
-				et131x_mii_write(etdev, 0x10,
+				et131x_mii_read(adapter, 0x12, &register18);
+				et131x_mii_write(adapter, 0x12, register18 | 0x4);
+				et131x_mii_write(adapter, 0x10,
 						 register18 | 0x8402);
-				et131x_mii_write(etdev, 0x11, register18 | 511);
-				et131x_mii_write(etdev, 0x12, register18);
+				et131x_mii_write(adapter, 0x11, register18 | 511);
+				et131x_mii_write(adapter, 0x12, register18);
 			}
 
-			et1310_config_flow_control(etdev);
+			et1310_config_flow_control(adapter);
 
-			if (etdev->linkspeed == TRUEPHY_SPEED_1000MBPS &&
-					etdev->registry_jumbo_packet > 2048)
-				et1310_phy_and_or_reg(etdev, 0x16, 0xcfff,
+			if (adapter->linkspeed == TRUEPHY_SPEED_1000MBPS &&
+					adapter->registry_jumbo_packet > 2048)
+				et1310_phy_and_or_reg(adapter, 0x16, 0xcfff,
 								   0x2000);
 
-			et131x_set_rx_dma_timer(etdev);
-			et1310_config_mac_regs2(etdev);
+			et131x_set_rx_dma_timer(adapter);
+			et1310_config_mac_regs2(adapter);
 		}
 	}
 }
@@ -904,71 +904,71 @@ static const u16 config_phy[25][2] = {
 };
 
 /* condensed version of the phy initialization routine */
-void et1310_phy_init(struct et131x_adapter *etdev)
+void et1310_phy_init(struct et131x_adapter *adapter)
 {
 	u16 data, index;
 
 	/* get the identity (again ?) */
-	et131x_mii_read(etdev, PHY_ID_1, &data);
-	et131x_mii_read(etdev, PHY_ID_2, &data);
+	et131x_mii_read(adapter, PHY_ID_1, &data);
+	et131x_mii_read(adapter, PHY_ID_2, &data);
 
 	/* what does this do/achieve ? */
 	/* should read 0002 */
-	et131x_mii_read(etdev, PHY_MPHY_CONTROL_REG, &data);
-	et131x_mii_write(etdev, PHY_MPHY_CONTROL_REG,	0x0006);
+	et131x_mii_read(adapter, PHY_MPHY_CONTROL_REG, &data);
+	et131x_mii_write(adapter, PHY_MPHY_CONTROL_REG,	0x0006);
 
 	/* read modem register 0402, should I do something with the return
 	   data ? */
-	et131x_mii_write(etdev, PHY_INDEX_REG, 0x0402);
-	et131x_mii_read(etdev, PHY_DATA_REG, &data);
+	et131x_mii_write(adapter, PHY_INDEX_REG, 0x0402);
+	et131x_mii_read(adapter, PHY_DATA_REG, &data);
 
 	/* what does this do/achieve ? */
-	et131x_mii_write(etdev, PHY_MPHY_CONTROL_REG, 0x0002);
+	et131x_mii_write(adapter, PHY_MPHY_CONTROL_REG, 0x0002);
 
 	/* get the identity (again ?) */
-	et131x_mii_read(etdev, PHY_ID_1, &data);
-	et131x_mii_read(etdev, PHY_ID_2, &data);
+	et131x_mii_read(adapter, PHY_ID_1, &data);
+	et131x_mii_read(adapter, PHY_ID_2, &data);
 
 	/* what does this achieve ? */
 	/* should read 0002 */
-	et131x_mii_read(etdev, PHY_MPHY_CONTROL_REG, &data);
-	et131x_mii_write(etdev, PHY_MPHY_CONTROL_REG, 0x0006);
+	et131x_mii_read(adapter, PHY_MPHY_CONTROL_REG, &data);
+	et131x_mii_write(adapter, PHY_MPHY_CONTROL_REG, 0x0006);
 
 	/* read modem register 0402, should I do something with
 	   the return data? */
-	et131x_mii_write(etdev, PHY_INDEX_REG, 0x0402);
-	et131x_mii_read(etdev, PHY_DATA_REG, &data);
+	et131x_mii_write(adapter, PHY_INDEX_REG, 0x0402);
+	et131x_mii_read(adapter, PHY_DATA_REG, &data);
 
-	et131x_mii_write(etdev, PHY_MPHY_CONTROL_REG, 0x0002);
+	et131x_mii_write(adapter, PHY_MPHY_CONTROL_REG, 0x0002);
 
 	/* what does this achieve (should return 0x1040) */
-	et131x_mii_read(etdev, PHY_CONTROL, &data);
+	et131x_mii_read(adapter, PHY_CONTROL, &data);
 	/* should read 0002 */
-	et131x_mii_read(etdev, PHY_MPHY_CONTROL_REG, &data);
-	et131x_mii_write(etdev, PHY_CONTROL, 0x1840);
+	et131x_mii_read(adapter, PHY_MPHY_CONTROL_REG, &data);
+	et131x_mii_write(adapter, PHY_CONTROL, 0x1840);
 
-	et131x_mii_write(etdev, PHY_MPHY_CONTROL_REG, 0x0007);
+	et131x_mii_write(adapter, PHY_MPHY_CONTROL_REG, 0x0007);
 
 	/* here the writing of the array starts.... */
 	index = 0;
 	while (config_phy[index][0] != 0x0000) {
 		/* write value */
-		et131x_mii_write(etdev, PHY_INDEX_REG, config_phy[index][0]);
-		et131x_mii_write(etdev, PHY_DATA_REG, config_phy[index][1]);
+		et131x_mii_write(adapter, PHY_INDEX_REG, config_phy[index][0]);
+		et131x_mii_write(adapter, PHY_DATA_REG, config_phy[index][1]);
 
 		/* read it back */
-		et131x_mii_write(etdev, PHY_INDEX_REG, config_phy[index][0]);
-		et131x_mii_read(etdev, PHY_DATA_REG, &data);
+		et131x_mii_write(adapter, PHY_INDEX_REG, config_phy[index][0]);
+		et131x_mii_read(adapter, PHY_DATA_REG, &data);
 
 		/* do a check on the value read back ? */
 		index++;
 	}
 	/* here the writing of the array ends... */
 
-	et131x_mii_read(etdev, PHY_CONTROL, &data);		/* 0x1840 */
+	et131x_mii_read(adapter, PHY_CONTROL, &data);		/* 0x1840 */
 	/* should read 0007 */
-	et131x_mii_read(etdev, PHY_MPHY_CONTROL_REG, &data);
-	et131x_mii_write(etdev, PHY_CONTROL, 0x1040);
-	et131x_mii_write(etdev, PHY_MPHY_CONTROL_REG, 0x0002);
+	et131x_mii_read(adapter, PHY_MPHY_CONTROL_REG, &data);
+	et131x_mii_write(adapter, PHY_CONTROL, 0x1040);
+	et131x_mii_write(adapter, PHY_MPHY_CONTROL_REG, 0x0002);
 }
 
diff --git a/drivers/staging/et131x/et1310_pm.c b/drivers/staging/et131x/et1310_pm.c
index 914aff6..5ebf064 100644
--- a/drivers/staging/et131x/et1310_pm.c
+++ b/drivers/staging/et131x/et1310_pm.c
@@ -88,7 +88,7 @@
 
 /**
  * et1310_enable_phy_coma - called when network cable is unplugged
- * @etdev: pointer to our adapter structure
+ * @adapter: pointer to our adapter structure
  *
  * driver receive an phy status change interrupt while in D0 and check that
  * phy_status is down.
@@ -106,75 +106,75 @@
  *       indicating linkup status, call the MPDisablePhyComa routine to
  *             restore JAGCore and gigE PHY
  */
-void et1310_enable_phy_coma(struct et131x_adapter *etdev)
+void et1310_enable_phy_coma(struct et131x_adapter *adapter)
 {
 	unsigned long flags;
 	u32 pmcsr;
 
-	pmcsr = readl(&etdev->regs->global.pm_csr);
+	pmcsr = readl(&adapter->regs->global.pm_csr);
 
 	/* Save the GbE PHY speed and duplex modes. Need to restore this
 	 * when cable is plugged back in
 	 */
-	etdev->pdown_speed = etdev->ai_force_speed;
-	etdev->pdown_duplex = etdev->ai_force_duplex;
+	adapter->pdown_speed = adapter->ai_force_speed;
+	adapter->pdown_duplex = adapter->ai_force_duplex;
 
 	/* Stop sending packets. */
-	spin_lock_irqsave(&etdev->send_hw_lock, flags);
-	etdev->flags |= fMP_ADAPTER_LOWER_POWER;
-	spin_unlock_irqrestore(&etdev->send_hw_lock, flags);
+	spin_lock_irqsave(&adapter->send_hw_lock, flags);
+	adapter->flags |= fMP_ADAPTER_LOWER_POWER;
+	spin_unlock_irqrestore(&adapter->send_hw_lock, flags);
 
 	/* Wait for outstanding Receive packets */
 
 	/* Gate off JAGCore 3 clock domains */
 	pmcsr &= ~ET_PMCSR_INIT;
-	writel(pmcsr, &etdev->regs->global.pm_csr);
+	writel(pmcsr, &adapter->regs->global.pm_csr);
 
 	/* Program gigE PHY in to Coma mode */
 	pmcsr |= ET_PM_PHY_SW_COMA;
-	writel(pmcsr, &etdev->regs->global.pm_csr);
+	writel(pmcsr, &adapter->regs->global.pm_csr);
 }
 
 /**
  * et1310_disable_phy_coma - Disable the Phy Coma Mode
- * @etdev: pointer to our adapter structure
+ * @adapter: pointer to our adapter structure
  */
-void et1310_disable_phy_coma(struct et131x_adapter *etdev)
+void et1310_disable_phy_coma(struct et131x_adapter *adapter)
 {
 	u32 pmcsr;
 
-	pmcsr = readl(&etdev->regs->global.pm_csr);
+	pmcsr = readl(&adapter->regs->global.pm_csr);
 
 	/* Disable phy_sw_coma register and re-enable JAGCore clocks */
 	pmcsr |= ET_PMCSR_INIT;
 	pmcsr &= ~ET_PM_PHY_SW_COMA;
-	writel(pmcsr, &etdev->regs->global.pm_csr);
+	writel(pmcsr, &adapter->regs->global.pm_csr);
 
 	/* Restore the GbE PHY speed and duplex modes;
 	 * Reset JAGCore; re-configure and initialize JAGCore and gigE PHY
 	 */
-	etdev->ai_force_speed = etdev->pdown_speed;
-	etdev->ai_force_duplex = etdev->pdown_duplex;
+	adapter->ai_force_speed = adapter->pdown_speed;
+	adapter->ai_force_duplex = adapter->pdown_duplex;
 
 	/* Re-initialize the send structures */
-	et131x_init_send(etdev);
+	et131x_init_send(adapter);
 
 	/* Reset the RFD list and re-start RU  */
-	et131x_reset_recv(etdev);
+	et131x_reset_recv(adapter);
 
 	/* Bring the device back to the state it was during init prior to
 	 * autonegotiation being complete.  This way, when we get the auto-neg
 	 * complete interrupt, we can complete init by calling ConfigMacREGS2.
 	 */
-	et131x_soft_reset(etdev);
+	et131x_soft_reset(adapter);
 
 	/* setup et1310 as per the documentation ?? */
-	et131x_adapter_setup(etdev);
+	et131x_adapter_setup(adapter);
 
 	/* Allow Tx to restart */
-	etdev->flags &= ~fMP_ADAPTER_LOWER_POWER;
+	adapter->flags &= ~fMP_ADAPTER_LOWER_POWER;
 
 	/* Need to re-enable Rx. */
-	et131x_rx_dma_enable(etdev);
+	et131x_rx_dma_enable(adapter);
 }
 
diff --git a/drivers/staging/et131x/et1310_rx.c b/drivers/staging/et131x/et1310_rx.c
index 0924309..e6458db 100644
--- a/drivers/staging/et131x/et1310_rx.c
+++ b/drivers/staging/et131x/et1310_rx.c
@@ -605,19 +605,19 @@ int et131x_init_recv(struct et131x_adapter *adapter)
 
 /**
  * et131x_config_rx_dma_regs - Start of Rx_DMA init sequence
- * @etdev: pointer to our adapter structure
+ * @adapter: pointer to our adapter structure
  */
-void et131x_config_rx_dma_regs(struct et131x_adapter *etdev)
+void et131x_config_rx_dma_regs(struct et131x_adapter *adapter)
 {
-	struct rxdma_regs __iomem *rx_dma = &etdev->regs->rxdma;
-	struct rx_ring *rx_local = &etdev->rx_ring;
+	struct rxdma_regs __iomem *rx_dma = &adapter->regs->rxdma;
+	struct rx_ring *rx_local = &adapter->rx_ring;
 	struct fbr_desc *fbr_entry;
 	u32 entry;
 	u32 psr_num_des;
 	unsigned long flags;
 
 	/* Halt RXDMA to perform the reconfigure.  */
-	et131x_rx_dma_disable(etdev);
+	et131x_rx_dma_disable(adapter);
 
 	/* Load the completion writeback physical address
 	 *
@@ -645,7 +645,7 @@ void et131x_config_rx_dma_regs(struct et131x_adapter *etdev)
 	writel((psr_num_des * LO_MARK_PERCENT_FOR_PSR) / 100,
 	       &rx_dma->psr_min_des);
 
-	spin_lock_irqsave(&etdev->rcv_lock, flags);
+	spin_lock_irqsave(&adapter->rcv_lock, flags);
 
 	/* These local variables track the PSR in the adapter structure */
 	rx_local->local_psr_full = 0;
@@ -715,34 +715,34 @@ void et131x_config_rx_dma_regs(struct et131x_adapter *etdev)
 	 */
 	writel(PARM_RX_TIME_INT_DEF, &rx_dma->max_pkt_time);
 
-	spin_unlock_irqrestore(&etdev->rcv_lock, flags);
+	spin_unlock_irqrestore(&adapter->rcv_lock, flags);
 }
 
 /**
  * et131x_set_rx_dma_timer - Set the heartbeat timer according to line rate.
- * @etdev: pointer to our adapter structure
+ * @adapter: pointer to our adapter structure
  */
-void et131x_set_rx_dma_timer(struct et131x_adapter *etdev)
+void et131x_set_rx_dma_timer(struct et131x_adapter *adapter)
 {
 	/* For version B silicon, we do not use the RxDMA timer for 10 and 100
 	 * Mbits/s line rates. We do not enable and RxDMA interrupt coalescing.
 	 */
-	if ((etdev->linkspeed == TRUEPHY_SPEED_100MBPS) ||
-	    (etdev->linkspeed == TRUEPHY_SPEED_10MBPS)) {
-		writel(0, &etdev->regs->rxdma.max_pkt_time);
-		writel(1, &etdev->regs->rxdma.num_pkt_done);
+	if ((adapter->linkspeed == TRUEPHY_SPEED_100MBPS) ||
+	    (adapter->linkspeed == TRUEPHY_SPEED_10MBPS)) {
+		writel(0, &adapter->regs->rxdma.max_pkt_time);
+		writel(1, &adapter->regs->rxdma.num_pkt_done);
 	}
 }
 
 /**
  * NICReturnRFD - Recycle a RFD and put it back onto the receive list
- * @etdev: pointer to our adapter
+ * @adapter: pointer to our adapter
  * @rfd: pointer to the RFD
  */
-static void nic_return_rfd(struct et131x_adapter *etdev, struct rfd *rfd)
+static void nic_return_rfd(struct et131x_adapter *adapter, struct rfd *rfd)
 {
-	struct rx_ring *rx_local = &etdev->rx_ring;
-	struct rxdma_regs __iomem *rx_dma = &etdev->regs->rxdma;
+	struct rx_ring *rx_local = &adapter->rx_ring;
+	struct rxdma_regs __iomem *rx_dma = &adapter->regs->rxdma;
 	u16 buff_index = rfd->bufferindex;
 	u8 ring_index = rfd->ringindex;
 	unsigned long flags;
@@ -755,7 +755,7 @@ static void nic_return_rfd(struct et131x_adapter *etdev, struct rfd *rfd)
 	    (ring_index == 0 && buff_index < rx_local->fbr0_num_entries) ||
 #endif
 	    (ring_index == 1 && buff_index < rx_local->fbr1_num_entries)) {
-		spin_lock_irqsave(&etdev->fbr_lock, flags);
+		spin_lock_irqsave(&adapter->fbr_lock, flags);
 
 		if (ring_index == 1) {
 			struct fbr_desc *next =
@@ -793,38 +793,38 @@ static void nic_return_rfd(struct et131x_adapter *etdev, struct rfd *rfd)
 			       &rx_dma->fbr0_full_offset);
 		}
 #endif
-		spin_unlock_irqrestore(&etdev->fbr_lock, flags);
+		spin_unlock_irqrestore(&adapter->fbr_lock, flags);
 	} else {
-		dev_err(&etdev->pdev->dev,
+		dev_err(&adapter->pdev->dev,
 			  "%s illegal Buffer Index returned\n", __func__);
 	}
 
 	/* The processing on this RFD is done, so put it back on the tail of
 	 * our list
 	 */
-	spin_lock_irqsave(&etdev->rcv_lock, flags);
+	spin_lock_irqsave(&adapter->rcv_lock, flags);
 	list_add_tail(&rfd->list_node, &rx_local->recv_list);
 	rx_local->num_ready_recv++;
-	spin_unlock_irqrestore(&etdev->rcv_lock, flags);
+	spin_unlock_irqrestore(&adapter->rcv_lock, flags);
 
 	WARN_ON(rx_local->num_ready_recv > rx_local->num_rfd);
 }
 
 /**
  * et131x_rx_dma_disable - Stop of Rx_DMA on the ET1310
- * @etdev: pointer to our adapter structure
+ * @adapter: pointer to our adapter structure
  */
-void et131x_rx_dma_disable(struct et131x_adapter *etdev)
+void et131x_rx_dma_disable(struct et131x_adapter *adapter)
 {
 	u32 csr;
 	/* Setup the receive dma configuration register */
-	writel(0x00002001, &etdev->regs->rxdma.csr);
-	csr = readl(&etdev->regs->rxdma.csr);
+	writel(0x00002001, &adapter->regs->rxdma.csr);
+	csr = readl(&adapter->regs->rxdma.csr);
 	if ((csr & 0x00020000) == 0) {	/* Check halt status (bit 17) */
 		udelay(5);
-		csr = readl(&etdev->regs->rxdma.csr);
+		csr = readl(&adapter->regs->rxdma.csr);
 		if ((csr & 0x00020000) == 0)
-			dev_err(&etdev->pdev->dev,
+			dev_err(&adapter->pdev->dev,
 			"RX Dma failed to enter halt state. CSR 0x%08x\n",
 				csr);
 	}
@@ -832,36 +832,36 @@ void et131x_rx_dma_disable(struct et131x_adapter *etdev)
 
 /**
  * et131x_rx_dma_enable - re-start of Rx_DMA on the ET1310.
- * @etdev: pointer to our adapter structure
+ * @adapter: pointer to our adapter structure
  */
-void et131x_rx_dma_enable(struct et131x_adapter *etdev)
+void et131x_rx_dma_enable(struct et131x_adapter *adapter)
 {
 	/* Setup the receive dma configuration register for normal operation */
 	u32 csr =  0x2000;	/* FBR1 enable */
 
-	if (etdev->rx_ring.fbr1_buffsize == 4096)
+	if (adapter->rx_ring.fbr1_buffsize == 4096)
 		csr |= 0x0800;
-	else if (etdev->rx_ring.fbr1_buffsize == 8192)
+	else if (adapter->rx_ring.fbr1_buffsize == 8192)
 		csr |= 0x1000;
-	else if (etdev->rx_ring.fbr1_buffsize == 16384)
+	else if (adapter->rx_ring.fbr1_buffsize == 16384)
 		csr |= 0x1800;
 #ifdef USE_FBR0
 	csr |= 0x0400;		/* FBR0 enable */
-	if (etdev->rx_ring.fbr0_buffsize == 256)
+	if (adapter->rx_ring.fbr0_buffsize == 256)
 		csr |= 0x0100;
-	else if (etdev->rx_ring.fbr0_buffsize == 512)
+	else if (adapter->rx_ring.fbr0_buffsize == 512)
 		csr |= 0x0200;
-	else if (etdev->rx_ring.fbr0_buffsize == 1024)
+	else if (adapter->rx_ring.fbr0_buffsize == 1024)
 		csr |= 0x0300;
 #endif
-	writel(csr, &etdev->regs->rxdma.csr);
+	writel(csr, &adapter->regs->rxdma.csr);
 
-	csr = readl(&etdev->regs->rxdma.csr);
+	csr = readl(&adapter->regs->rxdma.csr);
 	if ((csr & 0x00020000) != 0) {
 		udelay(5);
-		csr = readl(&etdev->regs->rxdma.csr);
+		csr = readl(&adapter->regs->rxdma.csr);
 		if ((csr & 0x00020000) != 0) {
-			dev_err(&etdev->pdev->dev,
+			dev_err(&adapter->pdev->dev,
 			    "RX Dma failed to exit halt state.  CSR 0x%08x\n",
 				csr);
 		}
@@ -870,7 +870,7 @@ void et131x_rx_dma_enable(struct et131x_adapter *etdev)
 
 /**
  * nic_rx_pkts - Checks the hardware for available packets
- * @etdev: pointer to our adapter
+ * @adapter: pointer to our adapter
  *
  * Returns rfd, a pointer to our MPRFD.
  *
@@ -879,9 +879,9 @@ void et131x_rx_dma_enable(struct et131x_adapter *etdev)
  * the packet to it, puts the RFD in the RecvPendList, and also returns
  * the pointer to the RFD.
  */
-static struct rfd *nic_rx_pkts(struct et131x_adapter *etdev)
+static struct rfd *nic_rx_pkts(struct et131x_adapter *adapter)
 {
-	struct rx_ring *rx_local = &etdev->rx_ring;
+	struct rx_ring *rx_local = &adapter->rx_ring;
 	struct rx_status_block *status;
 	struct pkt_stat_desc *psr;
 	struct rfd *rfd;
@@ -931,7 +931,7 @@ static struct rfd *nic_rx_pkts(struct et131x_adapter *etdev)
 	}
 
 	writel(rx_local->local_psr_full,
-	       &etdev->regs->rxdma.psr_full_offset);
+	       &adapter->regs->rxdma.psr_full_offset);
 
 #ifndef USE_FBR0
 	if (ring_index != 1)
@@ -949,7 +949,7 @@ static struct rfd *nic_rx_pkts(struct et131x_adapter *etdev)
 #endif
 	{
 		/* Illegal buffer or ring index cannot be used by S/W*/
-		dev_err(&etdev->pdev->dev,
+		dev_err(&adapter->pdev->dev,
 			  "NICRxPkts PSR Entry %d indicates "
 			  "length of %d and/or bad bi(%d)\n",
 			  rx_local->local_psr_full & 0xFFF,
@@ -958,21 +958,21 @@ static struct rfd *nic_rx_pkts(struct et131x_adapter *etdev)
 	}
 
 	/* Get and fill the RFD. */
-	spin_lock_irqsave(&etdev->rcv_lock, flags);
+	spin_lock_irqsave(&adapter->rcv_lock, flags);
 
 	rfd = NULL;
 	element = rx_local->recv_list.next;
 	rfd = (struct rfd *) list_entry(element, struct rfd, list_node);
 
 	if (rfd == NULL) {
-		spin_unlock_irqrestore(&etdev->rcv_lock, flags);
+		spin_unlock_irqrestore(&adapter->rcv_lock, flags);
 		return NULL;
 	}
 
 	list_del(&rfd->list_node);
 	rx_local->num_ready_recv--;
 
-	spin_unlock_irqrestore(&etdev->rcv_lock, flags);
+	spin_unlock_irqrestore(&adapter->rcv_lock, flags);
 
 	rfd->bufferindex = buff_index;
 	rfd->ringindex = ring_index;
@@ -983,18 +983,18 @@ static struct rfd *nic_rx_pkts(struct et131x_adapter *etdev)
 	 * also counted here.
 	 */
 	if (len < (NIC_MIN_PACKET_SIZE + 4)) {
-		etdev->stats.rx_other_errs++;
+		adapter->stats.rx_other_errs++;
 		len = 0;
 	}
 
 	if (len) {
-		if (etdev->replica_phy_loopbk == 1) {
+		if (adapter->replica_phy_loopbk == 1) {
 			buf = rx_local->fbr[ring_index]->virt[buff_index];
 
-			if (memcmp(&buf[6], etdev->addr, ETH_ALEN) == 0) {
+			if (memcmp(&buf[6], adapter->addr, ETH_ALEN) == 0) {
 				if (memcmp(&buf[42], "Replica packet",
 					   ETH_HLEN)) {
-					etdev->replica_phy_loopbk_passfail = 1;
+					adapter->replica_phy_loopbk_passfail = 1;
 				}
 			}
 		}
@@ -1009,11 +1009,11 @@ static struct rfd *nic_rx_pkts(struct et131x_adapter *etdev)
 			 * filters. Generally filter is 0x2b when in
 			 * promiscuous mode.
 			 */
-			if ((etdev->packet_filter &
+			if ((adapter->packet_filter &
 					ET131X_PACKET_TYPE_MULTICAST)
-			    && !(etdev->packet_filter &
+			    && !(adapter->packet_filter &
 					ET131X_PACKET_TYPE_PROMISCUOUS)
-			    && !(etdev->packet_filter &
+			    && !(adapter->packet_filter &
 					ET131X_PACKET_TYPE_ALL_MULTICAST)) {
 				buf = rx_local->fbr[ring_index]->
 						virt[buff_index];
@@ -1022,20 +1022,20 @@ static struct rfd *nic_rx_pkts(struct et131x_adapter *etdev)
 				 * destination address of this packet
 				 * matches one in our list.
 				 */
-				for (i = 0; i < etdev->multicast_addr_count;
+				for (i = 0; i < adapter->multicast_addr_count;
 				     i++) {
 					if (buf[0] ==
-						etdev->multicast_list[i][0]
+						adapter->multicast_list[i][0]
 					    && buf[1] ==
-						etdev->multicast_list[i][1]
+						adapter->multicast_list[i][1]
 					    && buf[2] ==
-						etdev->multicast_list[i][2]
+						adapter->multicast_list[i][2]
 					    && buf[3] ==
-						etdev->multicast_list[i][3]
+						adapter->multicast_list[i][3]
 					    && buf[4] ==
-						etdev->multicast_list[i][4]
+						adapter->multicast_list[i][4]
 					    && buf[5] ==
-						etdev->multicast_list[i][5]) {
+						adapter->multicast_list[i][5]) {
 						break;
 					}
 				}
@@ -1048,21 +1048,21 @@ static struct rfd *nic_rx_pkts(struct et131x_adapter *etdev)
 				 * so we free our RFD when we return
 				 * from this function.
 				 */
-				if (i == etdev->multicast_addr_count)
+				if (i == adapter->multicast_addr_count)
 					len = 0;
 			}
 
 			if (len > 0)
-				etdev->stats.multicast_pkts_rcvd++;
+				adapter->stats.multicast_pkts_rcvd++;
 		} else if (word0 & ALCATEL_BROADCAST_PKT)
-			etdev->stats.broadcast_pkts_rcvd++;
+			adapter->stats.broadcast_pkts_rcvd++;
 		else
 			/* Not sure what this counter measures in
 			 * promiscuous mode. Perhaps we should check
 			 * the MAC address to see if it is directed
 			 * to us in promiscuous mode.
 			 */
-			etdev->stats.unicast_pkts_rcvd++;
+			adapter->stats.unicast_pkts_rcvd++;
 	}
 
 	if (len > 0) {
@@ -1073,19 +1073,19 @@ static struct rfd *nic_rx_pkts(struct et131x_adapter *etdev)
 
 		skb = dev_alloc_skb(rfd->len + 2);
 		if (!skb) {
-			dev_err(&etdev->pdev->dev,
+			dev_err(&adapter->pdev->dev,
 				  "Couldn't alloc an SKB for Rx\n");
 			return NULL;
 		}
 
-		etdev->net_stats.rx_bytes += rfd->len;
+		adapter->net_stats.rx_bytes += rfd->len;
 
 		memcpy(skb_put(skb, rfd->len),
 		       rx_local->fbr[ring_index]->virt[buff_index],
 		       rfd->len);
 
-		skb->dev = etdev->netdev;
-		skb->protocol = eth_type_trans(skb, etdev->netdev);
+		skb->dev = adapter->netdev;
+		skb->protocol = eth_type_trans(skb, adapter->netdev);
 		skb->ip_summed = CHECKSUM_NONE;
 
 		netif_rx(skb);
@@ -1093,28 +1093,28 @@ static struct rfd *nic_rx_pkts(struct et131x_adapter *etdev)
 		rfd->len = 0;
 	}
 
-	nic_return_rfd(etdev, rfd);
+	nic_return_rfd(adapter, rfd);
 	return rfd;
 }
 
 /**
  * et131x_reset_recv - Reset the receive list
- * @etdev: pointer to our adapter
+ * @adapter: pointer to our adapter
  *
  * Assumption, Rcv spinlock has been acquired.
  */
-void et131x_reset_recv(struct et131x_adapter *etdev)
+void et131x_reset_recv(struct et131x_adapter *adapter)
 {
-	WARN_ON(list_empty(&etdev->rx_ring.recv_list));
+	WARN_ON(list_empty(&adapter->rx_ring.recv_list));
 }
 
 /**
  * et131x_handle_recv_interrupt - Interrupt handler for receive processing
- * @etdev: pointer to our adapter
+ * @adapter: pointer to our adapter
  *
  * Assumption, Rcv spinlock has been acquired.
  */
-void et131x_handle_recv_interrupt(struct et131x_adapter *etdev)
+void et131x_handle_recv_interrupt(struct et131x_adapter *adapter)
 {
 	struct rfd *rfd = NULL;
 	u32 count = 0;
@@ -1122,13 +1122,13 @@ void et131x_handle_recv_interrupt(struct et131x_adapter *etdev)
 
 	/* Process up to available RFD's */
 	while (count < NUM_PACKETS_HANDLED) {
-		if (list_empty(&etdev->rx_ring.recv_list)) {
-			WARN_ON(etdev->rx_ring.num_ready_recv != 0);
+		if (list_empty(&adapter->rx_ring.recv_list)) {
+			WARN_ON(adapter->rx_ring.num_ready_recv != 0);
 			done = false;
 			break;
 		}
 
-		rfd = nic_rx_pkts(etdev);
+		rfd = nic_rx_pkts(adapter);
 
 		if (rfd == NULL)
 			break;
@@ -1138,28 +1138,28 @@ void et131x_handle_recv_interrupt(struct et131x_adapter *etdev)
 		 * If length is zero, return the RFD in order to advance the
 		 * Free buffer ring.
 		 */
-		if (!etdev->packet_filter ||
-		    !netif_carrier_ok(etdev->netdev) ||
+		if (!adapter->packet_filter ||
+		    !netif_carrier_ok(adapter->netdev) ||
 		    rfd->len == 0)
 			continue;
 
 		/* Increment the number of packets we received */
-		etdev->net_stats.rx_packets++;
+		adapter->net_stats.rx_packets++;
 
 		/* Set the status on the packet, either resources or success */
-		if (etdev->rx_ring.num_ready_recv < RFD_LOW_WATER_MARK) {
-			dev_warn(&etdev->pdev->dev,
+		if (adapter->rx_ring.num_ready_recv < RFD_LOW_WATER_MARK) {
+			dev_warn(&adapter->pdev->dev,
 				    "RFD's are running out\n");
 		}
 		count++;
 	}
 
 	if (count == NUM_PACKETS_HANDLED || !done) {
-		etdev->rx_ring.unfinished_receives = true;
+		adapter->rx_ring.unfinished_receives = true;
 		writel(PARM_TX_TIME_INT_DEF * NANO_IN_A_MICRO,
-		       &etdev->regs->global.watchdog_timer);
+		       &adapter->regs->global.watchdog_timer);
 	} else
 		/* Watchdog timer will disable itself if appropriate. */
-		etdev->rx_ring.unfinished_receives = false;
+		adapter->rx_ring.unfinished_receives = false;
 }
 
diff --git a/drivers/staging/et131x/et1310_tx.c b/drivers/staging/et131x/et1310_tx.c
index eb8552b..f821104 100644
--- a/drivers/staging/et131x/et1310_tx.c
+++ b/drivers/staging/et131x/et1310_tx.c
@@ -181,59 +181,59 @@ void et131x_tx_dma_memory_free(struct et131x_adapter *adapter)
 
 /**
  * et131x_config_tx_dma_regs - Set up the tx dma section of the JAGCore.
- * @etdev: pointer to our private adapter structure
+ * @adapter: pointer to our private adapter structure
  *
  * Configure the transmit engine with the ring buffers we have created
  * and prepare it for use.
  */
-void et131x_config_tx_dma_regs(struct et131x_adapter *etdev)
+void et131x_config_tx_dma_regs(struct et131x_adapter *adapter)
 {
-	struct txdma_regs __iomem *txdma = &etdev->regs->txdma;
+	struct txdma_regs __iomem *txdma = &adapter->regs->txdma;
 
 	/* Load the hardware with the start of the transmit descriptor ring. */
-	writel((u32) ((u64)etdev->tx_ring.tx_desc_ring_pa >> 32),
+	writel((u32) ((u64)adapter->tx_ring.tx_desc_ring_pa >> 32),
 	       &txdma->pr_base_hi);
-	writel((u32) etdev->tx_ring.tx_desc_ring_pa,
+	writel((u32) adapter->tx_ring.tx_desc_ring_pa,
 	       &txdma->pr_base_lo);
 
 	/* Initialise the transmit DMA engine */
 	writel(NUM_DESC_PER_RING_TX - 1, &txdma->pr_num_des);
 
 	/* Load the completion writeback physical address */
-	writel((u32)((u64)etdev->tx_ring.tx_status_pa >> 32),
+	writel((u32)((u64)adapter->tx_ring.tx_status_pa >> 32),
 						&txdma->dma_wb_base_hi);
-	writel((u32)etdev->tx_ring.tx_status_pa, &txdma->dma_wb_base_lo);
+	writel((u32)adapter->tx_ring.tx_status_pa, &txdma->dma_wb_base_lo);
 
-	*etdev->tx_ring.tx_status = 0;
+	*adapter->tx_ring.tx_status = 0;
 
 	writel(0, &txdma->service_request);
-	etdev->tx_ring.send_idx = 0;
+	adapter->tx_ring.send_idx = 0;
 }
 
 /**
  * et131x_tx_dma_disable - Stop of Tx_DMA on the ET1310
- * @etdev: pointer to our adapter structure
+ * @adapter: pointer to our adapter structure
  */
-void et131x_tx_dma_disable(struct et131x_adapter *etdev)
+void et131x_tx_dma_disable(struct et131x_adapter *adapter)
 {
 	/* Setup the tramsmit dma configuration register */
 	writel(ET_TXDMA_CSR_HALT|ET_TXDMA_SNGL_EPKT,
-					&etdev->regs->txdma.csr);
+					&adapter->regs->txdma.csr);
 }
 
 /**
  * et131x_tx_dma_enable - re-start of Tx_DMA on the ET1310.
- * @etdev: pointer to our adapter structure
+ * @adapter: pointer to our adapter structure
  *
  * Mainly used after a return to the D0 (full-power) state from a lower state.
  */
-void et131x_tx_dma_enable(struct et131x_adapter *etdev)
+void et131x_tx_dma_enable(struct et131x_adapter *adapter)
 {
 	/* Setup the transmit dma configuration register for normal
 	 * operation
 	 */
 	writel(ET_TXDMA_SNGL_EPKT|(PARM_DMA_CACHE_DEF << ET_TXDMA_CACHE_SHIFT),
-					&etdev->regs->txdma.csr);
+					&adapter->regs->txdma.csr);
 }
 
 /**
@@ -272,12 +272,12 @@ void et131x_init_send(struct et131x_adapter *adapter)
 
 /**
  * nic_send_packet - NIC specific send handler for version B silicon.
- * @etdev: pointer to our adapter
+ * @adapter: pointer to our adapter
  * @tcb: pointer to struct tcb
  *
  * Returns 0 or errno.
  */
-static int nic_send_packet(struct et131x_adapter *etdev, struct tcb *tcb)
+static int nic_send_packet(struct et131x_adapter *adapter, struct tcb *tcb)
 {
 	u32 i;
 	struct tx_desc desc[24];	/* 24 x 16 byte */
@@ -331,7 +331,7 @@ static int nic_send_packet(struct et131x_adapter *etdev, struct tcb *tcb)
 				 * subsystem)
 				 */
 				desc[frag++].addr_lo =
-				    pci_map_single(etdev->pdev,
+				    pci_map_single(adapter->pdev,
 						   skb->data,
 						   skb->len -
 						   skb->data_len,
@@ -350,7 +350,7 @@ static int nic_send_packet(struct et131x_adapter *etdev, struct tcb *tcb)
 				 * subsystem)
 				 */
 				desc[frag++].addr_lo =
-				    pci_map_single(etdev->pdev,
+				    pci_map_single(adapter->pdev,
 						   skb->data,
 						   ((skb->len -
 						     skb->data_len) / 2),
@@ -369,7 +369,7 @@ static int nic_send_packet(struct et131x_adapter *etdev, struct tcb *tcb)
 				 * subsystem)
 				 */
 				desc[frag++].addr_lo =
-				    pci_map_single(etdev->pdev,
+				    pci_map_single(adapter->pdev,
 						   skb->data +
 						   ((skb->len -
 						     skb->data_len) / 2),
@@ -389,7 +389,7 @@ static int nic_send_packet(struct et131x_adapter *etdev, struct tcb *tcb)
 			 * addressable (as defined by the pci/dma subsystem)
 			 */
 			desc[frag++].addr_lo =
-			    pci_map_page(etdev->pdev,
+			    pci_map_page(adapter->pdev,
 					 frags[i - 1].page,
 					 frags[i - 1].page_offset,
 					 frags[i - 1].size,
@@ -400,11 +400,11 @@ static int nic_send_packet(struct et131x_adapter *etdev, struct tcb *tcb)
 	if (frag == 0)
 		return -EIO;
 
-	if (etdev->linkspeed == TRUEPHY_SPEED_1000MBPS) {
-		if (++etdev->tx_ring.since_irq == PARM_TX_NUM_BUFS_DEF) {
+	if (adapter->linkspeed == TRUEPHY_SPEED_1000MBPS) {
+		if (++adapter->tx_ring.since_irq == PARM_TX_NUM_BUFS_DEF) {
 			/* Last element & Interrupt flag */
 			desc[frag - 1].flags = 0x5;
-			etdev->tx_ring.since_irq = 0;
+			adapter->tx_ring.since_irq = 0;
 		} else { /* Last element */
 			desc[frag - 1].flags = 0x1;
 		}
@@ -413,13 +413,13 @@ static int nic_send_packet(struct et131x_adapter *etdev, struct tcb *tcb)
 
 	desc[0].flags |= 2;	/* First element flag */
 
-	tcb->index_start = etdev->tx_ring.send_idx;
+	tcb->index_start = adapter->tx_ring.send_idx;
 	tcb->stale = 0;
 
-	spin_lock_irqsave(&etdev->send_hw_lock, flags);
+	spin_lock_irqsave(&adapter->send_hw_lock, flags);
 
 	thiscopy = NUM_DESC_PER_RING_TX -
-				INDEX10(etdev->tx_ring.send_idx);
+				INDEX10(adapter->tx_ring.send_idx);
 
 	if (thiscopy >= frag) {
 		remainder = 0;
@@ -428,61 +428,61 @@ static int nic_send_packet(struct et131x_adapter *etdev, struct tcb *tcb)
 		remainder = frag - thiscopy;
 	}
 
-	memcpy(etdev->tx_ring.tx_desc_ring +
-	       INDEX10(etdev->tx_ring.send_idx), desc,
+	memcpy(adapter->tx_ring.tx_desc_ring +
+	       INDEX10(adapter->tx_ring.send_idx), desc,
 	       sizeof(struct tx_desc) * thiscopy);
 
-	add_10bit(&etdev->tx_ring.send_idx, thiscopy);
+	add_10bit(&adapter->tx_ring.send_idx, thiscopy);
 
-	if (INDEX10(etdev->tx_ring.send_idx) == 0 ||
-		    INDEX10(etdev->tx_ring.send_idx) == NUM_DESC_PER_RING_TX) {
-		etdev->tx_ring.send_idx &= ~ET_DMA10_MASK;
-		etdev->tx_ring.send_idx ^= ET_DMA10_WRAP;
+	if (INDEX10(adapter->tx_ring.send_idx) == 0 ||
+		    INDEX10(adapter->tx_ring.send_idx) == NUM_DESC_PER_RING_TX) {
+		adapter->tx_ring.send_idx &= ~ET_DMA10_MASK;
+		adapter->tx_ring.send_idx ^= ET_DMA10_WRAP;
 	}
 
 	if (remainder) {
-		memcpy(etdev->tx_ring.tx_desc_ring,
+		memcpy(adapter->tx_ring.tx_desc_ring,
 		       desc + thiscopy,
 		       sizeof(struct tx_desc) * remainder);
 
-		add_10bit(&etdev->tx_ring.send_idx, remainder);
+		add_10bit(&adapter->tx_ring.send_idx, remainder);
 	}
 
-	if (INDEX10(etdev->tx_ring.send_idx) == 0) {
-		if (etdev->tx_ring.send_idx)
+	if (INDEX10(adapter->tx_ring.send_idx) == 0) {
+		if (adapter->tx_ring.send_idx)
 			tcb->index = NUM_DESC_PER_RING_TX - 1;
 		else
 			tcb->index = ET_DMA10_WRAP|(NUM_DESC_PER_RING_TX - 1);
 	} else
-		tcb->index = etdev->tx_ring.send_idx - 1;
+		tcb->index = adapter->tx_ring.send_idx - 1;
 
-	spin_lock(&etdev->tcb_send_qlock);
+	spin_lock(&adapter->tcb_send_qlock);
 
-	if (etdev->tx_ring.send_tail)
-		etdev->tx_ring.send_tail->next = tcb;
+	if (adapter->tx_ring.send_tail)
+		adapter->tx_ring.send_tail->next = tcb;
 	else
-		etdev->tx_ring.send_head = tcb;
+		adapter->tx_ring.send_head = tcb;
 
-	etdev->tx_ring.send_tail = tcb;
+	adapter->tx_ring.send_tail = tcb;
 
 	WARN_ON(tcb->next != NULL);
 
-	etdev->tx_ring.used++;
+	adapter->tx_ring.used++;
 
-	spin_unlock(&etdev->tcb_send_qlock);
+	spin_unlock(&adapter->tcb_send_qlock);
 
 	/* Write the new write pointer back to the device. */
-	writel(etdev->tx_ring.send_idx,
-	       &etdev->regs->txdma.service_request);
+	writel(adapter->tx_ring.send_idx,
+	       &adapter->regs->txdma.service_request);
 
 	/* For Gig only, we use Tx Interrupt coalescing.  Enable the software
 	 * timer to wake us up if this packet isn't followed by N more.
 	 */
-	if (etdev->linkspeed == TRUEPHY_SPEED_1000MBPS) {
+	if (adapter->linkspeed == TRUEPHY_SPEED_1000MBPS) {
 		writel(PARM_TX_TIME_INT_DEF * NANO_IN_A_MICRO,
-		       &etdev->regs->global.watchdog_timer);
+		       &adapter->regs->global.watchdog_timer);
 	}
-	spin_unlock_irqrestore(&etdev->send_hw_lock, flags);
+	spin_unlock_irqrestore(&adapter->send_hw_lock, flags);
 
 	return 0;
 }
@@ -490,13 +490,13 @@ static int nic_send_packet(struct et131x_adapter *etdev, struct tcb *tcb)
 /**
  * send_packet - Do the work to send a packet
  * @skb: the packet(s) to send
- * @etdev: a pointer to the device's private adapter structure
+ * @adapter: a pointer to the device's private adapter structure
  *
  * Return 0 in almost all cases; non-zero value in extreme hard failure only.
  *
  * Assumption: Send spinlock has been acquired
  */
-static int send_packet(struct sk_buff *skb, struct et131x_adapter *etdev)
+static int send_packet(struct sk_buff *skb, struct et131x_adapter *adapter)
 {
 	int status;
 	struct tcb *tcb = NULL;
@@ -508,21 +508,21 @@ static int send_packet(struct sk_buff *skb, struct et131x_adapter *etdev)
 		return -EIO;
 
 	/* Get a TCB for this packet */
-	spin_lock_irqsave(&etdev->tcb_ready_qlock, flags);
+	spin_lock_irqsave(&adapter->tcb_ready_qlock, flags);
 
-	tcb = etdev->tx_ring.tcb_qhead;
+	tcb = adapter->tx_ring.tcb_qhead;
 
 	if (tcb == NULL) {
-		spin_unlock_irqrestore(&etdev->tcb_ready_qlock, flags);
+		spin_unlock_irqrestore(&adapter->tcb_ready_qlock, flags);
 		return -ENOMEM;
 	}
 
-	etdev->tx_ring.tcb_qhead = tcb->next;
+	adapter->tx_ring.tcb_qhead = tcb->next;
 
-	if (etdev->tx_ring.tcb_qhead == NULL)
-		etdev->tx_ring.tcb_qtail = NULL;
+	if (adapter->tx_ring.tcb_qhead == NULL)
+		adapter->tx_ring.tcb_qtail = NULL;
 
-	spin_unlock_irqrestore(&etdev->tcb_ready_qlock, flags);
+	spin_unlock_irqrestore(&adapter->tcb_ready_qlock, flags);
 
 	tcb->skb = skb;
 
@@ -540,22 +540,22 @@ static int send_packet(struct sk_buff *skb, struct et131x_adapter *etdev)
 	tcb->next = NULL;
 
 	/* Call the NIC specific send handler. */
-	status = nic_send_packet(etdev, tcb);
+	status = nic_send_packet(adapter, tcb);
 
 	if (status != 0) {
-		spin_lock_irqsave(&etdev->tcb_ready_qlock, flags);
+		spin_lock_irqsave(&adapter->tcb_ready_qlock, flags);
 
-		if (etdev->tx_ring.tcb_qtail)
-			etdev->tx_ring.tcb_qtail->next = tcb;
+		if (adapter->tx_ring.tcb_qtail)
+			adapter->tx_ring.tcb_qtail->next = tcb;
 		else
 			/* Apparently ready Q is empty. */
-			etdev->tx_ring.tcb_qhead = tcb;
+			adapter->tx_ring.tcb_qhead = tcb;
 
-		etdev->tx_ring.tcb_qtail = tcb;
-		spin_unlock_irqrestore(&etdev->tcb_ready_qlock, flags);
+		adapter->tx_ring.tcb_qtail = tcb;
+		spin_unlock_irqrestore(&adapter->tcb_ready_qlock, flags);
 		return status;
 	}
-	WARN_ON(etdev->tx_ring.used > NUM_TCB);
+	WARN_ON(adapter->tx_ring.used > NUM_TCB);
 	return 0;
 }
 
@@ -569,9 +569,9 @@ static int send_packet(struct sk_buff *skb, struct et131x_adapter *etdev)
 int et131x_send_packets(struct sk_buff *skb, struct net_device *netdev)
 {
 	int status = 0;
-	struct et131x_adapter *etdev = NULL;
+	struct et131x_adapter *adapter = NULL;
 
-	etdev = netdev_priv(netdev);
+	adapter = netdev_priv(netdev);
 
 	/* Send these packets
 	 *
@@ -580,7 +580,7 @@ int et131x_send_packets(struct sk_buff *skb, struct net_device *netdev)
 	 */
 
 	/* TCB is not available */
-	if (etdev->tx_ring.used >= NUM_TCB) {
+	if (adapter->tx_ring.used >= NUM_TCB) {
 		/* NOTE: If there's an error on send, no need to queue the
 		 * packet under Linux; if we just send an error up to the
 		 * netif layer, it will resend the skb to us.
@@ -590,21 +590,21 @@ int et131x_send_packets(struct sk_buff *skb, struct net_device *netdev)
 		/* We need to see if the link is up; if it's not, make the
 		 * netif layer think we're good and drop the packet
 		 */
-		if ((etdev->flags & fMP_ADAPTER_FAIL_SEND_MASK) ||
+		if ((adapter->flags & fMP_ADAPTER_FAIL_SEND_MASK) ||
 					!netif_carrier_ok(netdev)) {
 			dev_kfree_skb_any(skb);
 			skb = NULL;
 
-			etdev->net_stats.tx_dropped++;
+			adapter->net_stats.tx_dropped++;
 		} else {
-			status = send_packet(skb, etdev);
+			status = send_packet(skb, adapter);
 			if (status != 0 && status != -ENOMEM) {
 				/* On any other error, make netif think we're
 				 * OK and drop the packet
 				 */
 				dev_kfree_skb_any(skb);
 				skb = NULL;
-				etdev->net_stats.tx_dropped++;
+				adapter->net_stats.tx_dropped++;
 			}
 		}
 	}
@@ -613,25 +613,25 @@ int et131x_send_packets(struct sk_buff *skb, struct net_device *netdev)
 
 /**
  * free_send_packet - Recycle a struct tcb
- * @etdev: pointer to our adapter
+ * @adapter: pointer to our adapter
  * @tcb: pointer to struct tcb
  *
  * Complete the packet if necessary
  * Assumption - Send spinlock has been acquired
  */
-static inline void free_send_packet(struct et131x_adapter *etdev,
+static inline void free_send_packet(struct et131x_adapter *adapter,
 						struct tcb *tcb)
 {
 	unsigned long flags;
 	struct tx_desc *desc = NULL;
-	struct net_device_stats *stats = &etdev->net_stats;
+	struct net_device_stats *stats = &adapter->net_stats;
 
 	if (tcb->flags & fMP_DEST_BROAD)
-		atomic_inc(&etdev->stats.broadcast_pkts_xmtd);
+		atomic_inc(&adapter->stats.broadcast_pkts_xmtd);
 	else if (tcb->flags & fMP_DEST_MULTI)
-		atomic_inc(&etdev->stats.multicast_pkts_xmtd);
+		atomic_inc(&adapter->stats.multicast_pkts_xmtd);
 	else
-		atomic_inc(&etdev->stats.unicast_pkts_xmtd);
+		atomic_inc(&adapter->stats.unicast_pkts_xmtd);
 
 	if (tcb->skb) {
 		stats->tx_bytes += tcb->skb->len;
@@ -641,10 +641,10 @@ static inline void free_send_packet(struct et131x_adapter *etdev,
 		 * they point to
 		 */
 		do {
-			desc = (struct tx_desc *)(etdev->tx_ring.tx_desc_ring +
+			desc = (struct tx_desc *)(adapter->tx_ring.tx_desc_ring +
 						INDEX10(tcb->index_start));
 
-			pci_unmap_single(etdev->pdev,
+			pci_unmap_single(adapter->pdev,
 					 desc->addr_lo,
 					 desc->len_vlan, PCI_DMA_TODEVICE);
 
@@ -654,7 +654,7 @@ static inline void free_send_packet(struct et131x_adapter *etdev,
 				tcb->index_start &= ~ET_DMA10_MASK;
 				tcb->index_start ^= ET_DMA10_WRAP;
 			}
-		} while (desc != (etdev->tx_ring.tx_desc_ring +
+		} while (desc != (adapter->tx_ring.tx_desc_ring +
 				INDEX10(tcb->index)));
 
 		dev_kfree_skb_any(tcb->skb);
@@ -663,127 +663,127 @@ static inline void free_send_packet(struct et131x_adapter *etdev,
 	memset(tcb, 0, sizeof(struct tcb));
 
 	/* Add the TCB to the Ready Q */
-	spin_lock_irqsave(&etdev->tcb_ready_qlock, flags);
+	spin_lock_irqsave(&adapter->tcb_ready_qlock, flags);
 
-	etdev->net_stats.tx_packets++;
+	adapter->net_stats.tx_packets++;
 
-	if (etdev->tx_ring.tcb_qtail)
-		etdev->tx_ring.tcb_qtail->next = tcb;
+	if (adapter->tx_ring.tcb_qtail)
+		adapter->tx_ring.tcb_qtail->next = tcb;
 	else
 		/* Apparently ready Q is empty. */
-		etdev->tx_ring.tcb_qhead = tcb;
+		adapter->tx_ring.tcb_qhead = tcb;
 
-	etdev->tx_ring.tcb_qtail = tcb;
+	adapter->tx_ring.tcb_qtail = tcb;
 
-	spin_unlock_irqrestore(&etdev->tcb_ready_qlock, flags);
-	WARN_ON(etdev->tx_ring.used < 0);
+	spin_unlock_irqrestore(&adapter->tcb_ready_qlock, flags);
+	WARN_ON(adapter->tx_ring.used < 0);
 }
 
 /**
  * et131x_free_busy_send_packets - Free and complete the stopped active sends
- * @etdev: pointer to our adapter
+ * @adapter: pointer to our adapter
  *
  * Assumption - Send spinlock has been acquired
  */
-void et131x_free_busy_send_packets(struct et131x_adapter *etdev)
+void et131x_free_busy_send_packets(struct et131x_adapter *adapter)
 {
 	struct tcb *tcb;
 	unsigned long flags;
 	u32 freed = 0;
 
 	/* Any packets being sent? Check the first TCB on the send list */
-	spin_lock_irqsave(&etdev->tcb_send_qlock, flags);
+	spin_lock_irqsave(&adapter->tcb_send_qlock, flags);
 
-	tcb = etdev->tx_ring.send_head;
+	tcb = adapter->tx_ring.send_head;
 
 	while (tcb != NULL && freed < NUM_TCB) {
 		struct tcb *next = tcb->next;
 
-		etdev->tx_ring.send_head = next;
+		adapter->tx_ring.send_head = next;
 
 		if (next == NULL)
-			etdev->tx_ring.send_tail = NULL;
+			adapter->tx_ring.send_tail = NULL;
 
-		etdev->tx_ring.used--;
+		adapter->tx_ring.used--;
 
-		spin_unlock_irqrestore(&etdev->tcb_send_qlock, flags);
+		spin_unlock_irqrestore(&adapter->tcb_send_qlock, flags);
 
 		freed++;
-		free_send_packet(etdev, tcb);
+		free_send_packet(adapter, tcb);
 
-		spin_lock_irqsave(&etdev->tcb_send_qlock, flags);
+		spin_lock_irqsave(&adapter->tcb_send_qlock, flags);
 
-		tcb = etdev->tx_ring.send_head;
+		tcb = adapter->tx_ring.send_head;
 	}
 
 	WARN_ON(freed == NUM_TCB);
 
-	spin_unlock_irqrestore(&etdev->tcb_send_qlock, flags);
+	spin_unlock_irqrestore(&adapter->tcb_send_qlock, flags);
 
-	etdev->tx_ring.used = 0;
+	adapter->tx_ring.used = 0;
 }
 
 /**
  * et131x_handle_send_interrupt - Interrupt handler for sending processing
- * @etdev: pointer to our adapter
+ * @adapter: pointer to our adapter
  *
  * Re-claim the send resources, complete sends and get more to send from
  * the send wait queue.
  *
  * Assumption - Send spinlock has been acquired
  */
-void et131x_handle_send_interrupt(struct et131x_adapter *etdev)
+void et131x_handle_send_interrupt(struct et131x_adapter *adapter)
 {
 	unsigned long flags;
 	u32 serviced;
 	struct tcb *tcb;
 	u32 index;
 
-	serviced = readl(&etdev->regs->txdma.new_service_complete);
+	serviced = readl(&adapter->regs->txdma.new_service_complete);
 	index = INDEX10(serviced);
 
 	/* Has the ring wrapped?  Process any descriptors that do not have
 	 * the same "wrap" indicator as the current completion indicator
 	 */
-	spin_lock_irqsave(&etdev->tcb_send_qlock, flags);
+	spin_lock_irqsave(&adapter->tcb_send_qlock, flags);
 
-	tcb = etdev->tx_ring.send_head;
+	tcb = adapter->tx_ring.send_head;
 
 	while (tcb &&
 	       ((serviced ^ tcb->index) & ET_DMA10_WRAP) &&
 	       index < INDEX10(tcb->index)) {
-		etdev->tx_ring.used--;
-		etdev->tx_ring.send_head = tcb->next;
+		adapter->tx_ring.used--;
+		adapter->tx_ring.send_head = tcb->next;
 		if (tcb->next == NULL)
-			etdev->tx_ring.send_tail = NULL;
+			adapter->tx_ring.send_tail = NULL;
 
-		spin_unlock_irqrestore(&etdev->tcb_send_qlock, flags);
-		free_send_packet(etdev, tcb);
-		spin_lock_irqsave(&etdev->tcb_send_qlock, flags);
+		spin_unlock_irqrestore(&adapter->tcb_send_qlock, flags);
+		free_send_packet(adapter, tcb);
+		spin_lock_irqsave(&adapter->tcb_send_qlock, flags);
 
 		/* Goto the next packet */
-		tcb = etdev->tx_ring.send_head;
+		tcb = adapter->tx_ring.send_head;
 	}
 	while (tcb &&
 	       !((serviced ^ tcb->index) & ET_DMA10_WRAP)
 	       && index > (tcb->index & ET_DMA10_MASK)) {
-		etdev->tx_ring.used--;
-		etdev->tx_ring.send_head = tcb->next;
+		adapter->tx_ring.used--;
+		adapter->tx_ring.send_head = tcb->next;
 		if (tcb->next == NULL)
-			etdev->tx_ring.send_tail = NULL;
+			adapter->tx_ring.send_tail = NULL;
 
-		spin_unlock_irqrestore(&etdev->tcb_send_qlock, flags);
-		free_send_packet(etdev, tcb);
-		spin_lock_irqsave(&etdev->tcb_send_qlock, flags);
+		spin_unlock_irqrestore(&adapter->tcb_send_qlock, flags);
+		free_send_packet(adapter, tcb);
+		spin_lock_irqsave(&adapter->tcb_send_qlock, flags);
 
 		/* Goto the next packet */
-		tcb = etdev->tx_ring.send_head;
+		tcb = adapter->tx_ring.send_head;
 	}
 
 	/* Wake up the queue when we hit a low-water mark */
-	if (etdev->tx_ring.used <= NUM_TCB / 3)
-		netif_wake_queue(etdev->netdev);
+	if (adapter->tx_ring.used <= NUM_TCB / 3)
+		netif_wake_queue(adapter->netdev);
 
-	spin_unlock_irqrestore(&etdev->tcb_send_qlock, flags);
+	spin_unlock_irqrestore(&adapter->tcb_send_qlock, flags);
 }
 
diff --git a/drivers/staging/et131x/et131x_initpci.c b/drivers/staging/et131x/et131x_initpci.c
index 32a20ddaa..59637c6 100644
--- a/drivers/staging/et131x/et131x_initpci.c
+++ b/drivers/staging/et131x/et131x_initpci.c
@@ -263,38 +263,38 @@ static int et131x_pci_init(struct et131x_adapter *adapter,
  */
 void et131x_error_timer_handler(unsigned long data)
 {
-	struct et131x_adapter *etdev = (struct et131x_adapter *) data;
+	struct et131x_adapter *adapter = (struct et131x_adapter *) data;
 	u32 pm_csr;
 
-	pm_csr = readl(&etdev->regs->global.pm_csr);
+	pm_csr = readl(&adapter->regs->global.pm_csr);
 
 	if ((pm_csr & ET_PM_PHY_SW_COMA) == 0)
-		et1310_update_macstat_host_counters(etdev);
+		et1310_update_macstat_host_counters(adapter);
 	else
-		dev_err(&etdev->pdev->dev,
+		dev_err(&adapter->pdev->dev,
 		    "No interrupts, in PHY coma, pm_csr = 0x%x\n", pm_csr);
 
-	if (!(etdev->bmsr & MI_BMSR_LINK_STATUS) &&
-	    etdev->registry_phy_coma &&
-	    etdev->boot_coma < 11) {
-		etdev->boot_coma++;
+	if (!(adapter->bmsr & MI_BMSR_LINK_STATUS) &&
+	    adapter->registry_phy_coma &&
+	    adapter->boot_coma < 11) {
+		adapter->boot_coma++;
 	}
 
-	if (etdev->boot_coma == 10) {
-		if (!(etdev->bmsr & MI_BMSR_LINK_STATUS)
-		    && etdev->registry_phy_coma) {
+	if (adapter->boot_coma == 10) {
+		if (!(adapter->bmsr & MI_BMSR_LINK_STATUS)
+		    && adapter->registry_phy_coma) {
 			if ((pm_csr & ET_PM_PHY_SW_COMA) == 0) {
 				/* NOTE - This was originally a 'sync with
 				 *  interrupt'. How to do that under Linux?
 				 */
-				et131x_enable_interrupts(etdev);
-				et1310_enable_phy_coma(etdev);
+				et131x_enable_interrupts(adapter);
+				et1310_enable_phy_coma(adapter);
 			}
 		}
 	}
 
 	/* This is a periodic timer, so reschedule */
-	mod_timer(&etdev->error_timer, jiffies +
+	mod_timer(&adapter->error_timer, jiffies +
 					  TX_ERROR_PERIOD * HZ / 1000);
 }
 
@@ -305,34 +305,34 @@ void et131x_error_timer_handler(unsigned long data)
  */
 void et131x_link_detection_handler(unsigned long data)
 {
-	struct et131x_adapter *etdev = (struct et131x_adapter *) data;
+	struct et131x_adapter *adapter = (struct et131x_adapter *) data;
 	unsigned long flags;
 
-	if (etdev->media_state == 0) {
-		spin_lock_irqsave(&etdev->lock, flags);
+	if (adapter->media_state == 0) {
+		spin_lock_irqsave(&adapter->lock, flags);
 
-		etdev->media_state = NETIF_STATUS_MEDIA_DISCONNECT;
+		adapter->media_state = NETIF_STATUS_MEDIA_DISCONNECT;
 
-		spin_unlock_irqrestore(&etdev->lock, flags);
+		spin_unlock_irqrestore(&adapter->lock, flags);
 
-		netif_carrier_off(etdev->netdev);
+		netif_carrier_off(adapter->netdev);
 	}
 }
 
 /**
  * et131x_configure_global_regs	-	configure JAGCore global regs
- * @etdev: pointer to our adapter structure
+ * @adapter: pointer to our adapter structure
  *
  * Used to configure the global registers on the JAGCore
  */
-void et131x_configure_global_regs(struct et131x_adapter *etdev)
+void et131x_configure_global_regs(struct et131x_adapter *adapter)
 {
-	struct global_regs __iomem *regs = &etdev->regs->global;
+	struct global_regs __iomem *regs = &adapter->regs->global;
 
 	writel(0, &regs->rxq_start_addr);
 	writel(INTERNAL_MEM_SIZE - 1, &regs->txq_end_addr);
 
-	if (etdev->registry_jumbo_packet < 2048) {
+	if (adapter->registry_jumbo_packet < 2048) {
 		/* Tx / RxDMA and Tx/Rx MAC interfaces have a 1k word
 		 * block of RAM that the driver can split between Tx
 		 * and Rx as it desires.  Our default is to split it
@@ -340,7 +340,7 @@ void et131x_configure_global_regs(struct et131x_adapter *etdev)
 		 */
 		writel(PARM_RX_MEM_END_DEF, &regs->rxq_end_addr);
 		writel(PARM_RX_MEM_END_DEF + 1, &regs->txq_start_addr);
-	} else if (etdev->registry_jumbo_packet < 8192) {
+	} else if (adapter->registry_jumbo_packet < 8192) {
 		/* For jumbo packets > 2k but < 8k, split 50-50. */
 		writel(INTERNAL_MEM_RX_OFFSET, &regs->rxq_end_addr);
 		writel(INTERNAL_MEM_RX_OFFSET + 1, &regs->txq_start_addr);
@@ -368,59 +368,59 @@ void et131x_configure_global_regs(struct et131x_adapter *etdev)
 
 /**
  * et131x_adapter_setup - Set the adapter up as per cassini+ documentation
- * @etdev: pointer to our private adapter structure
+ * @adapter: pointer to our private adapter structure
  *
  * Returns 0 on success, errno on failure (as defined in errno.h)
  */
-int et131x_adapter_setup(struct et131x_adapter *etdev)
+int et131x_adapter_setup(struct et131x_adapter *adapter)
 {
 	int status = 0;
 
 	/* Configure the JAGCore */
-	et131x_configure_global_regs(etdev);
+	et131x_configure_global_regs(adapter);
 
-	et1310_config_mac_regs1(etdev);
+	et1310_config_mac_regs1(adapter);
 
 	/* Configure the MMC registers */
 	/* All we need to do is initialize the Memory Control Register */
-	writel(ET_MMC_ENABLE, &etdev->regs->mmc.mmc_ctrl);
+	writel(ET_MMC_ENABLE, &adapter->regs->mmc.mmc_ctrl);
 
-	et1310_config_rxmac_regs(etdev);
-	et1310_config_txmac_regs(etdev);
+	et1310_config_rxmac_regs(adapter);
+	et1310_config_txmac_regs(adapter);
 
-	et131x_config_rx_dma_regs(etdev);
-	et131x_config_tx_dma_regs(etdev);
+	et131x_config_rx_dma_regs(adapter);
+	et131x_config_tx_dma_regs(adapter);
 
-	et1310_config_macstat_regs(etdev);
+	et1310_config_macstat_regs(adapter);
 
 	/* Move the following code to Timer function?? */
-	status = et131x_xcvr_find(etdev);
+	status = et131x_xcvr_find(adapter);
 
 	if (status != 0)
-		dev_warn(&etdev->pdev->dev, "Could not find the xcvr\n");
+		dev_warn(&adapter->pdev->dev, "Could not find the xcvr\n");
 
 	/* Prepare the TRUEPHY library. */
-	et1310_phy_init(etdev);
+	et1310_phy_init(adapter);
 
 	/* Reset the phy now so changes take place */
-	et1310_phy_reset(etdev);
+	et1310_phy_reset(adapter);
 
 	/* Power down PHY */
-	et1310_phy_power_down(etdev, 1);
+	et1310_phy_power_down(adapter, 1);
 
 	/*
 	 * We need to turn off 1000 base half dulplex, the mac does not
 	 * support it. For the 10/100 part, turn off all gig advertisement
 	 */
-	if (etdev->pdev->device != ET131X_PCI_DEVICE_ID_FAST)
-		et1310_phy_advertise_1000BaseT(etdev, TRUEPHY_ADV_DUPLEX_FULL);
+	if (adapter->pdev->device != ET131X_PCI_DEVICE_ID_FAST)
+		et1310_phy_advertise_1000BaseT(adapter, TRUEPHY_ADV_DUPLEX_FULL);
 	else
-		et1310_phy_advertise_1000BaseT(etdev, TRUEPHY_ADV_DUPLEX_NONE);
+		et1310_phy_advertise_1000BaseT(adapter, TRUEPHY_ADV_DUPLEX_NONE);
 
 	/* Power up PHY */
-	et1310_phy_power_down(etdev, 0);
+	et1310_phy_power_down(adapter, 0);
 
-	et131x_setphy_normal(etdev);
+	et131x_setphy_normal(adapter);
 	return status;
 }
 
@@ -518,7 +518,7 @@ void et131x_adapter_memory_free(struct et131x_adapter *adapter)
 
 /**
  * et131x_adapter_init
- * @etdev: pointer to the private adapter struct
+ * @adapter: pointer to the private adapter struct
  * @pdev: pointer to the PCI device
  *
  * Initialize the data structures for the et131x_adapter object and link
@@ -531,41 +531,41 @@ static struct et131x_adapter *et131x_adapter_init(struct net_device *netdev,
 	static const u8 duplex[] = { 0, 1, 2, 1, 2, 2 };
 	static const u16 speed[] = { 0, 10, 10, 100, 100, 1000 };
 
-	struct et131x_adapter *etdev;
+	struct et131x_adapter *adapter;
 
 	/* Setup the fundamental net_device and private adapter structure
 	 * elements  */
 	SET_NETDEV_DEV(netdev, &pdev->dev);
 
 	/* Allocate private adapter struct and copy in relevant information */
-	etdev = netdev_priv(netdev);
-	etdev->pdev = pci_dev_get(pdev);
-	etdev->netdev = netdev;
+	adapter = netdev_priv(netdev);
+	adapter->pdev = pci_dev_get(pdev);
+	adapter->netdev = netdev;
 
 	/* Do the same for the netdev struct */
 	netdev->irq = pdev->irq;
 	netdev->base_addr = pci_resource_start(pdev, 0);
 
 	/* Initialize spinlocks here */
-	spin_lock_init(&etdev->lock);
-	spin_lock_init(&etdev->tcb_send_qlock);
-	spin_lock_init(&etdev->tcb_ready_qlock);
-	spin_lock_init(&etdev->send_hw_lock);
-	spin_lock_init(&etdev->rcv_lock);
-	spin_lock_init(&etdev->rcv_pend_lock);
-	spin_lock_init(&etdev->fbr_lock);
-	spin_lock_init(&etdev->phy_lock);
+	spin_lock_init(&adapter->lock);
+	spin_lock_init(&adapter->tcb_send_qlock);
+	spin_lock_init(&adapter->tcb_ready_qlock);
+	spin_lock_init(&adapter->send_hw_lock);
+	spin_lock_init(&adapter->rcv_lock);
+	spin_lock_init(&adapter->rcv_pend_lock);
+	spin_lock_init(&adapter->fbr_lock);
+	spin_lock_init(&adapter->phy_lock);
 
 	/* Parse configuration parameters into the private adapter struct */
 	if (et131x_speed_set)
-		dev_info(&etdev->pdev->dev,
+		dev_info(&adapter->pdev->dev,
 			"Speed set manually to : %d\n", et131x_speed_set);
 
-	etdev->speed_duplex = et131x_speed_set;
-	etdev->registry_jumbo_packet = 1514;	/* 1514-9216 */
+	adapter->speed_duplex = et131x_speed_set;
+	adapter->registry_jumbo_packet = 1514;	/* 1514-9216 */
 
 	/* Set the MAC address to a default */
-	memcpy(etdev->addr, default_mac, ETH_ALEN);
+	memcpy(adapter->addr, default_mac, ETH_ALEN);
 
 	/* Decode speed_duplex
 	 *
@@ -575,14 +575,14 @@ static struct et131x_adapter *et131x_adapter_init(struct net_device *netdev,
 	 * If we are the 10/100 device, and gigabit is somehow requested then
 	 * knock it down to 100 full.
 	 */
-	if (etdev->pdev->device == ET131X_PCI_DEVICE_ID_FAST &&
-	    etdev->speed_duplex == 5)
-		etdev->speed_duplex = 4;
+	if (adapter->pdev->device == ET131X_PCI_DEVICE_ID_FAST &&
+	    adapter->speed_duplex == 5)
+		adapter->speed_duplex = 4;
 
-	etdev->ai_force_speed = speed[etdev->speed_duplex];
-	etdev->ai_force_duplex = duplex[etdev->speed_duplex];	/* Auto FDX */
+	adapter->ai_force_speed = speed[adapter->speed_duplex];
+	adapter->ai_force_duplex = duplex[adapter->speed_duplex];	/* Auto FDX */
 
-	return etdev;
+	return adapter;
 }
 
 /**
diff --git a/drivers/staging/et131x/et131x_isr.c b/drivers/staging/et131x/et131x_isr.c
index 1584ab2..7cfd213 100644
--- a/drivers/staging/et131x/et131x_isr.c
+++ b/drivers/staging/et131x/et131x_isr.c
@@ -242,10 +242,10 @@ out:
  */
 void et131x_isr_handler(struct work_struct *work)
 {
-	struct et131x_adapter *etdev =
+	struct et131x_adapter *adapter =
 		container_of(work, struct et131x_adapter, task);
-	u32 status = etdev->stats.interrupt_status;
-	struct address_map __iomem *iomem = etdev->regs;
+	u32 status = adapter->stats.interrupt_status;
+	struct address_map __iomem *iomem = adapter->regs;
 
 	/*
 	 * These first two are by far the most common.  Once handled, we clear
@@ -254,11 +254,11 @@ void et131x_isr_handler(struct work_struct *work)
 	 */
 	/* Handle all the completed Transmit interrupts */
 	if (status & ET_INTR_TXDMA_ISR)
-		et131x_handle_send_interrupt(etdev);
+		et131x_handle_send_interrupt(adapter);
 
 	/* Handle all the completed Receives interrupts */
 	if (status & ET_INTR_RXDMA_XFR_DONE)
-		et131x_handle_recv_interrupt(etdev);
+		et131x_handle_recv_interrupt(adapter);
 
 	status &= 0xffffffd7;
 
@@ -270,7 +270,7 @@ void et131x_isr_handler(struct work_struct *work)
 			/* Following read also clears the register (COR) */
 			txdma_err = readl(&iomem->txdma.tx_dma_error);
 
-			dev_warn(&etdev->pdev->dev,
+			dev_warn(&adapter->pdev->dev,
 				    "TXDMA_ERR interrupt, error = %d\n",
 				    txdma_err);
 		}
@@ -295,8 +295,8 @@ void et131x_isr_handler(struct work_struct *work)
 			/* If the user has flow control on, then we will
 			 * send a pause packet, otherwise just exit
 			 */
-			if (etdev->flowcontrol == FLOW_TXONLY ||
-			    etdev->flowcontrol == FLOW_BOTH) {
+			if (adapter->flowcontrol == FLOW_TXONLY ||
+			    adapter->flowcontrol == FLOW_BOTH) {
 				u32 pm_csr;
 
 				/* Tell the device to send a pause packet via
@@ -345,7 +345,7 @@ void et131x_isr_handler(struct work_struct *work)
 			 */
 			/* TRAP();*/
 
-			dev_warn(&etdev->pdev->dev,
+			dev_warn(&adapter->pdev->dev,
 				    "RxDMA_ERR interrupt, error %x\n",
 				    readl(&iomem->txmac.tx_test));
 		}
@@ -359,7 +359,7 @@ void et131x_isr_handler(struct work_struct *work)
 			 * message when we are in DBG mode, otherwise we
 			 * will ignore it.
 			 */
-			dev_err(&etdev->pdev->dev, "WAKE_ON_LAN interrupt\n");
+			dev_err(&adapter->pdev->dev, "WAKE_ON_LAN interrupt\n");
 		}
 
 		/* Handle the PHY interrupt */
@@ -379,26 +379,26 @@ void et131x_isr_handler(struct work_struct *work)
 				 * so, disable it because we will not be able
 				 * to read PHY values until we are out.
 				 */
-				et1310_disable_phy_coma(etdev);
+				et1310_disable_phy_coma(adapter);
 			}
 
 			/* Read the PHY ISR to clear the reason for the
 			 * interrupt.
 			 */
-			et131x_mii_read(etdev,
+			et131x_mii_read(adapter,
 					(uint8_t) offsetof(struct mi_regs, isr),
 					&myisr);
 
-			if (!etdev->replica_phy_loopbk) {
-				et131x_mii_read(etdev,
+			if (!adapter->replica_phy_loopbk) {
+				et131x_mii_read(adapter,
 				       (uint8_t) offsetof(struct mi_regs, bmsr),
 				       &bmsr_data);
 
-				bmsr_ints = etdev->bmsr ^ bmsr_data;
-				etdev->bmsr = bmsr_data;
+				bmsr_ints = adapter->bmsr ^ bmsr_data;
+				adapter->bmsr = bmsr_data;
 
 				/* Do all the cable in / cable out stuff */
-				et131x_mii_check(etdev, bmsr_data, bmsr_ints);
+				et131x_mii_check(adapter, bmsr_data, bmsr_ints);
 			}
 		}
 
@@ -416,7 +416,7 @@ void et131x_isr_handler(struct work_struct *work)
 			 * a nutshell, the whole Tx path will have to be reset
 			 * and re-configured afterwards.
 			 */
-			dev_warn(&etdev->pdev->dev,
+			dev_warn(&adapter->pdev->dev,
 				    "TXMAC interrupt, error 0x%08x\n",
 				    err);
 
@@ -434,14 +434,14 @@ void et131x_isr_handler(struct work_struct *work)
 			 * set the flag to cause us to reset so we can solve
 			 * this issue.
 			 */
-			/* MP_SET_FLAG( etdev,
+			/* MP_SET_FLAG( adapter,
 						fMP_ADAPTER_HARDWARE_ERROR); */
 
-			dev_warn(&etdev->pdev->dev,
+			dev_warn(&adapter->pdev->dev,
 			  "RXMAC interrupt, error 0x%08x.  Requesting reset\n",
 				    readl(&iomem->rxmac.err_reg));
 
-			dev_warn(&etdev->pdev->dev,
+			dev_warn(&adapter->pdev->dev,
 				    "Enable 0x%08x, Diag 0x%08x\n",
 				    readl(&iomem->rxmac.ctrl),
 				    readl(&iomem->rxmac.rxq_diag));
@@ -461,7 +461,7 @@ void et131x_isr_handler(struct work_struct *work)
 			 * to maintain the top, software managed bits of the
 			 * counter(s).
 			 */
-			et1310_handle_macstat_interrupt(etdev);
+			et1310_handle_macstat_interrupt(adapter);
 		}
 
 		/* Handle SLV Timeout Interrupt */
@@ -477,5 +477,5 @@ void et131x_isr_handler(struct work_struct *work)
 			 */
 		}
 	}
-	et131x_enable_interrupts(etdev);
+	et131x_enable_interrupts(adapter);
 }
diff --git a/drivers/staging/et131x/et131x_netdev.c b/drivers/staging/et131x/et131x_netdev.c
index 93ef9d5..37e1069 100644
--- a/drivers/staging/et131x/et131x_netdev.c
+++ b/drivers/staging/et131x/et131x_netdev.c
@@ -212,19 +212,19 @@ int et131x_close(struct net_device *netdev)
 int et131x_ioctl_mii(struct net_device *netdev, struct ifreq *reqbuf, int cmd)
 {
 	int status = 0;
-	struct et131x_adapter *etdev = netdev_priv(netdev);
+	struct et131x_adapter *adapter = netdev_priv(netdev);
 	struct mii_ioctl_data *data = if_mii(reqbuf);
 
 	switch (cmd) {
 	case SIOCGMIIPHY:
-		data->phy_id = etdev->stats.xcvr_addr;
+		data->phy_id = adapter->stats.xcvr_addr;
 		break;
 
 	case SIOCGMIIREG:
 		if (!capable(CAP_NET_ADMIN))
 			status = -EPERM;
 		else
-			status = et131x_mii_read(etdev,
+			status = et131x_mii_read(adapter,
 					data->reg_num, &data->val_out);
 		break;
 
@@ -232,7 +232,7 @@ int et131x_ioctl_mii(struct net_device *netdev, struct ifreq *reqbuf, int cmd)
 		if (!capable(CAP_NET_ADMIN))
 			status = -EPERM;
 		else
-			status = et131x_mii_write(etdev, data->reg_num,
+			status = et131x_mii_write(adapter, data->reg_num,
 					 data->val_in);
 		break;
 
@@ -445,35 +445,35 @@ int et131x_tx(struct sk_buff *skb, struct net_device *netdev)
  */
 void et131x_tx_timeout(struct net_device *netdev)
 {
-	struct et131x_adapter *etdev = netdev_priv(netdev);
+	struct et131x_adapter *adapter = netdev_priv(netdev);
 	struct tcb *tcb;
 	unsigned long flags;
 
 	/* Any nonrecoverable hardware error?
 	 * Checks adapter->flags for any failure in phy reading
 	 */
-	if (etdev->flags & fMP_ADAPTER_NON_RECOVER_ERROR)
+	if (adapter->flags & fMP_ADAPTER_NON_RECOVER_ERROR)
 		return;
 
 	/* Hardware failure? */
-	if (etdev->flags & fMP_ADAPTER_HARDWARE_ERROR) {
-		dev_err(&etdev->pdev->dev, "hardware error - reset\n");
+	if (adapter->flags & fMP_ADAPTER_HARDWARE_ERROR) {
+		dev_err(&adapter->pdev->dev, "hardware error - reset\n");
 		return;
 	}
 
 	/* Is send stuck? */
-	spin_lock_irqsave(&etdev->tcb_send_qlock, flags);
+	spin_lock_irqsave(&adapter->tcb_send_qlock, flags);
 
-	tcb = etdev->tx_ring.send_head;
+	tcb = adapter->tx_ring.send_head;
 
 	if (tcb != NULL) {
 		tcb->count++;
 
 		if (tcb->count > NIC_SEND_HANG_THRESHOLD) {
-			spin_unlock_irqrestore(&etdev->tcb_send_qlock,
+			spin_unlock_irqrestore(&adapter->tcb_send_qlock,
 					       flags);
 
-			dev_warn(&etdev->pdev->dev,
+			dev_warn(&adapter->pdev->dev,
 				"Send stuck - reset.  tcb->WrIndex %x, flags 0x%08x\n",
 				tcb->index,
 				tcb->flags);
@@ -485,7 +485,7 @@ void et131x_tx_timeout(struct net_device *netdev)
 		}
 	}
 
-	spin_unlock_irqrestore(&etdev->tcb_send_qlock, flags);
+	spin_unlock_irqrestore(&adapter->tcb_send_qlock, flags);
 }
 
 /**
-- 
1.7.6

