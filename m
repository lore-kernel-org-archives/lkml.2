Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984Ab1K1HUP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 02:20:15 -0500
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:44056 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751288Ab1K1HUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 02:20:13 -0500
Subject: Re: [PATCH 10/11] wireless: Remove redundant spi driver bus
 initialization
From: Luciano Coelho <coelho@ti.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-kernel@vger.kernel.org, Dan Williams <dcbw@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Christian Lamparter <chunkeey@googlemail.com>,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
In-Reply-To: <1322148561-25138-10-git-send-email-lars@metafoo.de>
References: <1322148561-25138-1-git-send-email-lars@metafoo.de>
	 <1322148561-25138-10-git-send-email-lars@metafoo.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Nov 2011 09:20:07 +0200
Message-ID: <1322464807.6502.11.camel@cumari>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-24 at 16:29 +0100, Lars-Peter Clausen wrote: 
> In ancient times it was necessary to manually initialize the bus field of an
> spi_driver to spi_bus_type. These days this is done in spi_driver_register(),
> so we can drop the manual assignment.
> 
> The patch was generated using the following coccinelle semantic patch:
> // <smpl>
> @@
> identifier _driver;
> @@
> struct spi_driver _driver = {
> 	.driver = {
> -		.bus = &spi_bus_type,
> 	},
> };
> // </smpl>
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> Cc: Dan Williams <dcbw@redhat.com>
> Cc: "John W. Linville" <linville@tuxdriver.com>
> Cc: Christian Lamparter <chunkeey@googlemail.com>
> Cc: Luciano Coelho <coelho@ti.com>
> Cc: libertas-dev@lists.infradead.org
> Cc: linux-wireless@vger.kernel.org
> ---

[...]

> diff --git a/drivers/net/wireless/wl1251/spi.c b/drivers/net/wireless/wl1251/spi.c
> index eaa5f95..6248c35 100644
> --- a/drivers/net/wireless/wl1251/spi.c
> +++ b/drivers/net/wireless/wl1251/spi.c
> @@ -319,7 +319,6 @@ static int __devexit wl1251_spi_remove(struct spi_device *spi)
>  static struct spi_driver wl1251_spi_driver = {
>  	.driver = {
>  		.name		= DRIVER_NAME,
> -		.bus		= &spi_bus_type,
>  		.owner		= THIS_MODULE,
>  	},
>  
> diff --git a/drivers/net/wireless/wl12xx/spi.c b/drivers/net/wireless/wl12xx/spi.c
> index 0f97186..12421a6 100644
> --- a/drivers/net/wireless/wl12xx/spi.c
> +++ b/drivers/net/wireless/wl12xx/spi.c
> @@ -462,7 +462,6 @@ static int __devexit wl1271_remove(struct spi_device *spi)
>  static struct spi_driver wl1271_spi_driver = {
>  	.driver = {
>  		.name		= "wl1271_spi",
> -		.bus		= &spi_bus_type,
>  		.owner		= THIS_MODULE,
>  	},

For the wl12xx and wl1251 parts:

Acked-by: Luciano Coelho <coelho@ti.com>


-- 
Cheers,
Luca.

