Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666Ab2KTRJb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 12:09:31 -0500
Received: from www.linutronix.de ([62.245.132.108]:57507 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803Ab2KTRJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 12:09:29 -0500
Date: Tue, 20 Nov 2012 18:09:24 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [GIT pull] x86 fixes for 3.7
Message-ID: <alpine.LFD.2.02.1211201807500.2701@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest x86-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

* Fix problem in CMCI rediscovery code that was illegally migrating
  worker threads to other cpus.
* Disable way access filter on AMD Piledriver (performance regression)
* A few CE4100 platform fixes
* A few mail address changes (also in drivers/edac/)

Thanks,

	tglx

------------------>
Andre Przywara (1):
      x86, amd: Disable way access filter on Piledriver CPUs

Andreas Herrmann (1):
      x86, microcode_amd: Change email addresses, MAINTAINERS entry

Borislav Petkov (3):
      x86, AMD: Change Boris' email address
      EDAC: Change Boris' email address
      MAINTAINERS: Change Boris' email address

Florian Fainelli (1):
      x86/ce4100: Fix pm_poweroff

Maxime Bizon (2):
      x86/ce4100: Fix reboot by forcing the reboot method to be KBD
      x86/ce4100: Fix PCI configuration register access for devices without interrupts

Robert Richter (1):
      MAINTAINERS: Update email address for Robert Richter

Tang Chen (1):
      x86/mce: Do not change worker's running cpu in cmci_rediscover().


 MAINTAINERS                            |   14 +++++++-------
 arch/x86/kernel/cpu/amd.c              |   14 ++++++++++++++
 arch/x86/kernel/cpu/mcheck/mce_amd.c   |    2 +-
 arch/x86/kernel/cpu/mcheck/mce_intel.c |   31 ++++++++++++++++++-------------
 arch/x86/kernel/microcode_amd.c        |    4 ++--
 arch/x86/pci/ce4100.c                  |   13 +++++++++++++
 arch/x86/platform/ce4100/ce4100.c      |   24 ++++++++++++++++++++++++
 drivers/edac/amd64_edac.h              |    2 +-
 drivers/edac/edac_stub.c               |    2 +-
 drivers/edac/mce_amd_inj.c             |    4 ++--
 10 files changed, 83 insertions(+), 27 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 1fa9074..a41344b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -534,9 +534,9 @@ F:	drivers/iommu/amd_iommu*.[ch]
 F:	include/linux/amd-iommu.h
 
 AMD MICROCODE UPDATE SUPPORT
-M:	Andreas Herrmann <andreas.herrmann3@amd.com>
+M:	Andreas Herrmann <herrmann.der.user@googlemail.com>
 L:	amd64-microcode@amd64.org
-S:	Supported
+S:	Maintained
 F:	arch/x86/kernel/microcode_amd.c
 
 AMS (Apple Motion Sensor) DRIVER
@@ -2707,10 +2707,10 @@ F:	include/linux/edac.h
 
 EDAC-AMD64
 M:	Doug Thompson <dougthompson@xmission.com>
-M:	Borislav Petkov <borislav.petkov@amd.com>
+M:	Borislav Petkov <bp@alien8.de>
 L:	linux-edac@vger.kernel.org
 W:	bluesmoke.sourceforge.net
-S:	Supported
+S:	Maintained
 F:	drivers/edac/amd64_edac*
 
 EDAC-E752X
@@ -3703,7 +3703,7 @@ S:	Maintained
 F:	drivers/platform/x86/ideapad-laptop.c
 
 IDE/ATAPI DRIVERS
-M:	Borislav Petkov <petkovbb@gmail.com>
+M:	Borislav Petkov <bp@alien8.de>
 L:	linux-ide@vger.kernel.org
 S:	Maintained
 F:	Documentation/cdrom/ide-cd
@@ -5363,7 +5363,7 @@ S:	Maintained
 F:	sound/drivers/opl4/
 
 OPROFILE
-M:	Robert Richter <robert.richter@amd.com>
+M:	Robert Richter <rric@kernel.org>
 L:	oprofile-list@lists.sf.net
 S:	Maintained
 F:	arch/*/include/asm/oprofile*.h
@@ -8147,7 +8147,7 @@ F:	drivers/platform/x86
 
 X86 MCE INFRASTRUCTURE
 M:	Tony Luck <tony.luck@intel.com>
-M:	Borislav Petkov <bp@amd64.org>
+M:	Borislav Petkov <bp@alien8.de>
 L:	linux-edac@vger.kernel.org
 S:	Maintained
 F:	arch/x86/kernel/cpu/mcheck/*
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index f7e98a2..1b7d165 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -631,6 +631,20 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 		}
 	}
 
+	/*
+	 * The way access filter has a performance penalty on some workloads.
+	 * Disable it on the affected CPUs.
+	 */
+	if ((c->x86 == 0x15) &&
+	    (c->x86_model >= 0x02) && (c->x86_model < 0x20)) {
+		u64 val;
+
+		if (!rdmsrl_safe(0xc0011021, &val) && !(val & 0x1E)) {
+			val |= 0x1E;
+			wrmsrl_safe(0xc0011021, val);
+		}
+	}
+
 	cpu_detect_cache_sizes(c);
 
 	/* Multi core CPU? */
diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index 698b6ec..1ac581f 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -6,7 +6,7 @@
  *
  *  Written by Jacob Shin - AMD, Inc.
  *
- *  Support: borislav.petkov@amd.com
+ *  Maintained by: Borislav Petkov <bp@alien8.de>
  *
  *  April 2006
  *     - added support for AMD Family 0x10 processors
diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel.c b/arch/x86/kernel/cpu/mcheck/mce_intel.c
index 5f88abf..4f9a3cb 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_intel.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel.c
@@ -285,34 +285,39 @@ void cmci_clear(void)
 	raw_spin_unlock_irqrestore(&cmci_discover_lock, flags);
 }
 
+static long cmci_rediscover_work_func(void *arg)
+{
+	int banks;
+
+	/* Recheck banks in case CPUs don't all have the same */
+	if (cmci_supported(&banks))
+		cmci_discover(banks);
+
+	return 0;
+}
+
 /*
  * After a CPU went down cycle through all the others and rediscover
  * Must run in process context.
  */
 void cmci_rediscover(int dying)
 {
-	int banks;
-	int cpu;
-	cpumask_var_t old;
+	int cpu, banks;
 
 	if (!cmci_supported(&banks))
 		return;
-	if (!alloc_cpumask_var(&old, GFP_KERNEL))
-		return;
-	cpumask_copy(old, &current->cpus_allowed);
 
 	for_each_online_cpu(cpu) {
 		if (cpu == dying)
 			continue;
-		if (set_cpus_allowed_ptr(current, cpumask_of(cpu)))
+
+		if (cpu == smp_processor_id()) {
+			cmci_rediscover_work_func(NULL);
 			continue;
-		/* Recheck banks in case CPUs don't all have the same */
-		if (cmci_supported(&banks))
-			cmci_discover(banks);
-	}
+		}
 
-	set_cpus_allowed_ptr(current, old);
-	free_cpumask_var(old);
+		work_on_cpu(cpu, cmci_rediscover_work_func, NULL);
+	}
 }
 
 /*
diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 7720ff5..b3e67ba 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -8,8 +8,8 @@
  *  Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
  *
  *  Maintainers:
- *  Andreas Herrmann <andreas.herrmann3@amd.com>
- *  Borislav Petkov <borislav.petkov@amd.com>
+ *  Andreas Herrmann <herrmann.der.user@googlemail.com>
+ *  Borislav Petkov <bp@alien8.de>
  *
  *  This driver allows to upgrade microcode on F10h AMD
  *  CPUs and later.
diff --git a/arch/x86/pci/ce4100.c b/arch/x86/pci/ce4100.c
index 41bd2a2..b914e20 100644
--- a/arch/x86/pci/ce4100.c
+++ b/arch/x86/pci/ce4100.c
@@ -115,6 +115,16 @@ static void sata_revid_read(struct sim_dev_reg *reg, u32 *value)
 	reg_read(reg, value);
 }
 
+static void reg_noirq_read(struct sim_dev_reg *reg, u32 *value)
+{
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&pci_config_lock, flags);
+	/* force interrupt pin value to 0 */
+	*value = reg->sim_reg.value & 0xfff00ff;
+	raw_spin_unlock_irqrestore(&pci_config_lock, flags);
+}
+
 static struct sim_dev_reg bus1_fixups[] = {
 	DEFINE_REG(2, 0, 0x10, (16*MB), reg_init, reg_read, reg_write)
 	DEFINE_REG(2, 0, 0x14, (256), reg_init, reg_read, reg_write)
@@ -144,6 +154,7 @@ static struct sim_dev_reg bus1_fixups[] = {
 	DEFINE_REG(11, 5, 0x10, (64*KB), reg_init, reg_read, reg_write)
 	DEFINE_REG(11, 6, 0x10, (256), reg_init, reg_read, reg_write)
 	DEFINE_REG(11, 7, 0x10, (64*KB), reg_init, reg_read, reg_write)
+	DEFINE_REG(11, 7, 0x3c, 256, reg_init, reg_noirq_read, reg_write)
 	DEFINE_REG(12, 0, 0x10, (128*KB), reg_init, reg_read, reg_write)
 	DEFINE_REG(12, 0, 0x14, (256), reg_init, reg_read, reg_write)
 	DEFINE_REG(12, 1, 0x10, (1024), reg_init, reg_read, reg_write)
@@ -161,8 +172,10 @@ static struct sim_dev_reg bus1_fixups[] = {
 	DEFINE_REG(16, 0, 0x10, (64*KB), reg_init, reg_read, reg_write)
 	DEFINE_REG(16, 0, 0x14, (64*MB), reg_init, reg_read, reg_write)
 	DEFINE_REG(16, 0, 0x18, (64*MB), reg_init, reg_read, reg_write)
+	DEFINE_REG(16, 0, 0x3c, 256, reg_init, reg_noirq_read, reg_write)
 	DEFINE_REG(17, 0, 0x10, (128*KB), reg_init, reg_read, reg_write)
 	DEFINE_REG(18, 0, 0x10, (1*KB), reg_init, reg_read, reg_write)
+	DEFINE_REG(18, 0, 0x3c, 256, reg_init, reg_noirq_read, reg_write)
 };
 
 static void __init init_sim_regs(void)
diff --git a/arch/x86/platform/ce4100/ce4100.c b/arch/x86/platform/ce4100/ce4100.c
index 4c61b52..92525cb 100644
--- a/arch/x86/platform/ce4100/ce4100.c
+++ b/arch/x86/platform/ce4100/ce4100.c
@@ -21,12 +21,25 @@
 #include <asm/i8259.h>
 #include <asm/io.h>
 #include <asm/io_apic.h>
+#include <asm/emergency-restart.h>
 
 static int ce4100_i8042_detect(void)
 {
 	return 0;
 }
 
+/*
+ * The CE4100 platform has an internal 8051 Microcontroller which is
+ * responsible for signaling to the external Power Management Unit the
+ * intention to reset, reboot or power off the system. This 8051 device has
+ * its command register mapped at I/O port 0xcf9 and the value 0x4 is used
+ * to power off the system.
+ */
+static void ce4100_power_off(void)
+{
+	outb(0x4, 0xcf9);
+}
+
 #ifdef CONFIG_SERIAL_8250
 
 static unsigned int mem_serial_in(struct uart_port *p, int offset)
@@ -139,8 +152,19 @@ void __init x86_ce4100_early_setup(void)
 	x86_init.mpparse.find_smp_config = x86_init_noop;
 	x86_init.pci.init = ce4100_pci_init;
 
+	/*
+	 * By default, the reboot method is ACPI which is supported by the
+	 * CE4100 bootloader CEFDK using FADT.ResetReg Address and ResetValue
+	 * the bootloader will however issue a system power off instead of
+	 * reboot. By using BOOT_KBD we ensure proper system reboot as
+	 * expected.
+	 */
+	reboot_type = BOOT_KBD;
+
 #ifdef CONFIG_X86_IO_APIC
 	x86_init.pci.init_irq = sdv_pci_init;
 	x86_init.mpparse.setup_ioapic_ids = setup_ioapic_ids_from_mpc_nocheck;
 #endif
+
+	pm_power_off = ce4100_power_off;
 }
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index 8d48047..8c41396 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -33,7 +33,7 @@
  *		detection. The mods to Rev F required more family
  *		information detection.
  *
- *	Changes/Fixes by Borislav Petkov <borislav.petkov@amd.com>:
+ *	Changes/Fixes by Borislav Petkov <bp@alien8.de>:
  *		- misc fixes and code cleanups
  *
  * This module is based on the following documents
diff --git a/drivers/edac/edac_stub.c b/drivers/edac/edac_stub.c
index 6c86f6e..351945f 100644
--- a/drivers/edac/edac_stub.c
+++ b/drivers/edac/edac_stub.c
@@ -5,7 +5,7 @@
  *
  * 2007 (c) MontaVista Software, Inc.
  * 2010 (c) Advanced Micro Devices Inc.
- *	    Borislav Petkov <borislav.petkov@amd.com>
+ *	    Borislav Petkov <bp@alien8.de>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff --git a/drivers/edac/mce_amd_inj.c b/drivers/edac/mce_amd_inj.c
index 66b5151..2ae78f2 100644
--- a/drivers/edac/mce_amd_inj.c
+++ b/drivers/edac/mce_amd_inj.c
@@ -6,7 +6,7 @@
  * This file may be distributed under the terms of the GNU General Public
  * License version 2.
  *
- * Copyright (c) 2010:  Borislav Petkov <borislav.petkov@amd.com>
+ * Copyright (c) 2010:  Borislav Petkov <bp@alien8.de>
  *			Advanced Micro Devices Inc.
  */
 
@@ -168,6 +168,6 @@ module_init(edac_init_mce_inject);
 module_exit(edac_exit_mce_inject);
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Borislav Petkov <borislav.petkov@amd.com>");
+MODULE_AUTHOR("Borislav Petkov <bp@alien8.de>");
 MODULE_AUTHOR("AMD Inc.");
 MODULE_DESCRIPTION("MCE injection facility for testing MCE decoding");
