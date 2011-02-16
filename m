Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205Ab1BPHvt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 02:51:49 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:42706 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754263Ab1BPHvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 02:51:43 -0500
From: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
To: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>
Cc: "Arnd Bergmann" <arnd@arndb.de>, "'Greg KH'" <greg@kroah.com>
Subject: [PATCH 09/12] unicore32 machine related files: hardware registers
Date: Wed, 16 Feb 2011 15:51:35 +0800
Message-ID: <015301cbcdae$55cdb7e0$016927a0$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AcvNrkxKqH8YIjr9T2W7ItD8Ya699g==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Message-Id: <6a0404f13ab84fd4c730ab718eed1561e56f8ba7.1297842537.git.gxt@mprc.pku.edu.cn>
In-Reply-To: <cover.1297842537.git.gxt@mprc.pku.edu.cn>
References: <cover.1297842537.git.gxt@mprc.pku.edu.cn>
From: GuanXuetao <gxt@mprc.pku.edu.cn>
Date: Sat, 15 Jan 2011 18:24:44 +0800

This patch adds all hardware registers definitions.

Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
---
 arch/unicore32/include/mach/PKUnity.h     |  104 +++++++++++++
 arch/unicore32/include/mach/bitfield.h    |   24 +++
 arch/unicore32/include/mach/hardware.h    |   45 ++++++
 arch/unicore32/include/mach/regs-ac97.h   |   32 ++++
 arch/unicore32/include/mach/regs-dmac.h   |   81 ++++++++++
 arch/unicore32/include/mach/regs-gpio.h   |   70 +++++++++
 arch/unicore32/include/mach/regs-i2c.h    |   63 ++++++++
 arch/unicore32/include/mach/regs-intc.h   |   28 ++++
 arch/unicore32/include/mach/regs-nand.h   |   79 ++++++++++
 arch/unicore32/include/mach/regs-ost.h    |   92 ++++++++++++
 arch/unicore32/include/mach/regs-pci.h    |   94 ++++++++++++
 arch/unicore32/include/mach/regs-pm.h     |  126 ++++++++++++++++
 arch/unicore32/include/mach/regs-ps2.h    |   20 +++
 arch/unicore32/include/mach/regs-resetc.h |   34 +++++
 arch/unicore32/include/mach/regs-rtc.h    |   37 +++++
 arch/unicore32/include/mach/regs-sdc.h    |  156 ++++++++++++++++++++
 arch/unicore32/include/mach/regs-spi.h    |   98 ++++++++++++
 arch/unicore32/include/mach/regs-uart.h   |    3 +
 arch/unicore32/include/mach/regs-umal.h   |  229 +++++++++++++++++++++++++++++
 arch/unicore32/include/mach/regs-unigfx.h |  200 +++++++++++++++++++++++++
 20 files changed, 1615 insertions(+), 0 deletions(-)
 create mode 100644 arch/unicore32/include/mach/PKUnity.h
 create mode 100644 arch/unicore32/include/mach/bitfield.h
 create mode 100644 arch/unicore32/include/mach/hardware.h
 create mode 100644 arch/unicore32/include/mach/regs-ac97.h
 create mode 100644 arch/unicore32/include/mach/regs-dmac.h
 create mode 100644 arch/unicore32/include/mach/regs-gpio.h
 create mode 100644 arch/unicore32/include/mach/regs-i2c.h
 create mode 100644 arch/unicore32/include/mach/regs-intc.h
 create mode 100644 arch/unicore32/include/mach/regs-nand.h
 create mode 100644 arch/unicore32/include/mach/regs-ost.h
 create mode 100644 arch/unicore32/include/mach/regs-pci.h
 create mode 100644 arch/unicore32/include/mach/regs-pm.h
 create mode 100644 arch/unicore32/include/mach/regs-ps2.h
 create mode 100644 arch/unicore32/include/mach/regs-resetc.h
 create mode 100644 arch/unicore32/include/mach/regs-rtc.h
 create mode 100644 arch/unicore32/include/mach/regs-sdc.h
 create mode 100644 arch/unicore32/include/mach/regs-spi.h
 create mode 100644 arch/unicore32/include/mach/regs-uart.h
 create mode 100644 arch/unicore32/include/mach/regs-umal.h
 create mode 100644 arch/unicore32/include/mach/regs-unigfx.h

diff --git a/arch/unicore32/include/mach/PKUnity.h b/arch/unicore32/include/mach/PKUnity.h
new file mode 100644
index 0000000..1e13208
--- /dev/null
+++ b/arch/unicore32/include/mach/PKUnity.h
@@ -0,0 +1,104 @@
+/*
+ * linux/arch/unicore32/include/mach/PKUnity.h
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+/* Be sure that virtual mapping is defined right */
+#ifndef __MACH_PUV3_HARDWARE_H__
+#error You must include hardware.h not PKUnity.h
+#endif
+
+#include "bitfield.h"
+
+/*
+ * Memory Definitions
+ */
+#define PKUNITY_SDRAM_BASE		0x00000000 /* 0x00000000 - 0x7FFFFFFF 2GB */
+#define PKUNITY_IOSPACE_BASE            0x80000000 /* 0x80000000 - 0xFFFFFFFF 2GB */
+#define PKUNITY_PCI_BASE		0x80000000 /* 0x80000000 - 0xBFFFFFFF 1GB */
+#include "regs-pci.h"
+#define PKUNITY_BOOT_ROM2_BASE		0xF4000000 /* 0xF4000000 - 0xF7FFFFFF 64MB */
+#define PKUNITY_BOOT_SRAM2_BASE		0xF8000000 /* 0xF8000000 - 0xFBFFFFFF 64MB */
+#define PKUNITY_BOOT_FLASH_BASE		0xFC000000 /* 0xFC000000 - 0xFFFFFFFF 64MB */
+
+/*
+ * PKUNITY Memory Map Addresses: 0x03000000 - 0x03FFFFFF (16MB)
+ */
+#define PKUNITY_UVC_MMAP_BASE		0x02000000 /* 0x02000000 - 0x02FFFFFF 16MB */
+#define PKUNITY_UVC_MMAP_SIZE		0x01000000 /* 16MB */
+#define PKUNITY_UNIGFX_MMAP_BASE        0x03000000 /* 0x03000000 - 0x03FFFFFF 16MB */
+#define PKUNITY_UNIGFX_MMAP_SIZE        0x01000000 /* 16MB */
+
+/*
+ * PKUNITY System Bus Addresses (PCI): 0x80000000 - 0xBFFFFFFF (1GB)
+ */
+/* PCI Configuration regs */
+#define PKUNITY_PCICFG_BASE             0x80000000 /* 0x80000000 - 0x8000000B 12B */
+/* PCI Bridge Base */
+#define PKUNITY_PCIBRI_BASE             0x80010000 /* 0x80010000 - 0x80010250 592B */
+/* PCI Legacy IO */
+#define PKUNITY_PCILIO_BASE             0x80030000 /* 0x80030000 - 0x8003FFFF 64KB */
+/* PCI AHB-PCI MEM-mapping */
+#define PKUNITY_PCIMEM_BASE             0x90000000 /* 0x90000000 - 0x97FFFFFF 128MB */
+/* PCI PCI-AHB MEM-mapping */
+#define PKUNITY_PCIAHB_BASE             0x98000000 /* 0x98000000 - 0x9FFFFFFF 128MB */
+
+/*
+ * PKUNITY System Bus Addresses (AHB): 0xC0000000 - 0xEDFFFFFF (640MB)
+ */
+/* AHB-0 is DDR2 SDRAM */
+/* AHB-1 is PCI Space */
+#define PKUNITY_ARBITER_BASE		0xC0000000 /* AHB-2 */
+#define PKUNITY_DDR2CTRL_BASE		0xC0100000 /* AHB-3 */
+#define PKUNITY_DMAC_BASE		0xC0200000 /* AHB-4 */
+#include "regs-dmac.h"
+#define PKUNITY_UMAL_BASE		0xC0300000 /* AHB-5 */
+#include "regs-umal.h"
+#define PKUNITY_USB_BASE		0xC0400000 /* AHB-6 */
+#define PKUNITY_SATA_BASE		0xC0500000 /* AHB-7 */
+#define PKUNITY_SMC_BASE		0xC0600000 /* AHB-8 */
+/* AHB-9 is for APB bridge */
+#define PKUNITY_MME_BASE		0xC0700000 /* AHB-10 */
+#define PKUNITY_UNIGFX_BASE		0xC0800000 /* AHB-11 */
+#include "regs-unigfx.h"
+#define PKUNITY_NAND_BASE		0xC0900000 /* AHB-12 */
+#include "regs-nand.h"
+#define PKUNITY_H264D_BASE		0xC0A00000 /* AHB-13 */
+#define PKUNITY_H264E_BASE		0xC0B00000 /* AHB-14 */
+
+/*
+ * PKUNITY Peripheral Bus Addresses (APB): 0xEE000000 - 0xEFFFFFFF (128MB)
+ */
+#define PKUNITY_UART0_BASE		0xEE000000 /* APB-0 */
+#define PKUNITY_UART1_BASE		0xEE100000 /* APB-1 */
+#include "regs-uart.h"
+#define PKUNITY_I2C_BASE		0xEE200000 /* APB-2 */
+#include "regs-i2c.h"
+#define PKUNITY_SPI_BASE		0xEE300000 /* APB-3 */
+#include "regs-spi.h"
+#define PKUNITY_AC97_BASE		0xEE400000 /* APB-4 */
+#include "regs-ac97.h"
+#define PKUNITY_GPIO_BASE		0xEE500000 /* APB-5 */
+#include "regs-gpio.h"
+#define PKUNITY_INTC_BASE		0xEE600000 /* APB-6 */
+#include "regs-intc.h"
+#define PKUNITY_RTC_BASE		0xEE700000 /* APB-7 */
+#include "regs-rtc.h"
+#define PKUNITY_OST_BASE		0xEE800000 /* APB-8 */
+#include "regs-ost.h"
+#define PKUNITY_RESETC_BASE		0xEE900000 /* APB-9 */
+#include "regs-resetc.h"
+#define PKUNITY_PM_BASE			0xEEA00000 /* APB-10 */
+#include "regs-pm.h"
+#define PKUNITY_PS2_BASE		0xEEB00000 /* APB-11 */
+#include "regs-ps2.h"
+#define PKUNITY_SDC_BASE		0xEEC00000 /* APB-12 */
+#include "regs-sdc.h"
+
diff --git a/arch/unicore32/include/mach/bitfield.h b/arch/unicore32/include/mach/bitfield.h
new file mode 100644
index 0000000..128a702
--- /dev/null
+++ b/arch/unicore32/include/mach/bitfield.h
@@ -0,0 +1,24 @@
+/*
+ * linux/arch/unicore32/include/mach/bitfield.h
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __MACH_PUV3_BITFIELD_H__
+#define __MACH_PUV3_BITFIELD_H__
+
+#ifndef __ASSEMBLY__
+#define UData(Data)	((unsigned long) (Data))
+#else
+#define UData(Data)	(Data)
+#endif
+
+#define FIELD(val, vmask, vshift)	(((val) & ((UData(1) << (vmask)) - 1)) << (vshift))
+#define FMASK(vmask, vshift)		(((UData(1) << (vmask)) - 1) << (vshift))
+
+#endif /* __MACH_PUV3_BITFIELD_H__ */
diff --git a/arch/unicore32/include/mach/hardware.h b/arch/unicore32/include/mach/hardware.h
new file mode 100644
index 0000000..3fb7236
--- /dev/null
+++ b/arch/unicore32/include/mach/hardware.h
@@ -0,0 +1,45 @@
+/*
+ * linux/arch/unicore32/include/mach/hardware.h
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This file contains the hardware definitions for PKUnity architecture
+ */
+
+#ifndef __MACH_PUV3_HARDWARE_H__
+#define __MACH_PUV3_HARDWARE_H__
+
+#include "PKUnity.h"
+
+#define io_p2v(x)	((x) - PKUNITY_IOSPACE_BASE)
+#define io_v2p(x)	((x) + PKUNITY_IOSPACE_BASE)
+
+#ifndef __ASSEMBLY__
+
+# define __REG(x)	(*((volatile unsigned long *)io_p2v(x)))
+# define __PREG(x)	(io_v2p((unsigned long)&(x)))
+
+#else
+
+# define __REG(x)	io_p2v(x)
+# define __PREG(x)	io_v2p(x)
+
+#endif
+
+#define PCIBIOS_MIN_IO			0x4000 /* should lower than 64KB */
+#define PCIBIOS_MIN_MEM			PKUNITY_PCIMEM_BASE
+
+/*
+ * We override the standard dma-mask routines for bouncing.
+ */
+#define	HAVE_ARCH_PCI_SET_DMA_MASK
+
+#define pcibios_assign_all_busses()	1
+
+#endif  /* __MACH_PUV3_HARDWARE_H__ */
diff --git a/arch/unicore32/include/mach/regs-ac97.h b/arch/unicore32/include/mach/regs-ac97.h
new file mode 100644
index 0000000..ce299bf
--- /dev/null
+++ b/arch/unicore32/include/mach/regs-ac97.h
@@ -0,0 +1,32 @@
+/*
+ * PKUnity AC97 Registers
+ */
+
+#define PKUNITY_AC97_CONR		__REG(PKUNITY_AC97_BASE + 0x0000)
+#define PKUNITY_AC97_OCR		__REG(PKUNITY_AC97_BASE + 0x0004)
+#define PKUNITY_AC97_ICR		__REG(PKUNITY_AC97_BASE + 0x0008)
+#define PKUNITY_AC97_CRAC		__REG(PKUNITY_AC97_BASE + 0x000C)
+#define PKUNITY_AC97_INTR		__REG(PKUNITY_AC97_BASE + 0x0010)
+#define PKUNITY_AC97_INTRSTAT		__REG(PKUNITY_AC97_BASE + 0x0014)
+#define PKUNITY_AC97_INTRCLEAR		__REG(PKUNITY_AC97_BASE + 0x0018)
+#define PKUNITY_AC97_ENABLE		__REG(PKUNITY_AC97_BASE + 0x001C)
+#define PKUNITY_AC97_OUT_FIFO		__REG(PKUNITY_AC97_BASE + 0x0020)
+#define PKUNITY_AC97_IN_FIFO		__REG(PKUNITY_AC97_BASE + 0x0030)
+
+#define AC97_CODEC_REG(v)               FIELD((v), 7, 16)
+#define AC97_CODEC_VAL(v)               FIELD((v), 16, 0)
+#define AC97_CODEC_WRITECOMPLETE        FIELD(1, 1, 2)
+
+/*
+ * VAR PLAY SAMPLE RATE
+ */
+#define AC97_CMD_VPSAMPLE		(FIELD(3, 2, 16) | FIELD(3, 2, 0))
+
+/*
+ * FIX CAPTURE SAMPLE RATE
+ */
+#define AC97_CMD_FCSAMPLE		FIELD(7, 3, 0)
+
+#define AC97_CMD_RESET			FIELD(1, 1, 0)
+#define AC97_CMD_ENABLE			FIELD(1, 1, 0)
+#define AC97_CMD_DISABLE		FIELD(0, 1, 0)
diff --git a/arch/unicore32/include/mach/regs-dmac.h b/arch/unicore32/include/mach/regs-dmac.h
new file mode 100644
index 0000000..09fce9d
--- /dev/null
+++ b/arch/unicore32/include/mach/regs-dmac.h
@@ -0,0 +1,81 @@
+/*
+ * PKUnity Direct Memory Access Controller (DMAC)
+ */
+
+/*
+ * Interrupt Status Reg DMAC_ISR.
+ */
+#define DMAC_ISR		__REG(PKUNITY_DMAC_BASE + 0x0020)
+/*
+ * Interrupt Transfer Complete Status Reg DMAC_ITCSR.
+ */
+#define DMAC_ITCSR		__REG(PKUNITY_DMAC_BASE + 0x0050)
+/*
+ * Interrupt Transfer Complete Clear Reg DMAC_ITCCR.
+ */
+#define DMAC_ITCCR		__REG(PKUNITY_DMAC_BASE + 0x0060)
+/*
+ * Interrupt Error Status Reg DMAC_IESR.
+ */
+#define DMAC_IESR		__REG(PKUNITY_DMAC_BASE + 0x0080)
+/*
+ * Interrupt Error Clear Reg DMAC_IECR.
+ */
+#define DMAC_IECR		__REG(PKUNITY_DMAC_BASE + 0x0090)
+/*
+ * Enable Channels Reg DMAC_ENCH.
+ */
+#define DMAC_ENCH		__REG(PKUNITY_DMAC_BASE + 0x00B0)
+
+/*
+ * DMA control reg. Space [byte]
+ */
+#define DMASp                   0x00000100
+
+/*
+ * Source Addr DMAC_SRCADDR(ch).
+ */
+#define DMAC_SRCADDR(ch)	__REG(PKUNITY_DMAC_BASE + (ch)*DMASp + 0x00)
+/*
+ * Destination Addr DMAC_DESTADDR(ch).
+ */
+#define DMAC_DESTADDR(ch)	__REG(PKUNITY_DMAC_BASE + (ch)*DMASp + 0x04)
+/*
+ * Control Reg DMAC_CONTROL(ch).
+ */
+#define DMAC_CONTROL(ch)	__REG(PKUNITY_DMAC_BASE + (ch)*DMASp + 0x0C)
+/*
+ * Configuration Reg DMAC_CONFIG(ch).
+ */
+#define DMAC_CONFIG(ch)		__REG(PKUNITY_DMAC_BASE + (ch)*DMASp + 0x10)
+
+#define DMAC_IR_MASK            FMASK(6, 0)
+/*
+ * select channel (ch)
+ */
+#define DMAC_CHANNEL(ch)	FIELD(1, 1, (ch))
+
+#define DMAC_CONTROL_SIZE_BYTE(v)       (FIELD((v), 12, 14) | \
+					FIELD(0, 3, 9) | FIELD(0, 3, 6))
+#define DMAC_CONTROL_SIZE_HWORD(v)      (FIELD((v) >> 1, 12, 14) | \
+					FIELD(1, 3, 9) | FIELD(1, 3, 6))
+#define DMAC_CONTROL_SIZE_WORD(v)       (FIELD((v) >> 2, 12, 14) | \
+					FIELD(2, 3, 9) | FIELD(2, 3, 6))
+#define DMAC_CONTROL_DI                 FIELD(1, 1, 13)
+#define DMAC_CONTROL_SI                 FIELD(1, 1, 12)
+#define DMAC_CONTROL_BURST_1BYTE        (FIELD(0, 3, 3) | FIELD(0, 3, 0))
+#define DMAC_CONTROL_BURST_4BYTE        (FIELD(3, 3, 3) | FIELD(3, 3, 0))
+#define DMAC_CONTROL_BURST_8BYTE        (FIELD(5, 3, 3) | FIELD(5, 3, 0))
+#define DMAC_CONTROL_BURST_16BYTE       (FIELD(7, 3, 3) | FIELD(7, 3, 0))
+
+#define	DMAC_CONFIG_UART0_WR    (FIELD(2, 4, 11) | FIELD(1, 2, 1))
+#define	DMAC_CONFIG_UART0_RD    (FIELD(2, 4, 7)  | FIELD(2, 2, 1))
+#define	DMAC_CONFIG_UART1_WR    (FIELD(3, 4, 11) | FIELD(1, 2, 1))
+#define	DMAC_CONFIG_UART1RD     (FIELD(3, 4, 7)  | FIELD(2, 2, 1))
+#define	DMAC_CONFIG_AC97WR      (FIELD(4, 4, 11) | FIELD(1, 2, 1))
+#define	DMAC_CONFIG_AC97RD      (FIELD(4, 4, 7)  | FIELD(2, 2, 1))
+#define	DMAC_CONFIG_MMCWR       (FIELD(7, 4, 11) | FIELD(1, 2, 1))
+#define	DMAC_CONFIG_MMCRD       (FIELD(7, 4, 7)  | FIELD(2, 2, 1))
+#define DMAC_CONFIG_MASKITC     FIELD(1, 1, 4)
+#define DMAC_CONFIG_MASKIE      FIELD(1, 1, 3)
+#define DMAC_CONFIG_EN          FIELD(1, 1, 0)
diff --git a/arch/unicore32/include/mach/regs-gpio.h b/arch/unicore32/include/mach/regs-gpio.h
new file mode 100644
index 0000000..5dd99d4
--- /dev/null
+++ b/arch/unicore32/include/mach/regs-gpio.h
@@ -0,0 +1,70 @@
+/*
+ * PKUnity General-Purpose Input/Output (GPIO) Registers
+ */
+
+/*
+ * Voltage Status Reg GPIO_GPLR.
+ */
+#define GPIO_GPLR	__REG(PKUNITY_GPIO_BASE + 0x0000)
+/*
+ * Pin Direction Reg GPIO_GPDR.
+ */
+#define GPIO_GPDR	__REG(PKUNITY_GPIO_BASE + 0x0004)
+/*
+ * Output Pin Set Reg GPIO_GPSR.
+ */
+#define GPIO_GPSR	__REG(PKUNITY_GPIO_BASE + 0x0008)
+/*
+ * Output Pin Clear Reg GPIO_GPCR.
+ */
+#define GPIO_GPCR	__REG(PKUNITY_GPIO_BASE + 0x000C)
+/*
+ * Raise Edge Detect Reg GPIO_GRER.
+ */
+#define GPIO_GRER	__REG(PKUNITY_GPIO_BASE + 0x0010)
+/*
+ * Fall Edge Detect Reg GPIO_GFER.
+ */
+#define GPIO_GFER	__REG(PKUNITY_GPIO_BASE + 0x0014)
+/*
+ * Edge Status Reg GPIO_GEDR.
+ */
+#define GPIO_GEDR	__REG(PKUNITY_GPIO_BASE + 0x0018)
+/*
+ * Sepcial Voltage Detect Reg GPIO_GPIR.
+ */
+#define GPIO_GPIR	__REG(PKUNITY_GPIO_BASE + 0x0020)
+
+#define GPIO_MIN	(0)
+#define GPIO_MAX	(27)
+
+#define GPIO_GPIO(Nb)	(0x00000001 << (Nb))	/* GPIO [0..27] */
+#define GPIO_GPIO0	GPIO_GPIO(0)	/* GPIO  [0] */
+#define GPIO_GPIO1	GPIO_GPIO(1)	/* GPIO  [1] */
+#define GPIO_GPIO2	GPIO_GPIO(2)	/* GPIO  [2] */
+#define GPIO_GPIO3	GPIO_GPIO(3)	/* GPIO  [3] */
+#define GPIO_GPIO4	GPIO_GPIO(4)	/* GPIO  [4] */
+#define GPIO_GPIO5	GPIO_GPIO(5)	/* GPIO  [5] */
+#define GPIO_GPIO6	GPIO_GPIO(6)	/* GPIO  [6] */
+#define GPIO_GPIO7	GPIO_GPIO(7)	/* GPIO  [7] */
+#define GPIO_GPIO8	GPIO_GPIO(8)	/* GPIO  [8] */
+#define GPIO_GPIO9	GPIO_GPIO(9)	/* GPIO  [9] */
+#define GPIO_GPIO10	GPIO_GPIO(10)	/* GPIO [10] */
+#define GPIO_GPIO11	GPIO_GPIO(11)	/* GPIO [11] */
+#define GPIO_GPIO12	GPIO_GPIO(12)	/* GPIO [12] */
+#define GPIO_GPIO13	GPIO_GPIO(13)	/* GPIO [13] */
+#define GPIO_GPIO14	GPIO_GPIO(14)	/* GPIO [14] */
+#define GPIO_GPIO15	GPIO_GPIO(15)	/* GPIO [15] */
+#define GPIO_GPIO16	GPIO_GPIO(16)	/* GPIO [16] */
+#define GPIO_GPIO17	GPIO_GPIO(17)	/* GPIO [17] */
+#define GPIO_GPIO18	GPIO_GPIO(18)	/* GPIO [18] */
+#define GPIO_GPIO19	GPIO_GPIO(19)	/* GPIO [19] */
+#define GPIO_GPIO20	GPIO_GPIO(20)	/* GPIO [20] */
+#define GPIO_GPIO21	GPIO_GPIO(21)	/* GPIO [21] */
+#define GPIO_GPIO22	GPIO_GPIO(22)	/* GPIO [22] */
+#define GPIO_GPIO23	GPIO_GPIO(23)	/* GPIO [23] */
+#define GPIO_GPIO24	GPIO_GPIO(24)	/* GPIO [24] */
+#define GPIO_GPIO25	GPIO_GPIO(25)	/* GPIO [25] */
+#define GPIO_GPIO26	GPIO_GPIO(26)	/* GPIO [26] */
+#define GPIO_GPIO27	GPIO_GPIO(27)	/* GPIO [27] */
+
diff --git a/arch/unicore32/include/mach/regs-i2c.h b/arch/unicore32/include/mach/regs-i2c.h
new file mode 100644
index 0000000..70b704f
--- /dev/null
+++ b/arch/unicore32/include/mach/regs-i2c.h
@@ -0,0 +1,63 @@
+/*
+ * PKUnity Inter-integrated Circuit (I2C) Registers
+ */
+
+/*
+ * Control Reg I2C_CON.
+ */
+#define I2C_CON		__REG(PKUNITY_I2C_BASE + 0x0000)
+/*
+ * Target Address Reg I2C_TAR.
+ */
+#define I2C_TAR		__REG(PKUNITY_I2C_BASE + 0x0004)
+/*
+ * Data buffer and command Reg I2C_DATACMD.
+ */
+#define I2C_DATACMD	__REG(PKUNITY_I2C_BASE + 0x0010)
+/*
+ * Enable Reg I2C_ENABLE.
+ */
+#define I2C_ENABLE	__REG(PKUNITY_I2C_BASE + 0x006C)
+/*
+ * Status Reg I2C_STATUS.
+ */
+#define I2C_STATUS	__REG(PKUNITY_I2C_BASE + 0x0070)
+/*
+ * Tx FIFO Length Reg I2C_TXFLR.
+ */
+#define I2C_TXFLR	__REG(PKUNITY_I2C_BASE + 0x0074)
+/*
+ * Rx FIFO Length Reg I2C_RXFLR.
+ */
+#define I2C_RXFLR	__REG(PKUNITY_I2C_BASE + 0x0078)
+/*
+ * Enable Status Reg I2C_ENSTATUS.
+ */
+#define I2C_ENSTATUS	__REG(PKUNITY_I2C_BASE + 0x009C)
+
+#define I2C_CON_MASTER          FIELD(1, 1, 0)
+#define I2C_CON_SPEED_STD       FIELD(1, 2, 1)
+#define I2C_CON_SPEED_FAST      FIELD(2, 2, 1)
+#define I2C_CON_RESTART         FIELD(1, 1, 5)
+#define I2C_CON_SLAVEDISABLE    FIELD(1, 1, 6)
+
+#define I2C_DATACMD_READ        FIELD(1, 1, 8)
+#define I2C_DATACMD_WRITE       FIELD(0, 1, 8)
+#define I2C_DATACMD_DAT_MASK    FMASK(8, 0)
+#define I2C_DATACMD_DAT(v)      FIELD((v), 8, 0)
+
+#define I2C_ENABLE_ENABLE       FIELD(1, 1, 0)
+#define I2C_ENABLE_DISABLE      FIELD(0, 1, 0)
+
+#define I2C_STATUS_RFF          FIELD(1, 1, 4)
+#define I2C_STATUS_RFNE         FIELD(1, 1, 3)
+#define I2C_STATUS_TFE          FIELD(1, 1, 2)
+#define I2C_STATUS_TFNF         FIELD(1, 1, 1)
+#define I2C_STATUS_ACTIVITY     FIELD(1, 1, 0)
+
+#define I2C_ENSTATUS_ENABLE	FIELD(1, 1, 0)
+
+#define I2C_TAR_THERMAL	0x4f
+#define I2C_TAR_SPD	0x50
+#define I2C_TAR_PWIC    0x55
+#define I2C_TAR_EEPROM	0x57
diff --git a/arch/unicore32/include/mach/regs-intc.h b/arch/unicore32/include/mach/regs-intc.h
new file mode 100644
index 0000000..409ae47
--- /dev/null
+++ b/arch/unicore32/include/mach/regs-intc.h
@@ -0,0 +1,28 @@
+/*
+ * PKUNITY Interrupt Controller (INTC) Registers
+ */
+/*
+ * INTC Level Reg INTC_ICLR.
+ */
+#define INTC_ICLR	__REG(PKUNITY_INTC_BASE + 0x0000)
+/*
+ * INTC Mask Reg INTC_ICMR.
+ */
+#define INTC_ICMR	__REG(PKUNITY_INTC_BASE + 0x0004)
+/*
+ * INTC Pending Reg INTC_ICPR.
+ */
+#define INTC_ICPR	__REG(PKUNITY_INTC_BASE + 0x0008)
+/*
+ * INTC IRQ Pending Reg INTC_ICIP.
+ */
+#define INTC_ICIP	__REG(PKUNITY_INTC_BASE + 0x000C)
+/*
+ * INTC REAL Pending Reg INTC_ICFP.
+ */
+#define INTC_ICFP	__REG(PKUNITY_INTC_BASE + 0x0010)
+/*
+ * INTC Control Reg INTC_ICCR.
+ */
+#define INTC_ICCR	__REG(PKUNITY_INTC_BASE + 0x0014)
+
diff --git a/arch/unicore32/include/mach/regs-nand.h b/arch/unicore32/include/mach/regs-nand.h
new file mode 100644
index 0000000..0c33fe8
--- /dev/null
+++ b/arch/unicore32/include/mach/regs-nand.h
@@ -0,0 +1,79 @@
+/*
+ * PKUnity NAND Controller Registers
+ */
+/*
+ * ID Reg. 0 NAND_IDR0
+ */
+#define NAND_IDR0	__REG(PKUNITY_NAND_BASE + 0x0000)
+/*
+ * ID Reg. 1 NAND_IDR1
+ */
+#define NAND_IDR1	__REG(PKUNITY_NAND_BASE + 0x0004)
+/*
+ * ID Reg. 2 NAND_IDR2
+ */
+#define NAND_IDR2	__REG(PKUNITY_NAND_BASE + 0x0008)
+/*
+ * ID Reg. 3 NAND_IDR3
+ */
+#define NAND_IDR3	__REG(PKUNITY_NAND_BASE + 0x000C)
+/*
+ * Page Address Reg 0 NAND_PAR0
+ */
+#define NAND_PAR0	__REG(PKUNITY_NAND_BASE + 0x0010)
+/*
+ * Page Address Reg 1 NAND_PAR1
+ */
+#define NAND_PAR1	__REG(PKUNITY_NAND_BASE + 0x0014)
+/*
+ * Page Address Reg 2 NAND_PAR2
+ */
+#define NAND_PAR2	__REG(PKUNITY_NAND_BASE + 0x0018)
+/*
+ * ECC Enable Reg NAND_ECCEN
+ */
+#define NAND_ECCEN	__REG(PKUNITY_NAND_BASE + 0x001C)
+/*
+ * Buffer Reg NAND_BUF
+ */
+#define NAND_BUF	__REG(PKUNITY_NAND_BASE + 0x0020)
+/*
+ * ECC Status Reg NAND_ECCSR
+ */
+#define NAND_ECCSR	__REG(PKUNITY_NAND_BASE + 0x0024)
+/*
+ * Command Reg NAND_CMD
+ */
+#define NAND_CMD	__REG(PKUNITY_NAND_BASE + 0x0028)
+/*
+ * DMA Configure Reg NAND_DMACR
+ */
+#define NAND_DMACR	__REG(PKUNITY_NAND_BASE + 0x002C)
+/*
+ * Interrupt Reg NAND_IR
+ */
+#define NAND_IR		__REG(PKUNITY_NAND_BASE + 0x0030)
+/*
+ * Interrupt Mask Reg NAND_IMR
+ */
+#define NAND_IMR	__REG(PKUNITY_NAND_BASE + 0x0034)
+/*
+ * Chip Enable Reg NAND_CHIPEN
+ */
+#define NAND_CHIPEN	__REG(PKUNITY_NAND_BASE + 0x0038)
+/*
+ * Address Reg NAND_ADDR
+ */
+#define NAND_ADDR	__REG(PKUNITY_NAND_BASE + 0x003C)
+
+/*
+ * Command bits NAND_CMD_CMD_MASK
+ */
+#define NAND_CMD_CMD_MASK		FMASK(4, 4)
+#define NAND_CMD_CMD_READPAGE		FIELD(0x0, 4, 4)
+#define NAND_CMD_CMD_ERASEBLOCK		FIELD(0x6, 4, 4)
+#define NAND_CMD_CMD_READSTATUS		FIELD(0x7, 4, 4)
+#define NAND_CMD_CMD_WRITEPAGE		FIELD(0x8, 4, 4)
+#define NAND_CMD_CMD_READID		FIELD(0x9, 4, 4)
+#define NAND_CMD_CMD_RESET		FIELD(0xf, 4, 4)
+
diff --git a/arch/unicore32/include/mach/regs-ost.h b/arch/unicore32/include/mach/regs-ost.h
new file mode 100644
index 0000000..33049a8
--- /dev/null
+++ b/arch/unicore32/include/mach/regs-ost.h
@@ -0,0 +1,92 @@
+/*
+ * PKUnity Operating System Timer (OST) Registers
+ */
+/*
+ * Match Reg 0 OST_OSMR0
+ */
+#define OST_OSMR0	__REG(PKUNITY_OST_BASE + 0x0000)
+/*
+ * Match Reg 1 OST_OSMR1
+ */
+#define OST_OSMR1	__REG(PKUNITY_OST_BASE + 0x0004)
+/*
+ * Match Reg 2 OST_OSMR2
+ */
+#define OST_OSMR2	__REG(PKUNITY_OST_BASE + 0x0008)
+/*
+ * Match Reg 3 OST_OSMR3
+ */
+#define OST_OSMR3	__REG(PKUNITY_OST_BASE + 0x000C)
+/*
+ * Counter Reg OST_OSCR
+ */
+#define OST_OSCR	__REG(PKUNITY_OST_BASE + 0x0010)
+/*
+ * Status Reg OST_OSSR
+ */
+#define OST_OSSR	__REG(PKUNITY_OST_BASE + 0x0014)
+/*
+ * Watchdog Enable Reg OST_OWER
+ */
+#define OST_OWER	__REG(PKUNITY_OST_BASE + 0x0018)
+/*
+ * Interrupt Enable Reg OST_OIER
+ */
+#define OST_OIER	__REG(PKUNITY_OST_BASE + 0x001C)
+/*
+ * PWM Pulse Width Control Reg OST_PWMPWCR
+ */
+#define OST_PWMPWCR	__REG(PKUNITY_OST_BASE + 0x0080)
+/*
+ * PWM Duty Cycle Control Reg OST_PWMDCCR
+ */
+#define OST_PWMDCCR	__REG(PKUNITY_OST_BASE + 0x0084)
+/*
+ * PWM Period Control Reg OST_PWMPCR
+ */
+#define OST_PWMPCR	__REG(PKUNITY_OST_BASE + 0x0088)
+
+/*
+ * Match detected 0 OST_OSSR_M0
+ */
+#define OST_OSSR_M0		FIELD(1, 1, 0)
+/*
+ * Match detected 1 OST_OSSR_M1
+ */
+#define OST_OSSR_M1		FIELD(1, 1, 1)
+/*
+ * Match detected 2 OST_OSSR_M2
+ */
+#define OST_OSSR_M2		FIELD(1, 1, 2)
+/*
+ * Match detected 3 OST_OSSR_M3
+ */
+#define OST_OSSR_M3		FIELD(1, 1, 3)
+
+/*
+ * Interrupt enable 0 OST_OIER_E0
+ */
+#define OST_OIER_E0		FIELD(1, 1, 0)
+/*
+ * Interrupt enable 1 OST_OIER_E1
+ */
+#define OST_OIER_E1		FIELD(1, 1, 1)
+/*
+ * Interrupt enable 2 OST_OIER_E2
+ */
+#define OST_OIER_E2		FIELD(1, 1, 2)
+/*
+ * Interrupt enable 3 OST_OIER_E3
+ */
+#define OST_OIER_E3		FIELD(1, 1, 3)
+
+/*
+ * Watchdog Match Enable OST_OWER_WME
+ */
+#define OST_OWER_WME		FIELD(1, 1, 0)
+
+/*
+ * PWM Full Duty Cycle OST_PWMDCCR_FDCYCLE
+ */
+#define OST_PWMDCCR_FDCYCLE	FIELD(1, 1, 10)
+
diff --git a/arch/unicore32/include/mach/regs-pci.h b/arch/unicore32/include/mach/regs-pci.h
new file mode 100644
index 0000000..e8e1f1a
--- /dev/null
+++ b/arch/unicore32/include/mach/regs-pci.h
@@ -0,0 +1,94 @@
+/*
+ * PKUnity AHB-PCI Bridge Registers
+ */
+
+/*
+ * AHB/PCI fixed physical address for pci addess configuration
+ */
+/*
+ * PCICFG Bridge Base Reg.
+ */
+#define PCICFG_BRIBASE          __REG(PKUNITY_PCICFG_BASE + 0x0000)
+/*
+ * PCICFG Address Reg.
+ */
+#define PCICFG_ADDR             __REG(PKUNITY_PCICFG_BASE + 0x0004)
+/*
+ * PCICFG Address Reg.
+ */
+#define PCICFG_DATA             __REG(PKUNITY_PCICFG_BASE + 0x0008)
+
+/*
+ * PCI Bridge configuration space
+ */
+#define PCIBRI_ID		__REG(PKUNITY_PCIBRI_BASE + 0x0000)
+#define PCIBRI_CMD		__REG(PKUNITY_PCIBRI_BASE + 0x0004)
+#define PCIBRI_CLASS		__REG(PKUNITY_PCIBRI_BASE + 0x0008)
+#define PCIBRI_LTR		__REG(PKUNITY_PCIBRI_BASE + 0x000C)
+#define PCIBRI_BAR0		__REG(PKUNITY_PCIBRI_BASE + 0x0010)
+#define PCIBRI_BAR1		__REG(PKUNITY_PCIBRI_BASE + 0x0014)
+#define PCIBRI_BAR2		__REG(PKUNITY_PCIBRI_BASE + 0x0018)
+#define PCIBRI_BAR3		__REG(PKUNITY_PCIBRI_BASE + 0x001C)
+#define PCIBRI_BAR4		__REG(PKUNITY_PCIBRI_BASE + 0x0020)
+#define PCIBRI_BAR5		__REG(PKUNITY_PCIBRI_BASE + 0x0024)
+
+#define PCIBRI_PCICTL0		__REG(PKUNITY_PCIBRI_BASE + 0x0100)
+#define PCIBRI_PCIBAR0		__REG(PKUNITY_PCIBRI_BASE + 0x0104)
+#define PCIBRI_PCIAMR0		__REG(PKUNITY_PCIBRI_BASE + 0x0108)
+#define PCIBRI_PCITAR0		__REG(PKUNITY_PCIBRI_BASE + 0x010C)
+#define PCIBRI_PCICTL1		__REG(PKUNITY_PCIBRI_BASE + 0x0110)
+#define PCIBRI_PCIBAR1		__REG(PKUNITY_PCIBRI_BASE + 0x0114)
+#define PCIBRI_PCIAMR1		__REG(PKUNITY_PCIBRI_BASE + 0x0118)
+#define PCIBRI_PCITAR1		__REG(PKUNITY_PCIBRI_BASE + 0x011C)
+#define PCIBRI_PCICTL2		__REG(PKUNITY_PCIBRI_BASE + 0x0120)
+#define PCIBRI_PCIBAR2		__REG(PKUNITY_PCIBRI_BASE + 0x0124)
+#define PCIBRI_PCIAMR2		__REG(PKUNITY_PCIBRI_BASE + 0x0128)
+#define PCIBRI_PCITAR2		__REG(PKUNITY_PCIBRI_BASE + 0x012C)
+#define PCIBRI_PCICTL3		__REG(PKUNITY_PCIBRI_BASE + 0x0130)
+#define PCIBRI_PCIBAR3		__REG(PKUNITY_PCIBRI_BASE + 0x0134)
+#define PCIBRI_PCIAMR3		__REG(PKUNITY_PCIBRI_BASE + 0x0138)
+#define PCIBRI_PCITAR3		__REG(PKUNITY_PCIBRI_BASE + 0x013C)
+#define PCIBRI_PCICTL4		__REG(PKUNITY_PCIBRI_BASE + 0x0140)
+#define PCIBRI_PCIBAR4		__REG(PKUNITY_PCIBRI_BASE + 0x0144)
+#define PCIBRI_PCIAMR4		__REG(PKUNITY_PCIBRI_BASE + 0x0148)
+#define PCIBRI_PCITAR4		__REG(PKUNITY_PCIBRI_BASE + 0x014C)
+#define PCIBRI_PCICTL5		__REG(PKUNITY_PCIBRI_BASE + 0x0150)
+#define PCIBRI_PCIBAR5		__REG(PKUNITY_PCIBRI_BASE + 0x0154)
+#define PCIBRI_PCIAMR5		__REG(PKUNITY_PCIBRI_BASE + 0x0158)
+#define PCIBRI_PCITAR5		__REG(PKUNITY_PCIBRI_BASE + 0x015C)
+
+#define PCIBRI_AHBCTL0		__REG(PKUNITY_PCIBRI_BASE + 0x0180)
+#define PCIBRI_AHBBAR0		__REG(PKUNITY_PCIBRI_BASE + 0x0184)
+#define PCIBRI_AHBAMR0		__REG(PKUNITY_PCIBRI_BASE + 0x0188)
+#define PCIBRI_AHBTAR0		__REG(PKUNITY_PCIBRI_BASE + 0x018C)
+#define PCIBRI_AHBCTL1		__REG(PKUNITY_PCIBRI_BASE + 0x0190)
+#define PCIBRI_AHBBAR1		__REG(PKUNITY_PCIBRI_BASE + 0x0194)
+#define PCIBRI_AHBAMR1		__REG(PKUNITY_PCIBRI_BASE + 0x0198)
+#define PCIBRI_AHBTAR1		__REG(PKUNITY_PCIBRI_BASE + 0x019C)
+#define PCIBRI_AHBCTL2		__REG(PKUNITY_PCIBRI_BASE + 0x01A0)
+#define PCIBRI_AHBBAR2		__REG(PKUNITY_PCIBRI_BASE + 0x01A4)
+#define PCIBRI_AHBAMR2		__REG(PKUNITY_PCIBRI_BASE + 0x01A8)
+#define PCIBRI_AHBTAR2		__REG(PKUNITY_PCIBRI_BASE + 0x01AC)
+#define PCIBRI_AHBCTL3		__REG(PKUNITY_PCIBRI_BASE + 0x01B0)
+#define PCIBRI_AHBBAR3		__REG(PKUNITY_PCIBRI_BASE + 0x01B4)
+#define PCIBRI_AHBAMR3		__REG(PKUNITY_PCIBRI_BASE + 0x01B8)
+#define PCIBRI_AHBTAR3		__REG(PKUNITY_PCIBRI_BASE + 0x01BC)
+#define PCIBRI_AHBCTL4		__REG(PKUNITY_PCIBRI_BASE + 0x01C0)
+#define PCIBRI_AHBBAR4		__REG(PKUNITY_PCIBRI_BASE + 0x01C4)
+#define PCIBRI_AHBAMR4		__REG(PKUNITY_PCIBRI_BASE + 0x01C8)
+#define PCIBRI_AHBTAR4		__REG(PKUNITY_PCIBRI_BASE + 0x01CC)
+#define PCIBRI_AHBCTL5		__REG(PKUNITY_PCIBRI_BASE + 0x01D0)
+#define PCIBRI_AHBBAR5		__REG(PKUNITY_PCIBRI_BASE + 0x01D4)
+#define PCIBRI_AHBAMR5		__REG(PKUNITY_PCIBRI_BASE + 0x01D8)
+#define PCIBRI_AHBTAR5		__REG(PKUNITY_PCIBRI_BASE + 0x01DC)
+
+#define PCIBRI_CTLx_AT          FIELD(1, 1, 2)
+#define PCIBRI_CTLx_PREF        FIELD(1, 1, 1)
+#define PCIBRI_CTLx_MRL         FIELD(1, 1, 0)
+
+#define PCIBRI_BARx_ADDR        FIELD(0xFFFFFFFC, 30, 2)
+#define PCIBRI_BARx_IO          FIELD(1, 1, 0)
+#define PCIBRI_BARx_MEM         FIELD(0, 1, 0)
+
+#define PCIBRI_CMD_IO           FIELD(1, 1, 0)
+#define PCIBRI_CMD_MEM          FIELD(1, 1, 1)
diff --git a/arch/unicore32/include/mach/regs-pm.h b/arch/unicore32/include/mach/regs-pm.h
new file mode 100644
index 0000000..ed2d2fc
--- /dev/null
+++ b/arch/unicore32/include/mach/regs-pm.h
@@ -0,0 +1,126 @@
+/*
+ * PKUNITY Power Manager (PM) Registers
+ */
+/*
+ * PM Control Reg PM_PMCR
+ */
+#define PM_PMCR                 __REG(PKUNITY_PM_BASE + 0x0000)
+/*
+ * PM General Conf. Reg PM_PGCR
+ */
+#define PM_PGCR                 __REG(PKUNITY_PM_BASE + 0x0004)
+/*
+ * PM PLL Conf. Reg PM_PPCR
+ */
+#define PM_PPCR                 __REG(PKUNITY_PM_BASE + 0x0008)
+/*
+ * PM Wakeup Enable Reg PM_PWER
+ */
+#define PM_PWER                 __REG(PKUNITY_PM_BASE + 0x000C)
+/*
+ * PM GPIO Sleep Status Reg PM_PGSR
+ */
+#define PM_PGSR                 __REG(PKUNITY_PM_BASE + 0x0010)
+/*
+ * PM Clock Gate Reg PM_PCGR
+ */
+#define PM_PCGR                 __REG(PKUNITY_PM_BASE + 0x0014)
+/*
+ * PM SYS PLL Conf. Reg PM_PLLSYSCFG
+ */
+#define PM_PLLSYSCFG            __REG(PKUNITY_PM_BASE + 0x0018)
+/*
+ * PM DDR PLL Conf. Reg PM_PLLDDRCFG
+ */
+#define PM_PLLDDRCFG            __REG(PKUNITY_PM_BASE + 0x001C)
+/*
+ * PM VGA PLL Conf. Reg PM_PLLVGACFG
+ */
+#define PM_PLLVGACFG            __REG(PKUNITY_PM_BASE + 0x0020)
+/*
+ * PM Div Conf. Reg PM_DIVCFG
+ */
+#define PM_DIVCFG               __REG(PKUNITY_PM_BASE + 0x0024)
+/*
+ * PM SYS PLL Status Reg PM_PLLSYSSTATUS
+ */
+#define PM_PLLSYSSTATUS         __REG(PKUNITY_PM_BASE + 0x0028)
+/*
+ * PM DDR PLL Status Reg PM_PLLDDRSTATUS
+ */
+#define PM_PLLDDRSTATUS         __REG(PKUNITY_PM_BASE + 0x002C)
+/*
+ * PM VGA PLL Status Reg PM_PLLVGASTATUS
+ */
+#define PM_PLLVGASTATUS         __REG(PKUNITY_PM_BASE + 0x0030)
+/*
+ * PM Div Status Reg PM_DIVSTATUS
+ */
+#define PM_DIVSTATUS            __REG(PKUNITY_PM_BASE + 0x0034)
+/*
+ * PM Software Reset Reg PM_SWRESET
+ */
+#define PM_SWRESET              __REG(PKUNITY_PM_BASE + 0x0038)
+/*
+ * PM DDR2 PAD Start Reg PM_DDR2START
+ */
+#define PM_DDR2START            __REG(PKUNITY_PM_BASE + 0x003C)
+/*
+ * PM DDR2 PAD Status Reg PM_DDR2CAL0
+ */
+#define PM_DDR2CAL0             __REG(PKUNITY_PM_BASE + 0x0040)
+/*
+ * PM PLL DFC Done Reg PM_PLLDFCDONE
+ */
+#define PM_PLLDFCDONE           __REG(PKUNITY_PM_BASE + 0x0044)
+
+#define PM_PMCR_SFB             FIELD(1, 1, 0)
+#define PM_PMCR_IFB             FIELD(1, 1, 1)
+#define PM_PMCR_CFBSYS          FIELD(1, 1, 2)
+#define PM_PMCR_CFBDDR          FIELD(1, 1, 3)
+#define PM_PMCR_CFBVGA          FIELD(1, 1, 4)
+#define PM_PMCR_CFBDIVBCLK      FIELD(1, 1, 5)
+
+/*
+ * GPIO 8~27 wake-up enable PM_PWER_GPIOHIGH
+ */
+#define PM_PWER_GPIOHIGH        FIELD(1, 1, 8)
+/*
+ * RTC alarm wake-up enable PM_PWER_RTC
+ */
+#define PM_PWER_RTC             FIELD(1, 1, 31)
+
+#define PM_PCGR_BCLK64DDR	FIELD(1, 1, 0)
+#define PM_PCGR_BCLK64VGA	FIELD(1, 1, 1)
+#define PM_PCGR_BCLKDDR		FIELD(1, 1, 2)
+#define PM_PCGR_BCLKPCI		FIELD(1, 1, 4)
+#define PM_PCGR_BCLKDMAC	FIELD(1, 1, 5)
+#define PM_PCGR_BCLKUMAL	FIELD(1, 1, 6)
+#define PM_PCGR_BCLKUSB		FIELD(1, 1, 7)
+#define PM_PCGR_BCLKMME		FIELD(1, 1, 10)
+#define PM_PCGR_BCLKNAND	FIELD(1, 1, 11)
+#define PM_PCGR_BCLKH264E	FIELD(1, 1, 12)
+#define PM_PCGR_BCLKVGA		FIELD(1, 1, 13)
+#define PM_PCGR_BCLKH264D	FIELD(1, 1, 14)
+#define PM_PCGR_VECLK		FIELD(1, 1, 15)
+#define PM_PCGR_HECLK		FIELD(1, 1, 16)
+#define PM_PCGR_HDCLK		FIELD(1, 1, 17)
+#define PM_PCGR_NANDCLK		FIELD(1, 1, 18)
+#define PM_PCGR_GECLK		FIELD(1, 1, 19)
+#define PM_PCGR_VGACLK          FIELD(1, 1, 20)
+#define PM_PCGR_PCICLK		FIELD(1, 1, 21)
+#define PM_PCGR_SATACLK		FIELD(1, 1, 25)
+
+/*
+ * [23:20]PM_DIVCFG_VGACLK(v)
+ */
+#define PM_DIVCFG_VGACLK_MASK   FMASK(4, 20)
+#define PM_DIVCFG_VGACLK(v)	FIELD((v), 4, 20)
+
+#define PM_SWRESET_USB          FIELD(1, 1, 6)
+#define PM_SWRESET_VGADIV       FIELD(1, 1, 26)
+#define PM_SWRESET_GEDIV        FIELD(1, 1, 27)
+
+#define PM_PLLDFCDONE_SYSDFC    FIELD(1, 1, 0)
+#define PM_PLLDFCDONE_DDRDFC    FIELD(1, 1, 1)
+#define PM_PLLDFCDONE_VGADFC    FIELD(1, 1, 2)
diff --git a/arch/unicore32/include/mach/regs-ps2.h b/arch/unicore32/include/mach/regs-ps2.h
new file mode 100644
index 0000000..7da2071
--- /dev/null
+++ b/arch/unicore32/include/mach/regs-ps2.h
@@ -0,0 +1,20 @@
+/*
+ * PKUnity PS2 Controller Registers
+ */
+/*
+ * the same as I8042_DATA_REG PS2_DATA
+ */
+#define PS2_DATA	__REG(PKUNITY_PS2_BASE + 0x0060)
+/*
+ * the same as I8042_COMMAND_REG PS2_COMMAND
+ */
+#define PS2_COMMAND	__REG(PKUNITY_PS2_BASE + 0x0064)
+/*
+ * the same as I8042_STATUS_REG PS2_STATUS
+ */
+#define PS2_STATUS	__REG(PKUNITY_PS2_BASE + 0x0064)
+/*
+ * counter reg PS2_CNT
+ */
+#define PS2_CNT		__REG(PKUNITY_PS2_BASE + 0x0068)
+
diff --git a/arch/unicore32/include/mach/regs-resetc.h b/arch/unicore32/include/mach/regs-resetc.h
new file mode 100644
index 0000000..1763989
--- /dev/null
+++ b/arch/unicore32/include/mach/regs-resetc.h
@@ -0,0 +1,34 @@
+/*
+ * PKUnity Reset Controller (RC) Registers
+ */
+/*
+ * Software Reset Register
+ */
+#define RESETC_SWRR	__REG(PKUNITY_RESETC_BASE + 0x0000)
+/*
+ * Reset Status Register
+ */
+#define RESETC_RSSR	__REG(PKUNITY_RESETC_BASE + 0x0004)
+
+/*
+ * Software Reset Bit
+ */
+#define RESETC_SWRR_SRB		FIELD(1, 1, 0)
+
+/*
+ * Hardware Reset
+ */
+#define RESETC_RSSR_HWR		FIELD(1, 1, 0)
+/*
+ * Software Reset
+ */
+#define RESETC_RSSR_SWR		FIELD(1, 1, 1)
+/*
+ * Watchdog Reset
+ */
+#define RESETC_RSSR_WDR		FIELD(1, 1, 2)
+/*
+ * Sleep Mode Reset
+ */
+#define RESETC_RSSR_SMR		FIELD(1, 1, 3)
+
diff --git a/arch/unicore32/include/mach/regs-rtc.h b/arch/unicore32/include/mach/regs-rtc.h
new file mode 100644
index 0000000..155e387
--- /dev/null
+++ b/arch/unicore32/include/mach/regs-rtc.h
@@ -0,0 +1,37 @@
+/*
+ * PKUnity Real-Time Clock (RTC) control registers
+ */
+/*
+ * RTC Alarm Reg RTC_RTAR
+ */
+#define RTC_RTAR	__REG(PKUNITY_RTC_BASE + 0x0000)
+/*
+ * RTC Count Reg RTC_RCNR
+ */
+#define RTC_RCNR	__REG(PKUNITY_RTC_BASE + 0x0004)
+/*
+ * RTC Trim Reg RTC_RTTR
+ */
+#define RTC_RTTR	__REG(PKUNITY_RTC_BASE + 0x0008)
+/*
+ * RTC Status Reg RTC_RTSR
+ */
+#define RTC_RTSR	__REG(PKUNITY_RTC_BASE + 0x0010)
+
+/*
+ * ALarm detected RTC_RTSR_AL
+ */
+#define RTC_RTSR_AL		FIELD(1, 1, 0)
+/*
+ * 1 Hz clock detected RTC_RTSR_HZ
+ */
+#define RTC_RTSR_HZ		FIELD(1, 1, 1)
+/*
+ * ALarm interrupt Enable RTC_RTSR_ALE
+ */
+#define RTC_RTSR_ALE		FIELD(1, 1, 2)
+/*
+ * 1 Hz clock interrupt Enable RTC_RTSR_HZE
+ */
+#define RTC_RTSR_HZE		FIELD(1, 1, 3)
+
diff --git a/arch/unicore32/include/mach/regs-sdc.h b/arch/unicore32/include/mach/regs-sdc.h
new file mode 100644
index 0000000..3457b88
--- /dev/null
+++ b/arch/unicore32/include/mach/regs-sdc.h
@@ -0,0 +1,156 @@
+/*
+ * PKUnity Multi-Media Card and Security Digital Card (MMC/SD) Registers
+ */
+/*
+ * Clock Control Reg SDC_CCR
+ */
+#define SDC_CCR		__REG(PKUNITY_SDC_BASE + 0x0000)
+/*
+ * Software Reset Reg SDC_SRR
+ */
+#define SDC_SRR		__REG(PKUNITY_SDC_BASE + 0x0004)
+/*
+ * Argument Reg SDC_ARGUMENT
+ */
+#define SDC_ARGUMENT	__REG(PKUNITY_SDC_BASE + 0x0008)
+/*
+ * Command Reg SDC_COMMAND
+ */
+#define SDC_COMMAND	__REG(PKUNITY_SDC_BASE + 0x000C)
+/*
+ * Block Size Reg SDC_BLOCKSIZE
+ */
+#define SDC_BLOCKSIZE	__REG(PKUNITY_SDC_BASE + 0x0010)
+/*
+ * Block Cound Reg SDC_BLOCKCOUNT
+ */
+#define SDC_BLOCKCOUNT	__REG(PKUNITY_SDC_BASE + 0x0014)
+/*
+ * Transfer Mode Reg SDC_TMR
+ */
+#define SDC_TMR		__REG(PKUNITY_SDC_BASE + 0x0018)
+/*
+ * Response Reg. 0 SDC_RES0
+ */
+#define SDC_RES0	__REG(PKUNITY_SDC_BASE + 0x001C)
+/*
+ * Response Reg. 1 SDC_RES1
+ */
+#define SDC_RES1	__REG(PKUNITY_SDC_BASE + 0x0020)
+/*
+ * Response Reg. 2 SDC_RES2
+ */
+#define SDC_RES2	__REG(PKUNITY_SDC_BASE + 0x0024)
+/*
+ * Response Reg. 3 SDC_RES3
+ */
+#define SDC_RES3	__REG(PKUNITY_SDC_BASE + 0x0028)
+/*
+ * Read Timeout Control Reg SDC_RTCR
+ */
+#define SDC_RTCR	__REG(PKUNITY_SDC_BASE + 0x002C)
+/*
+ * Interrupt Status Reg SDC_ISR
+ */
+#define SDC_ISR		__REG(PKUNITY_SDC_BASE + 0x0030)
+/*
+ * Interrupt Status Mask Reg SDC_ISMR
+ */
+#define SDC_ISMR	__REG(PKUNITY_SDC_BASE + 0x0034)
+/*
+ * RX FIFO SDC_RXFIFO
+ */
+#define SDC_RXFIFO	__REG(PKUNITY_SDC_BASE + 0x0038)
+/*
+ * TX FIFO SDC_TXFIFO
+ */
+#define SDC_TXFIFO	__REG(PKUNITY_SDC_BASE + 0x003C)
+
+/*
+ * SD Clock Enable SDC_CCR_CLKEN
+ */
+#define SDC_CCR_CLKEN			FIELD(1, 1, 2)
+/*
+ * [15:8] SDC_CCR_PDIV(v)
+ */
+#define SDC_CCR_PDIV(v)			FIELD((v), 8, 8)
+
+/*
+ * Software reset enable SDC_SRR_ENABLE
+ */
+#define SDC_SRR_ENABLE			FIELD(0, 1, 0)
+/*
+ * Software reset disable SDC_SRR_DISABLE
+ */
+#define SDC_SRR_DISABLE			FIELD(1, 1, 0)
+
+/*
+ * Response type SDC_COMMAND_RESTYPE_MASK
+ */
+#define SDC_COMMAND_RESTYPE_MASK	FMASK(2, 0)
+/*
+ * No response SDC_COMMAND_RESTYPE_NONE
+ */
+#define SDC_COMMAND_RESTYPE_NONE	FIELD(0, 2, 0)
+/*
+ * 136-bit long response SDC_COMMAND_RESTYPE_LONG
+ */
+#define SDC_COMMAND_RESTYPE_LONG	FIELD(1, 2, 0)
+/*
+ * 48-bit short response SDC_COMMAND_RESTYPE_SHORT
+ */
+#define SDC_COMMAND_RESTYPE_SHORT	FIELD(2, 2, 0)
+/*
+ * 48-bit short and test if busy response SDC_COMMAND_RESTYPE_SHORTBUSY
+ */
+#define SDC_COMMAND_RESTYPE_SHORTBUSY	FIELD(3, 2, 0)
+/*
+ * data ready SDC_COMMAND_DATAREADY
+ */
+#define SDC_COMMAND_DATAREADY		FIELD(1, 1, 2)
+#define SDC_COMMAND_CMDEN		FIELD(1, 1, 3)
+/*
+ * [10:5] SDC_COMMAND_CMDINDEX(v)
+ */
+#define SDC_COMMAND_CMDINDEX(v)		FIELD((v), 6, 5)
+
+/*
+ * [10:0] SDC_BLOCKSIZE_BSMASK(v)
+ */
+#define SDC_BLOCKSIZE_BSMASK(v)		FIELD((v), 11, 0)
+/*
+ * [11:0] SDC_BLOCKCOUNT_BCMASK(v)
+ */
+#define SDC_BLOCKCOUNT_BCMASK(v)	FIELD((v), 12, 0)
+
+/*
+ * Data Width 1bit SDC_TMR_WTH_1BIT
+ */
+#define SDC_TMR_WTH_1BIT		FIELD(0, 1, 0)
+/*
+ * Data Width 4bit SDC_TMR_WTH_4BIT
+ */
+#define SDC_TMR_WTH_4BIT		FIELD(1, 1, 0)
+/*
+ * Read SDC_TMR_DIR_READ
+ */
+#define SDC_TMR_DIR_READ		FIELD(0, 1, 1)
+/*
+ * Write SDC_TMR_DIR_WRITE
+ */
+#define SDC_TMR_DIR_WRITE		FIELD(1, 1, 1)
+
+#define SDC_IR_MASK			FMASK(13, 0)
+#define SDC_IR_RESTIMEOUT		FIELD(1, 1, 0)
+#define SDC_IR_WRITECRC			FIELD(1, 1, 1)
+#define SDC_IR_READCRC			FIELD(1, 1, 2)
+#define SDC_IR_TXFIFOREAD		FIELD(1, 1, 3)
+#define SDC_IR_RXFIFOWRITE		FIELD(1, 1, 4)
+#define SDC_IR_READTIMEOUT		FIELD(1, 1, 5)
+#define SDC_IR_DATACOMPLETE		FIELD(1, 1, 6)
+#define SDC_IR_CMDCOMPLETE		FIELD(1, 1, 7)
+#define SDC_IR_RXFIFOFULL		FIELD(1, 1, 8)
+#define SDC_IR_RXFIFOEMPTY		FIELD(1, 1, 9)
+#define SDC_IR_TXFIFOFULL		FIELD(1, 1, 10)
+#define SDC_IR_TXFIFOEMPTY		FIELD(1, 1, 11)
+#define SDC_IR_ENDCMDWITHRES		FIELD(1, 1, 12)
diff --git a/arch/unicore32/include/mach/regs-spi.h b/arch/unicore32/include/mach/regs-spi.h
new file mode 100644
index 0000000..cadc713
--- /dev/null
+++ b/arch/unicore32/include/mach/regs-spi.h
@@ -0,0 +1,98 @@
+/*
+ * PKUnity Serial Peripheral Interface (SPI) Registers
+ */
+/*
+ * Control reg. 0 SPI_CR0
+ */
+#define SPI_CR0		__REG(PKUNITY_SPI_BASE + 0x0000)
+/*
+ * Control reg. 1 SPI_CR1
+ */
+#define SPI_CR1		__REG(PKUNITY_SPI_BASE + 0x0004)
+/*
+ * Enable reg SPI_SSIENR
+ */
+#define SPI_SSIENR	__REG(PKUNITY_SPI_BASE + 0x0008)
+/*
+ * Status reg SPI_SR
+ */
+#define SPI_SR		__REG(PKUNITY_SPI_BASE + 0x0028)
+/*
+ * Interrupt Mask reg SPI_IMR
+ */
+#define SPI_IMR		__REG(PKUNITY_SPI_BASE + 0x002C)
+/*
+ * Interrupt Status reg SPI_ISR
+ */
+#define SPI_ISR		__REG(PKUNITY_SPI_BASE + 0x0030)
+
+/*
+ * Enable SPI Controller SPI_SSIENR_EN
+ */
+#define SPI_SSIENR_EN		FIELD(1, 1, 0)
+
+/*
+ * SPI Busy SPI_SR_BUSY
+ */
+#define SPI_SR_BUSY		FIELD(1, 1, 0)
+/*
+ * Transmit FIFO Not Full SPI_SR_TFNF
+ */
+#define SPI_SR_TFNF		FIELD(1, 1, 1)
+/*
+ * Transmit FIFO Empty SPI_SR_TFE
+ */
+#define SPI_SR_TFE		FIELD(1, 1, 2)
+/*
+ * Receive FIFO Not Empty SPI_SR_RFNE
+ */
+#define SPI_SR_RFNE		FIELD(1, 1, 3)
+/*
+ * Receive FIFO Full SPI_SR_RFF
+ */
+#define SPI_SR_RFF		FIELD(1, 1, 4)
+
+/*
+ * Trans. FIFO Empty Interrupt Status SPI_ISR_TXEIS
+ */
+#define SPI_ISR_TXEIS		FIELD(1, 1, 0)
+/*
+ * Trans. FIFO Overflow Interrupt Status SPI_ISR_TXOIS
+ */
+#define SPI_ISR_TXOIS		FIELD(1, 1, 1)
+/*
+ * Receiv. FIFO Underflow Interrupt Status SPI_ISR_RXUIS
+ */
+#define SPI_ISR_RXUIS		FIELD(1, 1, 2)
+/*
+ * Receiv. FIFO Overflow Interrupt Status SPI_ISR_RXOIS
+ */
+#define SPI_ISR_RXOIS		FIELD(1, 1, 3)
+/*
+ * Receiv. FIFO Full Interrupt Status SPI_ISR_RXFIS
+ */
+#define SPI_ISR_RXFIS		FIELD(1, 1, 4)
+#define SPI_ISR_MSTIS		FIELD(1, 1, 5)
+
+/*
+ * Trans. FIFO Empty Interrupt Mask SPI_IMR_TXEIM
+ */
+#define SPI_IMR_TXEIM		FIELD(1, 1, 0)
+/*
+ * Trans. FIFO Overflow Interrupt Mask SPI_IMR_TXOIM
+ */
+#define SPI_IMR_TXOIM		FIELD(1, 1, 1)
+/*
+ * Receiv. FIFO Underflow Interrupt Mask SPI_IMR_RXUIM
+ */
+#define SPI_IMR_RXUIM		FIELD(1, 1, 2)
+/*
+ * Receiv. FIFO Overflow Interrupt Mask SPI_IMR_RXOIM
+ */
+#define SPI_IMR_RXOIM		FIELD(1, 1, 3)
+/*
+ * Receiv. FIFO Full Interrupt Mask SPI_IMR_RXFIM
+ */
+#define SPI_IMR_RXFIM		FIELD(1, 1, 4)
+#define SPI_IMR_MSTIM		FIELD(1, 1, 5)
+
diff --git a/arch/unicore32/include/mach/regs-uart.h b/arch/unicore32/include/mach/regs-uart.h
new file mode 100644
index 0000000..9fa6b19
--- /dev/null
+++ b/arch/unicore32/include/mach/regs-uart.h
@@ -0,0 +1,3 @@
+/*
+ * PKUnity Universal Asynchronous Receiver/Transmitter (UART) Registers
+ */
diff --git a/arch/unicore32/include/mach/regs-umal.h b/arch/unicore32/include/mach/regs-umal.h
new file mode 100644
index 0000000..2e718d1
--- /dev/null
+++ b/arch/unicore32/include/mach/regs-umal.h
@@ -0,0 +1,229 @@
+/*
+ * PKUnity Ultra Media Access Layer (UMAL) Ethernet MAC Registers
+ */
+
+/* MAC module of UMAL */
+/* UMAL's MAC module includes G/MII interface, several additional PHY
+ * interfaces, and MAC control sub-layer, which provides support for control
+ * frames (e.g. PAUSE frames).
+ */
+/*
+ * TX/RX reset and control UMAL_CFG1
+ */
+#define UMAL_CFG1		__REG(PKUNITY_UMAL_BASE + 0x0000)
+/*
+ * MAC interface mode control UMAL_CFG2
+ */
+#define UMAL_CFG2		__REG(PKUNITY_UMAL_BASE + 0x0004)
+/*
+ * Inter Packet/Frame Gap UMAL_IPGIFG
+ */
+#define UMAL_IPGIFG		__REG(PKUNITY_UMAL_BASE + 0x0008)
+/*
+ * Collision retry or backoff UMAL_HALFDUPLEX
+ */
+#define UMAL_HALFDUPLEX		__REG(PKUNITY_UMAL_BASE + 0x000c)
+/*
+ * Maximum Frame Length UMAL_MAXFRAME
+ */
+#define UMAL_MAXFRAME		__REG(PKUNITY_UMAL_BASE + 0x0010)
+/*
+ * Test Regsiter UMAL_TESTREG
+ */
+#define UMAL_TESTREG		__REG(PKUNITY_UMAL_BASE + 0x001c)
+/*
+ * MII Management Configure UMAL_MIICFG
+ */
+#define UMAL_MIICFG		__REG(PKUNITY_UMAL_BASE + 0x0020)
+/*
+ * MII Management Command UMAL_MIICMD
+ */
+#define UMAL_MIICMD		__REG(PKUNITY_UMAL_BASE + 0x0024)
+/*
+ * MII Management Address UMAL_MIIADDR
+ */
+#define UMAL_MIIADDR		__REG(PKUNITY_UMAL_BASE + 0x0028)
+/*
+ * MII Management Control UMAL_MIICTRL
+ */
+#define UMAL_MIICTRL		__REG(PKUNITY_UMAL_BASE + 0x002c)
+/*
+ * MII Management Status UMAL_MIISTATUS
+ */
+#define UMAL_MIISTATUS		__REG(PKUNITY_UMAL_BASE + 0x0030)
+/*
+ * MII Managment Indicator UMAL_MIIIDCT
+ */
+#define UMAL_MIIIDCT		__REG(PKUNITY_UMAL_BASE + 0x0034)
+/*
+ * Interface Control UMAL_IFCTRL
+ */
+#define UMAL_IFCTRL		__REG(PKUNITY_UMAL_BASE + 0x0038)
+/*
+ * Interface Status UMAL_IFSTATUS
+ */
+#define UMAL_IFSTATUS		__REG(PKUNITY_UMAL_BASE + 0x003c)
+/*
+ * MAC address (high 4 bytes) UMAL_STADDR1
+ */
+#define UMAL_STADDR1		__REG(PKUNITY_UMAL_BASE + 0x0040)
+/*
+ * MAC address (low 2 bytes) UMAL_STADDR2
+ */
+#define UMAL_STADDR2		__REG(PKUNITY_UMAL_BASE + 0x0044)
+
+/* FIFO MODULE OF UMAL */
+/* UMAL's FIFO module provides data queuing for increased system level
+ * throughput
+ */
+#define UMAL_FIFOCFG0		__REG(PKUNITY_UMAL_BASE + 0x0048)
+#define UMAL_FIFOCFG1		__REG(PKUNITY_UMAL_BASE + 0x004c)
+#define UMAL_FIFOCFG2		__REG(PKUNITY_UMAL_BASE + 0x0050)
+#define UMAL_FIFOCFG3		__REG(PKUNITY_UMAL_BASE + 0x0054)
+#define UMAL_FIFOCFG4		__REG(PKUNITY_UMAL_BASE + 0x0058)
+#define UMAL_FIFOCFG5		__REG(PKUNITY_UMAL_BASE + 0x005c)
+#define UMAL_FIFORAM0		__REG(PKUNITY_UMAL_BASE + 0x0060)
+#define UMAL_FIFORAM1		__REG(PKUNITY_UMAL_BASE + 0x0064)
+#define UMAL_FIFORAM2		__REG(PKUNITY_UMAL_BASE + 0x0068)
+#define UMAL_FIFORAM3		__REG(PKUNITY_UMAL_BASE + 0x006c)
+#define UMAL_FIFORAM4		__REG(PKUNITY_UMAL_BASE + 0x0070)
+#define UMAL_FIFORAM5		__REG(PKUNITY_UMAL_BASE + 0x0074)
+#define UMAL_FIFORAM6		__REG(PKUNITY_UMAL_BASE + 0x0078)
+#define UMAL_FIFORAM7		__REG(PKUNITY_UMAL_BASE + 0x007c)
+
+/* MAHBE MODUEL OF UMAL */
+/* UMAL's MAHBE module interfaces to the host system through 32-bit AHB Master
+ * and Slave ports.Registers within the M-AHBE provide Control and Status
+ * information concerning these transfers.
+ */
+/*
+ * Transmit Control UMAL_DMATxCtrl
+ */
+#define UMAL_DMATxCtrl		__REG(PKUNITY_UMAL_BASE + 0x0180)
+/*
+ * Pointer to TX Descripter UMAL_DMATxDescriptor
+ */
+#define UMAL_DMATxDescriptor	__REG(PKUNITY_UMAL_BASE + 0x0184)
+/*
+ * Status of Tx Packet Transfers UMAL_DMATxStatus
+ */
+#define UMAL_DMATxStatus	__REG(PKUNITY_UMAL_BASE + 0x0188)
+/*
+ * Receive Control UMAL_DMARxCtrl
+ */
+#define UMAL_DMARxCtrl		__REG(PKUNITY_UMAL_BASE + 0x018c)
+/*
+ * Pointer to Rx Descriptor UMAL_DMARxDescriptor
+ */
+#define UMAL_DMARxDescriptor	__REG(PKUNITY_UMAL_BASE + 0x0190)
+/*
+ * Status of Rx Packet Transfers UMAL_DMARxStatus
+ */
+#define UMAL_DMARxStatus	__REG(PKUNITY_UMAL_BASE + 0x0194)
+/*
+ * Interrupt Mask UMAL_DMAIntrMask
+ */
+#define UMAL_DMAIntrMask	__REG(PKUNITY_UMAL_BASE + 0x0198)
+/*
+ * Interrupts, read only UMAL_DMAInterrupt
+ */
+#define UMAL_DMAInterrupt	__REG(PKUNITY_UMAL_BASE + 0x019c)
+
+/*
+ * Commands for UMAL_CFG1 register
+ */
+#define UMAL_CFG1_TXENABLE	FIELD(1, 1, 0)
+#define UMAL_CFG1_RXENABLE	FIELD(1, 1, 2)
+#define UMAL_CFG1_TXFLOWCTL	FIELD(1, 1, 4)
+#define UMAL_CFG1_RXFLOWCTL	FIELD(1, 1, 5)
+#define UMAL_CFG1_CONFLPBK	FIELD(1, 1, 8)
+#define UMAL_CFG1_RESET		FIELD(1, 1, 31)
+#define UMAL_CFG1_CONFFLCTL	(MAC_TX_FLOW_CTL | MAC_RX_FLOW_CTL)
+
+/*
+ * Commands for UMAL_CFG2 register
+ */
+#define UMAL_CFG2_FULLDUPLEX	FIELD(1, 1, 0)
+#define UMAL_CFG2_CRCENABLE	FIELD(1, 1, 1)
+#define UMAL_CFG2_PADCRC	FIELD(1, 1, 2)
+#define UMAL_CFG2_LENGTHCHECK	FIELD(1, 1, 4)
+#define UMAL_CFG2_MODEMASK	FMASK(2, 8)
+#define UMAL_CFG2_NIBBLEMODE	FIELD(1, 2, 8)
+#define UMAL_CFG2_BYTEMODE	FIELD(2, 2, 8)
+#define UMAL_CFG2_PREAMBLENMASK	FMASK(4, 12)
+#define UMAL_CFG2_DEFPREAMBLEN	FIELD(7, 4, 12)
+#define UMAL_CFG2_FD100		(UMAL_CFG2_DEFPREAMBLEN | UMAL_CFG2_NIBBLEMODE \
+				| UMAL_CFG2_LENGTHCHECK | UMAL_CFG2_PADCRC \
+				| UMAL_CFG2_CRCENABLE | UMAL_CFG2_FULLDUPLEX)
+#define UMAL_CFG2_FD1000	(UMAL_CFG2_DEFPREAMBLEN | UMAL_CFG2_BYTEMODE \
+				| UMAL_CFG2_LENGTHCHECK | UMAL_CFG2_PADCRC \
+				| UMAL_CFG2_CRCENABLE | UMAL_CFG2_FULLDUPLEX)
+#define UMAL_CFG2_HD100		(UMAL_CFG2_DEFPREAMBLEN | UMAL_CFG2_NIBBLEMODE \
+				| UMAL_CFG2_LENGTHCHECK | UMAL_CFG2_PADCRC \
+				| UMAL_CFG2_CRCENABLE)
+
+/*
+ * Command for UMAL_IFCTRL register
+ */
+#define UMAL_IFCTRL_RESET	FIELD(1, 1, 31)
+
+/*
+ * Command for UMAL_MIICFG register
+ */
+#define UMAL_MIICFG_RESET	FIELD(1, 1, 31)
+
+/*
+ * Command for UMAL_MIICMD register
+ */
+#define UMAL_MIICMD_READ	FIELD(1, 1, 0)
+
+/*
+ * Command for UMAL_MIIIDCT register
+ */
+#define UMAL_MIIIDCT_BUSY	FIELD(1, 1, 0)
+#define UMAL_MIIIDCT_NOTVALID	FIELD(1, 1, 2)
+
+/*
+ * Commands for DMATxCtrl regesters
+ */
+#define UMAL_DMA_Enable		FIELD(1, 1, 0)
+
+/*
+ * Commands for DMARxCtrl regesters
+ */
+#define UMAL_DMAIntrMask_ENABLEHALFWORD	FIELD(1, 1, 16)
+
+/*
+ * Command for DMARxStatus
+ */
+#define CLR_RX_BUS_ERR		FIELD(1, 1, 3)
+#define CLR_RX_OVERFLOW		FIELD(1, 1, 2)
+#define CLR_RX_PKT		FIELD(1, 1, 0)
+
+/*
+ * Command for DMATxStatus
+ */
+#define CLR_TX_BUS_ERR		FIELD(1, 1, 3)
+#define CLR_TX_UNDERRUN		FIELD(1, 1, 1)
+#define CLR_TX_PKT		FIELD(1, 1, 0)
+
+/*
+ * Commands for DMAIntrMask and DMAInterrupt register
+ */
+#define INT_RX_MASK		FIELD(0xd, 4, 4)
+#define INT_TX_MASK		FIELD(0xb, 4, 0)
+
+#define INT_RX_BUS_ERR		FIELD(1, 1, 7)
+#define INT_RX_OVERFLOW		FIELD(1, 1, 6)
+#define INT_RX_PKT		FIELD(1, 1, 4)
+#define INT_TX_BUS_ERR		FIELD(1, 1, 3)
+#define INT_TX_UNDERRUN		FIELD(1, 1, 1)
+#define INT_TX_PKT		FIELD(1, 1, 0)
+
+/*
+ * MARCOS of UMAL's descriptors
+ */
+#define UMAL_DESC_PACKETSIZE_EMPTY	FIELD(1, 1, 31)
+#define UMAL_DESC_PACKETSIZE_NONEMPTY	FIELD(0, 1, 31)
+#define UMAL_DESC_PACKETSIZE_SIZEMASK	FMASK(12, 0)
+
diff --git a/arch/unicore32/include/mach/regs-unigfx.h b/arch/unicore32/include/mach/regs-unigfx.h
new file mode 100644
index 0000000..58bbd54
--- /dev/null
+++ b/arch/unicore32/include/mach/regs-unigfx.h
@@ -0,0 +1,200 @@
+/*
+ * PKUnity UNIGFX Registers
+ */
+
+#define UDE_BASE      (PKUNITY_UNIGFX_BASE + 0x1400)
+#define UGE_BASE      (PKUNITY_UNIGFX_BASE + 0x0000)
+
+/*
+ * command reg for UNIGFX DE
+ */
+/*
+ * control reg UDE_CFG
+ */
+#define UDE_CFG       __REG(UDE_BASE + 0x0000)
+/*
+ * framebuffer start address reg UDE_FSA
+ */
+#define UDE_FSA       __REG(UDE_BASE + 0x0004)
+/*
+ * line size reg UDE_LS
+ */
+#define UDE_LS        __REG(UDE_BASE + 0x0008)
+/*
+ * pitch size reg UDE_PS
+ */
+#define UDE_PS        __REG(UDE_BASE + 0x000C)
+/*
+ * horizontal active time reg UDE_HAT
+ */
+#define UDE_HAT       __REG(UDE_BASE + 0x0010)
+/*
+ * horizontal blank time reg UDE_HBT
+ */
+#define UDE_HBT       __REG(UDE_BASE + 0x0014)
+/*
+ * horizontal sync time reg UDE_HST
+ */
+#define UDE_HST       __REG(UDE_BASE + 0x0018)
+/*
+ * vertival active time reg UDE_VAT
+ */
+#define UDE_VAT       __REG(UDE_BASE + 0x001C)
+/*
+ * vertival blank time reg UDE_VBT
+ */
+#define UDE_VBT       __REG(UDE_BASE + 0x0020)
+/*
+ * vertival sync time reg UDE_VST
+ */
+#define UDE_VST       __REG(UDE_BASE + 0x0024)
+/*
+ * cursor position UDE_CXY
+ */
+#define UDE_CXY       __REG(UDE_BASE + 0x0028)
+/*
+ * cursor front color UDE_CC0
+ */
+#define UDE_CC0       __REG(UDE_BASE + 0x002C)
+/*
+ * cursor background color UDE_CC1
+ */
+#define UDE_CC1       __REG(UDE_BASE + 0x0030)
+/*
+ * video position UDE_VXY
+ */
+#define UDE_VXY       __REG(UDE_BASE + 0x0034)
+/*
+ * video start address reg UDE_VSA
+ */
+#define UDE_VSA       __REG(UDE_BASE + 0x0040)
+/*
+ * video size reg UDE_VS
+ */
+#define UDE_VS        __REG(UDE_BASE + 0x004C)
+
+/*
+ * command reg for UNIGFX GE
+ */
+/*
+ * src xy reg UGE_SRCXY
+ */
+#define UGE_SRCXY     __REG(UGE_BASE + 0x0000)
+/*
+ * dst xy reg UGE_DSTXY
+ */
+#define UGE_DSTXY     __REG(UGE_BASE + 0x0004)
+/*
+ * pitch reg UGE_PITCH
+ */
+#define UGE_PITCH     __REG(UGE_BASE + 0x0008)
+/*
+ * src start reg UGE_SRCSTART
+ */
+#define UGE_SRCSTART  __REG(UGE_BASE + 0x000C)
+/*
+ * dst start reg UGE_DSTSTART
+ */
+#define UGE_DSTSTART  __REG(UGE_BASE + 0x0010)
+/*
+ * width height reg UGE_WIDHEIGHT
+ */
+#define UGE_WIDHEIGHT __REG(UGE_BASE + 0x0014)
+/*
+ * rop alpah reg UGE_ROPALPHA
+ */
+#define UGE_ROPALPHA  __REG(UGE_BASE + 0x0018)
+/*
+ * front color UGE_FCOLOR
+ */
+#define UGE_FCOLOR    __REG(UGE_BASE + 0x001C)
+/*
+ * background color UGE_BCOLOR
+ */
+#define UGE_BCOLOR    __REG(UGE_BASE + 0x0020)
+/*
+ * src color key for high value UGE_SCH
+ */
+#define UGE_SCH       __REG(UGE_BASE + 0x0024)
+/*
+ * dst color key for high value UGE_DCH
+ */
+#define UGE_DCH       __REG(UGE_BASE + 0x0028)
+/*
+ * src color key for low value UGE_SCL
+ */
+#define UGE_SCL       __REG(UGE_BASE + 0x002C)
+/*
+ * dst color key for low value UGE_DCL
+ */
+#define UGE_DCL       __REG(UGE_BASE + 0x0030)
+/*
+ * clip 0 reg UGE_CLIP0
+ */
+#define UGE_CLIP0     __REG(UGE_BASE + 0x0034)
+/*
+ * clip 1 reg UGE_CLIP1
+ */
+#define UGE_CLIP1     __REG(UGE_BASE + 0x0038)
+/*
+ * command reg UGE_COMMAND
+ */
+#define UGE_COMMAND   __REG(UGE_BASE + 0x003C)
+/*
+ * pattern 0 UGE_P0
+ */
+#define UGE_P0        __REG(UGE_BASE + 0x0040)
+#define UGE_P1        __REG(UGE_BASE + 0x0044)
+#define UGE_P2        __REG(UGE_BASE + 0x0048)
+#define UGE_P3        __REG(UGE_BASE + 0x004C)
+#define UGE_P4        __REG(UGE_BASE + 0x0050)
+#define UGE_P5        __REG(UGE_BASE + 0x0054)
+#define UGE_P6        __REG(UGE_BASE + 0x0058)
+#define UGE_P7        __REG(UGE_BASE + 0x005C)
+#define UGE_P8        __REG(UGE_BASE + 0x0060)
+#define UGE_P9        __REG(UGE_BASE + 0x0064)
+#define UGE_P10       __REG(UGE_BASE + 0x0068)
+#define UGE_P11       __REG(UGE_BASE + 0x006C)
+#define UGE_P12       __REG(UGE_BASE + 0x0070)
+#define UGE_P13       __REG(UGE_BASE + 0x0074)
+#define UGE_P14       __REG(UGE_BASE + 0x0078)
+#define UGE_P15       __REG(UGE_BASE + 0x007C)
+#define UGE_P16       __REG(UGE_BASE + 0x0080)
+#define UGE_P17       __REG(UGE_BASE + 0x0084)
+#define UGE_P18       __REG(UGE_BASE + 0x0088)
+#define UGE_P19       __REG(UGE_BASE + 0x008C)
+#define UGE_P20       __REG(UGE_BASE + 0x0090)
+#define UGE_P21       __REG(UGE_BASE + 0x0094)
+#define UGE_P22       __REG(UGE_BASE + 0x0098)
+#define UGE_P23       __REG(UGE_BASE + 0x009C)
+#define UGE_P24       __REG(UGE_BASE + 0x00A0)
+#define UGE_P25       __REG(UGE_BASE + 0x00A4)
+#define UGE_P26       __REG(UGE_BASE + 0x00A8)
+#define UGE_P27       __REG(UGE_BASE + 0x00AC)
+#define UGE_P28       __REG(UGE_BASE + 0x00B0)
+#define UGE_P29       __REG(UGE_BASE + 0x00B4)
+#define UGE_P30       __REG(UGE_BASE + 0x00B8)
+#define UGE_P31       __REG(UGE_BASE + 0x00BC)
+
+#define UDE_CFG_DST_MASK	FMASK(2, 8)
+#define UDE_CFG_DST8            FIELD(0x0, 2, 8)
+#define UDE_CFG_DST16           FIELD(0x1, 2, 8)
+#define UDE_CFG_DST24           FIELD(0x2, 2, 8)
+#define UDE_CFG_DST32           FIELD(0x3, 2, 8)
+
+/*
+ * GDEN enable UDE_CFG_GDEN_ENABLE
+ */
+#define UDE_CFG_GDEN_ENABLE     FIELD(1, 1, 3)
+/*
+ * VDEN enable UDE_CFG_VDEN_ENABLE
+ */
+#define UDE_CFG_VDEN_ENABLE     FIELD(1, 1, 4)
+/*
+ * CDEN enable UDE_CFG_CDEN_ENABLE
+ */
+#define UDE_CFG_CDEN_ENABLE     FIELD(1, 1, 5)
+/*
+ * TIMEUP enable UDE_CFG_TIMEUP_ENABLE
+ */
+#define UDE_CFG_TIMEUP_ENABLE   FIELD(1, 1, 6)
-- 
1.6.2.2


