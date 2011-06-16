Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755651Ab1FPHss (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:48:48 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34379 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596Ab1FPHsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:48:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=XzdVD8rkr4olI/+kSLij4pOygCl9O6s/Z8vZ4oN9y1QNKzVabKiY0pCTuvAUjRleIR
         FhJDo/7m8L0uGgxltRwuHAsRdVrQYZDXFdzicQ5EPhFCJCoqojpS6yn1UWk7rujD34n+
         fcsl56QhJr5Da2UA++R1ngdfPQMxfwde9TAWA=
Date: Thu, 16 Jun 2011 15:48:29 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Andres Salomon <dilinger@queued.net>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [Patch] staging: remove obsoleted CS5535/CS5536 GPIO driver
Message-ID: <20110616074720.GA25350@cr0.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is scheduled to be removed.

Cc: Andres Salomon <dilinger@queued.net>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---
 Documentation/feature-removal-schedule.txt |   14 --
 drivers/staging/Kconfig                    |    2 -
 drivers/staging/cs5535_gpio/Kconfig        |   11 --
 drivers/staging/cs5535_gpio/Makefile       |    1 -
 drivers/staging/cs5535_gpio/TODO           |    6 -
 drivers/staging/cs5535_gpio/cs5535_gpio.c  |  260 ----------------------------
 6 files changed, 0 insertions(+), 294 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 72e2384..6257186 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -193,20 +193,6 @@ Why:	/proc/<pid>/oom_adj allows userspace to influence the oom killer's
 
 ---------------------------
 
-What:	CS5535/CS5536 obsolete GPIO driver
-When:	June 2011
-Files:	drivers/staging/cs5535_gpio/*
-Check:	drivers/staging/cs5535_gpio/cs5535_gpio.c
-Why:	A newer driver replaces this; it is drivers/gpio/cs5535-gpio.c, and
-	integrates with the Linux GPIO subsystem.  The old driver has been
-	moved to staging, and will be removed altogether around 2.6.40.
-	Please test the new driver, and ensure that the functionality you
-	need and any bugfixes from the old driver are available in the new
-	one.
-Who:	Andres Salomon <dilinger@queued.net>
-
---------------------------
-
 What:	remove EXPORT_SYMBOL(kernel_thread)
 When:	August 2006
 Files:	arch/*/kernel/*_ksyms.c
diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index 196284d..a85c11a 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -100,8 +100,6 @@ source "drivers/staging/sep/Kconfig"
 
 source "drivers/staging/iio/Kconfig"
 
-source "drivers/staging/cs5535_gpio/Kconfig"
-
 source "drivers/staging/zram/Kconfig"
 
 source "drivers/staging/zcache/Kconfig"
diff --git a/drivers/staging/cs5535_gpio/Kconfig b/drivers/staging/cs5535_gpio/Kconfig
deleted file mode 100644
index a1b3a8d..0000000
--- a/drivers/staging/cs5535_gpio/Kconfig
+++ /dev/null
@@ -1,11 +0,0 @@
-config CS5535_GPIO
-	tristate "AMD CS5535/CS5536 GPIO (Geode Companion Device)"
-	depends on X86_32
-	help
-	  Note: this driver is DEPRECATED.  Please use the cs5535-gpio module
-	  in the GPIO section instead (CONFIG_GPIO_CS5535).
-
-	  Give userspace access to the GPIO pins on the AMD CS5535 and
-	  CS5536 Geode companion devices.
-
-	  If compiled as a module, it will be called cs5535_gpio.
diff --git a/drivers/staging/cs5535_gpio/Makefile b/drivers/staging/cs5535_gpio/Makefile
deleted file mode 100644
index d67c4b8..0000000
--- a/drivers/staging/cs5535_gpio/Makefile
+++ /dev/null
@@ -1 +0,0 @@
-obj-$(CONFIG_CS5535_GPIO)	+= cs5535_gpio.o
diff --git a/drivers/staging/cs5535_gpio/TODO b/drivers/staging/cs5535_gpio/TODO
deleted file mode 100644
index 98d1cd1..0000000
--- a/drivers/staging/cs5535_gpio/TODO
+++ /dev/null
@@ -1,6 +0,0 @@
-This is an obsolete driver for some the CS5535 and CS5536 southbridge GPIOs.
-It has been replaced by a driver that makes use of the Linux GPIO subsystem.
-Please switch to that driver, and let dilinger@queued.net know if there's
-anything missing from the new driver.
-
-This driver is scheduled for removal in 2.6.40.
diff --git a/drivers/staging/cs5535_gpio/cs5535_gpio.c b/drivers/staging/cs5535_gpio/cs5535_gpio.c
deleted file mode 100644
index b25f9d1..0000000
--- a/drivers/staging/cs5535_gpio/cs5535_gpio.c
+++ /dev/null
@@ -1,260 +0,0 @@
-/*
- * AMD CS5535/CS5536 GPIO driver.
- * Allows a user space process to play with the GPIO pins.
- *
- * Copyright (c) 2005 Ben Gardner <bgardner@wabtec.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the smems of the GNU General Public License as published by
- * the Free Software Foundation; version 2 of the License.
- */
-
-#include <linux/fs.h>
-#include <linux/module.h>
-#include <linux/errno.h>
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/cdev.h>
-#include <linux/ioport.h>
-#include <linux/pci.h>
-
-#include <asm/uaccess.h>
-#include <asm/io.h>
-
-
-#define NAME			"cs5535_gpio"
-
-MODULE_AUTHOR("Ben Gardner <bgardner@wabtec.com>");
-MODULE_DESCRIPTION("AMD CS5535/CS5536 GPIO Pin Driver");
-MODULE_LICENSE("GPL");
-
-static int major;
-module_param(major, int, 0);
-MODULE_PARM_DESC(major, "Major device number");
-
-static ulong mask;
-module_param(mask, ulong, 0);
-MODULE_PARM_DESC(mask, "GPIO channel mask");
-
-#define MSR_LBAR_GPIO		0x5140000C
-
-static u32 gpio_base;
-
-static struct pci_device_id divil_pci[] = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_NS,  PCI_DEVICE_ID_NS_CS5535_ISA) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_CS5536_ISA) },
-	{ } /* NULL entry */
-};
-MODULE_DEVICE_TABLE(pci, divil_pci);
-
-static struct cdev cs5535_gpio_cdev;
-
-/* reserve 32 entries even though some aren't usable */
-#define CS5535_GPIO_COUNT	32
-
-/* IO block size */
-#define CS5535_GPIO_SIZE	256
-
-struct gpio_regmap {
-	u32	rd_offset;
-	u32	wr_offset;
-	char	on;
-	char	off;
-};
-static struct gpio_regmap rm[] =
-{
-	{ 0x30, 0x00, '1', '0' },	/* GPIOx_READ_BACK / GPIOx_OUT_VAL */
-	{ 0x20, 0x20, 'I', 'i' },	/* GPIOx_IN_EN */
-	{ 0x04, 0x04, 'O', 'o' },	/* GPIOx_OUT_EN */
-	{ 0x08, 0x08, 't', 'T' },	/* GPIOx_OUT_OD_EN */
-	{ 0x18, 0x18, 'P', 'p' },	/* GPIOx_OUT_PU_EN */
-	{ 0x1c, 0x1c, 'D', 'd' },	/* GPIOx_OUT_PD_EN */
-};
-
-
-/**
- * Gets the register offset for the GPIO bank.
- * Low (0-15) starts at 0x00, high (16-31) starts at 0x80
- */
-static inline u32 cs5535_lowhigh_base(int reg)
-{
-	return (reg & 0x10) << 3;
-}
-
-static ssize_t cs5535_gpio_write(struct file *file, const char __user *data,
-				 size_t len, loff_t *ppos)
-{
-	u32	m = iminor(file->f_path.dentry->d_inode);
-	int	i, j;
-	u32	base = gpio_base + cs5535_lowhigh_base(m);
-	u32	m0, m1;
-	char	c;
-
-	/**
-	 * Creates the mask for atomic bit programming.
-	 * The high 16 bits and the low 16 bits are used to set the mask.
-	 * For example, GPIO 15 maps to 31,15: 0,1 => On; 1,0=> Off
-	 */
-	m1 = 1 << (m & 0x0F);
-	m0 = m1 << 16;
-
-	for (i = 0; i < len; ++i) {
-		if (get_user(c, data+i))
-			return -EFAULT;
-
-		for (j = 0; j < ARRAY_SIZE(rm); j++) {
-			if (c == rm[j].on) {
-				outl(m1, base + rm[j].wr_offset);
-				/* If enabling output, turn off AUX 1 and AUX 2 */
-				if (c == 'O') {
-					outl(m0, base + 0x10);
-					outl(m0, base + 0x14);
-				}
-				break;
-			} else if (c == rm[j].off) {
-				outl(m0, base + rm[j].wr_offset);
-				break;
-			}
-		}
-	}
-	*ppos = 0;
-	return len;
-}
-
-static ssize_t cs5535_gpio_read(struct file *file, char __user *buf,
-				size_t len, loff_t *ppos)
-{
-	u32	m = iminor(file->f_path.dentry->d_inode);
-	u32	base = gpio_base + cs5535_lowhigh_base(m);
-	int	rd_bit = 1 << (m & 0x0f);
-	int	i;
-	char	ch;
-	ssize_t	count = 0;
-
-	if (*ppos >= ARRAY_SIZE(rm))
-		return 0;
-
-	for (i = *ppos; (i < (*ppos + len)) && (i < ARRAY_SIZE(rm)); i++) {
-		ch = (inl(base + rm[i].rd_offset) & rd_bit) ?
-		     rm[i].on : rm[i].off;
-
-		if (put_user(ch, buf+count))
-			return -EFAULT;
-
-		count++;
-	}
-
-	/* add a line-feed if there is room */
-	if ((i == ARRAY_SIZE(rm)) && (count < len)) {
-		if (put_user('\n', buf + count))
-			return -EFAULT;
-		count++;
-	}
-
-	*ppos += count;
-	return count;
-}
-
-static int cs5535_gpio_open(struct inode *inode, struct file *file)
-{
-	u32 m = iminor(inode);
-
-	/* the mask says which pins are usable by this driver */
-	if ((mask & (1 << m)) == 0)
-		return -EINVAL;
-
-	return nonseekable_open(inode, file);
-}
-
-static const struct file_operations cs5535_gpio_fops = {
-	.owner	= THIS_MODULE,
-	.write	= cs5535_gpio_write,
-	.read	= cs5535_gpio_read,
-	.open	= cs5535_gpio_open,
-	.llseek = no_llseek,
-};
-
-static int __init cs5535_gpio_init(void)
-{
-	dev_t	dev_id;
-	u32	low, hi;
-	int	retval;
-
-	if (pci_dev_present(divil_pci) == 0) {
-		printk(KERN_WARNING NAME ": DIVIL not found\n");
-		return -ENODEV;
-	}
-
-	/* Grab the GPIO I/O range */
-	rdmsr(MSR_LBAR_GPIO, low, hi);
-
-	/* Check the mask and whether GPIO is enabled (sanity check) */
-	if (hi != 0x0000f001) {
-		printk(KERN_WARNING NAME ": GPIO not enabled\n");
-		return -ENODEV;
-	}
-
-	/* Mask off the IO base address */
-	gpio_base = low & 0x0000ff00;
-
-	/**
-	 * Some GPIO pins
-	 *  31-29,23 : reserved (always mask out)
-	 *  28       : Power Button
-	 *  26       : PME#
-	 *  22-16    : LPC
-	 *  14,15    : SMBus
-	 *  9,8      : UART1
-	 *  7        : PCI INTB
-	 *  3,4      : UART2/DDC
-	 *  2        : IDE_IRQ0
-	 *  0        : PCI INTA
-	 *
-	 * If a mask was not specified, be conservative and only allow:
-	 *  1,2,5,6,10-13,24,25,27
-	 */
-	if (mask != 0)
-		mask &= 0x1f7fffff;
-	else
-		mask = 0x0b003c66;
-
-	if (!request_region(gpio_base, CS5535_GPIO_SIZE, NAME)) {
-		printk(KERN_ERR NAME ": can't allocate I/O for GPIO\n");
-		return -ENODEV;
-	}
-
-	if (major) {
-		dev_id = MKDEV(major, 0);
-		retval = register_chrdev_region(dev_id, CS5535_GPIO_COUNT,
-						NAME);
-	} else {
-		retval = alloc_chrdev_region(&dev_id, 0, CS5535_GPIO_COUNT,
-					     NAME);
-		major = MAJOR(dev_id);
-	}
-
-	if (retval) {
-		release_region(gpio_base, CS5535_GPIO_SIZE);
-		return -1;
-	}
-
-	printk(KERN_DEBUG NAME ": base=%#x mask=%#lx major=%d\n",
-	       gpio_base, mask, major);
-
-	cdev_init(&cs5535_gpio_cdev, &cs5535_gpio_fops);
-	cdev_add(&cs5535_gpio_cdev, dev_id, CS5535_GPIO_COUNT);
-
-	return 0;
-}
-
-static void __exit cs5535_gpio_cleanup(void)
-{
-	dev_t dev_id = MKDEV(major, 0);
-
-	cdev_del(&cs5535_gpio_cdev);
-	unregister_chrdev_region(dev_id, CS5535_GPIO_COUNT);
-	release_region(gpio_base, CS5535_GPIO_SIZE);
-}
-
-module_init(cs5535_gpio_init);
-module_exit(cs5535_gpio_cleanup);
