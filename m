Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864Ab0E0BjQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 21:39:16 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:53483 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756685Ab0E0BjP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 21:39:15 -0400
MIME-Version: 1.0
X-Originating-IP: [174.31.27.127]
In-Reply-To: <20100526235246.GA31068@pengutronix.de>
References: <AANLkTikzDvWakd7JW3DzTHinjS3dAlqzPx6K8V2qMDG7@mail.gmail.com>
	<AANLkTinkY8JYh44UOEPflBUDyQ2wat_AKShRjA3HPxrf@mail.gmail.com>
	<20100526235246.GA31068@pengutronix.de>
Date: Wed, 26 May 2010 18:39:13 -0700
Message-ID: <AANLkTikj8yGSK5Ovud_k8f6jWloojqDJmQ_H6pD_IFgM@mail.gmail.com>
Subject: Re: Controlling Driver Load Order
From: Robert Emanuele <rob@emanuele.us>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Linus Walleij <linus.ml.walleij@gmail.com>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for the suggestions but maybe I'm not describing this correctly...

In my platform's init_machine I had something like this:
{
    at91_add_device_i2c(1, my_i2c_devices, ARRAY_SIZE(my_i2c_devices));

    add_my_display();
}

Both of those calls lead to a platform_device_add.  I've tried moving
the at91_add_device_i2c into a function that was referenced by
subsys_initcall() like so:
static void __init power_control_init(void)
{
	at91_add_device_i2c(1, my_i2c_devices, ARRAY_SIZE(my_i2c_devices));
}
subsys_initcall(power_control_init);

Still the framebuffer device would initialize first and it would lack
having the i2c chips it needs ready.  That is the order I'm trying to
straighten out.

Thank you,

Rob

On Wed, May 26, 2010 at 4:52 PM, Wolfram Sang <w.sang@pengutronix.de> wrote:
> On Wed, May 26, 2010 at 11:04:01PM +0200, Linus Walleij wrote:
>> 2010/5/26 Robert Emanuele <rob@emanuele.us>:
>>
>> > On my at91sam9g45 platform I need my i2c drivers to load before the
>> > framebuffer driver.  The i2c drivers control a power management IC
>> > which is needed to enable the graphics controller.
>> >
>> > Is there a way to set up that order?
>>
>> The usual trick (which you can find in a lot of other I2C busses) is to use
>> a core_initcall() instead of module_init().
>
> Correct, but it's subsys_initcall().
>
> --
> Pengutronix e.K.                           | Wolfram Sang                |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
>
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.9 (GNU/Linux)
>
> iEYEARECAAYFAkv9tE4ACgkQD27XaX1/VRsuwgCgtuBO/G43yUxbTED+MdBf6tUv
> 9hYAn0WL0L475IYsXqiOlUMzGmdrAcr7
> =KcVU
> -----END PGP SIGNATURE-----
>
>
