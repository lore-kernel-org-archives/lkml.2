Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758552Ab1FFWq7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 18:46:59 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:57994
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758140Ab1FFWe6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 18:34:58 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>
Subject: [PATCH 12/49] Staging: hv: storvsc: Add a DMI signature to support auto-loading
Date: Mon,  6 Jun 2011 15:49:36 -0700
Message-Id: <1307400613-13234-12-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1307400613-13234-1-git-send-email-kys@microsoft.com>
References: <1307400540-13193-1-git-send-email-kys@microsoft.com>
 <1307400613-13234-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To support auto-loading the storvsc driver, add a DMI signature.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
---
 drivers/staging/hv/storvsc_drv.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 53e9ebd..2c6d2f2 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -24,6 +24,7 @@
 #include <linux/module.h>
 #include <linux/device.h>
 #include <linux/blkdev.h>
+#include <linux/dmi.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_host.h>
@@ -723,6 +724,27 @@ static struct hv_driver storvsc_drv = {
 	.remove = storvsc_remove,
 };
 
+/*
+ * We use a DMI table to determine if we should autoload this driver  This is
+ * needed by distro tools to determine if the hyperv drivers should be
+ * installed and/or configured.  We don't do anything else with the table, but
+ * it needs to be present.
+ */
+
+static const struct dmi_system_id __initconst
+hv_stor_dmi_table[] __maybe_unused  = {
+	{
+		.ident = "Hyper-V",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Microsoft Corporation"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Virtual Machine"),
+			DMI_MATCH(DMI_BOARD_NAME, "Virtual Machine"),
+		},
+	},
+	{ },
+};
+MODULE_DEVICE_TABLE(dmi, hv_stor_dmi_table);
+
 static int __init storvsc_drv_init(void)
 {
 	int ret;
-- 
1.7.4.1

