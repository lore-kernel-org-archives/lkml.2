Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044Ab2H3S5Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 14:57:16 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:44484 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656Ab2H3S5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 14:57:13 -0400
X-Originating-IP: 217.70.178.142
X-Originating-IP: 173.246.103.110
Date: Thu, 30 Aug 2012 11:57:05 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 1/5] rcu: Update rcutorture defaults
Message-ID: <20120830185704.GB6749@jtriplet-mobl1>
References: <20120830184448.GA31753@linux.vnet.ibm.com>
 <1346352312-31987-1-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346352312-31987-1-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 11:45:08AM -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paul.mckenney@linaro.org>
> 
> A number of new features have been added to rcutorture over the years, but
> the defaults have not been updated to include them.  This commit therefore
> turns on a couple of them that have proven helpful and trustworthy, namely
> periodic progress reports and testing of NO_HZ.
> 
> Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
>  kernel/rcutorture.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
> index 25b1503..86315d3 100644
> --- a/kernel/rcutorture.c
> +++ b/kernel/rcutorture.c
> @@ -53,10 +53,10 @@ MODULE_AUTHOR("Paul E. McKenney <paulmck@us.ibm.com> and Josh Triplett <josh@fre
>  
>  static int nreaders = -1;	/* # reader threads, defaults to 2*ncpus */
>  static int nfakewriters = 4;	/* # fake writer threads */
> -static int stat_interval;	/* Interval between stats, in seconds. */
> +static int stat_interval = 60;	/* Interval between stats, in seconds. */
>  				/*  Defaults to "only at end of test". */

Need to remove this comment about the default.

>  static bool verbose;		/* Print more debug info. */
> -static bool test_no_idle_hz;	/* Test RCU's support for tickless idle CPUs. */
> +static bool test_no_idle_hz = 1; /* Test RCU support for tickless idle CPUs. */

s/1/true/

>  static int shuffle_interval = 3; /* Interval between shuffles (in sec)*/
>  static int stutter = 5;		/* Start/stop testing interval (in sec) */
>  static int irqreader = 1;	/* RCU readers from irq (timers). */
> -- 
> 1.7.8
> 
