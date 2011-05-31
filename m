Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704Ab1EaMnL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 08:43:11 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:59604 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532Ab1EaMnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 08:43:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=dPY5ewqJiFb/CzSogLe4yPj+InHmavCh/X0Ls1vWpG7Y2e0gPvU/SPk/ZtqABvXHUd
         UDNPzBhLS7ajZ1/HVxIAHpitz6ucPLoEhbN9wmE1EsjVqf2vdHrS3wtXORL6CCdkXnQY
         IllybVsM3LK4k6pY+6jTCeU4dW5VabKxwMpVY=
Subject: [PATCH] ARM: OMAP2: Add missing include of linux/gpio.h
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Syed Mohammed Khasim <x0khasim@ti.com>,
        Grazvydas Ignotas <notasas@gmail.com>,
        Steve Sakoman <steve@sakoman.com>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 31 May 2011 20:42:49 +0800
Message-ID: <1306845769.27719.1.camel@phoenix>
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
make[1]: *** [arch/arm/mach-omap2/board-2430sdp.o] Error 1
make: *** [arch/arm/mach-omap2] Error 2

This patch fixes the build error.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Cc: Syed Mohammed Khasim <x0khasim@ti.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Grazvydas Ignotas <notasas@gmail.com>
Cc: Steve Sakoman <steve@sakoman.com>
---
 arch/arm/mach-omap2/board-2430sdp.c      |    1 +
 arch/arm/mach-omap2/board-apollon.c      |    1 +
 arch/arm/mach-omap2/board-omap3pandora.c |    1 +
 arch/arm/mach-omap2/board-overo.c        |    1 +
 4 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/board-2430sdp.c b/arch/arm/mach-omap2/board-2430sdp.c
index d54969b..329b95c 100644
--- a/arch/arm/mach-omap2/board-2430sdp.c
+++ b/arch/arm/mach-omap2/board-2430sdp.c
@@ -26,6 +26,7 @@
 #include <linux/err.h>
 #include <linux/clk.h>
 #include <linux/io.h>
+#include <linux/gpio.h>
 
 #include <mach/hardware.h>
 #include <asm/mach-types.h>
diff --git a/arch/arm/mach-omap2/board-apollon.c b/arch/arm/mach-omap2/board-apollon.c
index f3beb8e..41f07b0 100644
--- a/arch/arm/mach-omap2/board-apollon.c
+++ b/arch/arm/mach-omap2/board-apollon.c
@@ -27,6 +27,7 @@
 #include <linux/err.h>
 #include <linux/clk.h>
 #include <linux/smc91x.h>
+#include <linux/gpio.h>
 
 #include <mach/hardware.h>
 #include <asm/mach-types.h>
diff --git a/arch/arm/mach-omap2/board-omap3pandora.c b/arch/arm/mach-omap2/board-omap3pandora.c
index 1d10736..89d5fba 100644
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
diff --git a/arch/arm/mach-omap2/board-overo.c b/arch/arm/mach-omap2/board-overo.c
index 1555918..5942aa5 100644
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
-- 
1.7.4.1



