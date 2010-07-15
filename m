Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932853Ab0GOJMT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 05:12:19 -0400
Received: from 2605ds1-ynoe.0.fullrate.dk ([90.184.12.24]:56763 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932755Ab0GOJMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 05:12:17 -0400
X-Greylist: delayed 504 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Jul 2010 05:12:16 EDT
Message-ID: <e35163195d2e64bc525804893219de09.squirrel@shrek.krogh.cc>
Date: Thu, 15 Jul 2010 11:03:46 +0200 (CEST)
Subject: tpc-srv/tcp: nfsd: got error -104 when sending 116 bytes - 
     shutting down socket
From: jesper@krogh.cc
To: "Trond Myklebust" <Trond.Myklebust@netapp.com>
Cc: linux-kernel@vger.kernel.org, "Jens Axboe" <jens.axboe@oracle.com>,
        "Catalin Marinas" <catalin.marinas@arm.com>, "Jan Kara" <jack@suse.cz>,
        "Wu Fengguang" <fengguang.wu@intel.com>
User-Agent: SquirrelMail/1.4.15
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

I have been testing 2.6.33.5 in production and when getting a moderate NFS
load it end up by "hanging" itself. The last message in the log is:

rpc-srv/tcp: nfsd: got error -104 when sending 116 bytes - shutting down
socket

Prior to that. (say 24 hours of good operation) it stalled for some
minutes and send this into the logfile:

Jun 27 09:59:24 kat kernel: [330874.618403] Modules linked in: nfsd
exportfs autofs4 nfs lockd auth_rpcgss sunrpc bonding ipv6 iptable_filter
ip_tables x_tables ext4 jbd2 crc16 parport_pc lp parport loop psmouse
tpm_tis tpm tpm_bios serio_raw pcspkr k8temp shpchp pci_hotplug
i2c_nforce2 i2c_core button processor evdev joydev dm_multipath dm_mod
ext3 jbd mbcache sr_mod sd_mod sg ide_cd_mod cdrom usb_storage
usb_libusual usbhid hid amd74xx ehci_hcd ohci_hcd megaraid_sas mptsas
mptscsih mptbase ata_generic scsi_transport_sas qla2xxx scsi_transport_fc
libata e1000 scsi_mod usbcore thermal fan thermal_sys fuse
Jun 27 09:59:24 kat kernel: [330874.618403] CPU 15
Jun 27 09:59:24 kat kernel: [330874.618403] Pid: 6587, comm: nfsiod Not
tainted 2.6.33.5 #7 Sun Fire X4600 M2/Sun Fire X4600 M2
Jun 27 09:59:24 kat kernel: [330874.618403] RIP: 0010:[<ffffffff812eb412>]
 [<ffffffff812eb412>] _raw_spin_lock+0x12/0x20
Jun 27 09:59:24 kat kernel: [330874.618403] RSP: 0018:ffff8801fe9afde8 
EFLAGS: 00000297
Jun 27 09:59:24 kat kernel: [330874.618403] RAX: 0000000000002f2b RBX:
ffff8808698147e8 RCX: 0000000000000001
Jun 27 09:59:24 kat kernel: [330874.618403] RDX: ffff88084acd0c00 RSI:
ffffffffa04d52c0 RDI: ffff880869814894
Jun 27 09:59:24 kat kernel: [330874.618403] RBP: ffffffff8100358e R08:
0000000000000000 R09: ffff8801f6408048
Jun 27 09:59:24 kat kernel: [330874.618403] R10: ffff880e074136d8 R11:
0000000000000000 R12: 0000000352c3a300
Jun 27 09:59:24 kat kernel: [330874.618403] R13: ffffffff8102ae0b R14:
ffff88080720b348 R15: ffffffff81059f99
Jun 27 09:59:24 kat kernel: [330874.618403] FS:  00007f77cf53c700(0000)
GS:ffff880e07500000(0000) knlGS:00000000f76426b0
Jun 27 09:59:24 kat kernel: [330874.618403] CS:  0010 DS: 0000 ES: 0000
CR0: 000000008005003b
Jun 27 09:59:24 kat kernel: [330874.618403] CR2: 00007f09d9c2a288 CR3:
00000000014ba000 CR4: 00000000000006e0
Jun 27 09:59:24 kat kernel: [330874.618403] DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Jun 27 09:59:24 kat kernel: [330874.618403] DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
Jun 27 09:59:24 kat kernel: [330874.618403] Process nfsiod (pid: 6587,
threadinfo ffff8801fe9ae000, task ffff8801ff3ed400)
Jun 27 09:59:24 kat kernel: [330874.618403]  ffffffffa04d8924
ffff88084acd0b80 ffff880c328ad100 ffffea001fe1ea20
Jun 27 09:59:24 kat kernel: [330874.618403] <0> ffffffffa04da52f
ffff8801ff3ed400 ffff880c328ad1b0 ffffe8f220a0fc40
Jun 27 09:59:24 kat kernel: [330874.618403] <0> ffff8805feaf7d80
ffff8801ff3ed400 ffffffffa0450d00 ffffe8f220a0fc48
Jun 27 09:59:24 kat kernel: [330874.722405]  [<ffffffffa04d8924>] ?
nfs_mark_request_commit+0x34/0xc0 [nfs]
Jun 27 09:59:24 kat kernel: [330874.722405]  [<ffffffffa04da52f>] ?
nfs_writeback_release_full+0x4f/0x190 [nfs]
Jun 27 09:59:24 kat kernel: [330874.722405]  [<ffffffffa0450d00>] ?
rpc_async_release+0x0/0x10 [sunrpc]
Jun 27 09:59:24 kat kernel: [330874.722405]  [<ffffffff81056ac2>] ?
worker_thread+0x152/0x250
Jun 27 09:59:24 kat kernel: [330874.722405]  [<ffffffff81059f90>] ?
autoremove_wake_function+0x0/0x30
Jun 27 09:59:24 kat kernel: [330874.722405]  [<ffffffff81056970>] ?
worker_thread+0x0/0x250
Jun 27 09:59:24 kat kernel: [330874.722405]  [<ffffffff81059c26>] ?
kthread+0x96/0xa0
Jun 27 09:59:24 kat kernel: [330874.722405]  [<ffffffff810039d4>] ?
kernel_thread_helper+0x4/0x10
Jun 27 09:59:24 kat kernel: [330874.722405]  [<ffffffff81059b90>] ?
kthread+0x0/0xa0
Jun 27 09:59:24 kat kernel: [330874.722405]  [<ffffffff810039d0>] ?
kernel_thread_helper+0x0/0x10
Jun 27 09:59:24 kat kernel: [330874.914399] Call Trace:
Jun 27 09:59:24 kat kernel: [330874.914399]  [<ffffffffa04d8924>] ?
nfs_mark_request_commit+0x34/0xc0 [nfs]
Jun 27 09:59:24 kat kernel: [330874.914399]  [<ffffffffa04da52f>] ?
nfs_writeback_release_full+0x4f/0x190 [nfs]
Jun 27 09:59:24 kat kernel: [330874.914399]  [<ffffffffa0450d00>] ?
rpc_async_release+0x0/0x10 [sunrpc]
Jun 27 09:59:24 kat kernel: [330874.914399]  [<ffffffff81056ac2>] ?
worker_thread+0x152/0x250
Jun 27 09:59:24 kat kernel: [330874.914399]  [<ffffffff81059f90>] ?
autoremove_wake_function+0x0/0x30
Jun 27 09:59:24 kat kernel: [330874.914399]  [<ffffffff81056970>] ?
worker_thread+0x0/0x250
Jun 27 09:59:24 kat kernel: [330874.914399]  [<ffffffff81059c26>] ?
kthread+0x96/0xa0
Jun 27 09:59:24 kat kernel: [330874.914399]  [<ffffffff810039d4>] ?
kernel_thread_helper+0x4/0x10
Jun 27 09:59:24 kat kernel: [330874.914399]  [<ffffffff81059b90>] ?
kthread+0x0/0xa0
Jun 27 09:59:24 kat kernel: [330874.914399]  [<ffffffff810039d0>] ?
kernel_thread_helper+0x0/0x10
Jun 27 09:59:27 kat kerneloops: Submitted 1 kernel oopses to
www.kerneloops.org


Just prior to "hanging" these traces show up in the log files.

Jul 15 10:18:52 kat kernel: [957124.371899] kswapd0       D
ffff8801ff1d6278     0   523      2 0x00000000
Jul 15 10:18:52 kat kernel: [957124.371905]  ffffffff814c2020
0000000000000046 0000000000000000 0000000000000001
Jul 15 10:18:52 kat kernel: [957124.371908]  0000000000000000
ffff8801fea81fd8 ffff8801ff1d6000 0000000000004000
Jul 15 10:18:52 kat kernel: [957124.371911]  000000000000df48
0000000000013680 ffff8801fea81fd8 ffff8801fea81fd8
Jul 15 10:18:52 kat kernel: [957124.371914] Call Trace:
Jul 15 10:18:52 kat kernel: [957124.371952]  [<ffffffffa04ce250>] ?
nfs_wait_bit_uninterruptible+0x0/0x10 [nfs]
Jul 15 10:18:52 kat kernel: [957124.371960]  [<ffffffff812e9b2f>] ?
io_schedule+0x3f/0x60
Jul 15 10:18:52 kat kernel: [957124.371968]  [<ffffffffa04ce259>] ?
nfs_wait_bit_uninterruptible+0x9/0x10 [nfs]
Jul 15 10:18:52 kat kernel: [957124.371970]  [<ffffffff812e9faf>] ?
__wait_on_bit+0x4f/0x80
Jul 15 10:18:52 kat kernel: [957124.371977]  [<ffffffffa04ce250>] ?
nfs_wait_bit_uninterruptible+0x0/0x10 [nfs]
Jul 15 10:18:52 kat kernel: [957124.371980]  [<ffffffff812ea05a>] ?
out_of_line_wait_on_bit+0x7a/0xa0
Jul 15 10:18:52 kat kernel: [957124.371986]  [<ffffffff81059fc0>] ?
wake_bit_function+0x0/0x30
Jul 15 10:18:52 kat kernel: [957124.371994]  [<ffffffffa04d29a1>] ?
nfs_sync_mapping_wait+0x111/0x260 [nfs]
Jul 15 10:18:52 kat kernel: [957124.372002]  [<ffffffffa04d2b67>] ?
nfs_wb_page+0x77/0xe0 [nfs]
Jul 15 10:18:52 kat kernel: [957124.372008]  [<ffffffff810a5223>] ?
__remove_from_page_cache+0x33/0xb0
Jul 15 10:18:52 kat kernel: [957124.372014]  [<ffffffffa04c30f5>] ?
nfs_release_page+0x55/0x70 [nfs]
Jul 15 10:18:52 kat kernel: [957124.372018]  [<ffffffff810afd42>] ?
shrink_page_list+0x572/0x6d0
Jul 15 10:18:52 kat kernel: [957124.372021]  [<ffffffff810aeba3>] ?
isolate_pages_global+0x183/0x280
Jul 15 10:18:52 kat kernel: [957124.372024]  [<ffffffff810b0573>] ?
shrink_zone+0x6d3/0xac0
Jul 15 10:18:52 kat kernel: [957124.372027]  [<ffffffff812e904c>] ?
schedule+0x2bc/0xa80
Jul 15 10:18:52 kat kernel: [957124.372030]  [<ffffffff810b1846>] ?
kswapd+0x536/0x690
Jul 15 10:18:52 kat kernel: [957124.372032]  [<ffffffff810aea20>] ?
isolate_pages_global+0x0/0x280
Jul 15 10:18:52 kat kernel: [957124.372035]  [<ffffffff81059f90>] ?
autoremove_wake_function+0x0/0x30
Jul 15 10:18:52 kat kernel: [957124.372039]  [<ffffffff8102ae0b>] ?
__wake_up_common+0x5b/0x90
Jul 15 10:18:52 kat kernel: [957124.372041]  [<ffffffff810b1310>] ?
kswapd+0x0/0x690
Jul 15 10:18:52 kat kernel: [957124.372044]  [<ffffffff81059c26>] ?
kthread+0x96/0xa0
Jul 15 10:18:52 kat kernel: [957124.372050]  [<ffffffff810039d4>] ?
kernel_thread_helper+0x4/0x10
Jul 15 10:18:52 kat kernel: [957124.372053]  [<ffffffff81059b90>] ?
kthread+0x0/0xa0
Jul 15 10:18:52 kat kernel: [957124.372055]  [<ffffffff810039d0>] ?
kernel_thread_helper+0x0/0x10
Jul 15 10:18:52 kat kernel: [957124.544754] kswapd1       D
ffff8801ff1d6878     0   524      2 0x00000000
Jul 15 10:18:52 kat kernel: [957124.544758]  ffff8805ff02e000
0000000000000046 ffff8801ff1d6600 0000000000000001
Jul 15 10:18:52 kat kernel: [957124.544760]  ffff8801fea837e0
ffff8801fea83fd8 ffff8801ff1d6600 0000000000004000
Jul 15 10:18:52 kat kernel: [957124.544763]  000000000000df48
0000000000013680 ffff8801fea83fd8 ffff8801fea83fd8
Jul 15 10:18:52 kat kernel: [957124.544766] Call Trace:
Jul 15 10:18:52 kat kernel: [957124.544770]  [<ffffffff8118c4d9>] ?
cfq_add_rq_rb+0x99/0xf0
Jul 15 10:18:52 kat kernel: [957124.544778]  [<ffffffffa04ce250>] ?
nfs_wait_bit_uninterruptible+0x0/0x10 [nfs]
Jul 15 10:18:52 kat kernel: [957124.544780]  [<ffffffff812e9b2f>] ?
io_schedule+0x3f/0x60
Jul 15 10:18:52 kat kernel: [957124.544787]  [<ffffffffa04ce259>] ?
nfs_wait_bit_uninterruptible+0x9/0x10 [nfs]
Jul 15 10:18:52 kat kernel: [957124.544789]  [<ffffffff812e9faf>] ?
__wait_on_bit+0x4f/0x80
Jul 15 10:18:52 kat kernel: [957124.544796]  [<ffffffffa04ce250>] ?
nfs_wait_bit_uninterruptible+0x0/0x10 [nfs]
Jul 15 10:18:52 kat kernel: [957124.544798]  [<ffffffff812ea05a>] ?
out_of_line_wait_on_bit+0x7a/0xa0
Jul 15 10:18:52 kat kernel: [957124.544801]  [<ffffffff81059fc0>] ?
wake_bit_function+0x0/0x30
Jul 15 10:18:52 kat kernel: [957124.544808]  [<ffffffffa04d29a1>] ?
nfs_sync_mapping_wait+0x111/0x260 [nfs]
Jul 15 10:18:52 kat kernel: [957124.544816]  [<ffffffffa04d2b67>] ?
nfs_wb_page+0x77/0xe0 [nfs]
Jul 15 10:18:52 kat kernel: [957124.544820]  [<ffffffff810a9786>] ?
__pagevec_free+0x56/0xa0
Jul 15 10:18:52 kat kernel: [957124.544826]  [<ffffffffa04c30f5>] ?
nfs_release_page+0x55/0x70 [nfs]
Jul 15 10:18:52 kat kernel: [957124.544829]  [<ffffffff810afd42>] ?
shrink_page_list+0x572/0x6d0
Jul 15 10:18:52 kat kernel: [957124.544831]  [<ffffffff810aeba3>] ?
isolate_pages_global+0x183/0x280
Jul 15 10:18:52 kat kernel: [957124.544834]  [<ffffffff810b0573>] ?
shrink_zone+0x6d3/0xac0
Jul 15 10:18:52 kat kernel: [957124.544838]  [<ffffffff8104bf44>] ?
lock_timer_base+0x34/0x70
Jul 15 10:18:52 kat kernel: [957124.544841]  [<ffffffff8104bfc3>] ?
try_to_del_timer_sync+0x43/0xe0
Jul 15 10:18:52 kat kernel: [957124.544844]  [<ffffffff810b1846>] ?
kswapd+0x536/0x690
Jul 15 10:18:52 kat kernel: [957124.544846]  [<ffffffff810aea20>] ?
isolate_pages_global+0x0/0x280
Jul 15 10:18:52 kat kernel: [957124.544849]  [<ffffffff81059f90>] ?
autoremove_wake_function+0x0/0x30
Jul 15 10:18:52 kat kernel: [957124.544851]  [<ffffffff8102ae0b>] ?
__wake_up_common+0x5b/0x90
Jul 15 10:18:52 kat kernel: [957124.544853]  [<ffffffff810b1310>] ?
kswapd+0x0/0x690
Jul 15 10:18:52 kat kernel: [957124.544856]  [<ffffffff81059c26>] ?
kthread+0x96/0xa0
Jul 15 10:18:52 kat kernel: [957124.544859]  [<ffffffff810039d4>] ?
kernel_thread_helper+0x4/0x10
Jul 15 10:18:52 kat kernel: [957124.544861]  [<ffffffff81059b90>] ?
kthread+0x0/0xa0
Jul 15 10:18:52 kat kernel: [957124.544863]  [<ffffffff810039d0>] ?
kernel_thread_helper+0x0/0x10

The machine is a 16 core (8 x 2 ) AMD with 64GB of memory.

I've seen the same pattern 4-5 times on 2.6.33.6


