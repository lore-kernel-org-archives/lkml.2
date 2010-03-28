Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244Ab0C1V1h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 17:27:37 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:49267 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755118Ab0C1V1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 17:27:36 -0400
Date: Sun, 28 Mar 2010 16:27:28 -0500
From: David Fries <david@fries.net>
To: David Miller <davem@davemloft.net>
Cc: bzolnier@gmail.com, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: revert request "ide: skip probe if there are no devices on the
	port (v2)"
Message-ID: <20100328212728.GA2674@spacedout.fries.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Sun, 28 Mar 2010 16:27:30 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that I have 2.6.34-rc2 booting it no longer detects the cdrom
drive.  That is looking at the kernel messages, partition dump, and
after booting hdparm etc does not find the drive.  I expect it is
because the cdrom is a slave drive without a master on that ribbon.
Reverting
-------------------------------
commit a20b2a44eca52818ef52a94959480b7e6ea2f528
Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date:   Mon Jun 8 22:07:28 2009 +0200

    ide: skip probe if there are no devices on the port (v2)
    
    In ide_probe_port() skip probe if ide_port_wait_ready() returns -ENODEV
    and print error message instead of debug one if it returns -EBUSY.
    
    v2:
    Fix the default 'rc' value.
    
    Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
-------------------------------
fixes the problem.  That branch
'for-2.6.31' of git://git.kernel.org/pub/scm/linux/kernel/git/bart/ide-2.6
was merged at d614aec4752f8c61b2e7cb77806b6bd59aa50836 


boot output, no hdd mentioned
Again I'm giving it a bad root partition so it dumps the partition
table at the end of the messages and I can hibernate and resume
my other kernel.
on 220bf991b0366cc50a94feede3d7341fa5710ee4 Linux 2.6.34-rc2
reverting just
c06d4b0528aa9e515ae9c4a54f47dbca147a429a
via82cxxx: workaround h/w bugs

Uniform Multi-Platform E-IDE driver
via82cxxx 0000:00:07.1: VIA vt82c586b (rev 41) IDE UDMA33
via82cxxx 0000:00:07.1: IDE controller (0x1106:0x0571 rev 0x06)
via82cxxx 0000:00:07.1: not 100% native mode: will probe irqs later
ide: disallowing DMA for hda
ide: disallowing DMA for hdb
    ide0: BM-DMA at 0xe400-0xe407
ide: disallowing DMA for hdc
ide: disallowing DMA for hdd
    ide1: BM-DMA at 0xe408-0xe40f
hda: Maxtor 6Y120P0, ATA DISK drive
ide1: no devices on the port
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide1 at 0x170-0x177,0x376 on irq 15
ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
ide-gd driver 1.18
hda: max request size: 128KiB
hda: Host Protected Area detected.
        current capacity is 66055248 sectors (33820 MB)
        native  capacity is 240121728 sectors (122942 MB)
hda: 66055248 sectors (33820 MB) w/7936KiB Cache, CHS=65531/16/63
hda: cache flushes supported
 hda: hda1 hda2 hda3
hda: p3 size 236037312 exceeds device capacity, enabling native capacity
hda: detected capacity change from 33820286976 to 122942324736
ide-cd driver 5.00
...
VFS: Cannot open root device "1602" or unknown-block(22,2)
Please append a correct "root=" boot option; here are the available partitions:
0300       120060864 hda driver: ide-gd
  0301           49391 hda1
  0302         1992816 hda2
  0303       118018656 hda3
Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(22,2)



hdd found and model read with the addition of reverting
a20b2a44eca52818ef52a94959480b7e6ea2f528
ide: skip probe if there are no devices on the port (v2)

Uniform Multi-Platform E-IDE driver
via82cxxx 0000:00:07.1: VIA vt82c586b (rev 41) IDE UDMA33
via82cxxx 0000:00:07.1: IDE controller (0x1106:0x0571 rev 0x06)
via82cxxx 0000:00:07.1: not 100% native mode: will probe irqs later
ide: disallowing DMA for hda
ide: disallowing DMA for hdb
    ide0: BM-DMA at 0xe400-0xe407
ide: disallowing DMA for hdc
ide: disallowing DMA for hdd
    ide1: BM-DMA at 0xe408-0xe40f
hda: Maxtor 6Y120P0, ATA DISK drive
hdd: PLEXTOR CD-R PX-W4012A, ATAPI CD/DVD-ROM drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide1 at 0x170-0x177,0x376 on irq 15
ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
ide-gd driver 1.18
hda: max request size: 128KiB
hda: Host Protected Area detected.
        current capacity is 66055248 sectors (33820 MB)
        native  capacity is 240121728 sectors (122942 MB)
hda: 66055248 sectors (33820 MB) w/7936KiB Cache, CHS=65531/16/63
hda: cache flushes supported
 hda: hda1 hda2 hda3
hda: p3 size 236037312 exceeds device capacity, enabling native capacity
hda: detected capacity change from 33820286976 to 122942324736
ide-cd driver 5.00
ide-cd: hdd: ATAPI 40X CD-ROM CD-R/RW drive, 4096kB Cache
Uniform CD-ROM driver Revision: 3.20
...
VFS: Cannot open root device "1602" or unknown-block(22,2)
Please append a correct "root=" boot option; here are the available partitions:
0300       120060864 hda driver: ide-gd
  0301           49391 hda1
  0302         1992816 hda2
  0303       118018656 hda3
1640         4194302 hdd driver: ide-cdrom
Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(22,2)

-- 
David Fries <david@fries.net>
http://fries.net/~david/ (PGP encryption key available)
