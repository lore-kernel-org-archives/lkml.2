Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758303Ab2ERQVu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 12:21:50 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64087 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755394Ab2ERQVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 12:21:47 -0400
Date: Fri, 18 May 2012 09:21:42 -0700
From: Tejun Heo <tj@kernel.org>
To: koverstreet@google.com
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, axboe@kernel.dk,
        agk@redhat.com, neilb@suse.de
Subject: Re: [PATCH 08/13] block: Kill bi_destructor
Message-ID: <20120518162142.GH19388@google.com>
References: <cover.1337308722.git.koverstreet@google.com>
 <de05855cf0fa4800cfab7e8340f106dccc7a75a1.1337308722.git.koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <de05855cf0fa4800cfab7e8340f106dccc7a75a1.1337308722.git.koverstreet@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> @@ -417,8 +409,11 @@ void bio_put(struct bio *bio)
>  
>  		if (bio->bi_pool)
>  			bio_free(bio, bio->bi_pool);
> -		else
> -			bio->bi_destructor(bio);
> +		else {
> +			if (bio_integrity(bio))
> +				bio_integrity_free(bio, fs_bio_set);
> +			kfree(bio);

if {
} else {
}

And wouldn't it be better to make bio_free() handle kfreeing too?

Overall, I really like this change.  I hate how ->bi_destructor() has
been used.

Thanks!

-- 
tejun
