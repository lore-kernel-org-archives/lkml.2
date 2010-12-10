Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797Ab0LJD5I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 22:57:08 -0500
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:60922 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755412Ab0LJD5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 22:57:02 -0500
From: Fernando Guzman Lugo <fernando.lugo@ti.com>
To: <omar.ramirez@ti.com>
Cc: <linux-kernel@vger.kernel.org>, <felipe.contreras@gmail.com>, <nm@ti.com>,
        <ohad@wizery.com>, Fernando Guzman Lugo <fernando.lugo@ti.com>
Subject: [PATCHv2 1/4] staging: tidspbridge - use GTP7 for DSP stack dump
Date: Thu,  9 Dec 2010 21:55:39 -0600
Message-Id: <1291953342-4905-2-git-send-email-fernando.lugo@ti.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1291953342-4905-1-git-send-email-fernando.lugo@ti.com>
References: <1291953342-4905-1-git-send-email-fernando.lugo@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DSP stack dump is changed to GTP7 due to GPT8 is used
by DSP side apps

Signed-off-by: Fernando Guzman Lugo <fernando.lugo@ti.com>
---
 drivers/staging/tidspbridge/core/ue_deh.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/tidspbridge/core/ue_deh.c b/drivers/staging/tidspbridge/core/ue_deh.c
index 3430418..1e30ce8 100644
--- a/drivers/staging/tidspbridge/core/ue_deh.c
+++ b/drivers/staging/tidspbridge/core/ue_deh.c
@@ -193,15 +193,15 @@ static void mmu_fault_print_stack(struct bridge_dev_context *dev_context)
 			HW_PAGE_SIZE4KB, 1,
 			&map_attrs, HW_SET, HW_SET);
 
-	dsp_clk_enable(DSP_CLK_GPT8);
+	dsp_clk_enable(DSP_CLK_GPT7);
 
-	dsp_gpt_wait_overflow(DSP_CLK_GPT8, 0xfffffffe);
+	dsp_gpt_wait_overflow(DSP_CLK_GPT7, 0xfffffffe);
 
 	/* Clear MMU interrupt */
 	hw_mmu_event_ack(resources->dw_dmmu_base,
 			HW_MMU_TRANSLATION_FAULT);
 	dump_dsp_stack(dev_context);
-	dsp_clk_disable(DSP_CLK_GPT8);
+	dsp_clk_disable(DSP_CLK_GPT7);
 
 	hw_mmu_disable(resources->dw_dmmu_base);
 	free_page((unsigned long)dummy_va_addr);
-- 
1.7.3.2

