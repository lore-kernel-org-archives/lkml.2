Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456Ab0IBWut (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 18:50:49 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:60956 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753400Ab0IBWus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 18:50:48 -0400
Message-Id: <1283467847.11165.1393104277@webmail.messagingengine.com>
X-Sasl-Enc: GsWyE6C2vMagE97QfQ42HQffGNnTB2inLJtQdFbFF2qK 1283467847
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Jan Beulich" <JBeulich@novell.com>, "Ingo Molnar" <mingo@elte.hu>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
X-Mailer: MessagingEngine.com Webmail Interface
References: <4C7FBA790200007800013F64@vpn.id2.novell.com>
Subject: Re: Resend: [PATCH] x86-64: fix unwind annotations in syscall  stubs
In-Reply-To: <4C7FBA790200007800013F64@vpn.id2.novell.com>
Date: Fri, 03 Sep 2010 00:50:47 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 02 Sep 2010 13:53 +0100, "Jan Beulich" <JBeulich@novell.com> wrote:
> The scope should really extend to the end of the function, not the
> return location.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> 
> ---
>  arch/x86/kernel/entry_64.S |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-2.6.36-rc3/arch/x86/kernel/entry_64.S
> +++ 2.6.36-rc3-x86_64-error_entry-unwind-scope/arch/x86/kernel/entry_64.S
> @@ -1445,7 +1445,6 @@ error_swapgs:
>  error_sti:
>  	TRACE_IRQS_OFF
>  	ret
> -       CFI_ENDPROC
>  
>  /*
>   * There are two places in the kernel that can potentially fault with
> @@ -1470,6 +1469,7 @@ bstep_iret:
>  	/* Fix truncated RIP */
>  	movq %rcx,RIP+8(%rsp)
>  	jmp error_swapgs
> +       CFI_ENDPROC
>  END(error_entry)
>  

Indeed.

Acked-by: Alexander van Heukelum <heukelum@fastmail.fm>
