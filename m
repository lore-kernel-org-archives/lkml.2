Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490Ab2IUNZo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 09:25:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13542 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754707Ab2IUNZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 09:25:43 -0400
Date: Fri, 21 Sep 2012 09:25:39 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>,
        Joseph Glanville <joseph.glanville@orionvm.com.au>,
        cgroups <cgroups@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] block: fix request_queue->flags initialization
Message-ID: <20120921132539.GB15909@redhat.com>
References: <CAOzFzEhWk_7oQFOyW6Ri_9Cvsshj2s3pa=Oo-p8uL6r340MoTw@mail.gmail.com>
 <20120919194231.GF31860@redhat.com>
 <20120920183153.GI28934@google.com>
 <20120920184219.GH4681@redhat.com>
 <20120920191716.GI4681@redhat.com>
 <20120920192038.GJ28934@google.com>
 <20120920195759.GK4681@redhat.com>
 <20120920201815.GB7264@google.com>
 <20120920210852.GC7264@google.com>
 <20120920210930.GD7264@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120920210930.GD7264@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2012 at 02:09:30PM -0700, Tejun Heo wrote:
> A queue newly allocated with blk_alloc_queue_node() has only
> QUEUE_FLAG_BYPASS set.  For request-based drivers,
> blk_init_allocated_queue() is called and q->queue_flags is overwritten
> with QUEUE_FLAG_DEFAULT which doesn't include BYPASS even though the
> initial bypass is still in effect.
> 
> In blk_init_allocated_queue(), or QUEUE_FLAG_DEFAULT to q->queue_flags
> instead of overwriting.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Cc: stable@vger.kernel.org

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Vivek

> ---
>  block/blk-core.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -696,7 +696,7 @@ blk_init_allocated_queue(struct request_
>  	q->request_fn		= rfn;
>  	q->prep_rq_fn		= NULL;
>  	q->unprep_rq_fn		= NULL;
> -	q->queue_flags		= QUEUE_FLAG_DEFAULT;
> +	q->queue_flags		|= QUEUE_FLAG_DEFAULT;
>  
>  	/* Override internal queue lock with supplied lock pointer */
>  	if (lock)
