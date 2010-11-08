Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab0KHMsK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 07:48:10 -0500
Received: from cluster-d.mailcontrol.com ([85.115.60.190]:58542 "EHLO
	cluster-d.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab0KHMsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 07:48:09 -0500
Message-ID: <4CD7F056.6080405@csr.com>
Date: Mon, 08 Nov 2010 12:43:02 +0000
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: Jesper Juhl <jj@chaosbits.net>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg KH <greg@kroah.com>
Subject: Re: [PATCH] UWB: Return UWB_RSV_ALLOC_NOT_FOUND rather than crashing
 on NULL dereference if kzalloc fails
References: <alpine.LNX.2.00.1011072158211.26247@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1011072158211.26247@swampdragon.chaosbits.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Nov 2010 12:43:03.0763 (UTC) FILETIME=[7C261230:01CB7F42]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Juhl wrote:
> Hi,
> 
> Crashing on a null pointer deref is never a nice thing to do. It seems to 
> me that it's better to simply return UWB_RSV_ALLOC_NOT_FOUND if kzalloc() 
> fails in uwb_rsv_find_best_allocation().

This is fine.

struct uwb_rsv_alloc_info is not that large (about 414 bytes I think) so
it could possibly go on the stack and avoid the allocation.

Acked-by: David Vrabel <david.vrabel@csr.com>

Greg, seeing as I'm not maintaining the UWB subsystem any more do you
want to pick this (and future) UWB patches?

David

> I may be wrong since I have no way to test this (except compile test) and 
> this is unknown code to me, so please review carefully.
> 
> Please CC me on replies.
> 
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  allocator.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/uwb/allocator.c b/drivers/uwb/allocator.c
> index 436e4f7..e45e673 100644
> --- a/drivers/uwb/allocator.c
> +++ b/drivers/uwb/allocator.c
> @@ -326,7 +326,8 @@ int uwb_rsv_find_best_allocation(struct uwb_rsv *rsv, struct uwb_mas_bm *availab
>  	int bit_index;
>  
>  	ai = kzalloc(sizeof(struct uwb_rsv_alloc_info), GFP_KERNEL);
> -	
> +	if (!ai)
> +		return UWB_RSV_ALLOC_NOT_FOUND;
>  	ai->min_mas = rsv->min_mas;
>  	ai->max_mas = rsv->max_mas;
>  	ai->max_interval = rsv->max_interval;
-- 
David Vrabel, Senior Software Engineer, Drivers
CSR, Churchill House, Cambridge Business Park,  Tel: +44 (0)1223 692562
Cowley Road, Cambridge, CB4 0WZ                 http://www.csr.com/


Member of the CSR plc group of companies. CSR plc registered in England and Wales, registered number 4187346, registered office Churchill House, Cambridge Business Park, Cowley Road, Cambridge, CB4 0WZ, United Kingdom
