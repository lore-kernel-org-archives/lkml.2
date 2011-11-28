Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028Ab1K1M4m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 07:56:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28194 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753536Ab1K1M4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 07:56:40 -0500
Date: Mon, 28 Nov 2011 14:56:37 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 3/5] KVM: x86: remove the dead code of KVM_EXIT_HYPERCALL
Message-ID: <20111128125637.GS2557@redhat.com>
References: <4ED3811F.1070101@linux.vnet.ibm.com>
 <4ED38182.6070505@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ED38182.6070505@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 08:41:38PM +0800, Xiao Guangrong wrote:
> KVM_EXIT_HYPERCALL is not used anymore, so remove the code
> 
Why not remove the define as well?

> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  arch/x86/kvm/x86.c |    4 ----
>  1 files changed, 0 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index d54746c..7b6fd72 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5386,10 +5386,6 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
>  	if (r <= 0)
>  		goto out;
> 
> -	if (kvm_run->exit_reason == KVM_EXIT_HYPERCALL)
> -		kvm_register_write(vcpu, VCPU_REGS_RAX,
> -				     kvm_run->hypercall.ret);
> -
>  	r = __vcpu_run(vcpu);
> 
>  out:
> -- 
> 1.7.7.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--
			Gleb.
