Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111Ab1GQQaS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 12:30:18 -0400
Received: from mail.delivery.mysitehosted.com ([174.122.32.235]:46951 "EHLO
	mail.delivery.mysitehosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755708Ab1GQQaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 12:30:16 -0400
X-Greylist: delayed 5381 seconds by postgrey-1.27 at vger.kernel.org; Sun, 17 Jul 2011 12:30:15 EDT
Date: Sun, 17 Jul 2011 17:00:14 +0200
MIME-Version: 1.0
Message-ID: <b35b8f6b90fad9a4c66d254f4dd2f876@www.piximail.de>
X-Mailer: b1gMail/7.1.0
X-Sender-IP: 109.90.218.104
From: =?ISO-8859-1?B?TWFydGluIFP8Zmtl?= <martinlkml2011@piximail.de>
Subject: Panic while enabling 2nd CPU core after suspend to ram on Intel Atom CPU
Reply-To: =?ISO-8859-1?B?TWFydGluIFP8Zmtl?= <martinlkml2011@piximail.de>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A02020B.4E22F900.0089,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, everybody.

I get the following kernel panic after my system has been sent to "suspend to ram":
The system has an Intel Atom D525 Dual Core CPU with hyperthreading, showing up as 4 cpus in /proc/cpuinfo. After the kernel panic happened, the caps-lock and scroll-lock LED on the keyboard are blinking.

$ ksymoops -m /boot/System.map-3.0.0-rc7min oops_without_timestamps.log
ksymoops 2.4.11 on x86_64 3.0.0-rc7min.  Options used
     -V (default)
     -k /proc/ksyms (default)
     -l /proc/modules (default)
     -o /lib/modules/3.0.0-rc7min/ (default)
     -m /boot/System.map-3.0.0-rc7min (specified)

Error (regular_file): read_ksyms stat /proc/ksyms failed
ksymoops: No such file or directory
No modules in ksyms, skipping objects
No ksyms, skipping lsmod
 CPU 1
 Pid: 0, comm: kworker/0:0 Tainted: G        W   3.0.0-rc7min #14 Gigabyte Technology Co., Ltd. D525TUD/D525TUD
 RIP: 0010:[<ffffffff810088cf>]  [<ffffffff810088cf>] mwait_idle+0xd2/0x159
Using defaults from ksymoops -t elf64-x86-64 -a i386:x86-64
 RSP: 0000:ffff88013f515ef8  EFLAGS: 00010046
 RAX: ffff88013f514010 RBX: ffff88013f515fd8 RCX: 0000000000000000
 RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffffffff818df108
 RBP: ffff88013f515f08 R08: 0000000000000000 R09: 0000000000000000
 R10: 7fffffffffffffff R11: ffffffff8184e4d0 R12: 0000000000000001
 R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 FS:  0000000000000000(0000) GS:ffff88013fc80000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
 CR2: 0000000000000000 CR3: 0000000001803000 CR4: 00000000000006e0
  ffffffff818525a0 ffff88013f514010 ffff88013f515f28 ffffffff81001c88
  0000000000000001 0000000000000000 ffff88013f515f48 ffffffff81411371
  0000000000000000 0000000000000000 0000000000000000 0000000000000000
 Call Trace:
  [<ffffffff81001c88>] cpu_idle+0x5a/0x91
  [<ffffffff81411371>] start_secondary+0x19c/0x1a0
 Code: c2 74 13 65 48 8b 04 25 88 b5 00 00 48 2d d8 1f 00 00 0f ae 78 10 31 d2 65 48 8b 1c 25 88 b5 00 00 48 89 d1 48 8d 83 38 e0 ff ff <0f> 01 c8 0f ae f0 48 8b 83 38 e0 ff ff a8 08 75 08 31 c0 fb 0f


>>RIP; ffffffff810088cf <mwait_idle+d2/159>   <=====

>>RAX; ffff88013f514010 <phys_startup_64+ffff88013e514010/ffffffff80000000>
>>RBX; ffff88013f515fd8 <phys_startup_64+ffff88013e515fd8/ffffffff80000000>
>>RDI; ffffffff818df108 <idle_notifier+8/10>
>>RBP; ffff88013f515f08 <phys_startup_64+ffff88013e515f08/ffffffff80000000>
>>R10; 7fffffffffffffff <phys_startup_64+7ffffffffeffffff/ffffffff80000000>
>>R11; ffffffff8184e4d0 <migration_notifier+0/20>

Trace; ffffffff81001c88 <cpu_idle+5a/91>
Trace; ffffffff81411371 <start_secondary+19c/1a0>

Code;  ffffffff810088a4 <mwait_idle+a7/159>
0000000000000000 <_RIP>:
Code;  ffffffff810088a4 <mwait_idle+a7/159>
   0:   c2 74 13                  retq   $0x1374
Code;  ffffffff810088a7 <mwait_idle+aa/159>
   3:   65 48 8b 04 25 88 b5      mov    %gs:0xb588,%rax
Code;  ffffffff810088ae <mwait_idle+b1/159>
   a:   00 00
Code;  ffffffff810088b0 <mwait_idle+b3/159>
   c:   48 2d d8 1f 00 00         sub    $0x1fd8,%rax
Code;  ffffffff810088b6 <mwait_idle+b9/159>
  12:   0f ae 78 10               clflush 0x10(%rax)
Code;  ffffffff810088ba <mwait_idle+bd/159>
  16:   31 d2                     xor    %edx,%edx
Code;  ffffffff810088bc <mwait_idle+bf/159>
  18:   65 48 8b 1c 25 88 b5      mov    %gs:0xb588,%rbx
Code;  ffffffff810088c3 <mwait_idle+c6/159>
  1f:   00 00
Code;  ffffffff810088c5 <mwait_idle+c8/159>
  21:   48 89 d1                  mov    %rdx,%rcx
Code;  ffffffff810088c8 <mwait_idle+cb/159>
  24:   48 8d 83 38 e0 ff ff      lea    -0x1fc8(%rbx),%rax
Code;  ffffffff810088cf <mwait_idle+d2/159>   <=====
  2b:   0f 01 c8                  monitor %rax,%rcx,%rdx   <=====
Code;  ffffffff810088d2 <mwait_idle+d5/159>
  2e:   0f ae f0                  mfence
Code;  ffffffff810088d5 <mwait_idle+d8/159>
  31:   48 8b 83 38 e0 ff ff      mov    -0x1fc8(%rbx),%rax
Code;  ffffffff810088dc <mwait_idle+df/159>
  38:   a8 08                     test   $0x8,%al
Code;  ffffffff810088de <mwait_idle+e1/159>
  3a:   75 08                     jne    44 <_RIP+0x44>
Code;  ffffffff810088e0 <mwait_idle+e3/159>
  3c:   31 c0                     xor    %eax,%eax
Code;  ffffffff810088e2 <mwait_idle+e5/159>
  3e:   fb                        sti
Code;  ffffffff810088e3 <mwait_idle+e6/159>
  3f:

 Kernel panic - not syncing: Attempted to kill the idle task!
 Pid: 0, comm: kworker/0:0 Tainted: G      D W   3.0.0-rc7min #14
 Call Trace:
  [<ffffffff81414bc4>] panic+0x8c/0x199
  [<ffffffff810343d5>] do_exit+0xab/0x737
  [<ffffffff8103137a>] ? kmsg_dump+0x44/0xe3
  [<ffffffff81004fe4>] oops_end+0xb1/0xb9
  [<ffffffff810050d2>] die+0x55/0x5e
  [<ffffffff81002bce>] do_trap+0x11c/0x12b
  [<ffffffff81002f4e>] do_invalid_op+0x91/0x9a
  [<ffffffff810088cf>] ? mwait_idle+0xd2/0x159
  [<ffffffff81016a71>] ? __setup_APIC_LVTT+0x67/0x88
  [<ffffffff81052939>] ? ktime_get+0x5f/0xb5
  [<ffffffff81016aaa>] ? lapic_next_event+0x18/0x1c
  [<ffffffff81056a4a>] ? clockevents_program_event+0x75/0x7e
  [<ffffffff81056d77>] ? tick_setup_periodic+0x6f/0x81
  [<ffffffff814186d5>] invalid_op+0x15/0x20
  [<ffffffff810088cf>] ? mwait_idle+0xd2/0x159
  [<ffffffff8104f5dc>] ? atomic_notifier_call_chain+0x13/0x15
  [<ffffffff81001c88>] cpu_idle+0x5a/0x91
  [<ffffffff81411371>] start_secondary+0x19c/0x1a0
Warning (Oops_read): Code line not seen, dumping what data is available


Trace; ffffffff81414bc4 <panic+8c/199>
Trace; ffffffff810343d5 <do_exit+ab/737>
Trace; ffffffff8103137a <kmsg_dump+44/e3>
Trace; ffffffff81004fe4 <oops_end+b1/b9>
Trace; ffffffff810050d2 <die+55/5e>
Trace; ffffffff81002bce <do_trap+11c/12b>
Trace; ffffffff81002f4e <do_invalid_op+91/9a>
Trace; ffffffff810088cf <mwait_idle+d2/159>
Trace; ffffffff81016a71 <__setup_APIC_LVTT+67/88>
Trace; ffffffff81052939 <ktime_get+5f/b5>
Trace; ffffffff81016aaa <lapic_next_event+18/1c>
Trace; ffffffff81056a4a <clockevents_program_event+75/7e>
Trace; ffffffff81056d77 <tick_setup_periodic+6f/81>
Trace; ffffffff814186d5 <invalid_op+15/20>
Trace; ffffffff810088cf <mwait_idle+d2/159>
Trace; ffffffff8104f5dc <atomic_notifier_call_chain+13/15>
Trace; ffffffff81001c88 <cpu_idle+5a/91>
Trace; ffffffff81411371 <start_secondary+19c/1a0>
1 warning and 1 error issued.  Results may not be reliable.

To get there, I do the following:
1) disable cpu1 and cpu2 (both on cpu core 1 if I got it right) with:
$ echo 0 > /sys/devices/system/cpu/cpu1/online
$ echo 0 > /sys/devices/system/cpu/cpu2/online
this leaves me with cpu0 and cpu3 which are both hyperthreads on

2) suspend to ram, then resume the system
$ echo mem > /sys/power/state
(system goes into suspend, resumable by pressing the power button)

2a) During supend, a warning is issuted. My guess is that the harddisk is simply slow to spin up. Is that guess right ?
$ dmesg
[  104.092215] PM: Syncing filesystems ... done.
[  104.096763] PM: Preparing system for mem sleep
[  104.104047] Freezing user space processes ... (elapsed 0.01 seconds) done.
[  104.121723] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[  104.139774] PM: Entering mem sleep
[  104.143700] sd 1:0:0:0: [sdb] Synchronizing SCSI cache
[  104.143721] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  104.143878] sd 0:0:0:0: [sda] Stopping disk
[  104.158499] sd 1:0:0:0: [sdb] Stopping disk
[  104.169431] serial 00:08: disabled
[  104.172946] serial 00:08: wake-up capability disabled by ACPI
[  108.652030] serial 00:08: activated
[  108.963044] ata6: SATA link down (SStatus 0 SControl 300)
[  108.968599] ata5: SATA link down (SStatus 0 SControl 300)
[  110.156028] ata1: link is slow to respond, please be patient (ready=0)
[  110.162673] ata2: link is slow to respond, please be patient (ready=0)
[  113.943040] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  113.951711] ata2.00: configured for UDMA/133
[  114.803024] ata1: COMRESET failed (errno=-16)
[  117.050031] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  117.086293] ata1.00: configured for UDMA/133
[  117.100984] PM: resume of devices complete after 12306.735 msecs
[  117.107275] PM: resume devices took 12.313 seconds
[  117.112177] ------------[ cut here ]------------
[  117.116910] WARNING: at kernel/power/suspend_test.c:53 suspend_test_finish+0x7b/0x84()
[  117.125009] Hardware name: D525TUD
[  117.128511] Component: resume devices, time: 12313
[  117.133414] Pid: 3612, comm: echo Not tainted 3.0.0-rc7min #14
[  117.139352] Call Trace:
[  117.141905]  [<ffffffff81030f02>] warn_slowpath_common+0x7b/0x93
[  117.148024]  [<ffffffff81030fae>] warn_slowpath_fmt+0x41/0x43
[  117.153882]  [<ffffffff8105dabb>] suspend_test_finish+0x7b/0x84
[  117.159918]  [<ffffffff8105d853>] suspend_devices_and_enter+0x1d9/0x236
[  117.166642]  [<ffffffff8105d98f>] enter_state+0xdf/0x135
[  117.172062]  [<ffffffff8105d062>] state_store+0xb1/0xce
[  117.177403]  [<ffffffff81210ee3>] kobj_attr_store+0x17/0x19
[  117.183088]  [<ffffffff81113a97>] sysfs_write_file+0xef/0x12b
[  117.188947]  [<ffffffff810c5687>] vfs_write+0xae/0x153
[  117.194196]  [<ffffffff810c57e5>] sys_write+0x45/0x6c
[  117.199362]  [<ffffffff81417afb>] system_call_fastpath+0x16/0x1b
[  117.205481] ---[ end trace 27f1f84a48a28b3a ]---
[  117.210220] PM: Finishing wakeup.
[  117.213636] Restarting tasks ... done.

3) Now enabling the cpu1 or cpu2 (on core 1) leads to the panic:
$ echo 1 > /sys/devices/system/cpu/cpu1/online
[  162.550537] Booting Node 0 Processor 1 APIC 0x2
[  162.555190] smpboot cpu 1: start_ip = 9a000
[   28.795663] Disabled fast string operations
[  162.638260] invalid opcode: 0000 [#1] SMP
[  162.638260] CPU 1
[  162.638260] Pid: 0, comm: kworker/0:0 Tainted: G        W   3.0.0-rc7min #14 Gigabyte Technology Co., Ltd. D525TUD/D525TUD
... this is the oops which is at the beginnin ot the message ...

Attached: kernel .config, cpuinfo, content of /sys/power/* and content of /sys/devices/system/cpu/*

More info:
enabling and disabling cpu1, cpu2 and/or cpu3 in any combination or sequence works without errror if the system had not been suspended to ram before.
Suspend to disk works, also works if all cpus are enabled
Testing suspend to ram with /sys/power/pm_test works with all tests, including "core" even if all cpus are enabled
suspend to ram does not work with all cpus enabled, the system will only show the VGA BIOS greeting message and blinking keyboard leds.

If CONFIG_INTEL_IDLE is set in kernel config, the oops trace will include "intel_idle" instead of "mwait_idle" but not differ much otherwise. I can provide an oops trace with intel_idle if it helps.

I have tested kernels 2.6.35.10 2.6.36.2 2.6.37-rc6 2.6.39-git all with the same problem half a year ago.
Back then, the system had BIOS revision F3, this got upgraded to F4 for the tests with the 3.0.0-rc7 kernel.

Earlier, I had tried posting the problem to the linux-pm mailing list
 https://lists.linux-foundation.org/pipermail/linux-pm/2010-December/029654.html
 https://lists.linux-foundation.org/pipermail/linux-pm/2010-December/029655.html
 https://lists.linux-foundation.org/pipermail/linux-pm/2010-December/029656.html
However, I got the only answer I got was to try it on the LKML

Any help is appreciated.

I am NOT on the LKML, so please CC me in replies.
-Martin

------------------   Kernel config -------------
CONFIG_64BIT=y
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_HAVE_CPUMASK_OF_CPU_MAP=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ZONE_DMA32=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
CONFIG_ARCH_CPU_PROBE_RELEASE=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_HAVE_IRQ_WORK=y
CONFIG_IRQ_WORK=y
CONFIG_EXPERIMENTAL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_LOCALVERSION="min"
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
CONFIG_KERNEL_GZIP=y
CONFIG_DEFAULT_HOSTNAME="behemoth"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_FHANDLE=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_WATCH=y
CONFIG_AUDIT_TREE=y
CONFIG_HAVE_GENERIC_HARDIRQS=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_HAVE_SPARSE_IRQ=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_TREE_RCU=y
CONFIG_RCU_FANOUT=32
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=20
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_RELAY=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
CONFIG_RD_BZIP2=y
CONFIG_RD_LZMA=y
CONFIG_RD_XZ=y
CONFIG_RD_LZO=y
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_HAVE_PERF_EVENTS=y
CONFIG_PERF_EVENTS=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLAB=y
CONFIG_TRACEPOINTS=y
CONFIG_HAVE_OPROFILE=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
CONFIG_DEFAULT_CFQ=y
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_INLINE_SPIN_UNLOCK=y
CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
CONFIG_INLINE_READ_UNLOCK=y
CONFIG_INLINE_READ_UNLOCK_IRQ=y
CONFIG_INLINE_WRITE_UNLOCK=y
CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
CONFIG_MUTEX_SPIN_ON_OWNER=y
CONFIG_FREEZER=y
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
CONFIG_SCHED_OMIT_FRAME_POINTER=y
CONFIG_NO_BOOTMEM=y
CONFIG_MATOM=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_CMPXCHG=y
CONFIG_CMPXCHG_LOCAL=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_NR_CPUS=4
CONFIG_SCHED_MC=y
CONFIG_PREEMPT_NONE=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
CONFIG_SPARSEMEM_VMEMMAP=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_CLEANCACHE=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_SECCOMP=y
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_HOTPLUG_CPU=y
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_ARCH_HIBERNATION_HEADER=y
CONFIG_SUSPEND=y
CONFIG_SUSPEND_FREEZER=y
CONFIG_HIBERNATE_CALLBACKS=y
CONFIG_HIBERNATION=y
CONFIG_PM_STD_PARTITION=""
CONFIG_PM_SLEEP=y
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
CONFIG_PM_ADVANCED_DEBUG=y
CONFIG_PM_TEST_SUSPEND=y
CONFIG_CAN_PM_TRACE=y
CONFIG_PM_TRACE=y
CONFIG_PM_TRACE_RTC=y
CONFIG_ACPI=y
CONFIG_ACPI_SLEEP=y
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_PROCESSOR_AGGREGATOR=y
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_BLACKLIST_YEAR=0
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_CUSTOM_METHOD=y
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
CONFIG_PCIEAER=y
CONFIG_PCIEASPM=y
CONFIG_PCIE_PME=y
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
CONFIG_HT_IRQ=y
CONFIG_PCI_IOAPIC=y
CONFIG_PCI_LABEL=y
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
CONFIG_BINFMT_ELF=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_BINFMT_MISC=y
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_NET=y
CONFIG_PACKET=y
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=y
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
CONFIG_IP_PNP_BOOTP=y
CONFIG_IP_PNP_RARP=y
CONFIG_IP_MROUTE=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
CONFIG_SYN_COOKIES=y
CONFIG_INET_TUNNEL=y
CONFIG_INET_LRO=y
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=y
CONFIG_INET6_AH=y
CONFIG_INET6_ESP=y
CONFIG_INET6_XFRM_MODE_TRANSPORT=y
CONFIG_INET6_XFRM_MODE_TUNNEL=y
CONFIG_INET6_XFRM_MODE_BEET=y
CONFIG_IPV6_SIT=y
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_NETWORK_SECMARK=y
CONFIG_NETFILTER=y
CONFIG_NETFILTER_NETLINK=y
CONFIG_NETFILTER_NETLINK_LOG=y
CONFIG_NF_CONNTRACK=y
CONFIG_NF_CONNTRACK_SECMARK=y
CONFIG_NF_CONNTRACK_FTP=y
CONFIG_NF_CONNTRACK_IRC=y
CONFIG_NF_CONNTRACK_SIP=y
CONFIG_NF_CT_NETLINK=y
CONFIG_NETFILTER_XTABLES=y
CONFIG_NETFILTER_XT_MARK=y
CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=y
CONFIG_NETFILTER_XT_TARGET_NFLOG=y
CONFIG_NETFILTER_XT_TARGET_SECMARK=y
CONFIG_NETFILTER_XT_TARGET_TCPMSS=y
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=y
CONFIG_NETFILTER_XT_MATCH_POLICY=y
CONFIG_NETFILTER_XT_MATCH_STATE=y
CONFIG_NF_DEFRAG_IPV4=y
CONFIG_NF_CONNTRACK_IPV4=y
CONFIG_NF_CONNTRACK_PROC_COMPAT=y
CONFIG_IP_NF_IPTABLES=y
CONFIG_IP_NF_FILTER=y
CONFIG_IP_NF_TARGET_REJECT=y
CONFIG_IP_NF_TARGET_LOG=y
CONFIG_IP_NF_TARGET_ULOG=y
CONFIG_NF_NAT=y
CONFIG_NF_NAT_NEEDED=y
CONFIG_IP_NF_TARGET_MASQUERADE=y
CONFIG_NF_NAT_FTP=y
CONFIG_NF_NAT_IRC=y
CONFIG_NF_NAT_SIP=y
CONFIG_IP_NF_MANGLE=y
CONFIG_NF_DEFRAG_IPV6=y
CONFIG_NF_CONNTRACK_IPV6=y
CONFIG_IP6_NF_IPTABLES=y
CONFIG_IP6_NF_MATCH_IPV6HEADER=y
CONFIG_IP6_NF_TARGET_LOG=y
CONFIG_IP6_NF_FILTER=y
CONFIG_IP6_NF_TARGET_REJECT=y
CONFIG_IP6_NF_MANGLE=y
CONFIG_IP_SCTP=y
CONFIG_SCTP_HMAC_MD5=y
CONFIG_NET_SCHED=y
CONFIG_NET_CLS=y
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_CLS_ACT=y
CONFIG_NET_SCH_FIFO=y
CONFIG_DNS_RESOLVER=y
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
CONFIG_HAVE_BPF_JIT=y
CONFIG_FIB_RULES=y
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_NBD=y
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=16384
CONFIG_HAVE_IDE=y
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_PROC_FS=y
CONFIG_BLK_DEV_SD=y
CONFIG_ATA=y
CONFIG_ATA_VERBOSE_ERROR=y
CONFIG_ATA_ACPI=y
CONFIG_SATA_AHCI=y
CONFIG_ATA_SFF=y
CONFIG_ATA_BMDMA=y
CONFIG_PATA_JMICRON=y
CONFIG_ATA_GENERIC=y
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_AUTODETECT=y
CONFIG_MD_RAID0=y
CONFIG_MD_RAID1=y
CONFIG_BLK_DEV_DM=y
CONFIG_DM_SNAPSHOT=y
CONFIG_DM_MIRROR=y
CONFIG_NETDEVICES=y
CONFIG_MII=y
CONFIG_NETDEV_1000=y
CONFIG_R8169=y
CONFIG_NETCONSOLE=y
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_SPARSEKMAP=y
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_EVDEV=y
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_INPUT_JOYSTICK=y
CONFIG_INPUT_TABLET=y
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_INPUT_MISC=y
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
CONFIG_UNIX98_PTYS=y
CONFIG_SERIAL_NONSTANDARD=y
CONFIG_DEVKMEM=y
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_NR_UARTS=32
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
CONFIG_SERIAL_8250_DETECT_IRQ=y
CONFIG_SERIAL_8250_RSA=y
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_INTEL=y
CONFIG_HW_RANDOM_AMD=y
CONFIG_HW_RANDOM_VIA=y
CONFIG_NVRAM=y
CONFIG_HPET=y
CONFIG_HANGCHECK_TIMER=y
CONFIG_DEVPORT=y
CONFIG_RAMOOPS=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_I801=y
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_HWMON=y
CONFIG_THERMAL=y
CONFIG_SSB_POSSIBLE=y
CONFIG_BCMA_POSSIBLE=y
CONFIG_AGP=y
CONFIG_AGP_INTEL=y
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
CONFIG_DRM=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_DUMMY_CONSOLE=y
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
CONFIG_RTC_DRV_CMOS=y
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
CONFIG_EXT2_FS_XIP=y
CONFIG_EXT3_FS=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=y
CONFIG_EXT4_FS_XATTR=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
CONFIG_FS_XIP=y
CONFIG_JBD=y
CONFIG_JBD2=y
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
CONFIG_REISERFS_PROC_INFO=y
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
CONFIG_REISERFS_FS_SECURITY=y
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y
CONFIG_GENERIC_ACL=y
CONFIG_FSCACHE=y
CONFIG_FSCACHE_STATS=y
CONFIG_FSCACHE_HISTOGRAM=y
CONFIG_CACHEFILES=y
CONFIG_CACHEFILES_HISTOGRAM=y
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=850
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-15"
CONFIG_NTFS_FS=y
CONFIG_NTFS_RW=y
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
CONFIG_CONFIGFS_FS=y
CONFIG_PARTITION_ADVANCED=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
CONFIG_LDM_PARTITION=y
CONFIG_SUN_PARTITION=y
CONFIG_EFI_PARTITION=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
CONFIG_NLS_ISO8859_15=y
CONFIG_NLS_UTF8=y
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=7
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
CONFIG_DEBUG_FS=y
CONFIG_DEBUG_KERNEL=y
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=0
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_STACKTRACE=y
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
CONFIG_DEBUG_INFO_REDUCED=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_BOOT_PRINTK_DELAY=y
CONFIG_RCU_CPU_STALL_TIMEOUT=60
CONFIG_LKDTM=y
CONFIG_CPU_NOTIFIER_ERROR_INJECT=y
CONFIG_SYSCTL_SYSCALL_CHECK=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_EVENT_POWER_TRACING_DEPRECATED=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_BRANCH_PROFILE_NONE=y
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_DEBUG_RODATA=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
CONFIG_DEFAULT_IO_DELAY_TYPE=0
CONFIG_KEYS=y
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_CRYPTO=y
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_DES=y
CONFIG_HAVE_KVM=y
CONFIG_BINARY_PRINTF=y
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_CRC16=y
CONFIG_CRC32=y
CONFIG_LIBCRC32C=y
CONFIG_ZLIB_INFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
CONFIG_XZ_DEC_POWERPC=y
CONFIG_XZ_DEC_IA64=y
CONFIG_XZ_DEC_ARM=y
CONFIG_XZ_DEC_ARMTHUMB=y
CONFIG_XZ_DEC_SPARC=y
CONFIG_XZ_DEC_BCJ=y
CONFIG_DECOMPRESS_GZIP=y
CONFIG_DECOMPRESS_BZIP2=y
CONFIG_DECOMPRESS_LZMA=y
CONFIG_DECOMPRESS_XZ=y
CONFIG_DECOMPRESS_LZO=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPU_RMAP=y
CONFIG_NLATTR=y
----------------

------ contents of /sys/devices/system/cpu/* after cpu 1 and cpu2 have been turned off -----------
$ grep -r . /sys/devices/system/cpu/
grep: /sys/devices/system/cpu/probe: Permission denied
grep: /sys/devices/system/cpu/release: Permission denied
/sys/devices/system/cpu/online:0,3
/sys/devices/system/cpu/possible:0-3
/sys/devices/system/cpu/present:0-3
/sys/devices/system/cpu/kernel_max:3
/sys/devices/system/cpu/offline:1-2
/sys/devices/system/cpu/cpuidle/current_driver:intel_idle
/sys/devices/system/cpu/cpuidle/current_governor_ro:menu
/sys/devices/system/cpu/cpu0/crash_notes:13fc14a10
/sys/devices/system/cpu/cpu0/cache/index0/type:Data
/sys/devices/system/cpu/cpu0/cache/index0/level:1
/sys/devices/system/cpu/cpu0/cache/index0/coherency_line_size:64
/sys/devices/system/cpu/cpu0/cache/index0/physical_line_partition:1
/sys/devices/system/cpu/cpu0/cache/index0/ways_of_associativity:6
/sys/devices/system/cpu/cpu0/cache/index0/number_of_sets:64
/sys/devices/system/cpu/cpu0/cache/index0/size:24K
/sys/devices/system/cpu/cpu0/cache/index0/shared_cpu_map:9
/sys/devices/system/cpu/cpu0/cache/index0/shared_cpu_list:0,3
/sys/devices/system/cpu/cpu0/cache/index1/type:Instruction
/sys/devices/system/cpu/cpu0/cache/index1/level:1
/sys/devices/system/cpu/cpu0/cache/index1/coherency_line_size:64
/sys/devices/system/cpu/cpu0/cache/index1/physical_line_partition:1
/sys/devices/system/cpu/cpu0/cache/index1/ways_of_associativity:8
/sys/devices/system/cpu/cpu0/cache/index1/number_of_sets:64
/sys/devices/system/cpu/cpu0/cache/index1/size:32K
/sys/devices/system/cpu/cpu0/cache/index1/shared_cpu_map:9
/sys/devices/system/cpu/cpu0/cache/index1/shared_cpu_list:0,3
/sys/devices/system/cpu/cpu0/cache/index2/type:Unified
/sys/devices/system/cpu/cpu0/cache/index2/level:2
/sys/devices/system/cpu/cpu0/cache/index2/coherency_line_size:64
/sys/devices/system/cpu/cpu0/cache/index2/physical_line_partition:1
/sys/devices/system/cpu/cpu0/cache/index2/ways_of_associativity:8
/sys/devices/system/cpu/cpu0/cache/index2/number_of_sets:1024
/sys/devices/system/cpu/cpu0/cache/index2/size:512K
/sys/devices/system/cpu/cpu0/cache/index2/shared_cpu_map:9
/sys/devices/system/cpu/cpu0/cache/index2/shared_cpu_list:0,3
/sys/devices/system/cpu/cpu0/thermal_throttle/core_throttle_count:0
grep: /sys/devices/system/cpu/cpu0/microcode/reload: Permission denied
/sys/devices/system/cpu/cpu0/microcode/version:0x107
/sys/devices/system/cpu/cpu0/microcode/processor_flags:0x8
/sys/devices/system/cpu/cpu0/cpuidle/state0/name:POLL
/sys/devices/system/cpu/cpu0/cpuidle/state0/desc:CPUIDLE CORE POLL IDLE
/sys/devices/system/cpu/cpu0/cpuidle/state0/latency:0
/sys/devices/system/cpu/cpu0/cpuidle/state0/power:4294967295
/sys/devices/system/cpu/cpu0/cpuidle/state0/usage:8
/sys/devices/system/cpu/cpu0/cpuidle/state0/time:1838938
/sys/devices/system/cpu/cpu0/cpuidle/state1/name:C1-ATM
/sys/devices/system/cpu/cpu0/cpuidle/state1/desc:MWAIT 0x00
/sys/devices/system/cpu/cpu0/cpuidle/state1/latency:1
/sys/devices/system/cpu/cpu0/cpuidle/state1/power:4294967294
/sys/devices/system/cpu/cpu0/cpuidle/state1/usage:15944
/sys/devices/system/cpu/cpu0/cpuidle/state1/time:167329609
/sys/devices/system/cpu/cpu0/topology/physical_package_id:0
/sys/devices/system/cpu/cpu0/topology/core_id:0
/sys/devices/system/cpu/cpu0/topology/thread_siblings:9
/sys/devices/system/cpu/cpu0/topology/thread_siblings_list:0,3
/sys/devices/system/cpu/cpu0/topology/core_siblings:9
/sys/devices/system/cpu/cpu0/topology/core_siblings_list:0,3
/sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_min_freq:225000
/sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq:1800000
/sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_transition_latency:10000001
/sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq:225000
/sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq:1800000
/sys/devices/system/cpu/cpu0/cpufreq/affected_cpus:0 3
/sys/devices/system/cpu/cpu0/cpufreq/related_cpus:0 3
/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor:userspace
/sys/devices/system/cpu/cpu0/cpufreq/scaling_driver:p4-clockmod
/sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors:ondemand userspace performance
/sys/devices/system/cpu/cpu0/cpufreq/scaling_setspeed:1800000
/sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies:225000 450000 675000 900000 1125000 1350000 1575000 1800000
/sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_cur_freq:1800000
/sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq:1800000
/sys/devices/system/cpu/cpu1/online:0
/sys/devices/system/cpu/cpu1/crash_notes:13fc94a10
/sys/devices/system/cpu/cpu1/cpuidle/state0/name:POLL
/sys/devices/system/cpu/cpu1/cpuidle/state0/desc:CPUIDLE CORE POLL IDLE
/sys/devices/system/cpu/cpu1/cpuidle/state0/latency:0
/sys/devices/system/cpu/cpu1/cpuidle/state0/power:4294967295
/sys/devices/system/cpu/cpu1/cpuidle/state0/usage:10
/sys/devices/system/cpu/cpu1/cpuidle/state0/time:3742
/sys/devices/system/cpu/cpu1/cpuidle/state1/name:C1-ATM
/sys/devices/system/cpu/cpu1/cpuidle/state1/desc:MWAIT 0x00
/sys/devices/system/cpu/cpu1/cpuidle/state1/latency:1
/sys/devices/system/cpu/cpu1/cpuidle/state1/power:4294967294
/sys/devices/system/cpu/cpu1/cpuidle/state1/usage:3388
/sys/devices/system/cpu/cpu1/cpuidle/state1/time:24732806
/sys/devices/system/cpu/cpu2/online:0
/sys/devices/system/cpu/cpu2/crash_notes:13fd14a10
/sys/devices/system/cpu/cpu2/cpuidle/state0/name:POLL
/sys/devices/system/cpu/cpu2/cpuidle/state0/desc:CPUIDLE CORE POLL IDLE
/sys/devices/system/cpu/cpu2/cpuidle/state0/latency:0
/sys/devices/system/cpu/cpu2/cpuidle/state0/power:4294967295
/sys/devices/system/cpu/cpu2/cpuidle/state0/usage:12
/sys/devices/system/cpu/cpu2/cpuidle/state0/time:855620
/sys/devices/system/cpu/cpu2/cpuidle/state1/name:C1-ATM
/sys/devices/system/cpu/cpu2/cpuidle/state1/desc:MWAIT 0x00
/sys/devices/system/cpu/cpu2/cpuidle/state1/latency:1
/sys/devices/system/cpu/cpu2/cpuidle/state1/power:4294967294
/sys/devices/system/cpu/cpu2/cpuidle/state1/usage:4455
/sys/devices/system/cpu/cpu2/cpuidle/state1/time:27807198
/sys/devices/system/cpu/cpu3/online:1
/sys/devices/system/cpu/cpu3/crash_notes:13fd94a10
/sys/devices/system/cpu/cpu3/thermal_throttle/core_throttle_count:0
/sys/devices/system/cpu/cpu3/topology/physical_package_id:0
/sys/devices/system/cpu/cpu3/topology/core_id:0
/sys/devices/system/cpu/cpu3/topology/thread_siblings:9
/sys/devices/system/cpu/cpu3/topology/thread_siblings_list:0,3
/sys/devices/system/cpu/cpu3/topology/core_siblings:9
/sys/devices/system/cpu/cpu3/topology/core_siblings_list:0,3
/sys/devices/system/cpu/cpu3/cache/index0/type:Data
/sys/devices/system/cpu/cpu3/cache/index0/level:1
/sys/devices/system/cpu/cpu3/cache/index0/coherency_line_size:64
/sys/devices/system/cpu/cpu3/cache/index0/physical_line_partition:1
/sys/devices/system/cpu/cpu3/cache/index0/ways_of_associativity:6
/sys/devices/system/cpu/cpu3/cache/index0/number_of_sets:64
/sys/devices/system/cpu/cpu3/cache/index0/size:24K
/sys/devices/system/cpu/cpu3/cache/index0/shared_cpu_map:9
/sys/devices/system/cpu/cpu3/cache/index0/shared_cpu_list:0,3
/sys/devices/system/cpu/cpu3/cache/index1/type:Instruction
/sys/devices/system/cpu/cpu3/cache/index1/level:1
/sys/devices/system/cpu/cpu3/cache/index1/coherency_line_size:64
/sys/devices/system/cpu/cpu3/cache/index1/physical_line_partition:1
/sys/devices/system/cpu/cpu3/cache/index1/ways_of_associativity:8
/sys/devices/system/cpu/cpu3/cache/index1/number_of_sets:64
/sys/devices/system/cpu/cpu3/cache/index1/size:32K
/sys/devices/system/cpu/cpu3/cache/index1/shared_cpu_map:9
/sys/devices/system/cpu/cpu3/cache/index1/shared_cpu_list:0,3
/sys/devices/system/cpu/cpu3/cache/index2/type:Unified
/sys/devices/system/cpu/cpu3/cache/index2/level:2
/sys/devices/system/cpu/cpu3/cache/index2/coherency_line_size:64
/sys/devices/system/cpu/cpu3/cache/index2/physical_line_partition:1
/sys/devices/system/cpu/cpu3/cache/index2/ways_of_associativity:8
/sys/devices/system/cpu/cpu3/cache/index2/number_of_sets:1024
/sys/devices/system/cpu/cpu3/cache/index2/size:512K
/sys/devices/system/cpu/cpu3/cache/index2/shared_cpu_map:9
/sys/devices/system/cpu/cpu3/cache/index2/shared_cpu_list:0,3
grep: /sys/devices/system/cpu/cpu3/microcode/reload: Permission denied
/sys/devices/system/cpu/cpu3/microcode/version:0x107
/sys/devices/system/cpu/cpu3/microcode/processor_flags:0x8
/sys/devices/system/cpu/cpu3/cpuidle/state0/name:POLL
/sys/devices/system/cpu/cpu3/cpuidle/state0/desc:CPUIDLE CORE POLL IDLE
/sys/devices/system/cpu/cpu3/cpuidle/state0/latency:0
/sys/devices/system/cpu/cpu3/cpuidle/state0/power:4294967295
/sys/devices/system/cpu/cpu3/cpuidle/state0/usage:21
/sys/devices/system/cpu/cpu3/cpuidle/state0/time:2055565
/sys/devices/system/cpu/cpu3/cpuidle/state1/name:C1-ATM
/sys/devices/system/cpu/cpu3/cpuidle/state1/desc:MWAIT 0x00
/sys/devices/system/cpu/cpu3/cpuidle/state1/latency:1
/sys/devices/system/cpu/cpu3/cpuidle/state1/power:4294967294
/sys/devices/system/cpu/cpu3/cpuidle/state1/usage:13834
/sys/devices/system/cpu/cpu3/cpuidle/state1/time:166939905
---------------------

------------------------------ contents of /sys/power/* -----------------
$ grep -r . /sys/power/
/sys/power/state:mem disk
/sys/power/pm_trace:0
/sys/power/pm_async:1
/sys/power/wakeup_count:0
/sys/power/pm_test:[none] core processors platform devices freezer
/sys/power/disk:[platform] test testproc shutdown reboot
/sys/power/resume:8:2
/sys/power/image_size:1628569600
/sys/power/reserved_size:1048576
--------------------------------------------------------------------


______________________________________________________
PixiMail - The secret Freedom
