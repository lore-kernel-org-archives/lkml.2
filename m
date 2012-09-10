Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785Ab2IJRdo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 13:33:44 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:34323 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046Ab2IJRdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 13:33:42 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6830"; a="232625225"
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 10/9] ARM: msm: Allow msm_iomap-8x60 and msm_iomap-8960 to coexist
Date: Mon, 10 Sep 2012 10:33:08 -0700
Message-Id: <1347298389-12567-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.12.176.g3fc0e4c.dirty
In-Reply-To: <1346873339-10927-1-git-send-email-sboyd@codeaurora.org>
References: <1346873339-10927-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the unused GCC, ACC, and shared memory definitions in the
8660 static mappings. This allows the 8660 header file to be
included in msm_iomap.h unconditionally.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mach-msm/include/mach/msm_iomap-8x60.h | 11 -----------
 arch/arm/mach-msm/include/mach/msm_iomap.h      |  3 +--
 arch/arm/mach-msm/io.c                          |  2 --
 3 files changed, 1 insertion(+), 15 deletions(-)

diff --git a/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h b/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h
index c6d38f1..199372e 100644
--- a/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h
+++ b/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h
@@ -41,21 +41,10 @@
 #define MSM8X60_QGIC_CPU_PHYS	0x02081000
 #define MSM8X60_QGIC_CPU_SIZE	SZ_4K
 
-#define MSM_ACC_BASE		IOMEM(0xF0002000)
-#define MSM_ACC_PHYS		0x02001000
-#define MSM_ACC_SIZE		SZ_4K
-
-#define MSM_GCC_BASE		IOMEM(0xF0003000)
-#define MSM_GCC_PHYS		0x02082000
-#define MSM_GCC_SIZE		SZ_4K
-
 #define MSM_TLMM_BASE		IOMEM(0xF0004000)
 #define MSM_TLMM_PHYS		0x00800000
 #define MSM_TLMM_SIZE		SZ_16K
 
-#define MSM_SHARED_RAM_BASE	IOMEM(0xF0100000)
-#define MSM_SHARED_RAM_SIZE	SZ_1M
-
 #define MSM8X60_TMR_PHYS	0x02000000
 #define MSM8X60_TMR_SIZE	SZ_4K
 
diff --git a/arch/arm/mach-msm/include/mach/msm_iomap.h b/arch/arm/mach-msm/include/mach/msm_iomap.h
index 00afdfb..2ab7cf0 100644
--- a/arch/arm/mach-msm/include/mach/msm_iomap.h
+++ b/arch/arm/mach-msm/include/mach/msm_iomap.h
@@ -41,12 +41,11 @@
 #include "msm_iomap-7x30.h"
 #elif defined(CONFIG_ARCH_QSD8X50)
 #include "msm_iomap-8x50.h"
-#elif defined(CONFIG_ARCH_MSM8X60)
-#include "msm_iomap-8x60.h"
 #else
 #include "msm_iomap-7x00.h"
 #endif
 
+#include "msm_iomap-8x60.h"
 #include "msm_iomap-8960.h"
 
 #define MSM_DEBUG_UART_SIZE	SZ_4K
diff --git a/arch/arm/mach-msm/io.c b/arch/arm/mach-msm/io.c
index 35d6926..e674b59 100644
--- a/arch/arm/mach-msm/io.c
+++ b/arch/arm/mach-msm/io.c
@@ -112,8 +112,6 @@ static struct map_desc msm8x60_io_desc[] __initdata = {
 	MSM_CHIP_DEVICE(QGIC_CPU, MSM8X60),
 	MSM_CHIP_DEVICE(TMR, MSM8X60),
 	MSM_CHIP_DEVICE(TMR0, MSM8X60),
-	MSM_DEVICE(ACC),
-	MSM_DEVICE(GCC),
 #ifdef CONFIG_DEBUG_MSM8660_UART
 	MSM_DEVICE(DEBUG_UART),
 #endif
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

