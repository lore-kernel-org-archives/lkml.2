Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614Ab2FKJLo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 05:11:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56731 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731Ab2FKJLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 05:11:42 -0400
Date: Mon, 11 Jun 2012 02:11:16 -0700
From: tip-bot for Donald Dutile <ddutile@redhat.com>
Message-ID: <tip-e9071b0be5e7ce4903b7f7c370769d485774d3e3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        joe@perches.com, ddutile@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        joe@perches.com, ddutile@redhat.com, tglx@linutronix.de
In-Reply-To: <1339189991-13129-1-git-send-email-ddutile@redhat.com>
References: <1339189991-13129-1-git-send-email-ddutile@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/iommu] iommu/dmar: Use pr_format()
  instead of PREFIX to tidy up pr_*() calls
Git-Commit-ID: e9071b0be5e7ce4903b7f7c370769d485774d3e3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 11 Jun 2012 02:11:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e9071b0be5e7ce4903b7f7c370769d485774d3e3
Gitweb:     http://git.kernel.org/tip/e9071b0be5e7ce4903b7f7c370769d485774d3e3
Author:     Donald Dutile <ddutile@redhat.com>
AuthorDate: Fri, 8 Jun 2012 17:13:11 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 11 Jun 2012 10:27:44 +0200

iommu/dmar: Use pr_format() instead of PREFIX to tidy up pr_*() calls

Joe Perches recommended getting rid of the redundant
formatting of adding "PREFIX" to all the uses of pr_*() calls.

The recommendation helps to reduce source and improve
readibility.

While cleaning up the PREFIX's, I saw that one of
the pr_warn() was redundant in dmar_parse_one_dev_scope(),
since the same message was printed after breaking out of the
while loop for the same condition, !pdev.
So, to avoid a duplicate message, I removed the one in the while
loop.

Reported-by: Joe Perches <joe@perches.com>
Signed-off-by: Donald Dutile <ddutile@redhat.com>
Cc: iommu@lists.linux-foundation.org
Cc: chrisw@redhat.com
Cc: suresh.b.siddha@intel.com
Cc: dwmw2@infradead.org
Link: http://lkml.kernel.org/r/1339189991-13129-1-git-send-email-ddutile@redhat.com
[ Small whitespace fixes. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 drivers/iommu/dmar.c |   54 ++++++++++++++++++++++---------------------------
 1 files changed, 24 insertions(+), 30 deletions(-)

diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index 9ab6ebf..86e2f4a 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -26,6 +26,8 @@
  * These routines are used by both DMA-remapping and Interrupt-remapping
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt /* has to precede printk.h */
+
 #include <linux/pci.h>
 #include <linux/dmar.h>
 #include <linux/iova.h>
@@ -39,8 +41,6 @@
 #include <asm/irq_remapping.h>
 #include <asm/iommu_table.h>
 
-#define PREFIX "DMAR: "
-
 /* No locks are needed as DMA remapping hardware unit
  * list is constructed at boot time and hotplug of
  * these units are not supported by the architecture.
@@ -83,15 +83,12 @@ static int __init dmar_parse_one_dev_scope(struct acpi_dmar_device_scope *scope,
 		 * ignore it
 		 */
 		if (!bus) {
-			pr_warn(PREFIX "Device scope bus [%d] not found\n",
-				scope->bus);
+			pr_warn("Device scope bus [%d] not found\n", scope->bus);
 			break;
 		}
 		pdev = pci_get_slot(bus, PCI_DEVFN(path->dev, path->fn));
 		if (!pdev) {
-			pr_warn(PREFIX "Device scope device"
-				"[%04x:%02x:%02x.%02x] not found\n",
-				segment, bus->number, path->dev, path->fn);
+			/* warning will be printed below */
 			break;
 		}
 		path ++;
@@ -99,8 +96,7 @@ static int __init dmar_parse_one_dev_scope(struct acpi_dmar_device_scope *scope,
 		bus = pdev->subordinate;
 	}
 	if (!pdev) {
-		pr_warn(PREFIX
-			"Device scope device [%04x:%02x:%02x.%02x] not found\n",
+		pr_warn("Device scope device [%04x:%02x:%02x.%02x] not found\n",
 			segment, scope->bus, path->dev, path->fn);
 		*dev = NULL;
 		return 0;
@@ -109,8 +105,8 @@ static int __init dmar_parse_one_dev_scope(struct acpi_dmar_device_scope *scope,
 			pdev->subordinate) || (scope->entry_type == \
 			ACPI_DMAR_SCOPE_TYPE_BRIDGE && !pdev->subordinate)) {
 		pci_dev_put(pdev);
-		pr_warn(PREFIX "Device scope type does not match for %s\n",
-			 pci_name(pdev));
+		pr_warn("Device scope type does not match for %s\n",
+			pci_name(pdev));
 		return -EINVAL;
 	}
 	*dev = pdev;
@@ -132,7 +128,7 @@ int __init dmar_parse_dev_scope(void *start, void *end, int *cnt,
 		    scope->entry_type == ACPI_DMAR_SCOPE_TYPE_BRIDGE)
 			(*cnt)++;
 		else if (scope->entry_type != ACPI_DMAR_SCOPE_TYPE_IOAPIC) {
-			pr_warn(PREFIX "Unsupported device scope\n");
+			pr_warn("Unsupported device scope\n");
 		}
 		start += scope->length;
 	}
@@ -258,23 +254,23 @@ dmar_table_print_dmar_entry(struct acpi_dmar_header *header)
 	case ACPI_DMAR_TYPE_HARDWARE_UNIT:
 		drhd = container_of(header, struct acpi_dmar_hardware_unit,
 				    header);
-		pr_info(PREFIX "DRHD base: %#016Lx flags: %#x\n",
+		pr_info("DRHD base: %#016Lx flags: %#x\n",
 			(unsigned long long)drhd->address, drhd->flags);
 		break;
 	case ACPI_DMAR_TYPE_RESERVED_MEMORY:
 		rmrr = container_of(header, struct acpi_dmar_reserved_memory,
 				    header);
-		pr_info(PREFIX "RMRR base: %#016Lx end: %#016Lx\n",
+		pr_info("RMRR base: %#016Lx end: %#016Lx\n",
 			(unsigned long long)rmrr->base_address,
 			(unsigned long long)rmrr->end_address);
 		break;
 	case ACPI_DMAR_TYPE_ATSR:
 		atsr = container_of(header, struct acpi_dmar_atsr, header);
-		pr_info(PREFIX "ATSR flags: %#x\n", atsr->flags);
+		pr_info("ATSR flags: %#x\n", atsr->flags);
 		break;
 	case ACPI_DMAR_HARDWARE_AFFINITY:
 		rhsa = container_of(header, struct acpi_dmar_rhsa, header);
-		pr_info(PREFIX "RHSA base: %#016Lx proximity domain: %#x\n",
+		pr_info("RHSA base: %#016Lx proximity domain: %#x\n",
 		       (unsigned long long)rhsa->base_address,
 		       rhsa->proximity_domain);
 		break;
@@ -294,7 +290,7 @@ static int __init dmar_table_detect(void)
 				&dmar_tbl_size);
 
 	if (ACPI_SUCCESS(status) && !dmar_tbl) {
-		pr_warn(PREFIX "Unable to map DMAR\n");
+		pr_warn("Unable to map DMAR\n");
 		status = AE_NOT_FOUND;
 	}
 
@@ -328,18 +324,18 @@ parse_dmar_table(void)
 		return -ENODEV;
 
 	if (dmar->width < PAGE_SHIFT - 1) {
-		pr_warn(PREFIX "Invalid DMAR haw\n");
+		pr_warn("Invalid DMAR haw\n");
 		return -EINVAL;
 	}
 
-	pr_info(PREFIX "Host address width %d\n", dmar->width + 1);
+	pr_info("Host address width %d\n", dmar->width + 1);
 
 	entry_header = (struct acpi_dmar_header *)(dmar + 1);
 	while (((unsigned long)entry_header) <
 			(((unsigned long)dmar) + dmar_tbl->length)) {
 		/* Avoid looping forever on bad ACPI tables */
 		if (entry_header->length == 0) {
-			pr_warn(PREFIX "Invalid 0-length structure\n");
+			pr_warn("Invalid 0-length structure\n");
 			ret = -EINVAL;
 			break;
 		}
@@ -362,7 +358,7 @@ parse_dmar_table(void)
 #endif
 			break;
 		default:
-			pr_warn(PREFIX "Unknown DMAR structure type %d\n",
+			pr_warn("Unknown DMAR structure type %d\n",
 				entry_header->type);
 			ret = 0; /* for forward compatibility */
 			break;
@@ -461,12 +457,12 @@ int __init dmar_table_init(void)
 	ret = parse_dmar_table();
 	if (ret) {
 		if (ret != -ENODEV)
-			pr_info(PREFIX "parse DMAR table failure.\n");
+			pr_info("parse DMAR table failure.\n");
 		return ret;
 	}
 
 	if (list_empty(&dmar_drhd_units)) {
-		pr_info(PREFIX "No DMAR devices found\n");
+		pr_info("No DMAR devices found\n");
 		return -ENODEV;
 	}
 
@@ -498,7 +494,7 @@ int __init check_zero_address(void)
 			(((unsigned long)dmar) + dmar_tbl->length)) {
 		/* Avoid looping forever on bad ACPI tables */
 		if (entry_header->length == 0) {
-			pr_warn(PREFIX "Invalid 0-length structure\n");
+			pr_warn("Invalid 0-length structure\n");
 			return 0;
 		}
 
@@ -549,8 +545,7 @@ int __init detect_intel_iommu(void)
 
 		if (ret && irq_remapping_enabled && cpu_has_x2apic &&
 		    dmar->flags & 0x1)
-			pr_info("Queued invalidation will be enabled to "
-				"support x2apic and Intr-remapping.\n");
+			pr_info("Queued invalidation will be enabled to support x2apic and Intr-remapping.\n");
 
 		if (ret && !no_iommu && !iommu_detected && !dmar_disabled) {
 			iommu_detected = 1;
@@ -580,9 +575,9 @@ static void unmap_iommu(struct intel_iommu *iommu)
  * map_iommu: map the iommu's registers
  * @iommu: the iommu to map
  * @phys_addr: the physical address of the base resgister
- * 
+ *
  * Memory map the iommu's registers.  Start w/ a single page, and
- * possibly expand if that turns out to be insufficent.  
+ * possibly expand if that turns out to be insufficent.
  */
 static int map_iommu(struct intel_iommu *iommu, u64 phys_addr)
 {
@@ -1302,8 +1297,7 @@ int __init enable_drhd_fault_handling(void)
 		ret = dmar_set_interrupt(iommu);
 
 		if (ret) {
-			pr_err("DRHD %Lx: failed to enable fault, "
-			       " interrupt, ret %d\n",
+			pr_err("DRHD %Lx: failed to enable fault, interrupt, ret %d\n",
 			       (unsigned long long)drhd->reg_base_addr, ret);
 			return -1;
 		}
