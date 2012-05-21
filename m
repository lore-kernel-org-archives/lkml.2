Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609Ab2EUHQa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 03:16:30 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:64818 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075Ab2EUHQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 03:16:28 -0400
Date: Mon, 21 May 2012 09:16:22 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        paulmck@linux.vnet.ibm.com, smuckle@quicinc.com, khilman@ti.com,
        Robin.Randhawa@arm.com, suresh.b.siddha@intel.com,
        thebigcorporation@gmail.com, venki@google.com,
        panto@antoniou-consulting.com, mingo@elte.hu, paul.brett@intel.com,
        pdeschrijver@nvidia.com, pjt@google.com, efault@gmx.de,
        fweisbec@gmail.com, geoff@infradead.org, rostedt@goodmis.org,
        tglx@linutronix.de, amit.kucheria@linaro.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linaro-sched-sig@lists.linaro.org,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Juri Lelli <juri.lelli@gmail.com>
Subject: Re: Plumbers: Tweaking scheduler policy micro-conf RFP
Message-ID: <20120521071622.GA30748@gmail.com>
References: <CAKfTPtDSDAOAdv0GTDswZeRM7TmACrjok+5kddSaQpvy6_6xWw@mail.gmail.com>
 <CAKfTPtCfiY7A29+e50F+6awd8BjNJjg4=uNN4ReZfdS_4FbpkA@mail.gmail.com>
 <1337084609.27020.156.camel@laptop>
 <CAKfTPtDz1-fR2i5x7AVd8sGZhX2VNtz2rnQC3ePrcHO9MWK3FQ@mail.gmail.com>
 <1337086834.27020.162.camel@laptop>
 <CAKfTPtDrZ-tfC81jnxwpB+DCtmxhU+VfoYbtSBr8MkFt+P8JcA@mail.gmail.com>
 <1337096141.27694.82.camel@twins>
 <1337193010.27694.146.camel@twins>
 <CA+55aFzuygx6L-2hVCMbk5cvEdDp6AUtOGq-wYFn=4yEyebPLw@mail.gmail.com>
 <1337469731.573.154.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337469731.573.154.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Sat, 2012-05-19 at 10:08 -0700, Linus Torvalds wrote:
> > And I
> > *do* know that the real world simply isn't simple enough that we could
> > ever do a perfect job, so don't even try - instead aim for
> > "understandable, maintainable, and gets the main issues roughly
> > right". 
> 
> I think we're in violent agreement on many points and most of 
> this is based on a mis-understanding. I've argued for exactly 
> this many times.

it's these pending commits in tip:sched/core:

8e7fbcbc22c1 sched: Remove stale power aware scheduling remnants and dysfunctional knobs
fac536f7e492 Merge branch 'sched/urgent' into sched/core
13e099d2f77e sched/debug: Fix printing large integers on 32-bit platforms
e44bc5c5d00e sched/fair: Improve the ->group_imb logic
556061b00c9f sched/nohz: Fix rq->cpu_load[] calculations
870a0bb5d636 sched/numa: Don't scale the imbalance
04f733b4afac sched/fair: Revert sched-domain iteration breakage
316ad248307f sched/x86: Rewrite set_cpu_sibling_map()
dd7d8634e619 sched/numa: Fix the new NUMA topology bits
cb83b629bae0 sched/numa: Rewrite the CONFIG_NUMA sched domain support
bd939f45da24 sched/fair: Propagate 'struct lb_env' usage into find_busiest_group
0ce90475dcdb sched/fair: Add some serialization to the sched_domain load-balance walk
c22402a2f76e sched/fair: Let minimally loaded cpu balance the group
c82513e51355 sched: Change rq->nr_running to unsigned int
ad7687dde878 x86/numa: Check for nonsensical topologies on real hw as well
0acbb440f063 x86/numa: Hard partition cpu topology masks on node boundaries
94c0dd3278dd x86/numa: Allow specifying node_distance() for numa=fake
19209bbb8612 x86/sched: Make mwait_usable() heed to "idle=" kernel parameters properly
489a71b029cd sched: Update documentation and comments

the result of these commits is:

 24 files changed, 417 insertions(+), 975 deletions(-)

Most of the linecount win is due to the removal of the 
dysfunctional power scheduling - but even without that commit 
it's a simplification:

 15 files changed, 415 insertions(+), 481 deletions(-)

while it lifts the historic limitations of the sched-domains 
approach and makes the code a whole lot more logical.

Nevertheless I'll wait for Linus to confirm that he agrees 
violently as well, before sending these bits ;-)

Thanks,

	Ingo
