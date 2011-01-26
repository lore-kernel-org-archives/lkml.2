Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab1AZRoa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 12:44:30 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:50688 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802Ab1AZRo2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 12:44:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=tbb8UxhwEiVElY+pLgTJTjWtrTXx71sjzndc7UA9qa6/bSeTEt0t9K9chy3g4L7Q10
         WZjUEo2T2Is9HTJS2tS2JG/CTRbZNLp7UtfXq5IQuIlMbmxggFWMP688T1hdclSZ9WlJ
         qygJ3iq0/rJNrHwvtLgamf4ZqHy13huu5sxCA=
MIME-Version: 1.0
In-Reply-To: <20110126172605.GG8446@linux.vnet.ibm.com>
References: <20110126172148.GB8446@linux.vnet.ibm.com>
	<20110126172605.GG8446@linux.vnet.ibm.com>
Date: Wed, 26 Jan 2011 19:44:27 +0200
X-Google-Sender-Auth: BkNt_iajSDb5_o3SHqHKLY-FZ7s
Message-ID: <AANLkTi=w2Mq102MM=57y6P=YWQ_iUX5rx7oLaabGkCPj@mail.gmail.com>
Subject: Re: [PATCH 5/7] zram/xvmalloc: wrap debug code in #ifdef DEBUG
From: Pekka Enberg <penberg@kernel.org>
To: Nitin Gupta <ngupta@vflare.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        Pekka Enberg <penberg@cs.helsinki.fi>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Robert Jennings <rcj@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 7:26 PM, Robert Jennings <rcj@linux.vnet.ibm.com> wrote:
> This wraps the code, noted by comments as being debug code, with
> #ifdef DEBUG so that it is removed from running in non-debug kernels.
>
> Signed-off-by: Robert Jennings <rcj@linux.vnet.ibm.com>
> ---
>  drivers/staging/zram/xvmalloc.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/staging/zram/xvmalloc.c b/drivers/staging/zram/xvmalloc.c
> index b3622f1..172514e 100644
> --- a/drivers/staging/zram/xvmalloc.c
> +++ b/drivers/staging/zram/xvmalloc.c
> @@ -219,7 +219,6 @@ static void insert_block(struct xv_pool *pool, struct page *page, u32 offset,
>  static void remove_block_head(struct xv_pool *pool,
>                        struct block_header *block, u32 slindex)
>  {
> -       struct block_header *tmpblock;
>        u32 flindex = slindex / BITS_PER_LONG;
>
>        pool->freelist[slindex].page = block->link.next_page;
> @@ -232,6 +231,8 @@ static void remove_block_head(struct xv_pool *pool,
>                if (!pool->slbitmap[flindex])
>                        __clear_bit(flindex, &pool->flbitmap);
>        } else {
> +#ifdef DEBUG

Shouldn't that be something people can enable from Kconfig?

> +               struct block_header *tmpblock;
>                /*
>                 * DEBUG ONLY: We need not reinitialize freelist head previous
>                 * pointer to 0 - we never depend on its value. But just for
> @@ -242,6 +243,7 @@ static void remove_block_head(struct xv_pool *pool,
>                tmpblock->link.prev_page = 0;
>                tmpblock->link.prev_offset = 0;
>                put_ptr_atomic(tmpblock, KM_USER1);
> +#endif
>        }
>  }
>
> --
> 1.6.0.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
