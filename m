Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896Ab0E0Bdz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 21:33:55 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:59312 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756474Ab0E0Bdx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 21:33:53 -0400
MIME-Version: 1.0
X-Originating-IP: [174.31.27.127]
In-Reply-To: <20100526235246.GA31068@pengutronix.de>
References: <AANLkTikzDvWakd7JW3DzTHinjS3dAlqzPx6K8V2qMDG7@mail.gmail.com>
	<AANLkTinkY8JYh44UOEPflBUDyQ2wat_AKShRjA3HPxrf@mail.gmail.com>
	<20100526235246.GA31068@pengutronix.de>
Date: Wed, 26 May 2010 18:33:47 -0700
Message-ID: <AANLkTinhbSuKl3ajWEonsgsa_BVbUDffK7tNAXINUGZN@mail.gmail.com>
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

Maybe I'm not describing this correctly...
In my platform init_machine I had something like this:
{
at91_add_device_i2c(1, my_i2c_devices, ARRAY_SIZE(my_i2c_devices));

add_my_display


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
