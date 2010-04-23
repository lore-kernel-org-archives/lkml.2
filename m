Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553Ab0DWI3N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 04:29:13 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52107 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab0DWI3J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 04:29:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ELgFh0WuQfJhK6ix+yaFlIkg9jQggm6xDDOxK/6HKduNAb7N5APm0WlBv2lxhRQlag
         TkXRNVGog4QYvGIw0o8w1Y0DRdAJAPgXXnPXtp/xDkb13I2EJ5tjxz9yhG2TNJeGAjUf
         z6ZSpuiYd517krEp9PJgSQIfyJYL/bKPb26L8=
MIME-Version: 1.0
In-Reply-To: <1270511567-18567-7-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1270511567-18567-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	 <1270511567-18567-7-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Date: Fri, 23 Apr 2010 10:29:04 +0200
X-Google-Sender-Auth: 123159403f7fae93
Message-ID: <p2q10f740e81004230129rd5b07889m5ec7f453efd46403@mail.gmail.com>
Subject: Re: [PATCH -mm 06/12] m68k: use asm-generic/scatterlist.h
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Roman Zippel <zippel@linux-m68k.org>,
       "Linux/m68k" <linux-m68k@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 6, 2010 at 01:52, FUJITA Tomonori
<fujita.tomonori@lab.ntt.co.jp> wrote:
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Roman Zippel <zippel@linux-m68k.org>
> ---
>  arch/m68k/include/asm/scatterlist.h |   16 +---------------
>  1 files changed, 1 insertions(+), 15 deletions(-)
>
> diff --git a/arch/m68k/include/asm/scatterlist.h b/arch/m68k/include/asm/scatterlist.h
> index e27ad90..175da06 100644
> --- a/arch/m68k/include/asm/scatterlist.h
> +++ b/arch/m68k/include/asm/scatterlist.h
> @@ -1,23 +1,9 @@
>  #ifndef _M68K_SCATTERLIST_H
>  #define _M68K_SCATTERLIST_H
>
> -#include <linux/types.h>
> -
> -struct scatterlist {
> -#ifdef CONFIG_DEBUG_SG
> -       unsigned long sg_magic;
> -#endif
> -       unsigned long page_link;
> -       unsigned int offset;
> -       unsigned int length;
> -
> -       dma_addr_t dma_address; /* A place to hang host-specific addresses at. */
> -};
> +#include <asm-generic/scatterlist.h>

This include should be ...

>  /* This is bogus and should go away. */
>  #define ISA_DMA_THRESHOLD (0x00ffffff)

... below this definition, else you get duplicate definition errors
(and the wrong definition).

> -#define sg_dma_address(sg)     ((sg)->dma_address)
> -#define sg_dma_len(sg)         ((sg)->length)
> -
>  #endif /* !(_M68K_SCATTERLIST_H) */
> --
> 1.7.0

Will apply (incl. the fix).

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
