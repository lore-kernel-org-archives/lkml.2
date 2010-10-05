Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881Ab0JETio (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 15:38:44 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59973 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753133Ab0JETin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 15:38:43 -0400
Date: Tue, 5 Oct 2010 21:38:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, jslaby@suse.cz, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: + softirq-cleanup-preempt-check.patch added to -mm tree
Message-ID: <20101005193833.GA16493@elte.hu>
References: <201010051905.o95J5BrS013873@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201010051905.o95J5BrS013873@imap1.linux-foundation.org>
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

> +static inline void softirq_preempt_check(struct softirq_action *h,
> +		int prev_count)

unnecessary linebreak.

> +{
> +	if (unlikely(prev_count != preempt_count())) {

should be something like:

	if (prev_count == preempt_count())
		return;

then the rest will look cleaner as well.

> +		printk(KERN_ERR "huh, entered softirq %td %s %pf with preempt_count %08x, exited with %08x?\n",

Could be pr_err().

> +			softirq_preempt_check(h, prev_count);

Please put 'debug' in the function name as i suggested - that way people 
will only read it if they are interested in debug checks.

softirq_debug_check() would be perfect. (which might even grow new 
checks in the future)

Thanks,

	Ingo
