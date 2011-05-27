Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517Ab1E0MlL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 08:41:11 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50513 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217Ab1E0MlH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 08:41:07 -0400
MIME-Version: 1.0
In-Reply-To: <1306476003-4624-2-git-send-email-namhyung@gmail.com>
References: <1306476003-4624-1-git-send-email-namhyung@gmail.com>
	<1306476003-4624-2-git-send-email-namhyung@gmail.com>
Date: Fri, 27 May 2011 08:41:06 -0400
Message-ID: <BANLkTimkM=n6yR9AoMfJWVdYackcSjrSCw@mail.gmail.com>
Subject: Re: [PATCH 2/3] nbd: limit module parameters to a sane value
From: Paul Clements <paul.clements@us.sios.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        Laurent Vivier <Laurent.Vivier@bull.net>, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 2:00 AM, Namhyung Kim <namhyung@gmail.com> wrote:
> The 'max_part' parameter controls the number of maximum partition
> a nbd device can have. However if a user specifies very large
> value it would exceed the limitation of device minor number and
> can cause a kernel oops (or, at least, produce invalid device
> nodes in some cases).

Then don't do that... :)

Patch looks good.

Thanks,
Paul

> In addition, specifying large 'nbds_max' value causes same
> problem for the same reason.
>
> On my desktop, following command results to the kernel bug:
>
> $ sudo modprobe nbd max_part=100000
>  kernel BUG at /media/Linux_Data/project/linux/fs/sysfs/group.c:65!
>  invalid opcode: 0000 [#1] SMP
>  last sysfs file: /sys/devices/virtual/block/nbd4/range
>  CPU 1
>  Modules linked in: nbd(+) bridge stp llc kvm_intel kvm asus_atk0110 sg sr_mod cdrom
>
>  Pid: 2522, comm: modprobe Tainted: G        W   2.6.39-leonard+ #159 System manufacturer System Product Name/P5G41TD-M PRO
>  RIP: 0010:[<ffffffff8115aa08>]  [<ffffffff8115aa08>] internal_create_group+0x2f/0x166
>  RSP: 0018:ffff8801009f1de8  EFLAGS: 00010246
>  RAX: 00000000ffffffef RBX: ffff880103920478 RCX: 00000000000a7bd3
>  RDX: ffffffff81a2dbe0 RSI: 0000000000000000 RDI: ffff880103920478
>  RBP: ffff8801009f1e38 R08: ffff880103920468 R09: ffff880103920478
>  R10: ffff8801009f1de8 R11: ffff88011eccbb68 R12: ffffffff81a2dbe0
>  R13: ffff880103920468 R14: 0000000000000000 R15: ffff880103920400
>  FS:  00007f3c49de9700(0000) GS:ffff88011f800000(0000) knlGS:0000000000000000
>  CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>  CR2: 00007f3b7fe7c000 CR3: 00000000cd58d000 CR4: 00000000000406e0
>  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>  DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>  Process modprobe (pid: 2522, threadinfo ffff8801009f0000, task ffff8801009a93a0)
>  Stack:
>  ffff8801009f1e58 ffffffff812e8f6e ffff8801009f1e58 ffffffff812e7a80
>  ffff880000000010 ffff880103920400 ffff8801002fd0c0 ffff880103920468
>  0000000000000011 ffff880103920400 ffff8801009f1e48 ffffffff8115ab6a
>  Call Trace:
>  [<ffffffff812e8f6e>] ? device_add+0x4f1/0x5e4
>  [<ffffffff812e7a80>] ? dev_set_name+0x41/0x43
>  [<ffffffff8115ab6a>] sysfs_create_group+0x13/0x15
>  [<ffffffff810b857e>] blk_trace_init_sysfs+0x14/0x16
>  [<ffffffff811ee58b>] blk_register_queue+0x4c/0xfd
>  [<ffffffff811f3bdf>] add_disk+0xe4/0x29c
>  [<ffffffffa007e2ab>] nbd_init+0x2ab/0x30d [nbd]
>  [<ffffffffa007e000>] ? 0xffffffffa007dfff
>  [<ffffffff8100020f>] do_one_initcall+0x7f/0x13e
>  [<ffffffff8107ab0a>] sys_init_module+0xa1/0x1e3
>  [<ffffffff814f3542>] system_call_fastpath+0x16/0x1b
>  Code: 41 57 41 56 41 55 41 54 53 48 83 ec 28 0f 1f 44 00 00 48 89 fb 41 89 f6 49 89 d4 48 85 ff 74 0b 85 f6 75 0b 48 83
>  7f 30 00 75 14 <0f> 0b eb fe b9 ea ff ff ff 48 83 7f 30 00 0f 84 09 01 00 00 49
>  RIP  [<ffffffff8115aa08>] internal_create_group+0x2f/0x166
>  RSP <ffff8801009f1de8>
>  ---[ end trace 753285ffbf72c57c ]---
>
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> Cc: Laurent Vivier <Laurent.Vivier@bull.net>
> Cc: Paul Clements <Paul.Clements@steeleye.com>
> Cc: stable@kernel.org
> ---
>  drivers/block/nbd.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
> index 1df3bfe5225b..fdee7567fd15 100644
> --- a/drivers/block/nbd.c
> +++ b/drivers/block/nbd.c
> @@ -757,6 +757,12 @@ static int __init nbd_init(void)
>        if (max_part > 0)
>                part_shift = fls(max_part);
>
> +       if ((1UL << part_shift) > DISK_MAX_PARTS)
> +               return -EINVAL;
> +
> +       if (nbds_max > 1UL << (MINORBITS - part_shift))
> +               return -EINVAL;
> +
>        for (i = 0; i < nbds_max; i++) {
>                struct gendisk *disk = alloc_disk(1 << part_shift);
>                if (!disk)
> --
> 1.7.5.2
>
>
