Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759082Ab2EVWXA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 18:23:00 -0400
Received: from www.linutronix.de ([62.245.132.108]:40777 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754212Ab2EVWW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 18:22:59 -0400
Date: Wed, 23 May 2012 00:22:51 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Peter Zijlstra <peterz@infradead.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linaro-sched-sig@lists.linaro.org,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Zen Lin <zen@openhuawei.org>
Subject: Re: [RFC][PATCH 00/32] Nohz cpusets v2 (adaptive tickless kernel)
In-Reply-To: <1337723451.13348.121.camel@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.2.02.1205230020170.3231@ionos>
References: <1332338318-5958-1-git-send-email-fweisbec@gmail.com>   <CAOtvUMf0Zp9C-jT=ymEo6oyxnsgkvSiGDUs5V_56v4Ai2QyBJQ@mail.gmail.com>  <1332861025.16159.236.camel@twins>  <alpine.LFD.2.02.1205222327080.3231@ionos>
 <1337723451.13348.121.camel@gandalf.stny.rr.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 May 2012, Steven Rostedt wrote:

> On Tue, 2012-05-22 at 23:31 +0200, Thomas Gleixner wrote:
> 
> > diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
> > index 590900c..dc8ecc3 100644
> > --- a/arch/x86/kernel/tsc.c
> > +++ b/arch/x86/kernel/tsc.c
> > @@ -109,6 +109,10 @@ static int __init tsc_setup(char *str)
> >  {
> >  	if (!strcmp(str, "reliable"))
> >  		tsc_clocksource_reliable = 1;
> > +	if (!strcmp(str, "perfect")) {
> > +		tsc_clocksource_reliable = 1;
> > +		sched_clock_stable = 1;
> > +	}
> 
> 	else if(!strcmp(str, "pony")) {
> 		tsc_clocksource_reliable = 1;
> 		sched_clock_stable = 1;
> 		tsc_perfect_smp_synchronization = 1;

	else if (!strcmp(str, "real")
	     panic("Can't handle real TSCs!\n");
