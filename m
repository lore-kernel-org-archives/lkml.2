Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319Ab1IFMoR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 08:44:17 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:42565 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754077Ab1IFMoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 08:44:12 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LR3Q0B-01-8L4-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH] iommu/core: Use PAGE_SIZE instead of hard-coded value
Date: Tue, 6 Sep 2011 14:42:06 +0200
Message-ID: <1315312926-8064-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the hard-coded 4kb by PAGE_SIZE to make iommu-api
implementations possible on architectures where
PAGE_SIZE != 4kb.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/iommu.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index e61a9ba..30b0644 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -100,7 +100,7 @@ int iommu_map(struct iommu_domain *domain, unsigned long iova,
 {
 	size_t size;
 
-	size         = 0x1000UL << gfp_order;
+	size         = PAGE_SIZE << gfp_order;
 
 	BUG_ON(!IS_ALIGNED(iova | paddr, size));
 
@@ -112,7 +112,7 @@ int iommu_unmap(struct iommu_domain *domain, unsigned long iova, int gfp_order)
 {
 	size_t size;
 
-	size         = 0x1000UL << gfp_order;
+	size         = PAGE_SIZE << gfp_order;
 
 	BUG_ON(!IS_ALIGNED(iova, size));
 
-- 
1.7.4.1


