Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198Ab2G1GNH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2012 02:13:07 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:56877 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719Ab2G1GNG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2012 02:13:06 -0400
From: Chandrabhanu Mahapatra <cmahapatra@ti.com>
To: <linus.walleij@stericsson.com>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>, <tony@atomide.com>
CC: <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <leed.aguilar@ti.com>, Chandrabhanu Mahapatra <cmahapatra@ti.com>
Subject: [PATCH V1 3/3] OMAP: Define TCA6424 max number of possible IRQs
Date: Sat, 28 Jul 2012 11:40:05 +0530
Message-ID: <03736c1b42a7e28fc0b47aabd5c0f019edb1baf2.1343026861.git.cmahapatra@ti.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1343026861.git.cmahapatra@ti.com>
References: <cover.1341925681.git.cmahapatra@ti.com> <cover.1343026861.git.cmahapatra@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Leed Aguilar <leed.aguilar@ti.com>

TCA6424 being a 24 bit I2C and SMBus I/O expander has 24 available GPIO lines
that can be used as IRQs lines. So, the support for 24 more IRQ lines has been
added to the kernel.

Signed-off-by: Leed Aguilar <leed.aguilar@ti.com>
Signed-off-by: Chandrabhanu Mahapatra <cmahapatra@ti.com>
---
 arch/arm/plat-omap/include/plat/irqs.h |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/arm/plat-omap/include/plat/irqs.h b/arch/arm/plat-omap/include/plat/irqs.h
index 37bbbbb..97c71ba 100644
--- a/arch/arm/plat-omap/include/plat/irqs.h
+++ b/arch/arm/plat-omap/include/plat/irqs.h
@@ -378,8 +378,17 @@
 #endif
 #define OMAP_FPGA_IRQ_END	(OMAP_FPGA_IRQ_BASE + OMAP_FPGA_NR_IRQS)
 
+/* TCA6424A I2C and SMBus I/O expander */
+#define OMAP_TCA6424_IRQ_BASE	(OMAP_FPGA_IRQ_END)
+#ifdef CONFIG_GPIO_PCA953X
+#define OMAP_TCA6424_NR_IRQS	24
+#else
+#define OMAP_TCA6424_NR_IRQS	0
+#endif
+#define OMAP_TCA6424_IRQ_END	(OMAP_TCA6424_IRQ_BASE + OMAP_TCA6424_NR_IRQS)
+
 /* External TWL4030 can handle interrupts on 2430 and 34xx boards */
-#define	TWL4030_IRQ_BASE	(OMAP_FPGA_IRQ_END)
+#define	TWL4030_IRQ_BASE	(OMAP_TCA6424_IRQ_END)
 #ifdef	CONFIG_TWL4030_CORE
 #define	TWL4030_BASE_NR_IRQS	8
 #define	TWL4030_PWR_NR_IRQS	8
-- 
1.7.10

