Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885Ab1IMRiO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 13:38:14 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:41803
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755827Ab1IMRiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 13:38:12 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 01/20] Staging: hv: vmbus: Introduce a utility function to match hv_vmbus_device_id
Date: Tue, 13 Sep 2011 10:59:37 -0700
Message-Id: <1315936796-20662-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315936759-20623-1-git-send-email-kys@microsoft.com>
References: <1315936759-20623-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a utility function to match hv_vmbus_device_id.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/vmbus_drv.c |   23 ++++++++++++++++++-----
 1 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index 375e451..77f4373 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -272,6 +272,22 @@ static inline bool is_null_guid(const __u8 *guid)
 	return true;
 }
 
+/*
+ * Return a matching hv_vmbus_device_id pointer.
+ * If there is no match, return NULL.
+ */
+static const struct hv_vmbus_device_id *hv_vmbus_get_id(
+					const struct hv_vmbus_device_id *id,
+					__u8 *guid)
+{
+	for (; !is_null_guid(id->guid); id++)
+		if (!memcmp(&id->guid, guid, sizeof(uuid_le)))
+			return id;
+
+	return NULL;
+}
+
+
 
 /*
  * vmbus_match - Attempt to match the specified device to the specified driver
@@ -280,12 +296,9 @@ static int vmbus_match(struct device *device, struct device_driver *driver)
 {
 	struct hv_driver *drv = drv_to_hv_drv(driver);
 	struct hv_device *hv_dev = device_to_hv_device(device);
-	const struct hv_vmbus_device_id *id_array = drv->id_table;
 
-	for (; !is_null_guid(id_array->guid); id_array++)
-		if (!memcmp(&id_array->guid, &hv_dev->dev_type.b,
-				sizeof(uuid_le)))
-			return 1;
+	if (hv_vmbus_get_id(drv->id_table, hv_dev->dev_type.b))
+		return 1;
 
 	return 0;
 }
-- 
1.7.4.1

