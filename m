Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976Ab1HRRT4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 13:19:56 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35418 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844Ab1HRRTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 13:19:55 -0400
Subject: Re: [tip:x86/cpu] x86, intel, power: Correct the
 MSR_IA32_ENERGY_PERF_BIAS message
From: Christoph Fritz <chf.fritz@googlemail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Len Brown <lenb@kernel.org>
Cc: stable@kernel.org, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <tip-17edf2d79f1ea6dfdb4c444801d928953b9f98d6@git.kernel.org>
References: <alpine.LFD.2.02.1107151732480.18606@x980>
	 <tip-17edf2d79f1ea6dfdb4c444801d928953b9f98d6@git.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Aug 2011 19:23:07 +0200
Message-ID: <1313688187.3202.26.camel@lovely>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-07-16 at 18:52 +0000, tip-bot for Len Brown wrote:
> Commit-ID:  17edf2d79f1ea6dfdb4c444801d928953b9f98d6
> Gitweb:     http://git.kernel.org/tip/17edf2d79f1ea6dfdb4c444801d928953b9f98d6
> Author:     Len Brown <len.brown@intel.com>
> AuthorDate: Fri, 15 Jul 2011 17:37:15 -0400
> Committer:  H. Peter Anvin <hpa@linux.intel.com>
> CommitDate: Fri, 15 Jul 2011 15:13:55 -0700
> 
> x86, intel, power: Correct the MSR_IA32_ENERGY_PERF_BIAS message
> 
> Fix the printk_once() so that it actually prints (didn't print before
> due to a stray comma.)
> 
> [ hpa: changed to an incremental patch and adjusted the description
>   accordingly. ]
> 
> Signed-off-by: Len Brown <len.brown@intel.com>
> Link: http://lkml.kernel.org/r/alpine.LFD.2.02.1107151732480.18606@x980
> Cc: <table@kernel.org>

This "table" should be stable :)

Cc: <stable@kernel.org>
Reviewed-by: Christoph Fritz <chf.fritz@googlemail.com>

Thanks,
 Christoph

> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/intel.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
> index da0d779..ed6086e 100644
> --- a/arch/x86/kernel/cpu/intel.c
> +++ b/arch/x86/kernel/cpu/intel.c
> @@ -465,11 +465,11 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
>  		u64 epb;
>  
>  		rdmsrl(MSR_IA32_ENERGY_PERF_BIAS, epb);
> -		if ((epb & 0xF) == 0) {
> -			printk_once(KERN_WARNING, "x86: updated energy_perf_bias"
> -				" to 'normal' from 'performance'\n"
> -				"You can view and update epb via utility,"
> -				" such as x86_energy_perf_policy(8)\n");
> +		if ((epb & 0xF) == ENERGY_PERF_BIAS_PERFORMANCE) {
> +			printk_once(KERN_WARNING "ENERGY_PERF_BIAS:"
> +				" Set to 'normal', was 'performance'\n"
> +				"ENERGY_PERF_BIAS: View and update with"
> +				" x86_energy_perf_policy(8)\n");
>  			epb = (epb & ~0xF) | ENERGY_PERF_BIAS_NORMAL;
>  			wrmsrl(MSR_IA32_ENERGY_PERF_BIAS, epb);
>  		}
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



