Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765Ab1DENzJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 09:55:09 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:55516
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752817Ab1DENxy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 09:53:54 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 01/22] Staging: hv: Move the definition of struct storvsc_request_extension
Date: Tue,  5 Apr 2011 07:04:45 -0700
Message-Id: <1302012306-21277-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1302012261-21236-1-git-send-email-kys@microsoft.com>
References: <1302012261-21236-1-git-send-email-kys@microsoft.com>
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

