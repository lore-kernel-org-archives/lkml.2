Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829Ab2H3Vfu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 17:35:50 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:39716 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517Ab2H3Vft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 17:35:49 -0400
Date: Thu, 30 Aug 2012 14:35:36 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 1/5] rcu: Update rcutorture defaults
Message-ID: <20120830213536.GI30381@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120830184448.GA31753@linux.vnet.ibm.com>
 <1346352312-31987-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20120830185704.GB6749@jtriplet-mobl1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120830185704.GB6749@jtriplet-mobl1>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12083021-4242-0000-0000-000002BA03B7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 11:57:05AM -0700, Josh Triplett wrote:
> On Thu, Aug 30, 2012 at 11:45:08AM -0700, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paul.mckenney@linaro.org>
> > 
> > A number of new features have been added to rcutorture over the years, but
> > the defaults have not been updated to include them.  This commit therefore
> > turns on a couple of them that have proven helpful and trustworthy, namely
> > periodic progress reports and testing of NO_HZ.
> > 
> > Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > ---
> >  kernel/rcutorture.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
> > index 25b1503..86315d3 100644
> > --- a/kernel/rcutorture.c
> > +++ b/kernel/rcutorture.c
> > @@ -53,10 +53,10 @@ MODULE_AUTHOR("Paul E. McKenney <paulmck@us.ibm.com> and Josh Triplett <josh@fre
> >  
> >  static int nreaders = -1;	/* # reader threads, defaults to 2*ncpus */
> >  static int nfakewriters = 4;	/* # fake writer threads */
> > -static int stat_interval;	/* Interval between stats, in seconds. */
> > +static int stat_interval = 60;	/* Interval between stats, in seconds. */
> >  				/*  Defaults to "only at end of test". */
> 
> Need to remove this comment about the default.

Good catch!  I have replaced it with "Zero means "only at end of test".

> >  static bool verbose;		/* Print more debug info. */
> > -static bool test_no_idle_hz;	/* Test RCU's support for tickless idle CPUs. */
> > +static bool test_no_idle_hz = 1; /* Test RCU support for tickless idle CPUs. */
> 
> s/1/true/

Good point, fixed.

Thank you for looking this over!

							Thanx, Paul

> >  static int shuffle_interval = 3; /* Interval between shuffles (in sec)*/
> >  static int stutter = 5;		/* Start/stop testing interval (in sec) */
> >  static int irqreader = 1;	/* RCU readers from irq (timers). */
> > -- 
> > 1.7.8
> > 
> 

