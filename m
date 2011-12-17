Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568Ab1LQRbc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 12:31:32 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:55209 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389Ab1LQRba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 12:31:30 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] config: revamp configuration to allow for Moorestown and
 Medfield
To: linux-kernel@vger.kernel.org, mingo@elte.hu
Date: Sat, 17 Dec 2011 17:43:40 +0000
Message-ID: <20111217174318.7207.91543.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

This sets all up the other bits tha need to be INTEL_MID specific rather than
Moorestown specific.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 arch/x86/Kconfig                |    4 ++--
 arch/x86/include/asm/fixmap.h   |    2 +-
 arch/x86/include/asm/setup.h    |    2 +-
 arch/x86/pci/Makefile           |    2 +-
 arch/x86/platform/mrst/Makefile |    4 ++--
 drivers/rtc/Kconfig             |    6 +++---
 6 files changed, 10 insertions(+), 10 deletions(-)


diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 0f7f8ea..13947a2 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -713,8 +713,8 @@ config HPET_EMULATE_RTC
 	depends on HPET_TIMER && (RTC=y || RTC=m || RTC_DRV_CMOS=m || RTC_DRV_CMOS=y)
 
 config APB_TIMER
-       def_bool y if MRST
-       prompt "Langwell APB Timer Support" if X86_MRST
+       def_bool y if X86_INTEL_MID
+       prompt "Intel MID APB Timer Support" if X86_INTEL_MID
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
diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 53eb4e5..3a125b8 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -498,9 +498,9 @@ config RTC_DRV_CMOS
 	  will be called rtc-cmos.
 
 config RTC_DRV_VRTC
-	tristate "Virtual RTC for Moorestown platforms"
-	depends on X86_MRST
-	default y if X86_MRST
+	tristate "Virtual RTC for Intel MID platforms"
+	depends on X86_INTEL_MID
+	default y if X86_INTEL_MID
 
 	help
 	Say "yes" here to get direct support for the real time clock

