Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756493Ab1FGTgN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 15:36:13 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:18171 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754459Ab1FGTgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 15:36:12 -0400
Date: Tue, 7 Jun 2011 12:35:23 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, thomas@shipmail.org,
        dri-devel@lists.freedesktop.org, Jerome Glisse <j.glisse@redhat.com>,
        Dave Airlie <airlied@redhat.com>, David Airlie <airlied@linux.ie>
Subject: Re: [PATCH] ttm: Fix spelling mistakes and remove unused #ifdef
Message-Id: <20110607123523.319dd6fe.randy.dunlap@oracle.com>
In-Reply-To: <1307471752-1248-2-git-send-email-konrad.wilk@oracle.com>
References: <1307471752-1248-1-git-send-email-konrad.wilk@oracle.com>
	<1307471752-1248-2-git-send-email-konrad.wilk@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090209.4DEE7D87.01B6:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  7 Jun 2011 14:35:52 -0400 Konrad Rzeszutek Wilk wrote:

> . and some comments to make it easier to understand.
> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  drivers/gpu/drm/ttm/ttm_page_alloc.c |   14 +++++++-------
>  include/drm/ttm/ttm_bo_api.h         |    3 ---
>  include/drm/ttm/ttm_bo_driver.h      |    6 +++---
>  include/drm/ttm/ttm_memory.h         |    2 +-
>  include/drm/ttm/ttm_object.h         |    4 ++--
>  include/drm/ttm/ttm_page_alloc.h     |    2 +-
>  6 files changed, 14 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/gpu/drm/ttm/ttm_page_alloc.c b/drivers/gpu/drm/ttm/ttm_page_alloc.c
> index 9d9d929..3277965 100644
> --- a/drivers/gpu/drm/ttm/ttm_page_alloc.c
> +++ b/drivers/gpu/drm/ttm/ttm_page_alloc.c
> @@ -355,7 +355,7 @@ restart:
>  			if (nr_free)
>  				goto restart;
>  
> -			/* Not allowed to fall tough or break because
> +			/* Not allowed to fall through or break because
>  			 * following context is inside spinlock while we are
>  			 * outside here.
>  			 */
> @@ -554,7 +554,7 @@ out:
>  }
>  
>  /**
> - * Fill the given pool if there isn't enough pages and requested number of
> + * Fill the given pool if there isn't enough pages and the requested number of

                                   aren't

>   * pages is small.
>   */
>  static void ttm_page_pool_fill_locked(struct ttm_page_pool *pool,
> @@ -575,7 +575,7 @@ static void ttm_page_pool_fill_locked(struct ttm_page_pool *pool,
>  	pool->fill_lock = true;
>  
>  	/* If allocation request is small and there is not enough

	                                            are not enough

> -	 * pages in pool we fill the pool first */
> +	 * pages in a pool we fill the pool up first. */
>  	if (count < _manager->options.small
>  		&& count > pool->npages) {
>  		struct list_head new_pages;
> @@ -612,9 +612,9 @@ static void ttm_page_pool_fill_locked(struct ttm_page_pool *pool,
>  }
>  
>  /**
> - * Cut count nubmer of pages from the pool and put them to return list
> + * Cut out a number of pages from the pool and put them on the return list.

No, it wants 'count' or <count> in there, like:

 * Cut 'count' number of pages from the pool and put them on the return list.

>   *
> - * @return count of pages still to allocate to fill the request.
> + * @return count of pages still required to fulfill the request.
>   */
>  static unsigned ttm_page_pool_get_pages(struct ttm_page_pool *pool,
>  		struct list_head *pages, int ttm_flags,
> @@ -635,7 +635,7 @@ static unsigned ttm_page_pool_get_pages(struct ttm_page_pool *pool,
>  		goto out;
>  	}
>  	/* find the last pages to include for requested number of pages. Split
> -	 * pool to begin and halves to reduce search space. */
> +	 * pool to begin and halve it to reduce search space. */
>  	if (count <= pool->npages/2) {
>  		i = 0;
>  		list_for_each(p, &pool->list) {
> @@ -649,7 +649,7 @@ static unsigned ttm_page_pool_get_pages(struct ttm_page_pool *pool,
>  				break;
>  		}
>  	}
> -	/* Cut count number of pages from pool */
> +	/* Cut the count number of pages from the pool */

Not any better IMO.  How about:
	/* Cut <count> number of pages from the pool */
or
	/* Cut 'count' number of pages from the pool */

>  	list_cut_position(pages, &pool->list, p);
>  	pool->npages -= count;
>  	count = 0;

[snip]



---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
