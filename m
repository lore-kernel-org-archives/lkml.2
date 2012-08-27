Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874Ab2H0W6x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 18:58:53 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:40254 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379Ab2H0W6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 18:58:52 -0400
MIME-Version: 1.0
In-Reply-To: <1345241877-16200-15-git-send-email-cheiny@synaptics.com>
References: <1345241877-16200-1-git-send-email-cheiny@synaptics.com>
	<1345241877-16200-15-git-send-email-cheiny@synaptics.com>
Date: Mon, 27 Aug 2012 15:58:50 -0700
Message-ID: <CACRpkdYc68j24VZAMxLoC-7-sWn4bJPtxA5U6a95Dg82+zTetg@mail.gmail.com>
Subject: Re: [RFC PATCH 14/17] input: RMI4 F30 GPIO/LED control
From: Linus Walleij <linus.walleij@linaro.org>
To: Christopher Heiny <cheiny@synaptics.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Allie Xiong <axiong@synaptics.com>,
        William Manson <wmanson@synaptics.com>,
        Peichen Chang <peichen.chang@synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GPIO/LED, nice since I'm a GPIO maintainer I'll take a closer look.

If the bus will start doing a lot of non-input business it should live under
drivers/mfd but I think this is just one exception, right?

On Fri, Aug 17, 2012 at 3:17 PM, Christopher Heiny <cheiny@synaptics.com> wrote:

(...)
> diff --git a/drivers/input/rmi4/rmi_f30.c b/drivers/input/rmi4/rmi_f30.c

> +#include <linux/kernel.h>
> +#include <linux/rmi.h>
> +#include <linux/input.h>
> +#include <linux/slab.h>
> +#include "rmi_driver.h"

The non-existance of <linux/gpio.h> and <linux/leds.h> tells us that something
is very wrong.

You should not model these GPIOs and LEDs by a set of obscure
sysfs attributes, instead use the proper kernel subsystems that
already exist for handling this! LEDs and GPIOs already have their
own (standardized) userspace sysfs interfaces.

Reading the code I see that this is what happens here, so please rewrite
this to be a real GPIO+LED driver using struct gpio_chip and
the same for LEDs.

Be inspired by drivers/gpio/* and drivers/leds/*

Yours,
Linus Walleij
