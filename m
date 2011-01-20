Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619Ab1ATMh5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 07:37:57 -0500
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:35573 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755600Ab1ATMh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 07:37:56 -0500
Message-ID: <4D382C9F.6000108@stericsson.com>
Date: Thu, 20 Jan 2011 13:37:51 +0100
From: Mattias Wallin <mattias.wallin@stericsson.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Arun MURTHY <arun.murthy@stericsson.com>
Cc: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
Subject: Re: [PATCH] mfd: ab8500-gpadc Add new GPADC driver
References: <1295519304-27062-1-git-send-email-arun.murthy@stericsson.com>
In-Reply-To: <1295519304-27062-1-git-send-email-arun.murthy@stericsson.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2011 11:28 AM, Arun MURTHY wrote:
> AB8500 GPADC driver used to convert Acc and battery/ac/usb voltage
> 
> Signed-off-by: Arun Murthy <arun.murthy@stericsson.com>
> Acked-by: Linus Walleij <linus.walleij@stericsson.com>
> ---
>  drivers/mfd/Kconfig              |    7 +
>  drivers/mfd/Makefile             |    1 +
>  drivers/mfd/ab8500-gpadc.c       |  277 ++++++++++++++++++++++++++++++++++++++
>  include/linux/mfd/ab8500-gpadc.h |   47 +++++++
>  include/linux/mfd/ab8500.h       |    6 +
>  5 files changed, 338 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/mfd/ab8500-gpadc.c
>  create mode 100644 include/linux/mfd/ab8500-gpadc.h
> 
...
> +/**
> + * ab8500_gpadc_convert() - gpadc conversion
> + * @input:	analog input to be converted to digital data
> + *
> + * This function converts the selected analog i/p to digital
> + * data. Thereafter calibration has to be made to obtain the
> + * data in the required quantity measurement.
> + */
> +int ab8500_gpadc_convert(struct ab8500_gpadc *di, u8 input)
I would like this interface to change in order to remove the struct ab8500_gpadc
from the struct ab8500. I.e not restrict the users to subdriver of ab8500.
> +{
> +	int ret;
> +	u16 data = 0;
> +	int looplimit = 0;
> +	u8 val, low_data, high_data;
> +
> +	if (!di)
> +		return -ENODEV;
> +
> +	mutex_lock(&di->ab8500_gpadc_lock);
> +	/* Enable VTVout LDO this is required for GPADC */
> +	regulator_enable(di->regu);
...
> diff --git a/include/linux/mfd/ab8500.h b/include/linux/mfd/ab8500.h
> index 37f56b7..8ebc4d8 100644
> --- a/include/linux/mfd/ab8500.h
> +++ b/include/linux/mfd/ab8500.h
> @@ -106,6 +106,9 @@
>  #define AB8500_NR_IRQS			112
>  #define AB8500_NUM_IRQ_REGS		14
>  
> +/* Forward Declaration */
> +struct ab8500_gpadc;
> +
>  /**
>   * struct ab8500 - ab8500 internal structure
>   * @dev: parent device
> @@ -119,6 +122,7 @@
>   * @tx_buf: tx buf for SPI
>   * @mask: cache of IRQ regs for bus lock
>   * @oldmask: cache of previous IRQ regs for bus lock
> + * @gpadc: pointer to the ab8500 gpadc device information
>   */
>  struct ab8500 {
>  	struct device	*dev;
> @@ -137,6 +141,8 @@ struct ab8500 {
>  
>  	u8 mask[AB8500_NUM_IRQ_REGS];
>  	u8 oldmask[AB8500_NUM_IRQ_REGS];
> +
> +	struct ab8500_gpadc *gpadc;
Please remove this gpadc dependency from the struct ab8500.
>  };
>  
>  struct regulator_init_data;

Thanks and Regards,
Mattias Wallin
