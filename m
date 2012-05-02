Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242Ab2EBOB2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 10:01:28 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:38560 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755211Ab2EBOB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 10:01:26 -0400
Date: Wed, 2 May 2012 19:31:17 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] sched: steer waking task to empty cfs_rq for better
 latencies
Message-ID: <20120502140117.GC22740@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <20120424165619.GA28701@linux.vnet.ibm.com>
 <1335286696.28150.206.camel@twins>
 <1335287354.28150.209.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1335287354.28150.209.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12050214-5564-0000-0000-0000026F70B4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2012-04-24 19:09:14]:

> On Tue, 2012-04-24 at 18:58 +0200, Peter Zijlstra wrote:
> > On Tue, 2012-04-24 at 22:26 +0530, Srivatsa Vaddagiri wrote:
> > > Steer a waking task towards a cpu where its cgroup has zero tasks (in
> > > order to provide it better sleeper credits and hence reduce its wakeup
> > > latency). 
> > 
> > That's just vile.. pjt could you post your global vruntime stuff so
> > vatsa can have a go at that?
> 
> That is, you're playing a deficiency we should fix, not exploit.
> 
> Also, you do a second loop over all those cpus right after we've already
> iterated them..
> 
> furthermore, that 100%+ gain is still way insane, what else is broken?
> Did you try those paravirt tlb-flush patches and other such weirdness?

I got around to try pv-tlb-flush patches and it showed >100%
improvement for sysbench (without the balance-on-wake patch on host). This
was what readprofile showed (when pv-tlb-flush patches were absent in
guest):

1135704 total                                   0.3265
636737 native_cpuid                             18192.4857
283201 __bitmap_empty                           2832.0100
137853 flush_tlb_others_ipi                     569.6405

I will try out how much they help Trade workload (which got me started
on this originally) and report back (part of the problem in trying out
is that pv-tlb-flush platches are throwing wierd problems - which Nikunj
is helping investigate). 

In any case, we can't expect users to be able to easily upgrade their
guest VM kernels and so I am still looking for a solution that works for
older guest VM kernels. Paul, hope I can get the global vruntime patches
from you soon to test how much it helps!

- vatsa

