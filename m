Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673Ab2DUJOb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 05:14:31 -0400
Received: from smtp4.mail.ru ([94.100.176.44]:46748 "EHLO smtp4.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268Ab2DUJKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 05:10:13 -0400
From: Alexander Shiyan <shc_work@mail.ru>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH 02/17] ARM clps711x: Added Cirrus Logic EP7312 CPU variant
Date: Sat, 21 Apr 2012 13:11:15 +0400
Message-Id: <1334999490-27177-3-git-send-email-shc_work@mail.ru>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1334999490-27177-1-git-send-email-shc_work@mail.ru>
References: <1334999490-27177-1-git-send-email-shc_work@mail.ru>
X-Spam: Not detected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added register definitions specific to EP7312 and the necessary
configuration options.

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
---
 arch/arm/include/asm/hardware/ep7312.h         |  106 ++++++++++++++++++++++++
 arch/arm/mach-clps711x/Kconfig                 |    9 ++-
 arch/arm/mach-clps711x/include/mach/hardware.h |    4 +
 drivers/net/irda/Kconfig                       |    3 +-
 4 files changed, 119 insertions(+), 3 deletions(-)
 create mode 100644 arch/arm/include/asm/hardware/ep7312.h

diff --git a/arch/arm/include/asm/hardware/ep7312.h b/arch/arm/include/asm/hardware/ep7312.h
new file mode 100644
index 0000000..c01cced
--- /dev/null
+++ b/arch/arm/include/asm/hardware/ep7312.h
@@ -0,0 +1,106 @@
+/*
+ *  linux/arch/arm/include/asm/hardware/ep7312.h
+ *
+ *  This file contains the hardware definitions of the EP7312 internal
+ *  registers.
+ *
+ *  Copyright (C) 2000 Deep Blue Solutions Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307  USA
+ */
+#ifndef __ASM_HARDWARE_EP7312_H
+#define __ASM_HARDWARE_EP7312_H
+
+/* These registers are specific to the EP7312 only */
+#define DAIR			0x2000
+#define DAIDR0			0x2040
+#define DAIDR1			0x2080
+#define DAIDR2			0x20c0
+#define DAISR			0x2100
+#define SYSCON3			0x2200
+#define INTSR3			0x2240
+#define INTMR3			0x2280
+#define LEDFLSH			0x22c0
+#define SDCONF			0x2300
+#define SDRFPR			0x2340
+#define UNIQID			0x2440
+#define DAI64FS			0x2600
+#define PLLW			0x2610
+#define PLLR			0xA5A8
+#define RANDID0			0x2700
+#define RANDID1			0x2704
+#define RANDID2			0x2708
+#define RANDID3			0x270c
+
+#define DAI64FS_I2SF64		(1 << 0)
+#define DAI64FS_AUDIOCLKEN	(1 << 1)
+#define DAI64FS_AUDIOCLKSRC	(1 << 2)
+#define DAI64FS_MCLK256EN	(1 << 3)
+#define DAI64FS_LOOPBACK	(1 << 5)
+
+#define DAIR_RESERVED		(0x0404)
+#define DAIR_DAIEN		(1 << 16)
+#define DAIR_ECS		(1 << 17)
+#define DAIR_LCTM		(1 << 19)
+#define DAIR_LCRM		(1 << 20)
+#define DAIR_RCTM		(1 << 21)
+#define DAIR_RCRM		(1 << 22)
+#define DAIR_LBM		(1 << 23)
+
+#define DAIDR2_FIFOEN		(1 << 15)
+#define DAIDR2_FIFOLEFT		(0x0d << 16)
+#define DAIDR2_FIFORIGHT	(0x11 << 16)
+
+#define DAISR_RCTS		(1 << 0)
+#define DAISR_RCRS		(1 << 1)
+#define DAISR_LCTS		(1 << 2)
+#define DAISR_LCRS		(1 << 3)
+#define DAISR_RCTU		(1 << 4)
+#define DAISR_RCRO		(1 << 5)
+#define DAISR_LCTU		(1 << 6)
+#define DAISR_LCRO		(1 << 7)
+#define DAISR_RCNF		(1 << 8)
+#define DAISR_RCNE		(1 << 9)
+#define DAISR_LCNF		(1 << 10)
+#define DAISR_LCNE		(1 << 11)
+#define DAISR_FIFO		(1 << 12)
+
+#define SYSCON3_ADCCON		(1 << 0)
+#define SYSCON3_CLKCTL0		(1 << 1)
+#define SYSCON3_CLKCTL1		(1 << 2)
+#define SYSCON3_DAISEL		(1 << 3)
+#define SYSCON3_ADCCKNSEN	(1 << 4)
+#define SYSCON3_VERSN(x)	(((x) >> 5) & 0x7)
+#define SYSCON3_RESERVED0	(1 << 8)
+#define SYSCON3_128FS		(1 << 9)
+#define SYSCON3_ENPD67		(1 << 10)
+
+#define SDCONF_ACTIVE		(1 << 10)
+#define SDCONF_CLKCTL		(1 << 9)
+#define SDCONF_WIDTH_4		(0 << 7)
+#define SDCONF_WIDTH_8		(1 << 7)
+#define SDCONF_WIDTH_16		(2 << 7)
+#define SDCONF_WIDTH_32		(3 << 7)
+#define SDCONF_SIZE_16		(0 << 5)
+#define SDCONF_SIZE_64		(1 << 5)
+#define SDCONF_SIZE_128		(2 << 5)
+#define SDCONF_SIZE_256		(3 << 5)
+#define SDCONF_CASLAT_2		(2)
+#define SDCONF_CASLAT_3		(3)
+
+#define SYNCIO_FRMLEN(x)	(((x) & 0x3f) << 7)
+#define SYNCIO_CFGLEN(x)	((x) & 0x7f)
+
+#endif /* __ASM_HARDWARE_EP7312_H */
diff --git a/arch/arm/mach-clps711x/Kconfig b/arch/arm/mach-clps711x/Kconfig
index ec47ef4..f86aec1 100644
--- a/arch/arm/mach-clps711x/Kconfig
+++ b/arch/arm/mach-clps711x/Kconfig
@@ -1,6 +1,6 @@
 if ARCH_CLPS711X
 
-menu "CLPS711X/EP721X Implementations"
+menu "CLPS711X/EP721X/EP731X Implementations"
 
 config ARCH_AUTCPU12
 	bool "AUTCPU12"
@@ -57,9 +57,14 @@ config SOC_EP7212
 	depends on ARCH_P720T || ARCH_CEIVA
 	default y
 
+config SOC_EP7312
+	bool
+	depends on ARCH_FORTUNET
+	default y
+
 config EP72XX_ROM_BOOT
 	bool "EP72xx ROM boot"
-	depends on SOC_EP7211 || SOC_EP7212
+	depends on SOC_EP7211 || SOC_EP7212 || SOC_EP7312
 	---help---
 	  If you say Y here, your CLPS711x-based kernel will use the bootstrap
 	  mode memory map instead of the normal memory map.
diff --git a/arch/arm/mach-clps711x/include/mach/hardware.h b/arch/arm/mach-clps711x/include/mach/hardware.h
index 99461f3..2ff3473 100644
--- a/arch/arm/mach-clps711x/include/mach/hardware.h
+++ b/arch/arm/mach-clps711x/include/mach/hardware.h
@@ -64,6 +64,10 @@
 #define EP7212_BASE		CLPS7111_VIRT_BASE
 #include <asm/hardware/ep7212.h>
 
+#elif defined (CONFIG_SOC_EP7213)
+
+#include <asm/hardware/ep7312.h>
+
 #endif
 
 #define SYSPLD_VIRT_BASE	0xfe000000
diff --git a/drivers/net/irda/Kconfig b/drivers/net/irda/Kconfig
index 54d7723..a3929a1 100644
--- a/drivers/net/irda/Kconfig
+++ b/drivers/net/irda/Kconfig
@@ -212,7 +212,8 @@ config KINGSUN_DONGLE
 
 config EP7211_DONGLE
 	tristate "EP7211 I/R support"
-	depends on IRTTY_SIR && (SOC_EP7211 || SOC_EP7212) && IRDA && EXPERIMENTAL
+	depends on IRTTY_SIR && IRDA && EXPERIMENTAL && \
+		(SOC_EP7211 || SOC_EP7212 || SOC_7312)
 	help
 	  Say Y here if you want to build support for the Cirrus logic
 	  EP7211 chipset's infrared module.
-- 
1.7.3.4

