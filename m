Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800Ab1ARXEK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 18:04:10 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:65084 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564Ab1ARXEI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 18:04:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:in-reply-to:references:user-agent:date
         :message-id:mime-version:content-type:content-transfer-encoding;
        b=H0lxQzjpAGn4cApSBL6N2zGMUFYv5ykM2PQXgF7OFLUrh3ZXSDIgnX1EOMRhZNIaD2
         miPxPX4mej0PwJgejHUVEwBYyN8gWzTD0ceHn2JkEXbpD9pSiYiiwqOCAWhtdvokDvtx
         LMQVngwSEwurn98UqTiIL7XPelAM5Br2db0Bk=
From: Dmitry <dmonakhov@openvz.org>
To: John Tyree <johntyree@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
        Jiaying Zhang <jiayingz@google.com>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: Disk continually remounts and hardlocks the entire system if running on battery.
In-Reply-To: <AANLkTinCOrSBrLKxZfYw3HYNS=t8y8XqLxMXrjMWr1vb@mail.gmail.com>
References: <AANLkTi=_GSgFpsidp35-RDT3i6zhimXtyR=d6UtFmfMe@mail.gmail.com> <87ipxlj1vd.fsf@dmon-lp.sw.ru> <AANLkTinCOrSBrLKxZfYw3HYNS=t8y8XqLxMXrjMWr1vb@mail.gmail.com>
User-Agent: Notmuch/0.3.1-58-g6607fd6 (http://notmuchmail.org) Emacs/23.1.1 (i486-pc-linux-gnu)
Date: Wed, 19 Jan 2011 02:04:03 +0300
Message-ID: <87fwspizks.fsf@dmon-lp.sw.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Jan 2011 23:29:17 +0100, John Tyree <johntyree@gmail.com> wrote:
> That was my first panicked thought also. But why is it that it only happens
> using the most recent kernel? If I reboot right now and load 2.6.36.2, it
> will work flawlessly. No errors of any kind. No data problems. No
> complaints. Further, why would disk failure symptoms be tied to the ac power
> plug? I Googled the message and many others are reporting having this
> problem, do we all have dead drives?
Ok, my second guest that it looks like PM issue, what happens if you
move you disk to USB case with external power supply, i do understand
that may be a bit fancy test, but this can help us to localize whether
this is really a PM issue. What happens if you use a SSD drive (it has
different power consumption characteristics. May be it may be useful to
collect an power consumption statistics w and w/o battery.
And off-course it is better to ask for advise from PM gurus  
> 
> John
> 
> 2011/1/18 Dmitry <dmonakhov@openvz.org>
> 
> > On Tue, 18 Jan t2011 22:46:34 +0100, John Tyree <johntyree@gmail.com>
> > wrote:
> > > [1.] Disk continually remounts and hardlocks the entire system if running
> > on
> > > battery.
> > >
> > > [2.] When I unplug the power cord from laptop, the harddrive immediately
> > > stops spinning and nothing happens for up to ten seconds or more. During
> > > this
> > > time, absolutely nothing works except the mouse moving around in X.
> > > Applications do not redraw their guis, Can't launch anything or close
> > > anything. Just have to wait until it remounts and I hear the drive spin
> > up.
> > > At that time, everything snaps back to life as if nothing has happened.
> > >
> > > dmesg shows the following:
> > oh, just look at ata errors, definitely this is not fs's problem,
> > it's looks like your disk is dieing, Your options:
> > 1) plug/unplug sata cable :), in my experience this is the root of cause
> >   in 50% of cases.
> > 2) smart ctl logs
> > >
> > > [28687.441335] ata1.00: configured for UDMA/33
> > > [28687.441345] ata1: EH complete
> > > [28687.443153] sd 0:0:0:0: [sda] Write cache: disabled, read cache:
> > enabled,
> > > doesn't support DPO or FUA
> > > [28688.563053] EXT4-fs (sda5): re-mounted. Opts: commit=600
> > > [28688.570501] EXT4-fs (dm-0): re-mounted. Opts: commit=600
> > > [28727.760100] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x110000 action
> > > 0x6 frozen
> > > [28727.760115] ata1: SError: { PHYRdyChg Dispar }
> > > [28727.760126] ata1.00: failed command: WRITE DMA EXT
> > > [28727.760144] ata1.00: cmd 35/00:08:5d:8b:e1/00:00:17:00:00/e0 tag 0 dma
> > > 4096 out
> > > [28727.760148]          res 40/00:f4:00:00:00/00:00:00:00:00/40 Emask 0x4
> > > (timeout)
> > > [28727.760156] ata1.00: status: { DRDY }
> > > [28727.760170] ata1: hard resetting link
> > > [28728.066096] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
> > > [28728.067819] ata1.00: configured for UDMA/33
> > > [28728.068309] ata1.00: device reported invalid CHS sector 0
> > > [28728.068337] ata1: EH complete
> > > [28730.395512] ata1.00: configured for UDMA/33
> > > [28730.395520] ata1: EH complete
> > > [28730.430938] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
> > enabled,
> > > doesn't support DPO or FUA
> > > [28730.953631] EXT4-fs (sda5): re-mounted. Opts: commit=0
> > > [28730.958914] EXT4-fs (dm-0): re-mounted. Opts: commit=0
> > >
> > > This happens everytime the power is unplugged and continutes to happen,
> > with
> > > the harddrive spinning up and working for about 10 seconds before it
> > happens
> > > again. When the power is plugged back in, everything goes right back to
> > > normal. This started with vanilla 2.6.37 from linus's git. I thought it
> > > might
> > > have something to do with laptop-mode, but disabling it did not change
> > > anything.
> > >
> > > [3.] EXT4; filesystems; ?
> > >
> > > [4.]
> > > [4.1.]
> > > Linux version 2.6.37-liq2-eleanor (john@eleanor) (gcc version 4.5.2
> > (GCC) )
> > > #2 ZEN SMP PREEMPT Sat Jan 15 18:25:26 CET 2011
> > > [4.2.]
> > >
> > > #
> > > # Automatically generated make config: don't edit
> > > # Linux/x86_64 2.6.37 Kernel Configuration
> > > # Sat Jan 15 18:02:03 2011
> > > #
> > > CONFIG_64BIT=y
> > > # CONFIG_X86_32 is not set
> > > CONFIG_X86_64=y
> > > CONFIG_X86=y
> > > CONFIG_INSTRUCTION_DECODER=y
> > > CONFIG_OUTPUT_FORMAT="elf64-x86-64"
> > > CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
> > > CONFIG_GENERIC_CMOS_UPDATE=y
> > > CONFIG_CLOCKSOURCE_WATCHDOG=y
> > > CONFIG_GENERIC_CLOCKEVENTS=y
> > > CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
> > > CONFIG_LOCKDEP_SUPPORT=y
> > > CONFIG_STACKTRACE_SUPPORT=y
> > > CONFIG_HAVE_LATENCYTOP_SUPPORT=y
> > > CONFIG_MMU=y
> > > CONFIG_ZONE_DMA=y
> > > CONFIG_NEED_DMA_MAP_STATE=y
> > > CONFIG_NEED_SG_DMA_LENGTH=y
> > > CONFIG_GENERIC_ISA_DMA=y
> > > CONFIG_GENERIC_IOMAP=y
> > > CONFIG_GENERIC_BUG=y
> > > CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
> > > CONFIG_GENERIC_HWEIGHT=y
> > > CONFIG_GENERIC_GPIO=y
> > > CONFIG_ARCH_MAY_HAVE_PC_FDC=y
> > > # CONFIG_RWSEM_GENERIC_SPINLOCK is not set
> > > CONFIG_RWSEM_XCHGADD_ALGORITHM=y
> > > CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
> > > CONFIG_GENERIC_CALIBRATE_DELAY=y
> > > CONFIG_GENERIC_TIME_VSYSCALL=y
> > > CONFIG_ARCH_HAS_CPU_RELAX=y
> > > CONFIG_ARCH_HAS_DEFAULT_IDLE=y
> > > CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
> > > CONFIG_HAVE_SETUP_PER_CPU_AREA=y
> > > CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
> > > CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
> > > CONFIG_HAVE_CPUMASK_OF_CPU_MAP=y
> > > CONFIG_ARCH_HIBERNATION_POSSIBLE=y
> > > CONFIG_ARCH_SUSPEND_POSSIBLE=y
> > > CONFIG_ZONE_DMA32=y
> > > CONFIG_ARCH_POPULATES_NODE_MAP=y
> > > CONFIG_AUDIT_ARCH=y
> > > CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
> > > CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
> > > CONFIG_USE_GENERIC_SMP_HELPERS=y
> > > CONFIG_X86_64_SMP=y
> > > CONFIG_X86_HT=y
> > > CONFIG_X86_TRAMPOLINE=y
> > > CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi
> > > -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9
> > > -fcall-saved-r10 -fcall-saved-r11"
> > > # CONFIG_KTIME_SCALAR is not set
> > > CONFIG_ARCH_CPU_PROBE_RELEASE=y
> > > CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
> > > CONFIG_CONSTRUCTORS=y
> > > CONFIG_HAVE_IRQ_WORK=y
> > > CONFIG_IRQ_WORK=y
> > >
> > > #
> > > # General setup
> > > #
> > > # CONFIG_SCHED_BFS is not set
> > > CONFIG_SCHED_CFS=y
> > > # CONFIG_ZEN_SERVER is not set
> > > # CONFIG_ZEN_DEFAULT is not set
> > > CONFIG_ZEN_DESKTOP=y
> > > # CONFIG_ZEN_CUSTOM is not set
> > > CONFIG_EXPERIMENTAL=y
> > > CONFIG_LOCK_KERNEL=y
> > > CONFIG_INIT_ENV_ARG_LIMIT=32
> > > CONFIG_CROSS_COMPILE=""
> > > CONFIG_LOCALVERSION="-eleanor"
> > > # CONFIG_LOCALVERSION_AUTO is not set
> > > CONFIG_HAVE_KERNEL_GZIP=y
> > > CONFIG_HAVE_KERNEL_BZIP2=y
> > > CONFIG_HAVE_KERNEL_LZMA=y
> > > CONFIG_HAVE_KERNEL_LZO=y
> > > # CONFIG_KERNEL_GZIP is not set
> > > # CONFIG_KERNEL_BZIP2 is not set
> > > CONFIG_KERNEL_LZMA=y
> > > # CONFIG_KERNEL_LZO is not set
> > > CONFIG_SWAP=y
> > > CONFIG_SYSVIPC=y
> > > CONFIG_SYSVIPC_SYSCTL=y
> > > CONFIG_POSIX_MQUEUE=y
> > > CONFIG_POSIX_MQUEUE_SYSCTL=y
> > > CONFIG_BSD_PROCESS_ACCT=y
> > > CONFIG_BSD_PROCESS_ACCT_V3=y
> > > CONFIG_TASKSTATS=y
> > > CONFIG_TASK_DELAY_ACCT=y
> > > CONFIG_TASK_XACCT=y
> > > CONFIG_TASK_IO_ACCOUNTING=y
> > > CONFIG_AUDIT=y
> > > CONFIG_AUDITSYSCALL=y
> > > CONFIG_AUDIT_WATCH=y
> > > CONFIG_AUDIT_TREE=y
> > > CONFIG_HAVE_GENERIC_HARDIRQS=y
> > >
> > > #
> > > # IRQ subsystem
> > > #
> > > CONFIG_GENERIC_HARDIRQS=y
> > > CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ=y
> > > # CONFIG_GENERIC_HARDIRQS_NO_DEPRECATED is not set
> > > CONFIG_HAVE_SPARSE_IRQ=y
> > > CONFIG_GENERIC_IRQ_PROBE=y
> > > CONFIG_GENERIC_PENDING_IRQ=y
> > > # CONFIG_AUTO_IRQ_AFFINITY is not set
> > > # CONFIG_IRQ_PER_CPU is not set
> > > # CONFIG_HARDIRQS_SW_RESEND is not set
> > > # CONFIG_SPARSE_IRQ is not set
> > >
> > > #
> > > # RCU Subsystem
> > > #
> > > CONFIG_TREE_PREEMPT_RCU=y
> > > CONFIG_PREEMPT_RCU=y
> > > # CONFIG_RCU_TRACE is not set
> > > CONFIG_RCU_FANOUT=32
> > > # CONFIG_RCU_FANOUT_EXACT is not set
> > > # CONFIG_TREE_RCU_TRACE is not set
> > > CONFIG_IKCONFIG=y
> > > CONFIG_IKCONFIG_PROC=y
> > > CONFIG_LOG_BUF_SHIFT=15
> > > CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
> > > CONFIG_CGROUPS=y
> > > # CONFIG_CGROUP_DEBUG is not set
> > > # CONFIG_CGROUP_NS is not set
> > > # CONFIG_CGROUP_FREEZER is not set
> > > # CONFIG_CGROUP_DEVICE is not set
> > > # CONFIG_CPUSETS is not set
> > > # CONFIG_CGROUP_CPUACCT is not set
> > > # CONFIG_RESOURCE_COUNTERS is not set
> > > CONFIG_CGROUP_SCHED=y
> > > CONFIG_FAIR_GROUP_SCHED=y
> > > # CONFIG_RT_GROUP_SCHED is not set
> > > # CONFIG_BLK_CGROUP is not set
> > > CONFIG_NAMESPACES=y
> > > CONFIG_UTS_NS=y
> > > CONFIG_IPC_NS=y
> > > # CONFIG_USER_NS is not set
> > > # CONFIG_PID_NS is not set
> > > CONFIG_NET_NS=y
> > > CONFIG_SCHED_AUTOGROUP=y
> > > # CONFIG_SYSFS_DEPRECATED is not set
> > > CONFIG_RELAY=y
> > > CONFIG_BLK_DEV_INITRD=y
> > > CONFIG_INITRAMFS_SOURCE=""
> > > CONFIG_RD_GZIP=y
> > > CONFIG_RD_BZIP2=y
> > > CONFIG_RD_LZMA=y
> > > CONFIG_RD_LZO=y
> > > # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
> > > CONFIG_SYSCTL=y
> > > CONFIG_ANON_INODES=y
> > > # CONFIG_EMBEDDED is not set
> > > CONFIG_UID16=y
> > > CONFIG_SYSCTL_SYSCALL=y
> > > CONFIG_KALLSYMS=y
> > > # CONFIG_KALLSYMS_ALL is not set
> > > # CONFIG_KALLSYMS_EXTRA_PASS is not set
> > > CONFIG_HOTPLUG=y
> > > CONFIG_PRINTK=y
> > > CONFIG_BUG=y
> > > CONFIG_ELF_CORE=y
> > > CONFIG_PCSPKR_PLATFORM=y
> > > CONFIG_BASE_FULL=y
> > > CONFIG_FUTEX=y
> > > CONFIG_EPOLL=y
> > > CONFIG_SIGNALFD=y
> > > CONFIG_TIMERFD=y
> > > CONFIG_EVENTFD=y
> > > CONFIG_SHMEM=y
> > > CONFIG_AIO=y
> > > CONFIG_HAVE_PERF_EVENTS=y
> > >
> > > #
> > > # Kernel Performance Events And Counters
> > > #
> > > CONFIG_PERF_EVENTS=y
> > > # CONFIG_PERF_COUNTERS is not set
> > > # CONFIG_DEBUG_PERF_USE_VMALLOC is not set
> > > CONFIG_VM_EVENT_COUNTERS=y
> > > CONFIG_PCI_QUIRKS=y
> > > CONFIG_SLUB_DEBUG=y
> > > CONFIG_COMPAT_BRK=y
> > > # CONFIG_SLAB is not set
> > > CONFIG_SLUB=y
> > > CONFIG_PROFILING=y
> > > CONFIG_TRACEPOINTS=y
> > > # CONFIG_OPROFILE is not set
> > > CONFIG_HAVE_OPROFILE=y
> > > # CONFIG_KPROBES is not set
> > > # CONFIG_JUMP_LABEL is not set
> > > CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
> > > CONFIG_USER_RETURN_NOTIFIER=y
> > > CONFIG_HAVE_IOREMAP_PROT=y
> > > CONFIG_HAVE_KPROBES=y
> > > CONFIG_HAVE_KRETPROBES=y
> > > CONFIG_HAVE_OPTPROBES=y
> > > CONFIG_HAVE_ARCH_TRACEHOOK=y
> > > CONFIG_HAVE_DMA_ATTRS=y
> > > CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
> > > CONFIG_HAVE_DMA_API_DEBUG=y
> > > CONFIG_HAVE_HW_BREAKPOINT=y
> > > CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
> > > CONFIG_HAVE_USER_RETURN_NOTIFIER=y
> > > CONFIG_HAVE_PERF_EVENTS_NMI=y
> > > CONFIG_HAVE_ARCH_JUMP_LABEL=y
> > >
> > > #
> > > # GCOV-based kernel profiling
> > > #
> > > # CONFIG_GCOV_KERNEL is not set
> > > # CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
> > > CONFIG_SLABINFO=y
> > > CONFIG_RT_MUTEXES=y
> > > CONFIG_BASE_SMALL=0
> > > CONFIG_MODULES=y
> > > CONFIG_MODULE_FORCE_LOAD=y
> > > CONFIG_MODULE_UNLOAD=y
> > > CONFIG_MODULE_FORCE_UNLOAD=y
> > > # CONFIG_MODVERSIONS is not set
> > > # CONFIG_MODULE_SRCVERSION_ALL is not set
> > > CONFIG_STOP_MACHINE=y
> > > CONFIG_BLOCK=y
> > > CONFIG_BLK_DEV_BSG=y
> > > # CONFIG_BLK_DEV_INTEGRITY is not set
> > > CONFIG_BLOCK_COMPAT=y
> > >
> > > #
> > > # IO Schedulers
> > > #
> > > CONFIG_IOSCHED_NOOP=y
> > > CONFIG_IOSCHED_DEADLINE=y
> > > CONFIG_IOSCHED_CFQ=y
> > > CONFIG_IOSCHED_BFQ=y
> > > # CONFIG_CGROUP_BFQIO is not set
> > > # CONFIG_DEFAULT_DEADLINE is not set
> > > # CONFIG_DEFAULT_CFQ is not set
> > > CONFIG_DEFAULT_BFQ=y
> > > # CONFIG_DEFAULT_NOOP is not set
> > > CONFIG_DEFAULT_IOSCHED="bfq"
> > > CONFIG_PREEMPT_NOTIFIERS=y
> > > # CONFIG_INLINE_SPIN_TRYLOCK is not set
> > > # CONFIG_INLINE_SPIN_TRYLOCK_BH is not set
> > > # CONFIG_INLINE_SPIN_LOCK is not set
> > > # CONFIG_INLINE_SPIN_LOCK_BH is not set
> > > # CONFIG_INLINE_SPIN_LOCK_IRQ is not set
> > > # CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
> > > # CONFIG_INLINE_SPIN_UNLOCK is not set
> > > # CONFIG_INLINE_SPIN_UNLOCK_BH is not set
> > > # CONFIG_INLINE_SPIN_UNLOCK_IRQ is not set
> > > # CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE is not set
> > > # CONFIG_INLINE_READ_TRYLOCK is not set
> > > # CONFIG_INLINE_READ_LOCK is not set
> > > # CONFIG_INLINE_READ_LOCK_BH is not set
> > > # CONFIG_INLINE_READ_LOCK_IRQ is not set
> > > # CONFIG_INLINE_READ_LOCK_IRQSAVE is not set
> > > # CONFIG_INLINE_READ_UNLOCK is not set
> > > # CONFIG_INLINE_READ_UNLOCK_BH is not set
> > > # CONFIG_INLINE_READ_UNLOCK_IRQ is not set
> > > # CONFIG_INLINE_READ_UNLOCK_IRQRESTORE is not set
> > > # CONFIG_INLINE_WRITE_TRYLOCK is not set
> > > # CONFIG_INLINE_WRITE_LOCK is not set
> > > # CONFIG_INLINE_WRITE_LOCK_BH is not set
> > > # CONFIG_INLINE_WRITE_LOCK_IRQ is not set
> > > # CONFIG_INLINE_WRITE_LOCK_IRQSAVE is not set
> > > # CONFIG_INLINE_WRITE_UNLOCK is not set
> > > # CONFIG_INLINE_WRITE_UNLOCK_BH is not set
> > > # CONFIG_INLINE_WRITE_UNLOCK_IRQ is not set
> > > # CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE is not set
> > > CONFIG_MUTEX_SPIN_ON_OWNER=y
> > > CONFIG_FREEZER=y
> > >
> > > #
> > > # Processor type and features
> > > #
> > > CONFIG_TICK_ONESHOT=y
> > > CONFIG_NO_HZ=y
> > > CONFIG_HIGH_RES_TIMERS=y
> > > CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
> > > CONFIG_SMP=y
> > > CONFIG_X86_MPPARSE=y
> > > # CONFIG_X86_EXTENDED_PLATFORM is not set
> > > CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
> > > CONFIG_SCHED_OMIT_FRAME_POINTER=y
> > > # CONFIG_PARAVIRT_GUEST is not set
> > > CONFIG_NO_BOOTMEM=y
> > > # CONFIG_MEMTEST is not set
> > > CONFIG_MK8=y
> > > # CONFIG_MPSC is not set
> > > # CONFIG_MCORE2 is not set
> > > # CONFIG_MATOM is not set
> > > # CONFIG_GENERIC_CPU is not set
> > > CONFIG_X86_MARCH_NATIVE=y
> > > CONFIG_X86_CPU=y
> > > CONFIG_X86_INTERNODE_CACHE_SHIFT=6
> > > CONFIG_X86_CMPXCHG=y
> > > CONFIG_X86_L1_CACHE_SHIFT=6
> > > CONFIG_X86_XADD=y
> > > CONFIG_X86_WP_WORKS_OK=y
> > > CONFIG_X86_INTEL_USERCOPY=y
> > > CONFIG_X86_USE_PPRO_CHECKSUM=y
> > > CONFIG_X86_TSC=y
> > > CONFIG_X86_CMPXCHG64=y
> > > CONFIG_X86_CMOV=y
> > > CONFIG_X86_MINIMUM_CPU_FAMILY=64
> > > CONFIG_X86_DEBUGCTLMSR=y
> > > CONFIG_CPU_SUP_INTEL=y
> > > CONFIG_CPU_SUP_AMD=y
> > > CONFIG_CPU_SUP_CENTAUR=y
> > > CONFIG_HPET_TIMER=y
> > > CONFIG_HPET_EMULATE_RTC=y
> > > CONFIG_DMI=y
> > > CONFIG_GART_IOMMU=y
> > > # CONFIG_CALGARY_IOMMU is not set
> > > CONFIG_AMD_IOMMU=y
> > > # CONFIG_AMD_IOMMU_STATS is not set
> > > CONFIG_SWIOTLB=y
> > > CONFIG_IOMMU_HELPER=y
> > > CONFIG_IOMMU_API=y
> > > # CONFIG_MAXSMP is not set
> > > CONFIG_NR_CPUS=32
> > > # CONFIG_SCHED_SMT is not set
> > > CONFIG_SCHED_MC=y
> > > # CONFIG_IRQ_TIME_ACCOUNTING is not set
> > > # CONFIG_PREEMPT_NONE is not set
> > > # CONFIG_PREEMPT_VOLUNTARY is not set
> > > CONFIG_PREEMPT=y
> > > CONFIG_X86_LOCAL_APIC=y
> > > CONFIG_X86_IO_APIC=y
> > > CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
> > > CONFIG_X86_MCE=y
> > > # CONFIG_X86_MCE_INTEL is not set
> > > CONFIG_X86_MCE_AMD=y
> > > CONFIG_X86_MCE_THRESHOLD=y
> > > # CONFIG_X86_MCE_INJECT is not set
> > > # CONFIG_I8K is not set
> > > # CONFIG_MICROCODE is not set
> > > # CONFIG_X86_MSR is not set
> > > # CONFIG_X86_CPUID is not set
> > > CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
> > > CONFIG_ARCH_DMA_ADDR_T_64BIT=y
> > > CONFIG_DIRECT_GBPAGES=y
> > > # CONFIG_NUMA is not set
> > > CONFIG_ARCH_PROC_KCORE_TEXT=y
> > > CONFIG_ARCH_SPARSEMEM_DEFAULT=y
> > > CONFIG_ARCH_SPARSEMEM_ENABLE=y
> > > CONFIG_ARCH_SELECT_MEMORY_MODEL=y
> > > CONFIG_ARCH_MEMORY_PROBE=y
> > > CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
> > > CONFIG_SELECT_MEMORY_MODEL=y
> > > CONFIG_SPARSEMEM_MANUAL=y
> > > CONFIG_SPARSEMEM=y
> > > CONFIG_HAVE_MEMORY_PRESENT=y
> > > CONFIG_SPARSEMEM_EXTREME=y
> > > CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
> > > CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
> > > CONFIG_SPARSEMEM_VMEMMAP=y
> > > CONFIG_HAVE_MEMBLOCK=y
> > > CONFIG_MEMORY_HOTPLUG=y
> > > CONFIG_MEMORY_HOTPLUG_SPARSE=y
> > > CONFIG_MEMORY_HOTREMOVE=y
> > > CONFIG_PAGEFLAGS_EXTENDED=y
> > > CONFIG_SPLIT_PTLOCK_CPUS=4
> > > CONFIG_MIGRATION=y
> > > CONFIG_PHYS_ADDR_T_64BIT=y
> > > CONFIG_ZONE_DMA_FLAG=1
> > > CONFIG_BOUNCE=y
> > > CONFIG_VIRT_TO_BUS=y
> > > CONFIG_MMU_NOTIFIER=y
> > > # CONFIG_KSM is not set
> > > CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
> > > CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
> > > # CONFIG_MEMORY_FAILURE is not set
> > > # CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
> > > CONFIG_X86_RESERVE_LOW=64
> > > CONFIG_MTRR=y
> > > CONFIG_MTRR_SANITIZER=y
> > > CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
> > > CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
> > > CONFIG_X86_PAT=y
> > > CONFIG_ARCH_USES_PG_UNCACHED=y
> > > CONFIG_EFI=y
> > > CONFIG_SECCOMP=y
> > > CONFIG_CC_STACKPROTECTOR=y
> > > # CONFIG_HZ_100 is not set
> > > # CONFIG_HZ_250_NODEFAULT is not set
> > > # CONFIG_HZ_300 is not set
> > > CONFIG_HZ_1000=y
> > > # CONFIG_HZ_1500 is not set
> > > # CONFIG_HZ_2000 is not set
> > > # CONFIG_HZ_3000 is not set
> > > # CONFIG_HZ_4000 is not set
> > > # CONFIG_HZ_5000 is not set
> > > # CONFIG_HZ_7500 is not set
> > > # CONFIG_HZ_10000 is not set
> > > CONFIG_HZ=1000
> > > CONFIG_SCHED_HRTICK=y
> > > # CONFIG_KEXEC is not set
> > > # CONFIG_CRASH_DUMP is not set
> > > CONFIG_PHYSICAL_START=0x1000000
> > > # CONFIG_RELOCATABLE is not set
> > > CONFIG_PHYSICAL_ALIGN=0x1000000
> > > CONFIG_HOTPLUG_CPU=y
> > > CONFIG_COMPAT_VDSO=y
> > > # CONFIG_CMDLINE_BOOL is not set
> > > CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
> > > CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
> > >
> > > #
> > > # Power management and ACPI options
> > > #
> > > CONFIG_ARCH_HIBERNATION_HEADER=y
> > > CONFIG_PM=y
> > > # CONFIG_PM_DEBUG is not set
> > > CONFIG_PM_SLEEP_SMP=y
> > > CONFIG_PM_SLEEP=y
> > > CONFIG_SUSPEND_NVS=y
> > > CONFIG_SUSPEND=y
> > > CONFIG_SUSPEND_FREEZER=y
> > > CONFIG_HIBERNATION=y
> > > CONFIG_PM_STD_PARTITION="\"\""
> > > CONFIG_PM_RUNTIME=y
> > > CONFIG_PM_OPS=y
> > > CONFIG_ACPI=y
> > > CONFIG_ACPI_SLEEP=y
> > > CONFIG_ACPI_PROCFS=y
> > > CONFIG_ACPI_PROCFS_POWER=y
> > > # CONFIG_ACPI_POWER_METER is not set
> > > # CONFIG_ACPI_EC_DEBUGFS is not set
> > > CONFIG_ACPI_PROC_EVENT=y
> > > CONFIG_ACPI_AC=m
> > > CONFIG_ACPI_BATTERY=m
> > > CONFIG_ACPI_BUTTON=m
> > > CONFIG_ACPI_VIDEO=m
> > > # CONFIG_ACPI_FAN is not set
> > > CONFIG_ACPI_DOCK=y
> > > CONFIG_ACPI_PROCESSOR=m
> > > CONFIG_ACPI_HOTPLUG_CPU=y
> > > # CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
> > > CONFIG_ACPI_THERMAL=m
> > > # CONFIG_ACPI_CUSTOM_DSDT is not set
> > > CONFIG_ACPI_BLACKLIST_YEAR=0
> > > # CONFIG_ACPI_DEBUG is not set
> > > # CONFIG_ACPI_PCI_SLOT is not set
> > > CONFIG_X86_PM_TIMER=y
> > > CONFIG_ACPI_CONTAINER=m
> > > # CONFIG_ACPI_HOTPLUG_MEMORY is not set
> > > # CONFIG_ACPI_SBS is not set
> > > # CONFIG_ACPI_HED is not set
> > > CONFIG_ACPI_APEI=y
> > > # CONFIG_ACPI_APEI_GHES is not set
> > > # CONFIG_ACPI_APEI_EINJ is not set
> > > # CONFIG_ACPI_APEI_ERST_DEBUG is not set
> > > CONFIG_SFI=y
> > >
> > > #
> > > # CPU Frequency scaling
> > > #
> > > CONFIG_CPU_FREQ=y
> > > CONFIG_CPU_FREQ_TABLE=y
> > > # CONFIG_CPU_FREQ_DEBUG is not set
> > > CONFIG_CPU_FREQ_STAT=m
> > > CONFIG_CPU_FREQ_STAT_DETAILS=y
> > > # CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
> > > CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
> > > # CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
> > > # CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
> > > # CONFIG_CPU_FREQ_GOV_PERFORMANCE is not set
> > > # CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
> > > CONFIG_CPU_FREQ_GOV_USERSPACE=y
> > > CONFIG_CPU_FREQ_GOV_ONDEMAND=y
> > > # CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set
> > >
> > > #
> > > # CPUFreq processor drivers
> > > #
> > > # CONFIG_X86_PCC_CPUFREQ is not set
> > > CONFIG_X86_ACPI_CPUFREQ=m
> > > CONFIG_X86_POWERNOW_K8=m
> > > # CONFIG_X86_SPEEDSTEP_CENTRINO is not set
> > > # CONFIG_X86_P4_CLOCKMOD is not set
> > >
> > > #
> > > # shared options
> > > #
> > > # CONFIG_X86_SPEEDSTEP_LIB is not set
> > > CONFIG_CPU_IDLE=y
> > > CONFIG_CPU_IDLE_GOV_LADDER=y
> > > CONFIG_CPU_IDLE_GOV_MENU=y
> > > # CONFIG_INTEL_IDLE is not set
> > >
> > > #
> > > # Memory power savings
> > > #
> > > # CONFIG_I7300_IDLE is not set
> > >
> > > #
> > > # Bus options (PCI etc.)
> > > #
> > > CONFIG_PCI=y
> > > CONFIG_PCI_DIRECT=y
> > > CONFIG_PCI_MMCONFIG=y
> > > CONFIG_PCI_DOMAINS=y
> > > # CONFIG_PCI_CNB20LE_QUIRK is not set
> > > # CONFIG_DMAR is not set
> > > # CONFIG_INTR_REMAP is not set
> > > CONFIG_PCIEPORTBUS=y
> > > # CONFIG_PCIEAER is not set
> > > CONFIG_PCIEASPM=y
> > > # CONFIG_PCIEASPM_DEBUG is not set
> > > CONFIG_PCIE_PME=y
> > > CONFIG_ARCH_SUPPORTS_MSI=y
> > > CONFIG_PCI_MSI=y
> > > # CONFIG_PCI_DEBUG is not set
> > > # CONFIG_PCI_STUB is not set
> > > CONFIG_HT_IRQ=y
> > > # CONFIG_PCI_IOV is not set
> > > CONFIG_PCI_IOAPIC=y
> > > CONFIG_ISA_DMA_API=y
> > > CONFIG_AMD_NB=y
> > > # CONFIG_PCCARD is not set
> > > # CONFIG_HOTPLUG_PCI is not set
> > >
> > > #
> > > # Executable file formats / Emulations
> > > #
> > > CONFIG_BINFMT_ELF=y
> > > CONFIG_COMPAT_BINFMT_ELF=y
> > > # CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
> > > # CONFIG_HAVE_AOUT is not set
> > > CONFIG_BINFMT_MISC=y
> > > CONFIG_IA32_EMULATION=y
> > > # CONFIG_IA32_AOUT is not set
> > > CONFIG_COMPAT=y
> > > CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
> > > CONFIG_SYSVIPC_COMPAT=y
> > > CONFIG_HAVE_TEXT_POKE_SMP=y
> > > CONFIG_NET=y
> > > CONFIG_COMPAT_NETLINK_MESSAGES=y
> > >
> > > #
> > > # Networking options
> > > #
> > > CONFIG_PACKET=y
> > > CONFIG_UNIX=y
> > > # CONFIG_NET_KEY is not set
> > > CONFIG_INET=y
> > > CONFIG_IP_MULTICAST=y
> > > CONFIG_IP_ADVANCED_ROUTER=y
> > > CONFIG_ASK_IP_FIB_HASH=y
> > > # CONFIG_IP_FIB_TRIE is not set
> > > CONFIG_IP_FIB_HASH=y
> > > CONFIG_IP_MULTIPLE_TABLES=y
> > > CONFIG_IP_ROUTE_MULTIPATH=y
> > > CONFIG_IP_ROUTE_VERBOSE=y
> > > # CONFIG_IP_PNP is not set
> > > # CONFIG_NET_IPIP is not set
> > > # CONFIG_NET_IPGRE_DEMUX is not set
> > > CONFIG_IP_MROUTE=y
> > > CONFIG_IP_MROUTE_MULTIPLE_TABLES=y
> > > CONFIG_IP_PIMSM_V1=y
> > > CONFIG_IP_PIMSM_V2=y
> > > # CONFIG_ARPD is not set
> > > CONFIG_SYN_COOKIES=y
> > > # CONFIG_INET_AH is not set
> > > # CONFIG_INET_ESP is not set
> > > # CONFIG_INET_IPCOMP is not set
> > > # CONFIG_INET_XFRM_TUNNEL is not set
> > > # CONFIG_INET_TUNNEL is not set
> > > # CONFIG_INET_XFRM_MODE_TRANSPORT is not set
> > > # CONFIG_INET_XFRM_MODE_TUNNEL is not set
> > > # CONFIG_INET_XFRM_MODE_BEET is not set
> > > CONFIG_INET_LRO=y
> > > # CONFIG_INET_DIAG is not set
> > > # CONFIG_TCP_CONG_ADVANCED is not set
> > > CONFIG_TCP_CONG_CUBIC=y
> > > CONFIG_DEFAULT_TCP_CONG="cubic"
> > > # CONFIG_TCP_MD5SIG is not set
> > > CONFIG_IPV6=m
> > > CONFIG_IPV6_PRIVACY=y
> > > # CONFIG_IPV6_ROUTER_PREF is not set
> > > # CONFIG_IPV6_OPTIMISTIC_DAD is not set
> > > # CONFIG_INET6_AH is not set
> > > # CONFIG_INET6_ESP is not set
> > > # CONFIG_INET6_IPCOMP is not set
> > > # CONFIG_IPV6_MIP6 is not set
> > > # CONFIG_INET6_XFRM_TUNNEL is not set
> > > # CONFIG_INET6_TUNNEL is not set
> > > # CONFIG_INET6_XFRM_MODE_TRANSPORT is not set
> > > # CONFIG_INET6_XFRM_MODE_TUNNEL is not set
> > > # CONFIG_INET6_XFRM_MODE_BEET is not set
> > > # CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION is not set
> > > # CONFIG_IPV6_SIT is not set
> > > # CONFIG_IPV6_TUNNEL is not set
> > > # CONFIG_IPV6_MULTIPLE_TABLES is not set
> > > # CONFIG_IPV6_MROUTE is not set
> > > # CONFIG_NETLABEL is not set
> > > # CONFIG_NETWORK_SECMARK is not set
> > > # CONFIG_NETWORK_PHY_TIMESTAMPING is not set
> > > CONFIG_NETFILTER=y
> > > # CONFIG_NETFILTER_DEBUG is not set
> > > CONFIG_NETFILTER_ADVANCED=y
> > > CONFIG_BRIDGE_NETFILTER=y
> > >
> > > #
> > > # Core Netfilter Configuration
> > > #
> > > # CONFIG_NETFILTER_NETLINK_QUEUE is not set
> > > # CONFIG_NETFILTER_NETLINK_LOG is not set
> > > # CONFIG_NF_CONNTRACK is not set
> > > # CONFIG_NETFILTER_XTABLES is not set
> > > # CONFIG_IP_VS is not set
> > >
> > > #
> > > # IP: Netfilter Configuration
> > > #
> > > # CONFIG_NF_DEFRAG_IPV4 is not set
> > > # CONFIG_IP_NF_QUEUE is not set
> > > # CONFIG_IP_NF_IPTABLES is not set
> > > # CONFIG_IP_NF_ARPTABLES is not set
> > >
> > > #
> > > # IPv6: Netfilter Configuration
> > > #
> > > # CONFIG_NF_DEFRAG_IPV6 is not set
> > > # CONFIG_IP6_NF_QUEUE is not set
> > > # CONFIG_IP6_NF_IPTABLES is not set
> > > # CONFIG_BRIDGE_NF_EBTABLES is not set
> > > # CONFIG_IP_DCCP is not set
> > > # CONFIG_IP_SCTP is not set
> > > # CONFIG_RDS is not set
> > > # CONFIG_TIPC is not set
> > > # CONFIG_ATM is not set
> > > # CONFIG_L2TP is not set
> > > CONFIG_STP=m
> > > CONFIG_BRIDGE=m
> > > CONFIG_BRIDGE_IGMP_SNOOPING=y
> > > # CONFIG_NET_DSA is not set
> > > # CONFIG_VLAN_8021Q is not set
> > > # CONFIG_DECNET is not set
> > > CONFIG_LLC=m
> > > # CONFIG_LLC2 is not set
> > > # CONFIG_IPX is not set
> > > # CONFIG_ATALK is not set
> > > # CONFIG_X25 is not set
> > > # CONFIG_LAPB is not set
> > > # CONFIG_ECONET is not set
> > > # CONFIG_WAN_ROUTER is not set
> > > # CONFIG_PHONET is not set
> > > # CONFIG_IEEE802154 is not set
> > > CONFIG_NET_SCHED=y
> > >
> > > #
> > > # Queueing/Scheduling
> > > #
> > > # CONFIG_NET_SCH_CBQ is not set
> > > # CONFIG_NET_SCH_HTB is not set
> > > # CONFIG_NET_SCH_HFSC is not set
> > > # CONFIG_NET_SCH_PRIO is not set
> > > # CONFIG_NET_SCH_MULTIQ is not set
> > > # CONFIG_NET_SCH_RED is not set
> > > # CONFIG_NET_SCH_SFB is not set
> > > # CONFIG_NET_SCH_SFQ is not set
> > > # CONFIG_NET_SCH_TEQL is not set
> > > # CONFIG_NET_SCH_TBF is not set
> > > # CONFIG_NET_SCH_GRED is not set
> > > # CONFIG_NET_SCH_DSMARK is not set
> > > # CONFIG_NET_SCH_NETEM is not set
> > > # CONFIG_NET_SCH_DRR is not set
> > > # CONFIG_NET_SCH_INGRESS is not set
> > >
> > > #
> > > # Classification
> > > #
> > > CONFIG_NET_CLS=y
> > > # CONFIG_NET_CLS_BASIC is not set
> > > # CONFIG_NET_CLS_TCINDEX is not set
> > > # CONFIG_NET_CLS_ROUTE4 is not set
> > > # CONFIG_NET_CLS_FW is not set
> > > # CONFIG_NET_CLS_U32 is not set
> > > # CONFIG_NET_CLS_RSVP is not set
> > > # CONFIG_NET_CLS_RSVP6 is not set
> > > # CONFIG_NET_CLS_FLOW is not set
> > > # CONFIG_NET_CLS_CGROUP is not set
> > > CONFIG_NET_EMATCH=y
> > > CONFIG_NET_EMATCH_STACK=32
> > > # CONFIG_NET_EMATCH_CMP is not set
> > > # CONFIG_NET_EMATCH_NBYTE is not set
> > > # CONFIG_NET_EMATCH_U32 is not set
> > > # CONFIG_NET_EMATCH_META is not set
> > > # CONFIG_NET_EMATCH_TEXT is not set
> > > CONFIG_NET_CLS_ACT=y
> > > CONFIG_NET_ACT_POLICE=y
> > > # CONFIG_NET_ACT_GACT is not set
> > > # CONFIG_NET_ACT_MIRRED is not set
> > > # CONFIG_NET_ACT_NAT is not set
> > > # CONFIG_NET_ACT_PEDIT is not set
> > > # CONFIG_NET_ACT_SIMP is not set
> > > # CONFIG_NET_ACT_SKBEDIT is not set
> > > # CONFIG_NET_ACT_CSUM is not set
> > > CONFIG_NET_SCH_FIFO=y
> > > # CONFIG_DCB is not set
> > > CONFIG_DNS_RESOLVER=y
> > > CONFIG_RPS=y
> > >
> > > #
> > > # Network testing
> > > #
> > > # CONFIG_NET_PKTGEN is not set
> > > # CONFIG_NET_DROP_MONITOR is not set
> > > CONFIG_HAMRADIO=y
> > >
> > > #
> > > # Packet Radio protocols
> > > #
> > > # CONFIG_AX25 is not set
> > > # CONFIG_CAN is not set
> > > # CONFIG_IRDA is not set
> > > # CONFIG_BT is not set
> > > # CONFIG_AF_RXRPC is not set
> > > CONFIG_FIB_RULES=y
> > > CONFIG_WIRELESS=y
> > > CONFIG_WEXT_CORE=y
> > > CONFIG_WEXT_PROC=y
> > > CONFIG_CFG80211=m
> > > # CONFIG_NL80211_TESTMODE is not set
> > > # CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
> > > # CONFIG_CFG80211_REG_DEBUG is not set
> > > CONFIG_CFG80211_DEFAULT_PS=y
> > > # CONFIG_CFG80211_DEBUGFS is not set
> > > # CONFIG_CFG80211_INTERNAL_REGDB is not set
> > > CONFIG_CFG80211_WEXT=y
> > > CONFIG_WIRELESS_EXT_SYSFS=y
> > > # CONFIG_LIB80211 is not set
> > > CONFIG_MAC80211=m
> > > CONFIG_MAC80211_HAS_RC=y
> > > CONFIG_MAC80211_RC_MINSTREL=y
> > > CONFIG_MAC80211_RC_MINSTREL_HT=y
> > > CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
> > > CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
> > > CONFIG_MAC80211_MESH=y
> > > CONFIG_MAC80211_LEDS=y
> > > # CONFIG_MAC80211_DEBUGFS is not set
> > > # CONFIG_MAC80211_DEBUG_MENU is not set
> > > # CONFIG_WIMAX is not set
> > > # CONFIG_RFKILL is not set
> > > # CONFIG_NET_9P is not set
> > > # CONFIG_CAIF is not set
> > > # CONFIG_CEPH_LIB is not set
> > >
> > > #
> > > # Device Drivers
> > > #
> > >
> > > #
> > > # Generic Driver Options
> > > #
> > > CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
> > > CONFIG_DEVTMPFS=y
> > > CONFIG_DEVTMPFS_MOUNT=y
> > > CONFIG_STANDALONE=y
> > > CONFIG_PREVENT_FIRMWARE_BUILD=y
> > > CONFIG_FW_LOADER=y
> > > # CONFIG_FIRMWARE_IN_KERNEL is not set
> > > CONFIG_EXTRA_FIRMWARE=""
> > > # CONFIG_DEBUG_DRIVER is not set
> > > # CONFIG_DEBUG_DEVRES is not set
> > > # CONFIG_SYS_HYPERVISOR is not set
> > > # CONFIG_CONNECTOR is not set
> > > # CONFIG_MTD is not set
> > > # CONFIG_PARPORT is not set
> > > CONFIG_PNP=y
> > > # CONFIG_PNP_DEBUG_MESSAGES is not set
> > >
> > > #
> > > # Protocols
> > > #
> > > CONFIG_PNPACPI=y
> > > CONFIG_BLK_DEV=y
> > > # CONFIG_BLK_DEV_FD is not set
> > > # CONFIG_BLK_CPQ_DA is not set
> > > # CONFIG_BLK_CPQ_CISS_DA is not set
> > > # CONFIG_BLK_DEV_DAC960 is not set
> > > # CONFIG_BLK_DEV_UMEM is not set
> > > # CONFIG_BLK_DEV_COW_COMMON is not set
> > > CONFIG_BLK_DEV_LOOP=y
> > > # CONFIG_BLK_DEV_CRYPTOLOOP is not set
> > >
> > > #
> > > # DRBD disabled because PROC_FS, INET or CONNECTOR not selected
> > > #
> > > # CONFIG_BLK_DEV_NBD is not set
> > > # CONFIG_BLK_DEV_SX8 is not set
> > > # CONFIG_BLK_DEV_UB is not set
> > > CONFIG_BLK_DEV_RAM=y
> > > CONFIG_BLK_DEV_RAM_COUNT=16
> > > CONFIG_BLK_DEV_RAM_SIZE=16384
> > > # CONFIG_BLK_DEV_XIP is not set
> > > CONFIG_CDROM_PKTCDVD=m
> > > CONFIG_CDROM_PKTCDVD_BUFFERS=8
> > > # CONFIG_CDROM_PKTCDVD_WCACHE is not set
> > > # CONFIG_ATA_OVER_ETH is not set
> > > # CONFIG_BLK_DEV_HD is not set
> > > # CONFIG_BLK_DEV_RBD is not set
> > > # CONFIG_MISC_DEVICES is not set
> > > CONFIG_HAVE_IDE=y
> > > # CONFIG_IDE is not set
> > >
> > > #
> > > # SCSI device support
> > > #
> > > CONFIG_SCSI_MOD=y
> > > CONFIG_RAID_ATTRS=y
> > > CONFIG_SCSI=y
> > > CONFIG_SCSI_DMA=y
> > > CONFIG_SCSI_TGT=y
> > > CONFIG_SCSI_NETLINK=y
> > > CONFIG_SCSI_PROC_FS=y
> > >
> > > #
> > > # SCSI support type (disk, tape, CD-ROM)
> > > #
> > > CONFIG_BLK_DEV_SD=y
> > > # CONFIG_CHR_DEV_ST is not set
> > > # CONFIG_CHR_DEV_OSST is not set
> > > CONFIG_BLK_DEV_SR=y
> > > CONFIG_BLK_DEV_SR_VENDOR=y
> > > # CONFIG_CHR_DEV_SG is not set
> > > # CONFIG_CHR_DEV_SCH is not set
> > > CONFIG_SCSI_MULTI_LUN=y
> > > # CONFIG_SCSI_CONSTANTS is not set
> > > # CONFIG_SCSI_LOGGING is not set
> > > # CONFIG_SCSI_SCAN_ASYNC is not set
> > > CONFIG_SCSI_WAIT_SCAN=m
> > >
> > > #
> > > # SCSI Transports
> > > #
> > > CONFIG_SCSI_SPI_ATTRS=y
> > > CONFIG_SCSI_FC_ATTRS=m
> > > CONFIG_SCSI_FC_TGT_ATTRS=y
> > > CONFIG_SCSI_ISCSI_ATTRS=y
> > > CONFIG_SCSI_SAS_ATTRS=y
> > > CONFIG_SCSI_SAS_LIBSAS=y
> > > CONFIG_SCSI_SAS_ATA=y
> > > CONFIG_SCSI_SAS_HOST_SMP=y
> > > # CONFIG_SCSI_SAS_LIBSAS_DEBUG is not set
> > > # CONFIG_SCSI_SRP_ATTRS is not set
> > > CONFIG_SCSI_LOWLEVEL=y
> > > # CONFIG_ISCSI_TCP is not set
> > > # CONFIG_ISCSI_BOOT_SYSFS is not set
> > > # CONFIG_SCSI_CXGB3_ISCSI is not set
> > > # CONFIG_SCSI_CXGB4_ISCSI is not set
> > > CONFIG_SCSI_BNX2_ISCSI=m
> > > # CONFIG_BE2ISCSI is not set
> > > # CONFIG_BLK_DEV_3W_XXXX_RAID is not set
> > > # CONFIG_SCSI_HPSA is not set
> > > # CONFIG_SCSI_3W_9XXX is not set
> > > # CONFIG_SCSI_3W_SAS is not set
> > > # CONFIG_SCSI_ACARD is not set
> > > # CONFIG_SCSI_AACRAID is not set
> > > # CONFIG_SCSI_AIC7XXX is not set
> > > # CONFIG_SCSI_AIC7XXX_OLD is not set
> > > # CONFIG_SCSI_AIC79XX is not set
> > > # CONFIG_SCSI_AIC94XX is not set
> > > # CONFIG_SCSI_MVSAS is not set
> > > # CONFIG_SCSI_DPT_I2O is not set
> > > # CONFIG_SCSI_ADVANSYS is not set
> > > # CONFIG_SCSI_ARCMSR is not set
> > > CONFIG_MEGARAID_NEWGEN=y
> > > # CONFIG_MEGARAID_MM is not set
> > > # CONFIG_MEGARAID_LEGACY is not set
> > > # CONFIG_MEGARAID_SAS is not set
> > > # CONFIG_SCSI_MPT2SAS is not set
> > > # CONFIG_SCSI_HPTIOP is not set
> > > # CONFIG_SCSI_BUSLOGIC is not set
> > > # CONFIG_VMWARE_PVSCSI is not set
> > > # CONFIG_LIBFC is not set
> > > # CONFIG_LIBFCOE is not set
> > > # CONFIG_FCOE is not set
> > > # CONFIG_FCOE_FNIC is not set
> > > # CONFIG_SCSI_DMX3191D is not set
> > > # CONFIG_SCSI_EATA is not set
> > > # CONFIG_SCSI_FUTURE_DOMAIN is not set
> > > # CONFIG_SCSI_GDTH is not set
> > > # CONFIG_SCSI_IPS is not set
> > > # CONFIG_SCSI_INITIO is not set
> > > # CONFIG_SCSI_INIA100 is not set
> > > # CONFIG_SCSI_STEX is not set
> > > # CONFIG_SCSI_SYM53C8XX_2 is not set
> > > # CONFIG_SCSI_IPR is not set
> > > # CONFIG_SCSI_QLOGIC_1280 is not set
> > > # CONFIG_SCSI_QLA_FC is not set
> > > # CONFIG_SCSI_QLA_ISCSI is not set
> > > # CONFIG_SCSI_LPFC is not set
> > > # CONFIG_SCSI_DC395x is not set
> > > # CONFIG_SCSI_DC390T is not set
> > > # CONFIG_SCSI_DEBUG is not set
> > > # CONFIG_SCSI_PMCRAID is not set
> > > # CONFIG_SCSI_PM8001 is not set
> > > # CONFIG_SCSI_SRP is not set
> > > # CONFIG_SCSI_BFA_FC is not set
> > > # CONFIG_SCSI_DH is not set
> > > # CONFIG_SCSI_OSD_INITIATOR is not set
> > > CONFIG_ATA=y
> > > # CONFIG_ATA_NONSTANDARD is not set
> > > CONFIG_ATA_VERBOSE_ERROR=y
> > > CONFIG_ATA_ACPI=y
> > > CONFIG_SATA_PMP=y
> > >
> > > #
> > > # Controllers with non-SFF native interface
> > > #
> > > CONFIG_SATA_AHCI=y
> > > # CONFIG_SATA_AHCI_PLATFORM is not set
> > > # CONFIG_SATA_INIC162X is not set
> > > # CONFIG_SATA_SIL24 is not set
> > > # CONFIG_ATA_SFF is not set
> > > CONFIG_MD=y
> > > CONFIG_BLK_DEV_MD=y
> > > CONFIG_MD_AUTODETECT=y
> > > CONFIG_MD_LINEAR=y
> > > CONFIG_MD_RAID0=y
> > > CONFIG_MD_RAID1=y
> > > CONFIG_MD_RAID10=y
> > > CONFIG_MD_RAID456=y
> > > # CONFIG_MULTICORE_RAID456 is not set
> > > CONFIG_MD_MULTIPATH=y
> > > # CONFIG_MD_FAULTY is not set
> > > CONFIG_BLK_DEV_DM=y
> > > # CONFIG_DM_DEBUG is not set
> > > CONFIG_DM_CRYPT=y
> > > # CONFIG_DM_SNAPSHOT is not set
> > > CONFIG_DM_MIRROR=y
> > > # CONFIG_DM_LOG_USERSPACE is not set
> > > # CONFIG_DM_ZERO is not set
> > > # CONFIG_DM_MULTIPATH is not set
> > > # CONFIG_DM_DELAY is not set
> > > # CONFIG_DM_RAID45 is not set
> > > CONFIG_DM_UEVENT=y
> > > CONFIG_FUSION=y
> > > # CONFIG_FUSION_SPI is not set
> > > # CONFIG_FUSION_FC is not set
> > > # CONFIG_FUSION_SAS is not set
> > > CONFIG_FUSION_MAX_SGE=128
> > > # CONFIG_FUSION_LOGGING is not set
> > >
> > > #
> > > # IEEE 1394 (FireWire) support
> > > #
> > > CONFIG_FIREWIRE=m
> > > CONFIG_FIREWIRE_OHCI=m
> > > CONFIG_FIREWIRE_OHCI_DEBUG=y
> > > # CONFIG_FIREWIRE_SBP2 is not set
> > > # CONFIG_FIREWIRE_NET is not set
> > > # CONFIG_FIREWIRE_NOSY is not set
> > > # CONFIG_I2O is not set
> > > CONFIG_MACINTOSH_DRIVERS=y
> > > CONFIG_MAC_EMUMOUSEBTN=y
> > > CONFIG_NETDEVICES=y
> > > # CONFIG_IFB is not set
> > > # CONFIG_DUMMY is not set
> > > # CONFIG_BONDING is not set
> > > # CONFIG_MACVLAN is not set
> > > # CONFIG_EQUALIZER is not set
> > > CONFIG_TUN=m
> > > # CONFIG_VETH is not set
> > > # CONFIG_NET_SB1000 is not set
> > > # CONFIG_ARCNET is not set
> > > # CONFIG_MII is not set
> > > # CONFIG_PHYLIB is not set
> > > CONFIG_NET_ETHERNET=y
> > > # CONFIG_HAPPYMEAL is not set
> > > # CONFIG_SUNGEM is not set
> > > # CONFIG_CASSINI is not set
> > > CONFIG_NET_VENDOR_3COM=y
> > > # CONFIG_VORTEX is not set
> > > # CONFIG_TYPHOON is not set
> > > # CONFIG_ETHOC is not set
> > > # CONFIG_DNET is not set
> > > CONFIG_NET_TULIP=y
> > > # CONFIG_DE2104X is not set
> > > # CONFIG_TULIP is not set
> > > # CONFIG_DE4X5 is not set
> > > # CONFIG_WINBOND_840 is not set
> > > # CONFIG_DM9102 is not set
> > > # CONFIG_ULI526X is not set
> > > # CONFIG_HP100 is not set
> > > # CONFIG_IBM_NEW_EMAC_ZMII is not set
> > > # CONFIG_IBM_NEW_EMAC_RGMII is not set
> > > # CONFIG_IBM_NEW_EMAC_TAH is not set
> > > # CONFIG_IBM_NEW_EMAC_EMAC4 is not set
> > > # CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
> > > # CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
> > > # CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
> > > CONFIG_NET_PCI=y
> > > # CONFIG_PCNET32 is not set
> > > # CONFIG_AMD8111_ETH is not set
> > > # CONFIG_ADAPTEC_STARFIRE is not set
> > > # CONFIG_KSZ884X_PCI is not set
> > > # CONFIG_B44 is not set
> > > CONFIG_FORCEDETH=m
> > > # CONFIG_E100 is not set
> > > # CONFIG_FEALNX is not set
> > > # CONFIG_NATSEMI is not set
> > > # CONFIG_NE2K_PCI is not set
> > > # CONFIG_8139CP is not set
> > > # CONFIG_8139TOO is not set
> > > # CONFIG_R6040 is not set
> > > # CONFIG_SIS900 is not set
> > > # CONFIG_EPIC100 is not set
> > > # CONFIG_SMSC9420 is not set
> > > # CONFIG_SUNDANCE is not set
> > > # CONFIG_TLAN is not set
> > > # CONFIG_KS8851_MLL is not set
> > > # CONFIG_VIA_RHINE is not set
> > > # CONFIG_SC92031 is not set
> > > # CONFIG_ATL2 is not set
> > > CONFIG_NETDEV_1000=y
> > > # CONFIG_ACENIC is not set
> > > # CONFIG_DL2K is not set
> > > # CONFIG_E1000 is not set
> > > # CONFIG_E1000E is not set
> > > # CONFIG_IP1000 is not set
> > > # CONFIG_IGB is not set
> > > # CONFIG_IGBVF is not set
> > > # CONFIG_NS83820 is not set
> > > # CONFIG_HAMACHI is not set
> > > # CONFIG_YELLOWFIN is not set
> > > # CONFIG_R8169 is not set
> > > # CONFIG_SIS190 is not set
> > > # CONFIG_SKGE is not set
> > > # CONFIG_SKY2 is not set
> > > # CONFIG_VIA_VELOCITY is not set
> > > # CONFIG_TIGON3 is not set
> > > CONFIG_BNX2=m
> > > CONFIG_CNIC=m
> > > # CONFIG_QLA3XXX is not set
> > > # CONFIG_ATL1 is not set
> > > # CONFIG_ATL1E is not set
> > > # CONFIG_ATL1C is not set
> > > # CONFIG_JME is not set
> > > # CONFIG_STMMAC_ETH is not set
> > > # CONFIG_PCH_GBE is not set
> > > CONFIG_NETDEV_10000=y
> > > CONFIG_MDIO=m
> > > # CONFIG_CHELSIO_T1 is not set
> > > CONFIG_CHELSIO_T3_DEPENDS=y
> > > # CONFIG_CHELSIO_T3 is not set
> > > CONFIG_CHELSIO_T4_DEPENDS=y
> > > # CONFIG_CHELSIO_T4 is not set
> > > CONFIG_CHELSIO_T4VF_DEPENDS=y
> > > # CONFIG_CHELSIO_T4VF is not set
> > > # CONFIG_ENIC is not set
> > > # CONFIG_IXGBE is not set
> > > # CONFIG_IXGBEVF is not set
> > > # CONFIG_IXGB is not set
> > > # CONFIG_S2IO is not set
> > > # CONFIG_VXGE is not set
> > > # CONFIG_MYRI10GE is not set
> > > # CONFIG_NETXEN_NIC is not set
> > > # CONFIG_NIU is not set
> > > # CONFIG_MLX4_EN is not set
> > > # CONFIG_MLX4_CORE is not set
> > > # CONFIG_TEHUTI is not set
> > > # CONFIG_BNX2X is not set
> > > # CONFIG_QLCNIC is not set
> > > # CONFIG_QLGE is not set
> > > # CONFIG_BNA is not set
> > > CONFIG_SFC=m
> > > # CONFIG_BE2NET is not set
> > > # CONFIG_TR is not set
> > > CONFIG_WLAN=y
> > > # CONFIG_LIBERTAS_THINFIRM is not set
> > > # CONFIG_AIRO is not set
> > > # CONFIG_ATMEL is not set
> > > # CONFIG_AT76C50X_USB is not set
> > > # CONFIG_PRISM54 is not set
> > > # CONFIG_USB_ZD1201 is not set
> > > # CONFIG_USB_NET_RNDIS_WLAN is not set
> > > # CONFIG_RTL8180 is not set
> > > # CONFIG_RTL8187 is not set
> > > # CONFIG_ADM8211 is not set
> > > # CONFIG_MAC80211_HWSIM is not set
> > > # CONFIG_MWL8K is not set
> > > CONFIG_ATH_COMMON=m
> > > # CONFIG_ATH_DEBUG is not set
> > > CONFIG_ATH5K=m
> > > # CONFIG_ATH5K_DEBUG is not set
> > > # CONFIG_ATH9K is not set
> > > # CONFIG_ATH9K_HTC is not set
> > > # CONFIG_AR9170_USB is not set
> > > # CONFIG_CARL9170 is not set
> > > # CONFIG_B43 is not set
> > > # CONFIG_B43LEGACY is not set
> > > # CONFIG_HOSTAP is not set
> > > # CONFIG_IPW2100 is not set
> > > # CONFIG_IPW2200 is not set
> > > # CONFIG_IWLWIFI is not set
> > > # CONFIG_IWM is not set
> > > # CONFIG_LIBERTAS is not set
> > > # CONFIG_HERMES is not set
> > > # CONFIG_P54_COMMON is not set
> > > # CONFIG_RT2X00 is not set
> > > # CONFIG_WL1251 is not set
> > > # CONFIG_WL12XX is not set
> > > # CONFIG_ZD1211RW is not set
> > >
> > > #
> > > # Enable WiMAX (Networking options) to see the WiMAX drivers
> > > #
> > >
> > > #
> > > # USB Network Adapters
> > > #
> > > # CONFIG_USB_CATC is not set
> > > # CONFIG_USB_KAWETH is not set
> > > # CONFIG_USB_PEGASUS is not set
> > > # CONFIG_USB_RTL8150 is not set
> > > # CONFIG_USB_USBNET is not set
> > > # CONFIG_USB_IPHETH is not set
> > > CONFIG_WAN=y
> > > # CONFIG_HDLC is not set
> > > # CONFIG_DLCI is not set
> > > # CONFIG_SBNI is not set
> > >
> > > #
> > > # CAIF transport drivers
> > > #
> > > CONFIG_FDDI=y
> > > # CONFIG_DEFXX is not set
> > > # CONFIG_SKFP is not set
> > > CONFIG_HIPPI=y
> > > # CONFIG_ROADRUNNER is not set
> > > # CONFIG_PPP is not set
> > > # CONFIG_SLIP is not set
> > > CONFIG_NET_FC=y
> > > # CONFIG_NETCONSOLE is not set
> > > # CONFIG_NETPOLL is not set
> > > # CONFIG_NET_POLL_CONTROLLER is not set
> > > # CONFIG_VMXNET3 is not set
> > > # CONFIG_ISDN is not set
> > > # CONFIG_PHONE is not set
> > >
> > > #
> > > # Input device support
> > > #
> > > CONFIG_INPUT=y
> > > CONFIG_INPUT_FF_MEMLESS=y
> > > # CONFIG_INPUT_POLLDEV is not set
> > > CONFIG_INPUT_SPARSEKMAP=m
> > >
> > > #
> > > # Userland interfaces
> > > #
> > > CONFIG_INPUT_MOUSEDEV=y
> > > CONFIG_INPUT_MOUSEDEV_PSAUX=y
> > > CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
> > > CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
> > > CONFIG_INPUT_JOYDEV=m
> > > CONFIG_INPUT_EVDEV=m
> > > # CONFIG_INPUT_EVBUG is not set
> > >
> > > #
> > > # Input Device Drivers
> > > #
> > > CONFIG_INPUT_KEYBOARD=y
> > > # CONFIG_KEYBOARD_ADP5588 is not set
> > > CONFIG_KEYBOARD_ATKBD=y
> > > # CONFIG_KEYBOARD_QT2160 is not set
> > > # CONFIG_KEYBOARD_LKKBD is not set
> > > # CONFIG_KEYBOARD_GPIO is not set
> > > # CONFIG_KEYBOARD_GPIO_POLLED is not set
> > > # CONFIG_KEYBOARD_TCA6416 is not set
> > > # CONFIG_KEYBOARD_MATRIX is not set
> > > # CONFIG_KEYBOARD_LM8323 is not set
> > > # CONFIG_KEYBOARD_MAX7359 is not set
> > > # CONFIG_KEYBOARD_MCS is not set
> > > # CONFIG_KEYBOARD_NEWTON is not set
> > > # CONFIG_KEYBOARD_OPENCORES is not set
> > > # CONFIG_KEYBOARD_STOWAWAY is not set
> > > # CONFIG_KEYBOARD_SUNKBD is not set
> > > # CONFIG_KEYBOARD_XTKBD is not set
> > > CONFIG_INPUT_MOUSE=y
> > > CONFIG_MOUSE_PS2=m
> > > CONFIG_MOUSE_PS2_ALPS=y
> > > CONFIG_MOUSE_PS2_LOGIPS2PP=y
> > > CONFIG_MOUSE_PS2_SYNAPTICS=y
> > > CONFIG_MOUSE_PS2_LIFEBOOK=y
> > > CONFIG_MOUSE_PS2_TRACKPOINT=y
> > > # CONFIG_MOUSE_PS2_ELANTECH is not set
> > > CONFIG_MOUSE_PS2_SENTELIC=y
> > > CONFIG_MOUSE_PS2_TOUCHKIT=y
> > > # CONFIG_MOUSE_SERIAL is not set
> > > # CONFIG_MOUSE_APPLETOUCH is not set
> > > # CONFIG_MOUSE_BCM5974 is not set
> > > # CONFIG_MOUSE_VSXXXAA is not set
> > > # CONFIG_MOUSE_GPIO is not set
> > > # CONFIG_MOUSE_SYNAPTICS_I2C is not set
> > > CONFIG_INPUT_JOYSTICK=y
> > > # CONFIG_JOYSTICK_ANALOG is not set
> > > # CONFIG_JOYSTICK_A3D is not set
> > > # CONFIG_JOYSTICK_ADI is not set
> > > # CONFIG_JOYSTICK_COBRA is not set
> > > # CONFIG_JOYSTICK_GF2K is not set
> > > # CONFIG_JOYSTICK_GRIP is not set
> > > # CONFIG_JOYSTICK_GRIP_MP is not set
> > > # CONFIG_JOYSTICK_GUILLEMOT is not set
> > > # CONFIG_JOYSTICK_INTERACT is not set
> > > # CONFIG_JOYSTICK_SIDEWINDER is not set
> > > # CONFIG_JOYSTICK_TMDC is not set
> > > # CONFIG_JOYSTICK_IFORCE is not set
> > > # CONFIG_JOYSTICK_WARRIOR is not set
> > > # CONFIG_JOYSTICK_MAGELLAN is not set
> > > # CONFIG_JOYSTICK_SPACEORB is not set
> > > # CONFIG_JOYSTICK_SPACEBALL is not set
> > > # CONFIG_JOYSTICK_STINGER is not set
> > > # CONFIG_JOYSTICK_TWIDJOY is not set
> > > # CONFIG_JOYSTICK_ZHENHUA is not set
> > > # CONFIG_JOYSTICK_JOYDUMP is not set
> > > # CONFIG_JOYSTICK_XPAD is not set
> > > CONFIG_INPUT_TABLET=y
> > > # CONFIG_TABLET_USB_ACECAD is not set
> > > # CONFIG_TABLET_USB_AIPTEK is not set
> > > # CONFIG_TABLET_USB_GTCO is not set
> > > # CONFIG_TABLET_USB_HANWANG is not set
> > > # CONFIG_TABLET_USB_KBTAB is not set
> > > # CONFIG_TABLET_USB_WACOM is not set
> > > CONFIG_INPUT_TOUCHSCREEN=y
> > > # CONFIG_TOUCHSCREEN_AD7879 is not set
> > > # CONFIG_TOUCHSCREEN_BU21013 is not set
> > > # CONFIG_TOUCHSCREEN_CY8CTMG110 is not set
> > > # CONFIG_TOUCHSCREEN_DYNAPRO is not set
> > > # CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
> > > # CONFIG_TOUCHSCREEN_EETI is not set
> > > # CONFIG_TOUCHSCREEN_FUJITSU is not set
> > > # CONFIG_TOUCHSCREEN_GUNZE is not set
> > > # CONFIG_TOUCHSCREEN_ELO is not set
> > > # CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
> > > # CONFIG_TOUCHSCREEN_MCS5000 is not set
> > > # CONFIG_TOUCHSCREEN_MTOUCH is not set
> > > # CONFIG_TOUCHSCREEN_INEXIO is not set
> > > # CONFIG_TOUCHSCREEN_MK712 is not set
> > > # CONFIG_TOUCHSCREEN_PENMOUNT is not set
> > > # CONFIG_TOUCHSCREEN_QT602240 is not set
> > > # CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
> > > # CONFIG_TOUCHSCREEN_TOUCHWIN is not set
> > > # CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
> > > # CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
> > > # CONFIG_TOUCHSCREEN_TSC2007 is not set
> > > # CONFIG_TOUCHSCREEN_TPS6507X is not set
> > > CONFIG_INPUT_MISC=y
> > > # CONFIG_INPUT_AD714X is not set
> > > # CONFIG_INPUT_PCSPKR is not set
> > > # CONFIG_INPUT_APANEL is not set
> > > # CONFIG_INPUT_ATLAS_BTNS is not set
> > > # CONFIG_INPUT_ATI_REMOTE is not set
> > > # CONFIG_INPUT_ATI_REMOTE2 is not set
> > > # CONFIG_INPUT_KEYSPAN_REMOTE is not set
> > > # CONFIG_INPUT_POWERMATE is not set
> > > # CONFIG_INPUT_YEALINK is not set
> > > # CONFIG_INPUT_CM109 is not set
> > > # CONFIG_INPUT_UINPUT is not set
> > > # CONFIG_INPUT_WINBOND_CIR is not set
> > > # CONFIG_INPUT_PCF8574 is not set
> > > # CONFIG_INPUT_GPIO_ROTARY_ENCODER is not set
> > > # CONFIG_INPUT_ADXL34X is not set
> > >
> > > #
> > > # Hardware I/O ports
> > > #
> > > CONFIG_SERIO=y
> > > CONFIG_SERIO_I8042=y
> > > # CONFIG_SERIO_SERPORT is not set
> > > # CONFIG_SERIO_CT82C710 is not set
> > > # CONFIG_SERIO_PCIPS2 is not set
> > > CONFIG_SERIO_LIBPS2=y
> > > # CONFIG_SERIO_RAW is not set
> > > # CONFIG_SERIO_ALTERA_PS2 is not set
> > > # CONFIG_SERIO_PS2MULT is not set
> > > # CONFIG_GAMEPORT is not set
> > >
> > > #
> > > # Character devices
> > > #
> > > CONFIG_VT=y
> > > CONFIG_CONSOLE_TRANSLATIONS=y
> > > CONFIG_VT_CONSOLE=y
> > > # CONFIG_VT_CKO is not set
> > > CONFIG_HW_CONSOLE=y
> > > CONFIG_VT_HW_CONSOLE_BINDING=y
> > > CONFIG_DEVKMEM=y
> > > CONFIG_SERIAL_NONSTANDARD=y
> > > # CONFIG_COMPUTONE is not set
> > > # CONFIG_ROCKETPORT is not set
> > > # CONFIG_CYCLADES is not set
> > > # CONFIG_DIGIEPCA is not set
> > > # CONFIG_MOXA_INTELLIO is not set
> > > # CONFIG_MOXA_SMARTIO is not set
> > > # CONFIG_ISI is not set
> > > # CONFIG_SYNCLINK is not set
> > > # CONFIG_SYNCLINKMP is not set
> > > # CONFIG_SYNCLINK_GT is not set
> > > # CONFIG_N_HDLC is not set
> > > # CONFIG_N_GSM is not set
> > > # CONFIG_RISCOM8 is not set
> > > # CONFIG_SPECIALIX is not set
> > > CONFIG_STALDRV=y
> > > # CONFIG_STALLION is not set
> > > # CONFIG_ISTALLION is not set
> > > # CONFIG_NOZOMI is not set
> > >
> > > #
> > > # Serial drivers
> > > #
> > > CONFIG_SERIAL_8250=y
> > > CONFIG_SERIAL_8250_CONSOLE=y
> > > CONFIG_FIX_EARLYCON_MEM=y
> > > CONFIG_SERIAL_8250_PCI=y
> > > CONFIG_SERIAL_8250_PNP=y
> > > CONFIG_SERIAL_8250_NR_UARTS=4
> > > CONFIG_SERIAL_8250_RUNTIME_UARTS=4
> > > CONFIG_SERIAL_8250_EXTENDED=y
> > > CONFIG_SERIAL_8250_MANY_PORTS=y
> > > CONFIG_SERIAL_8250_SHARE_IRQ=y
> > > CONFIG_SERIAL_8250_DETECT_IRQ=y
> > > CONFIG_SERIAL_8250_RSA=y
> > >
> > > #
> > > # Non-8250 serial port support
> > > #
> > > # CONFIG_SERIAL_MFD_HSU is not set
> > > CONFIG_SERIAL_CORE=y
> > > CONFIG_SERIAL_CORE_CONSOLE=y
> > > # CONFIG_SERIAL_JSM is not set
> > > # CONFIG_SERIAL_TIMBERDALE is not set
> > > # CONFIG_SERIAL_ALTERA_JTAGUART is not set
> > > # CONFIG_SERIAL_ALTERA_UART is not set
> > > CONFIG_UNIX98_PTYS=y
> > > # CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
> > > CONFIG_LEGACY_PTYS=y
> > > CONFIG_LEGACY_PTY_COUNT=32
> > > # CONFIG_IPMI_HANDLER is not set
> > > CONFIG_HW_RANDOM=y
> > > # CONFIG_HW_RANDOM_TIMERIOMEM is not set
> > > # CONFIG_HW_RANDOM_INTEL is not set
> > > # CONFIG_HW_RANDOM_AMD is not set
> > > # CONFIG_HW_RANDOM_VIA is not set
> > > # CONFIG_NVRAM is not set
> > > # CONFIG_R3964 is not set
> > > # CONFIG_APPLICOM is not set
> > > # CONFIG_MWAVE is not set
> > > # CONFIG_RAW_DRIVER is not set
> > > CONFIG_HPET=y
> > > CONFIG_HPET_MMAP=y
> > > # CONFIG_HANGCHECK_TIMER is not set
> > > # CONFIG_TCG_TPM is not set
> > > # CONFIG_TELCLOCK is not set
> > > CONFIG_DEVPORT=y
> > > # CONFIG_RAMOOPS is not set
> > > CONFIG_I2C=m
> > > CONFIG_I2C_BOARDINFO=y
> > > CONFIG_I2C_COMPAT=y
> > > # CONFIG_I2C_CHARDEV is not set
> > > # CONFIG_I2C_MUX is not set
> > > CONFIG_I2C_HELPER_AUTO=y
> > > CONFIG_I2C_ALGOBIT=m
> > >
> > > #
> > > # I2C Hardware Bus support
> > > #
> > >
> > > #
> > > # PC SMBus host controller drivers
> > > #
> > > # CONFIG_I2C_ALI1535 is not set
> > > # CONFIG_I2C_ALI1563 is not set
> > > # CONFIG_I2C_ALI15X3 is not set
> > > # CONFIG_I2C_AMD756 is not set
> > > # CONFIG_I2C_AMD8111 is not set
> > > # CONFIG_I2C_I801 is not set
> > > # CONFIG_I2C_ISCH is not set
> > > # CONFIG_I2C_PIIX4 is not set
> > > CONFIG_I2C_NFORCE2=m
> > > # CONFIG_I2C_NFORCE2_S4985 is not set
> > > # CONFIG_I2C_SIS5595 is not set
> > > # CONFIG_I2C_SIS630 is not set
> > > # CONFIG_I2C_SIS96X is not set
> > > # CONFIG_I2C_VIA is not set
> > > # CONFIG_I2C_VIAPRO is not set
> > >
> > > #
> > > # ACPI drivers
> > > #
> > > # CONFIG_I2C_SCMI is not set
> > >
> > > #
> > > # I2C system bus drivers (mostly embedded / system-on-chip)
> > > #
> > > # CONFIG_I2C_GPIO is not set
> > > # CONFIG_I2C_INTEL_MID is not set
> > > # CONFIG_I2C_OCORES is not set
> > > # CONFIG_I2C_PCA_PLATFORM is not set
> > > # CONFIG_I2C_SIMTEC is not set
> > > # CONFIG_I2C_XILINX is not set
> > >
> > > #
> > > # External I2C/SMBus adapter drivers
> > > #
> > > # CONFIG_I2C_PARPORT_LIGHT is not set
> > > # CONFIG_I2C_TAOS_EVM is not set
> > > # CONFIG_I2C_TINY_USB is not set
> > >
> > > #
> > > # Other I2C/SMBus bus drivers
> > > #
> > > # CONFIG_I2C_STUB is not set
> > > # CONFIG_I2C_DEBUG_CORE is not set
> > > # CONFIG_I2C_DEBUG_ALGO is not set
> > > # CONFIG_I2C_DEBUG_BUS is not set
> > > # CONFIG_SPI is not set
> > >
> > > #
> > > # PPS support
> > > #
> > > # CONFIG_PPS is not set
> > > CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
> > > CONFIG_GPIOLIB=y
> > > # CONFIG_DEBUG_GPIO is not set
> > > CONFIG_GPIO_SYSFS=y
> > >
> > > #
> > > # Memory mapped GPIO expanders:
> > > #
> > > # CONFIG_GPIO_BASIC_MMIO is not set
> > > # CONFIG_GPIO_IT8761E is not set
> > > # CONFIG_GPIO_SCH is not set
> > > # CONFIG_GPIO_VX855 is not set
> > >
> > > #
> > > # I2C GPIO expanders:
> > > #
> > > # CONFIG_GPIO_MAX7300 is not set
> > > # CONFIG_GPIO_MAX732X is not set
> > > # CONFIG_GPIO_PCA953X is not set
> > > # CONFIG_GPIO_PCF857X is not set
> > > # CONFIG_GPIO_ADP5588 is not set
> > >
> > > #
> > > # PCI GPIO expanders:
> > > #
> > > # CONFIG_GPIO_CS5535 is not set
> > > # CONFIG_GPIO_BT8XX is not set
> > > # CONFIG_GPIO_LANGWELL is not set
> > > # CONFIG_GPIO_PCH is not set
> > > # CONFIG_GPIO_RDC321X is not set
> > >
> > > #
> > > # SPI GPIO expanders:
> > > #
> > >
> > > #
> > > # AC97 GPIO expanders:
> > > #
> > >
> > > #
> > > # MODULbus GPIO expanders:
> > > #
> > > # CONFIG_W1 is not set
> > > CONFIG_POWER_SUPPLY=y
> > > # CONFIG_POWER_SUPPLY_DEBUG is not set
> > > # CONFIG_PDA_POWER is not set
> > > # CONFIG_TEST_POWER is not set
> > > # CONFIG_BATTERY_DS2782 is not set
> > > # CONFIG_BATTERY_BQ20Z75 is not set
> > > # CONFIG_BATTERY_BQ27x00 is not set
> > > # CONFIG_BATTERY_MAX17040 is not set
> > > CONFIG_HWMON=m
> > > # CONFIG_HWMON_VID is not set
> > > # CONFIG_HWMON_DEBUG_CHIP is not set
> > >
> > > #
> > > # Native drivers
> > > #
> > > # CONFIG_SENSORS_ABITUGURU is not set
> > > # CONFIG_SENSORS_ABITUGURU3 is not set
> > > # CONFIG_SENSORS_AD7414 is not set
> > > # CONFIG_SENSORS_AD7418 is not set
> > > # CONFIG_SENSORS_ADM1021 is not set
> > > # CONFIG_SENSORS_ADM1025 is not set
> > > # CONFIG_SENSORS_ADM1026 is not set
> > > # CONFIG_SENSORS_ADM1029 is not set
> > > # CONFIG_SENSORS_ADM1031 is not set
> > > # CONFIG_SENSORS_ADM9240 is not set
> > > # CONFIG_SENSORS_ADT7411 is not set
> > > # CONFIG_SENSORS_ADT7462 is not set
> > > # CONFIG_SENSORS_ADT7470 is not set
> > > # CONFIG_SENSORS_ADT7475 is not set
> > > # CONFIG_SENSORS_ASC7621 is not set
> > > CONFIG_SENSORS_K8TEMP=m
> > > CONFIG_SENSORS_K10TEMP=m
> > > # CONFIG_SENSORS_ASB100 is not set
> > > # CONFIG_SENSORS_ATXP1 is not set
> > > # CONFIG_SENSORS_DS1621 is not set
> > > # CONFIG_SENSORS_I5K_AMB is not set
> > > # CONFIG_SENSORS_F71805F is not set
> > > # CONFIG_SENSORS_F71882FG is not set
> > > # CONFIG_SENSORS_F75375S is not set
> > > # CONFIG_SENSORS_FSCHMD is not set
> > > # CONFIG_SENSORS_G760A is not set
> > > # CONFIG_SENSORS_GL518SM is not set
> > > # CONFIG_SENSORS_GL520SM is not set
> > > # CONFIG_SENSORS_GPIO_FAN is not set
> > > # CONFIG_SENSORS_CORETEMP is not set
> > > # CONFIG_SENSORS_PKGTEMP is not set
> > > # CONFIG_SENSORS_IT87 is not set
> > > # CONFIG_SENSORS_JC42 is not set
> > > # CONFIG_SENSORS_LM63 is not set
> > > # CONFIG_SENSORS_LM73 is not set
> > > # CONFIG_SENSORS_LM75 is not set
> > > # CONFIG_SENSORS_LM77 is not set
> > > # CONFIG_SENSORS_LM78 is not set
> > > # CONFIG_SENSORS_LM80 is not set
> > > # CONFIG_SENSORS_LM83 is not set
> > > # CONFIG_SENSORS_LM85 is not set
> > > # CONFIG_SENSORS_LM87 is not set
> > > # CONFIG_SENSORS_LM90 is not set
> > > # CONFIG_SENSORS_LM92 is not set
> > > # CONFIG_SENSORS_LM93 is not set
> > > # CONFIG_SENSORS_LTC4215 is not set
> > > # CONFIG_SENSORS_LTC4245 is not set
> > > # CONFIG_SENSORS_LTC4261 is not set
> > > # CONFIG_SENSORS_LM95241 is not set
> > > # CONFIG_SENSORS_MAX1619 is not set
> > > # CONFIG_SENSORS_MAX6650 is not set
> > > # CONFIG_SENSORS_PC87360 is not set
> > > # CONFIG_SENSORS_PC87427 is not set
> > > # CONFIG_SENSORS_PCF8591 is not set
> > > # CONFIG_SENSORS_SHT15 is not set
> > > # CONFIG_SENSORS_SIS5595 is not set
> > > # CONFIG_SENSORS_SMM665 is not set
> > > # CONFIG_SENSORS_DME1737 is not set
> > > # CONFIG_SENSORS_EMC1403 is not set
> > > # CONFIG_SENSORS_EMC2103 is not set
> > > # CONFIG_SENSORS_SMSC47M1 is not set
> > > # CONFIG_SENSORS_SMSC47M192 is not set
> > > # CONFIG_SENSORS_SMSC47B397 is not set
> > > # CONFIG_SENSORS_ADS7828 is not set
> > > # CONFIG_SENSORS_AMC6821 is not set
> > > # CONFIG_SENSORS_THMC50 is not set
> > > # CONFIG_SENSORS_TMP102 is not set
> > > # CONFIG_SENSORS_TMP401 is not set
> > > # CONFIG_SENSORS_TMP421 is not set
> > > # CONFIG_SENSORS_VIA_CPUTEMP is not set
> > > # CONFIG_SENSORS_VIA686A is not set
> > > # CONFIG_SENSORS_VT1211 is not set
> > > # CONFIG_SENSORS_VT8231 is not set
> > > # CONFIG_SENSORS_W83781D is not set
> > > # CONFIG_SENSORS_W83791D is not set
> > > # CONFIG_SENSORS_W83792D is not set
> > > # CONFIG_SENSORS_W83793 is not set
> > > # CONFIG_SENSORS_W83795 is not set
> > > # CONFIG_SENSORS_W83L785TS is not set
> > > # CONFIG_SENSORS_W83L786NG is not set
> > > # CONFIG_SENSORS_W83627HF is not set
> > > # CONFIG_SENSORS_W83627EHF is not set
> > > # CONFIG_SENSORS_LIS3_I2C is not set
> > > # CONFIG_SENSORS_APPLESMC is not set
> > >
> > > #
> > > # ACPI drivers
> > > #
> > > # CONFIG_SENSORS_ATK0110 is not set
> > > # CONFIG_SENSORS_LIS3LV02D is not set
> > > CONFIG_THERMAL=m
> > > CONFIG_THERMAL_HWMON=y
> > > # CONFIG_WATCHDOG is not set
> > > CONFIG_SSB_POSSIBLE=y
> > >
> > > #
> > > # Sonics Silicon Backplane
> > > #
> > > # CONFIG_SSB is not set
> > > # CONFIG_MFD_SUPPORT is not set
> > > # CONFIG_REGULATOR is not set
> > > CONFIG_MEDIA_SUPPORT=m
> > >
> > > #
> > > # Multimedia core support
> > > #
> > > CONFIG_VIDEO_DEV=m
> > > CONFIG_VIDEO_V4L2_COMMON=m
> > > CONFIG_VIDEO_ALLOW_V4L1=y
> > > CONFIG_VIDEO_V4L1_COMPAT=y
> > > # CONFIG_DVB_CORE is not set
> > > CONFIG_VIDEO_MEDIA=m
> > >
> > > #
> > > # Multimedia drivers
> > > #
> > > # CONFIG_IR_CORE is not set
> > > # CONFIG_MEDIA_ATTACH is not set
> > > CONFIG_MEDIA_TUNER=m
> > > # CONFIG_MEDIA_TUNER_CUSTOMISE is not set
> > > CONFIG_MEDIA_TUNER_SIMPLE=m
> > > CONFIG_MEDIA_TUNER_TDA8290=m
> > > CONFIG_MEDIA_TUNER_TDA827X=m
> > > CONFIG_MEDIA_TUNER_TDA18271=m
> > > CONFIG_MEDIA_TUNER_TDA9887=m
> > > CONFIG_MEDIA_TUNER_TEA5761=m
> > > CONFIG_MEDIA_TUNER_TEA5767=m
> > > CONFIG_MEDIA_TUNER_MT20XX=m
> > > CONFIG_MEDIA_TUNER_XC2028=m
> > > CONFIG_MEDIA_TUNER_XC5000=m
> > > CONFIG_MEDIA_TUNER_MC44S803=m
> > > CONFIG_VIDEO_V4L2=m
> > > CONFIG_VIDEO_V4L1=m
> > > CONFIG_VIDEO_CAPTURE_DRIVERS=y
> > > # CONFIG_VIDEO_ADV_DEBUG is not set
> > > # CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
> > > # CONFIG_VIDEO_HELPER_CHIPS_AUTO is not set
> > >
> > > #
> > > # Encoders/decoders and other helper chips
> > > #
> > >
> > > #
> > > # Audio decoders
> > > #
> > > # CONFIG_VIDEO_TVAUDIO is not set
> > > # CONFIG_VIDEO_TDA7432 is not set
> > > # CONFIG_VIDEO_TDA9840 is not set
> > > # CONFIG_VIDEO_TDA9875 is not set
> > > # CONFIG_VIDEO_TEA6415C is not set
> > > # CONFIG_VIDEO_TEA6420 is not set
> > > # CONFIG_VIDEO_MSP3400 is not set
> > > # CONFIG_VIDEO_CS5345 is not set
> > > # CONFIG_VIDEO_CS53L32A is not set
> > > # CONFIG_VIDEO_M52790 is not set
> > > # CONFIG_VIDEO_TLV320AIC23B is not set
> > > # CONFIG_VIDEO_WM8775 is not set
> > > # CONFIG_VIDEO_WM8739 is not set
> > > # CONFIG_VIDEO_VP27SMPX is not set
> > >
> > > #
> > > # RDS decoders
> > > #
> > > # CONFIG_VIDEO_SAA6588 is not set
> > >
> > > #
> > > # Video decoders
> > > #
> > > # CONFIG_VIDEO_ADV7180 is not set
> > > # CONFIG_VIDEO_BT819 is not set
> > > # CONFIG_VIDEO_BT856 is not set
> > > # CONFIG_VIDEO_BT866 is not set
> > > # CONFIG_VIDEO_KS0127 is not set
> > > # CONFIG_VIDEO_OV7670 is not set
> > > # CONFIG_VIDEO_MT9V011 is not set
> > > # CONFIG_VIDEO_TCM825X is not set
> > > # CONFIG_VIDEO_SAA7110 is not set
> > > # CONFIG_VIDEO_SAA711X is not set
> > > # CONFIG_VIDEO_SAA717X is not set
> > > # CONFIG_VIDEO_SAA7191 is not set
> > > # CONFIG_VIDEO_TVP514X is not set
> > > # CONFIG_VIDEO_TVP5150 is not set
> > > # CONFIG_VIDEO_TVP7002 is not set
> > > # CONFIG_VIDEO_VPX3220 is not set
> > >
> > > #
> > > # Video and audio decoders
> > > #
> > > # CONFIG_VIDEO_CX25840 is not set
> > >
> > > #
> > > # MPEG video encoders
> > > #
> > > # CONFIG_VIDEO_CX2341X is not set
> > >
> > > #
> > > # Video encoders
> > > #
> > > # CONFIG_VIDEO_SAA7127 is not set
> > > # CONFIG_VIDEO_SAA7185 is not set
> > > # CONFIG_VIDEO_ADV7170 is not set
> > > # CONFIG_VIDEO_ADV7175 is not set
> > > # CONFIG_VIDEO_THS7303 is not set
> > > # CONFIG_VIDEO_ADV7343 is not set
> > > # CONFIG_VIDEO_AK881X is not set
> > >
> > > #
> > > # Video improvement chips
> > > #
> > > # CONFIG_VIDEO_UPD64031A is not set
> > > # CONFIG_VIDEO_UPD64083 is not set
> > > # CONFIG_VIDEO_VIVI is not set
> > > # CONFIG_VIDEO_CPIA2 is not set
> > > # CONFIG_VIDEO_ZORAN is not set
> > > # CONFIG_VIDEO_SAA7134 is not set
> > > # CONFIG_VIDEO_MXB is not set
> > > # CONFIG_VIDEO_HEXIUM_ORION is not set
> > > # CONFIG_VIDEO_HEXIUM_GEMINI is not set
> > > # CONFIG_VIDEO_CAFE_CCIC is not set
> > > # CONFIG_VIDEO_SR030PC30 is not set
> > > # CONFIG_SOC_CAMERA is not set
> > > CONFIG_V4L_USB_DRIVERS=y
> > > CONFIG_USB_VIDEO_CLASS=m
> > > CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV=y
> > > # CONFIG_USB_GSPCA is not set
> > > # CONFIG_VIDEO_PVRUSB2 is not set
> > > # CONFIG_VIDEO_HDPVR is not set
> > > # CONFIG_VIDEO_USBVISION is not set
> > > # CONFIG_USB_VICAM is not set
> > > # CONFIG_USB_IBMCAM is not set
> > > # CONFIG_USB_KONICAWC is not set
> > > # CONFIG_USB_ET61X251 is not set
> > > # CONFIG_USB_SE401 is not set
> > > # CONFIG_USB_SN9C102 is not set
> > > # CONFIG_USB_PWC is not set
> > > # CONFIG_USB_ZR364XX is not set
> > > # CONFIG_USB_STKWEBCAM is not set
> > > # CONFIG_USB_S2255 is not set
> > > # CONFIG_V4L_MEM2MEM_DRIVERS is not set
> > > # CONFIG_RADIO_ADAPTERS is not set
> > > # CONFIG_DAB is not set
> > >
> > > #
> > > # Graphics support
> > > #
> > > CONFIG_AGP=m
> > > CONFIG_AGP_AMD64=m
> > > # CONFIG_AGP_INTEL is not set
> > > # CONFIG_AGP_SIS is not set
> > > # CONFIG_AGP_VIA is not set
> > > CONFIG_VGA_ARB=y
> > > CONFIG_VGA_ARB_MAX_GPUS=16
> > > # CONFIG_VGA_SWITCHEROO is not set
> > > CONFIG_DRM=m
> > > CONFIG_DRM_KMS_HELPER=m
> > > CONFIG_DRM_TTM=m
> > > # CONFIG_DRM_TDFX is not set
> > > # CONFIG_DRM_R128 is not set
> > > # CONFIG_DRM_RADEON is not set
> > > # CONFIG_DRM_MGA is not set
> > > # CONFIG_DRM_SIS is not set
> > > # CONFIG_DRM_VIA is not set
> > > # CONFIG_DRM_SAVAGE is not set
> > > # CONFIG_STUB_POULSBO is not set
> > > # CONFIG_VGASTATE is not set
> > > CONFIG_VIDEO_OUTPUT_CONTROL=m
> > > CONFIG_FB=y
> > > CONFIG_FIRMWARE_EDID=y
> > > # CONFIG_FB_DDC is not set
> > > CONFIG_FB_BOOT_VESA_SUPPORT=y
> > > CONFIG_FB_CFB_FILLRECT=y
> > > CONFIG_FB_CFB_COPYAREA=y
> > > CONFIG_FB_CFB_IMAGEBLIT=y
> > > # CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
> > > # CONFIG_FB_SYS_FILLRECT is not set
> > > # CONFIG_FB_SYS_COPYAREA is not set
> > > # CONFIG_FB_SYS_IMAGEBLIT is not set
> > > # CONFIG_FB_FOREIGN_ENDIAN is not set
> > > # CONFIG_FB_SYS_FOPS is not set
> > > # CONFIG_FB_SVGALIB is not set
> > > # CONFIG_FB_MACMODES is not set
> > > CONFIG_FB_BACKLIGHT=y
> > > CONFIG_FB_MODE_HELPERS=y
> > > CONFIG_FB_TILEBLITTING=y
> > >
> > > #
> > > # Frame buffer hardware drivers
> > > #
> > > # CONFIG_FB_CIRRUS is not set
> > > # CONFIG_FB_PM2 is not set
> > > # CONFIG_FB_CYBER2000 is not set
> > > # CONFIG_FB_ARC is not set
> > > # CONFIG_FB_ASILIANT is not set
> > > # CONFIG_FB_IMSTT is not set
> > > # CONFIG_FB_VGA16 is not set
> > > CONFIG_FB_VESA=y
> > > # CONFIG_FB_EFI is not set
> > > # CONFIG_FB_N411 is not set
> > > # CONFIG_FB_HGA is not set
> > > # CONFIG_FB_S1D13XXX is not set
> > > # CONFIG_FB_NVIDIA is not set
> > > # CONFIG_FB_RIVA is not set
> > > # CONFIG_FB_LE80578 is not set
> > > # CONFIG_FB_MATROX is not set
> > > # CONFIG_FB_RADEON is not set
> > > # CONFIG_FB_ATY128 is not set
> > > # CONFIG_FB_ATY is not set
> > > # CONFIG_FB_S3 is not set
> > > # CONFIG_FB_SAVAGE is not set
> > > # CONFIG_FB_SIS is not set
> > > # CONFIG_FB_VIA is not set
> > > # CONFIG_FB_NEOMAGIC is not set
> > > # CONFIG_FB_KYRO is not set
> > > # CONFIG_FB_3DFX is not set
> > > # CONFIG_FB_VOODOO1 is not set
> > > # CONFIG_FB_VT8623 is not set
> > > # CONFIG_FB_TRIDENT is not set
> > > # CONFIG_FB_ARK is not set
> > > # CONFIG_FB_PM3 is not set
> > > # CONFIG_FB_CARMINE is not set
> > > # CONFIG_FB_GEODE is not set
> > > # CONFIG_FB_VIRTUAL is not set
> > > # CONFIG_FB_METRONOME is not set
> > > # CONFIG_FB_MB862XX is not set
> > > # CONFIG_FB_BROADSHEET is not set
> > > CONFIG_BACKLIGHT_LCD_SUPPORT=y
> > > # CONFIG_LCD_CLASS_DEVICE is not set
> > > CONFIG_BACKLIGHT_CLASS_DEVICE=y
> > > # CONFIG_BACKLIGHT_GENERIC is not set
> > > # CONFIG_BACKLIGHT_PROGEAR is not set
> > > # CONFIG_BACKLIGHT_MBP_NVIDIA is not set
> > > # CONFIG_BACKLIGHT_SAHARA is not set
> > > # CONFIG_BACKLIGHT_ADP8860 is not set
> > >
> > > #
> > > # Display device support
> > > #
> > > # CONFIG_DISPLAY_SUPPORT is not set
> > >
> > > #
> > > # Console display driver support
> > > #
> > > CONFIG_VGA_CONSOLE=y
> > > CONFIG_VGACON_SOFT_SCROLLBACK=y
> > > CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=1024
> > > CONFIG_DUMMY_CONSOLE=y
> > > CONFIG_FRAMEBUFFER_CONSOLE=y
> > > # CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY is not set
> > > # CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
> > > # CONFIG_FONTS is not set
> > > CONFIG_FONT_8x8=y
> > > CONFIG_FONT_8x16=y
> > > CONFIG_LOGO=y
> > > CONFIG_LOGO_RANDOM=y
> > >
> > > #
> > > # Available logos
> > > #
> > > CONFIG_LOGO_ZEN_CLUT224=y
> > > # CONFIG_LOGO_LINUX_MONO is not set
> > > # CONFIG_LOGO_LINUX_VGA16 is not set
> > > CONFIG_LOGO_LINUX_CLUT224=y
> > > # CONFIG_LOGO_OLDZEN_CLUT224 is not set
> > > # CONFIG_LOGO_ARCH_CLUT224 is not set
> > > # CONFIG_LOGO_GENTOO_CLUT224 is not set
> > > # CONFIG_LOGO_EXHERBO_CLUT224 is not set
> > > # CONFIG_LOGO_SLACKWARE_CLUT224 is not set
> > > # CONFIG_LOGO_DEBIAN_CLUT224 is not set
> > > # CONFIG_LOGO_FEDORASIMPLE_CLUT224 is not set
> > > # CONFIG_LOGO_FEDORAGLOSSY_CLUT224 is not set
> > > # CONFIG_LOGO_TITS_CLUT224 is not set
> > > # CONFIG_LOGO_BSD_CLUT224 is not set
> > > # CONFIG_LOGO_FBSD_CLUT224 is not set
> > > CONFIG_SOUND=m
> > > CONFIG_SOUND_OSS_CORE=y
> > > CONFIG_SOUND_OSS_CORE_PRECLAIM=y
> > > CONFIG_SND=m
> > > CONFIG_SND_TIMER=m
> > > CONFIG_SND_PCM=m
> > > CONFIG_SND_HWDEP=m
> > > CONFIG_SND_RAWMIDI=m
> > > CONFIG_SND_JACK=y
> > > CONFIG_SND_SEQUENCER=m
> > > CONFIG_SND_SEQ_DUMMY=m
> > > CONFIG_SND_OSSEMUL=y
> > > CONFIG_SND_MIXER_OSS=m
> > > CONFIG_SND_PCM_OSS=m
> > > CONFIG_SND_PCM_OSS_PLUGINS=y
> > > CONFIG_SND_SEQUENCER_OSS=y
> > > CONFIG_SND_HRTIMER=m
> > > CONFIG_SND_SEQ_HRTIMER_DEFAULT=y
> > > CONFIG_SND_DYNAMIC_MINORS=y
> > > # CONFIG_SND_SUPPORT_OLD_API is not set
> > > CONFIG_SND_VERBOSE_PROCFS=y
> > > # CONFIG_SND_VERBOSE_PRINTK is not set
> > > # CONFIG_SND_DEBUG is not set
> > > CONFIG_SND_VMASTER=y
> > > CONFIG_SND_DMA_SGBUF=y
> > > CONFIG_SND_RAWMIDI_SEQ=m
> > > # CONFIG_SND_OPL3_LIB_SEQ is not set
> > > # CONFIG_SND_OPL4_LIB_SEQ is not set
> > > # CONFIG_SND_SBAWE_SEQ is not set
> > > # CONFIG_SND_EMU10K1_SEQ is not set
> > > CONFIG_SND_DRIVERS=y
> > > # CONFIG_SND_PCSP is not set
> > > CONFIG_SND_DUMMY=m
> > > # CONFIG_SND_ALOOP is not set
> > > CONFIG_SND_VIRMIDI=m
> > > # CONFIG_SND_MTPAV is not set
> > > # CONFIG_SND_SERIAL_U16550 is not set
> > > # CONFIG_SND_MPU401 is not set
> > > CONFIG_SND_PCI=y
> > > # CONFIG_SND_AD1889 is not set
> > > # CONFIG_SND_ALS300 is not set
> > > # CONFIG_SND_ALS4000 is not set
> > > # CONFIG_SND_ALI5451 is not set
> > > # CONFIG_SND_ASIHPI is not set
> > > # CONFIG_SND_ATIIXP is not set
> > > # CONFIG_SND_ATIIXP_MODEM is not set
> > > # CONFIG_SND_AU8810 is not set
> > > # CONFIG_SND_AU8820 is not set
> > > # CONFIG_SND_AU8830 is not set
> > > # CONFIG_SND_AW2 is not set
> > > # CONFIG_SND_AZT3328 is not set
> > > # CONFIG_SND_BT87X is not set
> > > # CONFIG_SND_CA0106 is not set
> > > # CONFIG_SND_CMIPCI is not set
> > > # CONFIG_SND_OXYGEN is not set
> > > # CONFIG_SND_CS4281 is not set
> > > # CONFIG_SND_CS46XX is not set
> > > # CONFIG_SND_CS5530 is not set
> > > # CONFIG_SND_CS5535AUDIO is not set
> > > # CONFIG_SND_CTXFI is not set
> > > # CONFIG_SND_DARLA20 is not set
> > > # CONFIG_SND_GINA20 is not set
> > > # CONFIG_SND_LAYLA20 is not set
> > > # CONFIG_SND_DARLA24 is not set
> > > # CONFIG_SND_GINA24 is not set
> > > # CONFIG_SND_LAYLA24 is not set
> > > # CONFIG_SND_MONA is not set
> > > # CONFIG_SND_MIA is not set
> > > # CONFIG_SND_ECHO3G is not set
> > > # CONFIG_SND_INDIGO is not set
> > > # CONFIG_SND_INDIGOIO is not set
> > > # CONFIG_SND_INDIGODJ is not set
> > > # CONFIG_SND_INDIGOIOX is not set
> > > # CONFIG_SND_INDIGODJX is not set
> > > # CONFIG_SND_EMU10K1 is not set
> > > # CONFIG_SND_EMU10K1X is not set
> > > # CONFIG_SND_ENS1370 is not set
> > > # CONFIG_SND_ENS1371 is not set
> > > # CONFIG_SND_ES1938 is not set
> > > # CONFIG_SND_ES1968 is not set
> > > # CONFIG_SND_FM801 is not set
> > > CONFIG_SND_HDA_INTEL=m
> > > CONFIG_SND_HDA_HWDEP=y
> > > CONFIG_SND_HDA_RECONFIG=y
> > > # CONFIG_SND_HDA_INPUT_BEEP is not set
> > > CONFIG_SND_HDA_INPUT_JACK=y
> > > CONFIG_SND_HDA_PATCH_LOADER=y
> > > # CONFIG_SND_HDA_CODEC_REALTEK is not set
> > > # CONFIG_SND_HDA_CODEC_ANALOG is not set
> > > # CONFIG_SND_HDA_CODEC_SIGMATEL is not set
> > > # CONFIG_SND_HDA_CODEC_VIA is not set
> > > # CONFIG_SND_HDA_CODEC_HDMI is not set
> > > # CONFIG_SND_HDA_CODEC_CIRRUS is not set
> > > CONFIG_SND_HDA_CODEC_CONEXANT=y
> > > # CONFIG_SND_HDA_CODEC_CA0110 is not set
> > > # CONFIG_SND_HDA_CODEC_CMEDIA is not set
> > > # CONFIG_SND_HDA_CODEC_SI3054 is not set
> > > # CONFIG_SND_HDA_GENERIC is not set
> > > CONFIG_SND_HDA_POWER_SAVE=y
> > > CONFIG_SND_HDA_POWER_SAVE_DEFAULT=10
> > > # CONFIG_SND_HDSP is not set
> > > # CONFIG_SND_HDSPM is not set
> > > # CONFIG_SND_HIFIER is not set
> > > # CONFIG_SND_ICE1712 is not set
> > > # CONFIG_SND_ICE1724 is not set
> > > # CONFIG_SND_INTEL8X0 is not set
> > > # CONFIG_SND_INTEL8X0M is not set
> > > # CONFIG_SND_KORG1212 is not set
> > > # CONFIG_SND_LX6464ES is not set
> > > # CONFIG_SND_MAESTRO3 is not set
> > > # CONFIG_SND_MIXART is not set
> > > # CONFIG_SND_NM256 is not set
> > > # CONFIG_SND_PCXHR is not set
> > > # CONFIG_SND_RIPTIDE is not set
> > > # CONFIG_SND_RME32 is not set
> > > # CONFIG_SND_RME96 is not set
> > > # CONFIG_SND_RME9652 is not set
> > > # CONFIG_SND_SONICVIBES is not set
> > > # CONFIG_SND_TRIDENT is not set
> > > # CONFIG_SND_VIA82XX is not set
> > > # CONFIG_SND_VIA82XX_MODEM is not set
> > > # CONFIG_SND_VIRTUOSO is not set
> > > # CONFIG_SND_VX222 is not set
> > > # CONFIG_SND_YMFPCI is not set
> > > CONFIG_SND_USB=y
> > > # CONFIG_SND_USB_AUDIO is not set
> > > # CONFIG_SND_USB_UA101 is not set
> > > # CONFIG_SND_USB_USX2Y is not set
> > > # CONFIG_SND_USB_CAIAQ is not set
> > > # CONFIG_SND_USB_US122L is not set
> > > # CONFIG_SND_SOC is not set
> > > # CONFIG_SOUND_PRIME is not set
> > > CONFIG_HID_SUPPORT=y
> > > # CONFIG_HID is not set
> > >
> > > #
> > > # USB Input Devices
> > > #
> > > # CONFIG_USB_HID is not set
> > > CONFIG_HID_PID=y
> > > CONFIG_USB_SUPPORT=y
> > > CONFIG_USB_ARCH_HAS_HCD=y
> > > CONFIG_USB_ARCH_HAS_OHCI=y
> > > CONFIG_USB_ARCH_HAS_EHCI=y
> > > CONFIG_USB=y
> > > # CONFIG_USB_DEBUG is not set
> > > CONFIG_USB_ANNOUNCE_NEW_DEVICES=y
> > >
> > > #
> > > # Miscellaneous USB options
> > > #
> > > CONFIG_USB_DEVICEFS=y
> > > CONFIG_USB_DEVICE_CLASS=y
> > > # CONFIG_USB_DYNAMIC_MINORS is not set
> > > CONFIG_USB_SUSPEND=y
> > > # CONFIG_USB_OTG is not set
> > > CONFIG_USB_MON=y
> > > # CONFIG_USB_WUSB is not set
> > > # CONFIG_USB_WUSB_CBAF is not set
> > >
> > > #
> > > # USB Host Controller Drivers
> > > #
> > > # CONFIG_USB_C67X00_HCD is not set
> > > # CONFIG_USB_XHCI_HCD is not set
> > > CONFIG_USB_EHCI_HCD=m
> > > CONFIG_USB_EHCI_ROOT_HUB_TT=y
> > > CONFIG_USB_EHCI_TT_NEWSCHED=y
> > > # CONFIG_USB_OXU210HP_HCD is not set
> > > # CONFIG_USB_ISP116X_HCD is not set
> > > # CONFIG_USB_ISP1760_HCD is not set
> > > # CONFIG_USB_ISP1362_HCD is not set
> > > CONFIG_USB_OHCI_HCD=m
> > > # CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
> > > # CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
> > > CONFIG_USB_OHCI_LITTLE_ENDIAN=y
> > > # CONFIG_USB_UHCI_HCD is not set
> > > # CONFIG_USB_SL811_HCD is not set
> > > # CONFIG_USB_R8A66597_HCD is not set
> > > # CONFIG_USB_WHCI_HCD is not set
> > > # CONFIG_USB_HWA_HCD is not set
> > >
> > > #
> > > # USB Device Class drivers
> > > #
> > > # CONFIG_USB_ACM is not set
> > > CONFIG_USB_PRINTER=m
> > > # CONFIG_USB_WDM is not set
> > > # CONFIG_USB_TMC is not set
> > >
> > > #
> > > # NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
> > > #
> > >
> > > #
> > > # also be needed; see USB_STORAGE Help for more info
> > > #
> > > CONFIG_USB_STORAGE=m
> > > # CONFIG_USB_STORAGE_DEBUG is not set
> > > # CONFIG_USB_STORAGE_DATAFAB is not set
> > > # CONFIG_USB_STORAGE_FREECOM is not set
> > > # CONFIG_USB_STORAGE_ISD200 is not set
> > > # CONFIG_USB_STORAGE_USBAT is not set
> > > # CONFIG_USB_STORAGE_SDDR09 is not set
> > > # CONFIG_USB_STORAGE_SDDR55 is not set
> > > # CONFIG_USB_STORAGE_JUMPSHOT is not set
> > > # CONFIG_USB_STORAGE_ALAUDA is not set
> > > # CONFIG_USB_STORAGE_ONETOUCH is not set
> > > # CONFIG_USB_STORAGE_KARMA is not set
> > > # CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
> > > # CONFIG_USB_UAS is not set
> > > # CONFIG_USB_LIBUSUAL is not set
> > >
> > > #
> > > # USB Imaging devices
> > > #
> > > # CONFIG_USB_MDC800 is not set
> > > # CONFIG_USB_MICROTEK is not set
> > >
> > > #
> > > # USB port drivers
> > > #
> > > # CONFIG_USB_SERIAL is not set
> > >
> > > #
> > > # USB Miscellaneous drivers
> > > #
> > > # CONFIG_USB_EMI62 is not set
> > > # CONFIG_USB_EMI26 is not set
> > > # CONFIG_USB_ADUTUX is not set
> > > # CONFIG_USB_SEVSEG is not set
> > > # CONFIG_USB_RIO500 is not set
> > > # CONFIG_USB_LEGOTOWER is not set
> > > # CONFIG_USB_LCD is not set
> > > # CONFIG_USB_LED is not set
> > > # CONFIG_USB_CYPRESS_CY7C63 is not set
> > > # CONFIG_USB_CYTHERM is not set
> > > # CONFIG_USB_IDMOUSE is not set
> > > # CONFIG_USB_FTDI_ELAN is not set
> > > # CONFIG_USB_APPLEDISPLAY is not set
> > > # CONFIG_USB_SISUSBVGA is not set
> > > # CONFIG_USB_LD is not set
> > > # CONFIG_USB_TRANCEVIBRATOR is not set
> > > # CONFIG_USB_IOWARRIOR is not set
> > > # CONFIG_USB_TEST is not set
> > > # CONFIG_USB_ISIGHTFW is not set
> > > # CONFIG_USB_YUREX is not set
> > > # CONFIG_USB_GADGET is not set
> > >
> > > #
> > > # OTG and related infrastructure
> > > #
> > > # CONFIG_USB_GPIO_VBUS is not set
> > > # CONFIG_NOP_USB_XCEIV is not set
> > > # CONFIG_UWB is not set
> > > CONFIG_MMC=m
> > > # CONFIG_MMC_DEBUG is not set
> > > # CONFIG_MMC_UNSAFE_RESUME is not set
> > >
> > > #
> > > # MMC/SD/SDIO Card Drivers
> > > #
> > > CONFIG_MMC_BLOCK=m
> > > CONFIG_MMC_BLOCK_MINORS=8
> > > CONFIG_MMC_BLOCK_BOUNCE=y
> > > # CONFIG_SDIO_UART is not set
> > > # CONFIG_MMC_TEST is not set
> > >
> > > #
> > > # MMC/SD/SDIO Host Controller Drivers
> > > #
> > > CONFIG_MMC_SDHCI=m
> > > CONFIG_MMC_SDHCI_PCI=m
> > > CONFIG_MMC_RICOH_MMC=y
> > > # CONFIG_MMC_SDHCI_PLTFM is not set
> > > # CONFIG_MMC_WBSD is not set
> > > # CONFIG_MMC_TIFM_SD is not set
> > > # CONFIG_MMC_CB710 is not set
> > > # CONFIG_MMC_VIA_SDMMC is not set
> > > # CONFIG_MMC_USHC is not set
> > > CONFIG_MEMSTICK=m
> > > # CONFIG_MEMSTICK_DEBUG is not set
> > >
> > > #
> > > # MemoryStick drivers
> > > #
> > > # CONFIG_MEMSTICK_UNSAFE_RESUME is not set
> > > CONFIG_MSPRO_BLOCK=m
> > >
> > > #
> > > # MemoryStick Host Controller Drivers
> > > #
> > > # CONFIG_MEMSTICK_TIFM_MS is not set
> > > # CONFIG_MEMSTICK_JMICRON_38X is not set
> > > CONFIG_NEW_LEDS=y
> > > CONFIG_LEDS_CLASS=y
> > >
> > > #
> > > # LED drivers
> > > #
> > > # CONFIG_LEDS_ALIX2 is not set
> > > # CONFIG_LEDS_PCA9532 is not set
> > > # CONFIG_LEDS_GPIO is not set
> > > # CONFIG_LEDS_LP3944 is not set
> > > # CONFIG_LEDS_LP5521 is not set
> > > # CONFIG_LEDS_LP5523 is not set
> > > # CONFIG_LEDS_CLEVO_MAIL is not set
> > > # CONFIG_LEDS_PCA955X is not set
> > > # CONFIG_LEDS_BD2802 is not set
> > > # CONFIG_LEDS_INTEL_SS4200 is not set
> > > # CONFIG_LEDS_LT3593 is not set
> > > # CONFIG_LEDS_DELL_NETBOOKS is not set
> > > CONFIG_LEDS_TRIGGERS=y
> > >
> > > #
> > > # LED Triggers
> > > #
> > > # CONFIG_LEDS_TRIGGER_TIMER is not set
> > > # CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
> > > # CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
> > > # CONFIG_LEDS_TRIGGER_GPIO is not set
> > > # CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set
> > >
> > > #
> > > # iptables trigger is under Netfilter config (LED target)
> > > #
> > > CONFIG_ACCESSIBILITY=y
> > > CONFIG_A11Y_BRAILLE_CONSOLE=y
> > > # CONFIG_INFINIBAND is not set
> > > # CONFIG_EDAC is not set
> > > CONFIG_RTC_LIB=m
> > > CONFIG_RTC_CLASS=m
> > >
> > > #
> > > # RTC interfaces
> > > #
> > > CONFIG_RTC_INTF_SYSFS=y
> > > CONFIG_RTC_INTF_PROC=y
> > > CONFIG_RTC_INTF_DEV=y
> > > CONFIG_RTC_INTF_DEV_UIE_EMUL=y
> > > # CONFIG_RTC_DRV_TEST is not set
> > >
> > > #
> > > # I2C RTC drivers
> > > #
> > > # CONFIG_RTC_DRV_DS1307 is not set
> > > # CONFIG_RTC_DRV_DS1374 is not set
> > > # CONFIG_RTC_DRV_DS1672 is not set
> > > # CONFIG_RTC_DRV_DS3232 is not set
> > > # CONFIG_RTC_DRV_MAX6900 is not set
> > > # CONFIG_RTC_DRV_RS5C372 is not set
> > > # CONFIG_RTC_DRV_ISL1208 is not set
> > > # CONFIG_RTC_DRV_ISL12022 is not set
> > > # CONFIG_RTC_DRV_X1205 is not set
> > > # CONFIG_RTC_DRV_PCF8563 is not set
> > > # CONFIG_RTC_DRV_PCF8583 is not set
> > > # CONFIG_RTC_DRV_M41T80 is not set
> > > # CONFIG_RTC_DRV_BQ32K is not set
> > > # CONFIG_RTC_DRV_S35390A is not set
> > > # CONFIG_RTC_DRV_FM3130 is not set
> > > # CONFIG_RTC_DRV_RX8581 is not set
> > > # CONFIG_RTC_DRV_RX8025 is not set
> > >
> > > #
> > > # SPI RTC drivers
> > > #
> > >
> > > #
> > > # Platform RTC drivers
> > > #
> > > CONFIG_RTC_DRV_CMOS=m
> > > # CONFIG_RTC_DRV_DS1286 is not set
> > > # CONFIG_RTC_DRV_DS1511 is not set
> > > # CONFIG_RTC_DRV_DS1553 is not set
> > > # CONFIG_RTC_DRV_DS1742 is not set
> > > # CONFIG_RTC_DRV_STK17TA8 is not set
> > > # CONFIG_RTC_DRV_M48T86 is not set
> > > # CONFIG_RTC_DRV_M48T35 is not set
> > > # CONFIG_RTC_DRV_M48T59 is not set
> > > # CONFIG_RTC_DRV_MSM6242 is not set
> > > # CONFIG_RTC_DRV_BQ4802 is not set
> > > # CONFIG_RTC_DRV_RP5C01 is not set
> > > # CONFIG_RTC_DRV_V3020 is not set
> > >
> > > #
> > > # on-CPU RTC drivers
> > > #
> > > CONFIG_DMADEVICES=y
> > > # CONFIG_DMADEVICES_DEBUG is not set
> > >
> > > #
> > > # DMA Devices
> > > #
> > > # CONFIG_INTEL_MID_DMAC is not set
> > > # CONFIG_INTEL_IOATDMA is not set
> > > # CONFIG_TIMB_DMA is not set
> > > # CONFIG_PCH_DMA is not set
> > > CONFIG_AUXDISPLAY=y
> > > CONFIG_UIO=m
> > > # CONFIG_UIO_CIF is not set
> > > # CONFIG_UIO_PDRV is not set
> > > # CONFIG_UIO_PDRV_GENIRQ is not set
> > > # CONFIG_UIO_AEC is not set
> > > # CONFIG_UIO_SERCOS3 is not set
> > > # CONFIG_UIO_PCI_GENERIC is not set
> > > # CONFIG_UIO_NETX is not set
> > > CONFIG_STAGING=y
> > > # CONFIG_STAGING_EXCLUDE_BUILD is not set
> > > # CONFIG_ET131X is not set
> > > # CONFIG_SLICOSS is not set
> > > # CONFIG_VIDEO_CPIA is not set
> > > # CONFIG_VIDEO_STRADIS is not set
> > > # CONFIG_USB_IP_COMMON is not set
> > > # CONFIG_W35UND is not set
> > > # CONFIG_PRISM2_USB is not set
> > > # CONFIG_ECHO is not set
> > > # CONFIG_BRCM80211 is not set
> > > # CONFIG_RT2860 is not set
> > > # CONFIG_RT2870 is not set
> > > # CONFIG_COMEDI is not set
> > > # CONFIG_ASUS_OLED is not set
> > > # CONFIG_R8187SE is not set
> > > # CONFIG_RTL8192U is not set
> > > # CONFIG_RTL8192E is not set
> > > # CONFIG_R8712U is not set
> > > # CONFIG_TRANZPORT is not set
> > > # CONFIG_POHMELFS is not set
> > > # CONFIG_AUTOFS_FS is not set
> > > # CONFIG_LINE6_USB is not set
> > > # CONFIG_DRM_VMWGFX is not set
> > > CONFIG_DRM_NOUVEAU=m
> > > CONFIG_DRM_NOUVEAU_BACKLIGHT=y
> > > CONFIG_DRM_NOUVEAU_DEBUG=y
> > >
> > > #
> > > # I2C encoder or helper chips
> > > #
> > > # CONFIG_DRM_I2C_CH7006 is not set
> > > # CONFIG_DRM_I2C_SIL164 is not set
> > > # CONFIG_VT6655 is not set
> > > # CONFIG_VT6656 is not set
> > > # CONFIG_FB_UDL is not set
> > > # CONFIG_HYPERV is not set
> > > # CONFIG_VME_BUS is not set
> > > # CONFIG_IIO is not set
> > > # CONFIG_ZRAM is not set
> > > # CONFIG_BATMAN_ADV is not set
> > > # CONFIG_FB_SM7XX is not set
> > > # CONFIG_VIDEO_DT3155 is not set
> > > # CONFIG_CRYSTALHD is not set
> > >
> > > #
> > > # Texas Instruments shared transport line discipline
> > > #
> > > # CONFIG_FB_XGI is not set
> > > # CONFIG_SMB_FS is not set
> > > # CONFIG_EASYCAP is not set
> > > # CONFIG_SOLO6X10 is not set
> > > # CONFIG_ACPI_QUICKSTART is not set
> > > CONFIG_MACH_NO_WESTBRIDGE=y
> > > # CONFIG_ATH6K_LEGACY is not set
> > > # CONFIG_USB_ENESTORAGE is not set
> > > # CONFIG_BCM_WIMAX is not set
> > > # CONFIG_FT1000 is not set
> > >
> > > #
> > > # Speakup console speech
> > > #
> > > # CONFIG_SPEAKUP is not set
> > > # CONFIG_VHBA is not set
> > > CONFIG_X86_PLATFORM_DEVICES=y
> > > # CONFIG_ACER_WMI is not set
> > > # CONFIG_ACERHDF is not set
> > > # CONFIG_ASUS_LAPTOP is not set
> > > # CONFIG_DELL_WMI is not set
> > > # CONFIG_FUJITSU_LAPTOP is not set
> > > CONFIG_HP_WMI=m
> > > # CONFIG_PANASONIC_LAPTOP is not set
> > > # CONFIG_THINKPAD_ACPI is not set
> > > # CONFIG_SENSORS_HDAPS is not set
> > > # CONFIG_INTEL_MENLOW is not set
> > > # CONFIG_EEEPC_WMI is not set
> > > CONFIG_ACPI_WMI=m
> > > # CONFIG_MSI_WMI is not set
> > > # CONFIG_ACPI_ASUS is not set
> > > # CONFIG_TOPSTAR_LAPTOP is not set
> > > # CONFIG_ACPI_TOSHIBA is not set
> > > # CONFIG_TOSHIBA_BT_RFKILL is not set
> > > # CONFIG_ACPI_CMPC is not set
> > > # CONFIG_INTEL_IPS is not set
> > > # CONFIG_IBM_RTL is not set
> > >
> > > #
> > > # Firmware Drivers
> > > #
> > > # CONFIG_EDD is not set
> > > CONFIG_FIRMWARE_MEMMAP=y
> > > # CONFIG_EFI_VARS is not set
> > > # CONFIG_DELL_RBU is not set
> > > # CONFIG_DCDBAS is not set
> > > CONFIG_DMIID=y
> > > CONFIG_ISCSI_IBFT_FIND=y
> > > # CONFIG_ISCSI_IBFT is not set
> > >
> > > #
> > > # File systems
> > > #
> > > CONFIG_EXT2_FS=y
> > > # CONFIG_EXT2_FS_XATTR is not set
> > > # CONFIG_EXT2_FS_XIP is not set
> > > CONFIG_EXT3_FS=y
> > > CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
> > > CONFIG_EXT3_FS_XATTR=y
> > > # CONFIG_EXT3_FS_POSIX_ACL is not set
> > > # CONFIG_EXT3_FS_SECURITY is not set
> > > CONFIG_EXT4_FS=y
> > > CONFIG_EXT4_FS_XATTR=y
> > > # CONFIG_EXT4_FS_POSIX_ACL is not set
> > > # CONFIG_EXT4_FS_SECURITY is not set
> > > # CONFIG_EXT4_DEBUG is not set
> > > CONFIG_JBD=y
> > > # CONFIG_JBD_DEBUG is not set
> > > CONFIG_JBD2=y
> > > # CONFIG_JBD2_DEBUG is not set
> > > CONFIG_FS_MBCACHE=y
> > > CONFIG_REISERFS_FS=y
> > > # CONFIG_REISERFS_CHECK is not set
> > > # CONFIG_REISERFS_PROC_INFO is not set
> > > # CONFIG_REISERFS_FS_XATTR is not set
> > > CONFIG_JFS_FS=y
> > > # CONFIG_JFS_POSIX_ACL is not set
> > > # CONFIG_JFS_SECURITY is not set
> > > # CONFIG_JFS_DEBUG is not set
> > > # CONFIG_JFS_STATISTICS is not set
> > > CONFIG_FS_POSIX_ACL=y
> > > CONFIG_XFS_FS=y
> > > # CONFIG_XFS_QUOTA is not set
> > > # CONFIG_XFS_POSIX_ACL is not set
> > > # CONFIG_XFS_RT is not set
> > > # CONFIG_XFS_DEBUG is not set
> > > # CONFIG_GFS2_FS is not set
> > > # CONFIG_OCFS2_FS is not set
> > > CONFIG_BTRFS_FS=y
> > > # CONFIG_BTRFS_FS_POSIX_ACL is not set
> > > CONFIG_NILFS2_FS=y
> > > CONFIG_EXPORTFS=y
> > > CONFIG_FILE_LOCKING=y
> > > CONFIG_FSNOTIFY=y
> > > CONFIG_DNOTIFY=y
> > > CONFIG_INOTIFY_USER=y
> > > CONFIG_FANOTIFY=y
> > > # CONFIG_FANOTIFY_ACCESS_PERMISSIONS is not set
> > > CONFIG_QUOTA=y
> > > CONFIG_QUOTA_NETLINK_INTERFACE=y
> > > # CONFIG_PRINT_QUOTA_WARNING is not set
> > > # CONFIG_QUOTA_DEBUG is not set
> > > # CONFIG_QFMT_V1 is not set
> > > # CONFIG_QFMT_V2 is not set
> > > CONFIG_QUOTACTL=y
> > > CONFIG_QUOTACTL_COMPAT=y
> > > # CONFIG_AUTOFS4_FS is not set
> > > CONFIG_FUSE_FS=m
> > > # CONFIG_CUSE is not set
> > > CONFIG_GENERIC_ACL=y
> > >
> > > #
> > > # Caches
> > > #
> > > # CONFIG_FSCACHE is not set
> > >
> > > #
> > > # CD-ROM/DVD Filesystems
> > > #
> > > CONFIG_ISO9660_FS=m
> > > CONFIG_JOLIET=y
> > > CONFIG_ZISOFS=y
> > > CONFIG_UDF_FS=m
> > > CONFIG_UDF_NLS=y
> > >
> > > #
> > > # DOS/FAT/NT Filesystems
> > > #
> > > CONFIG_FAT_FS=m
> > > CONFIG_MSDOS_FS=m
> > > CONFIG_VFAT_FS=m
> > > CONFIG_FAT_DEFAULT_CODEPAGE=437
> > > CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
> > > # CONFIG_NTFS_FS is not set
> > >
> > > #
> > > # Pseudo filesystems
> > > #
> > > CONFIG_PROC_FS=y
> > > CONFIG_PROC_KCORE=y
> > > CONFIG_PROC_SYSCTL=y
> > > CONFIG_PROC_PAGE_MONITOR=y
> > > CONFIG_SYSFS=y
> > > CONFIG_TMPFS=y
> > > CONFIG_TMPFS_POSIX_ACL=y
> > > # CONFIG_HUGETLBFS is not set
> > > # CONFIG_HUGETLB_PAGE is not set
> > > CONFIG_CONFIGFS_FS=y
> > > CONFIG_MISC_FILESYSTEMS=y
> > > # CONFIG_ADFS_FS is not set
> > > # CONFIG_AFFS_FS is not set
> > > # CONFIG_ECRYPT_FS is not set
> > > # CONFIG_HFS_FS is not set
> > > # CONFIG_HFSPLUS_FS is not set
> > > # CONFIG_BEFS_FS is not set
> > > # CONFIG_BFS_FS is not set
> > > # CONFIG_EFS_FS is not set
> > > # CONFIG_LOGFS is not set
> > > # CONFIG_CRAMFS is not set
> > > CONFIG_SQUASHFS=m
> > > CONFIG_SQUASHFS_XATTRS=y
> > > # CONFIG_SQUASHFS_LZMA is not set
> > > # CONFIG_SQUASHFS_EMBEDDED is not set
> > > CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
> > > # CONFIG_VXFS_FS is not set
> > > # CONFIG_MINIX_FS is not set
> > > # CONFIG_OMFS_FS is not set
> > > # CONFIG_HPFS_FS is not set
> > > # CONFIG_QNX4FS_FS is not set
> > > CONFIG_ROMFS_FS=y
> > > CONFIG_ROMFS_BACKED_BY_BLOCK=y
> > > CONFIG_ROMFS_ON_BLOCK=y
> > > # CONFIG_SYSV_FS is not set
> > > # CONFIG_UFS_FS is not set
> > > CONFIG_NETWORK_FILESYSTEMS=y
> > > CONFIG_NFS_FS=y
> > > CONFIG_NFS_V3=y
> > > # CONFIG_NFS_V3_ACL is not set
> > > CONFIG_NFS_V4=y
> > > # CONFIG_NFS_V4_1 is not set
> > > # CONFIG_NFS_USE_LEGACY_DNS is not set
> > > CONFIG_NFS_USE_KERNEL_DNS=y
> > > # CONFIG_NFS_USE_NEW_IDMAPPER is not set
> > > # CONFIG_NFSD is not set
> > > CONFIG_LOCKD=y
> > > CONFIG_LOCKD_V4=y
> > > CONFIG_NFS_COMMON=y
> > > CONFIG_SUNRPC=y
> > > CONFIG_SUNRPC_GSS=y
> > > CONFIG_RPCSEC_GSS_KRB5=y
> > > # CONFIG_CEPH_FS is not set
> > > # CONFIG_CIFS is not set
> > > # CONFIG_NCP_FS is not set
> > > # CONFIG_CODA_FS is not set
> > > # CONFIG_AFS_FS is not set
> > >
> > > #
> > > # Partition Types
> > > #
> > > CONFIG_PARTITION_ADVANCED=y
> > > # CONFIG_ACORN_PARTITION is not set
> > > CONFIG_OSF_PARTITION=y
> > > CONFIG_AMIGA_PARTITION=y
> > > # CONFIG_ATARI_PARTITION is not set
> > > CONFIG_MAC_PARTITION=y
> > > CONFIG_MSDOS_PARTITION=y
> > > CONFIG_BSD_DISKLABEL=y
> > > CONFIG_MINIX_SUBPARTITION=y
> > > CONFIG_SOLARIS_X86_PARTITION=y
> > > CONFIG_UNIXWARE_DISKLABEL=y
> > > # CONFIG_LDM_PARTITION is not set
> > > CONFIG_SGI_PARTITION=y
> > > # CONFIG_ULTRIX_PARTITION is not set
> > > CONFIG_SUN_PARTITION=y
> > > CONFIG_KARMA_PARTITION=y
> > > CONFIG_EFI_PARTITION=y
> > > # CONFIG_SYSV68_PARTITION is not set
> > > CONFIG_NLS=y
> > > CONFIG_NLS_DEFAULT="utf8"
> > > CONFIG_NLS_CODEPAGE_437=m
> > > # CONFIG_NLS_CODEPAGE_737 is not set
> > > # CONFIG_NLS_CODEPAGE_775 is not set
> > > # CONFIG_NLS_CODEPAGE_850 is not set
> > > # CONFIG_NLS_CODEPAGE_852 is not set
> > > # CONFIG_NLS_CODEPAGE_855 is not set
> > > # CONFIG_NLS_CODEPAGE_857 is not set
> > > # CONFIG_NLS_CODEPAGE_860 is not set
> > > # CONFIG_NLS_CODEPAGE_861 is not set
> > > # CONFIG_NLS_CODEPAGE_862 is not set
> > > # CONFIG_NLS_CODEPAGE_863 is not set
> > > # CONFIG_NLS_CODEPAGE_864 is not set
> > > # CONFIG_NLS_CODEPAGE_865 is not set
> > > # CONFIG_NLS_CODEPAGE_866 is not set
> > > # CONFIG_NLS_CODEPAGE_869 is not set
> > > # CONFIG_NLS_CODEPAGE_936 is not set
> > > # CONFIG_NLS_CODEPAGE_950 is not set
> > > # CONFIG_NLS_CODEPAGE_932 is not set
> > > # CONFIG_NLS_CODEPAGE_949 is not set
> > > # CONFIG_NLS_CODEPAGE_874 is not set
> > > # CONFIG_NLS_ISO8859_8 is not set
> > > # CONFIG_NLS_CODEPAGE_1250 is not set
> > > # CONFIG_NLS_CODEPAGE_1251 is not set
> > > CONFIG_NLS_ASCII=m
> > > CONFIG_NLS_ISO8859_1=m
> > > # CONFIG_NLS_ISO8859_2 is not set
> > > # CONFIG_NLS_ISO8859_3 is not set
> > > # CONFIG_NLS_ISO8859_4 is not set
> > > # CONFIG_NLS_ISO8859_5 is not set
> > > # CONFIG_NLS_ISO8859_6 is not set
> > > # CONFIG_NLS_ISO8859_7 is not set
> > > # CONFIG_NLS_ISO8859_9 is not set
> > > # CONFIG_NLS_ISO8859_13 is not set
> > > # CONFIG_NLS_ISO8859_14 is not set
> > > # CONFIG_NLS_ISO8859_15 is not set
> > > # CONFIG_NLS_KOI8_R is not set
> > > # CONFIG_NLS_KOI8_U is not set
> > > CONFIG_NLS_UTF8=m
> > > # CONFIG_DLM is not set
> > >
> > > #
> > > # Kernel hacking
> > > #
> > > CONFIG_TRACE_IRQFLAGS_SUPPORT=y
> > > CONFIG_PRINTK_TIME=y
> > > CONFIG_ENABLE_WARN_DEPRECATED=y
> > > CONFIG_ENABLE_MUST_CHECK=y
> > > CONFIG_FRAME_WARN=0
> > > CONFIG_MAGIC_SYSRQ=y
> > > CONFIG_STRIP_ASM_SYMS=y
> > > CONFIG_UNUSED_SYMBOLS=y
> > > CONFIG_DEBUG_FS=y
> > > # CONFIG_HEADERS_CHECK is not set
> > > CONFIG_DEBUG_KERNEL=y
> > > # CONFIG_DEBUG_SHIRQ is not set
> > > # CONFIG_LOCKUP_DETECTOR is not set
> > > # CONFIG_HARDLOCKUP_DETECTOR is not set
> > > CONFIG_DETECT_HUNG_TASK=y
> > > # CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
> > > CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
> > > CONFIG_SCHED_DEBUG=y
> > > # CONFIG_SCHEDSTATS is not set
> > > CONFIG_TIMER_STATS=y
> > > # CONFIG_DEBUG_OBJECTS is not set
> > > # CONFIG_SLUB_DEBUG_ON is not set
> > > # CONFIG_SLUB_STATS is not set
> > > CONFIG_DEBUG_PREEMPT=y
> > > # CONFIG_DEBUG_RT_MUTEXES is not set
> > > # CONFIG_RT_MUTEX_TESTER is not set
> > > # CONFIG_DEBUG_SPINLOCK is not set
> > > # CONFIG_DEBUG_MUTEXES is not set
> > > CONFIG_BKL=y
> > > # CONFIG_DEBUG_LOCK_ALLOC is not set
> > > # CONFIG_PROVE_LOCKING is not set
> > > # CONFIG_SPARSE_RCU_POINTER is not set
> > > # CONFIG_LOCK_STAT is not set
> > > # CONFIG_DEBUG_SPINLOCK_SLEEP is not set
> > > # CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
> > > CONFIG_STACKTRACE=y
> > > # CONFIG_DEBUG_KOBJECT is not set
> > > CONFIG_DEBUG_BUGVERBOSE=y
> > > # CONFIG_DEBUG_INFO is not set
> > > # CONFIG_DEBUG_VM is not set
> > > # CONFIG_DEBUG_VIRTUAL is not set
> > > # CONFIG_DEBUG_WRITECOUNT is not set
> > > CONFIG_DEBUG_MEMORY_INIT=y
> > > # CONFIG_DEBUG_LIST is not set
> > > # CONFIG_TEST_LIST_SORT is not set
> > > # CONFIG_DEBUG_SG is not set
> > > # CONFIG_DEBUG_NOTIFIERS is not set
> > > # CONFIG_DEBUG_CREDENTIALS is not set
> > > CONFIG_ARCH_WANT_FRAME_POINTERS=y
> > > CONFIG_FRAME_POINTER=y
> > > # CONFIG_BOOT_PRINTK_DELAY is not set
> > > # CONFIG_RCU_TORTURE_TEST is not set
> > > # CONFIG_RCU_CPU_STALL_DETECTOR is not set
> > > # CONFIG_BACKTRACE_SELF_TEST is not set
> > > # CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
> > > # CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
> > > # CONFIG_LKDTM is not set
> > > # CONFIG_CPU_NOTIFIER_ERROR_INJECT is not set
> > > # CONFIG_FAULT_INJECTION is not set
> > > # CONFIG_LATENCYTOP is not set
> > > # CONFIG_SYSCTL_SYSCALL_CHECK is not set
> > > # CONFIG_DEBUG_PAGEALLOC is not set
> > > CONFIG_USER_STACKTRACE_SUPPORT=y
> > > CONFIG_NOP_TRACER=y
> > > CONFIG_HAVE_FTRACE_NMI_ENTER=y
> > > CONFIG_HAVE_FUNCTION_TRACER=y
> > > CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
> > > CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
> > > CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
> > > CONFIG_HAVE_DYNAMIC_FTRACE=y
> > > CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
> > > CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
> > > CONFIG_HAVE_C_RECORDMCOUNT=y
> > > CONFIG_RING_BUFFER=y
> > > CONFIG_FTRACE_NMI_ENTER=y
> > > CONFIG_EVENT_TRACING=y
> > > CONFIG_CONTEXT_SWITCH_TRACER=y
> > > CONFIG_TRACING=y
> > > CONFIG_GENERIC_TRACER=y
> > > CONFIG_TRACING_SUPPORT=y
> > > CONFIG_FTRACE=y
> > > CONFIG_FUNCTION_TRACER=y
> > > CONFIG_FUNCTION_GRAPH_TRACER=y
> > > # CONFIG_IRQSOFF_TRACER is not set
> > > # CONFIG_PREEMPT_TRACER is not set
> > > # CONFIG_SCHED_TRACER is not set
> > > # CONFIG_FTRACE_SYSCALLS is not set
> > > CONFIG_BRANCH_PROFILE_NONE=y
> > > # CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
> > > # CONFIG_PROFILE_ALL_BRANCHES is not set
> > > # CONFIG_STACK_TRACER is not set
> > > CONFIG_BLK_DEV_IO_TRACE=y
> > > CONFIG_DYNAMIC_FTRACE=y
> > > # CONFIG_FUNCTION_PROFILER is not set
> > > CONFIG_FTRACE_MCOUNT_RECORD=y
> > > # CONFIG_FTRACE_STARTUP_TEST is not set
> > > # CONFIG_MMIOTRACE is not set
> > > # CONFIG_RING_BUFFER_BENCHMARK is not set
> > > # CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
> > > # CONFIG_FIREWIRE_OHCI_REMOTE_DMA is not set
> > > # CONFIG_DYNAMIC_DEBUG is not set
> > > # CONFIG_DMA_API_DEBUG is not set
> > > CONFIG_ATOMIC64_SELFTEST=y
> > > # CONFIG_ASYNC_RAID6_TEST is not set
> > > # CONFIG_SAMPLES is not set
> > > CONFIG_HAVE_ARCH_KGDB=y
> > > # CONFIG_KGDB is not set
> > > CONFIG_HAVE_ARCH_KMEMCHECK=y
> > > CONFIG_STRICT_DEVMEM=y
> > > CONFIG_X86_VERBOSE_BOOTUP=y
> > > CONFIG_EARLY_PRINTK=y
> > > # CONFIG_EARLY_PRINTK_DBGP is not set
> > > # CONFIG_DEBUG_STACKOVERFLOW is not set
> > > # CONFIG_DEBUG_STACK_USAGE is not set
> > > # CONFIG_DEBUG_PER_CPU_MAPS is not set
> > > # CONFIG_X86_PTDUMP is not set
> > > CONFIG_DEBUG_RODATA=y
> > > CONFIG_DEBUG_RODATA_TEST=y
> > > # CONFIG_DEBUG_NX_TEST is not set
> > > # CONFIG_IOMMU_DEBUG is not set
> > > # CONFIG_IOMMU_STRESS is not set
> > > CONFIG_HAVE_MMIOTRACE_SUPPORT=y
> > > CONFIG_IO_DELAY_TYPE_0X80=0
> > > CONFIG_IO_DELAY_TYPE_0XED=1
> > > CONFIG_IO_DELAY_TYPE_UDELAY=2
> > > CONFIG_IO_DELAY_TYPE_NONE=3
> > > CONFIG_IO_DELAY_0X80=y
> > > # CONFIG_IO_DELAY_0XED is not set
> > > # CONFIG_IO_DELAY_UDELAY is not set
> > > # CONFIG_IO_DELAY_NONE is not set
> > > CONFIG_DEFAULT_IO_DELAY_TYPE=0
> > > # CONFIG_DEBUG_BOOT_PARAMS is not set
> > > # CONFIG_CPA_DEBUG is not set
> > > CONFIG_OPTIMIZE_INLINING=y
> > > # CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
> > >
> > > #
> > > # Security options
> > > #
> > > CONFIG_KEYS=y
> > > CONFIG_KEYS_DEBUG_PROC_KEYS=y
> > > # CONFIG_SECURITY_DMESG_RESTRICT is not set
> > > CONFIG_SECURITY=y
> > > CONFIG_SECURITYFS=y
> > > CONFIG_SECURITY_NETWORK=y
> > > CONFIG_SECURITY_PATH=y
> > > # CONFIG_SECURITY_SELINUX is not set
> > > # CONFIG_SECURITY_TOMOYO is not set
> > > CONFIG_SECURITY_APPARMOR=y
> > > CONFIG_SECURITY_APPARMOR_BOOTPARAM_VALUE=1
> > > # CONFIG_IMA is not set
> > > # CONFIG_DEFAULT_SECURITY_APPARMOR is not set
> > > CONFIG_DEFAULT_SECURITY_DAC=y
> > > CONFIG_DEFAULT_SECURITY=""
> > > CONFIG_XOR_BLOCKS=y
> > > CONFIG_ASYNC_CORE=y
> > > CONFIG_ASYNC_MEMCPY=y
> > > CONFIG_ASYNC_XOR=y
> > > CONFIG_ASYNC_PQ=y
> > > CONFIG_ASYNC_RAID6_RECOV=y
> > > CONFIG_CRYPTO=y
> > >
> > > #
> > > # Crypto core or helper
> > > #
> > > CONFIG_CRYPTO_ALGAPI=y
> > > CONFIG_CRYPTO_ALGAPI2=y
> > > CONFIG_CRYPTO_AEAD=y
> > > CONFIG_CRYPTO_AEAD2=y
> > > CONFIG_CRYPTO_BLKCIPHER=y
> > > CONFIG_CRYPTO_BLKCIPHER2=y
> > > CONFIG_CRYPTO_HASH=y
> > > CONFIG_CRYPTO_HASH2=y
> > > CONFIG_CRYPTO_RNG2=y
> > > CONFIG_CRYPTO_PCOMP2=y
> > > CONFIG_CRYPTO_MANAGER=y
> > > CONFIG_CRYPTO_MANAGER2=y
> > > CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
> > > CONFIG_CRYPTO_GF128MUL=y
> > > CONFIG_CRYPTO_NULL=y
> > > # CONFIG_CRYPTO_PCRYPT is not set
> > > CONFIG_CRYPTO_WORKQUEUE=y
> > > CONFIG_CRYPTO_CRYPTD=y
> > > CONFIG_CRYPTO_AUTHENC=y
> > > # CONFIG_CRYPTO_TEST is not set
> > >
> > > #
> > > # Authenticated Encryption with Associated Data
> > > #
> > > # CONFIG_CRYPTO_CCM is not set
> > > # CONFIG_CRYPTO_GCM is not set
> > > # CONFIG_CRYPTO_SEQIV is not set
> > >
> > > #
> > > # Block modes
> > > #
> > > CONFIG_CRYPTO_CBC=y
> > > # CONFIG_CRYPTO_CTR is not set
> > > # CONFIG_CRYPTO_CTS is not set
> > > CONFIG_CRYPTO_ECB=y
> > > CONFIG_CRYPTO_LRW=y
> > > CONFIG_CRYPTO_PCBC=y
> > > CONFIG_CRYPTO_XTS=y
> > > CONFIG_CRYPTO_FPU=y
> > >
> > > #
> > > # Hash modes
> > > #
> > > CONFIG_CRYPTO_HMAC=y
> > > CONFIG_CRYPTO_XCBC=y
> > > # CONFIG_CRYPTO_VMAC is not set
> > >
> > > #
> > > # Digest
> > > #
> > > CONFIG_CRYPTO_CRC32C=y
> > > # CONFIG_CRYPTO_CRC32C_INTEL is not set
> > > # CONFIG_CRYPTO_GHASH is not set
> > > CONFIG_CRYPTO_MD4=y
> > > CONFIG_CRYPTO_MD5=y
> > > CONFIG_CRYPTO_MICHAEL_MIC=y
> > > # CONFIG_CRYPTO_RMD128 is not set
> > > # CONFIG_CRYPTO_RMD160 is not set
> > > # CONFIG_CRYPTO_RMD256 is not set
> > > # CONFIG_CRYPTO_RMD320 is not set
> > > CONFIG_CRYPTO_SHA1=y
> > > CONFIG_CRYPTO_SHA256=y
> > > CONFIG_CRYPTO_SHA512=y
> > > CONFIG_CRYPTO_TGR192=y
> > > CONFIG_CRYPTO_WP512=y
> > > # CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL is not set
> > >
> > > #
> > > # Ciphers
> > > #
> > > CONFIG_CRYPTO_AES=y
> > > CONFIG_CRYPTO_AES_X86_64=y
> > > CONFIG_CRYPTO_AES_NI_INTEL=y
> > > CONFIG_CRYPTO_ANUBIS=y
> > > CONFIG_CRYPTO_ARC4=y
> > > CONFIG_CRYPTO_BLOWFISH=y
> > > CONFIG_CRYPTO_CAMELLIA=y
> > > CONFIG_CRYPTO_CAST5=y
> > > CONFIG_CRYPTO_CAST6=y
> > > CONFIG_CRYPTO_DES=y
> > > CONFIG_CRYPTO_FCRYPT=y
> > > CONFIG_CRYPTO_KHAZAD=y
> > > # CONFIG_CRYPTO_SALSA20 is not set
> > > # CONFIG_CRYPTO_SALSA20_X86_64 is not set
> > > CONFIG_CRYPTO_SEED=y
> > > CONFIG_CRYPTO_SERPENT=y
> > > CONFIG_CRYPTO_TEA=y
> > > CONFIG_CRYPTO_TWOFISH=y
> > > CONFIG_CRYPTO_TWOFISH_COMMON=y
> > > CONFIG_CRYPTO_TWOFISH_X86_64=y
> > >
> > > #
> > > # Compression
> > > #
> > > CONFIG_CRYPTO_DEFLATE=y
> > > # CONFIG_CRYPTO_ZLIB is not set
> > > # CONFIG_CRYPTO_LZO is not set
> > >
> > > #
> > > # Random Number Generation
> > > #
> > > # CONFIG_CRYPTO_ANSI_CPRNG is not set
> > > CONFIG_CRYPTO_HW=y
> > > # CONFIG_CRYPTO_DEV_PADLOCK is not set
> > > # CONFIG_CRYPTO_DEV_HIFN_795X is not set
> > > CONFIG_HAVE_KVM=y
> > > CONFIG_HAVE_KVM_IRQCHIP=y
> > > CONFIG_HAVE_KVM_EVENTFD=y
> > > CONFIG_KVM_APIC_ARCHITECTURE=y
> > > CONFIG_KVM_MMIO=y
> > > CONFIG_VIRTUALIZATION=y
> > > CONFIG_KVM=m
> > > # CONFIG_KVM_INTEL is not set
> > > CONFIG_KVM_AMD=m
> > > # CONFIG_KVM_MMU_AUDIT is not set
> > > # CONFIG_VHOST_NET is not set
> > > # CONFIG_VIRTIO_PCI is not set
> > > # CONFIG_VIRTIO_BALLOON is not set
> > > CONFIG_BINARY_PRINTF=y
> > >
> > > #
> > > # Library routines
> > > #
> > > CONFIG_RAID6_PQ=y
> > > CONFIG_BITREVERSE=y
> > > CONFIG_GENERIC_FIND_FIRST_BIT=y
> > > CONFIG_GENERIC_FIND_NEXT_BIT=y
> > > CONFIG_GENERIC_FIND_LAST_BIT=y
> > > # CONFIG_CRC_CCITT is not set
> > > CONFIG_CRC16=y
> > > # CONFIG_CRC_T10DIF is not set
> > > CONFIG_CRC_ITU_T=y
> > > CONFIG_CRC32=y
> > > # CONFIG_CRC7 is not set
> > > CONFIG_LIBCRC32C=y
> > > CONFIG_ZLIB_INFLATE=y
> > > CONFIG_ZLIB_DEFLATE=y
> > > CONFIG_LZO_COMPRESS=y
> > > CONFIG_LZO_DECOMPRESS=y
> > > CONFIG_DECOMPRESS_GZIP=y
> > > CONFIG_DECOMPRESS_BZIP2=y
> > > CONFIG_DECOMPRESS_LZMA=y
> > > CONFIG_DECOMPRESS_LZO=y
> > > CONFIG_HAS_IOMEM=y
> > > CONFIG_HAS_IOPORT=y
> > > CONFIG_HAS_DMA=y
> > > CONFIG_NLATTR=y
> > >
> > > [5.] 2.6.36.2 (vanilla)
> > >
> > > [6.]
> > > [7.] dmesg | tail -f. Just unplug the power cord and try to do something.
> > > [8.] Output of env as root:
> > >
> > >
> > CPLUS_INCLUDE_PATH=/usr/lib64/qt/include:/opt/kde3/lib64/qt3/include:/usr/lib64/qt/include:/opt/kde3/lib64/qt3/include
> > >
> > MANPATH=/usr/local/man:/usr/man:/usr/lib64/java/man:/usr/lib64/java/man:/usr/share/texmf/man
> > > HOSTNAME=eleanor.localhost
> > > SHELL=/bin/bash
> > > TERM=xterm
> > >
> > XDG_SESSION_COOKIE=e353e91fc94d0d84da7fc2cc4a47be0c-1295354339.155535-576806249
> > > MYVIMRC=/home/john/.vimrc
> > > WINDOWID=67112042
> > > QTDIR=/opt/kde3/lib64/qt3
> > > ANT_HOME=/usr/share/ant
> > > USER=root
> > >
> > LS_COLORS=no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.bat=01;32:*.BAT=01;32:*.btm=01;32:*.BTM=01;32:*.cmd=01;32:*.CMD=01;32:*.com=01;32:*.COM=01;32:*.dll=01;32:*.DLL=01;32:*.exe=01;32:*.EXE=01;32:*.7z=01;31:*.ace=01;31:*.arj=01;31:*.bz2=01;31:*.cpio=01;31:*.deb=01;31:*.dz=01;31:*.gz=01;31:*.jar=01;31:*.lzh=01;31:*.lzma=01;31:*.rar=01;31:*.RAR=01;31:*.rpm=01;31:*.rz=01;31:*.tar=01;31:*.taz=01;31:*.tb2=01;31:*.tbz2=01;31:*.tbz=01;31:*.tgz=01;31:*.tlz=01;31:*.trz=01;31:*.txz=01;31:*.tz=01;31:*.tz2=01;31:*.xz=01;31:*.z=01;31:*.Z=01;31:*.zip=01;31:*.ZIP=01;31:*.zoo=01;31:*.aac=00;35:*.anx=01;35:*.asf=01;35:*.ASF=01;35:*.au=00;35:*.axa=00;35:*.axv=01;35:*.avi=01;35:*.AVI=01;35:*.bmp=01;35:*.BMP=01;35:*.flac=01;35:*.FLAC=01;35:*.gif=01;35:*.GIF=01;35:*.jpg=01;35:*.JPG=01;35:*.jpeg=01;35:*.JPEG=01;35:*.m2a=01;35:*.M2A=01;35:*.m2v=01;35:*.M2V=01;35:*.m4a=01;35:*.M4A=01;35:*.m4p=01;35:*.M4P=01;35:*.m4v=01;35:*.M4V=01;35:*.mid=00;35:*.midi=00;35:*.mka=00;35:*.mkv=00;35:*.mov=01;35:*.MOV=01;35:*.mp3=01;35:*.MP3=01;35:*.mp4=01;35:*.mp4v=01;35:*.mpc=01;35:*.MPC=01;35:*.mpeg=01;35:*.MPEG=01;35:*.mpg=01;35:*.MPG=01;35:*.nuv=01;35:*.oga=00;35:*.ogv=01;35:*.ogx=01;35:*.ogg=01;35:*.OGG=01;35:*.pbm=01;35:*.pgm=01;35:*.png=01;35:*.PNG=01;35:*.ppm=01;35:*.qt=01;35:*.ra=00;35:*.ram=01;35:*.RAM=01;35:*.rm=01;35:*.RM=01;35:*.spx=00;35:*.svg=01;35:*.svgz=01;35:*.tga=01;35:*.TGA=01;35:*.tif=01;35:*.TIF=01;35:*.tiff=01;35:*.TIFF=01;35:*.vob=01;35:*.wav=01;35:*.WAV=01;35:*.wma=01;35:*.WMA=01;35:*.wmv=01;35:*.WMV=01;35:*.xbm=01;35:*.xcf=01;35:*.xpm=01;35:*.xspf=00;35:*.xwd=01;35:*.XWD=01;35:
> > > GDK_USE_XFT=1
> > > QEMU_AUDIO_DRV=alsa
> > > QEMU_AUDIO_ADC_FIXED_FREQ=48000
> > > XDG_CONFIG_DIRS=/etc/xdg:/etc/xfce/xdg:/etc/xfce/xdg
> > > T1LIB_CONFIG=/usr/share/t1lib/t1lib.config
> > > MINICOM=-c on
> > > PATH=/usr/local/sbin:/usr/local/bin:/sbin:/usr/sbin:/bin:/usr/bin
> > > _=/bin/env
> > > PWD=/usr/src/linux
> > > INPUTRC=/etc/inputrc
> > > JAVA_HOME=/usr/lib64/java
> > > EDITOR=vim
> > > QT4DIR=/usr/lib64/qt
> > > HOME=/root
> > > LESSCHARSET=utf-8
> > > SHLVL=4
> > > QEMU_AUDIO_DAC_FIXED_FREQ=48000
> > > KBUILD_OUTPUT=./build
> > > LS_OPTIONS=-F -b -T 0 --color=auto
> > > QEMU_ALSA_DAC_BUFFER_SIZE=16384
> > > LOGNAME=root
> > > LESS=-MR
> > > G_FILENAME_ENCODING=@locale
> > > VISUAL=vim
> > >
> > DBUS_SESSION_BUS_ADDRESS=unix:abstract=/tmp/dbus-CxsreJs24z,guid=be90305d1383f63992f613b4000001a5
> > > LESSOPEN=|lesspipe.sh %s
> > >
> > PKG_CONFIG_PATH=/usr/local/lib64/pkgconfig:/usr/lib64/pkgconfig:/usr/local/lib64/pkgconfig
> > > ARCH=x86_64
> > > VIMRUNTIME=/usr/share/vim/vim73
> > > DISPLAY=:0.0
> > > LADSPA_PATH=/usr/lib64/ladspa
> > > VIM=/usr/share/vim
> > > G_BROKEN_FILENAMES=1
> > > MAKEJOBS=-j3
> > > XAUTHORITY=/home/john/.Xauthority
> > > COLORTERM=Terminal
> > >
> > > [8.1] output of scripts/ver_linux
> > > If some fields are empty or look unusual you may have an old version.
> > > Compare to the current minimal requirements in Documentation/Changes.
> > >
> > > Linux eleanor 2.6.37-liq2-eleanor #2 ZEN SMP PREEMPT Sat Jan 15 18:25:26
> > CET
> > > 2011 x86_64 AMD Turion(tm) 64 X2 Mobile Technology TL-60 AuthenticAMD
> > > GNU/Linux
> > >
> > > Gnu C                  4.5.2
> > > Gnu make               3.82
> > > binutils               2.21.51.0.5.20110104
> > > util-linux             2.18
> > > mount                  support
> > > module-init-tools      3.12
> > > e2fsprogs              1.41.14
> > > jfsutils               1.1.14
> > > reiserfsprogs          3.6.21
> > > xfsprogs               3.1.3
> > > pcmciautils            015
> > > quota-tools            3.17.
> > > PPP                    2.4.5
> > > Linux C Library        2.12.2
> > > Dynamic linker (ldd)   2.12.2
> > > Linux C++ Library      6.0.14
> > > Procps                 3.2.8
> > > Net-tools              1.60
> > > Kbd                    1.15.2
> > > oprofile               0.9.6
> > > Sh-utils               8.8
> > > wireless-tools         29
> > > Modules Loaded         ath5k ath mac80211 cfg80211 usbhid hid
> > snd_seq_dummy
> > > snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss
> > > snd_mixer_oss ipv6 bridge stp llc cpufreq_stats powernow_k8 mperf kvm_amd
> > > kvm fuse i2c_nforce2 sdhci_pci sdhci nouveau ttm hp_wmi sparse_keymap
> > > drm_kms_helper snd_hda_codec_conexant wmi drm mmc_core firewire_ohci
> > agpgart
> > > i2c_algo_bit snd_hda_intel video snd_hda_codec snd_hwdep rtc_cmos
> > rtc_core
> > > snd_pcm uvcvideo videodev v4l1_compat v4l2_compat_ioctl32 joydev ohci_hcd
> > > psmouse ehci_hcd processor forcedeth firewire_core battery snd_timer
> > > i2c_core evdev k8temp output rtc_lib thermal thermal_sys ac button hwmon
> > snd
> > > soundcore snd_page_alloc
> > >
> > > [8.2.] /proc/cpuinfo
> > >
> > > processor    : 0
> > > vendor_id    : AuthenticAMD
> > > cpu family    : 15
> > > model        : 104
> > > model name    : AMD Turion(tm) 64 X2 Mobile Technology TL-60
> > > stepping    : 2
> > > cpu MHz        : 2000.000
> > > cache size    : 512 KB
> > > physical id    : 0
> > > siblings    : 2
> > > core id        : 0
> > > cpu cores    : 2
> > > apicid        : 0
> > > initial apicid    : 0
> > > fpu        : yes
> > > fpu_exception    : yes
> > > cpuid level    : 1
> > > wp        : yes
> > > flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca
> > cmov
> > > pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt rdtscp
> > lm
> > > 3dnowext 3dnow rep_good nopl extd_apicid pni cx16 lahf_lm cmp_legacy svm
> > > extapic cr8_legacy 3dnowprefetch lbrv
> > > bogomips    : 4000.07
> > > TLB size    : 1024 4K pages
> > > clflush size    : 64
> > > cache_alignment    : 64
> > > address sizes    : 40 bits physical, 48 bits virtual
> > > power management: ts fid vid ttp tm stc 100mhzsteps
> > >
> > > processor    : 1
> > > vendor_id    : AuthenticAMD
> > > cpu family    : 15
> > > model        : 104
> > > model name    : AMD Turion(tm) 64 X2 Mobile Technology TL-60
> > > stepping    : 2
> > > cpu MHz        : 2000.000
> > > cache size    : 512 KB
> > > physical id    : 0
> > > siblings    : 2
> > > core id        : 1
> > > cpu cores    : 2
> > > apicid        : 1
> > > initial apicid    : 1
> > > fpu        : yes
> > > fpu_exception    : yes
> > > cpuid level    : 1
> > > wp        : yes
> > > flags        : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca
> > cmov
> > > pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt rdtscp
> > lm
> > > 3dnowext 3dnow rep_good nopl extd_apicid pni cx16 lahf_lm cmp_legacy svm
> > > extapic cr8_legacy 3dnowprefetch lbrv
> > > bogomips    : 4000.07
> > > TLB size    : 1024 4K pages
> > > clflush size    : 64
> > > cache_alignment    : 64
> > > address sizes    : 40 bits physical, 48 bits virtual
> > > power management: ts fid vid ttp tm stc 100mhzsteps
> > >
> > > [8.3] /proc/modules
> > > ath5k 141752 0 - Live 0xffffffffa02ed000
> > > ath 13677 1 ath5k, Live 0xffffffffa0020000
> > > mac80211 204790 1 ath5k, Live 0xffffffffa010a000
> > > cfg80211 142010 3 ath5k,ath,mac80211, Live 0xffffffffa0090000
> > > usbhid 28949 0 - Live 0xffffffffa004a000
> > > hid 72577 1 usbhid, Live 0xffffffffa002b000
> > > snd_seq_dummy 1479 0 - Live 0xffffffffa05cf000
> > > snd_seq_oss 30198 0 - Live 0xffffffffa05c0000
> > > snd_seq_midi_event 5772 1 snd_seq_oss, Live 0xffffffffa05b9000
> > > snd_seq 51960 5 snd_seq_dummy,snd_seq_oss,snd_seq_midi_event, Live
> > > 0xffffffffa05a3000
> > > snd_seq_device 5505 3 snd_seq_dummy,snd_seq_oss,snd_seq, Live
> > > 0xffffffffa059c000
> > > snd_pcm_oss 40043 0 - Live 0xffffffffa058b000
> > > snd_mixer_oss 17784 2 snd_pcm_oss, Live 0xffffffffa0580000
> > > ipv6 259771 24 - Live 0xffffffffa052e000
> > > bridge 72792 0 - Live 0xffffffffa0512000
> > > stp 1592 1 bridge, Live 0xffffffffa050c000
> > > llc 3848 2 bridge,stp, Live 0xffffffffa0506000
> > > cpufreq_stats 3921 0 - Live 0xffffffffa0500000
> > > powernow_k8 13020 1 - Live 0xffffffffa04f6000
> > > mperf 1163 1 powernow_k8, Live 0xffffffffa04f0000
> > > kvm_amd 43520 0 - Live 0xffffffffa04de000
> > > kvm 291866 1 kvm_amd, Live 0xffffffffa0480000
> > > fuse 66704 5 - Live 0xffffffffa0465000
> > > i2c_nforce2 5168 0 - Live 0xffffffffa045e000
> > > sdhci_pci 7582 0 - Live 0xffffffffa0421000
> > > sdhci 17164 1 sdhci_pci, Live 0xffffffffa0416000
> > > nouveau 553761 2 - Live 0xffffffffa0338000
> > > ttm 53717 1 nouveau, Live 0xffffffffa0320000
> > > hp_wmi 5197 0 - Live 0xffffffffa02e9000
> > > sparse_keymap 2920 1 hp_wmi, Live 0xffffffffa02e3000
> > > drm_kms_helper 26715 1 nouveau, Live 0xffffffffa02d5000
> > > snd_hda_codec_conexant 42079 1 - Live 0xffffffffa02b9000
> > > wmi 8349 1 hp_wmi, Live 0xffffffffa02cc000
> > > drm 178090 4 nouveau,ttm,drm_kms_helper, Live 0xffffffffa027c000
> > > mmc_core 65216 1 sdhci, Live 0xffffffffa0262000
> > > firewire_ohci 27045 0 - Live 0xffffffffa0255000
> > > agpgart 29376 2 ttm,drm, Live 0xffffffffa0245000
> > > i2c_algo_bit 5023 1 nouveau, Live 0xffffffffa023e000
> > > snd_hda_intel 22061 9 - Live 0xffffffffa0231000
> > > video 12013 1 nouveau, Live 0xffffffffa021f000
> > > snd_hda_codec 64606 2 snd_hda_codec_conexant,snd_hda_intel, Live
> > > 0xffffffffa0204000
> > > snd_hwdep 6340 1 snd_hda_codec, Live 0xffffffffa01fc000
> > > rtc_cmos 9342 0 - Live 0xffffffffa01f3000
> > > rtc_core 14727 1 rtc_cmos, Live 0xffffffffa01e8000
> > > snd_pcm 73702 5 snd_pcm_oss,snd_hda_intel,snd_hda_codec, Live
> > > 0xffffffffa01cb000
> > > uvcvideo 62344 0 - Live 0xffffffffa01b4000
> > > videodev 65808 1 uvcvideo, Live 0xffffffffa019a000
> > > v4l1_compat 16298 2 uvcvideo,videodev, Live 0xffffffffa0191000
> > > v4l2_compat_ioctl32 10196 1 videodev, Live 0xffffffffa0189000
> > > joydev 10703 0 - Live 0xffffffffa0180000
> > > ohci_hcd 21658 0 - Live 0xffffffffa0174000
> > > psmouse 47286 0 - Live 0xffffffffa015f000
> > > ehci_hcd 38656 0 - Live 0xffffffffa013f000
> > > processor 26524 1 powernow_k8, Live 0xffffffffa0101000
> > > forcedeth 52560 0 - Live 0xffffffffa00ed000
> > > firewire_core 51491 1 firewire_ohci, Live 0xffffffffa00d8000
> > > battery 10567 0 - Live 0xffffffffa00b8000
> > > snd_timer 19949 4 snd_seq,snd_pcm, Live 0xffffffffa00cd000
> > > i2c_core 19972 6
> > > i2c_nforce2,nouveau,drm_kms_helper,drm,i2c_algo_bit,videodev, Live
> > > 0xffffffffa00c1000
> > > evdev 9553 18 - Live 0xffffffffa008b000
> > > k8temp 3483 0 - Live 0xffffffffa0085000
> > > output 2052 1 video, Live 0xffffffffa0079000
> > > rtc_lib 1978 1 rtc_core, Live 0xffffffffa0073000
> > > thermal 8146 0 - Live 0xffffffffa006b000
> > > thermal_sys 13926 3 video,processor,thermal, Live 0xffffffffa0057000
> > > ac 3281 0 - Live 0xffffffffa0047000
> > > button 5077 1 nouveau, Live 0xffffffffa0040000
> > > hwmon 1505 2 k8temp,thermal_sys, Live 0xffffffffa0028000
> > > snd 59352 23
> > >
> > snd_seq_oss,snd_seq,snd_seq_device,snd_pcm_oss,snd_mixer_oss,snd_hda_codec_conexant,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_timer,
> > > Live 0xffffffffa000f000
> > > soundcore 6151 2 snd, Live 0xffffffffa0007000
> > > snd_page_alloc 7457 2 snd_hda_intel,snd_pcm, Live 0xffffffffa0000000
> > >
> > > [8.4.] /proc/ioports, /proc/iomem
> > > 0000-0cf7 : PCI Bus 0000:00
> > >   0000-001f : dma1
> > >   0020-0021 : pic1
> > >   0040-0043 : timer0
> > >   0050-0053 : timer1
> > >   0060-0060 : keyboard
> > >   0062-0062 : EC data
> > >   0064-0064 : keyboard
> > >   0066-0066 : EC cmd
> > >   0070-0071 : rtc0
> > >   0080-008f : dma page reg
> > >   00a0-00a1 : pic2
> > >   00c0-00df : dma2
> > >   00f0-00ff : fpu
> > >   0170-0177 : 0000:00:06.0
> > >   01f0-01f7 : 0000:00:06.0
> > >   0360-0361 : pnp 00:04
> > >   0376-0376 : 0000:00:06.0
> > >   03c0-03df : vesafb
> > >   03f6-03f6 : 0000:00:06.0
> > >   04d0-04d1 : pnp 00:04
> > > 0cf8-0cff : PCI conf1
> > > 0d00-ffff : PCI Bus 0000:00
> > >   1000-107f : pnp 00:03
> > >     1000-1003 : ACPI PM1a_EVT_BLK
> > >     1004-1005 : ACPI PM1a_CNT_BLK
> > >     1008-100b : ACPI PM_TMR
> > >     1010-1015 : ACPI CPU throttle
> > >     1020-1027 : ACPI GPE0_BLK
> > >   1080-10ff : pnp 00:03
> > >   1400-147f : pnp 00:03
> > >   1480-14ff : pnp 00:03
> > >     1484-1484 : ACPI PM2_CNT_BLK
> > >   1800-187f : pnp 00:03
> > >   1880-18ff : pnp 00:03
> > >   3000-303f : 0000:00:01.1
> > >     3000-303f : nForce2_smbus
> > >   3040-307f : 0000:00:01.1
> > >     3040-307f : nForce2_smbus
> > >   3080-30bf : 0000:00:01.1
> > >   30c0-30cf : 0000:00:06.0
> > >   30d0-30df : 0000:00:09.0
> > >     30d0-30df : ahci
> > >   30e0-30e3 : 0000:00:09.0
> > >     30e0-30e3 : ahci
> > >   30e4-30e7 : 0000:00:09.0
> > >     30e4-30e7 : ahci
> > >   30e8-30ef : 0000:00:09.0
> > >     30e8-30ef : ahci
> > >   30f0-30f7 : 0000:00:09.0
> > >     30f0-30f7 : ahci
> > >   30f8-30ff : 0000:00:0a.0
> > >     30f8-30ff : forcedeth
> > >   4000-4fff : PCI Bus 0000:04
> > > 00000000-0000ffff : reserved
> > > 00010000-0009dfff : System RAM
> > > 0009e000-0009ffff : reserved
> > > 000a0000-000bffff : PCI Bus 0000:00
> > > 000c0000-000c3fff : PCI Bus 0000:00
> > > 000c4000-000c7fff : PCI Bus 0000:00
> > > 000c8000-000cbfff : PCI Bus 0000:00
> > > 000cc000-000cffff : PCI Bus 0000:00
> > > 000d2000-000fffff : reserved
> > >   000d4000-000d7fff : PCI Bus 0000:00
> > >   000d8000-000dbfff : PCI Bus 0000:00
> > >   000dc000-000dffff : PCI Bus 0000:00
> > >   000e0000-000e3fff : PCI Bus 0000:00
> > >   000e4000-000e7fff : PCI Bus 0000:00
> > >   000e8000-000ebfff : PCI Bus 0000:00
> > >   000ec000-000effff : PCI Bus 0000:00
> > >   000f0000-000fffff : PCI Bus 0000:00
> > > 00100000-77f4ffff : System RAM
> > >   01000000-0162f791 : Kernel code
> > >   0162f792-01aa8997 : Kernel data
> > >   01b53000-01c0abaf : Kernel bss
> > > 77f50000-77f64fff : ACPI Tables
> > > 77f65000-77f65fff : ACPI Non-volatile Storage
> > > 77f66000-7fffffff : reserved
> > > 80000000-febfffff : PCI Bus 0000:00
> > >   80000000-8001ffff : 0000:00:12.0
> > >   d0000000-dfffffff : 0000:00:12.0
> > >   e0000000-efffffff : reserved
> > >     e0000000-efffffff : pnp 00:02
> > >       e0000000-e04fffff : PCI MMCONFIG 0000 [bus 00-04]
> > >   f0000000-f1ffffff : PCI Bus 0000:04
> > >   f2000000-f3ffffff : PCI Bus 0000:04
> > >   f4000000-f4ffffff : 0000:00:12.0
> > >   f5000000-f5ffffff : 0000:00:12.0
> > >   f6000000-f60fffff : PCI Bus 0000:03
> > >     f6000000-f600ffff : 0000:03:00.0
> > >       f6000000-f600ffff : ath5k
> > >   f6100000-f61fffff : PCI Bus 0000:02
> > >     f6100000-f61007ff : 0000:02:05.0
> > >       f6100000-f61007ff : firewire_ohci
> > >     f6100800-f61008ff : 0000:02:05.1
> > >       f6100800-f61008ff : mmc0
> > >     f6101000-f61010ff : 0000:02:05.2
> > >     f6101400-f61014ff : 0000:02:05.3
> > >   f6200000-f627ffff : 0000:00:01.3
> > >   f6480000-f6483fff : 0000:00:07.0
> > >     f6480000-f6483fff : ICH HD audio
> > >   f6484000-f6485fff : 0000:00:09.0
> > >     f6484000-f6485fff : ahci
> > >   f6486000-f6486fff : 0000:00:02.0
> > >     f6486000-f6486fff : ohci_hcd
> > >   f6487000-f6487fff : 0000:00:04.0
> > >     f6487000-f6487fff : ohci_hcd
> > >   f6488000-f6488fff : 0000:00:0a.0
> > >     f6488000-f6488fff : forcedeth
> > >   f6489000-f64890ff : 0000:00:02.1
> > >     f6489000-f64890ff : ehci_hcd
> > >   f6489400-f64894ff : 0000:00:04.1
> > >     f6489400-f64894ff : ehci_hcd
> > >   f6489800-f648980f : 0000:00:0a.0
> > >     f6489800-f648980f : forcedeth
> > >   f6489c00-f6489cff : 0000:00:0a.0
> > >     f6489c00-f6489cff : forcedeth
> > > fec00000-fec0ffff : reserved
> > >   fec00000-fec003ff : IOAPIC 0
> > > fed00000-fed00fff : pnp 00:0b
> > >   fed00000-fed003ff : HPET 0
> > > fed40000-fed44fff : PCI Bus 0000:00
> > > fee00000-fee00fff : Local APIC
> > >   fee00000-fee00fff : reserved
> > > fef00000-fef00fff : pnp 00:0b
> > > fff80000-ffffffff : reserved
> > >
> > >
> > > 00:00.0 RAM memory: nVidia Corporation MCP67 Memory Controller (rev a2)
> > >     Subsystem: Hewlett-Packard Company Device 30cf
> > >     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> > > Stepping- SERR- FastB2B- DisINTx-
> > >     Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
> > <TAbort-
> > > <MAbort- >SERR- <PERR- INTx-
> > >     Latency: 0
> > >     Capabilities: [44] HyperTransport: Slave or Primary Interface
> > >         Command: BaseUnitID=0 UnitCnt=15 MastHost- DefDir- DUL-
> > >         Link Control 0: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO-
> > <CRCErr=0
> > > IsocEn- LSEn+ ExtCTL- 64b-
> > >         Link Config 0: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=16bit
> > > DwFcInEn- LWO=16bit DwFcOutEn-
> > >         Link Control 1: CFlE- CST- CFE- <LkFail+ Init- EOC+ TXO+
> > <CRCErr=0
> > > IsocEn- LSEn- ExtCTL- 64b-
> > >         Link Config 1: MLWI=8bit DwFcIn- MLWO=8bit DwFcOut- LWI=8bit
> > > DwFcInEn- LWO=8bit DwFcOutEn-
> > >         Revision ID: 1.03
> > >         Link Frequency 0: 800MHz
> > >         Link Error 0: <Prot- <Ovfl- <EOC- CTLTm-
> > >         Link Frequency Capability 0: 200MHz+ 300MHz+ 400MHz+ 500MHz+
> > 600MHz+
> > > 800MHz+ 1.0GHz+ 1.2GHz- 1.4GHz- 1.6GHz- Vend-
> > >         Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA- UIDRD-
> > >         Link Frequency 1: 200MHz
> > >         Link Error 1: <Prot- <Ovfl- <EOC- CTLTm-
> > >         Link Frequency Capability 1: 200MHz- 300MHz- 400MHz- 500MHz-
> > 600MHz-
> > > 800MHz- 1.0GHz- 1.2GHz- 1.4GHz- 1.6GHz- Vend-
> > >         Error Handling: PFlE+ OFlE+ PFE- OFE- EOCFE- RFE- CRCFE- SERRFE-
> > CF-
> > > RE- PNFE- ONFE- EOCNFE- RNFE- CRCNFE- SERRNFE-
> > >         Prefetchable memory behind bridge Upper: 00-00
> > >         Bus Number: 00
> > >     Capabilities: [dc] HyperTransport: MSI Mapping Enable+ Fixed-
> > >         Mapping Address Base: 00000000fee00000
> > >
> > > 00:01.0 ISA bridge: nVidia Corporation MCP67 ISA Bridge (rev a2)
> > >     Subsystem: Hewlett-Packard Company Device 30cf
> > >     Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr-
> > > Stepping- SERR- FastB2B- DisINTx-
> > >     Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
> > <TAbort-
> > > <MAbort+ >SERR- <PERR- INTx-
> > >     Latency: 0
> > >
> > > 00:01.1 SMBus: nVidia Corporation MCP67 SMBus (rev a2)
> > >     Subsystem: Hewlett-Packard Company Device 30cf
> > >     Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
> > > Stepping- SERR- FastB2B- DisINTx-
> > >     Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
> > <TAbort-
> > > <MAbort- >SERR- <PERR- INTx-
> > >     Interrupt: pin A routed to IRQ 10
> > >     Region 0: I/O ports at 3080 [size=64]
> > >     Region 4: I/O ports at 3040 [size=64]
> > >     Region 5: I/O ports at 3000 [size=64]
> > >     Capabilities: [44] Power Management version 2
> > >         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> > > PME(D0-,D1-,D2-,D3hot+,D3cold+)
> > >         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
> > >     Kernel driver in use: nForce2_smbus
> > >     Kernel modules: i2c-nforce2
> > >
> > > 00:01.2 RAM memory: nVidia Corporation MCP67 Memory Controller (rev a2)
> > >     Subsystem: Hewlett-Packard Company Device 30cf
> > >     Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
> > > Stepping- SERR- FastB2B- DisINTx+
> > >     Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
> > <TAbort-
> > > <MAbort- >SERR- <PERR- INTx-
> > >
> > > 00:01.3 Co-processor: nVidia Corporation MCP67 Co-processor (rev a2)
> > >     Subsystem: Hewlett-Packard Company Device 30cf
> > >     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> > > Stepping- SERR- FastB2B- DisINTx-
> > >     Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
> > <TAbort-
> > > <MAbort- >SERR- <PERR- INTx-
> > >     Latency: 0 (750ns min, 250ns max)
> > >     Interrupt: pin B routed to IRQ 11
> > >     Region 0: Memory at f6200000 (32-bit, non-prefetchable) [size=512K]
> > >
> > > 00:02.0 USB Controller: nVidia Corporation MCP67 OHCI USB 1.1 Controller
> > > (rev a2) (prog-if 10 [OHCI])
> > >     Subsystem: Hewlett-Packard Company Device 30cf
> > >     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> > > Stepping- SERR- FastB2B- DisINTx-
> > >     Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
> > <TAbort-
> > > <MAbort- >SERR- <PERR- INTx-
> > >     Latency: 0 (750ns min, 250ns max)
> > >     Interrupt: pin A routed to IRQ 18
> > >     Region 0: Memory at f6486000 (32-bit, non-prefetchable) [size=4K]
> > >     Capabilities: [44] Power Management version 2
> > >         Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
> > > PME(D0+,D1+,D2+,D3hot+,D3cold+)
> > >         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
> > >     Kernel driver in use: ohci_hcd
> > >     Kernel modules: ohci-hcd
> > >
> > > 00:02.1 USB Controller: nVidia Corporation MCP67 EHCI USB 2.0 Controller
> > > (rev a2) (prog-if 20 [EHCI])
> > >     Subsystem: Hewlett-Packard Company Device 30cf
> > >     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> > > Stepping- SERR- FastB2B- DisINTx-
> > >     Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
> > <TAbort-
> > > <MAbort- >SERR- <PERR- INTx-
> > >     Latency: 0 (750ns min, 250ns max)
> > >     Interrupt: pin B routed to IRQ 22
> > >     Region 0: Memory at f6489000 (32-bit, non-prefetchable) [size=256]
> > >     Capabilities: [44] Debug port: BAR=1 offset=0098
> > >     Capabilities: [80] Power Management version 2
> > >         Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
> > > PME(D0+,D1+,D2+,D3hot+,D3cold+)
> > >         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
> > >     Kernel driver in use: ehci_hcd
> > >     Kernel modules: ehci-hcd
> > >
> > > 00:04.0 USB Controller: nVidia Corporation MCP67 OHCI USB 1.1 Controller
> > > (rev a2) (prog-if 10 [OHCI])
> > >     Subsystem: Hewlett-Packard Company Device 30cf
> > >     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> > > Stepping- SERR- FastB2B- DisINTx-
> > >     Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
> > <TAbort-
> > > <MAbort- >SERR- <PERR- INTx-
> > >     Latency: 0 (750ns min, 250ns max)
> > >     Interrupt: pin A routed to IRQ 18
> > >     Region 0: Memory at f6487000 (32-bit, non-prefetchable) [size=4K]
> > >     Capabilities: [44] Power Management version 2
> > >         Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
> > > PME(D0+,D1+,D2+,D3hot+,D3cold+)
> > >         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
> > >     Kernel driver in use: ohci_hcd
> > >     Kernel modules: ohci-hcd
> > >
> > > 00:04.1 USB Controller: nVidia Corporation MCP67 EHCI USB 2.0 Controller
> > > (rev a2) (prog-if 20 [EHCI])
> > >     Subsystem: Hewlett-Packard Company Device 30cf
> > >     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> > > Stepping- SERR- FastB2B- DisINTx-
> > >     Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
> > <TAbort-
> > > <MAbort- >SERR- <PERR- INTx-
> > >     Latency: 0 (750ns min, 250ns max)
> > >     Interrupt: pin B routed to IRQ 22
> > >     Region 0: Memory at f6489400 (32-bit, non-prefetchable) [size=256]
> > >     Capabilities: [44] Debug port: BAR=1 offset=0098
> > >     Capabilities: [80] Power Management version 2
> > >         Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
> > > PME(D0+,D1+,D2+,D3hot+,D3cold+)
> > >         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
> > >     Kernel driver in use: ehci_hcd
> > >     Kernel modules: ehci-hcd
> > >
> > > 00:06.0 IDE interface: nVidia Corporation MCP67 IDE Controller (rev a1)
> > > (prog-if 8a [Master SecP PriP])
> > >     Subsystem: Hewlett-Packard Company Device 30cf
> > >     Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> > > Stepping- SERR- FastB2B- DisINTx-
> > >     Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
> > <TAbort-
> > > <MAbort- >SERR- <PERR- INTx-
> > >     Latency: 0 (750ns min, 250ns max)
> > >     Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable)
> > > [size=8]
> > >     Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable)
> > > [size=1]
> > >     Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable)
> > > [size=8]
> > >     Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable)
> > > [size=1]
> > >     Region 4: I/O ports at 30c0 [size=16]
> > >     Capabilities: [44] Power Management version 2
> > >         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> > > PME(D0-,D1-,D2-,D3hot-,D3cold-)
> > >         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
> > >
> > > 00:07.0 Audio device: nVidia Corporation MCP67 High Definition Audio (rev
> > > a1)
> > >     Subsystem: Hewlett-Packard Company Device 30cf
> > >     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> > > Stepping- SERR- FastB2B- DisINTx-
> > >     Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
> > <TAbort-
> > > <MAbort- >SERR- <PERR- INTx-
> > >     Latency: 0 (500ns min, 1250ns max)
> > >     Interrupt: pin A routed to IRQ 21
> > >     Region 0: Memory at f6480000 (32-bit, non-prefetchable) [size=16K]
> > >     Capabilities: [44] Power Management version 2
> > >         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> > > PME(D0-,D1-,D2-,D3hot+,D3cold+)
> > >         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
> > >     Capabilities: [50] MSI: Enable- Count=1/1 Maskable+ 64bit+
> > >         Address: 0000000000000000  Data: 0000
> > >         Masking: 00000000  Pending: 00000000
> > >     Capabilities: [6c] HyperTransport: MSI Mapping Enable- Fixed+
> > >     Kernel driver in use: HDA Intel
> > >     Kernel modules: snd-hda-intel
> > >
> > > 00:08.0 PCI bridge: nVidia Corporation MCP67 PCI Bridge (rev a2) (prog-if
> > 01
> > > [Subtractive decode])
> > >     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> > > Stepping- SERR+ FastB2B- DisINTx-
> > >     Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
> > <TAbort-
> > > <MAbort- >SERR- <PERR- INTx-
> > >     Latency: 0
> > >     Bus: primary=00, secondary=02, subordinate=02, sec-latency=64
> > >     I/O behind bridge: 0000f000-00000fff
> > >     Memory behind bridge: f6100000-f61fffff
> > >     Prefetchable memory behind bridge: fff00000-000fffff
> > >     Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> > > <TAbort- <MAbort+ <SERR- <PERR-
> > >     BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
> > >         PriDiscTmr- SecDiscTmr+ DiscTmrStat- DiscTmrSERREn-
> > >     Capabilities: [b8] Subsystem: nVidia Corporation Device cb84
> > >     Capabilities: [8c] HyperTransport: MSI Mapping Enable- Fixed-
> > >         Mapping Address Base: 00000000fee00000
> > >
> > > 00:09.0 IDE interface: nVidia Corporation MCP67 AHCI Controller (rev a2)
> > > (prog-if 85 [Master SecO PriO])
> > >     Subsystem: Hewlett-Packard Company Device 30cf
> > >     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> > > Stepping- SERR- FastB2B- DisINTx-
> > >     Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
> > <TAbort-
> > > <MAbort- >SERR- <PERR- INTx-
> > >     Latency: 0 (750ns min, 250ns max)
> > >     Interrupt: pin A routed to IRQ 23
> > >     Region 0: I/O ports at 30f0 [size=8]
> > >     Region 1: I/O ports at 30e4 [size=4]
> > >     Region 2: I/O ports at 30e8 [size=8]
> > >     Region 3: I/O ports at 30e0 [size=4]
> > >     Region 4: I/O ports at 30d0 [size=16]
> > >     Region 5: Memory at f6484000 (32-bit, non-prefetchable) [size=8K]
> > >     Capabilities: [44] Power Management version 2
> > >         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> > > PME(D0-,D1-,D2-,D3hot-,D3cold-)
> > >         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
> > >     Capabilities: [8c] SATA HBA <?>
> > >     Capabilities: [b0] MSI: Enable- Count=1/8 Maskable- 64bit+
> > >         Address: 0000000000000000  Data: 0000
> > >     Capabilities: [cc] HyperTransport: MSI Mapping Enable- Fixed+
> > >     Kernel driver in use: ahci
> > >
> > > 00:0a.0 Ethernet controller: nVidia Corporation MCP67 Ethernet (rev a2)
> > >     Subsystem: Hewlett-Packard Company Device 30cf
> > >     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> > > Stepping- SERR- FastB2B- DisINTx+
> > >     Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
> > <TAbort-
> > > <MAbort- >SERR- <PERR- INTx-
> > >     Latency: 0 (250ns min, 5000ns max)
> > >     Interrupt: pin A routed to IRQ 40
> > >     Region 0: Memory at f6488000 (32-bit, non-prefetchable) [size=4K]
> > >     Region 1: I/O ports at 30f8 [size=8]
> > >     Region 2: Memory at f6489c00 (32-bit, non-prefetchable) [size=256]
> > >     Region 3: Memory at f6489800 (32-bit, non-prefetchable) [size=16]
> > >     Capabilities: [44] Power Management version 2
> > >         Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
> > > PME(D0+,D1+,D2+,D3hot+,D3cold+)
> > >         Status: D0 NoSoftRst- PME-Enable+ DSel=0 DScale=0 PME-
> > >     Capabilities: [50] MSI: Enable+ Count=1/8 Maskable+ 64bit+
> > >         Address: 00000000fee0300c  Data: 4179
> > >         Masking: 000000fe  Pending: 00000000
> > >     Capabilities: [6c] HyperTransport: MSI Mapping Enable- Fixed+
> > >     Kernel driver in use: forcedeth
> > >     Kernel modules: forcedeth
> > >
> > > 00:0c.0 PCI bridge: nVidia Corporation MCP67 PCI Express Bridge (rev a2)
> > > (prog-if 00 [Normal decode])
> > >     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> > > Stepping- SERR+ FastB2B- DisINTx-
> > >     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> > <TAbort-
> > > <MAbort- >SERR- <PERR- INTx-
> > >     Latency: 0, Cache Line Size: 64 bytes
> > >     Bus: primary=00, secondary=04, subordinate=05, sec-latency=0
> > >     I/O behind bridge: 00004000-00004fff
> > >     Memory behind bridge: f2000000-f3ffffff
> > >     Prefetchable memory behind bridge: 00000000f0000000-00000000f1ffffff
> > >     Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
> > <TAbort-
> > > <MAbort- <SERR- <PERR-
> > >     BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
> > >         PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> > >     Capabilities: [40] Subsystem: nVidia Corporation Device 0000
> > >     Capabilities: [48] Power Management version 2
> > >         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> > > PME(D0+,D1+,D2+,D3hot+,D3cold+)
> > >         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
> > >     Capabilities: [50] MSI: Enable- Count=1/2 Maskable- 64bit+
> > >         Address: 0000000000000000  Data: 0000
> > >     Capabilities: [60] HyperTransport: MSI Mapping Enable- Fixed-
> > >         Mapping Address Base: 00000000fee00000
> > >     Capabilities: [80] Express (v1) Root Port (Slot+), MSI 00
> > >         DevCap:    MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns,
> > L1
> > > <1us
> > >             ExtTag+ RBE+ FLReset-
> > >         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal-
> > > Unsupported-
> > >             RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
> > >             MaxPayload 128 bytes, MaxReadReq 512 bytes
> > >         DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
> > > TransPend-
> > >         LnkCap:    Port #1, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency
> > L0
> > > <512ns, L1 <4us
> > >             ClockPM- Surprise- LLActRep+ BwNot-
> > >         LnkCtl:    ASPM Disabled; RCB 64 bytes Disabled- Retrain-
> > CommClk-
> > >             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
> > >         LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
> > DLActive-
> > > BWMgmt- ABWMgmt-
> > >         SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug-
> > > Surprise-
> > >             Slot #  2, PowerLimit 10.000000; Interlock- NoCompl-
> > >         SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq+
> > > LinkChg+
> > >             Control: AttnInd Off, PwrInd On, Power- Interlock-
> > >         SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet-
> > > Interlock-
> > >             Changed: MRL- PresDet- LinkState-
> > >         RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna-
> > > CRSVisible-
> > >         RootCap: CRSVisible-
> > >         RootSta: PME ReqID 0000, PMEStatus- PMEPending-
> > >     Capabilities: [100] Virtual Channel <?>
> > >
> > > 00:0d.0 PCI bridge: nVidia Corporation MCP67 PCI Express Bridge (rev a2)
> > > (prog-if 00 [Normal decode])
> > >     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> > > Stepping- SERR+ FastB2B- DisINTx-
> > >     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> > <TAbort-
> > > <MAbort- >SERR- <PERR- INTx-
> > >     Latency: 0, Cache Line Size: 64 bytes
> > >     Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
> > >     I/O behind bridge: 0000f000-00000fff
> > >     Memory behind bridge: f6000000-f60fffff
> > >     Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
> > >     Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
> > <TAbort-
> > > <MAbort- <SERR- <PERR-
> > >     BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
> > >         PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
> > >     Capabilities: [40] Subsystem: nVidia Corporation Device 0000
> > >     Capabilities: [48] Power Management version 2
> > >         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> > > PME(D0+,D1+,D2+,D3hot+,D3cold+)
> > >         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
> > >     Capabilities: [50] MSI: Enable- Count=1/2 Maskable- 64bit+
> > >         Address: 0000000000000000  Data: 0000
> > >     Capabilities: [60] HyperTransport: MSI Mapping Enable- Fixed-
> > >         Mapping Address Base: 00000000fee00000
> > >     Capabilities: [80] Express (v1) Root Port (Slot+), MSI 00
> > >         DevCap:    MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns,
> > L1
> > > <1us
> > >             ExtTag+ RBE+ FLReset-
> > >         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal-
> > > Unsupported-
> > >             RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
> > >             MaxPayload 128 bytes, MaxReadReq 512 bytes
> > >         DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
> > > TransPend-
> > >         LnkCap:    Port #2, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency
> > L0
> > > <512ns, L1 <4us
> > >             ClockPM- Surprise- LLActRep+ BwNot-
> > >         LnkCtl:    ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain-
> > CommClk+
> > >             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
> > >         LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
> > DLActive+
> > > BWMgmt- ABWMgmt-
> > >         SltCap:    AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug-
> > > Surprise-
> > >             Slot #  3, PowerLimit 10.000000; Interlock- NoCompl-
> > >         SltCtl:    Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq+
> > > LinkChg+
> > >             Control: AttnInd Off, PwrInd On, Power- Interlock-
> > >         SltSta:    Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+
> > > Interlock-
> > >             Changed: MRL- PresDet- LinkState-
> > >         RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna-
> > > CRSVisible-
> > >         RootCap: CRSVisible-
> > >         RootSta: PME ReqID 0000, PMEStatus- PMEPending-
> > >     Capabilities: [100] Virtual Channel <?>
> > >
> > > 00:12.0 VGA compatible controller: nVidia Corporation C67 [GeForce 7150M
> > /
> > > nForce 630M] (rev a2) (prog-if 00 [VGA controller])
> > >     Subsystem: Hewlett-Packard Company Device 30cf
> > >     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> > > Stepping- SERR- FastB2B- DisINTx-
> > >     Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
> > <TAbort-
> > > <MAbort- >SERR- <PERR- INTx-
> > >     Latency: 0
> > >     Interrupt: pin A routed to IRQ 16
> > >     Region 0: Memory at f5000000 (32-bit, non-prefetchable) [size=16M]
> > >     Region 1: Memory at d0000000 (64-bit, prefetchable) [size=256M]
> > >     Region 3: Memory at f4000000 (64-bit, non-prefetchable) [size=16M]
> > >     [virtual] Expansion ROM at 80000000 [disabled] [size=128K]
> > >     Capabilities: [48] Power Management version 2
> > >         Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> > > PME(D0-,D1-,D2-,D3hot-,D3cold-)
> > >         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
> > >     Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
> > >         Address: 0000000000000000  Data: 0000
> > >     Kernel driver in use: nouveau
> > >     Kernel modules: nouveau
> > >
> > > 00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
> > > HyperTransport Technology Configuration
> > >     Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
> > > Stepping- SERR- FastB2B- DisINTx-
> > >     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> > <TAbort-
> > > <MAbort- >SERR- <PERR- INTx-
> > >     Capabilities: [80] HyperTransport: Host or Secondary Interface
> > >         Command: WarmRst+ DblEnd- DevNum=0 ChainSide- HostHide+ Slave-
> > > <EOCErr- DUL-
> > >         Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=8
> > > IsocEn- LSEn+ ExtCTL- 64b+
> > >         Link Config: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=16bit
> > > DwFcInEn- LWO=16bit DwFcOutEn-
> > >         Revision ID: 1.02
> > >         Link Frequency: 800MHz
> > >         Link Error: <Prot- <Ovfl- <EOC- CTLTm-
> > >         Link Frequency Capability: 200MHz+ 300MHz- 400MHz+ 500MHz-
> > 600MHz+
> > > 800MHz+ 1.0GHz- 1.2GHz- 1.4GHz- 1.6GHz- Vend-
> > >         Feature Capability: IsocFC- LDTSTOP+ CRCTM- ECTLT- 64bA- UIDRD-
> > > ExtRS- UCnfE-
> > >
> > > 00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
> > > Address Map
> > >     Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
> > > Stepping- SERR- FastB2B- DisINTx-
> > >     Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> > <TAbort-
> > > <MAbort- >SERR- <PERR- INTx-
> > >
> > > 00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
> > DRAM
> > > Controller
> > >     Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
> > > Stepping- SERR- FastB2B- DisINTx-
> > >     Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> > <TAbort-
> > > <MAbort- >SERR- <PERR- INTx-
> > >
> > > 00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]
> > > Miscellaneous Control
> > >     Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
> > > Stepping- SERR- FastB2B- DisINTx-
> > >     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> > <TAbort-
> > > <MAbort- >SERR- <PERR- INTx-
> > >     Capabilities: [f0] Secure device <?>
> > >     Kernel driver in use: k8temp
> > >     Kernel modules: k8temp
> > >
> > > 02:05.0 FireWire (IEEE 1394): Ricoh Co Ltd R5C832 IEEE 1394 Controller
> > (rev
> > > 05) (prog-if 10 [OHCI])
> > >     Subsystem: Hewlett-Packard Company Device 30cf
> > >     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> > > Stepping- SERR+ FastB2B- DisINTx-
> > >     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
> > > <TAbort- <MAbort- >SERR- <PERR- INTx-
> > >     Latency: 64 (500ns min, 1000ns max), Cache Line Size: 64 bytes
> > >     Interrupt: pin A routed to IRQ 5
> > >     Region 0: Memory at f6100000 (32-bit, non-prefetchable) [size=2K]
> > >     Capabilities: [dc] Power Management version 2
> > >         Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
> > > PME(D0+,D1+,D2+,D3hot+,D3cold+)
> > >         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=2 PME+
> > >     Kernel driver in use: firewire_ohci
> > >     Kernel modules: firewire-ohci
> > >
> > > 02:05.1 SD Host controller: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host
> > > Adapter (rev 22)
> > >     Subsystem: Hewlett-Packard Company Device 30cf
> > >     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> > > Stepping- SERR+ FastB2B- DisINTx-
> > >     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
> > > <TAbort- <MAbort- >SERR- <PERR- INTx-
> > >     Latency: 64, Cache Line Size: 64 bytes
> > >     Interrupt: pin B routed to IRQ 7
> > >     Region 0: Memory at f6100800 (32-bit, non-prefetchable) [size=256]
> > >     Capabilities: [80] Power Management version 2
> > >         Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
> > > PME(D0+,D1+,D2+,D3hot+,D3cold+)
> > >         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=2 PME-
> > >     Kernel driver in use: sdhci-pci
> > >     Kernel modules: sdhci-pci
> > >
> > > 02:05.2 System peripheral: Ricoh Co Ltd R5C592 Memory Stick Bus Host
> > Adapter
> > > (rev 12)
> > >     Subsystem: Hewlett-Packard Company Device 30cf
> > >     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> > > Stepping- SERR+ FastB2B- DisINTx-
> > >     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
> > > <TAbort- <MAbort- >SERR- <PERR- INTx-
> > >     Latency: 64, Cache Line Size: 64 bytes
> > >     Interrupt: pin B routed to IRQ 11
> > >     Region 0: Memory at f6101000 (32-bit, non-prefetchable) [size=256]
> > >     Capabilities: [80] Power Management version 2
> > >         Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
> > > PME(D0+,D1+,D2+,D3hot+,D3cold+)
> > >         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=2 PME-
> > >
> > > 02:05.3 System peripheral: Ricoh Co Ltd xD-Picture Card Controller (rev
> > 12)
> > >     Subsystem: Hewlett-Packard Company Device 30cf
> > >     Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> > > Stepping- SERR+ FastB2B- DisINTx-
> > >     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
> > > <TAbort- <MAbort- >SERR- <PERR- INTx-
> > >     Latency: 64, Cache Line Size: 64 bytes
> > >     Interrupt: pin B routed to IRQ 11
> > >     Region 0: Memory at f6101400 (32-bit, non-prefetchable) [size=256]
> > >     Capabilities: [80] Power Management version 2
> > >         Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
> > > PME(D0+,D1+,D2+,D3hot+,D3cold+)
> > >         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=2 PME-
> > >
> > > 03:00.0 Ethernet controller: Atheros Communications Inc. AR5001 Wireless
> > > Network Adapter (rev 01)
> > >     Subsystem: Hewlett-Packard Company Device 137a
> > >     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> > > Stepping- SERR+ FastB2B- DisINTx-
> > >     Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> > <TAbort-
> > > <MAbort- >SERR- <PERR- INTx-
> > >     Latency: 0, Cache Line Size: 64 bytes
> > >     Interrupt: pin A routed to IRQ 19
> > >     Region 0: Memory at f6000000 (64-bit, non-prefetchable) [size=64K]
> > >     Capabilities: [40] Power Management version 2
> > >         Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
> > > PME(D0-,D1-,D2-,D3hot-,D3cold-)
> > >         Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
> > >     Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit-
> > >         Address: 00000000  Data: 0000
> > >     Capabilities: [60] Express (v1) Legacy Endpoint, MSI 00
> > >         DevCap:    MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns,
> > L1
> > > <64us
> > >             ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
> > >         DevCtl:    Report errors: Correctable- Non-Fatal- Fatal-
> > > Unsupported-
> > >             RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
> > >             MaxPayload 128 bytes, MaxReadReq 512 bytes
> > >         DevSta:    CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr-
> > > TransPend-
> > >         LnkCap:    Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency
> > L0
> > > <512ns, L1 <64us
> > >             ClockPM- Surprise- LLActRep- BwNot-
> > >         LnkCtl:    ASPM L1 Enabled; RCB 128 bytes Disabled- Retrain-
> > > CommClk+
> > >             ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
> > >         LnkSta:    Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+
> > DLActive-
> > > BWMgmt- ABWMgmt-
> > >     Capabilities: [90] MSI-X: Enable- Count=1 Masked-
> > >         Vector table: BAR=0 offset=00000000
> > >         PBA: BAR=0 offset=00000000
> > >     Capabilities: [100] Advanced Error Reporting
> > >         UESta:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
> > RxOF-
> > > MalfTLP- ECRC- UnsupReq- ACSViol-
> > >         UEMsk:    DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt-
> > RxOF-
> > > MalfTLP- ECRC- UnsupReq- ACSViol-
> > >         UESvrt:    DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt-
> > RxOF+
> > > MalfTLP+ ECRC- UnsupReq- ACSViol-
> > >         CESta:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
> > >         CEMsk:    RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr-
> > >         AERCap:    First Error Pointer: 00, GenCap+ CGenEn- ChkCap+
> > ChkEn-
> > >     Capabilities: [140] Virtual Channel <?>
> > >     Kernel driver in use: ath5k
> > >     Kernel modules: ath5k
> > >
> > > [8.6] /proc/scsi/scsi
> > > Attached devices:
> > > Host: scsi0 Channel: 00 Id: 00 Lun: 00
> > >   Vendor: ATA      Model: WDC WD2500BEVS-6 Rev: 01.0
> > >   Type:   Direct-Access                    ANSI  SCSI revision: 05
> > >
> > > [8.7] other relevent?
> > > /proc/diskstats
> > >
> > >    1       0 ram0 0 0 0 0 0 0 0 0 0 0 0
> > >    1       1 ram1 0 0 0 0 0 0 0 0 0 0 0
> > >    1       2 ram2 0 0 0 0 0 0 0 0 0 0 0
> > >    1       3 ram3 0 0 0 0 0 0 0 0 0 0 0
> > >    1       4 ram4 0 0 0 0 0 0 0 0 0 0 0
> > >    1       5 ram5 0 0 0 0 0 0 0 0 0 0 0
> > >    1       6 ram6 0 0 0 0 0 0 0 0 0 0 0
> > >    1       7 ram7 0 0 0 0 0 0 0 0 0 0 0
> > >    1       8 ram8 0 0 0 0 0 0 0 0 0 0 0
> > >    1       9 ram9 0 0 0 0 0 0 0 0 0 0 0
> > >    1      10 ram10 0 0 0 0 0 0 0 0 0 0 0
> > >    1      11 ram11 0 0 0 0 0 0 0 0 0 0 0
> > >    1      12 ram12 0 0 0 0 0 0 0 0 0 0 0
> > >    1      13 ram13 0 0 0 0 0 0 0 0 0 0 0
> > >    1      14 ram14 0 0 0 0 0 0 0 0 0 0 0
> > >    1      15 ram15 0 0 0 0 0 0 0 0 0 0 0
> > >    7       0 loop0 0 0 0 0 0 0 0 0 0 0 0
> > >    7       1 loop1 0 0 0 0 0 0 0 0 0 0 0
> > >    7       2 loop2 0 0 0 0 0 0 0 0 0 0 0
> > >    7       3 loop3 0 0 0 0 0 0 0 0 0 0 0
> > >    7       4 loop4 0 0 0 0 0 0 0 0 0 0 0
> > >    7       5 loop5 0 0 0 0 0 0 0 0 0 0 0
> > >    7       6 loop6 0 0 0 0 0 0 0 0 0 0 0
> > >    7       7 loop7 0 0 0 0 0 0 0 0 0 0 0
> > >    8       0 sda 50716 57998 2473876 2202457 103474 270866 2987232
> > 34111109
> > > 0 2512512 36313430
> > >    8       1 sda1 244 560 1307 936 0 0 0 0 0 829 936
> > >    8       2 sda2 2 0 4 329 0 0 0 0 0 329 329
> > >    8       3 sda3 134 43 1458 797 8 0 64 17 0 801 814
> > >    8       5 sda5 48172 40525 2410430 2047571 101140 218308 2555632
> > 33199467
> > > 0 2472881 35246887
> > >    8       6 sda6 833 3446 27875 135862 342 40963 330488 602578 0 102713
> > > 738438
> > >    8       7 sda7 1316 13424 32682 16768 1035 11595 101040 278967 0 47192
> > > 295730
> > >  253       0 dm-0 141 0 1122 787 10 0 64 147 0 371 934
> > >
> > > /proc/partitions
> > > major minor  #blocks  name
> > >
> > >    8        0  244198584 sda
> > >    8        1   20482843 sda1
> > >    8        2          1 sda2
> > >    8        3   12516352 sda3
> > >    8        5   32957316 sda5
> > >    8        6    1461883 sda6
> > >    8        7  176779197 sda7
> > >  253        0   12513280 dm-0
> > Non-text part: text/html
> >
> > >  LocalWords:  ctl html
> >
Non-text part: text/html
