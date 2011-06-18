Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531Ab1FRTIG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 15:08:06 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:65035 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087Ab1FRTIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 15:08:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Wim Van Sebroeck <wim@iguana.be>
Subject: Re: [PATCH 7/10 v2] Generic Watchdog Timer Driver
Date: Sat, 18 Jun 2011 21:07:45 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <20110618172537.GH3441@infomag.iguana.be>
In-Reply-To: <20110618172537.GH3441@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106182107.45682.arnd@arndb.de>
X-Provags-ID: V02:K0:njCuVKnTvj9fP7EoOrhx1upBGkwMGQ4NBxaicLzSTHi
 0flwOgZr0M/hGgP1jcia7wg2cPdLkis3ZYXLAJns3o17aqVBmf
 2ERA/2ztiZRqr4iYA77Wj2reRwFuAgH23BIGQs1mJHZXv8pY6s
 EuGRv2DucmsqfbrWm+L1BCSk/6vdCHmtGqcNAqHD+4KNbYHllF
 xrq7vxwmGi7askAXUeh5g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 18 June 2011 19:25:37 Wim Van Sebroeck wrote:
> diff -urN linux-2.6.38-generic-part6/Documentation/watchdog/src/watchdog-with-timer-example.c linux-2.6.38-generic-part7/Documentation/watchdog/src/watchdog-with-timer-example.c
> --- linux-2.6.38-generic-part6/Documentation/watchdog/src/watchdog-with-timer-example.c 2011-06-16 21:04:06.283940741 +0200
> +++ linux-2.6.38-generic-part7/Documentation/watchdog/src/watchdog-with-timer-example.c 2011-06-17 09:52:32.866632635 +0200
> @@ -45,6 +45,11 @@
>  MODULE_PARM_DESC(timeout, "Watchdog timeout in seconds. "
>         "(default = " __MODULE_STRING(WDT_TIMEOUT) ")");
>  
> +static int nowayout = WATCHDOG_NOWAYOUT;
> +module_param(nowayout, int, 0);
> +MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started. "
> +       "(default = " __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
> +
>  static struct watchdog_device wdt_dev;
>  static void wdt_timer_tick(unsigned long data);
>  static DEFINE_TIMER(timer, wdt_timer_tick, 0, 0);
> @@ -152,6 +157,8 @@
>  
>         /* Set watchdog_device parameters */
>         wdt_dev.timeout = timeout;
> +       if (nowayout)
> +               set_bit(WDOG_NO_WAY_OUT, &wdt_dev.status);
>  
>         /* Register the watchdog timer device */
>         res = watchdog_register_device(&wdt_dev);

Why is this a feature of the individual drivers and not of the core?

Maybe it can be in both, so existing drivers don't need to change the user
interface, but new drivers don't have to provide the option individually
when you can simply set it for the base module.

	Arnd
