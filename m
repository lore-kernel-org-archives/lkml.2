Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865Ab1HMA2A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 20:28:00 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:64949 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563Ab1HMA1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 20:27:48 -0400
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 07/10]drivers:net Remove pointless "@" from various parts of the kernel
Date: Fri, 12 Aug 2011 17:27:12 -0700
Message-Id: <1313195235-4522-7-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1313195235-4522-1-git-send-email-justinmattock@gmail.com>
References: <1313195235-4522-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

The patch series below removes some pointless "@"'s in various parts of the kernel.
Note: some might be useful, but then again, some just seemed a waste of space.
(and since the kernel is become bloated, might as well diet! even if it's a few bits)

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/net/arm/ep93xx_eth.c  |    2 +-
 drivers/net/ixp2000/enp2611.c |    8 ++++----
 drivers/net/ixp2000/ixpdev.c  |   10 +++++-----
 drivers/net/ixp2000/pm3386.c  |    6 +++---
 4 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/arm/ep93xx_eth.c b/drivers/net/arm/ep93xx_eth.c
index 4317af8..a259680 100644
--- a/drivers/net/arm/ep93xx_eth.c
+++ b/drivers/net/arm/ep93xx_eth.c
@@ -787,7 +787,7 @@ static int ep93xx_eth_remove(struct platform_device *pdev)
 
 	ep = netdev_priv(dev);
 
-	/* @@@ Force down.  */
+	/* Force down. */
 	unregister_netdev(dev);
 	ep93xx_free_buffers(ep);
 
diff --git a/drivers/net/ixp2000/enp2611.c b/drivers/net/ixp2000/enp2611.c
index 34a6cfd..68e4fea 100644
--- a/drivers/net/ixp2000/enp2611.c
+++ b/drivers/net/ixp2000/enp2611.c
@@ -122,8 +122,8 @@ static struct ixp2400_msf_parameters enp2611_msf_parameters =
 static struct net_device *nds[3];
 static struct timer_list link_check_timer;
 
-/* @@@ Poll the SFP moddef0 line too.  */
-/* @@@ Try to use the pm3386 DOOL interrupt as well.  */
+/* Poll the SFP moddef0 line too. */
+/* Try to use the pm3386 DOOL interrupt as well. */
 static void enp2611_check_link_status(unsigned long __dummy)
 {
 	int i;
@@ -138,7 +138,7 @@ static void enp2611_check_link_status(unsigned long __dummy)
 
 		status = pm3386_is_link_up(i);
 		if (status && !netif_carrier_ok(dev)) {
-			/* @@@ Should report autonegotiation status.  */
+			/* Should report autonegotiation status. */
 			printk(KERN_INFO "%s: NIC Link is Up\n", dev->name);
 
 			pm3386_enable_tx(i);
@@ -167,7 +167,7 @@ static void enp2611_set_port_admin_status(int port, int up)
 	} else {
 		caleb_disable_tx(port);
 		pm3386_disable_tx(port);
-		/* @@@ Flush out pending packets.  */
+		/* Flush out pending packets. */
 		pm3386_set_carrier(port, 0);
 
 		pm3386_disable_rx(port);
diff --git a/drivers/net/ixp2000/ixpdev.c b/drivers/net/ixp2000/ixpdev.c
index e122493..a319c81 100644
--- a/drivers/net/ixp2000/ixpdev.c
+++ b/drivers/net/ixp2000/ixpdev.c
@@ -47,7 +47,7 @@ static int ixpdev_xmit(struct sk_buff *skb, struct net_device *dev)
 	unsigned long flags;
 
 	if (unlikely(skb->len > PAGE_SIZE)) {
-		/* @@@ Count drops.  */
+		/* Count drops. */
 		dev_kfree_skb(skb);
 		return NETDEV_TX_OK;
 	}
@@ -103,7 +103,7 @@ static int ixpdev_rx(struct net_device *dev, int processed, int budget)
 			goto err;
 		}
 
-		/* @@@ Make FCS stripping configurable.  */
+		/* Make FCS stripping configurable. */
 		desc->pkt_length -= 4;
 
 		if (unlikely(!netif_running(nds[desc->channel])))
@@ -163,7 +163,7 @@ static void ixpdev_tx_complete(void)
 		if (desc == 0)
 			break;
 
-		/* @@@ Check whether entries come back in order.  */
+		/* Check whether entries come back in order. */
 		entry = (desc - TX_BUF_DESC_BASE) / sizeof(struct ixpdev_tx_desc);
 		channel = tx_desc[entry].channel;
 
@@ -343,7 +343,7 @@ int ixpdev_init(int __nds_count, struct net_device **__nds,
 		rx_desc[i].buf_length = PAGE_SIZE;
 	}
 
-	/* @@@ Maybe we shouldn't be preallocating TX buffers.  */
+	/* Maybe we shouldn't be preallocating TX buffers.  */
 	for (i = 0; i < TX_BUF_COUNT; i++) {
 		void *buf;
 
@@ -423,7 +423,7 @@ void ixpdev_deinit(void)
 {
 	int i;
 
-	/* @@@ Flush out pending packets.  */
+	/* Flush out pending packets. */
 
 	for (i = 0; i < nds_count; i++)
 		unregister_netdev(nds[i]);
diff --git a/drivers/net/ixp2000/pm3386.c b/drivers/net/ixp2000/pm3386.c
index e08d3f9..bedf822 100644
--- a/drivers/net/ixp2000/pm3386.c
+++ b/drivers/net/ixp2000/pm3386.c
@@ -166,7 +166,7 @@ void pm3386_init_port(int port)
 
 	/*
 	 * Initialise narrowbanding mode.  See application note 2010486
-	 * for more information.  (@@@ We also need to issue a reset
+	 * for more information.  (We also need to issue a reset
 	 * when ROOL or DOOL are detected.)
 	 */
 	pm3386_port_reg_write(port, 0x708, 0x10, 0xd055);
@@ -231,7 +231,7 @@ void pm3386_init_port(int port)
 	 */
 	pm3386_port_reg_write(port, 0x336, 0x100, 9018);
 
-	/* @@@ Should set 0x337/0x437 (RX forwarding threshold.)  */
+	/* Should set 0x337/0x437 (RX forwarding threshold.)  */
 
 	/*
 	 * Set autonegotiation parameters to 'no PAUSE, full duplex.'
@@ -294,7 +294,7 @@ void pm3386_get_stats(int port, struct net_device_stats *stats)
 	stats->tx_packets = pm3386_get_stat(port, 0x590);
 	stats->rx_bytes = pm3386_get_stat(port, 0x514);
 	stats->tx_bytes = pm3386_get_stat(port, 0x594);
-	/* @@@ Add other stats.  */
+	/* Add other stats. */
 }
 
 void pm3386_set_carrier(int port, int state)
-- 
1.7.6

