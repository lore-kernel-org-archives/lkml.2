Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562Ab0DEUke (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 16:40:34 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:58949 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756420Ab0DEUka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 16:40:30 -0400
Date: Mon, 5 Apr 2010 13:40:21 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, mingo@elte.hu,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Nicholas Miell <nmiell@comcast.net>,
       Linus Torvalds <torvalds@linux-foundation.org>, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       Nick Piggin <npiggin@suse.de>, Chris Friesen <cfriesen@nortel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] introduce sys_membarrier(): process-wide memory
	barrier (v10)
Message-ID: <20100405204021.GH2525@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100405175736.GA12656@Krystal>
 <20100405113837.e475db7b.randy.dunlap@oracle.com>
 <20100405191057.GB13309@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100405191057.GB13309@Krystal>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 05, 2010 at 03:10:57PM -0400, Mathieu Desnoyers wrote:
> * Randy Dunlap (randy.dunlap@oracle.com) wrote:
> > On Mon, 5 Apr 2010 13:57:37 -0400 Mathieu Desnoyers wrote:

[ . . . ]

> > > +#else /* #ifdef CONFIG_SMP */
> > 
> > I don't know that we have a known convention for that, but I would use:
> > 
> > #else /* not CONFIG_SMP */
> > 
> > or
> > 
> > #else /* !CONFIG_SMP */
> > 
> > > +
> > > +SYSCALL_DEFINE1(membarrier, unsigned int, flags)
> > > +{
> > > +	return 0;
> > > +}
> > > +
> > > +#endif /* #else #ifdef CONFIG_SMP */
> > 
> > and:
> > 
> > #endif /* CONFIG_SMP */
> > 
> > The "#else #ifdef" is both ugly and too wordy IMO.

The extra words make it very clear that we are in at the end of the #else
clause of a #ifdef with the given condition.  With "#endif /* CONFIG_SMP
*/", is the immediately preceding code compiled under CONFIG_SMP or
!CONFIG_SMP?  You have to dig back and see whether or not there is a
#else clause.

But there is no accounting for taste.  ;-)

							Thanx, Paul

> OK. I merely followed the coding style of the code added to sched.c by Paul
> McKenney. But you are right, the rest of sched.c does as you say:
> 
> #else /* !CONFIG_SMP */
> 
> #endif /* CONFIG_SMP */
> 
> Will fix.
> 
> Thanks !
> 
> Mathieu
> 
> > 
> > > +
> > >  #ifndef CONFIG_SMP
> > >  
> > >  int rcu_expedited_torture_stats(char *page)
> > 
> > 
> > ---
> > ~Randy
> > 
> 
> -- 
> Mathieu Desnoyers
> Operating System Efficiency R&D Consultant
> EfficiOS Inc.
> http://www.efficios.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
