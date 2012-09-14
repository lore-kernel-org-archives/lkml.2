Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460Ab2INBJo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 21:09:44 -0400
Received: from mga09.intel.com ([134.134.136.24]:52283 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718Ab2INBJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 21:09:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,420,1344236400"; 
   d="scan'208";a="203425533"
From: Aaron Lu <aaron.lu@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
        Borislav Petkov <bp@amd64.org>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aaron Lu <aaron.lwe@gmail.com>, Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH RESEND] ACPI: power: Use KERN_DEBUG when no power resources are found
Date: Fri, 14 Sep 2012 09:08:04 +0800
Message-Id: <1347584884-1486-1-git-send-email-aaron.lu@intel.com>
X-Mailer: git-send-email 1.7.12.21.g871e293
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit a606dac368eed5696fb38e16b1394f1d049c09e9 adds support to link
devices which have _PRx, if a device does not have _PRx, a warning
message will be printed.

This commit is for ZPODD on Intel ZPODD capable platforms, on other
platforms, it has no problem if there is no power resource for this
device, so a warning here is not appropriate, change it to debug.

Reported-by: Borislav Petkov <bp@amd64.org>
Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 drivers/acpi/power.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
index 215ecd0..e5e01d9 100644
--- a/drivers/acpi/power.c
+++ b/drivers/acpi/power.c
@@ -460,7 +460,7 @@ int acpi_power_resource_register_device(struct device *dev, acpi_handle handle)
 	return ret;
 
 no_power_resource:
-	printk(KERN_WARNING PREFIX "Invalid Power Resource to register!");
+	printk(KERN_DEBUG PREFIX "Invalid Power Resource to register!");
 	return -ENODEV;
 }
 EXPORT_SYMBOL_GPL(acpi_power_resource_register_device);
-- 
1.7.12.21.g871e293

