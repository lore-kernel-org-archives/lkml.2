Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484Ab1FARyM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 13:54:12 -0400
Received: from mx01.sz.bfs.de ([194.94.69.103]:8692 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308Ab1FARyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 13:54:10 -0400
Message-ID: <4DE67CBF.5080006@bfs.de>
Date: Wed, 01 Jun 2011 19:54:07 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: Wolfgang Grandegger <wg@grandegger.com>, kernel-janitors@vger.kernel.org,
        socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/10] drivers/net/can/flexcan.c: add missing clk_put
References: <1306948213-20767-4-git-send-email-julia@diku.dk>
In-Reply-To: <1306948213-20767-4-git-send-email-julia@diku.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Am 01.06.2011 19:10, schrieb Julia Lawall:
> From: Julia Lawall <julia@diku.dk>
> 
> The failed_get label is used after the call to clk_get has succeeded, so it
> should be moved up above the call to clk_put.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @r exists@
> expression e1,e2;
> statement S;
> @@
> 
> e1 = clk_get@p1(...);
> ... when != e1 = e2
>     when != clk_put(e1)
>     when any
> if (...) { ... when != clk_put(e1)
>                when != if (...) { ... clk_put(e1) ... }
> * return@p3 ...;
>  } else S
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
>  drivers/net/can/flexcan.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
> index d499056..121739c 100644
> --- a/drivers/net/can/flexcan.c
> +++ b/drivers/net/can/flexcan.c
> @@ -978,8 +978,8 @@ static int __devinit flexcan_probe(struct platform_device *pdev)
>   failed_map:
>  	release_mem_region(mem->start, mem_size);
>   failed_req:
> -	clk_put(clk);
>   failed_get:
> +	clk_put(clk);
>   failed_clock:
>  	return err;
>  }
> 

So failed_req == failed_get, is that intended ?

re,
 wh
