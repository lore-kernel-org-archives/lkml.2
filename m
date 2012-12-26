Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018Ab2LZTTA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 14:19:00 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:58804 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501Ab2LZTS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 14:18:57 -0500
Message-ID: <50DB5B80.50801@mvista.com>
Date: Wed, 26 Dec 2012 23:18:08 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Dongjin Kim <tobetter@gmail.com>
CC: linux-samsung-soc@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] USB: ehci-s5p: Add to get interrupt from DT
References: <1356547341-23620-1-git-send-email-tobetter@gmail.com> <1356547341-23620-3-git-send-email-tobetter@gmail.com>
In-Reply-To: <1356547341-23620-3-git-send-email-tobetter@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 12/26/2012 09:42 PM, Dongjin Kim wrote:

> This patch support to get interrupt resource from device tree as well as
> platform device if ehci node is defined in device tree and it's irq is
> described.

> Signed-off-by: Dongjin Kim <tobetter@gmail.com>
> ---
>  drivers/usb/host/ehci-s5p.c |    8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)

> diff --git a/drivers/usb/host/ehci-s5p.c b/drivers/usb/host/ehci-s5p.c
> index 319dcfa..0fc5e5e 100644
> --- a/drivers/usb/host/ehci-s5p.c
> +++ b/drivers/usb/host/ehci-s5p.c
> @@ -16,6 +16,7 @@
>  #include <linux/of.h>
>  #include <linux/platform_device.h>
>  #include <linux/of_gpio.h>
> +#include <linux/of_irq.h>
>  #include <linux/platform_data/usb-ehci-s5p.h>
>  #include <plat/usb-phy.h>
>  
> @@ -156,7 +157,12 @@ static int s5p_ehci_probe(struct platform_device *pdev)
>  		goto fail_io;
>  	}
>  
> -	irq = platform_get_irq(pdev, 0);
> +	if (pdev->dev.of_node)
> +		irq = irq_of_parse_and_map(pdev->dev.of_node, 0);

   platform_get_irq() should still work for device tree based platform devices.
I don't see the point on the patch?

> +	else {
> +		irq = platform_get_irq(pdev, 0);
> +	}

   Hm, why {} out of the blue? Both arms of *if* are single-stratement.

> +

   No need for empty line here.

>  	if (!irq) {
>  		dev_err(&pdev->dev, "Failed to get IRQ\n");
>  		err = -ENODEV;

WBR, Sergei

