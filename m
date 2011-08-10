Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178Ab1HJMS6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 08:18:58 -0400
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:36458 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753991Ab1HJMSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 08:18:55 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Grant Likely <grant.likely@secretlab.ca>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 18/19] mach-sa1100: move SA1100 GPIO driver to GPIO subsystem
Date: Wed, 10 Aug 2011 14:18:41 +0200
Message-ID: <1312978721-18671-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

As per example from the other ARM boards, push the SA100
GPIO driver down to the GPIO subsystem so it can be consolidated.

Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-sa1100/Makefile                      |    2 +-
 drivers/gpio/Makefile                              |    2 +-
 .../gpio.c => drivers/gpio/gpio-sa1100.c           |    1 -
 3 files changed, 2 insertions(+), 3 deletions(-)
 rename arch/arm/mach-sa1100/gpio.c => drivers/gpio/gpio-sa1100.c (98%)

diff --git a/arch/arm/mach-sa1100/Makefile b/arch/arm/mach-sa1100/Makefile
index 41252d2..73a5c64 100644
--- a/arch/arm/mach-sa1100/Makefile
+++ b/arch/arm/mach-sa1100/Makefile
@@ -3,7 +3,7 @@
 #
 
 # Common support
-obj-y := clock.o generic.o gpio.o irq.o dma.o time.o #nmi-oopser.o
+obj-y := clock.o generic.o irq.o dma.o time.o #nmi-oopser.o
 obj-m :=
 obj-n :=
 obj-  :=
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 7f846bf..6b77473 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -47,7 +47,7 @@ obj-$(CONFIG_GPIO_RDC321X)	+= gpio-rdc321x.o
 obj-$(CONFIG_GPIO_PLAT_SAMSUNG)	+= gpio-plat-samsung.o
 obj-$(CONFIG_GPIO_S5PC100)	+= gpio-s5pc100.o
 obj-$(CONFIG_GPIO_S5PV210)	+= gpio-s5pv210.o
-
+obj-$(CONFIG_ARCH_SA1100)	+= gpio-sa1100.o
 obj-$(CONFIG_GPIO_SCH)		+= gpio-sch.o
 obj-$(CONFIG_GPIO_STMPE)	+= gpio-stmpe.o
 obj-$(CONFIG_GPIO_SX150X)	+= gpio-sx150x.o
diff --git a/arch/arm/mach-sa1100/gpio.c b/drivers/gpio/gpio-sa1100.c
similarity index 98%
rename from arch/arm/mach-sa1100/gpio.c
rename to drivers/gpio/gpio-sa1100.c
index e547ed4..b6c1f6d 100644
--- a/arch/arm/mach-sa1100/gpio.c
+++ b/drivers/gpio/gpio-sa1100.c
@@ -12,7 +12,6 @@
 #include <linux/module.h>
 
 #include <mach/hardware.h>
-#include "generic.h"
 
 static int sa1100_gpio_get(struct gpio_chip *chip, unsigned offset)
 {
-- 
1.7.3.2

