Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751701Ab2AULmm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 06:42:42 -0500
Received: from trent.utfs.org ([194.246.123.103]:39418 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831Ab2AULml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 06:42:41 -0500
Date: Sat, 21 Jan 2012 03:42:32 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: peterz@infradead.org, axboe@kernel.dk, dm-devel@redhat.com
Subject: Re: BUG: spinlock trylock failure on UP on CPU#0, vgchange/936
In-Reply-To: <alpine.DEB.2.01.1201180009520.2895@trent.utfs.org>
Message-ID: <alpine.DEB.2.01.1201210341430.2895@trent.utfs.org>
References: <alpine.DEB.2.01.1201180009520.2895@trent.utfs.org>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jan 2012 at 00:18, Christian Kujau wrote:
> today's git checkout boots fine on powerpc32, but has this message during 
> bootup:
> 
> BUG: spinlock trylock failure on UP on CPU#0, vgchange/936
>  lock: ef32a9f8, .magic: dead4ead, .owner: vgchange/936, .owner_cpu: 0
> Call Trace:

Still happening with 3.3.0-rc1.

Anyone?

Thanks,
Christian.

> [eed459e0] [c0009de4] show_stack+0x70/0x1bc (unreliable)
> [eed45a20] [c0326da8] spin_dump+0x70/0xe0
> [eed45a30] [c0326f8c] do_raw_spin_trylock+0x58/0x70
> [eed45a40] [c0512b28] _raw_spin_trylock+0x34/0xa0
> [eed45a60] [c02f5510] put_io_context+0xd8/0x184
> [eed45a80] [c0303428] __cfq_slice_expired+0x1e4/0x43c
> [eed45ac0] [c03053d8] cfq_insert_request+0x264/0x5b0
> [eed45ae0] [c02edef4] __elv_add_request+0x1a4/0x2d4
> [eed45af0] [c02f1024] blk_flush_plug_list+0x22c/0x270
> [eed45b20] [c05112dc] io_schedule+0x74/0xec
> [eed45b30] [c0110f88] dio_await_completion+0x60/0xf4
> [eed45b50] [c0112d0c] __blockdev_direct_IO+0x1b80/0x3574
> [eed45d70] [c010f4a4] blkdev_direct_IO+0x54/0x64
> [eed45d90] [c009a424] generic_file_aio_read+0x7b8/0x808
> [eed45e40] [c00d4f68] do_sync_read+0xb8/0x144
> [eed45ef0] [c00d6168] vfs_read+0xcc/0x1c0
> [eed45f10] [c00d6394] sys_read+0x58/0xc8
> [eed45f40] [c00127a0] ret_from_syscall+0x0/0x38
> --- Exception: c01 at 0xfe52b90
>     LR = 0x1003e834
> 
> The system is running fine so far and has before with 3.2.0-rc7, without 
> that warning. The "vgchange" could be the result of some LVM2 initscripts 
> (lvm2-2.02.66-5 are installed on this Debian/stable system), but there are 
> no LVM disks anywhere on the system.
> 
> Full .config & dmesg: http://nerdbynature.de/bits/3.2.0/
> 
> Is this BUG something to worry about?
> 
> Thanks,
> Christian.
> -- 
> BOFH excuse #100:
> 
> IRQ dropout
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
BOFH excuse #63:

not properly grounded, please bury computer
