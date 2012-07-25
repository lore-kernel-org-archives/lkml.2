Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932737Ab2GYQnp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 12:43:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52645 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755987Ab2GYQno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 12:43:44 -0400
Date: Wed, 25 Jul 2012 09:43:39 -0700
From: Tejun Heo <tj@kernel.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: tglx@linutronix.de, mingo@kernel.org, peterz@infradead.org,
        rusty@rustcorp.com.au, paulmck@linux.vnet.ibm.com, namhyung@kernel.org,
        rjw@sisk.pl, nikunj@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 6/6] CPU hotplug: Invoke CPU offline notifiers in
 reverse order
Message-ID: <20120725164339.GA32378@google.com>
References: <20120725115224.3900.80783.stgit@srivatsabhat.in.ibm.com>
 <20120725115502.3900.10942.stgit@srivatsabhat.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120725115502.3900.10942.stgit@srivatsabhat.in.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Jul 25, 2012 at 05:25:13PM +0530, Srivatsa S. Bhat wrote:
> During CPU hotplug, we want to create the following effect:
>  * During CPU online, the CPU incrementally grows the number of services
>    it offers.
>  * During CPU offline, the services are incrementally retired, in the
>    reverse order of their growth during CPU online.
> 
> To achieve the above, invoke the registered CPU hotplug notifiers in the
> reverse order during CPU offline, with respect to the order in which they
> were invoked during CPU online.
> 
> This approach helps in making the hotplug path a lot more logically
> coherent: Services are started in a well-known order, perhaps with dependencies
> between them, while bringing up a CPU. While offlining the CPU, we honor
> many of the dependencies automatically by just backtracking the way we came;
> that is, by invoking the notifiers in the reverse order. Thus, this model of
> reverse notifier invocation helps us in avoiding the need for excessively
> messing with the notifier priorities while trying to get the ordering right.
> 
> Notes:
> 1. The workqueue code becomes simpler, since it now needs just a single CPU
> hotplug callback.
> 2. The scheduler's sched_cpu_[in]active() callbacks can also be merged into
> a single callback.
> 3. On similar lines, the cpusets' cpuset_cpu_[in]active() callbacks can also
> be merged.
> 
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

For workqueue part,

 Acked-by: Tejun Heo <tj@kernel.org>

Now that we can reverse-walk notifier chain, it probably is a good
idea to make it a bit smarter and call CANCELs in reverse order of
PREPAREs too.

Thanks.

-- 
tejun
