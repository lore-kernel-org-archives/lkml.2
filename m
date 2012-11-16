Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108Ab2KPQ16 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 11:27:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49131 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752874Ab2KPQ0B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 11:26:01 -0500
Date: Fri, 16 Nov 2012 16:25:56 +0000
From: Mel Gorman <mgorman@suse.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Benchmark results: "Enhanced NUMA scheduling with adaptive
 affinity"
Message-ID: <20121116162556.GD8218@suse.de>
References: <20121112160451.189715188@chello.nl>
 <20121112184833.GA17503@gmail.com>
 <20121115100805.GS8218@suse.de>
 <20121116155626.GA4271@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20121116155626.GA4271@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 04:56:26PM +0100, Ingo Molnar wrote:
> 
> * Mel Gorman <mgorman@suse.de> wrote:
> 
> > It is important to know how this was configured. I was running 
> > one JVM per node and the JVMs were sized that they should fit 
> > in the node. [...]
> 
> That is not what I tested: as I described it in the mail I 
> tested 32 warehouses: i.e. spanning the whole system.
> 

Good (sortof) because that's my preferred explanation as to why we are
seeing different results. Different machines and different kernels would
be a lot more problematic.

> You tested 4 parallel JVMs running one per node, right?
> 

4 parallel JVMs sized so they they could fit one-per-node. However, I did
*not* bind them to nodes because that would be completely pointless for
this type of test.

I've queued up another set of tests and added a single-JVM configuration
to the mix. The kernels will have debugging, lockstat enabled and will
be running two passes with the second pass running profiling so the
results will not be directly comparable. However, I'll keep a close eye
on the Single vs Multi JVM results.

Thanks.

-- 
Mel Gorman
SUSE Labs
