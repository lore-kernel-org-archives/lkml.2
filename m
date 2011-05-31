Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575Ab1EaMzx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 08:55:53 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:50697 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334Ab1EaMzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 08:55:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=JibbX7t7daIkhnCm9pYN2ntDgqlCzKPgC0e2LgvNhoP/+uqSlQzIh6JXqo7aygMseA
         r7xeA658Ot28dssWCDdyXjLKJbCFzOcO1UflQvmgfrSWBF39T7nKsiu+ODZC8E1OF7qj
         WNekaMJX/9h8NoLlhl+ynuPafVWq3ilrHHGH4=
Subject: [PATCH v2] ARM: OMAP2: Add missing include of linux/gpio.h
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Syed Mohammed Khasim <x0khasim@ti.com>,
        Grazvydas Ignotas <notasas@gmail.com>,
        Steve Sakoman <steve@sakoman.com>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 31 May 2011 20:55:44 +0800
Message-ID: <1306846544.30148.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got some build error like below while executing "make omap2plus_defconfig".

  CC      arch/arm/mach-omap2/board-2430sdp.o
arch/arm/mach-omap2/board-2430sdp.c: In function 'omap_2430sdp_init':
arch/arm/mach-omap2/board-2430sdp.c:247: error: 'GPIOF_OUT_INIT_LOW' undeclared (first use in this function)
arch/arm/mach-omap2/board-2430sdp.c:247: error: (Each undeclared identifier is reported only once
arch/arm/mach-omap2/board-2430sdp.c:247: error: for each function it appears in.)

This patch fixes the build error by include linux/gpio.h instead of mach/gpio.h.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Syed Mohammed Khasim <x0khasim@ti.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Grazvydas Ignotas <notasas@gmail.com>
Cc: Steve Sakoman <steve@sakoman.com>
---
 arch/arm/mach-omap2/board-2430sdp.c      |    2 +-
 arch/arm/mach-omap2/board-apollon.c      |    2 +-
 arch/arm/mach-omap2/board-omap3pandora.c |    2 +-
 arch/arm/mach-omap2/board-overo.c        |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-omap2/board-2430sdp.c b/arch/arm/mach-omap2/board-2430sdp.c
index d54969b..5de6eac 100644
--- a/arch/arm/mach-omap2/board-2430sdp.c
+++ b/arch/arm/mach-omap2/board-2430sdp.c
@@ -26,13 +26,13 @@
 #include <linux/err.h>
 #include <linux/clk.h>
 #include <linux/io.h>
+#include <linux/gpio.h>
 
 #include <mach/hardware.h>
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
 
-#include <mach/gpio.h>
 #include <plat/board.h>
 #include <plat/common.h>
 #include <plat/gpmc.h>
diff --git a/arch/arm/mach-omap2/board-apollon.c b/arch/arm/mach-omap2/board-apollon.c
index f3beb8e..b124bdf 100644
--- a/arch/arm/mach-omap2/board-apollon.c
+++ b/arch/arm/mach-omap2/board-apollon.c
@@ -27,13 +27,13 @@
 #include <linux/err.h>
 #include <linux/clk.h>
 #include <linux/smc91x.h>
+#include <linux/gpio.h>
 
 #include <mach/hardware.h>
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/flash.h>
 
-#include <mach/gpio.h>
 #include <plat/led.h>
 #include <plat/usb.h>
 #include <plat/board.h>
diff --git a/arch/arm/mach-omap2/board-omap3pandora.c b/arch/arm/mach-omap2/board-omap3pandora.c
index 1d10736..5ee034a 100644
--- a/arch/arm/mach-omap2/board-omap3pandora.c
+++ b/arch/arm/mach-omap2/board-omap3pandora.c
@@ -30,6 +30,7 @@
 #include <linux/leds.h>
 #include <linux/input.h>
 #include <linux/input/matrix_keypad.h>
+#include <linux/gpio.h>
 #include <linux/gpio_keys.h>
 #include <linux/mmc/host.h>
 #include <linux/mmc/card.h>
@@ -41,7 +42,6 @@
 
 #include <plat/board.h>
 #include <plat/common.h>
-#include <mach/gpio.h>
 #include <mach/hardware.h>
 #include <plat/mcspi.h>
 #include <plat/usb.h>
diff --git a/arch/arm/mach-omap2/board-overo.c b/arch/arm/mach-omap2/board-overo.c
index 1555918..9952c20 100644
--- a/arch/arm/mach-omap2/board-overo.c
+++ b/arch/arm/mach-omap2/board-overo.c
@@ -24,6 +24,7 @@
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/io.h>
+#include <linux/gpio.h>
 #include <linux/kernel.h>
 #include <linux/platform_device.h>
 #include <linux/i2c/twl.h>
@@ -45,7 +46,6 @@
 #include <plat/common.h>
 #include <video/omapdss.h>
 #include <video/omap-panel-generic-dpi.h>
-#include <mach/gpio.h>
 #include <plat/gpmc.h>
 #include <mach/hardware.h>
 #include <plat/nand.h>
-- 
1.7.4.1



