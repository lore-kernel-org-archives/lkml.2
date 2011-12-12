Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712Ab1LLRpQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 12:45:16 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43342 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753655Ab1LLRpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 12:45:11 -0500
Date: Mon, 12 Dec 2011 18:32:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        acme@infradead.org, robert.richter@amd.com, ming.m.lin@intel.com,
        andi@firstfloor.org, asharma@fb.com
Subject: Re: [PATCH 2/4] perf_event: add PERF_COUNT_HW_REF_CPU_CYCLES generic
 PMU event
Message-ID: <20111212173215.GI23870@elte.hu>
References: <1323559734-3488-1-git-send-email-eranian@google.com>
 <1323559734-3488-3-git-send-email-eranian@google.com>
 <1323694657.13285.12.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323694657.13285.12.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Sun, 2011-12-11 at 00:28 +0100, Stephane Eranian wrote:
> > This event counts the number of reference core cpu cycles.
> > Reference means that the event increments at a constant rate which
> > is not subject to core CPU frequency adjustments. The event may
> > not count when the processor is in halted (low power) state.
> > As such, it may not be equivalent to wall clock time. However,
> > when the processor is not halted state, the event keeps
> > a constant correlation with wall clock time.
> > 
> > Signed-off-by: Stephane Eranian <eranian@google.com>
> > ---
> >  include/linux/perf_event.h |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> > index 564769c..0885561 100644
> > --- a/include/linux/perf_event.h
> > +++ b/include/linux/perf_event.h
> > @@ -54,6 +54,7 @@ enum perf_hw_id {
> >  	PERF_COUNT_HW_BUS_CYCLES		= 6,
> >  	PERF_COUNT_HW_STALLED_CYCLES_FRONTEND	= 7,
> >  	PERF_COUNT_HW_STALLED_CYCLES_BACKEND	= 8,
> > +	PERF_COUNT_HW_REF_CPU_CYCLES		= 9,
> >  
> >  	PERF_COUNT_HW_MAX,			/* non-ABI */
> >  };
> 
> Does it make sense to add this to the 'generic' events? Are 
> other archs going to use this?
> 
> That is, I already queued patch 1, I'm just wondering if the 
> generic bit makes sense, Even BUS_CYCLES seems to be a 
> questionable 'generic' event, but that's history and we can't 
> fix it.

If we named it in a generic way, with a generic, 
platform-independent meaning behind it, then it shouldn't be a 
problem. This is why i suggested naming it 'constant CPU cycles' 
- or 'constant freq cycles' or a variant of that.

Thanks,

	Ingo
