Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751199Ab2KFJx5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 04:53:57 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:42413 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943Ab2KFJxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 04:53:54 -0500
MIME-Version: 1.0
X-Originating-IP: [88.2.49.79]
In-Reply-To: <1351958983-31355-2-git-send-email-fweisbec@gmail.com>
References: <1351958983-31355-1-git-send-email-fweisbec@gmail.com>
	<1351958983-31355-2-git-send-email-fweisbec@gmail.com>
Date: Tue, 6 Nov 2012 11:53:53 +0200
Message-ID: <CAOtvUMckqfMhSwE6DsEzaEUEcDGw0uyYD9x0_XSo-1GM3HDy1g@mail.gmail.com>
Subject: Re: [PATCH 1/3] context_tracking: New context tracking susbsystem
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 3, 2012 at 6:09 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> Create a new subsystem that probes on kernel boundaries
> to keep track of the transitions between level contexts
> with two basic initial contexts: user or kernel.
>
> This is an abstraction of some RCU code that use such tracking
> to implement its userspace extended quiescent state.
>
> We need to pull this up from RCU into this new level of indirection
> because this tracking is also going to be used to implement an "on
> demand" generic virtual cputime accounting. A necessary step to
> shutdown the tick while still accounting the cputime.
> ...
>
> diff --git a/arch/Kconfig b/arch/Kconfig
> index 366ec06..3855e06 100644
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -300,15 +300,15 @@ config SECCOMP_FILTER
>
>           See Documentation/prctl/seccomp_filter.txt for details.
>
> -config HAVE_RCU_USER_QS
> +config HAVE_CONTEXT_TRACKING
>         bool
>         help
> -         Provide kernel entry/exit hooks necessary for userspace
> +         Provide kernel/user boundaries probes necessary for userspace
>           RCU extended quiescent state. Syscalls need to be wrapped inside

A minor nit pick: if whole point of the patch is to turn an RCU
specific mechanism to a generic one
that RCU happens to use, then the text needs to reflect that. How about:

"Provide kernel/user boundaries probes necessary for subsystems that
need it, such as userspace
RCU extended quiescent state. "


> -         rcu_user_exit()-rcu_user_enter() through the slow path using
> -         TIF_NOHZ flag. Exceptions handlers must be wrapped as well. Irqs
> -         are already protected inside rcu_irq_enter/rcu_irq_exit() but
> -         preemption or signal handling on irq exit still need to be protected.
> +         user_exit()-user_enter() through the slow path using TIF_NOHZ flag.
> +         Exceptions handlers must be wrapped as well. Irqs are already
> +         protected inside rcu_irq_enter/rcu_irq_exit() but preemption or
> +         signal handling on irq exit still need to be protected.
>

Thanks,
Gilad

-- 
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
