Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327Ab2H1UgR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 16:36:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57848 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819Ab2H1UgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 16:36:16 -0400
Date: Tue, 28 Aug 2012 13:36:13 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, vgoyal@redhat.com, mpatocka@redhat.com,
        bharrosh@panasas.com, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v7 5/9] block: Kill bi_destructor
Message-ID: <20120828203613.GD24608@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1346175456-1572-1-git-send-email-koverstreet@google.com>
 <1346175456-1572-6-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346175456-1572-6-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 28, 2012 at 10:37:32AM -0700, Kent Overstreet wrote:
> @@ -385,7 +386,7 @@ struct bio *bio_kmalloc(gfp_t gfp_mask, unsigned int nr_iovecs)
>  	bio->bi_flags |= BIO_POOL_NONE << BIO_POOL_OFFSET;
>  	bio->bi_max_vecs = nr_iovecs;
>  	bio->bi_io_vec = bio->bi_inline_vecs;
> -	bio->bi_destructor = bio_kmalloc_destructor;
> +	bio->bi_pool = NULL;

Doesn't bio_init() already memset the whole thing?

Thanks.

-- 
tejun
