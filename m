Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577Ab1DGAPA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 20:15:00 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:54646 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755240Ab1DGAO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 20:14:59 -0400
Message-ID: <4D9D0227.3000807@metafoo.de>
Date: Thu, 07 Apr 2011 02:15:35 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110307 Icedove/3.0.11
MIME-Version: 1.0
To: Benson Leung <bleung@chromium.org>
CC: cbouatmailru@gmail.com, rklein@nvidia.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] gpio-charger: Add gpio_charger_resume
References: <1301796792-28806-1-git-send-email-bleung@chromium.org> <1302134120-29589-1-git-send-email-bleung@chromium.org>
In-Reply-To: <1302134120-29589-1-git-send-email-bleung@chromium.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2011 01:55 AM, Benson Leung wrote:
> Gpio charger should notify if the gpio state had changed
> during suspend. This will send a CHANGED event each time
> the system resumes, ensuring a plug/unplug of the charger
> is not missed.
> 
> Signed-off-by: Benson Leung <bleung@chromium.org>
Acked-By: Lars-Peter Clausen <lars@metafoo.de>

> 
> --
> Version history :
> v3 : Use SIMPLE_DEV_PM_OPS
> v2 : Changed to use dev_ms_ops
> v1 : Initial
> ---
>  drivers/power/gpio-charger.c |   15 +++++++++++++++
>  1 files changed, 15 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/power/gpio-charger.c b/drivers/power/gpio-charger.c
> index 25b88ac..718f2c5 100644
> --- a/drivers/power/gpio-charger.c
> +++ b/drivers/power/gpio-charger.c
> @@ -161,12 +161,27 @@ static int __devexit gpio_charger_remove(struct platform_device *pdev)
>  	return 0;
>  }
>  
> +#ifdef CONFIG_PM_SLEEP
> +static int gpio_charger_resume(struct device *dev)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct gpio_charger *gpio_charger = platform_get_drvdata(pdev);
> +
> +	power_supply_changed(&gpio_charger->charger);
> +
> +	return 0;
> +}
> +#endif
> +
> +static SIMPLE_DEV_PM_OPS(gpio_charger_pm_ops, NULL, gpio_charger_resume);
> +
>  static struct platform_driver gpio_charger_driver = {
>  	.probe = gpio_charger_probe,
>  	.remove = __devexit_p(gpio_charger_remove),
>  	.driver = {
>  		.name = "gpio-charger",
>  		.owner = THIS_MODULE,
> +		.pm = &gpio_charger_pm_ops,
>  	},
>  };
>  

