Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951Ab2FNOgk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 10:36:40 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:44573 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270Ab2FNOgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 10:36:39 -0400
Date: Thu, 14 Jun 2012 16:36:33 +0200
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
Message-ID: <20120614143633.GA32094@gmail.com>
References: <1339604397-8758-1-git-send-email-fweisbec@gmail.com>
 <1339664829.2559.14.camel@twins>
 <20120614111241.GA16848@somewhere>
 <20120614111638.GA16676@gmail.com>
 <alpine.LFD.2.02.1206141321010.3086@ionos>
 <20120614112241.GB16848@somewhere>
 <20120614144815.1401af49@de.ibm.com>
 <20120614130425.GC16848@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120614130425.GC16848@somewhere>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> > > > > > I'll try something with that.
> > > > > 
> > > > > Maybe sanitize all the variants under a single set of 
> > > > > wrappers/callbacks?
> > > > 
> > > > Yes, please!
> > > 
> > > Sure, I'm working in it.
> >  
> > Please keep me in the loop, I want to avoid that things 
> > break on s390. Thanks.
> 
> Well, I realize I can't consolidate much between ia64, s390 
> and ppc because they all handle virtual cpu time accounting 
> very differently. I'm also not what the virtual timer is for.

As a first step I'd suggest to create a superset of all existing 
and relied-upon wrappers/callbacks, into a single obvious 
sched_*() or time_*() namespace, without breaking functionality.

Once that is done we can eliminate individual, conceptually 
redundant callbacks, by carefully morphing the affected arches 
step by step.

No arch will be left behind.

Thanks,

	Ingo
