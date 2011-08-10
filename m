Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144Ab1HJMU2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 08:20:28 -0400
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:48981 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753969Ab1HJMRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 08:17:24 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Grant Likely <grant.likely@secretlab.ca>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>,
        Sekhar Nori <nsekhar@ti.com>, Kevin Hilman <khilman@ti.com>
Subject: [PATCH 07/19] mach-davinci: move GPIO driver to GPIO subsystem
Date: Wed, 10 Aug 2011 14:17:11 +0200
Message-ID: <1312978631-18306-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

As per example from the other ARM boards, push the DaVinci GPIO
driver down to the GPIO subsystem so it can be consolidated.

Cc: Sekhar Nori <nsekhar@ti.com>
Cc: Kevin Hilman <khilman@ti.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-davinci/Makefile                     |    2 +-
 drivers/gpio/Makefile                              |    1 +
 .../gpio.c => drivers/gpio/gpio-davinci.c          |    0
 3 files changed, 2 insertions(+), 1 deletions(-)
 rename arch/arm/mach-davinci/gpio.c => drivers/gpio/gpio-davinci.c (100%)

diff --git a/arch/arm/mach-davinci/Makefile b/arch/arm/mach-davinci/Makefile
index 0b87a1c..8f3c8ee 100644
--- a/arch/arm/mach-davinci/Makefile
+++ b/arch/arm/mach-davinci/Makefile
@@ -5,7 +5,7 @@
 
 # Common objects
 obj-y 			:= time.o clock.o serial.o io.o psc.o \
-			   gpio.o dma.o usb.o common.o sram.o aemif.o
+			   dma.o usb.o common.o sram.o aemif.o
 
 obj-$(CONFIG_DAVINCI_MUX)		+= mux.o
 
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 27295cb..a26fffa 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -14,6 +14,7 @@ obj-$(CONFIG_GPIO_ADP5588)	+= gpio-adp5588.o
 obj-$(CONFIG_GPIO_BT8XX)	+= gpio-bt8xx.o
 obj-$(CONFIG_GPIO_CS5535)	+= gpio-cs5535.o
 obj-$(CONFIG_GPIO_DA9052)	+= gpio-da9052.o
+obj-$(CONFIG_ARCH_DAVINCI)	+= gpio-davinci.o
 obj-$(CONFIG_GPIO_EP93XX)	+= gpio-ep93xx.o
 obj-$(CONFIG_GPIO_EXYNOS4)	+= gpio-exynos4.o
 obj-$(CONFIG_GPIO_IT8761E)	+= gpio-it8761e.o
diff --git a/arch/arm/mach-davinci/gpio.c b/drivers/gpio/gpio-davinci.c
similarity index 100%
rename from arch/arm/mach-davinci/gpio.c
rename to drivers/gpio/gpio-davinci.c
-- 
1.7.3.2

