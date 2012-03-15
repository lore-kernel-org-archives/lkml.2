Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031969Ab2CORBa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 13:01:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15982 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161096Ab2CORB3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 13:01:29 -0400
Date: Thu, 15 Mar 2012 13:01:00 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>, Jens Axboe <axboe@kernel.dk>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH block/for-3.4/core] cfq: fix cfqg ref handling when
 BLK_CGROUP && !CFQ_GROUP_IOSCHED
Message-ID: <20120315170100.GF3253@redhat.com>
References: <20120315094945.GA3205@localhost>
 <20120315163546.GA32137@google.com>
 <20120315164621.GD3253@redhat.com>
 <20120315165057.GB32137@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120315165057.GB32137@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 09:50:57AM -0700, Tejun Heo wrote:

> > [..]
> > > @@ -3533,7 +3551,7 @@ static int cfq_init_queue(struct request
> > >  
> > >  	spin_lock_irq(q->queue_lock);
> > >  	cfq_link_cfqq_cfqg(&cfqd->oom_cfqq, cfqd->root_group);
> > > -	blkg_put(cfqg_to_blkg(cfqd->root_group));
> > > +	cfqg_put(cfqd->root_group);
> > 
> > This seems to be a spurious cfqg_put()? Which reference we are putting
> > down here?
> 
> The extra ref from cfq_link_cfqq_cfqg() for oom_cfqq; otherwise, we
> need an extra cfq_put() in cfq_exit_queue().  I thought I wrote
> comment about that somewhere.  Hmmm.... apparently not.  The thing is
> that oom_cfqq doesn't go through proper cfqq destruction and thus
> never puts the extra ref to root cfqg.

Ok. Is cfq_exit_queue() a better place to put down this reference
explicitly with a comment. Even if you keep it here, atleast a comment
is required. It is not obvious at all (atleast to me).

Thanks
Vivek
