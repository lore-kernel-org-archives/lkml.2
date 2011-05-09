Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283Ab1EIVoz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 17:44:55 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:54069
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751518Ab1EIVon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:44:43 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 006/206] Staging: hv: Change the name of struct storvsc_driver_object
Date: Mon,  9 May 2011 14:54:48 -0700
Message-Id: <1304978288-22999-6-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename the struct storvsc_driver_object. 

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c  |   14 +++++++-------
 drivers/staging/hv/storvsc.c     |    2 +-
 drivers/staging/hv/storvsc_api.h |    8 ++++----
 drivers/staging/hv/storvsc_drv.c |   14 +++++++-------
 4 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index 51d1265..a80e7c1 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -170,7 +170,7 @@ static int blk_vsc_on_device_add(struct hv_device *device,
 
 static int blk_vsc_initialize(struct hv_driver *driver)
 {
-	struct storvsc_driver_object *stor_driver;
+	struct storvsc_driver *stor_driver;
 	int ret = 0;
 
 	stor_driver = hvdr_to_stordr(driver);
@@ -211,7 +211,7 @@ static int blkvsc_submit_request(struct blkvsc_request *blkvsc_req,
 {
 	struct block_device_context *blkdev = blkvsc_req->dev;
 	struct hv_device *device_ctx = blkdev->device_ctx;
-	struct storvsc_driver_object *storvsc_drv_obj =
+	struct storvsc_driver *storvsc_drv_obj =
 			drv_to_stordrv(device_ctx->device.driver);
 	struct hv_storvsc_request *storvsc_req;
 	struct vmscsi_request *vm_srb;
@@ -544,7 +544,7 @@ out:
  */
 static int blkvsc_remove(struct hv_device *dev)
 {
-	struct storvsc_driver_object *storvsc_drv_obj =
+	struct storvsc_driver *storvsc_drv_obj =
 				drv_to_stordrv(dev->device.driver);
 	struct block_device_context *blkdev = dev_get_drvdata(&dev->device);
 	unsigned long flags;
@@ -852,7 +852,7 @@ static void blkvsc_request(struct request_queue *queue)
 
 
 /* The one and only one */
-static  struct storvsc_driver_object g_blkvsc_drv;
+static  struct storvsc_driver g_blkvsc_drv;
 
 static const struct block_device_operations block_ops = {
 	.owner = THIS_MODULE,
@@ -867,7 +867,7 @@ static const struct block_device_operations block_ops = {
  */
 static int blkvsc_drv_init(void)
 {
-	struct storvsc_driver_object *storvsc_drv_obj = &g_blkvsc_drv;
+	struct storvsc_driver *storvsc_drv_obj = &g_blkvsc_drv;
 	struct hv_driver *drv = &g_blkvsc_drv.base;
 	int ret;
 
@@ -897,7 +897,7 @@ static int blkvsc_drv_exit_cb(struct device *dev, void *data)
 
 static void blkvsc_drv_exit(void)
 {
-	struct storvsc_driver_object *storvsc_drv_obj = &g_blkvsc_drv;
+	struct storvsc_driver *storvsc_drv_obj = &g_blkvsc_drv;
 	struct hv_driver *drv = &g_blkvsc_drv.base;
 	struct device *current_dev;
 	int ret;
@@ -935,7 +935,7 @@ static void blkvsc_drv_exit(void)
  */
 static int blkvsc_probe(struct hv_device *dev)
 {
-	struct storvsc_driver_object *storvsc_drv_obj =
+	struct storvsc_driver *storvsc_drv_obj =
 			drv_to_stordrv(dev->device.driver);
 
 	struct block_device_context *blkdev = NULL;
diff --git a/drivers/staging/hv/storvsc.c b/drivers/staging/hv/storvsc.c
index d53aa97..6be504b 100644
--- a/drivers/staging/hv/storvsc.c
+++ b/drivers/staging/hv/storvsc.c
@@ -411,7 +411,7 @@ static void stor_vsc_on_channel_callback(void *context)
 static int stor_vsc_connect_to_vsp(struct hv_device *device)
 {
 	struct vmstorage_channel_properties props;
-	struct storvsc_driver_object *stor_driver;
+	struct storvsc_driver *stor_driver;
 	int ret;
 
 	stor_driver = drv_to_stordrv(device->device.driver);
diff --git a/drivers/staging/hv/storvsc_api.h b/drivers/staging/hv/storvsc_api.h
index b60a058..4ebf50a 100644
--- a/drivers/staging/hv/storvsc_api.h
+++ b/drivers/staging/hv/storvsc_api.h
@@ -73,7 +73,7 @@ struct hv_storvsc_request {
 
 
 /* Represents the block vsc driver */
-struct storvsc_driver_object {
+struct storvsc_driver {
 	struct hv_driver base;
 
 	/* Set by caller (in bytes) */
@@ -149,13 +149,13 @@ static inline void put_stor_device(struct hv_device *device)
 	atomic_dec(&stor_device->ref_count);
 }
 
-static inline struct storvsc_driver_object *hvdr_to_stordr(struct hv_driver *d)
+static inline struct storvsc_driver *hvdr_to_stordr(struct hv_driver *d)
 {
-	return container_of(d, struct storvsc_driver_object, base);
+	return container_of(d, struct storvsc_driver, base);
 }
 
 static inline
-struct storvsc_driver_object *drv_to_stordrv(struct device_driver *d)
+struct storvsc_driver *drv_to_stordrv(struct device_driver *d)
 {
 	struct hv_driver *hvdrv = drv_to_hv_drv(d);
 	return hvdr_to_stordr(hvdrv);
diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index e449481..1fce10e 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -77,7 +77,7 @@ struct storvsc_cmd_request {
  */
 static int stor_vsc_initialize(struct hv_driver *driver)
 {
-	struct storvsc_driver_object *stor_driver;
+	struct storvsc_driver *stor_driver;
 
 	stor_driver = hvdr_to_stordr(driver);
 
@@ -152,7 +152,7 @@ module_param(storvsc_ringbuffer_size, int, S_IRUGO);
 MODULE_PARM_DESC(storvsc_ringbuffer_size, "Ring buffer size (bytes)");
 
 /* The one and only one */
-static struct storvsc_driver_object g_storvsc_drv;
+static struct storvsc_driver g_storvsc_drv;
 
 /* Scsi driver */
 static struct scsi_host_template scsi_driver = {
@@ -189,7 +189,7 @@ static struct scsi_host_template scsi_driver = {
 static int storvsc_drv_init(void)
 {
 	int ret;
-	struct storvsc_driver_object *storvsc_drv_obj = &g_storvsc_drv;
+	struct storvsc_driver *storvsc_drv_obj = &g_storvsc_drv;
 	struct hv_driver *drv = &g_storvsc_drv.base;
 
 	storvsc_drv_obj->ring_buffer_size = storvsc_ringbuffer_size;
@@ -286,7 +286,7 @@ static int storvsc_drv_exit_cb(struct device *dev, void *data)
 
 static void storvsc_drv_exit(void)
 {
-	struct storvsc_driver_object *storvsc_drv_obj = &g_storvsc_drv;
+	struct storvsc_driver *storvsc_drv_obj = &g_storvsc_drv;
 	struct hv_driver *drv = &g_storvsc_drv.base;
 	struct device *current_dev = NULL;
 	int ret;
@@ -323,7 +323,7 @@ static void storvsc_drv_exit(void)
 static int storvsc_probe(struct hv_device *device)
 {
 	int ret;
-	struct storvsc_driver_object *storvsc_drv_obj =
+	struct storvsc_driver *storvsc_drv_obj =
 		 drv_to_stordrv(device->device.driver);
 	struct Scsi_Host *host;
 	struct host_device_context *host_device_ctx;
@@ -400,7 +400,7 @@ static int storvsc_probe(struct hv_device *device)
  */
 static int storvsc_remove(struct hv_device *dev)
 {
-	struct storvsc_driver_object *storvsc_drv_obj =
+	struct storvsc_driver *storvsc_drv_obj =
 			 drv_to_stordrv(dev->device.driver);
 	struct Scsi_Host *host = dev_get_drvdata(&dev->device);
 	struct host_device_context *host_device_ctx =
@@ -686,7 +686,7 @@ static int storvsc_queuecommand_lck(struct scsi_cmnd *scmnd,
 	struct host_device_context *host_device_ctx =
 		(struct host_device_context *)scmnd->device->host->hostdata;
 	struct hv_device *device_ctx = host_device_ctx->device_ctx;
-	struct storvsc_driver_object *storvsc_drv_obj =
+	struct storvsc_driver *storvsc_drv_obj =
 		drv_to_stordrv(device_ctx->device.driver);
 	struct hv_storvsc_request *request;
 	struct storvsc_cmd_request *cmd_request;
-- 
1.7.4.1

