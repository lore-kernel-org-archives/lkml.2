Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab1HJMRY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 08:17:24 -0400
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:45089 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753875Ab1HJMRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 08:17:22 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Grant Likely <grant.likely@secretlab.ca>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>,
        zeal <zealcook@gmail.com>, Daniel Silverstone <dsilvers@simtec.co.uk>,
        Ben Dooks <ben-linux@fluff.org>
Subject: [PATCH 04/19] mach-ks8695: move GPIO driver to GPIO subsystem
Date: Wed, 10 Aug 2011 14:16:49 +0200
Message-ID: <1312978609-18202-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

As per example from the other ARM boards, push the KS8695 GPIO
driver down to the GPIO subsystem so it can be consolidated.

Cc: zeal <zealcook@gmail.com>
Cc: Daniel Silverstone <dsilvers@simtec.co.uk>
Cc: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-ks8695/Makefile                      |    2 +-
 drivers/gpio/Makefile                              |    1 +
 .../gpio.c => drivers/gpio/gpio-ks8695.c           |    0
 3 files changed, 2 insertions(+), 1 deletions(-)
 rename arch/arm/mach-ks8695/gpio.c => drivers/gpio/gpio-ks8695.c (100%)

diff --git a/arch/arm/mach-ks8695/Makefile b/arch/arm/mach-ks8695/Makefile
index 7e3e816..853efd9 100644
--- a/arch/arm/mach-ks8695/Makefile
+++ b/arch/arm/mach-ks8695/Makefile
@@ -3,7 +3,7 @@
 # Makefile for KS8695 architecture support
 #
 
-obj-y				:= cpu.o irq.o time.o gpio.o devices.o
+obj-y				:= cpu.o irq.o time.o devices.o
 obj-m				:=
 obj-n				:=
 obj-				:=
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 9588948..27295cb 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -18,6 +18,7 @@ obj-$(CONFIG_GPIO_EP93XX)	+= gpio-ep93xx.o
 obj-$(CONFIG_GPIO_EXYNOS4)	+= gpio-exynos4.o
 obj-$(CONFIG_GPIO_IT8761E)	+= gpio-it8761e.o
 obj-$(CONFIG_GPIO_JANZ_TTL)	+= gpio-janz-ttl.o
+obj-$(CONFIG_MACH_KS8695)	+= gpio-ks8695.o
 obj-$(CONFIG_GPIO_LANGWELL)	+= gpio-langwell.o
 obj-$(CONFIG_GPIO_MAX730X)	+= gpio-max730x.o
 obj-$(CONFIG_GPIO_MAX7300)	+= gpio-max7300.o
diff --git a/arch/arm/mach-ks8695/gpio.c b/drivers/gpio/gpio-ks8695.c
similarity index 100%
rename from arch/arm/mach-ks8695/gpio.c
rename to drivers/gpio/gpio-ks8695.c
-- 
1.7.3.2

