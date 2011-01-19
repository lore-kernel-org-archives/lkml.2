Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842Ab1ASU1H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 15:27:07 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:5080 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754145Ab1ASUZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 15:25:59 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6231"; a="70910657"
From: David Brown <davidb@codeaurora.org>
To: linux-arm-msm@vger.kernel.org
Cc: Stepan Moskovchenko <stepanm@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        David Brown <davidb@codeaurora.org>
Subject: [PATCH v2 08/11] msm: timer: Timer support for MSM8960
Date: Wed, 19 Jan 2011 12:25:44 -0800
Message-Id: <1295468747-22796-9-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1295468747-22796-1-git-send-email-davidb@codeaurora.org>
References: <1292384961-8851-1-git-send-email-stepanm@codeaurora.org>
 <1295468747-22796-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stepan Moskovchenko <stepanm@codeaurora.org>

Modify the macros in the MSM timer driver to support the
MSM8960 chip.

Signed-off-by: Stepan Moskovchenko <stepanm@codeaurora.org>
Signed-off-by: David Brown <davidb@codeaurora.org>
---
 arch/arm/mach-msm/timer.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-msm/timer.c b/arch/arm/mach-msm/timer.c
index 5548b15..e7f8e5a 100644
--- a/arch/arm/mach-msm/timer.c
+++ b/arch/arm/mach-msm/timer.c
@@ -55,7 +55,8 @@ enum timer_location {
 #if defined(CONFIG_ARCH_QSD8X50)
 #define DGT_HZ (19200000 / 4) /* 19.2 MHz / 4 by default */
 #define MSM_DGT_SHIFT (0)
-#elif defined(CONFIG_ARCH_MSM7X30) || defined(CONFIG_ARCH_MSM8X60)
+#elif defined(CONFIG_ARCH_MSM7X30) || defined(CONFIG_ARCH_MSM8X60) || \
+				      defined(CONFIG_ARCH_MSM8960)
 #define DGT_HZ (24576000 / 4) /* 24.576 MHz (LPXO) / 4 by default */
 #define MSM_DGT_SHIFT (0)
 #else
@@ -214,7 +215,7 @@ static void __init msm_timer_init(void)
 	} else if (cpu_is_qsd8x50()) {
 		msm_clocks[MSM_CLOCK_GPT].regbase = MSM_CSR_BASE;
 		msm_clocks[MSM_CLOCK_DGT].regbase = MSM_CSR_BASE + 0x10;
-	} else if (cpu_is_msm8x60()) {
+	} else if (cpu_is_msm8x60() || cpu_is_msm8960()) {
 		msm_clocks[MSM_CLOCK_GPT].regbase = MSM_TMR_BASE + 0x04;
 		msm_clocks[MSM_CLOCK_DGT].regbase = MSM_TMR_BASE + 0x24;
 
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

