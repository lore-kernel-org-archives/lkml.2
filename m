Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751261Ab1EORub (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 13:50:31 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38667 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201Ab1EORu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 13:50:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=G+j5kJahZTud8y6OImv2tlokQuc6yGUokPcLHPx2oY5/i9Y+YKf7F7kZmhtpyYa+Ls
         VgBMCbIz6MAhTzobvlEd5qfI0y960VCXxAD3gWq6t6/3rQJN5jdbA7G+qU3K1z2hAzrm
         70+q/9wQ+ou49NYRaE8/eMSAYWgVhXFr3x1W8=
MIME-Version: 1.0
In-Reply-To: <20110515133312.GM4071@lunn.ch>
References: <1304363768-30338-1-git-send-email-linus.walleij@stericsson.com>
	<20110503172712.GE6538@lunn.ch>
	<BANLkTi=ncV3M1q5SXNdUaXmtfkZ8Wn9dmw@mail.gmail.com>
	<20110515133312.GM4071@lunn.ch>
Date: Sun, 15 May 2011 19:50:26 +0200
X-Google-Sender-Auth: 46b2iLFkOiN_ZqK5NWKQ4wAB0VM
Message-ID: <BANLkTi=O_mZEqMhOS_Fz0vAYCQ-XpyG4UA@mail.gmail.com>
Subject: Re: [PATCH 0/4] Pinmux subsystem
From: Linus Walleij <linus.walleij@linaro.org>
To: Andrew Lunn <andrew@lunn.ch>
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Martin Persson <martin.persson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/15 Andrew Lunn <andrew@lunn.ch>:

> With a bit of scripting, came to the following results. Each line is
> on pinmux function description what would be needed in the driver. The
> number at the front says how many boards would use it. In total there
> are 33 descriptions needed. Of these, 18 are used only once. This to
> me suggests the board needs to be able to specify a pin description
> when there is no reuse with other boards.

As indicated elsewhere in this thread, a pinmux driver can pass in
platform/package/board/system data just like any other platform
driver in the kernel tree can.

You will have to specify it somehow in a custom header file, just
like with any other platform driver.

Example from:
arch/arm/mach-orion5x/ls-chl-setup.c:

static struct gpio_led lschl_led_pins[] = {
        {
                .name = "alarm:red",
                .gpio = LSCHL_GPIO_LED_ALARM,
                .active_low = 1,
        }, {
                .name = "info:amber",
                .gpio = LSCHL_GPIO_LED_INFO,
                .active_low = 1,
        }, {
                .name = "func:blue:top",
                .gpio = LSCHL_GPIO_LED_FUNC,
                .active_low = 1,
        }, {
                .name = "power:blue:bottom",
                .gpio = LSCHL_GPIO_LED_PWR,
        },
};

static struct gpio_led_platform_data lschl_led_data = {
        .leds = lschl_led_pins,
        .num_leds = ARRAY_SIZE(lschl_led_pins),
};

static struct platform_device lschl_leds = {
        .name = "leds-gpio",
        .id = -1,
        .dev = {
                .platform_data = &lschl_led_data,
        },
};

Still, the driver for these LEDs is in
drivers/leds/leds-gpio.c and the above structure is
described in include/linux/leds.h

There is no difference between this and letting
drivers/pinmux/pinmux-orion.c have a header file in
include/linux/pinmux/orion.h and pass in necessary board
data that way.

Are we now in agreement that this will work just fine?

Yours,
Linus Walleij
