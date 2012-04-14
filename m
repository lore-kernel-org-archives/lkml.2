Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075Ab2DNCok (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 22:44:40 -0400
Received: from mx.scalarmail.ca ([98.158.95.75]:58650 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754972Ab2DNCog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 22:44:36 -0400
Date: Fri, 13 Apr 2012 22:44:30 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Cc: Arend van Spriel <arend@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Subject: Regression: bcma: early boot crash on BCM4716 w/ 3.4-rc2+ (bisected)
Message-ID: <20120414024430.GA19782@elliptictech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

Attemping to boot Linus' master on my Asus RT-N16 (Broadcom BCM4716 SoC)
crashes early (before userspace is started).  Full boot log is appended.
Linux 3.3 boots successfully, so I bisected to the following commit.
Reverting the implicated commit on top of Linus' master corrects the
issue.

Please let me know if you need any more info,

10d8493cd9efd38b1947b7a74276dbdc8311aa1a is the first bad commit
commit 10d8493cd9efd38b1947b7a74276dbdc8311aa1a
Author: Arend van Spriel <arend@broadcom.com>
Date:   Tue Mar 6 15:50:48 2012 +0100

    bcma: add support for on-chip OTP memory used for SPROM storage
    
    Wireless Broadcom chips can have either their SPROM data stored
    on either external SPROM or on-chip OTP memory. Both are accessed
    through the same register space. This patch adds support for the
    on-chip OTP memory.
    
    Tested with:
    BCM43224 OTP and SPROM
    BCM4331 SPROM
    BCM4313 OTP
    
    This patch is in response to linux-wireless thread [1].
    
    [1] http://article.gmane.org/gmane.linux.kernel.wireless.general/85426
    
    Tested-by: Saul St. John <saul.stjohn@gmail.com>
    Tested-by: Rafal Milecki <zajec5@gmail.com>
    Tested-by: Hauke Mehrtens <hauke@hauke-m.de>
    Cc: Larry Finger <Larry.Finger@lwfinger.net>
    Signed-off-by: Arend van Spriel <arend@broadcom.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

:040000 040000 761bdd36c36c49d9e96d53e6797186bc1cc8364a fe16356daf2cdc7a3552804b85c1d7deb5b82579 M	drivers
:040000 040000 d1494dc9d5a89da0920aadb7f605386eb909acca e83a98ac9d8eebb1f367b1ce1bbac7da50ac0479 M	include

Linux version 3.4.0-rc2-00288-g7d93101 (nick@amythaon) (gcc version 4.5.3 (Gentoo 4.5.3-r2 p1.1, pie-0.4.7) ) #0 PREEMPT Thu Apr 12 20:18:40 EDT 2012
bootconsole [early0] enabled
CPU revision is: 00019740 (MIPS 74Kc)
bcm47xx: using bcma bus
bcma: Found chip with id 0x4716, rev 0x01 and package 0x0A
bcma: Core 0 found: ChipCommon (manuf 0x4BF, id 0x800, rev 0x1F, class 0x0)
bcma: Core 3 found: UNKNOWN (manuf 0x4A7, id 0x82C, rev 0x01, class 0x0)
bcma: PLL init unknown for device 0x4716
bcma: PMU resource config unknown for device 0x4716
bcma: PMU switch/regulators init unknown for device 0x4716
bcma: Workarounds unknown for device 0x4716
bcma: Initializing MIPS core...
bcma: IRQ reconfiguration done
bcma: core 0x0800, irq : 2(S)* 3  4  5  6  D  I 
bcma: core 0x082c, irq : 2(S)* 3  4  5  6  D  I 
bcma: found parallel flash.
bcma: Early bus registered
Determined physical RAM map:
 memory: 08000000 @ 00000000 (usable)
Initrd not found or empty - disabling initrd
Zone PFN ranges:
  Normal   0x00000000 -> 0x00008000
Movable zone start PFN for each node
Early memory PFN ranges
    0: 0x00000000 -> 0x00008000
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 32512
Kernel command line:  console=ttyS0,115200 console=ttyS0,115200n8
PID hash table entries: 512 (order: -1, 2048 bytes)
Dentry cache hash table entries: 16384 (order: 4, 65536 bytes)
Inode-cache hash table entries: 8192 (order: 3, 32768 bytes)
Primary instruction cache 32kB, VIPT, 4-way, linesize 32 bytes.
Primary data cache 32kB, 4-way, VIPT, cache aliases, linesize 32 bytes
Writing ErrCtl register=00000000
Readback ErrCtl register=00000000
Memory: 126448k/131072k available (2304k kernel code, 4624k reserved, 599k data, 180k init, 0k highmem)
SLUB: Genslabs=9, HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
NR_IRQS:128
Calibrating delay loop... 238.59 BogoMIPS (lpj=119296)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 512
NET: Registered protocol family 16
bio: create slab <bio-0> at 0
vgaarb: loaded
SCSI subsystem initialized
Switching to clocksource MIPS
NET: Registered protocol family 2
IP route cache hash table entries: 1024 (order: 0, 4096 bytes)
TCP established hash table entries: 4096 (order: 3, 32768 bytes)
TCP bind hash table entries: 4096 (order: 2, 16384 bytes)
TCP: Hash tables configured (established 4096 bind 4096)
TCP: reno registered
UDP hash table entries: 256 (order: 0, 4096 bytes)
UDP-Lite hash table entries: 256 (order: 0, 4096 bytes)
NET: Registered protocol family 1
bcma: Core 1 found: IEEE 802.11 (manuf 0x4BF, id 0x812, rev 0x11, class 0x0)
bcma: Core 2 found: GBit MAC (manuf 0x4BF, id 0x82D, rev 0x00, class 0x0)
bcma: Core 4 found: USB 2.0 Host (manuf 0x4BF, id 0x819, rev 0x04, class 0x0)
bcma: Core 5 found: PCIe (manuf 0x4BF, id 0x820, rev 0x0E, class 0x0)
bcma: Core 6 found: DDR1/DDR2 Memory Controller (manuf 0x4BF, id 0x82E, rev 0x01, class 0x0)
bcma: Core 7 found: Internal Memory (manuf 0x4BF, id 0x80E, rev 0x07, class 0x0)
bcma: Core 8 found: I2S (manuf 0x4BF, id 0x834, rev 0x00, class 0x0)
bcma: Initializing MIPS core...
bcma: set_irq: core 0x0812, irq 3 => 3
bcma: set_irq: core 0x082d, irq 4 => 4
bcma: set_irq: core 0x0819, irq 5 => 5
bcma: IRQ reconfiguration done
bcma: core 0x0800, irq : 2(S)* 3  4  5  6  D  I 
bcma: core 0x082c, irq : 2(S)* 3  4  5  6  D  I 
bcma: core 0x0812, irq : 2(S)  3* 4  5  6  D  I 
bcma: core 0x082d, irq : 2(S)  3  4* 5  6  D  I 
bcma: core 0x0819, irq : 2(S)  3  4  5* 6  D  I 
bcma: core 0x0820, irq : 2(S)  3  4  5  6* D  I 
bcma: core 0x082e, irq : 2(S)* 3  4  5  6  D  I 
bcma: core 0x080e, irq : 2(S)* 3  4  5  6  D  I 
bcma: core 0x0834, irq : 2(S)* 3  4  5  6  D  I 
bcma: PCIEcore in host mode found
PCI host bridge to bus 0000:00
pci_bus 0000:00: root bus resource [mem 0x08000000-0x0bffffff]
pci_bus 0000:00: root bus resource [io  0x0100-0x07ff]
bcma: PCI: Fixing up bridge 0000:00:00.0
bcma: PCI: Fixing up device 0000:00:00.0
bcma: PCI: Fixing up bridge 0000:00:00.1
bcma: PCI: Fixing up device 0000:00:00.1
Data bus error, epc == 8019e308, ra == 8019b914
Oops[#1]:
Cpu 0
$ 0   : 00000000 00000000 00000000 802c5aa0
$ 4   : 8030d410 b8000900 00000001 00000001
$ 8   : 80353bf4 00000003 00000001 8024e380
$12   : ffffffff 00000000 00000000 ffffffff
$16   : 87daca00 8030d150 00000902 87daca00
$20   : 87dacb00 87dacbb8 802d709c 80300000
$24   : 00000000 80171fa8                  
$28   : 87c28000 87c29df8 00000020 8019b914
Hi    : 00000000
Lo    : 15846c40
epc   : 8019e308 bcma_host_soc_read16+0x10/0x18
    Not tainted
ra    : 8019b914 bcma_sprom_get+0x244/0x670
Status: 11008003    KERNEL EXL IE 
Cause : 8080001c
PrId  : 00019740 (MIPS 74Kc)
Modules linked in:
Process swapper (pid: 1, threadinfo=87c28000, task=87c24000, tls=00000000)
Stack : 00000008 00000800 00000000 00000001 00000020 8023be2c 00000000 8030d150
        802d0000 00000000 80300000 00000008 802b8954 8023bc60 802c5000 00000000
        802c0000 00000100 802c0000 00000200 00000006 802d9824 00000000 80300000
        00000008 802b8954 802d709c 80300000 00000020 802d9848 00000000 80300000
        00000008 802b8954 802d709c 800015d0 00000000 800ffca8 00000001 00000006
        ...
Call Trace:
[<8019e308>] bcma_host_soc_read16+0x10/0x18
[<8019b914>] bcma_sprom_get+0x244/0x670
[<8023bc60>] bcma_bus_register+0xe4/0x264
[<802d9848>] bcm47xx_register_bus_complete+0x24/0x34
[<800015d0>] do_one_initcall+0xfc/0x1dc
[<802d7a48>] kernel_init+0x12c/0x1f8
[<80006c94>] kernel_thread_helper+0x10/0x18


Code: 30a5ffff  00452821  94a20000 <03e00008> 3042ffff  8c82015c  30a5ffff  00452821  8ca20000 
---[ end trace e93713a9d40cd06c ]---
Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)

