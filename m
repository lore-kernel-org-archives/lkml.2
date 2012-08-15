Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741Ab2HOHMb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 03:12:31 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:56862 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751288Ab2HOHMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 03:12:30 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19EV+8etp1Eq+RTDoQs0y67jG+1rbMkGfiOGlj07g
	E/VIp7vLTLnAOt
Message-ID: <1345014740.4515.104.camel@marge.simpson.net>
Subject: Re: [PATCH] sched: Support compiling out real-time scheduling with
 REALTIME_SCHED.
From: Mike Galbraith <efault@gmx.de>
To: Trevor Brandt <tjbrandt@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>, Eric Paris <eparis@redhat.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Glauber Costa <glommer@parallels.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, team-fjord@googlegroups.com
Date: Wed, 15 Aug 2012 09:12:20 +0200
In-Reply-To: <1344977423-28900-1-git-send-email-tjbrandt@gmail.com>
References: <y> <1344977423-28900-1-git-send-email-tjbrandt@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-08-14 at 13:50 -0700, Trevor Brandt wrote:

> diff --git a/init/Kconfig b/init/Kconfig
> index 3f42cd6..768dc76 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -27,6 +27,13 @@ config IRQ_WORK
>  	bool
>  	depends on HAVE_IRQ_WORK
>  
> +config REALTIME_SCHED
> +	bool "Realtime Scheduler" if EXPERT
> +	default y
> +	help
> +	  This option enables support for the realtime scheduler and the
> +	  corresponding scheduling classes SCHED_FIFO and SCHED_RR.
> +
>  menu "General setup"
>  
>  config EXPERIMENTAL

If you inverted that, it could be a proper default n new feature [1].

However, if weight loss is the goal, why not go whole hog, and create
sched/thin.c containing no lard... or just integrate an existing thin
scheduler as a config option?  Whole body replacement is a very radical
diet, but somehow seems less so than chopping off fingers and toes.

-Mike

(that SMP could select to greatly simplify RT)

