Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756336Ab3AIBsh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 20:48:37 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:63223 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755912Ab3AIBsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 20:48:35 -0500
MIME-Version: 1.0
In-Reply-To: <201301081306.02942.arnd@arndb.de>
References: <1357629535-26033-1-git-send-email-acourbot@nvidia.com> <201301081306.02942.arnd@arndb.de>
From: Alexandre Courbot <acourbot@nvidia.com>
Date: Wed, 9 Jan 2013 10:48:15 +0900
X-Google-Sender-Auth: TairA27x2d3motKG5yMtoyngJcI
Message-ID: <CAAVeFu+vWe+ZGBPy2MMEv=7n-ob=F65rfz+b6ND9zk1d16LbEA@mail.gmail.com>
Subject: Re: [PATCH 0/4] gpio: introduce descriptor-based interface
To: Arnd Bergmann <arnd@arndb.de>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 8, 2013 at 10:06 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> I like the interface, good idea!

Great! This was initially suggested by Linus W.

> A few questions:
>
> Is there a plan for migrating all the existing users of the current GPIO
> interface?

Nothing specifically planned for now, as we need to make sure the new
interface covers all needs first. There would be a lot of drivers to
change if we decide to deprecate the integer interface, but Coccinelle
could probably help here.

The question is, do we want to totally get rid of the integer
namespace? That would be the ultimate step, but would require another
way to identify GPIOs (controller_device:offset might be such a way),
and also to reorganize sysfs nodes. Wouldn't that be considered
breaking user-space? 'cause we all know what happens to those who
break user-space.

> How do you want to deal with drivers that work on platforms that currently
> don't use gpiolib but have their own implementation of asm/gpio.h? Are
> we going to phase them out?

With the current code, a driver should depend on gpiolib being
compiled if it uses the new interface. It is not even declared if
gpiolib is not used.

Given that both interfaces are quite close, one could imagine having a
gpiod wrapper around the integer namespace (the "opaque descriptors"
would then just be casted integers). This way drivers would only need
to depend on GENERIC_GPIO. It's a little bit weird to have gpiod
wrapping around gpio in one case and the opposite in another though -
I'd rather have these platforms convert to GPIO descriptors internally
(or even better, to gpiolib), but this is probably asking too much.

I do not know all the details of gpiolib's history, but why would
anyone want to implement the generic gpio interface and not use
gpiolib anyways?

Then there are platforms who do not follow generic gpios and implement
their own sauce. I don't think we need to care here, as these are not
supposed to be used with generic drivers anyway.

> If we are adding a new way to deal with GPIOs, would it make sense to
> have that more closely integrated into pinctrl in one form or another?
> My feeling is that there is already a significant overlap between the
> two, and while the addition of the gpiod_* functions doesn't necessarily
> make this worse, it could be a chance to improve the current situation
> to make the interface more consistent with pinctrl.

That may be a chance to introduce deeper changes indeed - what do you
have in mind exactly?

Thanks,
Alex.
