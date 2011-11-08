Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933135Ab1KHSez (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 13:34:55 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:8128 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933072Ab1KHSeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 13:34:19 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6524"; a="135802404"
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 2/8] msm: timer: Cleanup #includes and #defines
Date: Tue,  8 Nov 2011 10:34:04 -0800
Message-Id: <1320777250-23263-3-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.8.rc0.46.g5ae0f
In-Reply-To: <1320777250-23263-1-git-send-email-sboyd@codeaurora.org>
References: <1320777250-23263-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused/unnecessary #defines, #includes, and use the BIT
macro appropriately.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-msm/timer.c |   26 +++++++-------------------
 1 files changed, 7 insertions(+), 19 deletions(-)

diff --git a/arch/arm/mach-msm/timer.c b/arch/arm/mach-msm/timer.c
index 1cab559..ce389ca 100644
--- a/arch/arm/mach-msm/timer.c
+++ b/arch/arm/mach-msm/timer.c
@@ -13,44 +13,32 @@
  *
  */
 
+#include <linux/clocksource.h>
+#include <linux/clockchips.h>
 #include <linux/init.h>
-#include <linux/time.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
-#include <linux/clk.h>
-#include <linux/clockchips.h>
-#include <linux/delay.h>
 #include <linux/io.h>
 
 #include <asm/mach/time.h>
 #include <asm/hardware/gic.h>
+#include <asm/localtimer.h>
 
 #include <mach/msm_iomap.h>
 #include <mach/cpu.h>
+#include <mach/board.h>
 
 #define TIMER_MATCH_VAL         0x0000
 #define TIMER_COUNT_VAL         0x0004
 #define TIMER_ENABLE            0x0008
-#define TIMER_ENABLE_CLR_ON_MATCH_EN    2
-#define TIMER_ENABLE_EN                 1
+#define TIMER_ENABLE_CLR_ON_MATCH_EN    BIT(1)
+#define TIMER_ENABLE_EN                 BIT(0)
 #define TIMER_CLEAR             0x000C
 #define DGT_CLK_CTL             0x0034
-enum {
-	DGT_CLK_CTL_DIV_1 = 0,
-	DGT_CLK_CTL_DIV_2 = 1,
-	DGT_CLK_CTL_DIV_3 = 2,
-	DGT_CLK_CTL_DIV_4 = 3,
-};
-#define CSR_PROTECTION          0x0020
-#define CSR_PROTECTION_EN               1
+#define DGT_CLK_CTL_DIV_4	0x3
 
 #define GPT_HZ 32768
 
-enum timer_location {
-	LOCAL_TIMER = 0,
-	GLOBAL_TIMER = 1,
-};
-
 #define MSM_GLOBAL_TIMER MSM_CLOCK_DGT
 
 /* TODO: Remove these ifdefs */
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

