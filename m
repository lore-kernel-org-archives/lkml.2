Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732Ab2EHKSO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 06:18:14 -0400
Received: from mga03.intel.com ([143.182.124.21]:33656 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753203Ab2EHKSK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 06:18:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="140264858"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>,
        MIPS Mailing List <linux-mips@linux-mips.org>
Cc: Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: [PATCH] mips: bcm63xx: fix compilation problems
Date: Tue,  8 May 2012 13:19:07 +0300
Message-Id: <1336472347-25822-1-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

I get the following build error when I am compiling the MTD gpio-nand driver
for bcm63xx:

In file included from arch/mips/include/asm/mach-bcm63xx/gpio.h:4:0,
                 from arch/mips/include/asm/gpio.h:4,
                 from include/linux/gpio.h:36,
                 from drivers/mtd/maps/gpio-addr-flash.c:16:
arch/mips/include/asm/mach-bcm63xx/bcm63xx_gpio.h: In function 'bcm63xx_gpio_count':
arch/mips/include/asm/mach-bcm63xx/bcm63xx_gpio.h:10:2: error: implicit declaration of function 'bcm63xx_get_cpu_id' [-Werror=implicit-function-declaration]
arch/mips/include/asm/mach-bcm63xx/bcm63xx_gpio.h:11:7: error: 'BCM6358_CPU_ID' undeclared (first use in this function)
arch/mips/include/asm/mach-bcm63xx/bcm63xx_gpio.h:11:7: note: each undeclared identifier is reported only once for each function it appears in
arch/mips/include/asm/mach-bcm63xx/bcm63xx_gpio.h:13:7: error: 'BCM6338_CPU_ID' undeclared (first use in this function)
arch/mips/include/asm/mach-bcm63xx/bcm63xx_gpio.h:15:7: error: 'BCM6345_CPU_ID' undeclared (first use in this function)
arch/mips/include/asm/mach-bcm63xx/bcm63xx_gpio.h:17:7: error: 'BCM6368_CPU_ID' undeclared (first use in this function)
arch/mips/include/asm/mach-bcm63xx/bcm63xx_gpio.h:19:7: error: 'BCM6348_CPU_ID' undeclared (first use in this function)

This patch sloves the problem.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 arch/mips/include/asm/mach-bcm63xx/bcm63xx_gpio.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/mips/include/asm/mach-bcm63xx/bcm63xx_gpio.h b/arch/mips/include/asm/mach-bcm63xx/bcm63xx_gpio.h
index 3d5de96..b4b9103 100644
--- a/arch/mips/include/asm/mach-bcm63xx/bcm63xx_gpio.h
+++ b/arch/mips/include/asm/mach-bcm63xx/bcm63xx_gpio.h
@@ -1,6 +1,7 @@
 #ifndef BCM63XX_GPIO_H
 #define BCM63XX_GPIO_H
 
+#include "bcm63xx_cpu.h"
 #include <linux/init.h>
 
 int __init bcm63xx_gpio_init(void);
-- 
1.7.9.1

