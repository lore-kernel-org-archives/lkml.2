Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362Ab2HOPKb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 11:10:31 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:51192 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755161Ab2HOPK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 11:10:29 -0400
X-Originating-IP: 217.70.178.134
X-Originating-IP: 50.43.46.74
Date: Wed, 15 Aug 2012 08:10:20 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Mike Galbraith <efault@gmx.de>
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
Subject: Re: [PATCH] sched: Support compiling out real-time scheduling with
 REALTIME_SCHED.
Message-ID: <20120815151019.GA2837@leaf>
References: <y>
 <1344977423-28900-1-git-send-email-tjbrandt@gmail.com>
 <1345014740.4515.104.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345014740.4515.104.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 09:12:20AM +0200, Mike Galbraith wrote:
> On Tue, 2012-08-14 at 13:50 -0700, Trevor Brandt wrote:
> > diff --git a/init/Kconfig b/init/Kconfig
> > index 3f42cd6..768dc76 100644
> > --- a/init/Kconfig
> > +++ b/init/Kconfig
> > @@ -27,6 +27,13 @@ config IRQ_WORK
> >  	bool
> >  	depends on HAVE_IRQ_WORK
> >  
> > +config REALTIME_SCHED
> > +	bool "Realtime Scheduler" if EXPERT
> > +	default y
> > +	help
> > +	  This option enables support for the realtime scheduler and the
> > +	  corresponding scheduling classes SCHED_FIFO and SCHED_RR.
> > +
> >  menu "General setup"
> >  
> >  config EXPERIMENTAL
> 
> If you inverted that, it could be a proper default n new feature [1].

Huh.  You mean, DISABLE_REALTIME_SCHED?  How would that help?
DISABLE_REALTIME_SCHED=n seems like an unnecessary double negative, and
I see very little precedent for that in Kconfig options.

> (that SMP could select to greatly simplify RT)

I hope this isn't a serious suggestion. :)  In any case, that doesn't
seem like something that should happen in *this* patch, if it should
happen at all.

> However, if weight loss is the goal, why not go whole hog, and create
> sched/thin.c containing no lard... or just integrate an existing thin
> scheduler as a config option?

Historically, the response to configurable/modular/selectable schedulers
has been entirely negative, with most responses amounting to "we should
fix the scheduler we have to work for all workloads", which doesn't seem
like an unreasonable response to me.

The kernel also has a *large* number of dependencies on the workings of
the fair scheduler, and as this patch shows, far fewer on the real-time
scheduler.

Given both of the above, writing and integrating an entirely new
scheduler (*and* dealing with the repeats of old flamewars that would
ensue after posting it) seems a bit much to ask for a student project.
:)

- Josh Triplett
