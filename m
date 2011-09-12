Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065Ab1ILHwh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 03:52:37 -0400
Received: from lucidpixels.com ([72.73.18.11]:36207 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287Ab1ILHwg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 03:52:36 -0400
Date: Mon, 12 Sep 2011 03:52:35 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
cc: Alan Piszcz <ap@solarrain.com>, mlin@ss.pku.edu.cn
Subject: Re: 3.0.1: pagevec_lookup+0x1d/0x30, SLAB issues? [again w/DEBUG_VM
 & SLAB_DEBUG enabled]
In-Reply-To: <alpine.DEB.2.02.1109111837200.19558@p34.internal.lan>
Message-ID: <alpine.DEB.2.02.1109120351470.16088@p34.internal.lan>
References: <alpine.DEB.2.02.1109111815520.19558@p34.internal.lan> <alpine.DEB.2.02.1109111837200.19558@p34.internal.lan>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 11 Sep 2011, Justin Piszcz wrote:

>
>
> On Sun, 11 Sep 2011, Justin Piszcz wrote:
>
>> Hi,
>> 
>> With 3.0.1 now and all options compiled in and threadirqs removed, I get 
>> the same error this user is seeing:
>> http://www.gossamer-threads.com/lists/linux/kernel/1424997
>> 
>
> Hello Lin,
>
> I missed your mail (sender IP is in a CIDR blacklist), disabled & whitelisted 
> for now:
> http://marc.info/?l=linux-kernel&m=131567477126674&w=2
>
> I've enabled this and I will post a new e-mail / output if it happens
> again with debug enabled for SLAB.
>
> Response to your e-mail:
>
>> Could you tell how to reproduce this?
> Running a lot of processes at the same time (memory/cpu+i/o)
>
>> And would you please turn on more debug options to capture more info?
> Yup, done now; however, I am using SLAB, not SLUB; so I've enabled:
>
> -> [*] Debug slab memory allocations -> [*]   Memory leak debugging -> [*] 
> Debug VM
>
>> CONFIG_SLUB_DEBUG=y
>> CONFIG_SLUB_DEBUG_ON=y
>> CONFIG_DEBUG_VM=y
>
> Please let me know if there are any other options you think would be useful
> to enable or if this should be good, if it recurs again-- as noted above
> I will post an update.
>
> Justin.
>

Hi,

With the debug options enabled as mentioned above:

[27336.007038] BUG: soft lockup - CPU#9 stuck for 22s! [kswapd1:1045]
[27336.007043] CPU 9 
[27336.007047] Pid: 1045, comm: kswapd1 Not tainted 3.0.1 #7 Supermicro X8DTH-i/6/iF/6F/X8DTH
[27336.007053] RIP: 0010:[<ffffffff8107a981>]  [<ffffffff8107a981>] find_get_pages+0x61/0x150
[27336.007062] RSP: 0018:ffff880626783b50  EFLAGS: 00000246
[27336.007065] RAX: 0000000000000000 RBX: ffff880626783ba0 RCX: 0000000000000000
[27336.007067] RDX: 0000000000000000 RSI: 000000000000000e RDI: ffffea000f617890
[27336.007070] RBP: ffff880626783ba0 R08: 0000000000000000 R09: 000000000000000a
[27336.007072] R10: 0000000000000009 R11: ffff8803badfde18 R12: ffffffff816481ce
[27336.007075] R13: ffffffff810821cd R14: ffff880626783ad0 R15: ffff88063fffbe00
[27336.007078] FS:  0000000000000000(0000) GS:ffff880c3fc60000(0000) knlGS:0000000000000000
[27336.007081] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[27336.007084] CR2: 00007fbaef0fc000 CR3: 0000000001a43000 CR4: 00000000000006e0
[27336.007086] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[27336.007089] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[27336.007092] Process kswapd1 (pid: 1045, threadinfo ffff880626782000, task ffff880626d2a840)
[27336.007094] Stack:
[27336.007096]  ffff880c3fc6d520 0000000000000005 ffff880070743320 ffff880070743328
[27336.007103]  ffff880626783ba0 ffff880626783be0 000000000000041c ffffffffffffffff
[27336.007108]  ffff880070743320 ffffea000f617820 ffff880626783bc0 ffffffff8108597d
[27336.007114] Call Trace:
[27336.007121]  [<ffffffff8108597d>] pagevec_lookup+0x1d/0x30
[27336.007125]  [<ffffffff8108607f>] invalidate_mapping_pages+0x5f/0x170
[27336.007132]  [<ffffffff810d37b5>] shrink_icache_memory+0x2d5/0x320
[27336.007139]  [<ffffffff81086f5d>] shrink_slab+0x11d/0x190
[27336.007144]  [<ffffffff81089d6a>] balance_pgdat+0x4fa/0x6a0
[27336.007148]  [<ffffffff81089fc3>] kswapd+0xb3/0x250
[27336.007153]  [<ffffffff8104fea0>] ? abort_exclusive_wait+0xb0/0xb0
[27336.007157]  [<ffffffff81089f10>] ? balance_pgdat+0x6a0/0x6a0
[27336.007160]  [<ffffffff8104f457>] kthread+0x87/0x90
[27336.007167]  [<ffffffff81648814>] kernel_thread_helper+0x4/0x10
[27336.007171]  [<ffffffff8104f3d0>] ? kthread_flush_work_fn+0x10/0x10
[27336.007175]  [<ffffffff81648810>] ? gs_change+0xb/0xb
[27336.007177] Code: 89 ea e8 33 95 22 00 85 c0 89 c6 0f 84 01 01 00 00 4d 89 e7 31 c9 31 d2 66 90 49 8b 07 48 8b 38 48 85 ff 74 5b 40 f6 c7 01 75 7a 
[27336.007198]  63 83 44 e0 ff ff a9 00 ff ff 07 0f 85 8d 00 00 00 44 8b 47 
[27336.007209] Call Trace:
[27336.007213]  [<ffffffff8108597d>] pagevec_lookup+0x1d/0x30
[27336.007217]  [<ffffffff8108607f>] invalidate_mapping_pages+0x5f/0x170
[27336.007222]  [<ffffffff810d37b5>] shrink_icache_memory+0x2d5/0x320
[27336.007226]  [<ffffffff81086f5d>] shrink_slab+0x11d/0x190
[27336.007229]  [<ffffffff81089d6a>] balance_pgdat+0x4fa/0x6a0
[27336.007233]  [<ffffffff81089fc3>] kswapd+0xb3/0x250
[27336.007237]  [<ffffffff8104fea0>] ? abort_exclusive_wait+0xb0/0xb0
[27336.007241]  [<ffffffff81089f10>] ? balance_pgdat+0x6a0/0x6a0
[27336.007244]  [<ffffffff8104f457>] kthread+0x87/0x90
[27336.007248]  [<ffffffff81648814>] kernel_thread_helper+0x4/0x10
[27336.007252]  [<ffffffff8104f3d0>] ? kthread_flush_work_fn+0x10/0x10
[27336.007256]  [<ffffffff81648810>] ? gs_change+0xb/0xb

Justin.

