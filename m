Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856Ab2IFXkh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 19:40:37 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63688 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755751Ab2IFXke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 19:40:34 -0400
Message-ID: <5049346B.5020205@gmail.com>
Date: Fri, 07 Sep 2012 09:40:27 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: Hartley Sweeten <hsweeten@visionengravers.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: ep93xx: Fix build error due to 'SZ_32M' undeclared
References: <1346675368.15950.0.camel@phoenix>
In-Reply-To: <1346675368.15950.0.camel@phoenix>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/12 22:29, Axel Lin wrote:
> Include linux/sizes.h to fix below build errors:
>
>   CC      arch/arm/mach-ep93xx/adssphere.o
> arch/arm/mach-ep93xx/adssphere.c: In function 'adssphere_init_machine':
> arch/arm/mach-ep93xx/adssphere.c:32:49: error: 'SZ_32M' undeclared (first use in this function)
> arch/arm/mach-ep93xx/adssphere.c:32:49: note: each undeclared identifier is reported only once for each function it appears in
> make[1]: *** [arch/arm/mach-ep93xx/adssphere.o] Error 1
> make: *** [arch/arm/mach-ep93xx] Error 2
>
>   CC      arch/arm/mach-ep93xx/gesbc9312.o
> arch/arm/mach-ep93xx/gesbc9312.c: In function 'gesbc9312_init_machine':
> arch/arm/mach-ep93xx/gesbc9312.c:32:49: error: 'SZ_8M' undeclared (first use in this function)
> arch/arm/mach-ep93xx/gesbc9312.c:32:49: note: each undeclared identifier is reported only once for each function it appears in
> make[1]: *** [arch/arm/mach-ep93xx/gesbc9312.o] Error 1
> make: *** [arch/arm/mach-ep93xx] Error 2
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Hi Axel,

The patch looks fine. I notice that the other ep93xx boards are also
using the SZ_ defines, but are indirectly including linux/sizes.h via
asm/memory.h, which in turn is indirectly included via asm/io.h. That
seems a bit flaky, so I wonder if we should just explicitly include
<linux/sizes.h> in all the board files which use the SZ_ macros as per
the patch below. Thoughts?

~Ryan

---
    ARM: ep93xx: Fix build error due to 'SZ_32M' undeclared
    
    Include linux/sizes.h to fix below build errors:
    
      CC      arch/arm/mach-ep93xx/adssphere.o
    arch/arm/mach-ep93xx/adssphere.c: In function 'adssphere_init_machine':
    arch/arm/mach-ep93xx/adssphere.c:32:49: error: 'SZ_32M' undeclared (first use in this function)
    arch/arm/mach-ep93xx/adssphere.c:32:49: note: each undeclared identifier is reported only once for each function it appears in
    make[1]: *** [arch/arm/mach-ep93xx/adssphere.o] Error 1
    make: *** [arch/arm/mach-ep93xx] Error 2
    
      CC      arch/arm/mach-ep93xx/gesbc9312.o
    arch/arm/mach-ep93xx/gesbc9312.c: In function 'gesbc9312_init_machine':
    arch/arm/mach-ep93xx/gesbc9312.c:32:49: error: 'SZ_8M' undeclared (first use in this function)
    arch/arm/mach-ep93xx/gesbc9312.c:32:49: note: each undeclared identifier is reported only once for each function it appears in
    make[1]: *** [arch/arm/mach-ep93xx/gesbc9312.o] Error 1
    make: *** [arch/arm/mach-ep93xx] Error 2
    
    Also explicitly include linux/sizes.h on the other ep93xx which use
    the SZ_ macros and are currently indirectly including linux/sizes.h
    via asm/memory.h, which is included via asm/io.h.
    
    Signed-off-by: Axel Lin <axel.lin@gmail.com>
    Signed-off-by: Ryan Mallon <rmallon@gmail.com>

diff --git a/arch/arm/mach-ep93xx/adssphere.c b/arch/arm/mach-ep93xx/adssphere.c
index a472777..41383bf 100644
--- a/arch/arm/mach-ep93xx/adssphere.c
+++ b/arch/arm/mach-ep93xx/adssphere.c
@@ -13,6 +13,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
+#include <linux/sizes.h>
 
 #include <mach/hardware.h>
 
diff --git a/arch/arm/mach-ep93xx/edb93xx.c b/arch/arm/mach-ep93xx/edb93xx.c
index 337ab7c..e34f257 100644
--- a/arch/arm/mach-ep93xx/edb93xx.c
+++ b/arch/arm/mach-ep93xx/edb93xx.c
@@ -31,6 +31,7 @@
 #include <linux/i2c.h>
 #include <linux/i2c-gpio.h>
 #include <linux/spi/spi.h>
+#include <linux/sizes.h>
 
 #include <sound/cs4271.h>
 
diff --git a/arch/arm/mach-ep93xx/gesbc9312.c b/arch/arm/mach-ep93xx/gesbc9312.c
index 437c341..7fd705b 100644
--- a/arch/arm/mach-ep93xx/gesbc9312.c
+++ b/arch/arm/mach-ep93xx/gesbc9312.c
@@ -13,6 +13,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
+#include <linux/sizes.h>
 
 #include <mach/hardware.h>
 
diff --git a/arch/arm/mach-ep93xx/micro9.c b/arch/arm/mach-ep93xx/micro9.c
index 3d7cdab..1a8f032 100644
--- a/arch/arm/mach-ep93xx/micro9.c
+++ b/arch/arm/mach-ep93xx/micro9.c
@@ -15,6 +15,7 @@
 #include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/io.h>
+#include <linux/sizes.h>
 
 #include <mach/hardware.h>
 
diff --git a/arch/arm/mach-ep93xx/simone.c b/arch/arm/mach-ep93xx/simone.c
index 33dc079..a7c84cf 100644
--- a/arch/arm/mach-ep93xx/simone.c
+++ b/arch/arm/mach-ep93xx/simone.c
@@ -20,6 +20,7 @@
 #include <linux/platform_device.h>
 #include <linux/i2c.h>
 #include <linux/i2c-gpio.h>
+#include <linux/sizes.h>
 
 #include <mach/hardware.h>
 #include <mach/fb.h>
diff --git a/arch/arm/mach-ep93xx/snappercl15.c b/arch/arm/mach-ep93xx/snappercl15.c
index 01abd35..55acc79 100644
--- a/arch/arm/mach-ep93xx/snappercl15.c
+++ b/arch/arm/mach-ep93xx/snappercl15.c
@@ -23,6 +23,7 @@
 #include <linux/i2c.h>
 #include <linux/i2c-gpio.h>
 #include <linux/fb.h>
+#include <linux/sizes.h>
 
 #include <linux/mtd/partitions.h>
 #include <linux/mtd/nand.h>
diff --git a/arch/arm/mach-ep93xx/ts72xx.c b/arch/arm/mach-ep93xx/ts72xx.c
index aefda11..2a621af 100644
--- a/arch/arm/mach-ep93xx/ts72xx.c
+++ b/arch/arm/mach-ep93xx/ts72xx.c
@@ -19,6 +19,7 @@
 #include <linux/m48t86.h>
 #include <linux/mtd/nand.h>
 #include <linux/mtd/partitions.h>
+#include <linux/sizes.h>
 
 #include <mach/hardware.h>
 #include <mach/ts72xx.h>
diff --git a/arch/arm/mach-ep93xx/vision_ep9307.c b/arch/arm/mach-ep93xx/vision_ep9307.c
index 2905a49..4630a97 100644
--- a/arch/arm/mach-ep93xx/vision_ep9307.c
+++ b/arch/arm/mach-ep93xx/vision_ep9307.c
@@ -28,6 +28,7 @@
 #include <linux/spi/flash.h>
 #include <linux/spi/mmc_spi.h>
 #include <linux/mmc/host.h>
+#include <linux/sizes.h>
 
 #include <mach/hardware.h>
 #include <mach/fb.h>

