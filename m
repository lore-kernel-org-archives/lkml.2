Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081Ab1KHMt2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 07:49:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14086 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751509Ab1KHMt0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 07:49:26 -0500
Date: Tue, 8 Nov 2011 14:49:06 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: kvm@vger.kernel.org, avi@redhat.com, mtosatti@redhat.com,
        linux-kernel@vger.kernel.org, mingo@elte.hu, acme@ghostprotocols.net
Subject: Re: [PATCHv2 6/9] perf: expose perf capability to other modules.
Message-ID: <20111108124906.GO3225@redhat.com>
References: <1320323618-10375-1-git-send-email-gleb@redhat.com>
 <1320323618-10375-7-git-send-email-gleb@redhat.com>
 <1320674870.18053.37.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320674870.18053.37.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 07, 2011 at 03:07:50PM +0100, Peter Zijlstra wrote:
> On Thu, 2011-11-03 at 14:33 +0200, Gleb Natapov wrote:
> > @@ -1580,6 +1580,8 @@ __init int intel_pmu_init(void)
> >         x86_pmu.num_counters            = eax.split.num_counters;
> >         x86_pmu.cntval_bits             = eax.split.bit_width;
> >         x86_pmu.cntval_mask             = (1ULL << eax.split.bit_width) - 1;
> > +       x86_pmu.events_mask             = ebx;
> > +       x86_pmu.events_mask_len         = eax.split.mask_length;
> >  
> >         /*
> >          * Quirk: v2 perfmon does not report fixed-purpose events, so
> > @@ -1651,6 +1653,7 @@ __init int intel_pmu_init(void)
> >                          * architectural event which is often completely bogus:
> >                          */
> >                         intel_perfmon_event_map[PERF_COUNT_HW_BRANCH_MISSES] = 0x7f89;
> > +                       x86_pmu.events_mask &= ~0x40;
> >  
> >                         pr_cont("erratum AAJ80 worked around, ");
> >                 } 
> 
> It might make sense to introduce cpuid10_ebx or so, also I think the
cpuid10_ebx will have only one field though (event_mask).

> At the very least add a full ebx iteration to disable unsupported events
> in the intel-v1 case.
I do not understand what do you mean here, cpuid10_ebx was introduced by
intel v1 architectural PMU so it should already contain correct information.

--
			Gleb.
