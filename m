Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930Ab2BWVsL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 16:48:11 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35494 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731Ab2BWVsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 16:48:09 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of rmallon@gmail.com designates 10.68.74.72 as permitted sender) smtp.mail=rmallon@gmail.com; dkim=pass header.i=rmallon@gmail.com
Message-ID: <4F46B414.1090106@gmail.com>
Date: Fri, 24 Feb 2012 08:48:04 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.27) Gecko/20120216 Lightning/1.0b2 Thunderbird/3.1.19
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: plagnioj@jcrosoft.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk, arnd@arndb.de
Subject: Re: [PATCH v3 16/21] ARM: at91: finally drop at91_sys_read/write
References: <cover.1330006537.git.nicolas.ferre@atmel.com> <8c428b8d3316faa88cae80473bb67565561fb446.1330006537.git.nicolas.ferre@atmel.com>
In-Reply-To: <8c428b8d3316faa88cae80473bb67565561fb446.1330006537.git.nicolas.ferre@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/02/12 01:26, Nicolas Ferre wrote:

> From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> 
> Remove at91_sys_read/write() from io.h file. This function
> is not used anymore and was a stopper on the way to single
> zImage kernel for AT91.
> 
> Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>


Nice work guys.

Acked-by: Ryan Mallon <rmallon@gmail.com>

> ---
>  arch/arm/mach-at91/include/mach/io.h |   18 ------------------
>  1 files changed, 0 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/arm/mach-at91/include/mach/io.h b/arch/arm/mach-at91/include/mach/io.h
> index 4ca09ef..4003001 100644
> --- a/arch/arm/mach-at91/include/mach/io.h
> +++ b/arch/arm/mach-at91/include/mach/io.h
> @@ -28,22 +28,4 @@
>  #define __io(a)		__typesafe_io(a)
>  #define __mem_pci(a)	(a)
>  
> -#ifndef __ASSEMBLY__
> -
> -static inline unsigned int at91_sys_read(unsigned int reg_offset)
> -{
> -	void __iomem *addr = (void __iomem *)AT91_VA_BASE_SYS;
> -
> -	return __raw_readl(addr + reg_offset);
> -}
> -
> -static inline void at91_sys_write(unsigned int reg_offset, unsigned long value)
> -{
> -	void __iomem *addr = (void __iomem *)AT91_VA_BASE_SYS;
> -
> -	__raw_writel(value, addr + reg_offset);
> -}
> -
> -#endif
> -
>  #endif


