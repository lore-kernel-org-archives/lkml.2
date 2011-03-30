Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575Ab1C3XOU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 19:14:20 -0400
Received: from www.linutronix.de ([62.245.132.108]:36199 "EHLO linutronix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756514Ab1C3XOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 19:14:18 -0400
Date: Thu, 31 Mar 2011 01:14:12 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tony Lindgren <tony@atomide.com>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nico@fluxnic.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Brown <davidb@codeaurora.org>, linux-omap@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, linux-arm-kernel@lists.infradead.org
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
In-Reply-To: <20110330224752.GN18334@atomide.com>
Message-ID: <alpine.LFD.2.00.1103310059531.22418@localhost6.localdomain6>
References: <20110317183048.GW7258@atomide.com> <AANLkTimWbb5DWiiCW821H6pRicbk1fS3PYcnGyUMznvM@mail.gmail.com> <20110318101512.GA15375@n2100.arm.linux.org.uk> <201103301906.42429.arnd@arndb.de> <AANLkTim578-kwM14SJd06RW_QiC4WVCmFuG+ASgGC4sq@mail.gmail.com>
 <alpine.LFD.2.00.1103302155270.22418@localhost6.localdomain6> <20110330215434.GI18334@atomide.com> <20110330223807.GP2255@linux.vnet.ibm.com> <20110330224752.GN18334@atomide.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Mar 2011, Tony Lindgren wrote:

> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> [110330 15:35]:
> > On Wed, Mar 30, 2011 at 02:54:35PM -0700, Tony Lindgren wrote:
> > > * Thomas Gleixner <tglx@linutronix.de> [110330 14:07]:
> > > > 
> > > > So one person will be not enough, that needs to be a whole team of
> > > > experienced people in the very near future to deal with the massive
> > > > tsunami of crap which is targeted at mainline. If we fail to set that
> > > > up, then we run into a very ugly maintainability issue in no time.
> > > 
> > > One thing that will help here and distribute the load is to move
> > > more things under drivers/ as then we have more maintainers looking
> > > at the code.
> > 
> > In many cases, the ARM SoC vendors will want their people producing the
> > code, so although moving things to drivers might be a good thing to do,
> > it won't really increase the number of people involved.  Plus the move
> > to the drivers subtree would be a problem for devices with tight ties
> > to the board or SoC.
> > 
> > There is work on pushing towards common code, but there is a lot of code
> > and this will take time and a lot of work.
> 
> I agree on the common code part, then even drivers with tight
> ties to board or SoC become just generic drivers that are easy
> to review.

You wish. There is an already existing problem that the identical IP
cores of peripheral crap are reused accross architectures. And of
course because it is a different architecture we have two different
drivers with different issues.

See: http://marc.info/?l=linux-kernel&m=130041568128164

We already fail to detect this on the driver level, so please answer
the question I asked before: How do you spread the load and scale with
the amount of shite which is coming in?

The above example is probably not the only one in tree and we will see
lots of unnoticed instances of drivers dealing with minimal different
versions of the same IP crappola in the near future simply because the
vendors claim that their stuff is unique and only works with their
particular instance of hackery unless we have enough capable people to
look over this. Whether it's in arch/ or drivers/ it does not
matter. We are simply not prepared to the amount of crap coming in.

Thanks,

	tglx

