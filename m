Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758534Ab1FPRy6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 13:54:58 -0400
Received: from alice.et.bocholt.fh-gelsenkirchen.de ([193.175.197.63]:45137
	"EHLO alice.et.bocholt.fh-gelsenkirchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752823Ab1FPRyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 13:54:54 -0400
X-DKIM: Sendmail DKIM Filter v2.8.3 alice.et.bocholt.fh-gelsenkirchen.de p5GHsdCM032498
From: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [2.6.39] drm/i915: blank screen on Lenovo Ideapad U160
In-Reply-To: <20110616094030.15714852@jbarnes-desktop> (Jesse Barnes's message
	of "Thu, 16 Jun 2011 09:40:30 -0700")
References: <gi1uzevjl4.fsf@mx10.gouders.net>
	<alpine.DEB.2.00.1105311406210.5012@localhost6.localdomain6>
	<gitycau362.fsf@mx10.gouders.net> <giei3eoeic.fsf@mx10.gouders.net>
	<gi1uyx8m2f.fsf_-_@mx10.gouders.net>
	<20110615115903.685acba0@jbarnes-desktop>
	<giips6lr5a.fsf@mx10.gouders.net>
	<20110615144132.074167f3@jbarnes-desktop>
	<giei2ulpl1.fsf@mx10.gouders.net>
	<20110615150737.79cd5de7@jbarnes-desktop>
	<gi4o3q2plu.fsf@karga.hank.lab> <gizkli0zew.fsf@karga.hank.lab>
	<20110616094030.15714852@jbarnes-desktop>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
Date: Thu, 16 Jun 2011 19:54:36 +0200
Message-ID: <gisjr9ll0j.fsf@mx10.gouders.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
X-Greylist: Sender succeeded STARTTLS authentication, not delayed by milter-greylist-4.2.3 (alice.et.bocholt.fh-gelsenkirchen.de [192.168.0.63]); Thu, 16 Jun 2011 19:54:40 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

Jesse Barnes <jbarnes@virtuousgeek.org> writes:

> On Thu, 16 Jun 2011 13:49:11 +0200
> Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de> wrote:
>
>> Some redundant information, but if I change one line at another place
>> in the i915 code (whithout the above modification) the result is more
>> satisfactory on my machine, because in that case the display even works
>> after I close and reopen the lid:
>> 
>> diff --git a/drivers/gpu/drm/i915/intel_bios.c b/drivers/gpu/drm/i915/intel_bios.c
>> index 927442a..ebb67ae 100644
>> --- a/drivers/gpu/drm/i915/intel_bios.c
>> +++ b/drivers/gpu/drm/i915/intel_bios.c
>> @@ -267,7 +267,7 @@ static int intel_bios_ssc_frequency(struct drm_device *dev,
>>         case 4:
>>                 return alternate ? 100 : 96;
>>         default:
>> -               return alternate ? 100 : 120;
>> +               return alternate ? 120 : 100;
>>         }
>>  }
>
> Does your machine also work if you set the lvds_use_ssc param to 0?

Yes, that works!
I undid all modifications, compiled the i915 driver as a module (I am
not sure if that is necessary) und used i915.lvds_use_ssc=0 as a
further bootparameter, I will attach the dmesg output.

Would you say "This problem was just a case of wrong parameter usage",
then?

Dirk


--=-=-=
Content-Disposition: attachment; filename=dmesg.txt
Content-Description: dmesg

Initializing cgroup subsys cpu
Linux version 3.0.0-rc3-00055-gada9c93 (root@lena) (gcc version 4.5.2 (Gentoo 4.5.2 p1.0, pie-0.4.5) ) #11 SMP PREEMPT Thu Jun 16 19:34:22 CEST 2011
Command line: root=/dev/sda2 i915.modeset=1 i915.lvds_use_ssc=0
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009c400 (usable)
 BIOS-e820: 000000000009c400 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000dc000 - 00000000000e0000 (reserved)
 BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007327c000 (usable)
 BIOS-e820: 000000007327c000 - 0000000073282000 (reserved)
 BIOS-e820: 0000000073282000 - 00000000733e5000 (usable)
 BIOS-e820: 00000000733e5000 - 000000007340f000 (reserved)
 BIOS-e820: 000000007340f000 - 000000007346f000 (usable)
 BIOS-e820: 000000007346f000 - 0000000073470000 (reserved)
 BIOS-e820: 0000000073470000 - 00000000734f1000 (ACPI NVS)
 BIOS-e820: 00000000734f1000 - 000000007370f000 (reserved)
 BIOS-e820: 000000007370f000 - 0000000073717000 (usable)
 BIOS-e820: 0000000073717000 - 000000007371f000 (reserved)
 BIOS-e820: 000000007371f000 - 000000007377e000 (usable)
 BIOS-e820: 000000007377e000 - 000000007379f000 (ACPI NVS)
 BIOS-e820: 000000007379f000 - 00000000737e0000 (usable)
 BIOS-e820: 00000000737e0000 - 00000000737ff000 (ACPI data)
 BIOS-e820: 00000000737ff000 - 0000000073800000 (usable)
 BIOS-e820: 0000000073800000 - 000000007c000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000f080a000 - 00000000f080b000 (reserved)
 BIOS-e820: 00000000feaff000 - 00000000feb00000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
 BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
NX (Execute Disable) protection: active
DMI present.
DMI: LENOVO 08946MG/MoutCook, BIOS 33CN14WW        05/10/2010
e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
No AGP bridge found
last_pfn = 0x73800 max_arch_pfn = 0x400000000
MTRR default type: uncachable
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-D3FFF write-protect
  D4000-DBFFF uncachable
  DC000-FFFFF write-through
MTRR variable ranges enabled:
  0 disabled
  1 base 074000000 mask FFC000000 uncachable
  2 base 078000000 mask FF8000000 uncachable
  3 base 000000000 mask F80000000 write-back
  4 disabled
  5 disabled
  6 disabled
  7 disabled
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
initial memory mapped : 0 - 20000000
Base memory trampoline at [ffff880000097000] 97000 size 20480
init_memory_mapping: 0000000000000000-0000000073800000
 0000000000 - 0073800000 page 2M
kernel direct mapping tables up to 73800000 @ 737dd000-737e0000
ACPI: RSDP 00000000000f6b10 00024 (v02 LENOVO)
ACPI: XSDT 00000000737f2696 0005C (v01 LENOVO CB-01    06040000  LTP 00000000)
ACPI: FACP 00000000737e2000 000F4 (v03 INTEL  CALPELLA 06040000 PTEC 00000001)
ACPI: DSDT 00000000737e3000 0C4F4 (v02 Intel  CALPELLA 06040000 INTL 20060912)
ACPI: FACS 000000007379afc0 00040
ACPI: HPET 00000000737fed86 00038 (v01 INTEL  CALPELLA 06040000 PTEC 00000001)
ACPI: MCFG 00000000737fedbe 0003C (v01 INTEL  CALPELLA 06040000 PTEC 00000001)
ACPI: SLIC 00000000737fedfa 00176 (v01 LENOVO CB-01    06040000 LNVO 00000001)
ACPI: APIC 00000000737fef70 00068 (v01 PTLTD  ? APIC   06040000  LTP 00000000)
ACPI: BOOT 00000000737fefd8 00028 (v01 PTLTD  $SBFTBL$ 06040000  LTP 00000001)
ACPI: SSDT 00000000737e1000 009F1 (v01  PmRef    CpuPm 00003000 INTL 20051117)
ACPI: Local APIC address 0xfee00000
No NUMA configuration found
Faking a node at 0000000000000000-0000000073800000
Initmem setup node 0 0000000000000000-0000000073800000
  NODE_DATA [00000000737d8000 - 00000000737dcfff]
 [ffffea0000000000-ffffea0001bfffff] PMD -> [ffff880070c00000-ffff8800727fffff] on node 0
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   empty
Movable zone start PFN for each node
early_node_map[8] active PFN ranges
    0: 0x00000010 -> 0x0000009c
    0: 0x00000100 -> 0x0007327c
    0: 0x00073282 -> 0x000733e5
    0: 0x0007340f -> 0x0007346f
    0: 0x0007370f -> 0x00073717
    0: 0x0007371f -> 0x0007377e
    0: 0x0007379f -> 0x000737e0
    0: 0x000737ff -> 0x00073800
On node 0 totalpages: 472180
  DMA zone: 56 pages used for memmap
  DMA zone: 5 pages reserved
  DMA zone: 3919 pages, LIFO batch:0
  DMA32 zone: 6412 pages used for memmap
  DMA32 zone: 461788 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x408
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x04] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a701 base: 0xfed00000
SMP: Allowing 2 CPUs, 0 hotplug CPUs
nr_irqs_gsi: 40
Allocating PCI resources starting at 7c000000 (gap: 7c000000:64000000)
setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:2 nr_node_ids:1
PERCPU: Embedded 25 pages/cpu @ffff880073000000 s71104 r8192 d23104 u1048576
pcpu-alloc: s71104 r8192 d23104 u1048576 alloc=1*2097152
pcpu-alloc: [0] 0 1 
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 465707
Policy zone: DMA32
Kernel command line: root=/dev/sda2 i915.modeset=1 i915.lvds_use_ssc=0
PID hash table entries: 4096 (order: 3, 32768 bytes)
Checking aperture...
No AGP bridge found
Memory: 1850752k/1892352k available (4558k kernel code, 3632k absent, 37968k reserved, 2862k data, 596k init)
Preemptible hierarchical RCU implementation.
NR_IRQS:384
Extended CMOS year: 2000
Console: colour VGA+ 80x25
console [tty0] enabled
hpet clockevent registered
Fast TSC calibration using PIT
Detected 1063.978 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 2127.95 BogoMIPS (lpj=4255912)
pid_max: default: 32768 minimum: 301
Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Mount-cache hash table entries: 256
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
mce: CPU supports 9 MCE banks
CPU0: Thermal monitoring enabled (TM1)
using mwait in idle threads.
ACPI: Core revision 20110413
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Celeron(R) CPU        U3400  @ 1.07GHz stepping 05
Performance Events: PEBS fmt1+, Westmere events, Intel PMU driver.
... version:                3
... bit width:              48
... generic registers:      4
... value mask:             0000ffffffffffff
... max period:             000000007fffffff
... fixed-purpose events:   3
... event mask:             000000070000000f
Booting Node   0, Processors  #1 Ok.
smpboot cpu 1: start_ip = 97000
calibrate_delay_direct() timer_rate_max=4255940 timer_rate_min=4255778 pre_start=11635865752 pre_end=11644377492
calibrate_delay_direct() timer_rate_max=4255884 timer_rate_min=4255732 pre_start=11652889364 pre_end=11661401008
calibrate_delay_direct() timer_rate_max=4255936 timer_rate_min=4255760 pre_start=11669912768 pre_end=11678424464
calibrate_delay_direct() timer_rate_max=4255952 timer_rate_min=4255842 pre_start=11686936224 pre_end=11695448000
calibrate_delay_direct() timer_rate_max=4255934 timer_rate_min=4255810 pre_start=11703959708 pre_end=11712471452
Brought up 2 CPUs
Total of 2 processors activated (4255.92 BogoMIPS).
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
[Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
ACPI: SSDT 000000007371ac98 00222 (v01  PmRef  Cpu0Ist 00003000 INTL 20051117)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT           (null) 00222 (v01  PmRef  Cpu0Ist 00003000 INTL 20051117)
ACPI: SSDT 0000000073718018 00891 (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT           (null) 00891 (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
ACPI: SSDT 0000000073719a98 00303 (v01  PmRef    ApIst 00003000 INTL 20051117)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT           (null) 00303 (v01  PmRef    ApIst 00003000 INTL 20051117)
ACPI: SSDT 0000000073717d98 00119 (v01  PmRef    ApCst 00003000 INTL 20051117)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20051117)
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
ACPI: No dock devices found.
PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
\_SB_.PCI0:_OSC invalid UUID
_OSC request data:1 8 1f 
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fe])
pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x000d7fff]
pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x000dbfff]
pci_root PNP0A08:00: host bridge window [mem 0x000e0000-0x000e3fff]
pci_root PNP0A08:00: host bridge window [mem 0x7c000000-0xfeafffff]
pci 0000:00:00.0: [8086:0044] type 0 class 0x000600
pci 0000:00:02.0: [8086:0046] type 0 class 0x000300
pci 0000:00:02.0: reg 10: [mem 0xf0000000-0xf03fffff 64bit]
pci 0000:00:02.0: reg 18: [mem 0xd0000000-0xdfffffff 64bit pref]
pci 0000:00:02.0: reg 20: [io  0x1800-0x1807]
pci 0000:00:16.0: [8086:3b64] type 0 class 0x000780
pci 0000:00:16.0: reg 10: [mem 0xf0804000-0xf080400f 64bit]
pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
pci 0000:00:16.0: PME# disabled
pci 0000:00:1a.0: [8086:3b3c] type 0 class 0x000c03
pci 0000:00:1a.0: reg 10: [mem 0xf0806000-0xf08063ff]
pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1a.0: PME# disabled
pci 0000:00:1b.0: [8086:3b56] type 0 class 0x000403
pci 0000:00:1b.0: reg 10: [mem 0xf0800000-0xf0803fff 64bit]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: [8086:3b42] type 1 class 0x000604
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.1: [8086:3b44] type 1 class 0x000604
pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: PME# disabled
pci 0000:00:1d.0: [8086:3b34] type 0 class 0x000c03
pci 0000:00:1d.0: reg 10: [mem 0xf0807000-0xf08073ff]
pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.0: PME# disabled
pci 0000:00:1e.0: [8086:2448] type 1 class 0x000604
pci 0000:00:1f.0: [8086:3b09] type 0 class 0x000601
pci 0000:00:1f.2: [8086:3b29] type 0 class 0x000106
pci 0000:00:1f.2: reg 10: [io  0x1818-0x181f]
pci 0000:00:1f.2: reg 14: [io  0x180c-0x180f]
pci 0000:00:1f.2: reg 18: [io  0x1810-0x1817]
pci 0000:00:1f.2: reg 1c: [io  0x1808-0x180b]
pci 0000:00:1f.2: reg 20: [io  0x1820-0x183f]
pci 0000:00:1f.2: reg 24: [mem 0xf0808000-0xf08087ff]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
pci 0000:00:1f.3: [8086:3b30] type 0 class 0x000c05
pci 0000:00:1f.3: reg 10: [mem 0xf0809000-0xf08090ff 64bit]
pci 0000:00:1f.3: reg 20: [io  0x1840-0x185f]
pci 0000:00:1f.6: [8086:3b32] type 0 class 0x001180
pci 0000:00:1f.6: reg 10: [mem 0xf080a000-0xf080afff 64bit]
pci 0000:03:00.0: [1969:1063] type 0 class 0x000200
pci 0000:03:00.0: reg 10: [mem 0xf0400000-0xf043ffff 64bit]
pci 0000:03:00.0: reg 18: [io  0x2000-0x207f]
pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:03:00.0: PME# disabled
pci 0000:00:1c.0: PCI bridge to [bus 03-03]
pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
pci 0000:00:1c.0:   bridge window [mem 0xf0400000-0xf04fffff]
pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:04:00.0: [14e4:4727] type 0 class 0x000280
pci 0000:04:00.0: reg 10: [mem 0xf0500000-0xf0503fff 64bit]
pci 0000:04:00.0: supports D1 D2
pci 0000:04:00.0: PME# supported from D0 D3hot D3cold
pci 0000:04:00.0: PME# disabled
pci 0000:00:1c.1: PCI bridge to [bus 04-04]
pci 0000:00:1c.1:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:1c.1:   bridge window [mem 0xf0500000-0xf05fffff]
pci 0000:00:1c.1:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:00:1e.0: PCI bridge to [bus 0f-0f] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disabled)
pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x000e0000-0x000e3fff] (subtractive decode)
pci 0000:00:1e.0:   bridge window [mem 0x7c000000-0xfeafffff] (subtractive decode)
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
\_SB_.PCI0:_OSC invalid UUID
_OSC request data:1 1f 1f 
 pci0000:00: Requesting ACPI _OSC control (0x1d)
\_SB_.PCI0:_OSC invalid UUID
_OSC request data:1 0 1d 
 pci0000:00: ACPI _OSC request failed (AE_ERROR), returned control mask: 0x1d
ACPI _OSC control for PCIe not granted, disabling ASPM
ACPI: PCI Root Bridge [CPBG] (domain 0000 [bus ff])
pci 0000:ff:00.0: [8086:2c62] type 0 class 0x000600
pci 0000:ff:00.1: [8086:2d01] type 0 class 0x000600
pci 0000:ff:02.0: [8086:2d10] type 0 class 0x000600
pci 0000:ff:02.1: [8086:2d11] type 0 class 0x000600
pci 0000:ff:02.2: [8086:2d12] type 0 class 0x000600
pci 0000:ff:02.3: [8086:2d13] type 0 class 0x000600
 pci0000:ff: Requesting ACPI _OSC control (0x1d)
 pci0000:ff: ACPI _OSC request failed (AE_NOT_FOUND), returned control mask: 0x1d
ACPI _OSC control for PCIe not granted, disabling ASPM
ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 *10 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 *5 6 7 11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 *7 10 12 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 *11 12 14 15)
vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
vgaarb: bridge control possible 0000:00:02.0
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
wmi: Mapper loaded
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
reserve RAM buffer: 000000000009c400 - 000000000009ffff 
reserve RAM buffer: 000000007327c000 - 0000000073ffffff 
reserve RAM buffer: 00000000733e5000 - 0000000073ffffff 
reserve RAM buffer: 000000007346f000 - 0000000073ffffff 
reserve RAM buffer: 0000000073717000 - 0000000073ffffff 
reserve RAM buffer: 000000007377e000 - 0000000073ffffff 
reserve RAM buffer: 00000000737e0000 - 0000000073ffffff 
reserve RAM buffer: 0000000073800000 - 0000000073ffffff 
Bluetooth: Core ver 2.16
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
hpet0: 8 comparators, 64-bit 14.318180 MHz counter
Switching to clocksource hpet
cfg80211: Calling CRDA to update world regulatory domain
Switched to NOHz mode on CPU #0
Switched to NOHz mode on CPU #1
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:00: [bus 00-fe]
pnp 00:00: [io  0x0000-0x0cf7 window]
pnp 00:00: [io  0x0cf8-0x0cff]
pnp 00:00: [io  0x0d00-0xffff window]
pnp 00:00: [mem 0x000a0000-0x000bffff window]
pnp 00:00: [mem 0x000c0000-0x000c3fff window]
pnp 00:00: [mem 0x000c4000-0x000c7fff window]
pnp 00:00: [mem 0x000c8000-0x000cbfff window]
pnp 00:00: [mem 0x000cc000-0x000cffff window]
pnp 00:00: [mem 0x000d0000-0x000d3fff window]
pnp 00:00: [mem 0x000d4000-0x000d7fff window]
pnp 00:00: [mem 0x000d8000-0x000dbfff window]
pnp 00:00: [mem 0x000dc000-0x000dffff window]
pnp 00:00: [mem 0x000e0000-0x000e3fff window]
pnp 00:00: [mem 0x000e4000-0x000e7fff window]
pnp 00:00: [mem 0x000e8000-0x000ebfff window]
pnp 00:00: [mem 0x000ec000-0x000effff window]
pnp 00:00: [mem 0x000f0000-0x000fffff window]
pnp 00:00: [mem 0x7c000000-0xfeafffff window]
pnp 00:00: [mem 0xfed40000-0xfed44fff window]
pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
pnp 00:01: [io  0x0000-0x001f]
pnp 00:01: [io  0x0081-0x0091]
pnp 00:01: [io  0x0093-0x009f]
pnp 00:01: [io  0x00c0-0x00df]
pnp 00:01: [dma 4]
pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
pnp 00:02: [mem 0xff000000-0xffffffff]
pnp 00:02: Plug and Play ACPI device, IDs INT0800 (active)
pnp 00:03: [irq 0 disabled]
pnp 00:03: [irq 8]
pnp 00:03: [mem 0xfed00000-0xfed003ff]
pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
pnp 00:04: [io  0x00f0]
pnp 00:04: [irq 13]
pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
pnp 00:05: [io  0x002e-0x002f]
pnp 00:05: [io  0x004e-0x004f]
pnp 00:05: [io  0x0061]
pnp 00:05: [io  0x0063]
pnp 00:05: [io  0x0065]
pnp 00:05: [io  0x0067]
pnp 00:05: [io  0x0070]
pnp 00:05: [io  0x0080]
pnp 00:05: [io  0x0092]
pnp 00:05: [io  0x00b2-0x00b3]
pnp 00:05: [io  0x0068-0x006f]
pnp 00:05: [io  0x0500-0x050f]
pnp 00:05: [io  0xffff]
pnp 00:05: [io  0xffff]
pnp 00:05: [io  0x0400-0x047f]
pnp 00:05: [io  0x1180-0x11ff]
pnp 00:05: [io  0xfe00]
pnp 00:05: [mem 0xff800000-0xff800fff]
system 00:05: [io  0x0500-0x050f] has been reserved
system 00:05: [io  0xffff] has been reserved
system 00:05: [io  0xffff] has been reserved
system 00:05: [io  0x0400-0x047f] has been reserved
system 00:05: [io  0x1180-0x11ff] has been reserved
system 00:05: [io  0xfe00] has been reserved
system 00:05: [mem 0xff800000-0xff800fff] has been reserved
system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:06: [io  0x0070-0x0077]
pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
pnp 00:07: [io  0x0060]
pnp 00:07: [io  0x0064]
pnp 00:07: [irq 1]
pnp 00:07: Plug and Play ACPI device, IDs PNP0303 (active)
pnp 00:08: [irq 12]
pnp 00:08: Plug and Play ACPI device, IDs SYN0321 SYN0300 SYN0002 PNP0f13 (active)
pnp 00:09: [mem 0xfed1c000-0xfed1ffff]
pnp 00:09: [mem 0xfed10000-0xfed13fff]
pnp 00:09: [mem 0xfed18000-0xfed18fff]
pnp 00:09: [mem 0xfed19000-0xfed19fff]
pnp 00:09: [mem 0xe0000000-0xefffffff]
pnp 00:09: [mem 0x00000000-0xffffffffffffffff disabled]
pnp 00:09: [mem 0xfeaff000-0xfeafffff]
pnp 00:09: [mem 0xfed20000-0xfed3ffff]
pnp 00:09: [mem 0xfed90000-0xfed8ffff disabled]
pnp 00:09: [mem 0xfed40000-0xfed44fff]
pnp 00:09: [mem 0xfed45000-0xfed8ffff]
pnp 00:09: [mem 0xff000000-0xffffffff]
pnp 00:09: [mem 0xfee00000-0xfeefffff]
pnp 00:09: [mem 0xfe800000-0xfe80ffff]
system 00:09: [mem 0xfed1c000-0xfed1ffff] has been reserved
system 00:09: [mem 0xfed10000-0xfed13fff] has been reserved
system 00:09: [mem 0xfed18000-0xfed18fff] has been reserved
system 00:09: [mem 0xfed19000-0xfed19fff] has been reserved
system 00:09: [mem 0xe0000000-0xefffffff] has been reserved
system 00:09: [mem 0xfeaff000-0xfeafffff] has been reserved
system 00:09: [mem 0xfed20000-0xfed3ffff] has been reserved
system 00:09: [mem 0xfed40000-0xfed44fff] has been reserved
system 00:09: [mem 0xfed45000-0xfed8ffff] has been reserved
system 00:09: [mem 0xff000000-0xffffffff] could not be reserved
system 00:09: [mem 0xfee00000-0xfeefffff] could not be reserved
system 00:09: [mem 0xfe800000-0xfe80ffff] has been reserved
system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:0a: [bus ff]
pnp 00:0a: Plug and Play ACPI device, IDs PNP0a03 (active)
pnp: PnP ACPI: found 11 devices
ACPI: ACPI bus type pnp unregistered
PCI: max bus depth: 1 pci_try_num: 2
pci 0000:00:1c.1: BAR 9: assigned [mem 0x7c000000-0x7c1fffff 64bit pref]
pci 0000:00:1c.1: BAR 7: assigned [io  0x3000-0x3fff]
pci 0000:00:1c.0: BAR 9: assigned [mem 0x7c200000-0x7c3fffff 64bit pref]
pci 0000:00:1c.0: PCI bridge to [bus 03-03]
pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
pci 0000:00:1c.0:   bridge window [mem 0xf0400000-0xf04fffff]
pci 0000:00:1c.0:   bridge window [mem 0x7c200000-0x7c3fffff 64bit pref]
pci 0000:00:1c.1: PCI bridge to [bus 04-04]
pci 0000:00:1c.1:   bridge window [io  0x3000-0x3fff]
pci 0000:00:1c.1:   bridge window [mem 0xf0500000-0xf05fffff]
pci 0000:00:1c.1:   bridge window [mem 0x7c000000-0x7c1fffff 64bit pref]
pci 0000:00:1e.0: PCI bridge to [bus 0f-0f]
pci 0000:00:1e.0:   bridge window [io  disabled]
pci 0000:00:1e.0:   bridge window [mem disabled]
pci 0000:00:1e.0:   bridge window [mem pref disabled]
pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.1: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:00: resource 7 [mem 0x000d4000-0x000d7fff]
pci_bus 0000:00: resource 8 [mem 0x000d8000-0x000dbfff]
pci_bus 0000:00: resource 9 [mem 0x000e0000-0x000e3fff]
pci_bus 0000:00: resource 10 [mem 0x7c000000-0xfeafffff]
pci_bus 0000:03: resource 0 [io  0x2000-0x2fff]
pci_bus 0000:03: resource 1 [mem 0xf0400000-0xf04fffff]
pci_bus 0000:03: resource 2 [mem 0x7c200000-0x7c3fffff 64bit pref]
pci_bus 0000:04: resource 0 [io  0x3000-0x3fff]
pci_bus 0000:04: resource 1 [mem 0xf0500000-0xf05fffff]
pci_bus 0000:04: resource 2 [mem 0x7c000000-0x7c1fffff 64bit pref]
pci_bus 0000:0f: resource 4 [io  0x0000-0x0cf7]
pci_bus 0000:0f: resource 5 [io  0x0d00-0xffff]
pci_bus 0000:0f: resource 6 [mem 0x000a0000-0x000bffff]
pci_bus 0000:0f: resource 7 [mem 0x000d4000-0x000d7fff]
pci_bus 0000:0f: resource 8 [mem 0x000d8000-0x000dbfff]
pci_bus 0000:0f: resource 9 [mem 0x000e0000-0x000e3fff]
pci_bus 0000:0f: resource 10 [mem 0x7c000000-0xfeafffff]
NET: Registered protocol family 2
IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
UDP hash table entries: 1024 (order: 3, 32768 bytes)
UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
NET: Registered protocol family 1
pci 0000:00:02.0: Boot video device
PCI: CLS 64 bytes, default 64
Simple Boot Flag at 0x36 set to 0x1
Intel AES-NI instructions are not detected.
Intel PCLMULQDQ-NI instructions are not detected.
audit: initializing netlink socket (disabled)
type=2000 audit(1308245865.512:1): initialized
HugeTLB registered 2 MB page size, pre-allocated 0 pages
msgmni has been set to 3614
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
intel_idle: MWAIT substates: 0x1120
intel_idle: v0.4 model 0x25
intel_idle: lapic_timer_reliable_states 0xffffffff
ACPI: Deprecated procfs I/F for AC is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
ACPI: AC Adapter [ADP1] (on-line)
input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
ACPI: Lid Switch [LID0]
input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1
ACPI: Sleep Button [SLPB]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
ACPI: Power Button [PWRF]
ACPI: acpi_idle yielding to intel_idle
thermal LNXTHERM:00: registered as thermal_zone0
ACPI: Thermal Zone [TZS0] (54 C)
thermal LNXTHERM:01: registered as thermal_zone1
ACPI: Thermal Zone [TZS1] (46 C)
Real Time Clock Driver v1.12b
Non-volatile memory driver v1.3
Linux agpgart interface v0.103
agpgart-intel 0000:00:00.0: Intel HD Graphics Chipset
agpgart-intel 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
agpgart-intel 0000:00:00.0: detected 65536K stolen memory
agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[drm] Initialized drm 1.1.0 20060810
ACPI: Deprecated procfs I/F for battery is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
ACPI: Battery Slot [BAT0] (battery present)
Refined TSC clocksource calibration: 1063.992 MHz.
Switching to clocksource tsc
floppy0: no floppy controllers found
brd: module loaded
loop: module loaded
ahci 0000:00:1f.2: version 3.0
ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ahci 0000:00:1f.2: irq 40 for MSI/MSI-X
ahci: SSS flag set, parallel bus scan disabled
ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 4 ports 3 Gbps 0x21 impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq sntf ilck stag pm led clo pio slum part ems apst 
ahci 0000:00:1f.2: setting latency timer to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
scsi4 : ahci
scsi5 : ahci
ata1: SATA max UDMA/133 abar m2048@0xf0808000 port 0xf0808100 irq 40
ata2: DUMMY
ata3: DUMMY
ata4: DUMMY
ata5: DUMMY
ata6: SATA max UDMA/133 abar m2048@0xf0808000 port 0xf0808380 irq 40
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
ehci_hcd 0000:00:1a.0: setting latency timer to 64
ehci_hcd 0000:00:1a.0: EHCI Host Controller
ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1a.0: debug port 2
ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
ehci_hcd 0000:00:1a.0: irq 16, io mem 0xf0806000
ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 3 ports detected
ehci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1d.0: setting latency timer to 64
ehci_hcd 0000:00:1d.0: EHCI Host Controller
ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1d.0: debug port 2
ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
ehci_hcd 0000:00:1d.0: irq 23, io mem 0xf0807000
ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 3 ports detected
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
uhci_hcd: USB Universal Host Controller Interface driver
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
i8042: PNP: PS/2 Controller [PNP0303:KBD0,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mousedev: PS/2 mouse device common for all mice
i2c /dev entries driver
lirc_dev: IR Remote Control driver registered, major 252 
IR NEC protocol handler initialized
IR RC5(x) protocol handler initialized
IR RC6 protocol handler initialized
IR JVC protocol handler initialized
IR Sony protocol handler initialized
IR RC5 (streamzap) protocol handler initialized
IR LIRC bridge handler initialized
device-mapper: ioctl: 4.20.0-ioctl (2011-02-02) initialised: dm-devel@redhat.com
cpuidle: using governor ladder
cpuidle: using governor menu
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
oprofile: using NMI interrupt.
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
ip_tables: (C) 2000-2006 Netfilter Core Team
TCP cubic registered
NET: Registered protocol family 10
IPv6 over IPv4 tunneling driver
NET: Registered protocol family 17
Bridge firewalling registered
802.1Q VLAN Support v1.8
lib80211: common routines for IEEE802.11 drivers
lib80211_crypt: registered algorithm 'NULL'
lib80211_crypt: registered algorithm 'WEP'
lib80211_crypt: registered algorithm 'CCMP'
lib80211_crypt: registered algorithm 'TKIP'
Registering the dns_resolver key type
Kernel not built with RTC support, ALARM timers will not wake from suspend
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: ATA-8: WDC WD3200BEVT-24A23T0, 01.01A02, max UDMA/133
ata1.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
ata1.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      WDC WD3200BEVT-2 01.0 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 625142448 512-byte logical blocks: (320 GB/298 GiB)
sd 0:0:0:0: Attached scsi generic sg0 type 0
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
usb 1-1: new high speed USB device number 2 using ehci_hcd
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
sd 0:0:0:0: [sda] Attached SCSI disk
hub 1-1:1.0: USB hub found
hub 1-1:1.0: 6 ports detected
usb 2-1: new high speed USB device number 2 using ehci_hcd
ata6: SATA link down (SStatus 0 SControl 300)
hub 2-1:1.0: USB hub found
hub 2-1:1.0: 8 ports detected
usb 1-1.2: new full speed USB device number 3 using ehci_hcd
usb 1-1.6: new high speed USB device number 4 using ehci_hcd
Synaptics Touchpad, model: 1, fw: 7.2, id: 0x1c0b1, caps: 0xd04733/0xa44000/0xa0000
usb 2-1.5: new high speed USB device number 3 using ehci_hcd
input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio1/input/input4
EXT3-fs: barriers not enabled
kjournald starting.  Commit interval 5 seconds
EXT3-fs (sda2): mounted filesystem with writeback data mode
VFS: Mounted root (ext3 filesystem) readonly on device 8:2.
Freeing unused kernel memory: 596k freed
scsi6 : usb-storage 2-1.5:1.0
scsi 6:0:0:0: Direct-Access     Generic- Multi-Card       1.00 PQ: 0 ANSI: 0 CCS
sd 6:0:0:0: Attached scsi generic sg1 type 0
sd 6:0:0:0: [sdb] Attached SCSI removable disk
udevd[1501]: starting version 168
Bluetooth: Generic Bluetooth USB driver ver 0.6
usbcore: registered new interface driver btusb
atl1c 0000:03:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
atl1c 0000:03:00.0: setting latency timer to 64
i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
atl1c 0000:03:00.0: version 1.0.1.0-NAPI
i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
i915 0000:00:02.0: setting latency timer to 64
i915 0000:00:02.0: irq 41 for MSI/MSI-X
[drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[drm] Driver supports precise vblank timestamp query.
vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
udevd[1509]: renamed network interface eth0 to eth1
fbcon: inteldrmfb (fb0) is primary device
fixme: max PWM is zero.
Console: switching to colour frame buffer device 170x48
fb0: inteldrmfb frame buffer device
drm: registered panic notifier
acpi device:07: registered as cooling_device2
input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:01/input/input5
ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
HDA Intel 0000:00:1b.0: irq 42 for MSI/MSI-X
HDA Intel 0000:00:1b.0: setting latency timer to 64
hda_codec: ALC269VB: BIOS auto-probing.
HDMI status: Pin=4 Presence_Detect=0 ELD_Valid=0
EXT3-fs (sda2): using internal journal
EXT3-fs: barriers not enabled
kjournald starting.  Commit interval 5 seconds
EXT3-fs (dm-0): warning: maximal mount count reached, running e2fsck is recommended
EXT3-fs (dm-0): using internal journal
EXT3-fs (dm-0): mounted filesystem with writeback data mode
atl1c 0000:03:00.0: irq 43 for MSI/MSI-X
atl1c 0000:03:00.0: atl1c: eth1 NIC Link is Up<100 Mbps Full Duplex>
Adding 2097148k swap on /dev/sda5.  Priority:-1 extents:1 across:2097148k 

--=-=-=--
