Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760782Ab2ILRLZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 13:11:25 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:40192 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932196Ab2ILQ7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 12:59:36 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6832"; a="233521332"
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH 04/24] ARM: msm: Fix early debug uart mapping on some memory configs
Date: Wed, 12 Sep 2012 09:58:40 -0700
Message-Id: <1347469140-25069-5-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1347469140-25069-1-git-send-email-davidb@codeaurora.org>
References: <1347469140-25069-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Boyd <sboyd@codeaurora.org>

The uart mapping runs into the space allocated for lowmem on some
8960 boards when we have more than 512Mb of memory. We were
getting lucky before and our mapping wasn't part of DDR. Move the
mapping up into the vmalloc area which will always be outside of
the lowmem mapping regardless of how much lowmem actually exists.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: David Brown <davidb@codeaurora.org>
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
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

