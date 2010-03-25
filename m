Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029Ab0CYPgr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 11:36:47 -0400
Received: from mail-out2.uio.no ([129.240.10.58]:52861 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754930Ab0CYPgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 11:36:45 -0400
Subject: Re: INFO: suspicious rcu_dereference_check()
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-nfs@vger.kernel.org
In-Reply-To: <c4e36d111003250348q678eb2e6w4f3e8133e7fd6e58@mail.gmail.com>
References: <c4e36d111003250348q678eb2e6w4f3e8133e7fd6e58@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Mar 2010 11:36:40 -0400
Message-ID: <1269531400.3648.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 3 msgs/h 1 sum rcpts/h 7 sum msgs/h 2 total rcpts 2617 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 6093171428F2035B21F7339EE267ECAF1190779A
X-UiO-SPAM-Test: remote_host: 68.40.206.115 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 260 max/h 7 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-25 at 11:48 +0100, Zdenek Kabelac wrote: 
> Hi
> 
> I've enabled rcu correctness for my  todays 2.6.34-rc2 kernel.
> 
> I'm getting this INFO: from my kvm guest (which uses host's nfs
> exported directory.)
> This
> 
> ===================================================
> [ INFO: suspicious rcu_dereference_check() usage. ]
> ---------------------------------------------------
> fs/nfs/delegation.c:348 invoked rcu_dereference_check() without protection!
> 
> other info that might help us debug this:
> 
> 
> rcu_scheduler_active = 1, debug_locks = 0
> 2 locks held by rm/1820:
>  #0:  (&sb->s_type->i_mutex_key#13/1){+.+.+.}, at:
> [<ffffffff81138e1b>] do_unlinkat+0x9b/0x1c0
>  #1:  (&sb->s_type->i_mutex_key#13){+.+.+.}, at: [<ffffffff81136a76>]
> vfs_unlink+0x56/0xf0
> 
> stack backtrace:
> Pid: 1820, comm: rm Not tainted 2.6.34-rc2-00186-ge79a302 #60
> Call Trace:
>  [<ffffffff810819fb>] lockdep_rcu_dereference+0xbb/0xc0
>  [<ffffffffa0228351>] nfs_inode_return_delegation+0x101/0x110 [nfs]
>  [<ffffffffa01fd58d>] nfs_unlink+0xad/0x2a0 [nfs]
>  [<ffffffff81136aba>] vfs_unlink+0x9a/0xf0
>  [<ffffffff81148365>] ? mnt_want_write+0x65/0xb0
>  [<ffffffff81138f03>] do_unlinkat+0x183/0x1c0
>  [<ffffffff8142b66d>] ? retint_swapgs+0xe/0x13
>  [<ffffffff81083985>] ? trace_hardirqs_on_caller+0x155/0x1a0
>  [<ffffffff8142a232>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>  [<ffffffff811390a2>] sys_unlinkat+0x22/0x40
>  [<ffffffff81031dc8>] sysenter_dispatch+0x7/0x2c
> 

It is a 100% bogus warning. There are tentative patches floating around
to fix the above warning, but they haven't been merged yet.

In the meantime, please ignore...

Cheers
  Trond

