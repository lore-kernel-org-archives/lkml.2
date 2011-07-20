Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752258Ab1GTUG6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 16:06:58 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:40716 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368Ab1GTUG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 16:06:57 -0400
Date: Wed, 20 Jul 2011 13:06:39 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Ben Greear <greearb@candelatech.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ed Tomlinson <edt@aei.ca>, linux-kernel@vger.kernel.org,
        laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, edward.tomlinson@aero.bombardier.com
Subject: Re: [PATCH rcu/urgent 0/6] Fixes for RCU/scheduler/irq-threads
 trainwreck
Message-ID: <20110720200639.GO2313@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <201107192207.33813.edt@aei.ca>
 <20110720044435.GB2400@linux.vnet.ibm.com>
 <CA+55aFyaCY=qzFKswi2NR097KZtb5x98sba3rHJ7B0rchtzm2g@mail.gmail.com>
 <20110720133443.GG2400@linux.vnet.ibm.com>
 <4E270A0E.6090902@candelatech.com>
 <20110720171532.GB2313@linux.vnet.ibm.com>
 <20110720184413.GD17977@elte.hu>
 <1311187978.29152.58.camel@twins>
 <20110720190141.GJ2313@linux.vnet.ibm.com>
 <1311189946.29152.88.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311189946.29152.88.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 20, 2011 at 09:25:46PM +0200, Peter Zijlstra wrote:
> On Wed, 2011-07-20 at 12:01 -0700, Paul E. McKenney wrote:
> >   This can interact badly with the recently
> > added RCU read-side critical sections in the scheduler that have
> > either the runqueue or the priority-inheritance locks held, especially
> > when interrupts occur towards the end of __rcu_read_unlock(). 
> 
> Right, so while I recently added a lot more, there have been rcu usage
> sites under rq->lock for a long while, see commits
> 
> a18b83b7ef ("cpuacct: make cpuacct hierarchy walk in cpuacct_charge()
> safe when rcupreempt is used -v2") -- March 2009.
> 
> f3b577dec1 ("rcu: apply RCU protection to wake_affine()") -- Jun 2010
> 
> b0a0f667 ("sched: suppress RCU lockdep splat in task_fork_fair") -- Oct
> 2010
> 
> So I'm not quite seeing how the problems we're hitting now are new.

My guess is that the problem has been there for quite some time, but
that the probability of hitting it has increased, at least for some
combinations of config options.

							Thanx, Paul
