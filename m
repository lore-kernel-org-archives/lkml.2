Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604Ab0FNPQd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 11:16:33 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61325 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754821Ab0FNPQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 11:16:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=UtxUVC8IiG864EYWXywuZvFnYV50OR4zdEp3D1GCsTLaA71vr9NxBQhICDFWYozilA
         fH5EXee2wgT7H8cpsdGjziXqOnA9r+Ik4Hb77i1hcv8xpWQW/CcmfGiMX72+jDueb5Ej
         N+WxiQzZOJislHwcMnwBCJ0d5utKkFi0jgU5k=
MIME-Version: 1.0
Date: Mon, 14 Jun 2010 23:16:29 +0800
Message-ID: <AANLkTimnqVSom2qHetXMBPiCNTYd-yc8Tl6a64n0zTSk@mail.gmail.com>
Subject: e-SATA ExpressCard - OOPS plus incrementing "ataX" on Linux-2.6.xx
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: kristen.c.accardi@intel.com, Greg Kroah-Hartman <greg@kroah.com>,
       Dely Sy <dely.l.sy@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Takayoshi Kochi <t-kochi@bq.jp.nec.com>, Matthew Wilcox <willy@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just buy an e-SATA ExpressCard and trying on my notebook. It's able
to see the external SATA harddisk. On initial boot, I'm seeing the
following OOPS.


2010-06-14T16:43:21.077256+08:00 boston kernel: scsi 6:0:0:0:
Direct-Access     ATA      SAMSUNG MCCOE64G PS10 PQ: 0 ANSI: 5
2010-06-14T16:43:21.077258+08:00 boston kernel: sd 6:0:0:0: [sdb]
125045424 512-byte logical blocks: (64.0 GB/59.6 GiB)
2010-06-14T16:43:21.077260+08:00 boston kernel: sd 6:0:0:0: Attached
scsi generic sg1 type 0
2010-06-14T16:43:21.077261+08:00 boston kernel: sd 6:0:0:0: [sdb]
Write Protect is off
2010-06-14T16:43:21.077264+08:00 boston kernel: sd 6:0:0:0: [sdb] Mode
Sense: 00 3a 00 00
2010-06-14T16:43:21.077266+08:00 boston kernel: sd 6:0:0:0: [sdb]
Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
2010-06-14T16:43:21.077267+08:00 boston kernel: sdb: sdb1
2010-06-14T16:43:21.077268+08:00 boston kernel: sd 6:0:0:0: [sdb]
Attached SCSI disk
2010-06-14T16:43:21.077270+08:00 boston kernel: ------------[ cut here
]------------
2010-06-14T16:43:21.077272+08:00 boston kernel: WARNING: at
fs/sysfs/dir.c:451 sysfs_add_one+0x82/0x95()
2010-06-14T16:43:21.077273+08:00 boston kernel: Hardware name: 5413FGA
2010-06-14T16:43:21.077276+08:00 boston kernel: sysfs: cannot create
duplicate filename
'/devices/pci0000:00/0000:00:1c.3/0000:05:00.0/slot'
2010-06-14T16:43:21.077277+08:00 boston kernel: Modules linked in:
2010-06-14T16:43:21.077279+08:00 boston kernel: Pid: 1, comm: swapper
Not tainted 2.6.35-rc2 #69
2010-06-14T16:43:21.077280+08:00 boston kernel: Call Trace:
2010-06-14T16:43:21.077282+08:00 boston kernel: [<ffffffff8103127c>] ?
warn_slowpath_common+0x78/0x8c
2010-06-14T16:43:21.077284+08:00 boston kernel: [<ffffffff8103132f>] ?
warn_slowpath_fmt+0x45/0x4a
2010-06-14T16:43:21.077286+08:00 boston kernel: [<ffffffff810dcf35>] ?
sysfs_add_one+0x82/0x95
2010-06-14T16:43:21.077288+08:00 boston kernel: [<ffffffff810ddc58>] ?
sysfs_do_create_link+0xdd/0x151
2010-06-14T16:43:21.077291+08:00 boston kernel: [<ffffffff810dc869>] ?
sysfs_add_file_mode+0x56/0x7d
2010-06-14T16:43:21.077293+08:00 boston kernel: [<ffffffff811c82c7>] ?
pci_create_sysfs_dev_files+0x2e4/0x3f6
2010-06-14T16:43:21.077295+08:00 boston kernel: [<ffffffff8173af12>] ?
pci_sysfs_init+0x1b/0x4c
2010-06-14T16:43:21.077296+08:00 boston kernel: [<ffffffff8173aef7>] ?
pci_sysfs_init+0x0/0x4c
2010-06-14T16:43:21.077298+08:00 boston kernel: [<ffffffff810001e0>] ?
do_one_initcall+0x4f/0x149
2010-06-14T16:43:21.077300+08:00 boston kernel: [<ffffffff8171f696>] ?
kernel_init+0x14b/0x1d1
2010-06-14T16:43:21.077301+08:00 boston kernel: [<ffffffff81002ca4>] ?
kernel_thread_helper+0x4/0x10
2010-06-14T16:43:21.077303+08:00 boston kernel: [<ffffffff8171f54b>] ?
kernel_init+0x0/0x1d1
2010-06-14T16:43:21.077306+08:00 boston kernel: [<ffffffff81002ca0>] ?
kernel_thread_helper+0x0/0x10
2010-06-14T16:43:21.077307+08:00 boston kernel: ---[ end trace
962a14d7e07fcb71 ]---


A second problem relating to the ExpressCard is ejecting and inserting
the card. Every time I do so, I'm seeing the new card occupying a new
"ata" interface. See logs below ...


[Message from inserting the card ...]

2010-06-14T23:07:59.383541+08:00 boston kernel: pci 0000:05:00.0: no
hotplug settings from platform
2010-06-14T23:07:59.383541+08:00 boston kernel: pci 0000:05:00.0: no
hotplug settings from platform
2010-06-14T23:07:59.383542+08:00 boston kernel: ahci 0000:05:00.0:
enabling device (0000 -> 0003)
2010-06-14T23:07:59.383542+08:00 boston kernel: ahci 0000:05:00.0:
enabling device (0000 -> 0003)
2010-06-14T23:07:59.383544+08:00 boston kernel: ahci 0000:05:00.0: PCI
INT A -> GSI 19 (level, low) -> IRQ 19
2010-06-14T23:07:59.383544+08:00 boston kernel: ahci 0000:05:00.0: PCI
INT A -> GSI 19 (level, low) -> IRQ 19
2010-06-14T23:07:59.403405+08:00 boston kernel: ahci 0000:05:00.0:
AHCI 0001.0000 32 slots 1 ports 3 Gbps 0x1 impl SATA mode
2010-06-14T23:07:59.403436+08:00 boston kernel: ahci 0000:05:00.0:
flags: 64bit ncq pm led clo pmp pio slum part
2010-06-14T23:07:59.403442+08:00 boston kernel: ahci 0000:05:00.0:
setting latency timer to 64
2010-06-14T23:07:59.403447+08:00 boston kernel: scsi22 : ahci
2010-06-14T23:07:59.403453+08:00 boston kernel: ata20: SATA max
UDMA/133 abar m8192@0xf0000000 port 0xf0000100 irq 19
2010-06-14T23:07:59.753447+08:00 boston kernel: ata20: SATA link down
(SStatus 0 SControl 300)

[Message from ejecting the card ...]
2010-06-14T23:09:53.713399+08:00 boston kernel: ata20: failed to stop
engine (-5)
2010-06-14T23:09:53.713445+08:00 boston kernel: ahci 0000:05:00.0: PCI
INT A disabled

[Message from inserting the card ...]
2010-06-14T23:10:23.553540+08:00 boston kernel: ahci 0000:05:00.0:
enabling device (0000 -> 0003)
2010-06-14T23:10:23.553542+08:00 boston kernel: ahci 0000:05:00.0: PCI
INT A -> GSI 19 (level, low) -> IRQ 19
2010-06-14T23:10:23.583430+08:00 boston kernel: ahci 0000:05:00.0:
AHCI 0001.0000 32 slots 1 ports 3 Gbps 0x1 impl SATA mode
2010-06-14T23:10:23.583461+08:00 boston kernel: ahci 0000:05:00.0:
flags: 64bit ncq pm led clo pmp pio slum part
2010-06-14T23:10:23.583465+08:00 boston kernel: ahci 0000:05:00.0:
setting latency timer to 64
2010-06-14T23:10:23.583468+08:00 boston kernel: scsi23 : ahci
2010-06-14T23:10:23.583474+08:00 boston kernel: ata21: SATA max
UDMA/133 abar m8192@0xf0000000 port 0xf0000100 irq 19
2010-06-14T23:10:23.583465+08:00 boston kernel: ahci 0000:05:00.0:
setting latency timer to 64
2010-06-14T23:10:23.583468+08:00 boston kernel: scsi23 : ahci
2010-06-14T23:10:23.583474+08:00 boston kernel: ata21: SATA max
UDMA/133 abar m8192@0xf0000000 port 0xf0000100 irq 19
2010-06-14T23:10:23.913441+08:00 boston kernel: ata21: SATA link down
(SStatus 0 SControl 300)

[Message from ejecting the card ...]
2010-06-14T23:10:44.413404+08:00 boston kernel: ata21: failed to stop
engine (-5)
2010-06-14T23:10:44.413434+08:00 boston kernel: ahci 0000:05:00.0: PCI
INT A disabled


It looks like it failed to stop the sata interface. Or perhaps I be
asking ... is there a utility to stop the interface before pulling off
the card?

And often, inserting the card does not make the kernel detect the
event that the card has been inserted. I've to try a few times before
seeing any message. I've disabled rsyslog so that it shows repeated
logs.

I'm testing it on Linux-2.6.35-rc2, but I think it's happening on
older versions as well. I'm using CONFIG_HOTPLUG_PCI_ACPI so that it
can detect the hotplug events on my X201s Lenovo notebook.


Thanks,
Jeff
