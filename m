Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932453Ab1EaPxO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 11:53:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49609 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932430Ab1EaPxM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 11:53:12 -0400
Date: Tue, 31 May 2011 11:53:10 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org, abelay@mit.edu
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20110531155310.3587.70224.sendpatchset@prarit.bos.redhat.com>
Content-Type: text/x-c; charset=us-ascii
Subject: [RFC PATCH 23/35] drivers/pnp changes for SMBIOS and System Firmware
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/pnp changes for SMBIOS and System Firmware

---
 drivers/pnp/pnpacpi/core.c |    1 -
 drivers/pnp/pnpbios/core.c |   20 ++++++++++----------
 2 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/pnp/pnpacpi/core.c b/drivers/pnp/pnpacpi/core.c
index ca84d50..8971996 100644
--- a/drivers/pnp/pnpacpi/core.c
+++ b/drivers/pnp/pnpacpi/core.c
@@ -22,7 +22,6 @@
 #include <linux/acpi.h>
 #include <linux/pnp.h>
 #include <linux/slab.h>
-#include <linux/mod_devicetable.h>
 #include <acpi/acpi_bus.h>
 
 #include "../base.h"
diff --git a/drivers/pnp/pnpbios/core.c b/drivers/pnp/pnpbios/core.c
index cfe8685..7a59d1c 100644
--- a/drivers/pnp/pnpbios/core.c
+++ b/drivers/pnp/pnpbios/core.c
@@ -57,11 +57,11 @@
 #include <linux/slab.h>
 #include <linux/completion.h>
 #include <linux/spinlock.h>
-#include <linux/dmi.h>
 #include <linux/delay.h>
 #include <linux/acpi.h>
 #include <linux/freezer.h>
 #include <linux/kthread.h>
+#include <linux/sysfw.h>
 
 #include <asm/page.h>
 #include <asm/desc.h>
@@ -486,29 +486,29 @@ static int __init pnpbios_probe_system(void)
 	return 0;
 }
 
-static int __init exploding_pnp_bios(const struct dmi_system_id *d)
+static int __init exploding_pnp_bios(const struct sysfw_id *d)
 {
 	printk(KERN_WARNING "%s detected. Disabling PnPBIOS\n", d->ident);
 	return 0;
 }
 
-static struct dmi_system_id pnpbios_dmi_table[] __initdata = {
+static struct sysfw_id pnpbios_smbios_table[] __initdata = {
 	{			/* PnPBIOS GPF on boot */
 	 .callback = exploding_pnp_bios,
 	 .ident = "Higraded P14H",
 	 .matches = {
-		     DMI_MATCH(DMI_BIOS_VENDOR, "American Megatrends Inc."),
-		     DMI_MATCH(DMI_BIOS_VERSION, "07.00T"),
-		     DMI_MATCH(DMI_SYS_VENDOR, "Higraded"),
-		     DMI_MATCH(DMI_PRODUCT_NAME, "P14H"),
+		     SYSFW_MATCH(SYSFW_BIOS_VENDOR, "American Megatrends Inc."),
+		     SYSFW_MATCH(SYSFW_BIOS_VERSION, "07.00T"),
+		     SYSFW_MATCH(SYSFW_SYS_VENDOR, "Higraded"),
+		     SYSFW_MATCH(SYSFW_PRODUCT_NAME, "P14H"),
 		     },
 	 },
 	{			/* PnPBIOS GPF on boot */
 	 .callback = exploding_pnp_bios,
 	 .ident = "ASUS P4P800",
 	 .matches = {
-		     DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK Computer Inc."),
-		     DMI_MATCH(DMI_BOARD_NAME, "P4P800"),
+		     SYSFW_MATCH(SYSFW_BOARD_VENDOR, "ASUSTeK Computer Inc."),
+		     SYSFW_MATCH(SYSFW_BOARD_NAME, "P4P800"),
 		     },
 	 },
 	{}
@@ -522,7 +522,7 @@ static int __init pnpbios_init(void)
 	if (check_legacy_ioport(PNPBIOS_BASE))
 		return -ENODEV;
 #endif
-	if (pnpbios_disabled || dmi_check_system(pnpbios_dmi_table) ||
+	if (pnpbios_disabled || sysfw_callback(pnpbios_smbios_table) ||
 	    paravirt_enabled()) {
 		printk(KERN_INFO "PnPBIOS: Disabled\n");
 		return -ENODEV;
-- 
1.7.5.1

