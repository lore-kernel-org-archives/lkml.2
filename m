Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757902Ab2IRKkV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 06:40:21 -0400
Received: from 217-155-41-104.dsl.in-addr.zen.co.uk ([217.155.41.104]:60152
	"EHLO centos1.newflow.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752678Ab2IRKkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 06:40:18 -0400
Message-ID: <50584F90.2000606@mimc.co.uk>
Date: Tue, 18 Sep 2012 11:40:16 +0100
From: Mark Jackson <mpfj-list@mimc.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: 0.5sec delay when ttyO0 is enabled
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm using a BeagleBone, and the linux kernel from Koen Kooi (https://github.com/koenkooi/linux.git).

I have noticed there is a 0.5sec delay between OMAP UART0 being initialised and the console being
enabled.

I'll dig a bit deeper, but can anyone shed light on what the delay is ?

Can this delay be removed ?

My total boot time is only 1.3sec, so a 0.5sec delay is quite significant !?!

Below is the first portion of my boot log.

Thanks for any advice
Mark JACKSON
---
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.2.28+ (mpfj@mpfj-nanobone) (gcc version 4.5.4 (Buildroot
2012.08-git-00388-g7019407) ) #20 Thu Sep 13 16:56:56 BST 2012
[    0.000000] CPU: ARMv7 Processor [413fc082] revision 2 (ARMv7), cr=50c53c7d
[    0.000000] CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing instruction cache
[    0.000000] Machine: am335xevm
[    0.000000] Memory policy: ECC disabled, Data cache writeback
[    0.000000] AM335X ES1.0 (sgx neon )
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 65024
[    0.000000] Kernel command line: console=ttyO0,115200n8 root=/dev/mmcblk0p2 ro rootfstype=ext2
rootwait ip=none
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Memory: 256MB = 256MB total
[    0.000000] Memory: 253868k/253868k available, 8276k reserved, 0K highmem
[    0.000000] Virtual kernel memory layout:
[    0.000000]     vector  : 0xffff0000 - 0xffff1000   (   4 kB)
[    0.000000]     fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
[    0.000000]     vmalloc : 0xd0800000 - 0xff000000   ( 744 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xd0000000   ( 256 MB)
[    0.000000]     modules : 0xbf800000 - 0xc0000000   (   8 MB)
[    0.000000]       .text : 0xc0008000 - 0xc04ddadc   (4951 kB)
[    0.000000]       .init : 0xc04de000 - 0xc0517000   ( 228 kB)
[    0.000000]       .data : 0xc0518000 - 0xc056e3a8   ( 345 kB)
[    0.000000]        .bss : 0xc056e3cc - 0xc05d8a54   ( 426 kB)
[    0.000000] NR_IRQS:410 nr_irqs:410 410
[    0.000000] IRQ: Found an INTC at 0xfa200000 (revision 5.0) with 128 interrupts
[    0.000000] Total of 128 interrupts on 1 active controller
[    0.000000] OMAP clockevent source: GPTIMER2 at 24000000 Hz
[    0.000000] OMAP clocksource: GPTIMER1 at 32768 Hz
[    0.000000] sched_clock: 32 bits at 32kHz, resolution 30517ns, wraps every 131071999ms
[    0.000000] Console: colour dummy device 80x30
[    0.000183] Calibrating delay loop... 498.89 BogoMIPS (lpj=2494464)
[    0.058166] pid_max: default: 32768 minimum: 301
[    0.058319] Security Framework initialized
[    0.058410] Mount-cache hash table entries: 512
[    0.058837] Initializing cgroup subsys cpuacct
[    0.058898] Initializing cgroup subsys devices
[    0.058898] Initializing cgroup subsys freezer
[    0.058990] CPU: Testing write buffer coherency: ok
[    0.060180] devtmpfs: initialized
[    0.080780] omap_hwmod: gfx: failed to hardreset
[    0.097503] omap_hwmod: pruss: failed to hardreset
[    0.098114] print_constraints: dummy:
[    0.098419] NET: Registered protocol family 16
[    0.099731] OMAP GPIO hardware version 0.1
[    0.101043] omap_mux_init: Add partition: #1: core, flags: 0
[    0.102661]  omap_i2c.1: alias fck already exists
[    0.103057] hw-breakpoint: debug architecture 0x4 unsupported.
[    0.103240]  omap2_mcspi.1: alias fck already exists
[    0.103393]  omap2_mcspi.2: alias fck already exists
[    0.103607]  edma.0: alias fck already exists
[    0.103637]  edma.0: alias fck already exists
[    0.103668]  edma.0: alias fck already exists
[    0.103759] cape: pcm register
[    0.114685] bio: create slab <bio-0> at 0
[    0.116027] SCSI subsystem initialized
[    0.117004] usbcore: registered new interface driver usbfs
[    0.117156] usbcore: registered new interface driver hub
[    0.117340] usbcore: registered new device driver usb
[    0.117523] musb-ti81xx musb-ti81xx: musb0, board_mode=0x13, plat_mode=0x3
[    0.117675] musb-ti81xx musb-ti81xx: musb1, board_mode=0x13, plat_mode=0x1
[    0.118316] omap_i2c omap_i2c.1: bus 1 rev2.4.0 at 100 kHz
[    0.119598] Advanced Linux Sound Architecture Driver Version 1.0.24.
[    0.120239] Switching to clocksource gp timer
[    0.148681] musb-hdrc: version 6.0, ?dma?, otg (peripheral+host)
[    0.148895] musb-hdrc musb-hdrc.0: dma type: pio
[    0.149078] MUSB0 controller's USBSS revision = 4ea20800
[    0.149627] musb-hdrc musb-hdrc.0: USB OTG mode controller at d081c000 using PIO, IRQ 18
[    0.149932] musb-hdrc musb-hdrc.1: dma type: pio
[    0.150115] MUSB1 controller's USBSS revision = 4ea20800
[    0.150268] musb-hdrc musb-hdrc.1: MUSB HDRC host driver
[    0.150451] musb-hdrc musb-hdrc.1: new USB bus registered, assigned bus number 1
[    0.150604] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.150634] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.150665] usb usb1: Product: MUSB HDRC host driver
[    0.150665] usb usb1: Manufacturer: Linux 3.2.28+ musb-hcd
[    0.150695] usb usb1: SerialNumber: musb-hdrc.1
[    0.151519] hub 1-0:1.0: USB hub found
[    0.151550] hub 1-0:1.0: 1 port detected
[    0.152099] musb-hdrc musb-hdrc.1: USB Host mode controller at d081e800 using PIO, IRQ 19
[    0.152557] NET: Registered protocol family 2
[    0.152801] IP route cache hash table entries: 2048 (order: 1, 8192 bytes)
[    0.153289] TCP established hash table entries: 8192 (order: 4, 65536 bytes)
[    0.153503] TCP bind hash table entries: 8192 (order: 3, 32768 bytes)
[    0.153656] TCP: Hash tables configured (established 8192 bind 8192)
[    0.153656] TCP reno registered
[    0.153686] UDP hash table entries: 256 (order: 0, 4096 bytes)
[    0.153717] UDP-Lite hash table entries: 256 (order: 0, 4096 bytes)
[    0.154052] NET: Registered protocol family 1
[    0.154449] RPC: Registered named UNIX socket transport module.
[    0.154479] RPC: Registered udp transport module.
[    0.154479] RPC: Registered tcp transport module.
[    0.154510] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.156555] audit: initializing netlink socket (disabled)
[    0.156616] type=2000 audit(0.150:1): initialized
[    0.158172] VFS: Disk quotas dquot_6.5.2
[    0.158264] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.159545] msgmni has been set to 495
[    0.161010] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.161041] io scheduler noop registered
[    0.161071] io scheduler deadline registered
[    0.161132] io scheduler cfq registered (default)
[    0.162231] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.163848] omap_uart.0: ttyO0 at MMIO 0x44e09000 (irq = 72) is a OMAP UART0
[    0.757232] console [ttyO0] enabled
[    0.761535] omap_uart.1: ttyO1 at MMIO 0x48022000 (irq = 73) is a OMAP UART1
[    0.769409] omap_uart.2: ttyO2 at MMIO 0x48024000 (irq = 74) is a OMAP UART2
[    0.777282] omap_uart.3: ttyO3 at MMIO 0x481a6000 (irq = 44) is a OMAP UART3
[    0.785156] omap_uart.4: ttyO4 at MMIO 0x481a8000 (irq = 45) is a OMAP UART4
[    0.792999] omap_uart.5: ttyO5 at MMIO 0x481aa000 (irq = 46) is a OMAP UART5
...
