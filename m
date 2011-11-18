Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360Ab1KRRc7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 12:32:59 -0500
Received: from mga09.intel.com ([134.134.136.24]:6203 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752194Ab1KRRc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 12:32:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="77356937"
Date: Fri, 18 Nov 2011 09:32:57 -0800
From: Jesse Brandeburg <jesse.brandeburg@intel.com>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: "samuel@sortiz.org" <samuel@sortiz.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: Use kmemdup rather than duplicating its
 implementation
Message-ID: <20111118093257.000059eb@unknown>
In-Reply-To: <1321569820.1624.307.camel@localhost.localdomain>
References: <1321569820.1624.307.camel@localhost.localdomain>
X-Mailer: Claws Mail 3.7.10cvs7 (GTK+ 2.16.6; i586-pc-mingw32msvc)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Nov 2011 14:43:40 -0800
Thomas Meyer <thomas@m3y3r.de> wrote:

> The semantic patch that makes this change is available
> in scripts/coccinelle/api/memdup.cocci.
> 
> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
> ---
> 
> diff -u -p a/net/irda/irttp.c b/net/irda/irttp.c
> --- a/net/irda/irttp.c 2011-11-07 19:39:06.071138486 +0100
> +++ b/net/irda/irttp.c 2011-11-08 10:59:07.152748948 +0100
> @@ -1461,14 +1461,13 @@ struct tsap_cb *irttp_dup(struct tsap_cb
>  	}
>  
>  	/* Allocate a new instance */
> -	new = kmalloc(sizeof(struct tsap_cb), GFP_ATOMIC);
> +	new = kmemdup(orig, sizeof(struct tsap_cb), GFP_ATOMIC);
>  	if (!new) {
>  		IRDA_DEBUG(0, "%s(), unable to kmalloc\n", __func__);
>  		spin_unlock_irqrestore(&irttp->tsaps->hb_spinlock, flags);
>  		return NULL;
>  	}
>  	/* Dup */

this ^^^ comment should be removed also.

> -	memcpy(new, orig, sizeof(struct tsap_cb));
>  	spin_lock_init(&new->lock);
>  
>  	/* We don't need the old instance any more */
