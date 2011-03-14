Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488Ab1CNMeI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 08:34:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33164 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031Ab1CNMeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 08:34:05 -0400
Date: Mon, 14 Mar 2011 13:33:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: hpa@zytor.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, tlb: small cleanup for native_flush_tlb_others
Message-ID: <20110314123355.GA27477@elte.hu>
References: <4D7DBBE3.1010104@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D7DBBE3.1010104@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Xiao Guangrong <xiaoguangrong@cn.fujitsu.com> wrote:

> Use smp_processor_id instead of get_cpu and put_cpu since
> the caller has already disabled preemption
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  arch/x86/mm/tlb.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
> index 6acc724..92849d0 100644
> --- a/arch/x86/mm/tlb.c
> +++ b/arch/x86/mm/tlb.c
> @@ -211,11 +211,10 @@ void native_flush_tlb_others(const struct cpumask *cpumask,
>  	if (is_uv_system()) {
>  		unsigned int cpu;
>  
> -		cpu = get_cpu();
> +		cpu = smp_processor_id();
>  		cpumask = uv_flush_tlb_others(cpumask, mm, va, cpu);
>  		if (cpumask)
>  			flush_tlb_others_ipi(cpumask, mm, va);
> -		put_cpu();
>  		return;

There's multiple callers. Could you please update the changelog with the list of 
callers and a statement that all of them disable preemption already?

Thanks,

	Ingo
