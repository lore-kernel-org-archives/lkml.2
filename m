Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751590Ab2GRBDU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 21:03:20 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44407 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab2GRBC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 21:02:58 -0400
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Einon <mark.einon@gmail.com>, linux-kernel@vger.kernel.org
Cc: Toshiaki Yamane <yamanetoshi@gmail.com>
Subject: [PATCH] staging/et131x: fix checkpatch warnings
Date: Wed, 18 Jul 2012 10:02:46 +0900
Message-Id: <1342573366-8167-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1342442513-10488-1-git-send-email-yamanetoshi@gmail.com>
References: <1342442513-10488-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below checkpatch warns was fixed,

drivers/staging/et131x/et131x.c:2556: WARNING: Prefer pr_info(... to printk(KERN_INFO, ...
drivers/staging/et131x/et131x.c:2577: WARNING: Prefer pr_info(... to printk(KERN_INFO, ...
drivers/staging/et131x/et131x.c:5189: WARNING: Prefer pr_info(... to printk(KERN_INFO, ...

And added pr_fmt.

Signed-off-by: Toshiaki Yamane <yamanetoshi@gmail.com>
---
 drivers/staging/et131x/et131x.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index ac6897b..f188453 100644
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
@@ -2553,8 +2555,8 @@ static int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 			  "Cannot alloc memory for Packet Status Ring\n");
 		return -ENOMEM;
 	}
-	printk(KERN_INFO "Packet Status Ring %lx\n",
-	    (unsigned long) rx_ring->ps_ring_physaddr);
+	pr_info("Packet Status Ring %lx\n",
+		(unsigned long) rx_ring->ps_ring_physaddr);
 
 	/*
 	 * NOTE : dma_alloc_coherent(), used above to alloc DMA regions,
@@ -2574,7 +2576,7 @@ static int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
 		return -ENOMEM;
 	}
 	rx_ring->num_rfd = NIC_DEFAULT_NUM_RFD;
-	printk(KERN_INFO "PRS %lx\n", (unsigned long)rx_ring->rx_status_bus);
+	pr_info("PRS %lx\n", (unsigned long)rx_ring->rx_status_bus);
 
 	/* Recv
 	 * kmem_cache_create initializes a lookaside list. After successful
@@ -5186,8 +5188,8 @@ static int et131x_set_mac_addr(struct net_device *netdev, void *new_mac)
 
 	memcpy(netdev->dev_addr, address->sa_data, netdev->addr_len);
 
-	printk(KERN_INFO "%s: Setting MAC address to %pM\n",
-			netdev->name, netdev->dev_addr);
+	pr_info("%s: Setting MAC address to %pM\n",
+		netdev->name, netdev->dev_addr);
 
 	/* Free Rx DMA memory */
 	et131x_adapter_memory_free(adapter);
-- 
1.7.5.4

