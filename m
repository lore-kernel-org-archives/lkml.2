Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987Ab2GIVEZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 17:04:25 -0400
Received: from gate.crashing.org ([63.228.1.57]:35431 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405Ab2GIVEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 17:04:24 -0400
Message-ID: <1341867820.3804.4.camel@pasglop>
Subject: Re: [PATCH 0/4] cputime: Virtual cputime accounting small cleanups
 and consolidation
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, Paul Mackerras <paulus@samba.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Date: Tue, 10 Jul 2012 07:03:40 +1000
In-Reply-To: <20120709175053.GE8185@somewhere.redhat.com>
References: <1340113391-1896-1-git-send-email-fweisbec@gmail.com>
	 <20120709175053.GE8185@somewhere.redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-09 at 19:50 +0200, Frederic Weisbecker wrote:
> On Tue, Jun 19, 2012 at 03:43:07PM +0200, Frederic Weisbecker wrote:
> > Not sure to which tree this should go. The scheduler one may be.
> > Anyway if you're fine with it, it is pullable at:
> > 
> > git://github.com/fweisbec/linux-dynticks.git
> > 	virt-cputime
> 
> Ping. Are you guys fine with the patchset?

Missed it somewhat. I'll have a look today.

(Poke me on IRC with a stick if you don't hear from me in time)

Cheers,
Ben.

> > 
> > This is only built tested on the relevant archs.
> > 
> > I wish we could do more vtime cputime accounting consolidation
> > but archs do the things pretty differently although I bet the
> > behaviour could be more unified.
> > 
> > 
> > Frederic Weisbecker (4):
> >   cputime: Generalize CONFIG_VIRT_CPU_ACCOUNTING
> >   sched: Move cputime code to its own file
> >   cputime: Consolidate vtime handling on context switch
> >   s390: Remove leftover account_tick_vtime() header
> > 
> >  arch/Kconfig                           |    3 +
> >  arch/ia64/Kconfig                      |   12 +-
> >  arch/ia64/include/asm/switch_to.h      |    8 -
> >  arch/ia64/kernel/time.c                |    4 +-
> >  arch/powerpc/include/asm/time.h        |    6 -
> >  arch/powerpc/kernel/process.c          |    3 -
> >  arch/powerpc/kernel/time.c             |    6 +
> >  arch/powerpc/platforms/Kconfig.cputype |   16 +-
> >  arch/s390/Kconfig                      |    5 +-
> >  arch/s390/include/asm/switch_to.h      |    4 -
> >  arch/s390/kernel/vtime.c               |    4 +-
> >  include/linux/kernel_stat.h            |    6 +
> >  init/Kconfig                           |   13 +
> >  kernel/sched/Makefile                  |    2 +-
> >  kernel/sched/core.c                    |  552 +-------------------------------
> >  kernel/sched/cputime.c                 |  497 ++++++++++++++++++++++++++++
> >  kernel/sched/sched.h                   |   63 ++++
> >  17 files changed, 600 insertions(+), 604 deletions(-)
> >  create mode 100644 kernel/sched/cputime.c
> > 
> > -- 
> > 1.7.5.4
> > 


