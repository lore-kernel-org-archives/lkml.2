Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142Ab0CXIE3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 04:04:29 -0400
Received: from mailout5.samsung.com ([203.254.224.35]:56173 "EHLO
	mailout5.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818Ab0CXIEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 04:04:22 -0400
Date: Wed, 24 Mar 2010 17:04:54 +0900
From: Kyungmin Park <kmpark@infradead.org>
Subject: [PATCH] Samsung SoCs: OneNAND support
To: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Message-id: <20100324080454.GA24277@july>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
X-OriginalArrivalTime: 24 Mar 2010 08:04:17.0337 (UTC)
 FILETIME=[99D34290:01CACB28]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Samsung SoCs, s5pc6442, s5pc100, and s5pc110 has own OneNAND controller

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
diff --git a/arch/arm/plat-samsung/include/plat/regs-onenand.h b/arch/arm/plat-samsung/include/plat/regs-onenand.h
new file mode 100644
index 0000000..ca8c7e1
--- /dev/null
+++ b/arch/arm/plat-samsung/include/plat/regs-onenand.h
@@ -0,0 +1,75 @@
+/*
+ * linux/arch/arm/plat-samsung/include/plat/regs-onenand.h
+ *
+ *  Copyright (C) 2008-2010 Samsung Electronics
+ *  Kyungmin Park <kyungmin.park@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __SAMSUNG_ONENAND_H__
+#define __SAMSUNG_ONENAND_H__
+
+#include <mach/hardware.h>
+
+/*
+ * OneNAND Controller
+ */
+#define S3C64XX_ONENAND0_BASE	0x70100000
+#define S3C64XX_ONENAND1_BASE	0x70200000
+#define S5PC100_ONENAND_BASE	0xE7100000
+#define S5PC110_ONENAND_BASE	0xB0000000
+
+#ifdef CONFIG_ARCH_S3C64XX
+#define SAMSUNG_ONENAND_BASE	S3C64XX_ONENAND0_BASE
+#endif
+#if defined(CONFIG_ARCH_S5PC1XX) || defined(CONFIG_ARCH_S5PV210)
+#define SAMSUNG_ONENAND_BASE	S5PC100_ONENAND_BASE
+#endif
+
+#define MEM_CFG_OFFSET		0x0000
+#define BURST_LEN_OFFSET	0x0010
+#define MEM_RESET_OFFSET	0x0020
+#define INT_ERR_STAT_OFFSET	0x0030
+#define INT_ERR_MASK_OFFSET	0x0040
+#define INT_ERR_ACK_OFFSET	0x0050
+#define ECC_ERR_STAT_OFFSET	0x0060
+#define MANUFACT_ID_OFFSET	0x0070
+#define DEVICE_ID_OFFSET	0x0080
+#define DATA_BUF_SIZE_OFFSET	0x0090
+#define BOOT_BUF_SIZE_OFFSET	0x00A0
+#define BUF_AMOUNT_OFFSET	0x00B0
+#define TECH_OFFSET		0x00C0
+#define FBA_WIDTH_OFFSET	0x00D0
+#define FPA_WIDTH_OFFSET	0x00E0
+#define FSA_WIDTH_OFFSET	0x00F0
+#define TRANS_SPARE_OFFSET	0x0140
+#define DBS_DFS_WIDTH_OFFSET	0x0160
+#define INT_PIN_ENABLE_OFFSET	0x01A0
+#define ACC_CLOCK_OFFSET	0x01C0
+#define FLASH_VER_ID_OFFSET	0x01F0
+#define FLASH_AUX_CNTRL_OFFSET	0x0300		/* s3c64xx only */
+
+#define ONENAND_MEM_RESET_HOT	0x3
+#define ONENAND_MEM_RESET_COLD	0x2
+#define ONENAND_MEM_RESET_WARM	0x1
+
+#define CACHE_OP_ERR		(1 << 13)
+#define RST_CMP			(1 << 12)
+#define RDY_ACT			(1 << 11)
+#define INT_ACT			(1 << 10)
+#define UNSUP_CMD		(1 << 9)
+#define LOCKED_BLK		(1 << 8)
+#define BLK_RW_CMP		(1 << 7)
+#define ERS_CMP			(1 << 6)
+#define PGM_CMP			(1 << 5)
+#define LOAD_CMP		(1 << 4)
+#define ERS_FAIL		(1 << 3)
+#define PGM_FAIL		(1 << 2)
+#define INT_TO			(1 << 1)
+#define LD_FAIL_ECC_ERR		(1 << 0)
+
+#define TSRF			(1 << 0)
+
+#endif
diff --git a/drivers/mtd/onenand/Kconfig b/drivers/mtd/onenand/Kconfig
index 3a9f157..e0e1ee8 100644
--- a/drivers/mtd/onenand/Kconfig
+++ b/drivers/mtd/onenand/Kconfig
@@ -30,6 +30,14 @@ config MTD_ONENAND_OMAP2
 	  Support for a OneNAND flash device connected to an OMAP2/OMAP3 CPU
 	  via the GPMC memory controller.
 
+config MTD_ONENAND_SAMSUNG
+	tristate "OneNAND on Samsung SOC controller support"
+	depends on MTD_ONENAND && (ARCH_S3C64XX || ARCH_S5PC1XX || ARCH_S5PV210 || ARCH_S5P6442)
+        help
+          Support for a OneNAND flash device connected to an Samsung SOC
+          S3C64XX/S5PC1XX/S5P64XX controller.
+
+
 config MTD_ONENAND_OTP
 	bool "OneNAND OTP Support"
 	select HAVE_MTD_OTP
diff --git a/drivers/mtd/onenand/Makefile b/drivers/mtd/onenand/Makefile
index 64b6cc6..e59bb4a 100644
--- a/drivers/mtd/onenand/Makefile
+++ b/drivers/mtd/onenand/Makefile
@@ -8,6 +8,7 @@ obj-$(CONFIG_MTD_ONENAND)		+= onenand.o
 # Board specific.
 obj-$(CONFIG_MTD_ONENAND_GENERIC)	+= generic.o
 obj-$(CONFIG_MTD_ONENAND_OMAP2)		+= omap2.o
+obj-$(CONFIG_MTD_ONENAND_SAMSUNG)	+= samsung.o
 
 # Simulator
 obj-$(CONFIG_MTD_ONENAND_SIM)		+= onenand_sim.o
diff --git a/drivers/mtd/onenand/samsung.c b/drivers/mtd/onenand/samsung.c
new file mode 100644
index 0000000..de9242b
--- /dev/null
+++ b/drivers/mtd/onenand/samsung.c
@@ -0,0 +1,992 @@
+/*
+ * S3C64XX/S5PC1XX OneNAND driver
+ *
+ *  Copyright (C) 2008-2010 Samsung Electronics
+ *  Kyungmin Park <kyungmin.park@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Implementation:
+ *	Emulate the pseudo BufferRAM
+ */
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/sched.h>
+#include <linux/mtd/mtd.h>
+#include <linux/mtd/onenand.h>
+#include <linux/mtd/partitions.h>
+#include <linux/dma-mapping.h>
+
+#include <plat/regs-onenand.h>
+#include <plat/cpu.h>
+
+//#include <asm/mach/flash.h>
+#include <asm/io.h>
+
+#ifdef SAMSUNG_DEBUG
+#define DPRINTK(format, args...)					\
+do {									\
+	printk("%s[%d]: " format "\n", __func__, __LINE__, ##args);	\
+} while (0)
+#else
+#define DPRINTK(...)			do { } while (0)
+#endif
+
+#define S3C64XX_AHB_ADDR		0x20000000
+#define S5PC100_AHB_ADDR		0xB0000000
+
+#define ONENAND_ERASE_STATUS		0x00
+#define ONENAND_MULTI_ERASE_SET		0x01
+#define ONENAND_ERASE_START		0x03
+#define ONENAND_UNLOCK_START		0x08
+#define ONENAND_UNLOCK_END		0x09
+#define ONENAND_LOCK_START		0x0A
+#define ONENAND_LOCK_END		0x0B
+#define ONENAND_LOCK_TIGHT_START	0x0C
+#define ONENAND_LOCK_TIGHT_END		0x0D
+#define ONENAND_UNLOCK_ALL		0x0E
+#define ONENAND_OTP_ACCESS		0x12
+#define ONENAND_SPARE_ACCESS_ONLY	0x13
+#define ONENAND_MAIN_ACCESS_ONLY	0x14
+#define ONENAND_ERASE_VERIFY		0x15
+#define ONENAND_MAIN_SPARE_ACCESS	0x16
+#define ONENAND_PIPELINE_READ		0x4000
+
+#if defined(CONFIG_ARCH_S3C64XX)
+#define MAP_00				(0x0 << 24)
+#define MAP_01				(0x1 << 24)
+#define MAP_10				(0x2 << 24)
+#define MAP_11				(0x3 << 24)
+#elif defined(CONFIG_ARCH_S5PC1XX) || defined(CONFIG_ARCH_S5PC11X) ||	\
+	defined(CONFIG_ARCH_S5P64XX) || defined(CONFIG_ARCH_S5PV210)
+#define MAP_00				(0x0 << 26)
+#define MAP_01				(0x1 << 26)
+#define MAP_10				(0x2 << 26)
+#define MAP_11				(0x3 << 26)
+#endif
+
+/* The 'addr' is byte address. It makes a 16-bit word */
+#define CMD_MAP_00(addr)		(MAP_00 | ((addr) << 1))
+#define CMD_MAP_01(mem_addr)		(MAP_01 | (mem_addr))
+#define CMD_MAP_10(mem_addr)		(MAP_10 | (mem_addr))
+#define CMD_MAP_11(addr)		(MAP_11 | ((addr) << 2))
+
+/* S5PC110 specific definitions */
+#define S5PC110_DMA_OFFSET		0x600000
+#define S5PC110_DMA_SRC_ADDR		0x400
+#define S5PC110_DMA_SRC_CFG		0x404
+#define S5PC110_DMA_DST_ADDR		0x408
+#define S5PC110_DMA_DST_CFG		0x40C
+#define S5PC110_DMA_TRANS_SIZE		0x414
+#define S5PC110_DMA_TRANS_CMD		0x418
+#define S5PC110_DMA_TRANS_STATUS	0x41C
+#define S5PC110_DMA_TRANS_DIR		0x420
+
+#define S5PC110_DMA_CFG_SINGLE		(0x0 << 16)
+#define S5PC110_DMA_CFG_4BURST		(0x2 << 16)
+#define S5PC110_DMA_CFG_8BURST		(0x3 << 16)
+#define S5PC110_DMA_CFG_16BURST		(0x4 << 16)
+
+#define S5PC110_DMA_CFG_INC		(0x0 << 8)
+#define S5PC110_DMA_CFG_CNT		(0x1 << 8)
+
+#define S5PC110_DMA_CFG_8BIT		(0x0 << 0)
+#define S5PC110_DMA_CFG_16BIT		(0x1 << 0)
+#define S5PC110_DMA_CFG_32BIT		(0x2 << 0)
+
+#define S5PC110_DMA_SRC_CFG_READ	(S5PC110_DMA_CFG_16BURST | \
+					S5PC110_DMA_CFG_INC | \
+					S5PC110_DMA_CFG_16BIT)
+#define S5PC110_DMA_DST_CFG_READ	(S5PC110_DMA_CFG_16BURST | \
+					S5PC110_DMA_CFG_INC | \
+					S5PC110_DMA_CFG_32BIT)
+#define S5PC110_DMA_SRC_CFG_WRITE	(S5PC110_DMA_CFG_16BURST | \
+					S5PC110_DMA_CFG_INC | \
+					S5PC110_DMA_CFG_32BIT)
+#define S5PC110_DMA_DST_CFG_WRITE	(S5PC110_DMA_CFG_16BURST | \
+					S5PC110_DMA_CFG_INC | \
+					S5PC110_DMA_CFG_16BIT)
+
+#define S5PC110_DMA_TRANS_CMD_TDC	(0x1 << 18)
+#define S5PC110_DMA_TRANS_CMD_TEC	(0x1 << 16)
+#define S5PC110_DMA_TRANS_CMD_TR	(0x1 << 0)
+
+#define S5PC110_DMA_TRANS_STATUS_TD	(0x1 << 18)
+#define S5PC110_DMA_TRANS_STATUS_TB	(0x1 << 17)
+#define S5PC110_DMA_TRANS_STATUS_TE	(0x1 << 16)
+
+#define S5PC110_DMA_DIR_READ		0x0
+#define S5PC110_DMA_DIR_WRITE		0x1
+
+struct s3c_onenand {
+	struct mtd_info	*mtd;
+	struct platform_device	*pdev;
+
+	void __iomem	*base;
+	void __iomem	*ahb_addr;
+
+	int		bootram_command;
+
+	void __iomem	*page_buf;
+	void __iomem	*oob_buf;
+
+	unsigned int	(*mem_addr)(int fba, int fpa, int fsa);
+
+
+	void __iomem	*dma_addr;
+	unsigned long	phys_base;
+#ifdef CONFIG_MTD_PARTITIONS
+	struct mtd_partition *parts;
+#endif
+};
+
+static struct s3c_onenand *onenand;
+
+#ifdef CONFIG_MTD_PARTITIONS
+static const char *part_probes[] = { "cmdlinepart", NULL, };
+#endif
+
+static int s3c_read_reg(int offset)
+{
+	return readl(onenand->base + offset);
+}
+
+static void s3c_write_reg(int value, int offset)
+{
+	writel(value, onenand->base + offset);
+}
+
+static int s3c_read_cmd(unsigned int cmd)
+{
+	return readl(onenand->ahb_addr + cmd);
+}
+
+static void s3c_write_cmd(int value, unsigned int cmd)
+{
+	writel(value, onenand->ahb_addr + cmd);
+}
+
+#ifdef SAMSUNG_DEBUG
+static void s3c_dump_reg(void)
+{
+	int i;
+
+	for (i = 0; i < 0x400; i += 0x40) {
+		printk("0x%08X: 0x%08x 0x%08x 0x%08x 0x%08x\n",
+			(unsigned int) onenand->base + i,
+			s3c_read_reg(i), s3c_read_reg(i + 0x10),
+			s3c_read_reg(i + 0x20), s3c_read_reg(i + 0x30));
+	}
+}
+#endif
+
+static unsigned int s3c6400_mem_addr(int fba, int fpa, int fsa)
+{
+	return (fba << 10) | (fpa << 4) | (fsa << 2);
+}
+
+static unsigned int s3c6410_mem_addr(int fba, int fpa, int fsa)
+{
+	return (fba << 12) | (fpa << 6) | (fsa << 4);
+}
+
+static unsigned int s5pc100_mem_addr(int fba, int fpa, int fsa)
+{
+	return (fba << 13) | (fpa << 7) | (fsa << 5);
+}
+
+static void s3c_onenand_reset(void)
+{
+	unsigned long timeout = 0x10000;
+	int stat;
+
+	s3c_write_reg(ONENAND_MEM_RESET_COLD, MEM_RESET_OFFSET);
+	while (1 && timeout--) {
+		stat = s3c_read_reg(INT_ERR_STAT_OFFSET);
+		if (stat & RST_CMP)
+			break;
+	}
+	stat = s3c_read_reg(INT_ERR_STAT_OFFSET);
+	s3c_write_reg(stat, INT_ERR_ACK_OFFSET);
+
+	/* Clear interrupt */
+	s3c_write_reg(0x0, INT_ERR_ACK_OFFSET);
+	/* Clear the ECC status */
+	s3c_write_reg(0x0, ECC_ERR_STAT_OFFSET);
+}
+
+static unsigned short s3c_onenand_readw(void __iomem * addr)
+{
+	struct onenand_chip *this = onenand->mtd->priv;
+	int reg = addr - this->base;
+	int word_addr = reg >> 1;
+	int value;
+
+	/* It's used for probing time */
+	switch (reg) {
+	case ONENAND_REG_MANUFACTURER_ID:
+		return s3c_read_reg(MANUFACT_ID_OFFSET);
+	case ONENAND_REG_DEVICE_ID:
+		return s3c_read_reg(DEVICE_ID_OFFSET);
+	case ONENAND_REG_VERSION_ID:
+		return s3c_read_reg(FLASH_VER_ID_OFFSET);
+	case ONENAND_REG_DATA_BUFFER_SIZE:
+		return s3c_read_reg(DATA_BUF_SIZE_OFFSET);
+	case ONENAND_REG_TECHNOLOGY:
+		return s3c_read_reg(TECH_OFFSET);
+	case ONENAND_REG_SYS_CFG1:
+		return s3c_read_reg(MEM_CFG_OFFSET);
+
+	/* Used at unlock all status */
+	case ONENAND_REG_CTRL_STATUS:
+		return 0;
+
+	case ONENAND_REG_WP_STATUS:
+		return ONENAND_WP_US;
+
+	default:
+		break;
+	}
+
+	/* BootRAM access control */
+	if ((unsigned int) addr < ONENAND_DATARAM && onenand->bootram_command) {
+		if (word_addr == 0)
+			return s3c_read_reg(MANUFACT_ID_OFFSET);
+		if (word_addr == 1)
+			return s3c_read_reg(DEVICE_ID_OFFSET);
+		if (word_addr == 2)
+			return s3c_read_reg(FLASH_VER_ID_OFFSET);
+	}
+
+	value = s3c_read_cmd(CMD_MAP_11(word_addr)) & 0xffff;
+	printk(KERN_INFO "s3c_onenand_readw:  Illegal access"
+		" at reg 0x%x, value 0x%x\n", word_addr, value);
+	return value;
+}
+
+static void s3c_onenand_writew(unsigned short value, void __iomem * addr)
+{
+	struct onenand_chip *this = onenand->mtd->priv;
+	int reg = addr - this->base;
+	int word_addr = reg >> 1;
+
+	/* It's used for probing time */
+	switch (reg) {
+	case ONENAND_REG_SYS_CFG1:
+		s3c_write_reg(value, MEM_CFG_OFFSET);
+		return;
+
+	case ONENAND_REG_START_ADDRESS1:
+	case ONENAND_REG_START_ADDRESS2:
+		return;
+
+	/* Lock/lock-tight/unlock/unlock_all */
+	case ONENAND_REG_START_BLOCK_ADDRESS:
+		return;
+
+	default:
+		break;
+	}
+
+	/* BootRAM access control */
+	if ((unsigned int) addr < ONENAND_DATARAM) {
+		if (value == ONENAND_CMD_READID) {
+			onenand->bootram_command = 1;
+			return;
+		}
+		if (value == ONENAND_CMD_RESET) {
+			s3c_write_reg(ONENAND_MEM_RESET_COLD, MEM_RESET_OFFSET);
+			onenand->bootram_command = 0;
+			return;
+		}
+	}
+
+	printk(KERN_INFO "s3c_onenand_writew: Illegal access"
+		" at reg 0x%x, value 0x%x\n", word_addr, value);
+
+	s3c_write_cmd(value, CMD_MAP_11(word_addr));
+}
+
+static int s3c_onenand_wait(struct mtd_info *mtd, int state)
+{
+	unsigned int flags = INT_ACT;
+	unsigned int stat, ecc;
+	unsigned long timeout;
+
+	switch (state) {
+	case FL_READING:
+		flags |= BLK_RW_CMP | LOAD_CMP;
+		break;
+	case FL_WRITING:
+		flags |= BLK_RW_CMP | PGM_CMP;
+		break;
+	case FL_ERASING:
+		flags |= BLK_RW_CMP | ERS_CMP;
+		break;
+	case FL_LOCKING:
+		flags |= BLK_RW_CMP;
+		break;
+	default:
+		break;
+	}
+
+	/* The 20 msec is enough */
+	timeout = jiffies + msecs_to_jiffies(20);
+	while (time_before(jiffies, timeout)) {
+		stat = s3c_read_reg(INT_ERR_STAT_OFFSET);
+		if (stat & flags)
+			break;
+
+		if (state != FL_READING)
+			cond_resched();
+	}
+	/* To get correct interrupt status in timeout case */
+	stat = s3c_read_reg(INT_ERR_STAT_OFFSET);
+	s3c_write_reg(stat, INT_ERR_ACK_OFFSET);
+
+	/*
+	 * 	
+	 * In the Spec. it checks the controller status first
+	 * However if you get the correct information in case of
+	 * power off recovery (POR) test, it should read ECC status first
+	 */
+	if (stat & LOAD_CMP) {
+		ecc = s3c_read_reg(ECC_ERR_STAT_OFFSET);
+		if (ecc & ONENAND_ECC_4BIT_UNCORRECTABLE) {
+			printk(KERN_INFO "onenand_wait: ECC error = 0x%04x\n", ecc);
+			mtd->ecc_stats.failed++;
+			return -EBADMSG;
+		}
+#if 0
+		} else if (ecc & ONENAND_ECC_1BIT_ALL) {
+			printk(KERN_INFO "onenand_wait: correctable ECC error = 0x%04x\n", ecc);
+			mtd->ecc_stats.corrected++;
+		}
+#endif
+	}
+
+	if (stat & (LOCKED_BLK | ERS_FAIL | PGM_FAIL | LD_FAIL_ECC_ERR)) {
+		printk(KERN_INFO "s3c_onenand_wait: controller error = 0x%04x\n", stat);
+		if (stat & LOCKED_BLK)
+			printk(KERN_INFO "s3c_onenand_wait: it's locked error = 0x%04x\n", stat);
+
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int s3c_onenand_command(struct mtd_info *mtd, int cmd, loff_t addr,
+                           size_t len)
+{
+	struct onenand_chip *this = mtd->priv;
+	unsigned int *m, *s;
+	int fba, fpa, fsa = 0;
+	unsigned int mem_addr;
+	int i, mcount, scount;
+	int index;
+
+	fba = (int) (addr >> this->erase_shift);
+	fpa = (int) (addr >> this->page_shift);
+	fpa &= this->page_mask;
+
+	mem_addr = onenand->mem_addr(fba, fpa, fsa);
+
+	switch (cmd) {
+	case ONENAND_CMD_READ:
+	case ONENAND_CMD_READOOB:
+	case ONENAND_CMD_BUFFERRAM:
+		ONENAND_SET_NEXT_BUFFERRAM(this);
+	default:
+		break;
+	}
+
+	index = ONENAND_CURRENT_BUFFERRAM(this);
+
+	/*
+	 * Emulate Two BufferRAMs and access with 4 bytes pointer
+	 */
+	m = (unsigned int *) onenand->page_buf;
+	s = (unsigned int *) onenand->oob_buf;
+
+	if (index) {
+		m += (this->writesize >> 2);
+		s += (mtd->oobsize >> 2);
+	}
+
+	mcount = mtd->writesize >> 2;
+	scount = mtd->oobsize >> 2;
+
+	switch (cmd) {
+	case ONENAND_CMD_READ:
+		/* Main */
+		for (i = 0; i < mcount; i++)
+			*m++ = s3c_read_cmd(CMD_MAP_01(mem_addr));
+		return 0;
+
+	case ONENAND_CMD_READOOB:
+		s3c_write_reg(TSRF, TRANS_SPARE_OFFSET);
+		/* Main */
+		for (i = 0; i < mcount; i++)
+			*m++ = s3c_read_cmd(CMD_MAP_01(mem_addr));
+
+		/* Spare */
+		for (i = 0; i < scount; i++)
+			*s++ = s3c_read_cmd(CMD_MAP_01(mem_addr));
+
+		s3c_write_reg(0, TRANS_SPARE_OFFSET);
+		return 0;
+
+	case ONENAND_CMD_PROG:
+		/* Main */
+		for (i = 0; i < mcount; i++)
+			s3c_write_cmd(*m++, CMD_MAP_01(mem_addr));
+		return 0;
+
+	case ONENAND_CMD_PROGOOB:
+		s3c_write_reg(TSRF, TRANS_SPARE_OFFSET);
+
+		/* Main - dummy write */
+		for (i = 0; i < mcount; i++)
+			s3c_write_cmd(0xffffffff, CMD_MAP_01(mem_addr));
+
+		/* Spare */
+		for (i = 0; i < scount; i++)
+			s3c_write_cmd(*s++, CMD_MAP_01(mem_addr));
+
+		s3c_write_reg(0, TRANS_SPARE_OFFSET);
+		return 0;
+
+	case ONENAND_CMD_UNLOCK_ALL:
+		s3c_write_cmd(ONENAND_UNLOCK_ALL, CMD_MAP_10(mem_addr));
+		return 0;
+
+	case ONENAND_CMD_ERASE:
+		s3c_write_cmd(ONENAND_ERASE_START, CMD_MAP_10(mem_addr));
+		return 0;
+
+	default:
+		break;
+	}
+
+	return 0;
+}
+
+static unsigned char *s3c_get_bufferram(struct mtd_info *mtd, int area)
+{
+	struct onenand_chip *this = mtd->priv;
+	int index = ONENAND_CURRENT_BUFFERRAM(this);
+	unsigned char *p;
+
+	if (area == ONENAND_DATARAM) {
+		p = (unsigned char *) onenand->page_buf;
+		if (index == 1)
+			p += this->writesize;
+	} else {
+		p = (unsigned char *) onenand->oob_buf;
+		if (index == 1)
+			p += mtd->oobsize;
+	}
+
+	return p;
+}
+
+static int onenand_read_bufferram(struct mtd_info *mtd, int area,
+				  unsigned char *buffer, int offset,
+				  size_t count)
+{
+	unsigned char *p;
+
+	p = s3c_get_bufferram(mtd, area);
+	memcpy(buffer, p + offset, count);
+	return 0;
+}
+
+static int onenand_write_bufferram(struct mtd_info *mtd, int area,
+				   const unsigned char *buffer, int offset,
+				   size_t count)
+{
+	unsigned char *p;
+
+	p = s3c_get_bufferram(mtd, area);
+	memcpy(p + offset, buffer, count);
+	return 0;
+}
+
+static int s5pc110_dma_ops(void *dst, void *src, size_t count, int direction)
+{
+	void __iomem *base = onenand->dma_addr;
+	int status;
+
+	writel(src, base + S5PC110_DMA_SRC_ADDR);
+	writel(dst, base + S5PC110_DMA_DST_ADDR);
+
+	if (direction == S5PC110_DMA_DIR_READ) {
+		writel(S5PC110_DMA_SRC_CFG_READ, base + S5PC110_DMA_SRC_CFG);
+		writel(S5PC110_DMA_DST_CFG_READ, base + S5PC110_DMA_DST_CFG);
+	} else {
+		writel(S5PC110_DMA_SRC_CFG_WRITE, base + S5PC110_DMA_SRC_CFG);
+		writel(S5PC110_DMA_DST_CFG_WRITE, base + S5PC110_DMA_DST_CFG);
+	}
+
+	writel(count, base + S5PC110_DMA_TRANS_SIZE);
+	writel(direction, base + S5PC110_DMA_TRANS_DIR);
+
+	writel(S5PC110_DMA_TRANS_CMD_TR, base + S5PC110_DMA_TRANS_CMD);
+
+	do {
+		status = readl(base + S5PC110_DMA_TRANS_STATUS);
+	} while (!(status & S5PC110_DMA_TRANS_STATUS_TD));
+
+	if (status & S5PC110_DMA_TRANS_STATUS_TE) {
+		writel(S5PC110_DMA_TRANS_CMD_TEC, base + S5PC110_DMA_TRANS_CMD);
+		writel(S5PC110_DMA_TRANS_CMD_TDC, base + S5PC110_DMA_TRANS_CMD);
+		return -EIO;
+	}
+
+	writel(S5PC110_DMA_TRANS_CMD_TDC, base + S5PC110_DMA_TRANS_CMD);
+
+	return 0;
+}
+
+static int s5pc110_read_bufferram(struct mtd_info *mtd, int area,
+		unsigned char *buffer, int offset, size_t count)
+{
+	struct onenand_chip *this = mtd->priv;
+	void __iomem *bufferram;
+	void __iomem *p;
+	void *buf = (void *) buffer;
+	dma_addr_t dma_src, dma_dst;
+	int err;
+
+	p = bufferram = this->base + area;
+	if (ONENAND_CURRENT_BUFFERRAM(this)) {
+		if (area == ONENAND_DATARAM)
+			p += this->writesize;
+		else
+			p += mtd->oobsize;
+	}
+
+	if (offset & 3 || (size_t) buf & 3 || !onenand->dma_addr || count != mtd->writesize)
+		goto normal;
+
+	/* Handle vmalloc address */
+	if (buf >= high_memory) {
+		struct page *page;
+
+		if (((size_t) buf & PAGE_MASK) !=
+		    ((size_t) (buf + count - 1) & PAGE_MASK))
+			goto normal;
+		page = vmalloc_to_page(buf);
+		if (!page)
+			goto normal;
+		buf = page_address(page) + ((size_t) buf & ~PAGE_MASK);
+	}
+
+	/* DMA routine */
+#if 1
+	dma_src = onenand->phys_base + (p - this->base);
+	dma_dst = dma_map_single(&onenand->pdev->dev, buf, count, DMA_FROM_DEVICE);
+	if (dma_mapping_error(&onenand->pdev->dev, dma_dst)) {
+		dev_err(&onenand->pdev->dev, "Couldn't DMA map a %d byte buffer\n",
+			count);
+		goto normal;
+	}
+	err = s5pc110_dma_ops((void *) dma_dst, (void *) dma_src, count, S5PC110_DMA_DIR_READ);
+	dma_unmap_single(&onenand->pdev->dev, dma_dst, count, DMA_FROM_DEVICE);
+#else
+	dma_cache_maint(buf, count, DMA_FROM_DEVICE);
+	err = s5pc110_dma_ops((void *) virt_to_phys(buf),
+		(void *) (S5PC110_ONENAND_BASE | ((p - this->base) & 0x1FFFF)),
+			count, S5PC110_DMA_DIR_READ);
+#endif
+	if (!err)
+		return 0;
+
+normal:
+	if (count != mtd->writesize) {
+		/* Copy the bufferram to memory to prevent unaligned access */
+		memcpy(this->page_buf, bufferram, mtd->writesize);
+		p = this->page_buf + offset;
+	}
+
+	memcpy(buffer, p, count);
+
+	return 0;
+}
+
+static int s3c_onenand_bbt_wait(struct mtd_info *mtd, int state)
+{
+	unsigned int flags = INT_ACT | LOAD_CMP;
+	unsigned int stat;
+	unsigned long timeout;
+
+	/* The 20 msec is enough */
+	timeout = jiffies + msecs_to_jiffies(20);
+	while (time_before(jiffies, timeout)) {
+		stat = s3c_read_reg(INT_ERR_STAT_OFFSET);
+		if (stat & flags)
+			break;
+	}
+	/* To get correct interrupt status in timeout case */
+	stat = s3c_read_reg(INT_ERR_STAT_OFFSET);
+	s3c_write_reg(stat, INT_ERR_ACK_OFFSET);
+
+	if (stat & LD_FAIL_ECC_ERR) {
+		s3c_onenand_reset();
+		return ONENAND_BBT_READ_ERROR;
+	}
+
+	if (stat & LOAD_CMP) {
+		int ecc = s3c_read_reg(ECC_ERR_STAT_OFFSET);
+		if (ecc & ONENAND_ECC_4BIT_UNCORRECTABLE) {
+			s3c_onenand_reset();
+			return ONENAND_BBT_READ_ERROR;
+		}
+	}
+
+	return 0;
+}
+
+static void s3c_onenand_check_lock_status(struct mtd_info *mtd)
+{
+	struct onenand_chip *this = mtd->priv;
+	unsigned int block, end;
+	int tmp;
+
+	end = this->chipsize >> this->erase_shift;
+
+	for (block = 0; block < end; block++) {
+		tmp = s3c_read_cmd(CMD_MAP_01(onenand->mem_addr(block, 0, 0)));
+
+		if (s3c_read_reg(INT_ERR_STAT_OFFSET) & LOCKED_BLK) {
+			printk("block %d is write-protected!\n", block);
+			s3c_write_reg(LOCKED_BLK, INT_ERR_ACK_OFFSET);
+		}
+	}
+}
+
+static void s3c_onenand_do_lock_cmd(struct mtd_info *mtd, loff_t ofs, size_t len, int cmd)
+{
+	struct onenand_chip *this = mtd->priv;
+	int start, end, start_mem_addr, end_mem_addr;
+
+	start = ofs >> this->erase_shift;
+	start_mem_addr = onenand->mem_addr(start, 0, 0);
+	end = start + (len >> this->erase_shift) - 1;
+	end_mem_addr = onenand->mem_addr(end, 0, 0);
+
+	if (cmd == ONENAND_CMD_LOCK) {
+		s3c_write_cmd(ONENAND_LOCK_START, CMD_MAP_10(start_mem_addr));
+		s3c_write_cmd(ONENAND_LOCK_END, CMD_MAP_10(end_mem_addr));
+	} else {
+		s3c_write_cmd(ONENAND_UNLOCK_START, CMD_MAP_10(start_mem_addr));
+		s3c_write_cmd(ONENAND_UNLOCK_END, CMD_MAP_10(end_mem_addr));
+	}
+
+	this->wait(mtd, FL_LOCKING);
+}
+
+static void s3c_unlock_all(struct mtd_info *mtd)
+{
+	struct onenand_chip *this = mtd->priv;
+	loff_t ofs = 0;
+	size_t len = this->chipsize;
+
+	if (this->options & ONENAND_HAS_UNLOCK_ALL) {
+		/* Write unlock command */
+		this->command(mtd, ONENAND_CMD_UNLOCK_ALL, 0, 0);
+
+		/* No need to check return value */
+		this->wait(mtd, FL_LOCKING);
+
+		/* Workaround for all block unlock in DDP */
+		if (!ONENAND_IS_DDP(this)) {
+			s3c_onenand_check_lock_status(mtd);
+			return;
+		}
+
+		/* All blocks on another chip */
+		ofs = this->chipsize >> 1;
+		len = this->chipsize >> 1;
+	}
+
+	s3c_onenand_do_lock_cmd(mtd, ofs, len, ONENAND_CMD_UNLOCK);
+
+	s3c_onenand_check_lock_status(mtd);
+}
+
+static void s3c_onenand_setup(struct mtd_info *mtd)
+{
+	struct onenand_chip *this = mtd->priv;
+
+	onenand->mtd = mtd;
+
+	if (cpu_is_s3c6400())
+		onenand->mem_addr = s3c6400_mem_addr;
+	if (cpu_is_s3c6410())
+		onenand->mem_addr = s3c6410_mem_addr;
+	if (cpu_is_s5pc100())
+		onenand->mem_addr = s5pc100_mem_addr;
+	if (cpu_is_s5pc110() || cpu_is_s5p6442()) {
+		/* Use generic onenand functions */
+		this->read_bufferram = s5pc110_read_bufferram;
+		return;
+	}
+
+	this->read_word = s3c_onenand_readw;
+	this->write_word = s3c_onenand_writew;
+
+	this->wait = s3c_onenand_wait;
+	this->bbt_wait = s3c_onenand_bbt_wait;
+	this->unlock_all = s3c_unlock_all;
+	this->command = s3c_onenand_command;
+
+	this->read_bufferram = onenand_read_bufferram;
+	this->write_bufferram = onenand_write_bufferram;
+}
+
+static int s3c_onenand_probe(struct platform_device *pdev)
+{
+	struct onenand_platform_data *pdata;
+	struct onenand_chip *this;
+	struct mtd_info *mtd;
+	struct resource *r;
+	int size, err;
+	unsigned long ahb_addr = 0, ahb_addr_size = 0;
+	unsigned long onenand_if_ctrl_cfg = 0;
+
+	if (!(cpu_is_s3c64xx() || cpu_is_s5pc1xx() || cpu_is_s5p64xx()))
+		return -ENODEV;
+
+	pdata = pdev->dev.platform_data;
+	/* No need to check pdata. the platform data is optional */
+
+	size = sizeof(struct mtd_info) + sizeof(struct onenand_chip);
+	mtd = kzalloc(size, GFP_KERNEL);
+	if (!mtd) {
+		dev_err(&pdev->dev, "failed to allocate memory\n");
+		return -ENOMEM;
+	}
+
+	onenand = kzalloc(sizeof(struct s3c_onenand), GFP_KERNEL);
+	if (!onenand) {
+		err = -ENOMEM;
+		goto onenand_fail;
+	}
+
+	this = (struct onenand_chip *) &mtd[1];
+	mtd->priv = this;
+	mtd->owner = THIS_MODULE;
+	onenand->pdev = pdev;
+
+	s3c_onenand_setup(mtd);
+
+	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!r) {
+		dev_err(&pdev->dev, "no resource defined\n");
+		return -ENXIO;
+		goto resource_failed;
+	}
+
+	r = request_mem_region(r->start, resource_size(r), pdev->name);
+	if (!r) {
+		dev_err(&pdev->dev, "failed to request memory resource\n");
+		err = -EBUSY;
+		goto request_failed;
+	}
+
+	onenand->base = ioremap(r->start, resource_size(r));
+	if (!onenand->base) {
+		err = -EFAULT;
+		goto ioremap_failed;
+	}
+	/* Set onenand_chip also */
+	this->base = onenand->base;
+
+	if (cpu_is_s3c64xx()) {
+		ahb_addr = S3C64XX_AHB_ADDR;
+		ahb_addr_size = SZ_64M;
+	} else if (cpu_is_s5pc100()) {
+		ahb_addr = S5PC100_AHB_ADDR;
+		ahb_addr_size = SZ_256M - SZ_32M;
+	} else if (cpu_is_s5pc110() || cpu_is_s5p6442()) {
+		onenand->dma_addr = ioremap(r->start + S5PC110_DMA_OFFSET, 0x800);
+		if (!onenand->dma_addr)
+			onenand->dma_addr = 0;
+		onenand->phys_base = S5PC110_ONENAND_BASE;
+	}
+
+        /*
+	 * We only used as followings
+	 * S5PC100                              S3C64XX
+	 * MAP_01 0xB4000000 ~ 0xB4FFFFFF       0x21000000 ~ 0x21FFFFFF
+	 * MAP_10 0xB8000000 ~ 0xB8FFFFFF       0x22000000 ~ 0x22FFFFFF
+	 * MAP_11 0xBC000000 ~ 0xBCFFFFFF       0x23000000 ~ 0x23FFFFFF
+	 */
+	if (ahb_addr) {
+		/* We don't use last 32MiB */
+		onenand->ahb_addr = ioremap(ahb_addr, ahb_addr_size);
+		if (!onenand->ahb_addr) {
+			err = -EINVAL;
+			goto ahb_failed;
+		}
+
+		/* Allocate 4KiB BufferRAM */
+		onenand->page_buf = kzalloc(SZ_4K * sizeof(char), GFP_KERNEL);
+		if (!onenand->page_buf) {
+			err = -ENOMEM;
+			goto page_buf_fail;
+		}
+
+		/* Allocate 128 SpareRAM */
+		onenand->oob_buf = kzalloc(128 * sizeof(char), GFP_KERNEL);
+		if (!onenand->oob_buf) {
+			err = -ENOMEM;
+			goto oob_buf_fail;
+		}
+	}
+
+#ifdef CONFIG_MTD_RUNTIME_BADBLOCK_CHECK
+	/* Use runtime badblock check */
+	this->options |= ONENAND_RUNTIME_BADBLOCK_CHECK;
+#endif
+
+	if (cpu_is_s5pc110() || cpu_is_s5p6442()) {
+		onenand_if_ctrl_cfg = readl(onenand->dma_addr + 0x100);
+		if ((onenand_if_ctrl_cfg & ONENAND_SYS_CFG1_SYNC_WRITE) &&
+		    onenand->dma_addr) {
+			writel(onenand_if_ctrl_cfg & ~ONENAND_SYS_CFG1_SYNC_WRITE, onenand->dma_addr + 0x100);
+		} else
+			onenand_if_ctrl_cfg = 0;
+	}
+
+	if (onenand_scan(mtd, 1)) {
+		err = -EFAULT;
+		goto scan_failed;
+	}
+
+	if (cpu_is_s5pc110() || cpu_is_s5p6442()) {
+		if (onenand_if_ctrl_cfg && onenand->dma_addr)
+			writel(onenand_if_ctrl_cfg, onenand->dma_addr + 0x100);
+	}
+
+	if (ahb_addr) {
+		/* S3C don't handle subpage write */
+		mtd->subpage_sft = 0;
+		this->subpagesize = mtd->writesize;
+	}
+
+	if (s3c_read_reg(MEM_CFG_OFFSET) & ONENAND_SYS_CFG1_SYNC_READ)
+		printk(KERN_INFO "OneNAND Sync. Burst Read enabled\n");
+
+#ifdef CONFIG_MTD_PARTITIONS
+	err = parse_mtd_partitions(mtd, part_probes, &onenand->parts, 0);
+	if (err > 0)
+		add_mtd_partitions(mtd, onenand->parts, err);
+	else if (err <= 0 && pdata && pdata->parts)
+		add_mtd_partitions(mtd, pdata->parts, pdata->nr_parts);
+	else
+#endif
+		err = add_mtd_device(mtd);
+
+	platform_set_drvdata(pdev, mtd);
+	return 0;
+scan_failed:
+	kfree(onenand->oob_buf);
+oob_buf_fail:
+	kfree(onenand->page_buf);
+page_buf_fail:
+	if (onenand->ahb_addr)
+		iounmap(onenand->ahb_addr);
+ahb_failed:
+	if (onenand->dma_addr)
+		iounmap(onenand->dma_addr);
+	iounmap(onenand->base);
+ioremap_failed:
+	release_mem_region(r->start, resource_size(r));
+request_failed:
+resource_failed:
+	kfree(onenand);
+onenand_fail:
+	kfree(mtd);
+	return err;
+}
+
+static int __devexit s3c_onenand_remove(struct platform_device *pdev)
+{
+	struct mtd_info *mtd = platform_get_drvdata(pdev);
+
+	onenand_release(mtd);
+	if (onenand->ahb_addr)
+		iounmap(onenand->ahb_addr);
+	if (onenand->dma_addr)
+		iounmap(onenand->dma_addr);
+	iounmap(onenand->base);
+	platform_set_drvdata(pdev, NULL);
+	kfree(onenand->oob_buf);
+	kfree(onenand->page_buf);
+	kfree(onenand);
+	kfree(mtd);
+	return 0;
+}
+
+static int s3c_pm_ops_suspend(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct mtd_info *mtd = platform_get_drvdata(pdev);
+	struct onenand_chip *this = mtd->priv;
+
+	this->wait(mtd, FL_PM_SUSPENDED);
+	return mtd->suspend(mtd);
+}
+
+static  int s3c_pm_ops_resume(struct device *dev)
+{
+	struct platform_device *pdev = to_platform_device(dev);
+	struct mtd_info *mtd = platform_get_drvdata(pdev);
+	struct onenand_chip *this = mtd->priv;
+
+	mtd->resume(mtd);
+	this->unlock_all(mtd);
+	return 0;
+}
+
+static struct dev_pm_ops s3c_pm_ops = {
+	.suspend	= s3c_pm_ops_suspend,
+	.resume		= s3c_pm_ops_resume,
+};
+
+static struct platform_driver s3c_onenand_driver = {
+	.driver         = {
+		.name           = "samsung-onenand",
+		.pm		= &s3c_pm_ops,
+	},
+	.probe          = s3c_onenand_probe,
+	.remove         = __devexit_p(s3c_onenand_remove),
+};
+
+static int __init s3c_onenand_init(void)
+{
+	return platform_driver_register(&s3c_onenand_driver);
+}
+
+static void __exit s3c_onenand_exit(void)
+{
+	platform_driver_unregister(&s3c_onenand_driver);
+}
+
+#ifdef CONFIG_FAST_RESUME
+beforeresume_initcall(s3c_onenand_init);
+#else
+module_init(s3c_onenand_init);
+#endif
+module_exit(s3c_onenand_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Kyungmin Park <kyungmin.park@samsung.com>");
+MODULE_DESCRIPTION("Samsung S3C64XX/S5PC1XX OneNAND controller support");
+MODULE_ALIAS("platform:samsung-onenand");
