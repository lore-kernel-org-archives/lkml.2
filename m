Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993Ab1HXP35 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 11:29:57 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:40754 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917Ab1HXP3z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 11:29:55 -0400
MIME-Version: 1.0
In-Reply-To: <1314199415-7924-1-git-send-email-linkinjeon@gmail.com>
References: <1314199415-7924-1-git-send-email-linkinjeon@gmail.com>
Date: Thu, 25 Aug 2011 00:29:53 +0900
Message-ID: <CAKYAXd-hkg4yKXLd-HfW56NJX8RUZhVyg8YEEzaZmpE1epDk-g@mail.gmail.com>
Subject: Re: [PATCH] include: Fix compile warning in include/linux/bitops.h
From: NamJae Jeon <linkinjeon@gmail.com>
To: arnd@arndb.de
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi. Arnd.

I send a patch by the below your request.

Would you plz confirm it ?

Thanks.

2011/8/25 Namjae Jeon <linkinjeon@gmail.com>:
> The compile warning is caused by __const_hweight8 when using hweight_long with -Wsign-compare option.
> The reason is that the default return value of this macro is signed. So need type casting to remove warning.
>
> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
> ---
>  include/asm-generic/bitops/const_hweight.h |   18 +++++++++---------
>  1 files changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/include/asm-generic/bitops/const_hweight.h b/include/asm-generic/bitops/const_hweight.h
> index fa2a50b..31b7fce 100644
> --- a/include/asm-generic/bitops/const_hweight.h
> +++ b/include/asm-generic/bitops/const_hweight.h
> @@ -4,15 +4,15 @@
>  /*
>  * Compile time versions of __arch_hweightN()
>  */
> -#define __const_hweight8(w)            \
> -      (        (!!((w) & (1ULL << 0))) +       \
> -       (!!((w) & (1ULL << 1))) +       \
> -       (!!((w) & (1ULL << 2))) +       \
> -       (!!((w) & (1ULL << 3))) +       \
> -       (!!((w) & (1ULL << 4))) +       \
> -       (!!((w) & (1ULL << 5))) +       \
> -       (!!((w) & (1ULL << 6))) +       \
> -       (!!((w) & (1ULL << 7))) )
> +#define __const_hweight8(w)    (unsigned long) \
> +       (       (!!((w) & (1ULL << 0))) +       \
> +               (!!((w) & (1ULL << 1))) +       \
> +               (!!((w) & (1ULL << 2))) +       \
> +               (!!((w) & (1ULL << 3))) +       \
> +               (!!((w) & (1ULL << 4))) +       \
> +               (!!((w) & (1ULL << 5))) +       \
> +               (!!((w) & (1ULL << 6))) +       \
> +               (!!((w) & (1ULL << 7))) )
>
>  #define __const_hweight16(w) (__const_hweight8(w)  + __const_hweight8((w)  >> 8 ))
>  #define __const_hweight32(w) (__const_hweight16(w) + __const_hweight16((w) >> 16))
> --
> 1.7.4.4
>
>
Yes, this looks correct to me. Could you send the change as a proper patch
with your Signed-off-by:?

       Arnd
