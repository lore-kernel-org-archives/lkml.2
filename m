Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760913Ab2ILRLh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 13:11:37 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:60565 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760823Ab2ILRLd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 13:11:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH 09/16] ARM: tegra: move platform_data definitions
Date: Wed, 12 Sep 2012 16:21:15 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Russell King <linux@arm.linux.org.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Chris Ball <cjb@laptop.org>, Liam Girdwood <lrg@ti.com>
References: <1347368350-31212-1-git-send-email-arnd@arndb.de> <1347368390-31252-9-git-send-email-arnd@arndb.de> <504F5A51.9000506@wwwdotorg.org>
In-Reply-To: <504F5A51.9000506@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <201209121621.16019.arnd@arndb.de>
X-Provags-ID: V02:K0:XHn8cbOLQUHKsUrklsEEpb+VRqqYBuJhKrCjbxCJe12
 L8VK9Ch7TNJ3S6GTns0jYhGUlTrN1PhdMSDPRXZd+AmTwy2MCI
 D7QtIxd6jD4kncMje6MVCrLtBSdBUsK6+4IaKFAhFD0syGD8md
 GeOCyqXR+BT1vXQBhmkXPUERavks7cZF4CoLDAeE7aEDCruHto
 xLm3YObpRjiOfHwYaBvy+VDqUDLC7VQ2BSCL4PVzRgnLyyBig2
 BLk7tUAHSsjHxDwfc7SuCHnMAbV54qT9D2Cd3FaSVtgT2DB5uJ
 Ss0DzDp9jwP6nwGLemo+wNkIGH46RLS//GJzPf6Fod4jhJ4jCY
 BZp6Kf+G8L9wVGet1gn0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 September 2012, Stephen Warren wrote:

> >  .../mach/sdhci.h => include/linux/platform_data/mmc-sdhci-tegra.h  |    0
> 
> I have a not-yet-applied (but ack'd by Chris Ball) patch to move this to
> include/linux/mmc/tegra_sdhci.h. I believe all the dependencies are
> staged in the Tegra tree now, so I can apply it if you want. I'm fine
> with you apply this patch though; just let me know. If you want to take
> your patch, then this part:
> 
> Acked-by: Stephen Warren <swarren@wwwdotorg.org>

I've redone my patch now, the version below is what I have now.

Thanks,

	Arnd

>From 1580b8b9c820db3d1e9ffce91fc741516ad5547a Mon Sep 17 00:00:00 2001
From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 12 Sep 2012 18:15:42 +0200
Subject: [PATCH] ARM: tegra: move sdhci platform_data definition

Platform data for device drivers should be defined in
include/linux/platform_data/*.h, not in the architecture
and platform specific directories.

This the definitions for the tegra sdhci driver out of
the tegra include directories, which is the last one
for this platform.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: Nicolas Pitre <nico@linaro.org>
Acked-by: Stephen Warren <swarren@wwwdotorg.org>
Acked-by: Chris Ball <cjb@laptop.org>

diff --git a/arch/arm/mach-tegra/board-harmony.c b/arch/arm/mach-tegra/board-harmony.c
index e65e837..5f428ff 100644
--- a/arch/arm/mach-tegra/board-harmony.c
+++ b/arch/arm/mach-tegra/board-harmony.c
@@ -26,6 +26,7 @@
 #include <linux/io.h>
 #include <linux/gpio.h>
 #include <linux/i2c.h>
+#include <linux/platform_data/mmc-sdhci-tegra.h>
 
 #include <sound/wm8903.h>
 
@@ -38,7 +39,6 @@
 #include <mach/tegra_wm8903_pdata.h>
 #include <mach/iomap.h>
 #include <mach/irqs.h>
-#include <mach/sdhci.h>
 
 #include "board.h"
 #include "board-harmony.h"
diff --git a/arch/arm/mach-tegra/board-paz00.c b/arch/arm/mach-tegra/board-paz00.c
index 4b64af5..112bf68 100644
--- a/arch/arm/mach-tegra/board-paz00.c
+++ b/arch/arm/mach-tegra/board-paz00.c
@@ -31,6 +31,7 @@
 #include <linux/i2c.h>
 #include <linux/gpio.h>
 #include <linux/rfkill-gpio.h>
+#include <linux/platform_data/mmc-sdhci-tegra.h>
 
 #include <asm/hardware/gic.h>
 #include <asm/mach-types.h>
@@ -40,7 +41,6 @@
 
 #include <mach/iomap.h>
 #include <mach/irqs.h>
-#include <mach/sdhci.h>
 
 #include "board.h"
 #include "board-paz00.h"
diff --git a/arch/arm/mach-tegra/board-trimslice.c b/arch/arm/mach-tegra/board-trimslice.c
index 776aa95..8d1a66a 100644
--- a/arch/arm/mach-tegra/board-trimslice.c
+++ b/arch/arm/mach-tegra/board-trimslice.c
@@ -27,6 +27,7 @@
 #include <linux/i2c.h>
 #include <linux/gpio.h>
 #include <linux/platform_data/tegra_usb.h>
+#include <linux/platform_data/mmc-sdhci-tegra.h>
 
 #include <asm/hardware/gic.h>
 #include <asm/mach-types.h>
@@ -34,7 +35,6 @@
 #include <asm/setup.h>
 
 #include <mach/iomap.h>
-#include <mach/sdhci.h>
 
 #include "board.h"
 #include "clock.h"
diff --git a/drivers/mmc/host/sdhci-tegra.c b/drivers/mmc/host/sdhci-tegra.c
index 0810ccc..d43e746 100644
--- a/drivers/mmc/host/sdhci-tegra.c
+++ b/drivers/mmc/host/sdhci-tegra.c
@@ -28,7 +28,7 @@
 #include <asm/gpio.h>
 
 #include <mach/gpio-tegra.h>
-#include <mach/sdhci.h>
+#include <linux/platform_data/mmc-sdhci-tegra.h>
 
 #include "sdhci-pltfm.h"
 
diff --git a/arch/arm/mach-tegra/include/mach/sdhci.h b/include/linux/platform_data/mmc-sdhci-tegra.h
similarity index 84%
rename from arch/arm/mach-tegra/include/mach/sdhci.h
rename to include/linux/platform_data/mmc-sdhci-tegra.h
index 4231bc7..8f84306 100644
--- a/arch/arm/mach-tegra/include/mach/sdhci.h
+++ b/include/linux/platform_data/mmc-sdhci-tegra.h
@@ -1,6 +1,4 @@
 /*
- * include/asm-arm/arch-tegra/include/mach/sdhci.h
- *
  * Copyright (C) 2009 Palm, Inc.
  * Author: Yvonne Yip <y@palm.com>
  *
@@ -14,8 +12,8 @@
  * GNU General Public License for more details.
  *
  */
-#ifndef __ASM_ARM_ARCH_TEGRA_SDHCI_H
-#define __ASM_ARM_ARCH_TEGRA_SDHCI_H
+#ifndef __PLATFORM_DATA_TEGRA_SDHCI_H
+#define __PLATFORM_DATA_TEGRA_SDHCI_H
 
 #include <linux/mmc/host.h>
 

