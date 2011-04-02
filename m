Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757424Ab1DBXgH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 19:36:07 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:62621 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756413Ab1DBXgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 19:36:06 -0400
Message-ID: <4D97B307.8070200@metafoo.de>
Date: Sun, 03 Apr 2011 01:36:39 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110307 Icedove/3.0.11
MIME-Version: 1.0
To: Benson Leung <bleung@chromium.org>
CC: cbouatmailru@gmail.com, rklein@nvidia.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpio-charger: Add gpio_charger_resume
References: <1301786184-19603-1-git-send-email-bleung@chromium.org>
In-Reply-To: <1301786184-19603-1-git-send-email-bleung@chromium.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2011 01:16 AM, Benson Leung wrote:
> Gpio charger should notify if the gpio state had changed
> during suspend. This will send a CHANGED event each time
> the system resumes, ensuring a plug/unplug of the charger
> is not missed.
> 
> Signed-off-by: Benson Leung <bleung@chromium.org>

Seems reasonable, but please use dev_pm_ops.

- Lars

> ---
>  drivers/power/gpio-charger.c |   17 +++++++++++++++++
>  1 files changed, 17 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/power/gpio-charger.c b/drivers/power/gpio-charger.c
> index 25b88ac..e83c892 100644
> --- a/drivers/power/gpio-charger.c
> +++ b/drivers/power/gpio-charger.c
> @@ -161,9 +161,26 @@ static int __devexit gpio_charger_remove(struct platform_device *pdev)
>  	return 0;
>  }
>  
> +#if defined CONFIG_PM
> +static int gpio_charger_resume(struct platform_device *pdev)
> +{
> +	struct gpio_charger *gpio_charger = platform_get_drvdata(pdev);
> +
> +	power_supply_changed(&gpio_charger->charger);
> +
> +	return 0;
> +}
> +#else
> +#define gpio_charger_resume	NULL
> +#endif
> +#define gpio_charger_suspend	NULL
> +
> +
>  static struct platform_driver gpio_charger_driver = {
>  	.probe = gpio_charger_probe,
>  	.remove = __devexit_p(gpio_charger_remove),
> +	.suspend = gpio_charger_suspend,
> +	.resume = gpio_charger_resume,
>  	.driver = {
>  		.name = "gpio-charger",
>  		.owner = THIS_MODULE,

