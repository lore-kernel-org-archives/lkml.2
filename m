Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769Ab0F3HpY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 03:45:24 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60049 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751569Ab0F3HpQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 03:45:16 -0400
Date: Wed, 30 Jun 2010 09:44:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org, hch@lst.de,
       tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/irq] x86: Always use irq stacks
Message-ID: <20100630074434.GA25509@elte.hu>
References: <20100628121554.GA6605@lst.de>
 <tip-7974891db234467eaf1fec613ec0129cb4ac2332@git.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="X1bOJ3K7DJ5YkBrT"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <tip-7974891db234467eaf1fec613ec0129cb4ac2332@git.kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 3.0
X-ELTE-SpamLevel: sss
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=3.0 required=5.9 tests=BAYES_50,FR_ALMOST_VIAG2 autolearn=no SpamAssassin version=3.2.5
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5000]
	2.0 FR_ALMOST_VIAG2        RAW: Almost looks like viagra.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


* tip-bot for Christoph Hellwig <hch@lst.de> wrote:

> Commit-ID:  7974891db234467eaf1fec613ec0129cb4ac2332
> Gitweb:     http://git.kernel.org/tip/7974891db234467eaf1fec613ec0129cb4ac2332
> Author:     Christoph Hellwig <hch@lst.de>
> AuthorDate: Mon, 28 Jun 2010 14:15:54 +0200
> Committer:  Thomas Gleixner <tglx@linutronix.de>
> CommitDate: Tue, 29 Jun 2010 12:12:59 +0200
> 
> x86: Always use irq stacks

This commit is causing the following bootup crash in -tip testing:

async_continuing @ 1 after 0 usec
EXT3-fs (sda1): recovery required on readonly filesystem
EXT3-fs (sda1): write access will be enabled during recovery
EXT3-fs: barriers not enabled
BUG: unable to handle kernel NULL pointer dereference at 0000039c
IP: [<c102d4a6>] print_context_stack+0x86/0x130
*pde = 00000000 
Oops: 0000 [#1] 
last sysfs file: 

Pid: 0, comm: swapper Not tainted 2.6.35-rc3-tip-01298-g53cd4ef-dirty #13969 A8N-E/System Product Name
EIP: 0060:[<c102d4a6>] EFLAGS: 00010002 CPU: 0
EIP is at print_context_stack+0x86/0x130
EAX: 00000000 EBX: c229cd80 ECX: 00000001 EDX: c229c000
ESI: 00000000 EDI: c1e74d9c EBP: c229cd4c ESP: c229cd28
 DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
Process swapper (pid: 0, ti=c229c000 task=c22a1180 task.ti=c2296000)
Stack:
 c10349df c229dffc c229cd94 ffffe000 c229c000 c229cd94 c229cd68 c1e74d9c
<0> c229c000 c229cd7c c102c0ff c1e74d9c f72aa150 00000000 c229cd6c c229cd6c
<0> c2cd6fa0 00000000 f72aa150 f72aa120 f72aa174 c229cd94 c10349df c229cd7c
Call Trace:
 [<c10349df>] ? save_stack_trace+0x2f/0x50
BUG: unable to handle kernel NULL pointer dereference at 0000039c
IP: [<c102d4a6>] print_context_stack+0x86/0x130
*pde = 00000000 
Oops: 0000 [#2] 

Reverting 7974891db2 and dcfa72628 makes the crash go away.

Full crashlog and config attached.

	Ingo

--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: attachment; filename="crash.log"
Content-Transfer-Encoding: 8bit

Linux version 2.6.35-rc3-tip-01298-g53cd4ef-dirty (mingo@sirius) (gcc version 4.4.4 20100514 (Red Hat 4.4.4-3) (GCC) ) #13969 Wed Jun 30 02:08:25 CEST 2010
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003fff0000 (usable)
 BIOS-e820: 000000003fff0000 - 000000003fff3000 (ACPI NVS)
 BIOS-e820: 000000003fff3000 - 0000000040000000 (ACPI data)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
bootconsole [earlyser0] enabled
debug: ignoring loglevel setting.
Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
DMI 2.3 present.
Phoenix BIOS detected: BIOS may corrupt low RAM, working around it.
e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
last_pfn = 0x3fff0 max_arch_pfn = 0x100000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-C7FFF write-protect
  C8000-FFFFF uncachable
MTRR variable ranges enabled:
  0 base 0000000000 mask FFC0000000 write-back
  1 disabled
  2 disabled
  3 disabled
  4 disabled
  5 disabled
  6 disabled
  7 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
initial memory mapped : 0 - 02800000
Scan SMP from c0000000 for 1024 bytes.
Scan SMP from c009fc00 for 1024 bytes.
Scan SMP from c00f0000 for 65536 bytes.
found SMP MP-table at [c00f5680] f5680
  mpc: f1400-f152c
init_memory_mapping: 0000000000000000-00000000377fe000
 0000000000 - 0000400000 page 4k
 0000400000 - 0037400000 page 2M
 0037400000 - 00377fe000 page 4k
kernel direct mapping tables up to 377fe000 @ 10000-15000
135MB HIGHMEM available.
887MB LOWMEM available.
  mapped low ram: 0 - 377fe000
  low ram: 0 - 377fe000
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  Normal   0x00001000 -> 0x000377fe
  HighMem  0x000377fe -> 0x0003fff0
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000010 -> 0x0000009f
    0: 0x00000100 -> 0x0003fff0
On node 0 totalpages: 262015
free_area_init_node: node 0, pgdat c235e320, node_mem_map c25f5200
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3951 pages, LIFO batch:0
  Normal zone: 1744 pages used for memmap
  Normal zone: 221486 pages, LIFO batch:31
  HighMem zone: 272 pages used for memmap
  HighMem zone: 34530 pages, LIFO batch:7
Using APIC driver default
SFI: Simple Firmware Interface v0.81 http://simplefirmware.org
Intel MultiProcessor Specification v1.4
    Virtual Wire compatibility mode.
  mpc: f1400-f152c
MPTABLE: OEM ID: OEM00000
MPTABLE: Product ID: PROD00000000
MPTABLE: APIC at: 0xFEE00000
Processor #0 (Bootup-CPU)
Processor #1
ACPI: NR_CPUS/possible_cpus limit of 1 reached.  Processor 1/0x1 ignored.
Bus #0 is PCI   
Bus #1 is PCI   
Bus #2 is PCI   
Bus #3 is PCI   
Bus #4 is PCI   
Bus #5 is PCI   
Bus #6 is ISA   
I/O APIC #2 Version 17 at 0xFEC00000.
IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
Int: type 0, pol 3, trig 3, bus 00, IRQ 28, APIC ID 2, APIC INT 0b
Int: type 0, pol 3, trig 3, bus 00, IRQ 10, APIC ID 2, APIC INT 03
Int: type 0, pol 3, trig 3, bus 01, IRQ 00, APIC ID 2, APIC INT 05
Int: type 0, pol 3, trig 3, bus 05, IRQ 1c, APIC ID 2, APIC INT 0b
Int: type 3, pol 0, trig 0, bus 06, IRQ 00, APIC ID 2, APIC INT 00
Int: type 0, pol 0, trig 0, bus 06, IRQ 01, APIC ID 2, APIC INT 01
Int: type 0, pol 0, trig 0, bus 06, IRQ 00, APIC ID 2, APIC INT 02
Int: type 0, pol 0, trig 0, bus 06, IRQ 04, APIC ID 2, APIC INT 04
Int: type 0, pol 0, trig 0, bus 06, IRQ 06, APIC ID 2, APIC INT 06
Int: type 0, pol 0, trig 0, bus 06, IRQ 07, APIC ID 2, APIC INT 07
Int: type 0, pol 1, trig 1, bus 06, IRQ 08, APIC ID 2, APIC INT 08
Int: type 0, pol 0, trig 0, bus 06, IRQ 09, APIC ID 2, APIC INT 09
Int: type 0, pol 0, trig 0, bus 06, IRQ 0a, APIC ID 2, APIC INT 0a
Int: type 0, pol 0, trig 0, bus 06, IRQ 0c, APIC ID 2, APIC INT 0c
Int: type 0, pol 0, trig 0, bus 06, IRQ 0d, APIC ID 2, APIC INT 0d
Int: type 0, pol 0, trig 0, bus 06, IRQ 0e, APIC ID 2, APIC INT 0e
Int: type 0, pol 0, trig 0, bus 06, IRQ 0f, APIC ID 2, APIC INT 0f
Lint: type 3, pol 0, trig 0, bus 00, IRQ 00, APIC ID ff, APIC LINT 00
Lint: type 1, pol 0, trig 0, bus 00, IRQ 00, APIC ID ff, APIC LINT 01
Processors: 1
mapped APIC to ffffa000 (fee00000)
mapped IOAPIC to ffff9000 (fec00000)
nr_irqs_gsi: 40
Allocating PCI resources starting at 40000000 (gap: 40000000:a0000000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 259967
Kernel command line: root=/dev/sda1 earlyprintk=ttyS0,115200 console=ttyS0,115200 debug initcall_debug enforcing=0 apic=verbose ignore_loglevel sysrq_always_enabled selinux=0 nmi_watchdog=0 3 panic=1 3
sysrq: sysrq always enabled.
early_res array is doubled to 64 at [11000 - 117ff]
PID hash table entries: 4096 (order: 2, 16384 bytes)
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
Subtract (32 early reservations)
  #1 [0001000000 - 00025e80e0]   TEXT DATA BSS
  #2 [00025e9000 - 00025f3149]             BRK
  #3 [00000f5690 - 0000100000]   BIOS reserved
  #4 [00000f5680 - 00000f5690]    MP-table mpf
  #5 [000009f800 - 00000f1400]   BIOS reserved
  #6 [00000f152c - 00000f5680]   BIOS reserved
  #7 [00000f1400 - 00000f152c]    MP-table mpc
  #8 [0000010000 - 0000011000]         PGTABLE
  #9 [00025f4000 - 00025f5000]         BOOTMEM
  #10 [00025f5000 - 0002df5000]         BOOTMEM
  #11 [00025e80e0 - 00025e80e4]         BOOTMEM
  #12 [00025e80f0 - 00025e8170]         BOOTMEM
  #13 [00025e8170 - 00025e81c4]         BOOTMEM
  #14 [0002df5000 - 0002df7000]         BOOTMEM
  #15 [00025e81d0 - 00025e81e0]         BOOTMEM
  #16 [00025e81e0 - 00025e89e0]         BOOTMEM
  #17 [00025e89e0 - 00025e8a07]         BOOTMEM
  #18 [00025e8a10 - 00025e8b0c]         BOOTMEM
  #19 [00025e8b10 - 00025e8b50]         BOOTMEM
  #20 [00025e8b50 - 00025e8b90]         BOOTMEM
  #21 [00025e8b90 - 00025e8bd0]         BOOTMEM
  #22 [00025e8bd0 - 00025e8c10]         BOOTMEM
  #23 [00025e8c10 - 00025e8c50]         BOOTMEM
  #24 [00025e8c50 - 00025e8c90]         BOOTMEM
  #25 [00025e8c90 - 00025e8cd0]         BOOTMEM
  #26 [00025e8cd0 - 00025e8d10]         BOOTMEM
  #27 [00025e8d10 - 00025e8dc5]         BOOTMEM
  #28 [00025e8dd0 - 00025e8e85]         BOOTMEM
  #29 [0002df7000 - 0002dfb000]         BOOTMEM
  #30 [0002dfb000 - 0002e7b000]         BOOTMEM
  #31 [0002e7b000 - 0002ebb000]         BOOTMEM
Initializing HighMem for node 0 (000377fe:0003fff0)
Memory: 1016588k/1048512k available (14779k kernel code, 31472k reserved, 5280k data, 788k init, 139208k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffa2000 - 0xfffff000   ( 372 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
    lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
      .init : 0xc2397000 - 0xc245c000   ( 788 kB)
      .data : 0xc1e6eed7 - 0xc2396f60   (5280 kB)
      .text : 0xc1000000 - 0xc1e6eed7   (14779 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
Hierarchical RCU implementation.
	Hierarchical RCU autobalancing is disabled.
	Verbose stalled-CPUs detection is disabled.
NR_IRQS:288
CPU 0 irqstacks, hard=c2299000 soft=c229b000
spurious 8259A interrupt: IRQ7.
Console: colour VGA+ 80x25
console [ttyS0] enabled, bootconsole disabled
console [ttyS0] enabled, bootconsole disabled
Fast TSC calibration using PIT
Detected 2010.493 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 4020.98 BogoMIPS (lpj=8041972)
pid_max: default: 32768 minimum: 301
Security Framework initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
Mount-cache hash table entries: 512
Initializing cgroup subsys debug
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
Initializing cgroup subsys blkio
mce: CPU supports 5 MCE banks
Performance Events: AMD PMU driver.
... version:                0
... bit width:              48
... generic registers:      4
... value mask:             0000ffffffffffff
... max period:             00007fffffffffff
... fixed-purpose events:   0
... event mask:             000000000000000f
CPU: AMD Athlon(tm) 64 X2 Dual Core Processor 3800+ stepping 02
ftrace: converting mcount calls to 0f 1f 44 00 00
ftrace: allocating 47062 entries in 93 pages
calling  spawn_ksoftirqd+0x0/0x30 @ 1
initcall spawn_ksoftirqd+0x0/0x30 returned 0 after 0 usecs
calling  relay_init+0x0/0x7 @ 1
initcall relay_init+0x0/0x7 returned 0 after 0 usecs
calling  tracer_alloc_buffers+0x0/0x163 @ 1
initcall tracer_alloc_buffers+0x0/0x163 returned 0 after 0 usecs
calling  init_trace_printk+0x0/0x7 @ 1
initcall init_trace_printk+0x0/0x7 returned 0 after 0 usecs
calling  trace_workqueue_early_init+0x0/0xba @ 1
initcall trace_workqueue_early_init+0x0/0xba returned 0 after 0 usecs
calling  mce_amd_init+0x0/0x28 @ 1
initcall mce_amd_init+0x0/0x28 returned 0 after 0 usecs
Enabling APIC mode:  Flat.  Using 1 I/O APICs
enabled ExtINT on CPU#0
ExtINT not setup in hardware but reported by MP table
ENABLING IO-APIC IRQs
init IO_APIC IRQs
 2-0 (apicid-pin) not connected
IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-3 -> 0x29 -> IRQ 27 Mode:1 Active:1)
IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-5 -> 0x41 -> IRQ 29 Mode:1 Active:1)
IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-11 -> 0x49 -> IRQ 35 Mode:1 Active:1)
IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0)
IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0)
 2-16 2-17 2-18 2-19 2-20 2-21 2-22 2-23 (apicid-pin) not connected
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
..MP-BIOS bug: 8254 timer not connected to IO-APIC
...trying to set up timer (IRQ0) through the 8259A ...
..... (found apic 0 pin 0) ...
....... works.
Using local APIC timer interrupts.
calibrating APIC timer ...
... lapic delta = 1256509
..... delta 1256509
..... mult: 53963277
..... calibration result: 804165
..... CPU clock speed is 2010.1660 MHz.
..... host bus clock speed is 201.0165 MHz.
... verify APIC timer
... jiffies delta = 25
... jiffies result ok
devtmpfs: initialized
calling  init_mmap_min_addr+0x0/0x24 @ 1
initcall init_mmap_min_addr+0x0/0x24 returned 0 after 0 usecs
calling  init_cpufreq_transition_notifier_list+0x0/0x18 @ 1
initcall init_cpufreq_transition_notifier_list+0x0/0x18 returned 0 after 0 usecs
calling  net_ns_init+0x0/0xf2 @ 1
initcall net_ns_init+0x0/0xf2 returned 0 after 0 usecs
calling  cpufreq_tsc+0x0/0x25 @ 1
initcall cpufreq_tsc+0x0/0x25 returned 0 after 0 usecs
calling  pci_reboot_init+0x0/0x11 @ 1
initcall pci_reboot_init+0x0/0x11 returned 0 after 0 usecs
calling  reboot_init+0x0/0x11 @ 1
initcall reboot_init+0x0/0x11 returned 0 after 0 usecs
calling  sysctl_init+0x0/0x28 @ 1
initcall sysctl_init+0x0/0x28 returned 0 after 0 usecs
calling  ksysfs_init+0x0/0x74 @ 1
initcall ksysfs_init+0x0/0x74 returned 0 after 0 usecs
calling  async_init+0x0/0x5c @ 1
initcall async_init+0x0/0x5c returned 0 after 0 usecs
calling  init_jiffies_clocksource+0x0/0xf @ 1
initcall init_jiffies_clocksource+0x0/0xf returned 0 after 0 usecs
calling  init_ftrace_syscalls+0x0/0x89 @ 1
initcall init_ftrace_syscalls+0x0/0x89 returned 0 after 0 usecs
calling  init_hw_breakpoint+0x0/0x42 @ 1
initcall init_hw_breakpoint+0x0/0x42 returned 0 after 0 usecs
calling  init_zero_pfn+0x0/0x14 @ 1
initcall init_zero_pfn+0x0/0x14 returned 0 after 0 usecs
calling  filelock_init+0x0/0x2f @ 1
initcall filelock_init+0x0/0x2f returned 0 after 0 usecs
calling  init_aout_binfmt+0x0/0x11 @ 1
initcall init_aout_binfmt+0x0/0x11 returned 0 after 0 usecs
calling  init_misc_binfmt+0x0/0x35 @ 1
initcall init_misc_binfmt+0x0/0x35 returned 0 after 0 usecs
calling  init_script_binfmt+0x0/0x11 @ 1
initcall init_script_binfmt+0x0/0x11 returned 0 after 0 usecs
calling  init_elf_binfmt+0x0/0x11 @ 1
initcall init_elf_binfmt+0x0/0x11 returned 0 after 0 usecs
calling  debugfs_init+0x0/0x4a @ 1
initcall debugfs_init+0x0/0x4a returned 0 after 0 usecs
calling  securityfs_init+0x0/0x41 @ 1
initcall securityfs_init+0x0/0x41 returned 0 after 0 usecs
calling  random32_init+0x0/0x7f @ 1
initcall random32_init+0x0/0x7f returned 0 after 0 usecs
calling  sfi_sysfs_init+0x0/0xbc @ 1
initcall sfi_sysfs_init+0x0/0xbc returned 0 after 0 usecs
calling  virtio_init+0x0/0x30 @ 1
initcall virtio_init+0x0/0x30 returned 0 after 0 usecs
calling  cpufreq_core_init+0x0/0x41 @ 1
initcall cpufreq_core_init+0x0/0x41 returned 0 after 0 usecs
calling  sock_init+0x0/0x59 @ 1
initcall sock_init+0x0/0x59 returned 0 after 0 usecs
calling  net_inuse_init+0x0/0x24 @ 1
initcall net_inuse_init+0x0/0x24 returned 0 after 0 usecs
calling  netpoll_init+0x0/0x25 @ 1
initcall netpoll_init+0x0/0x25 returned 0 after 0 usecs
calling  netlink_proto_init+0x0/0x173 @ 1
NET: Registered protocol family 16
initcall netlink_proto_init+0x0/0x173 returned 0 after 0 usecs
calling  bdi_class_init+0x0/0x40 @ 1
initcall bdi_class_init+0x0/0x40 returned 0 after 0 usecs
calling  kobject_uevent_init+0x0/0x1e @ 1
initcall kobject_uevent_init+0x0/0x1e returned 0 after 0 usecs
calling  gpiolib_sysfs_init+0x0/0x86 @ 1
initcall gpiolib_sysfs_init+0x0/0x86 returned 0 after 0 usecs
calling  pcibus_class_init+0x0/0x14 @ 1
initcall pcibus_class_init+0x0/0x14 returned 0 after 0 usecs
calling  pci_driver_init+0x0/0xf @ 1
initcall pci_driver_init+0x0/0xf returned 0 after 0 usecs
calling  backlight_class_init+0x0/0x53 @ 1
initcall backlight_class_init+0x0/0x53 returned 0 after 0 usecs
calling  video_output_class_init+0x0/0x14 @ 1
initcall video_output_class_init+0x0/0x14 returned 0 after 0 usecs
calling  tty_class_init+0x0/0x2f @ 1
initcall tty_class_init+0x0/0x2f returned 0 after 0 usecs
calling  vtconsole_class_init+0x0/0xc2 @ 1
initcall vtconsole_class_init+0x0/0xc2 returned 0 after 0 usecs
calling  spi_init+0x0/0x98 @ 1
initcall spi_init+0x0/0x98 returned 0 after 0 usecs
calling  i2c_init+0x0/0x57 @ 1
i2c-core: driver [dummy] registered
initcall i2c_init+0x0/0x57 returned 0 after 3906 usecs
calling  eisa_init+0x0/0x29 @ 1
EISA bus registered
initcall eisa_init+0x0/0x29 returned 0 after 0 usecs
calling  amd_postcore_init+0x0/0x39 @ 1
node 0 link 0: io port [1000, fffff]
TOM: 0000000040000000 aka 1024M
node 0 link 0: mmio [e0000000, efffffff]
node 0 link 0: mmio [feb00000, fec0ffff]
node 0 link 0: mmio [a0000, bffff]
node 0 link 0: mmio [40000000, fed3ffff]
bus: [00, ff] on node 0 link 0
bus: 00 index 0 [io  0x0000-0xffff]
bus: 00 index 1 [mem 0x40000000-0xffffffff]
bus: 00 index 2 [mem 0xfeb00000-0xfec0ffff]
bus: 00 index 3 [mem 0x000a0000-0x000bffff]
initcall amd_postcore_init+0x0/0x39 returned 0 after 39062 usecs
calling  arch_kdebugfs_init+0x0/0x1e @ 1
initcall arch_kdebugfs_init+0x0/0x1e returned 0 after 0 usecs
calling  init_pit_clocksource+0x0/0x8b @ 1
initcall init_pit_clocksource+0x0/0x8b returned 0 after 0 usecs
calling  mtrr_if_init+0x0/0x4d @ 1
initcall mtrr_if_init+0x0/0x4d returned 0 after 0 usecs
calling  dmi_id_init+0x0/0x2bd @ 1
initcall dmi_id_init+0x0/0x2bd returned 0 after 0 usecs
calling  dma_bus_init+0x0/0x32 @ 1
initcall dma_bus_init+0x0/0x32 returned 0 after 0 usecs
calling  dma_channel_table_init+0x0/0xdf @ 1
initcall dma_channel_table_init+0x0/0xdf returned 0 after 0 usecs
calling  dca_init+0x0/0x21 @ 1
dca service started, version 1.12.1
initcall dca_init+0x0/0x21 returned 0 after 3906 usecs
calling  pci_arch_init+0x0/0x65 @ 1
PCI: PCI BIOS revision 3.00 entry at 0xf21d0, last bus=5
PCI: Using configuration type 1 for base access
initcall pci_arch_init+0x0/0x65 returned 0 after 11718 usecs
calling  topology_init+0x0/0x13 @ 1
initcall topology_init+0x0/0x13 returned 0 after 0 usecs
calling  mtrr_init_finialize+0x0/0x35 @ 1
initcall mtrr_init_finialize+0x0/0x35 returned 0 after 0 usecs
calling  mca_init+0x0/0x28c @ 1
initcall mca_init+0x0/0x28c returned -19 after 0 usecs
calling  param_sysfs_init+0x0/0x347 @ 1
initcall param_sysfs_init+0x0/0x347 returned 0 after 39062 usecs
calling  pm_sysrq_init+0x0/0x20 @ 1
initcall pm_sysrq_init+0x0/0x20 returned 0 after 0 usecs
calling  audit_watch_init+0x0/0x1b @ 1
audit: cannot initialize inotify handle
initcall audit_watch_init+0x0/0x1b returned 0 after 3906 usecs
calling  init_slow_work+0x0/0x67 @ 1
initcall init_slow_work+0x0/0x67 returned 0 after 0 usecs
calling  default_bdi_init+0x0/0xac @ 1
initcall default_bdi_init+0x0/0xac returned 0 after 0 usecs
calling  init_bio+0x0/0xe7 @ 1
bio: create slab <bio-0> at 0
initcall init_bio+0x0/0xe7 returned 0 after 3906 usecs
calling  fsnotify_init+0x0/0xf @ 1
initcall fsnotify_init+0x0/0xf returned 0 after 0 usecs
calling  fsnotify_notification_init+0x0/0xe6 @ 1
initcall fsnotify_notification_init+0x0/0xe6 returned 0 after 0 usecs
calling  cryptomgr_init+0x0/0xf @ 1
initcall cryptomgr_init+0x0/0xf returned 0 after 0 usecs
calling  blk_settings_init+0x0/0x1d @ 1
initcall blk_settings_init+0x0/0x1d returned 0 after 0 usecs
calling  blk_ioc_init+0x0/0x2f @ 1
initcall blk_ioc_init+0x0/0x2f returned 0 after 0 usecs
calling  blk_softirq_init+0x0/0x2a @ 1
initcall blk_softirq_init+0x0/0x2a returned 0 after 0 usecs
calling  blk_iopoll_setup+0x0/0x2a @ 1
initcall blk_iopoll_setup+0x0/0x2a returned 0 after 0 usecs
calling  genhd_device_init+0x0/0x50 @ 1
initcall genhd_device_init+0x0/0x50 returned 0 after 0 usecs
calling  blk_dev_integrity_init+0x0/0x2f @ 1
initcall blk_dev_integrity_init+0x0/0x2f returned 0 after 0 usecs
calling  gpiolib_debugfs_init+0x0/0x2a @ 1
initcall gpiolib_debugfs_init+0x0/0x2a returned 0 after 0 usecs
calling  max7301_init+0x0/0xf @ 1
initcall max7301_init+0x0/0xf returned 0 after 0 usecs
calling  mc33880_init+0x0/0xf @ 1
initcall mc33880_init+0x0/0xf returned 0 after 0 usecs
calling  pci_slot_init+0x0/0x50 @ 1
initcall pci_slot_init+0x0/0x50 returned 0 after 0 usecs
calling  fbmem_init+0x0/0x96 @ 1
initcall fbmem_init+0x0/0x96 returned 0 after 0 usecs
calling  misc_init+0x0/0xad @ 1
initcall misc_init+0x0/0xad returned 0 after 0 usecs
calling  vga_arb_device_init+0x0/0x75 @ 1
vgaarb: loaded
initcall vga_arb_device_init+0x0/0x75 returned 0 after 0 usecs
calling  cn_init+0x0/0x9d @ 1
initcall cn_init+0x0/0x9d returned 0 after 0 usecs
calling  tifm_init+0x0/0x81 @ 1
initcall tifm_init+0x0/0x81 returned 0 after 0 usecs
calling  init_scsi+0x0/0x90 @ 1
SCSI subsystem initialized
initcall init_scsi+0x0/0x90 returned 0 after 3906 usecs
calling  ata_init+0x0/0x2b9 @ 1
libata version 3.00 loaded.
initcall ata_init+0x0/0x2b9 returned 0 after 0 usecs
calling  phy_init+0x0/0x2a @ 1
initcall phy_init+0x0/0x2a returned 0 after 0 usecs
calling  usb_init+0x0/0x156 @ 1
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
initcall usb_init+0x0/0x156 returned 0 after 11718 usecs
calling  serio_init+0x0/0x8b @ 1
initcall serio_init+0x0/0x8b returned 0 after 0 usecs
calling  gameport_init+0x0/0x8b @ 1
initcall gameport_init+0x0/0x8b returned 0 after 0 usecs
calling  input_init+0x0/0x127 @ 1
initcall input_init+0x0/0x127 returned 0 after 0 usecs
calling  i2c_gpio_init+0x0/0x2e @ 1
initcall i2c_gpio_init+0x0/0x2e returned 0 after 0 usecs
calling  init_dvbdev+0x0/0xc2 @ 1
initcall init_dvbdev+0x0/0xc2 returned 0 after 0 usecs
calling  power_supply_class_init+0x0/0x39 @ 1
initcall power_supply_class_init+0x0/0x39 returned 0 after 3906 usecs
calling  thermal_init+0x0/0x32 @ 1
initcall thermal_init+0x0/0x32 returned 0 after 0 usecs
calling  mmc_init+0x0/0x7a @ 1
initcall mmc_init+0x0/0x7a returned 0 after 0 usecs
calling  leds_init+0x0/0x3d @ 1
initcall leds_init+0x0/0x3d returned 0 after 0 usecs
calling  init_soundcore+0x0/0x8c @ 1
initcall init_soundcore+0x0/0x8c returned 0 after 0 usecs
calling  alsa_sound_init+0x0/0xac @ 1
Advanced Linux Sound Architecture Driver Version 1.0.23.
initcall alsa_sound_init+0x0/0xac returned 0 after 3906 usecs
calling  ac97_bus_init+0x0/0xf @ 1
initcall ac97_bus_init+0x0/0xf returned 0 after 0 usecs
calling  pci_subsys_init+0x0/0x44 @ 1
PCI: Probing PCI hardware
PCI: Probing PCI hardware (bus 00)
HPET not enabled in BIOS. You might try hpet=force boot option
pci 0000:00:01.1: reg 10: [io  0xdc00-0xdc1f]
pci 0000:00:01.1: reg 20: [io  0x4c00-0x4c3f]
pci 0000:00:01.1: reg 24: [io  0x4c40-0x4c7f]
pci 0000:00:01.1: PME# supported from D3hot D3cold
pci 0000:00:01.1: PME# disabled
pci 0000:00:02.0: reg 10: [mem 0xda102000-0xda102fff]
pci 0000:00:02.0: supports D1 D2
pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:02.0: PME# disabled
pci 0000:00:02.1: reg 10: [mem 0xfeb00000-0xfeb000ff]
pci 0000:00:02.1: supports D1 D2
pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:02.1: PME# disabled
pci 0000:00:04.0: reg 10: [io  0xd400-0xd4ff]
pci 0000:00:04.0: reg 14: [io  0xd800-0xd8ff]
pci 0000:00:04.0: reg 18: [mem 0xda101000-0xda101fff]
pci 0000:00:04.0: supports D1 D2
pci 0000:00:06.0: reg 20: [io  0xf000-0xf00f]
pci 0000:00:0a.0: reg 10: [mem 0xda100000-0xda100fff]
pci 0000:00:0a.0: reg 14: [io  0xd000-0xd007]
pci 0000:00:0a.0: supports D1 D2
pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0a.0: PME# disabled
pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0b.0: PME# disabled
pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0c.0: PME# disabled
pci 0000:00:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0d.0: PME# disabled
pci 0000:00:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0e.0: PME# disabled
PCI: peer root bus 00 res updated from pci conf
pci 0000:05:07.0: reg 10: [io  0xc000-0xc0ff]
pci 0000:05:07.0: reg 14: [mem 0xda000000-0xda0000ff]
pci 0000:05:07.0: supports D1 D2
pci 0000:05:07.0: PME# supported from D1 D2 D3hot
pci 0000:05:07.0: PME# disabled
pci 0000:00:09.0: PCI bridge to [bus 05-05] (subtractive decode)
pci 0000:00:09.0:   bridge window [io  0xc000-0xcfff]
pci 0000:00:09.0:   bridge window [mem 0xda000000-0xda0fffff]
pci 0000:00:09.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:00:09.0:   bridge window [io  0x0000-0xffff] (subtractive decode)
pci 0000:00:09.0:   bridge window [mem 0x40000000-0xffffffff] (subtractive decode)
pci 0000:00:09.0:   bridge window [mem 0xfeb00000-0xfec0ffff] (subtractive decode)
pci 0000:00:09.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
pci 0000:00:0b.0: PCI bridge to [bus 04-04]
pci 0000:00:0b.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:0b.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:00:0b.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:00:0c.0: PCI bridge to [bus 03-03]
pci 0000:00:0c.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:0c.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:00:0c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:00:0d.0: PCI bridge to [bus 02-02]
pci 0000:00:0d.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:0d.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:00:0d.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:01:00.0: reg 10: [mem 0xd0000000-0xd7ffffff pref]
pci 0000:01:00.0: reg 14: [io  0xb000-0xb0ff]
pci 0000:01:00.0: reg 18: [mem 0xd9000000-0xd900ffff]
pci 0000:01:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
pci 0000:01:00.0: supports D1 D2
Clocksource tsc unstable (delta = 87321875 ns)
pci 0000:01:00.1: reg 10: [mem 0xd9010000-0xd901ffff]
pci 0000:01:00.1: supports D1 D2
pci 0000:01:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
pci 0000:00:0e.0: PCI bridge to [bus 01-01]
pci 0000:00:0e.0:   bridge window [io  0xb000-0xbfff]
pci 0000:00:0e.0:   bridge window [mem 0xd8000000-0xd9ffffff]
pci 0000:00:0e.0:   bridge window [mem 0xd0000000-0xd7ffffff 64bit pref]
vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
pci 0000:00:00.0: default IRQ router [10de:005e]
PCI: pci_cache_line_size set to 64 bytes
pci 0000:00:02.1: address space collision: [mem 0xfeb00000-0xfeb000ff] conflicts with PCI Bus #00 [mem 0xfeb00000-0xfec0ffff]
Expanded resource reserved due to conflict with PCI Bus #00
reserve RAM buffer: 000000000009f800 - 000000000009ffff 
reserve RAM buffer: 000000003fff0000 - 000000003fffffff initcall pci_subsys_init+0x0/0x44 returned 0 after 292968 usecs
calling  proto_init+0x0/0xf @ 1
initcall proto_init+0x0/0xf returned 0 after 0 usecs
calling  net_dev_init+0x0/0x125 @ 1
initcall net_dev_init+0x0/0x125 returned 0 after 0 usecs
calling  neigh_init+0x0/0x7c @ 1
initcall neigh_init+0x0/0x7c returned 0 after 0 usecs
calling  fib_rules_init+0x0/0xa4 @ 1
initcall fib_rules_init+0x0/0xa4 returned 0 after 0 usecs
calling  genl_init+0x0/0x7f @ 1
initcall genl_init+0x0/0x7f returned 0 after 0 usecs
calling  cipso_v4_init+0x0/0x54 @ 1
initcall cipso_v4_init+0x0/0x54 returned 0 after 0 usecs
calling  wanrouter_init+0x0/0x5a @ 1
Sangoma WANPIPE Router v1.1 (c) 1995-2000 Sangoma Technologies Inc.
initcall wanrouter_init+0x0/0x5a returned 0 after 3906 usecs
calling  atm_init+0x0/0xd7 @ 1
NET: Registered protocol family 8
NET: Registered protocol family 20
initcall atm_init+0x0/0xd7 returned 0 after 3906 usecs
calling  cfg80211_init+0x0/0xc2 @ 1
cfg80211: Calling CRDA to update world regulatory domain
initcall cfg80211_init+0x0/0xc2 returned 0 after 7812 usecs
calling  wireless_nlevent_init+0x0/0xf @ 1
initcall wireless_nlevent_init+0x0/0xf returned 0 after 0 usecs
calling  ieee80211_init+0x0/0x25 @ 1
initcall ieee80211_init+0x0/0x25 returned 0 after 0 usecs
calling  netlbl_init+0x0/0x7d @ 1
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
initcall netlbl_init+0x0/0x7d returned 0 after 15625 usecs
calling  rfkill_init+0x0/0x66 @ 1
initcall rfkill_init+0x0/0x66 returned 0 after 0 usecs
calling  sysctl_init+0x0/0x3b @ 1
initcall sysctl_init+0x0/0x3b returned 0 after 0 usecs
calling  print_ICs+0x0/0x4c6 @ 1

printing PIC contents
... PIC  IMR: fffa
... PIC  IRR: 0001
... PIC  ISR: 0001
... PIC ELCR: 0828
printing local APIC contents on CPU#0/0:
... APIC ID:      00000000 (0)
... APIC VERSION: 00040010
... APIC TASKPRI: 00000000 (00)
... APIC ARBPRI: 000000e0 (e0)
... APIC PROCPRI: 00000000
... APIC LDR: 01000000
... APIC DFR: ffffffff
... APIC SPIV: 000001ff
... APIC ISR field:
0000000000000000000000000000000000000000000000000000000000000000
... APIC TMR field:
0000000000000000000000000000000000000000000000000000000000000000
... APIC IRR field:
0000000000000000000000000000000000000000000000000000000000008000
... APIC ESR: 00000000
... APIC ICR: 0000c650
... APIC ICR2: 01000000
... APIC LVTT: 000200ef
... APIC LVTPC: 00000400
... APIC LVT0: 00010700
... APIC LVT1: 00000400
... APIC LVTERR: 000000fe
... APIC TMICT: 0000c454
... APIC TMCCT: 0000aa1b
... APIC TDCR: 00000003

number of MP IRQ sources: 17.
number of IO-APIC #2 registers: 24.
testing the IO APIC.......................

IO APIC #2......
.... register #00: 00000000
.......    : physical APIC id: 00
.......    : Delivery Type: 0
.......    : LTS          : 0
.... register #01: 00170011
.......     : max redirection entries: 0017
.......     : PRQ implemented: 0
.......     : IO APIC version: 0011
.... register #02: 00000000
.......     : arbitration: 00
.... IRQ redirection table:
 NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
 00 001 0    0    0   0   0    1    1    30
 01 001 0    0    0   0   0    1    1    31
 02 000 1    0    0   0   0    0    0    00
 03 001 1    1    0   1   0    1    1    29
 04 001 0    0    0   0   0    1    1    34
 05 001 1    1    0   1   0    1    1    41
 06 001 0    0    0   0   0    1    1    36
 07 001 1    0    0   0   0    1    1    37
 08 001 0    0    0   0   0    1    1    38
 09 001 0    0    0   0   0    1    1    39
 0a 001 0    0    0   0   0    1    1    3A
 0b 001 1    1    0   1   0    1    1    49
 0c 001 0    0    0   0   0    1    1    3C
 0d 001 0    0    0   0   0    1    1    3D
 0e 001 0    0    0   0   0    1    1    3E
 0f 001 0    0    0   0   0    1    1    3F
 10 000 1    0    0   0   0    0    0    00
 11 000 1    0    0   0   0    0    0    00
 12 000 1    0    0   0   0    0    0    00
 13 000 1    0    0   0   0    0    0    00
 14 000 1    0    0   0   0    0    0    00
 15 000 1    0    0   0   0    0    0    00
 16 000 1    0    0   0   0    0    0    00
 17 000 1    0    0   0   0    0    0    00
IRQ to pin mappings:
IRQ0 -> 0:0
IRQ1 -> 0:1
IRQ4 -> 0:4
IRQ6 -> 0:6
IRQ7 -> 0:7
IRQ8 -> 0:8
IRQ9 -> 0:9
IRQ10 -> 0:10
IRQ12 -> 0:12
IRQ13 -> 0:13
IRQ14 -> 0:14
IRQ15 -> 0:15
IRQ27 -> 0:3
IRQ29 -> 0:5
IRQ35 -> 0:11
.................................... done.
initcall print_ICs+0x0/0x4c6 returned 0 after 171875 usecs
calling  hpet_late_init+0x0/0x5f @ 1
initcall hpet_late_init+0x0/0x5f returned -19 after 0 usecs
calling  init_k8_nbs+0x0/0x24 @ 1
initcall init_k8_nbs+0x0/0x24 returned 0 after 0 usecs
calling  clocksource_done_booting+0x0/0x4f @ 1
initcall clocksource_done_booting+0x0/0x4f returned 0 after 0 usecs
calling  ftrace_init_debugfs+0x0/0xdd @ 1
initcall ftrace_init_debugfs+0x0/0xdd returned 0 after 0 usecs
calling  rb_init_debugfs+0x0/0x2f @ 1
initcall rb_init_debugfs+0x0/0x2f returned 0 after 0 usecs
calling  tracer_init_debugfs+0x0/0x2f9 @ 1
initcall tracer_init_debugfs+0x0/0x2f9 returned 0 after 0 usecs
calling  init_trace_printk_function_export+0x0/0x33 @ 1
initcall init_trace_printk_function_export+0x0/0x33 returned 0 after 0 usecs
calling  stat_workqueue_init+0x0/0x2b @ 1
initcall stat_workqueue_init+0x0/0x2b returned 0 after 0 usecs
calling  event_trace_init+0x0/0x270 @ 1
initcall event_trace_init+0x0/0x270 returned 0 after 23437 usecs
calling  init_pipe_fs+0x0/0x3d @ 1
initcall init_pipe_fs+0x0/0x3d returned 0 after 0 usecs
calling  eventpoll_init+0x0/0xa1 @ 1
initcall eventpoll_init+0x0/0xa1 returned 0 after 0 usecs
calling  anon_inode_init+0x0/0xf9 @ 1
initcall anon_inode_init+0x0/0xf9 returned 0 after 0 usecs
calling  fscache_init+0x0/0xa5 @ 1
Slow work thread pool: Starting up
Slow work thread pool: Ready
FS-Cache: Loaded
initcall fscache_init+0x0/0xa5 returned 0 after 7812 usecs
calling  tomoyo_initerface_init+0x0/0x154 @ 1
initcall tomoyo_initerface_init+0x0/0x154 returned 0 after 0 usecs
calling  blk_scsi_ioctl_init+0x0/0x288 @ 1
initcall blk_scsi_ioctl_init+0x0/0x288 returned 0 after 0 usecs
calling  chr_dev_init+0x0/0xcc @ 1
initcall chr_dev_init+0x0/0xcc returned 0 after 0 usecs
calling  firmware_class_init+0x0/0x14 @ 1
initcall firmware_class_init+0x0/0x14 returned 0 after 0 usecs
calling  ieee1394_init+0x0/0x21e @ 1
initcall ieee1394_init+0x0/0x21e returned 0 after 0 usecs
calling  cpufreq_gov_performance_init+0x0/0xf @ 1
initcall cpufreq_gov_performance_init+0x0/0xf returned 0 after 0 usecs
calling  cpufreq_gov_userspace_init+0x0/0xf @ 1
initcall cpufreq_gov_userspace_init+0x0/0xf returned 0 after 0 usecs
calling  ssb_modinit+0x0/0x5a @ 1
initcall ssb_modinit+0x0/0x5a returned 0 after 0 usecs
calling  pcibios_assign_resources+0x0/0x6b @ 1
pci 0000:00:02.1: BAR 0: assigned [mem 0x40000000-0x400000ff]
pci 0000:00:02.1: BAR 0: set to [mem 0x40000000-0x400000ff] (PCI address [0x40000000-0x400000ff]
pci 0000:00:09.0: PCI bridge to [bus 05-05]
pci 0000:00:09.0:   bridge window [io  0xc000-0xcfff]
pci 0000:00:09.0:   bridge window [mem 0xda000000-0xda0fffff]
pci 0000:00:09.0:   bridge window [mem pref disabled]
pci 0000:00:0b.0: PCI bridge to [bus 04-04]
pci 0000:00:0b.0:   bridge window [io  disabled]
pci 0000:00:0b.0:   bridge window [mem disabled]
pci 0000:00:0b.0:   bridge window [mem pref disabled]
pci 0000:00:0c.0: PCI bridge to [bus 03-03]
pci 0000:00:0c.0:   bridge window [io  disabled]
pci 0000:00:0c.0:   bridge window [mem disabled]
pci 0000:00:0c.0:   bridge window [mem pref disabled]
pci 0000:00:0d.0: PCI bridge to [bus 02-02]
pci 0000:00:0d.0:   bridge window [io  disabled]
pci 0000:00:0d.0:   bridge window [mem disabled]
pci 0000:00:0d.0:   bridge window [mem pref disabled]
pci 0000:01:00.0: BAR 6: assigned [mem 0xd8000000-0xd801ffff pref]
pci 0000:00:0e.0: PCI bridge to [bus 01-01]
pci 0000:00:0e.0:   bridge window [io  0xb000-0xbfff]
pci 0000:00:0e.0:   bridge window [mem 0xd8000000-0xd9ffffff]
pci 0000:00:0e.0:   bridge window [mem 0xd0000000-0xd7ffffff 64bit pref]
pci 0000:00:09.0: setting latency timer to 64
pci 0000:00:0b.0: setting latency timer to 64
pci 0000:00:0c.0: setting latency timer to 64
pci 0000:00:0d.0: setting latency timer to 64
pci 0000:00:0e.0: setting latency timer to 64
pci_bus 0000:00: resource 4 [io  0x0000-0xffff]
pci_bus 0000:00: resource 5 [mem 0x40000000-0xffffffff]
pci_bus 0000:00: resource 6 [mem 0xfeb00000-0xfec0ffff]
pci_bus 0000:00: resource 7 [mem 0x000a0000-0x000bffff]
pci_bus 0000:05: resource 0 [io  0xc000-0xcfff]
pci_bus 0000:05: resource 1 [mem 0xda000000-0xda0fffff]
pci_bus 0000:05: resource 4 [io  0x0000-0xffff]
pci_bus 0000:05: resource 5 [mem 0x40000000-0xffffffff]
pci_bus 0000:05: resource 6 [mem 0xfeb00000-0xfec0ffff]
pci_bus 0000:05: resource 7 [mem 0x000a0000-0x000bffff]
pci_bus 0000:01: resource 0 [io  0xb000-0xbfff]
pci_bus 0000:01: resource 1 [mem 0xd8000000-0xd9ffffff]
pci_bus 0000:01: resource 2 [mem 0xd0000000-0xd7ffffff 64bit pref]
initcall pcibios_assign_resources+0x0/0x6b returned 0 after 160156 usecs
calling  sysctl_core_init+0x0/0x2d @ 1
initcall sysctl_core_init+0x0/0x2d returned 0 after 0 usecs
calling  inet_init+0x0/0x249 @ 1
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 6, 262144 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
UDP hash table entries: 512 (order: 1, 8192 bytes)
UDP-Lite hash table entries: 512 (order: 1, 8192 bytes)
initcall inet_init+0x0/0x249 returned 0 after 27343 usecs
calling  af_unix_init+0x0/0x4d @ 1
NET: Registered protocol family 1
initcall af_unix_init+0x0/0x4d returned 0 after 3906 usecs
calling  init_sunrpc+0x0/0x53 @ 1
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
initcall init_sunrpc+0x0/0x53 returned 0 after 11718 usecs
calling  pci_apply_final_quirks+0x0/0x10a @ 1
pci 0000:01:00.0: Boot video device
PCI: CLS 32 bytes, default 64
initcall pci_apply_final_quirks+0x0/0x10a returned 0 after 19531 usecs
calling  default_rootfs+0x0/0x75 @ 1
initcall default_rootfs+0x0/0x75 returned 0 after 0 usecs
calling  pci_iommu_init+0x0/0x21 @ 1
DMA-API: preallocated 32768 debug entries
DMA-API: debugging enabled by kernel config
initcall pci_iommu_init+0x0/0x21 returned 0 after 31250 usecs
calling  irqfd_module_init+0x0/0x3d @ 1
initcall irqfd_module_init+0x0/0x3d returned 0 after 0 usecs
calling  i8259A_init_sysfs+0x0/0x1d @ 1
initcall i8259A_init_sysfs+0x0/0x1d returned 0 after 0 usecs
calling  sbf_init+0x0/0xe3 @ 1
initcall sbf_init+0x0/0xe3 returned 0 after 0 usecs
calling  i8237A_init_sysfs+0x0/0x1d @ 1
initcall i8237A_init_sysfs+0x0/0x1d returned 0 after 0 usecs
calling  add_rtc_cmos+0x0/0x47 @ 1
platform rtc_cmos: registered platform RTC device (no PNP device found)
initcall add_rtc_cmos+0x0/0x47 returned 0 after 3906 usecs
calling  cache_sysfs_init+0x0/0x1ff @ 1
initcall cache_sysfs_init+0x0/0x1ff returned 0 after 0 usecs
calling  mcheck_init_device+0x0/0x1c7 @ 1
initcall mcheck_init_device+0x0/0x1c7 returned 0 after 0 usecs
calling  threshold_init_device+0x0/0x38 @ 1
initcall threshold_init_device+0x0/0x38 returned 0 after 0 usecs
calling  inject_init+0x0/0x30 @ 1
Machine check injector initialized
initcall inject_init+0x0/0x30 returned 0 after 3906 usecs
calling  thermal_throttle_init_device+0x0/0x37 @ 1
initcall thermal_throttle_init_device+0x0/0x37 returned 0 after 0 usecs
calling  powernow_k6_init+0x0/0x8b @ 1
initcall powernow_k6_init+0x0/0x8b returned -19 after 0 usecs
calling  eps_init+0x0/0x3d @ 1
initcall eps_init+0x0/0x3d returned -19 after 0 usecs
calling  elanfreq_init+0x0/0x36 @ 1
elanfreq: error: no Elan processor found!
initcall elanfreq_init+0x0/0x36 returned -19 after 3906 usecs
calling  sc520_freq_init+0x0/0x88 @ 1
initcall sc520_freq_init+0x0/0x88 returned -19 after 0 usecs
calling  longrun_init+0x0/0x28 @ 1
initcall longrun_init+0x0/0x28 returned -19 after 0 usecs
calling  cpufreq_gx_init+0x0/0x1d7 @ 1
initcall cpufreq_gx_init+0x0/0x1d7 returned -19 after 0 usecs
calling  speedstep_init+0x0/0x119 @ 1
initcall speedstep_init+0x0/0x119 returned -19 after 0 usecs
calling  nforce2_init+0x0/0x6f @ 1
cpufreq-nforce2: No nForce2 chipset.
initcall nforce2_init+0x0/0x6f returned -19 after 3906 usecs
calling  msr_init+0x0/0xe7 @ 1
initcall msr_init+0x0/0xe7 returned 0 after 0 usecs
calling  cpuid_init+0x0/0xe7 @ 1
initcall cpuid_init+0x0/0xe7 returned 0 after 0 usecs
calling  ioapic_init_sysfs+0x0/0x89 @ 1
initcall ioapic_init_sysfs+0x0/0x89 returned 0 after 0 usecs
calling  add_pcspkr+0x0/0x2f @ 1
initcall add_pcspkr+0x0/0x2f returned 0 after 0 usecs
calling  start_periodic_check_for_corruption+0x0/0x40 @ 1
initcall start_periodic_check_for_corruption+0x0/0x40 returned 0 after 0 usecs
calling  aes_init+0x0/0xf @ 1
initcall aes_init+0x0/0xf returned 0 after 0 usecs
calling  init+0x0/0xf @ 1
initcall init+0x0/0xf returned 0 after 0 usecs
calling  proc_execdomains_init+0x0/0x27 @ 1
initcall proc_execdomains_init+0x0/0x27 returned 0 after 0 usecs
calling  ioresources_init+0x0/0x44 @ 1
initcall ioresources_init+0x0/0x44 returned 0 after 0 usecs
calling  uid_cache_init+0x0/0x79 @ 1
initcall uid_cache_init+0x0/0x79 returned 0 after 0 usecs
calling  init_posix_timers+0x0/0x157 @ 1
initcall init_posix_timers+0x0/0x157 returned 0 after 0 usecs
calling  init_posix_cpu_timers+0x0/0xb7 @ 1
initcall init_posix_cpu_timers+0x0/0xb7 returned 0 after 0 usecs
calling  nsproxy_cache_init+0x0/0x32 @ 1
initcall nsproxy_cache_init+0x0/0x32 returned 0 after 0 usecs
calling  create_proc_profile+0x0/0x60 @ 1
initcall create_proc_profile+0x0/0x60 returned 0 after 0 usecs
calling  timekeeping_init_device+0x0/0x1d @ 1
initcall timekeeping_init_device+0x0/0x1d returned 0 after 0 usecs
calling  init_clocksource_sysfs+0x0/0x43 @ 1
initcall init_clocksource_sysfs+0x0/0x43 returned 0 after 0 usecs
calling  init_timer_list_procfs+0x0/0x30 @ 1
initcall init_timer_list_procfs+0x0/0x30 returned 0 after 0 usecs
calling  futex_init+0x0/0x76 @ 1
initcall futex_init+0x0/0x76 returned 0 after 0 usecs
calling  proc_dma_init+0x0/0x27 @ 1
initcall proc_dma_init+0x0/0x27 returned 0 after 0 usecs
calling  kallsyms_init+0x0/0x2a @ 1
initcall kallsyms_init+0x0/0x2a returned 0 after 0 usecs
calling  crash_save_vmcoreinfo_init+0x0/0x4b4 @ 1
initcall crash_save_vmcoreinfo_init+0x0/0x4b4 returned 0 after 0 usecs
calling  crash_notes_memory_init+0x0/0x35 @ 1
initcall crash_notes_memory_init+0x0/0x35 returned 0 after 0 usecs
calling  audit_init+0x0/0x117 @ 1
audit: initializing netlink socket (disabled)
type=2000 audit(1277895987.604:1): initialized
initcall audit_init+0x0/0x117 returned 0 after 7812 usecs
calling  utsname_sysctl_init+0x0/0x11 @ 1
initcall utsname_sysctl_init+0x0/0x11 returned 0 after 0 usecs
calling  ftrace_mod_cmd_init+0x0/0xf @ 1
initcall ftrace_mod_cmd_init+0x0/0xf returned 0 after 0 usecs
calling  init_events+0x0/0x5d @ 1
initcall init_events+0x0/0x5d returned 0 after 0 usecs
calling  init_sched_switch_trace+0x0/0xf @ 1
initcall init_sched_switch_trace+0x0/0xf returned 0 after 0 usecs
calling  init_function_trace+0x0/0x35 @ 1
initcall init_function_trace+0x0/0x35 returned 0 after 0 usecs
calling  init_irqsoff_tracer+0x0/0x11 @ 1
initcall init_irqsoff_tracer+0x0/0x11 returned 0 after 0 usecs
calling  init_wakeup_tracer+0x0/0x1d @ 1
initcall init_wakeup_tracer+0x0/0x1d returned 0 after 0 usecs
calling  stack_trace_init+0x0/0x68 @ 1
initcall stack_trace_init+0x0/0x68 returned 0 after 0 usecs
calling  init_mmio_trace+0x0/0xf @ 1
initcall init_mmio_trace+0x0/0xf returned 0 after 0 usecs
calling  init_graph_trace+0x0/0x6a @ 1
initcall init_graph_trace+0x0/0x6a returned 0 after 0 usecs
calling  init_blk_tracer+0x0/0x56 @ 1
initcall init_blk_tracer+0x0/0x56 returned 0 after 0 usecs
calling  init_ksym_trace+0x0/0x5d @ 1
initcall init_ksym_trace+0x0/0x5d returned 0 after 0 usecs
calling  perf_event_sysfs_init+0x0/0x14 @ 1
initcall perf_event_sysfs_init+0x0/0x14 returned 0 after 0 usecs
calling  init_per_zone_wmark_min+0x0/0x67 @ 1
initcall init_per_zone_wmark_min+0x0/0x67 returned 0 after 0 usecs
calling  kswapd_init+0x0/0x13 @ 1
initcall kswapd_init+0x0/0x13 returned 0 after 0 usecs
calling  setup_vmstat+0x0/0x8a @ 1
initcall setup_vmstat+0x0/0x8a returned 0 after 0 usecs
calling  mm_sysfs_init+0x0/0x22 @ 1
initcall mm_sysfs_init+0x0/0x22 returned 0 after 0 usecs
calling  proc_vmalloc_init+0x0/0x2a @ 1
initcall proc_vmalloc_init+0x0/0x2a returned 0 after 0 usecs
calling  init_emergency_pool+0x0/0x62 @ 1
highmem bounce pool size: 64 pages
initcall init_emergency_pool+0x0/0x62 returned 0 after 0 usecs
calling  hugetlb_init+0x0/0x2fa @ 1
HugeTLB registered 4 MB page size, pre-allocated 0 pages
initcall hugetlb_init+0x0/0x2fa returned 0 after 3906 usecs
calling  ksm_init+0x0/0x1c1 @ 1
initcall ksm_init+0x0/0x1c1 returned 0 after 0 usecs
calling  slab_proc_init+0x0/0x2a @ 1
initcall slab_proc_init+0x0/0x2a returned 0 after 0 usecs
calling  slab_sysfs_init+0x0/0xc8 @ 1
initcall slab_sysfs_init+0x0/0xc8 returned 0 after 7812 usecs
calling  fasync_init+0x0/0x2f @ 1
initcall fasync_init+0x0/0x2f returned 0 after 0 usecs
calling  proc_filesystems_init+0x0/0x27 @ 1
initcall proc_filesystems_init+0x0/0x27 returned 0 after 0 usecs
calling  dnotify_init+0x0/0x81 @ 1
initcall dnotify_init+0x0/0x81 returned 0 after 0 usecs
calling  inotify_user_setup+0x0/0x78 @ 1
initcall inotify_user_setup+0x0/0x78 returned 0 after 0 usecs
calling  aio_setup+0x0/0xdd @ 1
initcall aio_setup+0x0/0xdd returned 0 after 0 usecs
calling  proc_locks_init+0x0/0x27 @ 1
initcall proc_locks_init+0x0/0x27 returned 0 after 0 usecs
calling  init_mbcache+0x0/0x11 @ 1
initcall init_mbcache+0x0/0x11 returned 0 after 0 usecs
calling  proc_cmdline_init+0x0/0x27 @ 1
initcall proc_cmdline_init+0x0/0x27 returned 0 after 0 usecs
calling  proc_cpuinfo_init+0x0/0x27 @ 1
initcall proc_cpuinfo_init+0x0/0x27 returned 0 after 0 usecs
calling  proc_devices_init+0x0/0x27 @ 1
initcall proc_devices_init+0x0/0x27 returned 0 after 0 usecs
calling  proc_interrupts_init+0x0/0x27 @ 1
initcall proc_interrupts_init+0x0/0x27 returned 0 after 0 usecs
calling  proc_loadavg_init+0x0/0x27 @ 1
initcall proc_loadavg_init+0x0/0x27 returned 0 after 0 usecs
calling  proc_meminfo_init+0x0/0x27 @ 1
initcall proc_meminfo_init+0x0/0x27 returned 0 after 0 usecs
calling  proc_stat_init+0x0/0x27 @ 1
initcall proc_stat_init+0x0/0x27 returned 0 after 0 usecs
calling  proc_uptime_init+0x0/0x27 @ 1
initcall proc_uptime_init+0x0/0x27 returned 0 after 0 usecs
calling  proc_version_init+0x0/0x27 @ 1
initcall proc_version_init+0x0/0x27 returned 0 after 0 usecs
calling  proc_softirqs_init+0x0/0x27 @ 1
initcall proc_softirqs_init+0x0/0x27 returned 0 after 0 usecs
calling  proc_kmsg_init+0x0/0x2a @ 1
initcall proc_kmsg_init+0x0/0x2a returned 0 after 0 usecs
calling  proc_page_init+0x0/0x4a @ 1
initcall proc_page_init+0x0/0x4a returned 0 after 0 usecs
calling  configfs_init+0x0/0xc8 @ 1
initcall configfs_init+0x0/0xc8 returned 0 after 0 usecs
calling  init_devpts_fs+0x0/0x3d @ 1
initcall init_devpts_fs+0x0/0x3d returned 0 after 0 usecs
calling  init_dlm+0x0/0x98 @ 1
DLM (built Jun 30 2010 02:07:29) installed
initcall init_dlm+0x0/0x98 returned 0 after 3906 usecs
calling  init_reiserfs_fs+0x0/0x64 @ 1
initcall init_reiserfs_fs+0x0/0x64 returned 0 after 0 usecs
calling  init_ext3_fs+0x0/0x6a @ 1
initcall init_ext3_fs+0x0/0x6a returned 0 after 0 usecs
calling  init_ext2_fs+0x0/0x6a @ 1
initcall init_ext2_fs+0x0/0x6a returned 0 after 0 usecs
calling  init_ext4_fs+0x0/0xd4 @ 1
initcall init_ext4_fs+0x0/0xd4 returned 0 after 0 usecs
calling  journal_init+0x0/0xa3 @ 1
initcall journal_init+0x0/0xa3 returned 0 after 0 usecs
calling  journal_init+0x0/0xe8 @ 1
initcall journal_init+0x0/0xe8 returned 0 after 0 usecs
calling  init_ramfs_fs+0x0/0xf @ 1
initcall init_ramfs_fs+0x0/0xf returned 0 after 0 usecs
calling  init_hugetlbfs_fs+0x0/0x8b @ 1
initcall init_hugetlbfs_fs+0x0/0x8b returned 0 after 0 usecs
calling  init_fat_fs+0x0/0x4c @ 1
initcall init_fat_fs+0x0/0x4c returned 0 after 0 usecs
calling  init_vfat_fs+0x0/0xf @ 1
initcall init_vfat_fs+0x0/0xf returned 0 after 0 usecs
calling  init_iso9660_fs+0x0/0x6a @ 1
initcall init_iso9660_fs+0x0/0x6a returned 0 after 0 usecs
calling  init_nfs_fs+0x0/0x158 @ 1
FS-Cache: Netfs 'nfs' registered for caching
initcall init_nfs_fs+0x0/0x158 returned 0 after 3906 usecs
calling  init_nlm+0x0/0x1c @ 1
initcall init_nlm+0x0/0x1c returned 0 after 0 usecs
calling  init_nls_cp437+0x0/0xf @ 1
initcall init_nls_cp437+0x0/0xf returned 0 after 0 usecs
calling  init_nls_cp737+0x0/0xf @ 1
initcall init_nls_cp737+0x0/0xf returned 0 after 0 usecs
calling  init_nls_cp775+0x0/0xf @ 1
initcall init_nls_cp775+0x0/0xf returned 0 after 0 usecs
calling  init_nls_cp850+0x0/0xf @ 1
initcall init_nls_cp850+0x0/0xf returned 0 after 0 usecs
calling  init_nls_cp852+0x0/0xf @ 1
initcall init_nls_cp852+0x0/0xf returned 0 after 0 usecs
calling  init_nls_cp857+0x0/0xf @ 1
initcall init_nls_cp857+0x0/0xf returned 0 after 0 usecs
calling  init_nls_cp861+0x0/0xf @ 1
initcall init_nls_cp861+0x0/0xf returned 0 after 0 usecs
calling  init_nls_cp862+0x0/0xf @ 1
initcall init_nls_cp862+0x0/0xf returned 0 after 0 usecs
calling  init_nls_cp863+0x0/0xf @ 1
initcall init_nls_cp863+0x0/0xf returned 0 after 0 usecs
calling  init_nls_cp864+0x0/0xf @ 1
initcall init_nls_cp864+0x0/0xf returned 0 after 0 usecs
calling  init_nls_cp866+0x0/0xf @ 1
initcall init_nls_cp866+0x0/0xf returned 0 after 0 usecs
calling  init_nls_cp869+0x0/0xf @ 1
initcall init_nls_cp869+0x0/0xf returned 0 after 0 usecs
calling  init_nls_cp932+0x0/0xf @ 1
initcall init_nls_cp932+0x0/0xf returned 0 after 0 usecs
calling  init_nls_euc_jp+0x0/0x39 @ 1
initcall init_nls_euc_jp+0x0/0x39 returned 0 after 0 usecs
calling  init_nls_cp936+0x0/0xf @ 1
initcall init_nls_cp936+0x0/0xf returned 0 after 0 usecs
calling  init_nls_cp949+0x0/0xf @ 1
initcall init_nls_cp949+0x0/0xf returned 0 after 0 usecs
calling  init_nls_cp1250+0x0/0xf @ 1
initcall init_nls_cp1250+0x0/0xf returned 0 after 0 usecs
calling  init_nls_ascii+0x0/0xf @ 1
initcall init_nls_ascii+0x0/0xf returned 0 after 0 usecs
calling  init_nls_iso8859_1+0x0/0xf @ 1
initcall init_nls_iso8859_1+0x0/0xf returned 0 after 0 usecs
calling  init_nls_iso8859_3+0x0/0xf @ 1
initcall init_nls_iso8859_3+0x0/0xf returned 0 after 0 usecs
calling  init_nls_iso8859_6+0x0/0xf @ 1
initcall init_nls_iso8859_6+0x0/0xf returned 0 after 0 usecs
calling  init_nls_iso8859_7+0x0/0xf @ 1
initcall init_nls_iso8859_7+0x0/0xf returned 0 after 0 usecs
calling  init_nls_cp1255+0x0/0xf @ 1
initcall init_nls_cp1255+0x0/0xf returned 0 after 0 usecs
calling  init_nls_iso8859_13+0x0/0xf @ 1
initcall init_nls_iso8859_13+0x0/0xf returned 0 after 0 usecs
calling  init_nls_iso8859_14+0x0/0xf @ 1
initcall init_nls_iso8859_14+0x0/0xf returned 0 after 0 usecs
calling  init_nls_koi8_u+0x0/0xf @ 1
initcall init_nls_koi8_u+0x0/0xf returned 0 after 0 usecs
calling  init_nls_koi8_ru+0x0/0x39 @ 1
initcall init_nls_koi8_ru+0x0/0x39 returned 0 after 0 usecs
calling  init_nls_utf8+0x0/0x1f @ 1
initcall init_nls_utf8+0x0/0x1f returned 0 after 0 usecs
calling  init_cifs+0x0/0x3e5 @ 1
initcall init_cifs+0x0/0x3e5 returned 0 after 3906 usecs
calling  init_ncp_fs+0x0/0x5a @ 1
initcall init_ncp_fs+0x0/0x5a returned 0 after 0 usecs
calling  init_ntfs_fs+0x0/0x235 @ 1
NTFS driver 2.1.29 [Flags: R/W DEBUG].
initcall init_ntfs_fs+0x0/0x235 returned 0 after 3906 usecs
calling  init_autofs_fs+0x0/0xf @ 1
initcall init_autofs_fs+0x0/0xf returned 0 after 0 usecs
calling  init_autofs4_fs+0x0/0x1e @ 1
initcall init_autofs4_fs+0x0/0x1e returned -16 after 0 usecs
initcall init_autofs4_fs+0x0/0x1e returned with error code -16 
calling  fuse_init+0x0/0x123 @ 1
fuse init (API version 7.14)
initcall fuse_init+0x0/0x123 returned 0 after 3906 usecs
calling  init_jfs_fs+0x0/0x18e @ 1
JFS: nTxBlock = 7942, nTxLock = 63536
initcall init_jfs_fs+0x0/0x18e returned 0 after 7812 usecs
calling  init_nilfs_fs+0x0/0xe1 @ 1
NILFS version 2 loaded
initcall init_nilfs_fs+0x0/0xe1 returned 0 after 3906 usecs
calling  init_ceph+0x0/0x176 @ 1
ceph: loaded (mon/mds/osd proto 15/32/24, osdmap 5/5 5/5)
initcall init_ceph+0x0/0x176 returned 0 after 3906 usecs
calling  ipc_init+0x0/0x20 @ 1
msgmni has been set to 1713
initcall ipc_init+0x0/0x20 returned 0 after 3906 usecs
calling  ipc_sysctl_init+0x0/0x11 @ 1
initcall ipc_sysctl_init+0x0/0x11 returned 0 after 0 usecs
calling  init_mqueue_fs+0x0/0x95 @ 1
initcall init_mqueue_fs+0x0/0x95 returned 0 after 0 usecs
calling  key_proc_init+0x0/0x64 @ 1
initcall key_proc_init+0x0/0x64 returned 0 after 0 usecs
calling  selinux_nf_ip_init+0x0/0x65 @ 1
SELinux:  Registering netfilter hooks
initcall selinux_nf_ip_init+0x0/0x65 returned 0 after 3906 usecs
calling  init_sel_fs+0x0/0x5c @ 1
initcall init_sel_fs+0x0/0x5c returned 0 after 0 usecs
calling  selnl_init+0x0/0x59 @ 1
initcall selnl_init+0x0/0x59 returned 0 after 0 usecs
calling  sel_netif_init+0x0/0x6d @ 1
initcall sel_netif_init+0x0/0x6d returned 0 after 0 usecs
calling  sel_netnode_init+0x0/0x76 @ 1
initcall sel_netnode_init+0x0/0x76 returned 0 after 0 usecs
calling  sel_netport_init+0x0/0x76 @ 1
initcall sel_netport_init+0x0/0x76 returned 0 after 0 usecs
calling  aurule_init+0x0/0x46 @ 1
initcall aurule_init+0x0/0x46 returned 0 after 0 usecs
calling  crypto_wq_init+0x0/0x3a @ 1
initcall crypto_wq_init+0x0/0x3a returned 0 after 0 usecs
calling  crypto_algapi_init+0x0/0xc @ 1
initcall crypto_algapi_init+0x0/0xc returned 0 after 0 usecs
calling  skcipher_module_init+0x0/0x11 @ 1
initcall skcipher_module_init+0x0/0x11 returned 0 after 0 usecs
calling  chainiv_module_init+0x0/0xf @ 1
initcall chainiv_module_init+0x0/0xf returned 0 after 0 usecs
calling  eseqiv_module_init+0x0/0xf @ 1
initcall eseqiv_module_init+0x0/0xf returned 0 after 0 usecs
calling  seqiv_module_init+0x0/0xf @ 1
initcall seqiv_module_init+0x0/0xf returned 0 after 0 usecs
calling  hmac_module_init+0x0/0xf @ 1
initcall hmac_module_init+0x0/0xf returned 0 after 0 usecs
calling  vmac_module_init+0x0/0xf @ 1
initcall vmac_module_init+0x0/0xf returned 0 after 0 usecs
calling  crypto_xcbc_module_init+0x0/0xf @ 1
initcall crypto_xcbc_module_init+0x0/0xf returned 0 after 0 usecs
calling  crypto_null_mod_init+0x0/0x69 @ 1
alg: No test for cipher_null (cipher_null-generic)
alg: No test for ecb(cipher_null) (ecb-cipher_null)
alg: No test for digest_null (digest_null-generic)
alg: No test for compress_null (compress_null-generic)
initcall crypto_null_mod_init+0x0/0x69 returned 0 after 15625 usecs
calling  md4_mod_init+0x0/0xf @ 1
initcall md4_mod_init+0x0/0xf returned 0 after 0 usecs
calling  md5_mod_init+0x0/0xf @ 1
initcall md5_mod_init+0x0/0xf returned 0 after 0 usecs
calling  rmd128_mod_init+0x0/0xf @ 1
initcall rmd128_mod_init+0x0/0xf returned 0 after 0 usecs
calling  rmd160_mod_init+0x0/0xf @ 1
initcall rmd160_mod_init+0x0/0xf returned 0 after 0 usecs
calling  rmd256_mod_init+0x0/0xf @ 1
initcall rmd256_mod_init+0x0/0xf returned 0 after 0 usecs
calling  rmd320_mod_init+0x0/0xf @ 1
initcall rmd320_mod_init+0x0/0xf returned 0 after 3906 usecs
calling  sha1_generic_mod_init+0x0/0xf @ 1
initcall sha1_generic_mod_init+0x0/0xf returned 0 after 0 usecs
calling  sha512_generic_mod_init+0x0/0x33 @ 1
initcall sha512_generic_mod_init+0x0/0x33 returned 0 after 0 usecs
calling  wp512_mod_init+0x0/0x59 @ 1
initcall wp512_mod_init+0x0/0x59 returned 0 after 0 usecs
calling  tgr192_mod_init+0x0/0x59 @ 1
initcall tgr192_mod_init+0x0/0x59 returned 0 after 0 usecs
calling  crypto_ecb_module_init+0x0/0xf @ 1
initcall crypto_ecb_module_init+0x0/0xf returned 0 after 0 usecs
calling  crypto_cbc_module_init+0x0/0xf @ 1
initcall crypto_cbc_module_init+0x0/0xf returned 0 after 0 usecs
calling  crypto_pcbc_module_init+0x0/0xf @ 1
initcall crypto_pcbc_module_init+0x0/0xf returned 0 after 0 usecs
calling  crypto_cts_module_init+0x0/0xf @ 1
initcall crypto_cts_module_init+0x0/0xf returned 0 after 0 usecs
calling  crypto_module_init+0x0/0xf @ 1
initcall crypto_module_init+0x0/0xf returned 0 after 0 usecs
calling  crypto_ctr_module_init+0x0/0x35 @ 1
initcall crypto_ctr_module_init+0x0/0x35 returned 0 after 0 usecs
calling  crypto_gcm_module_init+0x0/0x89 @ 1
initcall crypto_gcm_module_init+0x0/0x89 returned 0 after 0 usecs
calling  crypto_ccm_module_init+0x0/0x4f @ 1
initcall crypto_ccm_module_init+0x0/0x4f returned 0 after 0 usecs
calling  des_generic_mod_init+0x0/0x33 @ 1
initcall des_generic_mod_init+0x0/0x33 returned 0 after 0 usecs
calling  fcrypt_mod_init+0x0/0xf @ 1
alg: No test for fcrypt (fcrypt-generic)
initcall fcrypt_mod_init+0x0/0xf returned 0 after 3906 usecs
calling  blowfish_mod_init+0x0/0xf @ 1
initcall blowfish_mod_init+0x0/0xf returned 0 after 0 usecs
calling  aes_init+0x0/0xf @ 1
initcall aes_init+0x0/0xf returned 0 after 0 usecs
calling  camellia_init+0x0/0xf @ 1
initcall camellia_init+0x0/0xf returned 0 after 0 usecs
calling  cast5_mod_init+0x0/0xf @ 1
initcall cast5_mod_init+0x0/0xf returned 0 after 0 usecs
calling  cast6_mod_init+0x0/0xf @ 1
initcall cast6_mod_init+0x0/0xf returned 0 after 0 usecs
calling  arc4_init+0x0/0xf @ 1
initcall arc4_init+0x0/0xf returned 0 after 0 usecs
calling  tea_mod_init+0x0/0x59 @ 1
initcall tea_mod_init+0x0/0x59 returned 0 after 0 usecs
calling  khazad_mod_init+0x0/0xf @ 1
initcall khazad_mod_init+0x0/0xf returned 0 after 0 usecs
calling  anubis_mod_init+0x0/0xf @ 1
initcall anubis_mod_init+0x0/0xf returned 0 after 0 usecs
calling  salsa20_generic_mod_init+0x0/0xf @ 1
initcall salsa20_generic_mod_init+0x0/0xf returned 0 after 0 usecs
calling  deflate_mod_init+0x0/0xf @ 1
initcall deflate_mod_init+0x0/0xf returned 0 after 0 usecs
calling  zlib_mod_init+0x0/0xf @ 1
initcall zlib_mod_init+0x0/0xf returned 0 after 0 usecs
calling  michael_mic_init+0x0/0xf @ 1
initcall michael_mic_init+0x0/0xf returned 0 after 0 usecs
calling  crc32c_mod_init+0x0/0xf @ 1
initcall crc32c_mod_init+0x0/0xf returned 0 after 0 usecs
calling  crypto_authenc_module_init+0x0/0xf @ 1
initcall crypto_authenc_module_init+0x0/0xf returned 0 after 0 usecs
calling  krng_mod_init+0x0/0xf @ 1
alg: No test for stdrng (krng)
initcall krng_mod_init+0x0/0xf returned 0 after 3906 usecs
calling  prng_mod_init+0x0/0x1d @ 1
alg: No test for fips(ansi_cprng) (fips_ansi_cprng)
initcall prng_mod_init+0x0/0x1d returned 0 after 11718 usecs
calling  ghash_mod_init+0x0/0xf @ 1
initcall ghash_mod_init+0x0/0xf returned 0 after 0 usecs
calling  proc_genhd_init+0x0/0x44 @ 1
initcall proc_genhd_init+0x0/0x44 returned 0 after 0 usecs
calling  bsg_init+0x0/0x117 @ 1
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
initcall bsg_init+0x0/0x117 returned 0 after 3906 usecs
calling  init_cgroup_blkio+0x0/0xf @ 1
initcall init_cgroup_blkio+0x0/0xf returned 0 after 0 usecs
calling  noop_init+0x0/0x11 @ 1
io scheduler noop registered
initcall noop_init+0x0/0x11 returned 0 after 3906 usecs
calling  deadline_init+0x0/0x11 @ 1
io scheduler deadline registered (default)
initcall deadline_init+0x0/0x11 returned 0 after 3906 usecs
calling  cfq_init+0x0/0xa8 @ 1
io scheduler cfq registered
initcall cfq_init+0x0/0xa8 returned 0 after 0 usecs
calling  libcrc32c_mod_init+0x0/0x29 @ 1
initcall libcrc32c_mod_init+0x0/0x29 returned 0 after 0 usecs
calling  init_kmp+0x0/0xf @ 1
initcall init_kmp+0x0/0xf returned 0 after 0 usecs
calling  init_bm+0x0/0xf @ 1
initcall init_bm+0x0/0xf returned 0 after 0 usecs
calling  init_fsm+0x0/0xf @ 1
initcall init_fsm+0x0/0xf returned 0 after 0 usecs
calling  audit_classes_init+0x0/0x4f @ 1
initcall audit_classes_init+0x0/0x4f returned 0 after 0 usecs
calling  dynamic_debug_init+0x0/0x105 @ 1
initcall dynamic_debug_init+0x0/0x105 returned 0 after 0 usecs
calling  adp5588_gpio_init+0x0/0x11 @ 1
i2c-core: driver [adp5588-gpio] registered
initcall adp5588_gpio_init+0x0/0x11 returned 0 after 3906 usecs
calling  lnw_gpio_init+0x0/0x16 @ 1
initcall lnw_gpio_init+0x0/0x16 returned 0 after 0 usecs
calling  it8761e_gpio_init+0x0/0x15f @ 1
initcall it8761e_gpio_init+0x0/0x15f returned -19 after 0 usecs
calling  sch_gpio_init+0x0/0xf @ 1
initcall sch_gpio_init+0x0/0xf returned 0 after 0 usecs
calling  rdc321x_gpio_init+0x0/0xf @ 1
initcall rdc321x_gpio_init+0x0/0xf returned 0 after 0 usecs
calling  pci_proc_init+0x0/0x64 @ 1
initcall pci_proc_init+0x0/0x64 returned 0 after 0 usecs
calling  pcie_portdrv_init+0x0/0x51 @ 1
pcieport 0000:00:0b.0: setting latency timer to 64
pcieport 0000:00:0c.0: setting latency timer to 64
pcieport 0000:00:0d.0: setting latency timer to 64
pcieport 0000:00:0e.0: setting latency timer to 64
initcall pcie_portdrv_init+0x0/0x51 returned 0 after 15625 usecs
calling  pci_hotplug_init+0x0/0x1e @ 1
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
initcall pci_hotplug_init+0x0/0x1e returned 0 after 3906 usecs
calling  cpqhpc_init+0x0/0x66 @ 1
cpqphp: Compaq Hot Plug PCI Controller Driver version: 0.9.8
initcall cpqhpc_init+0x0/0x66 returned 0 after 3906 usecs
calling  pcied_init+0x0/0x71 @ 1
pciehp: PCI Express Hot Plug Controller Driver version: 0.4
initcall pcied_init+0x0/0x71 returned 0 after 3906 usecs
calling  shpcd_init+0x0/0x5f @ 1
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
initcall shpcd_init+0x0/0x5f returned 0 after 3906 usecs
calling  init_legacy+0x0/0x36 @ 1
initcall init_legacy+0x0/0x36 returned 0 after 0 usecs
calling  fb_console_init+0x0/0x117 @ 1
initcall fb_console_init+0x0/0x117 returned 0 after 0 usecs
calling  genericbl_init+0x0/0xf @ 1
initcall genericbl_init+0x0/0xf returned 0 after 0 usecs
calling  progearbl_init+0x0/0x4f @ 1
ALI M7101 PMU not found.
initcall progearbl_init+0x0/0x4f returned 0 after 0 usecs
calling  kb3886_init+0x0/0x33 @ 1
initcall kb3886_init+0x0/0x33 returned -19 after 0 usecs
calling  adp8860_init+0x0/0x11 @ 1
i2c-core: driver [adp8860_bl] registered
initcall adp8860_init+0x0/0x11 returned 0 after 3906 usecs
calling  display_class_init+0x0/0x6d @ 1
initcall display_class_init+0x0/0x6d returned 0 after 0 usecs
calling  arcfb_init+0x0/0x60 @ 1
initcall arcfb_init+0x0/0x60 returned -6 after 0 usecs
initcall arcfb_init+0x0/0x60 returned with error code -6 
calling  cyber2000fb_init+0x0/0xb3 @ 1
initcall cyber2000fb_init+0x0/0xb3 returned 0 after 0 usecs
calling  pm2fb_init+0x0/0x12b @ 1
initcall pm2fb_init+0x0/0x12b returned 0 after 0 usecs
calling  matroxfb_init+0x0/0x8a2 @ 1
initcall matroxfb_init+0x0/0x8a2 returned 0 after 0 usecs
calling  matroxfb_crtc2_init+0x0/0x30 @ 1
initcall matroxfb_crtc2_init+0x0/0x30 returned 0 after 0 usecs
calling  i2c_matroxfb_init+0x0/0x2b @ 1
initcall i2c_matroxfb_init+0x0/0x2b returned 0 after 0 usecs
calling  rivafb_init+0x0/0x1af @ 1
rivafb_setup START
initcall rivafb_init+0x0/0x1af returned 0 after 0 usecs
calling  aty128fb_init+0x0/0x118 @ 1
initcall aty128fb_init+0x0/0x118 returned 0 after 0 usecs
calling  via_core_init+0x0/0x29 @ 1
VIA Graphics Intergration Chipset framebuffer 2.4 initializing
initcall via_core_init+0x0/0x29 returned 0 after 3906 usecs
calling  kyrofb_init+0x0/0xc9 @ 1
initcall kyrofb_init+0x0/0xc9 returned 0 after 0 usecs
calling  savagefb_init+0x0/0x60 @ 1
initcall savagefb_init+0x0/0x60 returned 0 after 0 usecs
calling  neofb_init+0x0/0x12e @ 1
initcall neofb_init+0x0/0x12e returned 0 after 0 usecs
calling  tdfxfb_init+0x0/0x107 @ 1
initcall tdfxfb_init+0x0/0x107 returned 0 after 0 usecs
calling  imsttfb_init+0x0/0xd7 @ 1
initcall imsttfb_init+0x0/0xd7 returned 0 after 0 usecs
calling  vt8623fb_init+0x0/0x76 @ 1
initcall vt8623fb_init+0x0/0x76 returned 0 after 0 usecs
calling  tridentfb_init+0x0/0x1da @ 1
initcall tridentfb_init+0x0/0x1da returned 0 after 0 usecs
calling  vmlfb_init+0x0/0x80 @ 1
vmlfb: initializing
initcall vmlfb_init+0x0/0x80 returned 0 after 3906 usecs
calling  cr_pll_init+0x0/0xd1 @ 1
Could not find Carillo Ranch MCH device.
initcall cr_pll_init+0x0/0xd1 returned -19 after 3906 usecs
calling  s3fb_init+0x0/0xf2 @ 1
initcall s3fb_init+0x0/0xf2 returned 0 after 0 usecs
calling  arkfb_init+0x0/0x75 @ 1
initcall arkfb_init+0x0/0x75 returned 0 after 0 usecs
calling  hecubafb_init+0x0/0xf @ 1
initcall hecubafb_init+0x0/0xf returned 0 after 0 usecs
calling  n411_init+0x0/0x7f @ 1
no IO addresses supplied
initcall n411_init+0x0/0x7f returned -22 after 0 usecs
initcall n411_init+0x0/0x7f returned with error code -22 
calling  hgafb_init+0x0/0x63 @ 1
hgafb: HGA card not detected.
hgafb: probe of hgafb.0 failed with error -22
initcall hgafb_init+0x0/0x63 returned 0 after 7812 usecs
calling  sstfb_init+0x0/0x18f @ 1
initcall sstfb_init+0x0/0x18f returned 0 after 0 usecs
calling  tmiofb_init+0x0/0x57 @ 1
initcall tmiofb_init+0x0/0x57 returned 0 after 0 usecs
calling  metronomefb_init+0x0/0xf @ 1
initcall metronomefb_init+0x0/0xf returned 0 after 0 usecs
calling  broadsheetfb_init+0x0/0xf @ 1
initcall broadsheetfb_init+0x0/0xf returned 0 after 0 usecs
calling  carminefb_init+0x0/0x35 @ 1
initcall carminefb_init+0x0/0x35 returned 0 after 0 usecs
calling  mb862xxfb_init+0x0/0x1b @ 1
initcall mb862xxfb_init+0x0/0x1b returned 0 after 0 usecs
calling  uvesafb_init+0x0/0x35d @ 1
uvesafb: failed to execute /sbin/v86d
uvesafb: make sure that the v86d helper is installed and executable
uvesafb: Getting VBE info block failed (eax=0x4f00, err=-2)
uvesafb: vbe_init() failed with -22
uvesafb: probe of uvesafb.0 failed with error -22
initcall uvesafb_init+0x0/0x35d returned 0 after 15625 usecs
calling  virtio_pci_init+0x0/0x44 @ 1
initcall virtio_pci_init+0x0/0x44 returned 0 after 0 usecs
calling  init+0x0/0xf @ 1
initcall init+0x0/0xf returned 0 after 0 usecs
calling  rand_initialize+0x0/0x30 @ 1
initcall rand_initialize+0x0/0x30 returned 0 after 0 usecs
calling  tty_init+0x0/0x104 @ 1
initcall tty_init+0x0/0x104 returned 0 after 0 usecs
calling  pty_init+0x0/0x2bd @ 1
initcall pty_init+0x0/0x2bd returned 0 after 0 usecs
calling  sysrq_init+0x0/0x7a @ 1
initcall sysrq_init+0x0/0x7a returned 0 after 0 usecs
calling  rp_init+0x0/0xff3 @ 1
RocketPort device driver module, version 2.09, 12-June-2003
No rocketport ports found; unloading driver
initcall rp_init+0x0/0xff3 returned -6 after 7812 usecs
initcall rp_init+0x0/0xff3 returned with error code -6 
calling  stallion_module_init+0x0/0x3de @ 1
Stallion Multiport Serial Driver: version 5.6.0
initcall stallion_module_init+0x0/0x3de returned 0 after 3906 usecs
calling  specialix_init_module+0x0/0x354 @ 1
sx: Specialix IO8+ driver v1.11, (c) R.E.Wolff 1997/1998.
sx: derived from work (c) D.Gorodchanin 1994-1996.
sx: DTR/RTS pin is always RTS.
sx0: specialix IO8+ Board at 0x100 not found.
sx1: specialix IO8+ Board at 0x180 not found.
sx2: specialix IO8+ Board at 0x250 not found.
sx3: specialix IO8+ Board at 0x260 not found.
sx: No specialix IO8+ boards detected.
initcall specialix_init_module+0x0/0x354 returned -5 after 35156 usecs
initcall specialix_init_module+0x0/0x354 returned with error code -5 
calling  moxa_init+0x0/0x21c @ 1
MOXA Intellio family driver version 6.0k
initcall moxa_init+0x0/0x21c returned 0 after 11718 usecs
calling  mxser_module_init+0x0/0x5a7 @ 1
MOXA Smartio/Industio family driver version 2.0.5
initcall mxser_module_init+0x0/0x5a7 returned 0 after 3906 usecs
calling  ip2_loadmain+0x0/0x1292 @ 1
Computone IntelliPort Plus multiport driver version 1.2.14
initcall ip2_loadmain+0x0/0x1292 returned 0 after 3906 usecs
calling  synclink_init+0x0/0x22d @ 1
SyncLink serial driver $Revision: 4.38 $
SyncLink serial driver $Revision: 4.38 $, tty major#253
initcall synclink_init+0x0/0x22d returned 0 after 15625 usecs
calling  n_hdlc_init+0x0/0x8f @ 1
HDLC line discipline maxframe=4096
N_HDLC line discipline registered.
initcall n_hdlc_init+0x0/0x8f returned 0 after 7812 usecs
calling  gsm_init+0x0/0x117 @ 1
gsm_init: loaded as 252,0.
initcall gsm_init+0x0/0x117 returned 0 after 3906 usecs
calling  init+0x0/0x88 @ 1
initcall init+0x0/0x88 returned 0 after 3906 usecs
calling  raw_init+0x0/0xdd @ 1
initcall raw_init+0x0/0xdd returned 0 after 0 usecs
calling  lp_init_module+0x0/0x218 @ 1
lp: driver loaded but no devices found
initcall lp_init_module+0x0/0x218 returned 0 after 3906 usecs
calling  dtlk_init+0x0/0x1e2 @ 1
DoubleTalk PC - not found
initcall dtlk_init+0x0/0x1e2 returned -19 after 3906 usecs
calling  r3964_init+0x0/0x3f @ 1
r3964: Philips r3964 Driver $Revision: 1.10 $
initcall r3964_init+0x0/0x3f returned 0 after 3906 usecs
calling  applicom_init+0x0/0x46c @ 1
Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 Exp $
ac.o: No PCI boards found.
ac.o: For an ISA board you must supply memory and irq parameters.
initcall applicom_init+0x0/0x46c returned -6 after 7812 usecs
initcall applicom_init+0x0/0x46c returned with error code -6 
calling  sonypi_init+0x0/0x7f @ 1
sonypi: Sony Programmable I/O Controller Driver v1.26.
initcall sonypi_init+0x0/0x7f returned -19 after 3906 usecs
calling  rtc_init+0x0/0xff @ 1
Real Time Clock Driver v1.12b
initcall rtc_init+0x0/0xff returned 0 after 3906 usecs
calling  nvram_init+0x0/0x7e @ 1
Non-volatile memory driver v1.3
initcall nvram_init+0x0/0x7e returned 0 after 3906 usecs
calling  mod_init+0x0/0x207 @ 1
initcall mod_init+0x0/0x207 returned -19 after 0 usecs
calling  mod_init+0x0/0x97 @ 1
initcall mod_init+0x0/0x97 returned -19 after 0 usecs
calling  mod_init+0x0/0x48 @ 1
initcall mod_init+0x0/0x48 returned -19 after 0 usecs
calling  ppdev_init+0x0/0xbc @ 1
ppdev: user-space parallel port driver
initcall ppdev_init+0x0/0xbc returned 0 after 0 usecs
calling  nsc_gpio_init+0x0/0x16 @ 1
nsc_gpio initializing
initcall nsc_gpio_init+0x0/0x16 returned 0 after 3906 usecs
calling  agp_init+0x0/0x2f @ 1
Linux agpgart interface v0.103
initcall agp_init+0x0/0x2f returned 0 after 3906 usecs
calling  agp_ali_init+0x0/0x24 @ 1
initcall agp_ali_init+0x0/0x24 returned 0 after 0 usecs
calling  agp_ati_init+0x0/0x24 @ 1
initcall agp_ati_init+0x0/0x24 returned 0 after 0 usecs
calling  agp_amd64_mod_init+0x0/0xa @ 1
initcall agp_amd64_mod_init+0x0/0xa returned -19 after 0 usecs
calling  agp_efficeon_init+0x0/0x39 @ 1
initcall agp_efficeon_init+0x0/0x39 returned 0 after 0 usecs
calling  agp_intel_init+0x0/0x24 @ 1
initcall agp_intel_init+0x0/0x24 returned 0 after 0 usecs
calling  agp_nvidia_init+0x0/0x24 @ 1
initcall agp_nvidia_init+0x0/0x24 returned 0 after 0 usecs
calling  agp_sis_init+0x0/0x24 @ 1
initcall agp_sis_init+0x0/0x24 returned 0 after 0 usecs
calling  agp_serverworks_init+0x0/0x24 @ 1
initcall agp_serverworks_init+0x0/0x24 returned 0 after 0 usecs
calling  ipmi_init_msghandler_mod+0x0/0xc @ 1
ipmi message handler version 39.2
initcall ipmi_init_msghandler_mod+0x0/0xc returned 0 after 3906 usecs
calling  init_ipmi_devintf+0x0/0xf3 @ 1
ipmi device interface
initcall init_ipmi_devintf+0x0/0xf3 returned 0 after 0 usecs
calling  init_tis+0x0/0x7ec @ 1
tpm_tis tpm_tis: 1.2 TPM (device-id 0xFFFF, rev-id 255)
tpm_tis tpm_tis: Unable to request irq: 255 for use
tpm_tis tpm_tis: tpm_transmit: tpm_send: error 4294967291
tpm_tis tpm_tis: tpm_transmit: tpm_send: error 4294967291
tpm_tis tpm_tis: tpm_transmit: tpm_send: error 4294967291
initcall init_tis+0x0/0x7ec returned 0 after 19531 usecs
calling  drm_core_init+0x0/0x12b @ 1
[drm] Initialized drm 1.1.0 20060810
initcall drm_core_init+0x0/0x12b returned 0 after 0 usecs
calling  ttm_init+0x0/0x6e @ 1
initcall ttm_init+0x0/0x6e returned 0 after 0 usecs
calling  tdfx_init+0x0/0xf @ 1
initcall tdfx_init+0x0/0xf returned 0 after 0 usecs
calling  r128_init+0x0/0x19 @ 1
initcall r128_init+0x0/0x19 returned 0 after 0 usecs
calling  radeon_init+0x0/0xb4 @ 1
[drm] radeon defaulting to userspace modesetting.
IOAPIC[0]: Set routing entry (2-5 -> 0x41 -> IRQ 29 Mode:1 Active:1)
pci 0000:01:00.0: PCI->APIC IRQ transform: INT A -> IRQ 29
pci 0000:01:00.0: setting latency timer to 64
[drm] Initialized radeon 1.33.0 20080528 for 0000:01:00.0 on minor 0
initcall radeon_init+0x0/0xb4 returned 0 after 19531 usecs
calling  mga_init+0x0/0x19 @ 1
initcall mga_init+0x0/0x19 returned 0 after 0 usecs
calling  i810_init+0x0/0x19 @ 1
initcall i810_init+0x0/0x19 returned 0 after 0 usecs
calling  sis_init+0x0/0x19 @ 1
initcall sis_init+0x0/0x19 returned 0 after 0 usecs
calling  savage_init+0x0/0x19 @ 1
initcall savage_init+0x0/0x19 returned 0 after 0 usecs
calling  i810fb_init+0x0/0x35d @ 1
initcall i810fb_init+0x0/0x35d returned 0 after 0 usecs
calling  serial8250_init+0x0/0x14f @ 1
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
async_waiting @ 1
async_continuing @ 1 after 0 usec
async_waiting @ 1
async_continuing @ 1 after 0 usec
ÿserial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
initcall serial8250_init+0x0/0x14f returned 0 after 265625 usecs
calling  serial8250_pci_init+0x0/0x16 @ 1
initcall serial8250_pci_init+0x0/0x16 returned 0 after 0 usecs
calling  fourport_init+0x0/0xf @ 1
initcall fourport_init+0x0/0xf returned 0 after 3906 usecs
calling  boca_init+0x0/0xf @ 1
initcall boca_init+0x0/0xf returned 0 after 0 usecs
calling  hub6_init+0x0/0xf @ 1
initcall hub6_init+0x0/0xf returned 0 after 3906 usecs
calling  mca_init+0x0/0x1d @ 1
initcall mca_init+0x0/0x1d returned -19 after 0 usecs
calling  max3100_init+0x0/0xf @ 1
initcall max3100_init+0x0/0xf returned 0 after 0 usecs
calling  jsm_init_module+0x0/0x3a @ 1
initcall jsm_init_module+0x0/0x3a returned 0 after 0 usecs
calling  altera_jtaguart_init+0x0/0x33 @ 1
initcall altera_jtaguart_init+0x0/0x33 returned 0 after 0 usecs
calling  parport_default_proc_register+0x0/0x16 @ 1
initcall parport_default_proc_register+0x0/0x16 returned 0 after 0 usecs
calling  parport_pc_init+0x0/0x19b @ 1
parport0: PC-style at 0x378 (0x778)async_waiting @ 1
async_continuing @ 1 after 0 usec
 [PCSPP(,...)]
parport0: irq 7 detected
lp0: using parport0 (polling).
lp0: console ready
initcall parport_pc_init+0x0/0x19b returned 0 after 140625 usecs
calling  parport_serial_init+0x0/0x16 @ 1
initcall parport_serial_init+0x0/0x16 returned 0 after 0 usecs
calling  parport_ax88796_init+0x0/0xf @ 1
initcall parport_ax88796_init+0x0/0xf returned 0 after 0 usecs
calling  isa_bus_init+0x0/0x33 @ 1
initcall isa_bus_init+0x0/0x33 returned 0 after 0 usecs
calling  brd_init+0x0/0x160 @ 1
brd: module loaded
initcall brd_init+0x0/0x160 returned 0 after 3906 usecs
calling  cpqarray_init+0x0/0x277 @ 1
Compaq SMART2 Driver (v 2.6.0)
initcall cpqarray_init+0x0/0x277 returned -19 after 0 usecs
calling  cciss_init+0x0/0x8e @ 1
HP CISS Driver (v 3.6.20)
initcall cciss_init+0x0/0x8e returned 0 after 3906 usecs
calling  pkt_init+0x0/0x1c2 @ 1
initcall pkt_init+0x0/0x1c2 returned 0 after 0 usecs
calling  osdblk_init+0x0/0x9e @ 1
initcall osdblk_init+0x0/0x9e returned 0 after 0 usecs
calling  nbd_init+0x0/0x24c @ 1
nbd: registered device at major 43
initcall nbd_init+0x0/0x24c returned 0 after 7812 usecs
calling  ub_init+0x0/0x50 @ 1
usbcore: registered new interface driver ub
initcall ub_init+0x0/0x50 returned 0 after 3906 usecs
calling  drbd_init+0x0/0x31f @ 1
drbd: initialized. Version: 8.3.8rc2 (api:88/proto:86-94)
drbd: built-in
drbd: registered as block device major 147
drbd: minor_table @ 0xf664c6e0
initcall drbd_init+0x0/0x31f returned 0 after 15625 usecs
calling  ibmasm_init+0x0/0x66 @ 1
ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
initcall ibmasm_init+0x0/0x66 returned 0 after 3906 usecs
calling  ad_dpot_i2c_init+0x0/0x11 @ 1
i2c-core: driver [ad_dpot] registered
initcall ad_dpot_i2c_init+0x0/0x11 returned 0 after 3906 usecs
calling  ad_dpot_spi_init+0x0/0xf @ 1
initcall ad_dpot_spi_init+0x0/0xf returned 0 after 0 usecs
calling  ioc4_init+0x0/0x16 @ 1
initcall ioc4_init+0x0/0x16 returned 0 after 0 usecs
calling  enclosure_init+0x0/0x14 @ 1
initcall enclosure_init+0x0/0x14 returned 0 after 0 usecs
calling  cs5535_mfgpt_init+0x0/0x1d4 @ 1
initcall cs5535_mfgpt_init+0x0/0x1d4 returned -19 after 0 usecs
calling  ilo_init+0x0/0x82 @ 1
initcall ilo_init+0x0/0x82 returned 0 after 0 usecs
calling  tsl2550_init+0x0/0x11 @ 1
i2c-core: driver [tsl2550] registered
initcall tsl2550_init+0x0/0x11 returned 0 after 3906 usecs
calling  dac7512_init+0x0/0xf @ 1
initcall dac7512_init+0x0/0xf returned 0 after 0 usecs
calling  c2port_init+0x0/0x4a @ 1
Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Giometti
initcall c2port_init+0x0/0x4a returned 0 after 3906 usecs
calling  duramar2150_c2port_init+0x0/0x6a @ 1
c2port c2port0: C2 port uc added
c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 bytes total)
initcall duramar2150_c2port_init+0x0/0x6a returned 0 after 3906 usecs
calling  iwmct_init+0x0/0x3c @ 1
initcall iwmct_init+0x0/0x3c returned 0 after 0 usecs
calling  at24_init+0x0/0x2b @ 1
i2c-core: driver [at24] registered
initcall at24_init+0x0/0x2b returned 0 after 3906 usecs
calling  at25_init+0x0/0xf @ 1
initcall at25_init+0x0/0xf returned 0 after 0 usecs
calling  eeprom_init+0x0/0x11 @ 1
i2c-core: driver [eeprom] registered
initcall eeprom_init+0x0/0x11 returned 0 after 3906 usecs
calling  max6875_init+0x0/0x11 @ 1
i2c-core: driver [max6875] registered
initcall max6875_init+0x0/0x11 returned 0 after 3906 usecs
calling  cb710_init_module+0x0/0x16 @ 1
initcall cb710_init_module+0x0/0x16 returned 0 after 0 usecs
calling  lpc_sch_init+0x0/0x16 @ 1
initcall lpc_sch_init+0x0/0x16 returned 0 after 0 usecs
calling  rdc321x_sb_init+0x0/0x16 @ 1
initcall rdc321x_sb_init+0x0/0x16 returned 0 after 0 usecs
calling  mac_hid_init+0x0/0x1c @ 1
initcall mac_hid_init+0x0/0x1c returned 0 after 0 usecs
calling  scsi_tgt_init+0x0/0x8d @ 1
initcall scsi_tgt_init+0x0/0x8d returned 0 after 0 usecs
calling  raid_init+0x0/0xf @ 1
initcall raid_init+0x0/0xf returned 0 after 0 usecs
calling  spi_transport_init+0x0/0x75 @ 1
initcall spi_transport_init+0x0/0x75 returned 0 after 0 usecs
calling  fc_transport_init+0x0/0x71 @ 1
initcall fc_transport_init+0x0/0x71 returned 0 after 0 usecs
calling  sas_transport_init+0x0/0x9f @ 1
initcall sas_transport_init+0x0/0x9f returned 0 after 0 usecs
calling  sas_class_init+0x0/0x35 @ 1
initcall sas_class_init+0x0/0x35 returned 0 after 0 usecs
calling  scsi_dh_init+0x0/0x37 @ 1
initcall scsi_dh_init+0x0/0x37 returned 0 after 0 usecs
calling  rdac_init+0x0/0x74 @ 1
rdac: device handler registered
initcall rdac_init+0x0/0x74 returned 0 after 3906 usecs
calling  hp_sw_init+0x0/0xf @ 1
hp_sw: device handler registered
initcall hp_sw_init+0x0/0xf returned 0 after 3906 usecs
calling  clariion_init+0x0/0x32 @ 1
emc: device handler registered
initcall clariion_init+0x0/0x32 returned 0 after 0 usecs
calling  alua_init+0x0/0x32 @ 1
alua: device handler registered
initcall alua_init+0x0/0x32 returned 0 after 3906 usecs
calling  ahc_linux_init+0x0/0x61 @ 1
initcall ahc_linux_init+0x0/0x61 returned 0 after 0 usecs
calling  init_st+0x0/0x175 @ 1
st: Version 20081215, fixed bufsize 32768, s/g segs 256
initcall init_st+0x0/0x175 returned 0 after 3906 usecs
calling  init_osst+0x0/0x135 @ 1
osst :I: Tape driver with OnStream support version 0.99.4
osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
initcall init_osst+0x0/0x135 returned 0 after 3906 usecs
calling  init_sd+0x0/0x12b @ 1
initcall init_sd+0x0/0x12b returned 0 after 0 usecs
calling  init_sr+0x0/0x3d @ 1
initcall init_sr+0x0/0x3d returned 0 after 0 usecs
calling  init_sg+0x0/0x10f @ 1
initcall init_sg+0x0/0x10f returned 0 after 0 usecs
calling  init_ch_module+0x0/0xab @ 1
SCSI Media Changer driver v0.25 
initcall init_ch_module+0x0/0xab returned 0 after 0 usecs
calling  ses_init+0x0/0x33 @ 1
initcall ses_init+0x0/0x33 returned 0 after 0 usecs
calling  osd_uld_init+0x0/0xbf @ 1
osd: LOADED open-osd 0.2.0
initcall osd_uld_init+0x0/0xbf returned 0 after 3906 usecs
calling  ahci_init+0x0/0x16 @ 1
initcall ahci_init+0x0/0x16 returned 0 after 0 usecs
calling  ahci_init+0x0/0x14 @ 1
initcall ahci_init+0x0/0x14 returned -19 after 0 usecs
calling  inic_init+0x0/0x16 @ 1
initcall inic_init+0x0/0x16 returned 0 after 0 usecs
calling  sil24_init+0x0/0x16 @ 1
initcall sil24_init+0x0/0x16 returned 0 after 0 usecs
calling  qs_ata_init+0x0/0x16 @ 1
initcall qs_ata_init+0x0/0x16 returned 0 after 0 usecs
calling  piix_init+0x0/0x24 @ 1
initcall piix_init+0x0/0x24 returned 0 after 0 usecs
calling  mv_init+0x0/0x3a @ 1
initcall mv_init+0x0/0x3a returned 0 after 0 usecs
calling  nv_init+0x0/0x16 @ 1
initcall nv_init+0x0/0x16 returned 0 after 0 usecs
calling  pdc_ata_init+0x0/0x16 @ 1
initcall pdc_ata_init+0x0/0x16 returned 0 after 0 usecs
calling  sil_init+0x0/0x16 @ 1
initcall sil_init+0x0/0x16 returned 0 after 0 usecs
calling  sis_init+0x0/0x16 @ 1
initcall sis_init+0x0/0x16 returned 0 after 0 usecs
calling  k2_sata_init+0x0/0x16 @ 1
initcall k2_sata_init+0x0/0x16 returned 0 after 0 usecs
calling  uli_init+0x0/0x16 @ 1
initcall uli_init+0x0/0x16 returned 0 after 0 usecs
calling  svia_init+0x0/0x16 @ 1
initcall svia_init+0x0/0x16 returned 0 after 0 usecs
calling  vsc_sata_init+0x0/0x16 @ 1
initcall vsc_sata_init+0x0/0x16 returned 0 after 0 usecs
calling  amd_init+0x0/0x16 @ 1
pata_amd 0000:00:06.0: version 0.4.1
pata_amd 0000:00:06.0: setting latency timer to 64
scsi0 : pata_amd
scsi1 : pata_amd
ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xf000 irq 14
ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xf008 irq 15
initcall amd_init+0x0/0x16 returned 0 after 19531 usecs
calling  artop_init+0x0/0x16 @ 1
initcall artop_init+0x0/0x16 returned 0 after 0 usecs
calling  atp867x_init+0x0/0x16 @ 1
initcall atp867x_init+0x0/0x16 returned 0 after 0 usecs
calling  cmd64x_init+0x0/0x16 @ 1
initcall cmd64x_init+0x0/0x16 returned 0 after 0 usecs
calling  cs5520_init+0x0/0x16 @ 1
initcall cs5520_init+0x0/0x16 returned 0 after 0 usecs
calling  cs5530_init+0x0/0x16 @ 1
initcall cs5530_init+0x0/0x16 returned 0 after 0 usecs
calling  cs5535_init+0x0/0x16 @ 1
initcall cs5535_init+0x0/0x16 returned 0 after 0 usecs
calling  cs5536_init+0x0/0x16 @ 1
initcall cs5536_init+0x0/0x16 returned 0 after 0 usecs
calling  cy82c693_init+0x0/0x16 @ 1
initcall cy82c693_init+0x0/0x16 returned 0 after 0 usecs
calling  efar_init+0x0/0x16 @ 1
initcall efar_init+0x0/0x16 returned 0 after 0 usecs
calling  hpt36x_init+0x0/0x16 @ 1
initcall hpt36x_init+0x0/0x16 returned 0 after 0 usecs
calling  hpt3x2n_init+0x0/0x16 @ 1
initcall hpt3x2n_init+0x0/0x16 returned 0 after 0 usecs
calling  hpt3x3_init+0x0/0x16 @ 1
initcall hpt3x3_init+0x0/0x16 returned 0 after 0 usecs
calling  it8213_init+0x0/0x16 @ 1
initcall it8213_init+0x0/0x16 returned 0 after 0 usecs
calling  it821x_init+0x0/0x16 @ 1
initcall it821x_init+0x0/0x16 returned 0 after 0 usecs
calling  netcell_init+0x0/0x16 @ 1
initcall netcell_init+0x0/0x16 returned 0 after 0 usecs
calling  ninja32_init+0x0/0x16 @ 1
initcall ninja32_init+0x0/0x16 returned 0 after 0 usecs
calling  ns87415_init+0x0/0x16 @ 1
initcall ns87415_init+0x0/0x16 returned 0 after 0 usecs
calling  oldpiix_init+0x0/0x16 @ 1
initcall oldpiix_init+0x0/0x16 returned 0 after 0 usecs
calling  pdc2027x_init+0x0/0x16 @ 1
initcall pdc2027x_init+0x0/0x16 returned 0 after 0 usecs
calling  pdc202xx_init+0x0/0x16 @ 1
initcall pdc202xx_init+0x0/0x16 returned 0 after 0 usecs
calling  radisys_init+0x0/0x16 @ 1
initcall radisys_init+0x0/0x16 returned 0 after 0 usecs
calling  sch_init+0x0/0x16 @ 1
initcall sch_init+0x0/0x16 returned 0 after 0 usecs
calling  sil680_init+0x0/0x16 @ 1
initcall sil680_init+0x0/0x16 returned 0 after 0 usecs
calling  sis_init+0x0/0x16 @ 1
initcall sis_init+0x0/0x16 returned 0 after 0 usecs
calling  ata_tosh_init+0x0/0x16 @ 1
initcall ata_tosh_init+0x0/0x16 returned 0 after 0 usecs
calling  triflex_init+0x0/0x16 @ 1
initcall triflex_init+0x0/0x16 returned 0 after 0 usecs
calling  via_init+0x0/0x16 @ 1
initcall via_init+0x0/0x16 returned 0 after 0 usecs
calling  cmd640_init+0x0/0x16 @ 1
initcall cmd640_init+0x0/0x16 returned 0 after 0 usecs
calling  ns87410_init+0x0/0x16 @ 1
initcall ns87410_init+0x0/0x16 returned 0 after 0 usecs
calling  opti_init+0x0/0x16 @ 1
initcall opti_init+0x0/0x16 returned 0 after 0 usecs
calling  qdi_init+0x0/0x1ff @ 1
initcall qdi_init+0x0/0x1ff returned -19 after 0 usecs
calling  rz1000_init+0x0/0x16 @ 1
initcall rz1000_init+0x0/0x16 returned 0 after 0 usecs
calling  winbond_init+0x0/0x2b1 @ 1
initcall winbond_init+0x0/0x2b1 returned -19 after 0 usecs
calling  legacy_init+0x0/0x8ac @ 1
initcall legacy_init+0x0/0x8ac returned -19 after 0 usecs
calling  butterfly_init+0x0/0xf @ 1
calling  1_async_port_probe+0x0/0xd0 @ 86
calling  2_async_port_probe+0x0/0xd0 @ 87
async_waiting @ 87
parport0: AVR Butterfly
initcall butterfly_init+0x0/0xf returned 0 after 113281 usecs
calling  spi_gpio_init+0x0/0x14 @ 1
initcall spi_gpio_init+0x0/0x14 returned -19 after 0 usecs
calling  init_spi_lm70llp+0x0/0xf @ 1
parport0: cannot grant exclusive access for device spi-lm70llp
spi-lm70llp: spi_lm70llp probe fail, status -12
initcall init_spi_lm70llp+0x0/0xf returned 0 after 7812 usecs
calling  xilinx_spi_pltfm_init+0x0/0xf @ 1
initcall xilinx_spi_pltfm_init+0x0/0xf returned 0 after 0 usecs
calling  spidev_init+0x0/0xa5 @ 1
initcall spidev_init+0x0/0xa5 returned 0 after 0 usecs
calling  tle62x0_init+0x0/0xf @ 1
initcall tle62x0_init+0x0/0xf returned 0 after 0 usecs
calling  marvell_init+0x0/0x49 @ 1
initcall marvell_init+0x0/0x49 returned 0 after 0 usecs
calling  lxt_init+0x0/0x4d @ 1
initcall lxt_init+0x0/0x4d returned 0 after 0 usecs
calling  qs6612_init+0x0/0xf @ 1
initcall qs6612_init+0x0/0xf returned 0 after 0 usecs
calling  smsc_init+0x0/0x81 @ 1
initcall smsc_init+0x0/0x81 returned 0 after 0 usecs
calling  broadcom_init+0x0/0x117 @ 1
initcall broadcom_init+0x0/0x117 returned 0 after 0 usecs
calling  ip175c_init+0x0/0xf @ 1
initcall ip175c_init+0x0/0xf returned 0 after 0 usecs
calling  realtek_init+0x0/0xf @ 1
initcall realtek_init+0x0/0xf returned 0 after 0 usecs
calling  et1011c_init+0x0/0xf @ 1
initcall et1011c_init+0x0/0xf returned 0 after 0 usecs
calling  ns_init+0x0/0xf @ 1
initcall ns_init+0x0/0xf returned 0 after 0 usecs
calling  ksphy_init+0x0/0x4d @ 1
initcall ksphy_init+0x0/0x4d returned 0 after 0 usecs
calling  e1000_init_module+0x0/0x80 @ 1
e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k6-NAPI
e1000: Copyright (c) 1999-2006 Intel Corporation.
initcall e1000_init_module+0x0/0x80 returned 0 after 7812 usecs
calling  e1000_init_module+0x0/0x39 @ 1
e1000e: Intel(R) PRO/1000 Network Driver - 1.0.2-k4
e1000e: Copyright (c) 1999 - 2009 Intel Corporation.
initcall e1000_init_module+0x0/0x39 returned 0 after 11718 usecs
calling  igb_init_module+0x0/0x49 @ 1
Intel(R) Gigabit Ethernet Network Driver - version 2.1.0-k2
Copyright (c) 2007-2009 Intel Corporation.
initcall igb_init_module+0x0/0x49 returned 0 after 7812 usecs
calling  igbvf_init_module+0x0/0x64 @ 1
Intel(R) Virtual Function Network Driver - version 1.0.0-k0
Copyright (c) 2009 Intel Corporation.
initcall igbvf_init_module+0x0/0x64 returned 0 after 7812 usecs
calling  can_dev_init+0x0/0x29 @ 1
CAN device driver interface
initcall can_dev_init+0x0/0x29 returned 0 after 0 usecs
calling  ems_usb_init+0x0/0x41 @ 1
CPC-USB kernel driver loaded
usbcore: registered new interface driver ems_usb
initcall ems_usb_init+0x0/0x41 returned 0 after 7812 usecs
calling  sja1000_init+0x0/0x1e @ 1
sja1000 CAN netdevice driver
initcall sja1000_init+0x0/0x1e returned 0 after 3906 usecs
calling  sp_init+0x0/0xf @ 1
initcall sp_init+0x0/0xf returned 0 after 0 usecs
calling  kvaser_pci_init+0x0/0x16 @ 1
initcall kvaser_pci_init+0x0/0x16 returned 0 after 0 usecs
calling  plx_pci_init+0x0/0x16 @ 1
initcall plx_pci_init+0x0/0x16 returned 0 after 0 usecs
calling  mcp251x_can_init+0x0/0xf @ 1
initcall mcp251x_can_init+0x0/0xf returned 0 after 0 usecs
calling  bonding_init+0x0/0x844 @ 1
bonding: Ethernet Channel Bonding Driver: v3.6.0 (September 26, 2009)
bonding: Warning: either miimon or arp_interval and arp_ip_target module parameters must be specified, otherwise bonding will not detect link failures! see bonding.txt for details.
initcall bonding_init+0x0/0x844 returned 0 after 7812 usecs
calling  atl2_init_module+0x0/0x49 @ 1
Atheros(R) L2 Ethernet Driver - version 2.2.3
Copyright (c) 2007 Atheros Corporation.
initcall atl2_init_module+0x0/0x49 returned 0 after 7812 usecs
calling  atl1e_init_module+0x0/0x16 @ 1
initcall atl1e_init_module+0x0/0x16 returned 0 after 0 usecs
calling  atl1c_init_module+0x0/0x16 @ 1
initcall atl1c_init_module+0x0/0x16 returned 0 after 0 usecs
calling  jme_init_module+0x0/0x2d @ 1
jme: JMicron JMC2XX ethernet driver version 1.0.6
initcall jme_init_module+0x0/0x2d returned 0 after 3906 usecs
calling  gem_init+0x0/0x16 @ 1
initcall gem_init+0x0/0x16 returned 0 after 0 usecs
calling  vortex_init+0x0/0xc7 @ 1
initcall vortex_init+0x0/0xc7 returned 0 after 0 usecs
calling  ne2k_pci_init+0x0/0x16 @ 1
initcall ne2k_pci_init+0x0/0x16 returned 0 after 0 usecs
calling  pcnet32_init_module+0x0/0x112 @ 1
pcnet32: pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.de
initcall pcnet32_init_module+0x0/0x112 returned 0 after 3906 usecs
calling  e100_init_module+0x0/0x5a @ 1
e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
initcall e100_init_module+0x0/0x5a returned 0 after 7812 usecs
calling  tlan_probe+0x0/0x297 @ 1
ThunderLAN driver v1.15a
TLAN: 0 devices installed, PCI: 0  EISA: 0
initcall tlan_probe+0x0/0x297 returned -19 after 7812 usecs
calling  smsc9420_init_module+0x0/0x36 @ 1
initcall smsc9420_init_module+0x0/0x36 returned 0 after 0 usecs
calling  sis190_init_module+0x0/0x16 @ 1
initcall sis190_init_module+0x0/0x16 returned 0 after 0 usecs
calling  sis900_init_module+0x0/0x16 @ 1
initcall sis900_init_module+0x0/0x16 returned 0 after 0 usecs
calling  fealnx_init+0x0/0x16 @ 1
initcall fealnx_init+0x0/0x16 returned 0 after 0 usecs
calling  tg3_init+0x0/0x16 @ 1
initcall tg3_init+0x0/0x16 returned 0 after 0 usecs
calling  bnx2_init+0x0/0x16 @ 1
initcall bnx2_init+0x0/0x16 returned 0 after 0 usecs
calling  skge_init_module+0x0/0x4d @ 1
initcall skge_init_module+0x0/0x4d returned 0 after 0 usecs
calling  sky2_init_module+0x0/0x25 @ 1
sky2: driver version 1.28
initcall sky2_init_module+0x0/0x25 returned 0 after 3906 usecs
calling  ks8842_init+0x0/0xf @ 1
initcall ks8842_init+0x0/0xf returned 0 after 0 usecs
calling  ks8851_init+0x0/0xf @ 1
initcall ks8851_init+0x0/0xf returned 0 after 0 usecs
calling  ksz884x_init_module+0x0/0x16 @ 1
initcall ksz884x_init_module+0x0/0x16 returned 0 after 0 usecs
calling  rhine_init+0x0/0x64 @ 1
initcall rhine_init+0x0/0x64 returned 0 after 0 usecs
calling  velocity_init_module+0x0/0x16 @ 1
initcall velocity_init_module+0x0/0x16 returned 0 after 0 usecs
calling  sundance_init+0x0/0x16 @ 1
initcall sundance_init+0x0/0x16 returned 0 after 0 usecs
calling  hamachi_init+0x0/0x16 @ 1
initcall hamachi_init+0x0/0x16 returned 0 after 0 usecs
calling  net_olddevs_init+0x0/0x91 @ 1
cs89x0:cs89x0_probe(0x0)
PP_addr at 300[a]: 0xffff
eth0: incorrect signature at 300[c]: 0xffff!=0x630E
cs89x0: request_region(0x320, 0x10) failed
PP_addr at 340[a]: 0xffff
eth0: incorrect signature at 340[c]: 0xffff!=0x630E
PP_addr at 360[a]: 0xffff
eth0: incorrect signature at 360[c]: 0xffff!=0x630E
PP_addr at 200[a]: 0xffff
eth0: incorrect signature at 200[c]: 0xffff!=0x630E
PP_addr at 220[a]: 0xffff
eth0: incorrect signature at 220[c]: 0xffff!=0x630E
PP_addr at 240[a]: 0xffff
eth0: incorrect signature at 240[c]: 0xffff!=0x630E
PP_addr at 260[a]: 0xffff
eth0: incorrect signature at 260[c]: 0xffff!=0x630E
PP_addr at 280[a]: 0xffff
eth0: incorrect signature at 280[c]: 0xffff!=0x630E
PP_addr at 2a0[a]: 0xffff
eth0: incorrect signature at 2a0[c]: 0xffff!=0x630E
PP_addr at 2c0[a]: 0xffff
eth0: incorrect signature at 2c0[c]: 0xffff!=0x630E
PP_addr at 2e0[a]: 0xffff
eth0: incorrect signature at 2e0[c]: 0xffff!=0x630E
cs89x0: no cs8900 or cs8920 detected.  Be sure to disable PnP with SETUP
initcall net_olddevs_init+0x0/0x91 returned 0 after 70312 usecs
calling  hp100_module_init+0x0/0x46 @ 1
initcall hp100_module_init+0x0/0x46 returned 0 after 0 usecs
calling  NS8390p_init_module+0x0/0x7 @ 1
initcall NS8390p_init_module+0x0/0x7 returned 0 after 0 usecs
calling  ne3210_init+0x0/0x20 @ 1
initcall ne3210_init+0x0/0x20 returned 0 after 0 usecs
calling  init_nic+0x0/0x16 @ 1
forcedeth: Reverse Engineered nForce ethernet driver. Version 0.64.
IOAPIC[0]: Set routing entry (2-11 -> 0x49 -> IRQ 35 Mode:1 Active:1)
forcedeth 0000:00:0a.0: PCI->APIC IRQ transform: INT A -> IRQ 35
forcedeth 0000:00:0a.0: setting latency timer to 64
nv_probe: set workaround bit for reversed mac addr
ata1.00: ATA-6: HDS722525VLAT80, V36OA60A, max UDMA/100
ata1.00: 488397168 sectors, multi 1: LBA48 
ata1: nv_mode_filter: 0x3f39f&0x3f3ff->0x3f39f, BIOS=0x3f000 (0xc60000c0) ACPI=0x0
ata1.00: configured for UDMA/100
async_waiting @ 86
async_continuing @ 86 after 0 usec
scsi 0:0:0:0: Direct-Access     ATA      HDS722525VLAT80  V36O PQ: 0 ANSI: 5
sd 0:0:0:0: Attached scsi generic sg0 type 0
initcall 1_async_port_probe+0x0/0xd0 returned 0 after 742187 usecs
calling  3_sd_probe_async+0x0/0x1f0 @ 86
async_continuing @ 87 after 746093 usec
sd 0:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 < sda5 sda6 sda7 sda8 sda9 sda10 >
sd 0:0:0:0: [sda] Attached SCSI disk
initcall 3_sd_probe_async+0x0/0x1f0 returned 0 after 105468 usecs
ata2.01: ATAPI: DVDRW IDE 16X, VER A079, max UDMA/66
ata2: nv_mode_filter: 0x1f39f&0x73ff->0x739f, BIOS=0x7000 (0xc60000c0) ACPI=0x0
ata2.01: configured for UDMA/33
async_waiting @ 87
async_continuing @ 87 after 0 usec
scsi 1:0:1:0: CD-ROM            DVDRW    IDE 16X          A079 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 1x/48x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 1:0:1:0: Attached scsi CD-ROM sr0
sr 1:0:1:0: Attached scsi generic sg1 type 5
initcall 2_async_port_probe+0x0/0xd0 returned 0 after 968750 usecs
forcedeth 0000:00:0a.0: ifname eth0, PHY OUI 0x5043 @ 1, addr 00:13:d4:dc:41:12
forcedeth 0000:00:0a.0: highdma csum gbit lnktim desc-v3
initcall init_nic+0x0/0x16 returned 0 after 539062 usecs
calling  ql3xxx_init_module+0x0/0x16 @ 1
initcall ql3xxx_init_module+0x0/0x16 returned 0 after 0 usecs
calling  ppp_init+0x0/0xe3 @ 1
PPP generic driver version 2.4.2
initcall ppp_init+0x0/0xe3 returned 0 after 3906 usecs
calling  ppp_async_init+0x0/0x33 @ 1
initcall ppp_async_init+0x0/0x33 returned 0 after 0 usecs
calling  ppp_sync_init+0x0/0x33 @ 1
initcall ppp_sync_init+0x0/0x33 returned 0 after 0 usecs
calling  bsdcomp_init+0x0/0x29 @ 1
PPP BSD Compression module registered
initcall bsdcomp_init+0x0/0x29 returned 0 after 3906 usecs
calling  ppp_mppe_init+0x0/0x127 @ 1
PPP MPPE Compression module registered
initcall ppp_mppe_init+0x0/0x127 returned 0 after 3906 usecs
calling  slip_init+0x0/0x9c @ 1
SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=256) (6 bit encapsulation enabled).
initcall slip_init+0x0/0x9c returned 0 after 3906 usecs
calling  dummy_init_module+0x0/0x9f @ 1
initcall dummy_init_module+0x0/0x9f returned 0 after 0 usecs
calling  macvlan_init_module+0x0/0x45 @ 1
initcall macvlan_init_module+0x0/0x45 returned 0 after 0 usecs
calling  macvtap_init+0x0/0xc0 @ 1
initcall macvtap_init+0x0/0xc0 returned 0 after 0 usecs
calling  dfx_init+0x0/0x29 @ 1
initcall dfx_init+0x0/0x29 returned 0 after 0 usecs
calling  ibmlana_init_module+0x0/0xf @ 1
initcall ibmlana_init_module+0x0/0xf returned 0 after 0 usecs
calling  rtl8139_init_module+0x0/0x16 @ 1
8139too: 8139too Fast Ethernet driver 0.9.28
8139too 0000:05:07.0: PCI->APIC IRQ transform: INT A -> IRQ 35
8139too 0000:05:07.0: eth1: RealTek RTL8139 at 0xc000, 00:c0:df:03:68:5d, IRQ 35
initcall rtl8139_init_module+0x0/0x16 returned 0 after 15625 usecs
calling  depca_module_init+0x0/0xdd @ 1
initcall depca_module_init+0x0/0xdd returned 0 after 0 usecs
calling  sc92031_init+0x0/0x16 @ 1
initcall sc92031_init+0x0/0x16 returned 0 after 0 usecs
calling  eql_init_module+0x0/0x57 @ 1
Equalizer2002: Simon Janes (simon@ncm.com) and David S. Miller (davem@redhat.com)
initcall eql_init_module+0x0/0x57 returned 0 after 3906 usecs
calling  tun_init+0x0/0x8b @ 1
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
initcall tun_init+0x0/0x8b returned 0 after 7812 usecs
calling  rio_init+0x0/0x16 @ 1
initcall rio_init+0x0/0x16 returned 0 after 0 usecs
calling  rtl8169_init_module+0x0/0x16 @ 1
initcall rtl8169_init_module+0x0/0x16 returned 0 after 0 usecs
calling  amd8111e_init+0x0/0x16 @ 1
initcall amd8111e_init+0x0/0x16 returned 0 after 0 usecs
calling  enc28j60_init+0x0/0x1e @ 1
initcall enc28j60_init+0x0/0x1e returned 0 after 0 usecs
calling  hdlc_module_init+0x0/0x3d @ 1
HDLC support module revision 1.22
initcall hdlc_module_init+0x0/0x3d returned 0 after 0 usecs
calling  mod_init+0x0/0x11 @ 1
initcall mod_init+0x0/0x11 returned 0 after 0 usecs
calling  mod_init+0x0/0x11 @ 1
initcall mod_init+0x0/0x11 returned 0 after 0 usecs
calling  mod_init+0x0/0x11 @ 1
initcall mod_init+0x0/0x11 returned 0 after 0 usecs
calling  mod_init+0x0/0x2f @ 1
initcall mod_init+0x0/0x2f returned 0 after 0 usecs
calling  fst_init+0x0/0x29 @ 1
initcall fst_init+0x0/0x29 returned 0 after 0 usecs
calling  init_lmc+0x0/0x16 @ 1
initcall init_lmc+0x0/0x16 returned 0 after 0 usecs
calling  init_dlci+0x0/0x32 @ 1
DLCI driver v0.35, 4 Jan 1997, mike.mclagan@linux.org.
initcall init_dlci+0x0/0x32 returned 0 after 3906 usecs
calling  n2_init+0x0/0x9ed @ 1
initcall n2_init+0x0/0x9ed returned -22 after 0 usecs
initcall n2_init+0x0/0x9ed returned with error code -22 
calling  c101_init+0x0/0x646 @ 1
initcall c101_init+0x0/0x646 returned -22 after 0 usecs
initcall c101_init+0x0/0x646 returned with error code -22 
calling  wanxl_init_module+0x0/0x16 @ 1
initcall wanxl_init_module+0x0/0x16 returned 0 after 0 usecs
calling  arcnet_init+0x0/0x54 @ 1
arcnet loaded.
initcall arcnet_init+0x0/0x54 returned 0 after 3906 usecs
calling  arcnet_rfc1201_init+0x0/0x69 @ 1
arcnet: RFC1201 "standard" (`a') encapsulation support loaded.
initcall arcnet_rfc1201_init+0x0/0x69 returned 0 after 3906 usecs
calling  arcnet_rfc1051_init+0x0/0x41 @ 1
arcnet: RFC1051 "simple standard" (`s') encapsulation support loaded.
initcall arcnet_rfc1051_init+0x0/0x41 returned 0 after 3906 usecs
calling  arcnet_raw_init+0x0/0x56 @ 1
arcnet: raw mode (`r') encapsulation support loaded.
initcall arcnet_raw_init+0x0/0x56 returned 0 after 3906 usecs
calling  com90io_init+0x0/0x486 @ 1
arcnet: COM90xx IO-mapped mode support (by David Woodhouse et el.)
E-mail me if you actually test this driver, please!
 arc%d: No autoprobe for IO mapped cards; you must specify the base address!
initcall com90io_init+0x0/0x486 returned -19 after 11718 usecs
calling  arc_rimi_init+0x0/0x472 @ 1
arcnet: RIM I (entirely mem-mapped) support
E-mail me if you actually test the RIM I driver, please!
 arc%d: Given: node 00h, shmem 0h, irq 0
 arc%d: No autoprobe for RIM I; you must specify the shmem and irq!
initcall arc_rimi_init+0x0/0x472 returned -5 after 15625 usecs
initcall arc_rimi_init+0x0/0x472 returned with error code -5 
calling  com20020_init+0x0/0x296 @ 1
arcnet: COM20020 ISA support (by David Woodhouse et al.)
 arc%d: No autoprobe (yet) for IO mapped cards; you must specify the base address!
initcall com20020_init+0x0/0x296 returned -5 after 7812 usecs
initcall com20020_init+0x0/0x296 returned with error code -5 
calling  com20020pci_init+0x0/0x2e @ 1
arcnet: COM20020 PCI support
initcall com20020pci_init+0x0/0x2e returned 0 after 0 usecs
calling  catc_init+0x0/0x30 @ 1
usbcore: registered new interface driver catc
catc: v2.8:CATC EL1210A NetMate USB Ethernet driver
initcall catc_init+0x0/0x30 returned 0 after 7812 usecs
calling  kaweth_init+0x0/0x16 @ 1
usbcore: registered new interface driver kaweth
initcall kaweth_init+0x0/0x16 returned 0 after 3906 usecs
calling  pegasus_init+0x0/0x137 @ 1
pegasus: v0.6.14 (2006/09/27), Pegasus/Pegasus II USB Ethernet driver
usbcore: registered new interface driver pegasus
initcall pegasus_init+0x0/0x137 returned 0 after 7812 usecs
calling  hso_init+0x0/0x14a @ 1
hso: drivers/net/usb/hso.c: 1.2 Option Wireless
usbcore: registered new interface driver hso
initcall hso_init+0x0/0x14a returned 0 after 7812 usecs
calling  cdc_init+0x0/0x16 @ 1
usbcore: registered new interface driver cdc_ether
initcall cdc_init+0x0/0x16 returned 0 after 3906 usecs
calling  dm9601_init+0x0/0x16 @ 1
usbcore: registered new interface driver dm9601
initcall dm9601_init+0x0/0x16 returned 0 after 3906 usecs
calling  smsc95xx_init+0x0/0x16 @ 1
usbcore: registered new interface driver smsc95xx
initcall smsc95xx_init+0x0/0x16 returned 0 after 3906 usecs
calling  rndis_init+0x0/0x16 @ 1
usbcore: registered new interface driver rndis_host
initcall rndis_init+0x0/0x16 returned 0 after 3906 usecs
calling  cdc_subset_init+0x0/0x16 @ 1
usbcore: registered new interface driver cdc_subset
initcall cdc_subset_init+0x0/0x16 returned 0 after 3906 usecs
calling  zaurus_init+0x0/0x16 @ 1
usbcore: registered new interface driver zaurus
initcall zaurus_init+0x0/0x16 returned 0 after 3906 usecs
calling  mcs7830_init+0x0/0x16 @ 1
usbcore: registered new interface driver MOSCHIP usb-ethernet driver
initcall mcs7830_init+0x0/0x16 returned 0 after 3906 usecs
calling  usbnet_init+0x0/0x26 @ 1
initcall usbnet_init+0x0/0x26 returned 0 after 0 usecs
calling  int51x1_init+0x0/0x16 @ 1
usbcore: registered new interface driver int51x1
initcall int51x1_init+0x0/0x16 returned 0 after 3906 usecs
calling  ipheth_init+0x0/0x35 @ 1
usbcore: registered new interface driver ipheth
initcall ipheth_init+0x0/0x35 returned 0 after 3906 usecs
calling  sierra_net_init+0x0/0x16 @ 1
usbcore: registered new interface driver sierra_net
initcall sierra_net_init+0x0/0x16 returned 0 after 3906 usecs
calling  ipw2100_init+0x0/0x68 @ 1
ipw2100: Intel(R) PRO/Wireless 2100 Network Driver, git-1.2.2
ipw2100: Copyright(c) 2003-2006 Intel Corporation
initcall ipw2100_init+0x0/0x68 returned 0 after 7812 usecs
calling  libipw_init+0x0/0x9d @ 1
libipw: 802.11 data/management/control stack, git-1.1.13
libipw: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
initcall libipw_init+0x0/0x9d returned 0 after 7812 usecs
calling  atmel_init_module+0x0/0x16 @ 1
initcall atmel_init_module+0x0/0x16 returned 0 after 0 usecs
calling  at76_mod_init+0x0/0x64 @ 1
Atmel at76x USB Wireless LAN Driver 0.17 loading
usbcore: registered new interface driver at76c50x-usb
initcall at76_mod_init+0x0/0x64 returned 0 after 7812 usecs
calling  prism54_module_init+0x0/0x35 @ 1
Loaded prism54 driver, version 1.2
initcall prism54_module_init+0x0/0x35 returned 0 after 3906 usecs
calling  hostap_init+0x0/0x3f @ 1
initcall hostap_init+0x0/0x3f returned 0 after 0 usecs
calling  init_prism2_pci+0x0/0x16 @ 1
initcall init_prism2_pci+0x0/0x16 returned 0 after 0 usecs
calling  b43legacy_init+0x0/0x59 @ 1
Broadcom 43xx-legacy driver loaded [ Features: PLI, Firmware-ID: FW10 ]
initcall b43legacy_init+0x0/0x59 returned 0 after 3906 usecs
calling  rtl8180_init+0x0/0x16 @ 1
initcall rtl8180_init+0x0/0x16 returned 0 after 0 usecs
calling  rtl8187_init+0x0/0x16 @ 1
usbcore: registered new interface driver rtl8187
initcall rtl8187_init+0x0/0x16 returned 0 after 3906 usecs
calling  rndis_wlan_init+0x0/0x16 @ 1
usbcore: registered new interface driver rndis_wlan
initcall rndis_wlan_init+0x0/0x16 returned 0 after 3906 usecs
calling  zd1201_init+0x0/0x16 @ 1
usbcore: registered new interface driver zd1201
initcall zd1201_init+0x0/0x16 returned 0 after 3906 usecs
calling  lbs_init_module+0x0/0xbf @ 1
initcall lbs_init_module+0x0/0xbf returned 0 after 0 usecs
calling  if_usb_init_module+0x0/0xa6 @ 1
usbcore: registered new interface driver usb8xxx
initcall if_usb_init_module+0x0/0xa6 returned 0 after 3906 usecs
calling  if_sdio_init_module+0x0/0xc6 @ 1
libertas_sdio: Libertas SDIO driver
libertas_sdio: Copyright Pierre Ossman
initcall if_sdio_init_module+0x0/0xc6 returned 0 after 3906 usecs
calling  adm8211_init+0x0/0x16 @ 1
initcall adm8211_init+0x0/0x16 returned 0 after 0 usecs
calling  mwl8k_init+0x0/0x16 @ 1
initcall mwl8k_init+0x0/0x16 returned 0 after 0 usecs
calling  p54u_init+0x0/0x16 @ 1
usbcore: registered new interface driver p54usb
initcall p54u_init+0x0/0x16 returned 0 after 3906 usecs
calling  p54p_init+0x0/0x16 @ 1
initcall p54p_init+0x0/0x16 returned 0 after 0 usecs
calling  init_ath5k_pci+0x0/0x30 @ 1
initcall init_ath5k_pci+0x0/0x30 returned 0 after 0 usecs
calling  ath9k_init+0x0/0x6c @ 1
initcall ath9k_init+0x0/0x6c returned 0 after 0 usecs
calling  ath9k_init+0x0/0x7 @ 1
initcall ath9k_init+0x0/0x7 returned 0 after 0 usecs
calling  ath9k_cmn_init+0x0/0x7 @ 1
initcall ath9k_cmn_init+0x0/0x7 returned 0 after 0 usecs
calling  ath9k_htc_init+0x0/0x4c @ 1
usbcore: registered new interface driver ath9k_hif_usb
initcall ath9k_htc_init+0x0/0x4c returned 0 after 3906 usecs
calling  init_mac80211_hwsim+0x0/0x642 @ 1
mac80211_hwsim: Initializing radio 0
phy0: Selected rate control algorithm 'minstrel'
phy0: hwaddr 02:00:00:00:00:00 registered
mac80211_hwsim: Initializing radio 1
phy1: Selected rate control algorithm 'minstrel'
phy1: hwaddr 02:00:00:00:01:00 registered
initcall init_mac80211_hwsim+0x0/0x642 returned 0 after 27343 usecs
calling  dmfe_init_module+0x0/0xe4 @ 1
dmfe: Davicom DM9xxx net driver, version 1.36.4 (2002-01-17)
initcall dmfe_init_module+0x0/0xe4 returned 0 after 3906 usecs
calling  tulip_init+0x0/0x2a @ 1
initcall tulip_init+0x0/0x2a returned 0 after 0 usecs
calling  de4x5_module_init+0x0/0x26 @ 1
initcall de4x5_module_init+0x0/0x26 returned 0 after 0 usecs
calling  init_netconsole+0x0/0x1e8 @ 1
console [netcon0] enabled
netconsole: network logging started
initcall init_netconsole+0x0/0x1e8 returned 0 after 3906 usecs
calling  i2400m_driver_init+0x0/0x19 @ 1
initcall i2400m_driver_init+0x0/0x19 returned 0 after 0 usecs
calling  i2400ms_driver_init+0x0/0x19 @ 1
initcall i2400ms_driver_init+0x0/0x19 returned 0 after 0 usecs
calling  zatm_init_module+0x0/0x16 @ 1
initcall zatm_init_module+0x0/0x16 returned 0 after 0 usecs
calling  uPD98402_module_init+0x0/0x7 @ 1
initcall uPD98402_module_init+0x0/0x7 returned 0 after 0 usecs
calling  nicstar_init+0x0/0x5b @ 1
initcall nicstar_init+0x0/0x5b returned 0 after 0 usecs
calling  amb_module_init+0x0/0x12b @ 1
Madge ATM Ambassador driver version 1.2.4
initcall amb_module_init+0x0/0x12b returned 0 after 3906 usecs
calling  fore200e_module_init+0x0/0x25 @ 1
fore200e: FORE Systems 200E-series ATM driver - version 0.3e
initcall fore200e_module_init+0x0/0x25 returned 0 after 3906 usecs
calling  eni_init+0x0/0x16 @ 1
initcall eni_init+0x0/0x16 returned 0 after 0 usecs
calling  atmtcp_init+0x0/0x11 @ 1
initcall atmtcp_init+0x0/0x11 returned 0 after 0 usecs
calling  firestream_init_module+0x0/0x16 @ 1
initcall firestream_init_module+0x0/0x16 returned 0 after 0 usecs
calling  lanai_module_init+0x0/0x30 @ 1
initcall lanai_module_init+0x0/0x30 returned 0 after 0 usecs
calling  he_init+0x0/0x16 @ 1
initcall he_init+0x0/0x16 returned 0 after 0 usecs
calling  i2o_iop_init+0x0/0x45 @ 1
I2O subsystem v1.325
i2o: max drivers = 8
initcall i2o_iop_init+0x0/0x45 returned 0 after 3906 usecs
calling  i2o_config_init+0x0/0x3f @ 1
I2O Configuration OSM v1.323
initcall i2o_config_init+0x0/0x3f returned 0 after 3906 usecs
calling  i2o_bus_init+0x0/0x3e @ 1
I2O Bus Adapter OSM v1.317
initcall i2o_bus_init+0x0/0x3e returned 0 after 3906 usecs
calling  i2o_scsi_init+0x0/0x3e @ 1
I2O SCSI Peripheral OSM v1.316
initcall i2o_scsi_init+0x0/0x3e returned 0 after 0 usecs
calling  fusion_init+0x0/0x113 @ 1
Fusion MPT base driver 3.04.15
Copyright (c) 1999-2008 LSI Corporation
initcall fusion_init+0x0/0x113 returned 0 after 7812 usecs
calling  mptspi_init+0x0/0xc2 @ 1
Fusion MPT SPI Host driver 3.04.15
initcall mptspi_init+0x0/0xc2 returned 0 after 3906 usecs
calling  mptfc_init+0x0/0xd5 @ 1
Fusion MPT FC Host driver 3.04.15
initcall mptfc_init+0x0/0xd5 returned 0 after 3906 usecs
calling  mptctl_init+0x0/0x13d @ 1
Fusion MPT misc device (ioctl) driver 3.04.15
mptctl: Registered with Fusion MPT base driver
mptctl: /dev/mptctl @ (major,minor=10,220)
initcall mptctl_init+0x0/0x13d returned 0 after 11718 usecs
calling  mpt_lan_init+0x0/0x84 @ 1
Fusion MPT LAN driver 3.04.15
initcall mpt_lan_init+0x0/0x84 returned 0 after 3906 usecs
calling  fw_core_init+0x0/0x81 @ 1
initcall fw_core_init+0x0/0x81 returned 0 after 0 usecs
calling  fw_ohci_init+0x0/0x16 @ 1
initcall fw_ohci_init+0x0/0x16 returned 0 after 0 usecs
calling  sbp2_init+0x0/0x4a @ 1
initcall sbp2_init+0x0/0x4a returned 0 after 0 usecs
calling  ohci1394_init+0x0/0x16 @ 1
initcall ohci1394_init+0x0/0x16 returned 0 after 0 usecs
calling  video1394_init_module+0x0/0xac @ 1
video1394: Installed video1394 module
initcall video1394_init_module+0x0/0xac returned 0 after 3906 usecs
calling  init_raw1394+0x0/0xec @ 1
ieee1394: raw1394: /dev/raw1394 device initialized
initcall init_raw1394+0x0/0xec returned 0 after 3906 usecs
calling  ether1394_init_module+0x0/0x6c @ 1
initcall ether1394_init_module+0x0/0x6c returned 0 after 0 usecs
calling  cdrom_init+0x0/0x5b @ 1
initcall cdrom_init+0x0/0x5b returned 0 after 0 usecs
calling  aoe_init+0x0/0xa4 @ 1
aoe: AoE v47 initialised.
initcall aoe_init+0x0/0xa4 returned 0 after 0 usecs
calling  uwb_subsys_init+0x0/0x49 @ 1
initcall uwb_subsys_init+0x0/0x49 returned 0 after 0 usecs
calling  umc_bus_init+0x0/0xf @ 1
initcall umc_bus_init+0x0/0xf returned 0 after 0 usecs
calling  whci_init+0x0/0x16 @ 1
initcall whci_init+0x0/0x16 returned 0 after 3906 usecs
calling  whcrc_driver_init+0x0/0x16 @ 1
initcall whcrc_driver_init+0x0/0x16 returned 0 after 0 usecs
calling  hwarc_driver_init+0x0/0x16 @ 1
usbcore: registered new interface driver hwa-rc
initcall hwarc_driver_init+0x0/0x16 returned 0 after 3906 usecs
calling  i1480_dfu_driver_init+0x0/0x16 @ 1
usbcore: registered new interface driver i1480-dfu-usb
initcall i1480_dfu_driver_init+0x0/0x16 returned 0 after 3906 usecs
calling  i1480_est_init+0x0/0x94 @ 1
initcall i1480_est_init+0x0/0x94 returned 0 after 0 usecs
calling  mon_init+0x0/0xdf @ 1
initcall mon_init+0x0/0xdf returned 0 after 0 usecs
calling  ehci_hcd_init+0x0/0xdc @ 1
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd: block sizes: qh 60 qtd 96 itd 160 sitd 96
ehci_hcd 0000:00:02.1: can't find IRQ for PCI INT B; probably buggy MP table
ehci_hcd 0000:00:02.1: Found HC with no IRQ.  Check BIOS/PCI 0000:00:02.1 setup!
ehci_hcd 0000:00:02.1: init 0000:00:02.1 fail, -19
initcall ehci_hcd_init+0x0/0xdc returned 0 after 19531 usecs
calling  oxu_module_init+0x0/0xf @ 1
initcall oxu_module_init+0x0/0xf returned 0 after 0 usecs
calling  isp116x_init+0x0/0x3e @ 1
116x: driver isp116x-hcd, 03 Nov 2005
initcall isp116x_init+0x0/0x3e returned 0 after 3906 usecs
calling  ohci_hcd_mod_init+0x0/0xad @ 1
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ohci_hcd: block sizes: ed 64 td 64
ohci_hcd 0000:00:02.0: can't find IRQ for PCI INT A; probably buggy MP table
ohci_hcd 0000:00:02.0: Found HC with no IRQ.  Check BIOS/PCI 0000:00:02.0 setup!
ohci_hcd 0000:00:02.0: init 0000:00:02.0 fail, -19
initcall ohci_hcd_mod_init+0x0/0xad returned 0 after 15625 usecs
calling  uhci_hcd_init+0x0/0x129 @ 1
uhci_hcd: USB Universal Host Controller Interface driver
initcall uhci_hcd_init+0x0/0x129 returned 0 after 7812 usecs
calling  xhci_hcd_init+0x0/0x28 @ 1
initcall xhci_hcd_init+0x0/0x28 returned 0 after 0 usecs
calling  sl811h_init+0x0/0x3e @ 1
sl811: driver sl811-hcd, 19 May 2005
initcall sl811h_init+0x0/0x3e returned 0 after 3906 usecs
calling  r8a66597_init+0x0/0x3e @ 1
r8a66597_hcd: driver r8a66597_hcd, 2009-05-26
initcall r8a66597_init+0x0/0x3e returned 0 after 3906 usecs
calling  hwahc_driver_init+0x0/0x16 @ 1
usbcore: registered new interface driver hwa-hc
initcall hwahc_driver_init+0x0/0x16 returned 0 after 3906 usecs
calling  wusbcore_init+0x0/0x77 @ 1
initcall wusbcore_init+0x0/0x77 returned 0 after 0 usecs
calling  cbaf_driver_init+0x0/0x16 @ 1
usbcore: registered new interface driver wusb-cbaf
initcall cbaf_driver_init+0x0/0x16 returned 0 after 3906 usecs
calling  usblp_init+0x0/0x16 @ 1
usbcore: registered new interface driver usblp
initcall usblp_init+0x0/0x16 returned 0 after 3906 usecs
calling  usbtmc_init+0x0/0x30 @ 1
usbcore: registered new interface driver usbtmc
initcall usbtmc_init+0x0/0x30 returned 0 after 3906 usecs
calling  usb_stor_init+0x0/0x46 @ 1
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
initcall usb_stor_init+0x0/0x46 returned 0 after 11718 usecs
calling  usb_usual_init+0x0/0x30 @ 1
usbcore: registered new interface driver libusual
initcall usb_usual_init+0x0/0x30 returned 0 after 3906 usecs
calling  alauda_init+0x0/0x16 @ 1
usbcore: registered new interface driver ums-alauda
initcall alauda_init+0x0/0x16 returned 0 after 3906 usecs
calling  datafab_init+0x0/0x16 @ 1
usbcore: registered new interface driver ums-datafab
initcall datafab_init+0x0/0x16 returned 0 after 3906 usecs
calling  freecom_init+0x0/0x16 @ 1
usbcore: registered new interface driver ums-freecom
initcall freecom_init+0x0/0x16 returned 0 after 3906 usecs
calling  jumpshot_init+0x0/0x16 @ 1
usbcore: registered new interface driver ums-jumpshot
initcall jumpshot_init+0x0/0x16 returned 0 after 3906 usecs
calling  karma_init+0x0/0x16 @ 1
usbcore: registered new interface driver ums-karma
initcall karma_init+0x0/0x16 returned 0 after 3906 usecs
calling  sddr09_init+0x0/0x16 @ 1
usbcore: registered new interface driver ums-sddr09
initcall sddr09_init+0x0/0x16 returned 0 after 3906 usecs
calling  usbat_init+0x0/0x16 @ 1
usbcore: registered new interface driver ums-usbat
initcall usbat_init+0x0/0x16 returned 0 after 3906 usecs
calling  usb_mdc800_init+0x0/0x27f @ 1
usbcore: registered new interface driver mdc800
mdc800: v0.7.5 (30/10/2000):USB Driver for Mustek MDC800 Digital Camera
initcall usb_mdc800_init+0x0/0x27f returned 0 after 7812 usecs
calling  microtek_drv_init+0x0/0x16 @ 1
usbcore: registered new interface driver microtekX6
initcall microtek_drv_init+0x0/0x16 returned 0 after 3906 usecs
calling  appledisplay_init+0x0/0x5d @ 1
usbcore: registered new interface driver appledisplay
initcall appledisplay_init+0x0/0x5d returned 0 after 3906 usecs
calling  usb_cytherm_init+0x0/0x43 @ 1
usbcore: registered new interface driver cytherm
cytherm: v1.0:Cypress USB Thermometer driver
initcall usb_cytherm_init+0x0/0x43 returned 0 after 7812 usecs
calling  emi26_init+0x0/0x16 @ 1
usbcore: registered new interface driver emi26 - firmware loader
initcall emi26_init+0x0/0x16 returned 0 after 3906 usecs
calling  emi62_init+0x0/0x30 @ 1
usbcore: registered new interface driver emi62 - firmware loader
initcall emi62_init+0x0/0x30 returned 0 after 3906 usecs
calling  isight_firmware_init+0x0/0x16 @ 1
usbcore: registered new interface driver isight_firmware
initcall isight_firmware_init+0x0/0x16 returned 0 after 7812 usecs
calling  usb_led_init+0x0/0x35 @ 1
usbcore: registered new interface driver usbled
initcall usb_led_init+0x0/0x35 returned 0 after 3906 usecs
calling  lego_usb_tower_init+0x0/0x9d @ 1
drivers/usb/misc/legousbtower.c: lego_usb_tower_init: enter
usbcore: registered new interface driver legousbtower
legousbtower: v0.96:LEGO USB Tower Driver
drivers/usb/misc/legousbtower.c: lego_usb_tower_init: leave, return value 0
initcall lego_usb_tower_init+0x0/0x9d returned 0 after 15625 usecs
calling  usb_rio_init+0x0/0x30 @ 1
usbcore: registered new interface driver rio500
rio500: v1.1:USB Rio 500 driver
initcall usb_rio_init+0x0/0x30 returned 0 after 3906 usecs
calling  usbtest_init+0x0/0x42 @ 1
usbcore: registered new interface driver usbtest
initcall usbtest_init+0x0/0x42 returned 0 after 3906 usecs
calling  uss720_init+0x0/0x54 @ 1
usbcore: registered new interface driver uss720
uss720: v0.6:USB Parport Cable driver for Cables using the Lucent Technologies USS720 Chip
uss720: NOTE: this is a special purpose driver to allow nonstandard
uss720: protocols (eg. bitbang) over USS720 usb to parallel cables
uss720: If you just want to connect to a printer, use usblp instead
initcall uss720_init+0x0/0x54 returned 0 after 19531 usecs
calling  usb_sevseg_init+0x0/0x35 @ 1
usbcore: registered new interface driver usbsevseg
initcall usb_sevseg_init+0x0/0x35 returned 0 after 3906 usecs
calling  i8042_init+0x0/0xd2 @ 1
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
initcall i8042_init+0x0/0xd2 returned 0 after 7812 usecs
calling  parkbd_init+0x0/0x1ae @ 1
parport0: cannot grant exclusive access for device parkbd
initcall parkbd_init+0x0/0x1ae returned -19 after 3906 usecs
calling  ct82c710_init+0x0/0x167 @ 1
initcall ct82c710_init+0x0/0x167 returned -19 after 0 usecs
calling  pcips2_init+0x0/0x16 @ 1
initcall pcips2_init+0x0/0x16 returned 0 after 0 usecs
calling  serio_raw_init+0x0/0x16 @ 1
initcall serio_raw_init+0x0/0x16 returned 0 after 0 usecs
calling  altera_ps2_init+0x0/0xf @ 1
initcall altera_ps2_init+0x0/0xf returned 0 after 0 usecs
calling  emu_init+0x0/0x16 @ 1
initcall emu_init+0x0/0x16 returned 0 after 0 usecs
calling  fm801_gp_init+0x0/0x16 @ 1
initcall fm801_gp_init+0x0/0x16 returned 0 after 0 usecs
calling  l4_init+0x0/0x2ec @ 1
initcall l4_init+0x0/0x2ec returned -19 after 0 usecs
calling  ns558_init+0x0/0x37c @ 1
initcall ns558_init+0x0/0x37c returned -19 after 7812 usecs
calling  mousedev_init+0x0/0x7f @ 1
mice: PS/2 mouse device common for all mice
initcall mousedev_init+0x0/0x7f returned 0 after 3906 usecs
calling  joydev_init+0x0/0xf @ 1
initcall joydev_init+0x0/0xf returned 0 after 0 usecs
calling  evdev_init+0x0/0xf @ 1
initcall evdev_init+0x0/0xf returned 0 after 0 usecs
calling  evbug_init+0x0/0xf @ 1
initcall evbug_init+0x0/0xf returned 0 after 0 usecs
calling  atkbd_init+0x0/0x20 @ 1
initcall atkbd_init+0x0/0x20 returned 0 after 0 usecs
calling  gpio_keys_init+0x0/0xf @ 1
initcall gpio_keys_init+0x0/0xf returned 0 after 0 usecs
calling  lkkbd_init+0x0/0x16 @ 1
initcall lkkbd_init+0x0/0x16 returned 0 after 0 usecs
calling  lm8323_init+0x0/0x11 @ 1
i2c-core: driver [lm8323] registered
initcall lm8323_init+0x0/0x11 returned 0 after 3906 usecs
calling  nkbd_init+0x0/0x16 @ 1
initcall nkbd_init+0x0/0x16 returned 0 after 0 usecs
calling  opencores_kbd_init+0x0/0xf @ 1
initcall opencores_kbd_init+0x0/0xf returned 0 after 0 usecs
calling  skbd_init+0x0/0x16 @ 1
initcall skbd_init+0x0/0x16 returned 0 after 0 usecs
calling  sunkbd_init+0x0/0x16 @ 1
initcall sunkbd_init+0x0/0x16 returned 0 after 0 usecs
calling  xtkbd_init+0x0/0x16 @ 1
initcall xtkbd_init+0x0/0x16 returned 0 after 0 usecs
calling  atp_init+0x0/0x16 @ 1
usbcore: registered new interface driver appletouch
initcall atp_init+0x0/0x16 returned 0 after 3906 usecs
calling  bcm5974_init+0x0/0x16 @ 1
usbcore: registered new interface driver bcm5974
initcall bcm5974_init+0x0/0x16 returned 0 after 3906 usecs
calling  inport_init+0x0/0x131 @ 1
inport.c: Didn't find InPort mouse at 0x23c
initcall inport_init+0x0/0x131 returned -19 after 3906 usecs
calling  logibm_init+0x0/0x139 @ 1
logibm.c: Didn't find Logitech busmouse at 0x23c
initcall logibm_init+0x0/0x139 returned -19 after 3906 usecs
calling  psmouse_init+0x0/0x7e @ 1
initcall psmouse_init+0x0/0x7e returned 0 after 0 usecs
calling  sermouse_init+0x0/0x16 @ 1
initcall sermouse_init+0x0/0x16 returned 0 after 0 usecs
calling  vsxxxaa_init+0x0/0x16 @ 1
initcall vsxxxaa_init+0x0/0x16 returned 0 after 0 usecs
calling  a3d_init+0x0/0x16 @ 1
initcall a3d_init+0x0/0x16 returned 0 after 0 usecs
calling  adi_init+0x0/0x16 @ 1
initcall adi_init+0x0/0x16 returned 0 after 0 usecs
calling  analog_init+0x0/0xd3 @ 1
initcall analog_init+0x0/0xd3 returned 0 after 0 usecs
calling  gc_init+0x0/0x63d @ 1
initcall gc_init+0x0/0x63d returned -19 after 0 usecs
calling  grip_init+0x0/0x16 @ 1
initcall grip_init+0x0/0x16 returned 0 after 0 usecs
calling  grip_init+0x0/0x16 @ 1
initcall grip_init+0x0/0x16 returned 0 after 0 usecs
calling  guillemot_init+0x0/0x16 @ 1
initcall guillemot_init+0x0/0x16 returned 0 after 0 usecs
calling  interact_init+0x0/0x16 @ 1
initcall interact_init+0x0/0x16 returned 0 after 0 usecs
calling  joydump_init+0x0/0x16 @ 1
initcall joydump_init+0x0/0x16 returned 0 after 0 usecs
calling  magellan_init+0x0/0x16 @ 1
initcall magellan_init+0x0/0x16 returned 0 after 0 usecs
calling  sw_init+0x0/0x16 @ 1
initcall sw_init+0x0/0x16 returned 0 after 0 usecs
calling  spaceball_init+0x0/0x16 @ 1
initcall spaceball_init+0x0/0x16 returned 0 after 0 usecs
calling  spaceorb_init+0x0/0x16 @ 1
initcall spaceorb_init+0x0/0x16 returned 0 after 0 usecs
calling  stinger_init+0x0/0x16 @ 1
initcall stinger_init+0x0/0x16 returned 0 after 0 usecs
calling  tmdc_init+0x0/0x16 @ 1
initcall tmdc_init+0x0/0x16 returned 0 after 0 usecs
calling  tgfx_init+0x0/0x3fd @ 1
initcall tgfx_init+0x0/0x3fd returned -19 after 0 usecs
calling  warrior_init+0x0/0x16 @ 1
initcall warrior_init+0x0/0x16 returned 0 after 0 usecs
calling  usb_xpad_init+0x0/0x30 @ 1
usbcore: registered new interface driver xpad
xpad: X-Box pad driver
initcall usb_xpad_init+0x0/0x30 returned 0 after 3906 usecs
calling  zhenhua_init+0x0/0x16 @ 1
initcall zhenhua_init+0x0/0x16 returned 0 after 0 usecs
calling  walkera0701_init+0x0/0x1fa @ 1
walkera0701: parport without interrupt
initcall walkera0701_init+0x0/0x1fa returned -19 after 3906 usecs
calling  usb_acecad_init+0x0/0x30 @ 1
usbcore: registered new interface driver usb_acecad
acecad: v3.2:USB Acecad Flair tablet driver
initcall usb_acecad_init+0x0/0x30 returned 0 after 7812 usecs
calling  gtco_init+0x0/0x4b @ 1
usbcore: registered new interface driver gtco
GTCO usb driver version: 2.00.0006initcall gtco_init+0x0/0x4b returned 0 after 7812 usecs
calling  wacom_init+0x0/0x30 @ 1
usbcore: registered new interface driver wacom
wacom: v1.52:USB Wacom tablet driver
initcall wacom_init+0x0/0x30 returned 0 after 3906 usecs
calling  ad7877_init+0x0/0xf @ 1
initcall ad7877_init+0x0/0xf returned 0 after 0 usecs
calling  ad7879_init+0x0/0x11 @ 1
i2c-core: driver [ad7879] registered
initcall ad7879_init+0x0/0x11 returned 0 after 3906 usecs
calling  ads7846_init+0x0/0xf @ 1
initcall ads7846_init+0x0/0xf returned 0 after 0 usecs
calling  dynapro_init+0x0/0x16 @ 1
initcall dynapro_init+0x0/0x16 returned 0 after 0 usecs
calling  hampshire_init+0x0/0x16 @ 1
initcall hampshire_init+0x0/0x16 returned 0 after 0 usecs
calling  gunze_init+0x0/0x16 @ 1
initcall gunze_init+0x0/0x16 returned 0 after 0 usecs
calling  elo_init+0x0/0x16 @ 1
initcall elo_init+0x0/0x16 returned 0 after 0 usecs
calling  fujitsu_init+0x0/0x16 @ 1
initcall fujitsu_init+0x0/0x16 returned 0 after 0 usecs
calling  mcs5000_ts_init+0x0/0x11 @ 1
i2c-core: driver [mcs5000_ts] registered
initcall mcs5000_ts_init+0x0/0x11 returned 0 after 3906 usecs
calling  mk712_init+0x0/0x1cc @ 1
mk712: device not present
initcall mk712_init+0x0/0x1cc returned -19 after 3906 usecs
calling  htcpen_isa_init+0x0/0x29 @ 1
initcall htcpen_isa_init+0x0/0x29 returned -19 after 0 usecs
calling  usbtouch_init+0x0/0x16 @ 1
usbcore: registered new interface driver usbtouchscreen
initcall usbtouch_init+0x0/0x16 returned 0 after 3906 usecs
calling  pm_init+0x0/0x16 @ 1
initcall pm_init+0x0/0x16 returned 0 after 0 usecs
calling  touchit213_init+0x0/0x16 @ 1
initcall touchit213_init+0x0/0x16 returned 0 after 0 usecs
calling  tr_init+0x0/0x16 @ 1
initcall tr_init+0x0/0x16 returned 0 after 0 usecs
calling  tw_init+0x0/0x16 @ 1
initcall tw_init+0x0/0x16 returned 0 after 0 usecs
calling  tsc2007_init+0x0/0x11 @ 1
i2c-core: driver [tsc2007] registered
initcall tsc2007_init+0x0/0x11 returned 0 after 3906 usecs
calling  wm97xx_init+0x0/0xf @ 1
initcall wm97xx_init+0x0/0xf returned 0 after 0 usecs
calling  tps6507x_ts_init+0x0/0xf @ 1
initcall tps6507x_ts_init+0x0/0xf returned 0 after 0 usecs
calling  ad714x_i2c_init+0x0/0x11 @ 1
i2c-core: driver [ad714x_captouch] registered
initcall ad714x_i2c_init+0x0/0x11 returned 0 after 3906 usecs
calling  ad714x_spi_init+0x0/0xf @ 1
initcall ad714x_spi_init+0x0/0xf returned 0 after 0 usecs
calling  apanel_init+0x0/0x17b @ 1
apanel: Fujitsu BIOS signature 'FJKEYINF' not found...
initcall apanel_init+0x0/0x17b returned -19 after 3906 usecs
calling  ati_remote_init+0x0/0x43 @ 1
usbcore: registered new interface driver ati_remote
ati_remote: 2.2.1:ATI/X10 RF USB Remote Control
initcall ati_remote_init+0x0/0x43 returned 0 after 7812 usecs
calling  ati_remote2_init+0x0/0x43 @ 1
usbcore: registered new interface driver ati_remote2
ati_remote2: ATI/Philips USB RF remote driver 0.3
initcall ati_remote2_init+0x0/0x43 returned 0 after 7812 usecs
calling  cm109_init+0x0/0xfc @ 1
cm109: Keymap for Komunikate KIP1000 phone loaded
usbcore: registered new interface driver cm109
cm109: CM109 phone driver: 20080805 (C) Alfred E. Heggestad
initcall cm109_init+0x0/0xfc returned 0 after 11718 usecs
calling  usb_keyspan_init+0x0/0x35 @ 1
usbcore: registered new interface driver keyspan_remote
initcall usb_keyspan_init+0x0/0x35 returned 0 after 3906 usecs
calling  pcf8574_kp_init+0x0/0x11 @ 1
i2c-core: driver [pcf8574_keypad] registered
initcall pcf8574_kp_init+0x0/0x11 returned 0 after 3906 usecs
calling  powermate_init+0x0/0x16 @ 1
usbcore: registered new interface driver powermate
initcall powermate_init+0x0/0x16 returned 0 after 3906 usecs
calling  rotary_encoder_init+0x0/0xf @ 1
initcall rotary_encoder_init+0x0/0xf returned 0 after 0 usecs
calling  uinput_init+0x0/0xf @ 1
initcall uinput_init+0x0/0xf returned 0 after 0 usecs
calling  yealink_dev_init+0x0/0x30 @ 1
usbcore: registered new interface driver yealink
yealink: yld-20051230:Yealink phone driver
initcall yealink_dev_init+0x0/0x30 returned 0 after 7812 usecs
calling  i2c_smbus_init+0x0/0x11 @ 1
i2c-core: driver [smbus_alert] registered
initcall i2c_smbus_init+0x0/0x11 returned 0 after 3906 usecs
calling  i2c_dev_init+0x0/0xa7 @ 1
i2c /dev entries driver
i2c-core: driver [dev_driver] registered
initcall i2c_dev_init+0x0/0xa7 returned 0 after 3906 usecs
calling  i2c_ali1535_init+0x0/0x16 @ 1
initcall i2c_ali1535_init+0x0/0x16 returned 0 after 0 usecs
calling  ali1563_init+0x0/0x16 @ 1
initcall ali1563_init+0x0/0x16 returned 0 after 0 usecs
calling  amd756_init+0x0/0x16 @ 1
initcall amd756_init+0x0/0x16 returned 0 after 0 usecs
calling  i2c_amd8111_init+0x0/0x16 @ 1
initcall i2c_amd8111_init+0x0/0x16 returned 0 after 0 usecs
calling  i2c_i801_init+0x0/0x82 @ 1
initcall i2c_i801_init+0x0/0x82 returned 0 after 0 usecs
calling  i2c_sch_init+0x0/0xf @ 1
initcall i2c_sch_init+0x0/0xf returned 0 after 0 usecs
calling  nforce2_init+0x0/0x16 @ 1
i2c i2c-0: adapter [SMBus nForce2 adapter at 4c00] registered
i2c i2c-0: found normal entry for adapter 0, addr 0x50
i2c i2c-0: Creating eeprom at 0x50
i2c 0-0050: uevent
eeprom 0-0050: probe
i2c i2c-0: client [eeprom] registered with bus id 0-0050
i2c i2c-0: found normal entry for adapter 0, addr 0x51
i2c i2c-0: Creating eeprom at 0x51
i2c 0-0051: uevent
eeprom 0-0051: probe
i2c i2c-0: client [eeprom] registered with bus id 0-0051
i2c i2c-0: found normal entry for adapter 0, addr 0x52
input: AT Translated Set 2 keyboard as /class/input/input0
evbug.c: Connected device: input0 (AT Translated Set 2 keyboard at isa0060/serio0/input0)
i2c i2c-0: found normal entry for adapter 0, addr 0x53
i2c i2c-0: found normal entry for adapter 0, addr 0x54
i2c i2c-0: found normal entry for adapter 0, addr 0x55
i2c i2c-0: found normal entry for adapter 0, addr 0x56
i2c i2c-0: found normal entry for adapter 0, addr 0x57
i2c-dev: adapter [SMBus nForce2 adapter at 4c00] registered as minor 0
i2c i2c-0: nForce2 SMBus adapter at 0x4c00
i2c i2c-1: adapter [SMBus nForce2 adapter at 4c40] registered
i2c i2c-1: found normal entry for adapter 1, addr 0x50
i2c i2c-1: found normal entry for adapter 1, addr 0x51
i2c i2c-1: found normal entry for adapter 1, addr 0x52
i2c i2c-1: found normal entry for adapter 1, addr 0x53
i2c i2c-1: found normal entry for adapter 1, addr 0x54
i2c i2c-1: found normal entry for adapter 1, addr 0x55
i2c i2c-1: found normal entry for adapter 1, addr 0x56
i2c i2c-1: found normal entry for adapter 1, addr 0x57
i2c-dev: adapter [SMBus nForce2 adapter at 4c40] registered as minor 1
i2c i2c-1: nForce2 SMBus adapter at 0x4c40
initcall nforce2_init+0x0/0x16 returned 0 after 226562 usecs
calling  i2c_sis5595_init+0x0/0x16 @ 1
initcall i2c_sis5595_init+0x0/0x16 returned 0 after 0 usecs
calling  i2c_sis96x_init+0x0/0x16 @ 1
initcall i2c_sis96x_init+0x0/0x16 returned 0 after 0 usecs
calling  ocores_i2c_init+0x0/0xf @ 1
initcall ocores_i2c_init+0x0/0xf returned 0 after 0 usecs
calling  i2c_parport_init+0x0/0x4a @ 1
i2c-parport: adapter type unspecified
initcall i2c_parport_init+0x0/0x4a returned -19 after 3906 usecs
calling  i2c_parport_init+0x0/0x159 @ 1
i2c-parport-light: adapter type unspecified
initcall i2c_parport_init+0x0/0x159 returned -19 after 3906 usecs
calling  usb_i2c_tiny_usb_init+0x0/0x16 @ 1
usbcore: registered new interface driver i2c-tiny-usb
initcall usb_i2c_tiny_usb_init+0x0/0x16 returned 0 after 3906 usecs
calling  i2c_pcfisa_init+0x0/0x14 @ 1
initcall i2c_pcfisa_init+0x0/0x14 returned 0 after 0 usecs
calling  scx200_acb_init+0x0/0x22c @ 1
initcall scx200_acb_init+0x0/0x22c returned -19 after 0 usecs
calling  init_rc_map_adstech_dvb_t_pci+0x0/0xf @ 1
initcall init_rc_map_adstech_dvb_t_pci+0x0/0xf returned 0 after 0 usecs
calling  init_rc_map_apac_viewcomp+0x0/0xf @ 1
initcall init_rc_map_apac_viewcomp+0x0/0xf returned 0 after 0 usecs
calling  init_rc_map_asus_pc39+0x0/0xf @ 1
initcall init_rc_map_asus_pc39+0x0/0xf returned 0 after 0 usecs
calling  init_rc_map_ati_tv_wonder_hd_600+0x0/0xf @ 1
initcall init_rc_map_ati_tv_wonder_hd_600+0x0/0xf returned 0 after 0 usecs
calling  init_rc_map_avermedia_a16d+0x0/0xf @ 1
initcall init_rc_map_avermedia_a16d+0x0/0xf returned 0 after 0 usecs
calling  init_rc_map_avermedia+0x0/0xf @ 1
initcall init_rc_map_avermedia+0x0/0xf returned 0 after 0 usecs
calling  init_rc_map_avermedia_cardbus+0x0/0xf @ 1
initcall init_rc_map_avermedia_cardbus+0x0/0xf returned 0 after 0 usecs
calling  init_rc_map_avermedia_dvbt+0x0/0xf @ 1
initcall init_rc_map_avermedia_dvbt+0x0/0xf returned 0 after 0 usecs
calling  init_rc_map_avermedia_m135a+0x0/0xf @ 1
initcall init_rc_map_avermedia_m135a+0x0/0xf returned 0 after 0 usecs
calling  init_rc_map_avermedia_m733a_rm_k6+0x0/0xf @ 1
initcall init_rc_map_avermedia_m733a_rm_k6+0x0/0xf returned 0 after 0 usecs
calling  init_rc_map_avertv_303+0x0/0xf @ 1
initcall init_rc_map_avertv_303+0x0/0xf returned 0 after 0 usecs
calling  init_rc_map_behold+0x0/0xf @ 1
initcall init_rc_map_behold+0x0/0xf returned 0 after 0 usecs
calling  init_rc_map_behold_columbus+0x0/0xf @ 1
initcall init_rc_map_behold_columbus+0x0/0xf returned 0 after 0 usecs
calling  init_rc_map_budget_ci_old+0x0/0xf @ 1
initcall init_rc_map_budget_ci_old+0x0/0xf returned 0 after 0 usecs
calling  init_rc_map_cinergy_1400+0x0/0xf @ 1
initcall init_rc_map_cinergy_1400+0x0/0xf returned 0 after 0 usecs
calling  init_rc_map_cinergy+0x0/0xf @ 1
initcall init_rc_map_cinergy+0x0/0xf returned 0 after 0 usecs
calling  init_rc_map_dm1105_nec+0x0/0xf @ 1
initcall init_rc_map_dm1105_nec+0x0/0xf returned 0 after 0 usecs
calling  init_rc_map_dntv_live_dvb_t+0x0/0xf @ 1
initcall init_rc_map_dntv_live_dvb_t+0x0/0xf returned 0 after 0 usecs
calling  init_rc_map_dntv_live_dvbt_pro+0x0/0xf @ 1
initcall init_rc_map_dntv_live_dvbt_pro+0x0/0xf returned 0 after 0 usecs
calling  init_rc_map_empty+0x0/0xf @ 1
initcall init_rc_map_empty+0x0/0xf returned 0 after 0 usecs
calling  init_rc_map_em_terratec+0x0/0xf @ 1
initcall init_rc_map_em_terratec+0x0/0xf returned 0 after 0 usecs
calling  init_rc_map_encore_enltv2+0x0/0xf @ 1
initcall init_rc_map_encore_enltv2+0x0/0xf returned 0 after 0 usecs
calling  init_rc_map_encore_enltv+0x0/0xf @ 1
initcall init_rc_map_encore_enltv+0x0/0xf returned 0 after 0 usecs
calling  init_rc_map_encore_enltv_fm53+0x0/0xf @ 1
initcall init_rc_map_encore_enltv_fm53+0x0/0xf returned 0 after 0 usecs
calling  init_rc_map_evga_indtube+0x0/0xf @ 1
initcall init_rc_map_evga_indtube+0x0/0xf returned 0 after 0 usecs
calling  init_rc_map_eztv+0x0/0xf @ 1
initcall init_rc_map_eztv+0x0/0xf returned 0 after 0 usecs
calling  init_rc_map_flydvb+0x0/0xf @ 1
initcall init_rc_map_flydvb+0x0/0xf returned 0 after 0 usecs
calling  init_rc_map_flyvideo+0x0/0xf @ 1
initcall init_rc_map_flyvideo+0x0/0xf returned 0 after 0 usecs
calling  init_rc_map_fusionhdtv_mce+0x0/0xf @ 1
initcall init_rc_map_fusionhdtv_mce+0x0/0xf returned 0 after 0 usecs
calling  init_rc_map_gadmei_rm008z+0x0/0xf @ 1
initcall init_rc_map_gadmei_rm008z+0x0/0xf returned 0 after 0 usecs
calling  init_rc_map_genius_tvgo_a11mce+0x0/0xf @ 1
initcall init_rc_map_genius_tvgo_a11mce+0x0/0xf returned 0 after 0 usecs
calling  init_rc_map_gotview7135+0x0/0xf @ 1
initcall init_rc_map_gotview7135+0x0/0xf returned 0 after 0 usecs
calling  init_rc_map_hauppauge_new+0x0/0xf @ 1
initcall init_rc_map_hauppauge_new+0x0/0xf returned 0 after 0 usecs
calling  init_rc_map_imon_mce+0x0/0xf @ 1
initcall init_rc_map_imon_mce+0x0/0xf returned 0 after 0 usecs
calling  init_rc_map_imon_pad+0x0/0xf @ 1
initcall init_rc_map_imon_pad+0x0/0xf returned 0 after 0 usecs
calling  init_rc_map_iodata_bctv7e+0x0/0xf @ 1
initcall init_rc_map_iodata_bctv7e+0x0/0xf returned 0 after 0 usecs
calling  init_rc_map_kaiomy+0x0/0xf @ 1
initcall init_rc_map_kaiomy+0x0/0xf returned 0 after 0 usecs
calling  init_rc_map_kworld_315u+0x0/0xf @ 1
initcall init_rc_map_kworld_315u+0x0/0xf returned 0 after 0 usecs
calling  init_rc_map_kworld_plus_tv_analog+0x0/0xf @ 1
initcall init_rc_map_kworld_plus_tv_analog+0x0/0xf returned 0 after 0 usecs
calling  init_rc_map_manli+0x0/0xf @ 1
initcall init_rc_map_manli+0x0/0xf returned 0 after 0 usecs
calling  init_rc_map_msi_tvanywhere+0x0/0xf @ 1
initcall init_rc_map_msi_tvanywhere+0x0/0xf returned 0 after 0 usecs
calling  init_rc_map_msi_tvanywhere_plus+0x0/0xf @ 1
initcall init_rc_map_msi_tvanywhere_plus+0x0/0xf returned 0 after 0 usecs
calling  init_rc_map_nebula+0x0/0xf @ 1
initcall init_rc_map_nebula+0x0/0xf returned 0 after 0 usecs
calling  init_rc_map_nec_terratec_cinergy_xs+0x0/0xf @ 1
initcall init_rc_map_nec_terratec_cinergy_xs+0x0/0xf returned 0 after 0 usecs
calling  init_rc_map_norwood+0x0/0xf @ 1
initcall init_rc_map_norwood+0x0/0xf returned 0 after 0 usecs
calling  init_rc_map_npgtech+0x0/0xf @ 1
initcall init_rc_map_npgtech+0x0/0xf returned 0 after 0 usecs
calling  init_rc_map_pctv_sedna+0x0/0xf @ 1
initcall init_rc_map_pctv_sedna+0x0/0xf returned 0 after 0 usecs
calling  init_rc_map_pinnacle_color+0x0/0xf @ 1
initcall init_rc_map_pinnacle_color+0x0/0xf returned 0 after 0 usecs
calling  init_rc_map_pinnacle_grey+0x0/0xf @ 1
initcall init_rc_map_pinnacle_grey+0x0/0xf returned 0 after 0 usecs
calling  init_rc_map_pinnacle_pctv_hd+0x0/0xf @ 1
initcall init_rc_map_pinnacle_pctv_hd+0x0/0xf returned 0 after 0 usecs
calling  init_rc_map_pixelview+0x0/0xf @ 1
initcall init_rc_map_pixelview+0x0/0xf returned 0 after 0 usecs
calling  init_rc_map_pixelview+0x0/0xf @ 1
initcall init_rc_map_pixelview+0x0/0xf returned 0 after 0 usecs
calling  init_rc_map_pixelview_new+0x0/0xf @ 1
initcall init_rc_map_pixelview_new+0x0/0xf returned 0 after 0 usecs
calling  init_rc_map_powercolor_real_angel+0x0/0xf @ 1
initcall init_rc_map_powercolor_real_angel+0x0/0xf returned 0 after 0 usecs
calling  init_rc_map_proteus_2309+0x0/0xf @ 1
initcall init_rc_map_proteus_2309+0x0/0xf returned 0 after 0 usecs
calling  init_rc_map_purpletv+0x0/0xf @ 1
initcall init_rc_map_purpletv+0x0/0xf returned 0 after 0 usecs
calling  init_rc_map_pv951+0x0/0xf @ 1
initcall init_rc_map_pv951+0x0/0xf returned 0 after 0 usecs
calling  init_rc_map_rc5_hauppauge_new+0x0/0xf @ 1
initcall init_rc_map_rc5_hauppauge_new+0x0/0xf returned 0 after 0 usecs
calling  init_rc_map_rc5_tv+0x0/0xf @ 1
initcall init_rc_map_rc5_tv+0x0/0xf returned 0 after 0 usecs
calling  init_rc_map_real_audio_220_32_keys+0x0/0xf @ 1
initcall init_rc_map_real_audio_220_32_keys+0x0/0xf returned 0 after 0 usecs
calling  init_rc_map_tbs_nec+0x0/0xf @ 1
initcall init_rc_map_tbs_nec+0x0/0xf returned 0 after 0 usecs
calling  init_rc_map_terratec_cinergy_xs+0x0/0xf @ 1
initcall init_rc_map_terratec_cinergy_xs+0x0/0xf returned 0 after 0 usecs
calling  init_rc_map_tevii_nec+0x0/0xf @ 1
initcall init_rc_map_tevii_nec+0x0/0xf returned 0 after 0 usecs
calling  init_rc_map_tt_1500+0x0/0xf @ 1
initcall init_rc_map_tt_1500+0x0/0xf returned 0 after 0 usecs
calling  init_rc_map_videomate_s350+0x0/0xf @ 1
initcall init_rc_map_videomate_s350+0x0/0xf returned 0 after 0 usecs
calling  init_rc_map_videomate_tv_pvr+0x0/0xf @ 1
initcall init_rc_map_videomate_tv_pvr+0x0/0xf returned 0 after 0 usecs
calling  init_rc_map_winfast+0x0/0xf @ 1
initcall init_rc_map_winfast+0x0/0xf returned 0 after 0 usecs
calling  init_rc_map_winfast_usbii_deluxe+0x0/0xf @ 1
initcall init_rc_map_winfast_usbii_deluxe+0x0/0xf returned 0 after 0 usecs
calling  ir_core_init+0x0/0x35 @ 1
initcall ir_core_init+0x0/0x35 returned 0 after 0 usecs
calling  ir_nec_decode_init+0x0/0x20 @ 1
IR NEC protocol handler initialized
initcall ir_nec_decode_init+0x0/0x20 returned 0 after 0 usecs
calling  ir_rc6_decode_init+0x0/0x20 @ 1
IR RC6 protocol handler initialized
initcall ir_rc6_decode_init+0x0/0x20 returned 0 after 0 usecs
calling  ir_sony_decode_init+0x0/0x20 @ 1
IR Sony protocol handler initialized
initcall ir_sony_decode_init+0x0/0x20 returned 0 after 3906 usecs
calling  dabusb_init+0x0/0x9d @ 1
usbcore: registered new interface driver dabusb
dabusb: v1.54:DAB-USB Interface Driver for Linux (c)1999
initcall dabusb_init+0x0/0x9d returned 0 after 7812 usecs
calling  w1_init+0x0/0x97 @ 1
Driver for 1-wire Dallas network protocol.
initcall w1_init+0x0/0x97 returned 0 after 3906 usecs
calling  matrox_w1_init+0x0/0x16 @ 1
initcall matrox_w1_init+0x0/0x16 returned 0 after 0 usecs
calling  ds_init+0x0/0x40 @ 1
usbcore: registered new interface driver DS9490R
initcall ds_init+0x0/0x40 returned 0 after 3906 usecs
calling  sensors_ds2482_init+0x0/0x11 @ 1
i2c-core: driver [ds2482] registered
initcall sensors_ds2482_init+0x0/0x11 returned 0 after 3906 usecs
calling  w1_therm_init+0x0/0x29 @ 1
initcall w1_therm_init+0x0/0x29 returned 0 after 0 usecs
calling  w1_smem_init+0x0/0x33 @ 1
initcall w1_smem_init+0x0/0x33 returned 0 after 0 usecs
calling  w1_f2d_init+0x0/0xf @ 1
initcall w1_f2d_init+0x0/0xf returned 0 after 0 usecs
calling  w1_f23_init+0x0/0xf @ 1
initcall w1_f23_init+0x0/0xf returned 0 after 0 usecs
calling  w1_ds2760_init+0x0/0x28 @ 1
1-Wire driver for the DS2760 battery monitor  chip  - (c) 2004-2005, Szabolcs Gyurko
initcall w1_ds2760_init+0x0/0x28 returned 0 after 3906 usecs
calling  w1_bq27000_init+0x0/0x1d @ 1
initcall w1_bq27000_init+0x0/0x1d returned -17 after 0 usecs
initcall w1_bq27000_init+0x0/0x1d returned with error code -17 
calling  test_power_init+0x0/0x64 @ 1
power_supply test_ac: uevent
power_supply test_ac: POWER_SUPPLY_NAME=test_ac
power_supply test_ac: prop ONLINE=1
power_supply test_ac: power_supply_changed
power_supply test_battery: uevent
power_supply test_battery: POWER_SUPPLY_NAME=test_battery
power_supply test_battery: prop STATUS=Charging
power_supply test_battery: prop CHARGE_TYPE=Fast
power_supply test_battery: prop HEALTH=Good
power_supply test_battery: prop TECHNOLOGY=Li-ion
test_power_get_battery_property: some properties deliberately report errors.
power_supply test_battery: driver failed to report `charge_full' property
power_supply test_battery: power_supply_changed
initcall test_power_init+0x0/0x64 returned 0 after 46875 usecs
calling  ds278x_init+0x0/0x11 @ 1
i2c-core: driver [ds2782-battery] registered
initcall ds278x_init+0x0/0x11 returned 0 after 3906 usecs
calling  wm97xx_bat_init+0x0/0xf @ 1
initcall wm97xx_bat_init+0x0/0xf returned 0 after 0 usecs
calling  max17040_init+0x0/0x11 @ 1
i2c-core: driver [max17040] registered
initcall max17040_init+0x0/0x11 returned 0 after 3906 usecs
calling  gigaset_init_module+0x0/0x2e @ 1
gigaset: Driver for Gigaset 307x
gigaset: no ISDN subsystem interface
initcall gigaset_init_module+0x0/0x2e returned 0 after 3906 usecs
calling  usb_gigaset_init+0x0/0x90 @ 1
usbcore: registered new interface driver usb_gigaset
usb_gigaset: USB Driver for Gigaset 307x using M105
initcall usb_gigaset_init+0x0/0x90 returned 0 after 7812 usecs
calling  virtual_eisa_root_init+0x0/0x4d @ 1
EISA: Probing bus 0 at eisa.0
EISA: Cannot allocate resource for mainboard
Cannot allocate resource for EISA slot 1
Cannot allocate resource for EISA slot 2
Cannot allocate resource for EISA slot 3
Cannot allocate resource for EISA slot 4
Cannot allocate resource for EISA slot 5
Cannot allocate resource for EISA slot 6
Cannot allocate resource for EISA slot 7
Cannot allocate resource for EISA slot 8
EISA: Detected 0 cards.
initcall virtual_eisa_root_init+0x0/0x4d returned 0 after 39062 usecs
calling  init+0x0/0x1de @ 1
lguest: mapped switcher at ffc00000
initcall init+0x0/0x1de returned 0 after 3906 usecs
calling  cpufreq_stats_init+0x0/0x48 @ 1
initcall cpufreq_stats_init+0x0/0x48 returned 0 after 0 usecs
calling  cpufreq_gov_powersave_init+0x0/0xf @ 1
initcall cpufreq_gov_powersave_init+0x0/0xf returned 0 after 0 usecs
calling  cpufreq_gov_dbs_init+0x0/0x7b @ 1
power_supply test_ac: power_supply_changed_work
power_supply test_ac: power_supply_update_gen_leds 1
power_supply test_ac: uevent
power_supply test_ac: POWER_SUPPLY_NAME=test_ac
power_supply test_ac: prop ONLINE=1
power_supply test_battery: power_supply_changed_work
power_supply test_battery: power_supply_update_bat_leds 1
power_supply test_battery: uevent
power_supply test_battery: POWER_SUPPLY_NAME=test_battery
power_supply test_battery: prop STATUS=Charging
power_supply test_battery: prop CHARGE_TYPE=Fast
power_supply test_battery: prop HEALTH=Good
power_supply test_battery: prop TECHNOLOGY=Li-ion
test_power_get_battery_property: some properties deliberately report errors.
power_supply test_battery: driver failed to report `charge_full' property
initcall cpufreq_gov_dbs_init+0x0/0x7b returned 0 after 58593 usecs
calling  mmc_blk_init+0x0/0x3d @ 1
initcall mmc_blk_init+0x0/0x3d returned 0 after 0 usecs
calling  sdio_uart_init+0x0/0xc3 @ 1
initcall sdio_uart_init+0x0/0xc3 returned 0 after 0 usecs
calling  sdhci_drv_init+0x0/0x22 @ 1
sdhci: Secure Digital Host Controller Interface driver
sdhci: Copyright(c) Pierre Ossman
initcall sdhci_drv_init+0x0/0x22 returned 0 after 3906 usecs
calling  sdhci_drv_init+0x0/0xf @ 1
initcall sdhci_drv_init+0x0/0xf returned 0 after 0 usecs
calling  wbsd_drv_init+0x0/0x7b @ 1
wbsd: Winbond W83L51xD SD/MMC card interface driver
wbsd: Copyright(c) Pierre Ossman
initcall wbsd_drv_init+0x0/0x7b returned 0 after 7812 usecs
calling  tifm_sd_init+0x0/0xf @ 1
initcall tifm_sd_init+0x0/0xf returned 0 after 0 usecs
calling  memstick_init+0x0/0x81 @ 1
initcall memstick_init+0x0/0x81 returned 0 after 0 usecs
calling  mspro_block_init+0x0/0x6c @ 1
initcall mspro_block_init+0x0/0x6c returned 0 after 0 usecs
calling  tifm_ms_init+0x0/0xf @ 1
initcall tifm_ms_init+0x0/0xf returned 0 after 0 usecs
calling  bd2802_init+0x0/0x11 @ 1
i2c-core: driver [BD2802] registered
initcall bd2802_init+0x0/0x11 returned 0 after 3906 usecs
calling  lp3944_module_init+0x0/0x11 @ 1
i2c-core: driver [lp3944] registered
initcall lp3944_module_init+0x0/0x11 returned 0 after 3906 usecs
calling  pca955x_leds_init+0x0/0x11 @ 1
i2c-core: driver [leds-pca955x] registered
initcall pca955x_leds_init+0x0/0x11 returned 0 after 3906 usecs
calling  lt3593_led_init+0x0/0xf @ 1
initcall lt3593_led_init+0x0/0xf returned 0 after 0 usecs
calling  dac124s085_leds_init+0x0/0xf @ 1
initcall dac124s085_leds_init+0x0/0xf returned 0 after 0 usecs
calling  timer_trig_init+0x0/0xf @ 1
initcall timer_trig_init+0x0/0xf returned 0 after 0 usecs
calling  heartbeat_trig_init+0x0/0xf @ 1
initcall heartbeat_trig_init+0x0/0xf returned 0 after 0 usecs
calling  gpio_trig_init+0x0/0xf @ 1
initcall gpio_trig_init+0x0/0xf returned 0 after 0 usecs
calling  defon_trig_init+0x0/0xf @ 1
initcall defon_trig_init+0x0/0xf returned 0 after 0 usecs
calling  ibft_init+0x0/0x561 @ 1
No iBFT detected.
initcall ibft_init+0x0/0x561 returned 0 after 3906 usecs
calling  geode_aes_init+0x0/0x16 @ 1
initcall geode_aes_init+0x0/0x16 returned 0 after 0 usecs
calling  hifn_init+0x0/0xaa @ 1
Driver for HIFN 795x crypto accelerator chip has been successfully registered.
initcall hifn_init+0x0/0xaa returned 0 after 3906 usecs
calling  cs5535_mfgpt_init+0x0/0x180 @ 1
cs5535-clockevt: Could not allocate MFPGT timer
initcall cs5535_mfgpt_init+0x0/0x180 returned -19 after 3906 usecs
calling  ioat_init_module+0x0/0x7a @ 1
ioatdma: Intel(R) QuickData Technology Driver 4.00
initcall ioat_init_module+0x0/0x7a returned 0 after 3906 usecs
calling  td_init+0x0/0xf @ 1
initcall td_init+0x0/0xf returned 0 after 0 usecs
calling  vhost_net_init+0x0/0x40 @ 1
initcall vhost_net_init+0x0/0x40 returned 0 after 3906 usecs
calling  alsa_hwdep_init+0x0/0x46 @ 1
initcall alsa_hwdep_init+0x0/0x46 returned 0 after 0 usecs
calling  alsa_timer_init+0x0/0x196 @ 1
initcall alsa_timer_init+0x0/0x196 returned 0 after 0 usecs
calling  rtctimer_init+0x0/0xff @ 1
initcall rtctimer_init+0x0/0xff returned 0 after 0 usecs
calling  alsa_pcm_init+0x0/0x4d @ 1
initcall alsa_pcm_init+0x0/0x4d returned 0 after 0 usecs
calling  snd_mem_init+0x0/0x2f @ 1
initcall snd_mem_init+0x0/0x2f returned 0 after 0 usecs
calling  alsa_rawmidi_init+0x0/0xab @ 1
initcall alsa_rawmidi_init+0x0/0xab returned 0 after 0 usecs
calling  alsa_mixer_oss_init+0x0/0x2d @ 1
initcall alsa_mixer_oss_init+0x0/0x2d returned 0 after 0 usecs
calling  alsa_seq_init+0x0/0x37 @ 1
initcall alsa_seq_init+0x0/0x37 returned 0 after 0 usecs
calling  alsa_seq_device_init+0x0/0x4e @ 1
initcall alsa_seq_device_init+0x0/0x4e returned 0 after 0 usecs
calling  alsa_seq_midi_event_init+0x0/0x7 @ 1
initcall alsa_seq_midi_event_init+0x0/0x7 returned 0 after 0 usecs
calling  alsa_seq_oss_init+0x0/0x1b6 @ 1
initcall alsa_seq_oss_init+0x0/0x1b6 returned 0 after 0 usecs
calling  alsa_seq_dummy_init+0x0/0xc0 @ 1
initcall alsa_seq_dummy_init+0x0/0xc0 returned 0 after 0 usecs
calling  alsa_seq_midi_init+0x0/0x28 @ 1
initcall alsa_seq_midi_init+0x0/0x28 returned 0 after 0 usecs
calling  alsa_seq_midi_emul_init+0x0/0x7 @ 1
initcall alsa_seq_midi_emul_init+0x0/0x7 returned 0 after 0 usecs
calling  alsa_virmidi_init+0x0/0x7 @ 1
initcall alsa_virmidi_init+0x0/0x7 returned 0 after 0 usecs
calling  alsa_akm4xxx_module_init+0x0/0x7 @ 1
initcall alsa_akm4xxx_module_init+0x0/0x7 returned 0 after 0 usecs
calling  alsa_cs8427_module_init+0x0/0x7 @ 1
initcall alsa_cs8427_module_init+0x0/0x7 returned 0 after 0 usecs
calling  alsa_i2c_init+0x0/0x7 @ 1
initcall alsa_i2c_init+0x0/0x7 returned 0 after 0 usecs
calling  alsa_opl3_init+0x0/0x7 @ 1
initcall alsa_opl3_init+0x0/0x7 returned 0 after 0 usecs
calling  alsa_opl3_seq_init+0x0/0x19 @ 1
initcall alsa_opl3_seq_init+0x0/0x19 returned 0 after 0 usecs
calling  alsa_opl4_init+0x0/0x7 @ 1
initcall alsa_opl4_init+0x0/0x7 returned 0 after 0 usecs
calling  alsa_opl4_synth_init+0x0/0x19 @ 1
initcall alsa_opl4_synth_init+0x0/0x19 returned 0 after 0 usecs
calling  alsa_mpu401_uart_init+0x0/0x7 @ 1
initcall alsa_mpu401_uart_init+0x0/0x7 returned 0 after 0 usecs
calling  alsa_vx_core_init+0x0/0x7 @ 1
initcall alsa_vx_core_init+0x0/0x7 returned 0 after 0 usecs
calling  alsa_card_adlib_init+0x0/0x14 @ 1
isa adlib.0: please specify port
initcall alsa_card_adlib_init+0x0/0x14 returned -19 after 3906 usecs
calling  alsa_card_cmi8330_init+0x0/0x14 @ 1
ALSA sound/isa/cmi8330.c:622: cmi8330: specify wssport
initcall alsa_card_cmi8330_init+0x0/0x14 returned -19 after 7812 usecs
calling  alsa_card_es18xx_init+0x0/0x14 @ 1
ALSA sound/isa/es18xx.c:1558: reset at 0x220 failed!!!
ALSA sound/isa/es18xx.c:1626: es18xx: [0x220] ESS chip not found
ALSA sound/isa/es18xx.c:1558: reset at 0x240 failed!!!
ALSA sound/isa/es18xx.c:1626: es18xx: [0x240] ESS chip not found
ALSA sound/isa/es18xx.c:1558: reset at 0x260 failed!!!
ALSA sound/isa/es18xx.c:1626: es18xx: [0x260] ESS chip not found
ALSA sound/isa/es18xx.c:1558: reset at 0x280 failed!!!
ALSA sound/isa/es18xx.c:1626: es18xx: [0x280] ESS chip not found
initcall alsa_card_es18xx_init+0x0/0x14 returned 0 after 46875 usecs
calling  sscape_init+0x0/0x14 @ 1
initcall sscape_init+0x0/0x14 returned -19 after 3906 usecs
calling  alsa_card_ad1848_init+0x0/0x14 @ 1
isa ad1848.0: please specify port
initcall alsa_card_ad1848_init+0x0/0x14 returned -19 after 3906 usecs
calling  alsa_card_es1688_init+0x0/0x14 @ 1
ALSA sound/isa/es1688/es1688_lib.c:112: ess_reset at 0x220: failed!!!
ALSA sound/isa/es1688/es1688_lib.c:144: ESS: [0x220] reset failed... 0xff
ALSA sound/isa/es1688/es1688_lib.c:665: es1688: can't grab IRQ 5
ALSA sound/isa/es1688/es1688_lib.c:665: es1688: can't grab IRQ 5
es1688: probe of es1688.0 failed with error -16
initcall alsa_card_es1688_init+0x0/0x14 returned 0 after 23437 usecs
calling  alsa_es1688_init+0x0/0x7 @ 1
initcall alsa_es1688_init+0x0/0x7 returned 0 after 0 usecs
calling  alsa_card_gusextreme_init+0x0/0x14 @ 1
ALSA sound/isa/es1688/es1688_lib.c:661: es1688: can't grab port 0x224
ALSA sound/isa/es1688/es1688_lib.c:661: es1688: can't grab port 0x244
ALSA sound/isa/es1688/es1688_lib.c:661: es1688: can't grab port 0x264
gusextreme: probe of gusextreme.0 failed with error -16
initcall alsa_card_gusextreme_init+0x0/0x14 returned 0 after 19531 usecs
calling  alsa_gus_init+0x0/0x7 @ 1
initcall alsa_gus_init+0x0/0x7 returned 0 after 0 usecs
calling  snd_msnd_init+0x0/0x14 @ 1
initcall snd_msnd_init+0x0/0x14 returned -19 after 0 usecs
calling  snd_msnd_init+0x0/0x14 @ 1
initcall snd_msnd_init+0x0/0x14 returned -19 after 3906 usecs
calling  alsa_card_opti9xx_init+0x0/0x14 @ 1
initcall alsa_card_opti9xx_init+0x0/0x14 returned 0 after 0 usecs
calling  alsa_card_opti9xx_init+0x0/0x14 @ 1
Error: Driver 'opti92x' is already registered, aborting...
initcall alsa_card_opti9xx_init+0x0/0x14 returned -16 after 3906 usecs
initcall alsa_card_opti9xx_init+0x0/0x14 returned with error code -16 
calling  alsa_card_opti9xx_init+0x0/0x14 @ 1
initcall alsa_card_opti9xx_init+0x0/0x14 returned 0 after 0 usecs
calling  alsa_card_miro_init+0x0/0x14 @ 1
ALSA sound/isa/opti9xx/miro.c:1440: unable to detect OPTi9xx chip
initcall alsa_card_miro_init+0x0/0x14 returned 0 after 3906 usecs
calling  alsa_sb_common_init+0x0/0x7 @ 1
initcall alsa_sb_common_init+0x0/0x7 returned 0 after 0 usecs
calling  alsa_sb16_init+0x0/0x7 @ 1
initcall alsa_sb16_init+0x0/0x7 returned 0 after 0 usecs
calling  alsa_card_sb16_init+0x0/0x14 @ 1
ALSA sound/isa/sb/sb_common.c:255: sb: can't grab port 0x220
ALSA sound/isa/sb/sb_common.c:255: sb: can't grab port 0x240
ALSA sound/isa/sb/sb_common.c:255: sb: can't grab port 0x260
ALSA sound/isa/sb/sb_common.c:90: snd_sbdsp_reset [0x280] failed...
initcall alsa_card_sb16_init+0x0/0x14 returned 0 after 23437 usecs
calling  alsa_sb_csp_init+0x0/0x7 @ 1
initcall alsa_sb_csp_init+0x0/0x7 returned 0 after 0 usecs
calling  alsa_card_wavefront_init+0x0/0x14 @ 1
ALSA sound/isa/wavefront/wavefront.c:555: specify CS4232 port
initcall alsa_card_wavefront_init+0x0/0x14 returned -19 after 7812 usecs
calling  alsa_wss_init+0x0/0x7 @ 1
initcall alsa_wss_init+0x0/0x7 returned 0 after 0 usecs
calling  alsa_card_atiixp_init+0x0/0x16 @ 1
initcall alsa_card_atiixp_init+0x0/0x16 returned 0 after 0 usecs
calling  alsa_card_azf3328_init+0x0/0x16 @ 1
initcall alsa_card_azf3328_init+0x0/0x16 returned 0 after 0 usecs
calling  alsa_card_bt87x_init+0x0/0x29 @ 1
initcall alsa_card_bt87x_init+0x0/0x29 returned 0 after 0 usecs
calling  alsa_card_cs4281_init+0x0/0x16 @ 1
initcall alsa_card_cs4281_init+0x0/0x16 returned 0 after 0 usecs
calling  alsa_card_cs5530_init+0x0/0x16 @ 1
initcall alsa_card_cs5530_init+0x0/0x16 returned 0 after 0 usecs
calling  alsa_card_ens137x_init+0x0/0x16 @ 1
initcall alsa_card_ens137x_init+0x0/0x16 returned 0 after 0 usecs
calling  alsa_card_es1968_init+0x0/0x16 @ 1
initcall alsa_card_es1968_init+0x0/0x16 returned 0 after 0 usecs
calling  alsa_card_intel8x0_init+0x0/0x16 @ 1
IOAPIC[0]: Set routing entry (2-3 -> 0x29 -> IRQ 27 Mode:1 Active:1)
Intel ICH 0000:00:04.0: PCI->APIC IRQ transform: INT A -> IRQ 27
Intel ICH 0000:00:04.0: setting latency timer to 64
intel8x0_measure_ac97_clock: measured 56000 usecs (2680 samples)
intel8x0: clocking to 48000
wm97xx-ts 0-0:ALC850: Device with vendor 414c is not a wm97xx
initcall alsa_card_intel8x0_init+0x0/0x16 returned 0 after 335937 usecs
calling  alsa_card_intel8x0m_init+0x0/0x16 @ 1
initcall alsa_card_intel8x0m_init+0x0/0x16 returned 0 after 0 usecs
calling  alsa_card_m3_init+0x0/0x16 @ 1
initcall alsa_card_m3_init+0x0/0x16 returned 0 after 0 usecs
calling  alsa_card_rme32_init+0x0/0x16 @ 1
initcall alsa_card_rme32_init+0x0/0x16 returned 0 after 0 usecs
calling  sis7019_init+0x0/0x16 @ 1
initcall sis7019_init+0x0/0x16 returned 0 after 0 usecs
calling  alsa_card_sonicvibes_init+0x0/0x16 @ 1
initcall alsa_card_sonicvibes_init+0x0/0x16 returned 0 after 0 usecs
calling  alsa_card_via82xx_init+0x0/0x16 @ 1
initcall alsa_card_via82xx_init+0x0/0x16 returned 0 after 0 usecs
calling  alsa_card_via82xx_init+0x0/0x16 @ 1
initcall alsa_card_via82xx_init+0x0/0x16 returned 0 after 0 usecs
calling  alsa_ac97_init+0x0/0x7 @ 1
initcall alsa_ac97_init+0x0/0x7 returned 0 after 0 usecs
calling  alsa_card_ali_init+0x0/0x16 @ 1
initcall alsa_card_ali_init+0x0/0x16 returned 0 after 0 usecs
calling  snd_asihpi_init+0x0/0x1b @ 1
ASIHPI driver 4.03.25
initcall snd_asihpi_init+0x0/0x1b returned 0 after 0 usecs
calling  alsa_card_vortex_init+0x0/0x16 @ 1
initcall alsa_card_vortex_init+0x0/0x16 returned 0 after 0 usecs
calling  alsa_card_vortex_init+0x0/0x16 @ 1
initcall alsa_card_vortex_init+0x0/0x16 returned 0 after 0 usecs
calling  alsa_card_vortex_init+0x0/0x16 @ 1
initcall alsa_card_vortex_init+0x0/0x16 returned 0 after 0 usecs
calling  ct_card_init+0x0/0x16 @ 1
initcall ct_card_init+0x0/0x16 returned 0 after 0 usecs
calling  alsa_card_ca0106_init+0x0/0x16 @ 1
initcall alsa_card_ca0106_init+0x0/0x16 returned 0 after 0 usecs
calling  alsa_card_cs46xx_init+0x0/0x16 @ 1
initcall alsa_card_cs46xx_init+0x0/0x16 returned 0 after 0 usecs
calling  alsa_card_cs5535audio_init+0x0/0x16 @ 1
initcall alsa_card_cs5535audio_init+0x0/0x16 returned 0 after 0 usecs
calling  alsa_card_echo_init+0x0/0x16 @ 1
initcall alsa_card_echo_init+0x0/0x16 returned 0 after 3906 usecs
calling  alsa_card_echo_init+0x0/0x16 @ 1
initcall alsa_card_echo_init+0x0/0x16 returned 0 after 0 usecs
calling  alsa_card_echo_init+0x0/0x16 @ 1
initcall alsa_card_echo_init+0x0/0x16 returned 0 after 0 usecs
calling  alsa_card_echo_init+0x0/0x16 @ 1
initcall alsa_card_echo_init+0x0/0x16 returned 0 after 0 usecs
calling  alsa_card_echo_init+0x0/0x16 @ 1
initcall alsa_card_echo_init+0x0/0x16 returned 0 after 0 usecs
calling  alsa_card_echo_init+0x0/0x16 @ 1
initcall alsa_card_echo_init+0x0/0x16 returned 0 after 0 usecs
calling  alsa_card_echo_init+0x0/0x16 @ 1
initcall alsa_card_echo_init+0x0/0x16 returned 0 after 0 usecs
calling  alsa_card_echo_init+0x0/0x16 @ 1
initcall alsa_card_echo_init+0x0/0x16 returned 0 after 0 usecs
calling  alsa_card_emu10k1_init+0x0/0x16 @ 1
initcall alsa_card_emu10k1_init+0x0/0x16 returned 0 after 0 usecs
calling  alsa_emu10k1_synth_init+0x0/0x19 @ 1
initcall alsa_emu10k1_synth_init+0x0/0x19 returned 0 after 0 usecs
calling  alsa_card_emu10k1x_init+0x0/0x16 @ 1
initcall alsa_card_emu10k1x_init+0x0/0x16 returned 0 after 0 usecs
calling  patch_cmedia_init+0x0/0xf @ 1
initcall patch_cmedia_init+0x0/0xf returned 0 after 0 usecs
calling  patch_sigmatel_init+0x0/0xf @ 1
initcall patch_sigmatel_init+0x0/0xf returned 0 after 0 usecs
calling  patch_si3054_init+0x0/0xf @ 1
initcall patch_si3054_init+0x0/0xf returned 0 after 0 usecs
calling  patch_atihdmi_init+0x0/0xf @ 1
initcall patch_atihdmi_init+0x0/0xf returned 0 after 0 usecs
calling  patch_cirrus_init+0x0/0xf @ 1
initcall patch_cirrus_init+0x0/0xf returned 0 after 0 usecs
calling  patch_conexant_init+0x0/0xf @ 1
initcall patch_conexant_init+0x0/0xf returned 0 after 0 usecs
calling  patch_via_init+0x0/0xf @ 1
initcall patch_via_init+0x0/0xf returned 0 after 0 usecs
calling  patch_nvhdmi_init+0x0/0xf @ 1
initcall patch_nvhdmi_init+0x0/0xf returned 0 after 0 usecs
calling  alsa_card_azx_init+0x0/0x16 @ 1
initcall alsa_card_azx_init+0x0/0x16 returned 0 after 0 usecs
calling  alsa_card_ice1712_init+0x0/0x16 @ 1
initcall alsa_card_ice1712_init+0x0/0x16 returned 0 after 0 usecs
calling  alsa_ice1712_akm4xxx_module_init+0x0/0x7 @ 1
initcall alsa_ice1712_akm4xxx_module_init+0x0/0x7 returned 0 after 0 usecs
calling  pcxhr_module_init+0x0/0x16 @ 1
initcall pcxhr_module_init+0x0/0x16 returned 0 after 0 usecs
calling  alsa_card_riptide_init+0x0/0x41 @ 1
initcall alsa_card_riptide_init+0x0/0x41 returned 0 after 0 usecs
calling  alsa_card_hammerfall_init+0x0/0x16 @ 1
initcall alsa_card_hammerfall_init+0x0/0x16 returned 0 after 0 usecs
calling  alsa_card_hdsp_init+0x0/0x16 @ 1
initcall alsa_card_hdsp_init+0x0/0x16 returned 0 after 0 usecs
calling  alsa_card_hdspm_init+0x0/0x16 @ 1
initcall alsa_card_hdspm_init+0x0/0x16 returned 0 after 0 usecs
calling  alsa_card_trident_init+0x0/0x16 @ 1
initcall alsa_card_trident_init+0x0/0x16 returned 0 after 0 usecs
calling  alsa_card_vx222_init+0x0/0x16 @ 1
initcall alsa_card_vx222_init+0x0/0x16 returned 0 after 0 usecs
calling  alsa_util_mem_init+0x0/0x7 @ 1
initcall alsa_util_mem_init+0x0/0x7 returned 0 after 0 usecs
calling  alsa_emux_init+0x0/0x7 @ 1
initcall alsa_emux_init+0x0/0x7 returned 0 after 0 usecs
calling  snd_us122l_module_init+0x0/0x16 @ 1
usbcore: registered new interface driver snd-usb-us122l
initcall snd_us122l_module_init+0x0/0x16 returned 0 after 3906 usecs
calling  snd_module_init+0x0/0x16 @ 1
usbcore: registered new interface driver snd-usb-caiaq
initcall snd_module_init+0x0/0x16 returned 0 after 3906 usecs
calling  alsa_sound_last_init+0x0/0x5a @ 1
ALSA device list:
  #0: NVidia CK804 with ALC850 at irq 27
initcall alsa_sound_last_init+0x0/0x5a returned 0 after 3906 usecs
calling  flow_cache_init_global+0x0/0x112 @ 1
initcall flow_cache_init_global+0x0/0x112 returned 0 after 3906 usecs
calling  pg_init+0x0/0x28c @ 1
pktgen 2.73: Packet Generator for packet performance testing.
initcall pg_init+0x0/0x28c returned 0 after 3906 usecs
calling  llc_init+0x0/0x1b @ 1
initcall llc_init+0x0/0x1b returned 0 after 0 usecs
calling  snap_init+0x0/0x35 @ 1
initcall snap_init+0x0/0x35 returned 0 after 0 usecs
calling  nfnetlink_init+0x0/0x26 @ 1
Netfilter messages via NETLINK v0.30.
initcall nfnetlink_init+0x0/0x26 returned 0 after 3906 usecs
calling  nfnetlink_log_init+0x0/0xbe @ 1
initcall nfnetlink_log_init+0x0/0xbe returned 0 after 0 usecs
calling  nf_conntrack_standalone_init+0x0/0xf @ 1
nf_conntrack version 0.5.0 (15884 buckets, 63536 max)
CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
nf_conntrack.acct=1 kernel parameter, acct=1 nf_conntrack module option or
sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
initcall nf_conntrack_standalone_init+0x0/0xf returned 0 after 15625 usecs
calling  nf_ct_proto_gre_init+0x0/0x33 @ 1
initcall nf_ct_proto_gre_init+0x0/0x33 returned 0 after 0 usecs
calling  nf_conntrack_proto_sctp_init+0x0/0x51 @ 1
initcall nf_conntrack_proto_sctp_init+0x0/0x51 returned 0 after 0 usecs
calling  nf_conntrack_proto_udplite_init+0x0/0x37 @ 1
initcall nf_conntrack_proto_udplite_init+0x0/0x37 returned 0 after 0 usecs
calling  ctnetlink_init+0x0/0xba @ 1
ctnetlink v0.93: registering with nfnetlink.
initcall ctnetlink_init+0x0/0xba returned 0 after 3906 usecs
calling  nf_conntrack_amanda_init+0x0/0x9a @ 1
initcall nf_conntrack_amanda_init+0x0/0x9a returned 0 after 0 usecs
calling  nf_conntrack_irc_init+0x0/0x189 @ 1
initcall nf_conntrack_irc_init+0x0/0x189 returned 0 after 0 usecs
calling  nf_conntrack_netbios_ns_init+0x0/0x19 @ 1
initcall nf_conntrack_netbios_ns_init+0x0/0x19 returned 0 after 0 usecs
calling  nf_conntrack_pptp_init+0x0/0x33 @ 1
initcall nf_conntrack_pptp_init+0x0/0x33 returned 0 after 0 usecs
calling  nf_conntrack_sane_init+0x0/0x204 @ 1
initcall nf_conntrack_sane_init+0x0/0x204 returned 0 after 0 usecs
calling  nf_conntrack_sip_init+0x0/0x212 @ 1
initcall nf_conntrack_sip_init+0x0/0x212 returned 0 after 0 usecs
calling  nf_conntrack_tftp_init+0x0/0x179 @ 1
initcall nf_conntrack_tftp_init+0x0/0x179 returned 0 after 0 usecs
calling  xt_init+0x0/0xb0 @ 1
initcall xt_init+0x0/0xb0 returned 0 after 0 usecs
calling  tcpudp_mt_init+0x0/0x14 @ 1
initcall tcpudp_mt_init+0x0/0x14 returned 0 after 0 usecs
calling  mark_mt_init+0x0/0x37 @ 1
initcall mark_mt_init+0x0/0x37 returned 0 after 0 usecs
calling  connmark_mt_init+0x0/0x37 @ 1
initcall connmark_mt_init+0x0/0x37 returned 0 after 0 usecs
calling  classify_tg_init+0x0/0xf @ 1
initcall classify_tg_init+0x0/0xf returned 0 after 0 usecs
calling  connsecmark_tg_init+0x0/0xf @ 1
initcall connsecmark_tg_init+0x0/0xf returned 0 after 0 usecs
calling  led_tg_init+0x0/0xf @ 1
initcall led_tg_init+0x0/0xf returned 0 after 0 usecs
calling  nflog_tg_init+0x0/0xf @ 1
initcall nflog_tg_init+0x0/0xf returned 0 after 0 usecs
calling  nfqueue_tg_init+0x0/0x14 @ 1
initcall nfqueue_tg_init+0x0/0x14 returned 0 after 0 usecs
calling  secmark_tg_init+0x0/0xf @ 1
initcall secmark_tg_init+0x0/0xf returned 0 after 0 usecs
calling  tee_tg_init+0x0/0x14 @ 1
initcall tee_tg_init+0x0/0x14 returned 0 after 0 usecs
calling  xt_cluster_mt_init+0x0/0xf @ 1
initcall xt_cluster_mt_init+0x0/0xf returned 0 after 0 usecs
calling  comment_mt_init+0x0/0xf @ 1
initcall comment_mt_init+0x0/0xf returned 0 after 0 usecs
calling  connbytes_mt_init+0x0/0xf @ 1
initcall connbytes_mt_init+0x0/0xf returned 0 after 0 usecs
calling  conntrack_mt_init+0x0/0x14 @ 1
initcall conntrack_mt_init+0x0/0x14 returned 0 after 0 usecs
calling  dccp_mt_init+0x0/0x92 @ 1
initcall dccp_mt_init+0x0/0x92 returned 0 after 0 usecs
calling  dscp_mt_init+0x0/0x14 @ 1
initcall dscp_mt_init+0x0/0x14 returned 0 after 0 usecs
calling  esp_mt_init+0x0/0x14 @ 1
initcall esp_mt_init+0x0/0x14 returned 0 after 0 usecs
calling  hashlimit_mt_init+0x0/0x88 @ 1
initcall hashlimit_mt_init+0x0/0x88 returned 0 after 0 usecs
calling  hl_mt_init+0x0/0x14 @ 1
initcall hl_mt_init+0x0/0x14 returned 0 after 0 usecs
calling  limit_mt_init+0x0/0xf @ 1
initcall limit_mt_init+0x0/0xf returned 0 after 0 usecs
calling  mac_mt_init+0x0/0xf @ 1
initcall mac_mt_init+0x0/0xf returned 0 after 0 usecs
calling  owner_mt_init+0x0/0xf @ 1
initcall owner_mt_init+0x0/0xf returned 0 after 0 usecs
calling  pkttype_mt_init+0x0/0xf @ 1
initcall pkttype_mt_init+0x0/0xf returned 0 after 0 usecs
calling  policy_mt_init+0x0/0x14 @ 1
initcall policy_mt_init+0x0/0x14 returned 0 after 0 usecs
calling  state_mt_init+0x0/0xf @ 1
initcall state_mt_init+0x0/0xf returned 0 after 0 usecs
calling  statistic_mt_init+0x0/0xf @ 1
initcall statistic_mt_init+0x0/0xf returned 0 after 0 usecs
calling  string_mt_init+0x0/0xf @ 1
initcall string_mt_init+0x0/0xf returned 0 after 0 usecs
calling  tcpmss_mt_init+0x0/0x14 @ 1
initcall tcpmss_mt_init+0x0/0x14 returned 0 after 0 usecs
calling  time_mt_init+0x0/0x5c @ 1
xt_time: kernel timezone is -0000
initcall time_mt_init+0x0/0x5c returned 0 after 3906 usecs
calling  ip_vs_init+0x0/0xac @ 1
IPVS: Registered protocols (TCP, SCTP, AH)
IPVS: Connection hash table configured (size=4096, memory=32Kbytes)
IPVS: ipvs loaded.
initcall ip_vs_init+0x0/0xac returned 0 after 11718 usecs
calling  ip_vs_wrr_init+0x0/0xf @ 1
IPVS: [wrr] scheduler registered.
initcall ip_vs_wrr_init+0x0/0xf returned 0 after 3906 usecs
calling  ip_vs_lc_init+0x0/0xf @ 1
IPVS: [lc] scheduler registered.
initcall ip_vs_lc_init+0x0/0xf returned 0 after 0 usecs
calling  ip_vs_wlc_init+0x0/0xf @ 1
IPVS: [wlc] scheduler registered.
initcall ip_vs_wlc_init+0x0/0xf returned 0 after 0 usecs
calling  ip_vs_lblc_init+0x0/0x37 @ 1
IPVS: [lblc] scheduler registered.
initcall ip_vs_lblc_init+0x0/0x37 returned 0 after 3906 usecs
calling  ip_vs_lblcr_init+0x0/0x37 @ 1
IPVS: [lblcr] scheduler registered.
initcall ip_vs_lblcr_init+0x0/0x37 returned 0 after 3906 usecs
calling  ip_vs_dh_init+0x0/0xf @ 1
IPVS: [dh] scheduler registered.
initcall ip_vs_dh_init+0x0/0xf returned 0 after 3906 usecs
calling  ip_vs_sh_init+0x0/0xf @ 1
IPVS: [sh] scheduler registered.
initcall ip_vs_sh_init+0x0/0xf returned 0 after 3906 usecs
calling  ip_vs_nq_init+0x0/0xf @ 1
IPVS: [nq] scheduler registered.
initcall ip_vs_nq_init+0x0/0xf returned 0 after 3906 usecs
calling  sysctl_ipv4_init+0x0/0x71 @ 1
initcall sysctl_ipv4_init+0x0/0x71 returned 0 after 0 usecs
calling  ipip_init+0x0/0x54 @ 1
IPv4 over IPv4 tunneling driver
initcall ipip_init+0x0/0x54 returned 0 after 3906 usecs
calling  init_syncookies+0x0/0x16 @ 1
initcall init_syncookies+0x0/0x16 returned 0 after 0 usecs
calling  esp4_init+0x0/0x65 @ 1
initcall esp4_init+0x0/0x65 returned 0 after 0 usecs
calling  ipcomp4_init+0x0/0x65 @ 1
initcall ipcomp4_init+0x0/0x65 returned 0 after 0 usecs
calling  ipip_init+0x0/0xa9 @ 1
initcall ipip_init+0x0/0xa9 returned 0 after 0 usecs
calling  xfrm4_beet_init+0x0/0x14 @ 1
initcall xfrm4_beet_init+0x0/0x14 returned 0 after 0 usecs
calling  tunnel4_init+0x0/0x65 @ 1
initcall tunnel4_init+0x0/0x65 returned 0 after 0 usecs
calling  ipv4_netfilter_init+0x0/0x20 @ 1
initcall ipv4_netfilter_init+0x0/0x20 returned 0 after 0 usecs
calling  nf_conntrack_l3proto_ipv4_init+0x0/0x106 @ 1
initcall nf_conntrack_l3proto_ipv4_init+0x0/0x106 returned 0 after 0 usecs
calling  nf_defrag_init+0x0/0x14 @ 1
initcall nf_defrag_init+0x0/0x14 returned 0 after 0 usecs
calling  arp_tables_init+0x0/0x6b @ 1
arp_tables: (C) 2002 David S. Miller
initcall arp_tables_init+0x0/0x6b returned 0 after 0 usecs
calling  arpt_mangle_init+0x0/0xf @ 1
initcall arpt_mangle_init+0x0/0xf returned 0 after 0 usecs
calling  arptable_filter_init+0x0/0x40 @ 1
initcall arptable_filter_init+0x0/0x40 returned 0 after 0 usecs
calling  inet_diag_init+0x0/0xb5 @ 1
initcall inet_diag_init+0x0/0xb5 returned 0 after 0 usecs
calling  tcp_diag_init+0x0/0xf @ 1
initcall tcp_diag_init+0x0/0xf returned 0 after 0 usecs
calling  cubictcp_register+0x0/0x72 @ 1
TCP cubic registered
initcall cubictcp_register+0x0/0x72 returned 0 after 3906 usecs
calling  hstcp_register+0x0/0xf @ 1
TCP highspeed registered
initcall hstcp_register+0x0/0xf returned 0 after 3906 usecs
calling  hybla_register+0x0/0xf @ 1
TCP hybla registered
initcall hybla_register+0x0/0xf returned 0 after 0 usecs
calling  htcp_register+0x0/0xf @ 1
TCP htcp registered
initcall htcp_register+0x0/0xf returned 0 after 3906 usecs
calling  tcp_vegas_register+0x0/0x11 @ 1
TCP vegas registered
initcall tcp_vegas_register+0x0/0x11 returned 0 after 0 usecs
calling  tcp_veno_register+0x0/0x11 @ 1
TCP veno registered
initcall tcp_veno_register+0x0/0x11 returned 0 after 0 usecs
calling  tcp_lp_register+0x0/0xf @ 1
TCP lp registered
initcall tcp_lp_register+0x0/0xf returned 0 after 3906 usecs
calling  tcp_yeah_register+0x0/0x11 @ 1
TCP yeah registered
initcall tcp_yeah_register+0x0/0x11 returned 0 after 0 usecs
calling  tcp_illinois_register+0x0/0xf @ 1
TCP illinois registered
initcall tcp_illinois_register+0x0/0xf returned 0 after 0 usecs
calling  inet6_init+0x0/0x282 @ 1
NET: Registered protocol family 10
initcall inet6_init+0x0/0x282 returned 0 after 7812 usecs
calling  ah6_init+0x0/0x65 @ 1
initcall ah6_init+0x0/0x65 returned 0 after 0 usecs
calling  ipcomp6_init+0x0/0x65 @ 1
initcall ipcomp6_init+0x0/0x65 returned 0 after 0 usecs
calling  xfrm6_tunnel_init+0x0/0xc5 @ 1
initcall xfrm6_tunnel_init+0x0/0xc5 returned 0 after 0 usecs
calling  tunnel6_init+0x0/0x65 @ 1
initcall tunnel6_init+0x0/0x65 returned 0 after 0 usecs
calling  xfrm6_transport_init+0x0/0x14 @ 1
initcall xfrm6_transport_init+0x0/0x14 returned 0 after 0 usecs
calling  xfrm6_mode_tunnel_init+0x0/0x14 @ 1
initcall xfrm6_mode_tunnel_init+0x0/0x14 returned 0 after 0 usecs
calling  xfrm6_ro_init+0x0/0x14 @ 1
initcall xfrm6_ro_init+0x0/0x14 returned 0 after 0 usecs
calling  xfrm6_beet_init+0x0/0x14 @ 1
initcall xfrm6_beet_init+0x0/0x14 returned 0 after 0 usecs
calling  sit_init+0x0/0x54 @ 1
IPv6 over IPv4 tunneling driver
initcall sit_init+0x0/0x54 returned 0 after 3906 usecs
calling  ip6_tunnel_init+0x0/0x7e @ 1
initcall ip6_tunnel_init+0x0/0x7e returned 0 after 0 usecs
calling  packet_init+0x0/0x39 @ 1
NET: Registered protocol family 17
initcall packet_init+0x0/0x39 returned 0 after 3906 usecs
calling  br_init+0x0/0xb7 @ 1
Bridge firewalling registered
initcall br_init+0x0/0xb7 returned 0 after 0 usecs
calling  dsa_init_module+0x0/0x11 @ 1
initcall dsa_init_module+0x0/0x11 returned 0 after 0 usecs
calling  edsa_init_module+0x0/0x11 @ 1
initcall edsa_init_module+0x0/0x11 returned 0 after 0 usecs
calling  trailer_init_module+0x0/0x11 @ 1
initcall trailer_init_module+0x0/0x11 returned 0 after 0 usecs
calling  mv88e6060_init+0x0/0x11 @ 1
initcall mv88e6060_init+0x0/0x11 returned 0 after 0 usecs
calling  mv88e6123_61_65_init+0x0/0x11 @ 1
initcall mv88e6123_61_65_init+0x0/0x11 returned 0 after 0 usecs
calling  mv88e6131_init+0x0/0x11 @ 1
initcall mv88e6131_init+0x0/0x11 returned 0 after 0 usecs
calling  dsa_init_module+0x0/0xf @ 1
initcall dsa_init_module+0x0/0xf returned 0 after 0 usecs
calling  ipx_init+0x0/0xd8 @ 1
NET: Registered protocol family 4
initcall ipx_init+0x0/0xd8 returned 0 after 0 usecs
calling  atalk_init+0x0/0x7a @ 1
NET: Registered protocol family 5
initcall atalk_init+0x0/0x7a returned 0 after 3906 usecs
calling  x25_init+0x0/0x85 @ 1
NET: Registered protocol family 9
X.25 for Linux Version 0.2
initcall x25_init+0x0/0x85 returned 0 after 3906 usecs
calling  can_init+0x0/0xcd @ 1
can: controller area network core (rev 20090105 abi 8)
NET: Registered protocol family 29
initcall can_init+0x0/0xcd returned 0 after 3906 usecs
calling  raw_module_init+0x0/0x35 @ 1
can: raw protocol (rev 20090105)
initcall raw_module_init+0x0/0x35 returned 0 after 3906 usecs
calling  init_rpcsec_gss+0x0/0x3f @ 1
initcall init_rpcsec_gss+0x0/0x3f returned 0 after 0 usecs
calling  init_kerberos_module+0x0/0x29 @ 1
initcall init_kerberos_module+0x0/0x29 returned 0 after 0 usecs
calling  init_spkm3_module+0x0/0x29 @ 1
initcall init_spkm3_module+0x0/0x29 returned 0 after 0 usecs
calling  af_rxrpc_init+0x0/0x187 @ 1
NET: Registered protocol family 33
initcall af_rxrpc_init+0x0/0x187 returned 0 after 3906 usecs
calling  rxkad_init+0x0/0x5d @ 1
RxRPC: Registered security type 2 'rxkad'
initcall rxkad_init+0x0/0x5d returned 0 after 3906 usecs
calling  atm_clip_init+0x0/0xa6 @ 1
initcall atm_clip_init+0x0/0xa6 returned 0 after 0 usecs
calling  br2684_init+0x0/0x40 @ 1
initcall br2684_init+0x0/0x40 returned 0 after 0 usecs
calling  lane_module_init+0x0/0x6b @ 1
lec:lane_module_init: lec.c: Jun 30 2010 02:07:39 initialized
initcall lane_module_init+0x0/0x6b returned 0 after 3906 usecs
calling  atm_mpoa_init+0x0/0x45 @ 1
mpoa:atm_mpoa_init: mpc.c: Jun 30 2010 02:07:35 initialized
initcall atm_mpoa_init+0x0/0x45 returned 0 after 3906 usecs
calling  pppoatm_init+0x0/0x11 @ 1
initcall pppoatm_init+0x0/0x11 returned 0 after 0 usecs
calling  decnet_init+0x0/0x80 @ 1
NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet Project Team
DECnet: Routing cache hash table of 1024 buckets, 4Kbytes
NET: Registered protocol family 12
initcall decnet_init+0x0/0x80 returned 0 after 11718 usecs
calling  dn_rtmsg_init+0x0/0x70 @ 1
initcall dn_rtmsg_init+0x0/0x70 returned 0 after 0 usecs
calling  phonet_init+0x0/0x73 @ 1
NET: Registered protocol family 35
initcall phonet_init+0x0/0x73 returned 0 after 3906 usecs
calling  pep_register+0x0/0x14 @ 1
initcall pep_register+0x0/0x14 returned 0 after 0 usecs
calling  sctp_init+0x0/0x6ff @ 1
SCTP: Hash tables configured (established 65536 bind 65536)
sctp_init_sock(sk: f6178000)
initcall sctp_init+0x0/0x6ff returned 0 after 11718 usecs
calling  lib80211_init+0x0/0x1e @ 1
lib80211: common routines for IEEE802.11 drivers
lib80211_crypt: registered algorithm 'NULL'
initcall lib80211_init+0x0/0x1e returned 0 after 7812 usecs
calling  lib80211_crypto_wep_init+0x0/0xf @ 1
lib80211_crypt: registered algorithm 'WEP'
initcall lib80211_crypto_wep_init+0x0/0xf returned 0 after 3906 usecs
calling  lib80211_crypto_ccmp_init+0x0/0xf @ 1
lib80211_crypt: registered algorithm 'CCMP'
initcall lib80211_crypto_ccmp_init+0x0/0xf returned 0 after 3906 usecs
calling  lib80211_crypto_tkip_init+0x0/0xf @ 1
lib80211_crypt: registered algorithm 'TKIP'
initcall lib80211_crypto_tkip_init+0x0/0xf returned 0 after 3906 usecs
calling  tipc_init+0x0/0xc5 @ 1
TIPC: Activated (version 2.0.0 compiled Jun 30 2010 02:08:06)
NET: Registered protocol family 30
TIPC: Started in single node mode
initcall tipc_init+0x0/0xc5 returned 0 after 11718 usecs
calling  caif_device_init+0x0/0x71 @ 1
initcall caif_device_init+0x0/0x71 returned 0 after 0 usecs
calling  chnl_init_module+0x0/0xf @ 1
initcall chnl_init_module+0x0/0xf returned 0 after 0 usecs
calling  caif_sktinit_module+0x0/0x144 @ 1
NET: Registered protocol family 37
initcall caif_sktinit_module+0x0/0x144 returned 0 after 3906 usecs
calling  dcbnl_init+0x0/0x3a @ 1
initcall dcbnl_init+0x0/0x3a returned 0 after 0 usecs
calling  wimax_subsys_init+0x0/0x277 @ 1
initcall wimax_subsys_init+0x0/0x277 returned 0 after 0 usecs
calling  mcheck_debugfs_init+0x0/0x3e @ 1
initcall mcheck_debugfs_init+0x0/0x3e returned 0 after 0 usecs
calling  severities_debugfs_init+0x0/0x3e @ 1
initcall severities_debugfs_init+0x0/0x3e returned 0 after 0 usecs
calling  powernow_init+0x0/0xdb @ 1
initcall powernow_init+0x0/0xdb returned -19 after 0 usecs
calling  centrino_init+0x0/0x1d @ 1
initcall centrino_init+0x0/0x1d returned -19 after 0 usecs
calling  update_mp_table+0x0/0x5c2 @ 1
initcall update_mp_table+0x0/0x5c2 returned 0 after 0 usecs
calling  lapic_insert_resource+0x0/0x35 @ 1
initcall lapic_insert_resource+0x0/0x35 returned 0 after 0 usecs
calling  print_ipi_mode+0x0/0x2d @ 1
Using IPI Shortcut mode
initcall print_ipi_mode+0x0/0x2d returned 0 after 3906 usecs
calling  io_apic_bug_finalize+0x0/0x1a @ 1
initcall io_apic_bug_finalize+0x0/0x1a returned 0 after 0 usecs
calling  check_early_ioremap_leak+0x0/0x69 @ 1
initcall check_early_ioremap_leak+0x0/0x69 returned 0 after 0 usecs
calling  pat_memtype_list_init+0x0/0x37 @ 1
initcall pat_memtype_list_init+0x0/0x37 returned 0 after 0 usecs
calling  init_oops_id+0x0/0x50 @ 1
initcall init_oops_id+0x0/0x50 returned 0 after 0 usecs
calling  disable_boot_consoles+0x0/0x43 @ 1
initcall disable_boot_consoles+0x0/0x43 returned 0 after 0 usecs
calling  pm_qos_power_init+0x0/0xbf @ 1
initcall pm_qos_power_init+0x0/0xbf returned 0 after 0 usecs
calling  clear_boot_tracer+0x0/0x2d @ 1
initcall clear_boot_tracer+0x0/0x2d returned 0 after 0 usecs
calling  afs_init+0x0/0x1d8 @ 1
kAFS: Red Hat AFS client v0.1 registering.
FS-Cache: Netfs 'afs' registered for caching
initcall afs_init+0x0/0x1d8 returned 0 after 7812 usecs
calling  init_ima+0x0/0x14 @ 1
tpm_tis tpm_tis: tpm_transmit: tpm_send: error 4294967291
IMA: No TPM chip found, activating TPM-bypass!
initcall init_ima+0x0/0x14 returned 0 after 7812 usecs
calling  random32_reseed+0x0/0x4f @ 1
initcall random32_reseed+0x0/0x4f returned 0 after 0 usecs
calling  pci_resource_alignment_sysfs_init+0x0/0x14 @ 1
initcall pci_resource_alignment_sysfs_init+0x0/0x14 returned 0 after 0 usecs
calling  pci_sysfs_init+0x0/0x44 @ 1
initcall pci_sysfs_init+0x0/0x44 returned 0 after 0 usecs
calling  seqgen_init+0x0/0xe @ 1
initcall seqgen_init+0x0/0xe returned 0 after 0 usecs
calling  hd_init+0x0/0x2c9 @ 1
hd: no drives specified - use hd=cyl,head,sectors on kernel command line
initcall hd_init+0x0/0x2c9 returned -1 after 3906 usecs
initcall hd_init+0x0/0x2c9 returned with error code -1 
calling  scsi_complete_async_scans+0x0/0x130 @ 1
initcall scsi_complete_async_scans+0x0/0x130 returned 0 after 0 usecs
calling  edd_init+0x0/0x314 @ 1
BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
EDD information not available.
initcall edd_init+0x0/0x314 returned -19 after 7812 usecs
calling  memmap_init+0x0/0x30 @ 1
initcall memmap_init+0x0/0x30 returned 0 after 0 usecs
calling  dmatest_init+0x0/0x187 @ 1
initcall dmatest_init+0x0/0x187 returned 0 after 0 usecs
calling  pci_mmcfg_late_insert_resources+0x0/0x59 @ 1
initcall pci_mmcfg_late_insert_resources+0x0/0x59 returned 1 after 0 usecs
initcall pci_mmcfg_late_insert_resources+0x0/0x59 returned with error code 1 
calling  init_net_drop_monitor+0x0/0xfc @ 1
Initalizing network drop monitor service
initcall init_net_drop_monitor+0x0/0xfc returned 0 after 3906 usecs
calling  tcp_congestion_default+0x0/0xf @ 1
initcall tcp_congestion_default+0x0/0xf returned 0 after 0 usecs
calling  ip_auto_config+0x0/0xe18 @ 1
initcall ip_auto_config+0x0/0xe18 returned 0 after 0 usecs
calling  initialize_hashrnd+0x0/0x16 @ 1
initcall initialize_hashrnd+0x0/0x16 returned 0 after 0 usecs
input: ImPS/2 Generic Wheel Mouse as /class/input/input1
evbug.c: Connected device: input1 (ImPS/2 Generic Wheel Mouse at isa0060/serio1/input0)
async_waiting @ 1
async_continuing @ 1 after 0 usec
EXT3-fs (sda1): recovery required on readonly filesystem
EXT3-fs (sda1): write access will be enabled during recovery
EXT3-fs: barriers not enabled
BUG: unable to handle kernel NULL pointer dereference at 0000039c
IP: [<c102d4a6>] print_context_stack+0x86/0x130
*pde = 00000000 
Oops: 0000 [#1] 
last sysfs file: 

Pid: 0, comm: swapper Not tainted 2.6.35-rc3-tip-01298-g53cd4ef-dirty #13969 A8N-E/System Product Name
EIP: 0060:[<c102d4a6>] EFLAGS: 00010002 CPU: 0
EIP is at print_context_stack+0x86/0x130
EAX: 00000000 EBX: c229cd80 ECX: 00000001 EDX: c229c000
ESI: 00000000 EDI: c1e74d9c EBP: c229cd4c ESP: c229cd28
 DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
Process swapper (pid: 0, ti=c229c000 task=c22a1180 task.ti=c2296000)
Stack:
 c10349df c229dffc c229cd94 ffffe000 c229c000 c229cd94 c229cd68 c1e74d9c
<0> c229c000 c229cd7c c102c0ff c1e74d9c f72aa150 00000000 c229cd6c c229cd6c
<0> c2cd6fa0 00000000 f72aa150 f72aa120 f72aa174 c229cd94 c10349df c229cd7c
Call Trace:
 [<c10349df>] ? save_stack_trace+0x2f/0x50
BUG: unable to handle kernel NULL pointer dereference at 0000039c
IP: [<c102d4a6>] print_context_stack+0x86/0x130
*pde = 00000000 
Oops: 0000 [#2] 
last sysfs file: 

Pid: 0, comm: swapper Not tainted 2.6.35-rc3-tip-01298-g53cd4ef-dirty #13969 A8N-E/System Product Name
EIP: 0060:[<c102d4a6>] EFLAGS: 00010082 CPU: 0
EIP is at print_context_stack+0x86/0x130
EAX: 00000000 EBX: c229cd28 ECX: fffd24f0 EDX: c229c000
ESI: 00000000 EDI: c1e749b4 EBP: c229cb1c ESP: c229caf8
 DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
Process swapper (pid: 0, ti=c229c000 task=c22a1180 task.ti=c2296000)
Stack:
 c10349df c229dffc c229cb4c ffffe000 c229c000 c229cb4c c229cd28 c1e749b4
<0> c229c000 c229cb4c c102c0ff c1e749b4 c20b6d58 00000000 c229cb3c c229cb3c
<0> 00000018 00000000 00000000 c20b6d58 00000018 c229cb70 c102d2c7 c229cb4c
Call Trace:
 [<c10349df>] ? save_stack_trace+0x2f/0x50
BUG: unable to handle kernel NULL pointer dereference at 0000039c
IP: [<c102d4a6>] print_context_stack+0x86/0x130
*pde = 00000000 
Oops: 0000 [#3] 
last sysfs file: 

Pid: 0, comm: swapper Not tainted 2.6.35-rc3-tip-01298-g53cd4ef-dirty #13969 A8N-E/System Product Name
EIP: 0060:[<c102d4a6>] EFLAGS: 00010086 CPU: 0
EIP is at print_context_stack+0x86/0x130
EAX: 00000000 EBX: c229caf8 ECX: fffd214f EDX: c229c000
ESI: 00000000 EDI: c1e749b4 EBP: c229c8ec ESP: c229c8c8
 DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
Process swapper (pid: 0, ti=c229c000 task=c22a1180 task.ti=c2296000)
Stack:
 c10349df c229dffc c229c91c ffffe000 c229c000 c229c91c c229caf8 c1e749b4
<0> c229c000 c229c91c c102c0ff c1e749b4 c20b6d58 00000000 c229c90c c229c90c
<0> 00000018 00000000 00000000 c20b6d58 00000018 c229c940 c102d2c7 c229c91c
Call Trace:
 [<c10349df>] ? save_stack_trace+0x2f/0x50
BUG: unable to handle kernel NULL pointer dereference at 0000039c
IP: [<c102d4a6>] print_context_stack+0x86/0x130
*pde = 00000000 
Oops: 0000 [#4] 
last sysfs file: 

Pid: 0, comm: swapper Not tainted 2.6.35-rc3-tip-01298-g53cd4ef-dirty #13969 A8N-E/System Product Name
EIP: 0060:[<c102d4a6>] EFLAGS: 00010086 CPU: 0
EIP is at print_context_stack+0x86/0x130
EAX: 00000000 EBX: c229c8c8 ECX: fffd1dae EDX: c229c000
ESI: 00000000 EDI: c1e749b4 EBP: c229c6bc ESP: c229c698
 DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
Process swapper (pid: 0, ti=c229c000 task=c22a1180 task.ti=c2296000)
Stack:
 c10349df c229dffc c229c6ec ffffe000 c229c000 c229c6ec c229c8c8 c1e749b4
<0> c229c000 c229c6ec c102c0ff c1e749b4 c20b6d58 00000000 c229c6dc c229c6dc
<0> 00000018 00000000 00000000 c20b6d58 00000018 c229c710 c102d2c7 c229c6ec
Call Trace:
 [<c10349df>] ? save_stack_trace+0x2f/0x50
BUG: unable to handle kernel NULL pointer dereference at 0000039c
IP: [<c102d4a6>] print_context_stack+0x86/0x130
*pde = 00000000 
Oops: 0000 [#5] 
last sysfs file: 

Pid: 0, comm: swapper Not tainted 2.6.35-rc3-tip-01298-g53cd4ef-dirty #13969 A8N-E/System Product Name
EIP: 0060:[<c102d4a6>] EFLAGS: 00010086 CPU: 0
EIP is at print_context_stack+0x86/0x130
EAX: 00000000 EBX: c229c698 ECX: fffd1a0d EDX: c229c000
ESI: 00000000 EDI: c1e749b4 EBP: c229c48c ESP: c229c468
 DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
Process swapper (pid: 0, ti=c229c000 task=c22a1180 task.ti=c2296000)
Stack:
 c10349df c229dffc c229c4bc ffffe000 c229c000 c229c4bc c229c698 c1e749b4
<0> c229c000 c229c4bc c102c0ff c1e749b4 c20b6d58 00000000 c229c4ac c229c4ac
<0> 00000018 00000000 00000000 c20b6d58 00000018 c229c4e0 c102d2c7 c229c4bc
Call Trace:
 [<c10349df>] ? save_stack_trace+0x2f/0x50
 [<c102c0ff>] ? dump_trace+0xaf/0x110
 [<c102d2c7>] ? show_trace_log_lvl+0x47/0x50
 [<c102c1b7>] ? show_stack_log_lvl+0x57/0xf0
 [<c102c308>] ? show_registers+0xb8/0x1d0
 [<c102cf41>] ? __die+0x91/0x100
 [<c104c712>] ? no_context+0x92/0x150
 [<c104c867>] ? __bad_area_nosemaphore+0x97/0x140
 [<c105fe0b>] ? release_console_sem+0x20b/0x220
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104c927>] ? bad_area_nosemaphore+0x17/0x20
 [<c104cf24>] ? do_page_fault+0x334/0x3f0
 [<c18e1690>] ? write_msg+0x0/0x120
 [<c105f193>] ? __call_console_drivers+0x43/0x50
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c1e6df53>] ? error_code+0x63/0x70
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c102d4a6>] ? print_context_stack+0x86/0x130
 [<c10349df>] ? save_stack_trace+0x2f/0x50
 [<c102c0ff>] ? dump_trace+0xaf/0x110
 [<c102d2c7>] ? show_trace_log_lvl+0x47/0x50
 [<c102c1b7>] ? show_stack_log_lvl+0x57/0xf0
 [<c102c308>] ? show_registers+0xb8/0x1d0
 [<c102cf41>] ? __die+0x91/0x100
 [<c104c712>] ? no_context+0x92/0x150
 [<c104c867>] ? __bad_area_nosemaphore+0x97/0x140
 [<c105fe0b>] ? release_console_sem+0x20b/0x220
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104c927>] ? bad_area_nosemaphore+0x17/0x20
 [<c104cf24>] ? do_page_fault+0x334/0x3f0
 [<c18e1690>] ? write_msg+0x0/0x120
 [<c105f193>] ? __call_console_drivers+0x43/0x50
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c1e6df53>] ? error_code+0x63/0x70
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c102d4a6>] ? print_context_stack+0x86/0x130
 [<c10349df>] ? save_stack_trace+0x2f/0x50
 [<c102c0ff>] ? dump_trace+0xaf/0x110
 [<c102d2c7>] ? show_trace_log_lvl+0x47/0x50
 [<c102c1b7>] ? show_stack_log_lvl+0x57/0xf0
 [<c102c308>] ? show_registers+0xb8/0x1d0
 [<c102cf41>] ? __die+0x91/0x100
 [<c104c712>] ? no_context+0x92/0x150
 [<c104c867>] ? __bad_area_nosemaphore+0x97/0x140
 [<c105fe0b>] ? release_console_sem+0x20b/0x220
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104c927>] ? bad_area_nosemaphore+0x17/0x20
 [<c104cf24>] ? do_page_fault+0x334/0x3f0
 [<c18e1690>] ? write_msg+0x0/0x120
 [<c105f193>] ? __call_console_drivers+0x43/0x50
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c1e6df53>] ? error_code+0x63/0x70
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c102d4a6>] ? print_context_stack+0x86/0x130
 [<c10349df>] ? save_stack_trace+0x2f/0x50
 [<c102c0ff>] ? dump_trace+0xaf/0x110
 [<c102d2c7>] ? show_trace_log_lvl+0x47/0x50
 [<c102c1b7>] ? show_stack_log_lvl+0x57/0xf0
 [<c102c308>] ? show_registers+0xb8/0x1d0
 [<c102cf41>] ? __die+0x91/0x100
 [<c104c712>] ? no_context+0x92/0x150
 [<c104c867>] ? __bad_area_nosemaphore+0x97/0x140
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104c927>] ? bad_area_nosemaphore+0x17/0x20
 [<c104cf24>] ? do_page_fault+0x334/0x3f0
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c1e6df53>] ? error_code+0x63/0x70
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c102d4a6>] ? print_context_stack+0x86/0x130
 [<c10349df>] ? save_stack_trace+0x2f/0x50
 [<c102c0ff>] ? dump_trace+0xaf/0x110
 [<c10349df>] ? save_stack_trace+0x2f/0x50
 [<c13d4119>] ? dma_entry_alloc+0x69/0xc0
 [<c13d5354>] ? debug_dma_map_sg+0x94/0x150
 [<c165d528>] ? ata_scsi_rw_xlat+0x1d8/0x290
 [<c1655e4d>] ? ata_qc_issue+0x14d/0x300
 [<c165bb1b>] ? ata_scsi_translate+0x7b/0x150
 [<c10ecaa7>] ? slab_pad_check+0x37/0x1a0
 [<c15f3480>] ? scsi_done+0x0/0x40
 [<c15f3480>] ? scsi_done+0x0/0x40
 [<c165f004>] ? ata_scsi_queuecmd+0x84/0x260
 [<c165d350>] ? ata_scsi_rw_xlat+0x0/0x290
 [<c15f45c7>] ? scsi_dispatch_cmd+0xc7/0x250
 [<c15f991e>] ? scsi_request_fn+0x39e/0x480
 [<c10ee9c3>] ? __slab_free+0x1c3/0x240
 [<c13a7e7a>] ? __blk_run_queue+0x3a/0x70
 [<c13a989f>] ? blk_run_queue+0x1f/0x40
 [<c15fa798>] ? scsi_run_queue+0xb8/0x2d0
 [<c1597d14>] ? put_device+0x14/0x20
 [<c15f411d>] ? __scsi_put_command+0x4d/0x80
 [<c15faafd>] ? scsi_next_command+0x2d/0x40
 [<c15faf08>] ? scsi_io_completion+0x2b8/0x5b0
 [<c10ee9c3>] ? __slab_free+0x1c3/0x240
 [<c15f346a>] ? scsi_finish_command+0xaa/0xc0
 [<c15fb317>] ? scsi_softirq_done+0xf7/0x120
 [<c109c377>] ? __rcu_process_callbacks+0x47/0x470
 [<c13adb5a>] ? blk_done_softirq+0x6a/0x80
 [<c106471c>] ? __do_softirq+0x8c/0x1b0
 [<c1064690>] ? __do_softirq+0x0/0x1b0
 [<c102bfb4>] ? do_softirq+0x84/0xc0
 <IRQ> 
BUG: unable to handle kernel paging request at 0000fff8
IP: [<c102d475>] print_context_stack+0x55/0x130
*pde = 00000000 
Oops: 0000 [#6] 
last sysfs file: 

Pid: 0, comm: swapper Not tainted 2.6.35-rc3-tip-01298-g53cd4ef-dirty #13969 A8N-E/System Product Name
EIP: 0060:[<c102d475>] EFLAGS: 00010097 CPU: 0
EIP is at print_context_stack+0x55/0x130
EAX: ffffe000 EBX: 0000fff8 ECX: c229c28c EDX: 0000fff8
ESI: 00000000 EDI: 0000e000 EBP: c229c25c ESP: c229c238
 DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
Process swapper (pid: 0, ti=c229c000 task=c22a1180 task.ti=c2296000)
Stack:
 c229c248 0000fffc c229c28c ffffe000 0000e000 c229c28c 0000fff8 c1e749b4
<0> 0000e000 c229c28c c102c0ff c1e749b4 c20b6d58 00000000 c229c27c c229c27c
<0> 00000018 00000000 00000000 c20b6d58 00000018 c229c2b0 c102d2c7 c229c28c
Call Trace:
 [<c102c0ff>] ? dump_trace+0xaf/0x110
 [<c102d2c7>] ? show_trace_log_lvl+0x47/0x50
 [<c102c1b7>] ? show_stack_log_lvl+0x57/0xf0
 [<c102c308>] ? show_registers+0xb8/0x1d0
 [<c102cf41>] ? __die+0x91/0x100
 [<c104c712>] ? no_context+0x92/0x150
 [<c104c867>] ? __bad_area_nosemaphore+0x97/0x140
 [<c105fe0b>] ? release_console_sem+0x20b/0x220
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104c927>] ? bad_area_nosemaphore+0x17/0x20
 [<c104cf24>] ? do_page_fault+0x334/0x3f0
 [<c18e1690>] ? write_msg+0x0/0x120
 [<c105f193>] ? __call_console_drivers+0x43/0x50
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c1e6df53>] ? error_code+0x63/0x70
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c102d4a6>] ? print_context_stack+0x86/0x130
 [<c10349df>] ? save_stack_trace+0x2f/0x50
 [<c102c0ff>] ? dump_trace+0xaf/0x110
 [<c102d2c7>] ? show_trace_log_lvl+0x47/0x50
 [<c102c1b7>] ? show_stack_log_lvl+0x57/0xf0
 [<c102c308>] ? show_registers+0xb8/0x1d0
 [<c102cf41>] ? __die+0x91/0x100
 [<c104c712>] ? no_context+0x92/0x150
 [<c104c867>] ? __bad_area_nosemaphore+0x97/0x140
 [<c105fe0b>] ? release_console_sem+0x20b/0x220
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104c927>] ? bad_area_nosemaphore+0x17/0x20
 [<c104cf24>] ? do_page_fault+0x334/0x3f0
 [<c18e1690>] ? write_msg+0x0/0x120
 [<c105f193>] ? __call_console_drivers+0x43/0x50
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c1e6df53>] ? error_code+0x63/0x70
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c102d4a6>] ? print_context_stack+0x86/0x130
 [<c10349df>] ? save_stack_trace+0x2f/0x50
 [<c102c0ff>] ? dump_trace+0xaf/0x110
 [<c102d2c7>] ? show_trace_log_lvl+0x47/0x50
 [<c102c1b7>] ? show_stack_log_lvl+0x57/0xf0
 [<c102c308>] ? show_registers+0xb8/0x1d0
 [<c102cf41>] ? __die+0x91/0x100
 [<c104c712>] ? no_context+0x92/0x150
 [<c104c867>] ? __bad_area_nosemaphore+0x97/0x140
 [<c105fe0b>] ? release_console_sem+0x20b/0x220
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104c927>] ? bad_area_nosemaphore+0x17/0x20
 [<c104cf24>] ? do_page_fault+0x334/0x3f0
 [<c18e1690>] ? write_msg+0x0/0x120
 [<c105f193>] ? __call_console_drivers+0x43/0x50
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c1e6df53>] ? error_code+0x63/0x70
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c102d4a6>] ? print_context_stack+0x86/0x130
 [<c10349df>] ? save_stack_trace+0x2f/0x50
 [<c102c0ff>] ? dump_trace+0xaf/0x110
 [<c102d2c7>] ? show_trace_log_lvl+0x47/0x50
 [<c102c1b7>] ? show_stack_log_lvl+0x57/0xf0
 [<c102c308>] ? show_registers+0xb8/0x1d0
 [<c102cf41>] ? __die+0x91/0x100
 [<c104c712>] ? no_context+0x92/0x150
 [<c104c867>] ? __bad_area_nosemaphore+0x97/0x140
 [<c105fe0b>] ? release_console_sem+0x20b/0x220
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104c927>] ? bad_area_nosemaphore+0x17/0x20
 [<c104cf24>] ? do_page_fault+0x334/0x3f0
 [<c18e1690>] ? write_msg+0x0/0x120
 [<c105f193>] ? __call_console_drivers+0x43/0x50
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c1e6df53>] ? error_code+0x63/0x70
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c102d4a6>] ? print_context_stack+0x86/0x130
 [<c10349df>] ? save_stack_trace+0x2f/0x50
 [<c102c0ff>] ? dump_trace+0xaf/0x110
 [<c102d2c7>] ? show_trace_log_lvl+0x47/0x50
 [<c102c1b7>] ? show_stack_log_lvl+0x57/0xf0
 [<c102c308>] ? show_registers+0xb8/0x1d0
 [<c102cf41>] ? __die+0x91/0x100
 [<c104c712>] ? no_context+0x92/0x150
 [<c104c867>] ? __bad_area_nosemaphore+0x97/0x140
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104c927>] ? bad_area_nosemaphore+0x17/0x20
 [<c104cf24>] ? do_page_fault+0x334/0x3f0
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c1e6df53>] ? error_code+0x63/0x70
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c102d4a6>] ? print_context_stack+0x86/0x130
 [<c10349df>] ? save_stack_trace+0x2f/0x50
 [<c102c0ff>] ? dump_trace+0xaf/0x110
 [<c10349df>] ? save_stack_trace+0x2f/0x50
 [<c13d4119>] ? dma_entry_alloc+0x69/0xc0
 [<c13d5354>] ? debug_dma_map_sg+0x94/0x150
 [<c165d528>] ? ata_scsi_rw_xlat+0x1d8/0x290
 [<c1655e4d>] ? ata_qc_issue+0x14d/0x300
 [<c165bb1b>] ? ata_scsi_translate+0x7b/0x150
 [<c10ecaa7>] ? slab_pad_check+0x37/0x1a0
 [<c15f3480>] ? scsi_done+0x0/0x40
 [<c15f3480>] ? scsi_done+0x0/0x40
 [<c165f004>] ? ata_scsi_queuecmd+0x84/0x260
 [<c165d350>] ? ata_scsi_rw_xlat+0x0/0x290
 [<c15f45c7>] ? scsi_dispatch_cmd+0xc7/0x250
 [<c15f991e>] ? scsi_request_fn+0x39e/0x480
 [<c10ee9c3>] ? __slab_free+0x1c3/0x240
 [<c13a7e7a>] ? __blk_run_queue+0x3a/0x70
 [<c13a989f>] ? blk_run_queue+0x1f/0x40
 [<c15fa798>] ? scsi_run_queue+0xb8/0x2d0
 [<c1597d14>] ? put_device+0x14/0x20
 [<c15f411d>] ? __scsi_put_command+0x4d/0x80
 [<c15faafd>] ? scsi_next_command+0x2d/0x40
 [<c15faf08>] ? scsi_io_completion+0x2b8/0x5b0
 [<c10ee9c3>] ? __slab_free+0x1c3/0x240
 [<c15f346a>] ? scsi_finish_command+0xaa/0xc0
 [<c15fb317>] ? scsi_softirq_done+0xf7/0x120
 [<c109c377>] ? __rcu_process_callbacks+0x47/0x470
 [<c13adb5a>] ? blk_done_softirq+0x6a/0x80
 [<c106471c>] ? __do_softirq+0x8c/0x1b0
 [<c1064690>] ? __do_softirq+0x0/0x1b0
 [<c102bfb4>] ? do_softirq+0x84/0xc0
 <IRQ> 
 [<c102d2c7>] show_trace_log_lvl+0x47/0x50
 [<c102c1b7>] show_stack_log_lvl+0x57/0xf0
 [<c102c308>] show_registers+0xb8/0x1d0
 [<c102cf41>] __die+0x91/0x100
 [<c104c712>] no_context+0x92/0x150
 [<c104c867>] __bad_area_nosemaphore+0x97/0x140
 [<c13c4604>] ? __const_udelay+0x24/0x30
 [<c158a2a5>] ? wait_for_xmitr+0x55/0xb0
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104c927>] bad_area_nosemaphore+0x17/0x20
 [<c104cf24>] do_page_fault+0x334/0x3f0
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c1e6df53>] error_code+0x63/0x70
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c102d475>] ? print_context_stack+0x55/0x130
 [<c102c0ff>] dump_trace+0xaf/0x110
 [<c102d2c7>] show_trace_log_lvl+0x47/0x50
 [<c102c1b7>] show_stack_log_lvl+0x57/0xf0
 [<c102c308>] show_registers+0xb8/0x1d0
 [<c102cf41>] __die+0x91/0x100
 [<c104c712>] no_context+0x92/0x150
 [<c104c867>] __bad_area_nosemaphore+0x97/0x140
 [<c105fe0b>] ? release_console_sem+0x20b/0x220
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104c927>] bad_area_nosemaphore+0x17/0x20
 [<c104cf24>] do_page_fault+0x334/0x3f0
 [<c18e1690>] ? write_msg+0x0/0x120
 [<c105f193>] ? __call_console_drivers+0x43/0x50
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c1e6df53>] error_code+0x63/0x70
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c102d4a6>] ? print_context_stack+0x86/0x130
 [<c10349df>] ? save_stack_trace+0x2f/0x50
 [<c102c0ff>] dump_trace+0xaf/0x110
 [<c102d2c7>] show_trace_log_lvl+0x47/0x50
 [<c102c1b7>] show_stack_log_lvl+0x57/0xf0
 [<c102c308>] show_registers+0xb8/0x1d0
 [<c102cf41>] __die+0x91/0x100
 [<c104c712>] no_context+0x92/0x150
 [<c104c867>] __bad_area_nosemaphore+0x97/0x140
 [<c105fe0b>] ? release_console_sem+0x20b/0x220
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104c927>] bad_area_nosemaphore+0x17/0x20
 [<c104cf24>] do_page_fault+0x334/0x3f0
 [<c18e1690>] ? write_msg+0x0/0x120
 [<c105f193>] ? __call_console_drivers+0x43/0x50
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c1e6df53>] error_code+0x63/0x70
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c102d4a6>] ? print_context_stack+0x86/0x130
 [<c10349df>] ? save_stack_trace+0x2f/0x50
 [<c102c0ff>] dump_trace+0xaf/0x110
 [<c102d2c7>] show_trace_log_lvl+0x47/0x50
 [<c102c1b7>] show_stack_log_lvl+0x57/0xf0
 [<c102c308>] show_registers+0xb8/0x1d0
 [<c102cf41>] __die+0x91/0x100
 [<c104c712>] no_context+0x92/0x150
 [<c104c867>] __bad_area_nosemaphore+0x97/0x140
 [<c105fe0b>] ? release_console_sem+0x20b/0x220
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104c927>] bad_area_nosemaphore+0x17/0x20
 [<c104cf24>] do_page_fault+0x334/0x3f0
 [<c18e1690>] ? write_msg+0x0/0x120
 [<c105f193>] ? __call_console_drivers+0x43/0x50
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c1e6df53>] error_code+0x63/0x70
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c102d4a6>] ? print_context_stack+0x86/0x130
 [<c10349df>] ? save_stack_trace+0x2f/0x50
 [<c102c0ff>] dump_trace+0xaf/0x110
 [<c102d2c7>] show_trace_log_lvl+0x47/0x50
 [<c102c1b7>] show_stack_log_lvl+0x57/0xf0
 [<c102c308>] show_registers+0xb8/0x1d0
 [<c102cf41>] __die+0x91/0x100
 [<c104c712>] no_context+0x92/0x150
 [<c104c867>] __bad_area_nosemaphore+0x97/0x140
 [<c105fe0b>] ? release_console_sem+0x20b/0x220
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104c927>] bad_area_nosemaphore+0x17/0x20
 [<c104cf24>] do_page_fault+0x334/0x3f0
 [<c18e1690>] ? write_msg+0x0/0x120
 [<c105f193>] ? __call_console_drivers+0x43/0x50
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c1e6df53>] error_code+0x63/0x70
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c102d4a6>] ? print_context_stack+0x86/0x130
 [<c10349df>] ? save_stack_trace+0x2f/0x50
 [<c102c0ff>] dump_trace+0xaf/0x110
 [<c102d2c7>] show_trace_log_lvl+0x47/0x50
 [<c102c1b7>] show_stack_log_lvl+0x57/0xf0
 [<c102c308>] show_registers+0xb8/0x1d0
 [<c102cf41>] __die+0x91/0x100
 [<c104c712>] no_context+0x92/0x150
 [<c104c867>] __bad_area_nosemaphore+0x97/0x140
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104c927>] bad_area_nosemaphore+0x17/0x20
 [<c104cf24>] do_page_fault+0x334/0x3f0
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c1e6df53>] error_code+0x63/0x70
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c102d4a6>] ? print_context_stack+0x86/0x130
 [<c10349df>] ? save_stack_trace+0x2f/0x50
 [<c102c0ff>] dump_trace+0xaf/0x110
 [<c10349df>] save_stack_trace+0x2f/0x50
 [<c13d4119>] dma_entry_alloc+0x69/0xc0
 [<c13d5354>] debug_dma_map_sg+0x94/0x150
 [<c165d528>] ? ata_scsi_rw_xlat+0x1d8/0x290
 [<c1655e4d>] ata_qc_issue+0x14d/0x300
 [<c165bb1b>] ata_scsi_translate+0x7b/0x150
 [<c10ecaa7>] ? slab_pad_check+0x37/0x1a0
 [<c15f3480>] ? scsi_done+0x0/0x40
 [<c15f3480>] ? scsi_done+0x0/0x40
 [<c165f004>] ata_scsi_queuecmd+0x84/0x260
 [<c165d350>] ? ata_scsi_rw_xlat+0x0/0x290
 [<c15f45c7>] scsi_dispatch_cmd+0xc7/0x250
 [<c15f991e>] scsi_request_fn+0x39e/0x480
 [<c10ee9c3>] ? __slab_free+0x1c3/0x240
 [<c13a7e7a>] __blk_run_queue+0x3a/0x70
 [<c13a989f>] blk_run_queue+0x1f/0x40
 [<c15fa798>] scsi_run_queue+0xb8/0x2d0
 [<c1597d14>] ? put_device+0x14/0x20
 [<c15f411d>] ? __scsi_put_command+0x4d/0x80
 [<c15faafd>] scsi_next_command+0x2d/0x40
 [<c15faf08>] scsi_io_completion+0x2b8/0x5b0
 [<c10ee9c3>] ? __slab_free+0x1c3/0x240
 [<c15f346a>] scsi_finish_command+0xaa/0xc0
 [<c15fb317>] scsi_softirq_done+0xf7/0x120
 [<c109c377>] ? __rcu_process_callbacks+0x47/0x470
 [<c13adb5a>] blk_done_softirq+0x6a/0x80
 [<c106471c>] __do_softirq+0x8c/0x1b0
 [<c1064690>] ? __do_softirq+0x0/0x1b0
 [<c102bfb4>] do_softirq+0x84/0xc0
 <IRQ> 
 [<c102d2c7>] ? show_trace_log_lvl+0x47/0x50
 [<c102c1b7>] ? show_stack_log_lvl+0x57/0xf0
 [<c102c308>] ? show_registers+0xb8/0x1d0
 [<c102cf41>] ? __die+0x91/0x100
 [<c104c712>] ? no_context+0x92/0x150
 [<c104c867>] ? __bad_area_nosemaphore+0x97/0x140
 [<c13c4604>] ? __const_udelay+0x24/0x30
 [<c158a2a5>] ? wait_for_xmitr+0x55/0xb0
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104c927>] ? bad_area_nosemaphore+0x17/0x20
 [<c104cf24>] ? do_page_fault+0x334/0x3f0
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c1e6df53>] ? error_code+0x63/0x70
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c102d475>] ? print_context_stack+0x55/0x130
 [<c102c0ff>] ? dump_trace+0xaf/0x110
 [<c102d2c7>] ? show_trace_log_lvl+0x47/0x50
 [<c102c1b7>] ? show_stack_log_lvl+0x57/0xf0
 [<c102c308>] ? show_registers+0xb8/0x1d0
 [<c102cf41>] ? __die+0x91/0x100
 [<c104c712>] ? no_context+0x92/0x150
 [<c104c867>] ? __bad_area_nosemaphore+0x97/0x140
 [<c105fe0b>] ? release_console_sem+0x20b/0x220
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104c927>] ? bad_area_nosemaphore+0x17/0x20
 [<c104cf24>] ? do_page_fault+0x334/0x3f0
 [<c18e1690>] ? write_msg+0x0/0x120
 [<c105f193>] ? __call_console_drivers+0x43/0x50
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c1e6df53>] ? error_code+0x63/0x70
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c102d4a6>] ? print_context_stack+0x86/0x130
 [<c10349df>] ? save_stack_trace+0x2f/0x50
 [<c102c0ff>] ? dump_trace+0xaf/0x110
 [<c102d2c7>] ? show_trace_log_lvl+0x47/0x50
 [<c102c1b7>] ? show_stack_log_lvl+0x57/0xf0
 [<c102c308>] ? show_registers+0xb8/0x1d0
 [<c102cf41>] ? __die+0x91/0x100
 [<c104c712>] ? no_context+0x92/0x150
 [<c104c867>] ? __bad_area_nosemaphore+0x97/0x140
 [<c105fe0b>] ? release_console_sem+0x20b/0x220
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104c927>] ? bad_area_nosemaphore+0x17/0x20
 [<c104cf24>] ? do_page_fault+0x334/0x3f0
 [<c18e1690>] ? write_msg+0x0/0x120
 [<c105f193>] ? __call_console_drivers+0x43/0x50
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c1e6df53>] ? error_code+0x63/0x70
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c102d4a6>] ? print_context_stack+0x86/0x130
 [<c10349df>] ? save_stack_trace+0x2f/0x50
 [<c102c0ff>] ? dump_trace+0xaf/0x110
 [<c102d2c7>] ? show_trace_log_lvl+0x47/0x50
 [<c102c1b7>] ? show_stack_log_lvl+0x57/0xf0
 [<c102c308>] ? show_registers+0xb8/0x1d0
 [<c102cf41>] ? __die+0x91/0x100
 [<c104c712>] ? no_context+0x92/0x150
 [<c104c867>] ? __bad_area_nosemaphore+0x97/0x140
 [<c105fe0b>] ? release_console_sem+0x20b/0x220
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104c927>] ? bad_area_nosemaphore+0x17/0x20
 [<c104cf24>] ? do_page_fault+0x334/0x3f0
 [<c18e1690>] ? write_msg+0x0/0x120
 [<c105f193>] ? __call_console_drivers+0x43/0x50
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c1e6df53>] ? error_code+0x63/0x70
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c102d4a6>] ? print_context_stack+0x86/0x130
 [<c10349df>] ? save_stack_trace+0x2f/0x50
 [<c102c0ff>] ? dump_trace+0xaf/0x110
 [<c102d2c7>] ? show_trace_log_lvl+0x47/0x50
 [<c102c1b7>] ? show_stack_log_lvl+0x57/0xf0
 [<c102c308>] ? show_registers+0xb8/0x1d0
 [<c102cf41>] ? __die+0x91/0x100
 [<c104c712>] ? no_context+0x92/0x150
 [<c104c867>] ? __bad_area_nosemaphore+0x97/0x140
 [<c105fe0b>] ? release_console_sem+0x20b/0x220
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104c927>] ? bad_area_nosemaphore+0x17/0x20
 [<c104cf24>] ? do_page_fault+0x334/0x3f0
 [<c18e1690>] ? write_msg+0x0/0x120
 [<c105f193>] ? __call_console_drivers+0x43/0x50
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c1e6df53>] ? error_code+0x63/0x70
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c102d4a6>] ? print_context_stack+0x86/0x130
 [<c10349df>] ? save_stack_trace+0x2f/0x50
 [<c102c0ff>] ? dump_trace+0xaf/0x110
 [<c102d2c7>] ? show_trace_log_lvl+0x47/0x50
 [<c102c1b7>] ? show_stack_log_lvl+0x57/0xf0
 [<c102c308>] ? show_registers+0xb8/0x1d0
 [<c102cf41>] ? __die+0x91/0x100
 [<c104c712>] ? no_context+0x92/0x150
 [<c104c867>] ? __bad_area_nosemaphore+0x97/0x140
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104c927>] ? bad_area_nosemaphore+0x17/0x20
 [<c104cf24>] ? do_page_fault+0x334/0x3f0
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c1e6df53>] ? error_code+0x63/0x70
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c102d4a6>] ? print_context_stack+0x86/0x130
 [<c10349df>] ? save_stack_trace+0x2f/0x50
 [<c102c0ff>] ? dump_trace+0xaf/0x110
 [<c10349df>] ? save_stack_trace+0x2f/0x50
 [<c13d4119>] ? dma_entry_alloc+0x69/0xc0
 [<c13d5354>] ? debug_dma_map_sg+0x94/0x150
 [<c165d528>] ? ata_scsi_rw_xlat+0x1d8/0x290
 [<c1655e4d>] ? ata_qc_issue+0x14d/0x300
 [<c165bb1b>] ? ata_scsi_translate+0x7b/0x150
 [<c10ecaa7>] ? slab_pad_check+0x37/0x1a0
 [<c15f3480>] ? scsi_done+0x0/0x40
 [<c15f3480>] ? scsi_done+0x0/0x40
 [<c165f004>] ? ata_scsi_queuecmd+0x84/0x260
 [<c165d350>] ? ata_scsi_rw_xlat+0x0/0x290
 [<c15f45c7>] ? scsi_dispatch_cmd+0xc7/0x250
 [<c15f991e>] ? scsi_request_fn+0x39e/0x480
 [<c10ee9c3>] ? __slab_free+0x1c3/0x240
 [<c13a7e7a>] ? __blk_run_queue+0x3a/0x70
 [<c13a989f>] ? blk_run_queue+0x1f/0x40
 [<c15fa798>] ? scsi_run_queue+0xb8/0x2d0
 [<c1597d14>] ? put_device+0x14/0x20
 [<c15f411d>] ? __scsi_put_command+0x4d/0x80
 [<c15faafd>] ? scsi_next_command+0x2d/0x40
 [<c15faf08>] ? scsi_io_completion+0x2b8/0x5b0
 [<c10ee9c3>] ? __slab_free+0x1c3/0x240
 [<c15f346a>] ? scsi_finish_command+0xaa/0xc0
 [<c15fb317>] ? scsi_softirq_done+0xf7/0x120
 [<c109c377>] ? __rcu_process_callbacks+0x47/0x470
 [<c13adb5a>] ? blk_done_softirq+0x6a/0x80
 [<c106471c>] ? __do_softirq+0x8c/0x1b0
 [<c1064690>] ? __do_softirq+0x0/0x1b0
 [<c102bfb4>] ? do_softirq+0x84/0xc0
 <IRQ> 
 [<c102d2c7>] ? show_trace_log_lvl+0x47/0x50
 [<c102c1b7>] ? show_stack_log_lvl+0x57/0xf0
 [<c102c308>] ? show_registers+0xb8/0x1d0
 [<c102cf41>] ? __die+0x91/0x100
 [<c104c712>] ? no_context+0x92/0x150
 [<c104c867>] ? __bad_area_nosemaphore+0x97/0x140
 [<c13c4604>] ? __const_udelay+0x24/0x30
 [<c158a2a5>] ? wait_for_xmitr+0x55/0xb0
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104c927>] ? bad_area_nosemaphore+0x17/0x20
 [<c104cf24>] ? do_page_fault+0x334/0x3f0
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c1e6df53>] ? error_code+0x63/0x70
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c102d475>] ? print_context_stack+0x55/0x130
 [<c102c0ff>] ? dump_trace+0xaf/0x110
 [<c102d2c7>] ? show_trace_log_lvl+0x47/0x50
 [<c102c1b7>] ? show_stack_log_lvl+0x57/0xf0
 [<c102c308>] ? show_registers+0xb8/0x1d0
 [<c102cf41>] ? __die+0x91/0x100
 [<c104c712>] ? no_context+0x92/0x150
 [<c104c867>] ? __bad_area_nosemaphore+0x97/0x140
 [<c105fe0b>] ? release_console_sem+0x20b/0x220
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104c927>] ? bad_area_nosemaphore+0x17/0x20
 [<c104cf24>] ? do_page_fault+0x334/0x3f0
 [<c18e1690>] ? write_msg+0x0/0x120
 [<c105f193>] ? __call_console_drivers+0x43/0x50
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c1e6df53>] ? error_code+0x63/0x70
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c102d4a6>] ? print_context_stack+0x86/0x130
 [<c10349df>] ? save_stack_trace+0x2f/0x50
 [<c102c0ff>] ? dump_trace+0xaf/0x110
 [<c102d2c7>] ? show_trace_log_lvl+0x47/0x50
 [<c102c1b7>] ? show_stack_log_lvl+0x57/0xf0
 [<c102c308>] ? show_registers+0xb8/0x1d0
 [<c102cf41>] ? __die+0x91/0x100
 [<c104c712>] ? no_context+0x92/0x150
 [<c104c867>] ? __bad_area_nosemaphore+0x97/0x140
 [<c105fe0b>] ? release_console_sem+0x20b/0x220
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104c927>] ? bad_area_nosemaphore+0x17/0x20
 [<c104cf24>] ? do_page_fault+0x334/0x3f0
 [<c18e1690>] ? write_msg+0x0/0x120
 [<c105f193>] ? __call_console_drivers+0x43/0x50
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c1e6df53>] ? error_code+0x63/0x70
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c102d4a6>] ? print_context_stack+0x86/0x130
 [<c10349df>] ? save_stack_trace+0x2f/0x50
 [<c102c0ff>] ? dump_trace+0xaf/0x110
 [<c102d2c7>] ? show_trace_log_lvl+0x47/0x50
 [<c102c1b7>] ? show_stack_log_lvl+0x57/0xf0
 [<c102c308>] ? show_registers+0xb8/0x1d0
 [<c102cf41>] ? __die+0x91/0x100
 [<c104c712>] ? no_context+0x92/0x150
 [<c104c867>] ? __bad_area_nosemaphore+0x97/0x140
 [<c105fe0b>] ? release_console_sem+0x20b/0x220
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104c927>] ? bad_area_nosemaphore+0x17/0x20
 [<c104cf24>] ? do_page_fault+0x334/0x3f0
 [<c18e1690>] ? write_msg+0x0/0x120
 [<c105f193>] ? __call_console_drivers+0x43/0x50
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c1e6df53>] ? error_code+0x63/0x70
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c102d4a6>] ? print_context_stack+0x86/0x130
 [<c10349df>] ? save_stack_trace+0x2f/0x50
 [<c102c0ff>] ? dump_trace+0xaf/0x110
 [<c102d2c7>] ? show_trace_log_lvl+0x47/0x50
 [<c102c1b7>] ? show_stack_log_lvl+0x57/0xf0
 [<c102c308>] ? show_registers+0xb8/0x1d0
 [<c102cf41>] ? __die+0x91/0x100
 [<c104c712>] ? no_context+0x92/0x150
 [<c104c867>] ? __bad_area_nosemaphore+0x97/0x140
 [<c105fe0b>] ? release_console_sem+0x20b/0x220
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104c927>] ? bad_area_nosemaphore+0x17/0x20
 [<c104cf24>] ? do_page_fault+0x334/0x3f0
 [<c18e1690>] ? write_msg+0x0/0x120
 [<c105f193>] ? __call_console_drivers+0x43/0x50
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c1e6df53>] ? error_code+0x63/0x70
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c102d4a6>] ? print_context_stack+0x86/0x130
 [<c10349df>] ? save_stack_trace+0x2f/0x50
 [<c102c0ff>] ? dump_trace+0xaf/0x110
 [<c102d2c7>] ? show_trace_log_lvl+0x47/0x50
 [<c102c1b7>] ? show_stack_log_lvl+0x57/0xf0
 [<c102c308>] ? show_registers+0xb8/0x1d0
 [<c102cf41>] ? __die+0x91/0x100
 [<c104c712>] ? no_context+0x92/0x150
 [<c104c867>] ? __bad_area_nosemaphore+0x97/0x140
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104c927>] ? bad_area_nosemaphore+0x17/0x20
 [<c104cf24>] ? do_page_fault+0x334/0x3f0
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c1e6df53>] ? error_code+0x63/0x70
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c102d4a6>] ? print_context_stack+0x86/0x130
 [<c10349df>] ? save_stack_trace+0x2f/0x50
 [<c102c0ff>] ? dump_trace+0xaf/0x110
 [<c10349df>] ? save_stack_trace+0x2f/0x50
 [<c13d4119>] ? dma_entry_alloc+0x69/0xc0
 [<c13d5354>] ? debug_dma_map_sg+0x94/0x150
 [<c165d528>] ? ata_scsi_rw_xlat+0x1d8/0x290
 [<c1655e4d>] ? ata_qc_issue+0x14d/0x300
 [<c165bb1b>] ? ata_scsi_translate+0x7b/0x150
 [<c10ecaa7>] ? slab_pad_check+0x37/0x1a0
 [<c15f3480>] ? scsi_done+0x0/0x40
 [<c15f3480>] ? scsi_done+0x0/0x40
 [<c165f004>] ? ata_scsi_queuecmd+0x84/0x260
 [<c165d350>] ? ata_scsi_rw_xlat+0x0/0x290
 [<c15f45c7>] ? scsi_dispatch_cmd+0xc7/0x250
 [<c15f991e>] ? scsi_request_fn+0x39e/0x480
 [<c10ee9c3>] ? __slab_free+0x1c3/0x240
 [<c13a7e7a>] ? __blk_run_queue+0x3a/0x70
 [<c13a989f>] ? blk_run_queue+0x1f/0x40
 [<c15fa798>] ? scsi_run_queue+0xb8/0x2d0
 [<c1597d14>] ? put_device+0x14/0x20
 [<c15f411d>] ? __scsi_put_command+0x4d/0x80
 [<c15faafd>] ? scsi_next_command+0x2d/0x40
 [<c15faf08>] ? scsi_io_completion+0x2b8/0x5b0
 [<c10ee9c3>] ? __slab_free+0x1c3/0x240
 [<c15f346a>] ? scsi_finish_command+0xaa/0xc0
 [<c15fb317>] ? scsi_softirq_done+0xf7/0x120
 [<c109c377>] ? __rcu_process_callbacks+0x47/0x470
 [<c13adb5a>] ? blk_done_softirq+0x6a/0x80
 [<c106471c>] ? __do_softirq+0x8c/0x1b0
 [<c1064690>] ? __do_softirq+0x0/0x1b0
 [<c102bfb4>] ? do_softirq+0x84/0xc0
 <IRQ> 
 [<c102d2c7>] ? show_trace_log_lvl+0x47/0x50
 [<c102c1b7>] ? show_stack_log_lvl+0x57/0xf0
 [<c102c308>] ? show_registers+0xb8/0x1d0
 [<c102cf41>] ? __die+0x91/0x100
 [<c104c712>] ? no_context+0x92/0x150
 [<c104c867>] ? __bad_area_nosemaphore+0x97/0x140
 [<c13c4604>] ? __const_udelay+0x24/0x30
 [<c158a2a5>] ? wait_for_xmitr+0x55/0xb0
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104c927>] ? bad_area_nosemaphore+0x17/0x20
 [<c104cf24>] ? do_page_fault+0x334/0x3f0
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c1e6df53>] ? error_code+0x63/0x70
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c102d475>] ? print_context_stack+0x55/0x130
 [<c102c0ff>] ? dump_trace+0xaf/0x110
 [<c102d2c7>] ? show_trace_log_lvl+0x47/0x50
 [<c102c1b7>] ? show_stack_log_lvl+0x57/0xf0
 [<c102c308>] ? show_registers+0xb8/0x1d0
 [<c102cf41>] ? __die+0x91/0x100
 [<c104c712>] ? no_context+0x92/0x150
 [<c104c867>] ? __bad_area_nosemaphore+0x97/0x140
 [<c105fe0b>] ? release_console_sem+0x20b/0x220
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104c927>] ? bad_area_nosemaphore+0x17/0x20
 [<c104cf24>] ? do_page_fault+0x334/0x3f0
 [<c18e1690>] ? write_msg+0x0/0x120
 [<c105f193>] ? __call_console_drivers+0x43/0x50
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c1e6df53>] ? error_code+0x63/0x70
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c102d4a6>] ? print_context_stack+0x86/0x130
 [<c10349df>] ? save_stack_trace+0x2f/0x50
 [<c102c0ff>] ? dump_trace+0xaf/0x110
 [<c102d2c7>] ? show_trace_log_lvl+0x47/0x50
 [<c102c1b7>] ? show_stack_log_lvl+0x57/0xf0
 [<c102c308>] ? show_registers+0xb8/0x1d0
 [<c102cf41>] ? __die+0x91/0x100
 [<c104c712>] ? no_context+0x92/0x150
 [<c104c867>] ? __bad_area_nosemaphore+0x97/0x140
 [<c105fe0b>] ? release_console_sem+0x20b/0x220
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104c927>] ? bad_area_nosemaphore+0x17/0x20
 [<c104cf24>] ? do_page_fault+0x334/0x3f0
 [<c18e1690>] ? write_msg+0x0/0x120
 [<c105f193>] ? __call_console_drivers+0x43/0x50
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c1e6df53>] ? error_code+0x63/0x70
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c102d4a6>] ? print_context_stack+0x86/0x130
 [<c10349df>] ? save_stack_trace+0x2f/0x50
 [<c102c0ff>] ? dump_trace+0xaf/0x110
 [<c102d2c7>] ? show_trace_log_lvl+0x47/0x50
 [<c102c1b7>] ? show_stack_log_lvl+0x57/0xf0
 [<c102c308>] ? show_registers+0xb8/0x1d0
 [<c102cf41>] ? __die+0x91/0x100
 [<c104c712>] ? no_context+0x92/0x150
 [<c104c867>] ? __bad_area_nosemaphore+0x97/0x140
 [<c105fe0b>] ? release_console_sem+0x20b/0x220
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104c927>] ? bad_area_nosemaphore+0x17/0x20
 [<c104cf24>] ? do_page_fault+0x334/0x3f0
 [<c18e1690>] ? write_msg+0x0/0x120
 [<c105f193>] ? __call_console_drivers+0x43/0x50
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c1e6df53>] ? error_code+0x63/0x70
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c102d4a6>] ? print_context_stack+0x86/0x130
 [<c10349df>] ? save_stack_trace+0x2f/0x50
 [<c102c0ff>] ? dump_trace+0xaf/0x110
 [<c102d2c7>] ? show_trace_log_lvl+0x47/0x50
 [<c102c1b7>] ? show_stack_log_lvl+0x57/0xf0
 [<c102c308>] ? show_registers+0xb8/0x1d0
 [<c102cf41>] ? __die+0x91/0x100
 [<c104c712>] ? no_context+0x92/0x150
 [<c104c867>] ? __bad_area_nosemaphore+0x97/0x140
 [<c105fe0b>] ? release_console_sem+0x20b/0x220
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104c927>] ? bad_area_nosemaphore+0x17/0x20
 [<c104cf24>] ? do_page_fault+0x334/0x3f0
 [<c18e1690>] ? write_msg+0x0/0x120
 [<c105f193>] ? __call_console_drivers+0x43/0x50
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c1e6df53>] ? error_code+0x63/0x70
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c102d4a6>] ? print_context_stack+0x86/0x130
 [<c10349df>] ? save_stack_trace+0x2f/0x50
 [<c102c0ff>] ? dump_trace+0xaf/0x110
 [<c102d2c7>] ? show_trace_log_lvl+0x47/0x50
 [<c102c1b7>] ? show_stack_log_lvl+0x57/0xf0
 [<c102c308>] ? show_registers+0xb8/0x1d0
 [<c102cf41>] ? __die+0x91/0x100
 [<c104c712>] ? no_context+0x92/0x150
 [<c104c867>] ? __bad_area_nosemaphore+0x97/0x140
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104c927>] ? bad_area_nosemaphore+0x17/0x20
 [<c104cf24>] ? do_page_fault+0x334/0x3f0
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c1e6df53>] ? error_code+0x63/0x70
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c102d4a6>] ? print_context_stack+0x86/0x130
 [<c10349df>] ? save_stack_trace+0x2f/0x50
 [<c102c0ff>] ? dump_trace+0xaf/0x110
 [<c10349df>] ? save_stack_trace+0x2f/0x50
 [<c13d4119>] ? dma_entry_alloc+0x69/0xc0
 [<c13d5354>] ? debug_dma_map_sg+0x94/0x150
 [<c165d528>] ? ata_scsi_rw_xlat+0x1d8/0x290
 [<c1655e4d>] ? ata_qc_issue+0x14d/0x300
 [<c165bb1b>] ? ata_scsi_translate+0x7b/0x150
 [<c10ecaa7>] ? slab_pad_check+0x37/0x1a0
 [<c15f3480>] ? scsi_done+0x0/0x40
 [<c15f3480>] ? scsi_done+0x0/0x40
 [<c165f004>] ? ata_scsi_queuecmd+0x84/0x260
 [<c165d350>] ? ata_scsi_rw_xlat+0x0/0x290
 [<c15f45c7>] ? scsi_dispatch_cmd+0xc7/0x250
 [<c15f991e>] ? scsi_request_fn+0x39e/0x480
 [<c10ee9c3>] ? __slab_free+0x1c3/0x240
 [<c13a7e7a>] ? __blk_run_queue+0x3a/0x70
 [<c13a989f>] ? blk_run_queue+0x1f/0x40
 [<c15fa798>] ? scsi_run_queue+0xb8/0x2d0
 [<c1597d14>] ? put_device+0x14/0x20
 [<c15f411d>] ? __scsi_put_command+0x4d/0x80
 [<c15faafd>] ? scsi_next_command+0x2d/0x40
 [<c15faf08>] ? scsi_io_completion+0x2b8/0x5b0
 [<c10ee9c3>] ? __slab_free+0x1c3/0x240
 [<c15f346a>] ? scsi_finish_command+0xaa/0xc0
 [<c15fb317>] ? scsi_softirq_done+0xf7/0x120
 [<c109c377>] ? __rcu_process_callbacks+0x47/0x470
 [<c13adb5a>] ? blk_done_softirq+0x6a/0x80
 [<c106471c>] ? __do_softirq+0x8c/0x1b0
 [<c1064690>] ? __do_softirq+0x0/0x1b0
 [<c102bfb4>] ? do_softirq+0x84/0xc0
 <IRQ> 
 [<c102d2c7>] ? show_trace_log_lvl+0x47/0x50
 [<c102c1b7>] ? show_stack_log_lvl+0x57/0xf0
 [<c102c308>] ? show_registers+0xb8/0x1d0
 [<c102cf41>] ? __die+0x91/0x100
 [<c104c712>] ? no_context+0x92/0x150
 [<c104c867>] ? __bad_area_nosemaphore+0x97/0x140
 [<c13c4604>] ? __const_udelay+0x24/0x30
 [<c158a2a5>] ? wait_for_xmitr+0x55/0xb0
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104c927>] ? bad_area_nosemaphore+0x17/0x20
 [<c104cf24>] ? do_page_fault+0x334/0x3f0
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c1e6df53>] ? error_code+0x63/0x70
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c102d475>] ? print_context_stack+0x55/0x130
 [<c102c0ff>] ? dump_trace+0xaf/0x110
 [<c102d2c7>] ? show_trace_log_lvl+0x47/0x50
 [<c102c1b7>] ? show_stack_log_lvl+0x57/0xf0
 [<c102c308>] ? show_registers+0xb8/0x1d0
 [<c102cf41>] ? __die+0x91/0x100
 [<c104c712>] ? no_context+0x92/0x150
 [<c104c867>] ? __bad_area_nosemaphore+0x97/0x140
 [<c105fe0b>] ? release_console_sem+0x20b/0x220
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104c927>] ? bad_area_nosemaphore+0x17/0x20
 [<c104cf24>] ? do_page_fault+0x334/0x3f0
 [<c18e1690>] ? write_msg+0x0/0x120
 [<c105f193>] ? __call_console_drivers+0x43/0x50
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c1e6df53>] ? error_code+0x63/0x70
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c102d4a6>] ? print_context_stack+0x86/0x130
 [<c10349df>] ? save_stack_trace+0x2f/0x50
 [<c102c0ff>] ? dump_trace+0xaf/0x110
 [<c102d2c7>] ? show_trace_log_lvl+0x47/0x50
 [<c102c1b7>] ? show_stack_log_lvl+0x57/0xf0
 [<c102c308>] ? show_registers+0xb8/0x1d0
 [<c102cf41>] ? __die+0x91/0x100
 [<c104c712>] ? no_context+0x92/0x150
 [<c104c867>] ? __bad_area_nosemaphore+0x97/0x140
 [<c105fe0b>] ? release_console_sem+0x20b/0x220
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104c927>] ? bad_area_nosemaphore+0x17/0x20
 [<c104cf24>] ? do_page_fault+0x334/0x3f0
 [<c18e1690>] ? write_msg+0x0/0x120
 [<c105f193>] ? __call_console_drivers+0x43/0x50
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c1e6df53>] ? error_code+0x63/0x70
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c102d4a6>] ? print_context_stack+0x86/0x130
 [<c10349df>] ? save_stack_trace+0x2f/0x50
 [<c102c0ff>] ? dump_trace+0xaf/0x110
 [<c102d2c7>] ? show_trace_log_lvl+0x47/0x50
 [<c102c1b7>] ? show_stack_log_lvl+0x57/0xf0
 [<c102c308>] ? show_registers+0xb8/0x1d0
 [<c102cf41>] ? __die+0x91/0x100
 [<c104c712>] ? no_context+0x92/0x150
 [<c104c867>] ? __bad_area_nosemaphore+0x97/0x140
 [<c105fe0b>] ? release_console_sem+0x20b/0x220
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104c927>] ? bad_area_nosemaphore+0x17/0x20
 [<c104cf24>] ? do_page_fault+0x334/0x3f0
 [<c18e1690>] ? write_msg+0x0/0x120
 [<c105f193>] ? __call_console_drivers+0x43/0x50
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c1e6df53>] ? error_code+0x63/0x70
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c102d4a6>] ? print_context_stack+0x86/0x130
 [<c10349df>] ? save_stack_trace+0x2f/0x50
 [<c102c0ff>] ? dump_trace+0xaf/0x110
 [<c102d2c7>] ? show_trace_log_lvl+0x47/0x50
 [<c102c1b7>] ? show_stack_log_lvl+0x57/0xf0
 [<c102c308>] ? show_registers+0xb8/0x1d0
 [<c102cf41>] ? __die+0x91/0x100
 [<c104c712>] ? no_context+0x92/0x150
 [<c104c867>] ? __bad_area_nosemaphore+0x97/0x140
 [<c105fe0b>] ? release_console_sem+0x20b/0x220
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104c927>] ? bad_area_nosemaphore+0x17/0x20
 [<c104cf24>] ? do_page_fault+0x334/0x3f0
 [<c18e1690>] ? write_msg+0x0/0x120
 [<c105f193>] ? __call_console_drivers+0x43/0x50
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c1e6df53>] ? error_code+0x63/0x70
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c102d4a6>] ? print_context_stack+0x86/0x130
 [<c10349df>] ? save_stack_trace+0x2f/0x50
 [<c102c0ff>] ? dump_trace+0xaf/0x110
 [<c102d2c7>] ? show_trace_log_lvl+0x47/0x50
 [<c102c1b7>] ? show_stack_log_lvl+0x57/0xf0
 [<c102c308>] ? show_registers+0xb8/0x1d0
 [<c102cf41>] ? __die+0x91/0x100
 [<c104c712>] ? no_context+0x92/0x150
 [<c104c867>] ? __bad_area_nosemaphore+0x97/0x140
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104c927>] ? bad_area_nosemaphore+0x17/0x20
 [<c104cf24>] ? do_page_fault+0x334/0x3f0
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c1e6df53>] ? error_code+0x63/0x70
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c102d4a6>] ? print_context_stack+0x86/0x130
 [<c10349df>] ? save_stack_trace+0x2f/0x50
 [<c102c0ff>] ? dump_trace+0xaf/0x110
 [<c10349df>] ? save_stack_trace+0x2f/0x50
 [<c13d4119>] ? dma_entry_alloc+0x69/0xc0
 [<c13d5354>] ? debug_dma_map_sg+0x94/0x150
 [<c165d528>] ? ata_scsi_rw_xlat+0x1d8/0x290
 [<c1655e4d>] ? ata_qc_issue+0x14d/0x300
 [<c165bb1b>] ? ata_scsi_translate+0x7b/0x150
 [<c10ecaa7>] ? slab_pad_check+0x37/0x1a0
 [<c15f3480>] ? scsi_done+0x0/0x40
 [<c15f3480>] ? scsi_done+0x0/0x40
 [<c165f004>] ? ata_scsi_queuecmd+0x84/0x260
 [<c165d350>] ? ata_scsi_rw_xlat+0x0/0x290
 [<c15f45c7>] ? scsi_dispatch_cmd+0xc7/0x250
 [<c15f991e>] ? scsi_request_fn+0x39e/0x480
 [<c10ee9c3>] ? __slab_free+0x1c3/0x240
 [<c13a7e7a>] ? __blk_run_queue+0x3a/0x70
 [<c13a989f>] ? blk_run_queue+0x1f/0x40
 [<c15fa798>] ? scsi_run_queue+0xb8/0x2d0
 [<c1597d14>] ? put_device+0x14/0x20
 [<c15f411d>] ? __scsi_put_command+0x4d/0x80
 [<c15faafd>] ? scsi_next_command+0x2d/0x40
 [<c15faf08>] ? scsi_io_completion+0x2b8/0x5b0
 [<c10ee9c3>] ? __slab_free+0x1c3/0x240
 [<c15f346a>] ? scsi_finish_command+0xaa/0xc0
 [<c15fb317>] ? scsi_softirq_done+0xf7/0x120
 [<c109c377>] ? __rcu_process_callbacks+0x47/0x470
 [<c13adb5a>] ? blk_done_softirq+0x6a/0x80
 [<c106471c>] ? __do_softirq+0x8c/0x1b0
 [<c1064690>] ? __do_softirq+0x0/0x1b0
 [<c102bfb4>] ? do_softirq+0x84/0xc0
 <IRQ> 
 [<c102d2c7>] ? show_trace_log_lvl+0x47/0x50
 [<c102c1b7>] ? show_stack_log_lvl+0x57/0xf0
 [<c102c308>] ? show_registers+0xb8/0x1d0
 [<c102cf41>] ? __die+0x91/0x100
 [<c104c712>] ? no_context+0x92/0x150
 [<c104c867>] ? __bad_area_nosemaphore+0x97/0x140
 [<c13c4604>] ? __const_udelay+0x24/0x30
 [<c158a2a5>] ? wait_for_xmitr+0x55/0xb0
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104c927>] ? bad_area_nosemaphore+0x17/0x20
 [<c104cf24>] ? do_page_fault+0x334/0x3f0
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c1e6df53>] ? error_code+0x63/0x70
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c102d475>] ? print_context_stack+0x55/0x130
 [<c102c0ff>] ? dump_trace+0xaf/0x110
 [<c102d2c7>] ? show_trace_log_lvl+0x47/0x50
 [<c102c1b7>] ? show_stack_log_lvl+0x57/0xf0
 [<c102c308>] ? show_registers+0xb8/0x1d0
 [<c102cf41>] ? __die+0x91/0x100
 [<c104c712>] ? no_context+0x92/0x150
 [<c104c867>] ? __bad_area_nosemaphore+0x97/0x140
 [<c105fe0b>] ? release_console_sem+0x20b/0x220
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104c927>] ? bad_area_nosemaphore+0x17/0x20
 [<c104cf24>] ? do_page_fault+0x334/0x3f0
 [<c18e1690>] ? write_msg+0x0/0x120
 [<c105f193>] ? __call_console_drivers+0x43/0x50
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c1e6df53>] ? error_code+0x63/0x70
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c102d4a6>] ? print_context_stack+0x86/0x130
 [<c10349df>] ? save_stack_trace+0x2f/0x50
 [<c102c0ff>] ? dump_trace+0xaf/0x110
 [<c102d2c7>] ? show_trace_log_lvl+0x47/0x50
 [<c102c1b7>] ? show_stack_log_lvl+0x57/0xf0
 [<c102c308>] ? show_registers+0xb8/0x1d0
 [<c102cf41>] ? __die+0x91/0x100
 [<c104c712>] ? no_context+0x92/0x150
 [<c104c867>] ? __bad_area_nosemaphore+0x97/0x140
 [<c105fe0b>] ? release_console_sem+0x20b/0x220
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104c927>] ? bad_area_nosemaphore+0x17/0x20
 [<c104cf24>] ? do_page_fault+0x334/0x3f0
 [<c18e1690>] ? write_msg+0x0/0x120
 [<c105f193>] ? __call_console_drivers+0x43/0x50
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c1e6df53>] ? error_code+0x63/0x70
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c102d4a6>] ? print_context_stack+0x86/0x130
 [<c10349df>] ? save_stack_trace+0x2f/0x50
 [<c102c0ff>] ? dump_trace+0xaf/0x110
 [<c102d2c7>] ? show_trace_log_lvl+0x47/0x50
 [<c102c1b7>] ? show_stack_log_lvl+0x57/0xf0
 [<c102c308>] ? show_registers+0xb8/0x1d0
 [<c102cf41>] ? __die+0x91/0x100
 [<c104c712>] ? no_context+0x92/0x150
 [<c104c867>] ? __bad_area_nosemaphore+0x97/0x140
 [<c105fe0b>] ? release_console_sem+0x20b/0x220
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104c927>] ? bad_area_nosemaphore+0x17/0x20
 [<c104cf24>] ? do_page_fault+0x334/0x3f0
 [<c18e1690>] ? write_msg+0x0/0x120
 [<c105f193>] ? __call_console_drivers+0x43/0x50
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c1e6df53>] ? error_code+0x63/0x70
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c102d4a6>] ? print_context_stack+0x86/0x130
 [<c10349df>] ? save_stack_trace+0x2f/0x50
 [<c102c0ff>] ? dump_trace+0xaf/0x110
 [<c102d2c7>] ? show_trace_log_lvl+0x47/0x50
 [<c102c1b7>] ? show_stack_log_lvl+0x57/0xf0
 [<c102c308>] ? show_registers+0xb8/0x1d0
 [<c102cf41>] ? __die+0x91/0x100
 [<c104c712>] ? no_context+0x92/0x150
 [<c104c867>] ? __bad_area_nosemaphore+0x97/0x140
 [<c105fe0b>] ? release_console_sem+0x20b/0x220
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104c927>] ? bad_area_nosemaphore+0x17/0x20
 [<c104cf24>] ? do_page_fault+0x334/0x3f0
 [<c18e1690>] ? write_msg+0x0/0x120
 [<c105f193>] ? __call_console_drivers+0x43/0x50
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c1e6df53>] ? error_code+0x63/0x70
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c102d4a6>] ? print_context_stack+0x86/0x130
 [<c10349df>] ? save_stack_trace+0x2f/0x50
 [<c102c0ff>] ? dump_trace+0xaf/0x110
 [<c102d2c7>] ? show_trace_log_lvl+0x47/0x50
 [<c102c1b7>] ? show_stack_log_lvl+0x57/0xf0
 [<c102c308>] ? show_registers+0xb8/0x1d0
 [<c102cf41>] ? __die+0x91/0x100
 [<c104c712>] ? no_context+0x92/0x150
 [<c104c867>] ? __bad_area_nosemaphore+0x97/0x140
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104c927>] ? bad_area_nosemaphore+0x17/0x20
 [<c104cf24>] ? do_page_fault+0x334/0x3f0
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c1e6df53>] ? error_code+0x63/0x70
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c102d4a6>] ? print_context_stack+0x86/0x130
 [<c10349df>] ? save_stack_trace+0x2f/0x50
 [<c102c0ff>] ? dump_trace+0xaf/0x110
 [<c10349df>] ? save_stack_trace+0x2f/0x50
 [<c13d4119>] ? dma_entry_alloc+0x69/0xc0
 [<c13d5354>] ? debug_dma_map_sg+0x94/0x150
 [<c165d528>] ? ata_scsi_rw_xlat+0x1d8/0x290
 [<c1655e4d>] ? ata_qc_issue+0x14d/0x300
 [<c165bb1b>] ? ata_scsi_translate+0x7b/0x150
 [<c10ecaa7>] ? slab_pad_check+0x37/0x1a0
 [<c15f3480>] ? scsi_done+0x0/0x40
 [<c15f3480>] ? scsi_done+0x0/0x40
 [<c165f004>] ? ata_scsi_queuecmd+0x84/0x260
 [<c165d350>] ? ata_scsi_rw_xlat+0x0/0x290
 [<c15f45c7>] ? scsi_dispatch_cmd+0xc7/0x250
 [<c15f991e>] ? scsi_request_fn+0x39e/0x480
 [<c10ee9c3>] ? __slab_free+0x1c3/0x240
 [<c13a7e7a>] ? __blk_run_queue+0x3a/0x70
 [<c13a989f>] ? blk_run_queue+0x1f/0x40
 [<c15fa798>] ? scsi_run_queue+0xb8/0x2d0
 [<c1597d14>] ? put_device+0x14/0x20
 [<c15f411d>] ? __scsi_put_command+0x4d/0x80
 [<c15faafd>] ? scsi_next_command+0x2d/0x40
 [<c15faf08>] ? scsi_io_completion+0x2b8/0x5b0
 [<c10ee9c3>] ? __slab_free+0x1c3/0x240
 [<c15f346a>] ? scsi_finish_command+0xaa/0xc0
 [<c15fb317>] ? scsi_softirq_done+0xf7/0x120
 [<c109c377>] ? __rcu_process_callbacks+0x47/0x470
 [<c13adb5a>] ? blk_done_softirq+0x6a/0x80
 [<c106471c>] ? __do_softirq+0x8c/0x1b0
 [<c1064690>] ? __do_softirq+0x0/0x1b0
 [<c102bfb4>] ? do_softirq+0x84/0xc0
 <IRQ> 
 [<c102d2c7>] ? show_trace_log_lvl+0x47/0x50
 [<c102c1b7>] ? show_stack_log_lvl+0x57/0xf0
 [<c102c308>] ? show_registers+0xb8/0x1d0
 [<c102cf41>] ? __die+0x91/0x100
 [<c104c712>] ? no_context+0x92/0x150
 [<c104c867>] ? __bad_area_nosemaphore+0x97/0x140
 [<c13c4604>] ? __const_udelay+0x24/0x30
 [<c158a2a5>] ? wait_for_xmitr+0x55/0xb0
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104c927>] ? bad_area_nosemaphore+0x17/0x20
 [<c104cf24>] ? do_page_fault+0x334/0x3f0
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c104cbf0>] ? do_page_fault+0x0/0x3f0
 [<c1e6df53>] ? error_code+0x63/0x70

--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-Wed_Jun_30_11_10_16_CEST_2010.bad"

# 53cd4efe
#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.35-rc3
# Wed Jun 30 11:10:16 2010
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
# CONFIG_X86_64 is not set
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf32-i386"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
CONFIG_GENERIC_TIME=y
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
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_GPIO=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
# CONFIG_GENERIC_TIME_VSYSCALL is not set
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
# CONFIG_HAVE_CPUMASK_OF_CPU_MAP is not set
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
# CONFIG_ZONE_DMA32 is not set
CONFIG_ARCH_POPULATES_NODE_MAP=y
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_HAVE_EARLY_RES=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_HARDIRQS_NO__DO_IRQ=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_X86_32_LAZY_GS=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
CONFIG_KTIME_SCALAR=y
CONFIG_BOOTPARAM_SUPPORT_NOT_WANTED=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_BROKEN_BOOT_ALLOWED4=y
CONFIG_BROKEN_BOOT_ALLOWED3=y
CONFIG_BROKEN_BOOT_ALLOWED2=y
CONFIG_BROKEN_BOOT_DISALLOWED=y
CONFIG_BROKEN_BOOT_EUROPE=y
CONFIG_BROKEN_BOOT_TITAN=y
CONFIG_BROKEN_ON_SMP=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_LZO=y
# CONFIG_KERNEL_GZIP is not set
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
CONFIG_KERNEL_LZO=y
# CONFIG_SWAP is not set
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_TASKSTATS is not set
CONFIG_AUDIT=y
# CONFIG_AUDITSYSCALL is not set

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_TREE_PREEMPT_RCU is not set
# CONFIG_TINY_RCU is not set
# CONFIG_RCU_TRACE is not set
CONFIG_RCU_FANOUT=32
CONFIG_RCU_FANOUT_EXACT=y
# CONFIG_TREE_RCU_TRACE is not set
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=20
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
CONFIG_CGROUP_NS=y
CONFIG_CGROUP_FREEZER=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
# CONFIG_PROC_PID_CPUSET is not set
CONFIG_CGROUP_CPUACCT=y
# CONFIG_RESOURCE_COUNTERS is not set
CONFIG_CGROUP_SCHED=y
# CONFIG_FAIR_GROUP_SCHED is not set
CONFIG_RT_GROUP_SCHED=y
CONFIG_BLK_CGROUP=y
CONFIG_DEBUG_BLK_CGROUP=y
CONFIG_SYSFS_DEPRECATED=y
CONFIG_SYSFS_DEPRECATED_V2=y
CONFIG_RELAY=y
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
CONFIG_IPC_NS=y
# CONFIG_USER_NS is not set
# CONFIG_PID_NS is not set
CONFIG_NET_NS=y
# CONFIG_BLK_DEV_INITRD is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
# CONFIG_KALLSYMS_EXTRA_PASS is not set
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

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
CONFIG_PERF_COUNTERS=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_COMPAT_BRK is not set
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
# CONFIG_OPROFILE is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y

#
# GCOV-based kernel profiling
#
CONFIG_SLOW_WORK=y
CONFIG_SLOW_WORK_DEBUG=y
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=0
# CONFIG_MODULES is not set
CONFIG_BLOCK=y
CONFIG_LBDAF=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_INTEGRITY=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
CONFIG_CFQ_GROUP_IOSCHED=y
CONFIG_DEFAULT_DEADLINE=y
# CONFIG_DEFAULT_CFQ is not set
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="deadline"
CONFIG_PREEMPT_NOTIFIERS=y
# CONFIG_INLINE_SPIN_TRYLOCK is not set
# CONFIG_INLINE_SPIN_TRYLOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK is not set
# CONFIG_INLINE_SPIN_LOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK_IRQ is not set
# CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
CONFIG_INLINE_SPIN_UNLOCK=y
# CONFIG_INLINE_SPIN_UNLOCK_BH is not set
CONFIG_INLINE_SPIN_UNLOCK_IRQ=y
# CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_READ_TRYLOCK is not set
# CONFIG_INLINE_READ_LOCK is not set
# CONFIG_INLINE_READ_LOCK_BH is not set
# CONFIG_INLINE_READ_LOCK_IRQ is not set
# CONFIG_INLINE_READ_LOCK_IRQSAVE is not set
CONFIG_INLINE_READ_UNLOCK=y
# CONFIG_INLINE_READ_UNLOCK_BH is not set
CONFIG_INLINE_READ_UNLOCK_IRQ=y
# CONFIG_INLINE_READ_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_WRITE_TRYLOCK is not set
# CONFIG_INLINE_WRITE_LOCK is not set
# CONFIG_INLINE_WRITE_LOCK_BH is not set
# CONFIG_INLINE_WRITE_LOCK_IRQ is not set
# CONFIG_INLINE_WRITE_LOCK_IRQSAVE is not set
CONFIG_INLINE_WRITE_UNLOCK=y
# CONFIG_INLINE_WRITE_UNLOCK_BH is not set
CONFIG_INLINE_WRITE_UNLOCK_IRQ=y
# CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE is not set
# CONFIG_MUTEX_SPIN_ON_OWNER is not set
CONFIG_FREEZER=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
# CONFIG_NO_HZ is not set
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
# CONFIG_SMP_SUPPORT is not set
CONFIG_X86_MPPARSE=y
CONFIG_X86_EXTENDED_PLATFORM=y
CONFIG_X86_ELAN=y
CONFIG_X86_MRST=y
CONFIG_X86_RDC321X=y
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
CONFIG_SCHED_OMIT_FRAME_POINTER=y
# CONFIG_PARAVIRT_GUEST is not set
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
CONFIG_X86_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=4
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=4
CONFIG_X86_XADD=y
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_ALIGNMENT_16=y
CONFIG_X86_MINIMUM_CPU_FAMILY=4
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_CPU_SUP_INTEL=y
CONFIG_CPU_SUP_CYRIX_32=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
CONFIG_CPU_SUP_TRANSMETA_32=y
CONFIG_CPU_SUP_UMC_32=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_APB_TIMER=y
CONFIG_DMI=y
# CONFIG_IOMMU_HELPER is not set
# CONFIG_IOMMU_API is not set
CONFIG_NR_CPUS=1
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_X86_UP_APIC=y
CONFIG_X86_UP_IOAPIC=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_X86_ANCIENT_MCE=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=y
CONFIG_X86_THERMAL_VECTOR=y
CONFIG_VM86=y
# CONFIG_I8K is not set
CONFIG_X86_REBOOTFIXUPS=y
# CONFIG_MICROCODE is not set
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_UP_WANTED_1=y
CONFIG_UP_WANTED_2=y
CONFIG_UP_WANTED=y
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
CONFIG_PAGE_OFFSET=0xC0000000
CONFIG_HIGHMEM=y
# CONFIG_ARCH_PHYS_ADDR_T_64BIT is not set
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_DISCONTIGMEM_MANUAL is not set
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
# CONFIG_COMPACTION is not set
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
CONFIG_MEMORY_FAILURE=y
# CONFIG_HIGHPTE is not set
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_X86_RESERVE_LOW_64K=y
CONFIG_MATH_EMULATION=y
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
CONFIG_SECCOMP=y
# CONFIG_CC_STACKPROTECTOR is not set
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_X86_NEED_RELOCS=y
CONFIG_PHYSICAL_ALIGN=0x1000000
CONFIG_COMPAT_VDSO=y
CONFIG_CMDLINE_BOOL=y
CONFIG_CMDLINE=""
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
# CONFIG_PM is not set
CONFIG_SFI=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
CONFIG_CPU_FREQ_DEBUG=y
CONFIG_CPU_FREQ_STAT=y
CONFIG_CPU_FREQ_STAT_DETAILS=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=y
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# CPUFreq processor drivers
#
CONFIG_ELAN_CPUFREQ=y
CONFIG_SC520_CPUFREQ=y
CONFIG_X86_POWERNOW_K6=y
CONFIG_X86_POWERNOW_K7=y
CONFIG_X86_GX_SUSPMOD=y
CONFIG_X86_SPEEDSTEP_CENTRINO=y
CONFIG_X86_SPEEDSTEP_CENTRINO_TABLE=y
# CONFIG_X86_SPEEDSTEP_ICH is not set
CONFIG_X86_SPEEDSTEP_SMI=y
# CONFIG_X86_P4_CLOCKMOD is not set
CONFIG_X86_CPUFREQ_NFORCE2=y
CONFIG_X86_LONGRUN=y
CONFIG_X86_E_POWERSAVER=y

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y
CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK=y
# CONFIG_CPU_IDLE is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
# CONFIG_PCI_GOOLPC is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCI_CNB20LE_QUIRK=y
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=y
# CONFIG_PCIEAER is not set
CONFIG_PCIEASPM=y
CONFIG_PCIEASPM_DEBUG=y
CONFIG_ARCH_SUPPORTS_MSI=y
# CONFIG_PCI_MSI is not set
# CONFIG_PCI_STUB is not set
# CONFIG_HT_IRQ is not set
CONFIG_PCI_IOV=y
CONFIG_ISA_DMA_API=y
CONFIG_ISA=y
CONFIG_EISA=y
CONFIG_EISA_VLB_PRIMING=y
# CONFIG_EISA_PCI_EISA is not set
CONFIG_EISA_VIRTUAL_ROOT=y
# CONFIG_EISA_NAMES is not set
CONFIG_MCA=y
CONFIG_MCA_LEGACY=y
CONFIG_MCA_PROC_FS=y
# CONFIG_SCx200 is not set
# CONFIG_OLPC is not set
CONFIG_OLPC_OPENFIRMWARE=y
CONFIG_K8_NB=y
# CONFIG_PCCARD is not set
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_FAKE=y
CONFIG_HOTPLUG_PCI_COMPAQ=y
CONFIG_HOTPLUG_PCI_COMPAQ_NVRAM=y
# CONFIG_HOTPLUG_PCI_IBM is not set
# CONFIG_HOTPLUG_PCI_CPCI is not set
CONFIG_HOTPLUG_PCI_SHPC=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
CONFIG_HAVE_AOUT=y
CONFIG_BINFMT_AOUT=y
CONFIG_BINFMT_MISC=y
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_UNIX=y
CONFIG_XFRM=y
# CONFIG_XFRM_USER is not set
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
# CONFIG_XFRM_STATISTICS is not set
CONFIG_XFRM_IPCOMP=y
# CONFIG_NET_KEY is not set
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_FIB_HASH=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
CONFIG_IP_PNP_BOOTP=y
CONFIG_IP_PNP_RARP=y
CONFIG_NET_IPIP=y
# CONFIG_NET_IPGRE is not set
CONFIG_IP_MROUTE=y
# CONFIG_IP_PIMSM_V1 is not set
CONFIG_IP_PIMSM_V2=y
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
# CONFIG_INET_AH is not set
CONFIG_INET_ESP=y
CONFIG_INET_IPCOMP=y
CONFIG_INET_XFRM_TUNNEL=y
CONFIG_INET_TUNNEL=y
# CONFIG_INET_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
CONFIG_INET_XFRM_MODE_BEET=y
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=y
CONFIG_INET_TCP_DIAG=y
CONFIG_TCP_CONG_ADVANCED=y
# CONFIG_TCP_CONG_BIC is not set
CONFIG_TCP_CONG_CUBIC=y
# CONFIG_TCP_CONG_WESTWOOD is not set
CONFIG_TCP_CONG_HTCP=y
CONFIG_TCP_CONG_HSTCP=y
CONFIG_TCP_CONG_HYBLA=y
CONFIG_TCP_CONG_VEGAS=y
# CONFIG_TCP_CONG_SCALABLE is not set
CONFIG_TCP_CONG_LP=y
CONFIG_TCP_CONG_VENO=y
CONFIG_TCP_CONG_YEAH=y
CONFIG_TCP_CONG_ILLINOIS=y
# CONFIG_DEFAULT_BIC is not set
# CONFIG_DEFAULT_CUBIC is not set
# CONFIG_DEFAULT_HTCP is not set
CONFIG_DEFAULT_HYBLA=y
# CONFIG_DEFAULT_VEGAS is not set
# CONFIG_DEFAULT_VENO is not set
# CONFIG_DEFAULT_WESTWOOD is not set
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="hybla"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=y
# CONFIG_IPV6_PRIVACY is not set
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
CONFIG_IPV6_OPTIMISTIC_DAD=y
CONFIG_INET6_AH=y
# CONFIG_INET6_ESP is not set
CONFIG_INET6_IPCOMP=y
# CONFIG_IPV6_MIP6 is not set
CONFIG_INET6_XFRM_TUNNEL=y
CONFIG_INET6_TUNNEL=y
CONFIG_INET6_XFRM_MODE_TRANSPORT=y
CONFIG_INET6_XFRM_MODE_TUNNEL=y
CONFIG_INET6_XFRM_MODE_BEET=y
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=y
CONFIG_IPV6_SIT=y
# CONFIG_IPV6_SIT_6RD is not set
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=y
# CONFIG_IPV6_MULTIPLE_TABLES is not set
# CONFIG_IPV6_MROUTE is not set
CONFIG_NETLABEL=y
CONFIG_NETWORK_SECMARK=y
CONFIG_NETFILTER=y
CONFIG_NETFILTER_DEBUG=y
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=y

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=y
# CONFIG_NETFILTER_NETLINK_QUEUE is not set
CONFIG_NETFILTER_NETLINK_LOG=y
CONFIG_NF_CONNTRACK=y
CONFIG_NF_CT_ACCT=y
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_SECMARK=y
CONFIG_NF_CONNTRACK_EVENTS=y
# CONFIG_NF_CT_PROTO_DCCP is not set
CONFIG_NF_CT_PROTO_GRE=y
CONFIG_NF_CT_PROTO_SCTP=y
CONFIG_NF_CT_PROTO_UDPLITE=y
CONFIG_NF_CONNTRACK_AMANDA=y
# CONFIG_NF_CONNTRACK_FTP is not set
# CONFIG_NF_CONNTRACK_H323 is not set
CONFIG_NF_CONNTRACK_IRC=y
CONFIG_NF_CONNTRACK_NETBIOS_NS=y
CONFIG_NF_CONNTRACK_PPTP=y
CONFIG_NF_CONNTRACK_SANE=y
CONFIG_NF_CONNTRACK_SIP=y
CONFIG_NF_CONNTRACK_TFTP=y
CONFIG_NF_CT_NETLINK=y
CONFIG_NETFILTER_XTABLES=y

#
# Xtables combined modules
#
CONFIG_NETFILTER_XT_MARK=y
CONFIG_NETFILTER_XT_CONNMARK=y

#
# Xtables targets
#
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=y
CONFIG_NETFILTER_XT_TARGET_CONNMARK=y
CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=y
CONFIG_NETFILTER_XT_TARGET_LED=y
CONFIG_NETFILTER_XT_TARGET_MARK=y
CONFIG_NETFILTER_XT_TARGET_NFLOG=y
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=y
# CONFIG_NETFILTER_XT_TARGET_RATEEST is not set
CONFIG_NETFILTER_XT_TARGET_TEE=y
CONFIG_NETFILTER_XT_TARGET_SECMARK=y
# CONFIG_NETFILTER_XT_TARGET_TCPMSS is not set

#
# Xtables matches
#
CONFIG_NETFILTER_XT_MATCH_CLUSTER=y
CONFIG_NETFILTER_XT_MATCH_COMMENT=y
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=y
# CONFIG_NETFILTER_XT_MATCH_CONNLIMIT is not set
CONFIG_NETFILTER_XT_MATCH_CONNMARK=y
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=y
CONFIG_NETFILTER_XT_MATCH_DCCP=y
CONFIG_NETFILTER_XT_MATCH_DSCP=y
CONFIG_NETFILTER_XT_MATCH_ESP=y
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=y
# CONFIG_NETFILTER_XT_MATCH_HELPER is not set
CONFIG_NETFILTER_XT_MATCH_HL=y
# CONFIG_NETFILTER_XT_MATCH_IPRANGE is not set
# CONFIG_NETFILTER_XT_MATCH_LENGTH is not set
CONFIG_NETFILTER_XT_MATCH_LIMIT=y
CONFIG_NETFILTER_XT_MATCH_MAC=y
CONFIG_NETFILTER_XT_MATCH_MARK=y
# CONFIG_NETFILTER_XT_MATCH_MULTIPORT is not set
# CONFIG_NETFILTER_XT_MATCH_OSF is not set
CONFIG_NETFILTER_XT_MATCH_OWNER=y
CONFIG_NETFILTER_XT_MATCH_POLICY=y
# CONFIG_NETFILTER_XT_MATCH_PHYSDEV is not set
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=y
# CONFIG_NETFILTER_XT_MATCH_QUOTA is not set
# CONFIG_NETFILTER_XT_MATCH_RATEEST is not set
# CONFIG_NETFILTER_XT_MATCH_REALM is not set
# CONFIG_NETFILTER_XT_MATCH_RECENT is not set
# CONFIG_NETFILTER_XT_MATCH_SCTP is not set
CONFIG_NETFILTER_XT_MATCH_STATE=y
CONFIG_NETFILTER_XT_MATCH_STATISTIC=y
CONFIG_NETFILTER_XT_MATCH_STRING=y
CONFIG_NETFILTER_XT_MATCH_TCPMSS=y
CONFIG_NETFILTER_XT_MATCH_TIME=y
# CONFIG_NETFILTER_XT_MATCH_U32 is not set
CONFIG_IP_VS=y
CONFIG_IP_VS_IPV6=y
# CONFIG_IP_VS_DEBUG is not set
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=y
# CONFIG_IP_VS_PROTO_UDP is not set
CONFIG_IP_VS_PROTO_AH_ESP=y
# CONFIG_IP_VS_PROTO_ESP is not set
CONFIG_IP_VS_PROTO_AH=y
CONFIG_IP_VS_PROTO_SCTP=y

#
# IPVS scheduler
#
# CONFIG_IP_VS_RR is not set
CONFIG_IP_VS_WRR=y
CONFIG_IP_VS_LC=y
CONFIG_IP_VS_WLC=y
CONFIG_IP_VS_LBLC=y
CONFIG_IP_VS_LBLCR=y
CONFIG_IP_VS_DH=y
CONFIG_IP_VS_SH=y
# CONFIG_IP_VS_SED is not set
CONFIG_IP_VS_NQ=y

#
# IPVS application helper
#
# CONFIG_IP_VS_FTP is not set

#
# IP: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV4=y
CONFIG_NF_CONNTRACK_IPV4=y
# CONFIG_NF_CONNTRACK_PROC_COMPAT is not set
# CONFIG_IP_NF_QUEUE is not set
# CONFIG_IP_NF_IPTABLES is not set
CONFIG_IP_NF_ARPTABLES=y
CONFIG_IP_NF_ARPFILTER=y
CONFIG_IP_NF_ARP_MANGLE=y

#
# IPv6: Netfilter Configuration
#
# CONFIG_NF_CONNTRACK_IPV6 is not set
# CONFIG_IP6_NF_QUEUE is not set
# CONFIG_IP6_NF_IPTABLES is not set

#
# DECnet: Netfilter Configuration
#
CONFIG_DECNET_NF_GRABULATOR=y
# CONFIG_BRIDGE_NF_EBTABLES is not set
# CONFIG_IP_DCCP is not set
CONFIG_IP_SCTP=y
CONFIG_SCTP_DBG_MSG=y
CONFIG_SCTP_DBG_OBJCNT=y
# CONFIG_SCTP_HMAC_NONE is not set
CONFIG_SCTP_HMAC_SHA1=y
# CONFIG_SCTP_HMAC_MD5 is not set
# CONFIG_RDS is not set
CONFIG_TIPC=y
CONFIG_TIPC_ADVANCED=y
CONFIG_TIPC_ZONES=3
CONFIG_TIPC_CLUSTERS=1
CONFIG_TIPC_NODES=255
CONFIG_TIPC_PORTS=8191
CONFIG_TIPC_LOG=0
CONFIG_TIPC_DEBUG=y
CONFIG_ATM=y
CONFIG_ATM_CLIP=y
CONFIG_ATM_CLIP_NO_ICMP=y
CONFIG_ATM_LANE=y
CONFIG_ATM_MPOA=y
CONFIG_ATM_BR2684=y
CONFIG_ATM_BR2684_IPFILTER=y
# CONFIG_L2TP is not set
CONFIG_STP=y
CONFIG_BRIDGE=y
# CONFIG_BRIDGE_IGMP_SNOOPING is not set
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_DSA=y
CONFIG_NET_DSA_TAG_EDSA=y
CONFIG_NET_DSA_TAG_TRAILER=y
CONFIG_NET_DSA_MV88E6XXX=y
CONFIG_NET_DSA_MV88E6060=y
CONFIG_NET_DSA_MV88E6XXX_NEED_PPU=y
CONFIG_NET_DSA_MV88E6131=y
CONFIG_NET_DSA_MV88E6123_61_65=y
# CONFIG_VLAN_8021Q is not set
CONFIG_DECNET=y
CONFIG_DECNET_ROUTER=y
CONFIG_LLC=y
# CONFIG_LLC2 is not set
CONFIG_IPX=y
# CONFIG_IPX_INTERN is not set
CONFIG_ATALK=y
CONFIG_DEV_APPLETALK=y
# CONFIG_LTPC is not set
# CONFIG_IPDDP is not set
CONFIG_X25=y
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
CONFIG_WAN_ROUTER=y
CONFIG_PHONET=y
# CONFIG_IEEE802154 is not set
# CONFIG_NET_SCHED is not set
CONFIG_DCB=y

#
# Network testing
#
CONFIG_NET_PKTGEN=y
CONFIG_NET_DROP_MONITOR=y
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
# CONFIG_AX25 is not set
CONFIG_CAN=y
CONFIG_CAN_RAW=y
# CONFIG_CAN_BCM is not set

#
# CAN Device Drivers
#
# CONFIG_CAN_VCAN is not set
CONFIG_CAN_DEV=y
CONFIG_CAN_CALC_BITTIMING=y
CONFIG_CAN_MCP251X=y
CONFIG_CAN_SJA1000=y
# CONFIG_CAN_SJA1000_ISA is not set
CONFIG_CAN_SJA1000_PLATFORM=y
# CONFIG_CAN_EMS_PCI is not set
CONFIG_CAN_KVASER_PCI=y
CONFIG_CAN_PLX_PCI=y

#
# CAN USB interfaces
#
CONFIG_CAN_EMS_USB=y
CONFIG_CAN_DEBUG_DEVICES=y
# CONFIG_IRDA is not set
# CONFIG_BT is not set
CONFIG_AF_RXRPC=y
CONFIG_AF_RXRPC_DEBUG=y
CONFIG_RXKAD=y
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_WEXT_SPY=y
CONFIG_WEXT_PRIV=y
CONFIG_CFG80211=y
# CONFIG_NL80211_TESTMODE is not set
CONFIG_CFG80211_DEVELOPER_WARNINGS=y
# CONFIG_CFG80211_REG_DEBUG is not set
# CONFIG_CFG80211_DEFAULT_PS is not set
CONFIG_CFG80211_DEBUGFS=y
# CONFIG_CFG80211_INTERNAL_REGDB is not set
# CONFIG_CFG80211_WEXT is not set
CONFIG_WIRELESS_EXT_SYSFS=y
CONFIG_LIB80211=y
CONFIG_LIB80211_CRYPT_WEP=y
CONFIG_LIB80211_CRYPT_CCMP=y
CONFIG_LIB80211_CRYPT_TKIP=y
CONFIG_LIB80211_DEBUG=y
CONFIG_MAC80211=y
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_MINSTREL=y
# CONFIG_MAC80211_RC_DEFAULT_PID is not set
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel"
# CONFIG_MAC80211_MESH is not set
CONFIG_MAC80211_LEDS=y
CONFIG_MAC80211_DEBUGFS=y
CONFIG_MAC80211_DEBUG_MENU=y
CONFIG_MAC80211_NOINLINE=y
CONFIG_MAC80211_VERBOSE_DEBUG=y
# CONFIG_MAC80211_HT_DEBUG is not set
# CONFIG_MAC80211_TKIP_DEBUG is not set
CONFIG_MAC80211_IBSS_DEBUG=y
# CONFIG_MAC80211_VERBOSE_PS_DEBUG is not set
CONFIG_MAC80211_DEBUG_COUNTERS=y
# CONFIG_MAC80211_DRIVER_API_TRACER is not set
CONFIG_WIMAX=y
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_RFKILL=y
CONFIG_RFKILL_LEDS=y
CONFIG_RFKILL_INPUT=y
CONFIG_CAIF=y
# CONFIG_CAIF_DEBUG is not set
CONFIG_CAIF_NETDEV=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=y
# CONFIG_PROC_EVENTS is not set
CONFIG_PARPORT=y
CONFIG_PARPORT_PC=y
CONFIG_PARPORT_SERIAL=y
# CONFIG_PARPORT_PC_FIFO is not set
# CONFIG_PARPORT_PC_SUPERIO is not set
# CONFIG_PARPORT_GSC is not set
CONFIG_PARPORT_AX88796=y
# CONFIG_PARPORT_1284 is not set
CONFIG_PARPORT_NOT_PC=y
# CONFIG_PNP is not set
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_FD is not set
# CONFIG_BLK_DEV_XD is not set
CONFIG_BLK_CPQ_DA=y
CONFIG_BLK_CPQ_CISS_DA=y
CONFIG_CISS_SCSI_TAPE=y
# CONFIG_BLK_DEV_DAC960 is not set
# CONFIG_BLK_DEV_UMEM is not set
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set
CONFIG_BLK_DEV_DRBD=y
CONFIG_DRBD_FAULT_INJECTION=y
CONFIG_BLK_DEV_NBD=y
CONFIG_BLK_DEV_OSD=y
# CONFIG_BLK_DEV_SX8 is not set
CONFIG_BLK_DEV_UB=y
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
CONFIG_BLK_DEV_XIP=y
CONFIG_CDROM_PKTCDVD=y
CONFIG_CDROM_PKTCDVD_BUFFERS=8
CONFIG_CDROM_PKTCDVD_WCACHE=y
CONFIG_ATA_OVER_ETH=y
# CONFIG_VIRTIO_BLK is not set
CONFIG_BLK_DEV_HD=y
CONFIG_MISC_DEVICES=y
CONFIG_AD525X_DPOT=y
CONFIG_AD525X_DPOT_I2C=y
CONFIG_AD525X_DPOT_SPI=y
CONFIG_IBM_ASM=y
# CONFIG_PHANTOM is not set
CONFIG_SGI_IOC4=y
CONFIG_TIFM_CORE=y
# CONFIG_TIFM_7XX1 is not set
# CONFIG_ICS932S401 is not set
CONFIG_ENCLOSURE_SERVICES=y
CONFIG_CS5535_MFGPT=y
CONFIG_CS5535_MFGPT_DEFAULT_IRQ=7
CONFIG_CS5535_CLOCK_EVENT_SRC=y
CONFIG_HP_ILO=y
# CONFIG_ISL29003 is not set
CONFIG_SENSORS_TSL2550=y
# CONFIG_DS1682 is not set
CONFIG_TI_DAC7512=y
# CONFIG_VMWARE_BALLOON is not set
CONFIG_C2PORT=y
CONFIG_C2PORT_DURAMAR_2150=y

#
# EEPROM support
#
CONFIG_EEPROM_AT24=y
CONFIG_EEPROM_AT25=y
CONFIG_EEPROM_LEGACY=y
CONFIG_EEPROM_MAX6875=y
CONFIG_EEPROM_93CX6=y
CONFIG_CB710_CORE=y
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y
CONFIG_IWMC3200TOP=y
CONFIG_IWMC3200TOP_DEBUG=y
CONFIG_IWMC3200TOP_DEBUGFS=y
CONFIG_HAVE_IDE=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=y
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=y
CONFIG_CHR_DEV_OSST=y
CONFIG_BLK_DEV_SR=y
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=y
CONFIG_CHR_DEV_SCH=y
CONFIG_SCSI_ENCLOSURE=y
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
# CONFIG_SCSI_LOGGING is not set
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_FC_TGT_ATTRS=y
# CONFIG_SCSI_ISCSI_ATTRS is not set
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
CONFIG_SCSI_SAS_ATA=y
CONFIG_SCSI_SAS_HOST_SMP=y
# CONFIG_SCSI_SAS_LIBSAS_DEBUG is not set
# CONFIG_SCSI_LOWLEVEL is not set
CONFIG_SCSI_AIC7XXX=y
CONFIG_SCSI_DH=y
CONFIG_SCSI_DH_RDAC=y
CONFIG_SCSI_DH_HP_SW=y
CONFIG_SCSI_DH_EMC=y
CONFIG_SCSI_DH_ALUA=y
CONFIG_SCSI_OSD_INITIATOR=y
CONFIG_SCSI_OSD_ULD=y
CONFIG_SCSI_OSD_DPRINT_SENSE=1
CONFIG_SCSI_OSD_DEBUG=y
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
# CONFIG_ATA_VERBOSE_ERROR is not set
CONFIG_SATA_PMP=y

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=y
CONFIG_SATA_AHCI_PLATFORM=y
CONFIG_SATA_INIC162X=y
CONFIG_SATA_SIL24=y
CONFIG_ATA_SFF=y

#
# SFF controllers with custom DMA interface
#
# CONFIG_PDC_ADMA is not set
CONFIG_SATA_QSTOR=y
# CONFIG_SATA_SX4 is not set
CONFIG_ATA_BMDMA=y

#
# SATA SFF controllers with BMDMA
#
CONFIG_ATA_PIIX=y
CONFIG_SATA_MV=y
CONFIG_SATA_NV=y
CONFIG_SATA_PROMISE=y
CONFIG_SATA_SIL=y
CONFIG_SATA_SIS=y
CONFIG_SATA_SVW=y
CONFIG_SATA_ULI=y
CONFIG_SATA_VIA=y
CONFIG_SATA_VITESSE=y

#
# PATA SFF controllers with BMDMA
#
# CONFIG_PATA_ALI is not set
CONFIG_PATA_AMD=y
CONFIG_PATA_ARTOP=y
# CONFIG_PATA_ATIIXP is not set
CONFIG_PATA_ATP867X=y
CONFIG_PATA_CMD64X=y
CONFIG_PATA_CS5520=y
CONFIG_PATA_CS5530=y
CONFIG_PATA_CS5535=y
CONFIG_PATA_CS5536=y
CONFIG_PATA_CYPRESS=y
CONFIG_PATA_EFAR=y
CONFIG_PATA_HPT366=y
# CONFIG_PATA_HPT37X is not set
CONFIG_PATA_HPT3X2N=y
CONFIG_PATA_HPT3X3=y
CONFIG_PATA_HPT3X3_DMA=y
CONFIG_PATA_IT8213=y
CONFIG_PATA_IT821X=y
# CONFIG_PATA_JMICRON is not set
# CONFIG_PATA_MARVELL is not set
CONFIG_PATA_NETCELL=y
CONFIG_PATA_NINJA32=y
CONFIG_PATA_NS87415=y
CONFIG_PATA_OLDPIIX=y
# CONFIG_PATA_OPTIDMA is not set
CONFIG_PATA_PDC2027X=y
CONFIG_PATA_PDC_OLD=y
CONFIG_PATA_RADISYS=y
# CONFIG_PATA_RDC is not set
# CONFIG_PATA_SC1200 is not set
CONFIG_PATA_SCH=y
# CONFIG_PATA_SERVERWORKS is not set
CONFIG_PATA_SIL680=y
CONFIG_PATA_SIS=y
CONFIG_PATA_TOSHIBA=y
CONFIG_PATA_TRIFLEX=y
CONFIG_PATA_VIA=y
# CONFIG_PATA_WINBOND is not set

#
# PIO-only SFF controllers
#
CONFIG_PATA_CMD640_PCI=y
# CONFIG_PATA_MPIIX is not set
CONFIG_PATA_NS87410=y
CONFIG_PATA_OPTI=y
CONFIG_PATA_QDI=y
CONFIG_PATA_RZ1000=y
CONFIG_PATA_WINBOND_VLB=y

#
# Generic fallback / legacy drivers
#
# CONFIG_ATA_GENERIC is not set
CONFIG_PATA_LEGACY=y
CONFIG_MD=y
# CONFIG_BLK_DEV_MD is not set
# CONFIG_BLK_DEV_DM is not set
CONFIG_FUSION=y
CONFIG_FUSION_SPI=y
CONFIG_FUSION_FC=y
# CONFIG_FUSION_SAS is not set
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_CTL=y
CONFIG_FUSION_LAN=y
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#

#
# You can enable one or both FireWire driver stacks.
#

#
# The newer stack is recommended.
#
CONFIG_FIREWIRE=y
CONFIG_FIREWIRE_OHCI=y
CONFIG_FIREWIRE_OHCI_DEBUG=y
CONFIG_FIREWIRE_SBP2=y
# CONFIG_FIREWIRE_NET is not set
CONFIG_IEEE1394=y
CONFIG_IEEE1394_OHCI1394=y
# CONFIG_IEEE1394_PCILYNX is not set
# CONFIG_IEEE1394_SBP2 is not set
CONFIG_IEEE1394_ETH1394_ROM_ENTRY=y
CONFIG_IEEE1394_ETH1394=y
CONFIG_IEEE1394_RAWIO=y
CONFIG_IEEE1394_VIDEO1394=y
# CONFIG_IEEE1394_DV1394 is not set
CONFIG_IEEE1394_VERBOSEDEBUG=y
CONFIG_I2O=y
CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=y
# CONFIG_I2O_EXT_ADAPTEC is not set
CONFIG_I2O_CONFIG=y
# CONFIG_I2O_CONFIG_OLD_IOCTL is not set
CONFIG_I2O_BUS=y
# CONFIG_I2O_BLOCK is not set
CONFIG_I2O_SCSI=y
# CONFIG_I2O_PROC is not set
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
CONFIG_NETDEVICES=y
CONFIG_DUMMY=y
CONFIG_BONDING=y
CONFIG_MACVLAN=y
CONFIG_MACVTAP=y
CONFIG_EQUALIZER=y
CONFIG_TUN=y
# CONFIG_VETH is not set
CONFIG_ARCNET=y
CONFIG_ARCNET_1201=y
CONFIG_ARCNET_1051=y
CONFIG_ARCNET_RAW=y
CONFIG_ARCNET_CAP=y
# CONFIG_ARCNET_COM90xx is not set
CONFIG_ARCNET_COM90xxIO=y
CONFIG_ARCNET_RIM_I=y
CONFIG_ARCNET_COM20020=y
CONFIG_ARCNET_COM20020_ISA=y
CONFIG_ARCNET_COM20020_PCI=y
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
CONFIG_MARVELL_PHY=y
# CONFIG_DAVICOM_PHY is not set
CONFIG_QSEMI_PHY=y
CONFIG_LXT_PHY=y
# CONFIG_CICADA_PHY is not set
# CONFIG_VITESSE_PHY is not set
CONFIG_SMSC_PHY=y
CONFIG_BROADCOM_PHY=y
CONFIG_ICPLUS_PHY=y
CONFIG_REALTEK_PHY=y
CONFIG_NATIONAL_PHY=y
# CONFIG_STE10XP is not set
CONFIG_LSI_ET1011C_PHY=y
CONFIG_MICREL_PHY=y
# CONFIG_FIXED_PHY is not set
# CONFIG_MDIO_BITBANG is not set
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
# CONFIG_HAPPYMEAL is not set
CONFIG_SUNGEM=y
# CONFIG_CASSINI is not set
CONFIG_NET_VENDOR_3COM=y
# CONFIG_EL1 is not set
# CONFIG_EL2 is not set
CONFIG_ELPLUS=y
# CONFIG_EL16 is not set
# CONFIG_EL3 is not set
CONFIG_3C515=y
CONFIG_ELMC=y
CONFIG_ELMC_II=y
CONFIG_VORTEX=y
# CONFIG_TYPHOON is not set
CONFIG_LANCE=y
CONFIG_NET_VENDOR_SMC=y
# CONFIG_ULTRAMCA is not set
# CONFIG_ULTRA is not set
# CONFIG_ULTRA32 is not set
# CONFIG_SMC9194 is not set
CONFIG_ENC28J60=y
CONFIG_ENC28J60_WRITEVERIFY=y
# CONFIG_ETHOC is not set
# CONFIG_NET_VENDOR_RACAL is not set
# CONFIG_DNET is not set
CONFIG_NET_TULIP=y
# CONFIG_DE2104X is not set
CONFIG_TULIP=y
CONFIG_TULIP_MWI=y
CONFIG_TULIP_MMIO=y
CONFIG_TULIP_NAPI=y
CONFIG_TULIP_NAPI_HW_MITIGATION=y
CONFIG_DE4X5=y
# CONFIG_WINBOND_840 is not set
CONFIG_DM9102=y
# CONFIG_ULI526X is not set
CONFIG_AT1700=y
CONFIG_DEPCA=y
CONFIG_HP100=y
# CONFIG_NET_ISA is not set
CONFIG_NE2_MCA=y
CONFIG_IBMLANA=y
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
# CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
# CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
# CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
CONFIG_NET_PCI=y
CONFIG_PCNET32=y
CONFIG_AMD8111_ETH=y
# CONFIG_ADAPTEC_STARFIRE is not set
CONFIG_AC3200=y
CONFIG_KSZ884X_PCI=y
CONFIG_APRICOT=y
# CONFIG_B44 is not set
CONFIG_FORCEDETH=y
CONFIG_CS89x0=y
CONFIG_E100=y
# CONFIG_LNE390 is not set
CONFIG_FEALNX=y
# CONFIG_NATSEMI is not set
CONFIG_NE2K_PCI=y
CONFIG_NE3210=y
CONFIG_ES3210=y
# CONFIG_8139CP is not set
CONFIG_8139TOO=y
CONFIG_8139TOO_PIO=y
# CONFIG_8139TOO_TUNE_TWISTER is not set
CONFIG_8139TOO_8129=y
CONFIG_8139_OLD_RX_RESET=y
# CONFIG_R6040 is not set
CONFIG_SIS900=y
# CONFIG_EPIC100 is not set
CONFIG_SMSC9420=y
CONFIG_SUNDANCE=y
CONFIG_SUNDANCE_MMIO=y
CONFIG_TLAN=y
CONFIG_KS8842=y
# CONFIG_KS8851 is not set
CONFIG_KS8851_MLL=y
CONFIG_VIA_RHINE=y
CONFIG_VIA_RHINE_MMIO=y
CONFIG_SC92031=y
# CONFIG_NET_POCKET is not set
CONFIG_ATL2=y
CONFIG_NETDEV_1000=y
# CONFIG_ACENIC is not set
CONFIG_DL2K=y
CONFIG_E1000=y
CONFIG_E1000E=y
# CONFIG_IP1000 is not set
CONFIG_IGB=y
# CONFIG_IGB_DCA is not set
CONFIG_IGBVF=y
# CONFIG_NS83820 is not set
CONFIG_HAMACHI=y
# CONFIG_YELLOWFIN is not set
CONFIG_R8169=y
CONFIG_SIS190=y
CONFIG_SKGE=y
CONFIG_SKGE_DEBUG=y
CONFIG_SKY2=y
# CONFIG_SKY2_DEBUG is not set
CONFIG_VIA_VELOCITY=y
CONFIG_TIGON3=y
CONFIG_BNX2=y
# CONFIG_CNIC is not set
CONFIG_QLA3XXX=y
# CONFIG_ATL1 is not set
CONFIG_ATL1E=y
CONFIG_ATL1C=y
CONFIG_JME=y
# CONFIG_NETDEV_10000 is not set
# CONFIG_TR is not set
CONFIG_WLAN=y
# CONFIG_LIBERTAS_THINFIRM is not set
# CONFIG_AIRO is not set
CONFIG_ATMEL=y
CONFIG_PCI_ATMEL=y
CONFIG_AT76C50X_USB=y
CONFIG_PRISM54=y
CONFIG_USB_ZD1201=y
CONFIG_USB_NET_RNDIS_WLAN=y
CONFIG_RTL8180=y
CONFIG_RTL8187=y
CONFIG_RTL8187_LEDS=y
CONFIG_ADM8211=y
CONFIG_MAC80211_HWSIM=y
CONFIG_MWL8K=y
CONFIG_ATH_COMMON=y
CONFIG_ATH_DEBUG=y
CONFIG_ATH5K=y
# CONFIG_ATH5K_DEBUG is not set
CONFIG_ATH9K_HW=y
CONFIG_ATH9K_COMMON=y
CONFIG_ATH9K=y
CONFIG_ATH9K_DEBUGFS=y
CONFIG_ATH9K_HTC=y
CONFIG_ATH9K_HTC_DEBUGFS=y
# CONFIG_AR9170_USB is not set
# CONFIG_B43 is not set
CONFIG_B43LEGACY=y
CONFIG_B43LEGACY_PCI_AUTOSELECT=y
CONFIG_B43LEGACY_PCICORE_AUTOSELECT=y
CONFIG_B43LEGACY_LEDS=y
CONFIG_B43LEGACY_HWRNG=y
CONFIG_B43LEGACY_DEBUG=y
CONFIG_B43LEGACY_PIO=y
# CONFIG_B43LEGACY_DMA_AND_PIO_MODE is not set
# CONFIG_B43LEGACY_DMA_MODE is not set
CONFIG_B43LEGACY_PIO_MODE=y
CONFIG_HOSTAP=y
CONFIG_HOSTAP_FIRMWARE=y
# CONFIG_HOSTAP_FIRMWARE_NVRAM is not set
# CONFIG_HOSTAP_PLX is not set
CONFIG_HOSTAP_PCI=y
CONFIG_IPW2100=y
# CONFIG_IPW2100_MONITOR is not set
# CONFIG_IPW2100_DEBUG is not set
CONFIG_LIBIPW=y
CONFIG_LIBIPW_DEBUG=y
# CONFIG_IWLWIFI is not set
# CONFIG_IWM is not set
CONFIG_LIBERTAS=y
CONFIG_LIBERTAS_USB=y
CONFIG_LIBERTAS_SDIO=y
# CONFIG_LIBERTAS_SPI is not set
CONFIG_LIBERTAS_DEBUG=y
# CONFIG_LIBERTAS_MESH is not set
CONFIG_P54_COMMON=y
CONFIG_P54_USB=y
CONFIG_P54_PCI=y
# CONFIG_P54_SPI is not set
CONFIG_P54_LEDS=y
# CONFIG_ZD1211RW is not set

#
# WiMAX Wireless Broadband devices
#
CONFIG_WIMAX_I2400M=y
CONFIG_WIMAX_I2400M_SDIO=y
CONFIG_WIMAX_IWMC3200_SDIO=y
CONFIG_WIMAX_I2400M_DEBUG_LEVEL=8

#
# USB Network Adapters
#
CONFIG_USB_CATC=y
CONFIG_USB_KAWETH=y
CONFIG_USB_PEGASUS=y
# CONFIG_USB_RTL8150 is not set
CONFIG_USB_USBNET=y
# CONFIG_USB_NET_AX8817X is not set
CONFIG_USB_NET_CDCETHER=y
# CONFIG_USB_NET_CDC_EEM is not set
CONFIG_USB_NET_DM9601=y
# CONFIG_USB_NET_SMSC75XX is not set
CONFIG_USB_NET_SMSC95XX=y
# CONFIG_USB_NET_GL620A is not set
# CONFIG_USB_NET_NET1080 is not set
# CONFIG_USB_NET_PLUSB is not set
CONFIG_USB_NET_MCS7830=y
CONFIG_USB_NET_RNDIS_HOST=y
CONFIG_USB_NET_CDC_SUBSET=y
CONFIG_USB_ALI_M5632=y
# CONFIG_USB_AN2720 is not set
CONFIG_USB_BELKIN=y
CONFIG_USB_ARMLINUX=y
# CONFIG_USB_EPSON2888 is not set
CONFIG_USB_KC2190=y
CONFIG_USB_NET_ZAURUS=y
CONFIG_USB_HSO=y
CONFIG_USB_NET_INT51X1=y
# CONFIG_USB_CDC_PHONET is not set
CONFIG_USB_IPHETH=y
CONFIG_USB_SIERRA_NET=y
CONFIG_WAN=y
CONFIG_LANMEDIA=y
CONFIG_HDLC=y
CONFIG_HDLC_RAW=y
CONFIG_HDLC_RAW_ETH=y
# CONFIG_HDLC_CISCO is not set
CONFIG_HDLC_FR=y
CONFIG_HDLC_PPP=y

#
# X.25/LAPB support is disabled
#
# CONFIG_PCI200SYN is not set
CONFIG_WANXL=y
# CONFIG_PC300TOO is not set
CONFIG_N2=y
CONFIG_C101=y
CONFIG_FARSYNC=y
CONFIG_DLCI=y
CONFIG_DLCI_MAX=8
# CONFIG_SDLA is not set
# CONFIG_WAN_ROUTER_DRIVERS is not set
CONFIG_SBNI=y
# CONFIG_SBNI_MULTILINE is not set
CONFIG_ATM_DRIVERS=y
# CONFIG_ATM_DUMMY is not set
CONFIG_ATM_TCP=y
CONFIG_ATM_LANAI=y
CONFIG_ATM_ENI=y
CONFIG_ATM_ENI_DEBUG=y
# CONFIG_ATM_ENI_TUNE_BURST is not set
CONFIG_ATM_FIRESTREAM=y
CONFIG_ATM_ZATM=y
CONFIG_ATM_ZATM_DEBUG=y
CONFIG_ATM_NICSTAR=y
CONFIG_ATM_NICSTAR_USE_SUNI=y
CONFIG_ATM_NICSTAR_USE_IDT77105=y
# CONFIG_ATM_IDT77252 is not set
CONFIG_ATM_AMBASSADOR=y
# CONFIG_ATM_AMBASSADOR_DEBUG is not set
# CONFIG_ATM_HORIZON is not set
# CONFIG_ATM_IA is not set
CONFIG_ATM_FORE200E=y
# CONFIG_ATM_FORE200E_USE_TASKLET is not set
CONFIG_ATM_FORE200E_TX_RETRY=16
CONFIG_ATM_FORE200E_DEBUG=0
CONFIG_ATM_HE=y
# CONFIG_ATM_HE_USE_SUNI is not set
# CONFIG_ATM_SOLOS is not set

#
# CAIF transport drivers
#
# CONFIG_CAIF_TTY is not set
CONFIG_FDDI=y
CONFIG_DEFXX=y
CONFIG_DEFXX_MMIO=y
# CONFIG_SKFP is not set
# CONFIG_HIPPI is not set
# CONFIG_PLIP is not set
CONFIG_PPP=y
CONFIG_PPP_MULTILINK=y
CONFIG_PPP_FILTER=y
CONFIG_PPP_ASYNC=y
CONFIG_PPP_SYNC_TTY=y
# CONFIG_PPP_DEFLATE is not set
CONFIG_PPP_BSDCOMP=y
CONFIG_PPP_MPPE=y
# CONFIG_PPPOE is not set
CONFIG_PPPOATM=y
CONFIG_SLIP=y
# CONFIG_SLIP_COMPRESSED is not set
CONFIG_SLHC=y
# CONFIG_SLIP_SMART is not set
CONFIG_SLIP_MODE_SLIP6=y
CONFIG_NET_FC=y
CONFIG_NETCONSOLE=y
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=y
# CONFIG_VIRTIO_NET is not set
# CONFIG_VMXNET3 is not set
CONFIG_ISDN=y
# CONFIG_ISDN_I4L is not set
# CONFIG_ISDN_CAPI is not set
CONFIG_ISDN_DRV_GIGASET=y
CONFIG_GIGASET_DUMMYLL=y
# CONFIG_GIGASET_BASE is not set
CONFIG_GIGASET_M105=y
# CONFIG_GIGASET_M101 is not set
# CONFIG_GIGASET_DEBUG is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=y
CONFIG_INPUT_SPARSEKMAP=y

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=y
CONFIG_INPUT_EVDEV=y
CONFIG_INPUT_EVBUG=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
CONFIG_KEYBOARD_ATKBD=y
CONFIG_QT2160=y
CONFIG_KEYBOARD_LKKBD=y
CONFIG_KEYBOARD_GPIO=y
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_MATRIX is not set
CONFIG_KEYBOARD_LM8323=y
# CONFIG_KEYBOARD_MAX7359 is not set
CONFIG_KEYBOARD_NEWTON=y
CONFIG_KEYBOARD_OPENCORES=y
CONFIG_KEYBOARD_STOWAWAY=y
CONFIG_KEYBOARD_SUNKBD=y
CONFIG_KEYBOARD_XTKBD=y
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
CONFIG_MOUSE_PS2_ELANTECH=y
CONFIG_MOUSE_PS2_SENTELIC=y
CONFIG_MOUSE_PS2_TOUCHKIT=y
CONFIG_MOUSE_SERIAL=y
CONFIG_MOUSE_APPLETOUCH=y
CONFIG_MOUSE_BCM5974=y
CONFIG_MOUSE_INPORT=y
CONFIG_MOUSE_ATIXL=y
CONFIG_MOUSE_LOGIBM=y
# CONFIG_MOUSE_PC110PAD is not set
CONFIG_MOUSE_VSXXXAA=y
# CONFIG_MOUSE_GPIO is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=y
CONFIG_JOYSTICK_A3D=y
CONFIG_JOYSTICK_ADI=y
# CONFIG_JOYSTICK_COBRA is not set
# CONFIG_JOYSTICK_GF2K is not set
CONFIG_JOYSTICK_GRIP=y
CONFIG_JOYSTICK_GRIP_MP=y
CONFIG_JOYSTICK_GUILLEMOT=y
CONFIG_JOYSTICK_INTERACT=y
CONFIG_JOYSTICK_SIDEWINDER=y
CONFIG_JOYSTICK_TMDC=y
# CONFIG_JOYSTICK_IFORCE is not set
CONFIG_JOYSTICK_WARRIOR=y
CONFIG_JOYSTICK_MAGELLAN=y
CONFIG_JOYSTICK_SPACEORB=y
CONFIG_JOYSTICK_SPACEBALL=y
CONFIG_JOYSTICK_STINGER=y
# CONFIG_JOYSTICK_TWIDJOY is not set
CONFIG_JOYSTICK_ZHENHUA=y
# CONFIG_JOYSTICK_DB9 is not set
CONFIG_JOYSTICK_GAMECON=y
CONFIG_JOYSTICK_TURBOGRAFX=y
CONFIG_JOYSTICK_JOYDUMP=y
CONFIG_JOYSTICK_XPAD=y
CONFIG_JOYSTICK_XPAD_FF=y
CONFIG_JOYSTICK_XPAD_LEDS=y
CONFIG_JOYSTICK_WALKERA0701=y
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=y
# CONFIG_TABLET_USB_AIPTEK is not set
CONFIG_TABLET_USB_GTCO=y
# CONFIG_TABLET_USB_KBTAB is not set
CONFIG_TABLET_USB_WACOM=y
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_ADS7846=y
CONFIG_TOUCHSCREEN_AD7877=y
CONFIG_TOUCHSCREEN_AD7879_I2C=y
CONFIG_TOUCHSCREEN_AD7879=y
CONFIG_TOUCHSCREEN_DYNAPRO=y
CONFIG_TOUCHSCREEN_HAMPSHIRE=y
# CONFIG_TOUCHSCREEN_EETI is not set
CONFIG_TOUCHSCREEN_FUJITSU=y
CONFIG_TOUCHSCREEN_GUNZE=y
CONFIG_TOUCHSCREEN_ELO=y
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
CONFIG_TOUCHSCREEN_MCS5000=y
# CONFIG_TOUCHSCREEN_MTOUCH is not set
# CONFIG_TOUCHSCREEN_INEXIO is not set
CONFIG_TOUCHSCREEN_MK712=y
CONFIG_TOUCHSCREEN_HTCPEN=y
CONFIG_TOUCHSCREEN_PENMOUNT=y
CONFIG_TOUCHSCREEN_TOUCHRIGHT=y
CONFIG_TOUCHSCREEN_TOUCHWIN=y
CONFIG_TOUCHSCREEN_WM97XX=y
# CONFIG_TOUCHSCREEN_WM9705 is not set
CONFIG_TOUCHSCREEN_WM9712=y
CONFIG_TOUCHSCREEN_WM9713=y
CONFIG_TOUCHSCREEN_USB_COMPOSITE=y
CONFIG_TOUCHSCREEN_USB_EGALAX=y
CONFIG_TOUCHSCREEN_USB_PANJIT=y
CONFIG_TOUCHSCREEN_USB_3M=y
CONFIG_TOUCHSCREEN_USB_ITM=y
CONFIG_TOUCHSCREEN_USB_ETURBO=y
CONFIG_TOUCHSCREEN_USB_GUNZE=y
CONFIG_TOUCHSCREEN_USB_DMC_TSC10=y
CONFIG_TOUCHSCREEN_USB_IRTOUCH=y
CONFIG_TOUCHSCREEN_USB_IDEALTEK=y
CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH=y
CONFIG_TOUCHSCREEN_USB_GOTOP=y
CONFIG_TOUCHSCREEN_USB_JASTEC=y
CONFIG_TOUCHSCREEN_USB_E2I=y
CONFIG_TOUCHSCREEN_USB_ZYTRONIC=y
CONFIG_TOUCHSCREEN_USB_ETT_TC5UH=y
CONFIG_TOUCHSCREEN_USB_NEXIO=y
CONFIG_TOUCHSCREEN_TOUCHIT213=y
CONFIG_TOUCHSCREEN_TSC2007=y
CONFIG_TOUCHSCREEN_TPS6507X=y
CONFIG_INPUT_MISC=y
CONFIG_INPUT_AD714X=y
CONFIG_INPUT_AD714X_I2C=y
CONFIG_INPUT_AD714X_SPI=y
# CONFIG_INPUT_PCSPKR is not set
CONFIG_INPUT_APANEL=y
# CONFIG_INPUT_WISTRON_BTNS is not set
CONFIG_INPUT_ATI_REMOTE=y
CONFIG_INPUT_ATI_REMOTE2=y
CONFIG_INPUT_KEYSPAN_REMOTE=y
CONFIG_INPUT_POWERMATE=y
CONFIG_INPUT_YEALINK=y
CONFIG_INPUT_CM109=y
CONFIG_INPUT_UINPUT=y
CONFIG_INPUT_PCF8574=y
CONFIG_INPUT_GPIO_ROTARY_ENCODER=y

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
# CONFIG_SERIO_SERPORT is not set
CONFIG_SERIO_CT82C710=y
CONFIG_SERIO_PARKBD=y
CONFIG_SERIO_PCIPS2=y
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
CONFIG_SERIO_ALTERA_PS2=y
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
CONFIG_GAMEPORT_L4=y
CONFIG_GAMEPORT_EMU10K1=y
CONFIG_GAMEPORT_FM801=y

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
# CONFIG_VT_HW_CONSOLE_BINDING is not set
# CONFIG_DEVKMEM is not set
CONFIG_SERIAL_NONSTANDARD=y
CONFIG_COMPUTONE=y
CONFIG_ROCKETPORT=y
# CONFIG_CYCLADES is not set
# CONFIG_DIGIEPCA is not set
CONFIG_MOXA_INTELLIO=y
CONFIG_MOXA_SMARTIO=y
# CONFIG_ISI is not set
CONFIG_SYNCLINK=y
# CONFIG_SYNCLINKMP is not set
# CONFIG_SYNCLINK_GT is not set
CONFIG_N_HDLC=y
CONFIG_N_GSM=y
# CONFIG_RISCOM8 is not set
CONFIG_SPECIALIX=y
CONFIG_STALDRV=y
CONFIG_STALLION=y
# CONFIG_ISTALLION is not set
# CONFIG_NOZOMI is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_FOURPORT=y
# CONFIG_SERIAL_8250_ACCENT is not set
CONFIG_SERIAL_8250_BOCA=y
# CONFIG_SERIAL_8250_EXAR_ST16C554 is not set
CONFIG_SERIAL_8250_HUB6=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
CONFIG_SERIAL_8250_DETECT_IRQ=y
CONFIG_SERIAL_8250_RSA=y
CONFIG_SERIAL_8250_MCA=y

#
# Non-8250 serial port support
#
CONFIG_SERIAL_MAX3100=y
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=y
# CONFIG_SERIAL_TIMBERDALE is not set
CONFIG_SERIAL_ALTERA_JTAGUART=y
CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE=y
CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE_BYPASS=y
# CONFIG_SERIAL_ALTERA_UART is not set
CONFIG_UNIX98_PTYS=y
CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
# CONFIG_LEGACY_PTYS is not set
CONFIG_PRINTER=y
CONFIG_LP_CONSOLE=y
CONFIG_PPDEV=y
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
CONFIG_IPMI_HANDLER=y
CONFIG_IPMI_PANIC_EVENT=y
CONFIG_IPMI_PANIC_STRING=y
CONFIG_IPMI_DEVICE_INTERFACE=y
# CONFIG_IPMI_SI is not set
# CONFIG_IPMI_WATCHDOG is not set
# CONFIG_IPMI_POWEROFF is not set
CONFIG_HW_RANDOM=y
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
CONFIG_HW_RANDOM_INTEL=y
# CONFIG_HW_RANDOM_AMD is not set
CONFIG_HW_RANDOM_GEODE=y
CONFIG_HW_RANDOM_VIA=y
# CONFIG_HW_RANDOM_VIRTIO is not set
CONFIG_NVRAM=y
CONFIG_RTC=y
CONFIG_DTLK=y
CONFIG_R3964=y
CONFIG_APPLICOM=y
CONFIG_SONYPI=y
# CONFIG_MWAVE is not set
# CONFIG_PC8736x_GPIO is not set
CONFIG_NSC_GPIO=y
# CONFIG_CS5535_GPIO is not set
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HANGCHECK_TIMER is not set
CONFIG_TCG_TPM=y
CONFIG_TCG_TIS=y
# CONFIG_TCG_NSC is not set
# CONFIG_TCG_ATMEL is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
# CONFIG_RAMOOPS is not set
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_COMPAT=y
CONFIG_I2C_CHARDEV=y
# CONFIG_I2C_HELPER_AUTO is not set
CONFIG_I2C_SMBUS=y

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=y
CONFIG_I2C_ALGOPCF=y
CONFIG_I2C_ALGOPCA=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=y
CONFIG_I2C_ALI1563=y
# CONFIG_I2C_ALI15X3 is not set
CONFIG_I2C_AMD756=y
CONFIG_I2C_AMD8111=y
CONFIG_I2C_I801=y
CONFIG_I2C_ISCH=y
# CONFIG_I2C_PIIX4 is not set
CONFIG_I2C_NFORCE2=y
CONFIG_I2C_SIS5595=y
# CONFIG_I2C_SIS630 is not set
CONFIG_I2C_SIS96X=y
# CONFIG_I2C_VIA is not set
# CONFIG_I2C_VIAPRO is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
CONFIG_I2C_GPIO=y
CONFIG_I2C_OCORES=y
# CONFIG_I2C_PCA_PLATFORM is not set
# CONFIG_I2C_SIMTEC is not set
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT=y
CONFIG_I2C_PARPORT_LIGHT=y
# CONFIG_I2C_TAOS_EVM is not set
CONFIG_I2C_TINY_USB=y

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_ELEKTOR=y
CONFIG_SCx200_ACB=y
CONFIG_I2C_DEBUG_CORE=y
CONFIG_I2C_DEBUG_ALGO=y
# CONFIG_I2C_DEBUG_BUS is not set
CONFIG_SPI=y
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
CONFIG_SPI_BITBANG=y
CONFIG_SPI_BUTTERFLY=y
CONFIG_SPI_GPIO=y
CONFIG_SPI_LM70_LLP=y
CONFIG_SPI_XILINX=y
CONFIG_SPI_XILINX_PLTFM=y
# CONFIG_SPI_DESIGNWARE is not set

#
# SPI Protocol Masters
#
CONFIG_SPI_SPIDEV=y
CONFIG_SPI_TLE62X0=y

#
# PPS support
#
# CONFIG_PPS is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_MAX730X=y

#
# Memory mapped GPIO expanders:
#
CONFIG_GPIO_IT8761E=y
CONFIG_GPIO_SCH=y

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_MAX7300 is not set
# CONFIG_GPIO_MAX732X is not set
# CONFIG_GPIO_PCA953X is not set
# CONFIG_GPIO_PCF857X is not set
CONFIG_GPIO_ADP5588=y

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_CS5535 is not set
# CONFIG_GPIO_BT8XX is not set
CONFIG_GPIO_LANGWELL=y
CONFIG_GPIO_RDC321X=y

#
# SPI GPIO expanders:
#
CONFIG_GPIO_MAX7301=y
# CONFIG_GPIO_MCP23S08 is not set
CONFIG_GPIO_MC33880=y

#
# AC97 GPIO expanders:
#

#
# MODULbus GPIO expanders:
#
CONFIG_W1=y
CONFIG_W1_CON=y

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=y
CONFIG_W1_MASTER_DS2490=y
CONFIG_W1_MASTER_DS2482=y
# CONFIG_W1_MASTER_GPIO is not set

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
CONFIG_W1_SLAVE_SMEM=y
CONFIG_W1_SLAVE_DS2431=y
CONFIG_W1_SLAVE_DS2433=y
CONFIG_W1_SLAVE_DS2433_CRC=y
CONFIG_W1_SLAVE_DS2760=y
CONFIG_W1_SLAVE_BQ27000=y
CONFIG_POWER_SUPPLY=y
CONFIG_POWER_SUPPLY_DEBUG=y
# CONFIG_PDA_POWER is not set
CONFIG_TEST_POWER=y
# CONFIG_BATTERY_DS2760 is not set
CONFIG_BATTERY_DS2782=y
CONFIG_BATTERY_WM97XX=y
# CONFIG_BATTERY_BQ27x00 is not set
CONFIG_BATTERY_MAX17040=y
# CONFIG_HWMON is not set
CONFIG_THERMAL=y
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_SPROM=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
CONFIG_SSB_B43_PCI_BRIDGE=y
CONFIG_SSB_SDIOHOST_POSSIBLE=y
CONFIG_SSB_SDIOHOST=y
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
# CONFIG_MFD_SUPPORT is not set
CONFIG_MFD_CORE=y
CONFIG_LPC_SCH=y
CONFIG_MFD_RDC321X=y
# CONFIG_REGULATOR is not set
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
# CONFIG_VIDEO_DEV is not set
CONFIG_DVB_CORE=y
CONFIG_VIDEO_MEDIA=y

#
# Multimedia drivers
#
CONFIG_IR_CORE=y
CONFIG_VIDEO_IR=y
CONFIG_RC_MAP=y
CONFIG_IR_NEC_DECODER=y
# CONFIG_IR_RC5_DECODER is not set
CONFIG_IR_RC6_DECODER=y
# CONFIG_IR_JVC_DECODER is not set
CONFIG_IR_SONY_DECODER=y
# CONFIG_IR_IMON is not set
CONFIG_MEDIA_TUNER=y
# CONFIG_MEDIA_TUNER_CUSTOMISE is not set
CONFIG_MEDIA_TUNER_SIMPLE=y
CONFIG_MEDIA_TUNER_TDA8290=y
CONFIG_MEDIA_TUNER_TDA9887=y
CONFIG_MEDIA_TUNER_TEA5761=y
CONFIG_MEDIA_TUNER_TEA5767=y
CONFIG_MEDIA_TUNER_MT20XX=y
CONFIG_MEDIA_TUNER_XC2028=y
CONFIG_MEDIA_TUNER_XC5000=y
CONFIG_MEDIA_TUNER_MC44S803=y
CONFIG_DVB_MAX_ADAPTERS=8
CONFIG_DVB_DYNAMIC_MINORS=y
# CONFIG_DVB_CAPTURE_DRIVERS is not set
CONFIG_DAB=y
CONFIG_USB_DABUSB=y

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_ALI=y
CONFIG_AGP_ATI=y
# CONFIG_AGP_AMD is not set
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
CONFIG_AGP_NVIDIA=y
CONFIG_AGP_SIS=y
CONFIG_AGP_SWORKS=y
# CONFIG_AGP_VIA is not set
CONFIG_AGP_EFFICEON=y
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=y
CONFIG_DRM_TTM=y
CONFIG_DRM_TDFX=y
CONFIG_DRM_R128=y
CONFIG_DRM_RADEON=y
CONFIG_DRM_I810=y
# CONFIG_DRM_I830 is not set
# CONFIG_DRM_I915 is not set
CONFIG_DRM_MGA=y
CONFIG_DRM_SIS=y
# CONFIG_DRM_VIA is not set
CONFIG_DRM_SAVAGE=y
CONFIG_VGASTATE=y
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_DDC=y
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=y
CONFIG_FB_SVGALIB=y
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
CONFIG_FB_PM2=y
# CONFIG_FB_PM2_FIFO_DISCONNECT is not set
CONFIG_FB_CYBER2000=y
CONFIG_FB_ARC=y
CONFIG_FB_IMSTT=y
CONFIG_FB_UVESA=y
CONFIG_FB_N411=y
CONFIG_FB_HGA=y
CONFIG_FB_HGA_ACCEL=y
# CONFIG_FB_S1D13XXX is not set
# CONFIG_FB_NVIDIA is not set
CONFIG_FB_RIVA=y
CONFIG_FB_RIVA_I2C=y
CONFIG_FB_RIVA_DEBUG=y
CONFIG_FB_RIVA_BACKLIGHT=y
CONFIG_FB_I810=y
CONFIG_FB_I810_GTF=y
CONFIG_FB_I810_I2C=y
CONFIG_FB_LE80578=y
CONFIG_FB_CARILLO_RANCH=y
CONFIG_FB_MATROX=y
# CONFIG_FB_MATROX_MILLENIUM is not set
CONFIG_FB_MATROX_MYSTIQUE=y
CONFIG_FB_MATROX_G=y
CONFIG_FB_MATROX_I2C=y
# CONFIG_FB_MATROX_MAVEN is not set
CONFIG_FB_ATY128=y
CONFIG_FB_ATY128_BACKLIGHT=y
# CONFIG_FB_ATY is not set
CONFIG_FB_S3=y
CONFIG_FB_SAVAGE=y
# CONFIG_FB_SAVAGE_I2C is not set
# CONFIG_FB_SAVAGE_ACCEL is not set
# CONFIG_FB_SIS is not set
CONFIG_FB_VIA=y
CONFIG_FB_VIA_DIRECT_PROCFS=y
CONFIG_FB_NEOMAGIC=y
CONFIG_FB_KYRO=y
CONFIG_FB_3DFX=y
CONFIG_FB_3DFX_ACCEL=y
CONFIG_FB_3DFX_I2C=y
CONFIG_FB_VOODOO1=y
CONFIG_FB_VT8623=y
CONFIG_FB_TRIDENT=y
CONFIG_FB_ARK=y
# CONFIG_FB_PM3 is not set
CONFIG_FB_CARMINE=y
# CONFIG_FB_CARMINE_DRAM_EVAL is not set
CONFIG_CARMINE_DRAM_CUSTOM=y
# CONFIG_FB_GEODE is not set
CONFIG_FB_TMIO=y
# CONFIG_FB_TMIO_ACCELL is not set
CONFIG_FB_METRONOME=y
CONFIG_FB_MB862XX=y
CONFIG_FB_MB862XX_PCI_GDC=y
CONFIG_FB_BROADSHEET=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
# CONFIG_LCD_CLASS_DEVICE is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
CONFIG_BACKLIGHT_GENERIC=y
CONFIG_BACKLIGHT_PROGEAR=y
# CONFIG_BACKLIGHT_MBP_NVIDIA is not set
CONFIG_BACKLIGHT_SAHARA=y
CONFIG_BACKLIGHT_ADP8860=y

#
# Display device support
#
CONFIG_DISPLAY_SUPPORT=y

#
# Display hardware drivers
#

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
# CONFIG_VGACON_SOFT_SCROLLBACK is not set
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
# CONFIG_FRAMEBUFFER_CONSOLE_ROTATION is not set
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_LOGO=y
CONFIG_LOGO_LINUX_MONO=y
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
CONFIG_SOUND=y
CONFIG_SOUND_OSS_CORE=y
# CONFIG_SOUND_OSS_CORE_PRECLAIM is not set
CONFIG_SND=y
CONFIG_SND_TIMER=y
CONFIG_SND_PCM=y
CONFIG_SND_HWDEP=y
CONFIG_SND_RAWMIDI=y
CONFIG_SND_JACK=y
CONFIG_SND_SEQUENCER=y
CONFIG_SND_SEQ_DUMMY=y
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=y
# CONFIG_SND_PCM_OSS is not set
CONFIG_SND_SEQUENCER_OSS=y
# CONFIG_SND_HRTIMER is not set
CONFIG_SND_RTCTIMER=y
CONFIG_SND_SEQ_RTCTIMER_DEFAULT=y
CONFIG_SND_DYNAMIC_MINORS=y
CONFIG_SND_SUPPORT_OLD_API=y
CONFIG_SND_VERBOSE_PROCFS=y
CONFIG_SND_VERBOSE_PRINTK=y
CONFIG_SND_DEBUG=y
CONFIG_SND_DEBUG_VERBOSE=y
# CONFIG_SND_PCM_XRUN_DEBUG is not set
CONFIG_SND_VMASTER=y
CONFIG_SND_DMA_SGBUF=y
CONFIG_SND_RAWMIDI_SEQ=y
CONFIG_SND_OPL3_LIB_SEQ=y
CONFIG_SND_OPL4_LIB_SEQ=y
# CONFIG_SND_SBAWE_SEQ is not set
CONFIG_SND_EMU10K1_SEQ=y
CONFIG_SND_MPU401_UART=y
CONFIG_SND_OPL3_LIB=y
CONFIG_SND_OPL4_LIB=y
CONFIG_SND_VX_LIB=y
CONFIG_SND_AC97_CODEC=y
# CONFIG_SND_DRIVERS is not set
CONFIG_SND_WSS_LIB=y
CONFIG_SND_SB_COMMON=y
CONFIG_SND_SB16_DSP=y
CONFIG_SND_ISA=y
CONFIG_SND_ADLIB=y
CONFIG_SND_AD1848=y
CONFIG_SND_CMI8330=y
# CONFIG_SND_CS4231 is not set
# CONFIG_SND_CS4236 is not set
CONFIG_SND_ES1688=y
CONFIG_SND_ES18XX=y
# CONFIG_SND_SC6000 is not set
# CONFIG_SND_GUSCLASSIC is not set
CONFIG_SND_GUSEXTREME=y
# CONFIG_SND_GUSMAX is not set
# CONFIG_SND_JAZZ16 is not set
# CONFIG_SND_OPL3SA2 is not set
CONFIG_SND_OPTI92X_AD1848=y
CONFIG_SND_OPTI92X_CS4231=y
CONFIG_SND_OPTI93X=y
CONFIG_SND_MIRO=y
# CONFIG_SND_SB8 is not set
CONFIG_SND_SB16=y
# CONFIG_SND_SBAWE is not set
CONFIG_SND_SB16_CSP=y
# CONFIG_SND_SGALAXY is not set
CONFIG_SND_SSCAPE=y
CONFIG_SND_WAVEFRONT=y
CONFIG_SND_MSND_PINNACLE=y
CONFIG_SND_MSND_CLASSIC=y
CONFIG_SND_PCI=y
# CONFIG_SND_AD1889 is not set
# CONFIG_SND_ALS300 is not set
# CONFIG_SND_ALS4000 is not set
CONFIG_SND_ALI5451=y
CONFIG_SND_ASIHPI=y
CONFIG_SND_ATIIXP=y
# CONFIG_SND_ATIIXP_MODEM is not set
CONFIG_SND_AU8810=y
CONFIG_SND_AU8820=y
CONFIG_SND_AU8830=y
# CONFIG_SND_AW2 is not set
CONFIG_SND_AZT3328=y
CONFIG_SND_BT87X=y
# CONFIG_SND_BT87X_OVERCLOCK is not set
CONFIG_SND_CA0106=y
# CONFIG_SND_CMIPCI is not set
# CONFIG_SND_OXYGEN is not set
CONFIG_SND_CS4281=y
CONFIG_SND_CS46XX=y
CONFIG_SND_CS46XX_NEW_DSP=y
CONFIG_SND_CS5530=y
CONFIG_SND_CS5535AUDIO=y
CONFIG_SND_CTXFI=y
# CONFIG_SND_DARLA20 is not set
# CONFIG_SND_GINA20 is not set
# CONFIG_SND_LAYLA20 is not set
CONFIG_SND_DARLA24=y
CONFIG_SND_GINA24=y
# CONFIG_SND_LAYLA24 is not set
CONFIG_SND_MONA=y
CONFIG_SND_MIA=y
CONFIG_SND_ECHO3G=y
# CONFIG_SND_INDIGO is not set
# CONFIG_SND_INDIGOIO is not set
CONFIG_SND_INDIGODJ=y
CONFIG_SND_INDIGOIOX=y
CONFIG_SND_INDIGODJX=y
CONFIG_SND_EMU10K1=y
CONFIG_SND_EMU10K1X=y
# CONFIG_SND_ENS1370 is not set
CONFIG_SND_ENS1371=y
# CONFIG_SND_ES1938 is not set
CONFIG_SND_ES1968=y
CONFIG_SND_ES1968_INPUT=y
# CONFIG_SND_FM801 is not set
CONFIG_SND_HDA_INTEL=y
CONFIG_SND_HDA_HWDEP=y
CONFIG_SND_HDA_RECONFIG=y
CONFIG_SND_HDA_INPUT_BEEP=y
CONFIG_SND_HDA_INPUT_BEEP_MODE=1
CONFIG_SND_HDA_INPUT_JACK=y
CONFIG_SND_HDA_PATCH_LOADER=y
# CONFIG_SND_HDA_CODEC_REALTEK is not set
# CONFIG_SND_HDA_CODEC_ANALOG is not set
CONFIG_SND_HDA_CODEC_SIGMATEL=y
CONFIG_SND_HDA_CODEC_VIA=y
CONFIG_SND_HDA_CODEC_ATIHDMI=y
CONFIG_SND_HDA_CODEC_NVHDMI=y
# CONFIG_SND_HDA_CODEC_INTELHDMI is not set
CONFIG_SND_HDA_ELD=y
CONFIG_SND_HDA_CODEC_CIRRUS=y
CONFIG_SND_HDA_CODEC_CONEXANT=y
# CONFIG_SND_HDA_CODEC_CA0110 is not set
CONFIG_SND_HDA_CODEC_CMEDIA=y
CONFIG_SND_HDA_CODEC_SI3054=y
CONFIG_SND_HDA_GENERIC=y
CONFIG_SND_HDA_POWER_SAVE=y
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=0
CONFIG_SND_HDSP=y

#
# Don't forget to add built-in firmwares for HDSP driver
#
CONFIG_SND_HDSPM=y
# CONFIG_SND_HIFIER is not set
CONFIG_SND_ICE1712=y
# CONFIG_SND_ICE1724 is not set
CONFIG_SND_INTEL8X0=y
CONFIG_SND_INTEL8X0M=y
# CONFIG_SND_KORG1212 is not set
# CONFIG_SND_LX6464ES is not set
CONFIG_SND_MAESTRO3=y
CONFIG_SND_MAESTRO3_INPUT=y
# CONFIG_SND_MIXART is not set
# CONFIG_SND_NM256 is not set
CONFIG_SND_PCXHR=y
CONFIG_SND_RIPTIDE=y
CONFIG_SND_RME32=y
# CONFIG_SND_RME96 is not set
CONFIG_SND_RME9652=y
CONFIG_SND_SIS7019=y
CONFIG_SND_SONICVIBES=y
CONFIG_SND_TRIDENT=y
CONFIG_SND_VIA82XX=y
CONFIG_SND_VIA82XX_MODEM=y
# CONFIG_SND_VIRTUOSO is not set
CONFIG_SND_VX222=y
# CONFIG_SND_YMFPCI is not set
CONFIG_SND_SPI=y
CONFIG_SND_USB=y
# CONFIG_SND_USB_AUDIO is not set
# CONFIG_SND_USB_UA101 is not set
# CONFIG_SND_USB_USX2Y is not set
CONFIG_SND_USB_CAIAQ=y
CONFIG_SND_USB_CAIAQ_INPUT=y
CONFIG_SND_USB_US122L=y
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set
CONFIG_AC97_BUS=y
# CONFIG_HID_SUPPORT is not set
CONFIG_USB_MOUSE=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
CONFIG_USB_DEBUG=y
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
# CONFIG_USB_DEVICE_CLASS is not set
CONFIG_USB_DYNAMIC_MINORS=y
CONFIG_USB_MON=y
CONFIG_USB_WUSB=y
CONFIG_USB_WUSB_CBAF=y
CONFIG_USB_WUSB_CBAF_DEBUG=y

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_XHCI_HCD=y
CONFIG_USB_XHCI_HCD_DEBUGGING=y
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_OXU210HP_HCD=y
CONFIG_USB_ISP116X_HCD=y
# CONFIG_USB_ISP1760_HCD is not set
# CONFIG_USB_ISP1362_HCD is not set
CONFIG_USB_OHCI_HCD=y
# CONFIG_USB_OHCI_HCD_SSB is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=y
CONFIG_USB_SL811_HCD=y
CONFIG_USB_R8A66597_HCD=y
CONFIG_USB_HWA_HCD=y

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
CONFIG_USB_PRINTER=y
# CONFIG_USB_WDM is not set
CONFIG_USB_TMC=y

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=y
CONFIG_USB_STORAGE_DEBUG=y
CONFIG_USB_STORAGE_DATAFAB=y
CONFIG_USB_STORAGE_FREECOM=y
# CONFIG_USB_STORAGE_ISD200 is not set
CONFIG_USB_STORAGE_USBAT=y
CONFIG_USB_STORAGE_SDDR09=y
# CONFIG_USB_STORAGE_SDDR55 is not set
CONFIG_USB_STORAGE_JUMPSHOT=y
CONFIG_USB_STORAGE_ALAUDA=y
# CONFIG_USB_STORAGE_ONETOUCH is not set
CONFIG_USB_STORAGE_KARMA=y
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
CONFIG_USB_LIBUSUAL=y

#
# USB Imaging devices
#
CONFIG_USB_MDC800=y
CONFIG_USB_MICROTEK=y

#
# USB port drivers
#
CONFIG_USB_USS720=y
# CONFIG_USB_SERIAL is not set

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=y
CONFIG_USB_EMI26=y
# CONFIG_USB_ADUTUX is not set
CONFIG_USB_SEVSEG=y
CONFIG_USB_RIO500=y
CONFIG_USB_LEGOTOWER=y
# CONFIG_USB_LCD is not set
CONFIG_USB_LED=y
# CONFIG_USB_CYPRESS_CY7C63 is not set
CONFIG_USB_CYTHERM=y
# CONFIG_USB_IDMOUSE is not set
# CONFIG_USB_FTDI_ELAN is not set
CONFIG_USB_APPLEDISPLAY=y
# CONFIG_USB_SISUSBVGA is not set
# CONFIG_USB_LD is not set
# CONFIG_USB_TRANCEVIBRATOR is not set
# CONFIG_USB_IOWARRIOR is not set
CONFIG_USB_TEST=y
CONFIG_USB_ISIGHTFW=y
# CONFIG_USB_ATM is not set

#
# OTG and related infrastructure
#
# CONFIG_USB_GPIO_VBUS is not set
# CONFIG_NOP_USB_XCEIV is not set
CONFIG_UWB=y
CONFIG_UWB_HWA=y
CONFIG_UWB_WHCI=y
# CONFIG_UWB_WLP is not set
CONFIG_UWB_I1480U=y
CONFIG_MMC=y
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set

#
# MMC/SD/SDIO Card Drivers
#
CONFIG_MMC_BLOCK=y
CONFIG_MMC_BLOCK_BOUNCE=y
CONFIG_SDIO_UART=y
# CONFIG_MMC_TEST is not set

#
# MMC/SD/SDIO Host Controller Drivers
#
CONFIG_MMC_SDHCI=y
# CONFIG_MMC_SDHCI_PCI is not set
CONFIG_MMC_SDHCI_PLTFM=y
CONFIG_MMC_WBSD=y
CONFIG_MMC_TIFM_SD=y
# CONFIG_MMC_CB710 is not set
# CONFIG_MMC_VIA_SDMMC is not set
CONFIG_MEMSTICK=y
CONFIG_MEMSTICK_DEBUG=y

#
# MemoryStick drivers
#
CONFIG_MEMSTICK_UNSAFE_RESUME=y
CONFIG_MSPRO_BLOCK=y

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=y
# CONFIG_MEMSTICK_JMICRON_38X is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_ALIX2 is not set
# CONFIG_LEDS_PCA9532 is not set
# CONFIG_LEDS_GPIO is not set
CONFIG_LEDS_LP3944=y
# CONFIG_LEDS_CLEVO_MAIL is not set
CONFIG_LEDS_PCA955X=y
CONFIG_LEDS_DAC124S085=y
CONFIG_LEDS_BD2802=y
CONFIG_LEDS_LT3593=y
CONFIG_LEDS_TRIGGERS=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGER_TIMER=y
CONFIG_LEDS_TRIGGER_HEARTBEAT=y
# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
CONFIG_LEDS_TRIGGER_GPIO=y
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
# CONFIG_ACCESSIBILITY is not set
# CONFIG_INFINIBAND is not set
CONFIG_EDAC=y

#
# Reporting subsystems
#
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_DECODE_MCE=y
# CONFIG_EDAC_MM_EDAC is not set
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
CONFIG_ASYNC_TX_DISABLE_CHANNEL_SWITCH=y
CONFIG_INTEL_IOATDMA=y
CONFIG_TIMB_DMA=y
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#
CONFIG_NET_DMA=y
CONFIG_ASYNC_TX_DMA=y
CONFIG_DMATEST=y
CONFIG_DCA=y
CONFIG_AUXDISPLAY=y
# CONFIG_KS0108 is not set
# CONFIG_UIO is not set
# CONFIG_X86_PLATFORM_DEVICES is not set

#
# Firmware Drivers
#
CONFIG_EDD=y
CONFIG_EDD_OFF=y
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_DMIID=y
CONFIG_ISCSI_IBFT_FIND=y
CONFIG_ISCSI_IBFT=y

#
# File systems
#
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
# CONFIG_EXT2_FS_SECURITY is not set
CONFIG_EXT2_FS_XIP=y
CONFIG_EXT3_FS=y
# CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=y
CONFIG_EXT4_FS_XATTR=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
# CONFIG_EXT4_DEBUG is not set
CONFIG_FS_XIP=y
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=y
CONFIG_JBD2_DEBUG=y
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=y
# CONFIG_REISERFS_CHECK is not set
CONFIG_REISERFS_PROC_INFO=y
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
CONFIG_REISERFS_FS_SECURITY=y
CONFIG_JFS_FS=y
# CONFIG_JFS_POSIX_ACL is not set
CONFIG_JFS_SECURITY=y
# CONFIG_JFS_DEBUG is not set
# CONFIG_JFS_STATISTICS is not set
CONFIG_FS_POSIX_ACL=y
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
# CONFIG_BTRFS_FS is not set
CONFIG_NILFS2_FS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
# CONFIG_INOTIFY is not set
CONFIG_INOTIFY_USER=y
# CONFIG_QUOTA is not set
CONFIG_AUTOFS_FS=y
CONFIG_AUTOFS4_FS=y
CONFIG_FUSE_FS=y
# CONFIG_CUSE is not set
CONFIG_GENERIC_ACL=y

#
# Caches
#
CONFIG_FSCACHE=y
# CONFIG_FSCACHE_STATS is not set
CONFIG_FSCACHE_HISTOGRAM=y
# CONFIG_FSCACHE_DEBUG is not set
CONFIG_FSCACHE_OBJECT_LIST=y
# CONFIG_CACHEFILES is not set

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
# CONFIG_JOLIET is not set
CONFIG_ZISOFS=y
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
# CONFIG_MSDOS_FS is not set
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
CONFIG_NTFS_FS=y
CONFIG_NTFS_DEBUG=y
CONFIG_NTFS_RW=y

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=y
# CONFIG_MISC_FILESYSTEMS is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=y
# CONFIG_NFS_V3 is not set
CONFIG_NFS_V4=y
CONFIG_NFS_V4_1=y
CONFIG_ROOT_NFS=y
CONFIG_NFS_FSCACHE=y
# CONFIG_NFSD is not set
CONFIG_LOCKD=y
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=y
CONFIG_SUNRPC_GSS=y
CONFIG_RPCSEC_GSS_KRB5=y
CONFIG_RPCSEC_GSS_SPKM3=y
# CONFIG_SMB_FS is not set
CONFIG_CEPH_FS=y
CONFIG_CEPH_FS_PRETTYDEBUG=y
CONFIG_CIFS=y
CONFIG_CIFS_STATS=y
CONFIG_CIFS_STATS2=y
CONFIG_CIFS_WEAK_PW_HASH=y
CONFIG_CIFS_UPCALL=y
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
# CONFIG_CIFS_DEBUG2 is not set
# CONFIG_CIFS_DFS_UPCALL is not set
CONFIG_CIFS_EXPERIMENTAL=y
CONFIG_NCP_FS=y
CONFIG_NCPFS_PACKET_SIGNING=y
CONFIG_NCPFS_IOCTL_LOCKING=y
CONFIG_NCPFS_STRONG=y
CONFIG_NCPFS_NFS_NS=y
# CONFIG_NCPFS_OS2_NS is not set
CONFIG_NCPFS_SMALLDOS=y
CONFIG_NCPFS_NLS=y
# CONFIG_NCPFS_EXTRAS is not set
# CONFIG_CODA_FS is not set
CONFIG_AFS_FS=y
CONFIG_AFS_DEBUG=y
CONFIG_AFS_FSCACHE=y

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
CONFIG_ACORN_PARTITION=y
# CONFIG_ACORN_PARTITION_CUMANA is not set
CONFIG_ACORN_PARTITION_EESOX=y
CONFIG_ACORN_PARTITION_ICS=y
# CONFIG_ACORN_PARTITION_ADFS is not set
# CONFIG_ACORN_PARTITION_POWERTEC is not set
CONFIG_ACORN_PARTITION_RISCIX=y
CONFIG_OSF_PARTITION=y
# CONFIG_AMIGA_PARTITION is not set
CONFIG_ATARI_PARTITION=y
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
# CONFIG_SOLARIS_X86_PARTITION is not set
CONFIG_UNIXWARE_DISKLABEL=y
CONFIG_LDM_PARTITION=y
CONFIG_LDM_DEBUG=y
CONFIG_SGI_PARTITION=y
CONFIG_ULTRIX_PARTITION=y
# CONFIG_SUN_PARTITION is not set
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
CONFIG_SYSV68_PARTITION=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=y
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_CODEPAGE_852=y
# CONFIG_NLS_CODEPAGE_855 is not set
CONFIG_NLS_CODEPAGE_857=y
# CONFIG_NLS_CODEPAGE_860 is not set
CONFIG_NLS_CODEPAGE_861=y
CONFIG_NLS_CODEPAGE_862=y
CONFIG_NLS_CODEPAGE_863=y
CONFIG_NLS_CODEPAGE_864=y
# CONFIG_NLS_CODEPAGE_865 is not set
CONFIG_NLS_CODEPAGE_866=y
CONFIG_NLS_CODEPAGE_869=y
CONFIG_NLS_CODEPAGE_936=y
# CONFIG_NLS_CODEPAGE_950 is not set
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
# CONFIG_NLS_CODEPAGE_874 is not set
CONFIG_NLS_ISO8859_8=y
CONFIG_NLS_CODEPAGE_1250=y
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
# CONFIG_NLS_ISO8859_2 is not set
CONFIG_NLS_ISO8859_3=y
# CONFIG_NLS_ISO8859_4 is not set
# CONFIG_NLS_ISO8859_5 is not set
CONFIG_NLS_ISO8859_6=y
CONFIG_NLS_ISO8859_7=y
# CONFIG_NLS_ISO8859_9 is not set
CONFIG_NLS_ISO8859_13=y
CONFIG_NLS_ISO8859_14=y
# CONFIG_NLS_ISO8859_15 is not set
# CONFIG_NLS_KOI8_R is not set
CONFIG_NLS_KOI8_U=y
CONFIG_NLS_UTF8=y
CONFIG_DLM=y
CONFIG_DLM_DEBUG=y

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
# CONFIG_PRINTK_TIME is not set
# CONFIG_ENABLE_WARN_DEPRECATED is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=1024
CONFIG_MAGIC_SYSRQ=y
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_UNUSED_SYMBOLS is not set
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
# CONFIG_DEBUG_KERNEL is not set
# CONFIG_HARDLOCKUP_DETECTOR is not set
CONFIG_SLUB_DEBUG_ON=y
CONFIG_SLUB_STATS=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_STACKTRACE=y
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
CONFIG_RCU_CPU_STALL_DETECTOR=y
# CONFIG_LKDTM is not set
# CONFIG_LATENCYTOP is not set
CONFIG_SYSCTL_SYSCALL_CHECK=y
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
CONFIG_TRACER_MAX_TRACE=y
CONFIG_RING_BUFFER=y
CONFIG_FTRACE_NMI_ENTER=y
CONFIG_EVENT_TRACING=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
CONFIG_FUNCTION_GRAPH_TRACER=y
CONFIG_IRQSOFF_TRACER=y
# CONFIG_SYSPROF_TRACER is not set
CONFIG_SCHED_TRACER=y
CONFIG_FTRACE_SYSCALLS=y
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
CONFIG_KSYM_TRACER=y
CONFIG_PROFILE_KSYM_TRACER=y
CONFIG_STACK_TRACER=y
CONFIG_WORKQUEUE_TRACER=y
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_DYNAMIC_FTRACE=y
# CONFIG_FUNCTION_PROFILER is not set
CONFIG_FTRACE_MCOUNT_RECORD=y
# CONFIG_FTRACE_STARTUP_TEST is not set
CONFIG_MMIOTRACE=y
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
# CONFIG_FIREWIRE_OHCI_REMOTE_DMA is not set
CONFIG_BUILD_DOCSRC=y
CONFIG_DYNAMIC_DEBUG=y
CONFIG_DMA_API_DEBUG=y
# CONFIG_ATOMIC64_SELFTEST is not set
CONFIG_SAMPLES=y
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
CONFIG_EARLY_PRINTK=y
CONFIG_EARLY_PRINTK_DBGP=y
CONFIG_DOUBLEFAULT=y
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
CONFIG_IO_DELAY_UDELAY=y
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=2
CONFIG_OPTIMIZE_INLINING=y

#
# Security options
#
CONFIG_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
CONFIG_SECURITY=y
CONFIG_SECURITYFS=y
CONFIG_SECURITY_NETWORK=y
# CONFIG_SECURITY_NETWORK_XFRM is not set
CONFIG_SECURITY_PATH=y
CONFIG_LSM_MMAP_MIN_ADDR=65536
CONFIG_SECURITY_SELINUX=y
# CONFIG_SECURITY_SELINUX_BOOTPARAM is not set
CONFIG_SECURITY_SELINUX_DISABLE=y
CONFIG_SECURITY_SELINUX_DEVELOP=y
CONFIG_SECURITY_SELINUX_AVC_STATS=y
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
CONFIG_SECURITY_TOMOYO=y
CONFIG_IMA=y
CONFIG_IMA_MEASURE_PCR_IDX=10
CONFIG_IMA_AUDIT=y
CONFIG_IMA_LSM_RULES=y
CONFIG_DEFAULT_SECURITY_SELINUX=y
# CONFIG_DEFAULT_SECURITY_SMACK is not set
# CONFIG_DEFAULT_SECURITY_TOMOYO is not set
# CONFIG_DEFAULT_SECURITY_DAC is not set
CONFIG_DEFAULT_SECURITY="selinux"
CONFIG_ASYNC_TX_DISABLE_PQ_VAL_DMA=y
CONFIG_ASYNC_TX_DISABLE_XOR_VAL_DMA=y
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_FIPS=y
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
CONFIG_CRYPTO_WORKQUEUE=y
# CONFIG_CRYPTO_CRYPTD is not set
CONFIG_CRYPTO_AUTHENC=y

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
CONFIG_CRYPTO_GCM=y
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
CONFIG_CRYPTO_PCBC=y
# CONFIG_CRYPTO_XTS is not set

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=y
CONFIG_CRYPTO_VMAC=y

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
# CONFIG_CRYPTO_CRC32C_INTEL is not set
CONFIG_CRYPTO_GHASH=y
CONFIG_CRYPTO_MD4=y
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
CONFIG_CRYPTO_RMD128=y
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
CONFIG_CRYPTO_RMD320=y
CONFIG_CRYPTO_SHA1=y
# CONFIG_CRYPTO_SHA256 is not set
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=y
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
CONFIG_CRYPTO_BLOWFISH=y
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAST5=y
CONFIG_CRYPTO_CAST6=y
CONFIG_CRYPTO_DES=y
CONFIG_CRYPTO_FCRYPT=y
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=y
# CONFIG_CRYPTO_SALSA20_586 is not set
# CONFIG_CRYPTO_SEED is not set
# CONFIG_CRYPTO_SERPENT is not set
CONFIG_CRYPTO_TEA=y
# CONFIG_CRYPTO_TWOFISH is not set
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_586=y

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=y
CONFIG_CRYPTO_ZLIB=y
# CONFIG_CRYPTO_LZO is not set

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=y
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_PADLOCK=y
# CONFIG_CRYPTO_DEV_PADLOCK_AES is not set
# CONFIG_CRYPTO_DEV_PADLOCK_SHA is not set
CONFIG_CRYPTO_DEV_GEODE=y
CONFIG_CRYPTO_DEV_HIFN_795X=y
CONFIG_CRYPTO_DEV_HIFN_795X_RNG=y
CONFIG_HAVE_KVM=y
CONFIG_HAVE_KVM_IRQCHIP=y
CONFIG_HAVE_KVM_EVENTFD=y
CONFIG_KVM_APIC_ARCHITECTURE=y
CONFIG_KVM_MMIO=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=y
# CONFIG_KVM_INTEL is not set
# CONFIG_KVM_AMD is not set
CONFIG_VHOST_NET=y
CONFIG_LGUEST=y
CONFIG_VIRTIO=y
CONFIG_VIRTIO_RING=y
CONFIG_VIRTIO_PCI=y
CONFIG_VIRTIO_BALLOON=y
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
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
CONFIG_CRC7=y
CONFIG_LIBCRC32C=y
CONFIG_AUDIT_GENERIC=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=y
CONFIG_TEXTSEARCH_BM=y
CONFIG_TEXTSEARCH_FSM=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_NLATTR=y
CONFIG_LRU_CACHE=y
CONFIG_FORCE_SUCCESSFUL_BUILD=y
CONFIG_FORCE_MINIMAL_CONFIG=y
CONFIG_FORCE_MINIMAL_CONFIG_PHYS=y
CONFIG_X86_32_ALWAYS_ON=y

--X1bOJ3K7DJ5YkBrT--
