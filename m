Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766Ab2DDPKW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 11:10:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15243 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756354Ab2DDPKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 11:10:20 -0400
Date: Wed, 4 Apr 2012 11:10:14 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Shaohua Li <shli@kernel.org>
Cc: Tao Ma <tm@tao.ma>, Tejun Heo <tj@kernel.org>, axboe@kernel.dk,
        ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: IOPS based scheduler (Was: Re: [PATCH 18/21] blkcg: move
 blkio_group_conf->weight to cfq)
Message-ID: <20120404151014.GD12676@redhat.com>
References: <4F7A261A.9000200@tao.ma>
 <20120402222504.GA2672@redhat.com>
 <4F7A2B21.5000907@tao.ma>
 <20120403153736.GI5913@redhat.com>
 <4F7B2708.6080504@tao.ma>
 <20120403164959.GJ5913@redhat.com>
 <4F7B32AE.7050900@tao.ma>
 <CANejiEU1qAsvogozY3MjZnpcrbYZO4CkRE8s73WGPc_R5LKV9g@mail.gmail.com>
 <20120404133705.GB12676@redhat.com>
 <CANejiEVD6nFVqX8Jf_hmRHg8YyBvPxbTVjgEif3mO1aa925KkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANejiEVD6nFVqX8Jf_hmRHg8YyBvPxbTVjgEif3mO1aa925KkQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 04, 2012 at 07:52:24AM -0700, Shaohua Li wrote:

[..]
> Agreed, we can tweak cfq to make it support iops fairness because the two
> are conceptually the same. The problem is if this is a mess. CFQ is quite
> complicated already. In iops mode, a lot of code isn't required, like idle,
> queue merging, thinktime/seek detection and so on, as the scheduler
> will be only for ssd. With recent iocontext cleanup, the iops scheduler
> code is quite short actually.

Ok, this is somewhat a better reason to have a separate scheduler. I guess
we need to look that actual iops code and that can help decide whether
to keep it as a separate scheduler.

One question is still unanswered though. What real workload benefits
from it? If you are not doing idling in iops based scheduler, I doubt
you are doing to see much service differentiation on fast SSDs. As for
service differentiation IO queues have to be continuously backlogged and
total IOPS needed by applications need to be more than what disk can
offer. It becomes very hard to produe continuously backlogged queues
because real applications tend to read some data, proces data and then
generate more IO. 

Thanks
Vivek
