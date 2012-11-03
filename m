Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844Ab2KCLad (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 07:30:33 -0400
Received: from mx01.sz.bfs.de ([194.94.69.103]:61842 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752952Ab2KCLac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 07:30:32 -0400
Message-ID: <50950055.8040307@bfs.de>
Date: Sat, 03 Nov 2012 12:30:29 +0100
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Julia Lawall <Julia.Lawall@lip6.fr>
CC: netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/16] drivers/net/ethernet/ibm/emac/mal.c: use WARN
References: <1351940317-14812-1-git-send-email-Julia.Lawall@lip6.fr> <1351940317-14812-11-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1351940317-14812-11-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Am 03.11.2012 11:58, schrieb Julia Lawall:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Use WARN rather than printk followed by WARN_ON(1), for conciseness.
> 
> A simplified version of the semantic patch that makes this transformation
> is as follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression list es;
> @@
> 
> -printk(
> +WARN(1,
>   es);
> -WARN_ON(1);
> // </smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> ---
>  drivers/net/ethernet/ibm/emac/mal.c |    6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/ibm/emac/mal.c b/drivers/net/ethernet/ibm/emac/mal.c
> index 479e43e..84c6b6c 100644
> --- a/drivers/net/ethernet/ibm/emac/mal.c
> +++ b/drivers/net/ethernet/ibm/emac/mal.c
> @@ -738,13 +738,11 @@ static int __devexit mal_remove(struct platform_device *ofdev)
>  	/* Synchronize with scheduled polling */
>  	napi_disable(&mal->napi);
>  
> -	if (!list_empty(&mal->list)) {
> +	if (!list_empty(&mal->list))
>  		/* This is *very* bad */
> -		printk(KERN_EMERG
> +		WARN(1, KERN_EMERG
>  		       "mal%d: commac list is not empty on remove!\n",
>  		       mal->index);
> -		WARN_ON(1);
> -	}
>  
>  	dev_set_drvdata(&ofdev->dev, NULL);
>  
> 

Hi Julia,
you are removing the {} behin the if. I prefer to be a bit conservative
about {}. There is suggest to keep them because WARN may be expanded in
future (with a second line) and that will cause subtle changes that do
no break the code. (Yes i know it is possible to write macros that
contain savely more than one line.)

re,
 wh

