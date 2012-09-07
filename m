Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760275Ab2IGHan (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 03:30:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:20167 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756952Ab2IGH3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 03:29:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,384,1344236400"; 
   d="scan'208";a="189978685"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: lenb@kernel.org
Cc: rui.zhang@intel.com, khali@linux-fr.org, ben-linux@fluff.org,
        w.sang@pengutronix.de, dmitry.torokhov@gmail.com,
        eric.piel@tremplin-utc.net, mjg@redhat.com, ike.pan@canonical.com,
        herton@canonical.com, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH RESEND 03/12] ACPI/fan: convert to module_acpi_driver()
Date: Fri,  7 Sep 2012 10:31:40 +0300
Message-Id: <1347003109-26887-4-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1347003109-26887-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1347003109-26887-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/acpi/fan.c |   22 +---------------------
 1 file changed, 1 insertion(+), 21 deletions(-)

diff --git a/drivers/acpi/fan.c b/drivers/acpi/fan.c
index bc36a47..3bd6a54 100644
--- a/drivers/acpi/fan.c
+++ b/drivers/acpi/fan.c
@@ -212,24 +212,4 @@ static int acpi_fan_resume(struct device *dev)
 }
 #endif
 
-static int __init acpi_fan_init(void)
-{
-	int result = 0;
-
-	result = acpi_bus_register_driver(&acpi_fan_driver);
-	if (result < 0)
-		return -ENODEV;
-
-	return 0;
-}
-
-static void __exit acpi_fan_exit(void)
-{
-
-	acpi_bus_unregister_driver(&acpi_fan_driver);
-
-	return;
-}
-
-module_init(acpi_fan_init);
-module_exit(acpi_fan_exit);
+module_acpi_driver(acpi_fan_driver);
-- 
1.7.10.4

