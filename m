Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060Ab0JaIot (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 04:44:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59356 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752867Ab0JaIor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 04:44:47 -0400
Date: Sun, 31 Oct 2010 09:44:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: Remove redundant #ifdef.
Message-ID: <20101031084436.GA14001@elte.hu>
References: <AANLkTi=T2JXDT=jYRED8jMGiWdxwUt5vJ-RG=pfRv9dS@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=T2JXDT=jYRED8jMGiWdxwUt5vJ-RG=pfRv9dS@mail.gmail.com>
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


* Rakib Mullick <rakib.mullick@gmail.com> wrote:

>  Remove redundant #ifdef to wrap struct cpupri. root_domain structure
> is declared under #ifdef CONFIG_SMP, no need to use #ifdef again
> inside the structure.
> 
> 
> Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
> ---
> 
> --- linus-36/kernel/sched.c	2010-10-21 02:30:22.000000000 +0600
> +++ rakib-36/kernel/sched.c	2010-10-31 11:16:22.000000000 +0600
> @@ -426,9 +426,7 @@ struct root_domain {
>  	 */
>  	cpumask_var_t rto_mask;
>  	atomic_t rto_count;
> -#ifdef CONFIG_SMP
>  	struct cpupri cpupri;
> -#endif
>  };

The same patch was already sent by Christian Dietrich a few weeks ago, and it's 
upstream already:

 ed2d372c0738: sched: Remove unnecessary #ifdef CONFIG_SMP

Thanks,

	Ingo
