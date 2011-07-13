Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575Ab1GMOLk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 10:11:40 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36214 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964Ab1GMOLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 10:11:39 -0400
Date: Wed, 13 Jul 2011 16:11:34 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: David Sharp <dhsharp@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Michael Rubin <mrubin@google.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Jiaying Zhang <jiayingz@google.com>
Subject: Re: [PATCH v3] trace: Add x86 irq vector entry/exit tracepoints
Message-ID: <20110713141129.GG9201@somewhere>
References: <1306877298-31713-1-git-send-email-vnagarnaik@google.com>
 <1308681903-12840-1-git-send-email-vnagarnaik@google.com>
 <20110707233453.GE21115@somewhere>
 <CAJL_eku7ezDhSOaOxN4ACFas1rnX=uaV184ZK3-0fE60Rmwh8g@mail.gmail.com>
 <20110711155404.GB4109@somewhere.redhat.com>
 <CAL26m8+ca64BDrQUohxcZfUpZQgn7bNkup=Q92LaTmpvorm9fQ@mail.gmail.com>
 <20110712180859.GC9201@somewhere>
 <CAL26m8LsEwEEE1e4D9dWn2Gm5_cvtNXMRod4d2hsD=qHGG1Nig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL26m8LsEwEEE1e4D9dWn2Gm5_cvtNXMRod4d2hsD=qHGG1Nig@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 12, 2011 at 03:08:48PM -0700, Vaibhav Nagarnaik wrote:
> Breaking this patch up in different small ones makes sense. Can you
> comment on this proposal for the following trace events?
> 
> For tracepoints in generic IRQ handlers:
> 1. trace_timer_vector - takes an enum for BROADCAST, HRTIMER, ONESHOT,
>    PERIODIC and NOHZ.

Have you read my previous email entirely? 

Where I explained we shouldn't use that vector naming outside of low
level archs, and that those enums break tracing granularity?

> 2. trace_irq_work_vector - for IRQ_WORK_VECTOR

trace_irq_work_run() should be enough. And people can add
trace_irq_work_queue() if they need to one day.


> 3. trace_reschedule_vector - for RESCHEDULE_IPI vector

trace_reschedule_interrupt()


> 4. trace_call_function_vector - takes an enum for CALL_FUNCTION and
>    CALL_FUNCTION_SINGLE

Two seperate tracepoints should be better.


> Another trace event for arch-specific IRQ vectors which don't have
> generic event handlers:
> 5. trace_platform_irq_vector - takes an enum, which is defined in
>    asm/irq.h for each platform. This is traced in arch-specific files
>    only.

Yep. For this perhaps an enum can make sense.

Thanks.
