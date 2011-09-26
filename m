Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472Ab1IZS3E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 14:29:04 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6086 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607Ab1IZS3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 14:29:03 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 26 Sep 2011 11:29:02 -0700
Subject: Re: [PATCH v2] net:rfkill: add a gpio setup function into GPIO
 rfkill
From: Rhyland Klein <rklein@nvidia.com>
To: Sangwook Lee <sangwook.lee@linaro.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1317051787-24142-1-git-send-email-sangwook.lee@linaro.org>
References: <1317051787-24142-1-git-send-email-sangwook.lee@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Sep 2011 11:27:17 -0700
Message-ID: <1317061637.31414.1.camel@rklein-linux2>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-09-26 at 08:43 -0700, Sangwook Lee wrote:
> Add a gpio setup function which gives a chance to set up
> platform specific configuration such as pin multiplexing,
> input/output direction at the runtime or booting time.
> 
> Signed-off-by: Sangwook Lee <sangwook.lee@linaro.org>
> 
> v2:
> - fixed the return type after checking gpio_runtime_setup
> ---
>  include/linux/rfkill-gpio.h |    2 ++
>  net/rfkill/rfkill-gpio.c    |    8 ++++++++
>  2 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/rfkill-gpio.h b/include/linux/rfkill-gpio.h
> index a175d05..786e7bb 100644
> --- a/include/linux/rfkill-gpio.h
> +++ b/include/linux/rfkill-gpio.h
> @@ -30,6 +30,7 @@
>   * @reset_gpio:		GPIO which is used for reseting rfkill switch
>   * @shutdown_gpio:	GPIO which is used for shutdown of rfkill switch
>   * @power_clk_name:	[optional] name of clk to turn off while blocked
> + * @gpio_runtime_setup:	set up platform specific gpio configuration
>   */
>  
>  struct rfkill_gpio_platform_data {
> @@ -38,6 +39,7 @@ struct rfkill_gpio_platform_data {
>  	int			shutdown_gpio;
>  	const char		*power_clk_name;
>  	enum rfkill_type	type;
> +	int	(*gpio_runtime_setup)(struct platform_device *);
>  };
>  
>  #endif /* __RFKILL_GPIO_H */
> diff --git a/net/rfkill/rfkill-gpio.c b/net/rfkill/rfkill-gpio.c
> index 256c5dd..96a910c 100644
> --- a/net/rfkill/rfkill-gpio.c
> +++ b/net/rfkill/rfkill-gpio.c
> @@ -101,6 +101,14 @@ static int rfkill_gpio_probe(struct platform_device *pdev)
>  	if (!rfkill)
>  		return -ENOMEM;
>  
> +	if (pdata->gpio_runtime_setup) {
> +		ret = pdata->gpio_runtime_setup(pdev);
> +		if (ret) {
> +			pr_warn("%s: can't set up gpio\n", __func__);
> +			return ret;
> +		}
> +	}
> +
>  	rfkill->pdata = pdata;
>  
>  	len = strlen(pdata->name);

Acked-by Rhyland Klein <rklein@nvidia.com>

