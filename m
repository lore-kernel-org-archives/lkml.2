Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313Ab0KYOAM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 09:00:12 -0500
Received: from tomts43.bellnexxia.net ([209.226.175.110]:38304 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752490Ab0KYOAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 09:00:11 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEABr47UxGHlyW/2dsb2JhbACjCXK/JoVHBIRc
Date: Thu, 25 Nov 2010 08:14:46 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Peter Zijlstra <peterz@infradead.org>
Cc: michael@ellerman.id.au, Steven Rostedt <rostedt@goodmis.org>,
        Jason Baron <jbaron@redhat.com>, mingo@elte.hu, hpa@zytor.com,
        tglx@linutronix.de, andi@firstfloor.org, roland@redhat.com,
        rth@redhat.com, masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        avi@redhat.com, davem@davemloft.net, sam@ravnborg.org,
        ddaney@caviumnetworks.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] jump label: add enabled/disabled state to jump
	label key entries
Message-ID: <20101125131446.GA27350@Krystal>
References: <d03959060763fecdf2523a3f1353e1fc59f8f4a1.1290546539.git.jbaron@redhat.com> <1290586809.2072.424.camel@laptop> <20101124145401.GA2815@redhat.com> <1290611478.2072.482.camel@laptop> <20101124151936.GB2815@redhat.com> <1290612245.2072.486.camel@laptop> <20101124154200.GD2815@redhat.com> <1290613997.30543.529.camel@gandalf.stny.rr.com> <1290652762.18088.4.camel@concordia> <1290667950.2072.545.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1290667950.2072.545.camel@laptop>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 07:59:47 up 231 days, 22:50,  4 users,  load average: 0.60, 0.56,
	0.54
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
[...]
> > What would suit us would be to have an arch callback that is called
> > after all the transforms for a particular jump label key have been made.
> > That way we could optimise the individual patches, and do a sync step at
> > the end, ie. when we want the effect of the patching to be globally
> > visible. 
> 
> I think such a sync-barrier is desired (possibly only on the enable
> path) so we can actually say the tracepoints are on.
> 
> Which would mean sending IPIs to all CPUs and waiting for them to
> acknowledge them. Which, while not quite as expensive as stop_machine,
> its not really cheap either.

Yep, although this can be batched when enabling many tracepoints en
masse. May I suggest that you guys benchmark the two approaches so we
can figure out at how many tracepoints we start hitting a latency wall ?
100, 1000 and 10000 tracepoints should give interesting measurement
points. If we are still below 2 seconds on common hardware when enabling
10000 tracepoints, then the binary search might be fine.

Please note that HPA recommended the use of a perfect hash. It would
make sense, although there seems to be a non-null probability that the
perfect hash cannot be generated. There are techniques that will retry
with a different seed, but the kernel build time then becomes slightly
harder to predict (for very, very rare occurences, so maybe we don't
care).

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
