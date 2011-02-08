Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab1BHPCZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 10:02:25 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:59170 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754673Ab1BHPCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 10:02:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=lun69mV2soiK1QqcRGBAk2s6Q1NOxM1UCIlVC/a9TVN4aeOgRuoapIsyM004ZKMeFT
         jmNw//1b6gS09COblw0QAHYS8LX6VCDSVewUNtDM/LFu/11KfR+1oLu/fn5wSAyR6MEx
         Wo1+RopVDDFICfJ8F4t8F8YQOChGTL7cpcwLE=
Message-ID: <4D515AF7.1050807@gmail.com>
Date: Tue, 08 Feb 2011 07:02:15 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Fwd: WARNING: at kernel/lockdep.c:3151 check_flags+0x63/0x179()
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

not sure if this is o.k.or not, due to the message giving me a few
messages(full dmesg below)

[    0.046719] lockdep: fixing up alternatives.
[    0.046981] ------------[ cut here ]------------
[    0.046996] WARNING: at kernel/lockdep.c:3151 check_flags+0x63/0x179()
[    0.046996] Hardware name: MacBookPro2,2
[    0.046996] Modules linked in:
[    0.046996] Pid: 4, comm: kworker/0:0 Not tainted 2.6.38-rc4 #1
[    0.046996] Call Trace:
[    0.046996]  [<ffffffff81062aa8>] ? warn_slowpath_common+0x80/0x98
[    0.046996]  [<ffffffff8106ff00>] ? del_timer_sync+0x0/0xad
[    0.046996]  [<ffffffff81062ad5>] ? warn_slowpath_null+0x15/0x17
[    0.046996]  [<ffffffff8108e4fd>] ? check_flags+0x63/0x179
[    0.046996]  [<ffffffff81093d9f>] ? lock_acquire+0x59/0x109
[    0.046996]  [<ffffffff8105b199>] ? get_parent_ip+0x11/0x41
[    0.046996]  [<ffffffff8106ff48>] ? del_timer_sync+0x48/0xad
[    0.046996]  [<ffffffff8106ff00>] ? del_timer_sync+0x0/0xad
[    0.046996]  [<ffffffff81079634>] ? manage_workers+0xee/0x191
[    0.046996]  [<ffffffff81079810>] ? worker_thread+0x139/0x350
[    0.046996]  [<ffffffff810796d7>] ? worker_thread+0x0/0x350
[    0.046996]  [<ffffffff8107ecfc>] ? kthread+0x89/0x91
[    0.046996]  [<ffffffff8102e9a4>] ? kernel_thread_helper+0x4/0x10
[    0.046996]  [<ffffffff81483354>] ? restore_args+0x0/0x30
[    0.046996]  [<ffffffff8107ec73>] ? kthread+0x0/0x91
[    0.046996]  [<ffffffff8102e9a0>] ? kernel_thread_helper+0x0/0x10
[    0.046996] ---[ end trace 4eaa2a86a8e2da22 ]---
[    0.046996] possible reason: unannotated irqs-off.
[    0.046996] irq event stamp: 40



<----- cut   ----->


] Initializing RT-Tester: OK
[    0.477516] ====[ backtrace testing ]===========
[    0.477685] Testing a backtrace from process context.
[    0.477853] The following trace is a kernel self test and not a bug!
[    0.478146] Pid: 1, comm: swapper Tainted: G        W   2.6.38-rc4 #1
[    0.478318] Call Trace:
[    0.478495]  [<ffffffff810a59c5>] ? backtrace_regression_test+0x38/0xff
[    0.478671]  [<ffffffff81480c2d>] ? mutex_unlock+0x9/0xb
[    0.478845]  [<ffffffff812bbfc0>] ? misc_register+0x10d/0x115
[    0.479037]  [<ffffffff81953134>] ? snapshot_device_init+0x0/0x12
[    0.479212]  [<ffffffff81000210>] ? do_one_initcall+0x7a/0x139
[    0.479388]  [<ffffffff8193f68e>] ? kernel_init+0x13d/0x1c1
[    0.479561]  [<ffffffff8102e9a4>] ? kernel_thread_helper+0x4/0x10
[    0.479735]  [<ffffffff81483354>] ? restore_args+0x0/0x30
[    0.479906]  [<ffffffff8193f551>] ? kernel_init+0x0/0x1c1
[    0.480095]  [<ffffffff8102e9a0>] ? kernel_thread_helper+0x0/0x10
[    0.480266] Testing a backtrace from irq context.



full dmesg..:

[    0.000000] Linux version 2.6.38-rc4 (justin@Linux-2) (gcc version
4.4.2 (GCC) ) #1 SMP Mon Feb 7 19:33:30 PST 2011
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz root=/dev/sda3 ro
debug audit=1 selinux=1 enforcing=0 vga=790
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003f083000 (usable)
[    0.000000]  BIOS-e820: 000000003f083000 - 000000003f284000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003f284000 - 000000003febe000 (ACPI data)
[    0.000000]  BIOS-e820: 000000003febe000 - 000000003feef000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003feef000 - 000000003ff00000 (ACPI data)
[    0.000000]  BIOS-e820: 000000003ff00000 - 0000000040000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] DMI: Mac-F42187C8/MacBookPro2,2, BIOS
MBP22.88Z.00A5.B07.0708131242 08/13/07
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000
(usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000
(usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x3f083 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-DFFFF uncachable
[    0.000000]   E0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0FFE00000 mask FFFE00000 write-protect
[    0.000000]   1 base 000000000 mask FC0000000 write-back
[    0.000000]   2 base 03FF00000 mask FFFF00000 uncachable
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new
0x7010600070106
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-000000003f083000
[    0.000000]  0000000000 - 003f000000 page 2M
[    0.000000]  003f000000 - 003f083000 page 4k
[    0.000000] kernel direct mapping tables up to 3f083000 @
1fffd000-20000000
[    0.000000] ACPI: RSDP 00000000000fe020 00024 (v02 APPLE )
[    0.000000] ACPI: XSDT 000000003fefd1c0 00074 (v01 APPLE   Apple00
000000A5      01000013)
[    0.000000] ACPI: FACP 000000003fefb000 000F4 (v03 APPLE   Apple00
000000A5 Loki 0000005F)
[    0.000000] ACPI: DSDT 000000003fef0000 048D1 (v01 APPLE  MacBookP
00020002 INTL 20050309)
[    0.000000] ACPI: FACS 000000003fec0000 00040
[    0.000000] ACPI: HPET 000000003fefa000 00038 (v01 APPLE   Apple00
00000001 Loki 0000005F)
[    0.000000] ACPI: APIC 000000003fef9000 00068 (v01 APPLE   Apple00
00000001 Loki 0000005F)
[    0.000000] ACPI: MCFG 000000003fef8000 0003C (v01 APPLE   Apple00
00000001 Loki 0000005F)
[    0.000000] ACPI: ASF! 000000003fef7000 000A0 (v32 APPLE   Apple00
00000001 Loki 0000005F)
[    0.000000] ACPI: SBST 000000003fef6000 00030 (v01 APPLE   Apple00
00000001 Loki 0000005F)
[    0.000000] ACPI: ECDT 000000003fef5000 00053 (v01 APPLE   Apple00
00000001 Loki 0000005F)
[    0.000000] ACPI: SSDT 000000003feef000 004DC (v01 APPLE     CpuPm
00003000 INTL 20050309)
[    0.000000] ACPI: SSDT 000000003febd000 0064F (v01 SataRe  SataPri
00001000 INTL 20050309)
[    0.000000] ACPI: SSDT 000000003febc000 0069C (v01 SataRe  SataSec
00001000 INTL 20050309)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000]  [ffffea0000000000-ffffea0000dfffff] PMD ->
[ffff88003d800000-ffff88003e5fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   empty
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0003f083
[    0.000000] On node 0 totalpages: 258066
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3921 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 3474 pages used for memmap
[    0.000000]   DMA32 zone: 250609 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI
0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009f000 -
00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 -
00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 -
0000000000100000
[    0.000000] Allocating PCI resources starting at 40000000 (gap:
40000000:b0000000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2
nr_node_ids:1
[    0.000000] PERCPU: Embedded 474 pages/cpu @ffff88003d400000 s1912768
r8192 d20544 u2097152
[    0.000000] pcpu-alloc: s1912768 r8192 d20544 u2097152 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.
Total pages: 254530
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz
root=/dev/sda3 ro debug audit=1 selinux=1 enforcing=0 vga=790
[    0.000000] audit: enabled (after initialization)
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 8,
1048576 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 7, 524288
bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 992612k/1032716k available (4649k kernel code,
452k absent, 39652k reserved, 2943k data, 2312k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0,
CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU lockdep checking is enabled.
[    0.000000] NR_IRQS:320
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat,
Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 6367 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000]
----------------------------------------------------------------------------
[    0.000000]                                  | spin |wlock |rlock
|mutex | wsem | rsem |
[    0.000000]
--------------------------------------------------------------------------
[    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |
ok  |  ok  |  ok  |
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |
ok  |  ok  |  ok  |
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |
ok  |  ok  |  ok  |
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |
ok  |  ok  |  ok  |
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |
ok  |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |
ok  |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |
ok  |  ok  |  ok  |
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |
ok  |  ok  |  ok  |
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |
ok  |  ok  |  ok  |
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |
ok  |  ok  |  ok  |
[    0.000000]
--------------------------------------------------------------------------
[    0.000000]               recursive read-lock:             |  ok  |
            |  ok  |
[    0.000000]            recursive read-lock #2:             |  ok  |
            |  ok  |
[    0.000000]             mixed read-write-lock:             |  ok  |
            |  ok  |
[    0.000000]             mixed write-read-lock:             |  ok  |
            |  ok  |
[    0.000000]
--------------------------------------------------------------------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq read-recursion/123:  ok  |
[    0.000000]       soft-irq read-recursion/123:  ok  |
[    0.000000]       hard-irq read-recursion/132:  ok  |
[    0.000000]       soft-irq read-recursion/132:  ok  |
[    0.000000]       hard-irq read-recursion/213:  ok  |
[    0.000000]       soft-irq read-recursion/213:  ok  |
[    0.000000]       hard-irq read-recursion/231:  ok  |
[    0.000000]       soft-irq read-recursion/231:  ok  |
[    0.000000]       hard-irq read-recursion/312:  ok  |
[    0.000000]       soft-irq read-recursion/312:  ok  |
[    0.000000]       hard-irq read-recursion/321:  ok  |
[    0.000000]       soft-irq read-recursion/321:  ok  |
[    0.000000] -------------------------------------------------------
[    0.000000] Good, all 218 testcases passed! |
[    0.000000] ---------------------------------
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2161.271 MHz processor.
[    0.001005] Calibrating delay loop (skipped), value calculated using
timer frequency.. 4322.54 BogoMIPS (lpj=2161271)
[    0.001346] pid_max: default: 32768 minimum: 301
[    0.002209] Security Framework initialized
[    0.002391] SELinux:  Initializing.
[    0.002644] SELinux:  Starting in permissive mode
[    0.003071] Mount-cache hash table entries: 256
[    0.004949] CPU: Physical Processor ID: 0
[    0.005007] CPU: Processor Core ID: 0
[    0.005175] mce: CPU supports 6 MCE banks
[    0.005352] CPU0: Thermal monitoring enabled (TM2)
[    0.005524] using mwait in idle threads.
[    0.007121] ACPI: Core revision 20110112
[    0.033616] Setting APIC routing to flat
[    0.034295] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.044476] CPU0: Intel(R) Core(TM)2 CPU         T7400  @ 2.16GHz
stepping 06
[    0.044996] Performance Events: PEBS fmt0-, Core2 events, Intel PMU
driver.
[    0.044996] PEBS disabled due to CPU errata.
[    0.044996] ... version:                2
[    0.044996] ... bit width:              40
[    0.044996] ... generic registers:      2
[    0.045000] ... value mask:             000000ffffffffff
[    0.045171] ... max period:             000000007fffffff
[    0.045341] ... fixed-purpose events:   3
[    0.045510] ... event mask:             0000000700000003
[    0.046719] lockdep: fixing up alternatives.
[    0.046981] ------------[ cut here ]------------
[    0.046996] WARNING: at kernel/lockdep.c:3151 check_flags+0x63/0x179()
[    0.046996] Hardware name: MacBookPro2,2
[    0.046996] Modules linked in:
[    0.046996] Pid: 4, comm: kworker/0:0 Not tainted 2.6.38-rc4 #1
[    0.046996] Call Trace:
[    0.046996]  [<ffffffff81062aa8>] ? warn_slowpath_common+0x80/0x98
[    0.046996]  [<ffffffff8106ff00>] ? del_timer_sync+0x0/0xad
[    0.046996]  [<ffffffff81062ad5>] ? warn_slowpath_null+0x15/0x17
[    0.046996]  [<ffffffff8108e4fd>] ? check_flags+0x63/0x179
[    0.046996]  [<ffffffff81093d9f>] ? lock_acquire+0x59/0x109
[    0.046996]  [<ffffffff8105b199>] ? get_parent_ip+0x11/0x41
[    0.046996]  [<ffffffff8106ff48>] ? del_timer_sync+0x48/0xad
[    0.046996]  [<ffffffff8106ff00>] ? del_timer_sync+0x0/0xad
[    0.046996]  [<ffffffff81079634>] ? manage_workers+0xee/0x191
[    0.046996]  [<ffffffff81079810>] ? worker_thread+0x139/0x350
[    0.046996]  [<ffffffff810796d7>] ? worker_thread+0x0/0x350
[    0.046996]  [<ffffffff8107ecfc>] ? kthread+0x89/0x91
[    0.046996]  [<ffffffff8102e9a4>] ? kernel_thread_helper+0x4/0x10
[    0.046996]  [<ffffffff81483354>] ? restore_args+0x0/0x30
[    0.046996]  [<ffffffff8107ec73>] ? kthread+0x0/0x91
[    0.046996]  [<ffffffff8102e9a0>] ? kernel_thread_helper+0x0/0x10
[    0.046996] ---[ end trace 4eaa2a86a8e2da22 ]---
[    0.046996] possible reason: unannotated irqs-off.
[    0.046996] irq event stamp: 40
[    0.046996] hardirqs last  enabled at (39): [<ffffffff8148308b>]
_raw_spin_unlock_irqrestore+0x42/0x51
[    0.046996] hardirqs last disabled at (38): [<ffffffff81055600>]
task_rq_lock+0x35/0x7e
[    0.046996] softirqs last  enabled at (0): [<ffffffff81061344>]
copy_process+0x35c/0x1120
[    0.046996] softirqs last disabled at (40): [<ffffffff8106ff25>]
del_timer_sync+0x25/0xad
[    0.047047] Booting Node   0, Processors  #1 Ok.
[    0.120017] Brought up 2 CPUs
[    0.120189] Total of 2 processors activated (8644.86 BogoMIPS).
[    0.123145] atomic64 test passed for x86-64 platform with CX8 and
with SSE
[    0.123470] NET: Registered protocol family 16
[    0.125255] ACPI: bus type pci registered
[    0.125992] PCI: Using configuration type 1 for base access
[    0.152094] bio: create slab <bio-0> at 0
[    0.157600] ACPI: EC: EC description table is found, configuring boot EC
[    0.168807] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.174509] ACPI: SSDT 000000003feb8c10 002AE (v01 APPLE   Cpu0Ist
00003000 INTL 20050309)
[    0.175992] ACPI: Dynamic OEM Table Load:
[    0.176337] ACPI: SSDT           (null) 002AE (v01 APPLE   Cpu0Ist
00003000 INTL 20050309)
[    0.177633] ACPI: SSDT 000000003feb8910 002A0 (v01 APPLE   Cpu0Cst
00003001 INTL 20050309)
[    0.179011] ACPI: Dynamic OEM Table Load:
[    0.179354] ACPI: SSDT           (null) 002A0 (v01 APPLE   Cpu0Cst
00003001 INTL 20050309)
[    0.183787] ACPI: SSDT 000000003feb8f10 00087 (v01 APPLE   Cpu1Ist
00003000 INTL 20050309)
[    0.185205] ACPI: Dynamic OEM Table Load:
[    0.185548] ACPI: SSDT           (null) 00087 (v01 APPLE   Cpu1Ist
00003000 INTL 20050309)
[    0.186753] ACPI: SSDT 000000003feb7f10 00085 (v01 APPLE   Cpu1Cst
00003000 INTL 20050309)
[    0.188122] ACPI: Dynamic OEM Table Load:
[    0.188465] ACPI: SSDT           (null) 00085 (v01 APPLE   Cpu1Cst
00003000 INTL 20050309)
[    0.195019] ACPI: Interpreter enabled
[    0.195190] ACPI: (supports S0 S3 S4 S5)
[    0.195803] ACPI: Using IOAPIC for interrupt routing
[    0.237073] ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
[    0.241629] ACPI: No dock devices found.
[    0.241805] PCI: Ignoring host bridge windows from ACPI; if
necessary, use "pci=use_crs" and report a bug
[    0.245244] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.250611] pci_root PNP0A08:00: host bridge window [io
0x0000-0x0cf7] (ignored)
[    0.250862] pci_root PNP0A08:00: host bridge window [io
0x0d00-0xffff] (ignored)
[    0.250975] pci_root PNP0A08:00: host bridge window [mem
0x000a0000-0x000bffff] (ignored)
[    0.251227] pci_root PNP0A08:00: host bridge window [mem
0x40000000-0xfebfffff] (ignored)
[    0.251496] pci 0000:00:00.0: [8086:27a0] type 0 class 0x000600
[    0.251738] pci 0000:00:01.0: [8086:27a1] type 1 class 0x000604
[    0.252029] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.252202] pci 0000:00:01.0: PME# disabled
[    0.252404] pci 0000:00:07.0: [8086:27a3] type 0 class 0x001101
[    0.252588] pci 0000:00:07.0: reg 10: [mem 0x50404000-0x50404fff]
[    0.252880] pci 0000:00:1b.0: [8086:27d8] type 0 class 0x000403
[    0.252997] pci 0000:00:1b.0: reg 10: [mem 0x50400000-0x50403fff 64bit]
[    0.253278] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.253454] pci 0000:00:1b.0: PME# disabled
[    0.253656] pci 0000:00:1c.0: [8086:27d0] type 1 class 0x000604
[    0.254078] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.254253] pci 0000:00:1c.0: PME# disabled
[    0.254459] pci 0000:00:1c.1: [8086:27d2] type 1 class 0x000604
[    0.257077] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.257252] pci 0000:00:1c.1: PME# disabled
[    0.257457] pci 0000:00:1c.2: [8086:27d4] type 1 class 0x000604
[    0.258090] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.258265] pci 0000:00:1c.2: PME# disabled
[    0.258476] pci 0000:00:1d.0: [8086:27c8] type 0 class 0x000c03
[    0.258714] pci 0000:00:1d.0: reg 20: [io  0x4080-0x409f]
[    0.259023] pci 0000:00:1d.1: [8086:27c9] type 0 class 0x000c03
[    0.259267] pci 0000:00:1d.1: reg 20: [io  0x4060-0x407f]
[    0.259488] pci 0000:00:1d.2: [8086:27ca] type 0 class 0x000c03
[    0.259723] pci 0000:00:1d.2: reg 20: [io  0x4040-0x405f]
[    0.260032] pci 0000:00:1d.3: [8086:27cb] type 0 class 0x000c03
[    0.260270] pci 0000:00:1d.3: reg 20: [io  0x4020-0x403f]
[    0.260512] pci 0000:00:1d.7: [8086:27cc] type 0 class 0x000c03
[    0.260711] pci 0000:00:1d.7: reg 10: [mem 0x50405400-0x504057ff]
[    0.261018] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.261195] pci 0000:00:1d.7: PME# disabled
[    0.261394] pci 0000:00:1e.0: [8086:2448] type 1 class 0x000604
[    0.261671] pci 0000:00:1f.0: [8086:27b9] type 0 class 0x000601
[    0.261977] pci 0000:00:1f.0: quirk: [io  0x0400-0x047f] claimed by
ICH6 ACPI/GPIO/TCO
[    0.262229] pci 0000:00:1f.0: quirk: [io  0x0500-0x053f] claimed by
ICH6 GPIO
[    0.262405] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at
0680 (mask 000f)
[    0.262656] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at
1640 (mask 000f)
[    0.262911] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 4 PIO at
0300 (mask 001f)
[    0.263022] pci 0000:00:1f.1: [8086:27df] type 0 class 0x000101
[    0.263211] pci 0000:00:1f.1: reg 10: [io  0x40d8-0x40df]
[    0.263394] pci 0000:00:1f.1: reg 14: [io  0x40ec-0x40ef]
[    0.263577] pci 0000:00:1f.1: reg 18: [io  0x40d0-0x40d7]
[    0.263760] pci 0000:00:1f.1: reg 1c: [io  0x40e8-0x40eb]
[    0.263984] pci 0000:00:1f.1: reg 20: [io  0x40b0-0x40bf]
[    0.264211] pci 0000:00:1f.2: [8086:27c4] type 0 class 0x000101
[    0.264405] pci 0000:00:1f.2: reg 10: [io  0x40c8-0x40cf]
[    0.264588] pci 0000:00:1f.2: reg 14: [io  0x40e4-0x40e7]
[    0.264771] pci 0000:00:1f.2: reg 18: [io  0x40c0-0x40c7]
[    0.264984] pci 0000:00:1f.2: reg 1c: [io  0x40e0-0x40e3]
[    0.265166] pci 0000:00:1f.2: reg 20: [io  0x40a0-0x40af]
[    0.265349] pci 0000:00:1f.2: reg 24: [mem 0x50405000-0x504053ff]
[    0.265561] pci 0000:00:1f.2: PME# supported from D3hot
[    0.265734] pci 0000:00:1f.2: PME# disabled
[    0.265995] pci 0000:00:1f.3: [8086:27da] type 0 class 0x000c05
[    0.266249] pci 0000:00:1f.3: reg 20: [io  0xefa0-0xefbf]
[    0.266546] pci 0000:01:00.0: [1002:71c5] type 0 class 0x000300
[    0.266732] pci 0000:01:00.0: reg 10: [mem 0x40000000-0x47ffffff pref]
[    0.266985] pci 0000:01:00.0: reg 14: [io  0x3000-0x30ff]
[    0.267167] pci 0000:01:00.0: reg 18: [mem 0x50300000-0x5030ffff]
[    0.267376] pci 0000:01:00.0: reg 30: [mem 0xfffe0000-0xffffffff pref]
[    0.267581] pci 0000:01:00.0: supports D1 D2
[    0.267763] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.267936] pci 0000:00:01.0:   bridge window [io  0x3000-0x3fff]
[    0.267973] pci 0000:00:01.0:   bridge window [mem 0x50300000-0x503fffff]
[    0.268149] pci 0000:00:01.0:   bridge window [mem
0x40000000-0x47ffffff 64bit pref]
[    0.268509] pci 0000:02:00.0: [11ab:4362] type 0 class 0x000200
[    0.268713] pci 0000:02:00.0: reg 10: [mem 0x50200000-0x50203fff 64bit]
[    0.268988] pci 0000:02:00.0: reg 18: [io  0x2000-0x20ff]
[    0.269225] pci 0000:02:00.0: reg 30: [mem 0xfffe0000-0xffffffff pref]
[    0.269460] pci 0000:02:00.0: supports D1 D2
[    0.269630] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.269807] pci 0000:02:00.0: PME# disabled
[    0.269986] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.270160] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.270335] pci 0000:00:1c.0:   bridge window [mem 0x50200000-0x502fffff]
[    0.270514] pci 0000:00:1c.0:   bridge window [mem
0xfff00000-0x000fffff pref] (disabled)
[    0.270872] pci 0000:03:00.0: [168c:0024] type 0 class 0x000280
[    0.271003] pci 0000:03:00.0: reg 10: [mem 0x50100000-0x5010ffff 64bit]
[    0.271316] pci 0000:03:00.0: supports D1
[    0.271485] pci 0000:03:00.0: PME# supported from D0 D1 D3hot
[    0.271661] pci 0000:03:00.0: PME# disabled
[    0.271996] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.272170] pci 0000:00:1c.1:   bridge window [io  0xf000-0x0000]
(disabled)
[    0.272346] pci 0000:00:1c.1:   bridge window [mem 0x50100000-0x501fffff]
[    0.272526] pci 0000:00:1c.1:   bridge window [mem
0xfff00000-0x000fffff pref] (disabled)
[    0.272853] pci 0000:00:1c.2: PCI bridge to [bus 04-0b]
[    0.272974] pci 0000:00:1c.2:   bridge window [io  0x1000-0x1fff]
[    0.273147] pci 0000:00:1c.2:   bridge window [mem 0x4c100000-0x500fffff]
[    0.273326] pci 0000:00:1c.2:   bridge window [mem
0x48000000-0x4bffffff 64bit pref]
[    0.273645] pci 0000:0c:03.0: [104c:8025] type 0 class 0x000c00
[    0.273844] pci 0000:0c:03.0: reg 10: [mem 0x4c004000-0x4c0047ff]
[    0.273985] pci 0000:0c:03.0: reg 14: [mem 0x4c000000-0x4c003fff]
[    0.274263] pci 0000:0c:03.0: supports D1 D2
[    0.274432] pci 0000:0c:03.0: PME# supported from D0 D1 D2 D3hot
[    0.274610] pci 0000:0c:03.0: PME# disabled
[    0.274977] pci 0000:00:1e.0: PCI bridge to [bus 0c-0c] (subtractive
decode)
[    0.275153] pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000]
(disabled)
[    0.275329] pci 0000:00:1e.0:   bridge window [mem 0x4c000000-0x4c0fffff]
[    0.275509] pci 0000:00:1e.0:   bridge window [mem
0xfff00000-0x000fffff pref] (disabled)
[    0.275761] pci 0000:00:1e.0:   bridge window [io  0x0000-0xffff]
(subtractive decode)
[    0.275971] pci 0000:00:1e.0:   bridge window [mem
0x00000000-0xfffffffff] (subtractive decode)
[    0.276265] pci_bus 0000:00: on NUMA node 0
[    0.276440] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.277946] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEGP._PRT]
[    0.278402] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.279153] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.279745] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
[    0.280453] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
[    0.318174] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12
14 15) *11
[    0.319942] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 *11 12
14 15)
[    0.321417] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12
14 15) *11
[    0.323292] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 *11 12
14 15)
[    0.324769] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12
14 15) *0, disabled.
[    0.326583] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12
14 15) *0, disabled.
[    0.328252] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 *10 12
14 15)
[    0.329852] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *11 12 14 15)
[    0.331120] vgaarb: device added:
PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.331989] vgaarb: loaded
[    0.333010] SCSI subsystem initialized
[    0.333191] libata version 3.00 loaded.
[    0.334099] usbcore: registered new interface driver usbfs
[    0.334239] usbcore: registered new interface driver hub
[    0.335025] usbcore: registered new device driver usb
[    0.336039] Advanced Linux Sound Architecture Driver Version 1.0.23.
[    0.336208] PCI: Using ACPI for IRQ routing
[    0.336378] PCI: pci_cache_line_size set to 64 bytes
[    0.336767] reserve RAM buffer: 000000000009fc00 - 000000000009ffff
[    0.336866] reserve RAM buffer: 000000003f083000 - 000000003fffffff
[    0.338238] NetLabel: Initializing
[    0.338961] NetLabel:  domain hash size = 128
[    0.339130] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.339385] NetLabel:  unlabeled traffic allowed by default
[    0.339562] HPET: 3 timers in total, 0 timers will be used for
per-cpu timer
[    0.339741] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.340471] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.341971] cfg80211: Calling CRDA to update world regulatory domain
[    0.343044] Switching to clocksource hpet
[    0.343495] Switched to NOHz mode on CPU #0
[    0.343610] Switched to NOHz mode on CPU #1
[    0.356384] FS-Cache: Loaded
[    0.356799] pnp: PnP ACPI init
[    0.357022] ACPI: bus type pnp registered
[    0.359752] pnp 00:00: [bus 00-ff]
[    0.359923] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.360114] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.360284] pnp 00:00: [io  0x0d00-0xffff window]
[    0.360455] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.360627] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
[    0.360799] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
[    0.360970] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
[    0.361168] pnp 00:00: [mem 0x000cc000-0x000cffff window]
[    0.361340] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
[    0.361511] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
[    0.361682] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
[    0.361854] pnp 00:00: [mem 0x000dc000-0x000dffff window]
[    0.362042] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
[    0.362213] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
[    0.362384] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
[    0.362555] pnp 00:00: [mem 0x000ec000-0x000effff window]
[    0.362726] pnp 00:00: [mem 0x000f0000-0x000fffff window]
[    0.362898] pnp 00:00: [mem 0x40000000-0xfebfffff window]
[    0.363385] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03
(active)
[    0.363674] pnp 00:01: [mem 0xf0000000-0xf3ffffff]
[    0.363851] pnp 00:01: [mem 0xfed14000-0xfed17fff]
[    0.364039] pnp 00:01: [mem 0xfed18000-0xfed18fff]
[    0.364210] pnp 00:01: [mem 0xfed19000-0xfed19fff]
[    0.364380] pnp 00:01: [mem 0xfed1c000-0xfed1ffff]
[    0.364550] pnp 00:01: [mem 0xfed20000-0xfed8ffff]
[    0.365024] system 00:01: [mem 0xf0000000-0xf3ffffff] has been reserved
[    0.365198] system 00:01: [mem 0xfed14000-0xfed17fff] has been reserved
[    0.365380] system 00:01: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.365554] system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.365728] system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.365902] system 00:01: [mem 0xfed20000-0xfed8ffff] has been reserved
[    0.366092] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.367534] pnp 00:02: [io  0x0300-0x031f]
[    0.367717] pnp 00:02: [irq 6]
[    0.371000] pnp 00:02: Plug and Play ACPI device, IDs APP0001 (active)
[    0.371416] pnp 00:03: [io  0x0000-0x001f]
[    0.371586] pnp 00:03: [io  0x0081-0x0091]
[    0.371756] pnp 00:03: [io  0x0093-0x009f]
[    0.371925] pnp 00:03: [io  0x00c0-0x00df]
[    0.372107] pnp 00:03: [dma 4]
[    0.372512] pnp 00:03: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.372734] pnp 00:04: [mem 0xff000000-0xffffffff]
[    0.373191] pnp 00:04: Plug and Play ACPI device, IDs INT0800 (active)
[    0.373793] pnp 00:05: [irq 0 disabled]
[    0.373968] pnp 00:05: [irq 8]
[    0.374173] pnp 00:05: [mem 0xfed00000-0xfed003ff]
[    0.374686] system 00:05: [mem 0xfed00000-0xfed003ff] has been reserved
[    0.374861] system 00:05: Plug and Play ACPI device, IDs PNP0103
PNP0c01 (active)
[    0.375179] pnp 00:06: [io  0x00f0]
[    0.375355] pnp 00:06: [irq 13]
[    0.375778] pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.376084] pnp 00:07: [io  0x002e-0x002f]
[    0.376255] pnp 00:07: [io  0x004e-0x004f]
[    0.376424] pnp 00:07: [io  0x0061]
[    0.376591] pnp 00:07: [io  0x0063]
[    0.376767] pnp 00:07: [io  0x0065]
[    0.376936] pnp 00:07: [io  0x0067]
[    0.377116] pnp 00:07: [io  0x0070]
[    0.377292] pnp 00:07: [io  0x0080]
[    0.377465] pnp 00:07: [io  0x0092]
[    0.377634] pnp 00:07: [io  0x00b2-0x00b3]
[    0.377803] pnp 00:07: [io  0x0680-0x06ef]
[    0.377970] pnp 00:07: [io  0x0800-0x080f]
[    0.378207] pnp 00:07: [io  0x0810-0x0817]
[    0.378376] pnp 00:07: [io  0x0400-0x047f]
[    0.378545] pnp 00:07: [io  0x0500-0x053f]
[    0.378715] pnp 00:07: [io  0x1640-0x164f]
[    0.378912] pnp 00:07: disabling [io  0x1640-0x164f] because it
overlaps 0000:00:1c.2 BAR 7 [io  0x1000-0x1fff]
[    0.379493] system 00:07: [io  0x0680-0x06ef] has been reserved
[    0.379668] system 00:07: [io  0x0800-0x080f] has been reserved
[    0.379840] system 00:07: [io  0x0810-0x0817] has been reserved
[    0.380028] system 00:07: [io  0x0400-0x047f] has been reserved
[    0.380201] system 00:07: [io  0x0500-0x053f] has been reserved
[    0.380374] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.380585] pnp 00:08: [io  0x0070-0x0077]
[    0.381018] pnp 00:08: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.384497] pnp: PnP ACPI: found 9 devices
[    0.384666] ACPI: ACPI bus type pnp unregistered
[    0.406887] pci 0000:01:00.0: no compatible bridge window for [mem
0xfffe0000-0xffffffff pref]
[    0.407162] pci 0000:02:00.0: no compatible bridge window for [mem
0xfffe0000-0xffffffff pref]
[    0.407488] pci 0000:00:1c.0: BAR 9: assigned [mem
0x50500000-0x506fffff pref]
[    0.407742] pci 0000:00:1c.1: BAR 9: assigned [mem
0x50700000-0x508fffff 64bit pref]
[    0.407995] pci 0000:00:1c.1: BAR 7: assigned [io  0x5000-0x5fff]
[    0.408187] pci 0000:01:00.0: BAR 6: assigned [mem
0x50320000-0x5033ffff pref]
[    0.408439] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.408610] pci 0000:00:01.0:   bridge window [io  0x3000-0x3fff]
[    0.408790] pci 0000:00:01.0:   bridge window [mem 0x50300000-0x503fffff]
[    0.408965] pci 0000:00:01.0:   bridge window [mem
0x40000000-0x47ffffff 64bit pref]
[    0.409236] pci 0000:02:00.0: BAR 6: assigned [mem
0x50500000-0x5051ffff pref]
[    0.409488] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.409670] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.409847] pci 0000:00:1c.0:   bridge window [mem 0x50200000-0x502fffff]
[    0.410038] pci 0000:00:1c.0:   bridge window [mem
0x50500000-0x506fffff pref]
[    0.410296] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.410472] pci 0000:00:1c.1:   bridge window [io  0x5000-0x5fff]
[    0.410650] pci 0000:00:1c.1:   bridge window [mem 0x50100000-0x501fffff]
[    0.410826] pci 0000:00:1c.1:   bridge window [mem
0x50700000-0x508fffff 64bit pref]
[    0.411100] pci 0000:00:1c.2: PCI bridge to [bus 04-0b]
[    0.411272] pci 0000:00:1c.2:   bridge window [io  0x1000-0x1fff]
[    0.411448] pci 0000:00:1c.2:   bridge window [mem 0x4c100000-0x500fffff]
[    0.411624] pci 0000:00:1c.2:   bridge window [mem
0x48000000-0x4bffffff 64bit pref]
[    0.411881] pci 0000:00:1e.0: PCI bridge to [bus 0c-0c]
[    0.412068] pci 0000:00:1e.0:   bridge window [io  disabled]
[    0.412244] pci 0000:00:1e.0:   bridge window [mem 0x4c000000-0x4c0fffff]
[    0.412419] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    0.412615] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.412790] pci 0000:00:01.0: setting latency timer to 64
[    0.412972] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.413165] pci 0000:00:1c.0: setting latency timer to 64
[    0.413344] pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.413520] pci 0000:00:1c.1: setting latency timer to 64
[    0.413702] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.413878] pci 0000:00:1c.2: setting latency timer to 64
[    0.414226] pci 0000:00:1e.0: power state changed by ACPI to D0
[    0.414401] pci 0000:00:1e.0: power state changed by ACPI to D0
[    0.414578] pci 0000:00:1e.0: setting latency timer to 64
[    0.414751] pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
[    0.414922] pci_bus 0000:00: resource 1 [mem 0x00000000-0xfffffffff]
[    0.415113] pci_bus 0000:01: resource 0 [io  0x3000-0x3fff]
[    0.415282] pci_bus 0000:01: resource 1 [mem 0x50300000-0x503fffff]
[    0.415453] pci_bus 0000:01: resource 2 [mem 0x40000000-0x47ffffff
64bit pref]
[    0.415702] pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
[    0.415873] pci_bus 0000:02: resource 1 [mem 0x50200000-0x502fffff]
[    0.416060] pci_bus 0000:02: resource 2 [mem 0x50500000-0x506fffff pref]
[    0.416231] pci_bus 0000:03: resource 0 [io  0x5000-0x5fff]
[    0.416402] pci_bus 0000:03: resource 1 [mem 0x50100000-0x501fffff]
[    0.416574] pci_bus 0000:03: resource 2 [mem 0x50700000-0x508fffff
64bit pref]
[    0.416822] pci_bus 0000:04: resource 0 [io  0x1000-0x1fff]
[    0.416993] pci_bus 0000:04: resource 1 [mem 0x4c100000-0x500fffff]
[    0.417179] pci_bus 0000:04: resource 2 [mem 0x48000000-0x4bffffff
64bit pref]
[    0.417428] pci_bus 0000:0c: resource 1 [mem 0x4c000000-0x4c0fffff]
[    0.417599] pci_bus 0000:0c: resource 4 [io  0x0000-0xffff]
[    0.417770] pci_bus 0000:0c: resource 5 [mem 0x00000000-0xfffffffff]
[    0.418064] NET: Registered protocol family 2
[    0.418394] IP route cache hash table entries: 32768 (order: 6,
262144 bytes)
[    0.419278] TCP established hash table entries: 131072 (order: 9,
2097152 bytes)
[    0.420709] TCP bind hash table entries: 32768 (order: 9, 2621440 bytes)
[    0.422727] TCP: Hash tables configured (established 131072 bind 32768)
[    0.422903] TCP reno registered
[    0.423101] UDP hash table entries: 512 (order: 4, 98304 bytes)
[    0.423357] UDP-Lite hash table entries: 512 (order: 4, 98304 bytes)
[    0.423948] NET: Registered protocol family 1
[    0.424370] pci 0000:01:00.0: Boot video device
[    0.424561] PCI: CLS mismatch (256 != 64), using 64 bytes
[    0.468857] DMA-API: preallocated 32768 debug entries
[    0.469048] DMA-API: debugging enabled by kernel config
[    0.473757] microcode: CPU0 sig=0x6f6, pf=0x20, revision=0xc7
[    0.473949] microcode: CPU1 sig=0x6f6, pf=0x20, revision=0xc7
[    0.474349] microcode: Microcode Update Driver: v2.00
<tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.477140] Initializing RT-Tester: OK
[    0.477516] ====[ backtrace testing ]===========
[    0.477685] Testing a backtrace from process context.
[    0.477853] The following trace is a kernel self test and not a bug!
[    0.478146] Pid: 1, comm: swapper Tainted: G        W   2.6.38-rc4 #1
[    0.478318] Call Trace:
[    0.478495]  [<ffffffff810a59c5>] ? backtrace_regression_test+0x38/0xff
[    0.478671]  [<ffffffff81480c2d>] ? mutex_unlock+0x9/0xb
[    0.478845]  [<ffffffff812bbfc0>] ? misc_register+0x10d/0x115
[    0.479037]  [<ffffffff81953134>] ? snapshot_device_init+0x0/0x12
[    0.479212]  [<ffffffff81000210>] ? do_one_initcall+0x7a/0x139
[    0.479388]  [<ffffffff8193f68e>] ? kernel_init+0x13d/0x1c1
[    0.479561]  [<ffffffff8102e9a4>] ? kernel_thread_helper+0x4/0x10
[    0.479735]  [<ffffffff81483354>] ? restore_args+0x0/0x30
[    0.479906]  [<ffffffff8193f551>] ? kernel_init+0x0/0x1c1
[    0.480095]  [<ffffffff8102e9a0>] ? kernel_thread_helper+0x0/0x10
[    0.480266] Testing a backtrace from irq context.
[    0.480435] The following trace is a kernel self test and not a bug!
[    0.480612] Pid: 3, comm: ksoftirqd/0 Tainted: G        W   2.6.38-rc4 #1
[    0.480784] Call Trace:
[    0.480950]  <IRQ>  [<ffffffff810a597f>] ?
backtrace_test_irq_callback+0x9/0x17
[    0.481308]  [<ffffffff81068477>] ? tasklet_action+0x8b/0x11a
[    0.481480]  [<ffffffff81068e06>] ? __do_softirq+0xec/0x1e8
[    0.481654]  [<ffffffff8108e9ad>] ? trace_hardirqs_off+0xd/0xf
[    0.481827]  [<ffffffff8102ea9c>] ? call_softirq+0x1c/0x28
[    0.481997]  <EOI>  [<ffffffff8102ffd2>] ? do_softirq+0x46/0x9e
[    0.482273]  [<ffffffff8106822c>] ? run_ksoftirqd+0x6f/0x119
[    0.482445]  [<ffffffff810681bd>] ? run_ksoftirqd+0x0/0x119
[    0.482619]  [<ffffffff8107ecfc>] ? kthread+0x89/0x91
[    0.482791]  [<ffffffff8102e9a4>] ? kernel_thread_helper+0x4/0x10
[    0.482964]  [<ffffffff81483354>] ? restore_args+0x0/0x30
[    0.483150]  [<ffffffff8107ec73>] ? kthread+0x0/0x91
[    0.483321]  [<ffffffff8102e9a0>] ? kernel_thread_helper+0x0/0x10
[    0.484125] Testing a saved backtrace.
[    0.484293] The following trace is a kernel self test and not a bug!
[    0.484466]  [<ffffffff81037759>] save_stack_trace+0x28/0x45
[    0.484725]  [<ffffffff810a5a6a>] backtrace_regression_test+0xdd/0xff
[    0.484984]  [<ffffffff81000210>] do_one_initcall+0x7a/0x139
[    0.485277]  [<ffffffff8193f68e>] kernel_init+0x13d/0x1c1
[    0.485534]  [<ffffffff8102e9a4>] kernel_thread_helper+0x4/0x10
[    0.485793]  [<ffffffffffffffff>] 0xffffffffffffffff
[    0.486066] ====[ end of backtrace testing ]====
[    0.486251] audit: initializing netlink socket (enabled)
[    0.486469] type=2000 audit(1297137195.485:1): initialized
[    0.507286] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.537804] VFS: Disk quotas dquot_6.5.2
[    0.538334] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.545757] ROMFS MTD (C) 2007 Red Hat, Inc.
[    0.546396] fuse init (API version 7.16)
[    0.547953] msgmni has been set to 1938
[    0.548606] SELinux:  Registering netfilter hooks
[    0.549802] io scheduler noop registered
[    0.550493] io scheduler cfq registered (default)
[    0.552600] intel_idle: MWAIT substates: 0x22220
[    0.552770] intel_idle: does not run on family 6 model 15
[    0.560948] Linux agpgart interface v0.103
[    0.565819] loop: module loaded
[    0.567696] ata_piix 0000:00:1f.1: version 2.13
[    0.567882] ata_piix 0000:00:1f.1: power state changed by ACPI to D0
[    0.568297] ata_piix 0000:00:1f.1: power state changed by ACPI to D0
[    0.568478] ata_piix 0000:00:1f.1: PCI INT A -> GSI 18 (level, low)
-> IRQ 18
[    0.568720] ata_piix 0000:00:1f.1: setting latency timer to 64
[    0.570991] scsi0 : ata_piix
[    0.572355] scsi1 : ata_piix
[    0.575317] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x40b0
irq 14
[    0.575491] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x40b8
irq 15
[    0.575869] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low)
-> IRQ 19
[    0.576146] ata_piix 0000:00:1f.2: MAP [ P0 P2 -- -- ]
[    0.727031] ata_piix 0000:00:1f.2: setting latency timer to 64
[    0.728931] scsi2 : ata_piix
[    0.737446] ata1.00: ATAPI: MATSHITADVD-R   UJ-857D, KCV9, max UDMA/66
[    0.737798] scsi3 : ata_piix
[    0.742753] ata3: SATA max UDMA/133 cmd 0x40c8 ctl 0x40e4 bmdma
0x40a0 irq 19
[    0.742928] ata4: SATA max UDMA/133 cmd 0x40c0 ctl 0x40e0 bmdma
0x40a8 irq 19
[    0.743677] ata1.00: configured for UDMA/66
[    0.744171] usbcore: registered new interface driver usblcd
[    0.744587] usbcore: registered new interface driver usbled
[    0.745637] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    0.746041] scsi 0:0:0:0: CD-ROM            MATSHITA DVD-R   UJ-857D
  KCV9 PQ: 0 ANSI: 5
[    0.746697] i8042: No controller found
[    0.747411] mousedev: PS/2 mouse device common for all mice
[    0.748408] lirc_dev: IR Remote Control driver registered, major 254
[    0.748581] IR NEC protocol handler initialized
[    0.748750] IR RC5(x) protocol handler initialized
[    0.748920] IR RC6 protocol handler initialized
[    0.749173] IR JVC protocol handler initialized
[    0.749297] sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
[    0.749301] cdrom: Uniform CD-ROM driver Revision: 3.20
[    0.749713] IR Sony protocol handler initialized
[    0.749883] IR RC5 (streamzap) protocol handler initialized
[    0.750071] IR LIRC bridge handler initialized
[    0.750240] Linux video capture interface: v2.00
[    0.750634] sr 0:0:0:0: Attached scsi CD-ROM sr0
[    0.751466] sr 0:0:0:0: Attached scsi generic sg0 type 5
[    0.753187] device-mapper: ioctl: 4.19.1-ioctl (2011-01-07)
initialised: dm-devel@redhat.com
[    0.753437] EDAC MC: Ver: 2.1.0 Feb  7 2011
[    0.754147] cpuidle: using governor ladder
[    0.754316] cpuidle: using governor menu
[    0.759417] usbcore: registered new interface driver usbhid
[    0.759589] usbhid: USB HID core driver
[    0.760322] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low)
-> IRQ 22
[    0.760645] HDA Intel 0000:00:1b.0: irq 40 for MSI/MSI-X
[    0.760877] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    0.771965] hda_codec: STAC922x, Apple subsys_id=106b1e00
[    0.778189] ALSA device list:
[    0.778357]   #0: HDA Intel at 0x50400000 irq 40
[    0.778802] oprofile: using NMI interrupt.
[    0.779960] Initializing XFRM netlink socket
[    0.780268] NET: Registered protocol family 17
[    0.780489] NET: Registered protocol family 15
[    0.780658] lib80211: common routines for IEEE802.11 drivers
[    0.780830] lib80211_crypt: registered algorithm 'NULL'
[    0.781661] IMA: No TPM chip found, activating TPM-bypass!
[    0.916628] ata3.01: ATA-8: FUJITSU MHW2120BH, 00810013, max UDMA/100
[    0.916801] ata3.01: 234441648 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    0.923395] ata3.01: configured for UDMA/100
[    0.923815] scsi 2:0:1:0: Direct-Access     ATA      FUJITSU MHW2120B
0081 PQ: 0 ANSI: 5
[    0.924819] sd 2:0:1:0: [sda] 234441648 512-byte logical blocks: (120
GB/111 GiB)
[    0.925130] sd 2:0:1:0: Attached scsi generic sg1 type 0
[    0.925257] sd 2:0:1:0: [sda] Write Protect is off
[    0.925260] sd 2:0:1:0: [sda] Mode Sense: 00 3a 00 00
[    0.925327] sd 2:0:1:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    0.928293]  sda: sda1 sda2 sda3 sda4
[    0.929897] sd 2:0:1:0: [sda] Attached SCSI disk
[    0.973709] EXT4-fs (sda3): mounted filesystem with ordered data
mode. Opts: (null)
[    0.973998] VFS: Mounted root (ext4 filesystem) readonly on device 8:3.
[    0.978331] Freeing unused kernel memory: 2312k freed
[    1.472027] Refined TSC clocksource calibration: 2161.249 MHz.
[    1.472207] Switching to clocksource tsc
[    1.555352] SELinux: 2048 avtab hash slots, 194994 rules.
[    1.751415] SELinux: 2048 avtab hash slots, 194994 rules.
[    1.981656] SELinux:  7 users, 15 roles, 3413 types, 144 bools, 1
sens, 1024 cats
[    1.982095] SELinux:  81 classes, 194994 rules
[    1.996619] SELinux:  Permission read_policy in class security not
defined in policy.
[    1.996913] SELinux:  Permission audit_access in class file not
defined in policy.
[    1.997177] SELinux:  Permission audit_access in class dir not
defined in policy.
[    1.997427] SELinux:  Permission execmod in class dir not defined in
policy.
[    1.997607] SELinux:  Permission audit_access in class lnk_file not
defined in policy.
[    1.997856] SELinux:  Permission open in class lnk_file not defined
in policy.
[    1.998111] SELinux:  Permission execmod in class lnk_file not
defined in policy.
[    1.998363] SELinux:  Permission audit_access in class chr_file not
defined in policy.
[    1.998617] SELinux:  Permission audit_access in class blk_file not
defined in policy.
[    1.998868] SELinux:  Permission execmod in class blk_file not
defined in policy.
[    1.999126] SELinux:  Permission audit_access in class sock_file not
defined in policy.
[    1.999376] SELinux:  Permission execmod in class sock_file not
defined in policy.
[    1.999629] SELinux:  Permission audit_access in class fifo_file not
defined in policy.
[    1.999881] SELinux:  Permission execmod in class fifo_file not
defined in policy.
[    2.000274] SELinux: the above unknown classes and permissions will
be denied
[    2.000495] SELinux:  Completing initialization.
[    2.000665] SELinux:  Setting up existing superblocks.
[    2.000848] SELinux: initialized (dev sysfs, type sysfs), uses
genfs_contexts
[    2.001037] SELinux: initialized (dev rootfs, type rootfs), uses
genfs_contexts
[    2.001299] SELinux: initialized (dev bdev, type bdev), uses
genfs_contexts
[    2.001480] SELinux: initialized (dev proc, type proc), uses
genfs_contexts
[    2.001664] SELinux: initialized (dev tmpfs, type tmpfs), uses
transition SIDs
[    2.001929] SELinux: initialized (dev sockfs, type sockfs), uses task
SIDs
[    2.002120] SELinux: initialized (dev debugfs, type debugfs), uses
genfs_contexts
[    2.004184] SELinux: initialized (dev pipefs, type pipefs), uses task
SIDs
[    2.004366] SELinux: initialized (dev anon_inodefs, type
anon_inodefs), uses genfs_contexts
[    2.004623] SELinux: initialized (dev devpts, type devpts), uses
transition SIDs
[    2.004887] SELinux: initialized (dev hugetlbfs, type hugetlbfs),
uses transition SIDs
[    2.005155] SELinux: initialized (dev mqueue, type mqueue), uses
transition SIDs
[    2.005414] SELinux: initialized (dev selinuxfs, type selinuxfs),
uses genfs_contexts
[    2.005743] SELinux: initialized (dev securityfs, type securityfs),
uses genfs_contexts
[    2.006028] SELinux: initialized (dev sda3, type ext4), uses xattr
[    2.038884] type=1403 audit(1297137197.037:2): policy loaded
auid=4294967295 ses=4294967295
[    2.780263] SELinux: initialized (dev sysfs, type sysfs), uses
genfs_contexts
[    3.129218] usbcore: registered new interface driver uvcvideo
[    3.129394] USB Video Class driver (v1.0.0)
[    3.241817] applesmc: key=262 fan=2 temp=12 acc=1 lux=2 kbd=1
[    3.252962] input: applesmc as
/devices/platform/applesmc.768/input/input0
[    3.253411] Registered led device: smc::kbd_backlight
[    3.273797] usbcore: registered new interface driver appletouch
[    3.300484] ACPI: acpi_idle registered with cpuidle
[    3.301215] Monitor-Mwait will be used to enter C-1 state
[    3.301279] Monitor-Mwait will be used to enter C-2 state
[    3.301342] Monitor-Mwait will be used to enter C-3 state
[    3.301354] Marking TSC unstable due to TSC halts in idle
[    3.301633] Switching to clocksource hpet
[    3.330634] coretemp coretemp.0: TjMax is assumed as 100 C!
[    3.331382] coretemp coretemp.1: TjMax is assumed as 100 C!
[    3.389941] Bluetooth: Core ver 2.15
[    3.390413] NET: Registered protocol family 31
[    3.390583] Bluetooth: HCI device and connection manager initialized
[    3.390755] Bluetooth: HCI socket layer initialized
[    3.418569] Bluetooth: L2CAP ver 2.15
[    3.418757] Bluetooth: L2CAP socket layer initialized
[    3.428868] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[    3.450530] Bluetooth: Generic Bluetooth USB driver ver 0.6
[    3.451126] usbcore: registered new interface driver btusb
[    3.477894] Bluetooth: RFCOMM TTY layer initialized
[    3.478110] Bluetooth: RFCOMM socket layer initialized
[    3.478281] Bluetooth: RFCOMM ver 1.11
[    3.488766] Bluetooth: HCI UART driver ver 2.2
[    3.488936] Bluetooth: HCI H4 protocol initialized
[    3.489119] Bluetooth: HCI BCSP protocol initialized
[    3.532660] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    3.535890] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low)
-> IRQ 23
[    3.536114] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    3.536119] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    3.536302] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned
bus number 1
[    3.543286] ehci_hcd 0000:00:1d.7: using broken periodic workaround
[    3.543494] ehci_hcd 0000:00:1d.7: debug port 1
[    3.547544] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    3.547659] ehci_hcd 0000:00:1d.7: irq 23, io mem 0x50405400
[    3.557133] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    3.558664] hub 1-0:1.0: USB hub found
[    3.558878] hub 1-0:1.0: 8 ports detected
[    3.573911] uhci_hcd: USB Universal Host Controller Interface driver
[    3.574872] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low)
-> IRQ 23
[    3.575116] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    3.575125] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    3.575338] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned
bus number 2
[    3.580279] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00004080
[    3.581868] hub 2-0:1.0: USB hub found
[    3.582101] hub 2-0:1.0: 2 ports detected
[    3.583239] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low)
-> IRQ 19
[    3.583457] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    3.583466] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    3.583678] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned
bus number 3
[    3.588323] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00004060
[    3.589929] hub 3-0:1.0: USB hub found
[    3.590165] hub 3-0:1.0: 2 ports detected
[    3.591289] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low)
-> IRQ 18
[    3.591506] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    3.591515] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    3.591727] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned
bus number 4
[    3.600250] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00004040
[    3.601890] hub 4-0:1.0: USB hub found
[    3.602125] hub 4-0:1.0: 2 ports detected
[    3.603237] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low)
-> IRQ 16
[    3.603455] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    3.603464] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    3.603676] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned
bus number 5
[    3.608382] uhci_hcd 0000:00:1d.3: irq 16, io base 0x00004020
[    3.609972] hub 5-0:1.0: USB hub found
[    3.610208] hub 5-0:1.0: 2 ports detected
[    3.937513] SELinux: initialized (dev tmpfs, type tmpfs), uses
transition SIDs
[    3.963109] usb 1-4: new high speed USB device using ehci_hcd and
address 3
[    4.245265] udev: starting version 147
[    4.245822] udevd (1061): /proc/1061/oom_adj is deprecated, please
use /proc/1061/oom_score_adj instead.
[    4.489076] usb 2-2: new full speed USB device using uhci_hcd and
address 2
[    4.511945] i801_smbus 0000:00:1f.3: PCI INT B -> GSI 19 (level, low)
-> IRQ 19
[    4.512240] ACPI: resource 0000:00:1f.3 [io  0xefa0-0xefbf] conflicts
with ACPI region SMBI [io 0xefa0-0xefaf]
[    4.512514] ACPI: If an ACPI driver is available for this device, you
should use it instead of the native driver
[    4.680236] input: Apple Computer Apple Internal Keyboard / Trackpad
as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.0/input/input1
[    4.680541] apple 0003:05AC:021A.0001: input: USB HID v1.11 Keyboard
[Apple Computer Apple Internal Keyboard / Trackpad] on
usb-0000:00:1d.0-2/input0
[    4.684634] appletouch: Geyser mode initialized.
[    4.685014] input: appletouch as
/devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.1/input/input2
[    4.691841] input: Apple Computer Apple Internal Keyboard / Trackpad
as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.2/input/input3
[    4.692167] apple 0003:05AC:021A.0002: input: USB HID v1.11 Device
[Apple Computer Apple Internal Keyboard / Trackpad] on
usb-0000:00:1d.0-2/input2
[    4.926772] usb 4-2: new full speed USB device using uhci_hcd and
address 2
[    5.131498] generic-usb 0003:05AC:8240.0003: hiddev0: USB HID v1.11
Device [Apple Computer, Inc. IR Receiver] on usb-0000:00:1d.2-2/input0
[    5.274038] input: Lid Switch as
/devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input4
[    5.283977] ACPI: Lid Switch [LID0]
[    5.284436] input: Power Button as
/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input5
[    5.284708] ACPI: Power Button [PWRB]
[    5.285234] input: Sleep Button as
/devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input6
[    5.285515] ACPI: Sleep Button [SLPB]
[    5.285920] input: Power Button as
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input7
[    5.286241] ACPI: Power Button [PWRF]
[    5.295492] ACPI: Deprecated procfs I/F for AC is loaded, please
retry with CONFIG_ACPI_PROCFS_POWER cleared
[    5.295852] power_supply ADP1: uevent
[    5.295855] power_supply ADP1: POWER_SUPPLY_NAME=ADP1
[    5.295919] power_supply ADP1: prop ONLINE=1
[    5.295947] power_supply ADP1: power_supply_changed
[    5.295954] ACPI: AC Adapter [ADP1] (on-line)
[    5.296275] power_supply ADP1: power_supply_changed_work
[    5.341200] usb 5-1: new full speed USB device using uhci_hcd and
address 2
[    5.467686] power_supply ADP1: power_supply_update_gen_leds 1
[    5.467708] power_supply ADP1: uevent
[    5.467722] power_supply ADP1: POWER_SUPPLY_NAME=ADP1
[    5.467789] power_supply ADP1: prop ONLINE=1
[    5.536562] usbhid 5-1:1.0: couldn't find an input interrupt endpoint
[    5.555353] sky2: driver version 1.28
[    5.555644] sky2 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    5.555840] sky2 0000:02:00.0: setting latency timer to 64
[    5.555906] sky2 0000:02:00.0: Yukon-2 EC chip revision 2
[    5.556285] sky2 0000:02:00.0: irq 41 for MSI/MSI-X
[    5.631407] sky2 0000:02:00.0: eth0: addr 00:17:f2:cb:e3:71
[    5.764621] power_supply BAT0: uevent
[    5.764626] power_supply BAT0: POWER_SUPPLY_NAME=BAT0
[    5.788159] [drm] Initialized drm 1.1.0 20060810
[    5.819256] power_supply BAT0: prop STATUS=Unknown
[    5.819265] power_supply BAT0: prop PRESENT=1
[    5.819271] power_supply BAT0: prop TECHNOLOGY=Unknown
[    5.819277] power_supply BAT0: prop CYCLE_COUNT=0
[    5.819282] power_supply BAT0: prop VOLTAGE_MIN_DESIGN=10800000
[    5.819287] power_supply BAT0: prop VOLTAGE_NOW=12492000
[    5.819292] power_supply BAT0: prop POWER_NOW=0
[    5.819298] power_supply BAT0: prop ENERGY_FULL_DESIGN=55000000
[    5.819303] power_supply BAT0: prop ENERGY_FULL=45050000
[    5.819308] power_supply BAT0: prop ENERGY_NOW=44490000
[    5.819314] power_supply BAT0: prop MODEL_NAME=ASMB012
[    5.819319] power_supply BAT0: prop MANUFACTURER=SMPN012
[    5.819324] power_supply BAT0: prop SERIAL_NUMBER=
[    5.819513] power_supply BAT0: uevent
[    5.819516] power_supply BAT0: POWER_SUPPLY_NAME=BAT0
[    5.819520] power_supply BAT0: prop STATUS=Unknown
[    5.819526] power_supply BAT0: prop PRESENT=1
[    5.819532] power_supply BAT0: prop TECHNOLOGY=Unknown
[    5.819538] power_supply BAT0: prop CYCLE_COUNT=0
[    5.819543] power_supply BAT0: prop VOLTAGE_MIN_DESIGN=10800000
[    5.819548] power_supply BAT0: prop VOLTAGE_NOW=12492000
[    5.819553] power_supply BAT0: prop POWER_NOW=0
[    5.819558] power_supply BAT0: prop ENERGY_FULL_DESIGN=55000000
[    5.819563] power_supply BAT0: prop ENERGY_FULL=45050000
[    5.819568] power_supply BAT0: prop ENERGY_NOW=44490000
[    5.819574] power_supply BAT0: prop MODEL_NAME=ASMB012
[    5.819579] power_supply BAT0: prop MANUFACTURER=SMPN012
[    5.819584] power_supply BAT0: prop SERIAL_NUMBER=
[    5.819703] power_supply BAT0: power_supply_changed
[    5.819720] power_supply BAT0: power_supply_changed_work
[    5.819725] power_supply BAT0: power_supply_update_bat_leds 0
[    5.819728] ACPI: Deprecated procfs I/F for battery is loaded, please
retry with CONFIG_ACPI_PROCFS_POWER cleared
[    5.819757] ACPI: Battery Slot [BAT0] (battery present)
[    5.820228] power_supply BAT0: uevent
[    5.820230] power_supply BAT0: POWER_SUPPLY_NAME=BAT0
[    5.820236] power_supply BAT0: prop STATUS=Unknown
[    5.820241] power_supply BAT0: prop PRESENT=1
[    5.820247] power_supply BAT0: prop TECHNOLOGY=Unknown
[    5.820252] power_supply BAT0: prop CYCLE_COUNT=0
[    5.820258] power_supply BAT0: prop VOLTAGE_MIN_DESIGN=10800000
[    5.820263] power_supply BAT0: prop VOLTAGE_NOW=12492000
[    5.820268] power_supply BAT0: prop POWER_NOW=0
[    5.820274] power_supply BAT0: prop ENERGY_FULL_DESIGN=55000000
[    5.820279] power_supply BAT0: prop ENERGY_FULL=45050000
[    5.820285] power_supply BAT0: prop ENERGY_NOW=44490000
[    5.820290] power_supply BAT0: prop MODEL_NAME=ASMB012
[    5.820295] power_supply BAT0: prop MANUFACTURER=SMPN012
[    5.820301] power_supply BAT0: prop SERIAL_NUMBER=
[    5.821979] power_supply BAT0: uevent
[    5.821983] power_supply BAT0: POWER_SUPPLY_NAME=BAT0
[    5.821990] power_supply BAT0: prop STATUS=Unknown
[    5.821996] power_supply BAT0: prop PRESENT=1
[    5.822031] power_supply BAT0: prop TECHNOLOGY=Unknown
[    5.822037] power_supply BAT0: prop CYCLE_COUNT=0
[    5.822042] power_supply BAT0: prop VOLTAGE_MIN_DESIGN=10800000
[    5.822047] power_supply BAT0: prop VOLTAGE_NOW=12492000
[    5.822053] power_supply BAT0: prop POWER_NOW=0
[    5.822058] power_supply BAT0: prop ENERGY_FULL_DESIGN=55000000
[    5.822063] power_supply BAT0: prop ENERGY_FULL=45050000
[    5.822069] power_supply BAT0: prop ENERGY_NOW=44490000
[    5.822074] power_supply BAT0: prop MODEL_NAME=ASMB012
[    5.822080] power_supply BAT0: prop MANUFACTURER=SMPN012
[    5.822085] power_supply BAT0: prop SERIAL_NUMBER=
[    5.914786] usb 5-1: usbfs: USBDEVFS_CONTROL failed cmd hid2hci rqt
64 rq 0 len 0 ret -84
[    5.947459] firewire_ohci 0000:0c:03.0: PCI INT A -> GSI 19 (level,
low) -> IRQ 19
[    5.954180] usb 5-1: USB disconnect, address 2
[    5.998184] firewire_ohci: Added fw-ohci device 0000:0c:03.0, OHCI
v1.10, 4 IR + 8 IT contexts, quirks 0x2
[    6.121307] ath9k 0000:03:00.0: PCI INT A -> GSI 17 (level, low) ->
IRQ 17
[    6.121522] ath9k 0000:03:00.0: setting latency timer to 64
[    6.252821] ath: EEPROM regdomain: 0x64
[    6.252825] ath: EEPROM indicates we should expect a direct regpair map
[    6.252829] ath: Country alpha2 being used: 00
[    6.252831] ath: Regpair used: 0x64
[    6.284403] ieee80211 phy0: Selected rate control algorithm
'ath9k_rate_control'
[    6.285646] Registered led device: ath9k-phy0::radio
[    6.285774] Registered led device: ath9k-phy0::assoc
[    6.285858] Registered led device: ath9k-phy0::tx
[    6.285943] Registered led device: ath9k-phy0::rx
[    6.285950] ieee80211 phy0: Atheros AR5418 MAC/BB Rev:2 AR5133 RF
Rev:81 mem=0xffffc90001160000, irq=17
[    6.500477] firewire_core: created device fw0: GUID 0019e3fffe2ad87e,
S800
[    6.571990] [drm] radeon defaulting to kernel modesetting.
[    6.572191] [drm] radeon kernel modesetting enabled.
[    6.572460] radeon 0000:01:00.0: PCI INT A -> GSI 16 (level, low) ->
IRQ 16
[    6.572659] radeon 0000:01:00.0: setting latency timer to 64
[    6.576452] [drm] initializing kernel modesetting (RV530 0x1002:0x71C5).
[    6.576707] [drm] register mmio base: 0x50300000
[    6.576887] [drm] register mmio size: 65536
[    6.577416] ATOM BIOS: M56P
[    6.577626] [drm] Generation 2 PCI interface, using max accessible memory
[    6.577821] radeon 0000:01:00.0: VRAM: 128M 0x0000000000000000 -
0x0000000007FFFFFF (128M used)
[    6.578115] radeon 0000:01:00.0: GTT: 512M 0x0000000008000000 -
0x0000000027FFFFFF
[    6.578477] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    6.578661] [drm] Driver supports precise vblank timestamp query.
[    6.578918] radeon 0000:01:00.0: irq 42 for MSI/MSI-X
[    6.578937] radeon 0000:01:00.0: radeon: using MSI.
[    6.579365] [drm] radeon: irq initialized.
[    6.580996] [drm] Detected VRAM RAM=128M, BAR=128M
[    6.581204] [drm] RAM width 128bits DDR
[    6.581515] [TTM] Zone  kernel: Available graphics memory: 497462 kiB.
[    6.581689] [TTM] Initializing pool allocator.
[    6.581906] [drm] radeon: 128M of VRAM memory ready
[    6.582111] [drm] radeon: 512M of GTT memory ready.
[    6.582359] [drm] GART: num cpu pages 131072, num gpu pages 131072
[    6.584353] [drm] radeon: 1 quad pipes, 2 z pipes initialized.
[    6.585513] [drm] PCIE GART of 512M enabled (table at 0x00040000).
[    6.585747] radeon 0000:01:00.0: WB enabled
[    6.586226] [drm] Loading R500 Microcode
[    6.661079] usb 5-1: new full speed USB device using uhci_hcd and
address 3
[    7.085393] [drm] radeon: ring at 0x0000000008001000
[    7.085622] [drm] ring test succeeded in 4 usecs
[    7.088314] [drm] radeon: ib pool ready.
[    7.088869] [drm] ib test succeeded in 0 usecs
[    7.089088] failed to evaluate ATIF got AE_BAD_PARAMETER
[    7.091435] [drm] Radeon Display Connectors
[    7.091621] [drm] Connector 0:
[    7.091796] [drm]   LVDS
[    7.091974] [drm]   DDC: 0x7e60 0x7e60 0x7e64 0x7e64 0x7e68 0x7e68
0x7e6c 0x7e6c
[    7.092261] [drm]   Encoders:
[    7.092439] [drm]     LCD1: INTERNAL_LVTM1
[    7.092618] [drm] Connector 1:
[    7.092794] [drm]   S-video
[    7.092972] [drm]   Encoders:
[    7.093164] [drm]     TV1: INTERNAL_KLDSCP_DAC2
[    7.093347] [drm] Connector 2:
[    7.093519] [drm]   DVI-I
[    7.093691] [drm]   HPD1
[    7.093862] [drm]   DDC: 0x7e40 0x7e40 0x7e44 0x7e44 0x7e48 0x7e48
0x7e4c 0x7e4c
[    7.094137] [drm]   Encoders:
[    7.094308] [drm]     CRT2: INTERNAL_KLDSCP_DAC2
[    7.094479] [drm]     DFP1: INTERNAL_KLDSCP_TMDS1
[    7.321307] [drm] fb mappable at 0x400C0000
[    7.321500] [drm] vram apper at 0x40000000
[    7.321685] [drm] size 5300224
[    7.321867] [drm] fb depth is 24
[    7.322065] [drm]    pitch is 5888
[    7.322632] fbcon: radeondrmfb (fb0) is primary device
[    7.349190] Console: switching to colour frame buffer device 180x56
[    7.353111] fb0: radeondrmfb frame buffer device
[    7.353145] drm: registered panic notifier
[    7.353185] [drm] Initialized radeon 2.8.0 20080528 for 0000:01:00.0
on minor 0
[    7.480172] EXT4-fs (sda3): re-mounted. Opts:
errors=remount-ro,user_xattr
[    7.632481] EXT4-fs (sda3): re-mounted. Opts:
errors=remount-ro,user_xattr
[    7.685799] SELinux: initialized (dev tmpfs, type tmpfs), uses
transition SIDs
[    7.751370] Adding 390620k swap on /dev/sda4.  Priority:1 extents:1
across:390620k
[    9.332181] ip_tables: (C) 2000-2006 Netfilter Core Team
[    9.409741] nf_conntrack version 0.5.0 (7772 buckets, 31088 max)
[   11.775249] applesmc: light sensor data length set to 6
[   14.683492] sky2 0000:02:00.0: eth0: enabling interface
[   20.160181] usb 2-1: new low speed USB device using uhci_hcd and
address 3
[   20.345182] input: Mitsumi Electric Apple Optical USB Mouse as
/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1:1.0/input/input8
[   20.345415] apple 0003:05AC:0304.0004: input: USB HID v1.10 Mouse
[Mitsumi Electric Apple Optical USB Mouse] on usb-0000:00:1d.0-1/input0
[   20.463958] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   20.463962] Bluetooth: BNEP filters: protocol multicast
[   20.481415] Bluetooth: SCO (Voice Link) ver 0.6
[   20.481418] Bluetooth: SCO socket layer initialized
[   20.746213] wlan0: authenticate with 00:1e:2a:00:67:f0 (try 1)
[   20.748307] wlan0: authenticated
[   20.748364] wlan0: associate with 00:1e:2a:00:67:f0 (try 1)
[   20.751032] wlan0: RX AssocResp from 00:1e:2a:00:67:f0 (capab=0x431
status=0 aid=2)
[   20.751035] wlan0: associated

