Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760792Ab1D2SCU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 14:02:20 -0400
Received: from leopard.mail.utk.edu ([160.36.0.85]:45580 "EHLO
	leopard.mail.utk.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760781Ab1D2SCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 14:02:17 -0400
Date: Fri, 29 Apr 2011 14:01:28 -0400 (EDT)
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: Ingo Molnar <mingo@elte.hu>
cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@gmail.com>, Andi Kleen <ak@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: re-enable Nehalem raw Offcore-Events support
In-Reply-To: <20110429164227.GA25491@elte.hu>
Message-ID: <alpine.DEB.2.00.1104291353310.23685@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1104291056220.22212@cl320.eecs.utk.edu> <20110429164227.GA25491@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Apr 2011, Ingo Molnar wrote:

> Firstly, one technical problem i have with the raw events ABI method is that it 
> was added in commit e994d7d23a0b ("perf: Fix LLC-* events on Intel 
> Nehalem/Westmere"). The raw ABI bit was done 'under the radar', it was not the 
> declared title of the commit, it was not declared in the changelog either and 
> it was not my intention to offer such an ABI prematurely either - and i noticed 
> those two lines too late - but still in time to not let this slip into v2.6.39.

The initial patches from November seem to make it clear what is being done 
here.  I thought it was pretty obvious to those reviewing those patches 
what was involved.  How would I have known that OFFCORE_RESPONSE support 
was coming if I didn't see the patches obviously float by on linux-kernel?

> Thirdly, and this is my most fundamental objection, i also object to the timing 
> of this offcore raw access ABI, because past experience is that we *really* do 
> not want to allow raw PMU details without *first* having generic abstractions 
> and generic events first.

why?  Can you explain this better?

> The thing is, as far as i can see you and Andi are *still* pushing the failed 
> perfmon and Oprofile ABI and tooling models.

what ABI?  by the way, I hate oprofile and never use it.

perfmon2 and perfctr are very similar to perf_events in that they provide 
lightly massaged access to the MSRs so you can program whatever raw event 
that you like.

It's true that the *userspace* tools (pfmon, iperfex, PAPI) handle things 
differently than perf, but that's a *userspace* API, not a kernel ABI.  
You seem to keep confusing this.

> We put structure, proper abstractions and easy tooling *ahead* of the interests 
> of a small group of people who'd rather prefer a lowlevel, opaque hardware 
> channel so that they do not have to *think* about generalization and also 
> perhaps so they do not have to share their selection of events and analysis 
> methods with others ...

And generalization across platforms (and even across minor chip revisions) 
*doesn't work*.  It lasted maybe a year in PAPI before it was realized to 
be unworkable.  Talk to some people from AMD or Intel if you want.  It's 
not possible to sanely generalize perf counters.  They are too tied to 
hardware quirks.

Vince
vweaver1@eecs.utk.edu
