Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981Ab2C0Kup (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 06:50:45 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:40943 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842Ab2C0Kun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 06:50:43 -0400
Date: Tue, 27 Mar 2012 12:50:37 +0200
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
        Thomas Gleixner <tglx@linutronix.de>, Zen Lin <zen@openhuawei.org>,
        Dimitri Sivanich <sivanich@sgi.com>
Subject: Re: [PATCH 08/32] nohz: Try not to give the timekeeping duty to an
 adaptive tickless cpu
Message-ID: <20120327105034.GA13196@somewhere>
References: <1332338318-5958-1-git-send-email-fweisbec@gmail.com>
 <1332338318-5958-10-git-send-email-fweisbec@gmail.com>
 <alpine.DEB.2.00.1203210950500.20482@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1203210950500.20482@router.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2012 at 09:52:24AM -0500, Christoph Lameter wrote:
> On Wed, 21 Mar 2012, Frederic Weisbecker wrote:
> 
> > Try to give the timekeeing duty to a CPU that doesn't belong
> > to any nohz cpuset when possible, so that we increase the chance
> > for these nohz cpusets to run their CPUs out of periodic tick
> > mode.
> 
> Any way to manually specify which cpu? We f.e. always "sacrifice" cpu 0
> for OS activities. We would like to have all Os processing things
> restricted to cpu 0 so that the rest of the processors do not experience
> the OS noise.

Somebody tries to do this: https://lkml.org/lkml/2011/11/8/346

But in the case of nohz cpusets there is a problem to solve:

What if every CPUs are tickless (idle or busy), who must take
the timekeeping duty? Should we pick one of the busy CPUs? Or
keep one CPU with the tick even if it's idle? How do we choose
this CPU?

May be we need to define another flag on cpusets to assign the
timekeeping duty to any CPU on a flagged set. This way we can
force that duty to the CPU(s) we want.
