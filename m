Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097Ab1EIVyR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 17:54:17 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:54319
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755015Ab1EIVov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:44:51 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 091/206] Staging: hv: Statically initialize probe/remove
Date: Mon,  9 May 2011 14:56:13 -0700
Message-Id: <1304978288-22999-91-git-send-email-kys@microsoft.com>
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
 drivers/staging/hv/netvsc_drv.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/hv/netvsc_drv.c b/drivers/staging/hv/netvsc_drv.c
index 566865f..c5e7b93 100644
--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -440,7 +440,10 @@ static int netvsc_drv_exit_cb(struct device *dev, void *data)
 }
 
 /* The one and only one */
-static struct  netvsc_driver netvsc_drv;
+static struct  netvsc_driver netvsc_drv = {
+	.base.probe = netvsc_probe,
+	.base.remove = netvsc_remove,
+};
 
 static void netvsc_drv_exit(void)
 {
@@ -485,9 +488,6 @@ static int netvsc_drv_init(int (*drv_init)(struct hv_driver *drv))
 
 	drv->driver.name = net_drv_obj->base.name;
 
-	drv->probe = netvsc_probe;
-	drv->remove = netvsc_remove;
-
 	/* The driver belongs to vmbus */
 	ret = vmbus_child_driver_register(&drv->driver);
 
-- 
1.7.4.1

