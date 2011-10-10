Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719Ab1JJQ1d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 12:27:33 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:58359 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250Ab1JJQ1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 12:27:31 -0400
X-IronPort-AV: E=Sophos;i="4.68,518,1312156800"; 
   d="scan'208";a="8308688"
Subject: Re: [PATCH 1/9] mm: add a "struct subpage" type containing a page,
 offset and length
From: Ian Campbell <Ian.Campbell@citrix.com>
To: "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, "Christoph Hellwig" <hch@infradead.org>
Date: Mon, 10 Oct 2011 17:27:07 +0100
In-Reply-To: <1318245101-16890-1-git-send-email-ian.campbell@citrix.com>
References: <1318245076.21903.408.camel@zakaz.uk.xensource.com>
	 <1318245101-16890-1-git-send-email-ian.campbell@citrix.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1318264027.21903.470.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(reposting including LKML to catch other potential users)

Is this structure of any use to unify other instances of a similar
tuple, e.g. biovec, pagefrag etc?

Ian.

On Mon, 2011-10-10 at 12:11 +0100, Ian Campbell wrote:
> A few network drivers currently use skb_frag_struct for this purpose but I have
> patches which add additional fields and semantics there which these other uses
> do not want.
> 
> A structure for reference sub-page regions seems like a generally useful thing
> so do so instead of adding a network subsystem specific structure.
> 
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> Cc: linux-mm@kvack.org
> ---
>  include/linux/mm_types.h |   11 +++++++++++
>  1 files changed, 11 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 774b895..dc1d103 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -135,6 +135,17 @@ struct page {
>  #endif
>  ;
>  
> +struct subpage {
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


