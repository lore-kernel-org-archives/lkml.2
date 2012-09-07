Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760301Ab2IGHar (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 03:30:47 -0400
Received: from mga03.intel.com ([143.182.124.21]:18400 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760085Ab2IGH3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 03:29:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,384,1344236400"; 
   d="scan'208";a="189915683"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: lenb@kernel.org
Cc: rui.zhang@intel.com, khali@linux-fr.org, ben-linux@fluff.org,
        w.sang@pengutronix.de, dmitry.torokhov@gmail.com,
        eric.piel@tremplin-utc.net, mjg@redhat.com, ike.pan@canonical.com,
        herton@canonical.com, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH RESEND 09/12] ideapad: convert to module_acpi_driver()
Date: Fri,  7 Sep 2012 10:31:46 +0300
Message-Id: <1347003109-26887-10-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1347003109-26887-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1347003109-26887-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Acked-by: Ike Panhc <ike.pan@canonical.com>
---
 drivers/platform/x86/ideapad-laptop.c |   14 +-------------
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
1.7.10.4

