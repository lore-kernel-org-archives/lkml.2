Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757945Ab2HHJUX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 05:20:23 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:52334 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505Ab2HHJUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 05:20:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [rtc-linux] [PATCH 8/8] ARM: vt8500: gpio: Devicetree support for arch-vt8500
Date: Wed, 8 Aug 2012 09:19:52 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: vt8500-wm8505-linux-kernel@googlegroups.com,
        Tony Prisk <linux@prisktech.co.nz>,
        Russell King <linux@arm.linux.org.uk>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Alan Cox <alan@linux.intel.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Hauke Mehrtens <hauke@hauke-m.de>, Felipe Balbi <balbi@ti.com>,
        Neil Zhang <zhangwm@marvell.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Rob Landley <rob@landley.net>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Warren <swarren@nvidia.com>,
        Eric Andersson <eric.andersson@unixphere.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-serial@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
References: <1344389967-8465-1-git-send-email-linux@prisktech.co.nz> <1344389967-8465-9-git-send-email-linux@prisktech.co.nz> <CACRpkdbYxpN9RCu8j8KMBgrb=-DsYZHq7hx-ifmHhJ0ZZcRYjw@mail.gmail.com>
In-Reply-To: <CACRpkdbYxpN9RCu8j8KMBgrb=-DsYZHq7hx-ifmHhJ0ZZcRYjw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208080919.52592.arnd@arndb.de>
X-Provags-ID: V02:K0:fK2D8dNzGuQJdZxmT3oUYF9RibBdB5UW/Ic2vLCBMZc
 RKSMNxqomJQWlK1+V3qiYxDmwtS7jbbDv4iBNjEAeaK2qaU/xw
 XWLBAyl1jPgwd/ZiwwxT3OXlpKzG723XB1fpI9rraDfkaSpm7s
 bO4wz6lV2p0q6tCxzFnrT7OrLMuMvP8+Q1FCHLJKF9Ao76a1LI
 RlmaP9bIgeH+hTjSK7FonOGTqTRT+O/Cm0gmXfbwxd4fK6H3n4
 iS8tUXAeSR1VFu5QryFdutDxo/7OT8e60F7iGXnYnp/nRYkoo3
 DzbRREoFOIbgjc2s1sPUvuKfR+GrfEdn5dyLpZgeeW4iilIrGd
 3kVGLjx0KxL8rKq2lYHQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 August 2012, Linus Walleij wrote:
> On Wed, Aug 8, 2012 at 3:39 AM, Tony Prisk <linux@prisktech.co.nz> wrote:
> 
> > Converted the existing arch-vt8500 gpio to a platform_device.
> > Added support for WM8505 and WM8650 GPIO controllers.
> (...)
> > +++ b/drivers/gpio/gpio-vt8500.c
> 
> This driver looks very one-bit-per-gpio typed. Are you sure you cannot
> just reuse drivers/gpio/gpio-generic.c? Make a compelling case please...
> 
> > +struct vt8500_gpio_bank_regs {
> > +       int     en;
> > +       int     dir;
> > +       int     data_out;
> > +       int     data_in;
> 
> Why are all these members int? They should be u8 from reading your code.
> 
> > +       int     ngpio;
> > +};

Not necessarily 8 bit, but definitely unsigned.

> > +static struct vt8500_gpio_data vt8500_data = {
> > +       .num_banks      = 7,
> > +       .banks  = {
> > +               VT8500_BANK(0x00, 0x20, 0x40, 0x60, 26),
> > +               VT8500_BANK(0x04, 0x24, 0x44, 0x64, 28),
> > +               VT8500_BANK(0x08, 0x28, 0x48, 0x68, 31),
> > +               VT8500_BANK(0x0C, 0x2C, 0x4C, 0x6C, 19),
> > +               VT8500_BANK(0x10, 0x30, 0x50, 0x70, 19),
> > +               VT8500_BANK(0x14, 0x34, 0x54, 0x74, 23),
> > +               VT8500_BANK(-1, 0x3C, 0x5C, 0x7C, 9),    /* external gpio */
> 
> What on earth are all those magic numbers?
> 
> I *guess* they're enabling some default GPIO settings etc.

No, they are the register offsets you quoted above, per bank. There
is no easy way to abstract these, and I suggested putting the
values into the source code rather than describing each bank
separately in the .dtsi file.

My feeling however is that the "vt8500_chip->regoff" is wrong, which
would mean only the first bank works. The code adds the same offsets
per bank once more that it sets in this bank table.

	Arnd
