Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886Ab0FGDBH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 23:01:07 -0400
Received: from mail-yw0-f187.google.com ([209.85.211.187]:40066 "EHLO
	mail-yw0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755712Ab0FGDBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 23:01:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=tIn9Z8LcR9McHBstV042Gim/2KVB3jJ808BiYu9TslaVuKtIPH1QHb8r+1lNWXakJ4
         9R3dUR7rnSlI31wK+79/cSwu4nAd9srs7KShhUJAezgR0DfWnfcUBNPsmFv468D4kTwZ
         jiruM8BuHNdeLbpEUQWpsorFbmGG3WJrWX80E=
MIME-Version: 1.0
In-Reply-To: <AANLkTilDH891zRB_lv4OYEAlAKzHMTIGyDmbVm7I07xk@mail.gmail.com>
References: <alpine.LFD.2.00.1006052050100.3515@i5.linux-foundation.org>
	<AANLkTinpHAK3-qj26KSLLhMB5UUDT5I9aSkrxJeRRsSl@mail.gmail.com>
	<alpine.LFD.2.00.1006060710570.3515@i5.linux-foundation.org>
	<4C0BC35C.8070003@kernel.org>
	<4C0BC45A.6080104@gmail.com>
	<AANLkTinWB1M3uz5We566e2-UzwFsJuDi3rDAihgU5jCj@mail.gmail.com>
	<AANLkTilDH891zRB_lv4OYEAlAKzHMTIGyDmbVm7I07xk@mail.gmail.com>
Date: Mon, 7 Jun 2010 11:01:04 +0800
Message-ID: <AANLkTilAzIGdPGnZfi0y5fUpJm_J9pO_ns2cZhSFfMWh@mail.gmail.com>
Subject: Re: Linux 2.6.35-rc2
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Dave Airlie <airlied@gmail.com>
Cc: Torsten Kaiser <just.for.lkml@googlemail.com>,
       Tejun Heo <htejun@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alex Deucher <alexdeucher@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jgarzik@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 7, 2010 at 10:33 AM, Dave Airlie <airlied@gmail.com> wrote:
> On Mon, Jun 7, 2010 at 2:25 AM, Torsten Kaiser
> <just.for.lkml@googlemail.com> wrote:
>> On Sun, Jun 6, 2010 at 5:52 PM, Tejun Heo <htejun@gmail.com> wrote:
>>> On 06/06/2010 05:48 PM, Tejun Heo wrote:
>>>> Can you please try w/o KMS just in case?
>>
>> 2 out of 2 attempts without KMS worked without any OOPS.
>> Sorry to have bother you with this, it now really looks KMS related.
>>
>>> Also, does it always crash the same way?
>
> Just an initial guess does the vt.c patch in thread
>
> "Re: BUG kmalloc-4096: Poison overwritten (2.6.35-rc2)"

I'm seeing random failure as well. This might be a different issues,
but could be related.

1) Boot up. Without startx, on VT1 starts compiling gcc. Switch to
VT2. Start compiling something big as well. Switch back to VT1 ...
sometimes it just oops. If all VTs are "quiet", then no problem.


2010-06-06T22:09:02.982208+08:00 boston kernel: Pid: 28798, comm: sh
Not tainted 2.6.35-rc2 #38 5413FGA/5413FGA
2010-06-06T22:09:02.982212+08:00 boston kernel: RIP:
0010:[<ffffffff81091943>]  [<ffffffff81091943>]
kmem_cache_alloc+0x66/0x98
2010-06-06T22:09:02.982214+08:00 boston kernel: RSP:
0018:ffff880234d9fd80  EFLAGS: 00010002
2010-06-06T22:09:02.982217+08:00 boston kernel: RAX: 0000000000000000
RBX: 00000000000000d0 RCX: 0000000000000004
2010-06-06T22:09:02.982220+08:00 boston kernel: RDX: 0720072007200720
RSI: 00000000000000d0 RDI: ffff88023bc01900
2010-06-06T22:09:02.982222+08:00 boston kernel: RBP: ffff88023bc01900
R08: ffff880001b952e0 R09: 0000000000e00000
2010-06-06T22:09:02.982224+08:00 boston kernel: R10: 00000000000008ac
R11: 00000000000084d0 R12: 0000000000000246
2010-06-06T22:09:02.982227+08:00 boston kernel: R13: ffffffff8102f4ec
R14: ffff880234c09be8 R15: ffff88023a92b840
2010-06-06T22:09:02.982229+08:00 boston kernel: FS:
00007f028bbef700(0000) GS:ffff880001b80000(0000)
knlGS:0000000000000000
2010-06-06T22:09:02.982231+08:00 boston kernel: CS:  0010 DS: 0000 ES:
0000 CR0: 000000008005003b
2010-06-06T22:09:02.982234+08:00 boston kernel: CR2: 0000000000e38228
CR3: 0000000234c7e000 CR4: 00000000000006e0
2010-06-06T22:09:02.982236+08:00 boston kernel: DR0: 0000000000000000
DR1: 0000000000000000 DR2: 0000000000000000
2010-06-06T22:09:02.982238+08:00 boston kernel: DR3: 0000000000000000
DR6: 00000000ffff0ff0 DR7: 0000000000000400
2010-06-06T22:09:02.982241+08:00 boston kernel: Process sh (pid:
28798, threadinfo ffff880234d9e000, task ffff88023a92b840)
2010-06-06T22:09:02.982242+08:00 boston kernel: Stack:
2010-06-06T22:09:02.982245+08:00 boston kernel: ffff88023adcd880
ffff88023734b800 ffff88023adcd880 0000000000000004
2010-06-06T22:09:02.982248+08:00 boston kernel: <0> ffff8802373f0a80
ffffffff8102f4ec ffff88023a832d00 ffff88023b8bc930
2010-06-06T22:09:02.982250+08:00 boston kernel: <0> 0000000000000004
ffff88023adcd8e8 ffff88023734b868 ffff880234c09c08



Another oops ...



2010-06-06T22:19:16.731578+08:00 boston kernel: Pid: 11849, comm:
doltcompile Not tainted 2.6.35-rc1 #40 5413FGA/5413FGA
2010-06-06T22:19:16.731586+08:00 boston kernel: RIP:
0010:[<ffffffff810a950b>]  [<ffffffff810a950b>] __lookup_mnt+0x45/0x52
2010-06-06T22:19:16.731588+08:00 boston kernel: RSP:
0018:ffff880237183c60  EFLAGS: 00010203
2010-06-06T22:19:16.731591+08:00 boston kernel: RAX: 0720072007200720
RBX: ffff880237183d28 RCX: ffff88023bc128a0
2010-06-06T22:19:16.731595+08:00 boston kernel: RDX: 0000000000000001
RSI: ffff88023b85a9c0 RDI: ffff88023bcb2800
2010-06-06T22:19:16.731597+08:00 boston kernel: RBP: 0000000000000000
R08: 000000000000001c R09: 0000000000000007
2010-06-06T22:19:16.731600+08:00 boston kernel: R10: 0000000000000000
R11: ffff88023548a348 R12: ffff8802354e1004
2010-06-06T22:19:16.731603+08:00 boston kernel: R13: ffff880237183d28
R14: ffff88023a90f080 R15: ffff88023bcb2800
2010-06-06T22:19:16.731605+08:00 boston kernel: FS:
00002b4031647080(0000) GS:ffff880001b80000(0000)
knlGS:0000000000000000
2010-06-06T22:19:16.731608+08:00 boston kernel: CS:  0010 DS: 0000 ES:
0000 CR0: 0000000080050033
2010-06-06T22:19:16.731611+08:00 boston kernel: CR2: 0000000001c46000
CR3: 00000002370b3000 CR4: 00000000000006e0
2010-06-06T22:19:16.731613+08:00 boston kernel: DR0: 0000000000000000
DR1: 0000000000000000 DR2: 0000000000000000
2010-06-06T22:19:16.731620+08:00 boston kernel: DR3: 0000000000000000
DR6: 00000000ffff0ff0 DR7: 0000000000000400
2010-06-06T22:19:16.731623+08:00 boston kernel: Process doltcompile
(pid: 11849, threadinfo ffff880237182000, task ffff88023a90f080)
2010-06-06T22:19:16.731625+08:00 boston kernel: Stack:
2010-06-06T22:19:16.731628+08:00 boston kernel: ffffffff810a9b8c
ffff880237183d28 ffffffff8109d6c0 ffff880237183df8
2010-06-06T22:19:16.731631+08:00 boston kernel: <0> ffff880237183d18
ffff8802354e1004 ffffffff8109d92f 0000000000000000
2010-06-06T22:19:16.731633+08:00 boston kernel: <0> ffffffff81708240
0000000000000001 ffff880237183df8 0000000000000000
2010-06-06T22:19:16.731635+08:00 boston kernel: Call Trace:
2010-06-06T22:19:16.731638+08:00 boston kernel: [<ffffffff810a9b8c>] ?
lookup_mnt+0x21/0x35
2010-06-06T22:19:16.731641+08:00 boston kernel: [<ffffffff8109d6c0>] ?
__follow_mount+0x13/0x73
2010-06-06T22:19:16.731644+08:00 boston kernel: [<ffffffff8109d92f>] ?
do_lookup+0x79/0x201
2010-06-06T22:19:16.731647+08:00 boston kernel: [<ffffffff8109f51d>] ?
link_path_walk+0x1d0/0x9d5
2010-06-06T22:19:16.731649+08:00 boston kernel: [<ffffffff8109fe54>] ?
path_walk+0x63/0xd6
2010-06-06T22:19:16.731652+08:00 boston kernel: [<ffffffff8109ec59>] ?
path_init+0x46/0x1ac
2010-06-06T22:19:16.731655+08:00 boston kernel: [<ffffffff8109ff85>] ?
do_path_lookup+0x20/0x47
2010-06-06T22:19:16.731659+08:00 boston kernel: [<ffffffff810a091a>] ?
user_path_at+0x46/0x7f
2010-06-06T22:19:16.731661+08:00 boston kernel: [<ffffffff8101f878>] ?
do_page_fault+0x2bf/0x2fa
2010-06-06T22:19:16.731664+08:00 boston kernel: [<ffffffff81081f0a>] ?
vma_merge+0x13d/0x25d
2010-06-06T22:19:16.731667+08:00 boston kernel: [<ffffffff810990be>] ?
vfs_fstatat+0x2e/0x5b
2010-06-06T22:19:16.731670+08:00 boston kernel: [<ffffffff81082443>] ?
do_brk+0x244/0x33b
2010-06-06T22:19:16.731672+08:00 boston kernel: [<ffffffff81099283>] ?
sys_newstat+0x11/0x2d
2010-06-06T22:19:16.731676+08:00 boston kernel: [<ffffffff8148c785>] ?
page_fault+0x25/0x30
2010-06-06T22:19:16.731679+08:00 boston kernel: [<ffffffff81001f02>] ?
system_call_fastpath+0x16/0x1b
2010-06-06T22:19:16.731683+08:00 boston kernel: Code: 0c 08 81 e1 ff
00 00 00 48 c1 e1 04 48 03 0d dd 39 66 00 48 89 c8 85 d2 74 05 48 8b
00 eb 04 48 8b 40 08 48 39 c8 75 03 31 c0 c3 <48> 39 78 10 75 e5 48 39
70 18 75 df c3 55 48 c7 c2 e8 1b 5c 81
2010-06-06T22:19:16.731687+08:00 boston kernel: RIP
[<ffffffff810a950b>] __lookup_mnt+0x45/0x52
2010-06-06T22:19:16.731689+08:00 boston kernel: RSP <ffff880237183c60>
2010-06-06T22:19:16.731692+08:00 boston kernel: ---[ end trace
d1fd193ebde933ba ]---



2) Boot up. startx. On X windows, kill X. Sometimes, it oops.

2010-06-07T10:10:35.912257+08:00 boston kernel: Pid: 2569, comm: X Not
tainted 2.6.35-rc2 #41 5413FGA/5413FGA
2010-06-07T10:10:35.912260+08:00 boston kernel: RIP:
0010:[<ffffffff812514a5>]  [<ffffffff812514a5>]
i915_gem_madvise_ioctl+0xea/0x142
2010-06-07T10:10:35.912262+08:00 boston kernel: RSP:
0018:ffff8802373c9d88  EFLAGS: 00010246
2010-06-07T10:10:35.912264+08:00 boston kernel: RAX: 0720072007200720
RBX: ffff8802373c9de8 RCX: ffff8802373d14b8
2010-06-07T10:10:35.912266+08:00 boston kernel: RDX: 0000000000000001
RSI: 00000000000001fd RDI: ffff8802373f1ae8
2010-06-07T10:10:35.912269+08:00 boston kernel: RBP: 00000000ffffffea
R08: 0000000000000a09 R09: 00000000c00c6466
2010-06-07T10:10:35.912271+08:00 boston kernel: R10: 00007f7149727eb0
R11: 0000000000003206 R12: ffff88023b498820
2010-06-07T10:10:35.912273+08:00 boston kernel: R13: ffff880235041400
R14: ffffffff816d2690 R15: ffffffff812513bb
2010-06-07T10:10:35.912276+08:00 boston kernel: FS:
00007f714b5a4840(0000) GS:ffff880001b80000(0000)
knlGS:0000000000000000
2010-06-07T10:10:35.912278+08:00 boston kernel: CS:  0010 DS: 0000 ES:
0000 CR0: 0000000080050033
2010-06-07T10:10:35.912280+08:00 boston kernel: CR2: 00000000022f8190
CR3: 000000023721b000 CR4: 00000000000006e0
2010-06-07T10:10:35.912283+08:00 boston kernel: DR0: 0000000000000000
DR1: 0000000000000000 DR2: 0000000000000000
2010-06-07T10:10:35.912285+08:00 boston kernel: DR3: 0000000000000000
DR6: 00000000ffff0ff0 DR7: 0000000000000400
2010-06-07T10:10:35.912288+08:00 boston kernel: Process X (pid: 2569,
threadinfo ffff8802373c8000, task ffff88023af7f080)
2010-06-07T10:10:35.912290+08:00 boston kernel: Stack:
2010-06-07T10:10:35.912293+08:00 boston kernel: ffffea0007c0b988
ffff8802373d1480 ffff88023b498800 0000000000000066
2010-06-07T10:10:35.912296+08:00 boston kernel: <0> 00000000c00c6466
ffffffff81239d40 0000000000000066 000000000000e200
2010-06-07T10:10:35.912299+08:00 boston kernel: <0> 00007f7100000001
ffff88023af7f080 ffff8802373c9de8 00007fffc58c13c0
2010-06-07T10:10:35.912302+08:00 boston kernel: Call Trace:
2010-06-07T10:10:35.912306+08:00 boston kernel: [<ffffffff81239d40>] ?
drm_ioctl+0x21a/0x300
2010-06-07T10:10:35.912309+08:00 boston kernel: [<ffffffff8101f878>] ?
do_page_fault+0x2bf/0x2fa
2010-06-07T10:10:35.912312+08:00 boston kernel: [<ffffffff810a1bea>] ?
vfs_ioctl+0x23/0x93
2010-06-07T10:10:35.912316+08:00 boston kernel: [<ffffffff810a213e>] ?
do_vfs_ioctl+0x461/0x49b
2010-06-07T10:10:35.912320+08:00 boston kernel: [<ffffffff81080d7d>] ?
remove_vma+0x5b/0x63
2010-06-07T10:10:35.912323+08:00 boston kernel: [<ffffffff81081d3f>] ?
do_munmap+0x2d9/0x2fb
2010-06-07T10:10:35.912326+08:00 boston kernel: [<ffffffff810a21b4>] ?
sys_ioctl+0x3c/0x5c
2010-06-07T10:10:35.912329+08:00 boston kernel: [<ffffffff81001f02>] ?
system_call_fastpath+0x16/0x1b
2010-06-07T10:10:35.912333+08:00 boston kernel: Code: 41 8a 85 b1 00
00 00 83 e0 03 fe c8 75 3c 49 83 bd 88 00 00 00 00 75 32 49 8b 45 10
48 8b 40 18 48 8b 78 10 48 8b 87 f0 00 00 00 <48> 8b 40 60 48 85 c0 74
02 ff d0 41 8a 85 b1 00 00 00 83 e0 fc
2010-06-07T10:10:35.912337+08:00 boston kernel: RIP
[<ffffffff812514a5>] i915_gem_madvise_ioctl+0xea/0x142
2010-06-07T10:10:35.912340+08:00 boston kernel: RSP <ffff8802373c9d88>


Another oops ...

2010-06-05T08:50:51.499834+08:00 boston kernel: Pid: 2119, comm: X Not
tainted 2.6.35-rc1 #33 5413FGA/5413FGA
2010-06-05T08:50:51.499843+08:00 boston kernel: RIP:
0010:[<ffffffff810805c5>]  [<ffffffff810805c5>] find_vma+0x28/0x55
2010-06-05T08:50:51.499846+08:00 boston kernel: RSP:
0018:ffff8802372adf00  EFLAGS: 00010202
2010-06-05T08:50:51.499848+08:00 boston kernel: RAX: ffff88023ab61b28
RBX: ffff88023a9e7100 RCX: 07200720072006f0
2010-06-05T08:50:51.499850+08:00 boston kernel: RDX: 0720072007200720
RSI: 00007f236f34a000 RDI: ffff88023a9e7100
2010-06-05T08:50:51.499852+08:00 boston kernel: RBP: ffff88023ab61d20
R08: 0000000001173ad0 R09: 0000000000000847
2010-06-05T08:50:51.499855+08:00 boston kernel: R10: 00007f236d694eb0
R11: 0000000000003206 R12: 00007f236f349000
2010-06-05T08:50:51.499857+08:00 boston kernel: R13: ffff88023ab61c78
R14: 00007f236f34a000 R15: 0000000000000001
2010-06-05T08:50:51.499859+08:00 boston kernel: FS:
00007f236f511840(0000) GS:ffff880001880000(0000)
knlGS:0000000000000000
2010-06-05T08:50:51.499861+08:00 boston kernel: CS:  0010 DS: 0000 ES:
0000 CR0: 0000000080050033
2010-06-05T08:50:51.499863+08:00 boston kernel: CR2: 00000000027c6220
CR3: 00000002371b0000 CR4: 00000000000006e0
2010-06-05T08:50:51.499866+08:00 boston kernel: DR0: 0000000000000000
DR1: 0000000000000000 DR2: 0000000000000000
2010-06-05T08:50:51.499869+08:00 boston kernel: DR3: 0000000000000000
DR6: 00000000ffff0ff0 DR7: 0000000000000400
2010-06-05T08:50:51.499872+08:00 boston kernel: Process X (pid: 2119,
threadinfo ffff8802372ac000, task ffff88023ae94920)
2010-06-05T08:50:51.499874+08:00 boston kernel: Stack:
2010-06-05T08:50:51.499877+08:00 boston kernel: ffffffff81081b1b
ffff88023ab61168 ffff88023a9e7108 ffff88023722c240
2010-06-05T08:50:51.499880+08:00 boston kernel: <0> ffff88023a9e7168
ffff88023a9e7100 00007f236f349000 0000000000001000
2010-06-05T08:50:51.499883+08:00 boston kernel: <0> 0000000001178860
0000000000000001 ffffffff81081cd3 0000000000000003
2010-06-05T08:50:51.499885+08:00 boston kernel: Call Trace:
2010-06-05T08:50:51.499888+08:00 boston kernel: [<ffffffff81081b1b>] ?
do_munmap+0x17d/0x2fb
2010-06-05T08:50:51.499891+08:00 boston kernel: [<ffffffff81081cd3>] ?
sys_munmap+0x3a/0x50
2010-06-05T08:50:51.499894+08:00 boston kernel: [<ffffffff81001f02>] ?
system_call_fastpath+0x16/0x1b
2010-06-05T08:50:51.499898+08:00 boston kernel: Code: 47 48 c3 31 c0
48 85 ff 74 4d 48 8b 47 18 48 85 c0 74 0c 48 39 70 10 76 06 48 39 70
08 76 38 48 8b 57 08 31 c0 eb 22 48 8d 4a d0 <48> 39 72 e0 76 14 48 39
72 d8 77 05 48 89 c8 eb 12 48 8b 52 10
2010-06-05T08:50:51.499902+08:00 boston kernel: RIP
[<ffffffff810805c5>] find_vma+0x28/0x55
2010-06-05T08:50:51.499905+08:00 boston kernel: RSP <ffff8802372adf00>
2010-06-05T08:50:51.499909+08:00 boston kernel: ---[ end trace
b56d3a9bc0175a41 ]---



Thanks,
Jeff
