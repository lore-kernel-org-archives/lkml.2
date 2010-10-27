Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224Ab0J0K67 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 06:58:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44993 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752521Ab0J0K65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 06:58:57 -0400
Date: Wed, 27 Oct 2010 12:58:49 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 8/8] KVM: add debugfs file to show the number of async
 pf
Message-ID: <20101027105849.GQ26191@redhat.com>
References: <4CC7EA7D.5020901@cn.fujitsu.com>
 <4CC7EC9B.6020507@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CC7EC9B.6020507@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 27, 2010 at 05:10:51PM +0800, Xiao Guangrong wrote:
> It can help us to see the state of async pf
> 
I have patch to add three async pf statistics:
apf_not_present
apf_present
apf_doublefault

But Avi now wants to deprecate debugfs interface completely and move
towards ftrace, so I had to drop it.

> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  arch/x86/kvm/x86.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c0e7ad0..2dd8059 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -88,6 +88,8 @@ static u64 __read_mostly efer_reserved_bits = 0xfffffffffffffffeULL;
>  
>  #define VM_STAT(x) offsetof(struct kvm, stat.x), KVM_STAT_VM
>  #define VCPU_STAT(x) offsetof(struct kvm_vcpu, stat.x), KVM_STAT_VCPU
> +#define VCPU_ASYNC_PF_STAT offsetof(struct kvm_vcpu, async_pf.queued), \
> +							KVM_STAT_VCPU
>  
>  static void update_cr8_intercept(struct kvm_vcpu *vcpu);
>  static int kvm_dev_ioctl_get_supported_cpuid(struct kvm_cpuid2 *cpuid,
> @@ -141,6 +143,7 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
>  	{ "insn_emulation_fail", VCPU_STAT(insn_emulation_fail) },
>  	{ "irq_injections", VCPU_STAT(irq_injections) },
>  	{ "nmi_injections", VCPU_STAT(nmi_injections) },
> +	{ "async_pf_queued", VCPU_ASYNC_PF_STAT},
>  	{ "mmu_shadow_zapped", VM_STAT(mmu_shadow_zapped) },
>  	{ "mmu_pte_write", VM_STAT(mmu_pte_write) },
>  	{ "mmu_pte_updated", VM_STAT(mmu_pte_updated) },
> -- 
> 1.7.0.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
			Gleb.
