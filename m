Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752981Ab2JVKme (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 06:42:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:50860 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308Ab2JVKmd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 06:42:33 -0400
Message-ID: <1350902505.2768.88.camel@twins>
Subject: Re: [RFC PATCH 5/8] irq_work: Make self-IPIs optable
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Mon, 22 Oct 2012 12:41:45 +0200
In-Reply-To: <1350750167-14263-6-git-send-email-fweisbec@gmail.com>
References: <1350750167-14263-1-git-send-email-fweisbec@gmail.com>
	 <1350750167-14263-6-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-10-20 at 12:22 -0400, Frederic Weisbecker wrote:
> +       if (empty) {
> +               /*
> +                * If an IPI is requested, raise it right away. Otherwise wait
> +                * for the next tick unless it's stopped. Now if the arch uses
> +                * some other obscure way than IPI to raise an irq work, just raise
> +                * and don't think further.
> +                */
> +               if (ipi || !arch_irq_work_has_ipi() || tick_nohz_tick_stopped())
> +                       arch_irq_work_raise();
> +       }
>         preempt_enable();
>  } 

Doesn't this have a problem where we enqueue the first lazy and then one
with ipi? In that case it appears we won't send the IPI because the
queue wasn't empty.


