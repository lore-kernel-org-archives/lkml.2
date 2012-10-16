Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746Ab2JPW76 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 18:59:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48096 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755408Ab2JPW75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 18:59:57 -0400
Date: Tue, 16 Oct 2012 19:59:49 -0300
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [ 038/147] block: fix request_queue->flags initialization
Message-ID: <20121016225948.GA3027@herton-Z68MA-D2H-B3>
References: <20121014143533.742627615@decadent.org.uk>
 <20121014143538.966779793@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121014143538.966779793@decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 14, 2012 at 03:36:11PM +0100, Ben Hutchings wrote:
> 3.2-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Tejun Heo <tj@kernel.org>
> 
> commit 60ea8226cbd5c8301f9a39edc574ddabcb8150e0 upstream.
> 
> A queue newly allocated with blk_alloc_queue_node() has only
> QUEUE_FLAG_BYPASS set.  For request-based drivers,
> blk_init_allocated_queue() is called and q->queue_flags is overwritten
> with QUEUE_FLAG_DEFAULT which doesn't include BYPASS even though the
> initial bypass is still in effect.

Since QUEUE_FLAG_BYPASS doesn't exist and nothing in
blk_alloc_queue_node is set on 3.2, this change is uneeded then,
but the patch should be harmless anyway.

> 
> In blk_init_allocated_queue(), or QUEUE_FLAG_DEFAULT to q->queue_flags
> instead of overwriting.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Acked-by: Vivek Goyal <vgoyal@redhat.com>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  block/blk-core.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 80e29c9..a17869f 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -696,7 +696,7 @@ blk_init_allocated_queue(struct request_queue *q, request_fn_proc *rfn,
>  	q->request_fn		= rfn;
>  	q->prep_rq_fn		= NULL;
>  	q->unprep_rq_fn		= NULL;
> -	q->queue_flags		= QUEUE_FLAG_DEFAULT;
> +	q->queue_flags		|= QUEUE_FLAG_DEFAULT;
>  
>  	/* Override internal queue lock with supplied lock pointer */
>  	if (lock)

-- 
[]'s
Herton
