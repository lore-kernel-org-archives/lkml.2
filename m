Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab1DES21 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 14:28:27 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:32217
	"EHLO VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754158Ab1DES2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 14:28:20 -0400
X-SpamScore: -1
X-BigFish: VPS-1(zz1fa4Lc8kzz1202hzz8275bh8275dhz2dh95h668h839h63h)
X-Spam-TCS-SCL: 2:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
From: John Linn <john.linn@xilinx.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux@arm.linux.org.uk>, <catalin.marinas@arm.com>,
        <glikely@secretlab.ca>, <jamie@jamieiles.com>, <arnd@arndb.de>,
        <nicolas.pitre@linaro.org>
CC: John Linn <john.linn@xilinx.com>
Subject: [PATCH V6 3/5] ARM: Xilinx: base header files and assembly macros
Date: Tue, 5 Apr 2011 12:28:04 -0600
X-Mailer: git-send-email 1.5.4.7
In-Reply-To: <1302028086-17603-3-git-send-email-john.linn@xilinx.com>
References: <1302028086-17603-1-git-send-email-john.linn@xilinx.com>
 <1302028086-17603-2-git-send-email-john.linn@xilinx.com>
 <1302028086-17603-3-git-send-email-john.linn@xilinx.com>
X-RCIS-Action: ALLOW
MIME-Version: 1.0
Content-Type: text/plain
Message-ID: <59a58edb-5a37-4a51-87fe-7973baed3b9e@VA3EHSMHS023.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are the minimum needed to build the kernel for the new platform.

Signed-off-by: John Linn <john.linn@xilinx.com>
---

V6 Changes
	Only change was the renaming of mach-xilinx to mach-zynq
	which rippled thru as a minor change. The file xilinx_soc.h
	was renamed zynq_soc.h.

V5 Changes

Minor cleanup based on input from Russell King (uncompress.h.).
Minor cleanup based on input from Jamie Iles (uncompress.h.).
Moved to minimal dependencies on CLOCK_TICK_RATE based on input
	from Arnd.

V4 Changes

Cleanup based on input from Jamie Iles.
	Moved to PLAT_PHYS_OFFSET.
	Remove headers file inclusions that weren't needed.
	Added use of raw_readl/raw_writel in uncompressor uart code.
	Added cpu_relax() in the uncompressor uart code.

V3 Changes

Updates based on Russell Kings' comments
	Changed headers to update the license info and remove
	the address

	Updated the constant to use UL in vmalloc.h

V2 Changes

Updates based on Russell King's comments	
	moved to using entry-macro-gic.S
	moved stuff from hardware.h to xilinx_soc.h 
	added IOMEM() in io.h to help with typing
	Minor updates to IO_SPACE_LIMIT and __io()
	Updated addresses to be clear with seperate virtual
		and physical addresses

 arch/arm/mach-zynq/include/mach/clkdev.h      |   33 ++++++++++++++++
 arch/arm/mach-zynq/include/mach/debug-macro.S |   36 +++++++++++++++++
 arch/arm/mach-zynq/include/mach/entry-macro.S |   30 ++++++++++++++
 arch/arm/mach-zynq/include/mach/hardware.h    |   18 +++++++++
 arch/arm/mach-zynq/include/mach/io.h          |   33 ++++++++++++++++
 arch/arm/mach-zynq/include/mach/irqs.h        |   29 ++++++++++++++
 arch/arm/mach-zynq/include/mach/memory.h      |   23 +++++++++++
 arch/arm/mach-zynq/include/mach/system.h      |   28 +++++++++++++
 arch/arm/mach-zynq/include/mach/timex.h       |   23 +++++++++++
 arch/arm/mach-zynq/include/mach/uart.h        |   25 ++++++++++++
 arch/arm/mach-zynq/include/mach/uncompress.h  |   51 +++++++++++++++++++++++++
 arch/arm/mach-zynq/include/mach/vmalloc.h     |   20 ++++++++++
 arch/arm/mach-zynq/include/mach/zynq_soc.h    |   48 +++++++++++++++++++++++
 13 files changed, 397 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-zynq/include/mach/clkdev.h
 create mode 100644 arch/arm/mach-zynq/include/mach/debug-macro.S
 create mode 100644 arch/arm/mach-zynq/include/mach/entry-macro.S
 create mode 100644 arch/arm/mach-zynq/include/mach/hardware.h
 create mode 100644 arch/arm/mach-zynq/include/mach/io.h
 create mode 100644 arch/arm/mach-zynq/include/mach/irqs.h
 create mode 100644 arch/arm/mach-zynq/include/mach/memory.h
 create mode 100644 arch/arm/mach-zynq/include/mach/system.h
 create mode 100644 arch/arm/mach-zynq/include/mach/timex.h
 create mode 100644 arch/arm/mach-zynq/include/mach/uart.h
 create mode 100644 arch/arm/mach-zynq/include/mach/uncompress.h
 create mode 100644 arch/arm/mach-zynq/include/mach/vmalloc.h
 create mode 100644 arch/arm/mach-zynq/include/mach/zynq_soc.h

diff --git a/arch/arm/mach-zynq/include/mach/clkdev.h b/arch/arm/mach-zynq/include/mach/clkdev.h
new file mode 100644
index 0000000..fa8ce89
--- /dev/null
+++ b/arch/arm/mach-zynq/include/mach/clkdev.h
@@ -0,0 +1,33 @@
+/*
+ * arch/arm/mach-zynq/include/mach/clkdev.h
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
diff --git a/arch/arm/mach-zynq/include/mach/debug-macro.S b/arch/arm/mach-zynq/include/mach/debug-macro.S
new file mode 100644
index 0000000..9f664d5
--- /dev/null
+++ b/arch/arm/mach-zynq/include/mach/debug-macro.S
@@ -0,0 +1,36 @@
+/* arch/arm/mach-zynq/include/mach/debug-macro.S
+ *
+ * Debugging macro include header
+ *
+ *  Copyright (C) 2011 Xilinx
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <mach/zynq_soc.h>
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
diff --git a/arch/arm/mach-zynq/include/mach/entry-macro.S b/arch/arm/mach-zynq/include/mach/entry-macro.S
new file mode 100644
index 0000000..c25f239
--- /dev/null
+++ b/arch/arm/mach-zynq/include/mach/entry-macro.S
@@ -0,0 +1,30 @@
+/*
+ * arch/arm/mach-zynq/include/mach/entry-macro.S
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
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <mach/hardware.h>
+#include <asm/hardware/entry-macro-gic.S>
+
+                .macro  disable_fiq
+                .endm
+
+                .macro  arch_ret_to_user, tmp1, tmp2
+                .endm
diff --git a/arch/arm/mach-zynq/include/mach/hardware.h b/arch/arm/mach-zynq/include/mach/hardware.h
new file mode 100644
index 0000000..d558d8a
--- /dev/null
+++ b/arch/arm/mach-zynq/include/mach/hardware.h
@@ -0,0 +1,18 @@
+/* arch/arm/mach-zynq/include/mach/hardware.h
+ *
+ *  Copyright (C) 2011 Xilinx
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __MACH_HARDWARE_H__
+#define __MACH_HARDWARE_H__
+
+#endif
diff --git a/arch/arm/mach-zynq/include/mach/io.h b/arch/arm/mach-zynq/include/mach/io.h
new file mode 100644
index 0000000..39d9885
--- /dev/null
+++ b/arch/arm/mach-zynq/include/mach/io.h
@@ -0,0 +1,33 @@
+/* arch/arm/mach-zynq/include/mach/io.h
+ *
+ *  Copyright (C) 2011 Xilinx
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __MACH_IO_H__
+#define __MACH_IO_H__
+
+/* Allow IO space to be anywhere in the memory */
+
+#define IO_SPACE_LIMIT 0xffff
+
+/* IO address mapping macros, nothing special at this time but required */
+
+#ifdef __ASSEMBLER__
+#define IOMEM(x)		(x)
+#else
+#define IOMEM(x)		((void __force __iomem *)(x))
+#endif
+
+#define __io(a)			__typesafe_io(a)
+#define __mem_pci(a)		(a)
+
+#endif
diff --git a/arch/arm/mach-zynq/include/mach/irqs.h b/arch/arm/mach-zynq/include/mach/irqs.h
new file mode 100644
index 0000000..e7f414a
--- /dev/null
+++ b/arch/arm/mach-zynq/include/mach/irqs.h
@@ -0,0 +1,29 @@
+/* arch/arm/mach-zynq/include/mach/irqs.h
+ *
+ *  Copyright (C) 2011 Xilinx
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
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
diff --git a/arch/arm/mach-zynq/include/mach/memory.h b/arch/arm/mach-zynq/include/mach/memory.h
new file mode 100644
index 0000000..635f6df
--- /dev/null
+++ b/arch/arm/mach-zynq/include/mach/memory.h
@@ -0,0 +1,23 @@
+/* arch/arm/mach-zynq/include/mach/memory.h
+ *
+ *  Copyright (C) 2011 Xilinx
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __MACH_MEMORY_H__
+#define __MACH_MEMORY_H__
+
+#include <asm/sizes.h>
+
+#define PLAT_PHYS_OFFSET	UL(0x0)
+#define MEM_SIZE		SZ_256M
+
+#endif
diff --git a/arch/arm/mach-zynq/include/mach/system.h b/arch/arm/mach-zynq/include/mach/system.h
new file mode 100644
index 0000000..1b84d70
--- /dev/null
+++ b/arch/arm/mach-zynq/include/mach/system.h
@@ -0,0 +1,28 @@
+/* arch/arm/mach-zynq/include/mach/system.h
+ *
+ *  Copyright (C) 2011 Xilinx
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
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
diff --git a/arch/arm/mach-zynq/include/mach/timex.h b/arch/arm/mach-zynq/include/mach/timex.h
new file mode 100644
index 0000000..6c0245e
--- /dev/null
+++ b/arch/arm/mach-zynq/include/mach/timex.h
@@ -0,0 +1,23 @@
+/* arch/arm/mach-zynq/include/mach/timex.h
+ *
+ *  Copyright (C) 2011 Xilinx
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __MACH_TIMEX_H__
+#define __MACH_TIMEX_H__
+
+/* the following is needed for the system to build but will be removed
+   in the future, the value is not important but won't hurt
+*/
+#define CLOCK_TICK_RATE	(100 * HZ)
+
+#endif
diff --git a/arch/arm/mach-zynq/include/mach/uart.h b/arch/arm/mach-zynq/include/mach/uart.h
new file mode 100644
index 0000000..b2f5a37
--- /dev/null
+++ b/arch/arm/mach-zynq/include/mach/uart.h
@@ -0,0 +1,25 @@
+/* arch/arm/mach-zynq/include/mach/uart.h
+ *
+ *  Copyright (C) 2011 Xilinx
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
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
+#endif
diff --git a/arch/arm/mach-zynq/include/mach/uncompress.h b/arch/arm/mach-zynq/include/mach/uncompress.h
new file mode 100644
index 0000000..af4e844
--- /dev/null
+++ b/arch/arm/mach-zynq/include/mach/uncompress.h
@@ -0,0 +1,51 @@
+/* arch/arm/mach-zynq/include/mach/uncompress.h
+ *
+ *  Copyright (C) 2011 Xilinx
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __MACH_UNCOMPRESS_H__
+#define __MACH_UNCOMPRESS_H__
+
+#include <linux/io.h>
+#include <asm/processor.h>
+#include <mach/zynq_soc.h>
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
+	while (!(__raw_readl(IOMEM(LL_UART_PADDR + UART_SR_OFFSET)) &
+		UART_SR_TXEMPTY))
+		cpu_relax();
+}
+
+#define arch_decomp_wdog()
+
+static void putc(char ch)
+{
+	/*
+	 * Wait for room in the FIFO, then write the char into the FIFO
+	 */
+	while (__raw_readl(IOMEM(LL_UART_PADDR + UART_SR_OFFSET)) &
+		UART_SR_TXFULL)
+		cpu_relax();
+
+	__raw_writel(ch, IOMEM(LL_UART_PADDR + UART_FIFO_OFFSET));
+}
+
+#endif
diff --git a/arch/arm/mach-zynq/include/mach/vmalloc.h b/arch/arm/mach-zynq/include/mach/vmalloc.h
new file mode 100644
index 0000000..2398eff
--- /dev/null
+++ b/arch/arm/mach-zynq/include/mach/vmalloc.h
@@ -0,0 +1,20 @@
+/* arch/arm/mach-zynq/include/mach/vmalloc.h
+ *
+ *  Copyright (C) 2011 Xilinx
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __MACH_VMALLOC_H__
+#define __MACH_VMALLOC_H__
+
+#define VMALLOC_END       0xE0000000UL
+
+#endif
diff --git a/arch/arm/mach-zynq/include/mach/zynq_soc.h b/arch/arm/mach-zynq/include/mach/zynq_soc.h
new file mode 100644
index 0000000..d0d3f8f
--- /dev/null
+++ b/arch/arm/mach-zynq/include/mach/zynq_soc.h
@@ -0,0 +1,48 @@
+/* arch/arm/mach-zynq/include/mach/zynq_soc.h
+ *
+ *  Copyright (C) 2011 Xilinx
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __MACH_XILINX_SOC_H__
+#define __MACH_XILINX_SOC_H__
+
+#define PERIPHERAL_CLOCK_RATE		2500000
+
+/* For now, all mappings are flat (physical = virtual)
+ */
+#define UART0_PHYS			0xE0000000
+#define UART0_VIRT			UART0_PHYS
+
+#define TTC0_PHYS			0xF8001000
+#define TTC0_VIRT			TTC0_PHYS
+
+#define PL310_L2CC_PHYS			0xF8F02000
+#define PL310_L2CC_VIRT			PL310_L2CC_PHYS
+
+#define SCU_PERIPH_PHYS			0xF8F00000
+#define SCU_PERIPH_VIRT			SCU_PERIPH_PHYS
+
+/* The following are intended for the devices that are mapped early */
+
+#define TTC0_BASE			IOMEM(TTC0_VIRT)
+#define SCU_PERIPH_BASE			IOMEM(SCU_PERIPH_VIRT)
+#define SCU_GIC_CPU_BASE		(SCU_PERIPH_BASE + 0x100)
+#define SCU_GIC_DIST_BASE		(SCU_PERIPH_BASE + 0x1000)
+#define PL310_L2CC_BASE			IOMEM(PL310_L2CC_VIRT)
+
+/*
+ * Mandatory for CONFIG_LL_DEBUG, UART is mapped virtual = physical
+ */
+#define LL_UART_PADDR	UART0_PHYS
+#define LL_UART_VADDR	UART0_VIRT
+
+#endif
-- 
1.5.4.7



This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


