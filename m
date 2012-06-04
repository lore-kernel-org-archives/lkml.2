Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757178Ab2FDTf1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 15:35:27 -0400
Received: from smp.if.uj.edu.pl ([149.156.82.206]:41264 "EHLO smp.if.uj.edu.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406Ab2FDTfZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 15:35:25 -0400
Date: Mon, 4 Jun 2012 21:35:21 +0200
From: Witold Baryluk <baryluk@smp.if.uj.edu.pl>
To: Steven Rostedt <srostedt@redhat.com>
Cc: "H.J. Lu" <hjl.tools@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Failure(?) when testing trace event on UP kernel boot (INFO:
 suspicious RCU usage, when testing event rcu_something... )
Message-ID: <20120604193521.GE16584@smp.if.uj.edu.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I just rebuild by kernel with SMP disabled (This is 32-bit kernel
compiled with gcc-4.7 running on Pentium-M CPU), and this is what I got

[    0.000000] Linux version 3.4.0-t43-devel-up-10118-g233e562-dirty (baryluk@sredniczarny) (gcc version 4.7.0 (Debian 4.7.0-11) ) #2 Mon Jun 4 14:17:10 CEST 2012
...
[   18.535883] Running tests on trace events:
...
[   21.104950] Testing event rcu_utilization: OK
[   21.106136] 
[   21.106196] ===============================
[   21.106259] [ INFO: suspicious RCU usage. ]
[   21.106325] 3.4.0-t43-devel-up-10118-g233e562-dirty #2 Not tainted
[   21.106394] -------------------------------
[   21.106460] /sctank2/Dane/linux/linux-2.6/torvalds-linux-2.6/include/trace/events/rcu.h:275 suspicious rcu_dereference_check() usage!
[   21.106577] 
[   21.106577] other info that might help us debug this:
[   21.106577] 
[   21.106714] 
[   21.106714] RCU used illegally from idle CPU!
[   21.106714] rcu_scheduler_active = 1, debug_locks = 1
[   21.106858] RCU used illegally from extended quiescent state!
[   21.106927] no locks held by swapper/0.
[   21.106988] 
[   21.106988] stack backtrace:
[   21.107085] Pid: 0, comm: swapper Not tainted 3.4.0-t43-devel-up-10118-g233e562-dirty #2
[   21.107189] Call Trace:
[   21.107247] Testing event rcu_dyntick: 
[   21.107319]  [<c109908b>] lockdep_rcu_suspicious+0xcb/0xf0
[   21.107395]  [<c10d59a8>] rcu_idle_enter_common+0x248/0x3d0
[   21.107469]  [<c10d5c18>] ? rcu_idle_enter+0x28/0x100
[   21.107541]  [<c10d5c5a>] rcu_idle_enter+0x6a/0x100
[   21.107615]  [<c101c70a>] cpu_idle+0x5a/0x90
[   21.107686]  [<c175a1fe>] rest_init+0x126/0x138
[   21.107756]  [<c175a0d8>] ? reciprocal_value+0x48/0x48
[   21.107829]  [<c1c4b9a5>] start_kernel+0x31e/0x324
[   21.107900]  [<c1c4b4bc>] ? repair_env_string+0x51/0x51
[   21.107972]  [<c1c4b2d8>] i386_start_kernel+0x9b/0xa2
[   21.113001] OK
[   21.120950] Testing event rcu_prep_idle: OK
[   21.128954] Testing event rcu_callback: OK
[   21.136951] Testing event rcu_kfree_callback: OK
[   21.144968] Testing event rcu_batch_start: OK
[   21.152961] Testing event rcu_invoke_callback: OK
[   21.160960] Testing event rcu_invoke_kfree_callback: OK
[   21.168965] Testing event rcu_batch_end: OK
[   21.176957] Testing event rcu_torture_read: OK



sredniczarny:/boot# egrep 'SMP|LOCK|RCU|TRACE' /boot/config-`uname -r`
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_BROKEN_ON_SMP=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
# RCU Subsystem
CONFIG_TINY_RCU=y
# CONFIG_PREEMPT_RCU is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_TRACEPOINTS=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_BLOCK=y
# CONFIG_INLINE_SPIN_TRYLOCK is not set
# CONFIG_INLINE_SPIN_TRYLOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK is not set
# CONFIG_INLINE_SPIN_LOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK_IRQ is not set
# CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
CONFIG_UNINLINE_SPIN_UNLOCK=y
# CONFIG_INLINE_SPIN_UNLOCK_BH is not set
# CONFIG_INLINE_SPIN_UNLOCK_IRQ is not set
# CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_READ_TRYLOCK is not set
# CONFIG_INLINE_READ_LOCK is not set
# CONFIG_INLINE_READ_LOCK_BH is not set
# CONFIG_INLINE_READ_LOCK_IRQ is not set
# CONFIG_INLINE_READ_LOCK_IRQSAVE is not set
# CONFIG_INLINE_READ_UNLOCK is not set
# CONFIG_INLINE_READ_UNLOCK_BH is not set
# CONFIG_INLINE_READ_UNLOCK_IRQ is not set
# CONFIG_INLINE_READ_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_WRITE_TRYLOCK is not set
# CONFIG_INLINE_WRITE_LOCK is not set
# CONFIG_INLINE_WRITE_LOCK_BH is not set
# CONFIG_INLINE_WRITE_LOCK_IRQ is not set
# CONFIG_INLINE_WRITE_LOCK_IRQSAVE is not set
# CONFIG_INLINE_WRITE_UNLOCK is not set
# CONFIG_INLINE_WRITE_UNLOCK_BH is not set
# CONFIG_INLINE_WRITE_UNLOCK_IRQ is not set
# CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE is not set
# CONFIG_SMP is not set
# CONFIG_KVM_CLOCK is not set
CONFIG_PARAVIRT_CLOCK=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
CONFIG_PM_WAKELOCKS=y
CONFIG_PM_WAKELOCKS_LIMIT=100
CONFIG_PM_WAKELOCKS_GC=y
# CONFIG_X86_P4_CLOCKMOD is not set
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_NETFILTER_XT_TARGET_TRACE=m
CONFIG_DM_DEBUG_BLOCK_STACK_TRACING=y
CONFIG_TCM_IBLOCK=m
# CONFIG_TRACE_SINK is not set
# CONFIG_TELCLOCK is not set
CONFIG_I8253_LOCK=y
CONFIG_FILE_LOCKING=y
CONFIG_PNFS_BLOCK=m
CONFIG_LOCKD=y
CONFIG_LOCKD_V4=y
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=1
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=1
CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
CONFIG_PROVE_RCU=y
CONFIG_PROVE_RCU_REPEATEDLY=y
CONFIG_SPARSE_RCU_POINTER=y
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_STACKTRACE=y
CONFIG_RCU_TORTURE_TEST=m
CONFIG_RCU_TRACE=y
CONFIG_BACKTRACE_SELF_TEST=y
CONFIG_DEBUG_BLOCK_EXT_DEVT=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_GENERIC_TRACER=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
CONFIG_IRQSOFF_TRACER=y
CONFIG_SCHED_TRACER=y
CONFIG_FTRACE_SYSCALLS=y
CONFIG_STACK_TRACER=y
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_DYNAMIC_FTRACE=y
CONFIG_FTRACE_MCOUNT_RECORD=y
CONFIG_FTRACE_SELFTEST=y
CONFIG_FTRACE_STARTUP_TEST=y
CONFIG_EVENT_TRACE_TEST_SYSCALLS=y
# CONFIG_MMIOTRACE is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_XOR_BLOCKS=m

sredniczarny:/var/log# egrep 'EVENT' /boot/config-`uname -r`
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_EVENTFD=y
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PERF_EVENTS=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_OPROFILE_EVENT_MULTIPLEX=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
# CONFIG_ACPI_PROC_EVENT is not set
CONFIG_NF_CONNTRACK_EVENTS=y
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_PROC_EVENTS=y
CONFIG_DM_UEVENT=y
CONFIG_IPMI_PANIC_EVENT=y
CONFIG_EVENT_TRACING=y
# CONFIG_EVENT_POWER_TRACING_DEPRECATED is not set
CONFIG_KPROBE_EVENT=y
CONFIG_UPROBE_EVENT=y
CONFIG_PROBE_EVENTS=y
CONFIG_EVENT_TRACE_TEST_SYSCALLS=y


This failure doesn't show up on same kernel but with SMP

Jun  3 21:09:35 sredniczarny kernel: [   62.892021] Testing event rcu_utilization: OK
Jun  3 21:09:35 sredniczarny kernel: [   62.916021] Testing event rcu_grace_period: OK
Jun  3 21:09:35 sredniczarny kernel: [   62.940021] Testing event rcu_grace_period_init: OK
Jun  3 21:09:35 sredniczarny kernel: [   62.964021] Testing event rcu_preempt_task: OK
Jun  3 21:09:35 sredniczarny kernel: [   62.988021] Testing event rcu_unlock_preempted_task: OK
Jun  3 21:09:35 sredniczarny kernel: [   63.012021] Testing event rcu_quiescent_state_report: OK
Jun  3 21:09:35 sredniczarny kernel: [   63.036021] Testing event rcu_fqs: OK
Jun  3 21:09:35 sredniczarny kernel: [   63.060021] Testing event rcu_dyntick: OK
Jun  3 21:09:35 sredniczarny kernel: [   63.084021] Testing event rcu_prep_idle: OK
Jun  3 21:09:35 sredniczarny kernel: [   63.108021] Testing event rcu_callback: OK
Jun  3 21:09:35 sredniczarny kernel: [   63.132021] Testing event rcu_kfree_callback: OK
Jun  3 21:09:35 sredniczarny kernel: [   63.156021] Testing event rcu_batch_start: OK
Jun  3 21:09:35 sredniczarny kernel: [   63.180021] Testing event rcu_invoke_callback: OK
Jun  3 21:09:35 sredniczarny kernel: [   63.204021] Testing event rcu_invoke_kfree_callback: OK
Jun  3 21:09:35 sredniczarny kernel: [   63.228021] Testing event rcu_batch_end: OK
Jun  3 21:09:35 sredniczarny kernel: [   63.252021] Testing event rcu_torture_read: OK

Config diff:

# diff -u0 /boot/config-3.4.0-t43-devel-up-10118-g233e562-dirty /boot/config-3.4.0-t43-devel-smp-10118-g233e562-dirty  | egrep -v '^@'
--- /boot/config-3.4.0-t43-devel-up-10118-g233e562-dirty	2012-06-04 14:35:08.000000000 +0200
+++ /boot/config-3.4.0-t43-devel-smp-10118-g233e562-dirty	2012-06-02 20:57:13.000000000 +0200
+CONFIG_HAVE_INTEL_TXT=y
+CONFIG_X86_32_SMP=y
+CONFIG_X86_HT=y
+CONFIG_ARCH_CPU_PROBE_RELEASE=y
-CONFIG_BROKEN_ON_SMP=y
-CONFIG_LOCALVERSION="-t43-devel-up"
+CONFIG_LOCALVERSION="-t43-devel-smp"
+CONFIG_GENERIC_PENDING_IRQ=y
+CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
-CONFIG_TINY_RCU=y
+CONFIG_TREE_RCU=y
-# CONFIG_TREE_RCU_TRACE is not set
+CONFIG_RCU_FANOUT=32
+CONFIG_RCU_FANOUT_LEAF=16
+# CONFIG_RCU_FANOUT_EXACT is not set
+# CONFIG_RCU_FAST_NO_HZ is not set
+CONFIG_TREE_RCU_TRACE=y
+CONFIG_USE_GENERIC_SMP_HELPERS=y
+CONFIG_STOP_MACHINE=y
-# CONFIG_SMP is not set
+CONFIG_SMP=y
+CONFIG_X86_MPPARSE=y
+# CONFIG_X86_BIGSMP is not set
-# CONFIG_XEN_PRIVILEGED_GUEST is not set
+CONFIG_XEN_DOM0=y
+CONFIG_XEN_PRIVILEGED_GUEST=y
+CONFIG_XEN_PVHVM=y
+CONFIG_PARAVIRT_SPINLOCKS=y
-CONFIG_NR_CPUS=1
+CONFIG_NR_CPUS=2
+# CONFIG_SCHED_SMT is not set
+# CONFIG_SCHED_MC is not set
-# CONFIG_X86_UP_APIC is not set
+CONFIG_X86_LOCAL_APIC=y
+CONFIG_X86_IO_APIC=y
+# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
+CONFIG_X86_MCE_INTEL=y
+# CONFIG_X86_MCE_AMD is not set
+CONFIG_X86_MCE_THRESHOLD=y
+CONFIG_X86_THERMAL_VECTOR=y
-CONFIG_NEED_PER_CPU_KM=y
+CONFIG_HOTPLUG_CPU=y
+CONFIG_PM_SLEEP_SMP=y
+CONFIG_ACPI_HOTPLUG_CPU=y
-# CONFIG_ARCH_SUPPORTS_MSI is not set
+CONFIG_ARCH_SUPPORTS_MSI=y
+CONFIG_PCI_MSI=y
+# CONFIG_HT_IRQ is not set
+CONFIG_RPS=y
+CONFIG_RFS_ACCEL=y
+CONFIG_XPS=y
+CONFIG_XEN_BLKDEV_BACKEND=m
+# CONFIG_MULTICORE_RAID456 is not set
+CONFIG_XEN_NETDEV_BACKEND=m
-# CONFIG_I2C_ELEKTOR is not set
+CONFIG_XEN_BACKEND=y
+CONFIG_XEN_PCIDEV_BACKEND=m
+CONFIG_IOMMU_API=y
+CONFIG_DMAR_TABLE=y
+CONFIG_INTEL_IOMMU=y
+CONFIG_INTEL_IOMMU_DEFAULT_ON=y
+CONFIG_INTEL_IOMMU_FLOPPY_WA=y
+CONFIG_RCU_CPU_STALL_TIMEOUT=60
+CONFIG_RCU_CPU_STALL_INFO=y
+# CONFIG_DEBUG_PER_CPU_MAPS is not set
+# CONFIG_CPU_NOTIFIER_ERROR_INJECT is not set
+CONFIG_DEBUG_NMI_SELFTEST=y
+# CONFIG_INTEL_TXT is not set
+# CONFIG_CRYPTO_PCRYPT is not set
+CONFIG_CPU_RMAP=y


Regards,
Witek

-- 
Witold Baryluk
