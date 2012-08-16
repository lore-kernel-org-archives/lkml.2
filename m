Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700Ab2HPEam (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 00:30:42 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:59239 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751329Ab2HPEal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 00:30:41 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/fNmZGpWDfTiDZnzrtUcS4wm6eVDrsUfwByxOSo1
	Vo/O4Qhp/nCRXm
Message-ID: <1345091432.4314.19.camel@marge.simpson.net>
Subject: Re: [PATCH] sched: Support compiling out real-time scheduling with
 REALTIME_SCHED.
From: Mike Galbraith <efault@gmx.de>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Trevor Brandt <tjbrandt@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Eric Paris <eparis@redhat.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Glauber Costa <glommer@parallels.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, team-fjord@googlegroups.com
Date: Thu, 16 Aug 2012 06:30:32 +0200
In-Reply-To: <20120815151019.GA2837@leaf>
References: <y> <1344977423-28900-1-git-send-email-tjbrandt@gmail.com>
	 <1345014740.4515.104.camel@marge.simpson.net> <20120815151019.GA2837@leaf>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-08-15 at 08:10 -0700, Josh Triplett wrote: 
> On Wed, Aug 15, 2012 at 09:12:20AM +0200, Mike Galbraith wrote:
> > On Tue, 2012-08-14 at 13:50 -0700, Trevor Brandt wrote:
> > > diff --git a/init/Kconfig b/init/Kconfig
> > > index 3f42cd6..768dc76 100644
> > > --- a/init/Kconfig
> > > +++ b/init/Kconfig
> > > @@ -27,6 +27,13 @@ config IRQ_WORK
> > >  	bool
> > >  	depends on HAVE_IRQ_WORK
> > >  
> > > +config REALTIME_SCHED
> > > +	bool "Realtime Scheduler" if EXPERT
> > > +	default y
> > > +	help
> > > +	  This option enables support for the realtime scheduler and the
> > > +	  corresponding scheduling classes SCHED_FIFO and SCHED_RR.
> > > +
> > >  menu "General setup"
> > >  
> > >  config EXPERIMENTAL
> > 
> > If you inverted that, it could be a proper default n new feature [1].
> 
> Huh.  You mean, DISABLE_REALTIME_SCHED?  How would that help?
> DISABLE_REALTIME_SCHED=n seems like an unnecessary double negative, and
> I see very little precedent for that in Kconfig options.

No, it doesn't change anything.

> > (that SMP could select to greatly simplify RT)
> 
> I hope this isn't a serious suggestion. :)  In any case, that doesn't
> seem like something that should happen in *this* patch, if it should
> happen at all.

Slightly deformed funny-bone.

> > However, if weight loss is the goal, why not go whole hog, and create
> > sched/thin.c containing no lard... or just integrate an existing thin
> > scheduler as a config option?
> 
> Historically, the response to configurable/modular/selectable schedulers
> has been entirely negative, with most responses amounting to "we should
> fix the scheduler we have to work for all workloads", which doesn't seem
> like an unreasonable response to me.
> 
> The kernel also has a *large* number of dependencies on the workings of
> the fair scheduler, and as this patch shows, far fewer on the real-time
> scheduler.
> 
> Given both of the above, writing and integrating an entirely new
> scheduler (*and* dealing with the repeats of old flamewars that would
> ensue after posting it) seems a bit much to ask for a student project.
> :)

I think you could make something more generally useful to size extra
dinky boxen by doing that regardless.  But yeah, the bar for inclusion
might be a _tad_ high ;-)

Maintainers certainly wouldn't find it lovely, but there is some
utility.  I can imagine a single array version of the O(1) scheduler
saving lots of space.  If you made it single queue like BFS (or for that
matter maybe just uses BFS out of the box, dunno) you'd get rid of the
load balancing code as well, so would probably have a small footprint
scheduler without having to axe standard classes that may well be needed
in even size extra dinky boxen.

-Mike

