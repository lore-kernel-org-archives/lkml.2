Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115Ab1LUNzo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 08:55:44 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:21123 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab1LUNzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 08:55:43 -0500
X-SpamScore: -13
X-BigFish: VS-13(zz1487M1432N98dK1419Mzz1202hzzz2dh87h2a8h668h839h8e2h8e3h944hbe9n62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:160.36.179.113;KIP:(null);UIP:(null);IPV:NLI;H:kedge4.utk.tennessee.edu;RD:kedge4.utk.tennessee.edu;EFVD:NLI
X-FB-SS: 0,
X-FB-DOMAIN-IP-MATCH: fail
Date: Wed, 21 Dec 2011 08:55:08 -0500
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
In-Reply-To: <20111221120055.GA4040@elte.hu>
Message-ID: <alpine.DEB.2.00.1112210848100.29220@cl320.eecs.utk.edu>
References: <20111218234309.GA12958@elte.hu> <20111219090923.GB16765@erda.amd.com> <20111219105429.GC19861@elte.hu> <4EEF1C3B.3010307@redhat.com> <20111219114023.GB29855@elte.hu> <4EEF26F0.1050709@redhat.com> <20111220091511.GB3091@elte.hu>
 <alpine.DEB.2.00.1112201040190.11369@cl320.eecs.utk.edu> <20111220182754.GD8408@elte.hu> <alpine.DEB.2.00.1112201740280.18984@cl320.eecs.utk.edu> <20111221120055.GA4040@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Dec 2011, Ingo Molnar wrote:

> 
> * Vince Weaver <vweaver1@eecs.utk.edu> wrote:
> 
> Have a look at how the 'perf test' self-test utilizes RDPMC in 
> these commits in tip:perf/fast:

I did.  How many times do I have to tell you I already applied, ran, and 
benchmarked this code already, and the results were posted on that link in 
the previous e-mail.

> You can find these commits in today's -tip. Overhead should be 
> somewhere around 50 cycles per call (i suspect it could 
> optimized more), which is a fraction of what a syscall is 
> costing.

No, it's more than a "50-cycle" call.  To get a value out you need to do 
two rdpmc calls plus some mucking about with some mmap'd values.  It still 
benchmarks much slower than the perctr implementation.

I'd be glad to see _actual_ numbers for an _actual_ test that measures 
useful values.  Until then I'm believing the numbers I measure on three 
different architectures which still show that perf_event has high 
overhead.

> > [...] but that's mainly because as-posted the documentation 
> > for how to use that patchset is a bit unclear.
> 
> In your world there's always someone else to blame.

Yes.  I was blaming myself for not understanding the code well enough to 
write a good benchmark.

> The thing is, *you* are interested in this niche feature, PeterZ 
> not so much.

The thing *we* are interested in is the main PAPI use case.  It's arguable 
that more people use PAPI under Linux than actually use perf.

> You made a false claim that perf cannot use RDPMC and PeterZ has 
> proven you wrong once again. Your almost non-stop whining and 
> the constant misrepresentations you make are not very 
> productive.

I made no such claim.  Please cite.

You made the questionable claim that the AMD devels didn't consult with 
any competent perf counter experts.  What you meant was that they didn't 
have foresight 5 years that Ingo Molnar would come in late with some NIH 
implementation of some niche kernel functionality and take it over.  
Though in retrospect I guess that's inevitable.

Vince

