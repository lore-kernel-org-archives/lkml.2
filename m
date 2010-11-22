Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751570Ab0KVHVj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 02:21:39 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:45753 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab0KVHVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 02:21:38 -0500
Date: Mon, 22 Nov 2010 12:51:29 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        Shailabh Nagar <nagar1234@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        John stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [patch 0/4] taskstats: Improve cumulative time accounting
Message-ID: <20101122072129.GK12043@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20101119201108.269346583@linux.vnet.ibm.com>
 <1290197955.2109.1617.camel@laptop>
 <20101120151711.GA3019@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20101120151711.GA3019@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2010-11-20 16:17:11]:

> On 11/19, Peter Zijlstra wrote:
> >
> > On Fri, 2010-11-19 at 21:11 +0100, Michael Holzheu wrote:
> > > Due to POSIX POSIX.1-2001, the CPU time of processes is not accounted
> > > to the cumulative time of the parents, if the parents ignore SIGCHLD
> > > or have set SA_NOCLDWAIT. This behaviour has the major drawback that
> > > it is not possible to calculate all consumed CPU time of a system by
> > > looking at the current tasks. CPU time can be lost.
> > >
> > > To solve this problem, this patch set duplicates the cumulative accounting
> > > data in the signal_struct. In the second set (cdata_acct) the complete
> > > cumulative resource counters are stored. The new cumulative CPU time (utime
> > > and stime) is then exported via the taskstats interface.
> >
> > Maybe this has been treated earlier in the threads and I missed it, but
> > the obvious solution doesn't get mentioned:
> 
> IIRC, the first version did this.
> 
> And it was me who spoiled this approach. But! only because I wasn't sure
> this user-visible change is acceptable, and because there was some
> misunderstanding. See http://marc.info/?l=linux-kernel&m=128552495203050&w=2
> 
> But,
> 
> > What would break if we
> 
> say, any test-case which does getrusage() after fork() with ignored
> SIGCHLD/SA_NOCLDWAIT?.
> 
> > violate this silly POSIX rule and account time of
> > childs regardless of SIGCHLD/SA_NOCLDWAIT?
> 
> +1.
> 
> Personally, I'd certainly prefer this way, because I don't care about
> POSIX at all ;)
> 
> 
> Still. Once again, this breaks the current rules, and we never do
> this without strong reason.
> 
> I think we should ask Roland. If he thinks this is OK, I'd certainly
> agree.
>

The Linux man page states

In Linux kernel versions before 2.6.9, if the disposition of SIGCHLD
is set to SIG_IGN then the resource usages of child processes are
automatically included in the value returned by RUSAGE_CHILDREN,
although POSIX.1-2001 explicitly prohibits this. This nonconformance
is rectified in Linux 2.6.9 and later. 



-- 
	Three Cheers,
	Balbir
