Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758722Ab0JFHnU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 03:43:20 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:6374 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757415Ab0JFHnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 03:43:16 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6127"; a="56883648"
X-IronPort-AV: E=Sophos;i="4.57,287,1283756400"; 
   d="scan'208";a="88852284"
From: Jeff Ohlstein <johlstei@codeaurora.org>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Steve Muckle <smuckle@codeaurora.org>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Gregory Bean <gbean@codeaurora.org>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>,
        Jeff Ohlstein <johlstei@codeaurora.org>
Subject: [PATCH 02/20 v2] msm: io: MSM8X60 io support
Date: Wed,  6 Oct 2010 00:42:41 -0700
Message-Id: <1286350979-19328-3-git-send-email-johlstei@codeaurora.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1286350979-19328-1-git-send-email-johlstei@codeaurora.org>
References: <1286350979-19328-1-git-send-email-johlstei@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steve Muckle <smuckle@codeaurora.org>

MSM8X60 has different IO mappings than previous MSMs.

Signed-off-by: Steve Muckle <smuckle@codeaurora.org>
---
 arch/arm/mach-msm/include/mach/io.h             |    1 +
 arch/arm/mach-msm/include/mach/msm_iomap-8x60.h |   57 +++++++++++++++++++++++
 arch/arm/mach-msm/include/mach/msm_iomap.h      |    4 ++
 arch/arm/mach-msm/io.c                          |   15 ++++++
 4 files changed, 77 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-msm/include/mach/msm_iomap-8x60.h

diff --git a/arch/arm/mach-msm/include/mach/io.h b/arch/arm/mach-msm/include/mach/io.h
index c35b29f..7386e73 100644
--- a/arch/arm/mach-msm/include/mach/io.h
+++ b/arch/arm/mach-msm/include/mach/io.h
@@ -28,6 +28,7 @@ void __iomem *__msm_ioremap(unsigned long phys_addr, size_t size, unsigned int m
 
 void msm_map_qsd8x50_io(void);
 void msm_map_msm7x30_io(void);
+void msm_map_msm8x60_io(void);
 
 extern unsigned int msm_shared_ram_phys;
 
diff --git a/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h b/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h
new file mode 100644
index 0000000..1f1822b
--- /dev/null
+++ b/arch/arm/mach-msm/include/mach/msm_iomap-8x60.h
@@ -0,0 +1,57 @@
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
+#ifndef __ASM_ARCH_MSM_IOMAP_8X60_H
+#define __ASM_ARCH_MSM_IOMAP_8X60_H
+
+/* Physical base address and size of peripherals.
+ * Ordered by the virtual base addresses they will be mapped at.
+ *
+ * MSM_VIC_BASE must be an value that can be loaded via a "mov"
+ * instruction, otherwise entry-macro.S will not compile.
+ *
+ * If you add or remove entries here, you'll want to edit the
+ * msm_io_desc array in arch/arm/mach-msm/io.c to reflect your
+ * changes.
+ *
+ */
+
+#define MSM_QGIC_DIST_BASE	IOMEM(0xF0000000)
+#define MSM_QGIC_DIST_PHYS	0x02080000
+#define MSM_QGIC_DIST_SIZE	SZ_4K
+
+#define MSM_QGIC_CPU_BASE	IOMEM(0xF0001000)
+#define MSM_QGIC_CPU_PHYS	0x02081000
+#define MSM_QGIC_CPU_SIZE	SZ_4K
+
+#define MSM_ACC_BASE		IOMEM(0xF0002000)
+#define MSM_ACC_PHYS		0x02001000
+#define MSM_ACC_SIZE		SZ_4K
+
+#define MSM_GCC_BASE		IOMEM(0xF0003000)
+#define MSM_GCC_PHYS		0x02082000
+#define MSM_GCC_SIZE		SZ_4K
+
+#define MSM_SHARED_RAM_BASE	IOMEM(0xF0100000)
+#define MSM_SHARED_RAM_SIZE	SZ_1M
+
+#endif
diff --git a/arch/arm/mach-msm/include/mach/msm_iomap.h b/arch/arm/mach-msm/include/mach/msm_iomap.h
index e6b1821..8e24dd8 100644
--- a/arch/arm/mach-msm/include/mach/msm_iomap.h
+++ b/arch/arm/mach-msm/include/mach/msm_iomap.h
@@ -47,8 +47,12 @@
 #include "msm_iomap-7x30.h"
 #elif defined(CONFIG_ARCH_QSD8X50)
 #include "msm_iomap-8x50.h"
+#elif defined(CONFIG_ARCH_MSM8X60)
+#include "msm_iomap-8x60.h"
 #else
 #include "msm_iomap-7x00.h"
 #endif
 
+
+
 #endif
diff --git a/arch/arm/mach-msm/io.c b/arch/arm/mach-msm/io.c
index 1c05060..d36b610 100644
--- a/arch/arm/mach-msm/io.c
+++ b/arch/arm/mach-msm/io.c
@@ -100,6 +100,21 @@ void __init msm_map_qsd8x50_io(void)
 }
 #endif /* CONFIG_ARCH_QSD8X50 */
 
+#ifdef CONFIG_ARCH_MSM8X60
+static struct map_desc msm8x60_io_desc[] __initdata = {
+	MSM_DEVICE(QGIC_DIST),
+	MSM_DEVICE(QGIC_CPU),
+	MSM_DEVICE(TMR),
+	MSM_DEVICE(ACC),
+	MSM_DEVICE(GCC),
+};
+
+void __init msm_map_msm8x60_io(void)
+{
+	iotable_init(msm8x60_io_desc, ARRAY_SIZE(msm8x60_io_desc));
+}
+#endif /* CONFIG_ARCH_MSM8X60 */
+
 #ifdef CONFIG_ARCH_MSM7X30
 static struct map_desc msm7x30_io_desc[] __initdata = {
 	MSM_DEVICE(VIC),
-- 
1.7.2.1

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
