Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123Ab0DAKhJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 06:37:09 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:38226 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755003Ab0DAKhD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 06:37:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HmxOoHZO6GLibL7YPwP4HBHjWbGqhcpaSGIfp13g+GrLSXtiunMA4fKM95HQyD2F4I
         6PXIA/GTTrreFfRC0e8vG0D2xeI2Q4HJwzdXG8V3SmNwvq2EoFDKf4cYZUtyNX0VX3S9
         84HBsjsf0qIfwJObtKTN86AiiubZb//ofVyno=
MIME-Version: 1.0
In-Reply-To: <179901cad182$5f87f620$0400a8c0@dcccs>
References: <03ca01cacb92$195adf50$0400a8c0@dcccs>
	 <2375c9f91003242029p1efbbea1v8e313e460b118f14@mail.gmail.com>
	 <20100325153110.6be9a3df.kamezawa.hiroyu@jp.fujitsu.com>
	 <02c101cacbf8$d21d1650$0400a8c0@dcccs>
	 <179901cad182$5f87f620$0400a8c0@dcccs>
Date: Thu, 1 Apr 2010 18:37:00 +0800
Message-ID: <t2h2375c9f91004010337p618c4d5yc739fa25b5f842fa@mail.gmail.com>
Subject: Re: Somebody take a look please! (some kind of kernel bug?)
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Janos Haar <janos.haar@netcenter.hu>
Cc: linux-kernel@vger.kernel.org,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
       xfs@oss.sgi.com, Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 1, 2010 at 6:01 PM, Janos Haar <janos.haar@netcenter.hu> wrote:
> Hello,
>

Hi,
This is a totally different bug from the previous one reported by you. :)

> Another issue with this productive server:
> Can somebody point me to the rigth direction?
> Or support that this is a hw problem or not?


Probably no, it looks like an XFS bug or a write-back bug.

Thanks for your report. Cc'ing related people...


>
> The messages file are here:
> http://download.netcenter.hu/bughunt/20100324/marc30
>
> Thanks,
> Janos Haar
>
> Mar 30 18:51:43 alfa kernel: BUG: unable to handle kernel paging request at
> 000000320000008c
> Mar 30 18:51:43 alfa kernel: IP: [<ffffffff811d755b>]
> xfs_iflush_cluster+0x148/0x35a
> Mar 30 18:51:43 alfa kernel: PGD 102d7a067 PUD 0
> Mar 30 18:51:43 alfa kernel: Oops: 0000 [#1] SMP
> Mar 30 18:51:43 alfa kernel: last sysfs file: /sys/class/misc/rfkill/dev
> Mar 30 18:51:43 alfa kernel: CPU 0
> Mar 30 18:51:43 alfa kernel: Modules linked in: hidp l2cap crc16 bluetooth
> rfkill ipv6 video output sbs sbshc battery ac parport_pc lp parport
> serio_raw 8250_
> pnp 8250 serial_core shpchp button i2c_i801 i2c_core pcspkr
> Mar 30 18:51:43 alfa kernel: Pid: 3242, comm: flush-8:16 Not tainted
> 2.6.32.10 #2
> Mar 30 18:51:43 alfa kernel: RIP: 0010:[<ffffffff811d755b>]
> [<ffffffff811d755b>] xfs_iflush_cluster+0x148/0x35a
> Mar 30 18:51:43 alfa kernel: RSP: 0000:ffff880228ce5b60  EFLAGS: 00010206
> Mar 30 18:51:43 alfa kernel: RAX: 0000003200000000 RBX: ffff8801537947d0
> RCX: 000000000000001a
> Mar 30 18:51:43 alfa kernel: RDX: 0000000000000020 RSI: 00000000000c6cc2
> RDI: 0000000000000001
> Mar 30 18:51:43 alfa kernel: RBP: ffff880228ce5bd0 R08: ffff880228ce5b20
> R09: ffff8801ea436928
> Mar 30 18:51:43 alfa kernel: R10: 00000000000c6cc2 R11: 0000000000000001
> R12: ffff8800b630b11a
> Mar 30 18:51:43 alfa kernel: R13: ffff8801bd54ab30 R14: ffff88022962d2b8
> R15: 00000000000c6ca0
> Mar 30 18:51:43 alfa kernel: FS:  0000000000000000(0000)
> GS:ffff880028200000(0000) knlGS:0000000000000000
> Mar 30 18:51:43 alfa kernel: CS:  0010 DS: 0018 ES: 0018 CR0:
> 000000008005003b
> Mar 30 18:51:43 alfa kernel: CR2: 000000320000008c CR3: 0000000168e75000
> CR4: 00000000000006f0
> Mar 30 18:51:43 alfa kernel: DR0: 0000000000000000 DR1: 0000000000000000
> DR2: 0000000000000000
> Mar 30 18:51:43 alfa kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0
> DR7: 0000000000000400
> Mar 30 18:51:43 alfa kernel: Process flush-8:16 (pid: 3242, threadinfo
> ffff880228ce4000, task ffff880228ea4040)
> Mar 30 18:51:43 alfa kernel: Stack:
> Mar 30 18:51:43 alfa kernel:  ffff8801bd54ab30 ffff8800b630b140
> ffff88022a2d99d0 ffffffffffffffe0
> Mar 30 18:51:43 alfa kernel: <0> 0000000000000020 ffff880218e3db60
> 0000002028ce5bd0 0000000200000000
> Mar 30 18:51:43 alfa kernel: <0> ffff880218e3db70 ffff8801bd54ab30
> ffff8800b630b140 0000000000000002
> Mar 30 18:51:43 alfa kernel: Call Trace:
> Mar 30 18:51:43 alfa kernel:  [<ffffffff811d7931>] xfs_iflush+0x1c4/0x272
> Mar 30 18:51:43 alfa kernel:  [<ffffffff8103458e>] ?
> try_wait_for_completion+0x24/0x45
> Mar 30 18:51:43 alfa kernel:  [<ffffffff811f819c>]
> xfs_fs_write_inode+0xe0/0x11e
> Mar 30 18:51:43 alfa kernel:  [<ffffffff810f7bcf>]
> writeback_single_inode+0x109/0x215
> Mar 30 18:51:43 alfa kernel:  [<ffffffff810f84bd>]
> writeback_inodes_wb+0x33a/0x3cc
> Mar 30 18:51:43 alfa kernel:  [<ffffffff810f8686>] wb_writeback+0x137/0x1c7
> Mar 30 18:51:43 alfa kernel:  [<ffffffff810f8830>] ?
> wb_do_writeback+0x7d/0x1ae
> Mar 30 18:51:43 alfa kernel:  [<ffffffff810f892c>]
> wb_do_writeback+0x179/0x1ae
> Mar 30 18:51:43 alfa kernel:  [<ffffffff810f8830>] ?
> wb_do_writeback+0x7d/0x1ae
> Mar 30 18:51:43 alfa kernel:  [<ffffffff8105064c>] ?
> process_timeout+0x0/0x10
> Mar 30 18:51:43 alfa kernel:  [<ffffffff810c10ed>] ? bdi_start_fn+0x0/0xd1
> Mar 30 18:51:43 alfa kernel:  [<ffffffff810f898d>]
> bdi_writeback_task+0x2c/0xa2
> Mar 30 18:51:43 alfa kernel:  [<ffffffff810c1163>] bdi_start_fn+0x76/0xd1
> Mar 30 18:51:43 alfa kernel:  [<ffffffff810c10ed>] ? bdi_start_fn+0x0/0xd1
> Mar 30 18:51:43 alfa kernel:  [<ffffffff8105dda1>] kthread+0x82/0x8d
> Mar 30 18:51:43 alfa kernel:  [<ffffffff8100c15a>] child_rip+0xa/0x20
> Mar 30 18:51:43 alfa kernel:  [<ffffffff8100bafc>] ? restore_args+0x0/0x30
> Mar 30 18:51:43 alfa kernel:  [<ffffffff81038596>] ?
> finish_task_switch+0x0/0xbc
> Mar 30 18:51:43 alfa kernel:  [<ffffffff8105dd1f>] ? kthread+0x0/0x8d
> Mar 30 18:51:43 alfa kernel:  [<ffffffff8100c150>] ? child_rip+0x0/0x20
> Mar 30 18:51:43 alfa kernel: Code: 8e eb 01 00 00 b8 01 00 00 00 48 d3 e0 ff
> c8 23 43 18 48 23 45 a8 4c 39 f8 0f 85 ae 00 00 00 48 8b 83 80 00 00 00 48
> 85 c0
> 74 0b <66> f7 80 8c 00 00 00 ff 01 75 13 80 bb 0a 02 00 00 00 75 0a 8b
> Mar 30 18:51:43 alfa kernel: RIP  [<ffffffff811d755b>]
> xfs_iflush_cluster+0x148/0x35a
> Mar 30 18:51:43 alfa kernel:  RSP <ffff880228ce5b60>
> Mar 30 18:51:43 alfa kernel: CR2: 000000320000008c
> Mar 30 18:51:43 alfa kernel: ---[ end trace e6c8391ea76602f4 ]---
> Mar 30 18:51:43 alfa kernel: flush-8:16 used greatest stack depth: 2464
> bytes left
> Mar 30 19:09:39 alfa syslogd 1.4.1: restart.
>
