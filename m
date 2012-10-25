Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935441Ab2JYJtT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 05:49:19 -0400
Received: from mail.skyhub.de ([78.46.96.112]:36255 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934884Ab2JYJtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 05:49:18 -0400
Date: Thu, 25 Oct 2012 11:49:14 +0200
From: Borislav Petkov <bp@alien8.de>
To: Ivan Hu <ivan.hu@canonical.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        alex.shi@intel.com, borislav.petkov@amd.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, intel, power: Modify the MSR_IA32_ENERGY_PERF_BIAS
 message from warning to info
Message-ID: <20121025094914.GA17169@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Ivan Hu <ivan.hu@canonical.com>, tglx@linutronix.de,
	mingo@redhat.com, hpa@zytor.com, x86@kernel.org, alex.shi@intel.com,
	borislav.petkov@amd.com, linux-kernel@vger.kernel.org
References: <1351157280-9935-1-git-send-email-ivan.hu@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1351157280-9935-1-git-send-email-ivan.hu@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 05:28:00PM +0800, Ivan Hu wrote:
> Intel IA32 program guild doesn't mention that this MSR should be set by
> BIOS, instead, it mentions "Software can use whatever criteria it sees
> fit to program the MSR with the appropriate value.". Discuss with IBV,
> they'd like to keep this MSR as default, and let OS to change value if desired.
> This message should be more proper set as an info than a warning.

What is the difference? It'll appear in default dmesg loglevel settings
anyway.

> Signed-off-by: Ivan Hu <ivan.hu@canonical.com>
> ---
>  arch/x86/kernel/cpu/intel.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
> index 198e019..2bdc6bf 100644
> --- a/arch/x86/kernel/cpu/intel.c
> +++ b/arch/x86/kernel/cpu/intel.c
> @@ -466,7 +466,7 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
>  
>  		rdmsrl(MSR_IA32_ENERGY_PERF_BIAS, epb);
>  		if ((epb & 0xF) == ENERGY_PERF_BIAS_PERFORMANCE) {
> -			printk_once(KERN_WARNING "ENERGY_PERF_BIAS:"
> +			printk_once(KERN_INFO "ENERGY_PERF_BIAS:"

While you're at it, you can do pr_info_once to shorten this line a bit.

>  				" Set to 'normal', was 'performance'\n"
>  				"ENERGY_PERF_BIAS: View and update with"
>  				" x86_energy_perf_policy(8)\n");
> -- 
> 1.7.10.4

-- 
Regards/Gruss,
    Boris.
