Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864Ab2LGIHe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 03:07:34 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:60874 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068Ab2LGIH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 03:07:29 -0500
MIME-Version: 1.0
In-Reply-To: <1354775567-17408-1-git-send-email-linux@roeck-us.net>
References: <1354775567-17408-1-git-send-email-linux@roeck-us.net>
Date: Fri, 7 Dec 2012 09:07:28 +0100
Message-ID: <CACRpkdYDLJDwv97Z0agZBbzCtEdeb5Y-83K2HkZRtLP1Cz_QiA@mail.gmail.com>
Subject: Re: [PATCH] gpio: export 'debounce' attribute if supported by the
 gpio chip
From: Linus Walleij <linus.walleij@linaro.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 6, 2012 at 7:32 AM, Guenter Roeck <linux@roeck-us.net> wrote:

> Create a 'debounce' attribute if debounce is supported by the gpio
> chip and a gpio pin is exported.
>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

Can you describe the usecase for this?

I have this problem when working as a back-up GPIO maintainer that
I don't really understand the userspace apps doing this.

I would guess something like a userspace app reading a GPIO switch
and needing to set this to avoid key bounces, but it'd be nice to know
if this is really the case.

If this is the usecase I am slightly concerned why these are not used:
drivers/input/keyboard/gpio_keys_polled.c
drivers/input/keyboard/gpio_keys.c

The latter even uses the in-kernel debounce interface.

I'd agree if this is not user input at all but something like a switch
in a factory production line.

So please help me understand this.

Yours,
Linus Walleij
