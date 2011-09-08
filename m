Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933160Ab1IHOEH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 10:04:07 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:40603
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933089Ab1IHODQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 10:03:16 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 02/25] Staging: hv: vmbus: Rename vmbus_child_device_register
Date: Thu,  8 Sep 2011 07:24:13 -0700
Message-Id: <1315491876-9554-2-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315491876-9554-1-git-send-email-kys@microsoft.com>
References: <1315491843-9513-1-git-send-email-kys@microsoft.com>
 <1315491876-9554-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The vmbus devices are NOT child devices; rename vmbus_child_device_register
to reflect this.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/channel_mgmt.c |    2 +-
 drivers/staging/hv/hyperv_vmbus.h |    2 +-
 drivers/staging/hv/vmbus_drv.c    |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/hv/channel_mgmt.c b/drivers/staging/hv/channel_mgmt.c
index f99b944..a927046 100644
--- a/drivers/staging/hv/channel_mgmt.c
+++ b/drivers/staging/hv/channel_mgmt.c
@@ -393,7 +393,7 @@ static void vmbus_process_offer(struct work_struct *work)
 	 * binding which eventually invokes the device driver's AddDevice()
 	 * method.
 	 */
-	ret = vmbus_child_device_register(newchannel->device_obj);
+	ret = vmbus_device_register(newchannel->device_obj);
 	if (ret != 0) {
 		pr_err("unable to add child device object (relid %d)\n",
 			   newchannel->offermsg.child_relid);
diff --git a/drivers/staging/hv/hyperv_vmbus.h b/drivers/staging/hv/hyperv_vmbus.h
index e97e2cf..b2dfcd6 100644
--- a/drivers/staging/hv/hyperv_vmbus.h
+++ b/drivers/staging/hv/hyperv_vmbus.h
@@ -605,7 +605,7 @@ struct hv_device *vmbus_device_create(uuid_le *type,
 					 uuid_le *instance,
 					 struct vmbus_channel *channel);
 
-int vmbus_child_device_register(struct hv_device *child_device_obj);
+int vmbus_device_register(struct hv_device *child_device_obj);
 void vmbus_child_device_unregister(struct hv_device *device_obj);
 
 /* static void */
diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index 382baee..6d54ea1 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -619,9 +619,9 @@ struct hv_device *vmbus_device_create(uuid_le *type,
 }
 
 /*
- * vmbus_child_device_register - Register the child device
+ * vmbus_device_register - Register the child device
  */
-int vmbus_child_device_register(struct hv_device *child_device_obj)
+int vmbus_device_register(struct hv_device *child_device_obj)
 {
 	int ret = 0;
 
-- 
1.7.4.1

