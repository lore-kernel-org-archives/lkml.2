Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865Ab2DCXw1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 19:52:27 -0400
Received: from antcom.de ([188.40.178.216]:56079 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753519Ab2DCXw0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 19:52:26 -0400
Message-ID: <4F7B8D37.6020306@antcom.de>
Date: Wed, 04 Apr 2012 01:52:23 +0200
From: Roland Stigge <stigge@antcom.de>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linus.walleij@stericsson.com
Subject: Re: [PATCH] gpio: Device tree support for LPC32xx
References: <1333407513-18231-1-git-send-email-stigge@antcom.de> <20120403150430.EBA423E0436@localhost> <4F7B8A39.5000701@antcom.de>
In-Reply-To: <4F7B8A39.5000701@antcom.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/12 01:39, Roland Stigge wrote:
> ===============================================================
> Error requesting gpio 50
> ...
> gpiochip_add: registered GPIOs 0 to 7 on device: gpio_p0
> gpiochip_add: registered GPIOs 8 to 31 on device: gpio_p1
> gpiochip_add: registered GPIOs 32 to 44 on device: gpio_p2
> gpiochip_add: registered GPIOs 45 to 50 on device: gpio_p3
> gpiochip_add: registered GPIOs 51 to 78 on device: gpi_p3
> gpiochip_add: registered GPIOs 79 to 102 on device: gpo_p3
> ===============================================================
> 
> Seems to be caused by this device tree:
> 
>         leds {
>                 compatible = "gpio-leds";
>                 led0 {  
>                         gpios = <&gpo_p3 1 1>; /* GPO_P3 1, GPIO 80, active low */
>                         linux,default-trigger = "heartbeat";
>                         default-state = "keep";
>                 };
>         };

No, it was "another" 50 (decimal, not hex). :-) Was caused by old early
board init code, eliminated anyway.

Thanks,

Roland
