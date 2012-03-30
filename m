Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761075Ab2C3SqX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 14:46:23 -0400
Received: from mga01.intel.com ([192.55.52.88]:44484 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761008Ab2C3SqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 14:46:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="135792275"
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: Joerg Roedel <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org,
        David Woodhouse <dwmw2@infradead.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH 01/10] iommu: Rename intr_remapping files to intel_intr_remapping
Date: Fri, 30 Mar 2012 11:46:59 -0700
Message-Id: <1333133228-3134-2-git-send-email-suresh.b.siddha@intel.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1333133228-3134-1-git-send-email-suresh.b.siddha@intel.com>
References: <1333133228-3134-1-git-send-email-suresh.b.siddha@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

The files contain code mostly relevant for the Intel
implementation of interrupt remapping. Make that visible in
the file names. Also inline intr_remapping.h into
intr_remapping.c because it is only included there and the
content is very small. So there is no reason for a seperate
header file.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Acked-by: Yinghai Lu <yinghai@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 drivers/iommu/Makefile                             |    2 +-
 .../{intr_remapping.c => intel_intr_remapping.c}   |   17 ++++++++++++++++-
 drivers/iommu/intr_remapping.h                     |   17 -----------------
 3 files changed, 17 insertions(+), 19 deletions(-)
 rename drivers/iommu/{intr_remapping.c => intel_intr_remapping.c} (98%)
 delete mode 100644 drivers/iommu/intr_remapping.h

diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
index 7ad7a3b..1533ebf 100644
--- a/drivers/iommu/Makefile
+++ b/drivers/iommu/Makefile
@@ -4,7 +4,7 @@ obj-$(CONFIG_AMD_IOMMU) += amd_iommu.o amd_iommu_init.o
 obj-$(CONFIG_AMD_IOMMU_V2) += amd_iommu_v2.o
 obj-$(CONFIG_DMAR_TABLE) += dmar.o
 obj-$(CONFIG_INTEL_IOMMU) += iova.o intel-iommu.o
-obj-$(CONFIG_IRQ_REMAP) += intr_remapping.o
+obj-$(CONFIG_IRQ_REMAP) += intel_intr_remapping.o
 obj-$(CONFIG_OMAP_IOMMU) += omap-iommu.o
 obj-$(CONFIG_OMAP_IOVMM) += omap-iovmm.o
 obj-$(CONFIG_OMAP_IOMMU_DEBUG) += omap-iommu-debug.o
diff --git a/drivers/iommu/intr_remapping.c b/drivers/iommu/intel_intr_remapping.c
similarity index 98%
rename from drivers/iommu/intr_remapping.c
rename to drivers/iommu/intel_intr_remapping.c
index 6777ca0..212fff0 100644
--- a/drivers/iommu/intr_remapping.c
+++ b/drivers/iommu/intel_intr_remapping.c
@@ -10,10 +10,25 @@
 #include <asm/smp.h>
 #include <asm/cpu.h>
 #include <linux/intel-iommu.h>
-#include "intr_remapping.h"
 #include <acpi/acpi.h>
 #include <asm/pci-direct.h>
 
+struct ioapic_scope {
+	struct intel_iommu *iommu;
+	unsigned int id;
+	unsigned int bus;	/* PCI bus number */
+	unsigned int devfn;	/* PCI devfn number */
+};
+
+struct hpet_scope {
+	struct intel_iommu *iommu;
+	u8 id;
+	unsigned int bus;
+	unsigned int devfn;
+};
+
+#define IR_X2APIC_MODE(mode) (mode ? (1 << 11) : 0)
+
 static struct ioapic_scope ir_ioapic[MAX_IO_APICS];
 static struct hpet_scope ir_hpet[MAX_HPET_TBS];
 static int ir_ioapic_num, ir_hpet_num;
diff --git a/drivers/iommu/intr_remapping.h b/drivers/iommu/intr_remapping.h
deleted file mode 100644
index 5662fec..0000000
--- a/drivers/iommu/intr_remapping.h
+++ /dev/null
@@ -1,17 +0,0 @@
-#include <linux/intel-iommu.h>
-
-struct ioapic_scope {
-	struct intel_iommu *iommu;
-	unsigned int id;
-	unsigned int bus;	/* PCI bus number */
-	unsigned int devfn;	/* PCI devfn number */
-};
-
-struct hpet_scope {
-	struct intel_iommu *iommu;
-	u8 id;
-	unsigned int bus;
-	unsigned int devfn;
-};
-
-#define IR_X2APIC_MODE(mode) (mode ? (1 << 11) : 0)
-- 
1.7.6.5

