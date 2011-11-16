Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026Ab1KPIb5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 03:31:57 -0500
Received: from metasoft.pl ([195.149.224.191]:59319 "EHLO smtp.metasoft.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753006Ab1KPIbz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 03:31:55 -0500
X-clamdmail: clamdmail 0.18a
Message-ID: <4EC374F0.8000400@metasoft.pl>
Date: Wed, 16 Nov 2011 09:31:44 +0100
From: Rafal Prylowski <prylowski@metasoft.pl>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Mika Westerberg <mika.westerberg@iki.fi>
CC: linux-arm-kernel@lists.infradead.org, rmallon@gmail.com,
        vinod.koul@intel.com, broonie@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        hsweeten@visionengravers.com, dan.j.williams@intel.com, lrg@ti.com
Subject: Re: [PATCH v2 1/5] dmaengine: add ep93xx DMA support
References: <cover.1306662317.git.mika.westerberg@iki.fi> <3ea8d56034f25cbe3fd8a4c31d7d0d1540b6ac7e.1306662317.git.mika.westerberg@iki.fi> <4EC27EED.4030108@metasoft.pl> <20111116065512.GB2703@mwesterb-mobl.ger.corp.intel.com>
In-Reply-To: <20111116065512.GB2703@mwesterb-mobl.ger.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

W dniu 2011-11-16 07:55, Mika Westerberg pisze:
> Yes, this is certainly a copy-paste bug or something. Thanks for fixing :)
> 
> Can you send a separate patch for this? Make sure you Cc Vinod Koul as he is
> the maintainer of slave dma subsystem.

Here is a separate patch:

Index: linux-2.6/drivers/dma/ep93xx_dma.c
===================================================================
--- linux-2.6.orig/drivers/dma/ep93xx_dma.c
+++ linux-2.6/drivers/dma/ep93xx_dma.c
@@ -459,9 +459,6 @@ static int m2m_hw_setup(struct ep93xx_dm
 		 * This IDE part is totally untested. Values below are taken
 		 * from the EP93xx Users's Guide and might not be correct.
 		 */
-		control |= M2M_CONTROL_NO_HDSK;
-		control |= M2M_CONTROL_RSS_IDE;
-		control |= M2M_CONTROL_PW_16;
 
 		if (data->direction == DMA_TO_DEVICE) {
 			/* Worst case from the UG */
@@ -473,6 +470,9 @@ static int m2m_hw_setup(struct ep93xx_dm
 			control |= M2M_CONTROL_SAH;
 			control |= M2M_CONTROL_TM_RX;
 		}
+		control |= M2M_CONTROL_NO_HDSK;
+		control |= M2M_CONTROL_RSS_IDE;
+		control |= M2M_CONTROL_PW_16;
 		break;
 
 	default:

> 
>> 2) Kernel oops when trying to stop running transfers by calling
>> dmaengine_terminate_all(...) - caused by dereferencing empty list
>> in ep93xx_dma_get_active
> 
> Can you post that OOPS log? I would like to understand this problem a bit
> better before we do any fixes for the driver.
> 

OOPS log:

Linux version 3.2.0-rc1EP-1+ (prylowski@server) (gcc version 4.4.2 (GCC) ) #1008
 Wed Nov 16 08:25:45 CET 2011
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
    modules : 0xbf000000 -0xc0000000   (  16 MB)
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
UDP hashable entries: 256 (order: 0, 4096 bytes)
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
eth0: ep93xx on-chip ethernet, IRQ 39, 8e:42:5c:13:29:4c
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ep93xx-ohci ep93xx-ohci: EP93xx OHCI
ep93xx-ohci ep93xx-ohci: new USB bus registered, assigned bus number 1
ep93xx-ohci ep93xx-ohci: irq 56, io mem 0x80020000
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 3 ports detected
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usbcore: registered new interface driver fontel
rtc-ds1307 0-0068: rtc core: registered ds1307 as rtc0
rtc-ds1307 0-0068: 56 bytes nvram
ep93xx-rtc ep93xx-rtc: rtc core: registered ep93xx-rtc as rtc1
Software Watchdog Timer: 0.07 initialized. soft_noboot=0 soft_margin=60 sec soft
_panic=0 (nowayout= 0)
TCP cubic registered
NET: Registered protocol family 17
NET: Registered protocol family 15
ep93xx-rtc ep93xx-rtc: setting system clock to 1970-01-01 00:00:07 UTC (7)
ata1.00: ATA-8: WDC WD3200BEVE-00A0HT0, 11.01A11, max UDMA/100
ata1.00: 625142448 sectors, multi 0: LBA48
ata1.00: configured for UDMA/66
scsi 0:0:0:0: Direct-Access     ATA      WDC WD3200BEVE-0 11.0 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 625142448 512-byte logical blocks: (320 GB/298 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO
 or FUA
Internal error: Oops - undefined instruction: 0 [#1]
CPU: 0    Not tainted  (3.2.0-rc1EP-1+ #1008)
PC is at 0xc184c868
LR is at ep93xx_dma_tasklet+0xec/0x164
pc : [<c184c868>]    lr : [<c012b528>]    psr: 00000013
sp : c02b7e70  ip : ffffffff  fp : c02b7ea4
r10: 00000100  r9 : 80000013  r8 : c02b7e50
r7 : c02b7e70  r6 : c02b7ea4  r5 : 000000a4  r4 : c02b7e70
r3 : c02b751d  r2 : 8ae34598  r1 : c184c6e0  r0 : c02b7ea4
Flags: nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
Control: c000717f  Table: c0004000  DAC: 00000017
Process swapper (pid: 0, stack limit = 0xc02b6270)
Stack: (0xc02b7e70 to 0xc02b8000)
7e60:                                     c02b7ea4 c02b7e70 c0008b64 c02bd5c4
7e80: c02d60e0 00000000 00000000 c02bd44c c02d60e0 00000100 c02b7ec4 c02b7ea8
7ea0: c001c49c c012b44c 00000018 00000001 c02d60e0 c02b6000 c02b7f04 c02b7ec8
7ec0: c001cbc0 c001c3e4 c02b7eec c02b7ed8 00000006 0000000a c02bf674 c02c458c
7ee0: 00000011 00000000 c02b7f7c c0004000 41129200 c02b0c80 c02b7f14 c02b7f08
7f00: c001cdd0 c001cb38 c02b7f34 c02b7f18 c000983c c001cd98 c0009a60 60000013
7f20: fefb0001 c02b7f7c c02b7f44 c02b7f38 c0008190 c0009810 c02b7f9c c02b7f48
7f40: c0008b64 c0008190 c02c2bf8 00000002 c02b7f90 60000013 c02b6000 c02d1504
7f60: c02baa88 c02baa80 c0004000 41129200 c02b0c80 c02b7f9c c02b7fa0 c02b7f90
7f80: c0009a54 c0009a60 60000013 ffffffff c02b7fbc c02b7fa0 c000a03c c0009a40
7fa0: c02b80b0 c02b19dc c02b19d8 c02baa80 c02b7fcc c02b7fc0 c02384e4 c0009fd4
7fc0: c02b7ff4 c02b7fd0 c029d924 c0238494 c029d49c 00000000 00000000 c02b19dc
7fe0: c0007175 c02b803c 00000000 c02b7ff8 c000803c c029d700 00000000 00000000
Backtrace:
[<c012b43c>] (ep93xx_dma_tasklet+0x0/0x164) from [<c001c49c>] (tasklet_action+0x
c8/0xdc)
[<c001c3d4>] (tasklet_action+0x0/0xdc) from [<c001cbc0>] (__do_softirq+0x98/0x15
4)
 r7:c02b6000 r6:c02d60e0 r5:00000001 r4:00000018
[<c001cb28>] (__do_softirq+0x0/0x154) from [<c001cdd0>] (irq_exit+0x48/0x50)
[<c001cd88>] (irq_exit+0x0/0x50) from [<c000983c>] (handle_IRQ+0x3c/0x8c)
[<c0009800>] (handle_IRQ+0x0/0x8c) from [<c0008190>] (asm_do_IRQ+0x10/0x14)
 r7:c02b7f7c r6:fefb0001 r5:60000013 r4:c0009a60
[<c0008180>] (asm_do_IRQ+0x0/0x14) from [<c0008b64>] (__irq_svc+0x24/0xc0)
Exception stack(0xc02b7f48 to 0xc02b7f90)
7f40:                   c02c2bf8 00000002 c02b7f90 60000013 c02b6000 c02d1504
7f60: c02baa88 c02baa80 c0004000 41129200 c02b0c80 c02b7f9c c02b7fa0 c02b7f90
7f80: c0009a54 c0009a60 60000013 ffffffff
[<c0009a30>] (default_idle+0x0/0x34) from [<c000a03c>] (cpu_idle+0x78/0xb0)
[<c0009fc4>] (cpu_idle+0x0/0xb0) from [<c02384e4>] (rest_init+0x60/0x78)
 r7:c02baa80 r6:c02b19d8 r5:c02b19dc r4:c02b80b0
[<c0238484>] (rest_init+0x0/0x78) from [<c029d924>] (start_kernel+0x234/0x278)
[<c029d6f0>] (start_kernel+0x0/0x278) from [<c000803c>] (0xc000803c)
 r5:c02b803c r4:c0007175
Code: 42555300 54535953 643d4d45 65766972 (53007372)
---[ end trace a494979f60859f42 ]---
Kernel panic - not syncing: Fatal exception in interrupt
Rebooting in 2 seconds..


I'm trying to call dmaengine_terminate_all from function assigned as libata .bmdma_stop.
Maybe this is incorrect, and this bug report is invalid...

Regards,
Rafal Prylowski.
