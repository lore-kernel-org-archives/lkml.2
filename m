Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757Ab1AZRzZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 12:55:25 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:39845 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097Ab1AZRzY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 12:55:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Lol8XvoG8oWxHaHaa+Hj5tc9hV9FBodlg5QLsoQZChXYtyAxhumDiZEX6Hg/wWiP6D
         EPyZ+U2+x5vDk12I5n1uknpLXcRBSCZ0cklndoeU961ArlWy/lyZmsueGdpbq0cRraH/
         QhKGgxtWmEZuHBqFEIGQwJCDKV+Ci968vVCVE=
MIME-Version: 1.0
In-Reply-To: <20110126172508.GF8446@linux.vnet.ibm.com>
References: <20110126172148.GB8446@linux.vnet.ibm.com>
	<20110126172508.GF8446@linux.vnet.ibm.com>
Date: Wed, 26 Jan 2011 19:55:23 +0200
X-Google-Sender-Auth: 5y_UWFJAg91xW79DKBBVNePsrj4
Message-ID: <AANLkTi=eM-e9KU0PedOcXqR8TEVeAuP8Vnna-pxO4pRU@mail.gmail.com>
Subject: Re: [PATCH 4/7] zram/xvmalloc: free bit block insertion optimization
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

On Wed, Jan 26, 2011 at 7:25 PM, Robert Jennings <rcj@linux.vnet.ibm.com> wrote:
> There is no need to set the bits in the first- and second-level indices
> to indicate a free page when we know that a free page existed at this
> level.
>
> Signed-off-by: Robert Jennings <rcj@linux.vnet.ibm.com>

Why is it not necessary? I don't know that part of the code well
enough to tell if this patch is safe or not.

> ---
>  drivers/staging/zram/xvmalloc.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/staging/zram/xvmalloc.c b/drivers/staging/zram/xvmalloc.c
> index a507f95..b3622f1 100644
> --- a/drivers/staging/zram/xvmalloc.c
> +++ b/drivers/staging/zram/xvmalloc.c
> @@ -205,6 +205,8 @@ static void insert_block(struct xv_pool *pool, struct page *page, u32 offset,
>                nextblock->link.prev_page = page;
>                nextblock->link.prev_offset = offset;
>                put_ptr_atomic(nextblock, KM_USER1);
> +               /* If there was a next page then the free bits are set. */
> +               return;
>        }
>
>        __set_bit(slindex % BITS_PER_LONG, &pool->slbitmap[flindex]);
> --
> 1.6.0.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
