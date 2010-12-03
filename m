Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758477Ab0LCEyJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 23:54:09 -0500
Received: from tomts16.bellnexxia.net ([209.226.175.4]:54457 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751451Ab0LCEyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 23:54:07 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAIsF+ExGNBQZ/2dsb2JhbACjL3LCOoVHBIReOYpo
Date: Thu, 2 Dec 2010 23:54:02 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC][PATCH 1/2 v2] tracing: Add TRACE_EVENT_CONDITIONAL()
Message-ID: <20101203045402.GA29609@Krystal>
References: <20101203040358.955427199@goodmis.org> <20101203040822.144348122@goodmis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20101203040822.144348122@goodmis.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 23:26:24 up 239 days, 14:16,  5 users,  load average: 0.13, 0.10,
	0.09
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
[...]
> -#define __DO_TRACE(tp, proto, args)					\
> +#define __DO_TRACE(tp, proto, args, cond)				\
>  	do {								\
>  		struct tracepoint_func *it_func_ptr;			\
>  		void *it_func;						\
>  		void *__data;						\
>  									\
> +		if (!(cond))						\

One small documentation-related detail: my guess is that you are leaving
"cond" without likely/unlikely builtin expect purposefully so that we
can write, in TP_CONDITION:

  TP_CONDITION(unlikely(someparam)),

when we expect the condition to be usually false (and likely() for the
reverse). Maybe it could be worth documenting that expressions like the
following are valid :

  TP_CONDITION((likely(param1) && unlikely(param2)) || likely(param3))

It's fair to assume that kernel developers know this already, but given
we plan to re-use TRACE_EVENT() for the user-space tracer soon enough,
documenting this kind of use-case now can save us the trouble in the
future.

Other than that,

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

Thanks!

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
