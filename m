Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030732Ab2CGW4i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 17:56:38 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:37946 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932632Ab2CGW4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 17:56:35 -0500
Date: Wed, 7 Mar 2012 14:56:29 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, axboe@kernel.dk,
        hughd@google.com, avi@redhat.com, nate@cpanel.net,
        cl@linux-foundation.org, linux-kernel@vger.kernel.org,
        dpshah@google.com, ctalbott@google.com, rni@google.com
Subject: Re: [PATCHSET] mempool, percpu, blkcg: fix percpu stat allocation
 and remove stats_lock
Message-ID: <20120307225629.GE30676@google.com>
References: <20120305221321.GF1263@google.com>
 <20120306210954.GF32148@redhat.com>
 <20120306132034.ecaf8b20.akpm@linux-foundation.org>
 <20120306213437.GG32148@redhat.com>
 <20120306135531.828ca78e.akpm@linux-foundation.org>
 <20120307145556.GA11262@redhat.com>
 <20120307170544.GA30676@google.com>
 <20120307191334.GG13430@redhat.com>
 <20120307192219.GC30676@google.com>
 <20120307194229.GH13430@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120307194229.GH13430@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2012 at 02:42:29PM -0500, Vivek Goyal wrote:
> blk-cgroup: Alloc per cpu stats from worker thread in a delayed manner
> 
> Current per cpu stat allocation assumes GFP_KERNEL allocation flag. But in
> IO path there are times when we want GFP_NOIO semantics. As there is no
> way to pass the allocation flags to alloc_percpu(), this patch delays the
> allocation of stats using a worker thread.
> 
> v2-> tejun suggested following changes. Changed the patch accordingly.
> 	- move alloc_node location in structure
> 	- reduce the size of names of some of the fields
> 	- Reduce the scope of locking of alloc_list_lock
> 	- Simplified stat_alloc_fn() by allocating stats for all
> 	  policies in one go and then assigning these to a group.
> 
> v3 -> Andrew suggested to put some comments in the code. Also raised
>       concerns about trying to allocate infinitely in case of allocation
>       failure. I have changed the logic to sleep for 10ms before retrying.
>       That should take care of non-preemptible UP kernels.
> 
> v4 -> Tejun had more suggestions.
> 	- drop list_for_each_entry_all()
> 	- instead of msleep() use queue_delayed_work()
> 	- Some cleanups realted to more compact coding.
>  
> v5-> tejun suggested more cleanups leading to more compact code.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Looks good to me.  I'll roll it into the stats series.  Andrew, if you
still have objections, please scream.

Thanks.

-- 
tejun
