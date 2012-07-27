Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335Ab2G0EDR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 00:03:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39284 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775Ab2G0EDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 00:03:14 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: gregkh@linuxfoundation.org, ccross@android.com, hmh@hmh.eng.br,
        rpurdie@rpsys.net, linux-kernel@vger.kernel.org,
        linux-leds@vger.kernel.org
Subject: [PATCH 2/3] drivers: add a new device_create_file_uevent API
Date: Fri, 27 Jul 2012 12:02:42 +0800
Message-Id: <1343361763-10307-3-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.11.1
In-Reply-To: <1343361763-10307-1-git-send-email-bryan.wu@canonical.com>
References: <1343361763-10307-1-git-send-email-bryan.wu@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will use sysfs_create_file_uevent to create a sysfs file and send out
a uevent to userspace application such as udev.

Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
---
 drivers/base/core.c    | 19 +++++++++++++++++++
 include/linux/device.h |  4 ++++
 2 files changed, 23 insertions(+)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 346be8b..62fd266 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -538,6 +538,25 @@ int device_create_file(struct device *dev,
 }
 
 /**
+ * device_create_file_uevent - create sysfs attribute file for device
+ *				and send a uevent to userspace.
+ * @dev: device.
+ * @attr: device attribute descriptor.
+ * @desc: description about the uevent.
+ * @action: kobject uevent action type.
+ */
+int device_create_file_uevent(struct device *dev,
+		       const struct device_attribute *attr,
+		       const char *desc,
+		       enum kobject_action action)
+{
+	int error = 0;
+	if (dev)
+		error = sysfs_create_file_uevent(&dev->kobj, &attr->attr,
+						 desc, action);
+	return error;
+}
+/**
  * device_remove_file - remove sysfs attribute file.
  * @dev: device.
  * @attr: device attribute descriptor.
diff --git a/include/linux/device.h b/include/linux/device.h
index 6de9415..d1545f3 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -510,6 +510,10 @@ ssize_t device_store_int(struct device *dev, struct device_attribute *attr,
 
 extern int device_create_file(struct device *device,
 			      const struct device_attribute *entry);
+extern int device_create_file_uevent(struct device *dev,
+				const struct device_attribute *attr,
+			       const char *desc,
+			       enum kobject_action action);
 extern void device_remove_file(struct device *dev,
 			       const struct device_attribute *attr);
 extern int __must_check device_create_bin_file(struct device *dev,
-- 
1.7.11.1

