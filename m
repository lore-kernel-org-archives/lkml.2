Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760450Ab2FUVZ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 17:25:28 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:42675
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1760417Ab2FUVZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 17:25:27 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org,
        ohering@suse.com, apw@canonical.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 01/13] Drivers: hv: Add KVP definitions for IP address injection
Date: Thu, 21 Jun 2012 14:31:33 -0700
Message-Id: <1340314305-27126-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1340314200-27078-1-git-send-email-kys@microsoft.com>
References: <1340314200-27078-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the necessary definitions for supporting the IP injection functionality.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 include/linux/hyperv.h |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index 68ed7f7..0497764 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -127,6 +127,8 @@ enum hv_kvp_exchg_op {
 	KVP_OP_SET,
 	KVP_OP_DELETE,
 	KVP_OP_ENUMERATE,
+	KVP_OP_GET_IP_INFO,
+	KVP_OP_SET_IP_INFO,
 	KVP_OP_REGISTER,
 	KVP_OP_COUNT /* Number of operations, must be last. */
 };
@@ -140,6 +142,26 @@ enum hv_kvp_exchg_pool {
 	KVP_POOL_COUNT /* Number of pools, must be last. */
 };
 
+#define ADDR_FAMILY_NONE	0x00
+#define ADDR_FAMILY_IPV4	0x01
+#define ADDR_FAMILY_IPV6	0x02
+
+#define MAX_ADAPTER_ID_SIZE	128
+#define MAX_IP_ADDR_SIZE	1024
+#define MAX_GATEWAY_SIZE	512
+
+
+struct hv_kvp_ipaddr_value {
+	__u16	adapter_id[MAX_ADAPTER_ID_SIZE];
+	__u8	addr_family;
+	__u8	dhcp_enabled;
+	__u16	ip_addr[MAX_IP_ADDR_SIZE];
+	__u16	sub_net[MAX_IP_ADDR_SIZE];
+	__u16	gate_way[MAX_GATEWAY_SIZE];
+	__u16	dns_addr[MAX_IP_ADDR_SIZE];
+} __attribute__((packed));
+
+
 struct hv_kvp_hdr {
 	__u8 operation;
 	__u8 pool;
@@ -187,6 +209,7 @@ struct hv_kvp_msg {
 		struct hv_kvp_msg_set		kvp_set;
 		struct hv_kvp_msg_delete	kvp_delete;
 		struct hv_kvp_msg_enumerate	kvp_enum_data;
+		struct hv_kvp_ipaddr_value	kvp_ip_val;
 		struct hv_kvp_register		kvp_register;
 	} body;
 } __attribute__((packed));
@@ -982,6 +1005,7 @@ void vmbus_driver_unregister(struct hv_driver *hv_driver);
 #define HV_S_CONT			0x80070103
 #define HV_ERROR_NOT_SUPPORTED		0x80070032
 #define HV_ERROR_MACHINE_LOCKED		0x800704F7
+#define HV_ERROR_DEVICE_NOT_CONNECTED	0x8007048F
 
 /*
  * While we want to handle util services as regular devices,
-- 
1.7.4.1

