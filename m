Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756962Ab1JAUGw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 16:06:52 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:64053 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756682Ab1JAUFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 16:05:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jason Chagas <jason.chagas@marvell.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 13/26] ARM: pxa: use correct __iomem annotations
Date: Sat,  1 Oct 2011 22:03:45 +0200
Message-Id: <1317499438-14058-14-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317499438-14058-1-git-send-email-arnd@arndb.de>
References: <1317499438-14058-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:v9OTIc81g8zf3jpl8kWgZgl5eaGThakzI4tLpuATZ4w
 mFyesJw7LrM/QtGg+IB0AQRnKuA37O1gUXNgCz9Bu2lf1xWdU4
 ZgB2SpMlRhmefsS3fiOZmjkesswyRcFBTgMi9fMeUCvNMV89kh
 gmfJrfjhUpHERwcByuydDPgNtwWEj66NN9W/r4dqgXQqy7C2wE
 bd8YB87XK7X5Jc8gtohSsAGDh0GHdnUpGo0cwqltJQ0uT52cnH
 KeeUCMbAB4PH2b89CAymtAysciH37lz9O/F5Xpc2vXNNamYKfY
 +Zh6Noj1KIAAzynOrAN6h77dHEwc8Uy1Q5nuZFSytUvoZO6r6O
 /KqopR8IBdnCz9K2CfhB2LiPoIOWy92pKtYr94V9rUO5IVVrH6
 tMiJaD2x26hZw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This tries to clear up the confusion between integers and iomem pointers
in the marvell pxa platform. MMIO addresses are supposed to be __iomem*
values, in order to let the Linux type checking work correctly. This
patch moves the cast to __iomem as far back as possible, to the place
where the MMIO virtual address windows are defined.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/include/asm/hardware/it8152.h    |    2 +-
 arch/arm/mach-mmp/clock.h                 |    8 ++++----
 arch/arm/mach-mmp/common.c                |    4 ++--
 arch/arm/mach-mmp/include/mach/addr-map.h |   10 ++++++++--
 arch/arm/mach-mmp/mmp2.c                  |    3 ++-
 arch/arm/mach-pxa/balloon3.c              |   10 +++++-----
 arch/arm/mach-pxa/cm-x2xx-pci.c           |    2 +-
 arch/arm/mach-pxa/cm-x2xx.c               |    4 ++--
 arch/arm/mach-pxa/include/mach/addr-map.h |    8 ++++----
 arch/arm/mach-pxa/include/mach/balloon3.h |    2 +-
 arch/arm/mach-pxa/include/mach/hardware.h |    9 +++++----
 arch/arm/mach-pxa/include/mach/lpd270.h   |    4 ++--
 arch/arm/mach-pxa/include/mach/mtd-xip.h  |    1 -
 arch/arm/mach-pxa/include/mach/palmtx.h   |    6 +++---
 arch/arm/mach-pxa/include/mach/smemc.h    |    2 +-
 arch/arm/mach-pxa/include/mach/zeus.h     |    4 ++--
 arch/arm/mach-pxa/irq.c                   |    4 ++--
 arch/arm/mach-pxa/lpd270.c                |    2 +-
 arch/arm/mach-pxa/palmtx.c                |    8 ++++----
 arch/arm/mach-pxa/pxa25x.c                |    2 +-
 arch/arm/mach-pxa/pxa27x.c                |    2 +-
 arch/arm/mach-pxa/pxa3xx.c                |    2 +-
 arch/arm/mach-pxa/zeus.c                  |    8 ++++----
 arch/arm/plat-pxa/gpio.c                  |    2 +-
 arch/arm/plat-pxa/include/plat/mfp.h      |    2 +-
 arch/arm/plat-pxa/mfp.c                   |    4 ++--
 drivers/pcmcia/pxa2xx_balloon3.c          |    2 +-
 drivers/video/mbx/mbxfb.c                 |    6 +++---
 28 files changed, 65 insertions(+), 58 deletions(-)

diff --git a/arch/arm/include/asm/hardware/it8152.h b/arch/arm/include/asm/hardware/it8152.h
index b3fea38..43cab49 100644
--- a/arch/arm/include/asm/hardware/it8152.h
+++ b/arch/arm/include/asm/hardware/it8152.h
@@ -9,7 +9,7 @@
 
 #ifndef __ASM_HARDWARE_IT8152_H
 #define __ASM_HARDWARE_IT8152_H
-extern unsigned long it8152_base_address;
+extern void __iomem *it8152_base_address;
 
 #define IT8152_IO_BASE			(it8152_base_address + 0x03e00000)
 #define IT8152_CFGREG_BASE		(it8152_base_address + 0x03f00000)
diff --git a/arch/arm/mach-mmp/clock.h b/arch/arm/mach-mmp/clock.h
index 3143e99..149b30c 100644
--- a/arch/arm/mach-mmp/clock.h
+++ b/arch/arm/mach-mmp/clock.h
@@ -30,7 +30,7 @@ extern struct clkops apmu_clk_ops;
 
 #define APBC_CLK(_name, _reg, _fnclksel, _rate)			\
 struct clk clk_##_name = {					\
-		.clk_rst	= (void __iomem *)APBC_##_reg,	\
+		.clk_rst	= APBC_##_reg,			\
 		.fnclksel	= _fnclksel,			\
 		.rate		= _rate,			\
 		.ops		= &apbc_clk_ops,		\
@@ -38,7 +38,7 @@ struct clk clk_##_name = {					\
 
 #define APBC_CLK_OPS(_name, _reg, _fnclksel, _rate, _ops)	\
 struct clk clk_##_name = {					\
-		.clk_rst	= (void __iomem *)APBC_##_reg,	\
+		.clk_rst	= APBC_##_reg,			\
 		.fnclksel	= _fnclksel,			\
 		.rate		= _rate,			\
 		.ops		= _ops,				\
@@ -46,7 +46,7 @@ struct clk clk_##_name = {					\
 
 #define APMU_CLK(_name, _reg, _eval, _rate)			\
 struct clk clk_##_name = {					\
-		.clk_rst	= (void __iomem *)APMU_##_reg,	\
+		.clk_rst	= APMU_##_reg,			\
 		.enable_val	= _eval,			\
 		.rate		= _rate,			\
 		.ops		= &apmu_clk_ops,		\
@@ -54,7 +54,7 @@ struct clk clk_##_name = {					\
 
 #define APMU_CLK_OPS(_name, _reg, _eval, _rate, _ops)		\
 struct clk clk_##_name = {					\
-		.clk_rst	= (void __iomem *)APMU_##_reg,	\
+		.clk_rst	= APMU_##_reg,			\
 		.enable_val	= _eval,			\
 		.rate		= _rate,			\
 		.ops		= _ops,				\
diff --git a/arch/arm/mach-mmp/common.c b/arch/arm/mach-mmp/common.c
index 0ec0ca8..5720674 100644
--- a/arch/arm/mach-mmp/common.c
+++ b/arch/arm/mach-mmp/common.c
@@ -27,12 +27,12 @@ EXPORT_SYMBOL(mmp_chip_id);
 static struct map_desc standard_io_desc[] __initdata = {
 	{
 		.pfn		= __phys_to_pfn(APB_PHYS_BASE),
-		.virtual	= APB_VIRT_BASE,
+		.virtual	= (unsigned long)APB_VIRT_BASE,
 		.length		= APB_PHYS_SIZE,
 		.type		= MT_DEVICE,
 	}, {
 		.pfn		= __phys_to_pfn(AXI_PHYS_BASE),
-		.virtual	= AXI_VIRT_BASE,
+		.virtual	= (unsigned long)AXI_VIRT_BASE,
 		.length		= AXI_PHYS_SIZE,
 		.type		= MT_DEVICE,
 	},
diff --git a/arch/arm/mach-mmp/include/mach/addr-map.h b/arch/arm/mach-mmp/include/mach/addr-map.h
index 3254089..3e404ac 100644
--- a/arch/arm/mach-mmp/include/mach/addr-map.h
+++ b/arch/arm/mach-mmp/include/mach/addr-map.h
@@ -11,6 +11,12 @@
 #ifndef __ASM_MACH_ADDR_MAP_H
 #define __ASM_MACH_ADDR_MAP_H
 
+#ifndef __ASSEMBLER__
+#define IOMEM(x)	((void __iomem *)(x))
+#else
+#define IOMEM(x)	(x)
+#endif
+
 /* APB - Application Subsystem Peripheral Bus
  *
  * NOTE: the DMA controller registers are actually on the AXI fabric #1
@@ -18,11 +24,11 @@
  * peripherals on APB, let's count it into the ABP mapping area.
  */
 #define APB_PHYS_BASE		0xd4000000
-#define APB_VIRT_BASE		0xfe000000
+#define APB_VIRT_BASE		IOMEM(0xfe000000)
 #define APB_PHYS_SIZE		0x00200000
 
 #define AXI_PHYS_BASE		0xd4200000
-#define AXI_VIRT_BASE		0xfe200000
+#define AXI_VIRT_BASE		IOMEM(0xfe200000)
 #define AXI_PHYS_SIZE		0x00200000
 
 /* Static Memory Controller - Chip Select 0 and 1 */
diff --git a/arch/arm/mach-mmp/mmp2.c b/arch/arm/mach-mmp/mmp2.c
index 079c188..a80cbea 100644
--- a/arch/arm/mach-mmp/mmp2.c
+++ b/arch/arm/mach-mmp/mmp2.c
@@ -87,7 +87,8 @@ static struct mfp_addr_map mmp2_addr_map[] __initdata = {
 
 void mmp2_clear_pmic_int(void)
 {
-	unsigned long mfpr_pmic, data;
+	void __iomem *mfpr_pmic;
+	unsigned long data;
 
 	mfpr_pmic = APB_VIRT_BASE + 0x1e000 + 0x2c4;
 	data = __raw_readl(mfpr_pmic);
diff --git a/arch/arm/mach-pxa/balloon3.c b/arch/arm/mach-pxa/balloon3.c
index ef3e8b1..d0f1411 100644
--- a/arch/arm/mach-pxa/balloon3.c
+++ b/arch/arm/mach-pxa/balloon3.c
@@ -591,7 +591,7 @@ static void balloon3_nand_cmd_ctl(struct mtd_info *mtd, int cmd, unsigned int ct
 				BALLOON3_NAND_CONTROL_REG);
 		if (balloon3_ctl_set)
 			__raw_writel(balloon3_ctl_set,
-				BALLOON3_NAND_CONTROL_REG |
+				BALLOON3_NAND_CONTROL_REG +
 				BALLOON3_FPGA_SETnCLR);
 	}
 
@@ -608,7 +608,7 @@ static void balloon3_nand_select_chip(struct mtd_info *mtd, int chip)
 	__raw_writew(
 		BALLOON3_NAND_CONTROL_FLCE0 | BALLOON3_NAND_CONTROL_FLCE1 |
 		BALLOON3_NAND_CONTROL_FLCE2 | BALLOON3_NAND_CONTROL_FLCE3,
-		BALLOON3_NAND_CONTROL_REG | BALLOON3_FPGA_SETnCLR);
+		BALLOON3_NAND_CONTROL_REG + BALLOON3_FPGA_SETnCLR);
 
 	/* Deassert correct nCE line */
 	__raw_writew(BALLOON3_NAND_CONTROL_FLCE0 << chip,
@@ -626,7 +626,7 @@ static int balloon3_nand_probe(struct platform_device *pdev)
 	int ret;
 
 	__raw_writew(BALLOON3_NAND_CONTROL2_16BIT,
-		BALLOON3_NAND_CONTROL2_REG | BALLOON3_FPGA_SETnCLR);
+		BALLOON3_NAND_CONTROL2_REG + BALLOON3_FPGA_SETnCLR);
 
 	ver = __raw_readw(BALLOON3_FPGA_VER);
 	if (ver < 0x4f08)
@@ -649,7 +649,7 @@ static int balloon3_nand_probe(struct platform_device *pdev)
 		BALLOON3_NAND_CONTROL_FLCE0 | BALLOON3_NAND_CONTROL_FLCE1 |
 		BALLOON3_NAND_CONTROL_FLCE2 | BALLOON3_NAND_CONTROL_FLCE3 |
 		BALLOON3_NAND_CONTROL_FLWP,
-		BALLOON3_NAND_CONTROL_REG | BALLOON3_FPGA_SETnCLR);
+		BALLOON3_NAND_CONTROL_REG + BALLOON3_FPGA_SETnCLR);
 	return 0;
 
 err2:
@@ -807,7 +807,7 @@ static void __init balloon3_init(void)
 
 static struct map_desc balloon3_io_desc[] __initdata = {
 	{	/* CPLD/FPGA */
-		.virtual	=  BALLOON3_FPGA_VIRT,
+		.virtual	= (unsigned long)BALLOON3_FPGA_VIRT,
 		.pfn		= __phys_to_pfn(BALLOON3_FPGA_PHYS),
 		.length		= BALLOON3_FPGA_LENGTH,
 		.type		= MT_DEVICE,
diff --git a/arch/arm/mach-pxa/cm-x2xx-pci.c b/arch/arm/mach-pxa/cm-x2xx-pci.c
index 6bf479d..ebd9259 100644
--- a/arch/arm/mach-pxa/cm-x2xx-pci.c
+++ b/arch/arm/mach-pxa/cm-x2xx-pci.c
@@ -26,7 +26,7 @@
 
 #include <asm/hardware/it8152.h>
 
-unsigned long it8152_base_address;
+void __iomem *it8152_base_address;
 static int cmx2xx_it8152_irq_gpio;
 
 static void cmx2xx_it8152_irq_demux(unsigned int irq, struct irq_desc *desc)
diff --git a/arch/arm/mach-pxa/cm-x2xx.c b/arch/arm/mach-pxa/cm-x2xx.c
index 13cf518..4f07e16 100644
--- a/arch/arm/mach-pxa/cm-x2xx.c
+++ b/arch/arm/mach-pxa/cm-x2xx.c
@@ -39,7 +39,7 @@ extern void cmx270_init(void);
 #define CMX2XX_NR_IRQS		(IRQ_BOARD_START + 40)
 
 /* virtual addresses for statically mapped regions */
-#define CMX2XX_VIRT_BASE	(0xe8000000)
+#define CMX2XX_VIRT_BASE	(void __iomem *)(0xe8000000)
 #define CMX2XX_IT8152_VIRT	(CMX2XX_VIRT_BASE)
 
 /* physical address if local-bus attached devices */
@@ -482,7 +482,7 @@ static void __init cmx2xx_init_irq(void)
 /* Map PCI companion statically */
 static struct map_desc cmx2xx_io_desc[] __initdata = {
 	[0] = { /* PCI bridge */
-		.virtual	= CMX2XX_IT8152_VIRT,
+		.virtual	= (unsigned long)CMX2XX_IT8152_VIRT,
 		.pfn		= __phys_to_pfn(PXA_CS4_PHYS),
 		.length		= SZ_64M,
 		.type		= MT_DEVICE
diff --git a/arch/arm/mach-pxa/include/mach/addr-map.h b/arch/arm/mach-pxa/include/mach/addr-map.h
index f4c0365..bbf9df3 100644
--- a/arch/arm/mach-pxa/include/mach/addr-map.h
+++ b/arch/arm/mach-pxa/include/mach/addr-map.h
@@ -20,7 +20,7 @@
  * Peripheral Bus
  */
 #define PERIPH_PHYS		0x40000000
-#define PERIPH_VIRT		0xf2000000
+#define PERIPH_VIRT		IOMEM(0xf2000000)
 #define PERIPH_SIZE		0x02000000
 
 /*
@@ -28,21 +28,21 @@
  */
 #define PXA2XX_SMEMC_PHYS	0x48000000
 #define PXA3XX_SMEMC_PHYS	0x4a000000
-#define SMEMC_VIRT		0xf6000000
+#define SMEMC_VIRT		IOMEM(0xf6000000)
 #define SMEMC_SIZE		0x00100000
 
 /*
  * Dynamic Memory Controller (only on PXA3xx)
  */
 #define DMEMC_PHYS		0x48100000
-#define DMEMC_VIRT		0xf6100000
+#define DMEMC_VIRT		IOMEM(0xf6100000)
 #define DMEMC_SIZE		0x00100000
 
 /*
  * Internal Memory Controller (PXA27x and later)
  */
 #define IMEMC_PHYS		0x58000000
-#define IMEMC_VIRT		0xfe000000
+#define IMEMC_VIRT		IOMEM(0xfe000000)
 #define IMEMC_SIZE		0x00100000
 
 #endif /* __ASM_MACH_ADDR_MAP_H */
diff --git a/arch/arm/mach-pxa/include/mach/balloon3.h b/arch/arm/mach-pxa/include/mach/balloon3.h
index 7074e76..6d7eab3 100644
--- a/arch/arm/mach-pxa/include/mach/balloon3.h
+++ b/arch/arm/mach-pxa/include/mach/balloon3.h
@@ -23,7 +23,7 @@ enum balloon3_features {
 };
 
 #define BALLOON3_FPGA_PHYS	PXA_CS4_PHYS
-#define BALLOON3_FPGA_VIRT	(0xf1000000)	/* as per balloon2 */
+#define BALLOON3_FPGA_VIRT	IOMEM(0xf1000000)	/* as per balloon2 */
 #define BALLOON3_FPGA_LENGTH	0x01000000
 
 #define	BALLOON3_FPGA_SETnCLR		(0x1000)
diff --git a/arch/arm/mach-pxa/include/mach/hardware.h b/arch/arm/mach-pxa/include/mach/hardware.h
index de63ca3..8184669 100644
--- a/arch/arm/mach-pxa/include/mach/hardware.h
+++ b/arch/arm/mach-pxa/include/mach/hardware.h
@@ -36,22 +36,23 @@
  * Note that not all PXA2xx chips implement all those addresses, and the
  * kernel only maps the minimum needed range of this mapping.
  */
-#define io_p2v(x) (0xf2000000 + ((x) & 0x01ffffff) + (((x) & 0x1c000000) >> 1))
 #define io_v2p(x) (0x3c000000 + ((x) & 0x01ffffff) + (((x) & 0x0e000000) << 1))
+#define io_p2v(x) IOMEM(0xf2000000 + ((x) & 0x01ffffff) + (((x) & 0x1c000000) >> 1))
 
 #ifndef __ASSEMBLY__
-
-# define __REG(x)	(*((volatile u32 *)io_p2v(x)))
+# define IOMEM(x) ((void __iomem *)(x))
+# define __REG(x)	(*((volatile u32 __iomem *)io_p2v(x)))
 
 /* With indexed regs we don't want to feed the index through io_p2v()
    especially if it is a variable, otherwise horrible code will result. */
 # define __REG2(x,y)	\
-	(*(volatile u32 *)((u32)&__REG(x) + (y)))
+	(*(volatile u32 __iomem*)((u32)&__REG(x) + (y)))
 
 # define __PREG(x)	(io_v2p((u32)&(x)))
 
 #else
 
+# define IOMEM(x)	x 
 # define __REG(x)	io_p2v(x)
 # define __PREG(x)	io_v2p(x)
 
diff --git a/arch/arm/mach-pxa/include/mach/lpd270.h b/arch/arm/mach-pxa/include/mach/lpd270.h
index cd07009..4edc712 100644
--- a/arch/arm/mach-pxa/include/mach/lpd270.h
+++ b/arch/arm/mach-pxa/include/mach/lpd270.h
@@ -13,13 +13,13 @@
 #define __ASM_ARCH_LPD270_H
 
 #define LPD270_CPLD_PHYS	PXA_CS2_PHYS
-#define LPD270_CPLD_VIRT	0xf0000000
+#define LPD270_CPLD_VIRT	IOMEM(0xf0000000)
 #define LPD270_CPLD_SIZE	0x00100000
 
 #define LPD270_ETH_PHYS		(PXA_CS2_PHYS + 0x01000000)
 
 /* CPLD registers  */
-#define LPD270_CPLD_REG(x)	((unsigned long)(LPD270_CPLD_VIRT + (x)))
+#define LPD270_CPLD_REG(x)	(LPD270_CPLD_VIRT + (x))
 #define LPD270_CONTROL		LPD270_CPLD_REG(0x00)
 #define LPD270_PERIPHERAL0	LPD270_CPLD_REG(0x04)
 #define LPD270_PERIPHERAL1	LPD270_CPLD_REG(0x08)
diff --git a/arch/arm/mach-pxa/include/mach/mtd-xip.h b/arch/arm/mach-pxa/include/mach/mtd-xip.h
index 297387e..990d2bf 100644
--- a/arch/arm/mach-pxa/include/mach/mtd-xip.h
+++ b/arch/arm/mach-pxa/include/mach/mtd-xip.h
@@ -16,7 +16,6 @@
 #define __ARCH_PXA_MTD_XIP_H__
 
 #include <mach/regs-ost.h>
-#include <mach/regs-intc.h>
 
 #define xip_irqpending()	(ICIP & ICMR)
 
diff --git a/arch/arm/mach-pxa/include/mach/palmtx.h b/arch/arm/mach-pxa/include/mach/palmtx.h
index 10abc4f..7074a6e 100644
--- a/arch/arm/mach-pxa/include/mach/palmtx.h
+++ b/arch/arm/mach-pxa/include/mach/palmtx.h
@@ -71,7 +71,7 @@
 
 /* Various addresses  */
 #define PALMTX_PCMCIA_PHYS	0x28000000
-#define PALMTX_PCMCIA_VIRT	0xf0000000
+#define PALMTX_PCMCIA_VIRT	IOMEM(0xf0000000)
 #define PALMTX_PCMCIA_SIZE	0x100000
 
 #define PALMTX_PHYS_RAM_START	0xa0000000
@@ -84,8 +84,8 @@
 
 #define PALMTX_NAND_ALE_PHYS	(PALMTX_PHYS_NAND_START | (1 << 24))
 #define PALMTX_NAND_CLE_PHYS	(PALMTX_PHYS_NAND_START | (1 << 25))
-#define PALMTX_NAND_ALE_VIRT	0xff100000
-#define PALMTX_NAND_CLE_VIRT	0xff200000
+#define PALMTX_NAND_ALE_VIRT	IOMEM(0xff100000)
+#define PALMTX_NAND_CLE_VIRT	IOMEM(0xff200000)
 
 /* TOUCHSCREEN */
 #define AC97_LINK_FRAME			21
diff --git a/arch/arm/mach-pxa/include/mach/smemc.h b/arch/arm/mach-pxa/include/mach/smemc.h
index 654adc9..b7de471 100644
--- a/arch/arm/mach-pxa/include/mach/smemc.h
+++ b/arch/arm/mach-pxa/include/mach/smemc.h
@@ -13,7 +13,7 @@
 
 #define PXA2XX_SMEMC_BASE	0x48000000
 #define PXA3XX_SMEMC_BASE	0x4a000000
-#define SMEMC_VIRT		0xf6000000
+#define SMEMC_VIRT		IOMEM(0xf6000000)
 
 #define MDCNFG		(SMEMC_VIRT + 0x00)  /* SDRAM Configuration Register 0 */
 #define MDREFR		(SMEMC_VIRT + 0x04)  /* SDRAM Refresh Control Register */
diff --git a/arch/arm/mach-pxa/include/mach/zeus.h b/arch/arm/mach-pxa/include/mach/zeus.h
index 0641f31..56024f8 100644
--- a/arch/arm/mach-pxa/include/mach/zeus.h
+++ b/arch/arm/mach-pxa/include/mach/zeus.h
@@ -68,7 +68,7 @@
  * Be gentle, and remap that over 32kB...
  */
 
-#define ZEUS_CPLD		(0xf0000000)
+#define ZEUS_CPLD		IOMEM(0xf0000000)
 #define ZEUS_CPLD_VERSION	(ZEUS_CPLD + 0x0000)
 #define ZEUS_CPLD_ISA_IRQ	(ZEUS_CPLD + 0x1000)
 #define ZEUS_CPLD_CONTROL	(ZEUS_CPLD + 0x2000)
@@ -76,7 +76,7 @@
 /* CPLD register bits */
 #define ZEUS_CPLD_CONTROL_CF_RST        0x01
 
-#define ZEUS_PC104IO		(0xf1000000)
+#define ZEUS_PC104IO		IOMEM(0xf1000000)
 
 #define ZEUS_SRAM_SIZE		(256 * 1024)
 
diff --git a/arch/arm/mach-pxa/irq.c b/arch/arm/mach-pxa/irq.c
index 848e96d..5344f05 100644
--- a/arch/arm/mach-pxa/irq.c
+++ b/arch/arm/mach-pxa/irq.c
@@ -26,7 +26,7 @@
 
 #include "generic.h"
 
-#define IRQ_BASE		(void __iomem *)io_p2v(0x40d00000)
+#define IRQ_BASE		io_p2v(0x40d00000)
 
 #define ICIP			(0x000)
 #define ICMR			(0x004)
@@ -64,7 +64,7 @@ static inline void __iomem *irq_base(int i)
 		0x40d00130,
 	};
 
-	return (void __iomem *)io_p2v(phys_base[i]);
+	return io_p2v(phys_base[i]);
 }
 
 void pxa_mask_irq(struct irq_data *d)
diff --git a/arch/arm/mach-pxa/lpd270.c b/arch/arm/mach-pxa/lpd270.c
index c171d6e..e30cdc8 100644
--- a/arch/arm/mach-pxa/lpd270.c
+++ b/arch/arm/mach-pxa/lpd270.c
@@ -480,7 +480,7 @@ static void __init lpd270_init(void)
 
 static struct map_desc lpd270_io_desc[] __initdata = {
 	{
-		.virtual	= LPD270_CPLD_VIRT,
+		.virtual	= (unsigned long)LPD270_CPLD_VIRT,
 		.pfn		= __phys_to_pfn(LPD270_CPLD_PHYS),
 		.length		= LPD270_CPLD_SIZE,
 		.type		= MT_DEVICE,
diff --git a/arch/arm/mach-pxa/palmtx.c b/arch/arm/mach-pxa/palmtx.c
index fc42855..00c318f 100644
--- a/arch/arm/mach-pxa/palmtx.c
+++ b/arch/arm/mach-pxa/palmtx.c
@@ -247,7 +247,7 @@ static void palmtx_nand_cmd_ctl(struct mtd_info *mtd, int cmd,
 				 unsigned int ctrl)
 {
 	struct nand_chip *this = mtd->priv;
-	unsigned long nandaddr = (unsigned long)this->IO_ADDR_W;
+	char __iomem *nandaddr = this->IO_ADDR_W;
 
 	if (cmd == NAND_CMD_NONE)
 		return;
@@ -315,17 +315,17 @@ static inline void palmtx_nand_init(void) {}
  ******************************************************************************/
 static struct map_desc palmtx_io_desc[] __initdata = {
 {
-	.virtual	= PALMTX_PCMCIA_VIRT,
+	.virtual	= (unsigned long)PALMTX_PCMCIA_VIRT,
 	.pfn		= __phys_to_pfn(PALMTX_PCMCIA_PHYS),
 	.length		= PALMTX_PCMCIA_SIZE,
 	.type		= MT_DEVICE,
 }, {
-	.virtual	= PALMTX_NAND_ALE_VIRT,
+	.virtual	= (unsigned long)PALMTX_NAND_ALE_VIRT,
 	.pfn		= __phys_to_pfn(PALMTX_NAND_ALE_PHYS),
 	.length		= SZ_1M,
 	.type		= MT_DEVICE,
 }, {
-	.virtual	= PALMTX_NAND_CLE_VIRT,
+	.virtual	= (unsigned long)PALMTX_NAND_CLE_VIRT,
 	.pfn		= __phys_to_pfn(PALMTX_NAND_CLE_PHYS),
 	.length		= SZ_1M,
 	.type		= MT_DEVICE,
diff --git a/arch/arm/mach-pxa/pxa25x.c b/arch/arm/mach-pxa/pxa25x.c
index 9c434d2..6c49c7c 100644
--- a/arch/arm/mach-pxa/pxa25x.c
+++ b/arch/arm/mach-pxa/pxa25x.c
@@ -324,7 +324,7 @@ void __init pxa26x_init_irq(void)
 
 static struct map_desc pxa25x_io_desc[] __initdata = {
 	{	/* Mem Ctl */
-		.virtual	= SMEMC_VIRT,
+		.virtual	= (unsigned long)SMEMC_VIRT,
 		.pfn		= __phys_to_pfn(PXA2XX_SMEMC_BASE),
 		.length		= 0x00200000,
 		.type		= MT_DEVICE
diff --git a/arch/arm/mach-pxa/pxa27x.c b/arch/arm/mach-pxa/pxa27x.c
index 9d2400b..729af54 100644
--- a/arch/arm/mach-pxa/pxa27x.c
+++ b/arch/arm/mach-pxa/pxa27x.c
@@ -390,7 +390,7 @@ void __init pxa27x_init_irq(void)
 
 static struct map_desc pxa27x_io_desc[] __initdata = {
 	{	/* Mem Ctl */
-		.virtual	= SMEMC_VIRT,
+		.virtual	= (unsigned long)SMEMC_VIRT,
 		.pfn		= __phys_to_pfn(PXA2XX_SMEMC_BASE),
 		.length		= 0x00200000,
 		.type		= MT_DEVICE
diff --git a/arch/arm/mach-pxa/pxa3xx.c b/arch/arm/mach-pxa/pxa3xx.c
index b5cd9e5..b2479cb 100644
--- a/arch/arm/mach-pxa/pxa3xx.c
+++ b/arch/arm/mach-pxa/pxa3xx.c
@@ -394,7 +394,7 @@ void __init pxa3xx_init_irq(void)
 
 static struct map_desc pxa3xx_io_desc[] __initdata = {
 	{	/* Mem Ctl */
-		.virtual	= SMEMC_VIRT,
+		.virtual	= (unsigned long)SMEMC_VIRT,
 		.pfn		= __phys_to_pfn(PXA3XX_SMEMC_BASE),
 		.length		= 0x00200000,
 		.type		= MT_DEVICE
diff --git a/arch/arm/mach-pxa/zeus.c b/arch/arm/mach-pxa/zeus.c
index 99c49bc..9188492 100644
--- a/arch/arm/mach-pxa/zeus.c
+++ b/arch/arm/mach-pxa/zeus.c
@@ -860,25 +860,25 @@ static void __init zeus_init(void)
 
 static struct map_desc zeus_io_desc[] __initdata = {
 	{
-		.virtual = ZEUS_CPLD_VERSION,
+		.virtual = (unsigned long)ZEUS_CPLD_VERSION,
 		.pfn     = __phys_to_pfn(ZEUS_CPLD_VERSION_PHYS),
 		.length  = 0x1000,
 		.type    = MT_DEVICE,
 	},
 	{
-		.virtual = ZEUS_CPLD_ISA_IRQ,
+		.virtual = (unsigned long)ZEUS_CPLD_ISA_IRQ,
 		.pfn     = __phys_to_pfn(ZEUS_CPLD_ISA_IRQ_PHYS),
 		.length  = 0x1000,
 		.type    = MT_DEVICE,
 	},
 	{
-		.virtual = ZEUS_CPLD_CONTROL,
+		.virtual = (unsigned long)ZEUS_CPLD_CONTROL,
 		.pfn     = __phys_to_pfn(ZEUS_CPLD_CONTROL_PHYS),
 		.length  = 0x1000,
 		.type    = MT_DEVICE,
 	},
 	{
-		.virtual = ZEUS_PC104IO,
+		.virtual = (unsigned long)ZEUS_PC104IO,
 		.pfn     = __phys_to_pfn(ZEUS_PC104IO_PHYS),
 		.length  = 0x00800000,
 		.type    = MT_DEVICE,
diff --git a/arch/arm/plat-pxa/gpio.c b/arch/arm/plat-pxa/gpio.c
index a11dc36..0db7615 100644
--- a/arch/arm/plat-pxa/gpio.c
+++ b/arch/arm/plat-pxa/gpio.c
@@ -122,7 +122,7 @@ static int __init pxa_init_gpio_chip(int gpio_end)
 		struct gpio_chip *c = &chips[i].chip;
 
 		sprintf(chips[i].label, "gpio-%d", i);
-		chips[i].regbase = (void __iomem *)GPIO_BANK(i);
+		chips[i].regbase = GPIO_BANK(i);
 
 		c->base  = gpio;
 		c->label = chips[i].label;
diff --git a/arch/arm/plat-pxa/include/plat/mfp.h b/arch/arm/plat-pxa/include/plat/mfp.h
index 89e68e0..5c79c29 100644
--- a/arch/arm/plat-pxa/include/plat/mfp.h
+++ b/arch/arm/plat-pxa/include/plat/mfp.h
@@ -456,7 +456,7 @@ struct mfp_addr_map {
 
 #define MFP_ADDR_END	{ MFP_PIN_INVALID, 0 }
 
-void __init mfp_init_base(unsigned long mfpr_base);
+void __init mfp_init_base(void __iomem *mfpr_base);
 void __init mfp_init_addr(struct mfp_addr_map *map);
 
 /*
diff --git a/arch/arm/plat-pxa/mfp.c b/arch/arm/plat-pxa/mfp.c
index be12ead..2c4dbb1 100644
--- a/arch/arm/plat-pxa/mfp.c
+++ b/arch/arm/plat-pxa/mfp.c
@@ -229,7 +229,7 @@ void mfp_write(int mfp, unsigned long val)
 	spin_unlock_irqrestore(&mfp_spin_lock, flags);
 }
 
-void __init mfp_init_base(unsigned long mfpr_base)
+void __init mfp_init_base(void __iomem *mfpr_base)
 {
 	int i;
 
@@ -237,7 +237,7 @@ void __init mfp_init_base(unsigned long mfpr_base)
 	for (i = 0; i < ARRAY_SIZE(mfp_table); i++)
 		mfp_table[i].config = -1;
 
-	mfpr_mmio_base = (void __iomem *)mfpr_base;
+	mfpr_mmio_base = mfpr_base;
 }
 
 void __init mfp_init_addr(struct mfp_addr_map *map)
diff --git a/drivers/pcmcia/pxa2xx_balloon3.c b/drivers/pcmcia/pxa2xx_balloon3.c
index f56d7de..22a75e6 100644
--- a/drivers/pcmcia/pxa2xx_balloon3.c
+++ b/drivers/pcmcia/pxa2xx_balloon3.c
@@ -97,7 +97,7 @@ static void balloon3_pcmcia_socket_state(struct soc_pcmcia_socket *skt,
 static int balloon3_pcmcia_configure_socket(struct soc_pcmcia_socket *skt,
 				       const socket_state_t *state)
 {
-	__raw_writew(BALLOON3_CF_RESET, BALLOON3_CF_CONTROL_REG |
+	__raw_writew(BALLOON3_CF_RESET, BALLOON3_CF_CONTROL_REG +
 			((state->flags & SS_RESET) ?
 			BALLOON3_FPGA_SETnCLR : 0));
 	return 0;
diff --git a/drivers/video/mbx/mbxfb.c b/drivers/video/mbx/mbxfb.c
index afea9ab..6ce3416 100644
--- a/drivers/video/mbx/mbxfb.c
+++ b/drivers/video/mbx/mbxfb.c
@@ -34,7 +34,7 @@
 #include "regs.h"
 #include "reg_bits.h"
 
-static unsigned long virt_base_2700;
+static void __iomem *virt_base_2700;
 
 #define write_reg(val, reg) do { writel((val), (reg)); } while(0)
 
@@ -850,7 +850,7 @@ static int mbxfb_suspend(struct platform_device *dev, pm_message_t state)
 {
 	/* make frame buffer memory enter self-refresh mode */
 	write_reg_dly(LMPWR_MC_PWR_SRM, LMPWR);
-	while (LMPWRSTAT != LMPWRSTAT_MC_PWR_SRM)
+	while (readl(LMPWRSTAT) != LMPWRSTAT_MC_PWR_SRM)
 		; /* empty statement */
 
 	/* reset the device, since it's initial state is 'mostly sleeping' */
@@ -946,7 +946,7 @@ static int __devinit mbxfb_probe(struct platform_device *dev)
 		ret = -EINVAL;
 		goto err3;
 	}
-	virt_base_2700 = (unsigned long)mfbi->reg_virt_addr;
+	virt_base_2700 = mfbi->reg_virt_addr;
 
 	mfbi->fb_virt_addr = ioremap_nocache(mfbi->fb_phys_addr,
 					     res_size(mfbi->fb_req));
-- 
1.7.5.4

