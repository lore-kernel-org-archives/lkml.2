Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759097Ab2HJJqU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 05:46:20 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:49142
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758292Ab2HJJqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 05:46:18 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah)
X-WSS-ID: 0M8J9T1-01-0Q4-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH] iommu/amd: Fix wrong check for ARRAY_SIZE()
Date: Fri, 10 Aug 2012 11:46:13 +0200
Message-ID: <1344591973-4834-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The check in the for-loop is broken. Fix it and the
boot-crash it causes in AMD IOMMUv2 systems.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/amd_iommu_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index 0a2ea31..18a89b7 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -1111,7 +1111,7 @@ static void print_iommu_info(void)
 
 		if (iommu->cap & (1 << IOMMU_CAP_EFR)) {
 			pr_info("AMD-Vi:  Extended features: ");
-			for (i = 0; ARRAY_SIZE(feat_str); ++i) {
+			for (i = 0; i < ARRAY_SIZE(feat_str); ++i) {
 				if (iommu_feature(iommu, (1ULL << i)))
 					pr_cont(" %s", feat_str[i]);
 			}
-- 
1.7.9.5


