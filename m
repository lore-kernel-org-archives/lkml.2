Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933368Ab2HVVKw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 17:10:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34837 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933209Ab2HVVKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 17:10:49 -0400
Date: Wed, 22 Aug 2012 14:10:45 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, vgoyal@redhat.com, mpatocka@redhat.com,
        bharrosh@panasas.com, Jens Axboe <axboe@kernel.dk>,
        Alasdair Kergon <agk@redhat.com>, Sage Weil <sage@inktank.com>
Subject: Re: [PATCH v6 13/13] block: Only clone bio vecs that are in use
Message-ID: <20120822211045.GN19212@google.com>
References: <1345655050-28199-1-git-send-email-koverstreet@google.com>
 <1345655050-28199-14-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345655050-28199-14-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Kent.

On Wed, Aug 22, 2012 at 10:04:10AM -0700, Kent Overstreet wrote:
> bcache creates large bios internally, and then splits them according to
> the device requirements before it sends them down. If a lower level
> device tries to clone the bio, and the original bio had more than
> BIO_MAX_PAGES, the clone will fail unecessarily.
> 
> We can fix this by only cloning the bio vecs that are actually in use.

I'm pretty sure I sound like a broken record by now, but

* How was this tested?

* What are the implications and possible dangers?

> @@ -463,10 +468,10 @@ void __bio_clone(struct bio *bio, struct bio *bio_src)
>  	bio->bi_sector = bio_src->bi_sector;
>  	bio->bi_bdev = bio_src->bi_bdev;
>  	bio->bi_flags |= 1 << BIO_CLONED;
> +	bio->bi_flags &= ~(1 << BIO_SEG_VALID);

For the n'th time, explain please.

Thanks.

-- 
tejun
