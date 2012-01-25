Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011Ab2AYTBi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 14:01:38 -0500
Received: from gir.skynet.ie ([193.1.99.77]:45563 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751200Ab2AYTBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 14:01:36 -0500
Date: Wed, 25 Jan 2012 19:01:35 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Michal Kubecek <mkubecek@suse.cz>, JBeulich@suse.com
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] agp: fix scratch page cleanup
In-Reply-To: <20120125161350.82538402A7@alaris.suse.cz>
Message-ID: <alpine.DEB.2.00.1201251900330.12477@skynet.skynet.ie>
References: <20120125161350.82538402A7@alaris.suse.cz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> In error cleanup of agp_backend_initialize() and in agp_backend_cleanup(),
> agp_destroy_page() is passed virtual address of the scratch page. This
> leads to a kernel warning if the initialization fails (or upon regular
> cleanup) as pointer to struct page should be passed instead.

Jan can you check and ack this if okay? since you wrote this chunk 
originally?

Dave.

> 
> Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
> ---
>  drivers/char/agp/backend.c |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/char/agp/backend.c b/drivers/char/agp/backend.c
> index 4b71647..317c28c 100644
> --- a/drivers/char/agp/backend.c
> +++ b/drivers/char/agp/backend.c
> @@ -194,10 +194,10 @@ static int agp_backend_initialize(struct agp_bridge_data *bridge)
>  
>  err_out:
>  	if (bridge->driver->needs_scratch_page) {
> -		void *va = page_address(bridge->scratch_page_page);
> +		struct page *page = bridge->scratch_page_page;
>  
> -		bridge->driver->agp_destroy_page(va, AGP_PAGE_DESTROY_UNMAP);
> -		bridge->driver->agp_destroy_page(va, AGP_PAGE_DESTROY_FREE);
> +		bridge->driver->agp_destroy_page(page, AGP_PAGE_DESTROY_UNMAP);
> +		bridge->driver->agp_destroy_page(page, AGP_PAGE_DESTROY_FREE);
>  	}
>  	if (got_gatt)
>  		bridge->driver->free_gatt_table(bridge);
> @@ -221,10 +221,10 @@ static void agp_backend_cleanup(struct agp_bridge_data *bridge)
>  
>  	if (bridge->driver->agp_destroy_page &&
>  	    bridge->driver->needs_scratch_page) {
> -		void *va = page_address(bridge->scratch_page_page);
> +		struct page *page = bridge->scratch_page_page;
>  
> -		bridge->driver->agp_destroy_page(va, AGP_PAGE_DESTROY_UNMAP);
> -		bridge->driver->agp_destroy_page(va, AGP_PAGE_DESTROY_FREE);
> +		bridge->driver->agp_destroy_page(page, AGP_PAGE_DESTROY_UNMAP);
> +		bridge->driver->agp_destroy_page(page, AGP_PAGE_DESTROY_FREE);
>  	}
>  }
>  
> 
