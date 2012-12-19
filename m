Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243Ab2LSAXQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 19:23:16 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:55356 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754972Ab2LSAXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 19:23:14 -0500
Date: Wed, 19 Dec 2012 01:23:13 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Stephen Boyd <sboyd@codeaurora.org>
cc: Bob Liu <lliubbo@gmail.com>, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org, linux-arm-msm@vger.kernel.org,
        Steven Miao <realmz6@gmail.com>, trivial@kernel.org
Subject: Re: [PATCH/TRIVIAL] blackfin: time-ts: Remove duplicate assignment
In-Reply-To: <1355871705-19720-1-git-send-email-sboyd@codeaurora.org>
Message-ID: <alpine.LNX.2.00.1212190121450.14788@swampdragon.chaosbits.net>
References: <1355871705-19720-1-git-send-email-sboyd@codeaurora.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Dec 2012, Stephen Boyd wrote:

> It seems that this assignment is done twice in a row. Remove the
> duplicate assignment.
> 
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> Cc: Steven Miao <realmz6@gmail.com>
> Cc: trivial@kernel.org
> ---
> 
> Noticed while grepping for broadcast users.
> 
>  arch/blackfin/kernel/time-ts.c | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/arch/blackfin/kernel/time-ts.c b/arch/blackfin/kernel/time-ts.c
> index f608f02..cb0a484 100644
> --- a/arch/blackfin/kernel/time-ts.c
> +++ b/arch/blackfin/kernel/time-ts.c
> @@ -329,12 +329,6 @@ void bfin_coretmr_clockevent_init(void)
>  	evt->broadcast = smp_timer_broadcast;
>  #endif
>  
> -
> -#ifdef CONFIG_SMP
> -	evt->broadcast = smp_timer_broadcast;
> -#endif
> -
> -
>  	evt->name = "bfin_core_timer";
>  	evt->rating = 350;
>  	evt->irq = -1;
> 

Looks good to me.

Feel free to add
  Reviewed-by: Jesper Juhl <jj@chaosbits.net>
if you like.

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

