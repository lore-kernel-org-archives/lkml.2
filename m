Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758315Ab1FFWhs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 18:37:48 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:39485
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758206Ab1FFWfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 18:35:04 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>
Subject: [PATCH 46/49] Staging: hv: vmbus: Cleanup error codes in connection.c
Date: Mon,  6 Jun 2011 15:50:10 -0700
Message-Id: <1307400613-13234-46-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1307400613-13234-1-git-send-email-kys@microsoft.com>
References: <1307400540-13193-1-git-send-email-kys@microsoft.com>
 <1307400613-13234-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup error codes in connection.c.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
---
 drivers/staging/hv/connection.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/hv/connection.c b/drivers/staging/hv/connection.c
index 7d7f1d5..7e15392 100644
--- a/drivers/staging/hv/connection.c
+++ b/drivers/staging/hv/connection.c
@@ -51,13 +51,13 @@ int vmbus_connect(void)
 
 	/* Make sure we are not connecting or connected */
 	if (vmbus_connection.conn_state != DISCONNECTED)
-		return -1;
+		return -EISCONN;
 
 	/* Initialize the vmbus connection */
 	vmbus_connection.conn_state = CONNECTING;
 	vmbus_connection.work_queue = create_workqueue("hv_vmbus_con");
 	if (!vmbus_connection.work_queue) {
-		ret = -1;
+		ret = -ENOMEM;
 		goto cleanup;
 	}
 
@@ -74,7 +74,7 @@ int vmbus_connect(void)
 	vmbus_connection.int_page =
 	(void *)__get_free_pages(GFP_KERNEL|__GFP_ZERO, 0);
 	if (vmbus_connection.int_page == NULL) {
-		ret = -1;
+		ret = -ENOMEM;
 		goto cleanup;
 	}
 
@@ -90,7 +90,7 @@ int vmbus_connect(void)
 	vmbus_connection.monitor_pages =
 	(void *)__get_free_pages((GFP_KERNEL|__GFP_ZERO), 1);
 	if (vmbus_connection.monitor_pages == NULL) {
-		ret = -1;
+		ret = -ENOMEM;
 		goto cleanup;
 	}
 
@@ -157,7 +157,7 @@ int vmbus_connect(void)
 		pr_err("Unable to connect, "
 			"Version %d not supported by Hyper-V\n",
 			VMBUS_REVISION_NUMBER);
-		ret = -1;
+		ret = -ECONNREFUSED;
 		goto cleanup;
 	}
 
-- 
1.7.4.1

