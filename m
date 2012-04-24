Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925Ab2DXRf3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 13:35:29 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:50581 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756863Ab2DXRf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 13:35:28 -0400
Date: Tue, 24 Apr 2012 23:05:18 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] sched: steer waking task to empty cfs_rq for better
 latencies
Message-ID: <20120424173518.GB18799@linux.vnet.ibm.com>
Reply-To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <20120424165619.GA28701@linux.vnet.ibm.com>
 <1335286696.28150.206.camel@twins>
 <20120424170743.GA18799@linux.vnet.ibm.com>
 <1335287547.28150.210.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1335287547.28150.210.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12042417-4790-0000-0000-000002550DB8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2012-04-24 19:12:27]:

> > The workload I am up against does experience tons of wakeup (after very short 
> > (microsecond range) bursts of sleeps) and so am skeptical how the global 
> > vruntime would keep up with this kind of workload. I'd be happy to test patches 
> > and give feedback!
> 
> Thing is, global vruntime might fix that flaw/property you're exploiting
> to get that preemption.

Am curious to see how global vruntime influences task placement (esp. on
wakeup). Going back to the previous example:

                        N0                 N1
                        (0,1,2,3)	(4,5,6,7)

rq.nr_run ->            2 1 1 1         2 2 1 1
/a cfs_rq.nr_run ->     0 0 0 0         0 0 0 1


CPU7 is running a task A0 belonging to "/a". Another task A1 belonging
to "/a" is waking up and its prev_cpu was 7. Currently we let it wake on
cpu7 itself and wait behind A0. With global vruntime, are you saying
that we let A1 wake on cpu7 and it would preempt A0? That would still not be 
nice as A0 now incurs some additional latencies?

- vatsa

