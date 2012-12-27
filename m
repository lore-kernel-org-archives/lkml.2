Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751841Ab2L0B7X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 20:59:23 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:59265 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956Ab2L0B7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 20:59:20 -0500
Date: Wed, 26 Dec 2012 17:59:18 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Michal Nazarewicz <mpn@google.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cma: use unsigned type for count argument
In-Reply-To: <xa1tip7u14tq.fsf@mina86.com>
Message-ID: <alpine.DEB.2.00.1212261755450.4150@chino.kir.corp.google.com>
References: <52fd3c7b677ff01f1cd6d54e38a567b463ec1294.1355938871.git.mina86@mina86.com> <20121220153525.97841100.akpm@linux-foundation.org> <alpine.DEB.2.00.1212201557270.13223@chino.kir.corp.google.com> <xa1tip7u14tq.fsf@mina86.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Dec 2012, Michal Nazarewicz wrote:

> So I think just adding the following, should be sufficient to make
> everyone happy:
> 
> diff --git a/drivers/base/dma-contiguous.c b/drivers/base/dma-contiguous.c
> index e34e3e0..e91743b 100644
> --- a/drivers/base/dma-contiguous.c
> +++ b/drivers/base/dma-contiguous.c
> @@ -320,7 +320,7 @@ struct page *dma_alloc_from_contiguous(struct device *dev, unsigned int count,
>  	pr_debug("%s(cma %p, count %u, align %u)\n", __func__, (void *)cma,
>  		 count, align);
>  
> -	if (!count)
> +	if (!count || count > INT_MAX)
>  		return NULL;
>  
>  	mask = (1 << align) - 1;

How is this different than leaving the formal to have a signed type, i.e. 
drop your patch, and testing for count <= 0 instead?
