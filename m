Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722Ab2AZSnE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 13:43:04 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:52171 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753479Ab2AZSlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 13:41:13 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dhc1bhc31hc1ah668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LYF58H-02-HLD-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Ohad Ben-Cohen <ohad@wizery.com>,
        David Woodhouse <dwmw2@infradead.org>,
        David Brown <davidb@codeaurora.org>, Tony Lindgren <tony@atomide.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Stuart Yoder <b08248@gmail.com>, Scott Wood <scottwood@freescale.com>,
        Hiroshi Doyu <hdoyu@nvidia.com>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6/6] iommu/tegra: Implement DOMAIN_ATTR_GEOMETRY attribute
Date: Thu, 26 Jan 2012 19:40:57 +0100
Message-ID: <1327603257-17028-7-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1327603257-17028-1-git-send-email-joerg.roedel@amd.com>
References: <1327603257-17028-1-git-send-email-joerg.roedel@amd.com>
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
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/iommu/tegra-gart.c b/drivers/iommu/tegra-gart.c
index b21598f..b60ee49 100644
--- a/drivers/iommu/tegra-gart.c
+++ b/drivers/iommu/tegra-gart.c
@@ -163,6 +163,11 @@ static int gart_iommu_attach_dev(struct iommu_domain *domain,
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
index eb93c82..9614702 100644
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
1.7.5.4


