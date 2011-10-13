Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977Ab1JMUdz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 16:33:55 -0400
Received: from smtp-out.google.com ([74.125.121.67]:19370 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab1JMUdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 16:33:53 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=DzvohmY1vzxbdXU0q3xSr0dwiDk4E4juVMrF52gAl1JTv/+DT6xwwV7GKAlsW3sFT
	yIJZpLjZkrgp5B74ypOKg==
Date: Thu, 13 Oct 2011 13:33:45 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ian Campbell <ian.campbell@citrix.com>
cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <jaxboe@fusionio.com>, linux-mm@kvack.org
Subject: Re: [PATCH] mm: add a "struct page_frag" type containing a page,
 offset and length
In-Reply-To: <1318500176-10728-1-git-send-email-ian.campbell@citrix.com>
Message-ID: <alpine.DEB.2.00.1110131327470.24853@chino.kir.corp.google.com>
References: <1318500176-10728-1-git-send-email-ian.campbell@citrix.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Oct 2011, Ian Campbell wrote:

> A few network drivers currently use skb_frag_struct for this purpose but I have
> patches which add additional fields and semantics there which these other uses
> do not want.
> 

Is this patch a part of a larger series that actually uses 
struct page_frag?  Probably a good idea to post them so we know it doesn't 
just lie there dormant.

> A structure for reference sub-page regions seems like a generally useful thing
> so do so instead of adding a network subsystem specific structure.
> 

Agreed.

> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Jens Axboe <jaxboe@fusionio.com>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> [since v1: s/struct subpage/struct page_frag/ on advice from Christoph]

Acked-by: David Rientjes <rientjes@google.com>

> ---
>  include/linux/mm_types.h |   11 +++++++++++
>  1 files changed, 11 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 774b895..575faaf 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -135,6 +135,17 @@ struct page {
>  #endif
>  ;
>  
> +struct page_frag {
> +	struct page *page;
> +#if (BITS_PER_LONG > 32) || (PAGE_SIZE >= 65536)
> +	__u32 page_offset;
> +	__u32 size;
> +#else
> +	__u16 page_offset;
> +	__u16 size;
> +#endif
> +};
> +
>  typedef unsigned long __nocast vm_flags_t;
>  
>  /*
