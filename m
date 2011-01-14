Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553Ab1ANJcG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 04:32:06 -0500
Received: from www.tglx.de ([62.245.132.106]:45481 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152Ab1ANJb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 04:31:58 -0500
Date: Fri, 14 Jan 2011 10:31:19 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Richard Cochran <richardcochran@gmail.com>
cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Christoph Lameter <cl@linux.com>,
        David Miller <davem@davemloft.net>, John Stultz <johnstul@us.ibm.com>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>
Subject: Re: [PATCH V9 08/13] posix clocks: cleanup the CLOCK_DISPTACH
 macro
In-Reply-To: <20110114074837.GA8077@riccoc20.at.omicron.at>
Message-ID: <alpine.LFD.2.00.1101141030400.2678@localhost6.localdomain6>
References: <cover.1294917347.git.richard.cochran@omicron.at> <90b2beef441615d01c93fcad029c44af4e505c5f.1294917348.git.richard.cochran@omicron.at> <alpine.LFD.2.00.1101131745400.2678@localhost6.localdomain6> <20110114074837.GA8077@riccoc20.at.omicron.at>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Jan 2011, Richard Cochran wrote:
> On Thu, Jan 13, 2011 at 06:03:24PM +0100, Thomas Gleixner wrote:
> > On Thu, 13 Jan 2011, Richard Cochran wrote:
> > >  int posix_cpu_clock_getres(const clockid_t which_clock, struct timespec *ts);
> > >  int posix_cpu_clock_get(const clockid_t which_clock, struct timespec *ts);
> > > -int posix_cpu_clock_set(const clockid_t which_clock, const struct timespec *ts);
> > > +int posix_cpu_clock_set(const clockid_t which_clock, struct timespec *ts);
> > 
> > Shouldn't we change the clock_set function to have *ts const in all places ?
> 
> Yes, your are right.
> 
> > > @@ -293,6 +261,11 @@ static __init int init_posix_timers(void)
> > >  		.clock_adj = do_posix_clock_noadjtime,
> > >  		.timer_create = no_timer_create,
> > >  		.nsleep = no_nsleep,
> > > +		/* defaults: */
> > > +		.nsleep_restart	= common_nsleep_restart,
> > > +		.timer_del	= common_timer_del,
> > > +		.timer_get	= common_timer_get,
> > > +		.timer_set	= common_timer_set,
> > 
> > Hmm, we do not need to set functional entries for clocks which neither
> > implement timer_create nor nsleep.
> 
> I know, but I wanted to be really pendantic about what the previous
> code was, and what the new code does.
> 
> Before: By leaving the k_clock function pointer NULL, the clock
>         selects common_xyz. This common function may or may make
>         sense for that clock.
> 
> After:  By leaving the k_clock function pointer NULL, the clock will
>         return EINVAL for that syscall.
> 
> Maybe it would be better to leave the cleaning up of the common crud
> as a follow up patch. What do you think?

Fair enough.
