Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432Ab1DBKwi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 06:52:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37887 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767Ab1DBKwg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 06:52:36 -0400
Date: Sat, 2 Apr 2011 12:52:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20110402105230.GA1961@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus


out-of-topic modifications in x86-fixes-for-linus:
--------------------------------------------------
drivers/media/rc/ite-cir.c         # ca44456: x86: Stop including <linux/delay.
drivers/scsi/ultrastor.c           # ca44456: x86: Stop including <linux/delay.
include/linux/pci_ids.h            # cb6c852: x86, amd-nb: Rename CPU PCI id de
sound/soc/codecs/sn95031.c         # 438008a: sound: Add delay.h to sound/soc/c

 Thanks,

	Ingo

------------------>
Borislav Petkov (1):
      x86, amd-nb: Rename CPU PCI id define for F4

Cliff Wickman (1):
      x86, UV: Fix kdump reboot

Ingo Molnar (1):
      sound: Add delay.h to sound/soc/codecs/sn95031.c

Jean Delvare (1):
      x86: Stop including <linux/delay.h> in two asm header files

Suresh Siddha (1):
      x86, mtrr, pat: Fix one cpu getting out of sync during resume

Xiaotian Feng (1):
      x86, microcode: Unregister syscore_ops after microcode unloaded


 arch/x86/include/asm/apic.h        |    1 -
 arch/x86/include/asm/dma.h         |    1 -
 arch/x86/kernel/amd_nb.c           |    2 +-
 arch/x86/kernel/apic/hw_nmi.c      |    1 +
 arch/x86/kernel/apic/x2apic_uv_x.c |   10 ++++++++++
 arch/x86/kernel/cpu/mtrr/main.c    |   20 +++++++++++++++-----
 arch/x86/kernel/irq.c              |    1 +
 arch/x86/kernel/microcode_core.c   |    1 +
 arch/x86/kernel/reboot.c           |    1 +
 arch/x86/platform/uv/tlb_uv.c      |    1 +
 drivers/media/rc/ite-cir.c         |    1 +
 drivers/scsi/ultrastor.c           |    1 +
 include/linux/pci_ids.h            |    2 +-
 sound/soc/codecs/sn95031.c         |    2 ++
 14 files changed, 36 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index a279d98..2b7d573 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -2,7 +2,6 @@
 #define _ASM_X86_APIC_H
 
 #include <linux/cpumask.h>
-#include <linux/delay.h>
 #include <linux/pm.h>
 
 #include <asm/alternative.h>
diff --git a/arch/x86/include/asm/dma.h b/arch/x86/include/asm/dma.h
index 97b6d81..057099e 100644
--- a/arch/x86/include/asm/dma.h
+++ b/arch/x86/include/asm/dma.h
@@ -10,7 +10,6 @@
 
 #include <linux/spinlock.h>	/* And spinlocks */
 #include <asm/io.h>		/* need byte IO */
-#include <linux/delay.h>
 
 #ifdef HAVE_REALLY_SLOW_DMA_CONTROLLER
 #define dma_outb	outb_p
diff --git a/arch/x86/kernel/amd_nb.c b/arch/x86/kernel/amd_nb.c
index 6801959..4c39baa 100644
--- a/arch/x86/kernel/amd_nb.c
+++ b/arch/x86/kernel/amd_nb.c
@@ -21,7 +21,7 @@ const struct pci_device_id amd_nb_misc_ids[] = {
 EXPORT_SYMBOL(amd_nb_misc_ids);
 
 static struct pci_device_id amd_nb_link_ids[] = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_LINK) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_F4) },
 	{}
 };
 
diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
index c4e557a..5260fe9 100644
--- a/arch/x86/kernel/apic/hw_nmi.c
+++ b/arch/x86/kernel/apic/hw_nmi.c
@@ -16,6 +16,7 @@
 #include <linux/kprobes.h>
 #include <linux/nmi.h>
 #include <linux/module.h>
+#include <linux/delay.h>
 
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
 u64 hw_nmi_get_sample_period(void)
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 3c28928..33b10a0 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -23,6 +23,8 @@
 #include <linux/io.h>
 #include <linux/pci.h>
 #include <linux/kdebug.h>
+#include <linux/delay.h>
+#include <linux/crash_dump.h>
 
 #include <asm/uv/uv_mmrs.h>
 #include <asm/uv/uv_hub.h>
@@ -34,6 +36,7 @@
 #include <asm/ipi.h>
 #include <asm/smp.h>
 #include <asm/x86_init.h>
+#include <asm/emergency-restart.h>
 
 DEFINE_PER_CPU(int, x2apic_extra_bits);
 
@@ -810,4 +813,11 @@ void __init uv_system_init(void)
 
 	/* register Legacy VGA I/O redirection handler */
 	pci_register_set_vga_state(uv_set_vga_state);
+
+	/*
+	 * For a kdump kernel the reset must be BOOT_ACPI, not BOOT_EFI, as
+	 * EFI is not enabled in the kdump kernel.
+	 */
+	if (is_kdump_kernel())
+		reboot_type = BOOT_ACPI;
 }
diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index 307dfbb..929739a 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -293,14 +293,24 @@ set_mtrr(unsigned int reg, unsigned long base, unsigned long size, mtrr_type typ
 
 	/*
 	 * HACK!
-	 * We use this same function to initialize the mtrrs on boot.
-	 * The state of the boot cpu's mtrrs has been saved, and we want
-	 * to replicate across all the APs.
-	 * If we're doing that @reg is set to something special...
+	 *
+	 * We use this same function to initialize the mtrrs during boot,
+	 * resume, runtime cpu online and on an explicit request to set a
+	 * specific MTRR.
+	 *
+	 * During boot or suspend, the state of the boot cpu's mtrrs has been
+	 * saved, and we want to replicate that across all the cpus that come
+	 * online (either at the end of boot or resume or during a runtime cpu
+	 * online). If we're doing that, @reg is set to something special and on
+	 * this cpu we still do mtrr_if->set_all(). During boot/resume, this
+	 * is unnecessary if at this point we are still on the cpu that started
+	 * the boot/resume sequence. But there is no guarantee that we are still
+	 * on the same cpu. So we do mtrr_if->set_all() on this cpu aswell to be
+	 * sure that we are in sync with everyone else.
 	 */
 	if (reg != ~0U)
 		mtrr_if->set(reg, base, size, type);
-	else if (!mtrr_aps_delayed_init)
+	else
 		mtrr_if->set_all();
 
 	/* Wait for the others */
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 948a31e..1cb0b9f 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -8,6 +8,7 @@
 #include <linux/seq_file.h>
 #include <linux/smp.h>
 #include <linux/ftrace.h>
+#include <linux/delay.h>
 
 #include <asm/apic.h>
 #include <asm/io_apic.h>
diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index 5ed0ab5..f924280 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -550,6 +550,7 @@ static void __exit microcode_exit(void)
 	microcode_dev_exit();
 
 	unregister_hotcpu_notifier(&mc_cpu_notifier);
+	unregister_syscore_ops(&mc_syscore_ops);
 
 	get_online_cpus();
 	mutex_lock(&microcode_mutex);
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index d3ce37e..08c44b0 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -6,6 +6,7 @@
 #include <linux/dmi.h>
 #include <linux/sched.h>
 #include <linux/tboot.h>
+#include <linux/delay.h>
 #include <acpi/reboot.h>
 #include <asm/io.h>
 #include <asm/apic.h>
diff --git a/arch/x86/platform/uv/tlb_uv.c b/arch/x86/platform/uv/tlb_uv.c
index a7b38d3..7cb6424 100644
--- a/arch/x86/platform/uv/tlb_uv.c
+++ b/arch/x86/platform/uv/tlb_uv.c
@@ -11,6 +11,7 @@
 #include <linux/debugfs.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
+#include <linux/delay.h>
 
 #include <asm/mmu_context.h>
 #include <asm/uv/uv.h>
diff --git a/drivers/media/rc/ite-cir.c b/drivers/media/rc/ite-cir.c
index ac0e42b..accaf6c 100644
--- a/drivers/media/rc/ite-cir.c
+++ b/drivers/media/rc/ite-cir.c
@@ -41,6 +41,7 @@
 #include <linux/bitops.h>
 #include <media/rc-core.h>
 #include <linux/pci_ids.h>
+#include <linux/delay.h>
 
 #include "ite-cir.h"
 
diff --git a/drivers/scsi/ultrastor.c b/drivers/scsi/ultrastor.c
index 0571ef9..9f4b58b 100644
--- a/drivers/scsi/ultrastor.c
+++ b/drivers/scsi/ultrastor.c
@@ -138,6 +138,7 @@
 #include <linux/spinlock.h>
 #include <linux/stat.h>
 #include <linux/bitops.h>
+#include <linux/delay.h>
 
 #include <asm/io.h>
 #include <asm/system.h>
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 11fd381..4e2c915 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -518,7 +518,7 @@
 #define PCI_DEVICE_ID_AMD_11H_NB_MISC	0x1303
 #define PCI_DEVICE_ID_AMD_11H_NB_LINK	0x1304
 #define PCI_DEVICE_ID_AMD_15H_NB_F3	0x1603
-#define PCI_DEVICE_ID_AMD_15H_NB_LINK	0x1604
+#define PCI_DEVICE_ID_AMD_15H_NB_F4	0x1604
 #define PCI_DEVICE_ID_AMD_CNB17H_F3	0x1703
 #define PCI_DEVICE_ID_AMD_LANCE		0x2000
 #define PCI_DEVICE_ID_AMD_LANCE_HOME	0x2001
diff --git a/sound/soc/codecs/sn95031.c b/sound/soc/codecs/sn95031.c
index 2a30eae..a54d2a5 100644
--- a/sound/soc/codecs/sn95031.c
+++ b/sound/soc/codecs/sn95031.c
@@ -26,7 +26,9 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/platform_device.h>
+#include <linux/delay.h>
 #include <linux/slab.h>
+
 #include <asm/intel_scu_ipc.h>
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
