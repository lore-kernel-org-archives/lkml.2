Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612Ab1ETNZY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 09:25:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:40420 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756104Ab1ETNZX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 09:25:23 -0400
Subject: Re: linux-next: manual merge of the tip tree with the sparc tree
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Hellstrom <daniel@gaisler.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
In-Reply-To: <4DD66328.4010603@gaisler.com>
References: <20110517131435.aceca54e.sfr@canb.auug.org.au>
	 <4DD51D37.3010907@gaisler.com> <1305819306.2466.7228.camel@twins>
	 <4DD60530.6090900@gaisler.com> <1305879113.2466.7231.camel@twins>
	 <4DD66328.4010603@gaisler.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 20 May 2011 15:24:56 +0200
Message-ID: <1305897896.2466.7235.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-20 at 14:48 +0200, Daniel Hellstrom wrote:
> Subject: [PATCH] SCHED_TTWU_QUEUE is not longer needed since sparc32 now implements IPI
> 
> Signed-off-by: Daniel Hellstrom <daniel@gaisler.com>
> Reported-by: Peter Zijlstra <peterz@infradead.org>

Yep, this looks fine, please merge this patch through whatever tree
carries the sparc32-smp work.

Acked-by: Peter Zijlstra <peterz@infradead.org>

> ---
>  init/Kconfig   |    5 -----
>  kernel/sched.c |    2 +-
>  2 files changed, 1 insertions(+), 6 deletions(-)
> 
> diff --git a/init/Kconfig b/init/Kconfig
> index df64627..a66b656 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -827,11 +827,6 @@ config SCHED_AUTOGROUP
>           desktop applications.  Task group autogeneration is currently 
> based
>           upon task session.
> 
> -config SCHED_TTWU_QUEUE
> -       bool
> -       depends on !SPARC32
> -       default y
> -
>  config MM_OWNER
>         bool
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index c62acf4..0516af4 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -2564,7 +2564,7 @@ static void ttwu_queue(struct task_struct *p, int cpu)
>  {
>         struct rq *rq = cpu_rq(cpu);
> 
> -#if defined(CONFIG_SMP) && defined(CONFIG_SCHED_TTWU_QUEUE)
> +#if defined(CONFIG_SMP)
>         if (sched_feat(TTWU_QUEUE) && cpu != smp_processor_id()) {
>                 ttwu_queue_remote(p, cpu);
>                 return;
> -- 
