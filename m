Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932714Ab0EMWpy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 18:45:54 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:58265 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932574Ab0EMWpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 18:45:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=fKWXr9y75eiM6ClbcvMOiHKkdCsLlFyzT1QNrTgu1CQXKi3rBBbutBvJ1CrsVfBAYL
         noOadMHJXOI5y4g+o4IwY+d57S+4TWtK943ziNQ+1crQtv7ceemgSb/nRqYUxZzL69di
         id5RcH9O530V07eCCO3vcNBwgnlUC/pRUxOLA=
Message-ID: <4BEC7A84.3010503@gmail.com>
Date: Thu, 13 May 2010 15:17:40 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       lrodriguez@atheros.com
Subject: ath9k: BUG kmalloc-8192: Poison overwritten
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

not sure what this is, but while at a convention
I was trying to access the internet and(below is
full dmesg) this showed up.

After receiving this, I sat and tried to re-create
my steps to reproduce but had no luck(was even going
todo a bisect n the spot if I could re-create).

Anyways If I find a way to re-create I'll bisect:



[    0.000000] Linux version 2.6.34-rc7-00057-gcdfda35 (name@name) (gcc 
version 4.4.2 (GCC) ) #1 SMP Wed May 12 09:48:03 PDT 2010
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz root=/dev/sda3 ro 
debug audit=1 selinux=1 vga=790 enforcing=1
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
[ffff880002000000-ffff880002dfffff] on node 0
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
[    0.000000] nr_irqs_gsi: 24
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
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff880001800000 s84584 
r8192 d21912 u1048576
[    0.000000] pcpu-alloc: s84584 r8192 d21912 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on. 
Total pages: 254652
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz 
root=/dev/sda3 ro debug audit=1 selinux=1 vga=790 enforcing=1
[    0.000000] audit: enabled (after initialization)
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 8, 
1048576 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 7, 524288 
bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Subtract (48 early reservations)
[    0.000000]   #1 [0001000000 - 00017ae110]   TEXT DATA BSS
[    0.000000]   #2 [000009fc00 - 0000100000]   BIOS reserved
[    0.000000]   #3 [00017af000 - 00017af271]             BRK
[    0.000000]   #4 [0000001000 - 0000003000]      TRAMPOLINE
[    0.000000]   #5 [0000003000 - 0000007000]     ACPI WAKEUP
[    0.000000]   #6 [0000008000 - 0000009000]         PGTABLE
[    0.000000]   #7 [00017af280 - 00017b0280]         BOOTMEM
[    0.000000]   #8 [00017ae140 - 00017ae200]         BOOTMEM
[    0.000000]   #9 [0001fb1000 - 0001fb2000]         BOOTMEM
[    0.000000]   #10 [0001fb2000 - 0001fb3000]         BOOTMEM
[    0.000000]   #11 [0002000000 - 0002e00000]        MEMMAP 0
[    0.000000]   #12 [00017ae200 - 00017ae480]         BOOTMEM
[    0.000000]   #13 [00017b0280 - 00017ba280]         BOOTMEM
[    0.000000]   #14 [00017bb000 - 00017bc000]         BOOTMEM
[    0.000000]   #15 [00017ae480 - 00017ae4c1]         BOOTMEM
[    0.000000]   #16 [00017ae500 - 00017ae543]         BOOTMEM
[    0.000000]   #17 [00017ae580 - 00017ae900]         BOOTMEM
[    0.000000]   #18 [00017ae900 - 00017ae968]         BOOTMEM
[    0.000000]   #19 [00017ae980 - 00017ae9e8]         BOOTMEM
[    0.000000]   #20 [00017aea00 - 00017aea68]         BOOTMEM
[    0.000000]   #21 [00017aea80 - 00017aeae8]         BOOTMEM
[    0.000000]   #22 [00017aeb00 - 00017aeb68]         BOOTMEM
[    0.000000]   #23 [00017aeb80 - 00017aebe8]         BOOTMEM
[    0.000000]   #24 [00017aec00 - 00017aec68]         BOOTMEM
[    0.000000]   #25 [00017aec80 - 00017aece8]         BOOTMEM
[    0.000000]   #26 [00017aed00 - 00017aed68]         BOOTMEM
[    0.000000]   #27 [00017aed80 - 00017aede8]         BOOTMEM
[    0.000000]   #28 [00017aee00 - 00017aee68]         BOOTMEM
[    0.000000]   #29 [00017aee80 - 00017aeee8]         BOOTMEM
[    0.000000]   #30 [00017aef00 - 00017aef68]         BOOTMEM
[    0.000000]   #31 [00017aef80 - 00017aefe8]         BOOTMEM
[    0.000000]   #32 [00017ba280 - 00017ba2e8]         BOOTMEM
[    0.000000]   #33 [00017ba300 - 00017ba320]         BOOTMEM
[    0.000000]   #34 [00017ba340 - 00017ba397]         BOOTMEM
[    0.000000]   #35 [00017ba3c0 - 00017ba417]         BOOTMEM
[    0.000000]   #36 [0001800000 - 000181c000]         BOOTMEM
[    0.000000]   #37 [0001900000 - 000191c000]         BOOTMEM
[    0.000000]   #38 [00017ba440 - 00017ba448]         BOOTMEM
[    0.000000]   #39 [00017ba480 - 00017ba488]         BOOTMEM
[    0.000000]   #40 [00017ba4c0 - 00017ba4c8]         BOOTMEM
[    0.000000]   #41 [00017ba500 - 00017ba510]         BOOTMEM
[    0.000000]   #42 [00017ba540 - 00017ba680]         BOOTMEM
[    0.000000]   #43 [00017ba680 - 00017ba6e0]         BOOTMEM
[    0.000000]   #44 [00017ba700 - 00017ba760]         BOOTMEM
[    0.000000]   #45 [00017bc000 - 00017c4000]         BOOTMEM
[    0.000000]   #46 [000191c000 - 0001a1c000]         BOOTMEM
[    0.000000]   #47 [000181c000 - 000189c000]         BOOTMEM
[    0.000000] Memory: 1008652k/1033128k available (4031k kernel code, 
392k absent, 24084k reserved, 2512k data, 496k init)
[    0.000000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, 
CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:320
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2185.158 MHz processor.
[    0.001008] Calibrating delay loop (skipped), value calculated using 
timer frequency.. 4370.31 BogoMIPS (lpj=2185158)
[    0.001076] Security Framework initialized
[    0.001087] SELinux:  Initializing.
[    0.001120] SELinux:  Starting in enforcing mode
[    0.001142] Mount-cache hash table entries: 256
[    0.002043] CPU: Physical Processor ID: 0
[    0.002049] CPU: Processor Core ID: 0
[    0.002055] mce: CPU supports 6 MCE banks
[    0.002068] CPU0: Thermal monitoring enabled (TM2)
[    0.002075] using mwait in idle threads.
[    0.002080] Performance Events: Core2 events, Intel PMU driver.
[    0.002091] ... version:                2
[    0.002096] ... bit width:              40
[    0.002100] ... generic registers:      2
[    0.002105] ... value mask:             000000ffffffffff
[    0.002110] ... max period:             000000007fffffff
[    0.002115] ... fixed-purpose events:   3
[    0.002120] ... event mask:             0000000700000003
[    0.003004] ACPI: Core revision 20100121
[    0.026197] Setting APIC routing to flat
[    0.026579] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.036728] CPU0: Intel(R) Core(TM)2 CPU         T7400  @ 2.16GHz 
stepping 06
[    0.036999] Booting Node   0, Processors  #1 Ok.
[    0.108028] Brought up 2 CPUs
[    0.108037] Total of 2 processors activated (8692.62 BogoMIPS).
[    0.110456] NET: Registered protocol family 16
[    0.112093] ACPI: bus type pci registered
[    0.112144] PCI: Using configuration type 1 for base access
[    0.127078] bio: create slab <bio-0> at 0
[    0.129503] ACPI: EC: EC description table is found, configuring boot EC
[    0.138070] ACPI: BIOS _OSI(Linux) query ignored
[    0.141286] ACPI: SSDT 000000003feb8c10 002AE (v01 APPLE   Cpu0Ist 
00003000 INTL 20050309)
[    0.142757] ACPI: SSDT 000000003feb8910 002A0 (v01 APPLE   Cpu0Cst 
00003001 INTL 20050309)
[    0.145161] ACPI: SSDT 000000003feb8f10 00087 (v01 APPLE   Cpu1Ist 
00003000 INTL 20050309)
[    0.146431] ACPI: SSDT 000000003feb7f10 00085 (v01 APPLE   Cpu1Cst 
00003000 INTL 20050309)
[    0.147073] ACPI: Interpreter enabled
[    0.147081] ACPI: (supports S0 S3 S4 S5)
[    0.147172] ACPI: Using IOAPIC for interrupt routing
[    0.181056] ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
[    0.182099] ACPI: No dock devices found.
[    0.182107] PCI: Ignoring host bridge windows from ACPI; if 
necessary, use "pci=use_crs" and report a bug
[    0.185420] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.190476] pci_root PNP0A08:00: host bridge window [io 
0x0000-0x0cf7] (ignored)
[    0.190485] pci_root PNP0A08:00: host bridge window [io 
0x0d00-0xffff] (ignored)
[    0.190494] pci_root PNP0A08:00: host bridge window [mem 
0x000a0000-0x000bffff] (ignored)
[    0.190504] pci_root PNP0A08:00: host bridge window [mem 
0x40000000-0xfebfffff] (ignored)
[    0.190608] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.190615] pci 0000:00:01.0: PME# disabled
[    0.190652] pci 0000:00:07.0: reg 10: [mem 0x50404000-0x50404fff]
[    0.190751] pci 0000:00:1b.0: reg 10: [mem 0x50400000-0x50403fff 64bit]
[    0.190816] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.190824] pci 0000:00:1b.0: PME# disabled
[    0.190928] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.190936] pci 0000:00:1c.0: PME# disabled
[    0.191058] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.191066] pci 0000:00:1c.1: PME# disabled
[    0.191172] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.191181] pci 0000:00:1c.2: PME# disabled
[    0.191253] pci 0000:00:1d.0: reg 20: [io  0x4080-0x409f]
[    0.191325] pci 0000:00:1d.1: reg 20: [io  0x4060-0x407f]
[    0.191396] pci 0000:00:1d.2: reg 20: [io  0x4040-0x405f]
[    0.191468] pci 0000:00:1d.3: reg 20: [io  0x4020-0x403f]
[    0.191536] pci 0000:00:1d.7: reg 10: [mem 0x50405400-0x504057ff]
[    0.191604] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.191613] pci 0000:00:1d.7: PME# disabled
[    0.191789] pci 0000:00:1f.0: quirk: [io  0x0400-0x047f] claimed by 
ICH6 ACPI/GPIO/TCO
[    0.191799] pci 0000:00:1f.0: quirk: [io  0x0500-0x053f] claimed by 
ICH6 GPIO
[    0.191807] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 
0680 (mask 000f)
[    0.191817] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 
1640 (mask 000f)
[    0.191829] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 4 PIO at 
0300 (mask 001f)
[    0.191926] pci 0000:00:1f.1: reg 10: [io  0x40d8-0x40df]
[    0.191937] pci 0000:00:1f.1: reg 14: [io  0x40ec-0x40ef]
[    0.191948] pci 0000:00:1f.1: reg 18: [io  0x40d0-0x40d7]
[    0.191959] pci 0000:00:1f.1: reg 1c: [io  0x40e8-0x40eb]
[    0.191970] pci 0000:00:1f.1: reg 20: [io  0x40b0-0x40bf]
[    0.192045] pci 0000:00:1f.2: reg 10: [io  0x40c8-0x40cf]
[    0.192056] pci 0000:00:1f.2: reg 14: [io  0x40e4-0x40e7]
[    0.192067] pci 0000:00:1f.2: reg 18: [io  0x40c0-0x40c7]
[    0.192078] pci 0000:00:1f.2: reg 1c: [io  0x40e0-0x40e3]
[    0.192089] pci 0000:00:1f.2: reg 20: [io  0x40a0-0x40af]
[    0.192100] pci 0000:00:1f.2: reg 24: [mem 0x50405000-0x504053ff]
[    0.192133] pci 0000:00:1f.2: PME# supported from D3hot
[    0.192141] pci 0000:00:1f.2: PME# disabled
[    0.192210] pci 0000:00:1f.3: reg 20: [io  0xefa0-0xefbf]
[    0.192311] pci 0000:01:00.0: reg 10: [mem 0x40000000-0x47ffffff pref]
[    0.192323] pci 0000:01:00.0: reg 14: [io  0x3000-0x30ff]
[    0.192334] pci 0000:01:00.0: reg 18: [mem 0x50300000-0x5030ffff]
[    0.192356] pci 0000:01:00.0: reg 30: [mem 0xfffe0000-0xffffffff pref]
[    0.192386] pci 0000:01:00.0: supports D1 D2
[    0.192401] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.192407] pci 0000:00:01.0:   bridge window [io  0x3000-0x3fff]
[    0.192414] pci 0000:00:01.0:   bridge window [mem 0x50300000-0x503fffff]
[    0.192423] pci 0000:00:01.0:   bridge window [mem 
0x40000000-0x47ffffff 64bit pref]
[    0.192547] pci 0000:02:00.0: reg 10: [mem 0x50200000-0x50203fff 64bit]
[    0.192561] pci 0000:02:00.0: reg 18: [io  0x2000-0x20ff]
[    0.192599] pci 0000:02:00.0: reg 30: [mem 0xfffe0000-0xffffffff pref]
[    0.192658] pci 0000:02:00.0: supports D1 D2
[    0.192663] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.192673] pci 0000:02:00.0: PME# disabled
[    0.192690] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.192698] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.192707] pci 0000:00:1c.0:   bridge window [mem 0x50200000-0x502fffff]
[    0.192719] pci 0000:00:1c.0:   bridge window [mem 
0xfff00000-0x000fffff pref] (disabled)
[    0.192848] pci 0000:03:00.0: reg 10: [mem 0x50100000-0x5010ffff 64bit]
[    0.192944] pci 0000:03:00.0: supports D1
[    0.192949] pci 0000:03:00.0: PME# supported from D0 D1 D3hot
[    0.192958] pci 0000:03:00.0: PME# disabled
[    0.192984] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.193004] pci 0000:00:1c.1:   bridge window [io  0xf000-0x0000] 
(disabled)
[    0.193013] pci 0000:00:1c.1:   bridge window [mem 0x50100000-0x501fffff]
[    0.193025] pci 0000:00:1c.1:   bridge window [mem 
0xfff00000-0x000fffff pref] (disabled)
[    0.193096] pci 0000:00:1c.2: PCI bridge to [bus 04-0b]
[    0.193104] pci 0000:00:1c.2:   bridge window [io  0x1000-0x1fff]
[    0.193113] pci 0000:00:1c.2:   bridge window [mem 0x4c100000-0x500fffff]
[    0.193125] pci 0000:00:1c.2:   bridge window [mem 
0x48000000-0x4bffffff 64bit pref]
[    0.193211] pci 0000:0c:03.0: reg 10: [mem 0x4c004000-0x4c0047ff]
[    0.193223] pci 0000:0c:03.0: reg 14: [mem 0x4c000000-0x4c003fff]
[    0.193290] pci 0000:0c:03.0: supports D1 D2
[    0.193295] pci 0000:0c:03.0: PME# supported from D0 D1 D2 D3hot
[    0.193304] pci 0000:0c:03.0: PME# disabled
[    0.193369] pci 0000:00:1e.0: PCI bridge to [bus 0c-0c] (subtractive 
decode)
[    0.193378] pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] 
(disabled)
[    0.193387] pci 0000:00:1e.0:   bridge window [mem 0x4c000000-0x4c0fffff]
[    0.193398] pci 0000:00:1e.0:   bridge window [mem 
0xfff00000-0x000fffff pref] (disabled)
[    0.193407] pci 0000:00:1e.0:   bridge window [io  0x0000-0xffff] 
(subtractive decode)
[    0.193416] pci 0000:00:1e.0:   bridge window [mem 
0x00000000-0xffffffffffffffff] (subtractive decode)
[    0.193452] pci_bus 0000:00: on NUMA node 0
[    0.193463] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.194716] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEGP._PRT]
[    0.195143] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.195547] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.195951] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
[    0.196437] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
[    0.231287] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 
14 15) *11
[    0.232314] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 *11 12 
14 15)
[    0.232652] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 
14 15) *11
[    0.233007] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 *11 12 
14 15)
[    0.233341] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 
14 15) *0, disabled.
[    0.233678] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 
14 15) *0, disabled.
[    0.234029] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 *10 12 
14 15)
[    0.234370] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *11 12 14 15)
[    0.235095] vgaarb: device added: 
PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.235095] vgaarb: loaded
[    0.236081] SCSI subsystem initialized
[    0.236093] libata version 3.00 loaded.
[    0.236109] usbcore: registered new interface driver usbfs
[    0.236109] usbcore: registered new interface driver hub
[    0.236109] usbcore: registered new device driver usb
[    0.237110] PCI: Using ACPI for IRQ routing
[    0.237110] PCI: pci_cache_line_size set to 64 bytes
[    0.237185] reserve RAM buffer: 000000000009fc00 - 000000000009ffff
[    0.237190] reserve RAM buffer: 000000003f0ea000 - 000000003fffffff
[    0.238260] cfg80211: Calling CRDA to update world regulatory domain
[    0.238260] NetLabel: Initializing
[    0.238260] NetLabel:  domain hash size = 128
[    0.238260] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.238260] NetLabel:  unlabeled traffic allowed by default
[    0.238260] HPET: 3 timers in total, 0 timers will be used for 
per-cpu timer
[    0.238260] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.238260] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.241053] Switching to clocksource tsc
[    0.253311] pnp: PnP ACPI init
[    0.253343] ACPI: bus type pnp registered
[    0.259548] pnp 00:07: disabling [io  0x1640-0x164f] because it 
overlaps 0000:00:1c.2 BAR 7 [io  0x1000-0x1fff]
[    0.264668] pnp: PnP ACPI: found 9 devices
[    0.264674] ACPI: ACPI bus type pnp unregistered
[    0.264694] system 00:01: [mem 0xf0000000-0xf3ffffff] has been reserved
[    0.264702] system 00:01: [mem 0xfed14000-0xfed17fff] has been reserved
[    0.264709] system 00:01: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.264717] system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.264724] system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.264732] system 00:01: [mem 0xfed20000-0xfed8ffff] has been reserved
[    0.264745] system 00:05: [mem 0xfed00000-0xfed003ff] has been reserved
[    0.264758] system 00:07: [io  0x0680-0x06ef] has been reserved
[    0.264765] system 00:07: [io  0x0800-0x080f] has been reserved
[    0.264772] system 00:07: [io  0x0810-0x0817] has been reserved
[    0.264780] system 00:07: [io  0x0400-0x047f] has been reserved
[    0.264787] system 00:07: [io  0x0500-0x053f] has been reserved
[    0.270837] pci 0000:01:00.0: no compatible bridge window for [mem 
0xfffe0000-0xffffffff pref]
[    0.270849] pci 0000:02:00.0: no compatible bridge window for [mem 
0xfffe0000-0xffffffff pref]
[    0.270864] PCI: max bus depth: 1 pci_try_num: 2
[    0.270919] pci 0000:00:1c.0: BAR 9: assigned [mem 
0x50500000-0x506fffff pref]
[    0.270929] pci 0000:00:1c.1: BAR 9: assigned [mem 
0x50700000-0x508fffff 64bit pref]
[    0.270939] pci 0000:00:1c.1: BAR 7: assigned [io  0x5000-0x5fff]
[    0.270947] pci 0000:01:00.0: BAR 6: assigned [mem 
0x50320000-0x5033ffff pref]
[    0.270956] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.270962] pci 0000:00:01.0:   bridge window [io  0x3000-0x3fff]
[    0.270970] pci 0000:00:01.0:   bridge window [mem 0x50300000-0x503fffff]
[    0.270977] pci 0000:00:01.0:   bridge window [mem 
0x40000000-0x47ffffff 64bit pref]
[    0.270989] pci 0000:02:00.0: BAR 6: assigned [mem 
0x50500000-0x5051ffff pref]
[    0.270998] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.271004] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.271014] pci 0000:00:1c.0:   bridge window [mem 0x50200000-0x502fffff]
[    0.271023] pci 0000:00:1c.0:   bridge window [mem 
0x50500000-0x506fffff pref]
[    0.271036] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    0.271043] pci 0000:00:1c.1:   bridge window [io  0x5000-0x5fff]
[    0.271053] pci 0000:00:1c.1:   bridge window [mem 0x50100000-0x501fffff]
[    0.271061] pci 0000:00:1c.1:   bridge window [mem 
0x50700000-0x508fffff 64bit pref]
[    0.271075] pci 0000:00:1c.2: PCI bridge to [bus 04-0b]
[    0.271082] pci 0000:00:1c.2:   bridge window [io  0x1000-0x1fff]
[    0.271092] pci 0000:00:1c.2:   bridge window [mem 0x4c100000-0x500fffff]
[    0.271100] pci 0000:00:1c.2:   bridge window [mem 
0x48000000-0x4bffffff 64bit pref]
[    0.271114] pci 0000:00:1e.0: PCI bridge to [bus 0c-0c]
[    0.271119] pci 0000:00:1e.0:   bridge window [io  disabled]
[    0.271129] pci 0000:00:1e.0:   bridge window [mem 0x4c000000-0x4c0fffff]
[    0.271137] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    0.271160] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.271168] pci 0000:00:01.0: setting latency timer to 64
[    0.271183] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.271192] pci 0000:00:1c.0: setting latency timer to 64
[    0.271206] pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.271214] pci 0000:00:1c.1: setting latency timer to 64
[    0.271229] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.271238] pci 0000:00:1c.2: setting latency timer to 64
[    0.271414] pci 0000:00:1e.0: power state changed by ACPI to D0
[    0.271585] pci 0000:00:1e.0: power state changed by ACPI to D0
[    0.271596] pci 0000:00:1e.0: setting latency timer to 64
[    0.271604] pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
[    0.271610] pci_bus 0000:00: resource 1 [mem 
0x00000000-0xffffffffffffffff]
[    0.271616] pci_bus 0000:01: resource 0 [io  0x3000-0x3fff]
[    0.271622] pci_bus 0000:01: resource 1 [mem 0x50300000-0x503fffff]
[    0.271628] pci_bus 0000:01: resource 2 [mem 0x40000000-0x47ffffff 
64bit pref]
[    0.271636] pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
[    0.271641] pci_bus 0000:02: resource 1 [mem 0x50200000-0x502fffff]
[    0.271647] pci_bus 0000:02: resource 2 [mem 0x50500000-0x506fffff pref]
[    0.271653] pci_bus 0000:03: resource 0 [io  0x5000-0x5fff]
[    0.271659] pci_bus 0000:03: resource 1 [mem 0x50100000-0x501fffff]
[    0.271664] pci_bus 0000:03: resource 2 [mem 0x50700000-0x508fffff 
64bit pref]
[    0.271673] pci_bus 0000:04: resource 0 [io  0x1000-0x1fff]
[    0.271678] pci_bus 0000:04: resource 1 [mem 0x4c100000-0x500fffff]
[    0.271684] pci_bus 0000:04: resource 2 [mem 0x48000000-0x4bffffff 
64bit pref]
[    0.271692] pci_bus 0000:0c: resource 1 [mem 0x4c000000-0x4c0fffff]
[    0.271698] pci_bus 0000:0c: resource 4 [io  0x0000-0xffff]
[    0.271704] pci_bus 0000:0c: resource 5 [mem 
0x00000000-0xffffffffffffffff]
[    0.271750] NET: Registered protocol family 2
[    0.271843] IP route cache hash table entries: 32768 (order: 6, 
262144 bytes)
[    0.272403] TCP established hash table entries: 131072 (order: 9, 
2097152 bytes)
[    0.273452] TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
[    0.274867] TCP: Hash tables configured (established 131072 bind 65536)
[    0.274876] TCP reno registered
[    0.274889] UDP hash table entries: 512 (order: 3, 49152 bytes)
[    0.274930] UDP-Lite hash table entries: 512 (order: 3, 49152 bytes)
[    0.275258] NET: Registered protocol family 1
[    0.275468] pci 0000:01:00.0: Boot video device
[    0.275508] PCI: CLS mismatch (256 != 64), using 64 bytes
[    0.279402] microcode: CPU0 sig=0x6f6, pf=0x20, revision=0xc7
[    0.279416] microcode: CPU1 sig=0x6f6, pf=0x20, revision=0xc7
[    0.279557] microcode: Microcode Update Driver: v2.00 
<tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.281445] Initializing RT-Tester: OK
[    0.281596] audit: initializing netlink socket (enabled)
[    0.281628] type=2000 audit(1273772184.281:1): initialized
[    0.298252] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.320047] ROMFS MTD (C) 2007 Red Hat, Inc.
[    0.320386] fuse init (API version 7.13)
[    0.321144] msgmni has been set to 1970
[    0.321470] SELinux:  Registering netfilter hooks
[    0.322904] alg: No test for stdrng (krng)
[    0.322933] io scheduler noop registered
[    0.323320] io scheduler cfq registered (default)
[    0.324678] vesafb: framebuffer at 0x40000000, mapped to 
0xffffc90000100000, using 3072k, total 3072k
[    0.324688] vesafb: mode is 1024x768x32, linelength=4096, pages=0
[    0.324694] vesafb: scrolling: redraw
[    0.324699] vesafb: Truecolor: size=0:8:8:8, shift=0:16:8:0
[    0.324898] fbcon: VESA VGA (fb0) is primary device
[    0.372483] Console: switching to colour frame buffer device 128x48
[    0.416209] fb0: VESA VGA frame buffer device
[    0.432699] Linux agpgart interface v0.103
[    0.436337] loop: module loaded
[    0.437915] ata_piix 0000:00:1f.1: version 2.13
[    0.438440] ata_piix 0000:00:1f.1: power state changed by ACPI to D0
[    0.439107] ata_piix 0000:00:1f.1: power state changed by ACPI to D0
[    0.439687] ata_piix 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) 
-> IRQ 18
[    0.440370] ata_piix 0000:00:1f.1: setting latency timer to 64
[    0.441009] scsi0 : ata_piix
[    0.441972] scsi1 : ata_piix
[    0.445027] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x40b0 
irq 14
[    0.445652] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x40b8 
irq 15
[    0.446305] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) 
-> IRQ 19
[    0.446958] ata_piix 0000:00:1f.2: MAP [ P0 P2 -- -- ]
[    0.596926] ata_piix 0000:00:1f.2: setting latency timer to 64
[    0.597580] scsi2 : ata_piix
[    0.598188] scsi3 : ata_piix
[    0.603012] ata3: SATA max UDMA/133 cmd 0x40c8 ctl 0x40e4 bmdma 
0x40a0 irq 19
[    0.608993] ata1.00: ATAPI: MATSHITADVD-R   UJ-857D, KCV9, max UDMA/66
[    0.614830] ata1.00: configured for UDMA/66
[    0.616896] scsi 0:0:0:0: CD-ROM            MATSHITA DVD-R   UJ-857D 
  KCV9 PQ: 0 ANSI: 5
[    0.621508] sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
[    0.621511] Uniform CD-ROM driver Revision: 3.20
[    0.621917] sr 0:0:0:0: Attached scsi CD-ROM sr0
[    0.622252] sr 0:0:0:0: Attached scsi generic sg0 type 5
[    0.668937] ata4: SATA max UDMA/133 cmd 0x40c0 ctl 0x40e0 bmdma 
0x40a8 irq 19
[    0.679184] usbcore: registered new interface driver usblcd
[    0.689515] usbcore: registered new interface driver usbled
[    0.700278] PNP: No PS/2 controller found. Probing ports directly.
[    0.711866] i8042.c: No controller found.
[    0.723142] mice: PS/2 mouse device common for all mice
[    0.734868] Linux video capture interface: v2.00
[    0.748186] device-mapper: ioctl: 4.17.0-ioctl (2010-03-05) 
initialised: dm-devel@redhat.com
[    0.760910] EDAC MC: Ver: 2.1.0 May 12 2010
[    0.774216] cpuidle: using governor ladder
[    0.787369] cpuidle: using governor menu
[    0.804498] usbcore: registered new interface driver hiddev
[    0.818629] usbcore: registered new interface driver usbhid
[    0.832841] usbhid: USB HID core driver
[    0.850719] oprofile: using NMI interrupt.
[    0.853154] ata3.01: ATA-8: FUJITSU MHW2120BH, 00810013, max UDMA/100
[    0.853157] ata3.01: 234441648 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    0.859108] ata3.01: configured for UDMA/100
[    0.859284] scsi 2:0:1:0: Direct-Access     ATA      FUJITSU MHW2120B 
0081 PQ: 0 ANSI: 5
[    0.860054] sd 2:0:1:0: Attached scsi generic sg1 type 0
[    0.860121] sd 2:0:1:0: [sda] 234441648 512-byte logical blocks: (120 
GB/111 GiB)
[    0.860258] sd 2:0:1:0: [sda] Write Protect is off
[    0.860260] sd 2:0:1:0: [sda] Mode Sense: 00 3a 00 00
[    0.860317] sd 2:0:1:0: [sda] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[    1.003179] IPVS: Registered protocols (TCP, AH, ESP)
[    1.019542] IPVS: Connection hash table configured (size=4096, 
memory=64Kbytes)
[    1.036041] IPVS: ipvs loaded.
[    1.052808] Initializing XFRM netlink socket
[    1.069264] NET: Registered protocol family 17
[    1.085995] NET: Registered protocol family 15
[    1.102224] lib80211: common routines for IEEE802.11 drivers
[    1.118656] lib80211_crypt: registered algorithm 'NULL'
[    1.135474]  sda:
[    1.135917] No TPM chip found, activating TPM-bypass!
[    1.209863]  sda1 sda2 sda3 sda4
[    1.227678] sd 2:0:1:0: [sda] Attached SCSI disk
[    1.278520] EXT4-fs (sda3): mounted filesystem with ordered data mode
[    1.295223] VFS: Mounted root (ext4 filesystem) readonly on device 8:3.
[    1.311808] Freeing unused kernel memory: 496k freed
[    1.844055] SELinux: 2048 avtab hash slots, 175804 rules.
[    2.023210] SELinux: 2048 avtab hash slots, 175804 rules.
[    2.567788] SELinux:  7 users, 14 roles, 3026 types, 119 bools, 1 
sens, 256 cats
[    2.584412] SELinux:  77 classes, 175804 rules
[    2.611487] SELinux:  Completing initialization.
[    2.627459] SELinux:  Setting up existing superblocks.
[    2.643701] SELinux: initialized (dev sda3, type ext4), uses xattr
[    2.660153] SELinux: initialized (dev securityfs, type securityfs), 
uses genfs_contexts
[    2.676501] SELinux: initialized (dev selinuxfs, type selinuxfs), 
uses genfs_contexts
[    2.692911] SELinux: initialized (dev mqueue, type mqueue), uses 
transition SIDs
[    2.709334] SELinux: initialized (dev hugetlbfs, type hugetlbfs), 
uses transition SIDs
[    2.725519] SELinux: initialized (dev devpts, type devpts), uses 
transition SIDs
[    2.741403] SELinux: initialized (dev anon_inodefs, type 
anon_inodefs), uses genfs_contexts
[    2.757550] SELinux: initialized (dev pipefs, type pipefs), uses task 
SIDs
[    2.773911] SELinux: initialized (dev debugfs, type debugfs), uses 
genfs_contexts
[    2.791110] SELinux: initialized (dev sockfs, type sockfs), uses task 
SIDs
[    2.807750] SELinux: initialized (dev tmpfs, type tmpfs), uses 
transition SIDs
[    2.807764] SELinux: initialized (dev proc, type proc), uses 
genfs_contexts
[    2.807774] SELinux: initialized (dev bdev, type bdev), uses 
genfs_contexts
[    2.807779] SELinux: initialized (dev rootfs, type rootfs), uses 
genfs_contexts
[    2.807789] SELinux: initialized (dev sysfs, type sysfs), uses 
genfs_contexts
[    2.909603] type=1403 audit(1273772186.909:2): policy loaded 
auid=4294967295 ses=4294967295
[    3.757319] usbcore: registered new interface driver uvcvideo
[    3.774130] USB Video Class driver (v0.1.0)
[    3.816807] applesmc: Apple MacBook Pro 2,2 detected:
[    3.833839] applesmc:  - Model with accelerometer
[    3.851309] applesmc:  - Model with light sensors and backlight
[    3.868634] applesmc:  - Model with 12 temperature sensors
[    3.938612] applesmc: device successfully initialized (0xe0, 0x00).
[    3.938614] applesmc: device successfully initialized.
[    3.956404] applesmc: 2 fans found.
[    3.975685] input: applesmc as 
/devices/platform/applesmc.768/input/input0
[    3.993613] Registered led device: smc::kbd_backlight
[    3.993783] applesmc: driver successfully loaded.
[    4.015279] usbcore: registered new interface driver appletouch
[    4.050619] Monitor-Mwait will be used to enter C-1 state
[    4.050665] Monitor-Mwait will be used to enter C-2 state
[    4.050710] Monitor-Mwait will be used to enter C-3 state
[    4.050720] Marking TSC unstable due to TSC halts in idle
[    4.068950] Switching to clocksource hpet
[    4.154225] Bluetooth: Core ver 2.15
[    4.179362] NET: Registered protocol family 31
[    4.198212] Bluetooth: HCI device and connection manager initialized
[    4.217290] Bluetooth: HCI socket layer initialized
[    4.240238] Bluetooth: L2CAP ver 2.14
[    4.258807] Bluetooth: L2CAP socket layer initialized
[    4.281298] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[    4.307083] Bluetooth: Generic Bluetooth USB driver ver 0.6
[    4.325774] usbcore: registered new interface driver btusb
[    4.351853] Bluetooth: RFCOMM TTY layer initialized
[    4.371136] Bluetooth: RFCOMM socket layer initialized
[    4.390479] Bluetooth: RFCOMM ver 1.11
[    4.415303] Bluetooth: HCI UART driver ver 2.2
[    4.434628] Bluetooth: HCI H4 protocol initialized
[    4.454046] Bluetooth: HCI BCSP protocol initialized
[    4.489400] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    4.514683] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) 
-> IRQ 23
[    4.540213] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    4.540220] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    4.559476] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned 
bus number 1
[    4.578903] ehci_hcd 0000:00:1d.7: using broken periodic workaround
[    4.598151] ehci_hcd 0000:00:1d.7: debug port 1
[    4.621028] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    4.621080] ehci_hcd 0000:00:1d.7: irq 23, io mem 0x50405400
[    4.649399] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    4.676033] hub 1-0:1.0: USB hub found
[    4.701498] hub 1-0:1.0: 8 ports detected
[    4.740392] uhci_hcd: USB Universal Host Controller Interface driver
[    4.765887] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) 
-> IRQ 23
[    4.784953] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    4.784957] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    4.803730] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned 
bus number 2
[    4.822726] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00004080
[    4.823275] hub 2-0:1.0: USB hub found
[    4.823288] hub 2-0:1.0: 2 ports detected
[    4.823571] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) 
-> IRQ 19
[    4.823581] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    4.823584] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    4.823602] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned 
bus number 3
[    4.823639] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00004060
[    4.824202] hub 3-0:1.0: USB hub found
[    4.824214] hub 3-0:1.0: 2 ports detected
[    4.824482] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) 
-> IRQ 18
[    4.824493] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    4.824496] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    4.824505] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned 
bus number 4
[    4.824571] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00004040
[    4.825081] hub 4-0:1.0: USB hub found
[    4.825094] hub 4-0:1.0: 2 ports detected
[    4.825402] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) 
-> IRQ 16
[    4.825412] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    4.825415] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    4.825425] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned 
bus number 5
[    4.825486] uhci_hcd 0000:00:1d.3: irq 16, io base 0x00004020
[    4.825981] hub 5-0:1.0: USB hub found
[    4.826012] hub 5-0:1.0: 2 ports detected
[    5.301983] ieee1394: raw1394: /dev/raw1394 device initialized
[    5.424309] alg: No test for cipher_null (cipher_null-generic)
[    5.467935] alg: No test for ecb(cipher_null) (ecb-cipher_null)
[    5.485377] alg: No test for digest_null (digest_null-generic)
[    5.502474] alg: No test for compress_null (compress_null-generic)
[    5.621281] usb 1-4: new high speed USB device using ehci_hcd and 
address 3
[    5.690593] SELinux: initialized (dev tmpfs, type tmpfs), uses 
transition SIDs
[    6.049678] udev: starting version 147
[    6.173282] usb 2-2: new full speed USB device using uhci_hcd and 
address 2
[    6.306815] i801_smbus 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) 
-> IRQ 19
[    6.326425] ACPI: resource 0000:00:1f.3 [io  0xefa0-0xefbf] conflicts 
with ACPI region SMBI [io  0xefa0-0xefaf 64bit pref disabled]
[    6.366625] ACPI: If an ACPI driver is available for this device, you 
should use it instead of the native driver
[    6.405324] input: Apple Computer Apple Internal Keyboard / Trackpad 
as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.0/input/input1
[    6.870487] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) 
-> IRQ 22
[    6.999564] sky2: driver version 1.27
[    7.004258] input: Lid Switch as 
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input2
[    7.004429] ACPI: Lid Switch [LID0]
[    7.004563] input: Power Button as 
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input3
[    7.004569] ACPI: Power Button [PWRB]
[    7.004704] input: Sleep Button as 
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input4
[    7.004709] ACPI: Sleep Button [SLPB]
[    7.004859] input: Power Button as 
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input5
[    7.004864] ACPI: Power Button [PWRF]
[    7.161650] power_supply ADP1: uevent
[    7.161652] power_supply ADP1: No power supply yet
[    7.161677] power_supply ADP1: power_supply_changed
[    7.161683] ACPI: AC Adapter [ADP1] (off-line)
[    7.161689] power_supply ADP1: power_supply_changed_work
[    7.161691] power_supply ADP1: power_supply_update_gen_leds 0
[    7.161709] power_supply ADP1: uevent
[    7.161710] power_supply ADP1: POWER_SUPPLY_NAME=ADP1
[    7.161714] power_supply ADP1: Static prop TYPE=Mains
[    7.161717] power_supply ADP1: 1 dynamic props
[    7.161720] power_supply ADP1: prop ONLINE=0
[    7.325149] ohci1394 0000:0c:03.0: PCI INT A -> GSI 19 (level, low) 
-> IRQ 19
[    7.479887] HDA Intel 0000:00:1b.0: irq 24 for MSI/MSI-X
[    7.480187] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    7.486389] sky2 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    7.488203] apple 0003:05AC:021A.0001: input: USB HID v1.11 Keyboard 
[Apple Computer Apple Internal Keyboard / Trackpad] on 
usb-0000:00:1d.0-2/input0
[    7.492904] appletouch: Geyser mode initialized.
[    7.493143] input: appletouch as 
/devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.1/input/input6
[    7.499054] input: Apple Computer Apple Internal Keyboard / Trackpad 
as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.2/input/input7
[    7.499173] apple 0003:05AC:021A.0002: input: USB HID v1.11 Device 
[Apple Computer Apple Internal Keyboard / Trackpad] on 
usb-0000:00:1d.0-2/input2
[    7.722586] sky2 0000:02:00.0: setting latency timer to 64
[    7.722645] sky2 0000:02:00.0: Yukon-2 EC chip revision 2
[    7.724385] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[19] 
MMIO=[4c004000-4c0047ff]  Max Packet=[4096]  IR/IT contexts=[4/8]
[    7.807126] sky2 0000:02:00.0: irq 25 for MSI/MSI-X
[    7.807751] sky2 0000:02:00.0: eth0: addr 00:17:f2:cb:e3:71
[    7.829429] power_supply BAT0: uevent
[    7.829432] power_supply BAT0: No power supply yet
[    7.829570] power_supply BAT0: power_supply_changed
[    7.829790] power_supply BAT0: power_supply_changed_work
[    7.854969] ACPI: Battery Slot [BAT0] (battery present)
[    7.910336] power_supply BAT0: power_supply_update_bat_leds 2
[    7.910360] power_supply BAT0: uevent
[    7.910362] power_supply BAT0: POWER_SUPPLY_NAME=BAT0
[    7.910366] power_supply BAT0: Static prop TYPE=Battery
[    7.910370] power_supply BAT0: 14 dynamic props
[    7.910373] power_supply BAT0: prop STATUS=Discharging
[    7.910378] power_supply BAT0: prop PRESENT=1
[    7.910383] power_supply BAT0: prop TECHNOLOGY=Unknown
[    7.910387] power_supply BAT0: prop CYCLE_COUNT=0
[    7.910391] power_supply BAT0: prop VOLTAGE_MIN_DESIGN=10800000
[    7.910395] power_supply BAT0: prop VOLTAGE_NOW=11732000
[    7.910399] power_supply BAT0: prop CURRENT_NOW=48464000
[    7.910402] power_supply BAT0: prop POWER_NOW=48464000
[    7.910406] power_supply BAT0: prop ENERGY_FULL_DESIGN=55000000
[    7.910411] power_supply BAT0: prop ENERGY_FULL=47710000
[    7.910414] power_supply BAT0: prop ENERGY_NOW=46820000
[    7.910418] power_supply BAT0: prop MODEL_NAME=ASMB012
[    7.910422] power_supply BAT0: prop MANUFACTURER=SMPN012
[    7.910426] power_supply BAT0: prop SERIAL_NUMBER=
[    7.910689] power_supply BAT0: uevent
[    7.910692] power_supply BAT0: POWER_SUPPLY_NAME=BAT0
[    7.910696] power_supply BAT0: Static prop TYPE=Battery
[    7.910699] power_supply BAT0: 14 dynamic props
[    7.910703] power_supply BAT0: prop STATUS=Discharging
[    7.910707] power_supply BAT0: prop PRESENT=1
[    7.910711] power_supply BAT0: prop TECHNOLOGY=Unknown
[    7.910715] power_supply BAT0: prop CYCLE_COUNT=0
[    7.910720] power_supply BAT0: prop VOLTAGE_MIN_DESIGN=10800000
[    7.910724] power_supply BAT0: prop VOLTAGE_NOW=11732000
[    7.910728] power_supply BAT0: prop CURRENT_NOW=48464000
[    7.910732] power_supply BAT0: prop POWER_NOW=48464000
[    7.910736] power_supply BAT0: prop ENERGY_FULL_DESIGN=55000000
[    7.910741] power_supply BAT0: prop ENERGY_FULL=47710000
[    7.910745] power_supply BAT0: prop ENERGY_NOW=46820000
[    7.910749] power_supply BAT0: prop MODEL_NAME=ASMB012
[    7.910753] power_supply BAT0: prop MANUFACTURER=SMPN012
[    7.910757] power_supply BAT0: prop SERIAL_NUMBER=
[    7.991294] usb 4-2: new full speed USB device using uhci_hcd and 
address 2
[    8.169312] hda_codec: STAC922x, Apple subsys_id=106b1e00
[    8.213851] generic-usb 0003:05AC:8240.0003: hiddev0: USB HID v1.11 
Device [Apple Computer, Inc. IR Receiver] on usb-0000:00:1d.2-2/input0
[    8.296212] usb 1-4: usbfs: USBDEVFS_CONTROL failed cmd ift-load rqt 
64 rq 160 len 1 ret -71
[    8.299726] usb 1-4: usbfs: USBDEVFS_CONTROL failed cmd ift-load rqt 
64 rq 160 len 1 ret -71
[    8.301350] ath9k 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> 
IRQ 17
[    8.330317] ath9k 0000:03:00.0: setting latency timer to 64
[    8.464861] ath: EEPROM regdomain: 0x64
[    8.464866] ath: EEPROM indicates we should expect a direct regpair map
[    8.464872] ath: Country alpha2 being used: 00
[    8.464876] ath: Regpair used: 0x64
[    8.493293] phy0: Selected rate control algorithm 'ath9k_rate_control'
[    8.493785] Registered led device: ath9k-phy0::radio
[    8.493852] Registered led device: ath9k-phy0::assoc
[    8.493907] Registered led device: ath9k-phy0::tx
[    8.493967] Registered led device: ath9k-phy0::rx
[    8.493972] phy0: Atheros AR5418 MAC/BB Rev:2 AR5133 RF Rev:81 
mem=0xffffc90000c40000, irq=17
[    8.522564] usb 5-1: new full speed USB device using uhci_hcd and 
address 2
[    8.765409] input: HID 05ac:1000 as 
/devices/pci0000:00/0000:00:1d.3/usb5/5-1/5-1:1.0/input/input8
[    8.803719] generic-usb 0003:05AC:1000.0004: input: USB HID v1.11 
Keyboard [HID 05ac:1000] on usb-0000:00:1d.3-1/input0
[    8.848406] input: HID 05ac:1000 as 
/devices/pci0000:00/0000:00:1d.3/usb5/5-1/5-1:1.1/input/input9
[    8.887164] generic-usb 0003:05AC:1000.0005: input: USB HID v1.11 
Mouse [HID 05ac:1000] on usb-0000:00:1d.3-1/input1
[    8.926346] usb 1-4: USB disconnect, address 3
[    8.940850] usb 5-1: usbfs: USBDEVFS_CONTROL failed cmd hid2hci rqt 
64 rq 0 len 0 ret -84
[    9.014552] ieee1394: Host added: ID:BUS[0-00:1023] 
GUID[0019e3fffe2ad87e]
[    9.182951] SELinux: initialized (dev tmpfs, type tmpfs), uses 
transition SIDs
[    9.251396] usb 5-1: USB disconnect, address 2
[    9.279223] Adding 390620k swap on /dev/sda4.  Priority:1 extents:1 
across:390620k
[    9.522117] usb 5-1: new full speed USB device using uhci_hcd and 
address 3
[    9.990077] usb 1-4: new high speed USB device using ehci_hcd and 
address 7
[   10.135474] uvcvideo: Found UVC 1.00 device Built-in iSight (05ac:8501)
[   10.137882] uvcvideo: UVC non compliance - GET_DEF(PROBE) not 
supported. Enabling workaround.
[   10.999320] type=1107 audit(1273772194.999:3): user pid=1920 uid=0 
auid=4294967295 ses=4294967295 subj=system_u:system_r:initrc_t:s0 
msg='avc:  denied  { getgrp } for 
scontext=system_u:system_r:syslogd_t:s0 
tcontext=system_u:system_r:initrc_t:s0 tclass=nscd
[   10.999328] : exe="/usr/sbin/nscd" sauid=0 hostname=? addr=? terminal=?'
[   11.355566] ip_tables: (C) 2000-2006 Netfilter Core Team
[   11.394361] nf_conntrack version 0.5.0 (7883 buckets, 31532 max)
[   11.395908] CONFIG_NF_CT_ACCT is deprecated and will be removed soon. 
Please use
[   11.395911] nf_conntrack.acct=1 kernel parameter, acct=1 nf_conntrack 
module option or
[   11.395913] sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
[   11.754803] type=1107 audit(1273772195.754:4): user pid=1920 uid=0 
auid=4294967295 ses=4294967295 subj=system_u:system_r:initrc_t:s0 
msg='avc:  denied  { getgrp } for 
scontext=system_u:system_r:system_dbusd_t:s0-s0:c0.c255 
tcontext=system_u:system_r:initrc_t:s0 tclass=nscd
[   11.754812] : exe="/usr/sbin/nscd" sauid=0 hostname=? addr=? terminal=?'
[   13.602383] applesmc: light sensor data length set to 6
[   13.791855] type=1107 audit(1273772197.791:5): user pid=1920 uid=0 
auid=4294967295 ses=4294967295 subj=system_u:system_r:initrc_t:s0 
msg='avc:  denied  { getgrp } for 
scontext=system_u:system_r:crond_t:s0-s0:c0.c255 
tcontext=system_u:system_r:initrc_t:s0 tclass=nscd
[   13.791863] : exe="/usr/sbin/nscd" sauid=0 hostname=? addr=? terminal=?'
[   13.997828] sky2 0000:02:00.0: eth0: enabling interface
[   20.149711] type=1100 audit(1273772204.149:6): user pid=2024 uid=0 
auid=4294967295 ses=4294967295 
subj=system_u:system_r:local_login_t:s0-s0:c0.c255 
msg='op=PAM:authentication acct="name" exe="/bin/login" hostname=? 
addr=? terminal=/dev/tty1 res=success'
[   20.155131] type=1101 audit(1273772204.155:7): user pid=2024 uid=0 
auid=4294967295 ses=4294967295 
subj=system_u:system_r:local_login_t:s0-s0:c0.c255 
msg='op=PAM:accounting acct="name" exe="/bin/login" hostname=? addr=? 
terminal=/dev/tty1 res=success'
[   20.241945] type=1006 audit(1273772204.241:8): login pid=2024 uid=0 
old auid=4294967295 new auid=1000 old ses=4294967295 new ses=1
[   20.323652] type=2300 audit(1273772204.323:9): user pid=2024 uid=0 
auid=1000 ses=1 subj=system_u:system_r:local_login_t:s0-s0:c0.c255 
msg='pam: default-context=name:staff_r:staff_t:s0 
selected-context=name:staff_r:staff_t:s0: exe="/bin/login" hostname=? 
addr=? terminal=tty1 res=success'
[   20.429245] type=1105 audit(1273772204.429:10): user pid=2024 uid=0 
auid=1000 ses=1 subj=system_u:system_r:local_login_t:s0-s0:c0.c255 
msg='op=PAM:session_open acct="name" exe="/bin/login" hostname=? addr=? 
terminal=/dev/tty1 res=success'
[   20.433746] type=1107 audit(1273772204.433:11): user pid=1920 uid=0 
auid=4294967295 ses=4294967295 subj=system_u:system_r:initrc_t:s0 
msg='avc:  denied  { getgrp } for 
scontext=system_u:system_r:local_login_t:s0-s0:c0.c255 
tcontext=system_u:system_r:initrc_t:s0 tclass=nscd
[   20.433754] : exe="/usr/sbin/nscd" sauid=0 hostname=? addr=? terminal=?'
[   20.441801] type=1103 audit(1273772204.441:12): user pid=2024 uid=0 
auid=1000 ses=1 subj=system_u:system_r:local_login_t:s0-s0:c0.c255 
msg='op=PAM:setcred acct="name" exe="/bin/login" hostname=? addr=? 
terminal=/dev/tty1 res=success'
[   20.442096] type=1112 audit(1273772204.442:13): user pid=2024 uid=0 
auid=1000 ses=1 subj=system_u:system_r:local_login_t:s0-s0:c0.c255 
msg='op=login acct="name" exe="/bin/login" hostname=? addr=? 
terminal=/dev/tty1 res=success'
[   23.570733] [drm] Initialized drm 1.1.0 20060810
[   23.716956] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   23.716962] Bluetooth: BNEP filters: protocol multicast
[   23.784568] [drm] radeon defaulting to userspace modesetting.
[   23.785565] pci 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   23.785573] pci 0000:01:00.0: setting latency timer to 64
[   23.788528] [drm] Initialized radeon 1.33.0 20080528 for 0000:01:00.0 
on minor 0
[   23.824131] Bluetooth: SCO (Voice Link) ver 0.6
[   23.824136] Bluetooth: SCO socket layer initialized
[   24.048660] [drm] Setting GART location based on new memory map
[   24.049986] [drm] Loading R500 Microcode
[   24.049993] platform radeon_cp.0: firmware: requesting radeon/R520_cp.bin
[   24.140479] [drm] Num pipes: 1
[   24.140492] [drm] writeback test succeeded in 1 usecs
[   70.715375] ath9k: Two wiphys trying to scan at the same time
[   96.380992] input: Apple Wireless Mouse as 
/devices/pci0000:00/0000:00:1d.3/usb5/5-1/5-1:1.0/bluetooth/hci0/hci0:46/input10
[   96.381560] magicmouse 0005:05AC:030D.0006: input: BLUETOOTH HID 
v0.84 Mouse [Apple Wireless Mouse] on 00:17:F2:B4:BC:F5
[   96.392521] input: Apple Wireless Mouse as 
/devices/pci0000:00/0000:00:1d.3/usb5/5-1/5-1:1.0/bluetooth/hci0/hci0:46/input11
[  139.158731] wlan0: authenticate with 00:15:c7:fd:db:f0 (try 1)
[  139.160475] wlan0: authenticated
[  139.169204] wlan0: associate with 00:15:c7:fd:db:f0 (try 1)
[  139.172329] wlan0: RX AssocResp from 00:15:c7:fd:db:f0 (capab=0x1 
status=0 aid=4)
[  139.172332] wlan0: associated
[  142.735153] wlan0: deauthenticating from 00:15:c7:fd:db:f0 by local 
choice (reason=3)
[  142.746258] cfg80211: Calling CRDA to update world regulatory domain
[  247.410369] wlan0: deauthenticating from 00:15:c7:fd:db:f0 by local 
choice (reason=3)
[  247.414201] wlan0: deauthenticating from 00:15:c7:fd:db:f0 by local 
choice (reason=3)
[  247.422493] wlan0: authenticate with 00:14:1b:5a:81:70 (try 1)
[  247.424352] wlan0: authenticated
[  247.424417] wlan0: associate with 00:14:1b:5a:81:70 (try 1)
[  247.433408] wlan0: RX AssocResp from 00:14:1b:5a:81:70 (capab=0x1 
status=0 aid=3)
[  247.433412] wlan0: associated
[  252.656863] FIREWALL:INPUT IN=wlan0 OUT= 
MAC=ff:ff:ff:ff:ff:ff:00:1e:52:71:70:f3:08:00 SRC=10.34.29.143 
DST=255.255.255.255 LEN=35 TOS=0x00 PREC=0x00 TTL=64 ID=4854 PROTO=UDP 
SPT=63842 DPT=4445 LEN=15
[  265.326115] wlan0: deauthenticated from 00:14:1b:5a:81:70 (Reason: 1)
[  265.330662] cfg80211: Calling CRDA to update world regulatory domain
[  615.498762] 
=============================================================================
[  615.498771] BUG kmalloc-8192: Poison overwritten
[  615.498775] 
-----------------------------------------------------------------------------
[  615.498777]
[  615.498783] INFO: 0xffff880034e82100-0xffff880034e82157. First byte 
0x80 instead of 0x6b
[  615.498802] INFO: Allocated in ath_rxbuf_alloc+0x29/0x9c [ath] 
age=176071 cpu=0 pid=0
[  615.498814] INFO: Freed in skb_release_data+0xc4/0xc9 age=27 cpu=0 pid=0
[  615.498820] INFO: Slab 0xffffea0000b92c00 objects=3 used=2 
fp=0xffff880034e82048 flags=0x40000000000040c3
[  615.498826] INFO: Object 0xffff880034e82048 @offset=8264 fp=0x(null)
[  615.498829]
[  615.498833] Bytes b4 0xffff880034e82038:  5a d0 04 00 01 00 00 00 5a 
5a 5a 5a 5a 5a 5a 5a ZÐ......ZZZZZZZZ
[  615.498861]   Object 0xffff880034e82048:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.498888]   Object 0xffff880034e82058:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.498915]   Object 0xffff880034e82068:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.498943]   Object 0xffff880034e82078:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.498970]   Object 0xffff880034e82088:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.498997]   Object 0xffff880034e82098:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499024]   Object 0xffff880034e820a8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499051]   Object 0xffff880034e820b8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499078]   Object 0xffff880034e820c8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499105]   Object 0xffff880034e820d8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499133]   Object 0xffff880034e820e8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499160]   Object 0xffff880034e820f8:  6b 6b 6b 6b 6b 6b 6b 6b 80 
00 00 00 ff ff ff ff kkkkkkkk....ÿÿÿÿ
[  615.499187]   Object 0xffff880034e82108:  ff ff f8 1e df 0c 17 8d 8e 
ee b0 c7 e7 16 00 63 ÿÿø.ß....î°Çç..c
[  615.499214]   Object 0xffff880034e82118:  0a d4 88 ad 6e 08 00 00 0a 
00 02 00 00 10 46 72 .Ô.­n.........Fr
[  615.499241]   Object 0xffff880034e82128:  65 65 20 50 75 62 6c 69 63 
20 57 69 46 69 01 04 ee.Public.WiFi..
[  615.499269]   Object 0xffff880034e82138:  82 84 8b 96 03 01 02 06 02 
00 00 2a 01 00 2f 01 ...........*../.
[  615.499296]   Object 0xffff880034e82148:  00 dd 09 00 10 18 02 00 10 
00 00 00 9d d9 c9 ec .Ý...........ÙÉì
[  615.499323]   Object 0xffff880034e82158:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499350]   Object 0xffff880034e82168:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499378]   Object 0xffff880034e82178:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499405]   Object 0xffff880034e82188:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499432]   Object 0xffff880034e82198:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499459]   Object 0xffff880034e821a8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499486]   Object 0xffff880034e821b8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499513]   Object 0xffff880034e821c8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499540]   Object 0xffff880034e821d8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499568]   Object 0xffff880034e821e8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499595]   Object 0xffff880034e821f8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499622]   Object 0xffff880034e82208:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499649]   Object 0xffff880034e82218:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82228:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82238:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82248:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82258:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82268:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82278:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82288:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82298:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e822a8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e822b8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e822c8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e822d8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e822e8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e822f8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82308:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82318:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82328:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82338:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82348:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82358:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82368:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82378:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82388:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82398:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e823a8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e823b8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e823c8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e823d8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e823e8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e823f8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82408:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82418:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82428:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82438:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82448:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82458:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82468:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82478:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82488:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82498:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e824a8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e824b8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e824c8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e824d8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e824e8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e824f8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82508:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82518:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82528:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82538:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82548:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82558:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82568:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82578:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82588:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82598:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e825a8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e825b8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e825c8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e825d8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e825e8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e825f8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82608:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82618:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82628:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82638:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82648:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82658:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82668:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82678:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82688:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82698:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e826a8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e826b8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e826c8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e826d8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e826e8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e826f8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82708:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82718:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82728:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82738:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82748:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82758:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82768:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82778:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82788:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82798:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e827a8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e827b8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e827c8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e827d8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e827e8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e827f8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82808:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82818:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82828:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82838:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82848:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82858:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82868:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82878:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82888:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82898:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e828a8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e828b8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e828c8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e828d8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e828e8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e828f8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82908:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82918:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82928:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82938:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82948:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82958:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82968:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82978:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82988:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82998:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e829a8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e829b8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e829c8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e829d8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e829e8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e829f8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82a08:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82a18:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82a28:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82a38:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82a48:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82a58:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82a68:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82a78:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82a88:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82a98:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82aa8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82ab8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82ac8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82ad8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82ae8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82af8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82b08:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82b18:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82b28:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82b38:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82b48:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82b58:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82b68:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82b78:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82b88:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82b98:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82ba8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82bb8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82bc8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82bd8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82be8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82bf8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82c08:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82c18:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82c28:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82c38:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82c48:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82c58:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82c68:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82c78:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82c88:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82c98:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82ca8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82cb8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82cc8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82cd8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82ce8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82cf8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82d08:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82d18:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82d28:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82d38:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82d48:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82d58:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82d68:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82d78:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82d88:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82d98:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82da8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82db8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82dc8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82dd8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82de8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82df8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82e08:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82e18:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82e28:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82e38:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82e48:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82e58:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82e68:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82e78:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82e88:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82e98:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82ea8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82eb8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82ec8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82ed8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82ee8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82ef8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82f08:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82f18:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82f28:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82f38:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82f48:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82f58:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82f68:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82f78:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82f88:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82f98:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82fa8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82fb8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82fc8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82fd8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82fe8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e82ff8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e83008:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e83018:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e83028:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]   Object 0xffff880034e83038:  6b 6b 6b 6b 6b 6b 6b 6b 6b 
6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
[  615.499668]  Redzone 0xffff880034e84048:  bb bb bb bb bb bb bb bb 
                      »»»»»»»»
[  615.499668]  Padding 0xffff880034e84088:  5a 5a 5a 5a 5a 5a 5a 5a 
                      ZZZZZZZZ
[  615.499668] Pid: 0, comm: swapper Not tainted 
2.6.34-rc7-00057-gcdfda35 #1
[  615.499668] Call Trace:
[  615.499668]  <IRQ>  [<ffffffff810e414c>] print_trailer+0x134/0x13d
[  615.499668]  [<ffffffff810e4679>] check_bytes_and_report+0xb5/0xe6
[  615.499668]  [<ffffffff810e4771>] check_object+0xc7/0x1ff
[  615.499668]  [<ffffffff810e62f0>] __slab_alloc+0x45b/0x568
[  615.499668]  [<ffffffffa024a029>] ? ath_rxbuf_alloc+0x29/0x9c [ath]
[  615.499668]  [<ffffffff810e6dea>] __kmalloc_track_caller+0xf8/0x17e
[  615.499668]  [<ffffffffa024a029>] ? ath_rxbuf_alloc+0x29/0x9c [ath]
[  615.499668]  [<ffffffff81324934>] __alloc_skb+0x69/0x155
[  615.499668]  [<ffffffffa024a029>] ath_rxbuf_alloc+0x29/0x9c [ath]
[  615.499668]  [<ffffffffa02dfa6c>] ath_rx_tasklet+0x214/0x591 [ath9k]
[  615.499668]  [<ffffffffa02dedd3>] ath9k_tasklet+0x55/0xc3 [ath9k]
[  615.499668]  [<ffffffff8105e0c5>] tasklet_action+0x80/0xdf
[  615.499668]  [<ffffffffa02df73e>] ? ath_isr+0x130/0x146 [ath9k]
[  615.499668]  [<ffffffff8105f31b>] __do_softirq+0xe0/0x1a1
[  615.499668]  [<ffffffff81027edc>] call_softirq+0x1c/0x28
[  615.499668]  [<ffffffff810295a5>] do_softirq+0x41/0x7e
[  615.499668]  [<ffffffff8105f196>] irq_exit+0x36/0x78
[  615.499668]  [<ffffffff81028c7b>] do_IRQ+0xa7/0xbe
[  615.499668]  [<ffffffff813e9c93>] ret_from_intr+0x0/0x11
[  615.499668]  <EOI>  [<ffffffffa002ec12>] ? 
acpi_idle_enter_bm+0x2de/0x312 [processor]
[  615.499668]  [<ffffffffa002ec0b>] ? acpi_idle_enter_bm+0x2d7/0x312 
[processor]
[  615.499668]  [<ffffffff81304f5f>] cpuidle_idle_call+0x94/0xf1
[  615.499668]  [<ffffffff810263d3>] cpu_idle+0x58/0x93
[  615.499668]  [<ffffffff813d49b0>] rest_init+0x74/0x76
[  615.499668]  [<ffffffff8167acfe>] start_kernel+0x385/0x390
[  615.499668]  [<ffffffff8167a2ac>] x86_64_start_reservations+0xb3/0xb7
[  615.499668]  [<ffffffff8167a3a8>] x86_64_start_kernel+0xf8/0x107
[  615.499668] FIX kmalloc-8192: Restoring 
0xffff880034e82100-0xffff880034e82157=0x6b
[  615.499668]
[  615.499668] FIX kmalloc-8192: Marking all objects used
