Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757038Ab2JFUSp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 16:18:45 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:35485 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649Ab2JFUSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 16:18:42 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 29/49] toshiba_bluetooth: convert to module_acpi_driver()
Date: Sat,  6 Oct 2012 16:09:50 -0400
Message-Id: <01d1775301f950ea463e2184b67b6bc9b68f5bae.1349554106.git.len.brown@intel.com>
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
 drivers/platform/x86/toshiba_bluetooth.c | 22 +---------------------
 1 file changed, 1 insertion(+), 21 deletions(-)

diff --git a/drivers/platform/x86/toshiba_bluetooth.c b/drivers/platform/x86/toshiba_bluetooth.c
index 5e5d631..e95be0b 100644
--- a/drivers/platform/x86/toshiba_bluetooth.c
+++ b/drivers/platform/x86/toshiba_bluetooth.c
@@ -122,30 +122,10 @@ static int toshiba_bt_rfkill_add(struct acpi_device *device)
 	return result;
 }
 
-static int __init toshiba_bt_rfkill_init(void)
-{
-	int result;
-
-	result = acpi_bus_register_driver(&toshiba_bt_rfkill_driver);
-	if (result < 0) {
-		ACPI_DEBUG_PRINT((ACPI_DB_ERROR,
-				  "Error registering driver\n"));
-		return result;
-	}
-
-	return 0;
-}
-
 static int toshiba_bt_rfkill_remove(struct acpi_device *device, int type)
 {
 	/* clean up */
 	return 0;
 }
 
-static void __exit toshiba_bt_rfkill_exit(void)
-{
-	acpi_bus_unregister_driver(&toshiba_bt_rfkill_driver);
-}
-
-module_init(toshiba_bt_rfkill_init);
-module_exit(toshiba_bt_rfkill_exit);
+module_acpi_driver(toshiba_bt_rfkill_driver);
-- 
1.8.0.rc0.18.gf84667d

