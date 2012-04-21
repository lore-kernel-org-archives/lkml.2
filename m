Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818Ab2DUJKX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 05:10:23 -0400
Received: from smtp4.mail.ru ([94.100.176.44]:46947 "EHLO smtp4.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752857Ab2DUJKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 05:10:15 -0400
From: Alexander Shiyan <shc_work@mail.ru>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH 04/17] ARM clps711x: Using a single definition for virtual address register
Date: Sat, 21 Apr 2012 13:11:17 +0400
Message-Id: <1334999490-27177-5-git-send-email-shc_work@mail.ru>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1334999490-27177-1-git-send-email-shc_work@mail.ru>
References: <1334999490-27177-1-git-send-email-shc_work@mail.ru>
X-Spam: Not detected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using a single definition for the virtual address register for all
variants boards clps711x.

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
---
 arch/arm/include/asm/hardware/ep7211.h         |    5 -----
 arch/arm/include/asm/hardware/ep7212.h         |    9 ++-------
 arch/arm/mach-clps711x/include/mach/hardware.h |   10 ----------
 drivers/mtd/nand/autcpu12.c                    |    4 ++--
 4 files changed, 4 insertions(+), 24 deletions(-)

diff --git a/arch/arm/include/asm/hardware/ep7211.h b/arch/arm/include/asm/hardware/ep7211.h
index 654d5f6..ca4d198 100644
--- a/arch/arm/include/asm/hardware/ep7211.h
+++ b/arch/arm/include/asm/hardware/ep7211.h
@@ -25,11 +25,6 @@
 
 #include <asm/hardware/clps7111.h>
 
-/*
- * define EP7211_BASE to be the base address of the region
- * you want to access.
- */
-
 #define EP7211_PHYS_BASE	(0x80000000)
 
 /*
diff --git a/arch/arm/include/asm/hardware/ep7212.h b/arch/arm/include/asm/hardware/ep7212.h
index 3b43bbe..0b1f508 100644
--- a/arch/arm/include/asm/hardware/ep7212.h
+++ b/arch/arm/include/asm/hardware/ep7212.h
@@ -23,16 +23,11 @@
 #ifndef __ASM_HARDWARE_EP7212_H
 #define __ASM_HARDWARE_EP7212_H
 
-/*
- * define EP7212_BASE to be the base address of the region
- * you want to access.
- */
-
 #define EP7212_PHYS_BASE	(0x80000000)
 
 #ifndef __ASSEMBLY__
-#define ep_readl(off)		__raw_readl(EP7212_BASE + (off))
-#define ep_writel(val,off)	__raw_writel(val, EP7212_BASE + (off))
+#define ep_readl(off)		__raw_readl(CLPS7111_BASE + (off))
+#define ep_writel(val,off)	__raw_writel(val, CLPS7111_BASE + (off))
 #endif
 
 /*
diff --git a/arch/arm/mach-clps711x/include/mach/hardware.h b/arch/arm/mach-clps711x/include/mach/hardware.h
index 2ff3473..8c7b28e 100644
--- a/arch/arm/mach-clps711x/include/mach/hardware.h
+++ b/arch/arm/mach-clps711x/include/mach/hardware.h
@@ -54,14 +54,10 @@
 
 #if defined (CONFIG_SOC_EP7211)
 
-#define EP7211_VIRT_BASE	CLPS7111_VIRT_BASE
-#define EP7211_BASE		CLPS7111_VIRT_BASE
 #include <asm/hardware/ep7211.h>
 
 #elif defined (CONFIG_SOC_EP7212)
 
-#define EP7212_VIRT_BASE	CLPS7111_VIRT_BASE
-#define EP7212_BASE		CLPS7111_VIRT_BASE
 #include <asm/hardware/ep7212.h>
 
 #elif defined (CONFIG_SOC_EP7213)
@@ -75,9 +71,6 @@
 
 #if  defined (CONFIG_ARCH_AUTCPU12)
 
-#define  CS89712_VIRT_BASE	CLPS7111_VIRT_BASE
-#define  CS89712_BASE		CLPS7111_VIRT_BASE
-
 #include <asm/hardware/clps7111.h>
 #include <asm/hardware/ep7212.h>
 #include <asm/hardware/cs89712.h>
@@ -158,9 +151,6 @@
 
 #if defined (CONFIG_ARCH_CEIVA)
 
-#define  CEIVA_VIRT_BASE	CLPS7111_VIRT_BASE
-#define  CEIVA_BASE		CLPS7111_VIRT_BASE
-
 #include <asm/hardware/clps7111.h>
 #include <asm/hardware/ep7212.h>
 
diff --git a/drivers/mtd/nand/autcpu12.c b/drivers/mtd/nand/autcpu12.c
index 2e42ec2..5bd4107 100644
--- a/drivers/mtd/nand/autcpu12.c
+++ b/drivers/mtd/nand/autcpu12.c
@@ -102,7 +102,7 @@ static void autcpu12_hwcontrol(struct mtd_info *mtd, int cmd,
 		void __iomem *addr;
 		unsigned char bits;
 
-		addr = CS89712_VIRT_BASE + AUTCPU12_SMC_PORT_OFFSET;
+		addr = CLPS7111_VIRT_BASE + AUTCPU12_SMC_PORT_OFFSET;
 		bits = (ctrl & NAND_CLE) << 4;
 		bits |= (ctrl & NAND_ALE) << 2;
 		writeb((readb(addr) & ~0x30) | bits, addr);
@@ -120,7 +120,7 @@ static void autcpu12_hwcontrol(struct mtd_info *mtd, int cmd,
  */
 int autcpu12_device_ready(struct mtd_info *mtd)
 {
-	void __iomem *addr = CS89712_VIRT_BASE + AUTCPU12_SMC_PORT_OFFSET;
+	void __iomem *addr = CLPS7111_VIRT_BASE + AUTCPU12_SMC_PORT_OFFSET;
 
 	return readb(addr) & AUTCPU12_SMC_RDY;
 }
-- 
1.7.3.4

