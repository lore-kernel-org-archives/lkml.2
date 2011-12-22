Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134Ab1LVXYn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 18:24:43 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34143 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756091Ab1LVXYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 18:24:38 -0500
Date: Thu, 22 Dec 2011 15:24:33 -0800
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: avi@redhat.com, nate@cpanel.net, cl@linux-foundation.org, oleg@redhat.com,
        axboe@kernel.dk, vgoyal@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] block, mempool, percpu: implement percpu mempool
 and fix blkcg percpu alloc deadlock
Message-ID: <20111222232433.GQ17084@google.com>
References: <1324590326-10135-1-git-send-email-tj@kernel.org>
 <20111222135925.de3221c8.akpm@linux-foundation.org>
 <20111222220911.GK17084@google.com>
 <20111222142058.41316ee0.akpm@linux-foundation.org>
 <20111222224117.GL17084@google.com>
 <20111222145426.5844df96.akpm@linux-foundation.org>
 <20111222230047.GN17084@google.com>
 <20111222151649.de57746f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111222151649.de57746f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Dec 22, 2011 at 03:16:49PM -0800, Andrew Morton wrote:
> > The ones allocated in the last patch.  blk_group_cpu_stats.
> 
> What last patch.
> 
> I can find no occurence of "blk_group_cpu_stats" on linux-kernel or in
> the kernel tree.

Sorry it's blkio_group_stats_cpu.  It's in the seventh path in this
series.

> > The stats are per cgroup - request_queue pair.  We don't want to
> > allocate for all of them for each combination as there are
> > configurations with stupid number of request_queues and silly many
> > cgroups and #cgroups * #request_queue * #cpus can be huge.  So, we
> > want on-demand allocation.  While the stats are important, they are
> > not critical and allocations can be opportunistic.  If the allocation
> > fails this time, we can try it for the next time.
> 
> Without code to look at I am at a loss.

block/blk-cgroup.c blk-throttle.c cfq-iosched.c.  Have fun.

> request_queues are allocated in blk_alloc_queue_node(), which uses
> GFP_KERNEL (and also mysteriously takes a gfp_t arg).

Yeah, sure, we *can* allocate everything for every combination when
either request_queue or cgroup comes up.  That's the thing I tried to
explain in the above quoted paragraph.

Thanks.

-- 
tejun
