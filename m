Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758120Ab1KRPs2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 10:48:28 -0500
Received: from exchange.solarflare.com ([216.237.3.220]:31693 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905Ab1KRPs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 10:48:27 -0500
Message-ID: <1321631298.2885.119.camel@deadeye>
Subject: Re: [PATCH] net: Use kmemdup rather than duplicating its
 implementation
From: Ben Hutchings <bhutchings@solarflare.com>
To: Thomas Meyer <thomas@m3y3r.de>
CC: <samuel@sortiz.org>, <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Date: Fri, 18 Nov 2011 15:48:18 +0000
In-Reply-To: <1321569820.1624.307.camel@localhost.localdomain>
References: <1321569820.1624.307.camel@localhost.localdomain>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3-2 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [88.96.1.126]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-18526.005
X-TM-AS-Result: No--11.029500-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-OriginalArrivalTime: 18 Nov 2011 15:48:27.0068 (UTC) FILETIME=[830FF7C0:01CCA609]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-17 at 23:43 +0100, Thomas Meyer wrote:
> The semantic patch that makes this change is available
> in scripts/coccinelle/api/memdup.cocci.
> 
> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
> ---

Similarly this is for the specific driver 'irttp' and not generally
'net'.

Ben.

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
> -	memcpy(new, orig, sizeof(struct tsap_cb));
>  	spin_lock_init(&new->lock);
>  
>  	/* We don't need the old instance any more */

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

