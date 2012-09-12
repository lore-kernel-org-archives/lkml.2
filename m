Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761076Ab2ILSLH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 14:11:07 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:50800 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753508Ab2ILSLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 14:11:04 -0400
Message-ID: <5050D034.7030203@wwwdotorg.org>
Date: Wed, 12 Sep 2012 12:11:00 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: balbi@ti.com, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] usb: host: tegra: code clean up
References: <1347433362-4669-1-git-send-email-vbyravarasu@nvidia.com>
In-Reply-To: <1347433362-4669-1-git-send-email-vbyravarasu@nvidia.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2012 01:02 AM, Venu Byravarasu wrote:
> As part of code clean up, used devm counterparts for the APIs
> possible.

Almost all of this patch has already been applied as:

bc2ff98 drivers/usb/host/ehci-tegra.c: use devm_ functions

(btw, that patch has a much better patch subject than this one)

The only additions in your patch are shown below, and those changes
should indeed be a separate patch.

> diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-tegra.c
> index 6223d17..dba9f07 100644
> --- a/drivers/usb/host/ehci-tegra.c
> +++ b/drivers/usb/host/ehci-tegra.c
> @@ -701,7 +701,7 @@ static int tegra_ehci_probe(struct platform_device *pdev)
>                         break;
>                 default:
>                         err = -ENODEV;
> -                       dev_err(&pdev->dev, "unknown usb instance\n");
> +                       dev_err(&pdev->dev, "unknown usb inst:%d\n", instance);
>                         goto fail_io;
>                 }
>         }
> @@ -744,7 +744,7 @@ static int tegra_ehci_probe(struct platform_device *pdev)
>  
>         err = usb_add_hcd(hcd, irq, IRQF_SHARED);
>         if (err) {
> -               dev_err(&pdev->dev, "Failed to add USB HCD\n");
> +               dev_err(&pdev->dev, "usb_add_hcd failed with err 0x%x\n", err);
>                 goto fail;
>         }
>  
> @@ -753,7 +753,7 @@ static int tegra_ehci_probe(struct platform_device *pdev)
>  
>         /* Don't skip the pm_runtime_forbid call if wakeup isn't working */
>         /* if (!pdata->power_down_on_bus_suspend) */
> -               pm_runtime_forbid(&pdev->dev);
> +       pm_runtime_forbid(&pdev->dev);
>         pm_runtime_enable(&pdev->dev);
>         pm_runtime_put_sync(&pdev->dev);
>         return err;

I'm not sure that last change is worth making; hopefully, you'll fix the
bug the causes the "if" to be commented out, and we can re-enabled it
again. Removing the indent makes it much less obvious which lines of
code the "if" was intended to cover.
