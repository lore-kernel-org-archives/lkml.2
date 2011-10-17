Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164Ab1JQSgL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 14:36:11 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:1271 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752678Ab1JQSgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 14:36:08 -0400
From: Dmitry Torokhov <dtor@vmware.com>
Organization: VMware, Inc.
To: Rakib Mullick <rakib.mullick@gmail.com>
Subject: Re: [PATCH] drivers, vmw_balloon.c: Determine page allocation flag can_sleep outside loop.
Date: Mon, 17 Oct 2011 11:36:06 -0700
User-Agent: KMail/1.13.7 (Linux/3.1.0-rc9+; KDE/4.6.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <1318875227.10091.5.camel@localhost.localdomain>
In-Reply-To: <1318875227.10091.5.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201110171136.06619.dtor@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, October 17, 2011 11:13:47 AM Rakib Mullick wrote:
>  In vmballoon_reserve_page function, flags has been passed from the
> callee function (vmballoon_inflate here). So, we can determine
> can_sleep outside the loop.
> 
> Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>

Thanks Rakib.

Acked-by: Dmitry Torokhov <dtor@vmware.com>

> ---
> 
> diff --git a/drivers/misc/vmw_balloon.c b/drivers/misc/vmw_balloon.c
> index 053d36c..6983d80 100644
> --- a/drivers/misc/vmw_balloon.c
> +++ b/drivers/misc/vmw_balloon.c
> @@ -412,6 +412,7 @@ static int vmballoon_reserve_page(struct vmballoon
> *b, bool can_sleep) gfp_t flags;
>  	unsigned int hv_status;
>  	bool locked = false;
> +	flags = can_sleep ? VMW_PAGE_ALLOC_CANSLEEP : VMW_PAGE_ALLOC_NOSLEEP;
> 
>  	do {
>  		if (!can_sleep)
> @@ -419,7 +420,6 @@ static int vmballoon_reserve_page(struct vmballoon
> *b, bool can_sleep) else
>  			STATS_INC(b->stats.sleep_alloc);
> 
> -		flags = can_sleep ? VMW_PAGE_ALLOC_CANSLEEP : 
VMW_PAGE_ALLOC_NOSLEEP;
>  		page = alloc_page(flags);
>  		if (!page) {
>  			if (!can_sleep)
