Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018Ab0F1Jzn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 05:55:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3382 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751635Ab0F1Jzm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 05:55:42 -0400
Message-ID: <4C28719A.90406@redhat.com>
Date: Mon, 28 Jun 2010 12:55:38 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 4/10] KVM: MMU: fix forgot to flush all vcpu's tlb
References: <4C2498EC.2010006@cn.fujitsu.com> <4C249BB8.1020308@cn.fujitsu.com>
In-Reply-To: <4C249BB8.1020308@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2010 03:06 PM, Xiao Guangrong wrote:
> After remove a rmap, we should flush all vcpu's tlb
>
> Signed-off-by: Xiao Guangrong<xiaoguangrong@cn.fujitsu.com>
> ---
>   arch/x86/kvm/mmu.c |    2 ++
>   1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 0412ba4..f151540 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -1933,6 +1933,8 @@ static void mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
>   			pgprintk("hfn old %lx new %lx\n",
>   				 spte_to_pfn(*sptep), pfn);
>   			rmap_remove(vcpu->kvm, sptep);
> +			__set_spte(sptep, shadow_trap_nonpresent_pte);
> +			kvm_flush_remote_tlbs(vcpu->kvm);
>   		} else
>   			was_rmapped = 1;
>   	}
>    

Good catch.


-- 
error compiling committee.c: too many arguments to function

