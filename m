Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145Ab0HXN1I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 09:27:08 -0400
Received: from www.tglx.de ([62.245.132.106]:34753 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755023Ab0HXN1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 09:27:06 -0400
Date: Tue, 24 Aug 2010 15:26:14 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tejun Heo <tj@kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH REPOST 2.6.36-rc2] percpu_counter: add debugobj support
In-Reply-To: <4C739B49.6080409@kernel.org>
Message-ID: <alpine.LFD.2.00.1008241525250.2768@localhost.localdomain>
References: <20100813134756.GA5235@swordfish.minsk.epam.com> <4C73899A.304@kernel.org> <20100824091536.GA5440@swordfish.minsk.epam.com> <4C739B49.6080409@kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 24 Aug 2010, Tejun Heo wrote:

> All percpu counters are linked to a global list on initialization and
> removed from it on destruction.  The list is walked during CPU
> up/down.  If a percpu counter is freed without being properly
> destroyed, the system will oops only on the next CPU up/down making it
> pretty nasty to track down.  This patch adds debugobj support for
> percpu counters so that such problems can be found easily.
> 
> As percpu counters don't make sense on stack and can't be statically
> initialized, debugobj support is pretty simple.  It's initialized and
> activated on counter initialization, and deactivatd and destroyed on
> counter destruction.  With this patch applied, the bug fixed by commit
> 602586a83b719df0fbd94196a1359ed35aeb2df3 (shmem: put_super must
> percpu_counter_destroy) triggers the following warning on tmpfs
> unmount and the system won't oops on the next cpu up/down operation.
> 
>  ------------[ cut here ]------------
>  WARNING: at /devel/tj/os/work/lib/debugobjects.c:259 debug_print_object+0x5c/0x70()
>  Hardware name: Bochs
>  ODEBUG: free active (active state 0) object type: percpu_counter
>  Modules linked in:
>  Pid: 3999, comm: umount Not tainted 2.6.36-rc2-work+ #5
>  Call Trace:
>   [<ffffffff81083f7f>] warn_slowpath_common+0x7f/0xc0
>   [<ffffffff81084076>] warn_slowpath_fmt+0x46/0x50
>   [<ffffffff813b45cc>] debug_print_object+0x5c/0x70
>   [<ffffffff813b50e5>] debug_check_no_obj_freed+0x125/0x210
>   [<ffffffff811577d3>] kfree+0xb3/0x2f0
>   [<ffffffff81132edd>] shmem_put_super+0x1d/0x30
>   [<ffffffff81162e96>] generic_shutdown_super+0x56/0xe0
>   [<ffffffff81162f86>] kill_anon_super+0x16/0x60
>   [<ffffffff81162ff7>] kill_litter_super+0x27/0x30
>   [<ffffffff81163295>] deactivate_locked_super+0x45/0x60
>   [<ffffffff81163cfa>] deactivate_super+0x4a/0x70
>   [<ffffffff8117d446>] mntput_no_expire+0x86/0xe0
>   [<ffffffff8117df7f>] sys_umount+0x6f/0x360
>   [<ffffffff8103f01b>] system_call_fastpath+0x16/0x1b
>  ---[ end trace cce2a341ba3611a7 ]---
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Acked-by: Thomas Gleixner <tglxlinutronix.de>

