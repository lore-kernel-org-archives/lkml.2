Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291Ab2F1LAD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 07:00:03 -0400
Received: from mga11.intel.com ([192.55.52.93]:18859 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387Ab2F1K55 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 06:57:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="186037086"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org, rui.zhang@intel.com,
        khali@linux-fr.org, ben-linux@fluff.org, w.sang@pengutronix.de,
        dmitry.torokhov@gmail.com, eric.piel@tremplin-utc.net, mjg@redhat.com,
        ike.pan@canonical.com, herton@canonical.com,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 06/12] i2c-scmi: convert to module_acpi_driver()
Date: Thu, 28 Jun 2012 13:59:25 +0300
Message-Id: <1340881171-14811-7-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1340881171-14811-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1340881171-14811-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
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
1.7.10

