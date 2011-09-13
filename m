Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932268Ab1IMSP5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 14:15:57 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:59855
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756227Ab1IMSPw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 14:15:52 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 19/20] Staging: hv: netvsc: Rename rndisDevice to rndis_device
Date: Tue, 13 Sep 2011 10:59:55 -0700
Message-Id: <1315936796-20662-19-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315936796-20662-1-git-send-email-kys@microsoft.com>
References: <1315936759-20623-1-git-send-email-kys@microsoft.com>
 <1315936796-20662-1-git-send-email-kys@microsoft.com>
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
index efa7df5..bfe9129 100644
--- a/drivers/staging/hv/rndis_filter.c
+++ b/drivers/staging/hv/rndis_filter.c
@@ -690,11 +690,11 @@ int rndis_filter_device_add(struct hv_device *dev,
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
@@ -704,7 +704,7 @@ int rndis_filter_device_add(struct hv_device *dev,
 	 */
 	ret = netvsc_device_add(dev, additional_info);
 	if (ret != 0) {
-		kfree(rndisDevice);
+		kfree(rndis_device);
 		return ret;
 	}
 
@@ -712,11 +712,11 @@ int rndis_filter_device_add(struct hv_device *dev,
 	/* Initialize the rndis device */
 	net_device = hv_get_drvdata(dev);
 
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
@@ -725,21 +725,21 @@ int rndis_filter_device_add(struct hv_device *dev,
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

