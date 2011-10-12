Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383Ab1JLVjF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 17:39:05 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50359 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340Ab1JLVi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 17:38:58 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 02/10] staging: et131x: Move function declarations from et131x.h to et131x.c
Date: Wed, 12 Oct 2011 22:36:34 +0100
Message-Id: <1318455402-10596-3-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1318455402-10596-1-git-send-email-mark.einon@gmail.com>
References: <1318455402-10596-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function declarations in et131x.h are no longer used now all
functions are in one file. Removed declarations from et131x.h and
added any required forward declarations to et131x.c.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et131x.c |   31 ++++++++++++
 drivers/staging/et131x/et131x.h |  102 ---------------------------------------
 2 files changed, 31 insertions(+), 102 deletions(-)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index fdf6385..a038a37 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -96,6 +96,37 @@ MODULE_LICENSE("Dual BSD/GPL");
 MODULE_DESCRIPTION("10/100/1000 Base-T Ethernet Driver "
 		   "for the ET1310 by Agere Systems");
 
+void et131x_error_timer_handler(unsigned long data);
+void et131x_enable_interrupts(struct et131x_adapter *adapter);
+void et131x_disable_interrupts(struct et131x_adapter *adapter);
+void et131x_align_allocated_memory(struct et131x_adapter *adapter,
+				   u64 *phys_addr,
+				   u64 *offset, u64 mask);
+void et131x_adapter_setup(struct et131x_adapter *adapter);
+void et131x_soft_reset(struct et131x_adapter *adapter);
+void et131x_isr_handler(struct work_struct *work);
+void et1310_setup_device_for_multicast(struct et131x_adapter *adapter);
+void et1310_setup_device_for_unicast(struct et131x_adapter *adapter);
+void et131x_up(struct net_device *netdev);
+void et131x_down(struct net_device *netdev);
+struct net_device *et131x_device_alloc(void);
+void et131x_enable_txrx(struct net_device *netdev);
+void et131x_disable_txrx(struct net_device *netdev);
+int et1310_in_phy_coma(struct et131x_adapter *adapter);
+void et1310_phy_access_mii_bit(struct et131x_adapter *adapter,
+			       u16 action,
+			       u16 regnum, u16 bitnum, u8 *value);
+int et131x_phy_mii_read(struct et131x_adapter *adapter, u8 addr,
+	      u8 reg, u16 *value);
+int32_t et131x_mii_write(struct et131x_adapter *adapter,
+		u8 reg, u16 value);
+void et131x_rx_dma_memory_free(struct et131x_adapter *adapter);
+void et131x_rx_dma_disable(struct et131x_adapter *adapter);
+void et131x_rx_dma_enable(struct et131x_adapter *adapter);
+void et131x_reset_recv(struct et131x_adapter *adapter);
+void et131x_init_send(struct et131x_adapter *adapter);
+void et131x_tx_dma_enable(struct et131x_adapter *adapter);
+
 /* EEPROM functions */
 
 static int eeprom_wait_ready(struct pci_dev *pdev, u32 *status)
diff --git a/drivers/staging/et131x/et131x.h b/drivers/staging/et131x/et131x.h
index 0531414..71fd7fe 100644
--- a/drivers/staging/et131x/et131x.h
+++ b/drivers/staging/et131x/et131x.h
@@ -108,105 +108,3 @@
 #define INT_MASK_ENABLE             0xfffebf17
 #define INT_MASK_ENABLE_NO_FLOW     0xfffebfd7
 
-
-/* et131x_eeprom.c */
-int et131x_init_eeprom(struct et131x_adapter *adapter);
-
-/* et131x_initpci.c */
-void et131x_error_timer_handler(unsigned long data);
-void et131x_configure_global_regs(struct et131x_adapter *adapter);
-void et131x_enable_interrupts(struct et131x_adapter *adapter);
-void et131x_disable_interrupts(struct et131x_adapter *adapter);
-void et131x_align_allocated_memory(struct et131x_adapter *adapter,
-				   u64 *phys_addr,
-				   u64 *offset, u64 mask);
-
-void et131x_adapter_setup(struct et131x_adapter *adapter);
-int et131x_adapter_memory_alloc(struct et131x_adapter *adapter);
-void et131x_adapter_memory_free(struct et131x_adapter *adapter);
-void et131x_hwaddr_init(struct et131x_adapter *adapter);
-void et131x_soft_reset(struct et131x_adapter *adapter);
-
-/* et131x_isr.c */
-irqreturn_t et131x_isr(int irq, void *dev_id);
-void et131x_isr_handler(struct work_struct *work);
-
-/* et1310_mac.c */
-void et1310_config_mac_regs1(struct et131x_adapter *adapter);
-void et1310_config_mac_regs2(struct et131x_adapter *adapter);
-void et1310_config_rxmac_regs(struct et131x_adapter *adapter);
-void et1310_config_txmac_regs(struct et131x_adapter *adapter);
-void et1310_config_macstat_regs(struct et131x_adapter *adapter);
-void et1310_config_flow_control(struct et131x_adapter *adapter);
-void et1310_update_macstat_host_counters(struct et131x_adapter *adapter);
-void et1310_handle_macstat_interrupt(struct et131x_adapter *adapter);
-void et1310_setup_device_for_multicast(struct et131x_adapter *adapter);
-void et1310_setup_device_for_unicast(struct et131x_adapter *adapter);
-
-/* et131x_netdev.c */
-int et131x_open(struct net_device *netdev);
-int et131x_close(struct net_device *netdev);
-void et131x_up(struct net_device *netdev);
-void et131x_down(struct net_device *netdev);
-struct net_device *et131x_device_alloc(void);
-void et131x_enable_txrx(struct net_device *netdev);
-void et131x_disable_txrx(struct net_device *netdev);
-
-/* et1310_pm.c */
-int et1310_in_phy_coma(struct et131x_adapter *adapter);
-void et1310_enable_phy_coma(struct et131x_adapter *adapter);
-void et1310_disable_phy_coma(struct et131x_adapter *adapter);
-
-/* et1310_phy.c */
-void et1310_phy_power_down(struct et131x_adapter *adapter, bool down);
-void et1310_phy_access_mii_bit(struct et131x_adapter *adapter,
-			       u16 action,
-			       u16 regnum, u16 bitnum, u8 *value);
-
-void et131x_xcvr_init(struct et131x_adapter *adapter);
-
-/* static inline function does not work because et131x_adapter is not always
- * defined
- */
-int et131x_phy_mii_read(struct et131x_adapter *adapter, u8 addr,
-	      u8 reg, u16 *value);
-int32_t et131x_mii_read(struct et131x_adapter *adapter,
-		u8 reg, u16 *value);
-int32_t et131x_mii_write(struct et131x_adapter *adapter,
-		u8 reg, u16 value);
-
-int et131x_mdio_read(struct mii_bus *bus, int phy_addr, int reg);
-int et131x_mdio_write(struct mii_bus *bus, int phy_addr, int reg, u16 value);
-int et131x_mdio_reset(struct mii_bus *bus);
-
-/* et1310_rx.c */
-int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter);
-void et131x_rx_dma_memory_free(struct et131x_adapter *adapter);
-int et131x_rfd_resources_alloc(struct et131x_adapter *adapter,
-			       struct rfd *rfd);
-void et131x_rfd_resources_free(struct et131x_adapter *adapter,
-			       struct rfd *rfd);
-int et131x_init_recv(struct et131x_adapter *adapter);
-
-void et131x_config_rx_dma_regs(struct et131x_adapter *adapter);
-void et131x_set_rx_dma_timer(struct et131x_adapter *adapter);
-void et131x_rx_dma_disable(struct et131x_adapter *adapter);
-void et131x_rx_dma_enable(struct et131x_adapter *adapter);
-
-void et131x_reset_recv(struct et131x_adapter *adapter);
-
-void et131x_handle_recv_interrupt(struct et131x_adapter *adapter);
-
-/* et131x_tx.c */
-int et131x_tx_dma_memory_alloc(struct et131x_adapter *adapter);
-void et131x_tx_dma_memory_free(struct et131x_adapter *adapter);
-void et131x_config_tx_dma_regs(struct et131x_adapter *adapter);
-void et131x_init_send(struct et131x_adapter *adapter);
-void et131x_tx_dma_disable(struct et131x_adapter *adapter);
-void et131x_tx_dma_enable(struct et131x_adapter *adapter);
-void et131x_handle_send_interrupt(struct et131x_adapter *adapter);
-void et131x_free_busy_send_packets(struct et131x_adapter *adapter);
-int et131x_send_packets(struct sk_buff *skb, struct net_device *netdev);
-
-/* et131x_ethtool.c */
-void et131x_set_ethtool_ops(struct net_device *netdev);
-- 
1.7.6.4

