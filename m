Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733Ab0JZAjN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 20:39:13 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:56366 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390Ab0JZAif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 20:38:35 -0400
From: Fernando Guzman Lugo <x0095840@ti.com>
To: <gregkh@suse.de>
Cc: <felipe.contreras@nokia.com>, <Hiroshi.DOYU@nokia.com>,
        <linux-kernel@vger.kernel.org>, <andy.shevchenko@gmail.com>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Fernando Guzman Lugo <x0095840@ti.com>
Subject: [PATCH 5/8] staging: tidspbridge - use GTP7 for DSP stack dump
Date: Mon, 25 Oct 2010 19:51:43 -0500
Message-Id: <1288054306-4361-6-git-send-email-x0095840@ti.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1288054306-4361-5-git-send-email-x0095840@ti.com>
References: <1288054306-4361-1-git-send-email-x0095840@ti.com>
 <1288054306-4361-2-git-send-email-x0095840@ti.com>
 <1288054306-4361-3-git-send-email-x0095840@ti.com>
 <1288054306-4361-4-git-send-email-x0095840@ti.com>
 <1288054306-4361-5-git-send-email-x0095840@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DSP stack dump is changed to GTP7 due to GPT8 is used
by DSP side apps

Signed-off-by: Fernando Guzman Lugo <x0095840@ti.com>
---
 drivers/staging/tidspbridge/core/dsp-mmu.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/tidspbridge/core/dsp-mmu.c b/drivers/staging/tidspbridge/core/dsp-mmu.c
index 2d4e897..157b743 100644
--- a/drivers/staging/tidspbridge/core/dsp-mmu.c
+++ b/drivers/staging/tidspbridge/core/dsp-mmu.c
@@ -63,9 +63,9 @@ static void mmu_fault_print_stack(struct bridge_dev_context *dev_context)
 
 	load_iotlb_entry(mmu, &e);
 
-	dsp_clk_enable(DSP_CLK_GPT8);
+	dsp_clk_enable(DSP_CLK_GPT7);
 
-	if (dsp_gpt_wait_overflow(DSP_CLK_GPT8, 0xfffffffe, 10)) {
+	if (dsp_gpt_wait_overflow(DSP_CLK_GPT7, 0xfffffffe, 10)) {
 		pr_err("%s: error sending interrupt to DSP\n", __func__);
 		return;
 	}
@@ -75,7 +75,7 @@ static void mmu_fault_print_stack(struct bridge_dev_context *dev_context)
 	iommu_write_reg(mmu, tmp, MMU_IRQSTATUS);
 
 	dump_dsp_stack(dev_context);
-	dsp_clk_disable(DSP_CLK_GPT8);
+	dsp_clk_disable(DSP_CLK_GPT7);
 
 	iopgtable_clear_entry(mmu, fa);
 	free_page((unsigned long)dummy_addr);
-- 
1.6.3.3

