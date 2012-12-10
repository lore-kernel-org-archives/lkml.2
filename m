Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250Ab2LJKLs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 05:11:48 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:46913 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677Ab2LJKLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 05:11:45 -0500
MIME-Version: 1.0
In-Reply-To: <20121209170754.GA27468@roeck-us.net>
References: <1354775567-17408-1-git-send-email-linux@roeck-us.net>
	<CACRpkdYDLJDwv97Z0agZBbzCtEdeb5Y-83K2HkZRtLP1Cz_QiA@mail.gmail.com>
	<20121207145955.GA28704@roeck-us.net>
	<20121207164906.08b65046@pyramind.ukuu.org.uk>
	<1355047099.1673.5.camel@anish-Inspiron-N5050>
	<20121209110319.459a762a@pyramind.ukuu.org.uk>
	<20121209170754.GA27468@roeck-us.net>
Date: Mon, 10 Dec 2012 11:11:44 +0100
Message-ID: <CACRpkdao8ZzyhvUMBSxFDJJiut9myxfPPEamnaP4cU6mWTTYVQ@mail.gmail.com>
Subject: Re: [PATCH] gpio: export 'debounce' attribute if supported by the
 gpio chip
From: Linus Walleij <linus.walleij@linaro.org>
To: Guenter Roeck <groeck-dsl@sbcglobal.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        anish kumar <anish198519851985@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 9, 2012 at 6:07 PM, Guenter Roeck <groeck-dsl@sbcglobal.net> wrote:

> The gpio pins I am dealing with are provided by an FPGA which is used on various
> boards. While the gpio access registers are always the same, the actual usage is
> board specific. This means I either need to write ugly code, or use the gpio
> subsystem to provide access to the gpio pins. Ugly code is out of the question,
> which means I'll need gpio support.
>
> Anyway, I want to keep things simple, not add unnecessary complexity. Having to
> go through the input subsystem just to be able to support debounce on a couple
> of input pins doesn't really sound simple. Guess I'll have to find another
> solution if the patch is not accepted. Maybe I'll add a "debounce" property to
> the gpio driver's of properties.

I would like you to seriously consider both gpio-input and the new
drivers/extcon/extcon-gpio.c driver (maybe adding debounce into that
driver). The latter also has a sysfs interface.

Your usecases seem to be EXTCON_MECHANICAL. If not, new classes
can surely be added.

There is some risk that sysfs makes everything that is a GPIO line
appear as GPIO instead of what it really is, which is not helpful
for userspace which will have to keep track of all the routing of the
electronics.

The latter might be comfortable if you're designing and maintaining the
whole system with firmware and so on, but from a newcomer
examining the system in sysfs it's not helpful, and we're designing
that ABI for a purpose.

(And I share Grant's hesitant stance on extending the GPIO sysfs.)

Yours,
Linus Walleij
