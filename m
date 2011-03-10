Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051Ab1CJV5T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 16:57:19 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:34211
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752660Ab1CJV5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 16:57:18 -0500
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: kys@microsoft.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Cc: Haiyang Zhang <haiyangz@microsoft.com>,
        Mike Sterling <mike.sterling@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 07/21] Staging: hv: Get rid of vmbus_cleanup() function
Date: Thu, 10 Mar 2011 14:06:55 -0800
Message-Id: <1299794815-1077-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
In-Reply-To: <[PATCH 00/21] Staging: hv: Cleanup vmbus driver>
References: <[PATCH 00/21] Staging: hv: Cleanup vmbus driver>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of the vmbus_cleanup() function by inlining the
necessary code.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Mike Sterling <mike.sterling@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/vmbus_drv.c |   11 +----------
 1 files changed, 1 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index 11c69c5..e078c59 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -173,15 +173,6 @@ static int vmbus_dev_add(struct hv_device *dev, void *info)
 }
 
 
-/*
- * vmbus_cleanup - Perform any cleanup when the driver is removed
- */
-static void vmbus_cleanup(void)
-{
-
-	hv_cleanup();
-}
-
 struct onmessage_work_context {
 	struct work_struct work;
 	struct hv_message msg;
@@ -560,7 +551,7 @@ static void vmbus_bus_exit(void)
 	vmbus_disconnect();
 	on_each_cpu(hv_synic_cleanup, NULL, 1);
 
-	vmbus_cleanup();
+	hv_cleanup();
 
 	/* Unregister the root bus device */
 	device_unregister(&dev_ctx->device);
-- 
1.5.5.6

