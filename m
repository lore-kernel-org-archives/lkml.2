Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861Ab2DCXjl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 19:39:41 -0400
Received: from antcom.de ([188.40.178.216]:55262 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755107Ab2DCXjk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 19:39:40 -0400
Message-ID: <4F7B8A39.5000701@antcom.de>
Date: Wed, 04 Apr 2012 01:39:37 +0200
From: Roland Stigge <stigge@antcom.de>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linus.walleij@stericsson.com
Subject: Re: [PATCH] gpio: Device tree support for LPC32xx
References: <1333407513-18231-1-git-send-email-stigge@antcom.de> <20120403150430.EBA423E0436@localhost>
In-Reply-To: <20120403150430.EBA423E0436@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

thanks for your notes!

On 03/04/12 17:04, Grant Likely wrote:
>> +postcore_initcall(lpc32xx_gpio_init);
> 
> module_platform_driver() please.  Also, now that deferred probe is
> merged, there should no longer be any need to mess around with
> initcall levels to get gpio drivers probed early.

With module_platform_driver(), I get a new error reported after this
change, coming much earlier before the GPIO registration (which is
deferred now, of course):

===============================================================
Error requesting gpio 50
...
gpiochip_add: registered GPIOs 0 to 7 on device: gpio_p0
gpiochip_add: registered GPIOs 8 to 31 on device: gpio_p1
gpiochip_add: registered GPIOs 32 to 44 on device: gpio_p2
gpiochip_add: registered GPIOs 45 to 50 on device: gpio_p3
gpiochip_add: registered GPIOs 51 to 78 on device: gpi_p3
gpiochip_add: registered GPIOs 79 to 102 on device: gpo_p3
===============================================================

Seems to be caused by this device tree:

        leds {
                compatible = "gpio-leds";
                led0 {  
                        gpios = <&gpo_p3 1 1>; /* GPO_P3 1, GPIO 80, active low */
                        linux,default-trigger = "heartbeat";
                        default-state = "keep";
                };
        };

Are you sure that module_platform_driver() can already handle
this in v3.4-rc1?

Thanks in advance,

Roland
