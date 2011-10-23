Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753037Ab1JWROc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 13:14:32 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:60817 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621Ab1JWROb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 13:14:31 -0400
Date: Sun, 23 Oct 2011 19:11:02 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Mark Einon <mark.einon@gmail.com>
Cc: Greg KH <greg@kroah.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH staging 1/6] et131x: add static qualifiers.
Message-ID: <20111023171102.GA28657@electric-eye.fr.zoreil.com>
References: <1319361774-3148-1-git-send-email-mark.einon@gmail.com> <20111023093651.GA22285@kroah.com> <20111023094231.GA3409@msilap.einon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111023094231.GA3409@msilap.einon>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
---
 drivers/staging/et131x/et131x.c |  119 ++++++++++++++++++++-------------------
 1 files changed, 60 insertions(+), 59 deletions(-)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index 45b88d4..06960f3 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -795,7 +795,7 @@ static int eeprom_read(struct et131x_adapter *adapter, u32 addr, u8 *pdata)
 	return (status & LBCIF_STATUS_ACK_ERROR) ? -EIO : 0;
 }
 
-int et131x_init_eeprom(struct et131x_adapter *adapter)
+static int et131x_init_eeprom(struct et131x_adapter *adapter)
 {
 	struct pci_dev *pdev = adapter->pdev;
 	u8 eestatus;
@@ -868,7 +868,7 @@ int et131x_init_eeprom(struct et131x_adapter *adapter)
  * et131x_rx_dma_enable - re-start of Rx_DMA on the ET1310.
  * @adapter: pointer to our adapter structure
  */
-void et131x_rx_dma_enable(struct et131x_adapter *adapter)
+static void et131x_rx_dma_enable(struct et131x_adapter *adapter)
 {
 	/* Setup the receive dma configuration register for normal operation */
 	u32 csr =  0x2000;	/* FBR1 enable */
@@ -906,7 +906,7 @@ void et131x_rx_dma_enable(struct et131x_adapter *adapter)
  * et131x_rx_dma_disable - Stop of Rx_DMA on the ET1310
  * @adapter: pointer to our adapter structure
  */
-void et131x_rx_dma_disable(struct et131x_adapter *adapter)
+static void et131x_rx_dma_disable(struct et131x_adapter *adapter)
 {
 	u32 csr;
 	/* Setup the receive dma configuration register */
@@ -928,7 +928,7 @@ void et131x_rx_dma_disable(struct et131x_adapter *adapter)
  *
  * Mainly used after a return to the D0 (full-power) state from a lower state.
  */
-void et131x_tx_dma_enable(struct et131x_adapter *adapter)
+static void et131x_tx_dma_enable(struct et131x_adapter *adapter)
 {
 	/* Setup the transmit dma configuration register for normal
 	 * operation
@@ -964,7 +964,7 @@ static inline void add_12bit(u32 *v, int n)
  * et1310_config_mac_regs1 - Initialize the first part of MAC regs
  * @adapter: pointer to our adapter structure
  */
-void et1310_config_mac_regs1(struct et131x_adapter *adapter)
+static void et1310_config_mac_regs1(struct et131x_adapter *adapter)
 {
 	struct mac_regs __iomem *macregs = &adapter->regs->mac;
 	u32 station1;
@@ -1024,7 +1024,7 @@ void et1310_config_mac_regs1(struct et131x_adapter *adapter)
  * et1310_config_mac_regs2 - Initialize the second part of MAC regs
  * @adapter: pointer to our adapter structure
  */
-void et1310_config_mac_regs2(struct et131x_adapter *adapter)
+static void et1310_config_mac_regs2(struct et131x_adapter *adapter)
 {
 	int32_t delay = 0;
 	struct mac_regs __iomem *mac = &adapter->regs->mac;
@@ -1105,7 +1105,7 @@ void et1310_config_mac_regs2(struct et131x_adapter *adapter)
  *
  * Returns 0 if the device is not in phy coma, 1 if it is in phy coma
  */
-int et1310_in_phy_coma(struct et131x_adapter *adapter)
+static int et1310_in_phy_coma(struct et131x_adapter *adapter)
 {
 	u32 pmcsr;
 
@@ -1114,7 +1114,7 @@ int et1310_in_phy_coma(struct et131x_adapter *adapter)
 	return ET_PM_PHY_SW_COMA & pmcsr ? 1 : 0;
 }
 
-void et1310_setup_device_for_multicast(struct et131x_adapter *adapter)
+static void et1310_setup_device_for_multicast(struct et131x_adapter *adapter)
 {
 	struct rxmac_regs __iomem *rxmac = &adapter->regs->rxmac;
 	uint32_t nIndex;
@@ -1163,7 +1163,7 @@ void et1310_setup_device_for_multicast(struct et131x_adapter *adapter)
 	}
 }
 
-void et1310_setup_device_for_unicast(struct et131x_adapter *adapter)
+static void et1310_setup_device_for_unicast(struct et131x_adapter *adapter)
 {
 	struct rxmac_regs __iomem *rxmac = &adapter->regs->rxmac;
 	u32 uni_pf1;
@@ -1203,7 +1203,7 @@ void et1310_setup_device_for_unicast(struct et131x_adapter *adapter)
 	}
 }
 
-void et1310_config_rxmac_regs(struct et131x_adapter *adapter)
+static void et1310_config_rxmac_regs(struct et131x_adapter *adapter)
 {
 	struct rxmac_regs __iomem *rxmac = &adapter->regs->rxmac;
 	struct phy_device *phydev = adapter->phydev;
@@ -1334,7 +1334,7 @@ void et1310_config_rxmac_regs(struct et131x_adapter *adapter)
 	writel(0x9, &rxmac->ctrl);
 }
 
-void et1310_config_txmac_regs(struct et131x_adapter *adapter)
+static void et1310_config_txmac_regs(struct et131x_adapter *adapter)
 {
 	struct txmac_regs __iomem *txmac = &adapter->regs->txmac;
 
@@ -1348,7 +1348,7 @@ void et1310_config_txmac_regs(struct et131x_adapter *adapter)
 		writel(0x40, &txmac->cf_param);
 }
 
-void et1310_config_macstat_regs(struct et131x_adapter *adapter)
+static void et1310_config_macstat_regs(struct et131x_adapter *adapter)
 {
 	struct macstat_regs __iomem *macstat =
 		&adapter->regs->macstat;
@@ -1422,7 +1422,7 @@ void et1310_config_macstat_regs(struct et131x_adapter *adapter)
  *
  * Returns 0 on success, errno on failure (as defined in errno.h)
  */
-int et131x_phy_mii_read(struct et131x_adapter *adapter, u8 addr,
+static int et131x_phy_mii_read(struct et131x_adapter *adapter, u8 addr,
 	      u8 reg, u16 *value)
 {
 	struct mac_regs __iomem *mac = &adapter->regs->mac;
@@ -1478,7 +1478,7 @@ int et131x_phy_mii_read(struct et131x_adapter *adapter, u8 addr,
 	return status;
 }
 
-int et131x_mii_read(struct et131x_adapter *adapter, u8 reg, u16 *value)
+static int et131x_mii_read(struct et131x_adapter *adapter, u8 reg, u16 *value)
 {
 	struct phy_device *phydev = adapter->phydev;
 
@@ -1498,7 +1498,7 @@ int et131x_mii_read(struct et131x_adapter *adapter, u8 reg, u16 *value)
  *
  * Return 0 on success, errno on failure (as defined in errno.h)
  */
-int et131x_mii_write(struct et131x_adapter *adapter, u8 reg, u16 value)
+static int et131x_mii_write(struct et131x_adapter *adapter, u8 reg, u16 value)
 {
 	struct mac_regs __iomem *mac = &adapter->regs->mac;
 	struct phy_device *phydev = adapter->phydev;
@@ -1564,8 +1564,9 @@ int et131x_mii_write(struct et131x_adapter *adapter, u8 reg, u16 value)
 }
 
 /* Still used from _mac for BIT_READ */
-void et1310_phy_access_mii_bit(struct et131x_adapter *adapter, u16 action,
-			       u16 regnum, u16 bitnum, u8 *value)
+static void et1310_phy_access_mii_bit(struct et131x_adapter *adapter,
+				      u16 action, u16 regnum, u16 bitnum,
+				      u8 *value)
 {
 	u16 reg;
 	u16 mask = 0x0001 << bitnum;
@@ -1591,7 +1592,7 @@ void et1310_phy_access_mii_bit(struct et131x_adapter *adapter, u16 action,
 	}
 }
 
-void et1310_config_flow_control(struct et131x_adapter *adapter)
+static void et1310_config_flow_control(struct et131x_adapter *adapter)
 {
 	struct phy_device *phydev = adapter->phydev;
 
@@ -1632,7 +1633,7 @@ void et1310_config_flow_control(struct et131x_adapter *adapter)
  * et1310_update_macstat_host_counters - Update the local copy of the statistics
  * @adapter: pointer to the adapter structure
  */
-void et1310_update_macstat_host_counters(struct et131x_adapter *adapter)
+static void et1310_update_macstat_host_counters(struct et131x_adapter *adapter)
 {
 	struct ce_stats *stats = &adapter->stats;
 	struct macstat_regs __iomem *macstat =
@@ -1664,7 +1665,7 @@ void et1310_update_macstat_host_counters(struct et131x_adapter *adapter)
  * the statistics held in the adapter structure, checking the "wrap"
  * bit for each counter.
  */
-void et1310_handle_macstat_interrupt(struct et131x_adapter *adapter)
+static void et1310_handle_macstat_interrupt(struct et131x_adapter *adapter)
 {
 	u32 carry_reg1;
 	u32 carry_reg2;
@@ -1716,7 +1717,7 @@ void et1310_handle_macstat_interrupt(struct et131x_adapter *adapter)
 
 /* PHY functions */
 
-int et131x_mdio_read(struct mii_bus *bus, int phy_addr, int reg)
+static int et131x_mdio_read(struct mii_bus *bus, int phy_addr, int reg)
 {
 	struct net_device *netdev = bus->priv;
 	struct et131x_adapter *adapter = netdev_priv(netdev);
@@ -1731,7 +1732,7 @@ int et131x_mdio_read(struct mii_bus *bus, int phy_addr, int reg)
 		return value;
 }
 
-int et131x_mdio_write(struct mii_bus *bus, int phy_addr, int reg, u16 value)
+static int et131x_mdio_write(struct mii_bus *bus, int phy_addr, int reg, u16 value)
 {
 	struct net_device *netdev = bus->priv;
 	struct et131x_adapter *adapter = netdev_priv(netdev);
@@ -1739,7 +1740,7 @@ int et131x_mdio_write(struct mii_bus *bus, int phy_addr, int reg, u16 value)
 	return et131x_mii_write(adapter, reg, value);
 }
 
-int et131x_mdio_reset(struct mii_bus *bus)
+static int et131x_mdio_reset(struct mii_bus *bus)
 {
 	struct net_device *netdev = bus->priv;
 	struct et131x_adapter *adapter = netdev_priv(netdev);
@@ -1759,7 +1760,7 @@ int et131x_mdio_reset(struct mii_bus *bus)
  *	Can't you see that this code processed
  *	Phy power, phy power..
  */
-void et1310_phy_power_down(struct et131x_adapter *adapter, bool down)
+static void et1310_phy_power_down(struct et131x_adapter *adapter, bool down)
 {
 	u16 data;
 
@@ -1775,7 +1776,7 @@ void et1310_phy_power_down(struct et131x_adapter *adapter, bool down)
  * @adapter: pointer to our private adapter structure
  *
  */
-void et131x_xcvr_init(struct et131x_adapter *adapter)
+static void et131x_xcvr_init(struct et131x_adapter *adapter)
 {
 	u16 imr;
 	u16 isr;
@@ -1822,7 +1823,7 @@ void et131x_xcvr_init(struct et131x_adapter *adapter)
  *
  * Used to configure the global registers on the JAGCore
  */
-void et131x_configure_global_regs(struct et131x_adapter *adapter)
+static void et131x_configure_global_regs(struct et131x_adapter *adapter)
 {
 	struct global_regs __iomem *regs = &adapter->regs->global;
 
@@ -1869,7 +1870,7 @@ void et131x_configure_global_regs(struct et131x_adapter *adapter)
  * et131x_config_rx_dma_regs - Start of Rx_DMA init sequence
  * @adapter: pointer to our adapter structure
  */
-void et131x_config_rx_dma_regs(struct et131x_adapter *adapter)
+static void et131x_config_rx_dma_regs(struct et131x_adapter *adapter)
 {
 	struct rxdma_regs __iomem *rx_dma = &adapter->regs->rxdma;
 	struct rx_ring *rx_local = &adapter->rx_ring;
@@ -1987,7 +1988,7 @@ void et131x_config_rx_dma_regs(struct et131x_adapter *adapter)
  * Configure the transmit engine with the ring buffers we have created
  * and prepare it for use.
  */
-void et131x_config_tx_dma_regs(struct et131x_adapter *adapter)
+static void et131x_config_tx_dma_regs(struct et131x_adapter *adapter)
 {
 	struct txdma_regs __iomem *txdma = &adapter->regs->txdma;
 
@@ -2017,7 +2018,7 @@ void et131x_config_tx_dma_regs(struct et131x_adapter *adapter)
  *
  * Returns 0 on success, errno on failure (as defined in errno.h)
  */
-void et131x_adapter_setup(struct et131x_adapter *adapter)
+static void et131x_adapter_setup(struct et131x_adapter *adapter)
 {
 	/* Configure the JAGCore */
 	et131x_configure_global_regs(adapter);
@@ -2044,7 +2045,7 @@ void et131x_adapter_setup(struct et131x_adapter *adapter)
  * et131x_soft_reset - Issue a soft reset to the hardware, complete for ET1310
  * @adapter: pointer to our private adapter structure
  */
-void et131x_soft_reset(struct et131x_adapter *adapter)
+static void et131x_soft_reset(struct et131x_adapter *adapter)
 {
 	/* Disable MAC Core */
 	writel(0xc00f0000, &adapter->regs->mac.cfg1);
@@ -2062,7 +2063,7 @@ void et131x_soft_reset(struct et131x_adapter *adapter)
  *	Enable the appropriate interrupts on the ET131x according to our
  *	configuration
  */
-void et131x_enable_interrupts(struct et131x_adapter *adapter)
+static void et131x_enable_interrupts(struct et131x_adapter *adapter)
 {
 	u32 mask;
 
@@ -2082,7 +2083,7 @@ void et131x_enable_interrupts(struct et131x_adapter *adapter)
  *
  *	Block all interrupts from the et131x device at the device itself
  */
-void et131x_disable_interrupts(struct et131x_adapter *adapter)
+static void et131x_disable_interrupts(struct et131x_adapter *adapter)
 {
 	/* Disable all global interrupts */
 	writel(INT_MASK_DISABLE, &adapter->regs->global.int_mask);
@@ -2092,7 +2093,7 @@ void et131x_disable_interrupts(struct et131x_adapter *adapter)
  * et131x_tx_dma_disable - Stop of Tx_DMA on the ET1310
  * @adapter: pointer to our adapter structure
  */
-void et131x_tx_dma_disable(struct et131x_adapter *adapter)
+static void et131x_tx_dma_disable(struct et131x_adapter *adapter)
 {
 	/* Setup the tramsmit dma configuration register */
 	writel(ET_TXDMA_CSR_HALT|ET_TXDMA_SNGL_EPKT,
@@ -2103,7 +2104,7 @@ void et131x_tx_dma_disable(struct et131x_adapter *adapter)
  * et131x_enable_txrx - Enable tx/rx queues
  * @netdev: device to be enabled
  */
-void et131x_enable_txrx(struct net_device *netdev)
+static void et131x_enable_txrx(struct net_device *netdev)
 {
 	struct et131x_adapter *adapter = netdev_priv(netdev);
 
@@ -2123,7 +2124,7 @@ void et131x_enable_txrx(struct net_device *netdev)
  * et131x_disable_txrx - Disable tx/rx queues
  * @netdev: device to be disabled
  */
-void et131x_disable_txrx(struct net_device *netdev)
+static void et131x_disable_txrx(struct net_device *netdev)
 {
 	struct et131x_adapter *adapter = netdev_priv(netdev);
 
@@ -2142,7 +2143,7 @@ void et131x_disable_txrx(struct net_device *netdev)
  * et131x_init_send - Initialize send data structures
  * @adapter: pointer to our private adapter structure
  */
-void et131x_init_send(struct et131x_adapter *adapter)
+static void et131x_init_send(struct et131x_adapter *adapter)
 {
 	struct tcb *tcb;
 	u32 ct;
@@ -2192,7 +2193,7 @@ void et131x_init_send(struct et131x_adapter *adapter)
  *       indicating linkup status, call the MPDisablePhyComa routine to
  *             restore JAGCore and gigE PHY
  */
-void et1310_enable_phy_coma(struct et131x_adapter *adapter)
+static void et1310_enable_phy_coma(struct et131x_adapter *adapter)
 {
 	unsigned long flags;
 	u32 pmcsr;
@@ -2231,7 +2232,7 @@ void et1310_enable_phy_coma(struct et131x_adapter *adapter)
  * et1310_disable_phy_coma - Disable the Phy Coma Mode
  * @adapter: pointer to our adapter structure
  */
-void et1310_disable_phy_coma(struct et131x_adapter *adapter)
+static void et1310_disable_phy_coma(struct et131x_adapter *adapter)
 {
 	u32 pmcsr;
 
@@ -2296,7 +2297,7 @@ static inline u32 bump_free_buff_ring(u32 *free_buff_ring, u32 limit)
  * @offset: pointer to the offset variable
  * @mask: correct mask
  */
-void et131x_align_allocated_memory(struct et131x_adapter *adapter,
+static void et131x_align_allocated_memory(struct et131x_adapter *adapter,
 				   uint64_t *phys_addr,
 				   uint64_t *offset, uint64_t mask)
 {
@@ -2325,7 +2326,7 @@ void et131x_align_allocated_memory(struct et131x_adapter *adapter,
  * Allocates Free buffer ring 1 for sure, free buffer ring 0 if required,
  * and the Packet Status Ring.
  */
-int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
+static int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 {
 	u32 i, j;
 	u32 bufsize;
@@ -2629,7 +2630,7 @@ int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
  * et131x_rx_dma_memory_free - Free all memory allocated within this module.
  * @adapter: pointer to our private adapter structure
  */
-void et131x_rx_dma_memory_free(struct et131x_adapter *adapter)
+static void et131x_rx_dma_memory_free(struct et131x_adapter *adapter)
 {
 	u32 index;
 	u32 bufsize;
@@ -2774,7 +2775,7 @@ void et131x_rx_dma_memory_free(struct et131x_adapter *adapter)
  *
  * Returns 0 on success and errno on failure (as defined in errno.h)
  */
-int et131x_init_recv(struct et131x_adapter *adapter)
+static int et131x_init_recv(struct et131x_adapter *adapter)
 {
 	int status = -ENOMEM;
 	struct rfd *rfd = NULL;
@@ -2824,7 +2825,7 @@ int et131x_init_recv(struct et131x_adapter *adapter)
  * et131x_set_rx_dma_timer - Set the heartbeat timer according to line rate.
  * @adapter: pointer to our adapter structure
  */
-void et131x_set_rx_dma_timer(struct et131x_adapter *adapter)
+static void et131x_set_rx_dma_timer(struct et131x_adapter *adapter)
 {
 	struct phy_device *phydev = adapter->phydev;
 
@@ -3139,7 +3140,7 @@ static struct rfd *nic_rx_pkts(struct et131x_adapter *adapter)
  *
  * Assumption, Rcv spinlock has been acquired.
  */
-void et131x_handle_recv_interrupt(struct et131x_adapter *adapter)
+static void et131x_handle_recv_interrupt(struct et131x_adapter *adapter)
 {
 	struct rfd *rfd = NULL;
 	u32 count = 0;
@@ -3202,7 +3203,7 @@ void et131x_handle_recv_interrupt(struct et131x_adapter *adapter)
  * memory. The device will update the "status" in memory each time it xmits a
  * packet.
  */
-int et131x_tx_dma_memory_alloc(struct et131x_adapter *adapter)
+static int et131x_tx_dma_memory_alloc(struct et131x_adapter *adapter)
 {
 	int desc_size = 0;
 	struct tx_ring *tx_ring = &adapter->tx_ring;
@@ -3256,7 +3257,7 @@ int et131x_tx_dma_memory_alloc(struct et131x_adapter *adapter)
  *
  * Returns 0 on success and errno on failure (as defined in errno.h).
  */
-void et131x_tx_dma_memory_free(struct et131x_adapter *adapter)
+static void et131x_tx_dma_memory_free(struct et131x_adapter *adapter)
 {
 	int desc_size = 0;
 
@@ -3578,7 +3579,7 @@ static int send_packet(struct sk_buff *skb, struct et131x_adapter *adapter)
  *
  * Return 0 in almost all cases; non-zero value in extreme hard failure only
  */
-int et131x_send_packets(struct sk_buff *skb, struct net_device *netdev)
+static int et131x_send_packets(struct sk_buff *skb, struct net_device *netdev)
 {
 	int status = 0;
 	struct et131x_adapter *adapter = netdev_priv(netdev);
@@ -3696,7 +3697,7 @@ static inline void free_send_packet(struct et131x_adapter *adapter,
  *
  * Assumption - Send spinlock has been acquired
  */
-void et131x_free_busy_send_packets(struct et131x_adapter *adapter)
+static void et131x_free_busy_send_packets(struct et131x_adapter *adapter)
 {
 	struct tcb *tcb;
 	unsigned long flags;
@@ -3743,7 +3744,7 @@ void et131x_free_busy_send_packets(struct et131x_adapter *adapter)
  *
  * Assumption - Send spinlock has been acquired
  */
-void et131x_handle_send_interrupt(struct et131x_adapter *adapter)
+static void et131x_handle_send_interrupt(struct et131x_adapter *adapter)
 {
 	unsigned long flags;
 	u32 serviced;
@@ -3965,7 +3966,7 @@ static struct ethtool_ops et131x_ethtool_ops = {
 	.get_link = ethtool_op_get_link,
 };
 
-void et131x_set_ethtool_ops(struct net_device *netdev)
+static void et131x_set_ethtool_ops(struct net_device *netdev)
 {
 	SET_ETHTOOL_OPS(netdev, &et131x_ethtool_ops);
 }
@@ -3976,7 +3977,7 @@ void et131x_set_ethtool_ops(struct net_device *netdev)
  * et131x_hwaddr_init - set up the MAC Address on the ET1310
  * @adapter: pointer to our private adapter structure
  */
-void et131x_hwaddr_init(struct et131x_adapter *adapter)
+static void et131x_hwaddr_init(struct et131x_adapter *adapter)
 {
 	/* If have our default mac from init and no mac address from
 	 * EEPROM then we need to generate the last octet and set it on the
@@ -4110,7 +4111,7 @@ static int et131x_pci_init(struct et131x_adapter *adapter,
  * The routine called when the error timer expires, to track the number of
  * recurring errors.
  */
-void et131x_error_timer_handler(unsigned long data)
+static void et131x_error_timer_handler(unsigned long data)
 {
 	struct et131x_adapter *adapter = (struct et131x_adapter *) data;
 	struct phy_device *phydev = adapter->phydev;
@@ -4153,7 +4154,7 @@ void et131x_error_timer_handler(unsigned long data)
  *
  * Allocate all the memory blocks for send, receive and others.
  */
-int et131x_adapter_memory_alloc(struct et131x_adapter *adapter)
+static int et131x_adapter_memory_alloc(struct et131x_adapter *adapter)
 {
 	int status;
 
@@ -4188,7 +4189,7 @@ int et131x_adapter_memory_alloc(struct et131x_adapter *adapter)
  * et131x_adapter_memory_free - Free all memory allocated for use by Tx & Rx
  * @adapter: pointer to our private adapter structure
  */
-void et131x_adapter_memory_free(struct et131x_adapter *adapter)
+static void et131x_adapter_memory_free(struct et131x_adapter *adapter)
 {
 	/* Free DMA memory */
 	et131x_tx_dma_memory_free(adapter);
@@ -4417,7 +4418,7 @@ static void __devexit et131x_pci_remove(struct pci_dev *pdev)
  * et131x_up - Bring up a device for use.
  * @netdev: device to be opened
  */
-void et131x_up(struct net_device *netdev)
+static void et131x_up(struct net_device *netdev)
 {
 	struct et131x_adapter *adapter = netdev_priv(netdev);
 
@@ -4429,7 +4430,7 @@ void et131x_up(struct net_device *netdev)
  * et131x_down - Bring down the device
  * @netdev: device to be broght down
  */
-void et131x_down(struct net_device *netdev)
+static void et131x_down(struct net_device *netdev)
 {
 	struct et131x_adapter *adapter = netdev_priv(netdev);
 
@@ -4567,7 +4568,7 @@ out:
  * scheduled to run in a deferred context by the ISR. This is where the ISR's
  * work actually gets done.
  */
-void et131x_isr_handler(struct work_struct *work)
+static void et131x_isr_handler(struct work_struct *work)
 {
 	struct et131x_adapter *adapter =
 		container_of(work, struct et131x_adapter, task);
@@ -4823,7 +4824,7 @@ static struct net_device_stats *et131x_stats(struct net_device *netdev)
  *
  * Returns 0 on success, errno on failure (as defined in errno.h)
  */
-int et131x_open(struct net_device *netdev)
+static int et131x_open(struct net_device *netdev)
 {
 	int result = 0;
 	struct et131x_adapter *adapter = netdev_priv(netdev);
@@ -4857,7 +4858,7 @@ int et131x_open(struct net_device *netdev)
  *
  * Returns 0 on success, errno on failure (as defined in errno.h)
  */
-int et131x_close(struct net_device *netdev)
+static int et131x_close(struct net_device *netdev)
 {
 	struct et131x_adapter *adapter = netdev_priv(netdev);
 
-- 
1.7.6.4

