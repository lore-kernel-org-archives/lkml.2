Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758488Ab1FPUku (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 16:40:50 -0400
Received: from extranet.aprogsys.com ([91.121.73.63]:40269 "EHLO
	extranet.aprogsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754720Ab1FPUkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 16:40:45 -0400
X-Greylist: delayed 377 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Jun 2011 16:40:44 EDT
From: Vincent ETIENNE <ve@vetienne.net>
To: linux-kernel@vger.kernel.org
Subject: [btrfs] BUG at fs/btrfs/inode.c:4574! with 3.0.0-rc3-00055-gada9c93
Date: Thu, 16 Jun 2011 22:34:10 +0200
Message-ID: <4104372.Sh7o590mSo@jupiter>
User-Agent: KMail/4.6.0 (Linux/3.0.0-rc3-00055-gada9c93; KDE/4.6.4; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After a hard power failure (storm ) and a couurpted btrfs partition, next 
reboot show this

[   14.468140] kernel BUG at fs/btrfs/inode.c:4574!
[   14.468161] invalid opcode: 0000 [#1] PREEMPT SMP
[   14.468203] CPU 4
[   14.468214] Modules linked in: btrfs crc32c libcrc32c uvcvideo videodev 
v4l2_compat_ioctl32 firewire_ohci firewire_core crc_itu_t iTCO_wdt radeon ttm 
drm_kms_helper backlight cfbcopyarea power_supply cfbimgblt cfbfillrect$
[   14.468404]
[   14.468416] Pid: 2085, comm: mount Not tainted 3.0.0-rc3-00055-gada9c93 #67 
System manufacturer System Product Name/P6T DELUXE
[   14.468471] RIP: 0010:[<ffffffffa0202121>]  [<ffffffffa0202121>] 
btrfs_add_link+0x161/0x1c0 [btrfs]
[   14.468523] RSP: 0018:ffff880076fdd7c8  EFLAGS: 00010282
[   14.468546] RAX: 00000000ffffffef RBX: ffff88007446e770 RCX: 0000000000011ff4
[   14.468574] RDX: 0000000000011fe4 RSI: 000060ff830038b0 RDI: ffffea00019e0a00
[   14.468601] RBP: ffff880076fdd838 R08: ffff88007b600000 R09: 0000000000000000
[   14.468629] R10: ffff880078250730 R11: 0000000000000000 R12: ffff88007446df20
[   14.468657] R13: ffff880076db1000 R14: 000000000000000b R15: ffff880078e33000
[   14.468685] FS:  00007f730e116740(0000) GS:ffff88007b600000(0000) 
knlGS:0000000000000000
[   14.468717] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   14.468740] CR2: 00007f507c89bf80 CR3: 0000000078380000 CR4: 
00000000000006e0
[   14.468768] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[   14.468796] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   14.468823] Process mount (pid: 2085, threadinfo ffff880076fdc000, task 
ffff880078250000)
[   14.468854] Stack:
[   14.468866]  ffff880000000001 000000000000548e ffff880076fddfd8 
000000000000548e
[   14.468913]  ffff880078fc18c0 abff880077ec2000 0100000000005193 
0000000000000000
[   14.468959]  0000000000001000 0000000000000000 0000000000000097 
ffff880076fddaf0
[   14.469005] Call Trace:
[   14.469026]  [<ffffffffa022b201>] add_inode_ref+0x311/0x3d0 [btrfs]
[   14.469060]  [<ffffffffa022cfab>] replay_one_buffer+0x2cb/0x3c0 [btrfs]
[   14.469094]  [<ffffffffa0219b34>] ? alloc_extent_buffer+0xc4/0x500 [btrfs]
[   14.469130]  [<ffffffffa0219a70>] ? try_release_extent_mapping+0x190/0x190 
[btrfs]
[   14.469168]  [<ffffffffa021b763>] ? unmap_extent_buffer+0x13/0x40 [btrfs]
[   14.469203]  [<ffffffffa022bf09>] walk_down_log_tree+0x3a9/0x550 [btrfs]
[   14.469238]  [<ffffffffa022c1b5>] walk_log_tree+0x105/0x290 [btrfs]
[   14.469266]  [<ffffffff81505655>] ? _raw_spin_unlock+0x35/0x60
[   14.469299]  [<ffffffffa022e255>] btrfs_recover_log_trees+0x205/0x2f0 [btrfs]
[   14.469335]  [<ffffffffa022cce0>] ? fixup_inode_link_counts+0x150/0x150 [btrfs]
  14.469371]  [<ffffffffa01f438b>] open_ctree+0x145b/0x1800 [btrfs]
[   14.469399]  [<ffffffff8123ce00>] ? vsnprintf+0x470/0x600
[   14.469423]  [<ffffffff8118af31>] ? disk_name+0x61/0xc0
[   14.469450]  [<ffffffffa01ce6fe>] btrfs_mount+0x41e/0x5d0 [btrfs]
[   14.469478]  [<ffffffff811268a3>] mount_fs+0x43/0x1b0
[   14.469501]  [<ffffffff810fd720>] ? __alloc_percpu+0x10/0x20
[   14.469526]  [<ffffffff81140fea>] vfs_kern_mount+0x6a/0xd0
[   14.469550]  [<ffffffff81142494>] do_kern_mount+0x54/0x110
[   14.469574]  [<ffffffff81143bb4>] do_mount+0x1a4/0x850
[   14.469597]  [<ffffffff810f8216>] ? memdup_user+0x46/0x80
[   14.469620]  [<ffffffff810f82ab>] ? strndup_user+0x5b/0x80
[   14.469644]  [<ffffffff81144628>] sys_mount+0x98/0xf0
[   14.469667]  [<ffffffff815065ab>] system_call_fastpath+0x16/0x1b
[   14.469692] Code: 44 89 f1 4c 89 ee 4c 89 ff 4c 89 1c 24 4c 89 55 a8 4c 89 
5d a0 e8 d0 aa fe ff 4c 8b 5d a0 4c 8b 55 a8 85 c0 75 b4 e9 2d ff ff ff <0f> 0b 49 
8b b4 24 50 fc ff ff 48 8d 7d bf 4d 89 d9 b9 11 00 00
[   14.470158] RIP  [<ffffffffa0202121>] btrfs_add_link+0x161/0x1c0 [btrfs]
[   14.470198]  RSP <ffff880076fdd7c8>
[   14.472216] ---[ end trace 471d6a6668c5cb35 ]---

Have try some older kernel lying on my boot partition

Same with 3.0.0-rc2, 2.6.39, 2.6.39-rc2-00120-g94c8a98

Problem persist until i reboot with 2.6.38-08826-g1788c20 kernel where the 
partition has been corrected :

Jun 16 21:29:05 [kernel] [   16.641459] btrfs: unlinked 9 orphans
Jun 16 21:29:05 [kernel] [   16.641463] btrfs: truncated 15 orphans

So it looks like a regression appeared in 2.6.39 and not corrected for the 
moment ( more accurately between 2.6.38-08826-g1788c20 and 2.6.39-rc2-00120-
g94c8a98

As the partition is now correct I will not be able to reproduce the problem 
and bisect it more ( That's on my home PC so i have to admit that i would 
prefer not to have to force corruption by doing hard power failure on it... ). 

I hope this few data could be of some help

	Vincent

 

















