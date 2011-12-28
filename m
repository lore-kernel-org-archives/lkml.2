Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166Ab1L1JOX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 04:14:23 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:42865 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707Ab1L1JOV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 04:14:21 -0500
From: "AnilKumar, Chimata" <anilkumar@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "Girdwood, Liam" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "Nori, Sekhar" <nsekhar@ti.com>
Subject: RE: [PATCH 1/2] MFD: TPS65217: Add new mfd device for TPS65217
Thread-Topic: [PATCH 1/2] MFD: TPS65217: Add new mfd device for TPS65217
Thread-Index: AQHMwTK1zssV+wAOUUeoOy+ljcxe7pXo4nEAgAaiSnA=
Date: Wed, 28 Dec 2011 09:14:13 +0000
Message-ID: <331ABD5ECB02734CA317220B2BBEABC103ECA4@DBDE01.ent.ti.com>
References: <1324617679-14301-1-git-send-email-anilkumar@ti.com>
 <20111223104918.GD2834@opensource.wolfsonmicro.com>
In-Reply-To: <20111223104918.GD2834@opensource.wolfsonmicro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.157.50]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

Thanks for reviewing these patches.

On Fri, Dec 23, 2011 at 16:19:18, Mark Brown wrote:
> On Fri, Dec 23, 2011 at 10:51:19AM +0530, AnilKumar Ch wrote:
> > The TPS65217 chip is a power management IC for Portable Navigation Systems
> > and Tablet Computing devices. It contains the following components:
> 
> I can't help but thinking that there ought to be more code sharing
> between the various TI PMIC drivers.
> 
> > +static int tps65217_i2c_read_device(struct tps65217_dev *tps65217, char reg,
> > +				  int bytes, void *dest)
> > +{
> > +	struct i2c_client *i2c = tps65217->i2c_client;
> > +	struct i2c_msg xfer[2];
> > +	int ret;
> 
> Use regmap for the register I/O, this will save a lot of code and will
> also give access to things like the register cache code.
> 

All the I2C read and writes moved to regmap read and writes.

> > +	tps65217 = kzalloc(sizeof(struct tps65217_dev), GFP_KERNEL);
> > +	if (tps65217 == NULL)
> > +		return -ENOMEM;
> 
> Use devm_kzalloc(), it saves all the unwinding code.

Changed kzalloc to devm_kzalloc

> 
> > +/* All register addresses */
> > +#define TPS65217_REG_CHIPID		0X00
> 
> You should verify this as part of the probe() routine - read it back to
> make sure it's what's expected, and log the chip revision too in case it
> is useful for diagnostics.
> 

Added chip verification code to mfd probe and printing the regulator ID &
version number.

Thanks
AnilKumar
