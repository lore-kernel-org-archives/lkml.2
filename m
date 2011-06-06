Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587Ab1FFSMw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 14:12:52 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:34270 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753764Ab1FFSMv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 14:12:51 -0400
Date: Mon, 6 Jun 2011 11:12:46 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0/4] rcu: Detect rcu uses under extended quiescent
 state, and fix some
Message-ID: <20110606181246.GM3066@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1307329858-14999-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307329858-14999-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 06, 2011 at 05:10:53AM +0200, Frederic Weisbecker wrote:
> I found two examples with the last two patches but I suspect there are more bugs
> waiting to be detected under other configs and/or archs.

Good catch!!!

							Thanx, Paul

> Frederic Weisbecker (4):
>   rcu: Detect uses of rcu read side in extended quiescent states
>   nohz: Split extended quiescent state handling from nohz switch
>   x86: Don't call idle notifier inside rcu extended QS
>   x86: Call idle_exit() after irq_enter()
> 
>  arch/arm/kernel/process.c                |    4 +-
>  arch/avr32/kernel/process.c              |    4 +-
>  arch/blackfin/kernel/process.c           |    4 +-
>  arch/microblaze/kernel/process.c         |    4 +-
>  arch/mips/kernel/process.c               |    4 +-
>  arch/powerpc/kernel/idle.c               |    4 +-
>  arch/powerpc/platforms/iseries/setup.c   |    8 +++---
>  arch/s390/kernel/process.c               |    4 +-
>  arch/sh/kernel/idle.c                    |    2 +-
>  arch/sparc/kernel/process_64.c           |    4 +-
>  arch/tile/kernel/process.c               |    4 +-
>  arch/um/kernel/process.c                 |    4 +-
>  arch/unicore32/kernel/process.c          |    4 +-
>  arch/x86/kernel/apic/apic.c              |    6 ++--
>  arch/x86/kernel/apic/io_apic.c           |    3 +-
>  arch/x86/kernel/cpu/mcheck/mce.c         |    2 +-
>  arch/x86/kernel/cpu/mcheck/therm_throt.c |    2 +-
>  arch/x86/kernel/cpu/mcheck/threshold.c   |    2 +-
>  arch/x86/kernel/irq.c                    |    5 +--
>  arch/x86/kernel/process_32.c             |    4 +-
>  arch/x86/kernel/process_64.c             |    7 +++++-
>  include/linux/lockdep.h                  |    8 ++++++-
>  include/linux/rcupdate.h                 |   20 ++++++++++++-----
>  include/linux/tick.h                     |   10 ++++++--
>  kernel/lockdep.c                         |   12 ++++++++--
>  kernel/pid.c                             |    2 +-
>  kernel/rcutree.c                         |   14 ++++++++++++
>  kernel/time/tick-sched.c                 |   34 ++++++++++++++++++++++++++++-
>  28 files changed, 129 insertions(+), 56 deletions(-)
> 
> -- 
> 1.7.5.2
> 
