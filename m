Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263Ab1KUHoS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 02:44:18 -0500
Received: from metasoft.pl ([195.149.224.191]:58054 "EHLO smtp.metasoft.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753921Ab1KUHoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 02:44:15 -0500
X-clamdmail: clamdmail 0.18a
Message-ID: <4ECA0147.4020806@metasoft.pl>
Date: Mon, 21 Nov 2011 08:44:07 +0100
From: Rafal Prylowski <prylowski@metasoft.pl>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Mika Westerberg <mika.westerberg@iki.fi>
CC: linux-arm-kernel@lists.infradead.org, rmallon@gmail.com,
        vinod.koul@intel.com, broonie@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        hsweeten@visionengravers.com, dan.j.williams@intel.com, lrg@ti.com
Subject: Re: [PATCH v2 1/5] dmaengine: add ep93xx DMA support
References: <cover.1306662317.git.mika.westerberg@iki.fi> <3ea8d56034f25cbe3fd8a4c31d7d0d1540b6ac7e.1306662317.git.mika.westerberg@iki.fi> <4EC27EED.4030108@metasoft.pl> <20111116065512.GB2703@mwesterb-mobl.ger.corp.intel.com> <4EC374F0.8000400@metasoft.pl> <20111119123837.GA2711@mwesterb-mobl.ger.corp.intel.com>
In-Reply-To: <20111119123837.GA2711@mwesterb-mobl.ger.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

> I wasn't able to reproduce this but can you try if following patch helps? I'm
> not sure if it is correct but at least we get more information about the
> problem.
> 
> diff --git a/drivers/dma/ep93xx_dma.c b/drivers/dma/ep93xx_dma.c
> index 6181811..5b717da 100644
> --- a/drivers/dma/ep93xx_dma.c
> +++ b/drivers/dma/ep93xx_dma.c
> @@ -1106,6 +1106,7 @@ static int ep93xx_dma_terminate_all(struct ep93xx_dma_chan *edmac)
>  	spin_lock_irqsave(&edmac->lock, flags);
>  	/* First we disable and flush the DMA channel */
>  	edmac->edma->hw_shutdown(edmac);
> +	tasklet_kill(&edmac->tasklet);
>  	clear_bit(EP93XX_DMA_IS_CYCLIC, &edmac->flags);
>  	list_splice_init(&edmac->active, &list);
>  	list_splice_init(&edmac->queue, &list);
> 

It doesn't help:

Linux version 3.2.0-rc2EP-1+ (prylowski@server) (gcc version 4.4.2 (GCC) ) #1015
 Mon Nov 21 08:30:57 CET 2011
CPU: ARM920T [41129200] revision 0 (ARMv4T), cr=c0007177
CPU: VIVT data cache, VIVT instruction cache
Machine: Metasoft FonTel EP Board
Memory policy: ECC disabled, Data cache writeback
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 8128
Kernel command line: mtdparts=physmap-flash.0:128K(uboot),1152K(kernel),15104K(r
ootfs) root=/dev/mtdblock2 rootfstype=jffs2 console=ttyAM0 init=/sbin/init early
printk lpj=496128 panic=2
PID hash table entries: 128 (order: -3, 512 bytes)
Dentry cache hash table entries: 4096 (order: 2, 16384 bytes)
Inode-cache hash table entries: 2048 (order: 1, 8192 bytes)
Memory: 32MB = 32MB total
Memory: 27452k/27452k available, 5316k reserved, 0K highmem
Virtual kernel memory layout:
    vector  : 0xffff0000 - 0xffff1000   (   4 kB)
    fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
    vmalloc : 0xc2800000 - 0xfe800000   ( 960 MB)
    lowmem  : 0xc0000000 - 0xc2000000   (  32 MB)
    modules : 0xbf000000 - 0xc0000000   (  16 MB)
      .text : 0xc0008000 - 0xc029d000   (2644 kB)
      .init : 0xc029d000 - 0xc02b6000   ( 100 kB)
      .data : 0xc02b6000 - 0xc02d1440   ( 110 kB)
       .bss : 0xc02d1464 - 0xc02df51c   (  57 kB)
SLUB: Genslabs=13, HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
NR_IRQS:120
VIC @fefb0000: id 0x00041190, vendor 0x41
VIC @fefc0000: id 0x00041190, vendor 0x41
Console: colour dummy device 80x30
Calibrating delay loop (skipped) preset value.. 99.22 BogoMIPS (lpj=496128)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 512
CPU: Testing write buffer coherency: ok
NET: Registered protocol family 16
ep93xx clock: PLL1 running at 400 MHz, PLL2 at 192 MHz
ep93xx clock: FCLK 200 MHz, HCLK 100 MHz, PCLK 50 MHz
bio: create slab <bio-0> at 0
ep93xx-dma ep93xx-dma-m2p: EP93xx M2P DMA ready
ep93xx-dma ep93xx-dma-m2m: EP93xx M2M DMA ready
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
i2c-gpio i2c-gpio.0: using pins 49 (SDA) and 48 (SCL)
NET: Registered protocol family 2
IP route cache hash table entries: 1024 (order: 0, 4096 bytes)
TCP established hash table entries: 1024 (order: 1, 8192 bytes)
TCP bind hash table entries: 1024 (order: 0, 4096 bytes)
TCP: Hash tables configured (established 1024 bind 1024)
TCP reno registered
UDP hash table entries: 256 (order: 0, 4096 bytes)
UDP-Lite hash table entries: 256 (order: 0, 4096 bytes)
NET: Registered protocol family 1
JFFS2 version 2.2. (NAND) Â© 2001-2006 Red Hat, Inc.
msgmni has been set to 53
io scheduler noop registered
io scheduler deadline registered (default)
Serial: AMBA driver
apb:uart1: ttyAM0 at MMIO 0x808c0000 (irq = 52) is a AMBA
console [ttyAM0] enabled
apb:uart2: ttyAM1 at MMIO 0x808d0000 (irq = 54) is a AMBA
apb:uart3: ttyAM2 at MMIO 0x808e0000 (irq = 55) is a AMBA
fontel-pri fontel-pri: FonTel PRI initialized correctly.
ep93xx-ide ep93xx-ide: version 0.5
scsi0 : ep93xx-ide
ata1: PATA max UDMA/66 irq 40
physmap platform flash device: 01000000 at 60000000
physmap-flash.0: Found 1 x16 devices at 0x0 in 16-bit bank. Manufacturer ID 0x00
0001 Chip ID 0x002101
Amd/Fujitsu Extended Query Table at 0x0040
  Amd/Fujitsu Extended Query version 1.3.
number of CFI chips: 1
3 cmdlinepart partitions found on MTD device physmap-flash.0
Creating 3 MTD partitions on "physmap-flash.0":
0x000000000000-0x000000020000 : "uboot"
0x000000020000-0x000000140000 : "kernel"
0x000000140000-0x000001000000 : "rootfs"
ep93xx-spi ep93xx-spi.0: EP93xx SPI Controller at 0x808a0000 irq 53
ep93xx-eth version 0.1 loading
eth0: ep93xx on-chip ethernet, IRQ 39, aa:42:14:07:63:9d
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ep93xx-ohci ep93xx-ohci: EP93xx OHCI
ep93xx-ohci ep93xx-ohci: new USB bus registered, assigned bus number 1
ep93xx-ohci ep93xx-ohci: irq 56, io mem 0x80020000
ata1.00: HPA detected: current 234439535, native 234441648
ata1.00: ATA-7: ST9120822AS, 3.ALC, max UDMA/133
ata1.00: 234439535 sectors, multi 0: LBA48
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 3 ports detected
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
ata1.00: configured for UDMA/66
scsi 0:0:0:0: Direct-Access     ATA      ST9120822AS      3.AL PQ: 0 ANSI: 5
usbcore: registered new interface driver fontel
sd 0:0:0:0: [sda] 234439535 512-byte logical blocks: (120 GB/111 GiB)
rtc-ds1307 0-0068: rtc core: registered ds1307 as rtc0
rtc-ds1307 0-0068: 56 bytes nvram
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO
 or FUA
ep93xx-rtc ep93xx-rtc: rtc core: registered ep93xx-rtc as rtc1
Software Watchdog Timer: 0.07 initialized. soft_noboot=0 soft_margin=60 sec soft
_panic=0 (nowayout= 0)
TCP cubic registered
NET: Registered protocol family 17
NET: Registered protocol family 15
ep93xx-rtc ep93xx-rtc: setting system clock to 1970-01-01 00:00:07 UTC (7)
Attempt to kill tasklet from interrupt
Unable to handle kernel NULL pointer dereference at virtual address 00000000
pgd = c0004000
[00000000] *pgd=00000000
Internal error: Oops: 80000005 [#1]
CPU: 0    Not tainted  (3.2.0-rc2EP-1+ #1015)
PC is at 0x0
LR is at sys_sched_yield+0x38/0x48
pc : [<00000000>]    lr : [<c0015030>]    psr: 20000093
sp : c02b7ce8  ip : c02b7cf8  fp : c02b7cf4
r10: c1918000  r9 : c19180a4  r8 : 00002118
r7 : 00000004  r6 : c02b7d20  r5 : c184d6bc  r4 : c184d6b8
r3 : c023e458  r2 : c02b7ce8  r1 : 00000001  r0 : c02bcff0
Flags: nzCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
Control: c000717f  Table: c0004000  DAC: 00000017
Process swapper (pid: 0, stack limit = 0xc02b6270)
Stack: (0xc02b7ce8 to 0xc02b8000)
7ce0:                   c02b7d04 c02b7cf8 c023bdcc c0015008 c02b7d1c c02b7d08
7d00: c001ca04 c023bdb4 60000093 c184d680 c02b7d44 c02b7d20 c012ac8c c001c9d8
7d20: c02b7d20 c02b7d20 c02b7d44 c1914070 c19180a4 c2860000 c02b7d64 c02b7d48
7d40: c0177c50 c012ac54 c19180a4 c1918000 00000004 00000004 c02b7d8c c02b7d68
7d60: c0176a64 c0177c20 00000000 c1914190 00000000 00000001 0000000b c19180a4
7d80: c02b7dd4 c02b7d90 c0176cc0 c01769c4 00000001 40000093 00000000 00000000
7da0: c1914190 00000000 c1822000 c1912a80 00000028 00000000 00000000 00000028
7dc0: c02d8148 c02c0084 c02b7e0c c02b7dd8 c00426d0 c0176ae0 c02b7dfc c02b7de8
7de0: c0035628 c02c0084 00000028 c02b7f48 c02b7eb4 c02bd44c c02d60e0 c02b0c90
7e00: c02b7e24 c02b7e10 c004285c c004268c c02c0084 00000028 c02b7e3c c02b7e28
7e20: c0045178 c004283c c02c4578 00000028 c02b7e4c c02b7e40 c0042254 c00450fc
7e40: c02b7e6c c02b7e50 c0009838 c0042228 c001cb80 20000013 fefc0001 c02b7eb4
7e60: c02b7e7c c02b7e70 c0008190 c0009810 c02b7f04 c02b7e80 c0008b64 c0008190
7e80: 00000000 00000000 00000000 20000013 00000040 00000040 c02d60e0 c02b6000
7ea0: c02bd44c c02d60e0 c02b0c90 c02b7f04 c02b7f08 c02b7ec8 c001cdd0 c001cb80
7ec0: 20000013 ffffffff c02b7eec c02b7ed8 c004496c 0000000a c02bf674 c02c4578
7ee0: 00000011 00000000 c02b7f7c c0004000 41129200 c02b0c90 c02b7f14 c02b7f08
7f00: c001cdd0 c001cb38 c02b7f34 c02b7f18 c000983c c001cd98 c0009a60 60000013
7f20: fefb0001 c02b7f7c c02b7f44 c02b7f38 c0008190 c0009810 c02b7f9c c02b7f48
7f40: c0008b64 c0008190 c02c2bf8 00000002 c02b7f90 60000013 c02b6000 c02d1504
7f60: c02baa88 c02baa80 c0004000 41129200 c02b0c90 c02b7f9c c02b7fa0 c02b7f90
7f80: c0009a54 c0009a60 60000013 ffffffff c02b7fbc c02b7fa0 c000a03c c0009a40
7fa0: c02b80b0 c02b19ec c02b19e8 c02baa80 c02b7fcc c02b7fc0 c02384b4 c0009fd4
7fc0: c02b7ff4 c02b7fd0 c029d924 c0238464 c029d49c 00000000 00000000 c02b19ec
7fe0: c0007175 c02b803c 00000000 c02b7ff8 c000803c c029d700 00000000 00000000
Backtrace:
[<c0014ff8>] (sys_sched_yield+0x0/0x48) from [<c023bdcc>] (yield+0x28/0x2c)
[<c023bda4>] (yield+0x0/0x2c) from [<c001ca04>] (tasklet_kill+0x3c/0x9c)
[<c001c9c8>] (tasklet_kill+0x0/0x9c) from [<c012ac8c>] (ep93xx_dma_control+0x48/
0x1c0)
 r5:c184d680 r4:60000093
[<c012ac44>] (ep93xx_dma_control+0x0/0x1c0) from [<c0177c50>] (ep93xx_pata_dma_s
top+0x40/0xb8)
 r6:c2860000 r5:c19180a4 r4:c1914070
[<c0177c10>] (ep93xx_pata_dma_stop+0x0/0xb8) from [<c0176a64>] (ata_bmdma_port_i
ntr+0xb0/0x11c)
 r7:00000004 r6:00000004 r5:c1918000 r4:c19180a4
[<c01769b4>] (ata_bmdma_port_intr+0x0/0x11c) from [<c0176cc0>] (ata_bmdma_interr
upt+0x1f0/0x274)
 r9:c19180a4 r8:0000000b r7:00000001 r6:00000000 r5:c1914190
r4:00000000
[<c0176ad0>] (ata_bmdma_interrupt+0x0/0x274) from [<c00426d0>] (handle_irq_event
_percpu+0x54/0x1b0)
[<c004267c>] (handle_irq_event_percpu+0x0/0x1b0) from [<c004285c>] (handle_irq_e
vent+0x30/0x40)
[<c004282c>] (handle_irq_event+0x0/0x40) from [<c0045178>] (handle_level_irq+0x8
c/0xe8)
 r5:00000028 r4:c02c0084
[<c00450ec>] (handle_level_irq+0x0/0xe8) from [<c0042254>] (generic_handle_irq+0
x3c/0x48)
 r5:00000028 r4:c02c4578
[<c0042218>] (generic_handle_irq+0x0/0x48) from [<c0009838>] (handle_IRQ+0x38/0x
8c)
[<c0009800>] (handle_IRQ+0x0/0x8c) from [<c0008190>] (asm_do_IRQ+0x10/0x14)
 r7:c02b7eb4 r6:fefc0001 r5:20000013 r4:c001cb80
[<c0008180>] (asm_do_IRQ+0x0/0x14) from [<c0008b64>] (__irq_svc+0x24/0xc0)
Exception stack(0xc02b7e80 to 0xc02b7ec8)
7e80: 00000000 00000000 00000000 20000013 00000040 00000040 c02d60e0 c02b6000
7ea0: c02bd44c c02d60e0 c02b0c90 c02b7f04 c02b7f08 c02b7ec8 c001cdd0 c001cb80
7ec0: 20000013 ffffffff
[<c001cb28>] (__do_softirq+0x0/0x154) from [<c001cdd0>] (irq_exit+0x48/0x50)
[<c001cd88>] (irq_exit+0x0/0x50) from [<c000983c>] (handle_IRQ+0x3c/0x8c)
[<c0009800>] (handle_IRQ+0x0/0x8c) from [<c0008190>] (asm_do_IRQ+0x10/0x14)
 r7:c02b7f7c r6:fefb0001 r5:60000013 r4:c0009a60
[<c0008180>] (asm_do_IRQ+0x0/0x14) from [<c0008b64>] (__irq_svc+0x24/0xc0)
Exception stack(0xc02b7f48 to 0xc02b7f90)
7f40:                   c02c2bf8 00000002 c02b7f90 60000013 c02b6000 c02d1504
7f60: c02baa88 c02baa80 c0004000 41129200 c02b0c90 c02b7f9c c02b7fa0 c02b7f90
7f80: c0009a54 c0009a60 60000013 ffffffff
[<c0009a30>] (default_idle+0x0/0x34) from [<c000a03c>] (cpu_idle+0x78/0xb0)
[<c0009fc4>] (cpu_idle+0x0/0xb0) from [<c02384b4>] (rest_init+0x60/0x78)
 r7:c02baa80 r6:c02b19e8 r5:c02b19ec r4:c02b80b0
[<c0238454>] (rest_init+0x0/0x78) from [<c029d924>] (start_kernel+0x234/0x278)
[<c029d6f0>] (start_kernel+0x0/0x278) from [<c000803c>] (0xc000803c)
 r5:c02b803c r4:c0007175
Code: bad PC value
---[ end trace 3d4b7b18cc0879b4 ]---
Kernel panic - not syncing: Fatal exception in interrupt
Rebooting in 2 seconds..

I'm calling dma_terminate_all from interrupt. It seems that tasklet_kill is not
allowed to be called from this context.

Thanks,
Rafał Pryłowski.
