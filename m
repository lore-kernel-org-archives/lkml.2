Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960Ab2EWQ3n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 12:29:43 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:57021 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751369Ab2EWQ3m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 12:29:42 -0400
Date: Wed, 23 May 2012 09:28:46 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linaro-sched-sig@lists.linaro.org,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Kevin Hilman <khilman@ti.com>, Max Krasnyansky <maxk@qualcomm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 37/41] rcu: New rcu_user_enter() and rcu_user_exit() APIs
Message-ID: <20120523162846.GF2402@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1335830115-14335-1-git-send-email-fweisbec@gmail.com>
 <1335830115-14335-38-git-send-email-fweisbec@gmail.com>
 <20120522182306.GD8087@linux.vnet.ibm.com>
 <20120523142213.GF1663@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120523142213.GF1663@somewhere>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12052316-9360-0000-0000-0000069D91D8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 04:22:17PM +0200, Frederic Weisbecker wrote:
> On Tue, May 22, 2012 at 11:23:06AM -0700, Paul E. McKenney wrote:
> > On Tue, May 01, 2012 at 01:55:11AM +0200, Frederic Weisbecker wrote:
> > > These two APIs are provided to help the implementation
> > > of an adaptive tickless kernel (cf: nohz cpusets). We need
> > > to run into RCU extended quiescent state when we are in
> > > userland so that a tickless CPU is not involved in the
> > > global RCU state machine and can shutdown its tick safely.
> > > 
> > > These APIs are called from syscall and exception entry/exit
> > > points and can't be called from interrupt.
> > > 
> > > They are essentially the same than rcu_idle_enter() and
> > > rcu_idle_exit() minus the checks that ensure the CPU is
> > > running the idle task.
> > 
> > This looks reasonably sane.  There are a few nits like missing comment
> > headers for functions and the need for tracing, but I can handle that
> > when I pull it in.  I am happy to do that pretty much any time, but not
> > before the API stabilizes.  ;-)
> > 
> > So let me know when it is ready for -rcu.
> 
> Ok. So would you be willing to host this specific part in -rcu? I don't
> know if these APIs are welcome upstream if they have no upstream users
> yet. OTOH it would be easier for me if I don't need to include these patches
> in my endless rebases.
> 
> Another solution is to host that in some seperate tree. In yours or in -tip.
> Ingo seemed to be willing to host this patchset.
> 
> What do you think?
> 
> I believe I need to rebase against your latest changes though.

Indeed, there has been a bit of churn in this area from RCU_FAST_NO_HZ.

							Thanx, Paul

