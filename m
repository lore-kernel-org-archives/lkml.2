Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574Ab2LVBWk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 20:22:40 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:61620 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800Ab2LVBWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 20:22:39 -0500
X-Greylist: delayed 358 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Dec 2012 20:22:38 EST
Subject: Re: [PATCH] net: sched: integer overflow fix
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Stefan Hasko <hasko.stevo@gmail.com>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1356138300-16076-1-git-send-email-hasko.stevo@gmail.com>
References: <1356138300-16076-1-git-send-email-hasko.stevo@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 21 Dec 2012 17:16:37 -0800
Message-ID: <1356138997.21834.8185.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-12-22 at 02:04 +0100, Stefan Hasko wrote:
> Sorry, I did not realize different sizes casting problem, now it's clear to me. Thanks for help.
> 
> Fixed integer overflow in function htb_dequeue
> 
> Signed-off-by: Stefan Hasko <hasko.stevo@gmail.com>
> ---
>  net/sched/sch_htb.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
> index d2922c0..51561ea 100644
> --- a/net/sched/sch_htb.c
> +++ b/net/sched/sch_htb.c
> @@ -919,7 +919,7 @@ ok:
>  	q->now = ktime_to_ns(ktime_get());
>  	start_at = jiffies;
>  
> -	next_event = q->now + 5 * NSEC_PER_SEC;
> +	next_event = q->now + 5LLU * NSEC_PER_SEC;
>  
>  	for (level = 0; level < TC_HTB_MAXDEPTH; level++) {
>  		/* common case optimization - skip event handler quickly */

I guess David will remove the first line of your changelog

Acked-by: Eric Dumazet <edumazet@google.com>

Thanks


