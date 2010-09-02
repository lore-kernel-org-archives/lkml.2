Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756337Ab0IBWth (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 18:49:37 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:36396 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755482Ab0IBWtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 18:49:36 -0400
Message-Id: <1283467775.10264.1393103393@webmail.messagingengine.com>
X-Sasl-Enc: Zqv8NFSb1Pl+zDMsvC5NUH+MzJy9JTERATEt0RpLDbN8 1283467775
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Jan Beulich" <JBeulich@novell.com>, "Ingo Molnar" <mingo@elte.hu>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
X-Mailer: MessagingEngine.com Webmail Interface
References: <4C7FBA3D0200007800013F61@vpn.id2.novell.com>
Subject: Re: Resend: [PATCH] x86-64: fix unwind annotations in syscall  stubs
In-Reply-To: <4C7FBA3D0200007800013F61@vpn.id2.novell.com>
Date: Fri, 03 Sep 2010 00:49:35 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 02 Sep 2010 13:52 +0100, "Jan Beulich" <JBeulich@novell.com> wrote:
> With the return address removed from the stack, these should really
> refer to their caller's register state.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> 
> ---
>  arch/x86/kernel/entry_64.S |    7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> --- linux-2.6.36-rc3/arch/x86/kernel/entry_64.S
> +++ 2.6.36-rc3-x86_64-stub-unwind-annotations/arch/x86/kernel/entry_64.S
> @@ -714,9 +714,8 @@ END(ptregscall_common)
>  
>  ENTRY(stub_execve)
>  	CFI_STARTPROC
> -       popq %r11
> -       CFI_ADJUST_CFA_OFFSET -8
> -       CFI_REGISTER rip, r11
> +       addq $8, %rsp
> +       PARTIAL_FRAME 0
>  	SAVE_REST
>  	FIXUP_TOP_OF_STACK %r11
>  	movq %rsp, %rcx
> @@ -735,7 +734,7 @@ END(stub_execve)
>  ENTRY(stub_rt_sigreturn)
>  	CFI_STARTPROC
>  	addq $8, %rsp
> -       CFI_ADJUST_CFA_OFFSET   -8
> +       PARTIAL_FRAME 0
>  	SAVE_REST
>  	movq %rsp,%rdi
>  	FIXUP_TOP_OF_STACK %r11
> 

Thanks for creating these...

Acked-by: Alexander van Heukelum <heukelum@fastmail.fm>
