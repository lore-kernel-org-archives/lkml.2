Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959Ab0F2OHa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 10:07:30 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:62049 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648Ab0F2OH2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 10:07:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RMXk5sUn+I8OOK5NQ1g7p05lioNLk06JOFrGC1/vAcYarFRdiUHNpUn1HZKc7yCg+1
         7ZdDE5DDxZ8j/EmjNs6Cu5GQPrSM5GlufKDPzP+4Wz+BhqKTfxmnETLVUbvpTsHd49KL
         MVBoQ5ve87wzX6wv6sOYZRwGVF+iADKuPWOEo=
MIME-Version: 1.0
In-Reply-To: <20100629154801C.fujita.tomonori@lab.ntt.co.jp>
References: <20100629154801C.fujita.tomonori@lab.ntt.co.jp>
Date: Tue, 29 Jun 2010 10:07:27 -0400
Message-ID: <AANLkTikiJJ5G4Jy9sd644hpAljWFN_xvUJmpDZhxGf2x@mail.gmail.com>
Subject: Re: [PATCH] parisc: set ARCH_KMALLOC_MINALIGN
From: Matt Turner <mattst88@gmail.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-parisc@vger.kernel.org, kyle@mcmartin.ca, deller@gmx.de,
       jejb@parisc-linux.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 29, 2010 at 2:50 AM, FUJITA Tomonori
<fujita.tomonori@lab.ntt.co.jp> wrote:
> This is a resend:
>
> http://marc.info/?t=127432584100006&r=1&w=2
>
> I thought that it was merged but seems that it was lost somewhere?
>
> =
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Subject: [PATCH] parisc: set ARCH_KMALLOC_MINALIGN
>
> Architectures that handle DMA-non-coherent memory need to set
> ARCH_KMALLOC_MINALIGN to make sure that kmalloc'ed buffer is DMA-safe:
> the buffer doesn't share a cache with the others.
>
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Cc: Kyle McMartin <kyle@mcmartin.ca>
> Cc: Helge Deller <deller@gmx.de>
> Cc: James E.J. Bottomley <jejb@parisc-linux.org>
> Cc: stable@kernel.org
> ---
>  arch/parisc/include/asm/cache.h |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/arch/parisc/include/asm/cache.h b/arch/parisc/include/asm/cache.h
> index 45effe6..5d87f27 100644
> --- a/arch/parisc/include/asm/cache.h
> +++ b/arch/parisc/include/asm/cache.h
> @@ -22,6 +22,8 @@
>  #define L1_CACHE_SHIFT 5
>  #endif
>
> +#define ARCH_KMALLOC_MINALIGN  L1_CACHE_BYTES
> +
>  #ifndef __ASSEMBLY__
>
>  #define L1_CACHE_ALIGN(x)       (((x)+(L1_CACHE_BYTES-1))&~(L1_CACHE_BYTES-1))

Looks like you can send a patch to kill L1_CACHE_ALIGN too. :)

> --
> 1.6.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-parisc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
