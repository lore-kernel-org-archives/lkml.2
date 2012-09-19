Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452Ab2ISKwg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 06:52:36 -0400
Received: from mail.x86-64.org ([217.9.48.20]:35820 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751570Ab2ISKwc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 06:52:32 -0400
Date: Wed, 19 Sep 2012 12:52:27 +0200
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Dump family, model, stepping of the BSP
Message-ID: <20120919105227.GC4577@aftab.osrc.amd.com>
References: <1347640666-13638-1-git-send-email-bp@amd64.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347640666-13638-1-git-send-email-bp@amd64.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 06:37:46PM +0200, Borislav Petkov wrote:
> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> When acting on a user bug report, we find ourselves constantly asking
> for /proc/cpuinfo in order to know the exact family, model, stepping of
> the CPU in question. Instead of having to ask this, add this to dmesg
> so that it is visible and no ambiguities can ensue from looking at the
> official name string of the CPU coming from CPUID and trying to map it
> to f/m/s.
> 
> Output then looks like this:
> 
> [    0.146041] smpboot: CPU0: AMD FX(tm)-8100 Eight-Core Processor (fam: 15 model: 01 stepping: 02)

Guys, any comments on this one? I think dumping the f/m/s is very
helpful.

Thanks.

> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> ---
>  arch/x86/kernel/cpu/common.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index 2ea24da6f7fb..90f7f8f9212f 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -1022,14 +1022,16 @@ void __cpuinit print_cpu_info(struct cpuinfo_x86 *c)
>  		printk(KERN_CONT "%s ", vendor);
>  
>  	if (c->x86_model_id[0])
> -		printk(KERN_CONT "%s", c->x86_model_id);
> +		printk(KERN_CONT "%s", strim(c->x86_model_id));
>  	else
>  		printk(KERN_CONT "%d86", c->x86);
>  
> +	printk(KERN_CONT " (fam: %02x model: %02x", c->x86, c->x86_model);
> +
>  	if (c->x86_mask || c->cpuid_level >= 0)
> -		printk(KERN_CONT " stepping %02x\n", c->x86_mask);
> +		printk(KERN_CONT " stepping: %02x)\n", c->x86_mask);
>  	else
> -		printk(KERN_CONT "\n");
> +		printk(KERN_CONT ")\n");
>  
>  	print_cpu_msr(c);
>  }
> -- 
> 1.7.11.rc1
> 
> 

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
