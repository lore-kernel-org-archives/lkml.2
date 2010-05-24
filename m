Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654Ab0EXBEQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 21:04:16 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:38877 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab0EXBEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 21:04:15 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Julia Lawall <julia@diku.dk>
Subject: Re: [PATCH 5/27] mm: Use memdup_user
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.1005221019370.13021@ask.diku.dk>
References: <Pine.LNX.4.64.1005221019370.13021@ask.diku.dk>
Message-Id: <20100524095902.1E92.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 24 May 2010 10:04:10 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
>  mm/util.c |   11 +++--------
>  1 file changed, 3 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/util.c b/mm/util.c
> index f5712e8..4735ea4 100644
> --- a/mm/util.c
> +++ b/mm/util.c
> @@ -225,15 +225,10 @@ char *strndup_user(const char __user *s, long n)
>  	if (length > n)
>  		return ERR_PTR(-EINVAL);
>  
> -	p = kmalloc(length, GFP_KERNEL);
> +	p = memdup_user(s, length);

memdup? Why can't we use strnlen_user() and legitimate length copy?


>  
> -	if (!p)
> -		return ERR_PTR(-ENOMEM);
> -
> -	if (copy_from_user(p, s, length)) {
> -		kfree(p);
> -		return ERR_PTR(-EFAULT);
> -	}
> +	if (IS_ERR(p))
> +		return p;
>  
>  	p[length - 1] = '\0';
>  
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>



