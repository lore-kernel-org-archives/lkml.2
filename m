Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311Ab2C0LTx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 07:19:53 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:40116 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817Ab2C0LTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 07:19:51 -0400
Date: Tue, 27 Mar 2012 13:19:45 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linaro-sched-sig@lists.linaro.org,
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
Subject: Re: [PATCH 07/32] cpuset: Set up interface for nohz flag
Message-ID: <20120327111943.GB13196@somewhere>
References: <1332338318-5958-1-git-send-email-fweisbec@gmail.com>
 <1332338318-5958-9-git-send-email-fweisbec@gmail.com>
 <alpine.DEB.2.00.1203210949440.20482@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1203210949440.20482@router.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2012 at 09:50:27AM -0500, Christoph Lameter wrote:
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
> 
> If there are none: Can we make nohz default behavior without relying on
> cpusets?

I can't tell for now. I haven't yet covered everything the timer is
handling. Until that happens I can't do measurements.

In theory this sounds like a win in every case. I just would like
to test that in practice. This sets up hooks in kernel entry/exit.
More IPIs here and there. May be this adds overhead on workloads
involving a lot of syscalls or exceptions. I don't know.

Given this is not yet entirely clear, I think it may be better to keep
this interface around until the patchset reaches a version that becomes
mergeable. Then at this point we can get serious testing coverage to take
the decision to drop the interface and make it unconditional on
CONFIG_ADAPTIVE_NO_HZ.
