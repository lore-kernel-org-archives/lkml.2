Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128Ab1JTT3q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 15:29:46 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:42960 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295Ab1JTT3o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 15:29:44 -0400
MIME-Version: 1.0
In-Reply-To: <29711.1319101384@redhat.com>
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
	<18003.1317336244@redhat.com>
	<CAOH1cHmeX56+dZEidR4AAwEkz2kr7-J12vky5G8s0vzfbO39yw@mail.gmail.com>
	<6261.1317385734@redhat.com>
	<CAOH1cHkVjTSBvqvaoWnxTB1V-dOtj1cCT_kMZpJdsyNNeUoBag@mail.gmail.com>
	<8905.1317984176@redhat.com>
	<CAOH1cHnagaAVQ+8h_thqe7sneeiE6dCcD-U_NgZoO2PZRbixMg@mail.gmail.com>
	<32454.1318519287@redhat.com>
	<CAOH1cHkFitTHBkHzg+m7cZycOZTgWW8hF0g0=+pX6bPNVZNTxw@mail.gmail.com>
	<17609.1318584129@redhat.com>
	<CAOH1cHkrtzr4o=ygqrMnUfDhwC=U+QJOtuqS+vfQyeXP_TvjaQ@mail.gmail.com>
	<19081.1319027106@redhat.com>
	<CAOH1cH=smX1tWLB6PwaRfcrOu5YErF3TGUDoRnLZGmxvGH9rAA@mail.gmail.com>
	<29711.1319101384@redhat.com>
Date: Thu, 20 Oct 2011 12:29:43 -0700
Message-ID: <CAOH1cH=VvOjcE8FAPshytZwmhrwfhS1kcq=oV_btaPON7sWmfQ@mail.gmail.com>
Subject: Re: [Linux-cachefs] 3.0.3 64-bit Crash running fscache/cachefilesd
From: Mark Moseley <moseleymark@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: Linux filesystem caching discussion list 
	<linux-cachefs@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 20, 2011 at 2:03 AM, David Howells <dhowells@redhat.com> wrote:
> Mark Moseley <moseleymark@gmail.com> wrote:
>
>> Out of curiosity, did the dump of /proc/fs/fscache/stats show anything
>> interesting?
>
> Ah...  I missed the attachment.
>
> Looking at the number of pages currently marked (the difference between the
> following two numbers):
>
>        Pages  : mrk=3438716 unc=3223887
>        ...
>        Pages  : mrk=7660986 unc=7608076
>        Pages  : mrk=7668510 unc=7618591
>
> That isn't very high.  214829 at the beginning, dropping to 49919 at the end.
> I suspect this means that a lot of NFS inodes now exist that aren't now cached
> (the cache is under no requirement to actually cache anything if it feels it
> lacks the resources just to prevent the system from grinding to a halt).
>
> Was the last item in the list just before a crash?  I presume not from your
> comments.

Nope, it wasn't. I had to reboot it back into the previous kernel for
the weekend. I got a couple of oops though in the past 12 hours. I
unfortunately hadn't fired up that dump again though (I have now and
will send a new dump when I get another crash)

Here's the first:

[67666.379861] ------------[ cut here ]------------
[67666.379991] FS-Cache: Asserting on ReadOrAllocPages operation
[67666.379994]
[67666.379995] FS-Cache: Assertion failed
[67666.379997] 3 == 5 is false
[67666.389761] kernel BUG at fs/fscache/operation.c:426!
[67666.418480] invalid opcode: 0000 [#1] SMP
[67666.418480] CPU 6
[67666.418480] Modules linked in: xfs ioatdma dca loop joydev evdev
i5000_edac psmouse dcdbas edac_core pcspkr serio_raw shpchp
pci_hotplug i5k_amb sg sr_mod cdrom ehci_hcd ]
[67666.463678]
[67666.463678] Pid: 29497, comm: kworker/u:1 Not tainted 3.1.0-rc8 #1
Dell Inc. PowerEdge 1950/0DT097
[67666.463678] RIP: 0010:[<ffffffff81198832>]  [<ffffffff81198832>]
fscache_put_operation+0x332/0x360
[67666.463678] RSP: 0018:ffff880169e89dd0  EFLAGS: 00010286
[67666.463678] RAX: 0000000000000025 RBX: ffff8801ab673ae4 RCX: ffffffff81dfb040
[67666.463678] RDX: 00000000ffffffff RSI: 0000000000000086 RDI: ffffffff81dfaf30
[67666.463678] RBP: ffff880169e89df0 R08: 0000000000000006 R09: 0000000000000000
[67666.463678] R10: 0000000000000000 R11: 0000000000000003 R12: ffff8801ab673aa0
[67666.463678] R13: ffff8801dfe9d340 R14: ffffffff81e1d780 R15: ffff8802271f2305
[67666.463678] FS:  0000000000000000(0000) GS:ffff88022fd80000(0000)
knlGS:0000000000000000
[67666.463678] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[67666.463678] CR2: ffffffffff600400 CR3: 00000001ce38f000 CR4: 00000000000006e0
[67666.463678] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[67666.463678] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[67666.463678] Process kworker/u:1 (pid: 29497, threadinfo
ffff880169e88000, task ffff880048418040)
[67666.463678] Stack:
[67666.463678]  ffff8801ab673aa0 ffff8801ab673aa0 ffff8801ab673aa0
ffff8801dfe9d340
[67666.463678]  ffff880169e89e10 ffffffff8119889b ffffffff81e1d780
0000000000000000
[67666.463678]  ffff880169e89e60 ffffffff810661d4 0000000000000000
ffff8802271f2300
[67666.463678] Call Trace:
[67666.463678]  [<ffffffff8119889b>] fscache_op_work_func+0x3b/0xd0
[67666.463678]  [<ffffffff810661d4>] process_one_work+0x164/0x440
[67666.463678]  [<ffffffff81198860>] ? fscache_put_operation+0x360/0x360
[67666.463678]  [<ffffffff810669ec>] worker_thread+0x32c/0x430
[67666.463678]  [<ffffffff810666c0>] ? manage_workers+0x210/0x210
[67666.463678]  [<ffffffff8106d27e>] kthread+0x9e/0xb0
[67666.463678]  [<ffffffff8163f7b4>] kernel_thread_helper+0x4/0x10
[67666.463678]  [<ffffffff8163ce4a>] ? retint_restore_args+0xe/0xe
[67666.463678]  [<ffffffff8106d1e0>] ? kthread_worker_fn+0x190/0x190
[67666.463678]  [<ffffffff8163f7b0>] ? gs_change+0xb/0xb
[67666.463678] Code: 0c 10 4a 00 48 c7 c7 00 fb a1 81 31 c0 e8 fe 0f
4a 00 41 0f b6 74 24 40 ba 05 00 00 00 48 c7 c7 5b 75 a1 81 31 c0 e8
e5 0f 4a 00 <0f> 0b eb fe 65 48 8b
[67666.463678] RIP  [<ffffffff81198832>] fscache_put_operation+0x332/0x360
[67666.463678]  RSP <ffff880169e89dd0>
[67666.463279] ------------[ cut here ]------------
[67666.924857] ---[ end trace 0c287f8e8a3ed6ea ]---

At one point during that same run, I got this warning in the logs:

[30741.772165] httpd: page allocation failure: order:0, mode:0x11110
[30741.772175] Pid: 6343, comm: httpd Not tainted 3.1.0-rc8 #1
[30741.772180] Call Trace:
[30741.772199]  [<ffffffff810e524b>] warn_alloc_failed+0xfb/0x160
[30741.772205]  [<ffffffff810e1e8f>] ? zone_watermark_ok+0x1f/0x30
[30741.772210]  [<ffffffff810e4fa4>] ? get_page_from_freelist+0x444/0x5f0
[30741.772215]  [<ffffffff810e3720>] ? __zone_pcp_update+0xd0/0xd0
[30741.772220]  [<ffffffff810e58eb>] __alloc_pages_nodemask+0x54b/0x770
[30741.772229]  [<ffffffff8128c5ab>] cachefiles_read_or_alloc_pages+0xe8b/0xef0
[30741.772239]  [<ffffffff8106d6a7>] ? bit_waitqueue+0x17/0xb0
[30741.772243]  [<ffffffff8106d7ad>] ? wake_up_bit+0x2d/0x40
[30741.772252]  [<ffffffff81198f7a>] ? fscache_run_op+0x5a/0xa0
[30741.772256]  [<ffffffff81199653>] ? fscache_submit_op+0x373/0x5b0
[30741.772261]  [<ffffffff8119ba33>] __fscache_read_or_alloc_pages+0x3f3/0x530
[30741.772268]  [<ffffffff81251500>] __nfs_readpages_from_fscache+0x70/0x1c0
[30741.772275]  [<ffffffff812321ea>] nfs_readpages+0xca/0x1e0
[30741.772281]  [<ffffffff812d65de>] ? radix_tree_lookup+0x5e/0x80
[30741.772287]  [<ffffffff810e7e4a>] __do_page_cache_readahead+0x1ca/0x270
[30741.772291]  [<ffffffff810e7f11>] ra_submit+0x21/0x30
[30741.772295]  [<ffffffff810e813d>] ondemand_readahead+0x11d/0x250
[30741.772300]  [<ffffffff810e8319>] page_cache_async_readahead+0xa9/0xc0
[30741.772306]  [<ffffffff8114dd32>] __generic_file_splice_read+0x402/0x500
[30741.772315]  [<ffffffff8163c904>] ? _raw_spin_unlock_bh+0x14/0x20
[30741.772324]  [<ffffffff815925af>] ? tcp_sendpage+0xcf/0x6e0
[30741.772331]  [<ffffffff815b5f0f>] ? inet_sendpage+0x7f/0x110
[30741.772336]  [<ffffffff8114b7f0>] ? page_cache_pipe_buf_release+0x30/0x30
[30741.772341]  [<ffffffff8114de7f>] generic_file_splice_read+0x4f/0x90
[30741.772349]  [<ffffffff81224ccd>] nfs_file_splice_read+0x8d/0xe0
[30741.772353]  [<ffffffff8114c157>] do_splice_to+0x77/0xb0
[30741.772357]  [<ffffffff8114c9ac>] splice_direct_to_actor+0xcc/0x1e0
[30741.772362]  [<ffffffff8114c0b0>] ? do_splice_from+0xb0/0xb0
[30741.772366]  [<ffffffff8114cb17>] do_splice_direct+0x57/0x80
[30741.772372]  [<ffffffff81122026>] do_sendfile+0x166/0x1d0
[30741.772379]  [<ffffffff811347a8>] ? poll_select_set_timeout+0x88/0xa0
[30741.772383]  [<ffffffff8112211d>] sys_sendfile64+0x8d/0xb0
[30741.772389]  [<ffffffff8163d66b>] system_call_fastpath+0x16/0x1b

Not sure why it'd give that, but sysstat shows that it definitely
wasn't out of memory (and it's got 16gb of swap, so it'd take a while
-- i.e. at least once caught by sysstat -- before it actually did run
out). But that was also a good while before the crash. Dunno if
related, but I figured I should mention it. I've not seen it any other
time though.

The second crash was just a few minutes ago, but the traceback looks
like the others:

[24724.296274] kernel BUG at fs/fscache/operation.c:426!
[24724.300702] invalid opcode: 0000 [#1] SMP
[24724.311107] CPU 1
[24724.311107] Modules linked in: xfs loop joydev evdev psmouse dcdbas
pcspkr serio_raw shpchp i5000_edac edac_core pci_hotplug i5k_amb sg
sr_mod cdrom ]
[24724.311107]
[24724.311107] Pid: 14830, comm: kworker/u:1 Not tainted 3.1.0-rc8 #1
Dell Inc. PowerEdge 1950/0DT097
[24724.311107] RIP: 0010:[<ffffffff81198832>]  [<ffffffff81198832>]
fscache_put_operation+0x332/0x360
[24724.390018] RSP: 0000:ffff880082063dd0  EFLAGS: 00010286
[24724.390018] RAX: 0000000000000025 RBX: ffff8802245b80c4 RCX: ffffffff81dfb040
[24724.410019] RDX: 00000000ffffffff RSI: 0000000000000086 RDI: ffffffff81dfaf30
[24724.410019] RBP: ffff880082063df0 R08: 0000000000000006 R09: 0000000000000000
[24724.410019] R10: 0000000000000000 R11: 0000000000000003 R12: ffff8802245b8080
[24724.410019] R13: ffff8801b89fd210 R14: ffffffff81e1d780 R15: ffff880227255305
[24724.410019] FS:  0000000000000000(0000) GS:ffff88022fc40000(0000)
knlGS:0000000000000000
[24724.410019] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[24724.410019] CR2: 00000000047bf0f8 CR3: 00000001b854b000 CR4: 00000000000006e0
[24724.410019] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[24724.410019] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[24724.410019] Process kworker/u:1 (pid: 14830, threadinfo
ffff880082062000, task ffff8801cab3c380)
[24724.410019] Stack:
[24724.410019]  ffff8802245b8080 ffff8802245b8080 ffff8802245b8080
ffff8801b89fd210
[24724.410019]  ffff880082063e10 ffffffff8119889b ffffffff81e1d780
0000000000000000
[24724.410019]  ffff880082063e60 ffffffff810661d4 0000000000000000
ffff880227255300
[24724.410019] Call Trace:
[24724.410019]  [<ffffffff8119889b>] fscache_op_work_func+0x3b/0xd0
[24724.410019]  [<ffffffff810661d4>] process_one_work+0x164/0x440
[24724.410019]  [<ffffffff81198860>] ? fscache_put_operation+0x360/0x360
[24724.410019]  [<ffffffff8106685b>] worker_thread+0x19b/0x430
[24724.410019]  [<ffffffff810666c0>] ? manage_workers+0x210/0x210
[24724.410019]  [<ffffffff8106d27e>] kthread+0x9e/0xb0
[24724.410019]  [<ffffffff8163f7b4>] kernel_thread_helper+0x4/0x10
[24724.410019]  [<ffffffff8163ce4a>] ? retint_restore_args+0xe/0xe
[24724.410019]  [<ffffffff8106d1e0>] ? kthread_worker_fn+0x190/0x190
[24724.410019]  [<ffffffff8163f7b0>] ? gs_change+0xb/0xb
[24724.410019] Code: 0c 10 4a 00 48 c7 c7 00 fb a1 81 31 c0 e8 fe 0f
4a 00 41 0f b6 74 24 40 ba 05 00 00 00 48 c7 c7 5b 75 a1 81 31 c0 e8
e5 0f 4a 00 <0
[24724.410019] RIP  [<ffffffff81198832>] fscache_put_operation+0x332/0x360
[24724.410019]  RSP <ffff880082063dd0>
[24724.798329] ---[ end trace 54b4ea9a2f86ea9e ]---




>> One slightly interesting thing, unrelated to fscache: This box is a
>> part of a pool of servers, serving the same web workloads. Another box
>> in this same pool is running 3.0.4, up for about 23 days (vs 6 hrs),
>> and the nfs_inode_cache is approximately 1/4 of the 3.1.0-rc8's,
>> size-wise, 1/3 #ofobjects-wise; likewise dentry in a 3.0.4 box with a
>> much longer uptime is about 1/9 the size (200k objs vs 1.8mil objects,
>> 45megs vs 400megs) as the 3.1.0-rc8 box. Dunno if that's the result of
>> VM improvements or a symptom of something leaking :)
>
> It also depends on what the load consists of.  For instance someone running a
> lot of find commands would cause the server to skew in favour of inodes over
> data, but someone reading/writing big files would skew it the other way.

This is static web serving, 100% over NFS, so it'll be traversing a
lot of inodes and directories, as well as possibly reading very large
files, so I guess that'd be somewhere in between.


> Do I take it the 3.0.4 box is not running fscache, but the 3.1.0-rc8 box is?

The 3.0.4 box I mentioned is not running fscache, no. I mentioned it
mainly cause it was sort of interesting, but also in the interest of
bringing up anything that might even be tangentially related to this.
