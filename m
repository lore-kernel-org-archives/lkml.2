Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561Ab1D1HSz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 03:18:55 -0400
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:46068 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753963Ab1D1HSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 03:18:54 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Grant Likely <grant.likely@secretlab.ca>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] gpio: remove some legacy comments in build files
Date: Thu, 28 Apr 2011 09:18:37 +0200
Message-ID: <1303975117-20651-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

The build files for drivers/gpio has some wording and comments
about the directory being reserved exclusively for GPIO expanders
(according to the gpio.txt file these are on external busses) and
this has been false for some time. We already have PL061 and
Xilinx drivers which are in silicon and now I'm moving more
silicon drivers here, so delete this and reword it a bit.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/gpio/Kconfig  |    8 ++++----
 drivers/gpio/Makefile |    6 +-----
 2 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index c23401f..b7fac15 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -1,5 +1,5 @@
 #
-# platform-neutral GPIO infrastructure and expanders
+# GPIO infrastructure and drivers
 #
 
 config ARCH_WANT_OPTIONAL_GPIOLIB
@@ -31,7 +31,7 @@ menuconfig GPIOLIB
 	help
 	  This enables GPIO support through the generic GPIO library.
 	  You only need to enable this, if you also want to enable
-	  one or more of the GPIO expansion card drivers below.
+	  one or more of the GPIO drivers below.
 
 	  If unsure, say N.
 
@@ -63,12 +63,12 @@ config GPIO_SYSFS
 	  Kernel drivers may also request that a particular GPIO be
 	  exported to userspace; this can be useful when debugging.
 
-# put expanders in the right section, in alphabetical order
+# put drivers in the right section, in alphabetical order
 
 config GPIO_MAX730X
 	tristate
 
-comment "Memory mapped GPIO expanders:"
+comment "Memory mapped GPIO drivers:"
 
 config GPIO_BASIC_MMIO
 	tristate "Basic memory-mapped GPIO controllers support"
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index e4851c5..cfbdef1 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -1,8 +1,4 @@
-# generic gpio support: dedicated expander chips, etc
-#
-# NOTE: platform-specific GPIO drivers don't belong in the
-# drivers/gpio directory; put them with other platform setup
-# code, IRQ controllers, board init, etc.
+# generic gpio support: platform drivers, dedicated expander chips, etc
 
 ccflags-$(CONFIG_DEBUG_GPIO)	+= -DDEBUG
 
-- 
1.7.3.2

