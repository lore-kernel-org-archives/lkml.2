Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757071Ab2JFUSJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 16:18:09 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:51715 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756960Ab2JFUSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 16:18:03 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 27/49] ideapad: convert to module_acpi_driver()
Date: Sat,  6 Oct 2012 16:09:48 -0400
Message-Id: <26953f78fbae7fef6f91c3351050b0334c06161c.1349554106.git.len.brown@intel.com>
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
Acked-by: Ike Panhc <ike.pan@canonical.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/platform/x86/ideapad-laptop.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
index dae7abe..5ff4f2e 100644
--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -917,20 +917,8 @@ static struct acpi_driver ideapad_acpi_driver = {
 	.drv.pm = &ideapad_pm,
 	.owner = THIS_MODULE,
 };
-
-static int __init ideapad_acpi_module_init(void)
-{
-	return acpi_bus_register_driver(&ideapad_acpi_driver);
-}
-
-static void __exit ideapad_acpi_module_exit(void)
-{
-	acpi_bus_unregister_driver(&ideapad_acpi_driver);
-}
+module_acpi_driver(ideapad_acpi_driver);
 
 MODULE_AUTHOR("David Woodhouse <dwmw2@infradead.org>");
 MODULE_DESCRIPTION("IdeaPad ACPI Extras");
 MODULE_LICENSE("GPL");
-
-module_init(ideapad_acpi_module_init);
-module_exit(ideapad_acpi_module_exit);
-- 
1.8.0.rc0.18.gf84667d

