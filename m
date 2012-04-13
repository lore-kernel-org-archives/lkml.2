Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013Ab2DMSNI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 14:13:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12136 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966Ab2DMSNE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 14:13:04 -0400
Date: Fri, 13 Apr 2012 14:12:57 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org
Subject: Re: [PATCH 7/8] blkcg: implement per-queue policy activation
Message-ID: <20120413181257.GG26383@redhat.com>
References: <1334273380-30233-1-git-send-email-tj@kernel.org>
 <1334273380-30233-8-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334273380-30233-8-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 04:29:39PM -0700, Tejun Heo wrote:

[..]
> diff --git a/block/elevator.c b/block/elevator.c
> index be3ab6d..6a55d41 100644
> --- a/block/elevator.c
> +++ b/block/elevator.c
> @@ -896,8 +896,6 @@ static int elevator_switch(struct request_queue *q, struct elevator_type *new_e)
>  	ioc_clear_queue(q);
>  	spin_unlock_irq(q->queue_lock);
>  
> -	blkg_destroy_all(q, false);
> -

So now groups don't reclaimed until either cgroup is deleted or queue
exits. So if BLK_DEV_THROTTLE=n and cfq is switched out, blkg created
by CFQ policy will not be reclaimed (despite the fact nobody is using
them).

This is not necessarily bad, just thought of clarifying that it is the
design intent.

Thanks
Vivek
