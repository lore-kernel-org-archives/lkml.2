Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576Ab1AIU7A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 15:59:00 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:49633 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311Ab1AIU67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 15:58:59 -0500
Subject: Re: [PATCH/RFC] m68k: Uninline strchr()
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linux/m68k <linux-m68k@vger.kernel.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1101091942230.26296@ayla.of.borg>
References: <alpine.DEB.2.00.1101091942230.26296@ayla.of.borg>
Content-Type: text/plain
Date: Sun, 09 Jan 2011 12:52:56 -0800
Message-Id: <1294606376.2895.176.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-01-09 at 19:42 +0100, Geert Uytterhoeven wrote:
> Some versions of gcc replace calls to strstr() with single-character
> "needle" string parameters by calls to strchr() behind our back.
> 
> If strchr() is defined as an inline function, this causes linking errors
> like
> 
> 	ERROR: "strchr" [drivers/target/target_core_mod.ko] undefined!
> 
> As m68k is the only architecture that has an inline strchr() and this
> inline version is not an optimized asm version, uninline strchr() and use
> the standard out-of-line C version in lib/string.c instead.
> 
> This also decreases the defconfig/allmodconfig kernel image sizes by a few
> hundred bytes.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Hi Geert,

Thanks for taking the time to fix this up in m68k code.  As m68k is one
of the last architectures that target code has yet to run on, I am
excited to see this finally happen.  ;)

Best Regards,

Reviewed-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

> 
> diff --git a/arch/m68k/include/asm/string.h b/arch/m68k/include/asm/string.h
> index 2936dda..65b1312 100644
> --- a/arch/m68k/include/asm/string.h
> +++ b/arch/m68k/include/asm/string.h
> @@ -81,18 +81,6 @@ static inline char *strncpy(char *dest, const char *src, size_t n)
>  	strcpy(__d + strlen(__d), (s));		\
>  })
>  
> -#define __HAVE_ARCH_STRCHR
> -static inline char *strchr(const char *s, int c)
> -{
> -	char sc, ch = c;
> -
> -	for (; (sc = *s++) != ch; ) {
> -		if (!sc)
> -			return NULL;
> -	}
> -	return (char *)s - 1;
> -}
> -
>  #ifndef CONFIG_COLDFIRE
>  #define __HAVE_ARCH_STRCMP
>  static inline int strcmp(const char *cs, const char *ct)

