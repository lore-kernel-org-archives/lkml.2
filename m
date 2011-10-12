Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794Ab1JLXiS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 19:38:18 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:37567 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218Ab1JLXiR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 19:38:17 -0400
MIME-Version: 1.0
In-Reply-To: <CAOH1cHkg_eQRCHxOxiOPgO=-aZfnjts-tLFQFKffk5JjEfqy2w@mail.gmail.com>
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
	<1448.1318338420@redhat.com>
	<CAOH1cHkTiitknOsjnu9n7B2Ax+pSgM-EFDFJodjDnamxt3RMCA@mail.gmail.com>
	<9908.1318413955@redhat.com>
	<CAOH1cHkg_eQRCHxOxiOPgO=-aZfnjts-tLFQFKffk5JjEfqy2w@mail.gmail.com>
Date: Wed, 12 Oct 2011 16:38:15 -0700
Message-ID: <CAOH1cHnagaAVQ+8h_thqe7sneeiE6dCcD-U_NgZoO2PZRbixMg@mail.gmail.com>
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

On Wed, Oct 12, 2011 at 11:10 AM, Mark Moseley <moseleymark@gmail.com> wrote:
> On Wed, Oct 12, 2011 at 3:05 AM, David Howells <dhowells@redhat.com> wrote:
>> Mark Moseley <moseleymark@gmail.com> wrote:
>>
>>> > Hmmm...  An object is being added to the object list twice.  It may
>>> > indicate a free before an object is finished with.  Do you have slab
>>> > debugging turned on?
>>>
>>> It's compiled in but not currently enabled. Should I do so? And
>>> anything I should be looking for in it?
>>
>> This raises another question: Which of CONFIG_SLAB/SLOB/SLUB are you actually
>> using?
>>
>> David
>>
>
> I had SLUB. I have CONFIG_SLUB_DEBUG but not CONFIG_SLUB_DEBUG_ON.
>
> I've recompiled with SLAB and CONFIG_DEBUG_SLAB enabled though:
>
> CONFIG_SLAB=y
> CONFIG_SLABINFO=y
> CONFIG_DEBUG_SLAB=y
> CONFIG_DEBUG_SLAB_LEAK=y
>
> Any flags anywhere that I need to set?
>
> I've also cleared out the fscache cache. When I initially booted into
> the 3.1.0-rc8 with SLAB, I was already at the cachefilesd.conf limit,
> space-wise, and it would crash almost immediately (basically as soon
> as load balancers started directing traffic to it again). I didn't
> have console, so I don't have the full traceback for these ones, but a
> little of the top actually made it to the logs:
>
>
> [  117.654487] FS-Cache: Cache "mycache" added (type cachefiles)
> [  117.654494] CacheFiles: File cache on sdb6 registered
> [  184.943653] ------------[ cut here ]------------
> [  184.952933] kernel BUG at fs/fscache/object-list.c:83!
> [  184.960676] invalid opcode: 0000 [#1] SMP
> [  184.960676] CPU 1
> [  184.960676] Modules linked in: xfs ioatdma dca loop joydev evdev
> dcdbas psmouse serio_raw pcspkr i5000_edac edac_core i5k_amb shpchp pc
> i_hotplug sg sr_mod cdrom ehci_hcd uhci_hcd sd_mod crc_t10dif [last
> unloaded: scsi_wait_scan]
> [  184.960676]
> [  184.960676] Pid: 638, comm: kworker/u:2 Not tainted 3.1.0-rc8 #1
> Dell Inc. PowerEdge 1950/0DT097
> [  184.960676] RIP: 0010:[<ffffffff8119d15c>]  [<ffffffff8119d15c>]
> fscache_object_destroy+0x4c/0x50
> [  184.960676] RSP: 0000:ffff880224cebd90  EFLAGS: 00010246
> [  184.960676] RAX: 0000000000000011 RBX: ffff88021920a5e8 RCX: ffff8801d6b92a38
> [  184.960676] RDX: 0000000000000010 RSI: 000000000000006b RDI: ffffffff81c94b10
>
> This was the 2nd one, after I'd panicked it starting up cachefilesd a
> couple of minutes earlier (which was also "kernel BUG at
> fs/fscache/object-list.c:83"), so I figured I should clear the cache.
>


So on a cleared cache with SLAB, it took a while but this finally came
up. One interesting thing is that at some point, it logged this:

[13461.605871] [httpd ] <== __fscache_read_or_alloc_pages() = -ENOBUFS
[invalidating]

It was a while from when it logged that until when I happened to check
on the box again, but when I did (shortly before this traceback),
despite constant NFS activity, nothing in the fscache cache was
getting written out (i.e. the used bytes on the partition stopped
changing), and without any messages about withdrawing the cache or
anythin. The odds that everything that box was touching was in the
cache are incredibly slim, since it's web hosting. cachefilesd was
chugging along doing cull scans, so it didn't seem to be dead, but I
decided to restart it. The following traceback popped up within a
couple of minutes of cachefilesd restarting.


[20839.802118] kernel BUG at fs/fscache/object-list.c:83!
[20839.802733] invalid opcode: 0000 [#1] SMP
[20839.802733] CPU 0
[20839.802733] Modules linked in: xfs ioatdma dca loop joydev evdev
psmouse i5000_edac serio_raw pcspkr dcdbas shpchp edac_core
pci_hotplug i5k_amb sg sr_mod cdrom ehci_hcd ]
[20839.802733]
[20839.802733] Pid: 21371, comm: kworker/u:2 Not tainted 3.1.0-rc8 #1
Dell Inc. PowerEdge 1950/0DT097
[20839.802733] RIP: 0010:[<ffffffff8119d15c>]  [<ffffffff8119d15c>]
fscache_object_destroy+0x4c/0x50
[20839.802733] RSP: 0018:ffff8800a0d3bd90  EFLAGS: 00010246
[20839.802733] RAX: 0000000000000000 RBX: ffff880137e39a48 RCX: 00000000ffffffff
[20839.802733] RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffffffff81c94b10
[20839.802733] RBP: ffff8800a0d3bda0 R08: ffff88022fc11640 R09: 0000000000000000
[20839.802733] R10: 0000000000000400 R11: 0000000000000000 R12: ffff880137e39a48
[20839.802733] R13: 0000000000000001 R14: ffff880137e39a48 R15: ffff880137e39a68
[20839.802733] FS:  0000000000000000(0000) GS:ffff88022fc00000(0000)
knlGS:0000000000000000
[20839.802733] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[20839.802733] CR2: ffffffffff600400 CR3: 00000001d5845000 CR4: 00000000000006f0
[20839.802733] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[20839.802733] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[20839.802733] Process kworker/u:2 (pid: 21371, threadinfo
ffff8800a0d3a000, task ffff88006ba101c0)
[20839.802733] Stack:
[20839.802733]  ffff8800a0d3bdc0 ffff88007198b720 ffff8800a0d3bdc0
ffffffff81287c85
[20839.802733]  ffff8800578f4c18 ffff880137e39ac8 ffff8800a0d3be10
ffffffff811974fd
[20839.802733]  ffff880137e39a80 ffff880010486178 ffff8800578f4c20
0000000000000000
[20839.802733] Call Trace:
[20839.802733]  [<ffffffff81287c85>] cachefiles_put_object+0xf5/0x360
[20839.802733]  [<ffffffff811974fd>] fscache_object_work_func+0x1cd/0xe90
[20839.802733]  [<ffffffff810661d4>] process_one_work+0x164/0x440
[20839.802733]  [<ffffffff81197330>] ? fscache_enqueue_dependents+0x100/0x100
[20839.802733]  [<ffffffff810669ec>] worker_thread+0x32c/0x430
[20839.802733]  [<ffffffff810666c0>] ? manage_workers+0x210/0x210
[20839.802733]  [<ffffffff8106d27e>] kthread+0x9e/0xb0
[20839.802733]  [<ffffffff8163f7b4>] kernel_thread_helper+0x4/0x10
[20839.802733]  [<ffffffff8163ce4a>] ? retint_restore_args+0xe/0xe
[20839.802733]  [<ffffffff8106d1e0>] ? kthread_worker_fn+0x190/0x190
[20839.802733]  [<ffffffff8163f7b0>] ? gs_change+0xb/0xb
[20839.802733] Code: 6c cb 00 00 74 25 48 8d bb d0 00 00 00 48 c7 c6
f8 3d e5 81 e8 06 ac 13 00 f0 81 05 bb 79 af 00 00 00 10 00 48 83 c4
08 5b c9 c3 <0f> 0b eb fe 55 48 89
[20839.802733] RIP  [<ffffffff8119d15c>] fscache_object_destroy+0x4c/0x50
[20839.802733]  RSP <ffff8800a0d3bd90>
[20840.320257] ---[ end trace fdcbf6423d22291c ]---
