Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964Ab1FFShO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 14:37:14 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:46727 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751607Ab1FFShM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 14:37:12 -0400
Date: Mon, 6 Jun 2011 11:37:09 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Milton Miller <miltonm@bga.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [1/4] rcu: Detect uses of rcu read side in extended quiescent
 states
Message-ID: <20110606183709.GN3066@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1307329858-14999-3-git-send-email-fweisbec@gmail.com>
 <rcu-splat-split-printk@mdm.bga.com>
 <20110606181021.GL3066@linux.vnet.ibm.com>
 <20110606182052.GC7862@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110606182052.GC7862@somewhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 06, 2011 at 08:20:54PM +0200, Frederic Weisbecker wrote:
> On Mon, Jun 06, 2011 at 11:10:21AM -0700, Paul E. McKenney wrote:
> > On Sun, Jun 05, 2011 at 10:44:33PM -0500, Milton Miller wrote:
> > > On Mon, 06 Jun 2011 about 03:10:55 -0000, Frederic Weisbecker wrote:
> > > > @@ -3994,8 +3995,13 @@ void lockdep_rcu_dereference(const char *file, const int line)
> > > >  	printk("\n===================================================\n");
> > > >  	printk(  "[ INFO: suspicious rcu_dereference_check() usage. ]\n");
> > > >  	printk(  "---------------------------------------------------\n");
> > > > -	printk("%s:%d invoked rcu_dereference_check() without protection!\n",
> > > > -			file, line);
> > > > +	printk("%s:%d invoked rcu_dereference_check() ", file, line);
> > > > +
> > > > +	if (type == RCU_WARN_UNPROTECTED)
> > > > +		printk("without protection!\n");
> > > > +	else if (type == RCU_WARN_EXT_QS)
> > > > +		printk("while in RCU extended quiescent state!\n");
> > > > +
> > > >  	printk("\nother info that might help us debug this:\n\n");
> > > >  	printk("\nrcu_scheduler_active = %d, debug_locks = %d\n", rcu_scheduler_active, debug_locks);
> > > >  	lockdep_print_held_locks(curr);
> > > 
> > > Can we keep the above in one printk?   That way the printing is
> > > guaranteed to come out on one line.  Probably the easiest way would
> > > be add char *why = "" then assign a string based on the current
> > > conditions.  Do all of that before the first printk which gets the
> > > a %s added.
> > 
> > I have the following queued the -rcu tree which does add the string.
> > 
> > Frederic, would it be possible to base on this patch?
> > 
> > 							Thanx, Paul
> 
> No problem. Will respin soon.

Thank you!

> What's the branch in your tree? rcu/next ?

That is the one!

							Thanx, Paul
