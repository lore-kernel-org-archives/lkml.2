Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760967Ab2FDV3X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 17:29:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46506 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760938Ab2FDV3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 17:29:21 -0400
From: Donald Dutile <ddutile@redhat.com>
To: dwmw2@infradead.org
Cc: iommu@lists.linux-foundation.org, mingo@elte.hu,
        linux-kernel@vger.kernel.org, chrisw@redhat.com,
        suresh.b.siddha@intel.com
Subject: [PATCH 1/2] iommu: dmar: replace printks with appropriate pr_*()
Date: Mon,  4 Jun 2012 17:29:01 -0400
Message-Id: <1338845342-12464-2-git-send-email-ddutile@redhat.com>
In-Reply-To: <1338845342-12464-1-git-send-email-ddutile@redhat.com>
References: <1338845342-12464-1-git-send-email-ddutile@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just some cleanup so next patch can keep the info printing
the same way throughout the file.

Replace printk(KERN_*  with pr_*() functions.

Signed-off-by: Donald Dutile <ddutile@redhat.com>
---
 drivers/iommu/dmar.c | 83 ++++++++++++++++++++++------------------------------
 1 file changed, 35 insertions(+), 48 deletions(-)

diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index 3a74e44..1e5a10d 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -83,15 +83,14 @@ static int __init dmar_parse_one_dev_scope(struct acpi_dmar_device_scope *scope,
 		 * ignore it
 		 */
 		if (!bus) {
-			printk(KERN_WARNING
-			PREFIX "Device scope bus [%d] not found\n",
-			scope->bus);
+			pr_warn(PREFIX "Device scope bus [%d] not found\n",
+				scope->bus);
 			break;
 		}
 		pdev = pci_get_slot(bus, PCI_DEVFN(path->dev, path->fn));
 		if (!pdev) {
-			printk(KERN_WARNING PREFIX
-			"Device scope device [%04x:%02x:%02x.%02x] not found\n",
+			pr_warn(PREFIX "Device scope device"
+				"[%04x:%02x:%02x.%02x] not found\n",
 				segment, bus->number, path->dev, path->fn);
 			break;
 		}
@@ -100,9 +99,9 @@ static int __init dmar_parse_one_dev_scope(struct acpi_dmar_device_scope *scope,
 		bus = pdev->subordinate;
 	}
 	if (!pdev) {
-		printk(KERN_WARNING PREFIX
-		"Device scope device [%04x:%02x:%02x.%02x] not found\n",
-		segment, scope->bus, path->dev, path->fn);
+		pr_warn(PREFIX
+			"Device scope device [%04x:%02x:%02x.%02x] not found\n",
+			segment, scope->bus, path->dev, path->fn);
 		*dev = NULL;
 		return 0;
 	}
@@ -110,8 +109,7 @@ static int __init dmar_parse_one_dev_scope(struct acpi_dmar_device_scope *scope,
 			pdev->subordinate) || (scope->entry_type == \
 			ACPI_DMAR_SCOPE_TYPE_BRIDGE && !pdev->subordinate)) {
 		pci_dev_put(pdev);
-		printk(KERN_WARNING PREFIX
-			"Device scope type does not match for %s\n",
+		pr_warn(PREFIX "Device scope type does not match for %s\n",
 			 pci_name(pdev));
 		return -EINVAL;
 	}
@@ -134,8 +132,7 @@ int __init dmar_parse_dev_scope(void *start, void *end, int *cnt,
 		    scope->entry_type == ACPI_DMAR_SCOPE_TYPE_BRIDGE)
 			(*cnt)++;
 		else if (scope->entry_type != ACPI_DMAR_SCOPE_TYPE_IOAPIC) {
-			printk(KERN_WARNING PREFIX
-			       "Unsupported device scope\n");
+			pr_warn(PREFIX "Unsupported device scope\n");
 		}
 		start += scope->length;
 	}
@@ -261,25 +258,23 @@ dmar_table_print_dmar_entry(struct acpi_dmar_header *header)
 	case ACPI_DMAR_TYPE_HARDWARE_UNIT:
 		drhd = container_of(header, struct acpi_dmar_hardware_unit,
 				    header);
-		printk (KERN_INFO PREFIX
-			"DRHD base: %#016Lx flags: %#x\n",
+		pr_info(PREFIX "DRHD base: %#016Lx flags: %#x\n",
 			(unsigned long long)drhd->address, drhd->flags);
 		break;
 	case ACPI_DMAR_TYPE_RESERVED_MEMORY:
 		rmrr = container_of(header, struct acpi_dmar_reserved_memory,
 				    header);
-		printk (KERN_INFO PREFIX
-			"RMRR base: %#016Lx end: %#016Lx\n",
+		pr_info(PREFIX "RMRR base: %#016Lx end: %#016Lx\n",
 			(unsigned long long)rmrr->base_address,
 			(unsigned long long)rmrr->end_address);
 		break;
 	case ACPI_DMAR_TYPE_ATSR:
 		atsr = container_of(header, struct acpi_dmar_atsr, header);
-		printk(KERN_INFO PREFIX "ATSR flags: %#x\n", atsr->flags);
+		pr_info(PREFIX "ATSR flags: %#x\n", atsr->flags);
 		break;
 	case ACPI_DMAR_HARDWARE_AFFINITY:
 		rhsa = container_of(header, struct acpi_dmar_rhsa, header);
-		printk(KERN_INFO PREFIX "RHSA base: %#016Lx proximity domain: %#x\n",
+		pr_info(PREFIX "RHSA base: %#016Lx proximity domain: %#x\n",
 		       (unsigned long long)rhsa->base_address,
 		       rhsa->proximity_domain);
 		break;
@@ -299,7 +294,7 @@ static int __init dmar_table_detect(void)
 				&dmar_tbl_size);
 
 	if (ACPI_SUCCESS(status) && !dmar_tbl) {
-		printk (KERN_WARNING PREFIX "Unable to map DMAR\n");
+		pr_warn(PREFIX "Unable to map DMAR\n");
 		status = AE_NOT_FOUND;
 	}
 
@@ -333,20 +328,18 @@ parse_dmar_table(void)
 		return -ENODEV;
 
 	if (dmar->width < PAGE_SHIFT - 1) {
-		printk(KERN_WARNING PREFIX "Invalid DMAR haw\n");
+		pr_warn(PREFIX "Invalid DMAR haw\n");
 		return -EINVAL;
 	}
 
-	printk (KERN_INFO PREFIX "Host address width %d\n",
-		dmar->width + 1);
+	pr_info(PREFIX "Host address width %d\n", dmar->width + 1);
 
 	entry_header = (struct acpi_dmar_header *)(dmar + 1);
 	while (((unsigned long)entry_header) <
 			(((unsigned long)dmar) + dmar_tbl->length)) {
 		/* Avoid looping forever on bad ACPI tables */
 		if (entry_header->length == 0) {
-			printk(KERN_WARNING PREFIX
-				"Invalid 0-length structure\n");
+			pr_warn(PREFIX "Invalid 0-length structure\n");
 			ret = -EINVAL;
 			break;
 		}
@@ -369,8 +362,7 @@ parse_dmar_table(void)
 #endif
 			break;
 		default:
-			printk(KERN_WARNING PREFIX
-				"Unknown DMAR structure type %d\n",
+			pr_warn(PREFIX "Unknown DMAR structure type %d\n",
 				entry_header->type);
 			ret = 0; /* for forward compatibility */
 			break;
@@ -469,12 +461,12 @@ int __init dmar_table_init(void)
 	ret = parse_dmar_table();
 	if (ret) {
 		if (ret != -ENODEV)
-			printk(KERN_INFO PREFIX "parse DMAR table failure.\n");
+			pr_info(PREFIX "parse DMAR table failure.\n");
 		return ret;
 	}
 
 	if (list_empty(&dmar_drhd_units)) {
-		printk(KERN_INFO PREFIX "No DMAR devices found\n");
+		pr_info(PREFIX "No DMAR devices found\n");
 		return -ENODEV;
 	}
 
@@ -506,8 +498,7 @@ int __init check_zero_address(void)
 			(((unsigned long)dmar) + dmar_tbl->length)) {
 		/* Avoid looping forever on bad ACPI tables */
 		if (entry_header->length == 0) {
-			printk(KERN_WARNING PREFIX
-				"Invalid 0-length structure\n");
+			pr_warn(PREFIX "Invalid 0-length structure\n");
 			return 0;
 		}
 
@@ -558,8 +549,8 @@ int __init detect_intel_iommu(void)
 
 		if (ret && irq_remapping_enabled && cpu_has_x2apic &&
 		    dmar->flags & 0x1)
-			printk(KERN_INFO
-			       "Queued invalidation will be enabled to support x2apic and Intr-remapping.\n");
+			pr_info("Queued invalidation will be enabled to "
+				"support x2apic and Intr-remapping.\n");
 
 		if (ret && !no_iommu && !iommu_detected && !dmar_disabled) {
 			iommu_detected = 1;
@@ -602,7 +593,7 @@ int alloc_iommu(struct dmar_drhd_unit *drhd)
 
 	iommu->reg = ioremap(drhd->reg_base_addr, VTD_PAGE_SIZE);
 	if (!iommu->reg) {
-		printk(KERN_ERR "IOMMU: can't map the region\n");
+		pr_err("IOMMU: can't map the region\n");
 		goto error;
 	}
 	iommu->cap = dmar_readq(iommu->reg + DMAR_CAP_REG);
@@ -615,15 +606,13 @@ int alloc_iommu(struct dmar_drhd_unit *drhd)
 
 	agaw = iommu_calculate_agaw(iommu);
 	if (agaw < 0) {
-		printk(KERN_ERR
-		       "Cannot get a valid agaw for iommu (seq_id = %d)\n",
-		       iommu->seq_id);
+		pr_err("Cannot get a valid agaw for iommu (seq_id = %d)\n",
+			iommu->seq_id);
 		goto err_unmap;
 	}
 	msagaw = iommu_calculate_max_sagaw(iommu);
 	if (msagaw < 0) {
-		printk(KERN_ERR
-			"Cannot get a valid max agaw for iommu (seq_id = %d)\n",
+		pr_err("Cannot get a valid max agaw for iommu (seq_id = %d)\n",
 			iommu->seq_id);
 		goto err_unmap;
 	}
@@ -640,7 +629,7 @@ int alloc_iommu(struct dmar_drhd_unit *drhd)
 		iounmap(iommu->reg);
 		iommu->reg = ioremap(drhd->reg_base_addr, map_size);
 		if (!iommu->reg) {
-			printk(KERN_ERR "IOMMU: can't map the region\n");
+			pr_err("IOMMU: can't map the region\n");
 			goto error;
 		}
 	}
@@ -710,7 +699,7 @@ static int qi_check_fault(struct intel_iommu *iommu, int index)
 	if (fault & DMA_FSTS_IQE) {
 		head = readl(iommu->reg + DMAR_IQH_REG);
 		if ((head >> DMAR_IQ_SHIFT) == index) {
-			printk(KERN_ERR "VT-d detected invalid descriptor: "
+			pr_err("VT-d detected invalid descriptor: "
 				"low=%llx, high=%llx\n",
 				(unsigned long long)qi->desc[index].low,
 				(unsigned long long)qi->desc[index].high);
@@ -1129,15 +1118,14 @@ static int dmar_fault_do_one(struct intel_iommu *iommu, int type,
 	reason = dmar_get_fault_reason(fault_reason, &fault_type);
 
 	if (fault_type == INTR_REMAP)
-		printk(KERN_ERR "INTR-REMAP: Request device [[%02x:%02x.%d] "
+		pr_err("INTR-REMAP: Request device [[%02x:%02x.%d] "
 		       "fault index %llx\n"
 			"INTR-REMAP:[fault reason %02d] %s\n",
 			(source_id >> 8), PCI_SLOT(source_id & 0xFF),
 			PCI_FUNC(source_id & 0xFF), addr >> 48,
 			fault_reason, reason);
 	else
-		printk(KERN_ERR
-		       "DMAR:[%s] Request device [%02x:%02x.%d] "
+		pr_err("DMAR:[%s] Request device [%02x:%02x.%d] "
 		       "fault addr %llx \n"
 		       "DMAR:[fault reason %02d] %s\n",
 		       (type ? "DMA Read" : "DMA Write"),
@@ -1157,8 +1145,7 @@ irqreturn_t dmar_fault(int irq, void *dev_id)
 	raw_spin_lock_irqsave(&iommu->register_lock, flag);
 	fault_status = readl(iommu->reg + DMAR_FSTS_REG);
 	if (fault_status)
-		printk(KERN_ERR "DRHD: handling fault status reg %x\n",
-		       fault_status);
+		pr_err("DRHD: handling fault status reg %x\n", fault_status);
 
 	/* TBD: ignore advanced fault log currently */
 	if (!(fault_status & DMA_FSTS_PPF))
@@ -1224,7 +1211,7 @@ int dmar_set_interrupt(struct intel_iommu *iommu)
 
 	irq = create_irq();
 	if (!irq) {
-		printk(KERN_ERR "IOMMU: no free vectors\n");
+		pr_err("IOMMU: no free vectors\n");
 		return -EINVAL;
 	}
 
@@ -1241,7 +1228,7 @@ int dmar_set_interrupt(struct intel_iommu *iommu)
 
 	ret = request_irq(irq, dmar_fault, IRQF_NO_THREAD, iommu->name, iommu);
 	if (ret)
-		printk(KERN_ERR "IOMMU: can't request irq\n");
+		pr_err("IOMMU: can't request irq\n");
 	return ret;
 }
 
@@ -1258,7 +1245,7 @@ int __init enable_drhd_fault_handling(void)
 		ret = dmar_set_interrupt(iommu);
 
 		if (ret) {
-			printk(KERN_ERR "DRHD %Lx: failed to enable fault, "
+			pr_err("DRHD %Lx: failed to enable fault, "
 			       " interrupt, ret %d\n",
 			       (unsigned long long)drhd->reg_base_addr, ret);
 			return -1;
-- 
1.7.10.2.552.gaa3bb87

