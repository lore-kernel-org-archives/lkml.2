Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758110Ab2EYR4N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 13:56:13 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:35581 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124Ab2EYR4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 13:56:11 -0400
Date: Fri, 25 May 2012 10:55:44 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Dario Faggioli <raistlin@linux.it>, Colin Cross <ccross@android.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH] sched/rt: fix SCHED_RR across cgroups
Message-ID: <20120525175544.GF2396@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1337229266-15798-1-git-send-email-ccross@android.com>
 <1337331395.573.3.camel@twins>
 <CAMbhsRQYeM8b167HVge11kVtniWKEukN+xGMvcMDf5+UOOc8_w@mail.gmail.com>
 <1337366237.573.106.camel@twins>
 <CAMbhsRRnweLW_J+aBUsSbBh_Rp-PzVFap1FaRV1t9G0o9fZZAw@mail.gmail.com>
 <1337433062.7075.9.camel@Abyss>
 <CAMbhsRQYgOQA7NB-mdMDi8GxtTaZDQhED2J2X9YmyiYjAzXx4w@mail.gmail.com>
 <1337779944.27368.94.camel@Solace>
 <1337946769.9783.189.camel@laptop>
 <1337951526.13348.249.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337951526.13348.249.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12052517-1780-0000-0000-000005E36B36
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000277; HX=3.00000188; KW=3.00000007;
 PH=3.00000001; SC=3.00000002; SDB=6.00142304; UDB=6.00032816; UTC=2012-05-25
 17:56:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2012 at 09:12:06AM -0400, Steven Rostedt wrote:
> On Fri, 2012-05-25 at 13:52 +0200, Peter Zijlstra wrote:
> > On Wed, 2012-05-23 at 15:32 +0200, Dario Faggioli wrote:
> > > Again, I really think it is the intended behaviour, and yes, real-time
> > > group scheduling "breaks" the POSIX specification of the SCHED_{FIFO,RR}
> > > policies intentionally (and _proudly_, as Peter would say it, am I
> > > wrong? :-P). 
> > 
> > No, cgroups are well outside of POSIX ;-) as is SMP in fact.
> 
> That's because the POSIX standards committee is still struggling to come
> up with standardized SMP calls to handle NR_CPUS = 0

;-) ;-) ;-)

> Isn't Paul on that committee? ;-)

I have met with them occasionally, but have spent most of my time on
the C/C++ committees.  I didn't try sounding them out on NR_CPUS=0,
partly because they were choking pretty hard on NR_CPUS=4096.

At least part of the problem is that every OS out there has different
SMP feature, so the only way it would be possible to get this sort of
thing through the committee would be to invent something that was
roughly equally incompatible with everyone.

However, there are some SMP features standardized by various random
committees and aggregated by The Open Group, including:

o	The pthread_mutex_lock() API
o	pthread_getspecific() and pthread_setspecific()
o	pthread_getconcurrency() and pthread_setconcurrency()

But yes, even the aggregated standard is quite limiting.

							Thanx, Paul

