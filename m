Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452Ab0GCPU7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 11:20:59 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:57951 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715Ab0GCPUu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 11:20:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=lpL4K/EwK+avaYexbL3LpNdIEvVffSNGUbdAcnaC+NNm8w042jF5czsRCSl9KmGlaX
         4euiPjmLNmVfm+dTQZlny2f9G/0rqyAkifpnYB4CbGnzQKlWcO35XwA3e801Ied4gJbx
         Fpu5R7dcBseNSUgxWM5b4sNEnlXTufM4Um2iI=
MIME-Version: 1.0
In-Reply-To: <AANLkTimVkG9TFgyOTTnrztBjqT4JoOzFaP268vWLAAm9@mail.gmail.com>
References: <AANLkTimVkG9TFgyOTTnrztBjqT4JoOzFaP268vWLAAm9@mail.gmail.com>
Date: Sat, 3 Jul 2010 08:20:48 -0700
Message-ID: <AANLkTinO5WleYcVJrgZBVT9qTUioi3J1KJtCTCh6EklQ@mail.gmail.com>
Subject: Re: Drives missing at boot
From: Mark Knecht <markknecht@gmail.com>
To: Linux Kernel List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 2, 2010 at 10:56 AM, Mark Knecht <markknecht@gmail.com> wrote:
> Hi,
>   I have a newish machine - maybe 3 months old - which unreliably
> finds its disk drives at each boot. Probably 40% of the time booting 1
> or more drives will be missing.
>
>   So far I've been unable to determine what might be wrong. Sometimes
> it finds all 5 drives, sometimes only 4 or 3 drives. It's not always
> the same drives that are missing. Shown below are two successive warm
> boots. The machien had been running with all 5 drives working. The
> first time through it missed both /dev/sdd and /dev/sde while the very
> next time it found all 5 drives. Each of the 5 drives has been missing
> one or more times at different boots. (I.e. - it's not always drive
> sdd for instance.)
>
>   Every time I boot the AMI BIOS screen says all 5 drives are there.
> I have found that if I drop into BIOS before going to grub that
> selecting each drive one at a time and reading through it's setup
> seems to make the boot more reliable, but not 100%. Probably 80%
> reliable.
>
>   I don't know what info is required to look at this. I'm running the
> newest Gentoo kernel but it's been happening with all kernels I've
> tried since I built the machine. I'm attaching the kernel config as
> well as dmesg from the last boot which had all the drives. The only
> difference in dmesg when the drives don't show up (that I've spotted)
> is that the missing drive just isn't in dmesg. (I.e. no error messages
> that I could spot.)
>
>   Let me know what I might try or what other info you might want. The
> motherboard is an Asus Rampage II Extreme with an i7-980x 6 core/12
> thread processor. sda, sdb & sdc are part of a RAID1, sdd & sde are
> part of a RAID0.
>
> Thanks,
> Mark
>
<SNIP>

As a follow-up here's dmesg on a boot where neither sdd or sde showed up.

- Mark

mark@c2stable ~ $ ls -al /dev/sd*
brw-rw---- 1 root disk 8,  0 Jul  3  2010 /dev/sda
brw-rw---- 1 root disk 8,  1 Jul  3  2010 /dev/sda1
brw-rw---- 1 root disk 8,  2 Jul  3  2010 /dev/sda2
brw-rw---- 1 root disk 8,  3 Jul  3  2010 /dev/sda3
brw-rw---- 1 root disk 8,  4 Jul  3  2010 /dev/sda4
brw-rw---- 1 root disk 8,  5 Jul  3  2010 /dev/sda5
brw-rw---- 1 root disk 8,  6 Jul  3  2010 /dev/sda6
brw-rw---- 1 root disk 8, 16 Jul  3  2010 /dev/sdb
brw-rw---- 1 root disk 8, 17 Jul  3  2010 /dev/sdb1
brw-rw---- 1 root disk 8, 18 Jul  3  2010 /dev/sdb2
brw-rw---- 1 root disk 8, 19 Jul  3  2010 /dev/sdb3
brw-rw---- 1 root disk 8, 20 Jul  3  2010 /dev/sdb4
brw-rw---- 1 root disk 8, 21 Jul  3  2010 /dev/sdb5
brw-rw---- 1 root disk 8, 22 Jul  3  2010 /dev/sdb6
brw-rw---- 1 root disk 8, 32 Jul  3  2010 /dev/sdc
brw-rw---- 1 root disk 8, 33 Jul  3  2010 /dev/sdc1
brw-rw---- 1 root disk 8, 34 Jul  3  2010 /dev/sdc2
brw-rw---- 1 root disk 8, 35 Jul  3  2010 /dev/sdc3
brw-rw---- 1 root disk 8, 36 Jul  3  2010 /dev/sdc4
brw-rw---- 1 root disk 8, 37 Jul  3  2010 /dev/sdc5
brw-rw---- 1 root disk 8, 38 Jul  3  2010 /dev/sdc6
mark@c2stable ~ $ dmesg
Linux version 2.6.34-gentoo-r1 (root@c2stable) (gcc version 4.4.3
(Gentoo 4.4.3-r2 p1.2) ) #1 SMP PREEMPT Fri Jul 2 10:04:52 PDT 2010
Command line: root=/dev/md5
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000bf780000 (usable)
 BIOS-e820: 00000000bf780000 - 00000000bf798000 (ACPI data)
 BIOS-e820: 00000000bf798000 - 00000000bf7dc000 (ACPI NVS)
 BIOS-e820: 00000000bf7dc000 - 00000000c0000000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000340000000 (usable)
NX (Execute Disable) protection: active
DMI 2.5 present.
AMI BIOS detected: BIOS may corrupt low RAM, working around it.
e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
No AGP bridge found
last_pfn = 0x340000 max_arch_pfn = 0x400000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-DFFFF write-protect
  E0000-E7FFF write-through
  E8000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 000000000 mask E00000000 write-back
  1 base 200000000 mask F00000000 write-back
  2 base 300000000 mask FC0000000 write-back
  3 base 0C0000000 mask FC0000000 uncachable
  4 base 0BF800000 mask FFF800000 uncachable
  5 disabled
  6 disabled
  7 disabled
  8 disabled
  9 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
e820 update range: 00000000bf800000 - 0000000100000000 (usable) ==> (reserved)
last_pfn = 0xbf780 max_arch_pfn = 0x400000000
initial memory mapped : 0 - 20000000
found SMP MP-table at [ffff8800000ff780] ff780
Using GB pages for direct mapping
init_memory_mapping: 0000000000000000-00000000bf780000
 0000000000 - 0080000000 page 1G
 0080000000 - 00bf600000 page 2M
 00bf600000 - 00bf780000 page 4k
kernel direct mapping tables up to bf780000 @ 12000-15000
init_memory_mapping: 0000000100000000-0000000340000000
 0100000000 - 0340000000 page 1G
kernel direct mapping tables up to 340000000 @ 14000-15000
ACPI: RSDP 00000000000fb0c0 00014 (v00 ACPIAM)
ACPI: RSDT 00000000bf780000 00040 (v01 012810 RSDT1341 20100128 MSFT 00000097)
ACPI: FACP 00000000bf780200 00084 (v01 012810 FACP1341 20100128 MSFT 00000097)
ACPI: DSDT 00000000bf7804b0 0D2BA (v01  A1088 A1088000 00000000 INTL 20060113)
ACPI: FACS 00000000bf798000 00040
ACPI: APIC 00000000bf780390 000D8 (v01 012810 APIC1341 20100128 MSFT 00000097)
ACPI: MCFG 00000000bf780470 0003C (v01 012810 OEMMCFG  20100128 MSFT 00000097)
ACPI: OEMB 00000000bf798040 00072 (v01 012810 OEMB1341 20100128 MSFT 00000097)
ACPI: HPET 00000000bf78f4b0 00038 (v01 012810 OEMHPET  20100128 MSFT 00000097)
ACPI: OSFR 00000000bf78f4f0 000B0 (v01 012810 OEMOSFR  20100128 MSFT 00000097)
ACPI: SSDT 00000000bf79ba40 00363 (v01 DpgPmm    CpuPm 00000012 INTL 20060113)
ACPI: Local APIC address 0xfee00000
 [ffffea0000000000-ffffea000b5fffff] PMD ->
[ffff880002000000-ffff88000c7fffff] on node 0
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00340000
Movable zone start PFN for each node
early_node_map[3] active PFN ranges
    0: 0x00000010 -> 0x0000009f
    0: 0x00000100 -> 0x000bf780
    0: 0x00100000 -> 0x00340000
On node 0 totalpages: 3143439
  DMA zone: 56 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 3927 pages, LIFO batch:0
  DMA32 zone: 14280 pages used for memmap
  DMA32 zone: 765880 pages, LIFO batch:31
  Normal zone: 32256 pages used for memmap
  Normal zone: 2327040 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x10] enabled)
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x12] enabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x14] enabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x08] lapic_id[0x03] enabled)
ACPI: LAPIC (acpi_id[0x09] lapic_id[0x05] enabled)
ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x11] enabled)
ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x13] enabled)
ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x15] enabled)
ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x8c] disabled)
ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x8d] disabled)
ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x8e] disabled)
ACPI: LAPIC (acpi_id[0x10] lapic_id[0x8f] disabled)
ACPI: IOAPIC (id[0x06] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 6, version 32, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x07] address[0xfec8a000] gsi_base[24])
IOAPIC[1]: apic_id 7, version 32, address 0xfec8a000, GSI 24-47
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a301 base: 0xfed00000
16 Processors exceeds NR_CPUS limit of 12
SMP: Allowing 12 CPUs, 0 hotplug CPUs
nr_irqs_gsi: 48
early_res array is doubled to 64 at [14000 - 147ff]
Allocating PCI resources starting at c0000000 (gap: c0000000:3ee00000)
setup_percpu: NR_CPUS:12 nr_cpumask_bits:12 nr_cpu_ids:12 nr_node_ids:1
PERCPU: Embedded 26 pages/cpu @ffff880001800000 s75176 r8192 d23128 u131072
pcpu-alloc: s75176 r8192 d23128 u131072 alloc=1*2097152
pcpu-alloc: [0] 00 01 02 03 04 05 06 07 08 09 10 11 -- -- -- --
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 3096847
Kernel command line: root=/dev/md5
PID hash table entries: 4096 (order: 3, 32768 bytes)
Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
early_res array is doubled to 128 at [14800 - 157ff]
Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Checking aperture...
No AGP bridge found
Subtract (60 early reservations)
  #1 [0001000000 - 0001771244]   TEXT DATA BSS
  #2 [0001772000 - 0001772298]             BRK
  #3 [00000ff790 - 0000100000]   BIOS reserved
  #4 [00000ff780 - 00000ff790]    MP-table mpf
  #5 [000009fc00 - 00000f1310]   BIOS reserved
  #6 [00000f14fc - 00000ff780]   BIOS reserved
  #7 [00000f1310 - 00000f14fc]    MP-table mpc
  #8 [0000010000 - 0000012000]      TRAMPOLINE
  #9 [0000012000 - 0000014000]         PGTABLE
  #10 [00017722c0 - 00017732c0]         BOOTMEM
  #11 [0001771280 - 0001771880]         BOOTMEM
  #12 [0001f74000 - 0001f75000]         BOOTMEM
  #13 [0001f75000 - 0001f76000]         BOOTMEM
  #14 [0002000000 - 000c800000]        MEMMAP 0
  #15 [0001771880 - 0001771a00]         BOOTMEM
  #16 [00017732c0 - 000178b2c0]         BOOTMEM
  #17 [000178b2c0 - 00017a32c0]         BOOTMEM
  #18 [00017a4000 - 00017a5000]         BOOTMEM
  #19 [0001771a00 - 0001771a41]         BOOTMEM
  #20 [0001771a80 - 0001771b06]         BOOTMEM
  #21 [0001771b40 - 0001771da8]         BOOTMEM
  #22 [0001771dc0 - 0001771e28]         BOOTMEM
  #23 [0001771e40 - 0001771ea8]         BOOTMEM
  #24 [0001771ec0 - 0001771f28]         BOOTMEM
  #25 [0001771f40 - 0001771fa8]         BOOTMEM
  #26 [00017a32c0 - 00017a3328]         BOOTMEM
  #27 [00017a3340 - 00017a33a8]         BOOTMEM
  #28 [00017a33c0 - 00017a3428]         BOOTMEM
  #29 [00017a3440 - 00017a34a8]         BOOTMEM
  #30 [00017a34c0 - 00017a3528]         BOOTMEM
  #31 [00017a3540 - 00017a35a8]         BOOTMEM
  #32 [0001771fc0 - 0001771fce]         BOOTMEM
  #33 [00017a35c0 - 00017a35ce]         BOOTMEM
  #34 [0001800000 - 000181a000]         BOOTMEM
  #35 [0001820000 - 000183a000]         BOOTMEM
  #36 [0001840000 - 000185a000]         BOOTMEM
  #37 [0001860000 - 000187a000]         BOOTMEM
  #38 [0001880000 - 000189a000]         BOOTMEM
  #39 [00018a0000 - 00018ba000]         BOOTMEM
  #40 [00018c0000 - 00018da000]         BOOTMEM
  #41 [00018e0000 - 00018fa000]         BOOTMEM
  #42 [0001900000 - 000191a000]         BOOTMEM
  #43 [0001920000 - 000193a000]         BOOTMEM
  #44 [0001940000 - 000195a000]         BOOTMEM
  #45 [0001960000 - 000197a000]         BOOTMEM
  #46 [00017a3600 - 00017a3608]         BOOTMEM
  #47 [00017a3640 - 00017a3648]         BOOTMEM
  #48 [00017a3680 - 00017a36b0]         BOOTMEM
  #49 [00017a36c0 - 00017a3720]         BOOTMEM
  #50 [00017a3740 - 00017a3850]         BOOTMEM
  #51 [00017a3880 - 00017a38c8]         BOOTMEM
  #52 [00017a3900 - 00017a3948]         BOOTMEM
  #53 [00017a5000 - 00017ad000]         BOOTMEM
  #54 [000c800000 - 000d800000]         BOOTMEM
  #55 [000d800000 - 000e000000]         BOOTMEM
  #56 [000e000000 - 0012000000]         BOOTMEM
  #57 [00017ad000 - 00017cd000]         BOOTMEM
  #58 [000197a000 - 00019ba000]         BOOTMEM
  #59 [0000015800 - 000001d800]         BOOTMEM
Memory: 12302060k/13631488k available (3665k kernel code, 1057732k
absent, 271696k reserved, 2924k data, 476k init)
Experimental preemptable hierarchical RCU implementation.
NR_IRQS:640
Console: colour VGA+ 80x25
console [tty0] enabled
hpet clockevent registered
Fast TSC calibration using PIT
Detected 3337.655 MHz processor.
Calibrating delay loop (skipped), value calculated using timer
frequency.. 6675.31 BogoMIPS (lpj=3337655)
Security Framework initialized
Mount-cache hash table entries: 256
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 9 MCE banks
CPU0: Thermal monitoring enabled (TM1)
using mwait in idle threads.
Performance Events: Westmere events, Intel PMU driver.
... version:                3
... bit width:              48
... generic registers:      4
... value mask:             0000ffffffffffff
... max period:             000000007fffffff
... fixed-purpose events:   3
... event mask:             000000070000000f
Freeing SMP alternatives: 36k freed
ACPI: Core revision 20100121
Setting APIC routing to physical flat
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Core(TM) i7 CPU       X 980  @ 3.33GHz stepping 02
APIC calibration not consistent with PM-Timer: 103ms instead of 100ms
APIC delta adjusted to PM-Timer: 834372 (867738)
Booting Node   0, Processors  #1 #2 #3 #4 #5 #6 #7 #8 #9 #10 #11 Ok.
Brought up 12 CPUs
Total of 12 processors activated (80895.10 BogoMIPS).
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem
0xe0000000-0xefffffff] (base 0xe0000000)
PCI: not using MMCONFIG
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
ACPI: Executed 1 blocks of module-level executable AML code
ACPI: SSDT 00000000bf7980c0 03978 (v01 DpgPmm  P001Ist 00000011 INTL 20060113)
ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using IOAPIC for interrupt routing
PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem
0xe0000000-0xefffffff] (base 0xe0000000)
PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI
motherboard resources
ACPI: No dock devices found.
PCI: Using host bridge windows from ACPI; if necessary, use
"pci=nocrs" and report a bug
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000dffff]
pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xdfffffff]
pci_root PNP0A08:00: host bridge window [mem 0xf0000000-0xfed8ffff]
pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
pci 0000:00:00.0: PME# disabled
pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
pci 0000:00:01.0: PME# disabled
pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
pci 0000:00:03.0: PME# disabled
pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
pci 0000:00:07.0: PME# disabled
pci 0000:00:1a.0: reg 20: [io  0x9800-0x981f]
pci 0000:00:1a.1: reg 20: [io  0x9880-0x989f]
pci 0000:00:1a.2: reg 20: [io  0x9c00-0x9c1f]
pci 0000:00:1a.7: reg 10: [mem 0xfb9ff000-0xfb9ff3ff]
pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1a.7: PME# disabled
pci 0000:00:1b.0: reg 10: [mem 0xfb9f8000-0xfb9fbfff 64bit]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.2: PME# disabled
pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.4: PME# disabled
pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.5: PME# disabled
pci 0000:00:1d.0: reg 20: [io  0x9080-0x909f]
pci 0000:00:1d.1: reg 20: [io  0x9400-0x941f]
pci 0000:00:1d.2: reg 20: [io  0x9480-0x949f]
pci 0000:00:1d.7: reg 10: [mem 0xfb9fe000-0xfb9fe3ff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1f.0: quirk: [io  0x0800-0x087f] claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: [io  0x0500-0x053f] claimed by ICH6 GPIO
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0294 (mask 0003)
pci 0000:00:1f.2: reg 10: [io  0x8000-0x8007]
pci 0000:00:1f.2: reg 14: [io  0x7c00-0x7c03]
pci 0000:00:1f.2: reg 18: [io  0x7880-0x7887]
pci 0000:00:1f.2: reg 1c: [io  0x7800-0x7803]
pci 0000:00:1f.2: reg 20: [io  0x7480-0x748f]
pci 0000:00:1f.2: reg 24: [io  0x7400-0x740f]
pci 0000:00:1f.3: reg 10: [mem 0xfb9fd000-0xfb9fd0ff 64bit]
pci 0000:00:1f.3: reg 20: [io  0x0400-0x041f]
pci 0000:00:1f.5: reg 10: [io  0x9000-0x9007]
pci 0000:00:1f.5: reg 14: [io  0x8c00-0x8c03]
pci 0000:00:1f.5: reg 18: [io  0x8880-0x8887]
pci 0000:00:1f.5: reg 1c: [io  0x8800-0x8803]
pci 0000:00:1f.5: reg 20: [io  0x8480-0x848f]
pci 0000:00:1f.5: reg 24: [io  0x8400-0x840f]
pci 0000:00:01.0: PCI bridge to [bus 01-01]
pci 0000:00:01.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:01.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:00:01.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:00:03.0: PCI bridge to [bus 02-02]
pci 0000:00:03.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:03.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:00:03.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:03:00.0: reg 10: [mem 0xd0000000-0xdfffffff 64bit pref]
pci 0000:03:00.0: reg 18: [mem 0xfbac0000-0xfbadffff 64bit]
pci 0000:03:00.0: reg 20: [io  0xa000-0xa0ff]
pci 0000:03:00.0: reg 30: [mem 0xfbaa0000-0xfbabffff pref]
pci 0000:03:00.0: supports D1 D2
pci 0000:03:00.1: reg 10: [mem 0xfbafc000-0xfbafffff 64bit]
pci 0000:03:00.1: supports D1 D2
pci 0000:00:07.0: PCI bridge to [bus 03-03]
pci 0000:00:07.0:   bridge window [io  0xa000-0xafff]
pci 0000:00:07.0:   bridge window [mem 0xfba00000-0xfbafffff]
pci 0000:00:07.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
pci 0000:00:1c.0: PCI bridge to [bus 07-07]
pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:00:1c.0:   bridge window [mem 0xfaf00000-0xfaffffff 64bit pref]
pci 0000:06:00.0: reg 10: [mem 0xfbdfc000-0xfbdfffff 64bit]
pci 0000:06:00.0: reg 18: [io  0xd800-0xd8ff]
pci 0000:06:00.0: reg 30: [mem 0xfbdc0000-0xfbddffff pref]
pci 0000:06:00.0: supports D1 D2
pci 0000:06:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:06:00.0: PME# disabled
pci 0000:00:1c.2: PCI bridge to [bus 06-06]
pci 0000:00:1c.2:   bridge window [io  0xd000-0xdfff]
pci 0000:00:1c.2:   bridge window [mem 0xfbd00000-0xfbdfffff]
pci 0000:00:1c.2:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:05:00.0: reg 24: [mem 0xfbcfe000-0xfbcfffff]
pci 0000:05:00.0: PME# supported from D3hot
pci 0000:05:00.0: PME# disabled
pci 0000:05:00.1: reg 10: [io  0xcc00-0xcc07]
pci 0000:05:00.1: reg 14: [io  0xc880-0xc883]
pci 0000:05:00.1: reg 18: [io  0xc800-0xc807]
pci 0000:05:00.1: reg 1c: [io  0xc480-0xc483]
pci 0000:05:00.1: reg 20: [io  0xc400-0xc40f]
pci 0000:00:1c.4: PCI bridge to [bus 05-05]
pci 0000:00:1c.4:   bridge window [io  0xc000-0xcfff]
pci 0000:00:1c.4:   bridge window [mem 0xfbc00000-0xfbcfffff]
pci 0000:00:1c.4:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:04:00.0: reg 10: [mem 0xfbbfc000-0xfbbfffff 64bit]
pci 0000:04:00.0: reg 18: [io  0xb800-0xb8ff]
pci 0000:04:00.0: reg 30: [mem 0xfbbc0000-0xfbbdffff pref]
pci 0000:04:00.0: supports D1 D2
pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:04:00.0: PME# disabled
pci 0000:00:1c.5: PCI bridge to [bus 04-04]
pci 0000:00:1c.5:   bridge window [io  0xb000-0xbfff]
pci 0000:00:1c.5:   bridge window [mem 0xfbb00000-0xfbbfffff]
pci 0000:00:1c.5:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:08:02.0: reg 10: [mem 0xfbeff000-0xfbeff7ff]
pci 0000:08:02.0: reg 14: [io  0xec00-0xec7f]
pci 0000:08:02.0: supports D2
pci 0000:08:02.0: PME# supported from D2 D3hot D3cold
pci 0000:08:02.0: PME# disabled
pci 0000:00:1e.0: PCI bridge to [bus 08-08] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0xe000-0xefff]
pci 0000:00:1e.0:   bridge window [mem 0xfbe00000-0xfbefffff]
pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff]
(subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000dffff]
(subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xdfffffff]
(subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xfed8ffff]
(subtractive decode)
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P6._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P8._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE7._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs *5)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 6 7 10 11 12 *14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 6 7 10 11 12 14 *15)
ACPI: PCI Interrupt Link [LNKF] (IRQs *3 4 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 6 *7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 *4 6 7 10 11 12 14 15)
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
reserve RAM buffer: 000000000009fc00 - 000000000009ffff
reserve RAM buffer: 00000000bf780000 - 00000000bfffffff
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
hpet0: 4 comparators, 64-bit 14.318180 MHz counter
Switching to clocksource tsc
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 17 devices
ACPI: ACPI bus type pnp unregistered
system 00:01: [mem 0xfbf00000-0xfbffffff] has been reserved
system 00:01: [mem 0xfc000000-0xfcffffff] has been reserved
system 00:01: [mem 0xfd000000-0xfdffffff] has been reserved
system 00:01: [mem 0xfe000000-0xfebfffff] has been reserved
system 00:01: [mem 0xfec8a000-0xfec8afff] could not be reserved
system 00:01: [mem 0xfed10000-0xfed10fff] has been reserved
system 00:07: [io  0x0290-0x029f] has been reserved
system 00:08: [io  0x04d0-0x04d1] has been reserved
system 00:08: [io  0x0800-0x087f] has been reserved
system 00:08: [io  0x0500-0x057f] could not be reserved
system 00:08: [mem 0xfed1c000-0xfed1ffff] has been reserved
system 00:08: [mem 0xfed20000-0xfed3ffff] has been reserved
system 00:08: [mem 0xfed40000-0xfed8ffff] has been reserved
system 00:0b: [mem 0xffc00000-0xffdfffff] has been reserved
system 00:0c: [mem 0xfec00000-0xfec00fff] could not be reserved
system 00:0c: [mem 0xfee00000-0xfee00fff] has been reserved
system 00:0f: [mem 0xe0000000-0xefffffff] has been reserved
system 00:10: [mem 0x00000000-0x0009ffff] could not be reserved
system 00:10: [mem 0x000c0000-0x000cffff] has been reserved
system 00:10: [mem 0x000e0000-0x000fffff] could not be reserved
system 00:10: [mem 0x00100000-0xbfffffff] could not be reserved
system 00:10: [mem 0xfed90000-0xffffffff] could not be reserved
pci 0000:00:1c.0: BAR 8: assigned [mem 0xc0000000-0xc03fffff]
pci 0000:00:1c.2: BAR 9: assigned [mem 0xc0400000-0xc05fffff 64bit pref]
pci 0000:00:1c.4: BAR 9: assigned [mem 0xc0600000-0xc07fffff 64bit pref]
pci 0000:00:1c.5: BAR 9: assigned [mem 0xc0800000-0xc09fffff 64bit pref]
pci 0000:00:1c.0: BAR 7: assigned [io  0x1000-0x1fff]
pci 0000:00:01.0: PCI bridge to [bus 01-01]
pci 0000:00:01.0:   bridge window [io  disabled]
pci 0000:00:01.0:   bridge window [mem disabled]
pci 0000:00:01.0:   bridge window [mem pref disabled]
pci 0000:00:03.0: PCI bridge to [bus 02-02]
pci 0000:00:03.0:   bridge window [io  disabled]
pci 0000:00:03.0:   bridge window [mem disabled]
pci 0000:00:03.0:   bridge window [mem pref disabled]
pci 0000:00:07.0: PCI bridge to [bus 03-03]
pci 0000:00:07.0:   bridge window [io  0xa000-0xafff]
pci 0000:00:07.0:   bridge window [mem 0xfba00000-0xfbafffff]
pci 0000:00:07.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
pci 0000:00:1c.0: PCI bridge to [bus 07-07]
pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
pci 0000:00:1c.0:   bridge window [mem 0xc0000000-0xc03fffff]
pci 0000:00:1c.0:   bridge window [mem 0xfaf00000-0xfaffffff 64bit pref]
pci 0000:00:1c.2: PCI bridge to [bus 06-06]
pci 0000:00:1c.2:   bridge window [io  0xd000-0xdfff]
pci 0000:00:1c.2:   bridge window [mem 0xfbd00000-0xfbdfffff]
pci 0000:00:1c.2:   bridge window [mem 0xc0400000-0xc05fffff 64bit pref]
pci 0000:00:1c.4: PCI bridge to [bus 05-05]
pci 0000:00:1c.4:   bridge window [io  0xc000-0xcfff]
pci 0000:00:1c.4:   bridge window [mem 0xfbc00000-0xfbcfffff]
pci 0000:00:1c.4:   bridge window [mem 0xc0600000-0xc07fffff 64bit pref]
pci 0000:00:1c.5: PCI bridge to [bus 04-04]
pci 0000:00:1c.5:   bridge window [io  0xb000-0xbfff]
pci 0000:00:1c.5:   bridge window [mem 0xfbb00000-0xfbbfffff]
pci 0000:00:1c.5:   bridge window [mem 0xc0800000-0xc09fffff 64bit pref]
pci 0000:00:1e.0: PCI bridge to [bus 08-08]
pci 0000:00:1e.0:   bridge window [io  0xe000-0xefff]
pci 0000:00:1e.0:   bridge window [mem 0xfbe00000-0xfbefffff]
pci 0000:00:1e.0:   bridge window [mem pref disabled]
pci 0000:00:01.0: setting latency timer to 64
pci 0000:00:03.0: setting latency timer to 64
pci 0000:00:07.0: setting latency timer to 64
pci 0000:00:1c.0: enabling device (0106 -> 0107)
pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
pci 0000:00:1c.2: setting latency timer to 64
pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.4: setting latency timer to 64
pci 0000:00:1c.5: PCI INT B -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.5: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff]
pci_bus 0000:00: resource 8 [mem 0xc0000000-0xdfffffff]
pci_bus 0000:00: resource 9 [mem 0xf0000000-0xfed8ffff]
pci_bus 0000:03: resource 0 [io  0xa000-0xafff]
pci_bus 0000:03: resource 1 [mem 0xfba00000-0xfbafffff]
pci_bus 0000:03: resource 2 [mem 0xd0000000-0xdfffffff 64bit pref]
pci_bus 0000:07: resource 0 [io  0x1000-0x1fff]
pci_bus 0000:07: resource 1 [mem 0xc0000000-0xc03fffff]
pci_bus 0000:07: resource 2 [mem 0xfaf00000-0xfaffffff 64bit pref]
pci_bus 0000:06: resource 0 [io  0xd000-0xdfff]
pci_bus 0000:06: resource 1 [mem 0xfbd00000-0xfbdfffff]
pci_bus 0000:06: resource 2 [mem 0xc0400000-0xc05fffff 64bit pref]
pci_bus 0000:05: resource 0 [io  0xc000-0xcfff]
pci_bus 0000:05: resource 1 [mem 0xfbc00000-0xfbcfffff]
pci_bus 0000:05: resource 2 [mem 0xc0600000-0xc07fffff 64bit pref]
pci_bus 0000:04: resource 0 [io  0xb000-0xbfff]
pci_bus 0000:04: resource 1 [mem 0xfbb00000-0xfbbfffff]
pci_bus 0000:04: resource 2 [mem 0xc0800000-0xc09fffff 64bit pref]
pci_bus 0000:08: resource 0 [io  0xe000-0xefff]
pci_bus 0000:08: resource 1 [mem 0xfbe00000-0xfbefffff]
pci_bus 0000:08: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:08: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:08: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:08: resource 7 [mem 0x000d0000-0x000dffff]
pci_bus 0000:08: resource 8 [mem 0xc0000000-0xdfffffff]
pci_bus 0000:08: resource 9 [mem 0xf0000000-0xfed8ffff]
NET: Registered protocol family 2
IP route cache hash table entries: 524288 (order: 10, 4194304 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
UDP hash table entries: 8192 (order: 6, 262144 bytes)
UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
NET: Registered protocol family 1
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
pci 0000:03:00.0: Boot video device
PCI: CLS 256 bytes, default 64
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Placing 64MB software IO TLB between ffff88000e000000 - ffff880012000000
software IO TLB at phys 0xe000000 - 0x12000000
VFS: Disk quotas dquot_6.5.2
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
NTFS driver 2.1.29 [Flags: R/W].
fuse init (API version 7.13)
msgmni has been set to 24027
alg: No test for stdrng (krng)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
pcieport 0000:00:01.0: setting latency timer to 64
pcieport 0000:00:01.0: irq 48 for MSI/MSI-X
pcieport 0000:00:03.0: setting latency timer to 64
pcieport 0000:00:03.0: irq 49 for MSI/MSI-X
pcieport 0000:00:07.0: setting latency timer to 64
pcieport 0000:00:07.0: irq 50 for MSI/MSI-X
pcieport 0000:00:1c.0: setting latency timer to 64
pcieport 0000:00:1c.0: irq 51 for MSI/MSI-X
pcieport 0000:00:1c.2: setting latency timer to 64
pcieport 0000:00:1c.2: irq 52 for MSI/MSI-X
pcieport 0000:00:1c.4: setting latency timer to 64
pcieport 0000:00:1c.4: irq 53 for MSI/MSI-X
pcieport 0000:00:1c.5: setting latency timer to 64
pcieport 0000:00:1c.5: irq 54 for MSI/MSI-X
aer 0000:00:01.0:pcie02: AER service couldn't init device: no _OSC support
aer 0000:00:03.0:pcie02: AER service couldn't init device: no _OSC support
aer 0000:00:07.0:pcie02: AER service couldn't init device: no _OSC support
Non-volatile memory driver v1.3
input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
ACPI: Power Button [PWRB]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
ACPI: Power Button [PWRF]
Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
brd: module loaded
loop: module loaded
Uniform Multi-Platform E-IDE driver
ide-gd driver 1.18
ahci 0000:05:00.0: version 3.0
ahci 0000:05:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
ahci 0000:05:00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps 0x3 impl SATA mode
ahci 0000:05:00.0: flags: 64bit ncq pm led clo pmp pio slum part
ahci 0000:05:00.0: setting latency timer to 64
scsi0 : ahci
scsi1 : ahci
ata1: SATA max UDMA/133 abar m8192@0xfbcfe000 port 0xfbcfe100 irq 16
ata2: SATA max UDMA/133 abar m8192@0xfbcfe000 port 0xfbcfe180 irq 16
ata_piix 0000:00:1f.2: version 2.13
ata_piix 0000:00:1f.2: PCI INT B -> GSI 20 (level, low) -> IRQ 20
ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
ata_piix 0000:00:1f.2: setting latency timer to 64
scsi2 : ata_piix
scsi3 : ata_piix
ata3: SATA max UDMA/133 cmd 0x8000 ctl 0x7c00 bmdma 0x7480 irq 20
ata4: SATA max UDMA/133 cmd 0x7880 ctl 0x7800 bmdma 0x7488 irq 20
ata_piix 0000:00:1f.5: PCI INT B -> GSI 20 (level, low) -> IRQ 20
ata_piix 0000:00:1f.5: MAP [ P0 -- P1 -- ]
ata_piix 0000:00:1f.5: setting latency timer to 64
scsi4 : ata_piix
scsi5 : ata_piix
ata5: SATA max UDMA/133 cmd 0x9000 ctl 0x8c00 bmdma 0x8480 irq 20
ata6: SATA max UDMA/133 cmd 0x8880 ctl 0x8800 bmdma 0x8488 irq 20
console [netcon0] enabled
netconsole: network logging started
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
ehci_hcd 0000:00:1a.7: setting latency timer to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1a.7: debug port 1
ehci_hcd 0000:00:1a.7: cache line size of 256 is not supported
ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfb9ff000
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.34-gentoo-r1 ehci_hcd
usb usb1: SerialNumber: 0000:00:1a.7
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 256 is not supported
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfb9fe000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: EHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.34-gentoo-r1 ehci_hcd
usb usb2: SerialNumber: 0000:00:1d.7
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 6 ports detected
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1a.0: setting latency timer to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1a.0: irq 16, io base 0x00009800
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.34-gentoo-r1 uhci_hcd
usb usb3: SerialNumber: 0000:00:1a.0
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:1a.1: setting latency timer to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1a.1: irq 21, io base 0x00009880
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.34-gentoo-r1 uhci_hcd
usb usb4: SerialNumber: 0000:00:1a.1
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
uhci_hcd 0000:00:1a.2: PCI INT D -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1a.2: setting latency timer to 64
uhci_hcd 0000:00:1a.2: UHCI Host Controller
uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1a.2: irq 19, io base 0x00009c00
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.34-gentoo-r1 uhci_hcd
usb usb5: SerialNumber: 0000:00:1a.2
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
uhci_hcd 0000:00:1d.0: irq 23, io base 0x00009080
usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb6: Product: UHCI Host Controller
usb usb6: Manufacturer: Linux 2.6.34-gentoo-r1 uhci_hcd
usb usb6: SerialNumber: 0000:00:1d.0
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
uhci_hcd 0000:00:1d.1: irq 19, io base 0x00009400
usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb7: Product: UHCI Host Controller
usb usb7: Manufacturer: Linux 2.6.34-gentoo-r1 uhci_hcd
usb usb7: SerialNumber: 0000:00:1d.1
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00009480
usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb8: Product: UHCI Host Controller
usb usb8: Manufacturer: Linux 2.6.34-gentoo-r1 uhci_hcd
usb usb8: SerialNumber: 0000:00:1d.2
hub 8-0:1.0: USB hub found
hub 8-0:1.0: 2 ports detected
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usbcore: registered new interface driver libusual
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
i2c /dev entries driver
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
device-mapper: ioctl: 4.17.0-ioctl (2010-03-05) initialised: dm-devel@redhat.com
cpuidle: using governor ladder
cpuidle: using governor menu
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
TCP cubic registered
NET: Registered protocol family 17
drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
input: AT Translated Set 2 keyboard as
/devices/platform/i8042/serio0/input/input2
ata2: SATA link down (SStatus 0 SControl 300)
ata1: SATA link down (SStatus 0 SControl 300)
ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata5: SATA link down (SStatus 0 SControl 301)
usb 3-2: new full speed USB device using uhci_hcd and address 2
ata4.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata4.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata3.00: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata3.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata3.00: ATAPI: Optiarc DVD RW AD-7241S, 1.03, max UDMA/100
ata3.01: ATA-8: WDC WD5002ABYS-02B1B0, 02.03B03, max UDMA/133
ata3.01: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata4.00: ATA-8: WDC WD5002ABYS-02B1B0, 02.03B03, max UDMA/133
ata4.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata4.01: ATA-8: WDC WD5002ABYS-02B1B0, 02.03B03, max UDMA/133
ata4.01: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata3.00: configured for UDMA/100
ata4.00: configured for UDMA/133
ata3.01: configured for UDMA/133
ata4.01: configured for UDMA/133
scsi 2:0:0:0: CD-ROM            Optiarc  DVD RW AD-7241S  1.03 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 2:0:0:0: Attached scsi CD-ROM sr0
sr 2:0:0:0: Attached scsi generic sg0 type 5
scsi 2:0:1:0: Direct-Access     ATA      WDC WD5002ABYS-0 02.0 PQ: 0 ANSI: 5
sd 2:0:1:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
sd 2:0:1:0: Attached scsi generic sg1 type 0
scsi 3:0:0:0: Direct-Access     ATA      WDC WD5002ABYS-0 02.0 PQ: 0 ANSI: 5
sd 3:0:0:0: [sdb] 976773168 512-byte logical blocks: (500 GB/465 GiB)
sd 3:0:0:0: [sdb] Write Protect is off
sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 3:0:0:0: Attached scsi generic sg2 type 0
sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
scsi 3:0:1:0: Direct-Access     ATA      WDC WD5002ABYS-0 02.0 PQ: 0 ANSI: 5
 sdb:
sd 3:0:1:0: Attached scsi generic sg3 type 0
sd 2:0:1:0: [sda] Write Protect is off
sd 2:0:1:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:1:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sda: sdb1 sdb2 sdb3 sdb4 <
usb 3-2: New USB device found, idVendor=051d, idProduct=0002
usb 3-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 3-2: Product: Back-UPS BX1000G FW:869.L1 .D USB FW:L1
usb 3-2: Manufacturer: American Power Conversion
usb 3-2: SerialNumber: 3B1007X44377
 sda1 sda2 sda3 sda4 < sdb5
sd 3:0:1:0: [sdc] 976773168 512-byte logical blocks: (500 GB/465 GiB)
 sda5 sdb6 >
 sda6 >
sd 2:0:1:0: [sda] Attached SCSI disk
sd 3:0:1:0: [sdc] Write Protect is off
sd 3:0:1:0: [sdc] Mode Sense: 00 3a 00 00
sd 3:0:1:0: [sdc] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sd 3:0:0:0: [sdb] Attached SCSI disk
 sdc: sdc1 sdc2 sdc3 sdc4 < sdc5 sdc6 >
sd 3:0:1:0: [sdc] Attached SCSI disk
generic-usb 0003:051D:0002.0001: hiddev96,hidraw0: USB HID v1.00
Device [American Power Conversion Back-UPS BX1000G FW:869.L1 .D USB
FW:L1  ] on usb-0000:00:1a.0-2/input0
usb 8-2: new low speed USB device using uhci_hcd and address 2
usb 8-2: New USB device found, idVendor=045e, idProduct=0039
usb 8-2: New USB device strings: Mfr=1, Product=3, SerialNumber=0
usb 8-2: Product: Microsoft 5-Button Mouse with IntelliEye(TM)
usb 8-2: Manufacturer: Microsoft
input: Microsoft Microsoft 5-Button Mouse with IntelliEye(TM) as
/devices/pci0000:00/0000:00:1d.2/usb8/8-2/8-2:1.0/input/input3
generic-usb 0003:045E:0039.0002: input,hidraw1: USB HID v1.10 Mouse
[Microsoft Microsoft 5-Button Mouse with IntelliEye(TM)] on
usb-0000:00:1d.2-2/input0
input: PS/2 Generic Mouse as /devices/platform/i8042/serio1/input/input4
md: Waiting for all devices to be available before autodetect
md: If you don't use raid, use raid=noautodetect
md: Autodetecting RAID arrays.
md: Scanned 6 and added 6 devices.
md: autorun ...
md: considering sdc5 ...
md:  adding sdc5 ...
md: sdc3 has different UUID to sdc5
md:  adding sdb5 ...
md: sdb3 has different UUID to sdc5
md:  adding sda5 ...
md: sda3 has different UUID to sdc5
md: created md5
md: bind<sda5>
md: bind<sdb5>
md: bind<sdc5>
md: running: <sdc5><sdb5><sda5>
raid1: raid set md5 active with 3 out of 3 mirrors
md5: detected capacity change from 0 to 53694496768
md: considering sdc3 ...
md:  adding sdc3 ...
md:  adding sdb3 ...
md:  adding sda3 ...
md: created md3
md: bind<sda3>
md: bind<sdb3>
md: bind<sdc3>
md: running: <sdc3><sdb3><sda3>
raid1: raid set md3 active with 3 out of 3 mirrors
md3: detected capacity change from 0 to 53694562304
md: ... autorun DONE.
 md5: unknown partition table
kjournald starting.  Commit interval 5 seconds
EXT3-fs (md5): mounted filesystem with writeback data mode
VFS: Mounted root (ext3 filesystem) readonly on device 9:5.
Freeing unused kernel memory: 476k freed
Write protecting the kernel read-only data: 6144k
Freeing unused kernel memory: 412k freed
Freeing unused kernel memory: 224k freed
udev: starting version 149
rtc_cmos 00:03: RTC can wake from S4
rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
 md3: unknown partition table
i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
ACPI: resource 0000:00:1f.3 [io  0x0400-0x041f] conflicts with ACPI
region SMRG [io  0x0400-0x040f 64bit pref window disabled]
ACPI: If an ACPI driver is available for this device, you should use
it instead of the native driver
sky2: driver version 1.27
sky2 0000:06:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
sky2 0000:06:00.0: setting latency timer to 64
sky2 0000:06:00.0: Yukon-2 EC Ultra chip revision 3
sky2 0000:06:00.0: irq 55 for MSI/MSI-X
sky2 0000:06:00.0: eth0: addr e0:cb:4e:97:7a:09
sky2 0000:04:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
sky2 0000:04:00.0: setting latency timer to 64
sky2 0000:04:00.0: Yukon-2 EC Ultra chip revision 3
sky2 0000:04:00.0: irq 56 for MSI/MSI-X
sky2 0000:04:00.0: eth1: addr e0:cb:4e:97:80:fd
Linux agpgart interface v0.103
[drm] Initialized drm 1.1.0 20060810
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
HDA Intel 0000:00:1b.0: irq 57 for MSI/MSI-X
HDA Intel 0000:00:1b.0: setting latency timer to 64
[drm] radeon defaulting to kernel modesetting.
[drm] radeon kernel modesetting enabled.
radeon 0000:03:00.0: PCI INT A -> GSI 30 (level, low) -> IRQ 30
radeon 0000:03:00.0: setting latency timer to 64
[drm] initializing kernel modesetting (JUNIPER 0x1002:0x68B8).
[drm] register mmio base: 0xFBAC0000
[drm] register mmio size: 131072
ATOM BIOS: JUNIPER
[drm] Clocks initialized !
[drm] 1 Power State(s)
[drm] State 0 Default (default)
[drm]   16 PCIE Lanes
[drm]   1 Clock Mode(s)
[drm]           0 engine/memory: 850000/1200000
[drm] radeon: power management initialized
radeon 0000:03:00.0: VRAM: 256M 0x00000000 - 0x0FFFFFFF (256M used)
radeon 0000:03:00.0: GTT: 512M 0x10000000 - 0x2FFFFFFF
mtrr: type mismatch for d0000000,10000000 old: write-back new: write-combining
[drm] Detected VRAM RAM=256M, BAR=256M
[drm] RAM width 128bits DDR
[TTM] Zone  kernel: Available graphics memory: 6151604 kiB.
[TTM] Zone   dma32: Available graphics memory: 2097152 kiB.
[drm] radeon: 256M of VRAM memory ready
[drm] radeon: 512M of GTT memory ready.
[drm] Radeon Display Connectors
[drm] Connector 0:
[drm]   DisplayPort
[drm]   HPD4
[drm]   DDC: 0x6440 0x6440 0x6444 0x6444 0x6448 0x6448 0x644c 0x644c
[drm]   Encoders:
[drm]     DFP1: INTERNAL_UNIPHY2
[drm] Connector 1:
[drm]   HDMI-A
[drm]   HPD5
[drm]   DDC: 0x6430 0x6430 0x6434 0x6434 0x6438 0x6438 0x643c 0x643c
[drm]   Encoders:
[drm]     DFP2: INTERNAL_UNIPHY2
[drm] Connector 2:
[drm]   DVI-I
[drm]   HPD1
[drm]   DDC: 0x6460 0x6460 0x6464 0x6464 0x6468 0x6468 0x646c 0x646c
[drm]   Encoders:
[drm]     DFP3: INTERNAL_UNIPHY1
[drm]     CRT2: INTERNAL_KLDSCP_DAC2
[drm] Connector 3:
[drm]   DVI-I
[drm]   HPD6
[drm]   DDC: 0x6450 0x6450 0x6454 0x6454 0x6458 0x6458 0x645c 0x645c
[drm]   Encoders:
[drm]     DFP4: INTERNAL_UNIPHY
[drm]     CRT1: INTERNAL_KLDSCP_DAC1
hda_codec: AD1989B: BIOS auto-probing.
[drm] fb mappable at 0xD0040000
[drm] vram apper at 0xD0000000
[drm] size 8294400
[drm] fb depth is 24
[drm]    pitch is 7680
Console: switching to colour frame buffer device 240x67
fb0: radeondrmfb frame buffer device
registered panic notifier
[drm] Initialized radeon 2.3.0 20080528 for 0000:03:00.0 on minor 0
HDA Intel 0000:03:00.1: PCI INT B -> GSI 37 (level, low) -> IRQ 37
HDA Intel 0000:03:00.1: irq 58 for MSI/MSI-X
HDA Intel 0000:03:00.1: setting latency timer to 64
EXT3-fs (md5): using internal journal
md: md6 stopped.
md: bind<sdb6>
md: bind<sdc6>
md: bind<sda6>
raid1: raid set md6 active with 3 out of 3 mirrors
md6: detected capacity change from 0 to 253354939392
 md6: unknown partition table
kjournald starting.  Commit interval 5 seconds
EXT3-fs (md6): warning: maximal mount count reached, running e2fsck is
recommended
EXT3-fs (md6): using internal journal
EXT3-fs (md6): mounted filesystem with writeback data mode
Adding 4200992k swap on /dev/sda2.  Priority:-1 extents:1 across:4200992k
Adding 4200992k swap on /dev/sdb2.  Priority:-2 extents:1 across:4200992k
Adding 4200992k swap on /dev/sdc2.  Priority:-3 extents:1 across:4200992k
sky2 0000:06:00.0: eth0: enabling interface
sky2 0000:06:00.0: eth0: Link is up at 100 Mbps, full duplex, flow control both
NET: Registered protocol family 10
/dev/vmmon[4147]: Module vmmon: registered with major=10 minor=165
/dev/vmmon[4147]: Initial HV check: anyNotCapable=0 anyUnlocked=0
anyEnabled=1 anyDisabled=0
/dev/vmmon[4147]: HV check: anyNotCapable=0 anyUnlocked=0 anyEnabled=1
anyDisabled=0
/dev/vmmon[4147]: Module vmmon: initialized
/dev/vmci[4166]: VMCI: Driver initialized.
/dev/vmci[4166]: Module vmci: registered with major=10 minor=59
/dev/vmci[4166]: Module vmci: initialized
/dev/vmnet: open called by PID 4248 (vmnet-bridge)
/dev/vmnet: hub 0 does not exist, allocating memory.
/dev/vmnet: port on hub 0 successfully opened
bridge-eth0: up
bridge-eth0: attached
/dev/vmnet: open called by PID 4255 (vmnet-dhcpd)
/dev/vmnet: hub 1 does not exist, allocating memory.
/dev/vmnet: port on hub 1 successfully opened
/dev/vmnet: open called by PID 4257 (vmnet-netifup)
/dev/vmnet: port on hub 1 successfully opened
/dev/vmnet: open called by PID 4260 (vmnet-dhcpd)
/dev/vmnet: hub 8 does not exist, allocating memory.
/dev/vmnet: port on hub 8 successfully opened
/dev/vmnet: open called by PID 4264 (vmnet-natd)
/dev/vmnet: port on hub 8 successfully opened
/dev/vmnet: open called by PID 4265 (vmnet-netifup)
/dev/vmnet: port on hub 8 successfully opened
eth0: no IPv6 routers present
vmnet1: no IPv6 routers present
vmnet8: no IPv6 routers present
mark@c2stable ~ $
