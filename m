Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757119Ab2IZQi4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 12:38:56 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51545 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754626Ab2IZQiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 12:38:55 -0400
Date: Wed, 26 Sep 2012 09:38:51 -0700
From: Tejun Heo <tj@kernel.org>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alex Dubov <oakad@yahoo.com>,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 1/2] scatterlist: add sg_nents
Message-ID: <20120926163851.GP16296@google.com>
References: <1348652941-31899-1-git-send-email-maximlevitsky@gmail.com>
 <1348652941-31899-2-git-send-email-maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348652941-31899-2-git-send-email-maximlevitsky@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ing Jens)

On Wed, Sep 26, 2012 at 11:49:00AM +0200, Maxim Levitsky wrote:
> Useful helper to know the number of entries in scatterlist.
> 
> Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> ---
>  include/linux/scatterlist.h |    1 +
>  lib/scatterlist.c           |   22 ++++++++++++++++++++++
>  2 files changed, 23 insertions(+)
> 
> diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
> index 7b600da..4bd6c06 100644
> --- a/include/linux/scatterlist.h
> +++ b/include/linux/scatterlist.h
> @@ -201,6 +201,7 @@ static inline void *sg_virt(struct scatterlist *sg)
>  	return page_address(sg_page(sg)) + sg->offset;
>  }
>  
> +int sg_nents(struct scatterlist *sg);
>  struct scatterlist *sg_next(struct scatterlist *);
>  struct scatterlist *sg_last(struct scatterlist *s, unsigned int);
>  void sg_init_table(struct scatterlist *, unsigned int);
> diff --git a/lib/scatterlist.c b/lib/scatterlist.c
> index e76d85c..5cd9cdc 100644
> --- a/lib/scatterlist.c
> +++ b/lib/scatterlist.c
> @@ -39,6 +39,28 @@ struct scatterlist *sg_next(struct scatterlist *sg)
>  EXPORT_SYMBOL(sg_next);
>  
>  /**
> + * sg_nents - return total count of entries in scatterlist
> + * @sg:		The scatterlist
> + *
> + * Description:
> + * Allows to know how many entries are in sg, taking into acount
> + * chaining as well
> + *
> + **/
> +int sg_nents(struct scatterlist *sg)
> +{
> +	int nents = 0;
> +	while (sg) {
> +		nents++;
> +		sg = sg_next(sg);
> +	}
> +
> +	return nents;
> +}
> +EXPORT_SYMBOL(sg_nents);

How about the following instead?

	for (nents = 0; sg; sg = sg_next(sg))
		nents++;
	return nents;

Other than that,

 Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
