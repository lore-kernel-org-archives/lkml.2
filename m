Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834Ab1G1UF6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 16:05:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31753 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755719Ab1G1UF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 16:05:57 -0400
Date: Thu, 28 Jul 2011 16:05:32 -0400
From: Don Zickus <dzickus@redhat.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] watchdog: NUMA affine kthreads
Message-ID: <20110728200532.GP2581@redhat.com>
References: <1311871468.2346.28.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311871468.2346.28.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 28, 2011 at 06:44:28PM +0200, Eric Dumazet wrote:
> watchdog kthreads can use kthread_create_on_node() to NUMA affine their
> stack and task_struct.

Looks good, I'll apply and test it.

Thanks.

> 
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> CC: Don Zickus <dzickus@redhat.com>
> CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  kernel/watchdog.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/watchdog.c b/kernel/watchdog.c
> index 36491cd..14cabcd 100644
> --- a/kernel/watchdog.c
> +++ b/kernel/watchdog.c
> @@ -438,7 +438,8 @@ static int watchdog_enable(int cpu)
>  
>  	/* create the watchdog thread */
>  	if (!p) {
> -		p = kthread_create(watchdog, (void *)(unsigned long)cpu, "watchdog/%d", cpu);
> +		p = kthread_create_on_node(watchdog, NULL, cpu_to_node(cpu),
> +					   "watchdog/%d", cpu);
>  		if (IS_ERR(p)) {
>  			printk(KERN_ERR "softlockup watchdog for %i failed\n", cpu);
>  			if (!err) {
> 
> 
