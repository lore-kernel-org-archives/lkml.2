Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757636Ab0GWBhp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 21:37:45 -0400
Received: from bld-mail18.adl2.internode.on.net ([150.101.137.103]:49413 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755913Ab0GWBho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 21:37:44 -0400
Date: Fri, 23 Jul 2010 11:37:16 +1000
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
Message-ID: <20100723013716.GA7362@dastard>
References: <1279797230.20942.87.camel@minggr.sh.intel.com>
 <1279797640.12439.11.camel@jlt3.sipsolutions.net>
 <1279805440.3319.2.camel@gandalf.stny.rr.com>
 <20100722134836.GA6881@elte.hu>
 <1279806844.3319.3.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279806844.3319.3.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 22, 2010 at 09:54:04AM -0400, Steven Rostedt wrote:
> On Thu, 2010-07-22 at 15:48 +0200, Ingo Molnar wrote:
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > Yeah - and the point of this submission is to allow the discussion of how to 
> > achieve these registrations.
> > 
> > Driver authors will want to have some control - for example the place where 
> > the events directory shows up in sysfs within the driver's directory structure 
> > - etc.
> > 
> > But we indeed want to automate it as much as possible.
> 
> Perhaps we can create a TRACE_EVENT_PATH() macro, that allows the
> developer to specify the path that the event will be seen in sysfs?

Perhaps you could build that into the event class definition as well
so each separate class in a subsystem can be placed in it's own
sub-directory?

That would make turning on and off specific classes trace points so
much simpler than it now, espcially for XFS where we now have > 250
tracepoints that are mostly defined by event classes already...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
