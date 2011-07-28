Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745Ab1G1U4O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 16:56:14 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:55716 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755413Ab1G1U4L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 16:56:11 -0400
Date: Thu, 28 Jul 2011 13:56:00 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, David Miller <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        Mike Frysinger <vapier@gentoo.org>, Ralf Baechle <ralf@linux-mips.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Russell King <linux@arm.linux.org.uk>,
        Paul Mackerras <paulus@samba.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 0/3] rcu: Fix some rcu uses in extended quiescent state
Message-ID: <20110728205600.GU2403@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1310416472-2554-1-git-send-email-fweisbec@gmail.com>
 <20110715233203.GM2327@linux.vnet.ibm.com>
 <20110715234154.GC6590@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110715234154.GC6590@somewhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 16, 2011 at 01:41:56AM +0200, Frederic Weisbecker wrote:
> On Fri, Jul 15, 2011 at 04:32:03PM -0700, Paul E. McKenney wrote:
> > On Mon, Jul 11, 2011 at 10:34:29PM +0200, Frederic Weisbecker wrote:
> > > Hi,
> > > 
> > > First patch lays the ground to fix rcu uses in dyntick idle mode
> > > by splitting rcu extended qs state logic from tick nohz one.
> > > 
> > > The rest fixes the misuses that RCU has detected for me in x86.
> > 
> > These look good to me -- I have queued them and will try testing
> > them out.
> > 
> > > I'll try to fix those Paul has detected in PowerPc.
> > 
> > Looking forward to that one as well.  ;-)
> > 
> > It would be really cool if this approach could serve as RCU's idle-CPU
> > detection regardless of whether or not CONFIG_NO_HZ was set.  For one
> > thing, this would simplify the RCU code that treats idle tasks as extended
> > quiescent states.  Except during boot time.  :-/
> 
> For that we could just build rcu_enter_nohz() things on CONFIG_NO_HZ || CONFIG_PROVE_RCU.

Actually, it would be really cool if RCU could just rely on those
callbacks to detect idle regardless of the configuration.  Might not
be practical, but it would be nice.  ;-)

							Thanx, Paul

> > > Frederic Weisbecker (3):
> > >   nohz: Split extended quiescent state handling from nohz switch
> > >   x86: Enter rcu extended qs after idle notifier call
> > >   x86: Call idle notifier after irq_enter()
> > > 
> > >  arch/arm/kernel/process.c                |    4 +-
> > >  arch/avr32/kernel/process.c              |    4 +-
> > >  arch/blackfin/kernel/process.c           |    4 +-
> > >  arch/microblaze/kernel/process.c         |    4 +-
> > >  arch/mips/kernel/process.c               |    4 +-
> > >  arch/powerpc/kernel/idle.c               |    4 +-
> > >  arch/powerpc/platforms/iseries/setup.c   |    8 +++---
> > >  arch/s390/kernel/process.c               |    4 +-
> > >  arch/sh/kernel/idle.c                    |    2 +-
> > >  arch/sparc/kernel/process_64.c           |    4 +-
> > >  arch/tile/kernel/process.c               |    4 +-
> > >  arch/um/kernel/process.c                 |    4 +-
> > >  arch/unicore32/kernel/process.c          |    4 +-
> > >  arch/x86/kernel/apic/apic.c              |    6 ++--
> > >  arch/x86/kernel/apic/io_apic.c           |    2 +-
> > >  arch/x86/kernel/cpu/mcheck/mce.c         |    2 +-
> > >  arch/x86/kernel/cpu/mcheck/therm_throt.c |    2 +-
> > >  arch/x86/kernel/cpu/mcheck/threshold.c   |    2 +-
> > >  arch/x86/kernel/irq.c                    |    6 ++--
> > >  arch/x86/kernel/process_32.c             |    4 +-
> > >  arch/x86/kernel/process_64.c             |    5 ++++
> > >  include/linux/tick.h                     |   10 +++++--
> > >  kernel/time/tick-sched.c                 |   36 ++++++++++++++++++++++++++---
> > >  23 files changed, 83 insertions(+), 46 deletions(-)
> > > 
> > > -- 
> > > 1.7.5.4
> > > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
