Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624Ab2DXRMk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 13:12:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:48541 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755725Ab2DXRMj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 13:12:39 -0400
Message-ID: <1335287547.28150.210.camel@twins>
Subject: Re: [PATCH v1] sched: steer waking task to empty cfs_rq for better
 latencies
From: Peter Zijlstra <peterz@infradead.org>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org
Date: Tue, 24 Apr 2012 19:12:27 +0200
In-Reply-To: <20120424170743.GA18799@linux.vnet.ibm.com>
References: <20120424165619.GA28701@linux.vnet.ibm.com>
	 <1335286696.28150.206.camel@twins>
	 <20120424170743.GA18799@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-24 at 22:37 +0530, Srivatsa Vaddagiri wrote:
> * Peter Zijlstra <peterz@infradead.org> [2012-04-24 18:58:16]:
> 
> > On Tue, 2012-04-24 at 22:26 +0530, Srivatsa Vaddagiri wrote:
> > > Steer a waking task towards a cpu where its cgroup has zero tasks (in
> > > order to provide it better sleeper credits and hence reduce its wakeup
> > > latency). 
> > 
> > That's just vile.. pjt could you post your global vruntime stuff so
> > vatsa can have a go at that?
> 
> The workload I am up against does experience tons of wakeup (after very short 
> (microsecond range) bursts of sleeps) and so am skeptical how the global 
> vruntime would keep up with this kind of workload. I'd be happy to test patches 
> and give feedback!

Thing is, global vruntime might fix that flaw/property you're exploiting
to get that preemption.


