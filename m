Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182Ab1FTXlp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 19:41:45 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42643 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751439Ab1FTXln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 19:41:43 -0400
Date: Tue, 21 Jun 2011 00:41:40 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-kernel@vger.kernel.org,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Samuel Oritz <sameo@linux.intel.com>,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: Re: [PATCH 2/8] regmap: Add I2C bus support
Message-ID: <20110620234140.GB1905@opensource.wolfsonmicro.com>
References: <20110620124608.GB31140@opensource.wolfsonmicro.com>
 <1308574489-31322-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1308574489-31322-2-git-send-email-broonie@opensource.wolfsonmicro.com>
 <4DFFD64F.8040902@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DFFD64F.8040902@metafoo.de>
X-Cookie: You are magnetic in your bearing.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 01:22:55AM +0200, Lars-Peter Clausen wrote:
> On 06/20/2011 02:54 PM, Mark Brown wrote:
> > [...]
> > +
> > +#include <linux/regmap.h>
> > +#include <linux/i2c.h>

> #include <linux/init.h>

For...?

> > +static int regmap_i2c_read(struct device *dev,
> > +			   const void *reg, size_t reg_size,
> > +			   void *val, size_t val_size)
> > +{
> > +	struct i2c_client *i2c = to_i2c_client(dev);
> > +	struct i2c_msg xfer[2];
> > +	int ret;

> > +	if (!i2c_check_functionality(i2c->adapter, I2C_FUNC_PROTOCOL_MANGLING))
> > +		return -ENOTSUPP;

> You shouldn't need I2C_FUNC_PROTOCOL_MANGLING for reading.

Hrm, yeah, probably not.
