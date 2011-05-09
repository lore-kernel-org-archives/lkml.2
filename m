Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259Ab1EITv2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 15:51:28 -0400
Received: from mail.tomasu.net ([64.85.170.232]:48964 "EHLO mail.tomasu.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753617Ab1EITvY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 15:51:24 -0400
From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Reply-To: thomas@fjellstrom.ca
To: dri-devel@lists.freedesktop.org
Subject: Re: long delay when using HMDI output on RS780
Date: Mon, 9 May 2011 13:50:42 -0600
User-Agent: KMail/1.13.7 (Linux/2.6.38-2-amd64; KDE/4.6.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <201105071815.03318.thomas@fjellstrom.ca>
In-Reply-To: <201105071815.03318.thomas@fjellstrom.ca>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_TWEyNZVAFaW908q"
Message-Id: <201105091350.43119.thomas@fjellstrom.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_TWEyNZVAFaW908q
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit

On May 7, 2011, Thomas Fjellstrom wrote:
> I just switched to using HDMI with my media center, and its causing a 30+
> second delay in the screen turning on, as well as a 7 second delay in the X
> startup when it tries to fetch the EDID information. Basically I don't get
> any picture at all once KMS initializes until after X has been up a few
> seconds.
> 
> The odd thing is the monitor seems to think something is going on, since it
> doesn't go to sleep or display its "No Signal" OSD, but just after X starts
> up, it pops up the "Input detected/switched" OSD, and the picture appears.
> 
> The bios, grub2 (in both text mode and graphics mode), and the initial
> linux kernel messages all display fine and immediately. Its only once KMS
> and radeondrmfb initializes that there's a problem (at least till X starts
> up).
> 
> I've just built with a vanila 2.6.38.4 kernel from the stable git repo, and
> have played with some EDID settings, trying to disable edid where I could
> thinking thats what caused the problem. That doesn't seem to be the case
> though. I also tried playing with the video= kernel option, trying to force
> disable VGA-1, and set a static mode for HDMI-A-1, but if I try, it seems
> to force disable HDMI-A-1 instead of force the mode.
> 
> With a DVI-D cable instead, the problem goes away.
> 
> Attached are the dmesg and xorg.log files for the latest boot with HDMI (no
> video= parameter, and EDID enabled, most settings at defaults).
> 
> What exactly would cause this, and is there a way I can fix it?

I've been playing around with it more, and got it to not blank the screen 
after KMS init, /once/. So far no luck repeating that success.

I've tried late, and early kms init, and currently have the radeon module and 
firmware compiled into the kernel. Boot times at least are fairly decent, about 
8-10s till X starts, but about 25-35s till anything shows up.

Some strangeness, I have the kernel set to force the hdmi output to on, with a 
very specific mode, that X tends to like, the vga port is forced disabled. X is 
set to ignore EDID, and also set to that specific mode that it tends to auto 
set itself. Regardless X still wants to pause for 7s 2-3 times while 
processing EDID info.

I've attached the new dmesg and xorg logs from the latest attempts.

Note, this only happens with KMS, with HDMI. disabling KMS, or using DVI makes 
the problem go away. Even grub's own graphical mode works fine, its only once 
KMS inits that things go bad, and its not till after X is up for a few seconds 
that something displays on my screen.

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca

--Boundary-00=_TWEyNZVAFaW908q
Content-Type: text/plain;
  charset="UTF-8";
  name="chauncey.dmesg"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="chauncey.dmesg"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.38.5-local (moose@chauncey) (gcc version 4.6.1 20110428 (prerelease) (Debian 4.6.0-6) ) #14 SMP PREEMPT Sun May 8 23:19:24 MDT 2011
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-2.6.38.5-local root=UUID=f0797db1-b72e-43bc-9267-1c1f7a3736b5 ro video=HDMI-A-1:1920x1080@59.9D video=VGA-1:d quiet
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
[    0.000000] RAMDISK: 37a22000 - 37d09000
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
[    0.000000] PERCPU: Embedded 26 pages/cpu @ffff880077a00000 s75392 r8192 d22912 u524288
[    0.000000] pcpu-alloc: s75392 r8192 d22912 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 484144
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.38.5-local root=UUID=f0797db1-b72e-43bc-9267-1c1f7a3736b5 ro video=HDMI-A-1:1920x1080@59.9D video=VGA-1:d quiet
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ c12000000 size 32 MB
[    0.000000] Aperture beyond 4GB. Ignoring.
[    0.000000] Memory: 1918256k/1963904k available (5699k kernel code, 452k absent, 45196k reserved, 5561k data, 620k init)
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
[    0.000000] Detected 2209.926 MHz processor.
[    0.002004] Calibrating delay loop (skipped), value calculated using timer frequency.. 4419.85 BogoMIPS (lpj=2209926)
[    0.002008] pid_max: default: 32768 minimum: 301
[    0.003021] Security Framework initialized
[    0.003216] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.004079] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.004469] Mount-cache hash table entries: 256
[    0.004607] Initializing cgroup subsys ns
[    0.004611] ns_cgroup deprecated: consider using the 'clone_children' flag without the ns_cgroup.
[    0.004614] Initializing cgroup subsys cpuacct
[    0.004619] Initializing cgroup subsys devices
[    0.004622] Initializing cgroup subsys freezer
[    0.004624] Initializing cgroup subsys blkio
[    0.004657] tseg: 0077e00000
[    0.004660] CPU: Physical Processor ID: 0
[    0.004661] CPU: Processor Core ID: 0
[    0.004663] mce: CPU supports 6 MCE banks
[    0.004709] ACPI: Core revision 20110112
[    0.008084] Setting APIC routing to flat
[    0.008586] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.019143] CPU0: AMD Phenom(tm) 9550 Quad-Core Processor stepping 03
[    0.019998] Performance Events: AMD PMU driver.
[    0.019998] ... version:                0
[    0.019998] ... bit width:              48
[    0.019998] ... generic registers:      4
[    0.019998] ... value mask:             0000ffffffffffff
[    0.019998] ... max period:             00007fffffffffff
[    0.019998] ... fixed-purpose events:   0
[    0.019998] ... event mask:             000000000000000f
[    0.022036] MCE: In-kernel MCE decoding enabled.
[    0.022047] NMI watchdog enabled, takes one hw-pmu counter.
[    0.026022] Booting Node   0, Processors  #1
[    0.098007] NMI watchdog enabled, takes one hw-pmu counter.
[    0.101011]  #2
[    0.172995] NMI watchdog enabled, takes one hw-pmu counter.
[    0.175999]  #3 Ok.
[    0.247985] NMI watchdog enabled, takes one hw-pmu counter.
[    0.248976] Brought up 4 CPUs
[    0.248980] Total of 4 processors activated (17679.98 BogoMIPS).
[    0.250066] devtmpfs: initialized
[    0.253616] xor: automatically using best checksumming function: generic_sse
[    0.257973]    generic_sse:  8084.000 MB/sec
[    0.257975] xor: using function: generic_sse (8084.000 MB/sec)
[    0.258010] NET: Registered protocol family 16
[    0.258112] node 0 link 0: io port [c000, ffff]
[    0.258116] TOM: 0000000080000000 aka 2048M
[    0.258118] Fam 10h mmconf [e0000000, e00fffff]
[    0.258120] node 0 link 0: mmio [a0000, bffff]
[    0.258123] node 0 link 0: mmio [80000000, dfffffff]
[    0.258127] node 0 link 0: mmio [f0000000, fe02ffff]
[    0.258130] node 0 link 0: mmio [e0000000, e03fffff] ==> [e0100000, e03fffff]
[    0.258134] bus: [00, 03] on node 0 link 0
[    0.258137] bus: 00 index 0 [io  0x0000-0xffff]
[    0.258140] bus: 00 index 1 [mem 0x000a0000-0x000bffff]
[    0.258142] bus: 00 index 2 [mem 0x80000000-0xdfffffff]
[    0.258144] bus: 00 index 3 [mem 0xe0400000-0xfcffffffff]
[    0.258147] bus: 00 index 4 [mem 0xe0100000-0xe03fffff]
[    0.258157] Extended Config Space enabled on 1 nodes
[    0.258187] ACPI: bus type pci registered
[    0.258251] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.258254] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.281065] PCI: Using configuration type 1 for base access
[    0.282525] bio: create slab <bio-0> at 0
[    0.298981] raid6: int64x1   2140 MB/s
[    0.315988] raid6: int64x2   2160 MB/s
[    0.332996] raid6: int64x4   1796 MB/s
[    0.349999] raid6: int64x8   1507 MB/s
[    0.366966] raid6: sse2x1    3019 MB/s
[    0.383958] raid6: sse2x2    4902 MB/s
[    0.400959] raid6: sse2x4    5519 MB/s
[    0.400961] raid6: using algorithm sse2x4 (5519 MB/s)
[    0.402185] ACPI: EC: Look up EC in DSDT
[    0.407261] ACPI: Interpreter enabled
[    0.407267] ACPI: (supports S0 S3 S4 S5)
[    0.407289] ACPI: Using IOAPIC for interrupt routing
[    0.443175] ACPI: No dock devices found.
[    0.443178] HEST: Table not found.
[    0.443182] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.443253] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.443406] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
[    0.443409] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
[    0.443412] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.443415] pci_root PNP0A03:00: host bridge window [mem 0x000c0000-0x000dffff]
[    0.443418] pci_root PNP0A03:00: host bridge window [mem 0xfed40000-0xfed44fff]
[    0.443420] pci_root PNP0A03:00: host bridge window [mem 0x7ff00000-0xfebfffff]
[    0.443438] pci 0000:00:00.0: [1022:9600] type 0 class 0x000600
[    0.443452] pci 0000:00:00.0: reg 1c: [mem 0xe0000000-0xffffffff 64bit]
[    0.443489] pci 0000:00:01.0: [1022:9602] type 1 class 0x000604
[    0.443534] pci 0000:00:0a.0: [1022:9609] type 1 class 0x000604
[    0.443565] pci 0000:00:0a.0: PME# supported from D0 D3hot D3cold
[    0.443569] pci 0000:00:0a.0: PME# disabled
[    0.443598] pci 0000:00:11.0: [1002:4391] type 0 class 0x000106
[    0.443619] pci 0000:00:11.0: reg 10: [io  0xff00-0xff07]
[    0.443630] pci 0000:00:11.0: reg 14: [io  0xfe00-0xfe03]
[    0.443640] pci 0000:00:11.0: reg 18: [io  0xfd00-0xfd07]
[    0.443651] pci 0000:00:11.0: reg 1c: [io  0xfc00-0xfc03]
[    0.443661] pci 0000:00:11.0: reg 20: [io  0xfb00-0xfb0f]
[    0.443672] pci 0000:00:11.0: reg 24: [mem 0xfe02f000-0xfe02f3ff]
[    0.443720] pci 0000:00:12.0: [1002:4397] type 0 class 0x000c03
[    0.443735] pci 0000:00:12.0: reg 10: [mem 0xfe02e000-0xfe02efff]
[    0.443802] pci 0000:00:12.1: [1002:4398] type 0 class 0x000c03
[    0.443816] pci 0000:00:12.1: reg 10: [mem 0xfe02d000-0xfe02dfff]
[    0.443889] pci 0000:00:12.2: [1002:4396] type 0 class 0x000c03
[    0.443909] pci 0000:00:12.2: reg 10: [mem 0xfe02c000-0xfe02c0ff]
[    0.443991] pci 0000:00:12.2: supports D1 D2
[    0.443993] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.443998] pci 0000:00:12.2: PME# disabled
[    0.444021] pci 0000:00:13.0: [1002:4397] type 0 class 0x000c03
[    0.444035] pci 0000:00:13.0: reg 10: [mem 0xfe02b000-0xfe02bfff]
[    0.444104] pci 0000:00:13.1: [1002:4398] type 0 class 0x000c03
[    0.444119] pci 0000:00:13.1: reg 10: [mem 0xfe02a000-0xfe02afff]
[    0.444192] pci 0000:00:13.2: [1002:4396] type 0 class 0x000c03
[    0.444212] pci 0000:00:13.2: reg 10: [mem 0xfe029000-0xfe0290ff]
[    0.444286] pci 0000:00:13.2: supports D1 D2
[    0.444288] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.444293] pci 0000:00:13.2: PME# disabled
[    0.444318] pci 0000:00:14.0: [1002:4385] type 0 class 0x000c05
[    0.444416] pci 0000:00:14.1: [1002:439c] type 0 class 0x000101
[    0.444434] pci 0000:00:14.1: reg 10: [io  0x0000-0x0007]
[    0.444444] pci 0000:00:14.1: reg 14: [io  0x0000-0x0003]
[    0.444455] pci 0000:00:14.1: reg 18: [io  0x0000-0x0007]
[    0.444465] pci 0000:00:14.1: reg 1c: [io  0x0000-0x0003]
[    0.444476] pci 0000:00:14.1: reg 20: [io  0xfa00-0xfa0f]
[    0.444527] pci 0000:00:14.2: [1002:4383] type 0 class 0x000403
[    0.444551] pci 0000:00:14.2: reg 10: [mem 0xfe024000-0xfe027fff 64bit]
[    0.444612] pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
[    0.444616] pci 0000:00:14.2: PME# disabled
[    0.444631] pci 0000:00:14.3: [1002:439d] type 0 class 0x000601
[    0.444710] pci 0000:00:14.4: [1002:4384] type 1 class 0x000604
[    0.444753] pci 0000:00:14.5: [1002:4399] type 0 class 0x000c03
[    0.444767] pci 0000:00:14.5: reg 10: [mem 0xfe028000-0xfe028fff]
[    0.444839] pci 0000:00:18.0: [1022:1200] type 0 class 0x000600
[    0.444858] pci 0000:00:18.1: [1022:1201] type 0 class 0x000600
[    0.444873] pci 0000:00:18.2: [1022:1202] type 0 class 0x000600
[    0.444889] pci 0000:00:18.3: [1022:1203] type 0 class 0x000600
[    0.444907] pci 0000:00:18.4: [1022:1204] type 0 class 0x000600
[    0.444961] pci 0000:01:05.0: [1002:9610] type 0 class 0x000300
[    0.444971] pci 0000:01:05.0: reg 10: [mem 0xd8000000-0xdfffffff pref]
[    0.444976] pci 0000:01:05.0: reg 14: [io  0xee00-0xeeff]
[    0.444982] pci 0000:01:05.0: reg 18: [mem 0xfdfe0000-0xfdfeffff]
[    0.444993] pci 0000:01:05.0: reg 24: [mem 0xfde00000-0xfdefffff]
[    0.445007] pci 0000:01:05.0: supports D1 D2
[    0.445018] pci 0000:01:05.1: [1002:960f] type 0 class 0x000403
[    0.445027] pci 0000:01:05.1: reg 10: [mem 0xfdffc000-0xfdffffff]
[    0.445056] pci 0000:01:05.1: supports D1 D2
[    0.445096] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.445100] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    0.445103] pci 0000:00:01.0:   bridge window [mem 0xfde00000-0xfdffffff]
[    0.445108] pci 0000:00:01.0:   bridge window [mem 0xd8000000-0xdfffffff 64bit pref]
[    0.445147] pci 0000:02:00.0: [10ec:8168] type 0 class 0x000200
[    0.445161] pci 0000:02:00.0: reg 10: [io  0xde00-0xdeff]
[    0.445183] pci 0000:02:00.0: reg 18: [mem 0xfdbff000-0xfdbfffff 64bit pref]
[    0.445197] pci 0000:02:00.0: reg 20: [mem 0xfdbe0000-0xfdbeffff 64bit pref]
[    0.445207] pci 0000:02:00.0: reg 30: [mem 0x00000000-0x0000ffff pref]
[    0.445238] pci 0000:02:00.0: supports D1 D2
[    0.445240] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.445245] pci 0000:02:00.0: PME# disabled
[    0.446954] pci 0000:00:0a.0: PCI bridge to [bus 02-02]
[    0.446958] pci 0000:00:0a.0:   bridge window [io  0xd000-0xdfff]
[    0.446962] pci 0000:00:0a.0:   bridge window [mem 0xfdd00000-0xfddfffff]
[    0.446966] pci 0000:00:0a.0:   bridge window [mem 0xfdb00000-0xfdbfffff 64bit pref]
[    0.447004] pci 0000:03:06.0: [4444:0016] type 0 class 0x000400
[    0.447028] pci 0000:03:06.0: reg 10: [mem 0xf8000000-0xfbffffff pref]
[    0.447141] pci 0000:03:07.0: [4444:0016] type 0 class 0x000400
[    0.447165] pci 0000:03:07.0: reg 10: [mem 0xf4000000-0xf7ffffff pref]
[    0.447301] pci 0000:00:14.4: PCI bridge to [bus 03-03] (subtractive decode)
[    0.447306] pci 0000:00:14.4:   bridge window [io  0xc000-0xcfff]
[    0.447311] pci 0000:00:14.4:   bridge window [mem 0xfdc00000-0xfdcfffff]
[    0.447316] pci 0000:00:14.4:   bridge window [mem 0xf4000000-0xfbffffff pref]
[    0.447319] pci 0000:00:14.4:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.447321] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.447324] pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.447327] pci 0000:00:14.4:   bridge window [mem 0x000c0000-0x000dffff] (subtractive decode)
[    0.447330] pci 0000:00:14.4:   bridge window [mem 0xfed40000-0xfed44fff] (subtractive decode)
[    0.447333] pci 0000:00:14.4:   bridge window [mem 0x7ff00000-0xfebfffff] (subtractive decode)
[    0.447347] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.447626] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P_._PRT]
[    0.447725] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCEA._PRT]
[    0.447769] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
[    0.447813]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.462542] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.462588] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.462643] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.462690] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.462737] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.462789] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.462841] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.462887] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 7 10 11) *0, disabled.
[    0.463010] vgaarb: device added: PCI:0000:01:05.0,decodes=io+mem,owns=io+mem,locks=none
[    0.463015] vgaarb: loaded
[    0.463090] SCSI subsystem initialized
[    0.463107] libata version 3.00 loaded.
[    0.463107] usbcore: registered new interface driver usbfs
[    0.463107] usbcore: registered new interface driver hub
[    0.463107] usbcore: registered new device driver usb
[    0.463107] wmi: Mapper loaded
[    0.463113] Advanced Linux Sound Architecture Driver Version 1.0.23.
[    0.463115] PCI: Using ACPI for IRQ routing
[    0.463118] PCI: pci_cache_line_size set to 64 bytes
[    0.463127] pci 0000:00:00.0: no compatible bridge window for [mem 0xe0000000-0xffffffff 64bit]
[    0.463214] reserve RAM buffer: 000000000009f800 - 000000000009ffff 
[    0.463218] reserve RAM buffer: 0000000077de0000 - 0000000077ffffff 
[    0.463321] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.463326] hpet0: 4 comparators, 32-bit 14.318180 MHz counter
[    0.464977] Switching to clocksource hpet
[    0.465161] Switched to NOHz mode on CPU #0
[    0.465290] Switched to NOHz mode on CPU #3
[    0.465300] Switched to NOHz mode on CPU #2
[    0.465306] Switched to NOHz mode on CPU #1
[    0.468954] FS-Cache: Loaded
[    0.468979] pnp: PnP ACPI init
[    0.469013] ACPI: bus type pnp registered
[    0.469117] pnp 00:00: [bus 00-ff]
[    0.469121] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.469124] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.469126] pnp 00:00: [io  0x0d00-0xffff window]
[    0.469129] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.469131] pnp 00:00: [mem 0x000c0000-0x000dffff window]
[    0.469134] pnp 00:00: [mem 0xfed40000-0xfed44fff window]
[    0.469136] pnp 00:00: [mem 0x7ff00000-0xfebfffff window]
[    0.469203] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.469214] pnp 00:01: [io  0x0010-0x001f]
[    0.469216] pnp 00:01: [io  0x0022-0x003f]
[    0.469221] pnp 00:01: [io  0x0044-0x004d]
[    0.469223] pnp 00:01: [io  0x0050-0x005f]
[    0.469226] pnp 00:01: [io  0x0062-0x0063]
[    0.469228] pnp 00:01: [io  0x0065-0x006f]
[    0.469230] pnp 00:01: [io  0x0074-0x007f]
[    0.469232] pnp 00:01: [io  0x0091-0x0093]
[    0.469234] pnp 00:01: [io  0x00a2-0x00bf]
[    0.469236] pnp 00:01: [io  0x00e0-0x00ef]
[    0.469238] pnp 00:01: [io  0x04d0-0x04d1]
[    0.469240] pnp 00:01: [io  0x0220-0x0225]
[    0.469242] pnp 00:01: [io  0x0290-0x0294]
[    0.469317] system 00:01: [io  0x04d0-0x04d1] has been reserved
[    0.469322] system 00:01: [io  0x0220-0x0225] has been reserved
[    0.469325] system 00:01: [io  0x0290-0x0294] has been reserved
[    0.469330] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.498094] pnp 00:02: [io  0x4100-0x411f]
[    0.498097] pnp 00:02: [io  0x0228-0x022f]
[    0.498101] pnp 00:02: [io  0x0238-0x023f]
[    0.498103] pnp 00:02: [io  0x040b]
[    0.498105] pnp 00:02: [io  0x04d6]
[    0.498107] pnp 00:02: [io  0x0c00-0x0c01]
[    0.498109] pnp 00:02: [io  0x0c14]
[    0.498111] pnp 00:02: [io  0x0c50-0x0c52]
[    0.498113] pnp 00:02: [io  0x0c6c-0x0c6d]
[    0.498115] pnp 00:02: [io  0x0c6f]
[    0.498117] pnp 00:02: [io  0x0cd0-0x0cd1]
[    0.498119] pnp 00:02: [io  0x0cd2-0x0cd3]
[    0.498122] pnp 00:02: [io  0x0cd4-0x0cdf]
[    0.498124] pnp 00:02: [io  0x4000-0x40fe]
[    0.498126] pnp 00:02: [io  0x4210-0x4217]
[    0.498128] pnp 00:02: [io  0x0b00-0x0b0f]
[    0.498130] pnp 00:02: [io  0x0b10-0x0b1f]
[    0.498132] pnp 00:02: [io  0x0b20-0x0b3f]
[    0.498134] pnp 00:02: [mem 0x00000000-0x00000fff window]
[    0.498137] pnp 00:02: [mem 0xfee00400-0xfee00fff window]
[    0.498143] pnp 00:02: disabling [mem 0x00000000-0x00000fff window] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.498184] pnp 00:02: disabling [mem 0x00000000-0x00000fff window disabled] because it overlaps 0000:02:00.0 BAR 6 [mem 0x00000000-0x0000ffff pref]
[    0.498226] system 00:02: [io  0x4100-0x411f] has been reserved
[    0.498229] system 00:02: [io  0x0228-0x022f] has been reserved
[    0.498232] system 00:02: [io  0x0238-0x023f] has been reserved
[    0.498235] system 00:02: [io  0x040b] has been reserved
[    0.498242] system 00:02: [io  0x04d6] has been reserved
[    0.498245] system 00:02: [io  0x0c00-0x0c01] has been reserved
[    0.498248] system 00:02: [io  0x0c14] has been reserved
[    0.498251] system 00:02: [io  0x0c50-0x0c52] has been reserved
[    0.498253] system 00:02: [io  0x0c6c-0x0c6d] has been reserved
[    0.498256] system 00:02: [io  0x0c6f] has been reserved
[    0.498259] system 00:02: [io  0x0cd0-0x0cd1] has been reserved
[    0.498262] system 00:02: [io  0x0cd2-0x0cd3] has been reserved
[    0.498265] system 00:02: [io  0x0cd4-0x0cdf] has been reserved
[    0.498267] system 00:02: [io  0x4000-0x40fe] has been reserved
[    0.498270] system 00:02: [io  0x4210-0x4217] has been reserved
[    0.498273] system 00:02: [io  0x0b00-0x0b0f] has been reserved
[    0.498276] system 00:02: [io  0x0b10-0x0b1f] has been reserved
[    0.498279] system 00:02: [io  0x0b20-0x0b3f] has been reserved
[    0.498282] system 00:02: [mem 0xfee00400-0xfee00fff window] has been reserved
[    0.498286] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.498407] pnp 00:03: [dma 4]
[    0.498409] pnp 00:03: [io  0x0000-0x000f]
[    0.498411] pnp 00:03: [io  0x0080-0x0090]
[    0.498413] pnp 00:03: [io  0x0094-0x009f]
[    0.498415] pnp 00:03: [io  0x00c0-0x00df]
[    0.498468] pnp 00:03: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.498525] pnp 00:04: [irq 0 disabled]
[    0.498540] pnp 00:04: [irq 8]
[    0.498542] pnp 00:04: [mem 0xfed00000-0xfed003ff]
[    0.498582] pnp 00:04: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.498618] pnp 00:05: [io  0x0070-0x0073]
[    0.498653] pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.498665] pnp 00:06: [io  0x0061]
[    0.498705] pnp 00:06: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.498718] pnp 00:07: [io  0x00f0-0x00ff]
[    0.498733] pnp 00:07: [irq 13]
[    0.498775] pnp 00:07: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.499218] pnp 00:08: [mem 0xe0000000-0xefffffff]
[    0.499300] system 00:08: [mem 0xe0000000-0xefffffff] has been reserved
[    0.499303] system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.499464] pnp 00:09: [mem 0x000d1c00-0x000d3fff]
[    0.499467] pnp 00:09: [mem 0x000f0000-0x000f7fff]
[    0.499469] pnp 00:09: [mem 0x000f8000-0x000fbfff]
[    0.499471] pnp 00:09: [mem 0x000fc000-0x000fffff]
[    0.499473] pnp 00:09: [mem 0x77de0000-0x77dfffff]
[    0.499481] pnp 00:09: [mem 0xffff0000-0xffffffff]
[    0.499483] pnp 00:09: [mem 0x00000000-0x0009ffff]
[    0.499485] pnp 00:09: [mem 0x00100000-0x77ddffff]
[    0.499487] pnp 00:09: [mem 0x77ef0000-0x7feeffff]
[    0.499490] pnp 00:09: [mem 0xfec00000-0xfec00fff]
[    0.499492] pnp 00:09: [mem 0xfee00000-0xfee00fff]
[    0.499494] pnp 00:09: [mem 0xfff80000-0xfffeffff]
[    0.499499] pnp 00:09: disabling [mem 0x000d1c00-0x000d3fff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.499503] pnp 00:09: disabling [mem 0x000f0000-0x000f7fff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.499507] pnp 00:09: disabling [mem 0x000f8000-0x000fbfff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.499511] pnp 00:09: disabling [mem 0x000fc000-0x000fffff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.499515] pnp 00:09: disabling [mem 0x00000000-0x0009ffff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.499519] pnp 00:09: disabling [mem 0x00100000-0x77ddffff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.499601] system 00:09: [mem 0x77de0000-0x77dfffff] could not be reserved
[    0.499604] system 00:09: [mem 0xffff0000-0xffffffff] has been reserved
[    0.499607] system 00:09: [mem 0x77ef0000-0x7feeffff] could not be reserved
[    0.499610] system 00:09: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.499613] system 00:09: [mem 0xfee00000-0xfee00fff] could not be reserved
[    0.499621] system 00:09: [mem 0xfff80000-0xfffeffff] has been reserved
[    0.499625] system 00:09: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.499650] pnp: PnP ACPI: found 10 devices
[    0.499652] ACPI: ACPI bus type pnp unregistered
[    0.506920] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.506924] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    0.506928] pci 0000:00:01.0:   bridge window [mem 0xfde00000-0xfdffffff]
[    0.506932] pci 0000:00:01.0:   bridge window [mem 0xd8000000-0xdfffffff 64bit pref]
[    0.506939] pci 0000:02:00.0: BAR 6: assigned [mem 0xfdb00000-0xfdb0ffff pref]
[    0.506942] pci 0000:00:0a.0: PCI bridge to [bus 02-02]
[    0.506945] pci 0000:00:0a.0:   bridge window [io  0xd000-0xdfff]
[    0.506949] pci 0000:00:0a.0:   bridge window [mem 0xfdd00000-0xfddfffff]
[    0.506952] pci 0000:00:0a.0:   bridge window [mem 0xfdb00000-0xfdbfffff 64bit pref]
[    0.506957] pci 0000:00:14.4: PCI bridge to [bus 03-03]
[    0.506960] pci 0000:00:14.4:   bridge window [io  0xc000-0xcfff]
[    0.506966] pci 0000:00:14.4:   bridge window [mem 0xfdc00000-0xfdcfffff]
[    0.506971] pci 0000:00:14.4:   bridge window [mem 0xf4000000-0xfbffffff pref]
[    0.506998] pci 0000:00:0a.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.507016] pci 0000:00:0a.0: setting latency timer to 64
[    0.507025] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.507027] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.507030] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.507037] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000dffff]
[    0.507039] pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfed44fff]
[    0.507042] pci_bus 0000:00: resource 9 [mem 0x7ff00000-0xfebfffff]
[    0.507044] pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
[    0.507047] pci_bus 0000:01: resource 1 [mem 0xfde00000-0xfdffffff]
[    0.507050] pci_bus 0000:01: resource 2 [mem 0xd8000000-0xdfffffff 64bit pref]
[    0.507052] pci_bus 0000:02: resource 0 [io  0xd000-0xdfff]
[    0.507055] pci_bus 0000:02: resource 1 [mem 0xfdd00000-0xfddfffff]
[    0.507058] pci_bus 0000:02: resource 2 [mem 0xfdb00000-0xfdbfffff 64bit pref]
[    0.507060] pci_bus 0000:03: resource 0 [io  0xc000-0xcfff]
[    0.507063] pci_bus 0000:03: resource 1 [mem 0xfdc00000-0xfdcfffff]
[    0.507065] pci_bus 0000:03: resource 2 [mem 0xf4000000-0xfbffffff pref]
[    0.507072] pci_bus 0000:03: resource 4 [io  0x0000-0x0cf7]
[    0.507075] pci_bus 0000:03: resource 5 [io  0x0d00-0xffff]
[    0.507077] pci_bus 0000:03: resource 6 [mem 0x000a0000-0x000bffff]
[    0.507080] pci_bus 0000:03: resource 7 [mem 0x000c0000-0x000dffff]
[    0.507082] pci_bus 0000:03: resource 8 [mem 0xfed40000-0xfed44fff]
[    0.507085] pci_bus 0000:03: resource 9 [mem 0x7ff00000-0xfebfffff]
[    0.507130] NET: Registered protocol family 2
[    0.507277] IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.508230] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.509878] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.510274] TCP: Hash tables configured (established 262144 bind 65536)
[    0.510277] TCP reno registered
[    0.510286] UDP hash table entries: 1024 (order: 3, 32768 bytes)
[    0.510308] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
[    0.510435] NET: Registered protocol family 1
[    0.510557] RPC: Registered udp transport module.
[    0.510559] RPC: Registered tcp transport module.
[    0.510561] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.510570] pci 0000:00:01.0: MSI quirk detected; subordinate MSI disabled
[    0.626062] pci 0000:01:05.0: Boot video device
[    0.626078] PCI: CLS 4 bytes, default 64
[    0.626136] Unpacking initramfs...
[    0.689517] Freeing initrd memory: 2972k freed
[    0.692502] audit: initializing netlink socket (disabled)
[    0.692523] type=2000 audit(1304969786.691:1): initialized
[    0.711540] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.714161] VFS: Disk quotas dquot_6.5.2
[    0.714239] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.714460] DLM (built May  8 2011 20:42:57) installed
[    0.714942] FS-Cache: Netfs 'nfs' registered for caching
[    0.715110] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    0.715342] fuse init (API version 7.16)
[    0.715456] SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
[    0.716037] SGI XFS Quota Management subsystem
[    0.716046] msgmni has been set to 3752
[    0.716520] alg: No test for stdrng (krng)
[    0.716591] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.716628] io scheduler noop registered
[    0.716630] io scheduler deadline registered
[    0.716691] io scheduler cfq registered (default)
[    0.716870] pcieport 0000:00:0a.0: setting latency timer to 64
[    0.716907] pcieport 0000:00:0a.0: irq 40 for MSI/MSI-X
[    0.717185] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    0.717191] ACPI: Power Button [PWRB]
[    0.717268] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    0.717277] ACPI: Power Button [PWRF]
[    0.717291] ACPI: acpi_idle registered with cpuidle
[    0.749078] ERST: Table is not found!
[    0.749163] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.812270] Linux agpgart interface v0.103
[    0.812298] [drm] Initialized drm 1.1.0 20060810
[    0.812322] [drm] radeon defaulting to kernel modesetting.
[    0.812324] [drm] radeon kernel modesetting enabled.
[    0.812467] radeon 0000:01:05.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.812472] radeon 0000:01:05.0: setting latency timer to 64
[    0.814647] [drm] initializing kernel modesetting (RS780 0x1002:0x9610).
[    0.814671] [drm] register mmio base: 0xFDFE0000
[    0.814673] [drm] register mmio size: 65536
[    0.816933] ATOM BIOS: B27721
[    0.816953] radeon 0000:01:05.0: VRAM: 128M 0x00000000C0000000 - 0x00000000C7FFFFFF (128M used)
[    0.816956] radeon 0000:01:05.0: GTT: 512M 0x00000000A0000000 - 0x00000000BFFFFFFF
[    0.818146] [drm] Detected VRAM RAM=128M, BAR=128M
[    0.818151] [drm] RAM width 32bits DDR
[    0.818246] [TTM] Zone  kernel: Available graphics memory: 960614 kiB.
[    0.818248] [TTM] Initializing pool allocator.
[    0.818267] [drm] radeon: 128M of VRAM memory ready
[    0.818269] [drm] radeon: 512M of GTT memory ready.
[    0.818291] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    0.818293] [drm] Driver supports precise vblank timestamp query.
[    0.818327] [drm] radeon: irq initialized.
[    0.818330] [drm] GART: num cpu pages 131072, num gpu pages 131072
[    0.819216] [drm] Loading RS780 Microcode
[    0.821083] radeon 0000:01:05.0: WB enabled
[    0.852497] [drm] ring test succeeded in 1 usecs
[    0.852654] [drm] radeon: ib pool ready.
[    0.852724] [drm] ib test succeeded in 0 usecs
[    0.852726] [drm] Enabling audio support
[    0.852733] failed to evaluate ATIF got AE_BAD_PARAMETER
[    0.852960] [drm] Radeon Display Connectors
[    0.852962] [drm] Connector 0:
[    0.852963] [drm]   VGA
[    0.852966] [drm]   DDC: 0x7e40 0x7e40 0x7e44 0x7e44 0x7e48 0x7e48 0x7e4c 0x7e4c
[    0.852968] [drm]   Encoders:
[    0.852969] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[    0.852971] [drm] Connector 1:
[    0.852973] [drm]   HDMI-A
[    0.852974] [drm]   HPD1
[    0.852976] [drm]   DDC: 0x7e50 0x7e50 0x7e54 0x7e54 0x7e58 0x7e58 0x7e5c 0x7e5c
[    0.852978] [drm]   Encoders:
[    0.852980] [drm]     DFP1: INTERNAL_KLDSCP_LVTMA
[    0.957617] [drm] radeon: power management initialized
[    0.970466] [drm] forcing VGA-1 connector OFF
[    0.970469] [drm] forcing HDMI-A-1 connector ON
[    1.078171] [drm] fb mappable at 0xD8141000
[    1.078173] [drm] vram apper at 0xD8000000
[    1.078175] [drm] size 8294400
[    1.078176] [drm] fb depth is 24
[    1.078178] [drm]    pitch is 7680
[    1.078241] fbcon: radeondrmfb (fb0) is primary device
[    1.103599] Console: switching to colour frame buffer device 240x67
[    1.114339] fb0: radeondrmfb frame buffer device
[    1.114341] drm: registered panic notifier
[    1.114348] [drm] Initialized radeon 2.8.0 20080528 for 0000:01:05.0 on minor 0
[    1.115219] loop: module loaded
[    1.115300] Loading iSCSI transport class v2.0-870.
[    1.115494] ahci 0000:00:11.0: version 3.0
[    1.115525] ahci 0000:00:11.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    1.115663] ahci 0000:00:11.0: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[    1.115667] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part ccc 
[    1.116956] scsi0 : ahci
[    1.117093] scsi1 : ahci
[    1.117185] scsi2 : ahci
[    1.117276] scsi3 : ahci
[    1.117363] scsi4 : ahci
[    1.117455] scsi5 : ahci
[    1.117627] ata1: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f100 irq 22
[    1.117630] ata2: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f180 irq 22
[    1.117634] ata3: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f200 irq 22
[    1.117638] ata4: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f280 irq 22
[    1.117641] ata5: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f300 irq 22
[    1.117645] ata6: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f380 irq 22
[    1.117803] pata_atiixp 0000:00:14.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.118314] scsi6 : pata_atiixp
[    1.118387] scsi7 : pata_atiixp
[    1.119046] ata7: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xfa00 irq 14
[    1.119049] ata8: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xfa08 irq 15
[    1.119100] bonding: Ethernet Channel Bonding Driver: v3.7.0 (June 2, 2010)
[    1.119104] bonding: Warning: either miimon or arp_interval and arp_ip_target module parameters must be specified, otherwise bonding will not detect link failures! see bonding.txt for details.
[    1.119835] tun: Universal TUN/TAP device driver, 1.6
[    1.119837] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    1.119947] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    1.119962] r8169 0000:02:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    1.119990] r8169 0000:02:00.0: setting latency timer to 64
[    1.120065] r8169 0000:02:00.0: irq 41 for MSI/MSI-X
[    1.120343] r8169 0000:02:00.0: eth0: RTL8168c/8111c at 0xffffc90000352000, 00:1f:d0:82:55:1c, XID 1c4000c0 IRQ 41
[    1.127211] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.127272] ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    1.127285] ehci_hcd 0000:00:12.2: EHCI Host Controller
[    1.127309] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 1
[    1.135030] ehci_hcd 0000:00:12.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    1.135045] ehci_hcd 0000:00:12.2: applying AMD SB600/SB700 USB freeze workaround
[    1.135058] ehci_hcd 0000:00:12.2: debug port 1
[    1.135087] ehci_hcd 0000:00:12.2: irq 17, io mem 0xfe02c000
[    1.141019] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
[    1.141042] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.141046] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.141048] usb usb1: Product: EHCI Host Controller
[    1.141051] usb usb1: Manufacturer: Linux 2.6.38.5-local ehci_hcd
[    1.141053] usb usb1: SerialNumber: 0000:00:12.2
[    1.141169] hub 1-0:1.0: USB hub found
[    1.141174] hub 1-0:1.0: 6 ports detected
[    1.141340] ehci_hcd 0000:00:13.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.141354] ehci_hcd 0000:00:13.2: EHCI Host Controller
[    1.141365] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 2
[    1.147026] ehci_hcd 0000:00:13.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    1.147040] ehci_hcd 0000:00:13.2: applying AMD SB600/SB700 USB freeze workaround
[    1.147054] ehci_hcd 0000:00:13.2: debug port 1
[    1.147083] ehci_hcd 0000:00:13.2: irq 19, io mem 0xfe029000
[    1.153019] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
[    1.153034] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    1.153037] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.153040] usb usb2: Product: EHCI Host Controller
[    1.153042] usb usb2: Manufacturer: Linux 2.6.38.5-local ehci_hcd
[    1.153044] usb usb2: SerialNumber: 0000:00:13.2
[    1.153148] hub 2-0:1.0: USB hub found
[    1.153152] hub 2-0:1.0: 6 ports detected
[    1.153273] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.153319] ohci_hcd 0000:00:12.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.153331] ohci_hcd 0000:00:12.0: OHCI Host Controller
[    1.153340] ohci_hcd 0000:00:12.0: new USB bus registered, assigned bus number 3
[    1.159051] ohci_hcd 0000:00:12.0: irq 16, io mem 0xfe02e000
[    1.214063] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    1.214066] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.214069] usb usb3: Product: OHCI Host Controller
[    1.214075] usb usb3: Manufacturer: Linux 2.6.38.5-local ohci_hcd
[    1.214077] usb usb3: SerialNumber: 0000:00:12.0
[    1.214187] hub 3-0:1.0: USB hub found
[    1.214194] hub 3-0:1.0: 3 ports detected
[    1.214324] ohci_hcd 0000:00:12.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.214334] ohci_hcd 0000:00:12.1: OHCI Host Controller
[    1.214343] ohci_hcd 0000:00:12.1: new USB bus registered, assigned bus number 4
[    1.219031] ohci_hcd 0000:00:12.1: irq 16, io mem 0xfe02d000
[    1.274070] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    1.274073] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.274077] usb usb4: Product: OHCI Host Controller
[    1.274080] usb usb4: Manufacturer: Linux 2.6.38.5-local ohci_hcd
[    1.274083] usb usb4: SerialNumber: 0000:00:12.1
[    1.274187] hub 4-0:1.0: USB hub found
[    1.274194] hub 4-0:1.0: 3 ports detected
[    1.274324] ohci_hcd 0000:00:13.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    1.274337] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    1.274346] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 5
[    1.283033] ohci_hcd 0000:00:13.0: irq 18, io mem 0xfe02b000
[    1.338062] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    1.338065] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.338067] usb usb5: Product: OHCI Host Controller
[    1.338070] usb usb5: Manufacturer: Linux 2.6.38.5-local ohci_hcd
[    1.338072] usb usb5: SerialNumber: 0000:00:13.0
[    1.338189] hub 5-0:1.0: USB hub found
[    1.338195] hub 5-0:1.0: 3 ports detected
[    1.338333] ohci_hcd 0000:00:13.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    1.338344] ohci_hcd 0000:00:13.1: OHCI Host Controller
[    1.338352] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 6
[    1.343032] ohci_hcd 0000:00:13.1: irq 18, io mem 0xfe02a000
[    1.398060] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    1.398063] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.398066] usb usb6: Product: OHCI Host Controller
[    1.398068] usb usb6: Manufacturer: Linux 2.6.38.5-local ohci_hcd
[    1.398070] usb usb6: SerialNumber: 0000:00:13.1
[    1.398197] hub 6-0:1.0: USB hub found
[    1.398203] hub 6-0:1.0: 3 ports detected
[    1.398349] ohci_hcd 0000:00:14.5: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    1.398361] ohci_hcd 0000:00:14.5: OHCI Host Controller
[    1.398373] ohci_hcd 0000:00:14.5: new USB bus registered, assigned bus number 7
[    1.403033] ohci_hcd 0000:00:14.5: irq 18, io mem 0xfe028000
[    1.423053] ata6: SATA link down (SStatus 0 SControl 300)
[    1.423092] ata5: SATA link down (SStatus 0 SControl 300)
[    1.424055] ata4: SATA link down (SStatus 0 SControl 300)
[    1.458094] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    1.458097] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.458100] usb usb7: Product: OHCI Host Controller
[    1.458102] usb usb7: Manufacturer: Linux 2.6.38.5-local ohci_hcd
[    1.458104] usb usb7: SerialNumber: 0000:00:14.5
[    1.458220] hub 7-0:1.0: USB hub found
[    1.458226] hub 7-0:1.0: 2 ports detected
[    1.458364] usbcore: registered new interface driver libusual
[    1.458410] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    1.458868] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.458876] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.458990] mousedev: PS/2 mouse device common for all mice
[    1.459204] input: PC Speaker as /devices/platform/pcspkr/input/input2
[    1.459271] rtc_cmos 00:05: RTC can wake from S4
[    1.467067] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    1.467103] rtc0: alarms up to one month, 242 bytes nvram, hpet irqs
[    1.467166] ACPI: resource piix4_smbus [io  0x0b00-0x0b07] conflicts with ACPI region SOR1 [io 0xb00-0xb0f]
[    1.467169] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    1.467330] it87: Found IT8718F chip at 0x228, revision 5
[    1.467352] it87: Beeping is supported
[    1.467668] k10temp 0000:00:18.3: unreliable CPU thermal sensor; monitoring disabled
[    1.467822] pc87360: PC8736x not detected, module not inserted
[    1.467896] md: linear personality registered for level -1
[    1.467899] md: raid0 personality registered for level 0
[    1.467901] md: raid1 personality registered for level 1
[    1.467903] md: raid10 personality registered for level 10
[    1.467905] md: raid6 personality registered for level 6
[    1.467907] md: raid5 personality registered for level 5
[    1.467910] md: raid4 personality registered for level 4
[    1.467996] device-mapper: uevent: version 1.0.3
[    1.468115] device-mapper: ioctl: 4.19.1-ioctl (2011-01-07) initialised: dm-devel@redhat.com
[    1.468234] EDAC MC: Ver: 2.1.0 May  8 2011
[    1.468386] cpuidle: using governor ladder
[    1.468389] cpuidle: using governor menu
[    1.468541] usbcore: registered new interface driver usbhid
[    1.468542] usbhid: USB HID core driver
[    1.468602] Error: Driver 'pcspkr' is already registered, aborting...
[    1.468739] HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.468744] hda_intel: position_fix set to 1 for device 1458:a022
[    1.480536] hda_codec: ALC889A: BIOS auto-probing.
[    1.487845] input: HDA ATI SB Headphone as /devices/pci0000:00/0000:00:14.2/sound/card0/input3
[    1.488054] HDA Intel 0000:01:05.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.488075] HDA Intel 0000:01:05.1: setting latency timer to 64
[    1.492472] ALSA device list:
[    1.492474]   #0: HDA ATI SB at 0xfe024000 irq 16
[    1.492477]   #1: HDA ATI HDMI at 0xfdffc000 irq 19
[    1.492830] TCP cubic registered
[    1.492833] NET: Registered protocol family 17
[    1.493660] sctp: Hash tables configured (established 65536 bind 65536)
[    1.493803] Registering the dns_resolver key type
[    1.493850] powernow-k8: Found 1 AMD Phenom(tm) 9550 Quad-Core Processor (4 cpu cores) (version 2.20.00)
[    1.493891] powernow-k8:    0 : pstate 0 (2200 MHz)
[    1.493893] powernow-k8:    1 : pstate 1 (1100 MHz)
[    1.494251] PM: Hibernation image not present or could not be loaded.
[    1.494269] registered taskstats version 1
[    1.494698] rtc_cmos 00:05: setting system clock to 2011-05-09 19:36:27 UTC (1304969787)
[    1.494724] Initalizing network drop monitor service
[    1.577037] ata1: softreset failed (device not ready)
[    1.577090] ata1: applying SB600 PMP SRST workaround and retrying
[    1.579046] ata2: softreset failed (device not ready)
[    1.579138] ata2: applying SB600 PMP SRST workaround and retrying
[    1.579159] ata3: softreset failed (device not ready)
[    1.579248] ata3: applying SB600 PMP SRST workaround and retrying
[    1.647038] usb 2-2: new high speed USB device using ehci_hcd and address 2
[    1.692056] Refined TSC clocksource calibration: 2210.064 MHz.
[    1.692062] Switching to clocksource tsc
[    1.732059] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.732254] ata1.00: HPA detected: current 62525039, native 62533296
[    1.732303] ata1.00: ATA-7: OCZ-VERTEX v1.10, 1370, max UDMA/133
[    1.732309] ata1.00: 62525039 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    1.732561] ata1.00: configured for UDMA/133
[    1.732795] scsi 0:0:0:0: Direct-Access     ATA      OCZ-VERTEX v1.10 1370 PQ: 0 ANSI: 5
[    1.733147] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.733170] sd 0:0:0:0: [sda] 62525039 512-byte logical blocks: (32.0 GB/29.8 GiB)
[    1.733410] sd 0:0:0:0: [sda] Write Protect is off
[    1.733417] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.733478] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.734032] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.734059] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.734188]  sda: sda1
[    1.734526] ata2.00: ATAPI: TSSTcorp CDDVDW SH-S223Q, SB02, max UDMA/100
[    1.734696] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.735271] ata2.00: configured for UDMA/100
[    1.736140] scsi 1:0:0:0: CD-ROM            TSSTcorp CDDVDW SH-S223Q  SB02 PQ: 0 ANSI: 5
[    1.739694] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[    1.739700] cdrom: Uniform CD-ROM driver Revision: 3.20
[    1.739915] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    1.740070] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    1.763545] usb 2-2: New USB device found, idVendor=058f, idProduct=6362
[    1.763551] usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    1.763556] usb 2-2: Product: Mass Storage Device
[    1.763561] usb 2-2: Manufacturer: Generic
[    1.763565] usb 2-2: SerialNumber: 058F63626376
[    1.769602] ata3.00: ATA-7: ST3320620AS, 3.AAK, max UDMA/133
[    1.769611] ata3.00: 625142448 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    1.827911] ata3.00: configured for UDMA/133
[    1.828116] scsi 2:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
[    1.828417] sd 2:0:0:0: [sdb] 625142448 512-byte logical blocks: (320 GB/298 GiB)
[    1.828440] sd 2:0:0:0: Attached scsi generic sg2 type 0
[    1.828625] sd 2:0:0:0: [sdb] Write Protect is off
[    1.828633] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    1.828702] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.867946]  sdb: sdb1 sdb2
[    1.868541] sd 2:0:0:0: [sdb] Attached SCSI disk
[    1.871441] Freeing unused kernel memory: 620k freed
[    1.871703] Write protecting the kernel read-only data: 10240k
[    1.875286] Freeing unused kernel memory: 424k freed
[    1.886074] Freeing unused kernel memory: 1636k freed
[    1.914516] <30>udevd[148]: starting version 168
[    1.991038] usb 3-2: new full speed USB device using ohci_hcd and address 2
[    2.142110] usb 3-2: New USB device found, idVendor=1784, idProduct=0001
[    2.142118] usb 3-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    2.142125] usb 3-2: Product: eHome Infrared Transceiver
[    2.142130] usb 3-2: Manufacturer: Topseed
[    2.142133] usb 3-2: SerialNumber: TS000ueo
[    2.371037] usb 4-2: new low speed USB device using ohci_hcd and address 2
[    2.523125] usb 4-2: New USB device found, idVendor=04b3, idProduct=3025
[    2.523131] usb 4-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    2.523137] usb 4-2: Product: USB NetVista Full Width Keyboard.
[    2.523142] usb 4-2: Manufacturer: LITE-ON Technology
[    2.541213] input: LITE-ON Technology USB NetVista Full Width Keyboard. as /devices/pci0000:00/0000:00:12.1/usb4/4-2/4-2:1.0/input/input4
[    2.541404] generic-usb 0003:04B3:3025.0001: input,hidraw0: USB HID v1.10 Keyboard [LITE-ON Technology USB NetVista Full Width Keyboard.] on usb-0000:00:12.1-2/input0
[    2.768035] usb 4-3: new low speed USB device using ohci_hcd and address 3
[    2.918138] usb 4-3: New USB device found, idVendor=046d, idProduct=c517
[    2.918144] usb 4-3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    2.918150] usb 4-3: Product: USB Receiver
[    2.918154] usb 4-3: Manufacturer: Logitech
[    2.931210] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:12.1/usb4/4-3/4-3:1.0/input/input5
[    2.931404] logitech 0003:046D:C517.0002: input,hidraw1: USB HID v1.10 Keyboard [Logitech USB Receiver] on usb-0000:00:12.1-3/input0
[    2.938136] logitech 0003:046D:C517.0003: fixing up Logitech keyboard report descriptor
[    2.939355] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:12.1/usb4/4-3/4-3:1.1/input/input6
[    2.939731] logitech 0003:046D:C517.0003: input,hiddev0,hidraw2: USB HID v1.10 Mouse [Logitech USB Receiver] on usb-0000:00:12.1-3/input1
[    3.257479] PM: Starting manual resume from disk
[    3.257486] PM: Hibernation image partition 8:17 present
[    3.257491] PM: Looking for hibernation image.
[    3.257722] PM: Image not found (code -22)
[    3.257729] PM: Hibernation image not present or could not be loaded.
[    3.262362] EXT3-fs: barriers not enabled
[    3.262583] kjournald starting.  Commit interval 5 seconds
[    3.262660] EXT3-fs (sda1): mounted filesystem with ordered data mode
[    3.425973] <30>udevd[358]: starting version 168
[    3.556632] IR NEC protocol handler initialized
[    3.564312] IR RC5(x) protocol handler initialized
[    3.572854] IR RC6 protocol handler initialized
[    3.582025] Registered IR keymap rc-rc6-mce
[    3.582163] input: Media Center Ed. eHome Infrared Remote Transceiver (1784:0001) as /devices/pci0000:00/0000:00:12.0/usb3/3-2/3-2:1.0/rc/rc0/input7
[    3.582280] rc0: Media Center Ed. eHome Infrared Remote Transceiver (1784:0001) as /devices/pci0000:00/0000:00:12.0/usb3/3-2/3-2:1.0/rc/rc0
[    3.582936] IR JVC protocol handler initialized
[    3.583433] mceusb 3-2:1.0: Registered Topseed eHome Infrared Transceiver on usb3:2
[    3.583474] usbcore: registered new interface driver mceusb
[    3.593332] IR Sony protocol handler initialized
[    3.596082] usbcore: registered new interface driver uas
[    3.601628] lirc_dev: IR Remote Control driver registered, major 250 
[    3.604670] rc rc0: lirc_dev: driver ir-lirc-codec (mceusb) registered at minor = 0
[    3.604675] IR LIRC bridge handler initialized
[    5.840338] Adding 7815584k swap on /dev/sdb1.  Priority:-1 extents:1 across:7815584k 
[    5.882101] EXT3-fs (sda1): using internal journal
[    6.616676] EXT3-fs: barriers not enabled
[    6.629230] kjournald starting.  Commit interval 5 seconds
[    6.629609] EXT3-fs (dm-0): using internal journal
[    6.629619] EXT3-fs (dm-0): mounted filesystem with ordered data mode
[    6.695745] EXT4-fs (dm-1): mounted filesystem with ordered data mode. Opts: (null)
[    7.507878] r8169 0000:02:00.0: eth0: link down
[    7.507890] r8169 0000:02:00.0: eth0: link down
[    9.630844] r8169 0000:02:00.0: eth0: link up
[   10.401429] EXT4-fs (dm-1): re-mounted. Opts: commit=0

--Boundary-00=_TWEyNZVAFaW908q
Content-Type: text/x-log;
  charset="UTF-8";
  name="Xorg.0.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="Xorg.0.log"

[     7.743] 
X.Org X Server 1.10.1
Release Date: 2011-04-15
[     7.743] X Protocol Version 11, Revision 0
[     7.743] Build Operating System: Linux 2.6.32-5-amd64 x86_64 Debian
[     7.743] Current Operating System: Linux chauncey 2.6.38.5-local #14 SMP PREEMPT Sun May 8 23:19:24 MDT 2011 x86_64
[     7.743] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.38.5-local root=UUID=f0797db1-b72e-43bc-9267-1c1f7a3736b5 ro video=HDMI-A-1:1920x1080@59.9D video=VGA-1:d quiet
[     7.743] Build Date: 28 April 2011  12:13:00PM
[     7.743] xorg-server 2:1.10.1-2 (Julien Cristau <jcristau@debian.org>) 
[     7.743] Current version of pixman: 0.21.8
[     7.743] 	Before reporting problems, check http://wiki.x.org
	to make sure that you have the latest version.
[     7.743] Markers: (--) probed, (**) from config file, (==) default setting,
	(++) from command line, (!!) notice, (II) informational,
	(WW) warning, (EE) error, (NI) not implemented, (??) unknown.
[     7.744] (==) Log file: "/var/log/Xorg.0.log", Time: Mon May  9 13:36:33 2011
[     7.746] (==) Using config file: "/etc/X11/xorg.conf"
[     7.746] (==) Using system config directory "/usr/share/X11/xorg.conf.d"
[     7.749] (==) ServerLayout "X.org Configured"
[     7.749] (**) |-->Screen "Screen0" (0)
[     7.749] (**) |   |-->Monitor "HDMI-0"
[     7.749] (**) |   |-->Device "Card0"
[     7.749] (**) |-->Input Device "Mouse0"
[     7.749] (**) |-->Input Device "Keyboard0"
[     7.749] (==) Automatically adding devices
[     7.749] (==) Automatically enabling devices
[     7.751] (WW) The directory "/usr/share/fonts/X11/cyrillic" does not exist.
[     7.751] 	Entry deleted from font path.
[     7.754] (WW) The directory "/usr/share/fonts/X11/cyrillic" does not exist.
[     7.754] 	Entry deleted from font path.
[     7.754] (**) FontPath set to:
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
[     7.754] (**) ModulePath set to "/usr/lib/xorg/modules"
[     7.754] (WW) Hotplugging is on, devices using drivers 'kbd', 'mouse' or 'vmmouse' will be disabled.
[     7.754] (WW) Disabling Mouse0
[     7.754] (WW) Disabling Keyboard0
[     7.754] (II) Loader magic: 0x7dba00
[     7.754] (II) Module ABI versions:
[     7.754] 	X.Org ANSI C Emulation: 0.4
[     7.754] 	X.Org Video Driver: 10.0
[     7.754] 	X.Org XInput driver : 12.2
[     7.754] 	X.Org Server Extension : 5.0
[     7.756] (--) PCI:*(0:1:5:0) 1002:9610:1458:d000 rev 0, Mem @ 0xd8000000/134217728, 0xfdfe0000/65536, 0xfde00000/1048576, I/O @ 0x0000ee00/256
[     7.756] (--) PCI: (0:3:6:0) 4444:0016:0070:8801 rev 1, Mem @ 0xf8000000/67108864
[     7.756] (--) PCI: (0:3:7:0) 4444:0016:0070:8801 rev 1, Mem @ 0xf4000000/67108864
[     7.757] (II) Open ACPI successful (/var/run/acpid.socket)
[     7.757] (II) "extmod" will be loaded. This was enabled by default and also specified in the config file.
[     7.757] (II) "dbe" will be loaded. This was enabled by default and also specified in the config file.
[     7.757] (II) "glx" will be loaded. This was enabled by default and also specified in the config file.
[     7.757] (II) "record" will be loaded. This was enabled by default and also specified in the config file.
[     7.757] (II) "dri" will be loaded. This was enabled by default and also specified in the config file.
[     7.757] (II) "dri2" will be loaded. This was enabled by default and also specified in the config file.
[     7.757] (II) LoadModule: "dri2"
[     7.760] (II) Loading /usr/lib/xorg/modules/extensions/libdri2.so
[     7.763] (II) Module dri2: vendor="X.Org Foundation"
[     7.763] 	compiled for 1.10.1, module version = 1.2.0
[     7.763] 	ABI class: X.Org Server Extension, version 5.0
[     7.763] (II) Loading extension DRI2
[     7.763] (II) LoadModule: "dbe"
[     7.763] (II) Loading /usr/lib/xorg/modules/extensions/libdbe.so
[     7.764] (II) Module dbe: vendor="X.Org Foundation"
[     7.764] 	compiled for 1.10.1, module version = 1.0.0
[     7.764] 	Module class: X.Org Server Extension
[     7.764] 	ABI class: X.Org Server Extension, version 5.0
[     7.764] (II) Loading extension DOUBLE-BUFFER
[     7.764] (II) LoadModule: "glx"
[     7.764] (II) Loading /usr/lib/xorg/modules/extensions/libglx.so
[     7.768] (II) Module glx: vendor="X.Org Foundation"
[     7.768] 	compiled for 1.10.1, module version = 1.0.0
[     7.768] 	ABI class: X.Org Server Extension, version 5.0
[     7.768] (==) AIGLX enabled
[     7.768] (II) Loading extension GLX
[     7.769] (II) LoadModule: "extmod"
[     7.769] (II) Loading /usr/lib/xorg/modules/extensions/libextmod.so
[     7.771] (II) Module extmod: vendor="X.Org Foundation"
[     7.772] 	compiled for 1.10.1, module version = 1.0.0
[     7.772] 	Module class: X.Org Server Extension
[     7.772] 	ABI class: X.Org Server Extension, version 5.0
[     7.772] (II) Loading extension SELinux
[     7.772] (II) Loading extension MIT-SCREEN-SAVER
[     7.772] (II) Loading extension XFree86-VidModeExtension
[     7.772] (II) Loading extension XFree86-DGA
[     7.772] (II) Loading extension DPMS
[     7.772] (II) Loading extension XVideo
[     7.772] (II) Loading extension XVideo-MotionCompensation
[     7.772] (II) Loading extension X-Resource
[     7.772] (II) LoadModule: "record"
[     7.772] (II) Loading /usr/lib/xorg/modules/extensions/librecord.so
[     7.773] (II) Module record: vendor="X.Org Foundation"
[     7.773] 	compiled for 1.10.1, module version = 1.13.0
[     7.773] 	Module class: X.Org Server Extension
[     7.773] 	ABI class: X.Org Server Extension, version 5.0
[     7.773] (II) Loading extension RECORD
[     7.773] (II) LoadModule: "dri"
[     7.773] (II) Loading /usr/lib/xorg/modules/extensions/libdri.so
[     7.774] (II) Module dri: vendor="X.Org Foundation"
[     7.774] 	compiled for 1.10.1, module version = 1.0.0
[     7.774] 	ABI class: X.Org Server Extension, version 5.0
[     7.774] (II) Loading extension XFree86-DRI
[     7.774] (II) LoadModule: "radeon"
[     7.774] (II) Loading /usr/lib/xorg/modules/drivers/radeon_drv.so
[     7.781] (II) Module radeon: vendor="X.Org Foundation"
[     7.781] 	compiled for 1.10.1, module version = 6.14.1
[     7.781] 	Module class: X.Org Video Driver
[     7.781] 	ABI class: X.Org Video Driver, version 10.0
[     7.782] (II) RADEON: Driver for ATI Radeon chipsets:
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
[     7.791] (--) using VT number 2

[     7.814] (II) Loading /usr/lib/xorg/modules/drivers/radeon_drv.so
[     7.814] (II) [KMS] Kernel modesetting enabled.
[     7.815] (==) RADEON(0): Depth 24, (--) framebuffer bpp 32
[     7.815] (II) RADEON(0): Pixel depth = 24 bits stored in 4 bytes (32 bpp pixmaps)
[     7.815] (==) RADEON(0): Default visual is TrueColor
[     7.815] (**) RADEON(0): Option "IgnoreEDID" "on"
[     7.815] (==) RADEON(0): RGB weight 888
[     7.815] (II) RADEON(0): Using 8 bits per RGB (8 bit DAC)
[     7.815] (--) RADEON(0): Chipset: "ATI Radeon HD 3200 Graphics" (ChipID = 0x9610)
[     7.815] (II) RADEON(0): PCI card detected
[     7.815] drmOpenDevice: node name is /dev/dri/card0
[     7.815] drmOpenDevice: open result is 9, (OK)
[     7.815] drmOpenByBusid: Searching for BusID pci:0000:01:05.0
[     7.815] drmOpenDevice: node name is /dev/dri/card0
[     7.815] drmOpenDevice: open result is 9, (OK)
[     7.815] drmOpenByBusid: drmOpenMinor returns 9
[     7.815] drmOpenByBusid: drmGetBusid reports pci:0000:01:05.0
[     7.815] (II) Loading sub module "exa"
[     7.815] (II) LoadModule: "exa"
[     7.816] (II) Loading /usr/lib/xorg/modules/libexa.so
[     7.817] (II) Module exa: vendor="X.Org Foundation"
[     7.817] 	compiled for 1.10.1, module version = 2.5.0
[     7.817] 	ABI class: X.Org Video Driver, version 10.0
[     7.817] (II) RADEON(0): KMS Color Tiling: disabled
[     7.817] (II) RADEON(0): KMS Pageflipping: enabled
[     7.817] (II) RADEON(0): SwapBuffers wait for vsync: enabled
[     7.818] (II) RADEON(0): Output VGA-0 using monitor section VGA-0
[     7.818] (**) RADEON(0): Option "Ignore" "true"
[     7.818] (II) RADEON(0): Output HDMI-0 using monitor section HDMI-0
[     7.818] (II) RADEON(0): EDID for output HDMI-0
[     7.818] (II) RADEON(0): Manufacturer: BNQ  Model: 790e  Serial#: 21573
[     7.818] (II) RADEON(0): Year: 2009  Week: 6
[     7.818] (II) RADEON(0): EDID Version: 1.3
[     7.818] (II) RADEON(0): Digital Display Input
[     7.818] (II) RADEON(0): Max Image Size [cm]: horiz.: 48  vert.: 27
[     7.819] (II) RADEON(0): Gamma: 2.20
[     7.819] (II) RADEON(0): DPMS capabilities: Off
[     7.819] (II) RADEON(0): Supported color encodings: RGB 4:4:4 YCrCb 4:4:4 
[     7.819] (II) RADEON(0): Default color space is primary color space
[     7.819] (II) RADEON(0): First detailed timing is preferred mode
[     7.819] (II) RADEON(0): redX: 0.640 redY: 0.330   greenX: 0.300 greenY: 0.600
[     7.819] (II) RADEON(0): blueX: 0.150 blueY: 0.060   whiteX: 0.313 whiteY: 0.329
[     7.819] (II) RADEON(0): Supported established timings:
[     7.819] (II) RADEON(0): 720x400@70Hz
[     7.819] (II) RADEON(0): 640x480@60Hz
[     7.819] (II) RADEON(0): 640x480@67Hz
[     7.819] (II) RADEON(0): 640x480@72Hz
[     7.819] (II) RADEON(0): 640x480@75Hz
[     7.819] (II) RADEON(0): 800x600@56Hz
[     7.819] (II) RADEON(0): 800x600@60Hz
[     7.819] (II) RADEON(0): 800x600@72Hz
[     7.819] (II) RADEON(0): 800x600@75Hz
[     7.819] (II) RADEON(0): 832x624@75Hz
[     7.819] (II) RADEON(0): 1024x768@60Hz
[     7.819] (II) RADEON(0): 1024x768@70Hz
[     7.819] (II) RADEON(0): 1024x768@75Hz
[     7.819] (II) RADEON(0): 1280x1024@75Hz
[     7.819] (II) RADEON(0): 1152x864@75Hz
[     7.819] (II) RADEON(0): Manufacturer's mask: 0
[     7.819] (II) RADEON(0): Supported standard timings:
[     7.819] (II) RADEON(0): #0: hsize: 1280  vsize 720  refresh: 60  vid: 49281
[     7.819] (II) RADEON(0): #1: hsize: 1280  vsize 960  refresh: 60  vid: 16513
[     7.819] (II) RADEON(0): #2: hsize: 1280  vsize 1024  refresh: 60  vid: 32897
[     7.819] (II) RADEON(0): #3: hsize: 1440  vsize 900  refresh: 60  vid: 149
[     7.819] (II) RADEON(0): #4: hsize: 1600  vsize 1200  refresh: 60  vid: 16553
[     7.819] (II) RADEON(0): #5: hsize: 1680  vsize 1050  refresh: 60  vid: 179
[     7.819] (II) RADEON(0): #6: hsize: 1920  vsize 1080  refresh: 60  vid: 49361
[     7.819] (II) RADEON(0): Supported detailed timing:
[     7.819] (II) RADEON(0): clock: 138.5 MHz   Image Size:  480 x 270 mm
[     7.819] (II) RADEON(0): h_active: 1920  h_sync: 1968  h_sync_end 2000 h_blank_end 2080 h_border: 0
[     7.819] (II) RADEON(0): v_active: 1080  v_sync: 1083  v_sync_end 1088 v_blanking: 1111 v_border: 0
[     7.819] (II) RADEON(0): Ranges: V min: 55 V max: 85 Hz, H min: 30 H max: 83 kHz, PixClock max 215 MHz
[     7.819] (II) RADEON(0): Monitor name: BENQ E2400HD
[     7.819] (II) RADEON(0): Serial No: 22900384019
[     7.819] (II) RADEON(0): Supported detailed timing:
[     7.819] (II) RADEON(0): clock: 27.0 MHz   Image Size:  480 x 270 mm
[     7.819] (II) RADEON(0): h_active: 720  h_sync: 736  h_sync_end 798 h_blank_end 858 h_border: 0
[     7.819] (II) RADEON(0): v_active: 480  v_sync: 489  v_sync_end 495 v_blanking: 525 v_border: 0
[     7.819] (II) RADEON(0): Supported detailed timing:
[     7.819] (II) RADEON(0): clock: 74.2 MHz   Image Size:  480 x 270 mm
[     7.819] (II) RADEON(0): h_active: 1280  h_sync: 1390  h_sync_end 1430 h_blank_end 1650 h_border: 0
[     7.819] (II) RADEON(0): v_active: 720  v_sync: 725  v_sync_end 730 v_blanking: 750 v_border: 0
[     7.819] (II) RADEON(0): Supported detailed timing:
[     7.819] (II) RADEON(0): clock: 74.2 MHz   Image Size:  480 x 270 mm
[     7.819] (II) RADEON(0): h_active: 1280  h_sync: 1720  h_sync_end 1760 h_blank_end 1980 h_border: 0
[     7.819] (II) RADEON(0): v_active: 720  v_sync: 725  v_sync_end 730 v_blanking: 750 v_border: 0
[     7.819] (II) RADEON(0): Supported detailed timing:
[     7.819] (II) RADEON(0): clock: 27.0 MHz   Image Size:  480 x 270 mm
[     7.819] (II) RADEON(0): h_active: 720  h_sync: 732  h_sync_end 796 h_blank_end 864 h_border: 0
[     7.819] (II) RADEON(0): v_active: 576  v_sync: 581  v_sync_end 586 v_blanking: 625 v_border: 0
[     7.819] (II) RADEON(0): Supported detailed timing:
[     7.819] (II) RADEON(0): clock: 27.0 MHz   Image Size:  480 x 270 mm
[     7.819] (II) RADEON(0): h_active: 1440  h_sync: 1464  h_sync_end 1590 h_blank_end 1728 h_border: 0
[     7.819] (II) RADEON(0): v_active: 288  v_sync: 290  v_sync_end 293 v_blanking: 312 v_border: 0
[     7.819] (II) RADEON(0): Number of EDID sections to follow: 1
[     7.819] (II) RADEON(0): EDID (in hex):
[     7.819] (II) RADEON(0): 	00ffffffffffff0009d10e7945540000
[     7.819] (II) RADEON(0): 	0613010380301b782eee95a3544c9926
[     7.819] (II) RADEON(0): 	0f5054bfef8081c0814081809500a940
[     7.819] (II) RADEON(0): 	b300d1c001011a3680a070381f403020
[     7.819] (II) RADEON(0): 	3500e00e1100001e000000fd0037551e
[     7.819] (II) RADEON(0): 	5315000a202020202020000000fc0042
[     7.819] (II) RADEON(0): 	454e5120453234303048440a000000ff
[     7.819] (II) RADEON(0): 	0032323930303338343031390a20011c
[     7.819] (II) RADEON(0): 	020321714c1005041303120716011415
[     7.819] (II) RADEON(0): 	1f230907078301000067030c00100038
[     7.819] (II) RADEON(0): 	2d8c0ad08a20e02d10103e9600e00e11
[     7.819] (II) RADEON(0): 	000018011d007251d01e206e285500e0
[     7.819] (II) RADEON(0): 	0e1100001e011d00bc52d01e20b82855
[     7.819] (II) RADEON(0): 	40e00e1100001e8c0ad090204031200c
[     7.819] (II) RADEON(0): 	405500e00e110000188c0aa020512018
[     7.819] (II) RADEON(0): 	10187e2300e00e110000980000000044
[     7.819] (II) RADEON(0): EDID vendor "BNQ", prod id 30990
[     7.820] (II) RADEON(0): Using EDID range info for horizontal sync
[     7.820] (II) RADEON(0): Using EDID range info for vertical refresh
[     7.820] (II) RADEON(0): Printing DDC gathered Modelines:
[     7.820] (II) RADEON(0): Modeline "1920x1080"x0.0  138.50  1920 1968 2000 2080  1080 1083 1088 1111 +hsync +vsync (66.6 kHz)
[     7.820] (II) RADEON(0): Modeline "720x480"x0.0   27.00  720 736 798 858  480 489 495 525 -hsync -vsync (31.5 kHz)
[     7.820] (II) RADEON(0): Modeline "1280x720"x0.0   74.25  1280 1390 1430 1650  720 725 730 750 +hsync +vsync (45.0 kHz)
[     7.820] (II) RADEON(0): Modeline "1280x720"x0.0   74.25  1280 1720 1760 1980  720 725 730 750 +hsync +vsync (37.5 kHz)
[     7.820] (II) RADEON(0): Modeline "720x576"x0.0   27.00  720 732 796 864  576 581 586 625 -hsync -vsync (31.2 kHz)
[     7.820] (II) RADEON(0): Modeline "1440x576i"x0.0   27.00  1440 1464 1590 1728  576 580 586 625 interlace -hsync -vsync (15.6 kHz)
[     7.820] (II) RADEON(0): Modeline "800x600"x0.0   40.00  800 840 968 1056  600 601 605 628 +hsync +vsync (37.9 kHz)
[     7.820] (II) RADEON(0): Modeline "800x600"x0.0   36.00  800 824 896 1024  600 601 603 625 +hsync +vsync (35.2 kHz)
[     7.820] (II) RADEON(0): Modeline "640x480"x0.0   31.50  640 656 720 840  480 481 484 500 -hsync -vsync (37.5 kHz)
[     7.820] (II) RADEON(0): Modeline "640x480"x0.0   31.50  640 664 704 832  480 489 492 520 -hsync -vsync (37.9 kHz)
[     7.820] (II) RADEON(0): Modeline "640x480"x0.0   30.24  640 704 768 864  480 483 486 525 -hsync -vsync (35.0 kHz)
[     7.820] (II) RADEON(0): Modeline "640x480"x0.0   25.18  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz)
[     7.820] (II) RADEON(0): Modeline "720x400"x0.0   28.32  720 738 846 900  400 412 414 449 -hsync +vsync (31.5 kHz)
[     7.820] (II) RADEON(0): Modeline "1280x1024"x0.0  135.00  1280 1296 1440 1688  1024 1025 1028 1066 +hsync +vsync (80.0 kHz)
[     7.820] (II) RADEON(0): Modeline "1024x768"x0.0   78.75  1024 1040 1136 1312  768 769 772 800 +hsync +vsync (60.0 kHz)
[     7.820] (II) RADEON(0): Modeline "1024x768"x0.0   75.00  1024 1048 1184 1328  768 771 777 806 -hsync -vsync (56.5 kHz)
[     7.820] (II) RADEON(0): Modeline "1024x768"x0.0   65.00  1024 1048 1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz)
[     7.820] (II) RADEON(0): Modeline "832x624"x0.0   57.28  832 864 928 1152  624 625 628 667 -hsync -vsync (49.7 kHz)
[     7.820] (II) RADEON(0): Modeline "800x600"x0.0   49.50  800 816 896 1056  600 601 604 625 +hsync +vsync (46.9 kHz)
[     7.820] (II) RADEON(0): Modeline "800x600"x0.0   50.00  800 856 976 1040  600 637 643 666 +hsync +vsync (48.1 kHz)
[     7.820] (II) RADEON(0): Modeline "1152x864"x0.0  108.00  1152 1216 1344 1600  864 865 868 900 +hsync +vsync (67.5 kHz)
[     7.820] (II) RADEON(0): Modeline "1280x720"x60.0   74.48  1280 1336 1472 1664  720 721 724 746 -hsync +vsync (44.8 kHz)
[     7.820] (II) RADEON(0): Modeline "1280x960"x0.0  108.00  1280 1376 1488 1800  960 961 964 1000 +hsync +vsync (60.0 kHz)
[     7.820] (II) RADEON(0): Modeline "1280x1024"x0.0  108.00  1280 1328 1440 1688  1024 1025 1028 1066 +hsync +vsync (64.0 kHz)
[     7.820] (II) RADEON(0): Modeline "1440x900"x0.0   88.75  1440 1488 1520 1600  900 903 909 926 +hsync -vsync (55.5 kHz)
[     7.820] (II) RADEON(0): Modeline "1600x1200"x0.0  162.00  1600 1664 1856 2160  1200 1201 1204 1250 +hsync +vsync (75.0 kHz)
[     7.820] (II) RADEON(0): Modeline "1680x1050"x0.0  119.00  1680 1728 1760 1840  1050 1053 1059 1080 +hsync -vsync (64.7 kHz)
[     7.820] (II) RADEON(0): Modeline "1920x1080"x60.0  172.80  1920 2040 2248 2576  1080 1081 1084 1118 -hsync +vsync (67.1 kHz)
[     7.820] (II) RADEON(0): Modeline "1440x480i"x0.0   27.00  1440 1478 1602 1716  480 488 494 525 interlace -hsync -vsync (15.7 kHz)
[     7.820] (II) RADEON(0): Modeline "1920x1080i"x0.0   74.25  1920 2008 2052 2200  1080 1084 1094 1125 interlace +hsync +vsync (33.8 kHz)
[     7.820] (II) RADEON(0): Modeline "1920x1080i"x0.0   74.25  1920 2448 2492 2640  1080 1084 1094 1125 interlace +hsync +vsync (28.1 kHz)
[     7.820] (II) RADEON(0): Modeline "1440x240"x0.0   27.00  1440 1478 1602 1716  240 244 247 262 -hsync -vsync (15.7 kHz)
[     7.820] (II) RADEON(0): Modeline "1440x288"x0.0   27.00  1440 1464 1590 1728  288 290 293 312 -hsync -vsync (15.6 kHz)
[     7.820] (II) RADEON(0): Modeline "1920x1080"x0.0   74.25  1920 2558 2602 2750  1080 1084 1089 1125 +hsync +vsync (27.0 kHz)
[     7.821] (II) RADEON(0): Printing probed modes for output HDMI-0
[     7.821] (II) RADEON(0): Modeline "1920x1080_59.9"x59.9  138.50  1920 1968 2000 2080  1080 1083 1088 1111 +hsync +vsync (66.6 kHz)
[     7.821] (II) RADEON(0): Modeline "1920x1080"x59.9  138.50  1920 1968 2000 2080  1080 1083 1088 1111 +hsync +vsync (66.6 kHz)
[     7.821] (II) RADEON(0): Modeline "1600x1200"x60.0  162.00  1600 1664 1856 2160  1200 1201 1204 1250 +hsync +vsync (75.0 kHz)
[     7.821] (II) RADEON(0): Modeline "1680x1050"x60.0  146.25  1680 1784 1960 2240  1050 1053 1059 1089 -hsync +vsync (65.3 kHz)
[     7.821] (II) RADEON(0): Modeline "1280x1024"x75.0  135.00  1280 1296 1440 1688  1024 1025 1028 1066 +hsync +vsync (80.0 kHz)
[     7.821] (II) RADEON(0): Modeline "1280x1024"x60.0  108.00  1280 1328 1440 1688  1024 1025 1028 1066 +hsync +vsync (64.0 kHz)
[     7.821] (II) RADEON(0): Modeline "1440x900"x59.9  106.50  1440 1520 1672 1904  900 903 909 934 -hsync +vsync (55.9 kHz)
[     7.821] (II) RADEON(0): Modeline "1280x960"x60.0  108.00  1280 1376 1488 1800  960 961 964 1000 +hsync +vsync (60.0 kHz)
[     7.821] (II) RADEON(0): Modeline "1152x864"x75.0  108.00  1152 1216 1344 1600  864 865 868 900 +hsync +vsync (67.5 kHz)
[     7.821] (II) RADEON(0): Modeline "1280x720"x60.0   74.44  1280 1336 1472 1664  720 721 724 746 -hsync +vsync (44.7 kHz)
[     7.821] (II) RADEON(0): Modeline "1024x768"x75.1   78.80  1024 1040 1136 1312  768 769 772 800 +hsync +vsync (60.1 kHz)
[     7.821] (II) RADEON(0): Modeline "1024x768"x70.1   75.00  1024 1048 1184 1328  768 771 777 806 -hsync -vsync (56.5 kHz)
[     7.821] (II) RADEON(0): Modeline "1024x768"x60.0   65.00  1024 1048 1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz)
[     7.821] (II) RADEON(0): Modeline "832x624"x74.6   57.28  832 864 928 1152  624 625 628 667 -hsync -vsync (49.7 kHz)
[     7.821] (II) RADEON(0): Modeline "800x600"x72.2   50.00  800 856 976 1040  600 637 643 666 +hsync +vsync (48.1 kHz)
[     7.821] (II) RADEON(0): Modeline "800x600"x75.0   49.50  800 816 896 1056  600 601 604 625 +hsync +vsync (46.9 kHz)
[     7.821] (II) RADEON(0): Modeline "800x600"x60.3   40.00  800 840 968 1056  600 601 605 628 +hsync +vsync (37.9 kHz)
[     7.821] (II) RADEON(0): Modeline "800x600"x56.2   36.00  800 824 896 1024  600 601 603 625 +hsync +vsync (35.2 kHz)
[     7.821] (II) RADEON(0): Modeline "720x480"x59.9   27.00  720 736 798 858  480 489 495 525 -hsync -vsync (31.5 kHz)
[     7.821] (II) RADEON(0): Modeline "640x480"x72.8   31.50  640 664 704 832  480 489 491 520 -hsync -vsync (37.9 kHz)
[     7.821] (II) RADEON(0): Modeline "640x480"x75.0   31.50  640 656 720 840  480 481 484 500 -hsync -vsync (37.5 kHz)
[     7.821] (II) RADEON(0): Modeline "640x480"x66.7   30.24  640 704 768 864  480 483 486 525 -hsync -vsync (35.0 kHz)
[     7.821] (II) RADEON(0): Modeline "640x480"x60.0   25.20  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz)
[     7.821] (II) RADEON(0): Modeline "720x400"x70.1   28.32  720 738 846 900  400 412 414 449 -hsync +vsync (31.5 kHz)
[     7.821] (II) RADEON(0): Output HDMI-0 connected
[     7.821] (II) RADEON(0): Using user preference for initial modes
[     7.821] (II) RADEON(0): Output HDMI-0 using initial mode 1920x1080_59.9
[     7.821] (II) RADEON(0): Using default gamma of (1.0, 1.0, 1.0) unless otherwise stated.
[     7.821] (II) RADEON(0): mem size init: gart size :1fdff000 vram size: s:8000000 visible:77d7000
[     7.821] (II) RADEON(0): EXA: Driver will allow EXA pixmaps in VRAM
[     7.821] (**) RADEON(0): Display dimensions: (480, 270) mm
[     7.821] (**) RADEON(0): DPI set to (101, 101)
[     7.821] (II) Loading sub module "fb"
[     7.821] (II) LoadModule: "fb"
[     7.821] (II) Loading /usr/lib/xorg/modules/libfb.so
[     7.823] (II) Module fb: vendor="X.Org Foundation"
[     7.823] 	compiled for 1.10.1, module version = 1.0.0
[     7.823] 	ABI class: X.Org ANSI C Emulation, version 0.4
[     7.823] (II) Loading sub module "ramdac"
[     7.823] (II) LoadModule: "ramdac"
[     7.823] (II) Module "ramdac" already built-in
[     7.823] (--) Depth 24 pixmap format is 32 bpp
[     7.823] (II) RADEON(0): [DRI2] Setup complete
[     7.823] (II) RADEON(0): [DRI2]   DRI driver: r600
[     7.823] (II) RADEON(0): Front buffer size: 8100K
[     7.823] (II) RADEON(0): VRAM usage limit set to 103154K
[     7.826] (==) RADEON(0): Backing store disabled
[     7.826] (II) RADEON(0): Direct rendering enabled
[     7.828] (II) RADEON(0): Setting EXA maxPitchBytes
[     7.828] (II) EXA(0): Driver allocated offscreen pixmaps
[     7.828] (II) EXA(0): Driver registered support for the following operations:
[     7.828] (II)         Solid
[     7.828] (II)         Copy
[     7.828] (II)         Composite (RENDER acceleration)
[     7.828] (II)         UploadToScreen
[     7.828] (II)         DownloadFromScreen
[     7.828] (II) RADEON(0): Acceleration enabled
[     7.828] (==) RADEON(0): DPMS enabled
[     7.828] (==) RADEON(0): Silken mouse enabled
[     7.830] (II) RADEON(0): Set up textured video
[     7.830] (II) RADEON(0): RandR 1.2 enabled, ignore the following RandR disabled message.
[     7.861] (WW) RADEON(0): Option "UseEDID" is not used
[     7.861] (WW) RADEON(0): Option "NoDDC" is not used
[     7.861] (--) RandR disabled
[     7.861] (II) Initializing built-in extension Generic Event Extension
[     7.861] (II) Initializing built-in extension SHAPE
[     7.861] (II) Initializing built-in extension MIT-SHM
[     7.861] (II) Initializing built-in extension XInputExtension
[     7.861] (II) Initializing built-in extension XTEST
[     7.861] (II) Initializing built-in extension BIG-REQUESTS
[     7.861] (II) Initializing built-in extension SYNC
[     7.861] (II) Initializing built-in extension XKEYBOARD
[     7.861] (II) Initializing built-in extension XC-MISC
[     7.861] (II) Initializing built-in extension SECURITY
[     7.861] (II) Initializing built-in extension XINERAMA
[     7.861] (II) Initializing built-in extension XFIXES
[     7.861] (II) Initializing built-in extension RENDER
[     7.861] (II) Initializing built-in extension RANDR
[     7.861] (II) Initializing built-in extension COMPOSITE
[     7.861] (II) Initializing built-in extension DAMAGE
[     7.862] (II) SELinux: Disabled on system
[     7.889] (II) AIGLX: enabled GLX_MESA_copy_sub_buffer
[     7.889] (II) AIGLX: enabled GLX_INTEL_swap_event
[     7.889] (II) AIGLX: enabled GLX_SGI_swap_control and GLX_MESA_swap_control
[     7.889] (II) AIGLX: enabled GLX_SGI_make_current_read
[     7.889] (II) AIGLX: GLX_EXT_texture_from_pixmap backed by buffer objects
[     7.890] (II) AIGLX: Loaded and initialized /usr/lib/dri/r600_dri.so
[     7.890] (II) GLX: Initialized DRI2 GL provider for screen 0
[     7.892] (II) RADEON(0): Setting screen physical size to 508 x 285
[     8.019] (II) config/udev: Adding input device Power Button (/dev/input/event1)
[     8.019] (**) Power Button: Applying InputClass "evdev keyboard catchall"
[     8.019] (II) LoadModule: "evdev"
[     8.019] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[     8.020] (II) Module evdev: vendor="X.Org Foundation"
[     8.020] 	compiled for 1.10.1, module version = 2.6.0
[     8.020] 	Module class: X.Org XInput Driver
[     8.020] 	ABI class: X.Org XInput driver, version 12.2
[     8.020] (II) Using input driver 'evdev' for 'Power Button'
[     8.020] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[     8.020] (**) Power Button: always reports core events
[     8.020] (**) Power Button: Device: "/dev/input/event1"
[     8.025] (--) Power Button: Found keys
[     8.025] (II) Power Button: Configuring as keyboard
[     8.025] (**) Option "config_info" "udev:/sys/devices/LNXSYSTM:00/LNXPWRBN:00/input/input1/event1"
[     8.025] (II) XINPUT: Adding extended input device "Power Button" (type: KEYBOARD)
[     8.025] (**) Option "xkb_rules" "evdev"
[     8.025] (**) Option "xkb_model" "pc104"
[     8.025] (**) Option "xkb_layout" "us"
[     8.070] (II) config/udev: Adding input device Power Button (/dev/input/event0)
[     8.070] (**) Power Button: Applying InputClass "evdev keyboard catchall"
[     8.070] (II) Using input driver 'evdev' for 'Power Button'
[     8.070] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[     8.070] (**) Power Button: always reports core events
[     8.070] (**) Power Button: Device: "/dev/input/event0"
[     8.078] (--) Power Button: Found keys
[     8.078] (II) Power Button: Configuring as keyboard
[     8.078] (**) Option "config_info" "udev:/sys/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0/event0"
[     8.078] (II) XINPUT: Adding extended input device "Power Button" (type: KEYBOARD)
[     8.078] (**) Option "xkb_rules" "evdev"
[     8.078] (**) Option "xkb_model" "pc104"
[     8.078] (**) Option "xkb_layout" "us"
[     8.089] (II) config/udev: Adding input device Media Center Ed. eHome Infrared Remote Transceiver (1784:0001) (/dev/input/event7)
[     8.089] (**) Media Center Ed. eHome Infrared Remote Transceiver (1784:0001): Ignoring device from InputClass "ignore the mceusb remote"
[     8.091] (II) config/udev: Adding input device LITE-ON Technology USB NetVista Full Width Keyboard. (/dev/input/event4)
[     8.091] (**) LITE-ON Technology USB NetVista Full Width Keyboard.: Applying InputClass "evdev keyboard catchall"
[     8.091] (II) Using input driver 'evdev' for 'LITE-ON Technology USB NetVista Full Width Keyboard.'
[     8.091] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[     8.092] (**) LITE-ON Technology USB NetVista Full Width Keyboard.: always reports core events
[     8.092] (**) LITE-ON Technology USB NetVista Full Width Keyboard.: Device: "/dev/input/event4"
[     8.097] (--) LITE-ON Technology USB NetVista Full Width Keyboard.: Found keys
[     8.097] (II) LITE-ON Technology USB NetVista Full Width Keyboard.: Configuring as keyboard
[     8.097] (**) Option "config_info" "udev:/sys/devices/pci0000:00/0000:00:12.1/usb4/4-2/4-2:1.0/input/input4/event4"
[     8.097] (II) XINPUT: Adding extended input device "LITE-ON Technology USB NetVista Full Width Keyboard." (type: KEYBOARD)
[     8.097] (**) Option "xkb_rules" "evdev"
[     8.097] (**) Option "xkb_model" "pc104"
[     8.097] (**) Option "xkb_layout" "us"
[     8.098] (II) config/udev: Adding input device Logitech USB Receiver (/dev/input/event5)
[     8.099] (**) Logitech USB Receiver: Applying InputClass "evdev keyboard catchall"
[     8.099] (II) Using input driver 'evdev' for 'Logitech USB Receiver'
[     8.099] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[     8.099] (**) Logitech USB Receiver: always reports core events
[     8.099] (**) Logitech USB Receiver: Device: "/dev/input/event5"
[     8.105] (--) Logitech USB Receiver: Found keys
[     8.105] (II) Logitech USB Receiver: Configuring as keyboard
[     8.105] (**) Option "config_info" "udev:/sys/devices/pci0000:00/0000:00:12.1/usb4/4-3/4-3:1.0/input/input5/event5"
[     8.105] (II) XINPUT: Adding extended input device "Logitech USB Receiver" (type: KEYBOARD)
[     8.105] (**) Option "xkb_rules" "evdev"
[     8.105] (**) Option "xkb_model" "pc104"
[     8.105] (**) Option "xkb_layout" "us"
[     8.106] (II) config/udev: Adding input device Logitech USB Receiver (/dev/input/event6)
[     8.106] (**) Logitech USB Receiver: Applying InputClass "evdev pointer catchall"
[     8.106] (**) Logitech USB Receiver: Applying InputClass "evdev keyboard catchall"
[     8.106] (II) Using input driver 'evdev' for 'Logitech USB Receiver'
[     8.106] (II) Loading /usr/lib/xorg/modules/input/evdev_drv.so
[     8.106] (**) Logitech USB Receiver: always reports core events
[     8.106] (**) Logitech USB Receiver: Device: "/dev/input/event6"
[     8.113] (--) Logitech USB Receiver: Found 12 mouse buttons
[     8.113] (--) Logitech USB Receiver: Found scroll wheel(s)
[     8.113] (--) Logitech USB Receiver: Found relative axes
[     8.113] (--) Logitech USB Receiver: Found x and y relative axes
[     8.113] (--) Logitech USB Receiver: Found absolute axes
[     8.113] (--) Logitech USB Receiver: Found keys
[     8.113] (II) Logitech USB Receiver: Configuring as mouse
[     8.113] (II) Logitech USB Receiver: Configuring as keyboard
[     8.113] (II) Logitech USB Receiver: Adding scrollwheel support
[     8.113] (**) Logitech USB Receiver: YAxisMapping: buttons 4 and 5
[     8.113] (**) Logitech USB Receiver: EmulateWheelButton: 4, EmulateWheelInertia: 10, EmulateWheelTimeout: 200
[     8.113] (**) Option "config_info" "udev:/sys/devices/pci0000:00/0000:00:12.1/usb4/4-3/4-3:1.1/input/input6/event6"
[     8.113] (II) XINPUT: Adding extended input device "Logitech USB Receiver" (type: KEYBOARD)
[     8.113] (**) Option "xkb_rules" "evdev"
[     8.113] (**) Option "xkb_model" "pc104"
[     8.113] (**) Option "xkb_layout" "us"
[     8.113] (II) Logitech USB Receiver: initialized for relative axes.
[     8.113] (WW) Logitech USB Receiver: ignoring absolute axes.
[     8.114] (**) Logitech USB Receiver: (accel) keeping acceleration scheme 1
[     8.114] (**) Logitech USB Receiver: (accel) acceleration profile 0
[     8.114] (**) Logitech USB Receiver: (accel) acceleration factor: 2.000
[     8.114] (**) Logitech USB Receiver: (accel) acceleration threshold: 4
[     8.114] (II) config/udev: Adding input device Logitech USB Receiver (/dev/input/mouse0)
[     8.114] (II) No input driver/identifier specified (ignoring)
[     8.119] (II) config/udev: Adding input device HDA ATI SB Headphone (/dev/input/event3)
[     8.119] (II) No input driver/identifier specified (ignoring)
[     8.123] (II) config/udev: Adding input device PC Speaker (/dev/input/event2)
[     8.123] (II) No input driver/identifier specified (ignoring)
[    15.477] (II) RADEON(0): EDID vendor "BNQ", prod id 30990
[    15.477] (II) RADEON(0): Using hsync ranges from config file
[    15.477] (II) RADEON(0): Using vrefresh ranges from config file
[    15.477] (II) RADEON(0): Printing DDC gathered Modelines:
[    15.477] (II) RADEON(0): Modeline "1920x1080"x0.0  138.50  1920 1968 2000 2080  1080 1083 1088 1111 +hsync +vsync (66.6 kHz)
[    15.477] (II) RADEON(0): Modeline "720x480"x0.0   27.00  720 736 798 858  480 489 495 525 -hsync -vsync (31.5 kHz)
[    15.477] (II) RADEON(0): Modeline "1280x720"x0.0   74.25  1280 1390 1430 1650  720 725 730 750 +hsync +vsync (45.0 kHz)
[    15.477] (II) RADEON(0): Modeline "1280x720"x0.0   74.25  1280 1720 1760 1980  720 725 730 750 +hsync +vsync (37.5 kHz)
[    15.477] (II) RADEON(0): Modeline "720x576"x0.0   27.00  720 732 796 864  576 581 586 625 -hsync -vsync (31.2 kHz)
[    15.477] (II) RADEON(0): Modeline "1440x576i"x0.0   27.00  1440 1464 1590 1728  576 580 586 625 interlace -hsync -vsync (15.6 kHz)
[    15.478] (II) RADEON(0): Modeline "800x600"x0.0   40.00  800 840 968 1056  600 601 605 628 +hsync +vsync (37.9 kHz)
[    15.478] (II) RADEON(0): Modeline "800x600"x0.0   36.00  800 824 896 1024  600 601 603 625 +hsync +vsync (35.2 kHz)
[    15.478] (II) RADEON(0): Modeline "640x480"x0.0   31.50  640 656 720 840  480 481 484 500 -hsync -vsync (37.5 kHz)
[    15.478] (II) RADEON(0): Modeline "640x480"x0.0   31.50  640 664 704 832  480 489 492 520 -hsync -vsync (37.9 kHz)
[    15.478] (II) RADEON(0): Modeline "640x480"x0.0   30.24  640 704 768 864  480 483 486 525 -hsync -vsync (35.0 kHz)
[    15.478] (II) RADEON(0): Modeline "640x480"x0.0   25.18  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz)
[    15.478] (II) RADEON(0): Modeline "720x400"x0.0   28.32  720 738 846 900  400 412 414 449 -hsync +vsync (31.5 kHz)
[    15.478] (II) RADEON(0): Modeline "1280x1024"x0.0  135.00  1280 1296 1440 1688  1024 1025 1028 1066 +hsync +vsync (80.0 kHz)
[    15.478] (II) RADEON(0): Modeline "1024x768"x0.0   78.75  1024 1040 1136 1312  768 769 772 800 +hsync +vsync (60.0 kHz)
[    15.478] (II) RADEON(0): Modeline "1024x768"x0.0   75.00  1024 1048 1184 1328  768 771 777 806 -hsync -vsync (56.5 kHz)
[    15.478] (II) RADEON(0): Modeline "1024x768"x0.0   65.00  1024 1048 1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz)
[    15.478] (II) RADEON(0): Modeline "832x624"x0.0   57.28  832 864 928 1152  624 625 628 667 -hsync -vsync (49.7 kHz)
[    15.478] (II) RADEON(0): Modeline "800x600"x0.0   49.50  800 816 896 1056  600 601 604 625 +hsync +vsync (46.9 kHz)
[    15.478] (II) RADEON(0): Modeline "800x600"x0.0   50.00  800 856 976 1040  600 637 643 666 +hsync +vsync (48.1 kHz)
[    15.478] (II) RADEON(0): Modeline "1152x864"x0.0  108.00  1152 1216 1344 1600  864 865 868 900 +hsync +vsync (67.5 kHz)
[    15.478] (II) RADEON(0): Modeline "1280x720"x60.0   74.48  1280 1336 1472 1664  720 721 724 746 -hsync +vsync (44.8 kHz)
[    15.478] (II) RADEON(0): Modeline "1280x960"x0.0  108.00  1280 1376 1488 1800  960 961 964 1000 +hsync +vsync (60.0 kHz)
[    15.478] (II) RADEON(0): Modeline "1280x1024"x0.0  108.00  1280 1328 1440 1688  1024 1025 1028 1066 +hsync +vsync (64.0 kHz)
[    15.478] (II) RADEON(0): Modeline "1440x900"x0.0   88.75  1440 1488 1520 1600  900 903 909 926 +hsync -vsync (55.5 kHz)
[    15.478] (II) RADEON(0): Modeline "1600x1200"x0.0  162.00  1600 1664 1856 2160  1200 1201 1204 1250 +hsync +vsync (75.0 kHz)
[    15.478] (II) RADEON(0): Modeline "1680x1050"x0.0  119.00  1680 1728 1760 1840  1050 1053 1059 1080 +hsync -vsync (64.7 kHz)
[    15.478] (II) RADEON(0): Modeline "1920x1080"x60.0  172.80  1920 2040 2248 2576  1080 1081 1084 1118 -hsync +vsync (67.1 kHz)
[    15.478] (II) RADEON(0): Modeline "1440x480i"x0.0   27.00  1440 1478 1602 1716  480 488 494 525 interlace -hsync -vsync (15.7 kHz)
[    15.478] (II) RADEON(0): Modeline "1920x1080i"x0.0   74.25  1920 2008 2052 2200  1080 1084 1094 1125 interlace +hsync +vsync (33.8 kHz)
[    15.478] (II) RADEON(0): Modeline "1920x1080i"x0.0   74.25  1920 2448 2492 2640  1080 1084 1094 1125 interlace +hsync +vsync (28.1 kHz)
[    15.478] (II) RADEON(0): Modeline "1440x240"x0.0   27.00  1440 1478 1602 1716  240 244 247 262 -hsync -vsync (15.7 kHz)
[    15.478] (II) RADEON(0): Modeline "1440x288"x0.0   27.00  1440 1464 1590 1728  288 290 293 312 -hsync -vsync (15.6 kHz)
[    15.478] (II) RADEON(0): Modeline "1920x1080"x0.0   74.25  1920 2558 2602 2750  1080 1084 1089 1125 +hsync +vsync (27.0 kHz)
[    16.349] (II) RADEON(0): EDID vendor "BNQ", prod id 30990
[    16.349] (II) RADEON(0): Using hsync ranges from config file
[    16.349] (II) RADEON(0): Using vrefresh ranges from config file
[    16.350] (II) RADEON(0): Printing DDC gathered Modelines:
[    16.350] (II) RADEON(0): Modeline "1920x1080"x0.0  138.50  1920 1968 2000 2080  1080 1083 1088 1111 +hsync +vsync (66.6 kHz)
[    16.350] (II) RADEON(0): Modeline "720x480"x0.0   27.00  720 736 798 858  480 489 495 525 -hsync -vsync (31.5 kHz)
[    16.350] (II) RADEON(0): Modeline "1280x720"x0.0   74.25  1280 1390 1430 1650  720 725 730 750 +hsync +vsync (45.0 kHz)
[    16.350] (II) RADEON(0): Modeline "1280x720"x0.0   74.25  1280 1720 1760 1980  720 725 730 750 +hsync +vsync (37.5 kHz)
[    16.350] (II) RADEON(0): Modeline "720x576"x0.0   27.00  720 732 796 864  576 581 586 625 -hsync -vsync (31.2 kHz)
[    16.350] (II) RADEON(0): Modeline "1440x576i"x0.0   27.00  1440 1464 1590 1728  576 580 586 625 interlace -hsync -vsync (15.6 kHz)
[    16.350] (II) RADEON(0): Modeline "800x600"x0.0   40.00  800 840 968 1056  600 601 605 628 +hsync +vsync (37.9 kHz)
[    16.350] (II) RADEON(0): Modeline "800x600"x0.0   36.00  800 824 896 1024  600 601 603 625 +hsync +vsync (35.2 kHz)
[    16.350] (II) RADEON(0): Modeline "640x480"x0.0   31.50  640 656 720 840  480 481 484 500 -hsync -vsync (37.5 kHz)
[    16.350] (II) RADEON(0): Modeline "640x480"x0.0   31.50  640 664 704 832  480 489 492 520 -hsync -vsync (37.9 kHz)
[    16.350] (II) RADEON(0): Modeline "640x480"x0.0   30.24  640 704 768 864  480 483 486 525 -hsync -vsync (35.0 kHz)
[    16.350] (II) RADEON(0): Modeline "640x480"x0.0   25.18  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz)
[    16.350] (II) RADEON(0): Modeline "720x400"x0.0   28.32  720 738 846 900  400 412 414 449 -hsync +vsync (31.5 kHz)
[    16.350] (II) RADEON(0): Modeline "1280x1024"x0.0  135.00  1280 1296 1440 1688  1024 1025 1028 1066 +hsync +vsync (80.0 kHz)
[    16.350] (II) RADEON(0): Modeline "1024x768"x0.0   78.75  1024 1040 1136 1312  768 769 772 800 +hsync +vsync (60.0 kHz)
[    16.350] (II) RADEON(0): Modeline "1024x768"x0.0   75.00  1024 1048 1184 1328  768 771 777 806 -hsync -vsync (56.5 kHz)
[    16.350] (II) RADEON(0): Modeline "1024x768"x0.0   65.00  1024 1048 1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz)
[    16.350] (II) RADEON(0): Modeline "832x624"x0.0   57.28  832 864 928 1152  624 625 628 667 -hsync -vsync (49.7 kHz)
[    16.350] (II) RADEON(0): Modeline "800x600"x0.0   49.50  800 816 896 1056  600 601 604 625 +hsync +vsync (46.9 kHz)
[    16.350] (II) RADEON(0): Modeline "800x600"x0.0   50.00  800 856 976 1040  600 637 643 666 +hsync +vsync (48.1 kHz)
[    16.350] (II) RADEON(0): Modeline "1152x864"x0.0  108.00  1152 1216 1344 1600  864 865 868 900 +hsync +vsync (67.5 kHz)
[    16.350] (II) RADEON(0): Modeline "1280x720"x60.0   74.48  1280 1336 1472 1664  720 721 724 746 -hsync +vsync (44.8 kHz)
[    16.350] (II) RADEON(0): Modeline "1280x960"x0.0  108.00  1280 1376 1488 1800  960 961 964 1000 +hsync +vsync (60.0 kHz)
[    16.350] (II) RADEON(0): Modeline "1280x1024"x0.0  108.00  1280 1328 1440 1688  1024 1025 1028 1066 +hsync +vsync (64.0 kHz)
[    16.350] (II) RADEON(0): Modeline "1440x900"x0.0   88.75  1440 1488 1520 1600  900 903 909 926 +hsync -vsync (55.5 kHz)
[    16.350] (II) RADEON(0): Modeline "1600x1200"x0.0  162.00  1600 1664 1856 2160  1200 1201 1204 1250 +hsync +vsync (75.0 kHz)
[    16.350] (II) RADEON(0): Modeline "1680x1050"x0.0  119.00  1680 1728 1760 1840  1050 1053 1059 1080 +hsync -vsync (64.7 kHz)
[    16.350] (II) RADEON(0): Modeline "1920x1080"x60.0  172.80  1920 2040 2248 2576  1080 1081 1084 1118 -hsync +vsync (67.1 kHz)
[    16.350] (II) RADEON(0): Modeline "1440x480i"x0.0   27.00  1440 1478 1602 1716  480 488 494 525 interlace -hsync -vsync (15.7 kHz)
[    16.350] (II) RADEON(0): Modeline "1920x1080i"x0.0   74.25  1920 2008 2052 2200  1080 1084 1094 1125 interlace +hsync +vsync (33.8 kHz)
[    16.350] (II) RADEON(0): Modeline "1920x1080i"x0.0   74.25  1920 2448 2492 2640  1080 1084 1094 1125 interlace +hsync +vsync (28.1 kHz)
[    16.350] (II) RADEON(0): Modeline "1440x240"x0.0   27.00  1440 1478 1602 1716  240 244 247 262 -hsync -vsync (15.7 kHz)
[    16.350] (II) RADEON(0): Modeline "1440x288"x0.0   27.00  1440 1464 1590 1728  288 290 293 312 -hsync -vsync (15.6 kHz)
[    16.350] (II) RADEON(0): Modeline "1920x1080"x0.0   74.25  1920 2558 2602 2750  1080 1084 1089 1125 +hsync +vsync (27.0 kHz)
[    16.360] (II) RADEON(0): EDID vendor "BNQ", prod id 30990
[    16.360] (II) RADEON(0): Using hsync ranges from config file
[    16.360] (II) RADEON(0): Using vrefresh ranges from config file
[    16.360] (II) RADEON(0): Printing DDC gathered Modelines:
[    16.360] (II) RADEON(0): Modeline "1920x1080"x0.0  138.50  1920 1968 2000 2080  1080 1083 1088 1111 +hsync +vsync (66.6 kHz)
[    16.360] (II) RADEON(0): Modeline "720x480"x0.0   27.00  720 736 798 858  480 489 495 525 -hsync -vsync (31.5 kHz)
[    16.360] (II) RADEON(0): Modeline "1280x720"x0.0   74.25  1280 1390 1430 1650  720 725 730 750 +hsync +vsync (45.0 kHz)
[    16.360] (II) RADEON(0): Modeline "1280x720"x0.0   74.25  1280 1720 1760 1980  720 725 730 750 +hsync +vsync (37.5 kHz)
[    16.360] (II) RADEON(0): Modeline "720x576"x0.0   27.00  720 732 796 864  576 581 586 625 -hsync -vsync (31.2 kHz)
[    16.360] (II) RADEON(0): Modeline "1440x576i"x0.0   27.00  1440 1464 1590 1728  576 580 586 625 interlace -hsync -vsync (15.6 kHz)
[    16.360] (II) RADEON(0): Modeline "800x600"x0.0   40.00  800 840 968 1056  600 601 605 628 +hsync +vsync (37.9 kHz)
[    16.360] (II) RADEON(0): Modeline "800x600"x0.0   36.00  800 824 896 1024  600 601 603 625 +hsync +vsync (35.2 kHz)
[    16.360] (II) RADEON(0): Modeline "640x480"x0.0   31.50  640 656 720 840  480 481 484 500 -hsync -vsync (37.5 kHz)
[    16.360] (II) RADEON(0): Modeline "640x480"x0.0   31.50  640 664 704 832  480 489 492 520 -hsync -vsync (37.9 kHz)
[    16.360] (II) RADEON(0): Modeline "640x480"x0.0   30.24  640 704 768 864  480 483 486 525 -hsync -vsync (35.0 kHz)
[    16.360] (II) RADEON(0): Modeline "640x480"x0.0   25.18  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz)
[    16.360] (II) RADEON(0): Modeline "720x400"x0.0   28.32  720 738 846 900  400 412 414 449 -hsync +vsync (31.5 kHz)
[    16.360] (II) RADEON(0): Modeline "1280x1024"x0.0  135.00  1280 1296 1440 1688  1024 1025 1028 1066 +hsync +vsync (80.0 kHz)
[    16.360] (II) RADEON(0): Modeline "1024x768"x0.0   78.75  1024 1040 1136 1312  768 769 772 800 +hsync +vsync (60.0 kHz)
[    16.360] (II) RADEON(0): Modeline "1024x768"x0.0   75.00  1024 1048 1184 1328  768 771 777 806 -hsync -vsync (56.5 kHz)
[    16.360] (II) RADEON(0): Modeline "1024x768"x0.0   65.00  1024 1048 1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz)
[    16.360] (II) RADEON(0): Modeline "832x624"x0.0   57.28  832 864 928 1152  624 625 628 667 -hsync -vsync (49.7 kHz)
[    16.360] (II) RADEON(0): Modeline "800x600"x0.0   49.50  800 816 896 1056  600 601 604 625 +hsync +vsync (46.9 kHz)
[    16.360] (II) RADEON(0): Modeline "800x600"x0.0   50.00  800 856 976 1040  600 637 643 666 +hsync +vsync (48.1 kHz)
[    16.360] (II) RADEON(0): Modeline "1152x864"x0.0  108.00  1152 1216 1344 1600  864 865 868 900 +hsync +vsync (67.5 kHz)
[    16.360] (II) RADEON(0): Modeline "1280x720"x60.0   74.48  1280 1336 1472 1664  720 721 724 746 -hsync +vsync (44.8 kHz)
[    16.360] (II) RADEON(0): Modeline "1280x960"x0.0  108.00  1280 1376 1488 1800  960 961 964 1000 +hsync +vsync (60.0 kHz)
[    16.360] (II) RADEON(0): Modeline "1280x1024"x0.0  108.00  1280 1328 1440 1688  1024 1025 1028 1066 +hsync +vsync (64.0 kHz)
[    16.360] (II) RADEON(0): Modeline "1440x900"x0.0   88.75  1440 1488 1520 1600  900 903 909 926 +hsync -vsync (55.5 kHz)
[    16.360] (II) RADEON(0): Modeline "1600x1200"x0.0  162.00  1600 1664 1856 2160  1200 1201 1204 1250 +hsync +vsync (75.0 kHz)
[    16.361] (II) RADEON(0): Modeline "1680x1050"x0.0  119.00  1680 1728 1760 1840  1050 1053 1059 1080 +hsync -vsync (64.7 kHz)
[    16.361] (II) RADEON(0): Modeline "1920x1080"x60.0  172.80  1920 2040 2248 2576  1080 1081 1084 1118 -hsync +vsync (67.1 kHz)
[    16.361] (II) RADEON(0): Modeline "1440x480i"x0.0   27.00  1440 1478 1602 1716  480 488 494 525 interlace -hsync -vsync (15.7 kHz)
[    16.361] (II) RADEON(0): Modeline "1920x1080i"x0.0   74.25  1920 2008 2052 2200  1080 1084 1094 1125 interlace +hsync +vsync (33.8 kHz)
[    16.361] (II) RADEON(0): Modeline "1920x1080i"x0.0   74.25  1920 2448 2492 2640  1080 1084 1094 1125 interlace +hsync +vsync (28.1 kHz)
[    16.361] (II) RADEON(0): Modeline "1440x240"x0.0   27.00  1440 1478 1602 1716  240 244 247 262 -hsync -vsync (15.7 kHz)
[    16.361] (II) RADEON(0): Modeline "1440x288"x0.0   27.00  1440 1464 1590 1728  288 290 293 312 -hsync -vsync (15.6 kHz)
[    16.361] (II) RADEON(0): Modeline "1920x1080"x0.0   74.25  1920 2558 2602 2750  1080 1084 1089 1125 +hsync +vsync (27.0 kHz)
[    21.855] (II) RADEON(0): EDID vendor "BNQ", prod id 30990
[    21.855] (II) RADEON(0): Using hsync ranges from config file
[    21.855] (II) RADEON(0): Using vrefresh ranges from config file
[    21.855] (II) RADEON(0): Printing DDC gathered Modelines:
[    21.855] (II) RADEON(0): Modeline "1920x1080"x0.0  138.50  1920 1968 2000 2080  1080 1083 1088 1111 +hsync +vsync (66.6 kHz)
[    21.855] (II) RADEON(0): Modeline "720x480"x0.0   27.00  720 736 798 858  480 489 495 525 -hsync -vsync (31.5 kHz)
[    21.855] (II) RADEON(0): Modeline "1280x720"x0.0   74.25  1280 1390 1430 1650  720 725 730 750 +hsync +vsync (45.0 kHz)
[    21.855] (II) RADEON(0): Modeline "1280x720"x0.0   74.25  1280 1720 1760 1980  720 725 730 750 +hsync +vsync (37.5 kHz)
[    21.855] (II) RADEON(0): Modeline "720x576"x0.0   27.00  720 732 796 864  576 581 586 625 -hsync -vsync (31.2 kHz)
[    21.855] (II) RADEON(0): Modeline "1440x576i"x0.0   27.00  1440 1464 1590 1728  576 580 586 625 interlace -hsync -vsync (15.6 kHz)
[    21.855] (II) RADEON(0): Modeline "800x600"x0.0   40.00  800 840 968 1056  600 601 605 628 +hsync +vsync (37.9 kHz)
[    21.855] (II) RADEON(0): Modeline "800x600"x0.0   36.00  800 824 896 1024  600 601 603 625 +hsync +vsync (35.2 kHz)
[    21.855] (II) RADEON(0): Modeline "640x480"x0.0   31.50  640 656 720 840  480 481 484 500 -hsync -vsync (37.5 kHz)
[    21.855] (II) RADEON(0): Modeline "640x480"x0.0   31.50  640 664 704 832  480 489 492 520 -hsync -vsync (37.9 kHz)
[    21.855] (II) RADEON(0): Modeline "640x480"x0.0   30.24  640 704 768 864  480 483 486 525 -hsync -vsync (35.0 kHz)
[    21.855] (II) RADEON(0): Modeline "640x480"x0.0   25.18  640 656 752 800  480 490 492 525 -hsync -vsync (31.5 kHz)
[    21.856] (II) RADEON(0): Modeline "720x400"x0.0   28.32  720 738 846 900  400 412 414 449 -hsync +vsync (31.5 kHz)
[    21.856] (II) RADEON(0): Modeline "1280x1024"x0.0  135.00  1280 1296 1440 1688  1024 1025 1028 1066 +hsync +vsync (80.0 kHz)
[    21.856] (II) RADEON(0): Modeline "1024x768"x0.0   78.75  1024 1040 1136 1312  768 769 772 800 +hsync +vsync (60.0 kHz)
[    21.856] (II) RADEON(0): Modeline "1024x768"x0.0   75.00  1024 1048 1184 1328  768 771 777 806 -hsync -vsync (56.5 kHz)
[    21.856] (II) RADEON(0): Modeline "1024x768"x0.0   65.00  1024 1048 1184 1344  768 771 777 806 -hsync -vsync (48.4 kHz)
[    21.856] (II) RADEON(0): Modeline "832x624"x0.0   57.28  832 864 928 1152  624 625 628 667 -hsync -vsync (49.7 kHz)
[    21.856] (II) RADEON(0): Modeline "800x600"x0.0   49.50  800 816 896 1056  600 601 604 625 +hsync +vsync (46.9 kHz)
[    21.856] (II) RADEON(0): Modeline "800x600"x0.0   50.00  800 856 976 1040  600 637 643 666 +hsync +vsync (48.1 kHz)
[    21.856] (II) RADEON(0): Modeline "1152x864"x0.0  108.00  1152 1216 1344 1600  864 865 868 900 +hsync +vsync (67.5 kHz)
[    21.856] (II) RADEON(0): Modeline "1280x720"x60.0   74.48  1280 1336 1472 1664  720 721 724 746 -hsync +vsync (44.8 kHz)
[    21.856] (II) RADEON(0): Modeline "1280x960"x0.0  108.00  1280 1376 1488 1800  960 961 964 1000 +hsync +vsync (60.0 kHz)
[    21.856] (II) RADEON(0): Modeline "1280x1024"x0.0  108.00  1280 1328 1440 1688  1024 1025 1028 1066 +hsync +vsync (64.0 kHz)
[    21.856] (II) RADEON(0): Modeline "1440x900"x0.0   88.75  1440 1488 1520 1600  900 903 909 926 +hsync -vsync (55.5 kHz)
[    21.856] (II) RADEON(0): Modeline "1600x1200"x0.0  162.00  1600 1664 1856 2160  1200 1201 1204 1250 +hsync +vsync (75.0 kHz)
[    21.856] (II) RADEON(0): Modeline "1680x1050"x0.0  119.00  1680 1728 1760 1840  1050 1053 1059 1080 +hsync -vsync (64.7 kHz)
[    21.856] (II) RADEON(0): Modeline "1920x1080"x60.0  172.80  1920 2040 2248 2576  1080 1081 1084 1118 -hsync +vsync (67.1 kHz)
[    21.856] (II) RADEON(0): Modeline "1440x480i"x0.0   27.00  1440 1478 1602 1716  480 488 494 525 interlace -hsync -vsync (15.7 kHz)
[    21.856] (II) RADEON(0): Modeline "1920x1080i"x0.0   74.25  1920 2008 2052 2200  1080 1084 1094 1125 interlace +hsync +vsync (33.8 kHz)
[    21.856] (II) RADEON(0): Modeline "1920x1080i"x0.0   74.25  1920 2448 2492 2640  1080 1084 1094 1125 interlace +hsync +vsync (28.1 kHz)
[    21.856] (II) RADEON(0): Modeline "1440x240"x0.0   27.00  1440 1478 1602 1716  240 244 247 262 -hsync -vsync (15.7 kHz)
[    21.856] (II) RADEON(0): Modeline "1440x288"x0.0   27.00  1440 1464 1590 1728  288 290 293 312 -hsync -vsync (15.6 kHz)
[    21.856] (II) RADEON(0): Modeline "1920x1080"x0.0   74.25  1920 2558 2602 2750  1080 1084 1089 1125 +hsync +vsync (27.0 kHz)

--Boundary-00=_TWEyNZVAFaW908q--
