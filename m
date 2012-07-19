Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762Ab2GSLpx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 07:45:53 -0400
Received: from co1ehsobe004.messaging.microsoft.com ([216.32.180.187]:8263
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752076Ab2GSLpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 07:45:49 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bh8275dhz2dh668h839hd24he5bhf0ah)
X-WSS-ID: 0M7EOO7-02-76Z-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 1/2] iommu/amd: Add missing spin_lock initialization
Date: Thu, 19 Jul 2012 13:45:20 +0200
Message-ID: <1342698321-21720-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing spin_lock initialization in
amd_iommu_bind_pasid() function and make lockdep happy
again.

Cc: stable@vger.kernel.org # >= v3.3
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/amd_iommu_v2.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iommu/amd_iommu_v2.c b/drivers/iommu/amd_iommu_v2.c
index 036fe9b..a1f1bc8 100644
--- a/drivers/iommu/amd_iommu_v2.c
+++ b/drivers/iommu/amd_iommu_v2.c
@@ -681,6 +681,8 @@ int amd_iommu_bind_pasid(struct pci_dev *pdev, int pasid,
 
 	atomic_set(&pasid_state->count, 1);
 	init_waitqueue_head(&pasid_state->wq);
+	spin_lock_init(&pasid_state->lock);
+
 	pasid_state->task         = task;
 	pasid_state->mm           = get_task_mm(task);
 	pasid_state->device_state = dev_state;
-- 
1.7.9.5


