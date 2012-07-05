Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283Ab2GEMjR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 08:39:17 -0400
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:15342
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932589Ab2GEMhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 08:37:11 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah107ah)
X-WSS-ID: 0M6OTPR-01-2VD-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 28/28] iommu/amd: Report irq remapping through IOMMU-API
Date: Thu, 5 Jul 2012 14:36:48 +0200
Message-ID: <1341491808-23083-29-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1341491808-23083-1-git-send-email-joerg.roedel@amd.com>
References: <1341491808-23083-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Report the availability of irq remapping through the
IOMMU-API to allow KVM device passthrough again without
additional module parameter overrides.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/amd_iommu.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 41fe178..e9d08f8 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -3265,6 +3265,8 @@ static int amd_iommu_domain_has_cap(struct iommu_domain *domain,
 	switch (cap) {
 	case IOMMU_CAP_CACHE_COHERENCY:
 		return 1;
+	case IOMMU_CAP_INTR_REMAP:
+		return irq_remapping_enabled;
 	}
 
 	return 0;
-- 
1.7.9.5


