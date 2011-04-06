Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273Ab1DFJJD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 05:09:03 -0400
Received: from smtp-out.google.com ([216.239.44.51]:37196 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755186Ab1DFJJA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 05:09:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Ul9JsiOrKGpT26nTpgGe8wAp1e95BRv823VXwprTBxgK/0yUr2ZBwJ74N1K0jJ3noJ
         ZfxSzu3EX/0cMzSKbWzQ==
MIME-Version: 1.0
In-Reply-To: <1301796792-28806-1-git-send-email-bleung@chromium.org>
References: <1301796792-28806-1-git-send-email-bleung@chromium.org>
Date: Wed, 6 Apr 2011 02:08:58 -0700
X-Google-Sender-Auth: z23r_2G5fa96XodaJM717FfCzQI
Message-ID: <BANLkTinh-Chz7GzdHLqpSSzq4BzzwX5axw@mail.gmail.com>
Subject: Re: [PATCH v2] gpio-charger: Add gpio_charger_resume
From: Benson Leung <bleung@chromium.org>
To: lars@metafoo.de, cbouatmailru@gmail.com
Cc: rklein@nvidia.com, linux-kernel@vger.kernel.org,
        Benson Leung <bleung@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lars,

Please take another look.

Thanks,
Benson

On Sat, Apr 2, 2011 at 7:13 PM, Benson Leung <bleung@chromium.org> wrote:
> Gpio charger should notify if the gpio state had changed
> during suspend. This will send a CHANGED event each time
> the system resumes, ensuring a plug/unplug of the charger
> is not missed.
>
> Signed-off-by: Benson Leung <bleung@chromium.org>
>
> --
> Version history :
> v2 : Changed to use dev_pm_ops
> v1 : Initial
> ---
>  drivers/power/gpio-charger.c |   20 ++++++++++++++++++++
>  1 files changed, 20 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/power/gpio-charger.c b/drivers/power/gpio-charger.c
> index 25b88ac..df29059 100644
> --- a/drivers/power/gpio-charger.c
> +++ b/drivers/power/gpio-charger.c
> @@ -161,12 +161,32 @@ static int __devexit gpio_charger_remove(struct platform_device *pdev)
>        return 0;
>  }
>
> +#if defined(CONFIG_PM)
> +static int gpio_charger_resume(struct device *dev)
> +{
> +       struct platform_device *pdev = to_platform_device(dev);
> +       struct gpio_charger *gpio_charger = platform_get_drvdata(pdev);
> +
> +       power_supply_changed(&gpio_charger->charger);
> +
> +       return 0;
> +}
> +
> +static const struct dev_pm_ops gpio_charger_pm_ops = {
> +       .resume         = gpio_charger_resume,
> +};
> +#endif
> +
> +
>  static struct platform_driver gpio_charger_driver = {
>        .probe = gpio_charger_probe,
>        .remove = __devexit_p(gpio_charger_remove),
>        .driver = {
>                .name = "gpio-charger",
>                .owner = THIS_MODULE,
> +#if defined(CONFIG_PM)
> +               .pm = &gpio_charger_pm_ops,
> +#endif
>        },
>  };
>
> --
> 1.7.1
>
>



-- 
Benson Leung
Software Engineer, Chrom* OS
bleung@chromium.org
