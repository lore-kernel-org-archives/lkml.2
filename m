Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844Ab2ASObE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 09:31:04 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:47829
	"EHLO VA3EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751867Ab2ASOaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 09:30:22 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dhc1bhc31hc1ah668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LY1UY9-02-CW2-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Ohad Ben-Cohen <ohad@wizery.com>,
        David Woodhouse <dwmw2@infradead.org>,
        David Brown <davidb@codeaurora.org>, Tony Lindgren <tony@atomide.com>,
        Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Stuart Yoder <b08248@gmail.com>, Scott Wood <scottwood@freescale.com>,
        Hiroshi Doyu <hdoyu@nvidia.com>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 5/5] iommu/msm: Implement DOMAIN_ATTR_GEOMETRY attribute
Date: Thu, 19 Jan 2012 15:30:05 +0100
Message-ID: <1326983405-319-6-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1326983405-319-1-git-send-email-joerg.roedel@amd.com>
References: <1326983405-319-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement the attribute for the MSM IOMMU driver.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/msm_iommu.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/iommu/msm_iommu.c b/drivers/iommu/msm_iommu.c
index 08a90b8..ea6b7f7 100644
--- a/drivers/iommu/msm_iommu.c
+++ b/drivers/iommu/msm_iommu.c
@@ -226,6 +226,11 @@ static int msm_iommu_domain_init(struct iommu_domain *domain)
 
 	memset(priv->pgtable, 0, SZ_16K);
 	domain->priv = priv;
+
+	domain->geometry.aperture_start = 0;
+	domain->geometry.aperture_end   = (1ULL << 32) - 1;
+	domain->geometry.force_aperture = true;
+
 	return 0;
 
 fail_nomem:
-- 
1.7.5.4


