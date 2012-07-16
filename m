Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360Ab2GPMmB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 08:42:01 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46743 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272Ab2GPMl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 08:41:58 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Einon <mark.einon@gmail.com>, linux-kernel@vger.kernel.org
Cc: Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH] staging/et131x: fix checkpatch warnings
Date: Mon, 16 Jul 2012 21:41:53 +0900
Message-Id: <1342442513-10488-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below checkpatch warns was fixed,

drivers/staging/et131x/et131x.c:89: WARNING: quoted string split across lines
drivers/staging/et131x/et131x.c:2557: WARNING: Prefer pr_info(... to printk(KERN_INFO, ...
drivers/staging/et131x/et131x.c:2578: WARNING: Prefer pr_info(... to printk(KERN_INFO, ...
drivers/staging/et131x/et131x.c:2972: WARNING: suspect code indent for conditional statements (8, 8)
drivers/staging/et131x/et131x.c:4330: WARNING: quoted string split across lines
drivers/staging/et131x/et131x.c:5192: WARNING: Prefer pr_info(... to printk(KERN_INFO, ...

And added pr_fmt.

Signed-off-by: Toshiaki Yamane <yamanetoshi@gmail.com>
---
 drivers/staging/et131x/et131x.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index 5b11c5e..1de2425 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -53,6 +53,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/module.h>
@@ -85,8 +87,7 @@
 MODULE_AUTHOR("Victor Soriano <vjsoriano@agere.com>");
 MODULE_AUTHOR("Mark Einon <mark.einon@gmail.com>");
 MODULE_LICENSE("Dual BSD/GPL");
-MODULE_DESCRIPTION("10/100/1000 Base-T Ethernet Driver "
-		   "for the ET1310 by Agere Systems");
+MODULE_DESCRIPTION("10/100/1000 Base-T Ethernet Driver for the ET1310 by Agere Systems");
 
 /* EEPROM defines */
 #define MAX_NUM_REGISTER_POLLS          1000
@@ -2554,8 +2555,8 @@ static int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 			  "Cannot alloc memory for Packet Status Ring\n");
 		return -ENOMEM;
 	}
-	printk(KERN_INFO "Packet Status Ring %lx\n",
-	    (unsigned long) rx_ring->ps_ring_physaddr);
+	pr_info("Packet Status Ring %lx\n",
+		(unsigned long) rx_ring->ps_ring_physaddr);
 
 	/*
 	 * NOTE : dma_alloc_coherent(), used above to alloc DMA regions,
@@ -2575,7 +2576,7 @@ static int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 		return -ENOMEM;
 	}
 	rx_ring->num_rfd = NIC_DEFAULT_NUM_RFD;
-	printk(KERN_INFO "PRS %lx\n", (unsigned long)rx_ring->rx_status_bus);
+	pr_info("PRS %lx\n", (unsigned long)rx_ring->rx_status_bus);
 
 	/* Recv
 	 * kmem_cache_create initializes a lookaside list. After successful
@@ -2967,11 +2968,10 @@ static struct rfd *nic_rx_pkts(struct et131x_adapter *adapter)
 		(ring_index == 0 &&
 		buff_index > rx_local->fbr[1]->num_entries - 1) ||
 		(ring_index == 1 &&
-		buff_index > rx_local->fbr[0]->num_entries - 1))
+		 buff_index > rx_local->fbr[0]->num_entries - 1)) {
 #else
-	if (ring_index != 1 || buff_index > rx_local->fbr[0]->num_entries - 1)
+	if (ring_index != 1 || buff_index > rx_local->fbr[0]->num_entries - 1) {
 #endif
-	{
 		/* Illegal buffer or ring index cannot be used by S/W*/
 		dev_err(&adapter->pdev->dev,
 			  "NICRxPkts PSR Entry %d indicates "
@@ -4326,8 +4326,8 @@ static int et131x_mii_probe(struct net_device *netdev)
 	phydev->advertising = phydev->supported;
 	adapter->phydev = phydev;
 
-	dev_info(&adapter->pdev->dev, "attached PHY driver [%s] "
-		 "(mii_bus:phy_addr=%s)\n",
+	dev_info(&adapter->pdev->dev,
+		 "attached PHY driver [%s] (mii_bus:phy_addr=%s)\n",
 		 phydev->drv->name, dev_name(&phydev->dev));
 
 	return 0;
@@ -5189,8 +5189,8 @@ static int et131x_set_mac_addr(struct net_device *netdev, void *new_mac)
 
 	memcpy(netdev->dev_addr, address->sa_data, netdev->addr_len);
 
-	printk(KERN_INFO "%s: Setting MAC address to %pM\n",
-			netdev->name, netdev->dev_addr);
+	pr_info("%s: Setting MAC address to %pM\n",
+		netdev->name, netdev->dev_addr);
 
 	/* Free Rx DMA memory */
 	et131x_adapter_memory_free(adapter);
-- 
1.7.5.4

