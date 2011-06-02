Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932337Ab1FBFvy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 01:51:54 -0400
Received: from mail.perches.com ([173.55.12.10]:2424 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755509Ab1FBFvt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 01:51:49 -0400
From: Joe Perches <joe@perches.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Scott Murray <scott@spiteful.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org
Subject: [PATCH] pci: Use pr_<level> and pr_fmt
Date: Wed,  1 Jun 2011 22:51:18 -0700
Message-Id: <2d216bab12e307fc550aefdaec0302ee97917ae4.1306993815.git.joe@perches.com>
X-Mailer: git-send-email 1.7.5.rc3.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the current logging message styles.

Convert the dbg and debug macros to alway have a terminating \n.
Remove err, warn, and info macros, use pr_<level>.
Add pr_fmt as appropriate.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/pci/dmar.c                      |  116 ++++-----
 drivers/pci/hotplug/acpi_pcihp.c        |   36 ++--
 drivers/pci/hotplug/acpiphp.h           |   12 +-
 drivers/pci/hotplug/acpiphp_core.c      |   30 ++-
 drivers/pci/hotplug/acpiphp_glue.c      |   90 +++---
 drivers/pci/hotplug/acpiphp_ibm.c       |   48 ++--
 drivers/pci/hotplug/cpci_hotplug_core.c |  137 +++++-----
 drivers/pci/hotplug/cpci_hotplug_pci.c  |   51 ++--
 drivers/pci/hotplug/cpcihp_generic.c    |   60 ++--
 drivers/pci/hotplug/cpcihp_zt5550.c     |   62 ++--
 drivers/pci/hotplug/cpqphp.h            |   27 +-
 drivers/pci/hotplug/cpqphp_core.c       |  140 +++++-----
 drivers/pci/hotplug/cpqphp_ctrl.c       |   88 ++++---
 drivers/pci/hotplug/cpqphp_nvram.c      |   20 +-
 drivers/pci/hotplug/cpqphp_pci.c        |   48 ++--
 drivers/pci/hotplug/ibmphp.h            |   16 +-
 drivers/pci/hotplug/ibmphp_core.c       |  174 ++++++------
 drivers/pci/hotplug/ibmphp_ebda.c       |  224 +++++++++------
 drivers/pci/hotplug/ibmphp_hpc.c        |  132 +++++----
 drivers/pci/hotplug/ibmphp_pci.c        |  458 ++++++++++++++++++-------------
 drivers/pci/hotplug/ibmphp_res.c        |  178 +++++++-----
 drivers/pci/hotplug/pci_hotplug_core.c  |   27 +-
 drivers/pci/hotplug/pciehp.h            |    8 +-
 drivers/pci/hotplug/pciehp_acpi.c       |    8 +-
 drivers/pci/hotplug/pciehp_core.c       |   10 +-
 drivers/pci/hotplug/pciehp_ctrl.c       |   12 +-
 drivers/pci/hotplug/pciehp_pci.c        |    6 +-
 drivers/pci/hotplug/pcihp_skeleton.c    |   37 ++--
 drivers/pci/hotplug/rpadlpar_core.c     |   43 ++--
 drivers/pci/hotplug/rpaphp.h            |   12 +-
 drivers/pci/hotplug/rpaphp_core.c       |   12 +-
 drivers/pci/hotplug/rpaphp_pci.c        |   19 +-
 drivers/pci/hotplug/rpaphp_slot.c       |   22 +-
 drivers/pci/hotplug/sgi_hotplug.c       |   15 +-
 drivers/pci/hotplug/shpchp.h            |   24 +-
 drivers/pci/hotplug/shpchp_core.c       |    6 +-
 drivers/pci/hotplug/shpchp_ctrl.c       |   12 +-
 drivers/pci/intel-iommu.c               |  137 ++++-----
 drivers/pci/intr_remapping.c            |   43 ++--
 drivers/pci/iova.c                      |    6 +-
 drivers/pci/pci-acpi.c                  |    6 +-
 drivers/pci/pci-stub.c                  |   14 +-
 drivers/pci/pci-sysfs.c                 |    6 +-
 drivers/pci/pci.c                       |    9 +-
 drivers/pci/pcie/aer/aer_inject.c       |   10 +-
 drivers/pci/pcie/aer/aerdrv_errprint.c  |   81 +++---
 drivers/pci/pcie/aspm.c                 |    6 +-
 drivers/pci/pcie/portdrv_pci.c          |    6 +-
 drivers/pci/probe.c                     |    9 +-
 drivers/pci/quirks.c                    |   17 +-
 drivers/pci/setup-bus.c                 |   13 +-
 drivers/pci/slot.c                      |    4 +-
 drivers/pci/xen-pcifront.c              |   10 +-
 53 files changed, 1490 insertions(+), 1307 deletions(-)

diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
index 3dc9bef..c1e298c 100644
--- a/drivers/pci/dmar.c
+++ b/drivers/pci/dmar.c
@@ -26,6 +26,8 @@
  * These routines are used by both DMA-remapping and Interrupt-remapping
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/pci.h>
 #include <linux/dmar.h>
 #include <linux/iova.h>
@@ -38,8 +40,6 @@
 #include <linux/slab.h>
 #include <asm/iommu_table.h>
 
-#define PREFIX "DMAR: "
-
 /* No locks are needed as DMA remapping hardware unit
  * list is constructed at boot time and hotplug of
  * these units are not supported by the architecture.
@@ -82,15 +82,13 @@ static int __init dmar_parse_one_dev_scope(struct acpi_dmar_device_scope *scope,
 		 * ignore it
 		 */
 		if (!bus) {
-			printk(KERN_WARNING
-			PREFIX "Device scope bus [%d] not found\n",
-			scope->bus);
+			pr_warn("Device scope bus [%d] not found\n",
+				scope->bus);
 			break;
 		}
 		pdev = pci_get_slot(bus, PCI_DEVFN(path->dev, path->fn));
 		if (!pdev) {
-			printk(KERN_WARNING PREFIX
-			"Device scope device [%04x:%02x:%02x.%02x] not found\n",
+			pr_warn("Device scope device [%04x:%02x:%02x.%02x] not found\n",
 				segment, bus->number, path->dev, path->fn);
 			break;
 		}
@@ -99,9 +97,8 @@ static int __init dmar_parse_one_dev_scope(struct acpi_dmar_device_scope *scope,
 		bus = pdev->subordinate;
 	}
 	if (!pdev) {
-		printk(KERN_WARNING PREFIX
-		"Device scope device [%04x:%02x:%02x.%02x] not found\n",
-		segment, scope->bus, path->dev, path->fn);
+		pr_warn("Device scope device [%04x:%02x:%02x.%02x] not found\n",
+			segment, scope->bus, path->dev, path->fn);
 		*dev = NULL;
 		return 0;
 	}
@@ -109,9 +106,8 @@ static int __init dmar_parse_one_dev_scope(struct acpi_dmar_device_scope *scope,
 			pdev->subordinate) || (scope->entry_type == \
 			ACPI_DMAR_SCOPE_TYPE_BRIDGE && !pdev->subordinate)) {
 		pci_dev_put(pdev);
-		printk(KERN_WARNING PREFIX
-			"Device scope type does not match for %s\n",
-			 pci_name(pdev));
+		pr_warn("Device scope type does not match for %s\n",
+			pci_name(pdev));
 		return -EINVAL;
 	}
 	*dev = pdev;
@@ -133,8 +129,7 @@ static int __init dmar_parse_dev_scope(void *start, void *end, int *cnt,
 		    scope->entry_type == ACPI_DMAR_SCOPE_TYPE_BRIDGE)
 			(*cnt)++;
 		else if (scope->entry_type != ACPI_DMAR_SCOPE_TYPE_IOAPIC) {
-			printk(KERN_WARNING PREFIX
-			       "Unsupported device scope\n");
+			pr_warn("Unsupported device scope\n");
 		}
 		start += scope->length;
 	}
@@ -387,27 +382,25 @@ dmar_table_print_dmar_entry(struct acpi_dmar_header *header)
 	case ACPI_DMAR_TYPE_HARDWARE_UNIT:
 		drhd = container_of(header, struct acpi_dmar_hardware_unit,
 				    header);
-		printk (KERN_INFO PREFIX
-			"DRHD base: %#016Lx flags: %#x\n",
+		pr_info("DRHD base: %#016llx flags: %#x\n",
 			(unsigned long long)drhd->address, drhd->flags);
 		break;
 	case ACPI_DMAR_TYPE_RESERVED_MEMORY:
 		rmrr = container_of(header, struct acpi_dmar_reserved_memory,
 				    header);
-		printk (KERN_INFO PREFIX
-			"RMRR base: %#016Lx end: %#016Lx\n",
+		pr_info("RMRR base: %#016llx end: %#016Lx\n",
 			(unsigned long long)rmrr->base_address,
 			(unsigned long long)rmrr->end_address);
 		break;
 	case ACPI_DMAR_TYPE_ATSR:
 		atsr = container_of(header, struct acpi_dmar_atsr, header);
-		printk(KERN_INFO PREFIX "ATSR flags: %#x\n", atsr->flags);
+		pr_info("ATSR flags: %#x\n", atsr->flags);
 		break;
 	case ACPI_DMAR_HARDWARE_AFFINITY:
 		rhsa = container_of(header, struct acpi_dmar_rhsa, header);
-		printk(KERN_INFO PREFIX "RHSA base: %#016Lx proximity domain: %#x\n",
-		       (unsigned long long)rhsa->base_address,
-		       rhsa->proximity_domain);
+		pr_info("RHSA base: %#016llx proximity domain: %#x\n",
+			(unsigned long long)rhsa->base_address,
+			rhsa->proximity_domain);
 		break;
 	}
 }
@@ -425,7 +418,7 @@ static int __init dmar_table_detect(void)
 				&dmar_tbl_size);
 
 	if (ACPI_SUCCESS(status) && !dmar_tbl) {
-		printk (KERN_WARNING PREFIX "Unable to map DMAR\n");
+		pr_warn("Unable to map DMAR\n");
 		status = AE_NOT_FOUND;
 	}
 
@@ -459,20 +452,18 @@ parse_dmar_table(void)
 		return -ENODEV;
 
 	if (dmar->width < PAGE_SHIFT - 1) {
-		printk(KERN_WARNING PREFIX "Invalid DMAR haw\n");
+		pr_warn("Invalid DMAR haw\n");
 		return -EINVAL;
 	}
 
-	printk (KERN_INFO PREFIX "Host address width %d\n",
-		dmar->width + 1);
+	pr_info("Host address width %d\n", dmar->width + 1);
 
 	entry_header = (struct acpi_dmar_header *)(dmar + 1);
 	while (((unsigned long)entry_header) <
 			(((unsigned long)dmar) + dmar_tbl->length)) {
 		/* Avoid looping forever on bad ACPI tables */
 		if (entry_header->length == 0) {
-			printk(KERN_WARNING PREFIX
-				"Invalid 0-length structure\n");
+			pr_warn("Invalid 0-length structure\n");
 			ret = -EINVAL;
 			break;
 		}
@@ -499,8 +490,7 @@ parse_dmar_table(void)
 #endif
 			break;
 		default:
-			printk(KERN_WARNING PREFIX
-				"Unknown DMAR structure type %d\n",
+			pr_warn("Unknown DMAR structure type %d\n",
 				entry_header->type);
 			ret = 0; /* for forward compatibility */
 			break;
@@ -602,21 +592,21 @@ int __init dmar_table_init(void)
 	ret = parse_dmar_table();
 	if (ret) {
 		if (ret != -ENODEV)
-			printk(KERN_INFO PREFIX "parse DMAR table failure.\n");
+			pr_info("parse DMAR table failure\n");
 		return ret;
 	}
 
 	if (list_empty(&dmar_drhd_units)) {
-		printk(KERN_INFO PREFIX "No DMAR devices found\n");
+		pr_info("No DMAR devices found\n");
 		return -ENODEV;
 	}
 
 #ifdef CONFIG_DMAR
 	if (list_empty(&dmar_rmrr_units))
-		printk(KERN_INFO PREFIX "No RMRR found\n");
+		pr_info("No RMRR found\n");
 
 	if (list_empty(&dmar_atsr_units))
-		printk(KERN_INFO PREFIX "No ATSR found\n");
+		pr_info("No ATSR found\n");
 #endif
 
 	return 0;
@@ -647,8 +637,7 @@ int __init check_zero_address(void)
 			(((unsigned long)dmar) + dmar_tbl->length)) {
 		/* Avoid looping forever on bad ACPI tables */
 		if (entry_header->length == 0) {
-			printk(KERN_WARNING PREFIX
-				"Invalid 0-length structure\n");
+			pr_warn("Invalid 0-length structure\n");
 			return 0;
 		}
 
@@ -664,7 +653,8 @@ int __init check_zero_address(void)
 
 			addr = early_ioremap(drhd->address, VTD_PAGE_SIZE);
 			if (!addr ) {
-				printk("IOMMU: can't validate: %llx\n", drhd->address);
+				pr_err("IOMMU: can't validate: %llx\n",
+				       drhd->address);
 				goto failed;
 			}
 			cap = dmar_readq(addr + DMAR_CAP_REG);
@@ -701,9 +691,7 @@ int __init detect_intel_iommu(void)
 
 		dmar = (struct acpi_table_dmar *) dmar_tbl;
 		if (ret && cpu_has_x2apic && dmar->flags & 0x1)
-			printk(KERN_INFO
-			       "Queued invalidation will be enabled to support "
-			       "x2apic and Intr-remapping.\n");
+			pr_info("Queued invalidation will be enabled to support x2apic and Intr-remapping\n");
 #endif
 #ifdef CONFIG_DMAR
 		if (ret && !no_iommu && !iommu_detected && !dmar_disabled) {
@@ -747,7 +735,7 @@ int alloc_iommu(struct dmar_drhd_unit *drhd)
 
 	iommu->reg = ioremap(drhd->reg_base_addr, VTD_PAGE_SIZE);
 	if (!iommu->reg) {
-		printk(KERN_ERR "IOMMU: can't map the region\n");
+		pr_err("IOMMU: can't map the region\n");
 		goto error;
 	}
 	iommu->cap = dmar_readq(iommu->reg + DMAR_CAP_REG);
@@ -761,16 +749,14 @@ int alloc_iommu(struct dmar_drhd_unit *drhd)
 #ifdef CONFIG_DMAR
 	agaw = iommu_calculate_agaw(iommu);
 	if (agaw < 0) {
-		printk(KERN_ERR
-		       "Cannot get a valid agaw for iommu (seq_id = %d)\n",
+		pr_err("Cannot get a valid agaw for iommu (seq_id = %d)\n",
 		       iommu->seq_id);
 		goto err_unmap;
 	}
 	msagaw = iommu_calculate_max_sagaw(iommu);
 	if (msagaw < 0) {
-		printk(KERN_ERR
-			"Cannot get a valid max agaw for iommu (seq_id = %d)\n",
-			iommu->seq_id);
+		pr_err("Cannot get a valid max agaw for iommu (seq_id = %d)\n",
+		       iommu->seq_id);
 		goto err_unmap;
 	}
 #endif
@@ -787,7 +773,7 @@ int alloc_iommu(struct dmar_drhd_unit *drhd)
 		iounmap(iommu->reg);
 		iommu->reg = ioremap(drhd->reg_base_addr, map_size);
 		if (!iommu->reg) {
-			printk(KERN_ERR "IOMMU: can't map the region\n");
+			pr_err("IOMMU: can't map the region\n");
 			goto error;
 		}
 	}
@@ -859,10 +845,9 @@ static int qi_check_fault(struct intel_iommu *iommu, int index)
 	if (fault & DMA_FSTS_IQE) {
 		head = readl(iommu->reg + DMAR_IQH_REG);
 		if ((head >> DMAR_IQ_SHIFT) == index) {
-			printk(KERN_ERR "VT-d detected invalid descriptor: "
-				"low=%llx, high=%llx\n",
-				(unsigned long long)qi->desc[index].low,
-				(unsigned long long)qi->desc[index].high);
+			pr_err("VT-d detected invalid descriptor: low=%llx, high=%llx\n",
+			       (unsigned long long)qi->desc[index].low,
+			       (unsigned long long)qi->desc[index].high);
 			memcpy(&qi->desc[index], &qi->desc[wait_index],
 					sizeof(struct qi_desc));
 			__iommu_flush_cache(iommu, &qi->desc[index],
@@ -1278,17 +1263,14 @@ static int dmar_fault_do_one(struct intel_iommu *iommu, int type,
 	reason = dmar_get_fault_reason(fault_reason, &fault_type);
 
 	if (fault_type == INTR_REMAP)
-		printk(KERN_ERR "INTR-REMAP: Request device [[%02x:%02x.%d] "
-		       "fault index %llx\n"
-			"INTR-REMAP:[fault reason %02d] %s\n",
-			(source_id >> 8), PCI_SLOT(source_id & 0xFF),
-			PCI_FUNC(source_id & 0xFF), addr >> 48,
-			fault_reason, reason);
+		pr_err("INTR-REMAP: Request device [[%02x:%02x.%d] fault index %llx\n"
+		       "INTR-REMAP:[fault reason %02d] %s\n",
+		       (source_id >> 8), PCI_SLOT(source_id & 0xFF),
+		       PCI_FUNC(source_id & 0xFF), addr >> 48,
+		       fault_reason, reason);
 	else
-		printk(KERN_ERR
-		       "DMAR:[%s] Request device [%02x:%02x.%d] "
-		       "fault addr %llx \n"
-		       "DMAR:[fault reason %02d] %s\n",
+		pr_err("[%s] Request device [%02x:%02x.%d] fault addr %llx\n"
+		       "[fault reason %02d] %s\n",
 		       (type ? "DMA Read" : "DMA Write"),
 		       (source_id >> 8), PCI_SLOT(source_id & 0xFF),
 		       PCI_FUNC(source_id & 0xFF), addr, fault_reason, reason);
@@ -1306,8 +1288,7 @@ irqreturn_t dmar_fault(int irq, void *dev_id)
 	spin_lock_irqsave(&iommu->register_lock, flag);
 	fault_status = readl(iommu->reg + DMAR_FSTS_REG);
 	if (fault_status)
-		printk(KERN_ERR "DRHD: handling fault status reg %x\n",
-		       fault_status);
+		pr_err("DRHD: handling fault status reg %x\n", fault_status);
 
 	/* TBD: ignore advanced fault log currently */
 	if (!(fault_status & DMA_FSTS_PPF))
@@ -1373,7 +1354,7 @@ int dmar_set_interrupt(struct intel_iommu *iommu)
 
 	irq = create_irq();
 	if (!irq) {
-		printk(KERN_ERR "IOMMU: no free vectors\n");
+		pr_err("IOMMU: no free vectors\n");
 		return -EINVAL;
 	}
 
@@ -1390,7 +1371,7 @@ int dmar_set_interrupt(struct intel_iommu *iommu)
 
 	ret = request_irq(irq, dmar_fault, 0, iommu->name, iommu);
 	if (ret)
-		printk(KERN_ERR "IOMMU: can't request irq\n");
+		pr_err("IOMMU: can't request irq\n");
 	return ret;
 }
 
@@ -1407,8 +1388,7 @@ int __init enable_drhd_fault_handling(void)
 		ret = dmar_set_interrupt(iommu);
 
 		if (ret) {
-			printk(KERN_ERR "DRHD %Lx: failed to enable fault, "
-			       " interrupt, ret %d\n",
+			pr_err("DRHD %llx: failed to enable fault, interrupt, ret %d\n",
 			       (unsigned long long)drhd->reg_base_addr, ret);
 			return -1;
 		}
diff --git a/drivers/pci/hotplug/acpi_pcihp.c b/drivers/pci/hotplug/acpi_pcihp.c
index 8f3faf3..e338b1c 100644
--- a/drivers/pci/hotplug/acpi_pcihp.c
+++ b/drivers/pci/hotplug/acpi_pcihp.c
@@ -24,6 +24,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/kernel.h>
@@ -36,10 +38,11 @@
 
 #define MY_NAME	"acpi_pcihp"
 
-#define dbg(fmt, arg...) do { if (debug_acpi) printk(KERN_DEBUG "%s: %s: " fmt , MY_NAME , __func__ , ## arg); } while (0)
-#define err(format, arg...) printk(KERN_ERR "%s: " format , MY_NAME , ## arg)
-#define info(format, arg...) printk(KERN_INFO "%s: " format , MY_NAME , ## arg)
-#define warn(format, arg...) printk(KERN_WARNING "%s: " format , MY_NAME , ## arg)
+#define dbg(fmt, arg...)				\
+do {							\
+	if (debug_acpi)					\
+		pr_debug("%s: " fmt, __func__, ##arg);	\
+} while (0)
 
 #define	METHOD_NAME__SUN	"_SUN"
 #define	METHOD_NAME_OSHP	"OSHP"
@@ -68,9 +71,8 @@ decode_type0_hpx_record(union acpi_object *record, struct hotplug_params *hpx)
 		hpx->t0->enable_perr     = fields[5].integer.value;
 		break;
 	default:
-		printk(KERN_WARNING
-		       "%s: Type 0 Revision %d record not supported\n",
-		       __func__, revision);
+		pr_warn("%s: Type 0 Revision %d record not supported\n",
+			__func__, revision);
 		return AE_ERROR;
 	}
 	return AE_OK;
@@ -97,9 +99,8 @@ decode_type1_hpx_record(union acpi_object *record, struct hotplug_params *hpx)
 		hpx->t1->tot_max_split = fields[4].integer.value;
 		break;
 	default:
-		printk(KERN_WARNING
-		       "%s: Type 1 Revision %d record not supported\n",
-		       __func__, revision);
+		pr_warn("%s: Type 1 Revision %d record not supported\n",
+			__func__, revision);
 		return AE_ERROR;
 	}
 	return AE_OK;
@@ -139,9 +140,8 @@ decode_type2_hpx_record(union acpi_object *record, struct hotplug_params *hpx)
 		hpx->t2->sec_unc_err_mask_or   = fields[17].integer.value;
 		break;
 	default:
-		printk(KERN_WARNING
-		       "%s: Type 2 Revision %d record not supported\n",
-		       __func__, revision);
+		pr_warn("%s: Type 2 Revision %d record not supported\n",
+			__func__, revision);
 		return AE_ERROR;
 	}
 	return AE_OK;
@@ -201,7 +201,7 @@ acpi_run_hpx(acpi_handle handle, struct hotplug_params *hpx)
 				goto exit;
 			break;
 		default:
-			printk(KERN_ERR "%s: Type %d record not supported\n",
+			pr_err("%s: Type %d record not supported\n",
 			       __func__, type);
 			status = AE_ERROR;
 			goto exit;
@@ -270,7 +270,7 @@ static acpi_status acpi_run_oshp(acpi_handle handle)
 	status = acpi_evaluate_object(handle, METHOD_NAME_OSHP, NULL, NULL);
 	if (ACPI_FAILURE(status))
 		if (status != AE_NOT_FOUND)
-			printk(KERN_ERR "%s:%s OSHP fails=0x%x\n",
+			pr_err("%s:%s OSHP fails=0x%x\n",
 			       __func__, (char *)string.pointer, status);
 		else
 			dbg("%s:%s OSHP not found\n",
@@ -340,7 +340,7 @@ int acpi_get_hp_hw_control_from_firmware(struct pci_dev *pdev, u32 flags)
 
 	flags &= OSC_SHPC_NATIVE_HP_CONTROL;
 	if (!flags) {
-		err("Invalid flags %u specified!\n", flags);
+		pr_err("Invalid flags %u specified!\n", flags);
 		return -EINVAL;
 	}
 
@@ -357,7 +357,7 @@ int acpi_get_hp_hw_control_from_firmware(struct pci_dev *pdev, u32 flags)
 	if (handle) {
 		acpi_get_name(handle, ACPI_FULL_PATHNAME, &string);
 		dbg("Trying to get hotplug control for %s\n",
-				(char *)string.pointer);
+		    (char *)string.pointer);
 		status = acpi_pci_osc_control_set(handle, &flags, flags);
 		if (ACPI_SUCCESS(status))
 			goto got_one;
@@ -383,7 +383,7 @@ int acpi_get_hp_hw_control_from_firmware(struct pci_dev *pdev, u32 flags)
 
 	while (handle) {
 		acpi_get_name(handle, ACPI_FULL_PATHNAME, &string);
-		dbg("Trying to get hotplug control for %s \n",
+		dbg("Trying to get hotplug control for %s\n",
 		    (char *)string.pointer);
 		status = acpi_run_oshp(handle);
 		if (ACPI_SUCCESS(status))
diff --git a/drivers/pci/hotplug/acpiphp.h b/drivers/pci/hotplug/acpiphp.h
index 7722108..4901e06 100644
--- a/drivers/pci/hotplug/acpiphp.h
+++ b/drivers/pci/hotplug/acpiphp.h
@@ -40,14 +40,10 @@
 #include <linux/pci_hotplug.h>
 
 #define dbg(format, arg...)					\
-	do {							\
-		if (acpiphp_debug)				\
-			printk(KERN_DEBUG "%s: " format,	\
-				MY_NAME , ## arg);		\
-	} while (0)
-#define err(format, arg...) printk(KERN_ERR "%s: " format, MY_NAME , ## arg)
-#define info(format, arg...) printk(KERN_INFO "%s: " format, MY_NAME , ## arg)
-#define warn(format, arg...) printk(KERN_WARNING "%s: " format, MY_NAME , ## arg)
+do {								\
+	if (acpiphp_debug)					\
+		pr_debug(format, ##arg);			\
+} while (0)
 
 struct acpiphp_bridge;
 struct acpiphp_slot;
diff --git a/drivers/pci/hotplug/acpiphp_core.c b/drivers/pci/hotplug/acpiphp_core.c
index efa9f2d..25dba60 100644
--- a/drivers/pci/hotplug/acpiphp_core.c
+++ b/drivers/pci/hotplug/acpiphp_core.c
@@ -31,6 +31,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
@@ -137,7 +139,7 @@ static int enable_slot(struct hotplug_slot *hotplug_slot)
 {
 	struct slot *slot = hotplug_slot->private;
 
-	dbg("%s - physical_slot = %s\n", __func__, slot_name(slot));
+	dbg("%s: physical_slot = %s\n", __func__, slot_name(slot));
 
 	/* enable the specified slot */
 	return acpiphp_enable_slot(slot->acpi_slot);
@@ -155,7 +157,7 @@ static int disable_slot(struct hotplug_slot *hotplug_slot)
 	struct slot *slot = hotplug_slot->private;
 	int retval;
 
-	dbg("%s - physical_slot = %s\n", __func__, slot_name(slot));
+	dbg("%s: physical_slot = %s\n", __func__, slot_name(slot));
 
 	/* disable the specified slot */
 	retval = acpiphp_disable_slot(slot->acpi_slot);
@@ -178,7 +180,8 @@ static int disable_slot(struct hotplug_slot *hotplug_slot)
  {
 	int retval = -ENODEV;
 
-	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot_name(hotplug_slot));
+	dbg("%s: physical_slot = %s\n",
+	    __func__, hotplug_slot_name(hotplug_slot));
  
 	if (attention_info && try_module_get(attention_info->owner)) {
 		retval = attention_info->set_attn(hotplug_slot, status);
@@ -201,7 +204,7 @@ static int get_power_status(struct hotplug_slot *hotplug_slot, u8 *value)
 {
 	struct slot *slot = hotplug_slot->private;
 
-	dbg("%s - physical_slot = %s\n", __func__, slot_name(slot));
+	dbg("%s: physical_slot = %s\n", __func__, slot_name(slot));
 
 	*value = acpiphp_get_power_status(slot->acpi_slot);
 
@@ -223,7 +226,8 @@ static int get_attention_status(struct hotplug_slot *hotplug_slot, u8 *value)
 {
 	int retval = -EINVAL;
 
-	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot_name(hotplug_slot));
+	dbg("%s: physical_slot = %s\n",
+	    __func__, hotplug_slot_name(hotplug_slot));
 
 	if (attention_info && try_module_get(attention_info->owner)) {
 		retval = attention_info->get_attn(hotplug_slot, value);
@@ -246,7 +250,7 @@ static int get_latch_status(struct hotplug_slot *hotplug_slot, u8 *value)
 {
 	struct slot *slot = hotplug_slot->private;
 
-	dbg("%s - physical_slot = %s\n", __func__, slot_name(slot));
+	dbg("%s: physical_slot = %s\n", __func__, slot_name(slot));
 
 	*value = acpiphp_get_latch_status(slot->acpi_slot);
 
@@ -266,7 +270,7 @@ static int get_adapter_status(struct hotplug_slot *hotplug_slot, u8 *value)
 {
 	struct slot *slot = hotplug_slot->private;
 
-	dbg("%s - physical_slot = %s\n", __func__, slot_name(slot));
+	dbg("%s: physical_slot = %s\n", __func__, slot_name(slot));
 
 	*value = acpiphp_get_adapter_status(slot->acpi_slot);
 
@@ -300,7 +304,7 @@ static void release_slot(struct hotplug_slot *hotplug_slot)
 {
 	struct slot *slot = hotplug_slot->private;
 
-	dbg("%s - physical_slot = %s\n", __func__, slot_name(slot));
+	dbg("%s: physical_slot = %s\n", __func__, slot_name(slot));
 
 	kfree(slot->hotplug_slot);
 	kfree(slot);
@@ -343,11 +347,11 @@ int acpiphp_register_hotplug_slot(struct acpiphp_slot *acpiphp_slot)
 	if (retval == -EBUSY)
 		goto error_hpslot;
 	if (retval) {
-		err("pci_hp_register failed with error %d\n", retval);
+		pr_err("pci_hp_register failed with error %d\n", retval);
 		goto error_hpslot;
  	}
 
-	info("Slot [%s] registered\n", slot_name(slot));
+	pr_info("Slot [%s] registered\n", slot_name(slot));
 
 	return 0;
 error_hpslot:
@@ -364,17 +368,17 @@ void acpiphp_unregister_hotplug_slot(struct acpiphp_slot *acpiphp_slot)
 	struct slot *slot = acpiphp_slot->slot;
 	int retval = 0;
 
-	info("Slot [%s] unregistered\n", slot_name(slot));
+	pr_info("Slot [%s] unregistered\n", slot_name(slot));
 
 	retval = pci_hp_deregister(slot->hotplug_slot);
 	if (retval)
-		err("pci_hp_deregister failed with error %d\n", retval);
+		pr_err("pci_hp_deregister failed with error %d\n", retval);
 }
 
 
 static int __init acpiphp_init(void)
 {
-	info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
+	pr_info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
 
 	if (acpi_pci_disabled)
 		return 0;
diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index a70fa89..1e196bf 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -39,6 +39,8 @@
  *    bus. It loses the refcount when the the driver unloads.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/init.h>
 #include <linux/module.h>
 
@@ -171,7 +173,7 @@ register_slot(acpi_handle handle, u32 lvl, void *context, void **rv)
 	for (slot = bridge->slots; slot; slot = slot->next)
 		if (slot->device == device) {
 			if (slot->sun != sun)
-				warn("sibling found, but _SUN doesn't match!\n");
+				pr_warn("sibling found, but _SUN doesn't match!\n");
 			break;
 		}
 
@@ -198,11 +200,11 @@ register_slot(acpi_handle handle, u32 lvl, void *context, void **rv)
 		retval = acpiphp_register_hotplug_slot(slot);
 		if (retval) {
 			if (retval == -EBUSY)
-				warn("Slot %llu already registered by another "
-					"hotplug driver\n", slot->sun);
+				pr_warn("Slot %llu already registered by another hotplug driver\n",
+					slot->sun);
 			else
-				warn("acpiphp_register_hotplug_slot failed "
-					"(err code = 0x%x)\n", retval);
+				pr_warn("acpiphp_register_hotplug_slot failed (err code = 0x%x)\n",
+					retval);
 			goto err_exit;
 		}
 	}
@@ -233,7 +235,7 @@ register_slot(acpi_handle handle, u32 lvl, void *context, void **rv)
 		 */
 		newfunc->nb.notifier_call = post_dock_fixups;
 		if (register_dock_notifier(&newfunc->nb))
-			dbg("failed to register a dock notifier");
+			dbg("failed to register a dock notifier\n");
 	}
 
 	/* install notify handler */
@@ -244,7 +246,7 @@ register_slot(acpi_handle handle, u32 lvl, void *context, void **rv)
 					     newfunc);
 
 		if (ACPI_FAILURE(status))
-			err("failed to register interrupt notify handler\n");
+			pr_err("failed to register interrupt notify handler\n");
 	} else
 		status = AE_OK;
 
@@ -294,7 +296,7 @@ static void init_bridge_misc(struct acpiphp_bridge *bridge)
 						ACPI_SYSTEM_NOTIFY,
 						handle_hotplug_event_func);
 			if (ACPI_FAILURE(status))
-				err("failed to remove notify handler\n");
+				pr_err("failed to remove notify handler\n");
 		}
 		status = acpi_install_notify_handler(bridge->handle,
 					     ACPI_SYSTEM_NOTIFY,
@@ -302,7 +304,7 @@ static void init_bridge_misc(struct acpiphp_bridge *bridge)
 					     bridge);
 
 		if (ACPI_FAILURE(status)) {
-			err("failed to register interrupt notify handler\n");
+			pr_err("failed to register interrupt notify handler\n");
 		}
 	}
 }
@@ -392,7 +394,7 @@ static void add_p2p_bridge(acpi_handle *handle)
 
 	bridge = kzalloc(sizeof(struct acpiphp_bridge), GFP_KERNEL);
 	if (bridge == NULL) {
-		err("out of memory\n");
+		pr_err("out of memory\n");
 		return;
 	}
 
@@ -403,7 +405,7 @@ static void add_p2p_bridge(acpi_handle *handle)
 	bridge->pci_dev = acpi_get_pci_dev(handle);
 	bridge->pci_bus = bridge->pci_dev->subordinate;
 	if (!bridge->pci_bus) {
-		err("This is not a PCI-to-PCI bridge!\n");
+		pr_err("This is not a PCI-to-PCI bridge!\n");
 		goto err;
 	}
 
@@ -445,7 +447,7 @@ find_p2p_bridge(acpi_handle handle, u32 lvl, void *context, void **rv)
 	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, handle, (u32)1,
 				     find_p2p_bridge, NULL, NULL, NULL);
 	if (ACPI_FAILURE(status))
-		warn("find_p2p_bridge failed (error code = 0x%x)\n", status);
+		pr_warn("find_p2p_bridge failed (error code = 0x%x)\n", status);
 
  out:
 	pci_dev_put(dev);
@@ -484,7 +486,7 @@ static int add_bridge(acpi_handle handle)
 				     find_p2p_bridge, NULL, NULL, NULL);
 
 	if (ACPI_FAILURE(status))
-		warn("find_p2p_bridge failed (error code = 0x%x)\n", status);
+		pr_warn("find_p2p_bridge failed (error code = 0x%x)\n", status);
 
 	return 0;
 }
@@ -510,7 +512,7 @@ static void cleanup_bridge(struct acpiphp_bridge *bridge)
 	status = acpi_remove_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
 					    handle_hotplug_event_bridge);
 	if (ACPI_FAILURE(status))
-		err("failed to remove notify handler\n");
+		pr_err("failed to remove notify handler\n");
 
 	if ((bridge->type != BRIDGE_TYPE_HOST) &&
 	    ((bridge->flags & BRIDGE_HAS_EJ0) && bridge->func)) {
@@ -519,7 +521,7 @@ static void cleanup_bridge(struct acpiphp_bridge *bridge)
 						handle_hotplug_event_func,
 						bridge->func);
 		if (ACPI_FAILURE(status))
-			err("failed to install interrupt notify handler\n");
+			pr_err("failed to install interrupt notify handler\n");
 	}
 
 	slot = bridge->slots;
@@ -535,7 +537,7 @@ static void cleanup_bridge(struct acpiphp_bridge *bridge)
 						ACPI_SYSTEM_NOTIFY,
 						handle_hotplug_event_func);
 				if (ACPI_FAILURE(status))
-					err("failed to remove notify handler\n");
+					pr_err("failed to remove notify handler\n");
 			}
 			list_del(&func->sibling);
 			kfree(func);
@@ -613,7 +615,7 @@ static int power_on_slot(struct acpiphp_slot *slot)
 			dbg("%s: executing _PS0\n", __func__);
 			status = acpi_evaluate_object(func->handle, "_PS0", NULL, NULL);
 			if (ACPI_FAILURE(status)) {
-				warn("%s: _PS0 failed\n", __func__);
+				pr_warn("%s: _PS0 failed\n", __func__);
 				retval = -1;
 				goto err_exit;
 			} else
@@ -645,7 +647,7 @@ static int power_off_slot(struct acpiphp_slot *slot)
 		if (func->flags & FUNC_HAS_PS3) {
 			status = acpi_evaluate_object(func->handle, "_PS3", NULL, NULL);
 			if (ACPI_FAILURE(status)) {
-				warn("%s: _PS3 failed\n", __func__);
+				pr_warn("%s: _PS3 failed\n", __func__);
 				retval = -1;
 				goto err_exit;
 			} else
@@ -718,8 +720,7 @@ static int acpiphp_bus_add(struct acpiphp_func *func)
 	ret_val = acpi_bus_add(&device, pdevice, func->handle,
 		ACPI_BUS_TYPE_DEVICE);
 	if (ret_val) {
-		dbg("error adding bus, %x\n",
-			-ret_val);
+		dbg("error adding bus, %x\n", -ret_val);
 		goto acpiphp_bus_add_out;
 	}
 	ret_val = acpi_bus_start(device);
@@ -746,7 +747,7 @@ static int acpiphp_bus_trim(acpi_handle handle)
 
 	retval = acpi_bus_trim(device, 1);
 	if (retval)
-		err("cannot remove from acpi list\n");
+		pr_err("cannot remove from acpi list\n");
 
 	return retval;
 }
@@ -792,7 +793,7 @@ static int __ref enable_device(struct acpiphp_slot *slot)
 	dev = pci_get_slot(bus, PCI_DEVFN(slot->device, 0));
 	if (dev) {
 		/* This case shouldn't happen */
-		err("pci_dev structure already exists.\n");
+		pr_err("pci_dev structure already exists\n");
 		pci_dev_put(dev);
 		retval = -1;
 		goto err_exit;
@@ -800,7 +801,7 @@ static int __ref enable_device(struct acpiphp_slot *slot)
 
 	num = pci_scan_slot(bus, PCI_DEVFN(slot->device, 0));
 	if (num == 0) {
-		err("No new device found\n");
+		pr_err("No new device found\n");
 		retval = -1;
 		goto err_exit;
 	}
@@ -850,7 +851,7 @@ static int __ref enable_device(struct acpiphp_slot *slot)
 
 		status = find_p2p_bridge(func->handle, (u32)1, bus, NULL);
 		if (ACPI_FAILURE(status))
-			warn("find_p2p_bridge failed (error code = 0x%x)\n",
+			pr_warn("find_p2p_bridge failed (error code = 0x%x)\n",
 				status);
 		pci_dev_put(dev);
 	}
@@ -978,7 +979,7 @@ int acpiphp_eject_slot(struct acpiphp_slot *slot)
 
 			status = acpi_evaluate_object(func->handle, "_EJ0", &arg_list, NULL);
 			if (ACPI_FAILURE(status)) {
-				warn("%s: _EJ0 failed\n", __func__);
+				pr_warn("%s: _EJ0 failed\n", __func__);
 				return -1;
 			} else
 				break;
@@ -1009,7 +1010,7 @@ static int acpiphp_check_bridge(struct acpiphp_bridge *bridge)
 				continue;
 			retval = acpiphp_disable_slot(slot);
 			if (retval) {
-				err("Error occurred in disabling\n");
+				pr_err("Error occurred in disabling\n");
 				goto err_exit;
 			} else {
 				acpiphp_eject_slot(slot);
@@ -1020,7 +1021,7 @@ static int acpiphp_check_bridge(struct acpiphp_bridge *bridge)
 				continue;
 			retval = acpiphp_enable_slot(slot);
 			if (retval) {
-				err("Error occurred in enabling\n");
+				pr_err("Error occurred in enabling\n");
 				goto err_exit;
 			}
 			enabled++;
@@ -1094,7 +1095,7 @@ static void handle_bridge_insertion(acpi_handle handle, u32 type)
 
 	if ((type != ACPI_NOTIFY_BUS_CHECK) &&
 			(type != ACPI_NOTIFY_DEVICE_CHECK)) {
-		err("unexpected notification type %d\n", type);
+		pr_err("unexpected notification type %d\n", type);
 		return;
 	}
 
@@ -1104,14 +1105,14 @@ static void handle_bridge_insertion(acpi_handle handle, u32 type)
 		pdevice = NULL;
 	}
 	if (acpi_bus_add(&device, pdevice, handle, ACPI_BUS_TYPE_DEVICE)) {
-		err("cannot add bridge to acpi list\n");
+		pr_err("cannot add bridge to acpi list\n");
 		return;
 	}
 	if (!acpiphp_configure_bridge(handle) &&
 		!acpi_bus_start(device))
 		add_bridge(handle);
 	else
-		err("cannot configure and start bridge\n");
+		pr_err("cannot configure and start bridge\n");
 
 }
 
@@ -1143,7 +1144,7 @@ check_sub_bridges(acpi_handle handle, u32 lvl, void *context, void **rv)
 	if (bridge) {
 		acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);
 		dbg("%s: re-enumerating slots under %s\n",
-			__func__, objname);
+		    __func__, objname);
 		acpiphp_check_bridge(bridge);
 	}
 	return AE_OK ;
@@ -1179,7 +1180,7 @@ static void handle_hotplug_event_bridge(acpi_handle handle, u32 type, void *cont
 	}
 
 	if (!bridge && !num_sub_bridges) {
-		err("cannot get bridge info\n");
+		pr_err("cannot get bridge info\n");
 		return;
 	}
 
@@ -1191,7 +1192,7 @@ static void handle_hotplug_event_bridge(acpi_handle handle, u32 type, void *cont
 		dbg("%s: Bus check notify on %s\n", __func__, objname);
 		if (bridge) {
 			dbg("%s: re-enumerating slots under %s\n",
-				__func__, objname);
+			    __func__, objname);
 			acpiphp_check_bridge(bridge);
 		}
 		if (num_sub_bridges)
@@ -1223,22 +1224,22 @@ static void handle_hotplug_event_bridge(acpi_handle handle, u32 type, void *cont
 		break;
 
 	case ACPI_NOTIFY_FREQUENCY_MISMATCH:
-		printk(KERN_ERR "Device %s cannot be configured due"
-				" to a frequency mismatch\n", objname);
+		pr_err("Device %s cannot be configured due to a frequency mismatch\n",
+		       objname);
 		break;
 
 	case ACPI_NOTIFY_BUS_MODE_MISMATCH:
-		printk(KERN_ERR "Device %s cannot be configured due"
-				" to a bus mode mismatch\n", objname);
+		pr_err("Device %s cannot be configured due to a bus mode mismatch\n",
+		       objname);
 		break;
 
 	case ACPI_NOTIFY_POWER_FAULT:
-		printk(KERN_ERR "Device %s has suffered a power fault\n",
-				objname);
+		pr_err("Device %s has suffered a power fault\n", objname);
 		break;
 
 	default:
-		warn("notify_handler: unknown event type 0x%x for %s\n", type, objname);
+		pr_warn("notify_handler: unknown event type 0x%x for %s\n",
+			type, objname);
 		break;
 	}
 }
@@ -1288,7 +1289,8 @@ static void handle_hotplug_event_func(acpi_handle handle, u32 type, void *contex
 		break;
 
 	default:
-		warn("notify_handler: unknown event type 0x%x for %s\n", type, objname);
+		pr_warn("notify_handler: unknown event type 0x%x for %s\n",
+			type, objname);
 		break;
 	}
 }
@@ -1352,9 +1354,9 @@ int __init acpiphp_get_num_slots(void)
 
 	list_for_each_entry(bridge, &bridge_list, list) {
 		dbg("Bus %04x:%02x has %d slot%s\n",
-				pci_domain_nr(bridge->pci_bus),
-				bridge->pci_bus->number, bridge->nr_slots,
-				bridge->nr_slots == 1 ? "" : "s");
+		    pci_domain_nr(bridge->pci_bus),
+		    bridge->pci_bus->number, bridge->nr_slots,
+		    bridge->nr_slots == 1 ? "" : "s");
 		num_slots += bridge->nr_slots;
 	}
 
diff --git a/drivers/pci/hotplug/acpiphp_ibm.c b/drivers/pci/hotplug/acpiphp_ibm.c
index e525263..16ecce6 100644
--- a/drivers/pci/hotplug/acpiphp_ibm.c
+++ b/drivers/pci/hotplug/acpiphp_ibm.c
@@ -25,6 +25,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/module.h>
@@ -57,8 +59,7 @@ MODULE_PARM_DESC(debug, " Debugging mode enabled or not");
 #define dbg(format, arg...)				\
 do {							\
 	if (debug)					\
-		printk(KERN_DEBUG "%s: " format,	\
-				MY_NAME , ## arg);	\
+		pr_debug(format, ##arg);		\
 } while (0)
 
 #define FOUND_APCI 0x61504349
@@ -189,9 +190,9 @@ static int ibm_set_attention_status(struct hotplug_slot *slot, u8 status)
 
 	ibm_slot = ibm_slot_from_id(hpslot_to_sun(slot));
 
-	dbg("%s: set slot %d (%d) attention status to %d\n", __func__,
-			ibm_slot->slot.slot_num, ibm_slot->slot.slot_id,
-			(status ? 1 : 0));
+	dbg("%s: set slot %d (%d) attention status to %d\n",
+	    __func__, ibm_slot->slot.slot_num, ibm_slot->slot.slot_id,
+	    (status ? 1 : 0));
 
 	args[0].type = ACPI_TYPE_INTEGER;
 	args[0].integer.value = ibm_slot->slot.slot_id;
@@ -202,10 +203,10 @@ static int ibm_set_attention_status(struct hotplug_slot *slot, u8 status)
 
 	stat = acpi_evaluate_integer(ibm_acpi_handle, "APLS", &params, &rc);
 	if (ACPI_FAILURE(stat)) {
-		err("APLS evaluation failed:  0x%08x\n", stat);
+		pr_err("APLS evaluation failed:  0x%08x\n", stat);
 		return -ENODEV;
 	} else if (!rc) {
-		err("APLS method failed:  0x%08llx\n", rc);
+		pr_err("APLS method failed:  0x%08llx\n", rc);
 		return -ERANGE;
 	}
 	return 0;
@@ -234,9 +235,8 @@ static int ibm_get_attention_status(struct hotplug_slot *slot, u8 *status)
 	else
 		*status = 0;
 
-	dbg("%s: get slot %d (%d) attention status is %d\n", __func__,
-			ibm_slot->slot.slot_num, ibm_slot->slot.slot_id,
-			*status);
+	dbg("%s: get slot %d (%d) attention status is %d\n",
+	    __func__, ibm_slot->slot.slot_num, ibm_slot->slot.slot_id, *status);
 
 	kfree(ibm_slot);
 	return 0;
@@ -269,7 +269,7 @@ static void ibm_handle_events(acpi_handle handle, u32 event, void *context)
 	dbg("%s: Received notification %02x\n", __func__, event);
 
 	if (subevent == 0x80) {
-		dbg("%s: generationg bus event\n", __func__);
+		dbg("%s: generating bus event\n", __func__);
 		acpi_bus_generate_proc_event(note->device, note->event, detail);
 		acpi_bus_generate_netlink_event(note->device->pnp.device_class,
 						  dev_name(&note->device->dev),
@@ -302,7 +302,7 @@ static int ibm_get_table_from_acpi(char **bufp)
 
 	status = acpi_evaluate_object(ibm_acpi_handle, "APCI", NULL, &buffer);
 	if (ACPI_FAILURE(status)) {
-		err("%s:  APCI evaluation failed\n", __func__);
+		pr_err("%s:  APCI evaluation failed\n", __func__);
 		return -ENODEV;
 	}
 
@@ -310,13 +310,13 @@ static int ibm_get_table_from_acpi(char **bufp)
 	if (!(package) ||
 			(package->type != ACPI_TYPE_PACKAGE) ||
 			!(package->package.elements)) {
-		err("%s:  Invalid APCI object\n", __func__);
+		pr_err("%s:  Invalid APCI object\n", __func__);
 		goto read_table_done;
 	}
 
 	for(size = 0, i = 0; i < package->package.count; i++) {
 		if (package->package.elements[i].type != ACPI_TYPE_BUFFER) {
-			err("%s:  Invalid APCI element %d\n", __func__, i);
+			pr_err("%s:  Invalid APCI element %d\n", __func__, i);
 			goto read_table_done;
 		}
 		size += package->package.elements[i].buffer.length;
@@ -327,7 +327,7 @@ static int ibm_get_table_from_acpi(char **bufp)
 
 	lbuf = kzalloc(size, GFP_KERNEL);
 	dbg("%s: element count: %i, ASL table size: %i, &table = 0x%p\n",
-			__func__, package->package.count, size, lbuf);
+	    __func__, package->package.count, size, lbuf);
 
 	if (lbuf) {
 		*bufp = lbuf;
@@ -404,8 +404,8 @@ static acpi_status __init ibm_find_acpi_device(acpi_handle handle,
 
 	status = acpi_get_object_info(handle, &info);
 	if (ACPI_FAILURE(status)) {
-		err("%s:  Failed to get device information status=0x%x\n",
-			__func__, status);
+		pr_err("%s:  Failed to get device information status=0x%x\n",
+		       __func__, status);
 		return retval;
 	}
 
@@ -413,7 +413,7 @@ static acpi_status __init ibm_find_acpi_device(acpi_handle handle,
 			(!strcmp(info->hardware_id.string, IBM_HARDWARE_ID1) ||
 			 !strcmp(info->hardware_id.string, IBM_HARDWARE_ID2))) {
 		dbg("found hardware: %s, handle: %p\n",
-			info->hardware_id.string, handle);
+		    info->hardware_id.string, handle);
 		*phandle = handle;
 		/* returning non-zero causes the search to stop
 		 * and returns this value to the caller of 
@@ -438,13 +438,13 @@ static int __init ibm_acpiphp_init(void)
 	if (acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
 			ACPI_UINT32_MAX, ibm_find_acpi_device, NULL,
 			&ibm_acpi_handle, NULL) != FOUND_APCI) {
-		err("%s: acpi_walk_namespace failed\n", __func__);
+		pr_err("%s: acpi_walk_namespace failed\n", __func__);
 		retval = -ENODEV;
 		goto init_return;
 	}
 	dbg("%s: found IBM aPCI device\n", __func__);
 	if (acpi_bus_get_device(ibm_acpi_handle, &device)) {
-		err("%s: acpi_bus_get_device failed\n", __func__);
+		pr_err("%s: acpi_bus_get_device failed\n", __func__);
 		retval = -ENODEV;
 		goto init_return;
 	}
@@ -458,8 +458,8 @@ static int __init ibm_acpiphp_init(void)
 			ACPI_DEVICE_NOTIFY, ibm_handle_events,
 			&ibm_note);
 	if (ACPI_FAILURE(status)) {
-		err("%s: Failed to register notification handler\n",
-				__func__);
+		pr_err("%s: Failed to register notification handler\n",
+		       __func__);
 		retval = -EBUSY;
 		goto init_cleanup;
 	}
@@ -483,14 +483,14 @@ static void __exit ibm_acpiphp_exit(void)
 	dbg("%s\n", __func__);
 
 	if (acpiphp_unregister_attention(&ibm_attention_info))
-		err("%s: attention info deregistration failed", __func__);
+		pr_err("%s: attention info deregistration failed", __func__);
 
 	status = acpi_remove_notify_handler(
 			   ibm_acpi_handle,
 			   ACPI_DEVICE_NOTIFY,
 			   ibm_handle_events);
 	if (ACPI_FAILURE(status))
-		err("%s: Notification handler removal failed\n", __func__);
+		pr_err("%s: Notification handler removal failed\n", __func__);
 	/* remove the /sys entries */
 	sysfs_remove_bin_file(sysdir, &ibm_apci_table_attr);
 }
diff --git a/drivers/pci/hotplug/cpci_hotplug_core.c b/drivers/pci/hotplug/cpci_hotplug_core.c
index d703e73..20d20d4 100644
--- a/drivers/pci/hotplug/cpci_hotplug_core.c
+++ b/drivers/pci/hotplug/cpci_hotplug_core.c
@@ -25,6 +25,8 @@
  * Send feedback to <scottm@somanetworks.com>
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
@@ -43,14 +45,10 @@
 #define MY_NAME	"cpci_hotplug"
 
 #define dbg(format, arg...)					\
-	do {							\
-		if (cpci_debug)					\
-			printk (KERN_DEBUG "%s: " format "\n",	\
-				MY_NAME , ## arg); 		\
-	} while (0)
-#define err(format, arg...) printk(KERN_ERR "%s: " format "\n", MY_NAME , ## arg)
-#define info(format, arg...) printk(KERN_INFO "%s: " format "\n", MY_NAME , ## arg)
-#define warn(format, arg...) printk(KERN_WARNING "%s: " format "\n", MY_NAME , ## arg)
+do {								\
+	if (cpci_debug)						\
+		pr_debug(format, ##arg);			\
+} while (0)
 
 /* local variables */
 static DECLARE_RWSEM(list_rwsem);
@@ -106,7 +104,7 @@ enable_slot(struct hotplug_slot *hotplug_slot)
 	struct slot *slot = hotplug_slot->private;
 	int retval = 0;
 
-	dbg("%s - physical_slot = %s", __func__, slot_name(slot));
+	dbg("%s: physical_slot = %s\n", __func__, slot_name(slot));
 
 	if (controller->ops->set_power)
 		retval = controller->ops->set_power(slot, 1);
@@ -119,23 +117,23 @@ disable_slot(struct hotplug_slot *hotplug_slot)
 	struct slot *slot = hotplug_slot->private;
 	int retval = 0;
 
-	dbg("%s - physical_slot = %s", __func__, slot_name(slot));
+	dbg("%s: physical_slot = %s\n", __func__, slot_name(slot));
 
 	down_write(&list_rwsem);
 
 	/* Unconfigure device */
-	dbg("%s - unconfiguring slot %s", __func__, slot_name(slot));
+	dbg("%s: unconfiguring slot %s\n", __func__, slot_name(slot));
 	if ((retval = cpci_unconfigure_slot(slot))) {
-		err("%s - could not unconfigure slot %s",
-		    __func__, slot_name(slot));
+		pr_err("%s: could not unconfigure slot %s\n",
+		       __func__, slot_name(slot));
 		goto disable_error;
 	}
-	dbg("%s - finished unconfiguring slot %s", __func__, slot_name(slot));
+	dbg("%s: finished unconfiguring slot %s\n", __func__, slot_name(slot));
 
 	/* Clear EXT (by setting it) */
 	if (cpci_clear_ext(slot)) {
-		err("%s - could not clear EXT for slot %s",
-		    __func__, slot_name(slot));
+		pr_err("%s: could not clear EXT for slot %s\n",
+		       __func__, slot_name(slot));
 		retval = -ENODEV;
 		goto disable_error;
 	}
@@ -146,7 +144,7 @@ disable_slot(struct hotplug_slot *hotplug_slot)
 			goto disable_error;
 
 	if (update_adapter_status(slot->hotplug_slot, 0))
-		warn("failure to update adapter file");
+		pr_warn("failure to update adapter file\n");
 
 	if (slot->extracting) {
 		slot->extracting = 0;
@@ -265,17 +263,18 @@ cpci_hp_register_bus(struct pci_bus *bus, u8 first, u8 last)
 		 * Initialize the slot info structure with some known
 		 * good values.
 		 */
-		dbg("initializing slot %s", name);
+		dbg("initializing slot %s\n", name);
 		info->power_status = cpci_get_power_status(slot);
 		info->attention_status = cpci_get_attention_status(slot);
 
-		dbg("registering slot %s", name);
+		dbg("registering slot %s\n", name);
 		status = pci_hp_register(slot->hotplug_slot, bus, i, name);
 		if (status) {
-			err("pci_hp_register failed with error %d", status);
+			pr_err("pci_hp_register failed with error %d\n",
+			       status);
 			goto error_info;
 		}
-		dbg("slot registered with name: %s", slot_name(slot));
+		dbg("slot registered with name: %s\n", slot_name(slot));
 
 		/* Add slot to our internal list */
 		down_write(&list_rwsem);
@@ -311,11 +310,11 @@ cpci_hp_unregister_bus(struct pci_bus *bus)
 			list_del(&slot->slot_list);
 			slots--;
 
-			dbg("deregistering slot %s", slot_name(slot));
+			dbg("deregistering slot %s\n", slot_name(slot));
 			status = pci_hp_deregister(slot->hotplug_slot);
 			if (status) {
-				err("pci_hp_deregister failed with error %d",
-				    status);
+				pr_err("pci_hp_deregister failed with error %d\n",
+				       status);
 				break;
 			}
 		}
@@ -328,12 +327,12 @@ cpci_hp_unregister_bus(struct pci_bus *bus)
 static irqreturn_t
 cpci_hp_intr(int irq, void *data)
 {
-	dbg("entered cpci_hp_intr");
+	dbg("entered cpci_hp_intr\n");
 
 	/* Check to see if it was our interrupt */
 	if ((controller->irq_flags & IRQF_SHARED) &&
 	    !controller->ops->check_irq(controller->dev_id)) {
-		dbg("exited cpci_hp_intr, not our interrupt");
+		dbg("exited cpci_hp_intr, not our interrupt\n");
 		return IRQ_NONE;
 	}
 
@@ -356,28 +355,28 @@ init_slots(int clear_ins)
 	struct slot *slot;
 	struct pci_dev* dev;
 
-	dbg("%s - enter", __func__);
+	dbg("%s: enter\n", __func__);
 	down_read(&list_rwsem);
 	if (!slots) {
 		up_read(&list_rwsem);
 		return -1;
 	}
 	list_for_each_entry(slot, &slot_list, slot_list) {
-		dbg("%s - looking at slot %s", __func__, slot_name(slot));
+		dbg("%s: looking at slot %s\n", __func__, slot_name(slot));
 		if (clear_ins && cpci_check_and_clear_ins(slot))
-			dbg("%s - cleared INS for slot %s",
+			dbg("%s: cleared INS for slot %s\n",
 			    __func__, slot_name(slot));
 		dev = pci_get_slot(slot->bus, PCI_DEVFN(slot->number, 0));
 		if (dev) {
 			if (update_adapter_status(slot->hotplug_slot, 1))
-				warn("failure to update adapter file");
+				pr_warn("failure to update adapter file\n");
 			if (update_latch_status(slot->hotplug_slot, 1))
-				warn("failure to update latch file");
+				pr_warn("failure to update latch file\n");
 			slot->dev = dev;
 		}
 	}
 	up_read(&list_rwsem);
-	dbg("%s - exit", __func__);
+	dbg("%s: exit\n", __func__);
 	return 0;
 }
 
@@ -392,75 +391,76 @@ check_slots(void)
 	down_read(&list_rwsem);
 	if (!slots) {
 		up_read(&list_rwsem);
-		err("no slots registered, shutting down");
+		pr_err("no slots registered, shutting down\n");
 		return -1;
 	}
 	extracted = inserted = 0;
 	list_for_each_entry(slot, &slot_list, slot_list) {
-		dbg("%s - looking at slot %s", __func__, slot_name(slot));
+		dbg("%s: looking at slot %s\n", __func__, slot_name(slot));
 		if (cpci_check_and_clear_ins(slot)) {
 			/*
 			 * Some broken hardware (e.g. PLX 9054AB) asserts
 			 * ENUM# twice...
 			 */
 			if (slot->dev) {
-				warn("slot %s already inserted",
-				     slot_name(slot));
+				pr_warn("slot %s already inserted\n",
+					slot_name(slot));
 				inserted++;
 				continue;
 			}
 
 			/* Process insertion */
-			dbg("%s - slot %s inserted", __func__, slot_name(slot));
+			dbg("%s: slot %s inserted\n",
+			    __func__, slot_name(slot));
 
 			/* GSM, debug */
 			hs_csr = cpci_get_hs_csr(slot);
-			dbg("%s - slot %s HS_CSR (1) = %04x",
+			dbg("%s: slot %s HS_CSR (1) = %04x\n",
 			    __func__, slot_name(slot), hs_csr);
 
 			/* Configure device */
-			dbg("%s - configuring slot %s",
+			dbg("%s: configuring slot %s\n",
 			    __func__, slot_name(slot));
 			if (cpci_configure_slot(slot)) {
-				err("%s - could not configure slot %s",
-				    __func__, slot_name(slot));
+				pr_err("%s: could not configure slot %s\n",
+				       __func__, slot_name(slot));
 				continue;
 			}
-			dbg("%s - finished configuring slot %s",
+			dbg("%s: finished configuring slot %s\n",
 			    __func__, slot_name(slot));
 
 			/* GSM, debug */
 			hs_csr = cpci_get_hs_csr(slot);
-			dbg("%s - slot %s HS_CSR (2) = %04x",
+			dbg("%s: slot %s HS_CSR (2) = %04x\n",
 			    __func__, slot_name(slot), hs_csr);
 
 			if (update_latch_status(slot->hotplug_slot, 1))
-				warn("failure to update latch file");
+				pr_warn("failure to update latch file\n");
 
 			if (update_adapter_status(slot->hotplug_slot, 1))
-				warn("failure to update adapter file");
+				pr_warn("failure to update adapter file\n");
 
 			cpci_led_off(slot);
 
 			/* GSM, debug */
 			hs_csr = cpci_get_hs_csr(slot);
-			dbg("%s - slot %s HS_CSR (3) = %04x",
+			dbg("%s: slot %s HS_CSR (3) = %04x\n",
 			    __func__, slot_name(slot), hs_csr);
 
 			inserted++;
 		} else if (cpci_check_ext(slot)) {
 			/* Process extraction request */
-			dbg("%s - slot %s extracted",
+			dbg("%s: slot %s extracted\n",
 			    __func__, slot_name(slot));
 
 			/* GSM, debug */
 			hs_csr = cpci_get_hs_csr(slot);
-			dbg("%s - slot %s HS_CSR = %04x",
+			dbg("%s: slot %s HS_CSR = %04x\n",
 			    __func__, slot_name(slot), hs_csr);
 
 			if (!slot->extracting) {
 				if (update_latch_status(slot->hotplug_slot, 0)) {
-					warn("failure to update latch file");
+					pr_warn("failure to update latch file\n");
 				}
 				slot->extracting = 1;
 				atomic_inc(&extracting);
@@ -473,22 +473,22 @@ check_slots(void)
 				 * Hmmm, we're likely hosed at this point, should we
 				 * bother trying to tell the driver or not?
 				 */
-				err("card in slot %s was improperly removed",
-				    slot_name(slot));
+				pr_err("card in slot %s was improperly removed\n",
+				       slot_name(slot));
 				if (update_adapter_status(slot->hotplug_slot, 0))
-					warn("failure to update adapter file");
+					pr_warn("failure to update adapter file\n");
 				slot->extracting = 0;
 				atomic_dec(&extracting);
 			}
 		}
 	}
 	up_read(&list_rwsem);
-	dbg("inserted=%d, extracted=%d, extracting=%d",
+	dbg("inserted=%d, extracted=%d, extracting=%d\n",
 	    inserted, extracted, atomic_read(&extracting));
 	if (inserted || extracted)
 		return extracted;
 	else if (!atomic_read(&extracting)) {
-		err("cannot find ENUM# source, shutting down");
+		pr_err("cannot find ENUM# source, shutting down\n");
 		return -1;
 	}
 	return 0;
@@ -500,9 +500,9 @@ event_thread(void *data)
 {
 	int rc;
 
-	dbg("%s - event thread started", __func__);
+	dbg("%s: event thread started\n", __func__);
 	while (1) {
-		dbg("event thread sleeping");
+		dbg("event thread sleeping\n");
 		set_current_state(TASK_INTERRUPTIBLE);
 		schedule();
 		if (kthread_should_stop())
@@ -513,7 +513,7 @@ event_thread(void *data)
 				/* Give userspace a chance to handle extraction */
 				msleep(500);
 			} else if (rc < 0) {
-				dbg("%s - error checking slots", __func__);
+				dbg("%s: error checking slots\n", __func__);
 				thread_finished = 1;
 				goto out;
 			}
@@ -522,7 +522,7 @@ event_thread(void *data)
 			break;
 
 		/* Re-enable ENUM# interrupt */
-		dbg("%s - re-enabling irq", __func__);
+		dbg("%s: re-enabling irq\n", __func__);
 		controller->ops->enable_irq();
 	}
  out:
@@ -545,7 +545,8 @@ poll_thread(void *data)
 					/* Give userspace a chance to handle extraction */
 					msleep(500);
 				} else if (rc < 0) {
-					dbg("%s - error checking slots", __func__);
+					dbg("%s: error checking slots\n",
+					    __func__);
 					thread_finished = 1;
 					goto out;
 				}
@@ -565,7 +566,7 @@ cpci_start_thread(void)
 	else
 		cpci_thread = kthread_run(poll_thread, NULL, "cpci_hp_polld");
 	if (IS_ERR(cpci_thread)) {
-		err("Can't start up our thread");
+		pr_err("Can't start up our thread\n");
 		return PTR_ERR(cpci_thread);
 	}
 	thread_finished = 0;
@@ -597,11 +598,11 @@ cpci_hp_register_controller(struct cpci_hp_controller *new_controller)
 			       new_controller->irq_flags,
 			       MY_NAME,
 			       new_controller->dev_id)) {
-			err("Can't get irq %d for the hotplug cPCI controller",
-			    new_controller->irq);
+			pr_err("Can't get irq %d for the hotplug cPCI controller\n",
+			       new_controller->irq);
 			status = -ENODEV;
 		}
-		dbg("%s - acquired controller irq %d",
+		dbg("%s: acquired controller irq %d\n",
 		    __func__, new_controller->irq);
 	}
 	if (!status)
@@ -654,7 +655,7 @@ cpci_hp_start(void)
 	static int first = 1;
 	int status;
 
-	dbg("%s - enter", __func__);
+	dbg("%s: enter\n", __func__);
 	if (!controller)
 		return -ENODEV;
 
@@ -674,14 +675,14 @@ cpci_hp_start(void)
 	status = cpci_start_thread();
 	if (status)
 		return status;
-	dbg("%s - thread started", __func__);
+	dbg("%s: thread started\n", __func__);
 
 	if (controller->irq) {
 		/* Start enum interrupt processing */
-		dbg("%s - enabling irq", __func__);
+		dbg("%s: enabling irq\n", __func__);
 		controller->ops->enable_irq();
 	}
-	dbg("%s - exit", __func__);
+	dbg("%s: exit\n", __func__);
 	return 0;
 }
 
@@ -692,7 +693,7 @@ cpci_hp_stop(void)
 		return -ENODEV;
 	if (controller->irq) {
 		/* Stop enum interrupt processing */
-		dbg("%s - disabling irq", __func__);
+		dbg("%s: disabling irq\n", __func__);
 		controller->ops->disable_irq();
 	}
 	cpci_stop_thread();
diff --git a/drivers/pci/hotplug/cpci_hotplug_pci.c b/drivers/pci/hotplug/cpci_hotplug_pci.c
index 829c327..ce86342 100644
--- a/drivers/pci/hotplug/cpci_hotplug_pci.c
+++ b/drivers/pci/hotplug/cpci_hotplug_pci.c
@@ -23,6 +23,8 @@
  * Send feedback to <scottm@somanetworks.com>
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/pci.h>
@@ -36,15 +38,10 @@
 extern int cpci_debug;
 
 #define dbg(format, arg...)					\
-	do {							\
-		if (cpci_debug)					\
-			printk (KERN_DEBUG "%s: " format "\n",	\
-				MY_NAME , ## arg); 		\
-	} while (0)
-#define err(format, arg...) printk(KERN_ERR "%s: " format "\n", MY_NAME , ## arg)
-#define info(format, arg...) printk(KERN_INFO "%s: " format "\n", MY_NAME , ## arg)
-#define warn(format, arg...) printk(KERN_WARNING "%s: " format "\n", MY_NAME , ## arg)
-
+do {								\
+	if (cpci_debug)						\
+		pr_debug(format, ##arg);			\
+} while (0)
 
 u8 cpci_get_attention_status(struct slot* slot)
 {
@@ -208,8 +205,8 @@ int cpci_led_on(struct slot* slot)
 					      slot->devfn,
 					      hs_cap + 2,
 					      hs_csr)) {
-			err("Could not set LOO for slot %s",
-			    hotplug_slot_name(slot->hotplug_slot));
+			pr_err("Could not set LOO for slot %s\n",
+			       hotplug_slot_name(slot->hotplug_slot));
 			return -ENODEV;
 		}
 	}
@@ -237,8 +234,8 @@ int cpci_led_off(struct slot* slot)
 					      slot->devfn,
 					      hs_cap + 2,
 					      hs_csr)) {
-			err("Could not clear LOO for slot %s",
-			    hotplug_slot_name(slot->hotplug_slot));
+			pr_err("Could not clear LOO for slot %s\n",
+			       hotplug_slot_name(slot->hotplug_slot));
 			return -ENODEV;
 		}
 	}
@@ -255,28 +252,30 @@ int __ref cpci_configure_slot(struct slot *slot)
 	struct pci_bus *parent;
 	int fn;
 
-	dbg("%s - enter", __func__);
+	dbg("%s: enter\n", __func__);
 
 	if (slot->dev == NULL) {
-		dbg("pci_dev null, finding %02x:%02x:%x",
-		    slot->bus->number, PCI_SLOT(slot->devfn), PCI_FUNC(slot->devfn));
+		dbg("pci_dev null, finding %02x:%02x:%x\n",
+		    slot->bus->number, PCI_SLOT(slot->devfn),
+		    PCI_FUNC(slot->devfn));
 		slot->dev = pci_get_slot(slot->bus, slot->devfn);
 	}
 
 	/* Still NULL? Well then scan for it! */
 	if (slot->dev == NULL) {
 		int n;
-		dbg("pci_dev still null");
+		dbg("pci_dev still null\n");
 
 		/*
 		 * This will generate pci_dev structures for all functions, but
 		 * we will only call this case when lookup fails.
 		 */
 		n = pci_scan_slot(slot->bus, slot->devfn);
-		dbg("%s: pci_scan_slot returned %d", __func__, n);
+		dbg("%s: pci_scan_slot returned %d\n", __func__, n);
 		slot->dev = pci_get_slot(slot->bus, slot->devfn);
 		if (slot->dev == NULL) {
-			err("Could not find PCI device for slot %02x", slot->number);
+			pr_err("Could not find PCI device for slot %02x\n",
+			       slot->number);
 			return -ENODEV;
 		}
 	}
@@ -301,14 +300,14 @@ int __ref cpci_configure_slot(struct slot *slot)
 					break;
 			}
 			if (busnr >= end) {
-				err("No free bus for hot-added bridge\n");
+				pr_err("No free bus for hot-added bridge\n");
 				pci_dev_put(dev);
 				continue;
 			}
 			child = pci_add_new_bus(parent, dev, busnr);
 			if (!child) {
-				err("Cannot add new bus for %s\n",
-				    pci_name(dev));
+				pr_err("Cannot add new bus for %s\n",
+				       pci_name(dev));
 				pci_dev_put(dev);
 				continue;
 			}
@@ -322,7 +321,7 @@ int __ref cpci_configure_slot(struct slot *slot)
 	pci_bus_add_devices(parent);
 	pci_enable_bridges(parent);
 
-	dbg("%s - exit", __func__);
+	dbg("%s: exit\n", __func__);
 	return 0;
 }
 
@@ -331,9 +330,9 @@ int cpci_unconfigure_slot(struct slot* slot)
 	int i;
 	struct pci_dev *dev;
 
-	dbg("%s - enter", __func__);
+	dbg("%s: enter\n", __func__);
 	if (!slot->dev) {
-		err("No device for slot %02x\n", slot->number);
+		pr_err("No device for slot %02x\n", slot->number);
 		return -ENODEV;
 	}
 
@@ -348,6 +347,6 @@ int cpci_unconfigure_slot(struct slot* slot)
 	pci_dev_put(slot->dev);
 	slot->dev = NULL;
 
-	dbg("%s - exit", __func__);
+	dbg("%s: exit\n", __func__);
 	return 0;
 }
diff --git a/drivers/pci/hotplug/cpcihp_generic.c b/drivers/pci/hotplug/cpcihp_generic.c
index fb3f846..e5f3299 100644
--- a/drivers/pci/hotplug/cpcihp_generic.c
+++ b/drivers/pci/hotplug/cpcihp_generic.c
@@ -34,6 +34,8 @@
  * Send feedback to <scottm@somanetworks.com>
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/errno.h>
@@ -52,14 +54,10 @@
 #endif
 
 #define dbg(format, arg...)					\
-	do {							\
-		if(debug)					\
-			printk (KERN_DEBUG "%s: " format "\n",	\
-				MY_NAME , ## arg); 		\
-	} while(0)
-#define err(format, arg...) printk(KERN_ERR "%s: " format "\n", MY_NAME , ## arg)
-#define info(format, arg...) printk(KERN_INFO "%s: " format "\n", MY_NAME , ## arg)
-#define warn(format, arg...) printk(KERN_WARNING "%s: " format "\n", MY_NAME , ## arg)
+do {								\
+	if (debug)						\
+		pr_debug(format, ##arg);			\
+} while (0)
 
 /* local variables */
 static int debug;
@@ -83,7 +81,7 @@ static int __init validate_parameters(void)
 	unsigned long tmp;
 
 	if(!bridge) {
-		info("not configured, disabling.");
+		pr_info("not configured, disabling\n");
 		return -EINVAL;
 	}
 	str = bridge;
@@ -92,39 +90,39 @@ static int __init validate_parameters(void)
 
 	tmp = simple_strtoul(str, &p, 16);
 	if(p == str || tmp > 0xff) {
-		err("Invalid hotplug bus bridge device bus number");
+		pr_err("Invalid hotplug bus bridge device bus number\n");
 		return -EINVAL;
 	}
 	bridge_busnr = (u8) tmp;
-	dbg("bridge_busnr = 0x%02x", bridge_busnr);
+	dbg("bridge_busnr = 0x%02x\n", bridge_busnr);
 	if(*p != ':') {
-		err("Invalid hotplug bus bridge device");
+		pr_err("Invalid hotplug bus bridge device\n");
 		return -EINVAL;
 	}
 	str = p + 1;
 	tmp = simple_strtoul(str, &p, 16);
 	if(p == str || tmp > 0x1f) {
-		err("Invalid hotplug bus bridge device slot number");
+		pr_err("Invalid hotplug bus bridge device slot number\n");
 		return -EINVAL;
 	}
 	bridge_slot = (u8) tmp;
-	dbg("bridge_slot = 0x%02x", bridge_slot);
+	dbg("bridge_slot = 0x%02x\n", bridge_slot);
 
-	dbg("first_slot = 0x%02x", first_slot);
-	dbg("last_slot = 0x%02x", last_slot);
+	dbg("first_slot = 0x%02x\n", first_slot);
+	dbg("last_slot = 0x%02x\n", last_slot);
 	if(!(first_slot && last_slot)) {
-		err("Need to specify first_slot and last_slot");
+		pr_err("Need to specify first_slot and last_slot\n");
 		return -EINVAL;
 	}
 	if(last_slot < first_slot) {
-		err("first_slot must be less than last_slot");
+		pr_err("first_slot must be less than last_slot\n");
 		return -EINVAL;
 	}
 
-	dbg("port = 0x%04x", port);
-	dbg("enum_bit = 0x%02x", enum_bit);
+	dbg("port = 0x%04x\n", port);
+	dbg("enum_bit = 0x%02x\n", enum_bit);
 	if(enum_bit > 7) {
-		err("Invalid #ENUM bit");
+		pr_err("Invalid #ENUM bit\n");
 		return -EINVAL;
 	}
 	enum_mask = 1 << enum_bit;
@@ -145,7 +143,7 @@ static int __init cpcihp_generic_init(void)
 	struct resource* r;
 	struct pci_dev* dev;
 
-	info(DRIVER_DESC " version: " DRIVER_VERSION);
+	pr_info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
 	status = validate_parameters();
 	if (status)
 		return status;
@@ -156,12 +154,12 @@ static int __init cpcihp_generic_init(void)
 
 	bus = pci_find_bus(0, bridge_busnr);
 	if (!bus) {
-		err("Invalid bus number %d", bridge_busnr);
+		pr_err("Invalid bus number %d\n", bridge_busnr);
 		return -EINVAL;
 	}
 	dev = pci_get_slot(bus, PCI_DEVFN(bridge_slot, 0));
 	if(!dev || dev->hdr_type != PCI_HEADER_TYPE_BRIDGE) {
-		err("Invalid bridge device %s", bridge);
+		pr_err("Invalid bridge device %s\n", bridge);
 		pci_dev_put(dev);
 		return -EINVAL;
 	}
@@ -174,30 +172,30 @@ static int __init cpcihp_generic_init(void)
 
 	status = cpci_hp_register_controller(&generic_hpc);
 	if(status != 0) {
-		err("Could not register cPCI hotplug controller");
+		pr_err("Could not register cPCI hotplug controller\n");
 		return -ENODEV;
 	}
-	dbg("registered controller");
+	dbg("registered controller\n");
 
 	status = cpci_hp_register_bus(bus, first_slot, last_slot);
 	if(status != 0) {
-		err("Could not register cPCI hotplug bus");
+		pr_err("Could not register cPCI hotplug bus\n");
 		goto init_bus_register_error;
 	}
-	dbg("registered bus");
+	dbg("registered bus\n");
 
 	status = cpci_hp_start();
 	if(status != 0) {
-		err("Could not started cPCI hotplug system");
+		pr_err("Could not started cPCI hotplug system\n");
 		goto init_start_error;
 	}
-	dbg("started cpci hp system");
+	dbg("started cpci hp system\n");
 	return 0;
 init_start_error:
 	cpci_hp_unregister_bus(bus);
 init_bus_register_error:
 	cpci_hp_unregister_controller(&generic_hpc);
-	err("status = %d", status);
+	pr_err("status = %d\n", status);
 	return status;
 
 }
diff --git a/drivers/pci/hotplug/cpcihp_zt5550.c b/drivers/pci/hotplug/cpcihp_zt5550.c
index 41f6a8d..34a8e18 100644
--- a/drivers/pci/hotplug/cpcihp_zt5550.c
+++ b/drivers/pci/hotplug/cpcihp_zt5550.c
@@ -30,6 +30,8 @@
  * Send feedback to <scottm@somanetworks.com>
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/init.h>
@@ -47,14 +49,10 @@
 #define MY_NAME	"cpcihp_zt5550"
 
 #define dbg(format, arg...)					\
-	do {							\
-		if(debug)					\
-			printk (KERN_DEBUG "%s: " format "\n",	\
-				MY_NAME , ## arg); 		\
-	} while(0)
-#define err(format, arg...) printk(KERN_ERR "%s: " format "\n", MY_NAME , ## arg)
-#define info(format, arg...) printk(KERN_INFO "%s: " format "\n", MY_NAME , ## arg)
-#define warn(format, arg...) printk(KERN_WARNING "%s: " format "\n", MY_NAME , ## arg)
+do {								\
+	if (debug)						\
+		pr_debug(format, ##arg);			\
+} while (0)
 
 /* local variables */
 static int debug;
@@ -83,24 +81,26 @@ static int zt5550_hc_config(struct pci_dev *pdev)
 
 	/* Since we know that no boards exist with two HC chips, treat it as an error */
 	if(hc_dev) {
-		err("too many host controller devices?");
+		pr_err("too many host controller devices?\n");
 		return -EBUSY;
 	}
 
 	ret = pci_enable_device(pdev);
 	if(ret) {
-		err("cannot enable %s\n", pci_name(pdev));
+		pr_err("cannot enable %s\n", pci_name(pdev));
 		return ret;
 	}
 
 	hc_dev = pdev;
-	dbg("hc_dev = %p", hc_dev);
-	dbg("pci resource start %llx", (unsigned long long)pci_resource_start(hc_dev, 1));
-	dbg("pci resource len %llx", (unsigned long long)pci_resource_len(hc_dev, 1));
+	dbg("hc_dev = %p\n", hc_dev);
+	dbg("pci resource start %llx\n",
+	    (unsigned long long)pci_resource_start(hc_dev, 1));
+	dbg("pci resource len %llx\n",
+	    (unsigned long long)pci_resource_len(hc_dev, 1));
 
 	if(!request_mem_region(pci_resource_start(hc_dev, 1),
 				pci_resource_len(hc_dev, 1), MY_NAME)) {
-		err("cannot reserve MMIO region");
+		pr_err("cannot reserve MMIO region\n");
 		ret = -ENOMEM;
 		goto exit_disable_device;
 	}
@@ -108,9 +108,9 @@ static int zt5550_hc_config(struct pci_dev *pdev)
 	hc_registers =
 	    ioremap(pci_resource_start(hc_dev, 1), pci_resource_len(hc_dev, 1));
 	if(!hc_registers) {
-		err("cannot remap MMIO region %llx @ %llx",
-			(unsigned long long)pci_resource_len(hc_dev, 1),
-			(unsigned long long)pci_resource_start(hc_dev, 1));
+		pr_err("cannot remap MMIO region %llx @ %llx\n",
+		       (unsigned long long)pci_resource_len(hc_dev, 1),
+		       (unsigned long long)pci_resource_start(hc_dev, 1));
 		ret = -ENODEV;
 		goto exit_release_region;
 	}
@@ -123,17 +123,17 @@ static int zt5550_hc_config(struct pci_dev *pdev)
 	/*
 	 * Disable host control, fault and serial interrupts
 	 */
-	dbg("disabling host control, fault and serial interrupts");
+	dbg("disabling host control, fault and serial interrupts\n");
 	writeb((u8) HC_INT_MASK_REG, csr_hc_index);
 	writeb((u8) ALL_INDEXED_INTS_MASK, csr_hc_data);
-	dbg("disabled host control, fault and serial interrupts");
+	dbg("disabled host control, fault and serial interrupts\n");
 
 	/*
 	 * Disable timer0, timer1 and ENUM interrupts
 	 */
-	dbg("disabling timer0, timer1 and ENUM interrupts");
+	dbg("disabling timer0, timer1 and ENUM interrupts\n");
 	writeb((u8) ALL_DIRECT_INTS_MASK, csr_int_mask);
-	dbg("disabled timer0, timer1 and ENUM interrupts");
+	dbg("disabled timer0, timer1 and ENUM interrupts\n");
 	return 0;
 
 exit_release_region:
@@ -213,7 +213,7 @@ static int zt5550_hc_init_one (struct pci_dev *pdev, const struct pci_device_id
 	if(status != 0) {
 		return status;
 	}
-	dbg("returned from zt5550_hc_config");
+	dbg("returned from zt5550_hc_config\n");
 
 	memset(&zt5550_hpc, 0, sizeof (struct cpci_hp_controller));
 	zt5550_hpc_ops.query_enum = zt5550_hc_query_enum;
@@ -227,15 +227,15 @@ static int zt5550_hc_init_one (struct pci_dev *pdev, const struct pci_device_id
 		zt5550_hpc_ops.disable_irq = zt5550_hc_disable_irq;
 		zt5550_hpc_ops.check_irq = zt5550_hc_check_irq;
 	} else {
-		info("using ENUM# polling mode");
+		pr_info("using ENUM# polling mode\n");
 	}
 
 	status = cpci_hp_register_controller(&zt5550_hpc);
 	if(status != 0) {
-		err("could not register cPCI hotplug controller");
+		pr_err("could not register cPCI hotplug controller\n");
 		goto init_hc_error;
 	}
-	dbg("registered controller");
+	dbg("registered controller\n");
 
 	/* Look for first device matching cPCI bus's bridge vendor and device IDs */
 	if(!(bus0_dev = pci_get_device(PCI_VENDOR_ID_DEC,
@@ -248,24 +248,24 @@ static int zt5550_hc_init_one (struct pci_dev *pdev, const struct pci_device_id
 
 	status = cpci_hp_register_bus(bus0, 0x0a, 0x0f);
 	if(status != 0) {
-		err("could not register cPCI hotplug bus");
+		pr_err("could not register cPCI hotplug bus\n");
 		goto init_register_error;
 	}
-	dbg("registered bus");
+	dbg("registered bus\n");
 
 	status = cpci_hp_start();
 	if(status != 0) {
-		err("could not started cPCI hotplug system");
+		pr_err("could not started cPCI hotplug system\n");
 		cpci_hp_unregister_bus(bus0);
 		goto init_register_error;
 	}
-	dbg("started cpci hp system");
+	dbg("started cpci hp system\n");
 
 	return 0;
 init_register_error:
 	cpci_hp_unregister_controller(&zt5550_hpc);
 init_hc_error:
-	err("status = %d", status);
+	pr_err("status = %d\n", status);
 	zt5550_hc_cleanup();
 	return status;
 
@@ -298,7 +298,7 @@ static int __init zt5550_init(void)
 	struct resource* r;
 	int rc;
 
-	info(DRIVER_DESC " version: " DRIVER_VERSION);
+	pr_info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
 	r = request_region(ENUM_PORT, 1, "#ENUM hotswap signal register");
 	if(!r)
 		return -EBUSY;
diff --git a/drivers/pci/hotplug/cpqphp.h b/drivers/pci/hotplug/cpqphp.h
index d8ffc73..1897f9e 100644
--- a/drivers/pci/hotplug/cpqphp.h
+++ b/drivers/pci/hotplug/cpqphp.h
@@ -36,12 +36,11 @@
 
 #define MY_NAME	"cpqphp"
 
-#define dbg(fmt, arg...) do { if (cpqhp_debug) printk(KERN_DEBUG "%s: " fmt , MY_NAME , ## arg); } while (0)
-#define err(format, arg...) printk(KERN_ERR "%s: " format , MY_NAME , ## arg)
-#define info(format, arg...) printk(KERN_INFO "%s: " format , MY_NAME , ## arg)
-#define warn(format, arg...) printk(KERN_WARNING "%s: " format , MY_NAME , ## arg)
-
-
+#define dbg(fmt, arg...)			\
+do {						\
+	if (cpqhp_debug)			\
+		pr_debug(fmt, ##arg);		\
+} while (0)
 
 struct smbios_system_slot {
 	u8 type;
@@ -393,13 +392,13 @@ struct resource_lists {
  * error Messages
  */
 #define msg_initialization_err	"Initialization failure, error=%d\n"
-#define msg_HPC_rev_error	"Unsupported revision of the PCI hot plug controller found.\n"
-#define msg_HPC_non_compaq_or_intel	"The PCI hot plug controller is not supported by this driver.\n"
+#define msg_HPC_rev_error	"Unsupported revision of the PCI hot plug controller found\n"
+#define msg_HPC_non_compaq_or_intel	"The PCI hot plug controller is not supported by this driver\n"
 #define msg_HPC_not_supported	"this system is not supported by this version of cpqphpd. Upgrade to a newer version of cpqphpd\n"
 #define msg_unable_to_save	"unable to store PCI hot plug add resource information. This system must be rebooted before adding any PCI devices.\n"
-#define msg_button_on		"PCI slot #%d - powering on due to button press.\n"
-#define msg_button_off		"PCI slot #%d - powering off due to button press.\n"
-#define msg_button_cancel	"PCI slot #%d - action canceled due to button press.\n"
+#define msg_button_on		"PCI slot #%d - powering on due to button press\n"
+#define msg_button_off		"PCI slot #%d - powering off due to button press\n"
+#define msg_button_cancel	"PCI slot #%d - action canceled due to button press\n"
 #define msg_button_ignore	"PCI slot #%d - button press ignored.  (action in progress...)\n"
 
 
@@ -691,7 +690,7 @@ static inline int cpq_get_latch_status(struct controller *ctrl,
 	u8 hp_slot;
 
 	hp_slot = slot->device - ctrl->slot_device_offset;
-	dbg("%s: slot->device = %d, ctrl->slot_device_offset = %d \n",
+	dbg("%s: slot->device = %d, ctrl->slot_device_offset = %d\n",
 	    __func__, slot->device, ctrl->slot_device_offset);
 
 	status = (readl(ctrl->hpc_reg + INT_INPUT_CLEAR) & (0x01L << hp_slot));
@@ -721,7 +720,7 @@ static inline int wait_for_ctrl_irq(struct controller *ctrl)
         DECLARE_WAITQUEUE(wait, current);
 	int retval = 0;
 
-	dbg("%s - start\n", __func__);
+	dbg("%s: start\n", __func__);
 	add_wait_queue(&ctrl->queue, &wait);
 	/* Sleep for up to 1 second to wait for the LED to change. */
 	msleep_interruptible(1000);
@@ -729,7 +728,7 @@ static inline int wait_for_ctrl_irq(struct controller *ctrl)
 	if (signal_pending(current))
 		retval =  -EINTR;
 
-	dbg("%s - end\n", __func__);
+	dbg("%s: end\n", __func__);
 	return retval;
 }
 
diff --git a/drivers/pci/hotplug/cpqphp_core.c b/drivers/pci/hotplug/cpqphp_core.c
index 4952c3b..bf73856 100644
--- a/drivers/pci/hotplug/cpqphp_core.c
+++ b/drivers/pci/hotplug/cpqphp_core.c
@@ -28,6 +28,8 @@
  *			Torben Mathiasen <torben.mathiasen@hp.com>
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/kernel.h>
@@ -284,7 +286,7 @@ static void release_slot(struct hotplug_slot *hotplug_slot)
 {
 	struct slot *slot = hotplug_slot->private;
 
-	dbg("%s - physical_slot = %s\n", __func__, slot_name(slot));
+	dbg("%s: physical_slot = %s\n", __func__, slot_name(slot));
 
 	kfree(slot->hotplug_slot->info);
 	kfree(slot->hotplug_slot);
@@ -449,7 +451,7 @@ static int set_attention_status (struct hotplug_slot *hotplug_slot, u8 status)
 	u8 device;
 	u8 function;
 
-	dbg("%s - physical_slot = %s\n", __func__, slot_name(slot));
+	dbg("%s: physical_slot = %s\n", __func__, slot_name(slot));
 
 	if (cpqhp_get_bus_dev(ctrl, &bus, &devfn, slot->number) == -1)
 		return -ENODEV;
@@ -476,7 +478,7 @@ static int process_SI(struct hotplug_slot *hotplug_slot)
 	u8 device;
 	u8 function;
 
-	dbg("%s - physical_slot = %s\n", __func__, slot_name(slot));
+	dbg("%s: physical_slot = %s\n", __func__, slot_name(slot));
 
 	if (cpqhp_get_bus_dev(ctrl, &bus, &devfn, slot->number) == -1)
 		return -ENODEV;
@@ -508,7 +510,7 @@ static int process_SS(struct hotplug_slot *hotplug_slot)
 	u8 device;
 	u8 function;
 
-	dbg("%s - physical_slot = %s\n", __func__, slot_name(slot));
+	dbg("%s: physical_slot = %s\n", __func__, slot_name(slot));
 
 	if (cpqhp_get_bus_dev(ctrl, &bus, &devfn, slot->number) == -1)
 		return -ENODEV;
@@ -531,7 +533,7 @@ static int hardware_test(struct hotplug_slot *hotplug_slot, u32 value)
 	struct slot *slot = hotplug_slot->private;
 	struct controller *ctrl = slot->ctrl;
 
-	dbg("%s - physical_slot = %s\n", __func__, slot_name(slot));
+	dbg("%s: physical_slot = %s\n", __func__, slot_name(slot));
 
 	return cpqhp_hardware_test(ctrl, value);
 }
@@ -542,7 +544,7 @@ static int get_power_status(struct hotplug_slot *hotplug_slot, u8 *value)
 	struct slot *slot = hotplug_slot->private;
 	struct controller *ctrl = slot->ctrl;
 
-	dbg("%s - physical_slot = %s\n", __func__, slot_name(slot));
+	dbg("%s: physical_slot = %s\n", __func__, slot_name(slot));
 
 	*value = get_slot_enabled(ctrl, slot);
 	return 0;
@@ -553,7 +555,7 @@ static int get_attention_status(struct hotplug_slot *hotplug_slot, u8 *value)
 	struct slot *slot = hotplug_slot->private;
 	struct controller *ctrl = slot->ctrl;
 
-	dbg("%s - physical_slot = %s\n", __func__, slot_name(slot));
+	dbg("%s: physical_slot = %s\n", __func__, slot_name(slot));
 
 	*value = cpq_get_attention_status(ctrl, slot);
 	return 0;
@@ -564,7 +566,7 @@ static int get_latch_status(struct hotplug_slot *hotplug_slot, u8 *value)
 	struct slot *slot = hotplug_slot->private;
 	struct controller *ctrl = slot->ctrl;
 
-	dbg("%s - physical_slot = %s\n", __func__, slot_name(slot));
+	dbg("%s: physical_slot = %s\n", __func__, slot_name(slot));
 
 	*value = cpq_get_latch_status(ctrl, slot);
 
@@ -576,7 +578,7 @@ static int get_adapter_status(struct hotplug_slot *hotplug_slot, u8 *value)
 	struct slot *slot = hotplug_slot->private;
 	struct controller *ctrl = slot->ctrl;
 
-	dbg("%s - physical_slot = %s\n", __func__, slot_name(slot));
+	dbg("%s: physical_slot = %s\n", __func__, slot_name(slot));
 
 	*value = get_presence_status(ctrl, slot);
 
@@ -700,17 +702,17 @@ static int ctrl_slot_setup(struct controller *ctrl,
 		hotplug_slot_info->adapter_status =
 			get_presence_status(ctrl, slot);
 
-		dbg("registering bus %d, dev %d, number %d, "
-				"ctrl->slot_device_offset %d, slot %d\n",
-				slot->bus, slot->device,
-				slot->number, ctrl->slot_device_offset,
-				slot_number);
+		dbg("registering bus %d, dev %d, number %d, ctrl->slot_device_offset %d, slot %d\n",
+		    slot->bus, slot->device,
+		    slot->number, ctrl->slot_device_offset,
+		    slot_number);
 		result = pci_hp_register(hotplug_slot,
 					 ctrl->pci_dev->bus,
 					 slot->device,
 					 name);
 		if (result) {
-			err("pci_hp_register failed with error %d\n", result);
+			pr_err("pci_hp_register failed with error %d\n",
+			       result);
 			goto error_info;
 		}
 
@@ -750,7 +752,7 @@ static int one_time_init(void)
 	if (cpqhp_debug)
 		pci_print_IRQ_route();
 
-	dbg("Initialize + Start the notification mechanism \n");
+	dbg("Initialize + Start the notification mechanism\n");
 
 	retval = cpqhp_event_start_thread();
 	if (retval)
@@ -767,7 +769,7 @@ static int one_time_init(void)
 	/* Map rom address */
 	cpqhp_rom_start = ioremap(ROM_PHY_ADDR, ROM_PHY_LEN);
 	if (!cpqhp_rom_start) {
-		err ("Could not ioremap memory region for ROM\n");
+		pr_err("Could not ioremap memory region for ROM\n");
 		retval = -EIO;
 		goto error;
 	}
@@ -781,7 +783,7 @@ static int one_time_init(void)
 	smbios_table = detect_SMBIOS_pointer(cpqhp_rom_start,
 					cpqhp_rom_start + ROM_PHY_LEN);
 	if (!smbios_table) {
-		err ("Could not find the SMBIOS pointer in memory\n");
+		pr_err("Could not find the SMBIOS pointer in memory\n");
 		retval = -EIO;
 		goto error_rom_start;
 	}
@@ -789,7 +791,7 @@ static int one_time_init(void)
 	smbios_start = ioremap(readl(smbios_table + ST_ADDRESS),
 					readw(smbios_table + ST_LENGTH));
 	if (!smbios_start) {
-		err ("Could not ioremap memory region taken from SMBIOS values\n");
+		pr_err("Could not ioremap memory region taken from SMBIOS values\n");
 		retval = -EIO;
 		goto error_smbios_start;
 	}
@@ -824,8 +826,8 @@ static int cpqhpc_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	err = pci_enable_device(pdev);
 	if (err) {
-		printk(KERN_ERR MY_NAME ": cannot enable PCI device %s (%d)\n",
-			pci_name(pdev), err);
+		pr_err("cannot enable PCI device %s (%d)\n",
+		       pci_name(pdev), err);
 		return err;
 	}
 
@@ -842,7 +844,7 @@ static int cpqhpc_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 */
 	rc = pci_read_config_word(pdev, PCI_VENDOR_ID, &vendor_id);
 	if (rc || ((vendor_id != PCI_VENDOR_ID_COMPAQ) && (vendor_id != PCI_VENDOR_ID_INTEL))) {
-		err(msg_HPC_non_compaq_or_intel);
+		pr_err(msg_HPC_non_compaq_or_intel);
 		rc = -ENODEV;
 		goto err_disable_device;
 	}
@@ -850,7 +852,7 @@ static int cpqhpc_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	dbg("revision: %d\n", pdev->revision);
 	if ((vendor_id == PCI_VENDOR_ID_COMPAQ) && (!pdev->revision)) {
-		err(msg_HPC_rev_error);
+		pr_err(msg_HPC_rev_error);
 		rc = -ENODEV;
 		goto err_disable_device;
 	}
@@ -861,7 +863,7 @@ static int cpqhpc_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 * Also Intel HPC's may have RID=0.
 	 */
 	if ((pdev->revision <= 2) && (vendor_id != PCI_VENDOR_ID_INTEL)) {
-		err(msg_HPC_not_supported);
+		pr_err(msg_HPC_not_supported);
 		return -ENODEV;
 	}
 
@@ -870,30 +872,30 @@ static int cpqhpc_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 */
 	rc = pci_read_config_word(pdev, PCI_SUBSYSTEM_VENDOR_ID, &subsystem_vid);
 	if (rc) {
-		err("%s : pci_read_config_word failed\n", __func__);
+		pr_err("%s: pci_read_config_word failed\n", __func__);
 		goto err_disable_device;
 	}
 	dbg("Subsystem Vendor ID: %x\n", subsystem_vid);
 	if ((subsystem_vid != PCI_VENDOR_ID_COMPAQ) && (subsystem_vid != PCI_VENDOR_ID_INTEL)) {
-		err(msg_HPC_non_compaq_or_intel);
+		pr_err(msg_HPC_non_compaq_or_intel);
 		rc = -ENODEV;
 		goto err_disable_device;
 	}
 
 	ctrl = kzalloc(sizeof(struct controller), GFP_KERNEL);
 	if (!ctrl) {
-		err("%s : out of memory\n", __func__);
+		pr_err("%s: out of memory\n", __func__);
 		rc = -ENOMEM;
 		goto err_disable_device;
 	}
 
 	rc = pci_read_config_word(pdev, PCI_SUBSYSTEM_ID, &subsystem_deviceid);
 	if (rc) {
-		err("%s : pci_read_config_word failed\n", __func__);
+		pr_err("%s: pci_read_config_word failed\n", __func__);
 		goto err_free_ctrl;
 	}
 
-	info("Hot Plug Subsystem Device ID: %x\n", subsystem_deviceid);
+	pr_info("Hot Plug Subsystem Device ID: %x\n", subsystem_deviceid);
 
 	/* Set Vendor ID, so it can be accessed later from other
 	 * functions
@@ -990,7 +992,7 @@ static int cpqhpc_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 			ctrl->pcix_speed_capability = 0;
 			break;
 		default:
-			err(msg_HPC_not_supported);
+			pr_err(msg_HPC_not_supported);
 			rc = -ENODEV;
 			goto err_free_ctrl;
 		}
@@ -1053,29 +1055,29 @@ static int cpqhpc_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		break;
 
 	default:
-		err(msg_HPC_not_supported);
+		pr_err(msg_HPC_not_supported);
 		rc = -ENODEV;
 		goto err_free_ctrl;
 	}
 
 	/* Tell the user that we found one. */
-	info("Initializing the PCI hot plug controller residing on PCI bus %d\n",
-					pdev->bus->number);
+	pr_info("Initializing the PCI hot plug controller residing on PCI bus %d\n",
+		pdev->bus->number);
 
 	dbg("Hotplug controller capabilities:\n");
 	dbg("    speed_capability       %d\n", bus->max_bus_speed);
-	dbg("    slot_switch_type       %s\n", ctrl->slot_switch_type ?
-					"switch present" : "no switch");
-	dbg("    defeature_PHP          %s\n", ctrl->defeature_PHP ?
-					"PHP supported" : "PHP not supported");
-	dbg("    alternate_base_address %s\n", ctrl->alternate_base_address ?
-					"supported" : "not supported");
-	dbg("    pci_config_space       %s\n", ctrl->pci_config_space ?
-					"supported" : "not supported");
-	dbg("    pcix_speed_capability  %s\n", ctrl->pcix_speed_capability ?
-					"supported" : "not supported");
-	dbg("    pcix_support           %s\n", ctrl->pcix_support ?
-					"supported" : "not supported");
+	dbg("    slot_switch_type       %s\n",
+	    ctrl->slot_switch_type ? "switch present" : "no switch");
+	dbg("    defeature_PHP          %s\n",
+	    ctrl->defeature_PHP ? "PHP supported" : "PHP not supported");
+	dbg("    alternate_base_address %s\n",
+	    ctrl->alternate_base_address ? "supported" : "not supported");
+	dbg("    pci_config_space       %s\n",
+	    ctrl->pci_config_space ? "supported" : "not supported");
+	dbg("    pcix_speed_capability  %s\n",
+	    ctrl->pcix_speed_capability ? "supported" : "not supported");
+	dbg("    pcix_support           %s\n",
+	    ctrl->pcix_support ? "supported" : "not supported");
 
 	ctrl->pci_dev = pdev;
 	pci_set_drvdata(pdev, ctrl);
@@ -1084,15 +1086,15 @@ static int cpqhpc_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 * as we like tweaking it a lot */
 	ctrl->pci_bus = kmemdup(pdev->bus, sizeof(*ctrl->pci_bus), GFP_KERNEL);
 	if (!ctrl->pci_bus) {
-		err("out of memory\n");
+		pr_err("out of memory\n");
 		rc = -ENOMEM;
 		goto err_free_ctrl;
 	}
 
 	ctrl->bus = pdev->bus->number;
 	ctrl->rev = pdev->revision;
-	dbg("bus device function rev: %d %d %d %d\n", ctrl->bus,
-		PCI_SLOT(pdev->devfn), PCI_FUNC(pdev->devfn), ctrl->rev);
+	dbg("bus device function rev: %d %d %d %d\n",
+	    ctrl->bus, PCI_SLOT(pdev->devfn), PCI_FUNC(pdev->devfn), ctrl->rev);
 
 	mutex_init(&ctrl->crit_sect);
 	init_waitqueue_head(&ctrl->queue);
@@ -1104,12 +1106,14 @@ static int cpqhpc_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	dbg("pdev = %p\n", pdev);
-	dbg("pci resource start %llx\n", (unsigned long long)pci_resource_start(pdev, 0));
-	dbg("pci resource len %llx\n", (unsigned long long)pci_resource_len(pdev, 0));
+	dbg("pci resource start %llx\n",
+	    (unsigned long long)pci_resource_start(pdev, 0));
+	dbg("pci resource len %llx\n",
+	    (unsigned long long)pci_resource_len(pdev, 0));
 
 	if (!request_mem_region(pci_resource_start(pdev, 0),
 				pci_resource_len(pdev, 0), MY_NAME)) {
-		err("cannot reserve MMIO region\n");
+		pr_err("cannot reserve MMIO region\n");
 		rc = -ENOMEM;
 		goto err_free_bus;
 	}
@@ -1117,9 +1121,9 @@ static int cpqhpc_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	ctrl->hpc_reg = ioremap(pci_resource_start(pdev, 0),
 					pci_resource_len(pdev, 0));
 	if (!ctrl->hpc_reg) {
-		err("cannot remap MMIO region %llx @ %llx\n",
-		    (unsigned long long)pci_resource_len(pdev, 0),
-		    (unsigned long long)pci_resource_start(pdev, 0));
+		pr_err("cannot remap MMIO region %llx @ %llx\n",
+		       (unsigned long long)pci_resource_len(pdev, 0),
+		       (unsigned long long)pci_resource_start(pdev, 0));
 		rc = -ENODEV;
 		goto err_free_mem_region;
 	}
@@ -1146,17 +1150,17 @@ static int cpqhpc_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 				(readb(ctrl->hpc_reg + SLOT_MASK) >> 4),
 				&(ctrl->first_slot));
 	dbg("get_slot_mapping: first_slot = %d, returned = %d\n",
-				ctrl->first_slot, rc);
+	    ctrl->first_slot, rc);
 	if (rc) {
-		err(msg_initialization_err, rc);
+		pr_err(msg_initialization_err, rc);
 		goto err_iounmap;
 	}
 
 	/* Store PCI Config Space for all devices on this bus */
 	rc = cpqhp_save_config(ctrl, ctrl->bus, readb(ctrl->hpc_reg + SLOT_MASK));
 	if (rc) {
-		err("%s: unable to save PCI configuration data, error %d\n",
-				__func__, rc);
+		pr_err("%s: unable to save PCI configuration data, error %d\n",
+		       __func__, rc);
 		goto err_iounmap;
 	}
 
@@ -1177,7 +1181,7 @@ static int cpqhpc_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	ctrl->add_support = !rc;
 	if (rc) {
 		dbg("cpqhp_find_available_resources = 0x%x\n", rc);
-		err("unable to locate PCI configuration resources for hot plug add.\n");
+		pr_err("unable to locate PCI configuration resources for hot plug add\n");
 		goto err_iounmap;
 	}
 
@@ -1185,16 +1189,16 @@ static int cpqhpc_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 * Finish setting up the hot plug ctrl device
 	 */
 	ctrl->slot_device_offset = readb(ctrl->hpc_reg + SLOT_MASK) >> 4;
-	dbg("NumSlots %d \n", ctrl->slot_device_offset);
+	dbg("NumSlots %d\n", ctrl->slot_device_offset);
 
 	ctrl->next_event = 0;
 
 	/* Setup the slot information structures */
 	rc = ctrl_slot_setup(ctrl, smbios_start, smbios_table);
 	if (rc) {
-		err(msg_initialization_err, 6);
-		err("%s: unable to save PCI configuration data, error %d\n",
-			__func__, rc);
+		pr_err(msg_initialization_err, 6);
+		pr_err("%s: unable to save PCI configuration data, error %d\n",
+		       __func__, rc);
 		goto err_iounmap;
 	}
 
@@ -1202,11 +1206,11 @@ static int cpqhpc_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	writel(0xFFFFFFFFL, ctrl->hpc_reg + INT_MASK);
 
 	/* set up the interrupt */
-	dbg("HPC interrupt = %d \n", ctrl->interrupt);
+	dbg("HPC interrupt = %d\n", ctrl->interrupt);
 	if (request_irq(ctrl->interrupt, cpqhp_ctrl_intr,
 			IRQF_SHARED, MY_NAME, ctrl)) {
-		err("Can't get irq %d for the hotplug pci controller\n",
-			ctrl->interrupt);
+		pr_err("Can't get irq %d for the hotplug pci controller\n",
+		       ctrl->interrupt);
 		rc = -ENODEV;
 		goto err_iounmap;
 	}
@@ -1280,7 +1284,7 @@ static int cpqhpc_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	rc = init_SERR(ctrl);
 	if (rc) {
-		err("init_SERR failed\n");
+		pr_err("init_SERR failed\n");
 		mutex_unlock(&ctrl->crit_sect);
 		goto err_free_irq;
 	}
@@ -1450,7 +1454,7 @@ static int __init cpqhpc_init(void)
 
 	cpqhp_debug = debug;
 
-	info (DRIVER_DESC " version: " DRIVER_VERSION "\n");
+	pr_info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
 	cpqhp_initialize_debugfs();
 	result = pci_register_driver(&cpqhpc_driver);
 	dbg("pci_register_driver = %d\n", result);
diff --git a/drivers/pci/hotplug/cpqphp_ctrl.c b/drivers/pci/hotplug/cpqphp_ctrl.c
index e43908d..cc39c43 100644
--- a/drivers/pci/hotplug/cpqphp_ctrl.c
+++ b/drivers/pci/hotplug/cpqphp_ctrl.c
@@ -26,6 +26,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
@@ -76,7 +78,7 @@ static u8 handle_switch_change(u8 change, struct controller * ctrl)
 		return 0;
 
 	/* Switch Change */
-	dbg("cpqsbd:  Switch interrupt received.\n");
+	dbg("Switch interrupt received\n");
 
 	for (hp_slot = 0; hp_slot < 6; hp_slot++) {
 		if (change & (0x1L << hp_slot)) {
@@ -154,8 +156,8 @@ static u8 handle_presence_change(u16 change, struct controller * ctrl)
 	/*
 	 * Presence Change
 	 */
-	dbg("cpqsbd:  Presence/Notify input change.\n");
-	dbg("         Changed bits are 0x%4.4x\n", change );
+	dbg("Presence/Notify input change\n");
+	dbg("Changed bits are 0x%4.4x\n", change);
 
 	for (hp_slot = 0; hp_slot < 6; hp_slot++) {
 		if (change & (0x0101 << hp_slot)) {
@@ -187,25 +189,29 @@ static u8 handle_presence_change(u16 change, struct controller * ctrl)
 					/*
 					 * button Pressed (doesn't do anything)
 					 */
-					dbg("hp_slot %d button pressed\n", hp_slot);
+					dbg("hp_slot %d button pressed\n",
+					    hp_slot);
 					taskInfo->event_type = INT_BUTTON_PRESS;
 				} else {
 					/*
 					 * button Released - TAKE ACTION!!!!
 					 */
-					dbg("hp_slot %d button released\n", hp_slot);
+					dbg("hp_slot %d button released\n",
+					    hp_slot);
 					taskInfo->event_type = INT_BUTTON_RELEASE;
 
 					/* Cancel if we are still blinking */
 					if ((p_slot->state == BLINKINGON_STATE)
 					    || (p_slot->state == BLINKINGOFF_STATE)) {
 						taskInfo->event_type = INT_BUTTON_CANCEL;
-						dbg("hp_slot %d button cancel\n", hp_slot);
+						dbg("hp_slot %d button cancel\n",
+						    hp_slot);
 					} else if ((p_slot->state == POWERON_STATE)
 						   || (p_slot->state == POWEROFF_STATE)) {
-						/* info(msg_button_ignore, p_slot->number); */
+						/* pr_info(msg_button_ignore, p_slot->number); */
 						taskInfo->event_type = INT_BUTTON_IGNORE;
-						dbg("hp_slot %d button ignore\n", hp_slot);
+						dbg("hp_slot %d button ignore\n",
+						    hp_slot);
 					}
 				}
 			} else {
@@ -246,7 +252,7 @@ static u8 handle_power_fault(u8 change, struct controller * ctrl)
 	 * power fault
 	 */
 
-	info("power fault interrupt\n");
+	pr_info("power fault interrupt\n");
 
 	for (hp_slot = 0; hp_slot < 6; hp_slot++) {
 		if (change & (0x01 << hp_slot)) {
@@ -295,7 +301,8 @@ static u8 handle_power_fault(u8 change, struct controller * ctrl)
 				} else {
 					/* set power fault status for this board */
 					func->status = 0xFF;
-					info("power fault bit %x set\n", hp_slot);
+					pr_info("power fault bit %x set\n",
+						hp_slot);
 				}
 			}
 		}
@@ -835,13 +842,13 @@ int cpqhp_resource_sort_and_combine(struct pci_resource **head)
 	if (!(*head))
 		return 1;
 
-	dbg("*head->next = %p\n",(*head)->next);
+	dbg("*head->next = %p\n", (*head)->next);
 
 	if (!(*head)->next)
 		return 0;	/* only one item on the list, already sorted! */
 
-	dbg("*head->base = 0x%x\n",(*head)->base);
-	dbg("*head->next->base = 0x%x\n",(*head)->next->base);
+	dbg("*head->base = 0x%x\n", (*head)->base);
+	dbg("*head->next->base = 0x%x\n", (*head)->next->base);
 	while (out_of_order) {
 		out_of_order = 0;
 
@@ -875,7 +882,7 @@ int cpqhp_resource_sort_and_combine(struct pci_resource **head)
 	while (node1 && node1->next) {
 		if ((node1->base + node1->length) == node1->next->base) {
 			/* Combine */
-			dbg("8..\n");
+			dbg("8...\n");
 			node1->length += node1->next->length;
 			node2 = node1->next;
 			node1->next = node1->next->next;
@@ -918,7 +925,7 @@ irqreturn_t cpqhp_ctrl_intr(int IRQ, void *data)
 		/* Read to clear posted writes */
 		misc = readw(ctrl->hpc_reg + MISC);
 
-		dbg ("%s - waking up\n", __func__);
+		dbg("%s: waking up\n", __func__);
 		wake_up_interruptible(&ctrl->queue);
 	}
 
@@ -954,7 +961,7 @@ irqreturn_t cpqhp_ctrl_intr(int IRQ, void *data)
 
 	if (schedule_flag) {
 		wake_up_process(cpqhp_event_thread);
-		dbg("Waking even thread");
+		dbg("Waking even thread\n");
 	}
 	return IRQ_HANDLED;
 }
@@ -1247,8 +1254,8 @@ static u8 set_controller_speed(struct controller *ctrl, u8 adapter_speed, u8 hp_
 	bus->cur_bus_speed = adapter_speed;
 	slot = cpqhp_find_slot(ctrl, hp_slot + ctrl->slot_device_offset);
 
-	info("Successfully changed frequency/mode for adapter in slot %d\n",
-			slot->number);
+	pr_info("Successfully changed frequency/mode for adapter in slot %d\n",
+		slot->number);
 	return 0;
 }
 
@@ -1515,7 +1522,8 @@ static u32 board_added(struct pci_func *func, struct controller *ctrl)
 	if (func->status == 0xFF) {
 		/* power fault occurred, but it was benign */
 		temp_register = 0xFFFFFFFF;
-		dbg("%s: temp register set to %x by power fault\n", __func__, temp_register);
+		dbg("%s: temp register set to %x by power fault\n",
+		    __func__, temp_register);
 		rc = POWER_FAILURE;
 		func->status = 0;
 	} else {
@@ -1528,7 +1536,8 @@ static u32 board_added(struct pci_func *func, struct controller *ctrl)
 		if (rc != 0) {
 			/* Something's wrong here */
 			temp_register = 0xFFFFFFFF;
-			dbg("%s: temp register set to %x by error\n", __func__, temp_register);
+			dbg("%s: temp register set to %x by error\n",
+			    __func__, temp_register);
 		}
 		/* Preset return code.  It will be changed later if things go okay. */
 		rc = NO_ADAPTER_PRESENT;
@@ -1767,7 +1776,7 @@ int cpqhp_event_start_thread(void)
 {
 	cpqhp_event_thread = kthread_run(event_thread, NULL, "phpd_event");
 	if (IS_ERR(cpqhp_event_thread)) {
-		err ("Can't start up our event thread\n");
+		pr_err("Can't start up our event thread\n");
 		return PTR_ERR(cpqhp_event_thread);
 	}
 
@@ -1845,7 +1854,8 @@ static void interrupt_event_handler(struct controller *ctrl)
 						green_LED_off (ctrl, hp_slot);
 					}
 
-					info(msg_button_cancel, p_slot->number);
+					pr_info(msg_button_cancel,
+						p_slot->number);
 
 					p_slot->state = STATIC_STATE;
 
@@ -1865,11 +1875,13 @@ static void interrupt_event_handler(struct controller *ctrl)
 					if (is_slot_enabled (ctrl, hp_slot)) {
 						dbg("slot is on\n");
 						p_slot->state = BLINKINGOFF_STATE;
-						info(msg_button_off, p_slot->number);
+						pr_info(msg_button_off,
+							p_slot->number);
 					} else {
 						dbg("slot is off\n");
 						p_slot->state = BLINKINGON_STATE;
-						info(msg_button_on, p_slot->number);
+						pr_info(msg_button_on,
+							p_slot->number);
 					}
 					mutex_lock(&ctrl->crit_sect);
 
@@ -2301,7 +2313,7 @@ static u32 configure_new_device(struct controller * ctrl, struct pci_func * func
 		rc = configure_new_function(ctrl, new_slot, behind_bridge, resources);
 
 		if (rc) {
-			dbg("configure_new_function failed %d\n",rc);
+			dbg("configure_new_function failed %d\n", rc);
 			index = 0;
 
 			while (new_slot) {
@@ -2429,7 +2441,8 @@ static int configure_new_function(struct controller *ctrl, struct pci_func *func
 
 		/* set subordinate bus */
 		temp_byte = bus_node->base + bus_node->length - 1;
-		dbg("set subordinate bus = %d\n", bus_node->base + bus_node->length - 1);
+		dbg("set subordinate bus = %d\n",
+		    bus_node->base + bus_node->length - 1);
 		rc = pci_bus_write_config_byte(pci_bus, devfn, PCI_SUBORDINATE_BUS, temp_byte);
 		if (rc)
 			return rc;
@@ -2461,14 +2474,14 @@ static int configure_new_function(struct controller *ctrl, struct pci_func *func
 			return -ENOMEM;
 		dbg("Setup the IO, memory, and prefetchable windows\n");
 		dbg("io_node\n");
-		dbg("(base, len, next) (%x, %x, %p)\n", io_node->base,
-					io_node->length, io_node->next);
+		dbg("(base, len, next) (%x, %x, %p)\n",
+		    io_node->base, io_node->length, io_node->next);
 		dbg("mem_node\n");
-		dbg("(base, len, next) (%x, %x, %p)\n", mem_node->base,
-					mem_node->length, mem_node->next);
+		dbg("(base, len, next) (%x, %x, %p)\n",
+		    mem_node->base, mem_node->length, mem_node->next);
 		dbg("p_mem_node\n");
-		dbg("(base, len, next) (%x, %x, %p)\n", p_mem_node->base,
-					p_mem_node->length, p_mem_node->next);
+		dbg("(base, len, next) (%x, %x, %p)\n",
+		    p_mem_node->base, p_mem_node->length, p_mem_node->next);
 
 		/* set up the IRQ info */
 		if (!resources->irqs) {
@@ -2600,7 +2613,7 @@ static int configure_new_function(struct controller *ctrl, struct pci_func *func
 				new_slot->status = 0;
 
 				rc = configure_new_device(ctrl, new_slot, 1, &temp_resources);
-				dbg("configure_new_device rc=0x%x\n",rc);
+				dbg("configure_new_device rc=0x%x\n", rc);
 			}	/* End of IF (device in slot?) */
 		}		/* End of FOR loop */
 
@@ -2830,7 +2843,8 @@ static int configure_new_function(struct controller *ctrl, struct pci_func *func
 		for (cloop = 0x10; cloop <= 0x24; cloop += 4) {
 			temp_register = 0xFFFFFFFF;
 
-			dbg("CND: bus=%d, devfn=%d, offset=%d\n", pci_bus->number, devfn, cloop);
+			dbg("CND: bus=%d, devfn=%d, offset=%d\n",
+			    pci_bus->number, devfn, cloop);
 			rc = pci_bus_write_config_dword (pci_bus, devfn, cloop, temp_register);
 
 			rc = pci_bus_read_config_dword (pci_bus, devfn, cloop, &temp_register);
@@ -2847,8 +2861,10 @@ static int configure_new_function(struct controller *ctrl, struct pci_func *func
 					dbg("CND:      length = 0x%x\n", base);
 					io_node = get_io_resource(&(resources->io_head), base);
 					dbg("Got io_node start = %8.8x, length = %8.8x next (%p)\n",
-					    io_node->base, io_node->length, io_node->next);
-					dbg("func (%p) io_head (%p)\n", func, func->io_head);
+					    io_node->base, io_node->length,
+					    io_node->next);
+					dbg("func (%p) io_head (%p)\n",
+					    func, func->io_head);
 
 					/* allocate the resource to the board */
 					if (io_node) {
diff --git a/drivers/pci/hotplug/cpqphp_nvram.c b/drivers/pci/hotplug/cpqphp_nvram.c
index 76ba8a1..928d85e 100644
--- a/drivers/pci/hotplug/cpqphp_nvram.c
+++ b/drivers/pci/hotplug/cpqphp_nvram.c
@@ -26,6 +26,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
@@ -161,7 +163,7 @@ static int check_for_compaq_ROM (void __iomem *rom_start)
 	    (temp6 == 'Q')) {
 		result = 1;
 	}
-	dbg ("%s - returned %d\n", __func__, result);
+	dbg("%s: returned %d\n", __func__, result);
 	return result;
 }
 
@@ -418,7 +420,7 @@ static u32 store_HRT (void __iomem *rom_start)
 	evbuffer_length = temp_dword;
 
 	if (rc) {
-		err(msg_unable_to_save);
+		pr_err(msg_unable_to_save);
 		return(1);
 	}
 
@@ -530,7 +532,7 @@ int compaq_nvram_load (void __iomem *rom_start, struct controller *ctrl)
 				break;
 
 			mem_node->base = *(u32*)p_byte;
-			dbg("mem base = %8.8x\n",mem_node->base);
+			dbg("mem base = %8.8x\n", mem_node->base);
 			p_byte += 4;
 
 			if (p_byte > ((u8*)p_EV_header + evbuffer_length)) {
@@ -539,7 +541,7 @@ int compaq_nvram_load (void __iomem *rom_start, struct controller *ctrl)
 			}
 
 			mem_node->length = *(u32*)p_byte;
-			dbg("mem length = %8.8x\n",mem_node->length);
+			dbg("mem length = %8.8x\n", mem_node->length);
 			p_byte += 4;
 
 			if (p_byte > ((u8*)p_EV_header + evbuffer_length)) {
@@ -558,7 +560,7 @@ int compaq_nvram_load (void __iomem *rom_start, struct controller *ctrl)
 				break;
 
 			p_mem_node->base = *(u32*)p_byte;
-			dbg("pre-mem base = %8.8x\n",p_mem_node->base);
+			dbg("pre-mem base = %8.8x\n", p_mem_node->base);
 			p_byte += 4;
 
 			if (p_byte > ((u8*)p_EV_header + evbuffer_length)) {
@@ -567,7 +569,7 @@ int compaq_nvram_load (void __iomem *rom_start, struct controller *ctrl)
 			}
 
 			p_mem_node->length = *(u32*)p_byte;
-			dbg("pre-mem length = %8.8x\n",p_mem_node->length);
+			dbg("pre-mem length = %8.8x\n", p_mem_node->length);
 			p_byte += 4;
 
 			if (p_byte > ((u8*)p_EV_header + evbuffer_length)) {
@@ -586,7 +588,7 @@ int compaq_nvram_load (void __iomem *rom_start, struct controller *ctrl)
 				break;
 
 			io_node->base = *(u32*)p_byte;
-			dbg("io base = %8.8x\n",io_node->base);
+			dbg("io base = %8.8x\n", io_node->base);
 			p_byte += 4;
 
 			if (p_byte > ((u8*)p_EV_header + evbuffer_length)) {
@@ -595,7 +597,7 @@ int compaq_nvram_load (void __iomem *rom_start, struct controller *ctrl)
 			}
 
 			io_node->length = *(u32*)p_byte;
-			dbg("io length = %8.8x\n",io_node->length);
+			dbg("io length = %8.8x\n", io_node->length);
 			p_byte += 4;
 
 			if (p_byte > ((u8*)p_EV_header + evbuffer_length)) {
@@ -663,7 +665,7 @@ int compaq_nvram_store (void __iomem *rom_start)
 	if (evbuffer_init) {
 		rc = store_HRT(rom_start);
 		if (rc) {
-			err(msg_unable_to_save);
+			pr_err(msg_unable_to_save);
 		}
 	}
 	return rc;
diff --git a/drivers/pci/hotplug/cpqphp_pci.c b/drivers/pci/hotplug/cpqphp_pci.c
index 6173b9a..33a1bab 100644
--- a/drivers/pci/hotplug/cpqphp_pci.c
+++ b/drivers/pci/hotplug/cpqphp_pci.c
@@ -121,7 +121,8 @@ int cpqhp_unconfigure_device(struct pci_func* func)
 {
 	int j;
 
-	dbg("%s: bus/dev/func = %x/%x/%x\n", __func__, func->bus, func->device, func->function);
+	dbg("%s: bus/dev/func = %x/%x/%x\n",
+	    __func__, func->bus, func->device, func->function);
 
 	for (j=0; j<8 ; j++) {
 		struct pci_dev* temp = pci_get_bus_and_slot(func->bus, PCI_DEVFN(func->device, j));
@@ -209,7 +210,8 @@ static int PCI_ScanBusForNonBridge(struct controller *ctrl, u8 bus_num, u8 * dev
 		/* Scan for access first */
 		if (PCI_RefinedAccessConfig(ctrl->pci_bus, tdevice, 0x08, &work) == -1)
 			continue;
-		dbg("Looking for nonbridge bus_num %d dev_num %d\n", bus_num, tdevice);
+		dbg("Looking for nonbridge bus_num %d dev_num %d\n",
+		    bus_num, tdevice);
 		/* Yep we got one. Not a bridge ? */
 		if ((work >> 8) != PCI_TO_PCI_BRIDGE_CLASS) {
 			*dev_num = tdevice;
@@ -221,12 +223,14 @@ static int PCI_ScanBusForNonBridge(struct controller *ctrl, u8 bus_num, u8 * dev
 		/* Scan for access first */
 		if (PCI_RefinedAccessConfig(ctrl->pci_bus, tdevice, 0x08, &work) == -1)
 			continue;
-		dbg("Looking for bridge bus_num %d dev_num %d\n", bus_num, tdevice);
+		dbg("Looking for bridge bus_num %d dev_num %d\n",
+		    bus_num, tdevice);
 		/* Yep we got one. bridge ? */
 		if ((work >> 8) == PCI_TO_PCI_BRIDGE_CLASS) {
 			pci_bus_read_config_byte (ctrl->pci_bus, PCI_DEVFN(tdevice, 0), PCI_SECONDARY_BUS, &tbus);
 			/* XXX: no recursion, wtf? */
-			dbg("Recurse on bus_num %d tdevice %d\n", tbus, tdevice);
+			dbg("Recurse on bus_num %d tdevice %d\n",
+			    tbus, tdevice);
 			return 0;
 		}
 	}
@@ -257,7 +261,8 @@ static int PCI_GetBusDevHelper(struct controller *ctrl, u8 *bus_num, u8 *dev_num
 
 			dbg("bus_num %d devfn %d\n", *bus_num, *dev_num);
 			pci_bus_read_config_dword (ctrl->pci_bus, *dev_num, PCI_CLASS_REVISION, &work);
-			dbg("work >> 8 (%x) = BRIDGE (%x)\n", work >> 8, PCI_TO_PCI_BRIDGE_CLASS);
+			dbg("work >> 8 (%x) = BRIDGE (%x)\n",
+			    work >> 8, PCI_TO_PCI_BRIDGE_CLASS);
 
 			if ((work >> 8) == PCI_TO_PCI_BRIDGE_CLASS) {
 				pci_bus_read_config_byte (ctrl->pci_bus, *dev_num, PCI_SECONDARY_BUS, &tbus);
@@ -995,9 +1000,14 @@ int cpqhp_configure_board(struct controller *ctrl, struct pci_func * func)
 				pci_bus_read_config_dword (pci_bus, devfn, cloop, &temp);
 
 				if (temp != func->config_space[cloop >> 2]) {
-					dbg("Config space compare failure!!! offset = %x\n", cloop);
-					dbg("bus = %x, device = %x, function = %x\n", func->bus, func->device, func->function);
-					dbg("temp = %x, config space = %x\n\n", temp, func->config_space[cloop >> 2]);
+					dbg("Config space compare failure!!! offset = %x\n",
+					    cloop);
+					dbg("bus = %x, device = %x, function = %x\n",
+					    func->bus, func->device,
+					    func->function);
+					dbg("temp = %x, config space = %x\n",
+					    temp,
+					    func->config_space[cloop >> 2]);
 					return 1;
 				}
 			}
@@ -1251,7 +1261,8 @@ int cpqhp_find_available_resources(struct controller *ctrl, void __iomem *rom_st
 		u16 pre_mem_length = readw(one_slot + PRE_MEM_LENGTH);
 
 		dbg("%2.2x | %4.4x  | %4.4x | %4.4x   | %4.4x | %4.4x   | %4.4x |%2.2x %2.2x %2.2x\n",
-		    dev_func, io_base, io_length, mem_base, mem_length, pre_mem_base, pre_mem_length,
+		    dev_func, io_base, io_length, mem_base, mem_length,
+		    pre_mem_base, pre_mem_length,
 		    primary_bus, secondary_bus, max_bus);
 
 		/* If this entry isn't for our controller's bus, ignore it */
@@ -1270,7 +1281,8 @@ int cpqhp_find_available_resources(struct controller *ctrl, void __iomem *rom_st
 			func = cpqhp_slot_find(primary_bus, dev_func >> 3, 0);
 
 			while (func && (func->function != (dev_func & 0x07))) {
-				dbg("func = %p (bus, dev, fun) = (%d, %d, %d)\n", func, primary_bus, dev_func >> 3, index);
+				dbg("func = %p (bus, dev, fun) = (%d, %d, %d)\n",
+				    func, primary_bus, dev_func >> 3, index);
 				func = cpqhp_slot_find(primary_bus, dev_func >> 3, index++);
 			}
 
@@ -1306,8 +1318,8 @@ int cpqhp_find_available_resources(struct controller *ctrl, void __iomem *rom_st
 			io_node->length = io_length;
 
 			dbg("found io_node(base, length) = %x, %x\n",
-					io_node->base, io_node->length);
-			dbg("populated slot =%d \n", populated_slot);
+			    io_node->base, io_node->length);
+			dbg("populated slot =%d\n", populated_slot);
 			if (!populated_slot) {
 				io_node->next = ctrl->io_head;
 				ctrl->io_head = io_node;
@@ -1329,8 +1341,8 @@ int cpqhp_find_available_resources(struct controller *ctrl, void __iomem *rom_st
 			mem_node->length = mem_length << 16;
 
 			dbg("found mem_node(base, length) = %x, %x\n",
-					mem_node->base, mem_node->length);
-			dbg("populated slot =%d \n", populated_slot);
+			    mem_node->base, mem_node->length);
+			dbg("populated slot =%d\n", populated_slot);
 			if (!populated_slot) {
 				mem_node->next = ctrl->mem_head;
 				ctrl->mem_head = mem_node;
@@ -1353,8 +1365,8 @@ int cpqhp_find_available_resources(struct controller *ctrl, void __iomem *rom_st
 
 			p_mem_node->length = pre_mem_length << 16;
 			dbg("found p_mem_node(base, length) = %x, %x\n",
-					p_mem_node->base, p_mem_node->length);
-			dbg("populated slot =%d \n", populated_slot);
+			    p_mem_node->base, p_mem_node->length);
+			dbg("populated slot =%d\n", populated_slot);
 
 			if (!populated_slot) {
 				p_mem_node->next = ctrl->p_mem_head;
@@ -1377,8 +1389,8 @@ int cpqhp_find_available_resources(struct controller *ctrl, void __iomem *rom_st
 			bus_node->base = secondary_bus;
 			bus_node->length = max_bus - secondary_bus + 1;
 			dbg("found bus_node(base, length) = %x, %x\n",
-					bus_node->base, bus_node->length);
-			dbg("populated slot =%d \n", populated_slot);
+			    bus_node->base, bus_node->length);
+			dbg("populated slot =%d\n", populated_slot);
 			if (!populated_slot) {
 				bus_node->next = ctrl->bus_head;
 				ctrl->bus_head = bus_node;
diff --git a/drivers/pci/hotplug/ibmphp.h b/drivers/pci/hotplug/ibmphp.h
index a8d391a..90283ab 100644
--- a/drivers/pci/hotplug/ibmphp.h
+++ b/drivers/pci/hotplug/ibmphp.h
@@ -39,12 +39,16 @@ extern int ibmphp_debug;
 #else
 	#define MY_NAME THIS_MODULE->name
 #endif
-#define debug(fmt, arg...) do { if (ibmphp_debug == 1) printk(KERN_DEBUG "%s: " fmt , MY_NAME , ## arg); } while (0)
-#define debug_pci(fmt, arg...) do { if (ibmphp_debug) printk(KERN_DEBUG "%s: " fmt , MY_NAME , ## arg); } while (0)
-#define err(format, arg...) printk(KERN_ERR "%s: " format , MY_NAME , ## arg)
-#define info(format, arg...) printk(KERN_INFO "%s: " format , MY_NAME , ## arg)
-#define warn(format, arg...) printk(KERN_WARNING "%s: " format , MY_NAME , ## arg)
-
+#define debug(fmt, arg...)			\
+do {						\
+	if (ibmphp_debug == 1)			\
+		pr_debug(fmt, ##arg);		\
+} while (0)
+#define debug_pci(fmt, arg...)			\
+do {						\
+	if (ibmphp_debug)			\
+		pr_debug(fmt, ## arg);		\
+} while (0)
 
 /* EBDA stuff */
 
diff --git a/drivers/pci/hotplug/ibmphp_core.c b/drivers/pci/hotplug/ibmphp_core.c
index d934dd4..19753a9 100644
--- a/drivers/pci/hotplug/ibmphp_core.c
+++ b/drivers/pci/hotplug/ibmphp_core.c
@@ -27,6 +27,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/slab.h>
@@ -93,10 +95,10 @@ static inline int get_cur_bus_info(struct slot **sl)
 		slot_cur->bus_on->current_bus_mode = 0xFF;
 
 	debug("busstatus = %x, bus_speed = %x, bus_mode = %x\n",
-			slot_cur->busstatus,
-			slot_cur->bus_on->current_speed,
-			slot_cur->bus_on->current_bus_mode);
-	
+	      slot_cur->busstatus,
+	      slot_cur->bus_on->current_speed,
+	      slot_cur->bus_on->current_bus_mode);
+
 	*sl = slot_cur;
 	return 0;
 }
@@ -141,7 +143,7 @@ int ibmphp_init_devno(struct slot **cur_slot)
 
 	rtable = pcibios_get_irq_routing_table();
 	if (!rtable) {
-		err("no BIOS routing table...\n");
+		pr_err("no BIOS routing table...\n");
 		return -ENOMEM;
 	}
 
@@ -164,33 +166,33 @@ int ibmphp_init_devno(struct slot **cur_slot)
 						&irq_attr);
 
 			debug("(*cur_slot)->irq[0] = %x\n",
-					(*cur_slot)->irq[0]);
+			      (*cur_slot)->irq[0]);
 			debug("(*cur_slot)->irq[1] = %x\n",
-					(*cur_slot)->irq[1]);
+			      (*cur_slot)->irq[1]);
 			debug("(*cur_slot)->irq[2] = %x\n",
-					(*cur_slot)->irq[2]);
+			      (*cur_slot)->irq[2]);
 			debug("(*cur_slot)->irq[3] = %x\n",
-					(*cur_slot)->irq[3]);
+			      (*cur_slot)->irq[3]);
 
 			debug("rtable->exlusive_irqs = %x\n",
-					rtable->exclusive_irqs);
+			      rtable->exclusive_irqs);
 			debug("rtable->slots[loop].irq[0].bitmap = %x\n",
-					rtable->slots[loop].irq[0].bitmap);
+			      rtable->slots[loop].irq[0].bitmap);
 			debug("rtable->slots[loop].irq[1].bitmap = %x\n",
-					rtable->slots[loop].irq[1].bitmap);
+			      rtable->slots[loop].irq[1].bitmap);
 			debug("rtable->slots[loop].irq[2].bitmap = %x\n",
-					rtable->slots[loop].irq[2].bitmap);
+			      rtable->slots[loop].irq[2].bitmap);
 			debug("rtable->slots[loop].irq[3].bitmap = %x\n",
-					rtable->slots[loop].irq[3].bitmap);
+			      rtable->slots[loop].irq[3].bitmap);
 
 			debug("rtable->slots[loop].irq[0].link = %x\n",
-					rtable->slots[loop].irq[0].link);
+			      rtable->slots[loop].irq[0].link);
 			debug("rtable->slots[loop].irq[1].link = %x\n",
-					rtable->slots[loop].irq[1].link);
+			      rtable->slots[loop].irq[1].link);
 			debug("rtable->slots[loop].irq[2].link = %x\n",
-					rtable->slots[loop].irq[2].link);
+			      rtable->slots[loop].irq[2].link);
 			debug("rtable->slots[loop].irq[3].link = %x\n",
-					rtable->slots[loop].irq[3].link);
+			      rtable->slots[loop].irq[3].link);
 			debug("end of init_devno\n");
 			kfree(rtable);
 			return 0;
@@ -208,11 +210,11 @@ static inline int power_on(struct slot *slot_cur)
 
 	retval = ibmphp_hpc_writeslot(slot_cur, cmd);
 	if (retval) {
-		err("power on failed\n");
+		pr_err("power on failed\n");
 		return retval;
 	}
 	if (CTLR_RESULT(slot_cur->ctrl->status)) {
-		err("command not completed successfully in power_on\n");
+		pr_err("command not completed successfully in power_on\n");
 		return -EIO;
 	}
 	msleep(3000);	/* For ServeRAID cards, and some 66 PCI */
@@ -226,11 +228,11 @@ static inline int power_off(struct slot *slot_cur)
 
 	retval = ibmphp_hpc_writeslot(slot_cur, cmd);
 	if (retval) {
-		err("power off failed\n");
+		pr_err("power off failed\n");
 		return retval;
 	}
 	if (CTLR_RESULT(slot_cur->ctrl->status)) {
-		err("command not completed successfully in power_off\n");
+		pr_err("command not completed successfully in power_off\n");
 		retval = -EIO;
 	}
 	return retval;
@@ -243,7 +245,7 @@ static int set_attention_status(struct hotplug_slot *hotplug_slot, u8 value)
 	u8 cmd = 0x00;     /* avoid compiler warning */
 
 	debug("set_attention_status - Entry hotplug_slot[%lx] value[%x]\n",
-			(ulong) hotplug_slot, value);
+	      (ulong) hotplug_slot, value);
 	ibmphp_lock_operations();
 
 
@@ -260,8 +262,8 @@ static int set_attention_status(struct hotplug_slot *hotplug_slot, u8 value)
 			break;
 		default:
 			rc = -ENODEV;
-			err("set_attention_status - Error : invalid input [%x]\n",
-					value);
+			pr_err("set_attention_status - Error : invalid input [%x]\n",
+			       value);
 			break;
 		}
 		if (rc == 0) {
@@ -287,8 +289,8 @@ static int get_attention_status(struct hotplug_slot *hotplug_slot, u8 * value)
 	struct slot myslot;
 
 	debug("get_attention_status - Entry hotplug_slot[%lx] pvalue[%lx]\n",
-					(ulong) hotplug_slot, (ulong) value);
-        
+	      (ulong) hotplug_slot, (ulong) value);
+
 	ibmphp_lock_operations();
 	if (hotplug_slot) {
 		pslot = hotplug_slot->private;
@@ -318,7 +320,7 @@ static int get_latch_status(struct hotplug_slot *hotplug_slot, u8 * value)
 	struct slot myslot;
 
 	debug("get_latch_status - Entry hotplug_slot[%lx] pvalue[%lx]\n",
-					(ulong) hotplug_slot, (ulong) value);
+	      (ulong) hotplug_slot, (ulong) value);
 	ibmphp_lock_operations();
 	if (hotplug_slot) {
 		pslot = hotplug_slot->private;
@@ -333,7 +335,7 @@ static int get_latch_status(struct hotplug_slot *hotplug_slot, u8 * value)
 
 	ibmphp_unlock_operations();
 	debug("get_latch_status - Exit rc[%d] rc[%x] value[%x]\n",
-			rc, rc, *value);
+	      rc, rc, *value);
 	return rc;
 }
 
@@ -345,7 +347,7 @@ static int get_power_status(struct hotplug_slot *hotplug_slot, u8 * value)
 	struct slot myslot;
 
 	debug("get_power_status - Entry hotplug_slot[%lx] pvalue[%lx]\n",
-					(ulong) hotplug_slot, (ulong) value);
+	      (ulong) hotplug_slot, (ulong) value);
 	ibmphp_lock_operations();
 	if (hotplug_slot) {
 		pslot = hotplug_slot->private;
@@ -360,7 +362,7 @@ static int get_power_status(struct hotplug_slot *hotplug_slot, u8 * value)
 
 	ibmphp_unlock_operations();
 	debug("get_power_status - Exit rc[%d] rc[%x] value[%x]\n",
-			rc, rc, *value);
+	      rc, rc, *value);
 	return rc;
 }
 
@@ -372,7 +374,7 @@ static int get_adapter_present(struct hotplug_slot *hotplug_slot, u8 * value)
 	struct slot myslot;
 
 	debug("get_adapter_status - Entry hotplug_slot[%lx] pvalue[%lx]\n",
-					(ulong) hotplug_slot, (ulong) value);
+	      (ulong)hotplug_slot, (ulong)value);
 	ibmphp_lock_operations();
 	if (hotplug_slot) {
 		pslot = hotplug_slot->private;
@@ -402,7 +404,7 @@ static int get_max_bus_speed(struct slot *slot)
 	enum pci_bus_speed speed;
 	struct pci_bus *bus = slot->hotplug_slot->pci_slot->bus;
 
-	debug("%s - Entry slot[%p]\n", __func__, slot);
+	debug("%s: Entry slot[%p]\n", __func__, slot);
 
 	ibmphp_lock_operations();
 	mode = slot->supported_bus_mode;
@@ -428,7 +430,7 @@ static int get_max_bus_speed(struct slot *slot)
 	if (!rc)
 		bus->max_bus_speed = speed;
 
-	debug("%s - Exit rc[%d] speed[%x]\n", __func__, rc, speed);
+	debug("%s: Exit rc[%d] speed[%x]\n", __func__, rc, speed);
 	return rc;
 }
 
@@ -440,7 +442,7 @@ static int get_max_adapter_speed_1(struct hotplug_slot *hotplug_slot, u8 * value
 	struct slot myslot;
 
 	debug("get_max_adapter_speed_1 - Entry hotplug_slot[%lx] pvalue[%lx]\n",
-						(ulong)hotplug_slot, (ulong) value);
+	      (ulong)hotplug_slot, (ulong) value);
 
 	if (flag)
 		ibmphp_lock_operations();
@@ -514,7 +516,7 @@ static int __init init_ops(void)
 			return -ENODEV;
 
 		debug("BEFORE GETTING SLOT STATUS, slot # %x\n",
-							slot_cur->number);
+		      slot_cur->number);
 		if (slot_cur->ctrl->revision == 0xFF) 
 			if (get_ctrl_revision(slot_cur,
 						&slot_cur->ctrl->revision))
@@ -543,9 +545,9 @@ static int __init init_ops(void)
 		    !(SLOT_PRESENT(slot_cur->status)) && 
 		    !(SLOT_LATCH(slot_cur->status))) {
 			debug("BEFORE POWER OFF COMMAND\n");
-				rc = power_off(slot_cur);
-				if (rc)
-					return rc;
+			rc = power_off(slot_cur);
+			if (rc)
+				return rc;
 
 	/*		retval = slot_update(&slot_cur);
 	 *		if (retval)
@@ -595,7 +597,7 @@ static int validate(struct slot *slot_cur, int opn)
 		default:
 			break;
 	}
-	err("validate failed....\n");
+	pr_err("validate failed...\n");
 	return -EINVAL;
 }
 
@@ -614,7 +616,7 @@ int ibmphp_update_slot_info(struct slot *slot_cur)
 
 	info = kmalloc(sizeof(struct hotplug_slot_info), GFP_KERNEL);
 	if (!info) {
-		err("out of system memory\n");
+		pr_err("out of system memory\n");
 		return -ENOMEM;
 	}
         
@@ -715,7 +717,7 @@ static void ibm_unconfigure_device(struct pci_func *func)
 
 	debug("inside %s\n", __func__);
 	debug("func->device = %x, func->function = %x\n",
-					func->device, func->function);
+	      func->device, func->function);
 	debug("func->device << 3 | 0x0  = %x\n", func->device << 3 | 0x0);
 
 	for (j = 0; j < 0x08; j++) {
@@ -744,13 +746,13 @@ static u8 bus_structure_fixup(u8 busno)
 
 	bus = kmalloc(sizeof(*bus), GFP_KERNEL);
 	if (!bus) {
-		err("%s - out of memory\n", __func__);
+		pr_err("%s: out of memory\n", __func__);
 		return 1;
 	}
 	dev = kmalloc(sizeof(*dev), GFP_KERNEL);
 	if (!dev) {
 		kfree(bus);
-		err("%s - out of memory\n", __func__);
+		pr_err("%s: out of memory\n", __func__);
 		return 1;
 	}
 
@@ -760,8 +762,7 @@ static u8 bus_structure_fixup(u8 busno)
 	for (dev->devfn = 0; dev->devfn < 256; dev->devfn += 8) {
 		if (!pci_read_config_word(dev, PCI_VENDOR_ID, &l) &&
 					(l != 0x0000) && (l != 0xffff)) {
-			debug("%s - Inside bus_struture_fixup()\n",
-							__func__);
+			debug("%s: Inside bus_struture_fixup()\n", __func__);
 			pci_scan_bus(busno, ibmphp_pci_bus->ops, NULL);
 			break;
 		}
@@ -800,7 +801,7 @@ static int ibm_configure_device(struct pci_func *func)
 		func->dev = pci_get_bus_and_slot(func->busno,
 				PCI_DEVFN(func->device, func->function));
 		if (func->dev == NULL) {
-			err("ERROR... : pci_dev still NULL\n");
+			pr_err("ERROR... : pci_dev still NULL\n");
 			return 0;
 		}
 	}
@@ -858,13 +859,14 @@ static int set_bus(struct slot * slot_cur)
 	        { },
 	};	
 
-	debug("%s - entry slot # %d\n", __func__, slot_cur->number);
+	debug("%s: entry slot # %d\n", __func__, slot_cur->number);
 	if (SET_BUS_STATUS(slot_cur->ctrl) && is_bus_empty(slot_cur)) {
 		rc = slot_update(&slot_cur);
 		if (rc)
 			return rc;
 		speed = SLOT_SPEED(slot_cur->ext_status);
-		debug("ext_status = %x, speed = %x\n", slot_cur->ext_status, speed);
+		debug("ext_status = %x, speed = %x\n",
+		      slot_cur->ext_status, speed);
 		switch (speed) {
 		case HPC_SLOT_SPEED_33:
 			cmd = HPC_BUS_33CONVMODE;
@@ -910,23 +912,23 @@ static int set_bus(struct slot * slot_cur)
 				cmd = HPC_BUS_133PCIXMODE;
 				break;
 			default:
-				err("Wrong bus speed\n");
+				pr_err("Wrong bus speed\n");
 				return -ENODEV;
 			}
 			break;
 		default:
-			err("wrong slot speed\n");
+			pr_err("wrong slot speed\n");
 			return -ENODEV;
 		}
 		debug("setting bus speed for slot %d, cmd %x\n",
-						slot_cur->number, cmd);
+		      slot_cur->number, cmd);
 		retval = ibmphp_hpc_writeslot(slot_cur, cmd);
 		if (retval) {
-			err("setting bus speed failed\n");
+			pr_err("setting bus speed failed\n");
 			return retval;
 		}
 		if (CTLR_RESULT(slot_cur->ctrl->status)) {
-			err("command not completed successfully in set_bus\n");
+			pr_err("command not completed successfully in set_bus\n");
 			return -EIO;
 		}
 	}
@@ -985,15 +987,15 @@ static int check_limitations(struct slot *slot_cur)
 
 static inline void print_card_capability(struct slot *slot_cur)
 {
-	info("capability of the card is ");
+	pr_info("capability of the card is ");
 	if ((slot_cur->ext_status & CARD_INFO) == PCIX133) 
-		info("   133 MHz PCI-X\n");
+		pr_cont("   133 MHz PCI-X\n");
 	else if ((slot_cur->ext_status & CARD_INFO) == PCIX66)
-		info("    66 MHz PCI-X\n");
+		pr_cont("    66 MHz PCI-X\n");
 	else if ((slot_cur->ext_status & CARD_INFO) == PCI66)
-		info("    66 MHz PCI\n");
+		pr_cont("    66 MHz PCI\n");
 	else
-		info("    33 MHz PCI\n");
+		pr_cont("    33 MHz PCI\n");
 
 }
 
@@ -1011,11 +1013,11 @@ static int enable_slot(struct hotplug_slot *hs)
 
 	ibmphp_lock_operations();
 
-	debug("ENABLING SLOT........\n");
+	debug("ENABLING SLOT...\n");
 	slot_cur = hs->private;
 
 	if ((rc = validate(slot_cur, ENABLE))) {
-		err("validate function failed\n");
+		pr_err("validate function failed\n");
 		goto error_nopower;
 	}
 
@@ -1023,22 +1025,22 @@ static int enable_slot(struct hotplug_slot *hs)
 	
 	rc = set_bus(slot_cur);
 	if (rc) {
-		err("was not able to set the bus\n");
+		pr_err("was not able to set the bus\n");
 		goto error_nopower;
 	}
 
 	/*-----------------debugging------------------------------*/
 	get_cur_bus_info(&slot_cur);
 	debug("the current bus speed right after set_bus = %x\n",
-					slot_cur->bus_on->current_speed);
+	      slot_cur->bus_on->current_speed);
 	/*----------------------------------------------------------*/
 
 	rc = check_limitations(slot_cur);
 	if (rc) {
-		err("Adding this card exceeds the limitations of this bus.\n");
-		err("(i.e., >1 133MHz cards running on same bus, or "
-		     ">2 66 PCI cards running on same bus.\n");
-		err("Try hot-adding into another bus\n");
+		pr_err("Adding this card exceeds the limitations of this bus\n");
+		pr_err("(i.e., >1 133MHz cards running on same bus, or "
+		       ">2 66 PCI cards running on same bus.\n");
+		pr_err("Try hot-adding into another bus\n");
 		rc = -EINVAL;
 		goto error_nopower;
 	}
@@ -1046,7 +1048,7 @@ static int enable_slot(struct hotplug_slot *hs)
 	rc = power_on(slot_cur);
 
 	if (rc) {
-		err("something wrong when powering up... please see below for details\n");
+		pr_err("something wrong when powering up... please see below for details\n");
 		/* need to turn off before on, otherwise, blinking overwrites */
 		attn_off(slot_cur);
 		attn_on(slot_cur);
@@ -1059,14 +1061,14 @@ static int enable_slot(struct hotplug_slot *hs)
 		/* Check to see the error of why it failed */
 		if ((SLOT_POWER(slot_cur->status)) &&
 					!(SLOT_PWRGD(slot_cur->status)))
-			err("power fault occurred trying to power up\n");
+			pr_err("power fault occurred trying to power up\n");
 		else if (SLOT_BUS_SPEED(slot_cur->status)) {
-			err("bus speed mismatch occurred.  please check "
-				"current bus speed and card capability\n");
+			pr_err("bus speed mismatch occurred.  "
+			       "please check current bus speed and card capability\n");
 			print_card_capability(slot_cur);
 		} else if (SLOT_BUS_MODE(slot_cur->ext_status)) {
-			err("bus mode mismatch occurred.  please check "
-				"current bus mode and card capability\n");
+			pr_err("bus mode mismatch occurred.  "
+			       "please check current bus mode and card capability\n");
 			print_card_capability(slot_cur);
 		}
 		ibmphp_update_slot_info(slot_cur);
@@ -1076,7 +1078,7 @@ static int enable_slot(struct hotplug_slot *hs)
 	/*-----------------------debugging---------------------------*/
 	get_cur_bus_info(&slot_cur);
 	debug("the current bus speed right after power_on = %x\n",
-					slot_cur->bus_on->current_speed);
+	      slot_cur->bus_on->current_speed);
 	/*----------------------------------------------------------*/
 
 	rc = slot_update(&slot_cur);
@@ -1085,19 +1087,19 @@ static int enable_slot(struct hotplug_slot *hs)
 	
 	rc = -EINVAL;
 	if (SLOT_POWER(slot_cur->status) && !(SLOT_PWRGD(slot_cur->status))) {
-		err("power fault occurred trying to power up...\n");
+		pr_err("power fault occurred trying to power up...\n");
 		goto error_power;
 	}
 	if (SLOT_POWER(slot_cur->status) && (SLOT_BUS_SPEED(slot_cur->status))) {
-		err("bus speed mismatch occurred.  please check current bus "
-					"speed and card capability\n");
+		pr_err("bus speed mismatch occurred.  "
+		       "please check current bus speed and card capability\n");
 		print_card_capability(slot_cur);
 		goto error_power;
 	} 
 	/* Don't think this case will happen after above checks...
 	 * but just in case, for paranoia sake */
 	if (!(SLOT_POWER(slot_cur->status))) {
-		err("power on failed...\n");
+		pr_err("power on failed...\n");
 		goto error_power;
 	}
 
@@ -1105,7 +1107,7 @@ static int enable_slot(struct hotplug_slot *hs)
 	if (!slot_cur->func) {
 		/* We cannot do update_slot_info here, since no memory for
 		 * kmalloc n.e.ways, and update_slot_info allocates some */
-		err("out of system memory\n");
+		pr_err("out of system memory\n");
 		rc = -ENOMEM;
 		goto error_power;
 	}
@@ -1115,10 +1117,10 @@ static int enable_slot(struct hotplug_slot *hs)
 		slot_cur->func->irq[i] = slot_cur->irq[i];
 
 	debug("b4 configure_card, slot_cur->bus = %x, slot_cur->device = %x\n",
-					slot_cur->bus, slot_cur->device);
+	      slot_cur->bus, slot_cur->device);
 
 	if (ibmphp_configure_card(slot_cur->func, slot_cur->number)) {
-		err("configure_card was unsuccessful...\n");
+		pr_err("configure_card was unsuccessful...\n");
 		/* true because don't need to actually deallocate resources,
 		 * just remove references */
 		ibmphp_unconfigure_card(&slot_cur, 1);
@@ -1213,7 +1215,7 @@ int ibmphp_do_disable_slot(struct slot *slot_cur)
 		/* We need this for fncs's that were there on bootup */
 		slot_cur->func = kzalloc(sizeof(struct pci_func), GFP_KERNEL);
 		if (!slot_cur->func) {
-			err("out of system memory\n");
+			pr_err("out of system memory\n");
 			rc = -ENOMEM;
 			goto error;
 		}
@@ -1238,7 +1240,7 @@ int ibmphp_do_disable_slot(struct slot *slot_cur)
 	slot_cur->func = NULL;
 	debug("in disable_slot. after unconfigure_card\n");
 	if (rc) {
-		err("could not unconfigure card.\n");
+		pr_err("could not unconfigure card\n");
 		goto error;
 	}
 
@@ -1306,18 +1308,18 @@ static int __init ibmphp_init(void)
 
 	init_flag = 1;
 
-	info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
+	pr_info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
 
 	ibmphp_pci_bus = kmalloc(sizeof(*ibmphp_pci_bus), GFP_KERNEL);
 	if (!ibmphp_pci_bus) {
-		err("out of memory\n");
+		pr_err("out of memory\n");
 		rc = -ENOMEM;
 		goto exit;
 	}
 
 	bus = pci_find_bus(0, 0);
 	if (!bus) {
-		err("Can't find the root pci bus, can not continue\n");
+		pr_err("Can't find the root pci bus, can not continue\n");
 		rc = -ENODEV;
 		goto error;
 	}
diff --git a/drivers/pci/hotplug/ibmphp_ebda.c b/drivers/pci/hotplug/ibmphp_ebda.c
index 2850e64..edbf9fa 100644
--- a/drivers/pci/hotplug/ibmphp_ebda.c
+++ b/drivers/pci/hotplug/ibmphp_ebda.c
@@ -27,6 +27,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/errno.h>
 #include <linux/mm.h>
@@ -125,18 +127,23 @@ static void __init print_bus_info (void)
 	struct bus_info *ptr;
 	
 	list_for_each_entry(ptr, &bus_info_head, bus_info_list) {
-		debug ("%s - slot_min = %x\n", __func__, ptr->slot_min);
-		debug ("%s - slot_max = %x\n", __func__, ptr->slot_max);
-		debug ("%s - slot_count = %x\n", __func__, ptr->slot_count);
-		debug ("%s - bus# = %x\n", __func__, ptr->busno);
-		debug ("%s - current_speed = %x\n", __func__, ptr->current_speed);
-		debug ("%s - controller_id = %x\n", __func__, ptr->controller_id);
-		
-		debug ("%s - slots_at_33_conv = %x\n", __func__, ptr->slots_at_33_conv);
-		debug ("%s - slots_at_66_conv = %x\n", __func__, ptr->slots_at_66_conv);
-		debug ("%s - slots_at_66_pcix = %x\n", __func__, ptr->slots_at_66_pcix);
-		debug ("%s - slots_at_100_pcix = %x\n", __func__, ptr->slots_at_100_pcix);
-		debug ("%s - slots_at_133_pcix = %x\n", __func__, ptr->slots_at_133_pcix);
+		debug("%s: slot_min = %x\n", __func__, ptr->slot_min);
+		debug("%s: slot_max = %x\n", __func__, ptr->slot_max);
+		debug("%s: slot_count = %x\n", __func__, ptr->slot_count);
+		debug("%s: bus# = %x\n", __func__, ptr->busno);
+		debug("%s: current_speed = %x\n", __func__, ptr->current_speed);
+		debug("%s: controller_id = %x\n", __func__, ptr->controller_id);
+
+		debug("%s: slots_at_33_conv = %x\n",
+		      __func__, ptr->slots_at_33_conv);
+		debug("%s: slots_at_66_conv = %x\n",
+		      __func__, ptr->slots_at_66_conv);
+		debug("%s: slots_at_66_pcix = %x\n",
+		      __func__, ptr->slots_at_66_pcix);
+		debug("%s: slots_at_100_pcix = %x\n",
+		      __func__, ptr->slots_at_100_pcix);
+		debug("%s: slots_at_133_pcix = %x\n",
+		      __func__, ptr->slots_at_133_pcix);
 
 	}
 }
@@ -144,14 +151,15 @@ static void __init print_bus_info (void)
 static void print_lo_info (void)
 {
 	struct rio_detail *ptr;
-	debug ("print_lo_info ----\n");	
+	debug("print_lo_info ----\n");
 	list_for_each_entry(ptr, &rio_lo_head, rio_detail_list) {
-		debug ("%s - rio_node_id = %x\n", __func__, ptr->rio_node_id);
-		debug ("%s - rio_type = %x\n", __func__, ptr->rio_type);
-		debug ("%s - owner_id = %x\n", __func__, ptr->owner_id);
-		debug ("%s - first_slot_num = %x\n", __func__, ptr->first_slot_num);
-		debug ("%s - wpindex = %x\n", __func__, ptr->wpindex);
-		debug ("%s - chassis_num = %x\n", __func__, ptr->chassis_num);
+		debug("%s: rio_node_id = %x\n", __func__, ptr->rio_node_id);
+		debug("%s: rio_type = %x\n", __func__, ptr->rio_type);
+		debug("%s: owner_id = %x\n", __func__, ptr->owner_id);
+		debug("%s: first_slot_num = %x\n",
+		      __func__, ptr->first_slot_num);
+		debug("%s: wpindex = %x\n", __func__, ptr->wpindex);
+		debug("%s: chassis_num = %x\n", __func__, ptr->chassis_num);
 
 	}
 }
@@ -159,14 +167,15 @@ static void print_lo_info (void)
 static void print_vg_info (void)
 {
 	struct rio_detail *ptr;
-	debug ("%s ---\n", __func__);
+	debug("%s ---\n", __func__);
 	list_for_each_entry(ptr, &rio_vg_head, rio_detail_list) {
-		debug ("%s - rio_node_id = %x\n", __func__, ptr->rio_node_id);
-		debug ("%s - rio_type = %x\n", __func__, ptr->rio_type);
-		debug ("%s - owner_id = %x\n", __func__, ptr->owner_id);
-		debug ("%s - first_slot_num = %x\n", __func__, ptr->first_slot_num);
-		debug ("%s - wpindex = %x\n", __func__, ptr->wpindex);
-		debug ("%s - chassis_num = %x\n", __func__, ptr->chassis_num);
+		debug("%s: rio_node_id = %x\n", __func__, ptr->rio_node_id);
+		debug("%s: rio_type = %x\n", __func__, ptr->rio_type);
+		debug("%s: owner_id = %x\n", __func__, ptr->owner_id);
+		debug("%s: first_slot_num = %x\n",
+		      __func__, ptr->first_slot_num);
+		debug("%s: wpindex = %x\n", __func__, ptr->wpindex);
+		debug("%s: chassis_num = %x\n", __func__, ptr->chassis_num);
 
 	}
 }
@@ -176,8 +185,9 @@ static void __init print_ebda_pci_rsrc (void)
 	struct ebda_pci_rsrc *ptr;
 
 	list_for_each_entry(ptr, &ibmphp_ebda_pci_rsrc_head, ebda_pci_rsrc_list) {
-		debug ("%s - rsrc type: %x bus#: %x dev_func: %x start addr: %x end addr: %x\n", 
-			__func__, ptr->rsrc_type ,ptr->bus_num, ptr->dev_fun,ptr->start_addr, ptr->end_addr);
+		debug("%s: rsrc type: %x bus#: %x dev_func: %x start addr: %x end addr: %x\n",
+		      __func__, ptr->rsrc_type, ptr->bus_num, ptr->dev_fun,
+		      ptr->start_addr, ptr->end_addr);
 	}
 }
 
@@ -186,19 +196,19 @@ static void __init print_ibm_slot (void)
 	struct slot *ptr;
 
 	list_for_each_entry(ptr, &ibmphp_slot_head, ibm_slot_list) {
-		debug ("%s - slot_number: %x\n", __func__, ptr->number);
+		debug("%s: slot_number: %x\n", __func__, ptr->number);
 	}
 }
 
 static void __init print_opt_vg (void)
 {
 	struct opt_rio *ptr;
-	debug ("%s ---\n", __func__);
+	debug("%s ---\n", __func__);
 	list_for_each_entry(ptr, &opt_vg_head, opt_rio_list) {
-		debug ("%s - rio_type %x\n", __func__, ptr->rio_type);
-		debug ("%s - chassis_num: %x\n", __func__, ptr->chassis_num);
-		debug ("%s - first_slot_num: %x\n", __func__, ptr->first_slot_num);
-		debug ("%s - middle_num: %x\n", __func__, ptr->middle_num);
+		debug("%s: rio_type %x\n", __func__, ptr->rio_type);
+		debug("%s: chassis_num: %x\n", __func__, ptr->chassis_num);
+		debug("%s: first_slot_num: %x\n", __func__, ptr->first_slot_num);
+		debug("%s: middle_num: %x\n", __func__, ptr->middle_num);
 	}
 }
 
@@ -209,35 +219,46 @@ static void __init print_ebda_hpc (void)
 
 	list_for_each_entry(hpc_ptr, &ebda_hpc_head, ebda_hpc_list) {
 		for (index = 0; index < hpc_ptr->slot_count; index++) {
-			debug ("%s - physical slot#: %x\n", __func__, hpc_ptr->slots[index].slot_num);
-			debug ("%s - pci bus# of the slot: %x\n", __func__, hpc_ptr->slots[index].slot_bus_num);
-			debug ("%s - index into ctlr addr: %x\n", __func__, hpc_ptr->slots[index].ctl_index);
-			debug ("%s - cap of the slot: %x\n", __func__, hpc_ptr->slots[index].slot_cap);
+			debug("%s: physical slot#: %x\n",
+			      __func__, hpc_ptr->slots[index].slot_num);
+			debug("%s: pci bus# of the slot: %x\n",
+			      __func__, hpc_ptr->slots[index].slot_bus_num);
+			debug("%s: index into ctlr addr: %x\n",
+			      __func__, hpc_ptr->slots[index].ctl_index);
+			debug("%s: cap of the slot: %x\n",
+			      __func__, hpc_ptr->slots[index].slot_cap);
 		}
 
 		for (index = 0; index < hpc_ptr->bus_count; index++) {
-			debug ("%s - bus# of each bus controlled by this ctlr: %x\n", __func__, hpc_ptr->buses[index].bus_num);
+			debug("%s: bus# of each bus controlled by this ctlr: %x\n",
+			      __func__, hpc_ptr->buses[index].bus_num);
 		}
 
-		debug ("%s - type of hpc: %x\n", __func__, hpc_ptr->ctlr_type);
+		debug("%s: type of hpc: %x\n", __func__, hpc_ptr->ctlr_type);
 		switch (hpc_ptr->ctlr_type) {
 		case 1:
-			debug ("%s - bus: %x\n", __func__, hpc_ptr->u.pci_ctlr.bus);
-			debug ("%s - dev_fun: %x\n", __func__, hpc_ptr->u.pci_ctlr.dev_fun);
-			debug ("%s - irq: %x\n", __func__, hpc_ptr->irq);
+			debug("%s: bus: %x\n",
+			      __func__, hpc_ptr->u.pci_ctlr.bus);
+			debug("%s: dev_fun: %x\n",
+			      __func__, hpc_ptr->u.pci_ctlr.dev_fun);
+			debug("%s: irq: %x\n", __func__, hpc_ptr->irq);
 			break;
 
 		case 0:
-			debug ("%s - io_start: %x\n", __func__, hpc_ptr->u.isa_ctlr.io_start);
-			debug ("%s - io_end: %x\n", __func__, hpc_ptr->u.isa_ctlr.io_end);
-			debug ("%s - irq: %x\n", __func__, hpc_ptr->irq);
+			debug("%s: io_start: %x\n",
+			      __func__, hpc_ptr->u.isa_ctlr.io_start);
+			debug("%s: io_end: %x\n",
+			      __func__, hpc_ptr->u.isa_ctlr.io_end);
+			debug("%s: irq: %x\n", __func__, hpc_ptr->irq);
 			break;
 
 		case 2:
 		case 4:
-			debug ("%s - wpegbbar: %lx\n", __func__, hpc_ptr->u.wpeg_ctlr.wpegbbar);
-			debug ("%s - i2c_addr: %x\n", __func__, hpc_ptr->u.wpeg_ctlr.i2c_addr);
-			debug ("%s - irq: %x\n", __func__, hpc_ptr->irq);
+			debug("%s: wpegbbar: %lx\n",
+			      __func__, hpc_ptr->u.wpeg_ctlr.wpegbbar);
+			debug("%s: i2c_addr: %x\n",
+			      __func__, hpc_ptr->u.wpeg_ctlr.i2c_addr);
+			debug("%s: irq: %x\n", __func__, hpc_ptr->irq);
 			break;
 		}
 	}
@@ -258,7 +279,7 @@ int __init ibmphp_access_ebda (void)
 		return -ENOMEM;
 	ebda_seg = readw (io_mem);
 	iounmap (io_mem);
-	debug ("returned ebda segment: %x\n", ebda_seg);
+	debug("returned ebda segment: %x\n", ebda_seg);
 	
 	io_mem = ioremap(ebda_seg<<4, 1);
 	if (!io_mem)
@@ -295,14 +316,14 @@ int __init ibmphp_access_ebda (void)
 			continue;
 		/* found hs table */
 		if (blk_id == 0x4853) {
-			debug ("now enter hot swap block---\n");
-			debug ("hot blk id: %x\n", blk_id);
+			debug("now enter hot swap block---\n");
+			debug("hot blk id: %x\n", blk_id);
 			format = readb (io_mem + offset);
 
 			offset += 1;
 			if (format != 4)
 				goto error_nodev;
-			debug ("hot blk format: %x\n", format);
+			debug("hot blk format: %x\n", format);
 			/* hot swap sub blk */
 			base = offset;
 
@@ -327,10 +348,11 @@ int __init ibmphp_access_ebda (void)
 			hpc_list_ptr->format = format;
 			hpc_list_ptr->num_ctlrs = num_ctlrs;
 			hpc_list_ptr->phys_addr = sub_addr;	/*  offset of RSRC_CONTROLLER blk */
-			debug ("info about hpc descriptor---\n");
-			debug ("hot blk format: %x\n", format);
-			debug ("num of controller: %x\n", num_ctlrs);
-			debug ("offset of hpc data structure enteries: %x\n ", sub_addr);
+			debug("info about hpc descriptor---\n");
+			debug("hot blk format: %x\n", format);
+			debug("num of controller: %x\n", num_ctlrs);
+			debug("offset of hpc data structure entries: %x\n ",
+			      sub_addr);
 
 			sub_addr = base + re;	/* re sub blk */
 			/* FIXME: rc is never used/checked */
@@ -356,16 +378,17 @@ int __init ibmphp_access_ebda (void)
 			rsrc_list_ptr->num_entries = num_entries;
 			rsrc_list_ptr->phys_addr = sub_addr;
 
-			debug ("info about rsrc descriptor---\n");
-			debug ("format: %x\n", format);
-			debug ("num of rsrc: %x\n", num_entries);
-			debug ("offset of rsrc data structure enteries: %x\n ", sub_addr);
+			debug("info about rsrc descriptor---\n");
+			debug("format: %x\n", format);
+			debug("num of rsrc: %x\n", num_entries);
+			debug("offset of rsrc data structure enteries: %x\n",
+			      sub_addr);
 
 			hs_complete = 1;
 		} else {
 		/* found rio table, blk_id == 0x4752 */
-			debug ("now enter io table ---\n");
-			debug ("rio blk id: %x\n", blk_id);
+			debug("now enter io table ---\n");
+			debug("rio blk id: %x\n", blk_id);
 
 			rio_table_ptr = kzalloc(sizeof(struct rio_table_hdr), GFP_KERNEL);
 			if (!rio_table_ptr)
@@ -376,9 +399,12 @@ int __init ibmphp_access_ebda (void)
 			rio_table_ptr->offset = offset +3 ;
 			
 			debug("info about rio table hdr ---\n");
-			debug("ver_num: %x\nscal_count: %x\nriodev_count: %x\noffset of rio table: %x\n ",
-				rio_table_ptr->ver_num, rio_table_ptr->scal_count,
-				rio_table_ptr->riodev_count, rio_table_ptr->offset);
+			debug("ver_num: %x\n"
+			      "scal_count: %x\n"
+			      "riodev_count: %x\n"
+			      "offset of rio table: %x\n",
+			      rio_table_ptr->ver_num, rio_table_ptr->scal_count,
+			      rio_table_ptr->riodev_count, rio_table_ptr->offset);
 
 			rio_complete = 1;
 		}
@@ -436,7 +462,25 @@ static int __init ebda_rio_table (void)
 		rio_detail_ptr->status = readb (io_mem + offset + 12);
 		rio_detail_ptr->wpindex = readb (io_mem + offset + 13);
 		rio_detail_ptr->chassis_num = readb (io_mem + offset + 14);
-//		debug ("rio_node_id: %x\nbbar: %x\nrio_type: %x\nowner_id: %x\nport0_node: %x\nport0_port: %x\nport1_node: %x\nport1_port: %x\nfirst_slot_num: %x\nstatus: %x\n", rio_detail_ptr->rio_node_id, rio_detail_ptr->bbar, rio_detail_ptr->rio_type, rio_detail_ptr->owner_id, rio_detail_ptr->port0_node_connect, rio_detail_ptr->port0_port_connect, rio_detail_ptr->port1_node_connect, rio_detail_ptr->port1_port_connect, rio_detail_ptr->first_slot_num, rio_detail_ptr->status);
+/*
+		debug("rio_node_id: %x\n"
+		      "bbar: %x\n"
+		      "rio_type: %x\n"
+		      "owner_id: %x\n"
+		      "port0_node: %x\n"
+		      "port0_port: %x\n"
+		      "port1_node: %x\n"
+		      "port1_port: %x\n"
+		      "first_slot_num: %x\n"
+		      "status: %x\n",
+		      rio_detail_ptr->rio_node_id, rio_detail_ptr->bbar,
+		      rio_detail_ptr->rio_type, rio_detail_ptr->owner_id,
+		      rio_detail_ptr->port0_node_connect,
+		      rio_detail_ptr->port0_port_connect,
+		      rio_detail_ptr->port1_node_connect,
+		      rio_detail_ptr->port1_port_connect,
+		      rio_detail_ptr->first_slot_num, rio_detail_ptr->status);
+*/
 		//create linked list of chassis
 		if (rio_detail_ptr->rio_type == 4 || rio_detail_ptr->rio_type == 5) 
 			list_add (&rio_detail_ptr->rio_detail_list, &rio_vg_head);
@@ -617,7 +661,7 @@ static char *create_file_name (struct slot * slot_cur)
 	u8 flag = 0;
 
 	if (!slot_cur) {
-		err ("Structure passed is empty\n");
+		pr_err("Structure passed is empty\n");
 		return NULL;
 	}
 	
@@ -782,11 +826,11 @@ static int __init ebda_rsrc_controller (void)
 		hpc_ptr->ctlr_relative_id = ctlr;
 		hpc_ptr->slot_count = slot_num;
 		hpc_ptr->bus_count = bus_num;
-		debug ("now enter ctlr data struture ---\n");
-		debug ("ctlr id: %x\n", ctlr_id);
-		debug ("ctlr_relative_id: %x\n", hpc_ptr->ctlr_relative_id);
-		debug ("count of slots controlled by this ctlr: %x\n", slot_num);
-		debug ("count of buses controlled by this ctlr: %x\n", bus_num);
+		debug("now enter ctlr data struture ---\n");
+		debug("ctlr id: %x\n", ctlr_id);
+		debug("ctlr_relative_id: %x\n", hpc_ptr->ctlr_relative_id);
+		debug("count of slots controlled by this ctlr: %x\n", slot_num);
+		debug("count of buses controlled by this ctlr: %x\n", bus_num);
 
 		/* init slot structure, fetch slot, bus, cap... */
 		slot_ptr = hpc_ptr->slots;
@@ -862,9 +906,10 @@ static int __init ebda_rsrc_controller (void)
 				hpc_ptr->u.pci_ctlr.dev_fun = readb (io_mem + addr + 1);
 				hpc_ptr->irq = readb (io_mem + addr + 2);
 				addr += 3;
-				debug ("ctrl bus = %x, ctlr devfun = %x, irq = %x\n", 
-					hpc_ptr->u.pci_ctlr.bus,
-					hpc_ptr->u.pci_ctlr.dev_fun, hpc_ptr->irq);
+				debug("ctrl bus = %x, ctlr devfun = %x, irq = %x\n",
+				      hpc_ptr->u.pci_ctlr.bus,
+				      hpc_ptr->u.pci_ctlr.dev_fun,
+				      hpc_ptr->irq);
 				break;
 
 			case 0:
@@ -1010,8 +1055,8 @@ static int __init ebda_rsrc_rsrc (void)
 	struct ebda_pci_rsrc *rsrc_ptr;
 
 	addr = rsrc_list_ptr->phys_addr;
-	debug ("now entering rsrc land\n");
-	debug ("offset of rsrc: %x\n", rsrc_list_ptr->phys_addr);
+	debug("now entering rsrc land\n");
+	debug("offset of rsrc: %x\n", rsrc_list_ptr->phys_addr);
 
 	for (rsrc = 0; rsrc < rsrc_list_ptr->num_entries; rsrc++) {
 		type = readb (io_mem + addr);
@@ -1033,9 +1078,11 @@ static int __init ebda_rsrc_rsrc (void)
 			rsrc_ptr->end_addr = readw (io_mem + addr + 4);
 			addr += 6;
 
-			debug ("rsrc from io type ----\n");
-			debug ("rsrc type: %x bus#: %x dev_func: %x start addr: %x end addr: %x\n",
-				rsrc_ptr->rsrc_type, rsrc_ptr->bus_num, rsrc_ptr->dev_fun, rsrc_ptr->start_addr, rsrc_ptr->end_addr);
+			debug("rsrc from io type ----\n");
+			debug("rsrc type: %x bus#: %x dev_func: %x start addr: %x end addr: %x\n",
+			      rsrc_ptr->rsrc_type, rsrc_ptr->bus_num,
+			      rsrc_ptr->dev_fun, rsrc_ptr->start_addr,
+			      rsrc_ptr->end_addr);
 
 			list_add (&rsrc_ptr->ebda_pci_rsrc_list, &ibmphp_ebda_pci_rsrc_head);
 		}
@@ -1054,9 +1101,11 @@ static int __init ebda_rsrc_rsrc (void)
 			rsrc_ptr->end_addr = readl (io_mem + addr + 6);
 			addr += 10;
 
-			debug ("rsrc from mem or pfm ---\n");
-			debug ("rsrc type: %x bus#: %x dev_func: %x start addr: %x end addr: %x\n", 
-				rsrc_ptr->rsrc_type, rsrc_ptr->bus_num, rsrc_ptr->dev_fun, rsrc_ptr->start_addr, rsrc_ptr->end_addr);
+			debug("rsrc from mem or pfm ---\n");
+			debug("rsrc type: %x bus#: %x dev_func: %x start addr: %x end addr: %x\n",
+			      rsrc_ptr->rsrc_type, rsrc_ptr->bus_num,
+			      rsrc_ptr->dev_fun, rsrc_ptr->start_addr,
+			      rsrc_ptr->end_addr);
 
 			list_add (&rsrc_ptr->ebda_pci_rsrc_list, &ibmphp_ebda_pci_rsrc_head);
 		}
@@ -1194,14 +1243,15 @@ static int ibmphp_probe (struct pci_dev * dev, const struct pci_device_id *ids)
 {
 	struct controller *ctrl;
 
-	debug ("inside ibmphp_probe\n");
+	debug("inside ibmphp_probe\n");
 	
 	list_for_each_entry(ctrl, &ebda_hpc_head, ebda_hpc_list) {
 		if (ctrl->ctlr_type == 1) {
 			if ((dev->devfn == ctrl->u.pci_ctlr.dev_fun) && (dev->bus->number == ctrl->u.pci_ctlr.bus)) {
 				ctrl->ctrl_dev = dev;
-				debug ("found device!!!\n");
-				debug ("dev->device = %x, dev->subsystem_device = %x\n", dev->device, dev->subsystem_device);
+				debug("found device!!!\n");
+				debug("dev->device = %x, dev->subsystem_device = %x\n",
+				      dev->device, dev->subsystem_device);
 				return 0;
 			}
 		}
diff --git a/drivers/pci/hotplug/ibmphp_hpc.c b/drivers/pci/hotplug/ibmphp_hpc.c
index f59ed30..d291703 100644
--- a/drivers/pci/hotplug/ibmphp_hpc.c
+++ b/drivers/pci/hotplug/ibmphp_hpc.c
@@ -27,6 +27,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/wait.h>
 #include <linux/time.h>
 #include <linux/delay.h>
@@ -40,7 +42,8 @@
 #include "ibmphp.h"
 
 static int to_debug = 0;
-#define debug_polling(fmt, arg...)	do { if (to_debug) debug (fmt, arg); } while (0)
+#define debug_polling(fmt, arg...)			\
+	do { if (to_debug) debug(fmt, arg); } while (0)
 
 //----------------------------------------------------------------------------
 // timeout values
@@ -130,14 +133,14 @@ static int hpc_wait_ctlr_notworking (int, struct controller *, void __iomem *, u
 *---------------------------------------------------------------------*/
 void __init ibmphp_hpc_initvars (void)
 {
-	debug ("%s - Entry\n", __func__);
+	debug("%s: Entry\n", __func__);
 
 	mutex_init(&sem_hpcaccess);
 	sema_init(&semOperations, 1);
 	sema_init(&sem_exit, 0);
 	to_debug = 0;
 
-	debug ("%s - Exit\n", __func__);
+	debug("%s: Exit\n", __func__);
 }
 
 /*----------------------------------------------------------------------
@@ -155,7 +158,8 @@ static u8 i2c_ctrl_read (struct controller *ctlr_ptr, void __iomem *WPGBbar, u8
 	unsigned long ultemp;
 	unsigned long data;	// actual data HILO format
 
-	debug_polling ("%s - Entry WPGBbar[%p] index[%x] \n", __func__, WPGBbar, index);
+	debug_polling("%s: Entry WPGBbar[%p] index[%x]\n",
+		      __func__, WPGBbar, index);
 
 	//--------------------------------------------------------------------
 	// READ - step 1
@@ -178,7 +182,7 @@ static u8 i2c_ctrl_read (struct controller *ctlr_ptr, void __iomem *WPGBbar, u8
 		ultemp = ultemp << 8;
 		data |= ultemp;
 	} else {
-		err ("this controller type is not supported \n");
+		pr_err("this controller type is not supported\n");
 		return HPC_ERROR;
 	}
 
@@ -214,7 +218,7 @@ static u8 i2c_ctrl_read (struct controller *ctlr_ptr, void __iomem *WPGBbar, u8
 		i--;
 	}
 	if (i == 0) {
-		debug ("%s - Error : WPG timeout\n", __func__);
+		debug("%s: Error: WPG timeout\n", __func__);
 		return HPC_ERROR;
 	}
 	//--------------------------------------------------------------------
@@ -230,7 +234,7 @@ static u8 i2c_ctrl_read (struct controller *ctlr_ptr, void __iomem *WPGBbar, u8
 		i--;
 	}
 	if (i == 0) {
-		debug ("ctrl_read - Exit Error:I2C timeout\n");
+		debug("ctrl_read - Exit Error:I2C timeout\n");
 		return HPC_ERROR;
 	}
 
@@ -242,7 +246,8 @@ static u8 i2c_ctrl_read (struct controller *ctlr_ptr, void __iomem *WPGBbar, u8
 
 	status = (u8) data;
 
-	debug_polling ("%s - Exit index[%x] status[%x]\n", __func__, index, status);
+	debug_polling("%s: Exit index[%x] status[%x]\n",
+		      __func__, index, status);
 
 	return (status);
 }
@@ -263,7 +268,8 @@ static u8 i2c_ctrl_write (struct controller *ctlr_ptr, void __iomem *WPGBbar, u8
 	unsigned long data;	// actual data HILO format
 	int i;
 
-	debug_polling ("%s - Entry WPGBbar[%p] index[%x] cmd[%x]\n", __func__, WPGBbar, index, cmd);
+	debug_polling("%s: Entry WPGBbar[%p] index[%x] cmd[%x]\n",
+		      __func__, WPGBbar, index, cmd);
 
 	rc = 0;
 	//--------------------------------------------------------------------
@@ -289,7 +295,7 @@ static u8 i2c_ctrl_write (struct controller *ctlr_ptr, void __iomem *WPGBbar, u8
 		ultemp = ultemp << 8;
 		data |= ultemp;
 	} else {
-		err ("this controller type is not supported \n");
+		pr_err("this controller type is not supported\n");
 		return HPC_ERROR;
 	}
 
@@ -325,7 +331,7 @@ static u8 i2c_ctrl_write (struct controller *ctlr_ptr, void __iomem *WPGBbar, u8
 		i--;
 	}
 	if (i == 0) {
-		debug ("%s - Exit Error:WPG timeout\n", __func__);
+		debug("%s: Exit Error:WPG timeout\n", __func__);
 		rc = HPC_ERROR;
 	}
 
@@ -342,11 +348,11 @@ static u8 i2c_ctrl_write (struct controller *ctlr_ptr, void __iomem *WPGBbar, u8
 		i--;
 	}
 	if (i == 0) {
-		debug ("ctrl_read - Error : I2C timeout\n");
+		debug("ctrl_read - Error : I2C timeout\n");
 		rc = HPC_ERROR;
 	}
 
-	debug_polling ("%s Exit rc[%x]\n", __func__, rc);
+	debug_polling("%s Exit rc[%x]\n", __func__, rc);
 	return (rc);
 }
 
@@ -381,7 +387,7 @@ static void isa_ctrl_write (struct controller *ctlr_ptr, u8 offset, u8 data)
 static u8 pci_ctrl_read (struct controller *ctrl, u8 offset)
 {
 	u8 data = 0x00;
-	debug ("inside pci_ctrl_read\n");
+	debug("inside pci_ctrl_read\n");
 	if (ctrl->ctrl_dev)
 		pci_read_config_byte (ctrl->ctrl_dev, HPC_PCI_OFFSET + offset, &data);
 	return data;
@@ -390,7 +396,7 @@ static u8 pci_ctrl_read (struct controller *ctrl, u8 offset)
 static u8 pci_ctrl_write (struct controller *ctrl, u8 offset, u8 data)
 {
 	u8 rc = -ENODEV;
-	debug ("inside pci_ctrl_write\n");
+	debug("inside pci_ctrl_write\n");
 	if (ctrl->ctrl_dev) {
 		pci_write_config_byte (ctrl->ctrl_dev, HPC_PCI_OFFSET + offset, data);
 		rc = 0;
@@ -476,7 +482,7 @@ static u8 hpc_writecmdtoindex (u8 cmd, u8 index)
 		break;
 
 	default:
-		err ("hpc_writecmdtoindex - Error invalid cmd[%x]\n", cmd);
+		pr_err("%s: Error invalid cmd[%x]\n", __func__, cmd);
 		rc = HPC_ERROR;
 	}
 
@@ -542,12 +548,13 @@ int ibmphp_hpc_readslot (struct slot * pslot, u8 cmd, u8 * pstatus)
 	int rc = 0;
 	int busindex;
 
-	debug_polling ("%s - Entry pslot[%p] cmd[%x] pstatus[%p]\n", __func__, pslot, cmd, pstatus);
+	debug_polling("%s: Entry pslot[%p] cmd[%x] pstatus[%p]\n",
+		      __func__, pslot, cmd, pstatus);
 
 	if ((pslot == NULL)
 	    || ((pstatus == NULL) && (cmd != READ_ALLSTAT) && (cmd != READ_BUSSTATUS))) {
 		rc = -EINVAL;
-		err ("%s - Error invalid pointer, rc[%d]\n", __func__, rc);
+		pr_err("%s: Error invalid pointer, rc[%d]\n", __func__, rc);
 		return rc;
 	}
 
@@ -555,7 +562,8 @@ int ibmphp_hpc_readslot (struct slot * pslot, u8 cmd, u8 * pstatus)
 		busindex = ibmphp_get_bus_index (pslot->bus);
 		if (busindex < 0) {
 			rc = -EINVAL;
-			err ("%s - Exit Error:invalid bus, rc[%d]\n", __func__, rc);
+			pr_err("%s: Exit Error:invalid bus, rc[%d]\n",
+			       __func__, rc);
 			return rc;
 		} else
 			index = (u8) busindex;
@@ -566,7 +574,7 @@ int ibmphp_hpc_readslot (struct slot * pslot, u8 cmd, u8 * pstatus)
 
 	if (index == HPC_ERROR) {
 		rc = -EINVAL;
-		err ("%s - Exit Error:invalid index, rc[%d]\n", __func__, rc);
+		pr_err("%s: Exit Error:invalid index, rc[%d]\n", __func__, rc);
 		return rc;
 	}
 
@@ -642,7 +650,8 @@ int ibmphp_hpc_readslot (struct slot * pslot, u8 cmd, u8 * pstatus)
 						    ctrl_read (ctlr_ptr, wpg_bbar,
 								index + WPG_1ST_EXTSLOT_INDEX);
 				} else {
-					err ("%s - Error ctrl_read failed\n", __func__);
+					pr_err("%s: Error ctrl_read failed\n",
+					       __func__);
 					rc = -EINVAL;
 					break;
 				}
@@ -663,7 +672,7 @@ int ibmphp_hpc_readslot (struct slot * pslot, u8 cmd, u8 * pstatus)
 	
 	free_hpc_access ();
 
-	debug_polling ("%s - Exit rc[%d]\n", __func__, rc);
+	debug_polling("%s: Exit rc[%d]\n", __func__, rc);
 	return rc;
 }
 
@@ -682,10 +691,10 @@ int ibmphp_hpc_writeslot (struct slot * pslot, u8 cmd)
 	int rc = 0;
 	int timeout;
 
-	debug_polling ("%s - Entry pslot[%p] cmd[%x]\n", __func__, pslot, cmd);
+	debug_polling("%s: Entry pslot[%p] cmd[%x]\n", __func__, pslot, cmd);
 	if (pslot == NULL) {
 		rc = -EINVAL;
-		err ("%s - Error Exit rc[%d]\n", __func__, rc);
+		pr_err("%s: Error Exit rc[%d]\n", __func__, rc);
 		return rc;
 	}
 
@@ -695,7 +704,8 @@ int ibmphp_hpc_writeslot (struct slot * pslot, u8 cmd)
 		busindex = ibmphp_get_bus_index (pslot->bus);
 		if (busindex < 0) {
 			rc = -EINVAL;
-			err ("%s - Exit Error:invalid bus, rc[%d]\n", __func__, rc);
+			pr_err("%s: Exit Error:invalid bus, rc[%d]\n",
+			       __func__, rc);
 			return rc;
 		} else
 			index = (u8) busindex;
@@ -706,7 +716,7 @@ int ibmphp_hpc_writeslot (struct slot * pslot, u8 cmd)
 
 	if (index == HPC_ERROR) {
 		rc = -EINVAL;
-		err ("%s - Error Exit rc[%d]\n", __func__, rc);
+		pr_err("%s: Error Exit rc[%d]\n", __func__, rc);
 		return rc;
 	}
 
@@ -720,9 +730,10 @@ int ibmphp_hpc_writeslot (struct slot * pslot, u8 cmd)
 	if ((ctlr_ptr->ctlr_type == 2) || (ctlr_ptr->ctlr_type == 4)) {
 		wpg_bbar = ioremap (ctlr_ptr->u.wpeg_ctlr.wpegbbar, WPG_I2C_IOREMAP_SIZE);
 
-		debug ("%s - ctlr id[%x] physical[%lx] logical[%lx] i2c[%x]\n", __func__,
-		ctlr_ptr->ctlr_id, (ulong) (ctlr_ptr->u.wpeg_ctlr.wpegbbar), (ulong) wpg_bbar,
-		ctlr_ptr->u.wpeg_ctlr.i2c_addr);
+		debug("%s: ctlr id[%x] physical[%lx] logical[%lx] i2c[%x]\n",
+		      __func__, ctlr_ptr->ctlr_id,
+		      (ulong)(ctlr_ptr->u.wpeg_ctlr.wpegbbar), (ulong)wpg_bbar,
+		      ctlr_ptr->u.wpeg_ctlr.i2c_addr);
 	}
 	//--------------------------------------------------------------------
 	// check controller status before writing
@@ -751,7 +762,8 @@ int ibmphp_hpc_writeslot (struct slot * pslot, u8 cmd)
 				msleep(1000);
 				if (timeout < 1) {
 					done = 1;
-					err ("%s - Error command complete timeout\n", __func__);
+					pr_err("%s: Error command complete timeout\n",
+					       __func__);
 					rc = -EFAULT;
 				} else
 					timeout--;
@@ -766,7 +778,7 @@ int ibmphp_hpc_writeslot (struct slot * pslot, u8 cmd)
 		iounmap (wpg_bbar);
 	free_hpc_access ();
 
-	debug_polling ("%s - Exit rc[%d]\n", __func__, rc);
+	debug_polling("%s: Exit rc[%d]\n", __func__, rc);
 	return rc;
 }
 
@@ -804,10 +816,10 @@ void ibmphp_lock_operations (void)
 *---------------------------------------------------------------------*/
 void ibmphp_unlock_operations (void)
 {
-	debug ("%s - Entry\n", __func__);
+	debug("%s: Entry\n", __func__);
 	up (&semOperations);
 	to_debug = 0;
-	debug ("%s - Exit\n", __func__);
+	debug("%s: Exit\n", __func__);
 }
 
 /*----------------------------------------------------------------------
@@ -828,7 +840,7 @@ static int poll_hpc(void *data)
 	int poll_count = 0;
 	u8 ctrl_count = 0x00;
 
-	debug ("%s - Entry\n", __func__);
+	debug("%s: Entry\n", __func__);
 
 	while (!kthread_should_stop()) {
 		/* try to get the lock to do some kind of hardware access */
@@ -909,7 +921,7 @@ out_sleep:
 		msleep(100);
 	}
 	up (&sem_exit);
-	debug ("%s - Exit\n", __func__);
+	debug("%s: Exit\n", __func__);
 	return 0;
 }
 
@@ -936,7 +948,8 @@ static int process_changeinstatus (struct slot *pslot, struct slot *poldslot)
 	u8 disable = 0;
 	u8 update = 0;
 
-	debug ("process_changeinstatus - Entry pslot[%p], poldslot[%p]\n", pslot, poldslot);
+	debug("process_changeinstatus - Entry pslot[%p], poldslot[%p]\n",
+	      pslot, poldslot);
 
 	// bit 0 - HPC_SLOT_POWER
 	if ((pslot->status & 0x01) != (poldslot->status & 0x01))
@@ -992,7 +1005,7 @@ static int process_changeinstatus (struct slot *pslot, struct slot *poldslot)
 		update = 1;
 
 	if (disable) {
-		debug ("process_changeinstatus - disable slot\n");
+		debug("process_changeinstatus - disable slot\n");
 		pslot->flag = 0;
 		rc = ibmphp_do_disable_slot (pslot);
 	}
@@ -1001,7 +1014,8 @@ static int process_changeinstatus (struct slot *pslot, struct slot *poldslot)
 		ibmphp_update_slot_info (pslot);
 	}
 
-	debug ("%s - Exit rc[%d] disable[%x] update[%x]\n", __func__, rc, disable, update);
+	debug("%s: Exit rc[%d] disable[%x] update[%x]\n",
+	      __func__, rc, disable, update);
 
 	return rc;
 }
@@ -1023,7 +1037,7 @@ static int process_changeinlatch (u8 old, u8 new, struct controller *ctrl)
 	u8 mask;
 	int rc = 0;
 
-	debug ("%s - Entry old[%x], new[%x]\n", __func__, old, new);
+	debug("%s: Entry old[%x], new[%x]\n", __func__, old, new);
 	// bit 0 reserved, 0 is LSB, check bit 1-6 for 6 slots
 
 	for (i = ctrl->starting_slot_num; i <= ctrl->ending_slot_num; i++) {
@@ -1033,15 +1047,17 @@ static int process_changeinlatch (u8 old, u8 new, struct controller *ctrl)
 			if (pslot) {
 				memcpy ((void *) &myslot, (void *) pslot, sizeof (struct slot));
 				rc = ibmphp_hpc_readslot (pslot, READ_ALLSTAT, NULL);
-				debug ("%s - call process_changeinstatus for slot[%d]\n", __func__, i);
+				debug("%s: call process_changeinstatus for slot[%d]\n",
+				      __func__, i);
 				process_changeinstatus (pslot, &myslot);
 			} else {
 				rc = -EINVAL;
-				err ("%s - Error bad pointer for slot[%d]\n", __func__, i);
+				pr_err("%s: Error bad pointer for slot[%d]\n",
+				       __func__, i);
 			}
 		}
 	}
-	debug ("%s - Exit rc[%d]\n", __func__, rc);
+	debug("%s: Exit rc[%d]\n", __func__, rc);
 	return rc;
 }
 
@@ -1052,11 +1068,11 @@ static int process_changeinlatch (u8 old, u8 new, struct controller *ctrl)
 *---------------------------------------------------------------------*/
 int __init ibmphp_hpc_start_poll_thread (void)
 {
-	debug ("%s - Entry\n", __func__);
+	debug("%s: Entry\n", __func__);
 
 	ibmphp_poll_thread = kthread_run(poll_hpc, NULL, "hpc_poll");
 	if (IS_ERR(ibmphp_poll_thread)) {
-		err ("%s - Error, thread not started\n", __func__);
+		pr_err("%s: Error, thread not started\n", __func__);
 		return PTR_ERR(ibmphp_poll_thread);
 	}
 	return 0;
@@ -1069,28 +1085,28 @@ int __init ibmphp_hpc_start_poll_thread (void)
 *---------------------------------------------------------------------*/
 void __exit ibmphp_hpc_stop_poll_thread (void)
 {
-	debug ("%s - Entry\n", __func__);
+	debug("%s: Entry\n", __func__);
 
 	kthread_stop(ibmphp_poll_thread);
-	debug ("before locking operations \n");
+	debug("before locking operations\n");
 	ibmphp_lock_operations ();
-	debug ("after locking operations \n");
+	debug("after locking operations\n");
 	
 	// wait for poll thread to exit
-	debug ("before sem_exit down \n");
+	debug("before sem_exit down\n");
 	down (&sem_exit);
-	debug ("after sem_exit down \n");
+	debug("after sem_exit down\n");
 
 	// cleanup
-	debug ("before free_hpc_access \n");
+	debug("before free_hpc_access\n");
 	free_hpc_access ();
-	debug ("after free_hpc_access \n");
+	debug("after free_hpc_access\n");
 	ibmphp_unlock_operations ();
-	debug ("after unlock operations \n");
+	debug("after unlock operations\n");
 	up (&sem_exit);
-	debug ("after sem exit up\n");
+	debug("after sem exit up\n");
 
-	debug ("%s - Exit\n", __func__);
+	debug("%s: Exit\n", __func__);
 }
 
 /*----------------------------------------------------------------------
@@ -1107,7 +1123,8 @@ static int hpc_wait_ctlr_notworking (int timeout, struct controller *ctlr_ptr, v
 	int rc = 0;
 	u8 done = 0;
 
-	debug_polling ("hpc_wait_ctlr_notworking - Entry timeout[%d]\n", timeout);
+	debug_polling("hpc_wait_ctlr_notworking - Entry timeout[%d]\n",
+		      timeout);
 
 	while (!done) {
 		*pstatus = ctrl_read (ctlr_ptr, wpg_bbar, WPG_CTLR_INDEX);
@@ -1121,12 +1138,13 @@ static int hpc_wait_ctlr_notworking (int timeout, struct controller *ctlr_ptr, v
 			msleep(1000);
 			if (timeout < 1) {
 				done = 1;
-				err ("HPCreadslot - Error ctlr timeout\n");
+				pr_err("HPCreadslot - Error ctlr timeout\n");
 				rc = HPC_ERROR;
 			} else
 				timeout--;
 		}
 	}
-	debug_polling ("hpc_wait_ctlr_notworking - Exit rc[%x] status[%x]\n", rc, *pstatus);
+	debug_polling("hpc_wait_ctlr_notworking - Exit rc[%x] status[%x]\n",
+		      rc, *pstatus);
 	return rc;
 }
diff --git a/drivers/pci/hotplug/ibmphp_pci.c b/drivers/pci/hotplug/ibmphp_pci.c
index 7b09e16..545ade0 100644
--- a/drivers/pci/hotplug/ibmphp_pci.c
+++ b/drivers/pci/hotplug/ibmphp_pci.c
@@ -27,6 +27,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/pci.h>
@@ -92,7 +94,7 @@ int ibmphp_configure_card (struct pci_func *func, u8 slotno)
 	u8 flag;
 	u8 valid_device = 0x00; /* to see if we are able to read from card any device info at all */
 
-	debug ("inside configure_card, func->busno = %x\n", func->busno);
+	debug("inside configure_card, func->busno = %x\n", func->busno);
 
 	device = func->device;
 	cur_func = func;
@@ -109,15 +111,16 @@ int ibmphp_configure_card (struct pci_func *func, u8 slotno)
 
 		cur_func->function = function;
 
-		debug ("inside the loop, cur_func->busno = %x, cur_func->device = %x, cur_func->funcion = %x\n",
-			cur_func->busno, cur_func->device, cur_func->function);
+		debug("inside the loop, cur_func->busno = %x, cur_func->device = %x, cur_func->funcion = %x\n",
+		      cur_func->busno, cur_func->device, cur_func->function);
 
 		pci_bus_read_config_word (ibmphp_pci_bus, devfn, PCI_VENDOR_ID, &vendor_id);
 
-		debug ("vendor_id is %x\n", vendor_id);
+		debug("vendor_id is %x\n", vendor_id);
 		if (vendor_id != PCI_VENDOR_ID_NOTVALID) {
 			/* found correct device!!! */
-			debug ("found valid device, vendor_id = %x\n", vendor_id);
+			debug("found valid device, vendor_id = %x\n",
+			      vendor_id);
 
 			++valid_device;
 
@@ -130,25 +133,30 @@ int ibmphp_configure_card (struct pci_func *func, u8 slotno)
 			pci_bus_read_config_dword (ibmphp_pci_bus, devfn, PCI_CLASS_REVISION, &class);
 
 			class_code = class >> 24;
-			debug ("hrd_type = %x, class = %x, class_code %x\n", hdr_type, class, class_code);
+			debug("hrd_type = %x, class = %x, class_code %x\n",
+			      hdr_type, class, class_code);
 			class >>= 8;	/* to take revision out, class = class.subclass.prog i/f */
 			if (class == PCI_CLASS_NOT_DEFINED_VGA) {
-				err ("The device %x is VGA compatible and as is not supported for hot plugging. "
-				     "Please choose another device.\n", cur_func->device);
+				pr_err("The device %x is VGA compatible and as is not supported for hot plugging. "
+				       "Please choose another device.\n",
+				       cur_func->device);
 				return -ENODEV;
 			} else if (class == PCI_CLASS_DISPLAY_VGA) {
-				err ("The device %x is not supported for hot plugging. "
-				     "Please choose another device.\n", cur_func->device);
+				pr_err("The device %x is not supported for hot plugging. "
+				       "Please choose another device.\n",
+				       cur_func->device);
 				return -ENODEV;
 			}
 			switch (hdr_type) {
 				case PCI_HEADER_TYPE_NORMAL:
-					debug ("single device case.... vendor id = %x, hdr_type = %x, class = %x\n", vendor_id, hdr_type, class);
+					debug("single device case.... vendor id = %x, hdr_type = %x, class = %x\n",
+					      vendor_id, hdr_type, class);
 					assign_alt_irq (cur_func, class_code);
 					if ((rc = configure_device (cur_func)) < 0) {
 						/* We need to do this in case some other BARs were properly inserted */
-						err ("was not able to configure devfunc %x on bus %x.\n",
-						     cur_func->device, cur_func->busno);
+						pr_err("was not able to configure devfunc %x on bus %x.\n",
+						       cur_func->device,
+						       cur_func->busno);
 						cleanup_count = 6;
 						goto error;
 					}	
@@ -159,14 +167,15 @@ int ibmphp_configure_card (struct pci_func *func, u8 slotno)
 					assign_alt_irq (cur_func, class_code);
 					if ((rc = configure_device (cur_func)) < 0) {
 						/* We need to do this in case some other BARs were properly inserted */
-						err ("was not able to configure devfunc %x on bus %x...bailing out\n",
-						     cur_func->device, cur_func->busno);
+						pr_err("was not able to configure devfunc %x on bus %x...bailing out\n",
+						       cur_func->device,
+						       cur_func->busno);
 						cleanup_count = 6;
 						goto error;
 					}
 					newfunc = kzalloc(sizeof(*newfunc), GFP_KERNEL);
 					if (!newfunc) {
-						err ("out of system memory\n");
+						pr_err("out of system memory\n");
 						return -ENOMEM;
 					}
 					newfunc->busno = cur_func->busno;
@@ -179,20 +188,23 @@ int ibmphp_configure_card (struct pci_func *func, u8 slotno)
 				case PCI_HEADER_TYPE_MULTIBRIDGE:
 					class >>= 8;
 					if (class != PCI_CLASS_BRIDGE_PCI) {
-						err ("This %x is not PCI-to-PCI bridge, and as is not supported for hot-plugging. "
-						     "Please insert another card.\n", cur_func->device);
+						pr_err("This %x is not PCI-to-PCI bridge, and as is not supported for hot-plugging. "
+						       "Please insert another card.\n",
+						       cur_func->device);
 						return -ENODEV;
 					}
 					assign_alt_irq (cur_func, class_code);
 					rc = configure_bridge (&cur_func, slotno);
 					if (rc == -ENODEV) {
-						err ("You chose to insert Single Bridge, or nested bridges, this is not supported...\n");
-						err ("Bus %x, devfunc %x\n", cur_func->busno, cur_func->device);
+						pr_err("You chose to insert Single Bridge, or nested bridges, this is not supported...\n");
+						pr_err("Bus %x, devfunc %x\n",
+						       cur_func->busno,
+						       cur_func->device);
 						return rc;
 					}
 					if (rc) {
 						/* We need to do this in case some other BARs were properly inserted */
-						err ("was not able to hot-add PPB properly.\n");
+						pr_err("was not able to hot-add PPB properly\n");
 						func->bus = 1; /* To indicate to the unconfigure function that this is a PPB */
 						cleanup_count = 2;
 						goto error;
@@ -204,7 +216,7 @@ int ibmphp_configure_card (struct pci_func *func, u8 slotno)
 						if (func->devices[i]) {
 							newfunc = kzalloc(sizeof(*newfunc), GFP_KERNEL);
 							if (!newfunc) {
-								err ("out of system memory\n");
+								pr_err("out of system memory\n");
 								return -ENOMEM;
 							}
 							newfunc->busno = sec_number;
@@ -232,7 +244,7 @@ int ibmphp_configure_card (struct pci_func *func, u8 slotno)
 
 					newfunc = kzalloc(sizeof(*newfunc), GFP_KERNEL);
 					if (!newfunc) {
-						err ("out of system memory\n");
+						pr_err("out of system memory\n");
 						return -ENOMEM;
 					}
 					newfunc->busno = cur_func->busno;
@@ -245,40 +257,46 @@ int ibmphp_configure_card (struct pci_func *func, u8 slotno)
 					break;
 				case PCI_HEADER_TYPE_BRIDGE:
 					class >>= 8;
-					debug ("class now is %x\n", class);
+					debug("class now is %x\n", class);
 					if (class != PCI_CLASS_BRIDGE_PCI) {
-						err ("This %x is not PCI-to-PCI bridge, and as is not supported for hot-plugging. "
-						     "Please insert another card.\n", cur_func->device);
+						pr_err("This %x is not PCI-to-PCI bridge, and as is not supported for hot-plugging. "
+						       "Please insert another card.\n",
+						       cur_func->device);
 						return -ENODEV;
 					}
 
 					assign_alt_irq (cur_func, class_code);
 
-					debug ("cur_func->busno b4 configure_bridge is %x\n", cur_func->busno);
+					debug("cur_func->busno b4 configure_bridge is %x\n",
+					      cur_func->busno);
 					rc = configure_bridge (&cur_func, slotno);
 					if (rc == -ENODEV) {
-						err ("You chose to insert Single Bridge, or nested bridges, this is not supported...\n");
-						err ("Bus %x, devfunc %x\n", cur_func->busno, cur_func->device);
+						pr_err("You chose to insert Single Bridge, or nested bridges, this is not supported...\n");
+						pr_err("Bus %x, devfunc %x\n",
+						       cur_func->busno,
+						       cur_func->device);
 						return rc;
 					}
 					if (rc) {
 						/* We need to do this in case some other BARs were properly inserted */
 						func->bus = 1; /* To indicate to the unconfigure function that this is a PPB */
-						err ("was not able to hot-add PPB properly.\n");
+						pr_err("was not able to hot-add PPB properly\n");
 						cleanup_count = 2;
 						goto error;
 					}
-					debug ("cur_func->busno = %x, device = %x, function = %x\n",
-						cur_func->busno, device, function);
+					debug("cur_func->busno = %x, device = %x, function = %x\n",
+					      cur_func->busno, device, function);
 					pci_bus_read_config_byte (ibmphp_pci_bus, devfn, PCI_SECONDARY_BUS, &sec_number);
-					debug ("after configuring bridge..., sec_number = %x\n", sec_number);
+					debug("after configuring bridge..., sec_number = %x\n",
+					      sec_number);
 					flag = 0;
 					for (i = 0; i < 32; i++) {
 						if (func->devices[i]) {
-							debug ("inside for loop, device is %x\n", i);
+							debug("inside for loop, device is %x\n",
+							      i);
 							newfunc = kzalloc(sizeof(*newfunc), GFP_KERNEL);
 							if (!newfunc) {
-								err (" out of system memory\n");
+								pr_err("out of system memory\n");
 								return -ENOMEM;
 							}
 							newfunc->busno = sec_number;
@@ -308,7 +326,8 @@ int ibmphp_configure_card (struct pci_func *func, u8 slotno)
 					function = 0x8;
 					break;
 				default:
-					err ("MAJOR PROBLEM!!!!, header type not supported? %x\n", hdr_type);
+					pr_err("MAJOR PROBLEM!!!!, header type not supported? %x\n",
+					       hdr_type);
 					return -ENXIO;
 					break;
 			}	/* end of switch */
@@ -316,7 +335,7 @@ int ibmphp_configure_card (struct pci_func *func, u8 slotno)
 	}	/* end of for */
 
 	if (!valid_device) {
-		err ("Cannot find any valid devices on the card.  Or unable to read from card.\n");
+		pr_err("Cannot find any valid devices on the card.  Or unable to read from card.\n");
 		return -ENODEV;
 	}
 
@@ -364,7 +383,7 @@ static int configure_device (struct pci_func *func)
 	struct resource_node *pfmem[6];
 	unsigned int devfn;
 
-	debug ("%s - inside\n", __func__);
+	debug("%s: inside\n", __func__);
 
 	devfn = PCI_DEVFN(func->device, func->function);
 	ibmphp_pci_bus->number = func->busno;
@@ -390,21 +409,23 @@ static int configure_device (struct pci_func *func)
 		if (!bar[count])	/* This BAR is not implemented */
 			continue;
 
-		debug ("Device %x BAR %d wants %x\n", func->device, count, bar[count]);
+		debug("Device %x BAR %d wants %x\n",
+		      func->device, count, bar[count]);
 
 		if (bar[count] & PCI_BASE_ADDRESS_SPACE_IO) {
 			/* This is IO */
-			debug ("inside IO SPACE\n");
+			debug("inside IO SPACE\n");
 
 			len[count] = bar[count] & 0xFFFFFFFC;
 			len[count] = ~len[count] + 1;
 
-			debug ("len[count] in IO %x, count %d\n", len[count], count);
+			debug("len[count] in IO %x, count %d\n",
+			      len[count], count);
 
 			io[count] = kzalloc(sizeof(struct resource_node), GFP_KERNEL);
 
 			if (!io[count]) {
-				err ("out of system memory\n");
+				pr_err("out of system memory\n");
 				return -ENOMEM;
 			}
 			io[count]->type = IO;
@@ -415,33 +436,37 @@ static int configure_device (struct pci_func *func)
 				ibmphp_add_resource (io[count]);
 				func->io[count] = io[count];
 			} else {
-				err ("cannot allocate requested io for bus %x device %x function %x len %x\n",
-				     func->busno, func->device, func->function, len[count]);
+				pr_err("cannot allocate requested io for bus %x device %x function %x len %x\n",
+				       func->busno, func->device,
+				       func->function, len[count]);
 				kfree (io[count]);
 				return -EIO;
 			}
 			pci_bus_write_config_dword (ibmphp_pci_bus, devfn, address[count], func->io[count]->start);
 	
 			/* _______________This is for debugging purposes only_____________________ */ 
-			debug ("b4 writing, the IO address is %x\n", func->io[count]->start);
+			debug("b4 writing, the IO address is %x\n",
+			      func->io[count]->start);
 			pci_bus_read_config_dword (ibmphp_pci_bus, devfn, address[count], &bar[count]);
-			debug ("after writing.... the start address is %x\n", bar[count]);
+			debug("after writing.... the start address is %x\n",
+			      bar[count]);
 			/* _________________________________________________________________________*/
 
 		} else {
 			/* This is Memory */
 			if (bar[count] & PCI_BASE_ADDRESS_MEM_PREFETCH) {
 				/* pfmem */
-				debug ("PFMEM SPACE\n");
+				debug("PFMEM SPACE\n");
 
 				len[count] = bar[count] & 0xFFFFFFF0;
 				len[count] = ~len[count] + 1;
 
-				debug ("len[count] in PFMEM %x, count %d\n", len[count], count);
+				debug("len[count] in PFMEM %x, count %d\n",
+				      len[count], count);
 
 				pfmem[count] = kzalloc(sizeof(struct resource_node), GFP_KERNEL);
 				if (!pfmem[count]) {
-					err ("out of system memory\n");
+					pr_err("out of system memory\n");
 					return -ENOMEM;
 				}
 				pfmem[count]->type = PFMEM;
@@ -456,7 +481,7 @@ static int configure_device (struct pci_func *func)
 				} else {
 					mem_tmp = kzalloc(sizeof(*mem_tmp), GFP_KERNEL);
 					if (!mem_tmp) {
-						err ("out of system memory\n");
+						pr_err("out of system memory\n");
 						kfree (pfmem[count]);
 						return -ENOMEM;
 					}
@@ -464,7 +489,7 @@ static int configure_device (struct pci_func *func)
 					mem_tmp->busno = pfmem[count]->busno;
 					mem_tmp->devfunc = pfmem[count]->devfunc;
 					mem_tmp->len = pfmem[count]->len;
-					debug ("there's no pfmem... going into mem.\n");
+					debug("there's no pfmem... going into mem\n");
 					if (ibmphp_check_resource (mem_tmp, 0) == 0) {
 						ibmphp_add_resource (mem_tmp);
 						pfmem[count]->fromMem = 1;
@@ -474,8 +499,10 @@ static int configure_device (struct pci_func *func)
 						ibmphp_add_pfmem_from_mem (pfmem[count]);
 						func->pfmem[count] = pfmem[count];
 					} else {
-						err ("cannot allocate requested pfmem for bus %x, device %x, len %x\n",
-						     func->busno, func->device, len[count]);
+						pr_err("cannot allocate requested pfmem for bus %x, device %x, len %x\n",
+						       func->busno,
+						       func->device,
+						       len[count]);
 						kfree (mem_tmp);
 						kfree (pfmem[count]);
 						return -EIO;
@@ -485,29 +512,33 @@ static int configure_device (struct pci_func *func)
 				pci_bus_write_config_dword (ibmphp_pci_bus, devfn, address[count], func->pfmem[count]->start);
 
 				/*_______________This is for debugging purposes only______________________________*/				
-				debug ("b4 writing, start address is %x\n", func->pfmem[count]->start);
+				debug("b4 writing, start address is %x\n",
+				      func->pfmem[count]->start);
 				pci_bus_read_config_dword (ibmphp_pci_bus, devfn, address[count], &bar[count]);
-				debug ("after writing, start address is %x\n", bar[count]);
+				debug("after writing, start address is %x\n",
+				      bar[count]);
 				/*_________________________________________________________________________________*/
 
 				if (bar[count] & PCI_BASE_ADDRESS_MEM_TYPE_64) {	/* takes up another dword */
-					debug ("inside the mem 64 case, count %d\n", count);
+					debug("inside the mem 64 case, count %d\n",
+					      count);
 					count += 1;
 					/* on the 2nd dword, write all 0s, since we can't handle them n.e.ways */
 					pci_bus_write_config_dword (ibmphp_pci_bus, devfn, address[count], 0x00000000);
 				}
 			} else {
 				/* regular memory */
-				debug ("REGULAR MEM SPACE\n");
+				debug("REGULAR MEM SPACE\n");
 
 				len[count] = bar[count] & 0xFFFFFFF0;
 				len[count] = ~len[count] + 1;
 
-				debug ("len[count] in Mem %x, count %d\n", len[count], count);
+				debug("len[count] in Mem %x, count %d\n",
+				      len[count], count);
 
 				mem[count] = kzalloc(sizeof(struct resource_node), GFP_KERNEL);
 				if (!mem[count]) {
-					err ("out of system memory\n");
+					pr_err("out of system memory\n");
 					return -ENOMEM;
 				}
 				mem[count]->type = MEM;
@@ -519,21 +550,25 @@ static int configure_device (struct pci_func *func)
 					ibmphp_add_resource (mem[count]);
 					func->mem[count] = mem[count];
 				} else {
-					err ("cannot allocate requested mem for bus %x, device %x, len %x\n",
-					     func->busno, func->device, len[count]);
+					pr_err("cannot allocate requested mem for bus %x, device %x, len %x\n",
+					       func->busno, func->device,
+					       len[count]);
 					kfree (mem[count]);
 					return -EIO;
 				}
 				pci_bus_write_config_dword (ibmphp_pci_bus, devfn, address[count], func->mem[count]->start);
 				/* _______________________This is for debugging purposes only _______________________*/
-				debug ("b4 writing, start address is %x\n", func->mem[count]->start);
+				debug("b4 writing, start address is %x\n",
+				      func->mem[count]->start);
 				pci_bus_read_config_dword (ibmphp_pci_bus, devfn, address[count], &bar[count]);
-				debug ("after writing, the address is %x\n", bar[count]);
+				debug("after writing, the address is %x\n",
+				      bar[count]);
 				/* __________________________________________________________________________________*/
 
 				if (bar[count] & PCI_BASE_ADDRESS_MEM_TYPE_64) {
 					/* takes up another dword */
-					debug ("inside mem 64 case, reg. mem, count %d\n", count);
+					debug("inside mem 64 case, reg. mem, count %d\n",
+					      count);
 					count += 1;
 					/* on the 2nd dword, write all 0s, since we can't handle them n.e.ways */
 					pci_bus_write_config_dword (ibmphp_pci_bus, devfn, address[count], 0x00000000);
@@ -595,7 +630,7 @@ static int configure_bridge (struct pci_func **func_passed, u8 slotno)
 	u8 irq;
 	int retval;
 
-	debug ("%s - enter\n", __func__);
+	debug("%s: enter\n", __func__);
 
 	devfn = PCI_DEVFN(func->function, func->device);
 	ibmphp_pci_bus->number = func->busno;
@@ -608,39 +643,39 @@ static int configure_bridge (struct pci_func **func_passed, u8 slotno)
 
 	/* _____________________For debugging purposes only __________________________
 	pci_bus_config_byte (ibmphp_pci_bus, devfn, PCI_PRIMARY_BUS, &pri_number);
-	debug ("primary # written into the bridge is %x\n", pri_number);
+	debug("primary # written into the bridge is %x\n", pri_number);
 	 ___________________________________________________________________________*/
 
 	/* in EBDA, only get allocated 1 additional bus # per slot */
 	sec_number = find_sec_number (func->busno, slotno);
 	if (sec_number == 0xff) {
-		err ("cannot allocate secondary bus number for the bridged device\n");
+		pr_err("cannot allocate secondary bus number for the bridged device\n");
 		return -EINVAL;
 	}
 
-	debug ("after find_sec_number, the number we got is %x\n", sec_number);
-	debug ("AFTER FIND_SEC_NUMBER, func->busno IS %x\n", func->busno);
+	debug("after find_sec_number, the number we got is %x\n", sec_number);
+	debug("AFTER FIND_SEC_NUMBER, func->busno IS %x\n", func->busno);
 
 	pci_bus_write_config_byte (ibmphp_pci_bus, devfn, PCI_SECONDARY_BUS, sec_number);
 	
 	/* __________________For debugging purposes only __________________________________
 	pci_bus_read_config_byte (ibmphp_pci_bus, devfn, PCI_SECONDARY_BUS, &sec_number);
-	debug ("sec_number after write/read is %x\n", sec_number);
+	debug("sec_number after write/read is %x\n", sec_number);
 	 ________________________________________________________________________________*/
 
 	pci_bus_write_config_byte (ibmphp_pci_bus, devfn, PCI_SUBORDINATE_BUS, sec_number);
 
 	/* __________________For debugging purposes only ____________________________________
 	pci_bus_read_config_byte (ibmphp_pci_bus, devfn, PCI_SUBORDINATE_BUS, &sec_number);
-	debug ("subordinate number after write/read is %x\n", sec_number);
+	debug("subordinate number after write/read is %x\n", sec_number);
 	 __________________________________________________________________________________*/
 
 	pci_bus_write_config_byte (ibmphp_pci_bus, devfn, PCI_CACHE_LINE_SIZE, CACHE);
 	pci_bus_write_config_byte (ibmphp_pci_bus, devfn, PCI_LATENCY_TIMER, LATENCY);
 	pci_bus_write_config_byte (ibmphp_pci_bus, devfn, PCI_SEC_LATENCY_TIMER, LATENCY);
 
-	debug ("func->busno is %x\n", func->busno);
-	debug ("sec_number after writing is %x\n", sec_number);
+	debug("func->busno is %x\n", func->busno);
+	debug("sec_number after writing is %x\n", sec_number);
 
 
 	/* !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
@@ -655,24 +690,24 @@ static int configure_bridge (struct pci_func **func_passed, u8 slotno)
 
 		if (!bar[count]) {
 			/* This BAR is not implemented */
-			debug ("so we come here then, eh?, count = %d\n", count);
+			debug("so we come here then, eh?, count = %d\n", count);
 			continue;
 		}
 		//  tmp_bar = bar[count];
 
-		debug ("Bar %d wants %x\n", count, bar[count]);
+		debug("Bar %d wants %x\n", count, bar[count]);
 
 		if (bar[count] & PCI_BASE_ADDRESS_SPACE_IO) {
 			/* This is IO */
 			len[count] = bar[count] & 0xFFFFFFFC;
 			len[count] = ~len[count] + 1;
 
-			debug ("len[count] in IO = %x\n", len[count]);
+			debug("len[count] in IO = %x\n", len[count]);
 
 			bus_io[count] = kzalloc(sizeof(struct resource_node), GFP_KERNEL);
 		
 			if (!bus_io[count]) {
-				err ("out of system memory\n");
+				pr_err("out of system memory\n");
 				retval = -ENOMEM;
 				goto error;
 			}
@@ -685,8 +720,8 @@ static int configure_bridge (struct pci_func **func_passed, u8 slotno)
 				ibmphp_add_resource (bus_io[count]);
 				func->io[count] = bus_io[count];
 			} else {
-				err ("cannot allocate requested io for bus %x, device %x, len %x\n",
-				     func->busno, func->device, len[count]);
+				pr_err("cannot allocate requested io for bus %x, device %x, len %x\n",
+				       func->busno, func->device, len[count]);
 				kfree (bus_io[count]);
 				return -EIO;
 			}
@@ -700,11 +735,11 @@ static int configure_bridge (struct pci_func **func_passed, u8 slotno)
 				len[count] = bar[count] & 0xFFFFFFF0;
 				len[count] = ~len[count] + 1;
 
-				debug ("len[count] in PFMEM = %x\n", len[count]);
+				debug("len[count] in PFMEM = %x\n", len[count]);
 
 				bus_pfmem[count] = kzalloc(sizeof(struct resource_node), GFP_KERNEL);
 				if (!bus_pfmem[count]) {
-					err ("out of system memory\n");
+					pr_err("out of system memory\n");
 					retval = -ENOMEM;
 					goto error;
 				}
@@ -720,7 +755,7 @@ static int configure_bridge (struct pci_func **func_passed, u8 slotno)
 				} else {
 					mem_tmp = kzalloc(sizeof(*mem_tmp), GFP_KERNEL);
 					if (!mem_tmp) {
-						err ("out of system memory\n");
+						pr_err("out of system memory\n");
 						retval = -ENOMEM;
 						goto error;
 					}
@@ -735,8 +770,10 @@ static int configure_bridge (struct pci_func **func_passed, u8 slotno)
 						ibmphp_add_pfmem_from_mem (bus_pfmem[count]);
 						func->pfmem[count] = bus_pfmem[count];
 					} else {
-						err ("cannot allocate requested pfmem for bus %x, device %x, len %x\n", 
-						     func->busno, func->device, len[count]);
+						pr_err("cannot allocate requested pfmem for bus %x, device %x, len %x\n",
+						       func->busno,
+						       func->device,
+						       len[count]);
 						kfree (mem_tmp);
 						kfree (bus_pfmem[count]);
 						return -EIO;
@@ -757,11 +794,12 @@ static int configure_bridge (struct pci_func **func_passed, u8 slotno)
 				len[count] = bar[count] & 0xFFFFFFF0;
 				len[count] = ~len[count] + 1;
 
-				debug ("len[count] in Memory is %x\n", len[count]);
+				debug("len[count] in Memory is %x\n",
+				      len[count]);
 
 				bus_mem[count] = kzalloc(sizeof(struct resource_node), GFP_KERNEL);
 				if (!bus_mem[count]) {
-					err ("out of system memory\n");
+					pr_err("out of system memory\n");
 					retval = -ENOMEM;
 					goto error;
 				}
@@ -774,8 +812,9 @@ static int configure_bridge (struct pci_func **func_passed, u8 slotno)
 					ibmphp_add_resource (bus_mem[count]);
 					func->mem[count] = bus_mem[count];
 				} else {
-					err ("cannot allocate requested mem for bus %x, device %x, len %x\n",
-					     func->busno, func->device, len[count]);
+					pr_err("cannot allocate requested mem for bus %x, device %x, len %x\n",
+					       func->busno, func->device,
+					       len[count]);
 					kfree (bus_mem[count]);
 					return -EIO;
 				}
@@ -799,14 +838,14 @@ static int configure_bridge (struct pci_func **func_passed, u8 slotno)
 		return -ENOMEM;
 
 	ibmphp_pci_bus->number = func->busno;
-	debug ("after coming back from scan_behind_bridge\n");
-	debug ("amount_needed->not_correct = %x\n", amount_needed->not_correct);
-	debug ("amount_needed->io = %x\n", amount_needed->io);
-	debug ("amount_needed->mem = %x\n", amount_needed->mem);
-	debug ("amount_needed->pfmem =  %x\n", amount_needed->pfmem);
+	debug("after coming back from scan_behind_bridge\n");
+	debug("amount_needed->not_correct = %x\n", amount_needed->not_correct);
+	debug("amount_needed->io = %x\n", amount_needed->io);
+	debug("amount_needed->mem = %x\n", amount_needed->mem);
+	debug("amount_needed->pfmem =  %x\n", amount_needed->pfmem);
 
 	if (amount_needed->not_correct) {		
-		debug ("amount_needed is not correct\n");
+		debug("amount_needed is not correct\n");
 		for (count = 0; address[count]; count++) {
 			/* for 2 BARs */
 			if (bus_io[count]) {
@@ -825,14 +864,14 @@ static int configure_bridge (struct pci_func **func_passed, u8 slotno)
 	}
 
 	if (!amount_needed->io) {
-		debug ("it doesn't want IO?\n");
+		debug("it doesn't want IO?\n");
 		flag_io = 1;
 	} else {
-		debug ("it wants %x IO behind the bridge\n", amount_needed->io);
+		debug("it wants %x IO behind the bridge\n", amount_needed->io);
 		io = kzalloc(sizeof(*io), GFP_KERNEL);
 		
 		if (!io) {
-			err ("out of system memory\n");
+			pr_err("out of system memory\n");
 			retval = -ENOMEM;
 			goto error;
 		}
@@ -841,20 +880,21 @@ static int configure_bridge (struct pci_func **func_passed, u8 slotno)
 		io->devfunc = PCI_DEVFN(func->device, func->function);
 		io->len = amount_needed->io;
 		if (ibmphp_check_resource (io, 1) == 0) {
-			debug ("were we able to add io\n");
+			debug("were we able to add io\n");
 			ibmphp_add_resource (io);
 			flag_io = 1;
 		}
 	}
 
 	if (!amount_needed->mem) {
-		debug ("it doesn't want n.e.memory?\n");
+		debug("it doesn't want n.e.memory?\n");
 		flag_mem = 1;
 	} else {
-		debug ("it wants %x memory behind the bridge\n", amount_needed->mem);
+		debug("it wants %x memory behind the bridge\n",
+		      amount_needed->mem);
 		mem = kzalloc(sizeof(*mem), GFP_KERNEL);
 		if (!mem) {
-			err ("out of system memory\n");
+			pr_err("out of system memory\n");
 			retval = -ENOMEM;
 			goto error;
 		}
@@ -865,18 +905,19 @@ static int configure_bridge (struct pci_func **func_passed, u8 slotno)
 		if (ibmphp_check_resource (mem, 1) == 0) {
 			ibmphp_add_resource (mem);
 			flag_mem = 1;
-			debug ("were we able to add mem\n");
+			debug("were we able to add mem\n");
 		}
 	}
 
 	if (!amount_needed->pfmem) {
-		debug ("it doesn't want n.e.pfmem mem?\n");
+		debug("it doesn't want n.e.pfmem mem?\n");
 		flag_pfmem = 1;
 	} else {
-		debug ("it wants %x pfmemory behind the bridge\n", amount_needed->pfmem);
+		debug("it wants %x pfmemory behind the bridge\n",
+		      amount_needed->pfmem);
 		pfmem = kzalloc(sizeof(*pfmem), GFP_KERNEL);
 		if (!pfmem) {
-			err ("out of system memory\n");
+			pr_err("out of system memory\n");
 			retval = -ENOMEM;
 			goto error;
 		}
@@ -891,7 +932,7 @@ static int configure_bridge (struct pci_func **func_passed, u8 slotno)
 		} else {
 			mem_tmp = kzalloc(sizeof(*mem_tmp), GFP_KERNEL);
 			if (!mem_tmp) {
-				err ("out of system memory\n");
+				pr_err("out of system memory\n");
 				retval = -ENOMEM;
 				goto error;
 			}
@@ -909,8 +950,9 @@ static int configure_bridge (struct pci_func **func_passed, u8 slotno)
 		}
 	}
 
-	debug ("b4 if (flag_io && flag_mem && flag_pfmem)\n");
-	debug ("flag_io = %x, flag_mem = %x, flag_pfmem = %x\n", flag_io, flag_mem, flag_pfmem);
+	debug("b4 if (flag_io && flag_mem && flag_pfmem)\n");
+	debug("flag_io = %x, flag_mem = %x, flag_pfmem = %x\n",
+	      flag_io, flag_mem, flag_pfmem);
 
 	if (flag_io && flag_mem && flag_pfmem) {
 		/* If on bootup, there was a bridged card in this slot,
@@ -922,17 +964,17 @@ static int configure_bridge (struct pci_func **func_passed, u8 slotno)
 		if (!bus) {
 			bus = kzalloc(sizeof(*bus), GFP_KERNEL);
 			if (!bus) {
-				err ("out of system memory\n");
+				pr_err("out of system memory\n");
 				retval = -ENOMEM;
 				goto error;
 			}
 			bus->busno = sec_number;
-			debug ("b4 adding new bus\n");
+			debug("b4 adding new bus\n");
 			rc = add_new_bus (bus, io, mem, pfmem, func->busno);
 		} else if (!(bus->rangeIO) && !(bus->rangeMem) && !(bus->rangePFMem))
 			rc = add_new_bus (bus, io, mem, pfmem, 0xFF);
 		else {
-			err ("expected bus structure not empty?\n");
+			pr_err("expected bus structure not empty?\n");
 			retval = -EIO;
 			goto error;
 		}
@@ -949,11 +991,11 @@ static int configure_bridge (struct pci_func **func_passed, u8 slotno)
 		pci_bus_read_config_word (ibmphp_pci_bus, devfn, PCI_PREF_MEMORY_BASE, &pfmem_base);
 
 		if ((io_base & PCI_IO_RANGE_TYPE_MASK) == PCI_IO_RANGE_TYPE_32) {
-			debug ("io 32\n");
+			debug("io 32\n");
 			need_io_upper = 1;
 		}
 		if ((pfmem_base & PCI_PREF_RANGE_TYPE_MASK) == PCI_PREF_RANGE_TYPE_64) {
-			debug ("pfmem 64\n");
+			debug("pfmem 64\n");
 			need_pfmem_upper = 1;
 		}
 
@@ -963,9 +1005,11 @@ static int configure_bridge (struct pci_func **func_passed, u8 slotno)
 
 			/* _______________This is for debugging purposes only ____________________
 			pci_bus_read_config_byte (ibmphp_pci_bus, devfn, PCI_IO_BASE, &temp);
-			debug ("io_base = %x\n", (temp & PCI_IO_RANGE_TYPE_MASK) << 8);
+			debug("io_base = %x\n",
+			      (temp & PCI_IO_RANGE_TYPE_MASK) << 8);
 			pci_bus_read_config_byte (ibmphp_pci_bus, devfn, PCI_IO_LIMIT, &temp);
-			debug ("io_limit = %x\n", (temp & PCI_IO_RANGE_TYPE_MASK) << 8);
+			debug("io_limit = %x\n",
+			      (temp & PCI_IO_RANGE_TYPE_MASK) << 8);
 			 ________________________________________________________________________*/
 
 			if (need_io_upper) {	/* since can't support n.e.ways */
@@ -983,9 +1027,11 @@ static int configure_bridge (struct pci_func **func_passed, u8 slotno)
 			
 			/* ____________________This is for debugging purposes only ________________________
 			pci_bus_read_config_word (ibmphp_pci_bus, devfn, PCI_MEMORY_BASE, &temp);
-			debug ("mem_base = %x\n", (temp & PCI_MEMORY_RANGE_TYPE_MASK) << 16);
+			debug("mem_base = %x\n",
+			      (temp & PCI_MEMORY_RANGE_TYPE_MASK) << 16);
 			pci_bus_read_config_word (ibmphp_pci_bus, devfn, PCI_MEMORY_LIMIT, &temp);
-			debug ("mem_limit = %x\n", (temp & PCI_MEMORY_RANGE_TYPE_MASK) << 16);
+			debug("mem_limit = %x\n",
+			      (temp & PCI_MEMORY_RANGE_TYPE_MASK) << 16);
 			 __________________________________________________________________________________*/
 
 		} else {
@@ -998,9 +1044,11 @@ static int configure_bridge (struct pci_func **func_passed, u8 slotno)
 
 			/* __________________________This is for debugging purposes only _______________________
 			pci_bus_read_config_word (ibmphp_pci_bus, devfn, PCI_PREF_MEMORY_BASE, &temp);
-			debug ("pfmem_base = %x", (temp & PCI_MEMORY_RANGE_TYPE_MASK) << 16);
+			debug("pfmem_base = %x",
+			      (temp & PCI_MEMORY_RANGE_TYPE_MASK) << 16);
 			pci_bus_read_config_word (ibmphp_pci_bus, devfn, PCI_PREF_MEMORY_LIMIT, &temp);
-			debug ("pfmem_limit = %x\n", (temp & PCI_MEMORY_RANGE_TYPE_MASK) << 16);
+			debug("pfmem_limit = %x\n",
+			      (temp & PCI_MEMORY_RANGE_TYPE_MASK) << 16);
 			 ______________________________________________________________________________________*/
 
 			if (need_pfmem_upper) {	/* since can't support n.e.ways */
@@ -1012,7 +1060,7 @@ static int configure_bridge (struct pci_func **func_passed, u8 slotno)
 			pci_bus_write_config_word (ibmphp_pci_bus, devfn, PCI_PREF_MEMORY_LIMIT, 0x0000);
 		}
 
-		debug ("b4 writing control information\n");
+		debug("b4 writing control information\n");
 
 		pci_bus_read_config_byte (ibmphp_pci_bus, devfn, PCI_INTERRUPT_PIN, &irq);
 		if ((irq > 0x00) && (irq < 0x05))
@@ -1027,18 +1075,19 @@ static int configure_bridge (struct pci_func **func_passed, u8 slotno)
 		pci_bus_write_config_word (ibmphp_pci_bus, devfn, PCI_BRIDGE_CONTROL, 0x07);
 		for (i = 0; i < 32; i++) {
 			if (amount_needed->devices[i]) {
-				debug ("device where devices[i] is 1 = %x\n", i);
+				debug("device where devices[i] is 1 = %x\n", i);
 				func->devices[i] = 1;
 			}
 		}
 		func->bus = 1;	/* For unconfiguring, to indicate it's PPB */
 		func_passed = &func;
-		debug ("func->busno b4 returning is %x\n", func->busno);
-		debug ("func->busno b4 returning in the other structure is %x\n", (*func_passed)->busno);
+		debug("func->busno b4 returning is %x\n", func->busno);
+		debug("func->busno b4 returning in the other structure is %x\n",
+		      (*func_passed)->busno);
 		kfree (amount_needed);
 		return 0;
 	} else {
-		err ("Configuring bridge was unsuccessful...\n");
+		pr_err("Configuring bridge was unsuccessful...\n");
 		mem_tmp = NULL;
 		retval = -EIO;
 		goto error;
@@ -1100,8 +1149,8 @@ static struct res_needed *scan_behind_bridge (struct pci_func * func, u8 busno)
 
 	ibmphp_pci_bus->number = busno;
 
-	debug ("the bus_no behind the bridge is %x\n", busno);
-	debug ("scanning devices behind the bridge...\n");
+	debug("the bus_no behind the bridge is %x\n", busno);
+	debug("scanning devices behind the bridge...\n");
 	for (device = 0; device < 32; device++) {
 		amount->devices[device] = 0;
 		for (function = 0; function < 8; function++) {
@@ -1116,22 +1165,25 @@ static struct res_needed *scan_behind_bridge (struct pci_func * func, u8 busno)
 				pci_bus_read_config_byte (ibmphp_pci_bus, devfn, PCI_HEADER_TYPE, &hdr_type);
 				pci_bus_read_config_dword (ibmphp_pci_bus, devfn, PCI_CLASS_REVISION, &class);
 
-				debug ("hdr_type behind the bridge is %x\n", hdr_type);
+				debug("hdr_type behind the bridge is %x\n",
+				      hdr_type);
 				if (hdr_type & PCI_HEADER_TYPE_BRIDGE) {
-					err ("embedded bridges not supported for hot-plugging.\n");
+					pr_err("embedded bridges not supported for hot-plugging\n");
 					amount->not_correct = 1;
 					return amount;
 				}
 
 				class >>= 8;	/* to take revision out, class = class.subclass.prog i/f */
 				if (class == PCI_CLASS_NOT_DEFINED_VGA) {
-					err ("The device %x is VGA compatible and as is not supported for hot plugging. "
-					     "Please choose another device.\n", device);
+					pr_err("The device %x is VGA compatible and as is not supported for hot plugging. "
+					       "Please choose another device.\n",
+					       device);
 					amount->not_correct = 1;
 					return amount;
 				} else if (class == PCI_CLASS_DISPLAY_VGA) {
-					err ("The device %x is not supported for hot plugging. "
-					     "Please choose another device.\n", device);
+					pr_err("The device %x is not supported for hot plugging. "
+					       "Please choose another device.\n",
+					       device);
 					amount->not_correct = 1;
 					return amount;
 				}
@@ -1150,14 +1202,17 @@ static struct res_needed *scan_behind_bridge (struct pci_func * func, u8 busno)
 					pci_bus_write_config_dword (ibmphp_pci_bus, devfn, address[count], 0xFFFFFFFF);
 					pci_bus_read_config_dword (ibmphp_pci_bus, devfn, address[count], &bar[count]);
 
-					debug ("what is bar[count]? %x, count = %d\n", bar[count], count);
+					debug("what is bar[count]? %x, count = %d\n",
+					      bar[count], count);
 
 					if (!bar[count])	/* This BAR is not implemented */
 						continue;
 
 					//tmp_bar = bar[count];
 
-					debug ("count %d device %x function %x wants %x resources\n", count, device, function, bar[count]);
+					debug("count %d device %x function %x wants %x resources\n",
+					      count, device, function,
+					      bar[count]);
 
 					if (bar[count] & PCI_BASE_ADDRESS_SPACE_IO) {
 						/* This is IO */
@@ -1234,11 +1289,11 @@ static int unconfigure_boot_device (u8 busno, u8 device, u8 function)
 	u32 tmp_address;
 	unsigned int devfn;
 
-	debug ("%s - enter\n", __func__);
+	debug("%s: enter\n", __func__);
 
 	bus = ibmphp_find_res_bus (busno);
 	if (!bus) {
-		debug ("cannot find corresponding bus.\n");
+		debug("cannot find corresponding bus\n");
 		return -EINVAL;
 	}
 
@@ -1253,11 +1308,13 @@ static int unconfigure_boot_device (u8 busno, u8 device, u8 function)
 		pci_bus_read_config_dword (ibmphp_pci_bus, devfn, address[count], &size);
 		pci_bus_write_config_dword (ibmphp_pci_bus, devfn, address[count], start_address);
 
-		debug ("start_address is %x\n", start_address);
-		debug ("busno, device, function %x %x %x\n", busno, device, function);
+		debug("start_address is %x\n", start_address);
+		debug("busno, device, function %x %x %x\n",
+		      busno, device, function);
 		if (!size) {
 			/* This BAR is not implemented */
-			debug ("is this bar no implemented?, count = %d\n", count);
+			debug("is this bar not implemented?, count = %d\n",
+			      count);
 			continue;
 		}
 		tmp_address = start_address;
@@ -1268,20 +1325,20 @@ static int unconfigure_boot_device (u8 busno, u8 device, u8 function)
 			size = ~size + 1;
 			end_address = start_address + size - 1;
 			if (ibmphp_find_resource (bus, start_address, &io, IO) < 0) {
-				err ("cannot find corresponding IO resource to remove\n");
+				pr_err("cannot find corresponding IO resource to remove\n");
 				return -EIO;
 			}
-			debug ("io->start = %x\n", io->start);
+			debug("io->start = %x\n", io->start);
 			temp_end = io->end;
 			start_address = io->end + 1;
 			ibmphp_remove_resource (io);
 			/* This is needed b/c of the old I/O restrictions in the BIOS */
 			while (temp_end < end_address) {
 				if (ibmphp_find_resource (bus, start_address, &io, IO) < 0) {
-					err ("cannot find corresponding IO resource to remove\n");
+					pr_err("cannot find corresponding IO resource to remove\n");
 					return -EIO;
 				}
-				debug ("io->start = %x\n", io->start);
+				debug("io->start = %x\n", io->start);
 				temp_end = io->end;
 				start_address = io->end + 1;
 				ibmphp_remove_resource (io);
@@ -1292,29 +1349,32 @@ static int unconfigure_boot_device (u8 busno, u8 device, u8 function)
 			/* This is Memory */
 			if (start_address & PCI_BASE_ADDRESS_MEM_PREFETCH) {
 				/* pfmem */
-				debug ("start address of pfmem is %x\n", start_address);
+				debug("start address of pfmem is %x\n",
+				      start_address);
 				start_address &= PCI_BASE_ADDRESS_MEM_MASK;
 
 				if (ibmphp_find_resource (bus, start_address, &pfmem, PFMEM) < 0) {
-					err ("cannot find corresponding PFMEM resource to remove\n");
+					pr_err("cannot find corresponding PFMEM resource to remove\n");
 					return -EIO;
 				}
 				if (pfmem) {
-					debug ("pfmem->start = %x\n", pfmem->start);
+					debug("pfmem->start = %x\n",
+					      pfmem->start);
 
 					ibmphp_remove_resource(pfmem);
 				}
 			} else {
 				/* regular memory */
-				debug ("start address of mem is %x\n", start_address);
+				debug("start address of mem is %x\n",
+				      start_address);
 				start_address &= PCI_BASE_ADDRESS_MEM_MASK;
 
 				if (ibmphp_find_resource (bus, start_address, &mem, MEM) < 0) {
-					err ("cannot find corresponding MEM resource to remove\n");
+					pr_err("cannot find corresponding MEM resource to remove\n");
 					return -EIO;
 				}
 				if (mem) {
-					debug ("mem->start = %x\n", mem->start);
+					debug("mem->start = %x\n", mem->start);
 
 					ibmphp_remove_resource(mem);
 				}
@@ -1349,30 +1409,31 @@ static int unconfigure_boot_bridge (u8 busno, u8 device, u8 function)
 	devfn = PCI_DEVFN(device, function);
 	ibmphp_pci_bus->number = busno;
 	bus_no = (int) busno;
-	debug ("busno is %x\n", busno);
+	debug("busno is %x\n", busno);
 	pci_bus_read_config_byte (ibmphp_pci_bus, devfn, PCI_PRIMARY_BUS, &pri_number);
-	debug ("%s - busno = %x, primary_number = %x\n", __func__, busno, pri_number);
+	debug("%s: busno = %x, primary_number = %x\n",
+	      __func__, busno, pri_number);
 
 	pci_bus_read_config_byte (ibmphp_pci_bus, devfn, PCI_SECONDARY_BUS, &sec_number);
-	debug ("sec_number is %x\n", sec_number);
+	debug("sec_number is %x\n", sec_number);
 	sec_no = (int) sec_number;
 	pri_no = (int) pri_number;
 	if (pri_no != bus_no) {
-		err ("primary numbers in our structures and pci config space don't match.\n");
+		pr_err("primary numbers in our structures and pci config space don't match\n");
 		return -EINVAL;
 	}
 
 	pci_bus_read_config_byte (ibmphp_pci_bus, devfn, PCI_SUBORDINATE_BUS, &sub_number);
 	sub_no = (int) sub_number;
-	debug ("sub_no is %d, sec_no is %d\n", sub_no, sec_no);
+	debug("sub_no is %d, sec_no is %d\n", sub_no, sec_no);
 	if (sec_no != sub_number) {
-		err ("there're more buses behind this bridge.  Hot removal is not supported.  Please choose another card\n");
+		pr_err("there're more buses behind this bridge.  Hot removal is not supported.  Please choose another card\n");
 		return -ENODEV;
 	}
 
 	bus = ibmphp_find_res_bus (sec_number);
 	if (!bus) {
-		err ("cannot find Bus structure for the bridged device\n");
+		pr_err("cannot find Bus structure for the bridged device\n");
 		return -EINVAL;
 	}
 	debug("bus->busno is %x\n", bus->busno);
@@ -1395,11 +1456,11 @@ static int unconfigure_boot_bridge (u8 busno, u8 device, u8 function)
 			/* This is IO */
 			start_address &= PCI_BASE_ADDRESS_IO_MASK;
 			if (ibmphp_find_resource (bus, start_address, &io, IO) < 0) {
-				err ("cannot find corresponding IO resource to remove\n");
+				pr_err("cannot find corresponding IO resource to remove\n");
 				return -EIO;
 			}
 			if (io)
-				debug ("io->start = %x\n", io->start);
+				debug("io->start = %x\n", io->start);
 
 			ibmphp_remove_resource (io);
 
@@ -1410,11 +1471,12 @@ static int unconfigure_boot_bridge (u8 busno, u8 device, u8 function)
 				/* pfmem */
 				start_address &= PCI_BASE_ADDRESS_MEM_MASK;
 				if (ibmphp_find_resource (bus, start_address, &pfmem, PFMEM) < 0) {
-					err ("cannot find corresponding PFMEM resource to remove\n");
+					pr_err("cannot find corresponding PFMEM resource to remove\n");
 					return -EINVAL;
 				}
 				if (pfmem) {
-					debug ("pfmem->start = %x\n", pfmem->start);
+					debug("pfmem->start = %x\n",
+					      pfmem->start);
 
 					ibmphp_remove_resource(pfmem);
 				}
@@ -1422,11 +1484,11 @@ static int unconfigure_boot_bridge (u8 busno, u8 device, u8 function)
 				/* regular memory */
 				start_address &= PCI_BASE_ADDRESS_MEM_MASK;
 				if (ibmphp_find_resource (bus, start_address, &mem, MEM) < 0) {
-					err ("cannot find corresponding MEM resource to remove\n");
+					pr_err("cannot find corresponding MEM resource to remove\n");
 					return -EINVAL;
 				}
 				if (mem) {
-					debug ("mem->start = %x\n", mem->start);
+					debug("mem->start = %x\n", mem->start);
 
 					ibmphp_remove_resource(mem);
 				}
@@ -1437,7 +1499,7 @@ static int unconfigure_boot_bridge (u8 busno, u8 device, u8 function)
 			}
 		}	/* end of mem */
 	}	/* end of for */
-	debug ("%s - exiting, returning success\n", __func__);
+	debug("%s: exiting, returning success\n", __func__);
 	return 0;
 }
 
@@ -1453,12 +1515,12 @@ static int unconfigure_boot_card (struct slot *slot_cur)
 	unsigned int devfn;
 	u8 valid_device = 0x00; /* To see if we are ever able to find valid device and read it */
 
-	debug ("%s - enter\n", __func__);
+	debug("%s: enter\n", __func__);
 
 	device = slot_cur->device;
 	busno = slot_cur->bus;
 
-	debug ("b4 for loop, device is %x\n", device);
+	debug("b4 for loop, device is %x\n", device);
 	/* For every function on the card */
 	for (function = 0x0; function < 0x08; function++) {
 		devfn = PCI_DEVFN(device, function);
@@ -1470,7 +1532,7 @@ static int unconfigure_boot_card (struct slot *slot_cur)
 			/* found correct device!!! */
 			++valid_device;
 
-			debug ("%s - found correct device\n", __func__);
+			debug("%s: found correct device\n", __func__);
 
 			/* header: x x x x x x x x
 			 *         | |___________|=> 1=PPB bridge, 0=normal device, 2=CardBus Bridge
@@ -1480,15 +1542,17 @@ static int unconfigure_boot_card (struct slot *slot_cur)
 			pci_bus_read_config_byte (ibmphp_pci_bus, devfn, PCI_HEADER_TYPE, &hdr_type);
 			pci_bus_read_config_dword (ibmphp_pci_bus, devfn, PCI_CLASS_REVISION, &class);
 
-			debug ("hdr_type %x, class %x\n", hdr_type, class);
+			debug("hdr_type %x, class %x\n", hdr_type, class);
 			class >>= 8;	/* to take revision out, class = class.subclass.prog i/f */
 			if (class == PCI_CLASS_NOT_DEFINED_VGA) {
-				err ("The device %x function %x is VGA compatible and is not supported for hot removing. "
-				     "Please choose another device.\n", device, function);
+				pr_err("The device %x function %x is VGA compatible and is not supported for hot removing. "
+				       "Please choose another device.\n",
+				       device, function);
 				return -ENODEV;
 			} else if (class == PCI_CLASS_DISPLAY_VGA) {
-				err ("The device %x function %x is not supported for hot removing. "
-				     "Please choose another device.\n", device, function);
+				pr_err("The device %x function %x is not supported for hot removing. "
+				       "Please choose another device.\n",
+				       device, function);
 				return -ENODEV;
 			}
 
@@ -1496,8 +1560,8 @@ static int unconfigure_boot_card (struct slot *slot_cur)
 				case PCI_HEADER_TYPE_NORMAL:
 					rc = unconfigure_boot_device (busno, device, function);
 					if (rc) {
-						err ("was not able to unconfigure device %x func %x on bus %x. bailing out...\n",
-						     device, function, busno);
+						pr_err("was not able to unconfigure device %x func %x on bus %x. bailing out...\n",
+						       device, function, busno);
 						return rc;
 					}
 					function = 0x8;
@@ -1505,22 +1569,23 @@ static int unconfigure_boot_card (struct slot *slot_cur)
 				case PCI_HEADER_TYPE_MULTIDEVICE:
 					rc = unconfigure_boot_device (busno, device, function);
 					if (rc) {
-						err ("was not able to unconfigure device %x func %x on bus %x. bailing out...\n",
-						     device, function, busno);
+						pr_err("was not able to unconfigure device %x func %x on bus %x. bailing out...\n",
+						       device, function, busno);
 						return rc;
 					}
 					break;
 				case PCI_HEADER_TYPE_BRIDGE:
 					class >>= 8;
 					if (class != PCI_CLASS_BRIDGE_PCI) {
-						err ("This device %x function %x is not PCI-to-PCI bridge, "
-						     "and is not supported for hot-removing. "
-						     "Please try another card.\n", device, function);
+						pr_err("This device %x function %x is not PCI-to-PCI bridge, "
+						       "and is not supported for hot-removing. "
+						       "Please try another card.\n",
+						       device, function);
 						return -ENODEV;
 					}
 					rc = unconfigure_boot_bridge (busno, device, function);
 					if (rc != 0) {
-						err ("was not able to hot-remove PPB properly.\n");
+						pr_err("was not able to hot-remove PPB properly\n");
 						return rc;
 					}
 
@@ -1529,19 +1594,20 @@ static int unconfigure_boot_card (struct slot *slot_cur)
 				case PCI_HEADER_TYPE_MULTIBRIDGE:
 					class >>= 8;
 					if (class != PCI_CLASS_BRIDGE_PCI) {
-						err ("This device %x function %x is not PCI-to-PCI bridge, "
-						     "and is not supported for hot-removing. "
-						     "Please try another card.\n", device, function);
+						pr_err("This device %x function %x is not PCI-to-PCI bridge, "
+						       "and is not supported for hot-removing. "
+						       "Please try another card.\n",
+						       device, function);
 						return -ENODEV;
 					}
 					rc = unconfigure_boot_bridge (busno, device, function);
 					if (rc != 0) {
-						err ("was not able to hot-remove PPB properly.\n");
+						pr_err("was not able to hot-remove PPB properly\n");
 						return rc;
 					}
 					break;
 				default:
-					err ("MAJOR PROBLEM!!!! Cannot read device's header\n");
+					pr_err("MAJOR PROBLEM!!!! Cannot read device's header\n");
 					return -1;
 					break;
 			}	/* end of switch */
@@ -1549,7 +1615,7 @@ static int unconfigure_boot_card (struct slot *slot_cur)
 	}	/* end of for */
 
 	if (!valid_device) {
-		err ("Could not find device to unconfigure.  Or could not read the card.\n");
+		pr_err("Could not find device to unconfigure.  Or could not read the card.\n");
 		return -1;
 	}
 	return 0;
@@ -1573,7 +1639,7 @@ int ibmphp_unconfigure_card (struct slot **slot_cur, int the_end)
 	struct pci_func *cur_func = NULL;
 	struct pci_func *temp_func;
 
-	debug ("%s - enter\n", __func__);
+	debug("%s: enter\n", __func__);
 
 	if (!the_end) {
 		/* Need to unconfigure the card */
@@ -1597,19 +1663,19 @@ int ibmphp_unconfigure_card (struct slot **slot_cur, int the_end)
 
 			for (i = 0; i < count; i++) {
 				if (cur_func->io[i]) {
-					debug ("io[%d] exists\n", i);
+					debug("io[%d] exists\n", i);
 					if (the_end > 0)
 						ibmphp_remove_resource (cur_func->io[i]);
 					cur_func->io[i] = NULL;
 				}
 				if (cur_func->mem[i]) {
-					debug ("mem[%d] exists\n", i);
+					debug("mem[%d] exists\n", i);
 					if (the_end > 0)
 						ibmphp_remove_resource (cur_func->mem[i]);
 					cur_func->mem[i] = NULL;
 				}
 				if (cur_func->pfmem[i]) {
-					debug ("pfmem[%d] exists\n", i);
+					debug("pfmem[%d] exists\n", i);
 					if (the_end > 0)
 						ibmphp_remove_resource (cur_func->pfmem[i]);
 					cur_func->pfmem[i] = NULL;
@@ -1624,7 +1690,7 @@ int ibmphp_unconfigure_card (struct slot **slot_cur, int the_end)
 
 	sl->func = NULL;
 	*slot_cur = sl;
-	debug ("%s - exit\n", __func__);
+	debug("%s: exit\n", __func__);
 	return 0;
 }
 
@@ -1647,7 +1713,7 @@ static int add_new_bus (struct bus_node *bus, struct resource_node *io, struct r
 	if (parent_busno != 0xFF) {
 		cur_bus	= ibmphp_find_res_bus (parent_busno);
 		if (!cur_bus) {
-			err ("strange, cannot find bus which is supposed to be at the system... something is terribly wrong...\n");
+			pr_err("strange, cannot find bus which is supposed to be at the system... something is terribly wrong...\n");
 			return -ENODEV;
 		}
 	
@@ -1656,7 +1722,7 @@ static int add_new_bus (struct bus_node *bus, struct resource_node *io, struct r
 	if (io) {
 		io_range = kzalloc(sizeof(*io_range), GFP_KERNEL);
 		if (!io_range) {
-			err ("out of system memory\n");
+			pr_err("out of system memory\n");
 			return -ENOMEM;
 		}
 		io_range->start = io->start;
@@ -1668,7 +1734,7 @@ static int add_new_bus (struct bus_node *bus, struct resource_node *io, struct r
 	if (mem) {
 		mem_range = kzalloc(sizeof(*mem_range), GFP_KERNEL);
 		if (!mem_range) {
-			err ("out of system memory\n");
+			pr_err("out of system memory\n");
 			return -ENOMEM;
 		}
 		mem_range->start = mem->start;
@@ -1680,7 +1746,7 @@ static int add_new_bus (struct bus_node *bus, struct resource_node *io, struct r
 	if (pfmem) {
 		pfmem_range = kzalloc(sizeof(*pfmem_range), GFP_KERNEL);
 		if (!pfmem_range) {	
-			err ("out of system memory\n");
+			pr_err("out of system memory\n");
 			return -ENOMEM;
 		}
 		pfmem_range->start = pfmem->start;
@@ -1706,13 +1772,13 @@ static u8 find_sec_number (u8 primary_busno, u8 slotno)
 
 	bus = ibmphp_find_same_bus_num (primary_busno);
 	if (!bus) {
-		err ("cannot get slot range of the bus from the BIOS\n");
+		pr_err("cannot get slot range of the bus from the BIOS\n");
 		return 0xff;
 	}
 	max = bus->slot_max;
 	min = bus->slot_min;
 	if ((slotno > max) || (slotno < min)) {
-		err ("got the wrong range\n");
+		pr_err("got the wrong range\n");
 		return 0xff;
 	}
 	busno = (u8) (slotno - (u8) min);
diff --git a/drivers/pci/hotplug/ibmphp_res.c b/drivers/pci/hotplug/ibmphp_res.c
index e2dc289..dcd2df4 100644
--- a/drivers/pci/hotplug/ibmphp_res.c
+++ b/drivers/pci/hotplug/ibmphp_res.c
@@ -27,6 +27,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/pci.h>
@@ -51,13 +53,13 @@ static struct bus_node * __init alloc_error_bus (struct ebda_pci_rsrc * curr, u8
 	struct bus_node * newbus;
 
 	if (!(curr) && !(flag)) {
-		err ("NULL pointer passed\n");
+		pr_err("NULL pointer passed\n");
 		return NULL;
 	}
 
 	newbus = kzalloc(sizeof(struct bus_node), GFP_KERNEL);
 	if (!newbus) {
-		err ("out of system memory\n");
+		pr_err("out of system memory\n");
 		return NULL;
 	}
 
@@ -74,13 +76,13 @@ static struct resource_node * __init alloc_resources (struct ebda_pci_rsrc * cur
 	struct resource_node *rs;
 	
 	if (!curr) {
-		err ("NULL passed to allocate\n");
+		pr_err("NULL passed to allocate\n");
 		return NULL;
 	}
 
 	rs = kzalloc(sizeof(struct resource_node), GFP_KERNEL);
 	if (!rs) {
-		err ("out of system memory\n");
+		pr_err("out of system memory\n");
 		return NULL;
 	}
 	rs->busno = curr->bus_num;
@@ -100,7 +102,7 @@ static int __init alloc_bus_range (struct bus_node **new_bus, struct range_node
 	if (first_bus) {
 		newbus = kzalloc(sizeof(struct bus_node), GFP_KERNEL);
 		if (!newbus) {
-			err ("out of system memory.\n");
+			pr_err("out of system memory\n");
 			return -ENOMEM;
 		}
 		newbus->busno = curr->bus_num;
@@ -123,7 +125,7 @@ static int __init alloc_bus_range (struct bus_node **new_bus, struct range_node
 	if (!newrange) {
 		if (first_bus)
 			kfree (newbus);
-		err ("out of system memory\n");
+		pr_err("out of system memory\n");
 		return -ENOMEM;
 	}
 	newrange->start = curr->start_addr;
@@ -134,7 +136,8 @@ static int __init alloc_bus_range (struct bus_node **new_bus, struct range_node
 	else {
 		/* need to insert our range */
 		add_bus_range (flag, newrange, newbus);
-		debug ("%d resource Primary Bus inserted on bus %x [%x - %x]\n", flag, newbus->busno, newrange->start, newrange->end);
+		debug("%d resource Primary Bus inserted on bus %x [%x - %x]\n",
+		      flag, newbus->busno, newrange->start, newrange->end);
 	}
 
 	switch (flag) {
@@ -143,7 +146,9 @@ static int __init alloc_bus_range (struct bus_node **new_bus, struct range_node
 			if (first_bus)
 				newbus->noMemRanges = 1;
 			else {
-				debug ("First Memory Primary on bus %x, [%x - %x]\n", newbus->busno, newrange->start, newrange->end);
+				debug("First Memory Primary on bus %x, [%x - %x]\n",
+				      newbus->busno,
+				      newrange->start, newrange->end);
 				++newbus->noMemRanges;
 				fix_resources (newbus);
 			}
@@ -153,7 +158,9 @@ static int __init alloc_bus_range (struct bus_node **new_bus, struct range_node
 			if (first_bus)
 				newbus->noIORanges = 1;
 			else {
-				debug ("First IO Primary on bus %x, [%x - %x]\n", newbus->busno, newrange->start, newrange->end);
+				debug("First IO Primary on bus %x, [%x - %x]\n",
+				      newbus->busno,
+				      newrange->start, newrange->end);
 				++newbus->noIORanges;
 				fix_resources (newbus);
 			}
@@ -163,7 +170,9 @@ static int __init alloc_bus_range (struct bus_node **new_bus, struct range_node
 			if (first_bus)
 				newbus->noPFMemRanges = 1;
 			else {	
-				debug ("1st PFMemory Primary on Bus %x [%x - %x]\n", newbus->busno, newrange->start, newrange->end);
+				debug("1st PFMemory Primary on Bus %x [%x - %x]\n",
+				      newbus->busno,
+				      newrange->start, newrange->end);
 				++newbus->noPFMemRanges;
 				fix_resources (newbus);
 			}
@@ -214,7 +223,7 @@ int __init ibmphp_rsrc_init (void)
 		curr = list_entry (tmp_ebda, struct ebda_pci_rsrc, ebda_pci_rsrc_list);
 		if (!(curr->rsrc_type & PCIDEVMASK)) {
 			/* EBDA still lists non PCI devices, so ignore... */
-			debug ("this is not a PCI DEVICE in rsrc_init, please take care\n");
+			debug("this is not a PCI DEVICE in rsrc_init, please take care\n");
 			// continue;
 		}
 
@@ -227,7 +236,9 @@ int __init ibmphp_rsrc_init (void)
 					if ((rc = alloc_bus_range (&newbus, &newrange, curr, MEM, 1)))
 						return rc;
 					list_add_tail (&newbus->bus_list, &gbuses);
-					debug ("gbuses = NULL, Memory Primary Bus %x [%x - %x]\n", newbus->busno, newrange->start, newrange->end);
+					debug("gbuses = NULL, Memory Primary Bus %x [%x - %x]\n",
+					      newbus->busno,
+					      newrange->start, newrange->end);
 				} else {
 					bus_cur = find_bus_wprev (curr->bus_num, &bus_prev, 1);
 					/* found our bus */
@@ -241,7 +252,10 @@ int __init ibmphp_rsrc_init (void)
 							return rc;
 
 						list_add_tail (&newbus->bus_list, &gbuses);
-						debug ("New Bus, Memory Primary Bus %x [%x - %x]\n", newbus->busno, newrange->start, newrange->end);
+						debug("New Bus, Memory Primary Bus %x [%x - %x]\n",
+						      newbus->busno,
+						      newrange->start,
+						      newrange->end);
 					}
 				}
 			} else if ((curr->rsrc_type & RESTYPE) == PFMASK) {
@@ -251,7 +265,9 @@ int __init ibmphp_rsrc_init (void)
 					if ((rc = alloc_bus_range (&newbus, &newrange, curr, PFMEM, 1)))
 						return rc;
 					list_add_tail (&newbus->bus_list, &gbuses);
-					debug ("gbuses = NULL, PFMemory Primary Bus %x [%x - %x]\n", newbus->busno, newrange->start, newrange->end);
+					debug("gbuses = NULL, PFMemory Primary Bus %x [%x - %x]\n",
+					      newbus->busno,
+					      newrange->start, newrange->end);
 				} else {
 					bus_cur = find_bus_wprev (curr->bus_num, &bus_prev, 1);
 					if (bus_cur) {
@@ -264,7 +280,10 @@ int __init ibmphp_rsrc_init (void)
 						if ((rc = alloc_bus_range (&newbus, &newrange, curr, PFMEM, 1)))
 							return rc;
 						list_add_tail (&newbus->bus_list, &gbuses);
-						debug ("1st Bus, PFMemory Primary Bus %x [%x - %x]\n", newbus->busno, newrange->start, newrange->end);
+						debug("1st Bus, PFMemory Primary Bus %x [%x - %x]\n",
+						      newbus->busno,
+						      newrange->start,
+						      newrange->end);
 					}
 				}
 			} else if ((curr->rsrc_type & RESTYPE) == IOMASK) {
@@ -274,7 +293,9 @@ int __init ibmphp_rsrc_init (void)
 					if ((rc = alloc_bus_range (&newbus, &newrange, curr, IO, 1)))
 						return rc;
 					list_add_tail (&newbus->bus_list, &gbuses);
-					debug ("gbuses = NULL, IO Primary Bus %x [%x - %x]\n", newbus->busno, newrange->start, newrange->end);
+					debug("gbuses = NULL, IO Primary Bus %x [%x - %x]\n",
+					      newbus->busno,
+					      newrange->start, newrange->end);
 				} else {
 					bus_cur = find_bus_wprev (curr->bus_num, &bus_prev, 1);
 					if (bus_cur) {
@@ -286,7 +307,10 @@ int __init ibmphp_rsrc_init (void)
 						if ((rc = alloc_bus_range (&newbus, &newrange, curr, IO, 1)))
 							return rc;
 						list_add_tail (&newbus->bus_list, &gbuses);
-						debug ("1st Bus, IO Primary Bus %x [%x - %x]\n", newbus->busno, newrange->start, newrange->end);
+						debug("1st Bus, IO Primary Bus %x [%x - %x]\n",
+						      newbus->busno,
+						      newrange->start,
+						      newrange->end);
 					}
 				}
 
@@ -317,7 +341,9 @@ int __init ibmphp_rsrc_init (void)
 					++newbus->needMemUpdate;
 					new_mem->rangeno = -1;
 				}
-				debug ("Memory resource for device %x, bus %x, [%x - %x]\n", new_mem->devfunc, new_mem->busno, new_mem->start, new_mem->end);
+				debug("Memory resource for device %x, bus %x, [%x - %x]\n",
+				      new_mem->devfunc, new_mem->busno,
+				      new_mem->start, new_mem->end);
 
 			} else if ((curr->rsrc_type & RESTYPE) == PFMASK) {
 				/* PFMemory resource */
@@ -335,7 +361,9 @@ int __init ibmphp_rsrc_init (void)
 					new_pfmem->rangeno = -1;
 				}
 
-				debug ("PFMemory resource for device %x, bus %x, [%x - %x]\n", new_pfmem->devfunc, new_pfmem->busno, new_pfmem->start, new_pfmem->end);
+				debug("PFMemory resource for device %x, bus %x, [%x - %x]\n",
+				      new_pfmem->devfunc, new_pfmem->busno,
+				      new_pfmem->start, new_pfmem->end);
 			} else if ((curr->rsrc_type & RESTYPE) == IOMASK) {
 				/* IO resource */
 				new_io = alloc_resources (curr);
@@ -358,7 +386,9 @@ int __init ibmphp_rsrc_init (void)
 					++newbus->needIOUpdate;
 					new_io->rangeno = -1;
 				}
-				debug ("IO resource for device %x, bus %x, [%x - %x]\n", new_io->devfunc, new_io->busno, new_io->start, new_io->end);
+				debug("IO resource for device %x, bus %x, [%x - %x]\n",
+				      new_io->devfunc, new_io->busno,
+				      new_io->start, new_io->end);
 			}
 		}
 	}
@@ -523,7 +553,8 @@ static void fix_me (struct resource_node *res, struct bus_node *bus_cur, struct
 			while (range) {
 				if ((res->start >= range->start) && (res->end <= range->end)) {
 					res->rangeno = range->rangeno;
-					debug ("%s->rangeno in fix_resources is %d\n", str, res->rangeno);
+					debug("%s->rangeno in fix_resources is %d\n",
+					      str, res->rangeno);
 					switch (res->type) {
 						case IO:
 							--bus_cur->needIOUpdate;
@@ -563,7 +594,7 @@ static void fix_resources (struct bus_node *bus_cur)
 	struct range_node *range;
 	struct resource_node *res;
 
-	debug ("%s - bus_cur->busno = %d\n", __func__, bus_cur->busno);
+	debug("%s: bus_cur->busno = %d\n", __func__, bus_cur->busno);
 
 	if (bus_cur->needIOUpdate) {
 		res = bus_cur->firstIO;
@@ -599,10 +630,10 @@ int ibmphp_add_resource (struct resource_node *res)
 	struct range_node *range_cur = NULL;
 	struct resource_node *res_start = NULL;
 
-	debug ("%s - enter\n", __func__);
+	debug("%s: enter\n", __func__);
 
 	if (!res) {
-		err ("NULL passed to add\n");
+		pr_err("NULL passed to add\n");
 		return -ENODEV;
 	}
 	
@@ -610,7 +641,7 @@ int ibmphp_add_resource (struct resource_node *res)
 	
 	if (!bus_cur) {
 		/* didn't find a bus, smth's wrong!!! */
-		debug ("no bus in the system, either pci_dev's wrong or allocation failed\n");
+		debug("no bus in the system, either pci_dev's wrong or allocation failed\n");
 		return -ENODEV;
 	}
 
@@ -629,7 +660,7 @@ int ibmphp_add_resource (struct resource_node *res)
 			res_start = bus_cur->firstPFMem;
 			break;
 		default:
-			err ("cannot read the type of the resource to add... problem\n");
+			pr_err("cannot read the type of the resource to add... problem\n");
 			return -EINVAL;
 	}
 	while (range_cur) {
@@ -660,7 +691,7 @@ int ibmphp_add_resource (struct resource_node *res)
 		res->rangeno = -1;
 	}
 	
-	debug ("The range is %d\n", res->rangeno);
+	debug("The range is %d\n", res->rangeno);
 	if (!res_start) {
 		/* no first{IO,Mem,Pfmem} on the bus, 1st IO/Mem/Pfmem resource ever */
 		switch (res->type) {
@@ -680,7 +711,7 @@ int ibmphp_add_resource (struct resource_node *res)
 		res_cur = res_start;
 		res_prev = NULL;
 
-		debug ("res_cur->rangeno is %d\n", res_cur->rangeno);
+		debug("res_cur->rangeno is %d\n", res_cur->rangeno);
 
 		while (res_cur) {
 			if (res_cur->rangeno >= res->rangeno)
@@ -694,7 +725,8 @@ int ibmphp_add_resource (struct resource_node *res)
 
 		if (!res_cur) {
 			/* at the end of the resource list */
-			debug ("i should be here, [%x - %x]\n", res->start, res->end);
+			debug("i should be here, [%x - %x]\n",
+			      res->start, res->end);
 			res_prev->nextRange = res;
 			res->next = NULL;
 			res->nextRange = NULL;
@@ -762,7 +794,7 @@ int ibmphp_add_resource (struct resource_node *res)
 		}
 	}
 
-	debug ("%s - exit\n", __func__);
+	debug("%s: exit\n", __func__);
 	return 0;
 }
 
@@ -782,15 +814,14 @@ int ibmphp_remove_resource (struct resource_node *res)
 	char * type = "";
 
 	if (!res)  {
-		err ("resource to remove is NULL\n");
+		pr_err("resource to remove is NULL\n");
 		return -ENODEV;
 	}
 
 	bus_cur = find_bus_wprev (res->busno, NULL, 0);
 
 	if (!bus_cur) {
-		err ("cannot find corresponding bus of the io resource to remove  "
-			"bailing out...\n");
+		pr_err("cannot find corresponding bus of the io resource to remove - bailing out...\n");
 		return -ENODEV;
 	}
 
@@ -808,7 +839,7 @@ int ibmphp_remove_resource (struct resource_node *res)
 			type = "pfmem";
 			break;
 		default:
-			err ("unknown type for resource to remove\n");
+			pr_err("unknown type for resource to remove\n");
 			return -EINVAL;
 	}
 	res_prev = NULL;
@@ -846,7 +877,7 @@ int ibmphp_remove_resource (struct resource_node *res)
 							mem_cur = mem_cur->nextRange;
 					}
 					if (!mem_cur) {
-						err ("cannot find corresponding mem node for pfmem...\n");
+						pr_err("cannot find corresponding mem node for pfmem...\n");
 						return -EINVAL;
 					}
 
@@ -865,11 +896,12 @@ int ibmphp_remove_resource (struct resource_node *res)
 					res_cur = res_cur->nextRange;
 			}
 			if (!res_cur) {
-				err ("cannot find pfmem to delete...\n");
+				pr_err("cannot find pfmem to delete...\n");
 				return -EINVAL;
 			}
 		} else {
-			err ("the %s resource is not in the list to be deleted...\n", type);
+			pr_err("the %s resource is not in the list to be deleted...\n",
+			       type);
 			return -EINVAL;
 		}
 	}
@@ -949,7 +981,7 @@ static struct range_node * find_range (struct bus_node *bus_cur, struct resource
 			range = bus_cur->rangePFMem;
 			break;
 		default:
-			err ("cannot read resource type in find_range\n");
+			pr_err("cannot read resource type in find_range\n");
 	}
 
 	while (range) {
@@ -997,12 +1029,12 @@ int ibmphp_check_resource (struct resource_node *res, u8 bridge)
 
 	if (!bus_cur) {
 		/* didn't find a bus, smth's wrong!!! */
-		debug ("no bus in the system, either pci_dev's wrong or allocation failed\n");
+		debug("no bus in the system, either pci_dev's wrong or allocation failed\n");
 		return -EINVAL;
 	}
 
-	debug ("%s - enter\n", __func__);
-	debug ("bus_cur->busno is %d\n", bus_cur->busno);
+	debug("%s: enter\n", __func__);
+	debug("bus_cur->busno is %d\n", bus_cur->busno);
 
 	/* This is a quick fix to not mess up with the code very much.  i.e.,
 	 * 2000-2fff, len = 1000, but when we compare, we need it to be fff */
@@ -1022,17 +1054,17 @@ int ibmphp_check_resource (struct resource_node *res, u8 bridge)
 			noranges = bus_cur->noPFMemRanges;
 			break;
 		default:
-			err ("wrong type of resource to check\n");
+			pr_err("wrong type of resource to check\n");
 			return -EINVAL;
 	}
 	res_prev = NULL;
 
 	while (res_cur) {
 		range = find_range (bus_cur, res_cur);
-		debug ("%s - rangeno = %d\n", __func__, res_cur->rangeno);
+		debug("%s: rangeno = %d\n", __func__, res_cur->rangeno);
 
 		if (!range) {
-			err ("no range for the device exists... bailing out...\n");
+			pr_err("no range for the device exists... bailing out...\n");
 			return -EINVAL;
 		}
 
@@ -1040,7 +1072,7 @@ int ibmphp_check_resource (struct resource_node *res, u8 bridge)
 		if (!res_prev) {
 			/* first time in the loop */
 			if ((res_cur->start != range->start) && ((len_tmp = res_cur->start - 1 - range->start) >= res->len)) {
-				debug ("len_tmp = %x\n", len_tmp);
+				debug("len_tmp = %x\n", len_tmp);
 
 				if ((len_tmp < len_cur) || (len_cur == 0)) {
 
@@ -1068,7 +1100,7 @@ int ibmphp_check_resource (struct resource_node *res, u8 bridge)
 					}
 			
 					if (flag && len_cur == res->len) {
-						debug ("but we are not here, right?\n");
+						debug("but we are not here, right?\n");
 						res->start = start_cur;
 						res->len += 1; /* To restore the balance */
 						res->end = res->start + res->len - 1;
@@ -1080,7 +1112,7 @@ int ibmphp_check_resource (struct resource_node *res, u8 bridge)
 		if (!res_cur->next) {
 			/* last device on the range */
 			if ((range->end != res_cur->end) && ((len_tmp = range->end - (res_cur->end + 1)) >= res->len)) {
-				debug ("len_tmp = %x\n", len_tmp);
+				debug("len_tmp = %x\n", len_tmp);
 				if ((len_tmp < len_cur) || (len_cur == 0)) {
 
 					if (((res_cur->end + 1) % tmp_divide) == 0) {
@@ -1251,7 +1283,7 @@ int ibmphp_check_resource (struct resource_node *res, u8 bridge)
 
 		if ((!range) && (len_cur == 0)) {
 			/* have gone through the list of devices and ranges and haven't found n.e.thing */
-			err ("no appropriate range.. bailing out...\n");
+			pr_err("no appropriate range.. bailing out...\n");
 			return -EINVAL;
 		} else if (len_cur) {
 			res->start = start_cur;
@@ -1262,7 +1294,8 @@ int ibmphp_check_resource (struct resource_node *res, u8 bridge)
 	}
 
 	if (!res_cur) {
-		debug ("prev->rangeno = %d, noranges = %d\n", res_prev->rangeno, noranges);
+		debug("prev->rangeno = %d, noranges = %d\n",
+		      res_prev->rangeno, noranges);
 		if (res_prev->rangeno < noranges) {
 			/* if there're more ranges out there to check */
 			switch (res->type) {
@@ -1315,7 +1348,7 @@ int ibmphp_check_resource (struct resource_node *res, u8 bridge)
 
 			if ((!range) && (len_cur == 0)) {
 				/* have gone through the list of devices and ranges and haven't found n.e.thing */
-				err ("no appropriate range.. bailing out...\n");
+				pr_err("no appropriate range.. bailing out...\n");
 				return -EINVAL;
 			} else if (len_cur) {
 				res->start = start_cur;
@@ -1332,7 +1365,7 @@ int ibmphp_check_resource (struct resource_node *res, u8 bridge)
 				return 0;
 			} else {
 				/* have gone through the list of devices and haven't found n.e.thing */
-				err ("no appropriate range.. bailing out...\n");
+				pr_err("no appropriate range.. bailing out...\n");
 				return -EINVAL;
 			}
 		}
@@ -1356,11 +1389,12 @@ int ibmphp_remove_bus (struct bus_node *bus, u8 parent_busno)
 	prev_bus = find_bus_wprev (parent_busno, NULL, 0);	
 
 	if (!prev_bus) {
-		debug ("something terribly wrong. Cannot find parent bus to the one to remove\n");
+		debug("something terribly wrong. Cannot find parent bus to the one to remove\n");
 		return -ENODEV;
 	}
 
-	debug ("In ibmphp_remove_bus... prev_bus->busno is %x\n", prev_bus->busno);
+	debug("In ibmphp_remove_bus... prev_bus->busno is %x\n",
+	      prev_bus->busno);
 
 	rc = remove_ranges (bus, prev_bus);
 	if (rc)
@@ -1491,7 +1525,7 @@ int ibmphp_find_resource (struct bus_node *bus, u32 start_address, struct resour
 	char * type = "";
 
 	if (!bus) {
-		err ("The bus passed in NULL to find resource\n");
+		pr_err("The bus passed in NULL to find resource\n");
 		return -ENODEV;
 	}
 
@@ -1509,7 +1543,7 @@ int ibmphp_find_resource (struct bus_node *bus, u32 start_address, struct resour
 			type = "pfmem";
 			break;
 		default:
-			err ("wrong type of flag\n");
+			pr_err("wrong type of flag\n");
 			return -EINVAL;
 	}
 	
@@ -1535,17 +1569,19 @@ int ibmphp_find_resource (struct bus_node *bus, u32 start_address, struct resour
 				res_cur = res_cur->next;
 			}
 			if (!res_cur) {
-				debug ("SOS...cannot find %s resource in the bus.\n", type);
+				debug("SOS...cannot find %s resource in the bus\n",
+				      type);
 				return -EINVAL;
 			}
 		} else {
-			debug ("SOS... cannot find %s resource in the bus.\n", type);
+			debug("SOS... cannot find %s resource in the bus\n",
+			      type);
 			return -EINVAL;
 		}
 	}
 
 	if (*res)
-		debug ("*res->start = %x\n", (*res)->start);
+		debug("*res->start = %x\n", (*res)->start);
 
 	return 0;
 }
@@ -1703,7 +1739,7 @@ static int __init once_over (void)
 
 				mem = kzalloc(sizeof(struct resource_node), GFP_KERNEL);
 				if (!mem) {
-					err ("out of system memory\n");
+					pr_err("out of system memory\n");
 					return -ENOMEM;
 				}
 				mem->type = MEM;
@@ -1713,7 +1749,7 @@ static int __init once_over (void)
 				mem->end = pfmem_cur->end;
 				mem->len = pfmem_cur->len;
 				if (ibmphp_add_resource (mem) < 0)
-					err ("Trouble...trouble... EBDA allocated pfmem from mem, but system doesn't display it has this space... unless not PCI device...\n");
+					pr_err("Trouble...trouble... EBDA allocated pfmem from mem, but system doesn't display it has this space... unless not PCI device...\n");
 				pfmem_cur->rangeno = mem->rangeno;
 			}	/* end for pfmem */
 		}	/* end if */
@@ -1726,7 +1762,7 @@ int ibmphp_add_pfmem_from_mem (struct resource_node *pfmem)
 	struct bus_node *bus_cur = find_bus_wprev (pfmem->busno, NULL, 0);
 
 	if (!bus_cur) {
-		err ("cannot find bus of pfmem to add...\n");
+		pr_err("cannot find bus of pfmem to add...\n");
 		return -ENODEV;
 	}
 
@@ -1780,7 +1816,7 @@ void ibmphp_print_test (void)
 	debug_pci ("*****************START**********************\n");
 
 	if ((!list_empty(&gbuses)) && flags) {
-		err ("The GBUSES is not NULL?!?!?!?!?\n");
+		pr_err("The GBUSES is not NULL?!?!?!?!?\n");
 		return;
 	}
 
@@ -1897,7 +1933,7 @@ static int range_exists_already (struct range_node * range, struct bus_node * bu
 			range_cur = bus_cur->rangePFMem;
 			break;
 		default:
-			err ("wrong type passed to find out if range already exists\n");
+			pr_err("wrong type passed to find out if range already exists\n");
 			return -ENODEV;
 	}
 
@@ -1942,8 +1978,8 @@ static int __init update_bridge_ranges (struct bus_node **bus)
 		return -ENODEV;
 	ibmphp_pci_bus->number = bus_cur->busno;
 
-	debug ("inside %s\n", __func__);
-	debug ("bus_cur->busno = %x\n", bus_cur->busno);
+	debug("inside %s\n", __func__);
+	debug("bus_cur->busno = %x\n", bus_cur->busno);
 
 	for (device = 0; device < 32; device++) {
 		for (function = 0x00; function < 0x08; function++) {
@@ -1991,7 +2027,7 @@ static int __init update_bridge_ranges (struct bus_node **bus)
 						if ((start_address) && (start_address <= end_address)) {
 							range = kzalloc(sizeof(struct range_node), GFP_KERNEL);
 							if (!range) {
-								err ("out of system memory\n");
+								pr_err("out of system memory\n");
 								return -ENOMEM;
 							}
 							range->start = start_address;
@@ -2017,7 +2053,7 @@ static int __init update_bridge_ranges (struct bus_node **bus)
 								io = kzalloc(sizeof(struct resource_node), GFP_KERNEL);
 								if (!io) {
 									kfree (range);
-									err ("out of system memory\n");
+									pr_err("out of system memory\n");
 									return -ENOMEM;
 								}
 								io->type = IO;
@@ -2040,7 +2076,7 @@ static int __init update_bridge_ranges (struct bus_node **bus)
 
 							range = kzalloc(sizeof(struct range_node), GFP_KERNEL);
 							if (!range) {
-								err ("out of system memory\n");
+								pr_err("out of system memory\n");
 								return -ENOMEM;
 							}
 							range->start = start_address;
@@ -2067,7 +2103,7 @@ static int __init update_bridge_ranges (struct bus_node **bus)
 								mem = kzalloc(sizeof(struct resource_node), GFP_KERNEL);
 								if (!mem) {
 									kfree (range);
-									err ("out of system memory\n");
+									pr_err("out of system memory\n");
 									return -ENOMEM;
 								}
 								mem->type = MEM;
@@ -2094,7 +2130,7 @@ static int __init update_bridge_ranges (struct bus_node **bus)
 
 							range = kzalloc(sizeof(struct range_node), GFP_KERNEL);
 							if (!range) {
-								err ("out of system memory\n");
+								pr_err("out of system memory\n");
 								return -ENOMEM;
 							}
 							range->start = start_address;
@@ -2120,7 +2156,7 @@ static int __init update_bridge_ranges (struct bus_node **bus)
 								pfmem = kzalloc(sizeof(struct resource_node), GFP_KERNEL);
 								if (!pfmem) {
 									kfree (range);
-									err ("out of system memory\n");
+									pr_err("out of system memory\n");
 									return -ENOMEM;
 								}
 								pfmem->type = PFMEM;
diff --git a/drivers/pci/hotplug/pci_hotplug_core.c b/drivers/pci/hotplug/pci_hotplug_core.c
index 6d2eea9..7ff19fc 100644
--- a/drivers/pci/hotplug/pci_hotplug_core.c
+++ b/drivers/pci/hotplug/pci_hotplug_core.c
@@ -25,6 +25,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/kernel.h>
@@ -44,11 +46,11 @@
 
 #define MY_NAME	"pci_hotplug"
 
-#define dbg(fmt, arg...) do { if (debug) printk(KERN_DEBUG "%s: %s: " fmt , MY_NAME , __func__ , ## arg); } while (0)
-#define err(format, arg...) printk(KERN_ERR "%s: " format , MY_NAME , ## arg)
-#define info(format, arg...) printk(KERN_INFO "%s: " format , MY_NAME , ## arg)
-#define warn(format, arg...) printk(KERN_WARNING "%s: " format , MY_NAME , ## arg)
-
+#define dbg(fmt, arg...)				\
+do {							\
+	if (debug)					\
+		pr_debug("%s: " fmt, __func__, ##arg);	\
+} while (0)
 
 /* local variables */
 static int debug;
@@ -115,7 +117,7 @@ static ssize_t power_write_file(struct pci_slot *pci_slot, const char *buf,
 
 	lpower = simple_strtoul (buf, NULL, 10);
 	power = (u8)(lpower & 0xff);
-	dbg ("power = %d\n", power);
+	dbg("power = %d\n", power);
 
 	if (!try_module_get(slot->ops->owner)) {
 		retval = -ENODEV;
@@ -133,7 +135,7 @@ static ssize_t power_write_file(struct pci_slot *pci_slot, const char *buf,
 			break;
 
 		default:
-			err ("Illegal value specified for power\n");
+			pr_err("Illegal value specified for power\n");
 			retval = -EINVAL;
 	}
 	module_put(slot->ops->owner);
@@ -174,7 +176,7 @@ static ssize_t attention_write_file(struct pci_slot *slot, const char *buf,
 
 	lattention = simple_strtoul (buf, NULL, 10);
 	attention = (u8)(lattention & 0xff);
-	dbg (" - attention = %d\n", attention);
+	dbg(" - attention = %d\n", attention);
 
 	if (!try_module_get(ops->owner)) {
 		retval = -ENODEV;
@@ -244,7 +246,7 @@ static ssize_t test_write_file(struct pci_slot *pci_slot, const char *buf,
 
 	ltest = simple_strtoul (buf, NULL, 10);
 	test = (u32)(ltest & 0xffffffff);
-	dbg ("test = %d\n", test);
+	dbg("test = %d\n", test);
 
 	if (!try_module_get(slot->ops->owner)) {
 		retval = -ENODEV;
@@ -443,8 +445,7 @@ int __pci_hp_register(struct hotplug_slot *slot, struct pci_bus *bus,
 	if ((slot->info == NULL) || (slot->ops == NULL))
 		return -EINVAL;
 	if (slot->release == NULL) {
-		dbg("Why are you trying to register a hotplug slot "
-		    "without a proper release function?\n");
+		dbg("Why are you trying to register a hotplug slot without a proper release function?\n");
 		return -EINVAL;
 	}
 
@@ -543,11 +544,11 @@ static int __init pci_hotplug_init (void)
 
 	result = cpci_hotplug_init(debug);
 	if (result) {
-		err ("cpci_hotplug_init with error %d\n", result);
+		pr_err("cpci_hotplug_init with error %d\n", result);
 		goto err_cpci;
 	}
 
-	info (DRIVER_DESC " version: " DRIVER_VERSION "\n");
+	pr_info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
 
 err_cpci:
 	return result;
diff --git a/drivers/pci/hotplug/pciehp.h b/drivers/pci/hotplug/pciehp.h
index 838f571..7a5b74e 100644
--- a/drivers/pci/hotplug/pciehp.h
+++ b/drivers/pci/hotplug/pciehp.h
@@ -50,14 +50,8 @@ extern struct workqueue_struct *pciehp_ordered_wq;
 #define dbg(format, arg...)						\
 do {									\
 	if (pciehp_debug)						\
-		printk(KERN_DEBUG "%s: " format, MY_NAME , ## arg);	\
+		pr_debug(format, ##arg);				\
 } while (0)
-#define err(format, arg...)						\
-	printk(KERN_ERR "%s: " format, MY_NAME , ## arg)
-#define info(format, arg...)						\
-	printk(KERN_INFO "%s: " format, MY_NAME , ## arg)
-#define warn(format, arg...)						\
-	printk(KERN_WARNING "%s: " format, MY_NAME , ## arg)
 
 #define ctrl_dbg(ctrl, format, arg...)					\
 	do {								\
diff --git a/drivers/pci/hotplug/pciehp_acpi.c b/drivers/pci/hotplug/pciehp_acpi.c
index 5f72262..6486cfb 100644
--- a/drivers/pci/hotplug/pciehp_acpi.c
+++ b/drivers/pci/hotplug/pciehp_acpi.c
@@ -23,6 +23,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/acpi.h>
 #include <linux/pci.h>
 #include <linux/pci_hotplug.h>
@@ -68,8 +70,8 @@ static int __init parse_detect_mode(void)
 		return PCIEHP_DETECT_ACPI;
 	if (!strcmp(pciehp_detect_mode, "auto"))
 		return PCIEHP_DETECT_AUTO;
-	warn("bad specifier '%s' for pciehp_detect_mode. Use default\n",
-	     pciehp_detect_mode);
+	pr_warn("bad specifier '%s' for pciehp_detect_mode. Use default\n",
+		pciehp_detect_mode);
 	return PCIEHP_DETECT_DEFAULT;
 }
 
@@ -135,5 +137,5 @@ void __init pciehp_acpi_slot_detection_init(void)
 	slot_detection_mode = select_detection_mode();
 out:
 	if (slot_detection_mode == PCIEHP_DETECT_ACPI)
-		info("Using ACPI for slot detection.\n");
+		pr_info("Using ACPI for slot detection\n");
 }
diff --git a/drivers/pci/hotplug/pciehp_core.c b/drivers/pci/hotplug/pciehp_core.c
index 7ac8358..f29081c 100644
--- a/drivers/pci/hotplug/pciehp_core.c
+++ b/drivers/pci/hotplug/pciehp_core.c
@@ -27,6 +27,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/kernel.h>
@@ -353,9 +355,9 @@ static int __init pcied_init(void)
 
 	pciehp_firmware_init();
 	retval = pcie_port_service_register(&hpdriver_portdrv);
- 	dbg("pcie_port_service_register = %d\n", retval);
-  	info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
- 	if (retval) {
+	dbg("pcie_port_service_register = %d\n", retval);
+	pr_info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
+	if (retval) {
 		destroy_workqueue(pciehp_ordered_wq);
 		destroy_workqueue(pciehp_wq);
 		dbg("Failure to register service\n");
@@ -369,7 +371,7 @@ static void __exit pcied_cleanup(void)
 	destroy_workqueue(pciehp_ordered_wq);
 	destroy_workqueue(pciehp_wq);
 	pcie_port_service_unregister(&hpdriver_portdrv);
-	info(DRIVER_DESC " version: " DRIVER_VERSION " unloaded\n");
+	pr_info(DRIVER_DESC " version: " DRIVER_VERSION " unloaded\n");
 }
 
 module_init(pcied_init);
diff --git a/drivers/pci/hotplug/pciehp_ctrl.c b/drivers/pci/hotplug/pciehp_ctrl.c
index 085dbb5..eba2d74 100644
--- a/drivers/pci/hotplug/pciehp_ctrl.c
+++ b/drivers/pci/hotplug/pciehp_ctrl.c
@@ -363,13 +363,13 @@ static void handle_button_press_event(struct slot *p_slot)
 		if (getstatus) {
 			p_slot->state = BLINKINGOFF_STATE;
 			ctrl_info(ctrl,
-				  "PCI slot #%s - powering off due to button "
-				  "press.\n", slot_name(p_slot));
+				  "PCI slot #%s - powering off due to button press\n",
+				  slot_name(p_slot));
 		} else {
 			p_slot->state = BLINKINGON_STATE;
 			ctrl_info(ctrl,
-				  "PCI slot #%s - powering on due to button "
-				  "press.\n", slot_name(p_slot));
+				  "PCI slot #%s - powering on due to button press\n",
+				  slot_name(p_slot));
 		}
 		/* blink green LED and turn off amber */
 		if (PWR_LED(ctrl))
@@ -397,8 +397,8 @@ static void handle_button_press_event(struct slot *p_slot)
 		}
 		if (ATTN_LED(ctrl))
 			pciehp_set_attention_status(p_slot, 0);
-		ctrl_info(ctrl, "PCI slot #%s - action canceled "
-			  "due to button press\n", slot_name(p_slot));
+		ctrl_info(ctrl, "PCI slot #%s - action canceled due to button press\n",
+			  slot_name(p_slot));
 		p_slot->state = STATIC_STATE;
 		break;
 	case POWEROFF_STATE:
diff --git a/drivers/pci/hotplug/pciehp_pci.c b/drivers/pci/hotplug/pciehp_pci.c
index a4031df..f419b34 100644
--- a/drivers/pci/hotplug/pciehp_pci.c
+++ b/drivers/pci/hotplug/pciehp_pci.c
@@ -27,6 +27,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
@@ -45,8 +47,8 @@ static int __ref pciehp_add_bridge(struct pci_dev *dev)
 			break;
 	}
 	if (busnr-- > end) {
-		err("No bus number available for hot-added bridge %s\n",
-				pci_name(dev));
+		pr_err("No bus number available for hot-added bridge %s\n",
+		       pci_name(dev));
 		return -1;
 	}
 	for (pass = 0; pass < 2; pass++)
diff --git a/drivers/pci/hotplug/pcihp_skeleton.c b/drivers/pci/hotplug/pcihp_skeleton.c
index 5175d9b..f26b4ce 100644
--- a/drivers/pci/hotplug/pcihp_skeleton.c
+++ b/drivers/pci/hotplug/pcihp_skeleton.c
@@ -28,6 +28,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/kernel.h>
@@ -49,14 +51,10 @@ static LIST_HEAD(slot_list);
 #define MY_NAME	"pcihp_skeleton"
 
 #define dbg(format, arg...)					\
-	do {							\
-		if (debug)					\
-			printk (KERN_DEBUG "%s: " format "\n",	\
-				MY_NAME , ## arg); 		\
-	} while (0)
-#define err(format, arg...) printk(KERN_ERR "%s: " format "\n", MY_NAME , ## arg)
-#define info(format, arg...) printk(KERN_INFO "%s: " format "\n", MY_NAME , ## arg)
-#define warn(format, arg...) printk(KERN_WARNING "%s: " format "\n", MY_NAME , ## arg)
+do {								\
+	if (debug)						\
+		pr_debug(format, ##arg);			\
+} while (0)
 
 /* local variables */
 static int debug;
@@ -97,7 +95,7 @@ static int enable_slot(struct hotplug_slot *hotplug_slot)
 	struct slot *slot = hotplug_slot->private;
 	int retval = 0;
 
-	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
+	dbg("%s: physical_slot = %s\n", __func__, hotplug_slot->name);
 
 	/*
 	 * Fill in code here to enable the specified slot
@@ -111,7 +109,7 @@ static int disable_slot(struct hotplug_slot *hotplug_slot)
 	struct slot *slot = hotplug_slot->private;
 	int retval = 0;
 
-	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
+	dbg("%s: physical_slot = %s\n", __func__, hotplug_slot->name);
 
 	/*
 	 * Fill in code here to disable the specified slot
@@ -125,7 +123,7 @@ static int set_attention_status(struct hotplug_slot *hotplug_slot, u8 status)
 	struct slot *slot = hotplug_slot->private;
 	int retval = 0;
 
-	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
+	dbg("%s: physical_slot = %s\n", __func__, hotplug_slot->name);
 
 	switch (status) {
 		case 0:
@@ -150,7 +148,7 @@ static int hardware_test(struct hotplug_slot *hotplug_slot, u32 value)
 	struct slot *slot = hotplug_slot->private;
 	int retval = 0;
 
-	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
+	dbg("%s: physical_slot = %s\n", __func__, hotplug_slot->name);
 
 	switch (value) {
 		case 0:
@@ -169,7 +167,7 @@ static int get_power_status(struct hotplug_slot *hotplug_slot, u8 *value)
 	struct slot *slot = hotplug_slot->private;
 	int retval = 0;
 
-	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
+	dbg("%s: physical_slot = %s\n", __func__, hotplug_slot->name);
 
 	/*
 	 * Fill in logic to get the current power status of the specific
@@ -184,7 +182,7 @@ static int get_attention_status(struct hotplug_slot *hotplug_slot, u8 *value)
 	struct slot *slot = hotplug_slot->private;
 	int retval = 0;
 
-	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
+	dbg("%s: physical_slot = %s\n", __func__, hotplug_slot->name);
 
 	/*
 	 * Fill in logic to get the current attention status of the specific
@@ -199,7 +197,7 @@ static int get_latch_status(struct hotplug_slot *hotplug_slot, u8 *value)
 	struct slot *slot = hotplug_slot->private;
 	int retval = 0;
 
-	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
+	dbg("%s: physical_slot = %s\n", __func__, hotplug_slot->name);
 
 	/*
 	 * Fill in logic to get the current latch status of the specific
@@ -214,7 +212,7 @@ static int get_adapter_status(struct hotplug_slot *hotplug_slot, u8 *value)
 	struct slot *slot = hotplug_slot->private;
 	int retval = 0;
 
-	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
+	dbg("%s: physical_slot = %s\n", __func__, hotplug_slot->name);
 
 	/*
 	 * Fill in logic to get the current adapter status of the specific
@@ -228,7 +226,7 @@ static void release_slot(struct hotplug_slot *hotplug_slot)
 {
 	struct slot *slot = hotplug_slot->private;
 
-	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
+	dbg("%s: physical_slot = %s\n", __func__, hotplug_slot->name);
 	kfree(slot->hotplug_slot->info);
 	kfree(slot->hotplug_slot);
 	kfree(slot);
@@ -294,7 +292,8 @@ static int __init init_slots(void)
 		dbg("registering slot %d\n", i);
 		retval = pci_hp_register(slot->hotplug_slot);
 		if (retval) {
-			err("pci_hp_register failed with error %d\n", retval);
+			pr_err("pci_hp_register failed with error %d\n",
+			       retval);
 			goto error_info;
 		}
 
@@ -335,7 +334,7 @@ static int __init pcihp_skel_init(void)
 {
 	int retval;
 
-	info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
+	pr_info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
 	/*
 	 * Do specific initialization stuff for your driver here
 	 * like initializing your controller hardware (if any) and
diff --git a/drivers/pci/hotplug/rpadlpar_core.c b/drivers/pci/hotplug/rpadlpar_core.c
index 0830347..e6aea8a 100644
--- a/drivers/pci/hotplug/rpadlpar_core.c
+++ b/drivers/pci/hotplug/rpadlpar_core.c
@@ -15,6 +15,8 @@
  *      2 of the License, or (at your option) any later version.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #undef DEBUG
 
 #include <linux/init.h>
@@ -150,8 +152,8 @@ static void dlpar_pci_add_bus(struct device_node *dn)
 	/* Add EADS device to PHB bus, adding new entry to bus->devices */
 	dev = of_create_pci_dev(dn, phb->bus, pdn->devfn);
 	if (!dev) {
-		printk(KERN_ERR "%s: failed to create pci dev for %s\n",
-				__func__, dn->full_name);
+		pr_err("%s: failed to create pci dev for %s\n",
+		       __func__, dn->full_name);
 		return;
 	}
 
@@ -187,21 +189,20 @@ static int dlpar_add_pci_slot(char *drc_name, struct device_node *dn)
 	dev = dlpar_find_new_dev(phb->bus, dn);
 
 	if (!dev) {
-		printk(KERN_ERR "%s: unable to add bus %s\n", __func__,
-			drc_name);
+		pr_err("%s: unable to add bus %s\n", __func__, drc_name);
 		return -EIO;
 	}
 
 	if (dev->hdr_type != PCI_HEADER_TYPE_BRIDGE) {
-		printk(KERN_ERR "%s: unexpected header type %d, unable to add bus %s\n",
-			__func__, dev->hdr_type, drc_name);
+		pr_err("%s: unexpected header type %d, unable to add bus %s\n",
+		       __func__, dev->hdr_type, drc_name);
 		return -EIO;
 	}
 
 	/* Add hotplug slot */
 	if (rpaphp_add_slot(dn)) {
-		printk(KERN_ERR "%s: unable to add hotplug slot %s\n",
-			__func__, drc_name);
+		pr_err("%s: unable to add hotplug slot %s\n",
+		       __func__, drc_name);
 		return -EIO;
 	}
 	return 0;
@@ -219,7 +220,7 @@ static int dlpar_remove_phb(char *drc_name, struct device_node *dn)
 	/* If pci slot is hotplugable, use hotplug to remove it */
 	slot = find_php_slot(dn);
 	if (slot && rpaphp_deregister_slot(slot)) {
-		printk(KERN_ERR "%s: unable to remove hotplug slot %s\n",
+		pr_err("%s: unable to remove hotplug slot %s\n",
 		       __func__, drc_name);
 		return -EIO;
 	}
@@ -249,8 +250,8 @@ static int dlpar_add_phb(char *drc_name, struct device_node *dn)
 		return -EIO;
 
 	if (rpaphp_add_slot(dn)) {
-		printk(KERN_ERR "%s: unable to add hotplug slot %s\n",
-			__func__, drc_name);
+		pr_err("%s: unable to add hotplug slot %s\n",
+		       __func__, drc_name);
 		return -EIO;
 	}
 	return 0;
@@ -262,9 +263,8 @@ static int dlpar_add_vio_slot(char *drc_name, struct device_node *dn)
 		return -EINVAL;
 
 	if (!vio_register_device_node(dn)) {
-		printk(KERN_ERR
-			"%s: failed to register vio node %s\n",
-			__func__, drc_name);
+		pr_err("%s: failed to register vio node %s\n",
+		       __func__, drc_name);
 		return -EIO;
 	}
 	return 0;
@@ -310,7 +310,7 @@ int dlpar_add_slot(char *drc_name)
 			break;
 	}
 
-	printk(KERN_INFO "%s: slot %s added\n", DLPAR_MODULE_NAME, drc_name);
+	pr_info("%s: slot %s added\n", DLPAR_MODULE_NAME, drc_name);
 exit:
 	mutex_unlock(&rpadlpar_mutex);
 	return rc;
@@ -367,9 +367,8 @@ int dlpar_remove_pci_slot(char *drc_name, struct device_node *dn)
 			 pci_domain_nr(bus), bus->number);
 
 		if (rpaphp_deregister_slot(slot)) {
-			printk(KERN_ERR
-				"%s: unable to remove hotplug slot %s\n",
-				__func__, drc_name);
+			pr_err("%s: unable to remove hotplug slot %s\n",
+			       __func__, drc_name);
 			return -EIO;
 		}
 	}
@@ -379,8 +378,7 @@ int dlpar_remove_pci_slot(char *drc_name, struct device_node *dn)
 
 	/* Unmap PCI IO space */
 	if (pcibios_unmap_io_space(bus)) {
-		printk(KERN_ERR "%s: failed to unmap bus range\n",
-			__func__);
+		pr_err("%s: failed to unmap bus range\n", __func__);
 		return -ERANGE;
 	}
 
@@ -433,7 +431,7 @@ int dlpar_remove_slot(char *drc_name)
 	}
 	vm_unmap_aliases();
 
-	printk(KERN_INFO "%s: slot %s removed\n", DLPAR_MODULE_NAME, drc_name);
+	pr_info("%s: slot %s removed\n", DLPAR_MODULE_NAME, drc_name);
 exit:
 	mutex_unlock(&rpadlpar_mutex);
 	return rc;
@@ -451,8 +449,7 @@ int __init rpadlpar_io_init(void)
 	int rc = 0;
 
 	if (!is_dlpar_capable()) {
-		printk(KERN_WARNING "%s: partition not DLPAR capable\n",
-			__func__);
+		pr_warn("%s: partition not DLPAR capable\n", __func__);
 		return -EPERM;
 	}
 
diff --git a/drivers/pci/hotplug/rpaphp.h b/drivers/pci/hotplug/rpaphp.h
index 419919a..758a7b8 100644
--- a/drivers/pci/hotplug/rpaphp.h
+++ b/drivers/pci/hotplug/rpaphp.h
@@ -48,14 +48,10 @@
 #define MY_NAME "rpaphp"
 extern int rpaphp_debug;
 #define dbg(format, arg...)					\
-	do {							\
-		if (rpaphp_debug)					\
-			printk(KERN_DEBUG "%s: " format,	\
-				MY_NAME , ## arg); 		\
-	} while (0)
-#define err(format, arg...) printk(KERN_ERR "%s: " format, MY_NAME , ## arg)
-#define info(format, arg...) printk(KERN_INFO "%s: " format, MY_NAME , ## arg)
-#define warn(format, arg...) printk(KERN_WARNING "%s: " format, MY_NAME , ## arg)
+do {								\
+	if (rpaphp_debug)					\
+		pr_debug(format, ##arg);			\
+} while (0)
 
 /* slot states */
 
diff --git a/drivers/pci/hotplug/rpaphp_core.c b/drivers/pci/hotplug/rpaphp_core.c
index 758adb5..37dcee4 100644
--- a/drivers/pci/hotplug/rpaphp_core.c
+++ b/drivers/pci/hotplug/rpaphp_core.c
@@ -22,6 +22,9 @@
  * Send feedback to <lxie@us.ibm.com>
  *
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
@@ -330,7 +333,7 @@ int rpaphp_add_slot(struct device_node *dn)
 		slot->type = simple_strtoul(type, NULL, 10);
 				
 		dbg("Found drc-index:0x%x drc-name:%s drc-type:%s\n",
-				indexes[i + 1], name, type);
+		    indexes[i + 1], name, type);
 
 		retval = rpaphp_enable_slot(slot);
 		if (!retval)
@@ -342,7 +345,7 @@ int rpaphp_add_slot(struct device_node *dn)
 		name += strlen(name) + 1;
 		type += strlen(type) + 1;
 	}
-	dbg("%s - Exit: rc[%d]\n", __func__, retval);
+	dbg("%s: Exit: rc[%d]\n", __func__, retval);
 
 	/* XXX FIXME: reports a failure only if last entry in loop failed */
 	return retval;
@@ -371,7 +374,7 @@ static int __init rpaphp_init(void)
 {
 	struct device_node *dn = NULL;
 
-	info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
+	pr_info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
 
 	while ((dn = of_find_node_by_name(dn, "pci")))
 		rpaphp_add_slot(dn);
@@ -403,7 +406,8 @@ static int enable_slot(struct hotplug_slot *hotplug_slot)
 	} else if (state == EMPTY) {
 		slot->state = EMPTY;
 	} else {
-		err("%s: slot[%s] is in invalid state\n", __func__, slot->name);
+		pr_err("%s: slot[%s] is in invalid state\n",
+		       __func__, slot->name);
 		slot->state = NOT_VALID;
 		return -EINVAL;
 	}
diff --git a/drivers/pci/hotplug/rpaphp_pci.c b/drivers/pci/hotplug/rpaphp_pci.c
index 513e1e2..5ecf40e 100644
--- a/drivers/pci/hotplug/rpaphp_pci.c
+++ b/drivers/pci/hotplug/rpaphp_pci.c
@@ -22,6 +22,9 @@
  * Send feedback to <lxie@us.ibm.com>
  *
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/pci.h>
 #include <linux/string.h>
 
@@ -50,16 +53,16 @@ int rpaphp_get_sensor_state(struct slot *slot, int *state)
 			rc = rtas_set_power_level(slot->power_domain, POWER_ON,
 						  &setlevel);
 			if (rc < 0) {
-				dbg("%s: power on slot[%s] failed rc=%d.\n",
+				dbg("%s: power on slot[%s] failed rc=%d\n",
 				    __func__, slot->name, rc);
 			} else {
 				rc = rtas_get_sensor(DR_ENTITY_SENSE,
 						     slot->index, state);
 			}
 		} else if (rc == -ENODEV)
-			info("%s: slot is unusable\n", __func__);
+			pr_info("%s: slot is unusable\n", __func__);
 		else
-			err("%s failed to get sensor state\n", __func__);
+			pr_err("%s failed to get sensor state\n", __func__);
 	}
 	return rc;
 }
@@ -95,7 +98,8 @@ int rpaphp_enable_slot(struct slot *slot)
 
 	bus = pcibios_find_pci_bus(slot->dn);
 	if (!bus) {
-		err("%s: no pci_bus for dn %s\n", __func__, slot->dn->full_name);
+		pr_err("%s: no pci_bus for dn %s\n",
+		       __func__, slot->dn->full_name);
 		return -EINVAL;
 	}
 
@@ -110,8 +114,8 @@ int rpaphp_enable_slot(struct slot *slot)
 
 		/* non-empty slot has to have child */
 		if (!slot->dn->child) {
-			err("%s: slot[%s]'s device_node doesn't have child for adapter\n",
-			    __func__, slot->name);
+			pr_err("%s: slot[%s]'s device_node doesn't have child for adapter\n",
+			       __func__, slot->name);
 			return -EINVAL;
 		}
 
@@ -125,7 +129,8 @@ int rpaphp_enable_slot(struct slot *slot)
 
 		if (rpaphp_debug) {
 			struct pci_dev *dev;
-			dbg("%s: pci_devs of slot[%s]\n", __func__, slot->dn->full_name);
+			dbg("%s: pci_devs of slot[%s]\n",
+			    __func__, slot->dn->full_name);
 			list_for_each_entry (dev, &bus->devices, bus_list)
 				dbg("\t%s\n", pci_name(dev));
 		}
diff --git a/drivers/pci/hotplug/rpaphp_slot.c b/drivers/pci/hotplug/rpaphp_slot.c
index b283bbe..c6faffd 100644
--- a/drivers/pci/hotplug/rpaphp_slot.c
+++ b/drivers/pci/hotplug/rpaphp_slot.c
@@ -22,6 +22,9 @@
  * Send feedback to <lxie@us.ibm.com>
  *
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/sysfs.h>
@@ -100,16 +103,16 @@ int rpaphp_deregister_slot(struct slot *slot)
 	int retval = 0;
 	struct hotplug_slot *php_slot = slot->hotplug_slot;
 
-	 dbg("%s - Entry: deregistering slot=%s\n",
-		__func__, slot->name);
+	 dbg("%s: Entry: deregistering slot=%s\n",
+	     __func__, slot->name);
 
 	list_del(&slot->rpaphp_slot_list);
 	
 	retval = pci_hp_deregister(php_slot);
 	if (retval)
-		err("Problem unregistering a slot %s\n", slot->name);
+		pr_err("Problem unregistering a slot %s\n", slot->name);
 
-	dbg("%s - Exit: rc[%d]\n", __func__, retval);
+	dbg("%s: Exit: rc[%d]\n", __func__, retval);
 	return retval;
 }
 EXPORT_SYMBOL_GPL(rpaphp_deregister_slot);
@@ -121,12 +124,13 @@ int rpaphp_register_slot(struct slot *slot)
 	int slotno;
 
 	dbg("%s registering slot:path[%s] index[%x], name[%s] pdomain[%x] type[%d]\n", 
-		__func__, slot->dn->full_name, slot->index, slot->name,
-		slot->power_domain, slot->type);
+	    __func__, slot->dn->full_name, slot->index, slot->name,
+	    slot->power_domain, slot->type);
 
 	/* should not try to register the same slot twice */
 	if (is_registered(slot)) {
-		err("rpaphp_register_slot: slot[%s] is already registered\n", slot->name);
+		pr_err("%s: slot[%s] is already registered\n",
+		       __func__, slot->name);
 		return -EAGAIN;
 	}	
 
@@ -136,13 +140,13 @@ int rpaphp_register_slot(struct slot *slot)
 		slotno = -1;
 	retval = pci_hp_register(php_slot, slot->bus, slotno, slot->name);
 	if (retval) {
-		err("pci_hp_register failed with error %d\n", retval);
+		pr_err("pci_hp_register failed with error %d\n", retval);
 		return retval;
 	}
 
 	/* add slot to our internal list */
 	list_add(&slot->rpaphp_slot_list, &rpaphp_slot_head);
-	info("Slot [%s] registered\n", slot->name);
+	pr_info("Slot [%s] registered\n", slot->name);
 	return 0;
 }
 
diff --git a/drivers/pci/hotplug/sgi_hotplug.c b/drivers/pci/hotplug/sgi_hotplug.c
index 72d507b..9d322ff 100644
--- a/drivers/pci/hotplug/sgi_hotplug.c
+++ b/drivers/pci/hotplug/sgi_hotplug.c
@@ -362,7 +362,7 @@ static int enable_slot(struct hotplug_slot *bss_hotplug_slot)
 
 		ret = acpi_load_table((struct acpi_table_header *)ssdt);
 		if (ACPI_FAILURE(ret)) {
-			printk(KERN_ERR "%s: acpi_load_table failed (0x%x)\n",
+			pr_err("%s: acpi_load_table failed (0x%x)\n",
 			       __func__, ret);
 			/* try to continue on */
 		}
@@ -453,9 +453,8 @@ static int enable_slot(struct hotplug_slot *bss_hotplug_slot)
 				ret = acpi_bus_add(&device, pdevice, chandle,
 						   ACPI_BUS_TYPE_DEVICE);
 				if (ACPI_FAILURE(ret)) {
-					printk(KERN_ERR "%s: acpi_bus_add "
-					       "failed (0x%x) for slot %d "
-					       "func %d\n", __func__,
+					pr_err("%s: acpi_bus_add failed (0x%x) for slot %d func %d\n",
+					       __func__,
 					       ret, (int)(adr>>16),
 					       (int)(adr&0xffff));
 					/* try to continue on */
@@ -564,8 +563,7 @@ static int disable_slot(struct hotplug_slot *bss_hotplug_slot)
 		acpi_status ret;
 		ret = acpi_unload_table_id(ssdt_id);
 		if (ACPI_FAILURE(ret)) {
-			printk(KERN_ERR "%s: acpi_unload_table_id "
-			       "failed (0x%x) for id %d\n",
+			pr_err("%s: acpi_unload_table_id failed (0x%x) for id %d\n",
 			       __func__, ret, ssdt_id);
 			/* try to continue on */
 		}
@@ -685,8 +683,7 @@ static int __init sn_pci_hotplug_init(void)
 	int registered = 0;
 
 	if (!sn_prom_feature_available(PRF_HOTPLUG_SUPPORT)) {
-		printk(KERN_ERR "%s: PROM version does not support hotplug.\n",
-		       __func__);
+		pr_err("%s: PROM version does not support hotplug\n", __func__);
 		return -EPERM;
 	}
 
@@ -723,7 +720,7 @@ static void __exit sn_pci_hotplug_exit(void)
 		pci_hp_deregister(bss_hotplug_slot);
 
 	if (!list_empty(&sn_hp_list))
-		printk(KERN_ERR "%s: internal list is not empty\n", __FILE__);
+		pr_err("%s: internal list is not empty\n", __FILE__);
 }
 
 module_init(sn_pci_hotplug_init);
diff --git a/drivers/pci/hotplug/shpchp.h b/drivers/pci/hotplug/shpchp.h
index e0c90e6..43e2785 100644
--- a/drivers/pci/hotplug/shpchp.h
+++ b/drivers/pci/hotplug/shpchp.h
@@ -52,28 +52,20 @@ extern struct workqueue_struct *shpchp_ordered_wq;
 #define dbg(format, arg...)						\
 do {									\
 	if (shpchp_debug)						\
-		printk(KERN_DEBUG "%s: " format, MY_NAME , ## arg);	\
+		pr_debug(format, ##arg);				\
 } while (0)
-#define err(format, arg...)						\
-	printk(KERN_ERR "%s: " format, MY_NAME , ## arg)
-#define info(format, arg...)						\
-	printk(KERN_INFO "%s: " format, MY_NAME , ## arg)
-#define warn(format, arg...)						\
-	printk(KERN_WARNING "%s: " format, MY_NAME , ## arg)
 
 #define ctrl_dbg(ctrl, format, arg...)					\
-	do {								\
-		if (shpchp_debug)					\
-			dev_printk(KERN_DEBUG, &ctrl->pci_dev->dev,	\
-					format, ## arg);		\
-	} while (0)
+do {									\
+	if (shpchp_debug)						\
+		dev_dbg(&ctrl->pci_dev->dev, format, ##arg);		\
+} while (0)
 #define ctrl_err(ctrl, format, arg...)					\
-	dev_err(&ctrl->pci_dev->dev, format, ## arg)
+	dev_err(&ctrl->pci_dev->dev, format, ##arg)
 #define ctrl_info(ctrl, format, arg...)					\
-	dev_info(&ctrl->pci_dev->dev, format, ## arg)
+	dev_info(&ctrl->pci_dev->dev, format, ##arg)
 #define ctrl_warn(ctrl, format, arg...)					\
-	dev_warn(&ctrl->pci_dev->dev, format, ## arg)
-
+	dev_warn(&ctrl->pci_dev->dev, format, ##arg)
 
 #define SLOT_NAME_SIZE 10
 struct slot {
diff --git a/drivers/pci/hotplug/shpchp_core.c b/drivers/pci/hotplug/shpchp_core.c
index aca972b..fab3ded 100644
--- a/drivers/pci/hotplug/shpchp_core.c
+++ b/drivers/pci/hotplug/shpchp_core.c
@@ -27,6 +27,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/kernel.h>
@@ -372,7 +374,7 @@ static int __init shpcd_init(void)
 
 	retval = pci_register_driver(&shpc_driver);
 	dbg("%s: pci_register_driver = %d\n", __func__, retval);
-	info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
+	pr_info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
 	if (retval) {
 		destroy_workqueue(shpchp_ordered_wq);
 		destroy_workqueue(shpchp_wq);
@@ -386,7 +388,7 @@ static void __exit shpcd_cleanup(void)
 	pci_unregister_driver(&shpc_driver);
 	destroy_workqueue(shpchp_ordered_wq);
 	destroy_workqueue(shpchp_wq);
-	info(DRIVER_DESC " version: " DRIVER_VERSION " unloaded\n");
+	pr_info(DRIVER_DESC " version: " DRIVER_VERSION " unloaded\n");
 }
 
 module_init(shpcd_init);
diff --git a/drivers/pci/hotplug/shpchp_ctrl.c b/drivers/pci/hotplug/shpchp_ctrl.c
index b00b09b..050da0a 100644
--- a/drivers/pci/hotplug/shpchp_ctrl.c
+++ b/drivers/pci/hotplug/shpchp_ctrl.c
@@ -493,12 +493,12 @@ static void handle_button_press_event(struct slot *p_slot)
 		p_slot->hpc_ops->get_power_status(p_slot, &getstatus);
 		if (getstatus) {
 			p_slot->state = BLINKINGOFF_STATE;
-			ctrl_info(ctrl, "PCI slot #%s - powering off due to "
-				  "button press.\n", slot_name(p_slot));
+			ctrl_info(ctrl, "PCI slot #%s - powering off due to button press\n",
+				  slot_name(p_slot));
 		} else {
 			p_slot->state = BLINKINGON_STATE;
-			ctrl_info(ctrl, "PCI slot #%s - powering on due to "
-				  "button press.\n", slot_name(p_slot));
+			ctrl_info(ctrl, "PCI slot #%s - powering on due to button press\n",
+				  slot_name(p_slot));
 		}
 		/* blink green LED and turn off amber */
 		p_slot->hpc_ops->green_led_blink(p_slot);
@@ -521,8 +521,8 @@ static void handle_button_press_event(struct slot *p_slot)
 		else
 			p_slot->hpc_ops->green_led_off(p_slot);
 		p_slot->hpc_ops->set_attention_status(p_slot, 0);
-		ctrl_info(ctrl, "PCI slot #%s - action canceled due to "
-			  "button press\n", slot_name(p_slot));
+		ctrl_info(ctrl, "PCI slot #%s - action canceled due to button press\n",
+			  slot_name(p_slot));
 		p_slot->state = STATIC_STATE;
 		break;
 	case POWEROFF_STATE:
diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 59f17ac..a728162 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -21,6 +21,8 @@
  * Author: Fenghua Yu <fenghua.yu@intel.com>
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/init.h>
 #include <linux/bitmap.h>
 #include <linux/debugfs.h>
@@ -418,25 +420,21 @@ static int __init intel_iommu_setup(char *str)
 	while (*str) {
 		if (!strncmp(str, "on", 2)) {
 			dmar_disabled = 0;
-			printk(KERN_INFO "Intel-IOMMU: enabled\n");
+			pr_info("enabled\n");
 		} else if (!strncmp(str, "off", 3)) {
 			dmar_disabled = 1;
-			printk(KERN_INFO "Intel-IOMMU: disabled\n");
+			pr_info("disabled\n");
 		} else if (!strncmp(str, "igfx_off", 8)) {
 			dmar_map_gfx = 0;
-			printk(KERN_INFO
-				"Intel-IOMMU: disable GFX device mapping\n");
+			pr_info("disable GFX device mapping\n");
 		} else if (!strncmp(str, "forcedac", 8)) {
-			printk(KERN_INFO
-				"Intel-IOMMU: Forcing DAC for PCI devices\n");
+			pr_info("Forcing DAC for PCI devices\n");
 			dmar_forcedac = 1;
 		} else if (!strncmp(str, "strict", 6)) {
-			printk(KERN_INFO
-				"Intel-IOMMU: disable batched IOTLB flush\n");
+			pr_info("disable batched IOTLB flush\n");
 			intel_iommu_strict = 1;
 		} else if (!strncmp(str, "sp_off", 6)) {
-			printk(KERN_INFO
-				"Intel-IOMMU: disable supported super page\n");
+			pr_info("disable supported super page\n");
 			intel_iommu_superpage = 0;
 		}
 
@@ -1047,9 +1045,9 @@ static void __iommu_flush_iotlb(struct intel_iommu *iommu, u16 did,
 
 	/* check IOTLB invalidation granularity */
 	if (DMA_TLB_IAIG(val) == 0)
-		printk(KERN_ERR"IOMMU: flush IOTLB failed\n");
+		pr_err("flush IOTLB failed\n");
 	if (DMA_TLB_IAIG(val) != DMA_TLB_IIRG(type))
-		pr_debug("IOMMU: tlb flush request %Lx, actual %Lx\n",
+		pr_debug("tlb flush request %llx, actual %Lx\n",
 			(unsigned long long)DMA_TLB_IIRG(type),
 			(unsigned long long)DMA_TLB_IAIG(val));
 }
@@ -1223,13 +1221,13 @@ static int iommu_init_domains(struct intel_iommu *iommu)
 	 */
 	iommu->domain_ids = kcalloc(nlongs, sizeof(unsigned long), GFP_KERNEL);
 	if (!iommu->domain_ids) {
-		printk(KERN_ERR "Allocating domain id array failed\n");
+		pr_err("Allocating domain id array failed\n");
 		return -ENOMEM;
 	}
 	iommu->domains = kcalloc(ndomains, sizeof(struct dmar_domain *),
 			GFP_KERNEL);
 	if (!iommu->domains) {
-		printk(KERN_ERR "Allocating domain array failed\n");
+		pr_err("Allocating domain array failed\n");
 		return -ENOMEM;
 	}
 
@@ -1325,7 +1323,7 @@ static int iommu_attach_domain(struct dmar_domain *domain,
 	num = find_first_zero_bit(iommu->domain_ids, ndomains);
 	if (num >= ndomains) {
 		spin_unlock_irqrestore(&iommu->lock, flags);
-		printk(KERN_ERR "IOMMU: no free domain ids\n");
+		pr_err("no free domain ids\n");
 		return -ENOMEM;
 	}
 
@@ -1380,7 +1378,7 @@ static int dmar_init_reserved_ranges(void)
 	iova = reserve_iova(&reserved_iova_list, IOVA_PFN(IOAPIC_RANGE_START),
 		IOVA_PFN(IOAPIC_RANGE_END));
 	if (!iova) {
-		printk(KERN_ERR "Reserve IOAPIC range failed\n");
+		pr_err("Reserve IOAPIC range failed\n");
 		return -ENODEV;
 	}
 
@@ -1396,7 +1394,7 @@ static int dmar_init_reserved_ranges(void)
 					    IOVA_PFN(r->start),
 					    IOVA_PFN(r->end));
 			if (!iova) {
-				printk(KERN_ERR "Reserve iova failed\n");
+				pr_err("Reserve iova failed\n");
 				return -ENODEV;
 			}
 		}
@@ -1558,7 +1556,7 @@ static int domain_context_mapping_one(struct dmar_domain *domain, int segment,
 			num = find_first_zero_bit(iommu->domain_ids, ndomains);
 			if (num >= ndomains) {
 				spin_unlock_irqrestore(&iommu->lock, flags);
-				printk(KERN_ERR "IOMMU: no free domain ids\n");
+				pr_err("no free domain ids\n");
 				return -EFAULT;
 			}
 
@@ -1801,8 +1799,8 @@ static int __domain_mapping(struct dmar_domain *domain, unsigned long iov_pfn,
 		tmp = cmpxchg64_local(&pte->val, 0ULL, pteval);
 		if (tmp) {
 			static int dumps = 5;
-			printk(KERN_CRIT "ERROR: DMA PTE for vPFN 0x%lx already set (to %llx not %llx)\n",
-			       iov_pfn, tmp, (unsigned long long)pteval);
+			pr_crit("ERROR: DMA PTE for vPFN 0x%lx already set (to %llx not %llx)\n",
+				iov_pfn, tmp, (unsigned long long)pteval);
 			if (dumps) {
 				dumps--;
 				debug_dma_dump_mappings(NULL);
@@ -1964,8 +1962,7 @@ static struct dmar_domain *get_domain_for_dev(struct pci_dev *pdev, int gaw)
 	/* Allocate new domain for the device */
 	drhd = dmar_find_matched_drhd_unit(pdev);
 	if (!drhd) {
-		printk(KERN_ERR "IOMMU: can't find DMAR for device %s\n",
-			pci_name(pdev));
+		pr_err("can't find DMAR for device %s\n", pci_name(pdev));
 		return NULL;
 	}
 	iommu = drhd->iommu;
@@ -2063,7 +2060,7 @@ static int iommu_domain_identity_map(struct dmar_domain *domain,
 
 	if (!reserve_iova(&domain->iovad, dma_to_mm_pfn(first_vpfn),
 			  dma_to_mm_pfn(last_vpfn))) {
-		printk(KERN_ERR "IOMMU: reserve iova failed\n");
+		pr_err("reserve iova failed\n");
 		return -ENOMEM;
 	}
 
@@ -2096,14 +2093,13 @@ static int iommu_prepare_identity_map(struct pci_dev *pdev,
 	   range which is reserved in E820, so which didn't get set
 	   up to start with in si_domain */
 	if (domain == si_domain && hw_pass_through) {
-		printk("Ignoring identity map for HW passthrough device %s [0x%Lx - 0x%Lx]\n",
-		       pci_name(pdev), start, end);
+		pr_notice("Ignoring identity map for HW passthrough device %s [0x%llx - 0x%llx]\n",
+			  pci_name(pdev), start, end);
 		return 0;
 	}
 
-	printk(KERN_INFO
-	       "IOMMU: Setting identity map for device %s [0x%Lx - 0x%Lx]\n",
-	       pci_name(pdev), start, end);
+	pr_info("Setting identity map for device %s [0x%llx - 0x%llx]\n",
+		pci_name(pdev), start, end);
 	
 	if (end < start) {
 		WARN(1, "Your BIOS is broken; RMRR ends before it starts!\n"
@@ -2161,12 +2157,11 @@ static inline void iommu_prepare_isa(void)
 	if (!pdev)
 		return;
 
-	printk(KERN_INFO "IOMMU: Prepare 0-16MiB unity mapping for LPC\n");
+	pr_info("Prepare 0-16MiB unity mapping for LPC\n");
 	ret = iommu_prepare_identity_map(pdev, 0, 16*1024*1024 - 1);
 
 	if (ret)
-		printk(KERN_ERR "IOMMU: Failed to create 0-16MiB identity map; "
-		       "floppy might not work\n");
+		pr_err("Failed to create 0-16MiB identity map; floppy might not work\n");
 
 }
 #else
@@ -2350,8 +2345,8 @@ static int __init iommu_prepare_static_identity_mapping(int hw)
 		if (IS_BRIDGE_HOST_DEVICE(pdev))
 			continue;
 		if (iommu_should_identity_map(pdev, 1)) {
-			printk(KERN_INFO "IOMMU: %s identity mapping for device %s\n",
-			       hw ? "hardware" : "software", pci_name(pdev));
+			pr_info("%s identity mapping for device %s\n",
+				hw ? "hardware" : "software", pci_name(pdev));
 
 			ret = domain_add_dev_info(si_domain, pdev,
 						     hw ? CONTEXT_TT_PASS_THROUGH :
@@ -2390,7 +2385,7 @@ static int __init init_dmars(void)
 	g_iommus = kcalloc(g_num_of_iommus, sizeof(struct intel_iommu *),
 			GFP_KERNEL);
 	if (!g_iommus) {
-		printk(KERN_ERR "Allocating global iommu array failed\n");
+		pr_err("Allocating global iommu array failed\n");
 		ret = -ENOMEM;
 		goto error;
 	}
@@ -2420,7 +2415,7 @@ static int __init init_dmars(void)
 		 */
 		ret = iommu_alloc_root_entry(iommu);
 		if (ret) {
-			printk(KERN_ERR "IOMMU: allocate root entry failed\n");
+			pr_err("allocate root entry failed\n");
 			goto error;
 		}
 		if (!ecap_pass_through(iommu->ecap))
@@ -2468,17 +2463,15 @@ static int __init init_dmars(void)
 			 */
 			iommu->flush.flush_context = __iommu_flush_context;
 			iommu->flush.flush_iotlb = __iommu_flush_iotlb;
-			printk(KERN_INFO "IOMMU %d 0x%Lx: using Register based "
-			       "invalidation\n",
+			pr_info("%d 0x%llx: using Register based invalidation\n",
 				iommu->seq_id,
-			       (unsigned long long)drhd->reg_base_addr);
+				(unsigned long long)drhd->reg_base_addr);
 		} else {
 			iommu->flush.flush_context = qi_flush_context;
 			iommu->flush.flush_iotlb = qi_flush_iotlb;
-			printk(KERN_INFO "IOMMU %d 0x%Lx: using Queued "
-			       "invalidation\n",
+			pr_info("%d 0x%llx: using Queued invalidation\n",
 				iommu->seq_id,
-			       (unsigned long long)drhd->reg_base_addr);
+				(unsigned long long)drhd->reg_base_addr);
 		}
 	}
 
@@ -2499,7 +2492,7 @@ static int __init init_dmars(void)
 	if (iommu_identity_mapping) {
 		ret = iommu_prepare_static_identity_mapping(hw_pass_through);
 		if (ret) {
-			printk(KERN_CRIT "Failed to setup IOMMU pass-through\n");
+			pr_crit("Failed to setup IOMMU pass-through\n");
 			goto error;
 		}
 	}
@@ -2517,7 +2510,7 @@ static int __init init_dmars(void)
 	 *    endfor
 	 * endfor
 	 */
-	printk(KERN_INFO "IOMMU: Setting RMRR:\n");
+	pr_info("Setting RMRR:\n");
 	for_each_rmrr_units(rmrr) {
 		for (i = 0; i < rmrr->devices_cnt; i++) {
 			pdev = rmrr->devices[i];
@@ -2529,8 +2522,7 @@ static int __init init_dmars(void)
 				continue;
 			ret = iommu_prepare_rmrr_dev(rmrr, pdev);
 			if (ret)
-				printk(KERN_ERR
-				       "IOMMU: mapping reserved region failed\n");
+				pr_err("mapping reserved region failed\n");
 		}
 	}
 
@@ -2609,7 +2601,7 @@ static struct iova *intel_alloc_iova(struct device *dev,
 	}
 	iova = alloc_iova(&domain->iovad, nrpages, IOVA_PFN(dma_mask), 1);
 	if (unlikely(!iova)) {
-		printk(KERN_ERR "Allocating %ld-page iova for %s failed",
+		pr_err("Allocating %ld-page iova for %s failed",
 		       nrpages, pci_name(pdev));
 		return NULL;
 	}
@@ -2625,8 +2617,7 @@ static struct dmar_domain *__get_valid_domain_for_dev(struct pci_dev *pdev)
 	domain = get_domain_for_dev(pdev,
 			DEFAULT_DOMAIN_ADDRESS_WIDTH);
 	if (!domain) {
-		printk(KERN_ERR
-			"Allocating domain for %s failed", pci_name(pdev));
+		pr_err("Allocating domain for %s failed", pci_name(pdev));
 		return NULL;
 	}
 
@@ -2635,9 +2626,8 @@ static struct dmar_domain *__get_valid_domain_for_dev(struct pci_dev *pdev)
 		ret = domain_context_mapping(domain, pdev,
 					     CONTEXT_TT_MULTI_LEVEL);
 		if (ret) {
-			printk(KERN_ERR
-				"Domain context map for %s failed",
-				pci_name(pdev));
+			pr_err("Domain context map for %s failed\n",
+			       pci_name(pdev));
 			return NULL;
 		}
 	}
@@ -2688,8 +2678,8 @@ static int iommu_no_mapping(struct device *dev)
 			 * to non-identity mapping.
 			 */
 			domain_remove_one_dev_info(si_domain, pdev);
-			printk(KERN_INFO "32bit %s uses non-identity mapping\n",
-			       pci_name(pdev));
+			pr_info("32bit %s uses non-identity mapping\n",
+				pci_name(pdev));
 			return 0;
 		}
 	} else {
@@ -2704,8 +2694,8 @@ static int iommu_no_mapping(struct device *dev)
 						  CONTEXT_TT_PASS_THROUGH :
 						  CONTEXT_TT_MULTI_LEVEL);
 			if (!ret) {
-				printk(KERN_INFO "64bit %s uses identity mapping\n",
-				       pci_name(pdev));
+				pr_info("64bit %s uses identity mapping\n",
+					pci_name(pdev));
 				return 1;
 			}
 		}
@@ -2775,8 +2765,8 @@ static dma_addr_t __intel_map_single(struct device *hwdev, phys_addr_t paddr,
 error:
 	if (iova)
 		__free_iova(&domain->iovad, iova);
-	printk(KERN_ERR"Device %s request: %zx@%llx dir %d --- failed\n",
-		pci_name(pdev), size, (unsigned long long)paddr, dir);
+	pr_err("Device %s request: %zx@%llx dir %d --- failed\n",
+	       pci_name(pdev), size, (unsigned long long)paddr, dir);
 	return 0;
 }
 
@@ -3112,7 +3102,7 @@ static inline int iommu_domain_cache_init(void)
 
 					 NULL);
 	if (!iommu_domain_cache) {
-		printk(KERN_ERR "Couldn't create iommu_domain cache\n");
+		pr_err("Couldn't create iommu_domain cache\n");
 		ret = -ENOMEM;
 	}
 
@@ -3129,7 +3119,7 @@ static inline int iommu_devinfo_cache_init(void)
 					 SLAB_HWCACHE_ALIGN,
 					 NULL);
 	if (!iommu_devinfo_cache) {
-		printk(KERN_ERR "Couldn't create devinfo cache\n");
+		pr_err("Couldn't create devinfo cache\n");
 		ret = -ENOMEM;
 	}
 
@@ -3146,7 +3136,7 @@ static inline int iommu_iova_cache_init(void)
 					 SLAB_HWCACHE_ALIGN,
 					 NULL);
 	if (!iommu_iova_cache) {
-		printk(KERN_ERR "Couldn't create iova cache\n");
+		pr_err("Couldn't create iova cache\n");
 		ret = -ENOMEM;
 	}
 
@@ -3471,13 +3461,12 @@ int __init intel_iommu_init(void)
 	if (ret) {
 		if (force_on)
 			panic("tboot: Failed to initialize DMARs\n");
-		printk(KERN_ERR "IOMMU: dmar init failed\n");
+		pr_err("dmar init failed\n");
 		put_iova_domain(&reserved_iova_list);
 		iommu_exit_mempool();
 		return ret;
 	}
-	printk(KERN_INFO
-	"PCI-DMA: Intel(R) Virtualization Technology for Directed I/O\n");
+	pr_info("PCI-DMA: Intel(R) Virtualization Technology for Directed I/O\n");
 
 	init_timer(&unmap_timer);
 #ifdef CONFIG_SWIOTLB
@@ -3730,13 +3719,11 @@ static int intel_iommu_domain_init(struct iommu_domain *domain)
 
 	dmar_domain = iommu_alloc_vm_domain();
 	if (!dmar_domain) {
-		printk(KERN_ERR
-			"intel_iommu_domain_init: dmar_domain == NULL\n");
+		pr_err("%s: dmar_domain == NULL\n", __func__);
 		return -ENOMEM;
 	}
 	if (md_domain_init(dmar_domain, DEFAULT_DOMAIN_ADDRESS_WIDTH)) {
-		printk(KERN_ERR
-			"intel_iommu_domain_init() failed\n");
+		pr_err("%s() failed\n", __func__);
 		vm_domain_exit(dmar_domain);
 		return -ENOMEM;
 	}
@@ -3786,8 +3773,7 @@ static int intel_iommu_attach_device(struct iommu_domain *domain,
 		addr_width = cap_mgaw(iommu->cap);
 
 	if (dmar_domain->max_addr > (1LL << addr_width)) {
-		printk(KERN_ERR "%s: iommu width (%d) is not "
-		       "sufficient for the mapped address (%llx)\n",
+		pr_err("%s: iommu width (%d) is not sufficient for the mapped address (%llx)\n",
 		       __func__, addr_width, dmar_domain->max_addr);
 		return -EFAULT;
 	}
@@ -3845,8 +3831,7 @@ static int intel_iommu_map(struct iommu_domain *domain,
 		/* check if minimum agaw is sufficient for mapped address */
 		end = __DOMAIN_MAX_ADDR(dmar_domain->gaw) + 1;
 		if (end < max_addr) {
-			printk(KERN_ERR "%s: iommu width (%d) is not "
-			       "sufficient for the mapped address (%llx)\n",
+			pr_err("%s: iommu width (%d) is not sufficient for the mapped address (%llx)\n",
 			       __func__, dmar_domain->gaw, max_addr);
 			return -EFAULT;
 		}
@@ -3919,12 +3904,12 @@ static void __devinit quirk_iommu_rwbf(struct pci_dev *dev)
 	 * Mobile 4 Series Chipset neglects to set RWBF capability,
 	 * but needs it:
 	 */
-	printk(KERN_INFO "DMAR: Forcing write-buffer flush capability\n");
+	pr_info("DMAR: Forcing write-buffer flush capability\n");
 	rwbf_quirk = 1;
 
 	/* https://bugzilla.redhat.com/show_bug.cgi?id=538163 */
 	if (dev->revision == 0x07) {
-		printk(KERN_INFO "DMAR: Disabling IOMMU for graphics on this chipset\n");
+		pr_info("DMAR: Disabling IOMMU for graphics on this chipset\n");
 		dmar_map_gfx = 0;
 	}
 }
@@ -3949,7 +3934,7 @@ static void __devinit quirk_calpella_no_shadow_gtt(struct pci_dev *dev)
 		return;
 
 	if (!(ggc & GGC_MEMORY_VT_ENABLED)) {
-		printk(KERN_INFO "DMAR: BIOS has allocated no shadow GTT; disabling IOMMU for graphics\n");
+		pr_info("DMAR: BIOS has allocated no shadow GTT; disabling IOMMU for graphics\n");
 		dmar_map_gfx = 0;
 	}
 }
@@ -4012,6 +3997,6 @@ static void __init check_tylersburg_isoch(void)
 		return;
 	}
 	
-	printk(KERN_WARNING "DMAR: Recommended TLB entries for ISOCH unit is 16; your BIOS set %d\n",
-	       vtisochctrl);
+	pr_warn("DMAR: Recommended TLB entries for ISOCH unit is 16; your BIOS set %d\n",
+		vtisochctrl);
 }
diff --git a/drivers/pci/intr_remapping.c b/drivers/pci/intr_remapping.c
index 3607faf..c394a38 100644
--- a/drivers/pci/intr_remapping.c
+++ b/drivers/pci/intr_remapping.c
@@ -1,3 +1,5 @@
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/interrupt.h>
 #include <linux/dmar.h>
 #include <linux/spinlock.h>
@@ -95,10 +97,8 @@ int alloc_irte(struct intel_iommu *iommu, int irq, u16 count)
 	}
 
 	if (mask > ecap_max_handle_mask(iommu->ecap)) {
-		printk(KERN_ERR
-		       "Requested mask %x exceeds the max invalidation handle"
-		       " mask value %Lx\n", mask,
-		       ecap_max_handle_mask(iommu->ecap));
+		pr_err("Requested mask %x exceeds the max invalidation handle mask value %llx\n",
+		       mask, ecap_max_handle_mask(iommu->ecap));
 		return -1;
 	}
 
@@ -115,7 +115,7 @@ int alloc_irte(struct intel_iommu *iommu, int irq, u16 count)
 
 		if (index == start_index) {
 			spin_unlock_irqrestore(&irq_2_ir_lock, flags);
-			printk(KERN_ERR "can't allocate an IRTE\n");
+			pr_err("can't allocate an IRTE\n");
 			return -1;
 		}
 	} while (1);
@@ -336,7 +336,7 @@ int set_ioapic_sid(struct irte *irte, int apic)
 	}
 
 	if (sid == 0) {
-		pr_warning("Failed to set source-id of IOAPIC (%d)\n", apic);
+		pr_warn("Failed to set source-id of IOAPIC (%d)\n", apic);
 		return -1;
 	}
 
@@ -361,7 +361,7 @@ int set_hpet_sid(struct irte *irte, u8 id)
 	}
 
 	if (sid == 0) {
-		pr_warning("Failed to set source-id of HPET block (%d)\n", id);
+		pr_warn("Failed to set source-id of HPET block (%d)\n", id);
 		return -1;
 	}
 
@@ -457,7 +457,7 @@ static int setup_intr_remapping(struct intel_iommu *iommu, int mode)
 				 INTR_REMAP_PAGE_ORDER);
 
 	if (!pages) {
-		printk(KERN_ERR "failed to allocate pages of order %d\n",
+		pr_err("failed to allocate pages of order %d\n",
 		       INTR_REMAP_PAGE_ORDER);
 		kfree(iommu->ir_table);
 		return -ENOMEM;
@@ -528,7 +528,7 @@ int __init enable_intr_remapping(int eim)
 	int setup = 0;
 
 	if (parse_ioapics_under_ir() != 1) {
-		printk(KERN_INFO "Not enable interrupt remapping\n");
+		pr_info("Not enable interrupt remapping\n");
 		return -1;
 	}
 
@@ -566,8 +566,8 @@ int __init enable_intr_remapping(int eim)
 			continue;
 
 		if (eim && !ecap_eim_support(iommu->ecap)) {
-			printk(KERN_INFO "DRHD %Lx: EIM not supported by DRHD, "
-			       " ecap %Lx\n", drhd->reg_base_addr, iommu->ecap);
+			pr_info("DRHD %llx: EIM not supported by DRHD, ecap %Lx\n",
+				drhd->reg_base_addr, iommu->ecap);
 			return -1;
 		}
 	}
@@ -581,8 +581,7 @@ int __init enable_intr_remapping(int eim)
 		ret = dmar_enable_qi(iommu);
 
 		if (ret) {
-			printk(KERN_ERR "DRHD %Lx: failed to enable queued, "
-			       " invalidation, ecap %Lx, ret %d\n",
+			pr_err("DRHD %llx: failed to enable queued, invalidation, ecap %Lx, ret %d\n",
 			       drhd->reg_base_addr, iommu->ecap, ret);
 			return -1;
 		}
@@ -690,24 +689,23 @@ static int ir_parse_ioapic_hpet_scope(struct acpi_dmar_header *header,
 		scope = start;
 		if (scope->entry_type == ACPI_DMAR_SCOPE_TYPE_IOAPIC) {
 			if (ir_ioapic_num == MAX_IO_APICS) {
-				printk(KERN_WARNING "Exceeded Max IO APICS\n");
+				pr_warn("Exceeded Max IO APICS\n");
 				return -1;
 			}
 
-			printk(KERN_INFO "IOAPIC id %d under DRHD base "
-			       " 0x%Lx IOMMU %d\n", scope->enumeration_id,
-			       drhd->address, iommu->seq_id);
+			pr_info("IOAPIC id %d under DRHD base 0x%llx IOMMU %d\n",
+				scope->enumeration_id,
+				drhd->address, iommu->seq_id);
 
 			ir_parse_one_ioapic_scope(scope, iommu);
 		} else if (scope->entry_type == ACPI_DMAR_SCOPE_TYPE_HPET) {
 			if (ir_hpet_num == MAX_HPET_TBS) {
-				printk(KERN_WARNING "Exceeded Max HPET blocks\n");
+				pr_warn("Exceeded Max HPET blocks\n");
 				return -1;
 			}
 
-			printk(KERN_INFO "HPET id %d under DRHD base"
-			       " 0x%Lx\n", scope->enumeration_id,
-			       drhd->address);
+			pr_info("HPET id %d under DRHD base 0x%llx\n",
+				scope->enumeration_id, drhd->address);
 
 			ir_parse_one_hpet_scope(scope, iommu);
 		}
@@ -738,8 +736,7 @@ int __init parse_ioapics_under_ir(void)
 	}
 
 	if (ir_supported && ir_ioapic_num != nr_ioapics) {
-		printk(KERN_WARNING
-		       "Not all IO-APIC's listed under remapping hardware\n");
+		pr_warn("Not all IO-APIC's listed under remapping hardware\n");
 		return -1;
 	}
 
diff --git a/drivers/pci/iova.c b/drivers/pci/iova.c
index c5c274a..4a4e652 100644
--- a/drivers/pci/iova.c
+++ b/drivers/pci/iova.c
@@ -17,6 +17,8 @@
  * Author: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/iova.h>
 
 void
@@ -428,8 +430,8 @@ copy_reserved_iova(struct iova_domain *from, struct iova_domain *to)
 		struct iova *new_iova;
 		new_iova = reserve_iova(to, iova->pfn_lo, iova->pfn_hi);
 		if (!new_iova)
-			printk(KERN_ERR "Reserve iova range %lx@%lx failed\n",
-				iova->pfn_lo, iova->pfn_lo);
+			pr_err("Reserve iova range %lx@%lx failed\n",
+			       iova->pfn_lo, iova->pfn_lo);
 	}
 	spin_unlock_irqrestore(&from->iova_rbtree_lock, flags);
 }
diff --git a/drivers/pci/pci-acpi.c b/drivers/pci/pci-acpi.c
index d36f41e..a8c5007 100644
--- a/drivers/pci/pci-acpi.c
+++ b/drivers/pci/pci-acpi.c
@@ -7,6 +7,8 @@
  * Copyright (C) 2004 Intel Corp.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/delay.h>
 #include <linux/init.h>
 #include <linux/pci.h>
@@ -387,12 +389,12 @@ static int __init acpi_pci_init(void)
 	int ret;
 
 	if (acpi_gbl_FADT.boot_flags & ACPI_FADT_NO_MSI) {
-		printk(KERN_INFO"ACPI FADT declares the system doesn't support MSI, so disable it\n");
+		pr_info("ACPI FADT declares the system doesn't support MSI, so disable it\n");
 		pci_no_msi();
 	}
 
 	if (acpi_gbl_FADT.boot_flags & ACPI_FADT_NO_ASPM) {
-		printk(KERN_INFO"ACPI FADT declares the system doesn't support PCIe ASPM, so disable it\n");
+		pr_info("ACPI FADT declares the system doesn't support PCIe ASPM, so disable it\n");
 		pcie_clear_aspm();
 		pcie_no_aspm();
 	}
diff --git a/drivers/pci/pci-stub.c b/drivers/pci/pci-stub.c
index 775e933..07cfcd2 100644
--- a/drivers/pci/pci-stub.c
+++ b/drivers/pci/pci-stub.c
@@ -16,6 +16,8 @@
  * .../0000:00:19.0/driver -> ../../../bus/pci/drivers/pci-stub
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/pci.h>
 
@@ -66,20 +68,18 @@ static int __init pci_stub_init(void)
 				&class, &class_mask);
 
 		if (fields < 2) {
-			printk(KERN_WARNING
-			       "pci-stub: invalid id string \"%s\"\n", id);
+			pr_warn("invalid id string \"%s\"\n", id);
 			continue;
 		}
 
-		printk(KERN_INFO
-		       "pci-stub: add %04X:%04X sub=%04X:%04X cls=%08X/%08X\n",
-		       vendor, device, subvendor, subdevice, class, class_mask);
+		pr_info("add %04X:%04X sub=%04X:%04X cls=%08X/%08X\n",
+			vendor, device, subvendor, subdevice,
+			class, class_mask);
 
 		rc = pci_add_dynid(&stub_driver, vendor, device,
 				   subvendor, subdevice, class, class_mask, 0);
 		if (rc)
-			printk(KERN_WARNING
-			       "pci-stub: failed to add dynamic id (%d)\n", rc);
+			pr_warn("failed to add dynamic id (%d)\n", rc);
 	}
 
 	return 0;
diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 7bcf12a..a5ba1ff 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -14,6 +14,7 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/kernel.h>
 #include <linux/sched.h>
@@ -751,8 +752,7 @@ legacy_io_err:
 	kfree(b->legacy_io);
 	b->legacy_io = NULL;
 kzalloc_err:
-	printk(KERN_WARNING "pci: warning: could not create legacy I/O port "
-	       "and ISA memory resources to sysfs\n");
+	pr_warn("warning: could not create legacy I/O port and ISA memory resources to sysfs\n");
 	return;
 }
 
@@ -814,7 +814,7 @@ pci_mmap_resource(struct kobject *kobj, struct bin_attribute *attr,
 
 	if (!pci_mmap_fits(pdev, i, vma, PCI_MMAP_SYSFS)) {
 		WARN(1, "process \"%s\" tried to map 0x%08lx bytes "
-			"at page 0x%08lx on %s BAR %d (start 0x%16Lx, size 0x%16Lx)\n",
+			"at page 0x%08lx on %s BAR %d (start 0x%16llx, size 0x%16llx)\n",
 			current->comm, vma->vm_end-vma->vm_start, vma->vm_pgoff,
 			pci_name(pdev), i,
 			(u64)pci_resource_start(pdev, i),
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 56098b3..8d110cf 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -7,6 +7,8 @@
  *	Copyright 1997 -- 2000 Martin Mares <mj@ucw.cz>
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/delay.h>
 #include <linux/init.h>
@@ -3365,8 +3367,8 @@ resource_size_t pci_specified_resource_alignment(struct pci_dev *dev)
 			if (sscanf(p, "%x:%x.%x%n",
 					&bus, &slot, &func, &count) != 3) {
 				/* Invalid format */
-				printk(KERN_ERR "PCI: Can't parse resource_alignment parameter: %s\n",
-					p);
+				pr_err("Can't parse resource_alignment parameter: %s\n",
+				       p);
 				break;
 			}
 		}
@@ -3499,8 +3501,7 @@ static int __init pci_setup(char *str)
 			} else if (!strncmp(str, "hpmemsize=", 10)) {
 				pci_hotplug_mem_size = memparse(str + 10, &str);
 			} else {
-				printk(KERN_ERR "PCI: Unknown option `%s'\n",
-						str);
+				pr_err("Unknown option `%s'\n", str);
 			}
 		}
 		str = k;
diff --git a/drivers/pci/pcie/aer/aer_inject.c b/drivers/pci/pcie/aer/aer_inject.c
index 95489cd..9f4c3fc 100644
--- a/drivers/pci/pcie/aer/aer_inject.c
+++ b/drivers/pci/pcie/aer/aer_inject.c
@@ -17,6 +17,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/miscdevice.h>
@@ -397,16 +399,14 @@ static int aer_inject(struct aer_error_inj *einj)
 	if (!aer_mask_override && einj->cor_status &&
 	    !(einj->cor_status & ~cor_mask)) {
 		ret = -EINVAL;
-		printk(KERN_WARNING "The correctable error(s) is masked "
-				"by device\n");
+		pr_warn("The correctable error(s) is masked by device\n");
 		spin_unlock_irqrestore(&inject_lock, flags);
 		goto out_put;
 	}
 	if (!aer_mask_override && einj->uncor_status &&
 	    !(einj->uncor_status & ~uncor_mask)) {
 		ret = -EINVAL;
-		printk(KERN_WARNING "The uncorrectable error(s) is masked "
-				"by device\n");
+		pr_warn("The uncorrectable error(s) is masked by device\n");
 		spin_unlock_irqrestore(&inject_lock, flags);
 		goto out_put;
 	}
@@ -459,7 +459,7 @@ static int aer_inject(struct aer_error_inj *einj)
 
 	if (find_aer_device(rpdev, &edev)) {
 		if (!get_service_data(edev)) {
-			printk(KERN_WARNING "AER service is not initialized\n");
+			pr_warn("AER service is not initialized\n");
 			ret = -EINVAL;
 			goto out_put;
 		}
diff --git a/drivers/pci/pcie/aer/aerdrv_errprint.c b/drivers/pci/pcie/aer/aerdrv_errprint.c
index b07a42e..52725cb 100644
--- a/drivers/pci/pcie/aer/aerdrv_errprint.c
+++ b/drivers/pci/pcie/aer/aerdrv_errprint.c
@@ -13,6 +13,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/kernel.h>
@@ -121,7 +123,7 @@ static const char *aer_agent_string[] = {
 	"Transmitter ID"
 };
 
-static void __aer_print_error(const char *prefix,
+static void __aer_print_error(const char *level, const char *prefix,
 			      struct aer_err_info *info)
 {
 	int i, status;
@@ -140,12 +142,10 @@ static void __aer_print_error(const char *prefix,
 			errmsg = i < ARRAY_SIZE(aer_uncorrectable_error_string) ?
 				aer_uncorrectable_error_string[i] : NULL;
 
-		if (errmsg)
-			printk("%s""   [%2d] %-22s%s\n", prefix, i, errmsg,
-				info->first_error == i ? " (First)" : "");
-		else
-			printk("%s""   [%2d] Unknown Error Bit%s\n", prefix, i,
-				info->first_error == i ? " (First)" : "");
+		printk("%s%s   [%2d] %-22s%s\n",
+		       level, prefix, i,
+		       errmsg ? errmsg : "Unknown Error Bit",
+		       info->first_error == i ? " (First)" : "");
 	}
 }
 
@@ -153,47 +153,48 @@ void aer_print_error(struct pci_dev *dev, struct aer_err_info *info)
 {
 	int id = ((dev->bus->number << 8) | dev->devfn);
 	char prefix[44];
+	const char *level = (info->severity == AER_CORRECTABLE)
+		? KERN_WARNING : KERN_ERR;
 
-	snprintf(prefix, sizeof(prefix), "%s%s %s: ",
-		 (info->severity == AER_CORRECTABLE) ? KERN_WARNING : KERN_ERR,
+	snprintf(prefix, sizeof(prefix), "%s %s: ",
 		 dev_driver_string(&dev->dev), dev_name(&dev->dev));
 
 	if (info->status == 0) {
-		printk("%s""PCIe Bus Error: severity=%s, type=Unaccessible, "
-			"id=%04x(Unregistered Agent ID)\n", prefix,
-			aer_error_severity_string[info->severity], id);
+		printk("%s%sPCIe Bus Error: severity=%s, type=Unaccessible, id=%04x(Unregistered Agent ID)\n",
+		       level, prefix,
+		       aer_error_severity_string[info->severity], id);
 	} else {
 		int layer, agent;
 
 		layer = AER_GET_LAYER_ERROR(info->severity, info->status);
 		agent = AER_GET_AGENT(info->severity, info->status);
 
-		printk("%s""PCIe Bus Error: severity=%s, type=%s, id=%04x(%s)\n",
-			prefix, aer_error_severity_string[info->severity],
-			aer_error_layer[layer], id, aer_agent_string[agent]);
+		printk("%s%sPCIe Bus Error: severity=%s, type=%s, id=%04x(%s)\n",
+		       level, prefix, aer_error_severity_string[info->severity],
+		       aer_error_layer[layer], id, aer_agent_string[agent]);
 
-		printk("%s""  device [%04x:%04x] error status/mask=%08x/%08x\n",
-			prefix, dev->vendor, dev->device,
-			info->status, info->mask);
+		printk("%s%s  device [%04x:%04x] error status/mask=%08x/%08x\n",
+		       level, prefix, dev->vendor, dev->device,
+		       info->status, info->mask);
 
-		__aer_print_error(prefix, info);
+		__aer_print_error(level, prefix, info);
 
 		if (info->tlp_header_valid) {
 			unsigned char *tlp = (unsigned char *) &info->tlp;
-			printk("%s""  TLP Header:"
-				" %02x%02x%02x%02x %02x%02x%02x%02x"
-				" %02x%02x%02x%02x %02x%02x%02x%02x\n",
-				prefix, *(tlp + 3), *(tlp + 2), *(tlp + 1), *tlp,
-				*(tlp + 7), *(tlp + 6), *(tlp + 5), *(tlp + 4),
-				*(tlp + 11), *(tlp + 10), *(tlp + 9),
-				*(tlp + 8), *(tlp + 15), *(tlp + 14),
-				*(tlp + 13), *(tlp + 12));
+			printk("%s%s  TLP Header:"
+			       " %02x%02x%02x%02x %02x%02x%02x%02x"
+			       " %02x%02x%02x%02x %02x%02x%02x%02x\n",
+			       level, prefix,
+			       *(tlp + 3), *(tlp + 2), *(tlp + 1), *tlp,
+			       *(tlp + 7), *(tlp + 6), *(tlp + 5), *(tlp + 4),
+			       *(tlp + 11), *(tlp + 10), *(tlp + 9), *(tlp + 8),
+			       *(tlp + 15), *(tlp + 14), *(tlp + 13), *(tlp + 12));
 		}
 	}
 
 	if (info->id && info->error_dev_num > 1 && info->id == id)
-		printk("%s""  Error of this Agent(%04x) is reported first\n",
-			prefix, id);
+		printk("%s%s  Error of this Agent(%04x) is reported first\n",
+		       level, prefix, id);
 }
 
 void aer_print_port_info(struct pci_dev *dev, struct aer_err_info *info)
@@ -238,25 +239,25 @@ void cper_print_aer(const char *prefix, int cper_severity,
 	}
 	layer = AER_GET_LAYER_ERROR(aer_severity, status);
 	agent = AER_GET_AGENT(aer_severity, status);
-	printk("%s""aer_status: 0x%08x, aer_mask: 0x%08x\n",
+	printk("%saer_status: 0x%08x, aer_mask: 0x%08x\n",
 	       prefix, status, mask);
 	cper_print_bits(prefix, status, status_strs, status_strs_size);
-	printk("%s""aer_layer=%s, aer_agent=%s\n", prefix,
+	printk("%saer_layer=%s, aer_agent=%s\n", prefix,
 	       aer_error_layer[layer], aer_agent_string[agent]);
 	if (aer_severity != AER_CORRECTABLE)
-		printk("%s""aer_uncor_severity: 0x%08x\n",
+		printk("%saer_uncor_severity: 0x%08x\n",
 		       prefix, aer->uncor_severity);
 	if (tlp_header_valid) {
 		const unsigned char *tlp;
 		tlp = (const unsigned char *)&aer->header_log;
-		printk("%s""aer_tlp_header:"
-			" %02x%02x%02x%02x %02x%02x%02x%02x"
-			" %02x%02x%02x%02x %02x%02x%02x%02x\n",
-			prefix, *(tlp + 3), *(tlp + 2), *(tlp + 1), *tlp,
-			*(tlp + 7), *(tlp + 6), *(tlp + 5), *(tlp + 4),
-			*(tlp + 11), *(tlp + 10), *(tlp + 9),
-			*(tlp + 8), *(tlp + 15), *(tlp + 14),
-			*(tlp + 13), *(tlp + 12));
+		printk("%saer_tlp_header:"
+		       " %02x%02x%02x%02x %02x%02x%02x%02x"
+		       " %02x%02x%02x%02x %02x%02x%02x%02x\n",
+		       prefix,
+		       *(tlp + 3), *(tlp + 2), *(tlp + 1), *tlp,
+		       *(tlp + 7), *(tlp + 6), *(tlp + 5), *(tlp + 4),
+		       *(tlp + 11), *(tlp + 10), *(tlp + 9), *(tlp + 8),
+		       *(tlp + 15), *(tlp + 14), *(tlp + 13), *(tlp + 12));
 	}
 }
 #endif
diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
index 6892601..86d99e3 100644
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -7,6 +7,8 @@
  * Copyright (C) Shaohua Li (shaohua.li@intel.com)
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
@@ -937,10 +939,10 @@ static int __init pcie_aspm_disable(char *str)
 	if (!strcmp(str, "off")) {
 		aspm_disabled = 1;
 		aspm_support_enabled = false;
-		printk(KERN_INFO "PCIe ASPM is disabled\n");
+		pr_info("PCIe ASPM is disabled\n");
 	} else if (!strcmp(str, "force")) {
 		aspm_force = 1;
-		printk(KERN_INFO "PCIe ASPM is forcedly enabled\n");
+		pr_info("PCIe ASPM is forcedly enabled\n");
 	}
 	return 1;
 }
diff --git a/drivers/pci/pcie/portdrv_pci.c b/drivers/pci/pcie/portdrv_pci.c
index e0610bd..844e12f 100644
--- a/drivers/pci/pcie/portdrv_pci.c
+++ b/drivers/pci/pcie/portdrv_pci.c
@@ -6,6 +6,8 @@
  * Copyright (C) Tom Long Nguyen (tom.l.nguyen@intel.com)
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/kernel.h>
@@ -333,7 +335,7 @@ static struct pci_driver pcie_portdriver = {
 static int __init dmi_pcie_pme_disable_msi(const struct dmi_system_id *d)
 {
 	pr_notice("%s detected: will not use MSI for PCIe PME signaling\n",
-			d->ident);
+		  d->ident);
 	pcie_pme_disable_msi();
 	return 0;
 }
@@ -365,7 +367,7 @@ static int __init pcie_portdrv_init(void)
 
 	retval = pcie_port_bus_register();
 	if (retval) {
-		printk(KERN_WARNING "PCIE: bus_register error: %d\n", retval);
+		pr_warn("bus_register error: %d\n", retval);
 		goto out;
 	}
 	retval = pci_register_driver(&pcie_portdriver);
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 48849ff..6435697 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -2,6 +2,8 @@
  * probe.c - PCI detection and setup code
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/delay.h>
 #include <linux/init.h>
@@ -1140,10 +1142,9 @@ static struct pci_dev *pci_scan_device(struct pci_bus *bus, int devfn)
 			return NULL;
 		/* Card hasn't responded in 60 seconds?  Must be stuck. */
 		if (delay > 60 * 1000) {
-			printk(KERN_WARNING "pci %04x:%02x:%02x.%d: not "
-					"responding\n", pci_domain_nr(bus),
-					bus->number, PCI_SLOT(devfn),
-					PCI_FUNC(devfn));
+			pr_warn("pci %04x:%02x:%02x.%d: not responding\n",
+				pci_domain_nr(bus), bus->number,
+				PCI_SLOT(devfn), PCI_FUNC(devfn));
 			return NULL;
 		}
 	}
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index e8a1406..9367327 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -15,6 +15,8 @@
  *  use the PowerTweak utility (see http://powertweak.sourceforge.net).
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/pci.h>
@@ -2383,7 +2385,7 @@ static void __devinit nvbridge_check_legacy_irq_routing(struct pci_dev *dev)
 	pci_read_config_dword(dev, 0x74, &cfg);
 
 	if (cfg & ((1 << 2) | (1 << 15))) {
-		printk(KERN_INFO "Rewriting irq routing register on MCP55\n");
+		pr_info("Rewriting irq routing register on MCP55\n");
 		cfg &= ~((1 << 2) | (1 << 15));
 		pci_write_config_dword(dev, 0x74, cfg);
 	}
@@ -2881,8 +2883,7 @@ static int __init pci_apply_final_quirks(void)
 	u8 tmp;
 
 	if (pci_cache_line_size)
-		printk(KERN_DEBUG "PCI: CLS %u bytes\n",
-		       pci_cache_line_size << 2);
+		pr_debug("CLS %u bytes\n", pci_cache_line_size << 2);
 
 	for_each_pci_dev(dev) {
 		pci_fixup_device(pci_fixup_final, dev);
@@ -2898,15 +2899,15 @@ static int __init pci_apply_final_quirks(void)
 			if (!tmp || cls == tmp)
 				continue;
 
-			printk(KERN_DEBUG "PCI: CLS mismatch (%u != %u), "
-			       "using %u bytes\n", cls << 2, tmp << 2,
-			       pci_dfl_cache_line_size << 2);
+			pr_debug("CLS mismatch (%u != %u), using %u bytes\n",
+				 cls << 2, tmp << 2,
+				 pci_dfl_cache_line_size << 2);
 			pci_cache_line_size = pci_dfl_cache_line_size;
 		}
 	}
 	if (!pci_cache_line_size) {
-		printk(KERN_DEBUG "PCI: CLS %u bytes, default %u\n",
-		       cls << 2, pci_dfl_cache_line_size << 2);
+		pr_debug("CLS %u bytes, default %u\n",
+			 cls << 2, pci_dfl_cache_line_size << 2);
 		pci_cache_line_size = cls ? cls : pci_dfl_cache_line_size;
 	}
 
diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 1e9e5a5..a17031b 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -17,6 +17,8 @@
  *	     tighter packing. Prefetchable range support.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -66,7 +68,7 @@ static void add_to_list(struct resource_list_x *head,
 
 	tmp = kmalloc(sizeof(*tmp), GFP_KERNEL);
 	if (!tmp) {
-		pr_warning("add_to_list: kmalloc() failed!\n");
+		pr_warn("%s: kmalloc() failed!\n", __func__);
 		return;
 	}
 
@@ -1050,8 +1052,7 @@ pci_assign_unassigned_resources(void)
 	add_list.next = NULL;
 
 	pci_try_num = max_depth + 1;
-	printk(KERN_DEBUG "PCI: max bus depth: %d pci_try_num: %d\n",
-		 max_depth, pci_try_num);
+	pr_debug("max bus depth: %d pci_try_num: %d\n", max_depth, pci_try_num);
 
 again:
 	/* Depth first, calculate sizes and alignments of all
@@ -1083,8 +1084,7 @@ again:
 		goto enable_and_dump;
 	}
 
-	printk(KERN_DEBUG "PCI: No. %d try to assign unassigned res\n",
-			 tried_times + 1);
+	pr_debug("No. %d try to assign unassigned res\n", tried_times + 1);
 
 	/* third times and later will not check if it is leaf */
 	if ((tried_times + 1) > 2)
@@ -1152,8 +1152,7 @@ again:
 		goto enable_all;
 	}
 
-	printk(KERN_DEBUG "PCI: No. %d try to assign unassigned res\n",
-			 tried_times + 1);
+	pr_debug("No. %d try to assign unassigned res\n", tried_times + 1);
 
 	/*
 	 * Try to release leaf bridge's resources that doesn't fit resource of
diff --git a/drivers/pci/slot.c b/drivers/pci/slot.c
index 968cfea..ae5eb8a 100644
--- a/drivers/pci/slot.c
+++ b/drivers/pci/slot.c
@@ -5,6 +5,8 @@
  *	Alex Chiang <achiang@hp.com>
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kobject.h>
 #include <linux/slab.h>
 #include <linux/pci.h>
@@ -410,7 +412,7 @@ static int pci_slot_init(void)
 	pci_slots_kset = kset_create_and_add("slots", NULL,
 						&pci_bus_kset->kobj);
 	if (!pci_slots_kset) {
-		printk(KERN_ERR "PCI: Slot initialization failure\n");
+		pr_err("Slot initialization failure\n");
 		return -ENOMEM;
 	}
 	return 0;
diff --git a/drivers/pci/xen-pcifront.c b/drivers/pci/xen-pcifront.c
index 492b7d8..f9a472c 100644
--- a/drivers/pci/xen-pcifront.c
+++ b/drivers/pci/xen-pcifront.c
@@ -3,6 +3,9 @@
  *
  *   Author: Ryan Wilson <hap9@epoch.ncsc.mil>
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/mm.h>
@@ -288,8 +291,7 @@ static int pci_frontend_enable_msix(struct pci_dev *dev,
 				vector[i] = op.msix_entries[i].vector;
 			}
 		} else {
-			printk(KERN_DEBUG "enable msix get value %x\n",
-				op.value);
+			pr_debug("enable msix get value %x\n", op.value);
 		}
 	} else {
 		dev_err(&dev->dev, "enable msix get err %x\n", err);
@@ -360,12 +362,12 @@ static void pci_frontend_disable_msi(struct pci_dev *dev)
 	err = do_pci_op(pdev, &op);
 	if (err == XEN_PCI_ERR_dev_not_found) {
 		/* XXX No response from backend, what shall we do? */
-		printk(KERN_DEBUG "get no response from backend for disable MSI\n");
+		pr_debug("get no response from backend for disable MSI\n");
 		return;
 	}
 	if (err)
 		/* how can pciback notify us fail? */
-		printk(KERN_DEBUG "get fake response frombackend\n");
+		pr_debug("get fake response from backend\n");
 }
 
 static struct xen_pci_frontend_ops pci_frontend_ops = {
-- 
1.7.5.rc3.dirty

