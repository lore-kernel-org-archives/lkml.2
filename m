Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360Ab1CIG60 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 01:58:26 -0500
Received: from sj-iport-3.cisco.com ([171.71.176.72]:40706 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab1CIG6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 01:58:24 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAMazdk2rR7Hu/2dsb2JhbACma3SmXYtIh0gviGCFYwSFHYcVhmM
X-IronPort-AV: E=Sophos;i="4.62,289,1297036800"; 
   d="scan'208";a="275380337"
From: Vinay Sawal <vinaysawal@gmail.com>
To: greg@kroah.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Vinay Sawal <vinaysawal@gmail.com>
Subject: [PATCH 2/2] Staging: bcm: Bcmnet: fixed 'checkpatch.pl' issues
Date: Tue,  8 Mar 2011 22:58:22 -0800
Message-Id: <1299653902-27644-1-git-send-email-vinaysawal@gmail.com>
X-Mailer: git-send-email 1.6.2.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed all issues reported by 'checkpatch.pl' for this file.

Signed-off-by: Vinay Sawal <vinaysawal@gmail.com>
---
 drivers/staging/bcm/Bcmnet.c |   52 +++++++++++++++++++++++++++++------------
 1 files changed, 37 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/bcm/Bcmnet.c b/drivers/staging/bcm/Bcmnet.c
index a6ce239..a09b6a6 100644
--- a/drivers/staging/bcm/Bcmnet.c
+++ b/drivers/staging/bcm/Bcmnet.c
@@ -1,3 +1,24 @@
+/*
+    bcm/Bcmnet.c
+    Bcm network driver
+
+    This program is free software; you can redistribute it and/or modify
+    it under the terms of the GNU General Public License as published by
+    the Free Software Foundation; either version 2 of the License, or
+    (at your option) any later version.
+
+    This program is distributed in the hope that it will be useful,
+    but WITHOUT ANY WARRANTY; without even the implied warranty of
+    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+    GNU General Public License for more details.
+
+    You should have received a copy of the GNU General Public License
+    along with this program; if not, write to the Free Software
+    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+
+*/
+
+#define __NO_VERSION__
 #include "headers.h"
 
 struct net_device *gblpnetdev;
@@ -8,7 +29,7 @@ static INT bcm_open(struct net_device *dev)
 
 	if (Adapter->fw_download_done == FALSE) {
 		pr_notice(PFX "%s: link up failed (download in progress)\n",
- 			  dev->name);
+			  dev->name);
 		return -EBUSY;
 	}
 
@@ -50,7 +71,7 @@ static u16 bcm_select_queue(struct net_device *dev, struct sk_buff *skb)
 * Description - This is the main transmit function for our virtual
 *		interface(eth0). It handles the ARP packets. It
 *		clones this packet and then Queue it to a suitable
-* 		Queue. Then calls the transmit_packet().
+*		Queue. Then calls the transmit_packet().
 *
 * Parameter   -	 skb - Pointer to the socket buffer structure
 *		 dev - Pointer to the virtual net device structure
@@ -110,13 +131,13 @@ static netdev_tx_t bcm_transmit(struct sk_buff *skb, struct net_device *dev)
 Register other driver entry points with the kernel
 */
 static const struct net_device_ops bcmNetDevOps = {
-    .ndo_open		= bcm_open,
-    .ndo_stop 		= bcm_close,
-    .ndo_start_xmit	= bcm_transmit,
-    .ndo_change_mtu	= eth_change_mtu,
-    .ndo_set_mac_address = eth_mac_addr,
-    .ndo_validate_addr	= eth_validate_addr,
-    .ndo_select_queue	= bcm_select_queue,
+	.ndo_open		= bcm_open,
+	.ndo_stop		= bcm_close,
+	.ndo_start_xmit	        = bcm_transmit,
+	.ndo_change_mtu	        = eth_change_mtu,
+	.ndo_set_mac_address    = eth_mac_addr,
+	.ndo_validate_addr	= eth_validate_addr,
+	.ndo_select_queue	= bcm_select_queue,
 };
 
 static struct device_type wimax_type = {
@@ -138,7 +159,8 @@ static int bcm_get_settings(struct net_device *dev, struct ethtool_cmd *cmd)
 	return 0;
 }
 
-static void bcm_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
+static void bcm_get_drvinfo(struct net_device *dev,
+			    struct ethtool_drvinfo *info)
 {
 	PMINI_ADAPTER Adapter = GET_BCM_ADAPTER(dev);
 	PS_INTERFACE_ADAPTER psIntfAdapter = Adapter->pvInterfaceAdapter;
@@ -160,14 +182,14 @@ static u32 bcm_get_link(struct net_device *dev)
 	return Adapter->LinkUpStatus;
 }
 
-static u32 bcm_get_msglevel (struct net_device *dev)
+static u32 bcm_get_msglevel(struct net_device *dev)
 {
 	PMINI_ADAPTER Adapter = GET_BCM_ADAPTER(dev);
 
 	return Adapter->msg_enable;
 }
 
-static void bcm_set_msglevel (struct net_device *dev, u32 level)
+static void bcm_set_msglevel(struct net_device *dev, u32 level)
 {
 	PMINI_ADAPTER Adapter = GET_BCM_ADAPTER(dev);
 
@@ -177,7 +199,7 @@ static void bcm_set_msglevel (struct net_device *dev, u32 level)
 static const struct ethtool_ops bcm_ethtool_ops = {
 	.get_settings	= bcm_get_settings,
 	.get_drvinfo	= bcm_get_drvinfo,
-	.get_link 	= bcm_get_link,
+	.get_link	= bcm_get_link,
 	.get_msglevel	= bcm_get_msglevel,
 	.set_msglevel	= bcm_set_msglevel,
 };
@@ -206,7 +228,7 @@ int register_networkdev(PMINI_ADAPTER Adapter)
 	if (result != STATUS_SUCCESS) {
 		dev_err(&udev->dev,
 			PFX "Error in Reading the mac Address: %d", result);
- 		return -EIO;
+		return -EIO;
 	}
 
 	result = register_netdev(net);
@@ -233,6 +255,6 @@ void unregister_networkdev(PMINI_ADAPTER Adapter)
 	if (netif_msg_probe(Adapter))
 		dev_info(&udev->dev, PFX "%s: unregister usb-%s%s\n",
 			 net->name, xdev->bus->bus_name, xdev->devpath);
- 
+
 	unregister_netdev(Adapter->dev);
 }
-- 
1.6.2.4

