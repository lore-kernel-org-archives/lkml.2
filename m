Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758541Ab1FFWqB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 18:46:01 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:37241
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758164Ab1FFWe7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 18:34:59 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>
Subject: [PATCH 17/49] Staging: hv: vmbus: Get rid of vmbus_acpi_exit() by inlining the code
Date: Mon,  6 Jun 2011 15:49:41 -0700
Message-Id: <1307400613-13234-17-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1307400613-13234-1-git-send-email-kys@microsoft.com>
References: <1307400540-13193-1-git-send-email-kys@microsoft.com>
 <1307400613-13234-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of vmbus_acpi_exit() by inlining the code.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
---
 drivers/staging/hv/vmbus_drv.c |   10 +---------
 1 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index d799f42..39cd277 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -758,14 +758,6 @@ static struct acpi_driver vmbus_acpi_driver = {
 	},
 };
 
-static void vmbus_acpi_exit(void)
-{
-	acpi_bus_unregister_driver(&vmbus_acpi_driver);
-
-	return;
-}
-
-
 /*
  * We use a PCI table to determine if we should autoload this driver  This is
  * needed by distro tools to determine if the hyperv drivers should be
@@ -796,7 +788,7 @@ static int __init hv_acpi_init(void)
 	wait_for_completion(&probe_event);
 
 	if (irq <= 0) {
-		vmbus_acpi_exit();
+		acpi_bus_unregister_driver(&vmbus_acpi_driver);
 		return -ENODEV;
 	}
 
-- 
1.7.4.1

