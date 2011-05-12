Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452Ab1ELIqt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 04:46:49 -0400
Received: from hull.simtec.co.uk ([78.105.113.97]:38938 "EHLO
	preston.local.simtec.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752552Ab1ELIqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 04:46:47 -0400
X-Greylist: delayed 1304 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 May 2011 04:46:47 EDT
Message-ID: <4DCB9985.2050100@simtec.co.uk>
Date: Thu, 12 May 2011 09:25:41 +0100
From: Ben Dooks <ben@simtec.co.uk>
Organization: Simtec Electronics, UK
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH] spi: tle620x: add missing device_remove_file()
References: <1305117545.6324.3.camel@phoenix>
In-Reply-To: <1305117545.6324.3.camel@phoenix>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/11 13:39, Axel Lin wrote:
> This patch includes below fixes:
> 1. Add missing device_remove_file for dev_attr_status_show in tle62x0_remove.
> 2. Fix tle62x0_probe error handling:
>     Currently, if the error happens when ptr>  0, gpio_attrs[0] is not
>     properly remove.
>
> Signed-off-by: Axel Lin<axel.lin@gmail.com>
Acked-by: Ben Dooks <ben-linux@fluff.org>
> ---
>   drivers/spi/tle62x0.c |    3 ++-
>   1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/spi/tle62x0.c b/drivers/spi/tle62x0.c
> index a393895..32a4087 100644
> --- a/drivers/spi/tle62x0.c
> +++ b/drivers/spi/tle62x0.c
> @@ -283,7 +283,7 @@ static int __devinit tle62x0_probe(struct spi_device *spi)
>   	return 0;
>
>    err_gpios:
> -	for (; ptr>  0; ptr--)
> +	while (--ptr>= 0)
>   		device_remove_file(&spi->dev, gpio_attrs[ptr]);
>
>   	device_remove_file(&spi->dev,&dev_attr_status_show);
> @@ -301,6 +301,7 @@ static int __devexit tle62x0_remove(struct spi_device *spi)
>   	for (ptr = 0; ptr<  st->nr_gpio; ptr++)
>   		device_remove_file(&spi->dev, gpio_attrs[ptr]);
>
> +	device_remove_file(&spi->dev,&dev_attr_status_show);
>   	kfree(st);
>   	return 0;
>   }

