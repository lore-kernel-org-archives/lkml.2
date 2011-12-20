Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329Ab1LTSaL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 13:30:11 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41619 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751782Ab1LTSaC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 13:30:02 -0500
Date: Tue, 20 Dec 2011 19:27:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Vince Weaver <vweaver1@eecs.utk.edu>
Cc: Avi Kivity <avi@redhat.com>, Robert Richter <robert.richter@amd.com>,
        Benjamin Block <bebl@mageta.org>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>, hpa@zytor.com,
        tglx@linutronix.de, suresh.b.siddha@intel.com, eranian@google.com,
        brgerst@gmail.com, Andreas.Herrmann3@amd.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, Benjamin Block <benjamin.block@amd.com>
Subject: Re: [RFC 4/5] x86, perf: implements lwp-perf-integration (rc1)
Message-ID: <20111220182754.GD8408@elte.hu>
References: <20111218080443.GB4144@elte.hu>
 <ae462f089fd4375fe44b09361fb955af@server102.greatnet.de>
 <20111218234309.GA12958@elte.hu>
 <20111219090923.GB16765@erda.amd.com>
 <20111219105429.GC19861@elte.hu>
 <4EEF1C3B.3010307@redhat.com>
 <20111219114023.GB29855@elte.hu>
 <4EEF26F0.1050709@redhat.com>
 <20111220091511.GB3091@elte.hu>
 <alpine.DEB.2.00.1112201040190.11369@cl320.eecs.utk.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1112201040190.11369@cl320.eecs.utk.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vince Weaver <vweaver1@eecs.utk.edu> wrote:

> On Tue, 20 Dec 2011, Ingo Molnar wrote:

> > Granted, LWP was mis-designed to quite a degree, those AMD 
> > chip engineers should have talked to people who understand 
> > how modern PMU abstractions are added to the OS kernel 
> > properly.
> 
> You do realize that LWP was probably in design 5+ years ago, 
> at a time when most Linux kernel developers wanted nothing to 
> do with perf counters, and thus anyone they did contact for 
> help would have been from the since-rejected perfctr or 
> perfmon2 camp.

That does not really contradict what i said.

> Also, I'm sure Linux isn't the only Operating System that they 
> had in mind when designing this functionality.
> 
> Running LWP through the kernel is a foolish idea. Does anyone 
> have any numbers on what that would do to overhead?

At most an LLWPCB instruction is needed.

> perf_events creates huge overhead when doing self monitoring.  
> For simple self-monintoring counter reads it is an *order of 
> magnitude* worse than doing the same thing with perfctr.

Only if you are comparing apples to oranges: if you compare a 
full kernel based read of self-profiling counters with an RDPMC 
instruction.

But as we told you previously, you could use RDPMC under perf as 
well, last i checked PeterZ posted experimental patches for 
that. Peter, what's the status of that?

Thanks,

	Ingo
