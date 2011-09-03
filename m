Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751044Ab1ICLub (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Sep 2011 07:50:31 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47810 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702Ab1ICLua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Sep 2011 07:50:30 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com, Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 1/2] staging: et131x: Fix checkpatch whitespace warnings
Date: Sat,  3 Sep 2011 12:49:06 +0100
Message-Id: <1315050547-4781-1-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of my previous hacking attempts have not been following the rules.
All fixes either lines > 80 chars or whitespace corrections (spaces->tabs etc).

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et1310_mac.c     |    5 ++-
 drivers/staging/et131x/et1310_phy.c     |   16 +++++++----
 drivers/staging/et131x/et1310_phy.h     |   27 +++++++++----------
 drivers/staging/et131x/et1310_tx.c      |    5 ++-
 drivers/staging/et131x/et131x_ethtool.c |    8 +++---
 drivers/staging/et131x/et131x_initpci.c |   44 +++++++++++++++---------------
 drivers/staging/et131x/et131x_isr.c     |    6 +++-
 drivers/staging/et131x/et131x_netdev.c  |    7 +++-
 8 files changed, 64 insertions(+), 54 deletions(-)

diff --git a/drivers/staging/et131x/et1310_mac.c b/drivers/staging/et131x/et1310_mac.c
index ab85cb3..36f2168 100644
--- a/drivers/staging/et131x/et1310_mac.c
+++ b/drivers/staging/et131x/et1310_mac.c
@@ -191,7 +191,8 @@ void et1310_config_mac_regs2(struct et131x_adapter *adapter)
 	cfg1 |= CFG1_RX_ENABLE | CFG1_TX_ENABLE | CFG1_TX_FLOW;
 	/* Initialize loop back to off */
 	cfg1 &= ~(CFG1_LOOPBACK | CFG1_RX_FLOW);
-	if (adapter->flowcontrol == FLOW_RXONLY || adapter->flowcontrol == FLOW_BOTH)
+	if (adapter->flowcontrol == FLOW_RXONLY ||
+				adapter->flowcontrol == FLOW_BOTH)
 		cfg1 |= CFG1_RX_FLOW;
 	writel(cfg1, &mac->cfg1);
 
@@ -287,7 +288,7 @@ void et1310_config_rxmac_regs(struct et131x_adapter *adapter)
 	writel(sa_lo, &rxmac->sa_lo);
 
 	sa_hi = (u32) (adapter->addr[0] << ET_WOL_HI_SA1_SHIFT) |
-	               adapter->addr[1];
+		       adapter->addr[1];
 	writel(sa_hi, &rxmac->sa_hi);
 
 	/* Disable all Packet Filtering */
diff --git a/drivers/staging/et131x/et1310_phy.c b/drivers/staging/et131x/et1310_phy.c
index fedde6b..12345c7 100644
--- a/drivers/staging/et131x/et1310_phy.c
+++ b/drivers/staging/et131x/et1310_phy.c
@@ -132,7 +132,7 @@ int et131x_mii_read(struct et131x_adapter *adapter, u8 reg, u16 *value)
 {
 	struct phy_device *phydev = adapter->phydev;
 
-	if(!phydev)
+	if (!phydev)
 		return -EIO;
 
 	return et131x_phy_mii_read(adapter, phydev->addr, reg, value);
@@ -224,7 +224,7 @@ int et131x_mii_write(struct et131x_adapter *adapter, u8 reg, u16 value)
 	u32 mii_cmd;
 	u32 mii_indicator;
 
-	if(!phydev)
+	if (!phydev)
 		return -EIO;
 
 	addr = phydev->addr;
@@ -465,10 +465,12 @@ void et131x_mii_check(struct et131x_adapter *adapter,
 				u16 register18;
 
 				et131x_mii_read(adapter, 0x12, &register18);
-				et131x_mii_write(adapter, 0x12, register18 | 0x4);
+				et131x_mii_write(adapter, 0x12,
+						 register18 | 0x4);
 				et131x_mii_write(adapter, 0x10,
 						 register18 | 0x8402);
-				et131x_mii_write(adapter, 0x11, register18 | 511);
+				et131x_mii_write(adapter, 0x11,
+						 register18 | 511);
 				et131x_mii_write(adapter, 0x12, register18);
 			}
 
@@ -529,10 +531,12 @@ void et131x_mii_check(struct et131x_adapter *adapter,
 				u16 register18;
 
 				et131x_mii_read(adapter, 0x12, &register18);
-				et131x_mii_write(adapter, 0x12, register18 | 0x4);
+				et131x_mii_write(adapter, 0x12,
+						 register18 | 0x4);
 				et131x_mii_write(adapter, 0x10,
 						 register18 | 0x8402);
-				et131x_mii_write(adapter, 0x11, register18 | 511);
+				et131x_mii_write(adapter, 0x11,
+						 register18 | 511);
 				et131x_mii_write(adapter, 0x12, register18);
 			}
 
diff --git a/drivers/staging/et131x/et1310_phy.h b/drivers/staging/et131x/et1310_phy.h
index d8753f1..88dc8cd 100644
--- a/drivers/staging/et131x/et1310_phy.h
+++ b/drivers/staging/et131x/et1310_phy.h
@@ -280,19 +280,18 @@ struct mi_regs {
 #define PHY_INDEX_REG              0x10
 #define PHY_DATA_REG               0x11
 
-#define PHY_MPHY_CONTROL_REG       0x12	/* #define TRU_VMI_MPHY_CONTROL_REGISTER           18 */
-
-#define PHY_LOOPBACK_CONTROL       0x13	/* #define TRU_VMI_LOOPBACK_CONTROL_1_REGISTER     19 */
-					/* #define TRU_VMI_LOOPBACK_CONTROL_2_REGISTER     20 */
-#define PHY_REGISTER_MGMT_CONTROL  0x15	/* #define TRU_VMI_MI_SEQ_CONTROL_REGISTER         21 */
-#define PHY_CONFIG                 0x16	/* #define TRU_VMI_CONFIGURATION_REGISTER          22 */
-#define PHY_PHY_CONTROL            0x17	/* #define TRU_VMI_PHY_CONTROL_REGISTER            23 */
-#define PHY_INTERRUPT_MASK         0x18	/* #define TRU_VMI_INTERRUPT_MASK_REGISTER         24 */
-#define PHY_INTERRUPT_STATUS       0x19	/* #define TRU_VMI_INTERRUPT_STATUS_REGISTER       25 */
-#define PHY_PHY_STATUS             0x1A	/* #define TRU_VMI_PHY_STATUS_REGISTER             26 */
-#define PHY_LED_1                  0x1B	/* #define TRU_VMI_LED_CONTROL_1_REGISTER          27 */
-#define PHY_LED_2                  0x1C	/* #define TRU_VMI_LED_CONTROL_2_REGISTER          28 */
-					/* #define TRU_VMI_LINK_CONTROL_REGISTER           29 */
-					/* #define TRU_VMI_TIMING_CONTROL_REGISTER */
+#define PHY_MPHY_CONTROL_REG       0x12
+#define PHY_LOOPBACK_CONTROL       0x13	/* TRU_VMI_LOOPBACK_CONTROL_1_REG 19 */
+					/* TRU_VMI_LOOPBACK_CONTROL_2_REG 20 */
+#define PHY_REGISTER_MGMT_CONTROL  0x15	/* TRU_VMI_MI_SEQ_CONTROL_REG     21 */
+#define PHY_CONFIG                 0x16	/* TRU_VMI_CONFIGURATION_REG      22 */
+#define PHY_PHY_CONTROL            0x17	/* TRU_VMI_PHY_CONTROL_REG        23 */
+#define PHY_INTERRUPT_MASK         0x18	/* TRU_VMI_INTERRUPT_MASK_REG     24 */
+#define PHY_INTERRUPT_STATUS       0x19	/* TRU_VMI_INTERRUPT_STATUS_REG   25 */
+#define PHY_PHY_STATUS             0x1A	/* TRU_VMI_PHY_STATUS_REG         26 */
+#define PHY_LED_1                  0x1B	/* TRU_VMI_LED_CONTROL_1_REG      27 */
+#define PHY_LED_2                  0x1C	/* TRU_VMI_LED_CONTROL_2_REG      28 */
+					/* TRU_VMI_LINK_CONTROL_REG       29 */
+					/* TRU_VMI_TIMING_CONTROL_REG        */
 
 #endif /* _ET1310_PHY_H_ */
diff --git a/drivers/staging/et131x/et1310_tx.c b/drivers/staging/et131x/et1310_tx.c
index f821104..aa07138 100644
--- a/drivers/staging/et131x/et1310_tx.c
+++ b/drivers/staging/et131x/et1310_tx.c
@@ -435,7 +435,7 @@ static int nic_send_packet(struct et131x_adapter *adapter, struct tcb *tcb)
 	add_10bit(&adapter->tx_ring.send_idx, thiscopy);
 
 	if (INDEX10(adapter->tx_ring.send_idx) == 0 ||
-		    INDEX10(adapter->tx_ring.send_idx) == NUM_DESC_PER_RING_TX) {
+		  INDEX10(adapter->tx_ring.send_idx) == NUM_DESC_PER_RING_TX) {
 		adapter->tx_ring.send_idx &= ~ET_DMA10_MASK;
 		adapter->tx_ring.send_idx ^= ET_DMA10_WRAP;
 	}
@@ -641,7 +641,8 @@ static inline void free_send_packet(struct et131x_adapter *adapter,
 		 * they point to
 		 */
 		do {
-			desc = (struct tx_desc *)(adapter->tx_ring.tx_desc_ring +
+			desc = (struct tx_desc *)
+				    (adapter->tx_ring.tx_desc_ring +
 						INDEX10(tcb->index_start));
 
 			pci_unmap_single(adapter->pdev,
diff --git a/drivers/staging/et131x/et131x_ethtool.c b/drivers/staging/et131x/et131x_ethtool.c
index d980ad6..b92633f 100644
--- a/drivers/staging/et131x/et131x_ethtool.c
+++ b/drivers/staging/et131x/et131x_ethtool.c
@@ -58,10 +58,10 @@ static void et131x_get_drvinfo(struct net_device *netdev,
 }
 
 static struct ethtool_ops et131x_ethtool_ops = {
-        .get_settings = et131x_get_settings,
-        .set_settings = et131x_set_settings,
-        .get_drvinfo = et131x_get_drvinfo,
-        .get_link = ethtool_op_get_link,
+	.get_settings = et131x_get_settings,
+	.set_settings = et131x_set_settings,
+	.get_drvinfo = et131x_get_drvinfo,
+	.get_link = ethtool_op_get_link,
 };
 
 void et131x_set_ethtool_ops(struct net_device *netdev)
diff --git a/drivers/staging/et131x/et131x_initpci.c b/drivers/staging/et131x/et131x_initpci.c
index 2ef2a70..3cfcc2d 100644
--- a/drivers/staging/et131x/et131x_initpci.c
+++ b/drivers/staging/et131x/et131x_initpci.c
@@ -487,30 +487,30 @@ int et131x_mii_probe(struct net_device *netdev)
 	phydev = phy_connect(netdev, dev_name(&phydev->dev),
 			&et131x_adjust_link, 0, PHY_INTERFACE_MODE_MII);
 
-	if(IS_ERR(phydev)) {
+	if (IS_ERR(phydev)) {
 		dev_err(&adapter->pdev->dev, "Could not attach to PHY\n");
 		return PTR_ERR(phydev);
 	}
 
 	phydev->supported &= (SUPPORTED_10baseT_Half
-                                | SUPPORTED_10baseT_Full
-                                | SUPPORTED_100baseT_Half
-                                | SUPPORTED_100baseT_Full
-                                | SUPPORTED_Autoneg
-                                | SUPPORTED_MII
-                                | SUPPORTED_TP);
+				| SUPPORTED_10baseT_Full
+				| SUPPORTED_100baseT_Half
+				| SUPPORTED_100baseT_Full
+				| SUPPORTED_Autoneg
+				| SUPPORTED_MII
+				| SUPPORTED_TP);
 
 	if (adapter->pdev->device != ET131X_PCI_DEVICE_ID_FAST)
 		phydev->supported |= SUPPORTED_1000baseT_Full;
 
-        phydev->advertising = phydev->supported;
-        adapter->phydev = phydev;
+	phydev->advertising = phydev->supported;
+	adapter->phydev = phydev;
 
-        dev_info(&adapter->pdev->dev, "attached PHY driver [%s] "
-                "(mii_bus:phy_addr=%s)\n",
-                phydev->drv->name, dev_name(&phydev->dev));
+	dev_info(&adapter->pdev->dev, "attached PHY driver [%s] "
+		 "(mii_bus:phy_addr=%s)\n",
+		 phydev->drv->name, dev_name(&phydev->dev));
 
-        return 0;
+	return 0;
 }
 
 /**
@@ -707,22 +707,22 @@ static int __devinit et131x_pci_setup(struct pci_dev *pdev,
 	adapter->mii_bus->write = et131x_mdio_write;
 	adapter->mii_bus->reset = et131x_mdio_reset;
 	adapter->mii_bus->irq = kmalloc(sizeof(int)*PHY_MAX_ADDR, GFP_KERNEL);
-        if (!adapter->mii_bus->irq) {
-                dev_err(&pdev->dev, "mii_bus irq allocation failed\n");
+	if (!adapter->mii_bus->irq) {
+		dev_err(&pdev->dev, "mii_bus irq allocation failed\n");
 		goto err_mdio_free;
-        }
+	}
 
-        for (ii = 0; ii < PHY_MAX_ADDR; ii++)
-                adapter->mii_bus->irq[ii] = PHY_POLL;
+	for (ii = 0; ii < PHY_MAX_ADDR; ii++)
+		adapter->mii_bus->irq[ii] = PHY_POLL;
 
-        if (mdiobus_register(adapter->mii_bus)) {
-                dev_err(&pdev->dev, "failed to register MII bus\n");
+	if (mdiobus_register(adapter->mii_bus)) {
+		dev_err(&pdev->dev, "failed to register MII bus\n");
 		mdiobus_free(adapter->mii_bus);
 		goto err_mdio_free_irq;
-        }
+	}
 
 	if (et131x_mii_probe(netdev)) {
-                dev_err(&pdev->dev, "failed to probe MII bus\n");
+		dev_err(&pdev->dev, "failed to probe MII bus\n");
 		goto err_mdio_unregister;
 	}
 
diff --git a/drivers/staging/et131x/et131x_isr.c b/drivers/staging/et131x/et131x_isr.c
index 4d75690..94565c1 100644
--- a/drivers/staging/et131x/et131x_isr.c
+++ b/drivers/staging/et131x/et131x_isr.c
@@ -119,7 +119,8 @@ void et131x_enable_interrupts(struct et131x_adapter *adapter)
 	u32 mask;
 
 	/* Enable all global interrupts */
-	if (adapter->flowcontrol == FLOW_TXONLY || adapter->flowcontrol == FLOW_BOTH)
+	if (adapter->flowcontrol == FLOW_TXONLY ||
+			    adapter->flowcontrol == FLOW_BOTH)
 		mask = INT_MASK_ENABLE;
 	else
 		mask = INT_MASK_ENABLE_NO_FLOW;
@@ -276,7 +277,8 @@ void et131x_isr_handler(struct work_struct *work)
 		}
 
 		/* Handle Free Buffer Ring 0 and 1 Low interrupt */
-		if (status & (ET_INTR_RXDMA_FB_R0_LOW | ET_INTR_RXDMA_FB_R1_LOW)) {
+		if (status &
+		    (ET_INTR_RXDMA_FB_R0_LOW | ET_INTR_RXDMA_FB_R1_LOW)) {
 			/*
 			 * This indicates the number of unused buffers in
 			 * RXDMA free buffer ring 0 is <= the limit you
diff --git a/drivers/staging/et131x/et131x_netdev.c b/drivers/staging/et131x/et131x_netdev.c
index d12e05e..5fb4056 100644
--- a/drivers/staging/et131x/et131x_netdev.c
+++ b/drivers/staging/et131x/et131x_netdev.c
@@ -408,7 +408,7 @@ void et131x_tx_timeout(struct net_device *netdev)
 	unsigned long flags;
 
 	/* If the device is closed, ignore the timeout */
-	if (~(adapter->flags & fMP_ADAPTER_INTERRUPT_IN_USE));
+	if (~(adapter->flags & fMP_ADAPTER_INTERRUPT_IN_USE))
 		return;
 
 	/* Any nonrecoverable hardware error?
@@ -453,7 +453,10 @@ void et131x_tx_timeout(struct net_device *netdev)
 			/* Disable device interrupts */
 			et131x_disable_interrupts(adapter);
 
-			/* Enable the Tx and Rx DMA engines (if not already enabled) */
+			/*
+			 * Enable the Tx and Rx DMA engines
+			 * (if not already enabled)
+			 */
 			et131x_rx_dma_enable(adapter);
 			et131x_tx_dma_enable(adapter);
 
-- 
1.7.6

