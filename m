Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140Ab1ECKLL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 06:11:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2809 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751509Ab1ECKLJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 06:11:09 -0400
Subject: Re: [RFC patch 26/32] trace event gfs2 remove semicolons
From: Steven Whitehouse <swhiteho@redhat.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <20110502213215.535626022@efficios.com>
References: <20110502211123.163877033@efficios.com>
	 <20110502213215.535626022@efficios.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Tue, 03 May 2011 11:14:04 +0100
Message-ID: <1304417644.4049.4.camel@dolmen>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 2011-05-02 at 17:11 -0400, Mathieu Desnoyers wrote:
> plain text document attachment
> (trace-event-gfs2-remove-semicolons.patch)
> Part of the gradual TRACE_EVENT() semicolon removal. Enables creation of array
> of events, thus saving space for trace event probes.  Remove extra trailing
> semicolons at the end of GFS2 trace event declarations.
> 
Note that there is a new tracepoint for GFS2 currently awaiting the next
merge window in the GFS2 -nmw git tree, so that will need to be patched
too. Otherwise, looks good to me,

Steve.

> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Acked-by: Steven Whitehouse <swhiteho@redhat.com>
> CC: Steven Rostedt <rostedt@goodmis.org>
> CC: Frederic Weisbecker <fweisbec@gmail.com>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: Thomas Gleixner <tglx@linutronix.de>
> ---
>  fs/gfs2/trace_gfs2.h |   26 +++++++++++++-------------
>  1 file changed, 13 insertions(+), 13 deletions(-)
> 
> Index: linux-2.6-lttng/fs/gfs2/trace_gfs2.h
> ===================================================================
> --- linux-2.6-lttng.orig/fs/gfs2/trace_gfs2.h
> +++ linux-2.6-lttng/fs/gfs2/trace_gfs2.h
> @@ -42,8 +42,8 @@
>  	{(1UL << GLF_FROZEN),			"F" },		\
>  	{(1UL << GLF_QUEUED),			"q" })
>  
> -#ifndef NUMPTY
> -#define NUMPTY
> +#ifndef _TRACE_GFS2_DEF_
> +#define _TRACE_GFS2_DEF_
>  static inline u8 glock_trace_state(unsigned int state)
>  {
>  	switch(state) {
> @@ -56,7 +56,7 @@ static inline u8 glock_trace_state(unsig
>  	}
>  	return DLM_LOCK_NL;
>  }
> -#endif
> +#endif /* _TRACE_GFS2_DEF_ */
>  
>  /* Section 1 - Locking
>   *
> @@ -105,7 +105,7 @@ TRACE_EVENT(gfs2_glock_state_change,
>  		  glock_trace_name(__entry->tgt_state),
>  		  glock_trace_name(__entry->dmt_state),
>  		  show_glock_flags(__entry->flags))
> -);
> +)
>  
>  /* State change -> unlocked, glock is being deallocated */
>  TRACE_EVENT(gfs2_glock_put,
> @@ -137,7 +137,7 @@ TRACE_EVENT(gfs2_glock_put,
>  		  glock_trace_name(DLM_LOCK_IV),
>  		  show_glock_flags(__entry->flags))
>  
> -);
> +)
>  
>  /* Callback (local or remote) requesting lock demotion */
>  TRACE_EVENT(gfs2_demote_rq,
> @@ -171,7 +171,7 @@ TRACE_EVENT(gfs2_demote_rq,
>                    glock_trace_name(__entry->dmt_state),
>  		  show_glock_flags(__entry->flags))
>  
> -);
> +)
>  
>  /* Promotion/grant of a glock */
>  TRACE_EVENT(gfs2_promote,
> @@ -201,7 +201,7 @@ TRACE_EVENT(gfs2_promote,
>  		  (unsigned long long)__entry->glnum,
>  		  __entry->first ? "first": "other",
>  		  glock_trace_name(__entry->state))
> -);
> +)
>  
>  /* Queue/dequeue a lock request */
>  TRACE_EVENT(gfs2_glock_queue,
> @@ -231,7 +231,7 @@ TRACE_EVENT(gfs2_glock_queue,
>  		  (unsigned long long)__entry->glnum,
>  		  __entry->queue ? "" : "de",
>  		  glock_trace_name(__entry->state))
> -);
> +)
>  
>  /* Section 2 - Log/journal
>   *
> @@ -270,7 +270,7 @@ TRACE_EVENT(gfs2_pin,
>  		  (unsigned long long)__entry->block,
>  		  (unsigned long)__entry->len,
>  		  (unsigned long long)__entry->ino)
> -);
> +)
>  
>  /* Flushing the log */
>  TRACE_EVENT(gfs2_log_flush,
> @@ -295,7 +295,7 @@ TRACE_EVENT(gfs2_log_flush,
>  		  MAJOR(__entry->dev), MINOR(__entry->dev),
>  		  __entry->start ? "start" : "end",
>  		  (unsigned long long)__entry->log_seq)
> -);
> +)
>  
>  /* Reserving/releasing blocks in the log */
>  TRACE_EVENT(gfs2_log_blocks,
> @@ -316,7 +316,7 @@ TRACE_EVENT(gfs2_log_blocks,
>  
>  	TP_printk("%u,%u log reserve %d", MAJOR(__entry->dev),
>  		  MINOR(__entry->dev), __entry->blocks)
> -);
> +)
>  
>  /* Section 3 - bmap
>   *
> @@ -364,7 +364,7 @@ TRACE_EVENT(gfs2_bmap,
>  		  (unsigned long long)__entry->pblock,
>  		  __entry->state, __entry->create ? "create " : "nocreate",
>  		  __entry->errno)
> -);
> +)
>  
>  /* Keep track of blocks as they are allocated/freed */
>  TRACE_EVENT(gfs2_block_alloc,
> @@ -396,7 +396,7 @@ TRACE_EVENT(gfs2_block_alloc,
>  		  (unsigned long long)__entry->start,
>  		  (unsigned long)__entry->len,
>  		  block_state_name(__entry->block_state))
> -);
> +)
>  
>  #endif /* _TRACE_GFS2_H */
>  
> 


