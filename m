Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687Ab1GFQbf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 12:31:35 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:18533
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754662Ab1GFQbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 12:31:32 -0400
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275dhz2dh87h2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Shawn Guo <shawn.guo@linaro.org>
To: <linux-kernel@vger.kernel.org>
CC: <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <patches@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH v3 2/3] ARM: mxc: use ARCH_NR_GPIOS to define gpio number
Date: Thu, 7 Jul 2011 00:37:42 +0800
Message-ID: <1309970263-13239-3-git-send-email-shawn.guo@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1309970263-13239-1-git-send-email-shawn.guo@linaro.org>
References: <1309970263-13239-1-git-send-email-shawn.guo@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch removes MXC_GPIO_IRQS and instead uses ARCH_NR_GPIOS to
define gpio number.  This change is need when we change mxc gpio
driver to be device tree aware.  When migrating the driver to device
tree, pdev->id becomes unusable.  It requires driver get gpio range
from gpio core, which will dynamically allocates number from
ARCH_NR_GPIOS to 0.

As a bonus point, it removes lines of '#if' and make the code a
little bit cleaner.  The side effect is the waste of number.  But
this is not a point when we go single image.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Grant Likely <grant.likely@secretlab.ca>
---
 arch/arm/plat-mxc/include/mach/irqs.h |   21 +++------------------
 1 files changed, 3 insertions(+), 18 deletions(-)

diff --git a/arch/arm/plat-mxc/include/mach/irqs.h b/arch/arm/plat-mxc/include/mach/irqs.h
index 35c89bc..00e812b 100644
--- a/arch/arm/plat-mxc/include/mach/irqs.h
+++ b/arch/arm/plat-mxc/include/mach/irqs.h
@@ -11,6 +11,8 @@
 #ifndef __ASM_ARCH_MXC_IRQS_H__
 #define __ASM_ARCH_MXC_IRQS_H__
 
+#include <asm-generic/gpio.h>
+
 /*
  * SoCs with TZIC interrupt controller have 128 IRQs, those with AVIC have 64
  */
@@ -22,30 +24,13 @@
 
 #define MXC_GPIO_IRQ_START	MXC_INTERNAL_IRQS
 
-/* these are ordered by size to support multi-SoC kernels */
-#if defined CONFIG_SOC_IMX53
-#define MXC_GPIO_IRQS		(32 * 7)
-#elif defined CONFIG_ARCH_MX2
-#define MXC_GPIO_IRQS		(32 * 6)
-#elif defined CONFIG_SOC_IMX50
-#define MXC_GPIO_IRQS		(32 * 6)
-#elif defined CONFIG_ARCH_MX1
-#define MXC_GPIO_IRQS		(32 * 4)
-#elif defined CONFIG_ARCH_MX25
-#define MXC_GPIO_IRQS		(32 * 4)
-#elif defined CONFIG_SOC_IMX51
-#define MXC_GPIO_IRQS		(32 * 4)
-#elif defined CONFIG_ARCH_MX3
-#define MXC_GPIO_IRQS		(32 * 3)
-#endif
-
 /*
  * The next 16 interrupts are for board specific purposes.  Since
  * the kernel can only run on one machine at a time, we can re-use
  * these.  If you need more, increase MXC_BOARD_IRQS, but keep it
  * within sensible limits.
  */
-#define MXC_BOARD_IRQ_START	(MXC_INTERNAL_IRQS + MXC_GPIO_IRQS)
+#define MXC_BOARD_IRQ_START	(MXC_INTERNAL_IRQS + ARCH_NR_GPIOS)
 
 #ifdef CONFIG_MACH_MX31ADS_WM1133_EV1
 #define MXC_BOARD_IRQS  80
-- 
1.7.4.1


