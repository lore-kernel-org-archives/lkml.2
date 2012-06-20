Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524Ab2FTOWP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 10:22:15 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:41784
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756228Ab2FTOWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 10:22:14 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dI936eI1432Izz1202hzz8275bhz2dh668h839h944hd25hf0ah)
X-WSS-ID: 0M5X6KX-02-3ZZ-02
X-M-MSG: 
Date: Wed, 20 Jun 2012 16:22:07 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 05/10] perf, x86: Move Intel specific code to
 intel_pmu_init()
Message-ID: <20120620142207.GL1478@erda.amd.com>
References: <1340129448-8690-1-git-send-email-robert.richter@amd.com>
 <1340129448-8690-6-git-send-email-robert.richter@amd.com>
 <1340185002.21745.80.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1340185002.21745.80.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.06.12 11:36:42, Peter Zijlstra wrote:
> On Tue, 2012-06-19 at 20:10 +0200, Robert Richter wrote:
> > There is some Intel specific code in the generic x86 path. Move it to
> > intel_pmu_init().
> > 
> > Signed-off-by: Robert Richter <robert.richter@amd.com>
> > ---
> 
> > diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
> > index 1eb9f00..90d7097 100644
> > --- a/arch/x86/kernel/cpu/perf_event_intel.c
> > +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> > @@ -1760,7 +1760,7 @@ static __init void intel_nehalem_quirk(void)
> >  	}
> >  }
> >  
> > -__init int intel_pmu_init(void)
> > +static __init int __intel_pmu_init(void)
> >  {
> >  	union cpuid10_edx edx;
> >  	union cpuid10_eax eax;
> > @@ -1955,3 +1955,46 @@ __init int intel_pmu_init(void)
> >  
> >  	return 0;
> >  }
> > +
> > +__init int intel_pmu_init(void)
> > +{
> > +	struct event_constraint *c;
> > +	int ret = __intel_pmu_init();
> 
> 
> This seems like a nice enough cleanup all on its own, but why make it
> two functions?

Didn't know if checks are necessary after p6_pmu_init() and
p4_pmu_init(). I didn't want to touch the switch/case path containing
p6_pmu_init() and p4_pmu_init(). But it seems the p4 and p6 pmus don't
support fixed counters and have fix num_counter values. Thus we can
skip the checks that are moved from init_hw_perf_events() in that case
and leave intel_pmu_init() early.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

