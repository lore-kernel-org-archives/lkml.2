Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962Ab1C1QZo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 12:25:44 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:51630
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754781Ab1C1QXD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 12:23:03 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 01/20] Staging: hv: Move the definition of struct storvsc_request_extension
Date: Mon, 28 Mar 2011 09:33:26 -0700
Message-Id: <1301330025-25542-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1301329950-25490-1-git-send-email-kys@microsoft.com>
References: <1301329950-25490-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preperation for embedding struct storvsc_request_extension into
struct hv_storvsc_request, move the definition of
struct storvsc_request_extension.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/storvsc_api.h |   23 ++++++++++++-----------
 1 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/hv/storvsc_api.h b/drivers/staging/hv/storvsc_api.h
index 5f41ef6..800ebbf 100644
--- a/drivers/staging/hv/storvsc_api.h
+++ b/drivers/staging/hv/storvsc_api.h
@@ -53,6 +53,18 @@ enum storvsc_request_type{
 	UNKNOWN_TYPE,
 };
 
+
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
 struct hv_storvsc_request {
 	enum storvsc_request_type type;
 	u32 host;
@@ -103,17 +115,6 @@ struct storvsc_device_info {
 	unsigned char target_id;
 };
 
-struct storvsc_request_extension {
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
-- 
1.7.4.1

