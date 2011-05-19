Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933014Ab1ESPft (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 11:35:49 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44392 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505Ab1ESPfr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 11:35:47 -0400
Subject: Re: linux-next: manual merge of the tip tree with the sparc tree
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Hellstrom <daniel@gaisler.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
In-Reply-To: <4DD51D37.3010907@gaisler.com>
References: <20110517131435.aceca54e.sfr@canb.auug.org.au>
	 <4DD51D37.3010907@gaisler.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 19 May 2011 17:35:06 +0200
Message-ID: <1305819306.2466.7228.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-19 at 15:37 +0200, Daniel Hellstrom wrote:


> diff --git a/arch/sparc/kernel/smp_32.c b/arch/sparc/kernel/smp_32.c
> index 41102c5..d5b3958 100644
> --- a/arch/sparc/kernel/smp_32.c
> +++ b/arch/sparc/kernel/smp_32.c
> @@ -156,11 +156,11 @@ void arch_send_call_function_ipi_mask(const struct 
> cpumask *mask)
> 
>  void smp_resched_interrupt(void)
>  {
> +       irq_enter();
> +       scheduler_ipi();
>         local_cpu_data().irq_resched_count++;
> -       /*
> -        * do nothing, since it all was about calling re-schedule
> -        * routine called by interrupt return code.
> -        */
> +       irq_exit();
> +       /* re-schedule routine called by interrupt return code. */
>  }

That doesn't look like an IPI, that looks like its calls the function on
the local cpu, which is completely pointless.
