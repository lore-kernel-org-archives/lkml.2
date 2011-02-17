Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711Ab1BQPDa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 10:03:30 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:59377 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995Ab1BQPD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 10:03:26 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=dmEBd0-V5HIA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=QWdmx-PVuGpnauCHs-0A:9 a=yY1OcCWNK6JvUvy6HkdywXyBqQ8A:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 00/10] [GIT PULL][v2.6.39] tracing: updates
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
In-Reply-To: <20110217140442.GA8326@elte.hu>
References: <20110208221612.084294240@goodmis.org>
	 <20110217135023.GA5235@elte.hu>  <20110217140442.GA8326@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 17 Feb 2011 10:03:00 -0500
Message-ID: <1297954980.23343.912.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-17 at 15:04 +0100, Ingo Molnar wrote:
> > > Please pull the latest tip/perf/core tree, which can be found at:
> > > 
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> > > tip/perf/core
> 
> Note that these changes caused a new build failure on arch/m32r:
> 
> /home/mingo/tip/drivers/net/smc91x.h:199:1: warning: this is the location of the previous definition
> /home/mingo/tip/kernel/trace/ring_buffer.c: In function 'rb_reserve_next_event':
> /home/mingo/tip/kernel/trace/ring_buffer.c:2165: error: 'sched_clock_stable' undeclared (first use in this function)
> /home/mingo/tip/kernel/trace/ring_buffer.c:2165: error: (Each undeclared identifier is reported only once
> /home/mingo/tip/kernel/trace/ring_buffer.c:2165: error: for each function it appears in.)
> make[3]: *** [kernel/trace/ring_buffer.o] Error 1
> make[2]: *** [kernel/trace] Error 2

Ah, patch "tracing: Add unstable sched clock note to the warning"
referenced sched_clock_stable without encompassing it with:

#ifdef CONFIG_HAVE_UNSTABLE_SCHED_CLOCK

I wonder if we could instead in linux/sched.h add in the ifndef part:

#define sched_clock_stable 1

That way generic code can still reference this variable without having
to litter the code with #ifdef's.

Thoughts?

-- Steve


