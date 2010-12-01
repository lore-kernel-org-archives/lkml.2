Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab0LAPyZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 10:54:25 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45341 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884Ab0LAPyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 10:54:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=dH+LlP3GKlSSVZwuNV1+gjH7HclQM2YRVBwZZz9Q8CxaANG8hPcRGJm4XZ9Dso6nbG
         Dm9bzHi9nizY4hsddl0yPfEYjsdj+pklc8sfIBGdKkUMjey9n+bq9Z8GjaIJoGgcdGYi
         7yEMy5dpMX4CAsqPlYNqcQjgFthStN5Dc/jWQ=
Subject: Re: [PATCH RESEND] MIPS: Define dummy MAX_DMA_CHANNELS to fix
 build failure
From: Namhyung Kim <namhyung@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
In-Reply-To: <1289918840-13434-1-git-send-email-namhyung@gmail.com>
References: <1289918840-13434-1-git-send-email-namhyung@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Dec 2010 00:54:13 +0900
Message-ID: <1291218853.1684.35.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010-11-16 (화), 23:47 +0900, Namhyung Kim:
> allmodconfig build failes like following:
> 
>   CC [M]  sound/oss/soundcard.o
> sound/oss/soundcard.c:68: error: 'MAX_DMA_CHANNELS' undeclared here (not in a function)
> make[3]: *** [sound/oss/soundcard.o] Error 1
> make[2]: *** [sound/oss] Error 2
> make[1]: *** [sub-make] Error 2
> make: *** [all] Error 2
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  arch/mips/include/asm/dma.h |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/mips/include/asm/dma.h b/arch/mips/include/asm/dma.h
> index 2d47da6..c601cff 100644
> --- a/arch/mips/include/asm/dma.h
> +++ b/arch/mips/include/asm/dma.h
> @@ -74,7 +74,9 @@
>   *
>   */
>  
> -#ifndef CONFIG_GENERIC_ISA_DMA_SUPPORT_BROKEN
> +#ifdef CONFIG_GENERIC_ISA_DMA_SUPPORT_BROKEN
> +#define MAX_DMA_CHANNELS	0
> +#else
>  #define MAX_DMA_CHANNELS	8
>  #endif
>  

Ping. Any comments?


-- 
Regards,
Namhyung Kim


