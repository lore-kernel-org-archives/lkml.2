Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548Ab2D1JE7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 05:04:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44287 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190Ab2D1JEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 05:04:55 -0400
Date: Sat, 28 Apr 2012 02:02:46 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-8239c25f47d2b318156993b15f33900a86ea5e17@git.kernel.org>
Cc: mingo@kernel.org, jesper.nilsson@axis.com, rusty@rustcorp.com.au,
        schwidefsky@de.ibm.com, peterz@infradead.org, cmetcalf@tilera.com,
        tony.luck@intel.com, ralf@linux-mips.org, linux@arm.linux.org.uk,
        vapier@gentoo.org, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        hpa@zytor.com, richard@nod.at, lethal@linux-sh.org,
        srivatsa.bhat@linux.vnet.ibm.com, davem@davemloft.net,
        paulmck@linux.vnet.ibm.com, benh@kernel.crashing.org,
        dhowells@redhat.com, mattst88@gmail.com, jejb@parisc-linux.org,
        takata@linux-m32r.org, rkuo@codeaurora.org
Reply-To: mingo@kernel.org, jesper.nilsson@axis.com, rusty@rustcorp.com.au,
        peterz@infradead.org, schwidefsky@de.ibm.com, cmetcalf@tilera.com,
        tony.luck@intel.com, linux@arm.linux.org.uk, ralf@linux-mips.org,
        vapier@gentoo.org, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        hpa@zytor.com, richard@nod.at, lethal@linux-sh.org,
        srivatsa.bhat@linux.vnet.ibm.com, davem@davemloft.net,
        paulmck@linux.vnet.ibm.com, dhowells@redhat.com,
        benh@kernel.crashing.org, jejb@parisc-linux.org, mattst88@gmail.com,
        takata@linux-m32r.org, rkuo@codeaurora.org
In-Reply-To: <20120420124556.964170564@linutronix.de>
References: <20120420124556.964170564@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] smp: Add task_struct argument to __cpu_up()
Git-Commit-ID: 8239c25f47d2b318156993b15f33900a86ea5e17
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 28 Apr 2012 02:02:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8239c25f47d2b318156993b15f33900a86ea5e17
Gitweb:     http://git.kernel.org/tip/8239c25f47d2b318156993b15f33900a86ea5e17
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Fri, 20 Apr 2012 13:05:42 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 26 Apr 2012 12:06:09 +0200

smp: Add task_struct argument to __cpu_up()

Preparatory patch to make the idle thread allocation for secondary
cpus generic.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Richard Kuo <rkuo@codeaurora.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: David Howells <dhowells@redhat.com>
Cc: James E.J. Bottomley <jejb@parisc-linux.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: x86@kernel.org
Link: http://lkml.kernel.org/r/20120420124556.964170564@linutronix.de

---
 arch/alpha/kernel/smp.c         |    2 +-
 arch/arm/kernel/smp.c           |    2 +-
 arch/blackfin/mach-common/smp.c |    2 +-
 arch/cris/arch-v32/kernel/smp.c |    2 +-
 arch/hexagon/kernel/smp.c       |    2 +-
 arch/ia64/kernel/smpboot.c      |    2 +-
 arch/m32r/kernel/smpboot.c      |    2 +-
 arch/mips/kernel/smp.c          |    2 +-
 arch/mn10300/kernel/smp.c       |    2 +-
 arch/parisc/kernel/smp.c        |    2 +-
 arch/powerpc/kernel/smp.c       |    2 +-
 arch/s390/include/asm/smp.h     |    2 +-
 arch/s390/kernel/smp.c          |    2 +-
 arch/sh/kernel/smp.c            |    2 +-
 arch/sparc/kernel/smp_32.c      |    2 +-
 arch/sparc/kernel/smp_64.c      |    2 +-
 arch/tile/kernel/smpboot.c      |    2 +-
 arch/um/kernel/smp.c            |    2 +-
 arch/x86/include/asm/smp.h      |    4 +++-
 include/linux/smp.h             |    2 +-
 kernel/cpu.c                    |    2 +-
 21 files changed, 23 insertions(+), 21 deletions(-)

diff --git a/arch/alpha/kernel/smp.c b/arch/alpha/kernel/smp.c
index 50d438d..68d3947 100644
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -487,7 +487,7 @@ smp_prepare_boot_cpu(void)
 }
 
 int __cpuinit
-__cpu_up(unsigned int cpu)
+__cpu_up(unsigned int cpu, struct task_struct *tidle)
 {
 	smp_boot_one_cpu(cpu);
 
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index addbbe8..f0e2cbb 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -60,7 +60,7 @@ enum ipi_msg_type {
 
 static DECLARE_COMPLETION(cpu_running);
 
-int __cpuinit __cpu_up(unsigned int cpu)
+int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *tidle)
 {
 	struct cpuinfo_arm *ci = &per_cpu(cpu_data, cpu);
 	struct task_struct *idle = ci->idle;
diff --git a/arch/blackfin/mach-common/smp.c b/arch/blackfin/mach-common/smp.c
index ac8f8a4..d0cddd9 100644
--- a/arch/blackfin/mach-common/smp.c
+++ b/arch/blackfin/mach-common/smp.c
@@ -340,7 +340,7 @@ void smp_send_stop(void)
 	return;
 }
 
-int __cpuinit __cpu_up(unsigned int cpu)
+int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *tidle)
 {
 	int ret;
 	struct blackfin_cpudata *ci = &per_cpu(cpu_data, cpu);
diff --git a/arch/cris/arch-v32/kernel/smp.c b/arch/cris/arch-v32/kernel/smp.c
index 0b99df7..125ee2d 100644
--- a/arch/cris/arch-v32/kernel/smp.c
+++ b/arch/cris/arch-v32/kernel/smp.c
@@ -207,7 +207,7 @@ int setup_profiling_timer(unsigned int multiplier)
  */
 unsigned long cache_decay_ticks = 1;
 
-int __cpuinit __cpu_up(unsigned int cpu)
+int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *tidle)
 {
 	smp_boot_one_cpu(cpu);
 	return cpu_online(cpu) ? 0 : -ENOSYS;
diff --git a/arch/hexagon/kernel/smp.c b/arch/hexagon/kernel/smp.c
index 1298141..93e77e2 100644
--- a/arch/hexagon/kernel/smp.c
+++ b/arch/hexagon/kernel/smp.c
@@ -196,7 +196,7 @@ void __cpuinit start_secondary(void)
  * maintains control until "cpu_online(cpu)" is set.
  */
 
-int __cpuinit __cpu_up(unsigned int cpu)
+int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *tidle)
 {
 	struct task_struct *idle;
 	struct thread_info *thread;
diff --git a/arch/ia64/kernel/smpboot.c b/arch/ia64/kernel/smpboot.c
index 796f6a5..03e4ef3 100644
--- a/arch/ia64/kernel/smpboot.c
+++ b/arch/ia64/kernel/smpboot.c
@@ -793,7 +793,7 @@ set_cpu_sibling_map(int cpu)
 }
 
 int __cpuinit
-__cpu_up (unsigned int cpu)
+__cpu_up(unsigned int cpu, struct task_struct *tidle)
 {
 	int ret;
 	int sapicid;
diff --git a/arch/m32r/kernel/smpboot.c b/arch/m32r/kernel/smpboot.c
index 31541c9..a2cfc0a 100644
--- a/arch/m32r/kernel/smpboot.c
+++ b/arch/m32r/kernel/smpboot.c
@@ -343,7 +343,7 @@ static void __init do_boot_cpu(int phys_id)
 	}
 }
 
-int __cpuinit __cpu_up(unsigned int cpu_id)
+int __cpuinit __cpu_up(unsigned int cpu_id, struct task_struct *tidle)
 {
 	int timeout;
 
diff --git a/arch/mips/kernel/smp.c b/arch/mips/kernel/smp.c
index ba9376b..41079b2 100644
--- a/arch/mips/kernel/smp.c
+++ b/arch/mips/kernel/smp.c
@@ -209,7 +209,7 @@ static void __cpuinit do_fork_idle(struct work_struct *work)
 	complete(&c_idle->done);
 }
 
-int __cpuinit __cpu_up(unsigned int cpu)
+int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *tidle)
 {
 	struct task_struct *idle;
 
diff --git a/arch/mn10300/kernel/smp.c b/arch/mn10300/kernel/smp.c
index 910dddf..c6b40da 100644
--- a/arch/mn10300/kernel/smp.c
+++ b/arch/mn10300/kernel/smp.c
@@ -921,7 +921,7 @@ void initialize_secondary(void)
  * __cpu_up - Set smp_commenced_mask for the nominated CPU
  * @cpu: The target CPU.
  */
-int __devinit __cpu_up(unsigned int cpu)
+int __devinit __cpu_up(unsigned int cpu, struct task_struct *tidle)
 {
 	int timeout;
 
diff --git a/arch/parisc/kernel/smp.c b/arch/parisc/kernel/smp.c
index 0bb1d63..eae8cd8 100644
--- a/arch/parisc/kernel/smp.c
+++ b/arch/parisc/kernel/smp.c
@@ -449,7 +449,7 @@ void smp_cpus_done(unsigned int cpu_max)
 }
 
 
-int __cpuinit __cpu_up(unsigned int cpu)
+int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *tidle)
 {
 	if (cpu != 0 && cpu < parisc_max_cpus)
 		smp_boot_one_cpu(cpu);
diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index d9f9441..d38030f 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -482,7 +482,7 @@ static int __cpuinit create_idle(unsigned int cpu)
 	return 0;
 }
 
-int __cpuinit __cpu_up(unsigned int cpu)
+int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *tidle)
 {
 	int rc, c;
 
diff --git a/arch/s390/include/asm/smp.h b/arch/s390/include/asm/smp.h
index c77c6de..0b6f586 100644
--- a/arch/s390/include/asm/smp.h
+++ b/arch/s390/include/asm/smp.h
@@ -16,7 +16,7 @@
 extern struct mutex smp_cpu_state_mutex;
 extern struct save_area *zfcpdump_save_areas[NR_CPUS + 1];
 
-extern int __cpu_up(unsigned int cpu);
+extern int __cpu_up(unsigned int cpu, struct task_struct *tidle);
 
 extern void arch_send_call_function_single_ipi(int cpu);
 extern void arch_send_call_function_ipi_mask(const struct cpumask *mask);
diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index 1f77227..fc827aa 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -738,7 +738,7 @@ static void __cpuinit smp_fork_idle(struct work_struct *work)
 }
 
 /* Upping and downing of CPUs */
-int __cpuinit __cpu_up(unsigned int cpu)
+int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *tidle)
 {
 	struct create_idle c_idle;
 	struct pcpu *pcpu;
diff --git a/arch/sh/kernel/smp.c b/arch/sh/kernel/smp.c
index eaebdf6..ebb76e2 100644
--- a/arch/sh/kernel/smp.c
+++ b/arch/sh/kernel/smp.c
@@ -220,7 +220,7 @@ extern struct {
 	void *thread_info;
 } stack_start;
 
-int __cpuinit __cpu_up(unsigned int cpu)
+int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *tidle)
 {
 	struct task_struct *tsk;
 	unsigned long timeout;
diff --git a/arch/sparc/kernel/smp_32.c b/arch/sparc/kernel/smp_32.c
index f671e7f..1f397ae 100644
--- a/arch/sparc/kernel/smp_32.c
+++ b/arch/sparc/kernel/smp_32.c
@@ -411,7 +411,7 @@ void __init smp_prepare_boot_cpu(void)
 	set_cpu_possible(cpuid, true);
 }
 
-int __cpuinit __cpu_up(unsigned int cpu)
+int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *tidle)
 {
 	extern int __cpuinit smp4m_boot_one_cpu(int);
 	extern int __cpuinit smp4d_boot_one_cpu(int);
diff --git a/arch/sparc/kernel/smp_64.c b/arch/sparc/kernel/smp_64.c
index 3b1bd7c..2f9948c 100644
--- a/arch/sparc/kernel/smp_64.c
+++ b/arch/sparc/kernel/smp_64.c
@@ -1227,7 +1227,7 @@ void __devinit smp_fill_in_sib_core_maps(void)
 	}
 }
 
-int __cpuinit __cpu_up(unsigned int cpu)
+int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *tidle)
 {
 	int ret = smp_boot_one_cpu(cpu);
 
diff --git a/arch/tile/kernel/smpboot.c b/arch/tile/kernel/smpboot.c
index 172aef7..84873fb 100644
--- a/arch/tile/kernel/smpboot.c
+++ b/arch/tile/kernel/smpboot.c
@@ -222,7 +222,7 @@ void __cpuinit online_secondary(void)
 	cpu_idle();
 }
 
-int __cpuinit __cpu_up(unsigned int cpu)
+int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *tidle)
 {
 	/* Wait 5s total for all CPUs for them to come online */
 	static int timeout;
diff --git a/arch/um/kernel/smp.c b/arch/um/kernel/smp.c
index 6f588e1..a02b7e9 100644
--- a/arch/um/kernel/smp.c
+++ b/arch/um/kernel/smp.c
@@ -140,7 +140,7 @@ void smp_prepare_boot_cpu(void)
 	set_cpu_online(smp_processor_id(), true);
 }
 
-int __cpu_up(unsigned int cpu)
+int __cpu_up(unsigned int cpu, struct task_struct *tidle)
 {
 	cpu_set(cpu, smp_commenced_mask);
 	while (!cpu_online(cpu))
diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 0434c40..4eb3a74 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -62,6 +62,8 @@ DECLARE_EARLY_PER_CPU(int, x86_cpu_to_logical_apicid);
 /* Static state in head.S used to set up a CPU */
 extern unsigned long stack_start; /* Initial stack pointer address */
 
+struct task_struct;
+
 struct smp_ops {
 	void (*smp_prepare_boot_cpu)(void);
 	void (*smp_prepare_cpus)(unsigned max_cpus);
@@ -113,7 +115,7 @@ static inline void smp_cpus_done(unsigned int max_cpus)
 	smp_ops.smp_cpus_done(max_cpus);
 }
 
-static inline int __cpu_up(unsigned int cpu)
+static inline int __cpu_up(unsigned int cpu, struct task_struct *tidle)
 {
 	return smp_ops.cpu_up(cpu);
 }
diff --git a/include/linux/smp.h b/include/linux/smp.h
index 10530d9..24360de 100644
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -61,7 +61,7 @@ extern void smp_prepare_cpus(unsigned int max_cpus);
 /*
  * Bring a CPU up
  */
-extern int __cpu_up(unsigned int cpunum);
+extern int __cpu_up(unsigned int cpunum, struct task_struct *tidle);
 
 /*
  * Final polishing of CPUs
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 2060c6e..e711aef 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -309,7 +309,7 @@ static int __cpuinit _cpu_up(unsigned int cpu, int tasks_frozen)
 	}
 
 	/* Arch-specific enabling code. */
-	ret = __cpu_up(cpu);
+	ret = __cpu_up(cpu, NULL);
 	if (ret != 0)
 		goto out_notify;
 	BUG_ON(!cpu_online(cpu));
