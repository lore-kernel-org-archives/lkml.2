Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757040Ab2DDQu5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 12:50:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13461 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756854Ab2DDQu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 12:50:56 -0400
Date: Wed, 4 Apr 2012 12:50:48 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tao Ma <tm@tao.ma>
Cc: Shaohua Li <shli@kernel.org>, Tejun Heo <tj@kernel.org>, axboe@kernel.dk,
        ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: IOPS based scheduler (Was: Re: [PATCH 18/21] blkcg: move
 blkio_group_conf->weight to cfq)
Message-ID: <20120404165048.GF12676@redhat.com>
References: <4F7A261A.9000200@tao.ma>
 <20120402222504.GA2672@redhat.com>
 <4F7A2B21.5000907@tao.ma>
 <20120403153736.GI5913@redhat.com>
 <4F7B2708.6080504@tao.ma>
 <20120403164959.GJ5913@redhat.com>
 <4F7B32AE.7050900@tao.ma>
 <CANejiEU1qAsvogozY3MjZnpcrbYZO4CkRE8s73WGPc_R5LKV9g@mail.gmail.com>
 <20120404133705.GB12676@redhat.com>
 <4F7C7A91.8040707@tao.ma>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F7C7A91.8040707@tao.ma>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 05, 2012 at 12:45:05AM +0800, Tao Ma wrote:

[..]
> > In iops_mode(), expire each cfqq after dispatch of 1 or bunch of requests
> > and you should get the same behavior (with slice_idle=0 and group_idle=0).
> > So why write a new scheduler.
> really? How could we config cfq to work like this? Or you mean we can
> change the code for it?

You can just put a few lines of code to expire queue after 1-2 requests
dispatched from the queue. Than run your workload with slice_idle=0
and group_idle=0 and see what happens.

I don't even know what your workload is. 

> > 
> > Only thing is that with above, current code will provide iops fairness only
> > for groups. We should be able to tweak queue scheduling to support iops
> > fairness also.
> OK, as I have said in another e-mail another my concern is the
> complexity. It will make cfq too much complicated. I just checked the
> source code of shaohua's original patch, fiops scheduler is only ~700
> lines, so with cgroup support added it would be ~1000 lines I guess.
> Currently cfq-iosched.c is around ~4000 lines even after Tejun's cleanup
> of io context...

I think a large chunk of that iops scheduler code will be borrowed from
CFQ code. All the cgroup logic, queue creation logic, group scheduling
logic etc. And that's the reason I was still exploring the possibility 
of having common code base.

Thanks
Vivek
