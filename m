Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267Ab2BTI0E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 03:26:04 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60188 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368Ab2BTI0B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 03:26:01 -0500
Date: Mon, 20 Feb 2012 09:25:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org
Subject: Re: [PATCH 3/5] x86: s/#if CONFIG/#ifdef CONFIG/
Message-ID: <20120220082529.GA23502@elte.hu>
References: <1329664319-3128-1-git-send-email-geert@linux-m68k.org>
 <1329664319-3128-3-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329664319-3128-3-git-send-email-geert@linux-m68k.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: "H. Peter Anvin" <hpa@zytor.com>"
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: x86@kernel.org
> ---
>  arch/x86/boot/compressed/head_32.S |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/boot/compressed/head_32.S b/arch/x86/boot/compressed/head_32.S
> index a055993..a37b117 100644
> --- a/arch/x86/boot/compressed/head_32.S
> +++ b/arch/x86/boot/compressed/head_32.S
> @@ -173,7 +173,7 @@ relocated:
>  	call	decompress_kernel
>  	addl	$20, %esp
>  
> -#if CONFIG_RELOCATABLE
> +#ifdef CONFIG_RELOCATABLE
>  /*
>   * Find the address of the relocations.
>   */

I'd really prefer to read an actual "this is safe, because this 
value is defined in the Kconfig as ..." type of commit log 
instead of nothing, which would ensure us that you didnt just do 
a (fundamentally unsafe) sed job over the kernel tree but 
actually have *read* the Kconfig entries in question to ensure 
the correctness of your patches...

Thanks,

	Ingo
