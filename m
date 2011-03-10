Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158Ab1CJV5p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 16:57:45 -0500
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:37774
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752780Ab1CJV5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 16:57:44 -0500
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: kys@microsoft.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Cc: Haiyang Zhang <haiyangz@microsoft.com>,
        Mike Sterling <mike.sterling@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 08/21] Staging: hv: Change the signature for vmbus_child_device_register()
Date: Thu, 10 Mar 2011 14:07:21 -0800
Message-Id: <1299794841-1123-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
In-Reply-To: <[PATCH 00/21] Staging: hv: Cleanup vmbus driver>
References: <[PATCH 00/21] Staging: hv: Cleanup vmbus driver>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for getting rid of the vmbus_child_dev_add() function,
modify the signature of vmbus_child_device_register(). Note that
the root device is a global variable.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Mike Sterling <mike.sterling@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/vmbus_drv.c     |    7 +++----
 drivers/staging/hv/vmbus_private.h |    3 +--
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index e078c59..0b91eda 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -144,7 +144,7 @@ static struct hv_device *vmbus_device; /* vmbus root device */
  */
 int vmbus_child_dev_add(struct hv_device *child_dev)
 {
-	return vmbus_child_device_register(vmbus_device, child_dev);
+	return vmbus_child_device_register(child_dev);
 }
 
 /*
@@ -664,8 +664,7 @@ struct hv_device *vmbus_child_device_create(struct hv_guid *type,
 /*
  * vmbus_child_device_register - Register the child device on the specified bus
  */
-int vmbus_child_device_register(struct hv_device *root_device_obj,
-				struct hv_device *child_device_obj)
+int vmbus_child_device_register(struct hv_device *child_device_obj)
 {
 	int ret = 0;
 
@@ -680,7 +679,7 @@ int vmbus_child_device_register(struct hv_device *root_device_obj,
 
 	/* The new device belongs to this bus */
 	child_device_obj->device.bus = &vmbus_drv.bus; /* device->dev.bus; */
-	child_device_obj->device.parent = &root_device_obj->device;
+	child_device_obj->device.parent = &vmbus_device->device;
 	child_device_obj->device.release = vmbus_device_release;
 
 	/*
diff --git a/drivers/staging/hv/vmbus_private.h b/drivers/staging/hv/vmbus_private.h
index 1b88b6f..c176773 100644
--- a/drivers/staging/hv/vmbus_private.h
+++ b/drivers/staging/hv/vmbus_private.h
@@ -108,8 +108,7 @@ struct hv_device *vmbus_child_device_create(struct hv_guid *type,
 					 struct vmbus_channel *channel);
 
 int vmbus_child_dev_add(struct hv_device *device);
-int vmbus_child_device_register(struct hv_device *root_device_obj,
-				struct hv_device *child_device_obj);
+int vmbus_child_device_register(struct hv_device *child_device_obj);
 void vmbus_child_device_unregister(struct hv_device *device_obj);
 
 /* static void */
-- 
1.5.5.6

