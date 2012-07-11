Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932540Ab2GKNk5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 09:40:57 -0400
Received: from co1ehsobe001.messaging.microsoft.com ([216.32.180.184]:32269
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757775Ab2GKNj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 09:39:29 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah)
X-WSS-ID: 0M700LP-01-AYA-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 26/27] iommu/amd: Print message to system log when irq remapping is enabled
Date: Wed, 11 Jul 2012 15:39:11 +0200
Message-ID: <1342013952-10174-27-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1342013952-10174-1-git-send-email-joerg.roedel@amd.com>
References: <1342013952-10174-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Print an indicator to dmesg to easily find out if interrupt
remapping is enabled of a given system.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/amd_iommu_init.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index 8140fd2..fab4703 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -1196,6 +1196,8 @@ static void print_iommu_info(void)
 		}
 		pr_cont("\n");
 	}
+	if (irq_remapping_enabled)
+		pr_info("AMD-Vi: Interrupt remapping enabled\n");
 }
 
 static int __init amd_iommu_init_pci(void)
-- 
1.7.9.5


