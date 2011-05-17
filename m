Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569Ab1EQAzy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 20:55:54 -0400
Received: from mga11.intel.com ([192.55.52.93]:11026 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751381Ab1EQAzx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 20:55:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,222,1304319600"; 
   d="scan'208";a="3080080"
Subject: Re: [patch V3] percpu_counter: scalability works
From: Shaohua Li <shaohua.li@intel.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "cl@linux.com" <cl@linux.com>, "npiggin@kernel.dk" <npiggin@kernel.dk>
In-Reply-To: <1305555736.2898.46.camel@edumazet-laptop>
References: <20110511081012.903869567@sli10-conroe.sh.intel.com>
	 <20110511092848.GE1661@htj.dyndns.org>
	 <1305168493.2373.15.camel@sli10-conroe>
	 <20110512082159.GB1030@htj.dyndns.org>
	 <1305190520.2373.18.camel@sli10-conroe>
	 <20110512085922.GD1030@htj.dyndns.org>
	 <1305190936.3795.1.camel@edumazet-laptop>
	 <20110512090534.GE1030@htj.dyndns.org>
	 <1305261477.2373.45.camel@sli10-conroe>
	 <1305264007.2831.14.camel@edumazet-laptop>
	 <20110513052859.GA11088@sli10-conroe.sh.intel.com>
	 <1305268456.2831.38.camel@edumazet-laptop>
	 <1305298300.3866.22.camel@edumazet-laptop>
	 <1305301151.3866.39.camel@edumazet-laptop>
	 <1305304532.3866.54.camel@edumazet-laptop>
	 <1305305190.3866.57.camel@edumazet-laptop>
	 <1305324187.3120.30.camel@edumazet-laptop>
	 <1305507517.2375.10.camel@sli10-conroe>
	 <1305526296.3120.204.camel@edumazet-laptop>
	 <1305527828.2375.28.camel@sli10-conroe>
	 <1305528912.3120.213.camel@edumazet-laptop>
	 <1305530143.2375.42.camel@sli10-conroe>
	 <1305531877.3120.230.camel@edumazet-laptop>
	 <1305534857.2375.55.camel@sli10-conroe>
	 <1305538504.2898.33.camel@edumazet-laptop>
	 <1305555736.2898.46.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 May 2011 08:55:51 +0800
Message-ID: <1305593751.2375.69.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-16 at 22:22 +0800, Eric Dumazet wrote:
> Le lundi 16 mai 2011 à 11:35 +0200, Eric Dumazet a écrit :
> 
> > Given that vm_committed has one percent resolution need
> > (sysctl_overcommit_ratio is expressed with percent resolution), it
> > should be used with an appropriate batch value, something like :
> > 
> > vm_committed_as_batch = max(percpu_counter_batch,
> > 			    total_ram_pages/(num_possible_cpus()*100));
> > 
> 
> 
> Funny thing with vm_committed_as is we dont even read its value with
> default vm configuration 
> 
> (sysctl_overcommit_memory == OVERCOMMIT_ALWAYS or OVERCOMMIT_GUESS)
> 
> [ In this case, we read it only for /proc/meminfo output ]
> 
> Ideally, we could dynamically change vm_committed_as_batch when
> sysctl_overcommit_memory or other param is changed. This would need a
> mechanism to ask all cpus to transfert/clear their local s32 into global
> fbc->count [when lowering vm_committed_as_batch]
I actually posted something like this before
http://marc.info/?l=linux-mm&m=130144785326028&w=2
but this could affect /proc/meminfo read.

> Another idea would be to use an atomic when manipulating the percpu s32,
> so that __percpu_counter_sum() is able to make this operation itself :
> At the end of __percpu_counter_sum(), fbc->count would be the final
> result, and all s32 would be zero, unless some cpus called _add()
> meanwhile.
don't understand it. But if concurrent _add can introduce deviation,
this is good.

I'm still interesting in improving percpu_counter itself. If we can
improve it, why we don't? My patch doesn't slow down anything for all
tests. Why didn't you ever look at it?

Thanks,
Shaohua

