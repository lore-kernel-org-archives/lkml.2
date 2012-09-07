Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759651Ab2IGH3c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 03:29:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:20167 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756632Ab2IGH33 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 03:29:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,384,1344236400"; 
   d="scan'208";a="189978677"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: lenb@kernel.org
Cc: rui.zhang@intel.com, khali@linux-fr.org, ben-linux@fluff.org,
        w.sang@pengutronix.de, dmitry.torokhov@gmail.com,
        eric.piel@tremplin-utc.net, mjg@redhat.com, ike.pan@canonical.com,
        herton@canonical.com, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH RESEND 01/12] ACPI: introduce module_acpi_driver() helper macro
Date: Fri,  7 Sep 2012 10:31:38 +0300
Message-Id: <1347003109-26887-2-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1347003109-26887-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1347003109-26887-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a helper macro module_acpi_driver() which reduces the boilerplate code
for ACPI drivers. This is similar what is done for other busses (PCI, SPI,
I2C etc).

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 include/acpi/acpi_bus.h |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index bde976e..bddd909 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -381,6 +381,19 @@ int acpi_match_device_ids(struct acpi_device *device,
 int acpi_create_dir(struct acpi_device *);
 void acpi_remove_dir(struct acpi_device *);
 
+
+/**
+ * module_acpi_driver(acpi_driver) - Helper macro for registering an ACPI driver
+ * @__acpi_driver: acpi_driver struct
+ *
+ * Helper macro for ACPI drivers which do not do anything special in module
+ * init/exit. This eliminates a lot of boilerplate. Each module may only
+ * use this macro once, and calling it replaces module_init() and module_exit()
+ */
+#define module_acpi_driver(__acpi_driver) \
+	module_driver(__acpi_driver, acpi_bus_register_driver, \
+		      acpi_bus_unregister_driver)
+
 /*
  * Bind physical devices with ACPI devices
  */
-- 
1.7.10.4

