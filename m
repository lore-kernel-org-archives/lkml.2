Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041Ab2E1K5a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 06:57:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18981 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751176Ab2E1K53 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 06:57:29 -0400
Message-ID: <4FC35A15.6080000@redhat.com>
Date: Mon, 28 May 2012 13:57:25 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: MMU: fix huge page adapted on non-PAE host
References: <4FC316E3.6080607@linux.vnet.ibm.com>
In-Reply-To: <4FC316E3.6080607@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2012 09:10 AM, Xiao Guangrong wrote:
> The huge page size is 4M on non-PAE host, but 2M page size is used in
> transparent_hugepage_adjust(), so the page we get after adjust the
> mapping level is not the head page, the BUG_ON() will be triggered
> 
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 72102e0..be3cea4 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -2595,8 +2595,7 @@ static void transparent_hugepage_adjust(struct kvm_vcpu *vcpu,
>  			*gfnp = gfn;
>  			kvm_release_pfn_clean(pfn);
>  			pfn &= ~mask;
> -			if (!get_page_unless_zero(pfn_to_page(pfn)))
> -				BUG();
> +			kvm_get_pfn(pfn);
>  			*pfnp = pfn;
>  		}
>  	}

Shouldn't we adjust mask instead?

-- 
error compiling committee.c: too many arguments to function
