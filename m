Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab2E0O3Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 10:29:24 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:56302 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750846Ab2E0O3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 10:29:20 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19iLlNWtd1iHia5CtuiL1taP0NL2AX5KmSJNKj05F
	SUmTJyS7ue8xxn
Message-ID: <1338128955.7400.43.camel@marge.simpson.net>
Subject: Re: [rfc][patch] select_idle_sibling() inducing bouncing on westmere
From: Mike Galbraith <efault@gmx.de>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, lkml <linux-kernel@vger.kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Paul Turner <pjt@google.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Date: Sun, 27 May 2012 16:29:15 +0200
In-Reply-To: <4FC2362A.8080503@linux.intel.com>
References: <1337857490.7300.19.camel@marge.simpson.net>
	 <1337865431.9783.148.camel@laptop> <1337865641.9783.149.camel@laptop>
	 <1337926468.5415.48.camel@marge.simpson.net>
	 <1338014259.7302.26.camel@marge.simpson.net>
	 <1338017364.14636.9.camel@twins>
	 <1338020834.7747.8.camel@marge.simpson.net>
	 <1338110259.7678.77.camel@marge.simpson.net>
	 <4FC2362A.8080503@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-05-27 at 07:11 -0700, Arjan van de Ven wrote: 
> On 5/27/2012 2:17 AM, Mike Galbraith wrote:
> > On Sat, 2012-05-26 at 10:27 +0200, Mike Galbraith wrote: 
> >> Hohum, back to finding out what happened to cpufreq.
> > 
> > Answer: nothing.. in mainline.
> > 
> > I test performance habitually, so just never noticed how bad ondemand
> > sucks.  In enterprise, I found the below, explaining why cores crank up
> > fine there, but not in mainline.  Somebody thumped ondemand properly on
> > it's pointy head.
> > 
> > But, check out the numbers below this, and you can see just how horrible
> > bouncing is when you add governor latency _on top_ of it. 
> 
> part of it is not ondemand, but cpufreq.
> cpufreq forces you to schedule a kernel thread to change cpu
> frequency... on the cpu that's already busy.
> God knows what the scehduler then does in terms of load balancing.

Well, it'll take a spot that could have been used to authorize an affine
wakeup for one, switch freqs a tad too late if it doesn't preempt, not
to mention munching valuable cycles.

> (yes this is one of the things that will be fixed in the code that we
> now have working internally, and we're now making sure does not regress)

Cool.

> btw, on modern Intel CPUs, where in Idle, you have a frequency of Zero,
> regardless of what you ask for when you're running, and where an idle
> cpu is clock gated.... the performance governor behaves almost the same
> as ondemand in terms of power (due to the suckitude of ondemand)... but
> much better performance.

That sounds like it should rock.

-Mike

