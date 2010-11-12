Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933184Ab0KLXc2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 18:32:28 -0500
Received: from casper.infradead.org ([85.118.1.10]:38752 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933114Ab0KLXc1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 18:32:27 -0500
Subject: Re: [RFC][PATCH 13/22] sched: add resource limits for -deadline
 tasks
From: Peter Zijlstra <peterz@infradead.org>
To: Raistlin <raistlin@linux.it>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Chris Friesen <cfriesen@nortel.com>, oleg@redhat.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Darren Hart <darren@dvhart.com>, Johan Eker <johan.eker@ericsson.com>,
        "p.faure" <p.faure@akatech.ch>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Claudio Scordino <claudio@evidence.eu.com>,
        michael trimarchi <trimarchi@retis.sssup.it>,
        Fabio Checconi <fabio@gandalf.sssup.it>,
        Tommaso Cucinotta <cucinotta@sssup.it>,
        Juri Lelli <juri.lelli@gmail.com>,
        Nicola Manica <nicola.manica@disi.unitn.it>,
        Luca Abeni <luca.abeni@unitn.it>, Dhaval Giani <dhaval@retis.sssup.it>,
        Harald Gustafsson <hgu1972@gmail.com>,
        paulmck <paulmck@linux.vnet.ibm.com>
In-Reply-To: <1289597455.6525.786.camel@Palantir>
References: <1288333128.8661.137.camel@Palantir>
	 <1288334250.8661.154.camel@Palantir>  <1289505471.2084.191.camel@laptop>
	 <1289597455.6525.786.camel@Palantir>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 13 Nov 2010 00:32:21 +0100
Message-ID: <1289604741.2084.361.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-12 at 22:30 +0100, Raistlin wrote:
> On Thu, 2010-11-11 at 20:57 +0100, Peter Zijlstra wrote:
> > > In fact, this patch:
> > >  - adds the resource limit RLIMIT_DLDLINE, which is the minimum value
> > >    a user task can use as its own deadline;
> > >  - adds the resource limit RLIMIT_DLRTIME, which is the maximum value
> > >    a user task can use as it own runtime.
> > > 
> >
> > We might also want to add an additional !SYS_CAP_ADMIN global bandwidth
> > cap much like the existing sysctl bandwidth cap.
> > 
> Mmm... I think we've never discussed much about that before, so here I
> am. I'm currently asking one to be root to set SCHED_DEADLINE as his
> policy. Normal users are allowed to do so, but just under the rlimits
> restrictions provided by this patch.
> 
> So, first of all, are we cool with this? Or do we want normal users to
> be able to give their tasks SCHED_DEADLINE policy by default? 

I think so, it would make it much more useful to people.

> Maybe we want that but up to a certain bandwidth?

Exactly.

>  Is this that you mean here,
> having two bandwidth limits, one of which !SYS_ADMINs could not cross?

Yep. A bandwidth cap for !SYS_CAP_ADMIN and a these two constraints
already introduced by this patch, a min period to avoid very fast timer
programming and a max runtime to avoid incurring large latencies on the
rest of the system.



