Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734Ab0IWXkt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 19:40:49 -0400
Received: from dsl78-143-211-26.in-addr.fast.co.uk ([78.143.211.26]:46062 "EHLO
	ben-laptop" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756390Ab0IWXkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 19:40:47 -0400
Message-ID: <4C9BE577.4050504@fluff.org>
Date: Fri, 24 Sep 2010 00:40:39 +0100
From: Ben Dooks <ben-linux@fluff.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100915 Thunderbird/3.0.8
MIME-Version: 1.0
To: Darius Augulis <augulis.darius@gmail.com>
CC: linux-arm-kernel@lists.infradead.org, kgene.kim@samsung.com,
        ben-linux@fluff.org, linux-kernel@vger.kernel.org,
        paulius.zaleckas@gmail.com, linux-serial@vger.kernel.org
Subject: Re: [RESEND PATCH] serial: samsung: fix device name
References: <20100923190212.18863.25678.stgit@darius-desktop>
In-Reply-To: <20100923190212.18863.25678.stgit@darius-desktop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/09/10 20:15, Darius Augulis wrote:
> Swap device and driver names in serial/samsung.c

This is far too short, please see the notes below on trying
to make this more informative.

> Signed-off-by: Darius Augulis <augulis.darius@gmail.com>
> ---
> 
> This patch was submitted about 3 months ago, but still not merged.
> There was another similar patch from Joonyoung Shim
> <jy0922.shim@samsung.com> and was discussed here:
> http://marc.info/?l=linux-serial&m=127416101222281&w=2.
> Joonyoung Shim acked my patch and other people on ARM mailing list
> acked it. The maintainer, Ben Dooks, still not responding for
> a long time. Another maintainer, Kukjin Kim, refused to merge
> it without Ben's review.
> I would like to ask somebody pick up this bugfix.

I belive last time this was brought up I asked about the affect
this has on the userspace. The following issues would be helpful
or essential to have noted in the header about the effect of this.

- Does it change the /dev name of the device? if so I would thinl
  carefully about applying it, as it would be a change in the way
  that userspace sees the kernel.

- Does it change the kernel output itself? A note on what diffeences
  can be seen in things like dmesg would be helpful.

- Are there any other side effects

- Why is this a bug? Maybe the previous points will explain what is
  going on, but if not, then a reasonably concise description of
  what is going on here.

>  drivers/serial/samsung.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/serial/samsung.c b/drivers/serial/samsung.c
> index b1156ba..25c0d0f 100644
> --- a/drivers/serial/samsung.c
> +++ b/drivers/serial/samsung.c
> @@ -883,10 +883,10 @@ static struct uart_ops s3c24xx_serial_ops = {
>  
>  static struct uart_driver s3c24xx_uart_drv = {
>  	.owner		= THIS_MODULE,
> -	.dev_name	= "s3c2410_serial",
> +	.driver_name    = "s3c2410_serial",
>  	.nr		= CONFIG_SERIAL_SAMSUNG_UARTS,
>  	.cons		= S3C24XX_SERIAL_CONSOLE,
> -	.driver_name	= S3C24XX_SERIAL_NAME,
> +	.dev_name       = S3C24XX_SERIAL_NAME,
>  	.major		= S3C24XX_SERIAL_MAJOR,
>  	.minor		= S3C24XX_SERIAL_MINOR,
>  };
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

