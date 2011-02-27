Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713Ab1B0QCY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 11:02:24 -0500
Received: from hera.kernel.org ([140.211.167.34]:58604 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752482Ab1B0QCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 11:02:19 -0500
From: Guan Xuetao <epip@hera.kernel.org>
To: arnd@arndb.de
Cc: GuanXuetao <gxt@mprc.pku.edu.cn>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, greg@kroah.com
Subject: [PATCH 16/17] unicore32: add (void __iomem *) to io_p2v macro
Date: Sun, 27 Feb 2011 15:59:44 +0000
Message-Id: <e01e265d8c1ee1acf67177717a3611691cccf1da.1298821856.git.epip@hera.kernel.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <cover.1298821856.git.epip@hera.kernel.org>
References: <cover.1298821856.git.epip@hera.kernel.org>
In-Reply-To: <cover.1298821856.git.epip@hera.kernel.org>
References: <cover.1298821856.git.epip@hera.kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 27 Feb 2011 16:01:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: GuanXuetao <gxt@mprc.pku.edu.cn>

-- by advice with Arnd Bergmann

Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
---
 arch/unicore32/include/mach/hardware.h    |    9 +--
 arch/unicore32/include/mach/regs-ac97.h   |   20 ++--
 arch/unicore32/include/mach/regs-dmac.h   |   20 ++--
 arch/unicore32/include/mach/regs-gpio.h   |   16 ++--
 arch/unicore32/include/mach/regs-i2c.h    |   16 ++--
 arch/unicore32/include/mach/regs-intc.h   |   12 ++--
 arch/unicore32/include/mach/regs-nand.h   |   32 ++++----
 arch/unicore32/include/mach/regs-ost.h    |   22 +++---
 arch/unicore32/include/mach/regs-pci.h    |  122 ++++++++++++++--------------
 arch/unicore32/include/mach/regs-pm.h     |   36 ++++----
 arch/unicore32/include/mach/regs-ps2.h    |    8 +-
 arch/unicore32/include/mach/regs-resetc.h |    4 +-
 arch/unicore32/include/mach/regs-rtc.h    |    8 +-
 arch/unicore32/include/mach/regs-sdc.h    |   32 ++++----
 arch/unicore32/include/mach/regs-spi.h    |   12 ++--
 arch/unicore32/include/mach/regs-umal.h   |   76 +++++++++---------
 arch/unicore32/include/mach/regs-unigfx.h |  128 ++++++++++++++--------------
 17 files changed, 285 insertions(+), 288 deletions(-)

diff --git a/arch/unicore32/include/mach/hardware.h b/arch/unicore32/include/mach/hardware.h
index b71405a..b197b0b 100644
--- a/arch/unicore32/include/mach/hardware.h
+++ b/arch/unicore32/include/mach/hardware.h
@@ -17,13 +17,10 @@
 
 #include "PKUnity.h"
 
-#define io_p2v(x)	((x) - PKUNITY_MMIO_BASE)
-#define io_v2p(x)	((x) + PKUNITY_MMIO_BASE)
-
 #ifndef __ASSEMBLY__
-
-# define __REG(x)	(void __iomem *)io_p2v(x)
-
+#define io_p2v(x)	(void __iomem *)((x) - PKUNITY_MMIO_BASE)
+#else
+#define io_p2v(x)	((x) - PKUNITY_MMIO_BASE)
 #endif
 
 #define PCIBIOS_MIN_IO			0x4000 /* should lower than 64KB */
diff --git a/arch/unicore32/include/mach/regs-ac97.h b/arch/unicore32/include/mach/regs-ac97.h
index ce299bf..2d76cc3 100644
--- a/arch/unicore32/include/mach/regs-ac97.h
+++ b/arch/unicore32/include/mach/regs-ac97.h
@@ -2,16 +2,16 @@
  * PKUnity AC97 Registers
  */
 
-#define PKUNITY_AC97_CONR		__REG(PKUNITY_AC97_BASE + 0x0000)
-#define PKUNITY_AC97_OCR		__REG(PKUNITY_AC97_BASE + 0x0004)
-#define PKUNITY_AC97_ICR		__REG(PKUNITY_AC97_BASE + 0x0008)
-#define PKUNITY_AC97_CRAC		__REG(PKUNITY_AC97_BASE + 0x000C)
-#define PKUNITY_AC97_INTR		__REG(PKUNITY_AC97_BASE + 0x0010)
-#define PKUNITY_AC97_INTRSTAT		__REG(PKUNITY_AC97_BASE + 0x0014)
-#define PKUNITY_AC97_INTRCLEAR		__REG(PKUNITY_AC97_BASE + 0x0018)
-#define PKUNITY_AC97_ENABLE		__REG(PKUNITY_AC97_BASE + 0x001C)
-#define PKUNITY_AC97_OUT_FIFO		__REG(PKUNITY_AC97_BASE + 0x0020)
-#define PKUNITY_AC97_IN_FIFO		__REG(PKUNITY_AC97_BASE + 0x0030)
+#define PKUNITY_AC97_CONR		io_p2v(PKUNITY_AC97_BASE + 0x0000)
+#define PKUNITY_AC97_OCR		io_p2v(PKUNITY_AC97_BASE + 0x0004)
+#define PKUNITY_AC97_ICR		io_p2v(PKUNITY_AC97_BASE + 0x0008)
+#define PKUNITY_AC97_CRAC		io_p2v(PKUNITY_AC97_BASE + 0x000C)
+#define PKUNITY_AC97_INTR		io_p2v(PKUNITY_AC97_BASE + 0x0010)
+#define PKUNITY_AC97_INTRSTAT		io_p2v(PKUNITY_AC97_BASE + 0x0014)
+#define PKUNITY_AC97_INTRCLEAR		io_p2v(PKUNITY_AC97_BASE + 0x0018)
+#define PKUNITY_AC97_ENABLE		io_p2v(PKUNITY_AC97_BASE + 0x001C)
+#define PKUNITY_AC97_OUT_FIFO		io_p2v(PKUNITY_AC97_BASE + 0x0020)
+#define PKUNITY_AC97_IN_FIFO		io_p2v(PKUNITY_AC97_BASE + 0x0030)
 
 #define AC97_CODEC_REG(v)               FIELD((v), 7, 16)
 #define AC97_CODEC_VAL(v)               FIELD((v), 16, 0)
diff --git a/arch/unicore32/include/mach/regs-dmac.h b/arch/unicore32/include/mach/regs-dmac.h
index 09fce9d..3553243 100644
--- a/arch/unicore32/include/mach/regs-dmac.h
+++ b/arch/unicore32/include/mach/regs-dmac.h
@@ -5,27 +5,27 @@
 /*
  * Interrupt Status Reg DMAC_ISR.
  */
-#define DMAC_ISR		__REG(PKUNITY_DMAC_BASE + 0x0020)
+#define DMAC_ISR		io_p2v(PKUNITY_DMAC_BASE + 0x0020)
 /*
  * Interrupt Transfer Complete Status Reg DMAC_ITCSR.
  */
-#define DMAC_ITCSR		__REG(PKUNITY_DMAC_BASE + 0x0050)
+#define DMAC_ITCSR		io_p2v(PKUNITY_DMAC_BASE + 0x0050)
 /*
  * Interrupt Transfer Complete Clear Reg DMAC_ITCCR.
  */
-#define DMAC_ITCCR		__REG(PKUNITY_DMAC_BASE + 0x0060)
+#define DMAC_ITCCR		io_p2v(PKUNITY_DMAC_BASE + 0x0060)
 /*
  * Interrupt Error Status Reg DMAC_IESR.
  */
-#define DMAC_IESR		__REG(PKUNITY_DMAC_BASE + 0x0080)
+#define DMAC_IESR		io_p2v(PKUNITY_DMAC_BASE + 0x0080)
 /*
  * Interrupt Error Clear Reg DMAC_IECR.
  */
-#define DMAC_IECR		__REG(PKUNITY_DMAC_BASE + 0x0090)
+#define DMAC_IECR		io_p2v(PKUNITY_DMAC_BASE + 0x0090)
 /*
  * Enable Channels Reg DMAC_ENCH.
  */
-#define DMAC_ENCH		__REG(PKUNITY_DMAC_BASE + 0x00B0)
+#define DMAC_ENCH		io_p2v(PKUNITY_DMAC_BASE + 0x00B0)
 
 /*
  * DMA control reg. Space [byte]
@@ -35,19 +35,19 @@
 /*
  * Source Addr DMAC_SRCADDR(ch).
  */
-#define DMAC_SRCADDR(ch)	__REG(PKUNITY_DMAC_BASE + (ch)*DMASp + 0x00)
+#define DMAC_SRCADDR(ch)	io_p2v(PKUNITY_DMAC_BASE + (ch)*DMASp + 0x00)
 /*
  * Destination Addr DMAC_DESTADDR(ch).
  */
-#define DMAC_DESTADDR(ch)	__REG(PKUNITY_DMAC_BASE + (ch)*DMASp + 0x04)
+#define DMAC_DESTADDR(ch)	io_p2v(PKUNITY_DMAC_BASE + (ch)*DMASp + 0x04)
 /*
  * Control Reg DMAC_CONTROL(ch).
  */
-#define DMAC_CONTROL(ch)	__REG(PKUNITY_DMAC_BASE + (ch)*DMASp + 0x0C)
+#define DMAC_CONTROL(ch)	io_p2v(PKUNITY_DMAC_BASE + (ch)*DMASp + 0x0C)
 /*
  * Configuration Reg DMAC_CONFIG(ch).
  */
-#define DMAC_CONFIG(ch)		__REG(PKUNITY_DMAC_BASE + (ch)*DMASp + 0x10)
+#define DMAC_CONFIG(ch)		io_p2v(PKUNITY_DMAC_BASE + (ch)*DMASp + 0x10)
 
 #define DMAC_IR_MASK            FMASK(6, 0)
 /*
diff --git a/arch/unicore32/include/mach/regs-gpio.h b/arch/unicore32/include/mach/regs-gpio.h
index 5dd99d4..241a473 100644
--- a/arch/unicore32/include/mach/regs-gpio.h
+++ b/arch/unicore32/include/mach/regs-gpio.h
@@ -5,35 +5,35 @@
 /*
  * Voltage Status Reg GPIO_GPLR.
  */
-#define GPIO_GPLR	__REG(PKUNITY_GPIO_BASE + 0x0000)
+#define GPIO_GPLR	io_p2v(PKUNITY_GPIO_BASE + 0x0000)
 /*
  * Pin Direction Reg GPIO_GPDR.
  */
-#define GPIO_GPDR	__REG(PKUNITY_GPIO_BASE + 0x0004)
+#define GPIO_GPDR	io_p2v(PKUNITY_GPIO_BASE + 0x0004)
 /*
  * Output Pin Set Reg GPIO_GPSR.
  */
-#define GPIO_GPSR	__REG(PKUNITY_GPIO_BASE + 0x0008)
+#define GPIO_GPSR	io_p2v(PKUNITY_GPIO_BASE + 0x0008)
 /*
  * Output Pin Clear Reg GPIO_GPCR.
  */
-#define GPIO_GPCR	__REG(PKUNITY_GPIO_BASE + 0x000C)
+#define GPIO_GPCR	io_p2v(PKUNITY_GPIO_BASE + 0x000C)
 /*
  * Raise Edge Detect Reg GPIO_GRER.
  */
-#define GPIO_GRER	__REG(PKUNITY_GPIO_BASE + 0x0010)
+#define GPIO_GRER	io_p2v(PKUNITY_GPIO_BASE + 0x0010)
 /*
  * Fall Edge Detect Reg GPIO_GFER.
  */
-#define GPIO_GFER	__REG(PKUNITY_GPIO_BASE + 0x0014)
+#define GPIO_GFER	io_p2v(PKUNITY_GPIO_BASE + 0x0014)
 /*
  * Edge Status Reg GPIO_GEDR.
  */
-#define GPIO_GEDR	__REG(PKUNITY_GPIO_BASE + 0x0018)
+#define GPIO_GEDR	io_p2v(PKUNITY_GPIO_BASE + 0x0018)
 /*
  * Sepcial Voltage Detect Reg GPIO_GPIR.
  */
-#define GPIO_GPIR	__REG(PKUNITY_GPIO_BASE + 0x0020)
+#define GPIO_GPIR	io_p2v(PKUNITY_GPIO_BASE + 0x0020)
 
 #define GPIO_MIN	(0)
 #define GPIO_MAX	(27)
diff --git a/arch/unicore32/include/mach/regs-i2c.h b/arch/unicore32/include/mach/regs-i2c.h
index 70b704f..a1fe882 100644
--- a/arch/unicore32/include/mach/regs-i2c.h
+++ b/arch/unicore32/include/mach/regs-i2c.h
@@ -5,35 +5,35 @@
 /*
  * Control Reg I2C_CON.
  */
-#define I2C_CON		__REG(PKUNITY_I2C_BASE + 0x0000)
+#define I2C_CON		io_p2v(PKUNITY_I2C_BASE + 0x0000)
 /*
  * Target Address Reg I2C_TAR.
  */
-#define I2C_TAR		__REG(PKUNITY_I2C_BASE + 0x0004)
+#define I2C_TAR		io_p2v(PKUNITY_I2C_BASE + 0x0004)
 /*
  * Data buffer and command Reg I2C_DATACMD.
  */
-#define I2C_DATACMD	__REG(PKUNITY_I2C_BASE + 0x0010)
+#define I2C_DATACMD	io_p2v(PKUNITY_I2C_BASE + 0x0010)
 /*
  * Enable Reg I2C_ENABLE.
  */
-#define I2C_ENABLE	__REG(PKUNITY_I2C_BASE + 0x006C)
+#define I2C_ENABLE	io_p2v(PKUNITY_I2C_BASE + 0x006C)
 /*
  * Status Reg I2C_STATUS.
  */
-#define I2C_STATUS	__REG(PKUNITY_I2C_BASE + 0x0070)
+#define I2C_STATUS	io_p2v(PKUNITY_I2C_BASE + 0x0070)
 /*
  * Tx FIFO Length Reg I2C_TXFLR.
  */
-#define I2C_TXFLR	__REG(PKUNITY_I2C_BASE + 0x0074)
+#define I2C_TXFLR	io_p2v(PKUNITY_I2C_BASE + 0x0074)
 /*
  * Rx FIFO Length Reg I2C_RXFLR.
  */
-#define I2C_RXFLR	__REG(PKUNITY_I2C_BASE + 0x0078)
+#define I2C_RXFLR	io_p2v(PKUNITY_I2C_BASE + 0x0078)
 /*
  * Enable Status Reg I2C_ENSTATUS.
  */
-#define I2C_ENSTATUS	__REG(PKUNITY_I2C_BASE + 0x009C)
+#define I2C_ENSTATUS	io_p2v(PKUNITY_I2C_BASE + 0x009C)
 
 #define I2C_CON_MASTER          FIELD(1, 1, 0)
 #define I2C_CON_SPEED_STD       FIELD(1, 2, 1)
diff --git a/arch/unicore32/include/mach/regs-intc.h b/arch/unicore32/include/mach/regs-intc.h
index 409ae47..de828d0 100644
--- a/arch/unicore32/include/mach/regs-intc.h
+++ b/arch/unicore32/include/mach/regs-intc.h
@@ -4,25 +4,25 @@
 /*
  * INTC Level Reg INTC_ICLR.
  */
-#define INTC_ICLR	__REG(PKUNITY_INTC_BASE + 0x0000)
+#define INTC_ICLR	io_p2v(PKUNITY_INTC_BASE + 0x0000)
 /*
  * INTC Mask Reg INTC_ICMR.
  */
-#define INTC_ICMR	__REG(PKUNITY_INTC_BASE + 0x0004)
+#define INTC_ICMR	io_p2v(PKUNITY_INTC_BASE + 0x0004)
 /*
  * INTC Pending Reg INTC_ICPR.
  */
-#define INTC_ICPR	__REG(PKUNITY_INTC_BASE + 0x0008)
+#define INTC_ICPR	io_p2v(PKUNITY_INTC_BASE + 0x0008)
 /*
  * INTC IRQ Pending Reg INTC_ICIP.
  */
-#define INTC_ICIP	__REG(PKUNITY_INTC_BASE + 0x000C)
+#define INTC_ICIP	io_p2v(PKUNITY_INTC_BASE + 0x000C)
 /*
  * INTC REAL Pending Reg INTC_ICFP.
  */
-#define INTC_ICFP	__REG(PKUNITY_INTC_BASE + 0x0010)
+#define INTC_ICFP	io_p2v(PKUNITY_INTC_BASE + 0x0010)
 /*
  * INTC Control Reg INTC_ICCR.
  */
-#define INTC_ICCR	__REG(PKUNITY_INTC_BASE + 0x0014)
+#define INTC_ICCR	io_p2v(PKUNITY_INTC_BASE + 0x0014)
 
diff --git a/arch/unicore32/include/mach/regs-nand.h b/arch/unicore32/include/mach/regs-nand.h
index 0c33fe8..92578df 100644
--- a/arch/unicore32/include/mach/regs-nand.h
+++ b/arch/unicore32/include/mach/regs-nand.h
@@ -4,67 +4,67 @@
 /*
  * ID Reg. 0 NAND_IDR0
  */
-#define NAND_IDR0	__REG(PKUNITY_NAND_BASE + 0x0000)
+#define NAND_IDR0	io_p2v(PKUNITY_NAND_BASE + 0x0000)
 /*
  * ID Reg. 1 NAND_IDR1
  */
-#define NAND_IDR1	__REG(PKUNITY_NAND_BASE + 0x0004)
+#define NAND_IDR1	io_p2v(PKUNITY_NAND_BASE + 0x0004)
 /*
  * ID Reg. 2 NAND_IDR2
  */
-#define NAND_IDR2	__REG(PKUNITY_NAND_BASE + 0x0008)
+#define NAND_IDR2	io_p2v(PKUNITY_NAND_BASE + 0x0008)
 /*
  * ID Reg. 3 NAND_IDR3
  */
-#define NAND_IDR3	__REG(PKUNITY_NAND_BASE + 0x000C)
+#define NAND_IDR3	io_p2v(PKUNITY_NAND_BASE + 0x000C)
 /*
  * Page Address Reg 0 NAND_PAR0
  */
-#define NAND_PAR0	__REG(PKUNITY_NAND_BASE + 0x0010)
+#define NAND_PAR0	io_p2v(PKUNITY_NAND_BASE + 0x0010)
 /*
  * Page Address Reg 1 NAND_PAR1
  */
-#define NAND_PAR1	__REG(PKUNITY_NAND_BASE + 0x0014)
+#define NAND_PAR1	io_p2v(PKUNITY_NAND_BASE + 0x0014)
 /*
  * Page Address Reg 2 NAND_PAR2
  */
-#define NAND_PAR2	__REG(PKUNITY_NAND_BASE + 0x0018)
+#define NAND_PAR2	io_p2v(PKUNITY_NAND_BASE + 0x0018)
 /*
  * ECC Enable Reg NAND_ECCEN
  */
-#define NAND_ECCEN	__REG(PKUNITY_NAND_BASE + 0x001C)
+#define NAND_ECCEN	io_p2v(PKUNITY_NAND_BASE + 0x001C)
 /*
  * Buffer Reg NAND_BUF
  */
-#define NAND_BUF	__REG(PKUNITY_NAND_BASE + 0x0020)
+#define NAND_BUF	io_p2v(PKUNITY_NAND_BASE + 0x0020)
 /*
  * ECC Status Reg NAND_ECCSR
  */
-#define NAND_ECCSR	__REG(PKUNITY_NAND_BASE + 0x0024)
+#define NAND_ECCSR	io_p2v(PKUNITY_NAND_BASE + 0x0024)
 /*
  * Command Reg NAND_CMD
  */
-#define NAND_CMD	__REG(PKUNITY_NAND_BASE + 0x0028)
+#define NAND_CMD	io_p2v(PKUNITY_NAND_BASE + 0x0028)
 /*
  * DMA Configure Reg NAND_DMACR
  */
-#define NAND_DMACR	__REG(PKUNITY_NAND_BASE + 0x002C)
+#define NAND_DMACR	io_p2v(PKUNITY_NAND_BASE + 0x002C)
 /*
  * Interrupt Reg NAND_IR
  */
-#define NAND_IR		__REG(PKUNITY_NAND_BASE + 0x0030)
+#define NAND_IR		io_p2v(PKUNITY_NAND_BASE + 0x0030)
 /*
  * Interrupt Mask Reg NAND_IMR
  */
-#define NAND_IMR	__REG(PKUNITY_NAND_BASE + 0x0034)
+#define NAND_IMR	io_p2v(PKUNITY_NAND_BASE + 0x0034)
 /*
  * Chip Enable Reg NAND_CHIPEN
  */
-#define NAND_CHIPEN	__REG(PKUNITY_NAND_BASE + 0x0038)
+#define NAND_CHIPEN	io_p2v(PKUNITY_NAND_BASE + 0x0038)
 /*
  * Address Reg NAND_ADDR
  */
-#define NAND_ADDR	__REG(PKUNITY_NAND_BASE + 0x003C)
+#define NAND_ADDR	io_p2v(PKUNITY_NAND_BASE + 0x003C)
 
 /*
  * Command bits NAND_CMD_CMD_MASK
diff --git a/arch/unicore32/include/mach/regs-ost.h b/arch/unicore32/include/mach/regs-ost.h
index 33049a8..72b586a 100644
--- a/arch/unicore32/include/mach/regs-ost.h
+++ b/arch/unicore32/include/mach/regs-ost.h
@@ -4,47 +4,47 @@
 /*
  * Match Reg 0 OST_OSMR0
  */
-#define OST_OSMR0	__REG(PKUNITY_OST_BASE + 0x0000)
+#define OST_OSMR0	io_p2v(PKUNITY_OST_BASE + 0x0000)
 /*
  * Match Reg 1 OST_OSMR1
  */
-#define OST_OSMR1	__REG(PKUNITY_OST_BASE + 0x0004)
+#define OST_OSMR1	io_p2v(PKUNITY_OST_BASE + 0x0004)
 /*
  * Match Reg 2 OST_OSMR2
  */
-#define OST_OSMR2	__REG(PKUNITY_OST_BASE + 0x0008)
+#define OST_OSMR2	io_p2v(PKUNITY_OST_BASE + 0x0008)
 /*
  * Match Reg 3 OST_OSMR3
  */
-#define OST_OSMR3	__REG(PKUNITY_OST_BASE + 0x000C)
+#define OST_OSMR3	io_p2v(PKUNITY_OST_BASE + 0x000C)
 /*
  * Counter Reg OST_OSCR
  */
-#define OST_OSCR	__REG(PKUNITY_OST_BASE + 0x0010)
+#define OST_OSCR	io_p2v(PKUNITY_OST_BASE + 0x0010)
 /*
  * Status Reg OST_OSSR
  */
-#define OST_OSSR	__REG(PKUNITY_OST_BASE + 0x0014)
+#define OST_OSSR	io_p2v(PKUNITY_OST_BASE + 0x0014)
 /*
  * Watchdog Enable Reg OST_OWER
  */
-#define OST_OWER	__REG(PKUNITY_OST_BASE + 0x0018)
+#define OST_OWER	io_p2v(PKUNITY_OST_BASE + 0x0018)
 /*
  * Interrupt Enable Reg OST_OIER
  */
-#define OST_OIER	__REG(PKUNITY_OST_BASE + 0x001C)
+#define OST_OIER	io_p2v(PKUNITY_OST_BASE + 0x001C)
 /*
  * PWM Pulse Width Control Reg OST_PWMPWCR
  */
-#define OST_PWMPWCR	__REG(PKUNITY_OST_BASE + 0x0080)
+#define OST_PWMPWCR	io_p2v(PKUNITY_OST_BASE + 0x0080)
 /*
  * PWM Duty Cycle Control Reg OST_PWMDCCR
  */
-#define OST_PWMDCCR	__REG(PKUNITY_OST_BASE + 0x0084)
+#define OST_PWMDCCR	io_p2v(PKUNITY_OST_BASE + 0x0084)
 /*
  * PWM Period Control Reg OST_PWMPCR
  */
-#define OST_PWMPCR	__REG(PKUNITY_OST_BASE + 0x0088)
+#define OST_PWMPCR	io_p2v(PKUNITY_OST_BASE + 0x0088)
 
 /*
  * Match detected 0 OST_OSSR_M0
diff --git a/arch/unicore32/include/mach/regs-pci.h b/arch/unicore32/include/mach/regs-pci.h
index e8e1f1a..97db168 100644
--- a/arch/unicore32/include/mach/regs-pci.h
+++ b/arch/unicore32/include/mach/regs-pci.h
@@ -8,79 +8,79 @@
 /*
  * PCICFG Bridge Base Reg.
  */
-#define PCICFG_BRIBASE          __REG(PKUNITY_PCICFG_BASE + 0x0000)
+#define PCICFG_BRIBASE          io_p2v(PKUNITY_PCICFG_BASE + 0x0000)
 /*
  * PCICFG Address Reg.
  */
-#define PCICFG_ADDR             __REG(PKUNITY_PCICFG_BASE + 0x0004)
+#define PCICFG_ADDR             io_p2v(PKUNITY_PCICFG_BASE + 0x0004)
 /*
  * PCICFG Address Reg.
  */
-#define PCICFG_DATA             __REG(PKUNITY_PCICFG_BASE + 0x0008)
+#define PCICFG_DATA             io_p2v(PKUNITY_PCICFG_BASE + 0x0008)
 
 /*
  * PCI Bridge configuration space
  */
-#define PCIBRI_ID		__REG(PKUNITY_PCIBRI_BASE + 0x0000)
-#define PCIBRI_CMD		__REG(PKUNITY_PCIBRI_BASE + 0x0004)
-#define PCIBRI_CLASS		__REG(PKUNITY_PCIBRI_BASE + 0x0008)
-#define PCIBRI_LTR		__REG(PKUNITY_PCIBRI_BASE + 0x000C)
-#define PCIBRI_BAR0		__REG(PKUNITY_PCIBRI_BASE + 0x0010)
-#define PCIBRI_BAR1		__REG(PKUNITY_PCIBRI_BASE + 0x0014)
-#define PCIBRI_BAR2		__REG(PKUNITY_PCIBRI_BASE + 0x0018)
-#define PCIBRI_BAR3		__REG(PKUNITY_PCIBRI_BASE + 0x001C)
-#define PCIBRI_BAR4		__REG(PKUNITY_PCIBRI_BASE + 0x0020)
-#define PCIBRI_BAR5		__REG(PKUNITY_PCIBRI_BASE + 0x0024)
+#define PCIBRI_ID		io_p2v(PKUNITY_PCIBRI_BASE + 0x0000)
+#define PCIBRI_CMD		io_p2v(PKUNITY_PCIBRI_BASE + 0x0004)
+#define PCIBRI_CLASS		io_p2v(PKUNITY_PCIBRI_BASE + 0x0008)
+#define PCIBRI_LTR		io_p2v(PKUNITY_PCIBRI_BASE + 0x000C)
+#define PCIBRI_BAR0		io_p2v(PKUNITY_PCIBRI_BASE + 0x0010)
+#define PCIBRI_BAR1		io_p2v(PKUNITY_PCIBRI_BASE + 0x0014)
+#define PCIBRI_BAR2		io_p2v(PKUNITY_PCIBRI_BASE + 0x0018)
+#define PCIBRI_BAR3		io_p2v(PKUNITY_PCIBRI_BASE + 0x001C)
+#define PCIBRI_BAR4		io_p2v(PKUNITY_PCIBRI_BASE + 0x0020)
+#define PCIBRI_BAR5		io_p2v(PKUNITY_PCIBRI_BASE + 0x0024)
 
-#define PCIBRI_PCICTL0		__REG(PKUNITY_PCIBRI_BASE + 0x0100)
-#define PCIBRI_PCIBAR0		__REG(PKUNITY_PCIBRI_BASE + 0x0104)
-#define PCIBRI_PCIAMR0		__REG(PKUNITY_PCIBRI_BASE + 0x0108)
-#define PCIBRI_PCITAR0		__REG(PKUNITY_PCIBRI_BASE + 0x010C)
-#define PCIBRI_PCICTL1		__REG(PKUNITY_PCIBRI_BASE + 0x0110)
-#define PCIBRI_PCIBAR1		__REG(PKUNITY_PCIBRI_BASE + 0x0114)
-#define PCIBRI_PCIAMR1		__REG(PKUNITY_PCIBRI_BASE + 0x0118)
-#define PCIBRI_PCITAR1		__REG(PKUNITY_PCIBRI_BASE + 0x011C)
-#define PCIBRI_PCICTL2		__REG(PKUNITY_PCIBRI_BASE + 0x0120)
-#define PCIBRI_PCIBAR2		__REG(PKUNITY_PCIBRI_BASE + 0x0124)
-#define PCIBRI_PCIAMR2		__REG(PKUNITY_PCIBRI_BASE + 0x0128)
-#define PCIBRI_PCITAR2		__REG(PKUNITY_PCIBRI_BASE + 0x012C)
-#define PCIBRI_PCICTL3		__REG(PKUNITY_PCIBRI_BASE + 0x0130)
-#define PCIBRI_PCIBAR3		__REG(PKUNITY_PCIBRI_BASE + 0x0134)
-#define PCIBRI_PCIAMR3		__REG(PKUNITY_PCIBRI_BASE + 0x0138)
-#define PCIBRI_PCITAR3		__REG(PKUNITY_PCIBRI_BASE + 0x013C)
-#define PCIBRI_PCICTL4		__REG(PKUNITY_PCIBRI_BASE + 0x0140)
-#define PCIBRI_PCIBAR4		__REG(PKUNITY_PCIBRI_BASE + 0x0144)
-#define PCIBRI_PCIAMR4		__REG(PKUNITY_PCIBRI_BASE + 0x0148)
-#define PCIBRI_PCITAR4		__REG(PKUNITY_PCIBRI_BASE + 0x014C)
-#define PCIBRI_PCICTL5		__REG(PKUNITY_PCIBRI_BASE + 0x0150)
-#define PCIBRI_PCIBAR5		__REG(PKUNITY_PCIBRI_BASE + 0x0154)
-#define PCIBRI_PCIAMR5		__REG(PKUNITY_PCIBRI_BASE + 0x0158)
-#define PCIBRI_PCITAR5		__REG(PKUNITY_PCIBRI_BASE + 0x015C)
+#define PCIBRI_PCICTL0		io_p2v(PKUNITY_PCIBRI_BASE + 0x0100)
+#define PCIBRI_PCIBAR0		io_p2v(PKUNITY_PCIBRI_BASE + 0x0104)
+#define PCIBRI_PCIAMR0		io_p2v(PKUNITY_PCIBRI_BASE + 0x0108)
+#define PCIBRI_PCITAR0		io_p2v(PKUNITY_PCIBRI_BASE + 0x010C)
+#define PCIBRI_PCICTL1		io_p2v(PKUNITY_PCIBRI_BASE + 0x0110)
+#define PCIBRI_PCIBAR1		io_p2v(PKUNITY_PCIBRI_BASE + 0x0114)
+#define PCIBRI_PCIAMR1		io_p2v(PKUNITY_PCIBRI_BASE + 0x0118)
+#define PCIBRI_PCITAR1		io_p2v(PKUNITY_PCIBRI_BASE + 0x011C)
+#define PCIBRI_PCICTL2		io_p2v(PKUNITY_PCIBRI_BASE + 0x0120)
+#define PCIBRI_PCIBAR2		io_p2v(PKUNITY_PCIBRI_BASE + 0x0124)
+#define PCIBRI_PCIAMR2		io_p2v(PKUNITY_PCIBRI_BASE + 0x0128)
+#define PCIBRI_PCITAR2		io_p2v(PKUNITY_PCIBRI_BASE + 0x012C)
+#define PCIBRI_PCICTL3		io_p2v(PKUNITY_PCIBRI_BASE + 0x0130)
+#define PCIBRI_PCIBAR3		io_p2v(PKUNITY_PCIBRI_BASE + 0x0134)
+#define PCIBRI_PCIAMR3		io_p2v(PKUNITY_PCIBRI_BASE + 0x0138)
+#define PCIBRI_PCITAR3		io_p2v(PKUNITY_PCIBRI_BASE + 0x013C)
+#define PCIBRI_PCICTL4		io_p2v(PKUNITY_PCIBRI_BASE + 0x0140)
+#define PCIBRI_PCIBAR4		io_p2v(PKUNITY_PCIBRI_BASE + 0x0144)
+#define PCIBRI_PCIAMR4		io_p2v(PKUNITY_PCIBRI_BASE + 0x0148)
+#define PCIBRI_PCITAR4		io_p2v(PKUNITY_PCIBRI_BASE + 0x014C)
+#define PCIBRI_PCICTL5		io_p2v(PKUNITY_PCIBRI_BASE + 0x0150)
+#define PCIBRI_PCIBAR5		io_p2v(PKUNITY_PCIBRI_BASE + 0x0154)
+#define PCIBRI_PCIAMR5		io_p2v(PKUNITY_PCIBRI_BASE + 0x0158)
+#define PCIBRI_PCITAR5		io_p2v(PKUNITY_PCIBRI_BASE + 0x015C)
 
-#define PCIBRI_AHBCTL0		__REG(PKUNITY_PCIBRI_BASE + 0x0180)
-#define PCIBRI_AHBBAR0		__REG(PKUNITY_PCIBRI_BASE + 0x0184)
-#define PCIBRI_AHBAMR0		__REG(PKUNITY_PCIBRI_BASE + 0x0188)
-#define PCIBRI_AHBTAR0		__REG(PKUNITY_PCIBRI_BASE + 0x018C)
-#define PCIBRI_AHBCTL1		__REG(PKUNITY_PCIBRI_BASE + 0x0190)
-#define PCIBRI_AHBBAR1		__REG(PKUNITY_PCIBRI_BASE + 0x0194)
-#define PCIBRI_AHBAMR1		__REG(PKUNITY_PCIBRI_BASE + 0x0198)
-#define PCIBRI_AHBTAR1		__REG(PKUNITY_PCIBRI_BASE + 0x019C)
-#define PCIBRI_AHBCTL2		__REG(PKUNITY_PCIBRI_BASE + 0x01A0)
-#define PCIBRI_AHBBAR2		__REG(PKUNITY_PCIBRI_BASE + 0x01A4)
-#define PCIBRI_AHBAMR2		__REG(PKUNITY_PCIBRI_BASE + 0x01A8)
-#define PCIBRI_AHBTAR2		__REG(PKUNITY_PCIBRI_BASE + 0x01AC)
-#define PCIBRI_AHBCTL3		__REG(PKUNITY_PCIBRI_BASE + 0x01B0)
-#define PCIBRI_AHBBAR3		__REG(PKUNITY_PCIBRI_BASE + 0x01B4)
-#define PCIBRI_AHBAMR3		__REG(PKUNITY_PCIBRI_BASE + 0x01B8)
-#define PCIBRI_AHBTAR3		__REG(PKUNITY_PCIBRI_BASE + 0x01BC)
-#define PCIBRI_AHBCTL4		__REG(PKUNITY_PCIBRI_BASE + 0x01C0)
-#define PCIBRI_AHBBAR4		__REG(PKUNITY_PCIBRI_BASE + 0x01C4)
-#define PCIBRI_AHBAMR4		__REG(PKUNITY_PCIBRI_BASE + 0x01C8)
-#define PCIBRI_AHBTAR4		__REG(PKUNITY_PCIBRI_BASE + 0x01CC)
-#define PCIBRI_AHBCTL5		__REG(PKUNITY_PCIBRI_BASE + 0x01D0)
-#define PCIBRI_AHBBAR5		__REG(PKUNITY_PCIBRI_BASE + 0x01D4)
-#define PCIBRI_AHBAMR5		__REG(PKUNITY_PCIBRI_BASE + 0x01D8)
-#define PCIBRI_AHBTAR5		__REG(PKUNITY_PCIBRI_BASE + 0x01DC)
+#define PCIBRI_AHBCTL0		io_p2v(PKUNITY_PCIBRI_BASE + 0x0180)
+#define PCIBRI_AHBBAR0		io_p2v(PKUNITY_PCIBRI_BASE + 0x0184)
+#define PCIBRI_AHBAMR0		io_p2v(PKUNITY_PCIBRI_BASE + 0x0188)
+#define PCIBRI_AHBTAR0		io_p2v(PKUNITY_PCIBRI_BASE + 0x018C)
+#define PCIBRI_AHBCTL1		io_p2v(PKUNITY_PCIBRI_BASE + 0x0190)
+#define PCIBRI_AHBBAR1		io_p2v(PKUNITY_PCIBRI_BASE + 0x0194)
+#define PCIBRI_AHBAMR1		io_p2v(PKUNITY_PCIBRI_BASE + 0x0198)
+#define PCIBRI_AHBTAR1		io_p2v(PKUNITY_PCIBRI_BASE + 0x019C)
+#define PCIBRI_AHBCTL2		io_p2v(PKUNITY_PCIBRI_BASE + 0x01A0)
+#define PCIBRI_AHBBAR2		io_p2v(PKUNITY_PCIBRI_BASE + 0x01A4)
+#define PCIBRI_AHBAMR2		io_p2v(PKUNITY_PCIBRI_BASE + 0x01A8)
+#define PCIBRI_AHBTAR2		io_p2v(PKUNITY_PCIBRI_BASE + 0x01AC)
+#define PCIBRI_AHBCTL3		io_p2v(PKUNITY_PCIBRI_BASE + 0x01B0)
+#define PCIBRI_AHBBAR3		io_p2v(PKUNITY_PCIBRI_BASE + 0x01B4)
+#define PCIBRI_AHBAMR3		io_p2v(PKUNITY_PCIBRI_BASE + 0x01B8)
+#define PCIBRI_AHBTAR3		io_p2v(PKUNITY_PCIBRI_BASE + 0x01BC)
+#define PCIBRI_AHBCTL4		io_p2v(PKUNITY_PCIBRI_BASE + 0x01C0)
+#define PCIBRI_AHBBAR4		io_p2v(PKUNITY_PCIBRI_BASE + 0x01C4)
+#define PCIBRI_AHBAMR4		io_p2v(PKUNITY_PCIBRI_BASE + 0x01C8)
+#define PCIBRI_AHBTAR4		io_p2v(PKUNITY_PCIBRI_BASE + 0x01CC)
+#define PCIBRI_AHBCTL5		io_p2v(PKUNITY_PCIBRI_BASE + 0x01D0)
+#define PCIBRI_AHBBAR5		io_p2v(PKUNITY_PCIBRI_BASE + 0x01D4)
+#define PCIBRI_AHBAMR5		io_p2v(PKUNITY_PCIBRI_BASE + 0x01D8)
+#define PCIBRI_AHBTAR5		io_p2v(PKUNITY_PCIBRI_BASE + 0x01DC)
 
 #define PCIBRI_CTLx_AT          FIELD(1, 1, 2)
 #define PCIBRI_CTLx_PREF        FIELD(1, 1, 1)
diff --git a/arch/unicore32/include/mach/regs-pm.h b/arch/unicore32/include/mach/regs-pm.h
index ed2d2fc..8274b87 100644
--- a/arch/unicore32/include/mach/regs-pm.h
+++ b/arch/unicore32/include/mach/regs-pm.h
@@ -4,75 +4,75 @@
 /*
  * PM Control Reg PM_PMCR
  */
-#define PM_PMCR                 __REG(PKUNITY_PM_BASE + 0x0000)
+#define PM_PMCR                 io_p2v(PKUNITY_PM_BASE + 0x0000)
 /*
  * PM General Conf. Reg PM_PGCR
  */
-#define PM_PGCR                 __REG(PKUNITY_PM_BASE + 0x0004)
+#define PM_PGCR                 io_p2v(PKUNITY_PM_BASE + 0x0004)
 /*
  * PM PLL Conf. Reg PM_PPCR
  */
-#define PM_PPCR                 __REG(PKUNITY_PM_BASE + 0x0008)
+#define PM_PPCR                 io_p2v(PKUNITY_PM_BASE + 0x0008)
 /*
  * PM Wakeup Enable Reg PM_PWER
  */
-#define PM_PWER                 __REG(PKUNITY_PM_BASE + 0x000C)
+#define PM_PWER                 io_p2v(PKUNITY_PM_BASE + 0x000C)
 /*
  * PM GPIO Sleep Status Reg PM_PGSR
  */
-#define PM_PGSR                 __REG(PKUNITY_PM_BASE + 0x0010)
+#define PM_PGSR                 io_p2v(PKUNITY_PM_BASE + 0x0010)
 /*
  * PM Clock Gate Reg PM_PCGR
  */
-#define PM_PCGR                 __REG(PKUNITY_PM_BASE + 0x0014)
+#define PM_PCGR                 io_p2v(PKUNITY_PM_BASE + 0x0014)
 /*
  * PM SYS PLL Conf. Reg PM_PLLSYSCFG
  */
-#define PM_PLLSYSCFG            __REG(PKUNITY_PM_BASE + 0x0018)
+#define PM_PLLSYSCFG            io_p2v(PKUNITY_PM_BASE + 0x0018)
 /*
  * PM DDR PLL Conf. Reg PM_PLLDDRCFG
  */
-#define PM_PLLDDRCFG            __REG(PKUNITY_PM_BASE + 0x001C)
+#define PM_PLLDDRCFG            io_p2v(PKUNITY_PM_BASE + 0x001C)
 /*
  * PM VGA PLL Conf. Reg PM_PLLVGACFG
  */
-#define PM_PLLVGACFG            __REG(PKUNITY_PM_BASE + 0x0020)
+#define PM_PLLVGACFG            io_p2v(PKUNITY_PM_BASE + 0x0020)
 /*
  * PM Div Conf. Reg PM_DIVCFG
  */
-#define PM_DIVCFG               __REG(PKUNITY_PM_BASE + 0x0024)
+#define PM_DIVCFG               io_p2v(PKUNITY_PM_BASE + 0x0024)
 /*
  * PM SYS PLL Status Reg PM_PLLSYSSTATUS
  */
-#define PM_PLLSYSSTATUS         __REG(PKUNITY_PM_BASE + 0x0028)
+#define PM_PLLSYSSTATUS         io_p2v(PKUNITY_PM_BASE + 0x0028)
 /*
  * PM DDR PLL Status Reg PM_PLLDDRSTATUS
  */
-#define PM_PLLDDRSTATUS         __REG(PKUNITY_PM_BASE + 0x002C)
+#define PM_PLLDDRSTATUS         io_p2v(PKUNITY_PM_BASE + 0x002C)
 /*
  * PM VGA PLL Status Reg PM_PLLVGASTATUS
  */
-#define PM_PLLVGASTATUS         __REG(PKUNITY_PM_BASE + 0x0030)
+#define PM_PLLVGASTATUS         io_p2v(PKUNITY_PM_BASE + 0x0030)
 /*
  * PM Div Status Reg PM_DIVSTATUS
  */
-#define PM_DIVSTATUS            __REG(PKUNITY_PM_BASE + 0x0034)
+#define PM_DIVSTATUS            io_p2v(PKUNITY_PM_BASE + 0x0034)
 /*
  * PM Software Reset Reg PM_SWRESET
  */
-#define PM_SWRESET              __REG(PKUNITY_PM_BASE + 0x0038)
+#define PM_SWRESET              io_p2v(PKUNITY_PM_BASE + 0x0038)
 /*
  * PM DDR2 PAD Start Reg PM_DDR2START
  */
-#define PM_DDR2START            __REG(PKUNITY_PM_BASE + 0x003C)
+#define PM_DDR2START            io_p2v(PKUNITY_PM_BASE + 0x003C)
 /*
  * PM DDR2 PAD Status Reg PM_DDR2CAL0
  */
-#define PM_DDR2CAL0             __REG(PKUNITY_PM_BASE + 0x0040)
+#define PM_DDR2CAL0             io_p2v(PKUNITY_PM_BASE + 0x0040)
 /*
  * PM PLL DFC Done Reg PM_PLLDFCDONE
  */
-#define PM_PLLDFCDONE           __REG(PKUNITY_PM_BASE + 0x0044)
+#define PM_PLLDFCDONE           io_p2v(PKUNITY_PM_BASE + 0x0044)
 
 #define PM_PMCR_SFB             FIELD(1, 1, 0)
 #define PM_PMCR_IFB             FIELD(1, 1, 1)
diff --git a/arch/unicore32/include/mach/regs-ps2.h b/arch/unicore32/include/mach/regs-ps2.h
index 7da2071..725841e 100644
--- a/arch/unicore32/include/mach/regs-ps2.h
+++ b/arch/unicore32/include/mach/regs-ps2.h
@@ -4,17 +4,17 @@
 /*
  * the same as I8042_DATA_REG PS2_DATA
  */
-#define PS2_DATA	__REG(PKUNITY_PS2_BASE + 0x0060)
+#define PS2_DATA	io_p2v(PKUNITY_PS2_BASE + 0x0060)
 /*
  * the same as I8042_COMMAND_REG PS2_COMMAND
  */
-#define PS2_COMMAND	__REG(PKUNITY_PS2_BASE + 0x0064)
+#define PS2_COMMAND	io_p2v(PKUNITY_PS2_BASE + 0x0064)
 /*
  * the same as I8042_STATUS_REG PS2_STATUS
  */
-#define PS2_STATUS	__REG(PKUNITY_PS2_BASE + 0x0064)
+#define PS2_STATUS	io_p2v(PKUNITY_PS2_BASE + 0x0064)
 /*
  * counter reg PS2_CNT
  */
-#define PS2_CNT		__REG(PKUNITY_PS2_BASE + 0x0068)
+#define PS2_CNT		io_p2v(PKUNITY_PS2_BASE + 0x0068)
 
diff --git a/arch/unicore32/include/mach/regs-resetc.h b/arch/unicore32/include/mach/regs-resetc.h
index 1763989..8b0629c 100644
--- a/arch/unicore32/include/mach/regs-resetc.h
+++ b/arch/unicore32/include/mach/regs-resetc.h
@@ -4,11 +4,11 @@
 /*
  * Software Reset Register
  */
-#define RESETC_SWRR	__REG(PKUNITY_RESETC_BASE + 0x0000)
+#define RESETC_SWRR	io_p2v(PKUNITY_RESETC_BASE + 0x0000)
 /*
  * Reset Status Register
  */
-#define RESETC_RSSR	__REG(PKUNITY_RESETC_BASE + 0x0004)
+#define RESETC_RSSR	io_p2v(PKUNITY_RESETC_BASE + 0x0004)
 
 /*
  * Software Reset Bit
diff --git a/arch/unicore32/include/mach/regs-rtc.h b/arch/unicore32/include/mach/regs-rtc.h
index 155e3875..b70bc16 100644
--- a/arch/unicore32/include/mach/regs-rtc.h
+++ b/arch/unicore32/include/mach/regs-rtc.h
@@ -4,19 +4,19 @@
 /*
  * RTC Alarm Reg RTC_RTAR
  */
-#define RTC_RTAR	__REG(PKUNITY_RTC_BASE + 0x0000)
+#define RTC_RTAR	io_p2v(PKUNITY_RTC_BASE + 0x0000)
 /*
  * RTC Count Reg RTC_RCNR
  */
-#define RTC_RCNR	__REG(PKUNITY_RTC_BASE + 0x0004)
+#define RTC_RCNR	io_p2v(PKUNITY_RTC_BASE + 0x0004)
 /*
  * RTC Trim Reg RTC_RTTR
  */
-#define RTC_RTTR	__REG(PKUNITY_RTC_BASE + 0x0008)
+#define RTC_RTTR	io_p2v(PKUNITY_RTC_BASE + 0x0008)
 /*
  * RTC Status Reg RTC_RTSR
  */
-#define RTC_RTSR	__REG(PKUNITY_RTC_BASE + 0x0010)
+#define RTC_RTSR	io_p2v(PKUNITY_RTC_BASE + 0x0010)
 
 /*
  * ALarm detected RTC_RTSR_AL
diff --git a/arch/unicore32/include/mach/regs-sdc.h b/arch/unicore32/include/mach/regs-sdc.h
index 3457b88..47f56e5 100644
--- a/arch/unicore32/include/mach/regs-sdc.h
+++ b/arch/unicore32/include/mach/regs-sdc.h
@@ -4,67 +4,67 @@
 /*
  * Clock Control Reg SDC_CCR
  */
-#define SDC_CCR		__REG(PKUNITY_SDC_BASE + 0x0000)
+#define SDC_CCR		io_p2v(PKUNITY_SDC_BASE + 0x0000)
 /*
  * Software Reset Reg SDC_SRR
  */
-#define SDC_SRR		__REG(PKUNITY_SDC_BASE + 0x0004)
+#define SDC_SRR		io_p2v(PKUNITY_SDC_BASE + 0x0004)
 /*
  * Argument Reg SDC_ARGUMENT
  */
-#define SDC_ARGUMENT	__REG(PKUNITY_SDC_BASE + 0x0008)
+#define SDC_ARGUMENT	io_p2v(PKUNITY_SDC_BASE + 0x0008)
 /*
  * Command Reg SDC_COMMAND
  */
-#define SDC_COMMAND	__REG(PKUNITY_SDC_BASE + 0x000C)
+#define SDC_COMMAND	io_p2v(PKUNITY_SDC_BASE + 0x000C)
 /*
  * Block Size Reg SDC_BLOCKSIZE
  */
-#define SDC_BLOCKSIZE	__REG(PKUNITY_SDC_BASE + 0x0010)
+#define SDC_BLOCKSIZE	io_p2v(PKUNITY_SDC_BASE + 0x0010)
 /*
  * Block Cound Reg SDC_BLOCKCOUNT
  */
-#define SDC_BLOCKCOUNT	__REG(PKUNITY_SDC_BASE + 0x0014)
+#define SDC_BLOCKCOUNT	io_p2v(PKUNITY_SDC_BASE + 0x0014)
 /*
  * Transfer Mode Reg SDC_TMR
  */
-#define SDC_TMR		__REG(PKUNITY_SDC_BASE + 0x0018)
+#define SDC_TMR		io_p2v(PKUNITY_SDC_BASE + 0x0018)
 /*
  * Response Reg. 0 SDC_RES0
  */
-#define SDC_RES0	__REG(PKUNITY_SDC_BASE + 0x001C)
+#define SDC_RES0	io_p2v(PKUNITY_SDC_BASE + 0x001C)
 /*
  * Response Reg. 1 SDC_RES1
  */
-#define SDC_RES1	__REG(PKUNITY_SDC_BASE + 0x0020)
+#define SDC_RES1	io_p2v(PKUNITY_SDC_BASE + 0x0020)
 /*
  * Response Reg. 2 SDC_RES2
  */
-#define SDC_RES2	__REG(PKUNITY_SDC_BASE + 0x0024)
+#define SDC_RES2	io_p2v(PKUNITY_SDC_BASE + 0x0024)
 /*
  * Response Reg. 3 SDC_RES3
  */
-#define SDC_RES3	__REG(PKUNITY_SDC_BASE + 0x0028)
+#define SDC_RES3	io_p2v(PKUNITY_SDC_BASE + 0x0028)
 /*
  * Read Timeout Control Reg SDC_RTCR
  */
-#define SDC_RTCR	__REG(PKUNITY_SDC_BASE + 0x002C)
+#define SDC_RTCR	io_p2v(PKUNITY_SDC_BASE + 0x002C)
 /*
  * Interrupt Status Reg SDC_ISR
  */
-#define SDC_ISR		__REG(PKUNITY_SDC_BASE + 0x0030)
+#define SDC_ISR		io_p2v(PKUNITY_SDC_BASE + 0x0030)
 /*
  * Interrupt Status Mask Reg SDC_ISMR
  */
-#define SDC_ISMR	__REG(PKUNITY_SDC_BASE + 0x0034)
+#define SDC_ISMR	io_p2v(PKUNITY_SDC_BASE + 0x0034)
 /*
  * RX FIFO SDC_RXFIFO
  */
-#define SDC_RXFIFO	__REG(PKUNITY_SDC_BASE + 0x0038)
+#define SDC_RXFIFO	io_p2v(PKUNITY_SDC_BASE + 0x0038)
 /*
  * TX FIFO SDC_TXFIFO
  */
-#define SDC_TXFIFO	__REG(PKUNITY_SDC_BASE + 0x003C)
+#define SDC_TXFIFO	io_p2v(PKUNITY_SDC_BASE + 0x003C)
 
 /*
  * SD Clock Enable SDC_CCR_CLKEN
diff --git a/arch/unicore32/include/mach/regs-spi.h b/arch/unicore32/include/mach/regs-spi.h
index cadc713..6afe263 100644
--- a/arch/unicore32/include/mach/regs-spi.h
+++ b/arch/unicore32/include/mach/regs-spi.h
@@ -4,27 +4,27 @@
 /*
  * Control reg. 0 SPI_CR0
  */
-#define SPI_CR0		__REG(PKUNITY_SPI_BASE + 0x0000)
+#define SPI_CR0		io_p2v(PKUNITY_SPI_BASE + 0x0000)
 /*
  * Control reg. 1 SPI_CR1
  */
-#define SPI_CR1		__REG(PKUNITY_SPI_BASE + 0x0004)
+#define SPI_CR1		io_p2v(PKUNITY_SPI_BASE + 0x0004)
 /*
  * Enable reg SPI_SSIENR
  */
-#define SPI_SSIENR	__REG(PKUNITY_SPI_BASE + 0x0008)
+#define SPI_SSIENR	io_p2v(PKUNITY_SPI_BASE + 0x0008)
 /*
  * Status reg SPI_SR
  */
-#define SPI_SR		__REG(PKUNITY_SPI_BASE + 0x0028)
+#define SPI_SR		io_p2v(PKUNITY_SPI_BASE + 0x0028)
 /*
  * Interrupt Mask reg SPI_IMR
  */
-#define SPI_IMR		__REG(PKUNITY_SPI_BASE + 0x002C)
+#define SPI_IMR		io_p2v(PKUNITY_SPI_BASE + 0x002C)
 /*
  * Interrupt Status reg SPI_ISR
  */
-#define SPI_ISR		__REG(PKUNITY_SPI_BASE + 0x0030)
+#define SPI_ISR		io_p2v(PKUNITY_SPI_BASE + 0x0030)
 
 /*
  * Enable SPI Controller SPI_SSIENR_EN
diff --git a/arch/unicore32/include/mach/regs-umal.h b/arch/unicore32/include/mach/regs-umal.h
index 2e718d1..35880d6 100644
--- a/arch/unicore32/include/mach/regs-umal.h
+++ b/arch/unicore32/include/mach/regs-umal.h
@@ -10,86 +10,86 @@
 /*
  * TX/RX reset and control UMAL_CFG1
  */
-#define UMAL_CFG1		__REG(PKUNITY_UMAL_BASE + 0x0000)
+#define UMAL_CFG1		io_p2v(PKUNITY_UMAL_BASE + 0x0000)
 /*
  * MAC interface mode control UMAL_CFG2
  */
-#define UMAL_CFG2		__REG(PKUNITY_UMAL_BASE + 0x0004)
+#define UMAL_CFG2		io_p2v(PKUNITY_UMAL_BASE + 0x0004)
 /*
  * Inter Packet/Frame Gap UMAL_IPGIFG
  */
-#define UMAL_IPGIFG		__REG(PKUNITY_UMAL_BASE + 0x0008)
+#define UMAL_IPGIFG		io_p2v(PKUNITY_UMAL_BASE + 0x0008)
 /*
  * Collision retry or backoff UMAL_HALFDUPLEX
  */
-#define UMAL_HALFDUPLEX		__REG(PKUNITY_UMAL_BASE + 0x000c)
+#define UMAL_HALFDUPLEX		io_p2v(PKUNITY_UMAL_BASE + 0x000c)
 /*
  * Maximum Frame Length UMAL_MAXFRAME
  */
-#define UMAL_MAXFRAME		__REG(PKUNITY_UMAL_BASE + 0x0010)
+#define UMAL_MAXFRAME		io_p2v(PKUNITY_UMAL_BASE + 0x0010)
 /*
  * Test Regsiter UMAL_TESTREG
  */
-#define UMAL_TESTREG		__REG(PKUNITY_UMAL_BASE + 0x001c)
+#define UMAL_TESTREG		io_p2v(PKUNITY_UMAL_BASE + 0x001c)
 /*
  * MII Management Configure UMAL_MIICFG
  */
-#define UMAL_MIICFG		__REG(PKUNITY_UMAL_BASE + 0x0020)
+#define UMAL_MIICFG		io_p2v(PKUNITY_UMAL_BASE + 0x0020)
 /*
  * MII Management Command UMAL_MIICMD
  */
-#define UMAL_MIICMD		__REG(PKUNITY_UMAL_BASE + 0x0024)
+#define UMAL_MIICMD		io_p2v(PKUNITY_UMAL_BASE + 0x0024)
 /*
  * MII Management Address UMAL_MIIADDR
  */
-#define UMAL_MIIADDR		__REG(PKUNITY_UMAL_BASE + 0x0028)
+#define UMAL_MIIADDR		io_p2v(PKUNITY_UMAL_BASE + 0x0028)
 /*
  * MII Management Control UMAL_MIICTRL
  */
-#define UMAL_MIICTRL		__REG(PKUNITY_UMAL_BASE + 0x002c)
+#define UMAL_MIICTRL		io_p2v(PKUNITY_UMAL_BASE + 0x002c)
 /*
  * MII Management Status UMAL_MIISTATUS
  */
-#define UMAL_MIISTATUS		__REG(PKUNITY_UMAL_BASE + 0x0030)
+#define UMAL_MIISTATUS		io_p2v(PKUNITY_UMAL_BASE + 0x0030)
 /*
  * MII Managment Indicator UMAL_MIIIDCT
  */
-#define UMAL_MIIIDCT		__REG(PKUNITY_UMAL_BASE + 0x0034)
+#define UMAL_MIIIDCT		io_p2v(PKUNITY_UMAL_BASE + 0x0034)
 /*
  * Interface Control UMAL_IFCTRL
  */
-#define UMAL_IFCTRL		__REG(PKUNITY_UMAL_BASE + 0x0038)
+#define UMAL_IFCTRL		io_p2v(PKUNITY_UMAL_BASE + 0x0038)
 /*
  * Interface Status UMAL_IFSTATUS
  */
-#define UMAL_IFSTATUS		__REG(PKUNITY_UMAL_BASE + 0x003c)
+#define UMAL_IFSTATUS		io_p2v(PKUNITY_UMAL_BASE + 0x003c)
 /*
  * MAC address (high 4 bytes) UMAL_STADDR1
  */
-#define UMAL_STADDR1		__REG(PKUNITY_UMAL_BASE + 0x0040)
+#define UMAL_STADDR1		io_p2v(PKUNITY_UMAL_BASE + 0x0040)
 /*
  * MAC address (low 2 bytes) UMAL_STADDR2
  */
-#define UMAL_STADDR2		__REG(PKUNITY_UMAL_BASE + 0x0044)
+#define UMAL_STADDR2		io_p2v(PKUNITY_UMAL_BASE + 0x0044)
 
 /* FIFO MODULE OF UMAL */
 /* UMAL's FIFO module provides data queuing for increased system level
  * throughput
  */
-#define UMAL_FIFOCFG0		__REG(PKUNITY_UMAL_BASE + 0x0048)
-#define UMAL_FIFOCFG1		__REG(PKUNITY_UMAL_BASE + 0x004c)
-#define UMAL_FIFOCFG2		__REG(PKUNITY_UMAL_BASE + 0x0050)
-#define UMAL_FIFOCFG3		__REG(PKUNITY_UMAL_BASE + 0x0054)
-#define UMAL_FIFOCFG4		__REG(PKUNITY_UMAL_BASE + 0x0058)
-#define UMAL_FIFOCFG5		__REG(PKUNITY_UMAL_BASE + 0x005c)
-#define UMAL_FIFORAM0		__REG(PKUNITY_UMAL_BASE + 0x0060)
-#define UMAL_FIFORAM1		__REG(PKUNITY_UMAL_BASE + 0x0064)
-#define UMAL_FIFORAM2		__REG(PKUNITY_UMAL_BASE + 0x0068)
-#define UMAL_FIFORAM3		__REG(PKUNITY_UMAL_BASE + 0x006c)
-#define UMAL_FIFORAM4		__REG(PKUNITY_UMAL_BASE + 0x0070)
-#define UMAL_FIFORAM5		__REG(PKUNITY_UMAL_BASE + 0x0074)
-#define UMAL_FIFORAM6		__REG(PKUNITY_UMAL_BASE + 0x0078)
-#define UMAL_FIFORAM7		__REG(PKUNITY_UMAL_BASE + 0x007c)
+#define UMAL_FIFOCFG0		io_p2v(PKUNITY_UMAL_BASE + 0x0048)
+#define UMAL_FIFOCFG1		io_p2v(PKUNITY_UMAL_BASE + 0x004c)
+#define UMAL_FIFOCFG2		io_p2v(PKUNITY_UMAL_BASE + 0x0050)
+#define UMAL_FIFOCFG3		io_p2v(PKUNITY_UMAL_BASE + 0x0054)
+#define UMAL_FIFOCFG4		io_p2v(PKUNITY_UMAL_BASE + 0x0058)
+#define UMAL_FIFOCFG5		io_p2v(PKUNITY_UMAL_BASE + 0x005c)
+#define UMAL_FIFORAM0		io_p2v(PKUNITY_UMAL_BASE + 0x0060)
+#define UMAL_FIFORAM1		io_p2v(PKUNITY_UMAL_BASE + 0x0064)
+#define UMAL_FIFORAM2		io_p2v(PKUNITY_UMAL_BASE + 0x0068)
+#define UMAL_FIFORAM3		io_p2v(PKUNITY_UMAL_BASE + 0x006c)
+#define UMAL_FIFORAM4		io_p2v(PKUNITY_UMAL_BASE + 0x0070)
+#define UMAL_FIFORAM5		io_p2v(PKUNITY_UMAL_BASE + 0x0074)
+#define UMAL_FIFORAM6		io_p2v(PKUNITY_UMAL_BASE + 0x0078)
+#define UMAL_FIFORAM7		io_p2v(PKUNITY_UMAL_BASE + 0x007c)
 
 /* MAHBE MODUEL OF UMAL */
 /* UMAL's MAHBE module interfaces to the host system through 32-bit AHB Master
@@ -99,35 +99,35 @@
 /*
  * Transmit Control UMAL_DMATxCtrl
  */
-#define UMAL_DMATxCtrl		__REG(PKUNITY_UMAL_BASE + 0x0180)
+#define UMAL_DMATxCtrl		io_p2v(PKUNITY_UMAL_BASE + 0x0180)
 /*
  * Pointer to TX Descripter UMAL_DMATxDescriptor
  */
-#define UMAL_DMATxDescriptor	__REG(PKUNITY_UMAL_BASE + 0x0184)
+#define UMAL_DMATxDescriptor	io_p2v(PKUNITY_UMAL_BASE + 0x0184)
 /*
  * Status of Tx Packet Transfers UMAL_DMATxStatus
  */
-#define UMAL_DMATxStatus	__REG(PKUNITY_UMAL_BASE + 0x0188)
+#define UMAL_DMATxStatus	io_p2v(PKUNITY_UMAL_BASE + 0x0188)
 /*
  * Receive Control UMAL_DMARxCtrl
  */
-#define UMAL_DMARxCtrl		__REG(PKUNITY_UMAL_BASE + 0x018c)
+#define UMAL_DMARxCtrl		io_p2v(PKUNITY_UMAL_BASE + 0x018c)
 /*
  * Pointer to Rx Descriptor UMAL_DMARxDescriptor
  */
-#define UMAL_DMARxDescriptor	__REG(PKUNITY_UMAL_BASE + 0x0190)
+#define UMAL_DMARxDescriptor	io_p2v(PKUNITY_UMAL_BASE + 0x0190)
 /*
  * Status of Rx Packet Transfers UMAL_DMARxStatus
  */
-#define UMAL_DMARxStatus	__REG(PKUNITY_UMAL_BASE + 0x0194)
+#define UMAL_DMARxStatus	io_p2v(PKUNITY_UMAL_BASE + 0x0194)
 /*
  * Interrupt Mask UMAL_DMAIntrMask
  */
-#define UMAL_DMAIntrMask	__REG(PKUNITY_UMAL_BASE + 0x0198)
+#define UMAL_DMAIntrMask	io_p2v(PKUNITY_UMAL_BASE + 0x0198)
 /*
  * Interrupts, read only UMAL_DMAInterrupt
  */
-#define UMAL_DMAInterrupt	__REG(PKUNITY_UMAL_BASE + 0x019c)
+#define UMAL_DMAInterrupt	io_p2v(PKUNITY_UMAL_BASE + 0x019c)
 
 /*
  * Commands for UMAL_CFG1 register
diff --git a/arch/unicore32/include/mach/regs-unigfx.h b/arch/unicore32/include/mach/regs-unigfx.h
index 58bbd54..a2f1dec 100644
--- a/arch/unicore32/include/mach/regs-unigfx.h
+++ b/arch/unicore32/include/mach/regs-unigfx.h
@@ -11,67 +11,67 @@
 /*
  * control reg UDE_CFG
  */
-#define UDE_CFG       __REG(UDE_BASE + 0x0000)
+#define UDE_CFG       io_p2v(UDE_BASE + 0x0000)
 /*
  * framebuffer start address reg UDE_FSA
  */
-#define UDE_FSA       __REG(UDE_BASE + 0x0004)
+#define UDE_FSA       io_p2v(UDE_BASE + 0x0004)
 /*
  * line size reg UDE_LS
  */
-#define UDE_LS        __REG(UDE_BASE + 0x0008)
+#define UDE_LS        io_p2v(UDE_BASE + 0x0008)
 /*
  * pitch size reg UDE_PS
  */
-#define UDE_PS        __REG(UDE_BASE + 0x000C)
+#define UDE_PS        io_p2v(UDE_BASE + 0x000C)
 /*
  * horizontal active time reg UDE_HAT
  */
-#define UDE_HAT       __REG(UDE_BASE + 0x0010)
+#define UDE_HAT       io_p2v(UDE_BASE + 0x0010)
 /*
  * horizontal blank time reg UDE_HBT
  */
-#define UDE_HBT       __REG(UDE_BASE + 0x0014)
+#define UDE_HBT       io_p2v(UDE_BASE + 0x0014)
 /*
  * horizontal sync time reg UDE_HST
  */
-#define UDE_HST       __REG(UDE_BASE + 0x0018)
+#define UDE_HST       io_p2v(UDE_BASE + 0x0018)
 /*
  * vertival active time reg UDE_VAT
  */
-#define UDE_VAT       __REG(UDE_BASE + 0x001C)
+#define UDE_VAT       io_p2v(UDE_BASE + 0x001C)
 /*
  * vertival blank time reg UDE_VBT
  */
-#define UDE_VBT       __REG(UDE_BASE + 0x0020)
+#define UDE_VBT       io_p2v(UDE_BASE + 0x0020)
 /*
  * vertival sync time reg UDE_VST
  */
-#define UDE_VST       __REG(UDE_BASE + 0x0024)
+#define UDE_VST       io_p2v(UDE_BASE + 0x0024)
 /*
  * cursor position UDE_CXY
  */
-#define UDE_CXY       __REG(UDE_BASE + 0x0028)
+#define UDE_CXY       io_p2v(UDE_BASE + 0x0028)
 /*
  * cursor front color UDE_CC0
  */
-#define UDE_CC0       __REG(UDE_BASE + 0x002C)
+#define UDE_CC0       io_p2v(UDE_BASE + 0x002C)
 /*
  * cursor background color UDE_CC1
  */
-#define UDE_CC1       __REG(UDE_BASE + 0x0030)
+#define UDE_CC1       io_p2v(UDE_BASE + 0x0030)
 /*
  * video position UDE_VXY
  */
-#define UDE_VXY       __REG(UDE_BASE + 0x0034)
+#define UDE_VXY       io_p2v(UDE_BASE + 0x0034)
 /*
  * video start address reg UDE_VSA
  */
-#define UDE_VSA       __REG(UDE_BASE + 0x0040)
+#define UDE_VSA       io_p2v(UDE_BASE + 0x0040)
 /*
  * video size reg UDE_VS
  */
-#define UDE_VS        __REG(UDE_BASE + 0x004C)
+#define UDE_VS        io_p2v(UDE_BASE + 0x004C)
 
 /*
  * command reg for UNIGFX GE
@@ -79,102 +79,102 @@
 /*
  * src xy reg UGE_SRCXY
  */
-#define UGE_SRCXY     __REG(UGE_BASE + 0x0000)
+#define UGE_SRCXY     io_p2v(UGE_BASE + 0x0000)
 /*
  * dst xy reg UGE_DSTXY
  */
-#define UGE_DSTXY     __REG(UGE_BASE + 0x0004)
+#define UGE_DSTXY     io_p2v(UGE_BASE + 0x0004)
 /*
  * pitch reg UGE_PITCH
  */
-#define UGE_PITCH     __REG(UGE_BASE + 0x0008)
+#define UGE_PITCH     io_p2v(UGE_BASE + 0x0008)
 /*
  * src start reg UGE_SRCSTART
  */
-#define UGE_SRCSTART  __REG(UGE_BASE + 0x000C)
+#define UGE_SRCSTART  io_p2v(UGE_BASE + 0x000C)
 /*
  * dst start reg UGE_DSTSTART
  */
-#define UGE_DSTSTART  __REG(UGE_BASE + 0x0010)
+#define UGE_DSTSTART  io_p2v(UGE_BASE + 0x0010)
 /*
  * width height reg UGE_WIDHEIGHT
  */
-#define UGE_WIDHEIGHT __REG(UGE_BASE + 0x0014)
+#define UGE_WIDHEIGHT io_p2v(UGE_BASE + 0x0014)
 /*
  * rop alpah reg UGE_ROPALPHA
  */
-#define UGE_ROPALPHA  __REG(UGE_BASE + 0x0018)
+#define UGE_ROPALPHA  io_p2v(UGE_BASE + 0x0018)
 /*
  * front color UGE_FCOLOR
  */
-#define UGE_FCOLOR    __REG(UGE_BASE + 0x001C)
+#define UGE_FCOLOR    io_p2v(UGE_BASE + 0x001C)
 /*
  * background color UGE_BCOLOR
  */
-#define UGE_BCOLOR    __REG(UGE_BASE + 0x0020)
+#define UGE_BCOLOR    io_p2v(UGE_BASE + 0x0020)
 /*
  * src color key for high value UGE_SCH
  */
-#define UGE_SCH       __REG(UGE_BASE + 0x0024)
+#define UGE_SCH       io_p2v(UGE_BASE + 0x0024)
 /*
  * dst color key for high value UGE_DCH
  */
-#define UGE_DCH       __REG(UGE_BASE + 0x0028)
+#define UGE_DCH       io_p2v(UGE_BASE + 0x0028)
 /*
  * src color key for low value UGE_SCL
  */
-#define UGE_SCL       __REG(UGE_BASE + 0x002C)
+#define UGE_SCL       io_p2v(UGE_BASE + 0x002C)
 /*
  * dst color key for low value UGE_DCL
  */
-#define UGE_DCL       __REG(UGE_BASE + 0x0030)
+#define UGE_DCL       io_p2v(UGE_BASE + 0x0030)
 /*
  * clip 0 reg UGE_CLIP0
  */
-#define UGE_CLIP0     __REG(UGE_BASE + 0x0034)
+#define UGE_CLIP0     io_p2v(UGE_BASE + 0x0034)
 /*
  * clip 1 reg UGE_CLIP1
  */
-#define UGE_CLIP1     __REG(UGE_BASE + 0x0038)
+#define UGE_CLIP1     io_p2v(UGE_BASE + 0x0038)
 /*
  * command reg UGE_COMMAND
  */
-#define UGE_COMMAND   __REG(UGE_BASE + 0x003C)
+#define UGE_COMMAND   io_p2v(UGE_BASE + 0x003C)
 /*
  * pattern 0 UGE_P0
  */
-#define UGE_P0        __REG(UGE_BASE + 0x0040)
-#define UGE_P1        __REG(UGE_BASE + 0x0044)
-#define UGE_P2        __REG(UGE_BASE + 0x0048)
-#define UGE_P3        __REG(UGE_BASE + 0x004C)
-#define UGE_P4        __REG(UGE_BASE + 0x0050)
-#define UGE_P5        __REG(UGE_BASE + 0x0054)
-#define UGE_P6        __REG(UGE_BASE + 0x0058)
-#define UGE_P7        __REG(UGE_BASE + 0x005C)
-#define UGE_P8        __REG(UGE_BASE + 0x0060)
-#define UGE_P9        __REG(UGE_BASE + 0x0064)
-#define UGE_P10       __REG(UGE_BASE + 0x0068)
-#define UGE_P11       __REG(UGE_BASE + 0x006C)
-#define UGE_P12       __REG(UGE_BASE + 0x0070)
-#define UGE_P13       __REG(UGE_BASE + 0x0074)
-#define UGE_P14       __REG(UGE_BASE + 0x0078)
-#define UGE_P15       __REG(UGE_BASE + 0x007C)
-#define UGE_P16       __REG(UGE_BASE + 0x0080)
-#define UGE_P17       __REG(UGE_BASE + 0x0084)
-#define UGE_P18       __REG(UGE_BASE + 0x0088)
-#define UGE_P19       __REG(UGE_BASE + 0x008C)
-#define UGE_P20       __REG(UGE_BASE + 0x0090)
-#define UGE_P21       __REG(UGE_BASE + 0x0094)
-#define UGE_P22       __REG(UGE_BASE + 0x0098)
-#define UGE_P23       __REG(UGE_BASE + 0x009C)
-#define UGE_P24       __REG(UGE_BASE + 0x00A0)
-#define UGE_P25       __REG(UGE_BASE + 0x00A4)
-#define UGE_P26       __REG(UGE_BASE + 0x00A8)
-#define UGE_P27       __REG(UGE_BASE + 0x00AC)
-#define UGE_P28       __REG(UGE_BASE + 0x00B0)
-#define UGE_P29       __REG(UGE_BASE + 0x00B4)
-#define UGE_P30       __REG(UGE_BASE + 0x00B8)
-#define UGE_P31       __REG(UGE_BASE + 0x00BC)
+#define UGE_P0        io_p2v(UGE_BASE + 0x0040)
+#define UGE_P1        io_p2v(UGE_BASE + 0x0044)
+#define UGE_P2        io_p2v(UGE_BASE + 0x0048)
+#define UGE_P3        io_p2v(UGE_BASE + 0x004C)
+#define UGE_P4        io_p2v(UGE_BASE + 0x0050)
+#define UGE_P5        io_p2v(UGE_BASE + 0x0054)
+#define UGE_P6        io_p2v(UGE_BASE + 0x0058)
+#define UGE_P7        io_p2v(UGE_BASE + 0x005C)
+#define UGE_P8        io_p2v(UGE_BASE + 0x0060)
+#define UGE_P9        io_p2v(UGE_BASE + 0x0064)
+#define UGE_P10       io_p2v(UGE_BASE + 0x0068)
+#define UGE_P11       io_p2v(UGE_BASE + 0x006C)
+#define UGE_P12       io_p2v(UGE_BASE + 0x0070)
+#define UGE_P13       io_p2v(UGE_BASE + 0x0074)
+#define UGE_P14       io_p2v(UGE_BASE + 0x0078)
+#define UGE_P15       io_p2v(UGE_BASE + 0x007C)
+#define UGE_P16       io_p2v(UGE_BASE + 0x0080)
+#define UGE_P17       io_p2v(UGE_BASE + 0x0084)
+#define UGE_P18       io_p2v(UGE_BASE + 0x0088)
+#define UGE_P19       io_p2v(UGE_BASE + 0x008C)
+#define UGE_P20       io_p2v(UGE_BASE + 0x0090)
+#define UGE_P21       io_p2v(UGE_BASE + 0x0094)
+#define UGE_P22       io_p2v(UGE_BASE + 0x0098)
+#define UGE_P23       io_p2v(UGE_BASE + 0x009C)
+#define UGE_P24       io_p2v(UGE_BASE + 0x00A0)
+#define UGE_P25       io_p2v(UGE_BASE + 0x00A4)
+#define UGE_P26       io_p2v(UGE_BASE + 0x00A8)
+#define UGE_P27       io_p2v(UGE_BASE + 0x00AC)
+#define UGE_P28       io_p2v(UGE_BASE + 0x00B0)
+#define UGE_P29       io_p2v(UGE_BASE + 0x00B4)
+#define UGE_P30       io_p2v(UGE_BASE + 0x00B8)
+#define UGE_P31       io_p2v(UGE_BASE + 0x00BC)
 
 #define UDE_CFG_DST_MASK	FMASK(2, 8)
 #define UDE_CFG_DST8            FIELD(0x0, 2, 8)
-- 
1.7.4.1

