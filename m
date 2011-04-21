Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755671Ab1DUXJR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 19:09:17 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:55440 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658Ab1DUXJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 19:09:16 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6323"; a="87225105"
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] msm: timer: Fix DGT rate on 8960 and 8660
Date: Thu, 21 Apr 2011 16:09:11 -0700
Message-Id: <1303427351-16825-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.5.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DGT runs at 27 MHz divided by 4 on 8660 and 8960.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-msm/timer.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-msm/timer.c b/arch/arm/mach-msm/timer.c
index 38b95e9..ed73a38 100644
--- a/arch/arm/mach-msm/timer.c
+++ b/arch/arm/mach-msm/timer.c
@@ -55,10 +55,12 @@ enum timer_location {
 #if defined(CONFIG_ARCH_QSD8X50)
 #define DGT_HZ (19200000 / 4) /* 19.2 MHz / 4 by default */
 #define MSM_DGT_SHIFT (0)
-#elif defined(CONFIG_ARCH_MSM7X30) || defined(CONFIG_ARCH_MSM8X60) || \
-				      defined(CONFIG_ARCH_MSM8960)
+#elif defined(CONFIG_ARCH_MSM7X30)
 #define DGT_HZ (24576000 / 4) /* 24.576 MHz (LPXO) / 4 by default */
 #define MSM_DGT_SHIFT (0)
+#elif defined(CONFIG_ARCH_MSM8X60) || defined(CONFIG_ARCH_MSM8960)
+#define DGT_HZ (27000000 / 4) /* 27 MHz (PXO) / 4 by default */
+#define MSM_DGT_SHIFT (0)
 #else
 #define DGT_HZ 19200000 /* 19.2 MHz or 600 KHz after shift */
 #define MSM_DGT_SHIFT (5)
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

