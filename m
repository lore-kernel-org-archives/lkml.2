Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933141Ab1IHOFB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 10:05:01 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:33788
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933053Ab1IHODQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 10:03:16 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 24/25] Staging: hv: netvsc: Rename rndisDevice to rndis_device
Date: Thu,  8 Sep 2011 07:24:35 -0700
Message-Id: <1315491876-9554-24-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315491876-9554-1-git-send-email-kys@microsoft.com>
References: <1315491843-9513-1-git-send-email-kys@microsoft.com>
 <1315491876-9554-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename rndisDevice to rndis_device.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/rndis_filter.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/hv/rndis_filter.c b/drivers/staging/hv/rndis_filter.c
index fb46a88..cb9d4f6 100644
--- a/drivers/staging/hv/rndis_filter.c
+++ b/drivers/staging/hv/rndis_filter.c
@@ -695,11 +695,11 @@ int rndis_filter_device_add(struct hv_device *dev,
 {
 	int ret;
 	struct netvsc_device *net_device;
-	struct rndis_device *rndisDevice;
+	struct rndis_device *rndis_device;
 	struct netvsc_device_info *deviceInfo = additional_info;
 
-	rndisDevice = get_rndis_device();
-	if (!rndisDevice)
+	rndis_device = get_rndis_device();
+	if (!rndis_device)
 		return -ENODEV;
 
 	/*
@@ -709,7 +709,7 @@ int rndis_filter_device_add(struct hv_device *dev,
 	 */
 	ret = netvsc_device_add(dev, additional_info);
 	if (ret != 0) {
-		kfree(rndisDevice);
+		kfree(rndis_device);
 		return ret;
 	}
 
@@ -717,11 +717,11 @@ int rndis_filter_device_add(struct hv_device *dev,
 	/* Initialize the rndis device */
 	net_device = (struct netvsc_device *)hv_get_drvdata(dev);
 
-	net_device->extension = rndisDevice;
-	rndisDevice->net_dev = net_device;
+	net_device->extension = rndis_device;
+	rndis_device->net_dev = net_device;
 
 	/* Send the rndis initialization message */
-	ret = rndis_filter_init_device(rndisDevice);
+	ret = rndis_filter_init_device(rndis_device);
 	if (ret != 0) {
 		/*
 		 * TODO: If rndis init failed, we will need to shut down the
@@ -730,21 +730,21 @@ int rndis_filter_device_add(struct hv_device *dev,
 	}
 
 	/* Get the mac address */
-	ret = rndis_filter_query_device_mac(rndisDevice);
+	ret = rndis_filter_query_device_mac(rndis_device);
 	if (ret != 0) {
 		/*
 		 * TODO: shutdown rndis device and the channel
 		 */
 	}
 
-	memcpy(deviceInfo->mac_adr, rndisDevice->hw_mac_adr, ETH_ALEN);
+	memcpy(deviceInfo->mac_adr, rndis_device->hw_mac_adr, ETH_ALEN);
 
-	rndis_filter_query_device_link_status(rndisDevice);
+	rndis_filter_query_device_link_status(rndis_device);
 
-	deviceInfo->link_state = rndisDevice->link_stat;
+	deviceInfo->link_state = rndis_device->link_stat;
 
 	dev_info(&dev->device, "Device MAC %pM link state %s",
-		 rndisDevice->hw_mac_adr,
+		 rndis_device->hw_mac_adr,
 		 ((deviceInfo->link_state) ? ("down\n") : ("up\n")));
 
 	return ret;
-- 
1.7.4.1

