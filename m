Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162Ab2ITBTm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 21:19:42 -0400
Received: from mga11.intel.com ([192.55.52.93]:30538 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751854Ab2ITBTk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 21:19:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,452,1344236400"; 
   d="scan'208";a="224220377"
Message-ID: <505A6EFD.4070802@intel.com>
Date: Thu, 20 Sep 2012 09:18:53 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
CC: x86@kernel.org, yrl.pp-manager.tt@hitachi.com,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: Distinguish TLB shootdown interrupts from other
 functions call interrupts
References: <20120919090417.24381.87388.stgit@hpxw>
In-Reply-To: <20120919090417.24381.87388.stgit@hpxw>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> @@ -147,7 +148,7 @@ u64 arch_irq_stat_cpu(unsigned int cpu)
>  #ifdef CONFIG_SMP
>  	sum += irq_stats(cpu)->irq_resched_count;
>  	sum += irq_stats(cpu)->irq_call_count;
> -	sum += irq_stats(cpu)->irq_tlb_count;
> +	/* irq_tlb_count is already added to irq_call_count */


redundant comments here?

>  #endif
>  #ifdef CONFIG_X86_THERMAL_VECTOR
>  	sum += irq_stats(cpu)->irq_thermal_count;
> diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
> index 613cd83..0a054db 100644
> --- a/arch/x86/mm/tlb.c
> +++ b/arch/x86/mm/tlb.c
> @@ -98,6 +98,9 @@ static void flush_tlb_func(void *info)
>  {
>  	struct flush_tlb_info *f = info;
>  
> +	/* irq_call_cnt is also incremented; be subtracted on display */


If is it better to move above explanation to irq_call_cnt definition place: harirq.h?

> +	inc_irq_stat(irq_tlb_count);
> +
>  	if (f->flush_mm != this_cpu_read(cpu_tlbstate.active_mm))
>  		return;
>  
> 



-- 
Thanks
    Alex
