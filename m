Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870Ab1DFW4e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 18:56:34 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:52190
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756626Ab1DFWyF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 18:54:05 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 14/22] Staging: hv: Cleanup storvsc_remove()
Date: Wed,  6 Apr 2011 16:05:14 -0700
Message-Id: <1302131122-15530-14-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1302131122-15530-1-git-send-email-kys@microsoft.com>
References: <1302131006-15411-1-git-send-email-kys@microsoft.com>
 <1302131122-15530-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

storvsc_remove() cannot fail, clean it up accordingly.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/storvsc_drv.c |   14 ++------------
 1 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index ae61735..f819c6a 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -404,7 +404,6 @@ static int storvsc_probe(struct device *device)
  */
 static int storvsc_remove(struct device *device)
 {
-	int ret;
 	struct hv_driver *drv =
 			drv_to_hv_drv(device->driver);
 	struct storvsc_driver_object *storvsc_drv_obj = drv->priv;
@@ -413,20 +412,11 @@ static int storvsc_remove(struct device *device)
 	struct host_device_context *host_device_ctx =
 			(struct host_device_context *)host->hostdata;
 
-
-	if (!storvsc_drv_obj->base.dev_rm)
-		return -1;
-
 	/*
 	 * Call to the vsc driver to let it know that the device is being
 	 * removed
 	 */
-	ret = storvsc_drv_obj->base.dev_rm(device_obj);
-	if (ret != 0) {
-		/* TODO: */
-		DPRINT_ERR(STORVSC, "unable to remove vsc device (ret %d)",
-			   ret);
-	}
+	storvsc_drv_obj->base.dev_rm(device_obj);
 
 	if (host_device_ctx->request_pool) {
 		kmem_cache_destroy(host_device_ctx->request_pool);
@@ -438,7 +428,7 @@ static int storvsc_remove(struct device *device)
 
 	DPRINT_INFO(STORVSC, "releasing host adapter (%p)...", host);
 	scsi_host_put(host);
-	return ret;
+	return 0;
 }
 
 /*
-- 
1.7.4.1

