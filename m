Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059Ab0KRLww (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 06:52:52 -0500
Received: from www.tglx.de ([62.245.132.106]:51814 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934Ab0KRLwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 06:52:51 -0500
Date: Thu, 18 Nov 2010 12:52:33 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: a.p.zijlstra@chello.nl, eranian@google.com, linux-kernel@vger.kernel.org,
        x86@kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/4] x86: set cpu masks before calling CPU_STARTING
 notifiers
In-Reply-To: <1290077254-12165-2-git-send-email-andi@firstfloor.org>
Message-ID: <alpine.LFD.2.00.1011181251370.2900@localhost6.localdomain6>
References: <1290077254-12165-1-git-send-email-andi@firstfloor.org> <1290077254-12165-2-git-send-email-andi@firstfloor.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Nov 2010, Andi Kleen wrote:

> From: Andi Kleen <ak@linux.intel.com>
> 
> When booting up a CPU set the various topology masks before
> calling the CPU_STARTING notifier. This way the notifier
> can actually use the masks.
> 
> This is needed for a perf change.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  arch/x86/kernel/smpboot.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index 083e99d..9d2980e 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -281,6 +281,10 @@ static void __cpuinit smp_callin(void)
>  	 */
>  	smp_store_cpu_info(cpuid);
>  
> +	/* This must be done before setting cpu_online_mask */

Can we please fix up that comment to match that change ?

> +	set_cpu_sibling_map(raw_smp_processor_id());
> +	wmb();
> +

Thanks,

	tglx
