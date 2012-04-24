Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662Ab2DXR0W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 13:26:22 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:46701 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755566Ab2DXR0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 13:26:21 -0400
Date: Tue, 24 Apr 2012 22:56:03 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] sched: steer waking task to empty cfs_rq for better
 latencies
Message-ID: <20120424172603.GB28701@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1335287354.28150.209.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12042417-2674-0000-0000-000004282A1B
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

The first loop doesn't necessarily iterate thr' all cpus (as its looking
for a core that is fully idle - and hence breaks once it finds a busy
sibling).

> furthermore, that 100%+ gain is still way insane, what else is broken?

?

I have tried most benchmarks that were recommended for this kind of
change. Let me know if you suggest any other benchmark ..

> Did you try those paravirt tlb-flush patches and other such weirdness?

I will try that next. But IMHO the benefit of reduced wakeup latencies
should be over and above any benefit we get from paravirtualization.

- vatsa

