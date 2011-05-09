Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516Ab1EJJyN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 05:54:13 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:46520
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753550Ab1EJJyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 05:54:08 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 167/206] Staging: hv: Add the contents of hv_api.h
Date: Mon,  9 May 2011 14:57:29 -0700
Message-Id: <1304978288-22999-167-git-send-email-kys@microsoft.com>
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
 drivers/staging/hv/hyperv_vmbus.h |  113 +++++++++++++++++++++++++++++++++++++
 1 files changed, 113 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/hv/hyperv_vmbus.h b/drivers/staging/hv/hyperv_vmbus.h
index 5df7c82..ea06691 100644
--- a/drivers/staging/hv/hyperv_vmbus.h
+++ b/drivers/staging/hv/hyperv_vmbus.h
@@ -392,4 +392,117 @@ union hv_x64_msr_hypercall_contents {
 	};
 };
 
+
+#include "hv_api.h"
+
+enum {
+	VMBUS_MESSAGE_CONNECTION_ID	= 1,
+	VMBUS_MESSAGE_PORT_ID		= 1,
+	VMBUS_EVENT_CONNECTION_ID	= 2,
+	VMBUS_EVENT_PORT_ID		= 2,
+	VMBUS_MONITOR_CONNECTION_ID	= 3,
+	VMBUS_MONITOR_PORT_ID		= 3,
+	VMBUS_MESSAGE_SINT		= 2,
+};
+
+/* #defines */
+
+#define HV_PRESENT_BIT			0x80000000
+
+#define HV_LINUX_GUEST_ID_LO		0x00000000
+#define HV_LINUX_GUEST_ID_HI		0xB16B00B5
+#define HV_LINUX_GUEST_ID		(((u64)HV_LINUX_GUEST_ID_HI << 32) | \
+					   HV_LINUX_GUEST_ID_LO)
+
+#define HV_CPU_POWER_MANAGEMENT		(1 << 0)
+#define HV_RECOMMENDATIONS_MAX		4
+
+#define HV_X64_MAX			5
+#define HV_CAPS_MAX			8
+
+
+#define HV_HYPERCALL_PARAM_ALIGN	sizeof(u64)
+
+
+/* Service definitions */
+
+#define HV_SERVICE_PARENT_PORT				(0)
+#define HV_SERVICE_PARENT_CONNECTION			(0)
+
+#define HV_SERVICE_CONNECT_RESPONSE_SUCCESS		(0)
+#define HV_SERVICE_CONNECT_RESPONSE_INVALID_PARAMETER	(1)
+#define HV_SERVICE_CONNECT_RESPONSE_UNKNOWN_SERVICE	(2)
+#define HV_SERVICE_CONNECT_RESPONSE_CONNECTION_REJECTED	(3)
+
+#define HV_SERVICE_CONNECT_REQUEST_MESSAGE_ID		(1)
+#define HV_SERVICE_CONNECT_RESPONSE_MESSAGE_ID		(2)
+#define HV_SERVICE_DISCONNECT_REQUEST_MESSAGE_ID	(3)
+#define HV_SERVICE_DISCONNECT_RESPONSE_MESSAGE_ID	(4)
+#define HV_SERVICE_MAX_MESSAGE_ID				(4)
+
+#define HV_SERVICE_PROTOCOL_VERSION (0x0010)
+#define HV_CONNECT_PAYLOAD_BYTE_COUNT 64
+
+/* #define VMBUS_REVISION_NUMBER	6 */
+
+/* Our local vmbus's port and connection id. Anything >0 is fine */
+/* #define VMBUS_PORT_ID		11 */
+
+/* 628180B8-308D-4c5e-B7DB-1BEB62E62EF4 */
+static const struct hv_guid VMBUS_SERVICE_ID = {
+	.data = {
+		0xb8, 0x80, 0x81, 0x62, 0x8d, 0x30, 0x5e, 0x4c,
+		0xb7, 0xdb, 0x1b, 0xeb, 0x62, 0xe6, 0x2e, 0xf4
+	},
+};
+
+#define MAX_NUM_CPUS	32
+
+
+struct hv_input_signal_event_buffer {
+	u64 align8;
+	struct hv_input_signal_event event;
+};
+
+struct hv_context {
+	/* We only support running on top of Hyper-V
+	* So at this point this really can only contain the Hyper-V ID
+	*/
+	u64 guestid;
+
+	void *hypercall_page;
+
+	bool synic_initialized;
+
+	/*
+	 * This is used as an input param to HvCallSignalEvent hypercall. The
+	 * input param is immutable in our usage and must be dynamic mem (vs
+	 * stack or global). */
+	struct hv_input_signal_event_buffer *signal_event_buffer;
+	/* 8-bytes aligned of the buffer above */
+	struct hv_input_signal_event *signal_event_param;
+
+	void *synic_message_page[MAX_NUM_CPUS];
+	void *synic_event_page[MAX_NUM_CPUS];
+};
+
+extern struct hv_context hv_context;
+
+
+/* Hv Interface */
+
+extern int hv_init(void);
+
+extern void hv_cleanup(void);
+
+extern u16 hv_post_message(union hv_connection_id connection_id,
+			 enum hv_message_type message_type,
+			 void *payload, size_t payload_size);
+
+extern u16 hv_signal_event(void);
+
+extern void hv_synic_init(void *irqarg);
+
+extern void hv_synic_cleanup(void *arg);
+
 #endif /* _HYPERV_VMBUS_H */
-- 
1.7.4.1

