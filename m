Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709Ab1CJWFu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 17:05:50 -0500
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:45737
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752625Ab1CJWFt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 17:05:49 -0500
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: kys@microsoft.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Cc: Haiyang Zhang <haiyangz@microsoft.com>,
        Mike Sterling <mike.sterling@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 19/21] Staging: hv: Get rid of the forward declaration for vmbus_device_release
Date: Thu, 10 Mar 2011 14:15:26 -0800
Message-Id: <1299795326-1563-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
In-Reply-To: <[PATCH 00/21] Staging: hv: Cleanup vmbus driver>
References: <[PATCH 00/21] Staging: hv: Cleanup vmbus driver>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of the forward declaration of vmbus_device_release by moving
the code around.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Mike Sterling <mike.sterling@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/vmbus_drv.c |   27 ++++++++++++---------------
 1 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index 6f4094b..7c16acd 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -53,8 +53,6 @@ struct hv_bus {
 
 static irqreturn_t vmbus_isr(int irq, void *dev_id);
 
-static void vmbus_device_release(struct device *device);
-
 static ssize_t vmbus_show_device_attr(struct device *dev,
 				      struct device_attribute *dev_attr,
 				      char *buf);
@@ -300,6 +298,18 @@ static void vmbus_shutdown(struct device *child_device)
 	return;
 }
 
+
+/*
+ * vmbus_device_release - Final callback release of the vmbus child device
+ */
+static void vmbus_device_release(struct device *device)
+{
+	struct hv_device *device_ctx = device_to_hv_device(device);
+
+	kfree(device_ctx);
+
+}
+
 /* The one and only one */
 static struct hv_bus  hv_bus = {
 	.bus.name =		"vmbus",
@@ -848,19 +858,6 @@ void vmbus_child_device_unregister(struct hv_device *device_obj)
 }
 
 
-/*
- * vmbus_device_release - Final callback release of the vmbus child device
- */
-static void vmbus_device_release(struct device *device)
-{
-	struct hv_device *device_ctx = device_to_hv_device(device);
-
-	kfree(device_ctx);
-
-	/* !!DO NOT REFERENCE device_ctx anymore at this point!! */
-}
-
-
 
 static irqreturn_t vmbus_isr(int irq, void *dev_id)
 {
-- 
1.5.5.6

