Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463Ab1EGG6W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 02:58:22 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48365 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752812Ab1EGG6V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 02:58:21 -0400
Date: Sat, 7 May 2011 08:58:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Fix powerTOP regression with 2.6.39-rc5
Message-ID: <20110507065803.GA23414@elte.hu>
References: <4DC45537.6070609@linux.intel.com>
 <1304713252.25414.2532.camel@gandalf.stny.rr.com>
 <BANLkTim9YvResB+PwRp7QTK-a5VNg2PvmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTim9YvResB+PwRp7QTK-a5VNg2PvmQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, May 6, 2011 at 1:20 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > I strongly NACK this!
> 
> Doesn't matter.
> 
> Binary compatibility is more important.

Yes, absolutely, violently agreed.

Acked-by: Ingo Molnar <mingo@elte.hu>

Steve, we had this argument again and again internally, and you still do not 
seem to understand it: viable tooling is *way* more important than the 
short-term, marginal cleanliness interests of kernel developers. We wont be 
able to merge ftrace into perf until you understand this principle ...

Arjan, Steve, i think we need to create a 'perf test' testcase for ftrace 
events as well, to catch such ABI breakages faster, hm? It took a couple of 
months for this breakage to surface and that's clearly too slow.

> And if binaries don't use the interface to parse the format (or just parse it 
> wrongly - see the fairly recent example of adding uuid's to 
> /proc/self/mountinfo), then it's a regression.
> 
> And regressions get reverted, unless there are security issues or similar 
> that makes us go "Oh Gods, we really have to break things".
> 
> I don't understand why this simple logic is so hard for some kernel 
> developers to understand. Reality matters. Your personal wishes matter NOT AT 
> ALL.

You have just summed up the main philosophical difference between perf and 
ftrace: with perf we have a "sane tooling first" approach, while ftrace is 
still the old "kernel developers first" approach.

In the past 10 years i pushed tons of instrumentation code upstream and for a 
long time the kernel-integrated ftrace approach looked like the technical best 
solution to me, but after 2 years of sane instrumentation tooling via a proper 
user-space ABI and tools/perf/ i'm not looking back.

I am strongly convinced that we need to bite the bullet and unify the two 
approaches to enable even better tooling: expose the remaining bits of tracing 
functionality not available via perf yet via the perf ABI and move it under a 
single umbrella, slowly phase out the ABI-unstable /debug/tracing/ debugfs crap 
for new features and use the strict perf ABI approach. Steve?

Thanks,

	Ingo
