Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759280Ab0FJOiJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 10:38:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29586 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753226Ab0FJOiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 10:38:05 -0400
Message-ID: <4C10F46B.9090006@redhat.com>
Date: Thu, 10 Jun 2010 17:19:23 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: kvm@vger.kernel.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [19/23] KVM: Fix unused but set warnings
References: <20100610110.764742110@firstfloor.org> <20100610111055.4FB51B1A2B@basil.firstfloor.org>
In-Reply-To: <20100610111055.4FB51B1A2B@basil.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2010 02:10 PM, Andi Kleen wrote:
> No real bugs in this one, the real bug I found is in a separate
> patch.
>
>
> Index: linux-2.6.35-rc2-gcc/arch/x86/kvm/vmx.c
> ===================================================================
> --- linux-2.6.35-rc2-gcc.orig/arch/x86/kvm/vmx.c
> +++ linux-2.6.35-rc2-gcc/arch/x86/kvm/vmx.c
> @@ -1624,10 +1624,9 @@ static void enter_pmode(struct kvm_vcpu
>   static gva_t rmode_tss_base(struct kvm *kvm)
>   {
>   	if (!kvm->arch.tss_addr) {
> -		struct kvm_memslots *slots;
>   		gfn_t base_gfn;
>
> -		slots = kvm_memslots(kvm);
> +		kvm_memslots(kvm);
>   		base_gfn = kvm->memslots->memslots[0].base_gfn +
>   				 kvm->memslots->memslots[0].npages - 3;
>   		return base_gfn<<  PAGE_SHIFT;
>    

I think the base_gfn assignment below needs to use slots to get the rcu 
dereference correct.  I'll apply the patch without this hunk and fix it 
independently.


-- 
error compiling committee.c: too many arguments to function

