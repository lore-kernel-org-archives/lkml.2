Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535Ab2JQRk2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 13:40:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8285 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755751Ab2JQRk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 13:40:26 -0400
Date: Wed, 17 Oct 2012 13:40:17 -0400
From: Aristeu Rozanski <aris@redhat.com>
To: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: suspicious RCU usage in cgroup
Message-ID: <20121017174017.GK29956@redhat.com>
References: <20121005215926.GA2406@redhat.com>
 <20121005220612.GB29956@redhat.com>
 <20121017162623.GA30345@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121017162623.GA30345@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 12:26:23PM -0400, Dave Jones wrote:
> On Fri, Oct 05, 2012 at 06:06:12PM -0400, Aristeu Rozanski wrote:
>  > Hi Dave,
>  > On Fri, Oct 05, 2012 at 05:59:29PM -0400, Dave Jones wrote:
>  > > On boot in Linus' current tree..
>  > > 
>  > > ===============================
>  > > [ INFO: suspicious RCU usage. ]
>  > > 3.6.0+ #22 Not tainted
>  > > -------------------------------
>  > > include/linux/cgroup.h:566 suspicious rcu_dereference_check() usage!
>  > > 
>  > > other info that might help us debug this:
>  > > 
>  > > rcu_scheduler_active = 1, debug_locks = 1
>  > > 2 locks on stack by kdevtmpfs/59:
>  > >  #0: blocked:  (sb_writers){.+.+.+}, instance: ffff88014595a9a0, at: [<ffffffff81207bc4>] mnt_want_write+0x24/0x50
>  > >  #1: held:     (&sb->s_type->i_mutex_key#3/1){+.+.+.}, instance: ffff880145b1f5c8, at: [<ffffffff811f26d4>] kern_path_create+0x84/0x170
>  > > 
>  > > stack backtrace:
>  > > Pid: 59, comm: kdevtmpfs Not tainted 3.6.0+ #22
>  > > Call Trace:
>  > >  [<ffffffff810df1f2>] lockdep_rcu_suspicious+0xe2/0x130
>  > >  [<ffffffff81317cad>] devcgroup_inode_mknod+0x19d/0x240
>  > >  [<ffffffff812f54d8>] ? security_capable+0x18/0x20
>  > >  [<ffffffff8107e214>] ? ns_capable+0x44/0x80
>  > >  [<ffffffff811f3b0e>] vfs_mknod+0x7e/0x140
>  > >  [<ffffffff81452967>] handle_create.isra.2+0x77/0x210
>  > >  [<ffffffff810ddd6c>] ? lock_release_holdtime.part.26+0xcc/0x140
>  > >  [<ffffffff810afbf1>] ? get_parent_ip+0x11/0x50
>  > >  [<ffffffff816bacd9>] ? sub_preempt_count+0x79/0xd0
>  > >  [<ffffffff81452c47>] devtmpfsd+0x147/0x170
>  > >  [<ffffffff81452b00>] ? handle_create.isra.2+0x210/0x210
>  > >  [<ffffffff8109bf8d>] kthread+0xed/0x100
>  > >  [<ffffffff816bacd9>] ? sub_preempt_count+0x79/0xd0
>  > >  [<ffffffff816c04a4>] kernel_thread_helper+0x4/0x10
>  > >  [<ffffffff810a9fdc>] ? finish_task_switch+0x7c/0x120
>  > >  [<ffffffff816b62db>] ? _raw_spin_unlock_irq+0x4b/0x80
>  > >  [<ffffffff816b6d37>] ? retint_restore_args+0x13/0x13
>  > >  [<ffffffff8109bea0>] ? kthread_create_on_node+0x160/0x160
>  > >  [<ffffffff816c04a0>] ? gs_change+0x13/0x13
>  > 
>  > "[PATCH] cgroup: fix invalid rcu dereference" which is being routed thru
>  > akpm's tree should fix this.
>  > 
>  > see https://patchwork.kernel.org/patch/1456571/
> 
> What's happening with this ?

also found out that the device_cgroup patches that went in are v1, not
the v2. I'm preparing the refreshed patches to apply on top and will
submit along with the rcu fix to make sure they get in at the same time

-- 
Aristeu

