Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972Ab1GNWFw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 18:05:52 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39628 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802Ab1GNWFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 18:05:51 -0400
Date: Fri, 15 Jul 2011 00:05:46 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 5/6] trace: Add tracepoints to call function interrupt
 handlers
Message-ID: <20110714220545.GD26786@somewhere.redhat.com>
References: <1310679495-29104-1-git-send-email-vnagarnaik@google.com>
 <1310679495-29104-6-git-send-email-vnagarnaik@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310679495-29104-6-git-send-email-vnagarnaik@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 14, 2011 at 02:38:14PM -0700, Vaibhav Nagarnaik wrote:
> Add tracepoints to call function and call function single interrupt
> handlers.
> 
> This is a part of overall effort to trace all the interrupts happening
> in a system to figure out what time is spent in kernel space versus user
> space.
> 
> Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
> ---
>  include/trace/events/irq.h |   73 ++++++++++++++++++++++++++++++++++++++++++++
>  kernel/smp.c               |    5 +++
>  2 files changed, 78 insertions(+), 0 deletions(-)
> 
> diff --git a/include/trace/events/irq.h b/include/trace/events/irq.h
> index a2a0a49..40b19f4 100644
> --- a/include/trace/events/irq.h
> +++ b/include/trace/events/irq.h
> @@ -384,6 +384,79 @@ DEFINE_EVENT(reschedule_interrupt, reschedule_interrupt_exit,
>  	TP_ARGS(ignore)
>  );
>  
> +DECLARE_EVENT_CLASS(call_function,
> +
> +	TP_PROTO(unsigned int ignore),
> +
> +	TP_ARGS(ignore),
> +
> +	TP_STRUCT__entry(
> +		__field(	unsigned int,	ignore	)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->ignore = ignore;
> +	),
> +
> +	TP_printk("%u", __entry->ignore)
> +);
> +
> +/**
> + * call_function_entry - called immediately after entering the
> + * call function interrupt handler
> + *
> + * When used in combination with the call_function_exit tracepoint
> + * we can determine the call function interrupt handler runtime.
> + */
> +DEFINE_EVENT(call_function, call_function_entry,
> +
> +	TP_PROTO(unsigned int ignore),
> +
> +	TP_ARGS(ignore)
> +);

Looks good. But perhaps we need some disambiguation on the names, call_function is perhaps
too generic.

What about trace_irq_call_function() ? Or may be something with ipi in the name, dunno. 
