Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932433Ab0J0K3X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 06:29:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41536 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760629Ab0J0K3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 06:29:21 -0400
Date: Wed, 27 Oct 2010 12:29:13 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 3/8] KVM: fix searching async gfn in
 kvm_async_pf_gfn_slot
Message-ID: <20101027102913.GM26191@redhat.com>
References: <4CC7EA7D.5020901@cn.fujitsu.com>
 <4CC7EAE5.907@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CC7EAE5.907@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 27, 2010 at 05:03:33PM +0800, Xiao Guangrong wrote:
> The 'gfn' is not recorded if the next slot is empty
> 
This function is not used for gfn recording, only to search for recorded
gfn, but without the fix it walks over all entries if gfn is not in the
hash.

> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Acked-by: Gleb Natapov <gleb@redhat.com>

> ---
>  arch/x86/kvm/x86.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 7876ec8..16f42ff 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6207,8 +6207,8 @@ static u32 kvm_async_pf_gfn_slot(struct kvm_vcpu *vcpu, gfn_t gfn)
>  	u32 key = kvm_async_pf_hash_fn(gfn);
>  
>  	for (i = 0; i < roundup_pow_of_two(ASYNC_PF_PER_VCPU) &&
> -		     (vcpu->arch.apf.gfns[key] != gfn ||
> -		      vcpu->arch.apf.gfns[key] == ~0); i++)
> +		     (vcpu->arch.apf.gfns[key] != gfn &&
> +		      vcpu->arch.apf.gfns[key] != ~0); i++)
>  		key = kvm_async_pf_next_probe(key);
>  
>  	return key;
> -- 
> 1.7.0.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--
			Gleb.
