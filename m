Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932394Ab1LENkt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 08:40:49 -0500
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:44858
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932345Ab1LENfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 08:35:09 -0500
X-SpamScore: 3
X-BigFish: VPS3(zzc8kzz1202hzz8275bhz2dh668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-FB-SS: 13,
X-WSS-ID: 0LVQGEC-02-AUI-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 17/22] iommu/amd: Add driver stub for AMD IOMMUv2 support
Date: Mon, 5 Dec 2011 14:34:32 +0100
Message-ID: <1323092077-25501-18-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1323092077-25501-1-git-send-email-joerg.roedel@amd.com>
References: <1323092077-25501-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a Kconfig option for the optional driver. Since it is
optional it can be compiled as a module and will only be
loaded when required by another driver.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/Kconfig        |    8 ++++++++
 drivers/iommu/Makefile       |    1 +
 drivers/iommu/amd_iommu_v2.c |   36 ++++++++++++++++++++++++++++++++++++
 3 files changed, 45 insertions(+), 0 deletions(-)
 create mode 100644 drivers/iommu/amd_iommu_v2.c

diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index 220dfc2..e608a36 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -60,6 +60,14 @@ config AMD_IOMMU_STATS
 	  information to userspace via debugfs.
 	  If unsure, say N.
 
+config AMD_IOMMU_V2
+	tristate "AMD IOMMU Version 2 driver (EXPERIMENTAL)"
+	depends on AMD_IOMMU && EXPERIMENTAL
+	---help---
+	  This option enables support for the AMD IOMMUv2 features of the IOMMU
+	  hardware. Select this option if you want to use devices that support
+	  the the PCI PRI and PASID interface.
+
 # Intel IOMMU support
 config DMAR_TABLE
 	bool
diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
index 2f44487..0e36b49 100644
--- a/drivers/iommu/Makefile
+++ b/drivers/iommu/Makefile
@@ -1,6 +1,7 @@
 obj-$(CONFIG_IOMMU_API) += iommu.o
 obj-$(CONFIG_MSM_IOMMU) += msm_iommu.o msm_iommu_dev.o
 obj-$(CONFIG_AMD_IOMMU) += amd_iommu.o amd_iommu_init.o
+obj-$(CONFIG_AMD_IOMMU_V2) += amd_iommu_v2.o
 obj-$(CONFIG_DMAR_TABLE) += dmar.o
 obj-$(CONFIG_INTEL_IOMMU) += iova.o intel-iommu.o
 obj-$(CONFIG_IRQ_REMAP) += intr_remapping.o
diff --git a/drivers/iommu/amd_iommu_v2.c b/drivers/iommu/amd_iommu_v2.c
new file mode 100644
index 0000000..a19e07d
--- /dev/null
+++ b/drivers/iommu/amd_iommu_v2.c
@@ -0,0 +1,36 @@
+/*
+ * Copyright (C) 2010-2012 Advanced Micro Devices, Inc.
+ * Author: Joerg Roedel <joerg.roedel@amd.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ */
+
+#include <linux/module.h>
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Joerg Roedel <joerg.roedel@amd.com>");
+
+static int __init amd_iommu_v2_init(void)
+{
+	pr_info("AMD IOMMUv2 driver by Joerg Roedel <joerg.roedel@amd.com>");
+
+	return 0;
+}
+
+static void __exit amd_iommu_v2_exit(void)
+{
+}
+
+module_init(amd_iommu_v2_init);
+module_exit(amd_iommu_v2_exit);
-- 
1.7.5.4


