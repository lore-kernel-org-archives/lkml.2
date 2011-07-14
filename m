Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737Ab1GNDmj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 23:42:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53043 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753494Ab1GNDmi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 23:42:38 -0400
Date: Thu, 14 Jul 2011 13:42:28 +1000
From: NeilBrown <neilb@suse.de>
To: Muthu Kumar <muthu.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH]:drivers/md/raid10.c: r10buf_pool_alloc(): Set bi_vcnt
 for the new bio.
Message-ID: <20110714134228.65fb79c5@notabene.brown>
In-Reply-To: <CAFR8uecaG68Oifuz1ucpM49vaw5m420Cn0et-JQZjBjhsOes-Q@mail.gmail.com>
References: <CAFR8uecaG68Oifuz1ucpM49vaw5m420Cn0et-JQZjBjhsOes-Q@mail.gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Jul 2011 17:50:32 -0700 Muthu Kumar <muthu.lkml@gmail.com> wrote:

> Hi Neil,
> raid10.c: r10buf_pool_alloc() - doesn't set the bi_vcnt for the newly
> allocated bio. Setting it to RESYNC_PAGES for successful case.

What would be the point of doing that?  When an r10buf allocated in
sync_request(), one of the first things done to it is to initialise it
including setting bi_vcnt to 0.

> 
> BTW, why are we not using bio_add_page() here to add the page to bio?

How would that be useful?  We don't know what the underlying device is at
this point, and the point of bio_add_page is to make sure the device can
handle the extra page.

We do call bio_add_page at the appropriate time in sync_request().

So - not applied.

Thanks,
NeilBrown


> 
> Signed-off-by: Muthukumar R <muthur@gmail.com>
> 
> ------
>  drivers/md/raid10.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> ------
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 6e84668..8504c5b 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -129,6 +129,7 @@ static void * r10buf_pool_alloc(gfp_t gfp_flags, void *data)
> 
>                         bio->bi_io_vec[i].bv_page = page;
>                 }
> +               bio->bi_vcnt = RESYNC_PAGES;
>         }
> 
>         return r10_bio;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

