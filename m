Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526Ab0LFU36 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 15:29:58 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:40420
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752963Ab0LFU35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 15:29:57 -0500
From: Hank Janssen <hjanssen@microsoft.com>
To: hjanssen@microsoft.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Cc: Abhishek Kane <v-abkane@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 3/8] staging: hv: Convert camel case functions in storvsc_api.h to lowercase
Date: Mon,  6 Dec 2010 12:26:46 -0800
Message-Id: <1291667211-1865-3-git-send-email-hjanssen@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
In-Reply-To: <1291667211-1865-2-git-send-email-hjanssen@microsoft.com>
References: <1291667211-1865-1-git-send-email-hjanssen@microsoft.com>
 <1291667211-1865-2-git-send-email-hjanssen@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hank Janssen <hjanssen@microsoft.com> 

Convert camel case functions in storvsc_api.h to lowercase

Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>

---
 drivers/staging/hv/blkvsc.c      |    2 +-
 drivers/staging/hv/blkvsc_drv.c  |    2 +-
 drivers/staging/hv/storvsc.c     |    6 +++---
 drivers/staging/hv/storvsc_api.h |    6 +++---
 drivers/staging/hv/storvsc_drv.c |    4 ++--
 5 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/hv/blkvsc.c b/drivers/staging/hv/blkvsc.c
index 9ac04c3..e62c922 100644
--- a/drivers/staging/hv/blkvsc.c
+++ b/drivers/staging/hv/blkvsc.c
@@ -62,7 +62,7 @@ static int BlkVscOnDeviceAdd(struct hv_device *Device, void *AdditionalInfo)
 	return ret;
 }
 
-int BlkVscInitialize(struct hv_driver *Driver)
+int blk_vsc_initialize(struct hv_driver *Driver)
 {
 	struct storvsc_driver_object *storDriver;
 	int ret = 0;
diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index d65d69e..b3d05fc 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -1487,7 +1487,7 @@ static int __init blkvsc_init(void)
 
 	DPRINT_INFO(BLKVSC_DRV, "Blkvsc initializing....");
 
-	ret = blkvsc_drv_init(BlkVscInitialize);
+	ret = blkvsc_drv_init(blk_vsc_initialize);
 
 	return ret;
 }
diff --git a/drivers/staging/hv/storvsc.c b/drivers/staging/hv/storvsc.c
index c4346c6..7704131 100644
--- a/drivers/staging/hv/storvsc.c
+++ b/drivers/staging/hv/storvsc.c
@@ -605,7 +605,7 @@ static int StorVscOnDeviceRemove(struct hv_device *Device)
 	return 0;
 }
 
-int StorVscOnHostReset(struct hv_device *Device)
+int stor_vsc_on_host_reset(struct hv_device *Device)
 {
 	struct storvsc_device *storDevice;
 	struct storvsc_request_extension *request;
@@ -762,9 +762,9 @@ static void StorVscOnCleanup(struct hv_driver *Driver)
 }
 
 /*
- * StorVscInitialize - Main entry point
+ * stor_vsc_initialize - Main entry point
  */
-int StorVscInitialize(struct hv_driver *Driver)
+int stor_vsc_initialize(struct hv_driver *Driver)
 {
 	struct storvsc_driver_object *storDriver;
 
diff --git a/drivers/staging/hv/storvsc_api.h b/drivers/staging/hv/storvsc_api.h
index 46f031e..fbf5755 100644
--- a/drivers/staging/hv/storvsc_api.h
+++ b/drivers/staging/hv/storvsc_api.h
@@ -103,8 +103,8 @@ struct storvsc_device_info {
 };
 
 /* Interface */
-int StorVscInitialize(struct hv_driver *driver);
-int StorVscOnHostReset(struct hv_device *device);
-int BlkVscInitialize(struct hv_driver *driver);
+int stor_vsc_initialize(struct hv_driver *driver);
+int stor_vsc_on_host_reset(struct hv_device *device);
+int blk_vsc_initialize(struct hv_driver *driver);
 
 #endif /* _STORVSC_API_H_ */
diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 03695ce..0d96878 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -846,7 +846,7 @@ static int storvsc_host_reset_handler(struct scsi_cmnd *scmnd)
 		    scmnd->device, &device_ctx->device_obj);
 
 	/* Invokes the vsc to reset the host/bus */
-	ret = StorVscOnHostReset(&device_ctx->device_obj);
+	ret = stor_vsc_on_host_reset(&device_ctx->device_obj);
 	if (ret != 0)
 		return ret;
 
@@ -941,7 +941,7 @@ static int __init storvsc_init(void)
 	int ret;
 
 	DPRINT_INFO(STORVSC_DRV, "Storvsc initializing....");
-	ret = storvsc_drv_init(StorVscInitialize);
+	ret = storvsc_drv_init(stor_vsc_initialize);
 	return ret;
 }
 
-- 
1.6.0.2

