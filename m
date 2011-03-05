Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab1CERDj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 12:03:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13438 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752900Ab1CERDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 12:03:35 -0500
Date: Sat, 5 Mar 2011 13:48:05 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/10] KVM: MMU: fix kvm_mmu_get_spte_hierarchy
Message-ID: <20110305164805.GB4607@amt.cnet>
References: <4D70C569.1030107@cn.fujitsu.com>
 <4D70C597.4070105@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D70C597.4070105@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 04, 2011 at 06:57:27PM +0800, Xiao Guangrong wrote:
> Don not walk to the next level if spte is mapping to the large page
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  arch/x86/kvm/mmu.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index b9bf016..10e0982 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -3819,7 +3819,8 @@ int kvm_mmu_get_spte_hierarchy(struct kvm_vcpu *vcpu, u64 addr, u64 sptes[4])
>  	for_each_shadow_entry(vcpu, addr, iterator) {
>  		sptes[iterator.level-1] = *iterator.sptep;
>  		nr_sptes++;
> -		if (!is_shadow_present_pte(*iterator.sptep))
> +		if (!is_shadow_present_pte(*iterator.sptep) ||
> +		      is_last_spte(*iterator.sptep, iterator.level))
>  			break;
>  	}
>  	spin_unlock(&vcpu->kvm->mmu_lock);

shadow_walk_okay covers that case.

