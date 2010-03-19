Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247Ab0CSQkq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 12:40:46 -0400
Received: from mga06.intel.com ([134.134.136.21]:39992 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751993Ab0CSQkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 12:40:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,275,1267430400"; 
   d="scan'208";a="605950779"
Date: Fri, 19 Mar 2010 17:41:36 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Richard =?iso-8859-1?Q?R=F6jfors?= 
	<richard.rojfors@pelagicore.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: Add in XIIC to some configurations of timberdale
Message-ID: <20100319164135.GC30409@sortiz.org>
References: <1268732608.2020.10.camel@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1268732608.2020.10.camel@debian>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

On Tue, Mar 16, 2010 at 10:43:28AM +0100, Richard Röjfors wrote:
> This patch adds in the Xilinx I2C bus driver to some of the
> configurations of the timberdale MFD.
> 
> It provides the I2C devices to the XIIC via platform data in a
> similar way as done to the ocores driver.
Thanks, patch applied.

Cheers,
Samuel.


> Signed-off-by: Richard Röjfors <richard.rojfors@pelagicore.com>
> ---
> diff --git a/drivers/mfd/timberdale.c b/drivers/mfd/timberdale.c
> index 1ed44d2..1d52349 100644
> --- a/drivers/mfd/timberdale.c
> +++ b/drivers/mfd/timberdale.c
> @@ -30,6 +30,7 @@
>  
>  #include <linux/i2c.h>
>  #include <linux/i2c-ocores.h>
> +#include <linux/i2c-xiic.h>
>  #include <linux/i2c/tsc2007.h>
>  
>  #include <linux/spi/spi.h>
> @@ -68,6 +69,12 @@ static struct i2c_board_info timberdale_i2c_board_info[] = {
>  	},
>  };
>  
> +static __devinitdata struct xiic_i2c_platform_data
> +timberdale_xiic_platform_data = {
> +	.devices = timberdale_i2c_board_info,
> +	.num_devices = ARRAY_SIZE(timberdale_i2c_board_info)
> +};
> +
>  static __devinitdata struct ocores_i2c_platform_data
>  timberdale_ocores_platform_data = {
>  	.regstep = 4,
> @@ -76,6 +83,19 @@ timberdale_ocores_platform_data = {
>  	.num_devices = ARRAY_SIZE(timberdale_i2c_board_info)
>  };
>  
> +const static __devinitconst struct resource timberdale_xiic_resources[] = {
> +	{
> +		.start	= XIICOFFSET,
> +		.end	= XIICEND,
> +		.flags	= IORESOURCE_MEM,
> +	},
> +	{
> +		.start	= IRQ_TIMBERDALE_I2C,
> +		.end	= IRQ_TIMBERDALE_I2C,
> +		.flags	= IORESOURCE_IRQ,
> +	},
> +};
> +
>  const static __devinitconst struct resource timberdale_ocores_resources[] = {
>  	{
>  		.start	= OCORESOFFSET,
> @@ -269,6 +289,13 @@ static __devinitdata struct mfd_cell timberdale_cells_bar0_cfg0[] = {
>  		.resources = timberdale_uart_resources,
>  	},
>  	{
> +		.name = "xiic-i2c",
> +		.num_resources = ARRAY_SIZE(timberdale_xiic_resources),
> +		.resources = timberdale_xiic_resources,
> +		.platform_data = &timberdale_xiic_platform_data,
> +		.data_size = sizeof(timberdale_xiic_platform_data),
> +	},
> +	{
>  		.name = "timb-gpio",
>  		.num_resources = ARRAY_SIZE(timberdale_gpio_resources),
>  		.resources = timberdale_gpio_resources,
> @@ -313,6 +340,13 @@ static __devinitdata struct mfd_cell timberdale_cells_bar0_cfg1[] = {
>  		.resources = timberdale_uartlite_resources,
>  	},
>  	{
> +		.name = "xiic-i2c",
> +		.num_resources = ARRAY_SIZE(timberdale_xiic_resources),
> +		.resources = timberdale_xiic_resources,
> +		.platform_data = &timberdale_xiic_platform_data,
> +		.data_size = sizeof(timberdale_xiic_platform_data),
> +	},
> +	{
>  		.name = "timb-gpio",
>  		.num_resources = ARRAY_SIZE(timberdale_gpio_resources),
>  		.resources = timberdale_gpio_resources,
> @@ -357,6 +391,13 @@ static __devinitdata struct mfd_cell timberdale_cells_bar0_cfg2[] = {
>  		.resources = timberdale_uart_resources,
>  	},
>  	{
> +		.name = "xiic-i2c",
> +		.num_resources = ARRAY_SIZE(timberdale_xiic_resources),
> +		.resources = timberdale_xiic_resources,
> +		.platform_data = &timberdale_xiic_platform_data,
> +		.data_size = sizeof(timberdale_xiic_platform_data),
> +	},
> +	{
>  		.name = "timb-gpio",
>  		.num_resources = ARRAY_SIZE(timberdale_gpio_resources),
>  		.resources = timberdale_gpio_resources,
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
