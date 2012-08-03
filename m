Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146Ab2HCO5o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 10:57:44 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:40761 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753243Ab2HCO5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 10:57:42 -0400
Message-ID: <501BE6B1.9000100@ti.com>
Date: Fri, 3 Aug 2012 16:56:49 +0200
From: Benoit Cousson <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Sourav Poddar <sourav.poddar@ti.com>
CC: <khali@linux-fr.org>, <linux@roeck-us.net>, <lm-sensors@lm-sensors.org>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Felipe Balbi <balbi@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: Re: [PATCH] hwmon: tmp102: Add device tree support
References: <1343997350-676-1-git-send-email-sourav.poddar@ti.com>
In-Reply-To: <1343997350-676-1-git-send-email-sourav.poddar@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sourav,

On 08/03/2012 02:35 PM, Sourav Poddar wrote:
> update tmp102 temperature sensor to also use device tree.
> 
> Cc: Benoit Cousson <b-cousson@ti.com>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Acked-by: Felipe Balbi <balbi@ti.com>
> Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>
> ---
>  drivers/hwmon/tmp102.c |   14 +++++++++++++-
>  1 files changed, 13 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/hwmon/tmp102.c b/drivers/hwmon/tmp102.c
> index 0d466b9..a8a9060 100644
> --- a/drivers/hwmon/tmp102.c
> +++ b/drivers/hwmon/tmp102.c
> @@ -26,6 +26,7 @@
>  #include <linux/err.h>
>  #include <linux/mutex.h>
>  #include <linux/device.h>
> +#include <linux/of.h>
>  
>  #define	DRIVER_NAME "tmp102"
>  
> @@ -284,8 +285,19 @@ static const struct i2c_device_id tmp102_id[] = {
>  };
>  MODULE_DEVICE_TABLE(i2c, tmp102_id);
>  
> +#ifdef CONFIG_OF
> +static const struct of_device_id temperature_dt_match[] = {
> +	{ .compatible = "ti,tmp102" },

Are you sure this is needed for this device?

There is an automatic binding done for I2C devices in the of_i2c core
code. So in theory, DT will be able to bind to any I2C device using the
already existing table: MODULE_DEVICE_TABLE(i2c, tmp102_id).

So I think this patch should not be needed.

Regards,
Benoit

