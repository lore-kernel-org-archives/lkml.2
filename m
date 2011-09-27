Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427Ab1I0Nkm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 09:40:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34372 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751485Ab1I0Nkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 09:40:41 -0400
Date: Tue, 27 Sep 2011 15:39:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Venki Pallipadi <venki@google.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] sched: fix nohz idle load balancer issues
Message-ID: <20110927133909.GB26578@elte.hu>
References: <20110926115049.GA22604@linux.vnet.ibm.com>
 <20110927063222.GB18519@elte.hu>
 <20110927103106.GD4357@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110927103106.GD4357@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -1.9
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.9 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.1 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> wrote:

> * Ingo Molnar <mingo@elte.hu> [2011-09-27 08:32:24]:
> 
> > What are the tasks doing which are running - are they plain burning 
> > CPU time? If the tasks do something more complex, do you also have a 
> > measure of how much work gets done by the workload, per second?
> 
> They are simple cpu hogs at this time.
> 
> > Percentual changes in that metric would be nice to include in an 
> > additional column - that way we can see that it's not only idle
> > that has gone down, but workload performance has gone up too.
> 
> Ok, good point.
> 
> > In fact even if there was only a CPU burning loop in the workload it 
> > would be nice to make that somewhat more sophisticated by letting it 
> > process some larger array that has a cache footprint. This mimics 
> > real workloads that don't just spin burning CPU time but do real data 
> > processing.
> > 
> > For any non-trivial workload it's possible to reduce idle time 
> > without much increase in work done and in fact it's possible to 
> > decrease idle time *and* work done - so we need to see more clearly 
> > here and make sure it's all an improvement.
> 
> Ok - I will run a cpu intensive benchmark and get some numbers on 
> how benchmark score varies with the patch applied. I can pick a 
> simple matrix multiplication type benchmark, unless you have other 
> suggestions!

Yeah, matrix multiplication would be fine i think.

You could create it yourself and add it into 
tools/perf/bench/cpu-matrix.c as a new 'perf bench cpu matrix' 
testcase - perhaps with a '-s 10m' parameter that defines the size of 
the matrices, and a '-i 1000' parameter to specify the number of 
iterations - or so.

We could use that for scheduler HPC benchmarking in the future as 
well.

Thanks,

	Ingo
