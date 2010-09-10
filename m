Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479Ab0IJOqz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 10:46:55 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51417 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752715Ab0IJOqy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 10:46:54 -0400
Date: Fri, 10 Sep 2010 16:46:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Don Zickus <dzickus@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, robert.richter@amd.com,
        gorcunov@gmail.com, fweisbec@gmail.com, linux-kernel@vger.kernel.org,
        ying.huang@intel.com, ming.m.lin@intel.com, yinghai@kernel.org,
        andi@firstfloor.org, eranian@google.com
Subject: Re: [PATCH 0/3 v2] nmi perf fixes
Message-ID: <20100910144634.GA1060@elte.hu>
References: <1283454469-1909-1-git-send-email-dzickus@redhat.com>
 <1284118900.402.35.camel@laptop>
 <20100910132741.GB4879@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100910132741.GB4879@redhat.com>
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


* Don Zickus <dzickus@redhat.com> wrote:

> On Fri, Sep 10, 2010 at 01:41:40PM +0200, Peter Zijlstra wrote:
> > On Thu, 2010-09-02 at 15:07 -0400, Don Zickus wrote:
> > > Fixes to allow unknown nmis to pass through the perf nmi handler instead
> > > of being swallowed.  Contains patches that are already in Ingo's tree.  Added
> > > here for completeness.  Based on ingo/tip
> > > 
> > > Tested on intel/amd
> > > 
> > > v2: patch cleanups and consolidation, no code changes
> > > 
> > > Don Zickus (1):
> > >   perf, x86: Fix accidentally ack'ing a second event on intel perf
> > >     counter
> > > 
> > > Peter Zijlstra (1):
> > >   perf, x86: Fix handle_irq return values
> > > 
> > > Robert Richter (1):
> > >   perf, x86: Try to handle unknown nmis with an enabled PMU
> > > 
> > >  arch/x86/kernel/cpu/perf_event.c       |   59 +++++++++++++++++++++++++-------
> > >  arch/x86/kernel/cpu/perf_event_intel.c |   15 +++++---
> > >  arch/x86/kernel/cpu/perf_event_p4.c    |    2 +-
> > >  3 files changed, 56 insertions(+), 20 deletions(-)
> > 
> > Both Ingo and I are getting Dazed and confused on our AMD machines, it
> > started before yesterday (that is, after backing out all my recent
> > changes it still gets dazed), so I suspect this set.
> > 
> > I'll look at getting a trace of the thing, but if any of you has a
> > bright idea...
> 
> What are you running to create the problem?  I can try and duplicate 
> it here.

It happens easily here - just running something like:

   perf record -g ./hackbench 10

a couple of times triggers it. Note, unlike with the earlier bug, the 
NMIs are not permanently 'stuck' - and everything continues working. 
Obviously the messages are nasty looking so this is a regression we need 
to fix.

Thanks,

	Ingo
