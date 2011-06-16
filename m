Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932961Ab1FPURS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 16:17:18 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:42415
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758676Ab1FPUB6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 16:01:58 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 24/77] Staging: hv: netvsc: Get rid of the DMI signature in netvsc_drv.c
Date: Thu, 16 Jun 2011 13:16:57 -0700
Message-Id: <1308255470-3826-24-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1308255470-3826-1-git-send-email-kys@microsoft.com>
References: <1308255393-3785-1-git-send-email-kys@microsoft.com>
 <1308255470-3826-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have implemented a vmbus specific mechanism for auto-loading, get
rid of the DMI signature.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/netvsc_drv.c |   19 -------------------
 1 files changed, 0 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/hv/netvsc_drv.c b/drivers/staging/hv/netvsc_drv.c
index c570214..9075a73 100644
--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -33,7 +33,6 @@
 #include <linux/skbuff.h>
 #include <linux/in.h>
 #include <linux/slab.h>
-#include <linux/dmi.h>
 #include <net/arp.h>
 #include <net/route.h>
 #include <net/sock.h>
@@ -430,20 +429,6 @@ static void __exit netvsc_drv_exit(void)
 }
 
 
-static const struct dmi_system_id __initconst
-hv_netvsc_dmi_table[] __maybe_unused  = {
-	{
-		.ident = "Hyper-V",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Virtual Machine"),
-			DMI_MATCH(DMI_BOARD_NAME, "Virtual Machine"),
-		},
-	},
-	{ },
-};
-MODULE_DEVICE_TABLE(dmi, hv_netvsc_dmi_table);
-
 static int __init netvsc_drv_init(void)
 {
 	struct hv_driver *drv = &netvsc_drv;
@@ -451,10 +436,6 @@ static int __init netvsc_drv_init(void)
 
 	pr_info("initializing....");
 
-	if (!dmi_check_system(hv_netvsc_dmi_table))
-		return -ENODEV;
-
-
 	/* Callback to client driver to complete the initialization */
 	netvsc_initialize(drv);
 
-- 
1.7.4.1

