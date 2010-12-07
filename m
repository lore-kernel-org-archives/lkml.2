Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638Ab0LGAWO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 19:22:14 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62946 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705Ab0LGAWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 19:22:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=EDG8n7DZPn+wM3BcyeHVSPDeNKaBaZXOveQebNmzJINxwT5ku1RF2ekysEC85m3cab
         1J1Mca+Uc1pqqYSOQwIoRfwMLxFRrOoJvEwQqtb6O2jk1JMMOg618Lpc8rQRqjCc9kI2
         dIIql//Wa+yQWjdaCC6Zm2K2pNdCwQJPyDZCg=
Subject: Re: acpi_button: random oops on boot
From: Tobias Karnat <tobias.karnat@googlemail.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-acpi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        richard.coe@med.ge.com, jslaby@novell.com
In-Reply-To: <1291679699.6246.11.camel@Tobias-Karnat>
References: <1291477752.5096.27.camel@Tobias-Karnat>
	 <201012060928.11307.bjorn.helgaas@hp.com>
	 <1291676503.24968.25.camel@Tobias-Karnat>
	 <201012061626.45962.bjorn.helgaas@hp.com>
	 <1291679699.6246.11.camel@Tobias-Karnat>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Dec 2010 01:22:01 +0100
Message-ID: <1291681321.6246.20.camel@Tobias-Karnat>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, den 07.12.2010, 00:54 +0100 schrieb Tobias Karnat:
> > The acpi_button driver has a fairly complicated add() method.
> > In the absence of a better idea, I might just comment out blocks
> > of it and try to isolate the problem.  For example, take out
> > all the input stuff, take out the wakeup GPE stuff, take out
> > the type/name setup, etc.
> 
> Couldn't this be a compiler issue?
> Adding some printk's to fix it seems to be insane.

Just in case, here is some more info;

-Tobias

description: Tower Computer
product: Precision WorkStation 390
vendor: Dell Inc.
serial: 6WTSG3J
width: 64 bits
capabilities: smbios-2.3 dmi-2.3 vsyscall64 vsyscall32
configuration: administrator_password=enabled boot=normal chassis=tower power-on_password=enabled uuid=44454C4C-5700-1054-8053-B6C04F47334A

*-core
description: Motherboard
product: 0DN075
vendor: Dell Inc.
physical id: 0
serial: ..CN708217BE90AO.

*-firmware
description: BIOS
vendor: Dell Inc.
physical id: 0
version: 2.6.0 (05/19/2008)
size: 64KiB
capacity: 960KiB
capabilities: pci pnp apm upgrade shadowing cdboot bootselect edd int13floppytoshiba int5printscreen int9keyboard int14serial int17printer acpi usb ls120boot biosbootspecification netboot

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.36.1 (root@Tobias-Karnat) (gcc version 4.4.5 (Ubuntu/Linaro 4.4.4-14ubuntu5) ) #1 SMP PREEMPT Sat Dec 4 15:09:10 CET 2010
[    0.000000] Command line: root=/dev/md1 ro splash vga=795
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
[    0.000000] On node 0 totalpages: 1555865
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3927 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 767554 pages, LIFO batch:31
[    0.000000]   Normal zone: 10528 pages used for memmap
[    0.000000]   Normal zone: 759520 pages, LIFO batch:31
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
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1531001
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: root=/dev/md1 ro splash vga=795
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
[    0.000000]   #41 [00019b1b40 - 00019b1b60]         BOOTMEM
[    0.000000]   #42 [00019b1b80 - 00019b1ba0]         BOOTMEM
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
[    0.000000] Detected 2394.242 MHz processor.
[    0.001007] Calibrating delay loop (skipped), value calculated using timer frequency.. 4788.48 BogoMIPS (lpj=2394242)
[    0.001016] pid_max: default: 32768 minimum: 301
[    0.001043] Security Framework initialized
[    0.001064] AppArmor: AppArmor initialized
[    0.001805] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.007706] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.010515] Mount-cache hash table entries: 256
[    0.010689] Initializing cgroup subsys ns
[    0.010697] Initializing cgroup subsys cpuacct
[    0.010703] Initializing cgroup subsys memory
[    0.010715] Initializing cgroup subsys devices
[    0.010719] Initializing cgroup subsys freezer
[    0.010723] Initializing cgroup subsys net_cls
[    0.010760] CPU: Physical Processor ID: 0
[    0.010764] CPU: Processor Core ID: 0
[    0.010768] mce: CPU supports 6 MCE banks
[    0.010777] CPU0: Thermal monitoring enabled (TM2)
[    0.010784] using mwait in idle threads.
[    0.010787] Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
[    0.010796] PEBS disabled due to CPU errata.
[    0.010802] ... version:                2
[    0.010805] ... bit width:              40
[    0.010808] ... generic registers:      2
[    0.010812] ... value mask:             000000ffffffffff
[    0.010815] ... max period:             000000007fffffff
[    0.010819] ... fixed-purpose events:   3
[    0.010822] ... event mask:             0000000700000003
[    0.011747] ACPI: Core revision 20100702
[    0.089008] ftrace: converting mcount calls to 0f 1f 44 00 00
[    0.089016] ftrace: allocating 21373 entries in 84 pages
[    0.090050] Setting APIC routing to flat
[    0.090360] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.101053] CPU0: Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz stepping 0b
[    0.105019] Booting Node   0, Processors  #1 #2 #3
[    0.323008] Brought up 4 CPUs
[    0.323014] Total of 4 processors activated (19152.69 BogoMIPS).
[    0.324055] devtmpfs: initialized
[    0.325643] regulator: core version 0.5
[    0.325667] Time: 21:26:37  Date: 12/06/10
[    0.325700] NET: Registered protocol family 16
[    0.325798] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.325805] ACPI: bus type pci registered
[    0.325853] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf0000000-0xf3ffffff] (base 0xf0000000)
[    0.325860] PCI: MMCONFIG at [mem 0xf0000000-0xf3ffffff] reserved in E820
[    0.335731] PCI: Using configuration type 1 for base access
[    0.336355] bio: create slab <bio-0> at 0
[    0.337178] ACPI: EC: Look up EC in DSDT
[    0.354269] ACPI: BIOS _OSI(Linux) query ignored
[    0.365798] ACPI: Interpreter enabled
[    0.365807] ACPI: (supports S0 S1 S3 S4 S5)
[    0.366019] ACPI: Using IOAPIC for interrupt routing
[    0.436126] ACPI: No dock devices found.
[    0.436131] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.441022] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.450587] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
[    0.450594] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
[    0.450599] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.450605] pci_root PNP0A03:00: host bridge window [mem 0x000c0000-0x000effff]
[    0.450610] pci_root PNP0A03:00: host bridge window [mem 0x000f0000-0x000fffff]
[    0.450616] pci_root PNP0A03:00: host bridge window [mem 0xf4000000-0xfec00000]
[    0.450621] pci_root PNP0A03:00: host bridge window [mem 0xbff00000-0xefffffff]
[    0.450627] pci_root PNP0A03:00: host bridge window [mem 0xff980800-0xff980bff]
[    0.450632] pci_root PNP0A03:00: host bridge window [mem 0xff97c000-0xff97ffff]
[    0.450637] pci_root PNP0A03:00: host bridge window [mem 0xfed20000-0xfed9ffff]
[    0.450710] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.450713] pci 0000:00:01.0: PME# disabled
[    0.450799] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.450803] pci 0000:00:1c.0: PME# disabled
[    0.451004] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.451008] pci 0000:00:1c.4: PME# disabled
[    0.451096] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    0.451099] pci 0000:00:1c.5: PME# disabled
[    0.451153] pci 0000:00:1d.0: reg 20: [io  0xff80-0xff9f]
[    0.451214] pci 0000:00:1d.1: reg 20: [io  0xff60-0xff7f]
[    0.451276] pci 0000:00:1d.2: reg 20: [io  0xff40-0xff5f]
[    0.451337] pci 0000:00:1d.3: reg 20: [io  0xff20-0xff3f]
[    0.451387] pci 0000:00:1d.7: reg 10: [mem 0xff980800-0xff980bff]
[    0.451451] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.451455] pci 0000:00:1d.7: PME# disabled
[    0.451593] pci 0000:00:1f.0: quirk: [io  0x0800-0x087f] claimed by ICH6 ACPI/GPIO/TCO
[    0.451601] pci 0000:00:1f.0: quirk: [io  0x0880-0x08bf] claimed by ICH6 GPIO
[    0.451607] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0c00 (mask 007f)
[    0.451614] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 00e0 (mask 0007)
[    0.451657] pci 0000:00:1f.1: reg 10: [io  0x01f0-0x01f7]
[    0.451666] pci 0000:00:1f.1: reg 14: [io  0x03f4-0x03f7]
[    0.451674] pci 0000:00:1f.1: reg 18: [io  0x0170-0x0177]
[    0.451683] pci 0000:00:1f.1: reg 1c: [io  0x0374-0x0377]
[    0.451691] pci 0000:00:1f.1: reg 20: [io  0xffa0-0xffaf]
[    0.451735] pci 0000:00:1f.2: reg 10: [io  0xfe00-0xfe07]
[    0.451742] pci 0000:00:1f.2: reg 14: [io  0xfe10-0xfe13]
[    0.451750] pci 0000:00:1f.2: reg 18: [io  0xfe20-0xfe27]
[    0.451757] pci 0000:00:1f.2: reg 1c: [io  0xfe30-0xfe33]
[    0.451765] pci 0000:00:1f.2: reg 20: [io  0xfec0-0xfecf]
[    0.451772] pci 0000:00:1f.2: reg 24: [mem 0xff970000-0xff9703ff]
[    0.451796] pci 0000:00:1f.2: PME# supported from D3hot
[    0.451799] pci 0000:00:1f.2: PME# disabled
[    0.451859] pci 0000:00:1f.3: reg 20: [io  0xece0-0xecff]
[    0.451929] pci 0000:01:00.0: reg 10: [mem 0xfb000000-0xfbffffff]
[    0.451939] pci 0000:01:00.0: reg 14: [mem 0xc0000000-0xdfffffff 64bit pref]
[    0.451950] pci 0000:01:00.0: reg 1c: [mem 0xfc000000-0xfdffffff 64bit]
[    0.451957] pci 0000:01:00.0: reg 24: [io  0xdc80-0xdcff]
[    0.451964] pci 0000:01:00.0: reg 30: [mem 0xfaf00000-0xfaf7ffff pref]
[    0.451997] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.452003] pci 0000:00:01.0:   bridge window [io  0xd000-0xdfff]
[    0.452005] pci 0000:00:01.0:   bridge window [mem 0xfaf00000-0xfdffffff]
[    0.452009] pci 0000:00:01.0:   bridge window [mem 0xc0000000-0xdfffffff 64bit pref]
[    0.452107] pci 0000:02:00.0: reg 10: [mem 0xfadfbf80-0xfadfbfff 64bit]
[    0.452128] pci 0000:02:00.0: reg 18: [mem 0xfadfc000-0xfadfffff 64bit]
[    0.452141] pci 0000:02:00.0: reg 20: [io  0xcc80-0xccff]
[    0.452166] pci 0000:02:00.0: reg 30: [mem 0xfae00000-0xfae7ffff pref]
[    0.452205] pci 0000:02:00.0: supports D1 D2
[    0.452226] pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.452232] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.452238] pci 0000:00:1c.0:   bridge window [io  0xc000-0xcfff]
[    0.452242] pci 0000:00:1c.0:   bridge window [mem 0xfad00000-0xfaefffff]
[    0.452247] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.452284] pci 0000:00:1c.4: PCI bridge to [bus 03-03]
[    0.452290] pci 0000:00:1c.4:   bridge window [io  0xf000-0x0000] (disabled)
[    0.452293] pci 0000:00:1c.4:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.452299] pci 0000:00:1c.4:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.452377] pci 0000:04:00.0: reg 10: [mem 0xfacf0000-0xfacfffff 64bit]
[    0.452471] pci 0000:04:00.0: PME# supported from D3hot D3cold
[    0.452475] pci 0000:04:00.0: PME# disabled
[    0.452495] pci 0000:00:1c.5: PCI bridge to [bus 04-04]
[    0.452501] pci 0000:00:1c.5:   bridge window [io  0xf000-0x0000] (disabled)
[    0.452505] pci 0000:00:1c.5:   bridge window [mem 0xfac00000-0xfacfffff]
[    0.452510] pci 0000:00:1c.5:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.452557] pci 0000:05:02.0: reg 10: [io  0xbcc0-0xbcff]
[    0.452618] pci 0000:05:02.0: supports D1 D2
[    0.452646] pci 0000:05:02.1: reg 10: [io  0xbcb8-0xbcbf]
[    0.452708] pci 0000:05:02.1: supports D1 D2
[    0.452738] pci 0000:05:02.2: reg 10: [mem 0xfabeb800-0xfabebfff]
[    0.452748] pci 0000:05:02.2: reg 14: [mem 0xfabec000-0xfabeffff]
[    0.452805] pci 0000:05:02.2: supports D1 D2
[    0.452806] pci 0000:05:02.2: PME# supported from D0 D1 D2 D3hot
[    0.452810] pci 0000:05:02.2: PME# disabled
[    0.452850] pci 0000:05:04.0: reg 10: [mem 0xf7000000-0xf7ffffff]
[    0.452942] pci 0000:05:04.1: reg 10: [mem 0xf8000000-0xf8ffffff]
[    0.453036] pci 0000:05:04.2: reg 10: [mem 0xf9000000-0xf9ffffff]
[    0.453151] pci 0000:05:05.0: reg 10: [mem 0xfabf0000-0xfabfffff]
[    0.453250] pci 0000:00:1e.0: PCI bridge to [bus 05-05] (subtractive decode)
[    0.453257] pci 0000:00:1e.0:   bridge window [io  0xb000-0xbfff]
[    0.453260] pci 0000:00:1e.0:   bridge window [mem 0xf7000000-0xfabfffff]
[    0.453266] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.453268] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.453270] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.453272] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.453275] pci 0000:00:1e.0:   bridge window [mem 0x000c0000-0x000effff] (subtractive decode)
[    0.453277] pci 0000:00:1e.0:   bridge window [mem 0x000f0000-0x000fffff] (subtractive decode)
[    0.453279] pci 0000:00:1e.0:   bridge window [mem 0xf4000000-0xfec00000] (subtractive decode)
[    0.453281] pci 0000:00:1e.0:   bridge window [mem 0xbff00000-0xefffffff] (subtractive decode)
[    0.453284] pci 0000:00:1e.0:   bridge window [mem 0xff980800-0xff980bff] (subtractive decode)
[    0.453286] pci 0000:00:1e.0:   bridge window [mem 0xff97c000-0xff97ffff] (subtractive decode)
[    0.453288] pci 0000:00:1e.0:   bridge window [mem 0xfed20000-0xfed9ffff] (subtractive decode)
[    0.453308] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.453621] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI4._PRT]
[    0.453894] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI2._PRT]
[    0.454131] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
[    0.454292] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI5._PRT]
[    0.454459] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI6._PRT]
[    1.059122] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 15)
[    1.059486] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 *10 11 12 15)
[    1.059879] ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 5 6 7 9 10 11 12 15)
[    1.060251] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *9 10 11 12 15)
[    1.060612] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 7 9 10 11 12 15)
[    1.061014] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 *9 10 11 12 15)
[    1.061382] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 7 9 10 11 12 15)
[    1.061752] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 *10 11 12 15)
[    1.061846] HEST: Table is not found!
[    1.061901] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    1.061912] vgaarb: loaded
[    1.062037] SCSI subsystem initialized
[    1.062046] libata version 3.00 loaded.
[    1.062067] usbcore: registered new interface driver usbfs
[    1.062079] usbcore: registered new interface driver hub
[    1.062085] usbcore: registered new device driver usb
[    1.062085] ACPI: WMI: Mapper loaded
[    1.062085] PCI: Using ACPI for IRQ routing
[    1.062085] PCI: pci_cache_line_size set to 64 bytes
[    1.062085] pci 0000:00:1f.2: no compatible bridge window for [mem 0xff970000-0xff9703ff]
[    1.062148] Expanded resource reserved due to conflict with PCI Bus 0000:00
[    1.062153] Expanded resource reserved due to conflict with PCI Bus 0000:00
[    1.062158] reserve RAM buffer: 000000000009fc00 - 000000000009ffff 
[    1.062161] reserve RAM buffer: 00000000bfe0ac00 - 00000000bfffffff 
[    1.062234] NetLabel: Initializing
[    1.062238] NetLabel:  domain hash size = 128
[    1.062242] NetLabel:  protocols = UNLABELED CIPSOv4
[    1.062258] NetLabel:  unlabeled traffic allowed by default
[    1.062284] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    1.062291] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    1.062298] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    1.067023] Switching to clocksource tsc
[    1.073614] AppArmor: AppArmor Filesystem Enabled
[    1.073634] pnp: PnP ACPI init
[    1.073652] ACPI: bus type pnp registered
[    1.081217] pnp 00:01: disabling [io  0x0800-0x085f] because it overlaps 0000:00:1f.0 BAR 13 [io  0x0800-0x087f]
[    1.081225] pnp 00:01: disabling [io  0x0860-0x08ff] because it overlaps 0000:00:1f.0 BAR 13 [io  0x0800-0x087f]
[    1.113069] pnp: PnP ACPI: found 13 devices
[    1.113074] ACPI: ACPI bus type pnp unregistered
[    1.113085] system 00:01: [io  0x0c00-0x0c7f] has been reserved
[    1.113095] system 00:0a: [mem 0x00000000-0x0009ffff] could not be reserved
[    1.113101] system 00:0a: [mem 0x00100000-0x00ffffff] could not be reserved
[    1.113106] system 00:0a: [mem 0x01000000-0xbfe0abff] could not be reserved
[    1.113111] system 00:0a: [mem 0x000f0000-0x000fffff] could not be reserved
[    1.113116] system 00:0a: [mem 0x000c0000-0x000d3fff] has been reserved
[    1.113121] system 00:0a: [mem 0xfec00000-0xfecfffff] could not be reserved
[    1.113127] system 00:0a: [mem 0xfee00000-0xfeefffff] has been reserved
[    1.113131] system 00:0a: [mem 0xffb00000-0xffbfffff] has been reserved
[    1.113136] system 00:0a: [mem 0xffc00000-0xffffffff] has been reserved
[    1.113143] system 00:0b: [mem 0xf0000000-0xf3ffffff] has been reserved
[    1.113148] system 00:0b: [mem 0xfeda0000-0xfedacfff] has been reserved
[    1.118967] pci 0000:00:1c.0: BAR 15: assigned [mem 0xf4000000-0xf41fffff 64bit pref]
[    1.118974] pci 0000:00:1c.4: BAR 14: assigned [mem 0xf4200000-0xf43fffff]
[    1.118980] pci 0000:00:1c.4: BAR 15: assigned [mem 0xf4400000-0xf45fffff 64bit pref]
[    1.118987] pci 0000:00:1c.5: BAR 15: assigned [mem 0xf4600000-0xf47fffff 64bit pref]
[    1.118993] pci 0000:00:1c.4: BAR 13: assigned [io  0x1000-0x1fff]
[    1.118998] pci 0000:00:1c.5: BAR 13: assigned [io  0x2000-0x2fff]
[    1.119007] pci 0000:00:1f.2: BAR 5: assigned [mem 0xf4800000-0xf48003ff]
[    1.119014] pci 0000:00:1f.2: BAR 5: set to [mem 0xf4800000-0xf48003ff] (PCI address [0xf4800000-0xf48003ff]
[    1.119021] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    1.119026] pci 0000:00:01.0:   bridge window [io  0xd000-0xdfff]
[    1.119032] pci 0000:00:01.0:   bridge window [mem 0xfaf00000-0xfdffffff]
[    1.119037] pci 0000:00:01.0:   bridge window [mem 0xc0000000-0xdfffffff 64bit pref]
[    1.119045] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    1.119050] pci 0000:00:1c.0:   bridge window [io  0xc000-0xcfff]
[    1.119056] pci 0000:00:1c.0:   bridge window [mem 0xfad00000-0xfaefffff]
[    1.119063] pci 0000:00:1c.0:   bridge window [mem 0xf4000000-0xf41fffff 64bit pref]
[    1.119071] pci 0000:00:1c.4: PCI bridge to [bus 03-03]
[    1.119076] pci 0000:00:1c.4:   bridge window [io  0x1000-0x1fff]
[    1.119083] pci 0000:00:1c.4:   bridge window [mem 0xf4200000-0xf43fffff]
[    1.119089] pci 0000:00:1c.4:   bridge window [mem 0xf4400000-0xf45fffff 64bit pref]
[    1.119098] pci 0000:00:1c.5: PCI bridge to [bus 04-04]
[    1.119103] pci 0000:00:1c.5:   bridge window [io  0x2000-0x2fff]
[    1.119109] pci 0000:00:1c.5:   bridge window [mem 0xfac00000-0xfacfffff]
[    1.119115] pci 0000:00:1c.5:   bridge window [mem 0xf4600000-0xf47fffff 64bit pref]
[    1.119125] pci 0000:00:1e.0: PCI bridge to [bus 05-05]
[    1.119130] pci 0000:00:1e.0:   bridge window [io  0xb000-0xbfff]
[    1.119137] pci 0000:00:1e.0:   bridge window [mem 0xf7000000-0xfabfffff]
[    1.119143] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    1.119156]   alloc irq_desc for 16 on node -1
[    1.119157]   alloc kstat_irqs on node -1
[    1.119163] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.119170] pci 0000:00:01.0: setting latency timer to 64
[    1.119177] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.119183] pci 0000:00:1c.0: setting latency timer to 64
[    1.119190] pci 0000:00:1c.4: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.119196] pci 0000:00:1c.4: setting latency timer to 64
[    1.119203]   alloc irq_desc for 17 on node -1
[    1.119204]   alloc kstat_irqs on node -1
[    1.119208] pci 0000:00:1c.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    1.119214] pci 0000:00:1c.5: setting latency timer to 64
[    1.119220] pci 0000:00:1e.0: setting latency timer to 64
[    1.119223] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    1.119225] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    1.119227] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    1.119229] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000effff]
[    1.119231] pci_bus 0000:00: resource 8 [mem 0x000f0000-0x000fffff]
[    1.119233] pci_bus 0000:00: resource 9 [mem 0xf4000000-0xfec00000]
[    1.119235] pci_bus 0000:00: resource 10 [mem 0xbff00000-0xefffffff]
[    1.119237] pci_bus 0000:00: resource 11 [mem 0xff980800-0xff980bff]
[    1.119239] pci_bus 0000:00: resource 12 [mem 0xff97c000-0xff97ffff]
[    1.119241] pci_bus 0000:00: resource 13 [mem 0xfed20000-0xfed9ffff]
[    1.119244] pci_bus 0000:01: resource 0 [io  0xd000-0xdfff]
[    1.119246] pci_bus 0000:01: resource 1 [mem 0xfaf00000-0xfdffffff]
[    1.119248] pci_bus 0000:01: resource 2 [mem 0xc0000000-0xdfffffff 64bit pref]
[    1.119250] pci_bus 0000:02: resource 0 [io  0xc000-0xcfff]
[    1.119252] pci_bus 0000:02: resource 1 [mem 0xfad00000-0xfaefffff]
[    1.119254] pci_bus 0000:02: resource 2 [mem 0xf4000000-0xf41fffff 64bit pref]
[    1.119256] pci_bus 0000:03: resource 0 [io  0x1000-0x1fff]
[    1.119258] pci_bus 0000:03: resource 1 [mem 0xf4200000-0xf43fffff]
[    1.119260] pci_bus 0000:03: resource 2 [mem 0xf4400000-0xf45fffff 64bit pref]
[    1.119262] pci_bus 0000:04: resource 0 [io  0x2000-0x2fff]
[    1.119264] pci_bus 0000:04: resource 1 [mem 0xfac00000-0xfacfffff]
[    1.119266] pci_bus 0000:04: resource 2 [mem 0xf4600000-0xf47fffff 64bit pref]
[    1.119268] pci_bus 0000:05: resource 0 [io  0xb000-0xbfff]
[    1.119270] pci_bus 0000:05: resource 1 [mem 0xf7000000-0xfabfffff]
[    1.119272] pci_bus 0000:05: resource 4 [io  0x0000-0x0cf7]
[    1.119274] pci_bus 0000:05: resource 5 [io  0x0d00-0xffff]
[    1.119276] pci_bus 0000:05: resource 6 [mem 0x000a0000-0x000bffff]
[    1.119278] pci_bus 0000:05: resource 7 [mem 0x000c0000-0x000effff]
[    1.119280] pci_bus 0000:05: resource 8 [mem 0x000f0000-0x000fffff]
[    1.119282] pci_bus 0000:05: resource 9 [mem 0xf4000000-0xfec00000]
[    1.119284] pci_bus 0000:05: resource 10 [mem 0xbff00000-0xefffffff]
[    1.119286] pci_bus 0000:05: resource 11 [mem 0xff980800-0xff980bff]
[    1.119288] pci_bus 0000:05: resource 12 [mem 0xff97c000-0xff97ffff]
[    1.119290] pci_bus 0000:05: resource 13 [mem 0xfed20000-0xfed9ffff]
[    1.119319] NET: Registered protocol family 2
[    1.119546] IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    1.120886] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    1.126311] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    1.127053] TCP: Hash tables configured (established 524288 bind 65536)
[    1.127059] TCP reno registered
[    1.127077] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    1.127181] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    1.127411] NET: Registered protocol family 1
[    1.127576] pci 0000:01:00.0: Boot video device
[    1.127600] PCI: CLS 64 bytes, default 64
[    1.127657] Trying to unpack rootfs image as initramfs...
[    1.449480] Freeing initrd memory: 16324k freed
[    1.455900] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    1.455915] Placing 64MB software IO TLB between ffff880001d82000 - ffff880005d82000
[    1.455921] software IO TLB at phys 0x1d82000 - 0x5d82000
[    1.455993] Simple Boot Flag at 0x7a set to 0x80
[    1.456311] Scanning for low memory corruption every 60 seconds
[    1.456499] audit: initializing netlink socket (disabled)
[    1.456518] type=2000 audit(1291670798.455:1): initialized
[    1.464116] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.465405] VFS: Disk quotas dquot_6.5.2
[    1.465459] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.466019] fuse init (API version 7.15)
[    1.466103] msgmni has been set to 11837
[    1.466356] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    1.466365] io scheduler noop registered
[    1.466370] io scheduler deadline registered
[    1.466417] io scheduler cfq registered (default)
[    1.466613] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.466633] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.468337] vesafb: framebuffer at 0xfd000000, mapped to 0xffffc90005800000, using 10240k, total 14336k
[    1.468344] vesafb: mode is 1280x1024x32, linelength=5120, pages=1
[    1.468348] vesafb: scrolling: redraw
[    1.468352] vesafb: Truecolor: size=8:8:8:8, shift=24:16:8:0
[    1.518261] Console: switching to colour frame buffer device 160x64
[    1.565302] fb0: VESA VGA frame buffer device
[    1.565597] ACPI: button loading
[    1.565780] ACPI: hid: <PNP0C0C>
[    1.565961] ACPI: name: <>
[    1.566117] ACPI: class: <>
[    1.566310] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    1.566783] ACPI: Power Button [VBTN]
[    1.567007] ACPI: button loading
[    1.567189] ACPI: hid: <LNXPWRBN>
[    1.567375] ACPI: name: <>
[    1.567527] ACPI: class: <>
[    1.567716] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    1.568137] ACPI: Power Button [PWRF]
[    1.568888] ACPI: acpi_idle registered with cpuidle

