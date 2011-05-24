Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757578Ab1EXVHN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 17:07:13 -0400
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:58272 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757564Ab1EXVHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 17:07:11 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Grant Likely <grant.likely@secretlab.ca>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 2/4] gpio: move Nomadik GPIO driver to drivers/gpio
Date: Tue, 24 May 2011 23:07:01 +0200
Message-ID: <1306271221-28978-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This moves the Nomadik GPIO driver out of arch/arm/plat-nomadik
and into the desired location indicated by the subsystem
maintainer.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/plat-nomadik/Kconfig                      |    5 -----
 arch/arm/plat-nomadik/Makefile                     |    1 -
 drivers/gpio/Makefile                              |    1 +
 .../gpio.c => drivers/gpio/gpio-nomadik.c          |    0
 4 files changed, 1 insertions(+), 6 deletions(-)
 rename arch/arm/plat-nomadik/gpio.c => drivers/gpio/gpio-nomadik.c (100%)

diff --git a/arch/arm/plat-nomadik/Kconfig b/arch/arm/plat-nomadik/Kconfig
index 18296ee..ce65901 100644
--- a/arch/arm/plat-nomadik/Kconfig
+++ b/arch/arm/plat-nomadik/Kconfig
@@ -21,9 +21,4 @@ config HAS_MTU
 	  to multiple interrupt generating programmable
 	  32-bit free running decrementing counters.
 
-config NOMADIK_GPIO
-	bool
-	help
-	  Support for the Nomadik GPIO controller.
-
 endif
diff --git a/arch/arm/plat-nomadik/Makefile b/arch/arm/plat-nomadik/Makefile
index c335473..37c7cdd 100644
--- a/arch/arm/plat-nomadik/Makefile
+++ b/arch/arm/plat-nomadik/Makefile
@@ -3,4 +3,3 @@
 # Licensed under GPLv2
 
 obj-$(CONFIG_HAS_MTU)	+= timer.o
-obj-$(CONFIG_NOMADIK_GPIO)	+= gpio.o
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 7245d7d..6c2c3ad 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -38,6 +38,7 @@ obj-$(CONFIG_GPIO_WM8350)	+= wm8350-gpiolib.o
 obj-$(CONFIG_GPIO_WM8994)	+= wm8994-gpio.o
 obj-$(CONFIG_GPIO_SCH)		+= sch_gpio.o
 obj-$(CONFIG_MACH_U300)		+= gpio-u300.o
+obj-$(CONFIG_PLAT_NOMADIK)	+= gpio-nomadik.o
 obj-$(CONFIG_GPIO_RDC321X)	+= rdc321x-gpio.o
 obj-$(CONFIG_GPIO_JANZ_TTL)	+= janz-ttl.o
 obj-$(CONFIG_GPIO_SX150X)	+= sx150x.o
diff --git a/arch/arm/plat-nomadik/gpio.c b/drivers/gpio/gpio-nomadik.c
similarity index 100%
rename from arch/arm/plat-nomadik/gpio.c
rename to drivers/gpio/gpio-nomadik.c
-- 
1.7.3.2

