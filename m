Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441Ab2BWVrS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 16:47:18 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:45438 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288Ab2BWVrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 16:47:17 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of rmallon@gmail.com designates 10.68.193.136 as permitted sender) smtp.mail=rmallon@gmail.com; dkim=pass header.i=rmallon@gmail.com
Message-ID: <4F46B3DF.7010402@gmail.com>
Date: Fri, 24 Feb 2012 08:47:11 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.27) Gecko/20120216 Lightning/1.0b2 Thunderbird/3.1.19
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: plagnioj@jcrosoft.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk, arnd@arndb.de
Subject: Re: [PATCH v3 17/21] ARM: at91: merge SRAM Memory banks thanks to
 mirroring
References: <cover.1330006537.git.nicolas.ferre@atmel.com> <c9b1e3ffbc322a1d1e1272062a9361abe536a33a.1330006537.git.nicolas.ferre@atmel.com>
In-Reply-To: <c9b1e3ffbc322a1d1e1272062a9361abe536a33a.1330006537.git.nicolas.ferre@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/02/12 01:26, Nicolas Ferre wrote:

> From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> 
> On at91sam9260 and at91sam9g20 the SRAM banks are mirrored. We can
> merge them together to be able to have bigger and continuous
> internal RAM.

I think this patch needs some comments in the code. As mentioned in the
last round, this functionality is not documented, so it is not obvious
how/why this works. This is especially true for any user who has
problems with this code and then tries to look up those addresses in
their at91 manual only to find the regions are reserved.

Nicolas, are you able to give an official Atmel stance on this?

~Ryan

> Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
>  arch/arm/mach-at91/at91sam9260.c              |   13 +++++--------
>  arch/arm/mach-at91/include/mach/at91sam9260.h |    4 ++++
>  2 files changed, 9 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm/mach-at91/at91sam9260.c b/arch/arm/mach-at91/at91sam9260.c
> index 14882ae..4ade265 100644
> --- a/arch/arm/mach-at91/at91sam9260.c
> +++ b/arch/arm/mach-at91/at91sam9260.c
> @@ -310,15 +310,12 @@ static void __init at91sam9xe_map_io(void)
>  
>  static void __init at91sam9260_map_io(void)
>  {
> -	if (cpu_is_at91sam9xe()) {
> +	if (cpu_is_at91sam9xe())
>  		at91sam9xe_map_io();
> -	} else if (cpu_is_at91sam9g20()) {
> -		at91_init_sram(0, AT91SAM9G20_SRAM0_BASE, AT91SAM9G20_SRAM0_SIZE);
> -		at91_init_sram(1, AT91SAM9G20_SRAM1_BASE, AT91SAM9G20_SRAM1_SIZE);
> -	} else {
> -		at91_init_sram(0, AT91SAM9260_SRAM0_BASE, AT91SAM9260_SRAM0_SIZE);
> -		at91_init_sram(1, AT91SAM9260_SRAM1_BASE, AT91SAM9260_SRAM1_SIZE);
> -	}
> +	else if (cpu_is_at91sam9g20())
> +		at91_init_sram(0, AT91SAM9G20_SRAM_BASE, AT91SAM9G20_SRAM_SIZE);
> +	else
> +		at91_init_sram(0, AT91SAM9260_SRAM_BASE, AT91SAM9260_SRAM_SIZE);
>  }
>  
>  static void __init at91sam9260_ioremap_registers(void)
> diff --git a/arch/arm/mach-at91/include/mach/at91sam9260.h b/arch/arm/mach-at91/include/mach/at91sam9260.h
> index 2e47b6d..08ae9af 100644
> --- a/arch/arm/mach-at91/include/mach/at91sam9260.h
> +++ b/arch/arm/mach-at91/include/mach/at91sam9260.h
> @@ -113,6 +113,8 @@
>  #define AT91SAM9260_SRAM0_SIZE	SZ_4K		/* Internal SRAM 0 size (4Kb) */
>  #define AT91SAM9260_SRAM1_BASE	0x00300000	/* Internal SRAM 1 base address */
>  #define AT91SAM9260_SRAM1_SIZE	SZ_4K		/* Internal SRAM 1 size (4Kb) */
> +#define AT91SAM9260_SRAM_BASE	0x002FF000	/* Internal SRAM base address */
> +#define AT91SAM9260_SRAM_SIZE	SZ_8K		/* Internal SRAM size (8Kb) */
>  
>  #define AT91SAM9260_UHP_BASE	0x00500000	/* USB Host controller */
>  
> @@ -126,6 +128,8 @@
>  #define AT91SAM9G20_SRAM0_SIZE	SZ_16K		/* Internal SRAM 0 size (16Kb) */
>  #define AT91SAM9G20_SRAM1_BASE	0x00300000	/* Internal SRAM 1 base address */
>  #define AT91SAM9G20_SRAM1_SIZE	SZ_16K		/* Internal SRAM 1 size (16Kb) */
> +#define AT91SAM9G20_SRAM_BASE	0x002FC000	/* Internal SRAM base address */
> +#define AT91SAM9G20_SRAM_SIZE	SZ_32K		/* Internal SRAM size (32Kb) */
>  
>  #define AT91SAM9G20_UHP_BASE	0x00500000	/* USB Host controller */
>  


