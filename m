Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045Ab1CIVri (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 16:47:38 -0500
Received: from sj-iport-4.cisco.com ([171.68.10.86]:23154 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005Ab1CIVrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 16:47:37 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEACKEd02rRN+J/2dsb2JhbACmcXSnKotOh2gviGCFZQSFIocYhmQ
X-IronPort-AV: E=Sophos;i="4.62,292,1297036800"; 
   d="scan'208";a="273483330"
From: Vinay Sawal <vinaysawal@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Vinay Sawal <vinaysawal@gmail.com>
Subject: [PATCH] Staging: bcm: Bcmnet: fixed checkpatch script reported issues
Date: Wed,  9 Mar 2011 13:47:35 -0800
Message-Id: <1299707255-21352-1-git-send-email-vinaysawal@gmail.com>
X-Mailer: git-send-email 1.6.2.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed all issues reported by checkpatch script on this file.

Signed-off-by: Vinay Sawal <vinaysawal@gmail.com>
---
 drivers/staging/bcm/Bcmnet.c |   31 ++++++++++++++++---------------
 1 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/bcm/Bcmnet.c b/drivers/staging/bcm/Bcmnet.c
index a6ce239..133e146 100644
--- a/drivers/staging/bcm/Bcmnet.c
+++ b/drivers/staging/bcm/Bcmnet.c
@@ -8,7 +8,7 @@ static INT bcm_open(struct net_device *dev)
 
 	if (Adapter->fw_download_done == FALSE) {
 		pr_notice(PFX "%s: link up failed (download in progress)\n",
- 			  dev->name);
+			  dev->name);
 		return -EBUSY;
 	}
 
@@ -50,7 +50,7 @@ static u16 bcm_select_queue(struct net_device *dev, struct sk_buff *skb)
 * Description - This is the main transmit function for our virtual
 *		interface(eth0). It handles the ARP packets. It
 *		clones this packet and then Queue it to a suitable
-* 		Queue. Then calls the transmit_packet().
+*		Queue. Then calls the transmit_packet().
 *
 * Parameter   -	 skb - Pointer to the socket buffer structure
 *		 dev - Pointer to the virtual net device structure
@@ -110,13 +110,13 @@ static netdev_tx_t bcm_transmit(struct sk_buff *skb, struct net_device *dev)
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
@@ -138,7 +138,8 @@ static int bcm_get_settings(struct net_device *dev, struct ethtool_cmd *cmd)
 	return 0;
 }
 
-static void bcm_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
+static void bcm_get_drvinfo(struct net_device *dev,
+			    struct ethtool_drvinfo *info)
 {
 	PMINI_ADAPTER Adapter = GET_BCM_ADAPTER(dev);
 	PS_INTERFACE_ADAPTER psIntfAdapter = Adapter->pvInterfaceAdapter;
@@ -160,14 +161,14 @@ static u32 bcm_get_link(struct net_device *dev)
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
 
@@ -177,7 +178,7 @@ static void bcm_set_msglevel (struct net_device *dev, u32 level)
 static const struct ethtool_ops bcm_ethtool_ops = {
 	.get_settings	= bcm_get_settings,
 	.get_drvinfo	= bcm_get_drvinfo,
-	.get_link 	= bcm_get_link,
+	.get_link	= bcm_get_link,
 	.get_msglevel	= bcm_get_msglevel,
 	.set_msglevel	= bcm_set_msglevel,
 };
@@ -206,7 +207,7 @@ int register_networkdev(PMINI_ADAPTER Adapter)
 	if (result != STATUS_SUCCESS) {
 		dev_err(&udev->dev,
 			PFX "Error in Reading the mac Address: %d", result);
- 		return -EIO;
+		return -EIO;
 	}
 
 	result = register_netdev(net);
@@ -233,6 +234,6 @@ void unregister_networkdev(PMINI_ADAPTER Adapter)
 	if (netif_msg_probe(Adapter))
 		dev_info(&udev->dev, PFX "%s: unregister usb-%s%s\n",
 			 net->name, xdev->bus->bus_name, xdev->devpath);
- 
+
 	unregister_netdev(Adapter->dev);
 }
-- 
1.6.2.4

