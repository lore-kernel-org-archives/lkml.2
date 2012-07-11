Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757252Ab2GKKtc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 06:49:32 -0400
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:8410
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753085Ab2GKKt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 06:49:29 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah)
X-WSS-ID: 0M6ZSQB-01-0H0-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Hiroshi DOYU <hdoyu@nvidia.com>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6/7] iommu/tegra: Implement DOMAIN_ATTR_GEOMETRY attribute
Date: Wed, 11 Jul 2012 12:49:22 +0200
Message-ID: <1342003763-8139-7-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1342003763-8139-1-git-send-email-joerg.roedel@amd.com>
References: <1342003763-8139-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi DOYU <hdoyu@nvidia.com>

Implement the attribute for the Tegra IOMMU drivers.

Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/tegra-gart.c |    5 +++++
 drivers/iommu/tegra-smmu.c |    5 +++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/iommu/tegra-gart.c b/drivers/iommu/tegra-gart.c
index 0c0a377..c16e8fc 100644
--- a/drivers/iommu/tegra-gart.c
+++ b/drivers/iommu/tegra-gart.c
@@ -165,6 +165,11 @@ static int gart_iommu_attach_dev(struct iommu_domain *domain,
 		return -EINVAL;
 	domain->priv = gart;
 
+	domain->geometry.aperture_start = gart->iovmm_base;
+	domain->geometry.aperture_end   = gart->iovmm_base +
+					gart->page_count * GART_PAGE_SIZE - 1;
+	domain->geometry.force_aperture = true;
+
 	client = devm_kzalloc(gart->dev, sizeof(*c), GFP_KERNEL);
 	if (!client)
 		return -ENOMEM;
diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c
index ecd6790..96e73d5 100644
--- a/drivers/iommu/tegra-smmu.c
+++ b/drivers/iommu/tegra-smmu.c
@@ -807,6 +807,11 @@ found:
 	spin_unlock_irqrestore(&as->lock, flags);
 	domain->priv = as;
 
+	domain->geometry.aperture_start = smmu->iovmm_base;
+	domain->geometry.aperture_end   = smmu->iovmm_base +
+		smmu->page_count * SMMU_PAGE_SIZE - 1;
+	domain->geometry.force_aperture = true;
+
 	dev_dbg(smmu->dev, "smmu_as@%p\n", as);
 	return 0;
 
-- 
1.7.9.5


