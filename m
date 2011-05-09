Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932169Ab1EIWBK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 18:01:10 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:54207
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754930Ab1EIVos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:44:48 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 062/206] Staging: hv: Get rid of the indirection in invoking storvsc_dev_remove()
Date: Mon,  9 May 2011 14:55:44 -0700
Message-Id: <1304978288-22999-62-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of the indirection in invoking storvsc_dev_remove()

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/storvsc_drv.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 650e11f..233aa4c 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -359,8 +359,6 @@ static unsigned int copy_to_bounce_buffer(struct scatterlist *orig_sgl,
  */
 static int storvsc_remove(struct hv_device *dev)
 {
-	struct storvsc_driver *storvsc_drv_obj =
-			 drv_to_stordrv(dev->device.driver);
 	struct Scsi_Host *host = dev_get_drvdata(&dev->device);
 	struct hv_host_device *host_dev =
 			(struct hv_host_device *)host->hostdata;
@@ -369,7 +367,7 @@ static int storvsc_remove(struct hv_device *dev)
 	 * Call to the vsc driver to let it know that the device is being
 	 * removed
 	 */
-	storvsc_drv_obj->base.dev_rm(dev);
+	storvsc_dev_remove(dev);
 
 	if (host_dev->request_pool) {
 		kmem_cache_destroy(host_dev->request_pool);
@@ -842,7 +840,7 @@ static int storvsc_probe(struct hv_device *device)
 	ret = scsi_add_host(host, &device->device);
 	if (ret != 0) {
 
-		storvsc_drv_obj->base.dev_rm(device);
+		storvsc_dev_remove(device);
 
 		kmem_cache_destroy(host_dev->request_pool);
 		scsi_host_put(host);
-- 
1.7.4.1

