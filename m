Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382Ab1JTFgh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 01:36:37 -0400
Received: from smtp-out.google.com ([74.125.121.67]:29406 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871Ab1JTFgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 01:36:35 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=eax8NG/5p6DajmEXq0vY+xX2toc9K3sF9kY5k+rM4jJ09aV/Gpsq6Y8RHGN2LYUrC
	7hZaZD38MYfJO9mVsKrtQ==
Date: Wed, 19 Oct 2011 22:36:30 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ian Campbell <Ian.Campbell@citrix.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "jaxboe@fusionio.com" <jaxboe@fusionio.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] mm: add a "struct page_frag" type containing a page,
 offset and length
In-Reply-To: <1318927778.16132.52.camel@zakaz.uk.xensource.com>
Message-ID: <alpine.DEB.2.00.1110192236080.4618@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1110131327470.24853@chino.kir.corp.google.com> <20111013.163708.1319779926961023813.davem@davemloft.net> <alpine.DEB.2.00.1110131348310.24853@chino.kir.corp.google.com> <20111013.165148.64222593458932960.davem@davemloft.net>
 <20111013142201.355f9afc.akpm@linux-foundation.org> <1318575363.11016.8.camel@dagon.hellion.org.uk> <1318927778.16132.52.camel@zakaz.uk.xensource.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Oct 2011, Ian Campbell wrote:

> From 806b74572ad63e2ed3ca69bb5640a55dc4475e73 Mon Sep 17 00:00:00 2001
> From: Ian Campbell <ian.campbell@citrix.com>
> Date: Mon, 3 Oct 2011 16:46:54 +0100
> Subject: [PATCH] mm: add a "struct page_frag" type containing a page, offset and length
> 
> A few network drivers currently use skb_frag_struct for this purpose but I have
> patches which add additional fields and semantics there which these other uses
> do not want.
> 
> A structure for reference sub-page regions seems like a generally useful thing
> so do so instead of adding a network subsystem specific structure.
> 
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> Acked-by: Jens Axboe <jaxboe@fusionio.com>
> Acked-by: David Rientjes <rientjes@google.com>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: David Miller <davem@davemloft.net>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> [since v1: s/struct subpage/struct page_frag/ on advice from Christoph]
> [since v2: s/page_offset/offset/ on advice from Andrew]

Looks good, is this going to be going through net-next?

> ---
>  include/linux/mm_types.h |   11 +++++++++++
>  1 files changed, 11 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 774b895..29971a5 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -135,6 +135,17 @@ struct page {
>  #endif
>  ;
>  
> +struct page_frag {
> +	struct page *page;
> +#if (BITS_PER_LONG > 32) || (PAGE_SIZE >= 65536)
> +	__u32 offset;
> +	__u32 size;
> +#else
> +	__u16 offset;
> +	__u16 size;
> +#endif
> +};
> +
>  typedef unsigned long __nocast vm_flags_t;
>  
>  /*
