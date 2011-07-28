Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652Ab1G1MIY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 08:08:24 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51007 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755603Ab1G1MIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 08:08:17 -0400
Subject: Re: [PATCH v2 4/6] trace: Add tracepoints to reschedule interrupt
 handler
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Vaibhav Nagarnaik <vnagarnaik@google.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org
In-Reply-To: <1311793038-15155-5-git-send-email-vnagarnaik@google.com>
References: <1310679495-29104-1-git-send-email-vnagarnaik@google.com>
	 <1311793038-15155-5-git-send-email-vnagarnaik@google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Jul 2011 14:12:50 +0200
Message-ID: <1311855170.2617.169.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-07-27 at 11:57 -0700, Vaibhav Nagarnaik wrote:
> @@ -2578,6 +2579,7 @@ static void sched_ttwu_pending(void)
>         struct rq *rq = this_rq();
>         struct task_struct *list = xchg(&rq->wake_list, NULL);
>  
> +       trace_reschedule_interrupt_entry(0);
>         if (!list)
>                 return;
>  
> @@ -2610,6 +2612,7 @@ void scheduler_ipi(void)
>         irq_enter();
>         sched_ttwu_do_pending(list);
>         irq_exit();
> +       trace_reschedule_interrupt_exit(0);
>  } 

That's just wrong..

