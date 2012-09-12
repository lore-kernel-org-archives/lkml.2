Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760806Ab2ILRKd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 13:10:33 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:40192 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932209Ab2ILQ7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 12:59:38 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6832"; a="233521335"
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH 07/24] ARM: msm: Add handle_irq handler for 8660 DT machine
Date: Wed, 12 Sep 2012 09:58:43 -0700
Message-Id: <1347469140-25069-8-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1347469140-25069-1-git-send-email-davidb@codeaurora.org>
References: <1347469140-25069-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Boyd <sboyd@codeaurora.org>

Commit 041f777 (ARM: msm: convert SMP platforms to
CONFIG_MULTI_IRQ_HANDLER, 2011-09-06) forgot to add the
.handle_irq for the DT machine record. Add it so we get
interrupts instead of panics on DT enabled bootloaders.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: David Brown <davidb@codeaurora.org>
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
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

