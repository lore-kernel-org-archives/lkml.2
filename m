Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab0IQWqM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 18:46:12 -0400
Received: from kroah.org ([198.145.64.141]:35288 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753955Ab0IQWqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 18:46:11 -0400
Date: Fri, 17 Sep 2010 15:44:16 -0700
From: Greg KH <greg@kroah.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Minkyu Kang <mk7.kang@samsung.com>, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, kyungmin.park@samsung.com
Subject: Re: [PATCH] misc: adds support the FSA9480 USB Switch
Message-ID: <20100917224416.GB22684@kroah.com>
References: <4C7CD95A.5040309@samsung.com>
 <20100917150731.f1f44f3c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100917150731.f1f44f3c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 17, 2010 at 03:07:31PM -0700, Andrew Morton wrote:
> > +static ssize_t fsa9480_show_status(struct device *dev,
> > +				   struct device_attribute *attr,
> > +				   char *buf)
> > +{
> > +	struct fsa9480_usbsw *usbsw = dev_get_drvdata(dev);
> > +	struct i2c_client *client = usbsw->client;
> > +	int devid, ctrl, adc, dev1, dev2, intr,
> > +	    intmask1, intmask2, time1, time2, mansw1;
> > +
> > +	devid = fsa9480_read_reg(client, FSA9480_REG_DEVID);
> > +	ctrl = fsa9480_read_reg(client, FSA9480_REG_CTRL);
> > +	adc = fsa9480_read_reg(client, FSA9480_REG_ADC);
> > +	intmask1 = fsa9480_read_reg(client, FSA9480_REG_INT1_MASK);
> > +	intmask2 = fsa9480_read_reg(client, FSA9480_REG_INT2_MASK);
> > +	dev1 = fsa9480_read_reg(client, FSA9480_REG_DEV_T1);
> > +	dev2 = fsa9480_read_reg(client, FSA9480_REG_DEV_T2);
> > +	time1 = fsa9480_read_reg(client, FSA9480_REG_TIMING1);
> > +	time2 = fsa9480_read_reg(client, FSA9480_REG_TIMING2);
> > +	mansw1 = fsa9480_read_reg(client, FSA9480_REG_MANSW1);
> > +
> > +	fsa9480_read_irq(client, &intr);
> > +
> > +	return sprintf(buf, "Device ID(%02x), CTRL(%02x)\n"
> > +			"ADC(%02x), DEV_T1(%02x), DEV_T2(%02x)\n"
> > +			"INT(%04x), INTMASK(%02x, %02x)\n"
> > +			"TIMING(%02x, %02x), MANSW1(%02x)\n",
> > +			devid, ctrl, adc, dev1, dev2, intr,
> > +			intmask1, intmask2, time1, time2, mansw1);
> > +}
> 
> That's will produce odd-looking output I suspect.  More conventional
> would be
> 
> 	Device ID:%02x CTRL:%02x
> 
> or something like that.
> 
> But that result is basically unparseable by software and a better output
> would be
> 
> Device_ID: %02x
> CTRL: %02x
> ADC: %02x
> 
> etc.
> 
> But even that violates the sysfs one-value-per-file guideline.
> 
> So this interface is problematic.  It should have been discussed
> up-front in the changelog so we can all take a look at the proposal and
> have a think about it.

Yes, such a sysfs file is not allowed, please just have individual sysfs
files for these attribute types (device id, control, adc, etc.)

And are you sure they are even needed?  Some of those are already known
through the i2c interface, right?

thanks,

greg k-h
