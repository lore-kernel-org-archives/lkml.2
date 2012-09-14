Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755107Ab2INQ1a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 12:27:30 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:36477 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753243Ab2INQ1W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 12:27:22 -0400
From: Davide Ciminaghi <dciminaghi@mail.gnudd.com>
To: linux@arm.linux.org.uk, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, djbw@fb.com, vinod.koul@intel.com,
        grant.likely@secretlab.ca, linus.walleij@linaro.org, rubini@gnudd.com,
        wim@iguana.be, cjb@laptop.org, davidb@codeaurora.org, nico@fluxnic.net,
        gregkh@linuxfoundation.org, ben-linux@fluff.org,
        viresh.linux@gmail.com, rajeev-dlh.kumar@st.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        giancarlo.asnaghi@st.com
Subject: [PATCH 3/8] pl080.h: moved from arm/include/asm/hardware to include/linux/amba/
Date: Fri, 14 Sep 2012 18:23:58 +0200
Message-Id: <1347639843-32119-4-git-send-email-dciminaghi@mail.gnudd.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1347639843-32119-1-git-send-email-dciminaghi@mail.gnudd.com>
References: <1347639843-32119-1-git-send-email-dciminaghi@mail.gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alessandro Rubini <rubini@gnudd.com>

The header is used by drivers/dma/amba-pl08x.c, which can be compiled
under x86, where PL080 exists under a PCI-to-AMBA bridge. This patche
moves it where it can be accessed by other architectures, and fixes
all users.

Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
---
 arch/arm/include/asm/hardware/pl080.h |  146 ---------------------------------
 arch/arm/mach-s3c64xx/dma.c           |    2 +-
 arch/arm/mach-spear3xx/spear3xx.c     |    2 +-
 arch/arm/mach-spear6xx/spear6xx.c     |    2 +-
 drivers/dma/amba-pl08x.c              |    2 +-
 include/linux/amba/pl080.h            |  146 +++++++++++++++++++++++++++++++++
 6 files changed, 150 insertions(+), 150 deletions(-)
 delete mode 100644 arch/arm/include/asm/hardware/pl080.h
 create mode 100644 include/linux/amba/pl080.h

diff --git a/arch/arm/include/asm/hardware/pl080.h b/arch/arm/include/asm/hardware/pl080.h
deleted file mode 100644
index 4eea210..0000000
--- a/arch/arm/include/asm/hardware/pl080.h
+++ /dev/null
@@ -1,146 +0,0 @@
-/* arch/arm/include/asm/hardware/pl080.h
- *
- * Copyright 2008 Openmoko, Inc.
- * Copyright 2008 Simtec Electronics
- *      http://armlinux.simtec.co.uk/
- *      Ben Dooks <ben@simtec.co.uk>
- *
- * ARM PrimeCell PL080 DMA controller
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
-*/
-
-/* Note, there are some Samsung updates to this controller block which
- * make it not entierly compatible with the PL080 specification from
- * ARM. When in doubt, check the Samsung documentation first.
- *
- * The Samsung defines are PL080S, and add an extra control register,
- * the ability to move more than 2^11 counts of data and some extra
- * OneNAND features.
-*/
-
-#ifndef ASM_PL080_H
-#define ASM_PL080_H
-
-#define PL080_INT_STATUS			(0x00)
-#define PL080_TC_STATUS				(0x04)
-#define PL080_TC_CLEAR				(0x08)
-#define PL080_ERR_STATUS			(0x0C)
-#define PL080_ERR_CLEAR				(0x10)
-#define PL080_RAW_TC_STATUS			(0x14)
-#define PL080_RAW_ERR_STATUS			(0x18)
-#define PL080_EN_CHAN				(0x1c)
-#define PL080_SOFT_BREQ				(0x20)
-#define PL080_SOFT_SREQ				(0x24)
-#define PL080_SOFT_LBREQ			(0x28)
-#define PL080_SOFT_LSREQ			(0x2C)
-
-#define PL080_CONFIG				(0x30)
-#define PL080_CONFIG_M2_BE			(1 << 2)
-#define PL080_CONFIG_M1_BE			(1 << 1)
-#define PL080_CONFIG_ENABLE			(1 << 0)
-
-#define PL080_SYNC				(0x34)
-
-/* Per channel configuration registers */
-
-#define PL080_Cx_STRIDE				(0x20)
-#define PL080_Cx_BASE(x)			((0x100 + (x * 0x20)))
-#define PL080_Cx_SRC_ADDR(x)			((0x100 + (x * 0x20)))
-#define PL080_Cx_DST_ADDR(x)			((0x104 + (x * 0x20)))
-#define PL080_Cx_LLI(x)				((0x108 + (x * 0x20)))
-#define PL080_Cx_CONTROL(x)			((0x10C + (x * 0x20)))
-#define PL080_Cx_CONFIG(x)			((0x110 + (x * 0x20)))
-#define PL080S_Cx_CONTROL2(x)			((0x110 + (x * 0x20)))
-#define PL080S_Cx_CONFIG(x)			((0x114 + (x * 0x20)))
-
-#define PL080_CH_SRC_ADDR			(0x00)
-#define PL080_CH_DST_ADDR			(0x04)
-#define PL080_CH_LLI				(0x08)
-#define PL080_CH_CONTROL			(0x0C)
-#define PL080_CH_CONFIG				(0x10)
-#define PL080S_CH_CONTROL2			(0x10)
-#define PL080S_CH_CONFIG			(0x14)
-
-#define PL080_LLI_ADDR_MASK			(0x3fffffff << 2)
-#define PL080_LLI_ADDR_SHIFT			(2)
-#define PL080_LLI_LM_AHB2			(1 << 0)
-
-#define PL080_CONTROL_TC_IRQ_EN			(1 << 31)
-#define PL080_CONTROL_PROT_MASK			(0x7 << 28)
-#define PL080_CONTROL_PROT_SHIFT		(28)
-#define PL080_CONTROL_PROT_CACHE		(1 << 30)
-#define PL080_CONTROL_PROT_BUFF			(1 << 29)
-#define PL080_CONTROL_PROT_SYS			(1 << 28)
-#define PL080_CONTROL_DST_INCR			(1 << 27)
-#define PL080_CONTROL_SRC_INCR			(1 << 26)
-#define PL080_CONTROL_DST_AHB2			(1 << 25)
-#define PL080_CONTROL_SRC_AHB2			(1 << 24)
-#define PL080_CONTROL_DWIDTH_MASK		(0x7 << 21)
-#define PL080_CONTROL_DWIDTH_SHIFT		(21)
-#define PL080_CONTROL_SWIDTH_MASK		(0x7 << 18)
-#define PL080_CONTROL_SWIDTH_SHIFT		(18)
-#define PL080_CONTROL_DB_SIZE_MASK		(0x7 << 15)
-#define PL080_CONTROL_DB_SIZE_SHIFT		(15)
-#define PL080_CONTROL_SB_SIZE_MASK		(0x7 << 12)
-#define PL080_CONTROL_SB_SIZE_SHIFT		(12)
-#define PL080_CONTROL_TRANSFER_SIZE_MASK	(0xfff << 0)
-#define PL080_CONTROL_TRANSFER_SIZE_SHIFT	(0)
-
-#define PL080_BSIZE_1				(0x0)
-#define PL080_BSIZE_4				(0x1)
-#define PL080_BSIZE_8				(0x2)
-#define PL080_BSIZE_16				(0x3)
-#define PL080_BSIZE_32				(0x4)
-#define PL080_BSIZE_64				(0x5)
-#define PL080_BSIZE_128				(0x6)
-#define PL080_BSIZE_256				(0x7)
-
-#define PL080_WIDTH_8BIT			(0x0)
-#define PL080_WIDTH_16BIT			(0x1)
-#define PL080_WIDTH_32BIT			(0x2)
-
-#define PL080N_CONFIG_ITPROT			(1 << 20)
-#define PL080N_CONFIG_SECPROT			(1 << 19)
-#define PL080_CONFIG_HALT			(1 << 18)
-#define PL080_CONFIG_ACTIVE			(1 << 17)  /* RO */
-#define PL080_CONFIG_LOCK			(1 << 16)
-#define PL080_CONFIG_TC_IRQ_MASK		(1 << 15)
-#define PL080_CONFIG_ERR_IRQ_MASK		(1 << 14)
-#define PL080_CONFIG_FLOW_CONTROL_MASK		(0x7 << 11)
-#define PL080_CONFIG_FLOW_CONTROL_SHIFT		(11)
-#define PL080_CONFIG_DST_SEL_MASK		(0xf << 6)
-#define PL080_CONFIG_DST_SEL_SHIFT		(6)
-#define PL080_CONFIG_SRC_SEL_MASK		(0xf << 1)
-#define PL080_CONFIG_SRC_SEL_SHIFT		(1)
-#define PL080_CONFIG_ENABLE			(1 << 0)
-
-#define PL080_FLOW_MEM2MEM			(0x0)
-#define PL080_FLOW_MEM2PER			(0x1)
-#define PL080_FLOW_PER2MEM			(0x2)
-#define PL080_FLOW_SRC2DST			(0x3)
-#define PL080_FLOW_SRC2DST_DST			(0x4)
-#define PL080_FLOW_MEM2PER_PER			(0x5)
-#define PL080_FLOW_PER2MEM_PER			(0x6)
-#define PL080_FLOW_SRC2DST_SRC			(0x7)
-
-/* DMA linked list chain structure */
-
-struct pl080_lli {
-	u32	src_addr;
-	u32	dst_addr;
-	u32	next_lli;
-	u32	control0;
-};
-
-struct pl080s_lli {
-	u32	src_addr;
-	u32	dst_addr;
-	u32	next_lli;
-	u32	control0;
-	u32	control1;
-};
-
-#endif /* ASM_PL080_H */
diff --git a/arch/arm/mach-s3c64xx/dma.c b/arch/arm/mach-s3c64xx/dma.c
index f2a7a17..a77f521 100644
--- a/arch/arm/mach-s3c64xx/dma.c
+++ b/arch/arm/mach-s3c64xx/dma.c
@@ -23,6 +23,7 @@
 #include <linux/clk.h>
 #include <linux/err.h>
 #include <linux/io.h>
+#include <linux/amba/pl080.h>
 
 #include <mach/dma.h>
 #include <mach/map.h>
@@ -30,7 +31,6 @@
 
 #include <mach/regs-sys.h>
 
-#include <asm/hardware/pl080.h>
 
 /* dma channel state information */
 
diff --git a/arch/arm/mach-spear3xx/spear3xx.c b/arch/arm/mach-spear3xx/spear3xx.c
index 98144ba..ba61129 100644
--- a/arch/arm/mach-spear3xx/spear3xx.c
+++ b/arch/arm/mach-spear3xx/spear3xx.c
@@ -15,9 +15,9 @@
 
 #include <linux/amba/pl022.h>
 #include <linux/amba/pl08x.h>
+#include <linux/amba/pl080.h>
 #include <linux/of_irq.h>
 #include <linux/io.h>
-#include <asm/hardware/pl080.h>
 #include <asm/hardware/vic.h>
 #include <plat/pl080.h>
 #include <mach/generic.h>
diff --git a/arch/arm/mach-spear6xx/spear6xx.c b/arch/arm/mach-spear6xx/spear6xx.c
index 5a5a52d..8ce65a2 100644
--- a/arch/arm/mach-spear6xx/spear6xx.c
+++ b/arch/arm/mach-spear6xx/spear6xx.c
@@ -20,7 +20,7 @@
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
-#include <asm/hardware/pl080.h>
+#include <linux/amba/pl080.h>
 #include <asm/hardware/vic.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/time.h>
diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index d1cc579..b453c2f 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -83,7 +83,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/seq_file.h>
 #include <linux/slab.h>
-#include <asm/hardware/pl080.h>
+#include <linux/amba/pl080.h>
 
 #include "dmaengine.h"
 #include "virt-dma.h"
diff --git a/include/linux/amba/pl080.h b/include/linux/amba/pl080.h
new file mode 100644
index 0000000..3e7b62f
--- /dev/null
+++ b/include/linux/amba/pl080.h
@@ -0,0 +1,146 @@
+/* include/linux/amba/pl080.h
+ *
+ * Copyright 2008 Openmoko, Inc.
+ * Copyright 2008 Simtec Electronics
+ *      http://armlinux.simtec.co.uk/
+ *      Ben Dooks <ben@simtec.co.uk>
+ *
+ * ARM PrimeCell PL080 DMA controller
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+*/
+
+/* Note, there are some Samsung updates to this controller block which
+ * make it not entierly compatible with the PL080 specification from
+ * ARM. When in doubt, check the Samsung documentation first.
+ *
+ * The Samsung defines are PL080S, and add an extra control register,
+ * the ability to move more than 2^11 counts of data and some extra
+ * OneNAND features.
+*/
+
+#ifndef ASM_PL080_H
+#define ASM_PL080_H
+
+#define PL080_INT_STATUS			(0x00)
+#define PL080_TC_STATUS				(0x04)
+#define PL080_TC_CLEAR				(0x08)
+#define PL080_ERR_STATUS			(0x0C)
+#define PL080_ERR_CLEAR				(0x10)
+#define PL080_RAW_TC_STATUS			(0x14)
+#define PL080_RAW_ERR_STATUS			(0x18)
+#define PL080_EN_CHAN				(0x1c)
+#define PL080_SOFT_BREQ				(0x20)
+#define PL080_SOFT_SREQ				(0x24)
+#define PL080_SOFT_LBREQ			(0x28)
+#define PL080_SOFT_LSREQ			(0x2C)
+
+#define PL080_CONFIG				(0x30)
+#define PL080_CONFIG_M2_BE			(1 << 2)
+#define PL080_CONFIG_M1_BE			(1 << 1)
+#define PL080_CONFIG_ENABLE			(1 << 0)
+
+#define PL080_SYNC				(0x34)
+
+/* Per channel configuration registers */
+
+#define PL080_Cx_STRIDE				(0x20)
+#define PL080_Cx_BASE(x)			((0x100 + (x * 0x20)))
+#define PL080_Cx_SRC_ADDR(x)			((0x100 + (x * 0x20)))
+#define PL080_Cx_DST_ADDR(x)			((0x104 + (x * 0x20)))
+#define PL080_Cx_LLI(x)				((0x108 + (x * 0x20)))
+#define PL080_Cx_CONTROL(x)			((0x10C + (x * 0x20)))
+#define PL080_Cx_CONFIG(x)			((0x110 + (x * 0x20)))
+#define PL080S_Cx_CONTROL2(x)			((0x110 + (x * 0x20)))
+#define PL080S_Cx_CONFIG(x)			((0x114 + (x * 0x20)))
+
+#define PL080_CH_SRC_ADDR			(0x00)
+#define PL080_CH_DST_ADDR			(0x04)
+#define PL080_CH_LLI				(0x08)
+#define PL080_CH_CONTROL			(0x0C)
+#define PL080_CH_CONFIG				(0x10)
+#define PL080S_CH_CONTROL2			(0x10)
+#define PL080S_CH_CONFIG			(0x14)
+
+#define PL080_LLI_ADDR_MASK			(0x3fffffff << 2)
+#define PL080_LLI_ADDR_SHIFT			(2)
+#define PL080_LLI_LM_AHB2			(1 << 0)
+
+#define PL080_CONTROL_TC_IRQ_EN			(1 << 31)
+#define PL080_CONTROL_PROT_MASK			(0x7 << 28)
+#define PL080_CONTROL_PROT_SHIFT		(28)
+#define PL080_CONTROL_PROT_CACHE		(1 << 30)
+#define PL080_CONTROL_PROT_BUFF			(1 << 29)
+#define PL080_CONTROL_PROT_SYS			(1 << 28)
+#define PL080_CONTROL_DST_INCR			(1 << 27)
+#define PL080_CONTROL_SRC_INCR			(1 << 26)
+#define PL080_CONTROL_DST_AHB2			(1 << 25)
+#define PL080_CONTROL_SRC_AHB2			(1 << 24)
+#define PL080_CONTROL_DWIDTH_MASK		(0x7 << 21)
+#define PL080_CONTROL_DWIDTH_SHIFT		(21)
+#define PL080_CONTROL_SWIDTH_MASK		(0x7 << 18)
+#define PL080_CONTROL_SWIDTH_SHIFT		(18)
+#define PL080_CONTROL_DB_SIZE_MASK		(0x7 << 15)
+#define PL080_CONTROL_DB_SIZE_SHIFT		(15)
+#define PL080_CONTROL_SB_SIZE_MASK		(0x7 << 12)
+#define PL080_CONTROL_SB_SIZE_SHIFT		(12)
+#define PL080_CONTROL_TRANSFER_SIZE_MASK	(0xfff << 0)
+#define PL080_CONTROL_TRANSFER_SIZE_SHIFT	(0)
+
+#define PL080_BSIZE_1				(0x0)
+#define PL080_BSIZE_4				(0x1)
+#define PL080_BSIZE_8				(0x2)
+#define PL080_BSIZE_16				(0x3)
+#define PL080_BSIZE_32				(0x4)
+#define PL080_BSIZE_64				(0x5)
+#define PL080_BSIZE_128				(0x6)
+#define PL080_BSIZE_256				(0x7)
+
+#define PL080_WIDTH_8BIT			(0x0)
+#define PL080_WIDTH_16BIT			(0x1)
+#define PL080_WIDTH_32BIT			(0x2)
+
+#define PL080N_CONFIG_ITPROT			(1 << 20)
+#define PL080N_CONFIG_SECPROT			(1 << 19)
+#define PL080_CONFIG_HALT			(1 << 18)
+#define PL080_CONFIG_ACTIVE			(1 << 17)  /* RO */
+#define PL080_CONFIG_LOCK			(1 << 16)
+#define PL080_CONFIG_TC_IRQ_MASK		(1 << 15)
+#define PL080_CONFIG_ERR_IRQ_MASK		(1 << 14)
+#define PL080_CONFIG_FLOW_CONTROL_MASK		(0x7 << 11)
+#define PL080_CONFIG_FLOW_CONTROL_SHIFT		(11)
+#define PL080_CONFIG_DST_SEL_MASK		(0xf << 6)
+#define PL080_CONFIG_DST_SEL_SHIFT		(6)
+#define PL080_CONFIG_SRC_SEL_MASK		(0xf << 1)
+#define PL080_CONFIG_SRC_SEL_SHIFT		(1)
+#define PL080_CONFIG_ENABLE			(1 << 0)
+
+#define PL080_FLOW_MEM2MEM			(0x0)
+#define PL080_FLOW_MEM2PER			(0x1)
+#define PL080_FLOW_PER2MEM			(0x2)
+#define PL080_FLOW_SRC2DST			(0x3)
+#define PL080_FLOW_SRC2DST_DST			(0x4)
+#define PL080_FLOW_MEM2PER_PER			(0x5)
+#define PL080_FLOW_PER2MEM_PER			(0x6)
+#define PL080_FLOW_SRC2DST_SRC			(0x7)
+
+/* DMA linked list chain structure */
+
+struct pl080_lli {
+	u32	src_addr;
+	u32	dst_addr;
+	u32	next_lli;
+	u32	control0;
+};
+
+struct pl080s_lli {
+	u32	src_addr;
+	u32	dst_addr;
+	u32	next_lli;
+	u32	control0;
+	u32	control1;
+};
+
+#endif /* ASM_PL080_H */
-- 
1.7.9.1

