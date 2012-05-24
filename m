Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751764Ab2EXEsV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 00:48:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37419 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab2EXEsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 00:48:19 -0400
Date: Wed, 23 May 2012 21:48:17 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: ethan zhao <ethan.kernel@gmail.com>
cc: Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>
Subject: Re: Huge memory takes too long time to initialize on 4TB ?
In-Reply-To: <CABawtvO7kTR0OyY9yPhL+cLF8ehDF1R94ayBc4yQXc16Mbd0yg@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1205232146450.10366@chino.kir.corp.google.com>
References: <CABawtvMgrsAQaQy7RO5XFbj7qu8+4WHqaZbbNQOeEwhMs58Oyw@mail.gmail.com> <alpine.DEB.2.00.1205222035591.28165@chino.kir.corp.google.com> <20120523233240.GD4071@redhat.com> <alpine.DEB.2.00.1205231731250.8785@chino.kir.corp.google.com>
 <CABawtvO7kTR0OyY9yPhL+cLF8ehDF1R94ayBc4yQXc16Mbd0yg@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 May 2012, ethan zhao wrote:

> BUG: soft lockup - CPU#60 stuck for 21s! [swapper:1]
> Modules linked in:
> CPU 60
> Modules linked in:
> 
> Pid: 1, comm: swapper Not tainted 2.6.39-100.6.1.el6uek.x86_64 #1
> Oracle Corporation  Sun Fire X4800 M2 /
> RIP: 0010:[<ffffffff814fb2d9>]  [<ffffffff814fb2d9>]
> _raw_spin_unlock_irqrestore+0x19/0x30
> RSP: 0000:ffff887d8efbfe38  EFLAGS: 00000286
> RAX: 0000000038080200 RBX: ffff887d8efbfe00 RCX: 0340000000000400
> RDX: ffffea0c41bfe8d0 RSI: 0000000000000286 RDI: 0000000000000286
> RBP: ffff887d8efbfe40 R08: 0000000000000004 R09: 0000000000000000
> R10: ffff8b807ffcbfe8 R11: 0000000000014f50 R12: ffffffff81503f4e
> R13: ffffea0a81c00000 R14: ffff897d8d69b060 R15: ffff897d8d69b000
> FS:  0000000000000000(0000) GS:ffff8b807f800000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 0000000000000000 CR3: 0000000001761000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process swapper (pid: 1, threadinfo ffff887d8efbe000, task ffff887d8efbc040)
> Stack:
>  ffff8b807ffece00 ffff887d8efbfe80 ffffffff811105d1 ffff887d8efbfe80
>  ffffffff819aee60 0000000000000000 ffffffff814f7483 0000000000000000
>  0000000000000000 ffff887d8efbfea0 ffffffff814f74c0 ffffffff819aee58
> Call Trace:
>  [<ffffffff811105d1>] setup_per_zone_wmarks+0xb1/0xe0
>  [<ffffffff814f7483>] ? free_area_init_node+0xcb/0xcb
>  [<ffffffff814f74c0>] init_per_zone_wmark_min+0x3d/0x8b
>  [<ffffffff81002043>] do_one_initcall+0x43/0x190
>  [<ffffffff818c46fd>] kernel_init+0x15b/0x1e6
>  [<ffffffff815046a4>] kernel_thread_helper+0x4/0x10
>  [<ffffffff818c45a2>] ? parse_early_options+0x20/0x20
>  [<ffffffff815046a0>] ? gs_change+0x13/0x13

Yeah, this confirms what I was suspecting in that its a soft lockup 
because irqs aren't getting enabled for a lengthy period of time due to 
how long setup_per_zone_wmarks() takes for your system with 4TB of RAM.  
3.3 or later kernels should significantly improve this.  If there's still 
an issue, please let us know.
