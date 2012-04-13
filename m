Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676Ab2DMSRO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 14:17:14 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63983 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755275Ab2DMSRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 14:17:10 -0400
Date: Fri, 13 Apr 2012 11:17:05 -0700
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org
Subject: Re: [PATCH 7/8] blkcg: implement per-queue policy activation
Message-ID: <20120413181705.GD12233@google.com>
References: <1334273380-30233-1-git-send-email-tj@kernel.org>
 <1334273380-30233-8-git-send-email-tj@kernel.org>
 <20120413181257.GG26383@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120413181257.GG26383@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Apr 13, 2012 at 02:12:57PM -0400, Vivek Goyal wrote:
> On Thu, Apr 12, 2012 at 04:29:39PM -0700, Tejun Heo wrote:
> 
> [..]
> > diff --git a/block/elevator.c b/block/elevator.c
> > index be3ab6d..6a55d41 100644
> > --- a/block/elevator.c
> > +++ b/block/elevator.c
> > @@ -896,8 +896,6 @@ static int elevator_switch(struct request_queue *q, struct elevator_type *new_e)
> >  	ioc_clear_queue(q);
> >  	spin_unlock_irq(q->queue_lock);
> >  
> > -	blkg_destroy_all(q, false);
> > -
> 
> So now groups don't reclaimed until either cgroup is deleted or queue
> exits. So if BLK_DEV_THROTTLE=n and cfq is switched out, blkg created
> by CFQ policy will not be reclaimed (despite the fact nobody is using
> them).

It's not difficult to change.  We can just trigger reclaim if no
policy is enabled for the queue.  Hmmm... yeah, that's gonna be like
five line change.  I'll add it.

Thanks.

-- 
tejun
