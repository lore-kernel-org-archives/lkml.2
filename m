Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756935Ab2IDMJu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 08:09:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5738 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756840Ab2IDMJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 08:09:48 -0400
Message-ID: <5045EF86.4080600@redhat.com>
Date: Tue, 04 Sep 2012 15:09:42 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Mathias Krause <minipli@googlemail.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] KVM: x86 emulator: use aligned variants of SSE register
 ops
References: <1346283020-22385-1-git-send-email-minipli@googlemail.com> <1346283020-22385-3-git-send-email-minipli@googlemail.com>
In-Reply-To: <1346283020-22385-3-git-send-email-minipli@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2012 02:30 AM, Mathias Krause wrote:
> As the the compiler ensures that the memory operand is always aligned
> to a 16 byte memory location, 

I'm not sure it does.  Is V4SI aligned?  Do we use alignof() to
propagate the alignment to the vcpu allocation code?

> use the aligned variant of MOVDQ for
> read_sse_reg() and write_sse_reg().
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 1451cff..5a0fee1 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -909,23 +909,23 @@ static void read_sse_reg(struct x86_emulate_ctxt *ctxt, sse128_t *data, int reg)
>  {
>  	ctxt->ops->get_fpu(ctxt);
>  	switch (reg) {
> -	case 0: asm("movdqu %%xmm0, %0" : "=m"(*data)); break;
> -	case 1: asm("movdqu %%xmm1, %0" : "=m"(*data)); break;
> -	case 2: asm("movdqu %%xmm2, %0" : "=m"(*data)); break;
> -	case 3: asm("movdqu %%xmm3, %0" : "=m"(*data)); break;
> -	case 4: asm("movdqu %%xmm4, %0" : "=m"(*data)); break;
> -	case 5: asm("movdqu %%xmm5, %0" : "=m"(*data)); break;
> -	case 6: asm("movdqu %%xmm6, %0" : "=m"(*data)); break;
> -	case 7: asm("movdqu %%xmm7, %0" : "=m"(*data)); break;
> +	case 0: asm("movdqa %%xmm0, %0" : "=m"(*data)); break;
> +	case 1: asm("movdqa %%xmm1, %0" : "=m"(*data)); break;
> +	case 2: asm("movdqa %%xmm2, %0" : "=m"(*data)); break;
> +	case 3: asm("movdqa %%xmm3, %0" : "=m"(*data)); break;
> +	case 4: asm("movdqa %%xmm4, %0" : "=m"(*data)); break;
> +	case 5: asm("movdqa %%xmm5, %0" : "=m"(*data)); break;
> +	case 6: asm("movdqa %%xmm6, %0" : "=m"(*data)); break;
> +	case 7: asm("movdqa %%xmm7, %0" : "=m"(*data)); break;
>  #ifdef CONFIG_X86_64
> -	case 8: asm("movdqu %%xmm8, %0" : "=m"(*data)); break;
> -	case 9: asm("movdqu %%xmm9, %0" : "=m"(*data)); break;
> -	case 10: asm("movdqu %%xmm10, %0" : "=m"(*data)); break;
> -	case 11: asm("movdqu %%xmm11, %0" : "=m"(*data)); break;
> -	case 12: asm("movdqu %%xmm12, %0" : "=m"(*data)); break;
> -	case 13: asm("movdqu %%xmm13, %0" : "=m"(*data)); break;
> -	case 14: asm("movdqu %%xmm14, %0" : "=m"(*data)); break;
> -	case 15: asm("movdqu %%xmm15, %0" : "=m"(*data)); break;
> +	case 8: asm("movdqa %%xmm8, %0" : "=m"(*data)); break;
> +	case 9: asm("movdqa %%xmm9, %0" : "=m"(*data)); break;
> +	case 10: asm("movdqa %%xmm10, %0" : "=m"(*data)); break;
> +	case 11: asm("movdqa %%xmm11, %0" : "=m"(*data)); break;
> +	case 12: asm("movdqa %%xmm12, %0" : "=m"(*data)); break;
> +	case 13: asm("movdqa %%xmm13, %0" : "=m"(*data)); break;
> +	case 14: asm("movdqa %%xmm14, %0" : "=m"(*data)); break;
> +	case 15: asm("movdqa %%xmm15, %0" : "=m"(*data)); break;
>  #endif
>  	default: BUG();


The vmexit costs dominates any win here by several orders of magnitude.


-- 
error compiling committee.c: too many arguments to function
