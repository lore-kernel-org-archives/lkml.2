Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076Ab2A0H0k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 02:26:40 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:35395 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756033Ab2A0H0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 02:26:36 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 6/7] iommu, irq: alloc irq_desc for dmar_msi with local node
Date: Thu, 26 Jan 2012 23:25:52 -0800
Message-Id: <1327649153-16477-7-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1327649153-16477-1-git-send-email-yinghai@kernel.org>
References: <1327649153-16477-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4F225196.0137,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also fix the return value checking problem.

create_irq() will return -1 when fail to allocate.
create_irq_nr() will return 0 when fail to allocate.

here only check !irq, so need to change it to create_irq_nr.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/iommu/dmar.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index 35c1e17..c6e9b1a 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -1221,7 +1221,7 @@ int dmar_set_interrupt(struct intel_iommu *iommu)
 	if (iommu->irq)
 		return 0;
 
-	irq = create_irq();
+	irq = create_irq_nr(0, iommu->node);
 	if (!irq) {
 		printk(KERN_ERR "IOMMU: no free vectors\n");
 		return -EINVAL;
-- 
1.7.7

