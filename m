Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756994Ab2JFURA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 16:17:00 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:42316 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756852Ab2JFUQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 16:16:54 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 23/49] ACPI/sbshc: convert to module_acpi_driver()
Date: Sat,  6 Oct 2012 16:09:44 -0400
Message-Id: <e84a239e75493c683fed7b82d440f596527a08b7.1349554106.git.len.brown@intel.com>
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
 drivers/acpi/sbshc.c | 18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

diff --git a/drivers/acpi/sbshc.c b/drivers/acpi/sbshc.c
index f8d2a47..cf6129a 100644
--- a/drivers/acpi/sbshc.c
+++ b/drivers/acpi/sbshc.c
@@ -310,23 +310,7 @@ static int acpi_smbus_hc_remove(struct acpi_device *device, int type)
 	return 0;
 }
 
-static int __init acpi_smb_hc_init(void)
-{
-	int result;
-
-	result = acpi_bus_register_driver(&acpi_smb_hc_driver);
-	if (result < 0)
-		return -ENODEV;
-	return 0;
-}
-
-static void __exit acpi_smb_hc_exit(void)
-{
-	acpi_bus_unregister_driver(&acpi_smb_hc_driver);
-}
-
-module_init(acpi_smb_hc_init);
-module_exit(acpi_smb_hc_exit);
+module_acpi_driver(acpi_smb_hc_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Alexey Starikovskiy");
-- 
1.8.0.rc0.18.gf84667d

