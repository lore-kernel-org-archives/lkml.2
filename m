Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818Ab2AMBW6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 20:22:58 -0500
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:48377 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755707Ab2AMBW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 20:22:57 -0500
Message-ID: <4F0F87BE.2020202@oss.ntt.co.jp>
Date: Fri, 13 Jan 2012 10:24:14 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.25) Gecko/20111213 Thunderbird/3.1.17
MIME-Version: 1.0
To: dave@gnu.org
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        lkml <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: MMU: increment stats after event occurrence
References: <1326416880.3416.2.camel@offbook>
In-Reply-To: <1326416880.3416.2.camel@offbook>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/01/13 10:08), Davidlohr Bueso wrote:
> From: Davidlohr Bueso<dave@gnu.org>
>
> It makes more sense to actually increment statistics for tlb flushes and page table entry updates after such _events_ occur, instead of before.

Why?

	Takuya

>
> Signed-off-by: Davidlohr Bueso<dave@gnu.org>
> ---
>   arch/x86/kvm/mmu.c |    4 ++--
>   1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 2a2a9b4..0b7008e 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -3130,8 +3130,8 @@ static int nonpaging_init_context(struct kvm_vcpu *vcpu,
>
>   void kvm_mmu_flush_tlb(struct kvm_vcpu *vcpu)
>   {
> -	++vcpu->stat.tlb_flush;
>   	kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
> +	++vcpu->stat.tlb_flush;
>   }
>
>   static void paging_new_cr3(struct kvm_vcpu *vcpu)
> @@ -3486,8 +3486,8 @@ static void mmu_pte_write_new_pte(struct kvm_vcpu *vcpu,
>   		return;
>           }
>
> -	++vcpu->kvm->stat.mmu_pte_updated;
>   	vcpu->arch.mmu.update_pte(vcpu, sp, spte, new);
> +	++vcpu->kvm->stat.mmu_pte_updated;
>   }
>
>   static bool need_remote_flush(u64 old, u64 new)

