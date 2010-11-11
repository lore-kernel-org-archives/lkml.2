Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756424Ab0KKTyj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 14:54:39 -0500
Received: from casper.infradead.org ([85.118.1.10]:38910 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755553Ab0KKTyi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 14:54:38 -0500
Subject: Re: [RFC][PATCH 15/22] sched: add traceporints for -deadline tasks
From: Peter Zijlstra <peterz@infradead.org>
To: Raistlin <raistlin@linux.it>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Chris Friesen <cfriesen@nortel.com>, oleg@redhat.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Darren Hart <darren@dvhart.com>, Johan Eker <johan.eker@ericsson.com>,
        "p.faure" <p.faure@akatech.ch>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Claudio Scordino <claudio@evidence.eu.com>,
        michael trimarchi <trimarchi@retis.sssup.it>,
        Fabio Checconi <fabio@gandalf.sssup.it>,
        Tommaso Cucinotta <cucinotta@sssup.it>,
        Juri Lelli <juri.lelli@gmail.com>,
        Nicola Manica <nicola.manica@disi.unitn.it>,
        Luca Abeni <luca.abeni@unitn.it>, Dhaval Giani <dhaval@retis.sssup.it>,
        Harald Gustafsson <hgu1972@gmail.com>,
        paulmck <paulmck@linux.vnet.ibm.com>
In-Reply-To: <1288334334.8661.156.camel@Palantir>
References: <1288333128.8661.137.camel@Palantir>
	 <1288334334.8661.156.camel@Palantir>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 11 Nov 2010 20:54:34 +0100
Message-ID: <1289505274.2084.187.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-29 at 08:38 +0200, Raistlin wrote:
> Add tracepoints for the most notable events related to -deadline
> tasks scheduling (new task arrival, context switch, runtime accounting,
> bandwidth enforcement timer, etc.).
> 
> Signed-off-by: Dario Faggioli <raistlin@linux.it>
> Signed-off-by: Harald Gustafsson <harald.gustafsson@ericsson.com>
> ---
>  include/trace/events/sched.h |  203 +++++++++++++++++++++++++++++++++++++++++-
>  kernel/sched.c               |    2 +
>  kernel/sched_dl.c            |   21 +++++
>  3 files changed, 225 insertions(+), 1 deletions(-)
> 
> diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
> index f633478..03baa17 100644
> --- a/include/trace/events/sched.h
> +++ b/include/trace/events/sched.h
> @@ -304,7 +304,6 @@ DECLARE_EVENT_CLASS(sched_stat_template,
>  			(unsigned long long)__entry->delay)
>  );
>  
> -
>  /*
>   * Tracepoint for accounting wait time (time the task is runnable
>   * but not actually running due to scheduler contention).
> @@ -363,6 +362,208 @@ TRACE_EVENT(sched_stat_runtime,
>  );
>  
>  /*
> + * Tracepoint for task switches involving -deadline tasks:
> + */
> +TRACE_EVENT(sched_switch_dl,


We've already got sched_switch(), better extend that. Same for the next
patch, we already have a migration tracepoint, extend that.

And I recently rejected a fifo push/pull tracepoint patch from Steve
because the migration tracepoint was able to provide the same
information.



