Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297Ab2DUJL4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 05:11:56 -0400
Received: from smtp4.mail.ru ([94.100.176.44]:47905 "EHLO smtp4.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753838Ab2DUJKZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 05:10:25 -0400
From: Alexander Shiyan <shc_work@mail.ru>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH 11/17] ARM clps711x: Move definitions of register address in one unit
Date: Sat, 21 Apr 2012 13:11:24 +0400
Message-Id: <1334999490-27177-12-git-send-email-shc_work@mail.ru>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1334999490-27177-1-git-send-email-shc_work@mail.ru>
References: <1334999490-27177-1-git-send-email-shc_work@mail.ru>
X-Spam: Not detected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
---
 arch/arm/include/asm/hardware/clps7111.h          |   11 -----------
 arch/arm/mach-clps711x/include/mach/entry-macro.S |    2 +-
 arch/arm/mach-clps711x/include/mach/hardware.h    |   15 ++++++++++++---
 arch/arm/mach-clps711x/include/mach/uncompress.h  |    9 ++++-----
 4 files changed, 17 insertions(+), 20 deletions(-)

diff --git a/arch/arm/include/asm/hardware/clps7111.h b/arch/arm/include/asm/hardware/clps7111.h
index b63ed8c..f4a3ac9 100644
--- a/arch/arm/include/asm/hardware/clps7111.h
+++ b/arch/arm/include/asm/hardware/clps7111.h
@@ -23,17 +23,6 @@
 #ifndef __ASM_HARDWARE_CLPS7111_H
 #define __ASM_HARDWARE_CLPS7111_H
 
-#define CLPS711X_PHYS_BASE	(0x80000000)
-
-#ifndef __ASSEMBLY__
-#define clps_readb(off)		__raw_readb(CLPS7111_BASE + (off))
-#define clps_readw(off)		__raw_readw(CLPS7111_BASE + (off))
-#define clps_readl(off)		__raw_readl(CLPS7111_BASE + (off))
-#define clps_writeb(val,off)	__raw_writeb(val, CLPS7111_BASE + (off))
-#define clps_writew(val,off)	__raw_writew(val, CLPS7111_BASE + (off))
-#define clps_writel(val,off)	__raw_writel(val, CLPS7111_BASE + (off))
-#endif
-
 #define PADR		(0x0000)
 #define PBDR		(0x0001)
 #define PCDR		(0x0002)
diff --git a/arch/arm/mach-clps711x/include/mach/entry-macro.S b/arch/arm/mach-clps711x/include/mach/entry-macro.S
index 4ff5e77..56e5c2c 100644
--- a/arch/arm/mach-clps711x/include/mach/entry-macro.S
+++ b/arch/arm/mach-clps711x/include/mach/entry-macro.S
@@ -17,7 +17,7 @@
 #endif
 
 		.macro	get_irqnr_and_base, irqnr, stat, base, mask
-		mov	\base, #CLPS7111_BASE
+		mov	\base, #CLPS711X_VIRT_BASE
 		ldr	\stat, [\base, #INTSR1]
 		ldr	\mask, [\base, #INTMR1]
 		mov	\irqnr, #4
diff --git a/arch/arm/mach-clps711x/include/mach/hardware.h b/arch/arm/mach-clps711x/include/mach/hardware.h
index f5d8313..495d57b 100644
--- a/arch/arm/mach-clps711x/include/mach/hardware.h
+++ b/arch/arm/mach-clps711x/include/mach/hardware.h
@@ -22,11 +22,20 @@
 #ifndef __ASM_ARCH_HARDWARE_H
 #define __ASM_ARCH_HARDWARE_H
 
-#define CLPS711X_VIRT_BASE	0xff000000
-#define CLPS7111_BASE		CLPS711X_VIRT_BASE
-
 #include <asm/hardware/clps7111.h>
 
+#define CLPS711X_PHYS_BASE	(0x80000000)
+#define CLPS711X_VIRT_BASE	(0xff000000)
+
+#ifndef __ASSEMBLY__
+#define clps_readb(off)		__raw_readb(CLPS711X_VIRT_BASE + (off))
+#define clps_readw(off)		__raw_readw(CLPS711X_VIRT_BASE + (off))
+#define clps_readl(off)		__raw_readl(CLPS711X_VIRT_BASE + (off))
+#define clps_writeb(val,off)	__raw_writeb(val, CLPS711X_VIRT_BASE + (off))
+#define clps_writew(val,off)	__raw_writew(val, CLPS711X_VIRT_BASE + (off))
+#define clps_writel(val,off)	__raw_writel(val, CLPS711X_VIRT_BASE + (off))
+#endif
+
 /*
  * The physical addresses that the external chip select signals map to is
  * dependent on the setting of the nMEDCHG signal on EP7211 and EP7212
diff --git a/arch/arm/mach-clps711x/include/mach/uncompress.h b/arch/arm/mach-clps711x/include/mach/uncompress.h
index bf7b112..f0e8a32 100644
--- a/arch/arm/mach-clps711x/include/mach/uncompress.h
+++ b/arch/arm/mach-clps711x/include/mach/uncompress.h
@@ -19,11 +19,10 @@
  */
 #include <mach/hardware.h>
 
-#undef CLPS7111_BASE
-#define CLPS7111_BASE CLPS711X_PHYS_BASE
-
-#define __raw_readl(p)		(*(unsigned long *)(p))
-#define __raw_writel(v,p)	(*(unsigned long *)(p) = (v))
+#undef clps_readl
+#undef clps_writel
+#define clps_readl(p)		(*(unsigned long *)(CLPS711X_PHYS_BASE+p))
+#define clps_writel(v,p)	(*(unsigned long *)(CLPS711X_PHYS_BASE+p) = (v))
 
 #ifdef CONFIG_DEBUG_CLPS711X_UART2
 #define SYSFLGx	SYSFLG2
-- 
1.7.3.4

