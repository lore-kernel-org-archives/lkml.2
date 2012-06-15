Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644Ab2FOMNc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 08:13:32 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:47393 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147Ab2FOMNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 08:13:30 -0400
Date: Fri, 15 Jun 2012 14:13:25 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@ti.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Luck,Tony" <tony.luck@intel.com>
Subject: Re: [RFC GIT PULL] nohz: Basic cputime accounting for adaptive
 tickless
Message-ID: <20120615121325.GC28541@gmail.com>
References: <1339604397-8758-1-git-send-email-fweisbec@gmail.com>
 <1339664829.2559.14.camel@twins>
 <20120614111241.GA16848@somewhere>
 <20120614111638.GA16676@gmail.com>
 <alpine.LFD.2.02.1206141321010.3086@ionos>
 <20120614112241.GB16848@somewhere>
 <20120614144815.1401af49@de.ibm.com>
 <20120614130425.GC16848@somewhere>
 <20120614143633.GA32094@gmail.com>
 <20120614173453.GA20071@somewhere.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120614173453.GA20071@somewhere.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Thu, Jun 14, 2012 at 04:36:33PM +0200, Ingo Molnar wrote:
> > 
> > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > 
> > > > > > > > I'll try something with that.
> > > > > > > 
> > > > > > > Maybe sanitize all the variants under a single set of 
> > > > > > > wrappers/callbacks?
> > > > > > 
> > > > > > Yes, please!
> > > > > 
> > > > > Sure, I'm working in it.
> > > >  
> > > > Please keep me in the loop, I want to avoid that things 
> > > > break on s390. Thanks.
> > > 
> > > Well, I realize I can't consolidate much between ia64, s390 
> > > and ppc because they all handle virtual cpu time accounting 
> > > very differently. I'm also not what the virtual timer is for.
> > 
> > As a first step I'd suggest to create a superset of all existing 
> > and relied-upon wrappers/callbacks, into a single obvious 
> > sched_*() or time_*() namespace, without breaking functionality.
> 
> But the API is already well defined. The arch just need to 
> implement account_system_vtime() and account_process_tick() 
> and record the time on the kernel boundaries. This is pretty 
> well contained in ppc entry.S where it is implemented through 
> ACCOUNT_CPU_USER_ENTRY/EXIT macros (although I see the time 
> accounted on syscall boundaries but not in exceptions), it's 
> more complicated in ia64 as the virt accounting is spread here 
> and there in entry.S and it's always on in s390.
> 
> May be we could standardize a bit the way we save and account 
> the time. This require some non-trivial asm surgery on archs I 
> don't know much about though.

Yeah, account_*() is a fine API too - as long as it's a 
unification of all time accounting functionality.

Thanks,

	Ingo
