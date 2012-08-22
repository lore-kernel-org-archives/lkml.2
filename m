Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933482Ab2HVXAX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 19:00:23 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:19782 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932677Ab2HVXAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 19:00:17 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6812"; a="226086639"
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 1/2] ARM: MSM: Add handle_irq handler for 8660 DT machine
Date: Wed, 22 Aug 2012 16:00:13 -0700
Message-Id: <1345676414-16635-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1345676414-16635-1-git-send-email-sboyd@codeaurora.org>
References: <1345676414-16635-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 041f777 (ARM: msm: convert SMP platforms to
CONFIG_MULTI_IRQ_HANDLER, 2011-09-06) forgot to add the
.handle_irq for the DT machine record. Add it so we get
interrupts instead of panics on DT enabled bootloaders.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-msm/board-msm8x60.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-msm/board-msm8x60.c b/arch/arm/mach-msm/board-msm8x60.c
index e37a724..13ca9bb 100644
--- a/arch/arm/mach-msm/board-msm8x60.c
+++ b/arch/arm/mach-msm/board-msm8x60.c
@@ -158,6 +158,7 @@ MACHINE_END
 DT_MACHINE_START(MSM_DT, "Qualcomm MSM (Flattened Device Tree)")
 	.map_io = msm8x60_map_io,
 	.init_irq = msm8x60_init_irq,
+	.handle_irq = gic_handle_irq,
 	.init_machine = msm8x60_dt_init,
 	.init_late = msm8x60_init_late,
 	.timer = &msm_timer,
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

