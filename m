Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933228Ab1IHOGF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 10:06:05 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:33773
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933081Ab1IHODP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 10:03:15 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 23/25] Staging: hv: netvsc: Rename netDevice as net_device
Date: Thu,  8 Sep 2011 07:24:34 -0700
Message-Id: <1315491876-9554-23-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315491876-9554-1-git-send-email-kys@microsoft.com>
References: <1315491843-9513-1-git-send-email-kys@microsoft.com>
 <1315491876-9554-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename netDevice as net_device.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/netvsc.c       |    5 ++++-
 drivers/staging/hv/rndis_filter.c |   20 ++++++++++----------
 2 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/hv/netvsc.c b/drivers/staging/hv/netvsc.c
index b046873..4564f13 100644
--- a/drivers/staging/hv/netvsc.c
+++ b/drivers/staging/hv/netvsc.c
@@ -385,7 +385,10 @@ int netvsc_device_remove(struct hv_device *device)
 	hv_set_drvdata(device, NULL);
 	spin_unlock_irqrestore(&device->channel->inbound_lock, flags);
 
-	/* At this point, no one should be accessing netDevice except in here */
+	/*
+	 * At this point, no one should be accessing net_device
+	 * except in here
+	 */
 	dev_notice(&device->device, "net device safe to remove\n");
 
 	/* Now, we can close the channel safely */
diff --git a/drivers/staging/hv/rndis_filter.c b/drivers/staging/hv/rndis_filter.c
index 79948be..fb46a88 100644
--- a/drivers/staging/hv/rndis_filter.c
+++ b/drivers/staging/hv/rndis_filter.c
@@ -694,7 +694,7 @@ int rndis_filter_device_add(struct hv_device *dev,
 				  void *additional_info)
 {
 	int ret;
-	struct netvsc_device *netDevice;
+	struct netvsc_device *net_device;
 	struct rndis_device *rndisDevice;
 	struct netvsc_device_info *deviceInfo = additional_info;
 
@@ -715,10 +715,10 @@ int rndis_filter_device_add(struct hv_device *dev,
 
 
 	/* Initialize the rndis device */
-	netDevice = (struct netvsc_device *)hv_get_drvdata(dev);
+	net_device = (struct netvsc_device *)hv_get_drvdata(dev);
 
-	netDevice->extension = rndisDevice;
-	rndisDevice->net_dev = netDevice;
+	net_device->extension = rndisDevice;
+	rndisDevice->net_dev = net_device;
 
 	/* Send the rndis initialization message */
 	ret = rndis_filter_init_device(rndisDevice);
@@ -768,24 +768,24 @@ void rndis_filter_device_remove(struct hv_device *dev)
 
 int rndis_filter_open(struct hv_device *dev)
 {
-	struct netvsc_device *netDevice =
+	struct netvsc_device *net_device =
 		(struct netvsc_device *)hv_get_drvdata(dev);
 
-	if (!netDevice)
+	if (!net_device)
 		return -EINVAL;
 
-	return rndis_filter_open_device(netDevice->extension);
+	return rndis_filter_open_device(net_device->extension);
 }
 
 int rndis_filter_close(struct hv_device *dev)
 {
-	struct netvsc_device *netDevice =
+	struct netvsc_device *net_device =
 		(struct netvsc_device *)hv_get_drvdata(dev);
 
-	if (!netDevice)
+	if (!net_device)
 		return -EINVAL;
 
-	return rndis_filter_close_device(netDevice->extension);
+	return rndis_filter_close_device(net_device->extension);
 }
 
 int rndis_filter_send(struct hv_device *dev,
-- 
1.7.4.1

