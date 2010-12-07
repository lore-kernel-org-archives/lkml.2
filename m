Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829Ab0LGPxI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 10:53:08 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49409 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848Ab0LGPxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 10:53:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=hWXN7Rnn6kICrXBl+F0lj3nc+arYIRzW9H8CdTO1H8O0kMEgudMDkBzKP4N0JCE30G
         rnVb3gnr1LPc3DAOzRB/0Pvkua/0SLDyXPj6+2w2RlgFNST9P2P9ku5aTTmVw9674Mt6
         H30OP86uZxV6I/Oq/eoZDuz5Co/oVHhVnwV8A=
Subject: Re: acpi_button: random oops on boot
From: Tobias Karnat <tobias.karnat@googlemail.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-acpi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        richard.coe@med.ge.com, jslaby@novell.com
In-Reply-To: <1291736130.29072.19.camel@Tobias-Karnat>
References: <1291477752.5096.27.camel@Tobias-Karnat>
	 <201012060928.11307.bjorn.helgaas@hp.com>
	 <1291676503.24968.25.camel@Tobias-Karnat>
	 <201012061626.45962.bjorn.helgaas@hp.com>
	 <1291679699.6246.11.camel@Tobias-Karnat>
	 <20101207051521.GA16804@helgaas.com>
	 <1291734122.29072.14.camel@Tobias-Karnat>
	 <1291736130.29072.19.camel@Tobias-Karnat>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Dec 2010 16:52:58 +0100
Message-ID: <1291737178.3929.7.camel@Tobias-Karnat>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, den 07.12.2010, 16:35 +0100 schrieb Tobias Karnat:
> Oh well, it might be the Card Reader.
> 
> I will try booting without it, maybe it fixes the boot issue.
> 
> But strange that the printk patch could fix this.
> And the card reader did work with earlier kernels ~2.6.2x.

No, it wasn't the card reader.

I have no idea why it throws errors with maxcpus=1, but right now the
bigger problem is to get the oops on boot fixed.

-Tobias

Dmesg with mminit_loglevel=4:

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.36.1 (root@Tobias-Karnat) (gcc version 4.4.5 (Ubuntu/Linaro 4.4.4-14ubuntu5) ) #1 SMP PREEMPT Sat Dec 4 15:09:10 CET 2010
[    0.000000] Command line: root=/dev/md1 ro single vga=795 mminit_loglevel=4 maxcpus=1
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bfe0ac00 (usable)
[    0.000000]  BIOS-e820: 00000000bfe0ac00 - 00000000bfe0cc00 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bfe0ec00 - 00000000bfe5cc00 (reserved)
[    0.000000]  BIOS-e820: 00000000bfe5cc00 - 00000000bfe5ec00 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bfe5ec00 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fed00400 (reserved)
[    0.000000]  BIOS-e820: 00000000fed20000 - 00000000feda0000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 00000001bc000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.3 present.
[    0.000000] e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x1bc000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-D3FFF write-protect
[    0.000000]   D4000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask 000000000 write-back
[    0.000000]   1 base 0BFF00000 mask FFFF00000 uncachable
[    0.000000]   2 base 0C0000000 mask FC0000000 uncachable
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000bff00000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xbfe0a max_arch_pfn = 0x400000000
[    0.000000] e820 update range: 0000000000001000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000009fc00 (usable)
[    0.000000]  modified: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 00000000bfe0ac00 (usable)
[    0.000000]  modified: 00000000bfe0ac00 - 00000000bfe0cc00 (ACPI NVS)
[    0.000000]  modified: 00000000bfe0ec00 - 00000000bfe5cc00 (reserved)
[    0.000000]  modified: 00000000bfe5cc00 - 00000000bfe5ec00 (ACPI data)
[    0.000000]  modified: 00000000bfe5ec00 - 00000000c0000000 (reserved)
[    0.000000]  modified: 00000000f0000000 - 00000000f4000000 (reserved)
[    0.000000]  modified: 00000000fec00000 - 00000000fed00400 (reserved)
[    0.000000]  modified: 00000000fed20000 - 00000000feda0000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fef00000 (reserved)
[    0.000000]  modified: 00000000ffb00000 - 0000000100000000 (reserved)
[    0.000000]  modified: 0000000100000000 - 00000001bc000000 (usable)
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] found SMP MP-table at [ffff8800000fe710] fe710
[    0.000000] init_memory_mapping: 0000000000000000-00000000bfe0a000
[    0.000000]  0000000000 - 00bfe00000 page 2M
[    0.000000]  00bfe00000 - 00bfe0a000 page 4k
[    0.000000] kernel direct mapping tables up to bfe0a000 @ 16000-1b000
[    0.000000] init_memory_mapping: 0000000100000000-00000001bc000000
[    0.000000]  0100000000 - 01bc000000 page 2M
[    0.000000] kernel direct mapping tables up to 1bc000000 @ 19000-21000
[    0.000000] RAMDISK: 36fff000 - 37ff0000
[    0.000000] ACPI: RSDP 00000000000febf0 00024 (v02 DELL  )
[    0.000000] ACPI: XSDT 00000000000fcedc 00094 (v01 DELL    B8K     00000015 ASL  00000061)
[    0.000000] ACPI: FACP 00000000000fd004 000F4 (v03 DELL    B8K     00000015 ASL  00000061)
[    0.000000] ACPI: DSDT 00000000fff53074 036E3 (v01   DELL    dt_ex 00001000 INTL 20050624)
[    0.000000] ACPI: FACS 00000000bfe0ac00 00040
[    0.000000] ACPI: SSDT 00000000fff56878 000AC (v01   DELL    st_ex 00001000 INTL 20050624)
[    0.000000] ACPI: APIC 00000000000fd0f8 00092 (v01 DELL    B8K     00000015 ASL  00000061)
[    0.000000] ACPI: BOOT 00000000000fd18a 00028 (v01 DELL    B8K     00000015 ASL  00000061)
[    0.000000] ACPI: ASF! 00000000000fd1b2 00092 (v32 DELL    B8K     00000015 ASL  00000061)
[    0.000000] ACPI: MCFG 00000000000fd244 0003E (v01 DELL    B8K     00000015 ASL  00000061)
[    0.000000] ACPI: HPET 00000000000fd282 00038 (v01 DELL    B8K     00000015 ASL  00000061)
[    0.000000] ACPI: TCPA 00000000000fd4de 00032 (v01 DELL    B8K     00000015 ASL  00000061)
[    0.000000] ACPI: SLIC 00000000000fd2ba 00176 (v01 DELL    B8K     00000015 ASL  00000061)
[    0.000000] ACPI: SSDT 00000000bfe0ac40 001F9 (v01 DpgPmm  Cpu0Ist 00000011 INTL 20050624)
[    0.000000] ACPI: SSDT 00000000bfe0b049 001F9 (v01 DpgPmm  Cpu1Ist 00000011 INTL 20050624)
[    0.000000] ACPI: SSDT 00000000bfe0b452 001F9 (v01 DpgPmm  Cpu2Ist 00000011 INTL 20050624)
[    0.000000] ACPI: SSDT 00000000bfe0b85b 001F9 (v01 DpgPmm  Cpu3Ist 00000011 INTL 20050624)
[    0.000000] ACPI: SSDT 00000000bfe0bc64 00140 (v01 DpgPmm    CpuPm 00000010 INTL 20050624)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-00000001bc000000
[    0.000000] mminit::memory_register Entering add_active_range(0, 0x10, 0x9f) 0 entries of 3200 used
[    0.000000] mminit::memory_register Entering add_active_range(0, 0x100, 0xbfe0a) 1 entries of 3200 used
[    0.000000] mminit::memory_register Entering add_active_range(0, 0x100000, 0x1bc000) 2 entries of 3200 used
[    0.000000] Initmem setup node 0 0000000000000000-00000001bc000000
[    0.000000]   NODE_DATA [0000000100000000 - 0000000100004fff]
[    0.000000]  [ffffea0000000000-ffffea00061fffff] PMD -> [ffff880100200000-ffff8801055fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x001bc000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000bfe0a
[    0.000000]     0: 0x00100000 -> 0x001bc000
[    0.000000] mminit::pageflags_layout_widths Section 0 Node 6 Zone 2 Flags 25
[    0.000000] mminit::pageflags_layout_shifts Section 19 Node 6 Zone 2
[    0.000000] mminit::pageflags_layout_offsets Section 0 Node 58 Zone 56
[    0.000000] mminit::pageflags_layout_zoneid Zone ID: 56 -> 64
[    0.000000] mminit::pageflags_layout_usage location: 64 -> 56 unused 56 -> 25 flags 25 -> 0
[    0.000000] On node 0 totalpages: 1555865
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3927 pages, LIFO batch:0
[    0.000000] mminit::memmap_init Initialising map node 0 zone 0 pfns 16 -> 4096
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 767554 pages, LIFO batch:31
[    0.000000] mminit::memmap_init Initialising map node 0 zone 1 pfns 4096 -> 1048576
[    0.000000]   Normal zone: 10528 pages used for memmap
[    0.000000]   Normal zone: 759520 pages, LIFO batch:31
[    0.000000] mminit::memmap_init Initialising map node 0 zone 2 pfns 1048576 -> 1818624
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x01] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x02] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x03] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high level lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 8 CPUs, 4 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] early_res array is doubled to 64 at [1c000 - 1c7ff]
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000bfe0a000 - 00000000bfe0b000
[    0.000000] PM: Registered nosave memory: 00000000bfe0b000 - 00000000bfe0c000
[    0.000000] PM: Registered nosave memory: 00000000bfe0c000 - 00000000bfe0f000
[    0.000000] PM: Registered nosave memory: 00000000bfe0f000 - 00000000bfe5c000
[    0.000000] PM: Registered nosave memory: 00000000bfe5c000 - 00000000bfe5d000
[    0.000000] PM: Registered nosave memory: 00000000bfe5d000 - 00000000bfe5e000
[    0.000000] PM: Registered nosave memory: 00000000bfe5e000 - 00000000bfe5f000
[    0.000000] PM: Registered nosave memory: 00000000bfe5f000 - 00000000c0000000
[    0.000000] PM: Registered nosave memory: 00000000c0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000f4000000
[    0.000000] PM: Registered nosave memory: 00000000f4000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fed00000
[    0.000000] PM: Registered nosave memory: 00000000fed00000 - 00000000fed20000
[    0.000000] PM: Registered nosave memory: 00000000fed20000 - 00000000feda0000
[    0.000000] PM: Registered nosave memory: 00000000feda0000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fef00000
[    0.000000] PM: Registered nosave memory: 00000000fef00000 - 00000000ffb00000
[    0.000000] PM: Registered nosave memory: 00000000ffb00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at c0000000 (gap: c0000000:30000000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff880001a00000 s81280 r8192 d21120 u262144
[    0.000000] early_res array is doubled to 128 at [1c800 - 1d7ff]
[    0.000000] pcpu-alloc: s81280 r8192 d21120 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] mminit::zonelist general 0:DMA = 0:DMA 
[    0.000000] mminit::zonelist general 0:DMA32 = 0:DMA32 0:DMA 
[    0.000000] mminit::zonelist general 0:Normal = 0:Normal 0:DMA32 0:DMA 
[    0.000000] mminit::zonelist thisnode 0:DMA = 0:DMA 
[    0.000000] mminit::zonelist thisnode 0:DMA32 = 0:DMA32 0:DMA 
[    0.000000] mminit::zonelist thisnode 0:Normal = 0:Normal 0:DMA32 0:DMA 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1531001
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: root=/dev/md1 ro single vga=795 mminit_loglevel=4 maxcpus=1
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Subtract (63 early reservations)
[    0.000000]   #1 [0001000000 - 000197fcc0]   TEXT DATA BSS
[    0.000000]   #2 [0036fff000 - 0037ff0000]         RAMDISK
[    0.000000]   #3 [0001980000 - 0001980190]             BRK
[    0.000000]   #4 [00000fe720 - 0000100000]   BIOS reserved
[    0.000000]   #5 [00000fe710 - 00000fe720]    MP-table mpf
[    0.000000]   #6 [000009fc00 - 00000f0000]   BIOS reserved
[    0.000000]   #7 [00000f02e4 - 00000fe710]   BIOS reserved
[    0.000000]   #8 [00000f0000 - 00000f02e4]    MP-table mpc
[    0.000000]   #9 [0000010000 - 0000012000]      TRAMPOLINE
[    0.000000]   #10 [0000012000 - 0000016000]     ACPI WAKEUP
[    0.000000]   #11 [0000016000 - 0000019000]         PGTABLE
[    0.000000]   #12 [0000019000 - 000001c000]         PGTABLE
[    0.000000]   #13 [0100000000 - 0100005000]       NODE_DATA
[    0.000000]   #14 [00019801c0 - 00019811c0]         BOOTMEM
[    0.000000]   #15 [0001d811c0 - 0001d81640]         BOOTMEM
[    0.000000]   #16 [0100005000 - 0100006000]         BOOTMEM
[    0.000000]   #17 [0100006000 - 0100007000]         BOOTMEM
[    0.000000]   #18 [0100200000 - 0105600000]        MEMMAP 0
[    0.000000]   #19 [000197fcc0 - 000197fe40]         BOOTMEM
[    0.000000]   #20 [00019811c0 - 00019991c0]         BOOTMEM
[    0.000000]   #21 [00019991c0 - 00019b11c0]         BOOTMEM
[    0.000000]   #22 [00019b2000 - 00019b3000]         BOOTMEM
[    0.000000]   #23 [000197fe40 - 000197fe81]         BOOTMEM
[    0.000000]   #24 [000197fec0 - 000197ff03]         BOOTMEM
[    0.000000]   #25 [00019b11c0 - 00019b14d0]         BOOTMEM
[    0.000000]   #26 [000197ff40 - 000197ffa8]         BOOTMEM
[    0.000000]   #27 [00019b1500 - 00019b1568]         BOOTMEM
[    0.000000]   #28 [00019b1580 - 00019b15e8]         BOOTMEM
[    0.000000]   #29 [00019b1600 - 00019b1668]         BOOTMEM
[    0.000000]   #30 [00019b1680 - 00019b16e8]         BOOTMEM
[    0.000000]   #31 [00019b1700 - 00019b1768]         BOOTMEM
[    0.000000]   #32 [00019b1780 - 00019b17e8]         BOOTMEM
[    0.000000]   #33 [00019b1800 - 00019b1868]         BOOTMEM
[    0.000000]   #34 [00019b1880 - 00019b18e8]         BOOTMEM
[    0.000000]   #35 [00019b1900 - 00019b1968]         BOOTMEM
[    0.000000]   #36 [00019b1980 - 00019b19e8]         BOOTMEM
[    0.000000]   #37 [00019b1a00 - 00019b1a68]         BOOTMEM
[    0.000000]   #38 [00019b1a80 - 00019b1ae8]         BOOTMEM
[    0.000000]   #39 [000197ffc0 - 000197ffe0]         BOOTMEM
[    0.000000]   #40 [00019b1b00 - 00019b1b20]         BOOTMEM
[    0.000000]   #41 [00019b1b40 - 00019b1b7c]         BOOTMEM
[    0.000000]   #42 [00019b1b80 - 00019b1bbc]         BOOTMEM
[    0.000000]   #43 [0001a00000 - 0001a1b000]         BOOTMEM
[    0.000000]   #44 [0001a40000 - 0001a5b000]         BOOTMEM
[    0.000000]   #45 [0001a80000 - 0001a9b000]         BOOTMEM
[    0.000000]   #46 [0001ac0000 - 0001adb000]         BOOTMEM
[    0.000000]   #47 [0001b00000 - 0001b1b000]         BOOTMEM
[    0.000000]   #48 [0001b40000 - 0001b5b000]         BOOTMEM
[    0.000000]   #49 [0001b80000 - 0001b9b000]         BOOTMEM
[    0.000000]   #50 [0001bc0000 - 0001bdb000]         BOOTMEM
[    0.000000]   #51 [00019b1bc0 - 00019b1bc8]         BOOTMEM
[    0.000000]   #52 [00019b1c00 - 00019b1c08]         BOOTMEM
[    0.000000]   #53 [00019b1c40 - 00019b1c60]         BOOTMEM
[    0.000000]   #54 [00019b1c80 - 00019b1cc0]         BOOTMEM
[    0.000000]   #55 [00019b1cc0 - 00019b1de0]         BOOTMEM
[    0.000000]   #56 [00019b1e00 - 00019b1e48]         BOOTMEM
[    0.000000]   #57 [00019b1e80 - 00019b1ec8]         BOOTMEM
[    0.000000]   #58 [00019b3000 - 00019bb000]         BOOTMEM
[    0.000000]   #59 [0001d82000 - 0005d82000]         BOOTMEM
[    0.000000]   #60 [00019bb000 - 00019db000]         BOOTMEM
[    0.000000]   #61 [0001bdb000 - 0001c1b000]         BOOTMEM
[    0.000000]   #62 [000001d800 - 0000025800]         BOOTMEM
[    0.000000] Memory: 6044256k/7274496k available (5673k kernel code, 1051036k absent, 179204k reserved, 2458k data, 844k init)
[    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] 	Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:4352 nr_irqs:744
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 62914560 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2394.073 MHz processor.
[    0.001008] Calibrating delay loop (skipped), value calculated using timer frequency.. 4788.14 BogoMIPS (lpj=2394073)
[    0.001017] pid_max: default: 32768 minimum: 301
[    0.001045] Security Framework initialized
[    0.001067] AppArmor: AppArmor initialized
[    0.002032] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.008112] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.011073] Mount-cache hash table entries: 256
[    0.011254] Initializing cgroup subsys ns
[    0.011263] Initializing cgroup subsys cpuacct
[    0.011268] Initializing cgroup subsys memory
[    0.011280] Initializing cgroup subsys devices
[    0.011285] Initializing cgroup subsys freezer
[    0.011289] Initializing cgroup subsys net_cls
[    0.011326] CPU: Physical Processor ID: 0
[    0.011330] CPU: Processor Core ID: 0
[    0.011334] mce: CPU supports 6 MCE banks
[    0.011344] CPU0: Thermal monitoring enabled (TM2)
[    0.011351] using mwait in idle threads.
[    0.011354] Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
[    0.011363] PEBS disabled due to CPU errata.
[    0.011369] ... version:                2
[    0.011372] ... bit width:              40
[    0.011375] ... generic registers:      2
[    0.011379] ... value mask:             000000ffffffffff
[    0.011382] ... max period:             000000007fffffff
[    0.011386] ... fixed-purpose events:   3
[    0.011390] ... event mask:             0000000700000003
[    0.011427] SMP alternatives: switching to UP code
[    0.017801] ACPI: Core revision 20100702
[    0.095881] ftrace: converting mcount calls to 0f 1f 44 00 00
[    0.095890] ftrace: allocating 21373 entries in 84 pages
[    0.097048] Setting APIC routing to flat
[    0.097363] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.107891] CPU0: Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz stepping 0b
[    0.109102] Brought up 1 CPUs
[    0.109108] Total of 1 processors activated (4788.14 BogoMIPS).
[    0.109212] devtmpfs: initialized
[    0.110002] regulator: core version 0.5
[    0.110028] Time: 14:17:48  Date: 12/07/10
[    0.110064] NET: Registered protocol family 16
[    0.110156] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.110162] ACPI: bus type pci registered
[    0.110208] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf0000000-0xf3ffffff] (base 0xf0000000)
[    0.110215] PCI: MMCONFIG at [mem 0xf0000000-0xf3ffffff] reserved in E820
[    0.119021] PCI: Using configuration type 1 for base access
[    0.119626] bio: create slab <bio-0> at 0
[    0.120152] ACPI: EC: Look up EC in DSDT
[    0.137271] ACPI: BIOS _OSI(Linux) query ignored
[    0.148297] ACPI: Interpreter enabled
[    0.148302] ACPI: (supports S0 S1 S3 S4 S5)
[    0.148322] ACPI: Using IOAPIC for interrupt routing
[    0.217853] ACPI: No dock devices found.
[    0.217859] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.222593] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.232181] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
[    0.232187] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
[    0.232192] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.232197] pci_root PNP0A03:00: host bridge window [mem 0x000c0000-0x000effff]
[    0.232203] pci_root PNP0A03:00: host bridge window [mem 0x000f0000-0x000fffff]
[    0.232208] pci_root PNP0A03:00: host bridge window [mem 0xf4000000-0xfec00000]
[    0.232213] pci_root PNP0A03:00: host bridge window [mem 0xbff00000-0xefffffff]
[    0.232219] pci_root PNP0A03:00: host bridge window [mem 0xff980800-0xff980bff]
[    0.232224] pci_root PNP0A03:00: host bridge window [mem 0xff97c000-0xff97ffff]
[    0.232229] pci_root PNP0A03:00: host bridge window [mem 0xfed20000-0xfed9ffff]
[    0.232298] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.232301] pci 0000:00:01.0: PME# disabled
[    0.232385] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.232388] pci 0000:00:1c.0: PME# disabled
[    0.232455] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.232459] pci 0000:00:1c.4: PME# disabled
[    0.232524] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    0.232527] pci 0000:00:1c.5: PME# disabled
[    0.232579] pci 0000:00:1d.0: reg 20: [io  0xff80-0xff9f]
[    0.232639] pci 0000:00:1d.1: reg 20: [io  0xff60-0xff7f]
[    0.232699] pci 0000:00:1d.2: reg 20: [io  0xff40-0xff5f]
[    0.232759] pci 0000:00:1d.3: reg 20: [io  0xff20-0xff3f]
[    0.232808] pci 0000:00:1d.7: reg 10: [mem 0xff980800-0xff980bff]
[    0.232870] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.232874] pci 0000:00:1d.7: PME# disabled
[    0.233065] pci 0000:00:1f.0: quirk: [io  0x0800-0x087f] claimed by ICH6 ACPI/GPIO/TCO
[    0.233072] pci 0000:00:1f.0: quirk: [io  0x0880-0x08bf] claimed by ICH6 GPIO
[    0.233078] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0c00 (mask 007f)
[    0.233085] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 00e0 (mask 0007)
[    0.233128] pci 0000:00:1f.1: reg 10: [io  0x01f0-0x01f7]
[    0.233136] pci 0000:00:1f.1: reg 14: [io  0x03f4-0x03f7]
[    0.233144] pci 0000:00:1f.1: reg 18: [io  0x0170-0x0177]
[    0.233152] pci 0000:00:1f.1: reg 1c: [io  0x0374-0x0377]
[    0.233161] pci 0000:00:1f.1: reg 20: [io  0xffa0-0xffaf]
[    0.233203] pci 0000:00:1f.2: reg 10: [io  0xfe00-0xfe07]
[    0.233210] pci 0000:00:1f.2: reg 14: [io  0xfe10-0xfe13]
[    0.233218] pci 0000:00:1f.2: reg 18: [io  0xfe20-0xfe27]
[    0.233225] pci 0000:00:1f.2: reg 1c: [io  0xfe30-0xfe33]
[    0.233232] pci 0000:00:1f.2: reg 20: [io  0xfec0-0xfecf]
[    0.233239] pci 0000:00:1f.2: reg 24: [mem 0xff970000-0xff9703ff]
[    0.233263] pci 0000:00:1f.2: PME# supported from D3hot
[    0.233266] pci 0000:00:1f.2: PME# disabled
[    0.233324] pci 0000:00:1f.3: reg 20: [io  0xece0-0xecff]
[    0.233392] pci 0000:01:00.0: reg 10: [mem 0xfb000000-0xfbffffff]
[    0.233402] pci 0000:01:00.0: reg 14: [mem 0xc0000000-0xdfffffff 64bit pref]
[    0.233412] pci 0000:01:00.0: reg 1c: [mem 0xfc000000-0xfdffffff 64bit]
[    0.233419] pci 0000:01:00.0: reg 24: [io  0xdc80-0xdcff]
[    0.233426] pci 0000:01:00.0: reg 30: [mem 0xfaf00000-0xfaf7ffff pref]
[    0.233458] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.233463] pci 0000:00:01.0:   bridge window [io  0xd000-0xdfff]
[    0.233465] pci 0000:00:01.0:   bridge window [mem 0xfaf00000-0xfdffffff]
[    0.233469] pci 0000:00:01.0:   bridge window [mem 0xc0000000-0xdfffffff 64bit pref]
[    0.233547] pci 0000:02:00.0: reg 10: [mem 0xfadfbf80-0xfadfbfff 64bit]
[    0.233567] pci 0000:02:00.0: reg 18: [mem 0xfadfc000-0xfadfffff 64bit]
[    0.233580] pci 0000:02:00.0: reg 20: [io  0xcc80-0xccff]
[    0.233605] pci 0000:02:00.0: reg 30: [mem 0xfae00000-0xfae7ffff pref]
[    0.233643] pci 0000:02:00.0: supports D1 D2
[    0.233663] pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.233670] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.233675] pci 0000:00:1c.0:   bridge window [io  0xc000-0xcfff]
[    0.233679] pci 0000:00:1c.0:   bridge window [mem 0xfad00000-0xfaefffff]
[    0.233684] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.233719] pci 0000:00:1c.4: PCI bridge to [bus 03-03]
[    0.233725] pci 0000:00:1c.4:   bridge window [io  0xf000-0x0000] (disabled)
[    0.233729] pci 0000:00:1c.4:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.233734] pci 0000:00:1c.4:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.233811] pci 0000:04:00.0: reg 10: [mem 0xfacf0000-0xfacfffff 64bit]
[    0.233902] pci 0000:04:00.0: PME# supported from D3hot D3cold
[    0.233907] pci 0000:04:00.0: PME# disabled
[    0.233927] pci 0000:00:1c.5: PCI bridge to [bus 04-04]
[    0.233932] pci 0000:00:1c.5:   bridge window [io  0xf000-0x0000] (disabled)
[    0.233936] pci 0000:00:1c.5:   bridge window [mem 0xfac00000-0xfacfffff]
[    0.233941] pci 0000:00:1c.5:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.233987] pci 0000:05:02.0: reg 10: [io  0xbcc0-0xbcff]
[    0.234050] pci 0000:05:02.0: supports D1 D2
[    0.234078] pci 0000:05:02.1: reg 10: [io  0xbcb8-0xbcbf]
[    0.234138] pci 0000:05:02.1: supports D1 D2
[    0.234168] pci 0000:05:02.2: reg 10: [mem 0xfabeb800-0xfabebfff]
[    0.234177] pci 0000:05:02.2: reg 14: [mem 0xfabec000-0xfabeffff]
[    0.234233] pci 0000:05:02.2: supports D1 D2
[    0.234234] pci 0000:05:02.2: PME# supported from D0 D1 D2 D3hot
[    0.234238] pci 0000:05:02.2: PME# disabled
[    0.234277] pci 0000:05:04.0: reg 10: [mem 0xf7000000-0xf7ffffff]
[    0.234366] pci 0000:05:04.1: reg 10: [mem 0xf8000000-0xf8ffffff]
[    0.234450] pci 0000:05:04.2: reg 10: [mem 0xf9000000-0xf9ffffff]
[    0.234542] pci 0000:05:05.0: reg 10: [mem 0xfabf0000-0xfabfffff]
[    0.234638] pci 0000:00:1e.0: PCI bridge to [bus 05-05] (subtractive decode)
[    0.234644] pci 0000:00:1e.0:   bridge window [io  0xb000-0xbfff]
[    0.234648] pci 0000:00:1e.0:   bridge window [mem 0xf7000000-0xfabfffff]
[    0.234653] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.234655] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.234657] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.234659] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.234661] pci 0000:00:1e.0:   bridge window [mem 0x000c0000-0x000effff] (subtractive decode)
[    0.234664] pci 0000:00:1e.0:   bridge window [mem 0x000f0000-0x000fffff] (subtractive decode)
[    0.234666] pci 0000:00:1e.0:   bridge window [mem 0xf4000000-0xfec00000] (subtractive decode)
[    0.234668] pci 0000:00:1e.0:   bridge window [mem 0xbff00000-0xefffffff] (subtractive decode)
[    0.234670] pci 0000:00:1e.0:   bridge window [mem 0xff980800-0xff980bff] (subtractive decode)
[    0.234673] pci 0000:00:1e.0:   bridge window [mem 0xff97c000-0xff97ffff] (subtractive decode)
[    0.234675] pci 0000:00:1e.0:   bridge window [mem 0xfed20000-0xfed9ffff] (subtractive decode)
[    0.234694] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.235006] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI4._PRT]
[    0.235280] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI2._PRT]
[    0.235500] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
[    0.235660] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI5._PRT]
[    0.235826] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI6._PRT]
[    0.836451] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 15)
[    0.836801] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 *10 11 12 15)
[    0.837197] ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 5 6 7 9 10 11 12 15)
[    0.837557] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *9 10 11 12 15)
[    0.837916] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 7 9 10 11 12 15)
[    0.838314] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 *9 10 11 12 15)
[    0.838662] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 7 9 10 11 12 15)
[    0.839038] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 *10 11 12 15)
[    0.839131] HEST: Table is not found!
[    0.839180] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.839188] vgaarb: loaded
[    0.839304] SCSI subsystem initialized
[    0.839325] libata version 3.00 loaded.
[    0.839362] usbcore: registered new interface driver usbfs
[    0.839373] usbcore: registered new interface driver hub
[    0.839396] usbcore: registered new device driver usb
[    0.839491] ACPI: WMI: Mapper loaded
[    0.839495] PCI: Using ACPI for IRQ routing
[    0.839499] PCI: pci_cache_line_size set to 64 bytes
[    0.839523] pci 0000:00:1f.2: no compatible bridge window for [mem 0xff970000-0xff9703ff]
[    0.839579] Expanded resource reserved due to conflict with PCI Bus 0000:00
[    0.839583] Expanded resource reserved due to conflict with PCI Bus 0000:00
[    0.839588] reserve RAM buffer: 000000000009fc00 - 000000000009ffff 
[    0.839590] reserve RAM buffer: 00000000bfe0ac00 - 00000000bfffffff 
[    0.839660] NetLabel: Initializing
[    0.839664] NetLabel:  domain hash size = 128
[    0.839667] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.839682] NetLabel:  unlabeled traffic allowed by default
[    0.839707] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.839714] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.839721] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.843021] Switching to clocksource tsc
[    0.848816] AppArmor: AppArmor Filesystem Enabled
[    0.848836] pnp: PnP ACPI init
[    0.848855] ACPI: bus type pnp registered
[    0.856450] pnp 00:01: disabling [io  0x0800-0x085f] because it overlaps 0000:00:1f.0 BAR 13 [io  0x0800-0x087f]
[    0.856459] pnp 00:01: disabling [io  0x0860-0x08ff] because it overlaps 0000:00:1f.0 BAR 13 [io  0x0800-0x087f]
[    0.888183] pnp: PnP ACPI: found 13 devices
[    0.888188] ACPI: ACPI bus type pnp unregistered
[    0.888199] system 00:01: [io  0x0c00-0x0c7f] has been reserved
[    0.888208] system 00:0a: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.888214] system 00:0a: [mem 0x00100000-0x00ffffff] could not be reserved
[    0.888219] system 00:0a: [mem 0x01000000-0xbfe0abff] could not be reserved
[    0.888224] system 00:0a: [mem 0x000f0000-0x000fffff] could not be reserved
[    0.888229] system 00:0a: [mem 0x000c0000-0x000d3fff] has been reserved
[    0.888234] system 00:0a: [mem 0xfec00000-0xfecfffff] could not be reserved
[    0.888239] system 00:0a: [mem 0xfee00000-0xfeefffff] has been reserved
[    0.888244] system 00:0a: [mem 0xffb00000-0xffbfffff] has been reserved
[    0.888249] system 00:0a: [mem 0xffc00000-0xffffffff] has been reserved
[    0.888255] system 00:0b: [mem 0xf0000000-0xf3ffffff] has been reserved
[    0.888264] system 00:0b: [mem 0xfeda0000-0xfedacfff] has been reserved
[    0.893966] pci 0000:00:1c.0: BAR 15: assigned [mem 0xf4000000-0xf41fffff 64bit pref]
[    0.893977] pci 0000:00:1c.4: BAR 14: assigned [mem 0xf4200000-0xf43fffff]
[    0.893983] pci 0000:00:1c.4: BAR 15: assigned [mem 0xf4400000-0xf45fffff 64bit pref]
[    0.893989] pci 0000:00:1c.5: BAR 15: assigned [mem 0xf4600000-0xf47fffff 64bit pref]
[    0.893995] pci 0000:00:1c.4: BAR 13: assigned [io  0x1000-0x1fff]
[    0.894000] pci 0000:00:1c.5: BAR 13: assigned [io  0x2000-0x2fff]
[    0.894005] pci 0000:00:1f.2: BAR 5: assigned [mem 0xf4800000-0xf48003ff]
[    0.894012] pci 0000:00:1f.2: BAR 5: set to [mem 0xf4800000-0xf48003ff] (PCI address [0xf4800000-0xf48003ff]
[    0.894019] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.894023] pci 0000:00:01.0:   bridge window [io  0xd000-0xdfff]
[    0.894029] pci 0000:00:01.0:   bridge window [mem 0xfaf00000-0xfdffffff]
[    0.894034] pci 0000:00:01.0:   bridge window [mem 0xc0000000-0xdfffffff 64bit pref]
[    0.894041] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.894046] pci 0000:00:1c.0:   bridge window [io  0xc000-0xcfff]
[    0.894053] pci 0000:00:1c.0:   bridge window [mem 0xfad00000-0xfaefffff]
[    0.894059] pci 0000:00:1c.0:   bridge window [mem 0xf4000000-0xf41fffff 64bit pref]
[    0.894067] pci 0000:00:1c.4: PCI bridge to [bus 03-03]
[    0.894072] pci 0000:00:1c.4:   bridge window [io  0x1000-0x1fff]
[    0.894078] pci 0000:00:1c.4:   bridge window [mem 0xf4200000-0xf43fffff]
[    0.894084] pci 0000:00:1c.4:   bridge window [mem 0xf4400000-0xf45fffff 64bit pref]
[    0.894093] pci 0000:00:1c.5: PCI bridge to [bus 04-04]
[    0.894098] pci 0000:00:1c.5:   bridge window [io  0x2000-0x2fff]
[    0.894104] pci 0000:00:1c.5:   bridge window [mem 0xfac00000-0xfacfffff]
[    0.894110] pci 0000:00:1c.5:   bridge window [mem 0xf4600000-0xf47fffff 64bit pref]
[    0.894119] pci 0000:00:1e.0: PCI bridge to [bus 05-05]
[    0.894124] pci 0000:00:1e.0:   bridge window [io  0xb000-0xbfff]
[    0.894131] pci 0000:00:1e.0:   bridge window [mem 0xf7000000-0xfabfffff]
[    0.894136] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    0.894149]   alloc irq_desc for 16 on node -1
[    0.894151]   alloc kstat_irqs on node -1
[    0.894157] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.894163] pci 0000:00:01.0: setting latency timer to 64
[    0.894170] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.894176] pci 0000:00:1c.0: setting latency timer to 64
[    0.894183] pci 0000:00:1c.4: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.894189] pci 0000:00:1c.4: setting latency timer to 64
[    0.894196]   alloc irq_desc for 17 on node -1
[    0.894197]   alloc kstat_irqs on node -1
[    0.894200] pci 0000:00:1c.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.894206] pci 0000:00:1c.5: setting latency timer to 64
[    0.894212] pci 0000:00:1e.0: setting latency timer to 64
[    0.894215] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.894217] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.894219] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.894221] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000effff]
[    0.894223] pci_bus 0000:00: resource 8 [mem 0x000f0000-0x000fffff]
[    0.894225] pci_bus 0000:00: resource 9 [mem 0xf4000000-0xfec00000]
[    0.894227] pci_bus 0000:00: resource 10 [mem 0xbff00000-0xefffffff]
[    0.894229] pci_bus 0000:00: resource 11 [mem 0xff980800-0xff980bff]
[    0.894231] pci_bus 0000:00: resource 12 [mem 0xff97c000-0xff97ffff]
[    0.894233] pci_bus 0000:00: resource 13 [mem 0xfed20000-0xfed9ffff]
[    0.894235] pci_bus 0000:01: resource 0 [io  0xd000-0xdfff]
[    0.894237] pci_bus 0000:01: resource 1 [mem 0xfaf00000-0xfdffffff]
[    0.894239] pci_bus 0000:01: resource 2 [mem 0xc0000000-0xdfffffff 64bit pref]
[    0.894241] pci_bus 0000:02: resource 0 [io  0xc000-0xcfff]
[    0.894243] pci_bus 0000:02: resource 1 [mem 0xfad00000-0xfaefffff]
[    0.894245] pci_bus 0000:02: resource 2 [mem 0xf4000000-0xf41fffff 64bit pref]
[    0.894247] pci_bus 0000:03: resource 0 [io  0x1000-0x1fff]
[    0.894248] pci_bus 0000:03: resource 1 [mem 0xf4200000-0xf43fffff]
[    0.894250] pci_bus 0000:03: resource 2 [mem 0xf4400000-0xf45fffff 64bit pref]
[    0.894253] pci_bus 0000:04: resource 0 [io  0x2000-0x2fff]
[    0.894254] pci_bus 0000:04: resource 1 [mem 0xfac00000-0xfacfffff]
[    0.894256] pci_bus 0000:04: resource 2 [mem 0xf4600000-0xf47fffff 64bit pref]
[    0.894259] pci_bus 0000:05: resource 0 [io  0xb000-0xbfff]
[    0.894260] pci_bus 0000:05: resource 1 [mem 0xf7000000-0xfabfffff]
[    0.894262] pci_bus 0000:05: resource 4 [io  0x0000-0x0cf7]
[    0.894264] pci_bus 0000:05: resource 5 [io  0x0d00-0xffff]
[    0.894266] pci_bus 0000:05: resource 6 [mem 0x000a0000-0x000bffff]
[    0.894268] pci_bus 0000:05: resource 7 [mem 0x000c0000-0x000effff]
[    0.894270] pci_bus 0000:05: resource 8 [mem 0x000f0000-0x000fffff]
[    0.894272] pci_bus 0000:05: resource 9 [mem 0xf4000000-0xfec00000]
[    0.894274] pci_bus 0000:05: resource 10 [mem 0xbff00000-0xefffffff]
[    0.894276] pci_bus 0000:05: resource 11 [mem 0xff980800-0xff980bff]
[    0.894277] pci_bus 0000:05: resource 12 [mem 0xff97c000-0xff97ffff]
[    0.894279] pci_bus 0000:05: resource 13 [mem 0xfed20000-0xfed9ffff]
[    0.894309] NET: Registered protocol family 2
[    0.894502] IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.895721] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.901040] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.901744] TCP: Hash tables configured (established 524288 bind 65536)
[    0.901749] TCP reno registered
[    0.901765] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    0.901866] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    0.902105] NET: Registered protocol family 1
[    0.902249] pci 0000:01:00.0: Boot video device
[    0.902271] PCI: CLS 64 bytes, default 64
[    0.902323] Trying to unpack rootfs image as initramfs...
[    1.218783] Freeing initrd memory: 16324k freed
[    1.224822] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    1.224836] Placing 64MB software IO TLB between ffff880001d82000 - ffff880005d82000
[    1.224841] software IO TLB at phys 0x1d82000 - 0x5d82000
[    1.224898] Simple Boot Flag at 0x7a set to 0x80
[    1.225076] Scanning for low memory corruption every 60 seconds
[    1.225255] audit: initializing netlink socket (disabled)
[    1.225273] type=2000 audit(1291731469.224:1): initialized
[    1.232817] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.233922] VFS: Disk quotas dquot_6.5.2
[    1.233973] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.234454] fuse init (API version 7.15)
[    1.234525] msgmni has been set to 11837
[    1.234698] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    1.234705] io scheduler noop registered
[    1.234708] io scheduler deadline registered
[    1.234740] io scheduler cfq registered (default)
[    1.234870] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.234893] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.236416] vesafb: framebuffer at 0xfd000000, mapped to 0xffffc90005800000, using 10240k, total 14336k
[    1.236423] vesafb: mode is 1280x1024x32, linelength=5120, pages=1
[    1.236427] vesafb: scrolling: redraw
[    1.236431] vesafb: Truecolor: size=8:8:8:8, shift=24:16:8:0
[    1.286098] Console: switching to colour frame buffer device 160x64
[    1.332406] fb0: VESA VGA frame buffer device
[    1.332697] ACPI: button loading
[    1.332879] ACPI: hid: <PNP0C0C>
[    1.333065] ACPI: name: <>
[    1.333217] ACPI: class: <>
[    1.333406] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    1.333880] ACPI: Power Button [VBTN]
[    1.334101] ACPI: button loading
[    1.334283] ACPI: hid: <LNXPWRBN>
[    1.334469] ACPI: name: <>
[    1.334621] ACPI: class: <>
[    1.334805] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    1.335226] ACPI: Power Button [PWRF]
[    1.335965] ACPI: acpi_idle registered with cpuidle

