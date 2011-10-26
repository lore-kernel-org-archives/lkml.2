Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933783Ab1JZRjd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 13:39:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933636Ab1JZRjc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 13:39:32 -0400
Date: Wed, 26 Oct 2011 13:20:49 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, jgarzik@pobox.com, davem@davemloft.net, hch@infradead.org,
        ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] block: add blk_queue_dead()
Message-ID: <20111026172049.GD355@redhat.com>
References: <1319590927-15791-1-git-send-email-tj@kernel.org>
 <1319590927-15791-5-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319590927-15791-5-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 06:02:05PM -0700, Tejun Heo wrote:
> There are a number of QUEUE_FLAG_DEAD tests.  Add blk_queue_dead()
> macro and use it.
> 
> This patch doesn't introduce any functional difference.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Jens Axboe <axboe@kernel.dk>
> ---
>  block/blk-core.c       |    6 +++---
>  block/blk-exec.c       |    2 +-
>  block/blk-sysfs.c      |    4 ++--
>  block/blk-throttle.c   |    4 ++--
>  block/blk.h            |    2 +-
>  include/linux/blkdev.h |    1 +
>  6 files changed, 10 insertions(+), 9 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 1efb943..7d39897 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -603,7 +603,7 @@ EXPORT_SYMBOL(blk_init_allocated_queue_node);
>  
>  int blk_get_queue(struct request_queue *q)
>  {
> -	if (likely(!test_bit(QUEUE_FLAG_DEAD, &q->queue_flags))) {
> +	if (likely(!blk_queue_dead(q))) {
>  		kobject_get(&q->kobj);
>  		return 0;

I thought DEAD flag is now synchronized with queue lock. So the protocol
is that caller should be holding queue lock here first?

Thanks
Vivek
