Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106Ab2HYNLQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 09:11:16 -0400
Received: from smtp1.uu.se ([130.238.7.54]:48645 "EHLO smtp1.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751666Ab2HYNLJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 09:11:09 -0400
X-Greylist: delayed 484 seconds by postgrey-1.27 at vger.kernel.org; Sat, 25 Aug 2012 09:11:09 EDT
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <20536.52397.140042.917795@pilspetsen.it.uu.se>
Date: Sat, 25 Aug 2012 15:01:33 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: linux-arm-kernel@lists.infradead.org
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        linux-kernel@vger.kernel.org
Subject: [3.6-rc3 regression] sata_mv cannot get optional clkdev breaking boot on QNAP TS-119P+
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My Kirkwood-based QNAP TS-119P+ boots fine with the 3.5 kernel.  With
3.6-rc2 and 3.6-rc3 however sata_mv complains:

sata_mv sata_mv.0: cannot get optional clkdev
sata_mv sata_mv.0: slots 32 ports 2

and then the kernel grinds to a halt with no further messages.

Full boot log from 3.6-rc3 appended below.  .config available upon
request, but this is a non-DT kernel.

/Mikael

Uncompressing Linux... done, booting the kernel.
Booting Linux on physical CPU 0
Linux version 3.6.0-rc3 (mikpe@hallertau) (gcc version 4.6.4 20120706 (prerelease) (GCC) ) #1 Sat Aug 25 14:43:24 CEST 2012
CPU: Feroceon 88FR131 [56251311] revision 1 (ARMv5TE), cr=00053977
CPU: VIVT data cache, VIVT instruction cache
Machine: QNAP TS-119/TS-219
Ignoring unrecognised tag 0x41000403
Memory policy: ECC disabled, Data cache writeback
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 130048
Kernel command line: console=ttyS0,115200n8 ro root=/dev/sda1
PID hash table entries: 2048 (order: 1, 8192 bytes)
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 512MB = 512MB total
Memory: 515884k/515884k available, 8404k reserved, 0K highmem
Virtual kernel memory layout:
    vector  : 0xffff0000 - 0xffff1000   (   4 kB)
    fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
    vmalloc : 0xe0800000 - 0xff000000   ( 488 MB)
    lowmem  : 0xc0000000 - 0xe0000000   ( 512 MB)
    modules : 0xbf000000 - 0xc0000000   (  16 MB)
      .text : 0xc0008000 - 0xc0366000   (3448 kB)
      .init : 0xc0366000 - 0xc03844b8   ( 122 kB)
      .data : 0xc0386000 - 0xc03b32a0   ( 181 kB)
       .bss : 0xc03b32c4 - 0xc03c67c0   (  78 kB)
NR_IRQS:114
sched_clock: 32 bits at 200MHz, resolution 5ns, wraps every 21474ms
Console: colour dummy device 80x30
Calibrating delay loop... 1587.60 BogoMIPS (lpj=7938048)
pid_max: default: 32768 minimum: 301
Security Framework initialized
Mount-cache hash table entries: 512
CPU: Testing write buffer coherency: ok
Setting up static identity map for 0x2961e8 - 0x296224
devtmpfs: initialized
NET: Registered protocol family 16
DMA: preallocated 256 KiB pool for atomic coherent allocations
Kirkwood: MV88F6282-Rev-A0, TCLK=200000000.
Feroceon L2: Enabling L2
Feroceon L2: Cache support initialised.
Kirkwood PCIe port 0: 
link down, ignoring
bio: create slab <bio-0> at 0
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
Switching to clocksource orion_clocksource
NET: Registered protocol family 2
TCP established hash table entries: 16384 (order: 5, 131072 bytes)
TCP bind hash table entries: 16384 (order: 4, 65536 bytes)
TCP: Hash tables configured (established 16384 bind 16384)
TCP: reno registered
UDP hash table entries: 256 (order: 0, 4096 bytes)
UDP-Lite hash table entries: 256 (order: 0, 4096 bytes)
NET: Registered protocol family 1
RPC: Registered named UNIX socket transport module.
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
msgmni has been set to 1007
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler deadline registered
io scheduler cfq registered (default)
mv_xor_shared mv_xor_shared.0: Marvell shared XOR driver
mv_xor_shared mv_xor_shared.1: Marvell shared XOR driver
mv_xor mv_xor.0: Marvell XOR: ( xor cpy )
mv_xor mv_xor.1: Marvell XOR: ( xor fill cpy )
mv_xor mv_xor.2: Marvell XOR: ( xor cpy )
mv_xor mv_xor.3: Marvell XOR: ( xor fill cpy )
Serial: 8250/16550 driver, 2 ports, IRQ sharing disabled
serial8250.0: ttyS0 at MMIO 0xf1012000 (irq = 33) is a 16550A
console [ttyS0] enabled
serial8250.1: ttyS1 at MMIO 0xf1012100 (irq = 34) is a 16550A
loop: module loaded
sata_mv sata_mv.0: cannot get optional clkdev
sata_mv sata_mv.0: slots 32 ports 2
