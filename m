Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756065Ab2IBMZ7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 08:25:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41289 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab2IBMZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 08:25:58 -0400
Message-ID: <1346588747.7909.2.camel@phoenix>
Subject: [PATCH] ARM: ux500: Fix build error due to missing include of
 asm/pmu.h in cpu-db8500.c
From: Axel Lin <axel.lin@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Sun, 02 Sep 2012 20:25:47 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include asm/pmu.h to fix below build error:

  CC      arch/arm/mach-ux500/cpu-db8500.o
arch/arm/mach-ux500/cpu-db8500.c:118:8: error: variable 'db8500_pmu_platdata' has initializer but incomplete type
arch/arm/mach-ux500/cpu-db8500.c:119:2: error: unknown field 'handle_irq' specified in initializer
arch/arm/mach-ux500/cpu-db8500.c:119:2: warning: excess elements in struct initializer [enabled by default]
arch/arm/mach-ux500/cpu-db8500.c:119:2: warning: (near initialization for 'db8500_pmu_platdata') [enabled by default]
make[1]: *** [arch/arm/mach-ux500/cpu-db8500.o] Error 1
make: *** [arch/arm/mach-ux500] Error 2

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 arch/arm/mach-ux500/cpu-db8500.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-ux500/cpu-db8500.c b/arch/arm/mach-ux500/cpu-db8500.c
index 8169f2c..3ce7d94 100644
--- a/arch/arm/mach-ux500/cpu-db8500.c
+++ b/arch/arm/mach-ux500/cpu-db8500.c
@@ -18,6 +18,7 @@
 #include <linux/io.h>
 #include <linux/mfd/abx500/ab8500.h>
 
+#include <asm/pmu.h>
 #include <asm/mach/map.h>
 #include <plat/gpio-nomadik.h>
 #include <mach/hardware.h>
-- 
1.7.9.5



