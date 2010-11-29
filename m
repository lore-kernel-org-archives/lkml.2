Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786Ab0K2XMA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 18:12:00 -0500
Received: from mail.openrapids.net ([64.15.138.104]:42328 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753306Ab0K2XL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 18:11:59 -0500
Date: Mon, 29 Nov 2010 18:11:56 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix ppc asm typo
Message-ID: <20101129231156.GA648@Krystal>
References: <20101129223022.GA9205@linux.vnet.ibm.com> <20101129225220.GA512@Krystal> <20101129230820.GH2182@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101129230820.GH2182@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 18:10:50 up 6 days,  4:13,  4 users,  load average: 1.05, 1.03,
	1.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> On Mon, Nov 29, 2010 at 05:52:20PM -0500, Mathieu Desnoyers wrote:
> > Hi Paul,
> > 
> > This patch has already been merged by me in the userspace RCU library:
> > 
> > commit e72f49371b233637eaf143265a73c7322d0710fd
> > Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Date:   Wed Sep 23 03:09:59 2009 -0400
> > 
> >     ppc atomic: Fix asm format.
> >     
> >     Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> >     Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> > 
> > It's therefore already integrated in the current releases.
> 
> Hmmm...  I wonder why v0.5.2 got me a compiler error, then...

Maybe you did a make install that got the headers installed system-wide, and the
search order is wrong ? (just a thought)

Did you build 0.5.2 from the tarballs or from the git repo ?

Thanks,

Mathieu

> 
> 							Thanx, Paul
> 
> > Thanks,
> > 
> > Mathieu
> > 
> > 
> > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > Fix ppc asm typo.
> > > 
> > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > 
> > > diff --git a/urcu/uatomic_arch_ppc.h b/urcu/uatomic_arch_ppc.h
> > > index 426b0f2..bb74934 100644
> > > --- a/urcu/uatomic_arch_ppc.h
> > > +++ b/urcu/uatomic_arch_ppc.h
> > > @@ -133,7 +133,7 @@ unsigned long _uatomic_cmpxchg(void *addr, unsigned long old,
> > >  			"bne- 1b\n"	 	/* retry if lost reservation */
> > >  			"isync\n"
> > >  		"2:\n"
> > > -				: "=&r"(old_val),
> > > +				: "=&r"(old_val)
> > >  				: "r"(addr), "r"((unsigned long)_new),
> > >  				  "r"((unsigned long)old)
> > >  				: "memory", "cc");
> > 
> > -- 
> > Mathieu Desnoyers
> > Operating System Efficiency R&D Consultant
> > EfficiOS Inc.
> > http://www.efficios.com

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
