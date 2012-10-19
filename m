Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758138Ab2JSNzB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 09:55:01 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:59574 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755605Ab2JSNy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 09:54:59 -0400
Date: Fri, 19 Oct 2012 09:54:54 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        kosaki.motohiro@gmail.com, akpm@linux-foundation.org
Subject: Re: [PATCH] mm: Simplify for_each_populated_zone()
Message-ID: <20121019135454.GJ31863@cmpxchg.org>
References: <20121019105546.9704.93446.stgit@srivatsabhat.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121019105546.9704.93446.stgit@srivatsabhat.in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2012 at 04:25:47PM +0530, Srivatsa S. Bhat wrote:
> Move the check for populated_zone() to the control statement of the
> 'for' loop and get rid of the odd looking if/else block.
> 
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> ---
> 
>  include/linux/mmzone.h |    7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 50aaca8..5bdf02e 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -913,11 +913,8 @@ extern struct zone *next_zone(struct zone *zone);
>  
>  #define for_each_populated_zone(zone)		        \
>  	for (zone = (first_online_pgdat())->node_zones; \
> -	     zone;					\
> -	     zone = next_zone(zone))			\
> -		if (!populated_zone(zone))		\
> -			; /* do nothing */		\
> -		else
> +	     zone && populated_zone(zone);		\
> +	     zone = next_zone(zone))

I don't think we want to /abort/ the loop when encountering an
unpopulated zone.
