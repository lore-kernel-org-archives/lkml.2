Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112Ab2GXNh6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 09:37:58 -0400
Received: from mga01.intel.com ([192.55.52.88]:5042 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753267Ab2GXNhz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 09:37:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="197368316"
Message-ID: <500EA53A.5020606@linux.intel.com>
Date: Tue, 24 Jul 2012 16:38:02 +0300
From: Mathias Nyman <mathias.nyman@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] gpio: msic: Fix calculating register address in msic_gpio_to_oreg()
References: <1343126116.6033.1.camel@phoenix>
In-Reply-To: <1343126116.6033.1.camel@phoenix>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2012 01:35 PM, Axel Lin wrote:
> In the case offset is 20 ... 23, the equation to get the register should be:
>          INTEL_MSIC_GPIO1HV0CTLO - offset + 20
>
> With above equation, we can get below mapping between offset and the register:
>          offset is 20: INTEL_MSIC_GPIO1HV0CTLO
>          offset is 21: INTEL_MSIC_GPIO1HV1CTLO
>          offset is 22: INTEL_MSIC_GPIO1HV2CTLO
>          offset is 23: INTEL_MSIC_GPIO1HV3CTLO
>
> Signed-off-by: Axel Lin<axel.lin@gmail.com>
> ---
>   drivers/gpio/gpio-msic.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpio/gpio-msic.c b/drivers/gpio/gpio-msic.c
> index 71a838f..b389862 100644
> --- a/drivers/gpio/gpio-msic.c
> +++ b/drivers/gpio/gpio-msic.c
> @@ -99,7 +99,7 @@ static int msic_gpio_to_oreg(unsigned offset)
>   	if (offset<  20)
>   		return INTEL_MSIC_GPIO0HV0CTLO - offset + 16;
>
> -	return INTEL_MSIC_GPIO1HV0CTLO + offset + 20;
> +	return INTEL_MSIC_GPIO1HV0CTLO - offset + 20;
>   }
>
>   static int msic_gpio_direction_input(struct gpio_chip *chip, unsigned offset)

Nice, good catch.

The last 4 of the 24 gpios will work properly as outputs with this fix.

Acked-by: Mathias Nyman <mathias.nyman@linux.intel.com>

