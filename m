Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab2HBNSS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 09:18:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20230 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751540Ab2HBNSP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 09:18:15 -0400
Date: Thu, 2 Aug 2012 09:51:32 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/9] KVM: define kvm_fault_pfn statically
Message-ID: <20120802125132.GA25344@amt.cnet>
References: <5014F053.8020305@linux.vnet.ibm.com>
 <5014F08A.7030408@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5014F08A.7030408@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 29, 2012 at 04:12:58PM +0800, Xiao Guangrong wrote:
> After that, the exported and un-inline function, get_fault_pfn,
> can be removed
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  arch/x86/kvm/mmu.c       |    2 +-
>  include/linux/kvm_host.h |    3 ++-
>  virt/kvm/kvm_main.c      |   12 +++---------
>  3 files changed, 6 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index a9a2052..19bac91 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -2514,7 +2514,7 @@ static pfn_t pte_prefetch_gfn_to_pfn(struct kvm_vcpu *vcpu, gfn_t gfn,
> 
>  	slot = gfn_to_memslot_dirty_bitmap(vcpu, gfn, no_dirty_log);
>  	if (!slot)
> -		return get_fault_pfn();
> +		return kvm_fault_pfn;
> 
>  	hva = gfn_to_hva_memslot(slot, gfn);
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index dbc65f9..7cd6871 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -48,6 +48,8 @@
>  #define KVM_MAX_MMIO_FRAGMENTS \
>  	(KVM_MMIO_SIZE / KVM_USER_MMIO_SIZE + KVM_EXTRA_MMIO_FRAGMENTS)
> 
> +#define kvm_fault_pfn	(-EFAULT)
> +

This is confusing, it appears to be a variable not a definition. 
Use "#define KVM_FAULT_PFN_ERR" please.

