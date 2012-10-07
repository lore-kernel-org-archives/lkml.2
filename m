Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab2JGQaq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 12:30:46 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:48792 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751593Ab2JGQaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 12:30:39 -0400
Date: Sun, 7 Oct 2012 09:30:29 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Dave Airlie <airlied@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Kees Cook <keescook@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] make CONFIG_EXPERIMENTAL invisible and default
Message-ID: <20121007163029.GG2485@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20121003161702.GA22008@kroah.com>
 <20121003164712.GF2527@linux.vnet.ibm.com>
 <CAGXu5jJhEpdwCqYc0hWs504snMZg9FMygUjLwRUSyaKGAfXb5Q@mail.gmail.com>
 <20121003200314.GR2527@linux.vnet.ibm.com>
 <20121004015539.GA19958@srcf.ucam.org>
 <20121004143150.GA2464@linux.vnet.ibm.com>
 <20121005164642.GA10711@linux.vnet.ibm.com>
 <CAFTL4hy434CQhT8WTvKmNzkO4k_isfKQOrCjgfYFYfMVgS7QDw@mail.gmail.com>
 <20121007014447.GB2485@linux.vnet.ibm.com>
 <CAPM=9tzoaZ3AWzA6MFnKAMzFgrarWW=JTLHSTzGBf0hoPQ_RmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPM=9tzoaZ3AWzA6MFnKAMzFgrarWW=JTLHSTzGBf0hoPQ_RmQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12100716-6078-0000-0000-00001068A113
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 07, 2012 at 12:33:48PM +1000, Dave Airlie wrote:
> >>
> >> Really I would much prefer to add some "Don't enable it unless you're
> >> doing kernel hacking.
> >> If unsure say N" text in the Kconfig.
> >>
> >> I can understand that distros want to cover as much feature as they
> >> can for their users. But
> >> should it be an excuse for not reading outstanding warnings in Kconfig
> >> help text?
> >
> > In my experience, they do not read these warnings carefully.  :-(
> > Or perhaps they do read them, but react to them by running the code
> > through some test suite rather than by putting full faith in the
> > warning.
> 
> I think Kconfig is mostly what distro would like to use the thing is
> the Kconfig text needs to be there upfront when its merged, not two
> months later, since then it too late for a distro to notice.
> 
> I'd bet most distros would read the warnings, but in a lot of cases
> the warning don't exist until its too late.

In the case of CONFIG_RCU_USER_QS you are quite right, the warning
should have been there from the beginning and was not.  I suppose you
could argue that the warning was not sufficiently harsh in the case of
CONFIG_RCU_FAST_NO_HZ, but either way it did get ignored:

config RCU_FAST_NO_HZ
	bool "Accelerate last non-dyntick-idle CPU's grace periods"
	depends on TREE_RCU && NO_HZ && SMP
	default n
	help
	  This option causes RCU to attempt to accelerate grace periods
	  in order to allow the final CPU to enter dynticks-idle state
	  more quickly.  On the other hand, this option increases the
	  overhead of the dynticks-idle checking, particularly on systems
	  with large numbers of CPUs.

	  Say Y if energy efficiency is critically important, particularly
	  	if you have relatively few CPUs.

	  Say N if you are unsure.

I have since made RCU_FAST_NO_HZ more generally applicable, so it is
OK to enable now.  I suppose I need to update the help text...

Either way, however, it would be good to tag an experimental config
option at boot time.  Even if the help text gives very clear warnings,
it would be good to have the option defend itself against the occasional
inevitable typo.

							Thanx, Paul

> Dave.
> 
> 
> >> Or may be add some specific warning yeah. I wouldn't mind much.
> >
> > We have some weeks to think about it -- I cannot see pushing a
> > warning in as a regression.  ;-)
> >
> >                                                         Thanx, Paul
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 

