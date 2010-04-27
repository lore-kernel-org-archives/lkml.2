Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549Ab0D0J3h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 05:29:37 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:37093 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1749667Ab0D0J3f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 05:29:35 -0400
Date: Tue, 27 Apr 2010 11:29:34 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Paolo Minazzi <paolo.minazzi@gmail.com>
Cc: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] [MTD] Call bdi_init() and bdi_register()
Message-ID: <20100427092934.GH27497@kernel.dk>
References: <20100423205518.GB7008@logfs.org> <20100426094810.GE27497@kernel.dk> <20100426143253.GB4364@logfs.org> <20100426143803.GM27497@kernel.dk> <20100426144532.GN27497@kernel.dk> <20100426163050.GC4364@logfs.org> <20100426163126.GD4364@logfs.org> <x2v4aa525de1004270201t9f57f49fv1e9cfbb2d886e4ad@mail.gmail.com> <20100427091650.GG27497@kernel.dk> <r2l4aa525de1004270226r40c3dd1ctd09e716f47deca39@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <r2l4aa525de1004270226r40c3dd1ctd09e716f47deca39@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 27 2010, Paolo Minazzi wrote:
> On Tue, Apr 27, 2010 at 11:16 AM, Jens Axboe <jens.axboe@oracle.com> wrote:
> > On Tue, Apr 27 2010, Paolo Minazzi wrote:
> >> I have tried this patch.
> >> I have enabled LOGFS, but not mounted partition with it.
> >> /dev/mtdblock1 is my romfs root partition and it is OK.
> >>
> >> The problem is that init cannot mount my /dev/mtdblock1 romfs root.
> >>
> >> This is the fault :
> >> Platform: Cirrus Logic EDB9315A Board (ARM920T) Rev A
> >> Copyright (C) 2000, 2001, 2002, Red Hat, Inc.
> >>        |----------------------------------------------
> >> Raw file loaded 0x00080000-0x001dce6b, assumed entry at
> >> 0x00080000-----------------------------------------------------------
> >> RedBoot> exec -s 0x00b00000 -r 0x00a00000 -c "root=/dev/mtdblock1
> >> console=ttyAM console=tty1"--------------------------------
> >> ENTRY=0xc0008000-------------------------------------------------------------------------------------------------------------
> >> LENGTH=0x00300000------------------------------------------------------------------------------------------------------------
> >> BASE_ADDR=0x00080000---------------------------------------------------------------------------------------------------------
> >> Using base address 0x00080000 and length
> >> 0x00300000--------------------------------------------------------------------------
> >> Uncompressing Linux... done, booting the kernel.
> >> Linux version 2.6.34-rc5 (root@darkstar) (gcc version 3.4.3) #18 Tue
> >> Apr 27 10:55:55 CEST 2010
> >> CPU: ARM920T [41129200] revision 0 (ARMv4T), cr=c0007177
> >> CPU: VIVT data cache, VIVT instruction cache
> >> Machine: Cirrus Logic EDB9315A Evaluation Board
> >> Memory policy: ECC disabled, Data cache writeback
> >> Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 32512
> >> Kernel command line: root=/dev/mtdblock1 console=ttyAM console=tty1
> >> PID hash table entries: 512 (order: -1, 2048 bytes)
> >> Dentry cache hash table entries: 16384 (order: 4, 65536 bytes)
> >> Inode-cache hash table entries: 8192 (order: 3, 32768 bytes)
> >> Memory: 128MB = 128MB total
> >> Memory: 126928k/126928k available, 4144k reserved, 0K highmem
> >> Virtual kernel memory layout:
> >>     vector  : 0xffff0000 - 0xffff1000   (   4 kB)
> >>     fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
> >>     DMA     : 0xffc00000 - 0xffe00000   (   2 MB)
> >>     vmalloc : 0xc8800000 - 0xfe800000   ( 864 MB)
> >>     lowmem  : 0xc0000000 - 0xc8000000   ( 128 MB)
> >>     modules : 0xbf000000 - 0xc0000000   (  16 MB)
> >>       .init : 0xc0008000 - 0xc0036000   ( 184 kB)
> >>       .text : 0xc0036000 - 0xc02ab000   (2516 kB)
> >>       .data : 0xc02ac000 - 0xc02c4e00   ( 100 kB)
> >> SLUB: Genslabs=11, HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
> >> Hierarchical RCU implementation.
> >> NR_IRQS:120
> >> VIC @fefb0000: id 0x00041190, vendor 0x41
> >> VIC @fefc0000: id 0x00041190, vendor 0x41
> >> Console: colour dummy device 80x30
> >> console [tty1] enabled
> >> Calibrating delay loop... 99.73 BogoMIPS (lpj=498688)
> >> Mount-cache hash table entries: 512
> >> CPU: Testing write buffer coherency: ok
> >> NET: Registered protocol family 16
> >> ep93xx clock: PLL1 running at 200 MHz, PLL2 at 48 MHz
> >> ep93xx clock: FCLK 200 MHz, HCLK 100 MHz, PCLK 50 MHz
> >> ep93xx dma_m2p: M2P DMA subsystem initialized
> >> bio: create slab <bio-0> at 0
> >> SCSI subsystem initialized
> >> usbcore: registered new interface driver usbfs
> >> usbcore: registered new interface driver hub
> >> usbcore: registered new device driver usb
> >> NET: Registered protocol family 2
> >> IP route cache hash table entries: 1024 (order: 0, 4096 bytes)
> >> TCP established hash table entries: 4096 (order: 3, 32768 bytes)
> >> TCP bind hash table entries: 4096 (order: 2, 16384 bytes)
> >> TCP: Hash tables configured (established 4096 bind 4096)
> >> TCP reno registered
> >> UDP hash table entries: 256 (order: 0, 4096 bytes)
> >> UDP-Lite hash table entries: 256 (order: 0, 4096 bytes)
> >> NET: Registered protocol family 1
> >> JFFS2 version 2.2. (NAND) © 2001-2006 Red Hat, Inc.
> >> ***REGISTER LOGFS
> >> ***REGISTER LOGFS DONE ret=0
> >> ROMFS MTD (C) 2007 Red Hat, Inc.
> >> msgmni has been set to 247
> >> io scheduler noop registered
> >> io scheduler deadline registered
> >> io scheduler cfq registered (default)
> >> Console: switching to colour frame buffer device 100x37
> >> graphics fb0: registered. Mode = 800x600-16
> >> Serial: AMBA driver
> >> apb:uart1: ttyAM0 at MMIO 0x808c0000 (irq = 52) is a AMBA
> >> console [ttyAM0] enabled
> >> apb:uart2: ttyAM1 at MMIO 0x808d0000 (irq = 54) is a AMBA
> >> apb:uart3: ttyAM2 at MMIO 0x808e0000 (irq = 55) is a AMBA
> >> dev->num_resources=1
> >> physmap platform flash device: 02000000 at 60000000
> >> physmap-flash.0: Found 1 x16 devices at 0x0 in 16-bit bank
> >> physmap-flash.0: Found 1 x16 devices at 0x1000000 in 16-bit bank
> >>  Intel/Sharp Extended Query Table at 0x0031
> >>  Intel/Sharp Extended Query Table at 0x0031
> >> Using buffer write method
> >> cfi_cmdset_0001: Erase suspend on write enabled
> >> cmdlinepart partition parsing not available
> >> Searching for RedBoot partition table in physmap-flash.0 at offset 0x1fe0000
> >> 6 RedBoot partitions found on MTD device physmap-flash.0
> >> Creating 6 MTD partitions on "physmap-flash.0":
> >> 0x000000000000-0x000000040000 : "RedBoot"
> >> 0x000000040000-0x000000b40000 : "ramdisk"
> >> 0x000000b40000-0x000000e40000 : "zImage"
> >> 0x000000e40000-0x000001fc0000 : "jffs2"
> >> 0x000001fc0000-0x000001fe0000 : "RedBoot config"
> >> 0x000001fe0000-0x000002000000 : "FIS directory"
> >> PPP generic driver version 2.4.2
> >> PPP Deflate Compression module registered
> >> PPP BSD Compression module registered
> >> ep93xx-eth version 0.1 loading
> >> eth0: ep93xx on-chip ethernet, IRQ 39, 00:00:11:22:33:36
> >> ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> >> ep93xx-ohci ep93xx-ohci: EP93xx OHCI
> >> ep93xx-ohci ep93xx-ohci: new USB bus registered, assigned bus number 1
> >> ep93xx-ohci ep93xx-ohci: irq 56, io mem 0x80020000
> >> hub 1-0:1.0: USB hub found
> >> hub 1-0:1.0: 3 ports detected
> >> usbcore: registered new interface driver cdc_acm
> >> cdc_acm: v0.26:USB Abstract Control Model driver for USB modems and
> >> ISDN adapters
> >> Initializing USB Mass Storage driver...
> >> usbcore: registered new interface driver usb-storage
> >> USB Mass Storage support registered.
> >> ep93xx-rtc ep93xx-rtc: rtc core: registered ep93xx-rtc as rtc0
> >> usbcore: registered new interface driver usbhid
> >> usbhid: USB HID core driver
> >> TCP cubic registered
> >> NET: Registered protocol family 17
> >> Last power-down at UTC 08:47:16 on 27/04/2010
> >> ep93xx-rtc ep93xx-rtc: setting system clock to 2010-04-27 08:47:16 UTC
> >> (1272358036)
> >> VFS: Cannot open root device "mtdblock1" or unknown-block(31,1)
> >> Please append a correct "root=" boot option; here are the available partitions:
> >> 1f00             256 mtdblock0 (driver?)
> >> 1f01           11264 mtdblock1 (driver?)
> >> 1f02            3072 mtdblock2 (driver?)
> >> 1f03           17920 mtdblock3 (driver?)
> >> 1f04             128 mtdblock4 (driver?)
> >> 1f05             128 mtdblock5 (driver?)
> >> Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(31,1)
> >> Backtrace:
> >> [<c003a3dc>] (dump_backtrace+0x0/0x12c) from [<c003a520>] (dump_stack+0x18/0x1c)
> >>  r7:c7c11000 r6:fffffffb r5:c7c11000 r4:00000000
> >> [<c003a508>] (dump_stack+0x0/0x1c) from [<c0046628>] (panic+0x3c/0xc4)
> >> [<c00465ec>] (panic+0x0/0xc4) from [<c0008d58>] (mount_block_root+0x110/0x2e8)
> >>  r3:00000000 r2:20000013 r1:c7c27f58 r0:c0276b44
> >> [<c0008c48>] (mount_block_root+0x0/0x2e8) from [<c0008f84>]
> >> (mount_root+0x54/0x6c)
> >> [<c0008f30>] (mount_root+0x0/0x6c) from [<c0009094>]
> >> (prepare_namespace+0xf8/0x194)
> >>  r5:c001a56c r4:c001a570
> >> [<c0008f9c>] (prepare_namespace+0x0/0x194) from [<c0008aa4>]
> >> (kernel_init+0x114/0x15c)
> >>  r6:c0019b0c r5:c0019d5c r4:c02c4e18
> >> [<c0008990>] (kernel_init+0x0/0x15c) from [<c0048e98>] (do_exit+0x0/0x628)
> >>  r6:00000000 r5:00000000 r4:00000000
> >>
> >>
> >>
> >> If I disable logfs, my root /dev/mtdblock1 is mounted correclty.
> >
> > So this issue looks unrelated, but a bug none the less (if just enabling
> > logfs breaks the mount).
>
> To be precise, I say :
> 
> - downloaded 2.6.34rc5
> - apply the jens patch
> - the logfs code is the code in the 2.6.34rc5 (I have no applied other
> jorn patch)

(please stop top posting, I fixed this one up for you).

Just to be on the safe side - without the patch, does it work or not?

-- 
Jens Axboe

