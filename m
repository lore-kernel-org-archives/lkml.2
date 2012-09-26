Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756401Ab2IZND3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 09:03:29 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:60297 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756350Ab2IZND1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 09:03:27 -0400
MIME-Version: 1.0
In-Reply-To: <20120926125658.GA5641@beef>
References: <D7202A6C-5250-4B55-B3B8-FF15BCCA97AC@dominion.thruhere.net>
	<20120926125658.GA5641@beef>
Date: Wed, 26 Sep 2012 15:03:27 +0200
Message-ID: <CACRpkdYqVC4Vou+0Mn1OmQg8vPxDULDcFDD0yV5nassqkE1Zag@mail.gmail.com>
Subject: Re: replacement for /sys/kernel/debug/omap_mux in DT/pinctrl land ?
From: Linus Walleij <linus.walleij@linaro.org>
To: Matt Porter <mporter@ti.com>, Tony Lindgren <tony@atomide.com>
Cc: Koen Kooi <koen@dominion.thruhere.net>,
        List List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2012 at 2:56 PM, Matt Porter <mporter@ti.com> wrote:
> Adding Linus W. and lkml.
> On Wed, Sep 26, 2012 at 01:46:45PM +0200, Koen Kooi wrote:
>> Hi,
>>
>> With a patched 3.6rc7 on my beaglebone I can set the pinmux for pins using pinctrl and that seems to work. On the 3.2 vendor tree there was the omap_mux driver with an awesome debugfs interface:
>>
>> # cat /sys/kernel/debug/omap_mux/lcd_data0
>> name: lcd_data0.ehrpwm2A (0x44e108a0/0x8a0 = 0x0003), b NA, t NA
>> mode: OMAP_PIN_OUTPUT | OMAP_MUX_MODE3
>> signals: lcd_data0 | gpmc_a0 | pr1_mii_mt0_clk | ehrpwm2A | NA | pr1_pru1_pru_r30_0 | pr1_pru1_pru_r31_0 | gpio2_6
>>
>> Notice how it tells me that it's muxed the PWM in 2 ways: signal name (ehrpwm2A) and register content (0x0003). Compare to pinctrl:
>>
>> root@bone-mainline:/sys/kernel/debug/pinctrl/44e10800.pinmux# grep 8a0 *
>> pinconf-pins:pin 40 (44e108a0):
>> pingroups:pin 40 (44e108a0)
>> pinmux-pins:pin 40 (44e108a0): 4a300000.pruss (GPIO UNCLAIMED) function pinmux_pruss_led_pins group pinmux_pruss_led_pins
>> pins:pin 40 (44e108a0)  pinctrl-single
>>
>> What is that pin muxed to? It is part of the 'pinmux_pruss_led_pins' in the DT, but debugfs remains mute on how pin 40 is muxed.
>
> It does seem like a pretty big gap in the pinctrl/pinmux debugfs
> interface when viewed from an OMAP perspective. Ideally there would
> be a pinctrl/pinmux hook to the pinmux driver to provide the detailed
> h/w specific pin state info.

So add the hooks you need?

I assume you are using Tony's pinctrl-single driver, so Tony is the one to ask.

Yours,
Linus Walleij
