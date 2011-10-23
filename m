Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475Ab1JWKjj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 06:39:39 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:20023 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240Ab1JWKji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 06:39:38 -0400
X-AuditID: cbfee61a-b7cf1ae00000208e-d9-4ea3eee8993f
From: Sangbeom Kim <sbkim73@samsung.com>
To: "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>
Cc: "'Samuel Ortiz'" <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
References: <009201cc915a$cae8f290$60bad7b0$@com>
 <20111023083704.GA3135@opensource.wolfsonmicro.com>
In-reply-to: <20111023083704.GA3135@opensource.wolfsonmicro.com>
Subject: RE: [PATCH 1/3] mfd: Add S5M core driver
Date: Sun, 23 Oct 2011 19:39:36 +0900
Message-id: <009701cc9170$0f2e9ee0$2d8bdca0$@com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AcyRXvRj9e99i9aqRdahyqKNphORwQAClD+A
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Sun, Oct 23, 2011 at 05:37 PM +0900, Mark Brown wrote:

> >  drivers/mfd/s5m-core.c               |  235 +++++++++++++++++++++++++
> >  include/linux/mfd/s5m87xx/s5m-core.h |  313
> > ++++++++++++++++++++++++++++++++++
> 
> Naughty Outlook!

Sorry, I hope that I can send next version by git send-email.

> Actually, looking at this what I'm thinking is that we should put some
> inline functions in the regmap header which let you write this as
> something like
> 
> 	int s5m_reg_read(struct s5m87xx_dev *s5m87xx, u8 reg, u8 *dest)
> 	{
> 		return regmap_read_u8(s5m87xx->dev, reg, dest);
> 	}
> (which might be inline itself) as most of what you're doing here is the
> type conversion for the arguments.

OK, I will modify it.
> 
> > +EXPORT_SYMBOL(s5m_bulk_read);
> 
> All this stuff should be _GPL as the regmap core is _GPL - you shouldn't
> wrap a _GPL function with a non-GPL one.

You mean that EXPORT_SYMBOL should be replace with EXPORT_SYMBOL_GPL?

> > +static struct mfd_cell s5m87xx_devs[] = {
> > +	{
> > +		.name = "s5m8763-pmic",
> > +	}, {
> > +		.name = "s5m8767-pmic",
> > +	}, {
> 
> It looks a bit odd to have both simultaneously but I guess this will
> become more obvious later on?  I guess what I'd expect is one of these
> arrays per device variant.

My intention of this mfd driver is supporting all samsung mfd.
It is desirable that a core driver handle various driver to prevent produce
similar code.
So, If I want to implement like above concept, What kind of approach can be
advised?
 
> > +	s5m87xx->dev = &i2c->dev;
> > +	s5m87xx->i2c = i2c;
> > +	s5m87xx->irq = i2c->irq;
> 
> Is SPI supported?

SPI isn't supported by Samsung mfd

> 
> > +	dev_info(s5m87xx->dev ,"SAMSUNG S5M MFD\n");
> 
> Probably best to remove this for mainline, it's not really adding
> anything.

OK, I will remove it.

> > +static const struct i2c_device_id s5m87xx_i2c_id[] = {
> > +	{ "s5m87xx", 0 },
> > +	{ }
> > +};
> > +MODULE_DEVICE_TABLE(i2c, s5m87xx_i2c_id);
> 
> It'd be better to have one entry per chip explicitly naming the device,
> that way boards are describing which they have and the kernel can apply
> any device specific configuration.
> 
As I write above, I want to use a core driver for various mfd.
What kind of approach can be advised?

I'm very thank for your kindly review.
Sangbeom.

