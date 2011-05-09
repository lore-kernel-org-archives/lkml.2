Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549Ab1EIV6Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 17:58:16 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:54244
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754971Ab1EIVot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:44:49 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 069/206] Staging: hv: Get rid of netvsc_cleanup()
Date: Mon,  9 May 2011 14:55:51 -0700
Message-Id: <1304978288-22999-69-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

netvsc_cleanup() is an empty function; get rid of it.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/netvsc.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/hv/netvsc.c b/drivers/staging/hv/netvsc.c
index 8790f0f..34828c4 100644
--- a/drivers/staging/hv/netvsc.c
+++ b/drivers/staging/hv/netvsc.c
@@ -622,13 +622,6 @@ int netvsc_device_remove(struct hv_device *device)
 	return 0;
 }
 
-/*
- * netvsc_cleanup - Perform any cleanup when the driver is removed
- */
-static void netvsc_cleanup(struct hv_driver *drv)
-{
-}
-
 static void netvsc_send_completion(struct hv_device *device,
 				   struct vmpacket_descriptor *packet)
 {
@@ -1194,7 +1187,6 @@ int netvsc_initialize(struct hv_driver *drv)
 	/* Setup the dispatch table */
 	driver->base.dev_add	= netvsc_device_add;
 	driver->base.dev_rm	= netvsc_device_remove;
-	driver->base.cleanup		= netvsc_cleanup;
 
 	driver->send			= netvsc_send;
 
-- 
1.7.4.1

