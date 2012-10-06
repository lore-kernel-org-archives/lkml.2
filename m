Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756952Ab2JFUQq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 16:16:46 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:42316 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199Ab2JFUQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 16:16:41 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 22/49] ACPI/hed: convert to module_acpi_driver()
Date: Sat,  6 Oct 2012 16:09:43 -0400
Message-Id: <8fe4bf6f9765e3b867f7c8f1bb7f104dc83a2022.1349554106.git.len.brown@intel.com>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <1349554210-29978-1-git-send-email-lenb@kernel.org>
References: <1349554210-29978-1-git-send-email-lenb@kernel.org>
In-Reply-To: <a950c135e5b2be6ef7518d54d98a7901db1b377a.1349554105.git.len.brown@intel.com>
References: <a950c135e5b2be6ef7518d54d98a7901db1b377a.1349554105.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/hed.c | 20 +-------------------
 1 file changed, 1 insertion(+), 19 deletions(-)

diff --git a/drivers/acpi/hed.c b/drivers/acpi/hed.c
index d0c1967..20a0f2c 100644
--- a/drivers/acpi/hed.c
+++ b/drivers/acpi/hed.c
@@ -86,25 +86,7 @@ static struct acpi_driver acpi_hed_driver = {
 		.notify = acpi_hed_notify,
 	},
 };
-
-static int __init acpi_hed_init(void)
-{
-	if (acpi_disabled)
-		return -ENODEV;
-
-	if (acpi_bus_register_driver(&acpi_hed_driver) < 0)
-		return -ENODEV;
-
-	return 0;
-}
-
-static void __exit acpi_hed_exit(void)
-{
-	acpi_bus_unregister_driver(&acpi_hed_driver);
-}
-
-module_init(acpi_hed_init);
-module_exit(acpi_hed_exit);
+module_acpi_driver(acpi_hed_driver);
 
 ACPI_MODULE_NAME("hed");
 MODULE_AUTHOR("Huang Ying");
-- 
1.8.0.rc0.18.gf84667d

