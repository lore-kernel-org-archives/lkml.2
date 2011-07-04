Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757552Ab1GDNiA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 09:38:00 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:45726 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823Ab1GDNh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 09:37:59 -0400
Date: Mon, 4 Jul 2011 15:37:54 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@lists.ozlabs.org,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 4/6] hw_breakpoints: Breakpoints arch ability don't need
 perf events
Message-ID: <20110704133752.GC5551@somewhere>
References: <1306273947-8410-1-git-send-email-fweisbec@gmail.com>
 <1306273947-8410-5-git-send-email-fweisbec@gmail.com>
 <20110704133223.GB2963@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110704133223.GB2963@in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 04, 2011 at 07:02:23PM +0530, K.Prasad wrote:
> On Tue, May 24, 2011 at 11:52:25PM +0200, Frederic Weisbecker wrote:
> > The breakpoint support ability in an arch is not related
> > to the fact perf events is built or not. HAVE_HW_BREAKPOINT
> > only shows an ability so this dependency makes no sense
> > anymore. Archs that select HAVE_HW_BREAKPOINT already
> > ensure that perf event is built.
> > 
> > Remove that dependency.
> > 
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: Will Deacon <will.deacon@arm.com>
> > Cc: Prasad <prasad@linux.vnet.ibm.com>
> > Cc: Paul Mundt <lethal@linux-sh.org>
> > ---
> >  arch/Kconfig |    1 -
> >  1 files changed, 0 insertions(+), 1 deletions(-)
> > 
> > diff --git a/arch/Kconfig b/arch/Kconfig
> > index f78c2be..ce4be89 100644
> > --- a/arch/Kconfig
> > +++ b/arch/Kconfig
> > @@ -149,7 +149,6 @@ config HAVE_DEFAULT_NO_SPIN_MUTEXES
> > 
> >  config HAVE_HW_BREAKPOINT
> >  	bool
> > -	depends on PERF_EVENTS
> > 
> >  config HAVE_MIXED_BREAKPOINTS_REGS
> >  	bool
> > -- 
> 
> Just a thought you might want to consider...
> 
> The need to keep the ability (HAVE_HW_BREAKPOINT) and the user-choice to
> enable hardware breakpoints (through HW_BREAKPOINT) in separate config
> options isn't very clear to me (and is a bit confusing with very similar
> names).
> 
> Why not make HAVE_HW_BREAKPOINT selectable by the user (which in turn
> would turn on PERF_EVENTS) for a given architecture?

But then how kconfig knows if the allows that? You need to know if the
arch has the ability to support breakpoints.

This is a commin pattern in Linux Kconfig. Things are often seperated between
ability (some constant value provided by the arch) and the user choice that
depends on that ability.
The advantage of doing this is that you can centralize the generic dependencies,
help menu, etc... into a single place.
 
> Thanks,
> K.Prasad
> 
