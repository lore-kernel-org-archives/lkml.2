Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445Ab1JPAGx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 20:06:53 -0400
Received: from lucidpixels.com ([72.73.18.11]:49815 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753264Ab1JPAGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 20:06:52 -0400
Date: Sat, 15 Oct 2011 20:06:51 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
cc: linux-mm@vger.kernel.org
Subject: 3.1-rc9: BUG: soft lockup in find_get_pages+0x4e/0x140
Message-ID: <alpine.DEB.2.02.1110152003210.26507@p34.internal.lan>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

With 3.1-rc9 during a filesystem dump, this occurred, I thought a previous 
patch fixed this but it did not, it occurs MUCH less (first time in a 
couple of weeks) but the problem still occurs.

Thoughts?

[675100.763357] BUG: soft lockup - CPU#0 stuck for 22s! [dump:11066]
[675100.763361] CPU 0 
[675100.763364] Pid: 11066, comm: dump Not tainted 3.1.0-rc9 #1 Supermicro X8DTH-i/6/iF/6F/X8DTH
[675100.763368] RIP: 0010:[<ffffffff81078eee>]  [<ffffffff81078eee>] find_get_pages+0x4e/0x140
[675100.763375] RSP: 0018:ffff8806e6603d28  EFLAGS: 00000246
[675100.763377] RAX: ffff880019a0a210 RBX: ffffea0028a65820 RCX: 000000000000000e
[675100.763379] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffea0029e0faf0
[675100.763381] RBP: 0000000001200ae9 R08: 0000000000000000 R09: ffff8806e6603ce8
[675100.763383] R10: 0000000001200b03 R11: 0000000000000002 R12: ffffffff810805a4
[675100.763386] R13: ffff880c3fffae00 R14: ffff880c3fffae00 R15: ffff8806e6603db8
[675100.763392] FS:  00007fe9b56cc760(0000) GS:ffff88063fc00000(0000) knlGS:0000000000000000
[675100.763395] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[675100.763397] CR2: 00007f2da3718fa8 CR3: 0000000c22da4000 CR4: 00000000000006f0
[675100.763400] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[675100.763402] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[675100.763405] Process dump (pid: 11066, threadinfo ffff8806e6602000, task ffff880c21c931a0)
[675100.763407] Stack:
[675100.763408]  ffff8800398aaa88 0000000000000000 ffff88063fc0d560 0000000000000005
[675100.763415]  ffff880c270652d8 ffff8806e6603da8 00000000000067b5 ffffffffffffffff
[675100.763421]  ffff880c270652d8 ffffea0028a65820 000000000000000d ffffffff81083d15
[675100.763427] Call Trace:
[675100.763433]  [<ffffffff81083d15>] ? pagevec_lookup+0x15/0x20
[675100.763437]  [<ffffffff810843c6>] ? invalidate_mapping_pages+0x66/0x170
[675100.763442]  [<ffffffff812bc841>] ? blkdev_ioctl+0x6b1/0x700
[675100.763451]  [<ffffffff810e405b>] ? block_ioctl+0x3b/0x50
[675100.763455]  [<ffffffff810c692e>] ? do_vfs_ioctl+0x8e/0x4f0
[675100.763459]  [<ffffffff810c6dd9>] ? sys_ioctl+0x49/0x80
[675100.763464]  [<ffffffff8168b17b>] ? system_call_fastpath+0x16/0x1b
[675100.763466] Code: 48 89 de 4c 89 ef e8 72 37 25 00 85 c0 89 c1 0f 84 a8 00 00 00 49 89 df 31 d2 31 f6 45 31 f6 66 0f 1f 44 00 00 49 8b 07 48 8b 38 
[675100.763484]  85 ff 74 3e 40 f6 c7 03 75 5e 44 8b 47 1c 45 85 c0 74 ec 45 
[675100.763497] Call Trace:
[675100.763500]  [<ffffffff81083d15>] ? pagevec_lookup+0x15/0x20
[675100.763503]  [<ffffffff810843c6>] ? invalidate_mapping_pages+0x66/0x170
[675100.763507]  [<ffffffff812bc841>] ? blkdev_ioctl+0x6b1/0x700
[675100.763510]  [<ffffffff810e405b>] ? block_ioctl+0x3b/0x50
[675100.763513]  [<ffffffff810c692e>] ? do_vfs_ioctl+0x8e/0x4f0
[675100.763516]  [<ffffffff810c6dd9>] ? sys_ioctl+0x49/0x80
[675100.763519]  [<ffffffff8168b17b>] ? system_call_fastpath+0x16/0x1b
[675101.484164] BUG: soft lockup - CPU#10 stuck for 23s! [dump:11068]
[675101.484167] CPU 10 
[675101.484170] Pid: 11068, comm: dump Not tainted 3.1.0-rc9 #1 Supermicro X8DTH-i/6/iF/6F/X8DTH
[675101.484173] RIP: 0010:[<ffffffff81078eee>]  [<ffffffff81078eee>] find_get_pages+0x4e/0x140
[675101.484180] RSP: 0018:ffff880bf713dd28  EFLAGS: 00000246
[675101.484182] RAX: ffff8800ae90af00 RBX: ffffea00190d1288 RCX: 000000000000000e
[675101.484183] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffea0019046600
[675101.484185] RBP: 0000000000900eef R08: 0000000000000000 R09: ffff880bf713dce8
[675101.484186] R10: 0000000000900efd R11: 000000000000000d R12: ffffffff810805a4
[675101.484188] R13: ffff880c3fffae00 R14: ffff880c3fffae00 R15: ffff880bf713ddb8
[675101.484190] FS:  00007fe9b56cc760(0000) GS:ffff880c3fc80000(0000) knlGS:0000000000000000
[675101.484192] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[675101.484193] CR2: 00007f1577baefc8 CR3: 0000000bc3458000 CR4: 00000000000006e0
[675101.484195] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[675101.484196] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[675101.484198] Process dump (pid: 11068, threadinfo ffff880bf713c000, task ffff880c25b2e310)
[675101.484199] Stack:
[675101.484201]  ffff88003b6f6bc0 000000000000000a ffff880c3fc8d560 0000000000000005
[675101.484204]  ffff880c270652d8 ffff880bf713dda8 00000000000009f2 ffffffffffffffff
[675101.484208]  ffff880c270652d8 ffffea00190d1288 000000000000000d ffffffff81083d15
[675101.484211] Call Trace:
[675101.484217]  [<ffffffff81083d15>] ? pagevec_lookup+0x15/0x20
[675101.484220]  [<ffffffff810843c6>] ? invalidate_mapping_pages+0x66/0x170
[675101.484226]  [<ffffffff812bc841>] ? blkdev_ioctl+0x6b1/0x700
[675101.484230]  [<ffffffff810e405b>] ? block_ioctl+0x3b/0x50
[675101.484234]  [<ffffffff810c692e>] ? do_vfs_ioctl+0x8e/0x4f0
[675101.484238]  [<ffffffff810c6dd9>] ? sys_ioctl+0x49/0x80
[675101.484242]  [<ffffffff8168b17b>] ? system_call_fastpath+0x16/0x1b
[675101.484243] Code: 48 89 de 4c 89 ef e8 72 37 25 00 85 c0 89 c1 0f 84 a8 00 00 00 49 89 df 31 d2 31 f6 45 31 f6 66 0f 1f 44 00 00 49 8b 07 48 8b 38 
[675101.484257]  85 ff 74 3e 40 f6 c7 03 75 5e 44 8b 47 1c 45 85 c0 74 ec 45 
[675101.484263] Call Trace:
[675101.484266]  [<ffffffff81083d15>] ? pagevec_lookup+0x15/0x20
[675101.484268]  [<ffffffff810843c6>] ? invalidate_mapping_pages+0x66/0x170
[675101.484272]  [<ffffffff812bc841>] ? blkdev_ioctl+0x6b1/0x700
[675101.484275]  [<ffffffff810e405b>] ? block_ioctl+0x3b/0x50
[675101.484277]  [<ffffffff810c692e>] ? do_vfs_ioctl+0x8e/0x4f0
[675101.484279]  [<ffffffff810c6dd9>] ? sys_ioctl+0x49/0x80
[675101.484282]  [<ffffffff8168b17b>] ? system_call_fastpath+0x16/0x1b

Justin.
