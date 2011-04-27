Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988Ab1D0PHu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 11:07:50 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:60544 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564Ab1D0PHs convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:3:1>);
	Wed, 27 Apr 2011 11:07:48 -0400
Message-Id: <4DB84DAD020000780003E679@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 27 Apr 2011 16:09:01 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: mark a few more per-CPU items read-mostly
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/include/asm/percpu.h    |    2 +-
 arch/x86/include/asm/processor.h |    4 ++--
 arch/x86/include/asm/smp.h       |   10 +++++-----
 arch/x86/kernel/setup_percpu.c   |    4 ++--
 arch/x86/kernel/smpboot.c        |   10 +++++-----
 5 files changed, 15 insertions(+), 15 deletions(-)

--- 2.6.39-rc5/arch/x86/include/asm/percpu.h
+++ 2.6.39-rc5-x86-cpu-info-read-mostly/arch/x86/include/asm/percpu.h
@@ -545,7 +545,7 @@ do {									\
 #include <asm-generic/percpu.h>
 
 /* We can use this directly for local CPU (faster). */
-DECLARE_PER_CPU(unsigned long, this_cpu_off);
+DECLARE_PER_CPU_READ_MOSTLY(unsigned long, this_cpu_off);
 
 #endif /* !__ASSEMBLY__ */
 
--- 2.6.39-rc5/arch/x86/include/asm/processor.h
+++ 2.6.39-rc5-x86-cpu-info-read-mostly/arch/x86/include/asm/processor.h
@@ -111,7 +111,7 @@ struct cpuinfo_x86 {
 	/* Index into per_cpu list: */
 	u16			cpu_index;
 #endif
-} __attribute__((__aligned__(SMP_CACHE_BYTES)));
+};
 
 #define X86_VENDOR_INTEL	0
 #define X86_VENDOR_CYRIX	1
@@ -135,7 +135,7 @@ extern __u32			cpu_caps_cleared[NCAPINTS
 extern __u32			cpu_caps_set[NCAPINTS];
 
 #ifdef CONFIG_SMP
-DECLARE_PER_CPU_SHARED_ALIGNED(struct cpuinfo_x86, cpu_info);
+DECLARE_PER_CPU_READ_MOSTLY(struct cpuinfo_x86, cpu_info);
 #define cpu_data(cpu)		per_cpu(cpu_info, cpu)
 #else
 #define cpu_info		boot_cpu_data
--- 2.6.39-rc5/arch/x86/include/asm/smp.h
+++ 2.6.39-rc5-x86-cpu-info-read-mostly/arch/x86/include/asm/smp.h
@@ -31,12 +31,12 @@ static inline bool cpu_has_ht_siblings(v
 	return has_siblings;
 }
 
-DECLARE_PER_CPU(cpumask_var_t, cpu_sibling_map);
-DECLARE_PER_CPU(cpumask_var_t, cpu_core_map);
+DECLARE_PER_CPU_READ_MOSTLY(cpumask_var_t, cpu_sibling_map);
+DECLARE_PER_CPU_READ_MOSTLY(cpumask_var_t, cpu_core_map);
 /* cpus sharing the last level cache: */
-DECLARE_PER_CPU(cpumask_var_t, cpu_llc_shared_map);
-DECLARE_PER_CPU(u16, cpu_llc_id);
-DECLARE_PER_CPU(int, cpu_number);
+DECLARE_PER_CPU_READ_MOSTLY(cpumask_var_t, cpu_llc_shared_map);
+DECLARE_PER_CPU_READ_MOSTLY(u16, cpu_llc_id);
+DECLARE_PER_CPU_READ_MOSTLY(int, cpu_number);
 
 static inline struct cpumask *cpu_sibling_mask(int cpu)
 {
--- 2.6.39-rc5/arch/x86/kernel/setup_percpu.c
+++ 2.6.39-rc5-x86-cpu-info-read-mostly/arch/x86/kernel/setup_percpu.c
@@ -21,7 +21,7 @@
 #include <asm/cpu.h>
 #include <asm/stackprotector.h>
 
-DEFINE_PER_CPU(int, cpu_number);
+DEFINE_PER_CPU_READ_MOSTLY(int, cpu_number);
 EXPORT_PER_CPU_SYMBOL(cpu_number);
 
 #ifdef CONFIG_X86_64
@@ -30,7 +30,7 @@ EXPORT_PER_CPU_SYMBOL(cpu_number);
 #define BOOT_PERCPU_OFFSET 0
 #endif
 
-DEFINE_PER_CPU(unsigned long, this_cpu_off) = BOOT_PERCPU_OFFSET;
+DEFINE_PER_CPU_READ_MOSTLY(unsigned long, this_cpu_off) = BOOT_PERCPU_OFFSET;
 EXPORT_PER_CPU_SYMBOL(this_cpu_off);
 
 unsigned long __per_cpu_offset[NR_CPUS] __read_mostly = {
--- 2.6.39-rc5/arch/x86/kernel/smpboot.c
+++ 2.6.39-rc5-x86-cpu-info-read-mostly/arch/x86/kernel/smpboot.c
@@ -117,20 +117,20 @@ int smp_num_siblings = 1;
 EXPORT_SYMBOL(smp_num_siblings);
 
 /* Last level cache ID of each logical CPU */
-DEFINE_PER_CPU(u16, cpu_llc_id) = BAD_APICID;
+DEFINE_PER_CPU_READ_MOSTLY(u16, cpu_llc_id) = BAD_APICID;
 
 /* representing HT siblings of each logical CPU */
-DEFINE_PER_CPU(cpumask_var_t, cpu_sibling_map);
+DEFINE_PER_CPU_READ_MOSTLY(cpumask_var_t, cpu_sibling_map);
 EXPORT_PER_CPU_SYMBOL(cpu_sibling_map);
 
 /* representing HT and core siblings of each logical CPU */
-DEFINE_PER_CPU(cpumask_var_t, cpu_core_map);
+DEFINE_PER_CPU_READ_MOSTLY(cpumask_var_t, cpu_core_map);
 EXPORT_PER_CPU_SYMBOL(cpu_core_map);
 
-DEFINE_PER_CPU(cpumask_var_t, cpu_llc_shared_map);
+DEFINE_PER_CPU_READ_MOSTLY(cpumask_var_t, cpu_llc_shared_map);
 
 /* Per CPU bogomips and other parameters */
-DEFINE_PER_CPU_SHARED_ALIGNED(struct cpuinfo_x86, cpu_info);
+DEFINE_PER_CPU_READ_MOSTLY(struct cpuinfo_x86, cpu_info);
 EXPORT_PER_CPU_SYMBOL(cpu_info);
 
 atomic_t init_deasserted;



