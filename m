Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729Ab1KYKA0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 05:00:26 -0500
Received: from imr4.ericy.com ([198.24.6.9]:46325 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753550Ab1KYKAZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 05:00:25 -0500
Date: Fri, 25 Nov 2011 01:58:23 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Lars-Peter Clausen <lars@metafoo.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jean Delvare <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH 04/11] hwmon: Remove redundant spi driver bus
 initialization
Message-ID: <20111125095823.GB8908@ericsson.com>
References: <1322148561-25138-1-git-send-email-lars@metafoo.de>
 <1322148561-25138-4-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1322148561-25138-4-git-send-email-lars@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 24, 2011 at 10:29:14AM -0500, Lars-Peter Clausen wrote:
> In ancient times it was necessary to manually initialize the bus field of an
> spi_driver to spi_bus_type. These days this is done in spi_driver_register(),

s/spi_driver_register/spi_register_driver/

Otherwise

Acked-by: Guenter Roeck <guenter.roeck@ericsson.com>

Jean, ok if I take this and the others, or do you want to handle it ?

Guenter

> so we can drop the manual assignment.
> 
> The patch was generated using the following coccinelle semantic patch:
> // <smpl>
> @@
> identifier _driver;
> @@
> struct spi_driver _driver = {
> 	.driver = {
> -		.bus = &spi_bus_type,
> 	},
> };
> // </smpl>
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> Cc: Jean Delvare <khali@linux-fr.org>
> Cc: Guenter Roeck <guenter.roeck@ericsson.com>
> Cc: lm-sensors@lm-sensors.org
> ---
>  drivers/hwmon/ad7314.c  |    1 -
>  drivers/hwmon/ads7871.c |    1 -
>  2 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/hwmon/ad7314.c b/drivers/hwmon/ad7314.c
> index 318e38e..5d760f3 100644
> --- a/drivers/hwmon/ad7314.c
> +++ b/drivers/hwmon/ad7314.c
> @@ -160,7 +160,6 @@ MODULE_DEVICE_TABLE(spi, ad7314_id);
>  static struct spi_driver ad7314_driver = {
>  	.driver = {
>  		.name = "ad7314",
> -		.bus = &spi_bus_type,
>  		.owner = THIS_MODULE,
>  	},
>  	.probe = ad7314_probe,
> diff --git a/drivers/hwmon/ads7871.c b/drivers/hwmon/ads7871.c
> index 5231934..04450f8 100644
> --- a/drivers/hwmon/ads7871.c
> +++ b/drivers/hwmon/ads7871.c
> @@ -227,7 +227,6 @@ static int __devexit ads7871_remove(struct spi_device *spi)
>  static struct spi_driver ads7871_driver = {
>  	.driver = {
>  		.name = DEVICE_NAME,
> -		.bus = &spi_bus_type,
>  		.owner = THIS_MODULE,
>  	},
>  
> -- 
> 1.7.7.1
> 
> 

-- 
Guenter Roeck
Distinguished Engineer
PDU IP Systems
