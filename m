Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199Ab0LHWVO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 17:21:14 -0500
Received: from smtp.outflux.net ([198.145.64.163]:38338 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754303Ab0LHWVL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 17:21:11 -0500
Date: Wed, 8 Dec 2010 14:19:51 -0800
From: Kees Cook <kees.cook@canonical.com>
To: mat <castet.matthieu@free.fr>
Cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-next@vger.kernel.org,
        Arjan van de Ven <arjan@infradead.org>,
        James Morris <jmorris@namei.org>,
        Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Dave Jones <davej@redhat.com>,
        Siarhei Liakh <sliakh.lkml@gmail.com>
Subject: Re: [PATCH 3/3 V13] RO/NX protection for loadable kernel
Message-ID: <20101208221951.GO5750@outflux.net>
References: <4CE2F914.9070106@free.fr>
 <24422.1290656467@localhost>
 <20101126182355.62615dff@mat-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101126182355.62615dff@mat-laptop>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 26, 2010 at 06:23:55PM +0100, mat wrote:
> could you try the attached patch ?
> 
> on module load, we sort the __jump_table section. So we should make it
> writable.
> 
> 
> Matthieu

> diff --git a/arch/x86/include/asm/jump_label.h b/arch/x86/include/asm/jump_label.h
> index f52d42e..574dbc2 100644
> --- a/arch/x86/include/asm/jump_label.h
> +++ b/arch/x86/include/asm/jump_label.h
> @@ -14,7 +14,7 @@
>  	do {							\
>  		asm goto("1:"					\
>  			JUMP_LABEL_INITIAL_NOP			\
> -			".pushsection __jump_table,  \"a\" \n\t"\
> +			".pushsection __jump_table,  \"aw\" \n\t"\
>  			_ASM_PTR "1b, %l[" #label "], %c0 \n\t" \
>  			".popsection \n\t"			\
>  			: :  "i" (key) :  : label);		\

Acked-by: Kees Cook <kees.cook@canonical.com>

Can this please get committed to tip?

Thanks,

-Kees

-- 
Kees Cook
Ubuntu Security Team
