Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758102Ab1KRPrc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 10:47:32 -0500
Received: from mail.solarflare.com ([216.237.3.220]:31636 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757979Ab1KRPra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 10:47:30 -0500
Message-ID: <1321631242.2885.118.camel@deadeye>
Subject: Re: [PATCH] ethtool: Use kmemdup rather than duplicating its
 implementation
From: Ben Hutchings <bhutchings@solarflare.com>
To: Thomas Meyer <thomas@m3y3r.de>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Date: Fri, 18 Nov 2011 15:47:22 +0000
In-Reply-To: <1321571135.1624.313.camel@localhost.localdomain>
References: <1321571135.1624.313.camel@localhost.localdomain>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3-2 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [88.96.1.126]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-18526.005
X-TM-AS-Result: No--17.560600-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-OriginalArrivalTime: 18 Nov 2011 15:47:30.0521 (UTC) FILETIME=[615B9490:01CCA609]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-11-18 at 00:05 +0100, Thomas Meyer wrote:
> The semantic patch that makes this change is available
> in scripts/coccinelle/api/memdup.cocci.
> 
> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
> ---

The one-line description should refer to 'gianfar', not 'ethtool'.
(I expect David will fix this up.)

Ben.

> diff -u -p a/drivers/net/ethernet/freescale/gianfar_ethtool.c b/drivers/net/ethernet/freescale/gianfar_ethtool.c
> --- a/drivers/net/ethernet/freescale/gianfar_ethtool.c 2011-11-07 19:37:57.036756543 +0100
> +++ b/drivers/net/ethernet/freescale/gianfar_ethtool.c 2011-11-08 10:42:14.842512269 +0100
> @@ -1410,10 +1410,9 @@ static int gfar_optimize_filer_masks(str
>  
>  	/* We need a copy of the filer table because
>  	 * we want to change its order */
> -	temp_table = kmalloc(sizeof(*temp_table), GFP_KERNEL);
> +	temp_table = kmemdup(tab, sizeof(*temp_table), GFP_KERNEL);
>  	if (temp_table == NULL)
>  		return -ENOMEM;
> -	memcpy(temp_table, tab, sizeof(*temp_table));
>  
>  	mask_table = kcalloc(MAX_FILER_CACHE_IDX / 2 + 1,
>  			sizeof(struct gfar_mask_entry), GFP_KERNEL);
> 


-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

