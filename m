Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932800Ab1FPUQO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 16:16:14 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:42430
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758693Ab1FPUB7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 16:01:59 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 31/77] Staging: hv: netvsc: Initialize the driver name directly
Date: Thu, 16 Jun 2011 13:17:04 -0700
Message-Id: <1308255470-3826-31-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1308255470-3826-1-git-send-email-kys@microsoft.com>
References: <1308255393-3785-1-git-send-email-kys@microsoft.com>
 <1308255470-3826-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initialize the driver name directly in netvsc_drv.c.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/netvsc_drv.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/hv/netvsc_drv.c b/drivers/staging/hv/netvsc_drv.c
index 9075a73..05d8e32 100644
--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -41,6 +41,8 @@
 #include "hyperv.h"
 #include "hyperv_net.h"
 
+static const char *driver_name = "netvsc";
+
 struct net_device_context {
 	/* point back to our device context */
 	struct hv_device *device_ctx;
@@ -439,7 +441,7 @@ static int __init netvsc_drv_init(void)
 	/* Callback to client driver to complete the initialization */
 	netvsc_initialize(drv);
 
-	drv->driver.name = drv->name;
+	drv->driver.name = driver_name;
 
 	/* The driver belongs to vmbus */
 	ret = vmbus_child_driver_register(&drv->driver);
-- 
1.7.4.1

