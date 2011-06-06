Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758328Ab1FFWix (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 18:38:53 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:58082
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758200Ab1FFWfD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 18:35:03 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>
Subject: [PATCH 40/49] Staging: hv: vmbus: Rename local variables in vmbus_drv.c
Date: Mon,  6 Jun 2011 15:50:04 -0700
Message-Id: <1307400613-13234-40-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1307400613-13234-1-git-send-email-kys@microsoft.com>
References: <1307400540-13193-1-git-send-email-kys@microsoft.com>
 <1307400613-13234-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename local variables in vmbus_drv.c.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
---
 drivers/staging/hv/vmbus_drv.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index 921ca9a..17692ce 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -107,12 +107,12 @@ static ssize_t vmbus_show_device_attr(struct device *dev,
 				      struct device_attribute *dev_attr,
 				      char *buf)
 {
-	struct hv_device *device_ctx = device_to_hv_device(dev);
+	struct hv_device *hv_dev = device_to_hv_device(dev);
 	struct hv_device_info device_info;
 
 	memset(&device_info, 0, sizeof(struct hv_device_info));
 
-	get_channel_info(device_ctx, &device_info);
+	get_channel_info(hv_dev, &device_info);
 
 	if (!strcmp(dev_attr->attr.name, "class_id")) {
 		return sprintf(buf, "{%02x%02x%02x%02x-%02x%02x-%02x%02x-"
@@ -300,10 +300,10 @@ static int vmbus_match(struct device *device, struct device_driver *driver)
 {
 	int match = 0;
 	struct hv_driver *drv = drv_to_hv_drv(driver);
-	struct hv_device *device_ctx = device_to_hv_device(device);
+	struct hv_device *hv_dev = device_to_hv_device(device);
 
 	/* We found our driver ? */
-	if (memcmp(&device_ctx->dev_type, &drv->dev_type,
+	if (memcmp(&hv_dev->dev_type, &drv->dev_type,
 		   sizeof(struct hv_guid)) == 0)
 		match = 1;
 
@@ -387,9 +387,9 @@ static void vmbus_shutdown(struct device *child_device)
  */
 static void vmbus_device_release(struct device *device)
 {
-	struct hv_device *device_ctx = device_to_hv_device(device);
+	struct hv_device *hv_dev = device_to_hv_device(device);
 
-	kfree(device_ctx);
+	kfree(hv_dev);
 
 }
 
-- 
1.7.4.1

