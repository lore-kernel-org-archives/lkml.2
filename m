Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273Ab0KHVAE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 16:00:04 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60402 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754339Ab0KHVAC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 16:00:02 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jerome Glisse <j.glisse@gmail.com>
Subject: Re: Radeon RS780 - BUG: unable to handle kernel NULL pointer dereference
Date: Mon, 8 Nov 2010 21:58:59 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        airlied@linux.ie, Thomas Hellstrom <thellstrom@vmware.com>
References: <20101108170221.GA1602@arch.trippelsdorf.de> <20101108190258.GA1623@arch.trippelsdorf.de> <AANLkTi=fo3rnBp8Fs6H+ivP6R+x=QDzBLyi+DmT-LNHV@mail.gmail.com>
In-Reply-To: <AANLkTi=fo3rnBp8Fs6H+ivP6R+x=QDzBLyi+DmT-LNHV@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011082159.00199.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 08, 2010, Jerome Glisse wrote:
> On Mon, Nov 8, 2010 at 2:02 PM, Markus Trippelsdorf
> <markus@trippelsdorf.de> wrote:
> > On Mon, Nov 08, 2010 at 07:43:02PM +0100, Markus Trippelsdorf wrote:
> >> On Mon, Nov 08, 2010 at 06:07:37PM +0100, Markus Trippelsdorf wrote:
> >> > On Mon, Nov 08, 2010 at 06:02:21PM +0100, Markus Trippelsdorf wrote:
> >> > > I can trigger a kernel crash on my system by simply loading this png
> >> > > image with firefox:
> >> > > http://mediaarchive.cern.ch/MediaArchive/Photo/Public/2010/1011251/1011251_01/1011251_01-A4-at-144-dpi.jpg
> >> >
> >> > Sorry the above link is wrong, this is the right one (that triggers the
> >> > crash):
> >> > http://cdsweb.cern.ch/record/1305179/files/HI-150431-630470-huge.png
> >>
> >> I triggered it a few more times and took the attached picture.
> >> It points to the BUG() call at drivers/gpu/drm/ttm/ttm_bo.c:1628 .
> >> (Sorry for the bad picture quality)
> >
> > And here the same BUG in plaintext (should be a bit easier to read):
> >
> > Nov  8 19:28:23 arch kernel: ------------[ cut here ]------------
> > Nov  8 19:28:23 arch kernel: kernel BUG at drivers/gpu/drm/ttm/ttm_bo.c:1628!
> > Nov  8 19:28:23 arch kernel: invalid opcode: 0000 [#1] PREEMPT SMP
> > Nov  8 19:28:23 arch kernel: last sysfs file: /sys/devices/pci0000:00/0000:00:18.3/temp1_input
> > Nov  8 19:28:23 arch kernel: CPU 1
> > Nov  8 19:28:23 arch kernel: Pid: 1541, comm: X Not tainted 2.6.37-rc1-00116-g151f52f-dirty #31 M4A78T-E/System Product Name
> > Nov  8 19:28:23 arch kernel: RIP: 0010:[<ffffffff8121f0ff>]  [<ffffffff8121f0ff>] ttm_bo_init+0x30f/0x340
> > Nov  8 19:28:23 arch kernel: RSP: 0018:ffff88011b0fbbe8  EFLAGS: 00010246
> > Nov  8 19:28:23 arch kernel: RAX: ffff8800da881778 RBX: ffff8800da881620 RCX: ffff88011b15ed78
> > Nov  8 19:28:23 arch kernel: RDX: ffff8800c1556040 RSI: ffff88011ff22770 RDI: 000000000017adfb
> > Nov  8 19:28:23 arch kernel: RBP: ffff8800da881648 R08: 0000000000000000 R09: ffff8800c1556040
> > Nov  8 19:28:23 arch kernel: R10: 000000000ff85205 R11: ffff8800dae19200 R12: 0000000000000001
> > Nov  8 19:28:23 arch kernel: R13: ffff88011ff22528 R14: ffff88011ff22778 R15: 0000000000000000
> > Nov  8 19:28:23 arch kernel: FS:  00007f2043043700(0000) GS:ffff8800dfc80000(0000) knlGS:0000000000000000
> > Nov  8 19:28:23 arch kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > Nov  8 19:28:23 arch kernel: CR2: 00007f203d057000 CR3: 000000011b12b000 CR4: 00000000000006e0
> > Nov  8 19:28:23 arch kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > Nov  8 19:28:23 arch kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > Nov  8 19:28:23 arch kernel: Process X (pid: 1541, threadinfo ffff88011b0fa000, task ffff88011c959c20)
> > Nov  8 19:28:23 arch kernel: Stack:
> > Nov  8 19:28:23 arch kernel: 0000000000000000 ffff8800da881648 ffff88011b0fbd00 ffff8800da881600
> > Nov  8 19:28:23 arch kernel: ffff88011ff22000 0000000000000000 0000000000000001 00000000fffffff4
> > Nov  8 19:28:23 arch kernel: ffff88011b0fbd00 ffffffff8125294d 0000000000000000 ffffffff00000001
> > Nov  8 19:28:23 arch kernel: Call Trace:
> > Nov  8 19:28:23 arch kernel: [<ffffffff8125294d>] ? radeon_bo_create+0x14d/0x250
> > Nov  8 19:28:23 arch kernel: [<ffffffff812526c0>] ? radeon_ttm_bo_destroy+0x0/0xb0
> > Nov  8 19:28:23 arch kernel: [<ffffffff812671cc>] ? radeon_gem_object_create+0x8c/0x130
> > Nov  8 19:28:23 arch kernel: [<ffffffff81267634>] ? radeon_gem_create_ioctl+0x54/0xd0
> > Nov  8 19:28:23 arch kernel: [<ffffffff813ab26d>] ? sock_aio_read+0x10d/0x120
> > Nov  8 19:28:23 arch kernel: [<ffffffff8120963c>] ? drm_ioctl+0x39c/0x450
> > Nov  8 19:28:23 arch kernel: [<ffffffff812675e0>] ? radeon_gem_create_ioctl+0x0/0xd0
> > Nov  8 19:28:23 arch kernel: [<ffffffff810dd2c9>] ? do_vfs_ioctl+0xa9/0x610
> > Nov  8 19:28:23 arch kernel: [<ffffffff810dd879>] ? sys_ioctl+0x49/0x80
> > Nov  8 19:28:23 arch kernel: [<ffffffff810ce24e>] ? sys_read+0x4e/0x90
> > Nov  8 19:28:23 arch kernel: [<ffffffff8102dc2b>] ? system_call_fastpath+0x16/0x1b
> > Nov  8 19:28:23 arch kernel: Code: e8 fb ff ff 85 c0 0f 85 68 ff ff ff 48 8b 7c 24 08 89 04 24 e8 83 d9 ff ff 8b 04 24 48 83 c4 18 5b 5d 41 5c 41 5d 41 5e 41 5f c3 <0f> 0b 48 c7 c7 60 a4 55 81 31 c0 e8 14 80 22 00 b8 ea ff ff ff
> > Nov  8 19:28:23 arch kernel: RIP  [<ffffffff8121f0ff>] ttm_bo_init+0x30f/0x340
> > Nov  8 19:28:23 arch kernel: RSP <ffff88011b0fbbe8>
> > Nov  8 19:28:23 arch kernel: ---[ end trace 328a9acba7691d6e ]---
> > Nov  8 19:28:23 arch kernel: note: X[1541] exited with preempt_count 1
> > Nov  8 19:28:23 arch kernel: BUG: scheduling while atomic: X/1541/0x10000002
> > Nov  8 19:28:23 arch kernel: Pid: 1541, comm: X Tainted: G      D     2.6.37-rc1-00116-g151f52f-dirty #31
> > Nov  8 19:28:23 arch kernel: Call Trace:
> > Nov  8 19:28:23 arch kernel: [<ffffffff81447ad9>] ? schedule+0x639/0x850
> > Nov  8 19:28:23 arch kernel: [<ffffffff8105826d>] ? __cond_resched+0x1d/0x30
> > Nov  8 19:28:23 arch kernel: [<ffffffff81447f2f>] ? _cond_resched+0x2f/0x40
> > Nov  8 19:28:23 arch kernel: [<ffffffff810b57fc>] ? unmap_vmas+0x82c/0x9c0
> > Nov  8 19:28:23 arch kernel: [<ffffffff810bcb62>] ? exit_mmap+0xe2/0x1a0
> > Nov  8 19:28:23 arch kernel: [<ffffffff8105a705>] ? mmput+0x25/0xc0
> > Nov  8 19:28:23 arch kernel: [<ffffffff8105e734>] ? exit_mm+0x104/0x130
> > Nov  8 19:28:23 arch kernel: [<ffffffff81079ebf>] ? hrtimer_try_to_cancel+0x3f/0x80
> > Nov  8 19:28:23 arch kernel: [<ffffffff81089d0a>] ? acct_collect+0x9a/0x1a0
> > Nov  8 19:28:23 arch kernel: [<ffffffff8106045a>] ? do_exit+0x5aa/0x760
> > Nov  8 19:28:23 arch kernel: [<ffffffff81447163>] ? printk+0x40/0x45
> > Nov  8 19:28:23 arch kernel: [<ffffffff8105e33c>] ? kmsg_dump+0x7c/0x150
> > Nov  8 19:28:23 arch kernel: [<ffffffff81031fda>] ? oops_end+0x9a/0xe0
> > Nov  8 19:28:23 arch kernel: [<ffffffff8102ee74>] ? do_invalid_op+0x84/0xa0
> > Nov  8 19:28:23 arch kernel: [<ffffffff8121f0ff>] ? ttm_bo_init+0x30f/0x340
> > Nov  8 19:28:23 arch kernel: [<ffffffff810ddf50>] ? __pollwait+0x0/0x110
> > Nov  8 19:28:23 arch kernel: [<ffffffff8102e7d5>] ? invalid_op+0x15/0x20
> > Nov  8 19:28:23 arch kernel: [<ffffffff8121f0ff>] ? ttm_bo_init+0x30f/0x340
> > Nov  8 19:28:23 arch kernel: [<ffffffff8121efe3>] ? ttm_bo_init+0x1f3/0x340
> > Nov  8 19:28:23 arch kernel: [<ffffffff8125294d>] ? radeon_bo_create+0x14d/0x250
> > Nov  8 19:28:23 arch kernel: [<ffffffff812526c0>] ? radeon_ttm_bo_destroy+0x0/0xb0
> > Nov  8 19:28:23 arch kernel: [<ffffffff812671cc>] ? radeon_gem_object_create+0x8c/0x130
> > Nov  8 19:28:23 arch kernel: [<ffffffff81267634>] ? radeon_gem_create_ioctl+0x54/0xd0
> > Nov  8 19:28:23 arch kernel: [<ffffffff813ab26d>] ? sock_aio_read+0x10d/0x120
> > Nov  8 19:28:23 arch kernel: [<ffffffff8120963c>] ? drm_ioctl+0x39c/0x450
> > Nov  8 19:28:23 arch kernel: [<ffffffff812675e0>] ? radeon_gem_create_ioctl+0x0/0xd0
> > Nov  8 19:28:23 arch kernel: [<ffffffff810dd2c9>] ? do_vfs_ioctl+0xa9/0x610
> > Nov  8 19:28:23 arch kernel: [<ffffffff810dd879>] ? sys_ioctl+0x49/0x80
> > Nov  8 19:28:23 arch kernel: [<ffffffff810ce24e>] ? sys_read+0x4e/0x90
> > Nov  8 19:28:23 arch kernel: [<ffffffff8102dc2b>] ? system_call_fastpath+0x16/0x1b
> > Nov  8 19:28:23 arch kernel: BUG: scheduling while atomic: X/1541/0x10000002
> > Nov  8 19:28:23 arch kernel: Pid: 1541, comm: X Tainted: G      D     2.6.37-rc1-00116-g151f52f-dirty #31
> > Nov  8 19:28:23 arch kernel: Call Trace:
> > Nov  8 19:28:23 arch kernel: [<ffffffff81447ad9>] ? schedule+0x639/0x850
> > Nov  8 19:28:23 arch kernel: [<ffffffff8105826d>] ? __cond_resched+0x1d/0x30
> > Nov  8 19:28:23 arch kernel: [<ffffffff81447f2f>] ? _cond_resched+0x2f/0x40
> > Nov  8 19:28:23 arch kernel: [<ffffffff810b57fc>] ? unmap_vmas+0x82c/0x9c0
> > Nov  8 19:28:23 arch kernel: [<ffffffff810bcb62>] ? exit_mmap+0xe2/0x1a0
> > Nov  8 19:28:23 arch kernel: [<ffffffff8105a705>] ? mmput+0x25/0xc0
> > Nov  8 19:28:23 arch kernel: [<ffffffff8105e734>] ? exit_mm+0x104/0x130
> > Nov  8 19:28:23 arch kernel: [<ffffffff81079ebf>] ? hrtimer_try_to_cancel+0x3f/0x80
> > Nov  8 19:28:23 arch kernel: [<ffffffff81089d0a>] ? acct_collect+0x9a/0x1a0
> > Nov  8 19:28:23 arch kernel: [<ffffffff8106045a>] ? do_exit+0x5aa/0x760
> > Nov  8 19:28:23 arch kernel: [<ffffffff81447163>] ? printk+0x40/0x45
> > Nov  8 19:28:23 arch kernel: [<ffffffff8105e33c>] ? kmsg_dump+0x7c/0x150
> > Nov  8 19:28:23 arch kernel: [<ffffffff81031fda>] ? oops_end+0x9a/0xe0
> > Nov  8 19:28:23 arch kernel: [<ffffffff8102ee74>] ? do_invalid_op+0x84/0xa0
> > Nov  8 19:28:23 arch kernel: [<ffffffff8121f0ff>] ? ttm_bo_init+0x30f/0x340
> > Nov  8 19:28:23 arch kernel: [<ffffffff810ddf50>] ? __pollwait+0x0/0x110
> > Nov  8 19:28:23 arch kernel: [<ffffffff8102e7d5>] ? invalid_op+0x15/0x20
> > Nov  8 19:28:23 arch kernel: [<ffffffff8121f0ff>] ? ttm_bo_init+0x30f/0x340
> > Nov  8 19:28:23 arch kernel: [<ffffffff8121efe3>] ? ttm_bo_init+0x1f3/0x340
> > Nov  8 19:28:23 arch kernel: [<ffffffff8125294d>] ? radeon_bo_create+0x14d/0x250
> > Nov  8 19:28:23 arch kernel: [<ffffffff812526c0>] ? radeon_ttm_bo_destroy+0x0/0xb0
> > Nov  8 19:28:23 arch kernel: [<ffffffff812671cc>] ? radeon_gem_object_create+0x8c/0x130
> > Nov  8 19:28:23 arch kernel: [<ffffffff81267634>] ? radeon_gem_create_ioctl+0x54/0xd0
> > Nov  8 19:28:23 arch kernel: [<ffffffff813ab26d>] ? sock_aio_read+0x10d/0x120
> > Nov  8 19:28:23 arch kernel: [<ffffffff8120963c>] ? drm_ioctl+0x39c/0x450
> > Nov  8 19:28:23 arch kernel: [<ffffffff812675e0>] ? radeon_gem_create_ioctl+0x0/0xd0
> > Nov  8 19:28:23 arch kernel: [<ffffffff810dd2c9>] ? do_vfs_ioctl+0xa9/0x610
> > Nov  8 19:28:23 arch kernel: [<ffffffff810dd879>] ? sys_ioctl+0x49/0x80
> > Nov  8 19:28:23 arch kernel: [<ffffffff810ce24e>] ? sys_read+0x4e/0x90
> > Nov  8 19:28:23 arch kernel: [<ffffffff8102dc2b>] ? system_call_fastpath+0x16/0x1b
> >
> 
> Thomas this bug seems to point to a case where we endup trying adding
> an entry to
> same offset in the rb tree for addr_space_mm. After reviewing
> carefully the locking
> around the rb tree modification & addr_space_mm i am fairly confident
> that no race can
> occur. Would you have any idea on what might go wrong here ? I guess i would
> ultimately need to dump mm & rb tree state when BUG get trigger to try
> to understand
> states of things.

Hmm, why are you using BUG in there in the first place?  Would it be _so_
dangerous to continue that we just have to crash here?

Rafael
