Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758708Ab1FWB2p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 21:28:45 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48475 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758317Ab1FWB2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 21:28:43 -0400
Date: Thu, 23 Jun 2011 02:28:41 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sangbeom Kim <sbkim73@samsung.com>
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mfd: Add I2C control support for S5M8751
Message-ID: <20110623012841.GF20949@opensource.wolfsonmicro.com>
References: <1308722037-6966-1-git-send-email-sbkim73@samsung.com>
 <1308722037-6966-4-git-send-email-sbkim73@samsung.com>
 <20110622125050.GE23666@sirena.org.uk>
 <017201cc3144$74e343d0$5ea9cb70$@com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <017201cc3144$74e343d0$5ea9cb70$@com>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 10:25:37AM +0900, Sangbeom Kim wrote:

> Thank for your comment,
> We have a few PMIC (S5M8751, S5M8752 and others).
> They have different features. And Each one will have separate core file.
> But i2c interface is same.
> So, I try to separate i2s code.
> I would modify prefix like s5m87xx.

In that case you should definitely take a look at the regmap API I've
been posting.  It factors all the device I/O stuff out so you should be
able to just tell it that you have a device with n bit registers and n
bit values and it'll provide all the I/O functions you need.  I just
reposted it today, though it needs another round for some SPI stuff.

> > > +static int s5m8751_i2c_read_device(struct s5m8751 *s5m8751, uint8_t
> reg,
> > > +					uint8_t *val)
> > > +{
> > > +	int ret;
> > > +	ret = i2c_smbus_read_byte_data(s5m8751->i2c_client, reg);
> > > +	if (ret < 0) {
> > > +		dev_err(s5m8751->dev, "failed reading at 0x%02x\n", reg);
> > > +		return ret;
> > > +	}
> > > +	*val = (uint8_t)ret;

> > Why is this case required?

> I want pass the read value by val

Sorry, typo - why is this *cast* required?
