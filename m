Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932169Ab1I2XSe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 19:18:34 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:56733 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752734Ab1I2XSd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 19:18:33 -0400
Date: Thu, 29 Sep 2011 16:18:28 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, linux-kernel@vger.kernel.org,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: linux-next-20110923: warning kernel/rcutree.c:1833
Message-ID: <20110929231828.GA4931@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110926225032.GQ2399@linux.vnet.ibm.com>
 <20110927121648.GK18553@somewhere>
 <20110927180142.GD2335@linux.vnet.ibm.com>
 <20110928123116.GP18553@somewhere>
 <20110928184025.GF2383@linux.vnet.ibm.com>
 <20110928234633.GA3537@somewhere>
 <20110929005545.GT2383@linux.vnet.ibm.com>
 <20110929123040.GB3537@somewhere>
 <20110929171205.GA2362@linux.vnet.ibm.com>
 <20110929171901.GA6900@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110929171901.GA6900@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 10:19:01AM -0700, Paul E. McKenney wrote:
> On Thu, Sep 29, 2011 at 10:12:05AM -0700, Paul E. McKenney wrote:
> > On Thu, Sep 29, 2011 at 02:30:44PM +0200, Frederic Weisbecker wrote:
> 
> [ . . . ]
> 
> > > Sure I can take your patches (I'm going to merge the delta into the first).
> > > But if you want a rebase against -rc8, it's going to be easier if you
> > > do that rebase on the branch you want me to work on. Then I work on top
> > > of it.
> > > 
> > > For example we can take your rcu/dynticks, rewind to
> > > "rcu: Make synchronize_sched_expedited() better at work sharing"
> > > 771c326f20029a9f30b9a58237c9a5d5ddc1763d, rebase on top of -rc8
> > > and I rebase my patches (yours included) on top of it and I repost.
> > > 
> > > Right?
> > 
> > Yep!  Your earlier three patches look to need some extended-quiescent-state
> > rework as well:
> > 
> > b5566f3d: Detect illegal rcu dereference in extended quiescent state
> > ee05e5a4: Inform the user about dynticks-idle mode on PROVE_RCU warning
> > fa5d22cf: Warn when rcu_read_lock() is used in extended quiescent state
> > 
> > So I will leave these out and let you rebase them.
> 
> And for whatever it is worth, my following patches depend on yours as
> well, so will not include them in the rebase:
> 
> 61cf7640: Remove one layer of abstraction from PROVE_RCU checking
> 9a4d1ce3: Warn when srcu_read_lock() is used in an extended quiescent state

And the new stack passes moderate rcutorture testing, and is available
at https://github.com/paulmckrcu/linux on branch rcu/next.

							Thanx, Paul
