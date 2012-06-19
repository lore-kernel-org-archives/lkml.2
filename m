Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545Ab2FSAvX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 20:51:23 -0400
Received: from mga01.intel.com ([192.55.52.88]:6090 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752459Ab2FSAvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 20:51:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="181836960"
Subject: Re: [PATCH 1/2] x86, irq: update irq_cfg domain unless the new
 affinity is a subset of the current domain
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: yinghai@kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        gorcunov@openvz.org, Ingo Molnar <mingo@kernel.org>
Date: Mon, 18 Jun 2012 17:51:37 -0700
In-Reply-To: <20120618091740.GK3383@dhcp-26-207.brq.redhat.com>
References: <1337643880.1997.166.camel@sbsiddha-desk.sc.intel.com>
	 <1337644682-19854-1-git-send-email-suresh.b.siddha@intel.com>
	 <20120606172017.GA4777@dhcp-26-207.brq.redhat.com>
	 <1339806320.3475.68.camel@sbsiddha-desk.sc.intel.com>
	 <20120618091740.GK3383@dhcp-26-207.brq.redhat.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1340067097.3696.6.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-18 at 11:17 +0200, Alexander Gordeev wrote:
> I would suggest to go further and generalize your idea and introduce something
> like compare_domains() instead sub_domain flag. This would help us to keep/let
> __assign_irq_vector() be more generic and hide domains treating logic in
> drivers.

That sounds good.

> @@ -1138,47 +1138,50 @@ __assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
>  		int new_cpu;
>  		int vector, offset;
>  		bool more_domains;
> +		int cmp_domains;
>  
> -		more_domains = apic->vector_allocation_domain(cpu, tmp_mask);
> +		more = apic->vector_allocation_domain(cpu, mask, tmp_mask);
> +		cmp = apic->compare_domains(tmp_mask, cfg->domain);

I think we should be able to consolidate both of them into one
apic_driver specific routine. Also I think we should be able to use the
tmp_mask in each round and minimize the number of unnecessary
for_each_cpu iterations. And that should clean up the more_domains bool
logic we did earlier.

Will post the complete patch in a day.

thanks,
suresh



