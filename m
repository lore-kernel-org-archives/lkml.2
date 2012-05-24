Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932904Ab2EXS7q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 14:59:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40288 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754059Ab2EXS7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 14:59:44 -0400
Date: Thu, 24 May 2012 14:59:19 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, tj@kernel.org,
        axboe@kernel.dk, agk@redhat.com, neilb@suse.de,
        drbd-dev@lists.linbit.com, bharrosh@panasas.com, mpatocka@redhat.com,
        sage@newdream.net, yehuda@hq.newdream.net
Subject: Re: [PATCH v2 04/14] block: Add bio_clone_kmalloc()
Message-ID: <20120524185919.GE27550@redhat.com>
References: <1337817771-25038-1-git-send-email-koverstreet@google.com>
 <1337817771-25038-5-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337817771-25038-5-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 05:02:41PM -0700, Kent Overstreet wrote:

[..]
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index 013c7a5..5a953c6 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -729,7 +729,7 @@ static struct bio *bio_chain_clone(struct bio **old, struct bio **next,
>  	}
>  
>  	while (old_chain && (total < len)) {
> -		tmp = bio_kmalloc(gfpmask, old_chain->bi_max_vecs);
> +		tmp = bio_clone_kmalloc(old_chain, gfpmask);
>  		if (!tmp)
>  			goto err_out;
>  
> @@ -751,13 +751,9 @@ static struct bio *bio_chain_clone(struct bio **old, struct bio **next,
>  			if (!bp)
>  				goto err_out;
>  
> -			__bio_clone(tmp, &bp->bio1);
> -
>  			*next = &bp->bio2;

Is this code correct. Now original code might clone bio after split and
new code will clone the original bio itself and not the split one?

Thanks
Vivek
