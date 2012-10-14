Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652Ab2JNKt5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 06:49:57 -0400
Received: from mail.skyhub.de ([78.46.96.112]:48940 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752338Ab2JNKt4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 06:49:56 -0400
Date: Sun, 14 Oct 2012 12:49:51 +0200
From: Borislav Petkov <bp@alien8.de>
To: ling.ma@intel.com
Cc: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 1/2] [x86] Modify comments and clean up code.
Message-ID: <20121014104951.GA2165@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>, ling.ma@intel.com,
	mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
	linux-kernel@vger.kernel.org
References: <1349958524-1837-1-git-send-email-ling.ma@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1349958524-1837-1-git-send-email-ling.ma@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2012 at 08:28:44PM +0800, ling.ma@intel.com wrote:
> From: Ma Ling <ling.ma@intel.com>
> 
> Modern CPU use fast-string instruction to accelerate copy performance,
> by combining data into 128bit, so we modify comments and code style.
> 
> Signed-off-by: Ma Ling <ling.ma@intel.com>
> 
> ---
>  arch/x86/lib/copy_page_64.S |  119 +++++++++++++++++++++----------------------
>  1 files changed, 59 insertions(+), 60 deletions(-)
> 
> diff --git a/arch/x86/lib/copy_page_64.S b/arch/x86/lib/copy_page_64.S
> index 6b34d04..3da5527 100644
> --- a/arch/x86/lib/copy_page_64.S
> +++ b/arch/x86/lib/copy_page_64.S
> @@ -5,91 +5,90 @@
>  #include <asm/alternative-asm.h>
>  
>  	ALIGN
> -copy_page_c:
> +copy_page_rep:
>  	CFI_STARTPROC
> -	movl $4096/8,%ecx
> -	rep movsq
> +	movl	$4096/8, %ecx
> +	rep	movsq
>  	ret
>  	CFI_ENDPROC
> -ENDPROC(copy_page_c)
> +ENDPROC(copy_page_rep)
>  
> -/* Don't use streaming store because it's better when the target
> -   ends up in cache. */
> -	    
> -/* Could vary the prefetch distance based on SMP/UP */
> +/*
> +   Don't use streaming copy unless cpu indicate X86_FEATURE_REP_GOOD
> +   Could vary the prefetch distance based on SMP/UP
> +*/

Kernel comment style formatting is:

 /*
  * <something not trivial to see worth adding comment for>
  * <optional second line of that statement>
  */

>  
>  ENTRY(copy_page)
>  	CFI_STARTPROC
> -	subq	$2*8,%rsp
> +	subq	$2*8,	%rsp
>  	CFI_ADJUST_CFA_OFFSET 2*8
> -	movq	%rbx,(%rsp)
> +	movq	%rbx,	(%rsp)
>  	CFI_REL_OFFSET rbx, 0
> -	movq	%r12,1*8(%rsp)
> +	movq	%r12,	1*8(%rsp)
>  	CFI_REL_OFFSET r12, 1*8
>  
> -	movl	$(4096/64)-5,%ecx
> +	movl	$(4096/64)-5,	%ecx
>  	.p2align 4
>  .Loop64:
> -  	dec     %rcx
> +  	dec	%rcx

Applying: Modify comments and clean up code.
/home/boris/kernel/linux-2.6/.git/rebase-apply/patch:51: space before tab in indent.
        dec     %rcx
warning: 1 line adds whitespace errors.

>  
> -	movq        (%rsi), %rax
> -	movq      8 (%rsi), %rbx
> -	movq     16 (%rsi), %rdx
> -	movq     24 (%rsi), %r8
> -	movq     32 (%rsi), %r9
> -	movq     40 (%rsi), %r10
> -	movq     48 (%rsi), %r11
> -	movq     56 (%rsi), %r12
> +	movq	0x8*0(%rsi), %rax
> +	movq	0x8*1(%rsi), %rbx
> +	movq	0x8*2(%rsi), %rdx
> +	movq	0x8*3(%rsi), %r8
> +	movq	0x8*4(%rsi), %r9
> +	movq	0x8*5(%rsi), %r10
> +	movq	0x8*6(%rsi), %r11
> +	movq	0x8*7(%rsi), %r12

[ … ]

-- 
Regards/Gruss,
    Boris.
