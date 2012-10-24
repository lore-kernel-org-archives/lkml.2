Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757146Ab2JXQvu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 12:51:50 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:53924 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075Ab2JXQvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 12:51:49 -0400
MIME-Version: 1.0
In-Reply-To: <20121024161429.GA16350@core.coreip.homeip.net>
References: <1350911580-20307-1-git-send-email-sourav.poddar@ti.com>
	<20121022155028.GA13791@core.coreip.homeip.net>
	<508660D4.9030507@ti.com>
	<20121023200249.GA2712@core.coreip.homeip.net>
	<20121024083704.GF5665@arwen.pp.htv.fi>
	<20121024161429.GA16350@core.coreip.homeip.net>
Date: Wed, 24 Oct 2012 18:51:47 +0200
Message-ID: <CACRpkdai3NocZQnW6YRF+k6GXUSx3P_Ge=F-tkuivrFm6tBbLg@mail.gmail.com>
Subject: Re: [PATCHv2] Input: omap4-keypad: Add pinctrl support
From: Linus Walleij <linus.walleij@linaro.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Felipe Balbi <balbi@ti.com>, Benoit Cousson <b-cousson@ti.com>,
        Sourav Poddar <sourav.poddar@ti.com>, tony@atomide.com,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 6:14 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Wed, Oct 24, 2012 at 11:37:04AM +0300, Felipe Balbi wrote:

>> - we ask another layer to allocate memory for us
>> - we ask another layer to call our ISR once the IRQ line is asserted
>> - we ask another layer to handle the input events we just received
>> - we ask another layer to transfer data through DMA for us
>> - we ask another layer to turn regulators on and off.
>
> But we are _directly_ _using_ all of these. You allocate memory and you
> (the driver) stuff data into that memory. You ask for DMA and you take
> the DMAed data and work with it. Not so with pinctrl in omap keypad and
> other drivers I have seen so far.

Consult:
drivers/tty/serial/amba-pl011.c
drivers/spi/spi-pl022.c
drivers/i2c/busses/i2c-nomadik.c

for more complex pinctrl use cases. These are my dogfood drivers ...
Most of these will request more than one state and switch the driver
between these different states at runtime, in these examples for power
saving there are states named "default", "sleep" and in the I2C driver
also "idle".

These examples are more typical to how the ux500 platform will
look, also the SKE input driver will move the devise to sleep/default
states but we need to merge PM code before we can do that.

Yours,
Linus Walleij
