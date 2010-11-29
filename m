Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497Ab0K2Xao (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 18:30:44 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:57368 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751658Ab0K2Xan (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 18:30:43 -0500
Date: Mon, 29 Nov 2010 15:30:37 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix ppc asm typo
Message-ID: <20101129233037.GI2182@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20101129223022.GA9205@linux.vnet.ibm.com>
 <20101129225220.GA512@Krystal>
 <20101129230820.GH2182@linux.vnet.ibm.com>
 <20101129231156.GA648@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101129231156.GA648@Krystal>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 06:11:56PM -0500, Mathieu Desnoyers wrote:
> * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > On Mon, Nov 29, 2010 at 05:52:20PM -0500, Mathieu Desnoyers wrote:
> > > Hi Paul,
> > > 
> > > This patch has already been merged by me in the userspace RCU library:
> > > 
> > > commit e72f49371b233637eaf143265a73c7322d0710fd
> > > Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > Date:   Wed Sep 23 03:09:59 2009 -0400
> > > 
> > >     ppc atomic: Fix asm format.
> > >     
> > >     Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > >     Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> > > 
> > > It's therefore already integrated in the current releases.
> > 
> > Hmmm...  I wonder why v0.5.2 got me a compiler error, then...
> 
> Maybe you did a make install that got the headers installed system-wide, and the
> search order is wrong ? (just a thought)
> 
> Did you build 0.5.2 from the tarballs or from the git repo ?

Good point...  From a tarball that I extracted from the git repo.

I will give it another try.

							Thanx, Paul

> Thanks,
> 
> Mathieu
> 
> > 
> > 							Thanx, Paul
> > 
> > > Thanks,
> > > 
> > > Mathieu
> > > 
> > > 
> > > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > > Fix ppc asm typo.
> > > > 
> > > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > > 
> > > > diff --git a/urcu/uatomic_arch_ppc.h b/urcu/uatomic_arch_ppc.h
> > > > index 426b0f2..bb74934 100644
> > > > --- a/urcu/uatomic_arch_ppc.h
> > > > +++ b/urcu/uatomic_arch_ppc.h
> > > > @@ -133,7 +133,7 @@ unsigned long _uatomic_cmpxchg(void *addr, unsigned long old,
> > > >  			"bne- 1b\n"	 	/* retry if lost reservation */
> > > >  			"isync\n"
> > > >  		"2:\n"
> > > > -				: "=&r"(old_val),
> > > > +				: "=&r"(old_val)
> > > >  				: "r"(addr), "r"((unsigned long)_new),
> > > >  				  "r"((unsigned long)old)
> > > >  				: "memory", "cc");
> > > 
> > > -- 
> > > Mathieu Desnoyers
> > > Operating System Efficiency R&D Consultant
> > > EfficiOS Inc.
> > > http://www.efficios.com
> 
> -- 
> Mathieu Desnoyers
> Operating System Efficiency R&D Consultant
> EfficiOS Inc.
> http://www.efficios.com
