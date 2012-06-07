Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933331Ab2FGW0e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 18:26:34 -0400
Received: from mga14.intel.com ([143.182.124.37]:6539 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933235Ab2FGW0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 18:26:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="109286571"
Subject: Re: [PATCH 5/8] x86/apic: Try to spread IRQ vectors to different
 priority levels
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Yinghai Lu <yinghai@kernel.org>
Date: Thu, 07 Jun 2012 15:26:03 -0700
In-Reply-To: <20120607131514.GD4759@dhcp-26-207.brq.redhat.com>
References: <20120605112353.GA11457@dhcp-26-207.brq.redhat.com>
	 <20120606082231.GD5991@gmail.com>
	 <20120607131514.GD4759@dhcp-26-207.brq.redhat.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1339107963.28766.107.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-07 at 15:15 +0200, Alexander Gordeev wrote:
> When assigning a new vector it is primarially done by adding 8 to the
> previously given out vector number. Hence, two consequently allocated
> vector numbers would likely fall into the same priority level. Try to
> spread vector numbers to different priority levels better by changing
> the step from 8 to 16.
> 

Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>

> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> ---
>  arch/x86/kernel/apic/io_apic.c |    7 +++----
>  1 files changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> index 74c5697..05af3d3 100644
> --- a/arch/x86/kernel/apic/io_apic.c
> +++ b/arch/x86/kernel/apic/io_apic.c
> @@ -1112,7 +1112,7 @@ __assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
>  	 * 0x80, because int 0x80 is hm, kind of importantish. ;)
>  	 */
>  	static int current_vector = FIRST_EXTERNAL_VECTOR + VECTOR_OFFSET_START;
> -	static int current_offset = VECTOR_OFFSET_START % 8;
> +	static int current_offset = VECTOR_OFFSET_START % 16;
>  	unsigned int old_vector;
>  	int cpu, err;
>  	cpumask_var_t tmp_mask;
> @@ -1148,10 +1148,9 @@ __assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
>  		vector = current_vector;
>  		offset = current_offset;
>  next:
> -		vector += 8;
> +		vector += 16;
>  		if (vector >= first_system_vector) {
> -			/* If out of vectors on large boxen, must share them. */
> -			offset = (offset + 1) % 8;
> +			offset = (offset + 1) % 16;
>  			vector = FIRST_EXTERNAL_VECTOR + offset;
>  		}
>  		if (unlikely(current_vector == vector))
> -- 
> 1.7.7.6
> 


