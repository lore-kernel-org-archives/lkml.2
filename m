Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752Ab1HUBMr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 21:12:47 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53847 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478Ab1HUBMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 21:12:46 -0400
Date: Sun, 21 Aug 2011 02:12:40 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Dr. David Alan Gilbert" <linux@treblig.org>
Cc: linux-kernel@vger.kernel.org, nicolas.ferre@atmel.com,
        dan.j.williams@intel.com, akpm@linux-foundation.org
Subject: Re: [PATCH] Fix missing 'cnt' in ?: in dmatest
Message-ID: <20110821011240.GG2203@ZenIV.linux.org.uk>
References: <20110821005031.GB10377@gallifrey>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110821005031.GB10377@gallifrey>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 21, 2011 at 01:50:31AM +0100, Dr. David Alan Gilbert wrote:

> (WTH is x=y?:z legal C anyway?)

gccism.  It's not legal C; it's a gcc extension, and not a pretty one at
that.  It's almost definitely a bug in this case - what used to be in the
tree is equivalent to cnt > 0 ? cnt > 0 : 0, i.e. cnt > 0 ? 1 : 0, i.e.
cnt > 0.  AFAICS, after your patch it does make sense.

> Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
> 
> ---
> diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
> index 765f5ff..1b0ec9d 100644
> --- a/drivers/dma/dmatest.c
> +++ b/drivers/dma/dmatest.c
> @@ -572,7 +572,7 @@ static int dmatest_add_channel(struct dma_chan *chan)
>  	}
>  	if (dma_has_cap(DMA_PQ, dma_dev->cap_mask)) {
>  		cnt = dmatest_add_threads(dtc, DMA_PQ);
> -		thread_count += cnt > 0 ?: 0;
> +		thread_count += cnt > 0 ? cnt : 0;
>  	}
>  
>  	pr_info("dmatest: Started %u threads using %s\n",
> 
> -- 
>  -----Open up your eyes, open up your mind, open up your code -------   
> / Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
> \ gro.gilbert @ treblig.org |                               | In Hex /
>  \ _________________________|_____ http://www.treblig.org   |_______/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
