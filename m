Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab2JCUFt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 16:05:49 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:34028 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096Ab2JCUFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 16:05:48 -0400
Date: Wed, 3 Oct 2012 22:05:43 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Josh Triplett <josh@joshtriplett.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] rcu: Remove rcu_switch()
Message-ID: <20121003200533.GC637@somewhere>
References: <1349288512-2635-1-git-send-email-fweisbec@gmail.com>
 <20121003183945.GP2527@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121003183945.GP2527@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2012 at 11:39:45AM -0700, Paul E. McKenney wrote:
> On Wed, Oct 03, 2012 at 08:21:52PM +0200, Frederic Weisbecker wrote:
> > It's only there to call rcu_user_hooks_switch(). Let's
> > just call rcu_user_hooks_switch() directly, we don't need this
> > function in the middle.
> 
> Hello, Frederic!
> 
> Doesn't this also require an empty definition of rcu_user_hooks_switch()
> to handle the CONFIG_RCU_USER_QS=n case?  Or is there already such
> a definition that I am too blind to see?

There is, look below:

> 
> 							Thanx, Paul
> 
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Josh Triplett <josh@joshtriplett.org>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > ---
> >  include/linux/rcupdate.h |    2 ++
> >  include/linux/sched.h    |    8 --------
> >  kernel/sched/core.c      |    2 +-
> >  3 files changed, 3 insertions(+), 9 deletions(-)
> > 
> > diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> > index 7c968e4..5d009de 100644
> > --- a/include/linux/rcupdate.h
> > +++ b/include/linux/rcupdate.h
> > @@ -204,6 +204,8 @@ static inline void rcu_user_enter(void) { }
> >  static inline void rcu_user_exit(void) { }
> >  static inline void rcu_user_enter_after_irq(void) { }
> >  static inline void rcu_user_exit_after_irq(void) { }
> > +static inline void rcu_user_hooks_switch(struct task_struct *prev,
> > +					 struct task_struct *next) { }

Here.

> >  #endif /* CONFIG_RCU_USER_QS */
