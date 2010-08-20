Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818Ab0HTIQv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 04:16:51 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39375 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751650Ab0HTIQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 04:16:48 -0400
Date: Fri, 20 Aug 2010 10:16:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Don Zickus <dzickus@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v3] perf, x86: try to handle unknown nmis with running
 perfctrs
Message-ID: <20100820081605.GD17551@elte.hu>
References: <20100804184806.GL26154@erda.amd.com>
 <20100804192634.GG5130@lenovo>
 <20100806065203.GR26154@erda.amd.com>
 <20100806142131.GA1874@redhat.com>
 <20100809194829.GB26154@erda.amd.com>
 <20100817152225.GQ26154@erda.amd.com>
 <1282214753.1926.4669.camel@laptop>
 <20100819141240.GO4879@redhat.com>
 <1282228033.2605.204.camel@laptop>
 <20100820015017.GA4879@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100820015017.GA4879@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0061]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Don Zickus <dzickus@redhat.com> wrote:

> On Thu, Aug 19, 2010 at 04:27:13PM +0200, Peter Zijlstra wrote:
> > On Thu, 2010-08-19 at 10:12 -0400, Don Zickus wrote:
> > > On Thu, Aug 19, 2010 at 12:45:53PM +0200, Peter Zijlstra wrote:
> > > > 
> > > > I queued it with that part changed to:
> > > 
> > > I realized the other day this change doesn't cover the nehalem, core and p4
> > > cases which use
> > > 
> > > intel_pmu_handle_irq
> > > p4_pmu_handle_irq
> > > 
> > > as their handlers.  Though that patch can go on top of Robert's.
> > 
> > Something like this?
> 
> I tested this patch and Robert's on an AMD box and Nehalem box.  Both
> worked as intended.  However I did notice that whenever the AMD box
> detected handled >1, it was shortly followed by an unknown_nmi that was
> properly eaten with Robert's logic.  Whereas on the Nehalem box I saw a
> lot of 'handled > 1' messages but very very few of them were followed by
> an unknown_nmi message (and those messages that did come were properly
> eaten).
> 
> Maybe that is just the differences in the cpu designs.
> 
> Of course I had to make the one change I mentioned previously for the
> perf_event_intel.c file (moving the handled++ logic down a few lines).
> 
> I didn't run the test on a P4 box.
> 
> Looks great, thanks guys!

Please someone send the final version with a changelog, with all the acks and 
tested-by's added, so that i can send it Linuswards.

Thanks,

	Ingo
