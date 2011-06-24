Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348Ab1FXLUz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 07:20:55 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:59286 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234Ab1FXLUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 07:20:54 -0400
Date: Fri, 24 Jun 2011 13:20:49 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0/3 v3] rcu: Detect rcu uses under extended quiescent
 state
Message-ID: <20110624112045.GF8058@somewhere.redhat.com>
References: <1308870760-14153-1-git-send-email-fweisbec@gmail.com>
 <20110624035311.GB2266@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110624035311.GB2266@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 08:53:11PM -0700, Paul E. McKenney wrote:
> On Fri, Jun 24, 2011 at 01:12:37AM +0200, Frederic Weisbecker wrote:
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
> Queued, thank you, Frederic!
> 
> I have also applied your approach to SRCU, and I applied the following
> to simplify the code a bit -- please let me know if there are any
> problems with this approach.
> 
> 							Thanx, Paul
> 
> ------------------------------------------------------------------------
> 
> rcu: Remove one layer of abstraction from PROVE_RCU checking
> 
> Simplify things a bit by substituting the definitions of the single-line
> rcu_read_acquire(), rcu_read_release(), rcu_read_acquire_bh(),
> rcu_read_release_bh(), rcu_read_acquire_sched(), and
> rcu_read_release_sched() functions at their call points.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Yeah looks good. Thanks!
