Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174Ab1ALWJ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 17:09:57 -0500
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:14267 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752153Ab1ALWJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 17:09:54 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAA+1LU1R8CJ0/2dsb2JhbACECKA7dK4IjiANgRSBVIFjdASRJQ
Date: Wed, 12 Jan 2011 23:09:48 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Benny =?iso-8859-1?Q?L=F8nstrup_Ammitzb=F8ll?= 
	<benny@ammitzboell-consult.dk>,
        Gabor Juhos <juhosg@openwrt.org>,
        Herman Morsink Vollenbroek <h.morsinkvollenbroek@home.nl>,
        Imre Kaloz <kaloz@openwrt.org>,
        Lennert Buytenhek <buytenh@secretlab.ca>,
        Lutz Ballaschke <vegan.grindcore@googlemail.com>,
        Michel Arboi <michel@arboi.fr.eu.org>,
        Mike Waychison <mikew@google.com>, Namhyung Kim <namhyung@gmail.com>,
        Philippe De Muyter <phdm@macqel.be>,
        Priyanka Gupta <priyankag@google.com>,
        Randy Vinson <rvinson@mvista.com>,
        Seth Heasley <seth.heasley@intel.com>,
        Timur Tabi <timur@freescale.com>,
        Yegor Yefremov <yegorslists@googlemail.com>,
        Giel van Schijndel <me@mortis.eu>,
        Josh Boyer <jwboyer@linux.vnet.ibm.com>,
        Dan Weinlader <dan@weinlader.org>
Subject: [GIT PULL REQUEST] watchdog - v2.6.38-rc1
Message-ID: <20110112220948.GR3801@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I still have a couple of new drivers under review (da9052_wdt, intel_scu_watchdog, jz4740_wdt and dw_wdt),
but I thought it was best to sent you allready the following patches and new drivers.

Please pull from 'master' branch of
	git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
or if master.kernel.org hasn't synced up yet:
	master.kernel.org:/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git

This will update the following files:

 arch/m68k/include/asm/m548xgpt.h |    2 
 drivers/watchdog/Kconfig         |   56 +++-
 drivers/watchdog/Makefile        |    6 
 drivers/watchdog/alim1535_wdt.c  |    2 
 drivers/watchdog/alim7101_wdt.c  |    2 
 drivers/watchdog/ath79_wdt.c     |  305 +++++++++++++++++++++++
 drivers/watchdog/booke_wdt.c     |   35 ++
 drivers/watchdog/f71808e_wdt.c   |   78 ++++-
 drivers/watchdog/iTCO_wdt.c      |   12 
 drivers/watchdog/ks8695_wdt.c    |    2 
 drivers/watchdog/m548x_wdt.c     |  227 +++++++++++++++++
 drivers/watchdog/nv_tco.c        |  512 +++++++++++++++++++++++++++++++++++++++
 drivers/watchdog/nv_tco.h        |   64 ++++
 drivers/watchdog/sp5100_tco.c    |  480 ++++++++++++++++++++++++++++++++++++
 drivers/watchdog/sp5100_tco.h    |   41 +++
 drivers/watchdog/w83627hf_wdt.c  |    8 
 16 files changed, 1798 insertions(+), 34 deletions(-)

with these Changes:

Author: Philippe De Muyter <phdm@macqel.be>
Date:   Wed Nov 3 15:07:28 2010 +0100

    watchdog: Add MCF548x watchdog driver.
    
    Add watchdog driver for MCF548x.
    
    Signed-off-by: Philippe De Muyter <phdm@macqel.be>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Gabor Juhos <juhosg@openwrt.org>
Date:   Tue Jan 4 21:28:19 2011 +0100

    watchdog: add driver for the Atheros AR71XX/AR724X/AR913X SoCs
    
    This patch adds a driver for the built-in hardware watchdog device
    of the Atheros AR71XX/AR724X/AR913X SoCs.
    
    Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
    Signed-off-by: Imre Kaloz <kaloz@openwrt.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Mike Waychison <mikew@google.com>
Date:   Mon Oct 25 17:58:05 2010 -0700

    watchdog: Add TCO support for nVidia chipsets
    
    This driver adds support for /dev/watchdog for boards using either the MCP51 or
    MCP55 chipsets.  These are also known as the nForce 430 and nForce 550.  This
    driver is likely to work on other chipsets as well, though those are the only
    two that have been tested.
    
    Signed-off-by: Mike Waychison <mikew@google.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Priyanka Gupta <priyankag@google.com>
Date:   Mon Oct 25 17:58:04 2010 -0700

    watchdog: Add support for sp5100 chipset TCO
    
    This driver adds /dev/watchdog support for the AMD sp5100 aka SB7x0 chipsets.
    
    It follows the same conventions found in other /dev/watchdog drivers.
    
    Signed-off-by: Priyanka Gupta <priyankag@google.com>
    Signed-off-by: Mike Waychison <mikew@google.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Lutz Ballaschke <vegan.grindcore@googlemail.com>
Date:   Wed Jan 12 01:09:02 2011 +0100

    watchdog: f71808e_wdt: add F71862FG, F71869 to Kconfig
    
    Update Kconfig with the additional Fintek hardware that we support.
    
    Signed-off-by: Lutz Ballaschke <vegan.grindcore@googlemail.com>
    Acked-by: Giel van Schijndel <me@mortis.eu>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Seth Heasley <seth.heasley@intel.com>
Date:   Fri Jan 7 17:11:08 2011 -0800

    watchdog: iTCO_wdt: TCO Watchdog patch for Intel DH89xxCC PCH
    
    This patch adds the DeviceIDs for TCO Watchdog on the Intel DH89xxCC PCH.
    
    Signed-off-by: Seth Heasley <seth.heasley@intel.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Fri Dec 31 14:10:45 2010 +0000

    watchdog: iTCO_wdt: TCO Watchdog patch for Intel NM10 DeviceIDs
    
    This patch adds the Intel NM10 DeviceIDs for iTCO Watchdog.
    
    Reported-by: Dan Weinlader <dan@weinlader.org>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Yegor Yefremov <yegorslists@googlemail.com>
Date:   Tue Dec 14 16:29:31 2010 +0100

    watchdog: ks8695_wdt: include mach/hardware.h instead of mach/timex.h.
    
    ks8695_wdt needs KS8695_CLOCK_RATE, which is defined in
    mach/hardware.h, which is pulled in by the include of mach/timex.h,
    but the latter is going away, so just include mach/hardware.h
    directly.
    
    Signed-off-by: Yegor Yefremov <yegorslists@googlemail.com>
    Signed-off-by: Lennert Buytenhek <buytenh@secretlab.ca>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Randy Vinson <rvinson@mvista.com>
Date:   Mon Dec 6 14:02:23 2010 -0700

    watchdog: Propagate Book E WDT period changes to all cores
    
    When the watchdog period is changed, it needs to be propagated to all cores
    in addition to the core that performed the change.
    
    Signed-off-by: Randy Vinson <rvinson@mvista.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Timur Tabi <timur@freescale.com>
Date:   Fri Dec 3 10:51:43 2010 -0600

    watchdog: add CONFIG_WATCHDOG_NOWAYOUT support to PowerPC Book-E watchdog driver
    
    Normally, the watchdog is disabled when dev/watchdog is closed, but if
    CONFIG_WATCHDOG_NOWAYOUT is defined, then it means that the watchdog should
    remain enabled.  So we should disable it only if CONFIG_WATCHDOG_NOWAYOUT is
    not defined.
    
    Also ensure that /dev/watchdog is only opened by one process at a time.  That
    way, a second process can't accidentally disable the watchdog while the first
    process has it open.  There shouldn't be any need for more than one process to
    open /dev/watchdog anyway.
    
    Signed-off-by: Timur Tabi <timur@freescale.com>
    Acked-by: Josh Boyer <jwboyer@linux.vnet.ibm.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Namhyung Kim <namhyung@gmail.com>
Date:   Wed Dec 8 01:27:36 2010 +0900

    watchdog: alim7101_wdt: fix compiler warning on alim7101_pci_tbl
    
    Annotate alim7101_pci_tbl as '__used' to fix following warning:
    
      CC      drivers/watchdog/alim7101_wdt.o
    drivers/watchdog/alim7101_wdt.c:433: warning: ‘alim7101_pci_tbl’ defined but not used
    
    Signed-off-by: Namhyung Kim <namhyung@gmail.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Namhyung Kim <namhyung@gmail.com>
Date:   Wed Dec 8 01:27:35 2010 +0900

    watchdog: alim1535_wdt: fix compiler warning on ali_pci_tbl
    
    Annotate ali_pci_tbl as '__used' to fix following warning:
    
      CC      drivers/watchdog/alim1535_wdt.o
    drivers/watchdog/alim1535_wdt.c:304: warning: ‘ali_pci_tbl’ defined but not used
    
    Signed-off-by: Namhyung Kim <namhyung@gmail.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Herman Morsink Vollenbroek <h.morsinkvollenbroek@home.nl>
Date:   Mon Dec 6 21:24:56 2010 +0100

    watchdog: Fix reboot on W83627ehf chipset.
    
    The watchdog driver for the SUPERIO chip winbond w83627ehf does not work.
    If you open /dev/watchdog and write a character to /dev/watchdog then
    the watchdog will be triggered. However the watchdog will not trigger
    the hardware RESET after the timeout, because the watchdog has never been
    enabled.
    
    Signed-off-by: Herman Morsink Vollenbroek <h.morsinkvollenbroek@home.nl>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Benny Loenstrup Ammitzboell <benny@ammitzboell-consult.dk>
Date:   Thu Nov 11 16:08:41 2010 +0100

    watchdog: Add watchdog support for W83627DHG chip
    
    The following adds watchdog support for the Winbond W83627DHG chip.
    I have tested it on a PQ7-M102XL (Intel Atom) board.
    
    Signed-off-by: Benny Lønstrup Ammitzbøll <benny@ammitzboell-consult.dk>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Michel Arboi <michel@arboi.fr.eu.org>
Date:   Mon Dec 6 20:53:45 2010 +0100

    watchdog: f71808e_wdt: Add Fintek F71869 watchdog
    
    Add Fintek f71869 as a supported watchdog device.
    
    Signed-off-by: Michel Arboi <michel@arboi.fr.eu.org>
    Acked-by: Giel van Schijndel <me@mortis.eu>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Lutz Ballaschke <vegan.grindcore@googlemail.com>
Date:   Sun Sep 26 16:25:35 2010 +0200

    watchdog: add f71862fg support
    
    Watchdog support for Fintek F71862fg Super-I/O added.
    Two different hardware reset pins of the F71862fg chip can be configured
    by an additional module parameter.
    
    Signed-off-by: Lutz Ballaschke <vegan.grindcore@googlemail.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Lutz Ballaschke <vegan.grindcore@googlemail.com>
Date:   Sun Sep 26 16:38:20 2010 +0200

    watchdog: clean-up f71808e_wdt.c
    
    Cleaned up and replaced some magic numbers by constants.
    
    Signed-off-by: Lutz Ballaschke <vegan.grindcore@googlemail.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/arch/m68k/include/asm/m548xgpt.h b/arch/m68k/include/asm/m548xgpt.h
index c8ef158..33b2eef 100644
--- a/arch/m68k/include/asm/m548xgpt.h
+++ b/arch/m68k/include/asm/m548xgpt.h
@@ -59,11 +59,13 @@
 #define MCF_GPT_GMS_GPIO_INPUT     (0x00000000)
 #define MCF_GPT_GMS_GPIO_OUTLO     (0x00000020)
 #define MCF_GPT_GMS_GPIO_OUTHI     (0x00000030)
+#define MCF_GPT_GMS_GPIO_MASK      (0x00000030)
 #define MCF_GPT_GMS_TMS_DISABLE    (0x00000000)
 #define MCF_GPT_GMS_TMS_INCAPT     (0x00000001)
 #define MCF_GPT_GMS_TMS_OUTCAPT    (0x00000002)
 #define MCF_GPT_GMS_TMS_PWM        (0x00000003)
 #define MCF_GPT_GMS_TMS_GPIO       (0x00000004)
+#define MCF_GPT_GMS_TMS_MASK       (0x00000007)
 
 /* Bit definitions and macros for MCF_GPT_GCIR */
 #define MCF_GPT_GCIR_CNT(x)        (((x)&0x0000FFFF)<<0)
diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index a5ad77e..2e2400e 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -409,15 +409,26 @@ config ALIM7101_WDT
 	  Most people will say N.
 
 config F71808E_WDT
-	tristate "Fintek F71808E, F71882FG and F71889FG Watchdog"
+	tristate "Fintek F71808E, F71862FG, F71869, F71882FG and F71889FG Watchdog"
 	depends on X86 && EXPERIMENTAL
 	help
 	  This is the driver for the hardware watchdog on the Fintek
-	  F71808E, F71882FG and F71889FG Super I/O controllers.
+	  F71808E, F71862FG, F71869, F71882FG and F71889FG Super I/O controllers.
 
 	  You can compile this driver directly into the kernel, or use
 	  it as a module.  The module will be called f71808e_wdt.
 
+config SP5100_TCO
+	tristate "AMD/ATI SP5100 TCO Timer/Watchdog"
+	depends on X86 && PCI
+	---help---
+	  Hardware watchdog driver for the AMD/ATI SP5100 chipset. The TCO
+	  (Total Cost of Ownership) timer is a watchdog timer that will reboot
+	  the machine after its expiration. The expiration time can be
+	  configured with the "heartbeat" parameter.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called sp5100_tco.
 
 config GEODE_WDT
 	tristate "AMD Geode CS5535/CS5536 Watchdog"
@@ -631,6 +642,24 @@ config PC87413_WDT
 
 	  Most people will say N.
 
+config NV_TCO
+	tristate "nVidia TCO Timer/Watchdog"
+	depends on X86 && PCI
+	---help---
+	  Hardware driver for the TCO timer built into the nVidia Hub family
+	  (such as the MCP51).  The TCO (Total Cost of Ownership) timer is a
+	  watchdog timer that will reboot the machine after its second
+	  expiration. The expiration time can be configured with the
+	  "heartbeat" parameter.
+
+	  On some motherboards the driver may fail to reset the chipset's
+	  NO_REBOOT flag which prevents the watchdog from rebooting the
+	  machine. If this is the case you will get a kernel message like
+	  "failed to reset NO_REBOOT flag, reboot disabled by hardware".
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called nv_tco.
+
 config RDC321X_WDT
 	tristate "RDC R-321x SoC watchdog"
 	depends on X86_RDC321X
@@ -722,14 +751,15 @@ config SMSC37B787_WDT
 	  Most people will say N.
 
 config W83627HF_WDT
-	tristate "W83627HF Watchdog Timer"
+	tristate "W83627HF/W83627DHG Watchdog Timer"
 	depends on X86
 	---help---
 	  This is the driver for the hardware watchdog on the W83627HF chipset
 	  as used in Advantech PC-9578 and Tyan S2721-533 motherboards
-	  (and likely others).  This watchdog simply watches your kernel to
-	  make sure it doesn't freeze, and if it does, it reboots your computer
-	  after a certain amount of time.
+	  (and likely others). The driver also supports the W83627DHG chip.
+	  This watchdog simply watches your kernel to make sure it doesn't
+	  freeze, and if it does, it reboots your computer after a certain
+	  amount of time.
 
 	  To compile this driver as a module, choose M here: the
 	  module will be called w83627hf_wdt.
@@ -832,10 +862,22 @@ config SBC_EPX_C3_WATCHDOG
 
 # M68K Architecture
 
-# M68KNOMMU Architecture
+config M548x_WATCHDOG
+	tristate "MCF548x watchdog support"
+	depends on M548x
+	help
+	  To compile this driver as a module, choose M here: the
+	  module will be called m548x_wdt.
 
 # MIPS Architecture
 
+config ATH79_WDT
+	tristate "Atheros AR71XX/AR724X/AR913X hardware watchdog"
+	depends on ATH79
+	help
+	  Hardware driver for the built-in watchdog timer on the Atheros
+	  AR71XX/AR724X/AR913X SoCs.
+
 config BCM47XX_WDT
 	tristate "Broadcom BCM47xx Watchdog Timer"
 	depends on BCM47XX
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index 4b0ef38..dd77665 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -68,6 +68,7 @@ obj-$(CONFIG_ADVANTECH_WDT) += advantechwdt.o
 obj-$(CONFIG_ALIM1535_WDT) += alim1535_wdt.o
 obj-$(CONFIG_ALIM7101_WDT) += alim7101_wdt.o
 obj-$(CONFIG_F71808E_WDT) += f71808e_wdt.o
+obj-$(CONFIG_SP5100_TCO) += sp5100_tco.o
 obj-$(CONFIG_GEODE_WDT) += geodewdt.o
 obj-$(CONFIG_SC520_WDT) += sc520_wdt.o
 obj-$(CONFIG_SBC_FITPC2_WATCHDOG) += sbc_fitpc2_wdt.o
@@ -86,6 +87,7 @@ obj-$(CONFIG_HP_WATCHDOG) += hpwdt.o
 obj-$(CONFIG_SC1200_WDT) += sc1200wdt.o
 obj-$(CONFIG_SCx200_WDT) += scx200_wdt.o
 obj-$(CONFIG_PC87413_WDT) += pc87413_wdt.o
+obj-$(CONFIG_NV_TCO) += nv_tco.o
 obj-$(CONFIG_RDC321X_WDT) += rdc321x_wdt.o
 obj-$(CONFIG_60XX_WDT) += sbc60xxwdt.o
 obj-$(CONFIG_SBC8360_WDT) += sbc8360.o
@@ -104,10 +106,10 @@ obj-$(CONFIG_SBC_EPX_C3_WATCHDOG) += sbc_epx_c3.o
 # M32R Architecture
 
 # M68K Architecture
-
-# M68KNOMMU Architecture
+obj-$(CONFIG_M548x_WATCHDOG) += m548x_wdt.o
 
 # MIPS Architecture
+obj-$(CONFIG_ATH79_WDT) += ath79_wdt.o
 obj-$(CONFIG_BCM47XX_WDT) += bcm47xx_wdt.o
 obj-$(CONFIG_BCM63XX_WDT) += bcm63xx_wdt.o
 obj-$(CONFIG_RC32434_WDT) += rc32434_wdt.o
diff --git a/drivers/watchdog/alim1535_wdt.c b/drivers/watchdog/alim1535_wdt.c
index 1e9caea..fa4d360 100644
--- a/drivers/watchdog/alim1535_wdt.c
+++ b/drivers/watchdog/alim1535_wdt.c
@@ -301,7 +301,7 @@ static int ali_notify_sys(struct notifier_block *this,
  *	want to register another driver on the same PCI id.
  */
 
-static struct pci_device_id ali_pci_tbl[] = {
+static struct pci_device_id ali_pci_tbl[] __used = {
 	{ PCI_VENDOR_ID_AL, 0x1533, PCI_ANY_ID, PCI_ANY_ID,},
 	{ PCI_VENDOR_ID_AL, 0x1535, PCI_ANY_ID, PCI_ANY_ID,},
 	{ 0, },
diff --git a/drivers/watchdog/alim7101_wdt.c b/drivers/watchdog/alim7101_wdt.c
index d8d4da9..4b7a2b4 100644
--- a/drivers/watchdog/alim7101_wdt.c
+++ b/drivers/watchdog/alim7101_wdt.c
@@ -430,7 +430,7 @@ err_out:
 module_init(alim7101_wdt_init);
 module_exit(alim7101_wdt_unload);
 
-static struct pci_device_id alim7101_pci_tbl[] __devinitdata = {
+static struct pci_device_id alim7101_pci_tbl[] __devinitdata __used = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AL, PCI_DEVICE_ID_AL_M1533) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AL, PCI_DEVICE_ID_AL_M7101) },
 	{ }
diff --git a/drivers/watchdog/ath79_wdt.c b/drivers/watchdog/ath79_wdt.c
new file mode 100644
index 0000000..725c84b
--- /dev/null
+++ b/drivers/watchdog/ath79_wdt.c
@@ -0,0 +1,305 @@
+/*
+ * Atheros AR71XX/AR724X/AR913X built-in hardware watchdog timer.
+ *
+ * Copyright (C) 2008-2011 Gabor Juhos <juhosg@openwrt.org>
+ * Copyright (C) 2008 Imre Kaloz <kaloz@openwrt.org>
+ *
+ * This driver was based on: drivers/watchdog/ixp4xx_wdt.c
+ *	Author: Deepak Saxena <dsaxena@plexity.net>
+ *	Copyright 2004 (c) MontaVista, Software, Inc.
+ *
+ * which again was based on sa1100 driver,
+ *	Copyright (C) 2000 Oleg Drokin <green@crimea.edu>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ *
+ */
+
+#include <linux/bitops.h>
+#include <linux/errno.h>
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/miscdevice.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/platform_device.h>
+#include <linux/types.h>
+#include <linux/watchdog.h>
+#include <linux/clk.h>
+#include <linux/err.h>
+
+#include <asm/mach-ath79/ath79.h>
+#include <asm/mach-ath79/ar71xx_regs.h>
+
+#define DRIVER_NAME	"ath79-wdt"
+
+#define WDT_TIMEOUT	15	/* seconds */
+
+#define WDOG_CTRL_LAST_RESET	BIT(31)
+#define WDOG_CTRL_ACTION_MASK	3
+#define WDOG_CTRL_ACTION_NONE	0	/* no action */
+#define WDOG_CTRL_ACTION_GPI	1	/* general purpose interrupt */
+#define WDOG_CTRL_ACTION_NMI	2	/* NMI */
+#define WDOG_CTRL_ACTION_FCR	3	/* full chip reset */
+
+static int nowayout = WATCHDOG_NOWAYOUT;
+module_param(nowayout, int, 0);
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started "
+			   "(default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+
+static int timeout = WDT_TIMEOUT;
+module_param(timeout, int, 0);
+MODULE_PARM_DESC(timeout, "Watchdog timeout in seconds "
+			  "(default=" __MODULE_STRING(WDT_TIMEOUT) "s)");
+
+static unsigned long wdt_flags;
+
+#define WDT_FLAGS_BUSY		0
+#define WDT_FLAGS_EXPECT_CLOSE	1
+
+static struct clk *wdt_clk;
+static unsigned long wdt_freq;
+static int boot_status;
+static int max_timeout;
+
+static inline void ath79_wdt_keepalive(void)
+{
+	ath79_reset_wr(AR71XX_RESET_REG_WDOG, wdt_freq * timeout);
+}
+
+static inline void ath79_wdt_enable(void)
+{
+	ath79_wdt_keepalive();
+	ath79_reset_wr(AR71XX_RESET_REG_WDOG_CTRL, WDOG_CTRL_ACTION_FCR);
+}
+
+static inline void ath79_wdt_disable(void)
+{
+	ath79_reset_wr(AR71XX_RESET_REG_WDOG_CTRL, WDOG_CTRL_ACTION_NONE);
+}
+
+static int ath79_wdt_set_timeout(int val)
+{
+	if (val < 1 || val > max_timeout)
+		return -EINVAL;
+
+	timeout = val;
+	ath79_wdt_keepalive();
+
+	return 0;
+}
+
+static int ath79_wdt_open(struct inode *inode, struct file *file)
+{
+	if (test_and_set_bit(WDT_FLAGS_BUSY, &wdt_flags))
+		return -EBUSY;
+
+	clear_bit(WDT_FLAGS_EXPECT_CLOSE, &wdt_flags);
+	ath79_wdt_enable();
+
+	return nonseekable_open(inode, file);
+}
+
+static int ath79_wdt_release(struct inode *inode, struct file *file)
+{
+	if (test_bit(WDT_FLAGS_EXPECT_CLOSE, &wdt_flags))
+		ath79_wdt_disable();
+	else {
+		pr_crit(DRIVER_NAME ": device closed unexpectedly, "
+			"watchdog timer will not stop!\n");
+		ath79_wdt_keepalive();
+	}
+
+	clear_bit(WDT_FLAGS_BUSY, &wdt_flags);
+	clear_bit(WDT_FLAGS_EXPECT_CLOSE, &wdt_flags);
+
+	return 0;
+}
+
+static ssize_t ath79_wdt_write(struct file *file, const char *data,
+				size_t len, loff_t *ppos)
+{
+	if (len) {
+		if (!nowayout) {
+			size_t i;
+
+			clear_bit(WDT_FLAGS_EXPECT_CLOSE, &wdt_flags);
+
+			for (i = 0; i != len; i++) {
+				char c;
+
+				if (get_user(c, data + i))
+					return -EFAULT;
+
+				if (c == 'V')
+					set_bit(WDT_FLAGS_EXPECT_CLOSE,
+						&wdt_flags);
+			}
+		}
+
+		ath79_wdt_keepalive();
+	}
+
+	return len;
+}
+
+static const struct watchdog_info ath79_wdt_info = {
+	.options		= WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING |
+				  WDIOF_MAGICCLOSE | WDIOF_CARDRESET,
+	.firmware_version	= 0,
+	.identity		= "ATH79 watchdog",
+};
+
+static long ath79_wdt_ioctl(struct file *file, unsigned int cmd,
+			    unsigned long arg)
+{
+	void __user *argp = (void __user *)arg;
+	int __user *p = argp;
+	int err;
+	int t;
+
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		err = copy_to_user(argp, &ath79_wdt_info,
+				   sizeof(ath79_wdt_info)) ? -EFAULT : 0;
+		break;
+
+	case WDIOC_GETSTATUS:
+		err = put_user(0, p);
+		break;
+
+	case WDIOC_GETBOOTSTATUS:
+		err = put_user(boot_status, p);
+		break;
+
+	case WDIOC_KEEPALIVE:
+		ath79_wdt_keepalive();
+		err = 0;
+		break;
+
+	case WDIOC_SETTIMEOUT:
+		err = get_user(t, p);
+		if (err)
+			break;
+
+		err = ath79_wdt_set_timeout(t);
+		if (err)
+			break;
+
+		/* fallthrough */
+	case WDIOC_GETTIMEOUT:
+		err = put_user(timeout, p);
+		break;
+
+	default:
+		err = -ENOTTY;
+		break;
+	}
+
+	return err;
+}
+
+static const struct file_operations ath79_wdt_fops = {
+	.owner		= THIS_MODULE,
+	.llseek		= no_llseek,
+	.write		= ath79_wdt_write,
+	.unlocked_ioctl	= ath79_wdt_ioctl,
+	.open		= ath79_wdt_open,
+	.release	= ath79_wdt_release,
+};
+
+static struct miscdevice ath79_wdt_miscdev = {
+	.minor = WATCHDOG_MINOR,
+	.name = "watchdog",
+	.fops = &ath79_wdt_fops,
+};
+
+static int __devinit ath79_wdt_probe(struct platform_device *pdev)
+{
+	u32 ctrl;
+	int err;
+
+	wdt_clk = clk_get(&pdev->dev, "wdt");
+	if (IS_ERR(wdt_clk))
+		return PTR_ERR(wdt_clk);
+
+	err = clk_enable(wdt_clk);
+	if (err)
+		goto err_clk_put;
+
+	wdt_freq = clk_get_rate(wdt_clk);
+	if (!wdt_freq) {
+		err = -EINVAL;
+		goto err_clk_disable;
+	}
+
+	max_timeout = (0xfffffffful / wdt_freq);
+	if (timeout < 1 || timeout > max_timeout) {
+		timeout = max_timeout;
+		dev_info(&pdev->dev,
+			"timeout value must be 0 < timeout < %d, using %d\n",
+			max_timeout, timeout);
+	}
+
+	ctrl = ath79_reset_rr(AR71XX_RESET_REG_WDOG_CTRL);
+	boot_status = (ctrl & WDOG_CTRL_LAST_RESET) ? WDIOF_CARDRESET : 0;
+
+	err = misc_register(&ath79_wdt_miscdev);
+	if (err) {
+		dev_err(&pdev->dev,
+			"unable to register misc device, err=%d\n", err);
+		goto err_clk_disable;
+	}
+
+	return 0;
+
+err_clk_disable:
+	clk_disable(wdt_clk);
+err_clk_put:
+	clk_put(wdt_clk);
+	return err;
+}
+
+static int __devexit ath79_wdt_remove(struct platform_device *pdev)
+{
+	misc_deregister(&ath79_wdt_miscdev);
+	clk_disable(wdt_clk);
+	clk_put(wdt_clk);
+	return 0;
+}
+
+static void ath97_wdt_shutdown(struct platform_device *pdev)
+{
+	ath79_wdt_disable();
+}
+
+static struct platform_driver ath79_wdt_driver = {
+	.remove		= __devexit_p(ath79_wdt_remove),
+	.shutdown	= ath97_wdt_shutdown,
+	.driver		= {
+		.name	= DRIVER_NAME,
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init ath79_wdt_init(void)
+{
+	return platform_driver_probe(&ath79_wdt_driver, ath79_wdt_probe);
+}
+module_init(ath79_wdt_init);
+
+static void __exit ath79_wdt_exit(void)
+{
+	platform_driver_unregister(&ath79_wdt_driver);
+}
+module_exit(ath79_wdt_exit);
+
+MODULE_DESCRIPTION("Atheros AR71XX/AR724X/AR913X hardware watchdog driver");
+MODULE_AUTHOR("Gabor Juhos <juhosg@openwrt.org");
+MODULE_AUTHOR("Imre Kaloz <kaloz@openwrt.org");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:" DRIVER_NAME);
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
diff --git a/drivers/watchdog/booke_wdt.c b/drivers/watchdog/booke_wdt.c
index d11ffb0..7e7ec9c 100644
--- a/drivers/watchdog/booke_wdt.c
+++ b/drivers/watchdog/booke_wdt.c
@@ -85,6 +85,22 @@ static unsigned int sec_to_period(unsigned int secs)
 	return 0;
 }
 
+static void __booke_wdt_set(void *data)
+{
+	u32 val;
+
+	val = mfspr(SPRN_TCR);
+	val &= ~WDTP_MASK;
+	val |= WDTP(booke_wdt_period);
+
+	mtspr(SPRN_TCR, val);
+}
+
+static void booke_wdt_set(void)
+{
+	on_each_cpu(__booke_wdt_set, NULL, 0);
+}
+
 static void __booke_wdt_ping(void *data)
 {
 	mtspr(SPRN_TSR, TSR_ENW|TSR_WIS);
@@ -181,8 +197,7 @@ static long booke_wdt_ioctl(struct file *file,
 #else
 		booke_wdt_period = tmp;
 #endif
-		mtspr(SPRN_TCR, (mfspr(SPRN_TCR) & ~WDTP_MASK) |
-						WDTP(booke_wdt_period));
+		booke_wdt_set();
 		return 0;
 	case WDIOC_GETTIMEOUT:
 		return put_user(booke_wdt_period, p);
@@ -193,8 +208,15 @@ static long booke_wdt_ioctl(struct file *file,
 	return 0;
 }
 
+/* wdt_is_active stores wether or not the /dev/watchdog device is opened */
+static unsigned long wdt_is_active;
+
 static int booke_wdt_open(struct inode *inode, struct file *file)
 {
+	/* /dev/watchdog can only be opened once */
+	if (test_and_set_bit(0, &wdt_is_active))
+		return -EBUSY;
+
 	spin_lock(&booke_wdt_lock);
 	if (booke_wdt_enabled == 0) {
 		booke_wdt_enabled = 1;
@@ -210,8 +232,17 @@ static int booke_wdt_open(struct inode *inode, struct file *file)
 
 static int booke_wdt_release(struct inode *inode, struct file *file)
 {
+#ifndef CONFIG_WATCHDOG_NOWAYOUT
+	/* Normally, the watchdog is disabled when /dev/watchdog is closed, but
+	 * if CONFIG_WATCHDOG_NOWAYOUT is defined, then it means that the
+	 * watchdog should remain enabled.  So we disable it only if
+	 * CONFIG_WATCHDOG_NOWAYOUT is not defined.
+	 */
 	on_each_cpu(__booke_wdt_disable, NULL, 0);
 	booke_wdt_enabled = 0;
+#endif
+
+	clear_bit(0, &wdt_is_active);
 
 	return 0;
 }
diff --git a/drivers/watchdog/f71808e_wdt.c b/drivers/watchdog/f71808e_wdt.c
index 65e5796..d4d8d1f 100644
--- a/drivers/watchdog/f71808e_wdt.c
+++ b/drivers/watchdog/f71808e_wdt.c
@@ -42,18 +42,21 @@
 #define SIO_REG_DEVID		0x20	/* Device ID (2 bytes) */
 #define SIO_REG_DEVREV		0x22	/* Device revision */
 #define SIO_REG_MANID		0x23	/* Fintek ID (2 bytes) */
+#define SIO_REG_ROM_ADDR_SEL	0x27	/* ROM address select */
+#define SIO_REG_MFUNCT1		0x29	/* Multi function select 1 */
+#define SIO_REG_MFUNCT2		0x2a	/* Multi function select 2 */
+#define SIO_REG_MFUNCT3		0x2b	/* Multi function select 3 */
 #define SIO_REG_ENABLE		0x30	/* Logical device enable */
 #define SIO_REG_ADDR		0x60	/* Logical device address (2 bytes) */
 
 #define SIO_FINTEK_ID		0x1934	/* Manufacturers ID */
-#define SIO_F71808_ID		0x0901  /* Chipset ID */
-#define SIO_F71858_ID		0x0507  /* Chipset ID */
+#define SIO_F71808_ID		0x0901	/* Chipset ID */
+#define SIO_F71858_ID		0x0507	/* Chipset ID */
 #define SIO_F71862_ID		0x0601	/* Chipset ID */
+#define SIO_F71869_ID		0x0814	/* Chipset ID */
 #define SIO_F71882_ID		0x0541	/* Chipset ID */
 #define SIO_F71889_ID		0x0723	/* Chipset ID */
 
-#define	F71882FG_REG_START		0x01
-
 #define F71808FG_REG_WDO_CONF		0xf0
 #define F71808FG_REG_WDT_CONF		0xf5
 #define F71808FG_REG_WD_TIME		0xf6
@@ -70,13 +73,15 @@
 #define WATCHDOG_MAX_TIMEOUT	(60 * 255)
 #define WATCHDOG_PULSE_WIDTH	125	/* 125 ms, default pulse width for
 					   watchdog signal */
+#define WATCHDOG_F71862FG_PIN	63	/* default watchdog reset output
+					   pin number 63 */
 
 static unsigned short force_id;
 module_param(force_id, ushort, 0);
 MODULE_PARM_DESC(force_id, "Override the detected device ID");
 
 static const int max_timeout = WATCHDOG_MAX_TIMEOUT;
-static int timeout = 60;	/* default timeout in seconds */
+static int timeout = WATCHDOG_TIMEOUT;	/* default timeout in seconds */
 module_param(timeout, int, 0);
 MODULE_PARM_DESC(timeout,
 	"Watchdog timeout in seconds. 1<= timeout <="
@@ -89,6 +94,12 @@ MODULE_PARM_DESC(pulse_width,
 	"Watchdog signal pulse width. 0(=level), 1 ms, 25 ms, 125 ms or 5000 ms"
 			" (default=" __MODULE_STRING(WATCHDOG_PULSE_WIDTH) ")");
 
+static unsigned int f71862fg_pin = WATCHDOG_F71862FG_PIN;
+module_param(f71862fg_pin, uint, 0);
+MODULE_PARM_DESC(f71862fg_pin,
+	"Watchdog f71862fg reset output pin configuration. Choose pin 56 or 63"
+			" (default=" __MODULE_STRING(WATCHDOG_F71862FG_PIN)")");
+
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, bool, 0444);
 MODULE_PARM_DESC(nowayout, "Disable watchdog shutdown on close");
@@ -98,12 +109,13 @@ module_param(start_withtimeout, uint, 0);
 MODULE_PARM_DESC(start_withtimeout, "Start watchdog timer on module load with"
 	" given initial timeout. Zero (default) disables this feature.");
 
-enum chips { f71808fg, f71858fg, f71862fg, f71882fg, f71889fg };
+enum chips { f71808fg, f71858fg, f71862fg, f71869, f71882fg, f71889fg };
 
 static const char *f71808e_names[] = {
 	"f71808fg",
 	"f71858fg",
 	"f71862fg",
+	"f71869",
 	"f71882fg",
 	"f71889fg",
 };
@@ -282,6 +294,28 @@ exit_unlock:
 	return err;
 }
 
+static int f71862fg_pin_configure(unsigned short ioaddr)
+{
+	/* When ioaddr is non-zero the calling function has to take care of
+	   mutex handling and superio preparation! */
+
+	if (f71862fg_pin == 63) {
+		if (ioaddr) {
+			/* SPI must be disabled first to use this pin! */
+			superio_clear_bit(ioaddr, SIO_REG_ROM_ADDR_SEL, 6);
+			superio_set_bit(ioaddr, SIO_REG_MFUNCT3, 4);
+		}
+	} else if (f71862fg_pin == 56) {
+		if (ioaddr)
+			superio_set_bit(ioaddr, SIO_REG_MFUNCT1, 1);
+	} else {
+		printk(KERN_ERR DRVNAME ": Invalid argument f71862fg_pin=%d\n",
+				f71862fg_pin);
+		return -EINVAL;
+	}
+	return 0;
+}
+
 static int watchdog_start(void)
 {
 	/* Make sure we don't die as soon as the watchdog is enabled below */
@@ -299,19 +333,30 @@ static int watchdog_start(void)
 	switch (watchdog.type) {
 	case f71808fg:
 		/* Set pin 21 to GPIO23/WDTRST#, then to WDTRST# */
-		superio_clear_bit(watchdog.sioaddr, 0x2a, 3);
-		superio_clear_bit(watchdog.sioaddr, 0x2b, 3);
+		superio_clear_bit(watchdog.sioaddr, SIO_REG_MFUNCT2, 3);
+		superio_clear_bit(watchdog.sioaddr, SIO_REG_MFUNCT3, 3);
+		break;
+
+	case f71862fg:
+		err = f71862fg_pin_configure(watchdog.sioaddr);
+		if (err)
+			goto exit_superio;
+		break;
+
+	case f71869:
+		/* GPIO14 --> WDTRST# */
+		superio_clear_bit(watchdog.sioaddr, SIO_REG_MFUNCT1, 4);
 		break;
 
 	case f71882fg:
 		/* Set pin 56 to WDTRST# */
-		superio_set_bit(watchdog.sioaddr, 0x29, 1);
+		superio_set_bit(watchdog.sioaddr, SIO_REG_MFUNCT1, 1);
 		break;
 
 	case f71889fg:
 		/* set pin 40 to WDTRST# */
-		superio_outb(watchdog.sioaddr, 0x2b,
-				superio_inb(watchdog.sioaddr, 0x2b) & 0xcf);
+		superio_outb(watchdog.sioaddr, SIO_REG_MFUNCT3,
+			superio_inb(watchdog.sioaddr, SIO_REG_MFUNCT3) & 0xcf);
 		break;
 
 	default:
@@ -711,16 +756,19 @@ static int __init f71808e_find(int sioaddr)
 	case SIO_F71808_ID:
 		watchdog.type = f71808fg;
 		break;
+	case SIO_F71862_ID:
+		watchdog.type = f71862fg;
+		err = f71862fg_pin_configure(0); /* validate module parameter */
+		break;
+	case SIO_F71869_ID:
+		watchdog.type = f71869;
+		break;
 	case SIO_F71882_ID:
 		watchdog.type = f71882fg;
 		break;
 	case SIO_F71889_ID:
 		watchdog.type = f71889fg;
 		break;
-	case SIO_F71862_ID:
-		/* These have a watchdog, though it isn't implemented (yet). */
-		err = -ENOSYS;
-		goto exit;
 	case SIO_F71858_ID:
 		/* Confirmed (by datasheet) not to have a watchdog. */
 		err = -ENODEV;
diff --git a/drivers/watchdog/iTCO_wdt.c b/drivers/watchdog/iTCO_wdt.c
index b8838d2..2c6c2b4 100644
--- a/drivers/watchdog/iTCO_wdt.c
+++ b/drivers/watchdog/iTCO_wdt.c
@@ -1,7 +1,7 @@
 /*
  *	intel TCO Watchdog Driver
  *
- *	(c) Copyright 2006-2009 Wim Van Sebroeck <wim@iguana.be>.
+ *	(c) Copyright 2006-2010 Wim Van Sebroeck <wim@iguana.be>.
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
@@ -26,13 +26,15 @@
  *	document number 301473-002, 301474-026: 82801F (ICH6)
  *	document number 313082-001, 313075-006: 631xESB, 632xESB
  *	document number 307013-003, 307014-024: 82801G (ICH7)
+ *	document number 322896-001, 322897-001: NM10
  *	document number 313056-003, 313057-017: 82801H (ICH8)
  *	document number 316972-004, 316973-012: 82801I (ICH9)
  *	document number 319973-002, 319974-002: 82801J (ICH10)
  *	document number 322169-001, 322170-003: 5 Series, 3400 Series (PCH)
  *	document number 320066-003, 320257-008: EP80597 (IICH)
- *	document number TBD                   : Cougar Point (CPT)
+ *	document number 324645-001, 324646-001: Cougar Point (CPT)
  *	document number TBD                   : Patsburg (PBG)
+ *	document number TBD                   : DH89xxCC
  */
 
 /*
@@ -85,6 +87,7 @@ enum iTCO_chipsets {
 	TCO_ICH7DH,	/* ICH7DH */
 	TCO_ICH7M,	/* ICH7-M & ICH7-U */
 	TCO_ICH7MDH,	/* ICH7-M DH */
+	TCO_NM10,	/* NM10 */
 	TCO_ICH8,	/* ICH8 & ICH8R */
 	TCO_ICH8DH,	/* ICH8DH */
 	TCO_ICH8DO,	/* ICH8DO */
@@ -149,6 +152,7 @@ enum iTCO_chipsets {
 	TCO_CPT31,	/* Cougar Point */
 	TCO_PBG1,	/* Patsburg */
 	TCO_PBG2,	/* Patsburg */
+	TCO_DH89XXCC,	/* DH89xxCC */
 };
 
 static struct {
@@ -174,6 +178,7 @@ static struct {
 	{"ICH7DH", 2},
 	{"ICH7-M or ICH7-U", 2},
 	{"ICH7-M DH", 2},
+	{"NM10", 2},
 	{"ICH8 or ICH8R", 2},
 	{"ICH8DH", 2},
 	{"ICH8DO", 2},
@@ -238,6 +243,7 @@ static struct {
 	{"Cougar Point", 2},
 	{"Patsburg", 2},
 	{"Patsburg", 2},
+	{"DH89xxCC", 2},
 	{NULL, 0}
 };
 
@@ -291,6 +297,7 @@ static struct pci_device_id iTCO_wdt_pci_tbl[] = {
 	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH7_30,		TCO_ICH7DH)},
 	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH7_1,		TCO_ICH7M)},
 	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH7_31,		TCO_ICH7MDH)},
+	{ ITCO_PCI_DEVICE(0x27bc,				TCO_NM10)},
 	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH8_0,		TCO_ICH8)},
 	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH8_2,		TCO_ICH8DH)},
 	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH8_3,		TCO_ICH8DO)},
@@ -355,6 +362,7 @@ static struct pci_device_id iTCO_wdt_pci_tbl[] = {
 	{ ITCO_PCI_DEVICE(0x1c5f,				TCO_CPT31)},
 	{ ITCO_PCI_DEVICE(0x1d40,				TCO_PBG1)},
 	{ ITCO_PCI_DEVICE(0x1d41,				TCO_PBG2)},
+	{ ITCO_PCI_DEVICE(0x2310,				TCO_DH89XXCC)},
 	{ 0, },			/* End of list */
 };
 MODULE_DEVICE_TABLE(pci, iTCO_wdt_pci_tbl);
diff --git a/drivers/watchdog/ks8695_wdt.c b/drivers/watchdog/ks8695_wdt.c
index 2852bb2..8114719 100644
--- a/drivers/watchdog/ks8695_wdt.c
+++ b/drivers/watchdog/ks8695_wdt.c
@@ -21,7 +21,7 @@
 #include <linux/watchdog.h>
 #include <linux/io.h>
 #include <linux/uaccess.h>
-#include <mach/timex.h>
+#include <mach/hardware.h>
 #include <mach/regs-timer.h>
 
 #define WDT_DEFAULT_TIME	5	/* seconds */
diff --git a/drivers/watchdog/m548x_wdt.c b/drivers/watchdog/m548x_wdt.c
new file mode 100644
index 0000000..cabbcfe
--- /dev/null
+++ b/drivers/watchdog/m548x_wdt.c
@@ -0,0 +1,227 @@
+/*
+ * drivers/watchdog/m548x_wdt.c
+ *
+ * Watchdog driver for ColdFire MCF548x processors
+ * Copyright 2010 (c) Philippe De Muyter <phdm@macqel.be>
+ *
+ * Adapted from the IXP4xx watchdog driver, which carries these notices:
+ *
+ *  Author: Deepak Saxena <dsaxena@plexity.net>
+ *
+ *  Copyright 2004 (c) MontaVista, Software, Inc.
+ *  Based on sa1100 driver, Copyright (C) 2000 Oleg Drokin <green@crimea.edu>
+ *
+ * This file is licensed under  the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/fs.h>
+#include <linux/miscdevice.h>
+#include <linux/watchdog.h>
+#include <linux/init.h>
+#include <linux/bitops.h>
+#include <linux/ioport.h>
+#include <linux/uaccess.h>
+
+#include <asm/coldfire.h>
+#include <asm/m548xsim.h>
+#include <asm/m548xgpt.h>
+
+static int nowayout = WATCHDOG_NOWAYOUT;
+static unsigned int heartbeat = 30;	/* (secs) Default is 0.5 minute */
+static unsigned long wdt_status;
+
+#define	WDT_IN_USE		0
+#define	WDT_OK_TO_CLOSE		1
+
+static void wdt_enable(void)
+{
+	unsigned int gms0;
+
+	/* preserve GPIO usage, if any */
+	gms0 = __raw_readl(MCF_MBAR + MCF_GPT_GMS0);
+	if (gms0 & MCF_GPT_GMS_TMS_GPIO)
+		gms0 &= (MCF_GPT_GMS_TMS_GPIO | MCF_GPT_GMS_GPIO_MASK
+							| MCF_GPT_GMS_OD);
+	else
+		gms0 = MCF_GPT_GMS_TMS_GPIO | MCF_GPT_GMS_OD;
+	__raw_writel(gms0, MCF_MBAR + MCF_GPT_GMS0);
+	__raw_writel(MCF_GPT_GCIR_PRE(heartbeat*(MCF_BUSCLK/0xffff)) |
+			MCF_GPT_GCIR_CNT(0xffff), MCF_MBAR + MCF_GPT_GCIR0);
+	gms0 |= MCF_GPT_GMS_OCPW(0xA5) | MCF_GPT_GMS_WDEN | MCF_GPT_GMS_CE;
+	__raw_writel(gms0, MCF_MBAR + MCF_GPT_GMS0);
+}
+
+static void wdt_disable(void)
+{
+	unsigned int gms0;
+
+	/* disable watchdog */
+	gms0 = __raw_readl(MCF_MBAR + MCF_GPT_GMS0);
+	gms0 &= ~(MCF_GPT_GMS_WDEN | MCF_GPT_GMS_CE);
+	__raw_writel(gms0, MCF_MBAR + MCF_GPT_GMS0);
+}
+
+static void wdt_keepalive(void)
+{
+	unsigned int gms0;
+
+	gms0 = __raw_readl(MCF_MBAR + MCF_GPT_GMS0);
+	gms0 |= MCF_GPT_GMS_OCPW(0xA5);
+	__raw_writel(gms0, MCF_MBAR + MCF_GPT_GMS0);
+}
+
+static int m548x_wdt_open(struct inode *inode, struct file *file)
+{
+	if (test_and_set_bit(WDT_IN_USE, &wdt_status))
+		return -EBUSY;
+
+	clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
+	wdt_enable();
+	return nonseekable_open(inode, file);
+}
+
+static ssize_t m548x_wdt_write(struct file *file, const char *data,
+						size_t len, loff_t *ppos)
+{
+	if (len) {
+		if (!nowayout) {
+			size_t i;
+
+			clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
+
+			for (i = 0; i != len; i++) {
+				char c;
+
+				if (get_user(c, data + i))
+					return -EFAULT;
+				if (c == 'V')
+					set_bit(WDT_OK_TO_CLOSE, &wdt_status);
+			}
+		}
+		wdt_keepalive();
+	}
+	return len;
+}
+
+static const struct watchdog_info ident = {
+	.options	= WDIOF_MAGICCLOSE | WDIOF_SETTIMEOUT |
+				WDIOF_KEEPALIVEPING,
+	.identity	= "Coldfire M548x Watchdog",
+};
+
+static long m548x_wdt_ioctl(struct file *file, unsigned int cmd,
+							 unsigned long arg)
+{
+	int ret = -ENOTTY;
+	int time;
+
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		ret = copy_to_user((struct watchdog_info *)arg, &ident,
+				   sizeof(ident)) ? -EFAULT : 0;
+		break;
+
+	case WDIOC_GETSTATUS:
+		ret = put_user(0, (int *)arg);
+		break;
+
+	case WDIOC_GETBOOTSTATUS:
+		ret = put_user(0, (int *)arg);
+		break;
+
+	case WDIOC_KEEPALIVE:
+		wdt_keepalive();
+		ret = 0;
+		break;
+
+	case WDIOC_SETTIMEOUT:
+		ret = get_user(time, (int *)arg);
+		if (ret)
+			break;
+
+		if (time <= 0 || time > 30) {
+			ret = -EINVAL;
+			break;
+		}
+
+		heartbeat = time;
+		wdt_enable();
+		/* Fall through */
+
+	case WDIOC_GETTIMEOUT:
+		ret = put_user(heartbeat, (int *)arg);
+		break;
+	}
+	return ret;
+}
+
+static int m548x_wdt_release(struct inode *inode, struct file *file)
+{
+	if (test_bit(WDT_OK_TO_CLOSE, &wdt_status))
+		wdt_disable();
+	else {
+		printk(KERN_CRIT "WATCHDOG: Device closed unexpectedly - "
+					"timer will not stop\n");
+		wdt_keepalive();
+	}
+	clear_bit(WDT_IN_USE, &wdt_status);
+	clear_bit(WDT_OK_TO_CLOSE, &wdt_status);
+
+	return 0;
+}
+
+
+static const struct file_operations m548x_wdt_fops = {
+	.owner		= THIS_MODULE,
+	.llseek		= no_llseek,
+	.write		= m548x_wdt_write,
+	.unlocked_ioctl	= m548x_wdt_ioctl,
+	.open		= m548x_wdt_open,
+	.release	= m548x_wdt_release,
+};
+
+static struct miscdevice m548x_wdt_miscdev = {
+	.minor		= WATCHDOG_MINOR,
+	.name		= "watchdog",
+	.fops		= &m548x_wdt_fops,
+};
+
+static int __init m548x_wdt_init(void)
+{
+	if (!request_mem_region(MCF_MBAR + MCF_GPT_GCIR0, 4,
+						"Coldfire M548x Watchdog")) {
+		printk(KERN_WARNING
+				"Coldfire M548x Watchdog : I/O region busy\n");
+		return -EBUSY;
+	}
+	printk(KERN_INFO "ColdFire watchdog driver is loaded.\n");
+
+	return misc_register(&m548x_wdt_miscdev);
+}
+
+static void __exit m548x_wdt_exit(void)
+{
+	misc_deregister(&m548x_wdt_miscdev);
+	release_mem_region(MCF_MBAR + MCF_GPT_GCIR0, 4);
+}
+
+module_init(m548x_wdt_init);
+module_exit(m548x_wdt_exit);
+
+MODULE_AUTHOR("Philippe De Muyter <phdm@macqel.be>");
+MODULE_DESCRIPTION("Coldfire M548x Watchdog");
+
+module_param(heartbeat, int, 0);
+MODULE_PARM_DESC(heartbeat, "Watchdog heartbeat in seconds (default 30s)");
+
+module_param(nowayout, int, 0);
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started");
+
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
diff --git a/drivers/watchdog/nv_tco.c b/drivers/watchdog/nv_tco.c
new file mode 100644
index 0000000..1a50aa7
--- /dev/null
+++ b/drivers/watchdog/nv_tco.c
@@ -0,0 +1,512 @@
+/*
+ *	nv_tco 0.01:	TCO timer driver for NV chipsets
+ *
+ *	(c) Copyright 2005 Google Inc., All Rights Reserved.
+ *
+ *	Based off i8xx_tco.c:
+ *	(c) Copyright 2000 kernel concepts <nils@kernelconcepts.de>, All Rights
+ *	Reserved.
+ *				http://www.kernelconcepts.de
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License
+ *	as published by the Free Software Foundation; either version
+ *	2 of the License, or (at your option) any later version.
+ *
+ *	TCO timer driver for NV chipsets
+ *	based on softdog.c by Alan Cox <alan@redhat.com>
+ */
+
+/*
+ *	Includes, defines, variables, module parameters, ...
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/types.h>
+#include <linux/miscdevice.h>
+#include <linux/watchdog.h>
+#include <linux/init.h>
+#include <linux/fs.h>
+#include <linux/pci.h>
+#include <linux/ioport.h>
+#include <linux/jiffies.h>
+#include <linux/platform_device.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
+
+#include "nv_tco.h"
+
+/* Module and version information */
+#define TCO_VERSION "0.01"
+#define TCO_MODULE_NAME "NV_TCO"
+#define TCO_DRIVER_NAME   TCO_MODULE_NAME ", v" TCO_VERSION
+#define PFX TCO_MODULE_NAME ": "
+
+/* internal variables */
+static unsigned int tcobase;
+static DEFINE_SPINLOCK(tco_lock);	/* Guards the hardware */
+static unsigned long timer_alive;
+static char tco_expect_close;
+static struct pci_dev *tco_pci;
+
+/* the watchdog platform device */
+static struct platform_device *nv_tco_platform_device;
+
+/* module parameters */
+#define WATCHDOG_HEARTBEAT 30	/* 30 sec default heartbeat (2<heartbeat<39) */
+static int heartbeat = WATCHDOG_HEARTBEAT;  /* in seconds */
+module_param(heartbeat, int, 0);
+MODULE_PARM_DESC(heartbeat, "Watchdog heartbeat in seconds. (2<heartbeat<39, "
+			    "default=" __MODULE_STRING(WATCHDOG_HEARTBEAT) ")");
+
+static int nowayout = WATCHDOG_NOWAYOUT;
+module_param(nowayout, int, 0);
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started"
+		" (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+
+/*
+ * Some TCO specific functions
+ */
+static inline unsigned char seconds_to_ticks(int seconds)
+{
+	/* the internal timer is stored as ticks which decrement
+	 * every 0.6 seconds */
+	return (seconds * 10) / 6;
+}
+
+static void tco_timer_start(void)
+{
+	u32 val;
+	unsigned long flags;
+
+	spin_lock_irqsave(&tco_lock, flags);
+	val = inl(TCO_CNT(tcobase));
+	val &= ~TCO_CNT_TCOHALT;
+	outl(val, TCO_CNT(tcobase));
+	spin_unlock_irqrestore(&tco_lock, flags);
+}
+
+static void tco_timer_stop(void)
+{
+	u32 val;
+	unsigned long flags;
+
+	spin_lock_irqsave(&tco_lock, flags);
+	val = inl(TCO_CNT(tcobase));
+	val |= TCO_CNT_TCOHALT;
+	outl(val, TCO_CNT(tcobase));
+	spin_unlock_irqrestore(&tco_lock, flags);
+}
+
+static void tco_timer_keepalive(void)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&tco_lock, flags);
+	outb(0x01, TCO_RLD(tcobase));
+	spin_unlock_irqrestore(&tco_lock, flags);
+}
+
+static int tco_timer_set_heartbeat(int t)
+{
+	int ret = 0;
+	unsigned char tmrval;
+	unsigned long flags;
+	u8 val;
+
+	/*
+	 * note seconds_to_ticks(t) > t, so if t > 0x3f, so is
+	 * tmrval=seconds_to_ticks(t).  Check that the count in seconds isn't
+	 * out of range on it's own (to avoid overflow in tmrval).
+	 */
+	if (t < 0 || t > 0x3f)
+		return -EINVAL;
+	tmrval = seconds_to_ticks(t);
+
+	/* "Values of 0h-3h are ignored and should not be attempted" */
+	if (tmrval > 0x3f || tmrval < 0x04)
+		return -EINVAL;
+
+	/* Write new heartbeat to watchdog */
+	spin_lock_irqsave(&tco_lock, flags);
+	val = inb(TCO_TMR(tcobase));
+	val &= 0xc0;
+	val |= tmrval;
+	outb(val, TCO_TMR(tcobase));
+	val = inb(TCO_TMR(tcobase));
+
+	if ((val & 0x3f) != tmrval)
+		ret = -EINVAL;
+	spin_unlock_irqrestore(&tco_lock, flags);
+
+	if (ret)
+		return ret;
+
+	heartbeat = t;
+	return 0;
+}
+
+/*
+ *	/dev/watchdog handling
+ */
+
+static int nv_tco_open(struct inode *inode, struct file *file)
+{
+	/* /dev/watchdog can only be opened once */
+	if (test_and_set_bit(0, &timer_alive))
+		return -EBUSY;
+
+	/* Reload and activate timer */
+	tco_timer_keepalive();
+	tco_timer_start();
+	return nonseekable_open(inode, file);
+}
+
+static int nv_tco_release(struct inode *inode, struct file *file)
+{
+	/* Shut off the timer */
+	if (tco_expect_close == 42) {
+		tco_timer_stop();
+	} else {
+		printk(KERN_CRIT PFX "Unexpected close, not stopping "
+		       "watchdog!\n");
+		tco_timer_keepalive();
+	}
+	clear_bit(0, &timer_alive);
+	tco_expect_close = 0;
+	return 0;
+}
+
+static ssize_t nv_tco_write(struct file *file, const char __user *data,
+			    size_t len, loff_t *ppos)
+{
+	/* See if we got the magic character 'V' and reload the timer */
+	if (len) {
+		if (!nowayout) {
+			size_t i;
+
+			/*
+			 * note: just in case someone wrote the magic character
+			 * five months ago...
+			 */
+			tco_expect_close = 0;
+
+			/*
+			 * scan to see whether or not we got the magic
+			 * character
+			 */
+			for (i = 0; i != len; i++) {
+				char c;
+				if (get_user(c, data + i))
+					return -EFAULT;
+				if (c == 'V')
+					tco_expect_close = 42;
+			}
+		}
+
+		/* someone wrote to us, we should reload the timer */
+		tco_timer_keepalive();
+	}
+	return len;
+}
+
+static long nv_tco_ioctl(struct file *file, unsigned int cmd,
+			 unsigned long arg)
+{
+	int new_options, retval = -EINVAL;
+	int new_heartbeat;
+	void __user *argp = (void __user *)arg;
+	int __user *p = argp;
+	static const struct watchdog_info ident = {
+		.options =		WDIOF_SETTIMEOUT |
+					WDIOF_KEEPALIVEPING |
+					WDIOF_MAGICCLOSE,
+		.firmware_version =	0,
+		.identity =		TCO_MODULE_NAME,
+	};
+
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		return copy_to_user(argp, &ident, sizeof(ident)) ? -EFAULT : 0;
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, p);
+	case WDIOC_SETOPTIONS:
+		if (get_user(new_options, p))
+			return -EFAULT;
+		if (new_options & WDIOS_DISABLECARD) {
+			tco_timer_stop();
+			retval = 0;
+		}
+		if (new_options & WDIOS_ENABLECARD) {
+			tco_timer_keepalive();
+			tco_timer_start();
+			retval = 0;
+		}
+		return retval;
+	case WDIOC_KEEPALIVE:
+		tco_timer_keepalive();
+		return 0;
+	case WDIOC_SETTIMEOUT:
+		if (get_user(new_heartbeat, p))
+			return -EFAULT;
+		if (tco_timer_set_heartbeat(new_heartbeat))
+			return -EINVAL;
+		tco_timer_keepalive();
+		/* Fall through */
+	case WDIOC_GETTIMEOUT:
+		return put_user(heartbeat, p);
+	default:
+		return -ENOTTY;
+	}
+}
+
+/*
+ *	Kernel Interfaces
+ */
+
+static const struct file_operations nv_tco_fops = {
+	.owner =		THIS_MODULE,
+	.llseek =		no_llseek,
+	.write =		nv_tco_write,
+	.unlocked_ioctl =	nv_tco_ioctl,
+	.open =			nv_tco_open,
+	.release =		nv_tco_release,
+};
+
+static struct miscdevice nv_tco_miscdev = {
+	.minor =	WATCHDOG_MINOR,
+	.name =		"watchdog",
+	.fops =		&nv_tco_fops,
+};
+
+/*
+ * Data for PCI driver interface
+ *
+ * This data only exists for exporting the supported
+ * PCI ids via MODULE_DEVICE_TABLE.  We do not actually
+ * register a pci_driver, because someone else might one day
+ * want to register another driver on the same PCI id.
+ */
+static struct pci_device_id tco_pci_tbl[] = {
+	{ PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP51_SMBUS,
+	  PCI_ANY_ID, PCI_ANY_ID, },
+	{ PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP55_SMBUS,
+	  PCI_ANY_ID, PCI_ANY_ID, },
+	{ 0, },			/* End of list */
+};
+MODULE_DEVICE_TABLE(pci, tco_pci_tbl);
+
+/*
+ *	Init & exit routines
+ */
+
+static unsigned char __init nv_tco_getdevice(void)
+{
+	struct pci_dev *dev = NULL;
+	u32 val;
+
+	/* Find the PCI device */
+	for_each_pci_dev(dev) {
+		if (pci_match_id(tco_pci_tbl, dev) != NULL) {
+			tco_pci = dev;
+			break;
+		}
+	}
+
+	if (!tco_pci)
+		return 0;
+
+	/* Find the base io port */
+	pci_read_config_dword(tco_pci, 0x64, &val);
+	val &= 0xffff;
+	if (val == 0x0001 || val == 0x0000) {
+		/* Something is wrong here, bar isn't setup */
+		printk(KERN_ERR PFX "failed to get tcobase address\n");
+		return 0;
+	}
+	val &= 0xff00;
+	tcobase = val + 0x40;
+
+	if (!request_region(tcobase, 0x10, "NV TCO")) {
+		printk(KERN_ERR PFX "I/O address 0x%04x already in use\n",
+		       tcobase);
+		return 0;
+	}
+
+	/* Set a reasonable heartbeat before we stop the timer */
+	tco_timer_set_heartbeat(30);
+
+	/*
+	 * Stop the TCO before we change anything so we don't race with
+	 * a zeroed timer.
+	 */
+	tco_timer_keepalive();
+	tco_timer_stop();
+
+	/* Disable SMI caused by TCO */
+	if (!request_region(MCP51_SMI_EN(tcobase), 4, "NV TCO")) {
+		printk(KERN_ERR PFX "I/O address 0x%04x already in use\n",
+		       MCP51_SMI_EN(tcobase));
+		goto out;
+	}
+	val = inl(MCP51_SMI_EN(tcobase));
+	val &= ~MCP51_SMI_EN_TCO;
+	outl(val, MCP51_SMI_EN(tcobase));
+	val = inl(MCP51_SMI_EN(tcobase));
+	release_region(MCP51_SMI_EN(tcobase), 4);
+	if (val & MCP51_SMI_EN_TCO) {
+		printk(KERN_ERR PFX "Could not disable SMI caused by TCO\n");
+		goto out;
+	}
+
+	/* Check chipset's NO_REBOOT bit */
+	pci_read_config_dword(tco_pci, MCP51_SMBUS_SETUP_B, &val);
+	val |= MCP51_SMBUS_SETUP_B_TCO_REBOOT;
+	pci_write_config_dword(tco_pci, MCP51_SMBUS_SETUP_B, val);
+	pci_read_config_dword(tco_pci, MCP51_SMBUS_SETUP_B, &val);
+	if (!(val & MCP51_SMBUS_SETUP_B_TCO_REBOOT)) {
+		printk(KERN_ERR PFX "failed to reset NO_REBOOT flag, reboot "
+		       "disabled by hardware\n");
+		goto out;
+	}
+
+	return 1;
+out:
+	release_region(tcobase, 0x10);
+	return 0;
+}
+
+static int __devinit nv_tco_init(struct platform_device *dev)
+{
+	int ret;
+
+	/* Check whether or not the hardware watchdog is there */
+	if (!nv_tco_getdevice())
+		return -ENODEV;
+
+	/* Check to see if last reboot was due to watchdog timeout */
+	printk(KERN_INFO PFX "Watchdog reboot %sdetected.\n",
+	       inl(TCO_STS(tcobase)) & TCO_STS_TCO2TO_STS ? "" : "not ");
+
+	/* Clear out the old status */
+	outl(TCO_STS_RESET, TCO_STS(tcobase));
+
+	/*
+	 * Check that the heartbeat value is within it's range.
+	 * If not, reset to the default.
+	 */
+	if (tco_timer_set_heartbeat(heartbeat)) {
+		heartbeat = WATCHDOG_HEARTBEAT;
+		tco_timer_set_heartbeat(heartbeat);
+		printk(KERN_INFO PFX "heartbeat value must be 2<heartbeat<39, "
+		       "using %d\n", heartbeat);
+	}
+
+	ret = misc_register(&nv_tco_miscdev);
+	if (ret != 0) {
+		printk(KERN_ERR PFX "cannot register miscdev on minor=%d "
+		       "(err=%d)\n", WATCHDOG_MINOR, ret);
+		goto unreg_region;
+	}
+
+	clear_bit(0, &timer_alive);
+
+	tco_timer_stop();
+
+	printk(KERN_INFO PFX "initialized (0x%04x). heartbeat=%d sec "
+	       "(nowayout=%d)\n", tcobase, heartbeat, nowayout);
+
+	return 0;
+
+unreg_region:
+	release_region(tcobase, 0x10);
+	return ret;
+}
+
+static void __devexit nv_tco_cleanup(void)
+{
+	u32 val;
+
+	/* Stop the timer before we leave */
+	if (!nowayout)
+		tco_timer_stop();
+
+	/* Set the NO_REBOOT bit to prevent later reboots, just for sure */
+	pci_read_config_dword(tco_pci, MCP51_SMBUS_SETUP_B, &val);
+	val &= ~MCP51_SMBUS_SETUP_B_TCO_REBOOT;
+	pci_write_config_dword(tco_pci, MCP51_SMBUS_SETUP_B, val);
+	pci_read_config_dword(tco_pci, MCP51_SMBUS_SETUP_B, &val);
+	if (val & MCP51_SMBUS_SETUP_B_TCO_REBOOT) {
+		printk(KERN_CRIT PFX "Couldn't unset REBOOT bit.  Machine may "
+		       "soon reset\n");
+	}
+
+	/* Deregister */
+	misc_deregister(&nv_tco_miscdev);
+	release_region(tcobase, 0x10);
+}
+
+static int __devexit nv_tco_remove(struct platform_device *dev)
+{
+	if (tcobase)
+		nv_tco_cleanup();
+
+	return 0;
+}
+
+static void nv_tco_shutdown(struct platform_device *dev)
+{
+	tco_timer_stop();
+}
+
+static struct platform_driver nv_tco_driver = {
+	.probe		= nv_tco_init,
+	.remove		= __devexit_p(nv_tco_remove),
+	.shutdown	= nv_tco_shutdown,
+	.driver		= {
+		.owner	= THIS_MODULE,
+		.name	= TCO_MODULE_NAME,
+	},
+};
+
+static int __init nv_tco_init_module(void)
+{
+	int err;
+
+	printk(KERN_INFO PFX "NV TCO WatchDog Timer Driver v%s\n",
+	       TCO_VERSION);
+
+	err = platform_driver_register(&nv_tco_driver);
+	if (err)
+		return err;
+
+	nv_tco_platform_device = platform_device_register_simple(
+					TCO_MODULE_NAME, -1, NULL, 0);
+	if (IS_ERR(nv_tco_platform_device)) {
+		err = PTR_ERR(nv_tco_platform_device);
+		goto unreg_platform_driver;
+	}
+
+	return 0;
+
+unreg_platform_driver:
+	platform_driver_unregister(&nv_tco_driver);
+	return err;
+}
+
+static void __exit nv_tco_cleanup_module(void)
+{
+	platform_device_unregister(nv_tco_platform_device);
+	platform_driver_unregister(&nv_tco_driver);
+	printk(KERN_INFO PFX "NV TCO Watchdog Module Unloaded.\n");
+}
+
+module_init(nv_tco_init_module);
+module_exit(nv_tco_cleanup_module);
+
+MODULE_AUTHOR("Mike Waychison");
+MODULE_DESCRIPTION("TCO timer driver for NV chipsets");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
diff --git a/drivers/watchdog/nv_tco.h b/drivers/watchdog/nv_tco.h
new file mode 100644
index 0000000..c2d1d04
--- /dev/null
+++ b/drivers/watchdog/nv_tco.h
@@ -0,0 +1,64 @@
+/*
+ *	nv_tco:	TCO timer driver for nVidia chipsets.
+ *
+ *	(c) Copyright 2005 Google Inc., All Rights Reserved.
+ *
+ *	Supported Chipsets:
+ *		- MCP51/MCP55
+ *
+ *	(c) Copyright 2000 kernel concepts <nils@kernelconcepts.de>, All Rights
+ *	Reserved.
+ *				http://www.kernelconcepts.de
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License
+ *	as published by the Free Software Foundation; either version
+ *	2 of the License, or (at your option) any later version.
+ *
+ *	Neither kernel concepts nor Nils Faerber admit liability nor provide
+ *	warranty for any of this software. This material is provided
+ *	"AS-IS" and at no charge.
+ *
+ *	(c) Copyright 2000	kernel concepts <nils@kernelconcepts.de>
+ *				developed for
+ *                              Jentro AG, Haar/Munich (Germany)
+ *
+ *	TCO timer driver for NV chipsets
+ *	based on softdog.c by Alan Cox <alan@redhat.com>
+ */
+
+/*
+ * Some address definitions for the TCO
+ */
+
+#define TCO_RLD(base)	((base) + 0x00)	/* TCO Timer Reload and Current Value */
+#define TCO_TMR(base)	((base) + 0x01)	/* TCO Timer Initial Value	*/
+
+#define TCO_STS(base)	((base) + 0x04)	/* TCO Status Register		*/
+/*
+ * TCO Boot Status bit: set on TCO reset, reset by software or standby
+ * power-good (survives reboots), unfortunately this bit is never
+ * set.
+ */
+#  define TCO_STS_BOOT_STS	(1 << 9)
+/*
+ * first and 2nd timeout status bits, these also survive a warm boot,
+ * and they work, so we use them.
+ */
+#  define TCO_STS_TCO_INT_STS	(1 << 1)
+#  define TCO_STS_TCO2TO_STS	(1 << 10)
+#  define TCO_STS_RESET		(TCO_STS_BOOT_STS | TCO_STS_TCO2TO_STS | \
+				 TCO_STS_TCO_INT_STS)
+
+#define TCO_CNT(base)	((base) + 0x08)	/* TCO Control Register	*/
+#  define TCO_CNT_TCOHALT	(1 << 12)
+
+#define MCP51_SMBUS_SETUP_B 0xe8
+#  define MCP51_SMBUS_SETUP_B_TCO_REBOOT (1 << 25)
+
+/*
+ * The SMI_EN register is at the base io address + 0x04,
+ * while TCOBASE is + 0x40.
+ */
+#define MCP51_SMI_EN(base)	((base) - 0x40 + 0x04)
+#  define MCP51_SMI_EN_TCO	((1 << 4) | (1 << 5))
diff --git a/drivers/watchdog/sp5100_tco.c b/drivers/watchdog/sp5100_tco.c
new file mode 100644
index 0000000..8083728
--- /dev/null
+++ b/drivers/watchdog/sp5100_tco.c
@@ -0,0 +1,480 @@
+/*
+ *	sp5100_tco :	TCO timer driver for sp5100 chipsets
+ *
+ *	(c) Copyright 2009 Google Inc., All Rights Reserved.
+ *
+ *	Based on i8xx_tco.c:
+ *	(c) Copyright 2000 kernel concepts <nils@kernelconcepts.de>, All Rights
+ *	Reserved.
+ *				http://www.kernelconcepts.de
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License
+ *	as published by the Free Software Foundation; either version
+ *	2 of the License, or (at your option) any later version.
+ *
+ *	See AMD Publication 43009 "AMD SB700/710/750 Register Reference Guide"
+ */
+
+/*
+ *	Includes, defines, variables, module parameters, ...
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/types.h>
+#include <linux/miscdevice.h>
+#include <linux/watchdog.h>
+#include <linux/init.h>
+#include <linux/fs.h>
+#include <linux/pci.h>
+#include <linux/ioport.h>
+#include <linux/platform_device.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
+
+#include "sp5100_tco.h"
+
+/* Module and version information */
+#define TCO_VERSION "0.01"
+#define TCO_MODULE_NAME "SP5100 TCO timer"
+#define TCO_DRIVER_NAME   TCO_MODULE_NAME ", v" TCO_VERSION
+#define PFX TCO_MODULE_NAME ": "
+
+/* internal variables */
+static void __iomem *tcobase;
+static unsigned int pm_iobase;
+static DEFINE_SPINLOCK(tco_lock);	/* Guards the hardware */
+static unsigned long timer_alive;
+static char tco_expect_close;
+static struct pci_dev *sp5100_tco_pci;
+
+/* the watchdog platform device */
+static struct platform_device *sp5100_tco_platform_device;
+
+/* module parameters */
+
+#define WATCHDOG_HEARTBEAT 60	/* 60 sec default heartbeat. */
+static int heartbeat = WATCHDOG_HEARTBEAT;  /* in seconds */
+module_param(heartbeat, int, 0);
+MODULE_PARM_DESC(heartbeat, "Watchdog heartbeat in seconds. (default="
+		 __MODULE_STRING(WATCHDOG_HEARTBEAT) ")");
+
+static int nowayout = WATCHDOG_NOWAYOUT;
+module_param(nowayout, int, 0);
+MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started"
+		" (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+
+/*
+ * Some TCO specific functions
+ */
+static void tco_timer_start(void)
+{
+	u32 val;
+	unsigned long flags;
+
+	spin_lock_irqsave(&tco_lock, flags);
+	val = readl(SP5100_WDT_CONTROL(tcobase));
+	val |= SP5100_WDT_START_STOP_BIT;
+	writel(val, SP5100_WDT_CONTROL(tcobase));
+	spin_unlock_irqrestore(&tco_lock, flags);
+}
+
+static void tco_timer_stop(void)
+{
+	u32 val;
+	unsigned long flags;
+
+	spin_lock_irqsave(&tco_lock, flags);
+	val = readl(SP5100_WDT_CONTROL(tcobase));
+	val &= ~SP5100_WDT_START_STOP_BIT;
+	writel(val, SP5100_WDT_CONTROL(tcobase));
+	spin_unlock_irqrestore(&tco_lock, flags);
+}
+
+static void tco_timer_keepalive(void)
+{
+	u32 val;
+	unsigned long flags;
+
+	spin_lock_irqsave(&tco_lock, flags);
+	val = readl(SP5100_WDT_CONTROL(tcobase));
+	val |= SP5100_WDT_TRIGGER_BIT;
+	writel(val, SP5100_WDT_CONTROL(tcobase));
+	spin_unlock_irqrestore(&tco_lock, flags);
+}
+
+static int tco_timer_set_heartbeat(int t)
+{
+	unsigned long flags;
+
+	if (t < 0 || t > 0xffff)
+		return -EINVAL;
+
+	/* Write new heartbeat to watchdog */
+	spin_lock_irqsave(&tco_lock, flags);
+	writel(t, SP5100_WDT_COUNT(tcobase));
+	spin_unlock_irqrestore(&tco_lock, flags);
+
+	heartbeat = t;
+	return 0;
+}
+
+/*
+ *	/dev/watchdog handling
+ */
+
+static int sp5100_tco_open(struct inode *inode, struct file *file)
+{
+	/* /dev/watchdog can only be opened once */
+	if (test_and_set_bit(0, &timer_alive))
+		return -EBUSY;
+
+	/* Reload and activate timer */
+	tco_timer_start();
+	tco_timer_keepalive();
+	return nonseekable_open(inode, file);
+}
+
+static int sp5100_tco_release(struct inode *inode, struct file *file)
+{
+	/* Shut off the timer. */
+	if (tco_expect_close == 42) {
+		tco_timer_stop();
+	} else {
+		printk(KERN_CRIT PFX
+			"Unexpected close, not stopping watchdog!\n");
+		tco_timer_keepalive();
+	}
+	clear_bit(0, &timer_alive);
+	tco_expect_close = 0;
+	return 0;
+}
+
+static ssize_t sp5100_tco_write(struct file *file, const char __user *data,
+				size_t len, loff_t *ppos)
+{
+	/* See if we got the magic character 'V' and reload the timer */
+	if (len) {
+		if (!nowayout) {
+			size_t i;
+
+			/* note: just in case someone wrote the magic character
+			 * five months ago... */
+			tco_expect_close = 0;
+
+			/* scan to see whether or not we got the magic character
+			 */
+			for (i = 0; i != len; i++) {
+				char c;
+				if (get_user(c, data + i))
+					return -EFAULT;
+				if (c == 'V')
+					tco_expect_close = 42;
+			}
+		}
+
+		/* someone wrote to us, we should reload the timer */
+		tco_timer_keepalive();
+	}
+	return len;
+}
+
+static long sp5100_tco_ioctl(struct file *file, unsigned int cmd,
+			     unsigned long arg)
+{
+	int new_options, retval = -EINVAL;
+	int new_heartbeat;
+	void __user *argp = (void __user *)arg;
+	int __user *p = argp;
+	static const struct watchdog_info ident = {
+		.options =		WDIOF_SETTIMEOUT |
+					WDIOF_KEEPALIVEPING |
+					WDIOF_MAGICCLOSE,
+		.firmware_version =	0,
+		.identity =		TCO_MODULE_NAME,
+	};
+
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		return copy_to_user(argp, &ident,
+			sizeof(ident)) ? -EFAULT : 0;
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, p);
+	case WDIOC_SETOPTIONS:
+		if (get_user(new_options, p))
+			return -EFAULT;
+		if (new_options & WDIOS_DISABLECARD) {
+			tco_timer_stop();
+			retval = 0;
+		}
+		if (new_options & WDIOS_ENABLECARD) {
+			tco_timer_start();
+			tco_timer_keepalive();
+			retval = 0;
+		}
+		return retval;
+	case WDIOC_KEEPALIVE:
+		tco_timer_keepalive();
+		return 0;
+	case WDIOC_SETTIMEOUT:
+		if (get_user(new_heartbeat, p))
+			return -EFAULT;
+		if (tco_timer_set_heartbeat(new_heartbeat))
+			return -EINVAL;
+		tco_timer_keepalive();
+		/* Fall through */
+	case WDIOC_GETTIMEOUT:
+		return put_user(heartbeat, p);
+	default:
+		return -ENOTTY;
+	}
+}
+
+/*
+ * Kernel Interfaces
+ */
+
+static const struct file_operations sp5100_tco_fops = {
+	.owner =		THIS_MODULE,
+	.llseek =		no_llseek,
+	.write =		sp5100_tco_write,
+	.unlocked_ioctl =	sp5100_tco_ioctl,
+	.open =			sp5100_tco_open,
+	.release =		sp5100_tco_release,
+};
+
+static struct miscdevice sp5100_tco_miscdev = {
+	.minor =	WATCHDOG_MINOR,
+	.name =		"watchdog",
+	.fops =		&sp5100_tco_fops,
+};
+
+/*
+ * Data for PCI driver interface
+ *
+ * This data only exists for exporting the supported
+ * PCI ids via MODULE_DEVICE_TABLE.  We do not actually
+ * register a pci_driver, because someone else might
+ * want to register another driver on the same PCI id.
+ */
+static struct pci_device_id sp5100_tco_pci_tbl[] = {
+	{ PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_SBX00_SMBUS, PCI_ANY_ID,
+	  PCI_ANY_ID, },
+	{ 0, },			/* End of list */
+};
+MODULE_DEVICE_TABLE(pci, sp5100_tco_pci_tbl);
+
+/*
+ * Init & exit routines
+ */
+
+static unsigned char __devinit sp5100_tco_setupdevice(void)
+{
+	struct pci_dev *dev = NULL;
+	u32 val;
+
+	/* Match the PCI device */
+	for_each_pci_dev(dev) {
+		if (pci_match_id(sp5100_tco_pci_tbl, dev) != NULL) {
+			sp5100_tco_pci = dev;
+			break;
+		}
+	}
+
+	if (!sp5100_tco_pci)
+		return 0;
+
+	/* Request the IO ports used by this driver */
+	pm_iobase = SP5100_IO_PM_INDEX_REG;
+	if (!request_region(pm_iobase, SP5100_PM_IOPORTS_SIZE, "SP5100 TCO")) {
+		printk(KERN_ERR PFX "I/O address 0x%04x already in use\n",
+			pm_iobase);
+		goto exit;
+	}
+
+	/* Find the watchdog base address. */
+	outb(SP5100_PM_WATCHDOG_BASE3, SP5100_IO_PM_INDEX_REG);
+	val = inb(SP5100_IO_PM_DATA_REG);
+	outb(SP5100_PM_WATCHDOG_BASE2, SP5100_IO_PM_INDEX_REG);
+	val = val << 8 | inb(SP5100_IO_PM_DATA_REG);
+	outb(SP5100_PM_WATCHDOG_BASE1, SP5100_IO_PM_INDEX_REG);
+	val = val << 8 | inb(SP5100_IO_PM_DATA_REG);
+	outb(SP5100_PM_WATCHDOG_BASE0, SP5100_IO_PM_INDEX_REG);
+	/* Low three bits of BASE0 are reserved. */
+	val = val << 8 | (inb(SP5100_IO_PM_DATA_REG) & 0xf8);
+
+	tcobase = ioremap(val, SP5100_WDT_MEM_MAP_SIZE);
+	if (tcobase == 0) {
+		printk(KERN_ERR PFX "failed to get tcobase address\n");
+		goto unreg_region;
+	}
+
+	/* Enable watchdog decode bit */
+	pci_read_config_dword(sp5100_tco_pci,
+			      SP5100_PCI_WATCHDOG_MISC_REG,
+			      &val);
+
+	val |= SP5100_PCI_WATCHDOG_DECODE_EN;
+
+	pci_write_config_dword(sp5100_tco_pci,
+			       SP5100_PCI_WATCHDOG_MISC_REG,
+			       val);
+
+	/* Enable Watchdog timer and set the resolution to 1 sec. */
+	outb(SP5100_PM_WATCHDOG_CONTROL, SP5100_IO_PM_INDEX_REG);
+	val = inb(SP5100_IO_PM_DATA_REG);
+	val |= SP5100_PM_WATCHDOG_SECOND_RES;
+	val &= ~SP5100_PM_WATCHDOG_DISABLE;
+	outb(val, SP5100_IO_PM_DATA_REG);
+
+	/* Check that the watchdog action is set to reset the system. */
+	val = readl(SP5100_WDT_CONTROL(tcobase));
+	val &= ~SP5100_PM_WATCHDOG_ACTION_RESET;
+	writel(val, SP5100_WDT_CONTROL(tcobase));
+
+	/* Set a reasonable heartbeat before we stop the timer */
+	tco_timer_set_heartbeat(heartbeat);
+
+	/*
+	 * Stop the TCO before we change anything so we don't race with
+	 * a zeroed timer.
+	 */
+	tco_timer_stop();
+
+	/* Done */
+	return 1;
+
+	iounmap(tcobase);
+unreg_region:
+	release_region(pm_iobase, SP5100_PM_IOPORTS_SIZE);
+exit:
+	return 0;
+}
+
+static int __devinit sp5100_tco_init(struct platform_device *dev)
+{
+	int ret;
+	u32 val;
+
+	/* Check whether or not the hardware watchdog is there. If found, then
+	 * set it up.
+	 */
+	if (!sp5100_tco_setupdevice())
+		return -ENODEV;
+
+	/* Check to see if last reboot was due to watchdog timeout */
+	printk(KERN_INFO PFX "Watchdog reboot %sdetected.\n",
+	       readl(SP5100_WDT_CONTROL(tcobase)) & SP5100_PM_WATCHDOG_FIRED ?
+		      "" : "not ");
+
+	/* Clear out the old status */
+	val = readl(SP5100_WDT_CONTROL(tcobase));
+	val &= ~SP5100_PM_WATCHDOG_FIRED;
+	writel(val, SP5100_WDT_CONTROL(tcobase));
+
+	/*
+	 * Check that the heartbeat value is within it's range.
+	 * If not, reset to the default.
+	 */
+	if (tco_timer_set_heartbeat(heartbeat)) {
+		heartbeat = WATCHDOG_HEARTBEAT;
+		tco_timer_set_heartbeat(heartbeat);
+	}
+
+	ret = misc_register(&sp5100_tco_miscdev);
+	if (ret != 0) {
+		printk(KERN_ERR PFX "cannot register miscdev on minor="
+		       "%d (err=%d)\n",
+		       WATCHDOG_MINOR, ret);
+		goto exit;
+	}
+
+	clear_bit(0, &timer_alive);
+
+	printk(KERN_INFO PFX "initialized (0x%p). heartbeat=%d sec"
+		" (nowayout=%d)\n",
+		tcobase, heartbeat, nowayout);
+
+	return 0;
+
+exit:
+	iounmap(tcobase);
+	release_region(pm_iobase, SP5100_PM_IOPORTS_SIZE);
+	return ret;
+}
+
+static void __devexit sp5100_tco_cleanup(void)
+{
+	/* Stop the timer before we leave */
+	if (!nowayout)
+		tco_timer_stop();
+
+	/* Deregister */
+	misc_deregister(&sp5100_tco_miscdev);
+	iounmap(tcobase);
+	release_region(pm_iobase, SP5100_PM_IOPORTS_SIZE);
+}
+
+static int __devexit sp5100_tco_remove(struct platform_device *dev)
+{
+	if (tcobase)
+		sp5100_tco_cleanup();
+	return 0;
+}
+
+static void sp5100_tco_shutdown(struct platform_device *dev)
+{
+	tco_timer_stop();
+}
+
+static struct platform_driver sp5100_tco_driver = {
+	.probe		= sp5100_tco_init,
+	.remove		= __devexit_p(sp5100_tco_remove),
+	.shutdown	= sp5100_tco_shutdown,
+	.driver		= {
+		.owner	= THIS_MODULE,
+		.name	= TCO_MODULE_NAME,
+	},
+};
+
+static int __init sp5100_tco_init_module(void)
+{
+	int err;
+
+	printk(KERN_INFO PFX "SP5100 TCO WatchDog Timer Driver v%s\n",
+	       TCO_VERSION);
+
+	err = platform_driver_register(&sp5100_tco_driver);
+	if (err)
+		return err;
+
+	sp5100_tco_platform_device = platform_device_register_simple(
+					TCO_MODULE_NAME, -1, NULL, 0);
+	if (IS_ERR(sp5100_tco_platform_device)) {
+		err = PTR_ERR(sp5100_tco_platform_device);
+		goto unreg_platform_driver;
+	}
+
+	return 0;
+
+unreg_platform_driver:
+	platform_driver_unregister(&sp5100_tco_driver);
+	return err;
+}
+
+static void __exit sp5100_tco_cleanup_module(void)
+{
+	platform_device_unregister(sp5100_tco_platform_device);
+	platform_driver_unregister(&sp5100_tco_driver);
+	printk(KERN_INFO PFX "SP5100 TCO Watchdog Module Unloaded.\n");
+}
+
+module_init(sp5100_tco_init_module);
+module_exit(sp5100_tco_cleanup_module);
+
+MODULE_AUTHOR("Priyanka Gupta");
+MODULE_DESCRIPTION("TCO timer driver for SP5100 chipset");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
diff --git a/drivers/watchdog/sp5100_tco.h b/drivers/watchdog/sp5100_tco.h
new file mode 100644
index 0000000..a5a16cc
--- /dev/null
+++ b/drivers/watchdog/sp5100_tco.h
@@ -0,0 +1,41 @@
+/*
+ *	sp5100_tco:	TCO timer driver for sp5100 chipsets.
+ *
+ *	(c) Copyright 2009 Google Inc., All Rights Reserved.
+ *
+ *	TCO timer driver for sp5100 chipsets
+ */
+
+/*
+ * Some address definitions for the Watchdog
+ */
+
+#define SP5100_WDT_MEM_MAP_SIZE		0x08
+#define SP5100_WDT_CONTROL(base)	((base) + 0x00) /* Watchdog Control */
+#define SP5100_WDT_COUNT(base)		((base) + 0x04) /* Watchdog Count */
+
+#define SP5100_WDT_START_STOP_BIT	1
+#define SP5100_WDT_TRIGGER_BIT		(1 << 7)
+
+#define SP5100_PCI_WATCHDOG_MISC_REG	0x41
+#define SP5100_PCI_WATCHDOG_DECODE_EN	(1 << 3)
+
+#define SP5100_PM_IOPORTS_SIZE		0x02
+
+/* These two IO registers are hardcoded and there doesn't seem to be a way to
+ * read them from a register.
+ */
+#define SP5100_IO_PM_INDEX_REG		0xCD6
+#define SP5100_IO_PM_DATA_REG		0xCD7
+
+#define SP5100_PM_WATCHDOG_CONTROL	0x69
+#define SP5100_PM_WATCHDOG_BASE0	0x6C
+#define SP5100_PM_WATCHDOG_BASE1	0x6D
+#define SP5100_PM_WATCHDOG_BASE2	0x6E
+#define SP5100_PM_WATCHDOG_BASE3	0x6F
+
+#define SP5100_PM_WATCHDOG_FIRED	(1 << 1)
+#define SP5100_PM_WATCHDOG_ACTION_RESET	(1 << 2)
+
+#define SP5100_PM_WATCHDOG_DISABLE	1
+#define SP5100_PM_WATCHDOG_SECOND_RES	(3 << 1)
diff --git a/drivers/watchdog/w83627hf_wdt.c b/drivers/watchdog/w83627hf_wdt.c
index 0f5288d..e5c91d4 100644
--- a/drivers/watchdog/w83627hf_wdt.c
+++ b/drivers/watchdog/w83627hf_wdt.c
@@ -42,7 +42,7 @@
 
 #include <asm/system.h>
 
-#define WATCHDOG_NAME "w83627hf/thf/hg WDT"
+#define WATCHDOG_NAME "w83627hf/thf/hg/dhg WDT"
 #define PFX WATCHDOG_NAME ": "
 #define WATCHDOG_TIMEOUT 60		/* 60 sec default timeout */
 
@@ -89,7 +89,7 @@ static void w83627hf_select_wd_register(void)
 		c = ((inb_p(WDT_EFDR) & 0xf7) | 0x04); /* select WDT0 */
 		outb_p(0x2b, WDT_EFER);
 		outb_p(c, WDT_EFDR);	/* set GPIO3 to WDT0 */
-	} else if (c == 0x88) {	/* W83627EHF */
+	} else if (c == 0x88 || c == 0xa0) {	/* W83627EHF / W83627DHG */
 		outb_p(0x2d, WDT_EFER); /* select GPIO5 */
 		c = inb_p(WDT_EFDR) & ~0x01; /* PIN77 -> WDT0# */
 		outb_p(0x2d, WDT_EFER);
@@ -129,6 +129,8 @@ static void w83627hf_init(void)
 	t = inb_p(WDT_EFDR);      /* read CRF5 */
 	t &= ~0x0C;               /* set second mode & disable keyboard
 				    turning off watchdog */
+	t |= 0x02;		  /* enable the WDTO# output low pulse
+				    to the KBRST# pin (PIN60) */
 	outb_p(t, WDT_EFDR);    /* Write back to CRF5 */
 
 	outb_p(0xF7, WDT_EFER); /* Select CRF7 */
@@ -321,7 +323,7 @@ static int __init wdt_init(void)
 {
 	int ret;
 
-	printk(KERN_INFO "WDT driver for the Winbond(TM) W83627HF/THF/HG Super I/O chip initialising.\n");
+	printk(KERN_INFO "WDT driver for the Winbond(TM) W83627HF/THF/HG/DHG Super I/O chip initialising.\n");
 
 	if (wdt_set_heartbeat(timeout)) {
 		wdt_set_heartbeat(WATCHDOG_TIMEOUT);
