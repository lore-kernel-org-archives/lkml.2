Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934433Ab2JXQSI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 12:18:08 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:49861 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933640Ab2JXQSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 12:18:06 -0400
Date: Wed, 24 Oct 2012 09:18:01 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Benoit Cousson <b-cousson@ti.com>, Sourav Poddar <sourav.poddar@ti.com>,
        tony@atomide.com, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCHv2] Input: omap4-keypad: Add pinctrl support
Message-ID: <20121024161801.GB16350@core.coreip.homeip.net>
References: <1350911580-20307-1-git-send-email-sourav.poddar@ti.com>
 <20121022155028.GA13791@core.coreip.homeip.net>
 <508660D4.9030507@ti.com>
 <20121023200249.GA2712@core.coreip.homeip.net>
 <CACRpkdYwA7O8AqB8YFCK-c3e6-7FcbhMOiPEUq-cKJni_PO-Ow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdYwA7O8AqB8YFCK-c3e6-7FcbhMOiPEUq-cKJni_PO-Ow@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 02:54:23PM +0200, Linus Walleij wrote:
> On Tue, Oct 23, 2012 at 10:02 PM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
> 
> > I have seen just in a few days 3 or 4 drivers having exactly the same
> > change - call to devm_pinctrl_get_select_default(), and I guess I will
> > receive the same patches for the rest of input drivers shortly.
> > This suggests that the operation is done at the wrong level. Do the
> > pin configuration as you parse DT data, the same way you set up i2c
> > devices registers in of_i2c.c, and leave the individual drivers that do
> > not care about specifics alone.
> 
> Exactly this can be done with pinctrl hogs.
> 
> The problem with that is that it removes the cross-reference
> between the device and it's pinctrl handle (also from the device
> tree). Instead the pinctrl handle gets referenced to the pin controller
> itself. So from a modelling perpective this looks a bit ugly.
> 
> So we have two kinds of ugly:
> 
> - Sprinke devm_pinctrl_get_select_default() over all drivers
>   which makes pinctrl handles properly reference their devices
> 
> - Use hogs and loose coupling between pinctrl handles and their
>   devices
> 
> A third alternative as outlined is to use notifiers and some
> resource core in drivers/base/*

OK, so with drivers/base/, have you considered doing default pinctrl
selection in bus's probe() methods? Yo would select the default
configuration before starting probing the device and maybe select idle
when probe fails or device is unbound? That would still keep the link
between device object and pinctrl and there less busses than device
drivers out there.

Thanks.

-- 
Dmitry
