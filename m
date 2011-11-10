Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757798Ab1KJRNz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 12:13:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56739 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757682Ab1KJRNx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 12:13:53 -0500
Date: Thu, 10 Nov 2011 19:13:44 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        robert.richter@amd.com, mingo@elte.hu, ming.m.lin@intel.com,
        ak@linux.intel.com
Subject: Re: [PATCH] perf_events: fix and improve x86 event scheduling
Message-ID: <20111110171344.GB4659@redhat.com>
References: <20111107110149.GA5177@quad>
 <1320935860.13800.25.camel@twins>
 <CABPqkBS_4TBYUvw_bPbtgpAfp8+vnSRZBYQoSAOKjOYV4GHmXA@mail.gmail.com>
 <20111110164135.GA4659@redhat.com>
 <CABPqkBQsQuzGP2YT+hucoZxgF4H1s9T3kriw37zTMrUwzTmLYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBQsQuzGP2YT+hucoZxgF4H1s9T3kriw37zTMrUwzTmLYA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 10, 2011 at 05:59:22PM +0100, Stephane Eranian wrote:
> On Thu, Nov 10, 2011 at 5:41 PM, Gleb Natapov <gleb@redhat.com> wrote:
> > On Thu, Nov 10, 2011 at 04:09:32PM +0100, Stephane Eranian wrote:
> >> On Thu, Nov 10, 2011 at 3:37 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> >> > Just throwing this out there (hasn't event been compiled etc..).
> >> >
> >> > The idea is to try the fixed counters first so that we don't
> >> > 'accidentally' fill a GP counter with something that could have lived on
> >> > the fixed purpose one and then end up under utilizing the PMU that way.
> >> >
> >> > It ought to solve the most common PMU programming fail on Intel
> >> > thingies.
> >> >
> > Heh, just looked into doing exactly that here.
> >
> >> What are the configs for which you have failures on Intel?
> >>
> > Suppose you have 3 fixed event counters and 2 GP counters and 3 event.
> > One can go to one of the fixed counters or any GP, 2 others can be only on
> > GP. If the event that can go to fixed counter will be placed into GP
> > counter then one of the remaining events will fail to be scheduled.
> >
> Yes and the current algorithm does the right thing.
>  e1 (1 fixed +2 GP) -> weight = 3
>  e2 (2 GP) -> weight = 2
>  e3 (2 GP) -> weight = 2
> 
> The current algorithm schedules the event from light to heavy
> weight. Thus, it schedules e2, e3 first on the GPs and then
> e1 necessarily ends up on the fixed counter.
> 
> Do you have a test case where this does not work on Intel?
Yeah, you are right indeed. Actually my incentive was to force an event
to a fixed counter since it didn't count correctly when programmed into
GP.

What about if event that can go to fixed counter can go to only first
GP? Then weight of each event will be 2. But I am not sure that such
constrain actually exists on any real CPU.

--
			Gleb.
