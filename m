Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757861Ab2I1MZn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 08:25:43 -0400
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:50264
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757797Ab2I1MYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 08:24:21 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202h1d1ah1d2ahzz8275bhz2dh668h839hd24he5bhf0ah11b5h121eh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1155h)
X-WSS-ID: 0MB27SC-01-LL3-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 16/16] iommu/amd: Report irq remapping through IOMMU-API
Date: Fri, 28 Sep 2012 14:24:06 +0200
Message-ID: <1348835046-3262-17-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348835046-3262-1-git-send-email-joerg.roedel@amd.com>
References: <1348835046-3262-1-git-send-email-joerg.roedel@amd.com>
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
index 6fe4ad7..3f616f6 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -3353,6 +3353,8 @@ static int amd_iommu_domain_has_cap(struct iommu_domain *domain,
 	switch (cap) {
 	case IOMMU_CAP_CACHE_COHERENCY:
 		return 1;
+	case IOMMU_CAP_INTR_REMAP:
+		return irq_remapping_enabled;
 	}
 
 	return 0;
-- 
1.7.9.5


