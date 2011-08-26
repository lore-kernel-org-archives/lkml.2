Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015Ab1HZK1P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 06:27:15 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:34589 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754874Ab1HZK1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 06:27:12 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 2/2] config: Update device configurations for MID generic
 devices
To: x86@kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 26 Aug 2011 11:22:16 +0100
Message-ID: <20110826102204.16894.30087.stgit@localhost.localdomain>
In-Reply-To: <20110826102104.16894.85228.stgit@localhost.localdomain>
References: <20110826102104.16894.85228.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Some of our support is not Moorestown specific. We can now use the new
symbols to untangle this.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 arch/x86/Kconfig                   |    4 ++--
 arch/x86/include/asm/fixmap.h      |    2 +-
 arch/x86/include/asm/setup.h       |    2 +-
 arch/x86/pci/Makefile              |    2 +-
 arch/x86/platform/mrst/Makefile    |    4 ++--
 drivers/platform/x86/Kconfig       |    2 +-
 drivers/rtc/Kconfig                |    4 ++--
 drivers/staging/gma500/mrst_lvds.c |    1 -
 8 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 5c2b225..ac036fa 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -663,8 +663,8 @@ config HPET_EMULATE_RTC
 	depends on HPET_TIMER && (RTC=y || RTC=m || RTC_DRV_CMOS=m || RTC_DRV_CMOS=y)
 
 config APB_TIMER
-       def_bool y if MRST
-       prompt "Langwell APB Timer Support" if X86_MRST
+       def_bool y if X86_INTEL_MID
+       prompt "Intel MID platform APB Timer Support" if X86_INTEL_MID
        select DW_APB_TIMER
        help
          APB timer is the replacement for 8254, HPET on X86 MID platforms.
diff --git a/arch/x86/include/asm/fixmap.h b/arch/x86/include/asm/fixmap.h
index 460c74e..4da3c0c 100644
--- a/arch/x86/include/asm/fixmap.h
+++ b/arch/x86/include/asm/fixmap.h
@@ -117,7 +117,7 @@ enum fixed_addresses {
 #endif
 	FIX_TEXT_POKE1,	/* reserve 2 pages for text_poke() */
 	FIX_TEXT_POKE0, /* first page is last, because allocation is backward */
-#ifdef	CONFIG_X86_MRST
+#ifdef	CONFIG_X86_INTEL_MID
 	FIX_LNW_VRTC,
 #endif
 	__end_of_permanent_fixed_addresses,
diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index 9756551..d0f19f9 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -47,7 +47,7 @@ extern void reserve_standard_io_resources(void);
 extern void i386_reserve_resources(void);
 extern void setup_default_timer_irq(void);
 
-#ifdef CONFIG_X86_MRST
+#ifdef CONFIG_X86_INTEL_MID
 extern void x86_mrst_early_setup(void);
 #else
 static inline void x86_mrst_early_setup(void) { }
diff --git a/arch/x86/pci/Makefile b/arch/x86/pci/Makefile
index 6b8759f..75b06f3 100644
--- a/arch/x86/pci/Makefile
+++ b/arch/x86/pci/Makefile
@@ -15,7 +15,7 @@ obj-$(CONFIG_X86_VISWS)		+= visws.o
 
 obj-$(CONFIG_X86_NUMAQ)		+= numaq_32.o
 
-obj-$(CONFIG_X86_MRST)		+= mrst.o
+obj-$(CONFIG_X86_INTEL_MID)	+= mrst.o
 
 obj-y				+= common.o early.o
 obj-y				+= amd_bus.o bus_numa.o
diff --git a/arch/x86/platform/mrst/Makefile b/arch/x86/platform/mrst/Makefile
index ddeec73..7baed51 100644
--- a/arch/x86/platform/mrst/Makefile
+++ b/arch/x86/platform/mrst/Makefile
@@ -1,4 +1,4 @@
-obj-$(CONFIG_X86_MRST)		+= mrst.o
-obj-$(CONFIG_X86_MRST)		+= vrtc.o
+obj-$(CONFIG_X86_INTEL_MID)	+= mrst.o
+obj-$(CONFIG_X86_INTEL_MID)	+= vrtc.o
 obj-$(CONFIG_EARLY_PRINTK_INTEL_MID)	+= early_printk_mrst.o
 obj-$(CONFIG_X86_MRST)		+= pmu.o
diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 91d0d4b..ac38495 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -637,7 +637,7 @@ config ACPI_CMPC
 
 config INTEL_SCU_IPC
 	bool "Intel SCU IPC Support"
-	depends on X86_MRST
+	depends on X86_INTEL_MID
 	default y
 	---help---
 	  IPC is used to bridge the communications between kernel and SCU on
diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 5a538fc..ae1b922 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -499,8 +499,8 @@ config RTC_DRV_CMOS
 
 config RTC_DRV_VRTC
 	tristate "Virtual RTC for Moorestown platforms"
-	depends on X86_MRST
-	default y if X86_MRST
+	depends on X86_INTEL_MID
+	default y if X86_INTEL_MID
 
 	help
 	Say "yes" here to get direct support for the real time clock
diff --git a/drivers/staging/gma500/mrst_lvds.c b/drivers/staging/gma500/mrst_lvds.c
index e7999a2..133401e 100644
--- a/drivers/staging/gma500/mrst_lvds.c
+++ b/drivers/staging/gma500/mrst_lvds.c
@@ -348,7 +348,6 @@ void mrst_lvds_init(struct drm_device *dev,
 	 */
 
 	i2c_adap = i2c_get_adapter(dev_priv->ops->i2c_bus);
-
 	if (i2c_adap == NULL)
 		dev_err(dev->dev, "No ddc adapter available!\n");
 	/*

