Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab1ECTlp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 15:41:45 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48394 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754699Ab1ECTlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 15:41:31 -0400
Date: Tue, 3 May 2011 13:41:27 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org, linux@arm.linux.org.uk, tglx@linutronix.de,
        cbouatmailru@gmail.com, arnd@arndb.de, nico@fluxnic.net
Subject: Re: [PATCHv3 2/7] basic_mmio_gpio: convert to
 platform_{get,set}_drvdata()
Message-ID: <20110503194127.GB9401@ponder.secretlab.ca>
References: <1302520914-22816-1-git-send-email-jamie@jamieiles.com>
 <1302520914-22816-3-git-send-email-jamie@jamieiles.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302520914-22816-3-git-send-email-jamie@jamieiles.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 11, 2011 at 12:21:49PM +0100, Jamie Iles wrote:
> Use the platform drvdata helpers rather than working on the struct
> device itself.
> 
> Signed-off-by: Jamie Iles <jamie@jamieiles.com>
> Acked-by: Anton Vorontsov <cbouatmailru@gmail.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>

Merged, thanks.

g.

> ---
>  drivers/gpio/basic_mmio_gpio.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpio/basic_mmio_gpio.c b/drivers/gpio/basic_mmio_gpio.c
> index e935a24..5db5de4 100644
> --- a/drivers/gpio/basic_mmio_gpio.c
> +++ b/drivers/gpio/basic_mmio_gpio.c
> @@ -296,7 +296,7 @@ static int __devinit bgpio_probe(struct platform_device *pdev)
>  	else
>  		bgc->gc.base = -1;
>  
> -	dev_set_drvdata(dev, bgc);
> +	platform_set_drvdata(pdev, bgc);
>  
>  	ret = gpiochip_add(&bgc->gc);
>  	if (ret)
> @@ -307,7 +307,7 @@ static int __devinit bgpio_probe(struct platform_device *pdev)
>  
>  static int __devexit bgpio_remove(struct platform_device *pdev)
>  {
> -	struct bgpio_chip *bgc = dev_get_drvdata(&pdev->dev);
> +	struct bgpio_chip *bgc = platform_get_drvdata(pdev);
>  
>  	return gpiochip_remove(&bgc->gc);
>  }
> -- 
> 1.7.4.2
> 
