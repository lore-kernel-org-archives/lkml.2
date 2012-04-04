Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141Ab2DDK1n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 06:27:43 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:52488 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755939Ab2DDK1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 06:27:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Roland Stigge <stigge@antcom.de>
Subject: Re: [PATCH v2] gpio: Device tree support for LPC32xx
Date: Wed, 4 Apr 2012 08:48:38 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: grant.likely@secretlab.ca, arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linus.walleij@stericsson.com
References: <1333497518-25838-1-git-send-email-stigge@antcom.de>
In-Reply-To: <1333497518-25838-1-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201204040848.39376.arnd@arndb.de>
X-Provags-ID: V02:K0:aigjimQBlK/Xoj/lsJm2TEqqir2T6EiMBRImDbdZxbP
 O9IUOsySLBm4jYUWTNOhfoxG/NAy9mZhMoWJqD/bdq194QhArV
 WqNzFs0/wi3W22eMtMEftxu2a0fxO+Pwm9Uuc16eSTMPKOXNDx
 oftlMP3pjUTOKj2lNBWx/OHOIV/QRFWuyi3Sz9hIctdf7qwBkZ
 XbI5m+CPiF4mowSF6wvzfDy5op2FRF7C7PkhiCcEE/pz482DDt
 WiHwimBCh/7P0tZ1w05v7ti2yKKDhDBvQFwBbiGo3RFLyClV4C
 DCxTcps4CTJB2D5TtIO7aA1VIzK713pVrIuvh68SaljG8HfmvC
 X6sPzqy11T7dCEEnUbFo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 April 2012, Roland Stigge wrote:
> This patch adds device tree support for gpio-lpc32xx.c
> 
> Signed-off-by: Roland Stigge <stigge@antcom.de>

Reviewed-by: Arnd Bergmann <arnd@arndb.de>

Just one more comment:

> +#ifdef CONFIG_OF
> +static struct of_device_id lpc32xx_gpio_of_match[] __devinitdata = {
> +	{ .compatible = "nxp,lpc32xx-gpio", },
> +	{ },
> +};
> +#endif
> +
> +static struct platform_driver lpc32xx_gpio_driver = {
> +	.driver		= {
> +		.name	= "lpc32xx-gpio",
> +		.owner	= THIS_MODULE,
> +		.of_match_table = lpc32xx_gpio_of_match,
> +	},
> +	.probe		= lpc32xx_gpio_probe,
> +};

The #ifdef above is not helpful, it will cause a build error in the
of_match_table= assignment. Since the plan for this driver is to
be devicetree-only, it would be appropriate to just remove the
#ifdef, but adding of_match_ptr() is ok too.

	Arnd

