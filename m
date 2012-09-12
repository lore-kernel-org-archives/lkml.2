Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760586Ab2ILQ7a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 12:59:30 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:54548 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760503Ab2ILQ72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 12:59:28 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6832"; a="235815606"
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH 09/24] ARM: msm: Remove call to missing FPGA init on 8660
Date: Wed, 12 Sep 2012 09:58:45 -0700
Message-Id: <1347469140-25069-10-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1347469140-25069-1-git-send-email-davidb@codeaurora.org>
References: <1347469140-25069-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A previous patch[1] added code to initialize an FPGA register on the
8660 "SURF" development platform.  Since this development platform is
not widely available, and there is now a more available device "the
Dragonboard" based on the same core SOC, this change was dropped.

However, the DT code kept a lingering call to this FPGA init function.
Remove it.

[1] https://lkml.org/lkml/2011/8/12/357

Signed-off-by: David Brown <davidb@codeaurora.org>
---
 arch/arm/mach-msm/board-msm8x60.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/arm/mach-msm/board-msm8x60.c b/arch/arm/mach-msm/board-msm8x60.c
index 13ca9bb..ad87207 100644
--- a/arch/arm/mach-msm/board-msm8x60.c
+++ b/arch/arm/mach-msm/board-msm8x60.c
@@ -93,11 +93,6 @@ static struct of_dev_auxdata msm_auxdata_lookup[] __initdata = {
 
 static void __init msm8x60_dt_init(void)
 {
-	if (of_machine_is_compatible("qcom,msm8660-surf")) {
-		printk(KERN_INFO "Init surf UART registers\n");
-		msm8x60_init_uart12dm();
-	}
-
 	of_platform_populate(NULL, of_default_bus_match_table,
 			msm_auxdata_lookup, NULL);
 }
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

