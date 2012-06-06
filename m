Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758221Ab2FFUOt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 16:14:49 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:42313 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757513Ab2FFUOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 16:14:48 -0400
Date: Wed, 6 Jun 2012 16:07:15 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Borislav Petkov <bp@amd64.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Andre Przywara <andre.przywara@amd.com>, jeremy@goop.org,
        xen-devel@lists.xensource.com, LKML <linux-kernel@vger.kernel.org>,
        Jan Beulich <JBeulich@suse.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 2/4] x86, CPU: Fix show_msr MSR accessing function
Message-ID: <20120606200715.GC9602@phenom.dumpdata.com>
References: <1338562358-28182-1-git-send-email-bp@amd64.org>
 <1338562358-28182-3-git-send-email-bp@amd64.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338562358-28182-3-git-send-email-bp@amd64.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2012 at 04:52:36PM +0200, Borislav Petkov wrote:
> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> There's no real reason why, when showing the MSRs on a CPU at boottime,
> we should be using the AMD-specific variant. Simply use the generic safe
> one which handles #GPs just fine.

Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> 
> Cc: Yinghai Lu <yinghai@kernel.org>
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> ---
>  arch/x86/kernel/cpu/common.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index 82f29e70d058..232fba2d54c9 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -947,7 +947,7 @@ static void __cpuinit __print_cpu_msr(void)
>  		index_max = msr_range_array[i].max;
>  
>  		for (index = index_min; index < index_max; index++) {
> -			if (rdmsrl_amd_safe(index, &val))
> +			if (rdmsrl_safe(index, &val))
>  				continue;
>  			printk(KERN_INFO " MSR%08x: %016llx\n", index, val);
>  		}
> -- 
> 1.7.9.3.362.g71319
