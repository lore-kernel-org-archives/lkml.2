Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759524Ab2HXPQq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 11:16:46 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:44171 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755629Ab2HXPQn convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Fri, 24 Aug 2012 11:16:43 -0400
Message-Id: <5037A8E7020000780008A78B@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Fri, 24 Aug 2012 16:16:39 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Alex Shi" <alex.shi@intel.com>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <hpa@zytor.com>
Cc: <konrad.wilk@oracle.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen: fix logical error in tlb flushing
References: <1345798513-3566-1-git-send-email-alex.shi@intel.com>
In-Reply-To: <1345798513-3566-1-git-send-email-alex.shi@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 24.08.12 at 10:55, Alex Shi <alex.shi@intel.com> wrote:
> While TLB_FLUSH_ALL gets passed as 'end' argument to
> flush_tlb_others(), the Xen code was made to check its 'start'
> parameter. That may give a incorrect op.cmd to MMUEXT_INVLPG_MULTI
> instead of MMUEXT_TLB_FLUSH_MULTI. Then it causes some page can not
> be flushed from TLB.
> 
> This patch fixed this issue.
> 
> Reported-by: Jan Beulich <jbeulich@suse.com>
> Signed-off-by: Alex Shi <alex.shi@intel.com>

Acked-by: Jan Beulich <jbeulich@suse.com>

> ---
>  arch/x86/xen/mmu.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
> index b65a761..5141d80 100644
> --- a/arch/x86/xen/mmu.c
> +++ b/arch/x86/xen/mmu.c
> @@ -1283,7 +1283,7 @@ static void xen_flush_tlb_others(const struct cpumask 
> *cpus,
>  	cpumask_clear_cpu(smp_processor_id(), to_cpumask(args->mask));
>  
>  	args->op.cmd = MMUEXT_TLB_FLUSH_MULTI;
> -	if (start != TLB_FLUSH_ALL && (end - start) <= PAGE_SIZE) {
> +	if (end != TLB_FLUSH_ALL && (end - start) <= PAGE_SIZE) {
>  		args->op.cmd = MMUEXT_INVLPG_MULTI;
>  		args->op.arg1.linear_addr = start;
>  	}
> -- 
> 1.7.5.4
> 
> .



