Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715Ab1JKILx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 04:11:53 -0400
Received: from ezo.ezono.com ([50.22.105.208]:55014 "EHLO ezo.ezono.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750872Ab1JKILv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 04:11:51 -0400
Message-ID: <4E93FA3D.2030400@ezono.com>
Date: Tue, 11 Oct 2011 10:11:41 +0200
From: Abdelghani Ouchabane <abdelghani@ezono.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: PCIe can not rescan for new PCIe device ( FPGA board )
References: <4E8EA746.6030103@ezono.com> <CAErSpo6YEp2v9xzVJHsu5WSJDqb+sWZUfS-e7UmGEXENRiWmnQ@mail.gmail.com> <4E8F2758.3040408@ezono.com> <CAErSpo6Lo2bXw=yjscQ6zzRMnpMZ-cUzbBxN3dDS1D3M67sQ8g@mail.gmail.com> <4E939E5D.3010208@jp.fujitsu.com>
In-Reply-To: <4E939E5D.3010208@jp.fujitsu.com>
Content-Type: multipart/mixed;
 boundary="------------090703020608090803090508"
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - ezo.ezono.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - ezono.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090703020608090803090508
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable


>>> After I plug my board in,  I executed  echo 1>  /sys/bus/pci/rescan
>>
>>
>
> Can you try echo 1 > /sys/bus/pci/slots/XXX/power?
> (XXX: slot number)
Hallo Kenji,

     I am still having the same problem after executing "echo 1 >=20
/sys/bus/pci/slots/0000\:02\:00.0/power"

>
>> It seems like a pciehp bug that you have to rescan explicitly.  But
>> I'm not a pciehp expert and I haven't looked at the code.
>
> The pciehp automatically scans the bus on presence changed event
> (e.g. board is pluged in) if the hot-plug controller supports
> surprise removal. Otherwise, you need to power on slot explicitly
> by "echo 1 > /sys/bus/pci/slots/XXX/power". So one possibility is
> that your controller doesn't support surprise removal. We can
> check it by looking at the pciehp's debug output. Can you send
> whole dmesg output?

I attached to you the whole dmesg log.

Cheers,
Ghani



--------------090703020608090803090508
Content-Type: text/plain;
 name="dmesg-full.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="dmesg-full.txt"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.40.3-0.119.delos.i686 (root@ash) (gcc ve=
rsion 4.6.0 20110603 (Red Hat 4.6.0-10) (GCC) ) #1 PREEMPT Fri Sep 30 15:=
59:08 CEST 2011
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
[    0.000000]  BIOS-e820: 000000000009ec00 - 00000000000a0000 (reserved)=

[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)=

[    0.000000]  BIOS-e820: 0000000000100000 - 000000002fb93000 (usable)
[    0.000000]  BIOS-e820: 000000002fb93000 - 000000002fbda000 (ACPI NVS)=

[    0.000000]  BIOS-e820: 000000002fbda000 - 000000002fbe3000 (ACPI data=
)
[    0.000000]  BIOS-e820: 000000002fbe3000 - 000000002fbe6000 (ACPI NVS)=

[    0.000000]  BIOS-e820: 000000002fbe6000 - 000000002fc09000 (reserved)=

[    0.000000]  BIOS-e820: 000000002fc09000 - 000000002fc0a000 (usable)
[    0.000000]  BIOS-e820: 000000002fc0a000 - 000000002fc1a000 (reserved)=

[    0.000000]  BIOS-e820: 000000002fc1a000 - 000000002fc22000 (ACPI NVS)=

[    0.000000]  BIOS-e820: 000000002fc22000 - 000000002fc47000 (reserved)=

[    0.000000]  BIOS-e820: 000000002fc47000 - 000000002fc8a000 (ACPI NVS)=

[    0.000000]  BIOS-e820: 000000002fc8a000 - 000000002ff00000 (usable)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)=

[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)=

[    0.000000]  BIOS-e820: 00000000fec10000 - 00000000fec11000 (reserved)=

[    0.000000]  BIOS-e820: 00000000fed00000 - 00000000fed01000 (reserved)=

[    0.000000]  BIOS-e820: 00000000fed61000 - 00000000fed71000 (reserved)=

[    0.000000]  BIOS-e820: 00000000fed80000 - 00000000fed90000 (reserved)=

[    0.000000]  BIOS-e820: 00000000fef00000 - 0000000100000000 (reserved)=

[    0.000000] e820 remove range: 000000002d800000 - ffffffffffffffff (us=
able)
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled:=
 non-PAE kernel!
[    0.000000] user-defined physical RAM map:
[    0.000000]  user: 0000000000000000 - 000000000009ec00 (usable)
[    0.000000]  user: 000000000009ec00 - 00000000000a0000 (reserved)
[    0.000000]  user: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  user: 0000000000100000 - 000000002d800000 (usable)
[    0.000000]  user: 000000002fb93000 - 000000002fbda000 (ACPI NVS)
[    0.000000]  user: 000000002fbda000 - 000000002fbe3000 (ACPI data)
[    0.000000]  user: 000000002fbe3000 - 000000002fbe6000 (ACPI NVS)
[    0.000000]  user: 000000002fbe6000 - 000000002fc09000 (reserved)
[    0.000000]  user: 000000002fc0a000 - 000000002fc1a000 (reserved)
[    0.000000]  user: 000000002fc1a000 - 000000002fc22000 (ACPI NVS)
[    0.000000]  user: 000000002fc22000 - 000000002fc47000 (reserved)
[    0.000000]  user: 000000002fc47000 - 000000002fc8a000 (ACPI NVS)
[    0.000000]  user: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  user: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  user: 00000000fec10000 - 00000000fec11000 (reserved)
[    0.000000]  user: 00000000fed00000 - 00000000fed01000 (reserved)
[    0.000000]  user: 00000000fed61000 - 00000000fed71000 (reserved)
[    0.000000]  user: 00000000fed80000 - 00000000fed90000 (reserved)
[    0.000000]  user: 00000000fef00000 - 0000000100000000 (reserved)
[    0.000000] DMI 2.7 present.
[    0.000000] DMI:    /conga-BAF, BIOS BBRAR07 05/27/2011
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (us=
able) =3D=3D> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (us=
able)
[    0.000000] last_pfn =3D 0x2d800 max_arch_pfn =3D 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF write-through
[    0.000000]   C0000-CEFFF write-protect
[    0.000000]   CF000-E7FFF uncachable
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask FC0000000 write-back
[    0.000000]   1 base 02FF00000 mask FFFF00000 uncachable
[    0.000000]   2 base 030000000 mask FF0000000 uncachable
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600=
070106
[    0.000000] original variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 1GB, type WB
[    0.000000] reg 1, base: 767MB, range: 1MB, type UC
[    0.000000] reg 2, base: 768MB, range: 256MB, type UC
[    0.000000] total RAM covered: 767M
[    0.000000] Found optimal setting for mtrr clean up
[    0.000000]  gran_size: 64K 	chunk_size: 2M 	num_reg: 3  	lose cover R=
AM: 0G
[    0.000000] New variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 512MB, type WB
[    0.000000] reg 1, base: 512MB, range: 256MB, type WB
[    0.000000] reg 2, base: 767MB, range: 1MB, type UC
[    0.000000] initial memory mapped : 0 - 01000000
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 12288
[    0.000000] init_memory_mapping: 0000000000000000-000000002d800000
[    0.000000]  0000000000 - 0000400000 page 4k
[    0.000000]  0000400000 - 002d800000 page 2M
[    0.000000] kernel direct mapping tables up to 2d800000 @ ffc000-10000=
00
[    0.000000] log_buf_len: 134217728
[    0.000000] early log buf free: 125435(95%)
[    0.000000] RAMDISK: 2cb89000 - 2d7f0000
[    0.000000] ACPI: RSDP 000f0450 00024 (v02 ALASKA)
[    0.000000] ACPI: XSDT 2fbda068 00054 (v01 ALASKA    A M I 01072009 AM=
I  00010013)
[    0.000000] ACPI: FACP 2fbe06f0 000F4 (v04 ALASKA    A M I 01072009 AM=
I  00010013)
[    0.000000] ACPI Warning: Optional field Pm2ControlBlock has zero addr=
ess or length: 0x0000000000000000/0x1 (20110413/tbfadt-560)
[    0.000000] ACPI: DSDT 2fbda150 06599 (v02 ALASKA    A M I 00000000 IN=
TL 20051117)
[    0.000000] ACPI: FACS 2fc21f40 00040
[    0.000000] ACPI: APIC 2fbe07e8 00062 (v03 ALASKA    A M I 01072009 AM=
I  00010013)
[    0.000000] ACPI: MCFG 2fbe0850 0003C (v01 ALASKA    A M I 01072009 MS=
FT 00010013)
[    0.000000] ACPI: HPET 2fbe0890 00038 (v01 ALASKA    A M I 01072009 AM=
I  00000004)
[    0.000000] ACPI: SSDT 2fbe08c8 0030C (v01 AMD    POWERNOW 00000001 AM=
D  00000001)
[    0.000000] ACPI: SSDT 2fbe0bd8 0168E (v02    AMD     ALIB 00000001 MS=
FT 04000000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 728MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 2d800000
[    0.000000]   low ram: 0 - 2d800000
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x0002d800
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009e
[    0.000000]     0: 0x00000100 -> 0x0002d800
[    0.000000] On node 0 totalpages: 186254
[    0.000000] free_area_init_node: node 0, pgdat c09ea460, node_mem_map =
e45d9200
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3950 pages, LIFO batch:0
[    0.000000]   Normal zone: 1424 pages used for memmap
[    0.000000]   Normal zone: 180848 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: HPET id: 0xffffffff base: 0xfed00000
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 000000000=
009f000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 000000000=
00a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 000000000=
00e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 000000000=
0100000
[    0.000000] Allocating PCI resources starting at 2fc8a000 (gap: 2fc8a0=
00:b0376000)
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
[    0.000000] pcpu-alloc: [0] 0=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  To=
tal pages: 184798
[    0.000000] Kernel command line: ro root=3DUUID=3D5f8f0e62-d5dd-461e-b=
2be-75a5caa782d0 rd_NO_LUKS rd_NO_LVM rd_NO_MD rd_NO_DM LANG=3Den_IE SYSF=
ONT=3Dlatarcyrheb-sun16 KEYTABLE=3Duk selinux=3D0 rhgb acpi=3Dforce mem=3D=
728M init=3D/sbin/upstart early_login fastboot debug loglevel=3D8 log_buf=
_len=3D99999999
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 =
bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 by=
tes)
[    0.000000] Initializing CPU#0
[    0.000000] allocated 2981632 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't w=
ant memory cgroups
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 584188k/745472k available (3865k kernel code, 1608=
28k reserved, 2252k data, 520k init, 0k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffcf000 - 0xfffff000   ( 192 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xee000000 - 0xff7fe000   ( 279 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xed800000   ( 728 MB)
[    0.000000]       .init : 0xc09fa000 - 0xc0a7c000   ( 520 kB)
[    0.000000]       .data : 0xc07c64f4 - 0xc09f9800   (2252 kB)
[    0.000000]       .text : 0xc0400000 - 0xc07c64f4   (3865 kB)
[    0.000000] Checking if this processor honours the WP bit even in supe=
rvisor mode...Ok.
[    0.000000] SLUB: Genslabs=3D15, HWalign=3D64, Order=3D0-3, MinObjects=
=3D0, CPUs=3D1, Nodes=3D1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] NR_IRQS:16
[    0.000000] CPU 0 irqstacks, hard=3De3c06000 soft=3De3c08000
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 999.970 MHz processor.
[    0.001006] Calibrating delay loop (skipped), value calculated using t=
imer frequency.. 1999.94 BogoMIPS (lpj=3D999970)
[    0.001281] pid_max: default: 32768 minimum: 301
[    0.002012] Security Framework initialized
[    0.002163] SELinux:  Disabled at boot.
[    0.002433] Mount-cache hash table entries: 512
[    0.002799] Initializing cgroup subsys cpuacct
[    0.002941] Initializing cgroup subsys memory
[    0.003028] Initializing cgroup subsys devices
[    0.003166] Initializing cgroup subsys freezer
[    0.003301] Initializing cgroup subsys net_cls
[    0.003436] Initializing cgroup subsys blkio
[    0.003582] Initializing cgroup subsys perf_event
[    0.003777] mce: CPU supports 6 MCE banks
[    0.004031] CPU: AMD G-T40N Processor stepping 00
[    0.004322] ACPI: Core revision 20110413
[    0.016033] ACPI: setting ELCR to 0200 (from 0cc0)
[    0.016277] ftrace: allocating 22181 entries in 44 pages
[    0.017145] Performance Events: AMD PMU driver.
[    0.017339] ... version:                0
[    0.017471] ... bit width:              48
[    0.018008] ... generic registers:      4
[    0.018140] ... value mask:             0000ffffffffffff
[    0.018275] ... max period:             00007fffffffffff
[    0.018410] ... fixed-purpose events:   0
[    0.018541] ... event mask:             000000000000000f
[    0.019559] NMI watchdog enabled, takes one hw-pmu counter.
[    0.019929] devtmpfs: initialized
[    0.020266] PM: Registering ACPI NVS region at 2fb93000 (290816 bytes)=

[    0.020425] PM: Registering ACPI NVS region at 2fbe3000 (12288 bytes)
[    0.020564] PM: Registering ACPI NVS region at 2fc1a000 (32768 bytes)
[    0.020704] PM: Registering ACPI NVS region at 2fc47000 (274432 bytes)=

[    0.023682] atomic64 test passed for i586+ platform with CX8 and with =
SSE
[    0.023862] Time: 18:45:50  Date: 08/28/11
[    0.024103] NET: Registered protocol family 16
[    0.024562] Extended Config Space enabled on 0 nodes
[    0.024889] ACPI: bus type pci registered
[    0.025171] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe00000=
00-0xefffffff] (base 0xe0000000)
[    0.025400] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E=
820
[    0.025535] PCI: Using MMCONFIG for extended config space
[    0.025668] PCI: Using configuration type 1 for base access
[    0.029064] bio: create slab <bio-0> at 0
[    0.031805] ACPI: EC: Look up EC in DSDT
[    0.035646] ACPI: Executed 2 blocks of module-level executable AML cod=
e
[    0.089742] ACPI: Interpreter enabled
[    0.089884] ACPI: (supports S0 S3 S4 S5)
[    0.090225] ACPI: Using PIC for interrupt routing
[    0.138167] ACPI: Power Resource [FN00] (off)
[    0.139528] ACPI: No dock devices found.
[    0.139662] HEST: Table not found.
[    0.139793] PCI: Using host bridge windows from ACPI; if necessary, us=
e "pci=3Dnocrs" and report a bug
[    0.140588] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.141674] pci_root PNP0A08:00: host bridge window [io  0x0000-0x03af=
]
[    0.141816] pci_root PNP0A08:00: host bridge window [io  0x03e0-0x0cf7=
]
[    0.141954] pci_root PNP0A08:00: host bridge window [io  0x03b0-0x03df=
]
[    0.142000] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff=
]
[    0.142138] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x=
000bffff]
[    0.142361] pci_root PNP0A08:00: host bridge window [mem 0x000c0000-0x=
000dffff]
[    0.142582] pci_root PNP0A08:00: host bridge window [mem 0x40000000-0x=
ffffffff]
[    0.142833] pci 0000:00:00.0: [1022:1510] type 0 class 0x000600
[    0.143071] pci 0000:00:01.0: [1002:9804] type 0 class 0x000300
[    0.143227] pci 0000:00:01.0: reg 10: [mem 0xd0000000-0xdfffffff pref]=

[    0.143375] pci 0000:00:01.0: reg 14: [io  0xf000-0xf0ff]
[    0.143521] pci 0000:00:01.0: reg 18: [mem 0xfeb00000-0xfeb3ffff]
[    0.143717] pci 0000:00:01.0: supports D1 D2
[    0.144007] pci 0000:00:04.0: [1022:1512] type 1 class 0x000604
[    0.144216] pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
[    0.144358] pci 0000:00:04.0: PME# disabled
[    0.144525] pci 0000:00:05.0: [1022:1513] type 1 class 0x000604
[    0.144732] pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
[    0.144873] pci 0000:00:05.0: PME# disabled
[    0.145054] pci 0000:00:11.0: [1002:4390] type 0 class 0x000101
[    0.145217] pci 0000:00:11.0: reg 10: [io  0xf190-0xf197]
[    0.145366] pci 0000:00:11.0: reg 14: [io  0xf180-0xf183]
[    0.145513] pci 0000:00:11.0: reg 18: [io  0xf170-0xf177]
[    0.145662] pci 0000:00:11.0: reg 1c: [io  0xf160-0xf163]
[    0.145810] pci 0000:00:11.0: reg 20: [io  0xf150-0xf15f]
[    0.146002] pci 0000:00:11.0: reg 24: [mem 0xfeb48000-0xfeb483ff]
[    0.146168] pci 0000:00:11.0: set SATA to AHCI mode
[    0.146356] pci 0000:00:12.0: [1002:4397] type 0 class 0x000c03
[    0.146513] pci 0000:00:12.0: reg 10: [mem 0xfeb47000-0xfeb47fff]
[    0.146757] pci 0000:00:12.2: [1002:4396] type 0 class 0x000c03
[    0.146920] pci 0000:00:12.2: reg 10: [mem 0xfeb46000-0xfeb460ff]
[    0.147094] pci 0000:00:12.2: supports D1 D2
[    0.147228] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.147369] pci 0000:00:12.2: PME# disabled
[    0.147535] pci 0000:00:13.0: [1002:4397] type 0 class 0x000c03
[    0.147690] pci 0000:00:13.0: reg 10: [mem 0xfeb45000-0xfeb45fff]
[    0.148027] pci 0000:00:13.2: [1002:4396] type 0 class 0x000c03
[    0.148191] pci 0000:00:13.2: reg 10: [mem 0xfeb44000-0xfeb440ff]
[    0.148425] pci 0000:00:13.2: supports D1 D2
[    0.148558] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.148699] pci 0000:00:13.2: PME# disabled
[    0.148864] pci 0000:00:14.0: [1002:4385] type 0 class 0x000c05
[    0.149104] pci 0000:00:14.1: [1002:439c] type 0 class 0x000101
[    0.149260] pci 0000:00:14.1: reg 10: [io  0xf140-0xf147]
[    0.149408] pci 0000:00:14.1: reg 14: [io  0xf130-0xf133]
[    0.149555] pci 0000:00:14.1: reg 18: [io  0xf120-0xf127]
[    0.149703] pci 0000:00:14.1: reg 1c: [io  0xf110-0xf113]
[    0.149851] pci 0000:00:14.1: reg 20: [io  0xf100-0xf10f]
[    0.150054] pci 0000:00:14.2: [1002:4383] type 0 class 0x000403
[    0.150221] pci 0000:00:14.2: reg 10: [mem 0xfeb40000-0xfeb43fff 64bit=
]
[    0.150440] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.150580] pci 0000:00:14.2: PME# disabled
[    0.150734] pci 0000:00:14.3: [1002:439d] type 0 class 0x000601
[    0.151027] pci 0000:00:14.4: [1002:4384] type 1 class 0x000604
[    0.151241] pci 0000:00:18.0: [1022:1700] type 0 class 0x000600
[    0.151437] pci 0000:00:18.1: [1022:1701] type 0 class 0x000600
[    0.151629] pci 0000:00:18.2: [1022:1702] type 0 class 0x000600
[    0.151823] pci 0000:00:18.3: [1022:1703] type 0 class 0x000600
[    0.152047] pci 0000:00:18.4: [1022:1704] type 0 class 0x000600
[    0.152238] pci 0000:00:18.5: [1022:1718] type 0 class 0x000600
[    0.152429] pci 0000:00:18.6: [1022:1716] type 0 class 0x000600
[    0.152619] pci 0000:00:18.7: [1022:1719] type 0 class 0x000600
[    0.152909] pci 0000:01:00.0: [1814:0781] type 0 class 0x000280
[    0.153016] pci 0000:01:00.0: reg 10: [mem 0xfea00000-0xfea0ffff]
[    0.153263] pci 0000:01:00.0: PME# supported from D0 D3hot
[    0.153403] pci 0000:01:00.0: PME# disabled
[    0.155025] pci 0000:00:04.0: PCI bridge to [bus 01-01]
[    0.155172] pci 0000:00:04.0:   bridge window [io  0xfff000-0x0000] (d=
isabled)
[    0.155396] pci 0000:00:04.0:   bridge window [mem 0xfea00000-0xfeafff=
ff]
[    0.155539] pci 0000:00:04.0:   bridge window [mem 0xfff00000-0x000fff=
ff pref] (disabled)
[    0.155825] pci 0000:00:05.0: PCI bridge to [bus 02-02]
[    0.155962] pci 0000:00:05.0:   bridge window [io  0xfff000-0x0000] (d=
isabled)
[    0.155999] pci 0000:00:05.0:   bridge window [mem 0xfff00000-0x000fff=
ff] (disabled)
[    0.156225] pci 0000:00:05.0:   bridge window [mem 0xfff00000-0x000fff=
ff pref] (disabled)
[    0.156530] pci 0000:00:14.4: PCI bridge to [bus 03-03] (subtractive d=
ecode)
[    0.156670] pci 0000:00:14.4:   bridge window [io  0xf000-0x0000] (dis=
abled)
[    0.157000] pci 0000:00:14.4:   bridge window [mem 0xfff00000-0x000fff=
ff] (disabled)
[    0.157226] pci 0000:00:14.4:   bridge window [mem 0xfff00000-0x000fff=
ff pref] (disabled)
[    0.157449] pci 0000:00:14.4:   bridge window [io  0x0000-0x03af] (sub=
tractive decode)
[    0.157671] pci 0000:00:14.4:   bridge window [io  0x03e0-0x0cf7] (sub=
tractive decode)
[    0.157893] pci 0000:00:14.4:   bridge window [io  0x03b0-0x03df] (sub=
tractive decode)
[    0.157996] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff] (sub=
tractive decode)
[    0.158219] pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bff=
ff] (subtractive decode)
[    0.158443] pci 0000:00:14.4:   bridge window [mem 0x000c0000-0x000dff=
ff] (subtractive decode)
[    0.158667] pci 0000:00:14.4:   bridge window [mem 0x40000000-0xffffff=
ff] (subtractive decode)
[    0.159015] pci_bus 0000:00: on NUMA node 0
[    0.159149] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.159794] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0PC._PRT]
[    0.160334] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE4._PRT]
[    0.160581] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE5._PRT]
[    0.160841]  pci0000:00: Unable to request _OSC control (_OSC support =
mask: 0x0f)
[    0.176540] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 6 7 10 *11 12 14=
 15)
[    0.177179] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 6 *7 10 11 12 14=
 15)
[    0.177869] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 6 7 *10 11 12 14=
 15)
[    0.178637] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *6 7 10 11 12 14=
 15)
[    0.179331] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 6 7 10 11 12 14 =
15) *0
[    0.180024] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 6 7 10 11 12 14 =
15) *0
[    0.180682] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 6 7 10 11 12 14 =
15) *0
[    0.181329] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 6 7 10 11 12 14 =
15) *0
[    0.182128] vgaarb: device added: PCI:0000:00:01.0,decodes=3Dio+mem,ow=
ns=3Dio+mem,locks=3Dnone
[    0.182381] vgaarb: loaded
[    0.182510] vgaarb: bridge control possible 0000:00:01.0
[    0.182884] SCSI subsystem initialized
[    0.183127] libata version 3.00 loaded.
[    0.183406] usbcore: registered new interface driver usbfs
[    0.183586] usbcore: registered new interface driver hub
[    0.183796] usbcore: registered new device driver usb
[    0.184165] PCI: Using ACPI for IRQ routing
[    0.195932] PCI: pci_cache_line_size set to 64 bytes
[    0.196143] reserve RAM buffer: 000000000009ec00 - 000000000009ffff=20
[    0.196199] reserve RAM buffer: 000000002d800000 - 000000002fffffff=20
[    0.196618] NetLabel: Initializing
[    0.196870] NetLabel:  domain hash size =3D 128
[    0.196991] NetLabel:  protocols =3D UNLABELED CIPSOv4
[    0.197153] NetLabel:  unlabeled traffic allowed by default
[    0.197301] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.197571] hpet0: 3 comparators, 32-bit 14.318180 MHz counter
[    0.199018] Switching to clocksource hpet
[    0.200930] Switched to NOHz mode on CPU #0
[    0.218344] pnp: PnP ACPI init
[    0.218528] ACPI: bus type pnp registered
[    0.219231] pnp 00:00: [bus 00-ff]
[    0.219366] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.219502] pnp 00:00: [io  0x0000-0x03af window]
[    0.219638] pnp 00:00: [io  0x03e0-0x0cf7 window]
[    0.219774] pnp 00:00: [io  0x03b0-0x03df window]
[    0.219909] pnp 00:00: [io  0x0d00-0xffff window]
[    0.220074] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.223311] pnp 00:00: [mem 0x000c0000-0x000dffff window]
[    0.223446] pnp 00:00: [mem 0x40000000-0xffffffff window]
[    0.223581] pnp 00:00: [mem 0x00000000 window]
[    0.223842] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 =
(active)
[    0.224201] pnp 00:01: [mem 0xe0000000-0xefffffff]
[    0.224460] system 00:01: [mem 0xe0000000-0xefffffff] has been reserve=
d
[    0.224604] system 00:01: Plug and Play ACPI device, IDs PNP0c01 (acti=
ve)
[    0.225467] pnp 00:02: [io  0x040b]
[    0.225599] pnp 00:02: [io  0x04d6]
[    0.225728] pnp 00:02: [io  0x0c00-0x0c01]
[    0.225857] pnp 00:02: [io  0x0c14]
[    0.225985] pnp 00:02: [io  0x0c50-0x0c51]
[    0.226142] pnp 00:02: [io  0x0c52]
[    0.226273] pnp 00:02: [io  0x0c6c]
[    0.226404] pnp 00:02: [io  0x0c6f]
[    0.226536] pnp 00:02: [io  0x0cd0-0x0cd1]
[    0.226670] pnp 00:02: [io  0x0cd2-0x0cd3]
[    0.226808] pnp 00:02: [io  0x0cd4-0x0cd5]
[    0.226941] pnp 00:02: [io  0x0cd6-0x0cd7]
[    0.227099] pnp 00:02: [io  0x0cd8-0x0cdf]
[    0.227231] pnp 00:02: [io  0x0800-0x089f]
[    0.227365] pnp 00:02: [io  0x0000-0xffffffff disabled]
[    0.227501] pnp 00:02: [io  0x0000-0x000f]
[    0.227633] pnp 00:02: [io  0x0b20-0x0b3f]
[    0.227767] pnp 00:02: [io  0x0900-0x090f]
[    0.227900] pnp 00:02: [io  0x0910-0x091f]
[    0.228056] pnp 00:02: [io  0xfe00-0xfefe]
[    0.228190] pnp 00:02: [io  0x0060-0x005f disabled]
[    0.228326] pnp 00:02: [io  0x0064-0x0063 disabled]
[    0.228461] pnp 00:02: [mem 0xfec00000-0xfec00fff]
[    0.228597] pnp 00:02: [mem 0xfee00000-0xfee00fff]
[    0.228734] pnp 00:02: [mem 0xfed80000-0xfed8ffff]
[    0.228869] pnp 00:02: [mem 0xfed61000-0xfed70fff]
[    0.229028] pnp 00:02: [mem 0xfec10000-0xfec10fff]
[    0.229163] pnp 00:02: [mem 0xfed00000-0xfed00fff]
[    0.229298] pnp 00:02: [mem 0xffc00000-0xffffffff]
[    0.229587] system 00:02: [io  0x040b] has been reserved
[    0.229728] system 00:02: [io  0x04d6] has been reserved
[    0.229866] system 00:02: [io  0x0c00-0x0c01] has been reserved
[    0.230032] system 00:02: [io  0x0c14] has been reserved
[    0.230170] system 00:02: [io  0x0c50-0x0c51] has been reserved
[    0.230309] system 00:02: [io  0x0c52] has been reserved
[    0.230447] system 00:02: [io  0x0c6c] has been reserved
[    0.230584] system 00:02: [io  0x0c6f] has been reserved
[    0.230721] system 00:02: [io  0x0cd0-0x0cd1] has been reserved
[    0.230860] system 00:02: [io  0x0cd2-0x0cd3] has been reserved
[    0.230999] system 00:02: [io  0x0cd4-0x0cd5] has been reserved
[    0.231161] system 00:02: [io  0x0cd6-0x0cd7] has been reserved
[    0.231300] system 00:02: [io  0x0cd8-0x0cdf] has been reserved
[    0.231439] system 00:02: [io  0x0800-0x089f] has been reserved
[    0.231578] system 00:02: [io  0x0b20-0x0b3f] has been reserved
[    0.231716] system 00:02: [io  0x0900-0x090f] has been reserved
[    0.231856] system 00:02: [io  0x0910-0x091f] has been reserved
[    0.231995] system 00:02: [io  0xfe00-0xfefe] has been reserved
[    0.232160] system 00:02: [mem 0xfec00000-0xfec00fff] has been reserve=
d
[    0.232302] system 00:02: [mem 0xfee00000-0xfee00fff] has been reserve=
d
[    0.232444] system 00:02: [mem 0xfed80000-0xfed8ffff] has been reserve=
d
[    0.232585] system 00:02: [mem 0xfed61000-0xfed70fff] has been reserve=
d
[    0.232726] system 00:02: [mem 0xfec10000-0xfec10fff] has been reserve=
d
[    0.232868] system 00:02: [mem 0xfed00000-0xfed00fff] has been reserve=
d
[    0.233032] system 00:02: [mem 0xffc00000-0xffffffff] has been reserve=
d
[    0.233175] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (acti=
ve)
[    0.233872] pnp 00:03: [io  0x0000-0xffffffff disabled]
[    0.234038] pnp 00:03: [io  0x0a00-0x0a0f]
[    0.234174] pnp 00:03: [io  0x0000-0xffffffff disabled]
[    0.234310] pnp 00:03: [io  0xffff]
[    0.234442] pnp 00:03: [io  0xffff]
[    0.234686] system 00:03: [io  0x0a00-0x0a0f] has been reserved
[    0.234828] system 00:03: [io  0xffff] has been reserved
[    0.234966] system 00:03: [io  0xffff] has been reserved
[    0.235133] system 00:03: Plug and Play ACPI device, IDs PNP0c02 (acti=
ve)
[    0.236060] pnp 00:04: [dma 4]
[    0.236194] pnp 00:04: [io  0x0000-0x000f]
[    0.236327] pnp 00:04: [io  0x0081-0x0083]
[    0.236460] pnp 00:04: [io  0x0087]
[    0.236592] pnp 00:04: [io  0x0089-0x008b]
[    0.236725] pnp 00:04: [io  0x008f]
[    0.236858] pnp 00:04: [io  0x00c0-0x00df]
[    0.237089] pnp 00:04: Plug and Play ACPI device, IDs PNP0200 (active)=

[    0.237261] pnp 00:05: [io  0x0070-0x0071]
[    0.237396] pnp 00:05: [irq 8]
[    0.237593] pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)=

[    0.237756] pnp 00:06: [io  0x0061]
[    0.237961] pnp 00:06: Plug and Play ACPI device, IDs PNP0800 (active)=

[    0.238205] pnp 00:07: [io  0x0010-0x001f]
[    0.238338] pnp 00:07: [io  0x0022-0x003f]
[    0.238468] pnp 00:07: [io  0x0044-0x005f]
[    0.238598] pnp 00:07: [io  0x0072-0x007f]
[    0.238727] pnp 00:07: [io  0x0080]
[    0.238857] pnp 00:07: [io  0x0084-0x0086]
[    0.238986] pnp 00:07: [io  0x0088]
[    0.239142] pnp 00:07: [io  0x008c-0x008e]
[    0.239272] pnp 00:07: [io  0x0090-0x009f]
[    0.239402] pnp 00:07: [io  0x00a2-0x00bf]
[    0.239531] pnp 00:07: [io  0x00e0-0x00ef]
[    0.239661] pnp 00:07: [io  0x04d0-0x04d1]
[    0.239911] system 00:07: [io  0x04d0-0x04d1] has been reserved
[    0.240079] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (acti=
ve)
[    0.240239] pnp 00:08: [io  0x00f0-0x00ff]
[    0.240371] pnp 00:08: [irq 13]
[    0.240571] pnp 00:08: Plug and Play ACPI device, IDs PNP0c04 (active)=

[    0.240850] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (acti=
ve)
[    0.241452] pnp 00:0a: [mem 0x30000000-0x3fffffff]
[    0.241704] system 00:0a: [mem 0x30000000-0x3fffffff] has been reserve=
d
[    0.241845] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (acti=
ve)
[    0.256284] pnp 00:0b: [mem 0xfed00000-0xfed003ff]
[    0.256525] pnp 00:0b: Plug and Play ACPI device, IDs PNP0103 (active)=

[    0.256673] pnp: PnP ACPI: found 12 devices
[    0.256802] ACPI: ACPI bus type pnp unregistered
[    0.296842] PCI: max bus depth: 1 pci_try_num: 2
[    0.297060] pci 0000:00:05.0: BAR 14: assigned [mem 0x40000000-0x401ff=
fff]
[    0.297208] pci 0000:00:05.0: BAR 15: assigned [mem 0x40200000-0x403ff=
fff 64bit pref]
[    0.297445] pci 0000:00:05.0: BAR 13: assigned [io  0x1000-0x1fff]
[    0.297590] pci 0000:00:04.0: BAR 15: assigned [mem 0x40400000-0x405ff=
fff 64bit pref]
[    0.297826] pci 0000:00:04.0: BAR 13: assigned [io  0x2000-0x2fff]
[    0.297967] pci 0000:00:04.0: PCI bridge to [bus 01-01]
[    0.298129] pci 0000:00:04.0:   bridge window [io  0x2000-0x2fff]
[    0.298273] pci 0000:00:04.0:   bridge window [mem 0xfea00000-0xfeafff=
ff]
[    0.298416] pci 0000:00:04.0:   bridge window [mem 0x40400000-0x405fff=
ff 64bit pref]
[    0.298650] pci 0000:00:05.0: PCI bridge to [bus 02-02]
[    0.298787] pci 0000:00:05.0:   bridge window [io  0x1000-0x1fff]
[    0.298928] pci 0000:00:05.0:   bridge window [mem 0x40000000-0x401fff=
ff]
[    0.299095] pci 0000:00:05.0:   bridge window [mem 0x40200000-0x403fff=
ff 64bit pref]
[    0.299329] pci 0000:00:14.4: PCI bridge to [bus 03-03]
[    0.299463] pci 0000:00:14.4:   bridge window [io  disabled]
[    0.299604] pci 0000:00:14.4:   bridge window [mem disabled]
[    0.299745] pci 0000:00:14.4:   bridge window [mem pref disabled]
[    0.300193] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
[    0.300333] PCI: setting IRQ 11 as level-triggered
[    0.300473] pci 0000:00:04.0: PCI INT A -> Link[LNKA] -> GSI 11 (level=
, low) -> IRQ 11
[    0.300708] pci 0000:00:04.0: setting latency timer to 64
[    0.301097] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 7
[    0.301236] PCI: setting IRQ 7 as level-triggered
[    0.301374] pci 0000:00:05.0: PCI INT A -> Link[LNKB] -> GSI 7 (level,=
 low) -> IRQ 7
[    0.301606] pci 0000:00:05.0: setting latency timer to 64
[    0.301755] pci_bus 0000:00: resource 4 [io  0x0000-0x03af]
[    0.301891] pci_bus 0000:00: resource 5 [io  0x03e0-0x0cf7]
[    0.302056] pci_bus 0000:00: resource 6 [io  0x03b0-0x03df]
[    0.302194] pci_bus 0000:00: resource 7 [io  0x0d00-0xffff]
[    0.302332] pci_bus 0000:00: resource 8 [mem 0x000a0000-0x000bffff]
[    0.302471] pci_bus 0000:00: resource 9 [mem 0x000c0000-0x000dffff]
[    0.302609] pci_bus 0000:00: resource 10 [mem 0x40000000-0xffffffff]
[    0.302750] pci_bus 0000:01: resource 0 [io  0x2000-0x2fff]
[    0.302887] pci_bus 0000:01: resource 1 [mem 0xfea00000-0xfeafffff]
[    0.303050] pci_bus 0000:01: resource 2 [mem 0x40400000-0x405fffff 64b=
it pref]
[    0.303280] pci_bus 0000:02: resource 0 [io  0x1000-0x1fff]
[    0.303417] pci_bus 0000:02: resource 1 [mem 0x40000000-0x401fffff]
[    0.303557] pci_bus 0000:02: resource 2 [mem 0x40200000-0x403fffff 64b=
it pref]
[    0.303787] pci_bus 0000:03: resource 4 [io  0x0000-0x03af]
[    0.303923] pci_bus 0000:03: resource 5 [io  0x03e0-0x0cf7]
[    0.304084] pci_bus 0000:03: resource 6 [io  0x03b0-0x03df]
[    0.304222] pci_bus 0000:03: resource 7 [io  0x0d00-0xffff]
[    0.304360] pci_bus 0000:03: resource 8 [mem 0x000a0000-0x000bffff]
[    0.304500] pci_bus 0000:03: resource 9 [mem 0x000c0000-0x000dffff]
[    0.304639] pci_bus 0000:03: resource 10 [mem 0x40000000-0xffffffff]
[    0.304853] NET: Registered protocol family 2
[    0.305094] IP route cache hash table entries: 32768 (order: 5, 131072=
 bytes)
[    0.305512] TCP established hash table entries: 131072 (order: 8, 1048=
576 bytes)
[    0.306773] TCP bind hash table entries: 65536 (order: 6, 262144 bytes=
)
[    0.307243] TCP: Hash tables configured (established 131072 bind 65536=
)
[    0.307383] TCP reno registered
[    0.307516] UDP hash table entries: 512 (order: 1, 8192 bytes)
[    0.307662] UDP-Lite hash table entries: 512 (order: 1, 8192 bytes)
[    0.308057] NET: Registered protocol family 1
[    0.308227] pci 0000:00:01.0: Boot video device
[    0.876145] PCI: CLS 64 bytes, default 64
[    0.876428] Trying to unpack rootfs image as initramfs...
[    1.882691] Freeing initrd memory: 12700k freed
[    1.894871] apm: BIOS not found.
[    1.895288] Intel AES-NI instructions are not detected.
[    1.899046] audit: initializing netlink socket (disabled)
[    1.899208] type=3D2000 audit(1314557151.898:1): initialized
[    1.948207] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    1.959214] VFS: Disk quotas dquot_6.5.2
[    1.959492] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)=

[    1.961284] msgmni has been set to 1165
[    1.962316] alg: No test for stdrng (krng)
[    1.962468] NET: Registered protocol family 38
[    1.962752] Block layer SCSI generic (bsg) driver version 0.4 loaded (=
major 253)
[    1.963085] io scheduler noop registered
[    1.963221] io scheduler deadline registered
[    1.963399] io scheduler cfq registered (default)
[    1.963952] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.971579] ACPI: Deprecated procfs I/F for AC is loaded, please retry=
 with CONFIG_ACPI_PROCFS_POWER cleared
[    1.982035] ACPI: AC Adapter [ADP1] (on-line)
[    1.982395] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0=
C0C:00/input/input0
[    1.982634] ACPI: Power Button [PWRB]
[    1.982931] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/in=
put/input1
[    1.983190] ACPI: Power Button [PWRF]
[    1.987153] ACPI: Fan [FAN0] (off)
[    1.987631] ACPI: acpi_idle registered with cpuidle
[    2.030408] thermal LNXTHERM:00: registered as thermal_zone0
[    2.030552] ACPI: Thermal Zone [TZ00] (65 C)
[    2.031171] thermal LNXTHERM:01: registered as thermal_zone1
[    2.031312] ACPI: Thermal Zone [TZ01] (65 C)
[    2.031546] ERST: Table is not found!
[    2.031715] isapnp: Scanning for PnP cards...
[    2.046109] ACPI: Deprecated procfs I/F for battery is loaded, please =
retry with CONFIG_ACPI_PROCFS_POWER cleared
[    2.046362] ACPI: Battery Slot [BAT1] (battery absent)
[    2.061638] ACPI: Deprecated procfs I/F for battery is loaded, please =
retry with CONFIG_ACPI_PROCFS_POWER cleared
[    2.061886] ACPI: Battery Slot [BAT2] (battery absent)
[    2.410402] isapnp: No Plug & Play device found
[    2.410753] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    2.420076] Non-volatile memory driver v1.3
[    2.420218] Linux agpgart interface v0.103
[    2.424149] brd: module loaded
[    2.425945] loop: module loaded
[    2.426320] ahci 0000:00:11.0: version 3.0
[    2.426736] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 6
[    2.426875] PCI: setting IRQ 6 as level-triggered
[    2.427047] ahci 0000:00:11.0: PCI INT A -> Link[LNKD] -> GSI 6 (level=
, low) -> IRQ 6
[    2.427454] ahci 0000:00:11.0: AHCI 0001.0200 32 slots 4 ports 3 Gbps =
0xf impl SATA mode
[    2.427690] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo p=
mp pio slum part=20
[    2.429588] scsi0 : ahci
[    2.430047] scsi1 : ahci
[    2.430373] scsi2 : ahci
[    2.430667] scsi3 : ahci
[    2.431560] ata1: SATA max UDMA/133 abar m1024@0xfeb48000 port 0xfeb48=
100 irq 6
[    2.431795] ata2: SATA max UDMA/133 abar m1024@0xfeb48000 port 0xfeb48=
180 irq 6
[    2.432051] ata3: SATA max UDMA/133 abar m1024@0xfeb48000 port 0xfeb48=
200 irq 6
[    2.432293] ata4: SATA max UDMA/133 abar m1024@0xfeb48000 port 0xfeb48=
280 irq 6
[    2.432874] Fixed MDIO Bus: probed
[    2.433235] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver=

[    2.433421] ehci_hcd 0000:00:12.2: PCI INT B -> Link[LNKB] -> GSI 7 (l=
evel, low) -> IRQ 7
[    2.433685] ehci_hcd 0000:00:12.2: EHCI Host Controller
[    2.433941] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bu=
s number 1
[    2.434237] ehci_hcd 0000:00:12.2: applying AMD SB700/SB800/Hudson-2/3=
 EHCI dummy qh workaround
[    2.434512] QUIRK: Enable AMD PLL fix
[    2.434661] ehci_hcd 0000:00:12.2: debug port 1
[    2.434823] ehci_hcd 0000:00:12.2: irq 7, io mem 0xfeb46000
[    2.440049] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
[    2.440272] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    2.440410] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
[    2.440631] usb usb1: Product: EHCI Host Controller
[    2.440762] usb usb1: Manufacturer: Linux 2.6.40.3-0.119.delos.i686 eh=
ci_hcd
[    2.440899] usb usb1: SerialNumber: 0000:00:12.2
[    2.441360] hub 1-0:1.0: USB hub found
[    2.441503] hub 1-0:1.0: 5 ports detected
[    2.441824] ehci_hcd 0000:00:13.2: PCI INT B -> Link[LNKB] -> GSI 7 (l=
evel, low) -> IRQ 7
[    2.442104] ehci_hcd 0000:00:13.2: EHCI Host Controller
[    2.442348] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bu=
s number 2
[    2.442585] ehci_hcd 0000:00:13.2: applying AMD SB700/SB800/Hudson-2/3=
 EHCI dummy qh workaround
[    2.442854] ehci_hcd 0000:00:13.2: debug port 1
[    2.443040] ehci_hcd 0000:00:13.2: irq 7, io mem 0xfeb44000
[    2.449053] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
[    2.449253] usb usb2: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    2.449396] usb usb2: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
[    2.449622] usb usb2: Product: EHCI Host Controller
[    2.449756] usb usb2: Manufacturer: Linux 2.6.40.3-0.119.delos.i686 eh=
ci_hcd
[    2.449896] usb usb2: SerialNumber: 0000:00:13.2
[    2.450319] hub 2-0:1.0: USB hub found
[    2.450461] hub 2-0:1.0: 5 ports detected
[    2.450780] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.451272] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 10
[    2.451411] PCI: setting IRQ 10 as level-triggered
[    2.451550] ohci_hcd 0000:00:12.0: PCI INT A -> Link[LNKC] -> GSI 10 (=
level, low) -> IRQ 10
[    2.451802] ohci_hcd 0000:00:12.0: OHCI Host Controller
[    2.452088] ohci_hcd 0000:00:12.0: new USB bus registered, assigned bu=
s number 3
[    2.452354] ohci_hcd 0000:00:12.0: irq 10, io mem 0xfeb47000
[    2.507153] usb usb3: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    2.507296] usb usb3: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
[    2.507524] usb usb3: Product: OHCI Host Controller
[    2.507658] usb usb3: Manufacturer: Linux 2.6.40.3-0.119.delos.i686 oh=
ci_hcd
[    2.507798] usb usb3: SerialNumber: 0000:00:12.0
[    2.508247] hub 3-0:1.0: USB hub found
[    2.508392] hub 3-0:1.0: 5 ports detected
[    2.508698] ohci_hcd 0000:00:13.0: PCI INT A -> Link[LNKC] -> GSI 10 (=
level, low) -> IRQ 10
[    2.508950] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    2.509231] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bu=
s number 4
[    2.509491] ohci_hcd 0000:00:13.0: irq 10, io mem 0xfeb45000
[    2.564122] usb usb4: New USB device found, idVendor=3D1d6b, idProduct=
=3D0001
[    2.564265] usb usb4: New USB device strings: Mfr=3D3, Product=3D2, Se=
rialNumber=3D1
[    2.564492] usb usb4: Product: OHCI Host Controller
[    2.564627] usb usb4: Manufacturer: Linux 2.6.40.3-0.119.delos.i686 oh=
ci_hcd
[    2.564766] usb usb4: SerialNumber: 0000:00:13.0
[    2.565209] hub 4-0:1.0: USB hub found
[    2.565355] hub 4-0:1.0: 5 ports detected
[    2.565664] uhci_hcd: USB Universal Host Controller Interface driver
[    2.565985] usbcore: registered new interface driver usbserial
[    2.566184] USB Serial support registered for generic
[    2.566353] usbcore: registered new interface driver usbserial_generic=

[    2.566494] usbserial: USB Serial Driver core
[    2.566754] i8042: PNP: No PS/2 controller found. Probing ports direct=
ly.
[    2.567897] mousedev: PS/2 mouse device common for all mice
[    2.568449] rtc_cmos 00:05: RTC can wake from S4
[    2.568781] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    2.568950] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet i=
rqs
[    2.569396] device-mapper: uevent: version 1.0.3
[    2.569781] device-mapper: ioctl: 4.20.0-ioctl (2011-02-02) initialise=
d: dm-devel@redhat.com
[    2.570305] cpuidle: using governor ladder
[    2.570546] cpuidle: using governor menu
[    2.571041] EFI Variables Facility v0.08 2004-May-17
[    2.571596] usbcore: registered new interface driver usbhid
[    2.571730] usbhid: USB HID core driver
[    2.572189] ip_tables: (C) 2000-2006 Netfilter Core Team
[    2.572354] TCP cubic registered
[    2.572480] Initializing XFRM netlink socket
[    2.572627] NET: Registered protocol family 17
[    2.572799] Registering the dns_resolver key type
[    2.573240] PM: Hibernation image not present or could not be loaded.
[    2.573412] registered taskstats version 1
[    2.576300] IMA: No TPM chip found, activating TPM-bypass!
[    2.577096]   Magic number: 7:263:798
[    2.577375] rtc_cmos 00:05: setting system clock to 2011-08-28 18:45:5=
3 UTC (1314557153)
[    2.577840] Initializing network drop monitor service
[    2.737065] ata1: SATA link down (SStatus 0 SControl 300)
[    2.740066] ata2: SATA link down (SStatus 0 SControl 300)
[    2.740255] ata4: SATA link down (SStatus 0 SControl 300)
[    2.740432] ata3: SATA link down (SStatus 0 SControl 300)
[    2.740661] Freeing unused kernel memory: 520k freed
[    2.741467] Write protecting the kernel text: 3868k
[    2.741685] Write protecting the kernel read-only data: 1860k
[    2.743093] usb 1-2: new high speed USB device number 2 using ehci_hcd=

[    2.825134] dracut: dracut-009-12.fc15
[    2.853059] dracut: rd.luks=3D0: removing cryptoluks activation
[    2.861697] usb 1-2: New USB device found, idVendor=3D05e3, idProduct=3D=
0608
[    2.861850] usb 1-2: New USB device strings: Mfr=3D0, Product=3D1, Ser=
ialNumber=3D0
[    2.861991] usb 1-2: Product: USB2.0 Hub
[    2.863188] hub 1-2:1.0: USB hub found
[    2.863685] hub 1-2:1.0: 4 ports detected
[    2.871882] udev[90]: starting version 167
[    2.896066] Refined TSC clocksource calibration: 999.999 MHz.
[    2.896226] Switching to clocksource tsc
[    3.018138] [drm] Initialized drm 1.1.0 20060810
[    3.072457] [drm] radeon defaulting to kernel modesetting.
[    3.072608] [drm] radeon kernel modesetting enabled.
[    3.072857] radeon 0000:00:01.0: PCI INT A -> Link[LNKC] -> GSI 10 (le=
vel, low) -> IRQ 10
[    3.073120] radeon 0000:00:01.0: setting latency timer to 64
[    3.073910] [drm] initializing kernel modesetting (PALM 0x1002:0x9804 =
0x1022:0x1511).
[    3.074270] [drm] register mmio base: 0xFEB00000
[    3.074405] [drm] register mmio size: 262144
[    3.074862] ATOM BIOS: AMD
[    3.075080] radeon 0000:00:01.0: VRAM: 256M 0x0000000000000000 - 0x000=
000000FFFFFFF (256M used)
[    3.075315] radeon 0000:00:01.0: GTT: 512M 0x0000000010000000 - 0x0000=
00002FFFFFFF
[    3.075651] [drm] Detected VRAM RAM=3D256M, BAR=3D256M
[    3.075801] [drm] RAM width 32bits DDR
[    3.076141] [TTM] Zone  kernel: Available graphics memory: 298704 kiB.=

[    3.076283] [TTM] Initializing pool allocator.
[    3.076476] [drm] radeon: 256M of VRAM memory ready
[    3.076611] [drm] radeon: 512M of GTT memory ready.
[    3.076786] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010)=
=2E
[    3.076923] [drm] Driver supports precise vblank timestamp query.
[    3.077121] [drm] radeon: irq initialized.
[    3.077261] [drm] GART: num cpu pages 131072, num gpu pages 131072
[    3.080221] [drm] Loading PALM Microcode
[    3.103953] radeon 0000:00:01.0: WB enabled
[    3.120979] [drm] ring test succeeded in 1 usecs
[    3.121425] [drm] radeon: ib pool ready.
[    3.121738] [drm] ib test succeeded in 0 usecs
[    3.121884] failed to evaluate ATIF got AE_BAD_PARAMETER
[    3.128856] [drm] Radeon Display Connectors
[    3.128999] [drm] Connector 0:
[    3.129162] [drm]   LVDS
[    3.129292] [drm]   HPD1
[    3.129424] [drm]   DDC: 0x6430 0x6430 0x6434 0x6434 0x6438 0x6438 0x6=
43c 0x643c
[    3.129650] [drm]   Encoders:
[    3.129780] [drm]     LCD1: INTERNAL_UNIPHY
[    3.129911] [drm]     LCD1: TRAVIS
[    3.130063] [drm] Connector 1:
[    3.130192] [drm]   DisplayPort
[    3.130321] [drm]   HPD2
[    3.130452] [drm]   DDC: 0x6440 0x6440 0x6444 0x6444 0x6448 0x6448 0x6=
44c 0x644c
[    3.130676] [drm]   Encoders:
[    3.130805] [drm]     DFP1: INTERNAL_UNIPHY
[    3.130936] [drm] Connector 2:
[    3.131085] [drm]   VGA
[    3.131215] [drm]   DDC: 0x64d8 0x64d8 0x64dc 0x64dc 0x64e0 0x64e0 0x6=
4e4 0x64e4
[    3.131441] [drm]   Encoders:
[    3.131570] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[    3.253040] usb 4-2: new full speed USB device number 2 using ohci_hcd=

[    3.259054] [drm] Radeon display connector LVDS-1: No monitor connecte=
d or invalid EDID
[    3.387052] [drm] Radeon display connector DP-1: No monitor connected =
or invalid EDID
[    3.398125] [drm] Radeon display connector VGA-1: No monitor connected=
 or invalid EDID
[    3.411183] [drm] Internal thermal controller without fan control
[    3.411647] [drm] radeon: power management initialized
[    3.420100] usb 4-2: New USB device found, idVendor=3D0afa, idProduct=3D=
03e8
[    3.420250] usb 4-2: New USB device strings: Mfr=3D1, Product=3D0, Ser=
ialNumber=3D0
[    3.649064] usb 3-4: new low speed USB device number 2 using ohci_hcd
[    3.804118] usb 3-4: New USB device found, idVendor=3D413c, idProduct=3D=
2003
[    3.804264] usb 3-4: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D0
[    3.804407] usb 3-4: Product: Dell USB Keyboard
[    3.804540] usb 3-4: Manufacturer: Dell
[    3.812813] input: Dell Dell USB Keyboard as /devices/pci0000:00/0000:=
00:12.0/usb3/3-4/3-4:1.0/input/input2
[    3.813355] generic-usb 0003:413C:2003.0001: input,hidraw0: USB HID v1=
=2E10 Keyboard [Dell Dell USB Keyboard] on usb-0000:00:12.0-4/input0
[    3.877448] usb 1-2.1: new high speed USB device number 4 using ehci_h=
cd
[    3.943372] [drm] fb mappable at 0xD0141000
[    3.943508] [drm] vram apper at 0xD0000000
[    3.943641] [drm] size 3145728
[    3.943770] [drm] fb depth is 24
[    3.943900] [drm]    pitch is 4096
[    3.944367] fbcon: radeondrmfb (fb0) is primary device
[    3.956917] usb 1-2.1: New USB device found, idVendor=3D9710, idProduc=
t=3D7830
[    3.956926] usb 1-2.1: New USB device strings: Mfr=3D1, Product=3D2, S=
erialNumber=3D3
[    3.956933] usb 1-2.1: Product: UA0025C             =20
[    3.956939] usb 1-2.1: Manufacturer: Moschip Semiconductor
[    3.956944] usb 1-2.1: SerialNumber: 6e003e8f
[    4.038447] Console: switching to colour frame buffer device 128x48
[    4.049593] fb0: radeondrmfb frame buffer device
[    4.049694] drm: registered panic notifier
[    4.049796] [drm] Initialized radeon 2.10.0 20080528 for 0000:00:01.0 =
on minor 0
[    4.098364] dracut: Starting plymouth daemon
[    4.609975] pata_atiixp 0000:00:14.1: PCI INT B -> Link[LNKB] -> GSI 7=
 (level, low) -> IRQ 7
[    4.625103] scsi4 : pata_atiixp
[    4.627682] scsi5 : pata_atiixp
[    4.627853] ata5: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xf100 i=
rq 14
[    4.627862] ata6: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xf108 i=
rq 15
[    4.812666] ata5.00: CFA: InnoDisk Corp. - EDC4000 H 8GB, 080414, max =
UDMA/66
[    4.812679] ata5.00: 16128000 sectors, multi 2: LBA=20
[    4.812692] ata5.00: limited to UDMA/33 due to 40-wire cable
[    4.815370] ata5.00: configured for UDMA/33
[    4.815672] scsi 4:0:0:0: Direct-Access     ATA      InnoDisk Corp. - =
0804 PQ: 0 ANSI: 5
[    4.816143] sd 4:0:0:0: Attached scsi generic sg0 type 0
[    4.816379] sd 4:0:0:0: [sda] 16128000 512-byte logical blocks: (8.25 =
GB/7.69 GiB)
[    4.816560] sd 4:0:0:0: [sda] Write Protect is off
[    4.816570] sd 4:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.816648] sd 4:0:0:0: [sda] Write cache: disabled, read cache: enabl=
ed, doesn't support DPO or FUA
[    4.819976]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 sda9 >
[    4.821418] sd 4:0:0:0: [sda] Attached SCSI disk
[    5.290607] SGI XFS with ACLs, security attributes, large block/inode =
numbers, no debug enabled
[    5.294504] SGI XFS Quota Management subsystem
[    5.295818] XFS (sda2): Mounting Filesystem
[    6.184147] XFS (sda2): Ending clean mount
[    6.210169] dracut: Remounting /dev/disk/by-uuid/5f8f0e62-d5dd-461e-b2=
be-75a5caa782d0 with -o ro,
[    6.214510] XFS (sda2): Mounting Filesystem
[    6.867419] XFS (sda2): Ending clean mount
[    6.871984] dracut: Mounted root filesystem /dev/sda2
[    6.979478] dracut: Switching root
[    7.604918] udev[312]: starting version 167
[    7.955100] piix4_smbus 0000:00:14.0: SMBus Host Controller at 0xb00, =
revision 0
[    7.969576] SP5100 TCO timer: SP5100 TCO WatchDog Timer Driver v0.01
[    7.969738] SP5100 TCO timer: mmio address 0xbafe00 already in use
[    8.059849] cfg80211: Calling CRDA to update world regulatory domain
[    8.289449] input: USB Touchscreen 0afa:03e8 as /devices/pci0000:00/00=
00:00:13.0/usb4/4-2/4-2:1.0/input/input3
[    8.289729] usbcore: registered new interface driver usbtouchscreen
[    8.471440] mcs7830_async_cmd_callback() failed with -32
[    8.472055] usb 1-2.1: applying rev.C fixup
[    8.476048] usb 1-2.1: applying rev.C fixup
[    8.483971] MOSCHIP usb-ethernet driver 1-2.1:1.0: eth0: register 'MOS=
CHIP usb-ethernet driver' at usb-0000:00:12.2-2.1, MOSCHIP 7830/7832/7730=
 usb-NET adapter, 00:60:6e:00:01:99
[    8.484071] usbcore: registered new interface driver MOSCHIP usb-ether=
net driver
[    8.972791] HDA Intel 0000:00:14.2: PCI INT A -> Link[LNKA] -> GSI 11 =
(level, low) -> IRQ 11
[    8.972808] ALSA sound/pci/hda/hda_intel.c:2413 Using LPIB position fi=
x
[    8.976441] rt2800pci 0000:01:00.0: PCI INT A -> Link[LNKA] -> GSI 11 =
(level, low) -> IRQ 11
[    8.976465] rt2800pci 0000:01:00.0: setting latency timer to 64
[    8.982177] ALSA sound/pci/hda/hda_intel.c:1490 Enable sync_write for =
stable communication
[    8.984822] ALSA sound/pci/hda/hda_intel.c:2772 Applying patch firmwar=
e 'delos-hda-settings'
[    9.030394] ALSA sound/pci/hda/hda_codec.c:4707 autoconfig: line_outs=3D=
4 (0x1f/0x22/0x1c/0x23/0x0) type:line
[    9.030409] ALSA sound/pci/hda/hda_codec.c:4711    speaker_outs=3D0 (0=
x0/0x0/0x0/0x0/0x0)
[    9.030419] ALSA sound/pci/hda/hda_codec.c:4715    hp_outs=3D1 (0x20/0=
x0/0x0/0x0/0x0)
[    9.030427] ALSA sound/pci/hda/hda_codec.c:4716    mono: mono_out=3D0x=
0
[    9.030434] ALSA sound/pci/hda/hda_codec.c:4719    dig-out=3D0x25/0x0
[    9.030440] ALSA sound/pci/hda/hda_codec.c:4720    inputs:
[    9.030448] ALSA sound/pci/hda/hda_codec.c:4724  Mic=3D0x1d
[    9.030455] ALSA sound/pci/hda/hda_codec.c:4724  Front Mic=3D0x21
[    9.030462] ALSA sound/pci/hda/hda_codec.c:4724  Line=3D0x1e
[    9.030469] ALSA sound/pci/hda/hda_codec.c:4724  CD=3D0x24
[    9.030475] ALSA sound/pci/hda/hda_codec.c:4726=20
[    9.030481] ALSA sound/pci/hda/hda_codec.c:4728    dig-in=3D0x26
[    9.052058] ieee80211 phy0: Selected rate control algorithm 'minstrel_=
ht'
[    9.052485] Registered led device: rt2800pci-phy0::radio
[    9.052542] Registered led device: rt2800pci-phy0::assoc
[    9.052598] Registered led device: rt2800pci-phy0::quality
[    9.277094] cgosdrv: module license 'Free as is' taints kernel.
[    9.277105] Disabling lock debugging due to kernel taint
[    9.896301] pciehp: pcie_port_service_register =3D 0
[    9.896311] pciehp: PCI Express Hot Plug Controller Driver version: 0.=
4
[   10.452327] EXT4-fs (sda1): mounted filesystem with ordered data mode.=
 Opts: (null)
[   10.460644] XFS (sda8): Mounting Filesystem
[   10.668840] XFS (sda8): Ending clean mount
[   10.676622] XFS (sda7): Mounting Filesystem
[   10.947419] XFS (sda7): Ending clean mount
[   10.981267] XFS (sda5): Mounting Filesystem
[   11.221351] XFS (sda5): Ending clean mount
[   11.328180] Adding 262140k swap on /dev/sda6.  Priority:-1 extents:1 a=
cross:262140k=20
[   11.484929] upstart: system-setup-keyboard main process (635) terminat=
ed with status 1
[   11.720593] XFS (sda9): Mounting Filesystem
[   12.244254] XFS (sda9): Ending clean mount
[   12.976895] upstart: Unable to connect to the system bus: Failed to co=
nnect to socket /var/run/dbus/system_bus_socket: No such file or director=
y
[   13.181856] upstart: haldaemon main process (757) terminated with stat=
us 1
[   13.181963] upstart: haldaemon main process ended, respawning
[   14.045096] NET: Registered protocol family 10
[   15.029399] XFS (sda9): Mounting Filesystem
[   15.664568] XFS (sda9): Ending clean mount
[   17.430656] upstart: ezono-cyclades-second_phase_upgrade pre-start pro=
cess (1254) terminated with status 74
[   17.439606] upstart: ezono-cyclades-calibration pre-start process (125=
7) terminated with status 73
[   25.762026] eth0: no IPv6 routers present
[  106.606890] pci 0000:02:00.0: [1234:0002] type 0 class 0x001180
[  106.606939] pci 0000:02:00.0: reg 10: [mem 0x00000000-0x00000fff 64bit=
 pref]
[  106.606970] pci 0000:02:00.0: reg 18: [mem 0x00000000-0x0003ffff 64bit=
 pref]
[  106.607001] pci 0000:02:00.0: reg 20: [mem 0x00000000-0x00000fff 64bit=
 pref]
[  106.609195] radeon 0000:00:01.0: BAR 6: [??? 0x00000000 flags 0x2] has=
 bogus alignment
[  106.609221] pci 0000:02:00.0: BAR 2: assigned [mem 0x40200000-0x4023ff=
ff 64bit pref]
[  106.609241] pci 0000:02:00.0: BAR 2: set to [mem 0x40200000-0x4023ffff=
 64bit pref] (PCI address [0x40200000-0x4023ffff])
[  106.609253] pci 0000:02:00.0: BAR 0: assigned [mem 0x40240000-0x40240f=
ff 64bit pref]
[  106.609271] pci 0000:02:00.0: BAR 0: set to [mem 0x40240000-0x40240fff=
 64bit pref] (PCI address [0x40240000-0x40240fff])
[  106.609282] pci 0000:02:00.0: BAR 4: assigned [mem 0x40241000-0x40241f=
ff 64bit pref]
[  106.609300] pci 0000:02:00.0: BAR 4: set to [mem 0x40241000-0x40241fff=
 64bit pref] (PCI address [0x40241000-0x40241fff])

--------------090703020608090803090508--
