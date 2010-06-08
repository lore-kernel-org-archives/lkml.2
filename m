Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751629Ab0FHEpA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 00:45:00 -0400
Received: from smtp-out.google.com ([216.239.44.51]:41589 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab0FHEo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 00:44:59 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type;
	b=rQtuZ7xVrvnyQPXwzw8molJGEedTdzIRLZn3KZCBAKXw0jMO9soJBwxwuGQzgJ+km
	ebaiImgR3SVybXUXaHvLQ==
Date: Mon, 7 Jun 2010 21:44:51 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Joe Perches <joe@perches.com>
cc: Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/12] arch/cris: Remove unnecessary kmalloc casts
In-Reply-To: <d3966486cc145e7eebdb8ee11d10ed928e2203b1.1275968594.git.joe@perches.com>
Message-ID: <alpine.DEB.2.00.1006072143560.28717@chino.kir.corp.google.com>
References: <cover.1275968594.git.joe@perches.com> <d3966486cc145e7eebdb8ee11d10ed928e2203b1.1275968594.git.joe@perches.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jun 2010, Joe Perches wrote:

> And separate declaration from allocation
> Still no error checking on failure, but it probably doesn't matter.
> 
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

Why not fix the checkpatch failures at the same time?

ERROR: "foo* bar" should be "foo *bar"
#26: FILE: arch/cris/arch-v32/mm/intmem.c:36:
+		struct intmem_allocation* alloc;

ERROR: "foo* bar" should be "foo *bar"
#38: FILE: arch/cris/arch-v32/mm/intmem.c:65:
+				struct intmem_allocation* alloc;
