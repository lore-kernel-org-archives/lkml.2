Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547Ab2FDOll (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 10:41:41 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:40602 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754952Ab2FDOlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 10:41:40 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18ddG0c6VQdrKo0oukg+g7bbFY+IQa34jPjypFUW0
	n3xxP1rUZicOl5
Message-ID: <1338820895.7356.252.camel@marge.simpson.net>
Subject: Re: [PATCH] sched: balance_cpu to consider other cpus in its group
 as target of (pinned) task migration
From: Mike Galbraith <efault@gmx.de>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>, mingo@kernel.org,
        LKML <linux-kernel@vger.kernel.org>, roland@kernel.org,
        Ingo Molnar <mingo@elte.hu>
Date: Mon, 04 Jun 2012 16:41:35 +0200
In-Reply-To: <20120604143802.GB26651@linux.vnet.ibm.com>
References: <4FCC4E3B.4090209@linux.vnet.ibm.com>
	 <1338801907.7356.163.camel@marge.simpson.net>
	 <1338810796.28282.32.camel@twins>
	 <1338814063.7356.192.camel@marge.simpson.net>
	 <20120604130740.GC25126@linux.vnet.ibm.com>
	 <1338820234.7356.250.camel@marge.simpson.net>
	 <20120604143802.GB26651@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-04 at 20:08 +0530, Srivatsa Vaddagiri wrote: 
> * Mike Galbraith <efault@gmx.de> [2012-06-04 16:30:34]:
> 
> > Yeah, this is true, it is a latency source and a fairness violation.
> > Slow path balance consideration does make some sense to me.
> > 
> > But, if you have an RT requirement, you can't afford to mix unknown
> > entities, nor over-commit etc.  A realtime application will assign all
> > resources, so the load balancer becomes essentially unemployed.  No?
> > Non critical worker-bees may be allowed to bounce around in say a
> > cpuset, but none of the CPUs which do critical work will ever be
> > over-committed, else application just lost the war.  In that regard,
> > twiddling the load balancer to accommodate strange sounding case still
> > seems wrong to me.
> 
> Btw the patch should help non-rt case as well (where a high
> priority SCHED_OTHER is hogging cpu while low-priority SCHED_OTHER task
> on that same cpu suffers as we choose not to move it to another
> cpu (because of the way balance_cpu based load balance is written).

But high priority SCHED_OTHER tasks do not hog the CPU, they get their
fair share as defined by the user.

-Mike

