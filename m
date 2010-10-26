Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048Ab0JZAij (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 20:38:39 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:46197 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753874Ab0JZAih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 20:38:37 -0400
From: Fernando Guzman Lugo <x0095840@ti.com>
To: <gregkh@suse.de>
Cc: <felipe.contreras@nokia.com>, <Hiroshi.DOYU@nokia.com>,
        <linux-kernel@vger.kernel.org>, <andy.shevchenko@gmail.com>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Fernando Guzman Lugo <x0095840@ti.com>
Subject: [PATCH 6/8] staging: tidspbridge - remove disabling twl when printing DSP stack
Date: Mon, 25 Oct 2010 19:51:44 -0500
Message-Id: <1288054306-4361-7-git-send-email-x0095840@ti.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1288054306-4361-6-git-send-email-x0095840@ti.com>
References: <1288054306-4361-1-git-send-email-x0095840@ti.com>
 <1288054306-4361-2-git-send-email-x0095840@ti.com>
 <1288054306-4361-3-git-send-email-x0095840@ti.com>
 <1288054306-4361-4-git-send-email-x0095840@ti.com>
 <1288054306-4361-5-git-send-email-x0095840@ti.com>
 <1288054306-4361-6-git-send-email-x0095840@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now the SHM segments are not in lock tlbs, instead
they are in translation tables. So we cannot disable
twl in order to get the DSP stack dump.

Signed-off-by: Fernando Guzman Lugo <x0095840@ti.com>
---
 drivers/staging/tidspbridge/core/dsp-mmu.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/tidspbridge/core/dsp-mmu.c b/drivers/staging/tidspbridge/core/dsp-mmu.c
index 157b743..3a00087 100644
--- a/drivers/staging/tidspbridge/core/dsp-mmu.c
+++ b/drivers/staging/tidspbridge/core/dsp-mmu.c
@@ -43,14 +43,6 @@ static void mmu_fault_print_stack(struct bridge_dev_context *dev_context)
 	if (!dummy_addr)
 		return;
 
-	/*
-	 * Before acking the MMU fault, let's make sure MMU can only
-	 * access entry #0. Then add a new entry so that the DSP OS
-	 * can continue in order to dump the stack.
-	 */
-	tmp = iommu_read_reg(mmu, MMU_CNTL);
-	tmp &= ~MMU_CNTL_TWL_EN;
-	iommu_write_reg(mmu, tmp, MMU_CNTL);
 	fa = iommu_read_reg(mmu, MMU_FAULT_AD);
 	e.da = fa & PAGE_MASK;
 	e.pa = virt_to_phys(dummy_addr);
-- 
1.6.3.3

