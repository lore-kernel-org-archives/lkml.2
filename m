Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935Ab1ATPpQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 10:45:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10448 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755830Ab1ATPpO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 10:45:14 -0500
Date: Thu, 20 Jan 2011 10:43:27 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Jens Axboe <jaxboe@fusionio.com>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] loop: queue_lock NULL pointer derefence in
 blk_throtl_exit (v2)
Message-ID: <20110120154327.GD18875@redhat.com>
References: <20110114192532.GA4274@swordfish>
 <20110120113211.GB16184@redhat.com>
 <20110120125849.GA4172@swordfish>
 <20110120143546.GA18875@redhat.com>
 <20110120151738.GA4665@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110120151738.GA4665@swordfish.minsk.epam.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 05:18:22PM +0200, Sergey Senozhatsky wrote:
> On (01/20/11 09:35), Vivek Goyal wrote:
> > Hi Sergey,
> >
> 
> Hi Vivek,
> 
> > Can we expand a little bit on comment that why do we need to have
> > q->queue_lock initialized here now. Basically in the past nobody tried
> > to take q->queue_lock in blk_cleanup_queue() path hence things just
> > worked. Now blk throttling code is new and it takes q->queue_lock hence we
> > run into issues. This could be true for some other future code too.
> > 
> > Secondly currently blk throttle code seems to be the only user dependent
> > on this lock initialization. So it might make sense to move this code
> > closer to the actual call and blk_release_queue() might be even better
> > place to do it atleast for now.
> > 
> 
> I'm afraid it's not safe to move NULL-check-and-fix out from blk_cleanup_queue, 
> since we're performing elevator_exit(q->elevator) call, which may depend on 
> q->queue_lock. For example, (./cfq-iosched.c: .elevator_exit_fn = cfq_exit_queue)
> cfq_exit_queue uses q->queue_lock.

ok, actually cfq_exit_queue() will be called only if elevator has been
initilialzed and if elevator has been initialialized that means
q->queue_lock also has been initilalized so that should not be a problem.

I am not very particular about this thing. So I will leave it to you.

Thanks
Vivek
