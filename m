Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932600Ab2ITXgY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 19:36:24 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42487 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932489Ab2ITXgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 19:36:22 -0400
Date: Thu, 20 Sep 2012 16:36:18 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, neilb@suse.de
Subject: Re: [PATCH v2 06/26] block: Use bio_sectors() more consistently
Message-ID: <20120920233618.GL7264@google.com>
References: <1347322957-25260-1-git-send-email-koverstreet@google.com>
 <1347322957-25260-7-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347322957-25260-7-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 05:22:17PM -0700, Kent Overstreet wrote:
> diff --git a/drivers/block/aoe/aoeblk.c b/drivers/block/aoe/aoeblk.c
> index 321de7b..6e4420a 100644
> --- a/drivers/block/aoe/aoeblk.c
> +++ b/drivers/block/aoe/aoeblk.c
> @@ -199,7 +199,7 @@ aoeblk_make_request(struct request_queue *q, struct bio *bio)
>  	buf->bio = bio;
>  	buf->resid = bio->bi_size;
>  	buf->sector = bio->bi_sector;
> -	buf->bv = &bio->bi_io_vec[bio->bi_idx];
> +	buf->bv = bio_iovec(bio);

Contamination?

Also, in general, please cc at least the maintainers of the files that
you modify.

Thanks.

-- 
tejun
