Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206Ab2KZHWu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 02:22:50 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:41712 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622Ab2KZHWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 02:22:48 -0500
Message-ID: <50B318C5.8090508@redhat.com>
Date: Mon, 26 Nov 2012 08:22:45 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@linux.intel.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Gleb Natapov <gleb@redhat.com>,
        Linux KVM mailing list <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86, kvm: Remove incorrect redundant assembly constraint
References: <B3584E72CFEBED439A3ECA9BCE67A4EF1B17AF90@FMSMSX107.amr.corp.intel.com> <1353537681-18759-1-git-send-email-hpa@linux.intel.com>
In-Reply-To: <1353537681-18759-1-git-send-email-hpa@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 21/11/2012 23:41, H. Peter Anvin ha scritto:
> From: "H. Peter Anvin" <hpa@linux.intel.com>
> 
> In __emulate_1op_rax_rdx, we use "+a" and "+d" which are input/output
> constraints, and *then* use "a" and "d" as input constraints.  This is
> incorrect, but happens to work on some versions of gcc.
> 
> However, it breaks gcc with -O0 and icc, and may break on future
> versions of gcc.
> 
> Reported-and-tested-by: Melanie Blower <melanie.blower@intel.com>
> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> Link: http://lkml.kernel.org/r/B3584E72CFEBED439A3ECA9BCE67A4EF1B17AF90@FMSMSX107.amr.corp.intel.com
> ---
>  arch/x86/kvm/emulate.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 39171cb..bba39bf 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -426,8 +426,7 @@ static void invalidate_registers(struct x86_emulate_ctxt *ctxt)
>  			_ASM_EXTABLE(1b, 3b)				\
>  			: "=m" ((ctxt)->eflags), "=&r" (_tmp),		\
>  			  "+a" (*rax), "+d" (*rdx), "+qm"(_ex)		\
> -			: "i" (EFLAGS_MASK), "m" ((ctxt)->src.val),	\
> -			  "a" (*rax), "d" (*rdx));			\
> +			: "i" (EFLAGS_MASK), "m" ((ctxt)->src.val));	\
>  	} while (0)
>  
>  /* instruction has only one source operand, destination is implicit (e.g. mul, div, imul, idiv) */
> 

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
