Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731Ab0LIRAm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 12:00:42 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:37285 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754219Ab0LIRAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 12:00:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hbP/DYtoWmA+jU1LdQZ+eplIkk372Zyckb4jKTfv1ylzdTPxFS8uOU6WOMCV8iUmci
         tjKcbV4/OjqGcjF8BfTKwJ0vY6GuqiJkKxhj6HoEbSUS8bmHFtCbGixVxSLGZOGU2Ayh
         EzSKpUX99kOpl95KuX2fz9ySkPAMhkdkyNYr0=
Date: Thu, 9 Dec 2010 18:00:32 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Li Zefan <lizf@cn.fujitsu.com>,
        William Cohen <wcohen@redhat.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Jason Baron <jbaron@redhat.com>,
        Mel Gorman <mel@csn.ul.ie>,
        Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
        Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi@redhat.com>,
        Gleb Natapov <gleb@redhat.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Masami Hiramatsu <mhiramat@redhat.com>,
        Josh Stone <jistone@redhat.com>,
        Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
        Thomas Gleixner <tglx@linutronix.de>, Zhaolei <zhaolei@cn.fujitsu.com>,
        Anton Blanchard <anton@samba.org>
Subject: Re: [RFC PATCH] ftrace trace event: introduce assignment macros
Message-ID: <20101209170027.GF1712@nowhere>
References: <20101209162210.GB6769@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101209162210.GB6769@Krystal>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 09, 2010 at 11:22:11AM -0500, Mathieu Desnoyers wrote:
> This patch proposes encapsulation of the raw assignments within TP_fast_assign()
> by introducing tp_assign() and tp_memcpy() macros. This will allow us to:
> 
> - generically filter from input fields,
> - redefine the field write primitives.
> 
> The current macros map directly to the old code. I changed the documentation in
> tracepoint.txt to reflect these new primitives, but all TRACE_EVENT() users
> should gradually update their code to use these macro wrappers rather than raw
> "=" assignments or mempcy() calls.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> CC: Steven Rostedt <rostedt@goodmis.org>
> CC: Frederic Weisbecker <fweisbec@gmail.com>
> CC: Ingo Molnar <mingo@redhat.com>
> CC: Li Zefan <lizf@cn.fujitsu.com>
> CC: William Cohen <wcohen@redhat.com>
> CC: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
> CC: Theodore Ts'o <tytso@mit.edu>
> CC: Jason Baron <jbaron@redhat.com>
> CC: Mel Gorman <mel@csn.ul.ie>
> CC: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
> CC: Marcelo Tosatti <mtosatti@redhat.com>
> CC: Avi Kivity <avi@redhat.com>
> CC: Gleb Natapov <gleb@redhat.com>
> CC: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
> CC: Neil Horman <nhorman@tuxdriver.com>
> CC: Arjan van de Ven <arjan@linux.intel.com>
> CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
> CC: Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>
> CC: Martin K. Petersen <martin.petersen@oracle.com>
> CC: Oleg Nesterov <oleg@redhat.com>
> CC: Masami Hiramatsu <mhiramat@redhat.com>
> CC: Josh Stone <jistone@redhat.com>
> CC: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Zhaolei <zhaolei@cn.fujitsu.com>
> CC: Anton Blanchard <anton@samba.org>
> ---
>  include/linux/tracepoint.h |   12 ++++++------
>  include/trace/ftrace.h     |    6 ++++++
>  2 files changed, 12 insertions(+), 6 deletions(-)
> 
> Index: linux-2.6-lttng.git/include/trace/ftrace.h
> ===================================================================
> --- linux-2.6-lttng.git.orig/include/trace/ftrace.h
> +++ linux-2.6-lttng.git/include/trace/ftrace.h
> @@ -1,4 +1,10 @@
>  /*
> + * Macros mapping tp_assign() and tp_memcpy() to "=" and memcpy.
> + */
> +#define tp_assign(dest, src)		__entry->dest = src
> +#define tp_memcpy(dest, src, len)	memcpy(__entry->dest, src, len)

Looks good.


> +
> +/*
>   * Stage 1 of the trace events.
>   *
>   * Override the macros in <trace/trace_events.h> to include the following:
> Index: linux-2.6-lttng.git/include/linux/tracepoint.h
> ===================================================================
> --- linux-2.6-lttng.git.orig/include/linux/tracepoint.h
> +++ linux-2.6-lttng.git/include/linux/tracepoint.h
> @@ -306,12 +306,12 @@ static inline void tracepoint_update_pro
>   *	*
>   *
>   *	TP_fast_assign(
> - *		memcpy(__entry->next_comm, next->comm, TASK_COMM_LEN);
> - *		__entry->prev_pid	= prev->pid;
> - *		__entry->prev_prio	= prev->prio;
> - *		memcpy(__entry->prev_comm, prev->comm, TASK_COMM_LEN);
> - *		__entry->next_pid	= next->pid;
> - *		__entry->next_prio	= next->prio;
> + *		tp_memcpy(next_comm, next->comm, TASK_COMM_LEN);
> + *		tp_assign(prev_pid, prev->pid);
> + *		tp_assign(prev_prio, prev->prio);
> + *		tp_memcpy(prev_comm, prev->comm, TASK_COMM_LEN);
> + *		tp_assign(next_pid, next->pid);
> + *		tp_assign(next_prio, next->prio);
>   *	)
>   *
>   *	*
> 
> -- 
> Mathieu Desnoyers
> Operating System Efficiency R&D Consultant
> EfficiOS Inc.
> http://www.efficios.com
