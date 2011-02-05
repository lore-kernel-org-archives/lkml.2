Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658Ab1BEQRm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 11:17:42 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:17596
	"EHLO VA3EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752459Ab1BEQRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 11:17:34 -0500
X-SpamScore: -1
X-BigFish: VPS-1(zz1fa4Lc8kzz1202hzz8275bh8275dhz2dh95h27ah668h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:xsj-gw1;RD:error;EFVD:FOP
From: John Linn <john.linn@xilinx.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux@arm.linux.org.uk>, <catalin.marinas@arm.com>,
        <glikely@secretlab.ca>
CC: John Linn <john.linn@xilinx.com>
Subject: [PATCH 4/4] ARM: Xilinx: base header files and assembly macros
Date: Sat, 5 Feb 2011 09:17:17 -0700
X-Mailer: git-send-email 1.5.6.6
In-Reply-To: <1296922637-24662-4-git-send-email-john.linn@xilinx.com>
References: <1296922637-24662-1-git-send-email-john.linn@xilinx.com>
 <1296922637-24662-2-git-send-email-john.linn@xilinx.com>
 <1296922637-24662-3-git-send-email-john.linn@xilinx.com>
 <1296922637-24662-4-git-send-email-john.linn@xilinx.com>
X-RCIS-Action: ALLOW
MIME-Version: 1.0
Content-Type: text/plain
Message-ID: <19b00b69-90dd-4fba-b9f7-2f8c7b40fb9a@VA3EHSMHS017.ehs.local>
X-Bypass-Agent: EF-1;
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are the minimum needed to build the kernel for the new platform.

Signed-off-by: John Linn <john.linn@xilinx.com>
---
 arch/arm/mach-xilinx/include/mach/clkdev.h      |   33 +++++++++
 arch/arm/mach-xilinx/include/mach/debug-macro.S |   36 +++++++++
 arch/arm/mach-xilinx/include/mach/entry-macro.S |   87 +++++++++++++++++++++++
 arch/arm/mach-xilinx/include/mach/hardware.h    |   44 ++++++++++++
 arch/arm/mach-xilinx/include/mach/io.h          |   27 +++++++
 arch/arm/mach-xilinx/include/mach/irqs.h        |   28 +++++++
 arch/arm/mach-xilinx/include/mach/memory.h      |   23 ++++++
 arch/arm/mach-xilinx/include/mach/system.h      |   28 +++++++
 arch/arm/mach-xilinx/include/mach/timex.h       |   22 ++++++
 arch/arm/mach-xilinx/include/mach/uart.h        |   30 ++++++++
 arch/arm/mach-xilinx/include/mach/uncompress.h  |   46 ++++++++++++
 arch/arm/mach-xilinx/include/mach/vmalloc.h     |   20 +++++
 12 files changed, 424 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-xilinx/include/mach/clkdev.h
 create mode 100644 arch/arm/mach-xilinx/include/mach/debug-macro.S
 create mode 100644 arch/arm/mach-xilinx/include/mach/entry-macro.S
 create mode 100644 arch/arm/mach-xilinx/include/mach/hardware.h
 create mode 100644 arch/arm/mach-xilinx/include/mach/io.h
 create mode 100644 arch/arm/mach-xilinx/include/mach/irqs.h
 create mode 100644 arch/arm/mach-xilinx/include/mach/memory.h
 create mode 100644 arch/arm/mach-xilinx/include/mach/system.h
 create mode 100644 arch/arm/mach-xilinx/include/mach/timex.h
 create mode 100644 arch/arm/mach-xilinx/include/mach/uart.h
 create mode 100644 arch/arm/mach-xilinx/include/mach/uncompress.h
 create mode 100644 arch/arm/mach-xilinx/include/mach/vmalloc.h

diff --git a/arch/arm/mach-xilinx/include/mach/clkdev.h b/arch/arm/mach-xilinx/include/mach/clkdev.h
new file mode 100644
index 0000000..5dd1453
--- /dev/null
+++ b/arch/arm/mach-xilinx/include/mach/clkdev.h
@@ -0,0 +1,33 @@
+/*
+ * arch/arm/mach-xilinx/include/mach/clkdev.h
+ *
+ *  Copyright (C) 2011 Xilinx, Inc.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef __MACH_CLKDEV_H__
+#define __MACH_CLKDEV_H__
+
+struct clk {
+	unsigned long rate;
+};
+
+static inline int __clk_get(struct clk *clk)
+{
+	return 1;
+}
+
+static inline void __clk_put(struct clk *clk)
+{
+}
+
+#endif
diff --git a/arch/arm/mach-xilinx/include/mach/debug-macro.S b/arch/arm/mach-xilinx/include/mach/debug-macro.S
new file mode 100644
index 0000000..db16b13
--- /dev/null
+++ b/arch/arm/mach-xilinx/include/mach/debug-macro.S
@@ -0,0 +1,36 @@
+/* arch/arm/mach-xilinx/include/mach/debug-macro.S
+ *
+ * Debugging macro include header
+ *
+ *  Copyright (C) 2011 Xilinx
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <mach/hardware.h>
+#include <mach/uart.h>
+
+		.macro	addruart, rp, rv
+		ldr	\rp, =LL_UART_PADDR	@ physical
+		ldr	\rv, =LL_UART_VADDR	@ virtual
+		.endm
+
+		.macro	senduart,rd,rx
+		str	\rd, [\rx, #UART_FIFO_OFFSET]	@ TXDATA
+		.endm
+
+		.macro	waituart,rd,rx
+		.endm
+
+		.macro	busyuart,rd,rx
+1002:		ldr	\rd, [\rx, #UART_SR_OFFSET]	@ get status register
+		tst	\rd, #UART_SR_TXFULL		@
+		bne	1002b			@ wait if FIFO is full
+		.endm
diff --git a/arch/arm/mach-xilinx/include/mach/entry-macro.S b/arch/arm/mach-xilinx/include/mach/entry-macro.S
new file mode 100644
index 0000000..becb4cd
--- /dev/null
+++ b/arch/arm/mach-xilinx/include/mach/entry-macro.S
@@ -0,0 +1,87 @@
+/*
+ * arch/arm/mach-xilinx/include/mach/entry-macro.S
+ *
+ * Low-level IRQ helper macros
+ *
+ *  Copyright (C) 2011 Xilinx
+ *
+ * based on arch/plat-mxc/include/mach/entry-macro.S
+ *
+ *  Copyright (C) 2007 Lennert Buytenhek <buytenh@wantstofly.org>
+ *  Copyright 2004-2007 Freescale Semiconductor, Inc. All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+#include <mach/hardware.h>
+#include <asm/hardware/gic.h>
+
+		.macro	disable_fiq
+		.endm
+
+		.macro  get_irqnr_preamble, base, tmp
+		ldr	\base, =gic_cpu_base_addr
+		ldr	\base, [\base]
+		.endm
+
+		.macro  arch_ret_to_user, tmp1, tmp2
+		.endm
+
+		/*
+		 * The interrupt numbering scheme is defined in the
+		 * interrupt controller spec.
+		 *
+		 * Interrupts 0-15 are SFI and are filtered
+		 * Interrupts 31-1019 are normal and should be processed
+		 * 1020-1021 are reserved and are filtered
+		 * 1022 is not needed and filtered
+		 * 1023 is "spurious" (no interrupt) and is filtered
+		 *
+		 * A simple read from the controller will tell us the number
+		 * of the highest priority enabled interrupt.  We then just
+		 * need to check whether it is in the valid range for an IRQ
+		 * (16-1019 inclusive). If a valid interrupt, Z = 0 on return.
+		 */
+
+		.macro  get_irqnr_and_base, irqnr, irqstat, base, tmp
+
+		/* bits 12-10 = src CPU, 9-0 = int # */
+
+		ldr     \irqstat, [\base, #GIC_CPU_INTACK]
+		ldr	\tmp, =1020
+
+		bic     \irqnr, \irqstat, #0x1c00
+
+		cmp     \irqnr, #31
+		cmpcc	\irqnr, \irqnr
+		cmpne	\irqnr, \tmp
+		cmpcs	\irqnr, \irqnr
+
+		.endm
+
+		.macro test_for_ipi, irqnr, irqstat, base, tmp
+		bic	\irqnr, \irqstat, #0x1c00
+		cmp	\irqnr, #16
+		it	cc
+		strcc	\irqstat, [\base, #GIC_CPU_EOI]
+		it	cs
+		cmpcs	\irqnr, \irqnr
+		.endm
+
+		/* As above, this assumes irqstat and base are preserved */
+
+		.macro test_for_ltirq, irqnr, irqstat, base, tmp
+		bic	\irqnr, \irqstat, #0x1c00
+		mov 	\tmp, #0
+		cmp	\irqnr, #29
+		itt	eq
+		moveq	\tmp, #1
+		streq	\irqstat, [\base, #GIC_CPU_EOI]
+		cmp	\tmp, #0
+		.endm
diff --git a/arch/arm/mach-xilinx/include/mach/hardware.h b/arch/arm/mach-xilinx/include/mach/hardware.h
new file mode 100644
index 0000000..a635322
--- /dev/null
+++ b/arch/arm/mach-xilinx/include/mach/hardware.h
@@ -0,0 +1,44 @@
+/* arch/arm/mach-xilinx/include/mach/hardware.h
+ *
+ *  Copyright (C) 2011 Xilinx
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#ifndef __MACH_HARDWARE_H__
+#define __MACH_HARDWARE_H__
+
+#include <mach/memory.h>
+#include <mach/irqs.h>
+
+#define PERIPHERAL_CLOCK_RATE	2500000
+
+#define IO_BASE			0xE0000000
+#define UART0_BASE		(IO_BASE)
+
+#define PERIPH_BASE		0xF8000000
+#define TTC0_BASE		(PERIPH_BASE + 0x1000)
+
+#define SCU_PERIPH_BASE		0xF8F00000
+#define SCU_GIC_CPU_BASE	(SCU_PERIPH_BASE + 0x100)
+#define SCU_GLOBAL_TIMER_BASE	(SCU_PERIPH_BASE + 0x200)
+#define SCU_CPU_TIMER_BASE	(SCU_PERIPH_BASE + 0x600)
+#define SCU_WDT_BASE		(SCU_PERIPH_BASE + 0x620)
+#define SCU_GIC_DIST_BASE	(SCU_PERIPH_BASE + 0x1000)
+
+#define PL310_L2CC_BASE		0xF8F02000
+
+/*
+ * Mandatory for CONFIG_LL_DEBUG, UART is mapped virtual = physical
+ */
+#define LL_UART_PADDR	UART0_BASE
+#define LL_UART_VADDR	UART0_BASE
+
+#endif
diff --git a/arch/arm/mach-xilinx/include/mach/io.h b/arch/arm/mach-xilinx/include/mach/io.h
new file mode 100644
index 0000000..2e69db7
--- /dev/null
+++ b/arch/arm/mach-xilinx/include/mach/io.h
@@ -0,0 +1,27 @@
+/* arch/arm/mach-xilinx/include/mach/io.h
+ *
+ *  Copyright (C) 2011 Xilinx
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#ifndef __MACH_IO_H__
+#define __MACH_IO_H__
+
+/* Allow IO space to be anywhere in the memory */
+
+#define IO_SPACE_LIMIT 0xffffffff
+
+/* IO address mapping macros, nothing special at this time but required */
+
+#define __io(a)			((void __iomem *)(a))
+#define __mem_pci(a)		(a)
+
+#endif
diff --git a/arch/arm/mach-xilinx/include/mach/irqs.h b/arch/arm/mach-xilinx/include/mach/irqs.h
new file mode 100644
index 0000000..da2fadc
--- /dev/null
+++ b/arch/arm/mach-xilinx/include/mach/irqs.h
@@ -0,0 +1,28 @@
+/* arch/arm/mach-xilinx/include/mach/irqs.h
+ *
+ *  Copyright (C) 2011 Xilinx
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+#ifndef __MACH_IRQS_H
+#define __MACH_IRQS_H
+
+#define ARCH_NR_GPIOS	118
+#define NR_IRQS		(128 + ARCH_NR_GPIOS)
+
+/*
+ * GIC Interrupts
+ */
+
+#define IRQ_GIC_SPI_START	32
+#define IRQ_TIMERCOUNTER0	42
+#define IRQ_UART0		59
+
+#endif
diff --git a/arch/arm/mach-xilinx/include/mach/memory.h b/arch/arm/mach-xilinx/include/mach/memory.h
new file mode 100644
index 0000000..2b6d1eb
--- /dev/null
+++ b/arch/arm/mach-xilinx/include/mach/memory.h
@@ -0,0 +1,23 @@
+/* arch/arm/mach-xilinx/include/mach/memory.h
+ *
+ *  Copyright (C) 2011 Xilinx
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#ifndef __MACH_MEMORY_H__
+#define __MACH_MEMORY_H__
+
+#include <mach/hardware.h>
+
+#define PHYS_OFFSET             0x0
+#define MEM_SIZE		SZ_256M
+
+#endif
diff --git a/arch/arm/mach-xilinx/include/mach/system.h b/arch/arm/mach-xilinx/include/mach/system.h
new file mode 100644
index 0000000..a5f1f0f
--- /dev/null
+++ b/arch/arm/mach-xilinx/include/mach/system.h
@@ -0,0 +1,28 @@
+/* arch/arm/mach-xilinx/include/mach/system.h
+ *
+ *  Copyright (C) 2011 Xilinx
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#ifndef __MACH_SYSTEM_H__
+#define __MACH_SYSTEM_H__
+
+static inline void arch_idle(void)
+{
+	cpu_do_idle();
+}
+
+static inline void arch_reset(char mode, const char *cmd)
+{
+	/* Add architecture specific reset processing here */
+}
+
+#endif
diff --git a/arch/arm/mach-xilinx/include/mach/timex.h b/arch/arm/mach-xilinx/include/mach/timex.h
new file mode 100644
index 0000000..0c1d292
--- /dev/null
+++ b/arch/arm/mach-xilinx/include/mach/timex.h
@@ -0,0 +1,22 @@
+/* arch/arm/mach-xilinx/include/mach/timex.h
+ *
+ *  Copyright (C) 2011 Xilinx
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#ifndef __MACH_TIMEX_H__
+#define __MACH_TIMEX_H__
+
+#include <mach/hardware.h>
+
+#define CLOCK_TICK_RATE	(PERIPHERAL_CLOCK_RATE / 32)
+
+#endif
diff --git a/arch/arm/mach-xilinx/include/mach/uart.h b/arch/arm/mach-xilinx/include/mach/uart.h
new file mode 100644
index 0000000..2601143
--- /dev/null
+++ b/arch/arm/mach-xilinx/include/mach/uart.h
@@ -0,0 +1,30 @@
+/* arch/arm/mach-xilinx/include/mach/uart.h
+ *
+ *  Copyright (C) 2011 Xilinx
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+#ifndef __MACH_UART_H__
+#define __MACH_UART_H__
+
+#define UART_CR_OFFSET          0x00  /* Control Register [8:0] */
+#define UART_SR_OFFSET          0x2C  /* Channel Status [11:0] */
+#define UART_FIFO_OFFSET        0x30  /* FIFO [15:0] or [7:0] */
+
+#define UART_SR_TXFULL		0x00000010	/* TX FIFO full */
+#define UART_SR_TXEMPTY		0x00000008	/* TX FIFO empty */
+
+#define UART_FIFO_WRITE(base, value) \
+	(*(volatile unsigned int *)((base) + UART_FIFO_OFFSET) = (value))
+
+#define UART_STATUS(base) \
+	(*(volatile unsigned int *)((base) + UART_SR_OFFSET))
+
+#endif
diff --git a/arch/arm/mach-xilinx/include/mach/uncompress.h b/arch/arm/mach-xilinx/include/mach/uncompress.h
new file mode 100644
index 0000000..3a4aef7
--- /dev/null
+++ b/arch/arm/mach-xilinx/include/mach/uncompress.h
@@ -0,0 +1,46 @@
+/* arch/arm/mach-xilinx/include/mach/uncompress.h
+ *
+ *  Copyright (C) 2011 Xilinx
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+#ifndef __MACH_UNCOMPRESS_H__
+#define __MACH_UNCOMPRESS_H__
+
+#include <mach/hardware.h>
+#include <mach/uart.h>
+
+void arch_decomp_setup(void)
+{
+}
+
+static inline void flush(void)
+{
+	/*
+	 * Wait while the FIFO is not empty
+	 */
+	while (!(UART_STATUS(LL_UART_PADDR) & UART_SR_TXEMPTY))
+		;
+}
+
+#define arch_decomp_wdog()
+
+static void putc(char ch)
+{
+	/*
+	 * Wait for room in the FIFO, then write the char into the FIFO
+	 */
+	while (UART_STATUS(LL_UART_PADDR) & UART_SR_TXFULL)
+		;
+
+	UART_FIFO_WRITE(LL_UART_PADDR, ch);
+}
+
+#endif
diff --git a/arch/arm/mach-xilinx/include/mach/vmalloc.h b/arch/arm/mach-xilinx/include/mach/vmalloc.h
new file mode 100644
index 0000000..b70ff29
--- /dev/null
+++ b/arch/arm/mach-xilinx/include/mach/vmalloc.h
@@ -0,0 +1,20 @@
+/* arch/arm/mach-xilinx/include/mach/vmalloc.h
+ *
+ *  Copyright (C) 2011 Xilinx
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#ifndef __MACH_VMALLOC_H__
+#define __MACH_VMALLOC_H__
+
+#define VMALLOC_END       IO_BASE
+
+#endif
-- 
1.6.2.1



This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


