Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942Ab1G1USX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 16:18:23 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:48490 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755797Ab1G1USV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 16:18:21 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6421"; a="106412279"
From: David Brown <davidb@codeaurora.org>
To: Russell King <linux@arm.linux.org.uk>, David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: [PATCH 2/2] ARM: msm: Remove PLAT_PHYS_OFFSETS from MSM targets
Date: Thu, 28 Jul 2011 13:18:11 -0700
Message-Id: <1311884291-5409-2-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1311884291-5409-1-git-send-email-davidb@codeaurora.org>
References: <1311794355-26988-2-git-send-email-sboyd@codeaurora.org>
 <1311884291-5409-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that MSM can boot with the phys offset patching, eliminate the
definitions of the phys offsets, and instead select
ARM_PATCH_PHYS_VIRT.

Signed-off-by: David Brown <davidb@codeaurora.org>

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index ced9371..3a4d87c 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -618,6 +618,7 @@ config ARCH_MSM
 	select GENERIC_CLOCKEVENTS
 	select ARCH_REQUIRE_GPIOLIB
 	select CLKDEV_LOOKUP
+	select ARM_PATCH_PHYS_VIRT
 	help
 	  Support for Qualcomm MSM/QSD based systems.  This runs on the
 	  apps processor of the MSM/QSD and depends on a shared memory
diff --git a/arch/arm/mach-msm/include/mach/memory.h b/arch/arm/mach-msm/include/mach/memory.h
index 58d5e7e..deed41a 100644
--- a/arch/arm/mach-msm/include/mach/memory.h
+++ b/arch/arm/mach-msm/include/mach/memory.h
@@ -17,19 +17,12 @@
 #define __ASM_ARCH_MEMORY_H
 
 /* physical offset of RAM */
-#if defined(CONFIG_ARCH_QSD8X50) && defined(CONFIG_MSM_SOC_REV_A)
-#define PLAT_PHYS_OFFSET		UL(0x00000000)
-#elif defined(CONFIG_ARCH_QSD8X50)
-#define PLAT_PHYS_OFFSET		UL(0x20000000)
-#elif defined(CONFIG_ARCH_MSM7X30)
-#define PLAT_PHYS_OFFSET		UL(0x00000000)
-#elif defined(CONFIG_ARCH_MSM8X60)
-#define PLAT_PHYS_OFFSET		UL(0x40000000)
-#elif defined(CONFIG_ARCH_MSM8960)
-#define PLAT_PHYS_OFFSET		UL(0x40000000)
-#else
-#define PLAT_PHYS_OFFSET		UL(0x10000000)
-#endif
+#define QSD8X50A_PHYS_OFFSET		UL(0x00000000)
+#define QSD8X50_PHYS_OFFSET		UL(0x20000000)
+#define MSM7X30_PHYS_OFFSET		UL(0x00000000)
+#define MSM8X60_PHYS_OFFSET		UL(0x10000000)
+#define MSM8960_PHYS_OFFSET		UL(0x40000000)
+#define MSM7X01_PHYS_OFFSET		UL(0x10000000)
 
 #endif
 
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

