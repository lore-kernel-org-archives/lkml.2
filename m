Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932450Ab2DDR1n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 13:27:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1881 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932211Ab2DDR1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 13:27:42 -0400
Date: Wed, 4 Apr 2012 13:27:35 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tao Ma <tm@tao.ma>
Cc: Shaohua Li <shli@kernel.org>, Tejun Heo <tj@kernel.org>, axboe@kernel.dk,
        ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: IOPS based scheduler (Was: Re: [PATCH 18/21] blkcg: move
 blkio_group_conf->weight to cfq)
Message-ID: <20120404172735.GH12676@redhat.com>
References: <4F7A2B21.5000907@tao.ma>
 <20120403153736.GI5913@redhat.com>
 <4F7B2708.6080504@tao.ma>
 <20120403164959.GJ5913@redhat.com>
 <4F7B32AE.7050900@tao.ma>
 <CANejiEU1qAsvogozY3MjZnpcrbYZO4CkRE8s73WGPc_R5LKV9g@mail.gmail.com>
 <20120404133705.GB12676@redhat.com>
 <4F7C7A91.8040707@tao.ma>
 <20120404165048.GF12676@redhat.com>
 <4F7C824D.2050308@tao.ma>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F7C824D.2050308@tao.ma>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 05, 2012 at 01:18:05AM +0800, Tao Ma wrote:

[..]
> > You can just put a few lines of code to expire queue after 1-2 requests
> > dispatched from the queue. Than run your workload with slice_idle=0
> > and group_idle=0 and see what happens.
> oh, yes I can do this to see whether the latency helps, but it is
> hacking and doesn't work with the cgroup proportion...

"Hacking"?. I think effectively that's what effectively iops scheduler
should be doing to achieve faster switching.

Also, if your workload is keeping groups continuously busy, you should
get proportional behavior at group level. 

Do try the patch I sent you in a separate mail with your workload.

[..]
> > I think a large chunk of that iops scheduler code will be borrowed from
> > CFQ code. All the cgroup logic, queue creation logic, group scheduling
> > logic etc. And that's the reason I was still exploring the possibility 
> > of having common code base.
> Yeah, actually I was thinking of abstracting a generic logic, but it
> seems a lot bit hard. Maybe we can try to unify the code later?

Once you write and merge a new scheduler, that code merge is never going
to happen. They will happily part ways with lot of code/logic shared.

Once the hierarchical support comes to CFQ, same hierarchical cgroup 
support needs to be written to this new scheduler also.


Thanks
Vivek
