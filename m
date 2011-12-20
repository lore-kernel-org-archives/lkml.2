Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219Ab1LTWsD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 17:48:03 -0500
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:2558
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752037Ab1LTWsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 17:48:00 -0500
X-SpamScore: -3
X-BigFish: VS-3(zz1432N98dKzz1202hzzz2dh87h2a8h668h839h8e2h8e3h944hbe9n)
X-Forefront-Antispam-Report: CIP:160.36.179.112;KIP:(null);UIP:(null);IPV:NLI;H:kedge2.utk.tennessee.edu;RD:kedge2.utk.tennessee.edu;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
Date: Tue, 20 Dec 2011 17:47:55 -0500
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: Ingo Molnar <mingo@elte.hu>
CC: Avi Kivity <avi@redhat.com>, Robert Richter <robert.richter@amd.com>,
        Benjamin Block <bebl@mageta.org>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>, <hpa@zytor.com>,
        <tglx@linutronix.de>, <suresh.b.siddha@intel.com>,
        <eranian@google.com>, <brgerst@gmail.com>, <Andreas.Herrmann3@amd.com>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        Benjamin Block <benjamin.block@amd.com>
Subject: Re: [RFC 4/5] x86, perf: implements lwp-perf-integration (rc1)
In-Reply-To: <20111220182754.GD8408@elte.hu>
Message-ID: <alpine.DEB.2.00.1112201740280.18984@cl320.eecs.utk.edu>
References: <20111218080443.GB4144@elte.hu> <ae462f089fd4375fe44b09361fb955af@server102.greatnet.de> <20111218234309.GA12958@elte.hu> <20111219090923.GB16765@erda.amd.com> <20111219105429.GC19861@elte.hu> <4EEF1C3B.3010307@redhat.com> <20111219114023.GB29855@elte.hu>
 <4EEF26F0.1050709@redhat.com> <20111220091511.GB3091@elte.hu> <alpine.DEB.2.00.1112201040190.11369@cl320.eecs.utk.edu> <20111220182754.GD8408@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Dec 2011, Ingo Molnar wrote:

> 
> * Vince Weaver <vweaver1@eecs.utk.edu> wrote:
> 
> > On Tue, 20 Dec 2011, Ingo Molnar wrote:
> 
> > > Granted, LWP was mis-designed to quite a degree, those AMD 
> > > chip engineers should have talked to people who understand 
> > > how modern PMU abstractions are added to the OS kernel 
> > > properly.
> > 
> > You do realize that LWP was probably in design 5+ years ago, 
> > at a time when most Linux kernel developers wanted nothing to 
> > do with perf counters, and thus anyone they did contact for 
> > help would have been from the since-rejected perfctr or 
> > perfmon2 camp.
> 
> That does not really contradict what i said.

Well I'm just assuming that when you say "people who understand
how modern PMU abstractions are added to the OS kernel properly"
you mean yourself and the perf_event crew.

There are many other schools of thought on what kernel PMU abstractions 
should look like, and I'm sure AMD conferred with them.


> > Running LWP through the kernel is a foolish idea. Does anyone 
> > have any numbers on what that would do to overhead?
> 
> At most an LLWPCB instruction is needed.

you're saying that all the crazy kernel stuff you're proposing will have 
no extra overhead when compared to just implementing the proper xsave 
context switch code?

> > perf_events creates huge overhead when doing self monitoring.  
> > For simple self-monintoring counter reads it is an *order of 
> > magnitude* worse than doing the same thing with perfctr.
> 
> Only if you are comparing apples to oranges: if you compare a 
> full kernel based read of self-profiling counters with an RDPMC 
> instruction.

The benchmarks I posted show measurements getting *real data* from the 
counters.  Yes, on perfctr this is mostly just a rdpmc call plus a quick 
access to some mmap'd memory to make sure the context is valid.

perfctr is an order of magnitude less overhead because it was designed 
from the beginning to be a very low-overhead way to get self-monitoring 
data.  A lot of time and tuning was spent getting it that fast.

perf_event throws everything and the kitchen sink in the the kernel.  I'm 
guessing low-overhead self-monitoring was not really one of your primary 
design goals, and it shows.

> But as we told you previously, you could use RDPMC under perf as 
> well, last i checked PeterZ posted experimental patches for 
> that. Peter, what's the status of that?

yes.  If you checked the benchmark results I showed, you'd have seen that 
I run tests against that patchset too, and it's really only marginally 
better that the current perf_event stuff.  I might have written the 
benchmark poorly, but that's mainly because as-posted the documentation 
for how to use that patchset is a bit unclear.

Vince
vweaver1@eecs.utk.edu

