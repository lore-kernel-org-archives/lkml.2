Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655Ab2KZJba (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 04:31:30 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45548 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975Ab2KZJb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 04:31:28 -0500
Date: Mon, 26 Nov 2012 01:31:24 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH 3/5] Input: bu21013_ts - Add support for Device Tree
 booting
Message-ID: <20121126093124.GA13792@core.coreip.homeip.net>
References: <1352900837-20759-1-git-send-email-lee.jones@linaro.org>
 <1352900837-20759-4-git-send-email-lee.jones@linaro.org>
 <20121123155258.GE28552@gmail.com>
 <20121124075009.GB24711@core.coreip.homeip.net>
 <20121126090736.GC12782@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121126090736.GC12782@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2012 at 09:07:36AM +0000, Lee Jones wrote:
> On Fri, 23 Nov 2012, Dmitry Torokhov wrote:
> 
> > On Fri, Nov 23, 2012 at 03:52:58PM +0000, Lee Jones wrote:
> > > On Wed, 14 Nov 2012, Lee Jones wrote:
> > > 
> > > > Now we can register the BU21013_ts touch screen when booting with
> > > > Device Tree enabled. Here we parse all the necessary components
> > > > previously expected to be passed from platform data.
> > > > 
> > > > Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> > > > Cc: linux-input@vger.kernel.org
> > > > Acked-by: Arnd Bergmann <arnd@arndb.de>
> > > > Acked-by: Linus Walleij <linus.walleij@linaro.org>
> > > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > > > ---
> > > >  drivers/input/touchscreen/bu21013_ts.c |   39 ++++++++++++++++++++++++++++----
> > > >  1 file changed, 35 insertions(+), 4 deletions(-)
> > > > 
> > > > diff --git a/drivers/input/touchscreen/bu21013_ts.c b/drivers/input/touchscreen/bu21013_ts.c
> > > > index 5d8fc75..afef874 100644
> > > > --- a/drivers/input/touchscreen/bu21013_ts.c
> > > > +++ b/drivers/input/touchscreen/bu21013_ts.c
> > > > @@ -15,6 +15,8 @@
> > > >  #include <linux/regulator/consumer.h>
> > > >  #include <linux/module.h>
> > > >  #include <linux/gpio.h>
> > > > +#include <linux/of.h>
> > > > +#include <linux/of_gpio.h>
> > > >  
> > > >  /* Reference tracking for multiple displays. */
> > > >  static int bu21013_devices = 0;
> > > > @@ -487,13 +489,33 @@ static void bu21013_free_irq(struct bu21013_ts_data *bu21013_data)
> > > >   * This function used to initializes the i2c-client touchscreen
> > > >   * driver and returns integer.
> > > >   */
> > > > +static void __devinit bu21013_of_probe(struct device_node *np,
> > > > +				struct bu21013_platform_device *pdata)
> > > > +{
> > > > +	pdata->y_flip = pdata->x_flip = false;
> > > > +
> > > > +	if (of_get_property(np, "rohm,flip-x", NULL))
> > > > +		pdata->x_flip = true;
> > 
> > 	pdata->x_flip = of_property_read_bool(np, "rohm,flip-x");
> > 
> > ?
> 
> Yes, we can do this now it exists.
> 
> > Can I also get patch documenting the DT properties?
> 
> Sure. As a follow-up? I'll resubmit this first, right away.

No preference but I am going to fold documentation with the patch
implementing DT support anyway.

Thanks.

-- 
Dmitry
