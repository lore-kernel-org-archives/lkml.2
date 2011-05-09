Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932706Ab1EJIti (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 04:49:38 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:53100
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755997Ab1EJIau (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 04:30:50 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 158/206] Staging: hv: Include the contents of logging.h
Date: Mon,  9 May 2011 14:57:20 -0700
Message-Id: <1304978288-22999-158-git-send-email-kys@microsoft.com>
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
 include/linux/hyperv.h |   70 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 70 insertions(+), 0 deletions(-)

diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index 37fe93e..2e72a47 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -636,4 +636,74 @@ extern void vmbus_get_debug_info(struct vmbus_channel *channel,
 
 extern void vmbus_ontimer(unsigned long data);
 
+
+#define LOWORD(dw) ((unsigned short)(dw))
+#define HIWORD(dw) ((unsigned short)(((unsigned int) (dw) >> 16) & 0xFFFF))
+
+
+
+#define VMBUS				0x0001
+#define STORVSC				0x0002
+#define NETVSC				0x0004
+#define INPUTVSC			0x0008
+#define BLKVSC				0x0010
+#define VMBUS_DRV			0x0100
+#define STORVSC_DRV			0x0200
+#define NETVSC_DRV			0x0400
+#define INPUTVSC_DRV		0x0800
+#define BLKVSC_DRV			0x1000
+
+#define ALL_MODULES			(VMBUS		|\
+							STORVSC		|\
+							NETVSC		|\
+							INPUTVSC	|\
+							BLKVSC		|\
+							VMBUS_DRV	|\
+							STORVSC_DRV	|\
+							NETVSC_DRV	|\
+							INPUTVSC_DRV|\
+							BLKVSC_DRV)
+
+/* Logging Level */
+#define ERROR_LVL				3
+#define WARNING_LVL				4
+#define INFO_LVL				6
+#define DEBUG_LVL				7
+#define DEBUG_LVL_ENTEREXIT			8
+#define DEBUG_RING_LVL				9
+
+extern unsigned int vmbus_loglevel;
+
+#define DPRINT(mod, lvl, fmt, args...) do {\
+	if ((mod & (HIWORD(vmbus_loglevel))) &&	\
+	    (lvl <= LOWORD(vmbus_loglevel)))	\
+		printk(KERN_DEBUG #mod": %s() " fmt "\n", __func__, ## args);\
+	} while (0)
+
+#define DPRINT_DBG(mod, fmt, args...) do {\
+	if ((mod & (HIWORD(vmbus_loglevel))) &&		\
+	    (DEBUG_LVL <= LOWORD(vmbus_loglevel)))	\
+		printk(KERN_DEBUG #mod": %s() " fmt "\n", __func__, ## args);\
+	} while (0)
+
+#define DPRINT_INFO(mod, fmt, args...) do {\
+	if ((mod & (HIWORD(vmbus_loglevel))) &&		\
+	    (INFO_LVL <= LOWORD(vmbus_loglevel)))	\
+		printk(KERN_INFO #mod": " fmt "\n", ## args);\
+	} while (0)
+
+#define DPRINT_WARN(mod, fmt, args...) do {\
+	if ((mod & (HIWORD(vmbus_loglevel))) &&		\
+	    (WARNING_LVL <= LOWORD(vmbus_loglevel)))	\
+		printk(KERN_WARNING #mod": WARNING! " fmt "\n", ## args);\
+	} while (0)
+
+#define DPRINT_ERR(mod, fmt, args...) do {\
+	if ((mod & (HIWORD(vmbus_loglevel))) &&		\
+	    (ERROR_LVL <= LOWORD(vmbus_loglevel)))	\
+		printk(KERN_ERR #mod": %s() ERROR!! " fmt "\n",	\
+		       __func__, ## args);\
+	} while (0)
+
+
 #endif /* _HYPERV_H_ */
-- 
1.7.4.1

