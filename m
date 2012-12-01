Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234Ab2LAOZ7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 09:25:59 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:47247
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752122Ab2LAOXk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 09:23:40 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 10/28] Drivers: hv: Save and export negotiated vmbus version
Date: Sat,  1 Dec 2012 06:46:41 -0800
Message-Id: <1354373219-31374-10-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1354373219-31374-1-git-send-email-kys@microsoft.com>
References: <1354373160-31332-1-git-send-email-kys@microsoft.com>
 <1354373219-31374-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export the negotiated vmbus version as this may be useful for
individual drivers.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/hv/connection.c |    9 +++++++++
 include/linux/hyperv.h  |    6 ++++++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index 2b56a3f..70ea5d1 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -30,6 +30,7 @@
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 #include <linux/hyperv.h>
+#include <linux/export.h>
 #include <asm/hyperv.h>
 #include "hyperv_vmbus.h"
 
@@ -54,6 +55,12 @@ struct vmbus_connection vmbus_connection = {
 
 #define VERSION_INVAL -1
 
+/*
+ * Negotiated protocol version with the host.
+ */
+__u32 vmbus_proto_version;
+EXPORT_SYMBOL_GPL(vmbus_proto_version);
+
 static __u32 vmbus_get_next_version(__u32 current_version)
 {
 	switch (current_version) {
@@ -215,6 +222,8 @@ int vmbus_connect(void)
 	if (version == VERSION_INVAL)
 		goto cleanup;
 
+	vmbus_proto_version = version;
+	pr_info("Negotiated host information %d\n", version);
 	kfree(msginfo);
 	return 0;
 
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index bee559a..134a202 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -1204,5 +1204,11 @@ int hv_kvp_init(struct hv_util_service *);
 void hv_kvp_deinit(void);
 void hv_kvp_onchannelcallback(void *);
 
+/*
+ * Negotiated version with the Host.
+ */
+
+extern __u32 vmbus_proto_version;
+
 #endif /* __KERNEL__ */
 #endif /* _HYPERV_H */
-- 
1.7.4.1

