Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758212Ab2ERQJN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 12:09:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62714 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757808Ab2ERQJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 12:09:10 -0400
Date: Fri, 18 May 2012 09:09:03 -0700
From: Tejun Heo <tj@kernel.org>
To: koverstreet@google.com
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, axboe@kernel.dk,
        agk@redhat.com, neilb@suse.de
Subject: Re: [PATCH 04/13] block: Add bio_clone_kmalloc()
Message-ID: <20120518160903.GD19388@google.com>
References: <cover.1337308722.git.koverstreet@google.com>
 <1c7c2d4b89bc3d0e907608cec37bcf0ee50f4c0e.1337308722.git.koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1c7c2d4b89bc3d0e907608cec37bcf0ee50f4c0e.1337308722.git.koverstreet@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2012 at 10:59:51PM -0400, koverstreet@google.com wrote:
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

This effectively swaps the order of bio_split() and __bio_clone().  Is
that safe?  Also, please cc the maintainer.

Thanks.

-- 
tejun
