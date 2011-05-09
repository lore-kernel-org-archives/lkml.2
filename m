Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291Ab1EIVxT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 17:53:19 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:54338
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755034Ab1EIVow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:44:52 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 094/206] Staging: hv: Statically initialize probe/remove
Date: Mon,  9 May 2011 14:56:16 -0700
Message-Id: <1304978288-22999-94-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Statically initialize probe/remove.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/hv_mouse.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/hv/hv_mouse.c b/drivers/staging/hv/hv_mouse.c
index c5e50b4..4475534 100644
--- a/drivers/staging/hv/hv_mouse.c
+++ b/drivers/staging/hv/hv_mouse.c
@@ -943,7 +943,10 @@ static int mousevsc_drv_exit_cb(struct device *dev, void *data)
 	return 1;
 }
 
-static struct  mousevsc_drv_obj mousevsc_drv;
+static struct  mousevsc_drv_obj mousevsc_drv = {
+	.base.probe = mousevsc_probe,
+	.base.remove = mousevsc_remove,
+};
 
 static void mousevsc_drv_exit(void)
 {
@@ -996,9 +999,6 @@ static int __init mousevsc_init(void)
 
 	drv->driver.name = input_drv_obj->base.name;
 
-	drv->probe = mousevsc_probe;
-	drv->remove = mousevsc_remove;
-
 	/* The driver belongs to vmbus */
 	vmbus_child_driver_register(&drv->driver);
 
-- 
1.7.4.1

