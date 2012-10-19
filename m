Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758233Ab2JSJU2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 05:20:28 -0400
Received: from smtp-out-125.synserver.de ([212.40.185.125]:1103 "EHLO
	smtp-out-125.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755542Ab2JSJU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 05:20:26 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 29443
Message-ID: <50811BA5.8000004@metafoo.de>
Date: Fri, 19 Oct 2012 11:21:41 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.7) Gecko/20120922 Icedove/10.0.7
MIME-Version: 1.0
To: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
CC: cbou@mail.ru, dwmw2@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] Use devm_kzalloc instead of kzalloc/kfree
References: <1350603664-18148-1-git-send-email-marcos.souza.org@gmail.com> <1350603664-18148-2-git-send-email-marcos.souza.org@gmail.com>
In-Reply-To: <1350603664-18148-2-git-send-email-marcos.souza.org@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2012 01:41 AM, Marcos Paulo de Souza wrote:
> This does not chnange the rationale, just a cleanup
> 
> Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>

Thanks,

Acked-by: Lars-Peter Clausen <lars@metafoo.de?

> ---
>  drivers/power/jz4740-battery.c |   12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/power/jz4740-battery.c b/drivers/power/jz4740-battery.c
> index 8dbc7bf..72f6335 100644
> --- a/drivers/power/jz4740-battery.c
> +++ b/drivers/power/jz4740-battery.c
> @@ -252,7 +252,7 @@ static int __devinit jz_battery_probe(struct platform_device *pdev)
>  		return -ENXIO;
>  	}
>  
> -	jz_battery = kzalloc(sizeof(*jz_battery), GFP_KERNEL);
> +	jz_battery = devm_kzalloc(&pdev->dev, sizeof(*jz_battery), GFP_KERNEL);
>  	if (!jz_battery) {
>  		dev_err(&pdev->dev, "Failed to allocate driver structure\n");
>  		return -ENOMEM;
> @@ -264,14 +264,14 @@ static int __devinit jz_battery_probe(struct platform_device *pdev)
>  	if (jz_battery->irq < 0) {
>  		ret = jz_battery->irq;
>  		dev_err(&pdev->dev, "Failed to get platform irq: %d\n", ret);
> -		goto err_free;
> +		goto err;
>  	}
>  
>  	jz_battery->mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	if (!jz_battery->mem) {
>  		ret = -ENOENT;
>  		dev_err(&pdev->dev, "Failed to get platform mmio resource\n");
> -		goto err_free;
> +		goto err;
>  	}
>  
>  	jz_battery->mem = request_mem_region(jz_battery->mem->start,
> @@ -279,7 +279,7 @@ static int __devinit jz_battery_probe(struct platform_device *pdev)
>  	if (!jz_battery->mem) {
>  		ret = -EBUSY;
>  		dev_err(&pdev->dev, "Failed to request mmio memory region\n");
> -		goto err_free;
> +		goto err;
>  	}
>  
>  	jz_battery->base = ioremap_nocache(jz_battery->mem->start,
> @@ -373,8 +373,7 @@ err_iounmap:
>  	iounmap(jz_battery->base);
>  err_release_mem_region:
>  	release_mem_region(jz_battery->mem->start, resource_size(jz_battery->mem));
> -err_free:
> -	kfree(jz_battery);
> +err:
>  	return ret;
>  }
>  
> @@ -396,7 +395,6 @@ static int __devexit jz_battery_remove(struct platform_device *pdev)
>  
>  	iounmap(jz_battery->base);
>  	release_mem_region(jz_battery->mem->start, resource_size(jz_battery->mem));
> -	kfree(jz_battery);
>  
>  	return 0;
>  }

