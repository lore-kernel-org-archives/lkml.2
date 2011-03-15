Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758918Ab1COVyg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 17:54:36 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:33815
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758792Ab1COVxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 17:53:48 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Mike Sterling <mike.sterling@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 10/12] Staging: hv: Get rid of the forward declaration for vmbus_device_release
Date: Tue, 15 Mar 2011 15:03:42 -0700
Message-Id: <1300226624-27004-11-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
In-Reply-To: <1300226624-27004-10-git-send-email-kys@microsoft.com>
References: <1300226527-26933-1-git-send-email-kys@microsoft.com>
 <1300226624-27004-1-git-send-email-kys@microsoft.com>
 <1300226624-27004-2-git-send-email-kys@microsoft.com>
 <1300226624-27004-3-git-send-email-kys@microsoft.com>
 <1300226624-27004-4-git-send-email-kys@microsoft.com>
 <1300226624-27004-5-git-send-email-kys@microsoft.com>
 <1300226624-27004-6-git-send-email-kys@microsoft.com>
 <1300226624-27004-7-git-send-email-kys@microsoft.com>
 <1300226624-27004-8-git-send-email-kys@microsoft.com>
 <1300226624-27004-9-git-send-email-kys@microsoft.com>
 <1300226624-27004-10-git-send-email-kys@microsoft.com>
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
index 671632c..976175b 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -50,8 +50,6 @@ struct hv_bus {
 
 static irqreturn_t vmbus_isr(int irq, void *dev_id);
 
-static void vmbus_device_release(struct device *device);
-
 static ssize_t vmbus_show_device_attr(struct device *dev,
 				      struct device_attribute *dev_attr,
 				      char *buf);
@@ -297,6 +295,18 @@ static void vmbus_shutdown(struct device *child_device)
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
@@ -826,19 +836,6 @@ void vmbus_child_device_unregister(struct hv_device *device_obj)
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

