Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477Ab1HYQk5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 12:40:57 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:42753
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753407Ab1HYQ2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 12:28:55 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 15/59] Staging: hv: storvsc: Get rid of the DMI signature
Date: Thu, 25 Aug 2011 09:48:41 -0700
Message-Id: <1314290965-2698-15-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314290965-2698-1-git-send-email-kys@microsoft.com>
References: <1314290866-2644-1-git-send-email-kys@microsoft.com>
 <1314290965-2698-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have implemented a vmbus specific mechanism for auto-loading,
get rid of the DMI signature.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/storvsc_drv.c |   22 ----------------------
 1 files changed, 0 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index ed2140c..4dc6d2f 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -24,7 +24,6 @@
 #include <linux/module.h>
 #include <linux/device.h>
 #include <linux/blkdev.h>
-#include <linux/dmi.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_host.h>
@@ -730,27 +729,6 @@ static struct hv_driver storvsc_drv = {
 	.remove = storvsc_remove,
 };
 
-/*
- * We use a DMI table to determine if we should autoload this driver  This is
- * needed by distro tools to determine if the hyperv drivers should be
- * installed and/or configured.  We don't do anything else with the table, but
- * it needs to be present.
- */
-
-static const struct dmi_system_id __initconst
-hv_stor_dmi_table[] __maybe_unused  = {
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
-MODULE_DEVICE_TABLE(dmi, hv_stor_dmi_table);
-
 static int __init storvsc_drv_init(void)
 {
 	int ret;
-- 
1.7.4.1

