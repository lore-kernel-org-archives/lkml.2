Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757850Ab2BMUBN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 15:01:13 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53113 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757833Ab2BMUBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 15:01:12 -0500
Message-ID: <4F396C4C.9060108@gmail.com>
Date: Tue, 14 Feb 2012 07:02:20 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.26) Gecko/20120131 Thunderbird/3.1.18
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: plagnioj@jcrosoft.com, linux-arm-kernel@lists.infradead.org,
        grant.likely@secretlab.ca, rob.herring@calxeda.com, tglx@linutronix.de,
        devicetree-discuss@lists.ozlabs.org, avictor.za@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/9] ARM: at91/snapper9260: move gpio_to_irq out of structure
 initialization
References: <1329144189-4535-1-git-send-email-nicolas.ferre@atmel.com> <e0557a2864e52e017a0e931c6c64fd341ae21559.1329139662.git.nicolas.ferre@atmel.com>
In-Reply-To: <e0557a2864e52e017a0e931c6c64fd341ae21559.1329139662.git.nicolas.ferre@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/02/12 01:43, Nicolas Ferre wrote:

> gpio_to_irq() implementation will be moved from a macro to a
> plain function: we cannot use it in a structure initialization
> anymore.

What was the reason for the change? It was originally a macro for 
exactly this reason.

Anyway,

Reviewed-by: Ryan Mallon <rmallon@gmail.com>

> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> Cc: rmallon@gmail.com
> ---
>  arch/arm/mach-at91/board-snapper9260.c |   10 +++++++---
>  1 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/mach-at91/board-snapper9260.c b/arch/arm/mach-at91/board-snapper9260.c
> index 4770db0..3c2e3fc 100644
> --- a/arch/arm/mach-at91/board-snapper9260.c
> +++ b/arch/arm/mach-at91/board-snapper9260.c
> @@ -145,11 +145,11 @@ static struct i2c_board_info __initdata snapper9260_i2c_devices[] = {
>  		/* Audio codec */
>  		I2C_BOARD_INFO("tlv320aic23", 0x1a),
>  	},
> -	{
> +};
> +
> +static struct i2c_board_info __initdata snapper9260_i2c_isl1208 = {
>  		/* RTC */
>  		I2C_BOARD_INFO("isl1208", 0x6f),
> -		.irq = gpio_to_irq(AT91_PIN_PA31),
> -	},
>  };
>  
>  static void __init snapper9260_add_device_nand(void)
> @@ -163,6 +163,10 @@ static void __init snapper9260_board_init(void)
>  {
>  	at91_add_device_i2c(snapper9260_i2c_devices,
>  			    ARRAY_SIZE(snapper9260_i2c_devices));
> +
> +	snapper9260_i2c_isl1208.irq = gpio_to_irq(AT91_PIN_PA31);
> +	i2c_register_board_info(0, &snapper9260_i2c_isl1208, 1);
> +
>  	at91_add_device_serial();
>  	at91_add_device_usbh(&snapper9260_usbh_data);
>  	at91_add_device_udc(&snapper9260_udc_data);


