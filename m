Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870Ab0DYSRh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 14:17:37 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:65081 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675Ab0DYSRd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 14:17:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=JAyYLuEzWv5wQgqsjdWxJkNblCFjltVR2jVVEAQhozTwGYsu1zZb8BD9etHzZ7Hu9j
         Tc1d4xmkpj2HchggvcHwYv3U77zIqk8N6YI9CyGgviuWfsGYro+MzwyfPIJTCmkOixPa
         6kpxMSC9c3Ljx3dRI2SlJLPRcTvXcn0Z4V7fo=
MIME-Version: 1.0
In-Reply-To: <20100425224726P.fujita.tomonori@lab.ntt.co.jp>
References: <1270511567-18567-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	 <1270511567-18567-7-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	 <p2q10f740e81004230129rd5b07889m5ec7f453efd46403@mail.gmail.com>
	 <20100425224726P.fujita.tomonori@lab.ntt.co.jp>
Date: Sun, 25 Apr 2010 20:17:31 +0200
X-Google-Sender-Auth: 7e12c15a87a6d6ce
Message-ID: <l2w10f740e81004251117g948160chad8e4d2bdd1f2779@mail.gmail.com>
Subject: Re: [PATCH -mm 06/12] m68k: use asm-generic/scatterlist.h
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       zippel@linux-m68k.org, linux-m68k@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 25, 2010 at 15:46, FUJITA Tomonori
<fujita.tomonori@lab.ntt.co.jp> wrote:
> On Fri, 23 Apr 2010 10:29:04 +0200
> Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>
>> > +#include <asm-generic/scatterlist.h>
>>
>> This include should be ...
>>
>> > /* This is bogus and should go away. */
>> > #define ISA_DMA_THRESHOLD (0x00ffffff)
>
> asm-generic/scatterlist.h can't define ISA_DMA_THRESHOLD because of
> the way POWERPC uses ISA_DMA_THRESHOLD.
>
>
>> ... below this definition, else you get duplicate definition errors
>> (and the wrong definition).
>>
>> > -#define sg_dma_address(sg) ((sg)->dma_address)
>> > -#define sg_dma_len(sg) ((sg)->length)
>
> This patch needs to be applied against -mm; including some changes to
> asm-generic/scatterlist.h.

Ah, sorry, I thought it was against mainline.

> I've attached asm-generic/scatterlist.h in -mm.
>
> =
> #ifndef __ASM_GENERIC_SCATTERLIST_H
> #define __ASM_GENERIC_SCATTERLIST_H
>
> #include <linux/types.h>
>
> struct scatterlist {
> #ifdef CONFIG_DEBUG_SG
>        unsigned long   sg_magic;
> #endif
>        unsigned long   page_link;
>        unsigned int    offset;
>        unsigned int    length;
>        dma_addr_t      dma_address;
> #ifdef CONFIG_NEED_SG_DMA_LENGTH
>        unsigned int    dma_length;
> #endif
> };
>
> /*
>  * These macros should be used after a dma_map_sg call has been done
>  * to get bus addresses of each of the SG entries and their lengths.
>  * You should only work with the number of sg entries pci_map_sg
>  * returns, or alternatively stop on the first sg_dma_len(sg) which
>  * is 0.
>  */
> #define sg_dma_address(sg)      ((sg)->dma_address)
>
> #ifdef CONFIG_NEED_SG_DMA_LENGTH
> #define sg_dma_len(sg)          ((sg)->dma_length)
> #else
> #define sg_dma_len(sg)          ((sg)->length)
> #endif
>
> #endif /* __ASM_GENERIC_SCATTERLIST_H */

OK, I won't touch it.

Please consider it acked-by, so it can go in through Andrew, together with
the other patches.

Sorry for the confusion.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
