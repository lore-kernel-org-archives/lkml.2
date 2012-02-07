Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480Ab2BGPjm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 10:39:42 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:49866 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302Ab2BGPjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 10:39:41 -0500
Date: Tue, 7 Feb 2012 07:37:10 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rob Herring <robherring2@gmail.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Kevin Hilman <khilman@ti.com>, Josh Triplett <josh@joshtriplett.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH 0/3][RFC] tracing/rcu: Add _rcuidle() tracepoint to
 handle rcu_idle_exit() tracepoints
Message-ID: <20120207153710.GQ5941@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120207145653.829892056@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120207145653.829892056@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020715-6148-0000-0000-0000033B1C8D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 07, 2012 at 09:56:53AM -0500, Steven Rostedt wrote:
> This is an RFC patch set for what I plan on pushing out to handle
> the tracepoints that are called from within rcu_idle_exit() sections.
> 
> The first patch is the tracepoint infrastructure,
> the second is the changes in x86
> the third is the changes in the cpuidle driver.
> 
> I see there's use cases in the arm arch, but as that is in flux, I'll
> let the arm folks deal with those.

Please note that the __rcudle() tracepoints depend on patch #45 from
my series (https://lkml.org/lkml/2012/2/3/471), though only for code
containing tracepoints that are called both from idle and non-idle.
I believe that the tracepoints in this patch series are only invoked
from idle, so should be no problem.

							Thanx, Paul

> -- Steve
> 
> 
> Steven Rostedt (3):
>       tracing/rcu: Add trace_##name##__rcuidle() static tracepoint for inside rcu_idle_exit() sections
>       x86/tracing: Denote the power and cpuidle tracepoints as _rcuidle()
>       cpuidle/tracing: Denote the tracepoints as being in rcu_idle_exit() section
> 
> ----
>  arch/x86/kernel/process.c  |   24 ++++++++++++------------
>  drivers/cpuidle/cpuidle.c  |    8 ++++----
>  include/linux/tracepoint.h |   20 ++++++++++++++++----
>  3 files changed, 32 insertions(+), 20 deletions(-)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

