Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751675Ab1DHIRY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 04:17:24 -0400
Received: from ch1outboundpool.messaging.microsoft.com ([216.32.181.182]:50244
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750773Ab1DHIRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 04:17:19 -0400
X-SpamScore: -2
X-BigFish: VPS-2(zzbb2cKzz1202hzz8275bhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LJBR0Q-02-3MD-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
CC: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 4/5] x86/amd-iommu: Add flag to indicate IOTLB support
Date: Fri, 8 Apr 2011 10:17:09 +0200
Message-ID: <1302250630-8183-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1302250630-8183-1-git-send-email-joerg.roedel@amd.com>
References: <1302250630-8183-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a flag to the AMD IOMMU driver to indicate
that all IOMMUs present in the system support device IOTLBs.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/amd_iommu_types.h |    2 ++
 arch/x86/kernel/amd_iommu_init.c       |    4 ++++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/amd_iommu_types.h b/arch/x86/include/asm/amd_iommu_types.h
index f5d184e..cb811c9 100644
--- a/arch/x86/include/asm/amd_iommu_types.h
+++ b/arch/x86/include/asm/amd_iommu_types.h
@@ -250,6 +250,8 @@ extern bool amd_iommu_dump;
 
 /* global flag if IOMMUs cache non-present entries */
 extern bool amd_iommu_np_cache;
+/* Only true if all IOMMUs support device IOTLBs */
+extern bool amd_iommu_iotlb_sup;
 
 /*
  * Make iterating over all IOMMUs easier
diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 8848dda..b6c634f 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -137,6 +137,7 @@ int amd_iommus_present;
 
 /* IOMMUs have a non-present cache? */
 bool amd_iommu_np_cache __read_mostly;
+bool amd_iommu_iotlb_sup __read_mostly = true;
 
 /*
  * The ACPI table parsing functions set this variable on an error
@@ -673,6 +674,9 @@ static void __init init_iommu_from_pci(struct amd_iommu *iommu)
 					MMIO_GET_LD(range));
 	iommu->evt_msi_num = MMIO_MSI_NUM(misc);
 
+	if (!(iommu->cap & (1 << IOMMU_CAP_IOTLB)))
+		amd_iommu_iotlb_sup = false;
+
 	if (!is_rd890_iommu(iommu->dev))
 		return;
 
-- 
1.7.1


