Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382Ab1EYS5a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 14:57:30 -0400
Received: from www.linutronix.de ([62.245.132.108]:54091 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338Ab1EYS52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 14:57:28 -0400
Date: Wed, 25 May 2011 20:57:25 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        Witold Baryluk <baryluk@smp.if.uj.edu.pl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH] ftrace: Add internal recursive checks
In-Reply-To: <1306348063.1465.116.camel@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.2.02.1105252054270.3078@ionos>
References: <1306348063.1465.116.camel@gandalf.stny.rr.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 May 2011, Steven Rostedt wrote:
> +
> +	/* Only current can touch these values */
> +#define trace_recursion_inc() (current)->trace_recursion++
> +#define trace_recursion_dec() (current)->trace_recursion--
> +	/* Ring buffer has the 10 LSB bits to count */
> +#define trace_recursion_buffer() ((current)->trace_recursion & 0x3ff)
> +#define TRACE_INTERNAL_BIT		(1<<11)
> +#define TRACE_GLOBAL_BIT		(1<<12)
> +#define trace_recursion_set(bit)	(current)->trace_recursion |= (bit)
> +#define trace_recursion_clear(bit)	(current)->trace_recursion &= ~(bit)
> +#define trace_recursion_test(bit)	((current)->trace_recursion & (bit))
> +
>  #endif /* CONFIG_TRACING */

Bah, these are only used in kernel/trace/. So can you please add them
to a kernel/trace local header file instead of cramming it mindlessly
into task_struct just because you're lazy?

Thanks,

	tglx
