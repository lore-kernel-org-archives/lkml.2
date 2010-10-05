Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708Ab0JEHqF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 03:46:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40079 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752200Ab0JEHqD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 03:46:03 -0400
Date: Tue, 5 Oct 2010 09:45:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: akpm@linux-foundation.org
Cc: tglx@linutronix.de, jslaby@suse.cz, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch 1/1] softirq: improve preempt count error message
Message-ID: <20101005074554.GB23608@elte.hu>
References: <201010012114.o91LEcZl021026@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201010012114.o91LEcZl021026@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* akpm@linux-foundation.org <akpm@linux-foundation.org> wrote:

> From: Jiri Slaby <jslaby@suse.cz>
> 
> * add a space after the action
> * print function name instead of address of action (%p->%pf)
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  kernel/softirq.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff -puN kernel/softirq.c~softirq-improve-preempt-count-error-message kernel/softirq.c
> --- a/kernel/softirq.c~softirq-improve-preempt-count-error-message
> +++ a/kernel/softirq.c
> @@ -219,8 +219,8 @@ restart:
>  			h->action(h);
>  			trace_softirq_exit(h, softirq_vec);
>  			if (unlikely(prev_count != preempt_count())) {
> -				printk(KERN_ERR "huh, entered softirq %td %s %p"
> -				       "with preempt_count %08x,"
> +				printk(KERN_ERR "huh, entered softirq %td %s "
> +				       "%pf with preempt_count %08x,"
>  				       " exited with %08x?\n", h - softirq_vec,
>  				       softirq_to_name[h - softirq_vec],
>  				       h->action, prev_count, preempt_count());

Please fix the cause of the bug as well: i think this whole block of 
debug checks should move into a softirq_debug_check(h, prev_count) 
helper inline function - that would clean up the insane printk line 
which is currently spread out on 5 lines ...

It would also make __do_softirq() more readable.

Thanks,

	Ingo
