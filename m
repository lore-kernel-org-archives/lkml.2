Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531Ab2FKKvU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 06:51:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30091 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753236Ab2FKKvS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 06:51:18 -0400
Date: Mon, 11 Jun 2012 12:51:11 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] x86/apic: Eliminate cpu_mask_to_apicid() operation
Message-ID: <20120611105110.GB3383@dhcp-26-207.brq.redhat.com>
References: <20120605112353.GA11457@dhcp-26-207.brq.redhat.com>
 <20120606082231.GD5991@gmail.com>
 <20120607131559.GF4759@dhcp-26-207.brq.redhat.com>
 <1339107848.28766.104.camel@sbsiddha-desk.sc.intel.com>
 <20120608165330.GE4777@dhcp-26-207.brq.redhat.com>
 <20120611082249.GC31556@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120611082249.GC31556@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2012 at 10:22:49AM +0200, Ingo Molnar wrote:
> > @@ -2151,7 +2134,12 @@ int default_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
> >  			break;
> >  	}
> >  
> > -	return __default_cpu_to_apicid(cpu, apicid);
> > +	if (likely((unsigned int)cpu < nr_cpu_ids)) {
> > +		*apicid = per_cpu(x86_cpu_to_apicid, cpu);
> > +		return 0;
> > +	} else {
> > +		return -EINVAL;
> > +	}
> 
> The type cast is rather ugly - why not change the cpu type to 
> unsigned int?

Tried to preserve in changelog as much original code as possible.
Suppose, it has been int to match cpumask_* functions.

> Also, the else block is superfluous, just make it a return 
> -EINVAL?

What about posting a separate patch, with the rest of apic drivers that have
the same branch/cast fixed, altogether?

> 
> Thanks,
> 
> 	Ingo

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
