Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749Ab1KCVqJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 17:46:09 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:57184 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624Ab1KCVqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 17:46:08 -0400
Date: Thu, 3 Nov 2011 14:45:50 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org
Subject: Re: [PATCH RFC tip/core/rcu 0/28] Preview of RCU changes for 3.3
Message-ID: <20111103214550.GL2287@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20111102203017.GA3830@linux.vnet.ibm.com>
 <20111103045535.GA1957@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111103045535.GA1957@leaf>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11110321-8974-0000-0000-0000016A4594
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 02, 2011 at 09:55:35PM -0700, Josh Triplett wrote:
> On Wed, Nov 02, 2011 at 01:30:17PM -0700, Paul E. McKenney wrote:
> > This patchset permits idle tasks to use RCU read-side critical sections,
> > although they are still prohibited between tick_nohz_idle_exit_norcu()
> > and tick_nohz_idle_exit_norcu(); makes synchronize_sched_expedited()
> > better able to share work among concurrent callers, allows ftrace_dump()
> > to be invoked from modules, dumps tracing upon detection of an rcutorture
> > failure, detects illegal use of RCU read-side critical sections from
> > extended quiescent states, legitimizes the pre-existin use of RCU in the
> > idle notifiers, fixes a memory-barrier botch, introduces an SRCU-like bulk
> > reference count, improve dynticks entry/exit tracing, further improves
> > RCU's ability to allow a given CPU to enter dyntick-idle mode quickly,
> > fixes idle-task checks, updates documentation, and additional fixes
> > from a still-ongoing top-to-bottom inspection of RCU.  The patches are
> > as follows:
> 
> I've reviewed all of these patches.  For all of them except those
> indicated below:
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Thank you for your careful review and thoughtful comments!

I have pushed the changes to -rcu at:

git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/dev

Could you please check to make sure that I got your Reviewed-by
on the right commits?

							Thanx, Paul

> > 1.	Strengthen memory barriers used in PowerPC value-returning
> > 	atomics and locking primitives.  It is likely that this
> > 	commit will be superseded by something from the powerpc
> > 	maintainers.  The need for this strengthening was validated
> > 	by tooling from Peter Sewell's group at the University of
> > 	Cambridge.
> 
> As before, I don't have the background on powerpc to provide review on
> this one.  However, I trust Peter Sewell's group to have gotten the
> details right. :)
> 
> > 5.	Document the troubleshooting of lockdep lock-class leaks.
> 
> I replied with a few comments and a typo fix.
> 
> > 11.	Remove a useless self-awaken when setting up expedited grace
> > 	periods, courtesy of Thomas Gleixner and the -rt effort.
> 
> Replied with a fix: commit needs splitting.
> 
> > 12-17.	Make lockdep-RCU warn when RCU read-side primitives are
> > 	invoked from an idle RCU extended quiescent state, mostly
> > 	courtesy of Frederic Weisbecker.
> 
> Replied to 17 with a minor nit, but Reviewed-by still applies to all
> five with or without that nit fixed.
> 
> > 18-23.	Separate out the scheduler-clock tick's idea of dyntick
> > 	idle from RCU's notion of an idle extended quiescent state, mostly
> > 	courtesy of Frederic Weisbecker.  These commits are needed for
> > 	Frederic's work to suppress the scheduler-clock tick when there
> > 	is but one runnable task on a given CPU.
> 
> Very much looking forward to that work.  Any pointer to more information
> on tickless-when-one-task?
> 
> Replied to patch 19 with some naming comments; the rest seem fine.
> 
> > 24.	Introduce a bulk reference count, which is related to SRCU,
> > 	but which allows a reference to be acquired in an irq handler
> > 	and released by the task that was interrupted.
> 
> Replied with comments.
> 
> > 27.	Allow CPUs with pending RCU callbacks to enter dyntick-idle
> > 	mode.  Beware this commit, as it compiled and passed rcutorture
> > 	on the first try, which historically has indicated the presence
> > 	of subtle and highly destructive bugs.
> 
> Heh.  I reviewed this one particularly carefully, then, but I didn't
> find any logic errors.  I did reply with a couple of comments, though.
> 
> > 28.	Fix RCU's determination of whether or not it is running in the
> > 	context of an idle task.
> 
> Replied with concerns.
> 
> - Josh Triplett
> 

