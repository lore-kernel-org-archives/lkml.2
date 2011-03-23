Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048Ab1CWRkg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 13:40:36 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:42206
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755639Ab1CWRkc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 13:40:32 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 02/16] Staging: hv: Move the definition of struct storvsc_request_extension
Date: Wed, 23 Mar 2011 10:50:20 -0700
Message-Id: <1300902635-1347-2-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300902635-1347-1-git-send-email-kys@microsoft.com>
References: <1300902537-1290-1-git-send-email-kys@microsoft.com>
 <1300902635-1347-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for getting rid of the inclusion of storvsc.c from
blkvsc.c, move the definition of struct storvsc_request_extension
from storvsc.c to storvsc_api.h.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc.c      |    1 +
 drivers/staging/hv/storvsc.c     |   13 -------------
 drivers/staging/hv/storvsc_api.h |   12 ++++++++++++
 3 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/hv/blkvsc.c b/drivers/staging/hv/blkvsc.c
index 7c8729b..88d6e3c 100644
--- a/drivers/staging/hv/blkvsc.c
+++ b/drivers/staging/hv/blkvsc.c
@@ -24,6 +24,7 @@
 #include <linux/mm.h>
 #include "hv_api.h"
 #include "storvsc.c"
+#include "storvsc_api.h"
 
 static const char *g_blk_driver_name = "blkvsc";
 
diff --git a/drivers/staging/hv/storvsc.c b/drivers/staging/hv/storvsc.c
index e2ad729..56f3cc9 100644
--- a/drivers/staging/hv/storvsc.c
+++ b/drivers/staging/hv/storvsc.c
@@ -33,19 +33,6 @@
 #include "channel.h"
 
 
-struct storvsc_request_extension {
-	/* LIST_ENTRY ListEntry; */
-
-	struct hv_storvsc_request *request;
-	struct hv_device *device;
-
-	/* Synchronize the request/response if needed */
-	int wait_condition;
-	wait_queue_head_t wait_event;
-
-	struct vstor_packet vstor_packet;
-};
-
 /* A storvsc device is a device object that contains a vmbus channel */
 struct storvsc_device {
 	struct hv_device *device;
diff --git a/drivers/staging/hv/storvsc_api.h b/drivers/staging/hv/storvsc_api.h
index fbf5755..629144c 100644
--- a/drivers/staging/hv/storvsc_api.h
+++ b/drivers/staging/hv/storvsc_api.h
@@ -25,6 +25,7 @@
 #ifndef _STORVSC_API_H_
 #define _STORVSC_API_H_
 
+#include "vstorage.h"
 #include "vmbus_api.h"
 
 /* Defines */
@@ -102,6 +103,17 @@ struct storvsc_device_info {
 	unsigned char target_id;
 };
 
+struct storvsc_request_extension {
+	struct hv_storvsc_request *request;
+	struct hv_device *device;
+
+	/* Synchronize the request/response if needed */
+	int wait_condition;
+	wait_queue_head_t wait_event;
+
+	struct vstor_packet vstor_packet;
+};
+
 /* Interface */
 int stor_vsc_initialize(struct hv_driver *driver);
 int stor_vsc_on_host_reset(struct hv_device *device);
-- 
1.7.4.1

