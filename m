Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474Ab1JWLzQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 07:55:16 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40421 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755398Ab1JWLzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 07:55:15 -0400
Date: Sun, 23 Oct 2011 13:55:13 +0200
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sangbeom Kim <sbkim73@samsung.com>
Cc: "'Samuel Ortiz'" <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mfd: Add S5M core driver
Message-ID: <20111023115512.GA22871@opensource.wolfsonmicro.com>
References: <009201cc915a$cae8f290$60bad7b0$@com>
 <20111023083704.GA3135@opensource.wolfsonmicro.com>
 <009701cc9170$0f2e9ee0$2d8bdca0$@com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <009701cc9170$0f2e9ee0$2d8bdca0$@com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 23, 2011 at 07:39:36PM +0900, Sangbeom Kim wrote:
> On Sun, Oct 23, 2011 at 05:37 PM +0900, Mark Brown wrote:

> > > +EXPORT_SYMBOL(s5m_bulk_read);

> > All this stuff should be _GPL as the regmap core is _GPL - you shouldn't
> > wrap a _GPL function with a non-GPL one.

> You mean that EXPORT_SYMBOL should be replace with EXPORT_SYMBOL_GPL?

Yes.

> > > +static struct mfd_cell s5m87xx_devs[] = {
> > > +	{
> > > +		.name = "s5m8763-pmic",
> > > +	}, {
> > > +		.name = "s5m8767-pmic",
> > > +	}, {

> > It looks a bit odd to have both simultaneously but I guess this will
> > become more obvious later on?  I guess what I'd expect is one of these
> > arrays per device variant.

> My intention of this mfd driver is supporting all samsung mfd.
> It is desirable that a core driver handle various driver to prevent produce
> similar code.

Yes, this is very similar to what the wm831x driver does to handle all
the different chips we've got with the same register interface.

> So, If I want to implement like above concept, What kind of approach can be
> advised?

What wm831x does is register a different set of devices depending on the
device that gets registered - the per-device stuff is mostly just a set
of tables of devices to register.

> > > +	s5m87xx->dev = &i2c->dev;
> > > +	s5m87xx->i2c = i2c;
> > > +	s5m87xx->irq = i2c->irq;

> > Is SPI supported?

> SPI isn't supported by Samsung mfd

In that case it might be as well to just get things like the IRQ from
the i2c client rather than keeping a copy of the variable.
