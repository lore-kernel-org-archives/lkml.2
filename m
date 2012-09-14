Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759306Ab2INI2H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 04:28:07 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:62446 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759275Ab2INI2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 04:28:01 -0400
Date: Fri, 14 Sep 2012 09:27:56 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, linux-i2c@vger.kernel.org
Subject: Re: [PATCH 12/19] i2c-nomadik: Register sub-devices when passed via
 Device Tree
Message-ID: <20120914082754.GE3374@gmail.com>
References: <1347016499-29354-1-git-send-email-lee.jones@linaro.org>
 <1347016499-29354-13-git-send-email-lee.jones@linaro.org>
 <CACRpkdaCrus9SOpxyK+kV2gKr3sEZJsHCn6ivn2gA3ri0rcvHw@mail.gmail.com>
 <20120912105202.GD2624@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120912105202.GD2624@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 12:52:02PM +0200, Wolfram Sang wrote:
> On Mon, Sep 10, 2012 at 04:42:36AM -0700, Linus Walleij wrote:
> > On Fri, Sep 7, 2012 at 1:14 PM, Lee Jones <lee.jones@linaro.org> wrote:
> > 
> > > Each I2C device can be correctly probed already using Device Tree,
> > > but the sub-devices still have to be registered by calls to
> > > i2c_register_board_info(). After this patch, each sub-device can
> > > be registered directly from Device Tree instead, removing the
> > > requirement for the aforementioned calls from platform code.
> > >
> > > CC: linux-i2c@vger.kernel.org
> > > CC: Wolfram Sang <w.sang@pengutronix.de>
> > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > 
> > The patch as such is fine.
> > Acked-by: Linus Walleij <linus.walleij@linaro.org>
> > 
> > ...but there will be merge issues (of the type I'm
> > discussing with Arnd in another thread).
> > 
> > > ---
> > >  drivers/i2c/busses/i2c-nomadik.c |    4 ++++
> > >  1 file changed, 4 insertions(+)
> > >
> > > diff --git a/drivers/i2c/busses/i2c-nomadik.c b/drivers/i2c/busses/i2c-nomadik.c
> > > index 5d1a970..01231c2 100644
> > > --- a/drivers/i2c/busses/i2c-nomadik.c
> > > +++ b/drivers/i2c/busses/i2c-nomadik.c
> > > @@ -26,6 +26,7 @@
> > >  #include <linux/pm_runtime.h>
> > >  #include <linux/platform_data/i2c-nomadik.h>
> > >  #include <linux/of.h>
> > > +#include <linux/of_i2c.h>
> > 
> > This is clearly dependent on the other patches to I2C to
> > be merged first (the include above is not yet there in
> > linux-next even), so this patch should go into Wolfram's
> > tree right? Else we have to rip out all the patches to the
> > I2C driver from his tree and funnel it all through ARM SoC.
> 
> First, I'd like to have this patch squashed with "i2c: nomadik: Add
> Device Tree support to the Nomadik I2C driver". I wanted to do this on
> my own, but the patches do not apply to 3.6-rc5 (with or without
> regulator removal patch from Linus)?

I'm really not keen on squashing all my patches together. They are
clearly have very different purposes. If you think they are closely
related, then pull them in sequentially, but please don't squash
all my work into a single patch for no other reason than convenience.

> I can also take the I2C related changes to the devicetrees via my tree.
> This is not uncommon. Some people prefer to do this via their soc-trees,
> though. I don't care much since this is not really a hard dependency
> causing build failures or merge conflicts, but just needs a little extra
> time until the patches are all there...

It would be better for all the Device Tree changes go in as a single
patch-set. Again, I don't care where they go, so long as they go in
together. arm-soc seems like the most generic place for them to be
pulled into though.

Kind regards,
Lee

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
