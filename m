Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918Ab2BQLXk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 06:23:40 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48238 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751494Ab2BQLXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 06:23:39 -0500
Date: Fri, 17 Feb 2012 12:22:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dmitry Antipov <dmitry.antipov@linaro.org>
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@redhat.com>,
        Yong Zhang <yong.zhang0@gmail.com>, Venki Pallipadi <venki@google.com>,
        x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-dev@lists.linaro.org, patches@linaro.org
Subject: Re: [PATCH] sched: generalize CONFIG_IRQ_TIME_ACCOUNTING for X86 and
 ARM
Message-ID: <20120217112258.GC14789@elte.hu>
References: <1328918525-7309-1-git-send-email-dmitry.antipov@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328918525-7309-1-git-send-email-dmitry.antipov@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dmitry Antipov <dmitry.antipov@linaro.org> wrote:

> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -757,18 +757,20 @@ static DEFINE_PER_CPU(u64, cpu_hardirq_time);
>  static DEFINE_PER_CPU(u64, cpu_softirq_time);
>  
>  static DEFINE_PER_CPU(u64, irq_start_time);
> -static int sched_clock_irqtime;
>  
> -void enable_sched_clock_irqtime(void)
> -{
> -	sched_clock_irqtime = 1;
> -}
> +/* -1 if not initialized, 0 if disabled with "noirqtime" kernel option
> + * or after unstable clock was detected, 1 if enabled and active.
> + */

Please use the customary (multi-line) comment style:

  /*
   * Comment .....
   * ...... goes here.
   */

specified in Documentation/CodingStyle.

> +int sched_clock_irqtime = -1;

should be turned into __read_mostly I guess.

Thanks,

	Ingo
