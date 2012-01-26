Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622Ab2AZSlQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 13:41:16 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:12882 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582Ab2AZSlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 13:41:11 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dhc1bhc31hc1ah668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LYF58H-01-7NE-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Ohad Ben-Cohen <ohad@wizery.com>,
        David Woodhouse <dwmw2@infradead.org>,
        David Brown <davidb@codeaurora.org>, Tony Lindgren <tony@atomide.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Stuart Yoder <b08248@gmail.com>, Scott Wood <scottwood@freescale.com>,
        Hiroshi Doyu <hdoyu@nvidia.com>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 3/6] iommu/vt-d: Implement DOMAIN_ATTR_GEOMETRY attribute
Date: Thu, 26 Jan 2012 19:40:54 +0100
Message-ID: <1327603257-17028-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1327603257-17028-1-git-send-email-joerg.roedel@amd.com>
References: <1327603257-17028-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement the attribute for the Intel IOMMU driver.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/intel-iommu.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index c9c6053..12e7dc1 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -3917,6 +3917,10 @@ static int intel_iommu_domain_init(struct iommu_domain *domain)
 	domain_update_iommu_cap(dmar_domain);
 	domain->priv = dmar_domain;
 
+	domain->geometry.aperture_start = 0;
+	domain->geometry.aperture_end   = __DOMAIN_MAX_ADDR(dmar_domain->gaw);
+	domain->geometry.force_aperture = true;
+
 	return 0;
 }
 
-- 
1.7.5.4


