Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931Ab2AIIRu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 03:17:50 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52935 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751457Ab2AIIRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 03:17:48 -0500
Date: Mon, 9 Jan 2012 09:17:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL, v2] x86/platform changes for v3.3
Message-ID: <20120109081738.GA26379@elte.hu>
References: <20120105152035.GA11286@elte.hu>
 <CA+55aFw1emj7YRyp9Z_cH9y-M3BV--X8JPvk+E4jQzMTRCeymQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFw1emj7YRyp9Z_cH9y-M3BV--X8JPvk+E4jQzMTRCeymQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, Jan 5, 2012 at 7:20 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > Please pull the latest x86-platform-for-linus git tree from:
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-platform-for-linus
> 
> Ingo, there's something *seriously* wrong with your pull 
> requests. This is now the third totally buggered pull request 
> I encounter.

Sigh, sorry about that. Same problem as with x86/mm, the stale 
x86-platform-for-linus branch did not get reset after a forced 
rebase, which was not caught by automated nor by my manual 
checks.

> This one is also just some stale crap from six months ago with 
> TS-5500 GPIO support etc.
> 
> Please. Go back and double-check every single pull request you 
> wrote for me that I haven't merged yet. In fact, just in case, 
> check the ones I merged too, just to make sure that I merged 
> what you really intended me to merge, and not some stale crap. 
> Because you clearly haven't checked what's actually on the 
> tree on kernel.org.

Should have thought of that myself. I've double checked all the 
sha1's:

  core-debugobjects-for-linus   : dc4218bd0fe499fce2896f88101ea42dac1f60fc
  core-locking-for-linus        : f07fdec50a13f134ea9608c8fb3f6408c58ef55e
  core-memblock-for-linus       : 45aa0663cc408617b79a2b53f0a5f50e94688a48
  core-printk-for-linus         : 1a9a8aefa8f0530c97f4606ab7a2fc01fe31e9c1
  core-rcu-for-linus            : 919b83452b2e7c1dbced0456015508b4b9585db3
  perf-core-for-linus           : 9e183426bfb52bb44bf3c443d6587e4d02478603
  sched-core-for-linus          : 1ac9bc6943edf7d181b4b1cc734981350d4f6bae
  timers-core-for-linus         : 0518469d0a32be1e6dd8850ff274d52d72cdb52d
  x86-apic-for-linus            : c284b42abadbb22083bfde24d308899c08d44ffa
  x86-asm-for-linus             : ceb7b40b65539a771d1bfaf47660ac0ee57e0c4f
  x86-cleanups-for-linus        : 1affc46cffad9f2bc7c9ffec85726446903a58f9
  x86-cpu-for-linus             : cb3f718de8301a969f8169d7d4160e73baff0b86
  x86-efi-for-linus             : 2d2da60fb40a80cc59383121ccf763e0e0e8a42a
  x86-mce-for-linus             : a228b5892b0527b8574c06edc72cacaf8c25418d
  x86-microcode-for-linus       : 304fb45374918b166233855bcf498b02586afd80
  x86-platform-for-linus        : 7c9c3a1e5fc8728e948b8fa3cbcfcfb86db3afda [unmerged]
  x86-rdrand-for-linus          : cf833d0b9937874b50ef2867c4e8badfd64948ce
  x86-mm-for-linus              : 54eed6cb16ec315565aaaf8e34252ca253a68b7b [unmerged]
  x86-debug-for-linus           : e58d429209105e698e9d0357481d62b37fe9a7dd [unmerged]

all already merged ones were fine, and there are no broken ones 
beyond x86-mm-for-linus and x86-platform-for-linus (both fixed 
meanwhile).

> And while at it, I'd suggest you make your pull request script 
> actually verify the tree you are asking me to pull, so that 
> this doesn't continue to happen.

Yes, i've already fixed the script after the x86-mm-for-linus 
incident - but sadly and stupidly did not think of checking the 
remaining pending trees ...

Beyond the scripted check i also added another manual 
verification step as a precaution, to hopefully prevent future 
mishaps. (I did this extra checking step for all three pending 
trees, and they seem to be fine.)

Sorry again, and below is the refreshed pull request.

I guess the fears about 2012 were right after all.

	Ingo

----------------------->
Linus,

Please pull the latest x86-platform-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-platform-for-linus

   HEAD: 7c9c3a1e5fc8728e948b8fa3cbcfcfb86db3afda x86/intel config: Fix the APB_TIMER selection


out-of-topic modifications in x86-platform-for-linus:
-----------------------------------------------------
drivers/platform/x86/Kconfig       # c95aaef: x86/intel/scu/ipc: Match the chan
drivers/rtc/Kconfig                # 933b946: x86/intel config: Revamp configur
init/calibrate.c                   # b565201: x86: Reduce clock calibration tim

 Thanks,

	Ingo

------------------>
Alan Cox (7):
      x86/sfi: Kill the IRQ as id hack
      x86/config: Revamp configuration for MID devices
      x86: Fix INTEL_MID silly
      x86/apb: Fix configuration constraints
      x86/intel/scu/ipc: Match the changes in the x86 configuration
      x86/intel config: Revamp configuration to allow for Moorestown and Medfield
      x86/intel config: Fix the APB_TIMER selection

Alessandro Rubini (1):
      x86/Kconfig: Cyclone-timer depends on x86-summit

Jack Steiner (1):
      x86: Reduce clock calibration time during slave cpu startup

Michael Demeter (1):
      x86/mrst: Add additional debug prints for pb_keys


 arch/x86/Kconfig                |   31 +++++++++++++++++++++++++++----
 arch/x86/Kconfig.debug          |    6 +++---
 arch/x86/include/asm/fixmap.h   |    2 +-
 arch/x86/include/asm/setup.h    |    2 +-
 arch/x86/kernel/early_printk.c  |    2 +-
 arch/x86/kernel/smpboot.c       |   16 +++++++++++-----
 arch/x86/kernel/tsc.c           |   20 ++++++++++++++++++++
 arch/x86/pci/Makefile           |    2 +-
 arch/x86/platform/mrst/Makefile |    6 +++---
 arch/x86/platform/mrst/mrst.c   |    4 ++--
 drivers/platform/x86/Kconfig    |    2 +-
 drivers/rtc/Kconfig             |    6 +++---
 init/calibrate.c                |   15 +++++++++++++++
 13 files changed, 89 insertions(+), 25 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index efb4294..78fbb34 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -409,12 +409,14 @@ config X86_MRST
 	depends on PCI
 	depends on PCI_GOANY
 	depends on X86_IO_APIC
+	select X86_INTEL_MID
+	select SFI
+	select DW_APB_TIMER
 	select APB_TIMER
 	select I2C
 	select SPI
 	select INTEL_SCU_IPC
 	select X86_PLATFORM_DEVICES
-	select X86_INTEL_MID
 	---help---
 	  Moorestown is Intel's Low Power Intel Architecture (LPIA) based Moblin
 	  Internet Device(MID) platform. Moorestown consists of two chips:
@@ -423,6 +425,26 @@ config X86_MRST
 	  nor standard legacy replacement devices/features. e.g. Moorestown does
 	  not contain i8259, i8254, HPET, legacy BIOS, most of the io ports.
 
+config X86_MDFLD
+       bool "Medfield MID platform"
+	depends on PCI
+	depends on PCI_GOANY
+	depends on X86_IO_APIC
+	select X86_INTEL_MID
+	select SFI
+	select DW_APB_TIMER
+	select APB_TIMER
+	select I2C
+	select SPI
+	select INTEL_SCU_IPC
+	select X86_PLATFORM_DEVICES
+	---help---
+	  Medfield is Intel's Low Power Intel Architecture (LPIA) based Moblin
+	  Internet Device(MID) platform. 
+	  Unlike standard x86 PCs, Medfield does not have many legacy devices
+	  nor standard legacy replacement devices/features. e.g. Medfield does
+	  not contain i8259, i8254, HPET, legacy BIOS, most of the io ports.
+
 endif
 
 config X86_RDC321X
@@ -620,7 +642,7 @@ config X86_SUMMIT_NUMA
 
 config X86_CYCLONE_TIMER
 	def_bool y
-	depends on X86_32_NON_STANDARD
+	depends on X86_SUMMIT
 
 source "arch/x86/Kconfig.cpu"
 
@@ -648,9 +670,10 @@ config HPET_EMULATE_RTC
 	depends on HPET_TIMER && (RTC=y || RTC=m || RTC_DRV_CMOS=m || RTC_DRV_CMOS=y)
 
 config APB_TIMER
-       def_bool y if MRST
-       prompt "Langwell APB Timer Support" if X86_MRST
+       def_bool y if X86_INTEL_MID
+       prompt "Intel MID APB Timer Support" if X86_INTEL_MID
        select DW_APB_TIMER
+       depends on X86_INTEL_MID && SFI
        help
          APB timer is the replacement for 8254, HPET on X86 MID platforms.
          The APBT provides a stable time base on SMP
diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index bf56e17..28c3c73 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -43,9 +43,9 @@ config EARLY_PRINTK
 	  with klogd/syslogd or the X server. You should normally N here,
 	  unless you want to debug such a crash.
 
-config EARLY_PRINTK_MRST
-	bool "Early printk for MRST platform support"
-	depends on EARLY_PRINTK && X86_MRST
+config EARLY_PRINTK_INTEL_MID
+	bool "Early printk for Intel MID platform support"
+	depends on EARLY_PRINTK && X86_INTEL_MID
 
 config EARLY_PRINTK_DBGP
 	bool "Early printk via EHCI debug port"
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
diff --git a/arch/x86/kernel/early_printk.c b/arch/x86/kernel/early_printk.c
index cd28a35..7a53da0 100644
--- a/arch/x86/kernel/early_printk.c
+++ b/arch/x86/kernel/early_printk.c
@@ -240,7 +240,7 @@ static int __init setup_early_printk(char *buf)
 		if (!strncmp(buf, "xen", 3))
 			early_console_register(&xenboot_console, keep);
 #endif
-#ifdef CONFIG_EARLY_PRINTK_MRST
+#ifdef CONFIG_EARLY_PRINTK_INTEL_MID
 		if (!strncmp(buf, "mrst", 4)) {
 			mrst_early_console_init();
 			early_console_register(&early_mrst_console, keep);
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 9f548cb..00eef55 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -207,23 +207,29 @@ static void __cpuinit smp_callin(void)
 	 * Need to setup vector mappings before we enable interrupts.
 	 */
 	setup_vector_irq(smp_processor_id());
+
+	/*
+	 * Save our processor parameters. Note: this information
+	 * is needed for clock calibration.
+	 */
+	smp_store_cpu_info(cpuid);
+
 	/*
 	 * Get our bogomips.
+	 * Update loops_per_jiffy in cpu_data. Previous call to
+	 * smp_store_cpu_info() stored a value that is close but not as
+	 * accurate as the value just calculated.
 	 *
 	 * Need to enable IRQs because it can take longer and then
 	 * the NMI watchdog might kill us.
 	 */
 	local_irq_enable();
 	calibrate_delay();
+	cpu_data(cpuid).loops_per_jiffy = loops_per_jiffy;
 	local_irq_disable();
 	pr_debug("Stack at about %p\n", &cpuid);
 
 	/*
-	 * Save our processor parameters
-	 */
-	smp_store_cpu_info(cpuid);
-
-	/*
 	 * This must be done before setting cpu_online_mask
 	 * or calling notify_cpu_starting.
 	 */
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index db48336..490fb33 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -995,3 +995,23 @@ void __init tsc_init(void)
 	check_system_tsc_reliable();
 }
 
+#ifdef CONFIG_SMP
+/*
+ * If we have a constant TSC and are using the TSC for the delay loop,
+ * we can skip clock calibration if another cpu in the same socket has already
+ * been calibrated. This assumes that CONSTANT_TSC applies to all
+ * cpus in the socket - this should be a safe assumption.
+ */
+unsigned long __cpuinit calibrate_delay_is_known(void)
+{
+	int i, cpu = smp_processor_id();
+
+	if (!tsc_disabled && !cpu_has(&cpu_data(cpu), X86_FEATURE_CONSTANT_TSC))
+		return 0;
+
+	for_each_online_cpu(i)
+		if (cpu_data(i).phys_proc_id == cpu_data(cpu).phys_proc_id)
+			return cpu_data(i).loops_per_jiffy;
+	return 0;
+}
+#endif
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
index 1ea3877..7baed51 100644
--- a/arch/x86/platform/mrst/Makefile
+++ b/arch/x86/platform/mrst/Makefile
@@ -1,4 +1,4 @@
-obj-$(CONFIG_X86_MRST)		+= mrst.o
-obj-$(CONFIG_X86_MRST)		+= vrtc.o
-obj-$(CONFIG_EARLY_PRINTK_MRST)	+= early_printk_mrst.o
+obj-$(CONFIG_X86_INTEL_MID)	+= mrst.o
+obj-$(CONFIG_X86_INTEL_MID)	+= vrtc.o
+obj-$(CONFIG_EARLY_PRINTK_INTEL_MID)	+= early_printk_mrst.o
 obj-$(CONFIG_X86_MRST)		+= pmu.o
diff --git a/arch/x86/platform/mrst/mrst.c b/arch/x86/platform/mrst/mrst.c
index ad4ec1c..475e2cd 100644
--- a/arch/x86/platform/mrst/mrst.c
+++ b/arch/x86/platform/mrst/mrst.c
@@ -848,8 +848,7 @@ static void __init sfi_handle_ipc_dev(struct sfi_device_table_entry *entry)
 	if (mrst_has_msic())
 		return;
 
-	/* ID as IRQ is a hack that will go away */
-	pdev = platform_device_alloc(entry->name, entry->irq);
+	pdev = platform_device_alloc(entry->name, 0);
 	if (pdev == NULL) {
 		pr_err("out of memory for SFI platform device '%s'.\n",
 			entry->name);
@@ -1030,6 +1029,7 @@ static int __init pb_keys_init(void)
 	num = sizeof(gpio_button) / sizeof(struct gpio_keys_button);
 	for (i = 0; i < num; i++) {
 		gb[i].gpio = get_gpio_by_name(gb[i].desc);
+		pr_debug("info[%2d]: name = %s, gpio = %d\n", i, gb[i].desc, gb[i].gpio);
 		if (gb[i].gpio == -1)
 			continue;
 
diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 7f43cf8..f995e6e 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -639,7 +639,7 @@ config ACPI_CMPC
 
 config INTEL_SCU_IPC
 	bool "Intel SCU IPC Support"
-	depends on X86_MRST
+	depends on X86_INTEL_MID
 	default y
 	---help---
 	  IPC is used to bridge the communications between kernel and SCU on
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
diff --git a/init/calibrate.c b/init/calibrate.c
index 24df797..5f117ca 100644
--- a/init/calibrate.c
+++ b/init/calibrate.c
@@ -246,6 +246,19 @@ recalibrate:
 
 static DEFINE_PER_CPU(unsigned long, cpu_loops_per_jiffy) = { 0 };
 
+/*
+ * Check if cpu calibration delay is already known. For example,
+ * some processors with multi-core sockets may have all cores
+ * with the same calibration delay.
+ *
+ * Architectures should override this function if a faster calibration
+ * method is available.
+ */
+unsigned long __attribute__((weak)) __cpuinit calibrate_delay_is_known(void)
+{
+	return 0;
+}
+
 void __cpuinit calibrate_delay(void)
 {
 	unsigned long lpj;
@@ -265,6 +278,8 @@ void __cpuinit calibrate_delay(void)
 		lpj = lpj_fine;
 		pr_info("Calibrating delay loop (skipped), "
 			"value calculated using timer frequency.. ");
+	} else if ((lpj = calibrate_delay_is_known())) {
+		;
 	} else if ((lpj = calibrate_delay_direct()) != 0) {
 		if (!printed)
 			pr_info("Calibrating delay using timer "
