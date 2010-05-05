Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758907Ab0EEWgL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 18:36:11 -0400
Received: from tex.lwn.net ([70.33.254.29]:50640 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755000Ab0EEWfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 18:35:08 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-kernel@vger.kernel.org
Cc: Harald Welte <laforge@gnumonks.org>, linux-fbdev@vger.kernel.org,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn,
       =?UTF-8?q?Bruno=20Pr=C3=A9mont?= <bonbons@linux-vserver.org>,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
       linux-media@vger.kernel.org
Subject: [PATCH 4/5] viafb: move some include files to include/linux
Date: Wed,  5 May 2010 16:34:43 -0600
Message-Id: <1273098884-21848-5-git-send-email-corbet@lwn.net>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1273098884-21848-1-git-send-email-corbet@lwn.net>
References: <1273098884-21848-1-git-send-email-corbet@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are the files which should be available to subdevices compiled
outside of drivers/video/via.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 drivers/video/via/accel.c           |    2 +-
 drivers/video/via/dvi.c             |    4 +-
 drivers/video/via/hw.c              |    3 +-
 drivers/video/via/lcd.c             |    4 +-
 drivers/video/via/via-core.c        |    6 +-
 drivers/video/via/via-core.h        |  219 -----------------------------------
 drivers/video/via/via-gpio.c        |    4 +-
 drivers/video/via/via-gpio.h        |   14 ---
 drivers/video/via/via_i2c.c         |    4 +-
 drivers/video/via/via_i2c.h         |   42 -------
 drivers/video/via/via_modesetting.c |    2 +-
 drivers/video/via/via_utility.c     |    2 +-
 drivers/video/via/viafbdev.c        |    4 +-
 drivers/video/via/viamode.c         |    2 +-
 drivers/video/via/vt1636.c          |    4 +-
 include/linux/via-core.h            |  219 +++++++++++++++++++++++++++++++++++
 include/linux/via-gpio.h            |   14 +++
 include/linux/via_i2c.h             |   42 +++++++
 18 files changed, 296 insertions(+), 295 deletions(-)
 delete mode 100644 drivers/video/via/via-core.h
 delete mode 100644 drivers/video/via/via-gpio.h
 delete mode 100644 drivers/video/via/via_i2c.h
 create mode 100644 include/linux/via-core.h
 create mode 100644 include/linux/via-gpio.h
 create mode 100644 include/linux/via_i2c.h

diff --git a/drivers/video/via/accel.c b/drivers/video/via/accel.c
index 189aba4..e44893e 100644
--- a/drivers/video/via/accel.c
+++ b/drivers/video/via/accel.c
@@ -18,7 +18,7 @@
  * Foundation, Inc.,
  * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
-#include "via-core.h"
+#include <linux/via-core.h>
 #include "global.h"
 
 /*
diff --git a/drivers/video/via/dvi.c b/drivers/video/via/dvi.c
index 6271b76..39b040b 100644
--- a/drivers/video/via/dvi.c
+++ b/drivers/video/via/dvi.c
@@ -18,8 +18,8 @@
  * Foundation, Inc.,
  * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
-#include "via-core.h"
-#include "via_i2c.h"
+#include <linux/via-core.h>
+#include <linux/via_i2c.h>
 #include "global.h"
 
 static void tmds_register_write(int index, u8 data);
diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
index e356fe8..b996803 100644
--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -18,7 +18,8 @@
  * Foundation, Inc.,
  * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
-#include "via-core.h"
+
+#include <linux/via-core.h>
 #include "global.h"
 
 static struct pll_map pll_value[] = {
diff --git a/drivers/video/via/lcd.c b/drivers/video/via/lcd.c
index 04eec31..2ab0f15 100644
--- a/drivers/video/via/lcd.c
+++ b/drivers/video/via/lcd.c
@@ -18,8 +18,8 @@
  * Foundation, Inc.,
  * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
-#include "via-core.h"
-#include "via_i2c.h"
+#include <linux/via-core.h>
+#include <linux/via_i2c.h>
 #include "global.h"
 #include "lcdtbl.h"
 
diff --git a/drivers/video/via/via-core.c b/drivers/video/via/via-core.c
index c7d37a0..15fcaab 100644
--- a/drivers/video/via/via-core.c
+++ b/drivers/video/via/via-core.c
@@ -7,9 +7,9 @@
 /*
  * Core code for the Via multifunction framebuffer device.
  */
-#include "via-core.h"
-#include "via_i2c.h"
-#include "via-gpio.h"
+#include <linux/via-core.h>
+#include <linux/via_i2c.h>
+#include <linux/via-gpio.h>
 #include "global.h"
 
 #include <linux/module.h>
diff --git a/drivers/video/via/via-core.h b/drivers/video/via/via-core.h
deleted file mode 100644
index 7ffb521..0000000
--- a/drivers/video/via/via-core.h
+++ /dev/null
@@ -1,219 +0,0 @@
-/*
- * Copyright 1998-2009 VIA Technologies, Inc. All Rights Reserved.
- * Copyright 2001-2008 S3 Graphics, Inc. All Rights Reserved.
- * Copyright 2009-2010 Jonathan Corbet <corbet@lwn.net>
- * Copyright 2010 Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public
- * License as published by the Free Software Foundation;
- * either version 2, or (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTIES OR REPRESENTATIONS; without even
- * the implied warranty of MERCHANTABILITY or FITNESS FOR
- * A PARTICULAR PURPOSE.See the GNU General Public License
- * for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc.,
- * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
- */
-
-#ifndef __VIA_CORE_H__
-#define __VIA_CORE_H__
-#include <linux/types.h>
-#include <linux/io.h>
-#include <linux/spinlock.h>
-#include <linux/pci.h>
-
-/*
- * A description of each known serial I2C/GPIO port.
- */
-enum via_port_type {
-	VIA_PORT_NONE = 0,
-	VIA_PORT_I2C,
-	VIA_PORT_GPIO,
-};
-
-enum via_port_mode {
-	VIA_MODE_OFF = 0,
-	VIA_MODE_I2C,		/* Used as I2C port */
-	VIA_MODE_GPIO,	/* Two GPIO ports */
-};
-
-enum viafb_i2c_adap {
-	VIA_PORT_26 = 0,
-	VIA_PORT_31,
-	VIA_PORT_25,
-	VIA_PORT_2C,
-	VIA_PORT_3D,
-};
-#define VIAFB_NUM_PORTS 5
-
-struct via_port_cfg {
-	enum via_port_type	type;
-	enum via_port_mode	mode;
-	u16			io_port;
-	u8			ioport_index;
-};
-
-/*
- * This is the global viafb "device" containing stuff needed by
- * all subdevs.
- */
-struct viafb_dev {
-	struct pci_dev *pdev;
-	int chip_type;
-	struct via_port_cfg *port_cfg;
-	/*
-	 * Spinlock for access to device registers.  Not yet
-	 * globally used.
-	 */
-	spinlock_t reg_lock;
-	/*
-	 * The framebuffer MMIO region.  Little, if anything, touches
-	 * this memory directly, and certainly nothing outside of the
-	 * framebuffer device itself.  We *do* have to be able to allocate
-	 * chunks of this memory for other devices, though.
-	 */
-	unsigned long fbmem_start;
-	long fbmem_len;
-	void __iomem *fbmem;
-#if defined(CONFIG_FB_VIA_CAMERA) || defined(CONFIG_FB_VIA_CAMERA_MODULE)
-	long camera_fbmem_offset;
-	long camera_fbmem_size;
-#endif
-	/*
-	 * The MMIO region for device registers.
-	 */
-	unsigned long engine_start;
-	unsigned long engine_len;
-	void __iomem *engine_mmio;
-
-};
-
-/*
- * Interrupt management.
- */
-
-void viafb_irq_enable(u32 mask);
-void viafb_irq_disable(u32 mask);
-
-/*
- * The global interrupt control register and its bits.
- */
-#define VDE_INTERRUPT	0x200	/* Video interrupt flags/masks */
-#define   VDE_I_DVISENSE  0x00000001  /* DVI sense int status */
-#define   VDE_I_VBLANK    0x00000002  /* Vertical blank status */
-#define   VDE_I_MCCFI	  0x00000004  /* MCE compl. frame int status */
-#define   VDE_I_VSYNC	  0x00000008  /* VGA VSYNC int status */
-#define   VDE_I_DMA0DDONE 0x00000010  /* DMA 0 descr done */
-#define   VDE_I_DMA0TDONE 0x00000020  /* DMA 0 transfer done */
-#define   VDE_I_DMA1DDONE 0x00000040  /* DMA 1 descr done */
-#define   VDE_I_DMA1TDONE 0x00000080  /* DMA 1 transfer done */
-#define   VDE_I_C1AV      0x00000100  /* Cap Eng 1 act vid end */
-#define   VDE_I_HQV0	  0x00000200  /* First HQV engine */
-#define   VDE_I_HQV1      0x00000400  /* Second HQV engine */
-#define   VDE_I_HQV1EN	  0x00000800  /* Second HQV engine enable */
-#define   VDE_I_C0AV      0x00001000  /* Cap Eng 0 act vid end */
-#define   VDE_I_C0VBI     0x00002000  /* Cap Eng 0 VBI end */
-#define   VDE_I_C1VBI     0x00004000  /* Cap Eng 1 VBI end */
-#define   VDE_I_VSYNC2    0x00008000  /* Sec. Disp. VSYNC */
-#define   VDE_I_DVISNSEN  0x00010000  /* DVI sense enable */
-#define   VDE_I_VSYNC2EN  0x00020000  /* Sec Disp VSYNC enable */
-#define   VDE_I_MCCFIEN	  0x00040000  /* MC comp frame int mask enable */
-#define   VDE_I_VSYNCEN   0x00080000  /* VSYNC enable */
-#define   VDE_I_DMA0DDEN  0x00100000  /* DMA 0 descr done enable */
-#define   VDE_I_DMA0TDEN  0x00200000  /* DMA 0 trans done enable */
-#define   VDE_I_DMA1DDEN  0x00400000  /* DMA 1 descr done enable */
-#define   VDE_I_DMA1TDEN  0x00800000  /* DMA 1 trans done enable */
-#define   VDE_I_C1AVEN    0x01000000  /* cap 1 act vid end enable */
-#define   VDE_I_HQV0EN	  0x02000000  /* First hqv engine enable */
-#define   VDE_I_C1VBIEN	  0x04000000  /* Cap 1 VBI end enable */
-#define   VDE_I_LVDSSI    0x08000000  /* LVDS sense interrupt */
-#define   VDE_I_C0AVEN    0x10000000  /* Cap 0 act vid end enable */
-#define   VDE_I_C0VBIEN   0x20000000  /* Cap 0 VBI end enable */
-#define   VDE_I_LVDSSIEN  0x40000000  /* LVDS Sense enable */
-#define   VDE_I_ENABLE	  0x80000000  /* Global interrupt enable */
-
-/*
- * DMA management.
- */
-int viafb_request_dma(void);
-void viafb_release_dma(void);
-/* void viafb_dma_copy_out(unsigned int offset, dma_addr_t paddr, int len); */
-int viafb_dma_copy_out_sg(unsigned int offset, struct scatterlist *sg, int nsg);
-
-/*
- * DMA Controller registers.
- */
-#define VDMA_MR0	0xe00		/* Mod reg 0 */
-#define   VDMA_MR_CHAIN   0x01		/* Chaining mode */
-#define   VDMA_MR_TDIE    0x02		/* Transfer done int enable */
-#define VDMA_CSR0	0xe04		/* Control/status */
-#define	  VDMA_C_ENABLE	  0x01		  /* DMA Enable */
-#define	  VDMA_C_START	  0x02		  /* Start a transfer */
-#define	  VDMA_C_ABORT	  0x04		  /* Abort a transfer */
-#define	  VDMA_C_DONE	  0x08		  /* Transfer is done */
-#define VDMA_MARL0	0xe20		/* Mem addr low */
-#define VDMA_MARH0	0xe24		/* Mem addr high */
-#define VDMA_DAR0	0xe28		/* Device address */
-#define VDMA_DQWCR0	0xe2c		/* Count (16-byte) */
-#define VDMA_TMR0	0xe30		/* Tile mode reg */
-#define VDMA_DPRL0	0xe34		/* Not sure */
-#define	  VDMA_DPR_IN	  0x08		/* Inbound transfer to FB */
-#define VDMA_DPRH0	0xe38
-#define VDMA_PMR0	(0xe00 + 0x134) /* Pitch mode */
-
-/*
- * Useful stuff that probably belongs somewhere global.
- */
-#define VGA_WIDTH	640
-#define VGA_HEIGHT	480
-
-/*
- * Indexed port operations.  Note that these are all multi-op
- * functions; every invocation will be racy if you're not holding
- * reg_lock.
- */
-
-#define VIAStatus   0x3DA  /* Non-indexed port */
-#define VIACR       0x3D4
-#define VIASR       0x3C4
-#define VIAGR       0x3CE
-#define VIAAR       0x3C0
-
-static inline u8 via_read_reg(u16 port, u8 index)
-{
-	outb(index, port);
-	return inb(port + 1);
-}
-
-static inline void via_write_reg(u16 port, u8 index, u8 data)
-{
-	outb(index, port);
-	outb(data, port + 1);
-}
-
-static inline void via_write_reg_mask(u16 port, u8 index, u8 data, u8 mask)
-{
-	u8 old;
-
-	outb(index, port);
-	old = inb(port + 1);
-	outb((data & mask) | (old & ~mask), port + 1);
-}
-
-#define VIA_MISC_REG_READ	0x03CC
-#define VIA_MISC_REG_WRITE	0x03C2
-
-static inline void via_write_misc_reg_mask(u8 data, u8 mask)
-{
-	u8 old = inb(VIA_MISC_REG_READ);
-	outb((data & mask) | (old & ~mask), VIA_MISC_REG_WRITE);
-}
-
-
-#endif /* __VIA_CORE_H__ */
diff --git a/drivers/video/via/via-gpio.c b/drivers/video/via/via-gpio.c
index 67d699c..595516a 100644
--- a/drivers/video/via/via-gpio.c
+++ b/drivers/video/via/via-gpio.c
@@ -8,8 +8,8 @@
 #include <linux/spinlock.h>
 #include <linux/gpio.h>
 #include <linux/platform_device.h>
-#include "via-core.h"
-#include "via-gpio.h"
+#include <linux/via-core.h>
+#include <linux/via-gpio.h>
 
 /*
  * The ports we know about.  Note that the port-25 gpios are not
diff --git a/drivers/video/via/via-gpio.h b/drivers/video/via/via-gpio.h
deleted file mode 100644
index 8281aea..0000000
--- a/drivers/video/via/via-gpio.h
+++ /dev/null
@@ -1,14 +0,0 @@
-/*
- * Support for viafb GPIO ports.
- *
- * Copyright 2009 Jonathan Corbet <corbet@lwn.net>
- * Distributable under version 2 of the GNU General Public License.
- */
-
-#ifndef __VIA_GPIO_H__
-#define __VIA_GPIO_H__
-
-extern int viafb_gpio_lookup(const char *name);
-extern int viafb_gpio_init(void);
-extern void viafb_gpio_exit(void);
-#endif
diff --git a/drivers/video/via/via_i2c.c b/drivers/video/via/via_i2c.c
index 2291765..da9e4ca 100644
--- a/drivers/video/via/via_i2c.c
+++ b/drivers/video/via/via_i2c.c
@@ -23,8 +23,8 @@
 #include <linux/delay.h>
 #include <linux/spinlock.h>
 #include <linux/module.h>
-#include "via-core.h"
-#include "via_i2c.h"
+#include <linux/via-core.h>
+#include <linux/via_i2c.h>
 
 /*
  * There can only be one set of these, so there's no point in having
diff --git a/drivers/video/via/via_i2c.h b/drivers/video/via/via_i2c.h
deleted file mode 100644
index 44532e4..0000000
--- a/drivers/video/via/via_i2c.h
+++ /dev/null
@@ -1,42 +0,0 @@
-/*
- * Copyright 1998-2009 VIA Technologies, Inc. All Rights Reserved.
- * Copyright 2001-2008 S3 Graphics, Inc. All Rights Reserved.
-
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public
- * License as published by the Free Software Foundation;
- * either version 2, or (at your option) any later version.
-
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTIES OR REPRESENTATIONS; without even
- * the implied warranty of MERCHANTABILITY or FITNESS FOR
- * A PARTICULAR PURPOSE.See the GNU General Public License
- * for more details.
-
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc.,
- * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
- */
-#ifndef __VIA_I2C_H__
-#define __VIA_I2C_H__
-
-#include <linux/i2c.h>
-#include <linux/i2c-algo-bit.h>
-
-struct via_i2c_stuff {
-	u16 i2c_port;			/* GPIO or I2C port */
-	u16 is_active;			/* Being used as I2C? */
-	struct i2c_adapter adapter;
-	struct i2c_algo_bit_data algo;
-};
-
-
-int viafb_i2c_readbyte(u8 adap, u8 slave_addr, u8 index, u8 *pdata);
-int viafb_i2c_writebyte(u8 adap, u8 slave_addr, u8 index, u8 data);
-int viafb_i2c_readbytes(u8 adap, u8 slave_addr, u8 index, u8 *buff, int buff_len);
-struct i2c_adapter *viafb_find_i2c_adapter(enum viafb_i2c_adap which);
-
-extern int viafb_i2c_init(void);
-extern void viafb_i2c_exit(void);
-#endif /* __VIA_I2C_H__ */
diff --git a/drivers/video/via/via_modesetting.c b/drivers/video/via/via_modesetting.c
index b4e735c..3cddcff 100644
--- a/drivers/video/via/via_modesetting.c
+++ b/drivers/video/via/via_modesetting.c
@@ -24,8 +24,8 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/via-core.h>
 #include "via_modesetting.h"
-#include "via-core.h"
 #include "share.h"
 #include "debug.h"
 
diff --git a/drivers/video/via/via_utility.c b/drivers/video/via/via_utility.c
index 5757031..d05ccb6 100644
--- a/drivers/video/via/via_utility.c
+++ b/drivers/video/via/via_utility.c
@@ -19,7 +19,7 @@
  * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 
-#include "via-core.h"
+#include <linux/via-core.h>
 #include "global.h"
 
 void viafb_get_device_support_state(u32 *support_state)
diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
index 3d03318..d3dd2eb 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -22,9 +22,9 @@
 #include <linux/module.h>
 #include <linux/seq_file.h>
 #include <linux/stat.h>
-#define _MASTER_FILE
+#include <linux/via-core.h>
 
-#include "via-core.h"
+#define _MASTER_FILE
 #include "global.h"
 
 static char *viafb_name = "Via";
diff --git a/drivers/video/via/viamode.c b/drivers/video/via/viamode.c
index 2fdb9e6..2dbad3c 100644
--- a/drivers/video/via/viamode.c
+++ b/drivers/video/via/viamode.c
@@ -19,7 +19,7 @@
  * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 
-#include "via-core.h"
+#include <linux/via-core.h>
 #include "global.h"
 struct res_map_refresh res_map_refresh_tbl[] = {
 /*hres, vres, vclock, vmode_refresh*/
diff --git a/drivers/video/via/vt1636.c b/drivers/video/via/vt1636.c
index e5f8024..d65bf1a 100644
--- a/drivers/video/via/vt1636.c
+++ b/drivers/video/via/vt1636.c
@@ -19,8 +19,8 @@
  * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 
-#include "via-core.h"
-#include "via_i2c.h"
+#include <linux/via-core.h>
+#include <linux/via_i2c.h>
 #include "global.h"
 
 u8 viafb_gpio_i2c_read_lvds(struct lvds_setting_information
diff --git a/include/linux/via-core.h b/include/linux/via-core.h
new file mode 100644
index 0000000..7ffb521
--- /dev/null
+++ b/include/linux/via-core.h
@@ -0,0 +1,219 @@
+/*
+ * Copyright 1998-2009 VIA Technologies, Inc. All Rights Reserved.
+ * Copyright 2001-2008 S3 Graphics, Inc. All Rights Reserved.
+ * Copyright 2009-2010 Jonathan Corbet <corbet@lwn.net>
+ * Copyright 2010 Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License as published by the Free Software Foundation;
+ * either version 2, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTIES OR REPRESENTATIONS; without even
+ * the implied warranty of MERCHANTABILITY or FITNESS FOR
+ * A PARTICULAR PURPOSE.See the GNU General Public License
+ * for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc.,
+ * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+
+#ifndef __VIA_CORE_H__
+#define __VIA_CORE_H__
+#include <linux/types.h>
+#include <linux/io.h>
+#include <linux/spinlock.h>
+#include <linux/pci.h>
+
+/*
+ * A description of each known serial I2C/GPIO port.
+ */
+enum via_port_type {
+	VIA_PORT_NONE = 0,
+	VIA_PORT_I2C,
+	VIA_PORT_GPIO,
+};
+
+enum via_port_mode {
+	VIA_MODE_OFF = 0,
+	VIA_MODE_I2C,		/* Used as I2C port */
+	VIA_MODE_GPIO,	/* Two GPIO ports */
+};
+
+enum viafb_i2c_adap {
+	VIA_PORT_26 = 0,
+	VIA_PORT_31,
+	VIA_PORT_25,
+	VIA_PORT_2C,
+	VIA_PORT_3D,
+};
+#define VIAFB_NUM_PORTS 5
+
+struct via_port_cfg {
+	enum via_port_type	type;
+	enum via_port_mode	mode;
+	u16			io_port;
+	u8			ioport_index;
+};
+
+/*
+ * This is the global viafb "device" containing stuff needed by
+ * all subdevs.
+ */
+struct viafb_dev {
+	struct pci_dev *pdev;
+	int chip_type;
+	struct via_port_cfg *port_cfg;
+	/*
+	 * Spinlock for access to device registers.  Not yet
+	 * globally used.
+	 */
+	spinlock_t reg_lock;
+	/*
+	 * The framebuffer MMIO region.  Little, if anything, touches
+	 * this memory directly, and certainly nothing outside of the
+	 * framebuffer device itself.  We *do* have to be able to allocate
+	 * chunks of this memory for other devices, though.
+	 */
+	unsigned long fbmem_start;
+	long fbmem_len;
+	void __iomem *fbmem;
+#if defined(CONFIG_FB_VIA_CAMERA) || defined(CONFIG_FB_VIA_CAMERA_MODULE)
+	long camera_fbmem_offset;
+	long camera_fbmem_size;
+#endif
+	/*
+	 * The MMIO region for device registers.
+	 */
+	unsigned long engine_start;
+	unsigned long engine_len;
+	void __iomem *engine_mmio;
+
+};
+
+/*
+ * Interrupt management.
+ */
+
+void viafb_irq_enable(u32 mask);
+void viafb_irq_disable(u32 mask);
+
+/*
+ * The global interrupt control register and its bits.
+ */
+#define VDE_INTERRUPT	0x200	/* Video interrupt flags/masks */
+#define   VDE_I_DVISENSE  0x00000001  /* DVI sense int status */
+#define   VDE_I_VBLANK    0x00000002  /* Vertical blank status */
+#define   VDE_I_MCCFI	  0x00000004  /* MCE compl. frame int status */
+#define   VDE_I_VSYNC	  0x00000008  /* VGA VSYNC int status */
+#define   VDE_I_DMA0DDONE 0x00000010  /* DMA 0 descr done */
+#define   VDE_I_DMA0TDONE 0x00000020  /* DMA 0 transfer done */
+#define   VDE_I_DMA1DDONE 0x00000040  /* DMA 1 descr done */
+#define   VDE_I_DMA1TDONE 0x00000080  /* DMA 1 transfer done */
+#define   VDE_I_C1AV      0x00000100  /* Cap Eng 1 act vid end */
+#define   VDE_I_HQV0	  0x00000200  /* First HQV engine */
+#define   VDE_I_HQV1      0x00000400  /* Second HQV engine */
+#define   VDE_I_HQV1EN	  0x00000800  /* Second HQV engine enable */
+#define   VDE_I_C0AV      0x00001000  /* Cap Eng 0 act vid end */
+#define   VDE_I_C0VBI     0x00002000  /* Cap Eng 0 VBI end */
+#define   VDE_I_C1VBI     0x00004000  /* Cap Eng 1 VBI end */
+#define   VDE_I_VSYNC2    0x00008000  /* Sec. Disp. VSYNC */
+#define   VDE_I_DVISNSEN  0x00010000  /* DVI sense enable */
+#define   VDE_I_VSYNC2EN  0x00020000  /* Sec Disp VSYNC enable */
+#define   VDE_I_MCCFIEN	  0x00040000  /* MC comp frame int mask enable */
+#define   VDE_I_VSYNCEN   0x00080000  /* VSYNC enable */
+#define   VDE_I_DMA0DDEN  0x00100000  /* DMA 0 descr done enable */
+#define   VDE_I_DMA0TDEN  0x00200000  /* DMA 0 trans done enable */
+#define   VDE_I_DMA1DDEN  0x00400000  /* DMA 1 descr done enable */
+#define   VDE_I_DMA1TDEN  0x00800000  /* DMA 1 trans done enable */
+#define   VDE_I_C1AVEN    0x01000000  /* cap 1 act vid end enable */
+#define   VDE_I_HQV0EN	  0x02000000  /* First hqv engine enable */
+#define   VDE_I_C1VBIEN	  0x04000000  /* Cap 1 VBI end enable */
+#define   VDE_I_LVDSSI    0x08000000  /* LVDS sense interrupt */
+#define   VDE_I_C0AVEN    0x10000000  /* Cap 0 act vid end enable */
+#define   VDE_I_C0VBIEN   0x20000000  /* Cap 0 VBI end enable */
+#define   VDE_I_LVDSSIEN  0x40000000  /* LVDS Sense enable */
+#define   VDE_I_ENABLE	  0x80000000  /* Global interrupt enable */
+
+/*
+ * DMA management.
+ */
+int viafb_request_dma(void);
+void viafb_release_dma(void);
+/* void viafb_dma_copy_out(unsigned int offset, dma_addr_t paddr, int len); */
+int viafb_dma_copy_out_sg(unsigned int offset, struct scatterlist *sg, int nsg);
+
+/*
+ * DMA Controller registers.
+ */
+#define VDMA_MR0	0xe00		/* Mod reg 0 */
+#define   VDMA_MR_CHAIN   0x01		/* Chaining mode */
+#define   VDMA_MR_TDIE    0x02		/* Transfer done int enable */
+#define VDMA_CSR0	0xe04		/* Control/status */
+#define	  VDMA_C_ENABLE	  0x01		  /* DMA Enable */
+#define	  VDMA_C_START	  0x02		  /* Start a transfer */
+#define	  VDMA_C_ABORT	  0x04		  /* Abort a transfer */
+#define	  VDMA_C_DONE	  0x08		  /* Transfer is done */
+#define VDMA_MARL0	0xe20		/* Mem addr low */
+#define VDMA_MARH0	0xe24		/* Mem addr high */
+#define VDMA_DAR0	0xe28		/* Device address */
+#define VDMA_DQWCR0	0xe2c		/* Count (16-byte) */
+#define VDMA_TMR0	0xe30		/* Tile mode reg */
+#define VDMA_DPRL0	0xe34		/* Not sure */
+#define	  VDMA_DPR_IN	  0x08		/* Inbound transfer to FB */
+#define VDMA_DPRH0	0xe38
+#define VDMA_PMR0	(0xe00 + 0x134) /* Pitch mode */
+
+/*
+ * Useful stuff that probably belongs somewhere global.
+ */
+#define VGA_WIDTH	640
+#define VGA_HEIGHT	480
+
+/*
+ * Indexed port operations.  Note that these are all multi-op
+ * functions; every invocation will be racy if you're not holding
+ * reg_lock.
+ */
+
+#define VIAStatus   0x3DA  /* Non-indexed port */
+#define VIACR       0x3D4
+#define VIASR       0x3C4
+#define VIAGR       0x3CE
+#define VIAAR       0x3C0
+
+static inline u8 via_read_reg(u16 port, u8 index)
+{
+	outb(index, port);
+	return inb(port + 1);
+}
+
+static inline void via_write_reg(u16 port, u8 index, u8 data)
+{
+	outb(index, port);
+	outb(data, port + 1);
+}
+
+static inline void via_write_reg_mask(u16 port, u8 index, u8 data, u8 mask)
+{
+	u8 old;
+
+	outb(index, port);
+	old = inb(port + 1);
+	outb((data & mask) | (old & ~mask), port + 1);
+}
+
+#define VIA_MISC_REG_READ	0x03CC
+#define VIA_MISC_REG_WRITE	0x03C2
+
+static inline void via_write_misc_reg_mask(u8 data, u8 mask)
+{
+	u8 old = inb(VIA_MISC_REG_READ);
+	outb((data & mask) | (old & ~mask), VIA_MISC_REG_WRITE);
+}
+
+
+#endif /* __VIA_CORE_H__ */
diff --git a/include/linux/via-gpio.h b/include/linux/via-gpio.h
new file mode 100644
index 0000000..8281aea
--- /dev/null
+++ b/include/linux/via-gpio.h
@@ -0,0 +1,14 @@
+/*
+ * Support for viafb GPIO ports.
+ *
+ * Copyright 2009 Jonathan Corbet <corbet@lwn.net>
+ * Distributable under version 2 of the GNU General Public License.
+ */
+
+#ifndef __VIA_GPIO_H__
+#define __VIA_GPIO_H__
+
+extern int viafb_gpio_lookup(const char *name);
+extern int viafb_gpio_init(void);
+extern void viafb_gpio_exit(void);
+#endif
diff --git a/include/linux/via_i2c.h b/include/linux/via_i2c.h
new file mode 100644
index 0000000..44532e4
--- /dev/null
+++ b/include/linux/via_i2c.h
@@ -0,0 +1,42 @@
+/*
+ * Copyright 1998-2009 VIA Technologies, Inc. All Rights Reserved.
+ * Copyright 2001-2008 S3 Graphics, Inc. All Rights Reserved.
+
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License as published by the Free Software Foundation;
+ * either version 2, or (at your option) any later version.
+
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTIES OR REPRESENTATIONS; without even
+ * the implied warranty of MERCHANTABILITY or FITNESS FOR
+ * A PARTICULAR PURPOSE.See the GNU General Public License
+ * for more details.
+
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc.,
+ * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+#ifndef __VIA_I2C_H__
+#define __VIA_I2C_H__
+
+#include <linux/i2c.h>
+#include <linux/i2c-algo-bit.h>
+
+struct via_i2c_stuff {
+	u16 i2c_port;			/* GPIO or I2C port */
+	u16 is_active;			/* Being used as I2C? */
+	struct i2c_adapter adapter;
+	struct i2c_algo_bit_data algo;
+};
+
+
+int viafb_i2c_readbyte(u8 adap, u8 slave_addr, u8 index, u8 *pdata);
+int viafb_i2c_writebyte(u8 adap, u8 slave_addr, u8 index, u8 data);
+int viafb_i2c_readbytes(u8 adap, u8 slave_addr, u8 index, u8 *buff, int buff_len);
+struct i2c_adapter *viafb_find_i2c_adapter(enum viafb_i2c_adap which);
+
+extern int viafb_i2c_init(void);
+extern void viafb_i2c_exit(void);
+#endif /* __VIA_I2C_H__ */
-- 
1.7.0.1

