Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686Ab1CJVyy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 16:54:54 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:58961
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751816Ab1CJVyw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 16:54:52 -0500
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: kys@microsoft.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Cc: Haiyang Zhang <haiyangz@microsoft.com>,
        Mike Sterling <mike.sterling@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 02/21] Staging: hv: Change the signature for vmbus_cleanup()
Date: Thu, 10 Mar 2011 14:04:29 -0800
Message-Id: <1299794669-895-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
In-Reply-To: <[PATCH 00/21] Staging: hv: Cleanup vmbus driver>
References: <[PATCH 00/21] Staging: hv: Cleanup vmbus driver>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As part of geting rid of hv_driver object from
vmbus_driver_context, change the signature of
vmbus_cleanup() function. Note that while
vmbus_cleanup() was passed a pointer to hv_driver,
this argument was unused.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Mike Sterling <mike.sterling@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/vmbus_drv.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index 884a4c6..95654b1 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -190,9 +190,8 @@ static int vmbus_dev_rm(struct hv_device *dev)
 /*
  * vmbus_cleanup - Perform any cleanup when the driver is removed
  */
-static void vmbus_cleanup(struct hv_driver *drv)
+static void vmbus_cleanup(void)
 {
-	/* struct vmbus_driver *driver = (struct vmbus_driver *)drv; */
 
 	hv_cleanup();
 }
@@ -574,7 +573,7 @@ static void vmbus_bus_exit(void)
 	/* Remove the root device */
 	vmbus_dev_rm(dev_ctx);
 
-	vmbus_cleanup(NULL);
+	vmbus_cleanup();
 
 	/* Unregister the root bus device */
 	device_unregister(&dev_ctx->device);
-- 
1.5.5.6

