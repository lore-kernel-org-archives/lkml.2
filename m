Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467Ab2IOBGr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 21:06:47 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:48410 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753628Ab2IOBGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 21:06:10 -0400
From: John Stultz <john.stultz@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <john.stultz@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 3/3] jiffies: Add register_refined_jiffies() call to every arch
Date: Fri, 14 Sep 2012 21:05:30 -0400
Message-Id: <1347671130-22095-4-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347671130-22095-1-git-send-email-john.stultz@linaro.org>
References: <1347671130-22095-1-git-send-email-john.stultz@linaro.org>
x-cbid: 12091501-1976-0000-0000-00001158F498
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This isn't really something I want to submit, but shows what is
required to retain the refined jiffies clock calculation.

Instead of submitting this, which adds code that really
doesn't matter in most cases, I instead propose to not
submit this patch, and should anyone notice time quality
regressions caused by jiffies clock error, they can add
the appropriate changes from this patch.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 arch/alpha/kernel/setup.c      |    3 +++
 arch/arm/kernel/setup.c        |    2 ++
 arch/avr32/kernel/setup.c      |    2 ++
 arch/blackfin/kernel/setup.c   |    2 ++
 arch/c6x/kernel/setup.c        |    2 ++
 arch/cris/kernel/setup.c       |    2 ++
 arch/h8300/kernel/setup.c      |    2 ++
 arch/hexagon/kernel/setup.c    |    2 ++
 arch/ia64/kernel/setup.c       |    2 ++
 arch/m32r/kernel/setup.c       |    2 ++
 arch/m68k/kernel/setup_mm.c    |    2 ++
 arch/m68k/kernel/setup_no.c    |    2 ++
 arch/microblaze/kernel/setup.c |    2 ++
 arch/mips/kernel/setup.c       |    2 ++
 arch/mn10300/kernel/setup.c    |    2 ++
 arch/openrisc/kernel/setup.c   |    2 ++
 arch/parisc/kernel/setup.c     |    3 ++-
 arch/powerpc/kernel/setup_32.c |    2 ++
 arch/powerpc/kernel/setup_64.c |    2 ++
 arch/s390/kernel/setup.c       |    2 ++
 arch/score/kernel/setup.c      |    2 ++
 arch/sh/kernel/setup.c         |    2 ++
 arch/sparc/kernel/setup_32.c   |    2 ++
 arch/sparc/kernel/setup_64.c   |    2 ++
 arch/tile/kernel/setup.c       |    2 ++
 arch/um/kernel/um_arch.c       |    2 ++
 arch/unicore32/kernel/setup.c  |    2 ++
 arch/xtensa/kernel/setup.c     |    3 ++-
 28 files changed, 57 insertions(+), 2 deletions(-)

diff --git a/arch/alpha/kernel/setup.c b/arch/alpha/kernel/setup.c
index 9e3107cc5..cec1744 100644
--- a/arch/alpha/kernel/setup.c
+++ b/arch/alpha/kernel/setup.c
@@ -44,6 +44,7 @@
 #include <asm/io.h>
 #include <linux/log2.h>
 #include <linux/export.h>
+#include <linux/jiffies.h>
 
 extern struct atomic_notifier_head panic_notifier_list;
 static int alpha_panic_event(struct notifier_block *, unsigned long, void *);
@@ -747,6 +748,8 @@ setup_arch(char **cmdline_p)
 	setup_smp();
 #endif
 	paging_init();
+
+	register_refined_jiffies(CLOCK_TICK_RATE);
 }
 
 static char sys_unknown[] = "Unknown";
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index a81dcec..9b4580c 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -31,6 +31,7 @@
 #include <linux/bug.h>
 #include <linux/compiler.h>
 #include <linux/sort.h>
+#include <linux/jiffies.h>
 
 #include <asm/unified.h>
 #include <asm/cp15.h>
@@ -998,6 +999,7 @@ void __init setup_arch(char **cmdline_p)
 
 	if (mdesc->init_early)
 		mdesc->init_early();
+	register_refined_jiffies(CLOCK_TICK_RATE);
 }
 
 
diff --git a/arch/avr32/kernel/setup.c b/arch/avr32/kernel/setup.c
index b4247f4..141ac85 100644
--- a/arch/avr32/kernel/setup.c
+++ b/arch/avr32/kernel/setup.c
@@ -19,6 +19,7 @@
 #include <linux/root_dev.h>
 #include <linux/cpu.h>
 #include <linux/kernel.h>
+#include <linux/jiffies.h>
 
 #include <asm/sections.h>
 #include <asm/processor.h>
@@ -606,4 +607,5 @@ void __init setup_arch (char **cmdline_p)
 
 	paging_init();
 	resource_init();
+	register_refined_jiffies(CLOCK_TICK_RATE);
 }
diff --git a/arch/blackfin/kernel/setup.c b/arch/blackfin/kernel/setup.c
index fb96e60..71a4c1b 100644
--- a/arch/blackfin/kernel/setup.c
+++ b/arch/blackfin/kernel/setup.c
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 #include <linux/tty.h>
 #include <linux/pfn.h>
+#include <linux/jiffies.h>
 
 #ifdef CONFIG_MTD_UCLINUX
 #include <linux/mtd/map.h>
@@ -1101,6 +1102,7 @@ void __init setup_arch(char **cmdline_p)
 #endif
 	init_exception_vectors();
 	bfin_cache_init();	/* Initialize caches for the boot CPU */
+	register_refined_jiffies(CLOCK_TICK_RATE);
 }
 
 static int __init topology_init(void)
diff --git a/arch/c6x/kernel/setup.c b/arch/c6x/kernel/setup.c
index f4e72bd..b95997a 100644
--- a/arch/c6x/kernel/setup.c
+++ b/arch/c6x/kernel/setup.c
@@ -12,6 +12,7 @@
 #include <linux/memblock.h>
 #include <linux/seq_file.h>
 #include <linux/bootmem.h>
+#include <linux/jiffies.h>
 #include <linux/clkdev.h>
 #include <linux/initrd.h>
 #include <linux/kernel.h>
@@ -441,6 +442,7 @@ void __init setup_arch(char **cmdline_p)
 #if defined(CONFIG_VT) && defined(CONFIG_DUMMY_CONSOLE)
 	conswitchp = &dummy_con;
 #endif
+	register_refined_jiffies(CLOCK_TICK_RATE);
 }
 
 #define cpu_to_ptr(n) ((void *)((long)(n)+1))
diff --git a/arch/cris/kernel/setup.c b/arch/cris/kernel/setup.c
index 32c3d24..9a18d57 100644
--- a/arch/cris/kernel/setup.c
+++ b/arch/cris/kernel/setup.c
@@ -19,6 +19,7 @@
 #include <linux/utsname.h>
 #include <linux/pfn.h>
 #include <linux/cpu.h>
+#include <linux/jiffies.h>
 #include <asm/setup.h>
 #include <arch/system.h>
 
@@ -163,6 +164,7 @@ void __init setup_arch(char **cmdline_p)
 
 	/* Setup utsname */
 	strcpy(init_utsname()->machine, cris_machine_name);
+	register_refined_jiffies(CLOCK_TICK_RATE);
 }
 
 static void *c_start(struct seq_file *m, loff_t *pos)
diff --git a/arch/h8300/kernel/setup.c b/arch/h8300/kernel/setup.c
index d0b1607..4da1763 100644
--- a/arch/h8300/kernel/setup.c
+++ b/arch/h8300/kernel/setup.c
@@ -31,6 +31,7 @@
 #include <linux/bootmem.h>
 #include <linux/seq_file.h>
 #include <linux/init.h>
+#include <linux/jiffies.h>
 
 #include <asm/setup.h>
 #include <asm/irq.h>
@@ -187,6 +188,7 @@ void __init setup_arch(char **cmdline_p)
 		*cscr  |= (AREABIT(CONFIG_H8300_IDE_BASE) | AREABIT(CONFIG_H8300_IDE_ALT)) | 0x0f;
 	}
 #endif
+	register_refined_jiffies(CLOCK_TICK_RATE);
 #ifdef DEBUG
 	printk(KERN_DEBUG "Done setup_arch\n");
 #endif
diff --git a/arch/hexagon/kernel/setup.c b/arch/hexagon/kernel/setup.c
index 1202f78..d0d5cce 100644
--- a/arch/hexagon/kernel/setup.c
+++ b/arch/hexagon/kernel/setup.c
@@ -25,6 +25,7 @@
 #include <linux/seq_file.h>
 #include <linux/console.h>
 #include <linux/of_fdt.h>
+#include <linux/jiffies.h>
 #include <asm/io.h>
 #include <asm/sections.h>
 #include <asm/setup.h>
@@ -99,6 +100,7 @@ void __init setup_arch(char **cmdline_p)
 #ifdef CONFIG_SMP
 	smp_start_cpus();
 #endif
+	register_refined_jiffies(CLOCK_TICK_RATE);
 }
 
 /*
diff --git a/arch/ia64/kernel/setup.c b/arch/ia64/kernel/setup.c
index aaefd9b..2d6dce2 100644
--- a/arch/ia64/kernel/setup.c
+++ b/arch/ia64/kernel/setup.c
@@ -45,6 +45,7 @@
 #include <linux/cpufreq.h>
 #include <linux/kexec.h>
 #include <linux/crash_dump.h>
+#include <linux/jiffies.h>
 
 #include <asm/machvec.h>
 #include <asm/mca.h>
@@ -626,6 +627,7 @@ setup_arch (char **cmdline_p)
 	check_sal_cache_flush();
 #endif
 	paging_init();
+	register_refined_jiffies(CLOCK_TICK_RATE);
 }
 
 /*
diff --git a/arch/m32r/kernel/setup.c b/arch/m32r/kernel/setup.c
index 0392112..f6c5bf3 100644
--- a/arch/m32r/kernel/setup.c
+++ b/arch/m32r/kernel/setup.c
@@ -25,6 +25,7 @@
 #include <linux/cpu.h>
 #include <linux/nodemask.h>
 #include <linux/pfn.h>
+#include <linux/jiffies.h>
 
 #include <asm/processor.h>
 #include <asm/pgtable.h>
@@ -266,6 +267,7 @@ void __init setup_arch(char **cmdline_p)
 	setup_memory();
 
 	paging_init();
+	register_refined_jiffies(CLOCK_TICK_RATE);
 }
 
 static struct cpu cpu_devices[NR_CPUS];
diff --git a/arch/m68k/kernel/setup_mm.c b/arch/m68k/kernel/setup_mm.c
index d872ce4..3521cde 100644
--- a/arch/m68k/kernel/setup_mm.c
+++ b/arch/m68k/kernel/setup_mm.c
@@ -24,6 +24,7 @@
 #include <linux/seq_file.h>
 #include <linux/module.h>
 #include <linux/initrd.h>
+#include <linux/jiffies.h>
 
 #include <asm/bootinfo.h>
 #include <asm/sections.h>
@@ -383,6 +384,7 @@ void __init setup_arch(char **cmdline_p)
 	}
 #endif
 #endif
+	register_refined_jiffies(CLOCK_TICK_RATE);
 }
 
 static int show_cpuinfo(struct seq_file *m, void *v)
diff --git a/arch/m68k/kernel/setup_no.c b/arch/m68k/kernel/setup_no.c
index 71fb299..055c452 100644
--- a/arch/m68k/kernel/setup_no.c
+++ b/arch/m68k/kernel/setup_no.c
@@ -32,6 +32,7 @@
 #include <linux/initrd.h>
 #include <linux/root_dev.h>
 #include <linux/rtc.h>
+#include <linux/jiffies.h>
 
 #include <asm/setup.h>
 #include <asm/irq.h>
@@ -259,6 +260,7 @@ void __init setup_arch(char **cmdline_p)
 	 * Get kmalloc into gear.
 	 */
 	paging_init();
+	register_refined_jiffies(CLOCK_TICK_RATE);
 }
 
 /*
diff --git a/arch/microblaze/kernel/setup.c b/arch/microblaze/kernel/setup.c
index 4da971d..3dbddc7 100644
--- a/arch/microblaze/kernel/setup.c
+++ b/arch/microblaze/kernel/setup.c
@@ -15,6 +15,7 @@
 #include <linux/initrd.h>
 #include <linux/console.h>
 #include <linux/debugfs.h>
+#include <linux/jiffies.h>
 
 #include <asm/setup.h>
 #include <asm/sections.h>
@@ -74,6 +75,7 @@ void __init setup_arch(char **cmdline_p)
 	conswitchp = &dummy_con;
 #endif
 #endif
+	register_refined_jiffies(CLOCK_TICK_RATE);
 }
 
 #ifdef CONFIG_MTD_UCLINUX
diff --git a/arch/mips/kernel/setup.c b/arch/mips/kernel/setup.c
index a53f8ec..502eb50 100644
--- a/arch/mips/kernel/setup.c
+++ b/arch/mips/kernel/setup.c
@@ -22,6 +22,7 @@
 #include <linux/console.h>
 #include <linux/pfn.h>
 #include <linux/debugfs.h>
+#include <linux/jiffies.h>
 
 #include <asm/addrspace.h>
 #include <asm/bootinfo.h>
@@ -607,6 +608,7 @@ void __init setup_arch(char **cmdline_p)
 	plat_smp_setup();
 
 	cpu_cache_init();
+	register_refined_jiffies(CLOCK_TICK_RATE);
 }
 
 unsigned long kernelsp[NR_CPUS];
diff --git a/arch/mn10300/kernel/setup.c b/arch/mn10300/kernel/setup.c
index 33c3bd1..7e615e0 100644
--- a/arch/mn10300/kernel/setup.c
+++ b/arch/mn10300/kernel/setup.c
@@ -22,6 +22,7 @@
 #include <linux/init.h>
 #include <linux/bootmem.h>
 #include <linux/seq_file.h>
+#include <linux/jiffies.h>
 #include <linux/cpu.h>
 #include <asm/processor.h>
 #include <linux/console.h>
@@ -173,6 +174,7 @@ void __init setup_arch(char **cmdline_p)
 #endif
 
 	paging_init();
+	register_refined_jiffies(CLOCK_TICK_RATE);
 }
 
 /*
diff --git a/arch/openrisc/kernel/setup.c b/arch/openrisc/kernel/setup.c
index f4d5bed..1c42ac3 100644
--- a/arch/openrisc/kernel/setup.c
+++ b/arch/openrisc/kernel/setup.c
@@ -39,6 +39,7 @@
 #include <linux/memblock.h>
 #include <linux/device.h>
 #include <linux/of_platform.h>
+#include <linux/jiffies.h>
 
 #include <asm/segment.h>
 #include <asm/pgtable.h>
@@ -318,6 +319,7 @@ void __init setup_arch(char **cmdline_p)
 
 	*cmdline_p = cmd_line;
 
+	register_refined_jiffies(CLOCK_TICK_RATE);
 	printk(KERN_INFO "OpenRISC Linux -- http://openrisc.net\n");
 }
 
diff --git a/arch/parisc/kernel/setup.c b/arch/parisc/kernel/setup.c
index a3328c2..93af0cf 100644
--- a/arch/parisc/kernel/setup.c
+++ b/arch/parisc/kernel/setup.c
@@ -36,6 +36,7 @@
 #undef PCI_DEBUG
 #include <linux/proc_fs.h>
 #include <linux/export.h>
+#include <linux/jiffies.h>
 
 #include <asm/processor.h>
 #include <asm/pdc.h>
@@ -155,7 +156,7 @@ void __init setup_arch(char **cmdline_p)
 #if defined(CONFIG_VT) && defined(CONFIG_DUMMY_CONSOLE)
 	conswitchp = &dummy_con;	/* we use take_over_console() later ! */
 #endif
-
+	register_refined_jiffies(CLOCK_TICK_RATE);
 }
 
 /*
diff --git a/arch/powerpc/kernel/setup_32.c b/arch/powerpc/kernel/setup_32.c
index a8f54ec..e9e92c7 100644
--- a/arch/powerpc/kernel/setup_32.c
+++ b/arch/powerpc/kernel/setup_32.c
@@ -17,6 +17,7 @@
 #include <linux/cpu.h>
 #include <linux/console.h>
 #include <linux/memblock.h>
+#include <linux/jiffies.h>
 
 #include <asm/io.h>
 #include <asm/prom.h>
@@ -327,4 +328,5 @@ void __init setup_arch(char **cmdline_p)
 	/* Initialize the MMU context management stuff */
 	mmu_context_init();
 
+	register_refined_jiffies(CLOCK_TICK_RATE);
 }
diff --git a/arch/powerpc/kernel/setup_64.c b/arch/powerpc/kernel/setup_64.c
index 389bd4f..9d9c3f4 100644
--- a/arch/powerpc/kernel/setup_64.c
+++ b/arch/powerpc/kernel/setup_64.c
@@ -36,6 +36,7 @@
 #include <linux/lockdep.h>
 #include <linux/memblock.h>
 #include <linux/hugetlb.h>
+#include <linux/jiffies.h>
 
 #include <asm/io.h>
 #include <asm/kdump.h>
@@ -599,6 +600,7 @@ void __init setup_arch(char **cmdline_p)
 
 	kvm_linear_init();
 
+	register_refined_jiffies(CLOCK_TICK_RATE);
 	ppc64_boot_msg(0x15, "Setup Done");
 }
 
diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index f86c81e..4f15231 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -45,6 +45,7 @@
 #include <linux/crash_dump.h>
 #include <linux/memory.h>
 #include <linux/compat.h>
+#include <linux/jiffies.h>
 
 #include <asm/ipl.h>
 #include <asm/uaccess.h>
@@ -1094,4 +1095,5 @@ void __init setup_arch(char **cmdline_p)
 
 	/* Setup zfcpdump support */
 	setup_zfcpdump(console_devno);
+	register_refined_jiffies(CLOCK_TICK_RATE);
 }
diff --git a/arch/score/kernel/setup.c b/arch/score/kernel/setup.c
index b48459a..e68d17b 100644
--- a/arch/score/kernel/setup.c
+++ b/arch/score/kernel/setup.c
@@ -30,6 +30,7 @@
 #include <linux/mm.h>
 #include <linux/seq_file.h>
 #include <linux/screen_info.h>
+#include <linux/jiffies.h>
 
 #include <asm-generic/sections.h>
 #include <asm/setup.h>
@@ -118,6 +119,7 @@ void __init setup_arch(char **cmdline_p)
 	bootmem_init();
 	paging_init();
 	resource_init();
+	register_refined_jiffies(CLOCK_TICK_RATE);
 }
 
 static int show_cpuinfo(struct seq_file *m, void *v)
diff --git a/arch/sh/kernel/setup.c b/arch/sh/kernel/setup.c
index ebe7a7d..6ab324d 100644
--- a/arch/sh/kernel/setup.c
+++ b/arch/sh/kernel/setup.c
@@ -29,6 +29,7 @@
 #include <linux/delay.h>
 #include <linux/platform_device.h>
 #include <linux/memblock.h>
+#include <linux/jiffies.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
 #include <asm/page.h>
@@ -309,6 +310,7 @@ void __init setup_arch(char **cmdline_p)
 		sh_mv.mv_setup(cmdline_p);
 
 	plat_smp_setup();
+	register_refined_jiffies(CLOCK_TICK_RATE);
 }
 
 /* processor boot mode configuration */
diff --git a/arch/sparc/kernel/setup_32.c b/arch/sparc/kernel/setup_32.c
index 38bf80a..7f4c87f 100644
--- a/arch/sparc/kernel/setup_32.c
+++ b/arch/sparc/kernel/setup_32.c
@@ -33,6 +33,7 @@
 #include <linux/kdebug.h>
 #include <linux/export.h>
 #include <linux/start_kernel.h>
+#include <linux/jiffies.h>
 
 #include <asm/io.h>
 #include <asm/processor.h>
@@ -379,6 +380,7 @@ void __init setup_arch(char **cmdline_p)
 	paging_init();
 
 	smp_setup_cpu_possible_map();
+	register_refined_jiffies(CLOCK_TICK_RATE);
 }
 
 extern int stop_a_enabled;
diff --git a/arch/sparc/kernel/setup_64.c b/arch/sparc/kernel/setup_64.c
index 1414d16..7ec0638 100644
--- a/arch/sparc/kernel/setup_64.c
+++ b/arch/sparc/kernel/setup_64.c
@@ -30,6 +30,7 @@
 #include <linux/cpu.h>
 #include <linux/initrd.h>
 #include <linux/module.h>
+#include <linux/jiffies.h>
 
 #include <asm/io.h>
 #include <asm/processor.h>
@@ -547,6 +548,7 @@ void __init setup_arch(char **cmdline_p)
 
 	paging_init();
 	init_sparc64_elf_hwcap();
+	register_refined_jiffies(CLOCK_TICK_RATE);
 }
 
 extern int stop_a_enabled;
diff --git a/arch/tile/kernel/setup.c b/arch/tile/kernel/setup.c
index 6a649a4..f1bc41e 100644
--- a/arch/tile/kernel/setup.c
+++ b/arch/tile/kernel/setup.c
@@ -31,6 +31,7 @@
 #include <linux/timex.h>
 #include <linux/hugetlb.h>
 #include <linux/start_kernel.h>
+#include <linux/jiffies.h>
 #include <asm/setup.h>
 #include <asm/sections.h>
 #include <asm/cacheflush.h>
@@ -1392,6 +1393,7 @@ void __init setup_arch(char **cmdline_p)
 	setup_cpu(1);
 	setup_clock();
 	load_hv_initrd();
+	register_refined_jiffies(CLOCK_TICK_RATE);
 }
 
 
diff --git a/arch/um/kernel/um_arch.c b/arch/um/kernel/um_arch.c
index 4db8770..4d988e1 100644
--- a/arch/um/kernel/um_arch.c
+++ b/arch/um/kernel/um_arch.c
@@ -11,6 +11,7 @@
 #include <linux/string.h>
 #include <linux/utsname.h>
 #include <linux/sched.h>
+#include <linux/jiffies.h>
 #include <asm/pgtable.h>
 #include <asm/processor.h>
 #include <asm/setup.h>
@@ -384,6 +385,7 @@ void __init setup_arch(char **cmdline_p)
 	strlcpy(boot_command_line, command_line, COMMAND_LINE_SIZE);
 	*cmdline_p = command_line;
 	setup_hostinfo(host_info, sizeof host_info);
+	register_refined_jiffies(CLOCK_TICK_RATE);
 }
 
 void __init check_bugs(void)
diff --git a/arch/unicore32/kernel/setup.c b/arch/unicore32/kernel/setup.c
index 87adbf5..198c647 100644
--- a/arch/unicore32/kernel/setup.c
+++ b/arch/unicore32/kernel/setup.c
@@ -30,6 +30,7 @@
 #include <linux/memblock.h>
 #include <linux/elf.h>
 #include <linux/io.h>
+#include <linux/jiffies.h>
 
 #include <asm/cputype.h>
 #include <asm/sections.h>
@@ -271,6 +272,7 @@ void __init setup_arch(char **cmdline_p)
 #endif
 #endif
 	early_trap_init();
+	register_refined_jiffies(CLOCK_TICK_RATE);
 }
 
 static struct cpu cpuinfo_unicore;
diff --git a/arch/xtensa/kernel/setup.c b/arch/xtensa/kernel/setup.c
index 17e746f..1a817ff 100644
--- a/arch/xtensa/kernel/setup.c
+++ b/arch/xtensa/kernel/setup.c
@@ -21,7 +21,7 @@
 #include <linux/screen_info.h>
 #include <linux/bootmem.h>
 #include <linux/kernel.h>
-
+#include <linux/jiffies.h>
 #if defined(CONFIG_VGA_CONSOLE) || defined(CONFIG_DUMMY_CONSOLE)
 # include <linux/console.h>
 #endif
@@ -304,6 +304,7 @@ void __init setup_arch(char **cmdline_p)
 #ifdef CONFIG_PCI
 	platform_pcibios_init();
 #endif
+	register_refined_jiffies(CLOCK_TICK_RATE);
 }
 
 void machine_restart(char * cmd)
-- 
1.7.9.5

