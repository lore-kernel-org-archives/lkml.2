Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab1LMJwx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 04:52:53 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:51714 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873Ab1LMJwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 04:52:51 -0500
X-Auth-Info: fkEuGlblzUFAXcfYeZk9aVr8QraJPR41VG9IWYpauJw=
Date: Tue, 13 Dec 2011 10:52:43 +0100
From: Anatolij Gustschin <agust@denx.de>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: Re: [PATCH RESEND] gpio: mpc8xxx: don't allow input-only pins to be
 output for MPC5121
Message-ID: <20111213105243.101ced70@wker>
In-Reply-To: <1323767568-9565-1-git-send-email-w.sang@pengutronix.de>
References: <1323767568-9565-1-git-send-email-w.sang@pengutronix.de>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram,

Looks mostly good to me. Please see minor comments below.

On Tue, 13 Dec 2011 10:12:48 +0100
Wolfram Sang <w.sang@pengutronix.de> wrote:
...
> diff --git a/drivers/gpio/gpio-mpc8xxx.c b/drivers/gpio/gpio-mpc8xxx.c
> index ec3fcf0..25dc736 100644
> --- a/drivers/gpio/gpio-mpc8xxx.c
> +++ b/drivers/gpio/gpio-mpc8xxx.c
> @@ -115,6 +115,14 @@ static int mpc8xxx_gpio_dir_in(struct gpio_chip *gc, unsigned int gpio)
>  	return 0;
>  }
>  
> +static int mpc5121_gpio_dir_out(struct gpio_chip *gc, unsigned int gpio, int val)

Line over 80 chars.

> +{
> +	/* GPIO 28..31 are input only on MPC5121 */
> +	if (gpio >= 28)
> +		return -EINVAL;
> +
> +	return mpc8xxx_gpio_dir_out(gc, gpio, val);
> +}
>  static int mpc8xxx_gpio_dir_out(struct gpio_chip *gc, unsigned int gpio, int val)

Please separate by an empty line. Thanks.

Anatolij
