Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751803Ab2FKIWz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 04:22:55 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:32884 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab2FKIWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 04:22:53 -0400
Date: Mon, 11 Jun 2012 10:22:49 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] x86/apic: Eliminate cpu_mask_to_apicid() operation
Message-ID: <20120611082249.GC31556@gmail.com>
References: <20120605112353.GA11457@dhcp-26-207.brq.redhat.com>
 <20120606082231.GD5991@gmail.com>
 <20120607131559.GF4759@dhcp-26-207.brq.redhat.com>
 <1339107848.28766.104.camel@sbsiddha-desk.sc.intel.com>
 <20120608165330.GE4777@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120608165330.GE4777@dhcp-26-207.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexander Gordeev <agordeev@redhat.com> wrote:

> @@ -2151,7 +2134,12 @@ int default_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
>  			break;
>  	}
>  
> -	return __default_cpu_to_apicid(cpu, apicid);
> +	if (likely((unsigned int)cpu < nr_cpu_ids)) {
> +		*apicid = per_cpu(x86_cpu_to_apicid, cpu);
> +		return 0;
> +	} else {
> +		return -EINVAL;
> +	}

The type cast is rather ugly - why not change the cpu type to 
unsigned int?

Also, the else block is superfluous, just make it a return 
-EINVAL?

Thanks,

	Ingo
