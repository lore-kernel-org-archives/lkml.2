Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111Ab1EIWHp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 18:07:45 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:54124
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753272Ab1EIVop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:44:45 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 035/206] Staging: hv: Rename the struct hv_device * element of struct hv_host_device
Date: Mon,  9 May 2011 14:55:17 -0700
Message-Id: <1304978288-22999-35-git-send-email-kys@microsoft.com>
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
 drivers/staging/hv/storvsc_drv.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 2e2e004..c183220 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -55,7 +55,7 @@ struct hv_host_device {
 	/* must be 1st field
 	 * FIXME this is a bug */
 	/* point back to our device context */
-	struct hv_device *device_ctx;
+	struct hv_device *dev;
 	struct kmem_cache *request_pool;
 	unsigned int port;
 	unsigned char path;
@@ -345,7 +345,7 @@ static int storvsc_probe(struct hv_device *device)
 	memset(host_dev, 0, sizeof(struct hv_host_device));
 
 	host_dev->port = host->host_no;
-	host_dev->device_ctx = device;
+	host_dev->dev = device;
 
 	host_dev->request_pool =
 				kmem_cache_create(dev_name(&device->device),
@@ -685,7 +685,7 @@ static int storvsc_queuecommand_lck(struct scsi_cmnd *scmnd,
 	int ret;
 	struct hv_host_device *host_dev =
 		(struct hv_host_device *)scmnd->device->host->hostdata;
-	struct hv_device *device_ctx = host_dev->device_ctx;
+	struct hv_device *device_ctx = host_dev->dev;
 	struct storvsc_driver *storvsc_drv_obj =
 		drv_to_stordrv(device_ctx->device.driver);
 	struct hv_storvsc_request *request;
@@ -918,7 +918,7 @@ static int storvsc_host_reset_handler(struct scsi_cmnd *scmnd)
 	int ret;
 	struct hv_host_device *host_dev =
 		(struct hv_host_device *)scmnd->device->host->hostdata;
-	struct hv_device *device_ctx = host_dev->device_ctx;
+	struct hv_device *device_ctx = host_dev->dev;
 
 	DPRINT_INFO(STORVSC_DRV, "sdev (%p) dev obj (%p) - host resetting...",
 		    scmnd->device, device_ctx);
-- 
1.7.4.1

