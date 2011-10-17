Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617Ab1JQTbw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 15:31:52 -0400
Received: from smtp-out.google.com ([74.125.121.67]:4315 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534Ab1JQTbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 15:31:50 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=v8zEpoNAorBPqaPjsOIsiOtxikEyPlOTERxhWOdV57ZBIfNvBIojTPagH+qqsnc1b
	D3c6HktRf4cYr/p95JjzA==
Date: Mon, 17 Oct 2011 12:31:45 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Rakib Mullick <rakib.mullick@gmail.com>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Dmitry Torokhov <dtor@vmware.com>
Subject: Re: [PATCH] drivers, vmw_balloon.c: Determine page allocation flag
 can_sleep outside loop.
In-Reply-To: <1318875227.10091.5.camel@localhost.localdomain>
Message-ID: <alpine.DEB.2.00.1110171231030.12560@chino.kir.corp.google.com>
References: <1318875227.10091.5.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Oct 2011, Rakib Mullick wrote:

> diff --git a/drivers/misc/vmw_balloon.c b/drivers/misc/vmw_balloon.c
> index 053d36c..6983d80 100644
> --- a/drivers/misc/vmw_balloon.c
> +++ b/drivers/misc/vmw_balloon.c
> @@ -412,6 +412,7 @@ static int vmballoon_reserve_page(struct vmballoon *b, bool can_sleep)
>  	gfp_t flags;
>  	unsigned int hv_status;
>  	bool locked = false;
> +	flags = can_sleep ? VMW_PAGE_ALLOC_CANSLEEP : VMW_PAGE_ALLOC_NOSLEEP;
>  
>  	do {
>  		if (!can_sleep)

Should be folded in with the declaration of gfp_t flags.

Would you also like to add a might_sleep_if(can_sleep) here?

> @@ -419,7 +420,6 @@ static int vmballoon_reserve_page(struct vmballoon *b, bool can_sleep)
>  		else
>  			STATS_INC(b->stats.sleep_alloc);
>  
> -		flags = can_sleep ? VMW_PAGE_ALLOC_CANSLEEP : VMW_PAGE_ALLOC_NOSLEEP;
>  		page = alloc_page(flags);
>  		if (!page) {
>  			if (!can_sleep)
