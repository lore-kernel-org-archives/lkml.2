Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757779Ab1KJQlw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 11:41:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34185 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755643Ab1KJQlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 11:41:51 -0500
Date: Thu, 10 Nov 2011 18:41:35 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        robert.richter@amd.com, mingo@elte.hu, ming.m.lin@intel.com,
        ak@linux.intel.com
Subject: Re: [PATCH] perf_events: fix and improve x86 event scheduling
Message-ID: <20111110164135.GA4659@redhat.com>
References: <20111107110149.GA5177@quad>
 <1320935860.13800.25.camel@twins>
 <CABPqkBS_4TBYUvw_bPbtgpAfp8+vnSRZBYQoSAOKjOYV4GHmXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBS_4TBYUvw_bPbtgpAfp8+vnSRZBYQoSAOKjOYV4GHmXA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 10, 2011 at 04:09:32PM +0100, Stephane Eranian wrote:
> On Thu, Nov 10, 2011 at 3:37 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > Just throwing this out there (hasn't event been compiled etc..).
> >
> > The idea is to try the fixed counters first so that we don't
> > 'accidentally' fill a GP counter with something that could have lived on
> > the fixed purpose one and then end up under utilizing the PMU that way.
> >
> > It ought to solve the most common PMU programming fail on Intel
> > thingies.
> >
Heh, just looked into doing exactly that here.

> What are the configs for which you have failures on Intel?
> 
Suppose you have 3 fixed event counters and 2 GP counters and 3 event.
One can go to one of the fixed counters or any GP, 2 others can be only on
GP. If the event that can go to fixed counter will be placed into GP
counter then one of the remaining events will fail to be scheduled.

> I think I can improve my algorithm for fixed counters by treating
> them separately and trying fixed counters first any supported
> event.
> 
--
			Gleb.
