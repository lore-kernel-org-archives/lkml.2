Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758137Ab2ERQLn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 12:11:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47579 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753993Ab2ERQLk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 12:11:40 -0400
Date: Fri, 18 May 2012 12:11:30 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: koverstreet@google.com
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, tj@kernel.org,
        axboe@kernel.dk, agk@redhat.com
Subject: Re: [dm-devel] [PATCH 03/13] block: Add bio_clone_bioset()
Message-ID: <20120518161130.GG25708@redhat.com>
References: <cover.1337308722.git.koverstreet@google.com>
 <eb6a7d3fe7ae203202bc365d7274ee531631a9ca.1337308722.git.koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb6a7d3fe7ae203202bc365d7274ee531631a9ca.1337308722.git.koverstreet@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2012 at 10:59:50PM -0400, koverstreet@google.com wrote:

[..]
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index a5a524e..47605e7 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -178,23 +178,7 @@ struct bio *bio_clone_mddev(struct bio *bio, gfp_t gfp_mask,
>  	if (!mddev || !mddev->bio_set)
>  		return bio_clone(bio, gfp_mask);
>  
> -	b = bio_alloc_bioset(gfp_mask, bio->bi_max_vecs, mddev->bio_set);
> -	if (!b)
> -		return NULL;
> -
> -	__bio_clone(b, bio);
> -	if (bio_integrity(bio)) {
> -		int ret;
> -
> -		ret = bio_integrity_clone(b, bio, gfp_mask, mddev->bio_set);
> -
> -		if (ret < 0) {
> -			bio_put(b);
> -			return NULL;
> -		}
> -	}
> -
> -	return b;
> +	return bio_clone_bioset(gfp_mask, bio_segments(bio), mddev->bio_set);

Are we passing wrong arguments to bio_clone_bioset()?

Thanks
Vivek
