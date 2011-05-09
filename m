Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932725Ab1EJIlq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 04:41:46 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:53186
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756063Ab1EJIav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 04:30:51 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 147/206] Staging: hv: Move the assignment of name variable
Date: Mon,  9 May 2011 14:57:09 -0700
Message-Id: <1304978288-22999-147-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation to eliminate mouse_vsc_initialize,
move the assignment of driver name.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/hv_mouse.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/hv/hv_mouse.c b/drivers/staging/hv/hv_mouse.c
index 5f30e39..b4c087f 100644
--- a/drivers/staging/hv/hv_mouse.c
+++ b/drivers/staging/hv/hv_mouse.c
@@ -979,7 +979,6 @@ static void mousevsc_drv_exit(void)
 
 static int mouse_vsc_initialize(struct hv_driver *driver)
 {
-	driver->name = driver_name;
 	memcpy(&driver->dev_type, &mouse_guid,
 	       sizeof(struct hv_guid));
 
@@ -998,6 +997,7 @@ static int __init mousevsc_init(void)
 	mouse_vsc_initialize(&input_drv_obj->base);
 
 	drv->driver.name = driver_name;
+	drv->name = driver_name;
 
 	/* The driver belongs to vmbus */
 	vmbus_child_driver_register(&drv->driver);
-- 
1.7.4.1

