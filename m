Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932293Ab1AKPtV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 10:49:21 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:63928 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932282Ab1AKPtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 10:49:20 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Guan Xuetao" <guanxuetao@mprc.pku.edu.cn>
Subject: Re: [PATCH] asm-generic headers: add arch-specific __strnlen_user calling in uaccess.h
Date: Tue, 11 Jan 2011 16:49:14 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37; KDE/4.5.1; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
References: <008801cbb166$96cd0430$c4670c90$@mprc.pku.edu.cn>
In-Reply-To: <008801cbb166$96cd0430$c4670c90$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101111649.14711.arnd@arndb.de>
X-Provags-ID: V02:K0:a0TwV36bxA3q3UEeWGgOeNfYbkhQa4ld9WEZzRd6iKQ
 CL58E96UxWxateAp7pbfiLSafYaW+mmZ2Y1GuWk7UCP1UZp6Ry
 E64SO7xInxzRKejt9RAVH1BzmaYDBv4359o14KkGln6+hyAA3Z
 eR3+aCouMmyuHcBCajT8k79IL+q/xXCgVA5dh+8UXRnOis8Nui
 ggVIWCSK2grdW9KrzYCYQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 January 2011, Guan Xuetao wrote:
> diff --git a/include/asm-generic/uaccess.h b/include/asm-generic/uaccess.h
> index b218b85..ac68c99 100644
> --- a/include/asm-generic/uaccess.h
> +++ b/include/asm-generic/uaccess.h
> @@ -288,14 +288,16 @@ strncpy_from_user(char *dst, const char __user *src, long count)
>   *
>   * Return 0 on exception, a value greater than N if too long
>   */
> -#ifndef strnlen_user
> +#ifndef __strnlen_user
> +#define __strnlen_user strnlen
> +#endif
> +
>  static inline long strnlen_user(const char __user *src, long n)
>  {
>         if (!access_ok(VERIFY_READ, src, 1))
>                 return 0;
> -       return strlen((void * __force)src) + 1;
> +       return __strnlen_user(src, n);
>  }
> -#endif
>  
>  static inline long strlen_user(const char __user *src)

Yes, looks good. I believe no architecture currently uses the generic
uaccess.h file directly, so it's not surprising that you find problems
like this in it.

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
