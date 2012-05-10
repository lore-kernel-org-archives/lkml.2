Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757119Ab2EJHp4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 03:45:56 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:8548 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757075Ab2EJHpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 03:45:53 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 10 May 2012 00:45:03 -0700
From: Hiroshi DOYU <hdoyu@nvidia.com>
To: <hdoyu@nvidia.com>
CC: <linux-tegra@vger.kernel.org>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Bharat Nihalani <bnihalani@nvidia.com>,
        Vandana Salve <vsalve@nvidia.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] iommu/tegra: gart: Fix register offset correctly
Date: Thu, 10 May 2012 10:45:32 +0300
Message-ID: <1336635940-31068-1-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DT passes the exact GART register ranges without any overlapping with
MC register ranges. GART register offset needs to be adjusted by one
passed by DT correctly.

Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
---
 .../bindings/iommu/nvidia,tegra20-gart.txt         |    6 +++---
 drivers/iommu/tegra-gart.c                         |    7 ++++---
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/Documentation/devicetree/bindings/iommu/nvidia,tegra20-gart.txt b/Documentation/devicetree/bindings/iommu/nvidia,tegra20-gart.txt
index 2d87b91..099d936 100644
--- a/Documentation/devicetree/bindings/iommu/nvidia,tegra20-gart.txt
+++ b/Documentation/devicetree/bindings/iommu/nvidia,tegra20-gart.txt
@@ -7,8 +7,8 @@ Required properties:
 
 Example:
 
-	gart: gart@7000f000 {
+	gart {
 		compatible = "nvidia,tegra20-gart";
-		reg = < 0x7000f000 0x00000100    /* controller registers */
-		        0x58000000 0x02000000 >; /* GART aperture */
+		reg = <0x7000f024 0x00000018	/* controller registers */
+		       0x58000000 0x02000000>;	/* GART aperture */
 	};
diff --git a/drivers/iommu/tegra-gart.c b/drivers/iommu/tegra-gart.c
index 40533bb..0c0a377 100644
--- a/drivers/iommu/tegra-gart.c
+++ b/drivers/iommu/tegra-gart.c
@@ -36,9 +36,10 @@
 /* bitmap of the page sizes currently supported */
 #define GART_IOMMU_PGSIZES	(SZ_4K)
 
-#define GART_CONFIG		0x24
-#define GART_ENTRY_ADDR		0x28
-#define GART_ENTRY_DATA		0x2c
+#define GART_REG_BASE		0x24
+#define GART_CONFIG		(0x24 - GART_REG_BASE)
+#define GART_ENTRY_ADDR		(0x28 - GART_REG_BASE)
+#define GART_ENTRY_DATA		(0x2c - GART_REG_BASE)
 #define GART_ENTRY_PHYS_ADDR_VALID	(1 << 31)
 
 #define GART_PAGE_SHIFT		12
-- 
1.7.5.4

