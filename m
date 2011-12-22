Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131Ab1LVOBm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 09:01:42 -0500
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:27710
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752070Ab1LVOBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 09:01:38 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-FB-SS: 13,
X-WSS-ID: 0LWLYYC-02-237-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 2/3] iommu/amd: Init stats for iommu=pt
Date: Thu, 22 Dec 2011 15:01:18 +0100
Message-ID: <1324562479-29755-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1324562479-29755-1-git-send-email-joerg.roedel@amd.com>
References: <1324562479-29755-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The IOMMUv2 driver added a few statistic counter which are
interesting in the iommu=pt mode too. So initialize the
statistic counter for that mode too.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/amd_iommu.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index cfcc524..30e895d 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -3222,6 +3222,8 @@ int __init amd_iommu_init_passthrough(void)
 		attach_device(&dev->dev, pt_domain);
 	}
 
+	amd_iommu_stats_init();
+
 	pr_info("AMD-Vi: Initialized for Passthrough Mode\n");
 
 	return 0;
-- 
1.7.5.4


