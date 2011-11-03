Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761Ab1KCW6W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 18:58:22 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:44874 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349Ab1KCW6S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 18:58:18 -0400
MIME-Version: 1.0
In-Reply-To: <20111101010242.003738e9@lxorguk.ukuu.org.uk>
References: <1319602564-19162-1-git-send-email-paul.s.schilling@gmail.com>
	<20111027084310.2b7da753@pyx>
	<CAC=G6sz=PkDoODYh4beT_eRhkm+ZhUxtLnrBXPPuFJW3n+6Vcg@mail.gmail.com>
	<20111101010242.003738e9@lxorguk.ukuu.org.uk>
Date: Thu, 3 Nov 2011 17:58:17 -0500
Message-ID: <CAC=G6sxZ10ben3R5X2aKGi6q3a68+c0CO+mG=+kUeUvKoRbOJg@mail.gmail.com>
Subject: Re: [PATCH 02/15] ATA : vortex86 : fix vortex86dx/sx hardware CRC bug.
From: Paul Schilling <paul.s.schilling@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jeff Garzik <jgarzik@pobox.com>, "David S. Miller" <davem@davemloft.net>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found two different versions of the Vortex86DX one with
RDC_D1011 and the other RDC_D1012.

I tested the RDC_D1012 with the pata_rdc driver with
MWDMA2 turned on and this is the error I received.
the actual error is near the bottom of the dmesg.
I am pretty certain that I received the same error
when I used a RDC_D1011 with the ite_821x driver
with MWDMA2 turned on. I no longer have access
to a Vortex86DX with the RDC_D1011.

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.1.0-vortex (root@erased) (gcc version
4.4.3 (Ubuntu 4.4.3-4ubuntu5) ) #1 PREEMPT Thu Nov 3 14:30:13 CDT 2011
[    0.000000] CPU: vendor_id 'Vortex86 SoC' unknown, using generic init.
[    0.000000] CPU: Your system may be unstable.
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 0000000020000000 (usable)
[    0.000000]  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
[    0.000000] Notice: NX (Execute Disable) protection missing in CPU!
[    0.000000] DMI not present or invalid.
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000
(usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] last_pfn = 0x20000 max_arch_pfn = 0x100000
[    0.000000] initial memory mapped : 0 - 00c00000
[    0.000000] Base memory trampoline at [c009c000] 9c000 size 12288
[    0.000000] init_memory_mapping: 0000000000000000-0000000020000000
[    0.000000]  0000000000 - 0020000000 page 4k
[    0.000000] kernel direct mapping tables up to 20000000 @ b7d000-c00000
[    0.000000] RAMDISK: 17b34000 - 18040000
[    0.000000] ACPI Error: A valid RSDP was not found (20110623/tbxfroot-219)
[    0.000000] 512MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 20000000
[    0.000000]   low ram: 0 - 20000000
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x00020000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x00020000
[    0.000000] On node 0 totalpages: 130959
[    0.000000] free_area_init_node: node 0, pgdat c083c200,
node_mem_map dfc00200
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3951 pages, LIFO batch:0
[    0.000000]   Normal zone: 992 pages used for memmap
[    0.000000]   Normal zone: 125984 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] No local APIC present or hardware disabled
[    0.000000] APIC: disable apic facility
[    0.000000] APIC: switched to apic NOOP
[    0.000000] nr_irqs_gsi: 16
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e4000
[    0.000000] PM: Registered nosave memory: 00000000000e4000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 20000000 (gap:
20000000:df000000)
[    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
[    0.000000] pcpu-alloc: [0] 0
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.
Total pages: 129935
[    0.000000] Kernel command line:
BOOT_IMAGE=/boot/vmlinuz-3.1.0-vortex
root=UUID=0b45b03b-8787-4759-9bd0-ef4a48ca6169 ro quiet
[    0.000000] PID hash table entries: 2048 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] allocated 2096896 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't
want memory cgroups
[    0.000000] Memory: 503100k/524288k available (5069k kernel code,
20736k reserved, 2372k data, 568k init, 0k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffa2000 - 0xfffff000   ( 372 kB)
[    0.000000]     vmalloc : 0xe0800000 - 0xfffa0000   ( 503 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xe0000000   ( 512 MB)
[    0.000000]       .init : 0xc0845000 - 0xc08d3000   ( 568 kB)
[    0.000000]       .data : 0xc05f3532 - 0xc08447a0   (2372 kB)
[    0.000000]       .text : 0xc0100000 - 0xc05f3532   (5069 kB)
[    0.000000] Checking if this processor honours the WP bit even in
supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=15, HWalign=32, Order=0-3, MinObjects=0,
CPUs=1, Nodes=1
[    0.000000] NR_IRQS:2304 nr_irqs:256 16
[    0.000000] CPU 0 irqstacks, hard=df406000 soft=df408000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 1000.090 MHz processor.
[    0.008010] Calibrating delay loop (skipped), value calculated
using timer frequency.. 2000.18 BogoMIPS (lpj=4000360)
[    0.008053] pid_max: default: 32768 minimum: 301
[    0.008273] Security Framework initialized
[    0.008322] SELinux:  Disabled at boot.
[    0.008495] Mount-cache hash table entries: 512
[    0.012834] Initializing cgroup subsys cpuacct
[    0.012874] Initializing cgroup subsys memory
[    0.012972] Initializing cgroup subsys devices
[    0.012993] Initializing cgroup subsys freezer
[    0.013013] Initializing cgroup subsys net_cls
[    0.013228] CPU: Vortex86 SoC 05/02 stepping 02
[    0.013355] ftrace: allocating 21380 entries in 42 pages
[    0.020366] Performance Events:
[    0.024940] devtmpfs: initialized
[    0.027190] print_constraints: dummy:
[    0.027675] NET: Registered protocol family 16
[    0.029428] EISA bus registered
[    0.031049] PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=0
[    0.031071] PCI: Using configuration type 1 for base access
[    0.052745] bio: create slab <bio-0> at 0
[    0.053423] ACPI: Interpreter disabled.
[    0.054372] vgaarb: loaded
[    0.057676] SCSI subsystem initialized
[    0.058239] libata version 3.00 loaded.
[    0.058973] usbcore: registered new interface driver usbfs
[    0.059154] usbcore: registered new interface driver hub
[    0.059487] usbcore: registered new device driver usb
[    0.060905] PCI: Probing PCI hardware
[    0.060928] PCI: Probing PCI hardware (bus 00)
[    0.061252] pci 0000:00:00.0: [17f3:6021] type 0 class 0x000600
[    0.061411] pci 0000:00:02.0: [168c:0029] type 0 class 0x000280
[    0.061463] pci 0000:00:02.0: reg 10: [mem 0xfef90000-0xfef9ffff]
[    0.061569] pci 0000:00:02.0: PME# supported from D0 D3hot
[    0.061595] pci 0000:00:02.0: PME# disabled
[    0.061678] pci 0000:00:03.0: [18ca:0020] type 0 class 0x000300
[    0.061723] pci 0000:00:03.0: reg 10: [mem 0xf8000000-0xfbffffff pref]
[    0.061759] pci 0000:00:03.0: reg 14: [mem 0xfefc0000-0xfeffffff]
[    0.061794] pci 0000:00:03.0: reg 18: [io  0xdf80-0xdfff]
[    0.061875] pci 0000:00:03.0: supports D1 D2
[    0.061959] pci 0000:00:07.0: [17f3:6031] type 0 class 0x000601
[    0.062115] pci 0000:00:08.0: [17f3:6040] type 0 class 0x000200
[    0.062155] pci 0000:00:08.0: reg 10: [io  0xde00-0xdeff]
[    0.062190] pci 0000:00:08.0: reg 14: [mem 0xfefbb400-0xfefbb4ff]
[    0.062259] pci 0000:00:08.0: reg 30: [mem 0xfefa0000-0xfefaffff pref]
[    0.062352] pci 0000:00:0a.0: [17f3:6060] type 0 class 0x000c03
[    0.062392] pci 0000:00:0a.0: reg 10: [mem 0xfefb9000-0xfefb9fff]
[    0.062533] pci 0000:00:0a.1: [17f3:6061] type 0 class 0x000c03
[    0.062573] pci 0000:00:0a.1: reg 10: [mem 0xfefbb800-0xfefbb8ff]
[    0.062736] pci 0000:00:0b.0: [17f3:6060] type 0 class 0x000c03
[    0.062778] pci 0000:00:0b.0: reg 10: [mem 0xfefba000-0xfefbafff]
[    0.062919] pci 0000:00:0b.1: [17f3:6061] type 0 class 0x000c03
[    0.062960] pci 0000:00:0b.1: reg 10: [mem 0xfefbbc00-0xfefbbcff]
[    0.063113] pci 0000:00:0c.0: [17f3:1011] type 0 class 0x000101
[    0.063153] pci 0000:00:0c.0: reg 10: [io  0x0000-0x0007]
[    0.063187] pci 0000:00:0c.0: reg 14: [io  0x0000-0x0003]
[    0.063220] pci 0000:00:0c.0: reg 18: [io  0x0000-0x0007]
[    0.063254] pci 0000:00:0c.0: reg 1c: [io  0x0000-0x0003]
[    0.063287] pci 0000:00:0c.0: reg 20: [io  0xef00-0xef0f]
[    0.064234] vgaarb: device added:
PCI:0000:00:03.0,decodes=io+mem,owns=io+mem,locks=none
[    0.066351] pci 0000:00:07.0: default IRQ router [17f3:6031]
[    0.066483] PCI: pci_cache_line_size set to 32 bytes
[    0.066670] reserve RAM buffer: 000000000009fc00 - 000000000009ffff
[    0.067622] NetLabel: Initializing
[    0.067642] NetLabel:  domain hash size = 128
[    0.067657] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.067779] NetLabel:  unlabeled traffic allowed by default
[    0.068287] Switching to clocksource pit
[    0.097013] pnp: PnP ACPI: disabled
[    0.097040] PnPBIOS: Scanning system for PnP BIOS support...
[    0.097133] PnPBIOS: Found PnP BIOS installation structure at 0xc00f3ba0
[    0.097161] PnPBIOS: PnP BIOS version 1.0, entry 0xf0000:0x456a, dseg 0xf0000
[    0.097467] pnp 00:00: [mem 0x00000000-0x0009fbff]
[    0.097494] pnp 00:00: [mem 0x0009fc00-0x0009ffff]
[    0.097518] pnp 00:00: [mem 0x000e4000-0x000fffff]
[    0.097542] pnp 00:00: [mem 0x00100000-0x1fffffff]
[    0.097566] pnp 00:00: [mem 0xff000000-0xffffffff]
[    0.097903] system 00:00: [mem 0x00000000-0x0009fbff] could not be reserved
[    0.097936] system 00:00: [mem 0x0009fc00-0x0009ffff] could not be reserved
[    0.097967] system 00:00: [mem 0x000e4000-0x000fffff] could not be reserved
[    0.097997] system 00:00: [mem 0x00100000-0x1fffffff] could not be reserved
[    0.098028] system 00:00: [mem 0xff000000-0xffffffff] has been reserved
[    0.098062] system 00:00: Plug and Play BIOS device, IDs PNP0c01 (active)
[    0.098138] pnp 00:01: [io  0x0020-0x0021]
[    0.098161] pnp 00:01: [io  0x00a0-0x00a1]
[    0.098185] pnp 00:01: [irq 2]
[    0.098371] pnp 00:01: Plug and Play BIOS device, IDs PNP0000 (active)
[    0.098448] pnp 00:02: [dma 4]
[    0.098470] pnp 00:02: [io  0x0000-0x000f]
[    0.098493] pnp 00:02: [io  0x0080-0x0090]
[    0.098515] pnp 00:02: [io  0x0094-0x009f]
[    0.098537] pnp 00:02: [io  0x00c0-0x00de]
[    0.098724] pnp 00:02: Plug and Play BIOS device, IDs PNP0200 (active)
[    0.098801] pnp 00:03: [irq 0]
[    0.098823] pnp 00:03: [io  0x0040-0x0043]
[    0.099008] pnp 00:03: Plug and Play BIOS device, IDs PNP0100 (active)
[    0.099087] pnp 00:04: [irq 8]
[    0.099109] pnp 00:04: [io  0x0070-0x0071]
[    0.099296] pnp 00:04: Plug and Play BIOS device, IDs PNP0b00 (active)
[    0.099376] pnp 00:05: [irq 1]
[    0.099398] pnp 00:05: [io  0x0060]
[    0.099418] pnp 00:05: [io  0x0064]
[    0.099619] pnp 00:05: Plug and Play BIOS device, IDs PNP0303 (active)
[    0.099673] PNPBIOS fault.. attempting recovery.
[    0.099824] PnPBIOS: Warning! Your PnP BIOS caused a fatal error.
Attempting to continue
[    0.099938] PnPBIOS: You may need to reboot with the "pnpbios=off"
option to operate stably
[    0.100051] PnPBIOS: Check with your vendor for an updated BIOS
[    0.100146] PnPBIOS: get_dev_node: unexpected status 0x3a
[    0.100238] PnPBIOS: 6 nodes reported by PnP BIOS; 6 recorded by driver
[    0.121062] PCI: max bus depth: 0 pci_try_num: 1
[    0.121115] pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
[    0.121141] pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffff]
[    0.121512] NET: Registered protocol family 2
[    0.121970] IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
[    0.123583] TCP established hash table entries: 16384 (order: 5,
131072 bytes)
[    0.124150] TCP bind hash table entries: 16384 (order: 4, 65536 bytes)
[    0.124426] TCP: Hash tables configured (established 16384 bind 16384)
[    0.124446] TCP reno registered
[    0.124469] UDP hash table entries: 256 (order: 0, 4096 bytes)
[    0.124512] UDP-Lite hash table entries: 256 (order: 0, 4096 bytes)
[    0.125033] NET: Registered protocol family 1
[    0.125142] pci 0000:00:03.0: Boot video device
[    0.143774] PCI: CLS mismatch (64 != 16), using 32 bytes
[    0.164196] Trying to unpack rootfs image as initramfs...
[    1.142734] Freeing initrd memory: 5168k freed
[    1.165927] audit: initializing netlink socket (disabled)
[    1.166023] type=2000 audit(1320360344.160:1): initialized
[    1.262309] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    1.287011] VFS: Disk quotas dquot_6.5.2
[    1.287522] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    1.293969] fuse init (API version 7.17)
[    1.295051] msgmni has been set to 992
[    1.297252] Block layer SCSI generic (bsg) driver version 0.4
loaded (major 253)
[    1.297281] io scheduler noop registered
[    1.297299] io scheduler deadline registered
[    1.297357] io scheduler cfq registered (default)
[    1.299641] isapnp: Scanning for PnP cards...
[    1.653963] isapnp: No Plug & Play device found
[    1.654392] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.659068] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.663735] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    1.679204] brd: module loaded
[    1.686379] loop: module loaded
[    1.702633] Fixed MDIO Bus: probed
[    1.703179] tun: Universal TUN/TAP device driver, 1.6
[    1.703200] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    1.703547] PPP generic driver version 2.4.2
[    1.704652] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.704832] ehci_hcd 0000:00:0a.1: EHCI Host Controller
[    1.705230] ehci_hcd 0000:00:0a.1: new USB bus registered, assigned
bus number 1
[    1.727888] ehci_hcd 0000:00:0a.1: irq 9, io mem 0xfefbb800
[    1.739850] ehci_hcd 0000:00:0a.1: USB 2.0 started, EHCI 1.00
[    1.741043] hub 1-0:1.0: USB hub found
[    1.741096] hub 1-0:1.0: 2 ports detected
[    1.741546] ehci_hcd 0000:00:0b.1: EHCI Host Controller
[    1.741980] ehci_hcd 0000:00:0b.1: new USB bus registered, assigned
bus number 2
[    1.763878] ehci_hcd 0000:00:0b.1: irq 11, io mem 0xfefbbc00
[    1.775849] ehci_hcd 0000:00:0b.1: USB 2.0 started, EHCI 1.00
[    1.776908] hub 2-0:1.0: USB hub found
[    1.776955] hub 2-0:1.0: 2 ports detected
[    1.777472] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.777619] ohci_hcd 0000:00:0a.0: OHCI Host Controller
[    1.778046] ohci_hcd 0000:00:0a.0: new USB bus registered, assigned
bus number 3
[    1.778160] ohci_hcd 0000:00:0a.0: irq 7, io mem 0xfefb9000
[    1.862801] hub 3-0:1.0: USB hub found
[    1.862850] hub 3-0:1.0: 2 ports detected
[    1.863259] ohci_hcd 0000:00:0b.0: OHCI Host Controller
[    1.863689] ohci_hcd 0000:00:0b.0: new USB bus registered, assigned
bus number 4
[    1.863892] ohci_hcd 0000:00:0b.0: irq 10, io mem 0xfefba000
[    1.950905] hub 4-0:1.0: USB hub found
[    1.951010] hub 4-0:1.0: 2 ports detected
[    1.951478] uhci_hcd: USB Universal Host Controller Interface driver
[    1.952204] i8042: PNP: PS/2 Controller [PNP0303] at 0x60,0x64 irq 1
[    1.952228] i8042: PNP: PS/2 appears to have AUX port disabled, if
this is incorrect please boot with i8042.nopnp
[    1.952934] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.953913] mousedev: PS/2 mouse device common for all mice
[    1.954784] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    1.954862] rtc0: alarms up to one day, 114 bytes nvram
[    1.955908] device-mapper: uevent: version 1.0.3
[    1.956642] device-mapper: ioctl: 4.22.0-ioctl (2011-10-19)
initialised: dm-devel@redhat.com
[    1.957151] device-mapper: multipath: version 1.3.0 loaded
[    1.957178] device-mapper: multipath round-robin: version 1.0.0 loaded
[    1.958018] EISA: Probing bus 0 at eisa.0
[    1.958182] EISA: Detected 0 cards.
[    1.958225] cpuidle: using governor ladder
[    1.958244] cpuidle: using governor menu
[    1.960733] TCP cubic registered
[    1.962559] NET: Registered protocol family 10
[    1.967188] NET: Registered protocol family 17
[    1.967387] Registering the dns_resolver key type
[    1.967512] Using IPI Shortcut mode
[    1.968556] registered taskstats version 1
[    1.969274] rtc_cmos 00:04: setting system clock to 2011-11-03
22:45:46 UTC (1320360346)
[    1.969305] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    1.969324] EDD information not available.
[    1.970043] Freeing unused kernel memory: 568k freed
[    1.973325] Write protecting the kernel text: 5072k
[    1.973658] Write protecting the kernel read-only data: 2008k
[    2.113320] udev: starting version 151
[    2.114626] udevd (52): /proc/52/oom_adj is deprecated, please use
/proc/52/oom_score_adj instead.
[    2.171952] Switching to clocksource tsc
[    2.307975] usb 3-2: new full-speed USB device number 2 using ohci_hcd
[    2.727322] pata_rdc 0000:00:0c.0: version 0.01
[    2.727379] pata_rdc: Detected Vortex86DX Bug.
[    2.727394] pata_rdc: Disabling UDMA.
[    2.727646] pata_rdc 0000:00:0c.0: setting latency timer to 64
[    2.763662] scsi0 : pata_rdc
[    2.768570] scsi1 : pata_rdc
[    2.769069] ata1: PATA max MWDMA2 cmd 0x1f0 ctl 0x3f6 bmdma 0xef00 irq 14
[    2.769099] ata2: PATA max MWDMA2 cmd 0x170 ctl 0x376 bmdma 0xef08 irq 15
[    2.835952] usb 4-1: new full-speed USB device number 2 using ohci_hcd
[    2.940330] ata2.00: CFA: TRANSCEND, 20080820, max UDMA/66
[    2.940371] ata2.00: 7831152 sectors, multi 0: LBA
[    2.956125] ata2.00: configured for MWDMA2
[    2.956892] scsi 1:0:0:0: Direct-Access     ATA      TRANSCEND
  2008 PQ: 0 ANSI: 5
[    2.958033] sd 1:0:0:0: [sda] 7831152 512-byte logical blocks:
(4.00 GB/3.73 GiB)
[    2.958695] sd 1:0:0:0: [sda] Write Protect is off
[    2.958727] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.959010] sd 1:0:0:0: [sda] Write cache: disabled, read cache:
enabled, doesn't support DPO or FUA
[    2.960781] sd 1:0:0:0: Attached scsi generic sg0 type 0
[    2.965400] input: C-Media USB Audio Device    as
/devices/pci0000:00/0000:00:0a.0/usb3/3-2/3-2:1.3/input/input0
[    2.966734] generic-usb 0003:0D8C:0008.0001: input,hidraw0: USB HID
v1.00 Device [C-Media USB Audio Device   ] on
usb-0000:00:0a.0-2/input3
[    2.967685] usbcore: registered new interface driver usbhid
[    2.967711] usbhid: USB HID core driver
[    3.001011] hub 4-1:1.0: USB hub found
[    3.002823] hub 4-1:1.0: 3 ports detected
[    3.297800] usb 4-1.1: new full-speed USB device number 3 using ohci_hcd
[    3.428303] input: Lite-On Technology USB Productivity Option
Keyboard( has the hub in # 1 ) as
/devices/pci0000:00/0000:00:0b.0/usb4/4-1/4-1.1/4-1.1:1.0/input/input1
[    3.429731] generic-usb 0003:04B3:301B.0002: input,hidraw1: USB HID
v1.10 Keyboard [Lite-On Technology USB Productivity Option Keyboard(
has the hub in # 1 )] on usb-0000:00:0b.0-1.1/input0
[    3.443707] input: Lite-On Technology USB Productivity Option
Keyboard( has the hub in # 1 ) as
/devices/pci0000:00/0000:00:0b.0/usb4/4-1/4-1.1/4-1.1:1.1/input/input2
[    3.445122] generic-usb 0003:04B3:301B.0003: input,hidraw2: USB HID
v1.10 Device [Lite-On Technology USB Productivity Option Keyboard( has
the hub in # 1 )] on usb-0000:00:0b.0-1.1/input1
[    3.525794] usb 4-1.3: new low-speed USB device number 4 using ohci_hcd
[    3.647494] input: USB Optical Mouse as
/devices/pci0000:00/0000:00:0b.0/usb4/4-1/4-1.3/4-1.3:1.0/input/input3
[    3.650467] generic-usb 0003:04B3:310C.0004: input,hidraw3: USB HID
v1.11 Mouse [USB Optical Mouse] on usb-0000:00:0b.0-1.3/input0
[   33.822836] ata2: lost interrupt (Status 0x58)
[   33.824367] ata2: drained 2048 bytes to clear DRQ
[   33.824417] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[   33.824541] ata2.00: failed command: READ DMA
[   33.824665] ata2.00: cmd c8/00:08:00:00:00/00:00:00:00:00/e0 tag 0
dma 4096 in
[   33.824679]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[   33.824925] ata2.00: status: { DRDY }
[   33.825074] ata2: soft resetting link
[   33.987099] ata2.00: failed to IDENTIFY (INIT_DEV_PARAMS failed,
err_mask=0x80)
[   33.987128] ata2.00: revalidation failed (errno=-5)
[   38.978651] ata2: soft resetting link
[   39.142916] ata2.00: failed to IDENTIFY (INIT_DEV_PARAMS failed,
err_mask=0x80)
[   39.142945] ata2.00: revalidation failed (errno=-5)
[   44.134479] ata2: soft resetting link
[   44.298746] ata2.00: failed to IDENTIFY (INIT_DEV_PARAMS failed,
err_mask=0x80)
[   44.298774] ata2.00: revalidation failed (errno=-5)
[   44.298877] ata2.00: disabled
[   44.298920] ata2.00: device reported invalid CHS sector 0
[   44.299018] ata2: EH complete
[   44.299114] sd 1:0:0:0: [sda] Unhandled error code
[   44.299138] sd 1:0:0:0: [sda]  Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK
[   44.299170] sd 1:0:0:0: [sda] CDB: Read(10): 28 00 00 00 00 00 00 00 08 00
[   44.299243] end_request: I/O error, dev sda, sector 0
[   44.299351] Buffer I/O error on device sda, logical block 0
[   44.299708] sd 1:0:0:0: [sda] Unhandled error code
[   44.299733] sd 1:0:0:0: [sda]  Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK
[   44.299763] sd 1:0:0:0: [sda] CDB: Read(10): 28 00 00 00 00 00 00 00 08 00
[   44.299832] end_request: I/O error, dev sda, sector 0
[   44.299936] Buffer I/O error on device sda, logical block 0
[   44.300313] sd 1:0:0:0: [sda] Unhandled error code
[   44.300338] sd 1:0:0:0: [sda]  Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK
[   44.300368] sd 1:0:0:0: [sda] CDB: Read(10): 28 00 00 00 00 00 00 00 08 00
[   44.300438] end_request: I/O error, dev sda, sector 0
[   44.300542] Buffer I/O error on device sda, logical block 0
[   44.300703] ldm_validate_partition_table(): Disk read failed.
[   44.300932] sd 1:0:0:0: [sda] Unhandled error code
[   44.300956] sd 1:0:0:0: [sda]  Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK
[   44.300986] sd 1:0:0:0: [sda] CDB: Read(10): 28 00 00 00 00 00 00 00 08 00
[   44.301056] end_request: I/O error, dev sda, sector 0
[   44.301160] Buffer I/O error on device sda, logical block 0
[   44.301318]  sda: unable to read partition table
[   44.303020] sd 1:0:0:0: [sda] READ CAPACITY(16) failed
[   44.303047] sd 1:0:0:0: [sda]  Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK
[   44.303079] sd 1:0:0:0: [sda] Sense not available.
[   44.303423] sd 1:0:0:0: [sda] READ CAPACITY failed
[   44.303447] sd 1:0:0:0: [sda]  Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK
[   44.303477] sd 1:0:0:0: [sda] Sense not available.
[   44.303943] sd 1:0:0:0: [sda] Truncating mode parameter data from
8309 to 512 bytes
[   44.304095] sd 1:0:0:0: [sda] Got wrong page
[   44.304198] sd 1:0:0:0: [sda] Assuming drive cache: write through
[   44.304310] sd 1:0:0:0: [sda] Attached SCSI disk

On Mon, Oct 31, 2011 at 8:02 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Mon, 31 Oct 2011 14:07:45 -0500
> Paul Schilling <paul.s.schilling@gmail.com> wrote:
>
>> Hi,
>>
>> When I developed this patch for the Vortex86dx.  I recall trying many
>> combinations of udma and mwdma.  At the time I developed it, I came
>> to the conclusion that both udma and mwdma both failed with CRC
>> errors being reported.
>
> MWDMA does not have a CRC so that seems unlikely. If you can re-test and
> we can figure out what is going on that would be useful.
>
> Alan
>
