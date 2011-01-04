Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751514Ab1ADX7u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 18:59:50 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43103 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750892Ab1ADX7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 18:59:49 -0500
Date: Tue, 4 Jan 2011 15:59:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alberto Panizzo <maramaopercheseimorto@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, Marek Vasut <marek.vasut@gmail.com>,
        Tejun Heo <tj@kernel.org>, Axel Lin <axel.lin@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] backlight: l4f00242t03: Fix reset sequence
Message-Id: <20110104155920.1aafcf0c.akpm@linux-foundation.org>
In-Reply-To: <1290964433.3016.2.camel@realization>
References: <1290964433.3016.2.camel@realization>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Nov 2010 18:13:53 +0100
Alberto Panizzo <maramaopercheseimorto@gmail.com> wrote:

> The reset command is part of the init sequence and it take effect
> only if the lcd is powered.
> 
> Signed-off-by: Alberto Panizzo <maramaopercheseimorto@gmail.com>
> ---
> 
> This patch is built on top of:
> http://userweb.kernel.org/~akpm/mmotm/broken-out/drivers-video-backlight-l4f00242t03c-full-implement-fb-power-states-for-this-lcd.patch
> 
>  drivers/video/backlight/l4f00242t03.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/video/backlight/l4f00242t03.c b/drivers/video/backlight/l4f00242t03.c
> index 5d25743..c04aa90 100644
> --- a/drivers/video/backlight/l4f00242t03.c
> +++ b/drivers/video/backlight/l4f00242t03.c
> @@ -62,6 +62,8 @@ static void l4f00242t03_lcd_init(struct spi_device *spi)
>  		regulator_enable(priv->core_reg);
>  	}
>  
> +	l4f00242t03_reset(pdata->reset_gpio);
> +
>  	gpio_set_value(pdata->data_enable_gpio, 1);
>  	msleep(60);
>  	spi_write(spi, (const u8 *)cmd, ARRAY_SIZE(cmd) * sizeof(u16));
> @@ -225,7 +227,6 @@ static int __devinit l4f00242t03_probe(struct spi_device *spi)
>  	}
>  
>  	/* Init the LCD */
> -	l4f00242t03_reset(pdata->reset_gpio);
>  	l4f00242t03_lcd_init(spi);
>  	priv->lcd_state = FB_BLANK_VSYNC_SUSPEND;
>  	l4f00242t03_lcd_power_set(priv->ld, FB_BLANK_UNBLANK);

What were the user-visible effects of the bug which you just fixed?

Please always include this info when sending a bugfix!  Because without
that info it's much harder to work out whether we should backport the
fix into earlier kernels and it's harder for end-users and distro
maintainers to work out if the patch will fix particular behaviour
which they or their customers are seeing.

