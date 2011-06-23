Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758658Ab1FWCVN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 22:21:13 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:58710 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758333Ab1FWCVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 22:21:12 -0400
X-AuditID: cbfee61b-b7b2dae000007af9-99-4e02a31621fc
Date: Thu, 23 Jun 2011 11:21:10 +0900
From: Sangbeom Kim <sbkim73@samsung.com>
Subject: RE: [PATCH 3/3] mfd: Add I2C control support for S5M8751
In-reply-to: <20110623012841.GF20949@opensource.wolfsonmicro.com>
To: "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org
Message-id: <017301cc314c$37839eb0$a68adc10$@com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: AcwxROXPP1Y5MkuXRciUTdjHrYdXYgAAuI0Q
References: <1308722037-6966-1-git-send-email-sbkim73@samsung.com>
 <1308722037-6966-4-git-send-email-sbkim73@samsung.com>
 <20110622125050.GE23666@sirena.org.uk> <017201cc3144$74e343d0$5ea9cb70$@com>
 <20110623012841.GF20949@opensource.wolfsonmicro.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 10:29 AM +0900, Mark Brown wrote:
 > > Thank for your comment,
> > We have a few PMIC (S5M8751, S5M8752 and others).
> > They have different features. And Each one will have separate core file.
> > But i2c interface is same.
> > So, I try to separate i2s code.
> > I would modify prefix like s5m87xx.
> 
> In that case you should definitely take a look at the regmap API I've
> been posting.  It factors all the device I/O stuff out so you should be
> able to just tell it that you have a device with n bit registers and n
> bit values and it'll provide all the I/O functions you need.  I just
> reposted it today, though it needs another round for some SPI stuff.

OK, After reviewing your patch, I will apply  it.

> > > > +static int s5m8751_i2c_read_device(struct s5m8751 *s5m8751, uint8_t
> > reg,
> > > > +					uint8_t *val)
> > > > +{
> > > > +	int ret;
> > > > +	ret = i2c_smbus_read_byte_data(s5m8751->i2c_client, reg);
> > > > +	if (ret < 0) {
> > > > +		dev_err(s5m8751->dev, "failed reading at 0x%02x\n",
> reg);
> > > > +		return ret;
> > > > +	}
> > > > +	*val = (uint8_t)ret;
> 
> > > Why is this case required?
> 
> > I want pass the read value by val
> 
> Sorry, typo - why is this *cast* required?
Just want to make same type.

Thanks,
SB Kim

