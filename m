Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751695Ab0IJK1l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 06:27:41 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:59016 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab0IJK1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 06:27:40 -0400
Message-ID: <4C8A07BA.9090805@ru.mvista.com>
Date: Fri, 10 Sep 2010 14:26:02 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.9) Gecko/20100825 Thunderbird/3.1.3
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        avictor.za@gmail.com
Subject: Re: [PATCH] AT91: at91sam9261ek board: remove warnings related to
 use of SPI or SD/MMC
References: <1284113629-13768-1-git-send-email-nicolas.ferre@atmel.com> <1284113629-13768-2-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <1284113629-13768-2-git-send-email-nicolas.ferre@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 10-09-2010 14:13, Nicolas Ferre wrote:

> The sd/mmc data structure is not used if SPI is selected. The configuration
> of PIO on the board prevent from using both interfaces at the same time
> (board dependent).
> Remove the warnings at compilation time adding a preprocessor condition.

> Signed-off-by: Nicolas Ferre<nicolas.ferre@atmel.com>
[...]
> diff --git a/arch/arm/mach-at91/board-sam9261ek.c b/arch/arm/mach-at91/board-sam9261ek.c
> index b4307ab..19d4d2c 100644
> --- a/arch/arm/mach-at91/board-sam9261ek.c
> +++ b/arch/arm/mach-at91/board-sam9261ek.c
> @@ -169,17 +169,6 @@ static struct at91_udc_data __initdata ek_udc_data = {
>
>
>   /*
> - * MCI (SD/MMC)
> - */
> -static struct at91_mmc_data __initdata ek_mmc_data = {
> -	.wire4		= 1,
> -//	.det_pin	= ... not connected
> -//	.wp_pin		= ... not connected
> -//	.vcc_pin	= ... not connected
> -};
> -
> -
> -/*
>    * NAND flash
>    */
>   static struct mtd_partition __initdata ek_nand_partition[] = {
> @@ -247,6 +236,10 @@ static void __init ek_add_device_nand(void)
>   	at91_add_device_nand(&ek_nand_data);
>   }
>
> +/*
> + * SPI related devices
> + */
> +#if defined(CONFIG_SPI_ATMEL) || defined(CONFIG_SPI_ATMEL_MODULE)
>
>   /*
>    * ADS7846 Touchscreen
> @@ -357,6 +350,21 @@ static struct spi_board_info ek_spi_devices[] = {
>   #endif
>   };
>
> +#else /* CONFIG_SPI_ATMEL_* */
> +
> +/*
> + * MCI (SD/MMC)
> + * spi0 and mmc/sd share the same PIO pins: cannot be used at the same time
> + */
> +static struct at91_mmc_data __initdata ek_mmc_data = {
> +	.wire4		= 1,
> +//	.det_pin	= ... not connected
> +//	.wp_pin		= ... not connected
> +//	.vcc_pin	= ... not connected

    The coding style document forbids C99 style // comments. Could replace 
with normal comment or #if 0...

WBR, Sergei
