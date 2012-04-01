Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181Ab2DACaP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 22:30:15 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:36432 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754056Ab2DACaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 22:30:13 -0400
Date: Sun, 1 Apr 2012 10:17:06 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] debugobjects: Use GFP_ATOMIC to allocate when
 initializing
Message-ID: <20120401021706.GA21615@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1333228972-4594-1-git-send-email-levinsasha928@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1333228972-4594-1-git-send-email-levinsasha928@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 31, 2012 at 05:22:52PM -0400, Sasha Levin wrote:
> During the init stage, we have only 1 cpu and run with IRQs disabled,

debug_objects_mem_init() is called after local_irq_enable() in
start_kernel()

> we can't allocate with GFP_KERNEL.
> 
> This also fixes the related warning on boot.

Not sure how you get that.

Thanks,
Yong


> 
> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
> ---
>  lib/debugobjects.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/lib/debugobjects.c b/lib/debugobjects.c
> index 0ab9ae8..ece5e06 100644
> --- a/lib/debugobjects.c
> +++ b/lib/debugobjects.c
> @@ -1020,7 +1020,7 @@ static int __init debug_objects_replace_static_objects(void)
>  	int i, cnt = 0;
>  
>  	for (i = 0; i < ODEBUG_POOL_SIZE; i++) {
> -		obj = kmem_cache_zalloc(obj_cache, GFP_KERNEL);
> +		obj = kmem_cache_zalloc(obj_cache, GFP_ATOMIC);
>  		if (!obj)
>  			goto free;
>  		hlist_add_head(&obj->node, &objects);
> -- 
> 1.7.8.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Only stand for myself
