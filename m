Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298Ab2JNS5a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 14:57:30 -0400
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:10284 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749Ab2JNS53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 14:57:29 -0400
X-Authority-Analysis: v=2.0 cv=OOOlLFmB c=1 sm=0 a=YPDeGStqRoQnMAluW+pq4Q==:17 a=65KWcu232dMA:10 a=h9GbcFHyNoYA:10 a=DpEkYpXRGzUA:10 a=05ChyHeVI94A:10 a=ayC55rCoAAAA:8 a=nULq49Tkjo8A:10 a=gE5uZxI302zkM3Luqs8A:9 a=wPNLvfGTeEIA:10 a=pSDxxfrZAAAA:8 a=deLQG1uruYZzIbg-0iQA:9 a=QEXdDO2ut3YA:10 a=Sf_gFPzhefAA:10 a=-0qkl0XTG-IA:10 a=wQfR8xxmDhxcNYwu:21 a=y7clYHu3IpcesejW:21 a=S4Yire2jXoupEBX7:21 a=YPDeGStqRoQnMAluW+pq4Q==:117
X-Cloudmark-Score: 0
X-Originating-IP: 50.89.247.146
Message-ID: <507B0B16.4010900@cfl.rr.com>
Date: Sun, 14 Oct 2012 14:57:26 -0400
From: Mark Hounschell <dmarkh@cfl.rr.com>
Reply-To: dmarkh@cfl.rr.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
CC: markh@compro.net, linux-kernel@vger.kernel.org,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>
Subject: Re: Intel graphics drm issue?
References: <507812E8.3060607@compro.net> <20121012231459.166e29fd@neptune.home> <5079B97C.7020401@cfl.rr.com> <5079BE5C.8020401@cfl.rr.com> <20121014104138.7e8a9c59@neptune.home> <507A997D.7070508@cfl.rr.com> <20121014130323.06f0225d@neptune.home> <507AEE4A.1000907@cfl.rr.com> <20121014192253.5a7517ef@neptune.home> <507AFE69.70405@cfl.rr.com> <20121014201941.22284249@neptune.home>
In-Reply-To: <20121014201941.22284249@neptune.home>
Content-Type: multipart/mixed;
 boundary="------------030508060007060309000900"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030508060007060309000900
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

On 10/14/2012 02:19 PM, Bruno Pr=E9mont wrote:
> On Sun, 14 October 2012 Mark Hounschell <dmarkh@cfl.rr.com> wrote:
>>>> And could I ask if this simple pgm might work to build the file I ne=
ed?
>>>
>>> It looks fine. You can also check the output with hexdump just to
>>> make sure it looks sane.
>>
>> Did that and the data looks swapped compared to the array written, but=
 I
>> guess that's normal?
>
> That might very well be presentation issue, how did you call hexdump?
> When called with no arguments but filename it groups bytes as words and=

> those look swapped (on little-endian), but `hexdump -C $file` is fine,
> dumping each byte individually.
>

Yep, its right with -C

>>> If it's broken kernel will tell you that checksum does not match.
>>>
>>
>> So the  check sum is actually already in the data provided by the serv=
ice
>> manual then.
>
> Yes, checksum byte is part of the EDID blob.
>
> Bruno
>
>>> In any case the (successful) loading of edid should be visible in ker=
nel
>>> log.
>>>
>>
>> I'll be trying this a little later in the day.

I gave it a try. I don't think it liked my kernel cmdline. dmesg attached=
=2E=20
There is a lot more in there now that nomodeset is gone and the debug is =

turned on.

# ls -al /lib/firmware/edid/lg42lb9df.edid
-rw-r--r-- 1 root root 1024 Oct 14  2012 /lib/firmware/edid/lg42lb9df.edi=
d

## cat /proc/cmdline
root=3D/dev/disk/by-id/ata-INTEL_SSDSC2CW060A3_CVCV205106EB060AGN-part4=20
noresume splash=3Dsilent quiet apm=3Doff vga=3Dnormal drm.debug=3D0xe irq=
poll=20
drm_kms_helper.edid_firmware=3Dedid/lg42lb9df.edid


from attached dmesg:
1.833032] drm_kms_helper: Unknown parameter `edid'

Mark


--------------030508060007060309000900
Content-Type: text/plain; charset=UTF-8;
 name="dmesg-hdmi_only-3.6.2-3"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg-hdmi_only-3.6.2-3"

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.6.2 (root@geexbox) (gcc version 4.7.1 20120723 [gcc-4_7-branch revision 189773] (SUSE Linux) ) #2 SMP PREEMPT Sun Oct 14 08:55:34 EDT 2012
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   Centaur CentaurHauls
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
[    0.000000]   UMC UMC UMC UMC
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009d7ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009d800-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000020000000-0x00000000201fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000020200000-0x0000000040003fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000040004000-0x0000000040004fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000040005000-0x00000000d9e5efff] usable
[    0.000000] BIOS-e820: [mem 0x00000000d9e5f000-0x00000000da25afff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000da25b000-0x00000000da266fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000da267000-0x00000000da2f2fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000da2f3000-0x00000000da2f8fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000da2f9000-0x00000000da37afff] usable
[    0.000000] BIOS-e820: [mem 0x00000000da37b000-0x00000000da40cfff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000da40d000-0x00000000da6a2fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000da6a3000-0x00000000da6a3fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000da6a4000-0x00000000da6e6fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000da6e7000-0x00000000daffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000db800000-0x00000000df9fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed03fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000021f5fffff] usable
[    0.000000] Notice: NX (Execute Disable) protection missing in CPU!
[    0.000000] DMI 2.7 present.
[    0.000000] DMI:                  /DH77DF, BIOS KCH7710H.86A.0095.2012.0608.1754 06/08/2012
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0xdb000 max_arch_pfn = 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-E7FFF uncachable
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask E00000000 write-back
[    0.000000]   1 base 200000000 mask FE0000000 write-back
[    0.000000]   2 base 0E0000000 mask FE0000000 uncachable
[    0.000000]   3 base 0DC000000 mask FFC000000 uncachable
[    0.000000]   4 base 0DB800000 mask FFF800000 uncachable
[    0.000000]   5 base 21F800000 mask FFF800000 uncachable
[    0.000000]   6 base 21F600000 mask FFFE00000 uncachable
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: update [mem 0xdb800000-0xffffffff] usable ==> reserved
[    0.000000] found SMP MP-table at [mem 0x000fd770-0x000fd77f] mapped at [c00fd770]
[    0.000000] initial memory mapped: [mem 0x00000000-0x00bfffff]
[    0.000000] Base memory trampoline at [c0099000] 99000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x377fdfff]
[    0.000000]  [mem 0x00000000-0x003fffff] page 4k
[    0.000000]  [mem 0x00400000-0x373fffff] page 2M
[    0.000000]  [mem 0x37400000-0x377fdfff] page 4k
[    0.000000] kernel direct mapping tables up to 0x377fdfff @ [mem 0x00bfa000-0x00bfffff]
[    0.000000] RAMDISK: [mem 0x1e6ac000-0x1ffeffff]
[    0.000000] ACPI: RSDP 000f0490 00024 (v02  INTEL)
[    0.000000] ACPI: XSDT da25b070 00064 (v01 INTEL  DH77DF   0000005F AMI  00010013)
[    0.000000] ACPI: FACP da264db8 000F4 (v04 INTEL  DH77DF   0000005F AMI  00010013)
[    0.000000] ACPI: DSDT da25b168 09C49 (v02 INTEL  DH77DF   0000005F INTL 20051117)
[    0.000000] ACPI: FACS da40bf80 00040
[    0.000000] ACPI: APIC da264eb0 00072 (v03 INTEL  DH77DF   0000005F AMI  00010013)
[    0.000000] ACPI: FPDT da264f28 00044 (v01 INTEL  DH77DF   0000005F AMI  00010013)
[    0.000000] ACPI: MCFG da264f70 0003C (v01 INTEL  DH77DF   0000005F MSFT 00000097)
[    0.000000] ACPI: HPET da264fb0 00038 (v01 INTEL  DH77DF   0000005F AMI. 00000005)
[    0.000000] ACPI: SSDT da264fe8 0036D (v01 INTEL  DH77DF   0000005F INTL 20091112)
[    0.000000] ACPI: SSDT da265358 009AA (v01 INTEL  DH77DF   0000005F INTL 20051117)
[    0.000000] ACPI: SSDT da265d08 00A92 (v01 INTEL  DH77DF   0000005F INTL 20051117)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 2616MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 0 - 377fe000
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00010000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x377fdfff]
[    0.000000]   HighMem  [mem 0x377fe000-0xdaffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0009cfff]
[    0.000000]   node   0: [mem 0x00100000-0x1fffffff]
[    0.000000]   node   0: [mem 0x20200000-0x40003fff]
[    0.000000]   node   0: [mem 0x40005000-0xd9e5efff]
[    0.000000]   node   0: [mem 0xda2f9000-0xda37afff]
[    0.000000]   node   0: [mem 0xda6a3000-0xda6a3fff]
[    0.000000]   node   0: [mem 0xda6e7000-0xdaffffff]
[    0.000000] On node 0 totalpages: 894343
[    0.000000] free_area_init_node: node 0, pgdat c0894340, node_mem_map f5c9d200
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3949 pages, LIFO batch:0
[    0.000000]   Normal zone: 1744 pages used for memmap
[    0.000000]   Normal zone: 220974 pages, LIFO batch:31
[    0.000000]   HighMem zone: 5233 pages used for memmap
[    0.000000]   HighMem zone: 662411 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 000000000009e000
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 0000000020000000 - 0000000020200000
[    0.000000] e820: [mem 0xdfa00000-0xf7ffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 12 pages/cpu @f5c5b000 s26944 r0 d22208 u49152
[    0.000000] pcpu-alloc: s26944 r0 d22208 u49152 alloc=12*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 887334
[    0.000000] Kernel command line: root=/dev/disk/by-id/ata-INTEL_SSDSC2CW060A3_CVCV205106EB060AGN-part4 noresume splash=silent quiet apm=off vga=normal drm.debug=0xe irqpoll drm_kms_helper.edid_firmware=edid/lg42lb9df.edid
[    0.000000] Misrouted IRQ fixup and polling support enabled
[    0.000000] This may significantly impact system performance
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Initializing CPU#0
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Initializing HighMem for node 0 (000377fe:000db000)
[    0.000000] Memory: 3514572k/3588096k available (4577k kernel code, 62800k reserved, 2220k data, 452k init, 2670576k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff16000 - 0xfffff000   ( 932 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.000000]       .init : 0xc08a4000 - 0xc0915000   ( 452 kB)
[    0.000000]       .data : 0xc0678452 - 0xc08a3800   (2220 kB)
[    0.000000]       .text : 0xc0200000 - 0xc0678452   (4577 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	Dump stacks of tasks blocking RCU-preempt GP.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=8 to nr_cpu_ids=4.
[    0.000000] NR_IRQS:2304 nr_irqs:712 16
[    0.000000] CPU 0 irqstacks, hard=f5408000 soft=f540a000
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.003333] tsc: Detected 3392.460 MHz processor
[    0.000000] Calibrating delay loop (skipped), value calculated using timer frequency.. 6787.62 BogoMIPS (lpj=11308200)
[    0.000002] pid_max: default: 32768 minimum: 301
[    0.000014] Security Framework initialized
[    0.000023] AppArmor: AppArmor initialized
[    0.000028] Mount-cache hash table entries: 512
[    0.000134] Initializing cgroup subsys net_cls
[    0.000135] Initializing cgroup subsys blkio
[    0.000152] CPU: Physical Processor ID: 0
[    0.000152] CPU: Processor Core ID: 0
[    0.000155] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.000155] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.000693] mce: CPU supports 9 MCE banks
[    0.000703] CPU0: Thermal monitoring enabled (TM1)
[    0.000707] process: using mwait in idle threads
[    0.000712] Last level iTLB entries: 4KB 512, 2MB 0, 4MB 0
[    0.000712] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
[    0.000712] tlb_flushall_shift is 0x1
[    0.001276] ACPI: Core revision 20120711
[    0.007331] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.007753] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.040663] smpboot: CPU0: Intel(R) Core(TM) i5-3570K CPU @ 3.40GHz stepping 09
[    0.146597] Performance Events: PEBS fmt1+, 16-deep LBR, IvyBridge events, Intel PMU driver.
[    0.146601] ... version:                3
[    0.146602] ... bit width:              48
[    0.146602] ... generic registers:      8
[    0.146603] ... value mask:             0000ffffffffffff
[    0.146604] ... max period:             000000007fffffff
[    0.146604] ... fixed-purpose events:   3
[    0.146605] ... event mask:             00000007000000ff
[    0.193135] CPU 1 irqstacks, hard=f54b0000 soft=f54b2000
[    0.203369] Initializing CPU#1
[    0.193138] smpboot: Booting Node   0, Processors  #1
[    0.219725] CPU 2 irqstacks, hard=f54c6000 soft=f54c8000
[    0.229995] Initializing CPU#2
[    0.219728]  #2
[    0.246315] CPU 3 irqstacks, hard=f54e0000 soft=f54e2000
[    0.246318]  #3 OK
[    0.256585] Initializing CPU#3
[    0.260020] Brought up 4 CPUs
[    0.260022] smpboot: Total of 4 processors activated (27150.50 BogoMIPS)
[    0.262488] devtmpfs: initialized
[    0.262654] PM: Registering ACPI NVS region [mem 0xda37b000-0xda40cfff] (598016 bytes)
[    0.262659] PM: Registering ACPI NVS region [mem 0xda6a4000-0xda6e6fff] (274432 bytes)
[    0.262712] dummy: 
[    0.262741] RTC time: 14:36:59, date: 10/14/12
[    0.262764] NET: Registered protocol family 16
[    0.302930] ACPI: bus type pci registered
[    0.302975] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.302977] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.302977] PCI: Using MMCONFIG for extended config space
[    0.302978] PCI: Using configuration type 1 for base access
[    0.303432] bio: create slab <bio-0> at 0
[    0.303468] ACPI: Added _OSI(Module Device)
[    0.303469] ACPI: Added _OSI(Processor Device)
[    0.303470] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.303471] ACPI: Added _OSI(Processor Aggregator Device)
[    0.304800] ACPI: EC: Look up EC in DSDT
[    0.306319] ACPI: Executed 1 blocks of module-level executable AML code
[    0.316838] ACPI: SSDT da293018 0083B (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
[    0.317174] ACPI: Dynamic OEM Table Load:
[    0.317176] ACPI: SSDT   (null) 0083B (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
[    0.326299] ACPI: SSDT da294a98 00303 (v01  PmRef    ApIst 00003000 INTL 20051117)
[    0.326666] ACPI: Dynamic OEM Table Load:
[    0.326667] ACPI: SSDT   (null) 00303 (v01  PmRef    ApIst 00003000 INTL 20051117)
[    0.336460] ACPI: SSDT da299c18 00119 (v01  PmRef    ApCst 00003000 INTL 20051117)
[    0.336798] ACPI: Dynamic OEM Table Load:
[    0.336799] ACPI: SSDT   (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20051117)
[    0.350280] ACPI: Interpreter enabled
[    0.350285] ACPI: (supports S0 S3 S4 S5)
[    0.350297] ACPI: Using IOAPIC for interrupt routing
[    0.354268] ACPI: Power Resource [FN00] (off)
[    0.354318] ACPI: Power Resource [FN01] (off)
[    0.354365] ACPI: Power Resource [FN02] (off)
[    0.354413] ACPI: Power Resource [FN03] (off)
[    0.354460] ACPI: Power Resource [FN04] (off)
[    0.354817] ACPI: No dock devices found.
[    0.354821] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.355053] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    0.355383] PCI host bridge to bus 0000:00
[    0.355385] pci_bus 0000:00: busn_res: [bus 00-3e] is inserted under domain [bus 00-ff]
[    0.355386] pci_bus 0000:00: root bus resource [bus 00-3e]
[    0.355388] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.355389] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.355390] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.355391] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff]
[    0.355392] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
[    0.355393] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
[    0.355395] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff]
[    0.355396] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3fff]
[    0.355397] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7fff]
[    0.355398] pci_bus 0000:00: root bus resource [mem 0xdfa00000-0xfeafffff]
[    0.355404] pci 0000:00:00.0: [8086:0150] type 00 class 0x060000
[    0.355433] pci 0000:00:01.0: [8086:0151] type 01 class 0x060400
[    0.355455] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.355474] pci 0000:00:02.0: [8086:0162] type 00 class 0x030000
[    0.355481] pci 0000:00:02.0: reg 10: [mem 0xf7800000-0xf7bfffff 64bit]
[    0.355485] pci 0000:00:02.0: reg 18: [mem 0xe0000000-0xefffffff 64bit pref]
[    0.355488] pci 0000:00:02.0: reg 20: [io  0xf000-0xf03f]
[    0.355532] pci 0000:00:14.0: [8086:1e31] type 00 class 0x0c0330
[    0.355552] pci 0000:00:14.0: reg 10: [mem 0xf7d20000-0xf7d2ffff 64bit]
[    0.355617] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    0.355638] pci 0000:00:16.0: [8086:1e3a] type 00 class 0x078000
[    0.355659] pci 0000:00:16.0: reg 10: [mem 0xf7d37000-0xf7d3700f 64bit]
[    0.355730] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.355757] pci 0000:00:19.0: [8086:1503] type 00 class 0x020000
[    0.355773] pci 0000:00:19.0: reg 10: [mem 0xf7d00000-0xf7d1ffff]
[    0.355780] pci 0000:00:19.0: reg 14: [mem 0xf7d35000-0xf7d35fff]
[    0.355788] pci 0000:00:19.0: reg 18: [io  0xf080-0xf09f]
[    0.355845] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.355868] pci 0000:00:1a.0: [8086:1e2d] type 00 class 0x0c0320
[    0.355887] pci 0000:00:1a.0: reg 10: [mem 0xf7d34000-0xf7d343ff]
[    0.355970] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.355997] pci 0000:00:1c.0: [8086:1e10] type 01 class 0x060400
[    0.356125] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.356162] pci 0000:00:1c.7: [8086:1e1e] type 01 class 0x060400
[    0.356233] pci 0000:00:1c.7: PME# supported from D0 D3hot D3cold
[    0.356259] pci 0000:00:1d.0: [8086:1e26] type 00 class 0x0c0320
[    0.356278] pci 0000:00:1d.0: reg 10: [mem 0xf7d33000-0xf7d333ff]
[    0.356361] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.356383] pci 0000:00:1f.0: [8086:1e4a] type 00 class 0x060100
[    0.356500] pci 0000:00:1f.2: [8086:1e02] type 00 class 0x010601
[    0.356516] pci 0000:00:1f.2: reg 10: [io  0xf0d0-0xf0d7]
[    0.356523] pci 0000:00:1f.2: reg 14: [io  0xf0c0-0xf0c3]
[    0.356530] pci 0000:00:1f.2: reg 18: [io  0xf0b0-0xf0b7]
[    0.356537] pci 0000:00:1f.2: reg 1c: [io  0xf0a0-0xf0a3]
[    0.356544] pci 0000:00:1f.2: reg 20: [io  0xf060-0xf07f]
[    0.356551] pci 0000:00:1f.2: reg 24: [mem 0xf7d32000-0xf7d327ff]
[    0.356590] pci 0000:00:1f.2: PME# supported from D3hot
[    0.356606] pci 0000:00:1f.3: [8086:1e22] type 00 class 0x0c0500
[    0.356618] pci 0000:00:1f.3: reg 10: [mem 0xf7d31000-0xf7d310ff 64bit]
[    0.356638] pci 0000:00:1f.3: reg 20: [io  0xf040-0xf05f]
[    0.356675] pci_bus 0000:01: busn_res: [bus 01-02] is inserted under [bus 00-3e]
[    0.356692] pci 0000:01:00.0: [10b5:8112] type 01 class 0x060400
[    0.356797] pci 0000:01:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.356805] pci 0000:00:01.0: PCI bridge to [bus 01-02]
[    0.356807] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    0.356853] pci_bus 0000:02: busn_res: [bus 02] is inserted under [bus 01-02]
[    0.356873] pci 0000:02:04.0: [13f6:8788] type 00 class 0x040100
[    0.356896] pci 0000:02:04.0: reg 10: [io  0xe000-0xe0ff]
[    0.357006] pci 0000:02:04.0: supports D1 D2
[    0.357058] pci 0000:01:00.0: PCI bridge to [bus 02]
[    0.357062] pci 0000:01:00.0:   bridge window [io  0xe000-0xefff]
[    0.357146] pci_bus 0000:03: busn_res: [bus 03] is inserted under [bus 00-3e]
[    0.357149] pci 0000:00:1c.0: PCI bridge to [bus 03]
[    0.357201] pci_bus 0000:04: busn_res: [bus 04] is inserted under [bus 00-3e]
[    0.357204] pci 0000:00:1c.7: PCI bridge to [bus 04]
[    0.357207] pci 0000:00:1c.7:   bridge window [io  0xd000-0xdfff]
[    0.357211] pci 0000:00:1c.7:   bridge window [mem 0xf7c00000-0xf7cfffff]
[    0.357230] pci_bus 0000:00: on NUMA node 0
[    0.357231] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.357319] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.357346] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP08._PRT]
[    0.357369] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG0._PRT]
[    0.357460]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.357598]  pci0000:00: ACPI _OSC control (0x18) granted
[    0.360453] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.360492] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.360529] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 *4 5 6 10 11 12 14 15)
[    0.360565] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 *10 11 12 14 15)
[    0.360602] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 10 11 12 14 15)
[    0.360640] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.360673] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.360711] ACPI: PCI Interrupt Link [LNKH] (IRQs *3 4 5 6 10 11 12 14 15)
[    0.360754] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.360757] vgaarb: loaded
[    0.360757] vgaarb: bridge control possible 0000:00:02.0
[    0.360815] SCSI subsystem initialized
[    0.360817] ACPI: bus type scsi registered
[    0.360834] libata version 3.00 loaded.
[    0.360843] ACPI: bus type usb registered
[    0.360852] usbcore: registered new interface driver usbfs
[    0.360857] usbcore: registered new interface driver hub
[    0.360868] usbcore: registered new device driver usb
[    0.360894] PCI: Using ACPI for IRQ routing
[    0.362262] PCI: pci_cache_line_size set to 64 bytes
[    0.362309] e820: reserve RAM buffer [mem 0x0009d800-0x0009ffff]
[    0.362310] e820: reserve RAM buffer [mem 0x40004000-0x43ffffff]
[    0.362311] e820: reserve RAM buffer [mem 0xd9e5f000-0xdbffffff]
[    0.362313] e820: reserve RAM buffer [mem 0xda37b000-0xdbffffff]
[    0.362315] e820: reserve RAM buffer [mem 0xda6a4000-0xdbffffff]
[    0.362316] e820: reserve RAM buffer [mem 0xdb000000-0xdbffffff]
[    0.362366] NetLabel: Initializing
[    0.362367] NetLabel:  domain hash size = 128
[    0.362367] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.362373] NetLabel:  unlabeled traffic allowed by default
[    0.362425] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.362428] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.364434] Switching to clocksource hpet
[    0.364474] AppArmor: AppArmor Filesystem Enabled
[    0.364482] pnp: PnP ACPI init
[    0.364487] ACPI: bus type pnp registered
[    0.364669] pnp 00:00: [bus 00-3e]
[    0.364671] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.364672] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.364673] pnp 00:00: [io  0x0d00-0xffff window]
[    0.364674] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.364675] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
[    0.364676] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
[    0.364677] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
[    0.364678] pnp 00:00: [mem 0x000cc000-0x000cffff window]
[    0.364679] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
[    0.364681] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
[    0.364682] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
[    0.364683] pnp 00:00: [mem 0x000dc000-0x000dffff window]
[    0.364684] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
[    0.364685] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
[    0.364686] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
[    0.364687] pnp 00:00: [mem 0x000ec000-0x000effff window]
[    0.364689] pnp 00:00: [mem 0x000f0000-0x000fffff window]
[    0.364690] pnp 00:00: [mem 0xdfa00000-0xfeafffff window]
[    0.364691] pnp 00:00: [mem 0x00010000-0x0001ffff window]
[    0.364721] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    0.364737] pnp 00:01: [mem 0xfed40000-0xfed44fff]
[    0.364754] system 00:01: [mem 0xfed40000-0xfed44fff] has been reserved
[    0.364756] system 00:01: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.364763] pnp 00:02: [io  0x0000-0x001f]
[    0.364764] pnp 00:02: [io  0x0081-0x0091]
[    0.364765] pnp 00:02: [io  0x0093-0x009f]
[    0.364766] pnp 00:02: [io  0x00c0-0x00df]
[    0.364768] pnp 00:02: [dma 4]
[    0.364779] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.364784] pnp 00:03: [mem 0xff000000-0xffffffff]
[    0.364794] pnp 00:03: Plug and Play ACPI device, IDs INT0800 (active)
[    0.364849] pnp 00:04: [mem 0xfed00000-0xfed003ff]
[    0.364861] pnp 00:04: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.364868] pnp 00:05: [io  0x002e-0x002f]
[    0.364869] pnp 00:05: [io  0x004e-0x004f]
[    0.364870] pnp 00:05: [io  0x0061]
[    0.364871] pnp 00:05: [io  0x0063]
[    0.364872] pnp 00:05: [io  0x0065]
[    0.364873] pnp 00:05: [io  0x0067]
[    0.364874] pnp 00:05: [io  0x0070]
[    0.364875] pnp 00:05: [io  0x0080]
[    0.364876] pnp 00:05: [io  0x0092]
[    0.364877] pnp 00:05: [io  0x00b2-0x00b3]
[    0.364878] pnp 00:05: [io  0x0680-0x069f]
[    0.364879] pnp 00:05: [io  0x1000-0x100f]
[    0.364880] pnp 00:05: [io  0xffff]
[    0.364881] pnp 00:05: [io  0xffff]
[    0.364882] pnp 00:05: [io  0x0400-0x0453]
[    0.364883] pnp 00:05: [io  0x0458-0x047f]
[    0.364884] pnp 00:05: [io  0x0500-0x057f]
[    0.364885] pnp 00:05: [io  0x164e-0x164f]
[    0.364905] system 00:05: [io  0x0680-0x069f] has been reserved
[    0.364906] system 00:05: [io  0x1000-0x100f] has been reserved
[    0.364908] system 00:05: [io  0xffff] has been reserved
[    0.364909] system 00:05: [io  0xffff] has been reserved
[    0.364910] system 00:05: [io  0x0400-0x0453] has been reserved
[    0.364911] system 00:05: [io  0x0458-0x047f] has been reserved
[    0.364912] system 00:05: [io  0x0500-0x057f] has been reserved
[    0.364914] system 00:05: [io  0x164e-0x164f] has been reserved
[    0.364915] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.364920] pnp 00:06: [io  0x0070-0x0077]
[    0.364928] pnp 00:06: [irq 8]
[    0.364939] pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.364955] pnp 00:07: [io  0x0454-0x0457]
[    0.364973] system 00:07: [io  0x0454-0x0457] has been reserved
[    0.364975] system 00:07: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
[    0.365029] pnp 00:08: [io  0x0000-0xffffffff disabled]
[    0.365031] pnp 00:08: [io  0x0a30-0x0a3f]
[    0.365032] pnp 00:08: [io  0x0000-0xffffffff disabled]
[    0.365033] pnp 00:08: [io  0x0250-0x025f]
[    0.365050] system 00:08: [io  0x0a30-0x0a3f] has been reserved
[    0.365051] system 00:08: [io  0x0250-0x025f] has been reserved
[    0.365053] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.365089] pnp 00:09: [io  0x0010-0x001f]
[    0.365090] pnp 00:09: [io  0x0022-0x003f]
[    0.365091] pnp 00:09: [io  0x0044-0x005f]
[    0.365092] pnp 00:09: [io  0x0062-0x0063]
[    0.365093] pnp 00:09: [io  0x0065-0x006f]
[    0.365094] pnp 00:09: [io  0x0072-0x007f]
[    0.365095] pnp 00:09: [io  0x0080]
[    0.365096] pnp 00:09: [io  0x0084-0x0086]
[    0.365097] pnp 00:09: [io  0x0088]
[    0.365098] pnp 00:09: [io  0x008c-0x008e]
[    0.365099] pnp 00:09: [io  0x0090-0x009f]
[    0.365100] pnp 00:09: [io  0x00a2-0x00bf]
[    0.365101] pnp 00:09: [io  0x00e0-0x00ef]
[    0.365102] pnp 00:09: [io  0x04d0-0x04d1]
[    0.365122] system 00:09: [io  0x04d0-0x04d1] has been reserved
[    0.365123] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.365129] pnp 00:0a: [io  0x00f0-0x00ff]
[    0.365136] pnp 00:0a: [irq 13]
[    0.365148] pnp 00:0a: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.365324] pnp 00:0b: [mem 0xfed1c000-0xfed1ffff]
[    0.365325] pnp 00:0b: [mem 0xfed10000-0xfed17fff]
[    0.365326] pnp 00:0b: [mem 0xfed18000-0xfed18fff]
[    0.365327] pnp 00:0b: [mem 0xfed19000-0xfed19fff]
[    0.365328] pnp 00:0b: [mem 0xf8000000-0xfbffffff]
[    0.365329] pnp 00:0b: [mem 0xfed20000-0xfed3ffff]
[    0.365330] pnp 00:0b: [mem 0xfed90000-0xfed93fff]
[    0.365331] pnp 00:0b: [mem 0xfed45000-0xfed8ffff]
[    0.365332] pnp 00:0b: [mem 0xff000000-0xffffffff]
[    0.365333] pnp 00:0b: [mem 0xfee00000-0xfeefffff]
[    0.365334] pnp 00:0b: [mem 0xdfa00000-0xdfa00fff]
[    0.365366] system 00:0b: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.365367] system 00:0b: [mem 0xfed10000-0xfed17fff] has been reserved
[    0.365368] system 00:0b: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.365370] system 00:0b: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.365371] system 00:0b: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.365372] system 00:0b: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.365373] system 00:0b: [mem 0xfed90000-0xfed93fff] has been reserved
[    0.365375] system 00:0b: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.365376] system 00:0b: [mem 0xff000000-0xffffffff] has been reserved
[    0.365377] system 00:0b: [mem 0xfee00000-0xfeefffff] could not be reserved
[    0.365378] system 00:0b: [mem 0xdfa00000-0xdfa00fff] has been reserved
[    0.365380] system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.365487] pnp 00:0c: [mem 0x20000000-0x201fffff]
[    0.365488] pnp 00:0c: [mem 0x40004000-0x40004fff]
[    0.365520] system 00:0c: [mem 0x20000000-0x201fffff] has been reserved
[    0.365522] system 00:0c: [mem 0x40004000-0x40004fff] has been reserved
[    0.365523] system 00:0c: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.365538] pnp: PnP ACPI: found 13 devices
[    0.365538] ACPI: ACPI bus type pnp unregistered
[    0.400849] pci 0000:01:00.0: PCI bridge to [bus 02]
[    0.400853] pci 0000:01:00.0:   bridge window [io  0xe000-0xefff]
[    0.400868] pci 0000:00:01.0: PCI bridge to [bus 01-02]
[    0.400869] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    0.400873] pci 0000:00:1c.0: PCI bridge to [bus 03]
[    0.400893] pci 0000:00:1c.7: PCI bridge to [bus 04]
[    0.400895] pci 0000:00:1c.7:   bridge window [io  0xd000-0xdfff]
[    0.400900] pci 0000:00:1c.7:   bridge window [mem 0xf7c00000-0xf7cfffff]
[    0.400931] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.400932] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.400933] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.400934] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000d3fff]
[    0.400935] pci_bus 0000:00: resource 8 [mem 0x000d4000-0x000d7fff]
[    0.400937] pci_bus 0000:00: resource 9 [mem 0x000d8000-0x000dbfff]
[    0.400938] pci_bus 0000:00: resource 10 [mem 0x000dc000-0x000dffff]
[    0.400939] pci_bus 0000:00: resource 11 [mem 0x000e0000-0x000e3fff]
[    0.400940] pci_bus 0000:00: resource 12 [mem 0x000e4000-0x000e7fff]
[    0.400941] pci_bus 0000:00: resource 13 [mem 0xdfa00000-0xfeafffff]
[    0.400942] pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
[    0.400944] pci_bus 0000:02: resource 0 [io  0xe000-0xefff]
[    0.400945] pci_bus 0000:04: resource 0 [io  0xd000-0xdfff]
[    0.400946] pci_bus 0000:04: resource 1 [mem 0xf7c00000-0xf7cfffff]
[    0.400961] NET: Registered protocol family 2
[    0.401043] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.401165] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.401219] TCP: Hash tables configured (established 131072 bind 65536)
[    0.401225] TCP: reno registered
[    0.401226] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    0.401229] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    0.401257] NET: Registered protocol family 1
[    0.401263] pci 0000:00:02.0: Boot video device
[    0.434304] PCI: CLS 64 bytes, default 64
[    0.434343] Unpacking initramfs...
[    0.734938] Freeing initrd memory: 25872k freed
[    0.737441] audit: initializing netlink socket (disabled)
[    0.737449] type=2000 audit(1350225418.636:1): initialized
[    0.748189] bounce pool size: 64 pages
[    0.748191] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    0.749007] VFS: Disk quotas dquot_6.5.2
[    0.749033] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.749165] msgmni has been set to 1698
[    0.749283] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.749298] io scheduler noop registered
[    0.749298] io scheduler deadline registered
[    0.749302] io scheduler cfq registered (default)
[    0.749363] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
[    0.749546] intel_idle: MWAIT substates: 0x1120
[    0.749547] intel_idle: v0.4 model 0x3A
[    0.749548] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.752282] Serial: 8250/16550 driver, 8 ports, IRQ sharing disabled
[    0.752654] Non-volatile memory driver v1.3
[    0.752655] Linux agpgart interface v0.103
[    0.752727] ahci 0000:00:1f.2: version 3.0
[    0.752762] ahci 0000:00:1f.2: irq 41 for MSI/MSI-X
[    0.752784] ahci: SSS flag set, parallel bus scan disabled
[    0.763356] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x23 impl SATA mode
[    0.763360] ahci 0000:00:1f.2: flags: 64bit ncq stag pm led clo pio slum part ems sxs apst 
[    0.763369] ahci 0000:00:1f.2: setting latency timer to 64
[    0.776876] scsi0 : ahci
[    0.776912] scsi1 : ahci
[    0.776941] scsi2 : ahci
[    0.776969] scsi3 : ahci
[    0.776998] scsi4 : ahci
[    0.777026] scsi5 : ahci
[    0.777048] ata1: SATA max UDMA/133 abar m2048@0xf7d32000 port 0xf7d32100 irq 41
[    0.777051] ata2: SATA max UDMA/133 abar m2048@0xf7d32000 port 0xf7d32180 irq 41
[    0.777052] ata3: DUMMY
[    0.777052] ata4: DUMMY
[    0.777053] ata5: DUMMY
[    0.777055] ata6: SATA max UDMA/133 abar m2048@0xf7d32000 port 0xf7d32380 irq 41
[    0.777093] libphy: Fixed MDIO Bus: probed
[    0.777094] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.777111] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[    0.777114] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[    0.777117] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    0.781018] ehci_hcd 0000:00:1a.0: debug port 2
[    0.781024] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
[    0.781035] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xf7d34000
[    0.789930] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    0.789950] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.789953] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.789955] usb usb1: Product: EHCI Host Controller
[    0.789957] usb usb1: Manufacturer: Linux 3.6.2 ehci_hcd
[    0.789959] usb usb1: SerialNumber: 0000:00:1a.0
[    0.790035] hub 1-0:1.0: USB hub found
[    0.790037] hub 1-0:1.0: 2 ports detected
[    0.790082] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[    0.790085] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[    0.790087] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    0.793981] ehci_hcd 0000:00:1d.0: debug port 2
[    0.793987] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
[    0.793997] ehci_hcd 0000:00:1d.0: irq 23, io mem 0xf7d33000
[    0.803224] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    0.803237] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    0.803240] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.803242] usb usb2: Product: EHCI Host Controller
[    0.803244] usb usb2: Manufacturer: Linux 3.6.2 ehci_hcd
[    0.803246] usb usb2: SerialNumber: 0000:00:1d.0
[    0.803314] hub 2-0:1.0: USB hub found
[    0.803315] hub 2-0:1.0: 2 ports detected
[    0.803348] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.803355] uhci_hcd: USB Universal Host Controller Interface driver
[    0.803362] Initializing USB Mass Storage driver...
[    0.803371] usbcore: registered new interface driver usb-storage
[    0.803372] USB Mass Storage support registered.
[    0.803375] usbcore: registered new interface driver ums-alauda
[    0.803378] usbcore: registered new interface driver ums-cypress
[    0.803382] usbcore: registered new interface driver ums-datafab
[    0.803385] usbcore: registered new interface driver ums-freecom
[    0.803388] usbcore: registered new interface driver ums-isd200
[    0.803391] usbcore: registered new interface driver ums-jumpshot
[    0.803394] usbcore: registered new interface driver ums-karma
[    0.803397] usbcore: registered new interface driver ums-onetouch
[    0.803400] usbcore: registered new interface driver ums-sddr09
[    0.803403] usbcore: registered new interface driver ums-sddr55
[    0.803406] usbcore: registered new interface driver ums-usbat
[    0.803428] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    0.805990] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.805996] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.806043] mousedev: PS/2 mouse device common for all mice
[    0.806099] rtc_cmos 00:06: RTC can wake from S4
[    0.806202] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
[    0.806231] rtc0: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    0.806268] cpuidle: using governor ladder
[    0.806355] usbcore: registered new interface driver usbhid
[    0.806355] usbhid: USB HID core driver
[    0.806435] ashmem: initialized
[    0.806515] TCP: cubic registered
[    0.806576] NET: Registered protocol family 10
[    0.806668] lib80211: common routines for IEEE802.11 drivers
[    0.806669] lib80211_crypt: registered algorithm 'NULL'
[    0.806675] Key type dns_resolver registered
[    0.806677] Key type ceph registered
[    0.806681] libceph: loaded (mon/osd proto 15/24, osdmap 5/6 5/6)
[    0.806809] Using IPI No-Shortcut mode
[    0.806913] registered taskstats version 1
[    0.807216]   Magic number: 0:143:637
[    0.807292] rtc_cmos 00:06: setting system clock to 2012-10-14 14:36:59 UTC (1350225419)
[    1.095746] usb 1-1: new high-speed USB device number 2 using ehci_hcd
[    1.095752] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.104985] ata1.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
[    1.104990] ata1.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
[    1.104994] ata1.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) filtered out
[    1.107753] ata1.00: ATAPI: HL-DT-ST BDDVDRW UH12LS29, 1.00, max UDMA/133
[    1.112793] ata1.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
[    1.112798] ata1.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
[    1.112801] ata1.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) filtered out
[    1.115545] ata1.00: configured for UDMA/133
[    1.124563] scsi 0:0:0:0: CD-ROM            HL-DT-ST BDDVDRW UH12LS29 1.00 PQ: 0 ANSI: 5
[    1.219072] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
[    1.219076] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.219349] hub 1-1:1.0: USB hub found
[    1.219442] hub 1-1:1.0: 6 ports detected
[    1.325071] usb 2-1: new high-speed USB device number 2 using ehci_hcd
[    1.441416] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.442850] ata2.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
[    1.442856] ata2.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
[    1.442859] ata2.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) filtered out
[    1.448417] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
[    1.448421] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.448692] hub 2-1:1.0: USB hub found
[    1.448787] hub 2-1:1.0: 8 ports detected
[    1.453230] ata2.00: ATA-9: INTEL SSDSC2CW060A3, 400i, max UDMA/133
[    1.453233] ata2.00: 117231408 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.462747] ata2.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
[    1.462752] ata2.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
[    1.462756] ata2.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY) filtered out
[    1.473132] ata2.00: configured for UDMA/133
[    1.473310] scsi 1:0:0:0: Direct-Access     ATA      INTEL SSDSC2CW06 400i PQ: 0 ANSI: 5
[    1.124802] ACPI: Invalid Power Resource to register!
[    1.473485] sd 1:0:0:0: [sda] 117231408 512-byte logical blocks: (60.0 GB/55.8 GiB)
[    1.473683] sd 1:0:0:0: [sda] Write Protect is off
[    1.473686] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.473798] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.474517]  sda: sda1 sda2 sda3 sda4
[    1.474855] sd 1:0:0:0: [sda] Attached SCSI disk
[    1.514627] usb 1-1.2: new high-speed USB device number 3 using ehci_hcd
[    1.601158] usb 1-1.2: New USB device found, idVendor=0846, idProduct=9011
[    1.601163] usb 1-1.2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    1.601165] usb 1-1.2: Product: Remote Download Wireless Adapter
[    1.601167] usb 1-1.2: Manufacturer: Broadcom
[    1.601170] usb 1-1.2: SerialNumber: 0
[    1.714055] usb 2-1.6: new full-speed USB device number 3 using ehci_hcd
[    1.737228] tsc: Refined TSC clocksource calibration: 3392.302 MHz
[    1.737234] Switching to clocksource tsc
[    1.790419] ata6: SATA link down (SStatus 0 SControl 300)
[    1.790556] Freeing unused kernel memory: 452k freed
[    1.800292] usb 2-1.6: New USB device found, idVendor=19ff, idProduct=0231
[    1.800294] usb 2-1.6: New USB device strings: Mfr=0, Product=2, SerialNumber=0
[    1.800295] usb 2-1.6: Product: Dynex wireless combo
[    1.812704] emc: device handler registered
[    1.813598] rdac: device handler registered
[    1.814555] alua: device handler registered
[    1.815408] hp_sw: device handler registered
[    1.817953] udevd[113]: starting version 182
[    1.822988] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    1.823012] ACPI: Power Button [PWRB]
[    1.823046] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    1.823060] ACPI: Power Button [PWRF]
[    1.829105] xhci_hcd 0000:00:14.0: setting latency timer to 64
[    1.829112] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    1.829116] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 3
[    1.829198] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
[    1.829204] xhci_hcd 0000:00:14.0: irq 16, io mem 0xf7d20000
[    1.829246] xhci_hcd 0000:00:14.0: irq 42 for MSI/MSI-X
[    1.829293] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[    1.829294] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.829295] usb usb3: Product: xHCI Host Controller
[    1.829296] usb usb3: Manufacturer: Linux 3.6.2 xhci_hcd
[    1.829297] usb usb3: SerialNumber: 0000:00:14.0
[    1.831676] input: Dynex wireless combo as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.6/2-1.6:1.0/input/input2
[    1.831802] hid-generic 0003:19FF:0231.0001: input,hidraw0: USB HID v1.11 Keyboard [Dynex wireless combo] on usb-0000:00:1d.0-1.6/input0
[    1.831921] input: Dynex wireless combo as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.6/2-1.6:1.1/input/input3
[    1.831997] hid-generic 0003:19FF:0231.0002: input,hidraw1: USB HID v1.11 Mouse [Dynex wireless combo] on usb-0000:00:1d.0-1.6/input1
[    1.832545] [drm] Initialized drm 1.1.0 20060810
[    1.833032] drm_kms_helper: Unknown parameter `edid'
[    1.843701] xHCI xhci_add_endpoint called for root hub
[    1.843703] xHCI xhci_check_bandwidth called for root hub
[    1.843727] hub 3-0:1.0: USB hub found
[    1.843736] hub 3-0:1.0: 4 ports detected
[    1.843761] thermal LNXTHERM:00: registered as thermal_zone0
[    1.843762] ACPI: Thermal Zone [TZ00] (28 C)
[    1.843779] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    1.843781] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 4
[    1.843797] usb usb4: New USB device found, idVendor=1d6b, idProduct=0003
[    1.843799] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.843800] usb usb4: Product: xHCI Host Controller
[    1.843801] usb usb4: Manufacturer: Linux 3.6.2 xhci_hcd
[    1.843802] usb usb4: SerialNumber: 0000:00:14.0
[    1.843877] xHCI xhci_add_endpoint called for root hub
[    1.843878] xHCI xhci_check_bandwidth called for root hub
[    1.843894] hub 4-0:1.0: USB hub found
[    1.843900] hub 4-0:1.0: 4 ports detected
[    1.843910] thermal LNXTHERM:01: registered as thermal_zone1
[    1.843911] ACPI: Thermal Zone [TZ01] (30 C)
[    1.843957] ACPI: Fan [FAN0] (off)
[    1.843983] ACPI: Fan [FAN1] (off)
[    1.844003] ACPI: Fan [FAN2] (off)
[    1.844023] ACPI: Fan [FAN3] (off)
[    1.844042] ACPI: Fan [FAN4] (off)
[    1.867388] i915_pci_probe: Entered
[    1.867390] dropping agp requirement
[    1.867391] force-disabling agp on gen 7, is_ivybridge 1
[    1.867559] pci 0000:00:00.0: Intel Ivybridge Chipset
[    1.867591] pci 0000:00:00.0: detected gtt size: 2097152K total, 262144K mappable
[    1.868147] pci 0000:00:00.0: detected 65536K stolen memory
[    1.868303] i915 0000:00:02.0: setting latency timer to 64
[    1.473507] ACPI: Invalid Power Resource to register!
[    1.868483] [drm:intel_detect_pch], Found PatherPoint PCH
[    1.868835] [drm:intel_gt_init], Using MT version of forcewake
[    1.868906] [drm:intel_opregion_setup], graphic opregion physical addr: 0xda407018
[    1.868910] [drm:intel_opregion_setup], SWSCI supported
[    1.868928] i915 0000:00:02.0: irq 43 for MSI/MSI-X
[    1.868932] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    1.868933] [drm] Driver supports precise vblank timestamp query.
[    1.868934] [drm:init_vbt_defaults], Set default to SSC at 100MHz
[    1.868935] [drm:intel_parse_bios], Using VBT from OpRegion: $VBT SNB/IVB-DESKTOPd
[    1.868937] [drm:parse_general_features], BDB_GENERAL_FEATURES int_tv_support 0 int_crt_support 1 lvds_use_ssc 0 lvds_ssc_freq 120 display_clock_mode 0
[    1.868938] [drm:parse_general_definitions], crt_ddc_bus_pin: 5
[    1.868940] [drm:parse_lfp_panel_data], Found panel mode in BIOS VBT tables:
[    1.868941] [drm:drm_mode_debug_printmodeline], Modeline 0:"1024x768" 0 65000 1024 1048 1184 1344 768 771 777 806 0x8 0xa
[    1.868943] [drm:parse_lfp_panel_data], VBT initial LVDS value 300
[    1.868945] [drm:parse_sdvo_panel_data], Found SDVO panel mode in BIOS VBT tables:
[    1.868946] [drm:drm_mode_debug_printmodeline], Modeline 0:"1600x1200" 0 162000 1600 1664 1856 2160 1200 1201 1204 1250 0x8 0xa
[    1.868948] [drm:parse_sdvo_device_mapping], No SDVO device info is found in VBT
[    1.868993] [drm:intel_modeset_init], 3 display pipes available.
[    1.869003] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    1.869310] [drm:intel_lvds_init], LVDS is not present in VBT
[    1.869331] [drm:intel_crt_init], pch crt adpa set to 0x80f40010
[    1.869748] [drm:intel_sdvo_read_byte], i2c transfer returned -6
[    1.869750] [drm:intel_sdvo_init], No SDVO device found on SDVOB
[    1.869790] [drm:intel_dp_i2c_init], i2c_init DPDDC-B
[    1.872396] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    1.872397] [drm:intel_dp_i2c_aux_ch], aux_ch failed -110
[    1.874992] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    1.874993] [drm:intel_dp_i2c_aux_ch], aux_ch failed -110
[    1.875046] [drm:intel_dp_i2c_init], i2c_init DPDDC-C
[    1.877652] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    1.877653] [drm:intel_dp_i2c_aux_ch], aux_ch failed -110
[    1.880249] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    1.880249] [drm:intel_dp_i2c_aux_ch], aux_ch failed -110
[    1.880273] [drm:intel_dp_i2c_init], i2c_init DPDDC-D
[    1.882869] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    1.882870] [drm:intel_dp_i2c_aux_ch], aux_ch failed -110
[    1.885461] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    1.885462] [drm:intel_dp_i2c_aux_ch], aux_ch failed -110
[    1.885493] [drm:ironlake_crtc_dpms], crtc 0/0 dpms off
[    1.885496] [drm:i915_get_vblank_timestamp], crtc 0 is disabled
[    1.910283] [drm:ironlake_crtc_dpms], crtc 1/1 dpms off
[    1.910286] [drm:gm45_get_vblank_counter], trying to get vblank count for disabled pipe B
[    1.910287] [drm:i915_get_vblank_timestamp], crtc 1 is disabled
[    1.910288] [drm:gm45_get_vblank_counter], trying to get vblank count for disabled pipe B
[    1.910728] [drm:ironlake_crtc_dpms], crtc 2/2 dpms off
[    1.910729] [drm:gm45_get_vblank_counter], trying to get vblank count for disabled pipe C
[    1.910730] [drm:i915_get_vblank_timestamp], crtc 2 is disabled
[    1.910731] [drm:gm45_get_vblank_counter], trying to get vblank count for disabled pipe C
[    1.911171] [drm:ironlake_init_pch_refclk], has_panel 0 has_lvds 0 has_pch_edp 0 has_cpu_edp 0 has_ck505 0
[    1.911176] [drm:ironlake_init_pch_refclk], Disabling SSC entirely
[    1.935473] [drm:init_status_page], render ring hws offset: 0x00000000
[    1.935823] [drm:init_status_page], bsd ring hws offset: 0x00022000
[    1.935863] [drm:init_status_page], blitter ring hws offset: 0x00043000
[    1.935909] [drm:create_default_context], Default HW context loaded
[    1.935910] [drm:i915_gem_context_init], HW context support initialized
[    1.935967] [drm:intel_enable_rc6], RC6 and deep RC6 enabled
[    1.935968] [drm] Enabling RC6 states: RC6 on, RC6p on, RC6pp off
[    2.053056] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1]
[    2.053060] [drm:intel_ironlake_crt_detect_hotplug], trigger hotplug detect cycle: adpa=0xf40010
[    2.066294] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40010, result 0
[    2.066299] [drm:intel_crt_detect], CRT not detected via hotplug
[    2.066724] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpb
[    2.066725] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[    2.066727] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1] disconnected
[    2.066728] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:HDMI-A-1]
[    2.067145] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpb
[    2.067146] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:HDMI-A-1] disconnected
[    2.067147] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:DP-1]
[    2.069747] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    2.078861] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    2.085510] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    2.089556] [drm:intel_dp_detect], DPCD: 0000000000000000
[    2.089562] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:DP-1] disconnected
[    2.089565] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:HDMI-A-2]
[    2.096206] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
[    2.096212] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[    2.096215] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:HDMI-A-2] disconnected
[    2.096218] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:HDMI-A-3]
[    2.222511] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    2.222582] Raw EDID:
[    2.222627]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    2.222679]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.222729]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.222781]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.222830]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.222881]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.222930]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.222982]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.335522] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    2.335615] Raw EDID:
[    2.335684]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    2.335756]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.335830]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.335904]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.335978]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.336052]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.336125]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.336199]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.448539] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    2.448656] Raw EDID:
[    2.448725]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    2.448799]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.448874]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.448944]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.449019]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.449092]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.449165]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.449239]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.561546] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    2.561663] Raw EDID:
[    2.561731]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    2.561805]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.561879]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.561952]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.562026]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.562099]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.562174]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.562248]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.562322] i915 0000:00:02.0: HDMI-A-3: EDID block 0 invalid.
[    2.562324] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:HDMI-A-3] disconnected
[    2.562325] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-2]
[    2.564933] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    2.574115] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    2.580762] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    2.584803] [drm:intel_dp_detect], DPCD: 0000000000000000
[    2.584809] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-2] disconnected
[    2.584813] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-3]
[    2.587415] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    2.594058] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    2.600705] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    2.604746] [drm:intel_dp_detect], DPCD: 0000000000000000
[    2.604752] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-3] disconnected
[    2.604755] No connectors reported connected with modes
[    2.604757] [drm:drm_setup_crtcs], 
[    2.604759] [drm:drm_enable_connectors], connector 9 enabled? no
[    2.604762] [drm:drm_enable_connectors], connector 12 enabled? no
[    2.604764] [drm:drm_enable_connectors], connector 15 enabled? no
[    2.604765] [drm:drm_enable_connectors], connector 18 enabled? no
[    2.604767] [drm:drm_enable_connectors], connector 20 enabled? no
[    2.604769] [drm:drm_enable_connectors], connector 21 enabled? no
[    2.604771] [drm:drm_enable_connectors], connector 23 enabled? no
[    2.604781] [drm:drm_setup_crtcs], picking CRTCs for 8192x8192 config
[    2.604783] [drm] Cannot find any crtc or sizes - going 1024x768
[    2.607052] [drm:intelfb_create], allocated 1024x768 fb: 0x00073000, bo f4db6f00
[    2.607139] fbcon: inteldrmfb (fb0) is primary device
[    2.607511] [drm:drm_crtc_helper_set_config], 
[    2.607512] [drm:drm_crtc_helper_set_config], [CRTC:3] [NOFB]
[    2.607534] [drm:drm_crtc_helper_set_config], 
[    2.607535] [drm:drm_crtc_helper_set_config], [CRTC:5] [NOFB]
[    2.607554] [drm:drm_crtc_helper_set_config], 
[    2.607555] [drm:drm_crtc_helper_set_config], [CRTC:7] [NOFB]
[    2.609142] Console: switching to colour frame buffer device 128x48
[    2.610708] fb0: inteldrmfb frame buffer device
[    2.610709] drm: registered panic notifier
[    2.625008] acpi device:4b: registered as cooling_device9
[    2.625106] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    2.625135] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input4
[    2.625166] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    2.640039] [drm:i915_driver_open], 
[    2.640050] [drm:drm_crtc_helper_set_config], 
[    2.640051] [drm:drm_crtc_helper_set_config], [CRTC:3] [NOFB]
[    2.640074] [drm:drm_crtc_helper_set_config], 
[    2.640075] [drm:drm_crtc_helper_set_config], [CRTC:5] [NOFB]
[    2.640095] [drm:drm_crtc_helper_set_config], 
[    2.640096] [drm:drm_crtc_helper_set_config], [CRTC:7] [NOFB]
[    2.640122] [drm:i915_driver_open], 
[    2.640126] [drm:drm_crtc_helper_set_config], 
[    2.640127] [drm:drm_crtc_helper_set_config], [CRTC:3] [NOFB]
[    2.640149] [drm:drm_crtc_helper_set_config], 
[    2.640150] [drm:drm_crtc_helper_set_config], [CRTC:5] [NOFB]
[    2.640169] [drm:drm_crtc_helper_set_config], 
[    2.640170] [drm:drm_crtc_helper_set_config], [CRTC:7] [NOFB]
[    2.640194] [drm:i915_driver_open], 
[    2.640219] [drm:drm_mode_getresources], CRTC[3] CONNECTORS[7] ENCODERS[7]
[    2.640222] [drm:drm_mode_getresources], CRTC[3] CONNECTORS[7] ENCODERS[7]
[    2.640226] [drm:drm_mode_getconnector], [CONNECTOR:9:?]
[    2.640228] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1]
[    2.640233] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40010, result 0
[    2.640234] [drm:intel_crt_detect], CRT not detected via hotplug
[    2.640647] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpb
[    2.640648] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[    2.640649] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1] disconnected
[    2.640651] [drm:drm_mode_getconnector], [CONNECTOR:9:?]
[    2.640652] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1]
[    2.640654] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40010, result 0
[    2.640655] [drm:intel_crt_detect], CRT not detected via hotplug
[    2.641069] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpb
[    2.641069] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[    2.641070] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1] disconnected
[    2.641073] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[    2.641074] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:HDMI-A-1]
[    2.641486] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpb
[    2.641487] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:HDMI-A-1] disconnected
[    2.641488] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[    2.641489] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:HDMI-A-1]
[    2.641903] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpb
[    2.641904] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:HDMI-A-1] disconnected
[    2.641906] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
[    2.641907] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:DP-1]
[    2.644516] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    2.653865] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    2.663838] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    2.671207] [drm:intel_dp_detect], DPCD: 0000000000000000
[    2.671212] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:DP-1] disconnected
[    2.671217] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
[    2.671219] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:DP-1]
[    2.673828] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    2.680476] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    2.687126] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    2.691166] [drm:intel_dp_detect], DPCD: 0000000000000000
[    2.691172] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:DP-1] disconnected
[    2.691183] [drm:drm_mode_getconnector], [CONNECTOR:18:?]
[    2.691186] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:HDMI-A-2]
[    2.697824] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
[    2.697830] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[    2.697834] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:HDMI-A-2] disconnected
[    2.697841] [drm:drm_mode_getconnector], [CONNECTOR:18:?]
[    2.697852] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:HDMI-A-2]
[    2.704468] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
[    2.704473] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[    2.704477] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:HDMI-A-2] disconnected
[    2.704487] [drm:drm_mode_getconnector], [CONNECTOR:20:?]
[    2.704498] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:HDMI-A-3]
[    2.830778] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    2.830826] Raw EDID:
[    2.830836]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    2.830856]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.830876]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.830897]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.830917]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.830938]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.830958]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.830978]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.943788] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    2.943835] Raw EDID:
[    2.943845]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    2.943865]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.943886]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.943906]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.943926]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.943947]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.943967]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    2.943987]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.056797] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    3.056846] Raw EDID:
[    3.056856]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    3.056876]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.057307]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.057736]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.058149]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.058546]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.058937]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.059312]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.169808] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    3.170230] Raw EDID:
[    3.170635]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    3.171066]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.171500]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.171934]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.172366]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.172782]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.173184]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.173582]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.173964] i915 0000:00:02.0: HDMI-A-3: EDID block 0 invalid.
[    3.173965] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:HDMI-A-3] disconnected
[    3.173969] [drm:drm_mode_getconnector], [CONNECTOR:20:?]
[    3.173971] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:HDMI-A-3]
[    3.299436] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    3.299864] Raw EDID:
[    3.300271]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    3.300708]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.301145]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.301583]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.302019]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.302454]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.302873]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.303272]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.415768] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    3.416199] Raw EDID:
[    3.416609]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    3.417045]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.417484]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.417921]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.418357]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.418795]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.419216]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.419616]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.532104] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    3.532535] Raw EDID:
[    3.532944]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    3.533382]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.533822]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.534261]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.534698]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.535138]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.535561]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.535959]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.648438] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    3.648868] Raw EDID:
[    3.649276]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    3.649712]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.650149]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.650584]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.651018]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.651454]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.651870]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.652262]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    3.652642] i915 0000:00:02.0: HDMI-A-3: EDID block 0 invalid.
[    3.652644] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:HDMI-A-3] disconnected
[    3.652649] [drm:drm_mode_getconnector], [CONNECTOR:21:?]
[    3.652650] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-2]
[    3.655260] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    3.664326] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    3.670971] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    3.675021] [drm:intel_dp_detect], DPCD: 0000000000000000
[    3.675027] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-2] disconnected
[    3.675035] [drm:drm_mode_getconnector], [CONNECTOR:21:?]
[    3.675038] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-2]
[    3.677639] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    3.684266] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    3.690915] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    3.694965] [drm:intel_dp_detect], DPCD: 0000000000000000
[    3.694972] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-2] disconnected
[    3.694982] [drm:drm_mode_getconnector], [CONNECTOR:23:?]
[    3.694986] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-3]
[    3.697605] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    3.704214] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    3.710863] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    3.714909] [drm:intel_dp_detect], DPCD: 0000000000000000
[    3.714915] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-3] disconnected
[    3.714923] [drm:drm_mode_getconnector], [CONNECTOR:23:?]
[    3.714926] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-3]
[    3.717525] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    3.724155] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    3.730810] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    3.734852] [drm:intel_dp_detect], DPCD: 0000000000000000
[    3.734858] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-3] disconnected
[    3.734897] [drm:drm_crtc_helper_set_config], 
[    3.734898] [drm:drm_crtc_helper_set_config], [CRTC:3] [NOFB]
[    3.734921] [drm:drm_crtc_helper_set_config], 
[    3.734922] [drm:drm_crtc_helper_set_config], [CRTC:5] [NOFB]
[    3.734942] [drm:drm_crtc_helper_set_config], 
[    3.734942] [drm:drm_crtc_helper_set_config], [CRTC:7] [NOFB]
[    4.275663] EXT4-fs (sda4): mounted filesystem with ordered data mode. Opts: acl,user_xattr
[    4.289841] EXT4-fs (sda4): re-mounted. Opts: acl,user_xattr
[    4.568222] systemd-readahead-replay[270]: Bumped block_nr parameter of 8:0 to 16384. This is a temporary hack and should be removed one day.
[    4.966624] udevd[302]: starting version 182
[    5.035757] microcode: CPU0 sig=0x306a9, pf=0x2, revision=0x12
[    5.036937] microcode: CPU1 sig=0x306a9, pf=0x2, revision=0x12
[    5.037146] microcode: CPU2 sig=0x306a9, pf=0x2, revision=0x12
[    5.037366] microcode: CPU3 sig=0x306a9, pf=0x2, revision=0x12
[    5.037641] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    5.159360] EXT4-fs (sda4): re-mounted. Opts: acl,user_xattr
[    5.202946] BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
[    5.435540] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    5.435940] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    5.438844] ACPI Warning: 0x00000428-0x0000042f SystemIO conflicts with Region \PMIO 1 (20120711/utaddress-251)
[    5.438849] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    5.438851] ACPI Warning: 0x00000500-0x0000053f SystemIO conflicts with Region \GPIO 1 (20120711/utaddress-251)
[    5.438853] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    5.438854] lpc_ich: Resource conflict(s) found affecting gpio_ich
[    5.439034] e1000e: Intel(R) PRO/1000 Network Driver - 2.0.0-k
[    5.439035] e1000e: Copyright(c) 1999 - 2012 Intel Corporation.
[    5.439057] e1000e 0000:00:19.0: setting latency timer to 64
[    5.439099] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[    5.439125] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[    5.444846] sr 0:0:0:0: Attached scsi generic sg0 type 5
[    5.444869] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    5.447672] input: PC Speaker as /devices/platform/pcspkr/input/input5
[    5.457476] kvm: disabled by bios
[    5.462373] sr0: scsi3-mmc drive: 40x/40x writer dvd-ram cd/rw xa/form2 cdda tray
[    5.462376] cdrom: Uniform CD-ROM driver Revision: 3.20
[    5.462515] sr 0:0:0:0: Attached scsi CD-ROM sr0
[    5.473886] kvm: disabled by bios
[    5.617681] Adding 4193276k swap on /dev/sda3.  Priority:-1 extents:1 across:4193276k SS
[    5.693802] e1000e 0000:00:19.0: eth0: (PCI Express:2.5GT/s:Width x1) e8:40:f2:05:f1:85
[    5.693804] e1000e 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    5.693853] e1000e 0000:00:19.0: eth0: MAC: 10, PHY: 11, PBA No: FFFFFF-0FF
[    5.693906] ACPI Warning: 0x0000f040-0x0000f05f SystemIO conflicts with Region \_SB_.PCI0.SBUS.SMBI 1 (20120711/utaddress-251)
[    5.693910] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    5.725630] EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts: acl,user_xattr
[    6.592840] [drm:i915_driver_open], 
[    6.592862] [drm:drm_crtc_helper_set_config], 
[    6.592863] [drm:drm_crtc_helper_set_config], [CRTC:3] [NOFB]
[    6.592889] [drm:drm_crtc_helper_set_config], 
[    6.592890] [drm:drm_crtc_helper_set_config], [CRTC:5] [NOFB]
[    6.592910] [drm:drm_crtc_helper_set_config], 
[    6.592910] [drm:drm_crtc_helper_set_config], [CRTC:7] [NOFB]
[    6.592946] [drm:i915_driver_open], 
[    6.593080] [drm:drm_mode_getresources], CRTC[3] CONNECTORS[7] ENCODERS[7]
[    6.593083] [drm:drm_mode_getresources], CRTC[3] CONNECTORS[7] ENCODERS[7]
[    6.593111] [drm:drm_mode_getconnector], [CONNECTOR:9:?]
[    6.593113] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1]
[    6.593119] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40010, result 0
[    6.593120] [drm:intel_crt_detect], CRT not detected via hotplug
[    6.593545] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpb
[    6.593546] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[    6.593548] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1] disconnected
[    6.593550] [drm:drm_mode_getconnector], [CONNECTOR:9:?]
[    6.593551] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1]
[    6.593556] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40010, result 0
[    6.593557] [drm:intel_crt_detect], CRT not detected via hotplug
[    6.593972] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpb
[    6.593973] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[    6.593974] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1] disconnected
[    6.593991] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[    6.593992] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:HDMI-A-1]
[    6.594421] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpb
[    6.594422] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:HDMI-A-1] disconnected
[    6.594424] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[    6.594425] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:HDMI-A-1]
[    6.594848] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpb
[    6.594849] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:HDMI-A-1] disconnected
[    6.594858] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
[    6.594860] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:DP-1]
[    6.597463] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    6.605934] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    6.612557] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    6.619930] [drm:intel_dp_detect], DPCD: 0000000000000000
[    6.619934] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:DP-1] disconnected
[    6.619940] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
[    6.619941] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:DP-1]
[    6.622549] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    6.629177] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    6.635827] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    6.639866] [drm:intel_dp_detect], DPCD: 0000000000000000
[    6.639869] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:DP-1] disconnected
[    6.639905] [drm:drm_mode_getconnector], [CONNECTOR:18:?]
[    6.639907] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:HDMI-A-2]
[    6.646539] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
[    6.646545] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[    6.646549] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:HDMI-A-2] disconnected
[    6.646558] [drm:drm_mode_getconnector], [CONNECTOR:18:?]
[    6.646561] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:HDMI-A-2]
[    6.653193] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
[    6.653199] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[    6.653202] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:HDMI-A-2] disconnected
[    6.653245] [drm:drm_mode_getconnector], [CONNECTOR:20:?]
[    6.653246] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:HDMI-A-3]
[    6.779481] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    6.779482] Raw EDID:
[    6.779483]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    6.779484]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.779485]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.779485]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.779486]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.779487]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.779487]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.779488]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.789553] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[    6.892502] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    6.892505] Raw EDID:
[    6.892507]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    6.892508]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.892510]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.892511]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.892513]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.892514]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.892515]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.892517]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    6.892562] e1000e 0000:00:19.0: irq 44 for MSI/MSI-X
[    6.892647] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[    7.008817] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    7.008819] Raw EDID:
[    7.008821]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    7.008822]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.008822]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.008823]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.008824]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.008824]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.008825]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.008826]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.117033] RPC: Registered named UNIX socket transport module.
[    7.117035] RPC: Registered udp transport module.
[    7.117035] RPC: Registered tcp transport module.
[    7.117036] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    7.119227] FS-Cache: Loaded
[    7.121865] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    7.121866] Raw EDID:
[    7.121868]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    7.121868]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.121869]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.121870]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.121870]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.121871]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.121872]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.121872]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.121875] i915 0000:00:02.0: HDMI-A-3: EDID block 0 invalid.
[    7.121877] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:HDMI-A-3] disconnected
[    7.121886] [drm:drm_mode_getconnector], [CONNECTOR:20:?]
[    7.121888] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:HDMI-A-3]
[    7.121911] FS-Cache: Netfs 'nfs' registered for caching
[    7.261462] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    7.261465] Raw EDID:
[    7.261468]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    7.261469]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.261471]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.261472]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.261474]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.261483]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.261484]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.261485]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.374451] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    7.374454] Raw EDID:
[    7.374455]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    7.374456]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.374457]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.374457]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.374458]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.374459]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.374459]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.374460]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.487450] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    7.487452] Raw EDID:
[    7.487453]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    7.487454]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.487455]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.487455]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.487456]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.487457]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.487458]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.487458]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.607130] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    7.607133] Raw EDID:
[    7.607135]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    7.607137]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.607138]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.607140]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.607141]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.607143]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.607144]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.607154]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.607157] i915 0000:00:02.0: HDMI-A-3: EDID block 0 invalid.
[    7.607159] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:HDMI-A-3] disconnected
[    7.607197] [drm:drm_mode_getconnector], [CONNECTOR:21:?]
[    7.607199] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-2]
[    7.609805] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    7.616370] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    7.623018] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    7.627053] [drm:intel_dp_detect], DPCD: 0000000000000000
[    7.627056] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-2] disconnected
[    7.627061] [drm:drm_mode_getconnector], [CONNECTOR:21:?]
[    7.627062] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-2]
[    7.629666] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    7.636316] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    7.642961] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    7.646996] [drm:intel_dp_detect], DPCD: 0000000000000000
[    7.646999] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-2] disconnected
[    7.647024] [drm:drm_mode_getconnector], [CONNECTOR:23:?]
[    7.647026] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-3]
[    7.649629] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    7.656259] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    7.662904] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    7.666951] [drm:intel_dp_detect], DPCD: 0000000000000000
[    7.666957] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-3] disconnected
[    7.666966] [drm:drm_mode_getconnector], [CONNECTOR:23:?]
[    7.666969] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-3]
[    7.669586] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    7.676201] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    7.682847] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    7.686882] [drm:intel_dp_detect], DPCD: 0000000000000000
[    7.686885] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-3] disconnected
[    7.686923] [drm:drm_mode_getconnector], [CONNECTOR:9:?]
[    7.686925] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1]
[    7.686930] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40010, result 0
[    7.686932] [drm:intel_crt_detect], CRT not detected via hotplug
[    7.687355] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpb
[    7.687356] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[    7.687357] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1] disconnected
[    7.687359] [drm:drm_mode_getconnector], [CONNECTOR:9:?]
[    7.687360] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1]
[    7.687364] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40010, result 0
[    7.687365] [drm:intel_crt_detect], CRT not detected via hotplug
[    7.687778] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpb
[    7.687779] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[    7.687780] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1] disconnected
[    7.687797] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[    7.687799] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:HDMI-A-1]
[    7.688216] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpb
[    7.688218] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:HDMI-A-1] disconnected
[    7.688219] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[    7.688220] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:HDMI-A-1]
[    7.688635] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpb
[    7.688636] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:HDMI-A-1] disconnected
[    7.688646] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
[    7.688648] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:DP-1]
[    7.691257] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    7.699466] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    7.706116] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    7.710160] [drm:intel_dp_detect], DPCD: 0000000000000000
[    7.710166] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:DP-1] disconnected
[    7.710175] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
[    7.710178] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:DP-1]
[    7.712798] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    7.719409] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    7.726059] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    7.730102] [drm:intel_dp_detect], DPCD: 0000000000000000
[    7.730108] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:DP-1] disconnected
[    7.730147] [drm:drm_mode_getconnector], [CONNECTOR:18:?]
[    7.730149] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:HDMI-A-2]
[    7.736757] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
[    7.736763] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[    7.736767] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:HDMI-A-2] disconnected
[    7.736783] [drm:drm_mode_getconnector], [CONNECTOR:18:?]
[    7.736785] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:HDMI-A-2]
[    7.743409] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
[    7.743414] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[    7.743418] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:HDMI-A-2] disconnected
[    7.743451] [drm:drm_mode_getconnector], [CONNECTOR:20:?]
[    7.743452] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:HDMI-A-3]
[    7.869710] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    7.869713] Raw EDID:
[    7.869715]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    7.869717]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.869718]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.869720]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.869721]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.869722]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.869724]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.869725]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.982721] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    7.982724] Raw EDID:
[    7.982726]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    7.982728]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.982729]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.982730]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.982732]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.982733]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.982735]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    7.982736]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.095730] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    8.095733] Raw EDID:
[    8.095734]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    8.095736]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.095737]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.095739]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.095740]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.095742]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.095743]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.095744]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.208746] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    8.208748] Raw EDID:
[    8.208750]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    8.208752]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.208753]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.208755]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.208756]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.208758]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.208768]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.208768]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.208770] i915 0000:00:02.0: HDMI-A-3: EDID block 0 invalid.
[    8.208772] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:HDMI-A-3] disconnected
[    8.208776] [drm:drm_mode_getconnector], [CONNECTOR:20:?]
[    8.208777] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:HDMI-A-3]
[    8.335050] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    8.335053] Raw EDID:
[    8.335055]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    8.335056]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.335058]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.335059]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.335061]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.335062]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.335063]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.335065]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.388617] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: Rx/Tx
[    8.388620] e1000e 0000:00:19.0: eth0: 10/100 speed: disabling TSO
[    8.388652] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[    8.448063] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    8.448066] Raw EDID:
[    8.448068]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    8.448070]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.448071]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.448073]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.448074]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.448075]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.448085]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.448086]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.561073] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    8.561076] Raw EDID:
[    8.561078]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    8.561080]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.561081]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.561082]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.561084]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.561085]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.561087]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.561088]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.674083] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    8.674086] Raw EDID:
[    8.674088]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    8.674090]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.674091]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.674093]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.674094]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.674095]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.674106]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.674106]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    8.674108] i915 0000:00:02.0: HDMI-A-3: EDID block 0 invalid.
[    8.674109] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:HDMI-A-3] disconnected
[    8.674133] [drm:drm_mode_getconnector], [CONNECTOR:21:?]
[    8.674134] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-2]
[    8.676741] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    8.683332] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    8.689975] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    8.694021] [drm:intel_dp_detect], DPCD: 0000000000000000
[    8.694027] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-2] disconnected
[    8.694035] [drm:drm_mode_getconnector], [CONNECTOR:21:?]
[    8.694038] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-2]
[    8.696650] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    8.703275] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    8.709924] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    8.713964] [drm:intel_dp_detect], DPCD: 0000000000000000
[    8.713970] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-2] disconnected
[    8.714006] [drm:drm_mode_getconnector], [CONNECTOR:23:?]
[    8.714008] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-3]
[    8.716614] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    8.723220] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    8.729867] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    8.733906] [drm:intel_dp_detect], DPCD: 0000000000000000
[    8.733913] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-3] disconnected
[    8.733921] [drm:drm_mode_getconnector], [CONNECTOR:23:?]
[    8.733923] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-3]
[    8.736537] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    8.743161] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    8.749808] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    8.753850] [drm:intel_dp_detect], DPCD: 0000000000000000
[    8.753856] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-3] disconnected
[    8.761383] [drm:drm_mode_setcrtc], [CRTC:3]
[    8.761385] [drm:drm_crtc_helper_set_config], 
[    8.761386] [drm:drm_crtc_helper_set_config], [CRTC:3] [NOFB]
[    8.761411] [drm:drm_mode_setcrtc], [CRTC:5]
[    8.761412] [drm:drm_crtc_helper_set_config], 
[    8.761412] [drm:drm_crtc_helper_set_config], [CRTC:5] [NOFB]
[    8.761433] [drm:drm_mode_setcrtc], [CRTC:7]
[    8.761433] [drm:drm_crtc_helper_set_config], 
[    8.761434] [drm:drm_crtc_helper_set_config], [CRTC:7] [NOFB]
[    9.097333] [drm:drm_mode_getconnector], [CONNECTOR:9:?]
[    9.097337] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1]
[    9.097343] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40010, result 0
[    9.097344] [drm:intel_crt_detect], CRT not detected via hotplug
[    9.097767] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpb
[    9.097768] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[    9.097770] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1] disconnected
[    9.097773] [drm:drm_mode_getconnector], [CONNECTOR:9:?]
[    9.097774] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1]
[    9.097779] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40010, result 0
[    9.097780] [drm:intel_crt_detect], CRT not detected via hotplug
[    9.098194] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpb
[    9.098195] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[    9.098196] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1] disconnected
[    9.098201] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[    9.098203] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:HDMI-A-1]
[    9.098623] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpb
[    9.098624] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:HDMI-A-1] disconnected
[    9.098625] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[    9.098626] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:HDMI-A-1]
[    9.099049] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpb
[    9.099050] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:HDMI-A-1] disconnected
[    9.099052] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
[    9.099053] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:DP-1]
[    9.101656] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    9.108780] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    9.115407] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    9.119465] [drm:intel_dp_detect], DPCD: 0000000000000000
[    9.119472] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:DP-1] disconnected
[    9.119487] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
[    9.119498] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:DP-1]
[    9.122097] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    9.128703] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    9.135350] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[    9.139401] [drm:intel_dp_detect], DPCD: 0000000000000000
[    9.139407] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:DP-1] disconnected
[    9.139435] [drm:drm_mode_getconnector], [CONNECTOR:18:?]
[    9.139437] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:HDMI-A-2]
[    9.146069] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
[    9.146075] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[    9.146079] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:HDMI-A-2] disconnected
[    9.146087] [drm:drm_mode_getconnector], [CONNECTOR:18:?]
[    9.146090] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:HDMI-A-2]
[    9.152714] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
[    9.152720] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[    9.152724] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:HDMI-A-2] disconnected
[    9.152741] [drm:drm_mode_getconnector], [CONNECTOR:20:?]
[    9.152743] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:HDMI-A-3]
[    9.279021] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    9.279024] Raw EDID:
[    9.279026]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    9.279028]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.279029]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.279031]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.279032]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.279034]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.279044]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.279044]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.392030] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    9.392033] Raw EDID:
[    9.392035]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    9.392036]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.392038]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.392039]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.392041]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.392042]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.392043]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.392053]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.505040] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    9.505043] Raw EDID:
[    9.505045]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    9.505047]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.505048]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.505050]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.505051]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.505053]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.505054]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.505064]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.618053] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    9.618056] Raw EDID:
[    9.618058]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    9.618060]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.618061]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.618063]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.618064]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.618065]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.618075]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.618076]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.618078] i915 0000:00:02.0: HDMI-A-3: EDID block 0 invalid.
[    9.618080] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:HDMI-A-3] disconnected
[    9.618087] [drm:drm_mode_getconnector], [CONNECTOR:20:?]
[    9.618088] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:HDMI-A-3]
[    9.744357] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    9.744360] Raw EDID:
[    9.744362]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    9.744363]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.744365]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.744366]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.744368]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.744369]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.744370]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.744380]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.857368] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    9.857371] Raw EDID:
[    9.857373]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    9.857375]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.857376]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.857378]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.857379]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.857381]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.857382]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.857392]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.973703] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[    9.973706] Raw EDID:
[    9.973708]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[    9.973709]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.973711]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.973712]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.973713]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.973715]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.973725]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    9.973725]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.086714] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   10.086717] Raw EDID:
[   10.086719]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   10.086721]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.086722]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.086724]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.086725]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.086726]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.086736]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.086737]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.086739] i915 0000:00:02.0: HDMI-A-3: EDID block 0 invalid.
[   10.086740] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:HDMI-A-3] disconnected
[   10.086751] [drm:drm_mode_getconnector], [CONNECTOR:21:?]
[   10.086752] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-2]
[   10.089365] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   10.095952] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   10.102599] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   10.106649] [drm:intel_dp_detect], DPCD: 0000000000000000
[   10.106656] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-2] disconnected
[   10.106671] [drm:drm_mode_getconnector], [CONNECTOR:21:?]
[   10.106681] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-2]
[   10.109287] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   10.115915] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   10.122541] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   10.126589] [drm:intel_dp_detect], DPCD: 0000000000000000
[   10.126595] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-2] disconnected
[   10.126616] [drm:drm_mode_getconnector], [CONNECTOR:23:?]
[   10.126628] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-3]
[   10.129230] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   10.135837] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   10.142484] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   10.146536] [drm:intel_dp_detect], DPCD: 0000000000000000
[   10.146542] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-3] disconnected
[   10.146565] [drm:drm_mode_getconnector], [CONNECTOR:23:?]
[   10.146567] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-3]
[   10.149173] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   10.155814] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   10.162442] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   10.166486] [drm:intel_dp_detect], DPCD: 0000000000000000
[   10.166493] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-3] disconnected
[   10.167592] [drm:drm_mode_addfb], [FB:26]
[   10.169376] [drm:drm_mode_getconnector], [CONNECTOR:9:?]
[   10.169379] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1]
[   10.169384] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40010, result 0
[   10.169386] [drm:intel_crt_detect], CRT not detected via hotplug
[   10.169805] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpb
[   10.169806] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[   10.169808] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1] disconnected
[   10.169809] [drm:drm_mode_getconnector], [CONNECTOR:9:?]
[   10.169810] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1]
[   10.169812] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40010, result 0
[   10.169813] [drm:intel_crt_detect], CRT not detected via hotplug
[   10.170232] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpb
[   10.170233] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[   10.170233] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1] disconnected
[   10.170237] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[   10.170239] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:HDMI-A-1]
[   10.170656] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpb
[   10.170657] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:HDMI-A-1] disconnected
[   10.170658] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[   10.170659] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:HDMI-A-1]
[   10.171083] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpb
[   10.171084] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:HDMI-A-1] disconnected
[   10.171087] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
[   10.171088] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:DP-1]
[   10.173686] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   10.182370] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   10.189018] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   10.193089] [drm:intel_dp_detect], DPCD: 0000000000000000
[   10.193096] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:DP-1] disconnected
[   10.193110] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
[   10.193122] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:DP-1]
[   10.195730] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   10.202313] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   10.208961] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   10.213009] [drm:intel_dp_detect], DPCD: 0000000000000000
[   10.213015] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:DP-1] disconnected
[   10.213043] [drm:drm_mode_getconnector], [CONNECTOR:18:?]
[   10.213044] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:HDMI-A-2]
[   10.219663] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
[   10.219669] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[   10.219672] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:HDMI-A-2] disconnected
[   10.219680] [drm:drm_mode_getconnector], [CONNECTOR:18:?]
[   10.219690] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:HDMI-A-2]
[   10.226312] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
[   10.226318] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[   10.226321] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:HDMI-A-2] disconnected
[   10.226339] [drm:drm_mode_getconnector], [CONNECTOR:20:?]
[   10.226341] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:HDMI-A-3]
[   10.352636] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   10.352639] Raw EDID:
[   10.352641]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   10.352643]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.352645]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.352646]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.352647]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.352649]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.352650]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.352652]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.468955] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   10.468958] Raw EDID:
[   10.468960]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   10.468961]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.468963]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.468964]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.468966]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.468976]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.468976]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.468977]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.581965] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   10.581968] Raw EDID:
[   10.581970]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   10.581971]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.581973]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.581974]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.581976]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.581977]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.581979]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.581989]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.694975] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   10.694978] Raw EDID:
[   10.694980]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   10.694981]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.694983]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.694984]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.694986]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.694987]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.694997]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.694997]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.695000] i915 0000:00:02.0: HDMI-A-3: EDID block 0 invalid.
[   10.695001] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:HDMI-A-3] disconnected
[   10.695009] [drm:drm_mode_getconnector], [CONNECTOR:20:?]
[   10.695010] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:HDMI-A-3]
[   10.821282] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   10.821285] Raw EDID:
[   10.821287]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   10.821288]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.821290]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.821291]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.821293]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.821294]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.821304]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.821305]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.934291] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   10.934294] Raw EDID:
[   10.934296]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   10.934298]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.934299]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.934301]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.934302]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.934304]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.934305]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   10.934315]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.047306] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   11.047309] Raw EDID:
[   11.047311]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   11.047312]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.047314]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.047315]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.047317]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.047318]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.047319]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.047329]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.160313] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   11.160316] Raw EDID:
[   11.160318]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   11.160320]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.160321]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.160323]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.160324]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.160325]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.160335]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.160336]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.160337] i915 0000:00:02.0: HDMI-A-3: EDID block 0 invalid.
[   11.160339] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:HDMI-A-3] disconnected
[   11.160349] [drm:drm_mode_getconnector], [CONNECTOR:21:?]
[   11.160350] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-2]
[   11.162955] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   11.169561] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   11.176209] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   11.180250] [drm:intel_dp_detect], DPCD: 0000000000000000
[   11.180256] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-2] disconnected
[   11.180279] [drm:drm_mode_getconnector], [CONNECTOR:21:?]
[   11.180281] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-2]
[   11.182877] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   11.189506] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   11.196152] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   11.200192] [drm:intel_dp_detect], DPCD: 0000000000000000
[   11.200198] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-2] disconnected
[   11.200225] [drm:drm_mode_getconnector], [CONNECTOR:23:?]
[   11.200226] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-3]
[   11.202836] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   11.209448] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   11.216094] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   11.220135] [drm:intel_dp_detect], DPCD: 0000000000000000
[   11.220141] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-3] disconnected
[   11.220163] [drm:drm_mode_getconnector], [CONNECTOR:23:?]
[   11.220165] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-3]
[   11.222763] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   11.229390] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   11.236037] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   11.240079] [drm:intel_dp_detect], DPCD: 0000000000000000
[   11.240085] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-3] disconnected
[   11.249339] ksplashx[1645]: segfault at b7200fc4 ip 08056cac sp bff54f00 error 4 in ksplashx[8048000+1c000]
[   11.758474] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   11.764523] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   11.771172] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   11.775190] [drm:intel_dp_detect], DPCD: 0000000000000000
[   11.777836] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   11.784446] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   11.791091] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   11.795131] [drm:intel_dp_detect], DPCD: 0000000000000000
[   11.797762] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   11.804388] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   11.811036] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   11.815085] [drm:intel_dp_detect], DPCD: 0000000000000000
[   11.815539] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpb
[   11.821739] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
[   11.821742] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[   11.902921] [drm:i915_driver_open], 
[   11.954696] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   11.954699] Raw EDID:
[   11.954702]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   11.954703]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.954705]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.954706]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.954708]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.954709]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.954711]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   11.954712]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.067717] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   12.067720] Raw EDID:
[   12.067722]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   12.067724]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.067725]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.067727]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.067728]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.067729]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.067731]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.067732]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.180731] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   12.180734] Raw EDID:
[   12.180736]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   12.180737]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.180739]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.180740]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.180742]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.180743]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.180745]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.180746]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.293738] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   12.293741] Raw EDID:
[   12.293743]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   12.293745]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.293746]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.293748]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.293749]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.293750]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.293752]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.293753]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.293765] i915 0000:00:02.0: HDMI-A-3: EDID block 0 invalid.
[   12.293808] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40010, result 0
[   12.293810] [drm:intel_crt_detect], CRT not detected via hotplug
[   12.294224] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpb
[   12.294225] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[   12.296671] [drm:i915_driver_open], 
[   12.311210] [drm:drm_mode_getconnector], [CONNECTOR:9:?]
[   12.311214] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1]
[   12.311220] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40010, result 0
[   12.311221] [drm:intel_crt_detect], CRT not detected via hotplug
[   12.311640] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpb
[   12.311642] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[   12.311643] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1] disconnected
[   12.311646] [drm:drm_mode_getconnector], [CONNECTOR:9:?]
[   12.311647] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1]
[   12.311651] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40010, result 0
[   12.311652] [drm:intel_crt_detect], CRT not detected via hotplug
[   12.312061] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpb
[   12.312061] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[   12.312062] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1] disconnected
[   12.312067] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[   12.312068] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:HDMI-A-1]
[   12.312482] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpb
[   12.312483] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:HDMI-A-1] disconnected
[   12.312485] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[   12.312486] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:HDMI-A-1]
[   12.312903] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpb
[   12.312904] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:HDMI-A-1] disconnected
[   12.312907] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
[   12.312908] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:DP-1]
[   12.315505] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   12.322939] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   12.329570] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   12.333603] [drm:intel_dp_detect], DPCD: 0000000000000000
[   12.333607] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:DP-1] disconnected
[   12.333616] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
[   12.333618] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:DP-1]
[   12.336219] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   12.346161] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   12.352574] EXT4-fs (sda4): re-mounted. Opts: acl,user_xattr,commit=0
[   12.352787] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   12.355139] EXT4-fs (sda2): re-mounted. Opts: acl,user_xattr,commit=0
[   12.356870] [drm:intel_dp_detect], DPCD: 0000000000000000
[   12.356874] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:DP-1] disconnected
[   12.356893] [drm:drm_mode_getconnector], [CONNECTOR:18:?]
[   12.356895] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:HDMI-A-2]
[   12.363516] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
[   12.363519] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[   12.363520] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:HDMI-A-2] disconnected
[   12.363524] [drm:drm_mode_getconnector], [CONNECTOR:18:?]
[   12.363526] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:HDMI-A-2]
[   12.370170] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
[   12.370173] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[   12.370174] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:HDMI-A-2] disconnected
[   12.370182] [drm:drm_mode_getconnector], [CONNECTOR:20:?]
[   12.370183] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:HDMI-A-3]
[   12.496490] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   12.496493] Raw EDID:
[   12.496496]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   12.496497]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.496499]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.496500]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.496502]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.496503]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.496505]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.496506]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.616149] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   12.616153] Raw EDID:
[   12.616155]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   12.616157]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.616158]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.616159]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.616161]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.616162]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.616164]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.616174]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.729159] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   12.729162] Raw EDID:
[   12.729164]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   12.729165]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.729167]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.729168]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.729170]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.729171]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.729173]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.729174]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.842172] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   12.842175] Raw EDID:
[   12.842177]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   12.842178]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.842180]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.842181]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.842183]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.842184]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.842186]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.842196]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.842198] i915 0000:00:02.0: HDMI-A-3: EDID block 0 invalid.
[   12.842201] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:HDMI-A-3] disconnected
[   12.842214] [drm:drm_mode_getconnector], [CONNECTOR:20:?]
[   12.842216] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:HDMI-A-3]
[   12.968478] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   12.968481] Raw EDID:
[   12.968483]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   12.968485]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.968486]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.968488]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.968489]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.968491]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.968492]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   12.968502]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.081488] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   13.081491] Raw EDID:
[   13.081493]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   13.081494]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.081496]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.081497]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.081499]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.081500]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.081502]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.081511]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.194500] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   13.194503] Raw EDID:
[   13.194505]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   13.194507]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.194508]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.194510]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.194511]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.194513]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.194514]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.194524]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.307509] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   13.307512] Raw EDID:
[   13.307514]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   13.307516]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.307517]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.307519]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.307520]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.307522]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.307523]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.307533]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.307535] i915 0000:00:02.0: HDMI-A-3: EDID block 0 invalid.
[   13.307536] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:HDMI-A-3] disconnected
[   13.307550] [drm:drm_mode_getconnector], [CONNECTOR:21:?]
[   13.307552] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-2]
[   13.310155] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   13.316761] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   13.323405] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   13.327447] [drm:intel_dp_detect], DPCD: 0000000000000000
[   13.327453] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-2] disconnected
[   13.327470] [drm:drm_mode_getconnector], [CONNECTOR:21:?]
[   13.327482] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-2]
[   13.330079] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   13.336704] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   13.343352] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   13.347389] [drm:intel_dp_detect], DPCD: 0000000000000000
[   13.347395] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-2] disconnected
[   13.347425] [drm:drm_mode_getconnector], [CONNECTOR:23:?]
[   13.347427] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-3]
[   13.350037] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   13.356647] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   13.363295] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   13.367330] [drm:intel_dp_detect], DPCD: 0000000000000000
[   13.367337] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-3] disconnected
[   13.367354] [drm:drm_mode_getconnector], [CONNECTOR:23:?]
[   13.367357] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-3]
[   13.369963] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   13.376569] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   13.383219] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   13.387274] [drm:intel_dp_detect], DPCD: 0000000000000000
[   13.387281] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-3] disconnected
[   13.387333] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40010, result 0
[   13.387335] [drm:intel_crt_detect], CRT not detected via hotplug
[   13.387757] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpb
[   13.387759] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[   13.387760] [drm:output_poll_execute], [CONNECTOR:9:VGA-1] status updated from 2 to 2
[   13.388177] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpb
[   13.388178] [drm:output_poll_execute], [CONNECTOR:12:HDMI-A-1] status updated from 2 to 2
[   13.390782] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   13.399830] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   13.406483] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   13.410522] [drm:intel_dp_detect], DPCD: 0000000000000000
[   13.410525] [drm:output_poll_execute], [CONNECTOR:15:DP-1] status updated from 2 to 2
[   13.417170] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
[   13.417173] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[   13.417174] [drm:output_poll_execute], [CONNECTOR:18:HDMI-A-2] status updated from 2 to 2
[   13.546801] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   13.546803] Raw EDID:
[   13.546804]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   13.546805]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.546806]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.546807]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.546807]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.546808]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.546809]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.546809]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.659821] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   13.659823] Raw EDID:
[   13.659825]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   13.659825]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.659826]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.659827]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.659827]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.659828]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.659829]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.659829]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.772831] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   13.772833] Raw EDID:
[   13.772835]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   13.772835]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.772836]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.772837]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.772837]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.772838]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.772839]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.772839]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.889154] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   13.889156] Raw EDID:
[   13.889158]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   13.889159]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.889159]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.889160]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.889161]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.889161]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.889162]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.889163]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   13.889165] i915 0000:00:02.0: HDMI-A-3: EDID block 0 invalid.
[   13.889167] [drm:output_poll_execute], [CONNECTOR:20:HDMI-A-3] status updated from 2 to 2
[   13.891780] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   13.898407] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   13.905054] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   13.909101] [drm:intel_dp_detect], DPCD: 0000000000000000
[   13.909104] [drm:output_poll_execute], [CONNECTOR:21:DP-2] status updated from 2 to 2
[   13.911705] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   13.918351] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   13.924997] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   13.929042] [drm:intel_dp_detect], DPCD: 0000000000000000
[   13.929045] [drm:output_poll_execute], [CONNECTOR:23:DP-3] status updated from 2 to 2
[   14.432762] [drm:drm_mode_getconnector], [CONNECTOR:9:?]
[   14.432766] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1]
[   14.432772] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40010, result 0
[   14.432773] [drm:intel_crt_detect], CRT not detected via hotplug
[   14.433191] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpb
[   14.433192] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[   14.433194] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1] disconnected
[   14.433196] [drm:drm_mode_getconnector], [CONNECTOR:9:?]
[   14.433197] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1]
[   14.433202] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40010, result 0
[   14.433203] [drm:intel_crt_detect], CRT not detected via hotplug
[   14.433625] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpb
[   14.433626] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[   14.433627] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:9:VGA-1] disconnected
[   14.433632] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[   14.433633] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:HDMI-A-1]
[   14.433999] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpb
[   14.434000] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:HDMI-A-1] disconnected
[   14.434002] [drm:drm_mode_getconnector], [CONNECTOR:12:?]
[   14.434003] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:HDMI-A-1]
[   14.434375] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpb
[   14.434376] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:12:HDMI-A-1] disconnected
[   14.434379] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
[   14.434381] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:DP-1]
[   14.436983] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   14.443516] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   14.450160] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   14.454202] [drm:intel_dp_detect], DPCD: 0000000000000000
[   14.454206] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:DP-1] disconnected
[   14.454218] [drm:drm_mode_getconnector], [CONNECTOR:15:?]
[   14.454220] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:DP-1]
[   14.456826] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   14.463454] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   14.470104] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   14.474148] [drm:intel_dp_detect], DPCD: 0000000000000000
[   14.474152] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:15:DP-1] disconnected
[   14.474169] [drm:drm_mode_getconnector], [CONNECTOR:18:?]
[   14.474171] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:HDMI-A-2]
[   14.480802] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
[   14.480805] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[   14.480807] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:HDMI-A-2] disconnected
[   14.480811] [drm:drm_mode_getconnector], [CONNECTOR:18:?]
[   14.480812] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:HDMI-A-2]
[   14.487454] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
[   14.487457] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[   14.487459] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:18:HDMI-A-2] disconnected
[   14.487467] [drm:drm_mode_getconnector], [CONNECTOR:20:?]
[   14.487468] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:HDMI-A-3]
[   14.613778] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   14.613781] Raw EDID:
[   14.613784]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   14.613786]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   14.613787]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   14.613788]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   14.613799]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   14.613799]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   14.613800]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   14.613801]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   14.726784] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   14.726787] Raw EDID:
[   14.726789]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   14.726790]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   14.726792]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   14.726793]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   14.726795]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   14.726796]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   14.726797]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   14.726799]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   14.839794] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   14.839797] Raw EDID:
[   14.839799]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   14.839801]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   14.839802]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   14.839804]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   14.839805]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   14.839807]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   14.839808]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   14.839810]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   14.952806] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   14.952809] Raw EDID:
[   14.952811]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   14.952813]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   14.952814]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   14.952816]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   14.952817]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   14.952818]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   14.952820]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   14.952821]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   14.952833] i915 0000:00:02.0: HDMI-A-3: EDID block 0 invalid.
[   14.952836] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:HDMI-A-3] disconnected
[   14.952849] [drm:drm_mode_getconnector], [CONNECTOR:20:?]
[   14.952851] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:HDMI-A-3]
[   15.079115] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   15.079118] Raw EDID:
[   15.079120]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   15.079121]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   15.079123]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   15.079124]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   15.079125]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   15.079127]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   15.079137]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   15.079137]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   15.192125] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   15.192128] Raw EDID:
[   15.192130]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   15.192131]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   15.192133]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   15.192134]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   15.192135]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   15.192145]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   15.192146]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   15.192147]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   15.305135] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   15.305138] Raw EDID:
[   15.305140]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   15.305142]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   15.305143]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   15.305145]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   15.305146]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   15.305148]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   15.305157]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   15.305158]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   15.418146] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   15.418149] Raw EDID:
[   15.418151]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   15.418152]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   15.418154]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   15.418155]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   15.418156]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   15.418158]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   15.418167]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   15.418168]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   15.418170] i915 0000:00:02.0: HDMI-A-3: EDID block 0 invalid.
[   15.418171] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:20:HDMI-A-3] disconnected
[   15.418185] [drm:drm_mode_getconnector], [CONNECTOR:21:?]
[   15.418187] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-2]
[   15.420795] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   15.427394] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   15.434047] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   15.438082] [drm:intel_dp_detect], DPCD: 0000000000000000
[   15.438088] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-2] disconnected
[   15.438111] [drm:drm_mode_getconnector], [CONNECTOR:21:?]
[   15.438112] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-2]
[   15.440714] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   15.447322] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   15.457312] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   15.461358] [drm:intel_dp_detect], DPCD: 0000000000000000
[   15.461365] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:21:DP-2] disconnected
[   15.461388] [drm:drm_mode_getconnector], [CONNECTOR:23:?]
[   15.461390] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-3]
[   15.463995] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   15.470607] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   15.477254] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   15.481293] [drm:intel_dp_detect], DPCD: 0000000000000000
[   15.481299] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-3] disconnected
[   15.481321] [drm:drm_mode_getconnector], [CONNECTOR:23:?]
[   15.481322] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-3]
[   15.483924] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   15.490548] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   15.497194] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   15.501238] [drm:intel_dp_detect], DPCD: 0000000000000000
[   15.501244] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:23:DP-3] disconnected
[   22.836946] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40010, result 0
[   22.836952] [drm:intel_crt_detect], CRT not detected via hotplug
[   22.837386] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpb
[   22.837388] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[   22.837389] [drm:output_poll_execute], [CONNECTOR:9:VGA-1] status updated from 2 to 2
[   22.837809] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpb
[   22.837810] [drm:output_poll_execute], [CONNECTOR:12:HDMI-A-1] status updated from 2 to 2
[   22.840420] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   22.849510] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   22.856150] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   22.860202] [drm:intel_dp_detect], DPCD: 0000000000000000
[   22.860208] [drm:output_poll_execute], [CONNECTOR:15:DP-1] status updated from 2 to 2
[   22.866856] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
[   22.866862] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[   22.866865] [drm:output_poll_execute], [CONNECTOR:18:HDMI-A-2] status updated from 2 to 2
[   22.993159] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   22.993162] Raw EDID:
[   22.993164]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   22.993166]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   22.993167]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   22.993169]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   22.993170]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   22.993172]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   22.993173]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   22.993174]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.106175] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   23.106178] Raw EDID:
[   23.106180]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   23.106181]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.106183]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.106184]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.106186]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.106187]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.106189]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.106190]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.219187] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   23.219190] Raw EDID:
[   23.219192]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   23.219194]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.219195]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.219197]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.219198]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.219200]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.219201]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.219203]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.332184] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[   23.332187] Raw EDID:
[   23.332189]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[   23.332191]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.332192]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.332194]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.332195]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.332197]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.332198]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.332200]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[   23.332212] i915 0000:00:02.0: HDMI-A-3: EDID block 0 invalid.
[   23.332213] [drm:output_poll_execute], [CONNECTOR:20:HDMI-A-3] status updated from 2 to 2
[   23.334820] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   23.341444] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   23.348090] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   23.352134] [drm:intel_dp_detect], DPCD: 0000000000000000
[   23.352139] [drm:output_poll_execute], [CONNECTOR:21:DP-2] status updated from 2 to 2
[   23.354739] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   23.361387] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   23.368035] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[   23.372075] [drm:intel_dp_detect], DPCD: 0000000000000000
[   23.372081] [drm:output_poll_execute], [CONNECTOR:23:DP-3] status updated from 2 to 2
[  258.638359] [drm:i915_driver_open], 
[  258.739781] [drm:i915_driver_open], 
[  293.188284] [drm:i915_hotplug_work_func], running encoder hotplug functions
[  293.188300] [drm:intel_ironlake_crt_detect_hotplug], ironlake hotplug adpa=0xf40010, result 0
[  293.188303] [drm:intel_crt_detect], CRT not detected via hotplug
[  293.188731] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpb
[  293.188732] [drm:intel_crt_detect_ddc], CRT not detected via DDC:0x50 [no valid EDID found]
[  293.188734] [drm:output_poll_execute], [CONNECTOR:9:VGA-1] status updated from 2 to 2
[  293.189153] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpb
[  293.189155] [drm:output_poll_execute], [CONNECTOR:12:HDMI-A-1] status updated from 2 to 2
[  293.191753] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[  293.203656] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[  293.210304] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[  293.214347] [drm:intel_dp_detect], DPCD: 0000000000000000
[  293.214350] [drm:output_poll_execute], [CONNECTOR:15:DP-1] status updated from 2 to 2
[  293.224323] [drm:gmbus_xfer], GMBUS [i915 gmbus dpc] NAK for addr: 0050 r(1)
[  293.224328] [drm:drm_do_probe_ddc_edid], drm: skipping non-existent adapter i915 gmbus dpc
[  293.224331] [drm:output_poll_execute], [CONNECTOR:18:HDMI-A-2] status updated from 2 to 2
[  293.353958] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[  293.353961] Raw EDID:
[  293.353963]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[  293.353965]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  293.353966]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  293.353968]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  293.353969]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  293.353971]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  293.353972]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  293.353974]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  293.480271] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[  293.480274] Raw EDID:
[  293.480276]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[  293.480278]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  293.480279]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  293.480281]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  293.480282]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  293.480284]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  293.480285]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  293.480287]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  293.596613] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[  293.596616] Raw EDID:
[  293.596618]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[  293.596619]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  293.596621]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  293.596622]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  293.596624]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  293.596625]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  293.596627]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  293.596636]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  293.712929] [drm:drm_edid_block_valid] *ERROR* EDID checksum is invalid, remainder is 130
[  293.712930] Raw EDID:
[  293.712931]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[  293.712932]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  293.712932]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  293.712933]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  293.712934]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  293.712934]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  293.712935]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  293.712936]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[  293.712938] i915 0000:00:02.0: HDMI-A-3: EDID block 0 invalid.
[  293.712939] [drm:output_poll_execute], [CONNECTOR:20:HDMI-A-3] status updated from 2 to 2
[  293.715544] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[  293.722170] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[  293.728818] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[  293.732877] [drm:intel_dp_detect], DPCD: 0000000000000000
[  293.732883] [drm:output_poll_execute], [CONNECTOR:21:DP-2] status updated from 2 to 2
[  293.735486] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[  293.742132] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[  293.748779] [drm:intel_dp_aux_ch], dp_aux_ch timeout status 0x5145003f
[  293.752812] [drm:intel_dp_detect], DPCD: 0000000000000000
[  293.752818] [drm:output_poll_execute], [CONNECTOR:23:DP-3] status updated from 2 to 2

--------------030508060007060309000900--
