Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095Ab0K3Oge (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 09:36:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51307 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936Ab0K3Ogd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 09:36:33 -0500
Date: Tue, 30 Nov 2010 09:36:31 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add rb_next in block throttle
Message-ID: <20101130143631.GC26758@redhat.com>
References: <AANLkTimV=6=Je=k6UW=ivJtmR0ONoTrscM2i8YJd5JjA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimV=6=Je=k6UW=ivJtmR0ONoTrscM2i8YJd5JjA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 26, 2010 at 10:06:27PM +0800, Hillf Danton wrote:
> When selecting group for dispatching, the first entry of the service
> tree is sequentially dequeued, then the first entry is recomputed by
> calling rb_first().
> 
> When the first is removed from service tree, new first could also be
> computed with rb_next(), since it could be faster than rb_first in
> this special environment.
> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---

Ok. So set the leftmost element with the help of rb_next() at the time of
deletion of existing leftmost element. Not sure whether it is cheaper or
not but does not harm doing it this way.

Have you tested it to make sure nothing is broken?

Thanks
Vivek

> 
> --- a/block/blk-throttle.c	2010-11-01 19:54:12.000000000 +0800
> +++ b/block/blk-throttle.c	2010-11-26 21:27:40.000000000 +0800
> @@ -251,7 +251,7 @@ static void rb_erase_init(struct rb_node
>  static void throtl_rb_erase(struct rb_node *n, struct throtl_rb_root *root)
>  {
>  	if (root->left == n)
> -		root->left = NULL;
> +		root->left = rb_next(n);
>  	rb_erase_init(n, &root->rb);
>  	--root->count;
>  }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
