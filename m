Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075Ab1HSOgr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 10:36:47 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:63389 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430Ab1HSOgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 10:36:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 1/4 v4] drivers: create a pin control subsystem
Date: Fri, 19 Aug 2011 16:36:28 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Jamie Iles <jamie@jamieiles.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>, Joe Perches <joe@perches.com>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Lee Jones <lee.jones@linaro.org>, Greg KH <greg@kroah.com>
References: <1313747630-32258-1-git-send-email-linus.walleij@stericsson.com> <20110819104816.GA5030@pulham.picochip.com> <CACRpkdZhg_1WM37uqT1PNmpUjWS_groWJmNnR4SBjqJ6LFQQWQ@mail.gmail.com>
In-Reply-To: <CACRpkdZhg_1WM37uqT1PNmpUjWS_groWJmNnR4SBjqJ6LFQQWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108191636.29161.arnd@arndb.de>
X-Provags-ID: V02:K0:lwMfe4LTxft7xPdtHX8ilFB5YkmBV/0vICQHWiAhZKB
 LQc2V+NgKaj1IgchgAXSLq5PArIY96QLufYdpvNDjiIJXst2pE
 KCrI2vkZIzf9q9cb78ZR0WRkP34T8JwYauDC3P6C/xFq4jdrl/
 +R0EqTJnVnen3Rf2+q2m5gLZP3CaLN8mI0HWyPjowfZSYeXEvv
 xfF6kGZNTiLXUbFSEcxww==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 19 August 2011, Linus Walleij wrote:
> On Fri, Aug 19, 2011 at 12:48 PM, Jamie Iles <jamie@jamieiles.com> wrote:
> 
> >> +static struct class pinctrl_class = {
> >> +     .name = "pinctrl",
> >> +     .dev_release = pinctrl_dev_release,
> >> +     .dev_attrs = pinctrl_dev_attrs,
> >> +};
> >
> > Greg K-H has mentioned in the past that class is now deprecated for new
> > use and that a bus_type should be used instead.
> 
> Can you provide a reference with some detail?
> The pin control devices are usually aleady on a bus like the
> platform_bus or amba_bus or i2c_bus, then they register a
> class device in this case.
> 
> The kerneldoc documentation says
> "A bus is a channel between the processor and one or more devices."
> 
> This isn't the case here.
> 
> Anyhthing that help me understand this is appreciated, Arnd?

Taking Greg on Cc as well.

The main difference between a normal device and a class device is
that one is linked from /sys/bus/*/devices/* and the other is linked
from /sys/class/*/*. However, they both live in /sys/devices/.../*
as directories.

I always liked the separation between the two, although there are
a few cases where there is a grey area (e.g. /sys/bus/hid or
/sys/class/mmc_host) and the abstraction doesn't really fit.

IIRC Greg would prefer now to never have had the distinction
and wants to make all future uses use a bus_type.

	Arnd
