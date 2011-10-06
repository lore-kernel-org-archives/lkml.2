Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759375Ab1JFWu1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 18:50:27 -0400
Received: from mail.skyhub.de ([78.46.96.112]:44221 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752290Ab1JFWu0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 18:50:26 -0400
Date: Fri, 7 Oct 2011 00:50:20 +0200
From: Borislav Petkov <bp@alien8.de>
To: Alex Ben <aleben358@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <Mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Removed superfluous parentheses in macro defs
Message-ID: <20111006225020.GB5810@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Alex Ben <aleben358@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <Mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org, linux-kernel@vger.kernel.org
References: <1317939724-27924-1-git-send-email-aleben358@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1317939724-27924-1-git-send-email-aleben358@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 07, 2011 at 09:22:04AM +1100, Alex Ben wrote:
> 1) make it consistent with other constant macro deinitions, which
> don't have parentheses, as they are really superfluous.
> 
> 2) the extra parentheses on the 5th line of #define GDT_ENTRY is
> superfluous, as there is no bit shifting on that line.
> ---
>  arch/x86/include/asm/segment.h |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/segment.h b/arch/x86/include/asm/segment.h
> index 5e64171..92621c1 100644
> --- a/arch/x86/include/asm/segment.h
> +++ b/arch/x86/include/asm/segment.h
> @@ -10,7 +10,7 @@
> 	 (((flags) & _AC(0x0000f0ff,ULL)) << 40) |	\
> 	 (((limit) & _AC(0x000f0000,ULL)) << (48-16)) |	\
> 	 (((base)  & _AC(0x00ffffff,ULL)) << 16) |	\
> -	 (((limit) & _AC(0x0000ffff,ULL))))
> +	 ((limit)  & _AC(0x0000ffff,ULL)))
> 
>  /* Simple and small GDT entries for booting only */
> 
> @@ -75,7 +75,7 @@
> 
>  #define GDT_ENTRY_DEFAULT_USER_DS	15
> 
> -#define GDT_ENTRY_KERNEL_BASE		(12)
> +#define GDT_ENTRY_KERNEL_BASE		12

Please do a git annotate on the file you're patching and look at the
commit id which is listed for the GDT_ENTRY_KERNEL_BASE line to find out
why is the 12 parenthesized. Hint: 3234282f33b29

:-)

-- 
Regards/Gruss,
    Boris.
