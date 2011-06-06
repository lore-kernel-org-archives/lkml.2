Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412Ab1FFSHo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 14:07:44 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:32875 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757229Ab1FFSHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 14:07:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=X73yyW366pv/r95ZgfwvKudEW1L2sw89IaZGKB0eQGQx1MVg9cFAzuAIGg9MY+NgkA
         7KSJN2ppZNTzNBKgsfS7VLOSjt7nd+YvDMIorqeiiXcAI0GzX46+U1Un000MM+c30IpG
         rH3xRubp0fM85N4wi9gcrHj9MrVfF/KeDocfI=
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com, alan@lxorguk.ukuu.org.uk,
        Mark Einon <mark.einon@gmail.com>
Subject: [PATCH v2 5/7] staging: et131x: et131x_netdev.c checkpatch fixes
Date: Mon,  6 Jun 2011 19:07:02 +0100
Message-Id: <1307383624-8740-6-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1307383624-8740-1-git-send-email-mark.einon@gmail.com>
References: <1307295320-31716-1-git-send-email-mark.einon@gmail.com>
 <1307383624-8740-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et131x_netdev.c |  112 ++++++++++++++-----------------
 1 files changed, 51 insertions(+), 61 deletions(-)

diff --git a/drivers/staging/et131x/et131x_netdev.c b/drivers/staging/et131x/et131x_netdev.c
index 5f6522c..7cc4b48 100644
--- a/drivers/staging/et131x/et131x_netdev.c
+++ b/drivers/staging/et131x/et131x_netdev.c
@@ -89,67 +89,6 @@
 #include "et131x.h"
 
 struct net_device_stats *et131x_stats(struct net_device *netdev);
-int et131x_open(struct net_device *netdev);
-int et131x_close(struct net_device *netdev);
-int et131x_ioctl(struct net_device *netdev, struct ifreq *reqbuf, int cmd);
-void et131x_multicast(struct net_device *netdev);
-int et131x_tx(struct sk_buff *skb, struct net_device *netdev);
-void et131x_tx_timeout(struct net_device *netdev);
-int et131x_change_mtu(struct net_device *netdev, int new_mtu);
-int et131x_set_mac_addr(struct net_device *netdev, void *new_mac);
-void et131x_vlan_rx_register(struct net_device *netdev, struct vlan_group *grp);
-void et131x_vlan_rx_add_vid(struct net_device *netdev, uint16_t vid);
-void et131x_vlan_rx_kill_vid(struct net_device *netdev, uint16_t vid);
-
-static const struct net_device_ops et131x_netdev_ops = {
-	.ndo_open		= et131x_open,
-	.ndo_stop		= et131x_close,
-	.ndo_start_xmit		= et131x_tx,
-	.ndo_set_multicast_list	= et131x_multicast,
-	.ndo_tx_timeout		= et131x_tx_timeout,
-	.ndo_change_mtu		= et131x_change_mtu,
-	.ndo_set_mac_address	= et131x_set_mac_addr,
-	.ndo_validate_addr	= eth_validate_addr,
-	.ndo_get_stats		= et131x_stats,
-	.ndo_do_ioctl		= et131x_ioctl,
-};
-
-/**
- * et131x_device_alloc
- *
- * Returns pointer to the allocated and initialized net_device struct for
- * this device.
- *
- * Create instances of net_device and wl_private for the new adapter and
- * register the device's entry points in the net_device structure.
- */
-struct net_device *et131x_device_alloc(void)
-{
-	struct net_device *netdev;
-
-	/* Alloc net_device and adapter structs */
-	netdev = alloc_etherdev(sizeof(struct et131x_adapter));
-
-	if (netdev == NULL) {
-		printk(KERN_ERR "et131x: Alloc of net_device struct failed\n");
-		return NULL;
-	}
-
-	/* Setup the function registration table (and other data) for a
-	 * net_device
-	 */
-	/* netdev->init               = &et131x_init; */
-	/* netdev->set_config = &et131x_config; */
-	netdev->watchdog_timeo = ET131X_TX_TIMEOUT;
-	netdev->netdev_ops = &et131x_netdev_ops;
-
-	/* netdev->ethtool_ops        = &et131x_ethtool_ops; */
-
-	/* Poll? */
-	/* netdev->poll               = &et131x_poll; */
-	/* netdev->poll_controller    = &et131x_poll_controller; */
-	return netdev;
-}
 
 /**
  * et131x_stats - Return the current device statistics.
@@ -702,3 +641,54 @@ int et131x_set_mac_addr(struct net_device *netdev, void *new_mac)
 	netif_wake_queue(netdev);
 	return result;
 }
+
+static const struct net_device_ops et131x_netdev_ops = {
+	.ndo_open		= et131x_open,
+	.ndo_stop		= et131x_close,
+	.ndo_start_xmit		= et131x_tx,
+	.ndo_set_multicast_list	= et131x_multicast,
+	.ndo_tx_timeout		= et131x_tx_timeout,
+	.ndo_change_mtu		= et131x_change_mtu,
+	.ndo_set_mac_address	= et131x_set_mac_addr,
+	.ndo_validate_addr	= eth_validate_addr,
+	.ndo_get_stats		= et131x_stats,
+	.ndo_do_ioctl		= et131x_ioctl,
+};
+
+/**
+ * et131x_device_alloc
+ *
+ * Returns pointer to the allocated and initialized net_device struct for
+ * this device.
+ *
+ * Create instances of net_device and wl_private for the new adapter and
+ * register the device's entry points in the net_device structure.
+ */
+struct net_device *et131x_device_alloc(void)
+{
+	struct net_device *netdev;
+
+	/* Alloc net_device and adapter structs */
+	netdev = alloc_etherdev(sizeof(struct et131x_adapter));
+
+	if (netdev == NULL) {
+		printk(KERN_ERR "et131x: Alloc of net_device struct failed\n");
+		return NULL;
+	}
+
+	/* Setup the function registration table (and other data) for a
+	 * net_device
+	 */
+	/* netdev->init               = &et131x_init; */
+	/* netdev->set_config = &et131x_config; */
+	netdev->watchdog_timeo = ET131X_TX_TIMEOUT;
+	netdev->netdev_ops = &et131x_netdev_ops;
+
+	/* netdev->ethtool_ops        = &et131x_ethtool_ops; */
+
+	/* Poll? */
+	/* netdev->poll               = &et131x_poll; */
+	/* netdev->poll_controller    = &et131x_poll_controller; */
+	return netdev;
+}
+
-- 
1.7.4.4

