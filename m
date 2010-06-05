Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757651Ab0FEU2S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 16:28:18 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:40281 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754707Ab0FEU2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 16:28:14 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Eric Anholt <eric@anholt.net>
Subject: Re: regression: 2.6.35-rc1 hangs on i865G with KMS
Date: Sat, 5 Jun 2010 22:28:00 +0200
User-Agent: KMail/1.9.10
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
       Kernel development list <linux-kernel@vger.kernel.org>
References: <201006042201.29872.linux@rainbow-software.org> <87vd9yjpj4.fsf@pollan.anholt.net>
In-Reply-To: <87vd9yjpj4.fsf@pollan.anholt.net>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 21685
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201006052228.03025.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 05 June 2010 02:23:27 Eric Anholt wrote:
> On Fri, 4 Jun 2010 22:01:28 +0200, Ondrej Zary <linux@rainbow-software.org> wrote:
> > Hello,
> > I'm testing 2.6.35-rc1 kernel on Asus P4P800-VM (i865G chipset). After
> > loading i915 module, the screen goes blank and the kernel hangs
> > completely (same with 2.6.35-rc1-git2). This does not happen with
> > "i915.modeset=0" parameter.
> >
> > This problem does not appear with 2.6.34. Is this a known regression?
>
> Not known as far as I know -- we'd enjoy a bisect with a bug report on
> bugs.freedesktop.org.

Serial console with some printk()s added:
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 2.6.35-rc1-git2 (root@test) (gcc version 4.4.4 (Debian 4.4.4-1) ) #14 SMP Sat Jun 5 21:51:52 0
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e8000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000001f730000 (usable)
[    0.000000]  BIOS-e820: 000000001f730000 - 000000001f740000 (ACPI data)
[    0.000000]  BIOS-e820: 000000001f740000 - 000000001f7f0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000001f7f0000 - 000000001f800000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffb80000 - 0000000100000000 (reserved)
[    0.000000] Notice: NX (Execute Disable) protection missing in CPU or disabled in BIOS!
[    0.000000] DMI 2.3 present.
[    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working around it.
[    0.000000] last_pfn = 0x1f730 max_arch_pfn = 0x100000
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] found SMP MP-table at [c00ff780] ff780
[    0.000000] init_memory_mapping: 0000000000000000-000000001f730000
[    0.000000] ACPI: RSDP 000fad50 00021 (v02 ACPIAM)
[    0.000000] ACPI: XSDT 1f730100 0003C (v01 A M I  OEMXSDT  09000505 MSFT 00000097)
[    0.000000] ACPI: FACP 1f730290 000F4 (v03 A M I  OEMFACP  09000505 MSFT 00000097)
[    0.000000] ACPI: DSDT 1f7303f0 036A7 (v01  PPVM1 PPVM1911 00000911 INTL 02002026)
[    0.000000] ACPI: FACS 1f740000 00040
[    0.000000] ACPI: APIC 1f730390 0005C (v01 A M I  OEMAPIC  09000505 MSFT 00000097)
[    0.000000] ACPI: OEMB 1f740040 0003F (v01 A M I  OEMBIOS  09000505 MSFT 00000097)
[    0.000000] 503MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 1f730000
[    0.000000]   low ram: 0 - 1f730000
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x0001f730
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0001f730
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x81] disabled)
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 2 CPUs, 1 hotplug CPUs
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e8000
[    0.000000] PM: Registered nosave memory: 00000000000e8000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 1f800000 (gap: 1f800000:e0380000)
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:32 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 12 pages/cpu @c1800000 s28160 r0 d20992 u2097152
[    0.000000] pcpu-alloc: s28160 r0 d20992 u2097152 alloc=1*4194304
[    0.000000] pcpu-alloc: [0] 0 1
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 127696
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.35-rc1-git2 root=/dev/sda1 ro console=ttyS0 console=tty0
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] Subtract (41 early reservations)
[    0.000000]   #1 [0000001000 - 0000002000]   EX TRAMPOLINE
[    0.000000]   #2 [0001000000 - 00013cff2c]   TEXT DATA BSS
[    0.000000]   #3 [00013d0000 - 00013d62a8]             BRK
[    0.000000]   #4 [00000ff790 - 0000100000]   BIOS reserved
[    0.000000]   #5 [00000ff780 - 00000ff790]    MP-table mpf
[    0.000000]   #6 [000009fc00 - 00000f12a0]   BIOS reserved
[    0.000000]   #7 [00000f13b8 - 00000ff780]   BIOS reserved
[    0.000000]   #8 [00000f12a0 - 00000f13b8]    MP-table mpc
[    0.000000]   #9 [0000010000 - 0000011000]      TRAMPOLINE
[    0.000000]   #10 [0000011000 - 0000015000]     ACPI WAKEUP
[    0.000000]   #11 [0000015000 - 0000016000]         PGTABLE
[    0.000000]   #12 [00013d62c0 - 00017c62c0]         BOOTMEM
[    0.000000]   #13 [00013cff40 - 00013cff44]         BOOTMEM
[    0.000000]   #14 [00017c62c0 - 00017c6380]         BOOTMEM
[    0.000000]   #15 [00013cff80 - 00013cffb0]         BOOTMEM
[    0.000000]   #16 [00017c6380 - 00017c7b80]         BOOTMEM
[    0.000000]   #17 [00013cffc0 - 00013cffe7]         BOOTMEM
[    0.000000]   #18 [00017c7b80 - 00017c7c7c]         BOOTMEM
[    0.000000]   #19 [00017c7c80 - 00017c7cc0]         BOOTMEM
[    0.000000]   #20 [00017c7cc0 - 00017c7d00]         BOOTMEM
[    0.000000]   #21 [00017c7d00 - 00017c7d40]         BOOTMEM
[    0.000000]   #22 [00017c7d40 - 00017c7d80]         BOOTMEM
[    0.000000]   #23 [00017c7d80 - 00017c7dc0]         BOOTMEM
[    0.000000]   #24 [00017c7dc0 - 00017c7e00]         BOOTMEM
[    0.000000]   #25 [00017c7e00 - 00017c7e40]         BOOTMEM
[    0.000000]   #26 [00017c7e40 - 00017c7e80]         BOOTMEM
[    0.000000]   #27 [00017c7e80 - 00017c7e90]         BOOTMEM
[    0.000000]   #28 [00017c7ec0 - 00017c7f16]         BOOTMEM
[    0.000000]   #29 [00017c7f40 - 00017c7f96]         BOOTMEM
[    0.000000]   #30 [0001800000 - 000180c000]         BOOTMEM
[    0.000000]   #31 [0001a00000 - 0001a0c000]         BOOTMEM
[    0.000000]   #32 [00017c9fc0 - 00017c9fc4]         BOOTMEM
[    0.000000]   #33 [00017ca000 - 00017ca004]         BOOTMEM
[    0.000000]   #34 [00017ca040 - 00017ca048]         BOOTMEM
[    0.000000]   #35 [00017ca080 - 00017ca088]         BOOTMEM
[    0.000000]   #36 [00017ca0c0 - 00017ca168]         BOOTMEM
[    0.000000]   #37 [00017ca180 - 00017ca1e8]         BOOTMEM
[    0.000000]   #38 [00017c7fc0 - 00017c9fc0]         BOOTMEM
[    0.000000]   #39 [000180c000 - 000184c000]         BOOTMEM
[    0.000000]   #40 [00017ca200 - 00017ea200]         BOOTMEM
[    0.000000] Memory: 506328k/515264k available (1946k kernel code, 8484k reserved, 1144k data, 288k init, 0k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffd37000 - 0xfffff000   (2848 kB)
[    0.000000]     vmalloc : 0xdff30000 - 0xffd35000   ( 510 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xdf730000   ( 503 MB)
[    0.000000]       .init : 0xc1305000 - 0xc134d000   ( 288 kB)
[    0.000000]       .data : 0xc11e6a99 - 0xc1304aa0   (1144 kB)
[    0.000000]       .text : 0xc1000000 - 0xc11e6a99   (1946 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=13, HWalign=128, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000]  RCU-based detection of stalled CPUs is disabled.
[    0.000000]  Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:1280
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2793.087 MHz processor.
[    0.012009] Calibrating delay loop (skipped), value calculated using timer frequency.. 5586.17 BogoMIPS (lpj=11172348)
[    0.020005] pid_max: default: 32768 minimum: 301
[    0.024040] Mount-cache hash table entries: 512
[    0.028186] Initializing cgroup subsys ns
[    0.032010] Initializing cgroup subsys cpuacct
[    0.036008] Initializing cgroup subsys devices
[    0.040004] Initializing cgroup subsys freezer
[    0.044030] CPU0: Hyper-Threading is disabled
[    0.048005] mce: CPU supports 4 MCE banks
[    0.052015] CPU0: Thermal monitoring enabled (TM1)
[    0.056006] using mwait in idle threads.
[    0.064007] Performance Events: Netburst events, Netburst P4/Xeon PMU driver.
[    0.076014] ... version:                0
[    0.080003] ... bit width:              40
[    0.084003] ... generic registers:      18
[    0.088004] ... value mask:             000000ffffffffff
[    0.092003] ... max period:             0000007fffffffff
[    0.096003] ... fixed-purpose events:   0
[    0.100003] ... event mask:             000000000003ffff
[    0.104396] SMP alternatives: switching to UP code
[    0.112863] ACPI: Core revision 20100428
[    0.127011] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.132138] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.175765] CPU0: Intel(R) Celeron(R) CPU 2.80GHz stepping 01
[    0.188000] Brought up 1 CPUs
[    0.188007] Total of 1 processors activated (5586.17 BogoMIPS).
[    0.192193] devtmpfs: initialized
[    0.196564] Time: 20:12:46  Date: 06/05/10
[    0.200055] NET: Registered protocol family 16
[    0.204143] ACPI: bus type pci registered
[    0.208095] PCI: PCI BIOS revision 2.10 entry at 0xf0031, last bus=1
[    0.212003] PCI: Using configuration type 1 for base access
[    0.216783] bio: create slab <bio-0> at 0
[    0.224154] ACPI: Executed 1 blocks of module-level executable AML code
[    0.242295] ACPI: Interpreter enabled
[    0.244010] ACPI: (supports S0 S1 S3 S4 S5)
[    0.264006] ACPI: Using IOAPIC for interrupt routing
[    0.282227] ACPI Warning: Incorrect checksum in table [OEMB] - 0xB7, should be 0xA8 (20100428/tbutils-314)
[    0.292180] ACPI: No dock devices found.
[    0.296007] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
[    0.304168] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.308504] pci 0000:00:00.0: Enabling MCH 'Overflow' Device
[    0.312711] pci 0000:00:1f.0: quirk: [io  0x0800-0x087f] claimed by ICH4 ACPI/GPIO/TCO
[    0.316005] pci 0000:00:1f.0: quirk: [io  0x0480-0x04bf] claimed by ICH4 GPIO
[    0.320404] pci 0000:00:1e.0: PCI bridge to [bus 01-01] (subtractive decode)
[    0.334712] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.368154] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.408151] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[    0.447676] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[    0.482430] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.512151] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.554434] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.594432] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.630450] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.632013] vgaarb: loaded
[    0.636148] SCSI subsystem initialized
[    0.640161] PCI: Using ACPI for IRQ routing
[    0.644333] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.662284] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.666015] Switching to clocksource tsc
[    0.668062] pnp: PnP ACPI init
[    0.704610] ACPI: bus type pnp registered
[    0.760006] pnp: PnP ACPI: found 15 devices
[    0.810140] ACPI: ACPI bus type pnp unregistered
[    0.865469] system 00:0b: [io  0x0680-0x06ff] has been reserved
[    0.936366] system 00:0b: [io  0x0290-0x0297] has been reserved
[    1.007285] system 00:0c: [io  0x04d0-0x04d1] has been reserved
[    1.078188] system 00:0c: [io  0x0800-0x087f] has been reserved
[    1.149102] system 00:0c: [io  0x0480-0x04bf] has been reserved
[    1.220019] system 00:0c: [mem 0xfed20000-0xfed8ffff] has been reserved
[    1.299248] system 00:0c: [mem 0xffb00000-0xffbfffff] could not be reserved
[    1.382648] system 00:0d: [mem 0xfec00000-0xfec00fff] could not be reserved
[    1.466031] system 00:0d: [mem 0xfee00000-0xfee00fff] has been reserved
[    1.545268] system 00:0e: [mem 0x00000000-0x0009ffff] could not be reserved
[    1.628656] system 00:0e: [mem 0x000c0000-0x000dffff] could not be reserved
[    1.712047] system 00:0e: [mem 0x000e0000-0x000fffff] could not be reserved
[    1.795436] system 00:0e: [mem 0x00100000-0x1f7effff] could not be reserved
[    1.878830] system 00:0e: [mem 0xfff00000-0xffffffff] has been reserved
[    1.992870] pci 0000:00:1f.1: BAR 5: assigned [mem 0x20000000-0x200003ff]
[    2.074217] pci 0000:00:1f.1: BAR 5: set to [mem 0x20000000-0x200003ff] (PCI address [0x20000000-0x200003ff]
[    2.191908] pci 0000:00:1e.0: PCI bridge to [bus 01-01]
[    2.254505] pci 0000:00:1e.0:   bridge window [io  0xd000-0xdfff]
[    2.327506] pci 0000:00:1e.0:   bridge window [mem 0xfe500000-0xfe5fffff]
[    2.408814] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    2.481888] NET: Registered protocol family 2
[    2.534178] IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
[    2.617717] TCP established hash table entries: 16384 (order: 5, 131072 bytes)
[    2.704304] TCP bind hash table entries: 16384 (order: 5, 131072 bytes)
[    2.783661] TCP: Hash tables configured (established 16384 bind 16384)
[    2.861855] TCP reno registered
[    2.899496] UDP hash table entries: 256 (order: 1, 8192 bytes)
[    2.969374] UDP-Lite hash table entries: 256 (order: 1, 8192 bytes)
[    3.044586] NET: Registered protocol family 1
[    3.096897] pci 0000:01:08.0: Firmware left e100 interrupts enabled; disabling
[    3.185679] msgmni has been set to 988
[    3.230851] alg: No test for stdrng (krng)
[    3.280051] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    3.368655] io scheduler noop registered
[    3.415645] io scheduler deadline registered
[    3.466869] io scheduler cfq registered (default)
[    3.525713] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    3.601918] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    3.673957] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    3.748966] ata_piix 0000:00:1f.1: enabling device (0005 -> 0007)
[    3.821924] ata_piix 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    3.907533] scsi0 : ata_piix
[    3.942138] scsi1 : ata_piix
[    3.979186] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xfc00 irq 14
[    4.062605] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xfc08 irq 15
[    4.146207] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[    4.240206] serio: i8042 KBD port at 0x60,0x64 irq 1
[    4.299684] serio: i8042 AUX port at 0x60,0x64 irq 12
[    4.360403] mice: PS/2 mouse device common for all mice
[    4.423094] rtc_cmos 00:02: RTC can wake from S4
[    4.478510] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    4.551560] rtc0: alarms up to one month, 114 bytes nvram, hpet irqs
[    4.627668] cpuidle: using governor ladder
[    4.676724] cpuidle: using governor menu
[    4.723900] TCP cubic registered
[    4.762600] NET: Registered protocol family 17
[    4.815863] Using IPI No-Shortcut mode
[    4.861076]   Magic number: 14:663:244
[    4.906153] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    5.009366] rtc_cmos 00:02: setting system clock to 2010-06-05 20:12:52 UTC (1275768772)
[    5.210610] ata1.00: ATA-6: WDC WD800JB-00FMA0, 13.03G13, max UDMA/100
[    5.288836] ata1.00: 156301488 sectors, multi 16: LBA
[    5.350420] ata1.00: limited to UDMA/33 due to 40-wire cable
[    5.434508] ata1.00: configured for UDMA/33
[    5.484780] scsi 0:0:0:0: Direct-Access     ATA      WDC WD800JB-00FM 13.0 PQ: 0 ANSI: 5
[    5.582015] sd 0:0:0:0: [sda] 156301488 512-byte logical blocks: (80.0 GB/74.5 GiB)
[    5.673863] sd 0:0:0:0: [sda] Write Protect is off
[    5.731305] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.839828]  sda: sda1 sda2
[    5.886987] sd 0:0:0:0: [sda] Attached SCSI disk
[    5.947611] EXT3-fs: barriers not enabled
[    6.008250] kjournald starting.  Commit interval 5 seconds
[    6.074030] EXT3-fs (sda1): mounted filesystem with ordered data mode
[    6.151560] VFS: Mounted root (ext3 filesystem) readonly on device 8:1.
[    6.230897] Freeing unused kernel memory: 288k freed
[    6.290681] Write protecting the kernel text: 1948k
[    6.349135] Write protecting the kernel read-only data: 820k
[    8.605483] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input1
[    8.770289] ACPI: Power Button [PWRB]
[    8.822377] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    8.931552] usbcore: registered new interface driver usbfs
[    8.998781] usbcore: registered new interface driver hub
[    9.063061] ACPI: Power Button [PWRF]
[    9.110804] usbcore: registered new device driver usb
[    9.176133] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    9.257773] ehci_hcd 0000:00:1d.7: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    9.343941] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    9.407023] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    9.502182] ehci_hcd 0000:00:1d.7: debug port 1
[    9.561483] Linux agpgart interface v0.103
[    9.615298] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfe77bc00
[    9.696050] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    9.770150] hub 1-0:1.0: USB hub found
[    9.817114] hub 1-0:1.0: 8 ports detected
[    9.966145] uhci_hcd: USB Universal Host Controller Interface driver
[   10.043369] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   10.131078] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   10.201151] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[   10.297471] uhci_hcd 0000:00:1d.0: irq 16, io base 0x0000eec0
[   10.368646] hub 2-0:1.0: USB hub found
[   10.413956] hub 2-0:1.0: 2 ports detected
[   10.462755] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[   10.548952] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   10.611986] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[   10.701023] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000ef00
[   10.770709] hub 3-0:1.0: USB hub found
[   10.817336] hub 3-0:1.0: 2 ports detected
[   10.866266] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[   10.960749] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   11.037917] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[   11.111107] e100: Copyright(c) 1999-2006 Intel Corporation
[   11.184052] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[   11.273144] e100 0000:01:08.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[   11.355161] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000ef20
[   11.428220] hub 4-0:1.0: USB hub found
[   11.504810] e100 0000:01:08.0: eth0: addr 0xfe5ef000, irq 20, MAC addr 00:13:d4:79:a3:67
[   11.602459] hub 4-0:1.0: 2 ports detected
[   11.675832] agpgart-intel 0000:00:00.0: Intel 865 Chipset
[   11.743624] [drm] Initialized drm 1.1.0 20060810
[   11.815875] agpgart-intel 0000:00:00.0: detected 8060K stolen memory
[   11.916905] agpgart-intel 0000:00:00.0: AGP aperture is 128M @ 0xf0000000
[   11.998948] uhci_hcd 0000:00:1d.3: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   12.086056] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[   12.149296] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[   12.238371] uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000ef40
[   12.308612] hub 5-0:1.0: USB hub found
[   12.353900] hub 5-0:1.0: 2 ports detected
[   12.467069] input: PS/2 Generic Mouse as /devices/platform/i8042/serio1/input/input3
[   12.586016] Intel ICH 0000:00:1f.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[   13.100023] intel8x0_measure_ac97_clock: measured 55813 usecs (2689 samples)
[   13.184478] intel8x0: clocking to 48000
[   13.232336] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   13.340962] [drm] set up 7M of stolen space
[   13.434270] [drm] initialized overlay support
[   13.486980] before intel_fbdev_init
[   13.528890] intel_fbdev_init()
[   13.567923] before drm_fb_helper_init
[   13.612085] before add_all_connectors
[   13.656344] before initial_config
[   13.696182] before disable_unused_functions
[   13.792166] before parse_command_line
[   13.836076] before probe_connector_modes
[   13.994170] before setup_crtcs
[   14.030996] drm_fb_helper_single_fb_probe()
[   14.081169] before push down
[   14.115646] intel_fb_find_or_create_single()
[   14.166800] intelfb_create
[   14.202779] before i915_gem_object_pin
[   14.259875] before framebuffer_alloc
[   14.304216] before intel_framebuffer_init
[   14.353406] before fb_alloc_cmap
[   14.392080] before drm_fb_helper_fill
[   14.435905] before vga_switcheroo_client_fb_set
[   14.490177] intelfb_create() end
[   14.528857] intel_fb_find_or_create_single() end
[   14.584173] after push down
[   14.617653] before register_framebuffer
[   14.663613] register_framebuffer()
[   14.704375] before remove_conflicting
[   14.748253] before device_create
[   14.791508] after device_create
[   14.829279] before fb_init_device
[   14.870690] before fb_var_to_videomode
[   14.915642] before fb_add_videomode
[   14.957811] before fb_notifier_call_chain
[   15.006095] fbcon_fb_registered()
[   15.045870] fbcon_takeover()
[   15.080364] take_over_console()
[   15.118003] register_con_driver()
[   15.157725] fbcon_startup()
[   15.157728] before fb_open
[   15.157729] after fb_open
[   15.158332] before vc_resize
[   15.158342] fbcon_startup() end
[   15.328591] register_con_driver() end
[   15.372509] bind_con_driver()
[   15.408023] before acquire_console_sem()
[   15.455003] after acquire_console_sem()
[   15.500959] after for, retval=0
[   15.538599] before deflt
[   15.568960] after deflt
[   15.598284] for i=0
[   15.623446] ------------[ cut here ]------------
[   15.678771] WARNING: at drivers/char/vt.c:633 save_screen+0x24/0x34()
[   15.755921] Hardware name: To Be Filled By O.E.M.
[   15.812276] Modules linked in: i915(+) drm_kms_helper snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm drm snd_timer e100 ie
[   16.124421] Pid: 115, comm: modprobe Not tainted 2.6.35-rc1-git2 #14
[   16.200533] Call Trace:
[   16.229861]  [<c1026d50>] ? warn_slowpath_common+0x6a/0x7b
[   16.295575]  [<c1149da6>] ? save_screen+0x24/0x34
[   16.351930]  [<c1026d6e>] ? warn_slowpath_null+0xd/0x10
[   16.414525]  [<c1149da6>] ? save_screen+0x24/0x34
[   16.470881]  [<c114cb8d>] ? take_over_console+0x1c5/0x335
[   16.535558]  [<c11099b0>] ? fbcon_takeover+0x66/0xb0
[   16.595032]  [<c110c483>] ? fbcon_event_notify+0x1b2/0x4b0
[   16.660750]  [<c11e44be>] ? schedule+0x306/0x354
[   16.718459]  [<c103a0ff>] ? notifier_call_chain+0x23/0x46
[   16.783132]  [<c103a346>] ? __blocking_notifier_call_chain+0x39/0x4c
[   16.859244]  [<c103a362>] ? blocking_notifier_call_chain+0x9/0xc
[   16.931200]  [<c110339f>] ? register_framebuffer+0x255/0x272
[   16.999000]  [<e0083633>] ? drm_fb_helper_single_fb_probe+0x1e2/0x291 [drm_kms_helper]
[   17.093824]  [<e0083b70>] ? drm_fb_helper_initial_config+0x48e/0x49e [drm_kms_helper]
[   17.187611]  [<c11e45c3>] ? _cond_resched+0x26/0x3d
[   17.246073]  [<e023ed37>] ? intel_fbdev_init+0x79/0x82 [i915]
[   17.314897]  [<e02269a3>] ? i915_driver_load+0xd93/0xe5b [i915]
[   17.385803]  [<e0264005>] ? drm_get_dev+0x2cf/0x3b9 [drm]
[   17.450473]  [<c10fc86f>] ? local_pci_probe+0xb/0xc
[   17.508909]  [<c10fd2c6>] ? pci_device_probe+0x41/0x63
[   17.570463]  [<c1156c4b>] ? driver_probe_device+0x8c/0x110
[   17.636180]  [<c1156d0f>] ? __driver_attach+0x40/0x5b
[   17.696696]  [<c11564c5>] ? bus_for_each_dev+0x37/0x5f
[   17.758249]  [<c1156b1a>] ? driver_attach+0x11/0x13
[   17.816687]  [<c1156ccf>] ? __driver_attach+0x0/0x5b
[   17.876167]  [<c1156840>] ? bus_add_driver+0x87/0x1bb
[   17.936682]  [<c10ee9c9>] ? kset_find_obj+0x20/0x4a
[   17.995116]  [<c1156f28>] ? driver_register+0x7a/0xd9
[   18.055631]  [<c10fd491>] ? __pci_register_driver+0x33/0x89
[   18.122399]  [<e009d000>] ? i915_init+0x0/0x85 [i915]
[   18.182901]  [<c100112d>] ? do_one_initcall+0x44/0x120
[   18.244459]  [<c1048760>] ? sys_init_module+0xa7/0x1d7
[   18.306014]  [<c1002757>] ? sysenter_do_call+0x12/0x26
[   18.367568] ---[ end trace e5cd889fd9f41fa5 ]---
[   18.429997] fbcon_init()
[   18.460409] before con2fb_acquire_newinfo
[   18.508363] before set mode
[   18.541735] drm_fb_helper_set_par(), info=de583800
[   18.599025] var=de583830
[   18.629282] dev=de582000
[   18.660065] drm_fb_helper_set_par for i=0
[   18.708050] fb_helper=de404b00
[   18.744600] fb_helper->crtc_info=de5aac00
[   18.792530] fb_helper->crtc_info[i].mode_set=de5aac04
[   18.852943] crtc=df04e000
[   18.884240] crtc->funcs=e02460bc
[   18.922816] crtc->funcs->set_config=e0084848
[   19.072527] drm_fb_helper_set_par for i=1
[   19.120526] fb_helper=de404b00
[   19.157086] fb_helper->crtc_info=de5aac00
[   19.205018] fb_helper->crtc_info[i].mode_set=de5aac30
[   19.265431] crtc=(null)
[   19.295315] BUG: unable to handle kernel NULL pointer dereference at 000000f0
[   19.298644] IP: [<e00833c7>] drm_fb_helper_set_par+0xc1/0x14b [drm_kms_helper]
[   19.298644] *pde = 00000000
[   19.298644] Oops: 0000 [#1] SMP
[   19.298644] last sysfs file: /sys/devices/virtual/net/lo/operstate
[   19.298644] Modules linked in: i915(+) drm_kms_helper snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm drm snd_timer e100 ie
[   19.298644]
[   19.298644] Pid: 115, comm: modprobe Tainted: G        W   2.6.35-rc1-git2 #14 P4P800-VM/To Be Filled By O.E.M.
[   19.298644] EIP: 0060:[<e00833c7>] EFLAGS: 00010296 CPU: 0
[   19.298644] EIP is at drm_fb_helper_set_par+0xc1/0x14b [drm_kms_helper]
[   19.298644] EAX: 0000001e EBX: de404b00 ECX: df2dbc54 EDX: e0085637
[   19.298644] ESI: 00000001 EDI: 00000000 EBP: de582290 ESP: df2dbc50
[   19.298644]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[   19.298644] Process modprobe (pid: 115, ti=df2da000 task=df2ad8f0 task.ti=df2da000)
[   19.298644] Stack:
[   19.298644]  e0085637 00000000 0000002c df004000 de583800 df32fe00 c13c6158 c110be62
[   19.298644] <0> 00000100 000000a0 df004000 00000040 00000001 00000001 00000019 00000050
[   19.298644] <0> 00000000 df004000 c12027f0 00000000 00000000 c1149905 df004000 00000000
[   19.298644] Call Trace:
[   19.298644]  [<c110be62>] ? fbcon_init+0x294/0x3a8
[   19.298644]  [<c1149905>] ? visual_init+0x7f/0xb9
[   19.298644]  [<c114cbb7>] ? take_over_console+0x1ef/0x335
[   19.298644]  [<c11099b0>] ? fbcon_takeover+0x66/0xb0
[   19.298644]  [<c110c483>] ? fbcon_event_notify+0x1b2/0x4b0
[   19.298644]  [<c11e44be>] ? schedule+0x306/0x354
[   19.298644]  [<c103a0ff>] ? notifier_call_chain+0x23/0x46
[   19.298644]  [<c103a346>] ? __blocking_notifier_call_chain+0x39/0x4c
[   19.298644]  [<c103a362>] ? blocking_notifier_call_chain+0x9/0xc
[   19.298644]  [<c110339f>] ? register_framebuffer+0x255/0x272
[   19.298644]  [<e0083633>] ? drm_fb_helper_single_fb_probe+0x1e2/0x291 [drm_kms_helper]
[   19.298644]  [<e0083b70>] ? drm_fb_helper_initial_config+0x48e/0x49e [drm_kms_helper]
[   19.298644]  [<c11e45c3>] ? _cond_resched+0x26/0x3d
[   19.298644]  [<e023ed37>] ? intel_fbdev_init+0x79/0x82 [i915]
[   19.298644]  [<e02269a3>] ? i915_driver_load+0xd93/0xe5b [i915]
[   19.298644]  [<e0264005>] ? drm_get_dev+0x2cf/0x3b9 [drm]
[   19.298644]  [<c10fc86f>] ? local_pci_probe+0xb/0xc
[   19.298644]  [<c10fd2c6>] ? pci_device_probe+0x41/0x63
[   19.298644]  [<c1156c4b>] ? driver_probe_device+0x8c/0x110
[   19.298644]  [<c1156d0f>] ? __driver_attach+0x40/0x5b
[   19.298644]  [<c11564c5>] ? bus_for_each_dev+0x37/0x5f
[   19.298644]  [<c1156b1a>] ? driver_attach+0x11/0x13
[   19.298644]  [<c1156ccf>] ? __driver_attach+0x0/0x5b
[   19.298644]  [<c1156840>] ? bus_add_driver+0x87/0x1bb
[   19.298644]  [<c10ee9c9>] ? kset_find_obj+0x20/0x4a
[   19.298644]  [<c1156f28>] ? driver_register+0x7a/0xd9
[   19.298644]  [<c10fd491>] ? __pci_register_driver+0x33/0x89
[   19.298644]  [<e009d000>] ? i915_init+0x0/0x85 [i915]
[   19.298644]  [<c100112d>] ? do_one_initcall+0x44/0x120
[   19.298644]  [<c1048760>] ? sys_init_module+0xa7/0x1d7
[   19.298644]  [<c1002757>] ? sysenter_do_call+0x12/0x26
[   19.298644] Code: 6b d6 2c 8b 43 10 01 d0 8b 78 10 83 c0 04 50 68 12 56 08 e0 89 54 24 20 e8 f3 0c 16 e1 83 c4 20 57 68
[   19.298644] EIP: [<e00833c7>] drm_fb_helper_set_par+0xc1/0x14b [drm_kms_helper] SS:ESP 0068:df2dbc50
[   19.298644] CR2: 00000000000000f0
[   23.239762] ---[ end trace e5cd889fd9f41fa6 ]---                                                                        

Seems to be very nasty NULL pointer dereference - it's under
acquire_console_sem so nothing is printed... Had to comment out
acquire_console_sem() in bind_con_driver() to get this.

NULL crtc is dereferenced in drm_fb_helper_set_par():
...
        for (i = 0; i < fb_helper->crtc_count; i++) {
                printk("drm_fb_helper_set_par for i=%d\n", i);
                printk("fb_helper=%p\n", fb_helper);
                printk("fb_helper->crtc_info=%p\n", fb_helper->crtc_info);
                crtc = fb_helper->crtc_info[i].mode_set.crtc;
                printk("fb_helper->crtc_info[i].mode_set=%p\n", &fb_helper->crtc_info[i].mode_set);
                printk("crtc=%p\n", crtc);
                printk("crtc->funcs=%p\n", crtc->funcs);
                printk("crtc->funcs->set_config=%p\n", crtc->funcs->set_config);
                ret = crtc->funcs->set_config(&fb_helper->crtc_info[i].mode_set);
                if (ret) {
                        mutex_unlock(&dev->mode_config.mutex);
                        return ret;
                }
        }

As both 8be48d924c307e72e3797ab5bde81b07a1ccc52d and
386516744ba45d50f42c6999151cc210cb4f96e4 are very large, I can't find the bug.

-- 
Ondrej Zary
