Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751387Ab0GWEU5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 00:20:57 -0400
Received: from bld-mail13.adl6.internode.on.net ([150.101.137.98]:55975 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750778Ab0GWEU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 00:20:56 -0400
Date: Fri, 23 Jul 2010 14:20:41 +1000
From: Dave Chinner <david@fromorbit.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Johannes Berg <johannes@sipsolutions.net>,
        Lin Ming <ming.m.lin@intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Robert Richter <robert.richter@amd.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Greg KH <greg@kroah.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mundt <lethal@linux-sh.org>,
        "eranian@gmail.com" <eranian@gmail.com>,
        "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
        Paul Mackerras <paulus@samba.org>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Will Deacon <will.deacon@arm.com>, Maynard Johnson <mpjohn@us.ibm.com>,
        Carl Love <carll@us.ibm.com>, Kay Sievers <kay.sievers@vrfy.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH v1 06/15] perf: export tracepoint events via
 sysfs: iwlwifi and iwlwifi_io
Message-ID: <20100723042041.GF32635@dastard>
References: <1279797230.20942.87.camel@minggr.sh.intel.com>
 <1279797640.12439.11.camel@jlt3.sipsolutions.net>
 <1279805440.3319.2.camel@gandalf.stny.rr.com>
 <20100722134836.GA6881@elte.hu>
 <1279806844.3319.3.camel@gandalf.stny.rr.com>
 <20100723013716.GA7362@dastard>
 <1279851241.3319.31.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279851241.3319.31.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 22, 2010 at 10:14:00PM -0400, Steven Rostedt wrote:
> On Fri, 2010-07-23 at 11:37 +1000, Dave Chinner wrote:
> > On Thu, Jul 22, 2010 at 09:54:04AM -0400, Steven Rostedt wrote:
> > > On Thu, 2010-07-22 at 15:48 +0200, Ingo Molnar wrote:
> > > > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > > 
> > > > Yeah - and the point of this submission is to allow the discussion of how to 
> > > > achieve these registrations.
> > > > 
> > > > Driver authors will want to have some control - for example the place where 
> > > > the events directory shows up in sysfs within the driver's directory structure 
> > > > - etc.
> > > > 
> > > > But we indeed want to automate it as much as possible.
> > > 
> > > Perhaps we can create a TRACE_EVENT_PATH() macro, that allows the
> > > developer to specify the path that the event will be seen in sysfs?
> > 
> > Perhaps you could build that into the event class definition as well
> > so each separate class in a subsystem can be placed in it's own
> > sub-directory?
> > 
> > That would make turning on and off specific classes trace points so
> > much simpler than it now, espcially for XFS where we now have > 250
> > tracepoints that are mostly defined by event classes already...
> 
> I was working on creating a "TRACE_CATEGORY()" that allowed you to put
> tracepoints into categories. Thus, these tracepoints will all still be
> in the XFS system, but you can add hierarchical categories that let you
> group and enable tracepoints in these groups.

Yes, that's pretty much what I was thinking of.

> But I stopped this work since it was more ftrace specific than perf, and
> I need to figure out how to continue my work on ftrace and at the same
> time merge it towards perf. This has been taking much longer than I have
> expected. Perhaps I should just finish that work, and then see how we
> can make perf work with it too?

I'm not fussed - it's more of a wishlist item right now. If it's in
the pipeline, then I'm happy to wait until you've done all the hard
work for me. ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
