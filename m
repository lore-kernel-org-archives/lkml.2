Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537Ab1BYCFs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 21:05:48 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:22028 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756280Ab1BYCFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 21:05:47 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6267"; a="76353193"
From: Stepan Moskovchenko <stepanm@codeaurora.org>
To: linux@arm.linux.org.uk
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: [PATCH] arm: Footbridge: Fix I/O mappings for NOMMU mode
Date: Thu, 24 Feb 2011 18:05:18 -0800
Message-Id: <1298599518-24333-1-git-send-email-stepanm@codeaurora.org>
X-Mailer: git-send-email 1.7.3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the correct I/O address definitions for Footbridge
peripherals when the kernel is compiled without MMU
support.

Signed-off-by: Stepan Moskovchenko <stepanm@codeaurora.org>
---
 arch/arm/mach-footbridge/include/mach/hardware.h |   21 ++++++++++++++-------
 arch/arm/mach-footbridge/include/mach/io.h       |   10 ++++++++--
 2 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/arch/arm/mach-footbridge/include/mach/hardware.h b/arch/arm/mach-footbridge/include/mach/hardware.h
index 51dd902..b6fdf23 100644
--- a/arch/arm/mach-footbridge/include/mach/hardware.h
+++ b/arch/arm/mach-footbridge/include/mach/hardware.h
@@ -23,26 +23,33 @@
  * 0xf9000000	0x50000000	1MB	Cache flush
  * 0xf0000000	0x80000000	16MB	ISA memory
  */
+
+#ifdef CONFIG_MMU
+#define MMU_IO(a, b)	(a)
+#else
+#define MMU_IO(a, b)	(b)
+#endif
+
 #define XBUS_SIZE		0x00100000
-#define XBUS_BASE		0xff800000
+#define XBUS_BASE		MMU_IO(0xff800000, 0x40000000)

 #define ARMCSR_SIZE		0x00100000
-#define ARMCSR_BASE		0xfe000000
+#define ARMCSR_BASE		MMU_IO(0xfe000000, 0x42000000)

 #define WFLUSH_SIZE		0x00100000
-#define WFLUSH_BASE		0xfd000000
+#define WFLUSH_BASE		MMU_IO(0xfd000000, 0x78000000)

 #define PCIIACK_SIZE		0x00100000
-#define PCIIACK_BASE		0xfc000000
+#define PCIIACK_BASE		MMU_IO(0xfc000000, 0x79000000)

 #define PCICFG1_SIZE		0x01000000
-#define PCICFG1_BASE		0xfb000000
+#define PCICFG1_BASE		MMU_IO(0xfb000000, 0x7a000000)

 #define PCICFG0_SIZE		0x01000000
-#define PCICFG0_BASE		0xfa000000
+#define PCICFG0_BASE		MMU_IO(0xfa000000, 0x7b000000)

 #define PCIMEM_SIZE		0x01000000
-#define PCIMEM_BASE		0xf0000000
+#define PCIMEM_BASE		MMU_IO(0xf0000000, 0x80000000)

 #define XBUS_LEDS		((volatile unsigned char *)(XBUS_BASE + 0x12000))
 #define XBUS_LED_AMBER		(1 << 0)
diff --git a/arch/arm/mach-footbridge/include/mach/io.h b/arch/arm/mach-footbridge/include/mach/io.h
index 101a4fe..32e4cc3 100644
--- a/arch/arm/mach-footbridge/include/mach/io.h
+++ b/arch/arm/mach-footbridge/include/mach/io.h
@@ -14,8 +14,14 @@
 #ifndef __ASM_ARM_ARCH_IO_H
 #define __ASM_ARM_ARCH_IO_H

-#define PCIO_SIZE		0x00100000
-#define PCIO_BASE		0xff000000
+#ifdef CONFIG_MMU
+#define MMU_IO(a, b)	(a)
+#else
+#define MMU_IO(a, b)	(b)
+#endif
+
+#define PCIO_SIZE       0x00100000
+#define PCIO_BASE       MMU_IO(0xff000000, 0x7c000000)

 #define IO_SPACE_LIMIT 0xffff

--
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

