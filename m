Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932307Ab1EIWId (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 18:08:33 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:48614
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752495Ab1EIVoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:44:44 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 033/206] Staging: hv: Rename struct host_device_context
Date: Mon,  9 May 2011 14:55:15 -0700
Message-Id: <1304978288-22999-33-git-send-email-kys@microsoft.com>
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
 drivers/staging/hv/storvsc_drv.c |   27 ++++++++++++++-------------
 1 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index d19df02..2411f53 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -17,6 +17,7 @@
  * Authors:
  *   Haiyang Zhang <haiyangz@microsoft.com>
  *   Hank Janssen  <hjanssen@microsoft.com>
+ *   K. Y. Srinivasan <kys@microsoft.com>
  */
 #include <linux/init.h>
 #include <linux/slab.h>
@@ -50,7 +51,7 @@ static const struct hv_guid gStorVscDeviceType = {
 	}
 };
 
-struct host_device_context {
+struct hv_host_device {
 	/* must be 1st field
 	 * FIXME this is a bug */
 	/* point back to our device context */
@@ -325,14 +326,14 @@ static int storvsc_probe(struct hv_device *device)
 	struct storvsc_driver *storvsc_drv_obj =
 		 drv_to_stordrv(device->device.driver);
 	struct Scsi_Host *host;
-	struct host_device_context *host_device_ctx;
+	struct hv_host_device *host_device_ctx;
 	struct storvsc_device_info device_info;
 
 	if (!storvsc_drv_obj->base.dev_add)
 		return -1;
 
 	host = scsi_host_alloc(&scsi_driver,
-			       sizeof(struct host_device_context));
+			       sizeof(struct hv_host_device));
 	if (!host) {
 		DPRINT_ERR(STORVSC_DRV, "unable to allocate scsi host object");
 		return -ENOMEM;
@@ -340,8 +341,8 @@ static int storvsc_probe(struct hv_device *device)
 
 	dev_set_drvdata(&device->device, host);
 
-	host_device_ctx = (struct host_device_context *)host->hostdata;
-	memset(host_device_ctx, 0, sizeof(struct host_device_context));
+	host_device_ctx = (struct hv_host_device *)host->hostdata;
+	memset(host_device_ctx, 0, sizeof(struct hv_host_device));
 
 	host_device_ctx->port = host->host_no;
 	host_device_ctx->device_ctx = device;
@@ -402,8 +403,8 @@ static int storvsc_remove(struct hv_device *dev)
 	struct storvsc_driver *storvsc_drv_obj =
 			 drv_to_stordrv(dev->device.driver);
 	struct Scsi_Host *host = dev_get_drvdata(&dev->device);
-	struct host_device_context *host_device_ctx =
-			(struct host_device_context *)host->hostdata;
+	struct hv_host_device *host_device_ctx =
+			(struct hv_host_device *)host->hostdata;
 
 	/*
 	 * Call to the vsc driver to let it know that the device is being
@@ -432,8 +433,8 @@ static void storvsc_commmand_completion(struct hv_storvsc_request *request)
 	struct storvsc_cmd_request *cmd_request =
 		(struct storvsc_cmd_request *)request->context;
 	struct scsi_cmnd *scmnd = cmd_request->cmd;
-	struct host_device_context *host_device_ctx =
-		(struct host_device_context *)scmnd->device->host->hostdata;
+	struct hv_host_device *host_device_ctx =
+		(struct hv_host_device *)scmnd->device->host->hostdata;
 	void (*scsi_done_fn)(struct scsi_cmnd *);
 	struct scsi_sense_hdr sense_hdr;
 	struct vmscsi_request *vm_srb;
@@ -682,8 +683,8 @@ static int storvsc_queuecommand_lck(struct scsi_cmnd *scmnd,
 				void (*done)(struct scsi_cmnd *))
 {
 	int ret;
-	struct host_device_context *host_device_ctx =
-		(struct host_device_context *)scmnd->device->host->hostdata;
+	struct hv_host_device *host_device_ctx =
+		(struct hv_host_device *)scmnd->device->host->hostdata;
 	struct hv_device *device_ctx = host_device_ctx->device_ctx;
 	struct storvsc_driver *storvsc_drv_obj =
 		drv_to_stordrv(device_ctx->device.driver);
@@ -915,8 +916,8 @@ static int storvsc_device_configure(struct scsi_device *sdevice)
 static int storvsc_host_reset_handler(struct scsi_cmnd *scmnd)
 {
 	int ret;
-	struct host_device_context *host_device_ctx =
-		(struct host_device_context *)scmnd->device->host->hostdata;
+	struct hv_host_device *host_device_ctx =
+		(struct hv_host_device *)scmnd->device->host->hostdata;
 	struct hv_device *device_ctx = host_device_ctx->device_ctx;
 
 	DPRINT_INFO(STORVSC_DRV, "sdev (%p) dev obj (%p) - host resetting...",
-- 
1.7.4.1

