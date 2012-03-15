Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031906Ab2COQqz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 12:46:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23950 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031706Ab2COQqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 12:46:51 -0400
Date: Thu, 15 Mar 2012 12:46:21 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>, Jens Axboe <axboe@kernel.dk>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH block/for-3.4/core] cfq: fix cfqg ref handling when
 BLK_CGROUP && !CFQ_GROUP_IOSCHED
Message-ID: <20120315164621.GD3253@redhat.com>
References: <20120315094945.GA3205@localhost>
 <20120315163546.GA32137@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120315163546.GA32137@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 09:35:46AM -0700, Tejun Heo wrote:

[..]
> ---
> Yeap, forgot to test that config combination.  Fengguang, can you
> please test this patch?  Jens, once Fengguang confirms the fix, can
> you please apply this on top of for-3.4/core along with the pending
> stats updates?

I was working on similar patch and you beat me to it. :-) One comment
below.

[..]
> @@ -3533,7 +3551,7 @@ static int cfq_init_queue(struct request
>  
>  	spin_lock_irq(q->queue_lock);
>  	cfq_link_cfqq_cfqg(&cfqd->oom_cfqq, cfqd->root_group);
> -	blkg_put(cfqg_to_blkg(cfqd->root_group));
> +	cfqg_put(cfqd->root_group);

This seems to be a spurious cfqg_put()? Which reference we are putting
down here?

Thanks
Vivek
