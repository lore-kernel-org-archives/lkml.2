Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306Ab1FJMIl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 08:08:41 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:29268
	"EHLO CH1EHSOBE012.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756135Ab1FJMId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 08:08:33 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LMKPQ2-01-6LW-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 1/9] x86/amd-iommu: Remove redundant device_flush_dte() calls
Date: Fri, 10 Jun 2011 14:08:41 +0200
Message-ID: <1307707729-29767-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1307707729-29767-1-git-send-email-joerg.roedel@amd.com>
References: <1307707729-29767-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove these function calls from places where the function
has already been called by another function.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 7c3a95e..cc6f6da6 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1798,7 +1798,6 @@ static int device_change_notifier(struct notifier_block *nb,
 		goto out;
 	}
 
-	device_flush_dte(dev);
 	iommu_completion_wait(iommu);
 
 out:
@@ -2605,7 +2604,6 @@ static void amd_iommu_detach_device(struct iommu_domain *dom,
 	if (!iommu)
 		return;
 
-	device_flush_dte(dev);
 	iommu_completion_wait(iommu);
 }
 
-- 
1.7.4.1


