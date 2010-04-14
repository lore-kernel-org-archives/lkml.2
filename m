Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531Ab0DNByH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 21:54:07 -0400
Received: from mail-yw0-f198.google.com ([209.85.211.198]:48877 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736Ab0DNByD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 21:54:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:message-id:user-agent
         :mime-version:content-type;
        b=xjCtUdR/+YgBbyOwh6/7gwhZk95zwpJyzUHmZQLQJzrsuXMwYGzBIzvll7BtnQpCJA
         CxcOV8HpPJq60SsEmlKvs1oZpGT9oMzotVcra/RvcAYpvQVLH2PDW36PXIun6IOPaX+T
         6FKeEXzOCkay5uHAosGJYpClFSdnWlmAP71ow=
Date: Tue, 13 Apr 2010 21:53:46 -0400 (EDT)
From: Parag Warudkar <parag.lkml@gmail.com>
X-X-Sender: paragw@parag-laptop
To: linux-kernel@vger.kernel.org
cc: torvalds@linux-foundation.org
Subject: 2.6.34-rc4 : OOPS in unmap_vma
Message-ID: <alpine.DEB.2.00.1004132147260.1881@parag-laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not sure if this is related to the recent mm/vma fixes - got this 
while rebooting (kexec) latest git -

[    0.000000] Linux version 2.6.34-rc4 (paragw@parag-laptop) (gcc version 4.4.3 (Ubuntu 4.4.3-4ubuntu5) ) #19 SMP PREEMPT Tue Apr 13 20:59:37 EDT 2010
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-2.6.34-rc4 root=UUID=0a0bb1b9-978c-4e16-8e43-aae24e172e12 ro quiet splash
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000100 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000ef000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000b8f2f000 (usable)
[    0.000000]  BIOS-e820: 00000000b8f2f000 - 00000000b8f31000 (reserved)
[    0.000000]  BIOS-e820: 00000000b8f31000 - 00000000b9d70000 (usable)
[    0.000000]  BIOS-e820: 00000000b9d70000 - 00000000b9d80000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000b9d80000 - 00000000bc4e0000 (usable)
[    0.000000]  BIOS-e820: 00000000bc4e0000 - 00000000bc6e0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bc6e0000 - 00000000bde92000 (usable)
[    0.000000]  BIOS-e820: 00000000bde92000 - 00000000bde9a000 (reserved)
[    0.000000]  BIOS-e820: 00000000bde9a000 - 00000000bdebf000 (usable)
[    0.000000]  BIOS-e820: 00000000bdebf000 - 00000000bdecf000 (reserved)
[    0.000000]  BIOS-e820: 00000000bdecf000 - 00000000bdfcf000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bdfcf000 - 00000000bdfff000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bdfff000 - 00000000be000000 (usable)
[    0.000000]  BIOS-e820: 00000000be000000 - 00000000c0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed10000 - 00000000fed14000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed18000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffe80000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000140000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x140000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0FFE00000 mask FFFE00000 write-protect
[    0.000000]   1 base 000000000 mask F80000000 write-back
[    0.000000]   2 base 080000000 mask FC0000000 write-back
[    0.000000]   3 base 100000000 mask FC0000000 write-back
[    0.000000]   4 base 0B9D70000 mask FFFFF0000 uncachable
[    0.000000]   5 base 0C0000000 mask FF0000000 write-combining
[    0.000000]   6 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7010600070106, new 0x7010600070106
[    0.000000] last_pfn = 0xbe000 max_arch_pfn = 0x400000000
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000be000000
[    0.000000]  0000000000 - 00be000000 page 2M
[    0.000000] kernel direct mapping tables up to be000000 @ 8000-c000
[    0.000000] init_memory_mapping: 0000000100000000-0000000140000000
[    0.000000]  0100000000 - 0140000000 page 2M
[    0.000000] kernel direct mapping tables up to 140000000 @ a000-10000
[    0.000000] RAMDISK: 7f797000 - 7fff4000
[    0.000000] ACPI: RSDP 00000000000f6970 00024 (v02 HPQOEM)
[    0.000000] ACPI: XSDT 00000000bdffe120 0008C (v01 HPQOEM SLIC-MPC 0000000F      01000013)
[    0.000000] ACPI: FACP 00000000bdffc000 000F4 (v03 HPQOEM 30E7     0000000F HP   00000001)
[    0.000000] ACPI: DSDT 00000000bdfde000 186CB (v01 HPQOEM 30E7     00000001 INTL 20060912)
[    0.000000] ACPI: FACS 00000000bdf9c000 00040
[    0.000000] ACPI: HPET 00000000bdffb000 00038 (v01 HPQOEM 30E7     00000001 HP   00000001)
[    0.000000] ACPI: APIC 00000000bdffa000 00084 (v01 HPQOEM 30E7     00000001 HP   00000001)
[    0.000000] ACPI: MCFG 00000000bdff9000 0003C (v01 HPQOEM 30E7     00000001 HP   00000001)
[    0.000000] ACPI: ASF! 00000000bdff8000 00095 (v32 HPQOEM 30E7     00000001 HP   00000001)
[    0.000000] ACPI: TCPA 00000000bdff7000 00032 (v02 HPQOEM 30E7     00000000 HP   00000001)
[    0.000000] ACPI: SSDT 00000000bdfdb000 003B0 (v01 HPQOEM SataAhci 00001000 INTL 20060912)
[    0.000000] ACPI: SLIC 00000000bdfd9000 00176 (v01 HPQOEM SLIC-MPC 00000001 HP   00000001)
[    0.000000] ACPI: SSDT 00000000bdfd8000 007A1 (v01 HPQOEM   ATIGFX 00000001 INTL 20060912)
[    0.000000] ACPI: DMAR 00000000bdfd5000 000B0 (v01               ? 00000001      00000000)
[    0.000000] ACPI: SSDT 00000000bdfd4000 0066C (v01  PmRef    CpuPm 00003000 INTL 20060912)
[    0.000000] ACPI: SSDT 00000000bdfd3000 00288 (v01  PmRef  Cpu0Tst 00003000 INTL 20060912)
[    0.000000] ACPI: SSDT 00000000bdfd2000 00225 (v01  PmRef    ApTst 00003000 INTL 20060912)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000]  [ffffea0000000000-ffffea00045fffff] PMD -> [ffff880002200000-ffff8800059fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000001 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00140000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[8] active PFN ranges
[    0.000000]     0: 0x00000001 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000b8f2f
[    0.000000]     0: 0x000b8f31 -> 0x000b9d70
[    0.000000]     0: 0x000b9d80 -> 0x000bc4e0
[    0.000000]     0: 0x000bc6e0 -> 0x000bde92
[    0.000000]     0: 0x000bde9a -> 0x000bdebf
[    0.000000]     0: 0x000bdfff -> 0x000be000
[    0.000000]     0: 0x00100000 -> 0x00140000
[    0.000000] On node 0 totalpages: 1039428
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3942 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 759006 pages, LIFO batch:31
[    0.000000]   Normal zone: 3584 pages used for memmap
[    0.000000]   Normal zone: 258560 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] 4 Processors exceeds NR_CPUS limit of 2
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] early_res array is doubled to 64 at [7000 - 77ff]
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000ef000
[    0.000000] PM: Registered nosave memory: 00000000000ef000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000b8f2f000 - 00000000b8f31000
[    0.000000] PM: Registered nosave memory: 00000000b9d70000 - 00000000b9d80000
[    0.000000] PM: Registered nosave memory: 00000000bc4e0000 - 00000000bc6e0000
[    0.000000] PM: Registered nosave memory: 00000000bde92000 - 00000000bde9a000
[    0.000000] PM: Registered nosave memory: 00000000bdebf000 - 00000000bdecf000
[    0.000000] PM: Registered nosave memory: 00000000bdecf000 - 00000000bdfcf000
[    0.000000] PM: Registered nosave memory: 00000000bdfcf000 - 00000000bdfff000
[    0.000000] PM: Registered nosave memory: 00000000be000000 - 00000000c0000000
[    0.000000] PM: Registered nosave memory: 00000000c0000000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f0000000
[    0.000000] PM: Registered nosave memory: 00000000f0000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec01000
[    0.000000] PM: Registered nosave memory: 00000000fec01000 - 00000000fed10000
[    0.000000] PM: Registered nosave memory: 00000000fed10000 - 00000000fed14000
[    0.000000] PM: Registered nosave memory: 00000000fed14000 - 00000000fed18000
[    0.000000] PM: Registered nosave memory: 00000000fed18000 - 00000000fed1a000
[    0.000000] PM: Registered nosave memory: 00000000fed1a000 - 00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed20000
[    0.000000] PM: Registered nosave memory: 00000000fed20000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ffe80000
[    0.000000] PM: Registered nosave memory: 00000000ffe80000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at c0000000 (gap: c0000000:20000000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] early_res array is doubled to 128 at [b000 - bfff]
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff880001c00000 s83368 r8192 d23128 u1048576
[    0.000000] pcpu-alloc: s83368 r8192 d23128 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1021508
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-2.6.34-rc4 root=UUID=0a0bb1b9-978c-4e16-8e43-aae24e172e12 ro quiet splash
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.000000] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.000000] xsave/xrstor: enabled xstate_bv 0x3, cntxt size 0x240
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Subtract (72 early reservations)
[    0.000000]   #1 [0001000000 - 00019efc78]   TEXT DATA BSS
[    0.000000]   #2 [007f797000 - 007fff4000]         RAMDISK
[    0.000000]   #3 [000009fc00 - 0000100000]   BIOS reserved
[    0.000000]   #4 [00019f0000 - 00019f01a0]             BRK
[    0.000000]   #5 [0000001000 - 0000003000]      TRAMPOLINE
[    0.000000]   #6 [0000003000 - 0000007000]     ACPI WAKEUP
[    0.000000]   #7 [0000008000 - 000000a000]         PGTABLE
[    0.000000]   #8 [000000a000 - 000000b000]         PGTABLE
[    0.000000]   #9 [00019f01c0 - 00019f11c0]         BOOTMEM
[    0.000000]   #10 [00019efc80 - 00019eff80]         BOOTMEM
[    0.000000]   #11 [00021f2000 - 00021f3000]         BOOTMEM
[    0.000000]   #12 [00021f3000 - 00021f4000]         BOOTMEM
[    0.000000]   #13 [0002200000 - 0005a00000]        MEMMAP 0
[    0.000000]   #14 [00019f11c0 - 00019f1340]         BOOTMEM
[    0.000000]   #15 [00019f1340 - 0001a09340]         BOOTMEM
[    0.000000]   #16 [0001a09340 - 0001a0f340]         BOOTMEM
[    0.000000]   #17 [0001a10000 - 0001a11000]         BOOTMEM
[    0.000000]   #18 [00019eff80 - 00019effc1]         BOOTMEM
[    0.000000]   #19 [0001a0f340 - 0001a0f383]         BOOTMEM
[    0.000000]   #20 [0001a0f3c0 - 0001a0f970]         BOOTMEM
[    0.000000]   #21 [0001a0f980 - 0001a0f9e8]         BOOTMEM
[    0.000000]   #22 [0001a0fa00 - 0001a0fa68]         BOOTMEM
[    0.000000]   #23 [0001a0fa80 - 0001a0fae8]         BOOTMEM
[    0.000000]   #24 [0001a0fb00 - 0001a0fb68]         BOOTMEM
[    0.000000]   #25 [0001a0fb80 - 0001a0fbe8]         BOOTMEM
[    0.000000]   #26 [0001a0fc00 - 0001a0fc68]         BOOTMEM
[    0.000000]   #27 [0001a0fc80 - 0001a0fce8]         BOOTMEM
[    0.000000]   #28 [0001a0fd00 - 0001a0fd68]         BOOTMEM
[    0.000000]   #29 [0001a0fd80 - 0001a0fde8]         BOOTMEM
[    0.000000]   #30 [0001a0fe00 - 0001a0fe68]         BOOTMEM
[    0.000000]   #31 [0001a0fe80 - 0001a0fee8]         BOOTMEM
[    0.000000]   #32 [0001a0ff00 - 0001a0ff68]         BOOTMEM
[    0.000000]   #33 [0001a0ff80 - 0001a0ffe8]         BOOTMEM
[    0.000000]   #34 [0001a11000 - 0001a11068]         BOOTMEM
[    0.000000]   #35 [0001a11080 - 0001a110e8]         BOOTMEM
[    0.000000]   #36 [0001a11100 - 0001a11168]         BOOTMEM
[    0.000000]   #37 [0001a11180 - 0001a111e8]         BOOTMEM
[    0.000000]   #38 [0001a11200 - 0001a11268]         BOOTMEM
[    0.000000]   #39 [0001a11280 - 0001a112e8]         BOOTMEM
[    0.000000]   #40 [0001a11300 - 0001a11368]         BOOTMEM
[    0.000000]   #41 [0001a11380 - 0001a113e8]         BOOTMEM
[    0.000000]   #42 [0001a11400 - 0001a11468]         BOOTMEM
[    0.000000]   #43 [0001a11480 - 0001a114e8]         BOOTMEM
[    0.000000]   #44 [0001a11500 - 0001a11568]         BOOTMEM
[    0.000000]   #45 [0001a11580 - 0001a115e8]         BOOTMEM
[    0.000000]   #46 [0001a11600 - 0001a11620]         BOOTMEM
[    0.000000]   #47 [0001a11640 - 0001a11660]         BOOTMEM
[    0.000000]   #48 [0001a11680 - 0001a116a0]         BOOTMEM
[    0.000000]   #49 [0001a116c0 - 0001a116e0]         BOOTMEM
[    0.000000]   #50 [0001a11700 - 0001a11720]         BOOTMEM
[    0.000000]   #51 [0001a11740 - 0001a11760]         BOOTMEM
[    0.000000]   #52 [0001a11780 - 0001a117a0]         BOOTMEM
[    0.000000]   #53 [0001a117c0 - 0001a1181e]         BOOTMEM
[    0.000000]   #54 [0001a11840 - 0001a1189e]         BOOTMEM
[    0.000000]   #55 [0001c00000 - 0001c1c000]         BOOTMEM
[    0.000000]   #56 [0001d00000 - 0001d1c000]         BOOTMEM
[    0.000000]   #57 [0001a138c0 - 0001a138c8]         BOOTMEM
[    0.000000]   #58 [0001a13900 - 0001a13908]         BOOTMEM
[    0.000000]   #59 [0001a13940 - 0001a13948]         BOOTMEM
[    0.000000]   #60 [0001a13980 - 0001a13990]         BOOTMEM
[    0.000000]   #61 [0001a139c0 - 0001a13b00]         BOOTMEM
[    0.000000]   #62 [0001a13b00 - 0001a13b60]         BOOTMEM
[    0.000000]   #63 [0001a13b80 - 0001a13be0]         BOOTMEM
[    0.000000]   #64 [0001a13c00 - 0001a1bc00]         BOOTMEM
[    0.000000]   #65 [0001d1c000 - 000211c000]         BOOTMEM
[    0.000000]   #66 [0005a00000 - 0005c00000]         BOOTMEM
[    0.000000]   #67 [0001a118c0 - 0001a11b00]         BOOTMEM
[    0.000000]   #68 [0005c00000 - 0009c00000]         BOOTMEM
[    0.000000]   #69 [0001a1bc00 - 0001a3bc00]         BOOTMEM
[    0.000000]   #70 [0001a3bc00 - 0001a7bc00]         BOOTMEM
[    0.000000]   #71 [000000c000 - 0000014000]         BOOTMEM
[    0.000000] Memory: 4009092k/5242880k available (4101k kernel code, 1085168k absent, 148620k reserved, 4674k data, 608k init)
[    0.000000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:424
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2527.140 MHz processor.
[    0.006676] Calibrating delay loop (skipped), value calculated using timer frequency.. 5056.87 BogoMIPS (lpj=8423800)
[    0.006731] Security Framework initialized
[    0.006757] Mount-cache hash table entries: 256
[    0.007057] CPU: Physical Processor ID: 0
[    0.007063] CPU: Processor Core ID: 0
[    0.007071] mce: CPU supports 6 MCE banks
[    0.007087] CPU0: Thermal monitoring handled by SMI
[    0.007095] using mwait in idle threads.
[    0.007100] Performance Events: Core2 events, Intel PMU driver.
[    0.007115] ... version:                2
[    0.007120] ... bit width:              40
[    0.007124] ... generic registers:      2
[    0.007129] ... value mask:             000000ffffffffff
[    0.007134] ... max period:             000000007fffffff
[    0.007139] ... fixed-purpose events:   3
[    0.007144] ... event mask:             0000000700000003
[    0.010262] ACPI: Core revision 20100121
[    0.072510] ftrace: converting mcount calls to 0f 1f 44 00 00
[    0.072523] ftrace: allocating 15724 entries in 62 pages
[    0.073421] Setting APIC routing to flat
[    0.073857] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.107188] CPU0: Intel(R) Core(TM)2 Duo CPU     T9400  @ 2.53GHz stepping 0a
[    0.126718] Booting Node   0, Processors  #1 Ok.
[    0.009999] CPU1: Thermal monitoring handled by SMI
[    0.223361] Brought up 2 CPUs
[    0.223369] Total of 2 processors activated (10112.47 BogoMIPS).
[    0.225915] devtmpfs: initialized
[    0.228390] Time: 21:05:03  Date: 04/13/10
[    0.228468] NET: Registered protocol family 16
[    0.228687] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.228695] ACPI: bus type pci registered
[    0.228842] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.228851] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.425688] PCI: Using configuration type 1 for base access
[    0.426776] bio: create slab <bio-0> at 0
[    0.434976] ACPI: EC: Look up EC in DSDT
[    0.482857] ACPI: BIOS _OSI(Linux) query ignored
[    0.513501] ACPI: SSDT 00000000bdec7c18 00275 (v01  PmRef  Cpu0Ist 00003000 INTL 20060912)
[    0.516046] ACPI: SSDT 00000000bdec5618 0059A (v01  PmRef  Cpu0Cst 00003001 INTL 20060912)
[    0.519259] ACPI: SSDT 00000000bdec6e18 001D7 (v01  PmRef    ApIst 00003000 INTL 20060912)
[    0.521671] ACPI: SSDT 00000000bdec7f18 0008D (v01  PmRef    ApCst 00003000 INTL 20060912)
[    0.770506] ACPI: Interpreter enabled
[    0.770518] ACPI: (supports S0 S3 S4 S5)
[    0.770582] ACPI: Using IOAPIC for interrupt routing
[    0.805445] ACPI: EC: GPE = 0x16, I/O: command/status = 0x66, data = 0x62
[    0.805643] ACPI: Power Resource [APPR] (off)
[    0.806155] ACPI: Power Resource [LPP] (on)
[    0.806298] ACPI: Power Resource [PGF0] (off)
[    0.807534] ACPI: No dock devices found.
[    0.807542] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.810906] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.813812] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.813821] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.813829] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.813840] pci_root PNP0A08:00: host bridge window length 0x20000001 doesn't fit in 0xc0000000-0xdfffffff, trimming
[    0.813849] pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xdfffffff]
[    0.813856] pci_root PNP0A08:00: host bridge window [mem 0xf0000000-0xfedfffff]
[    0.813864] pci_root PNP0A08:00: host bridge window [mem 0xfee01000-0xfffffffe] invalid; aligning end to 16-byte boundary
[    0.813872] pci_root PNP0A08:00: host bridge window [mem 0xfee01000-0xffffffff]
[    0.814066] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.814075] pci 0000:00:01.0: PME# disabled
[    0.814215] pci 0000:00:19.0: reg 10: [mem 0xd8400000-0xd841ffff]
[    0.814231] pci 0000:00:19.0: reg 14: [mem 0xd8424000-0xd8424fff]
[    0.814246] pci 0000:00:19.0: reg 18: [io  0x80e0-0x80ff]
[    0.814339] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.814349] pci 0000:00:19.0: PME# disabled
[    0.814452] pci 0000:00:1a.0: reg 20: [io  0x80c0-0x80df]
[    0.814598] pci 0000:00:1a.1: reg 20: [io  0x80a0-0x80bf]
[    0.814745] pci 0000:00:1a.2: reg 20: [io  0x8080-0x809f]
[    0.814884] pci 0000:00:1a.7: reg 10: [mem 0xd8425c00-0xd8425fff]
[    0.814996] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.815006] pci 0000:00:1a.7: PME# disabled
[    0.815086] pci 0000:00:1b.0: reg 10: [mem 0xd8420000-0xd8423fff 64bit]
[    0.815186] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.815196] pci 0000:00:1b.0: PME# disabled
[    0.815361] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.815371] pci 0000:00:1c.0: PME# disabled
[    0.815535] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.815546] pci 0000:00:1c.1: PME# disabled
[    0.815710] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.815721] pci 0000:00:1c.2: PME# disabled
[    0.815888] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.815898] pci 0000:00:1c.4: PME# disabled
[    0.816017] pci 0000:00:1d.0: reg 20: [io  0x8060-0x807f]
[    0.816163] pci 0000:00:1d.1: reg 20: [io  0x8040-0x805f]
[    0.816309] pci 0000:00:1d.2: reg 20: [io  0x8020-0x803f]
[    0.816449] pci 0000:00:1d.7: reg 10: [mem 0xd8425800-0xd8425bff]
[    0.816560] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.816571] pci 0000:00:1d.7: PME# disabled
[    0.816959] pci 0000:00:1f.2: reg 10: [io  0x8108-0x810f]
[    0.816974] pci 0000:00:1f.2: reg 14: [io  0x8114-0x8117]
[    0.816989] pci 0000:00:1f.2: reg 18: [io  0x8100-0x8107]
[    0.817004] pci 0000:00:1f.2: reg 1c: [io  0x8110-0x8113]
[    0.817018] pci 0000:00:1f.2: reg 20: [io  0x8000-0x801f]
[    0.817033] pci 0000:00:1f.2: reg 24: [mem 0xd8425000-0xd84257ff]
[    0.817113] pci 0000:00:1f.2: PME# supported from D3hot
[    0.817123] pci 0000:00:1f.2: PME# disabled
[    0.817274] pci 0000:01:00.0: reg 10: [mem 0xc0000000-0xcfffffff pref]
[    0.817289] pci 0000:01:00.0: reg 14: [io  0x7000-0x70ff]
[    0.817304] pci 0000:01:00.0: reg 18: [mem 0xd8300000-0xd830ffff]
[    0.817344] pci 0000:01:00.0: reg 30: [mem 0xfffe0000-0xffffffff pref]
[    0.817394] pci 0000:01:00.0: supports D1 D2
[    0.817462] pci 0000:01:00.1: reg 10: [mem 0xd8310000-0xd8313fff]
[    0.817563] pci 0000:01:00.1: supports D1 D2
[    0.817603] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.817612] pci 0000:00:01.0:   bridge window [io  0x7000-0x7fff]
[    0.817621] pci 0000:00:01.0:   bridge window [mem 0xd8300000-0xd83fffff]
[    0.817633] pci 0000:00:01.0:   bridge window [mem 0xc0000000-0xcfffffff 64bit pref]
[    0.817734] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.817744] pci 0000:00:1c.0:   bridge window [io  0x9000-0x9fff]
[    0.817754] pci 0000:00:1c.0:   bridge window [mem 0xd8200000-0xd82fffff]
[    0.817770] pci 0000:00:1c.0:   bridge window [mem 0xd8500000-0xd86fffff 64bit pref]
[    0.818110] pci 0000:03:00.0: reg 10: [mem 0xd8100000-0xd8101fff 64bit]
[    0.818519] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.818558] pci 0000:03:00.0: PME# disabled
[    0.818664] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.818674] pci 0000:00:1c.1:   bridge window [io  0xa000-0xafff]
[    0.818685] pci 0000:00:1c.1:   bridge window [mem 0xd8100000-0xd81fffff]
[    0.818700] pci 0000:00:1c.1:   bridge window [mem 0xd8700000-0xd88fffff 64bit pref]
[    0.818801] pci 0000:00:1c.2: PCI bridge to [bus 04-44]
[    0.818811] pci 0000:00:1c.2:   bridge window [io  0x5000-0x6fff]
[    0.818822] pci 0000:00:1c.2:   bridge window [mem 0xd4100000-0xd80fffff]
[    0.818837] pci 0000:00:1c.2:   bridge window [mem 0xd8900000-0xd8afffff 64bit pref]
[    0.818938] pci 0000:00:1c.4: PCI bridge to [bus 45-85]
[    0.818948] pci 0000:00:1c.4:   bridge window [io  0x3000-0x4fff]
[    0.818958] pci 0000:00:1c.4:   bridge window [mem 0xd0100000-0xd40fffff]
[    0.818973] pci 0000:00:1c.4:   bridge window [mem 0xd8b00000-0xd8cfffff 64bit pref]
[    0.819110] pci 0000:86:09.0: reg 10: [mem 0xd0001000-0xd00017ff]
[    0.819219] pci 0000:86:09.0: supports D1 D2
[    0.819225] pci 0000:86:09.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.819235] pci 0000:86:09.0: PME# disabled
[    0.819304] pci 0000:86:09.1: reg 10: [mem 0xd0001b00-0xd0001bff]
[    0.819413] pci 0000:86:09.1: supports D1 D2
[    0.819419] pci 0000:86:09.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.819430] pci 0000:86:09.1: PME# disabled
[    0.819502] pci 0000:86:09.2: reg 10: [mem 0xd0001900-0xd00019ff]
[    0.819611] pci 0000:86:09.2: supports D1 D2
[    0.819616] pci 0000:86:09.2: PME# supported from D0 D1 D2 D3hot D3cold
[    0.819627] pci 0000:86:09.2: PME# disabled
[    0.819696] pci 0000:86:09.3: reg 10: [mem 0xd0001800-0xd00018ff]
[    0.819805] pci 0000:86:09.3: supports D1 D2
[    0.819810] pci 0000:86:09.3: PME# supported from D0 D1 D2 D3hot D3cold
[    0.819821] pci 0000:86:09.3: PME# disabled
[    0.819890] pci 0000:86:09.4: reg 10: [mem 0xd0000000-0xd0000fff]
[    0.819935] pci 0000:86:09.4: supports D1 D2
[    0.819941] pci 0000:86:09.4: PME# supported from D0 D1 D2 D3hot D3cold
[    0.819952] pci 0000:86:09.4: PME# disabled
[    0.820054] pci 0000:00:1e.0: PCI bridge to [bus 86-8a] (subtractive decode)
[    0.820065] pci 0000:00:1e.0:   bridge window [io  0x2000-0x2fff]
[    0.820076] pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xd00fffff]
[    0.820091] pci 0000:00:1e.0:   bridge window [mem 0xdc000000-0xdfffffff 64bit pref]
[    0.820098] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.820105] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.820112] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.820119] pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xdfffffff] (subtractive decode)
[    0.820126] pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xfedfffff] (subtractive decode)
[    0.820133] pci 0000:00:1e.0:   bridge window [mem 0xfee01000-0xffffffff] (subtractive decode)
[    0.820274] pci_bus 0000:00: on NUMA node 0
[    0.820292] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.820976] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEGP._PRT]
[    0.821275] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.821502] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.821762] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
[    0.822180] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP05._PRT]
[    0.822735] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
[    0.874049] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
[    0.874399] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
[    0.874744] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
[    0.875085] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
[    0.875427] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
[    0.875768] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
[    0.876109] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
[    0.876450] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
[    0.876766] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.876786] vgaarb: loaded
[    0.876990] SCSI subsystem initialized
[    0.877100] usbcore: registered new interface driver usbfs
[    0.877129] usbcore: registered new interface driver hub
[    0.877171] usbcore: registered new device driver usb
[    0.877171] PCI: Using ACPI for IRQ routing
[    0.877171] PCI: pci_cache_line_size set to 64 bytes
[    0.877171] reserve RAM buffer: 000000000009fc00 - 000000000009ffff 
[    0.877171] reserve RAM buffer: 00000000b8f2f000 - 00000000bbffffff 
[    0.877171] reserve RAM buffer: 00000000b9d70000 - 00000000bbffffff 
[    0.877171] reserve RAM buffer: 00000000bc4e0000 - 00000000bfffffff 
[    0.877171] reserve RAM buffer: 00000000bde92000 - 00000000bfffffff 
[    0.877171] reserve RAM buffer: 00000000bdebf000 - 00000000bfffffff 
[    0.877171] reserve RAM buffer: 00000000be000000 - 00000000bfffffff 
[    0.877285] NetLabel: Initializing
[    0.877290] NetLabel:  domain hash size = 128
[    0.877294] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.877324] NetLabel:  unlabeled traffic allowed by default
[    0.877336] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    0.877349] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.877364] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.880055] Switching to clocksource tsc
[    0.903009] pnp: PnP ACPI init
[    0.903035] ACPI: bus type pnp registered
[    0.904571] pnp 00:00: resource length 0x20000001 doesn't fit in 0xc0000000-0xdfffffff, trimming
[    0.914294]   alloc irq_desc for 23 on node -1
[    0.914301]   alloc kstat_irqs on node -1
[    0.915707] pnp: PnP ACPI: found 13 devices
[    0.915714] ACPI: ACPI bus type pnp unregistered
[    0.915740] system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.915749] system 00:01: [mem 0xfed10000-0xfed13fff] has been reserved
[    0.915757] system 00:01: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.915765] system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.915773] system 00:01: [mem 0xe0000000-0xefffffff] has been reserved
[    0.915781] system 00:01: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.915789] system 00:01: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.915797] system 00:01: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.915815] system 00:05: [mem 0xfed00000-0xfed003ff] has been reserved
[    0.915832] system 00:07: [io  0x0200-0x027f] has been reserved
[    0.915840] system 00:07: [io  0x1000-0x1003] has been reserved
[    0.915848] system 00:07: [io  0x1010-0x101f] has been reserved
[    0.915856] system 00:07: [io  0xffff] has been reserved
[    0.915863] system 00:07: [io  0x0400-0x047f] has been reserved
[    0.915870] system 00:07: [io  0x0500-0x057f] has been reserved
[    0.915878] system 00:07: [io  0xef80-0xef9f] has been reserved
[    0.920989] pci 0000:01:00.0: no compatible bridge window for [mem 0xfffe0000-0xffffffff pref]
[    0.921095] PCI: max bus depth: 2 pci_try_num: 3
[    0.921198] pci 0000:01:00.0: BAR 6: assigned [mem 0xd8320000-0xd833ffff pref]
[    0.921206] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.921214] pci 0000:00:01.0:   bridge window [io  0x7000-0x7fff]
[    0.921225] pci 0000:00:01.0:   bridge window [mem 0xd8300000-0xd83fffff]
[    0.921234] pci 0000:00:01.0:   bridge window [mem 0xc0000000-0xcfffffff 64bit pref]
[    0.921246] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.921255] pci 0000:00:1c.0:   bridge window [io  0x9000-0x9fff]
[    0.921268] pci 0000:00:1c.0:   bridge window [mem 0xd8200000-0xd82fffff]
[    0.921278] pci 0000:00:1c.0:   bridge window [mem 0xd8500000-0xd86fffff 64bit pref]
[    0.921294] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.921301] pci 0000:00:1c.1:   bridge window [io  0xa000-0xafff]
[    0.921314] pci 0000:00:1c.1:   bridge window [mem 0xd8100000-0xd81fffff]
[    0.921324] pci 0000:00:1c.1:   bridge window [mem 0xd8700000-0xd88fffff 64bit pref]
[    0.921340] pci 0000:00:1c.2: PCI bridge to [bus 04-44]
[    0.921347] pci 0000:00:1c.2:   bridge window [io  0x5000-0x6fff]
[    0.921360] pci 0000:00:1c.2:   bridge window [mem 0xd4100000-0xd80fffff]
[    0.921371] pci 0000:00:1c.2:   bridge window [mem 0xd8900000-0xd8afffff 64bit pref]
[    0.921386] pci 0000:00:1c.4: PCI bridge to [bus 45-85]
[    0.921394] pci 0000:00:1c.4:   bridge window [io  0x3000-0x4fff]
[    0.921406] pci 0000:00:1c.4:   bridge window [mem 0xd0100000-0xd40fffff]
[    0.921417] pci 0000:00:1c.4:   bridge window [mem 0xd8b00000-0xd8cfffff 64bit pref]
[    0.921436] pci 0000:86:09.4: BAR 15: assigned [mem 0xdc000000-0xdfffffff pref]
[    0.921445] pci 0000:86:09.4: BAR 16: assigned [mem 0xf0000000-0xf3ffffff]
[    0.921452] pci 0000:86:09.4: BAR 13: assigned [io  0x2000-0x20ff]
[    0.921459] pci 0000:86:09.4: BAR 14: assigned [io  0x2400-0x24ff]
[    0.921465] pci 0000:86:09.4: CardBus bridge to [bus 87-8a]
[    0.921471] pci 0000:86:09.4:   bridge window [io  0x2000-0x20ff]
[    0.921482] pci 0000:86:09.4:   bridge window [io  0x2400-0x24ff]
[    0.921493] pci 0000:86:09.4:   bridge window [mem 0xdc000000-0xdfffffff pref]
[    0.921505] pci 0000:86:09.4:   bridge window [mem 0xf0000000-0xf3ffffff]
[    0.921516] pci 0000:00:1e.0: PCI bridge to [bus 86-8a]
[    0.921524] pci 0000:00:1e.0:   bridge window [io  0x2000-0x2fff]
[    0.921537] pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xd00fffff]
[    0.921547] pci 0000:00:1e.0:   bridge window [mem 0xdc000000-0xdfffffff 64bit pref]
[    0.921575]   alloc irq_desc for 16 on node -1
[    0.921592]   alloc kstat_irqs on node -1
[    0.921604] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.921614] pci 0000:00:01.0: setting latency timer to 64
[    0.921635] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.921645] pci 0000:00:1c.0: setting latency timer to 64
[    0.921664]   alloc irq_desc for 17 on node -1
[    0.921668]   alloc kstat_irqs on node -1
[    0.921678] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.921688] pci 0000:00:1c.1: setting latency timer to 64
[    0.921707]   alloc irq_desc for 18 on node -1
[    0.921712]   alloc kstat_irqs on node -1
[    0.921720] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.921731] pci 0000:00:1c.2: setting latency timer to 64
[    0.921751] pci 0000:00:1c.4: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.921761] pci 0000:00:1c.4: setting latency timer to 64
[    0.921778] pci 0000:00:1e.0: setting latency timer to 64
[    0.921799]   alloc irq_desc for 22 on node -1
[    0.921804]   alloc kstat_irqs on node -1
[    0.921813] pci 0000:86:09.4: PCI INT B -> GSI 22 (level, low) -> IRQ 22
[    0.921827] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.921833] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.921840] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.921846] pci_bus 0000:00: resource 7 [mem 0xc0000000-0xdfffffff]
[    0.921852] pci_bus 0000:00: resource 8 [mem 0xf0000000-0xfedfffff]
[    0.921859] pci_bus 0000:00: resource 9 [mem 0xfee01000-0xffffffff]
[    0.921866] pci_bus 0000:01: resource 0 [io  0x7000-0x7fff]
[    0.921872] pci_bus 0000:01: resource 1 [mem 0xd8300000-0xd83fffff]
[    0.921878] pci_bus 0000:01: resource 2 [mem 0xc0000000-0xcfffffff 64bit pref]
[    0.921886] pci_bus 0000:02: resource 0 [io  0x9000-0x9fff]
[    0.921892] pci_bus 0000:02: resource 1 [mem 0xd8200000-0xd82fffff]
[    0.921899] pci_bus 0000:02: resource 2 [mem 0xd8500000-0xd86fffff 64bit pref]
[    0.921905] pci_bus 0000:03: resource 0 [io  0xa000-0xafff]
[    0.921912] pci_bus 0000:03: resource 1 [mem 0xd8100000-0xd81fffff]
[    0.921918] pci_bus 0000:03: resource 2 [mem 0xd8700000-0xd88fffff 64bit pref]
[    0.921925] pci_bus 0000:04: resource 0 [io  0x5000-0x6fff]
[    0.921931] pci_bus 0000:04: resource 1 [mem 0xd4100000-0xd80fffff]
[    0.921937] pci_bus 0000:04: resource 2 [mem 0xd8900000-0xd8afffff 64bit pref]
[    0.921944] pci_bus 0000:45: resource 0 [io  0x3000-0x4fff]
[    0.921950] pci_bus 0000:45: resource 1 [mem 0xd0100000-0xd40fffff]
[    0.921956] pci_bus 0000:45: resource 2 [mem 0xd8b00000-0xd8cfffff 64bit pref]
[    0.921963] pci_bus 0000:86: resource 0 [io  0x2000-0x2fff]
[    0.921969] pci_bus 0000:86: resource 1 [mem 0xd0000000-0xd00fffff]
[    0.921975] pci_bus 0000:86: resource 2 [mem 0xdc000000-0xdfffffff 64bit pref]
[    0.921982] pci_bus 0000:86: resource 4 [io  0x0000-0x0cf7]
[    0.921988] pci_bus 0000:86: resource 5 [io  0x0d00-0xffff]
[    0.921994] pci_bus 0000:86: resource 6 [mem 0x000a0000-0x000bffff]
[    0.922000] pci_bus 0000:86: resource 7 [mem 0xc0000000-0xdfffffff]
[    0.922006] pci_bus 0000:86: resource 8 [mem 0xf0000000-0xfedfffff]
[    0.922013] pci_bus 0000:86: resource 9 [mem 0xfee01000-0xffffffff]
[    0.922019] pci_bus 0000:87: resource 0 [io  0x2000-0x20ff]
[    0.922025] pci_bus 0000:87: resource 1 [io  0x2400-0x24ff]
[    0.922031] pci_bus 0000:87: resource 2 [mem 0xdc000000-0xdfffffff pref]
[    0.922037] pci_bus 0000:87: resource 3 [mem 0xf0000000-0xf3ffffff]
[    0.922093] NET: Registered protocol family 2
[    0.922244] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.924211] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.927279] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.928083] TCP: Hash tables configured (established 262144 bind 65536)
[    0.928089] TCP reno registered
[    0.928097] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.928154] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.928360] NET: Registered protocol family 1
[    0.928716] pci 0000:01:00.0: Boot video device
[    0.928791] PCI: CLS 64 bytes, default 64
[    0.928901] Trying to unpack rootfs image as initramfs...
[    1.443611] Freeing initrd memory: 8564k freed
[    1.450267] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    1.450281] Placing 64MB software IO TLB between ffff880005c00000 - ffff880009c00000
[    1.450289] software IO TLB at phys 0x5c00000 - 0x9c00000
[    1.467891] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.471148] VFS: Disk quotas dquot_6.5.2
[    1.471271] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.471785] fuse init (API version 7.13)
[    1.471974] msgmni has been set to 7846
[    1.472444] alg: No test for stdrng (krng)
[    1.472561] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    1.472569] io scheduler noop registered
[    1.472575] io scheduler deadline registered (default)
[    1.472851] pcieport 0000:00:01.0: setting latency timer to 64
[    1.472914]   alloc irq_desc for 24 on node -1
[    1.472920]   alloc kstat_irqs on node -1
[    1.472940] pcieport 0000:00:01.0: irq 24 for MSI/MSI-X
[    1.473105] pcieport 0000:00:1c.0: setting latency timer to 64
[    1.473181]   alloc irq_desc for 25 on node -1
[    1.473186]   alloc kstat_irqs on node -1
[    1.473204] pcieport 0000:00:1c.0: irq 25 for MSI/MSI-X
[    1.473399] pcieport 0000:00:1c.1: setting latency timer to 64
[    1.473474]   alloc irq_desc for 26 on node -1
[    1.473479]   alloc kstat_irqs on node -1
[    1.473496] pcieport 0000:00:1c.1: irq 26 for MSI/MSI-X
[    1.473685] pcieport 0000:00:1c.2: setting latency timer to 64
[    1.473760]   alloc irq_desc for 27 on node -1
[    1.473765]   alloc kstat_irqs on node -1
[    1.473782] pcieport 0000:00:1c.2: irq 27 for MSI/MSI-X
[    1.473965] pcieport 0000:00:1c.4: setting latency timer to 64
[    1.474040]   alloc irq_desc for 28 on node -1
[    1.474045]   alloc kstat_irqs on node -1
[    1.474062] pcieport 0000:00:1c.4: irq 28 for MSI/MSI-X
[    1.474287] pcieport 0000:00:01.0: Requesting control of PCIe PME from ACPI BIOS
[    1.479004] pcieport 0000:00:01.0: Signaling PME through PCIe PME interrupt
[    1.479012] pci 0000:01:00.0: Signaling PME through PCIe PME interrupt
[    1.479019] pci 0000:01:00.1: Signaling PME through PCIe PME interrupt
[    1.479028] pcie_pme 0000:00:01.0:pcie01: service driver pcie_pme loaded
[    1.479043] pcieport 0000:00:1c.0: Requesting control of PCIe PME from ACPI BIOS
[    1.479087] pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
[    1.479098] pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
[    1.479111] pcieport 0000:00:1c.1: Requesting control of PCIe PME from ACPI BIOS
[    1.479154] pcieport 0000:00:1c.1: Signaling PME through PCIe PME interrupt
[    1.479160] pci 0000:03:00.0: Signaling PME through PCIe PME interrupt
[    1.479171] pcie_pme 0000:00:1c.1:pcie01: service driver pcie_pme loaded
[    1.479184] pcieport 0000:00:1c.2: Requesting control of PCIe PME from ACPI BIOS
[    1.479225] pcieport 0000:00:1c.2: Signaling PME through PCIe PME interrupt
[    1.479236] pcie_pme 0000:00:1c.2:pcie01: service driver pcie_pme loaded
[    1.479249] pcieport 0000:00:1c.4: Requesting control of PCIe PME from ACPI BIOS
[    1.479292] pcieport 0000:00:1c.4: Signaling PME through PCIe PME interrupt
[    1.479303] pcie_pme 0000:00:1c.4:pcie01: service driver pcie_pme loaded
[    1.480303] ACPI: AC Adapter [AC] (on-line)
[    1.480507] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input0
[    1.480515] ACPI: Sleep Button [SLPB]
[    1.480621] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input1
[    1.480875] ACPI: Lid Switch [LID]
[    1.480986] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    1.480993] ACPI: Power Button [PWRF]
[    1.481362] ACPI: Fan [FANG] (off)
[    1.487588] Monitor-Mwait will be used to enter C-1 state
[    1.487659] Monitor-Mwait will be used to enter C-2 state
[    1.487683] Marking TSC unstable due to TSC halts in idle
[    1.487916] Switching to clocksource hpet
[    1.515705] thermal LNXTHERM:01: registered as thermal_zone0
[    1.515727] ACPI: Thermal Zone [GFXZ] (30 C)
[    1.526125] thermal LNXTHERM:02: registered as thermal_zone1
[    1.526147] ACPI: Thermal Zone [DTSZ] (62 C)
[    1.539548] thermal LNXTHERM:03: registered as thermal_zone2
[    1.539575] ACPI: Thermal Zone [BATZ] (29 C)
[    1.548740] thermal LNXTHERM:04: registered as thermal_zone3
[    1.548761] ACPI: Thermal Zone [CPUZ] (70 C)
[    1.557329] thermal LNXTHERM:05: registered as thermal_zone4
[    1.557350] ACPI: Thermal Zone [LOCZ] (49 C)
[    1.566204] thermal LNXTHERM:06: registered as thermal_zone5
[    1.566230] ACPI: Thermal Zone [CP2Z] (16 C)
[    1.569830] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.573154] brd: module loaded
[    1.574359] loop: module loaded
[    1.575286] Fixed MDIO Bus: probed
[    1.575361] PPP generic driver version 2.4.2
[    1.575433] tun: Universal TUN/TAP device driver, 1.6
[    1.575439] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    1.575652] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    1.577422] i8042.c: Detected active multiplexing controller, rev 1.1.
[    1.578207] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.578222] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[    1.578230] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[    1.578238] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[    1.578246] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[    1.578371] mice: PS/2 mouse device common for all mice
[    1.578585] rtc_cmos 00:08: RTC can wake from S4
[    1.578662] rtc_cmos 00:08: rtc core: registered rtc_cmos as rtc0
[    1.578708] rtc0: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    1.578902] device-mapper: uevent: version 1.0.3
[    1.579146] device-mapper: ioctl: 4.17.0-ioctl (2010-03-05) initialised: dm-devel@redhat.com
[    1.580924] device-mapper: multipath: version 1.1.1 loaded
[    1.580931] device-mapper: multipath round-robin: version 1.0.0 loaded
[    1.581218] cpuidle: using governor ladder
[    1.581408] cpuidle: using governor menu
[    1.582182] TCP cubic registered
[    1.582503] NET: Registered protocol family 10
[    1.583470] lo: Disabled Privacy Extensions
[    1.584154] NET: Registered protocol family 17
[    1.584392] PM: Checking image partition /dev/sda5
[    1.600271] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
[    1.618708] ACPI: Battery Slot [BAT0] (battery present)
[    1.619256] ACPI: Battery Slot [BAT1] (battery absent)
[    1.623421] PM: Resume from disk failed.
[    1.624208]   Magic number: 6:704:95
[    1.624265] pci_express 0000:00:1c.2:pcie08: hash matches
[    1.624426] rtc_cmos 00:08: setting system clock to 2010-04-13 21:05:04 UTC (1271192704)
[    1.624435] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    1.624440] EDD information not available.
[    1.624719] Freeing unused kernel memory: 608k freed
[    1.625038] Write protecting the kernel read-only data: 8192k
[    1.625966] Freeing unused kernel memory: 2024k freed
[    1.627166] Freeing unused kernel memory: 168k freed
[    1.663598] udev: starting version 151
[    1.978816] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.978883]   alloc irq_desc for 19 on node -1
[    1.978889]   alloc kstat_irqs on node -1
[    1.978906] ehci_hcd 0000:00:1a.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    1.978961] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    1.978970] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    1.978986] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    1.979053] ehci_hcd 0000:00:1a.7: debug port 1
[    1.982948] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[    1.982986] ehci_hcd 0000:00:1a.7: irq 19, io mem 0xd8425c00
[    2.001997] e1000e: Intel(R) PRO/1000 Network Driver - 1.0.2-k2
[    2.002006] e1000e: Copyright (c) 1999 - 2009 Intel Corporation.
[    2.006701] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    2.007017] hub 1-0:1.0: USB hub found
[    2.007031] hub 1-0:1.0: 6 ports detected
[    2.009743] e1000e 0000:00:19.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    2.009766] e1000e 0000:00:19.0: setting latency timer to 64
[    2.010056]   alloc irq_desc for 29 on node -1
[    2.010062]   alloc kstat_irqs on node -1
[    2.010087] e1000e 0000:00:19.0: irq 29 for MSI/MSI-X
[    2.047832] libata version 3.00 loaded.
[    2.244016] 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:24:81:b3:c2:95
[    2.244026] 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    2.244060] 0000:00:19.0: eth0: MAC: 7, PHY: 8, PBA No: 1052ff-0ff
[    2.244150]   alloc irq_desc for 20 on node -1
[    2.244157]   alloc kstat_irqs on node -1
[    2.244175] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 20 (level, low) -> IRQ 20
[    2.244249] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    2.244258] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    2.244277] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    2.244335] ehci_hcd 0000:00:1d.7: debug port 1
[    2.248237] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    2.248272] ehci_hcd 0000:00:1d.7: irq 20, io mem 0xd8425800
[    2.263619] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    2.263978] hub 2-0:1.0: USB hub found
[    2.263994] hub 2-0:1.0: 6 ports detected
[    2.264232] ahci 0000:00:1f.2: version 3.0
[    2.264269]   alloc irq_desc for 21 on node -1
[    2.264275]   alloc kstat_irqs on node -1
[    2.264292] ahci 0000:00:1f.2: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[    2.264399]   alloc irq_desc for 30 on node -1
[    2.264404]   alloc kstat_irqs on node -1
[    2.264425] ahci 0000:00:1f.2: irq 30 for MSI/MSI-X
[    2.264519] ahci: SSS flag set, parallel bus scan disabled
[    2.264585] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x33 impl SATA mode
[    2.264595] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part ccc ems sxs 
[    2.264607] ahci 0000:00:1f.2: setting latency timer to 64
[    2.284633] scsi0 : ahci
[    2.285021] scsi1 : ahci
[    2.285246] scsi2 : ahci
[    2.285401] scsi3 : ahci
[    2.285546] scsi4 : ahci
[    2.285686] scsi5 : ahci
[    2.286604] ata1: SATA max UDMA/133 abar m2048@0xd8425000 port 0xd8425100 irq 30
[    2.286613] ata2: SATA max UDMA/133 abar m2048@0xd8425000 port 0xd8425180 irq 30
[    2.286619] ata3: DUMMY
[    2.286623] ata4: DUMMY
[    2.286629] ata5: SATA max UDMA/133 abar m2048@0xd8425000 port 0xd8425300 irq 30
[    2.286637] ata6: SATA max UDMA/133 abar m2048@0xd8425000 port 0xd8425380 irq 30
[    2.603654] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.605252] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    2.607336] ata1.00: ATA-7: CORSAIR CMFSSD-256GBG2D, VBM19C1Q, max UDMA/100
[    2.607346] ata1.00: 500118192 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    2.608383] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    2.609671] ata1.00: configured for UDMA/100
[    2.620517] scsi 0:0:0:0: Direct-Access     ATA      CORSAIR CMFSSD-2 VBM1 PQ: 0 ANSI: 5
[    2.620971] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.621187] sd 0:0:0:0: [sda] 500118192 512-byte logical blocks: (256 GB/238 GiB)
[    2.621337] sd 0:0:0:0: [sda] Write Protect is off
[    2.621345] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.621409] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.621786]  sda: sda1 sda2 < sda5 sda6 >
[    2.623175] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.340329] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.353978] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    3.353992] ata2.00: ATAPI: Optiarc DVD RW AD-7581S, 4H03, max UDMA/100
[    3.374025] ata2.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
[    3.374069] ata2.00: configured for UDMA/100
[    3.391151] scsi 1:0:0:0: CD-ROM            Optiarc  DVD RW AD-7581S  4H03 PQ: 0 ANSI: 5
[    3.407448] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    3.407458] Uniform CD-ROM driver Revision: 3.20
[    3.407776] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    3.407950] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    3.726965] ata5: SATA link down (SStatus 0 SControl 300)
[    4.060303] ata6: SATA link down (SStatus 0 SControl 300)
[    4.225190] SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
[    4.234698] SGI XFS Quota Management subsystem
[    4.241477] XFS mounting filesystem sda6
[    4.299569] Ending clean XFS mount for filesystem: sda6
[    4.595091] Adding 11717628k swap on /dev/sda5.  Priority:-1 extents:1 across:11717628k SSD
[    4.873153] udev: starting version 151
[    5.375349] Linux agpgart interface v0.103
[    5.389998] ACPI: WMI: Mapper loaded
[    5.410286] tpm_tis 00:04: 1.2 TPM (device-id 0xB, rev-id 16)
[    5.447500] acpi device:02: registered as cooling_device3
[    5.448010] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:01/LNXVIDEO:00/input/input4
[    5.448049] ACPI: Video Device [DGFX] (multi-head: yes  rom: no  post: no)
[    5.450821] cfg80211: Calling CRDA to update world regulatory domain
[    5.477743] [drm] Initialized drm 1.1.0 20060810
[    5.479481] yenta_cardbus 0000:86:09.4: CardBus bridge found [103c:30e7]
[    5.485864] sdhci: Secure Digital Host Controller Interface driver
[    5.485866] sdhci: Copyright(c) Pierre Ossman
[    5.491963] input: HP WMI hotkeys as /devices/virtual/input/input5
[    5.505136] cfg80211: World regulatory domain updated:
[    5.505139]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[    5.505142]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    5.505144]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[    5.505146]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[    5.505149]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    5.505151]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    5.506822] kjournald starting.  Commit interval 5 seconds
[    5.507476] EXT3-fs (sda1): using internal journal
[    5.507482] EXT3-fs (sda1): mounted filesystem with ordered data mode
[    5.515525] lis3lv02d: hardware type NC693xx found.
[    5.528571] ppdev: user-space parallel port driver
[    5.531422] lis3lv02d: 8 bits sensor found
[    5.593390] input: ST LIS3LV02DL Accelerometer as /devices/platform/lis3lv02d/input/input6
[    5.593476] Registered led device: hp::hddprotect
[    5.593496] lis3lv02d driver loaded.
[    5.597165] [drm] radeon kernel modesetting enabled.
[    5.597219] radeon 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    5.597225] radeon 0000:01:00.0: setting latency timer to 64
[    5.599039] [drm] radeon: Initializing kernel modesetting.
[    5.605070] yenta_cardbus 0000:86:09.4: ISA IRQ mask 0x0cb8, PCI irq 22
[    5.605074] yenta_cardbus 0000:86:09.4: Socket status: 30000818
[    5.605081] yenta_cardbus 0000:86:09.4: pcmcia: parent PCI bridge window: [io  0x2000-0x2fff]
[    5.605084] yenta_cardbus 0000:86:09.4: pcmcia: parent PCI bridge window: [mem 0xd0000000-0xd00fffff]
[    5.605087] pcmcia_socket pcmcia_socket0: cs: memory probe 0xd0000000-0xd00fffff: excluding 0xd0000000-0xd000ffff
[    5.605103] yenta_cardbus 0000:86:09.4: pcmcia: parent PCI bridge window: [mem 0xdc000000-0xdfffffff 64bit pref]
[    5.605105] pcmcia_socket pcmcia_socket0: cs: memory probe 0xdc000000-0xdfffffff: excluding 0xdc000000-0xdfffffff
[    5.605120] yenta_cardbus 0000:86:09.4: pcmcia: parent PCI bridge window: [io  0x0000-0x0cf7]
[    5.605123] yenta_cardbus 0000:86:09.4: pcmcia: parent PCI bridge window: [io  0x0d00-0xffff]
[    5.605125] yenta_cardbus 0000:86:09.4: pcmcia: parent PCI bridge window: [mem 0x000a0000-0x000bffff]
[    5.605127] pcmcia_socket pcmcia_socket0: cs: memory probe 0x0a0000-0x0bffff: clean.
[    5.605141] yenta_cardbus 0000:86:09.4: pcmcia: parent PCI bridge window: [mem 0xc0000000-0xdfffffff]
[    5.605144] pcmcia_socket pcmcia_socket0: cs: memory probe 0xc0000000-0xdfffffff: excluding 0xc0000000-0xd8ffffff 0xdc000000-0xdfffffff
[    5.605186] yenta_cardbus 0000:86:09.4: pcmcia: parent PCI bridge window: [mem 0xf0000000-0xfedfffff]
[    5.605188] pcmcia_socket pcmcia_socket0: cs: memory probe 0xf0000000-0xfedfffff: excluding 0xf0000000-0xf3ffffff 0xfe800000-0xfeffffff
[    5.605215] yenta_cardbus 0000:86:09.4: pcmcia: parent PCI bridge window: [mem 0xfee01000-0xffffffff]
[    5.605217] pcmcia_socket pcmcia_socket0: cs: memory probe 0xfee01000-0xffffffff: excluding 0xffda5000-0x1000fefff
[    5.605293] [drm] register mmio base: 0xD8300000
[    5.605295] [drm] register mmio size: 65536
[    5.605498] ATOM BIOS: HP_Wistron_Vox_M86M
[    5.605516] [drm] Clocks initialized !
[    5.605519] [drm] Internal thermal controller with fan control
[    5.605522] [drm] 7 Power State(s)
[    5.605523] [drm] State 0 Default (default)
[    5.605525] [drm] 	16 PCIE Lanes
[    5.605526] [drm] 	3 Clock Mode(s)
[    5.605528] [drm] 		0 engine/memory: 600000/700000
[    5.605530] [drm] 		1 engine/memory: 600000/700000
[    5.605531] [drm] 		2 engine/memory: 600000/700000
[    5.605533] [drm] State 1 Performance 
[    5.605535] [drm] 	16 PCIE Lanes
[    5.605536] [drm] 	3 Clock Mode(s)
[    5.605538] [drm] 		0 engine/memory: 110000/405000
[    5.605539] [drm] 		1 engine/memory: 337000/405000
[    5.605541] [drm] 		2 engine/memory: 600000/700000
[    5.605543] [drm] State 2 Battery 
[    5.605544] [drm] 	16 PCIE Lanes
[    5.605545] [drm] 	3 Clock Mode(s)
[    5.605547] [drm] 		0 engine/memory: 110000/405000
[    5.605549] [drm] 		1 engine/memory: 337000/405000
[    5.605550] [drm] 		2 engine/memory: 337000/405000
[    5.605552] [drm] State 3 Default 
[    5.605553] [drm] 	16 PCIE Lanes
[    5.605555] [drm] 	3 Clock Mode(s)
[    5.605556] [drm] 		0 engine/memory: 300000/405000
[    5.605558] [drm] 		1 engine/memory: 450000/700000
[    5.605560] [drm] 		2 engine/memory: 450000/700000
[    5.605561] [drm] State 4 Performance 
[    5.605563] [drm] 	16 PCIE Lanes
[    5.605564] [drm] 	3 Clock Mode(s)
[    5.605566] [drm] 		0 engine/memory: 337000/700000
[    5.605567] [drm] 		1 engine/memory: 337000/700000
[    5.605569] [drm] 		2 engine/memory: 600000/700000
[    5.605571] [drm] State 5 Battery 
[    5.605572] [drm] 	16 PCIE Lanes
[    5.605573] [drm] 	3 Clock Mode(s)
[    5.605575] [drm] 		0 engine/memory: 337000/405000
[    5.605577] [drm] 		1 engine/memory: 337000/405000
[    5.605578] [drm] 		2 engine/memory: 337000/405000
[    5.605580] [drm] State 6 Default 
[    5.605581] [drm] 	16 PCIE Lanes
[    5.605583] [drm] 	3 Clock Mode(s)
[    5.605584] [drm] 		0 engine/memory: 337000/405000
[    5.605586] [drm] 		1 engine/memory: 337000/405000
[    5.605588] [drm] 		2 engine/memory: 337000/405000
[    5.605593] [drm] radeon: dynamic power management enabled
[    5.605594] [drm] radeon: power management initialized
[    5.605605] radeon 0000:01:00.0: VRAM: 256M 0x00000000 - 0x0FFFFFFF (256M used)
[    5.605607] radeon 0000:01:00.0: GTT: 512M 0x10000000 - 0x2FFFFFFF
[    5.605630] [drm] Detected VRAM RAM=256M, BAR=256M
[    5.605632] [drm] RAM width 128bits DDR
[    5.609690] iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:
[    5.609693] iwlagn: Copyright(c) 2003-2010 Intel Corporation
[    5.609780] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    5.609811] iwlagn 0000:03:00.0: setting latency timer to 64
[    5.609892] iwlagn 0000:03:00.0: Detected Intel Wireless WiFi Link 5300AGN REV=0x24
[    5.611438] [TTM] Zone  kernel: Available graphics memory: 2010228 kiB.
[    5.611454] [drm] radeon: 256M of VRAM memory ready
[    5.611456] [drm] radeon: 512M of GTT memory ready.
[    5.611508]   alloc irq_desc for 31 on node -1
[    5.611510]   alloc kstat_irqs on node -1
[    5.611539] radeon 0000:01:00.0: irq 31 for MSI/MSI-X
[    5.611571] [drm] radeon: using MSI.
[    5.611663] [drm] radeon: irq initialized.
[    5.611666] [drm] GART: num cpu pages 131072, num gpu pages 131072
[    5.612584] [drm] Loading RV635 Microcode
[    5.612587] platform radeon_cp.0: firmware: requesting radeon/RV635_pfp.bin
[    5.618382] sdhci-pci 0000:86:09.1: SDHCI controller found [1180:0822] (rev 25)
[    5.618401] sdhci-pci 0000:86:09.1: PCI INT B -> GSI 22 (level, low) -> IRQ 22
[    5.619433] sdhci-pci 0000:86:09.1: Will use DMA mode even though HW doesn't fully claim to support it.
[    5.620474] Registered led device: mmc0::
[    5.621650] mmc0: SDHCI controller on PCI [0000:86:09.1] using DMA
[    5.634509] platform radeon_cp.0: firmware: requesting radeon/RV635_me.bin
[    5.646976] platform radeon_cp.0: firmware: requesting radeon/R600_rlc.bin
[    5.650398] pcmcia_socket pcmcia_socket0: cs: memory probe 0x0c0000-0x0fffff: excluding 0xc0000-0xfffff
[    5.650450] pcmcia_socket pcmcia_socket0: cs: memory probe 0xa0000000-0xa0ffffff: excluding 0xa0000000-0xa0ffffff
[    5.650499] pcmcia_socket pcmcia_socket0: cs: memory probe 0x60000000-0x60ffffff: excluding 0x60000000-0x60ffffff
[    5.654244] iwlagn 0000:03:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
[    5.654332]   alloc irq_desc for 32 on node -1
[    5.654334]   alloc kstat_irqs on node -1
[    5.664217] iwlagn 0000:03:00.0: irq 32 for MSI/MSI-X
[    5.674417] iwlagn 0000:03:00.0: firmware: requesting iwlwifi-5000-2.ucode
[    5.695515] [drm] ring test succeeded in 1 usecs
[    5.695627] [drm] radeon: ib pool ready.
[    5.695711] [drm] ib test succeeded in 0 usecs
[    5.695735] [drm] Default TV standard: NTSC
[    5.698525] [drm] Radeon Display Connectors
[    5.698527] [drm] Connector 0:
[    5.698529] [drm]   VGA
[    5.698531] [drm]   DDC: 0x7e40 0x7e40 0x7e44 0x7e44 0x7e48 0x7e48 0x7e4c 0x7e4c
[    5.698533] [drm]   Encoders:
[    5.698535] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[    5.698536] [drm] Connector 1:
[    5.698538] [drm]   LVDS
[    5.698539] [drm]   Encoders:
[    5.698540] [drm]     LCD1: INTERNAL_KLDSCP_LVTMA
[    5.698542] [drm] Connector 2:
[    5.698543] [drm]   DVI-D
[    5.698544] [drm]   HPD1
[    5.698546] [drm]   DDC: 0x7e60 0x7e60 0x7e64 0x7e64 0x7e68 0x7e68 0x7e6c 0x7e6c
[    5.698548] [drm]   Encoders:
[    5.698549] [drm]     DFP1: INTERNAL_UNIPHY
[    5.698551] [drm] Connector 3:
[    5.698552] [drm]   HDMI-A
[    5.698554] [drm]   HPD2
[    5.698555] [drm]   DDC: 0x7e60 0x7e60 0x7e64 0x7e64 0x7e68 0x7e68 0x7e6c 0x7e6c
[    5.698557] [drm]   Encoders:
[    5.698559] [drm]     DFP2: INTERNAL_UNIPHY
[    5.700269] iwlagn 0000:03:00.0: loaded firmware version 8.24.2.12
[    5.707808] [drm] Requested: e: 11000 m: 40500 p: 16
[    5.707811] [drm] Setting: e: 11000 m: 40500 p: 16
[    5.745636] phy0: Selected rate control algorithm 'iwl-agn-rs'
[    5.751641] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[    5.751651] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    5.751726]   alloc irq_desc for 33 on node -1
[    5.751728]   alloc kstat_irqs on node -1
[    5.751740] HDA Intel 0000:00:1b.0: irq 33 for MSI/MSI-X
[    5.751772] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    5.768931] [drm] fb mappable at 0xC0141000
[    5.768933] [drm] vram apper at 0xC0000000
[    5.768935] [drm] size 7257600
[    5.768936] [drm] fb depth is 24
[    5.768937] [drm]    pitch is 6912
[    5.769070] fb0: radeondrmfb frame buffer device
[    5.769073] registered panic notifier
[    5.769078] [drm] Initialized radeon 2.2.0 20080528 for 0000:01:00.0 on minor 0
[    5.782885] [drm] Requested: e: 60000 m: 70000 p: 16
[    5.782887] [drm] Setting: e: 60000 m: 70000 p: 16
[    5.917687] e1000e 0000:00:19.0: irq 29 for MSI/MSI-X
[    5.971393] e1000e 0000:00:19.0: irq 29 for MSI/MSI-X
[    5.972575] ADDRCONF(NETDEV_UP): eth0: link is not ready
[    6.103499] Synaptics Touchpad, model: 1, fw: 7.0, id: 0x1c0b1, caps: 0xd44791/0xb00000
[    6.103509] serio: Synaptics pass-through port at isa0060/serio4/input0
[    6.148025] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input7
[    6.150539] HDA Intel 0000:01:00.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    6.150630]   alloc irq_desc for 34 on node -1
[    6.150632]   alloc kstat_irqs on node -1
[    6.150643] HDA Intel 0000:01:00.1: irq 34 for MSI/MSI-X
[    6.150675] HDA Intel 0000:01:00.1: setting latency timer to 64
[    6.152158] input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio4/input/input8
[    6.171924] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[    6.383279] [drm] Requested: e: 33700 m: 40500 p: 16
[    6.383289] [drm] Setting: e: 33700 m: 40500 p: 16
[    6.497789] pcmcia_socket pcmcia_socket0: pccard: PCMCIA card inserted into slot 0
[    6.497803] pcmcia_socket pcmcia_socket0: cs: memory probe 0x0a0000-0x0bffff: excluding 0xa0000-0xb9fff
[    6.526398] pcmcia_socket pcmcia_socket0: cs: memory probe 0xd9000000-0xdbffffff: excluding 0xd9f00000-0xda1fffff 0xdae00000-0xdb0fffff
[    6.531213] pcmcia_socket pcmcia_socket0: cs: memory probe 0xf4000000-0xfe7fffff: clean.
[    6.537863] pcmcia_socket pcmcia_socket0: cs: memory probe 0xfee01000-0xffda4fff: excluding 0xfeff5000-0xff0eefff 0xff7c5000-0xffe9afff
[    6.544272] parport_pc 00:09: reported by Plug and Play ACPI
[    6.544343] parport0: PC-style at 0x378 (0x778), irq 5, using FIFO [PCSPP,TRISTATE,COMPAT,ECP]
[    6.918609] Console: switching to colour frame buffer device 210x65
[    8.352900] lp0: using parport0 (interrupt-driven).
[   11.437727] BUG: unable to handle kernel paging request at 0000000000002203
[   11.437745] IP: [<ffffffff810e4107>] unmap_vmas+0x227/0xa90
[   11.437764] PGD 0 
[   11.437771] Oops: 0000 [#1] PREEMPT SMP 
[   11.437782] last sysfs file: /sys/devices/pci0000:00/0000:00:1e.0/0000:86:09.4/local_cpus
[   11.437792] CPU 1 
[   11.437796] Modules linked in: binfmt_misc lp kvm_intel kvm tpm_infineon snd_hda_codec_atihdmi snd_hda_codec_analog fbcon tileblit font bitblit softcursor snd_hda_intel snd_hda_codec snd_hwdep arc4 snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi pcmcia snd_rawmidi joydev snd_seq_midi_event iwlagn radeon snd_seq iwlcore ttm snd_timer drm_kms_helper hp_accel mac80211 hp_wmi sdhci_pci ppdev sdhci snd_seq_device coretemp intel_agp yenta_socket lis3lv02d rsrc_nonstatic drm cfg80211 input_polldev parport_pc video snd tpm_tis psmouse serio_raw mmc_core pcmcia_core tpm parport output tpm_bios rfkill wmi soundcore i2c_algo_bit led_class snd_page_alloc acpi_cpufreq agpgart ext3 jbd mbcache xfs exportfs ahci libata e1000e ehci_hcd
[   11.437986] 
[   11.437994] Pid: 484, comm: udevd Not tainted 2.6.34-rc4 #19 30E7/HP EliteBook 8530p
[   11.438001] RIP: 0010:[<ffffffff810e4107>]  [<ffffffff810e4107>] unmap_vmas+0x227/0xa90
[   11.438015] RSP: 0018:ffff88013dae5cb8  EFLAGS: 00010206
[   11.438023] RAX: 0000000000002203 RBX: 00007f5fffe49000 RCX: 00007f5fffe49fff
[   11.438030] RDX: 0000000000001a13 RSI: ffff880001d0d818 RDI: 00007f5fffe4a000
[   11.438039] RBP: ffff88013dae5df8 R08: 0000000000000000 R09: 0000000000000000
[   11.438047] R10: ffff8800019eff68 R11: dead000000100100 R12: 00007f5fffe49000
[   11.438055] R13: 0000000000005e00 R14: ffff88013dacf240 R15: ffff88013ded9500
[   11.438064] FS:  0000000000000000(0000) GS:ffff880001d00000(0000) knlGS:0000000000000000
[   11.438072] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   11.438078] CR2: 0000000000002203 CR3: 0000000001805000 CR4: 00000000000406e0
[   11.438085] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   11.438094] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   11.438102] Process udevd (pid: 484, threadinfo ffff88013dae4000, task ffff88013dae8000)
[   11.438108] Stack:
[   11.438112]  0000000000000000 0000000000000000 0000000000000000 ffffea00045150c8
[   11.438125] <0> ffff88013fb0daa8 0000000000000000 ffff88013dae5e08 ffff88013ded9500
[   11.438138] <0> ffff88013dae5fd8 000000013fb0dab0 ffffffffffffffff 0000000000000000
[   11.438155] Call Trace:
[   11.438170]  [<ffffffff810e9cfb>] exit_mmap+0xcb/0x1d0
[   11.438180]  [<ffffffff81045772>] mmput+0x42/0x110
[   11.438190]  [<ffffffff8104a419>] exit_mm+0x109/0x140
[   11.438203]  [<ffffffff813f87c6>] ? _raw_spin_unlock_irq+0x26/0x50
[   11.438213]  [<ffffffff8108ce20>] ? acct_collect+0x160/0x1b0
[   11.438222]  [<ffffffff8104c47c>] do_exit+0x68c/0x7a0
[   11.438233]  [<ffffffff8104c5e1>] do_group_exit+0x51/0xc0
[   11.438242]  [<ffffffff8104c667>] sys_exit_group+0x17/0x20
[   11.438253]  [<ffffffff810030f2>] system_call_fastpath+0x16/0x1b
[   11.438260] Code: b8 00 00 00 00 80 ff ff ff 48 21 45 80 48 8b 45 80 48 ff c8 48 3b 85 40 ff ff ff 48 8b 85 50 ff ff ff 48 0f 42 7d 80 48 89 7d 80 <48> 8b 38 48 85 ff 0f 84 f5 04 00 00 48 b8 fb 0f 00 00 00 c0 ff 
[   11.438384] RIP  [<ffffffff810e4107>] unmap_vmas+0x227/0xa90
[   11.438395]  RSP <ffff88013dae5cb8>
[   11.438399] CR2: 0000000000002203
[   11.438407] ---[ end trace febcfea907e44126 ]---
[   11.438414] Fixing recursive fault but reboot is needed!
[   11.438420] BUG: scheduling while atomic: udevd/484/0x00000002
[   11.438426] Modules linked in: binfmt_misc lp kvm_intel kvm tpm_infineon snd_hda_codec_atihdmi snd_hda_codec_analog fbcon tileblit font bitblit softcursor snd_hda_intel snd_hda_codec snd_hwdep arc4 snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi pcmcia snd_rawmidi joydev snd_seq_midi_event iwlagn radeon snd_seq iwlcore ttm snd_timer drm_kms_helper hp_accel mac80211 hp_wmi sdhci_pci ppdev sdhci snd_seq_device coretemp intel_agp yenta_socket lis3lv02d rsrc_nonstatic drm cfg80211 input_polldev parport_pc video snd tpm_tis psmouse serio_raw mmc_core pcmcia_core tpm parport output tpm_bios rfkill wmi soundcore i2c_algo_bit led_class snd_page_alloc acpi_cpufreq agpgart ext3 jbd mbcache xfs exportfs ahci libata e1000e ehci_hcd
[   11.438612] Pid: 484, comm: udevd Tainted: G      D    2.6.34-rc4 #19
[   11.438619] Call Trace:
[   11.438629]  [<ffffffff81036f07>] __schedule_bug+0x77/0x80
[   11.438639]  [<ffffffff813f5ce5>] schedule+0x835/0x850
[   11.438650]  [<ffffffff8104c4dd>] do_exit+0x6ed/0x7a0
[   11.438660]  [<ffffffff813f8646>] ? _raw_spin_unlock_irqrestore+0x36/0x70
[   11.438670]  [<ffffffff8104919d>] ? kmsg_dump+0x16d/0x1a0
[   11.438680]  [<ffffffff813f9dbf>] oops_end+0xaf/0xf0
[   11.438692]  [<ffffffff8102a03b>] no_context+0xfb/0x260
[   11.438702]  [<ffffffff8102a2c5>] __bad_area_nosemaphore+0x125/0x1e0
[   11.438713]  [<ffffffff8102a393>] bad_area_nosemaphore+0x13/0x20
[   11.438722]  [<ffffffff813fc0c8>] do_page_fault+0x2f8/0x3b0
[   11.438732]  [<ffffffff813f8fe5>] page_fault+0x25/0x30
[   11.438743]  [<ffffffff810e4107>] ? unmap_vmas+0x227/0xa90
[   11.438752]  [<ffffffff810e435b>] ? unmap_vmas+0x47b/0xa90
[   11.438763]  [<ffffffff810e9cfb>] exit_mmap+0xcb/0x1d0
[   11.438771]  [<ffffffff81045772>] mmput+0x42/0x110
[   11.438780]  [<ffffffff8104a419>] exit_mm+0x109/0x140
[   11.438789]  [<ffffffff813f87c6>] ? _raw_spin_unlock_irq+0x26/0x50
[   11.438798]  [<ffffffff8108ce20>] ? acct_collect+0x160/0x1b0
[   11.438807]  [<ffffffff8104c47c>] do_exit+0x68c/0x7a0
[   11.438817]  [<ffffffff8104c5e1>] do_group_exit+0x51/0xc0
[   11.438825]  [<ffffffff8104c667>] sys_exit_group+0x17/0x20
[   11.438835]  [<ffffffff810030f2>] system_call_fastpath+0x16/0x1b
[   13.392447] CPUFREQ: Per core ondemand sysfs interface is deprecated - up_threshold
[   17.978781] hda-intel: IRQ timing workaround is activated for card #1. Suggest a bigger bdl_pos_adj.
[   18.690014] [drm] Requested: e: 60000 m: 70000 p: 16
[   18.690018] [drm] Setting: e: 60000 m: 70000 p: 16
[   19.500017] [drm] Requested: e: 33700 m: 40500 p: 16
[   19.500021] [drm] Setting: e: 33700 m: 40500 p: 16
[   35.017959] wlan0: deauthenticating from 00:1e:e5:6a:2c:c2 by local choice (reason=3)
[   35.018352] wlan0: authenticate with 00:1e:e5:6a:2c:c2 (try 1)
[   35.021359] wlan0: authenticated
[   35.021417] wlan0: associate with 00:1e:e5:6a:2c:c2 (try 1)
[   35.025312] wlan0: RX AssocResp from 00:1e:e5:6a:2c:c2 (capab=0x411 status=0 aid=5)
[   35.025321] wlan0: associated
[   35.028567] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   35.071074] Intel AES-NI instructions are not detected.
[   35.083429] padlock: VIA PadLock not detected.
[   45.300268] wlan0: no IPv6 routers present
[   71.708858] iwlagn 0000:03:00.0: iwl_tx_agg_start on ra = 00:1e:e5:6a:2c:c2 tid = 0
[ 1235.316848] [drm] Requested: e: 11000 m: 40500 p: 16
[ 1235.316859] [drm] Setting: e: 11000 m: 40500 p: 16
[ 1235.333251] [drm] Requested: e: 60000 m: 70000 p: 16
[ 1235.333255] [drm] Setting: e: 60000 m: 70000 p: 16
[ 1235.933293] [drm] Requested: e: 33700 m: 40500 p: 16
[ 1235.933305] [drm] Setting: e: 33700 m: 40500 p: 16
