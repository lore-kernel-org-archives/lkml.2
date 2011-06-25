Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751005Ab1FYFKQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jun 2011 01:10:16 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:58719 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809Ab1FYFKL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jun 2011 01:10:11 -0400
Date: Fri, 24 Jun 2011 22:10:06 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0/3 v3] rcu: Detect rcu uses under extended quiescent
 state
Message-ID: <20110625051006.GF2266@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1308870760-14153-1-git-send-email-fweisbec@gmail.com>
 <1308907125.27849.19.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308907125.27849.19.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 24, 2011 at 11:18:45AM +0200, Peter Zijlstra wrote:
> On Fri, 2011-06-24 at 01:12 +0200, Frederic Weisbecker wrote:
> > This time I have no current practical cases to fix. Those I fixed
> > in previous versions were actually using rcu_dereference_raw(), which
> > is legal in extended qs.
> > 
> > Frederic Weisbecker (3):
> >   rcu: Detect illegal rcu dereference in extended quiescent state
> >   rcu: Inform the user about dynticks idle mode on PROVE_RCU warning
> >   rcu: Warn when rcu_read_lock() is used in extended quiescent state
> > 
> >  include/linux/rcupdate.h |   68 +++++++++++++++++++++++++++++++++++++++-------
> >  kernel/lockdep.c         |    4 +++
> >  kernel/rcupdate.c        |    4 +++
> >  kernel/rcutiny.c         |   13 +++++++++
> >  kernel/rcutree.c         |   14 +++++++++
> >  5 files changed, 93 insertions(+), 10 deletions(-)
> 
> Right, so the only comment I have is that it might have been nice to
> explain what the heck an extended qs is :-) I've since figured it out,
> but it did require waking up my brain.

Good point -- I updated the commit logs to (hopefully) make this
more clear.

							Thanx, Paul
