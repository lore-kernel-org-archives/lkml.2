Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616Ab0IBWvn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 18:51:43 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:60779 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753513Ab0IBWvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 18:51:42 -0400
Message-Id: <1283467901.11295.1393104403@webmail.messagingengine.com>
X-Sasl-Enc: bUaVtlNqhxn4PmFEF4K/tk1zc/4MYbArqg/mTU2ExtDz 1283467901
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Jan Beulich" <JBeulich@novell.com>, "Ingo Molnar" <mingo@elte.hu>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
X-Mailer: MessagingEngine.com Webmail Interface
References: <4C7FBAA80200007800013F67@vpn.id2.novell.com>
Subject: Re: Resend: [PATCH] x86-64: adjust frame type at paranoid_exit:
In-Reply-To: <4C7FBAA80200007800013F67@vpn.id2.novell.com>
Date: Fri, 03 Sep 2010 00:51:41 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 02 Sep 2010 13:54 +0100, "Jan Beulich" <JBeulich@novell.com> wrote:
> As this isn't an exception or interrupt entry point, it doesn't have
> any of the hardware provide frame layouts active.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> 
> ---
>  arch/x86/kernel/entry_64.S |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-2.6.36-rc3/arch/x86/kernel/entry_64.S
> +++ 2.6.36-rc3-x86_64-paranoid_exit-unwind/arch/x86/kernel/entry_64.S
> @@ -1368,7 +1368,7 @@ paranoidzeroentry machine_check *machine
>  
>  	/* ebx:	no swapgs flag */
>  ENTRY(paranoid_exit)
> -       INTR_FRAME
> +       DEFAULT_FRAME
>  	DISABLE_INTERRUPTS(CLBR_NONE)
>  	TRACE_IRQS_OFF
>  	testl %ebx,%ebx				/* swapgs needed? */
> 

Yes...

Acked-by: Alexander van Heukelum <heukelum@fastmail.fm>
