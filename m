Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933602Ab2JWUC6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 16:02:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35336 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933452Ab2JWUCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 16:02:55 -0400
Date: Tue, 23 Oct 2012 13:02:49 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Benoit Cousson <b-cousson@ti.com>
Cc: Sourav Poddar <sourav.poddar@ti.com>, tony@atomide.com,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCHv2] Input: omap4-keypad: Add pinctrl support
Message-ID: <20121023200249.GA2712@core.coreip.homeip.net>
References: <1350911580-20307-1-git-send-email-sourav.poddar@ti.com>
 <20121022155028.GA13791@core.coreip.homeip.net>
 <508660D4.9030507@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <508660D4.9030507@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 11:18:12AM +0200, Benoit Cousson wrote:
> Hi Dimitry,
> 
> On 10/22/2012 05:50 PM, Dmitry Torokhov wrote:
> > Hi Sourav,
> > 
> > On Mon, Oct 22, 2012 at 06:43:00PM +0530, Sourav Poddar wrote:
> >> Adapt keypad to use pinctrl framework.
> >>
> >> Tested on omap4430 sdp with 3.7-rc1 kernel.
> > 
> > I do not see anything in the driver that would directly use pinctrl. Is
> > there a better place to select default pin configuration; maybe when
> > instantiating platform device?
> 
> Why?
> The devm_pinctrl_get_select_default is using the pinctrl.

No, I guess we ihave different understanding of what "directly use" means.
This particular driver does directly use interrupts: it requests it and
performs some actions when interrupt arrives. Same goes for IO memory -
it gets requested, then we access it. With pinctrl we do not do anything
- we just ask another layer to configure it and that is it.

I have seen just in a few days 3 or 4 drivers having exactly the same
change - call to devm_pinctrl_get_select_default(), and I guess I will
receive the same patches for the rest of input drivers shortly.
This suggests that the operation is done at the wrong level. Do the
pin configuration as you parse DT data, the same way you set up i2c
devices registers in of_i2c.c, and leave the individual drivers that do
not care about specifics alone.

> That's why it is named "get_select_default" and not "get" only.
> This API ensure that the pin will be set to the default state, and this
> is all we need to do during the probe.

Why during the probe and not by default? Realistically, the driver will
be loaded as long as there is a matching device and pins will need to be
configured.

> 
> There is no point to change the mux if the driver is not probed, because
> potentially the pin can be use be another driver.

What other driver would use it? Who would chose what driver to load?

Thanks.

-- 
Dmitry
