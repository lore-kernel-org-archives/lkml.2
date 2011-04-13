Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757598Ab1DMBRM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 21:17:12 -0400
Received: from mga01.intel.com ([192.55.52.88]:9414 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757493Ab1DMBRK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 21:17:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,200,1301900400"; 
   d="scan'208";a="678293623"
Subject: Re: [PATCH 4/4]percpu_counter: use atomic64 for counter
From: Shaohua Li <shaohua.li@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "cl@linux.com" <cl@linux.com>
In-Reply-To: <20110412191534.GE16342@mtj.dyndns.org>
References: <1302595446.3981.130.camel@sli10-conroe>
	 <20110412191534.GE16342@mtj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Apr 2011 09:17:08 +0800
Message-ID: <1302657428.3981.149.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-13 at 03:15 +0800, Tejun Heo wrote:
> Hello,
> 
> On Tue, Apr 12, 2011 at 04:04:06PM +0800, Shaohua Li wrote:
> > should tunning the batch count, but if we can make percpu_counter better, why
> > not?
> 
> First of all, the lock being only in slow paths, it's quite unlikely
> to get ever contended.  Also, because the lock duration is always
> extremely short, conversion to atomic_t isn't too likely to gain
> anything significant, especially in cold paths.
> 
> That said, if it's all gains, why not?  I don't know.  Maybe.  Given
> problems in the previous patches, I don't feel too enthusiastic for
> this series at this point but I'm quite sleep deprived now so it might
> just be me not the patch itself.
yes, we do have something this matters. the vm_committed_as
percpu_counter could heavily contend the lock. please see
http://marc.info/?l=linux-kernel&m=130144786026044&w=2
We should fix vm_committed_as, but the atomic method also gives me very
good output. When I do mmap/munmap test in a 24 CPU system, the atomic
method gives me 50x faster.

Thanks,
Shaohua

