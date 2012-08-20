Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307Ab2HTFYF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 01:24:05 -0400
Received: from mga11.intel.com ([192.55.52.93]:46167 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868Ab2HTFYC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 01:24:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,795,1336374000"; 
   d="scan'208";a="210767190"
Message-ID: <1345440349.30835.3.camel@ymzhang.sh.intel.com>
Subject: Re: [PATCH] x86/fixup_irq: using the cpu_online_mask instead of
 cpu_all_mask
From: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Reply-To: yanmin_zhang@linux.intel.com
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>, linux-kernel@vger.kernel.org
Cc: "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>
Date: Mon, 20 Aug 2012 13:25:49 +0800
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4A137286@SHSMSX101.ccr.corp.intel.com>
References: <27240C0AC20F114CBF8149A2696CBE4A137286@SHSMSX101.ccr.corp.intel.com>
Organization: Intel.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-08-14 at 06:55 +0000, Liu, Chuansheng wrote:
> From: liu chuansheng <chuansheng.liu@intel.com>
> Subject: [PATCH] x86/fixup_irq: using the cpu_online_mask instead of cpu_all_mask
> 
> When one CPU is going down, and this CPU is the last one in irq affinity,
> current code is setting cpu_all_mask as the new affinity for that irq.
> 
> But for some system the firmware maybe send the interrupt to each CPU
> in irq affinity averagely, and cpu_all_mask include all CPUs.
> 
> Here replacing cpu_all_mask with cpu_online_mask, it is more reasonable
> and fittable.
It's a good finding. The issue exists on Medfield Android mobile. 


> 
> Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
> ---
>  arch/x86/kernel/irq.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
> index 7ad683d..d44f782 100644
> --- a/arch/x86/kernel/irq.c
> +++ b/arch/x86/kernel/irq.c
> @@ -270,7 +270,7 @@ void fixup_irqs(void)
>  
>                 if (cpumask_any_and(affinity, cpu_online_mask) >= nr_cpu_ids) {
>                         break_affinity = 1;
> -                       affinity = cpu_all_mask;
> +                       affinity = cpu_online_mask;
>                 }
>  
>                 chip = irq_data_get_irq_chip(data);


