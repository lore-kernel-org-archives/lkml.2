Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751400Ab2I3Qre (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 12:47:34 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:58158 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab2I3Qrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 12:47:31 -0400
Message-ID: <5068779A.20402@mvista.com>
Date: Sun, 30 Sep 2012 18:47:22 +0200
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        gregkh@linuxfoundation.org, balbi@ti.com
Subject: Re: [PATCH 6/6] usb: dwc3: core: add dt support for dwc3 core
References: <1348836795-4783-1-git-send-email-kishon@ti.com> <1348836795-4783-7-git-send-email-kishon@ti.com>
In-Reply-To: <1348836795-4783-7-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 28-09-2012 14:53, Kishon Vijay Abraham I wrote:

> Added dwc3 support for dwc3 core and update the documentation with
> device tree binding information.
>
> Signed-off-by: Kishon Vijay Abraham I<kishon@ti.com>
[...]

> diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
> index 08a5738..0c17a7a 100644
> --- a/drivers/usb/dwc3/core.c
> +++ b/drivers/usb/dwc3/core.c
[...]
> @@ -602,11 +601,22 @@ static int __devexit dwc3_remove(struct platform_device *pdev)
>   	return 0;
>   }
>
> +#ifdef CONFIG_OF
> +static const struct of_device_id of_dwc3_matach[] = {

     I guess you meant 'of_dwc3_match' here and below?


> +	{
> +		.compatible = "synopsis,dwc3"
> +	},
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(of, of_dwc3_matach);
> +#endif
> +
>   static struct platform_driver dwc3_driver = {
>   	.probe		= dwc3_probe,
>   	.remove		= __devexit_p(dwc3_remove),
>   	.driver		= {
>   		.name	= "dwc3",
> +		.of_match_table	= of_match_ptr(of_dwc3_matach),
>   	},
>   };
>   

WBR, Sergei

