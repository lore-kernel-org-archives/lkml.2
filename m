Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab0GLVnX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 17:43:23 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:25568 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753754Ab0GLVnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 17:43:21 -0400
Message-ID: <4C3B8C13.3040009@oracle.com>
Date: Mon, 12 Jul 2010 14:41:39 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Matt Fleming <matt@console-pimps.org>, linux-mmc@vger.kernel.org
Subject: Re: [PATCH v4] MMC: Add JZ4740 mmc driver
References: <1277688041-23522-1-git-send-email-lars@metafoo.de> <1278970413-21617-1-git-send-email-lars@metafoo.de>
In-Reply-To: <1278970413-21617-1-git-send-email-lars@metafoo.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4C3B8C63.000C:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lars-Peter Clausen wrote:
> This patch adds support for the mmc controller on JZ4740 SoCs.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> Acked-by: Matt Fleming <matt@console-pimps.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Matt Fleming <matt@console-pimps.org>
> Cc: linux-mmc@vger.kernel.org
> 
> ---
>  arch/mips/include/asm/mach-jz4740/jz4740_mmc.h |   15 +
>  drivers/mmc/host/Kconfig                       |    8 +
>  drivers/mmc/host/Makefile                      |    1 +
>  drivers/mmc/host/jz4740_mmc.c                  | 1024 ++++++++++++++++++++++++
>  4 files changed, 1048 insertions(+), 0 deletions(-)
>  create mode 100644 arch/mips/include/asm/mach-jz4740/jz4740_mmc.h
>  create mode 100644 drivers/mmc/host/jz4740_mmc.c
> 
> diff --git a/arch/mips/include/asm/mach-jz4740/jz4740_mmc.h b/arch/mips/include/asm/mach-jz4740/jz4740_mmc.h
> new file mode 100644
> index 0000000..8543f43
> --- /dev/null
> +++ b/arch/mips/include/asm/mach-jz4740/jz4740_mmc.h
> @@ -0,0 +1,15 @@
> +#ifndef __LINUX_MMC_JZ4740_MMC
> +#define __LINUX_MMC_JZ4740_MMC
> +
> +struct jz4740_mmc_platform_data {
> +	int gpio_power;
> +	int gpio_card_detect;
> +	int gpio_read_only;
> +	unsigned card_detect_active_low:1;
> +	unsigned read_only_active_low:1;
> +	unsigned power_active_low:1;
> +
> +	unsigned data_1bit:1;
> +};
> +
> +#endif
> diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
> index f06d06e..546fc49 100644
> --- a/drivers/mmc/host/Kconfig
> +++ b/drivers/mmc/host/Kconfig
> @@ -81,6 +81,14 @@ config MMC_RICOH_MMC
>  
>  	  If unsure, say Y.
>  
> +config MMC_JZ4740
> +	tristate "JZ4740 SD/Multimedia Card Interface support"
> +	depends on MACH_JZ4740

What tree has the kconfig symbol MACH_JZ4740 in it?
I can't seem to find it...

Should the depends also say anything about GPIO?
I only ask because the header file above mentions gpio.

> +	help
> +	  This selects the Ingenic Z4740 SD/Multimedia card Interface.
> +	  If you have an ngenic platform with a Multimedia Card slot,

	                 Ingenic ?

> +	  say Y or M here.
> +
>  config MMC_SDHCI_OF
>  	tristate "SDHCI support on OpenFirmware platforms"
>  	depends on MMC_SDHCI && PPC_OF

