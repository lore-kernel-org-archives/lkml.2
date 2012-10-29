Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739Ab2J2FGy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 01:06:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:44095 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760Ab2J2FGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 01:06:53 -0400
Subject: Re: [PATCH] async_tx: use memchr_inv
From: Vinod Koul <vkoul@infradead.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: vinod.koul@intel.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Dan Williams <djbw@fb.com>
In-Reply-To: <1351352973-3719-4-git-send-email-akinobu.mita@gmail.com>
References: <1351352973-3719-1-git-send-email-akinobu.mita@gmail.com>
	 <1351352973-3719-4-git-send-email-akinobu.mita@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Oct 2012 10:23:43 +0530
Message-ID: <1351486423.7077.31.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-10-28 at 00:49 +0900, Akinobu Mita wrote:
> Use memchr_inv() to check the specified page is filled with zero.
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Dan Williams <djbw@fb.com>
> ---
Looks fine to me, need Dan;s ack before applying

>  crypto/async_tx/async_xor.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
> index 154cc84..8ade0a0 100644
> --- a/crypto/async_tx/async_xor.c
> +++ b/crypto/async_tx/async_xor.c
> @@ -230,9 +230,7 @@ EXPORT_SYMBOL_GPL(async_xor);
>  
>  static int page_is_zero(struct page *p, unsigned int offset, size_t len)
>  {
> -	char *a = page_address(p) + offset;
> -	return ((*(u32 *) a) == 0 &&
> -		memcmp(a, a + 4, len - 4) == 0);
> +	return !memchr_inv(page_address(p) + offset, 0, len);
>  }
>  
>  static inline struct dma_chan *


-- 
Vinod Koul
Intel Corp.

