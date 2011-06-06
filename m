Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758503Ab1FFWq5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 18:46:57 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:58001
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758149Ab1FFWe6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 18:34:58 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>
Subject: [PATCH 16/49] Staging: hv: vmbus: Get rid of  vmbus_acpi_init() by inlining the code
Date: Mon,  6 Jun 2011 15:49:40 -0700
Message-Id: <1307400613-13234-16-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1307400613-13234-1-git-send-email-kys@microsoft.com>
References: <1307400540-13193-1-git-send-email-kys@microsoft.com>
 <1307400613-13234-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Staging: hv: vmbus: Get rid of  vmbus_acpi_init() by inlining the code.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
---
 drivers/staging/hv/vmbus_drv.c |   15 ++-------------
 1 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index 176a8cd..d799f42 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -758,18 +758,6 @@ static struct acpi_driver vmbus_acpi_driver = {
 	},
 };
 
-static int vmbus_acpi_init(void)
-{
-	int result;
-
-
-	result = acpi_bus_register_driver(&vmbus_acpi_driver);
-	if (result < 0)
-		return result;
-
-	return 0;
-}
-
 static void vmbus_acpi_exit(void)
 {
 	acpi_bus_unregister_driver(&vmbus_acpi_driver);
@@ -800,7 +788,8 @@ static int __init hv_acpi_init(void)
 	 * Get irq resources first.
 	 */
 
-	ret = vmbus_acpi_init();
+	ret = acpi_bus_register_driver(&vmbus_acpi_driver);
+
 	if (ret)
 		return ret;
 
-- 
1.7.4.1

