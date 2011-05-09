Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab1EIVyP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 17:54:15 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:47589
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755023Ab1EIVov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:44:51 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 077/206] Staging: hv: Get rid of call to cleanup()
Date: Mon,  9 May 2011 14:55:59 -0700
Message-Id: <1304978288-22999-77-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cleanup() is an empty function; get rid of it.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/netvsc_drv.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/hv/netvsc_drv.c b/drivers/staging/hv/netvsc_drv.c
index 3fc39cd..0e81a93 100644
--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -444,7 +444,6 @@ static int netvsc_drv_exit_cb(struct device *dev, void *data)
 
 static void netvsc_drv_exit(void)
 {
-	struct netvsc_driver *netvsc_drv_obj = &g_netvsc_drv;
 	struct hv_driver *drv = &g_netvsc_drv.base;
 	struct device *current_dev;
 	int ret;
@@ -466,9 +465,6 @@ static void netvsc_drv_exit(void)
 		device_unregister(current_dev);
 	}
 
-	if (netvsc_drv_obj->base.cleanup)
-		netvsc_drv_obj->base.cleanup(&netvsc_drv_obj->base);
-
 	vmbus_child_driver_unregister(&drv->driver);
 
 	return;
-- 
1.7.4.1

