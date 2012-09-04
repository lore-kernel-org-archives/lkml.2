Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757888Ab2IDWgX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 18:36:23 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:32867 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046Ab2IDWgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 18:36:21 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Hiroshi Doyu <hdoyu@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] dma: tegra: move smmu.h into SMMU driver
Date: Tue,  4 Sep 2012 16:36:15 -0600
Message-Id: <1346798175-28733-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

There's no need to place these defines into arch/arm/mach-tegra/include/.
Move them into the SMMU driver to clean up mach-tegra, as a pre-requisite
for single-zImage.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
Cc: Hiroshi Doyu <hdoyu@nvidia.com>
---
 arch/arm/mach-tegra/include/mach/smmu.h |   63 -------------------------------
 drivers/iommu/tegra-smmu.c              |   41 +++++++++++++++++++-
 2 files changed, 40 insertions(+), 64 deletions(-)
 delete mode 100644 arch/arm/mach-tegra/include/mach/smmu.h

diff --git a/arch/arm/mach-tegra/include/mach/smmu.h b/arch/arm/mach-tegra/include/mach/smmu.h
deleted file mode 100644
index dad403a..0000000
--- a/arch/arm/mach-tegra/include/mach/smmu.h
+++ /dev/null
@@ -1,63 +0,0 @@
-/*
- * IOMMU API for SMMU in Tegra30
- *
- * Copyright (c) 2012, NVIDIA CORPORATION.  All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2, as published by the Free Software Foundation.
- *
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
- */
-
-#ifndef	MACH_SMMU_H
-#define	MACH_SMMU_H
-
-enum smmu_hwgrp {
-	HWGRP_AFI,
-	HWGRP_AVPC,
-	HWGRP_DC,
-	HWGRP_DCB,
-	HWGRP_EPP,
-	HWGRP_G2,
-	HWGRP_HC,
-	HWGRP_HDA,
-	HWGRP_ISP,
-	HWGRP_MPE,
-	HWGRP_NV,
-	HWGRP_NV2,
-	HWGRP_PPCS,
-	HWGRP_SATA,
-	HWGRP_VDE,
-	HWGRP_VI,
-
-	HWGRP_COUNT,
-
-	HWGRP_END = ~0,
-};
-
-#define HWG_AFI		(1 << HWGRP_AFI)
-#define HWG_AVPC	(1 << HWGRP_AVPC)
-#define HWG_DC		(1 << HWGRP_DC)
-#define HWG_DCB		(1 << HWGRP_DCB)
-#define HWG_EPP		(1 << HWGRP_EPP)
-#define HWG_G2		(1 << HWGRP_G2)
-#define HWG_HC		(1 << HWGRP_HC)
-#define HWG_HDA		(1 << HWGRP_HDA)
-#define HWG_ISP		(1 << HWGRP_ISP)
-#define HWG_MPE		(1 << HWGRP_MPE)
-#define HWG_NV		(1 << HWGRP_NV)
-#define HWG_NV2		(1 << HWGRP_NV2)
-#define HWG_PPCS	(1 << HWGRP_PPCS)
-#define HWG_SATA	(1 << HWGRP_SATA)
-#define HWG_VDE		(1 << HWGRP_VDE)
-#define HWG_VI		(1 << HWGRP_VI)
-
-#endif	/* MACH_SMMU_H */
diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c
index c749f96..0b4d62e 100644
--- a/drivers/iommu/tegra-smmu.c
+++ b/drivers/iommu/tegra-smmu.c
@@ -39,9 +39,48 @@
 #include <asm/cacheflush.h>
 
 #include <mach/iomap.h>
-#include <mach/smmu.h>
 #include <mach/tegra-ahb.h>
 
+enum smmu_hwgrp {
+	HWGRP_AFI,
+	HWGRP_AVPC,
+	HWGRP_DC,
+	HWGRP_DCB,
+	HWGRP_EPP,
+	HWGRP_G2,
+	HWGRP_HC,
+	HWGRP_HDA,
+	HWGRP_ISP,
+	HWGRP_MPE,
+	HWGRP_NV,
+	HWGRP_NV2,
+	HWGRP_PPCS,
+	HWGRP_SATA,
+	HWGRP_VDE,
+	HWGRP_VI,
+
+	HWGRP_COUNT,
+
+	HWGRP_END = ~0,
+};
+
+#define HWG_AFI		(1 << HWGRP_AFI)
+#define HWG_AVPC	(1 << HWGRP_AVPC)
+#define HWG_DC		(1 << HWGRP_DC)
+#define HWG_DCB		(1 << HWGRP_DCB)
+#define HWG_EPP		(1 << HWGRP_EPP)
+#define HWG_G2		(1 << HWGRP_G2)
+#define HWG_HC		(1 << HWGRP_HC)
+#define HWG_HDA		(1 << HWGRP_HDA)
+#define HWG_ISP		(1 << HWGRP_ISP)
+#define HWG_MPE		(1 << HWGRP_MPE)
+#define HWG_NV		(1 << HWGRP_NV)
+#define HWG_NV2		(1 << HWGRP_NV2)
+#define HWG_PPCS	(1 << HWGRP_PPCS)
+#define HWG_SATA	(1 << HWGRP_SATA)
+#define HWG_VDE		(1 << HWGRP_VDE)
+#define HWG_VI		(1 << HWGRP_VI)
+
 /* bitmap of the page sizes currently supported */
 #define SMMU_IOMMU_PGSIZES	(SZ_4K)
 
-- 
1.7.0.4

