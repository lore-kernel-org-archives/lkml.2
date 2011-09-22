Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131Ab1IVVl4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 17:41:56 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:41040 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753939Ab1IVVlx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 17:41:53 -0400
MIME-Version: 1.0
In-Reply-To: <CAOH1cHnLfLQzZ8022ivfFkbug=adU1AYZPJOqdTnrqh9vuAAxg@mail.gmail.com>
References: <CAOH1cHnymZ1WasD4q+HXbeQb9wBAWmS9f451gEekA0-YjCZtLA@mail.gmail.com>
	<2150.1314882260@redhat.com>
	<CAOH1cHnLfLQzZ8022ivfFkbug=adU1AYZPJOqdTnrqh9vuAAxg@mail.gmail.com>
Date: Thu, 22 Sep 2011 14:41:53 -0700
Message-ID: <CAOH1cHm-hbC=KZJsT1H5ohVEJVzNvqaKatKVS+s2nKVkAMgX9w@mail.gmail.com>
Subject: Re: [Linux-cachefs] 3.0.3 64-bit Crash running fscache/cachefilesd
From: Mark Moseley <moseleymark@gmail.com>
Cc: Linux filesystem caching discussion list 
	<linux-cachefs@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 10:03 AM, Mark Moseley <moseleymark@gmail.com> wrote:
> On Thu, Sep 1, 2011 at 6:04 AM, David Howells <dhowells@redhat.com> wrote:
>> Mark Moseley <moseleymark@gmail.com> wrote:
>>
>>> [25625.932971] ------------[ cut here ]------------
>>
>> There's some important information before the cut-here line.  If you could
>> paste that too, it would be most useful.
>>
>
> Somehow I completely missed this reply, or I'd have replied later the
> same day :)
>
> I'll have to grab a new trace. I'll post that as soon as I get it.


I thought I'd be extra-helpful by getting that trace with a 3.0.4
kernel but got a completely different error this time (there was
nothing logged above this though). There was a
'__fscache_read_or_alloc_pages' crash for the previous boot too,
though it went for about 2.5 hours that time (with an empty cache
partition though).

[  606.240505] BUG: unable to handle kernel NULL pointer dereference
at 0000000000000040
[  606.250342] IP: [<ffffffff811ab9aa>]
__fscache_read_or_alloc_pages+0x14a/0x3b0
[  606.250342] PGD 62b46067 PUD 62b4e067 PMD 0
[  606.250342] Oops: 0000 [#1] SMP
[  606.250342] CPU 4
[  606.250342] Modules linked in: xfs ioatdma dca loop joydev evdev
psmouse i5000_edac edac_core dcdbas shpchp pci_hotplug i5k_amb
serio_raw pcspkr sg s]
[  606.250342]
[  606.250342] Pid: 5902, comm: httpd Not tainted 3.0.4 #1 Dell Inc.
PowerEdge 1950/0DT097
[  606.250342] RIP: 0010:[<ffffffff811ab9aa>]  [<ffffffff811ab9aa>]
__fscache_read_or_alloc_pages+0x14a/0x3b0
[  606.250342] RSP: 0018:ffff880062b519f8  EFLAGS: 00010246
[  606.250342] RAX: 0000000000000000 RBX: ffff8801188f6c30 RCX: 00000000c0000100
[  606.250342] RDX: 0000000000000000 RSI: ffff880062b51958 RDI: ffff88022ffd2b88
[  606.250342] RBP: ffff880062b51a38 R08: ffff8801ecb4e300 R09: 0000000000000008
[  606.250342] R10: 0000000000000007 R11: 0000000000000001 R12: 0000000000000000
[  606.250342] R13: ffff8800cb369380 R14: ffff880062b51bc8 R15: ffff880062b51aa4
[  606.250342] FS:  0000033d3885d6e0(0000) GS:ffff88022fd00000(0000)
knlGS:0000000000000000
[  606.250342] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  606.250342] CR2: 0000000000000040 CR3: 0000000001681000 CR4: 00000000000006f0
[  606.250342] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  606.250342] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  606.250342] Process httpd (pid: 5902, threadinfo ffff8801ecb4e300,
task ffff8801ecb4de00)
[  606.250342] Stack:
[  606.250342]  ffff88012172fa80 ffffffff81259c40 ffff880111153000
00000000ffffff97
[  606.250342]  ffff880062b51aa4 0000000000000001 ffff880061907050
ffff880061907198
[  606.250342]  ffff880062b51a88 ffffffff81259af0 ffffffff000200da
0000000000000002
[  606.250342] Call Trace:
[  606.250342]  [<ffffffff81259c40>] ? __nfs_readpages_from_fscache+0x1c0/0x1c0
[  606.250342]  [<ffffffff81259af0>] __nfs_readpages_from_fscache+0x70/0x1c0
[  606.250342]  [<ffffffff8123a6c6>] nfs_readpages+0xd6/0x200
[  606.250342]  [<ffffffff810f2e9a>] __do_page_cache_readahead+0x1da/0x270
[  606.250342]  [<ffffffff810f2f51>] ra_submit+0x21/0x30
[  606.250342]  [<ffffffff810f317d>] ondemand_readahead+0x11d/0x250
[  606.250342]  [<ffffffff810f33a6>] page_cache_sync_readahead+0x36/0x60
[  606.250342]  [<ffffffff810eb1ec>] generic_file_aio_read+0x45c/0x770
[  606.250342]  [<ffffffff8122df01>] nfs_file_read+0xe1/0x130
[  606.250342]  [<ffffffff8112d4c9>] do_sync_read+0xd9/0x120
[  606.250342]  [<ffffffff810ea629>] ? __filemap_fdatawrite_range+0x59/0x70
[  606.250342]  [<ffffffff8113206b>] ? cp_new_stat+0x16b/0x190
[  606.250342]  [<ffffffff8112e335>] vfs_read+0xf5/0x210
[  606.250342]  [<ffffffff8112e545>] sys_read+0x55/0x90
[  606.250342]  [<ffffffff81650ef4>] system_call_fastpath+0x16/0x1b
[  606.250342] Code: 48 8b 7a 28 ff d0 48 c7 c1 64 59 d5 81 48 c7 c2
6c 59 d5 81 48 8b 75 d0 4c 89 ef e8 c1 fa ff ff 41 89 c4 85 c0 78 51
49 8b 45 70
[  606.250342]  8b 40 40 a8 04 0f 84 4a 01 00 00 f0 ff 05 97 a0 ba 00 71 09
[  606.250342] RIP  [<ffffffff811ab9aa>]
__fscache_read_or_alloc_pages+0x14a/0x3b0
[  606.250342]  RSP <ffff880062b519f8>
[  606.250342] CR2: 0000000000000040
[  606.843210] ---[ end trace 48cd119076837772 ]---


I'll boot into that same 3.0.3 kernel as before and see if I get
anything logged before the '--cut--' line for it.

In general, the same pattern of things seeming to be generally working
fine when the cache dir is empty and things start to go bad when the
cache partition is fullish. I haven't measured this with any
exactitude though, so could be coincidental.
