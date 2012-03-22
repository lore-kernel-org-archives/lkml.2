Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751201Ab2CVEEH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 00:04:07 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:56124 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750873Ab2CVEEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 00:04:04 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/JuM4HBJXJCPZciRK8hVI2cq4ADlTR9lRnhCGtSR
	7cEW9PtLG+hm/c
Message-ID: <1332389033.5759.52.camel@marge.simpson.net>
Subject: Re: [PATCH 07/32] cpuset: Set up interface for nohz flag
From: Mike Galbraith <efault@gmx.de>
To: Christoph Lameter <cl@linux.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linaro-sched-sig@lists.linaro.org,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>, Ingo Molnar <mingo@kernel.org>,
        Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Zen Lin <zen@openhuawei.org>
Date: Thu, 22 Mar 2012 05:03:53 +0100
In-Reply-To: <alpine.DEB.2.00.1203210949440.20482@router.home>
References: <1332338318-5958-1-git-send-email-fweisbec@gmail.com>
	 <1332338318-5958-9-git-send-email-fweisbec@gmail.com>
	 <alpine.DEB.2.00.1203210949440.20482@router.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-21 at 09:50 -0500, Christoph Lameter wrote: 
> On Wed, 21 Mar 2012, Frederic Weisbecker wrote:
> 
> > Prepare the interface to implement the nohz cpuset flag.
> > This flag, once set, will tell the system to try to
> > shutdown the periodic timer tick when possible.
> >
> > We use here a per cpu refcounter. As long as a CPU
> > is contained into at least one cpuset that has the
> > nohz flag set, it is part of the set of CPUs that
> > run into adaptive nohz mode.
> 
> What are the drawbacks for nohz?

For nohz in general, latency.  To make it at all usable for rt loads, I
had to make isolated cores immune from playing load balancer.  Even so,
to achieve target latency, I had to hack up cpusets to let the user
dynamically switch nohz off for specified sets (and the tick has to be
skewed in both cases or you can just forget it).  With nohz, I can't
quite achieve 30us jitter target, turn it off, I get single digit.  Out
of the current box, triple digit for simple synchronized frame timers +
compute worker-bees load on 64 cores.  Patch 4 probably helps that, but
don't _think_ it'll fix it.  If you (currently) ever become balancer,
you're latency target is smoking wreckage.

-Mike

