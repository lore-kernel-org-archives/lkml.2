Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208Ab2J2BrQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 21:47:16 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:47743 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907Ab2J2BrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 21:47:15 -0400
X-AuditID: 9c93016f-b7c7bae000000eb7-9a-508de0206887
Date: Mon, 29 Oct 2012 10:52:59 +0900
From: Minchan Kim <minchan@kernel.org>
To: Joonsoo Kim <js1304@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 2/5] mm, highmem: remove useless pool_lock
Message-ID: <20121029015259.GG15767@bbox>
References: <Yes>
 <1351451576-2611-1-git-send-email-js1304@gmail.com>
 <1351451576-2611-3-git-send-email-js1304@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351451576-2611-3-git-send-email-js1304@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 04:12:53AM +0900, Joonsoo Kim wrote:
> The pool_lock protects the page_address_pool from concurrent access.
> But, access to the page_address_pool is already protected by kmap_lock.
> So remove it.
> 
> Signed-off-by: Joonsoo Kim <js1304@gmail.com>
Reviewed-by: Minchan Kin <minchan@kernel.org>

Looks good to me.
Just a nitpick.

Please write comment about locking rule like below.

> 
> diff --git a/mm/highmem.c b/mm/highmem.c
> index b3b3d68..017bad1 100644
> --- a/mm/highmem.c
> +++ b/mm/highmem.c
> @@ -328,7 +328,6 @@ struct page_address_map {
>   * page_address_map freelist, allocated from page_address_maps.
>   */

/* page_address_pool is protected by kmap_lock */

>  static struct list_head page_address_pool;	/* freelist */
> -static spinlock_t pool_lock;			/* protects page_address_pool */
>  

-- 
Kind regards,
Minchan Kim
