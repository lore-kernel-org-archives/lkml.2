Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694Ab2A1AZV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 19:25:21 -0500
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:49552
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751419Ab2A1AZU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 19:25:20 -0500
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, ohering@suse.com, zbr@ioremap.net
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 1/6] drivers: hv: kvp: Add/cleanup connector defines
Date: Fri, 27 Jan 2012 15:55:57 -0800
Message-Id: <1327708562-26964-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1327708522-26914-1-git-send-email-kys@microsoft.com>
References: <1327708522-26914-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current KVP code carries some private connector related defines.
Update connector.h to have all the KVP defines. As part of this patch
get rid of some unused defines.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/hv/hv_kvp.h       |    3 ---
 include/linux/connector.h |    1 +
 tools/hv/hv_kvp_daemon.c  |    4 ----
 3 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/drivers/hv/hv_kvp.h b/drivers/hv/hv_kvp.h
index 9b765d7..c2c5bba 100644
--- a/drivers/hv/hv_kvp.h
+++ b/drivers/hv/hv_kvp.h
@@ -107,9 +107,6 @@
  * the KVP user-mode component.
  */
 
-#define CN_KVP_VAL             0x1 /* This supports queries from the kernel */
-#define CN_KVP_USER_VAL       0x2 /* This supports queries from the user */
-
 enum hv_ku_op {
 	KVP_REGISTER = 0, /* Register the user mode component */
 	KVP_KERNEL_GET, /* Kernel is requesting the value */
diff --git a/include/linux/connector.h b/include/linux/connector.h
index 3c9c54f..7638407 100644
--- a/include/linux/connector.h
+++ b/include/linux/connector.h
@@ -43,6 +43,7 @@
 #define CN_IDX_DRBD			0x8
 #define CN_VAL_DRBD			0x1
 #define CN_KVP_IDX			0x9	/* HyperV KVP */
+#define CN_KVP_VAL			0x1	/* queries from the kernel */
 
 #define CN_NETLINK_USERS		10	/* Highest index + 1 */
 
diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
index 11224ed..2b6a2d9 100644
--- a/tools/hv/hv_kvp_daemon.c
+++ b/tools/hv/hv_kvp_daemon.c
@@ -40,15 +40,11 @@
 #include <syslog.h>
 
 /*
- * KYS: TODO. Need to register these in the kernel.
  *
  * The following definitions are shared with the in-kernel component; do not
  * change any of this without making the corresponding changes in
  * the KVP kernel component.
  */
-#define CN_KVP_IDX		0x9     /* MSFT KVP functionality */
-#define CN_KVP_VAL		0x1 /* This supports queries from the kernel */
-#define CN_KVP_USER_VAL		0x2 /* This supports queries from the user  */
 
 /*
  * KVP protocol: The user mode component first registers with the
-- 
1.7.4.1

