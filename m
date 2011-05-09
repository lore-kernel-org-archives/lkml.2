Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496Ab1EJJzR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 05:55:17 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:41728
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754529Ab1EJJyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 05:54:09 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 161/206] Staging: hv: Include the contents of vmbus.h
Date: Mon,  9 May 2011 14:57:23 -0700
Message-Id: <1304978288-22999-161-git-send-email-kys@microsoft.com>
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
 include/linux/hyperv.h |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index 3707fcb..2751b10 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -821,4 +821,26 @@ struct hv_device {
 	void *ext;
 };
 
+#include <linux/device.h>
+
+
+
+
+static inline struct hv_device *device_to_hv_device(struct device *d)
+{
+	return container_of(d, struct hv_device, device);
+}
+
+static inline struct hv_driver *drv_to_hv_drv(struct device_driver *d)
+{
+	return container_of(d, struct hv_driver, driver);
+}
+
+
+int vmbus_child_driver_register(struct device_driver *drv);
+void vmbus_child_driver_unregister(struct device_driver *drv);
+
+extern struct completion hv_channel_ready;
+
+
 #endif /* _HYPERV_H_ */
-- 
1.7.4.1

