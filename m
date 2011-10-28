Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932882Ab1J1Mi4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 08:38:56 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:2503 "EHLO sjogate2.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932687Ab1J1Mix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 08:38:53 -0400
Message-ID: <4EAAA231.1020601@atmel.com>
Date: Fri, 28 Oct 2011 14:38:09 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Sven Schnelle <svens@stackframe.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org,
        Rob Herring <robherring2@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
CC: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty/serial: atmel_serial: fix compilation
References: <1319801631-14654-1-git-send-email-svens@stackframe.org>
In-Reply-To: <1319801631-14654-1-git-send-email-svens@stackframe.org>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2011 01:33 PM, Sven Schnelle :
> If CONFIG_OF is disabled, compilation fails with:
> 
> drivers/tty/serial/atmel_serial.c: In function 'atmel_serial_probe':
> drivers/tty/serial/atmel_serial.c:1788: error: implicit declaration of function 'of_alias_get_id'
> 
> Fix this by adding the proper CONFIG_OF checks.

Yes, but I would like to avoid this and I have made a patch to address
this issue. I have sent it to the device tree guys yesterday:
"[PATCH] dt: add empty of_alias_get_id() for non-dt builds"

Maybe we can wait a little and see if it reaches Linus' tree on time. If
it is not, I will make sure that such a fix make it to mainline.

Best regards,

> Signed-off-by: Sven Schnelle <svens@stackframe.org>
> ---
>  drivers/tty/serial/atmel_serial.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
> index 4a0f86f..de338dd 100644
> --- a/drivers/tty/serial/atmel_serial.c
> +++ b/drivers/tty/serial/atmel_serial.c
> @@ -1777,16 +1777,20 @@ static int atmel_serial_resume(struct platform_device *pdev)
>  static int __devinit atmel_serial_probe(struct platform_device *pdev)
>  {
>  	struct atmel_uart_port *port;
> +#ifdef CONFIG_OF
>  	struct device_node *np = pdev->dev.of_node;
> +#endif
>  	struct atmel_uart_data *pdata = pdev->dev.platform_data;
>  	void *data;
>  	int ret = -ENODEV;
>  
>  	BUILD_BUG_ON(ATMEL_SERIAL_RINGSIZE & (ATMEL_SERIAL_RINGSIZE - 1));
>  
> +#ifdef CONFIG_OF
>  	if (np)
>  		ret = of_alias_get_id(np, "serial");
>  	else
> +#endif
>  		if (pdata)
>  			ret = pdata->num;
>  


-- 
Nicolas Ferre
