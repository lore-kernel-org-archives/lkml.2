Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441Ab2LWAZR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 19:25:17 -0500
Received: from mail.skyhub.de ([78.46.96.112]:47144 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752039Ab2LWAZO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 19:25:14 -0500
Date: Sun, 23 Dec 2012 01:25:07 +0100
From: Borislav Petkov <bp@alien8.de>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Alex Deucher <alexander.deucher@amd.com>, dri-devel@lists.freedesktop.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: radeon 0000:02:00.0: GPU lockup CP stall for more than 10000msec
Message-ID: <20121223002507.GA12121@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Alex Deucher <alexdeucher@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	dri-devel@lists.freedesktop.org,
	lkml <linux-kernel@vger.kernel.org>
References: <20121222203547.GA5319@liondog.tnic>
 <CADnq5_MJzNdWVCauZj5Z7Monmsy4gWeYP3gJaPUPwHEgqhqOYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CADnq5_MJzNdWVCauZj5Z7Monmsy4gWeYP3gJaPUPwHEgqhqOYw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 22, 2012 at 07:01:31PM -0500, Alex Deucher wrote:
> What chip is this?

I think it is RV635. Here's the whole 3.8-rc1 dmesg.

[    0.000000] Linux version 3.8.0-rc1 (boris@liondog) (gcc version 4.7.2 (Debian 4.7.2-4) ) #13 SMP PREEMPT Sat Dec 22 11:48:54 CET 2012
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.8.0-rc1 root=/dev/sda1 ro vga=0 log_bug_len=10M resume=/dev/sda2 no_console_suspend ignore_loglevel hpet=force
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009f7ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009f800-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000cffeffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000cfff0000-0x00000000cfff2fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000cfff3000-0x00000000cfffffff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000d0000000-0x00000000dfffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000f0000000-0x00000000f7ffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000022fffffff] usable
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.3 present.
[    0.000000] DMI:    /M57SLI-S4, BIOS FF 01/24/2008
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x230000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-C7FFF write-protect
[    0.000000]   C8000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-through
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
[    0.000000]   1 base 000080000000 mask FFFFC0000000 write-back
[    0.000000]   2 base 0000C0000000 mask FFFFF0000000 write-back
[    0.000000]   3 base 000100000000 mask FFFF00000000 write-back
[    0.000000]   4 base 000200000000 mask FFFFE0000000 write-back
[    0.000000]   5 base 000220000000 mask FFFFF0000000 write-back
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 0000000230000000 aka 8960M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: update [mem 0xd0000000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xcfff0 max_arch_pfn = 0x400000000
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0xcffeffff]
[    0.000000]  [mem 0x00000000-0xbfffffff] page 1G
[    0.000000]  [mem 0xc0000000-0xcfdfffff] page 2M
[    0.000000]  [mem 0xcfe00000-0xcffeffff] page 4k
[    0.000000] kernel direct mapping tables up to 0xcffeffff @ [mem 0x1fffd000-0x1fffffff]
[    0.000000] init_memory_mapping: [mem 0x100000000-0x22fffffff]
[    0.000000]  [mem 0x100000000-0x1ffffffff] page 1G
[    0.000000]  [mem 0x200000000-0x22fffffff] page 2M
[    0.000000] kernel direct mapping tables up to 0x22fffffff @ [mem 0xcffee000-0xcffeffff]
[    0.000000] ACPI: RSDP 00000000000f6620 00014 (v00 GBT   )
[    0.000000] ACPI: RSDT 00000000cfff3000 00038 (v01 GBT    NVDAACPI 42302E31 NVDA 01010101)
[    0.000000] ACPI: FACP 00000000cfff3040 00074 (v01 GBT    NVDAACPI 42302E31 NVDA 01010101)
[    0.000000] ACPI: DSDT 00000000cfff30c0 04C8E (v01 GBT    NVDAACPI 00001000 MSFT 0100000C)
[    0.000000] ACPI: FACS 00000000cfff0000 00040
[    0.000000] ACPI: SSDT 00000000cfff7e40 004CE (v01 PTLTD  POWERNOW 00000001  LTP 00000001)
[    0.000000] ACPI: HPET 00000000cfff8340 00038 (v01 GBT    NVDAACPI 42302E31 NVDA 00000098)
[    0.000000] ACPI: MCFG 00000000cfff8380 0003C (v01 GBT    NVDAACPI 42302E31 NVDA 01010101)
[    0.000000] ACPI: APIC 00000000cfff7d80 00098 (v01 GBT    NVDAACPI 42302E31 NVDA 01010101)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000]  [ffffea0000000000-ffffea0008bfffff] PMD -> [ffff880227600000-ffff88022f5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x22fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0xcffeffff]
[    0.000000]   node   0: [mem 0x100000000-0x22fffffff]
[    0.000000] On node 0 totalpages: 2097023
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3913 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 13248 pages used for memmap
[    0.000000]   DMA32 zone: 834608 pages, LIFO batch:31
[    0.000000]   Normal zone: 19456 pages used for memmap
[    0.000000]   Normal zone: 1225728 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ14 used by override.
[    0.000000] ACPI: IRQ15 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x10b9a201 base: 0xfefffc00
[    0.000000] smpboot: Allowing 4 CPUs, 2 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000cfff0000 - 00000000cfff3000
[    0.000000] PM: Registered nosave memory: 00000000cfff3000 - 00000000d0000000
[    0.000000] PM: Registered nosave memory: 00000000d0000000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000f8000000
[    0.000000] PM: Registered nosave memory: 00000000f8000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 0000000100000000
[    0.000000] e820: [mem 0xe0000000-0xefffffff] available for PCI devices
[    0.000000] setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 475 pages/cpu @ffff880226e00000 s1916672 r8192 d20736 u2097152
[    0.000000] pcpu-alloc: s1916672 r8192 d20736 u2097152 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2064249
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.8.0-rc1 root=/dev/sda1 ro vga=0 log_bug_len=10M resume=/dev/sda2 no_console_suspend ignore_loglevel hpet=force
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.000000] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ c4000000 size 32 MB
[    0.000000] Aperture pointing to e820 RAM. Ignoring.
[    0.000000] Your BIOS doesn't leave a aperture memory hole
[    0.000000] Please enable the IOMMU option in the BIOS setup
[    0.000000] This costs you 64 MB of RAM
[    0.000000] Mapping aperture over 65536 KB of RAM @ c4000000
[    0.000000] PM: Registered nosave memory: 00000000c4000000 - 00000000c8000000
[    0.000000] Memory: 8082684k/9175040k available (5253k kernel code, 786948k absent, 305408k reserved, 2978k data, 2452k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU lockdep checking is enabled.
[    0.000000] 	Additional per-CPU info printed with stalls.
[    0.000000] NR_IRQS:4352 nr_irqs:712 16
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
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
[    0.000000] ----------------------------------------------------------------------------
[    0.000000]                                  | spin |wlock |rlock |mutex | wsem | rsem |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]               recursive read-lock:             |  ok  |             |  ok  |
[    0.000000]            recursive read-lock #2:             |  ok  |             |  ok  |
[    0.000000]             mixed read-write-lock:             |  ok  |             |  ok  |
[    0.000000]             mixed write-read-lock:             |  ok  |             |  ok  |
[    0.000000]   --------------------------------------------------------------------------
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
[    0.001000] tsc: Fast TSC calibration using PIT
[    0.002000] tsc: Detected 2713.828 MHz processor
[    0.000003] Calibrating delay loop (skipped), value calculated using timer frequency.. 5427.65 BogoMIPS (lpj=2713828)
[    0.000089] pid_max: default: 32768 minimum: 301
[    0.000288] Mount-cache hash table entries: 256
[    0.001430] tseg: 0000000000
[    0.001518] CPU: Physical Processor ID: 0
[    0.001560] CPU: Processor Core ID: 0
[    0.001602] mce: CPU supports 6 MCE banks
[    0.001673] LVT offset 0 assigned for vector 0xf9
[    0.001720] process: using AMD E400 aware idle routine
[    0.001764] Last level iTLB entries: 4KB 512, 2MB 16, 4MB 8
[    0.001764] Last level dTLB entries: 4KB 512, 2MB 128, 4MB 64
[    0.001764] tlb_flushall_shift: 4
[    0.001964] Freeing SMP alternatives: 16k freed
[    0.002014] ACPI: Core revision 20121018
[    0.008889] ftrace: allocating 18886 entries in 74 pages
[    0.017527] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.027568] smpboot: CPU0: AMD Athlon(tm) 7750 Dual-Core Processor (fam: 10, model: 02, stepping: 03)
[    0.129513] Performance Events: AMD PMU driver.
[    0.129584] ... version:                0
[    0.129626] ... bit width:              48
[    0.129668] ... generic registers:      4
[    0.129709] ... value mask:             0000ffffffffffff
[    0.129752] ... max period:             00007fffffffffff
[    0.129794] ... fixed-purpose events:   0
[    0.129836] ... event mask:             000000000000000f
[    0.135718] MCE: In-kernel MCE decoding enabled.
[    0.137708] SMP alternatives: lockdep: fixing up alternatives
[    0.137776] smpboot: Booting Node   0, Processors  #1
[    0.151134] Brought up 2 CPUs
[    0.151214] smpboot: Total of 2 processors activated (10855.31 BogoMIPS)
[    0.153543] PM: Registering ACPI NVS region [mem 0xcfff0000-0xcfff2fff] (12288 bytes)
[    0.154602] NET: Registered protocol family 16
[    0.155923] node 0 link 0: io port [1000, fffff]
[    0.155975] TOM: 00000000d0000000 aka 3328M
[    0.156017] node 0 link 0: mmio [f0000000, f7ffffff]
[    0.156082] node 0 link 0: mmio [a0000, bffff]
[    0.156144] node 0 link 0: mmio [d0000000, ffb7ffff]
[    0.156206] TOM2: 0000000230000000 aka 8960M
[    0.156249] bus: [bus 00-ff] on node 0 link 0
[    0.156292] bus: 00 [io  0x0000-0xffff]
[    0.156333] bus: 00 [mem 0xd0000000-0xffffffff]
[    0.156375] bus: 00 [mem 0x000a0000-0x000bffff]
[    0.156417] bus: 00 [mem 0x230000000-0xfcffffffff]
[    0.156587] ACPI: bus type pci registered
[    0.156672] PCI: MMCONFIG for domain 0000 [bus 00-7f] at [mem 0xf0000000-0xf7ffffff] (base 0xf0000000)
[    0.156738] PCI: MMCONFIG at [mem 0xf0000000-0xf7ffffff] reserved in E820
[    0.188210] PCI: Using configuration type 1 for base access
[    0.205193] bio: create slab <bio-0> at 0
[    0.205624] ACPI: Added _OSI(Module Device)
[    0.205674] ACPI: Added _OSI(Processor Device)
[    0.205718] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.205761] ACPI: Added _OSI(Processor Aggregator Device)
[    0.212835] ACPI: EC: Look up EC in DSDT
[    0.225248] ACPI: Interpreter enabled
[    0.225294] ACPI: (supports S0 S3 S4 S5)
[    0.225462] ACPI: Using IOAPIC for interrupt routing
[    0.247830] ACPI: No dock devices found.
[    0.247877] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.248048] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.248095] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.248348] pci_root PNP0A08:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[    0.248431] pci_root PNP0A08:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.248636] pci_root PNP0A08:00: [Firmware Info]: MMCONFIG for domain 0000 [bus 00-7f] only partially covers this bridge
[    0.248990] PCI host bridge to bus 0000:00
[    0.249042] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.249088] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.249132] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.249177] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.249222] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000dffff]
[    0.249266] pci_bus 0000:00: root bus resource [mem 0xd0000000-0xfebfffff]
[    0.249382] pci 0000:00:00.0: [10de:0369] type 00 class 0x050000
[    0.249733] pci 0000:00:01.0: [10de:0360] type 00 class 0x060100
[    0.249851] pci 0000:00:01.0: Force enabled HPET at 0xfed00000
[    0.249919] pci 0000:00:01.1: [10de:0368] type 00 class 0x0c0500
[    0.249986] pci 0000:00:01.1: reg 10: [io  0xe800-0xe83f]
[    0.250069] pci 0000:00:01.1: reg 20: [io  0x1c00-0x1c3f]
[    0.250122] pci 0000:00:01.1: reg 24: [io  0x1c80-0x1cbf]
[    0.250219] pci 0000:00:01.1: PME# supported from D3hot D3cold
[    0.250333] pci 0000:00:02.0: [10de:036c] type 00 class 0x0c0310
[    0.250405] pci 0000:00:02.0: reg 10: [mem 0xfa006000-0xfa006fff]
[    0.250533] pci 0000:00:02.0: supports D1 D2
[    0.250576] pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.250643] pci 0000:00:02.1: [10de:036d] type 00 class 0x0c0320
[    0.250706] pci 0000:00:02.1: reg 10: [mem 0xfa00a000-0xfa00a0ff]
[    0.250843] pci 0000:00:02.1: supports D1 D2
[    0.250885] pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.250980] pci 0000:00:04.0: [10de:036e] type 00 class 0x01018a
[    0.251073] pci 0000:00:04.0: reg 20: [io  0xf000-0xf00f]
[    0.251184] pci 0000:00:05.0: [10de:037f] type 00 class 0x010185
[    0.251759] pci 0000:00:05.0: reg 10: [io  0xa800-0xa807]
[    0.251810] pci 0000:00:05.0: reg 14: [io  0xac00-0xac03]
[    0.251867] pci 0000:00:05.0: reg 18: [io  0xb000-0xb007]
[    0.251918] pci 0000:00:05.0: reg 1c: [io  0xb400-0xb403]
[    0.251970] pci 0000:00:05.0: reg 20: [io  0xb800-0xb80f]
[    0.252022] pci 0000:00:05.0: reg 24: [mem 0xfa00b000-0xfa00bfff]
[    0.252147] pci 0000:00:05.1: [10de:037f] type 00 class 0x010185
[    0.252211] pci 0000:00:05.1: reg 10: [io  0xbc00-0xbc07]
[    0.252263] pci 0000:00:05.1: reg 14: [io  0xc000-0xc003]
[    0.252315] pci 0000:00:05.1: reg 18: [io  0xc400-0xc407]
[    0.252366] pci 0000:00:05.1: reg 1c: [io  0xc800-0xc803]
[    0.252428] pci 0000:00:05.1: reg 20: [io  0xcc00-0xcc0f]
[    0.252481] pci 0000:00:05.1: reg 24: [mem 0xfa004000-0xfa004fff]
[    0.252606] pci 0000:00:05.2: [10de:037f] type 00 class 0x010185
[    0.252670] pci 0000:00:05.2: reg 10: [io  0xd000-0xd007]
[    0.252722] pci 0000:00:05.2: reg 14: [io  0xd400-0xd403]
[    0.252778] pci 0000:00:05.2: reg 18: [io  0xd800-0xd807]
[    0.252829] pci 0000:00:05.2: reg 1c: [io  0xdc00-0xdc03]
[    0.252881] pci 0000:00:05.2: reg 20: [io  0xe000-0xe00f]
[    0.252932] pci 0000:00:05.2: reg 24: [mem 0xfa005000-0xfa005fff]
[    0.253064] pci 0000:00:06.0: [10de:0370] type 01 class 0x060401
[    0.253206] pci 0000:00:06.1: [10de:0371] type 00 class 0x040300
[    0.253272] pci 0000:00:06.1: reg 10: [mem 0xfa000000-0xfa003fff]
[    0.253425] pci 0000:00:06.1: PME# supported from D3hot D3cold
[    0.253516] pci 0000:00:08.0: [10de:0373] type 00 class 0x068000
[    0.253585] pci 0000:00:08.0: reg 10: [mem 0xfa007000-0xfa007fff]
[    0.253637] pci 0000:00:08.0: reg 14: [io  0xe400-0xe407]
[    0.253688] pci 0000:00:08.0: reg 18: [mem 0xfa008000-0xfa0080ff]
[    0.253741] pci 0000:00:08.0: reg 1c: [mem 0xfa009000-0xfa00900f]
[    0.253868] pci 0000:00:08.0: supports D1 D2
[    0.253915] pci 0000:00:08.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.254010] pci 0000:00:0f.0: [10de:0377] type 01 class 0x060400
[    0.254147] pci 0000:00:0f.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.254234] pci 0000:00:18.0: [1022:1200] type 00 class 0x060000
[    0.254347] pci 0000:00:18.1: [1022:1201] type 00 class 0x060000
[    0.254452] pci 0000:00:18.2: [1022:1202] type 00 class 0x060000
[    0.254549] pci 0000:00:18.3: [1022:1203] type 00 class 0x060000
[    0.254661] pci 0000:00:18.4: [1022:1204] type 00 class 0x060000
[    0.254871] pci 0000:00:06.0: PCI bridge to [bus 01] (subtractive decode)
[    0.254918] pci 0000:00:06.0:   bridge window [io  0x8000-0x8fff]
[    0.254967] pci 0000:00:06.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.255031] pci 0000:00:06.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.255094] pci 0000:00:06.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.255158] pci 0000:00:06.0:   bridge window [mem 0x000c0000-0x000dffff] (subtractive decode)
[    0.255222] pci 0000:00:06.0:   bridge window [mem 0xd0000000-0xfebfffff] (subtractive decode)
[    0.255367] pci 0000:02:00.0: [1002:9598] type 00 class 0x030000
[    0.255439] pci 0000:02:00.0: reg 10: [mem 0xe0000000-0xefffffff 64bit pref]
[    0.255500] pci 0000:02:00.0: reg 18: [mem 0xf9000000-0xf900ffff 64bit]
[    0.255555] pci 0000:02:00.0: reg 20: [io  0x9000-0x90ff]
[    0.255619] pci 0000:02:00.0: reg 30: [mem 0x00000000-0x0001ffff pref]
[    0.255718] pci 0000:02:00.0: supports D1 D2
[    0.255793] pci 0000:02:00.1: [1002:aa20] type 00 class 0x040300
[    0.255860] pci 0000:02:00.1: reg 10: [mem 0xf9010000-0xf9013fff 64bit]
[    0.256010] pci 0000:02:00.1: supports D1 D2
[    0.257455] pci 0000:00:0f.0: PCI bridge to [bus 02]
[    0.257504] pci 0000:00:0f.0:   bridge window [io  0x9000-0x9fff]
[    0.257550] pci 0000:00:0f.0:   bridge window [mem 0xf8000000-0xf9ffffff]
[    0.257599] pci 0000:00:0f.0:   bridge window [mem 0xe0000000-0xefffffff 64bit pref]
[    0.257674] pci_bus 0000:00: on NUMA node 0
[    0.257766] ACPI: Invalid Power Resource to register!
[    0.257811] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
[    0.257975] ACPI: Invalid Power Resource to register!
[    0.258032] ACPI: Invalid Power Resource to register!
[    0.258088] ACPI: Invalid Power Resource to register!
[    0.258144] ACPI: Invalid Power Resource to register!
[    0.258201] ACPI: Invalid Power Resource to register!
[    0.258301] ACPI: Invalid Power Resource to register!
[    0.258358] ACPI: Invalid Power Resource to register!
[    0.258421] ACPI: Invalid Power Resource to register!
[    0.258477] ACPI: Invalid Power Resource to register!
[    0.258533] ACPI: Invalid Power Resource to register!
[    0.258589] ACPI: Invalid Power Resource to register!
[    0.258635] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.313263] ACPI: PCI Interrupt Link [LNK1] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.313627] ACPI: PCI Interrupt Link [LNK2] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.313975] ACPI: PCI Interrupt Link [LNK3] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.314320] ACPI: PCI Interrupt Link [LNK4] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.314683] ACPI: PCI Interrupt Link [LNK5] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.315037] ACPI: PCI Interrupt Link [LNK6] (IRQs 5 *7 9 10 11 14 15)
[    0.315323] ACPI: PCI Interrupt Link [LNK7] (IRQs 5 7 9 10 11 14 *15)
[    0.315628] ACPI: PCI Interrupt Link [LNK8] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.315973] ACPI: PCI Interrupt Link [LP2P] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.316348] ACPI: PCI Interrupt Link [LUBA] (IRQs *5 7 9 10 11 14 15)
[    0.316636] ACPI: PCI Interrupt Link [LMAC] (IRQs *5 7 9 10 11 14 15)
[    0.316929] ACPI: PCI Interrupt Link [LAZA] (IRQs 5 7 9 10 *11 14 15)
[    0.317216] ACPI: PCI Interrupt Link [LPMU] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.317575] ACPI: PCI Interrupt Link [LSMB] (IRQs 5 *7 9 10 11 14 15)
[    0.317863] ACPI: PCI Interrupt Link [LUB2] (IRQs 5 7 9 *10 11 14 15)
[    0.318148] ACPI: PCI Interrupt Link [LIDE] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.318506] ACPI: PCI Interrupt Link [LSID] (IRQs 5 7 9 10 11 14 *15)
[    0.318793] ACPI: PCI Interrupt Link [LFID] (IRQs 5 7 9 *10 11 14 15)
[    0.319084] ACPI: PCI Interrupt Link [LSA2] (IRQs 5 7 9 10 *11 14 15)
[    0.319428] ACPI: PCI Interrupt Link [APC1] (IRQs 16) *0, disabled.
[    0.319663] ACPI: PCI Interrupt Link [APC2] (IRQs 17) *0, disabled.
[    0.319896] ACPI: PCI Interrupt Link [APC3] (IRQs 18) *0, disabled.
[    0.320132] ACPI: PCI Interrupt Link [APC4] (IRQs 19) *0, disabled.
[    0.320381] ACPI: PCI Interrupt Link [APC5] (IRQs 16) *0, disabled.
[    0.320617] ACPI: PCI Interrupt Link [APC6] (IRQs 16) *0
[    0.320827] ACPI: PCI Interrupt Link [APC7] (IRQs 16) *0
[    0.321043] ACPI: PCI Interrupt Link [APC8] (IRQs 16) *0, disabled.
[    0.321275] ACPI: PCI Interrupt Link [APCF] (IRQs 20 21 22 23) *0
[    0.321569] ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22 23) *0
[    0.321841] ACPI: PCI Interrupt Link [APMU] (IRQs 20 21 22 23) *0, disabled.
[    0.322137] ACPI: PCI Interrupt Link [AAZA] (IRQs 20 21 22 23) *0
[    0.322417] ACPI: PCI Interrupt Link [APCS] (IRQs 20 21 22 23) *0
[    0.322686] ACPI: PCI Interrupt Link [APCL] (IRQs 20 21 22 23) *0
[    0.322962] ACPI: PCI Interrupt Link [APCM] (IRQs 20 21 22 23) *0, disabled.
[    0.323258] ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22 23) *0, disabled.
[    0.323561] ACPI: PCI Interrupt Link [APSI] (IRQs 20 21 22 23) *0
[    0.323832] ACPI: PCI Interrupt Link [APSJ] (IRQs 20 21 22 23) *0
[    0.324103] ACPI: PCI Interrupt Link [ASA2] (IRQs 20 21 22 23) *0
[    0.324859] vgaarb: device added: PCI:0000:02:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.324925] vgaarb: loaded
[    0.324966] vgaarb: bridge control possible 0000:02:00.0
[    0.325336] SCSI subsystem initialized
[    0.325379] ACPI: bus type scsi registered
[    0.325767] libata version 3.00 loaded.
[    0.325828] ACPI: bus type usb registered
[    0.326059] usbcore: registered new interface driver usbfs
[    0.326195] usbcore: registered new interface driver hub
[    0.326381] usbcore: registered new device driver usb
[    0.327037] Advanced Linux Sound Architecture Driver Initialized.
[    0.327082] PCI: Using ACPI for IRQ routing
[    0.331339] PCI: pci_cache_line_size set to 64 bytes
[    0.331505] e820: reserve RAM buffer [mem 0x0009f800-0x0009ffff]
[    0.331551] e820: reserve RAM buffer [mem 0xcfff0000-0xcfffffff]
[    0.332541] hpet clockevent registered
[    0.332587] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.332636] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
[    0.332771] hpet0: 3 comparators, 32-bit 25.000000 MHz counter
[    0.338863] Switching to clocksource hpet
[    0.353080] pnp: PnP ACPI init
[    0.353165] ACPI: bus type pnp registered
[    0.353577] system 00:00: [io  0x1000-0x107f] has been reserved
[    0.353623] system 00:00: [io  0x1080-0x10ff] has been reserved
[    0.353668] system 00:00: [io  0x1400-0x147f] has been reserved
[    0.353712] system 00:00: [io  0x1480-0x14ff] has been reserved
[    0.353757] system 00:00: [io  0x1800-0x187f] has been reserved
[    0.353801] system 00:00: [io  0x1880-0x18ff] has been reserved
[    0.353847] system 00:00: [mem 0xd0000000-0xdfffffff] has been reserved
[    0.353926] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.355394] system 00:01: [io  0x04d0-0x04d1] has been reserved
[    0.355440] system 00:01: [io  0x0800-0x087f] has been reserved
[    0.355484] system 00:01: [io  0x0295-0x0314] has been reserved
[    0.355529] system 00:01: [io  0x0290-0x0294] has been reserved
[    0.355577] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.355650] pnp 00:02: [dma 4]
[    0.355839] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.356139] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.356389] pnp 00:04: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.356629] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.356846] pnp 00:06: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.357400] pnp 00:07: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.357824] pnp 00:08: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.358152] system 00:09: [mem 0xf0000000-0xf7ffffff] has been reserved
[    0.358202] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.358577] system 00:0a: [mem 0x000d0000-0x000d3fff] has been reserved
[    0.358623] system 00:0a: [mem 0x000d5800-0x000d7fff] has been reserved
[    0.358668] system 00:0a: [mem 0x000f0000-0x000fbfff] could not be reserved
[    0.358713] system 00:0a: [mem 0x000fc000-0x000fffff] could not be reserved
[    0.358759] system 00:0a: [mem 0xcfff0000-0xcfffffff] could not be reserved
[    0.358804] system 00:0a: [mem 0xffff0000-0xffffffff] has been reserved
[    0.358849] system 00:0a: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.358894] system 00:0a: [mem 0x00100000-0xcffeffff] could not be reserved
[    0.359463] system 00:0a: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.359508] system 00:0a: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.359557] system 00:0a: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.359631] pnp: PnP ACPI: found 11 devices
[    0.359674] ACPI: ACPI bus type pnp unregistered
[    0.373559] pci 0000:00:06.0: PCI bridge to [bus 01]
[    0.373606] pci 0000:00:06.0:   bridge window [io  0x8000-0x8fff]
[    0.373666] pci 0000:02:00.0: BAR 6: assigned [mem 0xf8000000-0xf801ffff pref]
[    0.373730] pci 0000:00:0f.0: PCI bridge to [bus 02]
[    0.373774] pci 0000:00:0f.0:   bridge window [io  0x9000-0x9fff]
[    0.373821] pci 0000:00:0f.0:   bridge window [mem 0xf8000000-0xf9ffffff]
[    0.373867] pci 0000:00:0f.0:   bridge window [mem 0xe0000000-0xefffffff 64bit pref]
[    0.373956] pci 0000:00:06.0: setting latency timer to 64
[    0.374005] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.374049] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.374092] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.374137] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000dffff]
[    0.374181] pci_bus 0000:00: resource 8 [mem 0xd0000000-0xfebfffff]
[    0.374225] pci_bus 0000:01: resource 0 [io  0x8000-0x8fff]
[    0.374268] pci_bus 0000:01: resource 4 [io  0x0000-0x0cf7]
[    0.374311] pci_bus 0000:01: resource 5 [io  0x0d00-0xffff]
[    0.374355] pci_bus 0000:01: resource 6 [mem 0x000a0000-0x000bffff]
[    0.374399] pci_bus 0000:01: resource 7 [mem 0x000c0000-0x000dffff]
[    0.374443] pci_bus 0000:01: resource 8 [mem 0xd0000000-0xfebfffff]
[    0.374487] pci_bus 0000:02: resource 0 [io  0x9000-0x9fff]
[    0.374530] pci_bus 0000:02: resource 1 [mem 0xf8000000-0xf9ffffff]
[    0.374574] pci_bus 0000:02: resource 2 [mem 0xe0000000-0xefffffff 64bit pref]
[    0.374724] NET: Registered protocol family 2
[    0.375186] TCP established hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.375686] TCP bind hash table entries: 32768 (order: 9, 2621440 bytes)
[    0.378103] TCP: Hash tables configured (established 65536 bind 32768)
[    0.378251] TCP: reno registered
[    0.378324] UDP hash table entries: 4096 (order: 7, 786432 bytes)
[    0.379017] UDP-Lite hash table entries: 4096 (order: 7, 786432 bytes)
[    0.379875] NET: Registered protocol family 1
[    0.380221] ACPI: PCI Interrupt Link [APCF] enabled at IRQ 23
[    0.456031] ACPI: PCI Interrupt Link [APCL] enabled at IRQ 22
[    0.456233] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.456362] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.456491] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.456625] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.456764] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.456945] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.457124] pci 0000:00:00.0: Found enabled HT MSI Mapping
[    0.457189] pci 0000:02:00.0: Boot video device
[    0.457237] PCI: CLS 32 bytes, default 64
[    0.458343] PCI-DMA: Disabling AGP.
[    0.458507] PCI-DMA: aperture base @ c4000000 size 65536 KB
[    0.458550] PCI-DMA: using GART IOMMU.
[    0.458594] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    0.465163] LVT offset 1 assigned for vector 0x400
[    0.465234] Failed to setup IBS LVT offset, IBSCTL = 0xffffffff
[    0.465279] [Firmware Bug]: cpu 1, try to use APIC500 (LVT offset 0) for vector 0x10400, but the register is already in use for vector 0xf9 on another cpu
[    0.465348] [Firmware Bug]: cpu 1, IBS interrupt offset 0 not available (MSRC001103A=0x0000000000000100)
[    0.465413] Failed to setup IBS, -22
[    0.477544] msgmni has been set to 15915
[    0.478579] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.478669] io scheduler noop registered
[    0.478864] io scheduler cfq registered (default)
[    0.479285] pcieport 0000:00:0f.0: irq 40 for MSI/MSI-X
[    0.490647] GHES: HEST is not enabled!
[    0.490951] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.511679] 00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.513709] hpet_acpi_add: no address or irqs in _CRS
[    0.513865] Linux agpgart interface v0.103
[    0.514016] [drm] Initialized drm 1.1.0 20060810
[    0.517222] loop: module loaded
[    0.518244] sata_nv 0000:00:05.0: version 3.5
[    0.518460] ACPI: PCI Interrupt Link [APSI] enabled at IRQ 21
[    0.518532] sata_nv 0000:00:05.0: Using SWNCQ mode
[    0.518677] sata_nv 0000:00:05.0: setting latency timer to 64
[    0.520076] scsi0 : sata_nv
[    0.520722] scsi1 : sata_nv
[    0.521192] ata1: SATA max UDMA/133 cmd 0xa800 ctl 0xac00 bmdma 0xb800 irq 21
[    0.521238] ata2: SATA max UDMA/133 cmd 0xb000 ctl 0xb400 bmdma 0xb808 irq 21
[    0.521498] ACPI: PCI Interrupt Link [APSJ] enabled at IRQ 20
[    0.521560] sata_nv 0000:00:05.1: Using SWNCQ mode
[    0.521670] sata_nv 0000:00:05.1: setting latency timer to 64
[    0.522876] scsi2 : sata_nv
[    0.523363] scsi3 : sata_nv
[    0.523818] ata3: SATA max UDMA/133 cmd 0xbc00 ctl 0xc000 bmdma 0xcc00 irq 20
[    0.523864] ata4: SATA max UDMA/133 cmd 0xc400 ctl 0xc800 bmdma 0xcc08 irq 20
[    0.524085] ACPI: PCI Interrupt Link [ASA2] enabled at IRQ 23
[    0.524131] sata_nv 0000:00:05.2: Using SWNCQ mode
[    0.524238] sata_nv 0000:00:05.2: setting latency timer to 64
[    0.525378] scsi4 : sata_nv
[    0.525881] scsi5 : sata_nv
[    0.526306] ata5: SATA max UDMA/133 cmd 0xd000 ctl 0xd400 bmdma 0xe000 irq 23
[    0.526351] ata6: SATA max UDMA/133 cmd 0xd800 ctl 0xdc00 bmdma 0xe008 irq 23
[    0.526603] pata_amd 0000:00:04.0: version 0.4.1
[    0.526694] pata_amd 0000:00:04.0: setting latency timer to 64
[    0.528002] scsi6 : pata_amd
[    0.528611] scsi7 : pata_amd
[    0.529168] ata7: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xf000 irq 14
[    0.529221] ata8: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xf008 irq 15
[    0.529653] forcedeth: Reverse Engineered nForce ethernet driver. Version 0.64.
[    0.529900] ACPI: PCI Interrupt Link [APCH] enabled at IRQ 22
[    0.529949] forcedeth 0000:00:08.0: setting latency timer to 64
[    0.683131] ata7.00: ATAPI: Optiarc DVD RW AD-7173A, 1-01, max UDMA/66
[    0.683182] ata7: nv_mode_filter: 0x1f39f&0x1f39f->0x1f39f, BIOS=0x1f000 (0xc5000000) ACPI=0x1f01f (30:600:0x13)
[    0.689001] ata7.00: configured for UDMA/66
[    0.826567] ata3: SATA link down (SStatus 0 SControl 300)
[    0.828564] ata5: SATA link down (SStatus 0 SControl 300)
[    0.975440] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    0.979422] ata1.00: HPA detected: current 488395055, native 488397168
[    0.979468] ata1.00: ATA-8: WDC WD2500AAJS-62B4A0, 01.03A01, max UDMA/133
[    0.979512] ata1.00: 488395055 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    0.979770] ata1.00: failed to get Identify Device Data, Emask 0x1
[    0.985979] ata1.00: failed to get Identify Device Data, Emask 0x1
[    0.986024] ata1.00: configured for UDMA/133
[    0.986705] scsi 0:0:0:0: Direct-Access     ATA      WDC WD2500AAJS-6 01.0 PQ: 0 ANSI: 5
[    0.987858] sd 0:0:0:0: [sda] 488395055 512-byte logical blocks: (250 GB/232 GiB)
[    0.988423] sd 0:0:0:0: [sda] Write Protect is off
[    0.988453] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    0.988511] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    0.988605] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    0.989177] ACPI: Invalid Power Resource to register!
[    1.020725]  sda: sda1 sda2
[    1.021980] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.051312] forcedeth 0000:00:08.0: ifname eth0, PHY OUI 0x5043 @ 1, addr 00:1d:7d:e5:31:3d
[    1.051399] forcedeth 0000:00:08.0: highdma csum vlan pwrctl mgmt gbit lnktim msi desc-v3
[    1.051804] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.051849] ehci-pci: EHCI PCI platform driver
[    1.051944] ehci-pci 0000:00:02.1: setting latency timer to 64
[    1.051990] ehci-pci 0000:00:02.1: EHCI Host Controller
[    1.052153] ehci-pci 0000:00:02.1: new USB bus registered, assigned bus number 1
[    1.052291] ehci-pci 0000:00:02.1: debug port 1
[    1.052340] ehci-pci 0000:00:02.1: cache line size of 32 is not supported
[    1.052436] ehci-pci 0000:00:02.1: irq 22, io mem 0xfa00a000
[    1.058380] ehci-pci 0000:00:02.1: USB 2.0 started, EHCI 1.00
[    1.058565] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.058610] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.058673] usb usb1: Product: EHCI Host Controller
[    1.058716] usb usb1: Manufacturer: Linux 3.8.0-rc1 ehci_hcd
[    1.058760] usb usb1: SerialNumber: 0000:00:02.1
[    1.059542] hub 1-0:1.0: USB hub found
[    1.059621] hub 1-0:1.0: 10 ports detected
[    1.060281] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.060393] ohci_hcd 0000:00:02.0: setting latency timer to 64
[    1.060439] ohci_hcd 0000:00:02.0: OHCI Host Controller
[    1.060492] ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
[    1.060573] ohci_hcd 0000:00:02.0: irq 23, io mem 0xfa006000
[    1.113387] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    1.113432] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.113495] usb usb2: Product: OHCI Host Controller
[    1.113538] usb usb2: Manufacturer: Linux 3.8.0-rc1 ohci_hcd
[    1.113582] usb usb2: SerialNumber: 0000:00:02.0
[    1.113975] hub 2-0:1.0: USB hub found
[    1.114028] hub 2-0:1.0: 10 ports detected
[    1.114470] uhci_hcd: USB Universal Host Controller Interface driver
[    1.114648] Initializing USB Mass Storage driver...
[    1.114810] usbcore: registered new interface driver usb-storage
[    1.114854] USB Mass Storage support registered.
[    1.115147] i8042: PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    1.115192] i8042: PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[    1.115610] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.116313] mousedev: PS/2 mouse device common for all mice
[    1.116749] usbcore: registered new interface driver usbtouchscreen
[    1.116842] rtc_cmos 00:04: RTC can wake from S4
[    1.117287] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    1.117400] rtc0: alarms up to one year, y3k, 242 bytes nvram, hpet irqs
[    1.118077] cpuidle: using governor ladder
[    1.118124] cpuidle: using governor menu
[    1.119665] usbcore: registered new interface driver usbhid
[    1.119712] usbhid: USB HID core driver
[    1.120423] ACPI: PCI Interrupt Link [AAZA] enabled at IRQ 21
[    1.120470] hda_intel: Disabling MSI
[    1.120548] snd_hda_intel 0000:00:06.1: setting latency timer to 64
[    1.135144] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    1.412076] usb 1-8: new high-speed USB device number 3 using ehci-pci
[    1.443055] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.462403] ata2.00: ATA-7: SAMSUNG HD103UJ, 1AA01113, max UDMA7
[    1.462447] ata2.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    1.462610] ata2.00: failed to get Identify Device Data, Emask 0x1
[    1.467069] tsc: Refined TSC clocksource calibration: 2713.907 MHz
[    1.467137] Switching to clocksource tsc
[    1.481436] ata2.00: failed to get Identify Device Data, Emask 0x1
[    1.481482] ata2.00: configured for UDMA/133
[    1.481707] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD103UJ  1AA0 PQ: 0 ANSI: 5
[    1.482392] sd 1:0:0:0: [sdb] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    1.482559] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    1.482578] sd 1:0:0:0: [sdb] Write Protect is off
[    1.482580] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    1.482628] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.483158] ACPI: Invalid Power Resource to register!
[    1.492450]  sdb: sdb1
[    1.493192] sd 1:0:0:0: [sdb] Attached SCSI disk
[    1.526483] usb 1-8: New USB device found, idVendor=0424, idProduct=2504
[    1.526530] usb 1-8: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.527059] hub 1-8:1.0: USB hub found
[    1.527242] hub 1-8:1.0: 2 ports detected
[    1.743789] usb 2-7: new low-speed USB device number 2 using ohci_hcd
[    1.785757] ata4: SATA link down (SStatus 0 SControl 300)
[    1.884038] ACPI: PCI Interrupt Link [APC7] enabled at IRQ 16
[    1.884191] snd_hda_intel 0000:02:00.1: irq 41 for MSI/MSI-X
[    1.887959] TCP: cubic registered
[    1.888007] NET: Registered protocol family 17
[    1.888070] 9pnet: Installing 9P2000 support
[    1.888354] Key type dns_resolver registered
[    1.888726] usb 2-7: New USB device found, idVendor=046d, idProduct=c018
[    1.888772] usb 2-7: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    1.888817] usb 2-7: Product: USB Optical Mouse
[    1.888862] usb 2-7: Manufacturer: Logitech
[    1.894319] registered taskstats version 1
[    1.895498] console [netcon0] enabled
[    1.895543] netconsole: network logging started
[    1.895629] rtc_cmos 00:04: setting system clock to 2012-12-22 15:34:24 UTC (1356190464)
[    1.895845] ALSA device list:
[    1.895886]   #0: HDA NVidia at 0xfa000000 irq 21
[    1.895929]   #1: HDA ATI HDMI at 0xf9010000 irq 41
[    1.899414] input: Logitech USB Optical Mouse as /devices/pci0000:00/0000:00:02.0/usb2/2-7/2-7:1.0/input/input1
[    1.899859] hid-generic 0003:046D:C018.0001: input: USB HID v1.11 Mouse [Logitech USB Optical Mouse] on usb-0000:00:02.0-7/input0
[    2.088497] ata6: SATA link down (SStatus 0 SControl 300)
[    2.089698] scsi 6:0:0:0: CD-ROM            Optiarc  DVD RW AD-7173A  1-01 PQ: 0 ANSI: 5
[    2.091433] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[    2.091512] cdrom: Uniform CD-ROM driver Revision: 3.20
[    2.092058] sr 6:0:0:0: Attached scsi CD-ROM sr0
[    2.092370] sr 6:0:0:0: Attached scsi generic sg2 type 5
[    2.092843] ACPI: Invalid Power Resource to register!
[    2.093003] ata8: port disabled--ignoring
[    2.142825] kjournald starting.  Commit interval 5 seconds
[    2.142967] EXT3-fs (sda1): mounted filesystem with writeback data mode
[    2.143106] VFS: Mounted root (ext3 filesystem) readonly on device 8:1.
[    2.146939] Freeing unused kernel memory: 2452k freed
[    4.712567] k10temp 0000:00:18.3: unreliable CPU thermal sensor; monitoring disabled
[    5.219154] microcode: CPU0: patch_level=0x01000035
[    5.388041] microcode: CPU0: new patch_level=0x01000083
[    5.388111] microcode: CPU1: patch_level=0x01000035
[    5.388167] microcode: CPU1: new patch_level=0x01000083
[    5.388373] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    5.400626] EDAC MC: Ver: 3.0.0
[    5.509709] AMD64 EDAC driver v3.4.0
[    5.509810] EDAC amd64: DRAM ECC disabled.
[    5.509913] EDAC amd64: ECC disabled in the BIOS or no ECC capability, module will not load.
[    5.509913]  Either enable ECC checking or force module loading by setting 'ecc_enable_override'.
[    5.509913]  (Note that use of the override may cause unknown side effects.)
[    6.598961] [drm] radeon kernel modesetting enabled.
[    6.599387] ACPI: PCI Interrupt Link [APC6] enabled at IRQ 16
[    6.600291] [drm] initializing kernel modesetting (RV635 0x1002:0x9598 0x1043:0x01DA).
[    6.600475] [drm] register mmio base: 0xF9000000
[    6.600518] [drm] register mmio size: 65536
[    6.601178] ATOM BIOS: 9598.10.88.0.3.AS05
[    6.601274] radeon 0000:02:00.0: VRAM: 512M 0x0000000000000000 - 0x000000001FFFFFFF (512M used)
[    6.601339] radeon 0000:02:00.0: GTT: 512M 0x0000000020000000 - 0x000000003FFFFFFF
[    6.602612] [drm] Detected VRAM RAM=512M, BAR=256M
[    6.602663] [drm] RAM width 128bits DDR
[    6.603101] [TTM] Zone  kernel: Available graphics memory: 4075552 kiB
[    6.603152] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB
[    6.603196] [TTM] Initializing pool allocator
[    6.603260] [TTM] Initializing DMA pool allocator
[    6.603861] [drm] radeon: 512M of VRAM memory ready
[    6.603906] [drm] radeon: 512M of GTT memory ready.
[    6.604026] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    6.604070] [drm] Driver supports precise vblank timestamp query.
[    6.604234] radeon 0000:02:00.0: irq 42 for MSI/MSI-X
[    6.604297] radeon 0000:02:00.0: radeon: using MSI.
[    6.604435] [drm] radeon: irq initialized.
[    6.604481] [drm] GART: num cpu pages 131072, num gpu pages 131072
[    6.605457] [drm] probing gen 2 caps for device 10de:377 = 1/0
[    6.605589] [drm] Loading RV635 Microcode
[    6.725924] [drm] PCIE GART of 512M enabled (table at 0x0000000000040000).
[    6.726187] radeon 0000:02:00.0: WB enabled
[    6.726232] radeon 0000:02:00.0: fence driver on ring 0 use gpu addr 0x0000000020000c00 and cpu addr 0xffff88022308ac00
[    6.726298] radeon 0000:02:00.0: fence driver on ring 3 use gpu addr 0x0000000020000c0c and cpu addr 0xffff88022308ac0c
[    6.760444] [drm] ring test on 0 succeeded in 0 usecs
[    6.760552] [drm] ring test on 3 succeeded in 1 usecs
[    6.761163] [drm] ib test on ring 0 succeeded in 0 usecs
[    6.761224] [drm] ib test on ring 3 succeeded in 0 usecs
[    6.762055] [drm] Radeon Display Connectors
[    6.762100] [drm] Connector 0:
[    6.762141] [drm]   DVI-I-1
[    6.762182] [drm]   HPD1
[    6.762224] [drm]   DDC: 0x7e50 0x7e50 0x7e54 0x7e54 0x7e58 0x7e58 0x7e5c 0x7e5c
[    6.762286] [drm]   Encoders:
[    6.762327] [drm]     DFP1: INTERNAL_UNIPHY
[    6.762369] [drm]     CRT2: INTERNAL_KLDSCP_DAC2
[    6.762411] [drm] Connector 1:
[    6.762452] [drm]   DIN-1
[    6.762492] [drm]   Encoders:
[    6.762533] [drm]     TV1: INTERNAL_KLDSCP_DAC2
[    6.762585] [drm] Connector 2:
[    6.762626] [drm]   DVI-I-2
[    6.762667] [drm]   HPD2
[    6.762708] [drm]   DDC: 0x7e40 0x7e40 0x7e44 0x7e44 0x7e48 0x7e48 0x7e4c 0x7e4c
[    6.762770] [drm]   Encoders:
[    6.762811] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[    6.762853] [drm]     DFP2: INTERNAL_KLDSCP_LVTMA
[    6.762979] [drm] Internal thermal controller without fan control
[    6.763221] [drm] radeon: power management initialized
[    6.879818] [drm] fb mappable at 0xE0142000
[    6.879868] [drm] vram apper at 0xE0000000
[    6.879910] [drm] size 7299072
[    6.879951] [drm] fb depth is 24
[    6.879992] [drm]    pitch is 6912
[    6.880526] fbcon: radeondrmfb (fb0) is primary device
[    7.065653] kvm: Nested Virtualization enabled
[    7.065655] kvm: Nested Paging enabled
[    7.097973] Console: switching to colour frame buffer device 210x65
[    7.103313] radeon 0000:02:00.0: fb0: radeondrmfb frame buffer device
[    7.103348] radeon 0000:02:00.0: registered panic notifier
[    7.103409] [drm] Initialized radeon 2.27.0 20080528 for 0000:02:00.0 on minor 0
[    8.992728] Adding 16016800k swap on /dev/sda2.  Priority:-1 extents:1 across:16016800k 
[    9.425132] EXT3-fs (sda1): using internal journal
[   10.083272] fuse init (API version 7.20)
[   11.305372] kjournald starting.  Commit interval 5 seconds
[   11.305614] EXT3-fs (sdb1): warning: maximal mount count reached, running e2fsck is recommended
[   11.306070] EXT3-fs (sdb1): using internal journal
[   11.306100] EXT3-fs (sdb1): mounted filesystem with writeback data mode
[   12.325233] forcedeth 0000:00:08.0: irq 43 for MSI/MSI-X
[   12.325407] forcedeth 0000:00:08.0 eth0: MSI enabled
[   13.337798] NET: Registered protocol family 10
[   15.683433] device-mapper: ioctl: 4.23.1-ioctl (2012-12-18) initialised: dm-devel@redhat.com
[   21.522709] powernow-k8: this CPU is not supported anymore, using acpi-cpufreq instead.
[   21.565508] acpi-cpufreq: overriding BIOS provided _PSD data

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
