Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182Ab0FNLEO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 07:04:14 -0400
Received: from krynn.se.axis.com ([193.13.178.10]:38094 "EHLO
	krynn.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756085Ab0FNLEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 07:04:13 -0400
Date: Mon, 14 Jun 2010 12:59:30 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <trivial@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/12] arch/cris: Remove unnecessary kmalloc casts
Message-ID: <20100614105930.GH32506@axis.com>
References: <cover.1275968594.git.joe@perches.com> <d3966486cc145e7eebdb8ee11d10ed928e2203b1.1275968594.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d3966486cc145e7eebdb8ee11d10ed928e2203b1.1275968594.git.joe@perches.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 08, 2010 at 05:50:33AM +0200, Joe Perches wrote:
> And separate declaration from allocation
> Still no error checking on failure, but it probably doesn't matter.

Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>

> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  arch/cris/arch-v32/mm/intmem.c |   13 +++++--------
>  1 files changed, 5 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/cris/arch-v32/mm/intmem.c b/arch/cris/arch-v32/mm/intmem.c
> index 9e8b69c..1b17d92 100644
> --- a/arch/cris/arch-v32/mm/intmem.c
> +++ b/arch/cris/arch-v32/mm/intmem.c
> @@ -33,8 +33,8 @@ static void crisv32_intmem_init(void)
>  {
>  	static int initiated = 0;
>  	if (!initiated) {
> -		struct intmem_allocation* alloc =
> -		  (struct intmem_allocation*)kmalloc(sizeof *alloc, GFP_KERNEL);
> +		struct intmem_allocation* alloc;
> +		alloc = kmalloc(sizeof *alloc, GFP_KERNEL);
>  		INIT_LIST_HEAD(&intmem_allocations);
>  		intmem_virtual = ioremap(MEM_INTMEM_START + RESERVED_SIZE,
>  					 MEM_INTMEM_SIZE - RESERVED_SIZE);
> @@ -62,9 +62,8 @@ void* crisv32_intmem_alloc(unsigned size, unsigned align)
>  		if (allocation->status == STATUS_FREE &&
>  		    allocation->size >= size + alignment) {
>  			if (allocation->size > size + alignment) {
> -				struct intmem_allocation* alloc =
> -					(struct intmem_allocation*)
> -					kmalloc(sizeof *alloc, GFP_ATOMIC);
> +				struct intmem_allocation* alloc;
> +				alloc = kmalloc(sizeof *alloc, GFP_ATOMIC);
>  				alloc->status = STATUS_FREE;
>  				alloc->size = allocation->size - size -
>  					alignment;
> @@ -74,9 +73,7 @@ void* crisv32_intmem_alloc(unsigned size, unsigned align)
>  
>  				if (alignment) {
>  					struct intmem_allocation *tmp;
> -					tmp = (struct intmem_allocation *)
> -						kmalloc(sizeof *tmp,
> -							GFP_ATOMIC);
> +					tmp = kmalloc(sizeof *tmp, GFP_ATOMIC);
>  					tmp->offset = allocation->offset;
>  					tmp->size = alignment;
>  					tmp->status = STATUS_FREE;
> -- 
> 1.7.1.244.gbdc4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
