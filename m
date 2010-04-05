Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680Ab0DEVkI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 17:40:08 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:49453 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756439Ab0DEVkA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 17:40:00 -0400
Date: Mon, 5 Apr 2010 14:39:53 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, mingo@elte.hu,
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
Message-ID: <20100405213953.GJ2525@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100405175736.GA12656@Krystal>
 <20100405113837.e475db7b.randy.dunlap@oracle.com>
 <20100405191057.GB13309@Krystal>
 <20100405204021.GH2525@linux.vnet.ibm.com>
 <4BBA46DB.9060106@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BBA46DB.9060106@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 05, 2010 at 01:23:55PM -0700, Randy Dunlap wrote:
> Paul E. McKenney wrote:
> > On Mon, Apr 05, 2010 at 03:10:57PM -0400, Mathieu Desnoyers wrote:
> >> * Randy Dunlap (randy.dunlap@oracle.com) wrote:
> >>> On Mon, 5 Apr 2010 13:57:37 -0400 Mathieu Desnoyers wrote:
> > 
> > [ . . . ]
> > 
> >>>> +#else /* #ifdef CONFIG_SMP */
> >>> I don't know that we have a known convention for that, but I would use:
> >>>
> >>> #else /* not CONFIG_SMP */
> >>>
> >>> or
> >>>
> >>> #else /* !CONFIG_SMP */
> >>>
> >>>> +
> >>>> +SYSCALL_DEFINE1(membarrier, unsigned int, flags)
> >>>> +{
> >>>> +	return 0;
> >>>> +}
> >>>> +
> >>>> +#endif /* #else #ifdef CONFIG_SMP */
> 
> or just:
> 
> #endif /* #else #ifdef CONFIG_SMP : tell the reader that the #else part of the #ifdef CONFIG_SMP just ended */
> 
> ad nauseum.

You lost me on this one.

> >>> and:
> >>>
> >>> #endif /* CONFIG_SMP */
> >>>
> >>> The "#else #ifdef" is both ugly and too wordy IMO.
> > 
> > The extra words make it very clear that we are in at the end of the #else
> > clause of a #ifdef with the given condition.  With "#endif /* CONFIG_SMP
> > */", is the immediately preceding code compiled under CONFIG_SMP or
> > !CONFIG_SMP?  You have to dig back and see whether or not there is a
> > #else clause.
> > 
> > But there is no accounting for taste.  ;-)
> 
> IYHO.

Indeed, in both directions.

							Thanx, Paul
