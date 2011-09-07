Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264Ab1IGVp3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 17:45:29 -0400
Received: from mail-vw0-f43.google.com ([209.85.212.43]:47595 "EHLO
	mail-vw0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757203Ab1IGVp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 17:45:28 -0400
X-Greylist: delayed 337 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Sep 2011 17:45:28 EDT
Date: Wed, 7 Sep 2011 23:39:41 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        Mike Frysinger <vapier@gentoo.org>, Ralf Baechle <ralf@linux-mips.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Russell King <linux@arm.linux.org.uk>,
        Paul Mackerras <paulus@samba.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 1/4] nohz: Split extended quiescent state handling from
 nohz switch
Message-ID: <20110907213936.GA6222@somewhere>
References: <1313861452-24783-1-git-send-email-fweisbec@gmail.com>
 <1313861452-24783-2-git-send-email-fweisbec@gmail.com>
 <20110904233643.GN2411@linux.vnet.ibm.com>
 <20110907142233.GA11570@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110907142233.GA11570@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 07, 2011 at 07:22:33AM -0700, Paul E. McKenney wrote:
> On Sun, Sep 04, 2011 at 04:36:43PM -0700, Paul E. McKenney wrote:
> > On Sat, Aug 20, 2011 at 07:30:49PM +0200, Frederic Weisbecker wrote:
> > > It is assumed that rcu won't be used once we switch to tickless
> > > mode and until we restart the tick. However this is not always
> > > true, as in x86-64 where we dereference the idle notifiers after
> > > the tick is stopped.
> > > 
> > > To prepare for fixing this, split the tickless mode switching and
> > > RCU extended quiescent state logics.
> > > Make tick_nohz_stop/restart_sched_tick() RCU agnostic but provide
> > > a new pair of APIs tick_nohz_enter/exit_idle() that keep the
> > > old behaviour by handling both the nohz mode and RCU extended
> > > quiescent states, then convert every archs to use these.
> > > 
> > > Archs that want to switch to RCU extended QS to some custom points
> > > can do it later by changing the parameter in tick_nohz_enter,exit_idle()
> > > to false and call rcu_enter,exit() separately.
> > 
> > This approach looks quite good to me!  A few comments below.
> 
> But I get RCU stall warnings when running it on powerpc on top of
> the patch set at:
> 
> 	https://lkml.org/lkml/2011/9/7/64
> 
> At first glance, it appears that CPUs are entering dyntick-idle
> mode without RCU being informed.  Any thoughts on diagnostics?
> 
> 							Thanx, Paul

Nothing looks wrong to me looking at the powerpc part in my patchset.
But I have no machine to test anything other than x86.

That said I can't even fetch your tree to test on x86 because of the
kernel.org's desolation.
