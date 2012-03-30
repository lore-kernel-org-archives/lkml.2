Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761256Ab2C3SrS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 14:47:18 -0400
Received: from mga01.intel.com ([192.55.52.88]:57430 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761186Ab2C3Sqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 14:46:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="135792352"
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, Joerg Roedel <joerg.roedel@amd.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 10/10] iommu: rename intr_remapping.[ch] to irq_remapping.[ch]
Date: Fri, 30 Mar 2012 11:47:08 -0700
Message-Id: <1333133228-3134-11-git-send-email-suresh.b.siddha@intel.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1333133228-3134-1-git-send-email-suresh.b.siddha@intel.com>
References: <1333133228-3134-1-git-send-email-suresh.b.siddha@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the file names consistent with the naming conventions of irq subsystem.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Alex Williamson <alex.williamson@redhat.com>
---
 .../asm/{intr_remapping.h => irq_remapping.h}      |    0
 .../asm/{intr_remapping.h => irq_remapping.h}      |    6 +++---
 arch/x86/kernel/apic/apic.c                        |    2 +-
 arch/x86/kernel/apic/io_apic.c                     |    2 +-
 drivers/iommu/Makefile                             |    2 +-
 drivers/iommu/dmar.c                               |    2 +-
 drivers/iommu/intel-iommu.c                        |    2 +-
 ...ntel_intr_remapping.c => intel_irq_remapping.c} |    4 ++--
 .../iommu/{intr_remapping.c => irq_remapping.c}    |    2 +-
 .../iommu/{intr_remapping.h => irq_remapping.h}    |    6 +++---
 10 files changed, 14 insertions(+), 14 deletions(-)
 rename arch/ia64/include/asm/{intr_remapping.h => irq_remapping.h} (100%)
 rename arch/x86/include/asm/{intr_remapping.h => irq_remapping.h} (97%)
 rename drivers/iommu/{intel_intr_remapping.c => intel_irq_remapping.c} (99%)
 rename drivers/iommu/{intr_remapping.c => irq_remapping.c} (99%)
 rename drivers/iommu/{intr_remapping.h => irq_remapping.h} (96%)

diff --git a/arch/ia64/include/asm/intr_remapping.h b/arch/ia64/include/asm/irq_remapping.h
similarity index 100%
rename from arch/ia64/include/asm/intr_remapping.h
rename to arch/ia64/include/asm/irq_remapping.h
diff --git a/arch/x86/include/asm/intr_remapping.h b/arch/x86/include/asm/irq_remapping.h
similarity index 97%
rename from arch/x86/include/asm/intr_remapping.h
rename to arch/x86/include/asm/irq_remapping.h
index f9cbbcb..dcb0c72 100644
--- a/arch/x86/include/asm/intr_remapping.h
+++ b/arch/x86/include/asm/irq_remapping.h
@@ -19,8 +19,8 @@
  * the x86 interrupt management code.
  */
 
-#ifndef __X86_INTR_REMAPPING_H
-#define __X86_INTR_REMAPPING_H
+#ifndef __X86_IRQ_REMAPPING_H
+#define __X86_IRQ_REMAPPING_H
 
 #ifdef CONFIG_IRQ_REMAP
 
@@ -100,4 +100,4 @@ static inline int setup_hpet_msi_remapped(unsigned int irq, unsigned int id)
 }
 #endif /* CONFIG_IRQ_REMAP */
 
-#endif /* __X86_INTR_REMAPPING_H */
+#endif /* __X86_IRQ_REMAPPING_H */
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 4246191..313c223 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -35,7 +35,7 @@
 #include <linux/smp.h>
 #include <linux/mm.h>
 
-#include <asm/intr_remapping.h>
+#include <asm/irq_remapping.h>
 #include <asm/perf_event.h>
 #include <asm/x86_init.h>
 #include <asm/pgalloc.h>
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index abbbcd4..ef0648c 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -57,7 +57,7 @@
 #include <asm/msidef.h>
 #include <asm/hypertransport.h>
 #include <asm/setup.h>
-#include <asm/intr_remapping.h>
+#include <asm/irq_remapping.h>
 #include <asm/hpet.h>
 #include <asm/hw_irq.h>
 
diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
index 823e1cf..3e5e82a 100644
--- a/drivers/iommu/Makefile
+++ b/drivers/iommu/Makefile
@@ -4,7 +4,7 @@ obj-$(CONFIG_AMD_IOMMU) += amd_iommu.o amd_iommu_init.o
 obj-$(CONFIG_AMD_IOMMU_V2) += amd_iommu_v2.o
 obj-$(CONFIG_DMAR_TABLE) += dmar.o
 obj-$(CONFIG_INTEL_IOMMU) += iova.o intel-iommu.o
-obj-$(CONFIG_IRQ_REMAP) += intel_intr_remapping.o intr_remapping.o
+obj-$(CONFIG_IRQ_REMAP) += intel_irq_remapping.o irq_remapping.o
 obj-$(CONFIG_OMAP_IOMMU) += omap-iommu.o
 obj-$(CONFIG_OMAP_IOVMM) += omap-iovmm.o
 obj-$(CONFIG_OMAP_IOMMU_DEBUG) += omap-iommu-debug.o
diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index ee74f69..5ef65cf 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -36,7 +36,7 @@
 #include <linux/tboot.h>
 #include <linux/dmi.h>
 #include <linux/slab.h>
-#include <asm/intr_remapping.h>
+#include <asm/irq_remapping.h>
 #include <asm/iommu_table.h>
 
 #define PREFIX "DMAR: "
diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 3c48ce2..430224b 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -42,7 +42,7 @@
 #include <linux/dmi.h>
 #include <linux/pci-ats.h>
 #include <linux/memblock.h>
-#include <asm/intr_remapping.h>
+#include <asm/irq_remapping.h>
 #include <asm/cacheflush.h>
 #include <asm/iommu.h>
 
diff --git a/drivers/iommu/intel_intr_remapping.c b/drivers/iommu/intel_irq_remapping.c
similarity index 99%
rename from drivers/iommu/intel_intr_remapping.c
rename to drivers/iommu/intel_irq_remapping.c
index efeb601..b4d3950 100644
--- a/drivers/iommu/intel_intr_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -11,11 +11,11 @@
 #include <asm/cpu.h>
 #include <linux/intel-iommu.h>
 #include <acpi/acpi.h>
-#include <asm/intr_remapping.h>
+#include <asm/irq_remapping.h>
 #include <asm/pci-direct.h>
 #include <asm/msidef.h>
 
-#include "intr_remapping.h"
+#include "irq_remapping.h"
 
 struct ioapic_scope {
 	struct intel_iommu *iommu;
diff --git a/drivers/iommu/intr_remapping.c b/drivers/iommu/irq_remapping.c
similarity index 99%
rename from drivers/iommu/intr_remapping.c
rename to drivers/iommu/irq_remapping.c
index 523a7b3..1cf350e 100644
--- a/drivers/iommu/intr_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -2,7 +2,7 @@
 #include <linux/string.h>
 #include <linux/errno.h>
 
-#include "intr_remapping.h"
+#include "irq_remapping.h"
 
 int irq_remapping_enabled;
 
diff --git a/drivers/iommu/intr_remapping.h b/drivers/iommu/irq_remapping.h
similarity index 96%
rename from drivers/iommu/intr_remapping.h
rename to drivers/iommu/irq_remapping.h
index bd5d98f..b12974c 100644
--- a/drivers/iommu/intr_remapping.h
+++ b/drivers/iommu/irq_remapping.h
@@ -19,8 +19,8 @@
  * remapping drivers but with no need to be visible outside of the IOMMU layer.
  */
 
-#ifndef __INTR_REMAPPING_H
-#define __INTR_REMAPPING_H
+#ifndef __IRQ_REMAPPING_H
+#define __IRQ_REMAPPING_H
 
 #ifdef CONFIG_IRQ_REMAP
 
@@ -85,4 +85,4 @@ extern struct irq_remap_ops intel_irq_remap_ops;
 
 #endif /* CONFIG_IRQ_REMAP */
 
-#endif /* __INTR_REMAPPING_H */
+#endif /* __IRQ_REMAPPING_H */
-- 
1.7.6.5

