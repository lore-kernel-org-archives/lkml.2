Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623Ab2CLCCR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 22:02:17 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43627 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754442Ab2CLCCL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 22:02:11 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <1331405095-3299-1-git-send-email-alan@signal11.us>
References: <1331405049-3186-1-git-send-email-alan@signal11.us>
	<1331405095-3299-1-git-send-email-alan@signal11.us>
Date: Sun, 11 Mar 2012 19:02:10 -0700
Message-ID: <CAOesGMgBGcFuu8Vj=Y1rqowZeDvcT75745wq19COda3E0i3mWQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] ARM: at91: Use proper __iomem annotations
From: Olof Johansson <olof@lixom.net>
To: Alan Ott <alan@signal11.us>
Cc: Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Mar 10, 2012 at 10:44 AM, Alan Ott <alan@signal11.us> wrote:
> diff --git a/arch/arm/mach-at91/include/mach/hardware.h b/arch/arm/mach-at91/include/mach/hardware.h
> index 2d0e4e9..91375e2 100644
> --- a/arch/arm/mach-at91/include/mach/hardware.h
> +++ b/arch/arm/mach-at91/include/mach/hardware.h
> @@ -75,8 +75,12 @@
>  * to 0xFEF78000 .. 0xFF000000.  (544Kb)
>  */
>  #define AT91_IO_PHYS_BASE      0xFFF78000
> +#ifdef __ASSEMBLER__
>  #define AT91_IO_VIRT_BASE      (0xFF000000 - AT91_IO_SIZE)
>  #else
> +#define AT91_IO_VIRT_BASE      (void __iomem *)(0xFF000000 - AT91_IO_SIZE)
> +#endif
> +#else

This can use the IOMEM()-style macro instead, Rob Herring just moved
those to a common header file (not yet in any tree though).


-Olof
