Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200Ab1HJMSN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 08:18:13 -0400
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:39663 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754105Ab1HJMSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 08:18:11 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Grant Likely <grant.likely@secretlab.ca>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <w.sang@pengutronix.de>, Barry Song <bs14@csr.com>
Subject: [PATCH 12/19] mach-lpc32xx: move LPC32XX GPIO driver to GPIO subsystem
Date: Wed, 10 Aug 2011 14:17:51 +0200
Message-ID: <1312978671-18473-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

As per example from the other ARM boards, push the LPC32XX
GPIO driver down to the GPIO subsystem so it can be consolidated.

Cc: Wolfram Sang <w.sang@pengutronix.de>
Cc: Barry Song <bs14@csr.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-lpc32xx/Makefile                     |    2 +-
 drivers/gpio/Makefile                              |    1 +
 .../gpiolib.c => drivers/gpio/gpio-lpc32xx.c       |    1 -
 3 files changed, 2 insertions(+), 2 deletions(-)
 rename arch/arm/mach-lpc32xx/gpiolib.c => drivers/gpio/gpio-lpc32xx.c (99%)

diff --git a/arch/arm/mach-lpc32xx/Makefile b/arch/arm/mach-lpc32xx/Makefile
index a5fc5d0..f5db805 100644
--- a/arch/arm/mach-lpc32xx/Makefile
+++ b/arch/arm/mach-lpc32xx/Makefile
@@ -3,6 +3,6 @@
 #
 
 obj-y	:= timer.o irq.o common.o serial.o clock.o
-obj-y	+= gpiolib.o pm.o suspend.o
+obj-y	+= pm.o suspend.o
 obj-y	+= phy3250.o
 
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 2269822..33e095bd 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -21,6 +21,7 @@ obj-$(CONFIG_GPIO_IT8761E)	+= gpio-it8761e.o
 obj-$(CONFIG_GPIO_JANZ_TTL)	+= gpio-janz-ttl.o
 obj-$(CONFIG_MACH_KS8695)	+= gpio-ks8695.o
 obj-$(CONFIG_GPIO_LANGWELL)	+= gpio-langwell.o
+obj-$(CONFIG_ARCH_LPC32XX)	+= gpio-lpc32xx.o
 obj-$(CONFIG_GPIO_MAX730X)	+= gpio-max730x.o
 obj-$(CONFIG_GPIO_MAX7300)	+= gpio-max7300.o
 obj-$(CONFIG_GPIO_MAX7301)	+= gpio-max7301.o
diff --git a/arch/arm/mach-lpc32xx/gpiolib.c b/drivers/gpio/gpio-lpc32xx.c
similarity index 99%
rename from arch/arm/mach-lpc32xx/gpiolib.c
rename to drivers/gpio/gpio-lpc32xx.c
index 69061ea..b4e9d35 100644
--- a/arch/arm/mach-lpc32xx/gpiolib.c
+++ b/drivers/gpio/gpio-lpc32xx.c
@@ -24,7 +24,6 @@
 
 #include <mach/hardware.h>
 #include <mach/platform.h>
-#include "common.h"
 
 #define LPC32XX_GPIO_P3_INP_STATE		_GPREG(0x000)
 #define LPC32XX_GPIO_P3_OUTP_SET		_GPREG(0x004)
-- 
1.7.3.2

