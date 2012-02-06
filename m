Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381Ab2BFQW2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 11:22:28 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:42606 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754977Ab2BFQW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 11:22:26 -0500
Date: Mon, 6 Feb 2012 08:22:22 -0800
From: Tejun Heo <tj@kernel.org>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Knut Petersen <Knut_Petersen@t-online.de>, mroos@linux.ee
Subject: Re: [patch]block: fix ioc locking warning
Message-ID: <20120206162222.GB3926@google.com>
References: <1328514611.21268.66.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328514611.21268.66.camel@sli10-conroe>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Feb 06, 2012 at 03:50:11PM +0800, Shaohua Li wrote:
> diff --git a/block/blk-ioc.c b/block/blk-ioc.c
> index 27a06e0..7490b6d 100644
> --- a/block/blk-ioc.c
> +++ b/block/blk-ioc.c
> @@ -204,7 +204,9 @@ void put_io_context(struct io_context *ioc, struct request_queue *locked_q)
>  				spin_unlock(last_q->queue_lock);
>  			last_q = NULL;
>  
> -			if (!spin_trylock(this_q->queue_lock))
> +			/* spin_trylock() always successes in UP case */
> +			if (this_q != locked_q &&
> +			    !spin_trylock(this_q->queue_lock))

Yeah, this is the right thing to do.  I think the comment is slightly
misleading.  I'll prep a patch.

Thanks.

-- 
tejun
