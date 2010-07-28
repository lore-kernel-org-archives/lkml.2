Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886Ab0G1TJI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 15:09:08 -0400
Received: from server78.greatnet.de ([83.133.96.102]:44620 "EHLO
	server78.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173Ab0G1TJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 15:09:05 -0400
X-Greylist: delayed 408 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Jul 2010 15:09:05 EDT
Message-ID: <4C507EB0.8050208@nachtwindheim.de>
Date: Wed, 28 Jul 2010 21:02:08 +0200
From: Henrik Kretzschmar <henne@nachtwindheim.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100619 Icedove/3.0.5
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Peter_H=FCwe?= <PeterHuewe@gmx.de>
CC: =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jaya Kumar <jayakumar.lkml@gmail.com>, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Kernel Janitors <kernel-janitors@vger.kernel.org>,
        Jiri Kosina <trivial@kernel.org>
Subject: Re: [PATCH] video/w100fb: ignore void return value / fix build failure
References: <201007282029.52989.PeterHuewe@gmx.de>
In-Reply-To: <201007282029.52989.PeterHuewe@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 28.07.2010 20:29, schrieb Peter Hüwe:
> From: Peter Huewe <peterhuewe@gmx.de>
> 
> This patch fixes a build failure [1] (error: void value not ignored as
> it ought to be) by removing an assignment of a void return value.
> The functionality of the code is not changed.
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
Ached-by: Henrik Kretzschmar <henne@nachtwindheim.de>
> ---
> KernelVersion: linux-next-20100728
> References:
> [1] http://kisskb.ellerman.id.au/kisskb/buildresult/2980912/
> 
>  drivers/video/w100fb.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/video/w100fb.c b/drivers/video/w100fb.c
> index e66b8b1..d8b12c3 100644
> --- a/drivers/video/w100fb.c
> +++ b/drivers/video/w100fb.c
> @@ -858,9 +858,9 @@ unsigned long w100fb_gpio_read(int port)
>  void w100fb_gpio_write(int port, unsigned long value)
>  {
>  	if (port==W100_GPIO_PORT_A)
> -		value = writel(value, remapped_regs + mmGPIO_DATA);
> +		writel(value, remapped_regs + mmGPIO_DATA);
>  	else
> -		value = writel(value, remapped_regs + mmGPIO_DATA2);
> +		writel(value, remapped_regs + mmGPIO_DATA2);
>  }
>  EXPORT_SYMBOL(w100fb_gpio_read);
>  EXPORT_SYMBOL(w100fb_gpio_write);

