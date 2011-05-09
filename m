Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418Ab1EIVyN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 17:54:13 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:48740
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755025Ab1EIVov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:44:51 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 083/206] Staging: hv: Cleanup mouse_vsc_initialize()
Date: Mon,  9 May 2011 14:56:05 -0700
Message-Id: <1304978288-22999-83-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have gotten rid of the indirection, cleanup 
mouse_vsc_initialize().

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/hv_mouse.c |   10 +---------
 1 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/hv/hv_mouse.c b/drivers/staging/hv/hv_mouse.c
index 41bfa3f..523c428 100644
--- a/drivers/staging/hv/hv_mouse.c
+++ b/drivers/staging/hv/hv_mouse.c
@@ -980,19 +980,11 @@ static void mousevsc_drv_exit(void)
 
 static int mouse_vsc_initialize(struct hv_driver *driver)
 {
-	struct mousevsc_drv_obj *input_drv =
-		(struct mousevsc_drv_obj *)driver;
-	int ret = 0;
-
 	driver->name = driver_name;
 	memcpy(&driver->dev_type, &mouse_guid,
 	       sizeof(struct hv_guid));
 
-	/* Setup the dispatch table */
-	input_drv->base.dev_add = mousevsc_on_device_add;
-	input_drv->base.dev_rm = mousevsc_on_device_remove;
-
-	return ret;
+	return 0;
 }
 
 
-- 
1.7.4.1

