Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858Ab2DARgt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 13:36:49 -0400
Received: from www.linutronix.de ([62.245.132.108]:46867 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512Ab2DARgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 13:36:47 -0400
Date: Sun, 1 Apr 2012 19:36:45 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sasha Levin <levinsasha928@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] debugobjects: Use GFP_ATOMIC to allocate when
 initializing
In-Reply-To: <1333228972-4594-1-git-send-email-levinsasha928@gmail.com>
Message-ID: <alpine.LFD.2.02.1204011935190.2542@ionos>
References: <1333228972-4594-1-git-send-email-levinsasha928@gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Mar 2012, Sasha Levin wrote:

> During the init stage, we have only 1 cpu and run with IRQs disabled,
> we can't allocate with GFP_KERNEL.
> 
> This also fixes the related warning on boot.

Hrmm. This should not be the case. In early boot GFP_KERNEL
allocations should not trigger a warning when interrupts are
disabled. Which kind of warning are you observing ?

Thanks,

	tglx

 
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
> 
