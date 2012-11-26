Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676Ab2KZJ3N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 04:29:13 -0500
Received: from mail.free-electrons.com ([88.190.12.23]:47863 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520Ab2KZJ3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 04:29:12 -0500
Date: Mon, 26 Nov 2012 10:28:58 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Philippe Reynes <tremyfr@yahoo.fr>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        s.hauer@pengutronix.de, eric.jarrige@armadeus.org,
        julien.boibessot@armadeus.com
Subject: Re: [PATCH 3/4] imx27-dt: configure i2c1 gpio on armadeus apf27
Message-ID: <20121126102858.4ba818b0@skate>
In-Reply-To: <1353874625-14754-4-git-send-email-tremyfr@yahoo.fr>
References: <1353874625-14754-1-git-send-email-tremyfr@yahoo.fr>
	<1353874625-14754-4-git-send-email-tremyfr@yahoo.fr>
Organization: Free Electrons
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Philippe Reynes,

On Sun, 25 Nov 2012 21:17:04 +0100, Philippe Reynes wrote:

>  static const struct of_dev_auxdata imx27_auxdata_lookup[] __initconst = {
> @@ -48,6 +49,10 @@ int apf27_lan8700_wakeup(struct phy_device *phydev)
>  static void __init apf27_init(void)
>  {
>  	phy_register_fixup_for_id("imx27-fec.0-1:1f", apf27_lan8700_wakeup);
> +
> +	/* configure i2c1 gpio */
> +	mxc_gpio_mode((GPIO_PORTD | GPIO_OUT | GPIO_PF | 17));
> +	mxc_gpio_mode((GPIO_PORTD | GPIO_OUT | GPIO_PF | 18));
>  }

I haven't followed i.MX 27 support lately, but this surely should be
done using a pinctrl driver. I see that there is a general pinctrl
driver for i.MX, but a drivers/pinctrl/pinctrl-imx27.c might be
missing. It would probably be a better idea to implement the missing
pinctrl driver, if not already available?

Best regards,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
