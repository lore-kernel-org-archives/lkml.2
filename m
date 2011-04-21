Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280Ab1DUTTT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 15:19:19 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:48212
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752533Ab1DUTTS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 15:19:18 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: haiyangz@microsoft.com, hjanssen@microsoft.com, kys@microsoft.com,
        v-abkane@microsoft.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Subject: [PATCH 1/8] staging: hv: move netvsc_initialize() to clean up forward declaration
Date: Thu, 21 Apr 2011 12:30:40 -0700
Message-Id: <1303414247-22118-2-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1303414247-22118-1-git-send-email-haiyangz@microsoft.com>
References: <1303414247-22118-1-git-send-email-haiyangz@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/staging/hv/netvsc.c |   51 +++++++++++++++++-------------------------
 1 files changed, 21 insertions(+), 30 deletions(-)

diff --git a/drivers/staging/hv/netvsc.c b/drivers/staging/hv/netvsc.c
index e8c15d2..6eaecc1 100644
--- a/drivers/staging/hv/netvsc.c
+++ b/drivers/staging/hv/netvsc.c
@@ -45,12 +45,6 @@ static const struct hv_guid netvsc_device_type = {
 	}
 };
 
-static int netvsc_device_add(struct hv_device *device, void *additional_info);
-
-static int netvsc_device_remove(struct hv_device *device);
-
-static void netvsc_cleanup(struct hv_driver *driver);
-
 static void netvsc_channel_cb(void *context);
 
 static int netvsc_init_send_buf(struct hv_device *device);
@@ -66,9 +60,6 @@ static int netvsc_connect_vsp(struct hv_device *device);
 static void netvsc_send_completion(struct hv_device *device,
 				   struct vmpacket_descriptor *packet);
 
-static int netvsc_send(struct hv_device *device,
-			struct hv_netvsc_packet *packet);
-
 static void netvsc_receive(struct hv_device *device,
 			    struct vmpacket_descriptor *packet);
 
@@ -173,27 +164,6 @@ static struct netvsc_device *release_inbound_net_device(
 	return net_device;
 }
 
-/*
- * netvsc_initialize - Main entry point
- */
-int netvsc_initialize(struct hv_driver *drv)
-{
-	struct netvsc_driver *driver = (struct netvsc_driver *)drv;
-
-	drv->name = driver_name;
-	memcpy(&drv->dev_type, &netvsc_device_type, sizeof(struct hv_guid));
-
-	/* Setup the dispatch table */
-	driver->base.dev_add	= netvsc_device_add;
-	driver->base.dev_rm	= netvsc_device_remove;
-	driver->base.cleanup		= netvsc_cleanup;
-
-	driver->send			= netvsc_send;
-
-	rndis_filter_init(driver);
-	return 0;
-}
-
 static int netvsc_init_recv_buf(struct hv_device *device)
 {
 	int ret = 0;
@@ -1228,3 +1198,24 @@ out:
 	kfree(buffer);
 	return;
 }
+
+/*
+ * netvsc_initialize - Main entry point
+ */
+int netvsc_initialize(struct hv_driver *drv)
+{
+	struct netvsc_driver *driver = (struct netvsc_driver *)drv;
+
+	drv->name = driver_name;
+	memcpy(&drv->dev_type, &netvsc_device_type, sizeof(struct hv_guid));
+
+	/* Setup the dispatch table */
+	driver->base.dev_add	= netvsc_device_add;
+	driver->base.dev_rm	= netvsc_device_remove;
+	driver->base.cleanup		= netvsc_cleanup;
+
+	driver->send			= netvsc_send;
+
+	rndis_filter_init(driver);
+	return 0;
+}
-- 
1.6.3.2

