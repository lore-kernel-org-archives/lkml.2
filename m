Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667Ab0IBWxL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 18:53:11 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:37007 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751217Ab0IBWxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 18:53:09 -0400
Message-Id: <1283467989.11524.1393104501@webmail.messagingengine.com>
X-Sasl-Enc: 9xUUj4N3Ddyz3WOWmb99KSsoD8Is2xitgv11oBLToZT4 1283467989
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Jan Beulich" <JBeulich@novell.com>, "Ingo Molnar" <mingo@elte.hu>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
X-Mailer: MessagingEngine.com Webmail Interface
References: <4C7FBACF0200007800013F6A@vpn.id2.novell.com>
Subject: Re: Resend: [PATCH] x86-64: use symbolics instead of raw numbers  in
 entry_64.S
In-Reply-To: <4C7FBACF0200007800013F6A@vpn.id2.novell.com>
Date: Fri, 03 Sep 2010 00:53:09 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 02 Sep 2010 13:55 +0100, "Jan Beulich" <JBeulich@novell.com> wrote:
> ... making the code a little less fragile.
> 
> Also use pushq_cfi instead of raw CFI annotations in two more places,
> and add two missing annotations after stack pointer adjustments which
> got modified here anyway.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>

Good cleanup.

Generated binary is identical...

Acked-by: Alexander van Heukelum <heukelum@fastmail.fm>

> ---
>  arch/x86/kernel/entry_64.S |   32 ++++++++++++++++----------------
>  1 file changed, 16 insertions(+), 16 deletions(-)
> 
> --- linux-2.6.36-rc3/arch/x86/kernel/entry_64.S
> +++ 2.6.36-rc3-x86_64-unwind-annotations/arch/x86/kernel/entry_64.S
> @@ -796,8 +796,8 @@ END(interrupt)
>  
>  /* 0(%rsp): ~(interrupt number) */
>  	.macro interrupt func
> -       subq $10*8, %rsp
> -       CFI_ADJUST_CFA_OFFSET 10*8
> +       subq $ORIG_RAX-ARGOFFSET+8, %rsp
> +       CFI_ADJUST_CFA_OFFSET ORIG_RAX-ARGOFFSET+8
>  	call save_args
>  	PARTIAL_FRAME 0
>  	call \func
> @@ -1036,8 +1036,8 @@ ENTRY(\sym)
>  	INTR_FRAME
>  	PARAVIRT_ADJUST_EXCEPTION_FRAME
>  	pushq_cfi $-1		/* ORIG_RAX: no syscall to restart */
> -       subq $15*8,%rsp
> -       CFI_ADJUST_CFA_OFFSET 15*8
> +       subq $ORIG_RAX-R15, %rsp
> +       CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
>  	call error_entry
>  	DEFAULT_FRAME 0
>  	movq %rsp,%rdi		/* pt_regs pointer */
> @@ -1052,9 +1052,9 @@ END(\sym)
>  ENTRY(\sym)
>  	INTR_FRAME
>  	PARAVIRT_ADJUST_EXCEPTION_FRAME
> -       pushq $-1               /* ORIG_RAX: no syscall to restart */
> -       CFI_ADJUST_CFA_OFFSET 8
> -       subq $15*8, %rsp
> +       pushq_cfi $-1           /* ORIG_RAX: no syscall to restart */
> +       subq $ORIG_RAX-R15, %rsp
> +       CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
>  	call save_paranoid
>  	TRACE_IRQS_OFF
>  	movq %rsp,%rdi		/* pt_regs pointer */
> @@ -1070,9 +1070,9 @@ END(\sym)
>  ENTRY(\sym)
>  	INTR_FRAME
>  	PARAVIRT_ADJUST_EXCEPTION_FRAME
> -       pushq $-1               /* ORIG_RAX: no syscall to restart */
> -       CFI_ADJUST_CFA_OFFSET 8
> -       subq $15*8, %rsp
> +       pushq_cfi $-1           /* ORIG_RAX: no syscall to restart */
> +       subq $ORIG_RAX-R15, %rsp
> +       CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
>  	call save_paranoid
>  	TRACE_IRQS_OFF
>  	movq %rsp,%rdi		/* pt_regs pointer */
> @@ -1089,8 +1089,8 @@ END(\sym)
>  ENTRY(\sym)
>  	XCPT_FRAME
>  	PARAVIRT_ADJUST_EXCEPTION_FRAME
> -       subq $15*8,%rsp
> -       CFI_ADJUST_CFA_OFFSET 15*8
> +       subq $ORIG_RAX-R15, %rsp
> +       CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
>  	call error_entry
>  	DEFAULT_FRAME 0
>  	movq %rsp,%rdi			/* pt_regs pointer */
> @@ -1107,8 +1107,8 @@ END(\sym)
>  ENTRY(\sym)
>  	XCPT_FRAME
>  	PARAVIRT_ADJUST_EXCEPTION_FRAME
> -       subq $15*8,%rsp
> -       CFI_ADJUST_CFA_OFFSET 15*8
> +       subq $ORIG_RAX-R15, %rsp
> +       CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
>  	call save_paranoid
>  	DEFAULT_FRAME 0
>  	TRACE_IRQS_OFF
> @@ -1498,8 +1498,8 @@ ENTRY(nmi)
>  	INTR_FRAME
>  	PARAVIRT_ADJUST_EXCEPTION_FRAME
>  	pushq_cfi $-1
> -       subq $15*8, %rsp
> -       CFI_ADJUST_CFA_OFFSET 15*8
> +       subq $ORIG_RAX-R15, %rsp
> +       CFI_ADJUST_CFA_OFFSET ORIG_RAX-R15
>  	call save_paranoid
>  	DEFAULT_FRAME 0
>  	/* paranoidentry do_nmi, 0; without TRACE_IRQS_OFF */
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
> 
