Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207Ab2HBNST (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 09:18:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53548 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753604Ab2HBNSP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 09:18:15 -0400
Date: Thu, 2 Aug 2012 09:52:16 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 3/9] KVM: define kvm_hwpoison_pfn statically
Message-ID: <20120802125216.GB25344@amt.cnet>
References: <5014F053.8020305@linux.vnet.ibm.com>
 <5014F0B5.50602@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5014F0B5.50602@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 29, 2012 at 04:13:41PM +0800, Xiao Guangrong wrote:
> Then, get_hwpoison_pfn and is_hwpoison_pfn can be removed
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  arch/x86/kvm/mmu.c       |    2 +-
>  include/linux/kvm_host.h |    4 ++--
>  virt/kvm/kvm_main.c      |   13 +------------
>  3 files changed, 4 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 19bac91..320a781 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -2651,7 +2651,7 @@ static void kvm_send_hwpoison_signal(unsigned long address, struct task_struct *
>  static int kvm_handle_bad_page(struct kvm_vcpu *vcpu, gfn_t gfn, pfn_t pfn)
>  {
>  	kvm_release_pfn_clean(pfn);
> -	if (is_hwpoison_pfn(pfn)) {
> +	if (pfn == kvm_hwpoison_pfn) {
>  		kvm_send_hwpoison_signal(gfn_to_hva(vcpu->kvm, gfn), current);
>  		return 0;
>  	}
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 7cd6871..4de56cd 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -48,7 +48,8 @@
>  #define KVM_MAX_MMIO_FRAGMENTS \
>  	(KVM_MMIO_SIZE / KVM_USER_MMIO_SIZE + KVM_EXTRA_MMIO_FRAGMENTS)
> 
> -#define kvm_fault_pfn	(-EFAULT)
> +#define kvm_fault_pfn		(-EFAULT)
> +#define kvm_hwpoison_pfn	(-EHWPOISON)

Same here as kvm_fault_pfn.

