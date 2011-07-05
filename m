Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943Ab1GELov (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 07:44:51 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60668 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755740Ab1GELot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 07:44:49 -0400
Date: Tue, 5 Jul 2011 13:44:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>, Stephane Eranian <eranian@google.com>,
        Lin Ming <ming.m.lin@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip, final] perf, x86: Add hw_watchdog_set_attr() in a
 sake of nmi-watchdog on P4
Message-ID: <20110705114437.GC15654@elte.hu>
References: <20110705100320.GK17941@sun>
 <20110705102017.GA12458@elte.hu>
 <20110705103403.GN17941@sun>
 <20110705105959.GA14435@elte.hu>
 <20110705110550.GQ17941@sun>
 <20110705112002.GA15654@elte.hu>
 <20110705113620.GS17941@sun>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110705113620.GS17941@sun>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> On Tue, Jul 05, 2011 at 01:20:02PM +0200, Ingo Molnar wrote:
> > 
> > * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> > 
> > > On Tue, Jul 05, 2011 at 12:59:59PM +0200, Ingo Molnar wrote:
> > > ...
> > > > 
> > > > are 'non-sleeping ticks' non-halted cycles - i.e. cycles that 
> > > > always count with CPU frequency and can thus be used for periodic 
> > > > frequencies?
> > > 
> > > Yes, I think so (btw, as far as I remember oprofile does the same 
> > > 'threshold' gaming for nmi-watchdog).
> > 
> > But the NMI watchdog does not need a constant frequency event - it 
> > can use unhalted cycles just fine. Why does it need unhalted cycles 
> > on P4?
> > 
> 
> Ingo, the main problem there is not halted or unhalted events but rather
> inability of p4 architecture to move events between counters, with core
> or nehalem you can (if constraints allow) simply move nmi-watchdog event
> to another free counter and assign cpu cycles to a free slot. With p4 the
> situation is radically different -- every event has a number of contraints
> and once nmi-watchdog armed (it could be halted or unhaled event, whatever)
> ESCR/CCCR/counter registers tuple borrowed forever and we need to find out
> some different non-intersected ESCR/CCCR/counter tuple to count cpu-cycles
> in a sake of perf utility purpose. That is why this assignments done in
> a such weird way -- just to be able to run nmi-watchdog and cpu-cycles
> simultaneously.
> 
> Probably I miss something and you mean something completely different?

What i am missing is that you have not pointed out the *core problem* 
you are fixing and it's not obvious from the changelog either!

That the P4 has weird event constraints is not a problem users care 
about...

What 'bad thing' happens in practice without this patch, what 
limitations arise in perf or in the NMI watchdog? Does it lock up? 
Does it not work? Does 'perf top' get confused?

Conversely, what 'good thing' happens if the patch is applied and are 
there any limitations left?

Thanks,

	Ingo
