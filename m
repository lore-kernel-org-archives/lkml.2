Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989Ab0C2RO5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 13:14:57 -0400
Received: from mail-out1.uio.no ([129.240.10.57]:45246 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752231Ab0C2ROz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 13:14:55 -0400
Subject: Re: INFO: suspicious rcu_dereference_check()
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: paulmck@linux.vnet.ibm.com, David Howells <dhowells@redhat.com>
Cc: Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-nfs@vger.kernel.org
In-Reply-To: <20100329152557.GD2569@linux.vnet.ibm.com>
References: <c4e36d111003250348q678eb2e6w4f3e8133e7fd6e58@mail.gmail.com>
	 <1269531400.3648.1.camel@localhost.localdomain>
	 <20100329152557.GD2569@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Mar 2010 13:14:43 -0400
Message-ID: <1269882883.3181.25.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 6 msgs/h 2 sum rcpts/h 6 sum msgs/h 2 total rcpts 2675 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: DE305CE38DD03C29A481CA60CC616599419C7CE9
X-UiO-SPAM-Test: remote_host: 68.40.206.115 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 2 total 279 max/h 7 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-29 at 08:25 -0700, Paul E. McKenney wrote: 
> On Thu, Mar 25, 2010 at 11:36:40AM -0400, Trond Myklebust wrote:
> > On Thu, 2010-03-25 at 11:48 +0100, Zdenek Kabelac wrote: 
> > > Hi
> > > 
> > > I've enabled rcu correctness for my  todays 2.6.34-rc2 kernel.
> > > 
> > > I'm getting this INFO: from my kvm guest (which uses host's nfs
> > > exported directory.)
> > > This
> > > 
> > > ===================================================
> > > [ INFO: suspicious rcu_dereference_check() usage. ]
> > > ---------------------------------------------------
> > > fs/nfs/delegation.c:348 invoked rcu_dereference_check() without protection!
> > > 
> > > other info that might help us debug this:
> > > 
> > > 
> > > rcu_scheduler_active = 1, debug_locks = 0
> > > 2 locks held by rm/1820:
> > >  #0:  (&sb->s_type->i_mutex_key#13/1){+.+.+.}, at:
> > > [<ffffffff81138e1b>] do_unlinkat+0x9b/0x1c0
> > >  #1:  (&sb->s_type->i_mutex_key#13){+.+.+.}, at: [<ffffffff81136a76>]
> > > vfs_unlink+0x56/0xf0
> > > 
> > > stack backtrace:
> > > Pid: 1820, comm: rm Not tainted 2.6.34-rc2-00186-ge79a302 #60
> > > Call Trace:
> > >  [<ffffffff810819fb>] lockdep_rcu_dereference+0xbb/0xc0
> > >  [<ffffffffa0228351>] nfs_inode_return_delegation+0x101/0x110 [nfs]
> > >  [<ffffffffa01fd58d>] nfs_unlink+0xad/0x2a0 [nfs]
> > >  [<ffffffff81136aba>] vfs_unlink+0x9a/0xf0
> > >  [<ffffffff81148365>] ? mnt_want_write+0x65/0xb0
> > >  [<ffffffff81138f03>] do_unlinkat+0x183/0x1c0
> > >  [<ffffffff8142b66d>] ? retint_swapgs+0xe/0x13
> > >  [<ffffffff81083985>] ? trace_hardirqs_on_caller+0x155/0x1a0
> > >  [<ffffffff8142a232>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> > >  [<ffffffff811390a2>] sys_unlinkat+0x22/0x40
> > >  [<ffffffff81031dc8>] sysenter_dispatch+0x7/0x2c
> > > 
> > 
> > It is a 100% bogus warning. There are tentative patches floating around
> > to fix the above warning, but they haven't been merged yet.
> > 
> > In the meantime, please ignore...
> 
> Did you want to carry these patches, or would you rather that I do so?
> 
> (And sorry for the slow response, was on holiday last week.)
> 
> 							Thanx, Paul

Hi Paul,

I don't mind whether you or I push them to Linus, but IIRC you had a
couple of comments about the last patchset I saw from David, so I was
expecting to see either a reply from him or patch update. Did I miss
that reply? (Ccing: David)

Cheers
  Trond

