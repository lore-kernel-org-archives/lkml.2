Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760314Ab0LODta (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 22:49:30 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:39884 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758827Ab0LODt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 22:49:26 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6197"; a="66872367"
From: Stepan Moskovchenko <stepanm@codeaurora.org>
To: davidb@codeaurora.org
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: [PATCH 1/7] msm: io: I/O register definitions for MSM8960
Date: Tue, 14 Dec 2010 19:49:15 -0800
Message-Id: <1292384961-8851-2-git-send-email-stepanm@codeaurora.org>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1292384961-8851-1-git-send-email-stepanm@codeaurora.org>
References: <1292384961-8851-1-git-send-email-stepanm@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the register address definitions for the basic hardware
blocks on the Qualcomm MSM8960 chip.

Signed-off-by: Stepan Moskovchenko <stepanm@codeaurora.org>
---
 arch/arm/mach-msm/include/mach/io.h             |    1 +
 arch/arm/mach-msm/include/mach/msm_iomap-8960.h |   55 +++++++++++++++++++++++
 arch/arm/mach-msm/include/mach/msm_iomap.h      |    2 +
 arch/arm/mach-msm/io.c                          |   14 ++++++
 4 files changed, 72 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-msm/include/mach/msm_iomap-8960.h

diff --git a/arch/arm/mach-msm/include/mach/io.h b/arch/arm/mach-msm/include/mach/io.h
index 7386e73..dc1b928 100644
--- a/arch/arm/mach-msm/include/mach/io.h
+++ b/arch/arm/mach-msm/include/mach/io.h
@@ -29,6 +29,7 @@ void __iomem *__msm_ioremap(unsigned long phys_addr, size_t size, unsigned int m
 void msm_map_qsd8x50_io(void);
 void msm_map_msm7x30_io(void);
 void msm_map_msm8x60_io(void);
+void msm_map_msm8960_io(void);

 extern unsigned int msm_shared_ram_phys;

diff --git a/arch/arm/mach-msm/include/mach/msm_iomap-8960.h b/arch/arm/mach-msm/include/mach/msm_iomap-8960.h
new file mode 100644
index 0000000..ca6bf90
--- /dev/null
+++ b/arch/arm/mach-msm/include/mach/msm_iomap-8960.h
@@ -0,0 +1,55 @@
+/*
+ * Copyright (C) 2007 Google, Inc.
+ * Copyright (c) 2008-2010, Code Aurora Forum. All rights reserved.
+ * Author: Brian Swetland <swetland@google.com>
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
+ *
+ * The MSM peripherals are spread all over across 768MB of physical
+ * space, which makes just having a simple IO_ADDRESS macro to slide
+ * them into the right virtual location rough.  Instead, we will
+ * provide a master phys->virt mapping for peripherals here.
+ *
+ */
+
+#ifndef __ASM_ARCH_MSM_IOMAP_8960_H
+#define __ASM_ARCH_MSM_IOMAP_8960_H
+
+/* Physical base address and size of peripherals.
+ * Ordered by the virtual base addresses they will be mapped at.
+ *
+ * If you add or remove entries here, you'll want to edit the
+ * msm_io_desc array in arch/arm/mach-msm/io.c to reflect your
+ * changes.
+ *
+ */
+
+
+#define MSM_QGIC_DIST_BASE	IOMEM(0xF0000000)
+#define MSM_QGIC_DIST_PHYS	0x02000000
+#define MSM_QGIC_DIST_SIZE	SZ_4K
+
+#define MSM_QGIC_CPU_BASE	IOMEM(0xF0001000)
+#define MSM_QGIC_CPU_PHYS	0x02002000
+#define MSM_QGIC_CPU_SIZE	SZ_4K
+
+#define MSM_TMR_BASE		IOMEM(0xF0100000)
+#define MSM_TMR_PHYS		0x0200A000
+#define MSM_TMR_SIZE		(SZ_4K)
+
+#define MSM_TMR0_BASE		IOMEM(0xF0101000)
+#define MSM_TMR0_PHYS		0x0208A000
+#define MSM_TMR0_SIZE		(SZ_4K)
+
+#define MSM_GPT_BASE		(MSM_TMR_BASE + 0x4)
+#define MSM_DGT_BASE		(MSM_TMR_BASE + 0x24)
+
+#endif
diff --git a/arch/arm/mach-msm/include/mach/msm_iomap.h b/arch/arm/mach-msm/include/mach/msm_iomap.h
index 8e24dd8..4154a0a 100644
--- a/arch/arm/mach-msm/include/mach/msm_iomap.h
+++ b/arch/arm/mach-msm/include/mach/msm_iomap.h
@@ -49,6 +49,8 @@
 #include "msm_iomap-8x50.h"
 #elif defined(CONFIG_ARCH_MSM8X60)
 #include "msm_iomap-8x60.h"
+#elif defined(CONFIG_ARCH_MSM8960)
+#include "msm_iomap-8960.h"
 #else
 #include "msm_iomap-7x00.h"
 #endif
diff --git a/arch/arm/mach-msm/io.c b/arch/arm/mach-msm/io.c
index b826b6b..8254fc4 100644
--- a/arch/arm/mach-msm/io.c
+++ b/arch/arm/mach-msm/io.c
@@ -116,6 +116,20 @@ void __init msm_map_msm8x60_io(void)
 }
 #endif /* CONFIG_ARCH_MSM8X60 */

+#ifdef CONFIG_ARCH_MSM8960
+static struct map_desc msm8960_io_desc[] __initdata = {
+	MSM_DEVICE(QGIC_DIST),
+	MSM_DEVICE(QGIC_CPU),
+	MSM_DEVICE(TMR),
+	MSM_DEVICE(TMR0),
+};
+
+void __init msm_map_msm8960_io(void)
+{
+	iotable_init(msm8960_io_desc, ARRAY_SIZE(msm8960_io_desc));
+}
+#endif /* CONFIG_ARCH_MSM8960 */
+
 #ifdef CONFIG_ARCH_MSM7X30
 static struct map_desc msm7x30_io_desc[] __initdata = {
 	MSM_DEVICE(VIC),
--
1.7.0.2

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

