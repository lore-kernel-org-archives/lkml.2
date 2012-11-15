Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768654Ab2KOSMf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 13:12:35 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:59716 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768597Ab2KOSMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 13:12:34 -0500
MIME-Version: 1.0
In-Reply-To: <1353001964.18025.107.camel@gandalf.local.home>
References: <1352925457-15700-1-git-send-email-fweisbec@gmail.com>
	<1352925457-15700-8-git-send-email-fweisbec@gmail.com>
	<1352953617.18025.94.camel@gandalf.local.home>
	<CAFTL4hzzhd5__VwR7N+VKpq1C27xHGgi4vj87drbcLghJ+Od5g@mail.gmail.com>
	<1352997261.18025.103.camel@gandalf.local.home>
	<1353001964.18025.107.camel@gandalf.local.home>
Date: Thu, 15 Nov 2012 19:12:33 +0100
Message-ID: <CAFTL4hw+4V5eG4k515YKn_p2BC_cYH_4rboVaQpXorYTom+23w@mail.gmail.com>
Subject: Re: [PATCH RFC] irq_work: Warn if there's still work on cpu_down
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/11/15 Steven Rostedt <rostedt@goodmis.org>:
> If we are in nohz and there's still irq_work to be done when the idle
> task is about to go offline. Give a nasty warning.
>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
>
> Index: linux-rt.git/kernel/irq_work.c
> ===================================================================
> --- linux-rt.git.orig/kernel/irq_work.c
> +++ linux-rt.git/kernel/irq_work.c
> @@ -103,6 +103,9 @@ bool irq_work_needs_cpu(void)
>         if (llist_empty(this_list))
>                 return false;
>
> +       /* All work should have been flushed before going offline */
> +       WARN_ON_ONCE(cpu_is_offline(smp_processor_id()));

Should we return false in that case? I don't know what can happen if
we wait for one more tick while the CPU is offline and apic is
deactivated.

> +
>         return true;
>  }
>
>
>
