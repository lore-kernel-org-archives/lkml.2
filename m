Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932323Ab1EIWHn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 18:07:43 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:47398
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753220Ab1EIVop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:44:45 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 034/206] Staging: hv: Rename variables pointing to struct hv_host_device
Date: Mon,  9 May 2011 14:55:16 -0700
Message-Id: <1304978288-22999-34-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The subject line says it all.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/storvsc_drv.c |   50 +++++++++++++++++++-------------------
 1 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 2411f53..2e2e004 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -326,7 +326,7 @@ static int storvsc_probe(struct hv_device *device)
 	struct storvsc_driver *storvsc_drv_obj =
 		 drv_to_stordrv(device->device.driver);
 	struct Scsi_Host *host;
-	struct hv_host_device *host_device_ctx;
+	struct hv_host_device *host_dev;
 	struct storvsc_device_info device_info;
 
 	if (!storvsc_drv_obj->base.dev_add)
@@ -341,18 +341,18 @@ static int storvsc_probe(struct hv_device *device)
 
 	dev_set_drvdata(&device->device, host);
 
-	host_device_ctx = (struct hv_host_device *)host->hostdata;
-	memset(host_device_ctx, 0, sizeof(struct hv_host_device));
+	host_dev = (struct hv_host_device *)host->hostdata;
+	memset(host_dev, 0, sizeof(struct hv_host_device));
 
-	host_device_ctx->port = host->host_no;
-	host_device_ctx->device_ctx = device;
+	host_dev->port = host->host_no;
+	host_dev->device_ctx = device;
 
-	host_device_ctx->request_pool =
+	host_dev->request_pool =
 				kmem_cache_create(dev_name(&device->device),
 					sizeof(struct storvsc_cmd_request), 0,
 					SLAB_HWCACHE_ALIGN, NULL);
 
-	if (!host_device_ctx->request_pool) {
+	if (!host_dev->request_pool) {
 		scsi_host_put(host);
 		return -ENOMEM;
 	}
@@ -363,14 +363,14 @@ static int storvsc_probe(struct hv_device *device)
 
 	if (ret != 0) {
 		DPRINT_ERR(STORVSC_DRV, "unable to add scsi vsc device");
-		kmem_cache_destroy(host_device_ctx->request_pool);
+		kmem_cache_destroy(host_dev->request_pool);
 		scsi_host_put(host);
 		return -1;
 	}
 
 	/* host_device_ctx->port = device_info.PortNumber; */
-	host_device_ctx->path = device_info.path_id;
-	host_device_ctx->target = device_info.target_id;
+	host_dev->path = device_info.path_id;
+	host_dev->target = device_info.target_id;
 
 	/* max # of devices per target */
 	host->max_lun = STORVSC_MAX_LUNS_PER_TARGET;
@@ -386,7 +386,7 @@ static int storvsc_probe(struct hv_device *device)
 
 		storvsc_drv_obj->base.dev_rm(device);
 
-		kmem_cache_destroy(host_device_ctx->request_pool);
+		kmem_cache_destroy(host_dev->request_pool);
 		scsi_host_put(host);
 		return -1;
 	}
@@ -403,7 +403,7 @@ static int storvsc_remove(struct hv_device *dev)
 	struct storvsc_driver *storvsc_drv_obj =
 			 drv_to_stordrv(dev->device.driver);
 	struct Scsi_Host *host = dev_get_drvdata(&dev->device);
-	struct hv_host_device *host_device_ctx =
+	struct hv_host_device *host_dev =
 			(struct hv_host_device *)host->hostdata;
 
 	/*
@@ -412,9 +412,9 @@ static int storvsc_remove(struct hv_device *dev)
 	 */
 	storvsc_drv_obj->base.dev_rm(dev);
 
-	if (host_device_ctx->request_pool) {
-		kmem_cache_destroy(host_device_ctx->request_pool);
-		host_device_ctx->request_pool = NULL;
+	if (host_dev->request_pool) {
+		kmem_cache_destroy(host_dev->request_pool);
+		host_dev->request_pool = NULL;
 	}
 
 	DPRINT_INFO(STORVSC, "removing host adapter (%p)...", host);
@@ -433,7 +433,7 @@ static void storvsc_commmand_completion(struct hv_storvsc_request *request)
 	struct storvsc_cmd_request *cmd_request =
 		(struct storvsc_cmd_request *)request->context;
 	struct scsi_cmnd *scmnd = cmd_request->cmd;
-	struct hv_host_device *host_device_ctx =
+	struct hv_host_device *host_dev =
 		(struct hv_host_device *)scmnd->device->host->hostdata;
 	void (*scsi_done_fn)(struct scsi_cmnd *);
 	struct scsi_sense_hdr sense_hdr;
@@ -479,7 +479,7 @@ static void storvsc_commmand_completion(struct hv_storvsc_request *request)
 	/* !!DO NOT MODIFY the scmnd after this call */
 	scsi_done_fn(scmnd);
 
-	kmem_cache_free(host_device_ctx->request_pool, cmd_request);
+	kmem_cache_free(host_dev->request_pool, cmd_request);
 }
 
 static int do_bounce_buffer(struct scatterlist *sgl, unsigned int sg_count)
@@ -683,9 +683,9 @@ static int storvsc_queuecommand_lck(struct scsi_cmnd *scmnd,
 				void (*done)(struct scsi_cmnd *))
 {
 	int ret;
-	struct hv_host_device *host_device_ctx =
+	struct hv_host_device *host_dev =
 		(struct hv_host_device *)scmnd->device->host->hostdata;
-	struct hv_device *device_ctx = host_device_ctx->device_ctx;
+	struct hv_device *device_ctx = host_dev->device_ctx;
 	struct storvsc_driver *storvsc_drv_obj =
 		drv_to_stordrv(device_ctx->device.driver);
 	struct hv_storvsc_request *request;
@@ -721,7 +721,7 @@ static int storvsc_queuecommand_lck(struct scsi_cmnd *scmnd,
 
 	request_size = sizeof(struct storvsc_cmd_request);
 
-	cmd_request = kmem_cache_zalloc(host_device_ctx->request_pool,
+	cmd_request = kmem_cache_zalloc(host_dev->request_pool,
 				       GFP_ATOMIC);
 	if (!cmd_request) {
 		DPRINT_ERR(STORVSC_DRV, "scmnd (%p) - unable to allocate "
@@ -759,7 +759,7 @@ static int storvsc_queuecommand_lck(struct scsi_cmnd *scmnd,
 	request->context = cmd_request;/* scmnd; */
 
 	/* request->PortId = scmnd->device->channel; */
-	vm_srb->port_number = host_device_ctx->port;
+	vm_srb->port_number = host_dev->port;
 	vm_srb->path_id = scmnd->device->channel;
 	vm_srb->target_id = scmnd->device->id;
 	vm_srb->lun = scmnd->device->lun;
@@ -792,7 +792,7 @@ static int storvsc_queuecommand_lck(struct scsi_cmnd *scmnd,
 
 				scmnd->scsi_done = NULL;
 				scmnd->host_scribble = NULL;
-				kmem_cache_free(host_device_ctx->request_pool,
+				kmem_cache_free(host_dev->request_pool,
 						cmd_request);
 
 				return SCSI_MLQUEUE_HOST_BUSY;
@@ -851,7 +851,7 @@ retry_request:
 					      cmd_request->bounce_sgl_count);
 		}
 
-		kmem_cache_free(host_device_ctx->request_pool, cmd_request);
+		kmem_cache_free(host_dev->request_pool, cmd_request);
 
 		scmnd->scsi_done = NULL;
 		scmnd->host_scribble = NULL;
@@ -916,9 +916,9 @@ static int storvsc_device_configure(struct scsi_device *sdevice)
 static int storvsc_host_reset_handler(struct scsi_cmnd *scmnd)
 {
 	int ret;
-	struct hv_host_device *host_device_ctx =
+	struct hv_host_device *host_dev =
 		(struct hv_host_device *)scmnd->device->host->hostdata;
-	struct hv_device *device_ctx = host_device_ctx->device_ctx;
+	struct hv_device *device_ctx = host_dev->device_ctx;
 
 	DPRINT_INFO(STORVSC_DRV, "sdev (%p) dev obj (%p) - host resetting...",
 		    scmnd->device, device_ctx);
-- 
1.7.4.1

