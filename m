Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751769Ab0FFGM4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 02:12:56 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:45515 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405Ab0FFGMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 02:12:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=tvKqcoTTy7HeMDgpmpgIhshWFjG8Kn4RPD+WscGfnAsrrCteBw2Jjrjs2uxHkXfgBa
         73HzhFZJjJGBevFkdd5jgKrAcR/meeSUMeOLUdPMHoIUD4/oe8Qh2kA8IF1ss0DNn42s
         VoQ/3v+Khu5fSfXH36AK5ESrLaj0OXcTgf+mg=
Message-ID: <4C0B3C5B.5040703@gmail.com>
Date: Sat, 05 Jun 2010 23:12:43 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: BUG kmalloc-4096: Poison overwritten
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nice... on the first reboot of rc2
my macbookpro2,2 had a blank screen,
then on a reboot this showed up:
dmesg below.. not sure whats happening
if this is reproducible I'll bisect..
(last good commit:  52b0ace7dfe8)
dmesg:




[    0.000000] Linux version 2.6.35-rc2 (name@name) (gcc version 4.4.2 
(GCC) ) #27 SMP Sat Jun 5 22:51:41 PDT 2010
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz root=/dev/sda3 ro 
debug audit=1 selinux=1 vga=790 enforcing=0
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003f0ea000 (usable)
[    0.000000]  BIOS-e820: 000000003f0ea000 - 000000003f2eb000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003f2eb000 - 000000003febe000 (ACPI data)
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
[    0.000000] e820 update range: 0000000000000000 - 0000000000001000 
(usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 
(usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x3f0ea max_arch_pfn = 0x400000000
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
[    0.000000] init_memory_mapping: 0000000000000000-000000003f0ea000
[    0.000000]  0000000000 - 003f000000 page 2M
[    0.000000]  003f000000 - 003f0ea000 page 4k
[    0.000000] kernel direct mapping tables up to 3f0ea000 @ 8000-b000
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
[ffff880002200000-ffff880002ffffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000001 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   empty
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000001 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0003f0ea
[    0.000000] On node 0 totalpages: 258184
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3942 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 3476 pages used for memmap
[    0.000000]   DMA32 zone: 250710 pages, LIFO batch:31
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
[    0.000000] early_res array is doubled to 64 at [7000 - 77ff]
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
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff880001a00000 s85888 
r8192 d20608 u1048576
[    0.000000] pcpu-alloc: s85888 r8192 d20608 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on. 
Total pages: 254652
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz 
root=/dev/sda3 ro debug audit=1 selinux=1 vga=790 enforcing=0
[    0.000000] audit: enabled (after initialization)
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 8, 
1048576 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 7, 524288 
bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Subtract (48 early reservations)
[    0.000000]   #1 [0001000000 - 000186e4f0]   TEXT DATA BSS
[    0.000000]   #2 [000009fc00 - 0000100000]   BIOS reserved
[    0.000000]   #3 [000186f000 - 000186f271]             BRK
[    0.000000]   #4 [0000001000 - 0000003000]      TRAMPOLINE
[    0.000000]   #5 [0000003000 - 0000007000]     ACPI WAKEUP
[    0.000000]   #6 [0000008000 - 0000009000]         PGTABLE
[    0.000000]   #7 [000186f280 - 0001870280]         BOOTMEM
[    0.000000]   #8 [000186e500 - 000186e5c0]         BOOTMEM
[    0.000000]   #9 [0002071000 - 0002072000]         BOOTMEM
[    0.000000]   #10 [0002072000 - 0002073000]         BOOTMEM
[    0.000000]   #11 [0002200000 - 0003000000]        MEMMAP 0
[    0.000000]   #12 [000186e5c0 - 000186e840]         BOOTMEM
[    0.000000]   #13 [0001870280 - 000187a280]         BOOTMEM
[    0.000000]   #14 [000187b000 - 000187c000]         BOOTMEM
[    0.000000]   #15 [000186e840 - 000186e881]         BOOTMEM
[    0.000000]   #16 [000186e8c0 - 000186e903]         BOOTMEM
[    0.000000]   #17 [000186e940 - 000186ecc0]         BOOTMEM
[    0.000000]   #18 [000186ecc0 - 000186ed28]         BOOTMEM
[    0.000000]   #19 [000186ed40 - 000186eda8]         BOOTMEM
[    0.000000]   #20 [000186edc0 - 000186ee28]         BOOTMEM
[    0.000000]   #21 [000186ee40 - 000186eea8]         BOOTMEM
[    0.000000]   #22 [000186eec0 - 000186ef28]         BOOTMEM
[    0.000000]   #23 [000186ef40 - 000186efa8]         BOOTMEM
[    0.000000]   #24 [000187a280 - 000187a2e8]         BOOTMEM
[    0.000000]   #25 [000187a300 - 000187a368]         BOOTMEM
[    0.000000]   #26 [000187a380 - 000187a3e8]         BOOTMEM
[    0.000000]   #27 [000187a400 - 000187a468]         BOOTMEM
[    0.000000]   #28 [000187a480 - 000187a4e8]         BOOTMEM
[    0.000000]   #29 [000187a500 - 000187a568]         BOOTMEM
[    0.000000]   #30 [000187a580 - 000187a5e8]         BOOTMEM
[    0.000000]   #31 [000187a600 - 000187a668]         BOOTMEM
[    0.000000]   #32 [000187a680 - 000187a6e8]         BOOTMEM
[    0.000000]   #33 [000186efc0 - 000186efe0]         BOOTMEM
[    0.000000]   #34 [000187a700 - 000187a757]         BOOTMEM
[    0.000000]   #35 [000187a780 - 000187a7d7]         BOOTMEM
[    0.000000]   #36 [0001a00000 - 0001a1c000]         BOOTMEM
[    0.000000]   #37 [0001b00000 - 0001b1c000]         BOOTMEM
[    0.000000]   #38 [000187a800 - 000187a808]         BOOTMEM
[    0.000000]   #39 [000187a840 - 000187a848]         BOOTMEM
[    0.000000]   #40 [000187a880 - 000187a888]         BOOTMEM
[    0.000000]   #41 [000187a8c0 - 000187a8d0]         BOOTMEM
[    0.000000]   #42 [000187a900 - 000187aa40]         BOOTMEM
[    0.000000]   #43 [000187aa40 - 000187aaa0]         BOOTMEM
[    0.000000]   #44 [000187aac0 - 000187ab20]         BOOTMEM
[    0.000000]   #45 [000187c000 - 0001884000]         BOOTMEM
[    0.000000]   #46 [0001884000 - 0001984000]         BOOTMEM
[    0.000000]   #47 [0001a1c000 - 0001a9c000]         BOOTMEM
[    0.000000] Memory: 1007884k/1033128k available (4336k kernel code, 
392k absent, 24852k reserved, 2975k data, 508k init)
[    0.000000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, 
CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] 	Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:320
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration failed
[    0.000000] TSC: PIT calibration matches HPET. 1 loops
[    0.000000] Detected 2161.228 MHz processor.
[    0.002011] Calibrating delay loop (skipped), value calculated using 
timer frequency.. 4322.45 BogoMIPS (lpj=2161228)
[    0.002023] pid_max: default: 32768 minimum: 301
[    0.002038] 
=============================================================================
[    0.002046] BUG kmalloc-4096: Poison overwritten
[    0.002051] 
-----------------------------------------------------------------------------
[    0.002052]
[    0.002063] INFO: 0xffff88003ec09e00-0xffff88003ec09e9f. First byte 
0x20 instead of 0x6b
[    0.002073] INFO: Slab 0xffffea0000dba1c0 objects=7 used=1 
fp=0xffff88003ec09048 flags=0x40000000000040c3
[    0.002082] INFO: Object 0xffff88003ec09048 @offset=4168 
fp=0xffff88003ec0a090
[    0.002083]
[    0.002093] Bytes b4 0xffff88003ec09038:  00 00 00 00 00 00 00 00 5a 
5a 5a 5a 5a 5a 5a 5a ........ZZZZZZZZ
[    0.002114]   Object 0xffff88003ec09048:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002135]   Object 0xffff88003ec09058:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002155]   Object 0xffff88003ec09068:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002175]   Object 0xffff88003ec09078:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002196]   Object 0xffff88003ec09088:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002216]   Object 0xffff88003ec09098:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002237]   Object 0xffff88003ec090a8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002257]   Object 0xffff88003ec090b8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002277]   Object 0xffff88003ec090c8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002298]   Object 0xffff88003ec090d8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002318]   Object 0xffff88003ec090e8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002339]   Object 0xffff88003ec090f8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002359]   Object 0xffff88003ec09108:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002380]   Object 0xffff88003ec09118:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002400]   Object 0xffff88003ec09128:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002420]   Object 0xffff88003ec09138:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002441]   Object 0xffff88003ec09148:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002461]   Object 0xffff88003ec09158:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002482]   Object 0xffff88003ec09168:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002502]   Object 0xffff88003ec09178:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002523]   Object 0xffff88003ec09188:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002543]   Object 0xffff88003ec09198:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002563]   Object 0xffff88003ec091a8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002584]   Object 0xffff88003ec091b8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002604]   Object 0xffff88003ec091c8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002625]   Object 0xffff88003ec091d8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002645]   Object 0xffff88003ec091e8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002666]   Object 0xffff88003ec091f8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002686]   Object 0xffff88003ec09208:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002706]   Object 0xffff88003ec09218:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002727]   Object 0xffff88003ec09228:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002747]   Object 0xffff88003ec09238:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002768]   Object 0xffff88003ec09248:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002788]   Object 0xffff88003ec09258:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002809]   Object 0xffff88003ec09268:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002829]   Object 0xffff88003ec09278:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002849]   Object 0xffff88003ec09288:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002870]   Object 0xffff88003ec09298:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002890]   Object 0xffff88003ec092a8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002911]   Object 0xffff88003ec092b8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002931]   Object 0xffff88003ec092c8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002952]   Object 0xffff88003ec092d8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002972]   Object 0xffff88003ec092e8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002993]   Object 0xffff88003ec092f8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09308:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09318:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09328:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09338:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09348:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09358:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09368:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09378:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09388:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09398:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec093a8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec093b8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec093c8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec093d8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec093e8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec093f8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09408:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09418:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09428:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09438:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09448:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09458:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09468:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09478:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09488:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09498:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec094a8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec094b8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec094c8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec094d8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec094e8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec094f8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09508:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09518:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09528:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09538:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09548:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09558:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09568:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09578:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09588:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09598:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec095a8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec095b8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec095c8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec095d8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec095e8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec095f8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09608:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09618:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09628:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09638:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09648:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09658:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09668:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09678:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09688:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09698:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec096a8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec096b8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec096c8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec096d8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec096e8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec096f8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09708:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09718:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09728:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09738:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09748:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09758:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09768:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09778:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09788:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09798:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec097a8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec097b8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec097c8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec097d8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec097e8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec097f8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09808:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09818:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09828:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09838:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09848:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09858:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09868:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09878:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09888:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09898:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec098a8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec098b8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec098c8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec098d8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec098e8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec098f8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09908:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09918:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09928:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09938:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09948:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09958:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09968:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09978:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09988:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09998:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec099a8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec099b8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec099c8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec099d8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec099e8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec099f8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09a08:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09a18:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09a28:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09a38:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09a48:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09a58:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09a68:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09a78:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09a88:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09a98:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09aa8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09ab8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09ac8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09ad8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09ae8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09af8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09b08:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09b18:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09b28:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09b38:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09b48:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09b58:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09b68:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09b78:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09b88:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09b98:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09ba8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09bb8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09bc8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09bd8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09be8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09bf8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09c08:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09c18:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09c28:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09c38:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09c48:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09c58:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09c68:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09c78:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09c88:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09c98:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09ca8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09cb8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09cc8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09cd8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09ce8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09cf8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09d08:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09d18:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09d28:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09d38:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09d48:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09d58:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09d68:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09d78:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09d88:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09d98:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09da8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09db8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09dc8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09dd8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09de8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09df8:  6b 6b 6b 6b 6b 6b 6b 6b 20 
07 20 07 20 07 20 07 kkkkkkkk........
[    0.002999]   Object 0xffff88003ec09e08:  20 07 20 07 20 07 20 07 20 
07 20 07 20 07 20 07 ................
[    0.002999]   Object 0xffff88003ec09e18:  20 07 20 07 20 07 20 07 20 
07 20 07 20 07 20 07 ................
[    0.002999]   Object 0xffff88003ec09e28:  20 07 20 07 20 07 20 07 20 
07 20 07 20 07 20 07 ................
[    0.002999]   Object 0xffff88003ec09e38:  20 07 20 07 20 07 20 07 20 
07 20 07 20 07 20 07 ................
[    0.002999]   Object 0xffff88003ec09e48:  20 07 20 07 20 07 20 07 20 
07 20 07 20 07 20 07 ................
[    0.002999]   Object 0xffff88003ec09e58:  20 07 20 07 20 07 20 07 20 
07 20 07 20 07 20 07 ................
[    0.002999]   Object 0xffff88003ec09e68:  20 07 20 07 20 07 20 07 20 
07 20 07 20 07 20 07 ................
[    0.002999]   Object 0xffff88003ec09e78:  20 07 20 07 20 07 20 07 20 
07 20 07 20 07 20 07 ................
[    0.002999]   Object 0xffff88003ec09e88:  20 07 20 07 20 07 20 07 20 
07 20 07 20 07 20 07 ................
[    0.002999]   Object 0xffff88003ec09e98:  20 07 20 07 20 07 20 07 6b 
6b 6b 6b 6b 6b 6b 6b ........kkkkkkkk
[    0.002999]   Object 0xffff88003ec09ea8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09eb8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09ec8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09ed8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09ee8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09ef8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09f08:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09f18:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09f28:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09f38:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09f48:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09f58:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09f68:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09f78:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09f88:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09f98:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09fa8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09fb8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09fc8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09fd8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09fe8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec09ff8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec0a008:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec0a018:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec0a028:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[    0.002999]   Object 0xffff88003ec0a038:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b a5 kkkkkkkkkkkkkkk¥
[    0.002999]  Redzone 0xffff88003ec0a048:  bb bb bb bb bb bb bb bb 
                      »»»»»»»»
[    0.002999]  Padding 0xffff88003ec0a088:  5a 5a 5a 5a 5a 5a 5a 5a 
                      ZZZZZZZZ
[    0.002999] Pid: 0, comm: swapper Not tainted 2.6.35-rc2 #27
[    0.002999] Call Trace:
[    0.002999]  [<ffffffff810e377c>] print_trailer+0x12e/0x137
[    0.002999]  [<ffffffff810e3ca0>] check_bytes_and_report+0xb5/0xe6
[    0.002999]  [<ffffffff810e3d92>] check_object+0xc1/0x1f6
[    0.002999]  [<ffffffff810e54a9>] __slab_alloc+0x467/0x577
[    0.002999]  [<ffffffff8174d83f>] ? pidmap_init+0x82/0x10a
[    0.002999]  [<ffffffff8174d83f>] ? pidmap_init+0x82/0x10a
[    0.002999]  [<ffffffff810e5830>] kmem_cache_alloc_notrace+0x60/0xa3
[    0.002999]  [<ffffffff8174d83f>] pidmap_init+0x82/0x10a
[    0.002999]  [<ffffffff8173ac99>] start_kernel+0x320/0x392
[    0.002999]  [<ffffffff8173a2ac>] x86_64_start_reservations+0xb3/0xb7
[    0.002999]  [<ffffffff8173a3a8>] x86_64_start_kernel+0xf8/0x107
[    0.002999] FIX kmalloc-4096: Restoring 
0xffff88003ec09e00-0xffff88003ec09e9f=0x6b
[    0.002999]
[    0.002999] FIX kmalloc-4096: Marking all objects used
[    0.003105] Security Framework initialized
[    0.003116] SELinux:  Initializing.
[    0.003406] SELinux:  Starting in permissive mode
[    0.004022] Mount-cache hash table entries: 256
[    0.004663] CPU: Physical Processor ID: 0
[    0.004668] CPU: Processor Core ID: 0
[    0.004674] mce: CPU supports 6 MCE banks
[    0.004688] CPU0: Thermal monitoring enabled (TM2)
[    0.004695] using mwait in idle threads.
[    0.004699] Performance Events: PEBS fmt0-, Core2 events, Intel PMU 
driver.
[    0.004710] PEBS disabled due to CPU errata.
[    0.004718] ... version:                2
[    0.004723] ... bit width:              40
[    0.004728] ... generic registers:      2
[    0.004732] ... value mask:             000000ffffffffff
[    0.004738] ... max period:             000000007fffffff
[    0.004743] ... fixed-purpose events:   3
[    0.004747] ... event mask:             0000000700000003
[    0.005633] ACPI: Core revision 20100428
[    0.026681] Setting APIC routing to flat
[    0.026999] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.037087] CPU0: Intel(R) Core(TM)2 CPU         T7400  @ 2.16GHz 
stepping 06
[    0.037999] Booting Node   0, Processors  #1 Ok.
[    0.109027] Brought up 2 CPUs
[    0.109035] Total of 2 processors activated (8644.77 BogoMIPS).
[    0.112043] NET: Registered protocol family 16
[    0.113111] ACPI: bus type pci registered
[    0.113156] PCI: Using configuration type 1 for base access
[    0.133059] bio: create slab <bio-0> at 0
[    0.135427] ACPI: EC: EC description table is found, configuring boot EC
[    0.143681] ACPI: BIOS _OSI(Linux) query ignored
[    0.146946] ACPI: SSDT 000000003feb8c10 002AE (v01 APPLE   Cpu0Ist 
00003000 INTL 20050309)
[    0.147784] ACPI: Dynamic OEM Table Load:
[    0.147792] ACPI: SSDT (null) 002AE (v01 APPLE   Cpu0Ist 00003000 
INTL 20050309)
[    0.148739] ACPI: SSDT 000000003feb8910 002A0 (v01 APPLE   Cpu0Cst 
00003001 INTL 20050309)
[    0.149473] ACPI: Dynamic OEM Table Load:
[    0.149480] ACPI: SSDT (null) 002A0 (v01 APPLE   Cpu0Cst 00003001 
INTL 20050309)
[    0.151526] ACPI: SSDT 000000003feb8f10 00087 (v01 APPLE   Cpu1Ist 
00003000 INTL 20050309)
[    0.152304] ACPI: Dynamic OEM Table Load:
[    0.152311] ACPI: SSDT (null) 00087 (v01 APPLE   Cpu1Ist 00003000 
INTL 20050309)
[    0.153119] ACPI: SSDT 000000003feb7f10 00085 (v01 APPLE   Cpu1Cst 
00003000 INTL 20050309)
[    0.153841] ACPI: Dynamic OEM Table Load:
[    0.153849] ACPI: SSDT (null) 00085 (v01 APPLE   Cpu1Cst 00003000 
INTL 20050309)
[    0.154050] ACPI: Interpreter enabled
[    0.154057] ACPI: (supports S0 S3 S4 S5)
[    0.154164] ACPI: Using IOAPIC for interrupt routing
[    0.189260] ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
[    0.190511] ACPI: No dock devices found.
[    0.190518] PCI: Ignoring host bridge windows from ACPI; if 
necessary, use "pci=use_crs" and report a bug
[    0.194063] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.199432] pci_root PNP0A08:00: host bridge window [io 
0x0000-0x0cf7] (ignored)
[    0.199442] pci_root PNP0A08:00: host bridge window [io 
0x0d00-0xffff] (ignored)
[    0.199451] pci_root PNP0A08:00: host bridge window [mem 
0x000a0000-0x000bffff] (ignored)
[    0.199461] pci_root PNP0A08:00: host bridge window [mem 
0x40000000-0xfebfffff] (ignored)
[    0.199568] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.199575] pci 0000:00:01.0: PME# disabled
[    0.199613] pci 0000:00:07.0: reg 10: [mem 0x50404000-0x50404fff]
[    0.199714] pci 0000:00:1b.0: reg 10: [mem 0x50400000-0x50403fff 64bit]
[    0.199782] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.199790] pci 0000:00:1b.0: PME# disabled
[    0.199896] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.199905] pci 0000:00:1c.0: PME# disabled
[    0.200043] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.200052] pci 0000:00:1c.1: PME# disabled
[    0.200161] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.200169] pci 0000:00:1c.2: PME# disabled
[    0.200243] pci 0000:00:1d.0: reg 20: [io  0x4080-0x409f]
[    0.200316] pci 0000:00:1d.1: reg 20: [io  0x4060-0x407f]
[    0.200390] pci 0000:00:1d.2: reg 20: [io  0x4040-0x405f]
[    0.200463] pci 0000:00:1d.3: reg 20: [io  0x4020-0x403f]
[    0.200534] pci 0000:00:1d.7: reg 10: [mem 0x50405400-0x504057ff]
[    0.200602] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.200612] pci 0000:00:1d.7: PME# disabled
[    0.200826] pci 0000:00:1f.0: quirk: [io  0x0400-0x047f] claimed by 
ICH6 ACPI/GPIO/TCO
[    0.200838] pci 0000:00:1f.0: quirk: [io  0x0500-0x053f] claimed by 
ICH6 GPIO
[    0.200847] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 
0680 (mask 000f)
[    0.200858] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 
1640 (mask 000f)
[    0.200870] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 4 PIO at 
0300 (mask 001f)
[    0.200933] pci 0000:00:1f.1: reg 10: [io  0x40d8-0x40df]
[    0.200944] pci 0000:00:1f.1: reg 14: [io  0x40ec-0x40ef]
[    0.200956] pci 0000:00:1f.1: reg 18: [io  0x40d0-0x40d7]
[    0.200968] pci 0000:00:1f.1: reg 1c: [io  0x40e8-0x40eb]
[    0.200980] pci 0000:00:1f.1: reg 20: [io  0x40b0-0x40bf]
[    0.201046] pci 0000:00:1f.2: reg 10: [io  0x40c8-0x40cf]
[    0.201058] pci 0000:00:1f.2: reg 14: [io  0x40e4-0x40e7]
[    0.201069] pci 0000:00:1f.2: reg 18: [io  0x40c0-0x40c7]
[    0.201081] pci 0000:00:1f.2: reg 1c: [io  0x40e0-0x40e3]
[    0.201093] pci 0000:00:1f.2: reg 20: [io  0x40a0-0x40af]
[    0.201105] pci 0000:00:1f.2: reg 24: [mem 0x50405000-0x504053ff]
[    0.201140] pci 0000:00:1f.2: PME# supported from D3hot
[    0.201148] pci 0000:00:1f.2: PME# disabled
[    0.201218] pci 0000:00:1f.3: reg 20: [io  0xefa0-0xefbf]
[    0.201321] pci 0000:01:00.0: reg 10: [mem 0x40000000-0x47ffffff pref]
[    0.201333] pci 0000:01:00.0: reg 14: [io  0x3000-0x30ff]
[    0.201345] pci 0000:01:00.0: reg 18: [mem 0x50300000-0x5030ffff]
[    0.201368] pci 0000:01:00.0: reg 30: [mem 0xfffe0000-0xffffffff pref]
[    0.201398] pci 0000:01:00.0: supports D1 D2
[    0.201413] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.201421] pci 0000:00:01.0:   bridge window [io  0x3000-0x3fff]
[    0.201428] pci 0000:00:01.0:   bridge window [mem 0x50300000-0x503fffff]
[    0.201437] pci 0000:00:01.0:   bridge window [mem 
0x40000000-0x47ffffff 64bit pref]
[    0.201562] pci 0000:02:00.0: reg 10: [mem 0x50200000-0x50203fff 64bit]
[    0.201577] pci 0000:02:00.0: reg 18: [io  0x2000-0x20ff]
[    0.201616] pci 0000:02:00.0: reg 30: [mem 0xfffe0000-0xffffffff pref]
[    0.201676] pci 0000:02:00.0: supports D1 D2
[    0.201681] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.201691] pci 0000:02:00.0: PME# disabled
[    0.201708] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.201717] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.201726] pci 0000:00:1c.0:   bridge window [mem 0x50200000-0x502fffff]
[    0.201738] pci 0000:00:1c.0:   bridge window [mem 
0xfff00000-0x000fffff pref] (disabled)
[    0.201859] pci 0000:03:00.0: reg 10: [mem 0x50100000-0x5010ffff 64bit]
[    0.201957] pci 0000:03:00.0: supports D1
[    0.201962] pci 0000:03:00.0: PME# supported from D0 D1 D3hot
[    0.201971] pci 0000:03:00.0: PME# disabled
[    0.202002] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.202011] pci 0000:00:1c.1:   bridge window [io  0xf000-0x0000] 
(disabled)
[    0.202020] pci 0000:00:1c.1:   bridge window [mem 0x50100000-0x501fffff]
[    0.202033] pci 0000:00:1c.1:   bridge window [mem 
0xfff00000-0x000fffff pref] (disabled)
[    0.202105] pci 0000:00:1c.2: PCI bridge to [bus 04-0b]
[    0.202114] pci 0000:00:1c.2:   bridge window [io  0x1000-0x1fff]
[    0.202123] pci 0000:00:1c.2:   bridge window [mem 0x4c100000-0x500fffff]
[    0.202135] pci 0000:00:1c.2:   bridge window [mem 
0x48000000-0x4bffffff 64bit pref]
[    0.202223] pci 0000:0c:03.0: reg 10: [mem 0x4c004000-0x4c0047ff]
[    0.202236] pci 0000:0c:03.0: reg 14: [mem 0x4c000000-0x4c003fff]
[    0.202304] pci 0000:0c:03.0: supports D1 D2
[    0.202309] pci 0000:0c:03.0: PME# supported from D0 D1 D2 D3hot
[    0.202318] pci 0000:0c:03.0: PME# disabled
[    0.202385] pci 0000:00:1e.0: PCI bridge to [bus 0c-0c] (subtractive 
decode)
[    0.202394] pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] 
(disabled)
[    0.202404] pci 0000:00:1e.0:   bridge window [mem 0x4c000000-0x4c0fffff]
[    0.202416] pci 0000:00:1e.0:   bridge window [mem 
0xfff00000-0x000fffff pref] (disabled)
[    0.202426] pci 0000:00:1e.0:   bridge window [io  0x0000-0xffff] 
(subtractive decode)
[    0.202435] pci 0000:00:1e.0:   bridge window [mem 
0x00000000-0xffffffffffffffff] (subtractive decode)
[    0.202472] pci_bus 0000:00: on NUMA node 0
[    0.202484] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.203746] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEGP._PRT]
[    0.204177] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.204595] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.205018] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
[    0.205519] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
[    0.240322] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 
14 15) *11
[    0.240682] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 *11 12 
14 15)
[    0.241121] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 
14 15) *11
[    0.241464] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 *11 12 
14 15)
[    0.241804] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 
14 15) *0, disabled.
[    0.242248] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 
14 15) *0, disabled.
[    0.242598] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 *10 12 
14 15)
[    0.242935] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *11 12 14 15)
[    0.243123] vgaarb: device added: 
PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.243123] vgaarb: loaded
[    0.244097] SCSI subsystem initialized
[    0.244097] libata version 3.00 loaded.
[    0.244119] usbcore: registered new interface driver usbfs
[    0.245057] usbcore: registered new interface driver hub
[    0.245084] usbcore: registered new device driver usb
[    0.246098] Advanced Linux Sound Architecture Driver Version 1.0.23.
[    0.246105] PCI: Using ACPI for IRQ routing
[    0.246111] PCI: pci_cache_line_size set to 64 bytes
[    0.246278] reserve RAM buffer: 000000000009fc00 - 000000000009ffff
[    0.246284] reserve RAM buffer: 000000003f0ea000 - 000000003fffffff
[    0.247253] cfg80211: Calling CRDA to update world regulatory domain
[    0.247253] NetLabel: Initializing
[    0.247253] NetLabel:  domain hash size = 128
[    0.247253] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.247253] NetLabel:  unlabeled traffic allowed by default
[    0.247253] HPET: 3 timers in total, 0 timers will be used for 
per-cpu timer
[    0.247253] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.247253] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.250059] Switching to clocksource tsc
[    0.262416] pnp: PnP ACPI init
[    0.262460] ACPI: bus type pnp registered
[    0.269036] pnp 00:07: disabling [io  0x1640-0x164f] because it 
overlaps 0000:00:1c.2 BAR 7 [io  0x1000-0x1fff]
[    0.272411] pnp: PnP ACPI: found 9 devices
[    0.272417] ACPI: ACPI bus type pnp unregistered
[    0.272438] system 00:01: [mem 0xf0000000-0xf3ffffff] has been reserved
[    0.272446] system 00:01: [mem 0xfed14000-0xfed17fff] has been reserved
[    0.272454] system 00:01: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.272461] system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.272469] system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.272477] system 00:01: [mem 0xfed20000-0xfed8ffff] has been reserved
[    0.272491] system 00:05: [mem 0xfed00000-0xfed003ff] has been reserved
[    0.272505] system 00:07: [io  0x0680-0x06ef] has been reserved
[    0.272513] system 00:07: [io  0x0800-0x080f] has been reserved
[    0.272520] system 00:07: [io  0x0810-0x0817] has been reserved
[    0.272527] system 00:07: [io  0x0400-0x047f] has been reserved
[    0.272535] system 00:07: [io  0x0500-0x053f] has been reserved
[    0.279648] pci 0000:01:00.0: no compatible bridge window for [mem 
0xfffe0000-0xffffffff pref]
[    0.279661] pci 0000:02:00.0: no compatible bridge window for [mem 
0xfffe0000-0xffffffff pref]
[    0.279728] pci 0000:00:1c.0: BAR 9: assigned [mem 
0x50500000-0x506fffff pref]
[    0.279738] pci 0000:00:1c.1: BAR 9: assigned [mem 
0x50700000-0x508fffff 64bit pref]
[    0.279748] pci 0000:00:1c.1: BAR 7: assigned [io  0x5000-0x5fff]
[    0.279756] pci 0000:01:00.0: BAR 6: assigned [mem 
0x50320000-0x5033ffff pref]
[    0.279766] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.279773] pci 0000:00:01.0:   bridge window [io  0x3000-0x3fff]
[    0.279780] pci 0000:00:01.0:   bridge window [mem 0x50300000-0x503fffff]
[    0.279788] pci 0000:00:01.0:   bridge window [mem 
0x40000000-0x47ffffff 64bit pref]
[    0.279833] pci 0000:02:00.0: BAR 6: assigned [mem 
0x50500000-0x5051ffff pref]
[    0.279842] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.279849] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.279859] pci 0000:00:1c.0:   bridge window [mem 0x50200000-0x502fffff]
[    0.279868] pci 0000:00:1c.0:   bridge window [mem 
0x50500000-0x506fffff pref]
[    0.279882] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.279889] pci 0000:00:1c.1:   bridge window [io  0x5000-0x5fff]
[    0.279900] pci 0000:00:1c.1:   bridge window [mem 0x50100000-0x501fffff]
[    0.279908] pci 0000:00:1c.1:   bridge window [mem 
0x50700000-0x508fffff 64bit pref]
[    0.279923] pci 0000:00:1c.2: PCI bridge to [bus 04-0b]
[    0.279930] pci 0000:00:1c.2:   bridge window [io  0x1000-0x1fff]
[    0.279940] pci 0000:00:1c.2:   bridge window [mem 0x4c100000-0x500fffff]
[    0.279949] pci 0000:00:1c.2:   bridge window [mem 
0x48000000-0x4bffffff 64bit pref]
[    0.279963] pci 0000:00:1e.0: PCI bridge to [bus 0c-0c]
[    0.279969] pci 0000:00:1e.0:   bridge window [io  disabled]
[    0.279979] pci 0000:00:1e.0:   bridge window [mem 0x4c000000-0x4c0fffff]
[    0.279987] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    0.280010] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.280019] pci 0000:00:01.0: setting latency timer to 64
[    0.280034] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.280043] pci 0000:00:1c.0: setting latency timer to 64
[    0.280057] pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.280066] pci 0000:00:1c.1: setting latency timer to 64
[    0.280082] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.280090] pci 0000:00:1c.2: setting latency timer to 64
[    0.280266] pci 0000:00:1e.0: power state changed by ACPI to D0
[    0.280435] pci 0000:00:1e.0: power state changed by ACPI to D0
[    0.280446] pci 0000:00:1e.0: setting latency timer to 64
[    0.280454] pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
[    0.280460] pci_bus 0000:00: resource 1 [mem 
0x00000000-0xffffffffffffffff]
[    0.280467] pci_bus 0000:01: resource 0 [io  0x3000-0x3fff]
[    0.280473] pci_bus 0000:01: resource 1 [mem 0x50300000-0x503fffff]
[    0.280479] pci_bus 0000:01: resource 2 [mem 0x40000000-0x47ffffff 
64bit pref]
[    0.280487] pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
[    0.280493] pci_bus 0000:02: resource 1 [mem 0x50200000-0x502fffff]
[    0.280499] pci_bus 0000:02: resource 2 [mem 0x50500000-0x506fffff pref]
[    0.280506] pci_bus 0000:03: resource 0 [io  0x5000-0x5fff]
[    0.280512] pci_bus 0000:03: resource 1 [mem 0x50100000-0x501fffff]
[    0.280518] pci_bus 0000:03: resource 2 [mem 0x50700000-0x508fffff 
64bit pref]
[    0.280526] pci_bus 0000:04: resource 0 [io  0x1000-0x1fff]
[    0.280532] pci_bus 0000:04: resource 1 [mem 0x4c100000-0x500fffff]
[    0.280538] pci_bus 0000:04: resource 2 [mem 0x48000000-0x4bffffff 
64bit pref]
[    0.280546] pci_bus 0000:0c: resource 1 [mem 0x4c000000-0x4c0fffff]
[    0.280552] pci_bus 0000:0c: resource 4 [io  0x0000-0xffff]
[    0.280558] pci_bus 0000:0c: resource 5 [mem 
0x00000000-0xffffffffffffffff]
[    0.280639] NET: Registered protocol family 2
[    0.280738] IP route cache hash table entries: 32768 (order: 6, 
262144 bytes)
[    0.281305] TCP established hash table entries: 131072 (order: 9, 
2097152 bytes)
[    0.282380] TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
[    0.283818] TCP: Hash tables configured (established 131072 bind 65536)
[    0.283828] TCP reno registered
[    0.283840] UDP hash table entries: 512 (order: 3, 49152 bytes)
[    0.283880] UDP-Lite hash table entries: 512 (order: 3, 49152 bytes)
[    0.284219] NET: Registered protocol family 1
[    0.284422] pci 0000:01:00.0: Boot video device
[    0.284445] PCI: CLS mismatch (256 != 64), using 64 bytes
[    0.288514] microcode: CPU0 sig=0x6f6, pf=0x20, revision=0xc7
[    0.288529] microcode: CPU1 sig=0x6f6, pf=0x20, revision=0xc7
[    0.288668] microcode: Microcode Update Driver: v2.00 
<tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.290732] Initializing RT-Tester: OK
[    0.290900] audit: initializing netlink socket (enabled)
[    0.291010] type=2000 audit(1275804133.289:1): initialized
[    0.308158] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.331957] ROMFS MTD (C) 2007 Red Hat, Inc.
[    0.332315] fuse init (API version 7.14)
[    0.333240] msgmni has been set to 1968
[    0.333540] SELinux:  Registering netfilter hooks
[    0.335109] alg: No test for stdrng (krng)
[    0.335134] io scheduler noop registered
[    0.335564] io scheduler cfq registered (default)
[    0.337004] vesafb: framebuffer at 0x40000000, mapped to 
0xffffc90000100000, using 3072k, total 3072k
[    0.337014] vesafb: mode is 1024x768x32, linelength=4096, pages=0
[    0.337020] vesafb: scrolling: redraw
[    0.337026] vesafb: Truecolor: size=0:8:8:8, shift=0:16:8:0
[    0.337235] fbcon: VESA VGA (fb0) is primary device
[    0.385345] Console: switching to colour frame buffer device 128x48
[    0.429606] fb0: VESA VGA frame buffer device
[    0.447375] Linux agpgart interface v0.103
[    0.451435] loop: module loaded
[    0.453085] ata_piix 0000:00:1f.1: version 2.13
[    0.453622] ata_piix 0000:00:1f.1: power state changed by ACPI to D0
[    0.454422] ata_piix 0000:00:1f.1: power state changed by ACPI to D0
[    0.455008] ata_piix 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) 
-> IRQ 18
[    0.455701] ata_piix 0000:00:1f.1: setting latency timer to 64
[    0.456348] scsi0 : ata_piix
[    0.457452] scsi1 : ata_piix
[    0.460513] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x40b0 
irq 14
[    0.461146] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x40b8 
irq 15
[    0.461809] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) 
-> IRQ 19
[    0.462590] ata_piix 0000:00:1f.2: MAP [ P0 P2 -- -- ]
[    0.624904] ata_piix 0000:00:1f.2: setting latency timer to 64
[    0.625578] scsi2 : ata_piix
[    0.626334] ata1.00: ATAPI: MATSHITADVD-R   UJ-857D, KCV9, max UDMA/66
[    0.626640] scsi3 : ata_piix
[    0.631339] ata3: SATA max UDMA/133 cmd 0x40c8 ctl 0x40e4 bmdma 
0x40a0 irq 19
[    0.631342] ata4: SATA max UDMA/133 cmd 0x40c0 ctl 0x40e0 bmdma 
0x40a8 irq 19
[    0.631647] usbcore: registered new interface driver usblcd
[    0.631772] usbcore: registered new interface driver usbled
[    0.632255] PNP: No PS/2 controller found. Probing ports directly.
[    0.633122] i8042.c: No controller found.
[    0.633407] mice: PS/2 mouse device common for all mice
[    0.633726] IR NEC protocol handler initialized
[    0.633728] IR RC5(x) protocol handler initialized
[    0.633729] IR RC6 protocol handler initialized
[    0.633731] IR JVC protocol handler initialized
[    0.633733] IR Sony protocol handler initialized
[    0.633734] Linux video capture interface: v2.00
[    0.635401] device-mapper: ioctl: 4.17.0-ioctl (2010-03-05) 
initialised: dm-devel@redhat.com
[    0.635403] EDAC MC: Ver: 2.1.0 Jun  5 2010
[    0.635792] cpuidle: using governor ladder
[    0.635795] cpuidle: using governor menu
[    0.639594] usbcore: registered new interface driver hiddev
[    0.639717] usbcore: registered new interface driver usbhid
[    0.639719] usbhid: USB HID core driver
[    0.640000] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) 
-> IRQ 22
[    0.640065] HDA Intel 0000:00:1b.0: irq 40 for MSI/MSI-X
[    0.640120] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    0.649971] hda_codec: STAC922x, Apple subsys_id=106b1e00
[    0.655501] ALSA device list:
[    0.655503]   #0: HDA Intel at 0x50400000 irq 40
[    0.655740] oprofile: using NMI interrupt.
[    0.656073] IPVS: Registered protocols (TCP, AH, ESP)
[    0.656288] IPVS: Connection hash table configured (size=4096, 
memory=64Kbytes)
[    0.656352] IPVS: ipvs loaded.
[    0.656621] Initializing XFRM netlink socket
[    0.656644] NET: Registered protocol family 17
[    0.656695] NET: Registered protocol family 15
[    0.656697] lib80211: common routines for IEEE802.11 drivers
[    0.656700] lib80211_crypt: registered algorithm 'NULL'
[    0.657236] IMA: No TPM chip found, activating TPM-bypass!
[    0.816148] ata3.01: ATA-8: FUJITSU MHW2120BH, 00810013, max UDMA/100
[    0.816151] ata3.01: 234441648 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    0.822166] ata3.01: configured for UDMA/100
[    1.108308] ata1.00: configured for UDMA/66
[    1.124600] scsi 0:0:0:0: CD-ROM            MATSHITA DVD-R   UJ-857D 
  KCV9 PQ: 0 ANSI: 5
[    1.143967] sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
[    1.158730] Uniform CD-ROM driver Revision: 3.20
[    1.173609] sr 0:0:0:0: Attached scsi CD-ROM sr0
[    1.188703] sr 0:0:0:0: Attached scsi generic sg0 type 5
[    1.203357] scsi 2:0:1:0: Direct-Access     ATA      FUJITSU MHW2120B 
0081 PQ: 0 ANSI: 5
[    1.219201] sd 2:0:1:0: [sda] 234441648 512-byte logical blocks: (120 
GB/111 GiB)
[    1.234679] sd 2:0:1:0: Attached scsi generic sg1 type 0
[    1.249900] sd 2:0:1:0: [sda] Write Protect is off
[    1.264907] sd 2:0:1:0: [sda] Mode Sense: 00 3a 00 00
[    1.279876] sd 2:0:1:0: [sda] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[    1.295726]  sda: sda1 sda2 sda3 sda4
[    1.376638] sd 2:0:1:0: [sda] Attached SCSI disk
[    1.451576] EXT4-fs (sda3): mounted filesystem with ordered data 
mode. Opts: (null)
[    1.467941] VFS: Mounted root (ext4 filesystem) readonly on device 8:3.
[    1.484419] Freeing unused kernel memory: 508k freed
[    2.023359] SELinux: 2048 avtab hash slots, 175804 rules.
[    2.205660] SELinux: 2048 avtab hash slots, 175804 rules.
[    2.759578] SELinux:  7 users, 14 roles, 3026 types, 119 bools, 1 
sens, 256 cats
[    2.775922] SELinux:  77 classes, 175804 rules
[    2.803065] SELinux:  Completing initialization.
[    2.819359] SELinux:  Setting up existing superblocks.
[    2.835635] SELinux: initialized (dev sysfs, type sysfs), uses 
genfs_contexts
[    2.852043] SELinux: initialized (dev rootfs, type rootfs), uses 
genfs_contexts
[    2.868519] SELinux: initialized (dev bdev, type bdev), uses 
genfs_contexts
[    2.885085] SELinux: initialized (dev proc, type proc), uses 
genfs_contexts
[    2.901369] SELinux: initialized (dev tmpfs, type tmpfs), uses 
transition SIDs
[    2.901391] SELinux: initialized (dev sockfs, type sockfs), uses task 
SIDs
[    2.901397] SELinux: initialized (dev debugfs, type debugfs), uses 
genfs_contexts
[    2.902263] SELinux: initialized (dev pipefs, type pipefs), uses task 
SIDs
[    2.902270] SELinux: initialized (dev anon_inodefs, type 
anon_inodefs), uses genfs_contexts
[    2.902276] SELinux: initialized (dev devpts, type devpts), uses 
transition SIDs
[    2.902305] SELinux: initialized (dev hugetlbfs, type hugetlbfs), 
uses transition SIDs
[    2.902324] SELinux: initialized (dev mqueue, type mqueue), uses 
transition SIDs
[    2.902332] SELinux: initialized (dev selinuxfs, type selinuxfs), 
uses genfs_contexts
[    2.902378] SELinux: initialized (dev securityfs, type securityfs), 
uses genfs_contexts
[    2.902397] SELinux: initialized (dev sda3, type ext4), uses xattr
[    3.103042] type=1403 audit(1275804136.102:2): policy loaded 
auid=4294967295 ses=4294967295
[    3.639755] SELinux: initialized (dev sysfs, type sysfs), uses 
genfs_contexts
[    4.011668] usbcore: registered new interface driver uvcvideo
[    4.030119] USB Video Class driver (v0.1.0)
[    4.093473] applesmc: Apple MacBook Pro 2,2 detected:
[    4.112342] applesmc:  - Model with accelerometer
[    4.131839] applesmc:  - Model with light sensors and backlight
[    4.151525] applesmc:  - Model with 12 temperature sensors
[    4.171793] applesmc: device has already been initialized (0xe0, 0x00).
[    4.171795] applesmc: device successfully initialized.
[    4.191413] applesmc: 2 fans found.
[    4.211652] input: applesmc as 
/devices/platform/applesmc.768/input/input0
[    4.231157] Registered led device: smc::kbd_backlight
[    4.231346] applesmc: driver successfully loaded.
[    4.263867] usbcore: registered new interface driver appletouch
[    4.316717] ACPI: acpi_idle registered with cpuidle
[    4.317443] Monitor-Mwait will be used to enter C-1 state
[    4.317489] Monitor-Mwait will be used to enter C-2 state
[    4.317532] Monitor-Mwait will be used to enter C-3 state
[    4.317540] Marking TSC unstable due to TSC halts in idle
[    4.336962] Switching to clocksource hpet
[    4.377841] coretemp coretemp.0: TjMax is assumed as 100 C!
[    4.404038] coretemp coretemp.1: TjMax is assumed as 100 C!
[    4.456788] Bluetooth: Core ver 2.15
[    4.476459] NET: Registered protocol family 31
[    4.495922] Bluetooth: HCI device and connection manager initialized
[    4.515980] Bluetooth: HCI socket layer initialized
[    4.520195] Bluetooth: L2CAP ver 2.14
[    4.520197] Bluetooth: L2CAP socket layer initialized
[    4.523562] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[    4.620378] Bluetooth: Generic Bluetooth USB driver ver 0.6
[    4.640499] usbcore: registered new interface driver btusb
[    4.667919] Bluetooth: RFCOMM TTY layer initialized
[    4.688198] Bluetooth: RFCOMM socket layer initialized
[    4.708805] Bluetooth: RFCOMM ver 1.11
[    4.735325] Bluetooth: HCI UART driver ver 2.2
[    4.755727] Bluetooth: HCI H4 protocol initialized
[    4.782502] Bluetooth: HCI BCSP protocol initialized
[    4.826741] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.847578] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) 
-> IRQ 23
[    4.868500] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    4.868504] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    4.889190] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned 
bus number 1
[    4.910160] ehci_hcd 0000:00:1d.7: using broken periodic workaround
[    4.930925] ehci_hcd 0000:00:1d.7: debug port 1
[    4.955275] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    4.955344] ehci_hcd 0000:00:1d.7: irq 23, io mem 0x50405400
[    4.989153] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    5.016551] hub 1-0:1.0: USB hub found
[    5.042606] hub 1-0:1.0: 8 ports detected
[    5.067449] uhci_hcd: USB Universal Host Controller Interface driver
[    5.086521] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) 
-> IRQ 23
[    5.105715] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    5.105719] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    5.124369] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned 
bus number 2
[    5.142631] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00004080
[    5.161103] hub 2-0:1.0: USB hub found
[    5.178226] hub 2-0:1.0: 2 ports detected
[    5.195696] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) 
-> IRQ 19
[    5.213294] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    5.213299] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    5.230763] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned 
bus number 3
[    5.248507] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00004060
[    5.266462] hub 3-0:1.0: USB hub found
[    5.283578] hub 3-0:1.0: 2 ports detected
[    5.300683] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) 
-> IRQ 18
[    5.317679] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    5.317683] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    5.334298] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned 
bus number 4
[    5.351215] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00004040
[    5.368097] hub 4-0:1.0: USB hub found
[    5.384164] hub 4-0:1.0: 2 ports detected
[    5.400427] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) 
-> IRQ 16
[    5.416628] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    5.416631] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    5.432633] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned 
bus number 5
[    5.448972] uhci_hcd 0000:00:1d.3: irq 16, io base 0x00004020
[    5.465873] hub 5-0:1.0: USB hub found
[    5.482030] hub 5-0:1.0: 2 ports detected
[    5.516083] usb 1-4: new high speed USB device using ehci_hcd and 
address 3
[    5.542329] ieee1394: raw1394: /dev/raw1394 device initialized
[    5.647579] uvcvideo: Found UVC 1.00 device Built-in iSight (05ac:8501)
[    5.667080] uvcvideo: UVC non compliance - GET_DEF(PROBE) not 
supported. Enabling workaround.
[    5.751376] alg: No test for cipher_null (cipher_null-generic)
[    5.775173] alg: No test for ecb(cipher_null) (ecb-cipher_null)
[    5.799509] alg: No test for digest_null (digest_null-generic)
[    5.818158] alg: No test for compress_null (compress_null-generic)
[    5.985687] SELinux: initialized (dev tmpfs, type tmpfs), uses 
transition SIDs
[    6.107109] usb 2-2: new full speed USB device using uhci_hcd and 
address 2
[    6.314326] input: Apple Computer Apple Internal Keyboard / Trackpad 
as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.0/input/input1
[    6.354525] apple 0003:05AC:021A.0001: input: USB HID v1.11 Keyboard 
[Apple Computer Apple Internal Keyboard / Trackpad] on 
usb-0000:00:1d.0-2/input0
[    6.399510] udev: starting version 147
[    6.400722] appletouch: Geyser mode initialized.
[    6.400842] input: appletouch as 
/devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.1/input/input2
[    6.406748] input: Apple Computer Apple Internal Keyboard / Trackpad 
as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.2/input/input3
[    6.406760] apple 0003:05AC:021A.0002: input: USB HID v1.11 Device 
[Apple Computer Apple Internal Keyboard / Trackpad] on 
usb-0000:00:1d.0-2/input2
[    6.737097] usb 4-2: new full speed USB device using uhci_hcd and 
address 2
[    6.949804] generic-usb 0003:05AC:8240.0003: hiddev0: USB HID v1.11 
Device [Apple Computer, Inc. IR Receiver] on usb-0000:00:1d.2-2/input0
[    7.067763] i801_smbus 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) 
-> IRQ 19
[    7.093581] ACPI: resource 0000:00:1f.3 [io  0xefa0-0xefbf] conflicts 
with ACPI region SMBI [io  0xefa0-0xefaf 64bit disabled]
[    7.145205] ACPI: If an ACPI driver is available for this device, you 
should use it instead of the native driver
[    7.236721] input: Lid Switch as 
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input4
[    7.379311] ohci1394 0000:0c:03.0: PCI INT A -> GSI 19 (level, low) 
-> IRQ 19
[    7.409768] sky2: driver version 1.28
[    7.947112] ACPI: Lid Switch [LID0]
[    8.081654] sky2 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    8.094866] power_supply ADP1: uevent
[    8.094868] power_supply ADP1: POWER_SUPPLY_NAME=ADP1
[    8.094873] power_supply ADP1: prop ONLINE=1
[    8.094899] power_supply ADP1: power_supply_changed
[    8.094903] ACPI: AC Adapter [ADP1] (on-line)
[    8.095465] power_supply ADP1: power_supply_changed_work
[    8.095468] power_supply ADP1: power_supply_update_gen_leds 1
[    8.095486] power_supply ADP1: uevent
[    8.095488] power_supply ADP1: POWER_SUPPLY_NAME=ADP1
[    8.095493] power_supply ADP1: prop ONLINE=1
[    8.147897] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[19] 
MMIO=[4c004000-4c0047ff]  Max Packet=[4096]  IR/IT contexts=[4/8]
[    8.174352] sky2 0000:02:00.0: setting latency timer to 64
[    8.174443] sky2 0000:02:00.0: Yukon-2 EC chip revision 2
[    8.174697] sky2 0000:02:00.0: irq 41 for MSI/MSI-X
[    8.175817] power_supply BAT0: uevent
[    8.175819] power_supply BAT0: POWER_SUPPLY_NAME=BAT0
[    8.176824] sky2 0000:02:00.0: eth0: addr 00:17:f2:cb:e3:71
[    8.196426] power_supply BAT0: prop STATUS=Unknown
[    8.196431] power_supply BAT0: prop PRESENT=1
[    8.196436] power_supply BAT0: prop TECHNOLOGY=Unknown
[    8.196440] power_supply BAT0: prop CYCLE_COUNT=0
[    8.196444] power_supply BAT0: prop VOLTAGE_MIN_DESIGN=10800000
[    8.196449] power_supply BAT0: prop VOLTAGE_NOW=12403000
[    8.196453] power_supply BAT0: prop CURRENT_NOW=0
[    8.196457] power_supply BAT0: prop POWER_NOW=0
[    8.196461] power_supply BAT0: prop ENERGY_FULL_DESIGN=55000000
[    8.196465] power_supply BAT0: prop ENERGY_FULL=48000000
[    8.196469] power_supply BAT0: prop ENERGY_NOW=46120000
[    8.196473] power_supply BAT0: prop MODEL_NAME=ASMB012
[    8.196477] power_supply BAT0: prop MANUFACTURER=SMPN012
[    8.196482] power_supply BAT0: prop SERIAL_NUMBER=
[    8.196633] power_supply BAT0: uevent
[    8.196635] power_supply BAT0: POWER_SUPPLY_NAME=BAT0
[    8.196638] power_supply BAT0: prop STATUS=Unknown
[    8.196642] power_supply BAT0: prop PRESENT=1
[    8.196647] power_supply BAT0: prop TECHNOLOGY=Unknown
[    8.196651] power_supply BAT0: prop CYCLE_COUNT=0
[    8.196655] power_supply BAT0: prop VOLTAGE_MIN_DESIGN=10800000
[    8.196659] power_supply BAT0: prop VOLTAGE_NOW=12403000
[    8.196663] power_supply BAT0: prop CURRENT_NOW=0
[    8.196667] power_supply BAT0: prop POWER_NOW=0
[    8.196671] power_supply BAT0: prop ENERGY_FULL_DESIGN=55000000
[    8.196676] power_supply BAT0: prop ENERGY_FULL=48000000
[    8.196680] power_supply BAT0: prop ENERGY_NOW=46120000
[    8.196684] power_supply BAT0: prop MODEL_NAME=ASMB012
[    8.196688] power_supply BAT0: prop MANUFACTURER=SMPN012
[    8.196692] power_supply BAT0: prop SERIAL_NUMBER=
[    8.196792] power_supply BAT0: power_supply_changed
[    8.196798] power_supply BAT0: power_supply_changed_work
[    8.196801] power_supply BAT0: power_supply_update_bat_leds 0
[    8.196820] power_supply BAT0: uevent
[    8.196821] power_supply BAT0: POWER_SUPPLY_NAME=BAT0
[    8.196825] power_supply BAT0: prop STATUS=Unknown
[    8.196829] power_supply BAT0: prop PRESENT=1
[    8.196833] power_supply BAT0: prop TECHNOLOGY=Unknown
[    8.196837] power_supply BAT0: prop CYCLE_COUNT=0
[    8.196842] power_supply BAT0: prop VOLTAGE_MIN_DESIGN=10800000
[    8.196846] power_supply BAT0: prop VOLTAGE_NOW=12403000
[    8.196850] power_supply BAT0: prop CURRENT_NOW=0
[    8.196854] power_supply BAT0: prop POWER_NOW=0
[    8.196858] power_supply BAT0: prop ENERGY_FULL_DESIGN=55000000
[    8.196862] power_supply BAT0: prop ENERGY_FULL=48000000
[    8.196866] power_supply BAT0: prop ENERGY_NOW=46120000
[    8.196870] power_supply BAT0: prop MODEL_NAME=ASMB012
[    8.196874] power_supply BAT0: prop MANUFACTURER=SMPN012
[    8.196878] power_supply BAT0: prop SERIAL_NUMBER=
[    8.196984] power_supply BAT0: uevent
[    8.196986] power_supply BAT0: POWER_SUPPLY_NAME=BAT0
[    8.196990] power_supply BAT0: prop STATUS=Unknown
[    8.196994] power_supply BAT0: prop PRESENT=1
[    8.196998] power_supply BAT0: prop TECHNOLOGY=Unknown
[    8.197013] power_supply BAT0: prop CYCLE_COUNT=0
[    8.197018] power_supply BAT0: prop VOLTAGE_MIN_DESIGN=10800000
[    8.197022] power_supply BAT0: prop VOLTAGE_NOW=12403000
[    8.197026] power_supply BAT0: prop CURRENT_NOW=0
[    8.197030] power_supply BAT0: prop POWER_NOW=0
[    8.197034] power_supply BAT0: prop ENERGY_FULL_DESIGN=55000000
[    8.197038] power_supply BAT0: prop ENERGY_FULL=48000000
[    8.197042] power_supply BAT0: prop ENERGY_NOW=46120000
[    8.197046] power_supply BAT0: prop MODEL_NAME=ASMB012
[    8.197050] power_supply BAT0: prop MANUFACTURER=SMPN012
[    8.197054] power_supply BAT0: prop SERIAL_NUMBER=
[    8.197155] ACPI: Battery Slot [BAT0] (battery present)
[    8.197320] input: Power Button as 
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input5
[    8.197457] ACPI: Power Button [PWRB]
[    8.197614] input: Sleep Button as 
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input6
[    8.197688] ACPI: Sleep Button [SLPB]
[    8.197879] input: Power Button as 
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input7
[    8.197947] ACPI: Power Button [PWRF]
[    8.233993] ath9k 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> 
IRQ 17
[    8.234021] ath9k 0000:03:00.0: setting latency timer to 64
[    8.386980] ath: EEPROM regdomain: 0x64
[    8.386982] ath: EEPROM indicates we should expect a direct regpair map
[    8.386986] ath: Country alpha2 being used: 00
[    8.386987] ath: Regpair used: 0x64
[    8.420654] usb 5-1: new full speed USB device using uhci_hcd and 
address 2
[    8.436866] phy0: Selected rate control algorithm 'ath9k_rate_control'
[    8.437571] Registered led device: ath9k-phy0::radio
[    8.437628] Registered led device: ath9k-phy0::assoc
[    8.437691] Registered led device: ath9k-phy0::tx
[    8.437749] Registered led device: ath9k-phy0::rx
[    8.437754] phy0: Atheros AR5418 MAC/BB Rev:2 AR5133 RF Rev:81 
mem=0xffffc90000bc0000, irq=17
[    8.620534] usbhid 5-1:1.0: couldn't find an input interrupt endpoint
[    8.946429] usb 5-1: usbfs: USBDEVFS_CONTROL failed cmd hid2hci rqt 
64 rq 0 len 0 ret -71
[    8.954408] usb 5-1: USB disconnect, address 2
[    9.099069] EXT4-fs (sda3): re-mounted. Opts: 
errors=remount-ro,user_xattr
[    9.319179] EXT4-fs (sda3): re-mounted. Opts: 
errors=remount-ro,user_xattr
[    9.461125] SELinux: initialized (dev tmpfs, type tmpfs), uses 
transition SIDs
[    9.538780] Adding 390620k swap on /dev/sda4.  Priority:1 extents:1 
across:390620k
[    9.666090] usb 5-1: new full speed USB device using uhci_hcd and 
address 3
[    9.885825] ieee1394: Host added: ID:BUS[0-00:1023] 
GUID[0019e3fffe2ad87e]
[   11.381043] ip_tables: (C) 2000-2006 Netfilter Core Team
[   11.403586] nf_conntrack version 0.5.0 (7878 buckets, 31512 max)
[   11.404989] CONFIG_NF_CT_ACCT is deprecated and will be removed soon. 
Please use
[   11.404992] nf_conntrack.acct=1 kernel parameter, acct=1 nf_conntrack 
module option or
[   11.404994] sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
[   13.518184] applesmc: light sensor data length set to 6
[   16.763743] sky2 0000:02:00.0: eth0: enabling interface
[   20.331166] type=1100 audit(1275804153.330:3): user pid=1972 uid=0 
auid=4294967295 ses=4294967295 
subj=system_u:system_r:local_login_t:s0-s0:c0.c255 
msg='op=PAM:authentication acct="name" exe="/bin/login" hostname=? 
addr=? terminal=/dev/tty1 res=success'
[   20.334747] type=1101 audit(1275804153.333:4): user pid=1972 uid=0 
auid=4294967295 ses=4294967295 
subj=system_u:system_r:local_login_t:s0-s0:c0.c255 
msg='op=PAM:accounting acct="name" exe="/bin/login" hostname=? addr=? 
terminal=/dev/tty1 res=success'
[   20.391368] type=1006 audit(1275804153.390:5): login pid=1972 uid=0 
old auid=4294967295 new auid=1000 old ses=4294967295 new ses=1
[   20.461762] type=2300 audit(1275804153.460:6): user pid=1972 uid=0 
auid=1000 ses=1 subj=system_u:system_r:local_login_t:s0-s0:c0.c255 
msg='pam: default-context=name:staff_r:staff_t:s0 
selected-context=name:staff_r:staff_t:s0: exe="/bin/login" hostname=? 
addr=? terminal=tty1 res=success'
[   20.549788] type=1105 audit(1275804153.548:7): user pid=1972 uid=0 
auid=1000 ses=1 subj=system_u:system_r:local_login_t:s0-s0:c0.c255 
msg='op=PAM:session_open acct="name" exe="/bin/login" hostname=? addr=? 
terminal=/dev/tty1 res=success'
[   20.559159] type=1103 audit(1275804153.558:8): user pid=1972 uid=0 
auid=1000 ses=1 subj=system_u:system_r:local_login_t:s0-s0:c0.c255 
msg='op=PAM:setcred acct="name" exe="/bin/login" hostname=? addr=? 
terminal=/dev/tty1 res=success'
[   20.559312] type=1112 audit(1275804153.558:9): user pid=1972 uid=0 
auid=1000 ses=1 subj=system_u:system_r:local_login_t:s0-s0:c0.c255 
msg='op=login acct="name" exe="/bin/login" hostname=? addr=? 
terminal=/dev/tty1 res=success'
[   22.666931] wlan0: authenticate with 00:1e:2a:00:67:f0 (try 1)
[   22.674051] wlan0: authenticated
[   22.674168] wlan0: associate with 00:1e:2a:00:67:f0 (try 1)
[   22.676760] wlan0: RX AssocResp from 00:1e:2a:00:67:f0 (capab=0x431 
status=0 aid=1)
[   22.676765] wlan0: associated
[   24.422300] pci 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   24.518161] [drm] Initialized drm 1.1.0 20060810
[   24.705837] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   24.705840] Bluetooth: BNEP filters: protocol multicast
[   24.706928] [drm] radeon defaulting to userspace modesetting.
[   24.707884] pci 0000:01:00.0: setting latency timer to 64
[   24.708273] [drm] Initialized radeon 1.33.0 20080528 for 0000:01:00.0 
on minor 0
[   24.755996] Bluetooth: SCO (Voice Link) ver 0.6
[   24.756017] Bluetooth: SCO socket layer initialized
[   25.338451] [drm] Setting GART location based on new memory map
[   25.339567] [drm] Loading R500 Microcode
[   25.433793] [drm] Num pipes: 1
[   25.433809] [drm] writeback test succeeded in 1 usecs
[   26.568571] power_supply ADP1: uevent
[   26.568575] power_supply ADP1: POWER_SUPPLY_NAME=ADP1
[   26.568581] power_supply ADP1: prop ONLINE=1
[   26.584025] power_supply BAT0: uevent
[   26.584028] power_supply BAT0: POWER_SUPPLY_NAME=BAT0
[   26.614195] power_supply BAT0: prop STATUS=Unknown
[   26.614209] power_supply BAT0: prop PRESENT=1
[   26.614221] power_supply BAT0: prop TECHNOLOGY=Unknown
[   26.614231] power_supply BAT0: prop CYCLE_COUNT=0
[   26.614242] power_supply BAT0: prop VOLTAGE_MIN_DESIGN=10800000
[   26.614252] power_supply BAT0: prop VOLTAGE_NOW=12403000
[   26.614266] power_supply BAT0: prop CURRENT_NOW=0
[   26.614276] power_supply BAT0: prop POWER_NOW=0
[   26.614287] power_supply BAT0: prop ENERGY_FULL_DESIGN=55000000
[   26.614297] power_supply BAT0: prop ENERGY_FULL=48000000
[   26.614307] power_supply BAT0: prop ENERGY_NOW=46120000
[   26.614318] power_supply BAT0: prop MODEL_NAME=ASMB012
[   26.614328] power_supply BAT0: prop MANUFACTURER=SMPN012
[   26.614339] power_supply BAT0: prop SERIAL_NUMBER=
[   34.566318] input: Apple Wireless Mouse as 
/devices/pci0000:00/0000:00:1d.3/usb5/5-1/5-1:1.0/bluetooth/hci0/hci0:46/input8
[   34.569366] magicmouse 0005:05AC:030D.0004: input: BLUETOOTH HID 
v0.84 Mouse [Apple Wireless Mouse] on 00:17:F2:B4:BC:F5
[   34.580709] input: Apple Wireless Mouse as 
/devices/pci0000:00/0000:00:1d.3/usb5/5-1/5-1:1.0/bluetooth/hci0/hci0:46/input9
[   49.852133] type=1122 audit(1275804182.850:10): user pid=2032 
uid=1000 auid=1000 ses=1 subj=name:staff_r:xserver_t:s0 msg='avc: 
netlink poll: error 4
[   49.852138] : exe="/usr/bin/Xorg" sauid=0 hostname=? addr=? 
terminal=tty1'
[   65.396760] type=1122 audit(1275804198.395:11): user pid=2032 
uid=1000 auid=1000 ses=1 subj=name:staff_r:xserver_t:s0 msg='avc: 
netlink poll: error 4
[   65.396765] : exe="/usr/bin/Xorg" sauid=0 hostname=? addr=? 
terminal=tty1'



