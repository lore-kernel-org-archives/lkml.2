Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920Ab2LKHTm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 02:19:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1552 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751918Ab2LKHTk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 02:19:40 -0500
Date: Tue, 11 Dec 2012 09:19:38 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Jesse Larrew <jlarrew@linux.vnet.ibm.com>
Cc: KVM list <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kvm/vmx: fix the return value of handle_vmcall()
Message-ID: <20121211071938.GB11016@redhat.com>
References: <50C653ED.9000009@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50C653ED.9000009@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2012 at 03:28:13PM -0600, Jesse Larrew wrote:
> 
> The return value of kvm_emulate_hypercall() is intended to inform callers
> whether or not we need to exit to userspace. However, handle_vmcall()
> currently ignores the return value.
> 
No, it it not. KVM does not handle vmcalls in userspace.

> This patch simply propogates the return value from kvm_emulate_hypercall()
> to callers so that it can be acted upon appropriately.
> 
> Signed-off-by: Jesse Larrew <jlarrew@linux.vnet.ibm.com>
> ---
>  arch/x86/kvm/vmx.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index f858159..8b37f5f 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -4682,8 +4682,7 @@ static int handle_halt(struct kvm_vcpu *vcpu)
>  static int handle_vmcall(struct kvm_vcpu *vcpu)
>  {
>  	skip_emulated_instruction(vcpu);
> -	kvm_emulate_hypercall(vcpu);
> -	return 1;
> +	return kvm_emulate_hypercall(vcpu);
>  }
>  
>  static int handle_invd(struct kvm_vcpu *vcpu)
> -- 
> 1.7.11.7
> 
> Jesse Larrew
> Software Engineer, KVM Team
> IBM Linux Technology Center
> Phone: (512) 973-2052 (T/L: 363-2052)
> jlarrew@linux.vnet.ibm.com
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--
			Gleb.
