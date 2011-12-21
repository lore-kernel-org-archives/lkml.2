Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463Ab1LUMDB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 07:03:01 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48221 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752948Ab1LUMC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 07:02:57 -0500
Date: Wed, 21 Dec 2011 13:00:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Vince Weaver <vweaver1@eecs.utk.edu>
Cc: Avi Kivity <avi@redhat.com>, Robert Richter <robert.richter@amd.com>,
        Benjamin Block <bebl@mageta.org>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>, hpa@zytor.com,
        tglx@linutronix.de, suresh.b.siddha@intel.com, eranian@google.com,
        brgerst@gmail.com, Andreas.Herrmann3@amd.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, Benjamin Block <benjamin.block@amd.com>
Subject: Re: [RFC 4/5] x86, perf: implements lwp-perf-integration (rc1)
Message-ID: <20111221120055.GA4040@elte.hu>
References: <20111218234309.GA12958@elte.hu>
 <20111219090923.GB16765@erda.amd.com>
 <20111219105429.GC19861@elte.hu>
 <4EEF1C3B.3010307@redhat.com>
 <20111219114023.GB29855@elte.hu>
 <4EEF26F0.1050709@redhat.com>
 <20111220091511.GB3091@elte.hu>
 <alpine.DEB.2.00.1112201040190.11369@cl320.eecs.utk.edu>
 <20111220182754.GD8408@elte.hu>
 <alpine.DEB.2.00.1112201740280.18984@cl320.eecs.utk.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1112201740280.18984@cl320.eecs.utk.edu>
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


* Vince Weaver <vweaver1@eecs.utk.edu> wrote:

> > But as we told you previously, you could use RDPMC under 
> > perf as well, last i checked PeterZ posted experimental 
> > patches for that. Peter, what's the status of that?
> 
> yes.  If you checked the benchmark results I showed, you'd 
> have seen that I run tests against that patchset too, and it's 
> really only marginally better that the current perf_event 
> stuff.  I might have written the benchmark poorly, [...]

It is significantly faster for the self-monitoring case - which 
is a pretty niche usecase btw.

Have a look at how the 'perf test' self-test utilizes RDPMC in 
these commits in tip:perf/fast:

 08aa0d1f376e: perf tools: Add x86 RDPMC, RDTSC test
 e3f3541c19c8: perf: Extend the mmap control page with time (TSC) fields
 0c9d42ed4cee: perf, x86: Provide means for disabling userspace RDPMC
 fe4a330885ae: perf, x86: Implement user-space RDPMC support, to allow fast, user-space access to self-monitoring counters
 365a4038486b: perf: Fix mmap_page::offset computation
 35edc2a5095e: perf, arch: Rework perf_event_index()
 9a0f05cb3688: perf: Update the mmap control page on mmap()

You can find these commits in today's -tip. Overhead should be 
somewhere around 50 cycles per call (i suspect it could 
optimized more), which is a fraction of what a syscall is 
costing.

> [...] but that's mainly because as-posted the documentation 
> for how to use that patchset is a bit unclear.

In your world there's always someone else to blame.

The thing is, *you* are interested in this niche feature, PeterZ 
not so much.

You made a false claim that perf cannot use RDPMC and PeterZ has 
proven you wrong once again. Your almost non-stop whining and 
the constant misrepresentations you make are not very 
productive.

Thanks,

	Ingo
