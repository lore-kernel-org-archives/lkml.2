Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965336Ab1JFXWX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 19:22:23 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:32905 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752917Ab1JFXWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 19:22:22 -0400
Date: Thu, 6 Oct 2011 16:22:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Christoph Hellwig <hch@lst.de>, LKML <linux-kernel@vger.kernel.org>,
        Neil Brown <neilb@suse.de>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] bio: use a static inline function for
 bio_integrity_clone
Message-Id: <20111006162219.b629eabb.akpm@linux-foundation.org>
In-Reply-To: <20110826120900.cdc6e4c3597c88ad45015a9b@canb.auug.org.au>
References: <20110826120900.cdc6e4c3597c88ad45015a9b@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Aug 2011 12:09:00 +1000
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> When CONFIG_BLK_DEV_INTEGRITY is not set, we get these warnings:
> 
> drivers/md/dm.c: In function 'split_bvec':
> drivers/md/dm.c:1061:3: warning: statement with no effect
> drivers/md/dm.c: In function 'clone_bio':
> drivers/md/dm.c:1088:3: warning: statement with no effect
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  include/linux/bio.h |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index ce33e68..c98ecc8 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -527,7 +527,11 @@ extern void bio_integrity_init(void);
>  #define bioset_integrity_create(a, b)	(0)
>  #define bio_integrity_prep(a)		(0)
>  #define bio_integrity_enabled(a)	(0)
> -#define bio_integrity_clone(a, b, c, d)	(0)
> +static inline int bio_integrity_clone(struct bio *bio, struct bio *bio_src,
> +				      gfp_t gfp_mask, struct bio_set *bs)
> +{
> +	return 0;
> +}
>  #define bioset_integrity_free(a)	do { } while (0)
>  #define bio_integrity_free(a, b)	do { } while (0)
>  #define bio_integrity_endio(a, b)	do { } while (0)

grumble@lazybones.  All those other vile macros should be similarly
converted, for this reason and for all the others.

Am too lazy to do it myself, so let's at least fix this warning until
some others turn up.

