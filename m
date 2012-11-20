Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867Ab2KTBGL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 20:06:11 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:43423 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941Ab2KTBGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 20:06:08 -0500
From: Omar Ramirez Luna <omar.luna@linaro.org>
To: Tony Lindgren <tony@atomide.com>, Joerg Roedel <joro@8bytes.org>
Cc: Russell King <linux@arm.linux.org.uk>, Ohad Ben-Cohen <ohad@wizery.com>,
        Omar Ramirez Luna <omar.luna@linaro.org>, Ido Yariv <ido@wizery.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Paul Walmsley <paul@pwsan.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: [PATCH v5 1/5] iommu/omap: remove redundant clock handling on ISR
Date: Mon, 19 Nov 2012 19:05:48 -0600
Message-Id: <1353373552-16039-2-git-send-email-omar.luna@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1353373552-16039-1-git-send-email-omar.luna@linaro.org>
References: <1353373552-16039-1-git-send-email-omar.luna@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the interrupt to be generated, the mmu clock should be already
enabled while translating a virtual address, so, this call to clock
handling is just increasing/decreasing the counter.

This works now, because its users need the same clock and they
indirectly power the mmu, in this interrupt context the handling of
clocks inside the ISR doesn't seem to be needed nor helping.

Next patch should also correct the dependency on clients to handle
iommu clocks.

Signed-off-by: Omar Ramirez Luna <omar.luna@linaro.org>
---
 drivers/iommu/omap-iommu.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/omap-iommu.c b/drivers/iommu/omap-iommu.c
index badc17c..6b1288c 100644
--- a/drivers/iommu/omap-iommu.c
+++ b/drivers/iommu/omap-iommu.c
@@ -807,9 +807,7 @@ static irqreturn_t iommu_fault_handler(int irq, void *data)
 	if (!obj->refcount)
 		return IRQ_NONE;
 
-	clk_enable(obj->clk);
 	errs = iommu_report_fault(obj, &da);
-	clk_disable(obj->clk);
 	if (errs == 0)
 		return IRQ_HANDLED;
 
-- 
1.7.4.1

