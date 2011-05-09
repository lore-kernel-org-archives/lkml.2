Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932771Ab1EJItq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 04:49:46 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:42638
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755966Ab1EJIau (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 04:30:50 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 008/206] Staging: hv: Rename variables of type struct storvsc_driver *
Date: Mon,  9 May 2011 14:54:50 -0700
Message-Id: <1304978288-22999-8-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename the variables pointing to variables of type struct storvsc_driver *. 

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index a0e08de..391666e 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -211,7 +211,7 @@ static int blkvsc_submit_request(struct blkvsc_request *blkvsc_req,
 {
 	struct block_device_context *blkdev = blkvsc_req->dev;
 	struct hv_device *device_ctx = blkdev->device_ctx;
-	struct storvsc_driver *storvsc_drv_obj =
+	struct storvsc_driver *storvsc_drv =
 			drv_to_stordrv(device_ctx->device.driver);
 	struct hv_storvsc_request *storvsc_req;
 	struct vmscsi_request *vm_srb;
@@ -237,7 +237,7 @@ static int blkvsc_submit_request(struct blkvsc_request *blkvsc_req,
 
 	storvsc_req->sense_buffer = blkvsc_req->sense_buffer;
 
-	ret = storvsc_drv_obj->on_io_request(blkdev->device_ctx,
+	ret = storvsc_drv->on_io_request(blkdev->device_ctx,
 					   &blkvsc_req->request);
 	if (ret == 0)
 		blkdev->num_outstanding_reqs++;
@@ -544,7 +544,7 @@ out:
  */
 static int blkvsc_remove(struct hv_device *dev)
 {
-	struct storvsc_driver *storvsc_drv_obj =
+	struct storvsc_driver *storvsc_drv =
 				drv_to_stordrv(dev->device.driver);
 	struct block_device_context *blkdev = dev_get_drvdata(&dev->device);
 	unsigned long flags;
@@ -553,7 +553,7 @@ static int blkvsc_remove(struct hv_device *dev)
 	 * Call to the vsc driver to let it know that the device is being
 	 * removed
 	 */
-	storvsc_drv_obj->base.dev_rm(dev);
+	storvsc_drv->base.dev_rm(dev);
 
 	/* Get to a known state */
 	spin_lock_irqsave(&blkdev->lock, flags);
@@ -867,16 +867,16 @@ static const struct block_device_operations block_ops = {
  */
 static int blkvsc_drv_init(void)
 {
-	struct storvsc_driver *storvsc_drv_obj = &blkvsc_drv;
+	struct storvsc_driver *storvsc_drv = &blkvsc_drv;
 	struct hv_driver *drv = &blkvsc_drv.base;
 	int ret;
 
-	storvsc_drv_obj->ring_buffer_size = blkvsc_ringbuffer_size;
+	storvsc_drv->ring_buffer_size = blkvsc_ringbuffer_size;
 
 	/* Callback to client driver to complete the initialization */
-	blk_vsc_initialize(&storvsc_drv_obj->base);
+	blk_vsc_initialize(&storvsc_drv->base);
 
-	drv->driver.name = storvsc_drv_obj->base.name;
+	drv->driver.name = storvsc_drv->base.name;
 
 	drv->probe = blkvsc_probe;
 	drv->remove = blkvsc_remove;
@@ -897,7 +897,7 @@ static int blkvsc_drv_exit_cb(struct device *dev, void *data)
 
 static void blkvsc_drv_exit(void)
 {
-	struct storvsc_driver *storvsc_drv_obj = &blkvsc_drv;
+	struct storvsc_driver *storvsc_drv = &blkvsc_drv;
 	struct hv_driver *drv = &blkvsc_drv.base;
 	struct device *current_dev;
 	int ret;
@@ -922,8 +922,8 @@ static void blkvsc_drv_exit(void)
 		device_unregister(current_dev);
 	}
 
-	if (storvsc_drv_obj->base.cleanup)
-		storvsc_drv_obj->base.cleanup(&storvsc_drv_obj->base);
+	if (storvsc_drv->base.cleanup)
+		storvsc_drv->base.cleanup(&storvsc_drv->base);
 
 	vmbus_child_driver_unregister(&drv->driver);
 
@@ -935,7 +935,7 @@ static void blkvsc_drv_exit(void)
  */
 static int blkvsc_probe(struct hv_device *dev)
 {
-	struct storvsc_driver *storvsc_drv_obj =
+	struct storvsc_driver *storvsc_drv =
 			drv_to_stordrv(dev->device.driver);
 
 	struct block_device_context *blkdev = NULL;
@@ -965,7 +965,7 @@ static int blkvsc_probe(struct hv_device *dev)
 
 
 	/* Call to the vsc driver to add the device */
-	ret = storvsc_drv_obj->base.dev_add(dev, &device_info);
+	ret = storvsc_drv->base.dev_add(dev, &device_info);
 	if (ret != 0)
 		goto cleanup;
 
@@ -1035,7 +1035,7 @@ static int blkvsc_probe(struct hv_device *dev)
 	return ret;
 
 remove:
-	storvsc_drv_obj->base.dev_rm(dev);
+	storvsc_drv->base.dev_rm(dev);
 
 cleanup:
 	if (blkdev) {
-- 
1.7.4.1

