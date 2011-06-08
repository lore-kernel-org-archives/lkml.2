Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208Ab1FHIgx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 04:36:53 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55107 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754892Ab1FHIf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 04:35:59 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: Joerg Roedel <Joerg.Roedel@amd.com>
Cc: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        David Brown <davidb@codeaurora.org>,
        David Woodhouse <dwmw2@infradead.org>,
        <iommu@lists.linux-foundation.org>, <linux-pci@vger.kernel.org>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH 2/4] msm: iommu: move to drivers/iommu/
Date: Wed,  8 Jun 2011 11:34:20 +0300
Message-Id: <1307522062-19273-3-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1307522062-19273-1-git-send-email-ohad@wizery.com>
References: <1307522062-19273-1-git-send-email-ohad@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This should ease finding similarities with different platforms,
with the intention of solving problems once in a generic framework
which everyone can use.

Compile-tested for MSM8X60.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 arch/arm/mach-msm/Kconfig                          |   12 ------------
 arch/arm/mach-msm/Makefile                         |    2 +-
 drivers/iommu/Kconfig                              |   11 +++++++++++
 drivers/iommu/Makefile                             |    1 +
 .../mach-msm/iommu.c => drivers/iommu/msm-iommu.c  |    0
 5 files changed, 13 insertions(+), 13 deletions(-)
 rename arch/arm/mach-msm/iommu.c => drivers/iommu/msm-iommu.c (100%)

diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
index efb7b7d..14ebda1 100644
--- a/arch/arm/mach-msm/Kconfig
+++ b/arch/arm/mach-msm/Kconfig
@@ -148,18 +148,6 @@ config MACH_MSM8960_RUMI3
 
 endmenu
 
-config MSM_IOMMU
-	bool "MSM IOMMU Support"
-	depends on ARCH_MSM8X60 || ARCH_MSM8960
-	select IOMMU_API
-	default n
-	help
-	  Support for the IOMMUs found on certain Qualcomm SOCs.
-	  These IOMMUs allow virtualization of the address space used by most
-	  cores within the multimedia subsystem.
-
-	  If unsure, say N here.
-
 config IOMMU_PGTABLES_L2
 	def_bool y
 	depends on MSM_IOMMU && MMU && SMP && CPU_DCACHE_DISABLE=n
diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
index 9519fd2..0bf4648 100644
--- a/arch/arm/mach-msm/Makefile
+++ b/arch/arm/mach-msm/Makefile
@@ -3,7 +3,7 @@ obj-y += clock.o
 obj-$(CONFIG_DEBUG_FS) += clock-debug.o
 
 obj-$(CONFIG_MSM_VIC) += irq-vic.o
-obj-$(CONFIG_MSM_IOMMU) += iommu.o iommu_dev.o devices-iommu.o
+obj-$(CONFIG_MSM_IOMMU) += iommu_dev.o devices-iommu.o
 
 obj-$(CONFIG_ARCH_MSM7X00A) += dma.o irq.o acpuclock-arm11.o
 obj-$(CONFIG_ARCH_MSM7X30) += dma.o
diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index 2c5dfb4..c6d667c 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -1,3 +1,14 @@
 # IOMMU_API always gets selected by whoever wants it.
 config IOMMU_API
 	bool
+
+config MSM_IOMMU
+	bool "MSM IOMMU Support"
+	depends on ARCH_MSM8X60 || ARCH_MSM8960
+	select IOMMU_API
+	help
+	  Support for the IOMMUs found on certain Qualcomm SOCs.
+	  These IOMMUs allow virtualization of the address space used by most
+	  cores within the multimedia subsystem.
+
+	  If unsure, say N here.
diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
index 241ba4c..a7e66fa 100644
--- a/drivers/iommu/Makefile
+++ b/drivers/iommu/Makefile
@@ -1 +1,2 @@
 obj-$(CONFIG_IOMMU_API) += iommu.o
+obj-$(CONFIG_MSM_IOMMU) += msm-iommu.o
diff --git a/arch/arm/mach-msm/iommu.c b/drivers/iommu/msm-iommu.c
similarity index 100%
rename from arch/arm/mach-msm/iommu.c
rename to drivers/iommu/msm-iommu.c
-- 
1.7.1

