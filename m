Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760255Ab2IGHaj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 03:30:39 -0400
Received: from mga01.intel.com ([192.55.52.88]:21417 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759836Ab2IGH3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 03:29:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,384,1344236400"; 
   d="scan'208";a="219221409"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: lenb@kernel.org
Cc: rui.zhang@intel.com, khali@linux-fr.org, ben-linux@fluff.org,
        w.sang@pengutronix.de, dmitry.torokhov@gmail.com,
        eric.piel@tremplin-utc.net, mjg@redhat.com, ike.pan@canonical.com,
        herton@canonical.com, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH RESEND 06/12] i2c-scmi: convert to module_acpi_driver()
Date: Fri,  7 Sep 2012 10:31:43 +0300
Message-Id: <1347003109-26887-7-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1347003109-26887-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1347003109-26887-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Acked-by: Jean Delvare <khali@linux-fr.org>
---
 drivers/i2c/busses/i2c-scmi.c |   14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/i2c/busses/i2c-scmi.c b/drivers/i2c/busses/i2c-scmi.c
index 388cbdc..6aafa3d 100644
--- a/drivers/i2c/busses/i2c-scmi.c
+++ b/drivers/i2c/busses/i2c-scmi.c
@@ -426,19 +426,7 @@ static struct acpi_driver acpi_smbus_cmi_driver = {
 		.remove = acpi_smbus_cmi_remove,
 	},
 };
-
-static int __init acpi_smbus_cmi_init(void)
-{
-	return acpi_bus_register_driver(&acpi_smbus_cmi_driver);
-}
-
-static void __exit acpi_smbus_cmi_exit(void)
-{
-	acpi_bus_unregister_driver(&acpi_smbus_cmi_driver);
-}
-
-module_init(acpi_smbus_cmi_init);
-module_exit(acpi_smbus_cmi_exit);
+module_acpi_driver(acpi_smbus_cmi_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Crane Cai <crane.cai@amd.com>");
-- 
1.7.10.4

