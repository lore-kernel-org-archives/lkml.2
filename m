Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877Ab1H3PFx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 11:05:53 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65166 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760Ab1H3PFw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 11:05:52 -0400
MIME-Version: 1.0
In-Reply-To: <20110826120900.cdc6e4c3597c88ad45015a9b@canb.auug.org.au>
References: <20110826120900.cdc6e4c3597c88ad45015a9b@canb.auug.org.au>
Date: Tue, 30 Aug 2011 23:05:52 +0800
Message-ID: <CAM_iQpV4JSnW_xbHQjG6Nn70yp9WKZ1+D2uq1J_LmM6KgcQL6A@mail.gmail.com>
Subject: Re: [PATCH] bio: use a static inline function for bio_integrity_clone
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jens Axboe <jaxboe@fusionio.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Christoph Hellwig <hch@lst.de>, LKML <linux-kernel@vger.kernel.org>,
        Neil Brown <neilb@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 10:09 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> When CONFIG_BLK_DEV_INTEGRITY is not set, we get these warnings:
>
> drivers/md/dm.c: In function 'split_bvec':
> drivers/md/dm.c:1061:3: warning: statement with no effect
> drivers/md/dm.c: In function 'clone_bio':
> drivers/md/dm.c:1088:3: warning: statement with no effect
>
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  include/linux/bio.h |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
>
> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index ce33e68..c98ecc8 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -527,7 +527,11 @@ extern void bio_integrity_init(void);
>  #define bioset_integrity_create(a, b)  (0)
>  #define bio_integrity_prep(a)          (0)
>  #define bio_integrity_enabled(a)       (0)
> -#define bio_integrity_clone(a, b, c, d)        (0)
> +static inline int bio_integrity_clone(struct bio *bio, struct bio *bio_src,
> +                                     gfp_t gfp_mask, struct bio_set *bs)
> +{
> +       return 0;
> +}

or

#define bio_integrity_clone(a, b, c, d)        ({0})
