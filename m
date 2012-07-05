Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932555Ab2GEMhE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 08:37:04 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:46710
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932356Ab2GEMhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 08:37:00 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VPS-1(zz146fIzz1202hzz8275bhz2dh668h839hd24he5bhf0ah107ah)
X-WSS-ID: 0M6OTPI-01-2UT-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 09/28] iommu/amd: Move unmap_flush message to amd_iommu_init_dma_ops()
Date: Thu, 5 Jul 2012 14:36:29 +0200
Message-ID: <1341491808-23083-10-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1341491808-23083-1-git-send-email-joerg.roedel@amd.com>
References: <1341491808-23083-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The message belongs there anyway, so move it to that
function.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/amd_iommu.c      |    5 +++++
 drivers/iommu/amd_iommu_init.c |    8 --------
 2 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index cfa01c4..569800f 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -2962,6 +2962,11 @@ int __init amd_iommu_init_dma_ops(void)
 
 	amd_iommu_stats_init();
 
+	if (amd_iommu_unmap_flush)
+		pr_info("AMD-Vi: IO/TLB flush on unmap enabled\n");
+	else
+		pr_info("AMD-Vi: Lazy IO/TLB flushing enabled\n");
+
 	return 0;
 
 free_domains:
diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index 2324f9b..ab3bc19 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -1706,14 +1706,6 @@ static int __init amd_iommu_init(void)
 
 	amd_iommu_init_api();
 
-	if (iommu_pass_through)
-		goto out;
-
-	if (amd_iommu_unmap_flush)
-		printk(KERN_INFO "AMD-Vi: IO/TLB flush on unmap enabled\n");
-	else
-		printk(KERN_INFO "AMD-Vi: Lazy IO/TLB flushing enabled\n");
-
 out:
 	return ret;
 
-- 
1.7.9.5


