Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751755Ab1EHAWS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 20:22:18 -0400
Received: from mail.tomasu.net ([64.85.170.232]:50719 "EHLO mail.tomasu.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284Ab1EHAWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 20:22:15 -0400
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Sat, 07 May 2011 20:22:14 EDT
From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Reply-To: thomas@fjellstrom.ca
To: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: long delay when using HMDI output on RS780
Date: Sat, 7 May 2011 18:15:03 -0600
User-Agent: KMail/1.13.7 (Linux/2.6.38-2-amd64; KDE/4.6.2; x86_64; ; )
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_HCexN6izAl8L6Q2"
Message-Id: <201105071815.03318.thomas@fjellstrom.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_HCexN6izAl8L6Q2
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

I just switched to using HDMI with my media center, and its causing a 30+ 
second delay in the screen turning on, as well as a 7 second delay in the X 
startup when it tries to fetch the EDID information. Basically I don't get any 
picture at all once KMS initializes until after X has been up a few seconds. 

The odd thing is the monitor seems to think something is going on, since it 
doesn't go to sleep or display its "No Signal" OSD, but just after X starts 
up, it pops up the "Input detected/switched" OSD, and the picture appears.

The bios, grub2 (in both text mode and graphics mode), and the initial linux 
kernel messages all display fine and immediately. Its only once KMS and 
radeondrmfb initializes that there's a problem (at least till X starts up).

I've just built with a vanila 2.6.38.4 kernel from the stable git repo, and 
have played with some EDID settings, trying to disable edid where I could 
thinking thats what caused the problem. That doesn't seem to be the case 
though. I also tried playing with the video= kernel option, trying to force 
disable VGA-1, and set a static mode for HDMI-A-1, but if I try, it seems to 
force disable HDMI-A-1 instead of force the mode.

With a DVI-D cable instead, the problem goes away.

Attached are the dmesg and xorg.log files for the latest boot with HDMI (no 
video= parameter, and EDID enabled, most settings at defaults).

What exactly would cause this, and is there a way I can fix it?

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca

--Boundary-00=_HCexN6izAl8L6Q2
Content-Type: text/plain;
  charset="UTF-8";
  name="chauncey.dmesg"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="chauncey.dmesg"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.38.4 (moose@chauncey) (gcc version 4.6.1 20110428 (prerelease) (Debian 4.6.0-6) ) #6 SMP PREEMPT Sat May 7 17:08:42 MDT 2011
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-2.6.38.4 root=UUID=f0797db1-b72e-43bc-9267-1c1f7a3736b5 ro quiet
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 0000000077de0000 (usable)
[    0.000000]  BIOS-e820: 0000000077de0000 - 0000000077de3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 0000000077de3000 - 0000000077df0000 (ACPI data)
[    0.000000]  BIOS-e820: 0000000077df0000 - 0000000077e00000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] DMI: Gigabyte Technology Co., Ltd. GA-MA78GM-S2H/GA-MA78GM-S2H, BIOS F11 09/16/2009
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x77de0 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-C7FFF write-protect
[    0.000000]   C8000-FFFFF uncachable
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask FFFFC0000000 write-back
[    0.000000]   1 base 000040000000 mask FFFFE0000000 write-back
[    0.000000]   2 base 000060000000 mask FFFFF0000000 write-back
[    0.000000]   3 base 000070000000 mask FFFFF8000000 write-back
[    0.000000]   4 base 000077E00000 mask FFFFFFE00000 uncachable
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] found SMP MP-table at [ffff8800000f54e0] f54e0
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: 0000000000000000-0000000077de0000
[    0.000000]  0000000000 - 0040000000 page 1G
[    0.000000]  0040000000 - 0077c00000 page 2M
[    0.000000]  0077c00000 - 0077de0000 page 4k
[    0.000000] kernel direct mapping tables up to 77de0000 @ 1fffd000-20000000
[    0.000000] RAMDISK: 35f94000 - 36fc2000
[    0.000000] ACPI: RSDP 00000000000f6e40 00014 (v00 GBT   )
[    0.000000] ACPI: RSDT 0000000077de3000 00038 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: FACP 0000000077de3040 00074 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: DSDT 0000000077de30c0 069CD (v01 GBT    GBTUACPI 00001000 MSFT 03000000)
[    0.000000] ACPI: FACS 0000000077de0000 00040
[    0.000000] ACPI: SSDT 0000000077de9b80 00544 (v01 PTLTD  POWERNOW 00000001  LTP 00000001)
[    0.000000] ACPI: HPET 0000000077dea100 00038 (v01 GBT    GBTUACPI 42302E31 GBTU 00000098)
[    0.000000] ACPI: MCFG 0000000077dea140 0003C (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: APIC 0000000077de9ac0 00084 (v01 GBT    GBTUACPI 42302E31 GBTU 01010101)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] Scanning NUMA topology in Northbridge 24
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000077de0000
[    0.000000] Initmem setup node 0 0000000000000000-0000000077de0000
[    0.000000]   NODE_DATA [0000000077ddb000 - 0000000077ddffff]
[    0.000000]  [ffffea0000000000-ffffea0001bfffff] PMD -> [ffff880075600000-ffff8800771fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   empty
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x00077de0
[    0.000000] On node 0 totalpages: 490863
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3921 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 6657 pages used for memmap
[    0.000000]   DMA32 zone: 480223 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x4008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x10b9a201 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 77e00000 (gap: 77e00000:68200000)
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff880077a00000 s74880 r8192 d23424 u524288
[    0.000000] pcpu-alloc: s74880 r8192 d23424 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 484144
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.38.4 root=UUID=f0797db1-b72e-43bc-9267-1c1f7a3736b5 ro quiet
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ c10000000 size 32 MB
[    0.000000] Aperture beyond 4GB. Ignoring.
[    0.000000] Memory: 1909532k/1963904k available (2847k kernel code, 452k absent, 53920k reserved, 3777k data, 544k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Preemptable hierarchical RCU implementation.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] 	Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:4352 nr_irqs:712 16
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2209.922 MHz processor.
[    0.001004] Calibrating delay loop (skipped), value calculated using timer frequency.. 4419.84 BogoMIPS (lpj=2209922)
[    0.001008] pid_max: default: 32768 minimum: 301
[    0.002015] Security Framework initialized
[    0.002208] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.003101] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.003470] Mount-cache hash table entries: 256
[    0.003602] Initializing cgroup subsys ns
[    0.003606] ns_cgroup deprecated: consider using the 'clone_children' flag without the ns_cgroup.
[    0.003609] Initializing cgroup subsys cpuacct
[    0.003614] Initializing cgroup subsys devices
[    0.003616] Initializing cgroup subsys freezer
[    0.003618] Initializing cgroup subsys blkio
[    0.003649] tseg: 0077e00000
[    0.003652] CPU: Physical Processor ID: 0
[    0.003653] CPU: Processor Core ID: 0
[    0.003656] mce: CPU supports 6 MCE banks
[    0.003694] ACPI: Core revision 20110112
[    0.007085] Setting APIC routing to flat
[    0.008183] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.018193] CPU0: AMD Phenom(tm) 9550 Quad-Core Processor stepping 03
[    0.018998] Performance Events: AMD PMU driver.
[    0.018998] ... version:                0
[    0.018998] ... bit width:              48
[    0.018998] ... generic registers:      4
[    0.018998] ... value mask:             0000ffffffffffff
[    0.018998] ... max period:             00007fffffffffff
[    0.018998] ... fixed-purpose events:   0
[    0.018998] ... event mask:             000000000000000f
[    0.021046] NMI watchdog enabled, takes one hw-pmu counter.
[    0.025025] Booting Node   0, Processors  #1
[    0.097007] NMI watchdog enabled, takes one hw-pmu counter.
[    0.100011]  #2
[    0.171996] NMI watchdog enabled, takes one hw-pmu counter.
[    0.174999]  #3 Ok.
[    0.246984] NMI watchdog enabled, takes one hw-pmu counter.
[    0.247977] Brought up 4 CPUs
[    0.247980] Total of 4 processors activated (17680.87 BogoMIPS).
[    0.249067] devtmpfs: initialized
[    0.252380] NET: Registered protocol family 16
[    0.252380] node 0 link 0: io port [c000, ffff]
[    0.252380] TOM: 0000000080000000 aka 2048M
[    0.252380] Fam 10h mmconf [e0000000, e00fffff]
[    0.252380] node 0 link 0: mmio [a0000, bffff]
[    0.252380] node 0 link 0: mmio [80000000, dfffffff]
[    0.252380] node 0 link 0: mmio [f0000000, fe02ffff]
[    0.252380] node 0 link 0: mmio [e0000000, e03fffff] ==> [e0100000, e03fffff]
[    0.252380] bus: [00, 03] on node 0 link 0
[    0.252380] bus: 00 index 0 [io  0x0000-0xffff]
[    0.252380] bus: 00 index 1 [mem 0x000a0000-0x000bffff]
[    0.252380] bus: 00 index 2 [mem 0x80000000-0xdfffffff]
[    0.252380] bus: 00 index 3 [mem 0xe0400000-0xfcffffffff]
[    0.252380] bus: 00 index 4 [mem 0xe0100000-0xe03fffff]
[    0.252380] Extended Config Space enabled on 1 nodes
[    0.252380] ACPI: bus type pci registered
[    0.252380] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.252380] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.275935] PCI: Using configuration type 1 for base access
[    0.276310] bio: create slab <bio-0> at 0
[    0.277732] ACPI: EC: Look up EC in DSDT
[    0.283289] ACPI: Interpreter enabled
[    0.283295] ACPI: (supports S0 S3 S4 S5)
[    0.283317] ACPI: Using IOAPIC for interrupt routing
[    0.308213] ACPI: No dock devices found.
[    0.308216] HEST: Table not found.
[    0.308220] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.308291] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.308441] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
[    0.308444] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
[    0.308447] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.308450] pci_root PNP0A03:00: host bridge window [mem 0x000c0000-0x000dffff]
[    0.308452] pci_root PNP0A03:00: host bridge window [mem 0xfed40000-0xfed44fff]
[    0.308455] pci_root PNP0A03:00: host bridge window [mem 0x7ff00000-0xfebfffff]
[    0.308472] pci 0000:00:00.0: [1022:9600] type 0 class 0x000600
[    0.308485] pci 0000:00:00.0: reg 1c: [mem 0xe0000000-0xffffffff 64bit]
[    0.308522] pci 0000:00:01.0: [1022:9602] type 1 class 0x000604
[    0.308567] pci 0000:00:0a.0: [1022:9609] type 1 class 0x000604
[    0.308596] pci 0000:00:0a.0: PME# supported from D0 D3hot D3cold
[    0.308599] pci 0000:00:0a.0: PME# disabled
[    0.308628] pci 0000:00:11.0: [1002:4391] type 0 class 0x000106
[    0.308649] pci 0000:00:11.0: reg 10: [io  0xff00-0xff07]
[    0.308660] pci 0000:00:11.0: reg 14: [io  0xfe00-0xfe03]
[    0.308670] pci 0000:00:11.0: reg 18: [io  0xfd00-0xfd07]
[    0.308681] pci 0000:00:11.0: reg 1c: [io  0xfc00-0xfc03]
[    0.308691] pci 0000:00:11.0: reg 20: [io  0xfb00-0xfb0f]
[    0.308702] pci 0000:00:11.0: reg 24: [mem 0xfe02f000-0xfe02f3ff]
[    0.308749] pci 0000:00:12.0: [1002:4397] type 0 class 0x000c03
[    0.308763] pci 0000:00:12.0: reg 10: [mem 0xfe02e000-0xfe02efff]
[    0.308830] pci 0000:00:12.1: [1002:4398] type 0 class 0x000c03
[    0.308845] pci 0000:00:12.1: reg 10: [mem 0xfe02d000-0xfe02dfff]
[    0.308917] pci 0000:00:12.2: [1002:4396] type 0 class 0x000c03
[    0.308938] pci 0000:00:12.2: reg 10: [mem 0xfe02c000-0xfe02c0ff]
[    0.309020] pci 0000:00:12.2: supports D1 D2
[    0.309023] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.309027] pci 0000:00:12.2: PME# disabled
[    0.309057] pci 0000:00:13.0: [1002:4397] type 0 class 0x000c03
[    0.309071] pci 0000:00:13.0: reg 10: [mem 0xfe02b000-0xfe02bfff]
[    0.309141] pci 0000:00:13.1: [1002:4398] type 0 class 0x000c03
[    0.309155] pci 0000:00:13.1: reg 10: [mem 0xfe02a000-0xfe02afff]
[    0.309228] pci 0000:00:13.2: [1002:4396] type 0 class 0x000c03
[    0.309248] pci 0000:00:13.2: reg 10: [mem 0xfe029000-0xfe0290ff]
[    0.309322] pci 0000:00:13.2: supports D1 D2
[    0.309324] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.309328] pci 0000:00:13.2: PME# disabled
[    0.309354] pci 0000:00:14.0: [1002:4385] type 0 class 0x000c05
[    0.309451] pci 0000:00:14.1: [1002:439c] type 0 class 0x000101
[    0.309469] pci 0000:00:14.1: reg 10: [io  0x0000-0x0007]
[    0.309479] pci 0000:00:14.1: reg 14: [io  0x0000-0x0003]
[    0.309489] pci 0000:00:14.1: reg 18: [io  0x0000-0x0007]
[    0.309500] pci 0000:00:14.1: reg 1c: [io  0x0000-0x0003]
[    0.309510] pci 0000:00:14.1: reg 20: [io  0xfa00-0xfa0f]
[    0.309562] pci 0000:00:14.2: [1002:4383] type 0 class 0x000403
[    0.309585] pci 0000:00:14.2: reg 10: [mem 0xfe024000-0xfe027fff 64bit]
[    0.309646] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.309650] pci 0000:00:14.2: PME# disabled
[    0.309665] pci 0000:00:14.3: [1002:439d] type 0 class 0x000601
[    0.309743] pci 0000:00:14.4: [1002:4384] type 1 class 0x000604
[    0.309787] pci 0000:00:14.5: [1002:4399] type 0 class 0x000c03
[    0.309801] pci 0000:00:14.5: reg 10: [mem 0xfe028000-0xfe028fff]
[    0.309872] pci 0000:00:18.0: [1022:1200] type 0 class 0x000600
[    0.309891] pci 0000:00:18.1: [1022:1201] type 0 class 0x000600
[    0.309907] pci 0000:00:18.2: [1022:1202] type 0 class 0x000600
[    0.309923] pci 0000:00:18.3: [1022:1203] type 0 class 0x000600
[    0.309942] pci 0000:00:18.4: [1022:1204] type 0 class 0x000600
[    0.309995] pci 0000:01:05.0: [1002:9610] type 0 class 0x000300
[    0.310004] pci 0000:01:05.0: reg 10: [mem 0xd8000000-0xdfffffff pref]
[    0.310010] pci 0000:01:05.0: reg 14: [io  0xee00-0xeeff]
[    0.310015] pci 0000:01:05.0: reg 18: [mem 0xfdfe0000-0xfdfeffff]
[    0.310026] pci 0000:01:05.0: reg 24: [mem 0xfde00000-0xfdefffff]
[    0.310040] pci 0000:01:05.0: supports D1 D2
[    0.310051] pci 0000:01:05.1: [1002:960f] type 0 class 0x000403
[    0.310060] pci 0000:01:05.1: reg 10: [mem 0xfdffc000-0xfdffffff]
[    0.310089] pci 0000:01:05.1: supports D1 D2
[    0.310128] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.310132] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    0.310135] pci 0000:00:01.0:   bridge window [mem 0xfde00000-0xfdffffff]
[    0.310140] pci 0000:00:01.0:   bridge window [mem 0xd8000000-0xdfffffff 64bit pref]
[    0.310179] pci 0000:02:00.0: [10ec:8168] type 0 class 0x000200
[    0.310192] pci 0000:02:00.0: reg 10: [io  0xde00-0xdeff]
[    0.310214] pci 0000:02:00.0: reg 18: [mem 0xfdbff000-0xfdbfffff 64bit pref]
[    0.310229] pci 0000:02:00.0: reg 20: [mem 0xfdbe0000-0xfdbeffff 64bit pref]
[    0.310239] pci 0000:02:00.0: reg 30: [mem 0x00000000-0x0000ffff pref]
[    0.310269] pci 0000:02:00.0: supports D1 D2
[    0.310272] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.310276] pci 0000:02:00.0: PME# disabled
[    0.311975] pci 0000:00:0a.0: PCI bridge to [bus 02-02]
[    0.311980] pci 0000:00:0a.0:   bridge window [io  0xd000-0xdfff]
[    0.311983] pci 0000:00:0a.0:   bridge window [mem 0xfdd00000-0xfddfffff]
[    0.311987] pci 0000:00:0a.0:   bridge window [mem 0xfdb00000-0xfdbfffff 64bit pref]
[    0.312025] pci 0000:03:06.0: [4444:0016] type 0 class 0x000400
[    0.312049] pci 0000:03:06.0: reg 10: [mem 0xf8000000-0xfbffffff pref]
[    0.312162] pci 0000:03:07.0: [4444:0016] type 0 class 0x000400
[    0.312186] pci 0000:03:07.0: reg 10: [mem 0xf4000000-0xf7ffffff pref]
[    0.312321] pci 0000:00:14.4: PCI bridge to [bus 03-03] (subtractive decode)
[    0.312326] pci 0000:00:14.4:   bridge window [io  0xc000-0xcfff]
[    0.312331] pci 0000:00:14.4:   bridge window [mem 0xfdc00000-0xfdcfffff]
[    0.312336] pci 0000:00:14.4:   bridge window [mem 0xf4000000-0xfbffffff pref]
[    0.312339] pci 0000:00:14.4:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.312342] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.312344] pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.312347] pci 0000:00:14.4:   bridge window [mem 0x000c0000-0x000dffff] (subtractive decode)
[    0.312350] pci 0000:00:14.4:   bridge window [mem 0xfed40000-0xfed44fff] (subtractive decode)
[    0.312353] pci 0000:00:14.4:   bridge window [mem 0x7ff00000-0xfebfffff] (subtractive decode)
[    0.312367] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.312645] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P_._PRT]
[    0.312744] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCEA._PRT]
[    0.312787] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
[    0.312837]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.327569] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.327614] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.327664] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.327723] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.327776] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.327826] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.327874] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.327924] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.328043] vgaarb: device added: PCI:0000:01:05.0,decodes=io+mem,owns=io+mem,locks=none
[    0.328048] vgaarb: loaded
[    0.328077] PCI: Using ACPI for IRQ routing
[    0.328080] PCI: pci_cache_line_size set to 64 bytes
[    0.328089] pci 0000:00:00.0: no compatible bridge window for [mem 0xe0000000-0xffffffff 64bit]
[    0.328177] reserve RAM buffer: 000000000009f800 - 000000000009ffff 
[    0.328181] reserve RAM buffer: 0000000077de0000 - 0000000077ffffff 
[    0.328290] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.328295] hpet0: 4 comparators, 32-bit 14.318180 MHz counter
[    0.330001] Switching to clocksource hpet
[    0.330557] Switched to NOHz mode on CPU #0
[    0.330681] Switched to NOHz mode on CPU #3
[    0.330691] Switched to NOHz mode on CPU #2
[    0.330701] Switched to NOHz mode on CPU #1
[    0.331331] pnp: PnP ACPI init
[    0.331355] ACPI: bus type pnp registered
[    0.331450] pnp 00:00: [bus 00-ff]
[    0.331455] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.331458] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.331460] pnp 00:00: [io  0x0d00-0xffff window]
[    0.331462] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.331465] pnp 00:00: [mem 0x000c0000-0x000dffff window]
[    0.331467] pnp 00:00: [mem 0xfed40000-0xfed44fff window]
[    0.331470] pnp 00:00: [mem 0x7ff00000-0xfebfffff window]
[    0.331523] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.331536] pnp 00:01: [io  0x0010-0x001f]
[    0.331539] pnp 00:01: [io  0x0022-0x003f]
[    0.331541] pnp 00:01: [io  0x0044-0x004d]
[    0.331543] pnp 00:01: [io  0x0050-0x005f]
[    0.331550] pnp 00:01: [io  0x0062-0x0063]
[    0.331552] pnp 00:01: [io  0x0065-0x006f]
[    0.331554] pnp 00:01: [io  0x0074-0x007f]
[    0.331556] pnp 00:01: [io  0x0091-0x0093]
[    0.331558] pnp 00:01: [io  0x00a2-0x00bf]
[    0.331560] pnp 00:01: [io  0x00e0-0x00ef]
[    0.331562] pnp 00:01: [io  0x04d0-0x04d1]
[    0.331564] pnp 00:01: [io  0x0220-0x0225]
[    0.331566] pnp 00:01: [io  0x0290-0x0294]
[    0.331637] system 00:01: [io  0x04d0-0x04d1] has been reserved
[    0.331640] system 00:01: [io  0x0220-0x0225] has been reserved
[    0.331643] system 00:01: [io  0x0290-0x0294] has been reserved
[    0.331647] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.360079] pnp 00:02: [io  0x4100-0x411f]
[    0.360081] pnp 00:02: [io  0x0228-0x022f]
[    0.360084] pnp 00:02: [io  0x0238-0x023f]
[    0.360086] pnp 00:02: [io  0x040b]
[    0.360088] pnp 00:02: [io  0x04d6]
[    0.360090] pnp 00:02: [io  0x0c00-0x0c01]
[    0.360092] pnp 00:02: [io  0x0c14]
[    0.360094] pnp 00:02: [io  0x0c50-0x0c52]
[    0.360096] pnp 00:02: [io  0x0c6c-0x0c6d]
[    0.360098] pnp 00:02: [io  0x0c6f]
[    0.360100] pnp 00:02: [io  0x0cd0-0x0cd1]
[    0.360102] pnp 00:02: [io  0x0cd2-0x0cd3]
[    0.360104] pnp 00:02: [io  0x0cd4-0x0cdf]
[    0.360106] pnp 00:02: [io  0x4000-0x40fe]
[    0.360108] pnp 00:02: [io  0x4210-0x4217]
[    0.360110] pnp 00:02: [io  0x0b00-0x0b0f]
[    0.360112] pnp 00:02: [io  0x0b10-0x0b1f]
[    0.360114] pnp 00:02: [io  0x0b20-0x0b3f]
[    0.360117] pnp 00:02: [mem 0x00000000-0x00000fff window]
[    0.360119] pnp 00:02: [mem 0xfee00400-0xfee00fff window]
[    0.360125] pnp 00:02: disabling [mem 0x00000000-0x00000fff window] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.360162] pnp 00:02: disabling [mem 0x00000000-0x00000fff window disabled] because it overlaps 0000:02:00.0 BAR 6 [mem 0x00000000-0x0000ffff pref]
[    0.360209] system 00:02: [io  0x4100-0x411f] has been reserved
[    0.360212] system 00:02: [io  0x0228-0x022f] has been reserved
[    0.360215] system 00:02: [io  0x0238-0x023f] has been reserved
[    0.360218] system 00:02: [io  0x040b] has been reserved
[    0.360221] system 00:02: [io  0x04d6] has been reserved
[    0.360223] system 00:02: [io  0x0c00-0x0c01] has been reserved
[    0.360226] system 00:02: [io  0x0c14] has been reserved
[    0.360229] system 00:02: [io  0x0c50-0x0c52] has been reserved
[    0.360232] system 00:02: [io  0x0c6c-0x0c6d] has been reserved
[    0.360235] system 00:02: [io  0x0c6f] has been reserved
[    0.360237] system 00:02: [io  0x0cd0-0x0cd1] has been reserved
[    0.360240] system 00:02: [io  0x0cd2-0x0cd3] has been reserved
[    0.360243] system 00:02: [io  0x0cd4-0x0cdf] has been reserved
[    0.360246] system 00:02: [io  0x4000-0x40fe] has been reserved
[    0.360249] system 00:02: [io  0x4210-0x4217] has been reserved
[    0.360252] system 00:02: [io  0x0b00-0x0b0f] has been reserved
[    0.360254] system 00:02: [io  0x0b10-0x0b1f] has been reserved
[    0.360257] system 00:02: [io  0x0b20-0x0b3f] has been reserved
[    0.360261] system 00:02: [mem 0xfee00400-0xfee00fff window] has been reserved
[    0.360264] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.360387] pnp 00:03: [dma 4]
[    0.360391] pnp 00:03: [io  0x0000-0x000f]
[    0.360393] pnp 00:03: [io  0x0080-0x0090]
[    0.360396] pnp 00:03: [io  0x0094-0x009f]
[    0.360398] pnp 00:03: [io  0x00c0-0x00df]
[    0.360436] pnp 00:03: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.360499] pnp 00:04: [irq 0 disabled]
[    0.360513] pnp 00:04: [irq 8]
[    0.360515] pnp 00:04: [mem 0xfed00000-0xfed003ff]
[    0.360559] pnp 00:04: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.360594] pnp 00:05: [io  0x0070-0x0073]
[    0.360630] pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.360644] pnp 00:06: [io  0x0061]
[    0.360685] pnp 00:06: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.360699] pnp 00:07: [io  0x00f0-0x00ff]
[    0.360707] pnp 00:07: [irq 13]
[    0.360743] pnp 00:07: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.361137] pnp 00:08: [mem 0xe0000000-0xefffffff]
[    0.361221] system 00:08: [mem 0xe0000000-0xefffffff] has been reserved
[    0.361230] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.361388] pnp 00:09: [mem 0x000d1c00-0x000d3fff]
[    0.361392] pnp 00:09: [mem 0x000f0000-0x000f7fff]
[    0.361394] pnp 00:09: [mem 0x000f8000-0x000fbfff]
[    0.361397] pnp 00:09: [mem 0x000fc000-0x000fffff]
[    0.361399] pnp 00:09: [mem 0x77de0000-0x77dfffff]
[    0.361401] pnp 00:09: [mem 0xffff0000-0xffffffff]
[    0.361403] pnp 00:09: [mem 0x00000000-0x0009ffff]
[    0.361406] pnp 00:09: [mem 0x00100000-0x77ddffff]
[    0.361408] pnp 00:09: [mem 0x77ef0000-0x7feeffff]
[    0.361410] pnp 00:09: [mem 0xfec00000-0xfec00fff]
[    0.361412] pnp 00:09: [mem 0xfee00000-0xfee00fff]
[    0.361415] pnp 00:09: [mem 0xfff80000-0xfffeffff]
[    0.361420] pnp 00:09: disabling [mem 0x000d1c00-0x000d3fff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.361426] pnp 00:09: disabling [mem 0x000f0000-0x000f7fff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.361430] pnp 00:09: disabling [mem 0x000f8000-0x000fbfff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.361434] pnp 00:09: disabling [mem 0x000fc000-0x000fffff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.361438] pnp 00:09: disabling [mem 0x00000000-0x0009ffff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.361442] pnp 00:09: disabling [mem 0x00100000-0x77ddffff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.361528] system 00:09: [mem 0x77de0000-0x77dfffff] could not be reserved
[    0.361532] system 00:09: [mem 0xffff0000-0xffffffff] has been reserved
[    0.361535] system 00:09: [mem 0x77ef0000-0x7feeffff] could not be reserved
[    0.361543] system 00:09: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.361546] system 00:09: [mem 0xfee00000-0xfee00fff] could not be reserved
[    0.361550] system 00:09: [mem 0xfff80000-0xfffeffff] has been reserved
[    0.361553] system 00:09: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.361574] pnp: PnP ACPI: found 10 devices
[    0.361578] ACPI: ACPI bus type pnp unregistered
[    0.368589] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.368592] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    0.368596] pci 0000:00:01.0:   bridge window [mem 0xfde00000-0xfdffffff]
[    0.368600] pci 0000:00:01.0:   bridge window [mem 0xd8000000-0xdfffffff 64bit pref]
[    0.368606] pci 0000:02:00.0: BAR 6: assigned [mem 0xfdb00000-0xfdb0ffff pref]
[    0.368609] pci 0000:00:0a.0: PCI bridge to [bus 02-02]
[    0.368612] pci 0000:00:0a.0:   bridge window [io  0xd000-0xdfff]
[    0.368616] pci 0000:00:0a.0:   bridge window [mem 0xfdd00000-0xfddfffff]
[    0.368619] pci 0000:00:0a.0:   bridge window [mem 0xfdb00000-0xfdbfffff 64bit pref]
[    0.368624] pci 0000:00:14.4: PCI bridge to [bus 03-03]
[    0.368627] pci 0000:00:14.4:   bridge window [io  0xc000-0xcfff]
[    0.368633] pci 0000:00:14.4:   bridge window [mem 0xfdc00000-0xfdcfffff]
[    0.368638] pci 0000:00:14.4:   bridge window [mem 0xf4000000-0xfbffffff pref]
[    0.368663] pci 0000:00:0a.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.368667] pci 0000:00:0a.0: setting latency timer to 64
[    0.368675] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.368677] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.368680] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.368682] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000dffff]
[    0.368685] pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfed44fff]
[    0.368687] pci_bus 0000:00: resource 9 [mem 0x7ff00000-0xfebfffff]
[    0.368690] pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
[    0.368692] pci_bus 0000:01: resource 1 [mem 0xfde00000-0xfdffffff]
[    0.368695] pci_bus 0000:01: resource 2 [mem 0xd8000000-0xdfffffff 64bit pref]
[    0.368698] pci_bus 0000:02: resource 0 [io  0xd000-0xdfff]
[    0.368700] pci_bus 0000:02: resource 1 [mem 0xfdd00000-0xfddfffff]
[    0.368703] pci_bus 0000:02: resource 2 [mem 0xfdb00000-0xfdbfffff 64bit pref]
[    0.368706] pci_bus 0000:03: resource 0 [io  0xc000-0xcfff]
[    0.368708] pci_bus 0000:03: resource 1 [mem 0xfdc00000-0xfdcfffff]
[    0.368711] pci_bus 0000:03: resource 2 [mem 0xf4000000-0xfbffffff pref]
[    0.368718] pci_bus 0000:03: resource 4 [io  0x0000-0x0cf7]
[    0.368721] pci_bus 0000:03: resource 5 [io  0x0d00-0xffff]
[    0.368723] pci_bus 0000:03: resource 6 [mem 0x000a0000-0x000bffff]
[    0.368726] pci_bus 0000:03: resource 7 [mem 0x000c0000-0x000dffff]
[    0.368728] pci_bus 0000:03: resource 8 [mem 0xfed40000-0xfed44fff]
[    0.368731] pci_bus 0000:03: resource 9 [mem 0x7ff00000-0xfebfffff]
[    0.368769] NET: Registered protocol family 2
[    0.368905] IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.369851] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.371508] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.371893] TCP: Hash tables configured (established 262144 bind 65536)
[    0.371896] TCP reno registered
[    0.371905] UDP hash table entries: 1024 (order: 3, 32768 bytes)
[    0.371925] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
[    0.372066] NET: Registered protocol family 1
[    0.372079] pci 0000:00:01.0: MSI quirk detected; subordinate MSI disabled
[    0.488060] pci 0000:01:05.0: Boot video device
[    0.488075] PCI: CLS 4 bytes, default 64
[    0.488138] Unpacking initramfs...
[    0.882516] Freeing initrd memory: 16568k freed
[    0.890724] audit: initializing netlink socket (disabled)
[    0.890744] type=2000 audit(1304813191.889:1): initialized
[    0.901820] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.904145] VFS: Disk quotas dquot_6.5.2
[    0.904216] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.904317] msgmni has been set to 3761
[    0.904552] alg: No test for stdrng (krng)
[    0.904611] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.904648] io scheduler noop registered
[    0.904651] io scheduler deadline registered
[    0.904690] io scheduler cfq registered (default)
[    0.904869] pcieport 0000:00:0a.0: setting latency timer to 64
[    0.904906] pcieport 0000:00:0a.0: irq 40 for MSI/MSI-X
[    0.905116] ERST: Table is not found!
[    0.905202] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.969304] Linux agpgart interface v0.103
[    0.969376] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    0.969844] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.969871] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.970124] mousedev: PS/2 mouse device common for all mice
[    0.970165] rtc_cmos 00:05: RTC can wake from S4
[    0.977068] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    0.977102] rtc0: alarms up to one month, 242 bytes nvram, hpet irqs
[    0.977113] cpuidle: using governor ladder
[    0.977115] cpuidle: using governor menu
[    0.977440] TCP cubic registered
[    0.977590] NET: Registered protocol family 10
[    0.978411] Mobile IPv6
[    0.978414] NET: Registered protocol family 17
[    0.978418] Registering the dns_resolver key type
[    0.978548] PM: Hibernation image not present or could not be loaded.
[    0.978560] registered taskstats version 1
[    0.978967] rtc_cmos 00:05: setting system clock to 2011-05-08 00:06:32 UTC (1304813192)
[    0.978992] Initalizing network drop monitor service
[    0.980280] Freeing unused kernel memory: 544k freed
[    0.980447] Write protecting the kernel read-only data: 6144k
[    0.986223] Freeing unused kernel memory: 1232k freed
[    0.990887] Freeing unused kernel memory: 904k freed
[    1.008395] <30>udevd[89]: starting version 168
[    1.077234] SCSI subsystem initialized
[    1.090057] [drm] Initialized drm 1.1.0 20060810
[    1.107184] libata version 3.00 loaded.
[    1.119037] ahci 0000:00:11.0: version 3.0
[    1.119073] ahci 0000:00:11.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    1.119221] ahci 0000:00:11.0: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[    1.119225] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part ccc 
[    1.120399] scsi0 : ahci
[    1.120533] scsi1 : ahci
[    1.120617] scsi2 : ahci
[    1.120698] scsi3 : ahci
[    1.120785] scsi4 : ahci
[    1.120867] scsi5 : ahci
[    1.121054] ata1: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f100 irq 22
[    1.121058] ata2: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f180 irq 22
[    1.121062] ata3: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f200 irq 22
[    1.121066] ata4: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f280 irq 22
[    1.121069] ata5: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f300 irq 22
[    1.121073] ata6: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f380 irq 22
[    1.154066] [drm] radeon kernel modesetting enabled.
[    1.154201] radeon 0000:01:05.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    1.154206] radeon 0000:01:05.0: setting latency timer to 64
[    1.156507] [drm] initializing kernel modesetting (RS780 0x1002:0x9610).
[    1.156531] [drm] register mmio base: 0xFDFE0000
[    1.156533] [drm] register mmio size: 65536
[    1.158851] ATOM BIOS: B27721
[    1.158873] radeon 0000:01:05.0: VRAM: 128M 0x00000000C0000000 - 0x00000000C7FFFFFF (128M used)
[    1.158876] radeon 0000:01:05.0: GTT: 512M 0x00000000A0000000 - 0x00000000BFFFFFFF
[    1.160125] [drm] Detected VRAM RAM=128M, BAR=128M
[    1.160130] [drm] RAM width 32bits DDR
[    1.160218] [TTM] Zone  kernel: Available graphics memory: 964390 kiB.
[    1.160220] [TTM] Initializing pool allocator.
[    1.160244] [drm] radeon: 128M of VRAM memory ready
[    1.160246] [drm] radeon: 512M of GTT memory ready.
[    1.160276] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    1.160278] [drm] Driver supports precise vblank timestamp query.
[    1.160311] [drm] radeon: irq initialized.
[    1.160314] [drm] GART: num cpu pages 131072, num gpu pages 131072
[    1.161216] [drm] Loading RS780 Microcode
[    1.174536] radeon 0000:01:05.0: WB enabled
[    1.205951] [drm] ring test succeeded in 1 usecs
[    1.206120] [drm] radeon: ib pool ready.
[    1.206199] [drm] ib test succeeded in 0 usecs
[    1.206202] [drm] Enabling audio support
[    1.206210] failed to evaluate ATIF got AE_BAD_PARAMETER
[    1.206490] [drm] Radeon Display Connectors
[    1.206492] [drm] Connector 0:
[    1.206494] [drm]   VGA
[    1.206497] [drm]   DDC: 0x7e40 0x7e40 0x7e44 0x7e44 0x7e48 0x7e48 0x7e4c 0x7e4c
[    1.206501] [drm]   Encoders:
[    1.206504] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[    1.206506] [drm] Connector 1:
[    1.206508] [drm]   HDMI-A
[    1.206510] [drm]   HPD1
[    1.206513] [drm]   DDC: 0x7e50 0x7e50 0x7e54 0x7e54 0x7e58 0x7e58 0x7e5c 0x7e5c
[    1.206516] [drm]   Encoders:
[    1.206518] [drm]     DFP1: INTERNAL_KLDSCP_LVTMA
[    1.311492] [drm] radeon: power management initialized
[    1.426048] ata5: SATA link down (SStatus 0 SControl 300)
[    1.426154] ata4: SATA link down (SStatus 0 SControl 300)
[    1.426190] ata6: SATA link down (SStatus 0 SControl 300)
[    1.438934] [drm] fb mappable at 0xD8141000
[    1.438936] [drm] vram apper at 0xD8000000
[    1.438938] [drm] size 8294400
[    1.438939] [drm] fb depth is 24
[    1.438941] [drm]    pitch is 7680
[    1.453348] Console: switching to colour frame buffer device 240x67
[    1.463506] fb0: radeondrmfb frame buffer device
[    1.463508] drm: registered panic notifier
[    1.463514] [drm] Initialized radeon 2.8.0 20080528 for 0000:01:05.0 on minor 0
[    1.581057] ata3: softreset failed (device not ready)
[    1.581109] ata3: applying SB600 PMP SRST workaround and retrying
[    1.581127] ata2: softreset failed (device not ready)
[    1.581178] ata2: applying SB600 PMP SRST workaround and retrying
[    1.581196] ata1: softreset failed (device not ready)
[    1.581249] ata1: applying SB600 PMP SRST workaround and retrying
[    1.736074] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.736103] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.736129] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.736253] ata1.00: HPA detected: current 62525039, native 62533296
[    1.736295] ata1.00: ATA-7: OCZ-VERTEX v1.10, 1370, max UDMA/133
[    1.736299] ata1.00: 62525039 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.736534] ata1.00: configured for UDMA/133
[    1.736568] ata2.00: ATAPI: TSSTcorp CDDVDW SH-S223Q, SB02, max UDMA/100
[    1.736711] scsi 0:0:0:0: Direct-Access     ATA      OCZ-VERTEX v1.10 1370 PQ: 0 ANSI: 5
[    1.737309] ata2.00: configured for UDMA/100
[    1.738182] scsi 1:0:0:0: CD-ROM            TSSTcorp CDDVDW SH-S223Q  SB02 PQ: 0 ANSI: 5
[    1.779145] ata3.00: ATA-7: ST3320620AS, 3.AAK, max UDMA/133
[    1.779148] ata3.00: 625142448 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    1.837454] ata3.00: configured for UDMA/133
[    1.837543] scsi 2:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
[    1.847505] sd 0:0:0:0: [sda] 62525039 512-byte logical blocks: (32.0 GB/29.8 GiB)
[    1.847531] sd 2:0:0:0: [sdb] 625142448 512-byte logical blocks: (320 GB/298 GiB)
[    1.847690] sd 2:0:0:0: [sdb] Write Protect is off
[    1.847696] sd 0:0:0:0: [sda] Write Protect is off
[    1.847700] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.847705] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    1.847742] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.847759] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.848288]  sda: sda1
[    1.848597] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.877480]  sdb: sdb1 sdb2
[    1.877833] sd 2:0:0:0: [sdb] Attached SCSI disk
[    1.892046] Refined TSC clocksource calibration: 2210.064 MHz.
[    1.892051] Switching to clocksource tsc
[    3.117735] device-mapper: uevent: version 1.0.3
[    3.117926] device-mapper: ioctl: 4.19.1-ioctl (2011-01-07) initialised: dm-devel@redhat.com
[    3.138227] PM: Starting manual resume from disk
[    3.138231] PM: Hibernation image partition 8:17 present
[    3.138233] PM: Looking for hibernation image.
[    3.138425] PM: Image not found (code -22)
[    3.138429] PM: Hibernation image not present or could not be loaded.
[    3.170677] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[    3.366770] <30>udevd[392]: starting version 168
[    3.422124] wmi: Mapper loaded
[    3.426229] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    3.426237] ACPI: Power Button [PWRB]
[    3.426325] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    3.426329] ACPI: Power Button [PWRF]
[    3.439549] ACPI: acpi_idle registered with cpuidle
[    3.452642] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    3.466366] MCE: In-kernel MCE decoding enabled.
[    3.467762] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    3.467794] r8169 0000:02:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    3.467834] r8169 0000:02:00.0: setting latency timer to 64
[    3.467882] r8169 0000:02:00.0: irq 41 for MSI/MSI-X
[    3.468584] r8169 0000:02:00.0: eth0: RTL8168c/8111c at 0xffffc90000336000, 00:1f:d0:82:55:1c, XID 1c4000c0 IRQ 41
[    3.469045] input: PC Speaker as /devices/platform/pcspkr/input/input2
[    3.478040] k10temp 0000:00:18.3: unreliable CPU thermal sensor; monitoring disabled
[    3.480831] ACPI: resource piix4_smbus [io  0x0b00-0x0b07] conflicts with ACPI region SOR1 [io 0xb00-0xb0f]
[    3.480836] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    3.489972] shpchp 0000:00:01.0: HPC vendor_id 1022 device_id 9602 ss_vid 1022 ss_did 9602
[    3.489978] shpchp 0000:00:01.0: Cannot reserve MMIO region
[    3.490083] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    3.494518] pata_atiixp 0000:00:14.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.495161] scsi6 : pata_atiixp
[    3.495418] scsi7 : pata_atiixp
[    3.496079] ata7: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xfa00 irq 14
[    3.496082] ata8: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xfa08 irq 15
[    3.533032] EDAC MC: Ver: 2.1.0 May  7 2011
[    3.614070] usbcore: registered new interface driver usbfs
[    3.614107] usbcore: registered new interface driver hub
[    3.614184] usbcore: registered new device driver usb
[    3.634256] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    3.635261] ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    3.635289] ehci_hcd 0000:00:12.2: EHCI Host Controller
[    3.635321] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 1
[    3.639034] ehci_hcd 0000:00:12.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    3.639053] ehci_hcd 0000:00:12.2: applying AMD SB600/SB700 USB freeze workaround
[    3.639067] ehci_hcd 0000:00:12.2: debug port 1
[    3.639099] ehci_hcd 0000:00:12.2: irq 17, io mem 0xfe02c000
[    3.645018] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
[    3.645047] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    3.645050] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.645053] usb usb1: Product: EHCI Host Controller
[    3.645055] usb usb1: Manufacturer: Linux 2.6.38.4 ehci_hcd
[    3.645057] usb usb1: SerialNumber: 0000:00:12.2
[    3.645198] hub 1-0:1.0: USB hub found
[    3.645204] hub 1-0:1.0: 6 ports detected
[    3.645386] ehci_hcd 0000:00:13.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    3.645407] ehci_hcd 0000:00:13.2: EHCI Host Controller
[    3.645418] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 2
[    3.661881] ehci_hcd 0000:00:13.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    3.661898] ehci_hcd 0000:00:13.2: applying AMD SB600/SB700 USB freeze workaround
[    3.661914] ehci_hcd 0000:00:13.2: debug port 1
[    3.661952] ehci_hcd 0000:00:13.2: irq 19, io mem 0xfe029000
[    3.667014] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
[    3.667046] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    3.667049] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.667052] usb usb2: Product: EHCI Host Controller
[    3.667054] usb usb2: Manufacturer: Linux 2.6.38.4 ehci_hcd
[    3.667056] usb usb2: SerialNumber: 0000:00:13.2
[    3.667225] hub 2-0:1.0: USB hub found
[    3.667231] hub 2-0:1.0: 6 ports detected
[    3.668946] EDAC amd64_edac: v3.3.0
[    3.669064] EDAC amd64: DRAM ECC disabled.
[    3.669073] EDAC amd64: ECC disabled in the BIOS or no ECC capability, module will not load.
[    3.669074]  Either enable ECC checking or force module loading by setting 'ecc_enable_override'.
[    3.669076]  (Note that use of the override may cause unknown side effects.)
[    3.683676] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[    3.683682] cdrom: Uniform CD-ROM driver Revision: 3.20
[    3.683861] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    3.695068] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    3.695283] ohci_hcd 0000:00:12.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.695308] ohci_hcd 0000:00:12.0: OHCI Host Controller
[    3.695321] ohci_hcd 0000:00:12.0: new USB bus registered, assigned bus number 3
[    3.704068] ohci_hcd 0000:00:12.0: irq 16, io mem 0xfe02e000
[    3.705197] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    3.705263] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    3.705307] sd 2:0:0:0: Attached scsi generic sg2 type 0
[    3.759064] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    3.759069] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.759072] usb usb3: Product: OHCI Host Controller
[    3.759074] usb usb3: Manufacturer: Linux 2.6.38.4 ohci_hcd
[    3.759077] usb usb3: SerialNumber: 0000:00:12.0
[    3.759248] hub 3-0:1.0: USB hub found
[    3.759256] hub 3-0:1.0: 3 ports detected
[    3.759436] ohci_hcd 0000:00:12.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.759460] ohci_hcd 0000:00:12.1: OHCI Host Controller
[    3.759472] ohci_hcd 0000:00:12.1: new USB bus registered, assigned bus number 4
[    3.767076] ohci_hcd 0000:00:12.1: irq 16, io mem 0xfe02d000
[    3.822057] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    3.822061] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.822065] usb usb4: Product: OHCI Host Controller
[    3.822067] usb usb4: Manufacturer: Linux 2.6.38.4 ohci_hcd
[    3.822069] usb usb4: SerialNumber: 0000:00:12.1
[    3.822212] hub 4-0:1.0: USB hub found
[    3.822220] hub 4-0:1.0: 3 ports detected
[    3.822402] ohci_hcd 0000:00:13.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    3.822430] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    3.822442] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 5
[    3.831047] ohci_hcd 0000:00:13.0: irq 18, io mem 0xfe02b000
[    3.886053] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    3.886057] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.886059] usb usb5: Product: OHCI Host Controller
[    3.886061] usb usb5: Manufacturer: Linux 2.6.38.4 ohci_hcd
[    3.886063] usb usb5: SerialNumber: 0000:00:13.0
[    3.886196] hub 5-0:1.0: USB hub found
[    3.886203] hub 5-0:1.0: 3 ports detected
[    3.886357] ohci_hcd 0000:00:13.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    3.886376] ohci_hcd 0000:00:13.1: OHCI Host Controller
[    3.886387] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 6
[    3.891032] ohci_hcd 0000:00:13.1: irq 18, io mem 0xfe02a000
[    3.946052] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    3.946055] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    3.946057] usb usb6: Product: OHCI Host Controller
[    3.946059] usb usb6: Manufacturer: Linux 2.6.38.4 ohci_hcd
[    3.946062] usb usb6: SerialNumber: 0000:00:13.1
[    3.946191] hub 6-0:1.0: USB hub found
[    3.946197] hub 6-0:1.0: 3 ports detected
[    3.946339] HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.946344] hda_intel: position_fix set to 1 for device 1458:a022
[    3.976089] hda_codec: ALC889A: BIOS auto-probing.
[    3.983293] input: HDA ATI SB Headphone as /devices/pci0000:00/0000:00:14.2/sound/card0/input3
[    3.983503] ohci_hcd 0000:00:14.5: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    3.983522] ohci_hcd 0000:00:14.5: OHCI Host Controller
[    3.983535] ohci_hcd 0000:00:14.5: new USB bus registered, assigned bus number 7
[    3.983552] HDA Intel 0000:01:05.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    3.983572] HDA Intel 0000:01:05.1: setting latency timer to 64
[    3.990022] ohci_hcd 0000:00:14.5: irq 18, io mem 0xfe028000
[    4.045069] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    4.045073] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    4.045076] usb usb7: Product: OHCI Host Controller
[    4.045078] usb usb7: Manufacturer: Linux 2.6.38.4 ohci_hcd
[    4.045080] usb usb7: SerialNumber: 0000:00:14.5
[    4.045239] hub 7-0:1.0: USB hub found
[    4.045248] hub 7-0:1.0: 2 ports detected
[    4.050017] usb 2-2: new high speed USB device using ehci_hcd and address 2
[    4.166550] usb 2-2: New USB device found, idVendor=058f, idProduct=6362
[    4.166554] usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    4.166557] usb 2-2: Product: Mass Storage Device
[    4.166560] usb 2-2: Manufacturer: Generic
[    4.166562] usb 2-2: SerialNumber: 058F63626376
[    4.289031] usb 4-2: new low speed USB device using ohci_hcd and address 2
[    4.441076] usb 4-2: New USB device found, idVendor=04b3, idProduct=3025
[    4.441079] usb 4-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    4.441082] usb 4-2: Product: USB NetVista Full Width Keyboard.
[    4.441084] usb 4-2: Manufacturer: LITE-ON Technology
[    4.572026] usb 4-3: new low speed USB device using ohci_hcd and address 3
[    4.722087] usb 4-3: New USB device found, idVendor=046d, idProduct=c517
[    4.722091] usb 4-3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    4.722094] usb 4-3: Product: USB Receiver
[    4.722096] usb 4-3: Manufacturer: Logitech
[    4.733542] usbcore: registered new interface driver uas
[    4.742519] usbcore: registered new interface driver libusual
[    4.763602] Initializing USB Mass Storage driver...
[    4.763758] scsi8 : usb-storage 2-2:1.0
[    4.763943] usbcore: registered new interface driver usb-storage
[    4.763948] USB Mass Storage support registered.
[    4.784115] input: LITE-ON Technology USB NetVista Full Width Keyboard. as /devices/pci0000:00/0000:00:12.1/usb4/4-2/4-2:1.0/input/input4
[    4.784238] generic-usb 0003:04B3:3025.0001: input,hidraw0: USB HID v1.10 Keyboard [LITE-ON Technology USB NetVista Full Width Keyboard.] on usb-0000:00:12.1-2/input0
[    4.784377] usbcore: registered new interface driver usbhid
[    4.784380] usbhid: USB HID core driver
[    4.807133] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:12.1/usb4/4-3/4-3:1.0/input/input5
[    4.807255] logitech 0003:046D:C517.0002: input,hidraw1: USB HID v1.10 Keyboard [Logitech USB Receiver] on usb-0000:00:12.1-3/input0
[    4.814085] logitech 0003:046D:C517.0003: fixing up Logitech keyboard report descriptor
[    4.814686] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:12.1/usb4/4-3/4-3:1.1/input/input6
[    4.814907] logitech 0003:046D:C517.0003: input,hiddev0,hidraw2: USB HID v1.10 Mouse [Logitech USB Receiver] on usb-0000:00:12.1-3/input1
[    5.763667] scsi 8:0:0:0: Direct-Access     Generic  USB SD Reader    1.00 PQ: 0 ANSI: 0
[    5.764154] scsi 8:0:0:1: Direct-Access     Generic  USB CF Reader    1.01 PQ: 0 ANSI: 0
[    5.764653] scsi 8:0:0:2: Direct-Access     Generic  USB xD/SM Reader 1.02 PQ: 0 ANSI: 0
[    5.765159] scsi 8:0:0:3: Direct-Access     Generic  USB MS Reader    1.03 PQ: 0 ANSI: 0
[    5.765719] sd 8:0:0:0: Attached scsi generic sg3 type 0
[    5.765928] sd 8:0:0:1: Attached scsi generic sg4 type 0
[    5.766134] sd 8:0:0:2: Attached scsi generic sg5 type 0
[    5.766338] sd 8:0:0:3: Attached scsi generic sg6 type 0
[    5.771530] sd 8:0:0:0: [sdc] Attached SCSI removable disk
[    5.772148] sd 8:0:0:1: [sdd] Attached SCSI removable disk
[    5.773404] sd 8:0:0:3: [sdf] Attached SCSI removable disk
[    5.774045] sd 8:0:0:2: [sde] Attached SCSI removable disk
[    6.928162] Adding 7815584k swap on /dev/sdb1.  Priority:-1 extents:1 across:7815584k 
[    6.932471] EXT4-fs (sda1): re-mounted. Opts: (null)
[    6.957046] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro
[    6.988593] loop: module loaded
[    7.026424] it87: Found IT8718F chip at 0x228, revision 5
[    7.026447] it87: Beeping is supported
[    7.705368] EXT4-fs (dm-0): mounted filesystem with ordered data mode. Opts: (null)
[    7.759124] EXT4-fs (dm-1): mounted filesystem with ordered data mode. Opts: (null)
[    7.853962] r8169 0000:02:00.0: eth0: link down
[    7.853971] r8169 0000:02:00.0: eth0: link down
[    7.854271] ADDRCONF(NETDEV_UP): eth0: link is not ready
[    9.992612] r8169 0000:02:00.0: eth0: link up
[    9.992887] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   14.764342] RPC: Registered udp transport module.
[   14.764346] RPC: Registered tcp transport module.
[   14.764348] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   14.801909] FS-Cache: Loaded
[   14.936689] FS-Cache: Netfs 'nfs' registered for caching
[   14.994055] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   15.109851] fuse init (API version 7.16)
[   15.343622] powernow-k8: Found 1 AMD Phenom(tm) 9550 Quad-Core Processor (4 cpu cores) (version 2.20.00)
[   15.343697] powernow-k8:    0 : pstate 0 (2200 MHz)
[   15.343701] powernow-k8:    1 : pstate 1 (1100 MHz)
[   19.137978] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro,commit=0
[   19.183318] EXT4-fs (dm-0): re-mounted. Opts: commit=0
[   19.275994] EXT4-fs (dm-1): re-mounted. Opts: commit=0
[   20.626008] eth0: no IPv6 routers present

--Boundary-00=_HCexN6izAl8L6Q2
Content-Type: text/x-log;
  charset="UTF-8";
  name="chauncey.Xorg.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="chauncey.Xorg.log"

[    16.055] 
X.Org X Server 1.10.1
Release Date: 2011-04-15
[    16.055] X Protocol Version 11, Revision 0
[    16.055] Build Operating System: Linux 2.6.32-5-amd64 x86_64 Debian
[    16.055] Current Operating System: Linux chauncey 2.6.38.4 #6 SMP PREEMPT Sat May 7 17:08:42 MDT 2011 x86_64
[    16.055] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.38.4 root=UUID=f0797db1-b72e-43bc-9267-1c1f7a3736b5 ro quiet
[    16.055] Build Date: 28 April 2011  12:13:00PM
[    16.055] xorg-server 2:1.10.1-2 (Julien Cristau <jcristau@debian.org>) 
[    16.055] Current version of pixman: 0.21.8
[    16.055] 	Before reporting problems, check http://wiki.x.org
	to make sure that you have the latest version.
[    16.055] Markers: (--) probed, (**) from config file, (==) default setting,
	(++) from command line, (!!) notice, (II) informational,
	(WW) warning, (EE) error, (NI) not implemented, (??) unknown.
[    16.056] (==) Log file: "/var/log/Xorg.0.log", Time: Sat May  7 18:06:47 2011
[    16.059] (==) Using config file: "/etc/X11/xorg.conf"
[    16.059] (==) Using system config directory "/usr/share/X11/xorg.conf.d"
[    16.061] (==) ServerLayout "X.org Configured"
[    16.061] (**) |-->Screen "Screen0" (0)
[    16.061] (**) |   |-->Monitor "HDMI-0"
[    16.062] (**) |   |-->Device "Card0"
[    16.062] (**) |-->Input Device "Mouse0"
[    16.062] (**) |-->Input Device "Keyboard0"
[    16.062] (==) Automatically adding devices
[    16.062] (==) Automatically enabling devices
[    16.065] (WW) The directory "/usr/share/fonts/X11/cyrillic" does not exist.
[    16.065] 	Entry deleted from font path.
[    16.070] (WW) The directory "/usr/share/fonts/X11/cyrillic" does not exist.
[    16.070] 	Entry deleted from font path.
[    16.070] (**) FontPath set to:
	/usr/share/fonts/X11/misc,
	/usr/share/fonts/X11/100dpi/:unscaled,
	/usr/share/fonts/X11/75dpi/:unscaled,
	/usr/share/fonts/X11/Type1,
	/usr/share/fonts/X11/100dpi,
	/usr/share/fonts/X11/75dpi,
	/var/lib/defoma/x-ttcidfont-conf.d/dirs/TrueType,
	built-ins,
	/usr/share/fonts/X11/misc,
	/usr/share/fonts/X11/100dpi/:unscaled,
	/usr/share/fonts/X11/75dpi/:unscaled,
	/usr/share/fonts/X11/Type1,
	/usr/share/fonts/X11/100dpi,
	/usr/share/fonts/X11/75dpi,
	/var/lib/defoma/x-ttcidfont-conf.d/dirs/TrueType,
	built-ins
[    16.070] (**) ModulePath set to "/usr/lib/xorg/modules"
[    16.070] (WW) Hotplugging is on, devices using drivers 'kbd', 'mouse' or 'vmmouse' will be disabled.
[    16.070] (WW) Disabling Mouse0
[    16.070] (WW) Disabling Keyboard0
[    16.070] (II) Loader magic: 0x7dba00
[    16.070] (II) Module ABI versions:
[    16.070] 	X.Org ANSI C Emulation: 0.4
[    16.070] 	X.Org Video Driver: 10.0
[    16.070] 	X.Org XInput driver : 12.2
[    16.070] 	X.Org Server Extension : 5.0
[    16.072] (--) PCI:*(0:1:5:0) 1002:9610:1458:d000 rev 0, Mem @ 0xd8000000/134217728, 0xfdfe0000/65536, 0xfde00000/1048576, I/O @ 0x0000ee00/256
[    16.072] (--) PCI: (0:3:6:0) 4444:0016:0070:8801 rev 1, Mem @ 0xf8000000/67108864
[    16.072] (--) PCI: (0:3:7:0) 4444:0016:0070:8801 rev 1, Mem @ 0xf4000000/67108864
[    16.072] (II) Open ACPI successful (/var/run/acpid.socket)
[    16.072] (II) "extmod" will be loaded. This was enabled by default and also specified in the config file.
[    16.072] (II) "dbe" will be loaded. This was enabled by default and also specified in the config file.
[    16.072] (II) "glx" will be loaded. This was enabled by default and also specified in the config file.
[    16.072] (II) "record" will be loaded. This was enabled by default and also specified in the config file.
[    16.072] (II) "dri" will be loaded. This was enabled by default and also specified in the config file.
[    16.072] (II) "dri2" will be loaded. This was enabled by default and also specified in the config file.
[    16.072] (II) LoadModule: "dri2"
[    16.075] (II) Loading /usr/lib/xorg/modules/extensions/libdri2.so
[    16.081] (II) Module dri2: vendor="X.Org Foundation"
[    16.081] 	compiled for 1.10.1, module version = 1.2.0
[    16.081] 	ABI class: X.Org Server Extension, version 5.0
[    16.081] (II) Loading extension DRI2
[    16.081] (II) LoadModule: "dbe"
[    16.082] (II) Loading /usr/lib/xorg/modules/extensions/libdbe.so
[    16.082] (II) Module dbe: vendor="X.Org Foundation"
[    16.082] 	compiled for 1.10.1, module version = 1.0.0
[    16.082] 	Module class: X.Org Server Extension
[    16.082] 	ABI class: X.Org Server Extension, version 5.0
[    16.082] (II) Loading extension DOUBLE-BUFFER
[    16.082] (II) LoadModule: "glx"
[    16.083] (II) Loading /usr/lib/xorg/modules/extensions/libglx.so
[    16.086] (II) Module glx: vendor="X.Org Foundation"
[    16.086] 	compiled for 1.10.1, module version = 1.0.0
[    16.086] 	ABI class: X.Org Server Extension, version 5.0
[    16.086] (==) AIGLX enabled
[    16.086] (II) Loading extension GLX
[    16.087] (II) LoadModule: "extmod"
[    16.088] (II) Loading /usr/lib/xorg/modules/extensions/libextmod.so
[    16.090] (II) Module extmod: vendor="X.Org Foundation"
[    16.090] 	compiled for 1.10.1, module version = 1.0.0
[    16.090] 	Module class: X.Org Server Extension
[    16.090] 	ABI class: X.Org Server Extension, version 5.0
[    16.090] (II) Loading extension SELinux
[    16.090] (II) Loading extension MIT-SCREEN-SAVER
[    16.090] (II) Loading extension XFree86-VidModeExtension
[    16.090] (II) Loading extension XFree86-DGA
[    16.090] (II) Loading extension DPMS
[    16.090] (II) Loading extension XVideo
[    16.090] (II) Loading extension XVideo-MotionCompensation
[    16.091] (II) Loading extension X-Resource
[    16.091] (II) LoadModule: "record"
[    16.091] (II) Loading /usr/lib/xorg/modules/extensions/librecord.so
[    16.092] (II) Module record: vendor="X.Org Foundation"
[    16.092] 	compiled for 1.10.1, module version = 1.13.0
[    16.092] 	Module class: X.Org Server Extension
[    16.092] 	ABI class: X.Org Server Extension, version 5.0
[    16.092] (II) Loading extension RECORD
[    16.092] (II) LoadModule: "dri"
[    16.092] (II) Loading /usr/lib/xorg/modules/extensions/libdri.so
[    16.093] (II) Module dri: vendor="X.Org Foundation"
[    16.093] 	compiled for 1.10.1, module version = 1.0.0
[    16.093] 	ABI class: X.Org Server Extension, version 5.0
[    16.093] (II) Loading extension XFree86-DRI
[    16.093] (II) LoadModule: "radeon"
[    16.093] (II) Loading /usr/lib/xorg/modules/drivers/radeon_drv.so
[    16.101] (II) Module radeon: vendor="X.Org Foundation"
[    16.101] 	compiled for 1.10.1, module version = 6.14.1
[    16.101] 	Module class: X.Org Video Driver
[    16.102] 	ABI class: X.Org Video Driver, version 10.0
[    16.102] (II) RADEON: Driver for ATI Radeon chipsets:
	ATI Radeon Mobility X600 (M24) 3150 (PCIE), ATI FireMV 2400 (PCI),
	ATI Radeon Mobility X300 (M24) 3152 (PCIE),
	ATI FireGL M24 GL 3154 (PCIE), ATI FireMV 2400 3155 (PCI),
	ATI Radeon X600 (RV380) 3E50 (PCIE),
	ATI FireGL V3200 (RV380) 3E54 (PCIE), ATI Radeon IGP320 (A3) 4136,
	ATI Radeon IGP330/340/350 (A4) 4137, ATI Radeon 9500 AD (AGP),
	ATI Radeon 9500 AE (AGP), ATI Radeon 9600TX AF (AGP),
	ATI FireGL Z1 AG (AGP), ATI Radeon 9800SE AH (AGP),
	ATI Radeon 9800 AI (AGP), ATI Radeon 9800 AJ (AGP),
	ATI FireGL X2 AK (AGP), ATI Radeon 9600 AP (AGP),
	ATI Radeon 9600SE AQ (AGP), ATI Radeon 9600XT AR (AGP),
	ATI Radeon 9600 AS (AGP), ATI FireGL T2 AT (AGP), ATI Radeon 9650,
	ATI FireGL RV360 AV (AGP), ATI Radeon 7000 IGP (A4+) 4237,
	ATI Radeon 8500 AIW BB (AGP), ATI Radeon IGP320M (U1) 4336,
	ATI Radeon IGP330M/340M/350M (U2) 4337,
	ATI Radeon Mobility 7000 IGP 4437, ATI Radeon 9000/PRO If (AGP/PCI),
	ATI Radeon 9000 Ig (AGP/PCI), ATI Radeon X800 (R420) JH (AGP),
	ATI Radeon X800PRO (R420) JI (AGP),
	ATI Radeon X800SE (R420) JJ (AGP), ATI Radeon X800 (R420) JK (AGP),
	ATI Radeon X800 (R420) JL (AGP), ATI FireGL X3 (R420) JM (AGP),
	ATI Radeon Mobility 9800 (M18) JN (AGP),
	ATI Radeon X800 SE (R420) (AGP), ATI Radeon X800XT (R420) JP (AGP),
	ATI Radeon X800 VE (R420) JT (AGP), ATI Radeon X850 (R480) (AGP),
	ATI Radeon X850 XT (R480) (AGP), ATI Radeon X850 SE (R480) (AGP),
	ATI Radeon X850 PRO (R480) (AGP), ATI Radeon X850 XT PE (R480) (AGP),
	ATI Radeon Mobility M7 LW (AGP),
	ATI Mobility FireGL 7800 M7 LX (AGP),
	ATI Radeon Mobility M6 LY (AGP), ATI Radeon Mobility M6 LZ (AGP),
	ATI FireGL Mobility 9000 (M9) Ld (AGP),
	ATI Radeon Mobility 9000 (M9) Lf (AGP),
	ATI Radeon Mobility 9000 (M9) Lg (AGP), ATI Radeon 9700 Pro ND (AGP),
	ATI Radeon 9700/9500Pro NE (AGP), ATI Radeon 9600TX NF (AGP),
	ATI FireGL X1 NG (AGP), ATI Radeon 9800PRO NH (AGP),
	ATI Radeon 9800 NI (AGP), ATI FireGL X2 NK (AGP),
	ATI Radeon 9800XT NJ (AGP),
	ATI Radeon Mobility 9600/9700 (M10/M11) NP (AGP),
	ATI Radeon Mobility 9600 (M10) NQ (AGP),
	ATI Radeon Mobility 9600 (M11) NR (AGP),
	ATI Radeon Mobility 9600 (M10) NS (AGP),
	ATI FireGL Mobility T2 (M10) NT (AGP),
	ATI FireGL Mobility T2e (M11) NV (AGP), ATI Radeon QD (AGP),
	ATI Radeon QE (AGP), ATI Radeon QF (AGP), ATI Radeon QG (AGP),
	ATI FireGL 8700/8800 QH (AGP), ATI Radeon 8500 QL (AGP),
	ATI Radeon 9100 QM (AGP), ATI Radeon 7500 QW (AGP/PCI),
	ATI Radeon 7500 QX (AGP/PCI), ATI Radeon VE/7000 QY (AGP/PCI),
	ATI Radeon VE/7000 QZ (AGP/PCI), ATI ES1000 515E (PCI),
	ATI Radeon Mobility X300 (M22) 5460 (PCIE),
	ATI Radeon Mobility X600 SE (M24C) 5462 (PCIE),
	ATI FireGL M22 GL 5464 (PCIE), ATI Radeon X800 (R423) UH (PCIE),
	ATI Radeon X800PRO (R423) UI (PCIE),
	ATI Radeon X800LE (R423) UJ (PCIE),
	ATI Radeon X800SE (R423) UK (PCIE),
	ATI Radeon X800 XTP (R430) (PCIE), ATI Radeon X800 XL (R430) (PCIE),
	ATI Radeon X800 SE (R430) (PCIE), ATI Radeon X800 (R430) (PCIE),
	ATI FireGL V7100 (R423) (PCIE), ATI FireGL V5100 (R423) UQ (PCIE),
	ATI FireGL unknown (R423) UR (PCIE),
	ATI FireGL unknown (R423) UT (PCIE),
	ATI Mobility FireGL V5000 (M26) (PCIE),
	ATI Mobility FireGL V5000 (M26) (PCIE),
	ATI Mobility Radeon X700 XL (M26) (PCIE),
	ATI Mobility Radeon X700 (M26) (PCIE),
	ATI Mobility Radeon X700 (M26) (PCIE),
	ATI Radeon X550XTX 5657 (PCIE), ATI Radeon 9100 IGP (A5) 5834,
	ATI Radeon Mobility 9100 IGP (U3) 5835,
	ATI Radeon XPRESS 200 5954 (PCIE),
	ATI Radeon XPRESS 200M 5955 (PCIE), ATI Radeon 9250 5960 (AGP),
	ATI Radeon 9200 5961 (AGP), ATI Radeon 9200 5962 (AGP),
	ATI Radeon 9200SE 5964 (AGP), ATI FireMV 2200 (PCI),
	ATI ES1000 5969 (PCI), ATI Radeon XPRESS 200 5974 (PCIE),
	ATI Radeon XPRESS 200M 5975 (PCIE),
	ATI Radeon XPRESS 200 5A41 (PCIE),
	ATI Radeon XPRESS 200M 5A42 (PCIE),
	ATI Radeon XPRESS 200 5A61 (PCIE),
	ATI Radeon XPRESS 200M 5A62 (PCIE),
	ATI Radeon X300 (RV370) 5B60 (PCIE),
	ATI Radeon X600 (RV370) 5B62 (PCIE),
	ATI Radeon X550 (RV370) 5B63 (PCIE),
	ATI FireGL V3100 (RV370) 5B64 (PCIE),
	ATI FireMV 2200 PCIE (RV370) 5B65 (PCIE),
	ATI Radeon Mobility 9200 (M9+) 5C61 (AGP),
	ATI Radeon Mobility 9200 (M9+) 5C63 (AGP),
	ATI Mobility Radeon X800 XT (M28) (PCIE),
	ATI Mobility FireGL V5100 (M28) (PCIE),
	ATI Mobility Radeon X800 (M28) (PCIE), ATI Radeon X850 5D4C (PCIE),
	ATI Radeon X850 XT PE (R480) (PCIE),
	ATI Radeon X850 SE (R480) (PCIE), ATI Radeon X850 PRO (R480) (PCIE),
	ATI unknown Radeon / FireGL (R480) 5D50 (PCIE),
	ATI Radeon X850 XT (R480) (PCIE),
	ATI Radeon X800XT (R423) 5D57 (PCIE),
	ATI FireGL V5000 (RV410) (PCIE), ATI Radeon X700 XT (RV410) (PCIE),
	ATI Radeon X700 PRO (RV410) (PCIE),
	ATI Radeon X700 SE (RV410) (PCIE), ATI Radeon X700 (RV410) (PCIE),
	ATI Radeon X700 SE (RV410) (PCIE), ATI Radeon X1800,
	ATI Mobility Radeon X1800 XT, ATI Mobility Radeon X1800,
	ATI Mobility FireGL V7200, ATI FireGL V7200, ATI FireGL V5300,
	ATI Mobility FireGL V7100, ATI Radeon X1800, ATI Radeon X1800,
	ATI Radeon X1800, ATI Radeon X1800, ATI Radeon X1800,
	ATI FireGL V7300, ATI FireGL V7350, ATI Radeon X1600, ATI RV505,
	ATI Radeon X1300/X1550, ATI Radeon X1550, ATI M54-GL,
	ATI Mobility Radeon X1400, ATI Radeon X1300/X1550,
	ATI Radeon X1550 64-bit, ATI Mobility Radeon X1300,
	ATI Mobility Radeon X1300, ATI Mobility Radeon X1300,
	ATI Mobility Radeon X1300, ATI Radeon X1300, ATI Radeon X1300,
	ATI RV505, ATI RV505, ATI FireGL V3300, ATI FireGL V3350,
	ATI Radeon X1300, ATI Radeon X1550 64-bit, ATI Radeon X1300/X1550,
	ATI Radeon X1600, ATI Radeon X1300/X1550, ATI Mobility Radeon X1450,
	ATI Radeon X1300/X1550, ATI Mobility Radeon X2300,
	ATI Mobility Radeon X2300, ATI Mobility Radeon X1350,
	ATI Mobility Radeon X1350, ATI Mobility Radeon X1450,
	ATI Radeon X1300, ATI Radeon X1550, ATI Mobility Radeon X1350,
	ATI FireMV 2250, ATI Radeon X1550 64-bit, ATI Radeon X1600,
	ATI Radeon X1650, ATI Radeon X1600, ATI Radeon X1600,
	ATI Mobility FireGL V5200, ATI Mobility Radeon X1600,
	ATI Radeon X1650, ATI Radeon X1650, ATI Radeon X1600,
	ATI Radeon X1300 XT/X1600 Pro, ATI FireGL V3400,
	ATI Mobility FireGL V5250, ATI Mobility Radeon X1700,
	ATI Mobility Radeon X1700 XT, ATI FireGL V5200,
	ATI Mobility Radeon X1700, ATI Radeon X2300HD,
	ATI Mobility Radeon HD 2300, ATI Mobility Radeon HD 2300,
	ATI Radeon X1950, ATI Radeon X1900, ATI Radeon X1950,
	ATI Radeon X1900, ATI Radeon X1900, ATI Radeon X1900,
	ATI Radeon X1900, ATI Radeon X1900, ATI Radeon X1900,
	ATI Radeon X1900, ATI Radeon X1900, ATI Radeon X1900,
	ATI AMD Stream Processor, ATI Radeon X1900, ATI Radeon X1950,
	ATI RV560, ATI RV560, ATI Mobility Radeon X1900, ATI RV560,
	ATI Radeon X1950 GT, ATI RV570, ATI RV570, ATI FireGL V7400,
	ATI RV560, ATI Radeon X1650, ATI Radeon X1650, ATI RV560,
	ATI Radeon 9100 PRO IGP 7834, ATI Radeon Mobility 9200 IGP 7835,
	ATI Radeon X1200, ATI Radeon X1200, ATI Radeon X1200,
	ATI Radeon X1200, ATI Radeon X1200, ATI RS740, ATI RS740M, ATI RS740,
	ATI RS740M, ATI Radeon HD 2900 XT, ATI Radeon HD 2900 XT,
	ATI Radeon HD 2900 XT, ATI Radeon HD 2900 Pro, ATI Radeon HD 2900 GT,
	ATI FireGL V8650, ATI FireGL V8600, ATI FireGL V7600,
	ATI Radeon 4800 Series, ATI Radeon HD 4870 x2,
	ATI Radeon 4800 Series, ATI Radeon HD 4850 x2,
	ATI FirePro V8750 (FireGL), ATI FirePro V7760 (FireGL),
	ATI Mobility RADEON HD 4850, ATI Mobility RADEON HD 4850 X2,
	ATI Radeon 4800 Series, ATI FirePro RV770, AMD FireStream 9270,
	AMD FireStream 9250, ATI FirePro V8700 (FireGL),
	ATI Mobility RADEON HD 4870, ATI Mobility RADEON M98,
	ATI Mobility RADEON HD 4870, ATI Radeon 4800 Series,
	ATI Radeon 4800 Series, ATI FirePro M7750, ATI M98, ATI M98, ATI M98,
	ATI Mobility Radeon HD 4650, ATI Radeon RV730 (AGP),
	ATI Mobility Radeon HD 4670, ATI FirePro M5750,
	ATI Mobility Radeon HD 4670, ATI Radeon RV730 (AGP),
	ATI RV730XT [Radeon HD 4670], ATI RADEON E4600,
	ATI Radeon HD 4600 Series, ATI RV730 PRO [Radeon HD 4650],
	ATI FirePro V7750 (FireGL), ATI FirePro V5700 (FireGL),
	ATI FirePro V3750 (FireGL), ATI Mobility Radeon HD 4830,
	ATI Mobility Radeon HD 4850, ATI FirePro M7740, ATI RV740,
	ATI Radeon HD 4770, ATI Radeon HD 4700 Series, ATI Radeon HD 4770,
	ATI FirePro M5750, ATI RV610, ATI Radeon HD 2400 XT,
	ATI Radeon HD 2400 Pro, ATI Radeon HD 2400 PRO AGP, ATI FireGL V4000,
	ATI RV610, ATI Radeon HD 2350, ATI Mobility Radeon HD 2400 XT,
	ATI Mobility Radeon HD 2400, ATI RADEON E2400, ATI RV610,
	ATI FireMV 2260, ATI RV670, ATI Radeon HD3870,
	ATI Mobility Radeon HD 3850, ATI Radeon HD3850,
	ATI Mobility Radeon HD 3850 X2, ATI RV670,
	ATI Mobility Radeon HD 3870, ATI Mobility Radeon HD 3870 X2,
	ATI Radeon HD3870 X2, ATI FireGL V7700, ATI Radeon HD3850,
	ATI Radeon HD3690, AMD Firestream 9170, ATI Radeon HD 4550,
	ATI Radeon RV710, ATI Radeon RV710, ATI Radeon RV710,
	ATI Radeon HD 4350, ATI Mobility Radeon 4300 Series,
	ATI Mobility Radeon 4500 Series, ATI Mobility Radeon 4500 Series,
	ATI FirePro RG220, ATI Mobility Radeon 4330, ATI RV630,
	ATI Mobility Radeon HD 2600, ATI Mobility Radeon HD 2600 XT,
	ATI Radeon HD 2600 XT AGP, ATI Radeon HD 2600 Pro AGP,
	ATI Radeon HD 2600 XT, ATI Radeon HD 2600 Pro, ATI Gemini RV630,
	ATI Gemini Mobility Radeon HD 2600 XT, ATI FireGL V5600,
	ATI FireGL V3600, ATI Radeon HD 2600 LE,
	ATI Mobility FireGL Graphics Processor, ATI Radeon HD 3470,
	ATI Mobility Radeon HD 3430, ATI Mobility Radeon HD 3400 Series,
	ATI Radeon HD 3450, ATI Radeon HD 3450, ATI Radeon HD 3430,
	ATI Radeon HD 3450, ATI FirePro V3700, ATI FireMV 2450,
	ATI FireMV 2260, ATI FireMV 2260, ATI Radeon HD 3600 Series,
	ATI Radeon HD 3650 AGP, ATI Radeon HD 3600 PRO,
	ATI Radeon HD 3600 XT, ATI Radeon HD 3600 PRO,
	ATI Mobility Radeon HD 3650, ATI Mobility Radeon HD 3670,
	ATI Mobility FireGL V5700, ATI Mobility FireGL V5725,
	ATI Radeon HD 3200 Graphics, ATI Radeon 3100 Graphics,
	ATI Radeon HD 3200 Graphics, ATI Radeon 3100 Graphics,
	ATI Radeon HD 3300 Graphics, ATI Radeon HD 3200 Graphics,
	ATI Radeon 3000 Graphics, ATI Radeon HD 4200, ATI Radeon 4100,
	ATI Mobility Radeon HD 4200, ATI Mobility Radeon 4100,
	ATI Radeon HD 4290, ATI Radeon HD 4250, AMD Radeon HD 6310 Graphics,
	AMD Radeon HD 6310 Graphics, AMD Radeon HD 6250 Graphics,
	AMD Radeon HD 6250 Graphics, CYPRESS,
	ATI FirePro (FireGL) Graphics Adapter,
	ATI FirePro (FireGL) Graphics Adapter,
	ATI FirePro (FireGL) Graphics Adapter, AMD Firestream 9370,
	AMD Firestream 9350, ATI Radeon HD 5800 Series,
	ATI Radeon HD 5800 Series, ATI Radeon HD 5800 Series,
	ATI Radeon HD 5900 Series, ATI Radeon HD 5900 Series,
	ATI Mobility Radeon HD 5800 Series,
	ATI Mobility Radeon HD 5800 Series,
	ATI FirePro (FireGL) Graphics Adapter,
	ATI FirePro (FireGL) Graphics Adapter,
	ATI Mobility Radeon HD 5800 Series, ATI Radeon HD 5700 Series,
	ATI Radeon HD 5700 Series, ATI Radeon HD 5700 Series,
	ATI Mobility Radeon HD 5000 Series,
	ATI Mobility Radeon HD 5000 Series, ATI Mobility Radeon HD 5570,
	ATI FirePro (FireGL) Graphics Adapter,
	ATI FirePro (FireGL) Graphics Adapter, ATI Radeon HD 5670,
	ATI Radeon HD 5570, ATI Radeon HD 5500 Series, REDWOOD,
	ATI Mobility Radeon HD 5000 Series,
	ATI Mobility Radeon HD 5000 Series, ATI Mobility Radeon Graphics,
	ATI Mobility Radeon Graphics, CEDAR,
	ATI FirePro (FireGL) Graphics Adapter,
	ATI FirePro (FireGL) Graphics Adapter, ATI FirePro 2270, CEDAR,
	ATI Radeon HD 5450, CEDAR, CAYMAN, CAYMAN, CAYMAN, CAYMAN, CAYMAN,
	CAYMAN, CAYMAN, CAYMAN, CAYMAN, CAYMAN, AMD Radeon HD 6900 Series,
	AMD Radeon HD 6900 Series, CAYMAN, CAYMAN,
	AMD Radeon HD 6900M Series, Mobility Radeon HD 6000 Series, BARTS,
	BARTS, Mobility Radeon HD 6000 Series,
	Mobility Radeon HD 6000 Series, BARTS, BARTS, BARTS, BARTS,
	AMD Radeon HD 6800 Series, AMD Radeon HD 6800 Series, TURKS, TURKS,
	TURKS, TURKS, TURKS, TURKS, TURKS, TURKS, TURKS, TURKS, TURKS, TURKS,
	TURKS, CAICOS, CAICOS, CAICOS, CAICOS, CAICOS, CAICOS, CAICOS,
	CAICOS, CAICOS, CAICOS, CAICOS
[    16.111] (--) using VT number 2

[    16.133] (II) Loading /usr/lib/xorg/modules/drivers/radeon_drv.so
[    16.133] (II) [KMS] Kernel modesetting enabled.
[    16.134] (==) RADEON(0): Depth 24, (--) framebuffer bpp 32
[    16.134] (II) RADEON(0): Pixel depth = 24 bits stored in 4 bytes (32 bpp pixmaps)
[    16.134] (==) RADEON(0): Default visual is TrueColor
[    16.134] (==) RADEON(0): RGB weight 888
[    16.134] (II) RADEON(0): Using 8 bits per RGB (8 bit DAC)
[    16.134] (--) RADEON(0): Chipset: "ATI Radeon HD 3200 Graphics" (ChipID = 0x9610)
[    16.134] (II) RADEON(0): PCI card detected
[    16.134] drmOpenDevice: node name is /dev/dri/card0
[    16.134] drmOpenDevice: open result is 9, (OK)
[    16.134] drmOpenByBusid: Searching for BusID pci:0000:01:05.0
[    16.134] drmOpenDevice: node name is /dev/dri/card0
[    16.134] drmOpenDevice: open result is 9, (OK)
[    16.134] drmOpenByBusid: drmOpenMinor returns 9
[    16.134] drmOpenByBusid: drmGetBusid reports pci:0000:01:05.0
[    16.134] (II) Loading sub module "exa"
[    16.134] (II) LoadModule: "exa"
[    16.134] (II) Loading /usr/lib/xorg/modules/libexa.so
[    16.136] (II) Module exa: vendor="X.Org Foundation"
[    16.136] 	compiled for 1.10.1, module version = 2.5.0
[    16.136] 	ABI class: X.Org Video Driver, version 10.0
[    16.136] (II) RADEON(0): KMS Color Tiling: disabled
[    16.136] (II) RADEON(0): KMS Pageflipping: enabled
[    16.136] (II) RADEON(0): SwapBuffers wait for vsync: enabled
[    16.150] (II) RADEON(0): Output VGA-0 using monitor section VGA-0
[    16.150] (**) RADEON(0): Option "Ignore" "true"
[    16.255] (II) RADEON(0): Output HDMI-0 using monitor section HDMI-0
[    16.359] (II) RADEON(0): EDID for output HDMI-0
[    16.359] (II) RADEON(0): Manufacturer: BNQ  Model: 790e  Serial#: 21573
[    16.359] (II) RADEON(0): Year: 2009  Week: 6
[    16.359] (II) RADEON(0): EDID Version: 1.3
[    16.359] (II) RADEON(0): Digital Display Input
[    16.359] (II) RADEON(0): Max Image Size [cm]: horiz.: 48  vert.: 27
[    16.359] (II) RADEON(0): Gamma: 2.20
[    16.359] (II) RADEON(0): DPMS capabilities: Off
[    16.359] (II) RADEON(0): Supported color encodings: RGB 4:4:4 YCrCb 4:4:4 
[    16.359] (II) RADEON(0): Default color space is primary color space
[    16.359] (II) RADEON(0): First detailed timing is preferred mode
[    16.359] (II) RADEON(0): redX: 0.640 redY: 0.330   greenX: 0.300 greenY: 0.600
[    16.359] (II) RADEON(0): blueX: 0.150 blueY: 0.060   whiteX: 0.313 whiteY: 0.329
[    16.359] (II) RADEON(0): Supported established timings:
[    16.359] (II) RADEON(0): 720x400@70Hz
[    16.359] (II) RADEON(0): 640x480@60Hz
[    16.359] (II) RADEON(0): 640x480@67Hz
[    16.359] (II) RADEON(0): 640x480@72Hz
[    16.359] (II) RADEON(0): 640x480@75Hz
[    16.359] (II) RADEON(0): 800x600@56Hz
[    16.359] (II) RADEON(0): 800x600@60Hz
[    16.359] (II) RADEON(0): 800x600@72Hz
[    16.359] (II) RADEON(0): 800x600@75Hz
[    16.359] (II) RADEON(0): 832x624@75Hz
[    16.360] (II) RADEON(0): 1024x768@60Hz
[    16.360] (II) RADEON(0): 1024x768@70Hz
[    16.360] (II) RADEON(0): 1024x768@75Hz
[    16.360] (II) RADEON(0): 1280x1024@75Hz
[    16.360] (II) RADEON(0): 1152x864@75Hz
[    16.360] (II) RADEON(0): Manufacturer's mask: 0
[    16.360] (II) RADEON(0): Supported standard timings:
[    16.360] (II) RADEON(0): #0: hsize: 1280  vsize 720  refresh: 60  vid: 49281
[    16.360] (II) RADEON(0): #1: hsize: 1280  vsize 960  refresh: 60  vid: 16513
[    16.360] (II) RADEON(0): #2: hsize: 1280  vsize 1024  refresh: 60  vid: 32897
[    16.360] (II) RADEON(0): #3: hsize: 1440  vsize 900  refresh: 60  vid: 149
[    16.360] (II) RADEON(0): #4: hsize: 1600  vsize 1200  refresh: 60  vid: 16553
[    16.360] (II) RADEON(0): #5: hsize: 1680  vsize 1050  refresh: 60  vid: 179
[    16.360] (II) RADEON(0): #6: hsize: 1920  vsize 1080  refresh: 60  vid: 49361
[    16.360] (II) RADEON(0): Supported detailed timing:
[    16.360] (II) RADEON(0): clock: 138.5 MHz   Image Size:  480 x 270 mm
[    16.360] (II) RADEON(0): h_active: 1920  h_sync: 1968  h_sync_end 2000 h_blank_end 2080 h_border: 0
[    16.360] (II) RADEON(0): v_active: 1080  v_sync: 1083  v_sync_end 1088 v_blanking: 1111 v_border: 0
[    16.360] (II) RADEON(0): Ranges: V min: 55 V max: 85 Hz, H min: 30 H max: 83 kHz, PixClock max 215 MHz
[    16.360] (II) RADEON(0): Monitor name: BENQ E2400HD
[    16.360] (II) RADEON(0): Serial No: 22900384019
[    16.360] (II) RADEON(0): Supported detailed timing:
[    16.360] (II) RADEON(0): clock: 27.0 MHz   Image Size:  480 x 270 mm
[    16.360] (II) RADEON(0): h_active: 720  h_sync: 736  h_sync_end 798 h_blank_end 858 h_border: 0
[    16.360] (II) RADEON(0): v_active: 480  v_sync: 489  v_sync_end 495 v_blanking: 525 v_border: 0
[    16.360] (II) RADEON(0): Supported detailed timing:
[    16.360] (II) RADEON(0): clock: 74.2 MHz   Image Size:  480 x 270 mm
[    16.360] (II) RADEON(0): h_active: 1280  h_sync: 1390  h_sync_end 1430 h_blank_end 1650 h_border: 0
[    16.360] (II) RADEON(0): v_active: 720  v_sync: 725  v_sync_end 730 v_blanking: 750 v_border: 0
[    16.360] (II) RADEON(0): Supported detailed timing:
[    16.360] (II) RADEON(0): clock: 74.2 MHz   Image Size:  480 x 270 mm
[    16.360] (II) RADEON(0): h_active: 1280  h_sync: 1720  h_sync_end 1760 h_blank_end 1980 h_border: 0
[    16.360] (II) RADEON(0): v_active: 720  v_sync: 725  v_sync_end 730 v_blanking: 750 v_border: 0
[    16.360] (II) RADEON(0): Supported detailed timing:
[    16.360] (II) RADEON(0): clock: 27.0 MHz   Image Size:  480 x 270 mm
[    16.360] (II) RADEON(0): h_active: 720  h_sync: 732  h_sync_end 796 h_blank_end 864 h_border: 0
[    16.360] (II) RADEON(0): v_active: 576  v_sync: 581  v_sync_end 586 v_blanking: 625 v_border: 0
[    16.360] (II) RADEON(0): Supported detailed timing:
[    16.360] (II) RADEON(0): clock: 27.0 MHz   Image Size:  480 x 270 mm
[    16.360] (II) RADEON(0): h_active: 1440  h_sync: 1464  h_sync_end 1590 h_blank_end 1728 h_border: 0
[    16.360] (II) RADEON(0): v_active: 288  v_sync: 290  v_sync_end 293 v_blanking: 312 v_border: 0
[    16.360] (II) RADEON(0): Number of EDID sections to follow: 1
[    16.360] (II) RADEON(0): EDID (in hex):
[    16.360] (II) RADEON(0): 	00ffffffffffff0009d10e7945540000
[    16.360] (II) RADEON(0): 	0613010380301b782eee95a3544c9926
[    16.360] (II) RADEON(0): 	0f5054bfef8081c0814081809500a940
[    16.360] (II) RADEON(0): 	b300d1c001011a3680a070381f403020
[    16.360] (II) RADEON(0): 	3500e00e1100001e000000fd0037551e
[    16.360] (II) RADEON(0): 	5315000a202020202020000000fc0042
[    16.360] (II) RADEON(0): 	454e5120453234303048440a000000ff
[    16.360] (II) RADEON(0): 	0032323930303338343031390a20011c
[    16.360] (II) RADEON(0): 	020321714c1005041303120716011415
[    16.360] (II) RADEON(0): 	1f230907078301000067030c00100038
[    16.360] (II) RADEON(0): 	2d8c0ad08a20e02d10103e9600e00e11
[    16.360] (II) RADEON(0): 	000018011d007251d01e206e285500e0
[    16.360] (II) RADEON(0): 	0e1100001e011d00bc52d01e20b82855
[    16.360] (II) RADEON(0): 	40e00e1100001e8c0ad090204031200c
[    16.360] (II) RADEON(0): 	405500e00e110000188c0aa020512018
[    16.360] (II) RADEON(0): 	10187e2300e00e110000980000000044
[    16.360] (II) RADEON(0): EDID vendor "BNQ", prod id 30990
[    16.361] (II) RADEON(0): Using EDID range info for horizontal sync
[    16.361] (II) RADEON(0): Using EDID range info for vertical refresh
[    16.361] (II) RADEON(0): Printing DDC gathered Modelines:
[    16.361] (II) RADEON(0): Modeline "1920x1080"x0.0  138.50  1920 1968 2000 2080  1080 1083 1088 1111 +hsync +vsync (66.6 kHz)
[    16.361] (II) RADEON(0): Modeline "720x480"x0.0   27.00  720 736 798 858  480 489 495 525 -hsync -vsync (31.5 kHz)
[    16.361] (II) RADEON(0): Modeline "1280x720"x0.0   74.25  1280 1390 1430 1650  720 725 730 750 +hsync +vsync (45.0 kHz)
[    16.361] (II) RADEON(0): Modeline "1280x720"x0.0   74.25  1280 1720 1760 1980  720 725 730 750 +hsync +vsync (37.5 kHz)
[    16.361] (II) RADEON(0): Modeline "720x576"x0.0   27.00  720 732 796 864  576 581 586 625 -hsync -vsync (31.2 kHz)
[    16.361] (II) RADEON(0): Modeline "1440x576i"x0.0   27.00  1440 1464 1590 1728  576 580 586 625 interlace -hsync -vsync (15.6 kHz)
[    16.361] (II) RADEON(0): Modeline "800x600"x0.0   40.00  800 840 968 1056  600 601 605 628 +hsync +vsync (37.9 kHz)
[    16.361] (II) RADEON(0): Modeline "800x600"x0.0   36.00  800 824 896 1024  600 601 603 625 +hsync +vsync (35.2 kHz)
[    16.361] (II) RADEON(0): Modeline "640x480"x0.0   31.50  640 656 720 840  480 481 484 500 -hsync -vsync (37.5 kHz)
[    16.361] (II) RADEON(0): Modeline "640x480"x0.0   31.50  640 664 704 832  480 489 492 520 -hsync -vsync (37.9 kHz)
[    16.361] (II) RADEON(0): Modeline "640x480"x0.0   30.24  640 704 768 864  480 483 486 525 -hsync -vsync (35.0 kHz)
[    16.361] (II) RADEON(0): Modeline "640x480"x0.0   25.18  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz)
[    16.361] (II) RADEON(0): Modeline "720x400"x0.0   28.32  720 738 846 900  400 412 414 449 -hsync +vsync (31.5 kHz)
[    16.361] (II) RADEON(0): Modeline "1280x1024"x0.0  135.00  1280 1296 1440 1688  1024 1025 1028 1066 +hsync +vsync (80.0 kHz)
[    16.361] (II) RADEON(0): Modeline "1024x768"x0.0   78.75  1024 1040 1136 1312  768 769 772 800 +hsync +vsync (60.0 kHz)
[    16.361] (II) RADEON(0): Modeline "1024x768"x0.0   75.00  1024 1048 1184 1328  768 771 777 806 -hsync -vsync (56.5 kHz)
[    16.361] (II) RADEON(0): Modeline "1024x768"x0.0   65.00  1024 1048 1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz)
[    16.361] (II) RADEON(0): Modeline "832x624"x0.0   57.28  832 864 928 1152  624 625 628 667 -hsync -vsync (49.7 kHz)
[    16.361] (II) RADEON(0): Modeline "800x600"x0.0   49.50  800 816 896 1056  600 601 604 625 +hsync +vsync (46.9 kHz)
[    16.361] (II) RADEON(0): Modeline "800x600"x0.0   50.00  800 856 976 1040  600 637 643 666 +hsync +vsync (48.1 kHz)
[    16.361] (II) RADEON(0): Modeline "1152x864"x0.0  108.00  1152 1216 1344 1600  864 865 868 900 +hsync +vsync (67.5 kHz)
[    16.361] (II) RADEON(0): Modeline "1280x720"x60.0   74.48  1280 1336 1472 1664  720 721 724 746 -hsync +vsync (44.8 kHz)
[    16.361] (II) RADEON(0): Modeline "1280x960"x0.0  108.00  1280 1376 1488 1800  960 961 964 1000 +hsync +vsync (60.0 kHz)
[    16.361] (II) RADEON(0): Modeline "1280x1024"x0.0  108.00  1280 1328 1440 1688  1024 1025 1028 1066 +hsync +vsync (64.0 kHz)
[    16.361] (II) RADEON(0): Modeline "1440x900"x0.0   88.75  1440 1488 1520 1600  900 903 909 926 +hsync -vsync (55.5 kHz)
[    16.361] (II) RADEON(0): Modeline "1600x1200"x0.0  162.00  1600 1664 1856 2160  1200 1201 1204 1250 +hsync +vsync (75.0 kHz)
[    16.361] (II) RADEON(0): Modeline "1680x1050"x0.0  119.00  1680 1728 1760 1840  1050 1053 1059 1080 +hsync -vsync (64.7 kHz)
[    16.361] (II) RADEON(0): Modeline "1920x1080"x60.0  172.80  1920 2040 2248 2576  1080 1081 1084 1118 -hsync +vsync (67.1 kHz)
[    16.361] (II) RADEON(0): Modeline "1440x480i"x0.0   27.00  1440 1478 1602 1716  480 488 494 525 interlace -hsync -vsync (15.7 kHz)
[    16.361] (II) RADEON(0): Modeline "1920x1080i"x0.0   74.25  1920 2008 2052 2200  1080 1084 1094 1125 interlace +hsync +vsync (33.8 kHz)
[    16.361] (II) RADEON(0): Modeline "1920x1080i"x0.0   74.25  1920 2448 2492 2640  1080 1084 1094 1125 interlace +hsync +vsync (28.1 kHz)
[    16.361] (II) RADEON(0): Modeline "1440x240"x0.0   27.00  1440 1478 1602 1716  240 244 247 262 -hsync -vsync (15.7 kHz)
[    16.361] (II) RADEON(0): Modeline "1440x288"x0.0   27.00  1440 1464 1590 1728  288 290 293 312 -hsync -vsync (15.6 kHz)
[    16.361] (II) RADEON(0): Modeline "1920x1080"x0.0   74.25  1920 2558 2602 2750  1080 1084 1089 1125 +hsync +vsync (27.0 kHz)
[    16.361] (II) RADEON(0): Printing probed modes for output HDMI-0
[    16.361] (II) RADEON(0): Modeline "1920x1080"x59.9  138.50  1920 1968 2000 2080  1080 1083 1088 1111 +hsync +vsync (66.6 kHz)
[    16.361] (II) RADEON(0): Modeline "1600x1200"x60.0  162.00  1600 1664 1856 2160  1200 1201 1204 1250 +hsync +vsync (75.0 kHz)
[    16.361] (II) RADEON(0): Modeline "1680x1050"x60.0  146.25  1680 1784 1960 2240  1050 1053 1059 1089 -hsync +vsync (65.3 kHz)
[    16.361] (II) RADEON(0): Modeline "1280x1024"x75.0  135.00  1280 1296 1440 1688  1024 1025 1028 1066 +hsync +vsync (80.0 kHz)
[    16.361] (II) RADEON(0): Modeline "1280x1024"x60.0  108.00  1280 1328 1440 1688  1024 1025 1028 1066 +hsync +vsync (64.0 kHz)
[    16.361] (II) RADEON(0): Modeline "1440x900"x59.9  106.50  1440 1520 1672 1904  900 903 909 934 -hsync +vsync (55.9 kHz)
[    16.361] (II) RADEON(0): Modeline "1280x960"x60.0  108.00  1280 1376 1488 1800  960 961 964 1000 +hsync +vsync (60.0 kHz)
[    16.361] (II) RADEON(0): Modeline "1152x864"x75.0  108.00  1152 1216 1344 1600  864 865 868 900 +hsync +vsync (67.5 kHz)
[    16.362] (II) RADEON(0): Modeline "1280x720"x60.0   74.44  1280 1336 1472 1664  720 721 724 746 -hsync +vsync (44.7 kHz)
[    16.362] (II) RADEON(0): Modeline "1024x768"x75.1   78.80  1024 1040 1136 1312  768 769 772 800 +hsync +vsync (60.1 kHz)
[    16.362] (II) RADEON(0): Modeline "1024x768"x70.1   75.00  1024 1048 1184 1328  768 771 777 806 -hsync -vsync (56.5 kHz)
[    16.362] (II) RADEON(0): Modeline "1024x768"x60.0   65.00  1024 1048 1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz)
[    16.362] (II) RADEON(0): Modeline "832x624"x74.6   57.28  832 864 928 1152  624 625 628 667 -hsync -vsync (49.7 kHz)
[    16.362] (II) RADEON(0): Modeline "800x600"x72.2   50.00  800 856 976 1040  600 637 643 666 +hsync +vsync (48.1 kHz)
[    16.362] (II) RADEON(0): Modeline "800x600"x75.0   49.50  800 816 896 1056  600 601 604 625 +hsync +vsync (46.9 kHz)
[    16.362] (II) RADEON(0): Modeline "800x600"x60.3   40.00  800 840 968 1056  600 601 605 628 +hsync +vsync (37.9 kHz)
[    16.362] (II) RADEON(0): Modeline "800x600"x56.2   36.00  800 824 896 1024  600 601 603 625 +hsync +vsync (35.2 kHz)
[    16.362] (II) RADEON(0): Modeline "720x480"x59.9   27.00  720 736 798 858  480 489 495 525 -hsync -vsync (31.5 kHz)
[    16.362] (II) RADEON(0): Modeline "640x480"x72.8   31.50  640 664 704 832  480 489 491 520 -hsync -vsync (37.9 kHz)
[    16.362] (II) RADEON(0): Modeline "640x480"x75.0   31.50  640 656 720 840  480 481 484 500 -hsync -vsync (37.5 kHz)
[    16.362] (II) RADEON(0): Modeline "640x480"x66.7   30.24  640 704 768 864  480 483 486 525 -hsync -vsync (35.0 kHz)
[    16.362] (II) RADEON(0): Modeline "640x480"x60.0   25.20  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz)
[    16.362] (II) RADEON(0): Modeline "720x400"x70.1   28.32  720 738 846 900  400 412 414 449 -hsync +vsync (31.5 kHz)
[    16.362] (II) RADEON(0): Output HDMI-0 connected
[    16.362] (II) RADEON(0): Using exact sizes for initial modes
[    16.362] (II) RADEON(0): Output HDMI-0 using initial mode 1920x1080
[    16.362] (II) RADEON(0): Using default gamma of (1.0, 1.0, 1.0) unless otherwise stated.
[    16.362] (II) RADEON(0): mem size init: gart size :1fdff000 vram size: s:8000000 visible:77d7000
[    16.362] (II) RADEON(0): EXA: Driver will allow EXA pixmaps in VRAM
[    16.362] (**) RADEON(0): Display dimensions: (480, 270) mm
[    16.362] (**) RADEON(0): DPI set to (101, 101)
[    16.362] (II) Loading sub module "fb"
[    16.362] (II) LoadModule: "fb"
[    16.362] (II) Loading /usr/lib/xorg/modules/libfb.so
[    16.364] (II) Module fb: vendor="X.Org Foundation"
[    16.364] 	compiled for 1.10.1, module version = 1.0.0
[    16.364] 	ABI class: X.Org ANSI C Emulation, version 0.4
[    16.364] (II) Loading sub module "ramdac"
[    16.364] (II) LoadModule: "ramdac"
[    16.364] (II) Module "ramdac" already built-in
[    16.364] (--) Depth 24 pixmap format is 32 bpp
[    16.364] (II) RADEON(0): [DRI2] Setup complete
[    16.364] (II) RADEON(0): [DRI2]   DRI driver: r600
[    16.364] (II) RADEON(0): Front buffer size: 8100K
[    16.364] (II) RADEON(0): VRAM usage limit set to 103154K
[    16.367] (==) RADEON(0): Backing store disabled
[    16.367] (II) RADEON(0): Direct rendering enabled
[    16.369] (II) RADEON(0): Setting EXA maxPitchBytes
[    16.369] (II) EXA(0): Driver allocated offscreen pixmaps
[    16.369] (II) EXA(0): Driver registered support for the following operations:
[    16.369] (II)         Solid
[    16.369] (II)         Copy
[    16.369] (II)         Composite (RENDER acceleration)
[    16.369] (II)         UploadToScreen
[    16.369] (II)         DownloadFromScreen
[    16.369] (II) RADEON(0): Acceleration enabled
[    16.369] (==) RADEON(0): DPMS enabled
[    16.369] (==) RADEON(0): Silken mouse enabled
[    16.371] (II) RADEON(0): Set up textured video
[    16.371] (II) RADEON(0): RandR 1.2 enabled, ignore the following RandR disabled message.
[    16.404] (WW) RADEON(0): Option "ConnectedMonitor" is not used
[    16.404] (WW) RADEON(0): Option "HDMI" is not used
[    16.404] (--) RandR disabled
[    16.404] (II) Initializing built-in extension Generic Event Extension
[    16.404] (II) Initializing built-in extension SHAPE
[    16.404] (II) Initializing built-in extension MIT-SHM
[    16.404] (II) Initializing built-in extension XInputExtension
[    16.404] (II) Initializing built-in extension XTEST
[    16.404] (II) Initializing built-in extension BIG-REQUESTS
[    16.404] (II) Initializing built-in extension SYNC
[    16.404] (II) Initializing built-in extension XKEYBOARD
[    16.404] (II) Initializing built-in extension XC-MISC
[    16.404] (II) Initializing built-in extension SECURITY
[    16.404] (II) Initializing built-in extension XINERAMA
[    16.404] (II) Initializing built-in extension XFIXES
[    16.404] (II) Initializing built-in extension RENDER
[    16.404] (II) Initializing built-in extension RANDR
[    16.404] (II) Initializing built-in extension COMPOSITE
[    16.404] (II) Initializing built-in extension DAMAGE
[    16.405] (II) SELinux: Disabled on system
[    16.429] (II) AIGLX: enabled GLX_MESA_copy_sub_buffer
[    16.429] (II) AIGLX: enabled GLX_INTEL_swap_event
[    16.429] (II) AIGLX: enabled GLX_SGI_swap_control and GLX_MESA_swap_control
[    16.429] (II) AIGLX: enabled GLX_SGI_make_current_read
[    16.429] (II) AIGLX: GLX_EXT_texture_from_pixmap backed by buffer objects
[    16.429] (II) AIGLX: Loaded and initialized /usr/lib/dri/r600_dri.so
[    16.430] (II) GLX: Initialized DRI2 GL provider for screen 0
[    16.431] (II) RADEON(0): Setting screen physical size to 508 x 285
[    16.544] (II) config/udev: Adding input device Power Button (/dev/input/event1)
[    16.544] (**) Power Button: Applying InputClass "evdev keyboard catchall"
[    16.544] (II) LoadModule: "evdev"
[    16.544] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    16.545] (II) Module evdev: vendor="X.Org Foundation"
[    16.545] 	compiled for 1.10.1, module version = 2.6.0
[    16.545] 	Module class: X.Org XInput Driver
[    16.545] 	ABI class: X.Org XInput driver, version 12.2
[    16.545] (II) Using input driver 'evdev' for 'Power Button'
[    16.545] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    16.545] (**) Power Button: always reports core events
[    16.545] (**) Power Button: Device: "/dev/input/event1"
[    16.550] (--) Power Button: Found keys
[    16.550] (II) Power Button: Configuring as keyboard
[    16.550] (**) Option "config_info" "udev:/sys/devices/LNXSYSTM:00/LNXPWRBN:00/input/input1/event1"
[    16.550] (II) XINPUT: Adding extended input device "Power Button" (type: KEYBOARD)
[    16.550] (**) Option "xkb_rules" "evdev"
[    16.550] (**) Option "xkb_model" "pc104"
[    16.550] (**) Option "xkb_layout" "us"
[    16.585] (II) config/udev: Adding input device Power Button (/dev/input/event0)
[    16.585] (**) Power Button: Applying InputClass "evdev keyboard catchall"
[    16.585] (II) Using input driver 'evdev' for 'Power Button'
[    16.586] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    16.586] (**) Power Button: always reports core events
[    16.586] (**) Power Button: Device: "/dev/input/event0"
[    16.590] (--) Power Button: Found keys
[    16.590] (II) Power Button: Configuring as keyboard
[    16.590] (**) Option "config_info" "udev:/sys/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0/event0"
[    16.590] (II) XINPUT: Adding extended input device "Power Button" (type: KEYBOARD)
[    16.590] (**) Option "xkb_rules" "evdev"
[    16.590] (**) Option "xkb_model" "pc104"
[    16.590] (**) Option "xkb_layout" "us"
[    16.595] (II) config/udev: Adding input device LITE-ON Technology USB NetVista Full Width Keyboard. (/dev/input/event4)
[    16.595] (**) LITE-ON Technology USB NetVista Full Width Keyboard.: Applying InputClass "evdev keyboard catchall"
[    16.595] (II) Using input driver 'evdev' for 'LITE-ON Technology USB NetVista Full Width Keyboard.'
[    16.595] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    16.595] (**) LITE-ON Technology USB NetVista Full Width Keyboard.: always reports core events
[    16.595] (**) LITE-ON Technology USB NetVista Full Width Keyboard.: Device: "/dev/input/event4"
[    16.601] (--) LITE-ON Technology USB NetVista Full Width Keyboard.: Found keys
[    16.601] (II) LITE-ON Technology USB NetVista Full Width Keyboard.: Configuring as keyboard
[    16.601] (**) Option "config_info" "udev:/sys/devices/pci0000:00/0000:00:12.1/usb4/4-2/4-2:1.0/input/input4/event4"
[    16.601] (II) XINPUT: Adding extended input device "LITE-ON Technology USB NetVista Full Width Keyboard." (type: KEYBOARD)
[    16.601] (**) Option "xkb_rules" "evdev"
[    16.601] (**) Option "xkb_model" "pc104"
[    16.601] (**) Option "xkb_layout" "us"
[    16.602] (II) config/udev: Adding input device Logitech USB Receiver (/dev/input/event5)
[    16.603] (**) Logitech USB Receiver: Applying InputClass "evdev keyboard catchall"
[    16.603] (II) Using input driver 'evdev' for 'Logitech USB Receiver'
[    16.603] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    16.603] (**) Logitech USB Receiver: always reports core events
[    16.603] (**) Logitech USB Receiver: Device: "/dev/input/event5"
[    16.608] (--) Logitech USB Receiver: Found keys
[    16.608] (II) Logitech USB Receiver: Configuring as keyboard
[    16.608] (**) Option "config_info" "udev:/sys/devices/pci0000:00/0000:00:12.1/usb4/4-3/4-3:1.0/input/input5/event5"
[    16.608] (II) XINPUT: Adding extended input device "Logitech USB Receiver" (type: KEYBOARD)
[    16.608] (**) Option "xkb_rules" "evdev"
[    16.608] (**) Option "xkb_model" "pc104"
[    16.608] (**) Option "xkb_layout" "us"
[    16.608] (II) config/udev: Adding input device Logitech USB Receiver (/dev/input/event6)
[    16.608] (**) Logitech USB Receiver: Applying InputClass "evdev pointer catchall"
[    16.608] (**) Logitech USB Receiver: Applying InputClass "evdev keyboard catchall"
[    16.609] (II) Using input driver 'evdev' for 'Logitech USB Receiver'
[    16.609] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[    16.609] (**) Logitech USB Receiver: always reports core events
[    16.609] (**) Logitech USB Receiver: Device: "/dev/input/event6"
[    16.614] (--) Logitech USB Receiver: Found 12 mouse buttons
[    16.614] (--) Logitech USB Receiver: Found scroll wheel(s)
[    16.614] (--) Logitech USB Receiver: Found relative axes
[    16.614] (--) Logitech USB Receiver: Found x and y relative axes
[    16.614] (--) Logitech USB Receiver: Found absolute axes
[    16.614] (--) Logitech USB Receiver: Found keys
[    16.614] (II) Logitech USB Receiver: Configuring as mouse
[    16.614] (II) Logitech USB Receiver: Configuring as keyboard
[    16.614] (II) Logitech USB Receiver: Adding scrollwheel support
[    16.614] (**) Logitech USB Receiver: YAxisMapping: buttons 4 and 5
[    16.614] (**) Logitech USB Receiver: EmulateWheelButton: 4, EmulateWheelInertia: 10, EmulateWheelTimeout: 200
[    16.614] (**) Option "config_info" "udev:/sys/devices/pci0000:00/0000:00:12.1/usb4/4-3/4-3:1.1/input/input6/event6"
[    16.614] (II) XINPUT: Adding extended input device "Logitech USB Receiver" (type: KEYBOARD)
[    16.614] (**) Option "xkb_rules" "evdev"
[    16.614] (**) Option "xkb_model" "pc104"
[    16.614] (**) Option "xkb_layout" "us"
[    16.614] (II) Logitech USB Receiver: initialized for relative axes.
[    16.614] (WW) Logitech USB Receiver: ignoring absolute axes.
[    16.614] (**) Logitech USB Receiver: (accel) keeping acceleration scheme 1
[    16.614] (**) Logitech USB Receiver: (accel) acceleration profile 0
[    16.614] (**) Logitech USB Receiver: (accel) acceleration factor: 2.000
[    16.614] (**) Logitech USB Receiver: (accel) acceleration threshold: 4
[    16.615] (II) config/udev: Adding input device Logitech USB Receiver (/dev/input/mouse0)
[    16.615] (II) No input driver/identifier specified (ignoring)
[    16.618] (II) config/udev: Adding input device HDA ATI SB Headphone (/dev/input/event3)
[    16.618] (II) No input driver/identifier specified (ignoring)
[    16.620] (II) config/udev: Adding input device PC Speaker (/dev/input/event2)
[    16.620] (II) No input driver/identifier specified (ignoring)
[    24.893] (II) RADEON(0): EDID vendor "BNQ", prod id 30990
[    24.894] (II) RADEON(0): Using hsync ranges from config file
[    24.894] (II) RADEON(0): Using vrefresh ranges from config file
[    24.894] (II) RADEON(0): Printing DDC gathered Modelines:
[    24.894] (II) RADEON(0): Modeline "1920x1080"x0.0  138.50  1920 1968 2000 2080  1080 1083 1088 1111 +hsync +vsync (66.6 kHz)
[    24.894] (II) RADEON(0): Modeline "720x480"x0.0   27.00  720 736 798 858  480 489 495 525 -hsync -vsync (31.5 kHz)
[    24.894] (II) RADEON(0): Modeline "1280x720"x0.0   74.25  1280 1390 1430 1650  720 725 730 750 +hsync +vsync (45.0 kHz)
[    24.894] (II) RADEON(0): Modeline "1280x720"x0.0   74.25  1280 1720 1760 1980  720 725 730 750 +hsync +vsync (37.5 kHz)
[    24.894] (II) RADEON(0): Modeline "720x576"x0.0   27.00  720 732 796 864  576 581 586 625 -hsync -vsync (31.2 kHz)
[    24.894] (II) RADEON(0): Modeline "1440x576i"x0.0   27.00  1440 1464 1590 1728  576 580 586 625 interlace -hsync -vsync (15.6 kHz)
[    24.894] (II) RADEON(0): Modeline "800x600"x0.0   40.00  800 840 968 1056  600 601 605 628 +hsync +vsync (37.9 kHz)
[    24.894] (II) RADEON(0): Modeline "800x600"x0.0   36.00  800 824 896 1024  600 601 603 625 +hsync +vsync (35.2 kHz)
[    24.894] (II) RADEON(0): Modeline "640x480"x0.0   31.50  640 656 720 840  480 481 484 500 -hsync -vsync (37.5 kHz)
[    24.894] (II) RADEON(0): Modeline "640x480"x0.0   31.50  640 664 704 832  480 489 492 520 -hsync -vsync (37.9 kHz)
[    24.894] (II) RADEON(0): Modeline "640x480"x0.0   30.24  640 704 768 864  480 483 486 525 -hsync -vsync (35.0 kHz)
[    24.894] (II) RADEON(0): Modeline "640x480"x0.0   25.18  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz)
[    24.894] (II) RADEON(0): Modeline "720x400"x0.0   28.32  720 738 846 900  400 412 414 449 -hsync +vsync (31.5 kHz)
[    24.894] (II) RADEON(0): Modeline "1280x1024"x0.0  135.00  1280 1296 1440 1688  1024 1025 1028 1066 +hsync +vsync (80.0 kHz)
[    24.894] (II) RADEON(0): Modeline "1024x768"x0.0   78.75  1024 1040 1136 1312  768 769 772 800 +hsync +vsync (60.0 kHz)
[    24.894] (II) RADEON(0): Modeline "1024x768"x0.0   75.00  1024 1048 1184 1328  768 771 777 806 -hsync -vsync (56.5 kHz)
[    24.894] (II) RADEON(0): Modeline "1024x768"x0.0   65.00  1024 1048 1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz)
[    24.894] (II) RADEON(0): Modeline "832x624"x0.0   57.28  832 864 928 1152  624 625 628 667 -hsync -vsync (49.7 kHz)
[    24.894] (II) RADEON(0): Modeline "800x600"x0.0   49.50  800 816 896 1056  600 601 604 625 +hsync +vsync (46.9 kHz)
[    24.894] (II) RADEON(0): Modeline "800x600"x0.0   50.00  800 856 976 1040  600 637 643 666 +hsync +vsync (48.1 kHz)
[    24.894] (II) RADEON(0): Modeline "1152x864"x0.0  108.00  1152 1216 1344 1600  864 865 868 900 +hsync +vsync (67.5 kHz)
[    24.894] (II) RADEON(0): Modeline "1280x720"x60.0   74.48  1280 1336 1472 1664  720 721 724 746 -hsync +vsync (44.8 kHz)
[    24.894] (II) RADEON(0): Modeline "1280x960"x0.0  108.00  1280 1376 1488 1800  960 961 964 1000 +hsync +vsync (60.0 kHz)
[    24.894] (II) RADEON(0): Modeline "1280x1024"x0.0  108.00  1280 1328 1440 1688  1024 1025 1028 1066 +hsync +vsync (64.0 kHz)
[    24.894] (II) RADEON(0): Modeline "1440x900"x0.0   88.75  1440 1488 1520 1600  900 903 909 926 +hsync -vsync (55.5 kHz)
[    24.894] (II) RADEON(0): Modeline "1600x1200"x0.0  162.00  1600 1664 1856 2160  1200 1201 1204 1250 +hsync +vsync (75.0 kHz)
[    24.894] (II) RADEON(0): Modeline "1680x1050"x0.0  119.00  1680 1728 1760 1840  1050 1053 1059 1080 +hsync -vsync (64.7 kHz)
[    24.894] (II) RADEON(0): Modeline "1920x1080"x60.0  172.80  1920 2040 2248 2576  1080 1081 1084 1118 -hsync +vsync (67.1 kHz)
[    24.894] (II) RADEON(0): Modeline "1440x480i"x0.0   27.00  1440 1478 1602 1716  480 488 494 525 interlace -hsync -vsync (15.7 kHz)
[    24.894] (II) RADEON(0): Modeline "1920x1080i"x0.0   74.25  1920 2008 2052 2200  1080 1084 1094 1125 interlace +hsync +vsync (33.8 kHz)
[    24.894] (II) RADEON(0): Modeline "1920x1080i"x0.0   74.25  1920 2448 2492 2640  1080 1084 1094 1125 interlace +hsync +vsync (28.1 kHz)
[    24.894] (II) RADEON(0): Modeline "1440x240"x0.0   27.00  1440 1478 1602 1716  240 244 247 262 -hsync -vsync (15.7 kHz)
[    24.894] (II) RADEON(0): Modeline "1440x288"x0.0   27.00  1440 1464 1590 1728  288 290 293 312 -hsync -vsync (15.6 kHz)
[    24.894] (II) RADEON(0): Modeline "1920x1080"x0.0   74.25  1920 2558 2602 2750  1080 1084 1089 1125 +hsync +vsync (27.0 kHz)
[    25.070] (II) RADEON(0): EDID vendor "BNQ", prod id 30990
[    25.071] (II) RADEON(0): Using hsync ranges from config file
[    25.071] (II) RADEON(0): Using vrefresh ranges from config file
[    25.071] (II) RADEON(0): Printing DDC gathered Modelines:
[    25.071] (II) RADEON(0): Modeline "1920x1080"x0.0  138.50  1920 1968 2000 2080  1080 1083 1088 1111 +hsync +vsync (66.6 kHz)
[    25.071] (II) RADEON(0): Modeline "720x480"x0.0   27.00  720 736 798 858  480 489 495 525 -hsync -vsync (31.5 kHz)
[    25.071] (II) RADEON(0): Modeline "1280x720"x0.0   74.25  1280 1390 1430 1650  720 725 730 750 +hsync +vsync (45.0 kHz)
[    25.071] (II) RADEON(0): Modeline "1280x720"x0.0   74.25  1280 1720 1760 1980  720 725 730 750 +hsync +vsync (37.5 kHz)
[    25.071] (II) RADEON(0): Modeline "720x576"x0.0   27.00  720 732 796 864  576 581 586 625 -hsync -vsync (31.2 kHz)
[    25.071] (II) RADEON(0): Modeline "1440x576i"x0.0   27.00  1440 1464 1590 1728  576 580 586 625 interlace -hsync -vsync (15.6 kHz)
[    25.071] (II) RADEON(0): Modeline "800x600"x0.0   40.00  800 840 968 1056  600 601 605 628 +hsync +vsync (37.9 kHz)
[    25.071] (II) RADEON(0): Modeline "800x600"x0.0   36.00  800 824 896 1024  600 601 603 625 +hsync +vsync (35.2 kHz)
[    25.071] (II) RADEON(0): Modeline "640x480"x0.0   31.50  640 656 720 840  480 481 484 500 -hsync -vsync (37.5 kHz)
[    25.071] (II) RADEON(0): Modeline "640x480"x0.0   31.50  640 664 704 832  480 489 492 520 -hsync -vsync (37.9 kHz)
[    25.071] (II) RADEON(0): Modeline "640x480"x0.0   30.24  640 704 768 864  480 483 486 525 -hsync -vsync (35.0 kHz)
[    25.071] (II) RADEON(0): Modeline "640x480"x0.0   25.18  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz)
[    25.071] (II) RADEON(0): Modeline "720x400"x0.0   28.32  720 738 846 900  400 412 414 449 -hsync +vsync (31.5 kHz)
[    25.071] (II) RADEON(0): Modeline "1280x1024"x0.0  135.00  1280 1296 1440 1688  1024 1025 1028 1066 +hsync +vsync (80.0 kHz)
[    25.071] (II) RADEON(0): Modeline "1024x768"x0.0   78.75  1024 1040 1136 1312  768 769 772 800 +hsync +vsync (60.0 kHz)
[    25.071] (II) RADEON(0): Modeline "1024x768"x0.0   75.00  1024 1048 1184 1328  768 771 777 806 -hsync -vsync (56.5 kHz)
[    25.071] (II) RADEON(0): Modeline "1024x768"x0.0   65.00  1024 1048 1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz)
[    25.071] (II) RADEON(0): Modeline "832x624"x0.0   57.28  832 864 928 1152  624 625 628 667 -hsync -vsync (49.7 kHz)
[    25.071] (II) RADEON(0): Modeline "800x600"x0.0   49.50  800 816 896 1056  600 601 604 625 +hsync +vsync (46.9 kHz)
[    25.071] (II) RADEON(0): Modeline "800x600"x0.0   50.00  800 856 976 1040  600 637 643 666 +hsync +vsync (48.1 kHz)
[    25.071] (II) RADEON(0): Modeline "1152x864"x0.0  108.00  1152 1216 1344 1600  864 865 868 900 +hsync +vsync (67.5 kHz)
[    25.071] (II) RADEON(0): Modeline "1280x720"x60.0   74.48  1280 1336 1472 1664  720 721 724 746 -hsync +vsync (44.8 kHz)
[    25.071] (II) RADEON(0): Modeline "1280x960"x0.0  108.00  1280 1376 1488 1800  960 961 964 1000 +hsync +vsync (60.0 kHz)
[    25.071] (II) RADEON(0): Modeline "1280x1024"x0.0  108.00  1280 1328 1440 1688  1024 1025 1028 1066 +hsync +vsync (64.0 kHz)
[    25.071] (II) RADEON(0): Modeline "1440x900"x0.0   88.75  1440 1488 1520 1600  900 903 909 926 +hsync -vsync (55.5 kHz)
[    25.071] (II) RADEON(0): Modeline "1600x1200"x0.0  162.00  1600 1664 1856 2160  1200 1201 1204 1250 +hsync +vsync (75.0 kHz)
[    25.071] (II) RADEON(0): Modeline "1680x1050"x0.0  119.00  1680 1728 1760 1840  1050 1053 1059 1080 +hsync -vsync (64.7 kHz)
[    25.071] (II) RADEON(0): Modeline "1920x1080"x60.0  172.80  1920 2040 2248 2576  1080 1081 1084 1118 -hsync +vsync (67.1 kHz)
[    25.071] (II) RADEON(0): Modeline "1440x480i"x0.0   27.00  1440 1478 1602 1716  480 488 494 525 interlace -hsync -vsync (15.7 kHz)
[    25.071] (II) RADEON(0): Modeline "1920x1080i"x0.0   74.25  1920 2008 2052 2200  1080 1084 1094 1125 interlace +hsync +vsync (33.8 kHz)
[    25.071] (II) RADEON(0): Modeline "1920x1080i"x0.0   74.25  1920 2448 2492 2640  1080 1084 1094 1125 interlace +hsync +vsync (28.1 kHz)
[    25.071] (II) RADEON(0): Modeline "1440x240"x0.0   27.00  1440 1478 1602 1716  240 244 247 262 -hsync -vsync (15.7 kHz)
[    25.071] (II) RADEON(0): Modeline "1440x288"x0.0   27.00  1440 1464 1590 1728  288 290 293 312 -hsync -vsync (15.6 kHz)
[    25.071] (II) RADEON(0): Modeline "1920x1080"x0.0   74.25  1920 2558 2602 2750  1080 1084 1089 1125 +hsync +vsync (27.0 kHz)
[    25.180] (II) RADEON(0): EDID vendor "BNQ", prod id 30990
[    25.180] (II) RADEON(0): Using hsync ranges from config file
[    25.180] (II) RADEON(0): Using vrefresh ranges from config file
[    25.180] (II) RADEON(0): Printing DDC gathered Modelines:
[    25.180] (II) RADEON(0): Modeline "1920x1080"x0.0  138.50  1920 1968 2000 2080  1080 1083 1088 1111 +hsync +vsync (66.6 kHz)
[    25.180] (II) RADEON(0): Modeline "720x480"x0.0   27.00  720 736 798 858  480 489 495 525 -hsync -vsync (31.5 kHz)
[    25.180] (II) RADEON(0): Modeline "1280x720"x0.0   74.25  1280 1390 1430 1650  720 725 730 750 +hsync +vsync (45.0 kHz)
[    25.180] (II) RADEON(0): Modeline "1280x720"x0.0   74.25  1280 1720 1760 1980  720 725 730 750 +hsync +vsync (37.5 kHz)
[    25.180] (II) RADEON(0): Modeline "720x576"x0.0   27.00  720 732 796 864  576 581 586 625 -hsync -vsync (31.2 kHz)
[    25.180] (II) RADEON(0): Modeline "1440x576i"x0.0   27.00  1440 1464 1590 1728  576 580 586 625 interlace -hsync -vsync (15.6 kHz)
[    25.180] (II) RADEON(0): Modeline "800x600"x0.0   40.00  800 840 968 1056  600 601 605 628 +hsync +vsync (37.9 kHz)
[    25.180] (II) RADEON(0): Modeline "800x600"x0.0   36.00  800 824 896 1024  600 601 603 625 +hsync +vsync (35.2 kHz)
[    25.180] (II) RADEON(0): Modeline "640x480"x0.0   31.50  640 656 720 840  480 481 484 500 -hsync -vsync (37.5 kHz)
[    25.180] (II) RADEON(0): Modeline "640x480"x0.0   31.50  640 664 704 832  480 489 492 520 -hsync -vsync (37.9 kHz)
[    25.180] (II) RADEON(0): Modeline "640x480"x0.0   30.24  640 704 768 864  480 483 486 525 -hsync -vsync (35.0 kHz)
[    25.180] (II) RADEON(0): Modeline "640x480"x0.0   25.18  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz)
[    25.180] (II) RADEON(0): Modeline "720x400"x0.0   28.32  720 738 846 900  400 412 414 449 -hsync +vsync (31.5 kHz)
[    25.180] (II) RADEON(0): Modeline "1280x1024"x0.0  135.00  1280 1296 1440 1688  1024 1025 1028 1066 +hsync +vsync (80.0 kHz)
[    25.180] (II) RADEON(0): Modeline "1024x768"x0.0   78.75  1024 1040 1136 1312  768 769 772 800 +hsync +vsync (60.0 kHz)
[    25.180] (II) RADEON(0): Modeline "1024x768"x0.0   75.00  1024 1048 1184 1328  768 771 777 806 -hsync -vsync (56.5 kHz)
[    25.180] (II) RADEON(0): Modeline "1024x768"x0.0   65.00  1024 1048 1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz)
[    25.180] (II) RADEON(0): Modeline "832x624"x0.0   57.28  832 864 928 1152  624 625 628 667 -hsync -vsync (49.7 kHz)
[    25.180] (II) RADEON(0): Modeline "800x600"x0.0   49.50  800 816 896 1056  600 601 604 625 +hsync +vsync (46.9 kHz)
[    25.180] (II) RADEON(0): Modeline "800x600"x0.0   50.00  800 856 976 1040  600 637 643 666 +hsync +vsync (48.1 kHz)
[    25.180] (II) RADEON(0): Modeline "1152x864"x0.0  108.00  1152 1216 1344 1600  864 865 868 900 +hsync +vsync (67.5 kHz)
[    25.180] (II) RADEON(0): Modeline "1280x720"x60.0   74.48  1280 1336 1472 1664  720 721 724 746 -hsync +vsync (44.8 kHz)
[    25.180] (II) RADEON(0): Modeline "1280x960"x0.0  108.00  1280 1376 1488 1800  960 961 964 1000 +hsync +vsync (60.0 kHz)
[    25.180] (II) RADEON(0): Modeline "1280x1024"x0.0  108.00  1280 1328 1440 1688  1024 1025 1028 1066 +hsync +vsync (64.0 kHz)
[    25.180] (II) RADEON(0): Modeline "1440x900"x0.0   88.75  1440 1488 1520 1600  900 903 909 926 +hsync -vsync (55.5 kHz)
[    25.180] (II) RADEON(0): Modeline "1600x1200"x0.0  162.00  1600 1664 1856 2160  1200 1201 1204 1250 +hsync +vsync (75.0 kHz)
[    25.180] (II) RADEON(0): Modeline "1680x1050"x0.0  119.00  1680 1728 1760 1840  1050 1053 1059 1080 +hsync -vsync (64.7 kHz)
[    25.180] (II) RADEON(0): Modeline "1920x1080"x60.0  172.80  1920 2040 2248 2576  1080 1081 1084 1118 -hsync +vsync (67.1 kHz)
[    25.180] (II) RADEON(0): Modeline "1440x480i"x0.0   27.00  1440 1478 1602 1716  480 488 494 525 interlace -hsync -vsync (15.7 kHz)
[    25.180] (II) RADEON(0): Modeline "1920x1080i"x0.0   74.25  1920 2008 2052 2200  1080 1084 1094 1125 interlace +hsync +vsync (33.8 kHz)
[    25.180] (II) RADEON(0): Modeline "1920x1080i"x0.0   74.25  1920 2448 2492 2640  1080 1084 1094 1125 interlace +hsync +vsync (28.1 kHz)
[    25.180] (II) RADEON(0): Modeline "1440x240"x0.0   27.00  1440 1478 1602 1716  240 244 247 262 -hsync -vsync (15.7 kHz)
[    25.180] (II) RADEON(0): Modeline "1440x288"x0.0   27.00  1440 1464 1590 1728  288 290 293 312 -hsync -vsync (15.6 kHz)
[    25.180] (II) RADEON(0): Modeline "1920x1080"x0.0   74.25  1920 2558 2602 2750  1080 1084 1089 1125 +hsync +vsync (27.0 kHz)
[    26.160] (II) RADEON(0): EDID vendor "BNQ", prod id 30990
[    26.160] (II) RADEON(0): Using hsync ranges from config file
[    26.160] (II) RADEON(0): Using vrefresh ranges from config file
[    26.160] (II) RADEON(0): Printing DDC gathered Modelines:
[    26.160] (II) RADEON(0): Modeline "1920x1080"x0.0  138.50  1920 1968 2000 2080  1080 1083 1088 1111 +hsync +vsync (66.6 kHz)
[    26.160] (II) RADEON(0): Modeline "720x480"x0.0   27.00  720 736 798 858  480 489 495 525 -hsync -vsync (31.5 kHz)
[    26.160] (II) RADEON(0): Modeline "1280x720"x0.0   74.25  1280 1390 1430 1650  720 725 730 750 +hsync +vsync (45.0 kHz)
[    26.160] (II) RADEON(0): Modeline "1280x720"x0.0   74.25  1280 1720 1760 1980  720 725 730 750 +hsync +vsync (37.5 kHz)
[    26.160] (II) RADEON(0): Modeline "720x576"x0.0   27.00  720 732 796 864  576 581 586 625 -hsync -vsync (31.2 kHz)
[    26.160] (II) RADEON(0): Modeline "1440x576i"x0.0   27.00  1440 1464 1590 1728  576 580 586 625 interlace -hsync -vsync (15.6 kHz)
[    26.160] (II) RADEON(0): Modeline "800x600"x0.0   40.00  800 840 968 1056  600 601 605 628 +hsync +vsync (37.9 kHz)
[    26.160] (II) RADEON(0): Modeline "800x600"x0.0   36.00  800 824 896 1024  600 601 603 625 +hsync +vsync (35.2 kHz)
[    26.160] (II) RADEON(0): Modeline "640x480"x0.0   31.50  640 656 720 840  480 481 484 500 -hsync -vsync (37.5 kHz)
[    26.160] (II) RADEON(0): Modeline "640x480"x0.0   31.50  640 664 704 832  480 489 492 520 -hsync -vsync (37.9 kHz)
[    26.160] (II) RADEON(0): Modeline "640x480"x0.0   30.24  640 704 768 864  480 483 486 525 -hsync -vsync (35.0 kHz)
[    26.160] (II) RADEON(0): Modeline "640x480"x0.0   25.18  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz)
[    26.160] (II) RADEON(0): Modeline "720x400"x0.0   28.32  720 738 846 900  400 412 414 449 -hsync +vsync (31.5 kHz)
[    26.160] (II) RADEON(0): Modeline "1280x1024"x0.0  135.00  1280 1296 1440 1688  1024 1025 1028 1066 +hsync +vsync (80.0 kHz)
[    26.160] (II) RADEON(0): Modeline "1024x768"x0.0   78.75  1024 1040 1136 1312  768 769 772 800 +hsync +vsync (60.0 kHz)
[    26.160] (II) RADEON(0): Modeline "1024x768"x0.0   75.00  1024 1048 1184 1328  768 771 777 806 -hsync -vsync (56.5 kHz)
[    26.160] (II) RADEON(0): Modeline "1024x768"x0.0   65.00  1024 1048 1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz)
[    26.160] (II) RADEON(0): Modeline "832x624"x0.0   57.28  832 864 928 1152  624 625 628 667 -hsync -vsync (49.7 kHz)
[    26.160] (II) RADEON(0): Modeline "800x600"x0.0   49.50  800 816 896 1056  600 601 604 625 +hsync +vsync (46.9 kHz)
[    26.161] (II) RADEON(0): Modeline "800x600"x0.0   50.00  800 856 976 1040  600 637 643 666 +hsync +vsync (48.1 kHz)
[    26.161] (II) RADEON(0): Modeline "1152x864"x0.0  108.00  1152 1216 1344 1600  864 865 868 900 +hsync +vsync (67.5 kHz)
[    26.161] (II) RADEON(0): Modeline "1280x720"x60.0   74.48  1280 1336 1472 1664  720 721 724 746 -hsync +vsync (44.8 kHz)
[    26.161] (II) RADEON(0): Modeline "1280x960"x0.0  108.00  1280 1376 1488 1800  960 961 964 1000 +hsync +vsync (60.0 kHz)
[    26.161] (II) RADEON(0): Modeline "1280x1024"x0.0  108.00  1280 1328 1440 1688  1024 1025 1028 1066 +hsync +vsync (64.0 kHz)
[    26.161] (II) RADEON(0): Modeline "1440x900"x0.0   88.75  1440 1488 1520 1600  900 903 909 926 +hsync -vsync (55.5 kHz)
[    26.161] (II) RADEON(0): Modeline "1600x1200"x0.0  162.00  1600 1664 1856 2160  1200 1201 1204 1250 +hsync +vsync (75.0 kHz)
[    26.161] (II) RADEON(0): Modeline "1680x1050"x0.0  119.00  1680 1728 1760 1840  1050 1053 1059 1080 +hsync -vsync (64.7 kHz)
[    26.161] (II) RADEON(0): Modeline "1920x1080"x60.0  172.80  1920 2040 2248 2576  1080 1081 1084 1118 -hsync +vsync (67.1 kHz)
[    26.161] (II) RADEON(0): Modeline "1440x480i"x0.0   27.00  1440 1478 1602 1716  480 488 494 525 interlace -hsync -vsync (15.7 kHz)
[    26.161] (II) RADEON(0): Modeline "1920x1080i"x0.0   74.25  1920 2008 2052 2200  1080 1084 1094 1125 interlace +hsync +vsync (33.8 kHz)
[    26.161] (II) RADEON(0): Modeline "1920x1080i"x0.0   74.25  1920 2448 2492 2640  1080 1084 1094 1125 interlace +hsync +vsync (28.1 kHz)
[    26.161] (II) RADEON(0): Modeline "1440x240"x0.0   27.00  1440 1478 1602 1716  240 244 247 262 -hsync -vsync (15.7 kHz)
[    26.161] (II) RADEON(0): Modeline "1440x288"x0.0   27.00  1440 1464 1590 1728  288 290 293 312 -hsync -vsync (15.6 kHz)
[    26.161] (II) RADEON(0): Modeline "1920x1080"x0.0   74.25  1920 2558 2602 2750  1080 1084 1089 1125 +hsync +vsync (27.0 kHz)
[    26.273] (II) RADEON(0): EDID vendor "BNQ", prod id 30990
[    26.273] (II) RADEON(0): Using hsync ranges from config file
[    26.273] (II) RADEON(0): Using vrefresh ranges from config file
[    26.273] (II) RADEON(0): Printing DDC gathered Modelines:
[    26.273] (II) RADEON(0): Modeline "1920x1080"x0.0  138.50  1920 1968 2000 2080  1080 1083 1088 1111 +hsync +vsync (66.6 kHz)
[    26.273] (II) RADEON(0): Modeline "720x480"x0.0   27.00  720 736 798 858  480 489 495 525 -hsync -vsync (31.5 kHz)
[    26.273] (II) RADEON(0): Modeline "1280x720"x0.0   74.25  1280 1390 1430 1650  720 725 730 750 +hsync +vsync (45.0 kHz)
[    26.273] (II) RADEON(0): Modeline "1280x720"x0.0   74.25  1280 1720 1760 1980  720 725 730 750 +hsync +vsync (37.5 kHz)
[    26.273] (II) RADEON(0): Modeline "720x576"x0.0   27.00  720 732 796 864  576 581 586 625 -hsync -vsync (31.2 kHz)
[    26.273] (II) RADEON(0): Modeline "1440x576i"x0.0   27.00  1440 1464 1590 1728  576 580 586 625 interlace -hsync -vsync (15.6 kHz)
[    26.273] (II) RADEON(0): Modeline "800x600"x0.0   40.00  800 840 968 1056  600 601 605 628 +hsync +vsync (37.9 kHz)
[    26.273] (II) RADEON(0): Modeline "800x600"x0.0   36.00  800 824 896 1024  600 601 603 625 +hsync +vsync (35.2 kHz)
[    26.273] (II) RADEON(0): Modeline "640x480"x0.0   31.50  640 656 720 840  480 481 484 500 -hsync -vsync (37.5 kHz)
[    26.273] (II) RADEON(0): Modeline "640x480"x0.0   31.50  640 664 704 832  480 489 492 520 -hsync -vsync (37.9 kHz)
[    26.273] (II) RADEON(0): Modeline "640x480"x0.0   30.24  640 704 768 864  480 483 486 525 -hsync -vsync (35.0 kHz)
[    26.273] (II) RADEON(0): Modeline "640x480"x0.0   25.18  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz)
[    26.273] (II) RADEON(0): Modeline "720x400"x0.0   28.32  720 738 846 900  400 412 414 449 -hsync +vsync (31.5 kHz)
[    26.273] (II) RADEON(0): Modeline "1280x1024"x0.0  135.00  1280 1296 1440 1688  1024 1025 1028 1066 +hsync +vsync (80.0 kHz)
[    26.273] (II) RADEON(0): Modeline "1024x768"x0.0   78.75  1024 1040 1136 1312  768 769 772 800 +hsync +vsync (60.0 kHz)
[    26.273] (II) RADEON(0): Modeline "1024x768"x0.0   75.00  1024 1048 1184 1328  768 771 777 806 -hsync -vsync (56.5 kHz)
[    26.273] (II) RADEON(0): Modeline "1024x768"x0.0   65.00  1024 1048 1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz)
[    26.273] (II) RADEON(0): Modeline "832x624"x0.0   57.28  832 864 928 1152  624 625 628 667 -hsync -vsync (49.7 kHz)
[    26.273] (II) RADEON(0): Modeline "800x600"x0.0   49.50  800 816 896 1056  600 601 604 625 +hsync +vsync (46.9 kHz)
[    26.273] (II) RADEON(0): Modeline "800x600"x0.0   50.00  800 856 976 1040  600 637 643 666 +hsync +vsync (48.1 kHz)
[    26.273] (II) RADEON(0): Modeline "1152x864"x0.0  108.00  1152 1216 1344 1600  864 865 868 900 +hsync +vsync (67.5 kHz)
[    26.273] (II) RADEON(0): Modeline "1280x720"x60.0   74.48  1280 1336 1472 1664  720 721 724 746 -hsync +vsync (44.8 kHz)
[    26.273] (II) RADEON(0): Modeline "1280x960"x0.0  108.00  1280 1376 1488 1800  960 961 964 1000 +hsync +vsync (60.0 kHz)
[    26.273] (II) RADEON(0): Modeline "1280x1024"x0.0  108.00  1280 1328 1440 1688  1024 1025 1028 1066 +hsync +vsync (64.0 kHz)
[    26.273] (II) RADEON(0): Modeline "1440x900"x0.0   88.75  1440 1488 1520 1600  900 903 909 926 +hsync -vsync (55.5 kHz)
[    26.273] (II) RADEON(0): Modeline "1600x1200"x0.0  162.00  1600 1664 1856 2160  1200 1201 1204 1250 +hsync +vsync (75.0 kHz)
[    26.273] (II) RADEON(0): Modeline "1680x1050"x0.0  119.00  1680 1728 1760 1840  1050 1053 1059 1080 +hsync -vsync (64.7 kHz)
[    26.273] (II) RADEON(0): Modeline "1920x1080"x60.0  172.80  1920 2040 2248 2576  1080 1081 1084 1118 -hsync +vsync (67.1 kHz)
[    26.273] (II) RADEON(0): Modeline "1440x480i"x0.0   27.00  1440 1478 1602 1716  480 488 494 525 interlace -hsync -vsync (15.7 kHz)
[    26.273] (II) RADEON(0): Modeline "1920x1080i"x0.0   74.25  1920 2008 2052 2200  1080 1084 1094 1125 interlace +hsync +vsync (33.8 kHz)
[    26.273] (II) RADEON(0): Modeline "1920x1080i"x0.0   74.25  1920 2448 2492 2640  1080 1084 1094 1125 interlace +hsync +vsync (28.1 kHz)
[    26.273] (II) RADEON(0): Modeline "1440x240"x0.0   27.00  1440 1478 1602 1716  240 244 247 262 -hsync -vsync (15.7 kHz)
[    26.273] (II) RADEON(0): Modeline "1440x288"x0.0   27.00  1440 1464 1590 1728  288 290 293 312 -hsync -vsync (15.6 kHz)
[    26.273] (II) RADEON(0): Modeline "1920x1080"x0.0   74.25  1920 2558 2602 2750  1080 1084 1089 1125 +hsync +vsync (27.0 kHz)
[    26.880] (II) RADEON(0): EDID vendor "BNQ", prod id 30990
[    26.880] (II) RADEON(0): Using hsync ranges from config file
[    26.880] (II) RADEON(0): Using vrefresh ranges from config file
[    26.880] (II) RADEON(0): Printing DDC gathered Modelines:
[    26.880] (II) RADEON(0): Modeline "1920x1080"x0.0  138.50  1920 1968 2000 2080  1080 1083 1088 1111 +hsync +vsync (66.6 kHz)
[    26.880] (II) RADEON(0): Modeline "720x480"x0.0   27.00  720 736 798 858  480 489 495 525 -hsync -vsync (31.5 kHz)
[    26.880] (II) RADEON(0): Modeline "1280x720"x0.0   74.25  1280 1390 1430 1650  720 725 730 750 +hsync +vsync (45.0 kHz)
[    26.880] (II) RADEON(0): Modeline "1280x720"x0.0   74.25  1280 1720 1760 1980  720 725 730 750 +hsync +vsync (37.5 kHz)
[    26.880] (II) RADEON(0): Modeline "720x576"x0.0   27.00  720 732 796 864  576 581 586 625 -hsync -vsync (31.2 kHz)
[    26.880] (II) RADEON(0): Modeline "1440x576i"x0.0   27.00  1440 1464 1590 1728  576 580 586 625 interlace -hsync -vsync (15.6 kHz)
[    26.880] (II) RADEON(0): Modeline "800x600"x0.0   40.00  800 840 968 1056  600 601 605 628 +hsync +vsync (37.9 kHz)
[    26.880] (II) RADEON(0): Modeline "800x600"x0.0   36.00  800 824 896 1024  600 601 603 625 +hsync +vsync (35.2 kHz)
[    26.880] (II) RADEON(0): Modeline "640x480"x0.0   31.50  640 656 720 840  480 481 484 500 -hsync -vsync (37.5 kHz)
[    26.881] (II) RADEON(0): Modeline "640x480"x0.0   31.50  640 664 704 832  480 489 492 520 -hsync -vsync (37.9 kHz)
[    26.881] (II) RADEON(0): Modeline "640x480"x0.0   30.24  640 704 768 864  480 483 486 525 -hsync -vsync (35.0 kHz)
[    26.881] (II) RADEON(0): Modeline "640x480"x0.0   25.18  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz)
[    26.881] (II) RADEON(0): Modeline "720x400"x0.0   28.32  720 738 846 900  400 412 414 449 -hsync +vsync (31.5 kHz)
[    26.881] (II) RADEON(0): Modeline "1280x1024"x0.0  135.00  1280 1296 1440 1688  1024 1025 1028 1066 +hsync +vsync (80.0 kHz)
[    26.881] (II) RADEON(0): Modeline "1024x768"x0.0   78.75  1024 1040 1136 1312  768 769 772 800 +hsync +vsync (60.0 kHz)
[    26.881] (II) RADEON(0): Modeline "1024x768"x0.0   75.00  1024 1048 1184 1328  768 771 777 806 -hsync -vsync (56.5 kHz)
[    26.881] (II) RADEON(0): Modeline "1024x768"x0.0   65.00  1024 1048 1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz)
[    26.881] (II) RADEON(0): Modeline "832x624"x0.0   57.28  832 864 928 1152  624 625 628 667 -hsync -vsync (49.7 kHz)
[    26.881] (II) RADEON(0): Modeline "800x600"x0.0   49.50  800 816 896 1056  600 601 604 625 +hsync +vsync (46.9 kHz)
[    26.881] (II) RADEON(0): Modeline "800x600"x0.0   50.00  800 856 976 1040  600 637 643 666 +hsync +vsync (48.1 kHz)
[    26.881] (II) RADEON(0): Modeline "1152x864"x0.0  108.00  1152 1216 1344 1600  864 865 868 900 +hsync +vsync (67.5 kHz)
[    26.881] (II) RADEON(0): Modeline "1280x720"x60.0   74.48  1280 1336 1472 1664  720 721 724 746 -hsync +vsync (44.8 kHz)
[    26.881] (II) RADEON(0): Modeline "1280x960"x0.0  108.00  1280 1376 1488 1800  960 961 964 1000 +hsync +vsync (60.0 kHz)
[    26.881] (II) RADEON(0): Modeline "1280x1024"x0.0  108.00  1280 1328 1440 1688  1024 1025 1028 1066 +hsync +vsync (64.0 kHz)
[    26.881] (II) RADEON(0): Modeline "1440x900"x0.0   88.75  1440 1488 1520 1600  900 903 909 926 +hsync -vsync (55.5 kHz)
[    26.881] (II) RADEON(0): Modeline "1600x1200"x0.0  162.00  1600 1664 1856 2160  1200 1201 1204 1250 +hsync +vsync (75.0 kHz)
[    26.881] (II) RADEON(0): Modeline "1680x1050"x0.0  119.00  1680 1728 1760 1840  1050 1053 1059 1080 +hsync -vsync (64.7 kHz)
[    26.881] (II) RADEON(0): Modeline "1920x1080"x60.0  172.80  1920 2040 2248 2576  1080 1081 1084 1118 -hsync +vsync (67.1 kHz)
[    26.881] (II) RADEON(0): Modeline "1440x480i"x0.0   27.00  1440 1478 1602 1716  480 488 494 525 interlace -hsync -vsync (15.7 kHz)
[    26.881] (II) RADEON(0): Modeline "1920x1080i"x0.0   74.25  1920 2008 2052 2200  1080 1084 1094 1125 interlace +hsync +vsync (33.8 kHz)
[    26.881] (II) RADEON(0): Modeline "1920x1080i"x0.0   74.25  1920 2448 2492 2640  1080 1084 1094 1125 interlace +hsync +vsync (28.1 kHz)
[    26.881] (II) RADEON(0): Modeline "1440x240"x0.0   27.00  1440 1478 1602 1716  240 244 247 262 -hsync -vsync (15.7 kHz)
[    26.881] (II) RADEON(0): Modeline "1440x288"x0.0   27.00  1440 1464 1590 1728  288 290 293 312 -hsync -vsync (15.6 kHz)
[    26.881] (II) RADEON(0): Modeline "1920x1080"x0.0   74.25  1920 2558 2602 2750  1080 1084 1089 1125 +hsync +vsync (27.0 kHz)

--Boundary-00=_HCexN6izAl8L6Q2--
