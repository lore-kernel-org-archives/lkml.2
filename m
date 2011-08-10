Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281Ab1HJMSu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 08:18:50 -0400
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:32935 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754259Ab1HJMSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 08:18:48 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Grant Likely <grant.likely@secretlab.ca>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>,
        Vitaly Wool <vitalywool@gmail.com>
Subject: [PATCH 17/19] mach-pnx4008: rename GPIO header
Date: Wed, 10 Aug 2011 14:18:33 +0200
Message-ID: <1312978714-18638-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

The PNX4008 header file is using the generic gpio and gpiolib
namespace in <mach/gpio.h> yet the GPIO interface is not generic
at all so rename it to <mach/gpio-pnx4008.h>

Cc: Vitaly Wool <vitalywool@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 .../include/mach/{gpio.h => gpio-pnx4008.h}        |    0
 arch/arm/mach-pnx4008/serial.c                     |    2 +-
 drivers/gpio/gpio-pnx4008.c                        |    2 +-
 3 files changed, 2 insertions(+), 2 deletions(-)
 rename arch/arm/mach-pnx4008/include/mach/{gpio.h => gpio-pnx4008.h} (100%)

diff --git a/arch/arm/mach-pnx4008/include/mach/gpio.h b/arch/arm/mach-pnx4008/include/mach/gpio-pnx4008.h
similarity index 100%
rename from arch/arm/mach-pnx4008/include/mach/gpio.h
rename to arch/arm/mach-pnx4008/include/mach/gpio-pnx4008.h
diff --git a/arch/arm/mach-pnx4008/serial.c b/arch/arm/mach-pnx4008/serial.c
index eb29fac..374c138 100644
--- a/arch/arm/mach-pnx4008/serial.c
+++ b/arch/arm/mach-pnx4008/serial.c
@@ -9,7 +9,6 @@
  *  it under the terms of the GNU General Public License version 2 as
  *  published by the Free Software Foundation.
  */
-#include <linux/gpio.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/io.h>
@@ -20,6 +19,7 @@
 #include <linux/serial_core.h>
 #include <linux/serial_reg.h>
 
+#include <mach/gpio-pnx4008.h>
 #include <mach/clock.h>
 
 #define UART_3		0
diff --git a/drivers/gpio/gpio-pnx4008.c b/drivers/gpio/gpio-pnx4008.c
index eef531b..d3e71d3 100644
--- a/drivers/gpio/gpio-pnx4008.c
+++ b/drivers/gpio/gpio-pnx4008.c
@@ -13,13 +13,13 @@
  * is licensed "as is" without any warranty of any kind, whether express
  * or implied.
  */
-#include <linux/gpio.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/io.h>
 #include <mach/hardware.h>
 #include <mach/platform.h>
+#include <mach/gpio-pnx4008.h>
 
 /* register definitions */
 #define PIO_VA_BASE	IO_ADDRESS(PNX4008_PIO_BASE)
-- 
1.7.3.2

