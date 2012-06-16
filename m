Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759118Ab2FPAti (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 20:49:38 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:57993 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758984Ab2FPAth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 20:49:37 -0400
Date: Fri, 15 Jun 2012 17:49:31 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 09/15] rcu: Increasing rcu_barrier()
 concurrency
Message-ID: <20120616004931.GU2389@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120615210550.GA27506@linux.vnet.ibm.com>
 <1339794370-28119-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1339794370-28119-9-git-send-email-paulmck@linux.vnet.ibm.com>
 <20120615233151.GA7613@leaf>
 <1339806080.25903.68.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339806080.25903.68.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061600-7408-0000-0000-000005E5DA3D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 08:21:20PM -0400, Steven Rostedt wrote:
> On Fri, 2012-06-15 at 16:31 -0700, Josh Triplett wrote:
> >   
> > > -	smp_mb();  /* Prevent any prior operations from leaking in. */
> > > +	/*
> > > +	 * Ensure tht all prior references, including to ->n_barrier_done,
> > > +	 * are ordered before the _rcu_barrier() machinery.
> > > +	 */
> > > +	smp_mb();  /* See above block comment. */
> > 
> > If checkpatch complains about the lack of a comment to the right of a
> > barrier even when the barrier has a comment directly above it, that
> > seems like a bug in checkpatch that needs fixing, to prevent developers
> > from having to add noise like "See above block comment.". :)
> 
> 
> Yuck yuck yuck yuck!!!
> 
> 
> Really, checkpatch is not the golden rule. I've copied an old checkpatch
> from something like 2.6.38 or so and use that today, where it was still
> reasonable. I've long abandoned the latest checkpatch, as it causes too
> many false positives. Or nazis like dictation.
> 
> My rule of thumb is this. If what checkpatch tells you to do makes the
> format either uglier, or look stupid, it's a good idea to ignore the
> checkpatch complaint.
> 
> I think in this case, you hit the latter.

Heh.  I have been doing this "/* See above block comment. */" thing for
quite some time.  ;-)

							Thanx, Paul

