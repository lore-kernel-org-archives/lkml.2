Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758714Ab1BRW5i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 17:57:38 -0500
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:41018
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758094Ab1BRW5e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 17:57:34 -0500
From: Haiyang Zhang <haiyangz@microsoft.com>
To: haiyangz@microsoft.com, hjanssen@microsoft.com, kys@microsoft.com,
        v-abkane@microsoft.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Subject: [PATCH 1/2] staging: hv: Remove unnecessary ASSERTs in netvsc_initialize()
Date: Fri, 18 Feb 2011 15:05:52 -0800
Message-Id: <1298070353-23534-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These fields have been assigned in netvsc_drv_init() before calling
netvsc_initialize(), so there is no need to check them.
The ASSERTs were already commented out, and this patch removes
them.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>

---
 drivers/staging/hv/netvsc.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/hv/netvsc.c b/drivers/staging/hv/netvsc.c
index 8c6d4ae..f21a59d 100644
--- a/drivers/staging/hv/netvsc.c
+++ b/drivers/staging/hv/netvsc.c
@@ -188,11 +188,6 @@ int netvsc_initialize(struct hv_driver *drv)
 	drv->name = driver_name;
 	memcpy(&drv->dev_type, &netvsc_device_type, sizeof(struct hv_guid));
 
-	/* Make sure it is set by the caller */
-	/* FIXME: These probably should still be tested in some way */
-	/* ASSERT(driver->OnReceiveCallback); */
-	/* ASSERT(driver->OnLinkStatusChanged); */
-
 	/* Setup the dispatch table */
 	driver->base.dev_add	= netvsc_device_add;
 	driver->base.dev_rm	= netvsc_device_remove;
-- 
1.6.3.2

