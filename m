Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926Ab0F2K1k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 06:27:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38552 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754328Ab0F2K1j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 06:27:39 -0400
Date: Tue, 29 Jun 2010 12:26:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       Peter Zijlstra <peterz@infradead.org>, Greg KH <greg@kroah.com>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
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
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [rfc] Describe events in a structured way via sysfs
Message-ID: <20100629102656.GA25512@elte.hu>
References: <1277187920.4467.3.camel@minggr.sh.intel.com>
 <1277189971.3637.5.camel@jlt3.sipsolutions.net>
 <1277191359.5025.4.camel@minggr.sh.intel.com>
 <1277192007.3637.8.camel@jlt3.sipsolutions.net>
 <20100624093625.GA26931@elte.hu>
 <1277396053.3870.16.camel@jlt3.sipsolutions.net>
 <20100624173315.GA30403@elte.hu>
 <1277792114.5400.5.camel@minggr.sh.intel.com>
 <20100629085532.GE22344@elte.hu>
 <1277803248.5400.16.camel@minggr.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277803248.5400.16.camel@minggr.sh.intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Lin Ming <ming.m.lin@intel.com> wrote:

> > Also, we can (optionally) consider 'generic', subsystem level events to 
> > also show up under:
> > 
> >    /sys/bus/pci/drivers/i915/events/
> > 
> > This would give a model to non-device-specific events to be listed one 
> > level higher in the sysfs hierarchy.
> > 
> > This too would be done in the driver, not by generic code. It's generally 
> > the driver which knows how the events should be categorized.
> 
> This is a bit difficult. I'd like not to touch TRACE_EVENT(). [...]

We can certainly start with the simpler variant - it's also the more common 
case.

> [...] How does the driver know if an event is 'generic' if TRACE_EVENT is 
> not touched?

Well, it's per driver code which creates the 'events' directory anyway, so 
that code decides where to link things. It can link it to the per driver kobj 
- or to the per subsys kobj.

> > I'd imagine something similar for wireless drivers as well - most 
> > currently defined events would show up on a per device basis there.
> > 
> > Can you see practical problems with this scheme?
> 
> Not now. I may find some problems when write more detail code.

Ok. Feel free to post RFC patches (even if they are not fully complete yet), 
so that we can see how things are progressing.

I suspect the best approach would be to try to figure out the right sysfs 
placement for one or two existing driver tracepoints, so that we can see it 
all in practice. (Obviously any changes to drivers will have to go via the 
relevant driver maintainer tree(s).)

Thanks,

	Ingo
