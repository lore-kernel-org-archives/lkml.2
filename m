Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992Ab2H0Xf1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 19:35:27 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:56696 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754153Ab2H0Xf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 19:35:26 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6817"; a="230068601"
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] ARM: MSM: Fix early debug uart mapping on some memory configs
Date: Mon, 27 Aug 2012 16:35:21 -0700
Message-Id: <1346110521-24999-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.12.70.g851f7e6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The uart mapping runs into the space allocated for lowmem on some
8960 boards when we have more than 512Mb of memory. We were
getting lucky before and our mapping wasn't part of DDR. Move the
mapping up into the vmalloc area which will always be outside of
the lowmem mapping regardless of how much lowmem actually exists.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-msm/include/mach/msm_iomap-8960.h | 2 +-
 arch/arm/mach-msm/include/mach/msm_iomap-8x60.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-msm/include/mach/msm_iomap-8960.h b/arch/arm/mach-msm/include/mach/msm_iomap-8960.h
index a1752c0..facf434 100644
--- a/arch/arm/mach-msm/include/mach/msm_iomap-8960.h
+++ b/arch/arm/mach-msm/include/mach/msm_iomap-8960.h
@@ -46,7 +46,7 @@
 #define MSM8960_TMR0_SIZE	SZ_4K
 
 #ifdef CONFIG_DEBUG_MSM8960_UART
-#define MSM_DEBUG_UART_BASE	0xE1040000
+#define MSM_DEBUG_UART_BASE	0xF0040000
 #define MSM_DEBUG_UART_PHYS	0x16440000
 #endif
 
diff --git a/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h b/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h
index 5aed57d..21a2a88 100644
--- a/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h
+++ b/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h
@@ -63,7 +63,7 @@
 #define MSM8X60_TMR0_SIZE	SZ_4K
 
 #ifdef CONFIG_DEBUG_MSM8660_UART
-#define MSM_DEBUG_UART_BASE	0xE1040000
+#define MSM_DEBUG_UART_BASE	0xF0040000
 #define MSM_DEBUG_UART_PHYS	0x19C40000
 #endif
 
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

