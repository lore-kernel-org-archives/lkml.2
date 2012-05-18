Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031155Ab2ERNvN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 09:51:13 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62550 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945988Ab2ERNvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 09:51:11 -0400
Date: Fri, 18 May 2012 21:51:07 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>
Cc: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>,
        Ryan Mallon <ryan@bluewatersys.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        "Hans J. Koch" <hjk@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] gpio/generic: initialize basic_mmio_gpio shadow
 variables properly
Message-ID: <20120518135104.GC5427@S2101-09.ap.freescale.net>
References: <1337240103-4756-1-git-send-email-shawn.guo@linaro.org>
 <1337240103-4756-2-git-send-email-shawn.guo@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337240103-4756-2-git-send-email-shawn.guo@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant, Linus,

Can we manage to get it in with the upcoming merge window, as it fixes
a bug that we may not want to live with for another cycle?

Regards,
Shawn

On Thu, May 17, 2012 at 03:35:02PM +0800, Shawn Guo wrote:
> It fixes the issue in gpio-generic that commit fb14921 (gpio/mxc: add
> missing initialization of basic_mmio_gpio shadow variables) manged to
> fix in gpio-mxc driver, so that other platform specific drivers do not
> suffer from the same problem over and over again.
> 
> Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
> ---
>  drivers/gpio/gpio-generic.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-generic.c b/drivers/gpio/gpio-generic.c
> index e38dd0c..cfc9439 100644
> --- a/drivers/gpio/gpio-generic.c
> +++ b/drivers/gpio/gpio-generic.c
> @@ -394,6 +394,10 @@ int bgpio_init(struct bgpio_chip *bgc, struct device *dev,
>  		return ret;
>  
>  	bgc->data = bgc->read_reg(bgc->reg_dat);
> +	if (bgc->gc.set == bgpio_set_set)
> +		bgc->data = bgc->read_reg(bgc->reg_set);
> +	if (bgc->reg_dir)
> +		bgc->dir = bgc->read_reg(bgc->reg_dir);
>  
>  	return ret;
>  }
> -- 
> 1.7.5.4
> 
