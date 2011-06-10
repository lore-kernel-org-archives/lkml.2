Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757934Ab1FJSWE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 14:22:04 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:58142 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756178Ab1FJSWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 14:22:01 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=u6vS5eWj76tTEDxtKypWdc34PiV710yA34olMLiQVimWmUrMCZyN1+yQ1vXkNnMC6ZHtTXLPkn0dCOZDXQ/SjkZun41NxPlnSYYTV53uNYHt87oUlszwv0JuIKEJQE/F;
Date: Fri, 10 Jun 2011 11:21:58 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH] asm/types.h: All architectures use int-ll64.h in
 kernelspace
Message-Id: <20110610112158.00bcf219.rdunlap@xenotime.net>
In-Reply-To: <1307646404-13911-1-git-send-email-geert@linux-m68k.org>
References: <1307646404-13911-1-git-send-email-geert@linux-m68k.org>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  9 Jun 2011 21:06:44 +0200 Geert Uytterhoeven wrote:

> Now all 64-bit architectures have been converted to int-ll64.h, we can
> deprecate int-l64.h in kernelspace:
>   - Add a check to prevent new architectures from using int-l64.h in
>     kernelspace,
>   - Update documentation, as the casts to (unsigned) long long are no longer
>     needed.

For the documentation parts:
Acked-by: Randy Dunlap <rdunlap@xenotime.net>

but I'm not sure who should merge it...

> For backwards compatibility, alpha, ia64, mips, and powerpc still use
> int-l64.h in userspace.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>  Documentation/printk-formats.txt |    4 ++--
>  include/asm-generic/int-l64.h    |   38 +-------------------------------------
>  include/asm-generic/types.h      |    3 +--
>  3 files changed, 4 insertions(+), 41 deletions(-)
> 
> diff --git a/Documentation/printk-formats.txt b/Documentation/printk-formats.txt
> index 1b5a5dd..b9b8926 100644
> --- a/Documentation/printk-formats.txt
> +++ b/Documentation/printk-formats.txt
> @@ -13,11 +13,11 @@ Raw pointer value SHOULD be printed with %p.
>  
>  u64 SHOULD be printed with %llu/%llx, (unsigned long long):
>  
> -	printk("%llu", (unsigned long long)u64_var);
> +	printk("%llu", u64_var);
>  
>  s64 SHOULD be printed with %lld/%llx, (long long):
>  
> -	printk("%lld", (long long)s64_var);
> +	printk("%lld", s64_var);
>  
>  If <type> is dependent on a config option for its size (e.g., sector_t,
>  blkcnt_t, phys_addr_t, resource_size_t) or is architecture-dependent
> diff --git a/include/asm-generic/int-l64.h b/include/asm-generic/int-l64.h
> index 1ca3efc..f07a500 100644
> --- a/include/asm-generic/int-l64.h
> +++ b/include/asm-generic/int-l64.h
> @@ -31,43 +31,7 @@ typedef unsigned long __u64;
>  #endif /* __ASSEMBLY__ */
>  
>  #ifdef __KERNEL__
> -
> -#ifndef __ASSEMBLY__
> -
> -typedef signed char s8;
> -typedef unsigned char u8;
> -
> -typedef signed short s16;
> -typedef unsigned short u16;
> -
> -typedef signed int s32;
> -typedef unsigned int u32;
> -
> -typedef signed long s64;
> -typedef unsigned long u64;
> -
> -#define S8_C(x)  x
> -#define U8_C(x)  x ## U
> -#define S16_C(x) x
> -#define U16_C(x) x ## U
> -#define S32_C(x) x
> -#define U32_C(x) x ## U
> -#define S64_C(x) x ## L
> -#define U64_C(x) x ## UL
> -
> -#else /* __ASSEMBLY__ */
> -
> -#define S8_C(x)  x
> -#define U8_C(x)  x
> -#define S16_C(x) x
> -#define U16_C(x) x
> -#define S32_C(x) x
> -#define U32_C(x) x
> -#define S64_C(x) x
> -#define U64_C(x) x
> -
> -#endif /* __ASSEMBLY__ */
> -
> +#error Please use <asm-generic/int-ll64.h> in kernelspace
>  #endif /* __KERNEL__ */
>  
>  #endif /* _ASM_GENERIC_INT_L64_H */
> diff --git a/include/asm-generic/types.h b/include/asm-generic/types.h
> index 7a0f69e..a9672ef 100644
> --- a/include/asm-generic/types.h
> +++ b/include/asm-generic/types.h
> @@ -1,8 +1,7 @@
>  #ifndef _ASM_GENERIC_TYPES_H
>  #define _ASM_GENERIC_TYPES_H
>  /*
> - * int-ll64 is used practically everywhere now,
> - * so use it as a reasonable default.
> + * int-ll64 is used everywhere now.
>   */
>  #include <asm-generic/int-ll64.h>
>  
> -- 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
