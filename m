Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640Ab0DEVJQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 17:09:16 -0400
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:60427 "EHLO
	relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756412Ab0DEVJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 17:09:10 -0400
X-Originating-IP: 217.70.178.45
X-Originating-IP: 173.50.255.69
Date: Mon, 5 Apr 2010 14:08:34 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, mingo@elte.hu,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Nicholas Miell <nmiell@comcast.net>,
       Linus Torvalds <torvalds@linux-foundation.org>, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       Nick Piggin <npiggin@suse.de>, Chris Friesen <cfriesen@nortel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] introduce sys_membarrier(): process-wide memory
 barrier (v10)
Message-ID: <20100405210833.GA17206@feather>
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
> > > +/*
> > > + * sys_membarrier - issue memory barrier on current process running threads
> > > + * @flags: One of these must be set:
> > > + *         MEMBARRIER_EXPEDITED
> > > + *             Adds some overhead, fast execution (few microseconds)
> > > + *         MEMBARRIER_DELAYED
> > > + *             Low overhead, but slow execution (few milliseconds)
> > > + *
> > > + *         MEMBARRIER_QUERY
> > > + *           This optional flag can be set to query if the kernel supports
> > > + *           a set of flags.
> > > + *
> > > + * return values: Returns -EINVAL if the flags are incorrect. Testing for kernel
> > > + * sys_membarrier support can be done by checking for -ENOSYS return value.
> > > + * Return values >= 0 indicate success. For a given set of flags on a given
> > > + * kernel, this system call will always return the same value. It is therefore
> > > + * correct to check the return value only once at library load, passing the
> > 
> > library load assumes caller is a library?  does the kernel care about that?
> 
> Nope, it doesn't. Will rephrase:
> 
>     ... It is therefore
>  * correct to check the return value only once during a process lifetime,
>  * passing the MEMBARRIER_QUERY flag in addition to only check if the flags are
>  * supported, without performing any synchronization.

Technically you can optimize even more than "process lifetime", since as
you said the results hold "For a given set of flags on a given kernel".
So you could check once and use the results as long as you remain on the
same running system.  (Craziness like live process migration and
checkpoint/restart aside. :) )

- Josh Triplett
