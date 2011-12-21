Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab1LUAHT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 19:07:19 -0500
Received: from 8bytes.org ([88.198.83.132]:35251 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752739Ab1LUAHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 19:07:17 -0500
Date: Wed, 21 Dec 2011 01:07:16 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Avi Kivity <avi@redhat.com>, Robert Richter <robert.richter@amd.com>,
        Benjamin Block <bebl@mageta.org>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>, hpa@zytor.com,
        tglx@linutronix.de, suresh.b.siddha@intel.com, eranian@google.com,
        brgerst@gmail.com, Andreas.Herrmann3@amd.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, Benjamin Block <benjamin.block@amd.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC 4/5] x86, perf: implements lwp-perf-integration (rc1)
Message-ID: <20111221000716.GB30127@8bytes.org>
References: <20111219090923.GB16765@erda.amd.com> <20111219105429.GC19861@elte.hu> <4EEF1C3B.3010307@redhat.com> <20111219114023.GB29855@elte.hu> <4EEF26F0.1050709@redhat.com> <20111220091511.GB3091@elte.hu> <4EF05996.8030807@redhat.com> <20111220100916.GA20788@elte.hu> <20111220152758.GA30127@8bytes.org> <20111220184004.GE8408@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111220184004.GE8408@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 20, 2011 at 07:40:04PM +0100, Ingo Molnar wrote:

> > I am fine with integrating LWP into perf as long as it makes 
> > sense and does not break the intended usage scenario for LWP.
> 
> That's the wrong way around - in reality we'll integrate LWP 
> upstream only once it makes sense and works well with the 
> primary instrumentation abstraction we have in the kernel.

I still don't see why you want an abstraction for a hardware feature
that clearly doesn't need it. From an enablement perspective LWP is much
closer to AVX than to the MSR based PMU. And nobody really wants or
needs a kernel abstraction for AVX, no?

> Me or PeterZ could just say "this feature is too limited and not 
> convincing enough yet, sorry".

This statement shows very clearly the bottom-line of our conflict. You
see this as a perf-topic, for everyone else it is an x86 topic.

> But i'm being nice and helpful here [...]

And I appreciate the discussion. But we have fundamentally different
stand-points.  I hope we can come to an agreement.

> There's no "security implications" whatsoever. LWP is a ring-3 
> hw feature and it can do nothing that the user-space app could 
> not already do ...

Really? How could an application count DCache misses today without
instrumentation? I guess your answer is 'with perf', but LWP is a much
more light-weight way to do that because it works _completly_ in
hardware when the kernel supports context-switching it.

> 
> > [...] It also destroys the intended use-case for LWP because 
> > it disturbs any process that is doing self-profiling with LWP.
> 
> Why would it destroy that? Self-profiling can install events 
> just fine, the kernel will arbitrate the resource.

Because you can't reliably hand over the LWPCB management to the kernel.
The instruction to load a new LWPCB is executable in ring-3. Any
kernel-use of LWP will never be reliable. 

> > So what you are saying is (not just here, also in other emails 
> > in this thread) that every hardware not designed for perf is 
> > crap?
> 
> No - PMU hardware designed to not allow the profiling of the 
> kernel is obviously a crappy aspect of it. Also, PMU hardware 
> that does not allow 100% encapsulation by the kernel is 
> obviously not very wisely done either.

Why? Whats wrong with user-space having control over its own PMU in a
safe way? This is what the feature was designed for.


Thanks,

	Joerg

