Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962Ab2ESFrR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 01:47:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53016 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167Ab2ESFrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 01:47:14 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH V4 1/3] GPIO: MIPS: lantiq: move gpio-stp and gpio-ebu to the subsystem folder
To: John Crispin <blogic@openwrt.org>, Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, John Crispin <blogic@openwrt.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1337355777-1680-1-git-send-email-blogic@openwrt.org>
References: <1337355777-1680-1-git-send-email-blogic@openwrt.org>
Date: Fri, 18 May 2012 23:47:12 -0600
Message-Id: <20120519054712.EF0903E046E@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 May 2012 17:42:55 +0200, John Crispin <blogic@openwrt.org> wrote:
> Move the 2 drivers from arch/mips/lantiq/xway/ to the subsystem and make them
> buildable.
> 
> The following 2 patches will convert the drivers to OF.
> 
> Signed-off-by: John Crispin <blogic@openwrt.org>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: linux-kernel@vger.kernel.org

for all 3:

Acked-by: Grant Likely <grant.likely@secretlab.ca>

g.

> ---
> This patch is part of a series moving the mips/lantiq target to OF and clkdev
> support. The patch, once Acked, should go upstream via Ralf's MIPS tree.
> 
>  arch/mips/lantiq/xway/Makefile                     |    2 +-
>  drivers/gpio/Kconfig                               |   18 ++++++++++++++++++
>  drivers/gpio/Makefile                              |    2 ++
>  .../gpio_ebu.c => drivers/gpio/gpio-mm-lantiq.c    |    0
>  .../gpio_stp.c => drivers/gpio/gpio-stp-xway.c     |    0
>  5 files changed, 21 insertions(+), 1 deletions(-)
>  rename arch/mips/lantiq/xway/gpio_ebu.c => drivers/gpio/gpio-mm-lantiq.c (100%)
>  rename arch/mips/lantiq/xway/gpio_stp.c => drivers/gpio/gpio-stp-xway.c (100%)
> 
> diff --git a/arch/mips/lantiq/xway/Makefile b/arch/mips/lantiq/xway/Makefile
> index edef6c5..dc3194f 100644
> --- a/arch/mips/lantiq/xway/Makefile
> +++ b/arch/mips/lantiq/xway/Makefile
> @@ -1 +1 @@
> -obj-y := prom.o sysctrl.o clk.o reset.o gpio.o gpio_stp.o gpio_ebu.o dma.o
> +obj-y := prom.o sysctrl.o clk.o reset.o gpio.o dma.o
> diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
> index e03653d..8fae079 100644
> --- a/drivers/gpio/Kconfig
> +++ b/drivers/gpio/Kconfig
> @@ -96,6 +96,14 @@ config GPIO_EP93XX
>  	depends on ARCH_EP93XX
>  	select GPIO_GENERIC
>  
> +config GPIO_MM_LANTIQ
> +	bool "Lantiq Memory mapped GPIOs"
> +	depends on LANTIQ && SOC_XWAY
> +	help
> +	  This enables support for memory mapped GPIOs on the External Bus Unit
> +	  (EBU) found on Lantiq SoCs. The gpios are output only as they are
> +	  created by attaching a 16bit latch to the bus.
> +
>  config GPIO_MPC5200
>  	def_bool y
>  	depends on PPC_MPC52xx
> @@ -306,6 +314,16 @@ config GPIO_STMPE
>  	  This enables support for the GPIOs found on the STMPE I/O
>  	  Expanders.
>  
> +config GPIO_STP_XWAY
> +	bool "XWAY STP GPIOs"
> +	depends on SOC_XWAY
> +	help
> +	  This enables support for the Serial To Parallel (STP) unit found on
> +	  XWAY SoC. The STP allows the SoC to drive a shift registers cascade,
> +	  that can be up to 24 bit. This peripheral is aimed at driving leds.
> +	  Some of the gpios/leds can be auto updated by the soc with dsl and
> +	  phy status.
> +
>  config GPIO_TC3589X
>  	bool "TC3589X GPIOs"
>  	depends on MFD_TC3589X
> diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
> index 007f54b..ed1c96d 100644
> --- a/drivers/gpio/Makefile
> +++ b/drivers/gpio/Makefile
> @@ -30,6 +30,7 @@ obj-$(CONFIG_GPIO_MC33880)	+= gpio-mc33880.o
>  obj-$(CONFIG_GPIO_MC9S08DZ60)	+= gpio-mc9s08dz60.o
>  obj-$(CONFIG_GPIO_MCP23S08)	+= gpio-mcp23s08.o
>  obj-$(CONFIG_GPIO_ML_IOH)	+= gpio-ml-ioh.o
> +obj-$(CONFIG_GPIO_MM_LANTIQ)	+= gpio-mm-lantiq.o
>  obj-$(CONFIG_GPIO_MPC5200)	+= gpio-mpc5200.o
>  obj-$(CONFIG_GPIO_MPC8XXX)	+= gpio-mpc8xxx.o
>  obj-$(CONFIG_GPIO_MSM_V1)	+= gpio-msm-v1.o
> @@ -49,6 +50,7 @@ obj-$(CONFIG_ARCH_SA1100)	+= gpio-sa1100.o
>  obj-$(CONFIG_GPIO_SCH)		+= gpio-sch.o
>  obj-$(CONFIG_GPIO_SODAVILLE)	+= gpio-sodaville.o
>  obj-$(CONFIG_GPIO_STMPE)	+= gpio-stmpe.o
> +obj-$(CONFIG_GPIO_STP_XWAY)	+= gpio-stp-xway.o
>  obj-$(CONFIG_GPIO_SX150X)	+= gpio-sx150x.o
>  obj-$(CONFIG_GPIO_TC3589X)	+= gpio-tc3589x.o
>  obj-$(CONFIG_ARCH_TEGRA)	+= gpio-tegra.o
> diff --git a/arch/mips/lantiq/xway/gpio_ebu.c b/drivers/gpio/gpio-mm-lantiq.c
> similarity index 100%
> rename from arch/mips/lantiq/xway/gpio_ebu.c
> rename to drivers/gpio/gpio-mm-lantiq.c
> diff --git a/arch/mips/lantiq/xway/gpio_stp.c b/drivers/gpio/gpio-stp-xway.c
> similarity index 100%
> rename from arch/mips/lantiq/xway/gpio_stp.c
> rename to drivers/gpio/gpio-stp-xway.c
> -- 
> 1.7.9.1
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
