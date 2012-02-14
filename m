Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852Ab2BNSJz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 13:09:55 -0500
Received: from smp.if.uj.edu.pl ([149.156.82.206]:55511 "EHLO smp.if.uj.edu.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752791Ab2BNSJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 13:09:53 -0500
Date: Tue, 14 Feb 2012 19:09:48 +0100
From: Witold Baryluk <baryluk@smp.if.uj.edu.pl>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rob Herring <robherring2@gmail.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Kevin Hilman <khilman@ti.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/3][RFC] tracing/rcu: Add _rcuidle() tracepoint to
 handle rcu_idle_exit() tracepoints
Message-ID: <20120214180947.GA30057@smp.if.uj.edu.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have some problem with cpuidle tracing:

https://bugzilla.kernel.org/show_bug.cgi?id=42742

so I applied 3 patches from https://lkml.org/lkml/headers/2012/2/7/231

> Steven Rostedt (3):
>      tracing/rcu: Add trace_##name##__rcuidle() static tracepoint for inside rcu_idle_exit() sections
>      x86/tracing: Denote the power and cpuidle tracepoints as _rcuidle()
>      cpuidle/tracing: Denote the tracepoints as being in rcu_idle_exit() section

All 3 patches applied cleanly but for unknown reasons to me compilation fails:

CC      arch/x86/kernel/process.o
  arch/x86/kernel/process.c: In function ‘default_idle’:
  arch/x86/kernel/process.c:380:3: error: implicit declaration of function ‘trace_power_start_rcuidle’ [-Werror=implicit-function-declaration]
  arch/x86/kernel/process.c:394:3: error: implicit declaration of function ‘trace_power_end_rcuidle’ [-Werror=implicit-function-declaration]
  cc1: some warnings being treated as errors

I think this is because

        static inline void trace_##name##_rcuidle(proto)                \

should have only 1 argument passed.

but more are passed

        trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, smp_processor_id());
        trace_power_start_rcuidle(POWER_CSTATE, next_state, dev->cpu);

However this explanation fails because

        trace_power_end_rcuidle(smp_processor_id());

have single argument, and because without patches
arch/x86/kernel/process.c compiles without a problem. and there is
nothing in my 'git diff' which should justify such change.

It is mainline Linus kernel with just this 3 patches added.

Any idea?

gcc version 4.6.2 (Debian 4.6.2-14) 
Debian GNU/Linux, wheezy i386. (IA-32)
Intel Pentium M processor.

-- 
Witold Baryluk
