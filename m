Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932349Ab2KCMLl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 08:11:41 -0400
Received: from mx01.sz.bfs.de ([194.94.69.103]:51237 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932075Ab2KCMLj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 08:11:39 -0400
Message-ID: <509509F8.2010407@bfs.de>
Date: Sat, 03 Nov 2012 13:11:36 +0100
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Julia Lawall <Julia.Lawall@lip6.fr>
CC: Arnd Bergmann <arnd@arndb.de>, kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/16] drivers/misc/kgdbts.c: use WARN
References: <1351940317-14812-1-git-send-email-Julia.Lawall@lip6.fr> <1351940317-14812-12-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1351940317-14812-12-git-send-email-Julia.Lawall@lip6.fr>
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
>  drivers/misc/kgdbts.c |    5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/misc/kgdbts.c b/drivers/misc/kgdbts.c
> index 3aa9a96..8b367db 100644
> --- a/drivers/misc/kgdbts.c
> +++ b/drivers/misc/kgdbts.c
> @@ -114,9 +114,8 @@
>  		touch_nmi_watchdog();	\
>  	} while (0)
>  #define eprintk(a...) do { \
> -		printk(KERN_ERR a); \
> -		WARN_ON(1); \
> -	} while (0)
> +		WARN(1, KERN_ERR a); \
> +		} while (0)
>  #define MAX_CONFIG_LEN		40
>  

A macro calling a macro ?
Is it possible to replace eprintk() ?

re,
 wh
