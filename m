Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273Ab2LORGc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 12:06:32 -0500
Received: from mail.skyhub.de ([78.46.96.112]:55104 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750995Ab2LORGa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 12:06:30 -0500
Date: Sat, 15 Dec 2012 18:06:25 +0100
From: Borislav Petkov <bp@alien8.de>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH v6 03/27] x86, boot: move verify_cpu.S and no_longmode
 after 0x200
Message-ID: <20121215170625.GA9875@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Yinghai Lu <yinghai@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>
References: <1355436141-8668-1-git-send-email-yinghai@kernel.org>
 <1355436141-8668-4-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1355436141-8668-4-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2012 at 02:01:57PM -0800, Yinghai Lu wrote:
> We are short of space before 0x200 that is entry for startup_64.

And you're moving this down because of the couple of bytes the next
patch is adding? If so, then explain that here.

> According to hpa, we can not change startup_64 to other offset and
> that become ABI now.
> 
> We could move function verify_cpu and no_longmode down, because one is
> used via call and another will not return.
> So could avoid extra code of jmp back and forth if we would move other
> lines.

What does that sentence even mean? Why is it in the commit message?

> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: Matt Fleming <matt.fleming@intel.com>
> ---
>  arch/x86/boot/compressed/head_64.S |   17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
> index 2c4b171..fb984c0 100644
> --- a/arch/x86/boot/compressed/head_64.S
> +++ b/arch/x86/boot/compressed/head_64.S
> @@ -176,14 +176,6 @@ ENTRY(startup_32)
>  	lret
>  ENDPROC(startup_32)
>  
> -no_longmode:
> -	/* This isn't an x86-64 CPU so hang */
> -1:
> -	hlt
> -	jmp     1b
> -
> -#include "../../kernel/verify_cpu.S"
> -
>  	/*
>  	 * Be careful here startup_64 needs to be at a predictable
>  	 * address so I can export it in an ELF header.  Bootloaders
> @@ -349,6 +341,15 @@ relocated:
>   */
>  	jmp	*%rbp
>  
> +	.code32
> +no_longmode:
> +	/* This isn't an x86-64 CPU so hang */
> +1:
> +	hlt
> +	jmp     1b
> +
> +#include "../../kernel/verify_cpu.S"
> +
>  	.data
>  gdt:
>  	.word	gdt_end - gdt
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
