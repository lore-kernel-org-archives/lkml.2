Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756274Ab1I2Wou (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 18:44:50 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:45178 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756014Ab1I2Wot convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 18:44:49 -0400
MIME-Version: 1.0
In-Reply-To: <CAOH1cHn3_aeVYC73YO43zf5piKOO_=MJwbbVfhW8eAWnDahRrw@mail.gmail.com>
References: <CAOH1cHnymZ1WasD4q+HXbeQb9wBAWmS9f451gEekA0-YjCZtLA@mail.gmail.com>
	<2150.1314882260@redhat.com>
	<CAOH1cHnLfLQzZ8022ivfFkbug=adU1AYZPJOqdTnrqh9vuAAxg@mail.gmail.com>
	<CAOH1cHm-hbC=KZJsT1H5ohVEJVzNvqaKatKVS+s2nKVkAMgX9w@mail.gmail.com>
	<5149.1317036720@redhat.com>
	<CAOH1cHn3QF0QtR7KKN9gk5CiUvLqxsni0yi9bgCmJ8f=N1v27Q@mail.gmail.com>
	<CAOH1cHmTWdCHAprmbH7cfmZCVakdayR3jd031da2X2N3FmjfPw@mail.gmail.com>
	<6324.1317308270@redhat.com>
	<CAOH1cHn0tc-_dFe1PovpKmTE5pnMp40ZXi5TR9+i=ozviTdinA@mail.gmail.com>
	<12748.1317313818@redhat.com>
	<CAOH1cHmFuXn3uZbyZy94-cBGCPDxLsJuskkYRteeBs75iLhssw@mail.gmail.com>
	<CAOH1cHn3_aeVYC73YO43zf5piKOO_=MJwbbVfhW8eAWnDahRrw@mail.gmail.com>
Date: Thu, 29 Sep 2011 15:44:47 -0700
Message-ID: <CAOH1cHm4d4xUmeUbTwzPWZRpuzXOq+4zW-2QQUfF4DVveujqQw@mail.gmail.com>
Subject: Re: [Linux-cachefs] 3.0.3 64-bit Crash running fscache/cachefilesd
From: Mark Moseley <moseleymark@gmail.com>
Cc: Linux filesystem caching discussion list 
	<linux-cachefs@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 3:11 PM, Mark Moseley <moseleymark@gmail.com> wrote:
> On Thu, Sep 29, 2011 at 12:02 PM, Mark Moseley <moseleymark@gmail.com> wrote:
>> On Thu, Sep 29, 2011 at 9:30 AM, David Howells <dhowells@redhat.com> wrote:
>>> Mark Moseley <moseleymark@gmail.com> wrote:
>>>
>>>> >> [12999.564897] FS-Cache: Cookie 'NFS.fh' still has outstanding reads
>>>> >
>>>> > Hopefully the patch set I sent to you will deal with this.
>>>> >
>>>> > David
>>>>
>>>> Not sure what you mean. Was there another patch besides the one to get
>>>> more info in the traceback?
>>>
>>> I emailed a set of 13 patches to you a short time before that.  Hopefully
>>> they'll fix the outstanding-reads problem the bad-page-state problem.
>>
>> Sorry, I just had this thread sitting open in gmail and I was looking
>> for the patch within it. I see all those emails you sent. I'll try to
>> get those patched in today. Thanks!
>>
>
> With those 13 patches, I get this traceback. Nothing before or after
> in logs or console.
>

Got a bit more at the end this time (nothing before though):


[ 2709.769251] ------------[ cut here ]------------
[ 2709.778483] kernel BUG at fs/fscache/operation.c:408!
[ 2709.779147] invalid opcode: 0000 [#1] SMP
[ 2709.779147] CPU 0
[ 2709.779147] Modules linked in: xfs ioatdma dca loop joydev evdev
psmouse serio_raw pcspkr dcdbas i5000_edac edac_core i5k_amb shpchp
pci_hotplug sg sr_mod]
[ 2709.779147]
[ 2709.779147] Pid: 10663, comm: httpd Not tainted 3.1.0-rc8 #1 Dell
Inc. PowerEdge 1950/0DT097
[ 2709.779147] RIP: 0010:[<ffffffff81197b24>]  [<ffffffff81197b24>]
fscache_put_operation+0x304/0x330
[ 2709.779147] RSP: 0018:ffff880126bf79d8  EFLAGS: 00010296
[ 2709.779147] RAX: 0000000000000025 RBX: ffff880111c1c644 RCX: ffffffff81ddf040
[ 2709.779147] RDX: 00000000ffffffff RSI: 0000000000000082 RDI: ffffffff81ddef30
[ 2709.779147] RBP: ffff880126bf79f8 R08: 0000000000000006 R09: 0000000000000000
[ 2709.779147] R10: 0000000000000000 R11: 0000000000000003 R12: ffff880111c1c600
[ 2709.779147] R13: ffff880225e21af0 R14: ffff8800a7f14dd8 R15: ffff8800a7f14d80
[ 2709.779147] FS:  00007fd9b8f626e0(0000) GS:ffff88022fc00000(0000)
knlGS:0000000000000000
[ 2709.779147] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2709.779147] CR2: ffffffffff600400 CR3: 0000000127cf6000 CR4: 00000000000006f0
[ 2709.779147] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2709.779147] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2709.779147] Process httpd (pid: 10663, threadinfo ffff880126bf6000,
task ffff880009d78000)
[ 2709.779147] Stack:
[ 2709.779147]  ffff880126bf7bf8 0000000000000000 ffff880126bf7bf8
ffff880225e21af0
[ 2709.779147]  ffff880126bf7a68 ffffffff8119aa7e ffff880126bf7a18
ffff880126bf7ad4
[ 2709.779147]  ffff88019af67708 ffff880225e21af0 ffff880223cdfc3c
ffff880111c1c600
[ 2709.779147] Call Trace:
[ 2709.779147]  [<ffffffff8119aa7e>] __fscache_read_or_alloc_pages+0x1fe/0x530
[ 2709.779147]  [<ffffffff81250780>] __nfs_readpages_from_fscache+0x70/0x1c0
[ 2709.779147]  [<ffffffff8123142a>] nfs_readpages+0xca/0x1e0
[ 2709.779147]  [<ffffffff815f3c06>] ? rpc_do_put_task+0x36/0x50
[ 2709.779147]  [<ffffffff815ecd1a>] ? rpc_call_sync+0x5a/0x70
[ 2709.779147]  [<ffffffff810e7e9a>] __do_page_cache_readahead+0x1ca/0x270
[ 2709.779147]  [<ffffffff810e7f61>] ra_submit+0x21/0x30
[ 2709.779147]  [<ffffffff810e818d>] ondemand_readahead+0x11d/0x250
[ 2709.779147]  [<ffffffff810e83b6>] page_cache_sync_readahead+0x36/0x60
[ 2709.779147]  [<ffffffff810dffa4>] generic_file_aio_read+0x454/0x770
[ 2709.779147]  [<ffffffff81224ce1>] nfs_file_read+0xe1/0x130
[ 2709.779147]  [<ffffffff81121bd9>] do_sync_read+0xd9/0x120
[ 2709.779147]  [<ffffffff81122938>] vfs_read+0xc8/0x180
[ 2709.779147]  [<ffffffff81122af5>] sys_read+0x55/0x90
[ 2709.779147]  [<ffffffff8162b32b>] system_call_fastpath+0x16/0x1b
[ 2709.779147] Code: e8 d9 f9 48 00 48 c7 c7 88 1d a1 81 31 c0 e8 cb
f9 48 00 41 8b 74 24 40 ba 05 00 00 00 48 c7 c7 0f 9c a0 81 31 c0 e8
b3 f9 48 00 <0f> 0b
[ 2709.779147] RIP  [<ffffffff81197b24>] fscache_put_operation+0x304/0x330
[ 2709.779147]  RSP <ffff880126bf79d8>
[ 2710.341319] ---[ end trace df840d758e018f42 ]---

2011 Sep 29 18:3[ 2710.353281] Kernel panic - not syncing: Fatal exception
9:25 boscust2102[ 2710.364937] Pid: 10663, comm: httpd Tainted: G
D     3.1.0-rc8 #1
 [ 2709.769251] [ 2710.380560] Call Trace:
------------[ cu[ 2710.388046]  [<ffffffff816273ab>] panic+0xbf/0x1eb
t here ]--------[ 2710.400573]  [<ffffffff8104b98f>] ? kmsg_dump+0x4f/0x100
----
    2011 Sep 29[ 2710.413979]  [<ffffffff81005c08>] oops_end+0xa8/0xf0
 18:39:25 boscus[ 2710.426626]  [<ffffz��[ 2710.529057]
[<ffffffff81197b24>] ? fscache_put_operation+0x304/0x330
[ 2710.542164]  [<ffffffff81197b24>] ? fscache_put_operation+0x304/0x330
[ 2710.555411]  [<ffffffff8119aa7e>] __fscache_read_or_alloc_pages+0x1fe/0x530
[ 2710.569638]  [<ffffffff81250780>] __nfs_readpages_from_fscache+0x70/0x1c0
[ 2710.583413]  [<ffffffff8123142a>] nfs_readpages+0xca/0x1e0
[ 2710.594538]  [<ffffffff815f3c06>] ? rpc_do_put_task+0x36/0x50
[ 2710.606109]  [<ffffffff815ecd1a>] ? rpc_call_sync+0x5a/0x70
[ 2710.617354]  [<ffffffff810e7e9a>] __do_page_cache_readahead+0x1ca/0x270
[ 2710.630667]  [<ffffffff810e7f61>] ra_submit+0x21/0x30
[ 2710.640864]  [<ffffffff810e818d>] ondemand_readahead+0x11d/0x250
[ 2710.653060]  [<ffffffff810e83b6>] page_cache_sync_readahead+0x36/0x60
[ 2710.666126]  [<ffffffff810dffa4>] generic_file_aio_read+0x454/0x770
[ 2710.678961]  [<ffffffff81224ce1>] nfs_file_read+0xe1/0x130
[ 2710.690326]  [<ffffffff81121bd9>] do_sync_read+0xd9/0x120
[ 2710.701253]  [<ffffffff81122938>] vfs_read+0xc8/0x180
[ 2710.711554]  [<ffffffff81122af5>] sys_read+0x55/0x90
[ 2710.721618]  [<ffffffff8162b32b>] system_call_fastpath+0x16/0x1b
