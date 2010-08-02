Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958Ab0HBPx2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 11:53:28 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:45137 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887Ab0HBPxZ (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 2 Aug 2010 11:53:25 -0400
Date: Mon, 2 Aug 2010 11:52:48 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH -next] swiotlb: make io_tlb_overflow static
Message-ID: <20100802155248.GA9177@phenom.dumpdata.com>
References: <20100802234722U.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100802234722U.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4C56E9F1.012B:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 02, 2010 at 11:48:06PM +0900, FUJITA Tomonori wrote:
> We don't need to export io_tlb_overflow_buffer. I'll remove
> io_tlb_overflow_buffer completely in the long term though.

<nods>

> This can be applied to:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/konrad/swiotlb-2.6.git
> 
> =
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Subject: [PATCH] swiotlb: make io_tlb_overflow static
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

I've stuck it in a new branch (devel/swiotlb-0.9).

> ---
>  lib/swiotlb.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/lib/swiotlb.c b/lib/swiotlb.c
> index a009055..72c382c 100644
> --- a/lib/swiotlb.c
> +++ b/lib/swiotlb.c
> @@ -78,7 +78,7 @@ static unsigned long io_tlb_nslabs;
>   */
>  static unsigned long io_tlb_overflow = 32*1024;
>  
> -void *io_tlb_overflow_buffer;
> +static void *io_tlb_overflow_buffer;
>  
>  /*
>   * This is a free list describing the number of free entries available from
> -- 
> 1.6.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
