Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752358Ab2DVQkb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 12:40:31 -0400
Received: from mx.scalarmail.ca ([98.158.95.75]:47344 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751441Ab2DVQk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 12:40:29 -0400
Date: Sun, 22 Apr 2012 12:40:23 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>,
        Martin Peres <martin.peres@labri.fr>, dri-devel@lists.freedesktop.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.4-rc4
Message-ID: <20120422164023.GA32342@elliptictech.com>
References: <CA+55aFzQD4UyPVDQesrWq7JkM=BoQevdJpQt1YyaG10MtfM-Pw@mail.gmail.com>
 <20120422040715.GA30689@elliptictech.com>
 <CA+55aFwGrb_sOjHFWe6tYwf8mmNsFbqKAhz=bq2ofiU+F+wVvA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwGrb_sOjHFWe6tYwf8mmNsFbqKAhz=bq2ofiU+F+wVvA@mail.gmail.com>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-04-21 21:51 -0700, Linus Torvalds wrote:
> Nick, I realize you had trouble with a bisection already, but it might
> really be worth trying again. Do a
> 
>     git bisect visualize
> 
> and try to pick a good commit (avoding the problems you hit) when you
> hit a problem, and then do
> 
>    git reset --hard <that-point>
> 
> to force bisection to try another place. That way you can sometimes
> avoid the problem spots, and continue the bisection.

Unfortunately, I think the whole swath of commits bisect wants to test
are broken (as in, they panic before I get to see whether or not the VGA
is working), because the commit from which most of the drm trees were
based appears to be broken.  Nevertheless, I've included the new bisect
log (four new commits marked skip as opposed to last time).  I've also
included the boot log from a crashing kernel, in case someone recognizes
how I can avoid this during bisection.  Note that this crash is *not* a
regression that exists in current mainline -- bisecting this issue was
the first time I had ever seen it.

(Aside: is there a way to run "git bisect skip" without causing a new
working tree to be immediately checked out?  When I'm going to be
picking the next commit manually anyway, having git bisect checkout a
new tree arbitrarily, potentially forcing a complete recompile (~30
minutes) when the commit I picked could have been incrementally compiled
in ~1 minute is pretty annoying...)

  git bisect start 'drivers/gpu'
  # bad: [c16fa4f2ad19908a47c63d8fa436a1178438c7e7] Linux 3.3
  git bisect bad c16fa4f2ad19908a47c63d8fa436a1178438c7e7
  # good: [805a6af8dba5dfdd35ec35dc52ec0122400b2610] Linux 3.2
  git bisect good 805a6af8dba5dfdd35ec35dc52ec0122400b2610
  # skip: [5d56fe5fd794a98c4f446f8665fd06b82e93ff64] Merge branch 'drm-nouveau-next' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-core-next
  git bisect skip 5d56fe5fd794a98c4f446f8665fd06b82e93ff64
  # good: [dffc9ceb55695f121adc57dd1fde7304c3afe81e] gma500: kill virtual mapping support
  git bisect good dffc9ceb55695f121adc57dd1fde7304c3afe81e
  # skip: [5c2a5ce689c99037771a6c110374461781a6f042] drm: add missing exports for i810 driver.
  git bisect skip 5c2a5ce689c99037771a6c110374461781a6f042
  # skip: [44517c44496062180a6376cc704b33129441ce60] drm/radeon/kms: Add an MSI quirk for Dell RS690
  git bisect skip 44517c44496062180a6376cc704b33129441ce60
  # --- The commits below this point are newly tested ---
  # skip: [f7b24c42da1a7bbb98145d27aa716d8af3cae2a6] drm/nouveau/ttm: fix crash as a result of a recent ttm change
  git bisect skip f7b24c42da1a7bbb98145d27aa716d8af3cae2a6
  # skip: [0c101461e267850925218d6a6872c379f2498b16] drm/nv40/pm: parse fan pwm divisor from vbios tables
  git bisect skip 0c101461e267850925218d6a6872c379f2498b16
  # skip: [06e4cd64174b48345cbd99179b780a2bf4f96ab6] drm/radeon/kms: don't use 0 bpc for adjusting hdmi clock
  git bisect skip 06e4cd64174b48345cbd99179b780a2bf4f96ab6
  # skip: [1fbe6f625f69e48c4001051dc1431afc704acfaa] Merge tag 'v3.2-rc6' of /home/airlied/devel/kernel/linux-2.6 into drm-core-next
  git bisect skip 1fbe6f625f69e48c4001051dc1431afc704acfaa

Linux version 3.2.0-rc6-bisect-00099-g1fbe6f6 (nick@artemis) (gcc version 4.5.3 (Gentoo 4.5.3-r2 p1.1, pie-0.4.7) ) #60 PREEMPT Sun Apr 22 12:04:36 EDT 2012
Command line: root=md:name=newroot console=ttyS0,115200n8
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007ffc0000 (usable)
 BIOS-e820: 000000007ffc0000 - 000000007ffd0000 (ACPI data)
 BIOS-e820: 000000007ffd0000 - 0000000080000000 (ACPI NVS)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ff7c0000 - 0000000100000000 (reserved)
NX (Execute Disable) protection: active
DMI 2.3 present.
AGP bridge at 00:00:00
Aperture from AGP @ f8000000 old size 32 MB
Aperture size 4096 MB (APSIZE 0) is not right, using settings from NB
Aperture from AGP @ f8000000 size 32 MB (APSIZE 0)
last_pfn = 0x7ffc0 max_arch_pfn = 0x400000000
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
found SMP MP-table at [ffff8800000ff780] ff780
init_memory_mapping: 0000000000000000-000000007ffc0000
RAMDISK: 37c9c000 - 37ff0000
ACPI: RSDP 00000000000f9cb0 00021 (v02 ACPIAM)
ACPI: XSDT 000000007ffc0100 0003C (v01 A M I  OEMXSDT  01000618 MSFT 00000097)
ACPI: FACP 000000007ffc0290 000F4 (v03 A M I  OEMFACP  01000618 MSFT 00000097)
ACPI Warning: 32/64X length mismatch in Gpe1Block: 0/32 (20110623/tbfadt-529)
ACPI Warning: Optional field Gpe1Block has zero address or length: 0x00000000000044A0/0x0 (20110623/tbfadt-560)
ACPI: DSDT 000000007ffc0400 04524 (v01  A0055 A0055003 00000003 INTL 02002026)
ACPI: FACS 000000007ffd0000 00040
ACPI: APIC 000000007ffc0390 00068 (v01 A M I  OEMAPIC  01000618 MSFT 00000097)
ACPI: OEMB 000000007ffd0040 00041 (v01 A M I  OEMBIOS  01000618 MSFT 00000097)
Zone PFN ranges:
  DMA      0x00000010 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   empty
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000010 -> 0x0000009f
    0: 0x00000100 -> 0x0007ffc0
Nvidia board detected. Ignoring ACPI timer override.
If you got timer trouble try acpi_use_timer_override
ACPI: PM-Timer IO Port: 0x4008
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 17, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: BIOS IRQ0 pin2 override ignored.
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 80000000 (gap: 80000000:7ec00000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 516939
Kernel command line: root=md:name=newroot console=ttyS0,115200n8
PID hash table entries: 4096 (order: 3, 32768 bytes)
Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Checking aperture...
AGP bridge at 00:00:00
Aperture from AGP @ f8000000 old size 32 MB
Aperture size 4096 MB (APSIZE 0) is not right, using settings from NB
Aperture from AGP @ f8000000 size 32 MB (APSIZE 0)
Node 0: aperture @ f8000000 size 64 MB
Memory: 2053596k/2096896k available (3110k kernel code, 452k absent, 42848k reserved, 3386k data, 496k init)
NR_IRQS:4352 nr_irqs:256 16
Extended CMOS year: 2000
Console: colour VGA+ 80x25
console [ttyS0] enabled
kmemleak: Kernel memory leak detector disabled
Fast TSC calibration using PIT
Detected 2009.331 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 4018.66 BogoMIPS (lpj=2009331)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 256
mce: CPU supports 5 MCE banks
CPU: AMD Athlon(tm) 64 Processor 3200+ stepping 08
ACPI: Core revision 20110623
Performance Events: AMD PMU driver.
... version:                0
... bit width:              48
... generic registers:      4
... value mask:             0000ffffffffffff
... max period:             00007fffffffffff
... fixed-purpose events:   0
... event mask:             000000000000000f
MCE: In-kernel MCE decoding enabled.
..TIMER: vector=0x30 apic1=0 pin1=0 apic2=-1 pin2=-1
devtmpfs: initialized
NET: Registered protocol family 16
TOM: 0000000080000000 aka 2048M
ACPI: bus type pci registered
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: Added _OSI(Module Device)
ACPI: Added _OSI(Processor Device)
ACPI: Added _OSI(3.0 _SCP Extensions)
ACPI: Added _OSI(Processor Aggregator Device)
ACPI: Executed 1 blocks of module-level executable AML code
ACPI: Actual Package length (234) is larger than NumElements field (3), truncated

ACPI: Interpreter enabled
ACPI: (supports S0 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: Power Resource [ISAV] (on)
ACPI: No dock devices found.
PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
pci 0000:00:0b.0: PCI bridge to [bus 01-01]
pci 0000:00:0e.0: PCI bridge to [bus 02-02]
 pci0000:00: Unable to request _OSC control (_OSC support mask: 0x18)
ACPI: PCI Interrupt Link [LNKA] (IRQs 16 17 18 19) *10
ACPI: PCI Interrupt Link [LNKB] (IRQs 16 17 18 19) *9
ACPI: PCI Interrupt Link [LNKC] (IRQs 16 17 18 19) *7
ACPI: PCI Interrupt Link [LNKD] (IRQs 16 17 18 19) *9
ACPI: PCI Interrupt Link [LNKE] (IRQs 16 17 18 19) *11
ACPI: PCI Interrupt Link [LUS0] (IRQs 20 21 22) *5
ACPI: PCI Interrupt Link [LUS1] (IRQs 20 21 22) *9
ACPI: PCI Interrupt Link [LUS2] (IRQs 20 21 22) *10
ACPI: PCI Interrupt Link [LKLN] (IRQs 20 21 22) *3
ACPI: PCI Interrupt Link [LAUI] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [LKMO] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [LKSM] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [LTID] (IRQs 20 21 22) *0
ACPI: PCI Interrupt Link [LTIE] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [LATA] (IRQs 20 21 22) *14
vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
vgaarb: bridge control possible 0000:01:00.0
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
wmi: Mapper loaded
PCI: Using ACPI for IRQ routing
pci 0000:00:00.0: address space collision: [mem 0xf8000000-0xfbffffff pref] conflicts with GART [mem 0xf8000000-0xfbffffff]
pnp: PnP ACPI init
ACPI: bus type pnp registered
system 00:06: [io  0x0190-0x0193] has been reserved
system 00:06: [io  0x04d0-0x04d1] has been reserved
system 00:06: [io  0x4000-0x40ff window] has been reserved
system 00:06: [io  0x4400-0x44ff window] has been reserved
system 00:06: [io  0x4800-0x48ff window] has been reserved
system 00:07: [mem 0xfec00000-0xfec00fff] could not be reserved
system 00:07: [mem 0xfee00000-0xfeefffff] could not be reserved
system 00:07: [mem 0xff780000-0xff7bffff] has been reserved
system 00:08: [io  0x0480-0x0487] has been reserved
system 00:08: [io  0x0d00-0x0d07] has been reserved
pnp 00:0a: disabling [mem 0x00000000-0x0009ffff] because it overlaps 0000:00:00.0 BAR 0 [mem 0x00000000-0x03ffffff pref]
pnp 00:0a: disabling [mem 0x000c0000-0x000dffff] because it overlaps 0000:00:00.0 BAR 0 [mem 0x00000000-0x03ffffff pref]
pnp 00:0a: disabling [mem 0x000e0000-0x000fffff] because it overlaps 0000:00:00.0 BAR 0 [mem 0x00000000-0x03ffffff pref]
pnp 00:0a: disabling [mem 0x00100000-0x7fffffff] because it overlaps 0000:00:00.0 BAR 0 [mem 0x00000000-0x03ffffff pref]
system 00:0a: [mem 0xff7c0000-0xffffffff] has been reserved
pnp: PnP ACPI: found 11 devices
ACPI: ACPI bus type pnp unregistered
Switching to clocksource acpi_pm
pci 0000:00:0b.0: PCI bridge to [bus 01-01]
pci 0000:00:0b.0:   bridge window [mem 0xfc800000-0xfe8fffff]
pci 0000:00:0b.0:   bridge window [mem 0xd4700000-0xf46fffff pref]
pci 0000:00:0e.0: PCI bridge to [bus 02-02]
pci 0000:00:0e.0:   bridge window [io  0xa000-0xcfff]
pci 0000:00:0e.0:   bridge window [mem 0xfe900000-0xfeafffff]
NET: Registered protocol family 2
IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
UDP hash table entries: 1024 (order: 3, 32768 bytes)
UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes)
NET: Registered protocol family 1
Trying to unpack rootfs image as initramfs...
Freeing initrd memory: 3408k freed
agpgart-amd64 0000:00:00.0: AGP bridge [10de/00e1]
agpgart-amd64 0000:00:00.0: aperture size 4096 MB is not right, using settings from NB
agpgart-amd64 0000:00:00.0: setting up Nforce3 AGP
agpgart-amd64 0000:00:00.0: AGP aperture is 64M @ 0xf8000000
msgmni has been set to 4017
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
ACPI: Power Button [PWRB]
input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
ACPI: Power Button [PWRF]
ACPI: processor limited to max C-state 1
Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Real Time Clock Driver v1.12b
Linux agpgart interface v0.103
[drm] Initialized drm 1.1.0 20060810
ACPI: PCI Interrupt Link [LNKE] enabled at IRQ 19
nouveau 0000:01:00.0: PCI INT A -> Link[LNKE] -> GSI 19 (level, low) -> IRQ 19
[drm] nouveau 0000:01:00.0: Detected an NV30 generation card (0x436200a1)
[drm] nouveau 0000:01:00.0: Attempting to load BIOS image from PRAMIN
[drm] nouveau 0000:01:00.0: ... appears to be valid
[drm] nouveau 0000:01:00.0: BMP BIOS found
[drm] nouveau 0000:01:00.0: BMP version 5.40
[drm] nouveau 0000:01:00.0: Bios version 04.36.20.21
[drm] nouveau 0000:01:00.0: Found Display Configuration Block version 2.2
[drm] nouveau 0000:01:00.0: Raw DCB entry 0: 01000300 00009c40
[drm] nouveau 0000:01:00.0: Raw DCB entry 1: 02010310 00009c40
[drm] nouveau 0000:01:00.0: Raw DCB entry 2: 04000302 00000000
[drm] nouveau 0000:01:00.0: Raw DCB entry 3: 02020321 00000303
[drm] nouveau 0000:01:00.0: Loading NV17 power sequencing microcode
[drm] nouveau 0000:01:00.0: Parsing VBIOS init table 0 at offset 0xF01D
[drm] nouveau 0000:01:00.0: Parsing VBIOS init table 1 at offset 0xF4E1
[drm] nouveau 0000:01:00.0: Parsing VBIOS init table 2 at offset 0xF723
[drm] nouveau 0000:01:00.0: Parsing VBIOS init table 3 at offset 0xF896
[drm] nouveau 0000:01:00.0: Parsing VBIOS init table 4 at offset 0xF8B3
[drm] nouveau 0000:01:00.0: Parsing VBIOS init table 5 at offset 0xF8D0
[drm] nouveau 0000:01:00.0: Parsing VBIOS init table 6 at offset 0xF959
Apr 22 16:12:33 modprobe: FATAL: Could not open '/lib/modules/3.2.0-rc6-bisect-00099-g1fbe6f6/kernel/drivers/hwmon/lm90.ko': No such file or directory

[drm] nouveau 0000:01:00.0: 0 available performance level(s)
[drm] nouveau 0000:01:00.0: c: core 425MHz memory 501MHz voltage 1350mV
[TTM] Zone  kernel: Available graphics memory: 1028502 kiB.
[TTM] Initializing pool allocator.
[TTM] Initializing DMA pool allocator.
[drm] nouveau 0000:01:00.0: Detected 256MiB VRAM
agpgart-amd64 0000:00:00.0: AGP 3.0 bridge
agpgart: swapper tried to set rate=x12. Setting to AGP3 x8 mode.
agpgart-amd64 0000:00:00.0: putting AGP V3 device into 8x mode
nouveau 0000:01:00.0: putting AGP V3 device into 8x mode
[drm] nouveau 0000:01:00.0: 64 MiB GART (aperture)
[drm] nouveau 0000:01:00.0: Saving VGA fonts
BUG: unable to handle kernel NULL pointer dereference at           (null)
IP: [<ffffffff811acbfa>] nouveau_ttm_tt_populate+0xb9/0x194
PGD 0 
Oops: 0002 [#1] PREEMPT 
CPU 0 
Modules linked in:

Pid: 1, comm: swapper Not tainted 3.2.0-rc6-bisect-00099-g1fbe6f6 #60 ASUSTek Computer Inc. K8N-E-Deluxe/'K8N-E-Deluxe'
RIP: 0010:[<ffffffff811acbfa>]  [<ffffffff811acbfa>] nouveau_ttm_tt_populate+0xb9/0x194
RSP: 0018:ffff88007d05d7e0  EFLAGS: 00010202
RAX: 000000007c061000 RBX: ffff88007d34cec0 RCX: 0000000000001000
RDX: ffffea0001b21558 RSI: ffff88007d05d8f0 RDI: ffffffff8149508d
RBP: ffff88007d05d820 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000001 R11: dead000000100100 R12: 0000000000000000
R13: 0000000000000000 R14: ffff88007d184000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffffffff8161c000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 000000007d349000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 1, threadinfo ffff88007d05c000, task ffff88007d050ac0)
Stack:
 ffffffff816520b8 0000000001b63980 00000000000000c0 ffff88007d34cec0
 ffff88007c2002f8 ffff88007d05d8f0 ffff88007d05d800 0000000000000000
 ffff88007d05d850 ffffffff8119c59c ffff88007c2002f8 ffff88007d05d8f0
Call Trace:
 [<ffffffff8119c59c>] ttm_tt_bind+0x2c/0x4f
 [<ffffffff8119e23c>] ttm_bo_handle_move_mem+0x110/0x29e
 [<ffffffff8119f07e>] ttm_bo_move_buffer+0xe9/0x124
 [<ffffffff81191ecd>] ? drm_mm_kmalloc+0x28/0xa5
 [<ffffffff8119f16b>] ttm_bo_validate+0xb2/0xed
 [<ffffffff8119f506>] ttm_bo_init+0x360/0x399
 [<ffffffff811ad163>] nouveau_bo_new+0x220/0x23a
 [<ffffffff811acd46>] ? nouveau_ttm_tt_create+0x71/0x71
 [<ffffffff811c8ae3>] ? nouveau_ramht_insert+0x225/0x32e
 [<ffffffff811afce4>] nouveau_gem_new+0x55/0xe5
 [<ffffffff811ab0b5>] ? nouveau_gpuobj_channel_init+0x637/0x68a
 [<ffffffff811ab4de>] nouveau_notifier_init_channel+0x5f/0x134
 [<ffffffff811a7945>] nouveau_channel_alloc+0x1fd/0x568
 [<ffffffff811a6569>] nouveau_card_init+0x134c/0x14be
 [<ffffffff811a6d93>] nouveau_load+0x5d8/0x61f
 [<ffffffff8118f723>] drm_get_pci_dev+0x158/0x25d
 [<ffffffff81301f3e>] nouveau_pci_probe+0x10/0x12
 [<ffffffff8111854b>] local_pci_probe+0x12/0x16
 [<ffffffff811187b5>] pci_device_probe+0x65/0x96
 [<ffffffff810dedf1>] ? sysfs_create_link+0xe/0x10
 [<ffffffff81224ae1>] driver_probe_device+0xa3/0x131
 [<ffffffff81224bc7>] __driver_attach+0x58/0x7c
 [<ffffffff81224b6f>] ? driver_probe_device+0x131/0x131
 [<ffffffff81223dd4>] bus_for_each_dev+0x51/0x7d
 [<ffffffff812247e4>] driver_attach+0x19/0x1b
 [<ffffffff81224470>] bus_add_driver+0xb2/0x206
 [<ffffffff81224f1a>] driver_register+0x96/0x103
 [<ffffffff81118a24>] __pci_register_driver+0x47/0xb3
 [<ffffffff8118f8ad>] drm_pci_init+0x85/0xea
 [<ffffffff8167c30f>] ? ttm_init+0x62/0x62
 [<ffffffff8167c30f>] ? ttm_init+0x62/0x62
 [<ffffffff8167c35e>] nouveau_init+0x4f/0x51
 [<ffffffff810002e2>] do_one_initcall+0x78/0x126
 [<ffffffff8165ab3a>] kernel_init+0x8b/0x10b
 [<ffffffff81025bd9>] ? schedule_tail+0x16/0x3d
 [<ffffffff81306cc4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8165aaaf>] ? start_kernel+0x31d/0x31d
 [<ffffffff81306cc0>] ? gs_change+0xb/0xb
Code: 88 00 00 00 48 8b 80 70 01 00 00 48 85 c0 75 0b eb 02 31 ff 48 8b 05 66 c1 46 00 45 31 c9 45 31 c0 31 d2 b9 00 10 00 00 ff 50 10 
 89 07 48 8b 43 50 4a 8b 34 e8 49 8b 86 c0 02 00 00 48 89 c7 
RIP  [<ffffffff811acbfa>] nouveau_ttm_tt_populate+0xb9/0x194
 RSP <ffff88007d05d7e0>
CR2: 0000000000000000
---[ end trace eb6d24f9d33e5957 ]---
Kernel panic - not syncing: Attempted to kill init!
Pid: 1, comm: swapper Tainted: G      D      3.2.0-rc6-bisect-00099-g1fbe6f6 #60
Call Trace:
 [<ffffffff81303729>] panic+0x9a/0x19e
 [<ffffffff8102c76b>] do_exit+0x8e/0x68c
 [<ffffffff8102b0b7>] ? kmsg_dump+0xe5/0xf6
 [<ffffffff8100487c>] oops_end+0x9d/0xa5
 [<ffffffff8101c951>] no_context+0x1fd/0x20c
 [<ffffffff8101e511>] ? change_page_attr_set_clr+0x265/0x335
 [<ffffffff8101cb10>] __bad_area_nosemaphore+0x1b0/0x1d0
 [<ffffffff8101cb3e>] bad_area_nosemaphore+0xe/0x10
 [<ffffffff8101ced9>] do_page_fault+0x173/0x36e
 [<ffffffff810312f7>] ? ns_capable+0x43/0x58
 [<ffffffff8119c499>] ? ttm_mem_global_alloc_zone.clone.3+0x126/0x148
 [<ffffffff8119c51e>] ? ttm_mem_global_alloc_page+0x50/0x52
 [<ffffffff81305b5f>] page_fault+0x1f/0x30
 [<ffffffff811acbfa>] ? nouveau_ttm_tt_populate+0xb9/0x194
 [<ffffffff8119c59c>] ttm_tt_bind+0x2c/0x4f
 [<ffffffff8119e23c>] ttm_bo_handle_move_mem+0x110/0x29e
 [<ffffffff8119f07e>] ttm_bo_move_buffer+0xe9/0x124
 [<ffffffff81191ecd>] ? drm_mm_kmalloc+0x28/0xa5
 [<ffffffff8119f16b>] ttm_bo_validate+0xb2/0xed
 [<ffffffff8119f506>] ttm_bo_init+0x360/0x399
 [<ffffffff811ad163>] nouveau_bo_new+0x220/0x23a
 [<ffffffff811acd46>] ? nouveau_ttm_tt_create+0x71/0x71
 [<ffffffff811c8ae3>] ? nouveau_ramht_insert+0x225/0x32e
 [<ffffffff811afce4>] nouveau_gem_new+0x55/0xe5
 [<ffffffff811ab0b5>] ? nouveau_gpuobj_channel_init+0x637/0x68a
 [<ffffffff811ab4de>] nouveau_notifier_init_channel+0x5f/0x134
 [<ffffffff811a7945>] nouveau_channel_alloc+0x1fd/0x568
 [<ffffffff811a6569>] nouveau_card_init+0x134c/0x14be
 [<ffffffff811a6d93>] nouveau_load+0x5d8/0x61f
 [<ffffffff8118f723>] drm_get_pci_dev+0x158/0x25d
 [<ffffffff81301f3e>] nouveau_pci_probe+0x10/0x12
 [<ffffffff8111854b>] local_pci_probe+0x12/0x16
 [<ffffffff811187b5>] pci_device_probe+0x65/0x96
 [<ffffffff810dedf1>] ? sysfs_create_link+0xe/0x10
 [<ffffffff81224ae1>] driver_probe_device+0xa3/0x131
 [<ffffffff81224bc7>] __driver_attach+0x58/0x7c
 [<ffffffff81224b6f>] ? driver_probe_device+0x131/0x131
 [<ffffffff81223dd4>] bus_for_each_dev+0x51/0x7d
 [<ffffffff812247e4>] driver_attach+0x19/0x1b
 [<ffffffff81224470>] bus_add_driver+0xb2/0x206
 [<ffffffff81224f1a>] driver_register+0x96/0x103
 [<ffffffff81118a24>] __pci_register_driver+0x47/0xb3
 [<ffffffff8118f8ad>] drm_pci_init+0x85/0xea
 [<ffffffff8167c30f>] ? ttm_init+0x62/0x62
 [<ffffffff8167c30f>] ? ttm_init+0x62/0x62
 [<ffffffff8167c35e>] nouveau_init+0x4f/0x51
 [<ffffffff810002e2>] do_one_initcall+0x78/0x126
 [<ffffffff8165ab3a>] kernel_init+0x8b/0x10b
 [<ffffffff81025bd9>] ? schedule_tail+0x16/0x3d
 [<ffffffff81306cc4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8165aaaf>] ? start_kernel+0x31d/0x31d
 [<ffffffff81306cc0>] ? gs_change+0xb/0xb

Cheers,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)

