Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341Ab2DUJMc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 05:12:32 -0400
Received: from smtp4.mail.ru ([94.100.176.44]:47816 "EHLO smtp4.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753820Ab2DUJKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 05:10:24 -0400
From: Alexander Shiyan <shc_work@mail.ru>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH 10/17] ARM clps711x: Address register renaming to reflect the fact that the name is the same for all arch
Date: Sat, 21 Apr 2012 13:11:23 +0400
Message-Id: <1334999490-27177-11-git-send-email-shc_work@mail.ru>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1334999490-27177-1-git-send-email-shc_work@mail.ru>
References: <1334999490-27177-1-git-send-email-shc_work@mail.ru>
X-Spam: Not detected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
---
 arch/arm/include/asm/hardware/clps7111.h          |    2 +-
 arch/arm/mach-clps711x/common.c                   |    4 ++--
 arch/arm/mach-clps711x/include/mach/debug-macro.S |    4 ++--
 arch/arm/mach-clps711x/include/mach/hardware.h    |    4 ++--
 arch/arm/mach-clps711x/include/mach/uncompress.h  |    2 +-
 drivers/mtd/nand/autcpu12.c                       |    4 ++--
 drivers/mtd/nand/h1910.c                          |    2 +-
 7 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/arm/include/asm/hardware/clps7111.h b/arch/arm/include/asm/hardware/clps7111.h
index 84358d8..b63ed8c 100644
--- a/arch/arm/include/asm/hardware/clps7111.h
+++ b/arch/arm/include/asm/hardware/clps7111.h
@@ -23,7 +23,7 @@
 #ifndef __ASM_HARDWARE_CLPS7111_H
 #define __ASM_HARDWARE_CLPS7111_H
 
-#define CLPS7111_PHYS_BASE	(0x80000000)
+#define CLPS711X_PHYS_BASE	(0x80000000)
 
 #ifndef __ASSEMBLY__
 #define clps_readb(off)		__raw_readb(CLPS7111_BASE + (off))
diff --git a/arch/arm/mach-clps711x/common.c b/arch/arm/mach-clps711x/common.c
index 3544433..3b6e6b8 100644
--- a/arch/arm/mach-clps711x/common.c
+++ b/arch/arm/mach-clps711x/common.c
@@ -43,8 +43,8 @@
  */
 static struct map_desc clps711x_io_desc[] __initdata = {
 	{
-		.virtual	= CLPS7111_VIRT_BASE,
-		.pfn		= __phys_to_pfn(CLPS7111_PHYS_BASE),
+		.virtual	= CLPS711X_VIRT_BASE,
+		.pfn		= __phys_to_pfn(CLPS711X_PHYS_BASE),
 		.length		= SZ_1M,
 		.type		= MT_DEVICE
 	}
diff --git a/arch/arm/mach-clps711x/include/mach/debug-macro.S b/arch/arm/mach-clps711x/include/mach/debug-macro.S
index 15a9036..118b3d9 100644
--- a/arch/arm/mach-clps711x/include/mach/debug-macro.S
+++ b/arch/arm/mach-clps711x/include/mach/debug-macro.S
@@ -19,8 +19,8 @@
 #else
 		mov	\rp, #0x1000	@ UART2
 #endif
-		orr	\rv, \rp, #CLPS7111_VIRT_BASE
-		orr	\rp, \rp, #CLPS7111_PHYS_BASE
+		orr	\rv, \rp, #CLPS711X_VIRT_BASE
+		orr	\rp, \rp, #CLPS711X_PHYS_BASE
 		.endm
 
 		.macro	senduart,rd,rx
diff --git a/arch/arm/mach-clps711x/include/mach/hardware.h b/arch/arm/mach-clps711x/include/mach/hardware.h
index 50d68c2..f5d8313 100644
--- a/arch/arm/mach-clps711x/include/mach/hardware.h
+++ b/arch/arm/mach-clps711x/include/mach/hardware.h
@@ -22,8 +22,8 @@
 #ifndef __ASM_ARCH_HARDWARE_H
 #define __ASM_ARCH_HARDWARE_H
 
-#define CLPS7111_VIRT_BASE	0xff000000
-#define CLPS7111_BASE		CLPS7111_VIRT_BASE
+#define CLPS711X_VIRT_BASE	0xff000000
+#define CLPS7111_BASE		CLPS711X_VIRT_BASE
 
 #include <asm/hardware/clps7111.h>
 
diff --git a/arch/arm/mach-clps711x/include/mach/uncompress.h b/arch/arm/mach-clps711x/include/mach/uncompress.h
index ac42332..bf7b112 100644
--- a/arch/arm/mach-clps711x/include/mach/uncompress.h
+++ b/arch/arm/mach-clps711x/include/mach/uncompress.h
@@ -20,7 +20,7 @@
 #include <mach/hardware.h>
 
 #undef CLPS7111_BASE
-#define CLPS7111_BASE CLPS7111_PHYS_BASE
+#define CLPS7111_BASE CLPS711X_PHYS_BASE
 
 #define __raw_readl(p)		(*(unsigned long *)(p))
 #define __raw_writel(v,p)	(*(unsigned long *)(p) = (v))
diff --git a/drivers/mtd/nand/autcpu12.c b/drivers/mtd/nand/autcpu12.c
index 5bd4107..e78975a 100644
--- a/drivers/mtd/nand/autcpu12.c
+++ b/drivers/mtd/nand/autcpu12.c
@@ -102,7 +102,7 @@ static void autcpu12_hwcontrol(struct mtd_info *mtd, int cmd,
 		void __iomem *addr;
 		unsigned char bits;
 
-		addr = CLPS7111_VIRT_BASE + AUTCPU12_SMC_PORT_OFFSET;
+		addr = CLPS711X_VIRT_BASE + AUTCPU12_SMC_PORT_OFFSET;
 		bits = (ctrl & NAND_CLE) << 4;
 		bits |= (ctrl & NAND_ALE) << 2;
 		writeb((readb(addr) & ~0x30) | bits, addr);
@@ -120,7 +120,7 @@ static void autcpu12_hwcontrol(struct mtd_info *mtd, int cmd,
  */
 int autcpu12_device_ready(struct mtd_info *mtd)
 {
-	void __iomem *addr = CLPS7111_VIRT_BASE + AUTCPU12_SMC_PORT_OFFSET;
+	void __iomem *addr = CLPS711X_VIRT_BASE + AUTCPU12_SMC_PORT_OFFSET;
 
 	return readb(addr) & AUTCPU12_SMC_RDY;
 }
diff --git a/drivers/mtd/nand/h1910.c b/drivers/mtd/nand/h1910.c
index 11e4878..9bf5ce5 100644
--- a/drivers/mtd/nand/h1910.c
+++ b/drivers/mtd/nand/h1910.c
@@ -24,7 +24,7 @@
 #include <linux/mtd/nand.h>
 #include <linux/mtd/partitions.h>
 #include <asm/io.h>
-#include <mach/hardware.h>	/* for CLPS7111_VIRT_BASE */
+#include <mach/hardware.h>
 #include <asm/sizes.h>
 #include <mach/h1900-gpio.h>
 #include <mach/ipaq.h>
-- 
1.7.3.4

