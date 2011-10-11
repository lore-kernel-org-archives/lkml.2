Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415Ab1JKLRK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 07:17:10 -0400
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:51320 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751407Ab1JKLRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 07:17:09 -0400
Message-ID: <4E942581.2050903@ru.mvista.com>
Date: Tue, 11 Oct 2011 15:16:17 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: vinod.koul@intel.com, linux-arm-kernel@lists.infradead.org,
        robherring2@gmail.com, devicetree-discuss@lists.ozlabs.org,
        grant.likely@secretlab.ca, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 4/4] ARM: at91/dma: DMA controller registering with
 DT support
References: <e292fbb24a98b7cfda8ea83364956a50e1cb120f.1318264339.git.nicolas.ferre@atmel.com> <1318265021-4562-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <1318265021-4562-1-git-send-email-nicolas.ferre@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 10-10-2011 20:43, Nicolas Ferre wrote:

> Device tree support on at91sam9g45 family SoC. Only call
> platform_device_register() if no compatible dma-controller
> node is found in device tree.

> Signed-off-by: Nicolas Ferre<nicolas.ferre@atmel.com>
> ---
> V2: use compatible string to match device.

[...]

> diff --git a/arch/arm/mach-at91/at91sam9g45_devices.c b/arch/arm/mach-at91/at91sam9g45_devices.c
> index 9390ae6..2120055 100644
> --- a/arch/arm/mach-at91/at91sam9g45_devices.c
> +++ b/arch/arm/mach-at91/at91sam9g45_devices.c
> @@ -64,7 +64,13 @@ static struct platform_device at_hdmac_device = {
>
>   void __init at91_add_device_hdmac(void)
>   {
> -	platform_device_register(&at_hdmac_device);
> +	struct device_node *np = of_find_node_by_name(NULL, "dma-controller");
> +
> +	if (np&&  of_device_is_compatible(np, "atmel,at91sam9g45-dma")) {
> +		of_node_put(np);
> +	} else {
> +		platform_device_register(&at_hdmac_device);
> +	}

    {} not needed here, and checkpatch.pl should have protested.

WBR, Sergei

