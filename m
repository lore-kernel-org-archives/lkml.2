Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932645Ab1ERBAq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 21:00:46 -0400
Received: from mga01.intel.com ([192.55.52.88]:5248 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756484Ab1ERBAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 21:00:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,228,1304319600"; 
   d="scan'208";a="3103170"
Subject: Re: [patch V3] percpu_counter: scalability works
From: Shaohua Li <shaohua.li@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "cl@linux.com" <cl@linux.com>, "npiggin@kernel.dk" <npiggin@kernel.dk>
In-Reply-To: <20110517095001.GF20624@htj.dyndns.org>
References: <1305531877.3120.230.camel@edumazet-laptop>
	 <1305534857.2375.55.camel@sli10-conroe>
	 <1305538504.2898.33.camel@edumazet-laptop>
	 <1305555736.2898.46.camel@edumazet-laptop>
	 <1305593751.2375.69.camel@sli10-conroe>
	 <1305608212.9466.45.camel@edumazet-laptop>
	 <1305609768.2375.84.camel@sli10-conroe>
	 <1305622861.2850.21.camel@edumazet-laptop>
	 <20110517091102.GE20624@htj.dyndns.org>
	 <1305625541.2850.29.camel@edumazet-laptop>
	 <20110517095001.GF20624@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 May 2011 09:00:43 +0800
Message-ID: <1305680443.2375.94.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-17 at 17:50 +0800, Tejun Heo wrote:
> Hello, Eric.
> 
> On Tue, May 17, 2011 at 11:45:41AM +0200, Eric Dumazet wrote:
> > _sum() is a bit more precise than percpu_counter_read(), but to make it
> > really precise, we means we have to stop concurrent activities, and we
> > never did in previous/current implementation.
> > 
> > We could add this (as Shaohua and myself tried in various patches)
> > later, if needed, but nowhere in kernel we currently need that.
> > 
> > Even /proc/meminfo doesnt call _sum(&vm_committed_as) but the lazy
> > percpu_counter_read_positive() function...
> > 
> > Reammy _sum() gives a good approximation of the counter, more precise
> > because of the percpu s32 folding, but no guarantee of deviation.
> 
> I'm not asking to make it more accurate but the initial patches from
> Shaohua made the _sum() result to deviate by @batch even when only one
> thread is doing _inc() due to the race window between adding to the
> main counter and resetting the local one.  All I'm asking is closing
> that hole and I'll be completely happy with it.  The lglock does that
> but it's ummm.... not a very nice way to do it.
> 
> Please forget about deviations from concurrent activities.  I don't
> care and nobody should.  All I'm asking is removing that any update
> having the possibility of that unnecessary spike and I don't think
> that would be too hard.
Hmm, we once again to talk about the deviation issue. I thought we
agreed the deviation issue should be resolved in last discussion, but
seems not...

I would suggest you guys seriously look at my v3 patches, which doesn't
use lglock but can solve the deviation issue and has no significant
overhead.

Thanks,
Shaohua

