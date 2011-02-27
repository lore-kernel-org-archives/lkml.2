Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246Ab1B0XoV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 18:44:21 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:49232 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897Ab1B0Xny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 18:43:54 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
Subject: Re: [PATCH 09/12] unicore32 machine related files: hardware registers
Date: Sun, 27 Feb 2011 18:15:42 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        "'Greg KH'" <greg@kroah.com>
References: <015301cbcdae$55cdb7e0$016927a0$@mprc.pku.edu.cn> <201102261416.10050.arnd@arndb.de> <017d01cbd62f$53af8590$fb0e90b0$@mprc.pku.edu.cn>
In-Reply-To: <017d01cbd62f$53af8590$fb0e90b0$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102271815.42395.arnd@arndb.de>
X-Provags-ID: V02:K0:pLUtqcxyZZl8eguYH63rbjCYey4+ynWzSMMDGfqNZK/
 LoBBWoXS14zbKOpZkrEkqgS5+aJOXYkyuOXdYpcTv/cVk+T39C
 WNOvHYSXJ4bAxMFVxnnI3BIs/XburfiAELzcsDMszsQrC3nCaj
 d4olIoXmWOLszatlKlwdEStK5eXIZDCudiDUw8JScCdW9qmQJd
 O76r2IMCfEUrSBgiSPpMg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 27 February 2011, Guan Xuetao wrote:
> Please see following patch, __REG removed and __iomem added to io_p2v:
> 
> diff --git a/arch/unicore32/include/mach/hardware.h b/arch/unicore32/include/mach/hardware.h
> index b71405a..b197b0b 100644
> --- a/arch/unicore32/include/mach/hardware.h
> +++ b/arch/unicore32/include/mach/hardware.h
> @@ -17,13 +17,10 @@
>  
>  #include "PKUnity.h"
>  
> -#define io_p2v(x)      ((x) - PKUNITY_MMIO_BASE)
> -#define io_v2p(x)      ((x) + PKUNITY_MMIO_BASE)
> -
>  #ifndef __ASSEMBLY__
> -
> -# define __REG(x)      (void __iomem *)io_p2v(x)
> -
> +#define io_p2v(x)      (void __iomem *)((x) - PKUNITY_MMIO_BASE)
> +#else
> +#define io_p2v(x)      ((x) - PKUNITY_MMIO_BASE)
>  #endif
>  
>  #define PCIBIOS_MIN_IO                 0x4000 /* should lower than 64KB */

Yes, looks good!

Acked-by: Arnd Bergmann <arnd@arndb.de>

