Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111Ab1LVOCC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 09:02:02 -0500
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:23601
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752701Ab1LVOBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 09:01:32 -0500
X-SpamScore: -5
X-BigFish: VPS-5(z6c9Mzzz1202hzz8275bhz2dh668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LWLYYD-02-23D-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 1/3] iommu/amd: Remove unnecessary cache flushes in amd_iommu_resume
Date: Thu, 22 Dec 2011 15:01:17 +0100
Message-ID: <1324562479-29755-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1324562479-29755-1-git-send-email-joerg.roedel@amd.com>
References: <1324562479-29755-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The caches are already flushed in enable_iommus(), so this
flush is not necessary.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/amd_iommu_init.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index c7a5d7e..38784733 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -1396,13 +1396,6 @@ static void amd_iommu_resume(void)
 
 	/* re-load the hardware */
 	enable_iommus();
-
-	/*
-	 * we have to flush after the IOMMUs are enabled because a
-	 * disabled IOMMU will never execute the commands we send
-	 */
-	for_each_iommu(iommu)
-		iommu_flush_all_caches(iommu);
 }
 
 static int amd_iommu_suspend(void)
-- 
1.7.5.4


