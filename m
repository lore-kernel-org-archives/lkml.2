Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760261Ab2IGHal (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 03:30:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:21417 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759880Ab2IGH3e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 03:29:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,384,1344236400"; 
   d="scan'208";a="219221413"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: lenb@kernel.org
Cc: rui.zhang@intel.com, khali@linux-fr.org, ben-linux@fluff.org,
        w.sang@pengutronix.de, dmitry.torokhov@gmail.com,
        eric.piel@tremplin-utc.net, mjg@redhat.com, ike.pan@canonical.com,
        herton@canonical.com, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH RESEND 07/12] Input: atlas_btns - convert to module_acpi_driver()
Date: Fri,  7 Sep 2012 10:31:44 +0300
Message-Id: <1347003109-26887-8-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1347003109-26887-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1347003109-26887-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/misc/atlas_btns.c |   17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

diff --git a/drivers/input/misc/atlas_btns.c b/drivers/input/misc/atlas_btns.c
index 601f737..26f1313 100644
--- a/drivers/input/misc/atlas_btns.c
+++ b/drivers/input/misc/atlas_btns.c
@@ -151,22 +151,7 @@ static struct acpi_driver atlas_acpi_driver = {
 		.remove	= atlas_acpi_button_remove,
 	},
 };
-
-static int __init atlas_acpi_init(void)
-{
-	if (acpi_disabled)
-		return -ENODEV;
-
-	return acpi_bus_register_driver(&atlas_acpi_driver);
-}
-
-static void __exit atlas_acpi_exit(void)
-{
-	acpi_bus_unregister_driver(&atlas_acpi_driver);
-}
-
-module_init(atlas_acpi_init);
-module_exit(atlas_acpi_exit);
+module_acpi_driver(atlas_acpi_driver);
 
 MODULE_AUTHOR("Jaya Kumar");
 MODULE_LICENSE("GPL");
-- 
1.7.10.4

