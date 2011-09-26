Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821Ab1IZO3d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 10:29:33 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:37180 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315Ab1IZO3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 10:29:32 -0400
Subject: Re: [PATCH] net:rfkill: add a gpio setup function into GPIO rfkill
From: Johannes Berg <johannes@sipsolutions.net>
To: Sangwook Lee <sangwook.lee@linaro.org>
Cc: Rhyland Klein <rklein@nvidia.com>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1317046972-18570-1-git-send-email-sangwook.lee@linaro.org> (sfid-20110926_162515_088596_55377D64)
References: <1317046972-18570-1-git-send-email-sangwook.lee@linaro.org>
	 (sfid-20110926_162515_088596_55377D64)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Sep 2011 16:29:24 +0200
Message-ID: <1317047364.11511.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-09-26 at 15:22 +0100, Sangwook Lee wrote:
> Add a gpio setup function which gives a chance to set up
> platform specific configuration such as pin multiplexing,
> input/output direction at the runtime or booting time.
> 
> Signed-off-by: Sangwook Lee <sangwook.lee@linaro.org>
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
> index 256c5dd..d6cec90 100644
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
> +			return -EINVAL;

Wouldn't you want to return ret?

johannes

