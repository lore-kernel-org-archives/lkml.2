Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759412Ab2JaRna (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 13:43:30 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:34481 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758950Ab2JaRn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 13:43:28 -0400
Date: Wed, 31 Oct 2012 17:43:27 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Shan Wei <shanwei88@gmail.com>
cc: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        Kernel-Maillist <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/9] ftrace: use this_cpu_ptr per-cpu helper
In-Reply-To: <50910A0A.9010209@gmail.com>
Message-ID: <0000013ab7ebaffd-8b5d50e4-8ca9-4d40-a843-c343cbc70dbc-000000@email.amazonses.com>
References: <50910A0A.9010209@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Oct 2012, Shan Wei wrote:

> diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
> index a763888..7c9fde7 100644
> --- a/include/trace/ftrace.h
> +++ b/include/trace/ftrace.h
> @@ -638,7 +638,6 @@ __attribute__((section("_ftrace_events"))) *__event_##call = &event_##call
>   *	struct trace_entry *ent;
>   *	int __entry_size;
>   *	int __data_size;
> - *	int __cpu
>   *	int pc;
>   *
>   *	pc = preempt_count();
> @@ -654,7 +653,6 @@ __attribute__((section("_ftrace_events"))) *__event_##call = &event_##call
>   *	// Protect the non nmi buffer
>   *	// This also protects the rcu read side
>   *	local_irq_save(irq_flags);
> - *	__cpu = smp_processor_id();
>   *
>   *	if (in_nmi())
>   *		trace_buf = rcu_dereference_sched(perf_trace_buf_nmi);
> @@ -664,7 +662,7 @@ __attribute__((section("_ftrace_events"))) *__event_##call = &event_##call
>   *	if (!trace_buf)
>   *		goto end;
>   *
> - *	trace_buf = per_cpu_ptr(trace_buf, __cpu);
> + *	trace_buf = this_cpu_ptr(trace_buf);
>   *
>   * 	// Avoid recursion from perf that could mess up the buffer
>   * 	if (trace_buf->recursion++)

Reviewed-by: Christoph Lameter <cl@linux.com>

Code could be further reduced by not doing the this_cpu_ptr op but using
this_cpu_read later instead.

