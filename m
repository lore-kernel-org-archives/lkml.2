Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932598Ab2GKNr3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 09:47:29 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:25555
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757726Ab2GKNjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 09:39:21 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VPS-1(zz146fIzz1202hzz8275bhz2dh668h839hd24he5bhf0ah)
X-WSS-ID: 0M700LF-01-AXH-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 09/27] iommu/amd: Move unmap_flush message to amd_iommu_init_dma_ops()
Date: Wed, 11 Jul 2012 15:38:54 +0200
Message-ID: <1342013952-10174-10-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1342013952-10174-1-git-send-email-joerg.roedel@amd.com>
References: <1342013952-10174-1-git-send-email-joerg.roedel@amd.com>
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
index 45ee0a3..fa50f3a 100644
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
index 4912eca..514556c 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -1700,14 +1700,6 @@ static int __init amd_iommu_init(void)
 
 	amd_iommu_init_api();
 
-	if (iommu_pass_through)
-		goto out;
-
-	if (amd_iommu_unmap_flush)
-		printk(KERN_INFO "AMD-Vi: IO/TLB flush on unmap enabled\n");
-	else
-		printk(KERN_INFO "AMD-Vi: Lazy IO/TLB flushing enabled\n");
-
 	x86_platform.iommu_shutdown = disable_iommus;
 
 out:
-- 
1.7.9.5


