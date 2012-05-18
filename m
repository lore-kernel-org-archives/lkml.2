Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010Ab2ERQaZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 12:30:25 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49236 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929Ab2ERQaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 12:30:23 -0400
Date: Fri, 18 May 2012 09:30:18 -0700
From: Tejun Heo <tj@kernel.org>
To: koverstreet@google.com
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, axboe@kernel.dk,
        agk@redhat.com, neilb@suse.de
Subject: Re: [PATCH 09/13] block: Add an explicit bio flag for bios that
 own their bvec
Message-ID: <20120518163018.GI19388@google.com>
References: <cover.1337308722.git.koverstreet@google.com>
 <363875943e9d0e13bee6ed28239280543e6e5055.1337308722.git.koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <363875943e9d0e13bee6ed28239280543e6e5055.1337308722.git.koverstreet@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2012 at 10:59:56PM -0400, koverstreet@google.com wrote:
> From: Kent Overstreet <koverstreet@google.com>
> 
> This is for the new bio splitting code. When we split a bio, if the
> split occured on a bvec boundry we reuse the bvec for the new bio. But
> that means bio_free() can't free it, hence the explicit flag.
> 
> Signed-off-by: Kent Overstreet <koverstreet@google.com>
> ---
>  fs/bio.c                  |    3 ++-
>  include/linux/blk_types.h |    1 +
>  2 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/bio.c b/fs/bio.c
> index ecc9088..3332800 100644
> --- a/fs/bio.c
> +++ b/fs/bio.c
> @@ -234,7 +234,7 @@ void bio_free(struct bio *bio, struct bio_set *bs)
>  {
>  	void *p;
>  
> -	if (bio_has_allocated_vec(bio))
> +	if (bio_flagged(bio, BIO_HAS_VEC))
>  		bvec_free_bs(bs, bio->bi_io_vec, BIO_POOL_IDX(bio));

We can remove bio_has_allocated_vec()?

Thanks.

-- 
tejun
