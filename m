Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756368Ab0FAOqh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 10:46:37 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:58964 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920Ab0FAOqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 10:46:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=Wec8IBa0MV7nEwuRxGFT+eo9znUsqey1rD2ifUHD+XY1B55fVhI0WeafNimx87unYO
         B3PY6LzlzuAIkbZ+IeaByV6OyQpUoruI+Ov76eDNABCMvm6WOtdLpY1MbYVbpKvMYvsm
         pvsfvE8JrGYP+IZzER1CFGZJYKvKXT89Rrsrg=
Message-ID: <4C051D44.7040203@gmail.com>
Date: Tue, 01 Jun 2010 16:46:28 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.4) Gecko/20100522 SUSE/3.1rc1-2.1 Thunderbird/3.1
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       linux-ide@vger.kernel.org
Subject: Re: hibernation hangs with ATA errors (lockup_detector bug)
References: <4C03C608.1040600@gmail.com> <20100601135004.GP15159@redhat.com>
In-Reply-To: <20100601135004.GP15159@redhat.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2010 03:50 PM, Don Zickus wrote:
> On Mon, May 31, 2010 at 04:22:00PM +0200, Jiri Slaby wrote:
>> Hi,
>>
>> with -next I get the following errors while trying to hibernate in
>> qemu-kvm after the image is stored on disk:
> 
> Is this the host that is hibernating or the guest?

Guest.

> KVM guests don't emulate the performance counters, so the nmi piece
> shouldn't be functioning and the soft lockup piece just sits on top of an
> hrtimer, so off the top of my head it is hard to imagine it intefering
> with a sata driver.
> 
> I'll need your whole boot up log to see how the lockup detector
> initialized itself.

Here it goes (till the moment it dies on the ata errors):

Linux version 2.6.34-mm1_64+ (ku@bellona) (gcc version 4.5.0 20100420
[gcc-4_5-branch revision 158562] (SUSE Linux) ) #1209 SMP Thu May 27
22:57:37 CEST 2010
Command line: root=/dev/sda1 resume=/dev/sdb debug no_console_suspend
console=ttyS0,115200 console=tty0 printk.time=1 2
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
 BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003e7fb000 (usable)
 BIOS-e820: 000000003e7fb000 - 000000003e800000 (reserved)
 BIOS-e820: 00000000fffbc000 - 0000000100000000 (reserved)
NX (Execute Disable) protection: active
DMI 2.4 present.
e820 update range: 0000000000000000 - 0000000000001000 (usable) ==>
(reserved)
e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
No AGP bridge found
last_pfn = 0x3e7fb max_arch_pfn = 0x400000000
MTRR default type: write-back
MTRR fixed ranges enabled:
  00000-9FFFF write-back
  A0000-BFFFF uncachable
  C0000-FFFFF write-protect
MTRR variable ranges enabled:
  0 base 00E0000000 mask FFE0000000 uncachable
  1 disabled
  2 disabled
  3 disabled
  4 disabled
  5 disabled
  6 disabled
  7 disabled
PAT not supported by CPU.
initial memory mapped : 0 - 20000000
init_memory_mapping: 0000000000000000-000000003e7fb000
 0000000000 - 003e600000 page 2M
 003e600000 - 003e7fb000 page 4k
kernel direct mapping tables up to 3e7fb000 @ 8000-b000
RAMDISK: 3df2f000 - 3e7f0000
ACPI: RSDP 00000000000f84c0 00014 (v00 BOCHS )
ACPI: RSDT 000000003e7fde10 00034 (v01 BOCHS  BXPCRSDT 00000001 BXPC
00000001)
ACPI: FACP 000000003e7ffe40 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC
00000001)
ACPI: DSDT 000000003e7fdfd0 01E22 (v01   BXPC   BXDSDT 00000001 INTL
20090123)
ACPI: FACS 000000003e7ffe00 00040
ACPI: SSDT 000000003e7fdf80 00044 (v01 BOCHS  BXPCSSDT 00000001 BXPC
00000001)
ACPI: APIC 000000003e7fde90 0007A (v01 BOCHS  BXPCAPIC 00000001 BXPC
00000001)
ACPI: HPET 000000003e7fde50 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC
00000001)
ACPI: Local APIC address 0xfee00000
(8/32 early reservations) ==> bootmem [0000000000 - 003e7fb000]
  #0 [0001000000 - 0001989354]    TEXT DATA BSS ==> [0001000000 -
0001989354]
  #1 [003df2f000 - 003e7f0000]          RAMDISK ==> [003df2f000 -
003e7f0000]
  #2 [000009f000 - 0000100000]    BIOS reserved ==> [000009f000 -
0000100000]
  #3 [000198a000 - 000198a049]              BRK ==> [000198a000 -
000198a049]
  #4 [0000001000 - 0000003000]       TRAMPOLINE ==> [0000001000 -
0000003000]
  #5 [0000003000 - 0000007000]      ACPI WAKEUP ==> [0000003000 -
0000007000]
  #6 [0000008000 - 0000009000]          PGTABLE ==> [0000008000 -
0000009000]
  #7 [0000009000 - 0000011000]          BOOTMAP ==> [0000009000 -
0000011000]
 [ffffea0000000000-ffffea0000dfffff] PMD ->
[ffff880002200000-ffff880002ffffff] on node 0
sizeof(struct page) = 56
Zone PFN ranges:
  DMA      0x00000001 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   empty
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000001 -> 0x0000009f
    0: 0x00000100 -> 0x0003e7fb
On node 0 totalpages: 255897
  DMA zone: 56 pages used for memmap
  DMA zone: 112 pages reserved
  DMA zone: 3830 pages, LIFO batch:0
  DMA32 zone: 3444 pages used for memmap
  DMA32 zone: 248455 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0xb008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ5 used by override.
ACPI: IRQ9 used by override.
ACPI: IRQ10 used by override.
ACPI: IRQ11 used by override.
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a201 base: 0xfed00000
SMP: Allowing 2 CPUs, 0 hotplug CPUs
nr_irqs_gsi: 40
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
Allocating PCI resources starting at 3e800000 (gap: 3e800000:c17bc000)
setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:2 nr_node_ids:1
PERCPU: Embedded 26 pages/cpu @ffff880001a00000 s76352 r8192 d21952 u1048576
pcpu-alloc: s76352 r8192 d21952 u1048576 alloc=1*2097152
pcpu-alloc: [0] 0 1
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 252285
Kernel command line: root=/dev/sda1 resume=/dev/sdb debug
no_console_suspend console=ttyS0,115200 console=tty0 printk.time=1 2
PID hash table entries: 4096 (order: 3, 32768 bytes)
Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
Checking aperture...
No AGP bridge found
Memory: 988644k/1023980k available (5634k kernel code, 392k absent,
34944k reserved, 3013k data, 424k init)
SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
Hierarchical RCU implementation.
 RCU-based detection of stalled CPUs is disabled.
 Verbose stalled-CPUs detection is disabled.
NR_IRQS:4352 nr_irqs:512
Console: colour VGA+ 80x25
console [tty0] enabled
console [ttyS0] enabled
allocated 10485760 bytes of page_cgroup
please try 'cgroup_disable=memory' option if you don't want memory cgroups
hpet clockevent registered
Fast TSC calibration using PIT
Detected 2990.792 MHz processor.
Calibrating delay loop (skipped), value calculated using timer
frequency.. 5981.58 BogoMIPS (lpj=11963168)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 256
Initializing cgroup subsys debug
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
Initializing cgroup subsys memory
Initializing cgroup subsys devices
Initializing cgroup subsys freezer
mce: CPU supports 10 MCE banks
Performance Events: unsupported p6 CPU model 2 no PMU driver, software
events only.
ACPI: Core revision 20100428
Setting APIC routing to flat
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel QEMU Virtual CPU version 0.12.3 stepping 03
NMI watchdog failed to create perf event on cpu0: ffffffffffffffed
Booting Node   0, Processors  #1 Ok.
NMI watchdog failed to create perf event on cpu1: ffffffffffffffed
Brought up 2 CPUs
Total of 2 processors activated (11949.21 BogoMIPS).
devtmpfs: initialized
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using configuration type 1 for base access
mtrr: your CPUs had inconsistent variable MTRR settings
mtrr: your CPUs had inconsistent MTRRdefType settings
mtrr: probably your BIOS does not setup all CPUs.
mtrr: corrected configuration.
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: No dock devices found.
PCI: Ignoring host bridge windows from ACPI; if necessary, use
"pci=use_crs" and report a bug
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
(ignored)
pci_root PNP0A03:00: host bridge window [mem 0xe0000000-0xfebfffff]
(ignored)
pci 0000:00:01.1: reg 20: [io  0xc000-0xc00f]
pci 0000:00:01.2: reg 20: [io  0xc020-0xc03f]
pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX4 ACPI
pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX4 SMB
pci 0000:00:02.0: reg 10: [mem 0xf0000000-0xf1ffffff pref]
pci 0000:00:02.0: reg 14: [mem 0xf2000000-0xf2000fff]
pci 0000:00:02.0: reg 30: [mem 0xf2010000-0xf201ffff pref]
pci 0000:00:03.0: reg 10: [mem 0xf2020000-0xf203ffff]
pci 0000:00:03.0: reg 14: [io  0xc040-0xc07f]
pci 0000:00:03.0: reg 30: [mem 0xf2040000-0xf205ffff pref]
pci_bus 0000:00: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
Advanced Linux Sound Architecture Driver Version 1.0.23.
PCI: Using ACPI for IRQ routing
PCI: pci_cache_line_size set to 64 bytes
reserve RAM buffer: 000000000009f000 - 000000000009ffff
reserve RAM buffer: 000000003e7fb000 - 000000003fffffff
cfg80211: Calling CRDA to update world regulatory domain
HPET: 3 timers in total, 0 timers will be used for per-cpu timer
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 comparators, 64-bit 100.000000 MHz counter
Switching to clocksource tsc
Slow work thread pool: Starting up
Slow work thread pool: Ready
FS-Cache: Loaded
CacheFiles: Loaded
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 8 devices
ACPI: ACPI bus type pnp unregistered
pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffffffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
UDP hash table entries: 512 (order: 2, 16384 bytes)
UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
NET: Registered protocol family 1
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
pci 0000:00:00.0: Limiting direct PCI/PCI transfers
pci 0000:00:01.0: PIIX3: Enabling Passive Release
pci 0000:00:01.0: Activating ISA DMA hang workarounds
pci 0000:00:02.0: Boot video device
PCI: CLS 0 bytes, default 64
Unpacking initramfs...
Freeing initrd memory: 8964k freed
kvm: no hardware support
fuse init (API version 7.13)
msgmni has been set to 1948
alg: No test for stdrng (krng)
io scheduler noop registered
io scheduler cfq registered (default)
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
ACPI: Power Button [PWRF]
Linux agpgart interface v0.103
Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin
is 60 seconds).
Hangcheck: Using getrawmonotonic().
[drm] Initialized drm 1.1.0 20060810
[drm:i915_init] *ERROR* drm/i915 can't work without intel_agp module!
Serial: 8250/16550 driver, 2 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
parport_pc 00:05: reported by Plug and Play ACPI
parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
FDC 0 is a S82078B
loop: module loaded
ata_piix 0000:00:01.1: version 2.13
ata_piix 0000:00:01.1: setting latency timer to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: PATA max MWDMA2 cmd 0x1f0 ctl 0x3f6 bmdma 0xc000 irq 14
ata2: PATA max MWDMA2 cmd 0x170 ctl 0x376 bmdma 0xc008 irq 15
e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k6-NAPI
e1000: Copyright (c) 1999-2006 Intel Corporation.
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
e1000 0000:00:03.0: PCI INT A -> Link[LNKC] -> GSI 11 (level, high) ->
IRQ 11
e1000 0000:00:03.0: setting latency timer to 64
ata1.00: ATA-7: QEMU HARDDISK, 0.12.3, max UDMA/100
ata1.00: 20971520 sectors, multi 16: LBA48
ata1.01: ATA-7: QEMU HARDDISK, 0.12.3, max UDMA/100
ata1.01: 1433602 sectors, multi 16: LBA48
ata2.01: NODEV after polling detection
ata2.00: ATAPI: QEMU DVD-ROM, 0.12.3, max UDMA/100
ata2.00: configured for MWDMA2
ata1.00: configured for MWDMA2
ata1.01: configured for MWDMA2
scsi 0:0:0:0: Direct-Access     ATA      QEMU HARDDISK    0.12 PQ: 0 ANSI: 5
scsi 0:0:1:0: Direct-Access     ATA      QEMU HARDDISK    0.12 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 20971520 512-byte logical blocks: (10.7 GB/10.0 GiB)
scsi 1:0:0:0: CD-ROM            QEMU     QEMU DVD-ROM     0.12 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't
support DPO or FUA
sd 0:0:1:0: [sdb] 1433602 512-byte logical blocks: (734 MB/700 MiB)
 sda:sr0: scsi3-mmc drive: 4x/4x xa/form2 tray
Uniform CD-ROM driver Revision: 3.20
 sda1
sd 0:0:1:0: [sdb] Write Protect is off
sr 1:0:0:0: Attached scsi CD-ROM sr0
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:1:0: [sdb] Mode Sense: 00 3a 00 00
sd 0:0:1:0: [sdb] Write cache: disabled, read cache: enabled, doesn't
support DPO or FUA
 sdb: unknown partition table
sd 0:0:1:0: [sdb] Attached SCSI disk
e1000 0000:00:03.0: eth0: (PCI:33MHz:32-bit)
e1000 0000:00:03.0: eth0: 52:54:00:12:34:56
e1000 0000:00:03.0: eth0: Intel(R) PRO/1000 Network Connection
e1000e: Intel(R) PRO/1000 Network Driver - 1.0.2-k4
e1000e: Copyright (c) 1999 - 2009 Intel Corporation.
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
console [netcon0] enabled
netconsole: network logging started
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
uhci_hcd: USB Universal Host Controller Interface driver
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 10
uhci_hcd 0000:00:01.2: PCI INT D -> Link[LNKD] -> GSI 10 (level, high)
-> IRQ 10
uhci_hcd 0000:00:01.2: setting latency timer to 64
uhci_hcd 0000:00:01.2: UHCI Host Controller
uhci_hcd 0000:00:01.2: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:01.2: irq 10, io base 0x0000c020
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as
/devices/platform/i8042/serio0/input/input1
rtc_cmos 00:01: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one day, 114 bytes nvram, hpet irqs
i2c /dev entries driver
coretemp: CPU (model=0x2) has no thermal sensor.
coretemp: CPU (model=0x2) has no thermal sensor.
md: raid0 personality registered for level 0
md: raid1 personality registered for level 1
device-mapper: ioctl: 4.17.0-ioctl (2010-03-05) initialised:
dm-devel@redhat.com
cpuidle: using governor ladder
cpuidle: using governor menu
Registered led device: input::numl
Registered led device: input::capsl
Registered led device: input::scrolll
Registered led device: input1::numl
Registered led device: input1::capsl
Registered led device: input1::scrolll
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
ALSA device list:
  No soundcards found.
TCP cubic registered
NET: Registered protocol family 10
NET: Registered protocol family 17
registered taskstats version 1
rtc_cmos 00:01: setting system clock to 2010-06-01 14:42:57 UTC (1275403377)
Freeing unused kernel memory: 424k freed
Write protecting the kernel read-only data: 8192k
Freeing unused kernel memory: 488k freed
Freeing unused kernel memory: 328k freed
udev: starting version 154
PM: Starting manual resume from disk
EXT4-fs (sda1): (no)acl options not supported
EXT4-fs (sda1): mounted filesystem with ordered data mode
EXT4-fs (sda1): (no)acl options not supported
udev: starting version 154
Adding 716796k swap on /dev/sdb.  Priority:-1 extents:1 across:716796k
ADDRCONF(NETDEV_UP): eth0: link is not ready
e1000: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
Syncing filesystems ... done.
Freezing user space processes ... (elapsed 0.01 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
PM: Preallocating image memory... done (allocated 28778 pages)
PM: Allocated 115112 kbytes in 0.03 seconds (3837.06 MB/s)
e1000 0000:00:03.0: PCI INT A disabled
PM: freeze of devices complete after 54.045 msecs
PM: late freeze of devices complete after 0.614 msecs
ACPI: Preparing to enter system sleep state S4
PM: Saving platform NVS memory
Disabling non-boot CPUs ...
Broke affinity for irq 14
CPU 1 is now offline
SMP alternatives: switching to UP code
PM: Creating hibernation image:
PM: Need to copy 28341 pages
PM: Hibernation image created (28341 pages copied)
Enabling non-boot CPUs ...
SMP alternatives: switching to SMP code
Booting Node 0 Processor 1 APIC 0x1
NMI watchdog failed to create perf event on cpu1: ffffffffffffffed
CPU1 is up
ACPI: Waking up from system sleep state S4
PM: early thaw of devices complete after 0.025 msecs
ata_piix 0000:00:01.1: restoring config space at offset 0x1 (was
0x2800003, writing 0x2800007)
e1000 0000:00:03.0: restoring config space at offset 0x1 (was 0x100003,
writing 0x100007)
e1000 0000:00:03.0: PCI INT A -> Link[LNKC] -> GSI 11 (level, high) ->
IRQ 11
e1000 0000:00:03.0: setting latency timer to 64
ata_piix 0000:00:01.1: setting latency timer to 64
sd 0:0:0:0: [sda] Starting disk
sd 0:0:1:0: [sdb] Starting disk
e1000: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX
ata1.00: configured for MWDMA2
ata1.01: configured for MWDMA2
PM: thaw of devices complete after 166.297 msecs
PM: Saving image data pages (28397 pages) ... done
PM: Wrote 113588 kbytes in 2.95 seconds (38.50 MB/s)
ata2.01: qc timeout (cmd 0xec)
ata2.01: failed to IDENTIFY (I/O error, err_mask=0x4)
sd 0:0:1:0: [sdb] Stopping disk
sd 0:0:0:0: [sda] Stopping disk
uhci_hcd 0000:00:01.2: PCI INT D disabled
e1000 0000:00:03.0: PCI INT A disabled
ata2.01: qc timeout (cmd 0xec)
ata2.01: failed to IDENTIFY (I/O error, err_mask=0x4)


-- 
js
