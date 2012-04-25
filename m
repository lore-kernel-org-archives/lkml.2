Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758759Ab2DYN1X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 09:27:23 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:39717 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655Ab2DYN1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 09:27:20 -0400
Message-ID: <4F97FBB1.1090001@vflare.org>
Date: Wed, 25 Apr 2012 09:27:13 -0400
From: Nitin Gupta <ngupta@vflare.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 4/6] zsmalloc: add/fix function comment
References: <1335334994-22138-1-git-send-email-minchan@kernel.org> <1335334994-22138-5-git-send-email-minchan@kernel.org>
In-Reply-To: <1335334994-22138-5-git-send-email-minchan@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2012 02:23 AM, Minchan Kim wrote:

> Add/fix the comment.
> 
> Signed-off-by: Minchan Kim <minchan@kernel.org>
> ---
>  drivers/staging/zsmalloc/zsmalloc-main.c |   15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/zsmalloc/zsmalloc-main.c b/drivers/staging/zsmalloc/zsmalloc-main.c
> index 0fe4cbb..b7d31cc 100644
> --- a/drivers/staging/zsmalloc/zsmalloc-main.c
> +++ b/drivers/staging/zsmalloc/zsmalloc-main.c
> @@ -565,12 +565,9 @@ EXPORT_SYMBOL_GPL(zs_destroy_pool);
>   * zs_malloc - Allocate block of given size from pool.
>   * @pool: pool to allocate from
>   * @size: size of block to allocate
> - * @page: page no. that holds the object
> - * @offset: location of object within page
>   *
>   * On success, <page, offset> identifies block allocated
> - * and 0 is returned. On failure, <page, offset> is set to
> - * 0 and -ENOMEM is returned.
> + * and <page, offset> is returned. On failure, NULL is returned.
>   *


The returned value indeed encodes <page, offset> values as a 'void *'
but this should not be part of the function documentation since its an
internal detail.  So, its probably better to say:

On success, handle to the allocated object is returned; NULL otherwise.

On a side note, we should also 'typedef void * zs_handle' to avoid any
confusion. Without this, users may just treat zs_malloc return value as
a pointer and try to deference it.

>   * Allocation requests with size > ZS_MAX_ALLOC_SIZE will fail.
>   */
> @@ -666,6 +663,16 @@ void zs_free(struct zs_pool *pool, void *obj)
>  }
>  EXPORT_SYMBOL_GPL(zs_free);
>  
> +/**
> + * zs_map_object - get address of allocated object from handle.
> + * @pool: object allocated pool


should be: @pool: pool from which the object was allocated

> + * @handle: handle returned from zs_malloc
> + *

> + * Before using object allocated from zs_malloc, object
> + * should be mapped to page table by this function.
> + * After using object,  call zs_unmap_object to unmap page
> + * table.
> + */


We are not really unmapping any page tables, so could be written as:

Before using an object allocated from zs_malloc, it must be mapped using
this function. When done with the object, it must be unmapped using
zs_unmap_object


Sorry for nitpicking.

Thanks,
Nitin
