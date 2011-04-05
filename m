Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371Ab1DEQbs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 12:31:48 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:35511 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972Ab1DEQbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 12:31:45 -0400
Date: Tue, 5 Apr 2011 18:31:41 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: linux-kernel@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org
Subject: Re: WARNING: at drivers/gpu/drm/ttm/ttm_page_alloc.c:758
Message-ID: <20110405163141.GA1651@x4.trippels.de>
References: <20110329145651.GA1641@gentoo.trippels.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="J/dobhs11T7y2rNN"
Content-Disposition: inline
In-Reply-To: <20110329145651.GA1641@gentoo.trippels.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2011.03.29 at 16:56 +0200, Markus Trippelsdorf wrote:
> Just came across this WARNING (running latest git kernel):
> 
> Mar 29 09:14:39 gentoo kernel: udev[888]: starting version 164                                                                                       
> Mar 29 15:45:45 gentoo kernel: ------------[ cut here ]------------                                                                                  
> Mar 29 15:45:45 gentoo kernel: WARNING: at drivers/gpu/drm/ttm/ttm_page_alloc.c:758 ttm_put_pages+0x1c6/0x2b0()                                      
> Mar 29 15:45:45 gentoo kernel: Hardware name: System Product Name                                                                                    
It happened again today.

 ------------[ cut here ]------------                                                                                      
 WARNING: at drivers/gpu/drm/ttm/ttm_page_alloc.c:758 ttm_put_pages+0x1c6/0x2c0()                                          
 Hardware name: System Product Name                                                                                        
 Pid: 680, comm: kworker/u:6 Not tainted 2.6.39-rc1-00254-gd297f96 #5                                                      
 Call Trace:                                                                                                               
 [<ffffffff810736af>] warn_slowpath_common+0x6f/0xa0                                                                       
 [<ffffffff810737fa>] warn_slowpath_null+0x1a/0x20                                                                         
 [<ffffffff812c7726>] ttm_put_pages+0x1c6/0x2c0                                                                            
 [<ffffffff812bff7d>] ttm_tt_free_alloced_pages+0xbd/0x100                                                                 
 [<ffffffff812c0a5c>] ttm_tt_swapout+0x1bc/0x2c0                                                                           
 [<ffffffff812c2365>] ttm_bo_swapout+0x1a5/0x240                                                                           
 [<ffffffff812b5637>] ? drm_mm_kmalloc+0x37/0xe0                                                                           
 [<ffffffff812bf3b8>] ttm_shrink+0xd8/0x140                                                                                
 [<ffffffff8108eb01>] ? queue_work+0x21/0x60                                                                               
 [<ffffffff812bf420>] ? ttm_shrink+0x140/0x140                                                                             
 [<ffffffff812bf439>] ttm_shrink_work+0x19/0x20                                                                            
 [<ffffffff8108dade>] process_one_work+0x11e/0x4e0                                                                         
 [<ffffffff8108e4ce>] worker_thread+0x16e/0x360                                                                            
 [<ffffffff8108e360>] ? manage_workers.isra.28+0x260/0x260                                                                 
 [<ffffffff810932ac>] kthread+0x8c/0xa0                                                                                    
 [<ffffffff8152a394>] kernel_thread_helper+0x4/0x10                                                                        
 [<ffffffff81093220>] ? kthread_flush_work_fn+0x20/0x20                                                                    
 [<ffffffff8152a390>] ? gs_change+0xb/0xb                                                                                  
 ---[ end trace cb7fc1aad109a0a7 ]---                                                                                      
 ------------[ cut here ]------------

So its not a easily reproducible problem. My config and a full dmesg are
attached, in case anybody is interested.

-- 
Markus

--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=config

#
# Automatically generated make config: don't edit
# Linux/x86_64 2.6.39-rc1 Kernel Configuration
# Sun Apr  3 19:17:02 2011
#
CONFIG_64BIT=y
# CONFIG_X86_32 is not set
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
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
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
# CONFIG_KTIME_SCALAR is not set
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y
CONFIG_HAVE_IRQ_WORK=y
CONFIG_IRQ_WORK=y

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
# CONFIG_KERNEL_GZIP is not set
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
CONFIG_KERNEL_LZO=y
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
# CONFIG_FHANDLE is not set
# CONFIG_TASKSTATS is not set
# CONFIG_AUDIT is not set
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_HAVE_SPARSE_IRQ=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_IRQ_FORCED_THREADING=y
# CONFIG_SPARSE_IRQ is not set

#
# RCU Subsystem
#
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
# CONFIG_RCU_TRACE is not set
CONFIG_RCU_FANOUT=64
# CONFIG_RCU_FANOUT_EXACT is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_LOG_BUF_SHIFT=16
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
# CONFIG_CGROUP_NS is not set
# CONFIG_CGROUP_FREEZER is not set
# CONFIG_CGROUP_DEVICE is not set
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_RESOURCE_COUNTERS is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_RT_GROUP_SCHED is not set
# CONFIG_BLK_CGROUP is not set
# CONFIG_NAMESPACES is not set
# CONFIG_SCHED_AUTOGROUP is not set
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
# CONFIG_BLK_DEV_INITRD is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_EXPERT=y
CONFIG_EMBEDDED=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_EXTRA_PASS is not set
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_ELF_CORE is not set
# CONFIG_PCSPKR_PLATFORM is not set
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_PERF_COUNTERS is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
# CONFIG_SLUB_DEBUG is not set
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
CONFIG_TRACEPOINTS=y
CONFIG_HAVE_OPROFILE=y
CONFIG_JUMP_LABEL=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_USER_RETURN_NOTIFIER=y
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

#
# GCOV-based kernel profiling
#
# CONFIG_GCOV_KERNEL is not set
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
# CONFIG_BLK_DEV_INTEGRITY is not set

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_DEADLINE is not set
CONFIG_IOSCHED_CFQ=y
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_PREEMPT_NOTIFIERS=y
# CONFIG_INLINE_SPIN_TRYLOCK is not set
# CONFIG_INLINE_SPIN_TRYLOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK is not set
# CONFIG_INLINE_SPIN_LOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK_IRQ is not set
# CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
# CONFIG_INLINE_SPIN_UNLOCK is not set
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
CONFIG_MUTEX_SPIN_ON_OWNER=y
# CONFIG_FREEZER is not set

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
# CONFIG_NO_HZ is not set
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
# CONFIG_X86_MPPARSE is not set
# CONFIG_X86_EXTENDED_PLATFORM is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
CONFIG_SCHED_OMIT_FRAME_POINTER=y
# CONFIG_PARAVIRT_GUEST is not set
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
CONFIG_MK8=y
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
# CONFIG_GENERIC_CPU is not set
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_CMPXCHG=y
CONFIG_CMPXCHG_LOCAL=y
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_PROCESSOR_SELECT=y
# CONFIG_CPU_SUP_INTEL is not set
CONFIG_CPU_SUP_AMD=y
# CONFIG_CPU_SUP_CENTAUR is not set
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
# CONFIG_GART_IOMMU is not set
# CONFIG_CALGARY_IOMMU is not set
# CONFIG_AMD_IOMMU is not set
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
# CONFIG_IOMMU_API is not set
CONFIG_NR_CPUS=4
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
# CONFIG_X86_MCE_INTEL is not set
CONFIG_X86_MCE_AMD=y
CONFIG_X86_MCE_THRESHOLD=y
# CONFIG_X86_MCE_INJECT is not set
# CONFIG_I8K is not set
# CONFIG_MICROCODE is not set
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
# CONFIG_NUMA is not set
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
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
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
# CONFIG_KSM is not set
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_MEMORY_FAILURE is not set
CONFIG_TRANSPARENT_HUGEPAGE=y
CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
# CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=2
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
# CONFIG_EFI is not set
CONFIG_SECCOMP=y
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x200000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
# CONFIG_HOTPLUG_CPU is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
# CONFIG_HIBERNATION is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_ACPI=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_POWER_METER is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
# CONFIG_ACPI_PROC_EVENT is not set
# CONFIG_ACPI_AC is not set
# CONFIG_ACPI_BATTERY is not set
CONFIG_ACPI_BUTTON=y
# CONFIG_ACPI_VIDEO is not set
# CONFIG_ACPI_FAN is not set
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
CONFIG_ACPI_THERMAL=y
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
# CONFIG_CPU_FREQ_DEBUG is not set
CONFIG_CPU_FREQ_STAT=y
# CONFIG_CPU_FREQ_STAT_DETAILS is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
# CONFIG_CPU_FREQ_GOV_POWERSAVE is not set
# CONFIG_CPU_FREQ_GOV_USERSPACE is not set
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# CPUFreq processor drivers
#
# CONFIG_X86_PCC_CPUFREQ is not set
# CONFIG_X86_ACPI_CPUFREQ is not set
CONFIG_X86_POWERNOW_K8=y
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
# CONFIG_X86_P4_CLOCKMOD is not set

#
# shared options
#
# CONFIG_X86_SPEEDSTEP_LIB is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y

#
# Memory power savings
#
# CONFIG_I7300_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
# CONFIG_PCI_MMCONFIG is not set
CONFIG_PCI_DOMAINS=y
# CONFIG_PCI_CNB20LE_QUIRK is not set
# CONFIG_DMAR is not set
# CONFIG_INTR_REMAP is not set
# CONFIG_PCIEPORTBUS is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_STUB is not set
CONFIG_HT_IRQ=y
# CONFIG_PCI_IOV is not set
CONFIG_PCI_IOAPIC=y
CONFIG_ISA_DMA_API=y
CONFIG_AMD_NB=y
# CONFIG_PCCARD is not set
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
# CONFIG_HAVE_AOUT is not set
# CONFIG_BINFMT_MISC is not set
# CONFIG_IA32_EMULATION is not set
# CONFIG_COMPAT_FOR_U64_ALIGNMENT is not set
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_UNIX=y
# CONFIG_NET_KEY is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
# CONFIG_IP_ADVANCED_ROUTER is not set
# CONFIG_IP_PNP is not set
# CONFIG_NET_IPIP is not set
# CONFIG_NET_IPGRE_DEMUX is not set
# CONFIG_ARPD is not set
# CONFIG_SYN_COOKIES is not set
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
# CONFIG_INET_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
# CONFIG_INET_XFRM_MODE_BEET is not set
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
# CONFIG_TCP_MD5SIG is not set
# CONFIG_IPV6 is not set
# CONFIG_NETWORK_SECMARK is not set
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
# CONFIG_NETFILTER_ADVANCED is not set

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=y
CONFIG_NETFILTER_NETLINK_LOG=y
CONFIG_NF_CONNTRACK=y
CONFIG_NF_CONNTRACK_FTP=y
CONFIG_NF_CONNTRACK_IRC=y
CONFIG_NF_CONNTRACK_SIP=y
CONFIG_NF_CT_NETLINK=y
CONFIG_NETFILTER_XTABLES=y

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=y

#
# Xtables targets
#
CONFIG_NETFILTER_XT_TARGET_NFLOG=y
CONFIG_NETFILTER_XT_TARGET_TCPMSS=y

#
# Xtables matches
#
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=y
CONFIG_NETFILTER_XT_MATCH_STATE=y
# CONFIG_IP_SET is not set
# CONFIG_IP_VS is not set

#
# IP: Netfilter Configuration
#
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
# CONFIG_NF_NAT_TFTP is not set
# CONFIG_NF_NAT_AMANDA is not set
# CONFIG_NF_NAT_PPTP is not set
# CONFIG_NF_NAT_H323 is not set
CONFIG_NF_NAT_SIP=y
CONFIG_IP_NF_MANGLE=y
# CONFIG_IP_DCCP is not set
# CONFIG_IP_SCTP is not set
# CONFIG_RDS is not set
# CONFIG_TIPC is not set
# CONFIG_ATM is not set
# CONFIG_L2TP is not set
CONFIG_STP=y
CONFIG_BRIDGE=y
CONFIG_BRIDGE_IGMP_SNOOPING=y
# CONFIG_NET_DSA is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
CONFIG_LLC=y
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
# CONFIG_ATALK is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
# CONFIG_WAN_ROUTER is not set
# CONFIG_PHONET is not set
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
# CONFIG_DCB is not set
# CONFIG_BATMAN_ADV is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
# CONFIG_NET_DROP_MONITOR is not set
# CONFIG_HAMRADIO is not set
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
# CONFIG_AF_RXRPC is not set
# CONFIG_WIRELESS is not set
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
# CONFIG_NET_9P is not set
# CONFIG_CAIF is not set
# CONFIG_CEPH_LIB is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
CONFIG_STANDALONE=y
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE="radeon/R600_rlc.bin"
CONFIG_EXTRA_FIRMWARE_DIR="/lib/firmware"
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_ARCH_NO_SYSDEV_OPS=y
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_CPQ_DA is not set
# CONFIG_BLK_CPQ_CISS_DA is not set
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
# CONFIG_BLK_DEV_CRYPTOLOOP is not set

#
# DRBD disabled because PROC_FS, INET or CONNECTOR not selected
#
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_SX8 is not set
# CONFIG_BLK_DEV_UB is not set
# CONFIG_BLK_DEV_RAM is not set
CONFIG_CDROM_PKTCDVD=y
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_VIRTIO_BLK is not set
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RBD is not set
# CONFIG_SENSORS_LIS3LV02D is not set
# CONFIG_MISC_DEVICES is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
# CONFIG_SCSI_TGT is not set
# CONFIG_SCSI_NETLINK is not set
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=y
# CONFIG_BLK_DEV_SR_VENDOR is not set
CONFIG_CHR_DEV_SG=y
# CONFIG_CHR_DEV_SCH is not set
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
# CONFIG_SCSI_SPI_ATTRS is not set
# CONFIG_SCSI_FC_ATTRS is not set
# CONFIG_SCSI_ISCSI_ATTRS is not set
# CONFIG_SCSI_SAS_ATTRS is not set
# CONFIG_SCSI_SAS_LIBSAS is not set
# CONFIG_SCSI_SRP_ATTRS is not set
# CONFIG_SCSI_LOWLEVEL is not set
# CONFIG_SCSI_DH is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_VERBOSE_ERROR=y
# CONFIG_ATA_ACPI is not set
# CONFIG_SATA_PMP is not set

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=y
# CONFIG_SATA_AHCI_PLATFORM is not set
# CONFIG_SATA_INIC162X is not set
# CONFIG_SATA_ACARD_AHCI is not set
# CONFIG_SATA_SIL24 is not set
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_SX4 is not set
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
# CONFIG_ATA_PIIX is not set
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_SVW is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set

#
# PATA SFF controllers with BMDMA
#
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARASAN_CF is not set
# CONFIG_PATA_ARTOP is not set
CONFIG_PATA_ATIIXP=y
# CONFIG_PATA_ATP867X is not set
# CONFIG_PATA_CMD64X is not set
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CS5536 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT8213 is not set
# CONFIG_PATA_IT821X is not set
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NINJA32 is not set
# CONFIG_PATA_NS87415 is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RDC is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SCH is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_TOSHIBA is not set
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set

#
# PIO-only SFF controllers
#
# CONFIG_PATA_CMD640_PCI is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_PLATFORM is not set
# CONFIG_PATA_RZ1000 is not set

#
# Generic fallback / legacy drivers
#
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_LEGACY is not set
# CONFIG_MD is not set
# CONFIG_TARGET_CORE is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
# CONFIG_MACINTOSH_DRIVERS is not set
CONFIG_NETDEVICES=y
CONFIG_DUMMY=y
# CONFIG_BONDING is not set
# CONFIG_MACVLAN is not set
# CONFIG_EQUALIZER is not set
CONFIG_TUN=y
# CONFIG_VETH is not set
# CONFIG_NET_SB1000 is not set
# CONFIG_ARCNET is not set
CONFIG_MII=y
# CONFIG_PHYLIB is not set
# CONFIG_NET_ETHERNET is not set
CONFIG_NETDEV_1000=y
# CONFIG_ACENIC is not set
# CONFIG_DL2K is not set
# CONFIG_E1000 is not set
# CONFIG_E1000E is not set
# CONFIG_IP1000 is not set
# CONFIG_IGB is not set
# CONFIG_IGBVF is not set
# CONFIG_NS83820 is not set
# CONFIG_HAMACHI is not set
# CONFIG_YELLOWFIN is not set
# CONFIG_R8169 is not set
# CONFIG_SIS190 is not set
# CONFIG_SKGE is not set
# CONFIG_SKY2 is not set
# CONFIG_VIA_VELOCITY is not set
# CONFIG_TIGON3 is not set
# CONFIG_BNX2 is not set
# CONFIG_CNIC is not set
# CONFIG_QLA3XXX is not set
# CONFIG_ATL1 is not set
CONFIG_ATL1E=y
# CONFIG_ATL1C is not set
# CONFIG_JME is not set
# CONFIG_STMMAC_ETH is not set
# CONFIG_PCH_GBE is not set
# CONFIG_NETDEV_10000 is not set
# CONFIG_TR is not set
# CONFIG_WLAN is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#

#
# USB Network Adapters
#
# CONFIG_USB_CATC is not set
# CONFIG_USB_KAWETH is not set
# CONFIG_USB_PEGASUS is not set
# CONFIG_USB_RTL8150 is not set
# CONFIG_USB_USBNET is not set
# CONFIG_USB_IPHETH is not set
# CONFIG_WAN is not set

#
# CAIF transport drivers
#
# CONFIG_FDDI is not set
# CONFIG_HIPPI is not set
CONFIG_PPP=y
# CONFIG_PPP_MULTILINK is not set
CONFIG_PPP_FILTER=y
CONFIG_PPP_ASYNC=y
CONFIG_PPP_SYNC_TTY=y
# CONFIG_PPP_DEFLATE is not set
# CONFIG_PPP_BSDCOMP is not set
# CONFIG_PPP_MPPE is not set
# CONFIG_PPPOE is not set
# CONFIG_SLIP is not set
CONFIG_SLHC=y
# CONFIG_NET_FC is not set
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
# CONFIG_VIRTIO_NET is not set
# CONFIG_VMXNET3 is not set
# CONFIG_ISDN is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
# CONFIG_INPUT_POLLDEV is not set
# CONFIG_INPUT_SPARSEKMAP is not set

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
# CONFIG_INPUT_JOYDEV is not set
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
# CONFIG_MOUSE_PS2 is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
# CONFIG_MOUSE_BCM5974 is not set
# CONFIG_MOUSE_VSXXXAA is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
# CONFIG_GAMEPORT is not set

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
CONFIG_UNIX98_PTYS=y
# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
# CONFIG_LEGACY_PTYS is not set
# CONFIG_SERIAL_NONSTANDARD is not set
# CONFIG_NOZOMI is not set
# CONFIG_N_GSM is not set
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
# CONFIG_SERIAL_8250 is not set
CONFIG_FIX_EARLYCON_MEM=y

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MFD_HSU is not set
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_TTY_PRINTK is not set
# CONFIG_VIRTIO_CONSOLE is not set
# CONFIG_IPMI_HANDLER is not set
# CONFIG_HW_RANDOM is not set
# CONFIG_NVRAM is not set
# CONFIG_R3964 is not set
# CONFIG_APPLICOM is not set
# CONFIG_MWAVE is not set
# CONFIG_RAW_DRIVER is not set
CONFIG_HPET=y
CONFIG_HPET_MMAP=y
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
# CONFIG_RAMOOPS is not set
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=y
# CONFIG_I2C_MUX is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
# CONFIG_I2C_AMD756 is not set
# CONFIG_I2C_AMD8111 is not set
# CONFIG_I2C_I801 is not set
# CONFIG_I2C_ISCH is not set
# CONFIG_I2C_PIIX4 is not set
# CONFIG_I2C_NFORCE2 is not set
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_INTEL_MID is not set
# CONFIG_I2C_OCORES is not set
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_I2C_XILINX is not set
# CONFIG_I2C_EG20T is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
# CONFIG_I2C_PARPORT_LIGHT is not set
# CONFIG_I2C_TAOS_EVM is not set
# CONFIG_I2C_TINY_USB is not set

#
# Other I2C/SMBus bus drivers
#
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set

#
# PPS support
#
# CONFIG_PPS is not set

#
# PPS generators support
#
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_BQ20Z75 is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_MAX17040 is not set
# CONFIG_BATTERY_MAX17042 is not set
CONFIG_HWMON=y
# CONFIG_HWMON_VID is not set
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
# CONFIG_SENSORS_ABITUGURU is not set
# CONFIG_SENSORS_ABITUGURU3 is not set
# CONFIG_SENSORS_AD7414 is not set
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7411 is not set
# CONFIG_SENSORS_ADT7462 is not set
# CONFIG_SENSORS_ADT7470 is not set
# CONFIG_SENSORS_ADT7475 is not set
# CONFIG_SENSORS_ASC7621 is not set
# CONFIG_SENSORS_K8TEMP is not set
CONFIG_SENSORS_K10TEMP=y
# CONFIG_SENSORS_ASB100 is not set
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS620 is not set
# CONFIG_SENSORS_DS1621 is not set
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_G760A is not set
# CONFIG_SENSORS_GL518SM is not set
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_PKGTEMP is not set
# CONFIG_SENSORS_IT87 is not set
# CONFIG_SENSORS_JC42 is not set
# CONFIG_SENSORS_LINEAGE is not set
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM73 is not set
# CONFIG_SENSORS_LM75 is not set
# CONFIG_SENSORS_LM77 is not set
# CONFIG_SENSORS_LM78 is not set
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
# CONFIG_SENSORS_LM90 is not set
# CONFIG_SENSORS_LM92 is not set
# CONFIG_SENSORS_LM93 is not set
# CONFIG_SENSORS_LTC4151 is not set
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4245 is not set
# CONFIG_SENSORS_LTC4261 is not set
# CONFIG_SENSORS_LM95241 is not set
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX6639 is not set
# CONFIG_SENSORS_MAX6650 is not set
# CONFIG_SENSORS_PC87360 is not set
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_PMBUS is not set
# CONFIG_SENSORS_SHT21 is not set
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_EMC1403 is not set
# CONFIG_SENSORS_EMC2103 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
# CONFIG_SENSORS_SCH5627 is not set
# CONFIG_SENSORS_ADS1015 is not set
# CONFIG_SENSORS_ADS7828 is not set
# CONFIG_SENSORS_AMC6821 is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_TMP102 is not set
# CONFIG_SENSORS_TMP401 is not set
# CONFIG_SENSORS_TMP421 is not set
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
# CONFIG_SENSORS_VT1211 is not set
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
# CONFIG_SENSORS_W83792D is not set
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83795 is not set
# CONFIG_SENSORS_W83L785TS is not set
# CONFIG_SENSORS_W83L786NG is not set
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
# CONFIG_SENSORS_APPLESMC is not set

#
# ACPI drivers
#
CONFIG_SENSORS_ATK0110=y
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
# CONFIG_SSB is not set
# CONFIG_MFD_SUPPORT is not set
# CONFIG_REGULATOR is not set
# CONFIG_MEDIA_SUPPORT is not set

#
# Graphics support
#
# CONFIG_AGP is not set
# CONFIG_VGA_ARB is not set
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_TTM=y
# CONFIG_DRM_TDFX is not set
# CONFIG_DRM_R128 is not set
CONFIG_DRM_RADEON=y
CONFIG_DRM_RADEON_KMS=y
# CONFIG_DRM_MGA is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_STUB_POULSBO is not set
# CONFIG_VGASTATE is not set
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
# CONFIG_FB_DDC is not set
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
# CONFIG_FB_SYS_FILLRECT is not set
# CONFIG_FB_SYS_COPYAREA is not set
# CONFIG_FB_SYS_IMAGEBLIT is not set
# CONFIG_FB_FOREIGN_ENDIAN is not set
# CONFIG_FB_SYS_FOPS is not set
# CONFIG_FB_WMT_GE_ROPS is not set
# CONFIG_FB_SVGALIB is not set
# CONFIG_FB_MACMODES is not set
# CONFIG_FB_BACKLIGHT is not set
CONFIG_FB_MODE_HELPERS=y
# CONFIG_FB_TILEBLITTING is not set

#
# Frame buffer hardware drivers
#
# CONFIG_FB_CIRRUS is not set
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_VESA is not set
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
# CONFIG_FB_RIVA is not set
# CONFIG_FB_LE80578 is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
# CONFIG_FB_ATY128 is not set
# CONFIG_FB_ATY is not set
# CONFIG_FB_S3 is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
# CONFIG_FB_NEOMAGIC is not set
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
# CONFIG_FB_UDL is not set
# CONFIG_FB_VIRTUAL is not set
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
# CONFIG_BACKLIGHT_LCD_SUPPORT is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y

#
# Display device support
#
# CONFIG_DISPLAY_SUPPORT is not set

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
# CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY is not set
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
# CONFIG_LOGO is not set
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
CONFIG_SOUND_OSS_CORE_PRECLAIM=y
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_HWDEP=y
CONFIG_SND_RAWMIDI=y
CONFIG_SND_SEQUENCER=y
CONFIG_SND_SEQ_DUMMY=y
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=y
CONFIG_SND_PCM_OSS=y
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_HRTIMER=y
CONFIG_SND_SEQ_HRTIMER_DEFAULT=y
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_SUPPORT_OLD_API=y
# CONFIG_SND_VERBOSE_PROCFS is not set
# CONFIG_SND_VERBOSE_PRINTK is not set
# CONFIG_SND_DEBUG is not set
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_RAWMIDI_SEQ=y
# CONFIG_SND_OPL3_LIB_SEQ is not set
# CONFIG_SND_OPL4_LIB_SEQ is not set
# CONFIG_SND_SBAWE_SEQ is not set
# CONFIG_SND_EMU10K1_SEQ is not set
# CONFIG_SND_DRIVERS is not set
# CONFIG_SND_PCI is not set
CONFIG_SND_USB=y
CONFIG_SND_USB_AUDIO=y
# CONFIG_SND_USB_UA101 is not set
# CONFIG_SND_USB_USX2Y is not set
# CONFIG_SND_USB_CAIAQ is not set
# CONFIG_SND_USB_US122L is not set
# CONFIG_SND_USB_6FIRE is not set
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
CONFIG_HIDRAW=y

#
# USB Input Devices
#
CONFIG_USB_HID=y
# CONFIG_HID_PID is not set
CONFIG_USB_HIDDEV=y

#
# Special HID drivers
#
# CONFIG_HID_3M_PCT is not set
# CONFIG_HID_A4TECH is not set
# CONFIG_HID_ACRUX is not set
# CONFIG_HID_APPLE is not set
# CONFIG_HID_BELKIN is not set
# CONFIG_HID_CANDO is not set
# CONFIG_HID_CHERRY is not set
# CONFIG_HID_CHICONY is not set
# CONFIG_HID_PRODIKEYS is not set
# CONFIG_HID_CYPRESS is not set
# CONFIG_HID_DRAGONRISE is not set
# CONFIG_HID_EMS_FF is not set
# CONFIG_HID_EZKEY is not set
# CONFIG_HID_KEYTOUCH is not set
# CONFIG_HID_KYE is not set
# CONFIG_HID_UCLOGIC is not set
# CONFIG_HID_WALTOP is not set
# CONFIG_HID_GYRATION is not set
# CONFIG_HID_TWINHAN is not set
# CONFIG_HID_KENSINGTON is not set
# CONFIG_HID_LCPOWER is not set
# CONFIG_HID_LOGITECH is not set
# CONFIG_HID_MICROSOFT is not set
# CONFIG_HID_MOSART is not set
# CONFIG_HID_MONTEREY is not set
# CONFIG_HID_MULTITOUCH is not set
# CONFIG_HID_NTRIG is not set
# CONFIG_HID_ORTEK is not set
# CONFIG_HID_PANTHERLORD is not set
# CONFIG_HID_PETALYNX is not set
# CONFIG_HID_PICOLCD is not set
# CONFIG_HID_QUANTA is not set
# CONFIG_HID_ROCCAT is not set
# CONFIG_HID_ROCCAT_ARVO is not set
# CONFIG_HID_ROCCAT_KONE is not set
# CONFIG_HID_ROCCAT_KONEPLUS is not set
# CONFIG_HID_ROCCAT_KOVAPLUS is not set
# CONFIG_HID_ROCCAT_PYRA is not set
# CONFIG_HID_SAMSUNG is not set
# CONFIG_HID_SONY is not set
# CONFIG_HID_STANTUM is not set
# CONFIG_HID_SUNPLUS is not set
# CONFIG_HID_GREENASIA is not set
# CONFIG_HID_SMARTJOYPLUS is not set
# CONFIG_HID_TOPSEED is not set
# CONFIG_HID_THRUSTMASTER is not set
# CONFIG_HID_ZEROPLUS is not set
# CONFIG_HID_ZYDACRON is not set
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
# CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set

#
# Miscellaneous USB options
#
# CONFIG_USB_DEVICEFS is not set
# CONFIG_USB_DEVICE_CLASS is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_OTG_WHITELIST is not set
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
CONFIG_USB_MON=y
# CONFIG_USB_WUSB is not set
# CONFIG_USB_WUSB_CBAF is not set

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
# CONFIG_USB_XHCI_HCD is not set
CONFIG_USB_EHCI_HCD=y
# CONFIG_USB_EHCI_ROOT_HUB_TT is not set
# CONFIG_USB_EHCI_TT_NEWSCHED is not set
# CONFIG_USB_OXU210HP_HCD is not set
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
# CONFIG_USB_ISP1362_HCD is not set
CONFIG_USB_OHCI_HCD=y
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
# CONFIG_USB_UHCI_HCD is not set
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
# CONFIG_USB_WHCI_HCD is not set
# CONFIG_USB_HWA_HCD is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set
# CONFIG_USB_WDM is not set
# CONFIG_USB_TMC is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=y
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_REALTEK is not set
# CONFIG_USB_STORAGE_DATAFAB is not set
# CONFIG_USB_STORAGE_FREECOM is not set
# CONFIG_USB_STORAGE_ISD200 is not set
# CONFIG_USB_STORAGE_USBAT is not set
# CONFIG_USB_STORAGE_SDDR09 is not set
# CONFIG_USB_STORAGE_SDDR55 is not set
# CONFIG_USB_STORAGE_JUMPSHOT is not set
# CONFIG_USB_STORAGE_ALAUDA is not set
# CONFIG_USB_STORAGE_ONETOUCH is not set
# CONFIG_USB_STORAGE_KARMA is not set
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
# CONFIG_USB_STORAGE_ENE_UB6250 is not set
# CONFIG_USB_UAS is not set
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
# CONFIG_USB_MDC800 is not set
# CONFIG_USB_MICROTEK is not set

#
# USB port drivers
#
CONFIG_USB_SERIAL=y
# CONFIG_USB_SERIAL_CONSOLE is not set
# CONFIG_USB_EZUSB is not set
CONFIG_USB_SERIAL_GENERIC=y
# CONFIG_USB_SERIAL_AIRCABLE is not set
# CONFIG_USB_SERIAL_ARK3116 is not set
# CONFIG_USB_SERIAL_BELKIN is not set
# CONFIG_USB_SERIAL_CH341 is not set
# CONFIG_USB_SERIAL_WHITEHEAT is not set
# CONFIG_USB_SERIAL_DIGI_ACCELEPORT is not set
# CONFIG_USB_SERIAL_CP210X is not set
# CONFIG_USB_SERIAL_CYPRESS_M8 is not set
# CONFIG_USB_SERIAL_EMPEG is not set
# CONFIG_USB_SERIAL_FTDI_SIO is not set
# CONFIG_USB_SERIAL_FUNSOFT is not set
# CONFIG_USB_SERIAL_VISOR is not set
# CONFIG_USB_SERIAL_IPAQ is not set
# CONFIG_USB_SERIAL_IR is not set
# CONFIG_USB_SERIAL_EDGEPORT is not set
# CONFIG_USB_SERIAL_EDGEPORT_TI is not set
# CONFIG_USB_SERIAL_GARMIN is not set
# CONFIG_USB_SERIAL_IPW is not set
# CONFIG_USB_SERIAL_IUU is not set
# CONFIG_USB_SERIAL_KEYSPAN_PDA is not set
# CONFIG_USB_SERIAL_KEYSPAN is not set
# CONFIG_USB_SERIAL_KLSI is not set
# CONFIG_USB_SERIAL_KOBIL_SCT is not set
# CONFIG_USB_SERIAL_MCT_U232 is not set
# CONFIG_USB_SERIAL_MOS7720 is not set
# CONFIG_USB_SERIAL_MOS7840 is not set
# CONFIG_USB_SERIAL_MOTOROLA is not set
# CONFIG_USB_SERIAL_NAVMAN is not set
# CONFIG_USB_SERIAL_PL2303 is not set
# CONFIG_USB_SERIAL_OTI6858 is not set
# CONFIG_USB_SERIAL_QCAUX is not set
# CONFIG_USB_SERIAL_QUALCOMM is not set
# CONFIG_USB_SERIAL_SPCP8X5 is not set
# CONFIG_USB_SERIAL_HP4X is not set
# CONFIG_USB_SERIAL_SAFE is not set
# CONFIG_USB_SERIAL_SAMBA is not set
# CONFIG_USB_SERIAL_SIEMENS_MPI is not set
# CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
# CONFIG_USB_SERIAL_SYMBOL is not set
# CONFIG_USB_SERIAL_TI is not set
# CONFIG_USB_SERIAL_CYBERJACK is not set
# CONFIG_USB_SERIAL_XIRCOM is not set
CONFIG_USB_SERIAL_WWAN=y
CONFIG_USB_SERIAL_OPTION=y
# CONFIG_USB_SERIAL_OMNINET is not set
# CONFIG_USB_SERIAL_OPTICON is not set
# CONFIG_USB_SERIAL_VIVOPAY_SERIAL is not set
# CONFIG_USB_SERIAL_ZIO is not set
# CONFIG_USB_SERIAL_SSU100 is not set
# CONFIG_USB_SERIAL_DEBUG is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
# CONFIG_USB_EMI26 is not set
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
# CONFIG_USB_LEGOTOWER is not set
# CONFIG_USB_LCD is not set
# CONFIG_USB_LED is not set
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
# CONFIG_USB_APPLEDISPLAY is not set
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
# CONFIG_USB_TEST is not set
# CONFIG_USB_ISIGHTFW is not set
# CONFIG_USB_YUREX is not set
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
# CONFIG_NOP_USB_XCEIV is not set
# CONFIG_UWB is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
# CONFIG_NEW_LEDS is not set
# CONFIG_NFC_DEVICES is not set
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y

#
# Reporting subsystems
#
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_DECODE_MCE=y
# CONFIG_EDAC_MCE_INJ is not set
CONFIG_EDAC_MM_EDAC=y
CONFIG_EDAC_AMD64=y
# CONFIG_EDAC_AMD64_ERROR_INJECTION is not set
# CONFIG_EDAC_E752X is not set
# CONFIG_EDAC_I82975X is not set
# CONFIG_EDAC_I3000 is not set
# CONFIG_EDAC_I3200 is not set
# CONFIG_EDAC_X38 is not set
# CONFIG_EDAC_I5400 is not set
# CONFIG_EDAC_I7CORE is not set
# CONFIG_EDAC_I5000 is not set
# CONFIG_EDAC_I5100 is not set
# CONFIG_EDAC_I7300 is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
CONFIG_RTC_HCTOSYS=y
CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
# CONFIG_RTC_DRV_DS1307 is not set
# CONFIG_RTC_DRV_DS1374 is not set
# CONFIG_RTC_DRV_DS1672 is not set
# CONFIG_RTC_DRV_DS3232 is not set
# CONFIG_RTC_DRV_MAX6900 is not set
# CONFIG_RTC_DRV_RS5C372 is not set
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_ISL12022 is not set
# CONFIG_RTC_DRV_X1205 is not set
# CONFIG_RTC_DRV_PCF8563 is not set
# CONFIG_RTC_DRV_PCF8583 is not set
# CONFIG_RTC_DRV_M41T80 is not set
# CONFIG_RTC_DRV_BQ32K is not set
# CONFIG_RTC_DRV_S35390A is not set
# CONFIG_RTC_DRV_FM3130 is not set
# CONFIG_RTC_DRV_RX8581 is not set
# CONFIG_RTC_DRV_RX8025 is not set

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
# CONFIG_RTC_DRV_DS1286 is not set
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
# CONFIG_RTC_DRV_DS1742 is not set
# CONFIG_RTC_DRV_STK17TA8 is not set
# CONFIG_RTC_DRV_M48T86 is not set
# CONFIG_RTC_DRV_M48T35 is not set
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_MSM6242 is not set
# CONFIG_RTC_DRV_BQ4802 is not set
# CONFIG_RTC_DRV_RP5C01 is not set
# CONFIG_RTC_DRV_V3020 is not set

#
# on-CPU RTC drivers
#
# CONFIG_DMADEVICES is not set
# CONFIG_AUXDISPLAY is not set
# CONFIG_UIO is not set
# CONFIG_STAGING is not set
# CONFIG_X86_PLATFORM_DEVICES is not set

#
# Firmware Drivers
#
# CONFIG_EDD is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
# CONFIG_DMIID is not set
# CONFIG_DMI_SYSFS is not set
# CONFIG_ISCSI_IBFT_FIND is not set
# CONFIG_SIGMA is not set

#
# File systems
#
# CONFIG_EXT2_FS is not set
# CONFIG_EXT3_FS is not set
# CONFIG_EXT4_FS is not set
# CONFIG_REISERFS_FS is not set
# CONFIG_JFS_FS is not set
CONFIG_XFS_FS=y
# CONFIG_XFS_QUOTA is not set
# CONFIG_XFS_POSIX_ACL is not set
# CONFIG_XFS_RT is not set
# CONFIG_XFS_DEBUG is not set
# CONFIG_GFS2_FS is not set
# CONFIG_BTRFS_FS is not set
# CONFIG_NILFS2_FS is not set
# CONFIG_FS_POSIX_ACL is not set
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
# CONFIG_QUOTA is not set
# CONFIG_QUOTACTL is not set
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set

#
# Caches
#
# CONFIG_FSCACHE is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
# CONFIG_ZISOFS is not set
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
# CONFIG_CONFIGFS_FS is not set
# CONFIG_MISC_FILESYSTEMS is not set
# CONFIG_NETWORK_FILESYSTEMS is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
# CONFIG_OSF_PARTITION is not set
# CONFIG_AMIGA_PARTITION is not set
# CONFIG_ATARI_PARTITION is not set
# CONFIG_MAC_PARTITION is not set
CONFIG_MSDOS_PARTITION=y
# CONFIG_BSD_DISKLABEL is not set
# CONFIG_MINIX_SUBPARTITION is not set
# CONFIG_SOLARIS_X86_PARTITION is not set
# CONFIG_UNIXWARE_DISKLABEL is not set
# CONFIG_LDM_PARTITION is not set
# CONFIG_SGI_PARTITION is not set
# CONFIG_ULTRIX_PARTITION is not set
# CONFIG_SUN_PARTITION is not set
# CONFIG_KARMA_PARTITION is not set
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
# CONFIG_NLS_CODEPAGE_855 is not set
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
# CONFIG_NLS_CODEPAGE_861 is not set
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
# CONFIG_NLS_CODEPAGE_865 is not set
# CONFIG_NLS_CODEPAGE_866 is not set
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
# CONFIG_NLS_CODEPAGE_950 is not set
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
# CONFIG_NLS_CODEPAGE_874 is not set
# CONFIG_NLS_ISO8859_8 is not set
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
# CONFIG_NLS_ISO8859_2 is not set
# CONFIG_NLS_ISO8859_3 is not set
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
# CONFIG_NLS_ISO8859_6 is not set
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
# CONFIG_NLS_ISO8859_14 is not set
CONFIG_NLS_ISO8859_15=y
# CONFIG_NLS_KOI8_R is not set
# CONFIG_NLS_KOI8_U is not set
CONFIG_NLS_UTF8=y

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
# CONFIG_PRINTK_TIME is not set
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
# CONFIG_ENABLE_WARN_DEPRECATED is not set
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=1024
CONFIG_MAGIC_SYSRQ=y
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_SECTION_MISMATCH is not set
# CONFIG_DEBUG_KERNEL is not set
# CONFIG_HARDLOCKUP_DETECTOR is not set
# CONFIG_SLUB_STATS is not set
# CONFIG_SPARSE_RCU_POINTER is not set
CONFIG_STACKTRACE=y
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_MEMORY_INIT is not set
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_RCU_CPU_STALL_DETECTOR=y
CONFIG_RCU_CPU_STALL_TIMEOUT=60
CONFIG_RCU_CPU_STALL_DETECTOR_RUNNABLE=y
CONFIG_RCU_CPU_STALL_VERBOSE=y
# CONFIG_LKDTM is not set
# CONFIG_SYSCTL_SYSCALL_CHECK is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FTRACE_NMI_ENTER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_RING_BUFFER=y
CONFIG_FTRACE_NMI_ENTER=y
CONFIG_EVENT_TRACING=y
CONFIG_EVENT_POWER_TRACING_DEPRECATED=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_PREEMPT_TRACER is not set
CONFIG_SCHED_TRACER=y
# CONFIG_FTRACE_SYSCALLS is not set
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
# CONFIG_STACK_TRACER is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
CONFIG_DYNAMIC_FTRACE=y
# CONFIG_FUNCTION_PROFILER is not set
CONFIG_FTRACE_MCOUNT_RECORD=y
# CONFIG_FTRACE_STARTUP_TEST is not set
# CONFIG_MMIOTRACE is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_DMA_API_DEBUG is not set
# CONFIG_ATOMIC64_SELFTEST is not set
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_TEST_KSTRTOX is not set
CONFIG_STRICT_DEVMEM=y
# CONFIG_X86_VERBOSE_BOOTUP is not set
# CONFIG_EARLY_PRINTK is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
# CONFIG_OPTIMIZE_INLINING is not set

#
# Security options
#
# CONFIG_KEYS is not set
# CONFIG_SECURITY_DMESG_RESTRICT is not set
# CONFIG_SECURITY is not set
# CONFIG_SECURITYFS is not set
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
# CONFIG_CRYPTO is not set
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_APIC_ARCHITECTURE=y
CONFIG_KVM_MMIO=y
CONFIG_KVM_ASYNC_PF=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=y
# CONFIG_KVM_INTEL is not set
CONFIG_KVM_AMD=y
# CONFIG_KVM_MMU_AUDIT is not set
CONFIG_VHOST_NET=y
CONFIG_VIRTIO=y
CONFIG_VIRTIO_RING=y
CONFIG_VIRTIO_PCI=y
# CONFIG_VIRTIO_BALLOON is not set
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_GENERIC_FIND_LAST_BIT=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
# CONFIG_CRC_T10DIF is not set
# CONFIG_CRC_ITU_T is not set
CONFIG_CRC32=y
# CONFIG_CRC7 is not set
# CONFIG_LIBCRC32C is not set
# CONFIG_XZ_DEC is not set
# CONFIG_XZ_DEC_BCJ is not set
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CPU_RMAP=y
CONFIG_NLATTR=y
# CONFIG_AVERAGE is not set

--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="kern.log"

Apr  5 08:15:25 x4 kernel: Initializing cgroup subsys cpu
Apr  5 08:15:25 x4 kernel: Linux version 2.6.39-rc1-00254-gd297f96 (markus@x4.trippels.de) (gcc version 4.6.1 20110402 (prerelease) (GCC) ) #5 SMP PREEMPT Tue Apr 5 08:12:35 CEST 2011
Apr  5 08:15:25 x4 kernel: Command line: root=PARTUUID=6d6a4009-3a90-40df-806a-e63f48189719 init=/sbin/minit rootflags=logbsize=262144 fbcon=rotate:3 drm_kms_helper.poll=0 quiet kexec_jump_back_entry=0x00000202a4814e49
Apr  5 08:15:25 x4 kernel: KERNEL supported cpus:
Apr  5 08:15:25 x4 kernel: AMD AuthenticAMD
Apr  5 08:15:25 x4 kernel: BIOS-provided physical RAM map:
Apr  5 08:15:25 x4 kernel: BIOS-e820: 0000000000000100 - 000000000009fc00 (usable)
Apr  5 08:15:25 x4 kernel: BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
Apr  5 08:15:25 x4 kernel: BIOS-e820: 00000000000e6000 - 0000000000100000 (reserved)
Apr  5 08:15:25 x4 kernel: BIOS-e820: 0000000000100000 - 00000000dfe90000 (usable)
Apr  5 08:15:26 x4 kernel: BIOS-e820: 00000000dfe90000 - 00000000dfea8000 (ACPI data)
Apr  5 08:15:26 x4 kernel: BIOS-e820: 00000000dfea8000 - 00000000dfed0000 (ACPI NVS)
Apr  5 08:15:26 x4 kernel: BIOS-e820: 00000000dfed0000 - 00000000dff00000 (reserved)
Apr  5 08:15:26 x4 kernel: BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
Apr  5 08:15:26 x4 kernel: BIOS-e820: 0000000100000000 - 0000000220000000 (usable)
Apr  5 08:15:26 x4 kernel: NX (Execute Disable) protection: active
Apr  5 08:15:26 x4 kernel: DMI present.
Apr  5 08:15:26 x4 kernel: DMI: System manufacturer System Product Name/M4A78T-E, BIOS 3406    08/20/2010
Apr  5 08:15:26 x4 kernel: e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
Apr  5 08:15:26 x4 kernel: e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
Apr  5 08:15:26 x4 kernel: last_pfn = 0x220000 max_arch_pfn = 0x400000000
Apr  5 08:15:26 x4 kernel: MTRR default type: uncachable
Apr  5 08:15:26 x4 kernel: MTRR fixed ranges enabled:
Apr  5 08:15:26 x4 kernel: 00000-9FFFF write-back
Apr  5 08:15:26 x4 kernel: A0000-EFFFF uncachable
Apr  5 08:15:26 x4 kernel: F0000-FFFFF write-protect
Apr  5 08:15:26 x4 kernel: MTRR variable ranges enabled:
Apr  5 08:15:26 x4 kernel: 0 base 000000000000 mask FFFF80000000 write-back
Apr  5 08:15:26 x4 kernel: 1 base 000080000000 mask FFFFC0000000 write-back
Apr  5 08:15:26 x4 kernel: 2 base 0000C0000000 mask FFFFE0000000 write-back
Apr  5 08:15:26 x4 kernel: 3 base 0000F0000000 mask FFFFF8000000 write-combining
Apr  5 08:15:26 x4 kernel: 4 disabled
Apr  5 08:15:26 x4 kernel: 5 disabled
Apr  5 08:15:26 x4 kernel: 6 disabled
Apr  5 08:15:26 x4 kernel: 7 disabled
Apr  5 08:15:26 x4 kernel: TOM2: 0000000220000000 aka 8704M
Apr  5 08:15:26 x4 kernel: x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
Apr  5 08:15:26 x4 kernel: last_pfn = 0xdfe90 max_arch_pfn = 0x400000000
Apr  5 08:15:26 x4 kernel: initial memory mapped : 0 - 20000000
Apr  5 08:15:26 x4 kernel: Base memory trampoline at [ffff88000009d000] 9d000 size 8192
Apr  5 08:15:26 x4 kernel: Using GB pages for direct mapping
Apr  5 08:15:26 x4 kernel: init_memory_mapping: 0000000000000000-00000000dfe90000
Apr  5 08:15:26 x4 kernel: 0000000000 - 00c0000000 page 1G
Apr  5 08:15:26 x4 kernel: 00c0000000 - 00dfe00000 page 2M
Apr  5 08:15:26 x4 kernel: 00dfe00000 - 00dfe90000 page 4k
Apr  5 08:15:26 x4 kernel: kernel direct mapping tables up to dfe90000 @ dfe8d000-dfe90000
Apr  5 08:15:26 x4 kernel: init_memory_mapping: 0000000100000000-0000000220000000
Apr  5 08:15:26 x4 kernel: 0100000000 - 0200000000 page 1G
Apr  5 08:15:26 x4 kernel: 0200000000 - 0220000000 page 2M
Apr  5 08:15:26 x4 kernel: kernel direct mapping tables up to 220000000 @ 21fffe000-220000000
Apr  5 08:15:26 x4 kernel: ACPI: RSDP 00000000000fb880 00024 (v02 ACPIAM)
Apr  5 08:15:26 x4 kernel: ACPI: XSDT 00000000dfe90100 0005C (v01 082010 XSDT1403 20100820 MSFT 00000097)
Apr  5 08:15:26 x4 kernel: ACPI: FACP 00000000dfe90290 000F4 (v03 082010 FACP1403 20100820 MSFT 00000097)
Apr  5 08:15:26 x4 kernel: ACPI Warning: Optional field Pm2ControlBlock has zero address or length: 0x0000000000000000/0x1 (20110316/tbfadt-560)
Apr  5 08:15:26 x4 kernel: ACPI: DSDT 00000000dfe90450 0E6FE (v01  A1152 A1152000 00000000 INTL 20060113)
Apr  5 08:15:26 x4 kernel: ACPI: FACS 00000000dfea8000 00040
Apr  5 08:15:26 x4 kernel: ACPI: APIC 00000000dfe90390 0007C (v01 082010 APIC1403 20100820 MSFT 00000097)
Apr  5 08:15:26 x4 kernel: ACPI: MCFG 00000000dfe90410 0003C (v01 082010 OEMMCFG  20100820 MSFT 00000097)
Apr  5 08:15:26 x4 kernel: ACPI: OEMB 00000000dfea8040 00072 (v01 082010 OEMB1403 20100820 MSFT 00000097)
Apr  5 08:15:26 x4 kernel: ACPI: SRAT 00000000dfe9f450 000E8 (v01 AMD    FAM_F_10 00000002 AMD  00000001)
Apr  5 08:15:26 x4 kernel: ACPI: HPET 00000000dfe9f540 00038 (v01 082010 OEMHPET  20100820 MSFT 00000097)
Apr  5 08:15:26 x4 kernel: ACPI: SSDT 00000000dfe9f580 0088C (v01 A M I  POWERNOW 00000001 AMD  00000001)
Apr  5 08:15:26 x4 kernel: ACPI: Local APIC address 0xfee00000
Apr  5 08:15:26 x4 kernel: [ffffea0000000000-ffffea00077fffff] PMD -> [ffff88020c000000-ffff8802131fffff] on node 0
Apr  5 08:15:26 x4 kernel: Zone PFN ranges:
Apr  5 08:15:26 x4 kernel: DMA      0x00000010 -> 0x00001000
Apr  5 08:15:26 x4 kernel: DMA32    0x00001000 -> 0x00100000
Apr  5 08:15:26 x4 kernel: Normal   0x00100000 -> 0x00220000
Apr  5 08:15:26 x4 kernel: Movable zone start PFN for each node
Apr  5 08:15:26 x4 kernel: early_node_map[3] active PFN ranges
Apr  5 08:15:26 x4 kernel: 0: 0x00000010 -> 0x0000009f
Apr  5 08:15:26 x4 kernel: 0: 0x00000100 -> 0x000dfe90
Apr  5 08:15:26 x4 kernel: 0: 0x00100000 -> 0x00220000
Apr  5 08:15:26 x4 kernel: On node 0 totalpages: 2096671
Apr  5 08:15:26 x4 kernel: DMA zone: 56 pages used for memmap
Apr  5 08:15:26 x4 kernel: DMA zone: 2 pages reserved
Apr  5 08:15:26 x4 kernel: DMA zone: 3925 pages, LIFO batch:0
Apr  5 08:15:26 x4 kernel: DMA32 zone: 14280 pages used for memmap
Apr  5 08:15:26 x4 kernel: DMA32 zone: 898760 pages, LIFO batch:31
Apr  5 08:15:26 x4 kernel: Normal zone: 16128 pages used for memmap
Apr  5 08:15:26 x4 kernel: Normal zone: 1163520 pages, LIFO batch:31
Apr  5 08:15:26 x4 kernel: ACPI: PM-Timer IO Port: 0x808
Apr  5 08:15:26 x4 kernel: ACPI: Local APIC address 0xfee00000
Apr  5 08:15:26 x4 kernel: ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Apr  5 08:15:26 x4 kernel: ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Apr  5 08:15:26 x4 kernel: ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
Apr  5 08:15:26 x4 kernel: ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
Apr  5 08:15:26 x4 kernel: ACPI: LAPIC (acpi_id[0x05] lapic_id[0x84] disabled)
Apr  5 08:15:26 x4 kernel: ACPI: LAPIC (acpi_id[0x06] lapic_id[0x85] disabled)
Apr  5 08:15:26 x4 kernel: ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
Apr  5 08:15:26 x4 kernel: IOAPIC[0]: apic_id 4, version 33, address 0xfec00000, GSI 0-23
Apr  5 08:15:26 x4 kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
Apr  5 08:15:26 x4 kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
Apr  5 08:15:26 x4 kernel: ACPI: IRQ0 used by override.
Apr  5 08:15:26 x4 kernel: ACPI: IRQ2 used by override.
Apr  5 08:15:26 x4 kernel: ACPI: IRQ9 used by override.
Apr  5 08:15:26 x4 kernel: Using ACPI (MADT) for SMP configuration information
Apr  5 08:15:26 x4 kernel: ACPI: HPET id: 0x8300 base: 0xfed00000
Apr  5 08:15:26 x4 kernel: SMP: Allowing 4 CPUs, 0 hotplug CPUs
Apr  5 08:15:26 x4 kernel: nr_irqs_gsi: 40
Apr  5 08:15:26 x4 kernel: Allocating PCI resources starting at dff00000 (gap: dff00000:20000000)
Apr  5 08:15:26 x4 kernel: setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
Apr  5 08:15:26 x4 kernel: PERCPU: Embedded 24 pages/cpu @ffff88021fc00000 s74560 r0 d23744 u524288
Apr  5 08:15:26 x4 kernel: pcpu-alloc: s74560 r0 d23744 u524288 alloc=1*2097152
Apr  5 08:15:26 x4 kernel: pcpu-alloc: [0] 0 1 2 3 
Apr  5 08:15:26 x4 kernel: Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2066205
Apr  5 08:15:26 x4 kernel: Kernel command line: root=PARTUUID=6d6a4009-3a90-40df-806a-e63f48189719 init=/sbin/minit rootflags=logbsize=262144 fbcon=rotate:3 drm_kms_helper.poll=0 quiet kexec_jump_back_entry=0x00000202a4814e49
Apr  5 08:15:26 x4 kernel: PID hash table entries: 4096 (order: 3, 32768 bytes)
Apr  5 08:15:26 x4 kernel: Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Apr  5 08:15:26 x4 kernel: Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
Apr  5 08:15:26 x4 kernel: Memory: 8182424k/8912896k available (5292k kernel code, 526212k absent, 204260k reserved, 2158k data, 596k init)
Apr  5 08:15:26 x4 kernel: SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
Apr  5 08:15:26 x4 kernel: Preemptable hierarchical RCU implementation.
Apr  5 08:15:26 x4 kernel: NR_IRQS:384
Apr  5 08:15:26 x4 kernel: Extended CMOS year: 2000
Apr  5 08:15:26 x4 kernel: Console: colour VGA+ 80x25
Apr  5 08:15:26 x4 kernel: console [tty0] enabled
Apr  5 08:15:26 x4 kernel: hpet clockevent registered
Apr  5 08:15:26 x4 kernel: Fast TSC calibration using PIT
Apr  5 08:15:26 x4 kernel: Detected 3210.709 MHz processor.
Apr  5 08:15:26 x4 kernel: Calibrating delay loop (skipped), value calculated using timer frequency.. 6421.41 BogoMIPS (lpj=3210709)
Apr  5 08:15:26 x4 kernel: pid_max: default: 32768 minimum: 301
Apr  5 08:15:26 x4 kernel: Mount-cache hash table entries: 256
Apr  5 08:15:26 x4 kernel: tseg: 0000000000
Apr  5 08:15:26 x4 kernel: CPU: Physical Processor ID: 0
Apr  5 08:15:26 x4 kernel: CPU: Processor Core ID: 0
Apr  5 08:15:26 x4 kernel: mce: CPU supports 6 MCE banks
Apr  5 08:15:26 x4 kernel: using C1E aware idle routine
Apr  5 08:15:26 x4 kernel: Freeing SMP alternatives: 16k freed
Apr  5 08:15:26 x4 kernel: ACPI: Core revision 20110316
Apr  5 08:15:26 x4 kernel: ftrace: allocating 18139 entries in 72 pages
Apr  5 08:15:26 x4 kernel: Setting APIC routing to flat
Apr  5 08:15:26 x4 kernel: ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
Apr  5 08:15:26 x4 kernel: CPU0: AMD Phenom(tm) II X4 955 Processor stepping 02
Apr  5 08:15:26 x4 kernel: Performance Events: AMD PMU driver.
Apr  5 08:15:26 x4 kernel: ... version:                0
Apr  5 08:15:26 x4 kernel: ... bit width:              48
Apr  5 08:15:26 x4 kernel: ... generic registers:      4
Apr  5 08:15:26 x4 kernel: ... value mask:             0000ffffffffffff
Apr  5 08:15:26 x4 kernel: ... max period:             00007fffffffffff
Apr  5 08:15:26 x4 kernel: ... fixed-purpose events:   0
Apr  5 08:15:26 x4 kernel: ... event mask:             000000000000000f
Apr  5 08:15:26 x4 kernel: System has AMD C1E enabled
Apr  5 08:15:26 x4 kernel: Switch to broadcast mode on CPU0
Apr  5 08:15:26 x4 kernel: MCE: In-kernel MCE decoding enabled.
Apr  5 08:15:26 x4 kernel: Booting Node   0, Processors  #1
Apr  5 08:15:26 x4 kernel: smpboot cpu 1: start_ip = 9d000
Apr  5 08:15:26 x4 kernel: Switch to broadcast mode on CPU1
Apr  5 08:15:26 x4 kernel: #2
Apr  5 08:15:26 x4 kernel: smpboot cpu 2: start_ip = 9d000
Apr  5 08:15:26 x4 kernel: Switch to broadcast mode on CPU2
Apr  5 08:15:26 x4 kernel: #3 Ok.
Apr  5 08:15:26 x4 kernel: smpboot cpu 3: start_ip = 9d000
Apr  5 08:15:26 x4 kernel: Switch to broadcast mode on CPU3
Apr  5 08:15:26 x4 kernel: Brought up 4 CPUs
Apr  5 08:15:26 x4 kernel: Total of 4 processors activated (25686.61 BogoMIPS).
Apr  5 08:15:26 x4 kernel: devtmpfs: initialized
Apr  5 08:15:26 x4 kernel: NET: Registered protocol family 16
Apr  5 08:15:26 x4 kernel: node 0 link 0: io port [1000, ffffff]
Apr  5 08:15:26 x4 kernel: TOM: 00000000e0000000 aka 3584M
Apr  5 08:15:26 x4 kernel: Fam 10h mmconf [e0000000, efffffff]
Apr  5 08:15:26 x4 kernel: node 0 link 0: mmio [a0000, bffff]
Apr  5 08:15:26 x4 kernel: node 0 link 0: mmio [e0000000, efffffff] ==> none
Apr  5 08:15:26 x4 kernel: node 0 link 0: mmio [f0000000, fbcfffff]
Apr  5 08:15:26 x4 kernel: node 0 link 0: mmio [fbd00000, fbefffff]
Apr  5 08:15:26 x4 kernel: node 0 link 0: mmio [fbf00000, ffefffff]
Apr  5 08:15:26 x4 kernel: TOM2: 0000000220000000 aka 8704M
Apr  5 08:15:26 x4 kernel: bus: [00, 07] on node 0 link 0
Apr  5 08:15:26 x4 kernel: bus: 00 index 0 [io  0x0000-0xffff]
Apr  5 08:15:26 x4 kernel: bus: 00 index 1 [mem 0x000a0000-0x000bffff]
Apr  5 08:15:26 x4 kernel: bus: 00 index 2 [mem 0xf0000000-0xffffffff]
Apr  5 08:15:26 x4 kernel: bus: 00 index 3 [mem 0x220000000-0xfcffffffff]
Apr  5 08:15:26 x4 kernel: Extended Config Space enabled on 1 nodes
Apr  5 08:15:26 x4 kernel: ACPI: bus type pci registered
Apr  5 08:15:26 x4 kernel: PCI: Using configuration type 1 for base access
Apr  5 08:15:26 x4 kernel: PCI: Using configuration type 1 for extended access
Apr  5 08:15:26 x4 kernel: bio: create slab <bio-0> at 0
Apr  5 08:15:26 x4 kernel: ACPI: EC: Look up EC in DSDT
Apr  5 08:15:26 x4 kernel: ACPI: Executed 3 blocks of module-level executable AML code
Apr  5 08:15:26 x4 kernel: ACPI: Interpreter enabled
Apr  5 08:15:26 x4 kernel: ACPI: (supports S0 S5)
Apr  5 08:15:26 x4 kernel: ACPI: Using IOAPIC for interrupt routing
Apr  5 08:15:26 x4 kernel: PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
Apr  5 08:15:26 x4 kernel: ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
Apr  5 08:15:26 x4 kernel: pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
Apr  5 08:15:26 x4 kernel: pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
Apr  5 08:15:26 x4 kernel: pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
Apr  5 08:15:26 x4 kernel: pci_root PNP0A03:00: host bridge window [mem 0x000d0000-0x000dffff]
Apr  5 08:15:26 x4 kernel: pci_root PNP0A03:00: host bridge window [mem 0xdff00000-0xdfffffff]
Apr  5 08:15:26 x4 kernel: pci_root PNP0A03:00: host bridge window [mem 0xf0000000-0xfebfffff]
Apr  5 08:15:26 x4 kernel: pci 0000:00:00.0: [1022:9600] type 0 class 0x000600
Apr  5 08:15:26 x4 kernel: pci 0000:00:01.0: [1022:9602] type 1 class 0x000604
Apr  5 08:15:26 x4 kernel: pci 0000:00:06.0: [1022:9606] type 1 class 0x000604
Apr  5 08:15:26 x4 kernel: pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
Apr  5 08:15:26 x4 kernel: pci 0000:00:06.0: PME# disabled
Apr  5 08:15:26 x4 kernel: pci 0000:00:11.0: [1002:4390] type 0 class 0x000106
Apr  5 08:15:26 x4 kernel: pci 0000:00:11.0: reg 10: [io  0xc000-0xc007]
Apr  5 08:15:26 x4 kernel: pci 0000:00:11.0: reg 14: [io  0xb000-0xb003]
Apr  5 08:15:26 x4 kernel: pci 0000:00:11.0: reg 18: [io  0xa000-0xa007]
Apr  5 08:15:26 x4 kernel: pci 0000:00:11.0: reg 1c: [io  0x9000-0x9003]
Apr  5 08:15:26 x4 kernel: pci 0000:00:11.0: reg 20: [io  0x8000-0x800f]
Apr  5 08:15:26 x4 kernel: pci 0000:00:11.0: reg 24: [mem 0xfbcffc00-0xfbcfffff]
Apr  5 08:15:26 x4 kernel: pci 0000:00:12.0: [1002:4397] type 0 class 0x000c03
Apr  5 08:15:26 x4 kernel: pci 0000:00:12.0: reg 10: [mem 0xfbcfd000-0xfbcfdfff]
Apr  5 08:15:26 x4 kernel: pci 0000:00:12.1: [1002:4398] type 0 class 0x000c03
Apr  5 08:15:26 x4 kernel: pci 0000:00:12.1: reg 10: [mem 0xfbcfe000-0xfbcfefff]
Apr  5 08:15:26 x4 kernel: pci 0000:00:12.2: [1002:4396] type 0 class 0x000c03
Apr  5 08:15:26 x4 kernel: pci 0000:00:12.2: reg 10: [mem 0xfbcff800-0xfbcff8ff]
Apr  5 08:15:26 x4 kernel: pci 0000:00:12.2: supports D1 D2
Apr  5 08:15:26 x4 kernel: pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
Apr  5 08:15:26 x4 kernel: pci 0000:00:12.2: PME# disabled
Apr  5 08:15:26 x4 kernel: pci 0000:00:13.0: [1002:4397] type 0 class 0x000c03
Apr  5 08:15:26 x4 kernel: pci 0000:00:13.0: reg 10: [mem 0xfbcfb000-0xfbcfbfff]
Apr  5 08:15:26 x4 kernel: pci 0000:00:13.1: [1002:4398] type 0 class 0x000c03
Apr  5 08:15:26 x4 kernel: pci 0000:00:13.1: reg 10: [mem 0xfbcfc000-0xfbcfcfff]
Apr  5 08:15:26 x4 kernel: pci 0000:00:13.2: [1002:4396] type 0 class 0x000c03
Apr  5 08:15:26 x4 kernel: pci 0000:00:13.2: reg 10: [mem 0xfbcff400-0xfbcff4ff]
Apr  5 08:15:26 x4 kernel: pci 0000:00:13.2: supports D1 D2
Apr  5 08:15:26 x4 kernel: pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
Apr  5 08:15:26 x4 kernel: pci 0000:00:13.2: PME# disabled
Apr  5 08:15:26 x4 kernel: pci 0000:00:14.0: [1002:4385] type 0 class 0x000c05
Apr  5 08:15:26 x4 kernel: pci 0000:00:14.1: [1002:439c] type 0 class 0x000101
Apr  5 08:15:26 x4 kernel: pci 0000:00:14.1: reg 10: [io  0x0000-0x0007]
Apr  5 08:15:26 x4 kernel: pci 0000:00:14.1: reg 14: [io  0x0000-0x0003]
Apr  5 08:15:26 x4 kernel: pci 0000:00:14.1: reg 18: [io  0x0000-0x0007]
Apr  5 08:15:26 x4 kernel: pci 0000:00:14.1: reg 1c: [io  0x0000-0x0003]
Apr  5 08:15:26 x4 kernel: pci 0000:00:14.1: reg 20: [io  0xff00-0xff0f]
Apr  5 08:15:26 x4 kernel: pci 0000:00:14.3: [1002:439d] type 0 class 0x000601
Apr  5 08:15:26 x4 kernel: pci 0000:00:14.4: [1002:4384] type 1 class 0x000604
Apr  5 08:15:26 x4 kernel: pci 0000:00:14.5: [1002:4399] type 0 class 0x000c03
Apr  5 08:15:26 x4 kernel: pci 0000:00:14.5: reg 10: [mem 0xfbcfa000-0xfbcfafff]
Apr  5 08:15:26 x4 kernel: pci 0000:00:18.0: [1022:1200] type 0 class 0x000600
Apr  5 08:15:26 x4 kernel: pci 0000:00:18.1: [1022:1201] type 0 class 0x000600
Apr  5 08:15:26 x4 kernel: pci 0000:00:18.2: [1022:1202] type 0 class 0x000600
Apr  5 08:15:26 x4 kernel: pci 0000:00:18.3: [1022:1203] type 0 class 0x000600
Apr  5 08:15:26 x4 kernel: pci 0000:00:18.4: [1022:1204] type 0 class 0x000600
Apr  5 08:15:26 x4 kernel: pci 0000:01:05.0: [1002:9614] type 0 class 0x000300
Apr  5 08:15:26 x4 kernel: pci 0000:01:05.0: reg 10: [mem 0xf0000000-0xf7ffffff pref]
Apr  5 08:15:26 x4 kernel: pci 0000:01:05.0: reg 14: [io  0xd000-0xd0ff]
Apr  5 08:15:26 x4 kernel: pci 0000:01:05.0: reg 18: [mem 0xfbee0000-0xfbeeffff]
Apr  5 08:15:26 x4 kernel: pci 0000:01:05.0: reg 24: [mem 0xfbd00000-0xfbdfffff]
Apr  5 08:15:26 x4 kernel: pci 0000:01:05.0: supports D1 D2
Apr  5 08:15:26 x4 kernel: pci 0000:01:05.1: [1002:960f] type 0 class 0x000403
Apr  5 08:15:26 x4 kernel: pci 0000:01:05.1: reg 10: [mem 0xfbefc000-0xfbefffff]
Apr  5 08:15:26 x4 kernel: pci 0000:01:05.1: supports D1 D2
Apr  5 08:15:26 x4 kernel: pci 0000:00:01.0: PCI bridge to [bus 01-01]
Apr  5 08:15:26 x4 kernel: pci 0000:00:01.0:   bridge window [io  0xd000-0xdfff]
Apr  5 08:15:26 x4 kernel: pci 0000:00:01.0:   bridge window [mem 0xfbd00000-0xfbefffff]
Apr  5 08:15:26 x4 kernel: pci 0000:00:01.0:   bridge window [mem 0xf0000000-0xf7ffffff 64bit pref]
Apr  5 08:15:26 x4 kernel: pci 0000:02:00.0: [1969:1026] type 0 class 0x000200
Apr  5 08:15:26 x4 kernel: pci 0000:02:00.0: reg 10: [mem 0xfbfc0000-0xfbffffff 64bit]
Apr  5 08:15:26 x4 kernel: pci 0000:02:00.0: reg 18: [io  0xec00-0xec7f]
Apr  5 08:15:26 x4 kernel: pci 0000:02:00.0: PME# supported from D3hot D3cold
Apr  5 08:15:26 x4 kernel: pci 0000:02:00.0: PME# disabled
Apr  5 08:15:26 x4 kernel: pci 0000:00:06.0: PCI bridge to [bus 02-02]
Apr  5 08:15:26 x4 kernel: pci 0000:00:06.0:   bridge window [io  0xe000-0xefff]
Apr  5 08:15:26 x4 kernel: pci 0000:00:06.0:   bridge window [mem 0xfbf00000-0xfbffffff]
Apr  5 08:15:26 x4 kernel: pci 0000:00:06.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
Apr  5 08:15:26 x4 kernel: pci 0000:00:14.4: PCI bridge to [bus 03-03] (subtractive decode)
Apr  5 08:15:26 x4 kernel: pci 0000:00:14.4:   bridge window [io  0xf000-0x0000] (disabled)
Apr  5 08:15:26 x4 kernel: pci 0000:00:14.4:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
Apr  5 08:15:26 x4 kernel: pci 0000:00:14.4:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
Apr  5 08:15:26 x4 kernel: pci 0000:00:14.4:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
Apr  5 08:15:26 x4 kernel: pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff] (subtractive decode)
Apr  5 08:15:26 x4 kernel: pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
Apr  5 08:15:26 x4 kernel: pci 0000:00:14.4:   bridge window [mem 0x000d0000-0x000dffff] (subtractive decode)
Apr  5 08:15:26 x4 kernel: pci 0000:00:14.4:   bridge window [mem 0xdff00000-0xdfffffff] (subtractive decode)
Apr  5 08:15:26 x4 kernel: pci 0000:00:14.4:   bridge window [mem 0xf0000000-0xfebfffff] (subtractive decode)
Apr  5 08:15:26 x4 kernel: pci_bus 0000:00: on NUMA node 0
Apr  5 08:15:26 x4 kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
Apr  5 08:15:26 x4 kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
Apr  5 08:15:26 x4 kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE6._PRT]
Apr  5 08:15:26 x4 kernel: ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0PC._PRT]
Apr  5 08:15:26 x4 kernel: ACPI: PCI Interrupt Link [LNKA] (IRQs 4 7 10 11 12 14 15) *0, disabled.
Apr  5 08:15:26 x4 kernel: ACPI: PCI Interrupt Link [LNKB] (IRQs 4 7 10 11 12 14 15) *0, disabled.
Apr  5 08:15:26 x4 kernel: ACPI: PCI Interrupt Link [LNKC] (IRQs 4 7 10 11 12 14 15) *0, disabled.
Apr  5 08:15:26 x4 kernel: ACPI: PCI Interrupt Link [LNKD] (IRQs 4 7 10 11 12 14 15) *0, disabled.
Apr  5 08:15:26 x4 kernel: ACPI: PCI Interrupt Link [LNKE] (IRQs 4 7 10 11 12 14 15) *0, disabled.
Apr  5 08:15:26 x4 kernel: ACPI: PCI Interrupt Link [LNKF] (IRQs 4 7 10 11 12 14 15) *0, disabled.
Apr  5 08:15:26 x4 kernel: ACPI: PCI Interrupt Link [LNKG] (IRQs 4 7 10 11 12 14 15) *0, disabled.
Apr  5 08:15:26 x4 kernel: ACPI: PCI Interrupt Link [LNKH] (IRQs 4 7 10 11 12 14 15) *0, disabled.
Apr  5 08:15:26 x4 kernel: SCSI subsystem initialized
Apr  5 08:15:26 x4 kernel: libata version 3.00 loaded.
Apr  5 08:15:26 x4 kernel: usbcore: registered new interface driver usbfs
Apr  5 08:15:26 x4 kernel: usbcore: registered new interface driver hub
Apr  5 08:15:26 x4 kernel: usbcore: registered new device driver usb
Apr  5 08:15:26 x4 kernel: Advanced Linux Sound Architecture Driver Version 1.0.24.
Apr  5 08:15:26 x4 kernel: PCI: Using ACPI for IRQ routing
Apr  5 08:15:26 x4 kernel: PCI: pci_cache_line_size set to 64 bytes
Apr  5 08:15:26 x4 kernel: reserve RAM buffer: 000000000009fc00 - 000000000009ffff 
Apr  5 08:15:26 x4 kernel: reserve RAM buffer: 00000000dfe90000 - 00000000dfffffff 
Apr  5 08:15:26 x4 kernel: hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
Apr  5 08:15:26 x4 kernel: hpet0: 4 comparators, 32-bit 14.318180 MHz counter
Apr  5 08:15:26 x4 kernel: Switching to clocksource hpet
Apr  5 08:15:26 x4 kernel: pnp: PnP ACPI init
Apr  5 08:15:26 x4 kernel: ACPI: bus type pnp registered
Apr  5 08:15:26 x4 kernel: pnp 00:00: [bus 00-ff]
Apr  5 08:15:26 x4 kernel: pnp 00:00: [io  0x0cf8-0x0cff]
Apr  5 08:15:26 x4 kernel: pnp 00:00: [io  0x0000-0x0cf7 window]
Apr  5 08:15:26 x4 kernel: pnp 00:00: [io  0x0d00-0xffff window]
Apr  5 08:15:26 x4 kernel: pnp 00:00: [mem 0x000a0000-0x000bffff window]
Apr  5 08:15:26 x4 kernel: pnp 00:00: [mem 0x000d0000-0x000dffff window]
Apr  5 08:15:26 x4 kernel: pnp 00:00: [mem 0xdff00000-0xdfffffff window]
Apr  5 08:15:26 x4 kernel: pnp 00:00: [mem 0xf0000000-0xfebfffff window]
Apr  5 08:15:26 x4 kernel: pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
Apr  5 08:15:26 x4 kernel: pnp 00:01: [mem 0x00000000-0xffffffffffffffff disabled]
Apr  5 08:15:26 x4 kernel: pnp 00:01: [mem 0x00000000-0xffffffffffffffff disabled]
Apr  5 08:15:26 x4 kernel: system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
Apr  5 08:15:26 x4 kernel: pnp 00:02: [dma 4]
Apr  5 08:15:26 x4 kernel: pnp 00:02: [io  0x0000-0x000f]
Apr  5 08:15:26 x4 kernel: pnp 00:02: [io  0x0081-0x0083]
Apr  5 08:15:26 x4 kernel: pnp 00:02: [io  0x0087]
Apr  5 08:15:26 x4 kernel: pnp 00:02: [io  0x0089-0x008b]
Apr  5 08:15:26 x4 kernel: pnp 00:02: [io  0x008f]
Apr  5 08:15:26 x4 kernel: pnp 00:02: [io  0x00c0-0x00df]
Apr  5 08:15:26 x4 kernel: pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
Apr  5 08:15:26 x4 kernel: pnp 00:03: [io  0x0070-0x0071]
Apr  5 08:15:26 x4 kernel: pnp 00:03: [irq 8]
Apr  5 08:15:26 x4 kernel: pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
Apr  5 08:15:26 x4 kernel: pnp 00:04: [io  0x0061]
Apr  5 08:15:26 x4 kernel: pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
Apr  5 08:15:26 x4 kernel: pnp 00:05: [io  0x00f0-0x00ff]
Apr  5 08:15:26 x4 kernel: pnp 00:05: [irq 13]
Apr  5 08:15:26 x4 kernel: pnp 00:05: Plug and Play ACPI device, IDs PNP0c04 (active)
Apr  5 08:15:26 x4 kernel: pnp 00:06: [mem 0xfed00000-0xfed003ff]
Apr  5 08:15:26 x4 kernel: pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
Apr  5 08:15:26 x4 kernel: pnp 00:07: [io  0x0060]
Apr  5 08:15:26 x4 kernel: pnp 00:07: [io  0x0064]
Apr  5 08:15:26 x4 kernel: pnp 00:07: [mem 0xfec00000-0xfec00fff]
Apr  5 08:15:26 x4 kernel: pnp 00:07: [mem 0xfee00000-0xfee00fff]
Apr  5 08:15:26 x4 kernel: system 00:07: [mem 0xfec00000-0xfec00fff] could not be reserved
Apr  5 08:15:26 x4 kernel: system 00:07: [mem 0xfee00000-0xfee00fff] has been reserved
Apr  5 08:15:26 x4 kernel: system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
Apr  5 08:15:26 x4 kernel: pnp 00:08: [io  0x0010-0x001f]
Apr  5 08:15:26 x4 kernel: pnp 00:08: [io  0x0022-0x003f]
Apr  5 08:15:26 x4 kernel: pnp 00:08: [io  0x0062-0x0063]
Apr  5 08:15:26 x4 kernel: pnp 00:08: [io  0x0065-0x006f]
Apr  5 08:15:26 x4 kernel: pnp 00:08: [io  0x0072-0x007f]
Apr  5 08:15:26 x4 kernel: pnp 00:08: [io  0x0080]
Apr  5 08:15:26 x4 kernel: pnp 00:08: [io  0x0084-0x0086]
Apr  5 08:15:26 x4 kernel: pnp 00:08: [io  0x0088]
Apr  5 08:15:26 x4 kernel: pnp 00:08: [io  0x008c-0x008e]
Apr  5 08:15:26 x4 kernel: pnp 00:08: [io  0x0090-0x009f]
Apr  5 08:15:26 x4 kernel: pnp 00:08: [io  0x00a2-0x00bf]
Apr  5 08:15:26 x4 kernel: pnp 00:08: [io  0x00b1]
Apr  5 08:15:26 x4 kernel: pnp 00:08: [io  0x00e0-0x00ef]
Apr  5 08:15:26 x4 kernel: pnp 00:08: [io  0x04d0-0x04d1]
Apr  5 08:15:26 x4 kernel: pnp 00:08: [io  0x040b]
Apr  5 08:15:26 x4 kernel: pnp 00:08: [io  0x04d6]
Apr  5 08:15:26 x4 kernel: pnp 00:08: [io  0x0c00-0x0c01]
Apr  5 08:15:26 x4 kernel: pnp 00:08: [io  0x0c14]
Apr  5 08:15:26 x4 kernel: pnp 00:08: [io  0x0c50-0x0c51]
Apr  5 08:15:26 x4 kernel: pnp 00:08: [io  0x0c52]
Apr  5 08:15:26 x4 kernel: pnp 00:08: [io  0x0c6c]
Apr  5 08:15:26 x4 kernel: pnp 00:08: [io  0x0c6f]
Apr  5 08:15:26 x4 kernel: pnp 00:08: [io  0x0cd0-0x0cd1]
Apr  5 08:15:26 x4 kernel: pnp 00:08: [io  0x0cd2-0x0cd3]
Apr  5 08:15:26 x4 kernel: pnp 00:08: [io  0x0cd4-0x0cd5]
Apr  5 08:15:26 x4 kernel: pnp 00:08: [io  0x0cd6-0x0cd7]
Apr  5 08:15:26 x4 kernel: pnp 00:08: [io  0x0cd8-0x0cdf]
Apr  5 08:15:26 x4 kernel: pnp 00:08: [io  0x0b00-0x0b3f]
Apr  5 08:15:26 x4 kernel: pnp 00:08: [io  0x0800-0x089f]
Apr  5 08:15:26 x4 kernel: pnp 00:08: [io  0x0000-0xffffffffffffffff disabled]
Apr  5 08:15:26 x4 kernel: pnp 00:08: [io  0x0b00-0x0b0f]
Apr  5 08:15:26 x4 kernel: pnp 00:08: [io  0x0b20-0x0b3f]
Apr  5 08:15:26 x4 kernel: pnp 00:08: [io  0x0900-0x090f]
Apr  5 08:15:26 x4 kernel: pnp 00:08: [io  0x0910-0x091f]
Apr  5 08:15:26 x4 kernel: pnp 00:08: [io  0xfe00-0xfefe]
Apr  5 08:15:26 x4 kernel: pnp 00:08: [io  0x0060]
Apr  5 08:15:26 x4 kernel: pnp 00:08: [io  0x0064]
Apr  5 08:15:26 x4 kernel: pnp 00:08: [mem 0xdff00000-0xdfffffff]
Apr  5 08:15:26 x4 kernel: pnp 00:08: [mem 0xffb80000-0xffbfffff]
Apr  5 08:15:26 x4 kernel: pnp 00:08: [mem 0xfec10000-0xfec1001f]
Apr  5 08:15:26 x4 kernel: system 00:08: [io  0x04d0-0x04d1] has been reserved
Apr  5 08:15:26 x4 kernel: system 00:08: [io  0x040b] has been reserved
Apr  5 08:15:26 x4 kernel: system 00:08: [io  0x04d6] has been reserved
Apr  5 08:15:26 x4 kernel: system 00:08: [io  0x0c00-0x0c01] has been reserved
Apr  5 08:15:26 x4 kernel: system 00:08: [io  0x0c14] has been reserved
Apr  5 08:15:26 x4 kernel: system 00:08: [io  0x0c50-0x0c51] has been reserved
Apr  5 08:15:26 x4 kernel: system 00:08: [io  0x0c52] has been reserved
Apr  5 08:15:26 x4 kernel: system 00:08: [io  0x0c6c] has been reserved
Apr  5 08:15:26 x4 kernel: system 00:08: [io  0x0c6f] has been reserved
Apr  5 08:15:26 x4 kernel: system 00:08: [io  0x0cd0-0x0cd1] has been reserved
Apr  5 08:15:26 x4 kernel: system 00:08: [io  0x0cd2-0x0cd3] has been reserved
Apr  5 08:15:26 x4 kernel: system 00:08: [io  0x0cd4-0x0cd5] has been reserved
Apr  5 08:15:26 x4 kernel: system 00:08: [io  0x0cd6-0x0cd7] has been reserved
Apr  5 08:15:26 x4 kernel: system 00:08: [io  0x0cd8-0x0cdf] has been reserved
Apr  5 08:15:26 x4 kernel: system 00:08: [io  0x0b00-0x0b3f] has been reserved
Apr  5 08:15:26 x4 kernel: system 00:08: [io  0x0800-0x089f] has been reserved
Apr  5 08:15:26 x4 kernel: system 00:08: [io  0x0b00-0x0b0f] has been reserved
Apr  5 08:15:26 x4 kernel: system 00:08: [io  0x0b20-0x0b3f] has been reserved
Apr  5 08:15:26 x4 kernel: system 00:08: [io  0x0900-0x090f] has been reserved
Apr  5 08:15:26 x4 kernel: system 00:08: [io  0x0910-0x091f] has been reserved
Apr  5 08:15:26 x4 kernel: system 00:08: [io  0xfe00-0xfefe] has been reserved
Apr  5 08:15:26 x4 kernel: system 00:08: [mem 0xdff00000-0xdfffffff] has been reserved
Apr  5 08:15:26 x4 kernel: system 00:08: [mem 0xffb80000-0xffbfffff] has been reserved
Apr  5 08:15:26 x4 kernel: system 00:08: [mem 0xfec10000-0xfec1001f] has been reserved
Apr  5 08:15:26 x4 kernel: system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
Apr  5 08:15:26 x4 kernel: pnp 00:09: [io  0x0000-0xffffffffffffffff disabled]
Apr  5 08:15:26 x4 kernel: pnp 00:09: [io  0x0230-0x023f]
Apr  5 08:15:26 x4 kernel: pnp 00:09: [io  0x0290-0x029f]
Apr  5 08:15:26 x4 kernel: pnp 00:09: [io  0x0f40-0x0f4f]
Apr  5 08:15:26 x4 kernel: pnp 00:09: [io  0x0a30-0x0a3f]
Apr  5 08:15:26 x4 kernel: system 00:09: [io  0x0230-0x023f] has been reserved
Apr  5 08:15:26 x4 kernel: system 00:09: [io  0x0290-0x029f] has been reserved
Apr  5 08:15:26 x4 kernel: system 00:09: [io  0x0f40-0x0f4f] has been reserved
Apr  5 08:15:26 x4 kernel: system 00:09: [io  0x0a30-0x0a3f] has been reserved
Apr  5 08:15:26 x4 kernel: system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
Apr  5 08:15:26 x4 kernel: pnp 00:0a: [mem 0xe0000000-0xefffffff]
Apr  5 08:15:26 x4 kernel: system 00:0a: [mem 0xe0000000-0xefffffff] has been reserved
Apr  5 08:15:26 x4 kernel: system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
Apr  5 08:15:26 x4 kernel: pnp 00:0b: [mem 0x00000000-0x0009ffff]
Apr  5 08:15:26 x4 kernel: pnp 00:0b: [mem 0x000c0000-0x000cffff]
Apr  5 08:15:26 x4 kernel: pnp 00:0b: [mem 0x000e0000-0x000fffff]
Apr  5 08:15:26 x4 kernel: pnp 00:0b: [mem 0x00100000-0xdfefffff]
Apr  5 08:15:26 x4 kernel: pnp 00:0b: [mem 0xfec00000-0xffffffff]
Apr  5 08:15:26 x4 kernel: system 00:0b: [mem 0x00000000-0x0009ffff] could not be reserved
Apr  5 08:15:26 x4 kernel: system 00:0b: [mem 0x000c0000-0x000cffff] has been reserved
Apr  5 08:15:26 x4 kernel: system 00:0b: [mem 0x000e0000-0x000fffff] could not be reserved
Apr  5 08:15:26 x4 kernel: system 00:0b: [mem 0x00100000-0xdfefffff] could not be reserved
Apr  5 08:15:26 x4 kernel: system 00:0b: [mem 0xfec00000-0xffffffff] could not be reserved
Apr  5 08:15:26 x4 kernel: system 00:0b: Plug and Play ACPI device, IDs PNP0c01 (active)
Apr  5 08:15:26 x4 kernel: pnp: PnP ACPI: found 12 devices
Apr  5 08:15:26 x4 kernel: ACPI: ACPI bus type pnp unregistered
Apr  5 08:15:26 x4 kernel: pci 0000:00:01.0: PCI bridge to [bus 01-01]
Apr  5 08:15:26 x4 kernel: pci 0000:00:01.0:   bridge window [io  0xd000-0xdfff]
Apr  5 08:15:26 x4 kernel: pci 0000:00:01.0:   bridge window [mem 0xfbd00000-0xfbefffff]
Apr  5 08:15:26 x4 kernel: pci 0000:00:01.0:   bridge window [mem 0xf0000000-0xf7ffffff 64bit pref]
Apr  5 08:15:26 x4 kernel: pci 0000:00:06.0: PCI bridge to [bus 02-02]
Apr  5 08:15:26 x4 kernel: pci 0000:00:06.0:   bridge window [io  0xe000-0xefff]
Apr  5 08:15:26 x4 kernel: pci 0000:00:06.0:   bridge window [mem 0xfbf00000-0xfbffffff]
Apr  5 08:15:26 x4 kernel: pci 0000:00:06.0:   bridge window [mem pref disabled]
Apr  5 08:15:26 x4 kernel: pci 0000:00:14.4: PCI bridge to [bus 03-03]
Apr  5 08:15:26 x4 kernel: pci 0000:00:14.4:   bridge window [io  disabled]
Apr  5 08:15:26 x4 kernel: pci 0000:00:14.4:   bridge window [mem disabled]
Apr  5 08:15:26 x4 kernel: pci 0000:00:14.4:   bridge window [mem pref disabled]
Apr  5 08:15:26 x4 kernel: pci 0000:00:06.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
Apr  5 08:15:26 x4 kernel: pci 0000:00:06.0: setting latency timer to 64
Apr  5 08:15:26 x4 kernel: pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
Apr  5 08:15:26 x4 kernel: pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
Apr  5 08:15:26 x4 kernel: pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
Apr  5 08:15:26 x4 kernel: pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff]
Apr  5 08:15:26 x4 kernel: pci_bus 0000:00: resource 8 [mem 0xdff00000-0xdfffffff]
Apr  5 08:15:26 x4 kernel: pci_bus 0000:00: resource 9 [mem 0xf0000000-0xfebfffff]
Apr  5 08:15:26 x4 kernel: pci_bus 0000:01: resource 0 [io  0xd000-0xdfff]
Apr  5 08:15:26 x4 kernel: pci_bus 0000:01: resource 1 [mem 0xfbd00000-0xfbefffff]
Apr  5 08:15:26 x4 kernel: pci_bus 0000:01: resource 2 [mem 0xf0000000-0xf7ffffff 64bit pref]
Apr  5 08:15:26 x4 kernel: pci_bus 0000:02: resource 0 [io  0xe000-0xefff]
Apr  5 08:15:26 x4 kernel: pci_bus 0000:02: resource 1 [mem 0xfbf00000-0xfbffffff]
Apr  5 08:15:26 x4 kernel: pci_bus 0000:03: resource 4 [io  0x0000-0x0cf7]
Apr  5 08:15:26 x4 kernel: pci_bus 0000:03: resource 5 [io  0x0d00-0xffff]
Apr  5 08:15:26 x4 kernel: pci_bus 0000:03: resource 6 [mem 0x000a0000-0x000bffff]
Apr  5 08:15:26 x4 kernel: pci_bus 0000:03: resource 7 [mem 0x000d0000-0x000dffff]
Apr  5 08:15:26 x4 kernel: pci_bus 0000:03: resource 8 [mem 0xdff00000-0xdfffffff]
Apr  5 08:15:26 x4 kernel: pci_bus 0000:03: resource 9 [mem 0xf0000000-0xfebfffff]
Apr  5 08:15:26 x4 kernel: NET: Registered protocol family 2
Apr  5 08:15:26 x4 kernel: IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
Apr  5 08:15:26 x4 kernel: IPv4 FIB: Using LC-trie version 0.409
Apr  5 08:15:26 x4 kernel: TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
Apr  5 08:15:26 x4 kernel: TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
Apr  5 08:15:26 x4 kernel: TCP: Hash tables configured (established 262144 bind 65536)
Apr  5 08:15:26 x4 kernel: TCP reno registered
Apr  5 08:15:26 x4 kernel: UDP hash table entries: 4096 (order: 5, 131072 bytes)
Apr  5 08:15:26 x4 kernel: UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
Apr  5 08:15:26 x4 kernel: NET: Registered protocol family 1
Apr  5 08:15:26 x4 kernel: pci 0000:00:01.0: MSI quirk detected; subordinate MSI disabled
Apr  5 08:15:26 x4 kernel: pci 0000:01:05.0: Boot video device
Apr  5 08:15:26 x4 kernel: PCI: CLS 64 bytes, default 64
Apr  5 08:15:26 x4 kernel: PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Apr  5 08:15:26 x4 kernel: Placing 64MB software IO TLB between ffff8800dbe8d000 - ffff8800dfe8d000
Apr  5 08:15:26 x4 kernel: software IO TLB at phys 0xdbe8d000 - 0xdfe8d000
Apr  5 08:15:26 x4 kernel: kvm: Nested Virtualization enabled
Apr  5 08:15:26 x4 kernel: kvm: Nested Paging enabled
Apr  5 08:15:26 x4 kernel: SGI XFS with security attributes, large block/inode numbers, no debug enabled
Apr  5 08:15:26 x4 kernel: msgmni has been set to 15981
Apr  5 08:15:26 x4 kernel: Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
Apr  5 08:15:26 x4 kernel: io scheduler noop registered
Apr  5 08:15:26 x4 kernel: io scheduler cfq registered (default)
Apr  5 08:15:26 x4 kernel: input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
Apr  5 08:15:26 x4 kernel: ACPI: Power Button [PWRB]
Apr  5 08:15:26 x4 kernel: input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
Apr  5 08:15:26 x4 kernel: ACPI: Power Button [PWRF]
Apr  5 08:15:26 x4 kernel: ACPI: acpi_idle registered with cpuidle
Apr  5 08:15:26 x4 kernel: ACPI: processor limited to max C-state 1
Apr  5 08:15:26 x4 kernel: [drm] Initialized drm 1.1.0 20060810
Apr  5 08:15:26 x4 kernel: [drm] radeon defaulting to kernel modesetting.
Apr  5 08:15:26 x4 kernel: [drm] radeon kernel modesetting enabled.
Apr  5 08:15:26 x4 kernel: radeon 0000:01:05.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
Apr  5 08:15:26 x4 kernel: radeon 0000:01:05.0: setting latency timer to 64
Apr  5 08:15:26 x4 kernel: [drm] initializing kernel modesetting (RS780 0x1002:0x9614).
Apr  5 08:15:26 x4 kernel: [drm] register mmio base: 0xFBEE0000
Apr  5 08:15:26 x4 kernel: [drm] register mmio size: 65536
Apr  5 08:15:26 x4 kernel: ATOM BIOS: 113
Apr  5 08:15:26 x4 kernel: radeon 0000:01:05.0: VRAM: 128M 0x00000000C0000000 - 0x00000000C7FFFFFF (128M used)
Apr  5 08:15:26 x4 kernel: radeon 0000:01:05.0: GTT: 512M 0x00000000A0000000 - 0x00000000BFFFFFFF
Apr  5 08:15:26 x4 kernel: [drm] Detected VRAM RAM=128M, BAR=128M
Apr  5 08:15:26 x4 kernel: [drm] RAM width 32bits DDR
Apr  5 08:15:26 x4 kernel: [TTM] Zone  kernel: Available graphics memory: 4091220 kiB.
Apr  5 08:15:26 x4 kernel: [TTM] Zone   dma32: Available graphics memory: 2097152 kiB.
Apr  5 08:15:26 x4 kernel: [TTM] Initializing pool allocator.
Apr  5 08:15:26 x4 kernel: [drm] radeon: 128M of VRAM memory ready
Apr  5 08:15:26 x4 kernel: [drm] radeon: 512M of GTT memory ready.
Apr  5 08:15:26 x4 kernel: [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
Apr  5 08:15:26 x4 kernel: [drm] Driver supports precise vblank timestamp query.
Apr  5 08:15:26 x4 kernel: [drm] radeon: irq initialized.
Apr  5 08:15:26 x4 kernel: [drm] GART: num cpu pages 131072, num gpu pages 131072
Apr  5 08:15:26 x4 kernel: [drm] Loading RS780 Microcode
Apr  5 08:15:26 x4 kernel: radeon 0000:01:05.0: WB enabled
Apr  5 08:15:26 x4 kernel: [drm] ring test succeeded in 0 usecs
Apr  5 08:15:26 x4 kernel: [drm] radeon: ib pool ready.
Apr  5 08:15:26 x4 kernel: [drm] ib test succeeded in 0 usecs
Apr  5 08:15:26 x4 kernel: [drm] Enabling audio support
Apr  5 08:15:26 x4 kernel: [drm] Radeon Display Connectors
Apr  5 08:15:26 x4 kernel: [drm] Connector 0:
Apr  5 08:15:26 x4 kernel: [drm]   VGA
Apr  5 08:15:26 x4 kernel: [drm]   DDC: 0x7e40 0x7e40 0x7e44 0x7e44 0x7e48 0x7e48 0x7e4c 0x7e4c
Apr  5 08:15:26 x4 kernel: [drm]   Encoders:
Apr  5 08:15:26 x4 kernel: [drm]     CRT1: INTERNAL_KLDSCP_DAC1
Apr  5 08:15:26 x4 kernel: [drm] Connector 1:
Apr  5 08:15:26 x4 kernel: [drm]   DVI-D
Apr  5 08:15:26 x4 kernel: [drm]   HPD3
Apr  5 08:15:26 x4 kernel: [drm]   DDC: 0x7e50 0x7e50 0x7e54 0x7e54 0x7e58 0x7e58 0x7e5c 0x7e5c
Apr  5 08:15:26 x4 kernel: [drm]   Encoders:
Apr  5 08:15:26 x4 kernel: [drm]     DFP3: INTERNAL_KLDSCP_LVTMA
Apr  5 08:15:26 x4 kernel: [drm] radeon: power management initialized
Apr  5 08:15:26 x4 kernel: [drm] fb mappable at 0xF0141000
Apr  5 08:15:26 x4 kernel: [drm] vram apper at 0xF0000000
Apr  5 08:15:26 x4 kernel: [drm] size 7299072
Apr  5 08:15:26 x4 kernel: [drm] fb depth is 24
Apr  5 08:15:26 x4 kernel: [drm]    pitch is 6912
Apr  5 08:15:26 x4 kernel: Console: switching to colour frame buffer device 131x105
Apr  5 08:15:26 x4 kernel: fb0: radeondrmfb frame buffer device
Apr  5 08:15:26 x4 kernel: drm: registered panic notifier
Apr  5 08:15:26 x4 kernel: [drm] Initialized radeon 2.9.0 20080528 for 0000:01:05.0 on minor 0
Apr  5 08:15:26 x4 kernel: loop: module loaded
Apr  5 08:15:26 x4 kernel: ahci 0000:00:11.0: version 3.0
Apr  5 08:15:26 x4 kernel: ahci 0000:00:11.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
Apr  5 08:15:26 x4 kernel: ahci 0000:00:11.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
Apr  5 08:15:26 x4 kernel: ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part ccc 
Apr  5 08:15:26 x4 kernel: scsi0 : ahci
Apr  5 08:15:26 x4 kernel: scsi1 : ahci
Apr  5 08:15:26 x4 kernel: scsi2 : ahci
Apr  5 08:15:26 x4 kernel: scsi3 : ahci
Apr  5 08:15:26 x4 kernel: ata1: SATA max UDMA/133 irq_stat 0x00400000 irq 22, PHY RDY changed
Apr  5 08:15:26 x4 kernel: ata2: SATA max UDMA/133 abar m1024@0xfbcffc00 port 0xfbcffd80 irq 22
Apr  5 08:15:26 x4 kernel: ata3: SATA max UDMA/133 abar m1024@0xfbcffc00 port 0xfbcffe00 irq 22
Apr  5 08:15:26 x4 kernel: ata4: SATA max UDMA/133 abar m1024@0xfbcffc00 port 0xfbcffe80 irq 22
Apr  5 08:15:26 x4 kernel: pata_atiixp 0000:00:14.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Apr  5 08:15:26 x4 kernel: scsi4 : pata_atiixp
Apr  5 08:15:26 x4 kernel: scsi5 : pata_atiixp
Apr  5 08:15:26 x4 kernel: ata5: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xff00 irq 14
Apr  5 08:15:26 x4 kernel: ata6: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xff08 irq 15
Apr  5 08:15:26 x4 kernel: ATL1E 0000:02:00.0: BAR 0: set to [mem 0xfbfc0000-0xfbffffff 64bit] (PCI address [0xfbfc0000-0xfbffffff])
Apr  5 08:15:26 x4 kernel: ATL1E 0000:02:00.0: BAR 2: set to [io  0xec00-0xec7f] (PCI address [0xec00-0xec7f])
Apr  5 08:15:26 x4 kernel: ATL1E 0000:02:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
Apr  5 08:15:26 x4 kernel: ATL1E 0000:02:00.0: setting latency timer to 64
Apr  5 08:15:26 x4 kernel: PPP generic driver version 2.4.2
Apr  5 08:15:26 x4 kernel: tun: Universal TUN/TAP device driver, 1.6
Apr  5 08:15:26 x4 kernel: tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
Apr  5 08:15:26 x4 kernel: ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
Apr  5 08:15:26 x4 kernel: ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
Apr  5 08:15:26 x4 kernel: ehci_hcd 0000:00:12.2: EHCI Host Controller
Apr  5 08:15:26 x4 kernel: ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 1
Apr  5 08:15:26 x4 kernel: ehci_hcd 0000:00:12.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
Apr  5 08:15:26 x4 kernel: QUIRK: Enable AMD PLL fix
Apr  5 08:15:26 x4 kernel: ehci_hcd 0000:00:12.2: applying AMD SB600/SB700 USB freeze workaround
Apr  5 08:15:26 x4 kernel: ehci_hcd 0000:00:12.2: debug port 1
Apr  5 08:15:26 x4 kernel: ehci_hcd 0000:00:12.2: irq 17, io mem 0xfbcff800
Apr  5 08:15:26 x4 kernel: ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
Apr  5 08:15:26 x4 kernel: hub 1-0:1.0: USB hub found
Apr  5 08:15:26 x4 kernel: hub 1-0:1.0: 6 ports detected
Apr  5 08:15:26 x4 kernel: ehci_hcd 0000:00:13.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
Apr  5 08:15:26 x4 kernel: ehci_hcd 0000:00:13.2: EHCI Host Controller
Apr  5 08:15:26 x4 kernel: ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 2
Apr  5 08:15:26 x4 kernel: ehci_hcd 0000:00:13.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
Apr  5 08:15:26 x4 kernel: ehci_hcd 0000:00:13.2: applying AMD SB600/SB700 USB freeze workaround
Apr  5 08:15:26 x4 kernel: ehci_hcd 0000:00:13.2: debug port 1
Apr  5 08:15:26 x4 kernel: ehci_hcd 0000:00:13.2: irq 19, io mem 0xfbcff400
Apr  5 08:15:26 x4 kernel: ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
Apr  5 08:15:26 x4 kernel: hub 2-0:1.0: USB hub found
Apr  5 08:15:26 x4 kernel: hub 2-0:1.0: 6 ports detected
Apr  5 08:15:26 x4 kernel: ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
Apr  5 08:15:26 x4 kernel: ohci_hcd 0000:00:12.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Apr  5 08:15:26 x4 kernel: ohci_hcd 0000:00:12.0: OHCI Host Controller
Apr  5 08:15:26 x4 kernel: ohci_hcd 0000:00:12.0: new USB bus registered, assigned bus number 3
Apr  5 08:15:26 x4 kernel: ohci_hcd 0000:00:12.0: irq 16, io mem 0xfbcfd000
Apr  5 08:15:26 x4 kernel: hub 3-0:1.0: USB hub found
Apr  5 08:15:26 x4 kernel: hub 3-0:1.0: 3 ports detected
Apr  5 08:15:26 x4 kernel: ohci_hcd 0000:00:12.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Apr  5 08:15:26 x4 kernel: ohci_hcd 0000:00:12.1: OHCI Host Controller
Apr  5 08:15:26 x4 kernel: ohci_hcd 0000:00:12.1: new USB bus registered, assigned bus number 4
Apr  5 08:15:26 x4 kernel: ohci_hcd 0000:00:12.1: irq 16, io mem 0xfbcfe000
Apr  5 08:15:26 x4 kernel: hub 4-0:1.0: USB hub found
Apr  5 08:15:26 x4 kernel: hub 4-0:1.0: 3 ports detected
Apr  5 08:15:26 x4 kernel: ohci_hcd 0000:00:13.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
Apr  5 08:15:26 x4 kernel: ohci_hcd 0000:00:13.0: OHCI Host Controller
Apr  5 08:15:26 x4 kernel: ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 5
Apr  5 08:15:26 x4 kernel: ohci_hcd 0000:00:13.0: irq 18, io mem 0xfbcfb000
Apr  5 08:15:26 x4 kernel: ata5.00: ATAPI: HL-DT-STDVD-RAM GH22NP20, 1.03, max UDMA/66
Apr  5 08:15:26 x4 kernel: ata5.00: configured for UDMA/66
Apr  5 08:15:26 x4 kernel: hub 5-0:1.0: USB hub found
Apr  5 08:15:26 x4 kernel: hub 5-0:1.0: 3 ports detected
Apr  5 08:15:26 x4 kernel: ohci_hcd 0000:00:13.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
Apr  5 08:15:26 x4 kernel: ohci_hcd 0000:00:13.1: OHCI Host Controller
Apr  5 08:15:26 x4 kernel: ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 6
Apr  5 08:15:26 x4 kernel: ohci_hcd 0000:00:13.1: irq 18, io mem 0xfbcfc000
Apr  5 08:15:26 x4 kernel: hub 6-0:1.0: USB hub found
Apr  5 08:15:26 x4 kernel: hub 6-0:1.0: 3 ports detected
Apr  5 08:15:26 x4 kernel: ohci_hcd 0000:00:14.5: PCI INT C -> GSI 18 (level, low) -> IRQ 18
Apr  5 08:15:26 x4 kernel: ohci_hcd 0000:00:14.5: OHCI Host Controller
Apr  5 08:15:26 x4 kernel: ohci_hcd 0000:00:14.5: new USB bus registered, assigned bus number 7
Apr  5 08:15:26 x4 kernel: ohci_hcd 0000:00:14.5: irq 18, io mem 0xfbcfa000
Apr  5 08:15:26 x4 kernel: ata4: SATA link down (SStatus 0 SControl 300)
Apr  5 08:15:26 x4 kernel: ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Apr  5 08:15:26 x4 kernel: ata2: SATA link down (SStatus 0 SControl 300)
Apr  5 08:15:26 x4 kernel: ata3.00: ATA-8: OCZ-VERTEX, 1.6, max UDMA/133
Apr  5 08:15:26 x4 kernel: ata3.00: 62533296 sectors, multi 1: LBA48 NCQ (depth 31/32), AA
Apr  5 08:15:26 x4 kernel: ata3.00: configured for UDMA/133
Apr  5 08:15:26 x4 kernel: hub 7-0:1.0: USB hub found
Apr  5 08:15:26 x4 kernel: hub 7-0:1.0: 2 ports detected
Apr  5 08:15:26 x4 kernel: Initializing USB Mass Storage driver...
Apr  5 08:15:26 x4 kernel: usbcore: registered new interface driver usb-storage
Apr  5 08:15:26 x4 kernel: USB Mass Storage support registered.
Apr  5 08:15:26 x4 kernel: usbcore: registered new interface driver usbserial
Apr  5 08:15:26 x4 kernel: USB Serial support registered for generic
Apr  5 08:15:26 x4 kernel: usb 4-1: new full speed USB device number 2 using ohci_hcd
Apr  5 08:15:26 x4 kernel: ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Apr  5 08:15:26 x4 kernel: Refined TSC clocksource calibration: 3210.826 MHz.
Apr  5 08:15:26 x4 kernel: Switching to clocksource tsc
Apr  5 08:15:26 x4 kernel: ata1.00: ATA-8: ST1500DL003-9VT16L, CC32, max UDMA/133
Apr  5 08:15:26 x4 kernel: ata1.00: 2930277168 sectors, multi 16: LBA48 NCQ (depth 31/32)
Apr  5 08:15:26 x4 kernel: ata1.00: configured for UDMA/133
Apr  5 08:15:26 x4 kernel: scsi 0:0:0:0: Direct-Access     ATA      ST1500DL003-9VT1 CC32 PQ: 0 ANSI: 5
Apr  5 08:15:26 x4 kernel: sd 0:0:0:0: Attached scsi generic sg0 type 0
Apr  5 08:15:26 x4 kernel: scsi 2:0:0:0: Direct-Access     ATA      OCZ-VERTEX       1.6  PQ: 0 ANSI: 5
Apr  5 08:15:26 x4 kernel: sd 2:0:0:0: [sdb] 62533296 512-byte logical blocks: (32.0 GB/29.8 GiB)
Apr  5 08:15:26 x4 kernel: sd 2:0:0:0: Attached scsi generic sg1 type 0
Apr  5 08:15:26 x4 kernel: sd 2:0:0:0: [sdb] Write Protect is off
Apr  5 08:15:26 x4 kernel: sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
Apr  5 08:15:26 x4 kernel: sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Apr  5 08:15:26 x4 kernel: scsi 4:0:0:0: CD-ROM            HL-DT-ST DVD-RAM GH22NP20 1.03 PQ: 0 ANSI: 5
Apr  5 08:15:26 x4 kernel: sd 0:0:0:0: [sda] 2930277168 512-byte logical blocks: (1.50 TB/1.36 TiB)
Apr  5 08:15:26 x4 kernel: sdb: sdb1 sdb2
Apr  5 08:15:26 x4 kernel: sd 2:0:0:0: [sdb] Attached SCSI disk
Apr  5 08:15:26 x4 kernel: sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
Apr  5 08:15:26 x4 kernel: cdrom: Uniform CD-ROM driver Revision: 3.20
Apr  5 08:15:26 x4 kernel: sr 4:0:0:0: Attached scsi CD-ROM sr0
Apr  5 08:15:26 x4 kernel: sr 4:0:0:0: Attached scsi generic sg2 type 5
Apr  5 08:15:26 x4 kernel: sd 0:0:0:0: [sda] Write Protect is off
Apr  5 08:15:26 x4 kernel: sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
Apr  5 08:15:26 x4 kernel: sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Apr  5 08:15:26 x4 kernel: sda: sda1 sda2
Apr  5 08:15:26 x4 kernel: sd 0:0:0:0: [sda] Attached SCSI disk
Apr  5 08:15:26 x4 kernel: usb 4-2: new full speed USB device number 3 using ohci_hcd
Apr  5 08:15:26 x4 kernel: usb 4-3: new low speed USB device number 4 using ohci_hcd
Apr  5 08:15:26 x4 kernel: usbcore: registered new interface driver usbserial_generic
Apr  5 08:15:26 x4 kernel: usbserial: USB Serial Driver core
Apr  5 08:15:26 x4 kernel: USB Serial support registered for GSM modem (1-port)
Apr  5 08:15:26 x4 kernel: usbcore: registered new interface driver option
Apr  5 08:15:26 x4 kernel: option: v0.7.2:USB Driver for GSM modems
Apr  5 08:15:26 x4 kernel: i8042: PNP: No PS/2 controller found. Probing ports directly.
Apr  5 08:15:26 x4 kernel: serio: i8042 KBD port at 0x60,0x64 irq 1
Apr  5 08:15:26 x4 kernel: serio: i8042 AUX port at 0x60,0x64 irq 12
Apr  5 08:15:26 x4 kernel: mousedev: PS/2 mouse device common for all mice
Apr  5 08:15:26 x4 kernel: rtc_cmos 00:03: RTC can wake from S4
Apr  5 08:15:26 x4 kernel: rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
Apr  5 08:15:26 x4 kernel: rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
Apr  5 08:15:26 x4 kernel: i2c /dev entries driver
Apr  5 08:15:26 x4 kernel: EDAC MC: Ver: 2.1.0 Apr  4 2011
Apr  5 08:15:26 x4 kernel: AMD64 EDAC driver v3.4.0
Apr  5 08:15:26 x4 kernel: EDAC amd64: DRAM ECC enabled.
Apr  5 08:15:26 x4 kernel: EDAC amd64: F10h detected (node 0).
Apr  5 08:15:26 x4 kernel: EDAC MC: DCT0 chip selects:
Apr  5 08:15:26 x4 kernel: EDAC amd64: MC: 0:  1024MB 1:  1024MB
Apr  5 08:15:26 x4 kernel: EDAC amd64: MC: 2:  1024MB 3:  1024MB
Apr  5 08:15:26 x4 kernel: EDAC amd64: MC: 4:     0MB 5:     0MB
Apr  5 08:15:26 x4 kernel: EDAC amd64: MC: 6:     0MB 7:     0MB
Apr  5 08:15:26 x4 kernel: EDAC MC: DCT1 chip selects:
Apr  5 08:15:26 x4 kernel: EDAC amd64: MC: 0:  1024MB 1:  1024MB
Apr  5 08:15:26 x4 kernel: EDAC amd64: MC: 2:  1024MB 3:  1024MB
Apr  5 08:15:26 x4 kernel: EDAC amd64: MC: 4:     0MB 5:     0MB
Apr  5 08:15:26 x4 kernel: EDAC amd64: MC: 6:     0MB 7:     0MB
Apr  5 08:15:26 x4 kernel: EDAC amd64: using x4 syndromes.
Apr  5 08:15:26 x4 kernel: EDAC amd64: MCT channel count: 2
Apr  5 08:15:26 x4 kernel: EDAC amd64: CS0: Unbuffered DDR3 RAM
Apr  5 08:15:26 x4 kernel: EDAC amd64: CS1: Unbuffered DDR3 RAM
Apr  5 08:15:26 x4 kernel: EDAC amd64: CS2: Unbuffered DDR3 RAM
Apr  5 08:15:26 x4 kernel: EDAC amd64: CS3: Unbuffered DDR3 RAM
Apr  5 08:15:26 x4 kernel: EDAC MC0: Giving out device to 'amd64_edac' 'F10h': DEV 0000:00:18.2
Apr  5 08:15:26 x4 kernel: EDAC PCI0: Giving out device to module 'amd64_edac' controller 'EDAC PCI controller': DEV '0000:00:18.2' (POLLED)
Apr  5 08:15:26 x4 kernel: cpuidle: using governor ladder
Apr  5 08:15:26 x4 kernel: input: C-Media USB Headphone Set   as /devices/pci0000:00/0000:00:12.1/usb4/4-1/4-1:1.3/input/input2
Apr  5 08:15:26 x4 kernel: generic-usb 0003:0D8C:000C.0001: input,hidraw0: USB HID v1.00 Device [C-Media USB Headphone Set  ] on usb-0000:00:12.1-1/input3
Apr  5 08:15:26 x4 kernel: input: Logitech USB Receiver as /devices/pci0000:00/0000:00:12.1/usb4/4-2/4-2:1.0/input/input3
Apr  5 08:15:26 x4 kernel: generic-usb 0003:046D:C52B.0002: input,hidraw1: USB HID v1.11 Keyboard [Logitech USB Receiver] on usb-0000:00:12.1-2/input0
Apr  5 08:15:26 x4 kernel: input: Logitech USB Receiver as /devices/pci0000:00/0000:00:12.1/usb4/4-2/4-2:1.1/input/input4
Apr  5 08:15:26 x4 kernel: generic-usb 0003:046D:C52B.0003: input,hiddev0,hidraw2: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:12.1-2/input1
Apr  5 08:15:26 x4 kernel: generic-usb 0003:046D:C52B.0004: hiddev0,hidraw3: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:12.1-2/input2
Apr  5 08:15:26 x4 kernel: input: HID 046a:0011 as /devices/pci0000:00/0000:00:12.1/usb4/4-3/4-3:1.0/input/input5
Apr  5 08:15:26 x4 kernel: generic-usb 0003:046A:0011.0005: input,hidraw4: USB HID v1.10 Keyboard [HID 046a:0011] on usb-0000:00:12.1-3/input0
Apr  5 08:15:26 x4 kernel: usbcore: registered new interface driver usbhid
Apr  5 08:15:26 x4 kernel: usbhid: USB HID core driver
Apr  5 08:15:26 x4 kernel: usbcore: registered new interface driver snd-usb-audio
Apr  5 08:15:26 x4 kernel: ALSA device list:
Apr  5 08:15:26 x4 kernel: #0: C-Media USB Headphone Set at usb-0000:00:12.1-1, full speed
Apr  5 08:15:26 x4 kernel: Netfilter messages via NETLINK v0.30.
Apr  5 08:15:26 x4 kernel: nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
Apr  5 08:15:26 x4 kernel: ctnetlink v0.93: registering with nfnetlink.
Apr  5 08:15:26 x4 kernel: ip_tables: (C) 2000-2006 Netfilter Core Team
Apr  5 08:15:26 x4 kernel: TCP cubic registered
Apr  5 08:15:26 x4 kernel: NET: Registered protocol family 17
Apr  5 08:15:26 x4 kernel: powernow-k8: Found 1 AMD Phenom(tm) II X4 955 Processor (4 cpu cores) (version 2.20.00)
Apr  5 08:15:26 x4 kernel: powernow-k8:    0 : pstate 0 (3200 MHz)
Apr  5 08:15:26 x4 kernel: powernow-k8:    1 : pstate 1 (2500 MHz)
Apr  5 08:15:26 x4 kernel: powernow-k8:    2 : pstate 2 (2100 MHz)
Apr  5 08:15:26 x4 kernel: powernow-k8:    3 : pstate 3 (800 MHz)
Apr  5 08:15:26 x4 kernel: rtc_cmos 00:03: setting system clock to 2011-04-05 06:15:24 UTC (1301984124)
Apr  5 08:15:26 x4 kernel: XFS (sdb2): Mounting Filesystem
Apr  5 08:15:26 x4 kernel: XFS (sdb2): Ending clean mount
Apr  5 08:15:26 x4 kernel: VFS: Mounted root (xfs filesystem) readonly on device 8:18.
Apr  5 08:15:26 x4 kernel: devtmpfs: mounted
Apr  5 08:15:26 x4 kernel: Freeing unused kernel memory: 596k freed
Apr  5 08:15:26 x4 kernel: XFS (sda1): Mounting Filesystem
Apr  5 08:15:26 x4 kernel: XFS (sda1): Ending clean mount
Apr  5 08:15:26 x4 kernel: XFS (sda2): Mounting Filesystem
Apr  5 08:15:26 x4 kernel: XFS (sda2): Ending clean mount
Apr  5 08:15:26 x4 kernel: ATL1E 0000:02:00.0: irq 40 for MSI/MSI-X
Apr  5 08:15:26 x4 kernel: ATL1E 0000:02:00.0: eth0: NIC Link is Up <100 Mbps Full Duplex>
Apr  5 08:15:26 x4 kernel: ATL1E 0000:02:00.0: eth0: NIC Link is Up <100 Mbps Full Duplex>
Apr  5 16:15:10 x4 kernel: ATL1E 0000:02:00.0: eth0: rx sequence number error (rx=53164) (expect=53510)
Apr  5 16:15:10 x4 kernel: ATL1E 0000:02:00.0: eth0: NIC Link is Up <100 Mbps Full Duplex>
Apr  5 18:10:16 x4 kernel: ------------[ cut here ]------------
Apr  5 18:10:16 x4 kernel: WARNING: at drivers/gpu/drm/ttm/ttm_page_alloc.c:758 ttm_put_pages+0x1c6/0x2c0()
Apr  5 18:10:16 x4 kernel: Hardware name: System Product Name
Apr  5 18:10:16 x4 kernel: Pid: 680, comm: kworker/u:6 Not tainted 2.6.39-rc1-00254-gd297f96 #5
Apr  5 18:10:16 x4 kernel: Call Trace:
Apr  5 18:10:16 x4 kernel: [<ffffffff810736af>] warn_slowpath_common+0x6f/0xa0
Apr  5 18:10:16 x4 kernel: [<ffffffff810737fa>] warn_slowpath_null+0x1a/0x20
Apr  5 18:10:16 x4 kernel: [<ffffffff812c7726>] ttm_put_pages+0x1c6/0x2c0
Apr  5 18:10:16 x4 kernel: [<ffffffff812bff7d>] ttm_tt_free_alloced_pages+0xbd/0x100
Apr  5 18:10:16 x4 kernel: [<ffffffff812c0a5c>] ttm_tt_swapout+0x1bc/0x2c0
Apr  5 18:10:16 x4 kernel: [<ffffffff812c2365>] ttm_bo_swapout+0x1a5/0x240
Apr  5 18:10:16 x4 kernel: [<ffffffff812b5637>] ? drm_mm_kmalloc+0x37/0xe0
Apr  5 18:10:16 x4 kernel: [<ffffffff812bf3b8>] ttm_shrink+0xd8/0x140
Apr  5 18:10:16 x4 kernel: [<ffffffff8108eb01>] ? queue_work+0x21/0x60
Apr  5 18:10:16 x4 kernel: [<ffffffff812bf420>] ? ttm_shrink+0x140/0x140
Apr  5 18:10:16 x4 kernel: [<ffffffff812bf439>] ttm_shrink_work+0x19/0x20
Apr  5 18:10:16 x4 kernel: [<ffffffff8108dade>] process_one_work+0x11e/0x4e0
Apr  5 18:10:16 x4 kernel: [<ffffffff8108e4ce>] worker_thread+0x16e/0x360
Apr  5 18:10:16 x4 kernel: [<ffffffff8108e360>] ? manage_workers.isra.28+0x260/0x260
Apr  5 18:10:16 x4 kernel: [<ffffffff810932ac>] kthread+0x8c/0xa0
Apr  5 18:10:16 x4 kernel: [<ffffffff8152a394>] kernel_thread_helper+0x4/0x10
Apr  5 18:10:16 x4 kernel: [<ffffffff81093220>] ? kthread_flush_work_fn+0x20/0x20
Apr  5 18:10:16 x4 kernel: [<ffffffff8152a390>] ? gs_change+0xb/0xb
Apr  5 18:10:16 x4 kernel: ---[ end trace cb7fc1aad109a0a7 ]---
Apr  5 18:10:16 x4 kernel: ------------[ cut here ]------------
Apr  5 18:10:16 x4 kernel: WARNING: at drivers/gpu/drm/ttm/ttm_page_alloc.c:758 ttm_put_pages+0x1c6/0x2c0()
Apr  5 18:10:16 x4 kernel: Hardware name: System Product Name
Apr  5 18:10:16 x4 kernel: Pid: 680, comm: kworker/u:6 Tainted: G        W   2.6.39-rc1-00254-gd297f96 #5
Apr  5 18:10:16 x4 kernel: Call Trace:
Apr  5 18:10:16 x4 kernel: [<ffffffff810736af>] warn_slowpath_common+0x6f/0xa0
Apr  5 18:10:16 x4 kernel: [<ffffffff810737fa>] warn_slowpath_null+0x1a/0x20
Apr  5 18:10:16 x4 kernel: [<ffffffff812c7726>] ttm_put_pages+0x1c6/0x2c0
Apr  5 18:10:16 x4 kernel: [<ffffffff812bff7d>] ttm_tt_free_alloced_pages+0xbd/0x100
Apr  5 18:10:16 x4 kernel: [<ffffffff812c0a5c>] ttm_tt_swapout+0x1bc/0x2c0
Apr  5 18:10:16 x4 kernel: [<ffffffff812c2365>] ttm_bo_swapout+0x1a5/0x240
Apr  5 18:10:16 x4 kernel: [<ffffffff812b5637>] ? drm_mm_kmalloc+0x37/0xe0
Apr  5 18:10:16 x4 kernel: [<ffffffff812bf3b8>] ttm_shrink+0xd8/0x140
Apr  5 18:10:16 x4 kernel: [<ffffffff8108eb01>] ? queue_work+0x21/0x60
Apr  5 18:10:16 x4 kernel: [<ffffffff812bf420>] ? ttm_shrink+0x140/0x140
Apr  5 18:10:16 x4 kernel: [<ffffffff812bf439>] ttm_shrink_work+0x19/0x20
Apr  5 18:10:16 x4 kernel: [<ffffffff8108dade>] process_one_work+0x11e/0x4e0
Apr  5 18:10:16 x4 kernel: [<ffffffff8108e4ce>] worker_thread+0x16e/0x360
Apr  5 18:10:16 x4 kernel: [<ffffffff8108e360>] ? manage_workers.isra.28+0x260/0x260
Apr  5 18:10:16 x4 kernel: [<ffffffff810932ac>] kthread+0x8c/0xa0
Apr  5 18:10:16 x4 kernel: [<ffffffff8152a394>] kernel_thread_helper+0x4/0x10
Apr  5 18:10:16 x4 kernel: [<ffffffff81093220>] ? kthread_flush_work_fn+0x20/0x20
Apr  5 18:10:16 x4 kernel: [<ffffffff8152a390>] ? gs_change+0xb/0xb
Apr  5 18:10:16 x4 kernel: ---[ end trace cb7fc1aad109a0a8 ]---
Apr  5 18:10:16 x4 kernel: ------------[ cut here ]------------
Apr  5 18:10:16 x4 kernel: WARNING: at drivers/gpu/drm/ttm/ttm_page_alloc.c:758 ttm_put_pages+0x1c6/0x2c0()
Apr  5 18:10:16 x4 kernel: Hardware name: System Product Name
Apr  5 18:10:16 x4 kernel: Pid: 680, comm: kworker/u:6 Tainted: G        W   2.6.39-rc1-00254-gd297f96 #5
Apr  5 18:10:16 x4 kernel: Call Trace:
Apr  5 18:10:16 x4 kernel: [<ffffffff810736af>] warn_slowpath_common+0x6f/0xa0
Apr  5 18:10:16 x4 kernel: [<ffffffff810737fa>] warn_slowpath_null+0x1a/0x20
Apr  5 18:10:16 x4 kernel: [<ffffffff812c7726>] ttm_put_pages+0x1c6/0x2c0
Apr  5 18:10:16 x4 kernel: [<ffffffff812bff7d>] ttm_tt_free_alloced_pages+0xbd/0x100
Apr  5 18:10:16 x4 kernel: [<ffffffff812c0a5c>] ttm_tt_swapout+0x1bc/0x2c0
Apr  5 18:10:16 x4 kernel: [<ffffffff812c2365>] ttm_bo_swapout+0x1a5/0x240
Apr  5 18:10:16 x4 kernel: [<ffffffff812b5637>] ? drm_mm_kmalloc+0x37/0xe0
Apr  5 18:10:16 x4 kernel: [<ffffffff812bf3b8>] ttm_shrink+0xd8/0x140
Apr  5 18:10:16 x4 kernel: [<ffffffff8108eb01>] ? queue_work+0x21/0x60
Apr  5 18:10:16 x4 kernel: [<ffffffff812bf420>] ? ttm_shrink+0x140/0x140
Apr  5 18:10:16 x4 kernel: [<ffffffff812bf439>] ttm_shrink_work+0x19/0x20
Apr  5 18:10:16 x4 kernel: [<ffffffff8108dade>] process_one_work+0x11e/0x4e0
Apr  5 18:10:16 x4 kernel: [<ffffffff8108e4ce>] worker_thread+0x16e/0x360
Apr  5 18:10:16 x4 kernel: [<ffffffff8108e360>] ? manage_workers.isra.28+0x260/0x260
Apr  5 18:10:16 x4 kernel: [<ffffffff810932ac>] kthread+0x8c/0xa0
Apr  5 18:10:16 x4 kernel: [<ffffffff8152a394>] kernel_thread_helper+0x4/0x10
Apr  5 18:10:16 x4 kernel: [<ffffffff81093220>] ? kthread_flush_work_fn+0x20/0x20
Apr  5 18:10:16 x4 kernel: [<ffffffff8152a390>] ? gs_change+0xb/0xb
Apr  5 18:10:16 x4 kernel: ---[ end trace cb7fc1aad109a0a9 ]---
Apr  5 18:10:16 x4 kernel: ------------[ cut here ]------------

--J/dobhs11T7y2rNN--
