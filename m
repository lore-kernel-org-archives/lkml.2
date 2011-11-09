Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751589Ab1KIFdw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 00:33:52 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:21961 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795Ab1KIFdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 00:33:51 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6524"; a="135960758"
Message-ID: <bd0f0eff978b799baf979487756e5cde.squirrel@www.codeaurora.org>
In-Reply-To: <1320778170.8062.134.camel@localhost.localdomain>
References: <1320778170.8062.134.camel@localhost.localdomain>
Date: Tue, 8 Nov 2011 21:33:50 -0800 (PST)
Subject: Re: [PATCH] Hexagon: Use resource_size function
From: rkuo@codeaurora.org
To: "Thomas Meyer" <thomas@m3y3r.de>
Cc: davidb@codeaurora.org, "Arnd Bergmann" <arnd@arndb.de>,
        linux-hexagon@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Thomas Meyer <thomas@m3y3r.de>
>
>  Use resource_size function on resource object
>  instead of explicit computation.
>
>  The semantic patch that makes this change is available
>  in scripts/coccinelle/api/resource_size.cocci.
>
>  More information about semantic patching is available at
>  http://coccinelle.lip6.fr/
>
> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
> ---
>
> diff -u -p a/arch/hexagon/kernel/time.c b/arch/hexagon/kernel/time.c
> --- a/arch/hexagon/kernel/time.c 2011-11-07 19:37:21.719553477 +0100
> +++ b/arch/hexagon/kernel/time.c 2011-11-08 12:21:17.722176538 +0100
> @@ -200,12 +200,10 @@ void __init time_init_deferred(void)
>  		resource = rtos_timer_device.resource;
>
>  	/*  ioremap here means this has to run later, after paging init  */
> -	rtos_timer = ioremap(resource->start, resource->end
> -		- resource->start + 1);
> +	rtos_timer = ioremap(resource->start, resource_size(resource));
>
>  	if (!rtos_timer) {
> -		release_mem_region(resource->start, resource->end
> -			- resource->start + 1);
> +		release_mem_region(resource->start, resource_size(resource));
>  	}
>  	clocksource_register_khz(&hexagon_clocksource, pcycle_freq_mhz * 1000);
>
>
>
>

I don't have much to add about the form of the patch; David
noticed more than I did, but as far as content, it looks good
and I will have this patch applied to my tree.  Thanks!



