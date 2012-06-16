Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042Ab2FPRXm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 13:23:42 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:61527 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754333Ab2FPRXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 13:23:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] mmc: mmci.c: Defer probe() in case of yet uninitialized GPIOs
Date: Sat, 16 Jun 2012 17:23:23 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: Roland Stigge <stigge@antcom.de>, cjb@laptop.org,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        rmk+kernel@arm.linux.org.uk, ulf.hansson@stericsson.com,
        linus.walleij@linaro.org, sebastian.rasmussen@stericsson.com,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        aletes.xgr@gmail.com
References: <1339865375-22314-1-git-send-email-stigge@antcom.de>
In-Reply-To: <1339865375-22314-1-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201206161723.23768.arnd@arndb.de>
X-Provags-ID: V02:K0:Ibk1fKGLToC/VwV5pOfmokfxwVAzjojbWeRreTfZBeC
 mnirYQvhxqtU3G0Doi1S7TcSnMedn/3pk6XhnQ3Di5oTNrsdKF
 wN+cEUAPJ0xtaaOnOd0KhQoYHZ9GBYcUy4NSbRcAjqNqZfTwEV
 s3rwQfnp5J6TSnYbUyUNJxKF7Mb1D7L84xohPrThqMPLiWURcv
 yBcGVYs3oh8hKQDgLbp4VDXhC+tIFOuB+YeSFteqtsdfaO+Imo
 9xO5hT+HbpUKXez90AeYMf1Lb74107pNYSla2+LX+uusH4Jmtc
 jf6K8ma9u0iX4mxtbaJh3XPYZ9tmP6P+Z1H1INLpqVztW6ljQt
 RYVcFrh2gw3VvJf79zFc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 16 June 2012, Roland Stigge wrote:
> +       if (of_get_property(np, "wp-gpios", NULL)) {
> +               pdata->gpio_wp = of_get_named_gpio(np, "wp-gpios", 0);
> +               if (pdata->gpio_wp == -ENODEV)
> +                       pdata->gpio_wp = -EPROBE_DEFER;
> +       } else {
> +               pdata->gpio_wp = -ENODEV;
> +       }

This is still very ugly and there is a certain danfer that we might
have to duplicate this across more drivers. Can't we make
of_get_named_gpio_flags return -EPROBE_DEFER in cases where we can't
find the GPIO number yet but still have a chance of returning it at
a later point?

	Arnd
