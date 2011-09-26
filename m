Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260Ab1IZS0l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 14:26:41 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:50600 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752045Ab1IZS0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 14:26:39 -0400
Date: Mon, 26 Sep 2011 11:26:29 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andy Henroid <andrew.d.henroid@intel.com>,
        Mike Frysinger <vapier@gentoo.org>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        David Miller <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Russell King <linux@arm.linux.org.uk>,
        Paul Mackerras <paulus@samba.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCH 0/7 v4] rcu: Fix some rcu uses in extended quiescent
 state
Message-ID: <20110926182629.GI2399@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1317032352-25571-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317032352-25571-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 26, 2011 at 12:19:05PM +0200, Frederic Weisbecker wrote:
> Hi Paul,
> 
> Two fixes added in that set, the first two patches:
> 
> - The check on uses under extended quiescent states was buggy
> - One more illegal use of RCU fixed, from inside tick_nohz_stop_sched_tick()
> 
> It has survived one day and one night of rcutorture in x86-64
> with periodic cpu hotplug onlining/offlining...

Very good!  I have queued these and pushed them to -rcu on github
(https://github.com/paulmckrcu/linux) branch rcu/dynticks.

Some of the Power boxes are now back in the land of the living, and
will hopefully work their way through their testing backlogs some time
soon.  ;-)  At which point, I will restart PowerPC testing.

							Thanx, Paul

> No test in powerpc yet though... So I don't know yet why
> you got an rcutorture failure.
> 
> Frederic Weisbecker (7):
>   rcu: Fix preempt-unsafe debug check of rcu extended quiescent state
>   rcu: Fix early call to rcu_enter_nohz() on tick stopping
>   nohz: Separate out irq exit and idle loop dyntick logic
>   nohz: Allow rcu extended quiescent state handling seperately from
>     tick stop
>   x86: Enter rcu extended qs after idle notifier call
>   x86: Call idle notifier after irq_enter()
>   rcu: Fix early call to rcu_irq_exit()
> 
>  arch/arm/kernel/process.c                |    4 +-
>  arch/avr32/kernel/process.c              |    4 +-
>  arch/blackfin/kernel/process.c           |    4 +-
>  arch/microblaze/kernel/process.c         |    4 +-
>  arch/mips/kernel/process.c               |    4 +-
>  arch/powerpc/kernel/idle.c               |    4 +-
>  arch/powerpc/platforms/iseries/setup.c   |    8 +-
>  arch/s390/kernel/process.c               |    4 +-
>  arch/sh/kernel/idle.c                    |    4 +-
>  arch/sparc/kernel/process_64.c           |    4 +-
>  arch/tile/kernel/process.c               |    4 +-
>  arch/um/kernel/process.c                 |    4 +-
>  arch/unicore32/kernel/process.c          |    4 +-
>  arch/x86/kernel/apic/apic.c              |    6 +-
>  arch/x86/kernel/apic/io_apic.c           |    2 +-
>  arch/x86/kernel/cpu/mcheck/mce.c         |    2 +-
>  arch/x86/kernel/cpu/mcheck/therm_throt.c |    2 +-
>  arch/x86/kernel/cpu/mcheck/threshold.c   |    2 +-
>  arch/x86/kernel/irq.c                    |    6 +-
>  arch/x86/kernel/process_32.c             |    4 +-
>  arch/x86/kernel/process_64.c             |    9 ++-
>  include/linux/tick.h                     |   12 ++-
>  kernel/rcutree.c                         |   10 ++-
>  kernel/softirq.c                         |    4 +-
>  kernel/time/tick-sched.c                 |  120 +++++++++++++++++++++---------
>  25 files changed, 147 insertions(+), 88 deletions(-)
> 
> -- 
> 1.7.5.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
