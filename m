Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab1BIIrf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 03:47:35 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:42967 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752738Ab1BIIrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 03:47:33 -0500
Message-Id: <1297241252.30625.1419727165@webmail.messagingengine.com>
X-Sasl-Enc: lsJfjp9n5UxxRmqiwR4qxIaozImtCcL/pP6u1IUAbyUM 1297241252
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Jan Beulich" <JBeulich@novell.com>, "Ingo Molnar" <mingo@elte.hu>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
X-Mailer: MessagingEngine.com Webmail Interface
In-Reply-To: <4D525CE60200007800030EE5@vpn.id2.novell.com>
References: <4D525CE60200007800030EE5@vpn.id2.novell.com>
Subject: Re: [PATCH] x86: reduce back the alignment of the per-CPU data section
Date: Wed, 09 Feb 2011 09:47:32 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan,

This is indeed a leftover. Thanks.

This was once done to fix i386-UP, because the irq stacks were part of the percpu area. The stacks are now allocated dynamically.

Acked-by: Alexander van Heukelum <heukelum@fastmail.fm>

Greetings,
    Alexander

On Wed, 09 Feb 2011 08:22 +0000, "Jan Beulich" <JBeulich@novell.com> wrote:
> This complements commit 47f19a0814e80e1d4e5c17d61b70fca85ea09162,
> reverting one leftover of fe8e0c25cad28e8858ecfa5863333c70685a6811.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> Cc: Alexander van Heukelum <heukelum@fastmail.fm>
> 
> ---
>  arch/x86/kernel/vmlinux.lds.S |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- 2.6.38-rc4/arch/x86/kernel/vmlinux.lds.S
> +++ 2.6.38-rc4-x86-percpu-align/arch/x86/kernel/vmlinux.lds.S
> @@ -305,7 +305,7 @@ SECTIONS
>  	}
>  
>  #if !defined(CONFIG_X86_64) || !defined(CONFIG_SMP)
> -       PERCPU(THREAD_SIZE)
> +       PERCPU(PAGE_SIZE)
>  #endif
>  
>  	. = ALIGN(PAGE_SIZE);
> 
> 
> 
