Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918Ab0INMr7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 08:47:59 -0400
Received: from void.printf.net ([89.145.121.20]:45117 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752417Ab0INMr4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 08:47:56 -0400
Date: Tue, 14 Sep 2010 13:47:41 +0100
From: Chris Ball <cjb@laptop.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Hellwig <hch@infradead.org>, linux-mmc@vger.kernel.org
Subject: Re: [patch 21/30] mmc: Convert "mutex" to semaphore
Message-ID: <20100914124741.GA17079@void.printf.net>
References: <20100907124636.880953480@linutronix.de> <20100907125056.703221226@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100907125056.703221226@linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Sep 07, 2010 at 02:33:22PM -0000, Thomas Gleixner wrote:
> Get rid of init_MUTEX[_LOCKED]() and use sema_init() instead.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: linux-mmc@vger.kernel.org
> 
> ---
>  drivers/mmc/card/queue.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6/drivers/mmc/card/queue.c
> ===================================================================
> --- linux-2.6.orig/drivers/mmc/card/queue.c
> +++ linux-2.6/drivers/mmc/card/queue.c
> @@ -209,7 +209,7 @@ int mmc_init_queue(struct mmc_queue *mq,
>  		sg_init_table(mq->sg, host->max_phys_segs);
>  	}
>  
> -	init_MUTEX(&mq->thread_sem);
> +	sema_init(&mq->thread_sem, 1);
>  
>  	mq->thread = kthread_run(mmc_queue_thread, mq, "mmcqd");
>  	if (IS_ERR(mq->thread)) {
> 
> 

Thanks, applied to mmc-next.

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
