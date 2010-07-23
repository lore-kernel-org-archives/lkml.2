Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759374Ab0GWCOI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 22:14:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:37182 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410Ab0GWCOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 22:14:05 -0400
X-Authority-Analysis: v=1.1 cv=NvN00vXXLC/2Fo3NdLZJXFUM7u9qr/FOWvgMjmHRJhk= c=1 sm=0 a=yRs0Bdu_tHsA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=meVymXHHAAAA:8 a=MuEWEC7U8hhkXNCpiEcA:9 a=GZTMqLocBxpNe7Cy9Uu2pfh7HXcA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [RFC][PATCH v1 06/15] perf: export tracepoint events via
 sysfs: iwlwifi and iwlwifi_io
From: Steven Rostedt <rostedt@goodmis.org>
To: Dave Chinner <david@fromorbit.com>
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
In-Reply-To: <20100723013716.GA7362@dastard>
References: <1279797230.20942.87.camel@minggr.sh.intel.com>
	 <1279797640.12439.11.camel@jlt3.sipsolutions.net>
	 <1279805440.3319.2.camel@gandalf.stny.rr.com>
	 <20100722134836.GA6881@elte.hu>
	 <1279806844.3319.3.camel@gandalf.stny.rr.com>
	 <20100723013716.GA7362@dastard>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 22 Jul 2010 22:14:00 -0400
Message-ID: <1279851241.3319.31.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-23 at 11:37 +1000, Dave Chinner wrote:
> On Thu, Jul 22, 2010 at 09:54:04AM -0400, Steven Rostedt wrote:
> > On Thu, 2010-07-22 at 15:48 +0200, Ingo Molnar wrote:
> > > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > Yeah - and the point of this submission is to allow the discussion of how to 
> > > achieve these registrations.
> > > 
> > > Driver authors will want to have some control - for example the place where 
> > > the events directory shows up in sysfs within the driver's directory structure 
> > > - etc.
> > > 
> > > But we indeed want to automate it as much as possible.
> > 
> > Perhaps we can create a TRACE_EVENT_PATH() macro, that allows the
> > developer to specify the path that the event will be seen in sysfs?
> 
> Perhaps you could build that into the event class definition as well
> so each separate class in a subsystem can be placed in it's own
> sub-directory?
> 
> That would make turning on and off specific classes trace points so
> much simpler than it now, espcially for XFS where we now have > 250
> tracepoints that are mostly defined by event classes already...


I was working on creating a "TRACE_CATEGORY()" that allowed you to put
tracepoints into categories. Thus, these tracepoints will all still be
in the XFS system, but you can add hierarchical categories that let you
group and enable tracepoints in these groups.

But I stopped this work since it was more ftrace specific than perf, and
I need to figure out how to continue my work on ftrace and at the same
time merge it towards perf. This has been taking much longer than I have
expected. Perhaps I should just finish that work, and then see how we
can make perf work with it too?

-- Steve


